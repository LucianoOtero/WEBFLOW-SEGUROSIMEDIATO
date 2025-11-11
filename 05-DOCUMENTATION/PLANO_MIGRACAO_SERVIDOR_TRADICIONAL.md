# 🚀 PLANO DE MIGRAÇÃO: CONTAINERS → SERVIDOR TRADICIONAL

**Data:** 10/11/2025  
**Objetivo:** Eliminar containers Docker e migrar para servidor tradicional limpo

---

## 📋 RESUMO EXECUTIVO

### **O que será feito:**
1. ✅ **Limpeza completa** - Remover todos os containers, volumes, imagens e arquivos antigos
2. ✅ **Instalação limpa** - PHP, Nginx, MySQL, Composer, AWS SDK do zero
3. ✅ **Configuração** - Variáveis de ambiente, Nginx, PHP-FPM
4. ✅ **Cópia de arquivos** - Todos os arquivos do Windows para o servidor
5. ✅ **Estrutura limpa** - Diretórios organizados sem resquícios

---

## 🗑️ FASE 1: LIMPEZA COMPLETA

### **1.1. Parar e Remover Containers**

```bash
# Conectar no servidor
ssh root@65.108.156.14

# Parar todos os containers
docker stop $(docker ps -aq) 2>/dev/null || true

# Remover todos os containers
docker rm $(docker ps -aq) 2>/dev/null || true

# Remover todas as imagens
docker rmi $(docker images -q) 2>/dev/null || true

# Remover todos os volumes
docker volume rm $(docker volume ls -q) 2>/dev/null || true

# Remover todas as networks
docker network prune -f

# Limpar sistema Docker completamente
docker system prune -a -f --volumes
```

### **1.2. Remover Arquivos Antigos**

```bash
# Remover diretórios antigos do Docker
rm -rf /opt/webhooks-server/dev/root/*
rm -rf /opt/webhooks-server/prod/root/*
rm -rf /opt/webhooks-server/dev/logs/*
rm -rf /opt/webhooks-server/prod/logs/*

# Remover arquivos Docker
rm -rf /opt/webhooks-server/docker-compose.yml
rm -rf /opt/webhooks-server/Dockerfile
rm -rf /opt/webhooks-server/.dockerignore

# Remover diretórios de containers (se existirem)
rm -rf /var/lib/docker/containers/*
rm -rf /var/lib/docker/volumes/*

# Limpar logs antigos
rm -rf /var/log/docker*
```

### **1.3. Verificar Limpeza**

```bash
# Verificar se não há containers
docker ps -a

# Verificar se não há volumes
docker volume ls

# Verificar se não há imagens
docker images

# Verificar diretórios vazios
ls -la /opt/webhooks-server/dev/root/
ls -la /opt/webhooks-server/prod/root/
```

---

## 🔧 FASE 2: INSTALAÇÃO LIMPA

### **2.1. Atualizar Sistema**

```bash
apt update && apt upgrade -y
```

### **2.2. Instalar PHP 8.3 e Extensões**

```bash
# Adicionar repositório PHP
apt install -y software-properties-common
add-apt-repository ppa:ondrej/php -y
apt update

# Instalar PHP 8.3 e extensões necessárias
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

# Verificar instalação
php -v
php -m | grep -E "mysql|curl|mbstring"
```

### **2.3. Instalar Nginx**

```bash
apt install -y nginx

# Verificar instalação
nginx -v
systemctl status nginx
```

### **2.4. Instalar MySQL (se necessário)**

```bash
# Se MySQL já existe, pular esta etapa
# Se não existe:
apt install -y mysql-server

# Configurar MySQL
mysql_secure_installation
```

### **2.5. Instalar Composer**

```bash
# Baixar Composer
curl -sS https://getcomposer.org/installer | php

# Mover para /usr/local/bin
mv composer.phar /usr/local/bin/composer

# Tornar executável
chmod +x /usr/local/bin/composer

# Verificar instalação
composer --version
```

### **2.6. Instalar AWS SDK via Composer**

**⚠️ IMPORTANTE:** Esta etapa deve ser executada **APÓS** copiar os arquivos do Windows (FASE 4), pois precisa do `composer.json`.

```bash
# Instalar AWS SDK para DEV (após copiar composer.json)
cd /var/www/html/dev/root
composer install --no-dev --optimize-autoloader

# Instalar AWS SDK para PROD (após copiar composer.json)
cd /var/www/html/prod/root
composer install --no-dev --optimize-autoloader

# Verificar instalação
ls -la /var/www/html/dev/root/vendor/aws/aws-sdk-php
ls -la /var/www/html/prod/root/vendor/aws/aws-sdk-php
```

