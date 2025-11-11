<?php
/**
 * TEST_ENV_DIRECT.PHP
 * 
 * Teste direto das variáveis de ambiente sem usar config.php
 */

header('Content-Type: text/plain');

echo "=== TESTE DIRETO DE VARIAVEIS DE AMBIENTE ===" . PHP_EOL;
echo PHP_EOL;

echo "Metodo 1: \$_ENV" . PHP_EOL;
echo "  APP_BASE_DIR: " . ($_ENV['APP_BASE_DIR'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo "  APP_BASE_URL: " . ($_ENV['APP_BASE_URL'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo "  PHP_ENV: " . ($_ENV['PHP_ENV'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo PHP_EOL;

echo "Metodo 2: getenv()" . PHP_EOL;
echo "  APP_BASE_DIR: " . (getenv('APP_BASE_DIR') ?: 'NAO DEFINIDO') . PHP_EOL;
echo "  APP_BASE_URL: " . (getenv('APP_BASE_URL') ?: 'NAO DEFINIDO') . PHP_EOL;
echo "  PHP_ENV: " . (getenv('PHP_ENV') ?: 'NAO DEFINIDO') . PHP_EOL;
echo PHP_EOL;

echo "Metodo 3: \$_SERVER" . PHP_EOL;
echo "  APP_BASE_DIR: " . ($_SERVER['APP_BASE_DIR'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo "  APP_BASE_URL: " . ($_SERVER['APP_BASE_URL'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo "  PHP_ENV: " . ($_SERVER['PHP_ENV'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo PHP_EOL;

echo "Todas as variaveis \$_ENV:" . PHP_EOL;
foreach ($_ENV as $key => $value) {
    if (strpos($key, 'APP_') === 0 || strpos($key, 'PHP_ENV') === 0 || strpos($key, 'LOG_DB') === 0) {
        echo "  $key = $value" . PHP_EOL;
    }
}
echo PHP_EOL;

echo "=== FIM DO TESTE ===" . PHP_EOL;

