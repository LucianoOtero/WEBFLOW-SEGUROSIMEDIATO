# 📋 ESTRATÉGIA DE MIGRAÇÃO: DESENVOLVIMENTO PARA PRODUÇÃO

**Data:** 14/11/2025  
**Status:** 📝 **ESTRATÉGIA DEFINIDA**  
**Objetivo:** Migrar todos os arquivos de DEV para PROD e configurar variáveis de ambiente corretas

---

## 🎯 OBJETIVO

Preparar o ambiente de produção copiando todos os arquivos do diretório de desenvolvimento e configurando corretamente as variáveis de ambiente específicas de produção.

---

## 📁 DIRETÓRIOS IDENTIFICADOS

### **Windows (Máquina Local)**

#### **Diretório de Desenvolvimento:**
```
WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/
```

**Arquivos principais identificados:**
- `FooterCodeSiteDefinitivoCompleto.js`
- `MODAL_WHATSAPP_DEFINITIVO.js`
- `webflow_injection_limpo.js`
- `add_flyingdonkeys.php`
- `add_webflow_octa.php`
- `config.php`
- `config_env.js.php`
- `class.php`
- `ProfessionalLogger.php`
- `log_endpoint.php`
- `send_email_notification_endpoint.php`
- `send_admin_notification_ses.php`
- `cpf-validate.php`
- `placa-validate.php`
- `email_template_loader.php`
- `aws_ses_config.php`
- `email_templates/template_modal.php`
- `email_templates/template_primeiro_contato.php`
- `email_templates/template_logging.php`

#### **Diretório de Produção (Windows):**
```
WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/
```

**Arquivos atuais em PROD (Windows):**
- `add_flyingdonkeys_prod.php`
- `add_webflow_octa_prod.php`
- `aws_ses_config_prod.php`
- `config.php`
- `config.js`
- `FooterCodeSiteDefinitivoCompleto_prod.js`
- `MODAL_WHATSAPP_DEFINITIVO_prod.js`
- `send_admin_notification_ses_prod.php`
- `send_email_notification_endpoint_prod.php`

### **Servidores (Linux)**

#### **Servidor DEV:**
- **IP:** `65.108.156.14`
- **Diretório:** `/var/www/html/dev/root/`
- **URL:** `https://dev.bssegurosimediato.com.br`

#### **Servidor PROD:**
- **IP:** `157.180.36.223`
- **Diretório:** `/var/www/html/prod/root/`
- **URL:** `https://prod.bssegurosimediato.com.br`

---

## 📋 FASE 1: COMPARAÇÃO DE ARQUIVOS (WINDOWS)

### **Objetivo**
Comparar os arquivos entre os diretórios de desenvolvimento e produção no Windows para identificar diferenças.

### **Arquivos em DEV (02-DEVELOPMENT/) que devem estar em PROD:**

#### **JavaScript (.js):**
1. `FooterCodeSiteDefinitivoCompleto.js` → Copiar para PROD
2. `MODAL_WHATSAPP_DEFINITIVO.js` → Copiar para PROD
3. `webflow_injection_limpo.js` → Copiar para PROD

#### **PHP (.php):**
1. `add_flyingdonkeys.php` → Copiar para PROD
2. `add_webflow_octa.php` → Copiar para PROD
3. `config.php` → Copiar para PROD (já existe, verificar se é idêntico)
4. `config_env.js.php` → Copiar para PROD
5. `class.php` → Copiar para PROD
6. `ProfessionalLogger.php` → Copiar para PROD
7. `log_endpoint.php` → Copiar para PROD
8. `send_email_notification_endpoint.php` → Copiar para PROD
9. `send_admin_notification_ses.php` → Copiar para PROD
10. `cpf-validate.php` → Copiar para PROD
11. `placa-validate.php` → Copiar para PROD
12. `email_template_loader.php` → Copiar para PROD
13. `aws_ses_config.php` → Copiar para PROD (já existe como `aws_ses_config_prod.php`, verificar)

#### **Templates de Email:**
1. `email_templates/template_modal.php` → Copiar para PROD
2. `email_templates/template_primeiro_contato.php` → Copiar para PROD
3. `email_templates/template_logging.php` → Copiar para PROD

