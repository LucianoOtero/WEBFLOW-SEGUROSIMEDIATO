# 📋 PROJETO: PADRONIZAÇÃO placa-validate.php E cpf-validate.php

**Data:** 12/11/2025  
**Status:** 📝 **PROJETO ELABORADO**  
**Baseado em:** `ANALISE_CONSISTENCIA_ARQUITETURAL_ENDPOINTS.md`

---

## 🎯 OBJETIVO

Padronizar `placa-validate.php` e `cpf-validate.php` com locations específicos no Nginx, seguindo o mesmo padrão arquitetural dos demais endpoints (`log_endpoint.php`, `add_flyingdonkeys.php`, `add_webflow_octa.php`, `send_email_notification_endpoint.php`).

**Benefícios:**
- ✅ Consistência arquitetural completa (100% dos endpoints)
- ✅ Facilita migração DEV → PROD (configuração isolada)
- ✅ Arquitetura previsível e fácil de manter
- ✅ Alinhado com objetivos do projeto (migração suave)

---

## 🔍 SITUAÇÃO ATUAL

### **Endpoints com Location Específico (Padrão Estabelecido):**
- ✅ `log_endpoint.php` → `location = /log_endpoint.php` (linhas 25-37)
- ✅ `add_flyingdonkeys.php` → `location = /add_flyingdonkeys.php` (linhas 39-47)
- ✅ `add_webflow_octa.php` → `location = /add_webflow_octa.php` (linhas 49-57)
- ✅ `send_email_notification_endpoint.php` → `location = /send_email_notification_endpoint.php` (linhas 59-67)

### **Endpoints SEM Location Específico (Serão Padronizados):**
- ⚠️ `placa-validate.php` → usa `location ~ \.php$` (geral)
- ⚠️ `cpf-validate.php` → usa `location ~ \.php$` (geral)

**Problema:** Inconsistência arquitetural (66% padronizado, 33% não padronizado)

---

## 📋 ARQUIVOS QUE SERÃO MODIFICADOS

### **1. Configuração Nginx**
- **Localização:** `/etc/nginx/sites-available/dev.bssegurosimediato.com.br` (no servidor DEV)
- **Arquivo Local:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_bssegurosimediato_com_br.conf`
- **Modificações:**
  - Adicionar location específico para `placa-validate.php` (antes do location geral)
  - Adicionar location específico para `cpf-validate.php` (antes do location geral)
  - Seguir mesmo padrão dos demais endpoints (sem headers CORS do Nginx)

---

## 🔧 IMPLEMENTAÇÃO DETALHADA

### **FASE 1: Verificar Identidade dos Arquivos (OBRIGATÓRIO)**

**🚨 OBRIGATÓRIO:** Antes de modificar qualquer arquivo de configuração, verificar se o arquivo local é idêntico ao arquivo no servidor.

1. ✅ Baixar arquivo do servidor para local (se necessário)
   - Arquivo no servidor: `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`
   - Arquivo local: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_bssegurosimediato_com_br.conf`
   - Se arquivo local não existir ou estiver desatualizado, baixar do servidor primeiro

2. ✅ Comparar hash (SHA256, case-insensitive) do arquivo local com hash do arquivo no servidor
   - Se diferentes → Atualizar arquivo local com versão do servidor primeiro
   - Se idênticos → Pode modificar arquivo local com segurança

**Comandos:**
```powershell
# Definir caminho completo do workspace
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$arquivoLocal = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\nginx_dev_bssegurosimediato_com_br.conf"
$servidor = "root@65.108.156.14"
$arquivoServidor = "/etc/nginx/sites-available/dev.bssegurosimediato.com.br"

# Se arquivo local não existir, baixar do servidor
if (-not (Test-Path $arquivoLocal)) {
    Write-Host "⚠️ Arquivo local não existe. Baixando do servidor..." -ForegroundColor Yellow
    scp "${servidor}:${arquivoServidor}" $arquivoLocal
}

# Calcular hash do arquivo local (SHA256, maiúsculas)
$hashLocal = (Get-FileHash -Path $arquivoLocal -Algorithm SHA256).Hash.ToUpper()

# Calcular hash do arquivo no servidor (SHA256, maiúsculas)
$hashServidor = (ssh $servidor "sha256sum $arquivoServidor | cut -d' ' -f1").ToUpper()

Write-Host "Hash Local (SHA256 - Maiúsculas): $hashLocal"
Write-Host "Hash Servidor (SHA256 - Maiúsculas): $hashServidor"

# Comparar hashes
if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ Arquivos são idênticos - pode modificar arquivo local com segurança" -ForegroundColor Green
} else {
    Write-Host "⚠️ Arquivos são diferentes - atualizando arquivo local com versão do servidor..." -ForegroundColor Yellow
    # Baixar arquivo do servidor para atualizar arquivo local
    scp "${servidor}:${arquivoServidor}" $arquivoLocal
    Write-Host "✅ Arquivo local atualizado com versão do servidor" -ForegroundColor Green
    # Recalcular hash após atualização
    $hashLocal = (Get-FileHash -Path $arquivoLocal -Algorithm SHA256).Hash.ToUpper()
    Write-Host "Novo Hash Local (SHA256 - Maiúsculas): $hashLocal"
}
```

