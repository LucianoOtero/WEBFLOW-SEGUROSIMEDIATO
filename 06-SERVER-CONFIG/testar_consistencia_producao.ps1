# ============================================
# SCRIPT: TESTAR CONSISTÊNCIA DO AMBIENTE DE PRODUÇÃO
# ============================================
# 
# Este script verifica a consistência do ambiente de produção,
# validando arquivos, variáveis de ambiente, configurações e serviços.
# 
# Objetivo: Garantir que o ambiente de produção está configurado
# corretamente e funcionando como esperado.
#
# Data: 14/11/2025
# ============================================

param(
    [string]$ProdServer = "root@157.180.36.223",
    [string]$ProdDir = "/var/www/html/prod/root",
    [string]$ProdWindowsDir = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION",
    [string]$OutputFile = "relatorio_consistencia_producao_$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
)

# Cores para output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Função para executar comando SSH
function Invoke-SSHCommand {
    param(
        [string]$Server,
        [string]$Command
    )
    try {
        $result = ssh $Server $Command 2>&1
        return $result
    } catch {
        Write-ColorOutput "❌ Erro ao executar comando SSH: $_" "Red"
        return $null
    }
}

# Função para calcular hash SHA256 via SSH
function Get-RemoteFileHash {
    param(
        [string]$Server,
        [string]$FilePath
    )
    $command = "sha256sum '$FilePath' 2>/dev/null | cut -d' ' -f1"
    $hash = Invoke-SSHCommand -Server $Server -Command $command
    if ($hash) {
        return $hash.Trim().ToUpper()
    }
    return $null
}

# Função para calcular hash SHA256 local
function Get-LocalFileHash {
    param(
        [string]$FilePath
    )
    if (Test-Path $FilePath) {
        $hash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash.ToUpper()
        return $hash
    }
    return $null
}

# Função para verificar se arquivo existe remotamente
function Test-RemoteFile {
    param(
        [string]$Server,
        [string]$FilePath
    )
    $command = "test -f '$FilePath' && echo 'EXISTS' || echo 'NOT_EXISTS'"
    $result = Invoke-SSHCommand -Server $Server -Command $command
    return ($result -match "EXISTS")
}

# Função para obter permissões de arquivo remoto
function Get-RemoteFilePermissions {
    param(
        [string]$Server,
        [string]$FilePath
    )
    $command = "stat -c '%a %U:%G' '$FilePath' 2>/dev/null"
    $perms = Invoke-SSHCommand -Server $Server -Command $command
    return $perms.Trim()
}

# Função para verificar variável de ambiente no PHP-FPM
function Get-PHPFPMEnvVar {
    param(
        [string]$Server,
        [string]$VarName
    )
    $command = "grep '^env\[$VarName\]' /etc/php/8.3/fpm/pool.d/www.conf 2>/dev/null | sed 's/.*= *//'"
    $value = Invoke-SSHCommand -Server $Server -Command $command
    if ($value) {
        return $value.Trim()
    }
    return $null
}

# Função para verificar serviço
function Test-ServiceStatus {
    param(
        [string]$Server,
        [string]$ServiceName
    )
    $command = "systemctl is-active --quiet $ServiceName && echo 'ACTIVE' || echo 'INACTIVE'"
    $result = Invoke-SSHCommand -Server $Server -Command $command
    return ($result -match "ACTIVE")
}

# Função para verificar certificado SSL
function Test-SSLCertificate {
    param(
        [string]$Server,
        [string]$Domain
    )
    $command = "test -d '/etc/letsencrypt/live/$Domain' && openssl x509 -in /etc/letsencrypt/live/$Domain/cert.pem -noout -checkend 86400 2>/dev/null && echo 'VALID' || echo 'INVALID'"
    $result = Invoke-SSHCommand -Server $Server -Command $command
    return ($result -match "VALID")
}

# Função para testar acesso HTTPS
function Test-HTTPSAccess {
    param(
        [string]$Url
    )
    try {
        $response = Invoke-WebRequest -Uri $Url -Method Head -TimeoutSec 10 -UseBasicParsing -ErrorAction SilentlyContinue
        return ($response.StatusCode -eq 200)
    } catch {
        return $false
    }
}

