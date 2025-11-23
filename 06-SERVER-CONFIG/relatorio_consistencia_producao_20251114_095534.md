# 📊 RELATÓRIO: CONSISTÊNCIA DO AMBIENTE DE PRODUÇÃO

**Data:** 2025-11-14 09:55:34  
**Servidor PROD:** root@157.180.36.223  
**Diretório PROD:** /var/www/html/prod/root  
**Status:** 🔍 **VERIFICAÇÃO EM ANDAMENTO**

---

## 🎯 OBJETIVO

Verificar a consistência do ambiente de produção, validando arquivos, variáveis de ambiente, configurações e serviços.

---
## 📁 1. VERIFICAÇÃO DE ARQUIVOS

### **Arquivos JavaScript (.js)**

| Arquivo | Status Servidor | Status Local | Hash Servidor | Hash Local | Consistência |
|---------|----------------|--------------|---------------|------------|--------------|
| FooterCodeSiteDefinitivoCompleto.js | ✅ Existe | ✅ Existe | 340BCF9191009EA1E3493C7DB5EF5502C55B384C65F901433065614ECC23DB10 | 340BCF9191009EA1E3493C7DB5EF5502C55B384C65F901433065614ECC23DB10 | ✅ **CONSISTENTE** |
| MODAL_WHATSAPP_DEFINITIVO.js | ✅ Existe | ✅ Existe | A98C1DCBA1B6F496C6F4F913C77D5A270EF02E2EE668DD77537D42555B994EC8 | A98C1DCBA1B6F496C6F4F913C77D5A270EF02E2EE668DD77537D42555B994EC8 | ✅ **CONSISTENTE** |
| webflow_injection_limpo.js | ✅ Existe | ✅ Existe | 9837AA2A2C5019C40EFD09114840446E6F73C6584062C611E07156FE8E6ECFAA | 9837AA2A2C5019C40EFD09114840446E6F73C6584062C611E07156FE8E6ECFAA | ✅ **CONSISTENTE** |

### **Arquivos PHP (.php)**

