# 📋 PROJETO: ATUALIZAÇÃO DO AMBIENTE DE PRODUÇÃO

**Data:** 14/11/2025  
**Status:** 📝 **PROJETO DEFINIDO**  
**Objetivo:** Atualizar o ambiente de produção seguindo a estratégia de migração e o relatório de comparação

---

## 🎯 OBJETIVO

Atualizar o ambiente de produção copiando todos os arquivos do diretório de desenvolvimento para o diretório de produção no Windows, e em seguida copiar para o servidor de produção, configurando corretamente as variáveis de ambiente específicas de produção.

**Fluxo obrigatório:** DEV Windows → PROD Windows → PROD Servidor

---

## 📋 BASES DO PROJETO

### **Documentos de Referência:**
1. **Estratégia de Migração:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/ESTRATEGIA_MIGRACAO_DEV_PARA_PROD.md`
2. **Relatório de Comparação:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/relatorio_comparacao_dev_prod_20251114_090816.md`
3. **Variáveis de Ambiente PROD:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/VARIAVEIS_AMBIENTE_PROD.md`

### **Análise do Relatório de Comparação:**

#### **Arquivos com Diferenças (6 arquivos):**
1. `FooterCodeSiteDefinitivoCompleto.js` - ⚠️ Diferente
2. `webflow_injection_limpo.js` - ⚠️ Diferente
3. `add_flyingdonkeys.php` - ⚠️ Diferente
4. `add_webflow_octa.php` - ⚠️ Diferente
5. `cpf-validate.php` - ⚠️ Diferente
6. `placa-validate.php` - ⚠️ Diferente

#### **Arquivos Idênticos (9 arquivos):**
1. `MODAL_WHATSAPP_DEFINITIVO.js` - ✅ Idêntico
2. `config.php` - ✅ Idêntico
3. `config_env.js.php` - ✅ Idêntico
4. `class.php` - ✅ Idêntico
5. `ProfessionalLogger.php` - ✅ Idêntico
6. `log_endpoint.php` - ✅ Idêntico
7. `send_email_notification_endpoint.php` - ✅ Idêntico
8. `send_admin_notification_ses.php` - ✅ Idêntico
9. `email_template_loader.php` - ✅ Idêntico

#### **Variáveis de Ambiente que Precisam Correção:**
1. ❌ `APP_CORS_ORIGINS` - PROD usando origens de DEV
2. ❌ `ESPOCRM_URL` - PROD usando URL de DEV
3. ❌ `LOG_DB_NAME` - PROD usando banco de DEV
4. ❌ `LOG_DB_USER` - PROD usando usuário de DEV
5. ❌ `LOG_DIR` - Faltando em PROD

#### **Secret Keys:**
- ⚠️ **NOTA:** As secret keys do Webflow serão definidas amanhã
- ⚠️ **AÇÃO:** Não incluir atualização de secret keys neste projeto
- ⚠️ **PENDÊNCIA:** Criar projeto separado para atualizar secret keys após definição

---

## 📁 DIRETÓRIOS E SERVIDORES

### **Windows (Máquina Local):**

#### **Diretório de Desenvolvimento:**
```
C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\
```

#### **Diretório de Produção (Windows):**
```
C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\
```

### **Servidores:**

#### **Servidor DEV:**
- **IP:** `65.108.156.14`
- **Diretório:** `/var/www/html/dev/root/`
- **URL:** `https://dev.bssegurosimediato.com.br`

#### **Servidor PROD:**
- **IP:** `157.180.36.223`
- **Diretório:** `/var/www/html/prod/root/`
- **URL:** `https://prod.bssegurosimediato.com.br`

---

## 📋 FASE 1: BACKUP DO DIRETÓRIO PROD (WINDOWS)

### **Objetivo**
Criar backup completo do diretório de produção atual no Windows antes de qualquer modificação.

### **Processo**

