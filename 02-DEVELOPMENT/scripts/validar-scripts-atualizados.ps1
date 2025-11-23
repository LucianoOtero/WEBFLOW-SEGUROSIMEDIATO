# Script para validar que scripts estão atualizados e funcionando corretamente
# Versão: 1.0.0
# Data: 21/11/2025
# Uso: .\validar-scripts-atualizados.ps1

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "VALIDACAO: Scripts de Deploy Atualizados" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Configurações
$scriptsDir = Join-Path $PSScriptRoot "."
$documentacaoCorrecoes = Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) "05-DOCUMENTATION\CORRECOES_SCRIPTS_DEPLOY.md"

Write-Host "🔍 Verificando scripts de deploy..." -ForegroundColor Cyan
Write-Host ""

$scripts = @(
    "replicar-php-prod.ps1",
    "replicar-js-prod.ps1",
    "validar-replicacao-completa.ps1"
)

$erros = 0
$avisos = 0

foreach ($script in $scripts) {
    $scriptPath = Join-Path $scriptsDir $script
    
    if (-not (Test-Path $scriptPath)) {
        Write-Host "  ❌ $script - Arquivo não encontrado" -ForegroundColor Red
        $erros++
        continue
    }
    
    Write-Host "  📄 $script..." -ForegroundColor Gray -NoNewline
    
    # Verificar se script tem controle de versão
    $conteudo = Get-Content $scriptPath -Raw
    $temVersao = $conteudo -match "Versão:\s*\d+\.\d+\.\d+"
    $temRegraCritica = $conteudo -match "REGRA CRÍTICA.*corrigir no servidor"
    
    if (-not $temVersao) {
        Write-Host " ⚠️ Sem controle de versão" -ForegroundColor Yellow
        $avisos++
    } elseif (-not $temRegraCritica) {
        Write-Host " ⚠️ Sem aviso de regra crítica" -ForegroundColor Yellow
        $avisos++
    } else {
        Write-Host " ✅ OK" -ForegroundColor Green
    }
    
    # Validar sintaxe PowerShell
    $errosSintaxe = $null
    try {
        $tokens = $null
        $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$tokens, [ref]$errors)
        if ($errors.Count -gt 0) {
            Write-Host "    ❌ Erros de sintaxe encontrados:" -ForegroundColor Red
            foreach ($error in $errors) {
                Write-Host "      - $($error.Message)" -ForegroundColor Red
            }
            $erros++
        }
    } catch {
        Write-Host "    ❌ Erro ao validar sintaxe: $_" -ForegroundColor Red
        $erros++
    }
}

Write-Host ""
Write-Host "🔍 Verificando documentação de correções..." -ForegroundColor Cyan
Write-Host ""

if (Test-Path $documentacaoCorrecoes) {
    Write-Host "  ✅ Documentação de correções existe" -ForegroundColor Green
    
    # Verificar se há correções registradas
    $conteudoDoc = Get-Content $documentacaoCorrecoes -Raw
    $temCorrecoes = $conteudoDoc -match "### Correção #"
    
    if ($temCorrecoes) {
        Write-Host "  ℹ️ Correções registradas encontradas" -ForegroundColor Cyan
    } else {
        Write-Host "  ℹ️ Nenhuma correção registrada ainda" -ForegroundColor Gray
    }
} else {
    Write-Host "  ⚠️ Documentação de correções não encontrada" -ForegroundColor Yellow
    Write-Host "    Caminho esperado: $documentacaoCorrecoes" -ForegroundColor Gray
    $avisos++
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "RESULTADO DA VALIDACAO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Scripts OK: $($scripts.Count - $erros)" -ForegroundColor Green
Write-Host "❌ Erros: $erros" -ForegroundColor $(if ($erros -eq 0) { "Green" } else { "Red" })
Write-Host "⚠️ Avisos: $avisos" -ForegroundColor $(if ($avisos -eq 0) { "Green" } else { "Yellow" })
Write-Host ""

if ($erros -eq 0 -and $avisos -eq 0) {
    Write-Host "🎉 VALIDAÇÃO COMPLETA: Todos os scripts estão atualizados!" -ForegroundColor Green
    exit 0
} elseif ($erros -eq 0) {
    Write-Host "⚠️ ATENÇÃO: Alguns avisos encontrados (recomendado corrigir)" -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "❌ ERRO: Scripts com problemas encontrados" -ForegroundColor Red
    Write-Host "   Corrija os erros antes de usar os scripts" -ForegroundColor Red
    exit 1
}

