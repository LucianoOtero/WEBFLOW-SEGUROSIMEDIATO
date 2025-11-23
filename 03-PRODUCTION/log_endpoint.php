<?php
/**
 * log_endpoint.php - Endpoint de Logging Profissional
 * Versão: 1.3.0
 * Data: 2025-11-11
 * 
 * Recebe logs via POST JSON e armazena no banco de dados
 * com captura automática de arquivo, linha e contexto completo
 * 
 * CORREÇÕES APLICADAS:
 * - Warnings de REQUEST_METHOD corrigidos
 * - Bug do rate limiting corrigido
 * - Logging detalhado adicionado
 * - Tratamento de erros melhorado
 * - CORS corrigido: usando setCorsHeaders() do config.php (v1.2.0)
 */

// Incluir config.php ANTES de qualquer header ou logDebug() para usar setCorsHeaders()
require_once __DIR__ . '/config.php';

// Função auxiliar para logging em arquivo txt (sem banco de dados, sem referências circulares)
function logDebug($message, $data = null) {
    // getBaseDir() já está disponível via config.php incluído acima
    $logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
    $logFile = rtrim($logDir, '/\\') . '/log_endpoint_debug.txt';
    $timestamp = date('Y-m-d H:i:s.u');
    $memory = memory_get_usage(true);
    $peakMemory = memory_get_peak_usage(true);
    
    $logLine = sprintf(
        "[%s] %s | Memory: %s | Peak: %s",
        $timestamp,
        $message,
        number_format($memory, 0, ',', '.') . ' bytes',
        number_format($peakMemory, 0, ',', '.') . ' bytes'
    );
    
    if ($data !== null) {
        $logLine .= " | Data: " . json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }
    
    $logLine .= PHP_EOL;
    
    // Tentar gravar no arquivo principal - SEM fallback
    if (!@file_put_contents($logFile, $logLine, FILE_APPEND | LOCK_EX)) {
        error_log("log_endpoint.php: ERRO CRÍTICO - Não foi possível gravar log em: $logFile");
        throw new RuntimeException("Não foi possível gravar log em: $logFile");
    }
    
    // SEMPRE logar também no error_log do PHP para garantir que seja capturado
    error_log("log_endpoint_debug: " . trim($logLine));
}

// Função para ler últimos erros do error_log do PHP relacionados ao ProfessionalLogger
function getRecentProfessionalLoggerErrors($lines = 10) {
    $errorLogPath = ini_get('error_log');
    if (empty($errorLogPath) || !file_exists($errorLogPath)) {
        // Tentar caminhos comuns
        $commonPaths = [
            '/var/log/php/error.log',
            '/var/log/php-fpm/error.log',
            '/var/log/php_errors.log'
        ];
        foreach ($commonPaths as $path) {
            if (file_exists($path)) {
                $errorLogPath = $path;
                break;
            }
        }
    }
    
    if (empty($errorLogPath) || !file_exists($errorLogPath)) {
        return ['error' => 'Error log file not found'];
    }
    
    // Ler últimas linhas do arquivo (aumentar para pegar mais contexto)
    $command = sprintf("tail -n %d '%s' 2>/dev/null | grep -i 'ProfessionalLogger' | tail -n %d", $lines * 10, $errorLogPath, $lines);
    $output = [];
    $returnCode = 0;
    @exec($command, $output, $returnCode);
    
    // Se não encontrar nada, tentar ler as últimas linhas do arquivo diretamente
    if (empty($output)) {
        $command2 = sprintf("tail -n %d '%s' 2>/dev/null", $lines * 5, $errorLogPath);
        @exec($command2, $allLines, $returnCode2);
        $output = array_slice($allLines, -$lines);
    }
    
    return [
        'error_log_path' => $errorLogPath,
        'recent_errors' => $output,
        'count' => count($output),
        'command_used' => $command
    ];
}

// Capturar todos os erros e warnings
set_error_handler(function($errno, $errstr, $errfile, $errline) {
    logDebug("PHP Error/Warning captured", [
        'errno' => $errno,
        'errstr' => $errstr,
        'errfile' => $errfile,
        'errline' => $errline,
        'backtrace' => debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 5)
    ]);
    return false; // Continuar processamento normal
});

