<?php

header("Content-Type: application/json");

require_once __DIR__ . "/../../config/database.php";
require_once __DIR__ . "/../../utils/response.php";
require_once __DIR__ . "/../../utils/validator.php";


$raw = file_get_contents("php://input");
$input = json_decode($raw, true);

if (!$input) {
    sendResponse("error", "Invalid JSON body", null, 400);
}

$name = trim($input["name"] ?? "");
$email = trim($input["email"] ?? "");
$password = $input["password"] ?? "";

if ($name === "" || $email === "" || $password === "") {
    sendResponse("error", "All fields are required", null, 400);
}

if (!isEmailValid($email)) {
    sendResponse("error", "Invalid email format", null, 400);
}

if (!isPasswordStrong($password)) {
    sendResponse("error", "Password must be at least 6 characters", null, 400);
}

$stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);

if ($stmt->rowCount() > 0) {
    sendResponse("error", "Email already registered", null, 409);
}

$passwordHash = password_hash($password, PASSWORD_DEFAULT);

$stmt = $pdo->prepare(
    "INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)"
);
$stmt->execute([$name, $email, $passwordHash]);

sendResponse("success", "User registered successfully");