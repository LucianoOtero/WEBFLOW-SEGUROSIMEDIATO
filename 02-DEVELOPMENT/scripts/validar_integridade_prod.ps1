# ============================================================================
# SCRIPT: Validacao de Integridade no Servidor PROD (FASE 6)
# ============================================================================
# Projeto: PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md
# Fase: FASE 6 - Validacao de Integridade
# Versao: 1.0.0
# Data: 23/11/2025
# Ambiente: PRODUCAO (PROD)
# Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
# Objetivo: Validar integridade e sintaxe dos arquivos apos deploy
# ============================================================================

param(
    [switch]$Verbose,
    [string]$Server = "157.180.36.223"
)

$ErrorActionPreference = "Stop"
$LogFile = "validar_integridade_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURACOES
# ============================================================================

$servidorProd = $Server
$caminhoProd = "/var/www/html/prod/root"
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"

# Obter workspace root a partir do diretorio do script
$scriptDir = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$prodDirLocal = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"
$docDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION"

# Arquivos JavaScript
$arquivosJS = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js"
)

# Arquivos PHP
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
# FUNCOES DE LOG
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
# FUNCOES WRAPPER SSH
# ============================================================================

function Invoke-SafeSSHScript {
    param(
        [string]$ScriptContent,
        [string]$ScriptName = "temp_script.sh"
    )
    
    $tempScriptLocal = Join-Path $env:TEMP $ScriptName
    $tempScriptRemote = "/tmp/$ScriptName"
    
    Write-Log "Criando script temporario local: $tempScriptLocal" -Level "DEBUG"
    
    try {
        # Criar script temporario localmente (UTF8 sem BOM)
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($tempScriptLocal, $ScriptContent, $utf8NoBom)
        
        # Copiar para servidor via SCP
        Write-Log "Copiando script para servidor: $tempScriptRemote" -Level "DEBUG"
        scp $tempScriptLocal "root@${servidorProd}:${tempScriptRemote}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -ne 0) {
            throw "Falha ao copiar script para servidor"
        }
        
        # Tornar executavel e executar
        $executeCommand = "chmod +x $tempScriptRemote && $tempScriptRemote"
        Write-Log "Executando script no servidor: $executeCommand" -Level "DEBUG"
        $result = ssh root@$servidorProd $executeCommand 2>&1
        $exitCode = $LASTEXITCODE
        
        # Remover script do servidor
        ssh root@$servidorProd "rm -f $tempScriptRemote" 2>&1 | Out-Null
        
        # Remover script local
        Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
        
        if ($exitCode -ne 0) {
            Write-Log "Erro ao executar script temporario (exit code: $exitCode)" -Level "ERROR"
            Write-Log "Saida do script: $result" -Level "ERROR"
            throw "Script execution failed with exit code $exitCode"
        }
        
        return $result
    } catch {
        # Limpar arquivo local em caso de erro
        Remove-Item -Path $tempScriptLocal -Force -ErrorAction SilentlyContinue
        Write-Log "Excecao ao executar script temporario: $_" -Level "ERROR"
        throw
    }
}

# ============================================================================
# FUNCAO: Validar Sintaxe PHP no Servidor
# ============================================================================

function Test-PHPSyntaxRemote {
    param(
        [string]$RemoteFilePath
    )
    
    $phpCommand = "php -l '$RemoteFilePath'"
    $result = ssh root@$servidorProd $phpCommand 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        return @{Valid = $true; Message = "Sintaxe PHP valida"}
    } else {
        return @{Valid = $false; Message = $result -join "`n"}
    }
}

# ============================================================================
# FUNCAO: Calcular Hash SHA256 no Servidor
# ============================================================================

function Get-RemoteFileHashSHA256 {
    param(
        [string]$RemoteFilePath
    )
    
    $hashCommand = "sha256sum '$RemoteFilePath' | cut -d' ' -f1 | tr '[:lower:]' '[:upper:]'"
    $hash = (ssh root@$servidorProd $hashCommand 2>&1).Trim()
    
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao calcular hash do arquivo remoto: $RemoteFilePath"
    }
    
    return $hash.ToUpper()
}

# ============================================================================
# FUNCAO: Calcular Hash SHA256 Local
# ============================================================================

