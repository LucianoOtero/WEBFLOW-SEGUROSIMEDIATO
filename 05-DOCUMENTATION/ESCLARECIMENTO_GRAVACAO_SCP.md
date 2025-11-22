# 🔍 ESCLARECIMENTO: Gravação de Comandos SCP

**Data:** 21/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **ESCLARECIMENTO COMPLETO**

---

## ❓ PERGUNTA

**"A gravação de sessão SSH gravaria todos os comandos SCPs, inclusive o resultado (sucesso / falha)?"**

---

## ✅ RESPOSTA DIRETA

**Depende da ferramenta e de como o SCP é executado:**

### **1. Gravação de Sessão SSH (tlog, script, asciinema):**

**❌ LIMITAÇÃO IMPORTANTE:**
- ✅ **Grava SCP se executado dentro de uma sessão SSH interativa**
- ❌ **NÃO grava SCP se executado diretamente do Windows (PowerShell)**

**Por quê?**
- Quando você executa `scp arquivo.php root@servidor:/destino/` do PowerShell, isso cria uma **conexão SSH separada** apenas para transferência
- Não é uma sessão SSH interativa, então `tlog`/`script` não capturam
- O comando é executado no Windows, não dentro de uma sessão SSH no servidor

**Exemplo do que NÃO seria gravado:**
```powershell
# PowerShell (Windows)
scp config.php root@65.108.156.14:/var/www/html/dev/root/
# ❌ Este comando NÃO aparece em sessão SSH gravada
```

**Exemplo do que SERIA gravado:**
```bash
# Dentro de sessão SSH já aberta
ssh root@65.108.156.14
# Agora dentro do servidor:
scp /tmp/arquivo.php /var/www/html/dev/root/
# ✅ Este comando SERIA gravado por tlog/script
```

---

### **2. Auditoria de Sistema (auditd):**

**✅ MELHOR OPÇÃO PARA SCP:**
- ✅ **Grava TODAS as execuções de SCP no servidor**
- ✅ **Grava arquivos copiados**
- ✅ **Grava resultado (sucesso/falha)**
- ✅ **Grava origem e destino**
- ✅ **Funciona mesmo quando SCP vem do Windows**

**Como funciona:**
- `auditd` monitora **chamadas de sistema** no Linux
- Quando SCP é executado (mesmo vindo do Windows), o servidor Linux recebe a conexão
- `auditd` registra a execução do processo SCP no servidor
- Registra todos os arquivos acessados/copiados

**Exemplo de log do auditd:**
```
type=SYSCALL msg=audit(1734825600.123:456): arch=c000003e syscall=59 
success=yes exit=0 a0=7ffd12345678 a1=7ffd12345679 a2=7ffd1234567a 
items=2 ppid=1234 pid=5678 auid=1000 uid=0 gid=0 euid=0 suid=0 
fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="scp" 
exe="/usr/bin/scp" key="scp_usage"

type=PATH msg=audit(1734825600.123:456): item=0 name="/var/www/html/dev/root/config.php" 
inode=12345 dev=08:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 
nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0

type=PATH msg=audit(1734825600.123:456): item=1 name="/var/www/html/dev/root/" 
inode=12346 dev=08:01 mode=040755 ouid=0 ogid=0 rdev=00:00 
nametype=PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
```

---

## 🎯 SOLUÇÃO COMPLETA PARA O PROJETO

### **Problema Identificado:**

No projeto atual, SCP é executado do **PowerShell (Windows)** para o servidor Linux:
```powershell
# scripts/replicar-php-prod.ps1
scp $arquivoLocal root@65.108.156.14:$caminhoRemoto
```

**Isso significa:**
- ❌ `tlog`/`script` **NÃO** gravariam esses comandos
- ✅ `auditd` **SIM** gravaria no servidor
- ⚠️ Mas não gravaria o comando completo executado do Windows

---

## ✅ SOLUÇÃO RECOMENDADA: COMBINAÇÃO DE FERRAMENTAS

### **1. auditd no Servidor (Para SCP):**
- ✅ Grava todas as execuções de SCP no servidor
- ✅ Grava arquivos copiados
- ✅ Grava resultado (sucesso/falha via código de saída)
- ✅ Grava origem e destino

### **2. Logging Integrado nos Scripts PowerShell:**
- ✅ Gravar comando SCP antes de executar
- ✅ Gravar resultado após execução
- ✅ Gravar hash do arquivo
- ✅ Gravar timestamp

### **3. Gravação de Sessão SSH (Para Comandos Interativos):**
- ✅ Gravar quando você abre sessão SSH manualmente
- ✅ Gravar comandos executados dentro da sessão
- ✅ Útil para troubleshooting manual

---

## 📋 IMPLEMENTAÇÃO PRÁTICA

### **FASE 1: auditd para SCP (Servidor)**

**Configurar auditd para monitorar SCP:**
```bash
# No servidor DEV/PROD
ssh root@65.108.156.14

# Instalar auditd
apt install auditd

# Adicionar regra para SCP
cat >> /etc/audit/rules.d/scp-audit.rules << 'EOF'
# Monitorar execução de SCP
-a always,exit -F arch=b64 -S execve -F path=/usr/bin/scp -F key=scp_usage
-a always,exit -F arch=b32 -S execve -F path=/usr/bin/scp -F key=scp_usage

# Monitorar acesso a diretórios de desenvolvimento
-w /var/www/html/dev/root -p rwxa -k dev_file_changes
-w /var/www/html/prod/root -p rwxa -k prod_file_changes
EOF

# Reiniciar auditd
systemctl restart auditd
systemctl enable auditd
```

