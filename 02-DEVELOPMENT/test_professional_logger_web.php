<?php
/**
 * Script de Teste: ProfessionalLogger via Web (PHP-FPM)
 * 
 * Este script testa o ProfessionalLogger exatamente como os arquivos PHP do projeto fazem:
 * - send_email_notification_endpoint.php
 * - log_endpoint.php
 * 
 * Executado via web (PHP-FPM), não via CLI
 * 
 * Data: 16/11/2025
 * Ambiente: Produção
 */

// Headers primeiro (como log_endpoint.php faz)
header('Content-Type: application/json');
require_once __DIR__ . '/config.php';
setCorsHeaders();

$testResults = [];

try {
    // Carregar ProfessionalLogger
    require_once __DIR__ . '/ProfessionalLogger.php';
    
    if (!class_exists('ProfessionalLogger')) {
        throw new Exception('Classe ProfessionalLogger não encontrada');
    }
    
    // Teste 1: logger->log() (exatamente como log_endpoint.php faz)
    $logger = new ProfessionalLogger();
    $testMessage1 = '[TESTE WEB] Teste de ProfessionalLogger->log() via PHP-FPM - ' . date('Y-m-d H:i:s');
    $testData1 = [
        'test_type' => 'web_php_fpm',
        'simulated_by' => 'test_professional_logger_web.php',
        'timestamp' => time(),
        'random_data' => [
            'value1' => rand(1, 100),
            'value2' => 'test_string',
            'value3' => true
        ]
    ];
    
    $logId1 = $logger->log('INFO', $testMessage1, $testData1, 'TEST', null, [
        'file_name' => 'test_professional_logger_web.php',
        'file_path' => __FILE__,
        'line_number' => __LINE__,
        'function_name' => 'main'
    ]);
    
    $testResults['test1_log'] = [
        'success' => ($logId1 !== false && is_string($logId1)),
        'log_id' => $logId1,
        'message' => $testMessage1
    ];
    
    // Teste 2: logger->error() (exatamente como send_email_notification_endpoint.php faz)
    $testMessage2 = '[TESTE WEB] Teste de ProfessionalLogger->error() via PHP-FPM - ' . date('Y-m-d H:i:s');
    $testData2 = [
        'test_type' => 'web_php_fpm_error',
        'simulated_by' => 'test_professional_logger_web.php',
        'timestamp' => time()
    ];
    $testException = new Exception("Teste de exceção simulada");
    
    $logId2 = $logger->error($testMessage2, $testData2, 'TEST', $testException);
    
    $testResults['test2_error'] = [
        'success' => ($logId2 !== false && is_string($logId2)),
        'log_id' => $logId2,
        'message' => $testMessage2
    ];
    
    // Retornar resultados
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'message' => 'Testes executados com sucesso',
        'results' => $testResults,
        'summary' => [
            'total_tests' => count($testResults),
            'passed' => count(array_filter($testResults, function($r) { return $r['success']; })),
            'failed' => count(array_filter($testResults, function($r) { return !$r['success']; }))
        ]
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString()
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} catch (Error $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'type' => 'Fatal Error'
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}

