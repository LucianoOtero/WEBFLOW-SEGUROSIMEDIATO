# 🔧 PROJETO: CORREÇÃO CORS placa-validate.php e cpf-validate.php em PRODUÇÃO

**Data:** 16/11/2025  
**Status:** ✅ **IMPLEMENTADO E CONCLUÍDO**  
**Ambiente:** 🔴 **PRODUÇÃO** - `prod.bssegurosimediato.com.br`  
**Baseado em:** `ANALISE_ERRO_CORS_PLACA_VALIDATE_PROD.md`  
**Auditoria:** `AUDITORIA_CORRECAO_CORS_PLACA_CPF_VALIDATE_PROD.md`

---

## 🎯 OBJETIVO

Corrigir erro de CORS duplicado em `placa-validate.php` e `cpf-validate.php` em produção, adicionando locations específicos no Nginx seguindo o mesmo padrão arquitetural do ambiente DEV.

**Problema Identificado:**
- ❌ Nginx PROD não tem locations específicos para `placa-validate.php` e `cpf-validate.php`
- ❌ Ambos usam location geral `location ~ \.php$` que adiciona headers CORS
- ❌ PHP também adiciona headers CORS via `setCorsHeaders()`
- ❌ **Resultado:** Header `Access-Control-Allow-Origin` duplicado → Erro CORS

**Solução:**
- ✅ Adicionar locations específicos no Nginx PROD (sem headers CORS)
- ✅ PHP controla CORS via `setCorsHeaders()` (padrão arquitetural)
- ✅ Eliminar duplicação de headers CORS

---

## 🔍 SITUAÇÃO ATUAL

### **Ambiente DEV (Correto):**
- ✅ `placa-validate.php` → `location = /placa-validate.php` (sem headers CORS do Nginx)
- ✅ `cpf-validate.php` → `location = /cpf-validate.php` (sem headers CORS do Nginx)
- ✅ PHP controla CORS via `setCorsHeaders()`
- ✅ **Funciona corretamente**

### **Ambiente PROD (Problema):**
- ❌ `placa-validate.php` → usa `location ~ \.php$` (com headers CORS do Nginx)
- ❌ `cpf-validate.php` → usa `location ~ \.php$` (com headers CORS do Nginx)
- ❌ Nginx adiciona headers CORS + PHP adiciona headers CORS
- ❌ **Erro CORS duplicado**

---

## 📋 ARQUIVOS QUE SERÃO MODIFICADOS

### **1. Configuração Nginx PROD**
- **Localização no Servidor:** `/etc/nginx/sites-available/prod.bssegurosimediato.com.br`
- **Arquivo Local:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_prod_bssegurosimediato_com_br.conf` (será criado/atualizado)
- **Modificações:**
  - Adicionar location específico para `placa-validate.php` (antes do location geral)
  - Adicionar location específico para `cpf-validate.php` (antes do location geral)
  - Seguir mesmo padrão do ambiente DEV (sem headers CORS do Nginx)

---

## 🔧 IMPLEMENTAÇÃO DETALHADA

### **FASE 1: Verificar Identidade dos Arquivos (OBRIGATÓRIO)**

**🚨 OBRIGATÓRIO:** Antes de modificar qualquer arquivo de configuração, verificar se o arquivo local é idêntico ao arquivo no servidor.

**1.1. Baixar arquivo do servidor para local:**
- Arquivo no servidor: `/etc/nginx/sites-available/prod.bssegurosimediato.com.br`
- Arquivo local: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_prod_bssegurosimediato_com_br.conf`
- Se arquivo local não existir, baixar do servidor primeiro

**1.2. Comparar hash (SHA256, case-insensitive):**
- Se diferentes → Atualizar arquivo local com versão do servidor primeiro
- Se idênticos → Pode modificar arquivo local com segurança

**Comandos:**
```powershell
# Definir caminho completo do workspace
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$arquivoLocal = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\nginx_prod_bssegurosimediato_com_br.conf"
$servidor = "root@157.180.36.223"
$arquivoServidor = "/etc/nginx/sites-available/prod.bssegurosimediato.com.br"

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

**2.1. Criar backup da configuração Nginx no servidor PROD:**
- Arquivo: `/etc/nginx/sites-available/prod.bssegurosimediato.com.br.backup_ANTES_CORRECAO_CORS_PLACA_CPF_PROD_YYYYMMDD_HHMMSS`

**2.2. Criar backup local do arquivo de configuração:**
- Arquivo: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_prod_bssegurosimediato_com_br.conf.backup_ANTES_CORRECAO_CORS_PLACA_CPF_PROD_YYYYMMDD_HHMMSS`

**Comandos:**
```powershell
# Backup no servidor
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
ssh root@157.180.36.223 "cp /etc/nginx/sites-available/prod.bssegurosimediato.com.br /etc/nginx/sites-available/prod.bssegurosimediato.com.br.backup_ANTES_CORRECAO_CORS_PLACA_CPF_PROD_$timestamp"

# Backup local
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$arquivoLocal = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\nginx_prod_bssegurosimediato_com_br.conf"
$backupLocal = "${arquivoLocal}.backup_ANTES_CORRECAO_CORS_PLACA_CPF_PROD_$timestamp"
Copy-Item -Path $arquivoLocal -Destination $backupLocal -Force
Write-Host "✅ Backup local criado: $backupLocal" -ForegroundColor Green
```

