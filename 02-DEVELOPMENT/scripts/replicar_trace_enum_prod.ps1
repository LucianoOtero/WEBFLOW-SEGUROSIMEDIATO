# Script para replicar adição de 'TRACE' ao ENUM da coluna `level` em PRODUÇÃO
# Versão: 1.0.0
# Data: 23/11/2025
# Projeto: Replicar Adição de 'TRACE' ao ENUM da Coluna `level` em PRODUÇÃO
# Uso: .\replicar_trace_enum_prod.ps1 [-DryRun]
#
# ⚠️ REGRA CRÍTICA: Se este script falhar e você corrigir no servidor,
# OBRIGATÓRIO atualizar este script com a correção antes de próxima execução!
# Ver: PROCESSO_CORRECAO_SCRIPTS_DEPLOY.md

param(
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

# =====================================================
# CONFIGURAÇÕES
# =====================================================

$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$scriptSQL = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\alterar_enum_level_adicionar_trace_prod.sql"
$servidorProd = "root@157.180.36.223"
$bancoProd = "rpa_logs_prod"
$usuarioProd = "rpa_logger_prod"
$senhaProd = "tYbAwe7QkKNrHSRhaWplgsSxt"

# =====================================================
# FUNÇÕES AUXILIARES
# =====================================================

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "SUCCESS" { "Green" }
        "DEBUG" { "Gray" }
        default { "White" }
    }
    
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Invoke-SafeSSHCommand {
    param(
        [string]$Command,
        [string]$Description = ""
    )
    
    if ($DryRun) {
        Write-Log "DRYRUN: Executaria: $Command" -Level "DEBUG"
        return "DRYRUN_OUTPUT"
    }
    
    Write-Log "Executando: $Description" -Level "DEBUG"
    $result = ssh $servidorProd $Command 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -ne 0) {
        Write-Log "Erro ao executar comando (exit code: $exitCode)" -Level "ERROR"
        Write-Log "Saída: $result" -Level "ERROR"
        throw "SSH command failed: $Command"
    }
    
    return $result
}

function Invoke-SafeSSHScript {
    param(
        [string]$ScriptContent,
        [string]$ScriptName = "temp_script.sh"
    )
    
    $tempScriptLocal = Join-Path $env:TEMP $ScriptName
    $tempScriptRemote = "/tmp/$ScriptName"
    
    Write-Log "Criando script temporário local: $tempScriptLocal" -Level "DEBUG"
    
    try {
        # Criar script temporário localmente (UTF8 sem BOM, com quebras de linha Unix)
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        $scriptContentUnix = $ScriptContent -replace "`r`n", "`n" -replace "`r", "`n"
        [System.IO.File]::WriteAllText($tempScriptLocal, $scriptContentUnix, $utf8NoBom)
        
        if ($DryRun) {
            Write-Log "DRYRUN: Copiaria script para servidor: $tempScriptRemote" -Level "DEBUG"
            Write-Log "DRYRUN: Executaria script no servidor" -Level "DEBUG"
            Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
            return "DRYRUN_OUTPUT"
        }
        
        # Copiar para servidor via SCP
        Write-Log "Copiando script para servidor: $tempScriptRemote" -Level "DEBUG"
        scp $tempScriptLocal "${servidorProd}:${tempScriptRemote}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao copiar script para servidor"
        }
        
        # Tornar executável e executar
        $executeCommand = "chmod +x $tempScriptRemote && $tempScriptRemote"
        Write-Log "Executando script no servidor: $executeCommand" -Level "DEBUG"
        $result = ssh $servidorProd $executeCommand 2>&1
        $exitCode = $LASTEXITCODE
        
        # Remover script do servidor
        ssh $servidorProd "rm -f $tempScriptRemote" 2>&1 | Out-Null
        
        # Remover script local
        Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
        
        if ($exitCode -ne 0) {
            Write-Log "Erro ao executar script temporário (exit code: $exitCode)" -Level "ERROR"
            Write-Log "Saída do script: $result" -Level "ERROR"
            throw "Script execution failed with exit code $exitCode"
        }
        
        return $result
    } catch {
        # Limpar em caso de erro
        Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
        ssh $servidorProd "rm -f $tempScriptRemote" 2>&1 | Out-Null
        throw
    }
}

# =====================================================
# INÍCIO DO SCRIPT
# =====================================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "REPLICACAO: TRACE ENUM PROD" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "⚠️ MODO DRYRUN ATIVADO - Nenhuma alteração será feita" -ForegroundColor Yellow
    Write-Host ""
}

# =====================================================
# FASE 1: PREPARAÇÃO E VALIDAÇÃO PRÉ-REPLICAÇÃO
# =====================================================

Write-Host "🔍 FASE 1: Preparação e Validação Pré-Replicação" -ForegroundColor Cyan
Write-Host ""

# Verificar se script SQL existe
if (-not (Test-Path $scriptSQL)) {
    Write-Log "ERRO: Script SQL não encontrado: $scriptSQL" -Level "ERROR"
    exit 1
}
Write-Log "Script SQL encontrado: $scriptSQL" -Level "SUCCESS"