# Função auxiliar para obter configuração Nginx
function Get-NginxConfig {
    param(
        [string]$Server,
        [string]$Domain
    )
    $configFile = "/etc/nginx/sites-available/$Domain"
    $command = "test -f '$configFile' && cat '$configFile' || echo 'FILE_NOT_FOUND'"
    $config = Invoke-SSHCommand -Server $Server -Command $command
    return $config
}

# Valores esperados
$expectedEnvVars = @{
    "APP_BASE_DIR" = "/var/www/html/prod/root"
    "APP_BASE_URL" = "https://prod.bssegurosimediato.com.br"
    "PHP_ENV" = "production"
    "APP_CORS_ORIGINS" = "https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br"
    "ESPOCRM_URL" = "https://flyingdonkeys.com.br"
    "LOG_DB_NAME" = "rpa_logs_prod"
    "LOG_DB_USER" = "rpa_logger_prod"
    "LOG_DIR" = "/var/log/webflow-segurosimediato"
}

$jsFiles = @("FooterCodeSiteDefinitivoCompleto.js", "MODAL_WHATSAPP_DEFINITIVO.js", "webflow_injection_limpo.js")
$phpFiles = @(
    "add_flyingdonkeys.php",
    "add_webflow_octa.php",
    "config.php",
    "config_env.js.php",
    "class.php",
    "ProfessionalLogger.php",
    "log_endpoint.php",
    "send_email_notification_endpoint.php",
    "send_admin_notification_ses.php",
    "cpf-validate.php",
    "placa-validate.php",
    "email_template_loader.php",
    "aws_ses_config.php"
)
$emailTemplates = @("template_modal.php", "template_primeiro_contato.php", "template_logging.php")

# Iniciar relatório
$report = @"
# 📊 RELATÓRIO: CONSISTÊNCIA DO AMBIENTE DE PRODUÇÃO

**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Servidor PROD:** $ProdServer  
**Diretório PROD:** $ProdDir  
**Status:** 🔍 **VERIFICAÇÃO EM ANDAMENTO**

---

## 🎯 OBJETIVO

Verificar a consistência do ambiente de produção, validando arquivos, variáveis de ambiente, configurações e serviços.

---

"@

Write-ColorOutput "`n============================================" "Cyan"
Write-ColorOutput "🔍 TESTE DE CONSISTÊNCIA - AMBIENTE PROD" "Cyan"
Write-ColorOutput "============================================`n" "Cyan"

# Contadores
$totalChecks = 0
$passedChecks = 0
$failedChecks = 0
$warnings = 0

# ============================================
# 1. VERIFICAÇÃO DE ARQUIVOS
# ============================================

Write-ColorOutput "📁 1. Verificando arquivos..." "Yellow"

$fileVerification = @"
## 📁 1. VERIFICAÇÃO DE ARQUIVOS

### **Arquivos JavaScript (.js)**

| Arquivo | Status Servidor | Status Local | Hash Servidor | Hash Local | Consistência |
|---------|----------------|--------------|---------------|------------|--------------|
"@

$missingFiles = @()
$differentFiles = @()
$identicalFiles = @()

foreach ($file in $jsFiles) {
    $totalChecks++
    $serverPath = "$ProdDir/$file"
    $localPath = "$ProdWindowsDir/$file"
    
    $serverExists = Test-RemoteFile -Server $ProdServer -FilePath $serverPath
    $localExists = Test-Path $localPath
    
    if (-not $serverExists) {
        Write-ColorOutput "  ❌ Arquivo não encontrado no servidor: $file" "Red"
        $fileVerification += "`n| $file | ❌ **FALTANDO** | $(if ($localExists) { '✅ Existe' } else { '❌ Não existe' }) | - | $(if ($localExists) { (Get-LocalFileHash -FilePath $localPath) } else { '-' }) | 🔴 **FALTANDO NO SERVIDOR** |"
        $missingFiles += $file
        $failedChecks++
    } elseif (-not $localExists) {
        Write-ColorOutput "  ⚠️  Arquivo não encontrado localmente: $file" "Yellow"
        $serverHash = Get-RemoteFileHash -Server $ProdServer -FilePath $serverPath
        $fileVerification += "`n| $file | ✅ Existe | ❌ Não existe | $serverHash | - | ⚠️ **FALTANDO LOCALMENTE** |"
        $warnings++
    } else {
        $serverHash = Get-RemoteFileHash -Server $ProdServer -FilePath $serverPath
        $localHash = Get-LocalFileHash -FilePath $localPath
        
        if ($serverHash -eq $localHash) {
            Write-ColorOutput "  ✅ $file - Consistente" "Green"
            $fileVerification += "`n| $file | ✅ Existe | ✅ Existe | $serverHash | $localHash | ✅ **CONSISTENTE** |"
            $identicalFiles += $file
            $passedChecks++
        } else {
            Write-ColorOutput "  ⚠️  $file - Inconsistente (hashes diferentes)" "Yellow"
            $fileVerification += "`n| $file | ✅ Existe | ✅ Existe | $serverHash | $localHash | ⚠️ **INCONSISTENTE** |"
            $differentFiles += $file
            $warnings++
        }
    }
}

