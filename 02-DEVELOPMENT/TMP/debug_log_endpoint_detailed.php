<?php
/**
 * DEBUG DETALHADO - log_endpoint.php
 * Captura TODAS as informações da requisição para diagnóstico
 */

// Desabilitar output buffering
if (ob_get_level()) {
    ob_end_clean();
}

// Headers para debug
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Responder OPTIONS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit(0);
}

// Arquivo de log de debug
$debugLogFile = '/tmp/log_endpoint_debug_' . date('Y-m-d') . '.log';

function debugLog($message, $data = null) {
    global $debugLogFile;
    $entry = [
        'timestamp' => date('Y-m-d H:i:s.u'),
        'message' => $message,
        'data' => $data
    ];
    file_put_contents($debugLogFile, json_encode($entry, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) . PHP_EOL, FILE_APPEND | LOCK_EX);
}

// Capturar informações da requisição
$requestInfo = [
    'method' => $_SERVER['REQUEST_METHOD'] ?? 'NOT_SET',
    'uri' => $_SERVER['REQUEST_URI'] ?? 'NOT_SET',
    'query_string' => $_SERVER['QUERY_STRING'] ?? 'NOT_SET',
    'content_type' => $_SERVER['CONTENT_TYPE'] ?? 'NOT_SET',
    'content_length' => $_SERVER['CONTENT_LENGTH'] ?? 'NOT_SET',
    'request_method' => $_SERVER['REQUEST_METHOD'] ?? 'NOT_SET',
    'remote_addr' => $_SERVER['REMOTE_ADDR'] ?? 'NOT_SET',
    'http_user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'NOT_SET',
    'http_origin' => $_SERVER['HTTP_ORIGIN'] ?? 'NOT_SET',
    'http_referer' => $_SERVER['HTTP_REFERER'] ?? 'NOT_SET',
];

debugLog('REQUEST_START', $requestInfo);

// Tentar ler php://input
$phpInput = null;
$phpInputLength = 0;
$phpInputError = null;

try {
    $phpInput = file_get_contents('php://input');
    $phpInputLength = strlen($phpInput);
    debugLog('PHP_INPUT_READ', [
        'length' => $phpInputLength,
        'preview' => substr($phpInput, 0, 500),
        'is_empty' => empty($phpInput),
        'is_null' => is_null($phpInput)
    ]);
} catch (Exception $e) {
    $phpInputError = $e->getMessage();
    debugLog('PHP_INPUT_ERROR', ['error' => $phpInputError]);
}

// Tentar decodificar JSON
$jsonData = null;
$jsonError = null;

if ($phpInput) {
    $jsonData = json_decode($phpInput, true);
    $jsonError = json_last_error();
    $jsonErrorMsg = json_last_error_msg();
    
    debugLog('JSON_DECODE', [
        'success' => $jsonData !== null,
        'error_code' => $jsonError,
        'error_message' => $jsonErrorMsg,
        'decoded_keys' => $jsonData ? array_keys($jsonData) : null,
        'decoded_preview' => $jsonData ? json_encode(array_slice($jsonData, 0, 3), JSON_UNESCAPED_UNICODE) : null
    ]);
}

// Verificar se ProfessionalLogger existe
$loggerExists = file_exists(__DIR__ . '/ProfessionalLogger.php');
debugLog('PROFESSIONAL_LOGGER_CHECK', [
    'exists' => $loggerExists,
    'path' => __DIR__ . '/ProfessionalLogger.php',
    'readable' => $loggerExists ? is_readable(__DIR__ . '/ProfessionalLogger.php') : false
]);

// Tentar carregar ProfessionalLogger
$loggerLoaded = false;
$loggerError = null;

