# 📊 RELATÓRIO: COMPARAÇÃO AMBIENTES DEV vs PROD

**Data:** 2025-11-14 09:08:16  
**Servidor DEV:** root@65.108.156.14  
**Servidor PROD:** root@157.180.36.223  
**Status:** 🔍 **ANÁLISE EM ANDAMENTO**

---

## 🎯 OBJETIVO

Identificar diferenças entre os ambientes DEV e PROD para ajustar o ambiente de produção e garantir que todos os arquivos .js e .php funcionem corretamente.

---

## 📋 ARQUIVOS DO PROJETO

### **Arquivos JavaScript (.js)**
- FooterCodeSiteDefinitivoCompleto.js
- MODAL_WHATSAPP_DEFINITIVO.js
- webflow_injection_limpo.js

### **Arquivos PHP (.php)**
- dd_flyingdonkeys.php
- dd_webflow_octa.php
- config.php
- config_env.js.php
- class.php
- ProfessionalLogger.php
- log_endpoint.php
- send_email_notification_endpoint.php
- send_admin_notification_ses.php
- cpf-validate.php
- placa-validate.php
- mail_template_loader.php

### **Templates de Email**
- mail_templates/template_modal.php
- mail_templates/template_primeiro_contato.php
- mail_templates/template_logging.php

---
## 📁 1. COMPARAÇÃO DE ARQUIVOS

### **Arquivos JavaScript (.js)**

| Arquivo | Status DEV | Status PROD | Hash DEV | Hash PROD | Diferença |
|---------|-----------|-------------|----------|-----------|-----------|
| FooterCodeSiteDefinitivoCompleto.js | ✅ Existe | ✅ Existe | 340BCF9191009EA1E3493C7DB5EF5502C55B384C65F901433065614ECC23DB10 | 943E3F37F1C8B8C71B59B4C27B74C79CC03CABE469F27F31AD74DC891ADA8F67 | ⚠️ **DIFERENTES** |
| MODAL_WHATSAPP_DEFINITIVO.js | ✅ Existe | ✅ Existe | A98C1DCBA1B6F496C6F4F913C77D5A270EF02E2EE668DD77537D42555B994EC8 | A98C1DCBA1B6F496C6F4F913C77D5A270EF02E2EE668DD77537D42555B994EC8 | ✅ **IDÊNTICOS** |
| webflow_injection_limpo.js | ✅ Existe | ✅ Existe | 9837AA2A2C5019C40EFD09114840446E6F73C6584062C611E07156FE8E6ECFAA | 9D48E10908B8F9ACB40441A473F2F29009ACA66B23DF021BBF480636BA126839 | ⚠️ **DIFERENTES** |

### **Arquivos PHP (.php)**

