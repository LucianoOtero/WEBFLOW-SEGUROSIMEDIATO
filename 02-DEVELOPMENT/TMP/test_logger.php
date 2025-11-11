<?php
/**
 * test_logger.php - Teste do ProfessionalLogger
 */
require_once __DIR__ . '/ProfessionalLogger.php';

try {
    $logger = new ProfessionalLogger();
    $conn = $logger->getConnection();
    
    if ($conn) {
        echo "Connection OK\n";
        $logId = $logger->info('Teste do sistema de logging profissional', ['test' => true], 'TEST');
        echo "Log ID: $logId\n";
        echo "Request ID: " . $logger->getRequestId() . "\n";
    } else {
        echo "Connection FAILED\n";
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo "Stack trace:\n" . $e->getTraceAsString() . "\n";
}

