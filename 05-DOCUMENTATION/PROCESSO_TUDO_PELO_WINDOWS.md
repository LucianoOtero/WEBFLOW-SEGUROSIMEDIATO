# 🎯 PROCESSO: TUDO PELO WINDOWS - 100% RASTREÁVEL

**Data:** 21/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **PROCESSO PROPOSTO**

---

## 🚀 PROPOSTA REVOLUCIONÁRIA

### **Regra Fundamental:**
> **"TODAS as configurações PHP-FPM e scripts SQL devem ser feitas no Windows primeiro e sempre subidas para servidor DEV. Eliminar SSHs manuais."**

---

## ✅ IMPACTO NA CAPACIDADE DE MAPEAMENTO

### **ANTES (Processo Atual):**
- ✅ Arquivos PHP/JS via scripts: **100%** rastreável
- ❌ Configurações PHP-FPM: **0%** rastreável (manual no servidor)
- ❌ Scripts SQL: **0%** rastreável (executados manualmente)
- ❌ Comandos SSH manuais: **0%** rastreável
- **Total: ~90% rastreável**

### **DEPOIS (Processo Proposto):**
- ✅ Arquivos PHP/JS via scripts: **100%** rastreável
- ✅ Configurações PHP-FPM via scripts: **100%** rastreável
- ✅ Scripts SQL via scripts: **100%** rastreável
- ✅ Sem SSHs manuais: **100%** rastreável
- **Total: ~100% rastreável** 🎉

---

## 📋 NOVO PROCESSO OBRIGATÓRIO

### **REGRA CRÍTICA #1: NUNCA Modificar Diretamente no Servidor**

**❌ PROIBIDO:**
- ❌ SSH manual para modificar PHP-FPM
- ❌ Executar SQL diretamente no servidor
- ❌ Modificar arquivos diretamente no servidor
- ❌ Comandos manuais via SSH

**✅ OBRIGATÓRIO:**
- ✅ Criar/modificar tudo no Windows primeiro
- ✅ Usar scripts para copiar para servidor DEV
- ✅ Usar scripts para executar SQL
- ✅ Usar scripts para aplicar configurações PHP-FPM

---

## 🔧 IMPLEMENTAÇÃO: SCRIPTS NECESSÁRIOS

### **1. Script para Replicar Configuração PHP-FPM**

**Arquivo:** `scripts/replicar-php-fpm-dev.ps1`

```powershell
# Script para replicar configuração PHP-FPM para DEV
# Versão: 1.0.0
# Uso: .\replicar-php-fpm-dev.ps1

param(
    [string]$Ambiente = "DEV"
)

$ErrorActionPreference = "Stop"

# Configurações
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$configLocal = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_www_conf_DEV.txt"

if ($Ambiente -eq "PROD") {
    $servidor = "root@157.180.36.223"
    $caminhoRemoto = "/etc/php/8.3/fpm/pool.d/prod.conf"
    $configLocal = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_prod_conf.txt"
} else {
    $servidor = "root@65.108.156.14"
    $caminhoRemoto = "/etc/php/8.3/fpm/pool.d/www.conf"
}

# Logging
$LOG_FILE = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_PHP_FPM_$(Get-Date -Format 'yyyyMMdd').log"

function Write-PHPFPMLog {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Write-Host $logEntry
    $logEntry | Out-File -FilePath $LOG_FILE -Append
}

Write-PHPFPMLog "INICIANDO: Replicação de configuração PHP-FPM para $Ambiente" "INFO"
Write-PHPFPMLog "Arquivo local: $configLocal" "INFO"
Write-PHPFPMLog "Servidor: $servidor" "INFO"
Write-PHPFPMLog "Caminho remoto: $caminhoRemoto" "INFO"

# Verificar se arquivo local existe
if (-not (Test-Path $configLocal)) {
    Write-PHPFPMLog "ERRO: Arquivo local não encontrado: $configLocal" "ERROR"
    exit 1
}

# Calcular hash local
$hashLocal = (Get-FileHash -Path $configLocal -Algorithm SHA256).Hash.ToUpper()
Write-PHPFPMLog "Hash local: $hashLocal" "INFO"

# Criar backup no servidor
$backupFile = "$caminhoRemoto.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Write-PHPFPMLog "Criando backup no servidor: $backupFile" "INFO"
$backupResult = ssh $servidor "cp $caminhoRemoto $backupFile 2>&1"
if ($LASTEXITCODE -ne 0) {
    Write-PHPFPMLog "AVISO: Não foi possível criar backup (arquivo pode não existir): $backupResult" "WARN"
} else {
    Write-PHPFPMLog "Backup criado com sucesso" "SUCCESS"
}

# Copiar arquivo para servidor
Write-PHPFPMLog "Copiando configuração para servidor..." "INFO"
$scpResult = scp $configLocal "${servidor}:${caminhoRemoto}" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-PHPFPMLog "ERRO ao copiar configuração: $scpResult" "ERROR"
    exit 1
}
Write-PHPFPMLog "Configuração copiada com sucesso" "SUCCESS"

# Verificar hash remoto
$hashRemoto = (ssh $servidor "sha256sum $caminhoRemoto | awk '{print `$1}'" 2>&1).Trim().ToUpper()
Write-PHPFPMLog "Hash remoto: $hashRemoto" "INFO"

