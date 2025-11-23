# ============================================================================
# SCRIPT: Validação de Arquivo Local - FooterCodeSiteDefinitivoCompleto.js
# ============================================================================
# Projeto: PROJETO_DEPLOY_FOOTERCODE_PROD_GCLID_20251123.md
# Versão: 1.0.0
# Data: 23/11/2025
# Ambiente: VALIDAÇÃO LOCAL
# Objetivo: Validar integridade e sintaxe do arquivo antes do deploy
# ============================================================================

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
# Obter diretório do script e calcular workspace root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# Script está em WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/
# Workspace root está 2 níveis acima: WEBFLOW-SEGUROSIMEDIATO/
$workspaceRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$arquivo = "FooterCodeSiteDefinitivoCompleto.js"
$arquivoDevLocal = Join-Path $workspaceRoot "02-DEVELOPMENT\$arquivo"
$arquivoProdLocal = Join-Path $workspaceRoot "03-PRODUCTION\$arquivo"

$erros = 0
$avisos = 0

function Write-Result {
    param(
        [string]$Message,
        [ValidateSet("SUCCESS", "WARN", "ERROR", "INFO")]
        [string]$Level = "INFO"
    )
    
    $color = switch ($Level) {
        "SUCCESS" { "Green" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        default { "White" }
    }
    
    Write-Host $Message -ForegroundColor $color
    
    if ($Level -eq "ERROR") {
        $script:erros++
    } elseif ($Level -eq "WARN") {
        $script:avisos++
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VALIDAÇÃO DE ARQUIVO LOCAL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se arquivos existem
Write-Result "1. Verificando existência dos arquivos..." -Level "INFO"

if (-not (Test-Path $arquivoDevLocal)) {
    Write-Result "❌ Arquivo DEV local não encontrado: $arquivoDevLocal" -Level "ERROR"
    exit 1
} else {
    Write-Result "✅ Arquivo DEV local encontrado" -Level "SUCCESS"
}

if (-not (Test-Path $arquivoProdLocal)) {
    Write-Result "❌ Arquivo PROD local não encontrado: $arquivoProdLocal" -Level "ERROR"
    exit 1
} else {
    Write-Result "✅ Arquivo PROD local encontrado" -Level "SUCCESS"
}

Write-Host ""

# Validar sintaxe JavaScript
Write-Result "2. Validando sintaxe JavaScript..." -Level "INFO"

if (Get-Command node -ErrorAction SilentlyContinue) {
    $syntaxCheck = node --check $arquivoProdLocal 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Result "✅ Sintaxe JavaScript válida" -Level "SUCCESS"
    } else {
        Write-Result "❌ Erro de sintaxe JavaScript:" -Level "ERROR"
        Write-Result $syntaxCheck -Level "ERROR"
        exit 1
    }
} else {
    Write-Result "⚠️ Node.js não disponível - pulando validação de sintaxe" -Level "WARN"
}

Write-Host ""

# Comparar hash SHA256
Write-Result "3. Comparando hash SHA256 (DEV local vs PROD local)..." -Level "INFO"

$hashDevLocal = (Get-FileHash -Path $arquivoDevLocal -Algorithm SHA256).Hash.ToUpper()
$hashProdLocal = (Get-FileHash -Path $arquivoProdLocal -Algorithm SHA256).Hash.ToUpper()

Write-Result "Hash DEV local:  $hashDevLocal" -Level "INFO"
Write-Result "Hash PROD local: $hashProdLocal" -Level "INFO"

if ($hashDevLocal -eq $hashProdLocal) {
    Write-Result "✅ Arquivos DEV e PROD local são idênticos" -Level "SUCCESS"
} else {
    Write-Result "❌ Arquivos DEV e PROD local são diferentes!" -Level "ERROR"
    exit 1
}

Write-Host ""

# Verificar referências hardcoded a DEV
Write-Result "4. Verificando referências hardcoded a DEV..." -Level "INFO"

$conteudoProd = Get-Content -Path $arquivoProdLocal -Raw

$devReferences = @()
if ($conteudoProd -match "dev\.bssegurosimediato\.com\.br") {
    $devReferences += "dev.bssegurosimediato.com.br"
}
if ($conteudoProd -match "65\.108\.156\.14") {
    $devReferences += "65.108.156.14"
}

if ($devReferences.Count -eq 0) {
    Write-Result "✅ Nenhuma referência hardcoded a DEV encontrada" -Level "SUCCESS"
} else {
    Write-Result "⚠️ Referências hardcoded a DEV encontradas:" -Level "WARN"
    $devReferences | ForEach-Object {
        Write-Result "  - $_" -Level "WARN"
    }
    
    # Verificar se são apenas em comentários ou debug
    $linhasComDev = Get-Content -Path $arquivoProdLocal | Select-String -Pattern "dev\.bssegurosimediato\.com\.br|65\.108\.156\.14" -AllMatches
    $apenasComentarios = $true
    $conteudoLinhas = Get-Content -Path $arquivoProdLocal
    $emComentarioBloco = $false
    
    foreach ($linha in $linhasComDev) {
        $linhaNum = $linha.LineNumber - 1
        $linhaTexto = $conteudoLinhas[$linhaNum]
        $linhaLimpa = $linhaTexto.Trim()
        
        # Verificar se está em comentário de bloco
        if ($linhaTexto -match "\/\*") { $emComentarioBloco = $true }
        if ($linhaTexto -match "\*\/") { $emComentarioBloco = $false }
        
        # Verificar se é comentário (// ou /*) ou console.log/debug/warn
        if (-not $emComentarioBloco -and 
            $linhaLimpa -notmatch "^\/\/" -and 
            $linhaLimpa -notmatch "^\/\*" -and 
            $linhaLimpa -notmatch "^\s*\/\/" -and 
            $linhaLimpa -notmatch "^\s*\*" -and
            $linhaLimpa -notmatch "console\.(log|debug|warn|error)") {
            $apenasComentarios = $false
            Write-Result "  Linha $($linha.LineNumber): $linhaLimpa" -Level "WARN"
            break
        }
    }
    
    if ($apenasComentarios) {
        Write-Result "✅ Referências estão apenas em comentários/debug (não afetam funcionalidade)" -Level "SUCCESS"
    } else {
        Write-Result "❌ Referências hardcoded encontradas em código executável!" -Level "ERROR"
        exit 1
    }
}

Write-Host ""

# Verificar correções do GCLID
Write-Result "5. Verificando correções do GCLID..." -Level "INFO"

$gclidChecks = @{
    "executeGCLIDFill" = "Função de correção de timing"
    "fillGCLIDFields" = "Função de preenchimento"
    "document.readyState" = "Verificação de timing"
    "MutationObserver" = "Observer para campos dinâmicos"
    "GCLID_FLD" = "Campo do formulário"
}

$gclidPresentes = @()
$gclidAusentes = @()

foreach ($check in $gclidChecks.GetEnumerator()) {
    if ($conteudoProd -match [regex]::Escape($check.Key)) {
        $gclidPresentes += "$($check.Key) - $($check.Value)"
    } else {
        $gclidAusentes += "$($check.Key) - $($check.Value)"
    }
}

if ($gclidAusentes.Count -eq 0) {
    Write-Result "✅ Todas as correções do GCLID estão presentes:" -Level "SUCCESS"
    $gclidPresentes | ForEach-Object {
        Write-Result "  ✅ $_" -Level "SUCCESS"
    }
} else {
    Write-Result "❌ Algumas correções do GCLID estão ausentes:" -Level "ERROR"
    $gclidAusentes | ForEach-Object {
        Write-Result "  ❌ $_" -Level "ERROR"
    }
    exit 1
}

Write-Host ""

# Resumo final
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESUMO DA VALIDAÇÃO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($erros -eq 0) {
    Write-Result "✅ VALIDAÇÃO CONCLUÍDA COM SUCESSO" -Level "SUCCESS"
    if ($avisos -gt 0) {
        Write-Result "⚠️ $avisos aviso(s) encontrado(s) (não críticos)" -Level "WARN"
    }
    Write-Host ""
    Write-Result "Arquivo pronto para deploy em produção" -Level "SUCCESS"
    exit 0
} else {
    Write-Result "❌ VALIDAÇÃO FALHOU - $erros erro(s) encontrado(s)" -Level "ERROR"
    Write-Host ""
    Write-Result "Arquivo NÃO está pronto para deploy" -Level "ERROR"
    exit 1
}

