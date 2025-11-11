<?php
/**
 * TEST_ENV.PHP
 * 
 * Script de teste para verificar se as variáveis de ambiente estão sendo carregadas corretamente
 * via PHP-FPM
 */

require_once 'config.php';

header('Content-Type: text/plain');

echo "=== TESTE DE VARIAVEIS DE AMBIENTE ===" . PHP_EOL;
echo PHP_EOL;

try {
    echo "APP_BASE_URL: " . getBaseUrl() . PHP_EOL;
    echo "APP_BASE_DIR: " . getBaseDir() . PHP_EOL;
    
    $cors = getCorsOrigins();
    echo "CORS Origins: " . implode(', ', $cors) . PHP_EOL;
    
    echo "ESPOCRM_URL: " . getEspoCrmUrl() . PHP_EOL;
    echo "ESPOCRM_API_KEY: " . (strlen(getEspoCrmApiKey()) > 0 ? 'DEFINIDO' : 'NAO DEFINIDO') . PHP_EOL;
    
    echo "OCTADESK_API_BASE: " . getOctaDeskApiBase() . PHP_EOL;
    
    $dbConfig = getDatabaseConfig();
    echo "LOG_DB_HOST: " . $dbConfig['host'] . PHP_EOL;
    echo "LOG_DB_NAME: " . $dbConfig['name'] . PHP_EOL;
    
    echo PHP_EOL;
    echo "=== STATUS: TODAS AS VARIAVEIS CARREGADAS COM SUCESSO ===" . PHP_EOL;
    
} catch (Exception $e) {
    echo PHP_EOL;
    echo "=== ERRO ===" . PHP_EOL;
    echo $e->getMessage() . PHP_EOL;
    echo PHP_EOL;
    echo "Stack trace:" . PHP_EOL;
    echo $e->getTraceAsString() . PHP_EOL;
}