if ($hashLocal -eq $hashRemoto) {
    Write-PHPFPMLog "Hash verificado: Arquivo íntegro" "SUCCESS"
} else {
    Write-PHPFPMLog "ERRO: Hash não corresponde! Integridade comprometida." "ERROR"
    exit 1
}

# Validar sintaxe PHP-FPM
Write-PHPFPMLog "Validando sintaxe PHP-FPM..." "INFO"
$validateResult = ssh $servidor "php-fpm8.3 -tt 2>&1"
if ($LASTEXITCODE -eq 0) {
    Write-PHPFPMLog "Sintaxe PHP-FPM válida" "SUCCESS"
} else {
    Write-PHPFPMLog "ERRO: Sintaxe PHP-FPM inválida!" "ERROR"
    Write-PHPFPMLog "Erro: $validateResult" "ERROR"
    Write-PHPFPMLog "Restaurando backup..." "WARN"
    ssh $servidor "cp $backupFile $caminhoRemoto"
    exit 1
}

# Recarregar PHP-FPM (sem restart completo)
Write-PHPFPMLog "Recarregando PHP-FPM..." "INFO"
$reloadResult = ssh $servidor "systemctl reload php8.3-fpm 2>&1"
if ($LASTEXITCODE -eq 0) {
    Write-PHPFPMLog "PHP-FPM recarregado com sucesso" "SUCCESS"
} else {
    Write-PHPFPMLog "ERRO ao recarregar PHP-FPM: $reloadResult" "ERROR"
    exit 1
}

# Verificar variáveis de ambiente aplicadas
Write-PHPFPMLog "Verificando variáveis de ambiente aplicadas..." "INFO"
$envVars = ssh $servidor "php-fpm8.3 -tt 2>&1 | grep 'env\[' | sort"
Write-PHPFPMLog "Variáveis de ambiente:" "INFO"
$envVars | ForEach-Object { Write-PHPFPMLog "  $_" "INFO" }

Write-PHPFPMLog "Replicação de configuração PHP-FPM concluída com SUCESSO" "SUCCESS"
```

---

### **2. Script para Executar SQL no Servidor DEV**

**Arquivo:** `scripts/executar-sql-dev.ps1`

```powershell
# Script para executar script SQL no servidor DEV
# Versão: 1.0.0
# Uso: .\executar-sql-dev.ps1 <arquivo.sql>

param(
    [Parameter(Mandatory=$true)]
    [string]$ArquivoSQL
)

$ErrorActionPreference = "Stop"

# Configurações
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$sqlLocal = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\$ArquivoSQL"
$servidor = "root@65.108.156.14"
$sqlRemoto = "/tmp/$ArquivoSQL"

# Logging
$LOG_FILE = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_SQL_$(Get-Date -Format 'yyyyMMdd').log"

function Write-SQLLog {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Write-Host $logEntry
    $logEntry | Out-File -FilePath $LOG_FILE -Append
}

Write-SQLLog "INICIANDO: Execução de script SQL no servidor DEV" "INFO"
Write-SQLLog "Arquivo SQL: $ArquivoSQL" "INFO"
Write-SQLLog "Arquivo local: $sqlLocal" "INFO"

# Verificar se arquivo local existe
if (-not (Test-Path $sqlLocal)) {
    Write-SQLLog "ERRO: Arquivo SQL não encontrado: $sqlLocal" "ERROR"
    exit 1
}

# Validar sintaxe SQL básica (verificar se é arquivo SQL válido)
$conteudo = Get-Content $sqlLocal -Raw
if ($conteudo -notmatch "(?i)(USE|CREATE|ALTER|INSERT|UPDATE|DELETE|SELECT|DROP)") {
    Write-SQLLog "AVISO: Arquivo pode não ser um script SQL válido" "WARN"
}

# Calcular hash local
$hashLocal = (Get-FileHash -Path $sqlLocal -Algorithm SHA256).Hash.ToUpper()
Write-SQLLog "Hash local: $hashLocal" "INFO"

