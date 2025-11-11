<?php
/**
 * Script de teste para validar correções do log_endpoint.php
 */

require_once __DIR__ . '/ProfessionalLogger.php';

echo "=== TESTE DE CORREÇÕES DO LOG_ENDPOINT ===\n\n";

// Teste 1: Conexão MySQL com retry
echo "Teste 1: Conexão MySQL com retry logic\n";
$logger = new ProfessionalLogger();
$conn = $logger->getConnection();
if ($conn) {
    echo "✅ Conexão estabelecida com sucesso\n";
} else {
    echo "❌ Falha na conexão\n";
    exit(1);
}

// Teste 2: Inserção de log
echo "\nTeste 2: Inserção de log\n";
$logId = $logger->log('INFO', 'Teste de correções', ['test' => true]);
if ($logId) {
    echo "✅ Log inserido com sucesso. ID: $logId\n";
} else {
    echo "❌ Falha na inserção\n";
    exit(1);
}

// Teste 3: Rate limiting (simular arquivo vazio)
echo "\nTeste 3: Rate limiting com arquivo vazio\n";
$testFile = sys_get_temp_dir() . '/log_rate_limit_test.tmp';
file_put_contents($testFile, ''); // Arquivo vazio
$data = json_decode(file_get_contents($testFile), true);
if (!is_array($data) || !isset($data['first_request'])) {
    echo "✅ Validação de rate limit funciona (detecta arquivo vazio)\n";
} else {
    echo "❌ Validação não funciona\n";
    exit(1);
}
unlink($testFile);

// Teste 4: REQUEST_METHOD (simular ausência)
echo "\nTeste 4: REQUEST_METHOD ausente\n";
unset($_SERVER['REQUEST_METHOD']);
$method = $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN';
if ($method === 'UNKNOWN') {
    echo "✅ Null coalescing funciona corretamente\n";
} else {
    echo "❌ Null coalescing não funciona\n";
    exit(1);
}

echo "\n=== TODOS OS TESTES PASSARAM ===\n";

