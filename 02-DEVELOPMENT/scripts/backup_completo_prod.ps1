# ============================================================================
# SCRIPT: Backup Completo de Arquivos em Produção
# ============================================================================
# Projeto: PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md
# Versão: 1.0.0
# Data: 23/11/2025
# Ambiente: PRODUÇÃO (PROD)
# Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
# Objetivo: Criar backup completo de todos os arquivos antes do deploy
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [string]$Server = "157.180.36.223"
)

$ErrorActionPreference = "Stop"
$LogFile = "backup_completo_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

$servidorProd = $Server
$caminhoProd = "/var/www/html/prod/root"
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"

# Arquivos a fazer backup
$arquivosJS = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js"
)

$arquivosPHP = @(
    "config.php",
    "config_env.js.php",
    "add_webflow_octa.php",
    "add_flyingdonkeys.php",
    "cpf-validate.php",
    "placa-validate.php",
    "log_endpoint.php",
    "ProfessionalLogger.php",
    "aws_ses_config.php"
)

$todosArquivos = $arquivosJS + $arquivosPHP

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
# FUNÇÃO: Executar Script Bash no Servidor
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
        # Criar script temporário localmente (sem BOM para compatibilidade Linux)
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($tempScriptLocal, $ScriptContent, $utf8NoBom)
        
        # Copiar para servidor via SCP
        Write-Log "Copiando script para servidor: $tempScriptRemote" -Level "DEBUG"
        scp $tempScriptLocal "root@${servidorProd}:${tempScriptRemote}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao copiar script para servidor"
        }
        
        # Tornar executável e executar
        $executeCommand = "chmod +x $tempScriptRemote && $tempScriptRemote"
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
# FUNÇÃO: Criar Backup Completo
# ============================================================================