# Copiar arquivo SQL para servidor
Write-SQLLog "Copiando script SQL para servidor..." "INFO"
$scpResult = scp $sqlLocal "${servidor}:${sqlRemoto}" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-SQLLog "ERRO ao copiar script SQL: $scpResult" "ERROR"
    exit 1
}
Write-SQLLog "Script SQL copiado com sucesso" "SUCCESS"

# Verificar hash remoto
$hashRemoto = (ssh $servidor "sha256sum $sqlRemoto | awk '{print `$1}'" 2>&1).Trim().ToUpper()
if ($hashLocal -eq $hashRemoto) {
    Write-SQLLog "Hash verificado: Arquivo íntegro" "SUCCESS"
} else {
    Write-SQLLog "ERRO: Hash não corresponde!" "ERROR"
    exit 1
}

# Executar script SQL
Write-SQLLog "Executando script SQL no servidor DEV..." "INFO"
Write-SQLLog "AVISO: Esta operação modificará o banco de dados DEV" "WARN"

# Obter credenciais do banco (do PHP-FPM ou variáveis de ambiente)
# Nota: Credenciais devem estar em variáveis de ambiente seguras
$dbHost = "localhost"  # Ajustar conforme necessário
$dbName = "rpa_logs_dev"  # Ajustar conforme necessário
$dbUser = "rpa_logger_dev"  # Ajustar conforme necessário
# Senha deve ser obtida de forma segura (não hardcoded)

Write-SQLLog "Conectando ao banco: $dbName" "INFO"
$sqlResult = ssh $servidor "mysql -h $dbHost -u $dbUser -p'[SENHA_DO_BANCO]' $dbName < $sqlRemoto 2>&1"
$sqlExitCode = $LASTEXITCODE

if ($sqlExitCode -eq 0) {
    Write-SQLLog "Script SQL executado com SUCESSO" "SUCCESS"
    Write-SQLLog "Resultado: $sqlResult" "INFO"
} else {
    Write-SQLLog "ERRO ao executar script SQL: Código $sqlExitCode" "ERROR"
    Write-SQLLog "Erro: $sqlResult" "ERROR"
    exit 1
}

# Limpar arquivo temporário no servidor
Write-SQLLog "Removendo arquivo temporário do servidor..." "INFO"
ssh $servidor "rm -f $sqlRemoto" | Out-Null

Write-SQLLog "Execução de script SQL concluída com SUCESSO" "SUCCESS"
```

---

### **3. Script de Consulta Unificada (Atualizado)**

**Arquivo:** `scripts/consultar-todas-alteracoes-dev.ps1`

```powershell
# Script para consultar TODAS as alterações em DEV desde última replicação PROD
# Versão: 1.0.0
# Uso: .\consultar-todas-alteracoes-dev.ps1

$ErrorActionPreference = "Stop"

$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$servidor = "root@65.108.156.14"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "CONSULTA UNIFICADA: Todas as Alterações DEV" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Arquivos PHP/JS copiados via scripts PowerShell
Write-Host "📄 ARQUIVOS PHP/JS COPIADOS VIA SCRIPTS:" -ForegroundColor Yellow
$logFiles = Get-ChildItem "$workspaceRoot\WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_SCP_*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 5
foreach ($logFile in $logFiles) {
    Write-Host "  Arquivo: $($logFile.Name)" -ForegroundColor Gray
    Get-Content $logFile.FullName | Select-String "SCP SUCESSO" | ForEach-Object {
        Write-Host "    $_" -ForegroundColor Green
    }
}
Write-Host ""

# 2. Configurações PHP-FPM aplicadas
Write-Host "⚙️ CONFIGURAÇÕES PHP-FPM APLICADAS:" -ForegroundColor Yellow
$phpfpmLogFiles = Get-ChildItem "$workspaceRoot\WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_PHP_FPM_*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 5
foreach ($logFile in $phpfpmLogFiles) {
    Write-Host "  Arquivo: $($logFile.Name)" -ForegroundColor Gray
    Get-Content $logFile.FullName | Select-String "Replicação.*concluída com SUCESSO" | ForEach-Object {
        Write-Host "    $_" -ForegroundColor Green
    }
}
Write-Host ""

# 3. Scripts SQL executados
Write-Host "🗄️ SCRIPTS SQL EXECUTADOS:" -ForegroundColor Yellow
$sqlLogFiles = Get-ChildItem "$workspaceRoot\WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_SQL_*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 5
foreach ($logFile in $sqlLogFiles) {
    Write-Host "  Arquivo: $($logFile.Name)" -ForegroundColor Gray
    Get-Content $logFile.FullName | Select-String "Script SQL executado com SUCESSO" | ForEach-Object {
        Write-Host "    $_" -ForegroundColor Green
    }
}
Write-Host ""

