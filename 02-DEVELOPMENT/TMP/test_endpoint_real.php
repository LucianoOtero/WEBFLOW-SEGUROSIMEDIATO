<?php
/**
 * test_endpoint_real.php - Teste Real do log_endpoint.php
 * 
 * Simula exatamente o que o JavaScript está enviando
 */

// Simular requisição POST
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['REMOTE_ADDR'] = '191.9.24.241'; // IP real do usuário
$_SERVER['HTTP_USER_AGENT'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';
$_SERVER['HTTP_REFERER'] = 'https://segurosimediato-dev.webflow.io/?gclid=teste-dev-2511091520';

// Simular diferentes cenários de payload que podem estar causando erros

echo "=== TESTE REAL DO LOG_ENDPOINT.PHP ===\n\n";

// Teste 1: Payload válido (deve funcionar)
echo "TESTE 1: Payload válido\n";
$payload1 = [
    'level' => 'INFO',
    'message' => 'Teste válido',
    'category' => 'TEST',
    'data' => ['test' => true],
    'session_id' => 'sess_123',
    'url' => 'https://segurosimediato-dev.webflow.io/',
    'stack_trace' => null,
    'file_name' => 'test.js',
    'line_number' => 123
];

testPayload($payload1, "Teste 1");

// Teste 2: level undefined (deve retornar 400)
echo "\nTESTE 2: level undefined\n";
$payload2 = [
    'message' => 'Teste sem level',
    'category' => 'TEST'
];

testPayload($payload2, "Teste 2");

// Teste 3: message undefined (deve retornar 400)
echo "\nTESTE 3: message undefined\n";
$payload3 = [
    'level' => 'INFO',
    'category' => 'TEST'
];

testPayload($payload3, "Teste 3");

// Teste 4: level null (deve retornar 400)
echo "\nTESTE 4: level null\n";
$payload4 = [
    'level' => null,
    'message' => 'Teste com level null',
    'category' => 'TEST'
];

testPayload($payload4, "Teste 4");

// Teste 5: message vazio (deve retornar 400)
echo "\nTESTE 5: message vazio\n";
$payload5 = [
    'level' => 'INFO',
    'message' => '',
    'category' => 'TEST'
];

testPayload($payload5, "Teste 5");

// Teste 6: level inválido (deve retornar 400)
echo "\nTESTE 6: level inválido\n";
$payload6 = [
    'level' => 'INVALID',
    'message' => 'Teste com level inválido',
    'category' => 'TEST'
];

testPayload($payload6, "Teste 6");

// Teste 7: Payload como o JavaScript envia (com todos os campos)
echo "\nTESTE 7: Payload completo como JavaScript\n";
$payload7 = [
    'level' => 'DEBUG',
    'category' => null,
    'message' => '🔍 Funções de debug disponíveis:',
    'data' => null,
    'session_id' => 'sess_1762654395625_3vzleofbj',
    'url' => 'https://segurosimediato-dev.webflow.io/?gclid=teste-dev-2511091520',
    'stack_trace' => "Error\n    at sendLogToProfessionalSystem (FooterCodeSiteDefinitivoCompleto.js:379:17)\n    at window.logUnified (FooterCodeSiteDefinitivoCompleto.js:474:17)",
    'file_name' => 'FooterCodeSiteDefinitivoCompleto.js',
    'file_path' => 'https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js',
    'line_number' => 379,
    'function_name' => 'sendLogToProfessionalSystem'
];

testPayload($payload7, "Teste 7");

function testPayload($payload, $testName) {
    // Simular file_get_contents('php://input')
    $jsonPayload = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    
    // Capturar output do log_endpoint.php
    ob_start();
    
    // Simular variáveis globais
    $_POST = [];
    $_GET = [];
    $_ENV['PHP_ENV'] = 'development';
    
    // Incluir log_endpoint.php mas interceptar file_get_contents('php://input')
    // Não podemos realmente interceptar, então vamos testar diretamente a lógica
    
    // Ler o arquivo log_endpoint.php e executar a lógica
    $logEndpointPath = __DIR__ . '/log_endpoint.php';
    
    // Fazer requisição HTTP real usando curl
    $ch = curl_init('http://localhost/log_endpoint.php');
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonPayload);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Content-Length: ' . strlen($jsonPayload)
    ]);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, true);
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
    $body = substr($response, $headerSize);
    
    curl_close($ch);
    
    echo "   HTTP Code: $httpCode\n";
    echo "   Response: " . substr($body, 0, 200) . "\n";
    
    if ($httpCode === 200) {
        echo "   ✅ SUCESSO\n";
    } else {
        echo "   ❌ ERRO\n";
        $decoded = json_decode($body, true);
        if ($decoded) {
            echo "   Erro: " . ($decoded['error'] ?? 'Unknown') . "\n";
            if (isset($decoded['debug'])) {
                echo "   Debug: " . json_encode($decoded['debug'], JSON_PRETTY_PRINT) . "\n";
            }
        }
    }
}

echo "\n=== TESTES CONCLUÍDOS ===\n";

