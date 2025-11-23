# ============================================================================
# SCRIPT: Atualizar Variável SafetyMails SAFETY_TICKET em Produção
# ============================================================================
# Projeto: PROJETO_ATUALIZAR_SAFETYMAILS_PROD_V2_20251123.md
# Versão: 1.0.0
# Data: 23/11/2025
# Ambiente: PRODUÇÃO (PROD)
# Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
# Diretiva: NUNCA modificar arquivos diretamente no servidor
# Processo: Baixar → Modificar Localmente → Backup → Copiar → Validar
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [string]$Server = "157.180.36.223"
)

$ErrorActionPreference = "Stop"
$LogFile = "atualizar_safetymails_prod_v2_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

$servidorProd = $Server
$configFileRemote = "/etc/php/8.3/fpm/pool.d/www.conf"
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$tmpDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\TMP"

# Valores
$safetyTicketAtual = "05bf2ec47128ca0b917f8b955bada1bd3cadd47e"
$safetyTicketNovo = "9bab7f0c2711c5accfb83588c859dc1103844a94"
$safetyApiKeyEsperada = "20a7a1c297e39180bd80428ac13c363e882a531f"

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
        # Criar script temporário localmente (UTF8 sem BOM, com quebras de linha Unix)
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        # Converter quebras de linha para Unix (LF)
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
# FUNÇÃO: Baixar Arquivo do Servidor para Local
# ============================================================================

function Download-PhpFpmConfig {
    Write-Log "=== FASE 1: Baixar Arquivo do Servidor ===" -Level "INFO"
    
    $configFileLocal = Join-Path $tmpDir "www.conf.prod.original"
    
    # Criar diretório TMP se não existir
    if (-not (Test-Path $tmpDir)) {
        New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
        Write-Log "Diretório TMP criado: $tmpDir" -Level "INFO"
    }
    
    if ($DryRun) {
        Write-Log "[DRY-RUN] Baixaria arquivo de ${servidorProd}:${configFileRemote} para $configFileLocal" -Level "INFO"
        return $configFileLocal
    }
    
    Write-Log "Baixando arquivo de ${servidorProd}:${configFileRemote}..." -Level "INFO"
    scp "root@${servidorProd}:${configFileRemote}" $configFileLocal 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao baixar arquivo do servidor"
    }
    
    if (-not (Test-Path $configFileLocal)) {
        throw "Arquivo não foi baixado corretamente"
    }
    
    Write-Log "Arquivo baixado com sucesso: $configFileLocal" -Level "SUCCESS"
    
    # Calcular hash do arquivo baixado
    $hashLocal = (Get-FileHash -Path $configFileLocal -Algorithm SHA256).Hash
    Write-Log "Hash SHA256 do arquivo baixado: $hashLocal" -Level "INFO"
    
    return $configFileLocal
}

# ============================================================================
# FUNÇÃO: Modificar Arquivo Localmente
# ============================================================================

