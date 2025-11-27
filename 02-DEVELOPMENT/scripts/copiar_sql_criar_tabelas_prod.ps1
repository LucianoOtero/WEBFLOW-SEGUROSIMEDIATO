# Script para copiar script SQL de criação de tabelas archive e statistics para servidor de produção
# Versão: 1.0.0
# Data: 23/11/2025
# Projeto: Criar Tabelas Archive Statistics PROD
# Uso: .\copiar_sql_criar_tabelas_prod.ps1 [-DryRun]
#
# OBJETIVO:
# Copiar script SQL para criar tabelas application_logs_archive e log_statistics
# do ambiente local (Windows) para o servidor de produção, incluindo verificação
# de hash SHA256 para garantir integridade do arquivo.
#
# CARACTERÍSTICAS:
# - Calcula hash SHA256 do arquivo local ANTES de copiar
# - Copia arquivo via SCP para servidor PROD
# - Calcula hash SHA256 do arquivo no servidor APÓS cópia
# - Compara hashes (case-insensitive) para garantir integridade
# - Suporta modo DryRun para validação sem copiar
#
# CONFORMIDADE:
# - Segue diretivas do ./cursorrules
# - Usa caminho completo do workspace
# - Verifica hash SHA256 após cópia (obrigatório)
# - Compara hashes case-insensitive

param(
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

# Configurações
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$workspaceRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $scriptPath))
$scriptSQLLocal = Join-Path $workspaceRoot (Join-Path "WEBFLOW-SEGUROSIMEDIATO" (Join-Path "06-SERVER-CONFIG" "criar_tabelas_archive_statistics_prod.sql"))
$servidorProd = "root@157.180.36.223"
$scriptSQLRemote = "/tmp/criar_tabelas_archive_statistics_prod.sql"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "COPIAR SCRIPT SQL PARA PRODUÇÃO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Projeto: Criar Tabelas Archive Statistics PROD" -ForegroundColor Gray
Write-Host ""

if ($DryRun) {
    Write-Host "MODO DRYRUN ATIVADO - Nenhuma copia sera feita" -ForegroundColor Yellow
    Write-Host ""
}

# Verificar se script SQL local existe
if (-not (Test-Path $scriptSQLLocal)) {
    Write-Host "ERRO: Script SQL nao encontrado: $scriptSQLLocal" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifique se o arquivo existe no caminho correto." -ForegroundColor Yellow
    exit 1
}

Write-Host "Script SQL local: $scriptSQLLocal" -ForegroundColor Yellow
Write-Host "Script SQL remoto: $scriptSQLRemote" -ForegroundColor Yellow
Write-Host "Servidor: $servidorProd" -ForegroundColor Yellow
Write-Host ""

# Calcular hash do arquivo local ANTES de copiar (OBRIGATÓRIO)
Write-Host "Calculando hash SHA256 do arquivo local (ANTES da copia)..." -ForegroundColor Cyan
try {
    $hashLocal = (Get-FileHash -Path $scriptSQLLocal -Algorithm SHA256).Hash.ToUpper()
    Write-Host "Hash local (SHA256): $hashLocal" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "ERRO: Falha ao calcular hash do arquivo local: $_" -ForegroundColor Red
    exit 1
}

# Verificar conectividade com servidor
Write-Host "Verificando conectividade com servidor PROD..." -ForegroundColor Cyan
try {
    $connectivityTest = ssh $servidorProd "echo 'OK'" 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO: Nao foi possivel conectar ao servidor PROD" -ForegroundColor Red
        Write-Host "Detalhes: $connectivityTest" -ForegroundColor Red
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
    Write-Host "DRYRUN: Hash local seria: $hashLocal" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "DRYRUN concluido - Nenhuma copia foi realizada" -ForegroundColor Green
} else {
    Write-Host "Copiando script SQL para servidor PROD via SCP..." -ForegroundColor Cyan
    try {
        # Usar caminho completo do workspace (conforme diretivas)
        $fullPath = Resolve-Path $scriptSQLLocal
        scp $fullPath "${servidorProd}:${scriptSQLRemote}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERRO: Falha ao copiar script SQL para servidor" -ForegroundColor Red
            Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
            exit 1
        }
        
        Write-Host "Script SQL copiado com sucesso" -ForegroundColor Green
        Write-Host ""
        
        # Verificar hash do arquivo no servidor APÓS cópia (OBRIGATÓRIO)
        Write-Host "Calculando hash SHA256 do arquivo no servidor (APOS copia)..." -ForegroundColor Cyan
        try {
            $hashRemoteOutput = ssh $servidorProd "sha256sum $scriptSQLRemote | cut -d' ' -f1" 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Host "ERRO: Falha ao calcular hash no servidor" -ForegroundColor Red
                Write-Host "Detalhes: $hashRemoteOutput" -ForegroundColor Red
                exit 1
            }
            $hashRemote = $hashRemoteOutput.Trim().ToUpper()
            Write-Host "Hash remoto (SHA256): $hashRemote" -ForegroundColor Gray
            Write-Host ""
            
            # Comparar hashes (case-insensitive - ambos convertidos para maiúsculas)
            if ($hashLocal -eq $hashRemote) {
                Write-Host "Hash coincide - Arquivo copiado corretamente" -ForegroundColor Green
                Write-Host ""
                Write-Host "Hash documentado:" -ForegroundColor Gray
                Write-Host "  Local:  $hashLocal" -ForegroundColor Gray
                Write-Host "  Remoto: $hashRemote" -ForegroundColor Gray
            } else {
                Write-Host "ERRO: Hash nao coincide apos copia!" -ForegroundColor Red
                Write-Host ""
                Write-Host "Hash local:  $hashLocal" -ForegroundColor Red
                Write-Host "Hash remoto: $hashRemote" -ForegroundColor Red
                Write-Host ""
                Write-Host "RECOMENDACAO: Tentar copiar novamente" -ForegroundColor Yellow
                exit 1
            }
        } catch {
            Write-Host "ERRO: Falha ao verificar hash no servidor: $_" -ForegroundColor Red
            exit 1
        }
        
        # Verificar permissões do arquivo no servidor
        Write-Host "Verificando permissoes do arquivo no servidor..." -ForegroundColor Cyan
        try {
            $permissions = ssh $servidorProd "ls -la $scriptSQLRemote" 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Permissoes: $permissions" -ForegroundColor Gray
            }
        } catch {
            Write-Host "AVISO: Nao foi possivel verificar permissoes" -ForegroundColor Yellow
        }
        Write-Host ""
        
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
Write-Host "Hash SHA256: $hashLocal" -ForegroundColor Gray
Write-Host ""
Write-Host "PROXIMOS PASSOS:" -ForegroundColor Cyan
Write-Host "1. Validar sintaxe SQL (se necessario)" -ForegroundColor Gray
Write-Host "2. Executar script SQL no banco PROD" -ForegroundColor Gray
Write-Host "3. Validar que tabelas foram criadas corretamente" -ForegroundColor Gray
Write-Host ""