1. **Criar diretório de backup com timestamp**
   ```powershell
   $workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
   $backupDir = "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION_BACKUP_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
   New-Item -ItemType Directory -Path $backupDir -Force
   ```

2. **Copiar todo o conteúdo do diretório PROD para backup**
   ```powershell
   $prodDir = "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"
   Copy-Item -Path "$prodDir\*" -Destination $backupDir -Recurse -Force
   ```

3. **Verificar backup criado**
   ```powershell
   Get-ChildItem -Path $backupDir | Select-Object Name, Length
   ```

### **Resultado Esperado**
- ✅ Backup completo do diretório PROD criado
- ✅ Backup salvo em `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION_BACKUP_YYYYMMDD_HHMMSS/`

---

## 📋 FASE 2: CÓPIA DEV → PROD (WINDOWS)

### **Objetivo**
Copiar todos os arquivos do diretório de desenvolvimento para o diretório de produção no Windows, criando a primeira versão de produção.

### **Arquivos a Copiar**

#### **JavaScript (.js):**
1. `FooterCodeSiteDefinitivoCompleto.js`
2. `MODAL_WHATSAPP_DEFINITIVO.js`
3. `webflow_injection_limpo.js`

#### **PHP (.php):**
1. `add_flyingdonkeys.php`
2. `add_webflow_octa.php`
3. `config.php`
4. `config_env.js.php`
5. `class.php`
6. `ProfessionalLogger.php`
7. `log_endpoint.php`
8. `send_email_notification_endpoint.php`
9. `send_admin_notification_ses.php`
10. `cpf-validate.php`
11. `placa-validate.php`
12. `email_template_loader.php`
13. `aws_ses_config.php`

#### **Templates de Email:**
1. `email_templates/template_modal.php`
2. `email_templates/template_primeiro_contato.php`
3. `email_templates/template_logging.php`

#### **Outros:**
1. `composer.json` (se necessário)

### **Processo**

1. **Definir caminhos completos**
   ```powershell
   $workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
   $devDir = "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"
   $prodDir = "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"
   ```

2. **Copiar arquivos JavaScript**
   ```powershell
   Copy-Item -Path "$devDir\FooterCodeSiteDefinitivoCompleto.js" -Destination "$prodDir\FooterCodeSiteDefinitivoCompleto.js" -Force
   Copy-Item -Path "$devDir\MODAL_WHATSAPP_DEFINITIVO.js" -Destination "$prodDir\MODAL_WHATSAPP_DEFINITIVO.js" -Force
   Copy-Item -Path "$devDir\webflow_injection_limpo.js" -Destination "$prodDir\webflow_injection_limpo.js" -Force
   ```

3. **Copiar arquivos PHP**
   ```powershell
   Copy-Item -Path "$devDir\add_flyingdonkeys.php" -Destination "$prodDir\add_flyingdonkeys.php" -Force
   Copy-Item -Path "$devDir\add_webflow_octa.php" -Destination "$prodDir\add_webflow_octa.php" -Force
   Copy-Item -Path "$devDir\config.php" -Destination "$prodDir\config.php" -Force
   Copy-Item -Path "$devDir\config_env.js.php" -Destination "$prodDir\config_env.js.php" -Force
   Copy-Item -Path "$devDir\class.php" -Destination "$prodDir\class.php" -Force
   Copy-Item -Path "$devDir\ProfessionalLogger.php" -Destination "$prodDir\ProfessionalLogger.php" -Force
   Copy-Item -Path "$devDir\log_endpoint.php" -Destination "$prodDir\log_endpoint.php" -Force
   Copy-Item -Path "$devDir\send_email_notification_endpoint.php" -Destination "$prodDir\send_email_notification_endpoint.php" -Force
   Copy-Item -Path "$devDir\send_admin_notification_ses.php" -Destination "$prodDir\send_admin_notification_ses.php" -Force
   Copy-Item -Path "$devDir\cpf-validate.php" -Destination "$prodDir\cpf-validate.php" -Force
   Copy-Item -Path "$devDir\placa-validate.php" -Destination "$prodDir\placa-validate.php" -Force
   Copy-Item -Path "$devDir\email_template_loader.php" -Destination "$prodDir\email_template_loader.php" -Force
   Copy-Item -Path "$devDir\aws_ses_config.php" -Destination "$prodDir\aws_ses_config.php" -Force
   ```

