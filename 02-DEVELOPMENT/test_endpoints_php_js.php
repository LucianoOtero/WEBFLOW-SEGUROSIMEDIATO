<?php
/**
 * TEST_ENDPOINTS_PHP_JS.PHP
 * 
 * Teste completo para verificar se todos os endpoints PHP chamados por JavaScript
 * estão funcionando corretamente.
 * 
 * Endpoints testados:
 * 1. log_endpoint.php
 * 2. cpf-validate.php
 * 3. placa-validate.php
 * 4. add_flyingdonkeys.php
 * 5. add_webflow_octa.php
 * 6. send_email_notification_endpoint.php
 * 7. config_env.js.php
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/plain');

echo "==========================================" . PHP_EOL;
echo "TESTE DE ENDPOINTS PHP CHAMADOS POR JS" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$baseUrl = getBaseUrl();
$resultados = [];
$erros = [];

// Função helper para testar endpoint
function testarEndpoint($nome, $url, $method = 'GET', $data = null, $headers = []) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    
    if ($method === 'POST' && $data !== null) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        $headers['Content-Type'] = 'application/json';
    }
    
    if (!empty($headers)) {
        $headerArray = [];
        foreach ($headers as $key => $value) {
            $headerArray[] = "$key: $value";
        }
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headerArray);
    }
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    curl_close($ch);
    
    return [
        'success' => $httpCode >= 200 && $httpCode < 300 && empty($error),
        'http_code' => $httpCode,
        'response' => $response,
        'error' => $error
    ];
}

// ==================== TESTE 1: config_env.js.php ====================
echo "TESTE 1: config_env.js.php (Carregamento de Variáveis)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$url = $baseUrl . '/config_env.js.php';
$resultado = testarEndpoint('config_env.js.php', $url);

if ($resultado['success'] && strpos($resultado['response'], 'APP_BASE_URL') !== false) {
    echo "✅ config_env.js.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Variáveis expostas: " . (strpos($resultado['response'], 'window.APP_BASE_URL') !== false ? 'SIM' : 'NAO') . PHP_EOL;
    $resultados['config_env'] = $resultado;
} else {
    echo "❌ config_env.js.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    $erros['config_env'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 2: log_endpoint.php ====================
echo "TESTE 2: log_endpoint.php (Sistema de Logging)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$url = $baseUrl . '/log_endpoint.php';
$data = [
    'level' => 'INFO',
    'category' => 'TEST',
    'message' => 'Teste de endpoint log_endpoint.php',
    'data' => ['test' => true],
    'file_name' => 'test_endpoints_php_js.php',
    'line_number' => 100
];

$resultado = testarEndpoint('log_endpoint.php', $url, 'POST', $data);

if ($resultado['success']) {
    echo "✅ log_endpoint.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    $resultados['log_endpoint'] = $resultado;
} else {
    echo "❌ log_endpoint.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    $erros['log_endpoint'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 3: cpf-validate.php ====================
echo "TESTE 3: cpf-validate.php (Validação de CPF)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$url = $baseUrl . '/cpf-validate.php';
$data = ['cpf' => '12345678900']; // CPF de teste

$resultado = testarEndpoint('cpf-validate.php', $url, 'POST', $data);

if ($resultado['success']) {
    echo "✅ cpf-validate.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    $resultados['cpf_validate'] = $resultado;
} else {
    echo "❌ cpf-validate.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    $erros['cpf_validate'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 4: placa-validate.php ====================
echo "TESTE 4: placa-validate.php (Validação de Placa)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$url = $baseUrl . '/placa-validate.php';
$data = ['placa' => 'ABC1234']; // Placa de teste

$resultado = testarEndpoint('placa-validate.php', $url, 'POST', $data);

if ($resultado['success']) {
    echo "✅ placa-validate.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    $resultados['placa_validate'] = $resultado;
} else {
    echo "❌ placa-validate.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    $erros['placa_validate'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 5: add_flyingdonkeys.php ====================
echo "TESTE 5: add_flyingdonkeys.php (Integração FlyingDonkeys)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$url = $baseUrl . '/add_flyingdonkeys.php';
$data = [
    'name' => 'Teste Endpoint',
    'email' => 'teste@example.com',
    'phone' => '11987654321',
    'cpf' => '12345678900'
];

$resultado = testarEndpoint('add_flyingdonkeys.php', $url, 'POST', $data, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
]);

if ($resultado['success'] || $resultado['http_code'] === 200) {
    echo "✅ add_flyingdonkeys.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    $resultados['add_flyingdonkeys'] = $resultado;
} else {
    echo "❌ add_flyingdonkeys.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    $erros['add_flyingdonkeys'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 6: add_webflow_octa.php ====================
echo "TESTE 6: add_webflow_octa.php (Integração OctaDesk)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$url = $baseUrl . '/add_webflow_octa.php';
$data = [
    'name' => 'Teste OctaDesk',
    'email' => 'teste@example.com',
    'phone' => '11987654321'
];

$resultado = testarEndpoint('add_webflow_octa.php', $url, 'POST', $data, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
]);

if ($resultado['success'] || $resultado['http_code'] === 200) {
    echo "✅ add_webflow_octa.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    $resultados['add_webflow_octa'] = $resultado;
} else {
    echo "❌ add_webflow_octa.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    $erros['add_webflow_octa'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 7: send_email_notification_endpoint.php ====================
echo "TESTE 7: send_email_notification_endpoint.php (Envio de Email)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$url = $baseUrl . '/send_email_notification_endpoint.php';
$data = [
    'ddd' => '11',
    'celular' => '987654321',
    'nome' => 'Teste Email',
    'momento' => 'test',
    'momento_descricao' => 'Teste de Endpoint'
];

$resultado = testarEndpoint('send_email_notification_endpoint.php', $url, 'POST', $data, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
]);

if ($resultado['success'] || $resultado['http_code'] === 200) {
    echo "✅ send_email_notification_endpoint.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    $resultados['send_email'] = $resultado;
} else {
    echo "❌ send_email_notification_endpoint.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    $erros['send_email'] = $resultado;
}
echo PHP_EOL;

// ==================== RESUMO ====================
echo "==========================================" . PHP_EOL;
echo "RESUMO DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$sucessos = count($resultados);
$falhas = count($erros);

echo "Endpoints testados: 7" . PHP_EOL;
echo "Sucessos: $sucessos" . PHP_EOL;
echo "Falhas: $falhas" . PHP_EOL;
echo PHP_EOL;

if ($sucessos === 7) {
    echo "✅ TODOS OS ENDPOINTS FUNCIONANDO CORRETAMENTE!" . PHP_EOL;
} elseif ($sucessos > 0) {
    echo "⚠️  ALGUNS ENDPOINTS FUNCIONANDO" . PHP_EOL;
    echo PHP_EOL;
    echo "Endpoints com sucesso:" . PHP_EOL;
    foreach ($resultados as $endpoint => $resultado) {
        echo "  ✅ $endpoint (HTTP {$resultado['http_code']})" . PHP_EOL;
    }
    echo PHP_EOL;
    if (count($erros) > 0) {
        echo "Endpoints com falha:" . PHP_EOL;
        foreach ($erros as $endpoint => $resultado) {
            echo "  ❌ $endpoint (HTTP {$resultado['http_code']}): {$resultado['error']}" . PHP_EOL;
        }
    }
} else {
    echo "❌ NENHUM ENDPOINT FUNCIONOU" . PHP_EOL;
    echo PHP_EOL;
    echo "Erros encontrados:" . PHP_EOL;
    foreach ($erros as $endpoint => $resultado) {
        echo "  ❌ $endpoint: {$resultado['error']}" . PHP_EOL;
    }
}

echo PHP_EOL;
echo "==========================================" . PHP_EOL;
echo "FIM DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;

