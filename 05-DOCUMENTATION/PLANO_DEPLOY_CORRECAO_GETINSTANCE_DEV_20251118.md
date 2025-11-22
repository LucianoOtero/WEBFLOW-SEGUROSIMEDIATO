# 🚀 PLANO DE DEPLOY: Correção Erro getInstance() - Servidor DEV

**Data:** 18/11/2025  
**Versão:** 1.0.0  
**Projeto:** Corrigir Erro getInstance() e Revisar Logs  
**Status:** ⏳ **AGUARDANDO EXECUÇÃO**

---

## 🎯 OBJETIVO

Fazer deploy do arquivo corrigido `send_admin_notification_ses.php` para o servidor DEV, testar a correção do erro 500 e verificar que emails são enviados corretamente.

---

## 📋 FASES DO DEPLOY

### **FASE 1: Preparação e Backup**

**Objetivo:** Criar backup do arquivo no servidor antes de copiar

**Ações:**
1. Conectar ao servidor DEV via SSH
2. Criar backup do arquivo original com timestamp
3. Verificar que backup foi criado com sucesso

**Comandos:**
```bash
# Criar backup no servidor
ssh root@65.108.156.14 "cp /var/www/html/dev/root/send_admin_notification_ses.php /var/www/html/dev/root/send_admin_notification_ses.php.backup_$(date +%Y%m%d_%H%M%S).php"
```

---

### **FASE 2: Cópia do Arquivo para Servidor**

**Objetivo:** Copiar arquivo corrigido do Windows para servidor DEV

**Ações:**
1. Usar caminho completo do workspace
2. Copiar arquivo via SCP
3. Verificar que arquivo foi copiado

**Comandos:**
```powershell
# Copiar arquivo local para servidor (usar caminho completo do workspace)
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_admin_notification_ses.php" root@65.108.156.14:/var/www/html/dev/root/
```

---

### **FASE 3: Verificação de Hash SHA256**

**Objetivo:** Garantir integridade do arquivo após cópia

**Ações:**
1. Calcular hash SHA256 do arquivo local
2. Calcular hash SHA256 do arquivo no servidor
3. Comparar hashes (case-insensitive)
4. Confirmar que hashes coincidem

**Hash Esperado (Local):**
```
75BAA529155814C649D25467B8039BAF36BB839AFA9C2A38BEB1F93762344127
```

**Comandos:**
```powershell
# Hash local
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_admin_notification_ses.php" -Algorithm SHA256).Hash.ToUpper()

# Hash servidor
$hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/send_admin_notification_ses.php | cut -d' ' -f1").ToUpper()

# Comparar
if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ Hash coincide - arquivo copiado corretamente"
} else {
    Write-Host "❌ Hash não coincide - tentar copiar novamente"
}
```

---

### **FASE 4: Teste do Endpoint de Email**

**Objetivo:** Verificar que endpoint não retorna mais erro 500

**Ações:**
1. Enviar requisição POST de teste para `send_email_notification_endpoint.php`
2. Verificar resposta HTTP (deve ser 200, não 500)
3. Verificar que JSON de resposta contém `success: true`
4. Verificar que email foi enviado aos administradores

**Dados de Teste:**
```json
{
    "momento": "teste-deploy",
    "ddd": "11",
    "celular": "999999999",
    "nome": "Teste Deploy",
    "email": "teste@imediatoseguros.com.br",
    "gclid": "teste-deploy-20251118",
    "erro": null
}
```

**Comandos:**
```powershell
# Testar endpoint
$testData = @{
    momento = "teste-deploy"
    ddd = "11"
    celular = "999999999"
    nome = "Teste Deploy"
    email = "teste@imediatoseguros.com.br"
    gclid = "teste-deploy-20251118"
    erro = $null
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php" -Method POST -Body $testData -ContentType "application/json" -UseBasicParsing

# Verificar resposta
$result = $response.Content | ConvertFrom-Json
if ($response.StatusCode -eq 200 -and $result.success -eq $true) {
    Write-Host "✅ Endpoint funcionando corretamente"
} else {
    Write-Host "❌ Endpoint retornou erro"
}
```

---

### **FASE 5: Verificação de Logs no Banco de Dados**

**Objetivo:** Verificar que logs são inseridos corretamente após correção

**Ações:**
1. Consultar logs de categoria `EMAIL` no banco de dados
2. Verificar que logs de sucesso são inseridos
3. Verificar que não há mais erros fatais relacionados a `getInstance()`

**Comandos:**
```powershell
# Consultar logs de EMAIL
$response = Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/TMP/query_logs_endpoint.php?limit=10&category=EMAIL" -UseBasicParsing
$logs = ($response.Content | ConvertFrom-Json).logs

# Verificar logs recentes
$logs | Select-Object -First 5 | ForEach-Object {
    Write-Host "[$($_.timestamp)] [$($_.level)] $($_.message)"
}
```

---

### **FASE 6: Teste Funcional Completo**

**Objetivo:** Testar fluxo completo de envio de email via modal WhatsApp

**Ações:**
1. Carregar página no browser
2. Preencher modal WhatsApp com dados de teste
3. Verificar que email é enviado
4. Verificar console do browser (não deve mostrar erro 500)
5. Verificar que logs são inseridos no banco

**Observação:** Este teste requer intervenção manual no browser.

---

## ⚠️ AVISOS IMPORTANTES

### **Cache Cloudflare**

⚠️ **OBRIGATÓRIO:** Após atualizar arquivo `.php` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.

**Aviso ao Usuário:**
```
⚠️ IMPORTANTE: Após atualizar arquivos no servidor, é necessário limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.
```

---

### **Ambiente de Trabalho**

✅ **PADRÃO:** Trabalhar apenas no ambiente de **DESENVOLVIMENTO** (DEV)
- **Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
- **Caminho:** `/var/www/html/dev/root/`

---

## 📊 CHECKLIST DE DEPLOY

- [ ] FASE 1: Backup criado no servidor
- [ ] FASE 2: Arquivo copiado para servidor
- [ ] FASE 3: Hash SHA256 verificado e coincide
- [ ] FASE 4: Endpoint testado e retorna HTTP 200
- [ ] FASE 5: Logs verificados no banco de dados
- [ ] FASE 6: Teste funcional completo realizado
- [ ] Aviso sobre cache Cloudflare enviado ao usuário

---

## 📋 RESUMO ESPERADO

**Após Deploy Bem-Sucedido:**

1. ✅ Arquivo `send_admin_notification_ses.php` atualizado no servidor
2. ✅ Hash SHA256 coincide (arquivo íntegro)
3. ✅ Endpoint retorna HTTP 200 (não mais 500)
4. ✅ Emails são enviados corretamente
5. ✅ Logs são inseridos no banco de dados
6. ✅ Console do browser não mostra mais erro

---

**Documento criado em:** 18/11/2025  
**Versão:** 1.0.0  
**Status:** ⏳ **AGUARDANDO EXECUÇÃO**

