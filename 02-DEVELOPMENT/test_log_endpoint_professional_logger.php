<?php
/**
 * Script de Teste: log_endpoint.php e ProfessionalLogger.php
 * 
 * Este script testa ambos os sistemas de logging:
 * 1. log_endpoint.php via HTTP POST (simulando chamada do JavaScript)
 * 2. ProfessionalLogger diretamente (simulando chamada do PHP)
 * 
 * Data: 16/11/2025
 * Ambiente: Produção
 */

// Configurações
$baseUrl = 'https://prod.bssegurosimediato.com.br';
$testResults = [];

// Função para testar log_endpoint.php via HTTP POST
function testLogEndpointViaHTTP($baseUrl) {
    global $testResults;
    
    echo "\n" . str_repeat("=", 80) . "\n";
    echo "TESTE 1: log_endpoint.php via HTTP POST (Simulando JavaScript)\n";
    echo str_repeat("=", 80) . "\n\n";
    
    $endpoint = $baseUrl . '/log_endpoint.php';
    
    // Payload exatamente como o JavaScript envia
    $payload = [
        'level' => 'INFO',
        'category' => 'TEST',
        'message' => '[TESTE] Teste de log_endpoint.php via HTTP POST - ' . date('Y-m-d H:i:s'),
        'data' => [
            'test_type' => 'http_post',
            'simulated_by' => 'test_log_endpoint_professional_logger.php',
            'timestamp' => time(),
            'random_data' => [
                'value1' => rand(1, 100),
                'value2' => 'test_string',
                'value3' => true
            ]
        ],
        'session_id' => 'test_session_' . uniqid(),
        'url' => $baseUrl . '/test_log_endpoint_professional_logger.php',
        'stack_trace' => "Error\n    at testLogEndpointViaHTTP (test_log_endpoint_professional_logger.php:XX)\n    at main (test_log_endpoint_professional_logger.php:YY)",
        'file_name' => 'test_log_endpoint_professional_logger.php',
        'file_path' => __FILE__,
        'line_number' => __LINE__,
        'function_name' => 'testLogEndpointViaHTTP'
    ];
    
    echo "Endpoint: $endpoint\n";
    echo "Payload:\n";
    echo json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) . "\n\n";
    
    // Fazer requisição POST
    $ch = curl_init($endpoint);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json'
    ]);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2);
    
    $startTime = microtime(true);
    $response = curl_exec($ch);
    $duration = microtime(true) - $startTime;
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    curl_close($ch);
    
    echo "Tempo de Resposta: " . round($duration * 1000, 2) . "ms\n";
    echo "HTTP Status Code: $httpCode\n";
    
    if ($curlError) {
        echo "Erro cURL: $curlError\n";
        $testResults['log_endpoint_http'] = [
            'success' => false,
            'error' => $curlError,
            'http_code' => $httpCode
        ];
        return false;
    }
    
    echo "Resposta:\n";
    echo $response . "\n\n";
    
    $responseData = json_decode($response, true);
    
    if ($httpCode === 200 && $responseData && isset($responseData['success']) && $responseData['success']) {
        echo "✅ SUCESSO!\n";
        echo "Log ID: " . ($responseData['log_id'] ?? 'N/A') . "\n";
        echo "Request ID: " . ($responseData['request_id'] ?? 'N/A') . "\n";
        $testResults['log_endpoint_http'] = [
            'success' => true,
            'http_code' => $httpCode,
            'log_id' => $responseData['log_id'] ?? null,
            'request_id' => $responseData['request_id'] ?? null,
            'duration_ms' => round($duration * 1000, 2)
        ];
        return true;
    } else {
        echo "❌ FALHA!\n";
        echo "Erro: " . ($responseData['error'] ?? 'Erro desconhecido') . "\n";
        echo "Mensagem: " . ($responseData['message'] ?? 'N/A') . "\n";
        $testResults['log_endpoint_http'] = [
            'success' => false,
            'http_code' => $httpCode,
            'error' => $responseData['error'] ?? 'Erro desconhecido',
            'message' => $responseData['message'] ?? null,
            'response' => $responseData
        ];
        return false;
    }
}

