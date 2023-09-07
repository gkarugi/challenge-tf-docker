<?php

require "./bootstrap.php";

use Src\ApiHandler;

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: OPTIONS,GET,POST,PUT,DELETE");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$token = 'token';

if (isset($_SERVER["HTTP_X_API_KEY"])) {
    $token = $_SERVER["HTTP_X_API_KEY"];
} else {
    header("HTTP/1.1 401 Unauthorized");
    
    header("Content-Type: application/json");
    echo json_encode([
        'code' => 401,
        'message' => '401 unauthorized'
    ]);

    exit();
}

$uri = explode( 
    '/',
    parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH)
);

// return 404 Not Found if any requested endpoint doesn't start with start with /api
if ((isset($uri[1]) && $uri[1] != 'api')) {
    header("HTTP/1.1 404 Not Found");
    
    header("Content-Type: application/json");
    echo json_encode([
        'code' => 404,
        'message' => '404 not found'
    ]);

    exit();
}

match ($_SERVER['REQUEST_METHOD']) {
    'GET' => call_user_func(function() use($uri) {
        match ($uri[2]) {
            'avg-server-load' => call_user_func(function() {
                $stats = ApiHandler::getServerStats();

                header("Content-Type: application/json");
                echo json_encode($stats);
                exit();
            }),
            'return-value-key'=> call_user_func(function() {
                $json = json_decode(file_get_contents('./assets/tech_assess.json'), true);
                echo $json['tech']['return_value'];
                exit;
            }),
            default => call_user_func(function() {
                header("HTTP/1.1 404 Not Found");
                header("Content-Type: application/json");
                echo json_encode([
                    'code' => 404,
                    'message' => '404 not found'
                ]);
                exit();
            })
        };
    }),
    'POST' =>  call_user_func(function() use($uri) {
        match ($uri[2]) {
            'update-value-key'=> call_user_func(function() {
                echo "todo update json file";
                // TODO: implement json file update
            }),
            default => call_user_func(function() {
                header("HTTP/1.1 404 Not Found");
                header("Content-Type: application/json");
                echo json_encode([
                    'code' => 404,
                    'message' => '404 not found'
                ]);
                exit();
            })
        };
    }),
    default => call_user_func(function() {
        header("HTTP/1.1 404 Not Found");
        header("Content-Type: application/json");
        echo json_encode([
            'code' => 404,
            'message' => '404 not found'
        ]);
        exit();
    }),
};