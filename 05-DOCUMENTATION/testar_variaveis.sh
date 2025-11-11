#!/bin/bash
echo "=== TESTE DE VARIAVEIS DE AMBIENTE ==="
echo ""
echo "Via PHP CLI:"
php -r "echo 'PHP_ENV: ' . (getenv('PHP_ENV') ?: 'NAO DEFINIDO') . PHP_EOL;"
php -r "echo 'APP_BASE_URL: ' . (getenv('APP_BASE_URL') ?: 'NAO DEFINIDO') . PHP_EOL;"
echo ""
echo "Criando arquivo de teste PHP..."
cat > /var/www/html/dev/root/test_env.php << 'PHPEOF'
<?php
header('Content-Type: text/plain');
echo '=== TESTE DE VARIAVEIS DE AMBIENTE ===' . PHP_EOL . PHP_EOL;
echo 'PHP_ENV: ' . ($_ENV['PHP_ENV'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo 'APP_BASE_DIR: ' . ($_ENV['APP_BASE_DIR'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo 'APP_BASE_URL: ' . ($_ENV['APP_BASE_URL'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo 'ESPOCRM_URL: ' . ($_ENV['ESPOCRM_URL'] ?? 'NAO DEFINIDO') . PHP_EOL;
echo 'ESPOCRM_API_KEY: ' . (isset($_ENV['ESPOCRM_API_KEY']) ? 'DEFINIDO (' . strlen($_ENV['ESPOCRM_API_KEY']) . ' chars)' : 'NAO DEFINIDO') . PHP_EOL;
echo 'WEBFLOW_SECRET_FLYINGDONKEYS: ' . (isset($_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']) ? 'DEFINIDO (' . strlen($_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']) . ' chars)' : 'NAO DEFINIDO') . PHP_EOL;
echo 'AWS_ACCESS_KEY_ID: ' . (isset($_ENV['AWS_ACCESS_KEY_ID']) ? 'DEFINIDO' : 'NAO DEFINIDO') . PHP_EOL;
PHPEOF
chmod 644 /var/www/html/dev/root/test_env.php
echo "Arquivo criado: /var/www/html/dev/root/test_env.php"
echo "Teste via: curl http://dev.bssegurosimediato.com.br/test_env.php"

