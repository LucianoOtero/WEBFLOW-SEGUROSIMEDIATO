# ============================================================================
# SCRIPT: Backup do FooterCodeSiteDefinitivoCompleto.js em Produção
# ============================================================================
# Projeto: PROJETO_DEPLOY_FOOTERCODE_PROD_GCLID_20251123.md
# Versão: 1.0.0
# Data: 23/11/2025
# Ambiente: PRODUÇÃO (PROD)
# Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
# Objetivo: Criar backup completo do arquivo FooterCodeSiteDefinitivoCompleto.js antes do deploy
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [string]$Server = "157.180.36.223"
)

$ErrorActionPreference = "Stop"
$LogFile = "backup_footercode_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

$servidorProd = $Server
$caminhoProd = "/var/www/html/prod/root"
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"

# Arquivo a fazer backup
$arquivo = "FooterCodeSiteDefinitivoCompleto.js"

# ============================================================================
# FUNÇÕES DE LOG
# ============================================================================

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO", "WARN", "ERROR", "DEBUG", "SUCCESS")]
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    Add-Content -Path $LogFile -Value $logMessage
    
    if ($Verbose -or $Level -eq "ERROR" -or $Level -eq "WARN" -or $Level -eq "SUCCESS") {
        $color = switch ($Level) {
            "ERROR" { "Red" }
            "WARN" { "Yellow" }
            "SUCCESS" { "Green" }
            default { "White" }
        }
        Write-Host $logMessage -ForegroundColor $color
    }
}

# ============================================================================
# FUNÇÕES WRAPPER SSH
# ============================================================================

function Invoke-SafeSSHScript {
    param(
        [string]$ScriptContent,
        [string]$ScriptName = "temp_script.sh"
    )
    
    $tempScriptLocal = Join-Path $env:TEMP $ScriptName
    $tempScriptRemote = "/tmp/$ScriptName"
    
    Write-Log "Criando script temporário local: $tempScriptLocal" -Level "DEBUG"
    
    try {
        # Criar script temporário localmente (UTF8 sem BOM, com line endings Unix)
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        # Converter line endings para Unix (LF) antes de salvar
        $scriptContentUnix = $ScriptContent -replace "`r`n", "`n" -replace "`r", "`n"
        [System.IO.File]::WriteAllText($tempScriptLocal, $scriptContentUnix, $utf8NoBom)
        
        # Copiar para servidor via SCP
        Write-Log "Copiando script para servidor: $tempScriptRemote" -Level "DEBUG"
        scp $tempScriptLocal "root@${servidorProd}:${tempScriptRemote}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao copiar script para servidor"
        }
        
        # Tornar executável e executar
        $executeCommand = "chmod +x $tempScriptRemote && $tempScriptRemote"
        Write-Log "Executando script no servidor: $executeCommand" -Level "DEBUG"
        $result = ssh root@$servidorProd $executeCommand 2>&1
        $exitCode = $LASTEXITCODE
        
        # Remover script do servidor
        ssh root@$servidorProd "rm -f $tempScriptRemote" 2>&1 | Out-Null
        
        # Remover script local
        Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
        
        if ($exitCode -ne 0) {
            Write-Log "Erro ao executar script temporário (exit code: $exitCode)" -Level "ERROR"
            Write-Log "Saída do script: $result" -Level "ERROR"
            throw "Script execution failed with exit code $exitCode"
        }
        
        return $result
    } catch {
        # Limpar arquivo local em caso de erro
        Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
        Write-Log "Exceção ao executar script temporário: $_" -Level "ERROR"
        throw
    }
}

# ============================================================================
# FUNÇÃO PRINCIPAL: Criar Backup
# ============================================================================