# Verificar conectividade com servidor PROD
Write-Log "Verificando conectividade com servidor PROD..." -Level "INFO"
try {
    $testConnection = Invoke-SafeSSHCommand -Command "echo 'OK'" -Description "Teste de conectividade"
    Write-Log "Conectividade com servidor PROD confirmada" -Level "SUCCESS"
} catch {
    Write-Log "ERRO: Não foi possível conectar ao servidor PROD" -Level "ERROR"
    exit 1
}

Write-Host ""

# =====================================================
# FASE 2: VERIFICAÇÃO DO SCHEMA ATUAL EM PROD
# =====================================================

Write-Host "🔍 FASE 2: Verificação do Schema Atual em PROD" -ForegroundColor Cyan
Write-Host ""

$verificarSchemaScript = @"
#!/bin/bash
set -e

mysql -u $usuarioProd -p$senhaProd $bancoProd <<EOF
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = '$bancoProd' 
  AND COLUMN_NAME = 'level'
ORDER BY TABLE_NAME;
EOF
"@

Write-Log "Verificando schema atual do banco PROD..." -Level "INFO"
try {
    $schemaAtual = Invoke-SafeSSHScript -ScriptContent $verificarSchemaScript -ScriptName "verificar_schema_prod.sh"
    Write-Host $schemaAtual
    Write-Log "Schema atual verificado" -Level "SUCCESS"
} catch {
    Write-Log "ERRO: Falha ao verificar schema atual" -Level "ERROR"
    exit 1
}

Write-Host ""

# =====================================================
# FASE 3: BACKUP DO BANCO DE DADOS PROD
# =====================================================

Write-Host "🔍 FASE 3: Backup do Banco de Dados PROD" -ForegroundColor Cyan
Write-Host ""

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "/tmp/backup_rpa_logs_prod_${timestamp}.sql"

$backupScript = @"
#!/bin/bash
set -e

echo "Criando backup do banco $bancoProd..."
mysqldump -u $usuarioProd -p$senhaProd $bancoProd > $backupFile

if [ $? -eq 0 ]; then
    echo "✅ Backup criado com sucesso: $backupFile"
    ls -lh $backupFile
    echo "BACKUP_FILE=$backupFile"
else
    echo "❌ ERRO: Falha ao criar backup"
    exit 1
fi
"@

Write-Log "Criando backup do banco de dados PROD..." -Level "INFO"
try {
    $backupResult = Invoke-SafeSSHScript -ScriptContent $backupScript -ScriptName "backup_prod.sh"
    Write-Host $backupResult
    Write-Log "Backup criado com sucesso: $backupFile" -Level "SUCCESS"
} catch {
    Write-Log "ERRO: Falha ao criar backup do banco de dados" -Level "ERROR"
    exit 1
}

Write-Host ""

# =====================================================
# FASE 4: EXECUÇÃO DA ALTERAÇÃO EM PROD
# =====================================================

Write-Host "🔍 FASE 4: Execução da Alteração em PROD" -ForegroundColor Cyan
Write-Host ""

# Copiar script SQL para servidor
$scriptSQLRemote = "/tmp/alterar_enum_level_adicionar_trace_prod.sql"

Write-Log "Copiando script SQL para servidor PROD..." -Level "INFO"
if (-not $DryRun) {
    scp $scriptSQL "${servidorProd}:${scriptSQLRemote}" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Log "ERRO: Falha ao copiar script SQL para servidor" -Level "ERROR"
        exit 1
    }
    Write-Log "Script SQL copiado para servidor" -Level "SUCCESS"
} else {
    Write-Log "DRYRUN: Copiaria script SQL para servidor" -Level "DEBUG"
}

# Executar script SQL
$executarSQLScript = @"
#!/bin/bash
set -e

echo "Executando script SQL no banco $bancoProd..."
mysql -u $usuarioProd -p$senhaProd $bancoProd < $scriptSQLRemote

if [ $? -eq 0 ]; then
    echo "✅ Script SQL executado com sucesso"
else
    echo "❌ ERRO: Falha ao executar script SQL"
    exit 1
fi
"@

Write-Log "Executando script SQL no banco de dados PROD..." -Level "INFO"
try {
    $execResult = Invoke-SafeSSHScript -ScriptContent $executarSQLScript -ScriptName "executar_sql_prod.sh"
    Write-Host $execResult
    Write-Log "Script SQL executado com sucesso" -Level "SUCCESS"
} catch {
    Write-Log "ERRO: Falha ao executar script SQL" -Level "ERROR"
    Write-Log "Backup disponível em: $backupFile" -Level "WARN"
    exit 1
}

Write-Host ""

# =====================================================
# FASE 5: VALIDAÇÃO DA ALTERAÇÃO APLICADA
# =====================================================

Write-Host "🔍 FASE 5: Validação da Alteração Aplicada" -ForegroundColor Cyan
Write-Host ""

$validarAlteracaoScript = @"
#!/bin/bash
set -e

