<?php
header("Content-Type: application/json");

require_once __DIR__ . "/../../config/database.php";
require_once __DIR__ . "/../../utils/response.php";

// Auth
$headers = getallheaders();
$token = $headers["Authorization"] ?? "";

if ($token === "") {
    sendResponse("error", "Unauthorized", null, 401);
}

$stmt = $pdo->prepare(
    "SELECT id FROM users WHERE auth_token = ? LIMIT 1"
);
$stmt->execute([$token]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    sendResponse("error", "Invalid token", null, 401);
}

// Input
$setId = $_GET["set_id"] ?? null;
if (!$setId) {
    sendResponse("error", "set_id required", null, 400);
}

// Verify ownership
$stmt = $pdo->prepare("
  SELECT id FROM flashcard_sets
  WHERE id = ? AND user_id = ?
");
$stmt->execute([$setId, $user["id"]]);

if (!$stmt->fetch()) {
    sendResponse("error", "Access denied", null, 403);
}

// Fetch flashcards
$stmt = $pdo->prepare("
  SELECT question, answer
  FROM flashcards
  WHERE set_id = ?
");
$stmt->execute([$setId]);

$flashcards = $stmt->fetchAll(PDO::FETCH_ASSOC);

sendResponse("success", "Flashcards fetched", [
  "flashcards" => $flashcards
]);
