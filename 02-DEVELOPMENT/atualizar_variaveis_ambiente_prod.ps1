# ============================================================================
# SCRIPT: Atualizar Variáveis de Ambiente em Produção (Versão Otimizada)
# ============================================================================
# Projeto: PROJETO_ATUALIZAR_VARIAVEIS_AMBIENTE_PROD_20251122.md
# Versão: 2.0.0
# Data: 23/11/2025
# Ambiente: PRODUÇÃO (PROD)
# Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
# Otimização: Executa todas as operações em um único script bash no servidor
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [string]$Server = "157.180.36.223"
)

$ErrorActionPreference = "Stop"
$LogFile = "atualizar_variaveis_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

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
# VARIÁVEIS A PROCESSAR
# ============================================================================

# Variáveis a adicionar (20 variáveis)
$variaveis_adicionar = @{
    # CRÍTICO (3 variáveis)
    'APILAYER_KEY' = 'dce92fa84152098a3b5b7b8db24debbc'
    'SAFETY_TICKET' = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'
    'SAFETY_API_KEY' = '20a7a1c297e39180bd80428ac13c363e882a531f'
    
    # ALTO (13 variáveis)
    'AWS_SES_FROM_NAME' = 'BP Seguros Imediato'
    'VIACEP_BASE_URL' = 'https://viacep.com.br'
    'APILAYER_BASE_URL' = 'https://apilayer.net'
    'SAFETYMAILS_OPTIN_BASE' = 'https://optin.safetymails.com'
    'RPA_API_BASE_URL' = 'https://rpaimediatoseguros.com.br'
    'SAFETYMAILS_BASE_DOMAIN' = 'safetymails.com'
    'PH3A_API_KEY' = '691dd2aa-9af4-84f2-06f9-350e1d709602'
    'PH3A_DATA_URL' = 'https://api.ph3a.com.br/DataBusca/api/Data/GetData'
    'PH3A_LOGIN_URL' = 'https://api.ph3a.com.br/DataBusca/api/Account/Login'
    'PH3A_PASSWORD' = 'ImdSeg2025$$'
    'PH3A_USERNAME' = 'alex.kaminski@imediatoseguros.com.br'
    'PLACAFIPE_API_TOKEN' = '1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214'
    'PLACAFIPE_API_URL' = 'https://api.placafipe.com.br/getplaca'
    'SUCCESS_PAGE_URL' = 'https://www.segurosimediato.com.br/sucesso'
    
    # MÉDIO (4 variáveis)
    'RPA_ENABLED' = 'false'
    'USE_PHONE_API' = 'true'
    'VALIDAR_PH3A' = 'false'
    'OCTADESK_FROM' = '+551132301422'
}

# Variável a modificar (1 variável)
$variavel_modificar = @{
    'AWS_SES_FROM_EMAIL' = 'noreply@bpsegurosimediato.com.br'
}

# ============================================================================
# FUNÇÃO: Criar e Executar Script Bash Completo
# ============================================================================