$fileVerification += "`n`n### **Arquivos PHP (.php)**`n`n| Arquivo | Status Servidor | Status Local | Hash Servidor | Hash Local | Consistência |`n|---------|----------------|--------------|---------------|------------|--------------|"

foreach ($file in $phpFiles) {
    $totalChecks++
    $serverPath = "$ProdDir/$file"
    $localPath = "$ProdWindowsDir/$file"
    
    $serverExists = Test-RemoteFile -Server $ProdServer -FilePath $serverPath
    $localExists = Test-Path $localPath
    
    if (-not $serverExists) {
        Write-ColorOutput "  ❌ Arquivo não encontrado no servidor: $file" "Red"
        $fileVerification += "`n| $file | ❌ **FALTANDO** | $(if ($localExists) { '✅ Existe' } else { '❌ Não existe' }) | - | $(if ($localExists) { (Get-LocalFileHash -FilePath $localPath) } else { '-' }) | 🔴 **FALTANDO NO SERVIDOR** |"
        $missingFiles += $file
        $failedChecks++
    } elseif (-not $localExists) {
        Write-ColorOutput "  ⚠️  Arquivo não encontrado localmente: $file" "Yellow"
        $serverHash = Get-RemoteFileHash -Server $ProdServer -FilePath $serverPath
        $fileVerification += "`n| $file | ✅ Existe | ❌ Não existe | $serverHash | - | ⚠️ **FALTANDO LOCALMENTE** |"
        $warnings++
    } else {
        $serverHash = Get-RemoteFileHash -Server $ProdServer -FilePath $serverPath
        $localHash = Get-LocalFileHash -FilePath $localPath
        
        if ($serverHash -eq $localHash) {
            Write-ColorOutput "  ✅ $file - Consistente" "Green"
            $fileVerification += "`n| $file | ✅ Existe | ✅ Existe | $serverHash | $localHash | ✅ **CONSISTENTE** |"
            $identicalFiles += $file
            $passedChecks++
        } else {
            Write-ColorOutput "  ⚠️  $file - Inconsistente (hashes diferentes)" "Yellow"
            $fileVerification += "`n| $file | ✅ Existe | ✅ Existe | $serverHash | $localHash | ⚠️ **INCONSISTENTE** |"
            $differentFiles += $file
            $warnings++
        }
    }
}

$fileVerification += "`n`n### **Templates de Email**`n`n| Arquivo | Status Servidor | Status Local | Hash Servidor | Hash Local | Consistência |`n|---------|----------------|--------------|---------------|------------|--------------|"

