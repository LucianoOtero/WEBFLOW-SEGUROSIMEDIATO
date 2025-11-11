<?php
/**
 * ProfessionalLogger - Sistema de Logging Profissional
 * Versão: 1.0.0
 * Data: 2025-11-08
 * 
 * Classe para logging profissional com captura automática de:
 * - Arquivo e linha de código
 * - Stack trace
 * - Contexto completo da requisição
 * 
 * Uso:
 * $logger = new ProfessionalLogger();
 * $logger->info('Mensagem', ['data' => 'adicional']);
 */

class ProfessionalLogger {
    private $pdo = null;
    private $config = null;
    private $requestId = null;
    private $environment = null;
    
    /**
     * Construtor
     */
    public function __construct() {
        $this->requestId = uniqid('req_', true);
        $this->environment = $this->detectEnvironment();
        $this->loadConfig();
    }
    
    /**
     * Detectar ambiente (dev/prod)
     */
    private function detectEnvironment() {
        $env = $_ENV['PHP_ENV'] ?? 'development';
        return in_array(strtolower($env), ['production', 'prod']) ? 'production' : 'development';
    }
    
    /**
     * Carregar configuração do banco de dados
     */
    private function loadConfig() {
        // Detectar se está rodando em Docker
        $isDocker = file_exists('/.dockerenv');
        // Gateway padrão do Docker para acessar serviços no host
        // Tentar descobrir o gateway da rede Docker
        if ($isDocker) {
            // Tentar descobrir o gateway automaticamente
            $gateway = trim(shell_exec("ip route | grep default | awk '{print \$3}' 2>/dev/null") ?: '');
            // Se não conseguir, tentar 172.18.0.1 (gateway comum do Docker) ou 172.17.0.1
            if (empty($gateway)) {
                // Testar qual funciona
                $testHosts = ['172.18.0.1', '172.17.0.1'];
                $gateway = '172.18.0.1'; // Default
                foreach ($testHosts as $testHost) {
                    $test = @fsockopen($testHost, 3306, $errno, $errstr, 1);
                    if ($test) {
                        fclose($test);
                        $gateway = $testHost;
                        break;
                    }
                }
            }
            $defaultHost = $gateway;
        } else {
            $defaultHost = 'localhost';
        }
        
        // Tentar $_ENV primeiro, depois getenv(), depois default
        $this->config = [
            'host' => $_ENV['LOG_DB_HOST'] ?? getenv('LOG_DB_HOST') ?: $defaultHost,
            'port' => (int)($_ENV['LOG_DB_PORT'] ?? getenv('LOG_DB_PORT') ?: 3306),
            'database' => $_ENV['LOG_DB_NAME'] ?? getenv('LOG_DB_NAME') ?: 'rpa_logs_dev',
            'username' => $_ENV['LOG_DB_USER'] ?? getenv('LOG_DB_USER') ?: 'rpa_logger_dev',
            'password' => $_ENV['LOG_DB_PASS'] ?? getenv('LOG_DB_PASS') ?: '',
            'charset' => 'utf8mb4',
            'options' => [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
                PDO::ATTR_TIMEOUT => 5
            ]
        ];
    }
    
    /**
     * Conectar ao banco de dados
     */
    private function connect() {
        if ($this->pdo !== null) {
            // Verificar se conexão ainda está válida
            try {
                $this->pdo->query('SELECT 1');
                return $this->pdo;
            } catch (PDOException $e) {
                // Conexão perdida, resetar
                $this->pdo = null;
            }
        }
        
        $maxRetries = 3;
        $retryDelay = 1; // segundos
        
        for ($attempt = 1; $attempt <= $maxRetries; $attempt++) {
            try {
                $dsn = sprintf(
                    'mysql:host=%s;port=%d;dbname=%s;charset=%s',
                    $this->config['host'],
                    $this->config['port'],
                    $this->config['database'],
                    $this->config['charset']
                );
                
                $this->pdo = new PDO(
                    $dsn,
                    $this->config['username'],
                    $this->config['password'],
                    $this->config['options']
                );
                
                return $this->pdo;
                
            } catch (PDOException $e) {
                $errorCode = $e->getCode();
                $errorMessage = $e->getMessage();
                
                error_log("ProfessionalLogger: Database connection failed (attempt $attempt/$maxRetries) - Code: $errorCode, Message: $errorMessage");
                
                if ($attempt < $maxRetries) {
                    // Aguardar antes de tentar novamente
                    sleep($retryDelay);
                    continue;
                }
                
                // Todas as tentativas falharam
                error_log("ProfessionalLogger: All connection attempts failed. Giving up.");
                return null;
            }
        }
        
        return null;
    }
    
