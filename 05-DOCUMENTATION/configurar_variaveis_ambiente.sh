#!/bin/bash
# Script para configurar variáveis de ambiente persistentes
# Executar no servidor 65.108.156.14

set -e

echo "=========================================="
echo "CONFIGURACAO DE VARIAVEIS DE AMBIENTE"
echo "=========================================="
echo ""

# ==================== FASE 1: VARIÁVEIS GLOBAIS DO SISTEMA ====================
echo "FASE 1: Configurando variaveis globais do sistema..."

# Criar diretório se não existir
mkdir -p /etc/environment.d

# Criar arquivo de ambiente global
cat > /etc/environment.d/webhooks.conf << 'EOF'
# Variáveis de ambiente para Webhooks Server
# Carregadas automaticamente em todos os shells e serviços

# Ambiente (será sobrescrito por PHP-FPM pool específico)
PHP_ENV=development

# Diretórios base
APP_BASE_DIR_DEV=/var/www/html/dev/root
APP_BASE_DIR_PROD=/var/www/html/prod/root
APP_BASE_URL_DEV=https://dev.bssegurosimediato.com.br
APP_BASE_URL_PROD=https://bssegurosimediato.com.br

# CORS Origins
APP_CORS_ORIGINS_DEV=https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br
APP_CORS_ORIGINS_PROD=https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://bpsegurosimediato.com.br

# Banco de dados DEV
LOG_DB_HOST_DEV=localhost
LOG_DB_PORT_DEV=3306
LOG_DB_NAME_DEV=rpa_logs_dev
LOG_DB_USER_DEV=rpa_logger_dev
LOG_DB_PASS_DEV=tYbAwe7QkKNrHSRhaWplgsSxt

# Banco de dados PROD
LOG_DB_HOST_PROD=localhost
LOG_DB_PORT_PROD=3306
LOG_DB_NAME_PROD=rpa_logs_prod
LOG_DB_USER_PROD=rpa_logger_prod
LOG_DB_PASS_PROD=[SENHA_PROD]

# EspoCRM DEV
ESPOCRM_URL_DEV=https://dev.flyingdonkeys.com.br
ESPOCRM_API_KEY_DEV=73b5b7983bfc641cdba72d204a48ed9d

# EspoCRM PROD
ESPOCRM_URL_PROD=https://flyingdonkeys.com.br
ESPOCRM_API_KEY_PROD=82d5f667f3a65a9a43341a0705be2b0c

# Webflow Secrets DEV
WEBFLOW_SECRET_FLYINGDONKEYS_DEV=888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
WEBFLOW_SECRET_OCTADESK_DEV=1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291

# Webflow Secrets PROD
WEBFLOW_SECRET_FLYINGDONKEYS_PROD=ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990
WEBFLOW_SECRET_OCTADESK_PROD=4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f

# OctaDesk (compartilhado)
OCTADESK_API_KEY=b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
OCTADESK_API_BASE=https://o205242-d60.api004.octadesk.services

# AWS SES DEV (SUBSTITUIR COM CREDENCIAIS REAIS)
AWS_ACCESS_KEY_ID_DEV=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY_DEV=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_REGION_DEV=us-east-1
AWS_SES_FROM_EMAIL_DEV=noreply@bssegurosimediato.com.br
AWS_SES_ADMIN_EMAILS_DEV=lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com

# AWS SES PROD (SUBSTITUIR COM CREDENCIAIS REAIS)
AWS_ACCESS_KEY_ID_PROD=[AWS_KEY_PROD]
AWS_SECRET_ACCESS_KEY_PROD=[AWS_SECRET_PROD]
AWS_REGION_PROD=us-east-1
AWS_SES_FROM_EMAIL_PROD=noreply@bssegurosimediato.com.br
AWS_SES_ADMIN_EMAILS_PROD=lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
EOF

chmod 644 /etc/environment.d/webhooks.conf

echo "  ✅ Arquivo /etc/environment.d/webhooks.conf criado"
echo ""

# ==================== FASE 2: ATUALIZAR PHP-FPM POOLS ====================
echo "FASE 2: Atualizando pools PHP-FPM com variaveis persistentes..."

# Backup dos arquivos existentes
cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup.$(date +%Y%m%d_%H%M%S)
if [ -f /etc/php/8.3/fpm/pool.d/prod.conf ]; then
    cp /etc/php/8.3/fpm/pool.d/prod.conf /etc/php/8.3/fpm/pool.d/prod.conf.backup.$(date +%Y%m%d_%H%M%S)
fi

# Atualizar pool DEV (www.conf)
# Remover variáveis antigas se existirem e adicionar novas
sed -i '/^env\[PHP_ENV\]/d' /etc/php/8.3/fpm/pool.d/www.conf
sed -i '/^env\[APP_BASE_DIR\]/d' /etc/php/8.3/fpm/pool.d/www.conf
sed -i '/^env\[APP_BASE_URL\]/d' /etc/php/8.3/fpm/pool.d/www.conf
sed -i '/^env\[APP_CORS_ORIGINS\]/d' /etc/php/8.3/fpm/pool.d/www.conf
sed -i '/^env\[LOG_DB_/d' /etc/php/8.3/fpm/pool.d/www.conf
sed -i '/^env\[ESPOCRM_/d' /etc/php/8.3/fpm/pool.d/www.conf
sed -i '/^env\[WEBFLOW_SECRET_/d' /etc/php/8.3/fpm/pool.d/www.conf
sed -i '/^env\[OCTADESK_/d' /etc/php/8.3/fpm/pool.d/www.conf
sed -i '/^env\[AWS_/d' /etc/php/8.3/fpm/pool.d/www.conf

