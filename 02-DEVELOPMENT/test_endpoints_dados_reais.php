<?php
/**
 * TEST_ENDPOINTS_DADOS_REAIS.PHP
 * 
 * Teste completo dos endpoints com dados reais:
 * - add_flyingdonkeys.php
 * - cpf-validate.php
 * - add_webflow_octa.php
 * 
 * Valida logs após cada teste
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/plain');

echo "==========================================" . PHP_EOL;
echo "TESTE DE ENDPOINTS COM DADOS REAIS" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$baseUrl = getBaseUrl();
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
$resultados = [];
$erros = [];

// Função para testar endpoint com dados reais
function testarEndpointReal($nome, $url, $data, $headers = []) {
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

// Função para ler últimas linhas do log
function lerUltimasLinhasLog($arquivo, $linhas = 10) {
    if (!file_exists($arquivo)) {
        return [];
    }
    $content = file_get_contents($arquivo);
    $lines = explode("\n", $content);
    return array_slice($lines, -$linhas);
}

// ==================== TESTE 1: cpf-validate.php ====================
echo "TESTE 1: cpf-validate.php (Validação de CPF Real)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

// CPF de teste (não usar CPF real em produção)
$cpfTeste = '12345678900'; // CPF de teste

$url = $baseUrl . '/cpf-validate.php';
$data = ['cpf' => $cpfTeste];

echo "Enviando CPF: $cpfTeste" . PHP_EOL;
$resultado = testarEndpointReal('cpf-validate.php', $url, $data);

if ($resultado['success'] || ($resultado['http_code'] === 200 && isset($resultado['response_data']['success']))) {
    echo "✅ cpf-validate.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    if (isset($resultado['response_data']['success'])) {
        echo "   Success: " . ($resultado['response_data']['success'] ? 'SIM' : 'NAO') . PHP_EOL;
        if (isset($resultado['response_data']['data']['nome'])) {
            echo "   Nome encontrado: " . $resultado['response_data']['data']['nome'] . PHP_EOL;
        }
    }
    $resultados['cpf_validate'] = $resultado;
} else {
    echo "❌ cpf-validate.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    if (isset($resultado['response_data']['error'])) {
        echo "   Mensagem: " . $resultado['response_data']['error'] . PHP_EOL;
    }
    $erros['cpf_validate'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 2: add_flyingdonkeys.php ====================
echo "TESTE 2: add_flyingdonkeys.php (Integração FlyingDonkeys com Dados Reais)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

// Dados reais de teste (estrutura Webflow API V2)
$dadosFlyingDonkeys = [
    'payload' => json_encode([
        'data' => json_encode([
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
        ])
    ])
];

$url = $baseUrl . '/add_flyingdonkeys.php';
$logFileAntes = $logDir . '/flyingdonkeys_dev.txt';
$linhasAntes = file_exists($logFileAntes) ? count(file($logFileAntes)) : 0;

echo "Enviando dados para FlyingDonkeys..." . PHP_EOL;
$resultado = testarEndpointReal('add_flyingdonkeys.php', $url, $dadosFlyingDonkeys, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
]);

// Verificar logs
$linhasDepois = file_exists($logFileAntes) ? count(file($logFileAntes)) : 0;
$novasLinhas = $linhasDepois - $linhasAntes;

if ($resultado['success'] || ($resultado['http_code'] === 200 && isset($resultado['response_data']['success']))) {
    echo "✅ add_flyingdonkeys.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    if (isset($resultado['response_data']['success'])) {
        echo "   Success: " . ($resultado['response_data']['success'] ? 'SIM' : 'NAO') . PHP_EOL;
    }
    echo "   Logs: $novasLinhas nova(s) linha(s) adicionada(s)" . PHP_EOL;
    if ($novasLinhas > 0) {
        $ultimasLinhas = lerUltimasLinhasLog($logFileAntes, min(3, $novasLinhas));
        echo "   Últimas linhas do log:" . PHP_EOL;
        foreach ($ultimasLinhas as $linha) {
            if (!empty(trim($linha))) {
                echo "     - " . substr($linha, 0, 100) . (strlen($linha) > 100 ? '...' : '') . PHP_EOL;
            }
        }
    }
    $resultados['add_flyingdonkeys'] = $resultado;
} else {
    echo "❌ add_flyingdonkeys.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    if (isset($resultado['response_data']['error'])) {
        echo "   Mensagem: " . $resultado['response_data']['error'] . PHP_EOL;
    }
    echo "   Logs: $novasLinhas nova(s) linha(s) adicionada(s)" . PHP_EOL;
    if ($novasLinhas > 0) {
        $ultimasLinhas = lerUltimasLinhasLog($logFileAntes, min(3, $novasLinhas));
        echo "   Últimas linhas do log:" . PHP_EOL;
        foreach ($ultimasLinhas as $linha) {
            if (!empty(trim($linha))) {
                echo "     - " . substr($linha, 0, 100) . (strlen($linha) > 100 ? '...' : '') . PHP_EOL;
            }
        }
    }
    $erros['add_flyingdonkeys'] = $resultado;
}
echo PHP_EOL;

// ==================== TESTE 3: add_webflow_octa.php ====================
echo "TESTE 3: add_webflow_octa.php (Integração OctaDesk com Dados Reais)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

// Dados reais de teste (estrutura Webflow API V2)
$dadosOctaDesk = [
    'payload' => [
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
            'GCLID_FLD' => 'test-gclid-octa-' . time()
        ],
        'name' => 'Formulário de Teste'
    ]
];

$url = $baseUrl . '/add_webflow_octa.php';
$logFileAntes = $logDir . '/webhook_octadesk_prod.txt';
$linhasAntes = file_exists($logFileAntes) ? count(file($logFileAntes)) : 0;

echo "Enviando dados para OctaDesk..." . PHP_EOL;
$resultado = testarEndpointReal('add_webflow_octa.php', $url, $dadosOctaDesk, [
    'Origin' => 'https://segurosimediato-dev.webflow.io'
]);

// Verificar logs
$linhasDepois = file_exists($logFileAntes) ? count(file($logFileAntes)) : 0;
$novasLinhas = $linhasDepois - $linhasAntes;

if ($resultado['success'] || ($resultado['http_code'] === 200 && isset($resultado['response_data']['success']))) {
    echo "✅ add_webflow_octa.php: FUNCIONANDO" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    if (isset($resultado['response_data']['success'])) {
        echo "   Success: " . ($resultado['response_data']['success'] ? 'SIM' : 'NAO') . PHP_EOL;
    }
    echo "   Logs: $novasLinhas nova(s) linha(s) adicionada(s)" . PHP_EOL;
    if ($novasLinhas > 0) {
        $ultimasLinhas = lerUltimasLinhasLog($logFileAntes, min(3, $novasLinhas));
        echo "   Últimas linhas do log:" . PHP_EOL;
        foreach ($ultimasLinhas as $linha) {
            if (!empty(trim($linha))) {
                echo "     - " . substr($linha, 0, 100) . (strlen($linha) > 100 ? '...' : '') . PHP_EOL;
            }
        }
    }
    $resultados['add_webflow_octa'] = $resultado;
} else {
    echo "❌ add_webflow_octa.php: FALHA" . PHP_EOL;
    echo "   HTTP Code: {$resultado['http_code']}" . PHP_EOL;
    echo "   Erro: {$resultado['error']}" . PHP_EOL;
    if (isset($resultado['response_data']['error'])) {
        echo "   Mensagem: " . $resultado['response_data']['error'] . PHP_EOL;
    }
    echo "   Logs: $novasLinhas nova(s) linha(s) adicionada(s)" . PHP_EOL;
    if ($novasLinhas > 0) {
        $ultimasLinhas = lerUltimasLinhasLog($logFileAntes, min(3, $novasLinhas));
        echo "   Últimas linhas do log:" . PHP_EOL;
        foreach ($ultimasLinhas as $linha) {
            if (!empty(trim($linha))) {
                echo "     - " . substr($linha, 0, 100) . (strlen($linha) > 100 ? '...' : '') . PHP_EOL;
            }
        }
    }
    $erros['add_webflow_octa'] = $resultado;
}
echo PHP_EOL;

// ==================== RESUMO ====================
echo "==========================================" . PHP_EOL;
echo "RESUMO DOS TESTES COM DADOS REAIS" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$sucessos = count($resultados);
$falhas = count($erros);

echo "Endpoints testados: 3" . PHP_EOL;
echo "Sucessos: $sucessos" . PHP_EOL;
echo "Falhas: $falhas" . PHP_EOL;
echo PHP_EOL;

if ($sucessos === 3) {
    echo "✅ TODOS OS ENDPOINTS FUNCIONANDO COM DADOS REAIS!" . PHP_EOL;
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
            echo "  ❌ $endpoint (HTTP {$resultado['http_code']})" . PHP_EOL;
        }
    }
} else {
    echo "❌ NENHUM ENDPOINT FUNCIONOU" . PHP_EOL;
}

echo PHP_EOL;
echo "==========================================" . PHP_EOL;
echo "FIM DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;

