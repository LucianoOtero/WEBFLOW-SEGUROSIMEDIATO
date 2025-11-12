#!/bin/bash

# ============================================
# SCRIPT: AJUSTAR SERVIDOR DE DEV PARA PROD
# ============================================
# 
# Este script ajusta as configurações de um servidor
# criado a partir de snapshot do servidor DEV para PROD.
# 
# Uso: Execute este script APÓS criar o servidor PROD
#      a partir do snapshot do servidor DEV.
#
# ============================================

set -e  # Parar em caso de erro

echo "🚀 Iniciando ajuste de DEV para PROD..."
echo ""

# ============================================
# 1. VARIÁVEIS DE AMBIENTE PHP-FPM
# ============================================

echo "📝 1. Ajustando variáveis de ambiente PHP-FPM..."

POOL_FILE="/etc/php/8.3/fpm/pool.d/www.conf"

if [ ! -f "$POOL_FILE" ]; then
    echo "❌ Arquivo não encontrado: $POOL_FILE"
    exit 1
fi

# Criar backup
BACKUP_FILE="${POOL_FILE}.backup_ANTES_PROD_$(date +%Y%m%d_%H%M%S)"
cp "$POOL_FILE" "$BACKUP_FILE"
echo "   ✅ Backup criado: $BACKUP_FILE"

# Alterar variáveis DEV → PROD
sed -i 's|env[APP_BASE_DIR] = /var/www/html/dev/root|env[APP_BASE_DIR] = /var/www/html/prod/root|g' "$POOL_FILE"
sed -i 's|env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br|env[APP_BASE_URL] = https://prod.bssegurosimediato.com.br|g' "$POOL_FILE"
sed -i 's|env[APP_ENVIRONMENT] = development|env[APP_ENVIRONMENT] = production|g' "$POOL_FILE"

echo "   ✅ Variáveis ajustadas:"
echo "      - APP_BASE_DIR: /var/www/html/dev/root → /var/www/html/prod/root"
echo "      - APP_BASE_URL: https://dev.bssegurosimediato.com.br → https://prod.bssegurosimediato.com.br"
echo "      - APP_ENVIRONMENT: development → production"
echo ""

# ============================================
# 2. CONFIGURAÇÃO NGINX
# ============================================

echo "📝 2. Ajustando configuração Nginx..."

DEV_NGINX="/etc/nginx/sites-available/dev.bssegurosimediato.com.br"
PROD_NGINX="/etc/nginx/sites-available/prod.bssegurosimediato.com.br"

if [ ! -f "$DEV_NGINX" ]; then
    echo "   ⚠️  Arquivo DEV não encontrado: $DEV_NGINX"
    echo "   ℹ️  Será necessário criar configuração PROD manualmente"
else
    # Criar configuração PROD baseada em DEV
    cp "$DEV_NGINX" "$PROD_NGINX"
    
    # Alterar configurações DEV → PROD
    sed -i 's|dev.bssegurosimediato.com.br|prod.bssegurosimediato.com.br|g' "$PROD_NGINX"
    sed -i 's|/var/www/html/dev/root|/var/www/html/prod/root|g' "$PROD_NGINX"
    
    # Ativar site PROD
    ln -sf "$PROD_NGINX" /etc/nginx/sites-enabled/prod.bssegurosimediato.com.br
    
    echo "   ✅ Configuração Nginx PROD criada: $PROD_NGINX"
    echo "   ✅ Site PROD ativado"
fi
echo ""

# ============================================
# 3. ESTRUTURA DE DIRETÓRIOS
# ============================================

echo "📝 3. Criando estrutura de diretórios PROD..."

mkdir -p /var/www/html/prod/root
mkdir -p /var/www/html/prod/root/email_templates
mkdir -p /var/www/html/prod/logs

chown -R www-data:www-data /var/www/html/prod
chmod -R 755 /var/www/html/prod

echo "   ✅ Diretórios criados:"
echo "      - /var/www/html/prod/root"
echo "      - /var/www/html/prod/root/email_templates"
echo "      - /var/www/html/prod/logs"
echo ""

# ============================================
# 4. LIMPAR DADOS DE DESENVOLVIMENTO (OPCIONAL)
# ============================================

echo "📝 4. Limpando dados de desenvolvimento..."

# Limpar logs de desenvolvimento (opcional - descomente se necessário)
# rm -rf /var/www/html/dev/logs/*

# Limpar arquivos temporários
find /tmp -type f -name "*dev*" -mtime +7 -delete 2>/dev/null || true

echo "   ✅ Limpeza concluída"
echo ""

# ============================================
# 5. REINICIAR SERVIÇOS
# ============================================

echo "📝 5. Reiniciando serviços..."

# Testar configuração Nginx
if nginx -t; then
    systemctl reload nginx
    echo "   ✅ Nginx reiniciado"
else
    echo "   ❌ Erro na configuração do Nginx. Verifique manualmente."
    exit 1
fi

# Reiniciar PHP-FPM
systemctl restart php8.3-fpm
echo "   ✅ PHP-FPM reiniciado"
echo ""

# ============================================
# 6. VERIFICAÇÃO
# ============================================

echo "📝 6. Verificando configurações..."

# Verificar variáveis de ambiente
echo "   Verificando variáveis PHP-FPM:"
grep "APP_BASE_DIR\|APP_BASE_URL\|APP_ENVIRONMENT" "$POOL_FILE" | head -3

# Verificar Nginx
if [ -f "$PROD_NGINX" ]; then
    echo "   ✅ Configuração Nginx PROD existe"
    echo "   Verificando server_name:"
    grep "server_name" "$PROD_NGINX" | head -1
fi

# Verificar diretórios
if [ -d "/var/www/html/prod/root" ]; then
    echo "   ✅ Diretório PROD existe"
fi

echo ""
echo "============================================"
echo "✅ AJUSTE DE DEV PARA PROD CONCLUÍDO!"
echo "============================================"
echo ""
echo "📋 PRÓXIMOS PASSOS:"
echo ""
echo "1. Copiar arquivos de aplicação para /var/www/html/prod/root/"
echo "2. Configurar DNS no Cloudflare:"
echo "   - Registrar A: prod → 157.180.36.223"
echo "   - Domínio completo: prod.bssegurosimediato.com.br"
echo ""
echo "3. Obter certificado SSL:"
echo "   certbot --nginx -d prod.bssegurosimediato.com.br"
echo ""
echo "4. Testar acesso:"
echo "   curl -I https://prod.bssegurosimediato.com.br"
echo ""
echo "5. Verificar variáveis de ambiente:"
echo "   php -r \"require '/var/www/html/prod/root/config_env.js.php'; echo APP_BASE_URL;\""
echo ""