# Adicionar variáveis DEV ao final do pool
cat >> /etc/php/8.3/fpm/pool.d/www.conf << 'EOF'

; ==================== VARIÁVEIS DE AMBIENTE DEV ====================
; Carregadas automaticamente em todas as requisições PHP

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

; AWS SES DEV (SUBSTITUIR COM CREDENCIAIS REAIS)
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_REGION] = us-east-1
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
EOF

echo "  ✅ Pool DEV (www.conf) atualizado"

# Criar/Atualizar pool PROD
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

; ==================== VARIÁVEIS DE AMBIENTE PROD ====================
; Carregadas automaticamente em todas as requisições PHP

env[PHP_ENV] = production
env[APP_BASE_DIR] = /var/www/html/prod/root
env[APP_BASE_URL] = https://bssegurosimediato.com.br
env[APP_CORS_ORIGINS] = https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://bpsegurosimediato.com.br

; Banco de dados PROD
env[LOG_DB_HOST] = localhost
env[LOG_DB_PORT] = 3306
env[LOG_DB_NAME] = rpa_logs_prod
env[LOG_DB_USER] = rpa_logger_prod
env[LOG_DB_PASS] = [SENHA_PROD]

; EspoCRM PROD
env[ESPOCRM_URL] = https://flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 82d5f667f3a65a9a43341a0705be2b0c

; Webflow Secrets PROD
env[WEBFLOW_SECRET_FLYINGDONKEYS] = ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990
env[WEBFLOW_SECRET_OCTADESK] = 4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f

; OctaDesk
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services

; AWS SES PROD (SUBSTITUIR COM CREDENCIAIS REAIS)
env[AWS_ACCESS_KEY_ID] = [AWS_KEY_PROD]
env[AWS_SECRET_ACCESS_KEY] = [AWS_SECRET_PROD]
env[AWS_REGION] = us-east-1
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
EOF

echo "  ✅ Pool PROD (prod.conf) atualizado"
echo ""

# ==================== FASE 3: SYSTEMD ENVIRONMENT ====================
echo "FASE 3: Configurando variaveis para systemd..."

# Criar arquivo de ambiente para PHP-FPM
mkdir -p /etc/systemd/system/php8.3-fpm.service.d/
cat > /etc/systemd/system/php8.3-fpm.service.d/environment.conf << 'EOF'
[Service]
# Variáveis de ambiente serão carregadas dos pools PHP-FPM
# Não é necessário definir aqui, pois PHP-FPM lê dos arquivos de pool
EOF

echo "  ✅ Arquivo systemd criado"
echo ""

# ==================== FASE 4: SCRIPT DE CARREGAMENTO ====================
echo "FASE 4: Criando script de carregamento automatico..."

# Criar script que será executado no boot
cat > /etc/profile.d/webhooks-env.sh << 'EOF'
#!/bin/bash
# Carregar variáveis de ambiente do webhooks server
# Este arquivo é executado automaticamente em todos os shells

if [ -f /etc/environment.d/webhooks.conf ]; then
    set -a
    source /etc/environment.d/webhooks.conf
    set +a
fi
EOF

chmod +x /etc/profile.d/webhooks-env.sh

echo "  ✅ Script /etc/profile.d/webhooks-env.sh criado"
echo ""

# ==================== FASE 5: VALIDAÇÃO E REINÍCIO ====================
echo "FASE 5: Validando e reiniciando servicos..."

# Validar configuração PHP-FPM
php-fpm8.3 -t

# Reiniciar PHP-FPM para carregar novas variáveis
systemctl daemon-reload
systemctl restart php8.3-fpm

# Verificar status
systemctl status php8.3-fpm --no-pager -l | head -10

echo ""
echo "=========================================="
echo "CONFIGURACAO CONCLUIDA!"
echo "=========================================="
echo ""
echo "VARIAVEIS CONFIGURADAS:"
echo "  - /etc/environment.d/webhooks.conf (global)"
echo "  - /etc/php/8.3/fpm/pool.d/www.conf (DEV)"
echo "  - /etc/php/8.3/fpm/pool.d/prod.conf (PROD)"
echo "  - /etc/profile.d/webhooks-env.sh (shells)"
echo ""
echo "TESTAR VARIAVEIS:"
echo "  php -r \"echo getenv('PHP_ENV') . PHP_EOL;\""
echo "  php -r \"echo \$_ENV['APP_BASE_URL'] . PHP_EOL;\""
echo ""
echo "IMPORTANTE:"
echo "  - Substituir [SENHA_PROD] pela senha real do MySQL PROD"
echo "  - Substituir [AWS_KEY_PROD] e [AWS_SECRET_PROD] pelas credenciais AWS reais"
echo "  - As variaveis serao carregadas automaticamente apos reiniciar o servidor"
echo ""