4. **Criar diretório de templates e copiar**
   ```powershell
   New-Item -ItemType Directory -Path "$prodDir\email_templates" -Force
   Copy-Item -Path "$devDir\email_templates\template_modal.php" -Destination "$prodDir\email_templates\template_modal.php" -Force
   Copy-Item -Path "$devDir\email_templates\template_primeiro_contato.php" -Destination "$prodDir\email_templates\template_primeiro_contato.php" -Force
   Copy-Item -Path "$devDir\email_templates\template_logging.php" -Destination "$prodDir\email_templates\template_logging.php" -Force
   ```

5. **Copiar composer.json (se necessário)**
   ```powershell
   if (Test-Path "$devDir\composer.json") {
       Copy-Item -Path "$devDir\composer.json" -Destination "$prodDir\composer.json" -Force
   }
   ```

6. **Verificar arquivos copiados**
   ```powershell
   Get-ChildItem -Path $prodDir -File | Where-Object { $_.Extension -in '.js', '.php' } | Select-Object Name, Length, LastWriteTime
   ```

### **Resultado Esperado**
- ✅ Todos os arquivos copiados de DEV para PROD (Windows)
- ✅ Diretório PROD (Windows) contém primeira versão de produção
- ✅ Templates de email copiados

---

## 📋 FASE 3: BACKUP NO SERVIDOR PROD

### **Objetivo**
Criar backup completo do diretório de produção no servidor antes de qualquer modificação.

### **Processo**

1. **Criar backup no servidor com timestamp**
   ```bash
   ssh root@157.180.36.223 "mkdir -p /var/www/html/prod/root_backup_$(date +%Y%m%d_%H%M%S) && cp -r /var/www/html/prod/root/* /var/www/html/prod/root_backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null || true"
   ```

2. **Verificar backup criado**
   ```bash
   ssh root@157.180.36.223 "ls -lh /var/www/html/prod/root_backup_* | tail -1"
   ```

### **Resultado Esperado**
- ✅ Backup completo criado no servidor
- ✅ Backup salvo em `/var/www/html/prod/root_backup_YYYYMMDD_HHMMSS/`

---

## 📋 FASE 4: CÓPIA PROD WINDOWS → PROD SERVIDOR

### **Objetivo**
Copiar todos os arquivos do diretório de produção no Windows para o servidor de produção.

**⚠️ IMPORTANTE:** Sempre usar o diretório PROD do Windows como origem, nunca o diretório DEV.

### **Arquivos a Copiar**

Todos os arquivos copiados na Fase 2 (DEV → PROD Windows) devem ser copiados para o servidor.

### **Processo**

1. **Definir caminhos completos**
   ```powershell
   $workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
   $prodDir = "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"
   $prodServer = "root@157.180.36.223"
   $prodServerDir = "/var/www/html/prod/root"
   ```

2. **Copiar arquivos JavaScript**
   ```powershell
   scp "$prodDir\FooterCodeSiteDefinitivoCompleto.js" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\MODAL_WHATSAPP_DEFINITIVO.js" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\webflow_injection_limpo.js" "${prodServer}:${prodServerDir}/"
   ```

3. **Copiar arquivos PHP**
   ```powershell
   scp "$prodDir\add_flyingdonkeys.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\add_webflow_octa.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\config.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\config_env.js.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\class.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\ProfessionalLogger.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\log_endpoint.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\send_email_notification_endpoint.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\send_admin_notification_ses.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\cpf-validate.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\placa-validate.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\email_template_loader.php" "${prodServer}:${prodServerDir}/"
   scp "$prodDir\aws_ses_config.php" "${prodServer}:${prodServerDir}/"
   ```

