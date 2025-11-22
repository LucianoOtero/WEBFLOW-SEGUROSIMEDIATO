# 🚀 PLANO DE DEPLOY: Refatoração Arquivos JavaScript (.js) - Servidor DEV

**Data:** 18/11/2025  
**Versão:** 1.0.0  
**Projeto:** Refatorar Arquivos JavaScript (.js) - Versão 1.6.0  
**Ambiente:** DESENVOLVIMENTO (DEV)  
**Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)  
**Caminho no Servidor:** `/var/www/html/dev/root/`

---

## 🎯 OBJETIVO DO DEPLOY

Fazer deploy dos arquivos refatorados para o servidor DEV, garantindo:
- ✅ Integridade dos arquivos (verificação SHA256)
- ✅ Funcionalidade preservada
- ✅ Logs sendo inseridos no banco de dados
- ✅ Sistema de logging funcionando corretamente

---

## ⚠️ PRÉ-REQUISITOS

### **Antes de Iniciar:**

1. ✅ **Backups locais criados:** ✅ CONCLUÍDO
   - `backups/REFATORACAO_JS_20251118/FooterCodeSiteDefinitivoCompleto.js.backup_20251118_092325.js`
   - `backups/REFATORACAO_JS_20251118/webflow_injection_limpo.js.backup_20251118_092748.js`
   - `backups/REFATORACAO_JS_20251118/MODAL_WHATSAPP_DEFINITIVO.js.backup_20251118_092748.js`
   - `backups/CENTRALIZAR_EMAIL_20251118/ProfessionalLogger.php.backup_20251118_092748.php`

2. ✅ **Auditoria realizada:** ✅ CONCLUÍDA
   - Documento: `AUDITORIA_PROJETO_REFATORAR_ARQUIVOS_JS_20251118.md`
   - Status: APROVADO COM RESSALVAS MENORES (92/100)

3. ✅ **Hash SHA256 dos arquivos locais documentados:**
   - `FooterCodeSiteDefinitivoCompleto.js`: `F07EE33EBF80194B5DA99F2EE9E0AE97773A174C5A62D72DADD78426BCECA05F`
   - `webflow_injection_limpo.js`: `B594126A50DDBD97532A45B028A1B249A72477D73CE3ED1C3CA0447F547873E7`
   - `MODAL_WHATSAPP_DEFINITIVO.js`: `F3202B2585A80B476F436D1D3B1BB9A5CFEEF8925B4D6BB728B6689DCEF6C760`
   - `ProfessionalLogger.php`: `9FE1B54D6AD3DAA0C408FACA92386CF9072203D78D182DF80F508FF06778DD58`

4. ✅ **Acesso SSH ao servidor:** Verificar acesso antes de iniciar
5. ✅ **Variáveis de ambiente:** Verificar se estão configuradas corretamente no servidor

---

## 📋 FASES DO DEPLOY

### **FASE 1: Preparação e Verificação de Acesso**

**Objetivo:** Verificar acesso ao servidor e preparar ambiente.

**Tarefas:**

1. ✅ **Verificar acesso SSH ao servidor DEV:**
   ```powershell
   ssh root@65.108.156.14 "echo 'Acesso SSH OK'"
   ```

2. ✅ **Verificar diretório de destino existe:**
   ```powershell
   ssh root@65.108.156.14 "test -d /var/www/html/dev/root && echo 'Diretório existe' || echo 'ERRO: Diretório não existe'"
   ```

3. ✅ **Verificar permissões do diretório:**
   ```powershell
   ssh root@65.108.156.14 "ls -ld /var/www/html/dev/root"
   ```

**Entregáveis:**
- Confirmação de acesso SSH
- Confirmação de diretório existente
- Confirmação de permissões adequadas

**Tempo Estimado:** ~5min

---

### **FASE 2: Criação de Backups no Servidor**

**Objetivo:** Criar backups dos arquivos originais no servidor antes de substituí-los.

**Tarefas:**

1. ✅ **Criar backup de `FooterCodeSiteDefinitivoCompleto.js`:**
   ```powershell
   ssh root@65.108.156.14 "cp /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js.backup_$(date +%Y%m%d_%H%M%S).js && echo 'Backup criado'"
   ```