if ($loggerExists) {
    try {
        require_once __DIR__ . '/ProfessionalLogger.php';
        $loggerLoaded = true;
        debugLog('PROFESSIONAL_LOGGER_LOADED', ['success' => true]);
    } catch (Exception $e) {
        $loggerError = $e->getMessage();
        debugLog('PROFESSIONAL_LOGGER_LOAD_ERROR', [
            'error' => $loggerError,
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);
    } catch (Error $e) {
        $loggerError = $e->getMessage();
        debugLog('PROFESSIONAL_LOGGER_LOAD_FATAL', [
            'error' => $loggerError,
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);
    }
}

// Tentar criar instância do logger
$loggerInstance = null;
$loggerInstanceError = null;

if ($loggerLoaded) {
    try {
        $loggerInstance = new ProfessionalLogger();
        debugLog('PROFESSIONAL_LOGGER_INSTANCE', ['success' => true]);
    } catch (Exception $e) {
        $loggerInstanceError = $e->getMessage();
        debugLog('PROFESSIONAL_LOGGER_INSTANCE_ERROR', [
            'error' => $loggerInstanceError,
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);
    } catch (Error $e) {
        $loggerInstanceError = $e->getMessage();
        debugLog('PROFESSIONAL_LOGGER_INSTANCE_FATAL', [
            'error' => $loggerInstanceError,
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);
    }
}

// Verificar rate limiting
$rateLimitInfo = null;
$rateLimitError = null;

try {
    $clientIP = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    $rateLimitFile = sys_get_temp_dir() . '/log_rate_limit_' . md5($clientIP) . '.tmp';
    $rateLimitInfo = [
        'ip' => $clientIP,
        'file' => $rateLimitFile,
        'exists' => file_exists($rateLimitFile),
        'readable' => file_exists($rateLimitFile) ? is_readable($rateLimitFile) : false,
        'writable' => is_writable(sys_get_temp_dir())
    ];
    
    if (file_exists($rateLimitFile)) {
        $fileContent = file_get_contents($rateLimitFile);
        $rateLimitInfo['content'] = $fileContent;
        $rateLimitInfo['content_length'] = strlen($fileContent);
        $rateLimitData = json_decode($fileContent, true);
        $rateLimitInfo['json_decode_success'] = $rateLimitData !== null;
        $rateLimitInfo['json_decode_error'] = json_last_error_msg();
        $rateLimitInfo['decoded_data'] = $rateLimitData;
        $rateLimitInfo['is_array'] = is_array($rateLimitData);
        $rateLimitInfo['has_first_request'] = is_array($rateLimitData) && isset($rateLimitData['first_request']);
    }
    
    debugLog('RATE_LIMIT_CHECK', $rateLimitInfo);
} catch (Exception $e) {
    $rateLimitError = $e->getMessage();
    debugLog('RATE_LIMIT_ERROR', ['error' => $rateLimitError]);
}

// Resposta de debug
$response = [
    'success' => true,
    'debug' => true,
    'request_info' => $requestInfo,
    'php_input' => [
        'length' => $phpInputLength,
        'preview' => substr($phpInput, 0, 200),
        'is_empty' => empty($phpInput),
        'error' => $phpInputError
    ],
    'json_decode' => [
        'success' => $jsonData !== null,
        'error_code' => $jsonError,
        'error_message' => $jsonErrorMsg ?? null,
        'data' => $jsonData
    ],
    'professional_logger' => [
        'file_exists' => $loggerExists,
        'loaded' => $loggerLoaded,
        'instance_created' => $loggerInstance !== null,
        'errors' => [
            'load' => $loggerError,
            'instance' => $loggerInstanceError
        ]
    ],
    'rate_limit' => [
        'info' => $rateLimitInfo,
        'error' => $rateLimitError
    ],
    'environment' => [
        'php_version' => PHP_VERSION,
        'error_reporting' => error_reporting(),
        'display_errors' => ini_get('display_errors'),
        'log_errors' => ini_get('log_errors'),
        'error_log' => ini_get('error_log'),
        'sys_temp_dir' => sys_get_temp_dir(),
        'tmp_writable' => is_writable(sys_get_temp_dir())
    ],
    'debug_log_file' => $debugLogFile
];

http_response_code(200);
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);

