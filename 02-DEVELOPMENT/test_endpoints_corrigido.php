<?php
/**
 * TEST_ENDPOINTS_CORRIGIDO.PHP
 * 
 * Teste corrigido dos endpoints baseado em como o JavaScript realmente os chama:
 * - cpf-validate.php: POST com { "cpf": "..." }
 * - add_flyingdonkeys.php: POST com estrutura Webflow API V2 correta
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/plain');

echo "==========================================" . PHP_EOL;
echo "TESTE CORRIGIDO DE ENDPOINTS" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$baseUrl = getBaseUrl();
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
$resultados = [];
$erros = [];

// Função para testar endpoint exatamente como o JavaScript faz
function testarEndpointJS($nome, $url, $data, $headers = []) {
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

// ==================== TESTE 1: cpf-validate.php (Como o JavaScript chama) ====================
echo "TESTE 1: cpf-validate.php (Formato JavaScript)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

// Formato exato do FooterCodeSiteDefinitivoCompleto.js linha 977
$url = $baseUrl . '/cpf-validate.php';
$data = ['cpf' => '12345678900']; // CPF de teste

echo "Enviando: " . json_encode($data) . PHP_EOL;
$resultado = testarEndpointJS('cpf-validate.php', $url, $data);

echo "HTTP Code: {$resultado['http_code']}" . PHP_EOL;
if (isset($resultado['response_data'])) {
    echo "Response: " . json_encode($resultado['response_data'], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . PHP_EOL;
}

if ($resultado['http_code'] === 200 && isset($resultado['response_data']['success'])) {
    echo "✅ cpf-validate.php: FUNCIONANDO" . PHP_EOL;
    $resultados['cpf_validate'] = $resultado;
} elseif ($resultado['http_code'] === 400) {
    // HTTP 400 pode ser esperado se CPF não existe na base ou API retornou erro
    echo "⚠️  cpf-validate.php: HTTP 400 (pode ser esperado se CPF não existe)" . PHP_EOL;
    if (isset($resultado['response_data']['error'])) {
        echo "   Erro: " . $resultado['response_data']['error'] . PHP_EOL;
    }
    $erros['cpf_validate'] = $resultado;
} else {
    echo "❌ cpf-validate.php: FALHA" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    $erros['cpf_validate'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 2: add_flyingdonkeys.php (Como o Modal JavaScript chama) ====================
echo "TESTE 2: add_flyingdonkeys.php (Formato Modal JavaScript)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

// Formato exato do MODAL_WHATSAPP_DEFINITIVO.js
// O modal envia um objeto direto, não uma string JSON dupla
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
        'GCLID_FLD' => 'test-gclid-' . time()
    ]
];

// Também testar formato Webflow API V2 (com payload)
$dadosFlyingDonkeysV2 = [
    'payload' => [
        'name' => 'Formulário de Teste',
        'data' => [
            'NOME' => 'Maria Santos Teste',
            'Email' => 'maria.santos.teste@example.com',
            'DDD-CELULAR' => '21',
            'CELULAR' => '987654321',
            'CPF' => '12345678900',
            'CEP' => '20040-020',
            'MARCA' => 'Toyota',
            'PLACA' => 'XYZ9876',
            'ANO' => '2021',
            'GCLID_FLD' => 'test-gclid-v2-' . time()
        ]
    ]
];

$url = $baseUrl . '/add_flyingdonkeys.php';
$logFileAntes = $logDir . '/flyingdonkeys_dev.txt';
$linhasAntes = file_exists($logFileAntes) ? count(file($logFileAntes)) : 0;

// Teste 2.1: Formato direto (sem payload)
echo "Teste 2.1: Formato direto (sem payload)" . PHP_EOL;
echo "Enviando: " . json_encode($dadosFlyingDonkeys, JSON_PRETTY_PRINT) . PHP_EOL;
$resultado1 = testarEndpointJS('add_flyingdonkeys.php', $url, $dadosFlyingDonkeys, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
]);

echo "HTTP Code: {$resultado1['http_code']}" . PHP_EOL;
if (isset($resultado1['response_data'])) {
    echo "Response: " . json_encode($resultado1['response_data'], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . PHP_EOL;
}

// Verificar logs
$linhasDepois = file_exists($logFileAntes) ? count(file($logFileAntes)) : 0;
$novasLinhas = $linhasDepois - $linhasAntes;

if ($resultado1['http_code'] === 200 && (isset($resultado1['response_data']['success']) || isset($resultado1['response_data']['status']) && $resultado1['response_data']['status'] === 'success')) {
    echo "✅ add_flyingdonkeys.php (formato direto): FUNCIONANDO" . PHP_EOL;
    if (isset($resultado1['response_data']['data']['leadIdFlyingDonkeys'])) {
        echo "   Lead ID: " . $resultado1['response_data']['data']['leadIdFlyingDonkeys'] . PHP_EOL;
    }
    echo "   Logs: $novasLinhas nova(s) linha(s)" . PHP_EOL;
    $resultados['add_flyingdonkeys_direto'] = $resultado1;
} else {
    echo "❌ add_flyingdonkeys.php (formato direto): FALHA" . PHP_EOL;
    if (isset($resultado1['response_data']['error'])) {
        echo "   Erro: " . $resultado1['response_data']['error'] . PHP_EOL;
    }
    echo "   Logs: $novasLinhas nova(s) linha(s)" . PHP_EOL;
    if ($novasLinhas > 0) {
        $ultimasLinhas = array_slice(file($logFileAntes), -min(3, $novasLinhas));
        echo "   Últimas linhas do log:" . PHP_EOL;
        foreach ($ultimasLinhas as $linha) {
            if (!empty(trim($linha))) {
                echo "     - " . substr(trim($linha), 0, 150) . PHP_EOL;
            }
        }
    }
    $erros['add_flyingdonkeys_direto'] = $resultado1;
}
echo PHP_EOL;

// Teste 2.2: Formato Webflow API V2 (com payload)
echo "Teste 2.2: Formato Webflow API V2 (com payload)" . PHP_EOL;
$linhasAntes = file_exists($logFileAntes) ? count(file($logFileAntes)) : 0;
echo "Enviando: " . json_encode($dadosFlyingDonkeysV2, JSON_PRETTY_PRINT) . PHP_EOL;
$resultado2 = testarEndpointJS('add_flyingdonkeys.php', $url, $dadosFlyingDonkeysV2, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
]);

echo "HTTP Code: {$resultado2['http_code']}" . PHP_EOL;
if (isset($resultado2['response_data'])) {
    echo "Response: " . json_encode($resultado2['response_data'], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . PHP_EOL;
}

// Verificar logs
$linhasDepois = file_exists($logFileAntes) ? count(file($logFileAntes)) : 0;
$novasLinhas = $linhasDepois - $linhasAntes;

if ($resultado2['http_code'] === 200 && (isset($resultado2['response_data']['success']) || (isset($resultado2['response_data']['status']) && $resultado2['response_data']['status'] === 'success'))) {
    echo "✅ add_flyingdonkeys.php (formato V2): FUNCIONANDO" . PHP_EOL;
    if (isset($resultado2['response_data']['data']['leadIdFlyingDonkeys'])) {
        echo "   Lead ID: " . $resultado2['response_data']['data']['leadIdFlyingDonkeys'] . PHP_EOL;
    }
    if (isset($resultado2['response_data']['data']['opportunityIdFlyingDonkeys'])) {
        echo "   Opportunity ID: " . $resultado2['response_data']['data']['opportunityIdFlyingDonkeys'] . PHP_EOL;
    }
    echo "   Logs: $novasLinhas nova(s) linha(s)" . PHP_EOL;
    $resultados['add_flyingdonkeys_v2'] = $resultado2;
} else {
    echo "❌ add_flyingdonkeys.php (formato V2): FALHA" . PHP_EOL;
    if (isset($resultado2['response_data']['error'])) {
        echo "   Erro: " . $resultado2['response_data']['error'] . PHP_EOL;
    }
    echo "   Logs: $novasLinhas nova(s) linha(s)" . PHP_EOL;
    if ($novasLinhas > 0) {
        $ultimasLinhas = array_slice(file($logFileAntes), -min(3, $novasLinhas));
        echo "   Últimas linhas do log:" . PHP_EOL;
        foreach ($ultimasLinhas as $linha) {
            if (!empty(trim($linha))) {
                echo "     - " . substr(trim($linha), 0, 150) . PHP_EOL;
            }
        }
    }
    $erros['add_flyingdonkeys_v2'] = $resultado2;
}
echo PHP_EOL;

// ==================== RESUMO ====================
echo "==========================================" . PHP_EOL;
echo "RESUMO DOS TESTES CORRIGIDOS" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$sucessos = count($resultados);
$falhas = count($erros);

echo "Testes realizados: 3" . PHP_EOL;
echo "Sucessos: $sucessos" . PHP_EOL;
echo "Falhas: $falhas" . PHP_EOL;
echo PHP_EOL;

if ($sucessos > 0) {
    echo "Testes com sucesso:" . PHP_EOL;
    foreach ($resultados as $teste => $resultado) {
        echo "  ✅ $teste (HTTP {$resultado['http_code']})" . PHP_EOL;
    }
    echo PHP_EOL;
}

if (count($erros) > 0) {
    echo "Testes com falha:" . PHP_EOL;
    foreach ($erros as $teste => $resultado) {
        echo "  ❌ $teste (HTTP {$resultado['http_code']})" . PHP_EOL;
        if (isset($resultado['response_data']['error'])) {
            echo "     Erro: " . $resultado['response_data']['error'] . PHP_EOL;
        }
    }
}

echo PHP_EOL;
echo "==========================================" . PHP_EOL;
echo "FIM DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;