2. ✅ **Criar backup de `webflow_injection_limpo.js`:**
   ```powershell
   ssh root@65.108.156.14 "cp /var/www/html/dev/root/webflow_injection_limpo.js /var/www/html/dev/root/webflow_injection_limpo.js.backup_$(date +%Y%m%d_%H%M%S).js && echo 'Backup criado'"
   ```

3. ✅ **Criar backup de `MODAL_WHATSAPP_DEFINITIVO.js`:**
   ```powershell
   ssh root@65.108.156.14 "cp /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js.backup_$(date +%Y%m%d_%H%M%S).js && echo 'Backup criado'"
   ```

4. ✅ **Criar backup de `ProfessionalLogger.php`:**
   ```powershell
   ssh root@65.108.156.14 "cp /var/www/html/dev/root/ProfessionalLogger.php /var/www/html/dev/root/ProfessionalLogger.php.backup_$(date +%Y%m%d_%H%M%S).php && echo 'Backup criado'"
   ```

5. ✅ **Verificar backups criados:**
   ```powershell
   ssh root@65.108.156.14 "ls -lh /var/www/html/dev/root/*.backup_*"
   ```

**Entregáveis:**
- 4 backups criados no servidor
- Lista de backups confirmada

**Tempo Estimado:** ~5min

---

### **FASE 3: Cópia dos Arquivos para o Servidor**

**Objetivo:** Copiar arquivos modificados do ambiente local para o servidor DEV.

**⚠️ IMPORTANTE:** Usar caminho completo do workspace ao copiar arquivos.

**Tarefas:**

1. ✅ **Copiar `FooterCodeSiteDefinitivoCompleto.js`:**
   ```powershell
   $workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
   cd $workspacePath
   scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js" root@65.108.156.14:/var/www/html/dev/root/
   ```

2. ✅ **Copiar `webflow_injection_limpo.js`:**
   ```powershell
   scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\webflow_injection_limpo.js" root@65.108.156.14:/var/www/html/dev/root/
   ```

3. ✅ **Copiar `MODAL_WHATSAPP_DEFINITIVO.js`:**
   ```powershell
   scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\MODAL_WHATSAPP_DEFINITIVO.js" root@65.108.156.14:/var/www/html/dev/root/
   ```

4. ✅ **Copiar `ProfessionalLogger.php`:**
   ```powershell
   scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" root@65.108.156.14:/var/www/html/dev/root/
   ```

**Entregáveis:**
- 4 arquivos copiados para o servidor
- Confirmação de cópia bem-sucedida

**Tempo Estimado:** ~5min

---

### **FASE 4: Verificação de Integridade (Hash SHA256)**

**Objetivo:** Verificar que os arquivos foram copiados corretamente comparando hash SHA256.

**⚠️ IMPORTANTE:** Comparar hashes ignorando diferenças de maiúsculas/minúsculas (case-insensitive).

**Tarefas:**

1. ✅ **Verificar hash de `FooterCodeSiteDefinitivoCompleto.js`:**
   ```powershell
   $hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js" -Algorithm SHA256).Hash.ToUpper()
   $hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js | cut -d' ' -f1").ToUpper()
   
   if ($hashLocal -eq $hashServidor) {
       Write-Host "✅ Hash coincide - arquivo copiado corretamente" -ForegroundColor Green
   } else {
       Write-Host "❌ Hash não coincide - tentar copiar novamente" -ForegroundColor Red
       Write-Host "Local:    $hashLocal" -ForegroundColor Yellow
       Write-Host "Servidor: $hashServidor" -ForegroundColor Yellow
   }
   ```

2. ✅ **Verificar hash de `webflow_injection_limpo.js`:**
   ```powershell
   $hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\webflow_injection_limpo.js" -Algorithm SHA256).Hash.ToUpper()
   $hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/webflow_injection_limpo.js | cut -d' ' -f1").ToUpper()
   
   if ($hashLocal -eq $hashServidor) {
       Write-Host "✅ Hash coincide - arquivo copiado corretamente" -ForegroundColor Green
   } else {
       Write-Host "❌ Hash não coincide - tentar copiar novamente" -ForegroundColor Red
   }
   ```

