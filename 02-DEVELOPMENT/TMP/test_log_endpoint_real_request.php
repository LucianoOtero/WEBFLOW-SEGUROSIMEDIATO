<?php
/**
 * test_log_endpoint_real_request.php
 * 
 * Simula exatamente uma requisição real do navegador
 */

// Simular variáveis de servidor
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['REMOTE_ADDR'] = '191.9.24.241';
$_SERVER['HTTP_USER_AGENT'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';
$_SERVER['HTTP_REFERER'] = 'https://segurosimediato-dev.webflow.io/?gclid=teste-dev-2511091520';
$_SERVER['HTTP_ORIGIN'] = 'https://segurosimediato-dev.webflow.io';
$_SERVER['REQUEST_URI'] = '/log_endpoint.php';
$_SERVER['SERVER_NAME'] = 'dev.bssegurosimediato.com.br';

// Simular payload exato que o JavaScript envia
$payload = [
    'level' => 'INFO',
    'category' => 'GCLID',
    'message' => '✅ Capturado da URL e salvo em cookie: teste-dev-2511091520',
    'data' => null,
    'session_id' => 'sess_1762654395625_3vzleofbj',
    'url' => 'https://segurosimediato-dev.webflow.io/?gclid=teste-dev-2511091520',
    'stack_trace' => null,
    'file_name' => null,
    'file_path' => null,
    'line_number' => null,
    'function_name' => null
];

// Simular file_get_contents('php://input')
$jsonPayload = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

echo "=== TESTE DE REQUISIÇÃO REAL ===\n\n";
echo "Payload JSON:\n";
echo $jsonPayload . "\n\n";

// Capturar output
ob_start();

// Incluir log_endpoint.php
// Mas precisamos interceptar file_get_contents('php://input')
// Vamos fazer de outra forma - criar um wrapper

// Salvar payload em arquivo temporário
$tempFile = sys_get_temp_dir() . '/test_log_payload_' . uniqid() . '.json';
file_put_contents($tempFile, $jsonPayload);

// Modificar temporariamente file_get_contents para ler do arquivo
// Não podemos fazer isso diretamente, então vamos testar a lógica manualmente

echo "Testando lógica do log_endpoint.php...\n\n";

// 1. Verificar JSON
$input = json_decode($jsonPayload, true);
if (!$input) {
    echo "❌ JSON inválido: " . json_last_error_msg() . "\n";
    exit(1);
}
echo "✅ JSON válido\n";

// 2. Verificar campos obrigatórios
if (!isset($input['level']) || $input['level'] === null || $input['level'] === '') {
    echo "❌ level faltando ou vazio\n";
    exit(1);
}
echo "✅ level presente: " . $input['level'] . "\n";

if (!isset($input['message']) || $input['message'] === null || $input['message'] === '') {
    echo "❌ message faltando ou vazio\n";
    exit(1);
}
echo "✅ message presente\n";

// 3. Validar nível
$validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'];
$level = is_string($input['level']) ? strtoupper(trim($input['level'])) : '';
if (empty($level) || !in_array($level, $validLevels)) {
    echo "❌ level inválido: " . $input['level'] . "\n";
    exit(1);
}
echo "✅ level válido: $level\n";

// 4. Testar ProfessionalLogger
require_once __DIR__ . '/ProfessionalLogger.php';

try {
    $logger = new ProfessionalLogger();
    echo "✅ ProfessionalLogger instanciado\n";
    
    // Testar conexão
    $conn = $logger->getConnection();
    if ($conn) {
        echo "✅ Conexão MySQL estabelecida\n";
    } else {
        echo "❌ Conexão MySQL FALHOU\n";
        exit(1);
    }
    
    // Testar inserção
    $jsFileInfo = [
        'file_name' => $input['file_name'] ?? null,
        'file_path' => $input['file_path'] ?? null,
        'line_number' => isset($input['line_number']) ? (int)$input['line_number'] : null,
        'function_name' => $input['function_name'] ?? null
    ];
    
    $logId = $logger->log(
        $level,
        $input['message'],
        $input['data'] ?? null,
        $input['category'] ?? null,
        $input['stack_trace'] ?? null,
        $jsFileInfo
    );
    
    if ($logId) {
        echo "✅ Log inserido com sucesso. ID: $logId\n";
    } else {
        echo "❌ Inserção FALHOU (retornou false)\n";
        exit(1);
    }
    
} catch (Exception $e) {
    echo "❌ Erro: " . $e->getMessage() . "\n";
    echo "📍 Arquivo: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "📍 Stack trace:\n" . $e->getTraceAsString() . "\n";
    exit(1);
} catch (Error $e) {
    echo "❌ Erro fatal: " . $e->getMessage() . "\n";
    echo "📍 Arquivo: " . $e->getFile() . ":" . $e->getLine() . "\n";
    exit(1);
}

echo "\n=== TESTE CONCLUÍDO COM SUCESSO ===\n";

