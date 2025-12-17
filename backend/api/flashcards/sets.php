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

// Fetch sets
$stmt = $pdo->prepare("
  SELECT id, title, created_at
  FROM flashcard_sets
  WHERE user_id = ?
  ORDER BY created_at DESC
");
$stmt->execute([$user["id"]]);

$sets = $stmt->fetchAll(PDO::FETCH_ASSOC);

sendResponse("success", "Sets fetched", [
  "sets" => $sets
]);