function Get-FileHashSHA256 {
    param(
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        throw "Arquivo nao encontrado: $FilePath"
    }
    
    $hash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash.ToUpper()
    return $hash
}

# ============================================================================
# FUNCAO PRINCIPAL: Validar Integridade no Servidor PROD
# ============================================================================

function Start-ValidateIntegrityProd {
    Write-Log "========================================" -Level "INFO"
    Write-Log "FASE 6: VALIDACAO DE INTEGRIDADE PROD" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    $resultados = @{
        PHPSyntax = @{}
        HashComparison = @{}
        JavaScriptAccess = @{}
        EnvironmentVariables = @{}
    }
    
    $erros = 0
    $avisos = 0
    
    # ========================================================================
    # 1. Validar Sintaxe PHP no Servidor
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "1. Validando sintaxe PHP no servidor..." -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    foreach ($arquivo in $arquivosPHP) {
        $arquivoRemote = "$caminhoProd/$arquivo"
        
        Write-Log "Validando: $arquivo" -Level "INFO"
        
        $resultado = Test-PHPSyntaxRemote -RemoteFilePath $arquivoRemote
        
        if ($resultado.Valid) {
            Write-Log "  [OK] Sintaxe PHP valida" -Level "SUCCESS"
            $resultados.PHPSyntax[$arquivo] = $resultado
        } else {
            Write-Log "  [ERRO] $($resultado.Message)" -Level "ERROR"
            $resultados.PHPSyntax[$arquivo] = $resultado
            $erros++
        }
    }
    
    # ========================================================================
    # 2. Verificar Variáveis de Ambiente
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "2. Verificando variaveis de ambiente..." -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    # Criar script PHP temporario para verificar variaveis
    $phpCheckScript = @'
<?php
// Script temporario para verificar variaveis de ambiente
$requiredVars = [
    'APP_BASE_URL',
    'APP_ENVIRONMENT',
    'AWS_SES_FROM_EMAIL',
    'AWS_SES_FROM_NAME',
    'OCTADESK_FROM',
    'WHATSAPP_PHONE',
    'WHATSAPP_DEFAULT_MESSAGE'
];

$found = [];
$missing = [];

foreach ($requiredVars as $var) {
    if (isset($_ENV[$var]) && !empty($_ENV[$var])) {
        $found[] = $var;
    } else {
        $missing[] = $var;
    }
}

echo "=== VARIAVEIS DE AMBIENTE ===\n";
echo "Encontradas: " . count($found) . "\n";
echo "Faltando: " . count($missing) . "\n";

if (count($found) > 0) {
    echo "\n--- Encontradas ---\n";
    foreach ($found as $var) {
        echo "$var: " . (strlen($_ENV[$var]) > 50 ? substr($_ENV[$var], 0, 50) . '...' : $_ENV[$var]) . "\n";
    }
}

if (count($missing) > 0) {
    echo "\n--- Faltando ---\n";
    foreach ($missing as $var) {
        echo "$var\n";
    }
}
'@
    
    $tempPhpFile = "/tmp/check_env_vars.php"
    
    try {
        # Criar arquivo PHP temporario localmente
        $tempPhpLocal = Join-Path $env:TEMP "check_env_vars.php"
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($tempPhpLocal, $phpCheckScript, $utf8NoBom)
        
        # Copiar para servidor
        scp $tempPhpLocal "root@${servidorProd}:${tempPhpFile}" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            # Executar script PHP via web (para ter acesso as variaveis do PHP-FPM)
            $webUrl = "https://prod.bssegurosimediato.com.br/tmp/check_env_vars.php"
            Write-Log "  Executando verificacao via web: $webUrl" -Level "INFO"
            
            try {
                $response = Invoke-WebRequest -Uri $webUrl -UseBasicParsing -TimeoutSec 10 -ErrorAction SilentlyContinue
                $output = $response.Content
                Write-Log "  Resultado:" -Level "INFO"
                $output -split "`n" | ForEach-Object { Write-Log "    $_" -Level "INFO" }
                
                if ($output -match "Faltando: 0") {
                    Write-Log "  [OK] Todas as variaveis de ambiente estao disponiveis" -Level "SUCCESS"
                    $resultados.EnvironmentVariables["Status"] = "OK"
                } else {
                    Write-Log "  [AVISO] Algumas variaveis de ambiente podem estar faltando" -Level "WARN"
                    $resultados.EnvironmentVariables["Status"] = "WARN"
                    $avisos++
                }
            } catch {
                Write-Log "  [AVISO] Nao foi possivel verificar via web. Tentando via CLI..." -Level "WARN"
                # Tentar via CLI (pode nao ter acesso as variaveis do PHP-FPM)
                $cliResult = ssh root@$servidorProd "php $tempPhpFile" 2>&1
                Write-Log "  Resultado CLI:" -Level "INFO"
                $cliResult -split "`n" | ForEach-Object { Write-Log "    $_" -Level "INFO" }
                $avisos++
            }
            
            # Remover arquivo temporario
            ssh root@$servidorProd "rm -f $tempPhpFile" 2>&1 | Out-Null
        }
        
        # Remover arquivo local
        Remove-Item -Path $tempPhpLocal -Force -ErrorAction SilentlyContinue
    } catch {
        Write-Log "  [ERRO] Falha ao verificar variaveis de ambiente: $_" -Level "ERROR"
        $erros++
    }
    
    # ========================================================================
    # 3. Verificar Integridade dos Arquivos JavaScript
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "3. Verificando integridade dos arquivos JavaScript..." -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    $baseUrl = "https://prod.bssegurosimediato.com.br"
    
    foreach ($arquivo in $arquivosJS) {
        $url = "$baseUrl/$arquivo"
        
        Write-Log "Verificando: $arquivo" -Level "INFO"
        
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
            $statusCode = $response.StatusCode
            
            if ($statusCode -eq 200) {
                $contentLength = $response.Content.Length
                Write-Log "  [OK] Arquivo acessivel via HTTP (Status: $statusCode, Tamanho: $contentLength bytes)" -Level "SUCCESS"
                $resultados.JavaScriptAccess[$arquivo] = @{
                    Status = "OK"
                    StatusCode = $statusCode
                    ContentLength = $contentLength
                }
            } else {
                Write-Log "  [ERRO] Status HTTP: $statusCode" -Level "ERROR"
                $resultados.JavaScriptAccess[$arquivo] = @{
                    Status = "ERROR"
                    StatusCode = $statusCode
                }
                $erros++
            }
        } catch {
            Write-Log "  [ERRO] Falha ao acessar arquivo: $_" -Level "ERROR"
            $resultados.JavaScriptAccess[$arquivo] = @{
                Status = "ERROR"
                Error = $_.ToString()
            }
            $erros++
        }
    }
    
    # ========================================================================
    # 4. Comparar Hash SHA256 Final
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "4. Comparando hash SHA256 final..." -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    foreach ($arquivo in $todosArquivos) {
        $arquivoLocal = Join-Path $prodDirLocal $arquivo
        $arquivoRemote = "$caminhoProd/$arquivo"
        
        Write-Log "Comparando: $arquivo" -Level "INFO"
        
        try {
            $hashLocal = Get-FileHashSHA256 -FilePath $arquivoLocal
            $hashRemote = Get-RemoteFileHashSHA256 -RemoteFilePath $arquivoRemote
            
            if ($hashLocal -eq $hashRemote) {
                Write-Log "  [OK] Hashes coincidem" -Level "SUCCESS"
                $resultados.HashComparison[$arquivo] = @{
                    HashLocal = $hashLocal
                    HashRemote = $hashRemote
                    Valid = $true
                }
            } else {
                Write-Log "  [ERRO] Hashes diferentes!" -Level "ERROR"
                Write-Log "    Local:  $hashLocal" -Level "ERROR"
                Write-Log "    Remote: $hashRemote" -Level "ERROR"
                $resultados.HashComparison[$arquivo] = @{
                    HashLocal = $hashLocal
                    HashRemote = $hashRemote
                    Valid = $false
                }
                $erros++
            }
        } catch {
            Write-Log "  [ERRO] Falha ao comparar hash: $_" -Level "ERROR"
            $erros++
        }
    }
    
    # ========================================================================
    # RESUMO FINAL
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "RESUMO DA VALIDACAO" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    Write-Log "Arquivos PHP validados: $($arquivosPHP.Count)" -Level "INFO"
    Write-Log "Arquivos JavaScript verificados: $($arquivosJS.Count)" -Level "INFO"
    Write-Log "Total de arquivos: $($todosArquivos.Count)" -Level "INFO"
    Write-Log "Erros encontrados: $erros" -Level $(if ($erros -gt 0) { "ERROR" } else { "SUCCESS" })
    Write-Log "Avisos encontrados: $avisos" -Level $(if ($avisos -gt 0) { "WARN" } else { "SUCCESS" })
    
    if ($erros -eq 0) {
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "FASE 6 CONCLUIDA COM SUCESSO" -Level "SUCCESS"
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "Todos os arquivos foram validados com sucesso!" -Level "SUCCESS"
    } else {
        Write-Log "========================================" -Level "ERROR"
        Write-Log "FASE 6 CONCLUIDA COM ERROS" -Level "ERROR"
        Write-Log "========================================" -Level "ERROR"
        Write-Log "Corrija os erros antes de prosseguir." -Level "ERROR"
    }
    
    # Salvar relatorio
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $relatorioFile = Join-Path $docDir "RELATORIO_VALIDACAO_INTEGRIDADE_PROD_$timestamp.md"
    
    $relatorioContent = '# Relatorio de Validacao de Integridade em PROD' + "`n`n"
    $relatorioContent += '**Data:** ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + "`n"
    $relatorioContent += '**Fase:** FASE 6 - Validacao de Integridade' + "`n"
    $relatorioContent += '**Projeto:** PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md' + "`n`n"
    $relatorioContent += '## Resumo' + "`n`n"
    $relatorioContent += '- **Total de arquivos:** ' + $todosArquivos.Count + "`n"
    $relatorioContent += '- **Erros encontrados:** ' + $erros + "`n"
    $relatorioContent += '- **Avisos encontrados:** ' + $avisos + "`n"
    $relatorioContent += '- **Status:** ' + $(if ($erros -eq 0) { 'APROVADO' } else { 'REPROVADO' }) + "`n`n"
    
    $relatorioContent += '## Detalhes' + "`n`n"
    $relatorioContent += '### Validacao de Sintaxe PHP' + "`n`n"
    foreach ($arquivo in $arquivosPHP) {
        if ($resultados.PHPSyntax.ContainsKey($arquivo)) {
            $result = $resultados.PHPSyntax[$arquivo]
            $relatorioContent += '- **' + $arquivo + '**: ' + $(if ($result.Valid) { 'OK' } else { 'ERRO - ' + $result.Message }) + "`n"
        }
    }
    
    $relatorioContent += "`n### Comparacao de Hash SHA256`n`n"
    foreach ($arquivo in $todosArquivos) {
        if ($resultados.HashComparison.ContainsKey($arquivo)) {
            $result = $resultados.HashComparison[$arquivo]
            $relatorioContent += '- **' + $arquivo + '**: ' + $(if ($result.Valid) { 'OK - Hashes coincidem' } else { 'ERRO - Hashes diferentes' }) + "`n"
        }
    }
    
    $relatorioContent += "`n### Acessibilidade dos Arquivos JavaScript`n`n"
    foreach ($arquivo in $arquivosJS) {
        if ($resultados.JavaScriptAccess.ContainsKey($arquivo)) {
            $result = $resultados.JavaScriptAccess[$arquivo]
            $relatorioContent += '- **' + $arquivo + '**: ' + $result.Status + $(if ($result.StatusCode) { ' (HTTP ' + $result.StatusCode + ')' } else { '' }) + "`n"
        }
    }
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($relatorioFile, $relatorioContent, $utf8NoBom)
    
    Write-Log "Relatorio salvo em: $relatorioFile" -Level "INFO"
    Write-Log "Log salvo em: $LogFile" -Level "INFO"
    
    return @{
        Erros = $erros
        Avisos = $avisos
        Resultados = $resultados
    }
}

# ============================================================================
# EXECUCAO
# ============================================================================

Start-ValidateIntegrityProd