foreach ($template in $emailTemplates) {
    $totalChecks++
    $serverPath = "$ProdDir/email_templates/$template"
    $localPath = "$ProdWindowsDir/email_templates/$template"
    
    $serverExists = Test-RemoteFile -Server $ProdServer -FilePath $serverPath
    $localExists = Test-Path $localPath
    
    if (-not $serverExists) {
        Write-ColorOutput "  ❌ Template não encontrado no servidor: $template" "Red"
        $fileVerification += "`n| $template | ❌ **FALTANDO** | $(if ($localExists) { '✅ Existe' } else { '❌ Não existe' }) | - | $(if ($localExists) { (Get-LocalFileHash -FilePath $localPath) } else { '-' }) | 🔴 **FALTANDO NO SERVIDOR** |"
        $missingFiles += "email_templates/$template"
        $failedChecks++
    } elseif (-not $localExists) {
        Write-ColorOutput "  ⚠️  Template não encontrado localmente: $template" "Yellow"
        $serverHash = Get-RemoteFileHash -Server $ProdServer -FilePath $serverPath
        $fileVerification += "`n| $template | ✅ Existe | ❌ Não existe | $serverHash | - | ⚠️ **FALTANDO LOCALMENTE** |"
        $warnings++
    } else {
        $serverHash = Get-RemoteFileHash -Server $ProdServer -FilePath $serverPath
        $localHash = Get-LocalFileHash -FilePath $localPath
        
        if ($serverHash -eq $localHash) {
            Write-ColorOutput "  ✅ $template - Consistente" "Green"
            $fileVerification += "`n| $template | ✅ Existe | ✅ Existe | $serverHash | $localHash | ✅ **CONSISTENTE** |"
            $identicalFiles += "email_templates/$template"
            $passedChecks++
        } else {
            Write-ColorOutput "  ⚠️  $template - Inconsistente (hashes diferentes)" "Yellow"
            $fileVerification += "`n| $template | ✅ Existe | ✅ Existe | $serverHash | $localHash | ⚠️ **INCONSISTENTE** |"
            $differentFiles += "email_templates/$template"
            $warnings++
        }
    }
}

$report += $fileVerification

# ============================================
# 2. VERIFICAÇÃO DE VARIÁVEIS DE AMBIENTE
# ============================================

Write-ColorOutput "`n🔧 2. Verificando variáveis de ambiente..." "Yellow"

$envVerification = @"

---

## 🔧 2. VARIÁVEIS DE AMBIENTE PHP-FPM

| Variável | Valor Esperado | Valor Atual | Status |
|----------|---------------|-------------|--------|
"@

$envIssues = @()
$envCorrect = @()

foreach ($var in $expectedEnvVars.Keys) {
    $totalChecks++
    $expectedValue = $expectedEnvVars[$var]
    $actualValue = Get-PHPFPMEnvVar -Server $ProdServer -VarName $var
    
    if (-not $actualValue) {
        Write-ColorOutput "  ❌ Variável não encontrada: $var" "Red"
        $envVerification += "`n| $var | $expectedValue | ❌ **FALTANDO** | 🔴 **FALTANDO** |"
        $envIssues += $var
        $failedChecks++
    } elseif ($actualValue -eq $expectedValue) {
        Write-ColorOutput "  ✅ $var - Correto" "Green"
        $envVerification += "`n| $var | $expectedValue | $actualValue | ✅ **CORRETO** |"
        $envCorrect += $var
        $passedChecks++
    } else {
        Write-ColorOutput "  ⚠️  $var - Incorreto (esperado: $expectedValue, atual: $actualValue)" "Yellow"
        $envVerification += "`n| $var | $expectedValue | $actualValue | ⚠️ **INCORRETO** |"
        $envIssues += $var
        $warnings++
    }
}

# Verificar secret keys (apenas se existem, não validar valor)
$secretKeys = @("WEBFLOW_SECRET_FLYINGDONKEYS", "WEBFLOW_SECRET_OCTADESK")
foreach ($key in $secretKeys) {
    $totalChecks++
    $value = Get-PHPFPMEnvVar -Server $ProdServer -VarName $key
    if ($value) {
        Write-ColorOutput "  ✅ $key - Definida" "Green"
        $envVerification += "`n| $key | (definida) | $($value.Substring(0, [Math]::Min(20, $value.Length)))... | ✅ **DEFINIDA** |"
        $envCorrect += $key
        $passedChecks++
    } else {
        Write-ColorOutput "  ⚠️  $key - Não definida" "Yellow"
        $envVerification += "`n| $key | (deve estar definida) | ❌ **FALTANDO** | ⚠️ **FALTANDO** |"
        $envIssues += $key
        $warnings++
    }
}

$report += $envVerification

# ============================================
# 3. VERIFICAÇÃO DE CONFIGURAÇÃO NGINX
# ============================================

Write-ColorOutput "`n🌐 3. Verificando configuração Nginx..." "Yellow"

