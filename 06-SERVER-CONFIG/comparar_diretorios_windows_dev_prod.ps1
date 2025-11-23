# ============================================
# SCRIPT: COMPARAR DIRETÓRIOS WINDOWS DEV vs PROD
# ============================================
# 
# Este script compara os diretórios de desenvolvimento e produção no Windows,
# identificando arquivos diferentes, faltando ou desatualizados.
#
# Data: 16/11/2025
# ============================================

param(
    [string]$DevDir = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT",
    [string]$ProdDir = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION",
    [string]$OutputFile = "relatorio_comparacao_windows_dev_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
)

# Cores para output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Função para calcular hash SHA256
function Get-FileHashSHA256 {
    param([string]$FilePath)
    if (Test-Path $FilePath) {
        return (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash.ToUpper()
    }
    return $null
}

# Arquivos essenciais a comparar
$essentialFiles = @(
    # JavaScript
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js",
    # PHP
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
    "aws_ses_config.php",
    # Templates
    "email_templates\template_modal.php",
    "email_templates\template_primeiro_contato.php",
    "email_templates\template_logging.php",
    # Outros
    "composer.json"
)

Write-ColorOutput "`n============================================" "Cyan"
Write-ColorOutput "🔍 COMPARAÇÃO: DEV vs PROD (WINDOWS)" "Cyan"
Write-ColorOutput "============================================`n" "Cyan"

# Contadores
$totalFiles = 0
$identicalFiles = 0
$differentFiles = 0
$missingInProd = 0
$extraInProd = @()

# Iniciar relatório
$report = @"
# 📊 RELATÓRIO: COMPARAÇÃO DIRETÓRIOS WINDOWS DEV vs PROD

**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Diretório DEV:** $DevDir  
**Diretório PROD:** $ProdDir  
**Status:** 🔍 **COMPARAÇÃO EM ANDAMENTO**

---

## 🎯 OBJETIVO

Comparar os diretórios de desenvolvimento e produção no Windows para identificar arquivos diferentes, faltando ou desatualizados.

---

## 📁 COMPARAÇÃO DE ARQUIVOS ESSENCIAIS

### **Arquivos JavaScript (.js)**

| Arquivo | Status DEV | Status PROD | Hash DEV | Hash PROD | Status |
|---------|-----------|-------------|----------|-----------|--------|
"@

$jsFiles = @("FooterCodeSiteDefinitivoCompleto.js", "MODAL_WHATSAPP_DEFINITIVO.js", "webflow_injection_limpo.js")

foreach ($file in $jsFiles) {
    $totalFiles++
    $devPath = Join-Path $DevDir $file
    $prodPath = Join-Path $ProdDir $file
    
    $devExists = Test-Path $devPath
    $prodExists = Test-Path $prodPath
    
    if ($devExists -and $prodExists) {
        $devHash = Get-FileHashSHA256 -FilePath $devPath
        $prodHash = Get-FileHashSHA256 -FilePath $prodPath
        
        if ($devHash -eq $prodHash) {
            Write-ColorOutput "  ✅ $file - Idêntico" "Green"
            $report += "`n| $file | ✅ Existe | ✅ Existe | $($devHash.Substring(0, 16))... | $($prodHash.Substring(0, 16))... | ✅ **IDÊNTICO** |"
            $identicalFiles++
        } else {
            Write-ColorOutput "  ⚠️  $file - Diferente" "Yellow"
            $report += "`n| $file | ✅ Existe | ✅ Existe | $($devHash.Substring(0, 16))... | $($prodHash.Substring(0, 16))... | ⚠️ **DIFERENTE** |"
            $differentFiles++
        }
    } elseif ($devExists -and -not $prodExists) {
        Write-ColorOutput "  ❌ $file - Faltando em PROD" "Red"
        $devHash = Get-FileHashSHA256 -FilePath $devPath
        $report += "`n| $file | ✅ Existe | ❌ Faltando | $($devHash.Substring(0, 16))... | - | 🔴 **FALTANDO EM PROD** |"
        $missingInProd++
    } elseif (-not $devExists -and $prodExists) {
        Write-ColorOutput "  ⚠️  $file - Existe apenas em PROD" "Yellow"
        $prodHash = Get-FileHashSHA256 -FilePath $prodPath
        $report += "`n| $file | ❌ Não existe | ✅ Existe | - | $($prodHash.Substring(0, 16))... | ⚠️ **EXTRA EM PROD** |"
        $extraInProd += $file
    } else {
        Write-ColorOutput "  ❌ $file - Não existe em nenhum" "Red"
        $report += "`n| $file | ❌ Não existe | ❌ Não existe | - | - | ❌ **NÃO EXISTE** |"
    }
}

$report += "`n`n### **Arquivos PHP (.php)**`n`n| Arquivo | Status DEV | Status PROD | Hash DEV | Hash PROD | Status |`n|---------|-----------|-------------|----------|-----------|--------|"

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

foreach ($file in $phpFiles) {
    $totalFiles++
    $devPath = Join-Path $DevDir $file
    $prodPath = Join-Path $ProdDir $file
    
    $devExists = Test-Path $devPath
    $prodExists = Test-Path $prodPath
    
    if ($devExists -and $prodExists) {
        $devHash = Get-FileHashSHA256 -FilePath $devPath
        $prodHash = Get-FileHashSHA256 -FilePath $prodPath
        
        if ($devHash -eq $prodHash) {
            Write-ColorOutput "  ✅ $file - Idêntico" "Green"
            $report += "`n| $file | ✅ Existe | ✅ Existe | $($devHash.Substring(0, 16))... | $($prodHash.Substring(0, 16))... | ✅ **IDÊNTICO** |"
            $identicalFiles++
        } else {
            Write-ColorOutput "  ⚠️  $file - Diferente" "Yellow"
            $report += "`n| $file | ✅ Existe | ✅ Existe | $($devHash.Substring(0, 16))... | $($prodHash.Substring(0, 16))... | ⚠️ **DIFERENTE** |"
            $differentFiles++
        }
    } elseif ($devExists -and -not $prodExists) {
        Write-ColorOutput "  ❌ $file - Faltando em PROD" "Red"
        $devHash = Get-FileHashSHA256 -FilePath $devPath
        $report += "`n| $file | ✅ Existe | ❌ Faltando | $($devHash.Substring(0, 16))... | - | 🔴 **FALTANDO EM PROD** |"
        $missingInProd++
    } elseif (-not $devExists -and $prodExists) {
        Write-ColorOutput "  ⚠️  $file - Existe apenas em PROD" "Yellow"
        $prodHash = Get-FileHashSHA256 -FilePath $prodPath
        $report += "`n| $file | ❌ Não existe | ✅ Existe | - | $($prodHash.Substring(0, 16))... | ⚠️ **EXTRA EM PROD** |"
        $extraInProd += $file
    } else {
        Write-ColorOutput "  ❌ $file - Não existe em nenhum" "Red"
        $report += "`n| $file | ❌ Não existe | ❌ Não existe | - | - | ❌ **NÃO EXISTE** |"
    }
}

$report += "`n`n### **Templates de Email**`n`n| Arquivo | Status DEV | Status PROD | Hash DEV | Hash PROD | Status |`n|---------|-----------|-------------|----------|-----------|--------|"

$templates = @(
    "email_templates\template_modal.php",
    "email_templates\template_primeiro_contato.php",
    "email_templates\template_logging.php"
)

foreach ($template in $templates) {
    $totalFiles++
    $devPath = Join-Path $DevDir $template
    $prodPath = Join-Path $ProdDir $template
    
    $devExists = Test-Path $devPath
    $prodExists = Test-Path $prodPath
    
    if ($devExists -and $prodExists) {
        $devHash = Get-FileHashSHA256 -FilePath $devPath
        $prodHash = Get-FileHashSHA256 -FilePath $prodPath
        
        if ($devHash -eq $prodHash) {
            Write-ColorOutput "  ✅ $template - Idêntico" "Green"
            $report += "`n| $template | ✅ Existe | ✅ Existe | $($devHash.Substring(0, 16))... | $($prodHash.Substring(0, 16))... | ✅ **IDÊNTICO** |"
            $identicalFiles++
        } else {
            Write-ColorOutput "  ⚠️  $template - Diferente" "Yellow"
            $report += "`n| $template | ✅ Existe | ✅ Existe | $($devHash.Substring(0, 16))... | $($prodHash.Substring(0, 16))... | ⚠️ **DIFERENTE** |"
            $differentFiles++
        }
    } elseif ($devExists -and -not $prodExists) {
        Write-ColorOutput "  ❌ $template - Faltando em PROD" "Red"
        $devHash = Get-FileHashSHA256 -FilePath $devPath
        $report += "`n| $template | ✅ Existe | ❌ Faltando | $($devHash.Substring(0, 16))... | - | 🔴 **FALTANDO EM PROD** |"
        $missingInProd++
    } elseif (-not $devExists -and $prodExists) {
        Write-ColorOutput "  ⚠️  $template - Existe apenas em PROD" "Yellow"
        $prodHash = Get-FileHashSHA256 -FilePath $prodPath
        $report += "`n| $template | ❌ Não existe | ✅ Existe | - | $($prodHash.Substring(0, 16))... | ⚠️ **EXTRA EM PROD** |"
        $extraInProd += $template
    } else {
        Write-ColorOutput "  ❌ $template - Não existe em nenhum" "Red"
        $report += "`n| $template | ❌ Não existe | ❌ Não existe | - | - | ❌ **NÃO EXISTE** |"
    }
}

$report += "`n`n### **Outros Arquivos**`n`n| Arquivo | Status DEV | Status PROD | Hash DEV | Hash PROD | Status |`n|---------|-----------|-------------|----------|-----------|--------|"

$otherFiles = @("composer.json")

foreach ($file in $otherFiles) {
    $totalFiles++
    $devPath = Join-Path $DevDir $file
    $prodPath = Join-Path $ProdDir $file
    
    $devExists = Test-Path $devPath
    $prodExists = Test-Path $prodPath
    
    if ($devExists -and $prodExists) {
        $devHash = Get-FileHashSHA256 -FilePath $devPath
        $prodHash = Get-FileHashSHA256 -FilePath $prodPath
        
        if ($devHash -eq $prodHash) {
            Write-ColorOutput "  ✅ $file - Idêntico" "Green"
            $report += "`n| $file | ✅ Existe | ✅ Existe | $($devHash.Substring(0, 16))... | $($prodHash.Substring(0, 16))... | ✅ **IDÊNTICO** |"
            $identicalFiles++
        } else {
            Write-ColorOutput "  ⚠️  $file - Diferente" "Yellow"
            $report += "`n| $file | ✅ Existe | ✅ Existe | $($devHash.Substring(0, 16))... | $($prodHash.Substring(0, 16))... | ⚠️ **DIFERENTE** |"
            $differentFiles++
        }
    } elseif ($devExists -and -not $prodExists) {
        Write-ColorOutput "  ❌ $file - Faltando em PROD" "Red"
        $devHash = Get-FileHashSHA256 -FilePath $devPath
        $report += "`n| $file | ✅ Existe | ❌ Faltando | $($devHash.Substring(0, 16))... | - | 🔴 **FALTANDO EM PROD** |"
        $missingInProd++
    } elseif (-not $devExists -and $prodExists) {
        Write-ColorOutput "  ⚠️  $file - Existe apenas em PROD" "Yellow"
        $prodHash = Get-FileHashSHA256 -FilePath $prodPath
        $report += "`n| $file | ❌ Não existe | ✅ Existe | - | $($prodHash.Substring(0, 16))... | ⚠️ **EXTRA EM PROD** |"
        $extraInProd += $file
    } else {
        Write-ColorOutput "  ❌ $file - Não existe em nenhum" "Red"
        $report += "`n| $file | ❌ Não existe | ❌ Não existe | - | - | ❌ **NÃO EXISTE** |"
    }
}

# Resumo
$report += @"

---

## 📊 RESUMO DA COMPARAÇÃO

### **Estatísticas**

| Categoria | Total |
|-----------|-------|
| **Total de arquivos verificados** | **$totalFiles** |
| **Arquivos idênticos** | **$identicalFiles** |
| **Arquivos diferentes** | **$differentFiles** |
| **Arquivos faltando em PROD** | **$missingInProd** |
| **Arquivos extras em PROD** | **$($extraInProd.Count)** |

### **Status Geral**

$(
    if ($differentFiles -eq 0 -and $missingInProd -eq 0) {
        "✅ **PROD ESTÁ ATUALIZADO** - Todos os arquivos estão idênticos ou não há arquivos faltando"
    } elseif ($differentFiles -gt 0 -or $missingInProd -gt 0) {
        "⚠️ **PROD PRECISA ATUALIZAÇÃO** - Existem arquivos diferentes ou faltando"
    } else {
        "✅ **PROD ESTÁ ATUALIZADO**"
    }
)

---

## 🎯 RECOMENDAÇÕES

### **Ações Necessárias**

$(
    if ($differentFiles -gt 0) {
        "1. **Atualizar arquivos diferentes:**`n   " + ($differentFiles | ForEach-Object { "- Copiar arquivos diferentes de DEV para PROD" } | Out-String)
    } else {
        "1. ✅ Nenhum arquivo precisa ser atualizado"
    }
)

$(
    if ($missingInProd -gt 0) {
        "2. **Copiar arquivos faltantes:**`n   " + ($missingInProd | ForEach-Object { "- Copiar arquivos faltantes de DEV para PROD" } | Out-String)
    } else {
        "2. ✅ Nenhum arquivo faltando"
    }
)

$(
    if ($extraInProd.Count -gt 0) {
        "3. **Arquivos extras em PROD (verificar se podem ser removidos):**`n   " + ($extraInProd | ForEach-Object { "- $_" } | Out-String)
    } else {
        "3. ✅ Nenhum arquivo extra em PROD"
    }
)

---

## 📝 PRÓXIMOS PASSOS

1. Revisar este relatório
2. Copiar arquivos diferentes de DEV para PROD (se necessário)
3. Copiar arquivos faltantes de DEV para PROD (se necessário)
4. Verificar arquivos extras em PROD (remover se não forem necessários)
5. Atualizar servidor de produção após sincronização local

---

**Relatório gerado em:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Script:** `comparar_diretorios_windows_dev_prod.ps1`

"@

# Salvar relatório
$reportPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) $OutputFile
$report | Out-File -FilePath $reportPath -Encoding UTF8

Write-ColorOutput "`n============================================" "Cyan"
Write-ColorOutput "✅ COMPARAÇÃO CONCLUÍDA!" "Green"
Write-ColorOutput "============================================`n" "Cyan"

Write-ColorOutput "📊 Resumo:" "Yellow"
Write-ColorOutput "   - Total de arquivos: $totalFiles" "White"
Write-ColorOutput "   - Idênticos: $identicalFiles" "Green"
Write-ColorOutput "   - Diferentes: $differentFiles" "Yellow"
Write-ColorOutput "   - Faltando em PROD: $missingInProd" "Red"
Write-ColorOutput "   - Extras em PROD: $($extraInProd.Count)" "Yellow"

Write-ColorOutput "`n📄 Relatório salvo em:" "Yellow"
Write-ColorOutput "   $reportPath`n" "Cyan"