| Arquivo | Status Servidor | Status Local | Hash Servidor | Hash Local | Consistência |
|---------|----------------|--------------|---------------|------------|--------------|
| add_flyingdonkeys.php | ✅ Existe | ✅ Existe | 3E79045E4CFA737E64ACFB71FC96D07E473F42C95D6F8ABB81D76773DE4A79DC | 3E79045E4CFA737E64ACFB71FC96D07E473F42C95D6F8ABB81D76773DE4A79DC | ✅ **CONSISTENTE** |
| add_webflow_octa.php | ✅ Existe | ✅ Existe | D6927A9A2D67CD7E9BFAA06AC647DB2E448CB4AE126CADAE90A1D2FFBDD88F7D | D6927A9A2D67CD7E9BFAA06AC647DB2E448CB4AE126CADAE90A1D2FFBDD88F7D | ✅ **CONSISTENTE** |
| config.php | ✅ Existe | ✅ Existe | 7FD0C886F48818DB1C7C0CA30A5648641B3201BB01C441FEFE5B67F2AD9DBF1E | 7FD0C886F48818DB1C7C0CA30A5648641B3201BB01C441FEFE5B67F2AD9DBF1E | ✅ **CONSISTENTE** |
| config_env.js.php | ✅ Existe | ✅ Existe | 42EC9E633EEFFE2A6B28710460CAFED510E83B1026A4AF71B4AF082BF1E61667 | 42EC9E633EEFFE2A6B28710460CAFED510E83B1026A4AF71B4AF082BF1E61667 | ✅ **CONSISTENTE** |
| class.php | ✅ Existe | ✅ Existe | 5A2728E22C2269261246B2AE838F009AF9803DB898F25BD776C5D9A3AD16BA24 | 5A2728E22C2269261246B2AE838F009AF9803DB898F25BD776C5D9A3AD16BA24 | ✅ **CONSISTENTE** |
| ProfessionalLogger.php | ✅ Existe | ✅ Existe | 68D13059C0C264FC8DD9CECCCCAB9021D078071A895DAF5944D59317227BBACA | 68D13059C0C264FC8DD9CECCCCAB9021D078071A895DAF5944D59317227BBACA | ✅ **CONSISTENTE** |
| log_endpoint.php | ✅ Existe | ✅ Existe | 26ED3A2CDF13E691FB636D98474617392D9D0D43FF369D778162344A71B6D64A | 26ED3A2CDF13E691FB636D98474617392D9D0D43FF369D778162344A71B6D64A | ✅ **CONSISTENTE** |
| send_email_notification_endpoint.php | ✅ Existe | ✅ Existe | 0F26BA79BB30F2C89C9737080CAE3E74648FAC9B6CCAB239FD5A369FE83FF290 | 0F26BA79BB30F2C89C9737080CAE3E74648FAC9B6CCAB239FD5A369FE83FF290 | ✅ **CONSISTENTE** |
| send_admin_notification_ses.php | ✅ Existe | ✅ Existe | 45A84226F9480456E1D0A8AE8B067CA5DCA5DE6B381E39E4581B3653B3D8D08A | 45A84226F9480456E1D0A8AE8B067CA5DCA5DE6B381E39E4581B3653B3D8D08A | ✅ **CONSISTENTE** |
| cpf-validate.php | ✅ Existe | ✅ Existe | 4696C0155D33A90F39E9C2F8BCF7771F4E97828E53EDE46903C47B028A99103F | 4696C0155D33A90F39E9C2F8BCF7771F4E97828E53EDE46903C47B028A99103F | ✅ **CONSISTENTE** |
| placa-validate.php | ✅ Existe | ✅ Existe | 324573946D94E301BDCB92E06F18DB26625C1C6F0727F8C5ECC1BA7A8000CB1E | 324573946D94E301BDCB92E06F18DB26625C1C6F0727F8C5ECC1BA7A8000CB1E | ✅ **CONSISTENTE** |
| email_template_loader.php | ✅ Existe | ✅ Existe | 27972F419C9BBF801EB96D71811B35BB6D8BB08788EB142677CA3674F0C97814 | 27972F419C9BBF801EB96D71811B35BB6D8BB08788EB142677CA3674F0C97814 | ✅ **CONSISTENTE** |
| aws_ses_config.php | ✅ Existe | ✅ Existe | 72504734D7B44DB222740ED24BDC1C61626150BA3FD2EC8A06E5F8C22AAB7310 | 72504734D7B44DB222740ED24BDC1C61626150BA3FD2EC8A06E5F8C22AAB7310 | ✅ **CONSISTENTE** |

### **Templates de Email**

| Arquivo | Status Servidor | Status Local | Hash Servidor | Hash Local | Consistência |
|---------|----------------|--------------|---------------|------------|--------------|
| template_modal.php | ✅ Existe | ✅ Existe | FDB14FF4D75498D82E9A130F9372F60415CE4296BE7D8D6E3E4226DCA6E33DB5 | FDB14FF4D75498D82E9A130F9372F60415CE4296BE7D8D6E3E4226DCA6E33DB5 | ✅ **CONSISTENTE** |
| template_primeiro_contato.php | ✅ Existe | ✅ Existe | 4560AB9D7171423572E7510FAFFB23A30C3471ACC0754C767492E22A490D303B | 4560AB9D7171423572E7510FAFFB23A30C3471ACC0754C767492E22A490D303B | ✅ **CONSISTENTE** |
| template_logging.php | ✅ Existe | ✅ Existe | D24B3FBE965158136517530E3CA9B66FF22A057491468673C2B824FA09960C23 | D24B3FBE965158136517530E3CA9B66FF22A057491468673C2B824FA09960C23 | ✅ **CONSISTENTE** |
---

## 🔧 2. VARIÁVEIS DE AMBIENTE PHP-FPM