---

## 📋 FASE 2: CÓPIA DE ARQUIVOS DEV → PROD (WINDOWS)

### **Objetivo**
Copiar todos os arquivos do diretório de desenvolvimento para o diretório de produção no Windows, criando a primeira versão de produção.

### **Processo**

1. **Criar backup do diretório PROD atual (se necessário)**
   ```powershell
   # Criar backup com timestamp
   $backupDir = "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
   Copy-Item -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION" -Destination $backupDir -Recurse
   ```

2. **Copiar arquivos JavaScript**
   ```powershell
   Copy-Item -Path "02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js" -Destination "03-PRODUCTION\FooterCodeSiteDefinitivoCompleto.js" -Force
   Copy-Item -Path "02-DEVELOPMENT\MODAL_WHATSAPP_DEFINITIVO.js" -Destination "03-PRODUCTION\MODAL_WHATSAPP_DEFINITIVO.js" -Force
   Copy-Item -Path "02-DEVELOPMENT\webflow_injection_limpo.js" -Destination "03-PRODUCTION\webflow_injection_limpo.js" -Force
   ```

3. **Copiar arquivos PHP**
   ```powershell
   Copy-Item -Path "02-DEVELOPMENT\add_flyingdonkeys.php" -Destination "03-PRODUCTION\add_flyingdonkeys.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\add_webflow_octa.php" -Destination "03-PRODUCTION\add_webflow_octa.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\config.php" -Destination "03-PRODUCTION\config.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\config_env.js.php" -Destination "03-PRODUCTION\config_env.js.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\class.php" -Destination "03-PRODUCTION\class.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\ProfessionalLogger.php" -Destination "03-PRODUCTION\ProfessionalLogger.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\log_endpoint.php" -Destination "03-PRODUCTION\log_endpoint.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\send_email_notification_endpoint.php" -Destination "03-PRODUCTION\send_email_notification_endpoint.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\send_admin_notification_ses.php" -Destination "03-PRODUCTION\send_admin_notification_ses.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\cpf-validate.php" -Destination "03-PRODUCTION\cpf-validate.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\placa-validate.php" -Destination "03-PRODUCTION\placa-validate.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\email_template_loader.php" -Destination "03-PRODUCTION\email_template_loader.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\aws_ses_config.php" -Destination "03-PRODUCTION\aws_ses_config.php" -Force
   ```

4. **Copiar templates de email**
   ```powershell
   # Criar diretório se não existir
   New-Item -ItemType Directory -Path "03-PRODUCTION\email_templates" -Force
   
   Copy-Item -Path "02-DEVELOPMENT\email_templates\template_modal.php" -Destination "03-PRODUCTION\email_templates\template_modal.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\email_templates\template_primeiro_contato.php" -Destination "03-PRODUCTION\email_templates\template_primeiro_contato.php" -Force
   Copy-Item -Path "02-DEVELOPMENT\email_templates\template_logging.php" -Destination "03-PRODUCTION\email_templates\template_logging.php" -Force
   ```

5. **Copiar composer.json (se necessário)**
   ```powershell
   Copy-Item -Path "02-DEVELOPMENT\composer.json" -Destination "03-PRODUCTION\composer.json" -Force
   ```

### **Resultado Esperado**
Após esta fase, o diretório `03-PRODUCTION/` no Windows terá todos os arquivos do diretório `02-DEVELOPMENT/`, criando a primeira versão de produção.

---

## 📋 FASE 3: CÓPIA DE ARQUIVOS PARA SERVIDOR PROD

### **Objetivo**
Copiar todos os arquivos do diretório de produção no Windows para o servidor de produção.

### **Processo**

1. **Criar backup no servidor PROD (obrigatório)**
   ```bash
   ssh root@157.180.36.223 "mkdir -p /var/www/html/prod/root_backup_$(date +%Y%m%d_%H%M%S) && cp -r /var/www/html/prod/root/* /var/www/html/prod/root_backup_$(date +%Y%m%d_%H%M%S)/"
   ```