3. ✅ **Verificar hash de `MODAL_WHATSAPP_DEFINITIVO.js`:**
   ```powershell
   $hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\MODAL_WHATSAPP_DEFINITIVO.js" -Algorithm SHA256).Hash.ToUpper()
   $hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js | cut -d' ' -f1").ToUpper()
   
   if ($hashLocal -eq $hashServidor) {
       Write-Host "✅ Hash coincide - arquivo copiado corretamente" -ForegroundColor Green
   } else {
       Write-Host "❌ Hash não coincide - tentar copiar novamente" -ForegroundColor Red
   }
   ```

4. ✅ **Verificar hash de `ProfessionalLogger.php`:**
   ```powershell
   $hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
   $hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/ProfessionalLogger.php | cut -d' ' -f1").ToUpper()
   
   if ($hashLocal -eq $hashServidor) {
       Write-Host "✅ Hash coincide - arquivo copiado corretamente" -ForegroundColor Green
   } else {
       Write-Host "❌ Hash não coincide - tentar copiar novamente" -ForegroundColor Red
   }
   ```

**Entregáveis:**
- Confirmação de hash SHA256 para todos os 4 arquivos
- Documentação de hashes verificados

**Tempo Estimado:** ~5min

---

### **FASE 5: Verificação de Variáveis de Ambiente**

**Objetivo:** Verificar se as variáveis de ambiente necessárias estão configuradas no servidor.

**Tarefas:**

1. ✅ **Verificar variáveis de ambiente do PHP-FPM:**
   ```powershell
   ssh root@65.108.156.14 "php -r 'echo \"LOG_ENABLED: \" . (getenv(\"LOG_ENABLED\") ?: \"NÃO DEFINIDO\") . \"\\n\";'"
   ssh root@65.108.156.14 "php -r 'echo \"LOG_DATABASE_ENABLED: \" . (getenv(\"LOG_DATABASE_ENABLED\") ?: \"NÃO DEFINIDO\") . \"\\n\";'"
   ssh root@65.108.156.14 "php -r 'echo \"LOG_DATABASE_MIN_LEVEL: \" . (getenv(\"LOG_DATABASE_MIN_LEVEL\") ?: \"NÃO DEFINIDO\") . \"\\n\";'"
   ssh root@65.108.156.14 "php -r 'echo \"APP_BASE_URL: \" . (getenv(\"APP_BASE_URL\") ?: \"NÃO DEFINIDO\") . \"\\n\";'"
   ```

2. ✅ **Verificar configuração recomendada:**
   - `LOG_ENABLED=true`
   - `LOG_DATABASE_ENABLED=true`
   - `LOG_DATABASE_MIN_LEVEL=all` (para inserir todos os logs no banco)
   - `APP_BASE_URL=https://dev.bssegurosimediato.com.br`

**Entregáveis:**
- Lista de variáveis de ambiente verificadas
- Confirmação de configuração adequada

**Tempo Estimado:** ~5min

---

### **FASE 6: Teste de Conexão com Banco de Dados**

**Objetivo:** Verificar se a conexão com o banco de dados está funcionando.

**Tarefas:**

1. ✅ **Testar conexão com banco de dados via PHP:**
   ```powershell
   ssh root@65.108.156.14 "php -r 'try { \$pdo = new PDO(\"mysql:host=\" . getenv(\"LOG_DB_HOST\") . \";port=\" . (getenv(\"LOG_DB_PORT\") ?: 3306) . \";dbname=\" . getenv(\"LOG_DB_NAME\") . \";charset=utf8mb4\", getenv(\"LOG_DB_USER\"), getenv(\"LOG_DB_PASS\")); echo \"✅ Conexão com banco OK\\n\"; } catch (Exception \$e) { echo \"❌ Erro na conexão: \" . \$e->getMessage() . \"\\n\"; }'"
   ```