function New-CompleteBackup {
    Write-Log "=== Criando Backup Completo em PROD ===" -Level "INFO"
    
    # Construir script bash completo para backup
    $backupScriptLines = @(
        '#!/bin/bash',
        'set -e',
        '',
        '# Configurações',
        "PROD_PATH=`"$caminhoProd`"",
        'TIMESTAMP=$(date +%Y%m%d_%H%M%S)',
        'BACKUP_DIR="${PROD_PATH}/backups/deploy_${TIMESTAMP}"',
        '',
        '# Criar diretório de backup',
        'mkdir -p "$BACKUP_DIR"',
        'if [ ! -d "$BACKUP_DIR" ]; then',
        '    echo "ERRO: Diretório de backup não foi criado"',
        '    exit 1',
        'fi',
        '',
        '# Arquivos JavaScript',
        'JS_FILES=(',
        '    "FooterCodeSiteDefinitivoCompleto.js"',
        '    "MODAL_WHATSAPP_DEFINITIVO.js"',
        '    "webflow_injection_limpo.js"',
        ')',
        '',
        '# Arquivos PHP',
        'PHP_FILES=(',
        '    "config.php"',
        '    "config_env.js.php"',
        '    "add_webflow_octa.php"',
        '    "add_flyingdonkeys.php"',
        '    "cpf-validate.php"',
        '    "placa-validate.php"',
        '    "log_endpoint.php"',
        '    "ProfessionalLogger.php"',
        '    "aws_ses_config.php"',
        ')',
        '',
        'echo "BACKUP_DIR=$BACKUP_DIR"',
        'echo "TIMESTAMP=$TIMESTAMP"',
        '',
        '# Fazer backup de arquivos JavaScript',
        'echo "=== BACKUP ARQUIVOS JAVASCRIPT ==="',
        'for FILE in "${JS_FILES[@]}"; do',
        '    SOURCE="${PROD_PATH}/${FILE}"',
        '    DEST="${BACKUP_DIR}/${FILE}"',
        '    ',
        '    if [ -f "$SOURCE" ]; then',
        '        cp "$SOURCE" "$DEST"',
        '        if [ ! -f "$DEST" ]; then',
        '            echo "ERRO: Backup de $FILE falhou"',
        '            exit 1',
        '        fi',
        '        ',
        '        # Calcular hash SHA256 do original e do backup',
        '        ORIGINAL_HASH=$(sha256sum "$SOURCE" | cut -d'' '' -f1)',
        '        BACKUP_HASH=$(sha256sum "$DEST" | cut -d'' '' -f1)',
        '        ',
        '        if [ "$ORIGINAL_HASH" != "$BACKUP_HASH" ]; then',
        '            echo "ERRO: Hash não coincide para $FILE"',
        '            echo "ORIGINAL_HASH=$ORIGINAL_HASH"',
        '            echo "BACKUP_HASH=$BACKUP_HASH"',
        '            exit 1',
        '        fi',
        '        ',
        '        echo "BACKUP_JS:$FILE:$ORIGINAL_HASH:$BACKUP_HASH"',
        '    else',
        '        echo "AVISO: Arquivo $FILE não existe em PROD"',
        '        echo "MISSING_JS:$FILE"',
        '    fi',
        'done',
        '',
        '# Fazer backup de arquivos PHP',
        'echo "=== BACKUP ARQUIVOS PHP ==="',
        'for FILE in "${PHP_FILES[@]}"; do',
        '    SOURCE="${PROD_PATH}/${FILE}"',
        '    DEST="${BACKUP_DIR}/${FILE}"',
        '    ',
        '    if [ -f "$SOURCE" ]; then',
        '        cp "$SOURCE" "$DEST"',
        '        if [ ! -f "$DEST" ]; then',
        '            echo "ERRO: Backup de $FILE falhou"',
        '            exit 1',
        '        fi',
        '        ',
        '        # Calcular hash SHA256 do original e do backup',
        '        ORIGINAL_HASH=$(sha256sum "$SOURCE" | cut -d'' '' -f1)',
        '        BACKUP_HASH=$(sha256sum "$DEST" | cut -d'' '' -f1)',
        '        ',
        '        if [ "$ORIGINAL_HASH" != "$BACKUP_HASH" ]; then',
        '            echo "ERRO: Hash não coincide para $FILE"',
        '            echo "ORIGINAL_HASH=$ORIGINAL_HASH"',
        '            echo "BACKUP_HASH=$BACKUP_HASH"',
        '            exit 1',
        '        fi',
        '        ',
        '        echo "BACKUP_PHP:$FILE:$ORIGINAL_HASH:$BACKUP_HASH"',
        '    else',
        '        echo "AVISO: Arquivo $FILE não existe em PROD"',
        '        echo "MISSING_PHP:$FILE"',
        '    fi',
        'done',
        '',
        '# Criar arquivo de índice de backups',
        'INDEX_FILE="${BACKUP_DIR}/backup_index.txt"',
        'echo "# Índice de Backup - Deploy PROD" > "$INDEX_FILE"',
        'echo "# Data: $(date)" >> "$INDEX_FILE"',
        'echo "# Timestamp: $TIMESTAMP" >> "$INDEX_FILE"',
        'echo "" >> "$INDEX_FILE"',
        'echo "## Arquivos JavaScript" >> "$INDEX_FILE"',
        'for FILE in "${JS_FILES[@]}"; do',
        '    if [ -f "${PROD_PATH}/${FILE}" ]; then',
        '        HASH=$(sha256sum "${PROD_PATH}/${FILE}" | cut -d'' '' -f1)',
        '        echo "$FILE:$HASH" >> "$INDEX_FILE"',
        '    fi',
        'done',
        'echo "" >> "$INDEX_FILE"',
        'echo "## Arquivos PHP" >> "$INDEX_FILE"',
        'for FILE in "${PHP_FILES[@]}"; do',
        '    if [ -f "${PROD_PATH}/${FILE}" ]; then',
        '        HASH=$(sha256sum "${PROD_PATH}/${FILE}" | cut -d'' '' -f1)',
        '        echo "$FILE:$HASH" >> "$INDEX_FILE"',
        '    fi',
        'done',
        '',
        'echo "INDEX_FILE=$INDEX_FILE"',
        'echo "=== BACKUP CONCLUÍDO ==="'
    )
    
    $backupScript = $backupScriptLines -join "`n"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN: Simulando criação de backup" -Level "WARN"
        Write-Log "Script bash que seria executado:" -Level "INFO"
        Write-Log $backupScript -Level "DEBUG"
        return @{
            BackupDir = "/var/www/html/prod/root/backups/deploy_DRYRUN"
            Timestamp = "DRYRUN"
            Files = @()
        }
    }
    
    try {
        Write-Log "Executando script de backup no servidor..." -Level "INFO"
        $result = Invoke-SafeSSHScript -ScriptContent $backupScript -ScriptName "backup_completo_prod.sh"
        
        # Processar resultado
        $backupInfo = @{
            BackupDir = ""
            Timestamp = ""
            IndexFile = ""
            Files = @()
            MissingFiles = @()
        }
        
        $result | ForEach-Object {
            if ($_ -match '^BACKUP_DIR=(.+)$') {
                $backupInfo['BackupDir'] = $matches[1]
            } elseif ($_ -match '^TIMESTAMP=(.+)$') {
                $backupInfo['Timestamp'] = $matches[1]
            } elseif ($_ -match '^BACKUP_JS:(.+):(.+):(.+)$') {
                $fileName = $matches[1]
                $originalHash = $matches[2]
                $backupHash = $matches[3]
                $backupInfo['Files'] += @{
                    File = $fileName
                    Type = "JS"
                    OriginalHash = $originalHash
                    BackupHash = $backupHash
                    Status = "OK"
                }
            } elseif ($_ -match '^BACKUP_PHP:(.+):(.+):(.+)$') {
                $fileName = $matches[1]
                $originalHash = $matches[2]
                $backupHash = $matches[3]
                $backupInfo['Files'] += @{
                    File = $fileName
                    Type = "PHP"
                    OriginalHash = $originalHash
                    BackupHash = $backupHash
                    Status = "OK"
                }
            } elseif ($_ -match '^MISSING_JS:(.+)$') {
                $backupInfo['MissingFiles'] += @{
                    File = $matches[1]
                    Type = "JS"
                }
            } elseif ($_ -match '^MISSING_PHP:(.+)$') {
                $backupInfo['MissingFiles'] += @{
                    File = $matches[1]
                    Type = "PHP"
                }
            } elseif ($_ -match '^INDEX_FILE=(.+)$') {
                $backupInfo['IndexFile'] = $matches[1]
            }
        }
        
        Write-Log "=== RESUMO DO BACKUP ===" -Level "INFO"
        Write-Log "Diretório de backup: $($backupInfo['BackupDir'])" -Level "SUCCESS"
        Write-Log "Timestamp: $($backupInfo['Timestamp'])" -Level "INFO"
        Write-Log "Arquivos com backup: $($backupInfo['Files'].Count)" -Level "SUCCESS"
        Write-Log "Arquivos não encontrados: $($backupInfo['MissingFiles'].Count)" -Level "WARN"
        
        if ($backupInfo['Files'].Count -gt 0) {
            Write-Log "Arquivos com backup criado:" -Level "INFO"
            foreach ($file in $backupInfo['Files']) {
                Write-Log "  - $($file.File) ($($file.Type)) - Hash: $($file.OriginalHash)" -Level "INFO"
            }
        }
        
        if ($backupInfo['MissingFiles'].Count -gt 0) {
            Write-Log "Arquivos não encontrados em PROD:" -Level "WARN"
            foreach ($file in $backupInfo['MissingFiles']) {
                Write-Log "  - $($file.File) ($($file.Type))" -Level "WARN"
            }
        }
        
        if ($backupInfo['IndexFile']) {
            Write-Log "Arquivo de índice criado: $($backupInfo['IndexFile'])" -Level "SUCCESS"
        }
        
        return $backupInfo
        
    } catch {
        Write-Log "Erro ao criar backup: $_" -Level "ERROR"
        throw
    }
}