2. **Copiar arquivos JavaScript**
   ```powershell
   $workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
   $prodServer = "root@157.180.36.223"
   $prodDir = "/var/www/html/prod/root"
   
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\FooterCodeSiteDefinitivoCompleto.js" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\MODAL_WHATSAPP_DEFINITIVO.js" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\webflow_injection_limpo.js" "${prodServer}:${prodDir}/"
   ```

3. **Copiar arquivos PHP**
   ```powershell
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\add_flyingdonkeys.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\add_webflow_octa.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\config.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\config_env.js.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\class.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\log_endpoint.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\send_email_notification_endpoint.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\send_admin_notification_ses.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\cpf-validate.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\placa-validate.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\email_template_loader.php" "${prodServer}:${prodDir}/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\aws_ses_config.php" "${prodServer}:${prodDir}/"
   ```

4. **Copiar templates de email**
   ```powershell
   # Criar diretório no servidor se não existir
   ssh $prodServer "mkdir -p ${prodDir}/email_templates"
   
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\email_templates\template_modal.php" "${prodServer}:${prodDir}/email_templates/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\email_templates\template_primeiro_contato.php" "${prodServer}:${prodDir}/email_templates/"
   scp "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\email_templates\template_logging.php" "${prodServer}:${prodDir}/email_templates/"
   ```

5. **Ajustar permissões no servidor**
   ```bash
   ssh root@157.180.36.223 "chown -R www-data:www-data /var/www/html/prod/root && chmod -R 755 /var/www/html/prod/root"
   ```

6. **Verificar integridade dos arquivos (hash SHA256)**
   ```powershell
   # Para cada arquivo copiado, verificar hash
   # Exemplo:
   $localHash = (Get-FileHash -Path "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\config.php" -Algorithm SHA256).Hash.ToUpper()
   $remoteHash = (ssh $prodServer "sha256sum ${prodDir}/config.php | cut -d' ' -f1").ToUpper()
   
   if ($localHash -eq $remoteHash) {
       Write-Host "✅ Hash coincide - arquivo copiado corretamente"
   } else {
       Write-Host "❌ Hash não coincide - tentar copiar novamente"
   }
   ```

### **Resultado Esperado**
Após esta fase, todos os arquivos estarão no servidor de produção `/var/www/html/prod/root/`.

---

## 📋 FASE 4: CONFIGURAÇÃO DE VARIÁVEIS DE AMBIENTE PROD

### **Objetivo**
Criar documento definindo corretamente as variáveis de ambiente específicas de produção que precisam ser ajustadas no PHP-FPM.

### **Variáveis que Precisam ser Ajustadas em PROD**

Com base no relatório de comparação, as seguintes variáveis estão incorretas em PROD:

#### **1. APP_CORS_ORIGINS**
- **Status Atual:** PROD está usando origens de DEV
- **Valor Atual (PROD):** `https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br`
- **Valor Correto (PROD):** `https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br`
- **Ação:** Atualizar em `/etc/php/8.3/fpm/pool.d/www.conf`

#### **2. ESPOCRM_URL**
- **Status Atual:** PROD está usando URL de DEV
- **Valor Atual (PROD):** `https://dev.flyingdonkeys.com.br`
- **Valor Correto (PROD):** `https://flyingdonkeys.com.br`
- **Ação:** Atualizar em `/etc/php/8.3/fpm/pool.d/www.conf`

#### **3. LOG_DB_NAME**
- **Status Atual:** PROD está usando banco de DEV
- **Valor Atual (PROD):** `rpa_logs_dev`
- **Valor Correto (PROD):** `rpa_logs_prod`
- **Ação:** Atualizar em `/etc/php/8.3/fpm/pool.d/www.conf`

#### **4. LOG_DB_USER**
- **Status Atual:** PROD está usando usuário de DEV
- **Valor Atual (PROD):** `rpa_logger_dev`
- **Valor Correto (PROD):** `rpa_logger_prod`
- **Ação:** Atualizar em `/etc/php/8.3/fpm/pool.d/www.conf`

#### **5. LOG_DIR**
- **Status Atual:** Faltando em PROD
- **Valor Correto (PROD):** `/var/log/webflow-segurosimediato`
- **Ação:** Adicionar em `/etc/php/8.3/fpm/pool.d/www.conf`

### **Documento de Configuração**