| Arquivo | Status DEV | Status PROD | Hash DEV | Hash PROD | Diferença |
|---------|-----------|-------------|----------|-----------|-----------|
| add_flyingdonkeys.php | ✅ Existe | ✅ Existe | 3E79045E4CFA737E64ACFB71FC96D07E473F42C95D6F8ABB81D76773DE4A79DC | 6F668732FF6852BD75E5D046BB349D1DDEB69FFBFC9B401C05AE6D4C2D4F3F03 | ⚠️ **DIFERENTES** |
| add_webflow_octa.php | ✅ Existe | ✅ Existe | D6927A9A2D67CD7E9BFAA06AC647DB2E448CB4AE126CADAE90A1D2FFBDD88F7D | 554F174A3A6A93B69B6F98153A95274007987C85AD858DD3DDAA4869E8A5AA89 | ⚠️ **DIFERENTES** |
| config.php | ✅ Existe | ✅ Existe | 7FD0C886F48818DB1C7C0CA30A5648641B3201BB01C441FEFE5B67F2AD9DBF1E | 7FD0C886F48818DB1C7C0CA30A5648641B3201BB01C441FEFE5B67F2AD9DBF1E | ✅ **IDÊNTICOS** |
| config_env.js.php | ✅ Existe | ✅ Existe | 42EC9E633EEFFE2A6B28710460CAFED510E83B1026A4AF71B4AF082BF1E61667 | 42EC9E633EEFFE2A6B28710460CAFED510E83B1026A4AF71B4AF082BF1E61667 | ✅ **IDÊNTICOS** |
| class.php | ✅ Existe | ✅ Existe | 5A2728E22C2269261246B2AE838F009AF9803DB898F25BD776C5D9A3AD16BA24 | 5A2728E22C2269261246B2AE838F009AF9803DB898F25BD776C5D9A3AD16BA24 | ✅ **IDÊNTICOS** |
| ProfessionalLogger.php | ✅ Existe | ✅ Existe | 68D13059C0C264FC8DD9CECCCCAB9021D078071A895DAF5944D59317227BBACA | 68D13059C0C264FC8DD9CECCCCAB9021D078071A895DAF5944D59317227BBACA | ✅ **IDÊNTICOS** |
| log_endpoint.php | ✅ Existe | ✅ Existe | 26ED3A2CDF13E691FB636D98474617392D9D0D43FF369D778162344A71B6D64A | 26ED3A2CDF13E691FB636D98474617392D9D0D43FF369D778162344A71B6D64A | ✅ **IDÊNTICOS** |
| send_email_notification_endpoint.php | ✅ Existe | ✅ Existe | 0F26BA79BB30F2C89C9737080CAE3E74648FAC9B6CCAB239FD5A369FE83FF290 | 0F26BA79BB30F2C89C9737080CAE3E74648FAC9B6CCAB239FD5A369FE83FF290 | ✅ **IDÊNTICOS** |
| send_admin_notification_ses.php | ✅ Existe | ✅ Existe | 45A84226F9480456E1D0A8AE8B067CA5DCA5DE6B381E39E4581B3653B3D8D08A | 45A84226F9480456E1D0A8AE8B067CA5DCA5DE6B381E39E4581B3653B3D8D08A | ✅ **IDÊNTICOS** |
| cpf-validate.php | ✅ Existe | ✅ Existe | 4696C0155D33A90F39E9C2F8BCF7771F4E97828E53EDE46903C47B028A99103F | DB92B25F4E6884DA38D2543AE25CEE08B22614DC06450BCF23DCE53AB1ABB504 | ⚠️ **DIFERENTES** |
| placa-validate.php | ✅ Existe | ✅ Existe | 324573946D94E301BDCB92E06F18DB26625C1C6F0727F8C5ECC1BA7A8000CB1E | A5A6ECB2244801630CD2E942E6215E28C7EA7A575E48ABEEF4D62465049FC134 | ⚠️ **DIFERENTES** |
| email_template_loader.php | ✅ Existe | ✅ Existe | 27972F419C9BBF801EB96D71811B35BB6D8BB08788EB142677CA3674F0C97814 | 27972F419C9BBF801EB96D71811B35BB6D8BB08788EB142677CA3674F0C97814 | ✅ **IDÊNTICOS** |
---

## 🔧 2. VARIÁVEIS DE AMBIENTE PHP-FPM

### **Variáveis DEV**

```
env[APP_BASE_DIR] = /var/www/html/dev/root
env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br
env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_REGION] = us-east-1
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
env[LOG_DB_HOST] = localhost
env[LOG_DB_NAME] = rpa_logs_dev
env[LOG_DB_PASS] = tYbAwe7QkKNrHSRhaWplgsSxt
env[LOG_DB_PORT] = 3306
env[LOG_DB_USER] = rpa_logger_dev
env[LOG_DIR] = /var/log/webflow-segurosimediato
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[PHP_ENV] = development
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 5e93a6f31e520738ce8bf4770f32929bec207696ad9ca54f6f5e67813c33ae40
env[WEBFLOW_SECRET_OCTADESK] = 000b928364360d28af0db403c33aa5ec39d8ea9a8358add26a41f9ef951e6246
```

### **Variáveis PROD**

```
env[APP_BASE_DIR] = /var/www/html/prod/root
env[APP_BASE_URL] = https://prod.bssegurosimediato.com.br
env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_REGION] = us-east-1
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
env[LOG_DB_HOST] = localhost
env[LOG_DB_NAME] = rpa_logs_dev
env[LOG_DB_PASS] = tYbAwe7QkKNrHSRhaWplgsSxt
env[LOG_DB_PORT] = 3306
env[LOG_DB_USER] = rpa_logger_dev
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[PHP_ENV] = production
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
env[WEBFLOW_SECRET_OCTADESK] = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291
```

### **Análise de Diferenças**

| Variável | Valor DEV | Valor PROD | Status |
|----------|-----------|------------|--------|
| APP_BASE_DIR | ⚠️ /var/www/html/dev/root | ⚠️ /var/www/html/prod/root | ⚠️ **DIFERENTES** |
| APP_BASE_URL | ⚠️ https://dev.bssegurosimediato.com.br | ⚠️ https://prod.bssegurosimediato.com.br | ⚠️ **DIFERENTES** |
| APP_ENVIRONMENT | ❌ Não existe | ❌ Não existe | ⚠️ **NÃO ENCONTRADO** |
| PHP_ENV | ⚠️ development | ⚠️ production | ⚠️ **DIFERENTES** |
| LOG_DIR | ✅ /var/log/webflow-segurosimediato | ❌ **FALTANDO** | 🔴 **FALTANDO EM PROD** |
| WEBFLOW_SECRET_FLYINGDONKEYS | ⚠️ 5e93a6f31e520738ce8bf4770f32929bec207696ad9ca54f6f5e67813c33ae40 | ⚠️ 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142 | ⚠️ **DIFERENTES** |
| WEBFLOW_SECRET_OCTADESK | ⚠️ 000b928364360d28af0db403c33aa5ec39d8ea9a8358add26a41f9ef951e6246 | ⚠️ 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291 | ⚠️ **DIFERENTES** |
| ESPOCRM_URL | ✅ https://dev.flyingdonkeys.com.br | ✅ https://dev.flyingdonkeys.com.br | ✅ **IDÊNTICOS** |
| LOG_DB_NAME | ✅ rpa_logs_dev | ✅ rpa_logs_dev | ✅ **IDÊNTICOS** |
| LOG_DB_USER | ✅ rpa_logger_dev | ✅ rpa_logger_dev | ✅ **IDÊNTICOS** |

