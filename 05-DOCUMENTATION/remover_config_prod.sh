#!/bin/bash
# Script para remover todas as configurações de PROD
# Servidor será apenas DEV

set -e

echo "=========================================="
echo "REMOVENDO CONFIGURACOES DE PROD"
echo "Servidor sera apenas DEV"
echo "=========================================="
echo ""

# ==================== FASE 1: REMOVER POOL PHP-FPM PROD ====================
echo "FASE 1: Removendo pool PHP-FPM PROD..."

if [ -f /etc/php/8.3/fpm/pool.d/prod.conf ]; then
    rm -f /etc/php/8.3/fpm/pool.d/prod.conf
    echo "  ✅ Pool PROD removido"
else
    echo "  ℹ️  Pool PROD nao encontrado"
fi

echo ""

# ==================== FASE 2: REMOVER CONFIGURAÇÃO NGINX PROD ====================
echo "FASE 2: Removendo configuracao Nginx PROD..."

if [ -f /etc/nginx/sites-available/bssegurosimediato.com.br ]; then
    rm -f /etc/nginx/sites-available/bssegurosimediato.com.br
    echo "  ✅ Configuracao Nginx PROD removida"
else
    echo "  ℹ️  Configuracao Nginx PROD nao encontrada"
fi

if [ -L /etc/nginx/sites-enabled/bssegurosimediato.com.br ]; then
    rm -f /etc/nginx/sites-enabled/bssegurosimediato.com.br
    echo "  ✅ Link simbolico PROD removido"
fi

echo ""

# ==================== FASE 3: LIMPAR VARIÁVEIS DE AMBIENTE PROD ====================
echo "FASE 3: Limpando variaveis de ambiente PROD..."

# Remover variáveis PROD do arquivo global (manter apenas DEV)
if [ -f /etc/environment.d/webhooks.conf ]; then
    # Criar backup
    cp /etc/environment.d/webhooks.conf /etc/environment.d/webhooks.conf.backup.$(date +%Y%m%d_%H%M%S)
    
    # Manter apenas variáveis DEV
    cat > /etc/environment.d/webhooks.conf << 'EOF'
# Variáveis de ambiente para Webhooks Server - DEV APENAS
# Carregadas automaticamente em todos os shells e serviços

# Ambiente
PHP_ENV=development

# Diretórios base DEV
APP_BASE_DIR=/var/www/html/dev/root
APP_BASE_URL=https://dev.bssegurosimediato.com.br
APP_CORS_ORIGINS=https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br

# Banco de dados DEV
LOG_DB_HOST=localhost
LOG_DB_PORT=3306
LOG_DB_NAME=rpa_logs_dev
LOG_DB_USER=rpa_logger_dev
LOG_DB_PASS=tYbAwe7QkKNrHSRhaWplgsSxt

# EspoCRM DEV
ESPOCRM_URL=https://dev.flyingdonkeys.com.br
ESPOCRM_API_KEY=73b5b7983bfc641cdba72d204a48ed9d

# Webflow Secrets DEV
WEBFLOW_SECRET_FLYINGDONKEYS=888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
WEBFLOW_SECRET_OCTADESK=1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291

# OctaDesk
OCTADESK_API_KEY=b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
OCTADESK_API_BASE=https://o205242-d60.api004.octadesk.services

# AWS SES DEV (SUBSTITUIR COM CREDENCIAIS REAIS)
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_REGION=us-east-1
AWS_SES_FROM_EMAIL=noreply@bssegurosimediato.com.br
AWS_SES_ADMIN_EMAILS=lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
EOF
    
    echo "  ✅ Arquivo de variaveis atualizado (apenas DEV)"
else
    echo "  ℹ️  Arquivo de variaveis nao encontrado"
fi

echo ""

# ==================== FASE 4: LIMPAR POOL PHP-FPM DEV (REMOVER REFERÊNCIAS PROD) ====================
echo "FASE 4: Limpando pool PHP-FPM DEV..."

# O pool DEV já está correto, apenas garantir que não há referências PROD
if grep -q "production" /etc/php/8.3/fpm/pool.d/www.conf; then
    echo "  ⚠️  Verificar se há referencias PROD no pool DEV"
else
    echo "  ✅ Pool DEV limpo"
fi

echo ""

# ==================== FASE 5: VERIFICAR ESTRUTURA DE DIRETÓRIOS ====================
echo "FASE 5: Verificando estrutura de diretorios..."

echo "Diretorios DEV:"
ls -ld /var/www/html/dev/root /var/www/html/dev/logs 2>/dev/null || echo "  ⚠️  Diretorios DEV nao encontrados"

echo ""
echo "Diretorios PROD (serao mantidos vazios, mas nao usados):"
ls -ld /var/www/html/prod/root /var/www/html/prod/logs 2>/dev/null || echo "  ℹ️  Diretorios PROD nao existem"

echo ""

# ==================== FASE 6: REINICIAR SERVIÇOS ====================
echo "FASE 6: Reiniciando servicos..."

# Validar PHP-FPM
php-fpm8.3 -t

# Reiniciar PHP-FPM
systemctl restart php8.3-fpm

# Validar Nginx
nginx -t

# Reiniciar Nginx
systemctl restart nginx

echo "  ✅ Servicos reiniciados"
echo ""

# ==================== FASE 7: VERIFICAÇÃO FINAL ====================
echo "FASE 7: Verificacao final..."

echo "Pools PHP-FPM ativos:"
ls -1 /etc/php/8.3/fpm/pool.d/*.conf | grep -v ".backup"

echo ""
echo "Sites Nginx ativos:"
ls -1 /etc/nginx/sites-enabled/

echo ""
echo "Status servicos:"
systemctl is-active php8.3-fpm
systemctl is-active nginx

echo ""
echo "=========================================="
echo "CONFIGURACAO CONCLUIDA!"
echo "=========================================="
echo ""
echo "SERVIDOR CONFIGURADO APENAS PARA DEV:"
echo "  - PHP-FPM: Pool DEV (www.conf)"
echo "  - Nginx: dev.bssegurosimediato.com.br"
echo "  - Diretorio: /var/www/html/dev/root"
echo "  - Logs: /var/www/html/dev/logs"
echo ""
echo "CONFIGURACOES PROD REMOVIDAS:"
echo "  - Pool PHP-FPM PROD removido"
echo "  - Configuracao Nginx PROD removida"
echo "  - Variaveis de ambiente PROD removidas"
echo ""