function Modify-SafetyTicket {
    param(
        [string]$ConfigFileLocal
    )
    
    Write-Log "=== FASE 2: Modificar Arquivo Localmente ===" -Level "INFO"
    
    $configFileModified = Join-Path $tmpDir "www.conf.prod.modified"
    
    if ($DryRun) {
        Write-Log "[DRY-RUN] Modificaria SAFETY_TICKET de '$safetyTicketAtual' para '$safetyTicketNovo'" -Level "INFO"
        Write-Log "[DRY-RUN] Arquivo modificado seria salvo em: $configFileModified" -Level "INFO"
        return $configFileModified
    }
    
    Write-Log "Lendo arquivo original..." -Level "INFO"
    $content = Get-Content -Path $ConfigFileLocal -Raw
    
    # Verificar se SAFETY_TICKET atual existe
    if ($content -notmatch [regex]::Escape($safetyTicketAtual)) {
        throw "SAFETY_TICKET atual não encontrado no arquivo. Valor esperado: $safetyTicketAtual"
    }
    
    # Verificar se SAFETY_API_KEY está correta
    if ($content -notmatch [regex]::Escape($safetyApiKeyEsperada)) {
        Write-Log "AVISO: SAFETY_API_KEY não encontrada com valor esperado. Continuando..." -Level "WARN"
    }
    
    # Substituir SAFETY_TICKET (manter formato com aspas)
    Write-Log "Substituindo SAFETY_TICKET..." -Level "INFO"
    $contentModified = $content -replace ([regex]::Escape("`"$safetyTicketAtual`""), "`"$safetyTicketNovo`"")
    
    # Verificar se substituição foi feita
    if ($contentModified -notmatch [regex]::Escape($safetyTicketNovo)) {
        throw "Falha ao substituir SAFETY_TICKET. Substituição não foi aplicada."
    }
    
    # Verificar que SAFETY_TICKET antigo não existe mais
    if ($contentModified -match [regex]::Escape($safetyTicketAtual)) {
        throw "SAFETY_TICKET antigo ainda presente após substituição"
    }
    
    Write-Log "Salvando arquivo modificado..." -Level "INFO"
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($configFileModified, $contentModified, $utf8NoBom)
    
    Write-Log "Arquivo modificado salvo: $configFileModified" -Level "SUCCESS"
    
    # Calcular hash do arquivo modificado
    $hashModified = (Get-FileHash -Path $configFileModified -Algorithm SHA256).Hash
    Write-Log "Hash SHA256 do arquivo modificado: $hashModified" -Level "INFO"
    
    return $configFileModified
}

# ============================================================================
# FUNÇÃO: Criar Backup no Servidor
# ============================================================================

function Backup-PhpFpmConfig {
    Write-Log "=== FASE 3: Criar Backup no Servidor ===" -Level "INFO"
    
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $backupFileRemote = "$configFileRemote.backup_$timestamp"
    
    if ($DryRun) {
        Write-Log "[DRY-RUN] Criaria backup em: $backupFileRemote" -Level "INFO"
        return $backupFileRemote
    }
    
    $backupScriptLines = @(
        '#!/bin/bash',
        'set -e',
        '',
        "CONFIG_FILE=`"$configFileRemote`"",
        "BACKUP_FILE=`"$backupFileRemote`"",
        '',
        '# Criar backup',
        'cp "$CONFIG_FILE" "$BACKUP_FILE"',
        '',
        '# Calcular hash do original e backup',
        'ORIG_HASH=$(sha256sum "$CONFIG_FILE" | cut -d'' '' -f1)',
        'BACK_HASH=$(sha256sum "$BACKUP_FILE" | cut -d'' '' -f1)',
        '',
        '# Verificar que hashes coincidem',
        'if [ "$ORIG_HASH" != "$BACK_HASH" ]; then',
        '    echo "ERRO: Hash do backup não coincide com original"',
        '    exit 1',
        'fi',
        '',
        'echo "BACKUP_FILE=$BACKUP_FILE"',
        'echo "ORIGINAL_HASH=$ORIG_HASH"',
        'echo "BACKUP_HASH=$BACK_HASH"'
    )
    $backupScript = $backupScriptLines -join "`n"
    
    Write-Log "Criando backup no servidor..." -Level "INFO"
    $result = Invoke-SafeSSHScript -ScriptContent $backupScript -ScriptName "backup_phpfpm.sh"
    
    # Extrair informações do resultado
    $backupInfo = @{}
    foreach ($line in $result -split "`n") {
        if ($line -match 'BACKUP_FILE=(.+)') {
            $backupInfo['BACKUP_FILE'] = $matches[1]
        }
        if ($line -match 'ORIGINAL_HASH=(.+)') {
            $backupInfo['ORIGINAL_HASH'] = $matches[1]
        }
        if ($line -match 'BACKUP_HASH=(.+)') {
            $backupInfo['BACKUP_HASH'] = $matches[1]
        }
    }
    
    Write-Log "Backup criado: $($backupInfo['BACKUP_FILE'])" -Level "SUCCESS"
    Write-Log "Hash original: $($backupInfo['ORIGINAL_HASH'])" -Level "INFO"
    Write-Log "Hash backup: $($backupInfo['BACKUP_HASH'])" -Level "INFO"
    
    if ($backupInfo['ORIGINAL_HASH'] -ne $backupInfo['BACKUP_HASH']) {
        throw "Hash do backup não coincide com original"
    }
    
    return $backupInfo['BACKUP_FILE']
}

# ============================================================================
# FUNÇÃO: Copiar Arquivo Modificado para Servidor
# ============================================================================

function Upload-PhpFpmConfig {
    param(
        [string]$ConfigFileModified
    )
    
    Write-Log "=== FASE 4: Copiar Arquivo Modificado para Servidor ===" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "[DRY-RUN] Copiaria arquivo de $ConfigFileModified para ${servidorProd}:${configFileRemote}" -Level "INFO"
        return
    }
    
    Write-Log "Copiando arquivo modificado para servidor..." -Level "INFO"
    scp $ConfigFileModified "root@${servidorProd}:${configFileRemote}" 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao copiar arquivo para servidor"
    }
    
    Write-Log "Arquivo copiado com sucesso" -Level "SUCCESS"
}