---

### **FASE 3: Criar Locations Específicos no Nginx**

**Padrão a Seguir (baseado no ambiente DEV):**

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
- Inserir **ANTES** do location geral `location ~ \.php$`
- Após outros locations específicos (se existirem)
- Manter ordem: locations específicos primeiro, location geral por último

---

### **FASE 4: Modificar Arquivo Local**

**4.1. Abrir arquivo local:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_prod_bssegurosimediato_com_br.conf`

**4.2. Adicionar locations específicos:**
- Localizar location geral `location ~ \.php$`
- Inserir locations específicos **ANTES** do location geral
- Manter formatação e comentários consistentes

**4.3. Verificar sintaxe:**
- Verificar que não há erros de sintaxe
- Verificar que locations específicos estão antes do location geral

**Estrutura Esperada:**
```nginx
# ... (outros locations específicos, se existirem) ...

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

### **FASE 5: Copiar para Servidor PROD**

**Processo:**
1. ✅ Verificar que arquivo local está correto
2. ✅ Copiar arquivo local para servidor PROD usando caminho completo do workspace
3. ✅ Criar backup no servidor antes de sobrescrever (já feito na FASE 2)
4. ✅ Comparar hash após cópia (SHA256, case-insensitive)

**Comandos:**
```powershell
# Definir caminho completo do workspace
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$arquivoLocal = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\nginx_prod_bssegurosimediato_com_br.conf"
$servidor = "root@157.180.36.223"
$arquivoServidor = "/etc/nginx/sites-available/prod.bssegurosimediato.com.br"

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
ssh root@157.180.36.223 "nginx -t"

# Se teste passar, recarregar Nginx
ssh root@157.180.36.223 "systemctl reload nginx"

# Se teste falhar, reverter usando backup
# ssh root@157.180.36.223 "cp /etc/nginx/sites-available/prod.bssegurosimediato.com.br.backup_ANTES_CORRECAO_CORS_PLACA_CPF_PROD_* /etc/nginx/sites-available/prod.bssegurosimediato.com.br"
```

---

### **FASE 7: Testes Funcionais**

**7.1. Testar validação de placa:**
- Acessar formulário em `https://www.segurosimediato.com.br` (ou domínio de produção)
- Digitar placa no campo
- Verificar se validação funciona corretamente
- Verificar se não há erros CORS no console do browser

**7.2. Testar validação de CPF:**
- Acessar formulário em `https://www.segurosimediato.com.br` (ou domínio de produção)
- Digitar CPF no campo
- Verificar se validação funciona corretamente
- Verificar se não há erros CORS no console do browser

**7.3. Verificar headers CORS:**
- Abrir DevTools → Network
- Fazer requisição para `placa-validate.php`
- Verificar headers da resposta
- Confirmar que `Access-Control-Allow-Origin` aparece apenas uma vez (enviado pelo PHP)

**7.4. Verificar logs do Nginx:**
- Verificar se não há erros em `/var/log/nginx/prod_error.log` (ou log apropriado)
- Verificar se requisições estão sendo processadas corretamente

**Comandos de Teste:**
```bash
# Testar endpoint placa-validate.php via curl
curl -I -X OPTIONS \
  -H "Origin: https://www.segurosimediato.com.br" \
  -H "Access-Control-Request-Method: POST" \
  https://prod.bssegurosimediato.com.br/placa-validate.php

# Testar endpoint cpf-validate.php via curl
curl -I -X OPTIONS \
  -H "Origin: https://www.segurosimediato.com.br" \
  -H "Access-Control-Request-Method: POST" \
  https://prod.bssegurosimediato.com.br/cpf-validate.php

# Verificar logs do Nginx
ssh root@157.180.36.223 "tail -n 50 /var/log/nginx/prod_error.log"
```

---

### **FASE 8: Verificar Consistência Arquitetural**

**Verificação:**
1. ✅ Confirmar que `placa-validate.php` tem location específico
2. ✅ Confirmar que `cpf-validate.php` tem location específico
3. ✅ Confirmar que locations específicos seguem mesmo padrão do DEV:
   - Sem headers CORS do Nginx
   - PHP controla CORS via `setCorsHeaders()`
   - Comentários consistentes
   - Formatação consistente

**Resultado Esperado:**
- ✅ `placa-validate.php` e `cpf-validate.php` com location específico
- ✅ Arquitetura consistente com ambiente DEV
- ✅ Sem duplicação de headers CORS
- ✅ Funcionamento correto em produção

---

### **FASE 9: Auditoria Pós-Implementação**

**9.1. Auditoria de Configuração:**
- Verificar sintaxe do Nginx (`nginx -t`)
- Verificar se locations específicos foram adicionados corretamente
- Verificar se location geral não foi afetado
- Comparar configuração modificada com backup

