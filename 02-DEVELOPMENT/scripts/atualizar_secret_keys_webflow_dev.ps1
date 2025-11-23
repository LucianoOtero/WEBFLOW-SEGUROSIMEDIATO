# ============================================================================
# SCRIPT: Atualizar Secret Keys Webflow em Desenvolvimento
# ============================================================================
# Projeto: PROJETO_ATUALIZAR_SECRET_KEYS_WEBFLOW_DEV_20251123.md
# Versão: 1.0.0
# Data: 23/11/2025
# Ambiente: DESENVOLVIMENTO (DEV)
# Servidor: dev.bssegurosimediato.com.br (IP: 65.108.156.14)
# Objetivo: Atualizar secret keys do Webflow no servidor DEV
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [string]$Server = "65.108.156.14"
)

$ErrorActionPreference = "Stop"
$LogFile = "atualizar_secret_keys_webflow_dev_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

$servidorDev = $Server
$configFile = "/etc/php/8.3/fpm/pool.d/www.conf"

# Variáveis a atualizar (modificar)
$variaveis_atualizar = @{
    'WEBFLOW_SECRET_FLYINGDONKEYS' = 'f7b51405e219164038394cf8f0c6b2f197d5a060f0959e3272570a4c10cf1678'
    'WEBFLOW_SECRET_OCTADESK' = '01956c927e436abf74efbd58b1e605b5b6f8f3da409e78241d32a34cec76d50d'
}

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
        # Criar script temporário localmente (UTF8 sem BOM)
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($tempScriptLocal, $ScriptContent, $utf8NoBom)
        
        # Copiar para servidor via SCP
        Write-Log "Copiando script para servidor: $tempScriptRemote" -Level "DEBUG"
        scp $tempScriptLocal "root@${servidorDev}:${tempScriptRemote}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao copiar script para servidor"
        }
        
        # Tornar executável e executar
        $executeCommand = "chmod +x $tempScriptRemote && $tempScriptRemote"
        Write-Log "Executando script no servidor: $executeCommand" -Level "DEBUG"
        $result = ssh root@$servidorDev $executeCommand 2>&1
        $exitCode = $LASTEXITCODE
        
        # Remover script do servidor
        ssh root@$servidorDev "rm -f $tempScriptRemote" 2>&1 | Out-Null
        
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
# FUNÇÃO: Criar e Executar Script de Atualização
# ============================================================================

function Invoke-UpdateSecretKeys {
    Write-Log "=== Criando Script Bash Completo ===" -Level "INFO"
    
    # Construir script bash completo
    $bashScriptLines = @(
        '#!/bin/bash',
        'set -e',
        '',
        '# Configurações',
        "CONFIG_FILE=`"$configFile`"",
        'TIMESTAMP=$(date +%Y%m%d_%H%M%S)',
        'BACKUP_FILE="${CONFIG_FILE}.backup_${TIMESTAMP}"',
        '',
        '# Criar backup',
        'cp "$CONFIG_FILE" "$BACKUP_FILE"',
        'if [ ! -f "$BACKUP_FILE" ]; then',
        '    echo "ERRO: Backup não foi criado"',
        '    exit 1',
        'fi',
        '',
        '# Calcular hash do backup',
        'BACKUP_HASH=$(sha256sum "$BACKUP_FILE" | cut -d'' '' -f1)',
        'ORIGINAL_HASH=$(sha256sum "$CONFIG_FILE" | cut -d'' '' -f1)',
        '',
        'echo "BACKUP_FILE=$BACKUP_FILE"',
        'echo "BACKUP_HASH=$BACKUP_HASH"',
        'echo "ORIGINAL_HASH=$ORIGINAL_HASH"',
        '',
        '# Função para modificar variável',
        'update_var() {',
        '    local VAR_NAME="$1"',
        '    local VAR_VALUE="$2"',
        '    if grep -q "env\[$VAR_NAME\]" "$CONFIG_FILE"; then',
        '        sed -i "s|env\[$VAR_NAME\].*|env[$VAR_NAME] = \"$VAR_VALUE\"|" "$CONFIG_FILE"',
        '        echo "UPDATED:$VAR_NAME"',
        '    else',
        '        echo "NOT_FOUND:$VAR_NAME"',
        '        exit 1',
        '    fi',
        '}',
        '',
        'echo "=== ATUALIZANDO VARIÁVEIS ==="',
        ''
    )
    
    # Adicionar comandos de atualização para cada variável
    foreach ($varName in $variaveis_atualizar.Keys) {
        $varValue = $variaveis_atualizar[$varName]
        $bashScriptLines += @(
            "update_var '$varName' '$varValue'"
        )
    }
    
    # Adicionar validações e recarga
    $bashScriptLines += @(
        '',
        'echo "=== VALIDANDO SINTAXE PHP-FPM ==="',
        'if ! php-fpm8.3 -tt > /dev/null 2>&1; then',
        '    echo "ERRO_SINTAXE=1"',
        '    exit 1',
        'fi',
        'echo "SINTAXE_OK=1"',
        '',
        'echo "=== VERIFICANDO VARIÁVEIS ATUALIZADAS ==="',
        'VARS_TO_CHECK=('
    )
    
    foreach ($varName in $variaveis_atualizar.Keys) {
        $bashScriptLines += "    '$varName'"
    }
    
    $varsPattern = $variaveis_atualizar.Keys -join '|'
    $bashScriptLines += @(
        ')',
        '',
        "php-fpm8.3 -tt 2>&1 | grep `"env\[`" | grep -E `"($varsPattern)`" > /tmp/vars_found.txt || true",
        '',
        'MISSING_VARS=()',
        'for VAR in "${VARS_TO_CHECK[@]}"; do',
        '    if ! grep -q "env\[$VAR\]" /tmp/vars_found.txt; then',
        '        MISSING_VARS+=("$VAR")',
        '    fi',
        'done',
        '',
        'rm -f /tmp/vars_found.txt',
        '',
        'if [ ${#MISSING_VARS[@]} -gt 0 ]; then',
        '    echo "VARIAVEIS_FALTANDO=${MISSING_VARS[*]}"',
        '    exit 1',
        'else',
        '    echo "TODAS_VARIAVEIS_PRESENTES=1"',
        'fi',
        '',
        'echo "=== RECARREGANDO PHP-FPM ==="',
        'if [ "$DRY_RUN" != "1" ]; then',
        '    systemctl reload php8.3-fpm',
        '    if [ $? -ne 0 ]; then',
        '        echo "ERRO_RECARGA=1"',
        '        exit 1',
        '    fi',
        '    STATUS=$(systemctl is-active php8.3-fpm)',
        '    if [ "$STATUS" != "active" ]; then',
        '        echo "ERRO_STATUS=1"',
        '        echo "STATUS_ATUAL=$STATUS"',
        '        exit 1',
        '    fi',
        '    echo "RECARGA_OK=1"',
        '    echo "STATUS=$STATUS"',
        'else',
        '    echo "DRY_RUN: Recarga não executada"',
        'fi',
        '',
        'echo "=== CONCLUÍDO ==="'
    )
    
    $bashScript = $bashScriptLines -join "`n"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN: Adicionando flag DRY_RUN=1 ao script" -Level "WARN"
        $bashScript = "DRY_RUN=1`n" + $bashScript
    }
    
    # Executar script
    Write-Log "Executando script de atualização no servidor DEV..." -Level "INFO"
    $result = Invoke-SafeSSHScript -ScriptContent $bashScript -ScriptName "update_secret_keys_dev.sh"
    
    return $result
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

