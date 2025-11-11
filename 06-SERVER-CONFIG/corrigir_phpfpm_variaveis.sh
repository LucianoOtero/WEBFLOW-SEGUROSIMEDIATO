#!/bin/bash
# Script para corrigir configuração de variáveis de ambiente no PHP-FPM
# Baseado na documentação oficial do PHP-FPM e Ubuntu

set -e

echo "=========================================="
echo "CORRECAO DE VARIAVEIS DE AMBIENTE PHP-FPM"
echo "=========================================="
echo ""

# Backup do arquivo atual
BACKUP_FILE="/etc/php/8.3/fpm/pool.d/www.conf.backup.$(date +%Y%m%d_%H%M%S)"
cp /etc/php/8.3/fpm/pool.d/www.conf "$BACKUP_FILE"
echo "✅ Backup criado: $BACKUP_FILE"
echo ""

# Verificar se clear_env está configurado corretamente
echo "1. Verificando clear_env..."
if grep -q "^clear_env = no" /etc/php/8.3/fpm/pool.d/www.conf; then
    echo "   ✅ clear_env = no já está configurado"
elif grep -q "^;clear_env = no" /etc/php/8.3/fpm/pool.d/www.conf; then
    echo "   🔧 Descomentando clear_env..."
    sed -i 's/^;clear_env = no/clear_env = no/' /etc/php/8.3/fpm/pool.d/www.conf
    echo "   ✅ clear_env = no configurado"
else
    echo "   🔧 Adicionando clear_env = no..."
    # Adicionar após a linha [www]
    sed -i '/^\[www\]/a clear_env = no' /etc/php/8.3/fpm/pool.d/www.conf
    echo "   ✅ clear_env = no adicionado"
fi
echo ""

# Verificar se as variáveis estão definidas
echo "2. Verificando variáveis de ambiente..."
if grep -q "^env\[APP_BASE_DIR\]" /etc/php/8.3/fpm/pool.d/www.conf; then
    echo "   ✅ Variáveis já estão definidas"
    echo ""
    echo "   Variáveis encontradas:"
    grep "^env\[" /etc/php/8.3/fpm/pool.d/www.conf | head -5
    echo ""
else
    echo "   ⚠️  Variáveis não encontradas. Adicionando..."
    
    # Remover variáveis antigas se existirem (comentadas ou não)
    sed -i '/^;env\[APP_BASE_DIR\]/d' /etc/php/8.3/fpm/pool.d/www.conf
    sed -i '/^env\[PHP_ENV\]/d' /etc/php/8.3/fpm/pool.d/www.conf
    sed -i '/^env\[APP_BASE_DIR\]/d' /etc/php/8.3/fpm/pool.d/www.conf
    sed -i '/^env\[APP_BASE_URL\]/d' /etc/php/8.3/fpm/pool.d/www.conf
    sed -i '/^env\[APP_CORS_ORIGINS\]/d' /etc/php/8.3/fpm/pool.d/www.conf
    
    # Adicionar variáveis após clear_env
    cat >> /etc/php/8.3/fpm/pool.d/www.conf << 'EOF'

; ==================== VARIÁVEIS DE AMBIENTE DEV ====================
; Carregadas automaticamente em todas as requisições PHP
; IMPORTANTE: clear_env = no deve estar configurado acima

env[PHP_ENV] = development
env[APP_BASE_DIR] = /var/www/html/dev/root
env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br
env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br

; Banco de dados DEV
env[LOG_DB_HOST] = localhost
env[LOG_DB_PORT] = 3306
env[LOG_DB_NAME] = rpa_logs_dev
env[LOG_DB_USER] = rpa_logger_dev
env[LOG_DB_PASS] = tYbAwe7QkKNrHSRhaWplgsSxt

; EspoCRM DEV
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d

; Webflow Secrets DEV
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
env[WEBFLOW_SECRET_OCTADESK] = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291

; OctaDesk
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services

; AWS SES DEV
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_REGION] = us-east-1
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
EOF
    echo "   ✅ Variáveis adicionadas"
fi
echo ""

# Validar configuração
echo "3. Validando configuração PHP-FPM..."
if php-fpm8.3 -t; then
    echo "   ✅ Configuração válida"
else
    echo "   ❌ ERRO: Configuração inválida!"
    echo "   Restaurando backup..."
    cp "$BACKUP_FILE" /etc/php/8.3/fpm/pool.d/www.conf
    exit 1
fi
echo ""

# Reiniciar PHP-FPM
echo "4. Reiniciando PHP-FPM..."
systemctl restart php8.3-fpm
sleep 2

if systemctl is-active --quiet php8.3-fpm; then
    echo "   ✅ PHP-FPM reiniciado com sucesso"
else
    echo "   ❌ ERRO: PHP-FPM não iniciou!"
    echo "   Restaurando backup..."
    cp "$BACKUP_FILE" /etc/php/8.3/fpm/pool.d/www.conf
    systemctl restart php8.3-fpm
    exit 1
fi
echo ""

# Verificar se as variáveis estão disponíveis
echo "5. Testando variáveis de ambiente..."
TEST_FILE="/var/www/html/dev/root/test_env.php"
if [ -f "$TEST_FILE" ]; then
    echo "   Testando via HTTP..."
    sleep 1
    RESULT=$(curl -k -s https://dev.bssegurosimediato.com.br/test_env.php 2>&1 | head -5)
    if echo "$RESULT" | grep -q "APP_BASE_URL"; then
        echo "   ✅ Variáveis estão sendo carregadas!"
        echo ""
        echo "$RESULT"
    else
        echo "   ⚠️  Variáveis ainda não estão disponíveis"
        echo "   Resultado:"
        echo "$RESULT" | head -3
    fi
else
    echo "   ⚠️  Arquivo de teste não encontrado: $TEST_FILE"
fi
echo ""

echo "=========================================="
echo "CORRECAO CONCLUIDA"
echo "=========================================="
echo ""
echo "Próximos passos:"
echo "  1. Verificar logs: tail -f /var/log/php8.3-fpm.log"
echo "  2. Testar: curl -k https://dev.bssegurosimediato.com.br/test_env.php"
echo "  3. Verificar variáveis: grep '^env\[' /etc/php/8.3/fpm/pool.d/www.conf"
echo ""