---

## ⚙️ FASE 3: CONFIGURAÇÃO

### **3.1. Criar Estrutura de Diretórios**

```bash
# Criar diretórios principais
mkdir -p /var/www/html/dev/root
mkdir -p /var/www/html/prod/root
mkdir -p /var/www/html/dev/logs
mkdir -p /var/www/html/prod/logs

# Definir permissões
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
```

### **3.2. Configurar Variáveis de Ambiente (PHP-FPM)**

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

Adicionar no final do arquivo:

```ini
[www]
; Variáveis de ambiente para DEV (será sobrescrito por pool específico)
env[PHP_ENV] = development
env[APP_BASE_DIR] = /var/www/html/dev/root
env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br
env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br

; Variáveis de banco de dados
env[LOG_DB_HOST] = localhost
env[LOG_DB_PORT] = 3306
env[LOG_DB_NAME] = rpa_logs_dev
env[LOG_DB_USER] = rpa_logger_dev
env[LOG_DB_PASS] = tYbAwe7QkKNrHSRhaWplgsSxt

; Variáveis EspoCRM
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d

; Variáveis Webflow
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
env[WEBFLOW_SECRET_OCTADESK] = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291

; Variáveis OctaDesk
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services

; Variáveis AWS SES
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_REGION] = us-east-1
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
```

**Criar pool separado para PROD:**

**Arquivo:** `/etc/php/8.3/fpm/pool.d/prod.conf`

```ini
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

; Variáveis de banco de dados
env[LOG_DB_HOST] = localhost
env[LOG_DB_PORT] = 3306
env[LOG_DB_NAME] = rpa_logs_prod
env[LOG_DB_USER] = rpa_logger_prod
env[LOG_DB_PASS] = [SENHA_PROD]

; Variáveis EspoCRM
env[ESPOCRM_URL] = https://flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 82d5f667f3a65a9a43341a0705be2b0c

; Variáveis Webflow
env[WEBFLOW_SECRET_FLYINGDONKEYS] = ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990
env[WEBFLOW_SECRET_OCTADESK] = 4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f

; Variáveis OctaDesk
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services

; Variáveis AWS SES
env[AWS_ACCESS_KEY_ID] = [AWS_KEY_PROD]
env[AWS_SECRET_ACCESS_KEY] = [AWS_SECRET_PROD]
env[AWS_REGION] = us-east-1
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
```

### **3.3. Configurar Nginx**

**Arquivo:** `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name dev.bssegurosimediato.com.br;

    # Redirecionar HTTP para HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name dev.bssegurosimediato.com.br;

    # SSL (Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/dev.bssegurosimediato.com.br/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/dev.bssegurosimediato.com.br/privkey.pem;

    root /var/www/html/dev/root;
    index index.php index.html;

    # Logs
    access_log /var/log/nginx/dev_access.log;
    error_log /var/log/nginx/dev_error.log;

    # PHP
    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Arquivos estáticos (JS, CSS, etc)
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # CORS headers para requisições PHP
    location ~ \.php$ {
        add_header 'Access-Control-Allow-Origin' '$http_origin' always;
        add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type, X-Webflow-Signature, X-Webflow-Timestamp' always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }
}
```

**Arquivo:** `/etc/nginx/sites-available/bssegurosimediato.com.br`

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name bssegurosimediato.com.br www.bssegurosimediato.com.br;

    # Redirecionar HTTP para HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name bssegurosimediato.com.br www.bssegurosimediato.com.br;

    # SSL (Let's Encrypt)
    ssl_certificate /etc/letsencrypt/live/bssegurosimediato.com.br/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/bssegurosimediato.com.br/privkey.pem;

    root /var/www/html/prod/root;
    index index.php index.html;

    # Logs
    access_log /var/log/nginx/prod_access.log;
    error_log /var/log/nginx/prod_error.log;

    # PHP
    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php8.3-fpm-prod.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Arquivos estáticos
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # CORS headers
    location ~ \.php$ {
        add_header 'Access-Control-Allow-Origin' '$http_origin' always;
        add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Content-Type, X-Webflow-Signature, X-Webflow-Timestamp' always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;

        if ($request_method = 'OPTIONS') {
            return 204;
        }
    }
}
```

**Ativar sites:**

```bash
# Criar links simbólicos
ln -s /etc/nginx/sites-available/dev.bssegurosimediato.com.br /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/bssegurosimediato.com.br /etc/nginx/sites-enabled/

# Testar configuração
nginx -t