**⚠️ IMPORTANTE:** Não prosseguir para FASE 2 até que os arquivos sejam idênticos.

---

### **FASE 2: Criar Backup**

1. ✅ Criar backup da configuração Nginx no servidor DEV
   - Arquivo: `/etc/nginx/sites-available/dev.bssegurosimediato.com.br.backup_ANTES_PADRONIZACAO_PLACA_CPF_YYYYMMDD_HHMMSS`
2. ✅ Criar backup local do arquivo de configuração
   - Arquivo: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_bssegurosimediato_com_br.conf.backup_ANTES_PADRONIZACAO_PLACA_CPF_YYYYMMDD_HHMMSS`

**Comandos:**
```bash
# Backup no servidor
ssh root@65.108.156.14 "cp /etc/nginx/sites-available/dev.bssegurosimediato.com.br /etc/nginx/sites-available/dev.bssegurosimediato.com.br.backup_ANTES_PADRONIZACAO_PLACA_CPF_\$(date +%Y%m%d_%H%M%S)"

# Backup local
# PowerShell
Copy-Item "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\nginx_dev_bssegurosimediato_com_br.conf" "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\nginx_dev_bssegurosimediato_com_br.conf.backup_ANTES_PADRONIZACAO_PLACA_CPF_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
```

---

### **FASE 3: Criar Locations Específicos no Nginx**

**Padrão a Seguir (baseado nos outros endpoints):**

```nginx
# Location específico para placa-validate.php (SEM headers CORS - PHP faz com validação)
# Deve vir ANTES do location geral para ter prioridade
location = /placa-validate.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    # NÃO adicionar headers CORS aqui - o PHP fará com validação via setCorsHeaders()
}

# Location específico para cpf-validate.php (SEM headers CORS - PHP faz com validação)
# Deve vir ANTES do location geral para ter prioridade
location = /cpf-validate.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    # NÃO adicionar headers CORS aqui - o PHP fará com validação via setCorsHeaders()
}
```

**Localização no Arquivo:**
- Inserir **ANTES** do location geral `location ~ \.php$` (linha 70)
- Após o location de `send_email_notification_endpoint.php` (linha 67)
- Manter ordem: locations específicos primeiro, location geral por último

---

### **FASE 4: Modificar Arquivo Local**

1. ✅ Abrir arquivo local: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_bssegurosimediato_com_br.conf`
2. ✅ Adicionar locations específicos após linha 67 (após `send_email_notification_endpoint.php`)
3. ✅ Manter formatação e comentários consistentes com outros locations
4. ✅ Verificar sintaxe antes de copiar para servidor

**Estrutura Esperada:**
```nginx
# ... (locations existentes) ...

# Location específico para send_email_notification_endpoint.php (SEM headers CORS - PHP faz com validação)
location = /send_email_notification_endpoint.php {
    # ... (configuração existente) ...
}

# Location específico para placa-validate.php (SEM headers CORS - PHP faz com validação)
# Deve vir ANTES do location geral para ter prioridade
location = /placa-validate.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    # NÃO adicionar headers CORS aqui - o PHP fará com validação via setCorsHeaders()
}

# Location específico para cpf-validate.php (SEM headers CORS - PHP faz com validação)
# Deve vir ANTES do location geral para ter prioridade
location = /cpf-validate.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    # NÃO adicionar headers CORS aqui - o PHP fará com validação via setCorsHeaders()
}

# Location geral para outros arquivos PHP (COM headers CORS do Nginx)
location ~ \.php$ {
    # ... (configuração existente) ...
}
```

---

### **FASE 5: Copiar para Servidor DEV**

**Processo:**
1. ✅ Verificar que arquivo local está correto
2. ✅ Copiar arquivo local para servidor DEV usando caminho completo do workspace
3. ✅ Criar backup no servidor antes de sobrescrever
4. ✅ Comparar hash após cópia (SHA256, case-insensitive)