# ============================================================================
# FUNÇÃO: Verificar Hash após Cópia
# ============================================================================

function Verify-Hash {
    param(
        [string]$ConfigFileModified
    )
    
    Write-Log "=== FASE 5: Verificar Hash após Cópia ===" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "[DRY-RUN] Verificaria hash SHA256 do arquivo local vs servidor" -Level "INFO"
        return
    }
    
    # Calcular hash local
    $hashLocal = (Get-FileHash -Path $ConfigFileModified -Algorithm SHA256).Hash.ToUpper()
    Write-Log "Hash SHA256 local: $hashLocal" -Level "INFO"
    
    # Calcular hash remoto
    $hashScriptLines = @(
        '#!/bin/bash',
        "sha256sum `"$configFileRemote`" | cut -d' ' -f1"
    )
    $hashScript = $hashScriptLines -join "`n"
    
    $hashRemote = (Invoke-SafeSSHScript -ScriptContent $hashScript -ScriptName "get_hash.sh").Trim().ToUpper()
    Write-Log "Hash SHA256 remoto: $hashRemote" -Level "INFO"
    
    # Comparar hashes (case-insensitive)
    if ($hashLocal -ne $hashRemote) {
        throw "Hash não coincide! Local: $hashLocal, Remoto: $hashRemote"
    }
    
    Write-Log "Hash SHA256 coincide - arquivo copiado corretamente" -Level "SUCCESS"
}

# ============================================================================
# FUNÇÃO: Validar Sintaxe PHP-FPM
# ============================================================================

function Validate-PhpFpmSyntax {
    Write-Log "=== FASE 6: Validar Sintaxe PHP-FPM ===" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "[DRY-RUN] Validaria sintaxe PHP-FPM" -Level "INFO"
        return
    }
    
    $validateScriptLines = @(
        '#!/bin/bash',
        'php-fpm8.3 -tt 2>&1'
    )
    $validateScript = $validateScriptLines -join "`n"
    
    Write-Log "Validando sintaxe PHP-FPM..." -Level "INFO"
    $result = Invoke-SafeSSHScript -ScriptContent $validateScript -ScriptName "validate_syntax.sh"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Erro na validação de sintaxe:" -Level "ERROR"
        Write-Log $result -Level "ERROR"
        throw "Sintaxe PHP-FPM inválida"
    }
    
    Write-Log "Sintaxe PHP-FPM válida" -Level "SUCCESS"
}

# ============================================================================
# FUNÇÃO: Recarregar PHP-FPM
# ============================================================================

