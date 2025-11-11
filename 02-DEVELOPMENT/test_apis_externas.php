<?php
/**
 * TEST_APIS_EXTERNAS.PHP
 * 
 * Teste de conexão com APIs externas:
 * - API PH3A (cpf-validate.php)
 * - EspoCRM/FlyingDonkeys (add_flyingdonkeys.php)
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/plain');

echo "==========================================" . PHP_EOL;
echo "TESTE DE CONEXÃO COM APIs EXTERNAS" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

// ==================== TESTE 1: API PH3A ====================
echo "TESTE 1: API PH3A (cpf-validate.php)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$username = 'alex.kaminski@imediatoseguros.com.br';
$password = 'ImdSeg2025$$';

echo "1.1. Testando login na API PH3A..." . PHP_EOL;
$login_url = "https://api.ph3a.com.br/DataBusca/api/Account/Login";
$login_data = json_encode([
    "UserName" => $username,
    "Password" => $password
]);

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $login_url);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $login_data);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);

$login_response = curl_exec($ch);
$login_http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$login_error = curl_error($ch);
curl_close($ch);

if ($login_response === false || !empty($login_error)) {
    echo "❌ Erro de conexão: $login_error" . PHP_EOL;
} elseif ($login_http_code !== 200) {
    echo "❌ HTTP Code: $login_http_code" . PHP_EOL;
    echo "Response: " . substr($login_response, 0, 200) . PHP_EOL;
} else {
    $login_data = json_decode($login_response, true);
    if ($login_data && $login_data['success'] && isset($login_data['data']['Token'])) {
        echo "✅ Login bem-sucedido!" . PHP_EOL;
        echo "   Token obtido: " . substr($login_data['data']['Token'], 0, 20) . "..." . PHP_EOL;
        
        // Testar consulta de CPF
        echo PHP_EOL;
        echo "1.2. Testando consulta de CPF..." . PHP_EOL;
        $token = $login_data['data']['Token'];
        $data_url = "https://api.ph3a.com.br/DataBusca/data";
        $data_body = json_encode([
            "Document" => "12345678900",
            "Type" => 0,
            "HashType" => 0,
            "Rules" => [
                "Phones.Limit" => 3,
                "Phones.History" => false,
                "Phones.Rank" => 90
            ]
        ]);
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $data_url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data_body);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            "Content-Type: application/json",
            "Token: " . $token
        ]);
        
        $data_response = curl_exec($ch);
        $data_http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $data_error = curl_error($ch);
        curl_close($ch);
        
        if ($data_response === false || !empty($data_error)) {
            echo "❌ Erro na consulta: $data_error" . PHP_EOL;
        } elseif ($data_http_code !== 200) {
            echo "⚠️  HTTP Code: $data_http_code" . PHP_EOL;
            echo "Response: " . substr($data_response, 0, 200) . PHP_EOL;
            if ($data_http_code === 400) {
                echo "   (HTTP 400 pode ser esperado se CPF não existe na base)" . PHP_EOL;
            }
        } else {
            $api_data = json_decode($data_response, true);
            if ($api_data && isset($api_data['Data'])) {
                echo "✅ Consulta bem-sucedida!" . PHP_EOL;
                echo "   Nome: " . ($api_data['Data']['NameBrasil'] ?? 'N/A') . PHP_EOL;
            } else {
                echo "⚠️  CPF não encontrado na base de dados" . PHP_EOL;
            }
        }
    } else {
        echo "❌ Falha no login: " . ($login_data['message'] ?? 'Erro desconhecido') . PHP_EOL;
    }
}
echo PHP_EOL;

// ==================== TESTE 2: EspoCRM/FlyingDonkeys ====================
echo "TESTE 2: EspoCRM/FlyingDonkeys (add_flyingdonkeys.php)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

try {
    $espocrm_url = getEspoCrmUrl();
    $espocrm_api_key = getEspoCrmApiKey();
    
    echo "2.1. Verificando configuração..." . PHP_EOL;
    echo "   URL: $espocrm_url" . PHP_EOL;
    echo "   API Key: " . (empty($espocrm_api_key) ? '❌ NÃO DEFINIDO' : '✅ DEFINIDO (' . substr($espocrm_api_key, 0, 8) . '...)') . PHP_EOL;
    
    if (empty($espocrm_api_key)) {
        echo "❌ API Key não está definida!" . PHP_EOL;
    } else {
        echo PHP_EOL;
        echo "2.2. Testando conexão com EspoCRM..." . PHP_EOL;
        
        require_once __DIR__ . '/class.php';
        $client = new EspoApiClient($espocrm_url);
        $client->setApiKey($espocrm_api_key);
        
        // Testar GET simples
        try {
            $test_url = $espocrm_url . '/api/v1/Lead?maxSize=1';
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $test_url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_TIMEOUT, 10);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                "X-Api-Key: " . $espocrm_api_key,
                "Content-Type: application/json"
            ]);
            
            $response = curl_exec($ch);
            $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            curl_close($ch);
            
            if ($response === false || !empty($error)) {
                echo "❌ Erro de conexão: $error" . PHP_EOL;
            } elseif ($http_code === 200) {
                echo "✅ Conexão com EspoCRM bem-sucedida!" . PHP_EOL;
            } elseif ($http_code === 401) {
                echo "❌ Erro de autenticação (401) - API Key inválida" . PHP_EOL;
            } elseif ($http_code === 403) {
                echo "❌ Acesso negado (403) - Verificar permissões" . PHP_EOL;
            } else {
                echo "⚠️  HTTP Code: $http_code" . PHP_EOL;
                echo "Response: " . substr($response, 0, 200) . PHP_EOL;
            }
        } catch (Exception $e) {
            echo "❌ Exceção: " . $e->getMessage() . PHP_EOL;
        }
        
        // Testar class.php diretamente
        echo PHP_EOL;
        echo "2.3. Testando class.php..." . PHP_EOL;
        try {
            // Tentar fazer uma requisição simples via class.php
            $result = $client->request('GET', 'Lead', ['maxSize' => 1]);
            if (isset($result['list'])) {
                echo "✅ class.php funcionando corretamente!" . PHP_EOL;
                echo "   Leads encontrados: " . count($result['list']) . PHP_EOL;
            } else {
                echo "⚠️  Resposta inesperada do EspoCRM" . PHP_EOL;
            }
        } catch (Exception $e) {
            echo "❌ Erro em class.php: " . $e->getMessage() . PHP_EOL;
            echo "   Arquivo: " . $e->getFile() . PHP_EOL;
            echo "   Linha: " . $e->getLine() . PHP_EOL;
        }
    }
} catch (Exception $e) {
    echo "❌ Erro ao testar EspoCRM: " . $e->getMessage() . PHP_EOL;
}
echo PHP_EOL;

// ==================== RESUMO ====================
echo "==========================================" . PHP_EOL;
echo "FIM DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;