# ============================================================================
# FUNÇÃO: Validar Backup
# ============================================================================

function Test-BackupIntegrity {
    param(
        [hashtable]$BackupInfo
    )
    
    Write-Log "=== Validando Integridade do Backup ===" -Level "INFO"
    
    if ($BackupInfo['Files'].Count -eq 0) {
        Write-Log "AVISO: Nenhum arquivo foi feito backup" -Level "WARN"
        return $false
    }
    
    $allValid = $true
    foreach ($file in $BackupInfo['Files']) {
        if ($file.OriginalHash -ne $file.BackupHash) {
            Write-Log "ERRO: Hash não coincide para $($file.File)" -Level "ERROR"
            Write-Log "  Original: $($file.OriginalHash)" -Level "ERROR"
            Write-Log "  Backup: $($file.BackupHash)" -Level "ERROR"
            $allValid = $false
        } else {
            Write-Log "✅ $($file.File) - Hash validado" -Level "SUCCESS"
        }
    }
    
    if ($allValid) {
        Write-Log "Todos os backups têm hash SHA256 idêntico aos originais" -Level "SUCCESS"
    } else {
        Write-Log "ERRO: Alguns backups têm hash diferente dos originais" -Level "ERROR"
    }
    
    return $allValid
}

# ============================================================================
# FUNÇÃO: Salvar Informações do Backup Localmente
# ============================================================================