$nginxConfig = Get-NginxConfig -Server $ProdServer -Domain "prod.bssegurosimediato.com.br"
$nginxExists = ($nginxConfig -notmatch "FILE_NOT_FOUND")

$nginxVerification = @"

---

## 🌐 3. CONFIGURAÇÃO NGINX

| Item | Status | Detalhes |
|------|--------|----------|
| Arquivo de configuração | $(if ($nginxExists) { '✅ Existe' } else { '❌ Não encontrado' }) | `/etc/nginx/sites-available/prod.bssegurosimediato.com.br` |
"@

$totalChecks++
if ($nginxExists) {
    $passedChecks++
    Write-ColorOutput "  ✅ Configuração Nginx existe" "Green"
    
    # Verificar server_name
    $serverName = Invoke-SSHCommand -Server $ProdServer -Command "grep 'server_name' /etc/nginx/sites-available/prod.bssegurosimediato.com.br | head -1"
    if ($serverName -match "prod.bssegurosimediato.com.br") {
        $nginxVerification += "`n| server_name | ✅ Correto | `prod.bssegurosimediato.com.br` |"
        $passedChecks++
    } else {
        $nginxVerification += "`n| server_name | ⚠️ Verificar | $serverName |"
        $warnings++
    }
    $totalChecks++
    
    # Verificar document root
    $docRoot = Invoke-SSHCommand -Server $ProdServer -Command "grep 'root' /etc/nginx/sites-available/prod.bssegurosimediato.com.br | grep -v '#' | head -1"
    if ($docRoot -match "/var/www/html/prod/root") {
        $nginxVerification += "`n| document root | ✅ Correto | `/var/www/html/prod/root` |"
        $passedChecks++
    } else {
        $nginxVerification += "`n| document root | ⚠️ Verificar | $docRoot |"
        $warnings++
    }
    $totalChecks++
} else {
    $failedChecks++
    Write-ColorOutput "  ❌ Configuração Nginx não encontrada" "Red"
}

$report += $nginxVerification

# ============================================
# 4. VERIFICAÇÃO DE CERTIFICADO SSL
# ============================================

Write-ColorOutput "`n🔒 4. Verificando certificado SSL..." "Yellow"

$sslValid = Test-SSLCertificate -Server $ProdServer -Domain "prod.bssegurosimediato.com.br"
$sslExists = (Invoke-SSHCommand -Server $ProdServer -Command "test -d '/etc/letsencrypt/live/prod.bssegurosimediato.com.br' && echo 'EXISTS' || echo 'NOT_EXISTS'") -match "EXISTS"

$sslVerification = @"

---

## 🔒 4. CERTIFICADO SSL

| Item | Status |
|------|--------|
| Certificado existe | $(if ($sslExists) { '✅ Sim' } else { '❌ Não' }) |
| Certificado válido | $(if ($sslValid) { '✅ Sim' } else { '⚠️ Verificar' }) |
"@

$totalChecks++
if ($sslExists) {
    $passedChecks++
} else {
    $failedChecks++
}

$totalChecks++
if ($sslValid) {
    $passedChecks++
} else {
    $warnings++
}

$report += $sslVerification

# ============================================
# 5. VERIFICAÇÃO DE SERVIÇOS
# ============================================

Write-ColorOutput "`n⚙️ 5. Verificando serviços..." "Yellow"

$nginxActive = Test-ServiceStatus -Server $ProdServer -ServiceName "nginx"
$phpFpmActive = Test-ServiceStatus -Server $ProdServer -ServiceName "php8.3-fpm"

$serviceVerification = @"

---

## ⚙️ 5. SERVIÇOS

| Serviço | Status |
|---------|--------|
| Nginx | $(if ($nginxActive) { '✅ Ativo' } else { '❌ Inativo' }) |
| PHP-FPM 8.3 | $(if ($phpFpmActive) { '✅ Ativo' } else { '❌ Inativo' }) |
"@

$totalChecks++
if ($nginxActive) {
    $passedChecks++
} else {
    $failedChecks++
}

$totalChecks++
if ($phpFpmActive) {
    $passedChecks++
} else {
    $failedChecks++
}

$report += $serviceVerification

# ============================================
# 6. VERIFICAÇÃO DE PERMISSÕES
# ============================================

