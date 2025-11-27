# Script para copiar script SQL de alteração do ENUM TRACE para servidor de produção
# Versão: 1.0.0
# Data: 23/11/2025
# Uso: .\copiar_sql_trace_enum_prod.ps1 [-DryRun]

param(
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

# Configurações
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$workspaceRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $scriptPath))
$scriptSQLLocal = Join-Path $workspaceRoot (Join-Path "WEBFLOW-SEGUROSIMEDIATO" (Join-Path "06-SERVER-CONFIG" "alterar_enum_level_adicionar_trace_prod.sql"))
$servidorProd = "root@157.180.36.223"
$scriptSQLRemote = "/tmp/alterar_enum_level_adicionar_trace_prod.sql"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "COPIAR SCRIPT SQL PARA PRODUÇÃO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "MODO DRYRUN ATIVADO - Nenhuma copia sera feita" -ForegroundColor Yellow
    Write-Host ""
}

# Verificar se script SQL local existe
if (-not (Test-Path $scriptSQLLocal)) {
    Write-Host "ERRO: Script SQL nao encontrado: $scriptSQLLocal" -ForegroundColor Red
    exit 1
}

Write-Host "Script SQL local: $scriptSQLLocal" -ForegroundColor Yellow
Write-Host "Script SQL remoto: $scriptSQLRemote" -ForegroundColor Yellow
Write-Host "Servidor: $servidorProd" -ForegroundColor Yellow
Write-Host ""

# Calcular hash do arquivo local
Write-Host "Calculando hash do arquivo local..." -ForegroundColor Cyan
$hashLocal = (Get-FileHash -Path $scriptSQLLocal -Algorithm SHA256).Hash.ToUpper()
Write-Host "Hash local: $hashLocal" -ForegroundColor Gray
Write-Host ""

# Verificar conectividade com servidor
Write-Host "Verificando conectividade com servidor PROD..." -ForegroundColor Cyan
try {
    ssh $servidorProd "echo 'OK'" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO: Nao foi possivel conectar ao servidor PROD" -ForegroundColor Red
        exit 1
    }
    Write-Host "Conectividade confirmada" -ForegroundColor Green
} catch {
    Write-Host "ERRO: Falha ao conectar ao servidor PROD: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Copiar script SQL para servidor
if ($DryRun) {
    Write-Host "DRYRUN: Copiaria arquivo para: ${servidorProd}:${scriptSQLRemote}" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "DRYRUN concluido - Nenhuma copia foi realizada" -ForegroundColor Green
} else {
    Write-Host "Copiando script SQL para servidor PROD..." -ForegroundColor Cyan
    try {
        scp $scriptSQLLocal "${servidorProd}:${scriptSQLRemote}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERRO: Falha ao copiar script SQL para servidor" -ForegroundColor Red
            exit 1
        }
        
        Write-Host "Script SQL copiado com sucesso" -ForegroundColor Green
        Write-Host ""
        
        # Verificar hash do arquivo no servidor
        Write-Host "Verificando hash do arquivo no servidor..." -ForegroundColor Cyan
        $hashRemote = (ssh $servidorProd "sha256sum $scriptSQLRemote | cut -d' ' -f1").ToUpper()
        Write-Host "Hash remoto: $hashRemote" -ForegroundColor Gray
        
        if ($hashLocal -eq $hashRemote) {
            Write-Host "Hash coincide - Arquivo copiado corretamente" -ForegroundColor Green
        } else {
            Write-Host "ERRO: Hash nao coincide apos copia!" -ForegroundColor Red
            Write-Host "Local:  $hashLocal" -ForegroundColor Red
            Write-Host "Remoto: $hashRemote" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "ERRO: Falha ao copiar script SQL: $_" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Copia concluida com sucesso" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Script SQL disponivel em: $scriptSQLRemote" -ForegroundColor Gray
Write-Host ""

