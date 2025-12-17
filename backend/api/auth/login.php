<?php

header("Content-Type: application/json");

require_once __DIR__ . "/../../config/database.php";
require_once __DIR__ . "/../../utils/response.php";

// Read JSON body
$input = json_decode(file_get_contents("php://input"), true);

if (!$input) {
    sendResponse("error", "Invalid JSON body", null, 400);
}

$email = trim($input["email"] ?? "");
$password = $input["password"] ?? "";

if ($email === "" || $password === "") {
    sendResponse("error", "Email and password required", null, 400);
}

// Fetch user
$stmt = $pdo->prepare(
    "SELECT id, name, email, password_hash FROM users WHERE email = ? LIMIT 1"
);
$stmt->execute([$email]);

$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    sendResponse("error", "Invalid credentials", null, 401);
}

// Verify password
if (!password_verify($password, $user["password_hash"])) {
    sendResponse("error", "Invalid credentials", null, 401);
}

// Login success
// Generate token
$token = bin2hex(random_bytes(32));

// Save token in DB
$update = $pdo->prepare(
    "UPDATE users SET auth_token = ? WHERE id = ?"
);
$update->execute([$token, $user["id"]]);

sendResponse(
    "success",
    "Login successful",
    [
        "token" => $token,
        "user" => [
            "id" => $user["id"],
            "name" => $user["name"],
            "email" => $user["email"]
        ]
    ]
);