# 4. Mudanças detectadas no servidor (via auditd)
Write-Host "🔍 MUDANÇAS DETECTADAS NO SERVIDOR (auditd):" -ForegroundColor Yellow
$auditdResult = ssh $servidor "ausearch -k dev_file_changes --start today -i 2>&1 | head -20"
if ($auditdResult) {
    Write-Host $auditdResult -ForegroundColor Gray
} else {
    Write-Host "  Nenhuma mudança detectada hoje" -ForegroundColor Gray
}
Write-Host ""

# 5. Documentação manual (se houver)
Write-Host "📋 DOCUMENTAÇÃO MANUAL:" -ForegroundColor Yellow
$docFile = "$workspaceRoot\WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_*.md"
$docFiles = Get-ChildItem $docFile | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($docFiles) {
    Write-Host "  Documento: $($docFiles[0].Name)" -ForegroundColor Gray
    Write-Host "  Última atualização: $($docFiles[0].LastWriteTime)" -ForegroundColor Gray
} else {
    Write-Host "  Nenhum documento encontrado" -ForegroundColor Yellow
}
Write-Host ""

# 6. Gerar checklist de replicação
Write-Host "✅ CHECKLIST DE REPLICAÇÃO PARA PROD:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  [ ] Arquivos PHP copiados para PROD" -ForegroundColor Yellow
Write-Host "  [ ] Arquivos JavaScript copiados para PROD" -ForegroundColor Yellow
Write-Host "  [ ] Configuração PHP-FPM aplicada em PROD" -ForegroundColor Yellow
Write-Host "  [ ] Scripts SQL executados em PROD" -ForegroundColor Yellow
Write-Host "  [ ] Validação de hash SHA256" -ForegroundColor Yellow
Write-Host "  [ ] Validação de sintaxe PHP-FPM" -ForegroundColor Yellow
Write-Host "  [ ] Testes funcionais em PROD" -ForegroundColor Yellow
Write-Host ""
```

---

## 📋 REGRAS OBRIGATÓRIAS

### **REGRA #1: NUNCA Modificar Diretamente no Servidor**

**❌ PROIBIDO:**
```bash
# ❌ NÃO FAZER:
ssh root@servidor
nano /etc/php/8.3/fpm/pool.d/www.conf
# Modificar diretamente
```

**✅ OBRIGATÓRIO:**
```powershell
# ✅ FAZER:
# 1. Modificar arquivo localmente no Windows
# 2. Usar script para copiar
.\replicar-php-fpm-dev.ps1
```

---

### **REGRA #2: NUNCA Executar SQL Diretamente no Servidor**

**❌ PROIBIDO:**
```bash
# ❌ NÃO FAZER:
ssh root@servidor
mysql -u user -p database
# Executar SQL diretamente
```

**✅ OBRIGATÓRIO:**
```powershell
# ✅ FAZER:
# 1. Criar script SQL no Windows
# 2. Usar script para executar
.\executar-sql-dev.ps1 alterar_enum_level_adicionar_trace_dev.sql
```

---

### **REGRA #3: NUNCA Usar SSH Manual para Comandos**

**❌ PROIBIDO:**
```bash
# ❌ NÃO FAZER:
ssh root@servidor "comando qualquer"
```

**✅ OBRIGATÓRIO:**
```powershell
# ✅ FAZER:
# Criar script PowerShell que executa o comando e loga
.\executar-comando-dev.ps1 "comando"
```

---

## ✅ BENEFÍCIOS DO NOVO PROCESSO

### **1. 100% de Rastreabilidade**
- ✅ Todas as mudanças passam pelo Windows
- ✅ Todos os scripts logam suas ações
- ✅ Histórico completo e auditável

### **2. Versionamento Completo**
- ✅ Configurações PHP-FPM versionadas no Git
- ✅ Scripts SQL versionados no Git
- ✅ Histórico completo de mudanças

### **3. Replicação Automática**
- ✅ Script de consulta unificada lista tudo
- ✅ Checklist completo gerado automaticamente
- ✅ Processo de replicação simplificado

### **4. Segurança**
- ✅ Validação de hash em todas as operações
- ✅ Validação de sintaxe antes de aplicar
- ✅ Backups automáticos antes de mudanças

---

## 🎯 CONCLUSÃO

### **Com Este Processo:**

**✅ SERIA possível mapear 100% das mudanças:**
- ✅ Arquivos PHP/JS: **100%** rastreável
- ✅ Configurações PHP-FPM: **100%** rastreável
- ✅ Scripts SQL: **100%** rastreável
- ✅ Comandos executados: **100%** rastreável

**✅ Benefícios:**
- ✅ Histórico completo e auditável
- ✅ Replicação automática e confiável
- ✅ Processo padronizado e seguro
- ✅ Zero dependência de documentação manual

---

**Processo proposto para 100% de rastreabilidade através de scripts automatizados.**