// Headers CORS (usar função do config.php para evitar duplicação com Nginx)
// IMPORTANTE: Headers devem ser enviados ANTES de qualquer output (incluindo logs)
// Isso evita erro 502 "upstream sent too big header" no Nginx
header('Content-Type: application/json');
// Usar setCorsHeaders() do config.php - valida origem e envia apenas um valor no header
setCorsHeaders();
// Adicionar headers específicos do log_endpoint.php após setCorsHeaders()
header('Access-Control-Allow-Headers: Content-Type, X-API-Key, X-Client-Timestamp, X-Webflow-Signature, X-Webflow-Timestamp, X-Requested-With, Authorization');

// Logging DEPOIS dos headers (corrige erro 502 Bad Gateway)
logDebug("Starting request", [
    'method' => $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN',
    'uri' => $_SERVER['REQUEST_URI'] ?? 'UNKNOWN',
    'ip' => $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN'
]);

// Nota: setCorsHeaders() já trata requisições OPTIONS (preflight) e envia os headers corretos
// Não é necessário código adicional para OPTIONS

// Verificar método HTTP
if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'error' => 'Method not allowed',
        'method' => $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN'
    ]);
    exit;
}

// Incluir classe ProfessionalLogger
logDebug("Loading ProfessionalLogger.php", ['path' => __DIR__ . '/ProfessionalLogger.php']);
try {
    $loggerPath = __DIR__ . '/ProfessionalLogger.php';
    if (!file_exists($loggerPath)) {
        throw new Exception("ProfessionalLogger.php not found at: $loggerPath");
    }
    require_once $loggerPath;
    logDebug("ProfessionalLogger.php loaded successfully");
} catch (Exception $e) {
    logDebug("Exception loading ProfessionalLogger", [
        'message' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString()
    ]);
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Failed to load ProfessionalLogger',
        'message' => $e->getMessage(),
        'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
            'file' => basename($e->getFile()),
            'line' => $e->getLine()
        ] : null)
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
} catch (Error $e) {
    logDebug("Fatal error loading ProfessionalLogger", [
        'message' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString()
    ]);
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Failed to load ProfessionalLogger',
        'message' => $e->getMessage(),
        'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
            'file' => basename($e->getFile()),
            'line' => $e->getLine()
        ] : null)
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