function Start-Backup {
    Write-Log "========================================" -Level "INFO"
    Write-Log "INICIANDO BACKUP EM PRODUÇÃO" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN ATIVADO - Nenhuma modificação será realizada" -Level "WARN"
    }
    
    try {
        $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $backupDirRemote = "$caminhoProd/backups/deploy_footercode_$timestamp"
        $backupIndexFileRemote = "$backupDirRemote/backup_index.txt"
        
        Write-Log "Criando diretório de backup remoto: $backupDirRemote" -Level "INFO"
        if (-not $DryRun) {
            Invoke-SafeSSHScript -ScriptContent "mkdir -p $backupDirRemote" -ScriptName "mkdir_backup.sh" | Out-Null
        } else {
            Write-Log "[DRY-RUN] mkdir -p $backupDirRemote" -Level "INFO"
        }
        
        # Construir script bash usando here-string para evitar problemas de escape
        $backupScript = @"
#!/bin/bash
set -e

BACKUP_DIR="$backupDirRemote"
INDEX_FILE="$backupIndexFileRemote"
ORIGINAL_FILE="$caminhoProd/$arquivo"

echo "--- BACKUP INDEX ---" > "`$INDEX_FILE"
echo "Timestamp: `$(date '+%Y-%m-%d %H:%M:%S')" >> "`$INDEX_FILE"
echo "Arquivo: $arquivo" >> "`$INDEX_FILE"
echo "--------------------" >> "`$INDEX_FILE"

# Verificar se arquivo original existe
if [ ! -f "`$ORIGINAL_FILE" ]; then
    echo "ERRO: Arquivo original não encontrado: `$ORIGINAL_FILE"
    exit 1
fi

# Fazer backup do arquivo
cp "`$ORIGINAL_FILE" "`$BACKUP_DIR/$arquivo"

# Calcular hash SHA256
ORIG_HASH=`$(sha256sum "`$ORIGINAL_FILE" | cut -d' ' -f1)
BACK_HASH=`$(sha256sum "`$BACKUP_DIR/$arquivo" | cut -d' ' -f1)

echo "FILE: $arquivo" >> "`$INDEX_FILE"
echo "  ORIGINAL_PATH: `$ORIGINAL_FILE" >> "`$INDEX_FILE"
echo "  BACKUP_PATH: `$BACKUP_DIR/$arquivo" >> "`$INDEX_FILE"
echo "  ORIGINAL_HASH: `$ORIGINAL_HASH" >> "`$INDEX_FILE"
echo "  BACKUP_HASH: `$BACK_HASH" >> "`$INDEX_FILE"

# Verificar integridade do backup
if [ "`$ORIG_HASH" == "`$BACK_HASH" ]; then
    echo "  STATUS: OK" >> "`$INDEX_FILE"
    echo "BACKUP_OK=1"
else
    echo "  STATUS: ERROR" >> "`$INDEX_FILE"
    echo "BACKUP_ERROR=1"
    exit 1
fi

echo "BACKUP_DIR=`$BACKUP_DIR"
echo "BACKUP_FILE=`$BACKUP_DIR/$arquivo"
echo "ORIGINAL_HASH=`$ORIGINAL_HASH"
echo "BACKUP_HASH=`$BACK_HASH"

echo "=== CONCLUÍDO ==="
"@
        
        if (-not $DryRun) {
            $result = Invoke-SafeSSHScript -ScriptContent $backupScript -ScriptName "backup_footercode.sh"
            Write-Log "Backup remoto criado com sucesso" -Level "SUCCESS"
            
            # Processar resultado
            $resultLines = $result -split "`n"
            $backupDir = $null
            $backupFile = $null
            $originalHash = $null
            $backupHash = $null
            
            foreach ($line in $resultLines) {
                if ($line -match 'BACKUP_DIR=(.+)') {
                    $backupDir = $matches[1]
                    Write-Log "Diretório de backup: $backupDir" -Level "SUCCESS"
                }
                elseif ($line -match 'BACKUP_FILE=(.+)') {
                    $backupFile = $matches[1]
                    Write-Log "Arquivo de backup: $backupFile" -Level "INFO"
                }
                elseif ($line -match 'ORIGINAL_HASH=(.+)') {
                    $originalHash = $matches[1]
                    Write-Log "Hash SHA256 original: $originalHash" -Level "INFO"
                }
                elseif ($line -match 'BACKUP_HASH=(.+)') {
                    $backupHash = $matches[1]
                    Write-Log "Hash SHA256 backup: $backupHash" -Level "INFO"
                }
                elseif ($line -match 'BACKUP_OK=1') {
                    Write-Log "Integridade do backup validada: OK" -Level "SUCCESS"
                }
                elseif ($line -match 'BACKUP_ERROR=1') {
                    Write-Log "ERRO: Integridade do backup falhou" -Level "ERROR"
                    throw "Backup integrity validation failed"
                }
            }
            
            # Baixar o arquivo de índice para documentação local
            $localBackupIndexDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION"
            $localBackupIndexFile = Join-Path $localBackupIndexDir "backup_index_footercode_$timestamp.txt"
            
            Write-Log "Baixando índice de backup para: $localBackupIndexFile" -Level "INFO"
            scp "root@${servidorProd}:${backupIndexFileRemote}" $localBackupIndexFile 2>&1 | Out-Null
            
            if ($LASTEXITCODE -ne 0) {
                Write-Log "Falha ao baixar arquivo de índice de backup." -Level "WARN"
            } else {
                Write-Log "Índice de backup baixado com sucesso." -Level "SUCCESS"
            }
            
            # Criar documento de backup info
            $backupInfoFile = Join-Path $localBackupIndexDir "BACKUP_INFO_FOOTERCODE_$timestamp.md"
            $backupInfoContent = @"
# 📋 Informações de Backup - FooterCodeSiteDefinitivoCompleto.js

**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Projeto:** PROJETO_DEPLOY_FOOTERCODE_PROD_GCLID_20251123.md  
**Fase:** FASE 3 - Backup Completo em PROD

---

## 📊 INFORMAÇÕES DO BACKUP

- **Diretório de Backup:** `$backupDir`
- **Arquivo de Backup:** `$backupFile`
- **Hash SHA256 Original:** `$originalHash`
- **Hash SHA256 Backup:** `$backupHash`
- **Status:** ✅ OK (hashes coincidem)

---

## 📋 ARQUIVOS

- **Índice de Backup:** `backup_index_footercode_$timestamp.txt`
- **Documento de Informações:** `BACKUP_INFO_FOOTERCODE_$timestamp.md`

---

**Backup criado em:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
"@
            [System.IO.File]::WriteAllText($backupInfoFile, $backupInfoContent, (New-Object System.Text.UTF8Encoding $false))
            Write-Log "Documento de informações de backup criado: $backupInfoFile" -Level "SUCCESS"
            
        } else {
            Write-Log "[DRY-RUN] Backup completo simulado." -Level "INFO"
            Write-Log "[DRY-RUN] Diretório de backup remoto: $backupDirRemote" -Level "INFO"
            Write-Log "[DRY-RUN] Conteúdo do script bash de backup:" -Level "DEBUG"
            $backupScript | ForEach-Object { Write-Log "  $_" -Level "DEBUG" }
        }
        
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "BACKUP CONCLUÍDO COM SUCESSO" -Level "SUCCESS"
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "Log salvo em: $LogFile" -Level "INFO"
        
    } catch {
        Write-Log "ERRO CRÍTICO: $_" -Level "ERROR"
        Write-Log "Consulte o log: $LogFile" -Level "ERROR"
        throw
    }
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

Start-Backup