**9.2. Auditoria de Funcionalidade:**
- Comparar código modificado com backup original
- Confirmar que apenas locations específicos foram adicionados
- Confirmar que nenhuma funcionalidade foi quebrada
- Confirmar que validação de placa funciona corretamente
- Confirmar que validação de CPF funciona corretamente

**9.3. Auditoria de Consistência:**
- Verificar que locations específicos seguem mesmo padrão do DEV
- Verificar que arquitetura está consistente entre DEV e PROD
- Confirmar que padrão arquitetural está estabelecido

**9.4. Documentar Auditoria:**
- Criar relatório de auditoria em `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/`
- Listar todos os arquivos auditados
- Documentar mudanças realizadas
- Confirmar que nenhuma funcionalidade foi prejudicada
- Registrar aprovação da auditoria

---

## 📊 RESUMO DAS MUDANÇAS

### **Arquivo Modificado:**
- `/etc/nginx/sites-available/prod.bssegurosimediato.com.br` (no servidor PROD)
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_prod_bssegurosimediato_com_br.conf` (local)

### **Mudanças Principais:**
- Adicionar location específico para `placa-validate.php` (antes do location geral)
- Adicionar location específico para `cpf-validate.php` (antes do location geral)
- Seguir mesmo padrão do ambiente DEV (sem headers CORS do Nginx)

### **Impacto:**
- ✅ Elimina erro de CORS duplicado
- ✅ Consistência arquitetural entre DEV e PROD
- ✅ Arquitetura previsível e fácil de manter
- ✅ Não quebra funcionalidades existentes

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **Preparação:**
- [ ] FASE 1: Verificar identidade dos arquivos (comparar hash local vs servidor)
- [ ] FASE 1: Se diferentes, atualizar arquivo local com versão do servidor
- [ ] FASE 2: Criar backup da configuração Nginx no servidor PROD
- [ ] FASE 2: Criar backup local do arquivo de configuração

### **Implementação:**
- [ ] FASE 3: Criar locations específicos no arquivo local
- [ ] FASE 4: Modificar arquivo local com locations específicos
- [ ] FASE 5: Copiar arquivo local para servidor PROD (com verificação de hash)
- [ ] FASE 6: Testar configuração Nginx (`nginx -t`)
- [ ] FASE 6: Recarregar Nginx (`systemctl reload nginx`)

### **Testes:**
- [ ] FASE 7: Testar validação de placa em produção
- [ ] FASE 7: Testar validação de CPF em produção
- [ ] FASE 7: Verificar headers CORS (sem duplicação)
- [ ] FASE 7: Verificar logs do Nginx

### **Verificação:**
- [ ] FASE 8: Verificar consistência arquitetural (DEV vs PROD)
- [ ] FASE 8: Confirmar que locations específicos seguem mesmo padrão

### **Auditoria:**
- [ ] FASE 9: Realizar auditoria de configuração
- [ ] FASE 9: Realizar auditoria de funcionalidade
- [ ] FASE 9: Realizar auditoria de consistência
- [ ] FASE 9: Documentar auditoria

---

## 🎯 RESULTADO ESPERADO

Após implementação:
- ✅ `placa-validate.php` e `cpf-validate.php` com location específico no Nginx PROD
- ✅ Arquitetura consistente com ambiente DEV
- ✅ Sem duplicação de headers CORS
- ✅ Validação de placa funcionando corretamente em produção
- ✅ Validação de CPF funcionando corretamente em produção
- ✅ Headers CORS enviados apenas pelo PHP (sem duplicação)
- ✅ Erro CORS eliminado

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Backup Obrigatório:**
   - Sempre fazer backup antes de modificar configuração Nginx
   - Configuração incorreta pode quebrar todo o site em produção

2. **Teste Obrigatório:**
   - Sempre testar configuração com `nginx -t` antes de recarregar
   - Não recarregar se teste falhar

3. **Ambiente PRODUÇÃO:**
   - ⚠️ Este projeto trabalha no ambiente de **PRODUÇÃO**
   - ⚠️ Qualquer erro pode afetar usuários reais
   - ⚠️ Testar cuidadosamente antes de considerar concluído

4. **Verificação de Hash:**
   - Sempre comparar hash após copiar arquivo para servidor
   - Usar SHA256 com comparação case-insensitive
   - Usar caminho completo do workspace

5. **Ordem dos Locations:**
   - Locations específicos devem vir **ANTES** do location geral
   - Isso garante que tenham prioridade sobre o location geral

6. **Cache Cloudflare:**
   - 🚨 **OBRIGATÓRIO:** Após atualizar configuração Nginx, avisar ao usuário sobre a necessidade de limpar o cache do Cloudflare (se aplicável)
   - Mudanças no Nginx geralmente não requerem limpeza de cache, mas é importante verificar

---

## 📋 PRÓXIMOS PASSOS

1. ✅ Aguardar autorização para implementar
2. ✅ Executar fases do projeto em ordem
3. ✅ Realizar auditoria pós-implementação
4. ✅ Documentar resultados

---

**Status:** 📝 **PROJETO ELABORADO**  
**Próximo Passo:** Aguardar autorização para implementar

