#!/bin/bash
# Script de instalação limpa no servidor tradicional
# Instala PHP, Nginx, MySQL, Composer e AWS SDK

set -e  # Parar em caso de erro

echo "🔧 INICIANDO INSTALAÇÃO LIMPA"
echo "=============================="
echo ""

# 1. Atualizar sistema
echo "1️⃣  Atualizando sistema..."
apt update && apt upgrade -y

# 2. Instalar PHP 8.3
echo ""
echo "2️⃣  Instalando PHP 8.3..."
apt install -y software-properties-common
add-apt-repository ppa:ondrej/php -y
apt update

apt install -y \
    php8.3 \
    php8.3-fpm \
    php8.3-cli \
    php8.3-mysql \
    php8.3-curl \
    php8.3-mbstring \
    php8.3-xml \
    php8.3-zip \
    php8.3-gd \
    php8.3-bcmath \
    php8.3-intl

echo "  ✅ PHP instalado: $(php -v | head -n 1)"

# 3. Instalar Nginx
echo ""
echo "3️⃣  Instalando Nginx..."
apt install -y nginx
echo "  ✅ Nginx instalado: $(nginx -v 2>&1)"

# 4. Instalar MySQL (se não existir)
echo ""
echo "4️⃣  Verificando MySQL..."
if ! command -v mysql &> /dev/null; then
    echo "  Instalando MySQL..."
    apt install -y mysql-server
    echo "  ⚠️  Configure MySQL com: mysql_secure_installation"
else
    echo "  ✅ MySQL já instalado"
fi

# 5. Instalar Composer
echo ""
echo "5️⃣  Instalando Composer..."
if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
    echo "  ✅ Composer instalado: $(composer --version)"
else
    echo "  ✅ Composer já instalado"
fi

# 6. Criar estrutura de diretórios
echo ""
echo "6️⃣  Criando estrutura de diretórios..."
mkdir -p /var/www/html/dev/root
mkdir -p /var/www/html/prod/root
mkdir -p /var/www/html/dev/logs
mkdir -p /var/www/html/prod/logs

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "  ✅ Diretórios criados:"
echo "     /var/www/html/dev/root"
echo "     /var/www/html/prod/root"

# 7. Instalar AWS SDK (será feito após copiar composer.json)
echo ""
echo "7️⃣  AWS SDK será instalado após copiar composer.json"
echo "  Execute: cd /var/www/html/dev/root && composer install"
echo "  Execute: cd /var/www/html/prod/root && composer install"

echo ""
echo "✅ Instalação base concluída!"
echo ""
echo "📋 PRÓXIMOS PASSOS:"
echo "  1. Configurar variáveis de ambiente no PHP-FPM"
echo "  2. Configurar Nginx"
echo "  3. Copiar arquivos do Windows"
echo "  4. Instalar AWS SDK via Composer"





