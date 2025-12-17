<?php

function sendResponse($status, $message, $data = null, $code = 200) {
    http_response_code($code);

    $response = [
        "status" => $status,
        "message" => $message
    ];

    if ($data !== null) {
        $response["data"] = $data;
    }

    echo json_encode($response);
    exit;
}
