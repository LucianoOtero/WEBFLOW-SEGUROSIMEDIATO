# 📋 RESUMO EXECUTIVO - MIGRAÇÃO PARA SERVIDOR TRADICIONAL

**Data:** 10/11/2025  
**Objetivo:** Eliminar containers Docker e migrar para servidor tradicional limpo

---

## 🎯 O QUE SERÁ FEITO

1. **Limpeza total** - Remover todos os containers, volumes, imagens e arquivos antigos
2. **Instalação limpa** - PHP 8.3, Nginx, MySQL, Composer do zero
3. **Configuração** - Variáveis de ambiente, Nginx, PHP-FPM
4. **Cópia de arquivos** - Todos os arquivos do Windows para o servidor
5. **Instalação AWS SDK** - Via Composer após copiar arquivos

---

## 📝 PASSOS PRINCIPAIS

### **1. LIMPEZA (No Servidor)**

```bash
# Executar script de limpeza
bash SCRIPT_LIMPEZA_SERVIDOR.sh
```

**OU manualmente:**
```bash
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true
docker rmi $(docker images -q) 2>/dev/null || true
docker volume rm $(docker volume ls -q) 2>/dev/null || true
docker system prune -a -f --volumes
rm -rf /opt/webhooks-server/*
```

---

### **2. INSTALAÇÃO (No Servidor)**

```bash
# Executar script de instalação
bash SCRIPT_INSTALACAO_SERVIDOR.sh
```

**OU manualmente:**
```bash
apt update && apt upgrade -y
apt install -y php8.3 php8.3-fpm php8.3-cli php8.3-mysql php8.3-curl php8.3-mbstring php8.3-xml php8.3-zip nginx mysql-server
curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
mkdir -p /var/www/html/{dev,prod}/root
```

---

### **3. CONFIGURAÇÃO (No Servidor)**

**3.1. Variáveis de Ambiente PHP-FPM:**
- Editar `/etc/php/8.3/fpm/pool.d/www.conf` (DEV)
- Criar `/etc/php/8.3/fpm/pool.d/prod.conf` (PROD)
- Adicionar todas as variáveis `env[...]` conforme plano completo

**3.2. Nginx:**
- Criar `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`
- Criar `/etc/nginx/sites-available/bssegurosimediato.com.br`
- Ativar sites: `ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/`
- Testar: `nginx -t && systemctl restart nginx`

**3.3. Reiniciar PHP-FPM:**
```bash
systemctl restart php8.3-fpm
systemctl enable php8.3-fpm
```

---

### **4. COPIAR ARQUIVOS (Do Windows)**

**No Windows (PowerShell):**
```powershell
cd WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT
.\copiar_arquivos_servidor.ps1
```

**OU manualmente via SCP:**
```powershell
# DEV
scp config.php root@65.108.156.14:/var/www/html/dev/root/
scp add_flyingdonkeys.php root@65.108.156.14:/var/www/html/dev/root/
scp add_webflow_octa.php root@65.108.156.14:/var/www/html/dev/root/
scp send_email_notification_endpoint.php root@65.108.156.14:/var/www/html/dev/root/
scp send_admin_notification_ses.php root@65.108.156.14:/var/www/html/dev/root/
scp class.php root@65.108.156.14:/var/www/html/dev/root/
scp cpf-validate.php root@65.108.156.14:/var/www/html/dev/root/
scp placa-validate.php root@65.108.156.14:/var/www/html/dev/root/
scp composer.json root@65.108.156.14:/var/www/html/dev/root/
scp MODAL_WHATSAPP_DEFINITIVO.js root@65.108.156.14:/var/www/html/dev/root/
scp FooterCodeSiteDefinitivoCompleto.js root@65.108.156.14:/var/www/html/dev/root/
scp webflow_injection_limpo.js root@65.108.156.14:/var/www/html/dev/root/

# PROD (renomeando)
scp ..\03-PRODUCTION\config.php root@65.108.156.14:/var/www/html/prod/root/
scp ..\03-PRODUCTION\add_flyingdonkeys_prod.php root@65.108.156.14:/var/www/html/prod/root/add_flyingdonkeys.php
scp ..\03-PRODUCTION\add_webflow_octa_prod.php root@65.108.156.14:/var/www/html/prod/root/add_webflow_octa.php
scp ..\03-PRODUCTION\send_email_notification_endpoint_prod.php root@65.108.156.14:/var/www/html/prod/root/send_email_notification_endpoint.php
scp ..\03-PRODUCTION\send_admin_notification_ses_prod.php root@65.108.156.14:/var/www/html/prod/root/send_admin_notification_ses.php
scp ..\02-DEVELOPMENT\class.php root@65.108.156.14:/var/www/html/prod/root/
scp ..\02-DEVELOPMENT\cpf-validate.php root@65.108.156.14:/var/www/html/prod/root/
scp ..\02-DEVELOPMENT\placa-validate.php root@65.108.156.14:/var/www/html/prod/root/
scp ..\03-PRODUCTION\composer.json root@65.108.156.14:/var/www/html/prod/root/
scp ..\03-PRODUCTION\MODAL_WHATSAPP_DEFINITIVO_prod.js root@65.108.156.14:/var/www/html/prod/root/MODAL_WHATSAPP_DEFINITIVO.js
scp ..\03-PRODUCTION\FooterCodeSiteDefinitivoCompleto_prod.js root@65.108.156.14:/var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js
```

---

### **5. INSTALAR AWS SDK (No Servidor)**

```bash
# DEV
cd /var/www/html/dev/root
composer install --no-dev --optimize-autoloader

# PROD
cd /var/www/html/prod/root
composer install --no-dev --optimize-autoloader

# Verificar
php -r "require 'vendor/autoload.php'; echo class_exists('Aws\Ses\SesClient') ? 'OK' : 'ERRO';"
```

---

### **6. VERIFICAÇÃO (No Servidor)**

```bash
# Verificar permissões
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Testar endpoint DEV
curl -X POST https://dev.bssegurosimediato.com.br/add_flyingdonkeys.php \
  -H "Content-Type: application/json" \
  -H "Origin: https://segurosimediato-dev.webflow.io" \
  -d '{"test": true}'

# Verificar logs
tail -f /var/log/nginx/dev_error.log
```

---

## ⚠️ ATENÇÃO

1. **Backup antes de começar** - Fazer backup completo do servidor atual
2. **Credenciais AWS** - Substituir valores placeholder pelas credenciais reais
3. **Senha MySQL PROD** - Substituir pela senha real
4. **SSL** - Certificados Let's Encrypt devem estar configurados
5. **Firewall** - Garantir que portas 80, 443, 22 estão abertas

---

## 📚 DOCUMENTAÇÃO COMPLETA

Para detalhes completos, consulte:
- `PLANO_MIGRACAO_SERVIDOR_TRADICIONAL.md` - Plano detalhado completo
- `SCRIPT_LIMPEZA_SERVIDOR.sh` - Script de limpeza
- `SCRIPT_INSTALACAO_SERVIDOR.sh` - Script de instalação
- `copiar_arquivos_servidor.ps1` - Script de cópia (Windows)

---

**Tempo estimado:** 2-3 horas  
**Complexidade:** Média-Alta  
**Risco:** Médio (com backup adequado)