Write-ColorOutput "`n🔐 6. Verificando permissões..." "Yellow"

$permVerification = @"

---

## 🔐 6. PERMISSÕES DE ARQUIVOS

| Arquivo | Permissões | Proprietário | Status |
|---------|-----------|--------------|--------|
"@

# Verificar permissões de alguns arquivos principais
$sampleFiles = @("config.php", "FooterCodeSiteDefinitivoCompleto.js", "add_flyingdonkeys.php")
foreach ($file in $sampleFiles) {
    $totalChecks++
    $filePath = "$ProdDir/$file"
    $perms = Get-RemoteFilePermissions -Server $ProdServer -FilePath $filePath
    
    if ($perms) {
        $permParts = $perms -split ' '
        $permValue = $permParts[0]
        $owner = $permParts[1]
        
        if ($owner -eq "www-data:www-data") {
            Write-ColorOutput "  ✅ $file - Permissões corretas: $perms" "Green"
            $permVerification += "`n| $file | $permValue | $owner | ✅ **CORRETO** |"
            $passedChecks++
        } else {
            Write-ColorOutput "  ⚠️  $file - Proprietário incorreto: $perms" "Yellow"
            $permVerification += "`n| $file | $permValue | $owner | ⚠️ **INCORRETO** |"
            $warnings++
        }
    } else {
        Write-ColorOutput "  ⚠️  $file - Não foi possível verificar permissões" "Yellow"
        $permVerification += "`n| $file | - | - | ⚠️ **NÃO VERIFICADO** |"
        $warnings++
    }
}

$report += $permVerification

# ============================================
# 7. VERIFICAÇÃO DE ESTRUTURA DE DIRETÓRIOS
# ============================================

Write-ColorOutput "`n📂 7. Verificando estrutura de diretórios..." "Yellow"

$dirVerification = @"

---

## 📂 7. ESTRUTURA DE DIRETÓRIOS

| Diretório | Status |
|----------|--------|
"@

$expectedDirs = @(
    "/var/www/html/prod/root",
    "/var/www/html/prod/root/email_templates",
    "/var/log/webflow-segurosimediato"
)

foreach ($dir in $expectedDirs) {
    $totalChecks++
    $command = "test -d '$dir' && echo 'EXISTS' || echo 'NOT_EXISTS'"
    $result = Invoke-SSHCommand -Server $ProdServer -Command $command
    $exists = ($result -match "EXISTS")
    
    if ($exists) {
        Write-ColorOutput "  ✅ Diretório existe: $dir" "Green"
        $dirVerification += "`n| $dir | ✅ **EXISTE** |"
        $passedChecks++
    } else {
        Write-ColorOutput "  ⚠️  Diretório não existe: $dir" "Yellow"
        $dirVerification += "`n| $dir | ⚠️ **NÃO EXISTE** |"
        $warnings++
    }
}

$report += $dirVerification

# ============================================
# 8. TESTE DE ACESSO HTTPS
# ============================================

Write-ColorOutput "`n🌐 8. Testando acesso HTTPS..." "Yellow"

$httpsVerification = @"

---

## 🌐 8. TESTE DE ACESSO HTTPS

| URL | Status | Detalhes |
|-----|--------|----------|
"@

$testUrls = @(
    "https://prod.bssegurosimediato.com.br",
    "https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js",
    "https://prod.bssegurosimediato.com.br/config.php"
)

foreach ($url in $testUrls) {
    $totalChecks++
    $accessible = Test-HTTPSAccess -Url $url
    
    if ($accessible) {
        Write-ColorOutput "  ✅ Acesso OK: $url" "Green"
        $httpsVerification += "`n| $url | ✅ **ACESSÍVEL** | HTTP 200 OK |"
        $passedChecks++
    } else {
        Write-ColorOutput "  ❌ Acesso falhou: $url" "Red"
        $httpsVerification += "`n| $url | ❌ **NÃO ACESSÍVEL** | Erro ao acessar |"
        $failedChecks++
    }
}

$report += $httpsVerification

# ============================================
# RESUMO E RECOMENDAÇÕES
# ============================================