---

## 🌐 3. CONFIGURAÇÃO NGINX

### **Status**

| Ambiente | Arquivo | Status |
|----------|---------|--------|
| DEV | /etc/nginx/sites-available/dev.bssegurosimediato.com.br | ✅ Existe |
| PROD | /etc/nginx/sites-available/prod.bssegurosimediato.com.br | ✅ Existe |

---

## 🔒 4. CERTIFICADOS SSL

| Ambiente | Domínio | Certificado | Status |
|----------|---------|-------------|--------|
| DEV | dev.bssegurosimediato.com.br | ✅ Existe | ✅ Ativo |
| PROD | prod.bssegurosimediato.com.br | ✅ Existe | ✅ Ativo |

---

## 📂 5. ESTRUTURA DE DIRETÓRIOS

### **Diretórios DEV**

```
/var/www/html/dev/root
/var/www/html/dev/root/email_templates
/var/www/html/dev/root/logs
/var/www/html/dev/root/TESTES
/var/www/html/dev/root/vendor
/var/www/html/dev/root/vendor/aws
/var/www/html/dev/root/vendor/bin
/var/www/html/dev/root/vendor/composer
/var/www/html/dev/root/vendor/guzzlehttp
/var/www/html/dev/root/vendor/mtdowling
/var/www/html/dev/root/vendor/psr
/var/www/html/dev/root/vendor/ralouphie
/var/www/html/dev/root/vendor/symfony
/var/www/html/dev/root/webhooks
```

### **Diretórios PROD**

```
/var/www/html/prod/root
/var/www/html/prod/root/email_templates
```

---

## 📊 RESUMO DA COMPARAÇÃO

### **Estatísticas**

| Categoria | Total | Idênticos | Diferentes | Faltando em PROD |
|-----------|-------|-----------|------------|------------------|
| Arquivos .js | 3 | 1 | 2 | 0 |
| Arquivos .php | 12 | 8 | 4 | 0 |
| **TOTAL** | **15** | **9** | **6** | **0** |

### **Arquivos Faltando em PROD**

- ✅ Nenhum arquivo faltando

### **Arquivos com Diferenças**

- ⚠️ **FooterCodeSiteDefinitivoCompleto.js**
- ⚠️ **webflow_injection_limpo.js**
- ⚠️ **add_flyingdonkeys.php**
- ⚠️ **add_webflow_octa.php**
- ⚠️ **cpf-validate.php**
- ⚠️ **placa-validate.php**


---

## 🎯 RECOMENDAÇÕES

### **Ações Prioritárias**

1. **Copiar arquivos faltantes para PROD:**
   - OK Nenhum arquivo faltando
2. **Atualizar arquivos diferentes em PROD:**
   - FooterCodeSiteDefinitivoCompleto.js
   - webflow_injection_limpo.js
   - add_flyingdonkeys.php
   - add_webflow_octa.php
   - cpf-validate.php
   - placa-validate.php

3. **Verificar e ajustar variáveis de ambiente PHP-FPM em PROD:**
   - Verificar se todas as variáveis críticas estão configuradas
   - Ajustar valores específicos de PROD (APP_BASE_DIR, APP_BASE_URL, APP_ENVIRONMENT, etc.)

4. **Verificar configuração Nginx PROD:**
   - Garantir que configuração existe e está correta
   - Verificar locations específicos (placa-validate.php, cpf-validate.php)

5. **Obter certificado SSL para PROD:**
   - Configurar DNS primeiro
   - Executar Certbot após DNS propagado

---

## 📝 PRÓXIMOS PASSOS

1. ✅ Revisar este relatório
2. ⏳ Copiar arquivos faltando para PROD
3. ⏳ ⏳ Atualizar arquivos diferentes em PROD
4. ⏳ Verificar e ajustar variáveis de ambiente PHP-FPM
5. ⏳ Verificar configuração Nginx PROD
6. ⏳ Obter certificado SSL PROD
7. ⏳ Testar funcionamento de todos os arquivos .js e .php em PROD

---

**Relatório gerado em:** 2025-11-14 09:11:46  
**Script:** comparar_ambientes_dev_prod.ps1