2. ✅ **Verificar se tabela `application_logs` existe:**
   ```powershell
   ssh root@65.108.156.14 "php -r 'try { \$pdo = new PDO(\"mysql:host=\" . getenv(\"LOG_DB_HOST\") . \";port=\" . (getenv(\"LOG_DB_PORT\") ?: 3306) . \";dbname=\" . getenv(\"LOG_DB_NAME\") . \";charset=utf8mb4\", getenv(\"LOG_DB_USER\"), getenv(\"LOG_DB_PASS\")); \$stmt = \$pdo->query(\"SHOW TABLES LIKE \\\"application_logs\\\"\"); if (\$stmt->rowCount() > 0) { echo \"✅ Tabela application_logs existe\\n\"; } else { echo \"❌ Tabela application_logs não existe\\n\"; } } catch (Exception \$e) { echo \"❌ Erro: \" . \$e->getMessage() . \"\\n\"; }'"
   ```

**Entregáveis:**
- Confirmação de conexão com banco de dados
- Confirmação de existência da tabela `application_logs`

**Tempo Estimado:** ~5min

---

### **FASE 7: Teste de Endpoint PHP de Log**

**Objetivo:** Verificar se o endpoint `log_endpoint.php` está funcionando corretamente.

**Tarefas:**

1. ✅ **Testar endpoint `log_endpoint.php` via HTTP:**
   ```powershell
   $testPayload = @{
       level = "INFO"
       category = "TEST"
       message = "Teste de deploy - Refatoração JS"
       data = @{
           deploy_date = "2025-11-18"
           deploy_version = "1.6.0"
       }
   } | ConvertTo-Json -Compress
   
   $response = Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/log_endpoint.php" -Method POST -Body $testPayload -ContentType "application/json" -UseBasicParsing
   
   Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
   Write-Host "Response: $($response.Content)" -ForegroundColor Gray
   ```

2. ✅ **Verificar resposta do endpoint:**
   - Status Code deve ser `200`
   - Resposta deve conter `"success": true`
   - Resposta deve conter `log_id`

**Entregáveis:**
- Confirmação de endpoint funcionando
- `log_id` do teste documentado

**Tempo Estimado:** ~5min

---

### **FASE 8: Verificação de Sensibilização do Banco de Dados**

**Objetivo:** Verificar se os logs estão sendo inseridos no banco de dados (sensibilização).

**Tarefas:**

1. ✅ **Contar logs inseridos antes do teste:**
   ```powershell
   ssh root@65.108.156.14 "php -r 'try { \$pdo = new PDO(\"mysql:host=\" . getenv(\"LOG_DB_HOST\") . \";port=\" . (getenv(\"LOG_DB_PORT\") ?: 3306) . \";dbname=\" . getenv(\"LOG_DB_NAME\") . \";charset=utf8mb4\", getenv(\"LOG_DB_USER\"), getenv(\"LOG_DB_PASS\")); \$countBefore = \$pdo->query(\"SELECT COUNT(*) as total FROM application_logs\")->fetch()[\"total\"]; echo \"Logs antes do teste: \$countBefore\\n\"; } catch (Exception \$e) { echo \"❌ Erro: \" . \$e->getMessage() . \"\\n\"; }'"
   ```

2. ✅ **Enviar alguns logs de teste via endpoint:**
   ```powershell
   # Teste 1: Log INFO
   $test1 = @{
       level = "INFO"
       category = "DEPLOY_TEST"
       message = "Teste de deploy - Log INFO"
   } | ConvertTo-Json -Compress
   Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/log_endpoint.php" -Method POST -Body $test1 -ContentType "application/json" -UseBasicParsing | Out-Null
   
   # Teste 2: Log DEBUG
   $test2 = @{
       level = "DEBUG"
       category = "DEPLOY_TEST"
       message = "Teste de deploy - Log DEBUG"
   } | ConvertTo-Json -Compress
   Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/log_endpoint.php" -Method POST -Body $test2 -ContentType "application/json" -UseBasicParsing | Out-Null
   
   # Teste 3: Log WARN
   $test3 = @{
       level = "WARN"
       category = "DEPLOY_TEST"
       message = "Teste de deploy - Log WARN"
   } | ConvertTo-Json -Compress
   Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/log_endpoint.php" -Method POST -Body $test3 -ContentType "application/json" -UseBasicParsing | Out-Null
   
   Start-Sleep -Seconds 2
   ```