function Reload-PhpFpm {
    Write-Log "=== FASE 7: Recarregar PHP-FPM ===" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "[DRY-RUN] Recarregaria PHP-FPM" -Level "INFO"
        return
    }
    
    $reloadScriptLines = @(
        '#!/bin/bash',
        'systemctl reload php8.3-fpm',
        'if [ $? -ne 0 ]; then',
        '    echo "ERRO: Falha ao recarregar PHP-FPM"',
        '    exit 1',
        'fi',
        '',
        '# Verificar status',
        'if systemctl is-active --quiet php8.3-fpm; then',
        '    echo "SUCCESS: PHP-FPM está ativo"',
        'else',
        '    echo "ERRO: PHP-FPM não está ativo"',
        '    exit 1',
        'fi'
    )
    $reloadScript = $reloadScriptLines -join "`n"
    
    Write-Log "Recarregando PHP-FPM..." -Level "INFO"
    $result = Invoke-SafeSSHScript -ScriptContent $reloadScript -ScriptName "reload_phpfpm.sh"
    
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao recarregar PHP-FPM"
    }
    
    Write-Log "PHP-FPM recarregado com sucesso" -Level "SUCCESS"
}

# ============================================================================
# FUNÇÃO: Verificar Variáveis
# ============================================================================

function Verify-Variables {
    Write-Log "=== FASE 8: Verificar Variáveis ===" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "[DRY-RUN] Verificaria variáveis SAFETY_TICKET e SAFETY_API_KEY" -Level "INFO"
        return
    }
    
    $verifyScriptLines = @(
        '#!/bin/bash',
        "grep -E 'SAFETY_TICKET|SAFETY_API_KEY' `"$configFileRemote`" | grep -v '^#' | grep -v '^;'"
    )
    $verifyScript = $verifyScriptLines -join "`n"
    
    Write-Log "Verificando variáveis no arquivo..." -Level "INFO"
    $result = Invoke-SafeSSHScript -ScriptContent $verifyScript -ScriptName "verify_vars.sh"
    
    Write-Log "Variáveis encontradas:" -Level "INFO"
    Write-Log $result -Level "INFO"
    
    # Verificar SAFETY_TICKET
    if ($result -notmatch [regex]::Escape($safetyTicketNovo)) {
        throw "SAFETY_TICKET não foi atualizada corretamente. Valor esperado: $safetyTicketNovo"
    }
    
    # Verificar SAFETY_API_KEY
    if ($result -notmatch [regex]::Escape($safetyApiKeyEsperada)) {
        Write-Log "AVISO: SAFETY_API_KEY não encontrada com valor esperado" -Level "WARN"
    }
    
    Write-Log "Variáveis verificadas com sucesso" -Level "SUCCESS"
}

# ============================================================================
# FUNÇÃO PRINCIPAL
# ============================================================================

function Start-UpdateSafetyMails {
    Write-Log "========================================" -Level "INFO"
    Write-Log "INICIANDO ATUALIZAÇÃO SAFETYMAILS PROD" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN ATIVADO - Nenhuma modificação será realizada" -Level "WARN"
    }
    
    try {
        # FASE 1: Baixar arquivo do servidor
        $configFileLocal = Download-PhpFpmConfig
        
        # FASE 2: Modificar arquivo localmente
        $configFileModified = Modify-SafetyTicket -ConfigFileLocal $configFileLocal
        
        # FASE 3: Criar backup no servidor
        $backupFile = Backup-PhpFpmConfig
        
        # FASE 4: Copiar arquivo modificado para servidor
        Upload-PhpFpmConfig -ConfigFileModified $configFileModified
        
        # FASE 5: Verificar hash após cópia
        Verify-Hash -ConfigFileModified $configFileModified
        
        # FASE 6: Validar sintaxe PHP-FPM
        Validate-PhpFpmSyntax
        
        # FASE 7: Recarregar PHP-FPM
        Reload-PhpFpm
        
        # FASE 8: Verificar variáveis
        Verify-Variables
        
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "ATUALIZAÇÃO CONCLUÍDA COM SUCESSO" -Level "SUCCESS"
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "Log salvo em: $LogFile" -Level "INFO"
        Write-Log "Backup criado em: $backupFile" -Level "INFO"
        
    } catch {
        Write-Log "ERRO CRÍTICO: $_" -Level "ERROR"
        Write-Log "Consulte o log: $LogFile" -Level "ERROR"
        Write-Log "Backup disponível em: $backupFile" -Level "INFO"
        throw
    }
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

Start-UpdateSafetyMails

