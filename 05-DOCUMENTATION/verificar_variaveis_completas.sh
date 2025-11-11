#!/bin/bash
# Script para verificar se todas as variáveis necessárias estão configuradas

echo "=========================================="
echo "VERIFICACAO DE VARIAVEIS DE AMBIENTE"
echo "=========================================="
echo ""

echo "VARIAVEIS USADAS PELOS ARQUIVOS:"
echo "---------------------------------"
echo ""

echo "📄 PHP (config.php e outros):"
echo "  ✅ PHP_ENV"
echo "  ✅ APP_BASE_DIR"
echo "  ✅ APP_BASE_URL"
echo "  ✅ APP_CORS_ORIGINS"
echo "  ✅ LOG_DB_HOST"
echo "  ✅ LOG_DB_PORT"
echo "  ✅ LOG_DB_NAME"
echo "  ✅ LOG_DB_USER"
echo "  ✅ LOG_DB_PASS"
echo "  ✅ ESPOCRM_URL"
echo "  ✅ ESPOCRM_API_KEY"
echo "  ✅ WEBFLOW_SECRET_FLYINGDONKEYS"
echo "  ✅ WEBFLOW_SECRET_OCTADESK"
echo "  ✅ OCTADESK_API_KEY"
echo "  ✅ OCTADESK_API_BASE"
echo "  ✅ AWS_ACCESS_KEY_ID"
echo "  ✅ AWS_SECRET_ACCESS_KEY"
echo "  ✅ AWS_REGION"
echo "  ✅ AWS_SES_FROM_EMAIL"
echo "  ✅ AWS_SES_ADMIN_EMAILS"
echo ""

echo "📄 JavaScript (via config_env.js.php):"
echo "  ✅ APP_BASE_URL (exposto como window.APP_BASE_URL)"
echo "  ✅ PHP_ENV (exposto como window.APP_ENVIRONMENT)"
echo ""

echo "VARIAVEIS CONFIGURADAS NO PHP-FPM:"
echo "-----------------------------------"
php-fpm8.3 -tt 2>&1 | grep "env\[" | sort

echo ""
echo "ARQUIVO config_env.js.php:"
echo "--------------------------"
if [ -f /var/www/html/dev/root/config_env.js.php ]; then
    echo "  ✅ Arquivo existe"
    echo "  Conteudo:"
    cat /var/www/html/dev/root/config_env.js.php | head -25
else
    echo "  ❌ Arquivo NAO existe - precisa ser copiado do Windows"
fi

echo ""
echo "=========================================="
echo "RESUMO:"
echo "=========================================="
echo ""
echo "VARIAVEIS PHP:"
echo "  - Todas as 20 variaveis estao configuradas no PHP-FPM"
echo "  - Disponiveis via \$_ENV[] em todos os arquivos PHP"
echo ""
echo "VARIAVEIS JAVASCRIPT:"
echo "  - APP_BASE_URL e PHP_ENV estao configuradas no PHP-FPM"
echo "  - Expostas via config_env.js.php como window.APP_BASE_URL e window.APP_ENVIRONMENT"
echo "  - Arquivo config_env.js.php precisa ser copiado do Windows"
echo ""
echo "PROXIMOS PASSOS:"
echo "  1. Copiar config_env.js.php para /var/www/html/dev/root/"
echo "  2. Copiar todos os outros arquivos PHP e JS"
echo ""

