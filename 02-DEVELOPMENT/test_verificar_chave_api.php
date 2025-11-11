<?php
/**
 * TEST_VERIFICAR_CHAVE_API.PHP
 * 
 * Teste para verificar se a chave da API está configurada corretamente
 * para dev.flyingdonkeys.com.br
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/plain');

echo "==========================================" . PHP_EOL;
echo "VERIFICAÇÃO DA CHAVE DA API ESPOCRM" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

// Verificar ambiente
$is_dev = strpos($_SERVER['HTTP_HOST'] ?? '', 'dev.') !== false || 
          strpos($_SERVER['REQUEST_URI'] ?? '', '/dev/') !== false ||
          isset($_GET['dev']) || isset($_POST['dev']);

echo "1. DETECÇÃO DE AMBIENTE" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;
echo "Host: " . ($_SERVER['HTTP_HOST'] ?? 'N/A') . PHP_EOL;
echo "Ambiente detectado: " . ($is_dev ? 'DEV' : 'PROD') . PHP_EOL;
echo "isDevelopment(): " . (isDevelopment() ? 'SIM' : 'NAO') . PHP_EOL;
echo PHP_EOL;

// Verificar variáveis de ambiente
echo "2. VARIÁVEIS DE AMBIENTE" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;
echo "ESPOCRM_URL (env): " . ($_ENV['ESPOCRM_URL'] ?? 'NÃO DEFINIDO') . PHP_EOL;
echo "ESPOCRM_API_KEY (env): " . (isset($_ENV['ESPOCRM_API_KEY']) ? substr($_ENV['ESPOCRM_API_KEY'], 0, 8) . '...' : 'NÃO DEFINIDO') . PHP_EOL;
echo PHP_EOL;

// Verificar funções de config.php
echo "3. FUNÇÕES DE CONFIG.PHP" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;
$espocrm_url = getEspoCrmUrl();
$espocrm_api_key = getEspoCrmApiKey();
echo "getEspoCrmUrl(): $espocrm_url" . PHP_EOL;
echo "getEspoCrmApiKey(): " . substr($espocrm_api_key, 0, 8) . '...' . PHP_EOL;
echo "Chave completa: $espocrm_api_key" . PHP_EOL;
echo PHP_EOL;

// Verificar se é a chave correta para DEV
echo "4. VALIDAÇÃO DA CHAVE" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;
$chave_esperada_dev = '73b5b7983bfc641cdba72d204a48ed9d';
$chave_esperada_prod = '82d5f667f3a65a9a43341a0705be2b0c';

if ($is_dev || isDevelopment()) {
    if ($espocrm_api_key === $chave_esperada_dev) {
        echo "✅ Chave DEV correta: $chave_esperada_dev" . PHP_EOL;
    } else {
        echo "❌ Chave DEV incorreta!" . PHP_EOL;
        echo "   Esperada: $chave_esperada_dev" . PHP_EOL;
        echo "   Obtida: $espocrm_api_key" . PHP_EOL;
    }
    
    if ($espocrm_url === 'https://dev.flyingdonkeys.com.br') {
        echo "✅ URL DEV correta: $espocrm_url" . PHP_EOL;
    } else {
        echo "❌ URL DEV incorreta!" . PHP_EOL;
        echo "   Esperada: https://dev.flyingdonkeys.com.br" . PHP_EOL;
        echo "   Obtida: $espocrm_url" . PHP_EOL;
    }
} else {
    if ($espocrm_api_key === $chave_esperada_prod) {
        echo "✅ Chave PROD correta: $chave_esperada_prod" . PHP_EOL;
    } else {
        echo "❌ Chave PROD incorreta!" . PHP_EOL;
        echo "   Esperada: $chave_esperada_prod" . PHP_EOL;
        echo "   Obtida: $espocrm_api_key" . PHP_EOL;
    }
}
echo PHP_EOL;

// Verificar como add_flyingdonkeys.php vai usar
echo "5. CONFIGURAÇÃO NO add_flyingdonkeys.php" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

// Simular a lógica do add_flyingdonkeys.php
$DEV_ESPOCRM_CREDENTIALS = null; // Não existe config/dev_config.php
if ($is_dev) {
    if (isset($DEV_ESPOCRM_CREDENTIALS) && !empty($DEV_ESPOCRM_CREDENTIALS['url']) && !empty($DEV_ESPOCRM_CREDENTIALS['api_key'])) {
        $FLYINGDONKEYS_API_URL = $DEV_ESPOCRM_CREDENTIALS['url'];
        $FLYINGDONKEYS_API_KEY = $DEV_ESPOCRM_CREDENTIALS['api_key'];
        echo "Usando DEV_ESPOCRM_CREDENTIALS (se existir)" . PHP_EOL;
    } else {
        $FLYINGDONKEYS_API_URL = getEspoCrmUrl();
        $FLYINGDONKEYS_API_KEY = getEspoCrmApiKey();
        echo "Usando getEspoCrmUrl() e getEspoCrmApiKey()" . PHP_EOL;
    }
} else {
    $FLYINGDONKEYS_API_URL = getEspoCrmUrl();
    $FLYINGDONKEYS_API_KEY = getEspoCrmApiKey();
    echo "Usando getEspoCrmUrl() e getEspoCrmApiKey() (PROD)" . PHP_EOL;
}

echo "FLYINGDONKEYS_API_URL: $FLYINGDONKEYS_API_URL" . PHP_EOL;
echo "FLYINGDONKEYS_API_KEY: " . substr($FLYINGDONKEYS_API_KEY, 0, 8) . '...' . PHP_EOL;
echo "Chave completa: $FLYINGDONKEYS_API_KEY" . PHP_EOL;
echo PHP_EOL;

// Testar conexão
echo "6. TESTE DE CONEXÃO" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;
try {
    require_once __DIR__ . '/class.php';
    $client = new EspoApiClient($FLYINGDONKEYS_API_URL);
    $client->setApiKey($FLYINGDONKEYS_API_KEY);
    
    echo "Cliente criado com:" . PHP_EOL;
    echo "  URL: $FLYINGDONKEYS_API_URL" . PHP_EOL;
    echo "  API Key: " . substr($FLYINGDONKEYS_API_KEY, 0, 8) . '...' . PHP_EOL;
    
    // Testar GET simples
    $result = $client->request('GET', 'Lead', ['maxSize' => 1]);
    if (isset($result['list'])) {
        echo "✅ Conexão bem-sucedida!" . PHP_EOL;
        echo "   Leads encontrados: " . count($result['list']) . PHP_EOL;
    } else {
        echo "⚠️  Resposta inesperada" . PHP_EOL;
    }
} catch (Exception $e) {
    echo "❌ Erro na conexão: " . $e->getMessage() . PHP_EOL;
    echo "   Arquivo: " . $e->getFile() . PHP_EOL;
    echo "   Linha: " . $e->getLine() . PHP_EOL;
}
echo PHP_EOL;

echo "==========================================" . PHP_EOL;
echo "FIM DA VERIFICAÇÃO" . PHP_EOL;
echo "==========================================" . PHP_EOL;