3. ✅ **Contar logs inseridos após o teste:**
   ```powershell
   ssh root@65.108.156.14 "php -r 'try { \$pdo = new PDO(\"mysql:host=\" . getenv(\"LOG_DB_HOST\") . \";port=\" . (getenv(\"LOG_DB_PORT\") ?: 3306) . \";dbname=\" . getenv(\"LOG_DB_NAME\") . \";charset=utf8mb4\", getenv(\"LOG_DB_USER\"), getenv(\"LOG_DB_PASS\")); \$countAfter = \$pdo->query(\"SELECT COUNT(*) as total FROM application_logs\")->fetch()[\"total\"]; echo \"Logs após o teste: \$countAfter\\n\"; \$diff = \$countAfter - \$countBefore; echo \"Novos logs inseridos: \$diff\\n\"; if (\$diff >= 3) { echo \"✅ Banco de dados sensibilizado - logs sendo inseridos\\n\"; } else { echo \"⚠️ Atenção: Poucos logs inseridos. Verificar parametrização.\\n\"; } } catch (Exception \$e) { echo \"❌ Erro: \" . \$e->getMessage() . \"\\n\"; }'"
   ```

4. ✅ **Verificar logs de teste inseridos:**
   ```powershell
   ssh root@65.108.156.14 "php -r 'try { \$pdo = new PDO(\"mysql:host=\" . getenv(\"LOG_DB_HOST\") . \";port=\" . (getenv(\"LOG_DB_PORT\") ?: 3306) . \";dbname=\" . getenv(\"LOG_DB_NAME\") . \";charset=utf8mb4\", getenv(\"LOG_DB_USER\"), getenv(\"LOG_DB_PASS\")); \$logs = \$pdo->query(\"SELECT level, category, message FROM application_logs WHERE category = \\\"DEPLOY_TEST\\\" ORDER BY timestamp DESC LIMIT 5\")->fetchAll(PDO::FETCH_ASSOC); foreach (\$logs as \$log) { echo \"[\" . \$log[\"level\"] . \"] [\" . \$log[\"category\"] . \"] \" . \$log[\"message\"] . \"\\n\"; } } catch (Exception \$e) { echo \"❌ Erro: \" . \$e->getMessage() . \"\\n\"; }'"
   ```

**Entregáveis:**
- Confirmação de que logs estão sendo inseridos no banco
- Contagem de logs antes e depois do teste
- Lista de logs de teste inseridos

**Tempo Estimado:** ~10min

---

### **FASE 9: Teste de Funcionalidade no Browser**

**Objetivo:** Verificar se o sistema de logging está funcionando no browser.

**Tarefas:**

1. ✅ **Abrir site no browser:** `https://dev.bssegurosimediato.com.br`
2. ✅ **Abrir console do browser (F12)**
3. ✅ **Verificar que `window.novo_log` está disponível:**
   ```javascript
   typeof window.novo_log === 'function'  // Deve retornar true
   ```
4. ✅ **Testar chamada de `novo_log()`:**
   ```javascript
   window.novo_log('INFO', 'TEST', 'Teste manual de novo_log()', { teste: true });
   ```
5. ✅ **Verificar que log aparece no console**
6. ✅ **Verificar que log é enviado para banco** (verificar no banco após alguns segundos)

**Entregáveis:**
- Confirmação de `window.novo_log` disponível
- Confirmação de log aparecendo no console
- Confirmação de log sendo inserido no banco

**Tempo Estimado:** ~10min

---

### **FASE 10: Verificação de Email para Administradores**

**Objetivo:** Verificar se emails são enviados para administradores quando logs ERROR/FATAL são registrados.

**Tarefas:**

1. ✅ **Enviar log ERROR via endpoint:**
   ```powershell
   $errorLog = @{
       level = "ERROR"
       category = "DEPLOY_TEST"
       message = "Teste de envio de email - Log ERROR"
       data = @{
           test = true
       }
   } | ConvertTo-Json -Compress
   
   $response = Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/log_endpoint.php" -Method POST -Body $errorLog -ContentType "application/json" -UseBasicParsing
   Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
   Write-Host "Response: $($response.Content)" -ForegroundColor Gray
   ```

2. ✅ **Verificar logs do servidor para confirmação de envio de email:**
   ```powershell
   ssh root@65.108.156.14 "tail -n 20 /var/log/php/error.log | grep -i 'email\|ProfessionalLogger'"
   ```

3. ✅ **Verificar se email foi enviado** (verificar caixa de entrada dos administradores)

