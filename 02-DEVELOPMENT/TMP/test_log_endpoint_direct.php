<?php
/**
 * test_log_endpoint_direct.php
 * 
 * Testa o log_endpoint.php diretamente simulando uma requisição HTTP real
 */

// Simular variáveis de servidor
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['REMOTE_ADDR'] = '191.9.24.241';
$_SERVER['HTTP_USER_AGENT'] = 'Mozilla/5.0';
$_SERVER['HTTP_REFERER'] = 'https://segurosimediato-dev.webflow.io/';
$_SERVER['REQUEST_URI'] = '/log_endpoint.php';
$_SERVER['SERVER_NAME'] = 'dev.bssegurosimediato.com.br';

// Payload de teste
$testPayload = [
    'level' => 'INFO',
    'message' => 'Teste direto via script PHP',
    'category' => 'TEST',
    'data' => null,
    'session_id' => 'test_session',
    'url' => 'https://segurosimediato-dev.webflow.io/'
];

// Simular php://input usando stream wrapper
// Não podemos realmente simular php://input, então vamos testar a lógica diretamente

echo "=== TESTE DIRETO DO LOG_ENDPOINT.PHP ===\n\n";

// Incluir log_endpoint.php mas interceptar file_get_contents('php://input')
// Vamos fazer um teste mais direto - testar cada parte

// 1. Testar JSON decode
$jsonPayload = json_encode($testPayload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
echo "1. Payload JSON:\n";
echo $jsonPayload . "\n\n";

$input = json_decode($jsonPayload, true);
if (!$input) {
    echo "❌ JSON inválido: " . json_last_error_msg() . "\n";
    exit(1);
}
echo "✅ JSON válido\n\n";

// 2. Testar validação
echo "2. Validando campos...\n";
if (!isset($input['level']) || $input['level'] === null || $input['level'] === '') {
    echo "❌ level faltando\n";
    exit(1);
}
echo "✅ level: " . $input['level'] . "\n";

if (!isset($input['message']) || $input['message'] === null || $input['message'] === '') {
    echo "❌ message faltando\n";
    exit(1);
}
echo "✅ message presente\n\n";

// 3. Testar ProfessionalLogger
echo "3. Testando ProfessionalLogger...\n";
require_once __DIR__ . '/ProfessionalLogger.php';

try {
    $logger = new ProfessionalLogger();
    echo "✅ Logger criado\n";
    
    $conn = $logger->getConnection();
    if (!$conn) {
        echo "❌ Conexão MySQL falhou\n";
        exit(1);
    }
    echo "✅ Conexão MySQL OK\n\n";
    
    // 4. Testar inserção
    echo "4. Testando inserção de log...\n";
    $jsFileInfo = [
        'file_name' => $input['file_name'] ?? null,
        'file_path' => $input['file_path'] ?? null,
        'line_number' => isset($input['line_number']) ? (int)$input['line_number'] : null,
        'function_name' => $input['function_name'] ?? null
    ];
    
    $logId = $logger->log(
        strtoupper(trim($input['level'])),
        $input['message'],
        $input['data'] ?? null,
        $input['category'] ?? null,
        $input['stack_trace'] ?? null,
        $jsFileInfo
    );
    
    if ($logId) {
        echo "✅ Log inserido. ID: $logId\n";
    } else {
        echo "❌ Inserção falhou\n";
        exit(1);
    }
    
} catch (Exception $e) {
    echo "❌ Erro: " . $e->getMessage() . "\n";
    echo "📍 " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "📍 Stack:\n" . $e->getTraceAsString() . "\n";
    exit(1);
} catch (Error $e) {
    echo "❌ Erro fatal: " . $e->getMessage() . "\n";
    echo "📍 " . $e->getFile() . ":" . $e->getLine() . "\n";
    exit(1);
}

echo "\n=== TESTE CONCLUÍDO COM SUCESSO ===\n";

