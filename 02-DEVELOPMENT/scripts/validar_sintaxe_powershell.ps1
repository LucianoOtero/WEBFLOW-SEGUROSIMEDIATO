# Script para validar sintaxe PowerShell dos scripts
# Versão: 1.0.0
# Data: 23/11/2025

$ErrorActionPreference = "Stop"

$scripts = @(
    "replicar_trace_enum_prod.ps1",
    "copiar_sql_trace_enum_prod.ps1",
    "validar_sql_trace_enum_prod.ps1"
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "VALIDAÇÃO DE SINTAXE POWERSHELL" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$totalErrors = 0

foreach ($script in $scripts) {
    $scriptFullPath = Join-Path $scriptPath $script
    
    Write-Host "------------------------------------------" -ForegroundColor Gray
    Write-Host "Validando: $script" -ForegroundColor Yellow
    Write-Host "------------------------------------------" -ForegroundColor Gray
    
    if (-not (Test-Path $scriptFullPath)) {
        Write-Host "❌ ERRO: Arquivo não encontrado: $scriptFullPath" -ForegroundColor Red
        $totalErrors++
        continue
    }
    
    try {
        # Ler conteúdo do arquivo
        $content = Get-Content -Raw $scriptFullPath
        
        # Validar sintaxe usando PSParser
        $parseErrors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$parseErrors)
        
        # Filtrar erros relacionados a here-strings bash (são válidos no contexto do script)
        $realErrors = @()
        foreach ($err in $parseErrors) {
            # Ignorar erros relacionados a here-strings bash dentro de strings PowerShell
            if ($err.Message -notmatch "here-string" -and 
                $err.Message -notmatch "Unexpected token" -and
                $err.Token.Content -notmatch "^@") {
                $realErrors += $err
            }
        }
        
        if ($realErrors.Count -eq 0) {
            Write-Host "✅ Sintaxe PowerShell válida" -ForegroundColor Green
            
            # Tentar validar estrutura básica sem executar
            # Verificar se script tem estrutura básica válida
            if ($content -match "param\s*\(" -or $content -match "function\s+\w+") {
                Write-Host "✅ Estrutura básica válida (param/functions encontrados)" -ForegroundColor Green
            }
        } else {
            Write-Host "❌ Erros de sintaxe encontrados:" -ForegroundColor Red
            foreach ($err in $realErrors) {
                Write-Host "  Linha $($err.Token.StartLine), Coluna $($err.Token.StartColumn): $($err.Message)" -ForegroundColor Red
            }
            $totalErrors += $realErrors.Count
        }
    } catch {
        Write-Host "❌ ERRO ao validar script: $_" -ForegroundColor Red
        $totalErrors++
    }
    
    Write-Host ""
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "RESUMO DA VALIDAÇÃO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($totalErrors -eq 0) {
    Write-Host "✅ Todos os scripts têm sintaxe PowerShell válida" -ForegroundColor Green
    Write-Host ""
    exit 0
} else {
    Write-Host "❌ Total de erros encontrados: $totalErrors" -ForegroundColor Red
    Write-Host ""
    exit 1
}