// Função para testar ProfessionalLogger diretamente (simulando PHP)
function testProfessionalLoggerDirect() {
    global $testResults;
    
    echo "\n" . str_repeat("=", 80) . "\n";
    echo "TESTE 2: ProfessionalLogger diretamente (Simulando PHP)\n";
    echo str_repeat("=", 80) . "\n\n";
    
    // Verificar se ProfessionalLogger.php existe
    $loggerPath = __DIR__ . '/ProfessionalLogger.php';
    if (!file_exists($loggerPath)) {
        echo "❌ ERRO: ProfessionalLogger.php não encontrado em: $loggerPath\n";
        $testResults['professional_logger_direct'] = [
            'success' => false,
            'error' => 'ProfessionalLogger.php não encontrado'
        ];
        return false;
    }
    
    // Verificar se extensão PDO MySQL está disponível
    if (!extension_loaded('pdo_mysql')) {
        echo "⚠️ AVISO: Extensão PDO MySQL não está carregada no PHP CLI\n";
        echo "   Isso é normal - a extensão está disponível via PHP-FPM (web)\n";
        echo "   Testando apenas via HTTP POST (que usa PHP-FPM)...\n\n";
        $testResults['professional_logger_direct'] = [
            'success' => false,
            'error' => 'Extensão PDO MySQL não disponível no PHP CLI',
            'note' => 'Isso é normal - extensão disponível via PHP-FPM'
        ];
        return false;
    }
    
    echo "Carregando ProfessionalLogger.php...\n";
    require_once $loggerPath;
    
    if (!class_exists('ProfessionalLogger')) {
        echo "❌ ERRO: Classe ProfessionalLogger não encontrada após carregar arquivo\n";
        $testResults['professional_logger_direct'] = [
            'success' => false,
            'error' => 'Classe ProfessionalLogger não encontrada'
        ];
        return false;
    }
    
    echo "✅ ProfessionalLogger.php carregado com sucesso\n\n";
    
    // Instanciar logger (exatamente como send_email_notification_endpoint.php faz)
    echo "Instanciando ProfessionalLogger...\n";
    try {
        $logger = new ProfessionalLogger();
        echo "✅ ProfessionalLogger instanciado com sucesso\n";
        echo "Request ID: " . $logger->getRequestId() . "\n\n";
    } catch (Exception $e) {
        echo "❌ ERRO ao instanciar ProfessionalLogger:\n";
        echo "   Mensagem: " . $e->getMessage() . "\n";
        echo "   Arquivo: " . $e->getFile() . "\n";
        echo "   Linha: " . $e->getLine() . "\n";
        $testResults['professional_logger_direct'] = [
            'success' => false,
            'error' => $e->getMessage(),
            'exception' => get_class($e)
        ];
        return false;
    } catch (Error $e) {
        echo "❌ ERRO FATAL ao instanciar ProfessionalLogger:\n";
        echo "   Mensagem: " . $e->getMessage() . "\n";
        echo "   Arquivo: " . $e->getFile() . "\n";
        echo "   Linha: " . $e->getLine() . "\n";
        $testResults['professional_logger_direct'] = [
            'success' => false,
            'error' => $e->getMessage(),
            'exception' => get_class($e)
        ];
        return false;
    }
    
    // Teste 2.1: logger->log() (exatamente como log_endpoint.php faz)
    echo "Teste 2.1: logger->log() (simulando log_endpoint.php)...\n";
    $testMessage = '[TESTE] Teste de ProfessionalLogger->log() - ' . date('Y-m-d H:i:s');
    $testData = [
        'test_type' => 'direct_php',
        'simulated_by' => 'test_log_endpoint_professional_logger.php',
        'timestamp' => time(),
        'random_data' => [
            'value1' => rand(1, 100),
            'value2' => 'test_string',
            'value3' => true
        ]
    ];
    $testCategory = 'TEST';
    $testStackTrace = "Error\n    at testProfessionalLoggerDirect (test_log_endpoint_professional_logger.php:XX)\n    at main (test_log_endpoint_professional_logger.php:YY)";
    $testJsFileInfo = [
        'file_name' => 'test_log_endpoint_professional_logger.php',
        'file_path' => __FILE__,
        'line_number' => __LINE__,
        'function_name' => 'testProfessionalLoggerDirect'
    ];
    
    echo "Chamando: logger->log('INFO', message, data, category, stackTrace, jsFileInfo)\n";
    echo "Mensagem: $testMessage\n";
    echo "Categoria: $testCategory\n";
    echo "Dados: " . json_encode($testData, JSON_PRETTY_PRINT) . "\n\n";
    
    $startTime = microtime(true);
    try {
        $logId = $logger->log('INFO', $testMessage, $testData, $testCategory, $testStackTrace, $testJsFileInfo);
        $duration = microtime(true) - $startTime;
        
        echo "Tempo de Execução: " . round($duration * 1000, 2) . "ms\n";
        echo "Log ID Retornado: " . ($logId !== false ? $logId : 'false') . "\n";
        
        if ($logId !== false && is_string($logId) && strlen($logId) > 0) {
            echo "✅ SUCESSO! Log inserido com ID: $logId\n";
            $testResults['professional_logger_log'] = [
                'success' => true,
                'log_id' => $logId,
                'duration_ms' => round($duration * 1000, 2)
            ];
        } else {
            echo "❌ FALHA! logger->log() retornou false ou valor inválido\n";
            $testResults['professional_logger_log'] = [
                'success' => false,
                'log_id' => $logId,
                'error' => 'logger->log() retornou false'
            ];
        }
    } catch (Exception $e) {
        $duration = microtime(true) - $startTime;
        echo "❌ EXCEÇÃO ao chamar logger->log():\n";
        echo "   Mensagem: " . $e->getMessage() . "\n";
        echo "   Arquivo: " . $e->getFile() . "\n";
        echo "   Linha: " . $e->getLine() . "\n";
        echo "   Stack Trace:\n" . $e->getTraceAsString() . "\n";
        $testResults['professional_logger_log'] = [
            'success' => false,
            'error' => $e->getMessage(),
            'exception' => get_class($e),
            'duration_ms' => round($duration * 1000, 2)
        ];
    } catch (Error $e) {
        $duration = microtime(true) - $startTime;
        echo "❌ ERRO FATAL ao chamar logger->log():\n";
        echo "   Mensagem: " . $e->getMessage() . "\n";
        echo "   Arquivo: " . $e->getFile() . "\n";
        echo "   Linha: " . $e->getLine() . "\n";
        $testResults['professional_logger_log'] = [
            'success' => false,
            'error' => $e->getMessage(),
            'exception' => get_class($e),
            'duration_ms' => round($duration * 1000, 2)
        ];
    }
    
    echo "\n";
    
    // Teste 2.2: logger->error() (exatamente como send_email_notification_endpoint.php faz)
    echo "Teste 2.2: logger->error() (simulando send_email_notification_endpoint.php)...\n";
    $testErrorMessage = '[TESTE] Teste de ProfessionalLogger->error() - ' . date('Y-m-d H:i:s');
    $testErrorData = [
        'test_type' => 'direct_php_error',
        'simulated_by' => 'test_log_endpoint_professional_logger.php',
        'timestamp' => time()
    ];
    $testErrorCategory = 'TEST';
    $testException = new Exception("Teste de exceção simulada");
    
    echo "Chamando: logger->error(message, data, category, exception)\n";
    echo "Mensagem: $testErrorMessage\n";
    echo "Categoria: $testErrorCategory\n";
    echo "Dados: " . json_encode($testErrorData, JSON_PRETTY_PRINT) . "\n\n";
    
    $startTime = microtime(true);
    try {
        $errorLogId = $logger->error($testErrorMessage, $testErrorData, $testErrorCategory, $testException);
        $duration = microtime(true) - $startTime;
        
        echo "Tempo de Execução: " . round($duration * 1000, 2) . "ms\n";
        echo "Log ID Retornado: " . ($errorLogId !== false ? $errorLogId : 'false') . "\n";
        
        if ($errorLogId !== false && is_string($errorLogId) && strlen($errorLogId) > 0) {
            echo "✅ SUCESSO! Log de erro inserido com ID: $errorLogId\n";
            $testResults['professional_logger_error'] = [
                'success' => true,
                'log_id' => $errorLogId,
                'duration_ms' => round($duration * 1000, 2)
            ];
        } else {
            echo "❌ FALHA! logger->error() retornou false ou valor inválido\n";
            $testResults['professional_logger_error'] = [
                'success' => false,
                'log_id' => $errorLogId,
                'error' => 'logger->error() retornou false'
            ];
        }
    } catch (Exception $e) {
        $duration = microtime(true) - $startTime;
        echo "❌ EXCEÇÃO ao chamar logger->error():\n";
        echo "   Mensagem: " . $e->getMessage() . "\n";
        echo "   Arquivo: " . $e->getFile() . "\n";
        echo "   Linha: " . $e->getLine() . "\n";
        $testResults['professional_logger_error'] = [
            'success' => false,
            'error' => $e->getMessage(),
            'exception' => get_class($e),
            'duration_ms' => round($duration * 1000, 2)
        ];
    } catch (Error $e) {
        $duration = microtime(true) - $startTime;
        echo "❌ ERRO FATAL ao chamar logger->error():\n";
        echo "   Mensagem: " . $e->getMessage() . "\n";
        echo "   Arquivo: " . $e->getFile() . "\n";
        echo "   Linha: " . $e->getLine() . "\n";
        $testResults['professional_logger_error'] = [
            'success' => false,
            'error' => $e->getMessage(),
            'exception' => get_class($e),
            'duration_ms' => round($duration * 1000, 2)
        ];
    }
    
    return true;
}

