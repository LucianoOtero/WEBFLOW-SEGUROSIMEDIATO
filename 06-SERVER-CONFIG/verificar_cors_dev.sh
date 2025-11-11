#!/bin/bash
# Script para verificar e adicionar dev.bssegurosimediato.com.br ao CORS se necessário

set -e

echo "=========================================="
echo "VERIFICACAO DE CORS - dev.bssegurosimediato.com.br"
echo "=========================================="
echo ""

CORS_ORIGINS=$(grep '^env\[APP_CORS_ORIGINS\]' /etc/php/8.3/fpm/pool.d/www.conf | cut -d'=' -f2 | tr -d ' ')

if [ -z "$CORS_ORIGINS" ]; then
    echo "❌ APP_CORS_ORIGINS não encontrado no PHP-FPM pool"
    exit 1
fi

echo "CORS Origins configurados:"
echo "$CORS_ORIGINS"
echo ""

if echo "$CORS_ORIGINS" | grep -q "dev.bssegurosimediato.com.br"; then
    echo "✅ dev.bssegurosimediato.com.br já está incluído no CORS"
else
    echo "⚠️  dev.bssegurosimediato.com.br NÃO está incluído no CORS"
    echo ""
    echo "Adicionando dev.bssegurosimediato.com.br ao CORS..."
    
    # Backup
    cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup.$(date +%Y%m%d_%H%M%S)
    
    # Adicionar dev.bssegurosimediato.com.br
    sed -i "s|^env\[APP_CORS_ORIGINS\] = .*|env[APP_CORS_ORIGINS] = $CORS_ORIGINS,https://dev.bssegurosimediato.com.br|" /etc/php/8.3/fpm/pool.d/www.conf
    
    echo "✅ dev.bssegurosimediato.com.br adicionado ao CORS"
    echo ""
    echo "Reiniciando PHP-FPM..."
    systemctl restart php8.3-fpm
    
    echo "✅ PHP-FPM reiniciado"
fi

echo ""
echo "=========================================="
echo "VERIFICACAO CONCLUIDA"
echo "=========================================="