    /**
     * Capturar informações do arquivo e linha usando debug_backtrace
     */
    private function captureCallerInfo() {
        $trace = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 10);
        
        // Procurar o primeiro frame que não seja desta classe
        $caller = null;
        foreach ($trace as $frame) {
            // Ignorar frames desta classe e funções de log
            if (isset($frame['file']) && 
                !strpos($frame['file'], 'ProfessionalLogger.php') &&
                !isset($frame['function']) || 
                !in_array($frame['function'], ['log', 'debug', 'info', 'warn', 'error', 'fatal'])) {
                $caller = $frame;
                break;
            }
        }
        
        // Se não encontrou, usar o primeiro frame disponível
        if ($caller === null && isset($trace[0])) {
            $caller = $trace[0];
        }
        
        if ($caller === null) {
            return [
                'file_name' => 'unknown',
                'file_path' => null,
                'line_number' => null,
                'function_name' => null,
                'class_name' => null
            ];
        }
        
        return [
            'file_name' => basename($caller['file'] ?? 'unknown'),
            'file_path' => $caller['file'] ?? null,
            'line_number' => $caller['line'] ?? null,
            'function_name' => $caller['function'] ?? null,
            'class_name' => $caller['class'] ?? null
        ];
    }
    
    /**
     * Obter informações do cliente
     */
    private function getClientInfo() {
        return [
            'ip_address' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
            'url' => $_SERVER['HTTP_REFERER'] ?? ($_SERVER['REQUEST_URI'] ?? 'unknown'),
            'server_name' => $_SERVER['SERVER_NAME'] ?? 'unknown'
        ];
    }
    
    /**
     * Sanitizar dados sensíveis
     */
    private function sanitizeData($data) {
        if (is_string($data)) {
            // Mascarar senhas, tokens, etc.
            $data = preg_replace('/("password"\s*:\s*")([^"]+)(")/i', '$1****$3', $data);
            $data = preg_replace('/("token"\s*:\s*")([^"]+)(")/i', '$1****$3', $data);
            $data = preg_replace('/("api_key"\s*:\s*")([^"]+)(")/i', '$1****$3', $data);
        } elseif (is_array($data) || is_object($data)) {
            $data = json_encode($data, JSON_UNESCAPED_UNICODE);
            $data = $this->sanitizeData($data);
            $data = json_decode($data, true);
        }
        return $data;
    }
    
    /**
     * Preparar dados do log
     */
    private function prepareLogData($level, $message, $data = null, $category = null, $stackTrace = null, $jsFileInfo = null) {
        // Se informações do JavaScript foram fornecidas, usar essas (sobrescreve captura PHP)
        if ($jsFileInfo !== null && is_array($jsFileInfo)) {
            $callerInfo = [
                'file_name' => $jsFileInfo['file_name'] ?? 'unknown',
                'file_path' => $jsFileInfo['file_path'] ?? null,
                'line_number' => $jsFileInfo['line_number'] ?? null,
                'function_name' => $jsFileInfo['function_name'] ?? null,
                'class_name' => null // JavaScript não tem classes neste contexto
            ];
        } else {
            $callerInfo = $this->captureCallerInfo();
        }
        $clientInfo = $this->getClientInfo();
        
        // Sanitizar dados
        if ($data !== null) {
            $data = $this->sanitizeData($data);
        }
        
        // Converter dados para JSON se necessário
        // IMPORTANTE: A coluna 'data' é do tipo JSON no banco, então precisa ser JSON válido
        $dataJson = null;
        if ($data !== null) {
            if (is_array($data) || is_object($data)) {
                // Array/objeto: converter para JSON
                $dataJson = json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            } elseif (is_string($data)) {
                // String: verificar se já é JSON válido
                $decoded = json_decode($data, true);
                if (json_last_error() === JSON_ERROR_NONE && (is_array($decoded) || is_object($decoded))) {
                    // Já é JSON válido, usar como está
                    $dataJson = $data;
                } else {
                    // Não é JSON válido, converter string para JSON (wrapping)
                    $dataJson = json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
                }
            } else {
                // Outros tipos (int, float, bool, null): converter para JSON
                $dataJson = json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            }
            
            // Validar que o JSON é válido antes de inserir
            if ($dataJson !== null) {
                $testDecode = json_decode($dataJson, true);
                if (json_last_error() !== JSON_ERROR_NONE) {
                    // Se ainda não for JSON válido, forçar como string JSON
                    $dataJson = json_encode((string)$dataJson, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
                }
                
                // Limitar tamanho (máximo 10KB)
                if (strlen($dataJson) > 10000) {
                    $truncated = substr($dataJson, 0, 10000);
                    // Garantir que o JSON truncado ainda seja válido
                    $dataJson = json_encode(json_decode($truncated, true) ?: $truncated, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
                }
            }
        }
        
        return [
            'log_id' => uniqid('log_', true) . '_' . microtime(true) . '_' . random_int(1000, 9999),
            'request_id' => $this->requestId,
            'timestamp' => date('Y-m-d H:i:s.u'),
            'client_timestamp' => isset($_SERVER['HTTP_X_CLIENT_TIMESTAMP']) 
                ? date('Y-m-d H:i:s.u', strtotime($_SERVER['HTTP_X_CLIENT_TIMESTAMP']))
                : null,
            'server_time' => microtime(true),
            'level' => strtoupper($level),
            'category' => $category,
            'file_name' => $callerInfo['file_name'],
            'file_path' => $callerInfo['file_path'],
            'line_number' => $callerInfo['line_number'],
            'function_name' => $callerInfo['function_name'],
            'class_name' => $callerInfo['class_name'],
            'message' => $message,
            'data' => $dataJson,
            'stack_trace' => $stackTrace,
            'url' => $clientInfo['url'],
            'session_id' => $_POST['session_id'] ?? $_GET['session_id'] ?? null,
            'user_id' => $_POST['user_id'] ?? $_GET['user_id'] ?? null,
            'ip_address' => $clientInfo['ip_address'],
            'user_agent' => $clientInfo['user_agent'],
            'environment' => $this->environment,
            'server_name' => $clientInfo['server_name'],
            'metadata' => null,
            'tags' => null
        ];
    }
    
    /**
     * Função auxiliar para logging direto em arquivo (garantir captura de erros)
     */
    private function logToFile($message, $data = null) {
        // Usar getBaseDir() de config.php
        require_once __DIR__ . '/config.php';
        $logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
        $logFile = rtrim($logDir, '/\\') . '/professional_logger_errors.txt';
        
        $timestamp = date('Y-m-d H:i:s.u');
        
        $logLine = "[$timestamp] $message";
        if ($data !== null) {
            $logLine .= " | " . json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        }
        $logLine .= PHP_EOL;
        
        // Tentar gravar no arquivo principal - SEM fallback
        if (!@file_put_contents($logFile, $logLine, FILE_APPEND | LOCK_EX)) {
            error_log("ProfessionalLogger: ERRO CRÍTICO - Não foi possível gravar log em: $logFile");
            throw new RuntimeException("Não foi possível gravar log em: $logFile");
        }
        
        // SEMPRE logar também no error_log do PHP
        error_log("ProfessionalLogger: " . trim($logLine));
    }
    
    /**
     * Inserir log no banco de dados
     */
    private function insertLog($logData) {
        $pdo = $this->connect();
        if ($pdo === null) {
            $this->logToFile("Database connection failed - connect() returned null");
            return false;
        }
        
        try {
            $sql = "
                INSERT INTO application_logs (
                    log_id, request_id, timestamp, client_timestamp, server_time,
                    level, category, file_name, file_path, line_number,
                    function_name, class_name, message, data, stack_trace,
                    url, session_id, user_id, ip_address, user_agent,
                    environment, server_name, metadata, tags
                ) VALUES (
                    :log_id, :request_id, :timestamp, :client_timestamp, :server_time,
                    :level, :category, :file_name, :file_path, :line_number,
                    :function_name, :class_name, :message, :data, :stack_trace,
                    :url, :session_id, :user_id, :ip_address, :user_agent,
                    :environment, :server_name, :metadata, :tags
                )
            ";
            
            $stmt = $pdo->prepare($sql);
            $result = $stmt->execute([
                ':log_id' => $logData['log_id'],
                ':request_id' => $logData['request_id'],
                ':timestamp' => $logData['timestamp'],
                ':client_timestamp' => $logData['client_timestamp'],
                ':server_time' => $logData['server_time'],
                ':level' => $logData['level'],
                ':category' => $logData['category'],
                ':file_name' => $logData['file_name'],
                ':file_path' => $logData['file_path'],
                ':line_number' => $logData['line_number'],
                ':function_name' => $logData['function_name'],
                ':class_name' => $logData['class_name'],
                ':message' => $logData['message'],
                ':data' => $logData['data'],
                ':stack_trace' => $logData['stack_trace'],
                ':url' => $logData['url'],
                ':session_id' => $logData['session_id'],
                ':user_id' => $logData['user_id'],
                ':ip_address' => $logData['ip_address'],
                ':user_agent' => $logData['user_agent'],
                ':environment' => $logData['environment'],
                ':server_name' => $logData['server_name'],
                ':metadata' => $logData['metadata'],
                ':tags' => $logData['tags']
            ]);
            
            // Se execute() retornou false, verificar errorInfo
            if ($result === false) {
                $errorInfo = $stmt->errorInfo();
                $this->logToFile("INSERT execute() returned false", [
                    'sqlstate' => $errorInfo[0] ?? 'N/A',
                    'error_code' => $errorInfo[1] ?? 'N/A',
                    'error_message' => $errorInfo[2] ?? 'N/A',
                    'log_id' => $logData['log_id'],
                    'level' => $logData['level']
                ]);
                return false;
            }
            
            return $result ? $logData['log_id'] : false;
            
        } catch (PDOException $e) {
            $errorCode = $e->getCode();
            $errorMessage = $e->getMessage();
            $errorFile = $e->getFile();
            $errorLine = $e->getLine();
            $sqlState = $e->errorInfo[0] ?? 'N/A';
            $driverCode = $e->errorInfo[1] ?? 'N/A';
            $driverMessage = $e->errorInfo[2] ?? 'N/A';
            
            // Log detalhado do erro com todas as informações
            $errorDetails = [
                'error_code' => $errorCode,
                'sqlstate' => $sqlState,
                'driver_code' => $driverCode,
                'driver_message' => $driverMessage,
                'error_message' => $errorMessage,
                'file' => $errorFile,
                'line' => $errorLine,
                'log_id' => $logData['log_id'] ?? 'N/A',
                'request_id' => $logData['request_id'] ?? 'N/A',
                'level' => $logData['level'] ?? 'N/A',
                'message_length' => strlen($logData['message'] ?? ''),
                'has_data' => $logData['data'] !== null,
                'data_length' => $logData['data'] !== null ? strlen($logData['data']) : 0,
                'has_stack_trace' => $logData['stack_trace'] !== null,
                'stack_trace_length' => $logData['stack_trace'] !== null ? strlen($logData['stack_trace']) : 0
            ];
            
            // Logar em arquivo E error_log
            $this->logToFile("PDOException during INSERT", $errorDetails);
            error_log("ProfessionalLogger: Failed to insert log - Code: $errorCode, SQLSTATE: $sqlState, Message: $errorMessage, File: $errorFile, Line: $errorLine");
            
            // Se for deadlock (código 1213) ou timeout, tentar novamente
            $isDeadlock = ($errorCode == 1213 || strpos($errorMessage, 'Deadlock') !== false);
            $isTimeout = ($errorCode == 2006 || strpos($errorMessage, 'timeout') !== false || strpos($errorMessage, 'Timed out') !== false);
            
            if ($isDeadlock || $isTimeout) {
                $retryType = $isDeadlock ? 'deadlock' : 'timeout';
                $this->logToFile("$retryType detected, retrying once...", ['log_id' => $logData['log_id']]);
                
                try {
                    // Aguardar um pouco antes de retry
                    usleep($isDeadlock ? 100000 : 500000); // 100ms para deadlock, 500ms para timeout
                    
                    // Tentar novamente
                    $stmt = $pdo->prepare($sql);
                    $result = $stmt->execute([
                        ':log_id' => $logData['log_id'],
                        ':request_id' => $logData['request_id'],
                        ':timestamp' => $logData['timestamp'],
                        ':client_timestamp' => $logData['client_timestamp'],
                        ':server_time' => $logData['server_time'],
                        ':level' => $logData['level'],
                        ':category' => $logData['category'],
                        ':file_name' => $logData['file_name'],
                        ':file_path' => $logData['file_path'],
                        ':line_number' => $logData['line_number'],
                        ':function_name' => $logData['function_name'],
                        ':class_name' => $logData['class_name'],
                        ':message' => $logData['message'],
                        ':data' => $logData['data'],
                        ':stack_trace' => $logData['stack_trace'],
                        ':url' => $logData['url'],
                        ':session_id' => $logData['session_id'],
                        ':user_id' => $logData['user_id'],
                        ':ip_address' => $logData['ip_address'],
                        ':user_agent' => $logData['user_agent'],
                        ':environment' => $logData['environment'],
                        ':server_name' => $logData['server_name'],
                        ':metadata' => $logData['metadata'],
                        ':tags' => $logData['tags']
                    ]);
                    
                    if ($result) {
                        $this->logToFile("Retry after $retryType succeeded", ['log_id' => $logData['log_id']]);
                        error_log("ProfessionalLogger: Retry after $retryType succeeded");
                        return $logData['log_id'];
                    } else {
                        $retryErrorInfo = $stmt->errorInfo();
                        $this->logToFile("Retry after $retryType - execute() returned false", [
                            'sqlstate' => $retryErrorInfo[0] ?? 'N/A',
                            'error_code' => $retryErrorInfo[1] ?? 'N/A',
                            'error_message' => $retryErrorInfo[2] ?? 'N/A'
                        ]);
                        error_log("ProfessionalLogger: Retry after $retryType - execute() returned false");
                        error_log("ProfessionalLogger: Retry error info: " . json_encode($retryErrorInfo ?? []));
                    }
                    
                } catch (PDOException $e2) {
                    $this->logToFile("Retry after $retryType failed", [
                        'error_code' => $e2->getCode(),
                        'sqlstate' => $e2->errorInfo[0] ?? 'N/A',
                        'error_message' => $e2->getMessage()
                    ]);
                    error_log("ProfessionalLogger: Retry after $retryType failed - Code: " . $e2->getCode() . ", Message: " . $e2->getMessage());
                }
            }
            
            // Se não for deadlock/timeout, verificar outros erros comuns
            if ($errorCode == 23000 || strpos($errorMessage, 'Duplicate entry') !== false) {
                $this->logToFile("Duplicate entry error", ['log_id' => $logData['log_id'] ?? 'N/A']);
                error_log("ProfessionalLogger: Duplicate entry error - log_id may already exist: " . ($logData['log_id'] ?? 'N/A'));
            } elseif ($errorCode == 22001 || strpos($errorMessage, 'Data too long') !== false) {
                $this->logToFile("Data too long error", [
                    'message_length' => strlen($logData['message'] ?? ''),
                    'data_length' => $logData['data'] !== null ? strlen($logData['data']) : 0
                ]);
                error_log("ProfessionalLogger: Data too long error - message length: " . strlen($logData['message'] ?? ''));
            } elseif ($errorCode == 42000 || strpos($errorMessage, 'syntax error') !== false) {
                $this->logToFile("SQL syntax error detected");
                error_log("ProfessionalLogger: SQL syntax error detected");
            } else {
                // Erro desconhecido - logar todos os detalhes
                $this->logToFile("Unknown PDO error", $errorDetails);
            }
            
            return false;
        } catch (Exception $e) {
            // Capturar outras exceções não-PDO
            $this->logToFile("Non-PDO exception during insert", [
                'exception_class' => get_class($e),
                'message' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'log_id' => $logData['log_id'] ?? 'N/A'
            ]);
            error_log("ProfessionalLogger: Non-PDO exception during insert - " . get_class($e) . ": " . $e->getMessage() . " in " . $e->getFile() . ":" . $e->getLine());
            return false;
        }
    }
    
    /**
     * Método genérico de log
     */
    public function log($level, $message, $data = null, $category = null, $stackTrace = null, $jsFileInfo = null) {
        $logData = $this->prepareLogData($level, $message, $data, $category, $stackTrace, $jsFileInfo);
        return $this->insertLog($logData);
    }
    
    /**
     * Log DEBUG
     */
    public function debug($message, $data = null, $category = null) {
        return $this->log('DEBUG', $message, $data, $category);
    }
    
    /**
     * Log INFO
     */
    public function info($message, $data = null, $category = null) {
        return $this->log('INFO', $message, $data, $category);
    }
    
    /**
     * Log WARN
     */
    public function warn($message, $data = null, $category = null) {
        return $this->log('WARN', $message, $data, $category);
    }
    
    /**
     * Sanitizar dados para serialização JSON
     * Converte recursos e objetos não serializáveis em strings
     * 
     * @param mixed $data Dados a sanitizar
     * @return mixed Dados sanitizados
     */
    private function sanitizeForJson($data) {
        if (is_resource($data)) {
            return '[Resource não serializável: ' . get_resource_type($data) . ']';
        }
        
        if (is_object($data)) {
            // Tentar serializar objeto simples
            if (method_exists($data, '__toString')) {
                return (string)$data;
            }
            // Objeto complexo: converter para string descritiva
            return '[Objeto não serializável: ' . get_class($data) . ']';
        }
        
        if (is_array($data)) {
            return array_map([$this, 'sanitizeForJson'], $data);
        }
        
        // Tipos primitivos (string, int, float, bool, null) são OK
        return $data;
    }
    
    /**
     * Enviar notificação por email quando ERROR ou FATAL
     * 
     * @param string $level Nível do log ('ERROR' ou 'FATAL')
     * @param string $message Mensagem do log
     * @param mixed $data Dados adicionais
     * @param string|null $category Categoria do log
     * @param string|null $stackTrace Stack trace completo
     * @param array|null $logData Dados completos do log (arquivo, linha, etc.)
     */
    private function sendEmailNotification($level, $message, $data = null, $category = null, $stackTrace = null, $logData = null) {
        try {
            // Determinar URL do endpoint
            $baseUrl = $_ENV['APP_BASE_URL'] ?? '';
            if (empty($baseUrl)) {
                error_log('[ProfessionalLogger] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');
                throw new RuntimeException('APP_BASE_URL não está definido nas variáveis de ambiente');
            }
            $endpoint = $baseUrl . '/send_email_notification_endpoint.php';
            
            // Sanitizar dados antes de adicionar ao payload
            $sanitizedData = $this->sanitizeForJson($data);
            $sanitizedStackTrace = $this->sanitizeForJson($stackTrace);
            $sanitizedLogData = $this->sanitizeForJson($logData);
            
            // Preparar payload
            $payload = [
                'ddd' => '00', // Não aplicável para logs
                'celular' => '000000000', // Não aplicável para logs
                'nome' => 'Sistema de Logging',
                'cpf' => 'N/A',
                'email' => 'N/A',
                'cep' => 'N/A',
                'placa' => 'N/A',
                'gclid' => 'N/A',
                'momento' => strtolower($level),
                'momento_descricao' => $level === 'FATAL' ? 'Erro Fatal no Sistema' : 'Erro no Sistema',
                'momento_emoji' => $level === 'FATAL' ? '🚨' : '❌',
                'erro' => [
                    'message' => $message,
                    'level' => $level,
                    'category' => $category,
                    'data' => $sanitizedData,
                    'stack_trace' => $sanitizedStackTrace,
                    'file_name' => $sanitizedLogData['file_name'] ?? null,
                    'line_number' => $sanitizedLogData['line_number'] ?? null,
                    'function_name' => $sanitizedLogData['function_name'] ?? null,
                    'class_name' => $sanitizedLogData['class_name'] ?? null,
                    'timestamp' => $sanitizedLogData['timestamp'] ?? date('Y-m-d H:i:s'),
                    'request_id' => $this->requestId,
                    'environment' => $this->environment
                ]
            ];
            
            // Validar JSON antes de enviar
            $jsonPayload = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            
            if ($jsonPayload === false) {
                $jsonError = json_last_error_msg();
                error_log("[ProfessionalLogger] Erro ao serializar JSON para email: " . $jsonError);
                // Tentar enviar payload simplificado
                $payloadSimplified = [
                    'ddd' => '00',
                    'celular' => '000000000',
                    'nome' => 'Sistema de Logging',
                    'cpf' => 'N/A',
                    'email' => 'N/A',
                    'cep' => 'N/A',
                    'placa' => 'N/A',
                    'gclid' => 'N/A',
                    'momento' => strtolower($level),
                    'momento_descricao' => $level === 'FATAL' ? 'Erro Fatal no Sistema' : 'Erro no Sistema',
                    'momento_emoji' => $level === 'FATAL' ? '🚨' : '❌',
                    'erro' => [
                        'message' => $message . ' [JSON serialization failed: ' . $jsonError . ']',
                        'level' => $level,
                        'category' => $category,
                        'timestamp' => date('Y-m-d H:i:s'),
                        'request_id' => $this->requestId,
                        'environment' => $this->environment
                    ]
                ];
                $jsonPayload = json_encode($payloadSimplified, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
                
                // Se ainda falhar, não enviar
                if ($jsonPayload === false) {
                    error_log("[ProfessionalLogger] Falha crítica ao serializar JSON simplificado. Não será enviado email.");
                    return;
                }
            }
            
            // Preparar contexto HTTP (assíncrono, não bloqueia)
            // IMPORTANTE: Header deve ser string com \r\n, não array
            $headerString = "Content-Type: application/json\r\n" .
                           "User-Agent: ProfessionalLogger-EmailNotification/1.0";
            
            $context = stream_context_create([
                'http' => [
                    'method' => 'POST',
                    'header' => $headerString,
                    'content' => $jsonPayload,
                    'timeout' => 10, // Aumentado para 10 segundos
                    'ignore_errors' => true // Não lançar exceção em HTTP errors
                ],
                'ssl' => [
                    'verify_peer' => false,
                    'verify_peer_name' => false,
                    'allow_self_signed' => true
                ]
            ]);
            
            // Fazer requisição e capturar erros para debug
            $result = @file_get_contents($endpoint, false, $context);
            
            // Logar resultado para debug (sem usar ProfessionalLogger para evitar loop)
            if ($result === false) {
                $error = error_get_last();
                // Logar em arquivo de erro do PHP (não usar ProfessionalLogger)
                error_log("[ProfessionalLogger] Falha ao enviar email: " . ($error['message'] ?? 'Erro desconhecido') . " | Endpoint: " . $endpoint);
            } else {
                // Logar sucesso para debug
                $responseData = @json_decode($result, true);
                if ($responseData && isset($responseData['success'])) {
                    error_log("[ProfessionalLogger] Email enviado: " . ($responseData['success'] ? 'SUCESSO' : 'FALHOU') . " | Total enviado: " . ($responseData['total_sent'] ?? 0) . " | Endpoint: " . $endpoint);
                } else {
                    error_log("[ProfessionalLogger] Resposta inesperada do endpoint: " . substr($result, 0, 200) . " | Endpoint: " . $endpoint);
                }
            }
            
        } catch (Exception $e) {
            // Logar exceção em arquivo de erro do PHP (não usar ProfessionalLogger)
            error_log("[ProfessionalLogger] Exceção ao enviar email: " . $e->getMessage() . " | Endpoint: " . ($endpoint ?? 'N/A'));
        }
    }
    
    /**
     * Log ERROR
     */
    public function error($message, $data = null, $category = null, $exception = null) {
        $stackTrace = null;
        if ($exception instanceof Exception) {
            $stackTrace = $exception->getTraceAsString();
        }
        
        // Fazer log primeiro
        $logId = $this->log('ERROR', $message, $data, $category, $stackTrace);
        
        // Se log foi bem-sucedido, enviar email (assíncrono)
        if ($logId !== false) {
            // Obter dados do log para incluir no email
            $logData = $this->prepareLogData('ERROR', $message, $data, $category, $stackTrace);
            $this->sendEmailNotification('ERROR', $message, $data, $category, $stackTrace, $logData);
        }
        
        return $logId;
    }
    
    /**
     * Log FATAL
     */
    public function fatal($message, $data = null, $category = null, $exception = null) {
        $stackTrace = null;
        if ($exception instanceof Exception) {
            $stackTrace = $exception->getTraceAsString();
        }
        
        // Fazer log primeiro
        $logId = $this->log('FATAL', $message, $data, $category, $stackTrace);
        
        // Se log foi bem-sucedido, enviar email (assíncrono)
        if ($logId !== false) {
            // Obter dados do log para incluir no email
            $logData = $this->prepareLogData('FATAL', $message, $data, $category, $stackTrace);
            $this->sendEmailNotification('FATAL', $message, $data, $category, $stackTrace, $logData);
        }
        
        return $logId;
    }
    
    /**
     * Obter request ID
     */
    public function getRequestId() {
        return $this->requestId;
    }
    
    /**
     * Obter conexão PDO (para uso em outros scripts)
     */
    public function getConnection() {
        return $this->connect();
    }
}