// Função para exibir resumo dos testes
function displayTestSummary($testResults) {
    echo "\n" . str_repeat("=", 80) . "\n";
    echo "RESUMO DOS TESTES\n";
    echo str_repeat("=", 80) . "\n\n";
    
    $totalTests = 0;
    $passedTests = 0;
    
    foreach ($testResults as $testName => $result) {
        $totalTests++;
        $status = $result['success'] ? '✅ PASSOU' : '❌ FALHOU';
        echo "$testName: $status\n";
        if ($result['success']) {
            $passedTests++;
            if (isset($result['log_id'])) {
                echo "  Log ID: " . $result['log_id'] . "\n";
            }
            if (isset($result['duration_ms'])) {
                echo "  Duração: " . $result['duration_ms'] . "ms\n";
            }
        } else {
            if (isset($result['error'])) {
                echo "  Erro: " . $result['error'] . "\n";
            }
            if (isset($result['http_code'])) {
                echo "  HTTP Code: " . $result['http_code'] . "\n";
            }
        }
        echo "\n";
    }
    
    echo str_repeat("-", 80) . "\n";
    echo "Total: $totalTests testes | Passou: $passedTests | Falhou: " . ($totalTests - $passedTests) . "\n";
    echo str_repeat("=", 80) . "\n";
    
    return $passedTests === $totalTests;
}

// Executar testes
echo "\n";
echo str_repeat("=", 80) . "\n";
echo "SCRIPT DE TESTE: log_endpoint.php e ProfessionalLogger.php\n";
echo "Data: " . date('Y-m-d H:i:s') . "\n";
echo "Ambiente: Produção\n";
echo str_repeat("=", 80) . "\n";

// Teste 1: log_endpoint.php via HTTP POST
$test1Result = testLogEndpointViaHTTP($baseUrl);

// Teste 2: ProfessionalLogger diretamente
$test2Result = testProfessionalLoggerDirect();

// Exibir resumo
$allTestsPassed = displayTestSummary($testResults);

// Retornar código de saída apropriado
exit($allTestsPassed ? 0 : 1);

