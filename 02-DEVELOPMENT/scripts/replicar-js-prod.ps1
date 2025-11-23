# Script para replicar arquivo JavaScript de DEV para PROD com validação completa
# Versão: 1.0.0
# Data: 21/11/2025
# Última Correção: -
# Uso: .\replicar-js-prod.ps1 arquivo.js
#
# ⚠️ REGRA CRÍTICA: Se este script falhar e você corrigir no servidor,
# OBRIGATÓRIO atualizar este script com a correção antes de próxima execução!
# Ver: PROCESSO_CORRECAO_SCRIPTS_DEPLOY.md

param(
    [Parameter(Mandatory=$true)]
    [string]$arquivo
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "REPLICACAO SEGURA: JS DEV -> PROD" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Configurações
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$arquivoLocal = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\$arquivo"
$servidorDev = "root@65.108.156.14"
$servidorProd = "root@157.180.36.223"
$caminhoDev = "/var/www/html/dev/root/$arquivo"
$caminhoProd = "/var/www/html/prod/root/$arquivo"

# Verificar se arquivo existe localmente
if (-not (Test-Path $arquivoLocal)) {
    Write-Host "❌ ERRO: Arquivo não encontrado: $arquivoLocal" -ForegroundColor Red
    exit 1
}

Write-Host "📄 Arquivo: $arquivo" -ForegroundColor Yellow
Write-Host ""

# FASE 1: Validar sintaxe JavaScript (se ESLint disponível)
Write-Host "🔍 FASE 1: Validando sintaxe JavaScript..." -ForegroundColor Cyan
if (Get-Command eslint -ErrorAction SilentlyContinue) {
    $eslintResult = eslint $arquivoLocal 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️ AVISO: ESLint encontrou problemas:" -ForegroundColor Yellow
        Write-Host $eslintResult -ForegroundColor Yellow
        Write-Host ""
        $continuar = Read-Host "Continuar mesmo assim? (s/N)"
        if ($continuar -ne "s" -and $continuar -ne "S") {
            exit 1
        }
    } else {
        Write-Host "✅ Sintaxe JavaScript válida" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️ ESLint não encontrado - pulando validação" -ForegroundColor Yellow
}
Write-Host ""

# FASE 2: Calcular hash local
Write-Host "🔍 FASE 2: Calculando hash local..." -ForegroundColor Cyan
$hashLocal = (Get-FileHash -Path $arquivoLocal -Algorithm SHA256).Hash.ToUpper()
Write-Host "Hash local: $hashLocal" -ForegroundColor Gray
Write-Host ""

# FASE 3: Verificar arquivo em DEV
Write-Host "🔍 FASE 3: Verificando arquivo em DEV..." -ForegroundColor Cyan
$hashDev = (ssh $servidorDev "sha256sum $caminhoDev 2>/dev/null | cut -d' ' -f1").ToUpper()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrEmpty($hashDev)) {
    Write-Host "⚠️ Arquivo não existe em DEV. Copiando para DEV primeiro..." -ForegroundColor Yellow
    scp $arquivoLocal "${servidorDev}:${caminhoDev}"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ ERRO: Falha ao copiar para DEV" -ForegroundColor Red
        exit 1
    }
    $hashDev = (ssh $servidorDev "sha256sum $caminhoDev | cut -d' ' -f1").ToUpper()
}
Write-Host "Hash DEV: $hashDev" -ForegroundColor Gray

if ($hashLocal -ne $hashDev) {
    Write-Host "❌ ERRO: Hash local não coincide com DEV" -ForegroundColor Red
    Write-Host "Local: $hashLocal" -ForegroundColor Red
    Write-Host "DEV:   $hashDev" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Hash local coincide com DEV" -ForegroundColor Green
Write-Host ""

# FASE 4: Criar backup em PROD
Write-Host "🔍 FASE 4: Criando backup em PROD..." -ForegroundColor Cyan
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupCmd = "cp $caminhoProd ${caminhoProd}.backup_${timestamp} 2>/dev/null || echo 'Arquivo não existe em PROD (primeira vez)'"
ssh $servidorProd $backupCmd | Out-Null
Write-Host "✅ Backup criado (ou arquivo não existe)" -ForegroundColor Green
Write-Host ""

# FASE 5: Copiar para PROD
Write-Host "🔍 FASE 5: Copiando para PROD..." -ForegroundColor Cyan
scp $arquivoLocal "${servidorProd}:${caminhoProd}"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ERRO: Falha ao copiar para PROD" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Arquivo copiado para PROD" -ForegroundColor Green
Write-Host ""

# FASE 6: Verificar hash em PROD
Write-Host "🔍 FASE 6: Verificando hash em PROD..." -ForegroundColor Cyan
$hashProd = (ssh $servidorProd "sha256sum $caminhoProd | cut -d' ' -f1").ToUpper()
Write-Host "Hash PROD: $hashProd" -ForegroundColor Gray

if ($hashLocal -ne $hashProd) {
    Write-Host "❌ ERRO CRÍTICO: Hash não coincide após cópia!" -ForegroundColor Red
    Write-Host "Local: $hashLocal" -ForegroundColor Red
    Write-Host "PROD:  $hashProd" -ForegroundColor Red
    Write-Host ""
    Write-Host "⚠️ Restaurando backup..." -ForegroundColor Yellow
    ssh $servidorProd "mv ${caminhoProd}.backup_${timestamp} $caminhoProd" | Out-Null
    exit 1
}
Write-Host "✅ Hash PROD coincide com local" -ForegroundColor Green
Write-Host ""

# SUCESSO
Write-Host "==========================================" -ForegroundColor Green
Write-Host "✅ REPLICAÇÃO CONCLUÍDA COM SUCESSO" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Arquivo: $arquivo" -ForegroundColor Yellow
Write-Host "Hash: $hashLocal" -ForegroundColor Gray
Write-Host "Backup: ${arquivo}.backup_${timestamp}" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠️ PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "1. Limpar cache do Cloudflare" -ForegroundColor White
Write-Host "2. Testar funcionalidade em PROD" -ForegroundColor White
Write-Host "3. Verificar console do navegador" -ForegroundColor White
Write-Host "4. Atualizar documento de tracking" -ForegroundColor White