echo "Verificando schema após alteração..."
mysql -u $usuarioProd -p$senhaProd $bancoProd <<EOF
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = '$bancoProd' 
  AND COLUMN_NAME = 'level'
ORDER BY TABLE_NAME;
EOF

# Verificar se TRACE está no ENUM
TRACE_PRESENT=\$(mysql -u $usuarioProd -p$senhaProd $bancoProd -N -e "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '$bancoProd' AND TABLE_NAME = 'application_logs' AND COLUMN_NAME = 'level';" | grep -i TRACE)

if [ -n "\$TRACE_PRESENT" ]; then
    echo "✅ TRACE encontrado no ENUM"
    echo "VALIDATION_OK=1"
else
    echo "❌ ERRO: TRACE não encontrado no ENUM"
    echo "VALIDATION_OK=0"
    exit 1
fi
"@

Write-Log "Validando que alteração foi aplicada corretamente..." -Level "INFO"
try {
    $validacaoResult = Invoke-SafeSSHScript -ScriptContent $validarAlteracaoScript -ScriptName "validar_alteracao_prod.sh"
    Write-Host $validacaoResult
    
    if ($validacaoResult -match "VALIDATION_OK=1") {
        Write-Log "Validação bem-sucedida: TRACE está presente no ENUM" -Level "SUCCESS"
    } else {
        Write-Log "ERRO: Validação falhou - TRACE não encontrado no ENUM" -Level "ERROR"
        exit 1
    }
} catch {
    Write-Log "ERRO: Falha ao validar alteração" -Level "ERROR"
    exit 1
}

Write-Host ""

# =====================================================
# FASE 6: TESTE FUNCIONAL EM PROD
# =====================================================

Write-Host "🔍 FASE 6: Teste Funcional em PROD" -ForegroundColor Cyan
Write-Host ""

$testeFuncionalScript = @"
#!/bin/bash
set -e

echo "Testando inserção de log com nível TRACE..."
mysql -u $usuarioProd -p$senhaProd $bancoProd <<EOF
INSERT INTO application_logs (
    log_id, request_id, timestamp, server_time,
    level, category, file_name, message, environment
) VALUES (
    CONCAT('test_', UNIX_TIMESTAMP(), '_', FLOOR(RAND() * 1000000)),
    CONCAT('req_test_', UNIX_TIMESTAMP()),
    NOW(6),
    UNIX_TIMESTAMP(NOW(6)),
    'TRACE',
    'TEST',
    'test_replicacao.sql',
    'Teste de inserção TRACE após replicação',
    'production'
);

SELECT 
    log_id,
    level,
    message,
    timestamp
FROM application_logs 
WHERE level = 'TRACE' 
  AND message LIKE '%Teste de inserção TRACE após replicação%'
ORDER BY timestamp DESC 
LIMIT 1;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Teste funcional bem-sucedido: Log TRACE inserido corretamente"
    echo "TEST_OK=1"
else
    echo "❌ ERRO: Falha ao inserir log TRACE"
    echo "TEST_OK=0"
    exit 1
fi
"@

Write-Log "Executando teste funcional (inserção de log TRACE)..." -Level "INFO"
try {
    $testeResult = Invoke-SafeSSHScript -ScriptContent $testeFuncionalScript -ScriptName "teste_funcional_prod.sh"
    Write-Host $testeResult
    
    if ($testeResult -match "TEST_OK=1") {
        Write-Log "Teste funcional bem-sucedido: Log TRACE inserido corretamente" -Level "SUCCESS"
    } else {
        Write-Log "ERRO: Teste funcional falhou" -Level "ERROR"
        exit 1
    }
} catch {
    Write-Log "ERRO: Falha ao executar teste funcional" -Level "ERROR"
    exit 1
}

Write-Host ""

# =====================================================
# RESUMO FINAL
# =====================================================

Write-Host "==========================================" -ForegroundColor Green
Write-Host "✅ REPLICAÇÃO CONCLUÍDA COM SUCESSO" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Log "Resumo da replicação:" -Level "INFO"
Write-Host "  Banco de Dados: $bancoProd" -ForegroundColor Gray
Write-Host "  Backup criado: $backupFile" -ForegroundColor Gray
Write-Host "  Script SQL: $scriptSQLRemote" -ForegroundColor Gray
Write-Host "  Status: ✅ Alteração aplicada e validada" -ForegroundColor Green
Write-Host ""

Write-Host "⚠️ PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "  1. Monitorar logs por 24-48h" -ForegroundColor Gray
Write-Host "  2. Verificar que logs TRACE estão sendo inseridos normalmente" -ForegroundColor Gray
Write-Host "  3. Atualizar documentação de tracking" -ForegroundColor Gray
Write-Host "  4. Atualizar histórico de replicação" -ForegroundColor Gray
Write-Host ""

if ($DryRun) {
    Write-Host "⚠️ MODO DRYRUN: Nenhuma alteração foi feita realmente" -ForegroundColor Yellow
    Write-Host ""
}


