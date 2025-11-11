<?php
/**
 * TEST_SECRET_KEYS.PHP
 * 
 * Teste para verificar se os endpoints funcionam COM e SEM secret keys:
 * - add_flyingdonkeys.php (com e sem X-Webflow-Signature)
 * - add_webflow_octa.php (com e sem X-Webflow-Signature)
 * 
 * IMPORTANTE: Não modifica os endpoints, apenas testa ambos os cenários
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/plain');

echo "==========================================" . PHP_EOL;
echo "TESTE: ENDPOINTS COM E SEM SECRET KEYS" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$baseUrl = getBaseUrl();
$resultados = [];

// Função para testar endpoint
function testarEndpoint($nome, $url, $data, $headers = []) {
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
    curl_setopt($ch, CURLOPT_TIMEOUT, 30);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    
    $headerArray = ['Content-Type: application/json'];
    foreach ($headers as $key => $value) {
        $headerArray[] = "$key: $value";
    }
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headerArray);
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $error = curl_error($ch);
    curl_close($ch);
    
    $responseData = json_decode($response, true);
    
    return [
        'success' => $httpCode >= 200 && $httpCode < 300 && empty($error),
        'http_code' => $httpCode,
        'response' => $response,
        'response_data' => $responseData,
        'error' => $error
    ];
}

// ==================== TESTE 1: add_flyingdonkeys.php SEM SECRET KEY ====================
echo "TESTE 1: add_flyingdonkeys.php SEM Secret Key (requisição do navegador/modal)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$dadosFlyingDonkeys = [
    'name' => 'Formulário de Teste',
    'data' => [
        'NOME' => 'João Silva Teste',
        'Email' => 'joao.silva.teste@example.com',
        'DDD-CELULAR' => '11',
        'CELULAR' => '987654321',
        'CPF' => '12345678900',
        'CEP' => '01310-100',
        'MARCA' => 'Honda',
        'PLACA' => 'ABC1234',
        'ANO' => '2020',
        'GCLID_FLD' => 'test-gclid-sem-secret-' . time()
    ]
];

$url = $baseUrl . '/add_flyingdonkeys.php';
$resultado1 = testarEndpoint('add_flyingdonkeys.php (sem secret)', $url, $dadosFlyingDonkeys, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
    // NÃO incluir X-Webflow-Signature e X-Webflow-Timestamp
]);

if ($resultado1['http_code'] === 200 && (isset($resultado1['response_data']['status']) && $resultado1['response_data']['status'] === 'success')) {
    echo "✅ add_flyingdonkeys.php SEM secret key: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado1['http_code']}" . PHP_EOL;
    if (isset($resultado1['response_data']['data']['leadIdFlyingDonkeys'])) {
        echo "   Lead ID: " . $resultado1['response_data']['data']['leadIdFlyingDonkeys'] . PHP_EOL;
    }
    $resultados['flyingdonkeys_sem_secret'] = true;
} else {
    echo "❌ add_flyingdonkeys.php SEM secret key: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado1['http_code']}" . PHP_EOL;
    if (isset($resultado1['response_data']['error'])) {
        echo "   Erro: " . $resultado1['response_data']['error'] . PHP_EOL;
    }
    $resultados['flyingdonkeys_sem_secret'] = false;
}
echo PHP_EOL;

// ==================== TESTE 2: add_flyingdonkeys.php COM SECRET KEY ====================
echo "TESTE 2: add_flyingdonkeys.php COM Secret Key (requisição do Webflow)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$webflowSecret = getWebflowSecretFlyingDonkeys();
$timestamp = time();
$payload = json_encode($dadosFlyingDonkeys);
$signature = hash_hmac('sha256', $timestamp . ':' . $payload, $webflowSecret);

$resultado2 = testarEndpoint('add_flyingdonkeys.php (com secret)', $url, $dadosFlyingDonkeys, [
    'Origin' => 'https://segurosimediato-dev.webflow.io',
    'X-Webflow-Signature' => $signature,
    'X-Webflow-Timestamp' => (string)$timestamp
]);

if ($resultado2['http_code'] === 200 && (isset($resultado2['response_data']['status']) && $resultado2['response_data']['status'] === 'success')) {
    echo "✅ add_flyingdonkeys.php COM secret key: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado2['http_code']}" . PHP_EOL;
    if (isset($resultado2['response_data']['data']['leadIdFlyingDonkeys'])) {
        echo "   Lead ID: " . $resultado2['response_data']['data']['leadIdFlyingDonkeys'] . PHP_EOL;
    }
    $resultados['flyingdonkeys_com_secret'] = true;
} elseif ($resultado2['http_code'] === 401) {
    echo "⚠️  add_flyingdonkeys.php COM secret key: HTTP 401 (signature inválida)" . PHP_EOL;
    echo "   Isso pode indicar problema na secret key ou na geração da signature" . PHP_EOL;
    $resultados['flyingdonkeys_com_secret'] = false;
} else {
    echo "❌ add_flyingdonkeys.php COM secret key: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado2['http_code']}" . PHP_EOL;
    if (isset($resultado2['response_data']['error'])) {
        echo "   Erro: " . $resultado2['response_data']['error'] . PHP_EOL;
    }
    $resultados['flyingdonkeys_com_secret'] = false;
}
echo PHP_EOL;

// ==================== TESTE 3: add_webflow_octa.php SEM SECRET KEY ====================
echo "TESTE 3: add_webflow_octa.php SEM Secret Key (requisição do navegador/modal)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$dadosOctaDesk = [
    'payload' => [
        'name' => 'Formulário de Teste',
        'data' => [
            'name' => 'Maria Santos Teste',
            'email' => 'maria.santos.teste@example.com',
            'DDD-CELULAR' => '21',
            'CELULAR' => '987654321',
            'CPF' => '12345678900',
            'CEP' => '20040-020',
            'PLACA' => 'XYZ9876',
            'MARCA' => 'Toyota',
            'ANO' => '2021',
            'GCLID_FLD' => 'test-gclid-octa-sem-secret-' . time()
        ]
    ]
];

$url = $baseUrl . '/add_webflow_octa.php';
$resultado3 = testarEndpoint('add_webflow_octa.php (sem secret)', $url, $dadosOctaDesk, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
    // NÃO incluir X-Webflow-Signature e X-Webflow-Timestamp
]);

if ($resultado3['http_code'] === 200 && (isset($resultado3['response_data']['success']) && $resultado3['response_data']['success'] === true)) {
    echo "✅ add_webflow_octa.php SEM secret key: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado3['http_code']}" . PHP_EOL;
    $resultados['octadesk_sem_secret'] = true;
} else {
    echo "❌ add_webflow_octa.php SEM secret key: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado3['http_code']}" . PHP_EOL;
    if (isset($resultado3['response_data']['error'])) {
        echo "   Erro: " . $resultado3['response_data']['error'] . PHP_EOL;
    }
    $resultados['octadesk_sem_secret'] = false;
}
echo PHP_EOL;

// ==================== TESTE 4: add_webflow_octa.php COM SECRET KEY ====================
echo "TESTE 4: add_webflow_octa.php COM Secret Key (requisição do Webflow)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$webflowSecretOcta = getWebflowSecretOctaDesk();
$timestamp = time();
$payload = json_encode($dadosOctaDesk);
$signature = hash_hmac('sha256', $timestamp . ':' . $payload, $webflowSecretOcta);

$resultado4 = testarEndpoint('add_webflow_octa.php (com secret)', $url, $dadosOctaDesk, [
    'Origin' => 'https://segurosimediato-dev.webflow.io',
    'X-Webflow-Signature' => $signature,
    'X-Webflow-Timestamp' => (string)$timestamp
]);

if ($resultado4['http_code'] === 200 && (isset($resultado4['response_data']['success']) && $resultado4['response_data']['success'] === true)) {
    echo "✅ add_webflow_octa.php COM secret key: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado4['http_code']}" . PHP_EOL;
    $resultados['octadesk_com_secret'] = true;
} elseif ($resultado4['http_code'] === 401) {
    echo "⚠️  add_webflow_octa.php COM secret key: HTTP 401 (signature inválida)" . PHP_EOL;
    echo "   Isso pode indicar problema na secret key ou na geração da signature" . PHP_EOL;
    $resultados['octadesk_com_secret'] = false;
} else {
    echo "❌ add_webflow_octa.php COM secret key: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado4['http_code']}" . PHP_EOL;
    if (isset($resultado4['response_data']['error'])) {
        echo "   Erro: " . $resultado4['response_data']['error'] . PHP_EOL;
    }
    $resultados['octadesk_com_secret'] = false;
}
echo PHP_EOL;

// ==================== VERIFICAÇÃO DAS SECRET KEYS ====================
echo "VERIFICAÇÃO DAS SECRET KEYS CONFIGURADAS" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;
echo "WEBFLOW_SECRET_FLYINGDONKEYS: " . substr(getWebflowSecretFlyingDonkeys(), 0, 16) . '...' . PHP_EOL;
echo "WEBFLOW_SECRET_OCTADESK: " . substr(getWebflowSecretOctaDesk(), 0, 16) . '...' . PHP_EOL;
echo PHP_EOL;

// ==================== RESUMO ====================
echo "==========================================" . PHP_EOL;
echo "RESUMO DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$totalTestes = count($resultados);
$sucessos = count(array_filter($resultados));

echo "Testes realizados: $totalTestes" . PHP_EOL;
echo "Sucessos: $sucessos" . PHP_EOL;
echo "Falhas: " . ($totalTestes - $sucessos) . PHP_EOL;
echo PHP_EOL;

echo "Resultados detalhados:" . PHP_EOL;
foreach ($resultados as $teste => $sucesso) {
    $status = $sucesso ? '✅' : '❌';
    echo "  $status $teste" . PHP_EOL;
}

echo PHP_EOL;
echo "==========================================" . PHP_EOL;
echo "FIM DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;

