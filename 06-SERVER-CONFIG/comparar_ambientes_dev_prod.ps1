# ============================================
# SCRIPT: COMPARAR AMBIENTES DEV vs PROD
# ============================================
# 
# Este script compara os ambientes de desenvolvimento e produção
# identificando diferenças para ajustar o ambiente de produção.
# 
# Objetivo: Garantir que todos os arquivos .js e .php funcionem
# corretamente em produção após ajustes.
#
# Data: 12/11/2025
# ============================================

param(
    [string]$DevServer = "root@65.108.156.14",
    [string]$ProdServer = "root@157.180.36.223",
    [string]$DevDir = "/var/www/html/dev/root",
    [string]$ProdDir = "/var/www/html/prod/root",
    [string]$OutputFile = "relatorio_comparacao_dev_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
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

# Função para listar arquivos em diretório remoto
function Get-RemoteFiles {
    param(
        [string]$Server,
        [string]$Directory,
        [string[]]$Extensions
    )
    $extFilter = ($Extensions | ForEach-Object { "-name '*$_'" }) -join " -o "
    $command = "find '$Directory' -maxdepth 1 -type f \( $extFilter \) 2>/dev/null | xargs -r basename -a | sort"
    $files = Invoke-SSHCommand -Server $Server -Command $command
    if ($files) {
        return ($files -split "`n" | Where-Object { $_.Trim() -ne "" })
    }
    return @()
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

# Função para obter variáveis de ambiente do PHP-FPM
function Get-PHPFPMEnvVars {
    param(
        [string]$Server
    )
    $command = "grep '^env\[.*\]' /etc/php/8.3/fpm/pool.d/www.conf 2>/dev/null | sort"
    $vars = Invoke-SSHCommand -Server $Server -Command $command
    if ($vars) {
        return ($vars -split "`n" | Where-Object { $_.Trim() -ne "" })
    }
    return @()
}

# Função para obter configuração Nginx
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

# Função para verificar certificado SSL
function Get-SSLCertificate {
    param(
        [string]$Server,
        [string]$Domain
    )
    $command = "test -d '/etc/letsencrypt/live/$Domain' && echo 'EXISTS' || echo 'NOT_EXISTS'"
    $result = Invoke-SSHCommand -Server $Server -Command $command
    return ($result -match "EXISTS")
}

# Iniciar relatório
$report = @"
# 📊 RELATÓRIO: COMPARAÇÃO AMBIENTES DEV vs PROD

**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Servidor DEV:** $DevServer  
**Servidor PROD:** $ProdServer  
**Status:** 🔍 **ANÁLISE EM ANDAMENTO**

---

## 🎯 OBJETIVO

Identificar diferenças entre os ambientes DEV e PROD para ajustar o ambiente de produção e garantir que todos os arquivos .js e .php funcionem corretamente.

---

## 📋 ARQUIVOS DO PROJETO

### **Arquivos JavaScript (.js)**
- `FooterCodeSiteDefinitivoCompleto.js`
- `MODAL_WHATSAPP_DEFINITIVO.js`
- `webflow_injection_limpo.js`

### **Arquivos PHP (.php)**
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

### **Templates de Email**
- `email_templates/template_modal.php`
- `email_templates/template_primeiro_contato.php`
- `email_templates/template_logging.php`

---

"@

Write-ColorOutput "`n============================================" "Cyan"
Write-ColorOutput "🔍 COMPARAÇÃO AMBIENTES DEV vs PROD" "Cyan"
Write-ColorOutput "============================================`n" "Cyan"

# ============================================
# 1. COMPARAR ARQUIVOS .JS E .PHP
# ============================================

Write-ColorOutput "📁 1. Comparando arquivos .js e .php..." "Yellow"

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
    "email_template_loader.php"
)

$allFiles = $jsFiles + $phpFiles

$fileComparison = @"
## 📁 1. COMPARAÇÃO DE ARQUIVOS

### **Arquivos JavaScript (.js)**

| Arquivo | Status DEV | Status PROD | Hash DEV | Hash PROD | Diferença |
|---------|-----------|-------------|----------|-----------|-----------|
"@

$missingInProd = @()
$differentHashes = @()
$sameHashes = @()

foreach ($file in $jsFiles) {
    $devPath = "$DevDir/$file"
    $prodPath = "$ProdDir/$file"
    
    $devExists = Test-RemoteFile -Server $DevServer -FilePath $devPath
    $prodExists = Test-RemoteFile -Server $ProdServer -FilePath $prodPath
    
    if (-not $devExists) {
        Write-ColorOutput "  ⚠️  Arquivo não encontrado em DEV: $file" "Yellow"
        $fileComparison += "`n| $file | ❌ Não existe | - | - | - | ⚠️ Não encontrado em DEV |"
        continue
    }
    
    $devHash = Get-RemoteFileHash -Server $DevServer -FilePath $devPath
    
    if (-not $prodExists) {
        Write-ColorOutput "  ❌ Arquivo não encontrado em PROD: $file" "Red"
        $fileComparison += "`n| $file | ✅ Existe | ❌ **FALTANDO** | $devHash | - | 🔴 **FALTANDO EM PROD** |"
        $missingInProd += $file
    } else {
        $prodHash = Get-RemoteFileHash -Server $ProdServer -FilePath $prodPath
        
        if ($devHash -eq $prodHash) {
            Write-ColorOutput "  ✅ $file - Hashes idênticos" "Green"
            $fileComparison += "`n| $file | ✅ Existe | ✅ Existe | $devHash | $prodHash | ✅ **IDÊNTICOS** |"
            $sameHashes += $file
        } else {
            Write-ColorOutput "  ⚠️  $file - Hashes diferentes" "Yellow"
            $fileComparison += "`n| $file | ✅ Existe | ✅ Existe | $devHash | $prodHash | ⚠️ **DIFERENTES** |"
            $differentHashes += $file
        }
    }
}

$fileComparison += "`n`n### **Arquivos PHP (.php)**`n`n| Arquivo | Status DEV | Status PROD | Hash DEV | Hash PROD | Diferença |`n|---------|-----------|-------------|----------|-----------|-----------|"

foreach ($file in $phpFiles) {
    $devPath = "$DevDir/$file"
    $prodPath = "$ProdDir/$file"
    
    $devExists = Test-RemoteFile -Server $DevServer -FilePath $devPath
    $prodExists = Test-RemoteFile -Server $ProdServer -FilePath $prodPath
    
    if (-not $devExists) {
        Write-ColorOutput "  ⚠️  Arquivo não encontrado em DEV: $file" "Yellow"
        $fileComparison += "`n| $file | ❌ Não existe | - | - | - | ⚠️ Não encontrado em DEV |"
        continue
    }
    
    $devHash = Get-RemoteFileHash -Server $DevServer -FilePath $devPath
    
    if (-not $prodExists) {
        Write-ColorOutput "  ❌ Arquivo não encontrado em PROD: $file" "Red"
        $fileComparison += "`n| $file | ✅ Existe | ❌ **FALTANDO** | $devHash | - | 🔴 **FALTANDO EM PROD** |"
        $missingInProd += $file
    } else {
        $prodHash = Get-RemoteFileHash -Server $ProdServer -FilePath $prodPath
        
        if ($devHash -eq $prodHash) {
            Write-ColorOutput "  ✅ $file - Hashes idênticos" "Green"
            $fileComparison += "`n| $file | ✅ Existe | ✅ Existe | $devHash | $prodHash | ✅ **IDÊNTICOS** |"
            $sameHashes += $file
        } else {
            Write-ColorOutput "  ⚠️  $file - Hashes diferentes" "Yellow"
            $fileComparison += "`n| $file | ✅ Existe | ✅ Existe | $devHash | $prodHash | ⚠️ **DIFERENTES** |"
            $differentHashes += $file
        }
    }
}

$report += $fileComparison

# ============================================
# 2. COMPARAR VARIÁVEIS DE AMBIENTE PHP-FPM
# ============================================

Write-ColorOutput "`n🔧 2. Comparando variáveis de ambiente PHP-FPM..." "Yellow"

$devEnvVars = Get-PHPFPMEnvVars -Server $DevServer
$prodEnvVars = Get-PHPFPMEnvVars -Server $ProdServer

$envComparison = @"

---

## 🔧 2. VARIÁVEIS DE AMBIENTE PHP-FPM

### **Variáveis DEV**

``````
$($devEnvVars -join "`n")
``````

### **Variáveis PROD**

``````
$($prodEnvVars -join "`n")
``````

### **Análise de Diferenças**

"@

# Variáveis críticas para comparar
$criticalVars = @(
    "APP_BASE_DIR",
    "APP_BASE_URL",
    "APP_ENVIRONMENT",
    "PHP_ENV",
    "LOG_DIR",
    "WEBFLOW_SECRET_FLYINGDONKEYS",
    "WEBFLOW_SECRET_OCTADESK",
    "ESPOCRM_URL",
    "LOG_DB_NAME",
    "LOG_DB_USER"
)

$envDiff = @()

foreach ($var in $criticalVars) {
    $devValue = ($devEnvVars | Where-Object { $_ -match "env\[$var\]" }) -replace ".*=\s*", ""
    $prodValue = ($prodEnvVars | Where-Object { $_ -match "env\[$var\]" }) -replace ".*=\s*", ""
    
    if ($devValue -and $prodValue) {
        if ($devValue -eq $prodValue) {
            Write-ColorOutput "  ✅ $var - Valores idênticos" "Green"
            $envDiff += "| $var | ✅ $devValue | ✅ $prodValue | ✅ **IDÊNTICOS** |"
        } else {
            Write-ColorOutput "  ⚠️  $var - Valores diferentes" "Yellow"
            $envDiff += "| $var | ⚠️ $devValue | ⚠️ $prodValue | ⚠️ **DIFERENTES** |"
        }
    } elseif ($devValue -and -not $prodValue) {
        Write-ColorOutput "  ❌ $var - Faltando em PROD" "Red"
        $envDiff += "| $var | ✅ $devValue | ❌ **FALTANDO** | 🔴 **FALTANDO EM PROD** |"
    } elseif (-not $devValue -and $prodValue) {
        Write-ColorOutput "  ⚠️  $var - Existe apenas em PROD" "Yellow"
        $envDiff += "| $var | ❌ Não existe | ⚠️ $prodValue | ⚠️ **APENAS EM PROD** |"
    } else {
        Write-ColorOutput "  ⚠️  $var - Não encontrado em nenhum ambiente" "Yellow"
        $envDiff += "| $var | ❌ Não existe | ❌ Não existe | ⚠️ **NÃO ENCONTRADO** |"
    }
}

$envComparison += @"

| Variável | Valor DEV | Valor PROD | Status |
|----------|-----------|------------|--------|
$($envDiff -join "`n")

"@

$report += $envComparison

# ============================================
# 3. COMPARAR CONFIGURAÇÃO NGINX
# ============================================

Write-ColorOutput "`n🌐 3. Comparando configuração Nginx..." "Yellow"

$devNginxConfig = Get-NginxConfig -Server $DevServer -Domain "dev.bssegurosimediato.com.br"
$prodNginxConfig = Get-NginxConfig -Server $ProdServer -Domain "prod.bssegurosimediato.com.br"

$nginxComparison = @"

---

## 🌐 3. CONFIGURAÇÃO NGINX

### **Status**

| Ambiente | Arquivo | Status |
|----------|---------|--------|
| DEV | `/etc/nginx/sites-available/dev.bssegurosimediato.com.br` | $(if ($devNginxConfig -notmatch "FILE_NOT_FOUND") { "✅ Existe" } else { "❌ Não encontrado" }) |
| PROD | `/etc/nginx/sites-available/prod.bssegurosimediato.com.br` | $(if ($prodNginxConfig -notmatch "FILE_NOT_FOUND") { "✅ Existe" } else { "❌ Não encontrado" }) |

"@

if ($prodNginxConfig -match "FILE_NOT_FOUND") {
    Write-ColorOutput "  ❌ Configuração Nginx PROD não encontrada" "Red"
    $nginxComparison += @"

⚠️ **PROBLEMA:** Configuração Nginx PROD não encontrada.

**Ação necessária:** Criar configuração Nginx para PROD baseada em DEV.

"@
} else {
    Write-ColorOutput "  ✅ Configuração Nginx PROD encontrada" "Green"
}

$report += $nginxComparison

# ============================================
# 4. COMPARAR CERTIFICADOS SSL
# ============================================

Write-ColorOutput "`n🔒 4. Comparando certificados SSL..." "Yellow"

$devSSLCert = Get-SSLCertificate -Server $DevServer -Domain "dev.bssegurosimediato.com.br"
$prodSSLCert = Get-SSLCertificate -Server $ProdServer -Domain "prod.bssegurosimediato.com.br"

$sslComparison = @"

---

## 🔒 4. CERTIFICADOS SSL

| Ambiente | Domínio | Certificado | Status |
|----------|---------|-------------|--------|
| DEV | `dev.bssegurosimediato.com.br` | $(if ($devSSLCert) { "✅ Existe" } else { "❌ Não encontrado" }) | $(if ($devSSLCert) { "✅ Ativo" } else { "❌ Inativo" }) |
| PROD | `prod.bssegurosimediato.com.br` | $(if ($prodSSLCert) { "✅ Existe" } else { "❌ Não encontrado" }) | $(if ($prodSSLCert) { "✅ Ativo" } else { "❌ Inativo" }) |

"@

if (-not $prodSSLCert) {
    Write-ColorOutput "  ⚠️  Certificado SSL PROD não encontrado" "Yellow"
    $sslComparison += @"

⚠️ **AVISO:** Certificado SSL PROD não encontrado.

**Ação necessária:** Obter certificado SSL via Certbot após configuração DNS.

"@
}

$report += $sslComparison

# ============================================
# 5. COMPARAR ESTRUTURA DE DIRETÓRIOS
# ============================================

Write-ColorOutput "`n📂 5. Comparando estrutura de diretórios..." "Yellow"

$devDirs = Invoke-SSHCommand -Server $DevServer -Command "find '$DevDir' -type d -maxdepth 2 2>/dev/null | sort"
$prodDirs = Invoke-SSHCommand -Server $ProdServer -Command "find '$ProdDir' -type d -maxdepth 2 2>/dev/null | sort"

$dirComparison = @"

---

## 📂 5. ESTRUTURA DE DIRETÓRIOS

### **Diretórios DEV**

``````
$($devDirs -join "`n")
``````

### **Diretórios PROD**

``````
$($prodDirs -join "`n")
``````

"@

$report += $dirComparison

# ============================================
# RESUMO E RECOMENDAÇÕES
# ============================================

$summary = @"

---

## 📊 RESUMO DA COMPARAÇÃO

### **Estatísticas**

| Categoria | Total | Idênticos | Diferentes | Faltando em PROD |
|-----------|-------|-----------|------------|------------------|
| Arquivos .js | $($jsFiles.Count) | $($sameHashes | Where-Object { $jsFiles -contains $_ } | Measure-Object | Select-Object -ExpandProperty Count) | $($differentHashes | Where-Object { $jsFiles -contains $_ } | Measure-Object | Select-Object -ExpandProperty Count) | $($missingInProd | Where-Object { $jsFiles -contains $_ } | Measure-Object | Select-Object -ExpandProperty Count) |
| Arquivos .php | $($phpFiles.Count) | $($sameHashes | Where-Object { $phpFiles -contains $_ } | Measure-Object | Select-Object -ExpandProperty Count) | $($differentHashes | Where-Object { $phpFiles -contains $_ } | Measure-Object | Select-Object -ExpandProperty Count) | $($missingInProd | Where-Object { $phpFiles -contains $_ } | Measure-Object | Select-Object -ExpandProperty Count) |
| **TOTAL** | **$($allFiles.Count)** | **$($sameHashes.Count)** | **$($differentHashes.Count)** | **$($missingInProd.Count)** |

### **Arquivos Faltando em PROD**

$(
    if ($missingInProd.Count -gt 0) {
        $missingInProd | ForEach-Object { "- ❌ **$_**" } | Out-String
    } else {
        "- ✅ Nenhum arquivo faltando"
    }
)

### **Arquivos com Diferenças**

$(
    if ($differentHashes.Count -gt 0) {
        $differentHashes | ForEach-Object { "- ⚠️ **$_**" } | Out-String
    } else {
        "- ✅ Nenhuma diferença encontrada"
    }
)

---

## 🎯 RECOMENDAÇÕES

### **Ações Prioritárias**

1. **Copiar arquivos faltantes para PROD:**
"@

# Construir lista de arquivos faltantes
if ($missingInProd.Count -gt 0) {
    $missingFilesList = $missingInProd | ForEach-Object { "   - $_" } | Out-String
    $summary += "`n$missingFilesList"
} else {
    $summary += "`n   - OK Nenhum arquivo faltando"
}

$summary += @"

2. **Atualizar arquivos diferentes em PROD:**
"@

# Construir lista de arquivos diferentes
if ($differentHashes.Count -gt 0) {
    $differentFilesList = $differentHashes | ForEach-Object { "   - $_" } | Out-String
    $summary += "`n$differentFilesList"
} else {
    $summary += "`n   - OK Nenhum arquivo precisa ser atualizado"
}

$summary += @"

3. **Verificar e ajustar variáveis de ambiente PHP-FPM em PROD:**
   - Verificar se todas as variáveis críticas estão configuradas
   - Ajustar valores específicos de PROD (APP_BASE_DIR, APP_BASE_URL, APP_ENVIRONMENT, etc.)

4. **Verificar configuração Nginx PROD:**
   - Garantir que configuração existe e está correta
   - Verificar locations específicos (placa-validate.php, cpf-validate.php)

5. **Obter certificado SSL para PROD:**
   - Configurar DNS primeiro
   - Executar Certbot após DNS propagado

---

## 📝 PRÓXIMOS PASSOS

1. ✅ Revisar este relatório
2. ⏳ Copiar arquivos faltando para PROD
3. ⏳ ⏳ Atualizar arquivos diferentes em PROD
4. ⏳ Verificar e ajustar variáveis de ambiente PHP-FPM
5. ⏳ Verificar configuração Nginx PROD
6. ⏳ Obter certificado SSL PROD
7. ⏳ Testar funcionamento de todos os arquivos .js e .php em PROD

---

**Relatório gerado em:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Script:** `comparar_ambientes_dev_prod.ps1`

"@

$report += $summary

# Salvar relatório
$reportPath = Join-Path $PSScriptRoot $OutputFile
$report | Out-File -FilePath $reportPath -Encoding UTF8

Write-ColorOutput "`n============================================" "Cyan"
Write-ColorOutput "✅ COMPARAÇÃO CONCLUÍDA!" "Green"
Write-ColorOutput "============================================`n" "Cyan"

Write-ColorOutput "📊 Resumo:" "Yellow"
Write-ColorOutput "   - Arquivos idênticos: $($sameHashes.Count)" "Green"
Write-ColorOutput "   - Arquivos diferentes: $($differentHashes.Count)" "Yellow"
Write-ColorOutput "   - Arquivos faltando em PROD: $($missingInProd.Count)" "Red"

Write-ColorOutput "`n📄 Relatório salvo em:" "Yellow"
Write-ColorOutput "   $reportPath`n" "Cyan"