**Consultar logs de SCP:**
```bash
# Ver todas as execuções de SCP
ausearch -k scp_usage -i

# Ver SCP com resultado de sucesso
ausearch -k scp_usage -i | grep "success=yes"

# Ver SCP com resultado de falha
ausearch -k scp_usage -i | grep "success=no"

# Ver arquivos copiados via SCP
ausearch -k scp_usage -i | grep "nametype=CREATE"

# Exportar para arquivo
ausearch -k scp_usage -i > /var/log/scp_audit_$(date +%Y%m%d).log
```

---

### **FASE 2: Logging Integrado nos Scripts PowerShell**

**Atualizar scripts para logar SCP:**
```powershell
# Adicionar no início do script
$LOG_FILE = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_SCP_$(Get-Date -Format 'yyyyMMdd').log"

function Write-SCPLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Write-Host $logEntry
    $logEntry | Out-File -FilePath $LOG_FILE -Append
}

# Antes de executar SCP
Write-SCPLog "INICIANDO SCP: $arquivoLocal -> root@$servidor:$caminhoRemoto" "INFO"
Write-SCPLog "Hash local: $hashLocal" "INFO"

# Executar SCP
$scpResult = scp $arquivoLocal "root@${servidor}:${caminhoRemoto}" 2>&1
$scpExitCode = $LASTEXITCODE

# Após executar SCP
if ($scpExitCode -eq 0) {
    Write-SCPLog "SCP SUCESSO: Arquivo copiado com sucesso" "SUCCESS"
    Write-SCPLog "Verificando hash remoto..." "INFO"
    
    # Verificar hash remoto
    $hashRemoto = (ssh root@$servidor "sha256sum $caminhoRemoto | awk '{print `$1}'" 2>&1).Trim()
    Write-SCPLog "Hash remoto: $hashRemoto" "INFO"
    
    if ($hashLocal -eq $hashRemoto) {
        Write-SCPLog "HASH VERIFICADO: Arquivo íntegro" "SUCCESS"
    } else {
        Write-SCPLog "HASH DIVERGENTE: Arquivo pode estar corrompido" "ERROR"
    }
} else {
    Write-SCPLog "SCP FALHOU: Código de saída $scpExitCode" "ERROR"
    Write-SCPLog "Erro: $scpResult" "ERROR"
}
```

---

### **FASE 3: Script de Consulta Unificada**

**Criar script para consultar logs de SCP:**
```powershell
# scripts/consultar-logs-scp.ps1
param(
    [string]$Data = (Get-Date -Format "yyyyMMdd"),
    [string]$Servidor = "65.108.156.14"
)

Write-Host "Consultando logs de SCP para $Data..." -ForegroundColor Cyan

# Logs locais (PowerShell)
$logLocal = "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_SCP_$Data.log"
if (Test-Path $logLocal) {
    Write-Host "`n📄 LOGS LOCAIS (PowerShell):" -ForegroundColor Yellow
    Get-Content $logLocal | Select-String "SCP"
} else {
    Write-Host "⚠️ Log local não encontrado: $logLocal" -ForegroundColor Yellow
}

# Logs do servidor (auditd)
Write-Host "`n📄 LOGS DO SERVIDOR (auditd):" -ForegroundColor Yellow
ssh root@$Servidor "ausearch -k scp_usage -i --start today | grep -E '(comm=|nametype=CREATE|success=)'"
```

---

## 📊 COMPARAÇÃO DAS FERRAMENTAS

| Ferramenta | Grava SCP do Windows? | Grava Resultado? | Grava Arquivos? | Grava Comando Completo? |
|------------|---------------------|------------------|-----------------|------------------------|
| **tlog** | ❌ Não | ⚠️ Parcial | ❌ Não | ❌ Não |
| **script** | ❌ Não | ⚠️ Parcial | ❌ Não | ❌ Não |
| **asciinema** | ❌ Não | ⚠️ Parcial | ❌ Não | ❌ Não |
| **auditd** | ✅ Sim | ✅ Sim | ✅ Sim | ⚠️ Parcial |
| **Logging PowerShell** | ✅ Sim | ✅ Sim | ✅ Sim | ✅ Sim |

---

## ✅ CONCLUSÃO

### **Para Gravar SCP Executado do Windows:**

**✅ MELHOR SOLUÇÃO: Combinação de auditd + Logging PowerShell**

1. **auditd no servidor:**
   - Grava execução de SCP no servidor
   - Grava arquivos copiados
   - Grava resultado (sucesso/falha)
   - Grava origem e destino

2. **Logging nos scripts PowerShell:**
   - Grava comando completo antes de executar
   - Grava resultado após execução
   - Grava hash do arquivo
   - Grava timestamp

3. **Gravação de sessão SSH (opcional):**
   - Útil para comandos executados dentro de sessão SSH
   - Não captura SCP executado do Windows diretamente

---

## 🎯 RECOMENDAÇÃO FINAL

**Para o projeto atual (SCP do PowerShell para servidor Linux):**

✅ **Implementar:**
1. **auditd no servidor** - Para gravar execuções de SCP no servidor
2. **Logging integrado nos scripts PowerShell** - Para gravar comandos e resultados do lado do Windows
3. **Script de consulta unificada** - Para visualizar todos os logs juntos

**Isso garantirá:**
- ✅ Todos os comandos SCP gravados
- ✅ Todos os resultados (sucesso/falha) gravados
- ✅ Todos os arquivos copiados rastreados
- ✅ Histórico completo e auditável

---

**Esclarecimento completo sobre gravação de comandos SCP.**