try {
    // Logging detalhado para diagnóstico
    $requestStartTime = microtime(true);
    $requestId = uniqid('req_', true);
    
    logDebug("Request started", [
        'request_id' => $requestId,
        'method' => $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN',
        'ip' => $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN',
        'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'UNKNOWN',
        'content_type' => $_SERVER['CONTENT_TYPE'] ?? 'UNKNOWN',
        'content_length' => $_SERVER['CONTENT_LENGTH'] ?? 'UNKNOWN'
    ]);
    
    // Ler dados JSON
    logDebug("Reading input stream");
    $rawInput = file_get_contents('php://input');
    logDebug("Raw input received", [
        'length' => strlen($rawInput),
        'preview' => substr($rawInput, 0, 200)
    ]);
    
    $input = json_decode($rawInput, true);
    $jsonError = json_last_error();
    
    if (!$input || $jsonError !== JSON_ERROR_NONE) {
        logDebug("Invalid JSON input", [
            'json_error' => $jsonError,
            'json_error_msg' => json_last_error_msg(),
            'raw_input_preview' => substr($rawInput, 0, 500)
        ]);
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'error' => 'Invalid JSON input',
            'details' => json_last_error_msg(),
            'json_error_code' => $jsonError
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
    
    // Log após validação de JSON
    logDebug("JSON validated", [
        'request_id' => $requestId,
        'level' => $input['level'] ?? 'N/A',
        'message_length' => strlen($input['message'] ?? ''),
        'has_data' => isset($input['data']),
        'has_category' => isset($input['category']),
        'input_keys' => array_keys($input)
    ]);
    
    // Validar campos obrigatórios
    $missingFields = [];
    if (!isset($input['level']) || $input['level'] === null || $input['level'] === '') {
        $missingFields[] = 'level';
    }
    if (!isset($input['message']) || $input['message'] === null || $input['message'] === '') {
        $missingFields[] = 'message';
    }
    
    if (!empty($missingFields)) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'error' => 'Missing required fields',
            'missing_fields' => $missingFields,
            'required' => ['level', 'message'],
            'received' => [
                'level' => $input['level'] ?? 'NOT_SET',
                'message' => isset($input['message']) ? (is_string($input['message']) ? substr($input['message'], 0, 50) : gettype($input['message'])) : 'NOT_SET'
            ],
            'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
                'input_keys' => array_keys($input),
                'level_type' => isset($input['level']) ? gettype($input['level']) : 'NOT_SET',
                'message_type' => isset($input['message']) ? gettype($input['message']) : 'NOT_SET'
            ] : null)
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
    
    // Validar nível
    $validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE'];
    $level = is_string($input['level']) ? strtoupper(trim($input['level'])) : '';
    if (empty($level) || !in_array($level, $validLevels)) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'error' => 'Invalid level',
            'valid_levels' => $validLevels,
            'received_level' => $input['level'],
            'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
                'level_type' => gettype($input['level']),
                'level_value' => $input['level']
            ] : null)
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
    
    // FASE 7: Verificar parametrização NO INÍCIO (após validação de nível)
    // Carregar LogConfig (já está disponível via ProfessionalLogger.php)
    $category = $input['category'] ?? null;
    
    // Verificar se deve logar
    if (!LogConfig::shouldLog($level, $category)) {
        // Retornar 200 OK mas não processar requisição (conforme especificação)
        logDebug("Log request ignored due to parametrization", [
            'level' => $level,
            'category' => $category,
            'reason' => 'LogConfig::shouldLog() returned false'
        ]);
        http_response_code(200);
        echo json_encode([
            'success' => true,
            'log_id' => null,
            'request_id' => null,
            'timestamp' => date('Y-m-d H:i:s.u'),
            'inserted' => false,
            'reason' => 'Logging disabled by configuration'
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
    
    // Rate limiting simples (por IP) - com tratamento robusto de erros
    $clientIP = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    $rateLimitFile = sys_get_temp_dir() . '/log_rate_limit_' . md5($clientIP) . '.tmp';
    $now = time();
    $window = 60; // 1 minuto
    $maxRequests = 100; // máximo 100 requests por minuto
    
    $rateLimitData = null;
    
    if (file_exists($rateLimitFile)) {
        $fileContent = file_get_contents($rateLimitFile);
        $rateLimitData = json_decode($fileContent, true);
        
        // Validar dados do rate limit
        if (!is_array($rateLimitData) || !isset($rateLimitData['first_request']) || !isset($rateLimitData['count'])) {
            // Arquivo corrompido, vazio ou inválido - recriar
            logDebug("Rate limit file corrupted or invalid, recreating", ['file' => $rateLimitFile]);
            $rateLimitData = ['first_request' => $now, 'count' => 1];
        } else if ($now - $rateLimitData['first_request'] < $window) {
            // Janela ainda válida
            if ($rateLimitData['count'] >= $maxRequests) {
                http_response_code(429);
                echo json_encode([
                    'success' => false,
                    'error' => 'Rate limit exceeded',
                    'retry_after' => $window - ($now - $rateLimitData['first_request'])
                ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
                exit;
            }
            $rateLimitData['count']++;
        } else {
            // Janela expirou - resetar
            $rateLimitData = ['first_request' => $now, 'count' => 1];
        }
    } else {
        // Arquivo não existe - criar
        $rateLimitData = ['first_request' => $now, 'count' => 1];
    }
    
    // Salvar dados do rate limit com lock para evitar race conditions
    file_put_contents($rateLimitFile, json_encode($rateLimitData), LOCK_EX);
    
    // Log após rate limiting
    logDebug("Rate limit checked", [
        'request_id' => $requestId,
        'count' => $rateLimitData['count'] ?? 'N/A',
        'first_request' => $rateLimitData['first_request'] ?? 'N/A'
    ]);
    
    // Criar instância do logger
    logDebug("Creating ProfessionalLogger instance");
    try {
        $logger = new ProfessionalLogger();
        logDebug("ProfessionalLogger instance created", [
            'request_id' => $logger->getRequestId()
        ]);
    } catch (Exception $e) {
        logDebug("Exception creating ProfessionalLogger", [
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'Failed to create logger instance',
            'message' => $e->getMessage(),
            'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
                'file' => basename($e->getFile()),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ] : null)
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    } catch (Error $e) {
        logDebug("Fatal error creating ProfessionalLogger", [
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'Failed to create logger instance',
            'message' => $e->getMessage(),
            'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
                'file' => basename($e->getFile()),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ] : null)
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
    
    // Preparar dados (category já foi definido acima na verificação de parametrização)
    $message = $input['message'];
    $data = $input['data'] ?? null;
    // $category já definido acima na verificação de parametrização
    $stackTrace = $input['stack_trace'] ?? null;
    
    // Se houver exceção, capturar stack trace
    if (isset($input['exception']) && is_array($input['exception'])) {
        $stackTrace = $input['exception']['trace'] ?? $stackTrace;
    }
    
    // Se o JavaScript enviou informações de arquivo/linha, usar essas informações
    // (sobrescreve a captura automática do PHP que capturaria log_endpoint.php)
    $jsFileInfo = null;
    if (isset($input['file_name']) || isset($input['line_number'])) {
        $jsFileInfo = [
            'file_name' => $input['file_name'] ?? null,
            'file_path' => $input['file_path'] ?? null,
            'line_number' => isset($input['line_number']) ? (int)$input['line_number'] : null,
            'function_name' => $input['function_name'] ?? null
        ];
    }
    
    // Registrar log (passar informações do JS se disponíveis)
    logDebug("Calling logger->log()", [
        'level' => $level,
        'message_length' => strlen($message),
        'message_preview' => substr($message, 0, 200),
        'has_data' => $data !== null,
        'data_type' => $data !== null ? gettype($data) : null,
        'data_size' => $data !== null ? (is_string($data) ? strlen($data) : (is_array($data) ? count($data) : 'N/A')) : null,
        'has_category' => $category !== null,
        'category' => $category,
        'has_stack_trace' => $stackTrace !== null,
        'stack_trace_length' => $stackTrace !== null ? strlen($stackTrace) : 0,
        'has_js_file_info' => $jsFileInfo !== null,
        'js_file_info' => $jsFileInfo
    ]);
    
    try {
        $logStartTime = microtime(true);
        $logId = $logger->log($level, $message, $data, $category, $stackTrace, $jsFileInfo);
        $logDuration = microtime(true) - $logStartTime;
        logDebug("logger->log() returned", [
            'log_id' => $logId,
            'duration_ms' => round($logDuration * 1000, 2),
            'return_type' => gettype($logId),
            'is_false' => ($logId === false)
        ]);
    } catch (Exception $e) {
        logDebug("Exception in logger->log()", [
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);
        throw $e;
    } catch (Error $e) {
        logDebug("Fatal error in logger->log()", [
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);
        throw $e;
    }
    
    if ($logId === false) {
        // Logar motivo da falha para diagnóstico
        logDebug("Logger returned false - investigating", [
            'level' => $level,
            'message' => substr($message, 0, 100),
            'message_length' => strlen($message),
            'has_data' => $data !== null,
            'data_type' => $data !== null ? gettype($data) : null,
            'data_size' => $data !== null ? (is_string($data) ? strlen($data) : (is_array($data) ? count($data) : 'N/A')) : null
        ]);
        
        // Verificar status da conexão (para debug)
        try {
            $connection = $logger->getConnection();
            $connectionStatus = $connection !== null ? 'connected' : 'disconnected';
            logDebug("Database connection status", ['status' => $connectionStatus]);
            
            // Se conectado, tentar uma query simples para verificar
            if ($connection !== null) {
                try {
                    $testQuery = $connection->query('SELECT 1');
                    logDebug("Database connection test query", ['success' => $testQuery !== false]);
                } catch (Exception $e) {
                    logDebug("Database connection test query failed", [
                        'message' => $e->getMessage(),
                        'code' => $e->getCode()
                    ]);
                }
            }
        } catch (Exception $e) {
            logDebug("Exception getting connection", [
                'message' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'code' => $e->getCode()
            ]);
            $connectionStatus = 'error';
        }
        
        // Verificar últimos logs de erro do ProfessionalLogger
        logDebug("Checking recent ProfessionalLogger error logs");
        $recentErrors = getRecentProfessionalLoggerErrors(5);
        logDebug("Recent ProfessionalLogger errors from error_log", $recentErrors);
        
        // Tentar obter mais informações sobre o erro
        try {
            // Verificar se há algum método para obter último erro
            if (method_exists($logger, 'getLastError')) {
                $lastErrorMethod = 'getLastError';
                $lastError = $logger->$lastErrorMethod();
                logDebug("Logger last error (via getLastError)", $lastError);
            }
        } catch (Exception $e) {
            logDebug("Exception getting last error from logger", [
                'message' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]);
        }
        
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'Failed to insert log',
            'message' => 'Database insertion failed',
            'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
                'connection_status' => $connectionStatus,
                'possible_causes' => [
                    'Database connection failed',
                    'Insert query failed',
                    'PDO exception occurred',
                    'Database timeout',
                    'Deadlock occurred',
                    'Data too long for column',
                    'Duplicate entry (log_id already exists)',
                    'SQL syntax error',
                    'Table locked'
                ],
                'timestamp' => date('Y-m-d H:i:s.u'),
                'request_id' => $requestId,
                'log_data_info' => [
                    'level' => $level,
                    'message_length' => strlen($message),
                    'has_data' => $data !== null,
                    'has_category' => $category !== null,
                    'has_stack_trace' => $stackTrace !== null
                ]
            ] : null)
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
    
    // Log após inserção bem-sucedida
    $requestDuration = microtime(true) - $requestStartTime;
    logDebug("Request completed successfully", [
        'request_id' => $requestId,
        'log_id' => $logId,
        'duration_ms' => round($requestDuration * 1000, 2),
        'memory_usage' => memory_get_usage(true),
        'peak_memory' => memory_get_peak_usage(true)
    ]);
    
    // Resposta de sucesso
    logDebug("Sending success response");
    http_response_code(200);
    $response = [
        'success' => true,
        'log_id' => $logId,
        'request_id' => $logger->getRequestId(),
        'timestamp' => date('Y-m-d H:i:s.u'),
        'inserted' => true
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    logDebug("Response sent");
    
} catch (Exception $e) {
    // Log de erro interno com detalhes completos
    $errorDetails = [
        'message' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString(),
        'code' => $e->getCode(),
        'previous' => $e->getPrevious() ? get_class($e->getPrevious()) : null
    ];
    logDebug("Exception caught in main try-catch", $errorDetails);
    
    // Resposta de erro (sem expor detalhes sensíveis em produção)
    http_response_code(500);
    $response = [
        'success' => false,
        'error' => 'Internal server error',
        'message' => 'An error occurred while processing the log',
        // Em desenvolvimento, incluir mais detalhes para debug
        'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
            'exception' => get_class($e),
            'message' => $e->getMessage(),
            'file' => basename($e->getFile()),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ] : null)
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    logDebug("Error response sent");
} catch (Error $e) {
    // Capturar erros fatais do PHP 7+
    $errorDetails = [
        'message' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString(),
        'code' => $e->getCode(),
        'previous' => $e->getPrevious() ? get_class($e->getPrevious()) : null
    ];
    logDebug("Fatal error caught in main try-catch", $errorDetails);
    
    http_response_code(500);
    $response = [
        'success' => false,
        'error' => 'Internal server error',
        'message' => 'A fatal error occurred while processing the log',
        'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
            'error' => get_class($e),
            'message' => $e->getMessage(),
            'file' => basename($e->getFile()),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ] : null)
    ];
    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    logDebug("Fatal error response sent");
} catch (Throwable $e) {
    // Capturar qualquer outro tipo de erro
    logDebug("Throwable caught (unexpected error type)", [
        'class' => get_class($e),
        'message' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString()
    ]);
    
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Internal server error',
        'message' => 'An unexpected error occurred',
        'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
            'error_type' => get_class($e),
            'message' => $e->getMessage()
        ] : null)
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}