function Invoke-CompleteUpdateScript {
    Write-Log "=== Criando Script Bash Completo ===" -Level "INFO"
    
    # Construir script bash completo
    $bashScriptLines = @(
        '#!/bin/bash',
        'set -e',
        '',
        '# Configurações',
        'CONFIG_FILE="/etc/php/8.3/fpm/pool.d/www.conf"',
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
        '# Função para adicionar variável se não existir',
        'add_var_if_not_exists() {',
        '    local VAR_NAME="$1"',
        '    local VAR_VALUE="$2"',
        '    if ! grep -q "env\[$VAR_NAME\]" "$CONFIG_FILE"; then',
        '        echo "env[$VAR_NAME] = \"$VAR_VALUE\"" >> "$CONFIG_FILE"',
        '        echo "ADDED:$VAR_NAME"',
        '    else',
        '        echo "EXISTS:$VAR_NAME"',
        '    fi',
        '}',
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
        'echo "=== ADICIONANDO VARIÁVEIS ==="',
        ''
    )
    
    # Adicionar comandos para cada variável
    foreach ($var in $variaveis_adicionar.GetEnumerator()) {
        $escapedValue = $var.Value -replace '\$', '\$' -replace '`', '\`' -replace '"', '\"'
        $bashScriptLines += "add_var_if_not_exists `"$($var.Key)`" `"$escapedValue`""
    }
    
    $bashScriptLines += @(
        '',
        'echo "=== MODIFICANDO VARIÁVEL ==="',
        ''
    )
    
    # Adicionar comando para modificar variável
    $escapedModifyValue = $variavel_modificar['AWS_SES_FROM_EMAIL'] -replace '\$', '\$' -replace '`', '\`' -replace '"', '\"'
    $bashScriptLines += "update_var `"AWS_SES_FROM_EMAIL`" `"$escapedModifyValue`""
    
    $bashScriptLines += @(
        '',
        'echo "=== VALIDANDO SINTAXE ==="',
        'if ! php-fpm8.3 -tt > /dev/null 2>&1; then',
        '    echo "ERRO_SINTAXE=1"',
        '    exit 1',
        'fi',
        'echo "SINTAXE_OK=1"',
        '',
        'echo "=== VERIFICANDO VARIÁVEIS ==="',
        'VARS_TO_CHECK=(',
        '    "APILAYER_KEY"',
        '    "SAFETY_TICKET"',
        '    "SAFETY_API_KEY"',
        '    "AWS_SES_FROM_NAME"',
        '    "VIACEP_BASE_URL"',
        '    "APILAYER_BASE_URL"',
        '    "SAFETYMAILS_OPTIN_BASE"',
        '    "RPA_API_BASE_URL"',
        '    "SAFETYMAILS_BASE_DOMAIN"',
        '    "PH3A_API_KEY"',
        '    "PH3A_DATA_URL"',
        '    "PH3A_LOGIN_URL"',
        '    "PH3A_PASSWORD"',
        '    "PH3A_USERNAME"',
        '    "PLACAFIPE_API_TOKEN"',
        '    "PLACAFIPE_API_URL"',
        '    "SUCCESS_PAGE_URL"',
        '    "RPA_ENABLED"',
        '    "USE_PHONE_API"',
        '    "VALIDAR_PH3A"',
        '    "OCTADESK_FROM"',
        '    "AWS_SES_FROM_EMAIL"',
        ')',
        '',
        'php-fpm8.3 -tt 2>&1 | grep ''env\['' > /tmp/vars_found.txt',
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
        $bashScript = $bashScript -replace 'DRY_RUN" != "1"', 'DRY_RUN" == "1"'
        $bashScript = "DRY_RUN=1`n" + $bashScript
    }
    
    # Salvar script localmente
    $tempScriptLocal = Join-Path $env:TEMP "update_vars_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').sh"
    $tempScriptRemote = "/tmp/update_vars_prod.sh"
    
    Write-Log "Salvando script localmente: $tempScriptLocal" -Level "DEBUG"
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($tempScriptLocal, $bashScript, $utf8NoBom)
    
    try {
        # Copiar para servidor
        Write-Log "Copiando script para servidor: $tempScriptRemote" -Level "INFO"
        scp $tempScriptLocal "root@${Server}:${tempScriptRemote}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao copiar script para servidor"
        }
        
        # Tornar executável e executar
        Write-Log "Executando script no servidor..." -Level "INFO"
        $result = ssh root@$Server "chmod +x $tempScriptRemote && $tempScriptRemote" 2>&1
        $exitCode = $LASTEXITCODE
        
        # Remover script do servidor
        ssh root@$Server "rm -f $tempScriptRemote" 2>&1 | Out-Null
        
        # Remover script local
        Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
        
        if ($exitCode -ne 0) {
            Write-Log "Erro ao executar script (exit code: $exitCode)" -Level "ERROR"
            Write-Log "Saída do script: $result" -Level "ERROR"
            throw "Script execution failed with exit code $exitCode"
        }
        
        # Processar resultado
        $backupInfo = @{}
        $addedVars = @()
        $existingVars = @()
        $updatedVars = @()
        
        $result | ForEach-Object {
            if ($_ -match '^BACKUP_FILE=(.+)$') {
                $backupInfo['BACKUP_FILE'] = $matches[1]
            } elseif ($_ -match '^BACKUP_HASH=(.+)$') {
                $backupInfo['BACKUP_HASH'] = $matches[1]
            } elseif ($_ -match '^ORIGINAL_HASH=(.+)$') {
                $backupInfo['ORIGINAL_HASH'] = $matches[1]
            } elseif ($_ -match '^ADDED:(.+)$') {
                $addedVars += $matches[1]
            } elseif ($_ -match '^EXISTS:(.+)$') {
                $existingVars += $matches[1]
            } elseif ($_ -match '^UPDATED:(.+)$') {
                $updatedVars += $matches[1]
            } elseif ($_ -match '^NOT_FOUND:(.+)$') {
                Write-Log "Variável não encontrada para modificação: $($matches[1])" -Level "ERROR"
            } elseif ($_ -match '^ERRO_') {
                Write-Log "Erro detectado: $_" -Level "ERROR"
            } elseif ($_ -match '^SINTAXE_OK=1$') {
                Write-Log "Sintaxe validada com sucesso" -Level "SUCCESS"
            } elseif ($_ -match '^TODAS_VARIAVEIS_PRESENTES=1$') {
                Write-Log "Todas as variáveis estão presentes" -Level "SUCCESS"
            } elseif ($_ -match '^RECARGA_OK=1$') {
                Write-Log "PHP-FPM recarregado com sucesso" -Level "SUCCESS"
            }
        }
        
        Write-Log "=== RESUMO DA EXECUÇÃO ===" -Level "INFO"
        Write-Log "Backup criado: $($backupInfo['BACKUP_FILE'])" -Level "SUCCESS"
        Write-Log "Hash original: $($backupInfo['ORIGINAL_HASH'])" -Level "INFO"
        Write-Log "Hash backup: $($backupInfo['BACKUP_HASH'])" -Level "INFO"
        Write-Log "Variáveis adicionadas: $($addedVars.Count)" -Level "SUCCESS"
        if ($addedVars.Count -gt 0) {
            Write-Log "  - $($addedVars -join ', ')" -Level "INFO"
        }
        Write-Log "Variáveis que já existiam: $($existingVars.Count)" -Level "WARN"
        Write-Log "Variáveis modificadas: $($updatedVars.Count)" -Level "SUCCESS"
        if ($updatedVars.Count -gt 0) {
            Write-Log "  - $($updatedVars -join ', ')" -Level "INFO"
        }
        
        return @{
            BackupInfo = $backupInfo
            AddedVars = $addedVars
            ExistingVars = $existingVars
            UpdatedVars = $updatedVars
            Result = $result
        }
        
    } catch {
        # Limpar arquivo local em caso de erro
        Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
        Write-Log "Exceção ao executar script: $_" -Level "ERROR"
        throw
    }
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

function Start-UpdateProcess {
    Write-Log "========================================" -Level "INFO"
    Write-Log "INICIANDO ATUALIZAÇÃO DE VARIÁVEIS PROD" -Level "INFO"
    Write-Log "Versão Otimizada - Execução em lote" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN ATIVADO - Nenhuma modificação será realizada" -Level "WARN"
    }
    
    try {
        $result = Invoke-CompleteUpdateScript
        
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "ATUALIZAÇÃO CONCLUÍDA COM SUCESSO" -Level "SUCCESS"
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "Log salvo em: $LogFile" -Level "INFO"
        
        return $result
        
    } catch {
        Write-Log "ERRO CRÍTICO: $_" -Level "ERROR"
        Write-Log "Consulte o log: $LogFile" -Level "ERROR"
        Write-Log "Execute rollback se necessário" -Level "ERROR"
        throw
    }
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

Start-UpdateProcess