function Save-BackupInfo {
    param(
        [hashtable]$BackupInfo
    )
    
    $docDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION"
    
    # Criar diretório se não existir
    if (-not (Test-Path $docDir)) {
        New-Item -ItemType Directory -Path $docDir -Force | Out-Null
    }
    
    $backupInfoFile = Join-Path $docDir "BACKUP_INFO_DEPLOY_$($BackupInfo['Timestamp']).md"
    
    $content = @"
# 📋 Informações do Backup - Deploy PROD

**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Timestamp:** $($BackupInfo['Timestamp'])  
**Diretório de Backup:** $($BackupInfo['BackupDir'])  
**Arquivo de Índice:** $($BackupInfo['IndexFile'])

---

## 📊 RESUMO

- **Arquivos com Backup:** $($BackupInfo['Files'].Count)
- **Arquivos Não Encontrados:** $($backupInfo['MissingFiles'].Count)

---

## 📁 ARQUIVOS COM BACKUP

### Arquivos JavaScript

| Arquivo | Hash SHA256 Original | Hash SHA256 Backup | Status |
|---------|---------------------|-------------------|--------|
"@
    
    foreach ($file in $BackupInfo['Files'] | Where-Object { $_.Type -eq "JS" }) {
        $status = if ($file.OriginalHash -eq $file.BackupHash) { "✅ OK" } else { "❌ ERRO" }
        $content += "`n| $($file.File) | $($file.OriginalHash) | $($file.BackupHash) | $status |"
    }
    
    $content += @"

### Arquivos PHP

| Arquivo | Hash SHA256 Original | Hash SHA256 Backup | Status |
|---------|---------------------|-------------------|--------|
"@
    
    foreach ($file in $BackupInfo['Files'] | Where-Object { $_.Type -eq "PHP" }) {
        $status = if ($file.OriginalHash -eq $file.BackupHash) { "✅ OK" } else { "❌ ERRO" }
        $content += "`n| $($file.File) | $($file.OriginalHash) | $($file.BackupHash) | $status |"
    }
    
    if ($BackupInfo['MissingFiles'].Count -gt 0) {
        $content += @"

---

## ⚠️ ARQUIVOS NÃO ENCONTRADOS

| Arquivo | Tipo |
|---------|------|
"@
        foreach ($file in $BackupInfo['MissingFiles']) {
            $content += "`n| $($file.File) | $($file.Type) |"
        }
    }
    
    $content += @"

---

## 📝 OBSERVAÇÕES

- Todos os arquivos encontrados foram copiados para backup
- Hash SHA256 validado para garantir integridade
- Arquivo de índice criado em: $($BackupInfo['IndexFile'])

---

**Backup criado em:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Script:** backup_completo_prod.ps1 v1.0.0
"@
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($backupInfoFile, $content, $utf8NoBom)
    
    Write-Log "Informações do backup salvas em: $backupInfoFile" -Level "SUCCESS"
    
    return $backupInfoFile
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

function Start-BackupProcess {
    Write-Log "========================================" -Level "INFO"
    Write-Log "INICIANDO BACKUP COMPLETO EM PROD" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN ATIVADO - Nenhum backup será criado" -Level "WARN"
    }
    
    try {
        # Criar backup completo
        $backupInfo = New-CompleteBackup
        
        if (-not $DryRun) {
            # Validar integridade do backup
            $isValid = Test-BackupIntegrity -BackupInfo $backupInfo
            
            if (-not $isValid) {
                Write-Log "ERRO: Integridade do backup não validada" -Level "ERROR"
                throw "Backup integrity validation failed"
            }
            
            # Salvar informações do backup localmente
            $infoFile = Save-BackupInfo -BackupInfo $backupInfo
            
            Write-Log "========================================" -Level "SUCCESS"
            Write-Log "BACKUP COMPLETO CRIADO COM SUCESSO" -Level "SUCCESS"
            Write-Log "========================================" -Level "SUCCESS"
            Write-Log "Diretório de backup: $($backupInfo['BackupDir'])" -Level "INFO"
            Write-Log "Arquivos com backup: $($backupInfo['Files'].Count)" -Level "INFO"
            Write-Log "Informações salvas em: $infoFile" -Level "INFO"
            Write-Log "Log salvo em: $LogFile" -Level "INFO"
        } else {
            Write-Log "========================================" -Level "INFO"
            Write-Log "DRY-RUN CONCLUÍDO" -Level "INFO"
            Write-Log "========================================" -Level "INFO"
        }
        
        return $backupInfo
        
    } catch {
        Write-Log "ERRO CRÍTICO: $_" -Level "ERROR"
        Write-Log "Consulte o log: $LogFile" -Level "ERROR"
        throw
    }
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

Start-BackupProcess

