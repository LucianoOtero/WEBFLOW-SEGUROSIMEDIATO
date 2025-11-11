#!/bin/bash
# Script completo de migração: limpeza + instalação + configuração
# Executar no servidor 65.108.156.14

set -e  # Parar em caso de erro

echo "=========================================="
echo "MIGRACAO: CONTAINERS -> SERVIDOR TRADICIONAL"
echo "Servidor: 65.108.156.14"
echo "=========================================="
echo ""

# ==================== FASE 1: LIMPEZA ====================
echo "FASE 1: LIMPEZA COMPLETA"
echo "------------------------"

echo "1.1 Parando containers..."
docker stop $(docker ps -aq) 2>/dev/null || echo "  Nenhum container rodando"

echo "1.2 Removendo containers..."
docker rm $(docker ps -aq) 2>/dev/null || echo "  Nenhum container para remover"

echo "1.3 Removendo imagens..."
docker rmi $(docker images -q) 2>/dev/null || echo "  Nenhuma imagem para remover"

echo "1.4 Removendo volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null || echo "  Nenhum volume para remover"

echo "1.5 Removendo networks..."
docker network prune -f

echo "1.6 Limpando sistema Docker..."
docker system prune -a -f --volumes

echo "1.7 Removendo arquivos antigos..."
rm -rf /opt/webhooks-server/dev/root/* 2>/dev/null || true
rm -rf /opt/webhooks-server/prod/root/* 2>/dev/null || true
rm -rf /opt/webhooks-server/dev/logs/* 2>/dev/null || true
rm -rf /opt/webhooks-server/prod/logs/* 2>/dev/null || true
rm -rf /opt/webhooks-server/docker-compose.yml 2>/dev/null || true
rm -rf /opt/webhooks-server/Dockerfile 2>/dev/null || true

echo "1.8 Verificando limpeza..."
echo "  Containers: $(docker ps -aq | wc -l)"
echo "  Imagens: $(docker images -q | wc -l)"
echo "  Volumes: $(docker volume ls -q | wc -l)"

echo ""
echo "✅ Limpeza concluida!"
echo ""

# ==================== FASE 2: INSTALAÇÃO ====================
echo "FASE 2: INSTALAÇÃO LIMPA"
echo "------------------------"

echo "2.1 Atualizando sistema..."
export DEBIAN_FRONTEND=noninteractive
apt update && apt upgrade -y

echo "2.2 Instalando PHP 8.3..."
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

echo "  PHP instalado: $(php -v | head -n 1)"

echo "2.3 Instalando Nginx..."
apt install -y nginx
echo "  Nginx instalado: $(nginx -v 2>&1)"

echo "2.4 Verificando MySQL..."
if ! command -v mysql &> /dev/null; then
    echo "  Instalando MySQL..."
    apt install -y mysql-server
    echo "  ⚠️  Configure MySQL com: mysql_secure_installation"
else
    echo "  ✅ MySQL ja instalado"
fi

echo "2.5 Instalando Composer..."
if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
    echo "  Composer instalado: $(composer --version)"
else
    echo "  ✅ Composer ja instalado"
fi

echo "2.6 Criando estrutura de diretorios..."
mkdir -p /var/www/html/dev/root
mkdir -p /var/www/html/prod/root
mkdir -p /var/www/html/dev/logs
mkdir -p /var/www/html/prod/logs

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "  Diretorios criados:"
echo "    /var/www/html/dev/root"
echo "    /var/www/html/prod/root"

echo ""
echo "✅ Instalacao base concluida!"
echo ""

# ==================== FASE 3: CONFIGURAÇÃO ====================
echo "FASE 3: CONFIGURAÇÃO"
echo "--------------------"

echo "3.1 Configurando PHP-FPM (DEV)..."
# Backup do arquivo original
cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup

# Adicionar variáveis de ambiente ao pool DEV
cat >> /etc/php/8.3/fpm/pool.d/www.conf << 'EOF'

; Variáveis de ambiente para DEV
env[PHP_ENV] = development
env[APP_BASE_DIR] = /var/www/html/dev/root
env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br
env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br

; Variáveis de banco de dados DEV
env[LOG_DB_HOST] = localhost
env[LOG_DB_PORT] = 3306
env[LOG_DB_NAME] = rpa_logs_dev
env[LOG_DB_USER] = rpa_logger_dev
env[LOG_DB_PASS] = tYbAwe7QkKNrHSRhaWplgsSxt

; Variáveis EspoCRM DEV
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d

; Variáveis Webflow DEV
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
env[WEBFLOW_SECRET_OCTADESK] = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291

; Variáveis OctaDesk
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services

; Variáveis AWS SES DEV
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_REGION] = us-east-1
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
EOF

echo "3.2 Criando pool PHP-FPM para PROD..."
cat > /etc/php/8.3/fpm/pool.d/prod.conf << 'EOF'
[prod]
user = www-data
group = www-data
listen = /run/php/php8.3-fpm-prod.sock
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35

; Variáveis de ambiente para PROD
env[PHP_ENV] = production
env[APP_BASE_DIR] = /var/www/html/prod/root
env[APP_BASE_URL] = https://bssegurosimediato.com.br
env[APP_CORS_ORIGINS] = https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://bpsegurosimediato.com.br

; Variáveis de banco de dados PROD
env[LOG_DB_HOST] = localhost
env[LOG_DB_PORT] = 3306
env[LOG_DB_NAME] = rpa_logs_prod
env[LOG_DB_USER] = rpa_logger_prod
env[LOG_DB_PASS] = [SENHA_PROD]

; Variáveis EspoCRM PROD
env[ESPOCRM_URL] = https://flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 82d5f667f3a65a9a43341a0705be2b0c

; Variáveis Webflow PROD
env[WEBFLOW_SECRET_FLYINGDONKEYS] = ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990
env[WEBFLOW_SECRET_OCTADESK] = 4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f

; Variáveis OctaDesk
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services

; Variáveis AWS SES PROD
env[AWS_ACCESS_KEY_ID] = [AWS_KEY_PROD]
env[AWS_SECRET_ACCESS_KEY] = [AWS_SECRET_PROD]
env[AWS_REGION] = us-east-1
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
EOF

echo "3.3 Configurando Nginx (DEV)..."
# Verificar se certificados SSL existem
if [ -f /etc/letsencrypt/live/dev.bssegurosimediato.com.br/fullchain.pem ]; then
    cat > /etc/nginx/sites-available/dev.bssegurosimediato.com.br << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name dev.bssegurosimediato.com.br;

    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name dev.bssegurosimediato.com.br;

    ssl_certificate /etc/letsencrypt/live/dev.bssegurosimediato.com.br/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/dev.bssegurosimediato.com.br/privkey.pem;
EOF
else
    echo "  AVISO: Certificados SSL nao encontrados para DEV - usando apenas HTTP"
    cat > /etc/nginx/sites-available/dev.bssegurosimediato.com.br << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name dev.bssegurosimediato.com.br;
EOF
fi

cat >> /etc/nginx/sites-available/dev.bssegurosimediato.com.br << 'EOF'

    root /var/www/html/dev/root;
    index index.php index.html;

    access_log /var/log/nginx/dev_access.log;
    error_log /var/log/nginx/dev_error.log;

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
        
        add_header 'Access-Control-Allow-Origin' '\$http_origin' always;
        add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type, X-Webflow-Signature, X-Webflow-Timestamp' always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

echo "3.4 Configurando Nginx (PROD)..."
# Verificar se certificados SSL existem
if [ -f /etc/letsencrypt/live/bssegurosimediato.com.br/fullchain.pem ]; then
    cat > /etc/nginx/sites-available/bssegurosimediato.com.br << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name bssegurosimediato.com.br www.bssegurosimediato.com.br;

    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name bssegurosimediato.com.br www.bssegurosimediato.com.br;

    ssl_certificate /etc/letsencrypt/live/bssegurosimediato.com.br/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/bssegurosimediato.com.br/privkey.pem;
EOF
else
    echo "  AVISO: Certificados SSL nao encontrados para PROD - usando apenas HTTP"
    cat > /etc/nginx/sites-available/bssegurosimediato.com.br << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name bssegurosimediato.com.br www.bssegurosimediato.com.br;
EOF
fi

cat >> /etc/nginx/sites-available/bssegurosimediato.com.br << 'EOF'

    root /var/www/html/prod/root;
    index index.php index.html;

    access_log /var/log/nginx/prod_access.log;
    error_log /var/log/nginx/prod_error.log;

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php8.3-fpm-prod.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
        
        add_header 'Access-Control-Allow-Origin' '\$http_origin' always;
        add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type, X-Webflow-Signature, X-Webflow-Timestamp' always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

echo "3.5 Ativando sites Nginx..."
ln -sf /etc/nginx/sites-available/dev.bssegurosimediato.com.br /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/bssegurosimediato.com.br /etc/nginx/sites-enabled/

echo "3.6 Testando configuração Nginx..."
nginx -t

echo "3.7 Reiniciando serviços..."
systemctl restart php8.3-fpm
systemctl enable php8.3-fpm
systemctl restart nginx
systemctl enable nginx

echo ""
echo "✅ Configuracao concluida!"
echo ""

# ==================== RESUMO ====================
echo "=========================================="
echo "MIGRACAO CONCLUIDA!"
echo "=========================================="
echo ""
echo "PROXIMOS PASSOS:"
echo "1. Copiar arquivos do Windows para o servidor"
echo "2. Instalar AWS SDK via Composer (apos copiar composer.json)"
echo "3. Configurar credenciais AWS reais no PHP-FPM"
echo "4. Configurar senha MySQL PROD no PHP-FPM"
echo ""
echo "Comandos para instalar AWS SDK:"
echo "  cd /var/www/html/dev/root && composer install"
echo "  cd /var/www/html/prod/root && composer install"
echo ""