# Construir strings de recomendação antes do here-string
$recommendation1 = if ($missingFiles.Count -gt 0) {
    $fileList = $missingFiles | ForEach-Object { "- $_" } | Out-String
    "1. **Copiar arquivos faltantes para servidor:**`n   $fileList"
} else {
    "1. OK - Nenhum arquivo faltando"
}

$recommendation2 = if ($differentFiles.Count -gt 0) {
    $fileList = $differentFiles | ForEach-Object { "- $_" } | Out-String
    "2. **Atualizar arquivos inconsistentes:**`n   $fileList"
} else {
    "2. OK - Nenhum arquivo precisa ser atualizado"
}

$recommendation3 = if ($envIssues.Count -gt 0) {
    $issueList = $envIssues | ForEach-Object { "- $_" } | Out-String
    "3. **Corrigir variáveis de ambiente:**`n   $issueList"
} else {
    "3. OK - Todas as variáveis estão corretas"
}

$recommendation4 = if (-not $nginxActive -or -not $phpFpmActive) {
    $services = @()
    if (-not $nginxActive) { $services += "- Nginx`n   " }
    if (-not $phpFpmActive) { $services += "- PHP-FPM`n   " }
    "4. **Reiniciar serviços inativos:**`n   $($services -join '')"
} else {
    "4. OK - Todos os serviços estão ativos"
}

$summary = @"

---

## 📊 RESUMO DA VERIFICAÇÃO

### **Estatísticas**

| Categoria | Total | ✅ Passou | ⚠️ Avisos | ❌ Falhou |
|-----------|-------|-----------|-----------|-----------|
| **TOTAL** | **$totalChecks** | **$passedChecks** | **$warnings** | **$failedChecks** |

### **Status Geral**

$(
    if ($failedChecks -eq 0 -and $warnings -eq 0) {
        "✅ **AMBIENTE CONSISTENTE** - Todas as verificações passaram"
    } elseif ($failedChecks -eq 0) {
        "⚠️ **AMBIENTE PARCIALMENTE CONSISTENTE** - Alguns avisos, mas sem falhas críticas"
    } else {
        "❌ **AMBIENTE INCONSISTENTE** - Foram encontradas falhas que precisam ser corrigidas"
    }
)

### **Arquivos Faltando no Servidor**

$(
    if ($missingFiles.Count -gt 0) {
        $missingFiles | ForEach-Object { "- ❌ **$_**" } | Out-String
    } else {
        "- ✅ Nenhum arquivo faltando"
    }
)

### **Arquivos Inconsistentes**

$(
    if ($differentFiles.Count -gt 0) {
        $differentFiles | ForEach-Object { "- AVISO: **$_**" } | Out-String
    } else {
        "- OK - Nenhum arquivo inconsistente"
    }
)

### **Variáveis de Ambiente com Problemas**

$(
    if ($envIssues.Count -gt 0) {
        $envIssues | ForEach-Object { "- AVISO: **$_**" } | Out-String
    } else {
        "- OK - Todas as variáveis estão corretas"
    }
)

---

## 🎯 RECOMENDAÇÕES

### **Ações Prioritárias**

$recommendation1

$recommendation2

$recommendation3

$recommendation4

---

## 📝 PRÓXIMOS PASSOS

1. Revisar este relatório
2. Corrigir problemas identificados
3. Executar script novamente para verificar correções
4. Validar que todas as verificações passam

---

**Relatório gerado em:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Script:** `testar_consistencia_producao.ps1`

"@

$report += $summary

# Salvar relatório
$reportPath = Join-Path $PSScriptRoot $OutputFile
$report | Out-File -FilePath $reportPath -Encoding UTF8

Write-ColorOutput "`n============================================" "Cyan"
Write-ColorOutput "✅ VERIFICAÇÃO CONCLUÍDA!" "Green"
Write-ColorOutput "============================================`n" "Cyan"

Write-ColorOutput "📊 Resumo:" "Yellow"
Write-ColorOutput "   - Total de verificações: $totalChecks" "White"
Write-ColorOutput "   - Verificações passaram: $passedChecks" "Green"
Write-ColorOutput "   - Avisos: $warnings" "Yellow"
Write-ColorOutput "   - Falhas: $failedChecks" "Red"

Write-ColorOutput "`n📄 Relatório salvo em:" "Yellow"
Write-ColorOutput "   $reportPath`n" "Cyan"