4. **Criar diretório de templates no servidor e copiar**
   ```bash
   ssh $prodServer "mkdir -p ${prodServerDir}/email_templates"
   scp "$prodDir\email_templates\template_modal.php" "${prodServer}:${prodServerDir}/email_templates/"
   scp "$prodDir\email_templates\template_primeiro_contato.php" "${prodServer}:${prodServerDir}/email_templates/"
   scp "$prodDir\email_templates\template_logging.php" "${prodServer}:${prodServerDir}/email_templates/"
   ```

5. **Ajustar permissões no servidor**
   ```bash
   ssh $prodServer "chown -R www-data:www-data ${prodServerDir} && chmod -R 755 ${prodServerDir}"
   ```

6. **Verificar integridade dos arquivos (hash SHA256)**
   
   Para cada arquivo copiado, verificar hash:
   ```powershell
   # Exemplo para config.php
   $localHash = (Get-FileHash -Path "$prodDir\config.php" -Algorithm SHA256).Hash.ToUpper()
   $remoteHash = (ssh $prodServer "sha256sum ${prodServerDir}/config.php | cut -d' ' -f1").ToUpper()
   
   if ($localHash -eq $remoteHash) {
       Write-Host "✅ config.php - Hash coincide" -ForegroundColor Green
   } else {
       Write-Host "❌ config.php - Hash não coincide. Tentar copiar novamente." -ForegroundColor Red
       # Tentar copiar novamente
       scp "$prodDir\config.php" "${prodServer}:${prodServerDir}/"
       # Verificar novamente
   }
   ```

   **Repetir para todos os arquivos copiados.**

### **Resultado Esperado**
- ✅ Todos os arquivos copiados para servidor PROD
- ✅ Permissões ajustadas corretamente
- ✅ Hash SHA256 verificado para todos os arquivos (case-insensitive)
- ✅ Todos os arquivos idênticos entre Windows PROD e Servidor PROD

---

## 📋 FASE 5: CONFIGURAÇÃO DE VARIÁVEIS DE AMBIENTE PROD

### **Objetivo**
Aplicar as variáveis de ambiente corretas no servidor de produção.

### **Variáveis a Corrigir**

1. **APP_CORS_ORIGINS**
   - De: `https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br`
   - Para: `https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br`

2. **ESPOCRM_URL**
   - De: `https://dev.flyingdonkeys.com.br`
   - Para: `https://flyingdonkeys.com.br`

3. **LOG_DB_NAME**
   - De: `rpa_logs_dev`
   - Para: `rpa_logs_prod`

4. **LOG_DB_USER**
   - De: `rpa_logger_dev`
   - Para: `rpa_logger_prod`

5. **LOG_DIR**
   - Adicionar: `/var/log/webflow-segurosimediato`

### **Processo**

1. **Criar backup do arquivo PHP-FPM no servidor**
   ```bash
   ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_ANTES_CORRECAO_VARIAVEIS_$(date +%Y%m%d_%H%M%S)"
   ```

2. **Baixar arquivo atual do servidor para local**
   ```powershell
   $workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
   $configDir = "$workspacePath\WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG"
   scp "root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf" "$configDir\php-fpm_www_conf_PROD_ATUAL.conf"
   ```

3. **Criar backup local do arquivo baixado**
   ```powershell
   Copy-Item -Path "$configDir\php-fpm_www_conf_PROD_ATUAL.conf" -Destination "$configDir\php-fpm_www_conf_PROD_ATUAL.conf.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
   ```

4. **Aplicar correções no arquivo local**
   
   Editar `php-fpm_www_conf_PROD_ATUAL.conf`:
   
   - Atualizar `env[APP_CORS_ORIGINS]`
   - Atualizar `env[ESPOCRM_URL]`
   - Atualizar `env[LOG_DB_NAME]`
   - Atualizar `env[LOG_DB_USER]`
   - Adicionar `env[LOG_DIR] = /var/log/webflow-segurosimediato`