# Reiniciar Nginx
systemctl restart nginx
```

### **3.4. Reiniciar PHP-FPM**

```bash
systemctl restart php8.3-fpm
systemctl enable php8.3-fpm
```

---

## 📁 FASE 4: COPIAR ARQUIVOS DO WINDOWS

### **4.1. Lista de Arquivos para DEV**

**Origem (Windows):** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`  
**Destino (Servidor):** `/var/www/html/dev/root/`

**Arquivos PHP:**
- `config.php`
- `add_flyingdonkeys.php`
- `add_webflow_octa.php`
- `send_email_notification_endpoint.php`
- `send_admin_notification_ses.php`
- `class.php`
- `cpf-validate.php`
- `placa-validate.php`
- `ProfessionalLogger.php` (se existir)
- `log_endpoint.php` (se existir)

**Arquivos JavaScript:**
- `MODAL_WHATSAPP_DEFINITIVO.js`
- `FooterCodeSiteDefinitivoCompleto.js`
- `webflow_injection_limpo.js`

**Arquivos de Configuração:**
- `composer.json` (para instalar dependências AWS SDK)

### **4.2. Lista de Arquivos para PROD**

**Origem (Windows):** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/`  
**Destino (Servidor):** `/var/www/html/prod/root/`

**Arquivos PHP:**
- `config.php`
- `add_flyingdonkeys_prod.php` → renomear para `add_flyingdonkeys.php`
- `add_webflow_octa_prod.php` → renomear para `add_webflow_octa.php`
- `send_email_notification_endpoint_prod.php` → renomear para `send_email_notification_endpoint.php`
- `send_admin_notification_ses_prod.php` → renomear para `send_admin_notification_ses.php`
- `class.php` (mesmo do dev)
- `cpf-validate.php` (mesmo do dev)
- `placa-validate.php` (mesmo do dev)
- `ProfessionalLogger.php` (se existir)

**Arquivos JavaScript:**
- `MODAL_WHATSAPP_DEFINITIVO_prod.js` → renomear para `MODAL_WHATSAPP_DEFINITIVO.js`
- `FooterCodeSiteDefinitivoCompleto_prod.js` → renomear para `FooterCodeSiteDefinitivoCompleto.js`

**Arquivos de Configuração:**
- `composer.json` (para instalar dependências AWS SDK)

### **4.3. Script de Cópia (Windows → Servidor)**

**Criar script PowerShell:** `copiar_arquivos_servidor.ps1`

```powershell
# Configurações
$servidor = "root@65.108.156.14"
$devLocal = "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"
$prodLocal = "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"
$devRemoto = "/var/www/html/dev/root"
$prodRemoto = "/var/www/html/prod/root"

# Arquivos PHP para DEV
$arquivosPHPDev = @(
    "config.php",
    "add_flyingdonkeys.php",
    "add_webflow_octa.php",
    "send_email_notification_endpoint.php",
    "send_admin_notification_ses.php",
    "class.php",
    "cpf-validate.php",
    "placa-validate.php"
)

# Arquivos JS para DEV
$arquivosJSDev = @(
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "FooterCodeSiteDefinitivoCompleto.js",
    "webflow_injection_limpo.js"
)

# Copiar arquivos DEV
Write-Host "📦 Copiando arquivos DEV..." -ForegroundColor Cyan
foreach ($arquivo in $arquivosPHPDev + $arquivosJSDev) {
    $origem = Join-Path $devLocal $arquivo
    if (Test-Path $origem) {
        Write-Host "  Copiando: $arquivo" -ForegroundColor Green
        scp $origem "${servidor}:${devRemoto}/"
    } else {
        Write-Host "  ⚠️  Não encontrado: $arquivo" -ForegroundColor Yellow
    }
}

# Arquivos PHP para PROD
$arquivosPHPProd = @(
    @{Origem="config.php"; Destino="config.php"},
    @{Origem="add_flyingdonkeys_prod.php"; Destino="add_flyingdonkeys.php"},
    @{Origem="add_webflow_octa_prod.php"; Destino="add_webflow_octa.php"},
    @{Origem="send_email_notification_endpoint_prod.php"; Destino="send_email_notification_endpoint.php"},
    @{Origem="send_admin_notification_ses_prod.php"; Destino="send_admin_notification_ses.php"},
    @{Origem="class.php"; Destino="class.php"},
    @{Origem="cpf-validate.php"; Destino="cpf-validate.php"},
    @{Origem="placa-validate.php"; Destino="placa-validate.php"}
)

# Arquivos JS para PROD
$arquivosJSProd = @(
    @{Origem="MODAL_WHATSAPP_DEFINITIVO_prod.js"; Destino="MODAL_WHATSAPP_DEFINITIVO.js"},
    @{Origem="FooterCodeSiteDefinitivoCompleto_prod.js"; Destino="FooterCodeSiteDefinitivoCompleto.js"}
)