**Entregáveis:**
- Confirmação de log ERROR inserido
- Confirmação de tentativa de envio de email
- Verificação manual de recebimento de email (se possível)

**Tempo Estimado:** ~10min

---

## 📊 RESUMO DAS FASES

| Fase | Descrição | Tempo Estimado |
|------|-----------|----------------|
| **FASE 1** | Preparação e Verificação de Acesso | ~5min |
| **FASE 2** | Criação de Backups no Servidor | ~5min |
| **FASE 3** | Cópia dos Arquivos para o Servidor | ~5min |
| **FASE 4** | Verificação de Integridade (Hash SHA256) | ~5min |
| **FASE 5** | Verificação de Variáveis de Ambiente | ~5min |
| **FASE 6** | Teste de Conexão com Banco de Dados | ~5min |
| **FASE 7** | Teste de Endpoint PHP de Log | ~5min |
| **FASE 8** | Verificação de Sensibilização do Banco de Dados | ~10min |
| **FASE 9** | Teste de Funcionalidade no Browser | ~10min |
| **FASE 10** | Verificação de Email para Administradores | ~10min |
| **TOTAL** | - | **~65min** |

---

## ⚠️ AVISOS IMPORTANTES

### **🚨 CACHE CLOUDFLARE - OBRIGATÓRIO:**

⚠️ **IMPORTANTE:** Após atualizar arquivos no servidor, é necessário limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente. O Cloudflare pode manter versões antigas em cache, causando erros como uso de código desatualizado, funções não encontradas, etc.

**Ação Obrigatória:**
1. Acessar painel do Cloudflare
2. Selecionar domínio `dev.bssegurosimediato.com.br`
3. Ir em "Caching" → "Purge Everything"
4. Confirmar limpeza de cache

### **🚨 VERIFICAÇÃO DE HASH SHA256:**

⚠️ **OBRIGATÓRIO:** Verificar hash SHA256 de TODOS os arquivos após cópia para servidor. Se hash não coincidir, tentar copiar novamente.

### **🚨 ROLLBACK:**

Se houver problemas após o deploy:
1. Restaurar arquivos dos backups criados na FASE 2
2. Verificar hash SHA256 dos arquivos restaurados
3. Limpar cache do Cloudflare novamente

---

## 📋 CHECKLIST DE DEPLOY

### **Antes do Deploy:**
- [ ] Backups locais criados ✅
- [ ] Auditoria realizada ✅
- [ ] Hash SHA256 dos arquivos locais documentados ✅
- [ ] Acesso SSH ao servidor verificado
- [ ] Variáveis de ambiente verificadas

### **Durante o Deploy:**
- [ ] FASE 1: Preparação concluída
- [ ] FASE 2: Backups no servidor criados
- [ ] FASE 3: Arquivos copiados para servidor
- [ ] FASE 4: Hash SHA256 verificado (todos os 4 arquivos)
- [ ] FASE 5: Variáveis de ambiente verificadas
- [ ] FASE 6: Conexão com banco de dados testada
- [ ] FASE 7: Endpoint PHP testado
- [ ] FASE 8: Banco de dados sensibilizado (logs inseridos)
- [ ] FASE 9: Funcionalidade no browser testada
- [ ] FASE 10: Email para administradores verificado

### **Após o Deploy:**
- [ ] Cache do Cloudflare limpo ⚠️ **OBRIGATÓRIO**
- [ ] Funcionalidades testadas manualmente
- [ ] Logs sendo inseridos no banco de dados confirmado
- [ ] Nenhum erro no console do browser
- [ ] Documentação de deploy atualizada

---

## 📄 DOCUMENTAÇÃO DE REFERÊNCIA

- **Projeto:** `PROJETO_REFATORAR_ARQUIVOS_JS_20251117.md` (Versão 1.6.0)
- **Auditoria:** `AUDITORIA_PROJETO_REFATORAR_ARQUIVOS_JS_20251118.md`
- **Diretivas:** `./cursorrules`
- **Framework de Auditoria:** `AUDITORIA_PROJETOS_BOAS_PRATICAS.md`

---

**Documento criado em:** 18/11/2025  
**Versão:** 1.0.0  
**Status:** 📝 **PRONTO PARA EXECUÇÃO**