5. **Renomear arquivo corrigido**
   ```powershell
   Rename-Item -Path "$configDir\php-fpm_www_conf_PROD_ATUAL.conf" -NewName "php-fpm_www_conf_PROD.conf"
   ```

6. **Copiar arquivo corrigido para servidor**
   ```powershell
   scp "$configDir\php-fpm_www_conf_PROD.conf" "root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf"
   ```

7. **Verificar hash após cópia**
   ```powershell
   $localHash = (Get-FileHash -Path "$configDir\php-fpm_www_conf_PROD.conf" -Algorithm SHA256).Hash.ToUpper()
   $remoteHash = (ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf | cut -d' ' -f1").ToUpper()
   
   if ($localHash -eq $remoteHash) {
       Write-Host "✅ Arquivo PHP-FPM copiado corretamente" -ForegroundColor Green
   } else {
       Write-Host "❌ Hash não coincide. Tentar copiar novamente." -ForegroundColor Red
   }
   ```

8. **Testar configuração PHP-FPM**
   ```bash
   ssh root@157.180.36.223 "php-fpm8.3 -t"
   ```

9. **Reiniciar PHP-FPM**
   ```bash
   ssh root@157.180.36.223 "systemctl restart php8.3-fpm"
   ```

10. **Verificar variáveis aplicadas**
    ```bash
    ssh root@157.180.36.223 "php -r \"echo 'APP_CORS_ORIGINS: ' . getenv('APP_CORS_ORIGINS') . PHP_EOL;\""
    ssh root@157.180.36.223 "php -r \"echo 'ESPOCRM_URL: ' . getenv('ESPOCRM_URL') . PHP_EOL;\""
    ssh root@157.180.36.223 "php -r \"echo 'LOG_DB_NAME: ' . getenv('LOG_DB_NAME') . PHP_EOL;\""
    ssh root@157.180.36.223 "php -r \"echo 'LOG_DB_USER: ' . getenv('LOG_DB_USER') . PHP_EOL;\""
    ssh root@157.180.36.223 "php -r \"echo 'LOG_DIR: ' . getenv('LOG_DIR') . PHP_EOL;\""
    ```

### **Resultado Esperado**
- ✅ Backup do arquivo PHP-FPM criado
- ✅ Arquivo baixado do servidor para local
- ✅ Correções aplicadas localmente
- ✅ Arquivo corrigido copiado para servidor
- ✅ Hash verificado após cópia
- ✅ PHP-FPM reiniciado
- ✅ Todas as variáveis aplicadas corretamente

---

## 📋 FASE 6: VERIFICAÇÃO E TESTES

### **Objetivo**
Verificar que todos os arquivos foram copiados corretamente e testar o funcionamento do ambiente de produção.

### **Processo**

1. **Verificar arquivos no servidor PROD**
   ```bash
   ssh root@157.180.36.223 "ls -lh /var/www/html/prod/root/*.js /var/www/html/prod/root/*.php | head -20"
   ```

2. **Verificar diretório de templates**
   ```bash
   ssh root@157.180.36.223 "ls -lh /var/www/html/prod/root/email_templates/"
   ```

3. **Testar acesso HTTPS**
   ```bash
   curl -I https://prod.bssegurosimediato.com.br
   ```

4. **Testar carregamento de arquivo JavaScript**
   ```bash
   curl -I https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js
   ```

5. **Testar endpoint PHP**
   ```bash
   curl -I https://prod.bssegurosimediato.com.br/config.php
   ```

6. **Verificar logs**
   ```bash
   ssh root@157.180.36.223 "ls -lh /var/log/webflow-segurosimediato/"
   ```

### **Resultado Esperado**
- ✅ Todos os arquivos presentes no servidor
- ✅ Acesso HTTPS funcionando
- ✅ Arquivos JavaScript carregando
- ✅ Endpoints PHP respondendo
- ✅ Diretório de logs acessível

---

## 📋 CHECKLIST COMPLETO DO PROJETO