**Comandos:**
```powershell
# Definir caminho completo do workspace
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$arquivoLocal = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\nginx_dev_bssegurosimediato_com_br.conf"
$servidor = "root@65.108.156.14"
$arquivoServidor = "/etc/nginx/sites-available/dev.bssegurosimediato.com.br"

# Criar backup no servidor antes de copiar
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
ssh $servidor "cp $arquivoServidor ${arquivoServidor}.backup_ANTES_PADRONIZACAO_PLACA_CPF_$timestamp"

# Copiar arquivo para servidor
scp $arquivoLocal "${servidor}:${arquivoServidor}"

# Comparar hash após cópia (SHA256, case-insensitive)
$hashLocal = (Get-FileHash -Path $arquivoLocal -Algorithm SHA256).Hash.ToUpper()
$hashServidor = (ssh $servidor "sha256sum $arquivoServidor | cut -d' ' -f1").ToUpper()

Write-Host "Hash Local (SHA256 - Maiúsculas): $hashLocal"
Write-Host "Hash Servidor (SHA256 - Maiúsculas): $hashServidor"

if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ Arquivos são idênticos - cópia bem-sucedida" -ForegroundColor Green
} else {
    Write-Host "❌ Arquivos são diferentes - tentar copiar novamente" -ForegroundColor Red
    exit 1
}
```

---

### **FASE 6: Testar Configuração Nginx**

**Processo:**
1. ✅ Testar sintaxe do Nginx: `nginx -t`
2. ✅ Se teste passar, recarregar Nginx: `systemctl reload nginx`
3. ✅ Se teste falhar, reverter mudanças usando backup

**Comandos:**
```bash
# Testar configuração
ssh root@65.108.156.14 "nginx -t"

# Se teste passar, recarregar Nginx
ssh root@65.108.156.14 "systemctl reload nginx"

# Se teste falhar, reverter usando backup
# ssh root@65.108.156.14 "cp /etc/nginx/sites-available/dev.bssegurosimediato.com.br.backup_ANTES_PADRONIZACAO_PLACA_CPF_* /etc/nginx/sites-available/dev.bssegurosimediato.com.br"
```

---

### **FASE 7: Testes Funcionais**

1. ✅ Testar validação de placa:
   - Acessar formulário em `https://segurosimediato-dev.webflow.io`
   - Digitar placa no campo
   - Verificar se validação funciona corretamente
   - Verificar se não há erros CORS no console do browser

2. ✅ Testar validação de CPF:
   - Acessar formulário em `https://segurosimediato-dev.webflow.io`
   - Digitar CPF no campo
   - Verificar se validação funciona corretamente
   - Verificar se não há erros CORS no console do browser

3. ✅ Verificar headers CORS:
   - Abrir DevTools → Network
   - Fazer requisição para `placa-validate.php`
   - Verificar headers da resposta
   - Confirmar que `Access-Control-Allow-Origin` aparece apenas uma vez (enviado pelo PHP)

4. ✅ Verificar logs do Nginx:
   - Verificar se não há erros em `/var/log/nginx/dev_error.log`
   - Verificar se requisições estão sendo processadas corretamente

**Comandos de Teste:**
```bash
# Testar endpoint placa-validate.php via curl
curl -I -X OPTIONS \
  -H "Origin: https://segurosimediato-dev.webflow.io" \
  -H "Access-Control-Request-Method: POST" \
  https://dev.bssegurosimediato.com.br/placa-validate.php

# Testar endpoint cpf-validate.php via curl
curl -I -X OPTIONS \
  -H "Origin: https://segurosimediato-dev.webflow.io" \
  -H "Access-Control-Request-Method: POST" \
  https://dev.bssegurosimediato.com.br/cpf-validate.php

# Verificar logs do Nginx
ssh root@65.108.156.14 "tail -n 50 /var/log/nginx/dev_error.log"
```

---

### **FASE 8: Verificar Consistência Arquitetural**

**Verificação:**
1. ✅ Confirmar que todos os endpoints têm location específico:
   - ✅ `log_endpoint.php` → location específico
   - ✅ `add_flyingdonkeys.php` → location específico
   - ✅ `add_webflow_octa.php` → location específico
   - ✅ `send_email_notification_endpoint.php` → location específico
   - ✅ `placa-validate.php` → location específico (NOVO)
   - ✅ `cpf-validate.php` → location específico (NOVO)

2. ✅ Confirmar que todos os locations específicos seguem mesmo padrão:
   - ✅ Sem headers CORS do Nginx
   - ✅ PHP controla CORS via `setCorsHeaders()` ou headers próprios
   - ✅ Comentários consistentes
   - ✅ Formatação consistente

**Resultado Esperado:**
- ✅ **100% dos endpoints** com location específico
- ✅ **Arquitetura completamente consistente**
- ✅ **Padrão único e previsível**

---

### **FASE 9: Auditoria Pós-Implementação**

1. ✅ **Auditoria de Configuração:**
   - Verificar sintaxe do Nginx (`nginx -t`)
   - Verificar se locations específicos foram adicionados corretamente
   - Verificar se location geral não foi afetado
   - Comparar configuração modificada com backup

