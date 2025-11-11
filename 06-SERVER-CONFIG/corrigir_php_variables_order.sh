#!/bin/bash
# Script para corrigir variables_order no PHP-FPM
# Isso permite que $_ENV seja populado automaticamente

set -e

echo "=========================================="
echo "CORRECAO DE VARIABLES_ORDER NO PHP-FPM"
echo "=========================================="
echo ""

# Backup
BACKUP_FILE="/etc/php/8.3/fpm/php.ini.backup.$(date +%Y%m%d_%H%M%S)"
cp /etc/php/8.3/fpm/php.ini "$BACKUP_FILE"
echo "✅ Backup criado: $BACKUP_FILE"
echo ""

# Verificar variables_order atual
CURRENT_ORDER=$(grep "^variables_order" /etc/php/8.3/fpm/php.ini | head -1)
echo "1. Variables_order atual: $CURRENT_ORDER"

# Verificar se já contém 'E'
if echo "$CURRENT_ORDER" | grep -q "E"; then
    echo "   ✅ 'E' já está presente em variables_order"
else
    echo "   🔧 Adicionando 'E' ao variables_order..."
    
    # Remover linha atual (se existir)
    sed -i '/^variables_order/d' /etc/php/8.3/fpm/php.ini
    
    # Adicionar nova linha com 'E'
    # Formato padrão: variables_order = "GPCS"
    # Novo formato: variables_order = "EGPCS" (E = Environment)
    sed -i '/^\[PHP\]/a variables_order = "EGPCS"' /etc/php/8.3/fpm/php.ini
    
    # Se não houver seção [PHP], adicionar no início
    if ! grep -q "^variables_order" /etc/php/8.3/fpm/php.ini; then
        echo "variables_order = \"EGPCS\"" >> /etc/php/8.3/fpm/php.ini
    fi
    
    echo "   ✅ variables_order atualizado para incluir 'E'"
fi
echo ""

# Verificar configuração
echo "2. Verificando configuração..."
NEW_ORDER=$(grep "^variables_order" /etc/php/8.3/fpm/php.ini | head -1)
echo "   Nova configuração: $NEW_ORDER"
echo ""

# Reiniciar PHP-FPM
echo "3. Reiniciando PHP-FPM..."
systemctl restart php8.3-fpm
sleep 2

if systemctl is-active --quiet php8.3-fpm; then
    echo "   ✅ PHP-FPM reiniciado com sucesso"
else
    echo "   ❌ ERRO: PHP-FPM não iniciou!"
    echo "   Restaurando backup..."
    cp "$BACKUP_FILE" /etc/php/8.3/fpm/php.ini
    systemctl restart php8.3-fpm
    exit 1
fi
echo ""

# Testar
echo "4. Testando variáveis..."
sleep 1
RESULT=$(curl -k -s https://dev.bssegurosimediato.com.br/test_env_direct.php 2>&1 | grep -A 3 "Metodo 1")
if echo "$RESULT" | grep -q "APP_BASE_DIR: /var/www"; then
    echo "   ✅ \$_ENV agora está funcionando!"
    echo ""
    echo "$RESULT"
else
    echo "   ⚠️  \$_ENV ainda não está funcionando"
    echo "   Resultado:"
    echo "$RESULT"
fi
echo ""

echo "=========================================="
echo "CORRECAO CONCLUIDA"
echo "=========================================="
echo ""