### **Fase 1: Backup PROD Windows**
- [ ] Criar diretório de backup com timestamp
- [ ] Copiar todo o conteúdo do diretório PROD para backup
- [ ] Verificar backup criado

### **Fase 2: Cópia DEV → PROD (Windows)**
- [ ] Copiar arquivos JavaScript (3 arquivos)
- [ ] Copiar arquivos PHP (13 arquivos)
- [ ] Criar diretório de templates e copiar (3 arquivos)
- [ ] Copiar composer.json (se necessário)
- [ ] Verificar arquivos copiados

### **Fase 3: Backup Servidor PROD**
- [ ] Criar backup no servidor com timestamp
- [ ] Verificar backup criado

### **Fase 4: Cópia PROD Windows → PROD Servidor**
- [ ] Copiar arquivos JavaScript para servidor
- [ ] Copiar arquivos PHP para servidor
- [ ] Criar diretório de templates no servidor e copiar
- [ ] Ajustar permissões no servidor
- [ ] Verificar hash SHA256 de todos os arquivos copiados
- [ ] Confirmar que todos os hashes coincidem

### **Fase 5: Configuração Variáveis de Ambiente**
- [ ] Criar backup do arquivo PHP-FPM no servidor
- [ ] Baixar arquivo atual do servidor para local
- [ ] Criar backup local do arquivo baixado
- [ ] Aplicar correções no arquivo local (5 variáveis)
- [ ] Renomear arquivo corrigido
- [ ] Copiar arquivo corrigido para servidor
- [ ] Verificar hash após cópia
- [ ] Testar configuração PHP-FPM
- [ ] Reiniciar PHP-FPM
- [ ] Verificar todas as variáveis aplicadas

### **Fase 6: Verificação e Testes**
- [ ] Verificar arquivos no servidor PROD
- [ ] Verificar diretório de templates
- [ ] Testar acesso HTTPS
- [ ] Testar carregamento de arquivo JavaScript
- [ ] Testar endpoint PHP
- [ ] Verificar logs

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **Diretivas Obrigatórias Seguidas:**

1. ✅ **Backups Obrigatórios:**
   - Backup do diretório PROD (Windows) antes de modificar
   - Backup do servidor PROD antes de modificar
   - Backup do arquivo PHP-FPM antes de modificar

2. ✅ **Verificação de Hash:**
   - Hash SHA256 verificado após cada cópia
   - Comparação case-insensitive
   - Re-cópia se hash não coincidir

3. ✅ **Caminhos Completos:**
   - Sempre usar caminho completo do workspace
   - Não usar caminhos relativos

4. ✅ **Fluxo Correto:**
   - DEV Windows → PROD Windows → PROD Servidor
   - Nunca copiar diretamente de DEV para servidor PROD

5. ✅ **Arquivos Criados Localmente:**
   - Arquivo PHP-FPM corrigido criado localmente primeiro
   - Copiado para servidor via SCP

6. ✅ **Secret Keys:**
   - ⚠️ **NÃO incluídas neste projeto** (serão definidas amanhã)
   - ⚠️ Criar projeto separado para atualizar secret keys

---

## 📝 PENDÊNCIAS

### **Secret Keys do Webflow:**
- ⚠️ **Status:** Serão definidas amanhã
- ⚠️ **Ação:** Criar projeto separado após definição
- ⚠️ **Variáveis afetadas:**
  - `WEBFLOW_SECRET_FLYINGDONKEYS`
  - `WEBFLOW_SECRET_OCTADESK`

---

## 📋 PRÓXIMOS PASSOS APÓS CONCLUSÃO

1. ⏳ Aguardar definição das secret keys do Webflow
2. ⏳ Criar projeto para atualizar secret keys
3. ⏳ Executar projeto de atualização de secret keys
4. ⏳ Testes finais completos em produção

---

**Data de Criação:** 14/11/2025  
**Status:** 📝 **PROJETO DEFINIDO - AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**

