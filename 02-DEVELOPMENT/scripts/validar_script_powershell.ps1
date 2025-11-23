# ============================================================================
# SCRIPT: Validador de Scripts PowerShell
# ============================================================================
# Objetivo: Validar scripts PowerShell antes de executar no servidor
# ============================================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$ScriptPath,
    
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

function Write-ValidationLog {
    param(
        [string]$Message,
        [ValidateSet("INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )
    
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        default { "White" }
    }
    Write-Host "[$Level] $Message" -ForegroundColor $color
}

Write-ValidationLog "========================================" -Level "INFO"
Write-ValidationLog "VALIDAÇÃO DE SCRIPT POWERSHELL" -Level "INFO"
Write-ValidationLog "========================================" -Level "INFO"
Write-ValidationLog "Script: $ScriptPath" -Level "INFO"

# 1. Verificar se arquivo existe
if (-not (Test-Path $ScriptPath)) {
    Write-ValidationLog "ERRO: Arquivo não encontrado: $ScriptPath" -Level "ERROR"
    exit 1
}

# 2. Validar sintaxe PowerShell
Write-ValidationLog "Validando sintaxe PowerShell..." -Level "INFO"
try {
    $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw $ScriptPath), [ref]$null)
    Write-ValidationLog "✅ Sintaxe PowerShell válida" -Level "SUCCESS"
} catch {
    Write-ValidationLog "❌ ERRO: Sintaxe PowerShell inválida: $_" -Level "ERROR"
    exit 1
}

# 3. Tentar carregar o script (sem executar)
Write-ValidationLog "Carregando script (sem executar)..." -Level "INFO"
try {
    $scriptContent = Get-Content -Raw $ScriptPath
    $null = [System.Management.Automation.PowerShell]::Create().AddScript($scriptContent).Invoke()
    Write-ValidationLog "✅ Script carregado com sucesso" -Level "SUCCESS"
} catch {
    Write-ValidationLog "❌ ERRO: Falha ao carregar script: $_" -Level "ERROR"
    exit 1
}

# 4. Verificar se script tem parâmetro -DryRun
Write-ValidationLog "Verificando suporte a modo DryRun..." -Level "INFO"
$scriptContent = Get-Content -Raw $ScriptPath
if ($scriptContent -match 'param\s*\([^)]*-DryRun') {
    Write-ValidationLog "✅ Script suporta modo DryRun" -Level "SUCCESS"
} else {
    Write-ValidationLog "⚠️ AVISO: Script não tem parâmetro -DryRun" -Level "WARN"
}

# 5. Verificar funções críticas
Write-ValidationLog "Verificando funções críticas..." -Level "INFO"
$requiredFunctions = @('Write-Log', 'Invoke-SafeSSHScript')
$missingFunctions = @()

foreach ($func in $requiredFunctions) {
    if ($scriptContent -match "function\s+$func") {
        Write-ValidationLog "✅ Função encontrada: $func" -Level "SUCCESS"
    } else {
        Write-ValidationLog "⚠️ Função não encontrada: $func" -Level "WARN"
        $missingFunctions += $func
    }
}

# 6. Verificar uso de variáveis de servidor
Write-ValidationLog "Verificando configurações de servidor..." -Level "INFO"
if ($scriptContent -match '\$servidor(Dev|Prod)') {
    Write-ValidationLog "✅ Variável de servidor encontrada" -Level "SUCCESS"
} else {
    Write-ValidationLog "⚠️ AVISO: Variável de servidor não encontrada" -Level "WARN"
}

# 7. Verificar tratamento de erros
Write-ValidationLog "Verificando tratamento de erros..." -Level "INFO"
if ($scriptContent -match 'try\s*\{' -and $scriptContent -match 'catch\s*\{') {
    Write-ValidationLog "✅ Tratamento de erros presente" -Level "SUCCESS"
} else {
    Write-ValidationLog "⚠️ AVISO: Tratamento de erros pode estar incompleto" -Level "WARN"
}

Write-ValidationLog "========================================" -Level "INFO"
if ($missingFunctions.Count -eq 0) {
    Write-ValidationLog "✅ VALIDAÇÃO CONCLUÍDA COM SUCESSO" -Level "SUCCESS"
    Write-ValidationLog "Script está pronto para execução (recomenda-se testar em DryRun primeiro)" -Level "INFO"
    exit 0
} else {
    Write-ValidationLog "⚠️ VALIDAÇÃO CONCLUÍDA COM AVISOS" -Level "WARN"
    Write-ValidationLog "Funções faltando: $($missingFunctions -join ', ')" -Level "WARN"
    exit 0
}

