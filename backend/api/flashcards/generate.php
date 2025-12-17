<?php

header("Content-Type: application/json");

// 1. IMPORTS
require_once __DIR__ . "/../../config/database.php";
require_once __DIR__ . "/../../config/gemini.php";
require_once __DIR__ . "/../../utils/response.php";

// 2. AUTHENTICATION CHECK
$headers = getallheaders();
$token = $headers["Authorization"] ?? $_SERVER["HTTP_AUTHORIZATION"] ?? "";

if ($token === "") {
    sendResponse("error", "Unauthorized: No token provided", null, 401);
}

$stmt = $pdo->prepare("SELECT id FROM users WHERE auth_token = ? LIMIT 1");
$stmt->execute([$token]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    sendResponse("error", "Unauthorized: Invalid token", null, 401);
}

// 3. FILE UPLOAD CHECK
if (!isset($_FILES["file"])) {
    sendResponse("error", "No file uploaded", null, 400);
}

$file = $_FILES["file"];
$ext = strtolower(pathinfo($file["name"], PATHINFO_EXTENSION));

if ($ext !== "pdf") {
    sendResponse("error", "Only PDF files are supported", null, 400);
}

// 4. MOVE FILE
$uploadDir = __DIR__ . "/../../uploads/";
if (!is_dir($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

$pdfPath = $uploadDir . uniqid() . ".pdf";
if (!move_uploaded_file($file["tmp_name"], $pdfPath)) {
    sendResponse("error", "Failed to save uploaded file", null, 500);
}

// 5. TEXT EXTRACTION
$textPath = $uploadDir . uniqid() . ".txt";
$pdftotext = "C:/xpdf/bin64/pdftotext.exe"; // ⚠️ VERIFY THIS PATH MATCHES YOUR SYSTEM

$command = "\"$pdftotext\" \"$pdfPath\" \"$textPath\"";
exec($command);

if (!file_exists($textPath)) {
    sendResponse("error", "Text extraction failed", null, 500);
}

$rawText = file_get_contents($textPath);

// CLEAN TEXT ENCODING
$rawText = mb_convert_encoding($rawText, 'UTF-8', 'UTF-8');
$rawText = preg_replace('/[\x00-\x09\x0B\x0C\x0E-\x1F\x7F]/u', '', $rawText);
$rawText = trim($rawText);

if (strlen($rawText) < 50) {
    sendResponse("error", "PDF text too short or unreadable", null, 400);
}

// 6. CALL GEMINI API (UPDATED MODEL)
$prompt = "
You are an AI tutor.
From the following study material, generate exactly 5 flashcards.
Return ONLY valid JSON in this format:
{
  \"flashcards\": [
    {\"question\": \"Question text...\", \"answer\": \"Answer text...\"}
  ]
}

Study material:
" . substr($rawText, 0, 30000);

// ⚠️ CHANGED TO gemini-1.5-flash
$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" . GEMINI_API_KEY;
$requestBody = [
    "contents" => [
        [
            "parts" => [
                ["text" => $prompt]
            ]
        ]
    ]
];

$jsonPayload = json_encode($requestBody);

if ($jsonPayload === false) {
    sendResponse("error", "Failed to encode JSON payload", null, 500);
}

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonPayload);

$response = curl_exec($ch);

if (curl_errno($ch)) {
    sendResponse("error", "Curl Error: " . curl_error($ch), null, 500);
}
curl_close($ch);

$result = json_decode($response, true);

if (isset($result["error"])) {
    sendResponse("error", "Gemini API Error: " . $result["error"]["message"], null, 500);
}

if (!isset($result["candidates"][0]["content"]["parts"][0]["text"])) {
    sendResponse("error", "Gemini returned no content", ["raw" => $result], 500);
}

$jsonText = trim($result["candidates"][0]["content"]["parts"][0]["text"]);
$jsonText = preg_replace('/```json|```/', '', $jsonText);

$parsed = json_decode($jsonText, true);

if (!$parsed || !isset($parsed["flashcards"])) {
    sendResponse("error", "Invalid JSON from Gemini", ["raw" => $jsonText], 500);
}

$flashcards = $parsed["flashcards"];

// 7. DATABASE PERSISTENCE
try {
    $pdo->beginTransaction();

    // A. Set
    $stmt = $pdo->prepare("INSERT INTO flashcard_sets (user_id, title) VALUES (?, ?)");
    $stmt->execute([$user["id"], "Set from " . $file["name"]]);
    $setId = $pdo->lastInsertId();

    // B. File
    $stmt = $pdo->prepare("INSERT INTO flashcard_files (set_id, file_name, file_path) VALUES (?, ?, ?)");
    $stmt->execute([$setId, $file["name"], $pdfPath]);

    // C. Flashcards
    $stmt = $pdo->prepare("INSERT INTO flashcards (set_id, question, answer) VALUES (?, ?, ?)");
    foreach ($flashcards as $card) {
        $stmt->execute([$setId, $card["question"], $card["answer"]]);
    }

    $pdo->commit();

    sendResponse("success", "Flashcards generated and saved", [
        "set_id" => $setId,
        "flashcards" => $flashcards
    ]);

} catch (Exception $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    sendResponse("error", "Database Error: " . $e->getMessage(), null, 500);
}
?>