function Start-UpdateSecretKeys {
    Write-Log "========================================" -Level "INFO"
    Write-Log "INICIANDO ATUALIZAÇÃO SECRET KEYS DEV" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN ATIVADO - Nenhuma modificação será realizada" -Level "WARN"
    }
    
    try {
        # Executar atualização
        $result = Invoke-UpdateSecretKeys
        
        # Processar resultado
        $resultLines = $result -split "`n"
        $backupFile = $null
        $backupHash = $null
        $originalHash = $null
        
        foreach ($line in $resultLines) {
            if ($line -match 'BACKUP_FILE=(.+)') {
                $backupFile = $matches[1]
                Write-Log "Backup criado: $backupFile" -Level "SUCCESS"
            }
            elseif ($line -match 'BACKUP_HASH=(.+)') {
                $backupHash = $matches[1]
            }
            elseif ($line -match 'ORIGINAL_HASH=(.+)') {
                $originalHash = $matches[1]
            }
            elseif ($line -match 'UPDATED:(.+)') {
                Write-Log "Variável atualizada: $($matches[1])" -Level "SUCCESS"
            }
            elseif ($line -match 'NOT_FOUND:(.+)') {
                Write-Log "ERRO: Variável não encontrada: $($matches[1])" -Level "ERROR"
                throw "Variável não encontrada: $($matches[1])"
            }
            elseif ($line -match 'SINTAXE_OK=1') {
                Write-Log "Sintaxe PHP-FPM validada com sucesso" -Level "SUCCESS"
            }
            elseif ($line -match 'ERRO_SINTAXE=1') {
                Write-Log "ERRO: Sintaxe PHP-FPM inválida" -Level "ERROR"
                throw "Sintaxe PHP-FPM inválida"
            }
            elseif ($line -match 'TODAS_VARIAVEIS_PRESENTES=1') {
                Write-Log "Todas as variáveis estão presentes e corretas" -Level "SUCCESS"
            }
            elseif ($line -match 'VARIAVEIS_FALTANDO=(.+)') {
                Write-Log "ERRO: Variáveis faltando: $($matches[1])" -Level "ERROR"
                throw "Variáveis faltando: $($matches[1])"
            }
            elseif ($line -match 'RECARGA_OK=1') {
                Write-Log "PHP-FPM recarregado com sucesso" -Level "SUCCESS"
            }
            elseif ($line -match 'STATUS=(.+)') {
                Write-Log "Status PHP-FPM: $($matches[1])" -Level "INFO"
            }
            elseif ($line -match 'ERRO_RECARGA=1') {
                Write-Log "ERRO: Falha ao recarregar PHP-FPM" -Level "ERROR"
                throw "Falha ao recarregar PHP-FPM"
            }
            elseif ($line -match 'ERRO_STATUS=1') {
                Write-Log "ERRO: Status PHP-FPM inválido após recarga" -Level "ERROR"
                throw "Status PHP-FPM inválido"
            }
        }
        
        # Validar hash do backup
        if ($backupHash -and $originalHash) {
            if ($backupHash -eq $originalHash) {
                Write-Log "Hash do backup validado: $backupHash" -Level "SUCCESS"
            } else {
                Write-Log "AVISO: Hash do backup não coincide com original" -Level "WARN"
                Write-Log "  Backup: $backupHash" -Level "WARN"
                Write-Log "  Original: $originalHash" -Level "WARN"
            }
        }
        
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "ATUALIZAÇÃO CONCLUÍDA COM SUCESSO" -Level "SUCCESS"
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "Log salvo em: $LogFile" -Level "INFO"
        if ($backupFile) {
            Write-Log "Backup criado em: $backupFile" -Level "INFO"
        }
        
    } catch {
        Write-Log "ERRO CRÍTICO: $_" -Level "ERROR"
        Write-Log "Consulte o log: $LogFile" -Level "ERROR"
        throw
    }
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

Start-UpdateSecretKeys