# Copiar arquivos PROD
Write-Host "`n📦 Copiando arquivos PROD..." -ForegroundColor Cyan
foreach ($item in $arquivosPHPProd + $arquivosJSProd) {
    $origem = Join-Path $prodLocal $item.Origem
    if (Test-Path $origem) {
        Write-Host "  Copiando: $($item.Origem) → $($item.Destino)" -ForegroundColor Green
        # Copiar para servidor e renomear
        scp $origem "${servidor}:${prodRemoto}/$($item.Destino)"
    } else {
        Write-Host "  ⚠️  Não encontrado: $($item.Origem)" -ForegroundColor Yellow
    }
}

Write-Host "`n✅ Cópia concluída!" -ForegroundColor Green
```

### **4.4. Comandos Manuais (Alternativa)**

Se preferir copiar manualmente:

```bash
# No servidor, criar diretórios
mkdir -p /var/www/html/dev/root
mkdir -p /var/www/html/prod/root

# No Windows (PowerShell), copiar arquivos DEV
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\config.php" root@65.108.156.14:/var/www/html/dev/root/
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\add_flyingdonkeys.php" root@65.108.156.14:/var/www/html/dev/root/
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\add_webflow_octa.php" root@65.108.156.14:/var/www/html/dev/root/
# ... (repetir para todos os arquivos)

# Copiar arquivos PROD (renomeando)
scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\add_flyingdonkeys_prod.php" root@65.108.156.14:/var/www/html/prod/root/add_flyingdonkeys.php
# ... (repetir para todos os arquivos)
```

---

## 📦 FASE 4.5: INSTALAR AWS SDK (APÓS COPIAR ARQUIVOS)

**⚠️ Executar esta fase APÓS copiar todos os arquivos do Windows (FASE 4)**

```bash
# Instalar AWS SDK para DEV
cd /var/www/html/dev/root
composer install --no-dev --optimize-autoloader

# Instalar AWS SDK para PROD
cd /var/www/html/prod/root
composer install --no-dev --optimize-autoloader

# Verificar instalação
php -r "require 'vendor/autoload.php'; echo class_exists('Aws\Ses\SesClient') ? 'OK' : 'ERRO';"
```

---

## ✅ FASE 5: VERIFICAÇÃO E TESTES

### **5.1. Verificar Variáveis de Ambiente**

```bash
# Criar arquivo de teste
cat > /var/www/html/dev/root/test_env.php << 'EOF'
<?php
phpinfo();
EOF

# Acessar via browser: https://dev.bssegurosimediato.com.br/test_env.php
# Verificar se variáveis $_ENV estão definidas
```

### **5.2. Verificar Permissões**

```bash
# Verificar permissões
ls -la /var/www/html/dev/root/
ls -la /var/www/html/prod/root/

# Corrigir se necessário
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
```

### **5.3. Testar Endpoints**

```bash
# Testar endpoint DEV
curl -X POST https://dev.bssegurosimediato.com.br/add_flyingdonkeys.php \
  -H "Content-Type: application/json" \
  -H "Origin: https://segurosimediato-dev.webflow.io" \
  -d '{"test": true}'

# Verificar logs
tail -f /var/log/nginx/dev_error.log
tail -f /var/log/php8.3-fpm.log
```

---

## 📝 CHECKLIST FINAL

- [ ] Containers Docker removidos completamente
- [ ] Arquivos antigos removidos
- [ ] PHP 8.3 instalado e configurado
- [ ] Nginx instalado e configurado
- [ ] MySQL instalado e configurado
- [ ] Composer instalado
- [ ] AWS SDK instalado via Composer
- [ ] Variáveis de ambiente configuradas no PHP-FPM
- [ ] Nginx configurado para DEV e PROD
- [ ] Todos os arquivos copiados do Windows para DEV
- [ ] Todos os arquivos copiados do Windows para PROD
- [ ] Permissões corretas definidas
- [ ] Testes de endpoints realizados
- [ ] Logs funcionando

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Backup antes de começar:** Fazer backup completo do servidor atual
2. **Credenciais AWS:** Substituir `[AWS_KEY_PROD]` e `[AWS_SECRET_PROD]` pelas credenciais reais
3. **Senha MySQL PROD:** Substituir `[SENHA_PROD]` pela senha real
4. **SSL:** Certificados Let's Encrypt devem estar configurados
5. **Firewall:** Garantir que portas 80, 443, 22 estão abertas

---

**Documento criado em:** 10/11/2025  
**Versão:** 1.0