| Variável | Valor Esperado | Valor Atual | Status |
|----------|---------------|-------------|--------|
| LOG_DB_USER | rpa_logger_prod | rpa_logger_prod | ✅ **CORRETO** |
| PHP_ENV | production | production | ✅ **CORRETO** |
| LOG_DIR | /var/log/webflow-segurosimediato | /var/log/webflow-segurosimediato | ✅ **CORRETO** |
| LOG_DB_NAME | rpa_logs_prod | rpa_logs_prod | ✅ **CORRETO** |
| APP_BASE_URL | https://prod.bssegurosimediato.com.br | https://prod.bssegurosimediato.com.br | ✅ **CORRETO** |
| APP_BASE_DIR | /var/www/html/prod/root | /var/www/html/prod/root | ✅ **CORRETO** |
| ESPOCRM_URL | https://flyingdonkeys.com.br | https://flyingdonkeys.com.br | ✅ **CORRETO** |
| APP_CORS_ORIGINS | https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br | https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br | ✅ **CORRETO** |
| WEBFLOW_SECRET_FLYINGDONKEYS | (definida) | 888931809d5215258729... | ✅ **DEFINIDA** |
| WEBFLOW_SECRET_OCTADESK | (definida) | 1dead60b2edf3bab32d8... | ✅ **DEFINIDA** |
---

## 🌐 3. CONFIGURAÇÃO NGINX

| Item | Status | Detalhes |
|------|--------|----------|
| Arquivo de configuração | ✅ Existe | /etc/nginx/sites-available/prod.bssegurosimediato.com.br |
| server_name | ✅ Correto | prod.bssegurosimediato.com.br |
| document root | ✅ Correto | /var/www/html/prod/root |
---

## 🔒 4. CERTIFICADO SSL

| Item | Status |
|------|--------|
| Certificado existe | ✅ Sim |
| Certificado válido | ✅ Sim |
---

## ⚙️ 5. SERVIÇOS

| Serviço | Status |
|---------|--------|
| Nginx | ✅ Ativo |
| PHP-FPM 8.3 | ✅ Ativo |
---

## 🔐 6. PERMISSÕES DE ARQUIVOS

| Arquivo | Permissões | Proprietário | Status |
|---------|-----------|--------------|--------|
| config.php | 755 | www-data:www-data | ✅ **CORRETO** |
| FooterCodeSiteDefinitivoCompleto.js | 755 | www-data:www-data | ✅ **CORRETO** |
| add_flyingdonkeys.php | 755 | www-data:www-data | ✅ **CORRETO** |
---

## 📂 7. ESTRUTURA DE DIRETÓRIOS

| Diretório | Status |
|----------|--------|
| /var/www/html/prod/root | ✅ **EXISTE** |
| /var/www/html/prod/root/email_templates | ✅ **EXISTE** |
| /var/log/webflow-segurosimediato | ✅ **EXISTE** |
---

## 🌐 8. TESTE DE ACESSO HTTPS

| URL | Status | Detalhes |
|-----|--------|----------|
| https://prod.bssegurosimediato.com.br | ✅ **ACESSÍVEL** | HTTP 200 OK |
| https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js | ✅ **ACESSÍVEL** | HTTP 200 OK |
| https://prod.bssegurosimediato.com.br/config.php | ✅ **ACESSÍVEL** | HTTP 200 OK |
---

## 📊 RESUMO DA VERIFICAÇÃO

### **Estatísticas**

| Categoria | Total | ✅ Passou | ⚠️ Avisos | ❌ Falhou |
|-----------|-------|-----------|-----------|-----------|
| **TOTAL** | **45** | **45** | **0** | **0** |

### **Status Geral**

✅ **AMBIENTE CONSISTENTE** - Todas as verificações passaram

### **Arquivos Faltando no Servidor**

- ✅ Nenhum arquivo faltando

### **Arquivos Inconsistentes**

- OK - Nenhum arquivo inconsistente

### **Variáveis de Ambiente com Problemas**

- OK - Todas as variáveis estão corretas

---

## 🎯 RECOMENDAÇÕES

### **Ações Prioritárias**

1. OK - Nenhum arquivo faltando

2. OK - Nenhum arquivo precisa ser atualizado

3. OK - Todas as variáveis estão corretas

4. OK - Todos os serviços estão ativos

---

## 📝 PRÓXIMOS PASSOS

1. Revisar este relatório
2. Corrigir problemas identificados
3. Executar script novamente para verificar correções
4. Validar que todas as verificações passam

---

**Relatório gerado em:** 2025-11-14 09:58:43  
**Script:** 	estar_consistencia_producao.ps1