Criar arquivo: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/VARIAVEIS_AMBIENTE_PROD.md`

---

## 📋 FASE 5: APLICAÇÃO DAS VARIÁVEIS DE AMBIENTE NO SERVIDOR

### **Objetivo**
Aplicar as variáveis de ambiente corretas no servidor de produção.

### **Processo**

1. **Criar backup do arquivo PHP-FPM**
   ```bash
   ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_ANTES_MIGRACAO_$(date +%Y%m%d_%H%M%S)"
   ```

2. **Atualizar variáveis no servidor**
   - Editar `/etc/php/8.3/fpm/pool.d/www.conf` no servidor
   - Aplicar as correções definidas no documento `VARIAVEIS_AMBIENTE_PROD.md`

3. **Reiniciar PHP-FPM**
   ```bash
   ssh root@157.180.36.223 "systemctl restart php8.3-fpm"
   ```

4. **Verificar variáveis aplicadas**
   ```bash
   ssh root@157.180.36.223 "php -r \"echo getenv('APP_CORS_ORIGINS');\""
   ```

---

## 📋 CHECKLIST DE MIGRAÇÃO

### **Fase 1: Comparação**
- [ ] Comparar arquivos entre `02-DEVELOPMENT/` e `03-PRODUCTION/` no Windows
- [ ] Identificar arquivos faltando em PROD
- [ ] Identificar arquivos diferentes

### **Fase 2: Cópia DEV → PROD (Windows)**
- [ ] Criar backup do diretório PROD atual
- [ ] Copiar arquivos JavaScript
- [ ] Copiar arquivos PHP
- [ ] Copiar templates de email
- [ ] Verificar integridade dos arquivos copiados

### **Fase 3: Cópia para Servidor PROD**
- [ ] Criar backup no servidor PROD
- [ ] Copiar arquivos JavaScript para servidor
- [ ] Copiar arquivos PHP para servidor
- [ ] Copiar templates de email para servidor
- [ ] Ajustar permissões no servidor
- [ ] Verificar integridade (hash SHA256) de todos os arquivos

### **Fase 4: Configuração de Variáveis**
- [ ] Criar documento `VARIAVEIS_AMBIENTE_PROD.md`
- [ ] Documentar todas as variáveis que precisam ser ajustadas
- [ ] Definir valores corretos para PROD

### **Fase 5: Aplicação no Servidor**
- [ ] Criar backup do arquivo PHP-FPM
- [ ] Atualizar variáveis no servidor
- [ ] Reiniciar PHP-FPM
- [ ] Verificar variáveis aplicadas

### **Fase 6: Testes**
- [ ] Testar acesso HTTPS em PROD
- [ ] Testar endpoints PHP
- [ ] Testar carregamento de arquivos JavaScript
- [ ] Verificar logs
- [ ] Testar webhooks

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Backups Obrigatórios:**
   - Sempre criar backup antes de qualquer modificação
   - Backup local (Windows) e remoto (servidor)

2. **Verificação de Integridade:**
   - Sempre verificar hash SHA256 após cópia
   - Comparar hashes case-insensitive

3. **Permissões:**
   - Proprietário: `www-data:www-data`
   - Permissões: `755` (diretórios) / `644` (arquivos)

4. **Variáveis de Ambiente:**
   - Nunca commitar secret keys no Git
   - Sempre usar variáveis de ambiente do PHP-FPM
   - Verificar valores antes de aplicar

5. **Testes:**
   - Sempre testar após cada fase
   - Verificar logs em caso de erro

---

## 📝 PRÓXIMOS PASSOS

1. ✅ Estratégia definida
2. ⏳ Executar Fase 1: Comparação de arquivos
3. ⏳ Executar Fase 2: Cópia DEV → PROD (Windows)
4. ⏳ Executar Fase 3: Cópia para servidor PROD
5. ⏳ Executar Fase 4: Criar documento de variáveis
6. ⏳ Executar Fase 5: Aplicar variáveis no servidor
7. ⏳ Executar Fase 6: Testes finais

---

**Data de Criação:** 14/11/2025  
**Status:** 📝 **ESTRATÉGIA DEFINIDA - AGUARDANDO EXECUÇÃO**