2. ✅ **Auditoria de Funcionalidade:**
   - Comparar código modificado com backup original
   - Confirmar que apenas locations específicos foram adicionados
   - Confirmar que nenhuma funcionalidade foi quebrada
   - Confirmar que validação de placa funciona corretamente
   - Confirmar que validação de CPF funciona corretamente

3. ✅ **Auditoria de Consistência:**
   - Verificar que todos os endpoints seguem mesmo padrão
   - Verificar que arquitetura está completamente consistente
   - Confirmar que padrão arquitetural está estabelecido

4. ✅ **Documentar Auditoria:**
   - Criar relatório de auditoria em `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/`
   - Listar todos os arquivos auditados
   - Documentar mudanças realizadas
   - Confirmar que nenhuma funcionalidade foi prejudicada
   - Registrar aprovação da auditoria

---

## 📊 RESUMO DAS MUDANÇAS

### **Arquivo Modificado:**
- `/etc/nginx/sites-available/dev.bssegurosimediato.com.br` (no servidor DEV)
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_bssegurosimediato_com_br.conf` (local)

### **Mudanças Principais:**
- Adicionar location específico para `placa-validate.php` (antes do location geral)
- Adicionar location específico para `cpf-validate.php` (antes do location geral)
- Seguir mesmo padrão dos demais endpoints (sem headers CORS do Nginx)

### **Impacto:**
- ✅ Consistência arquitetural completa (100% dos endpoints)
- ✅ Facilita migração DEV → PROD (configuração isolada)
- ✅ Arquitetura previsível e fácil de manter
- ✅ Não quebra funcionalidades existentes

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **Preparação:**
- [ ] FASE 1: Verificar identidade dos arquivos (comparar hash local vs servidor)
- [ ] FASE 1: Se diferentes, atualizar arquivo local com versão do servidor
- [ ] FASE 2: Criar backup da configuração Nginx no servidor DEV
- [ ] FASE 2: Criar backup local do arquivo de configuração

### **Implementação:**
- [ ] FASE 3: Criar locations específicos no arquivo local
- [ ] FASE 4: Modificar arquivo local com locations específicos
- [ ] FASE 5: Copiar arquivo local para servidor DEV (com verificação de hash)
- [ ] FASE 6: Testar configuração Nginx (`nginx -t`)
- [ ] FASE 6: Recarregar Nginx (`systemctl reload nginx`)

### **Testes:**
- [ ] FASE 7: Testar validação de placa
- [ ] FASE 7: Testar validação de CPF
- [ ] FASE 7: Verificar headers CORS
- [ ] FASE 7: Verificar logs do Nginx

### **Verificação:**
- [ ] FASE 8: Verificar consistência arquitetural (100% dos endpoints)
- [ ] FASE 8: Confirmar que todos os endpoints seguem mesmo padrão

### **Auditoria:**
- [ ] FASE 9: Realizar auditoria de configuração
- [ ] FASE 9: Realizar auditoria de funcionalidade
- [ ] FASE 9: Realizar auditoria de consistência
- [ ] FASE 9: Documentar auditoria

---

## 🎯 RESULTADO ESPERADO

Após implementação:
- ✅ **100% dos endpoints** com location específico no Nginx
- ✅ **Arquitetura completamente consistente**
- ✅ **Padrão único e previsível**
- ✅ **Validação de placa funcionando corretamente**
- ✅ **Validação de CPF funcionando corretamente**
- ✅ **Headers CORS enviados apenas pelo PHP (sem duplicação)**
- ✅ **Facilita migração DEV → PROD** (configuração isolada por endpoint)

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Backup Obrigatório:**
   - Sempre fazer backup antes de modificar configuração Nginx
   - Configuração incorreta pode quebrar todo o site

2. **Teste Obrigatório:**
   - Sempre testar configuração com `nginx -t` antes de recarregar
   - Não recarregar se teste falhar

3. **Ambiente:**
   - Este projeto trabalha apenas no ambiente DEV
   - Não modificar configuração de produção

4. **Verificação de Hash:**
   - Sempre comparar hash após copiar arquivo para servidor
   - Usar SHA256 com comparação case-insensitive
   - Usar caminho completo do workspace

5. **Ordem dos Locations:**
   - Locations específicos devem vir **ANTES** do location geral
   - Isso garante que tenham prioridade sobre o location geral

---

## 📋 PRÓXIMOS PASSOS

1. ✅ Aguardar autorização para implementar
2. ✅ Executar fases do projeto em ordem
3. ✅ Realizar auditoria pós-implementação
4. ✅ Documentar resultados

---

**Status:** 📝 **PROJETO ELABORADO**  
**Próximo Passo:** Aguardar autorização para implementar

