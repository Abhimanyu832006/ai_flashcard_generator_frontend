<?php
require_once "../config/database.php";

echo json_encode([
    "status" => "success",
    "message" => "Database connected successfully"
]);
