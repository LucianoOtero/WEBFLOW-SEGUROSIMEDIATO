# ============================================================================
# SCRIPT: Deploy de Arquivos para Servidor PROD
# ============================================================================
# Projeto: PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md
# Fase: FASE 5 - Deploy para Servidor PROD
# Versao: 1.0.0
# Data: 23/11/2025
# Ambiente: PRODUCAO (PROD)
# Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
# Objetivo: Copiar todos os arquivos de PROD local para servidor PROD com validacao de integridade
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [string]$Server = "157.180.36.223"
)

$ErrorActionPreference = "Stop"
$LogFile = "deploy_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURACOES
# ============================================================================

$servidorProd = $Server
$caminhoProd = "/var/www/html/prod/root"

# Obter workspace root a partir do diretorio do script
$scriptDir = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$prodDirLocal = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"
$docDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION"

# Arquivos JavaScript a deployar (3 arquivos)
$arquivosJS = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js"
)

# Arquivos PHP a deployar (9 arquivos)
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
# FUNCAO PRINCIPAL: Deploy para Servidor PROD
# ============================================================================

function Start-DeployToProd {
    Write-Log "========================================" -Level "INFO"
    Write-Log "FASE 5: DEPLOY PARA SERVIDOR PROD" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN ATIVADO - Nenhuma modificacao sera realizada" -Level "WARN"
    }
    
    try {
        # Verificar se arquivos locais existem
        Write-Log "Verificando arquivos em PROD local..." -Level "INFO"
        $arquivosFaltando = @()
        foreach ($arquivo in $todosArquivos) {
            $arquivoLocal = Join-Path $prodDirLocal $arquivo
            if (-not (Test-Path $arquivoLocal)) {
                $arquivosFaltando += $arquivo
                Write-Log "ARQUIVO NAO ENCONTRADO EM PROD LOCAL: $arquivo" -Level "ERROR"
            }
        }
        
        if ($arquivosFaltando.Count -gt 0) {
            throw "Arquivos nao encontrados em PROD local: $($arquivosFaltando -join ', ')"
        }
        
        Write-Log "Todos os arquivos encontrados em PROD local ($($todosArquivos.Count) arquivos)" -Level "SUCCESS"
        
        # Resultados do deploy
        $resultados = @{}
        $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $deployados = 0
        $erros = 0
        
        Write-Log "========================================" -Level "INFO"
        Write-Log "Iniciando deploy de arquivos..." -Level "INFO"
        Write-Log "========================================" -Level "INFO"
        
        foreach ($arquivo in $todosArquivos) {
            $arquivoLocal = Join-Path $prodDirLocal $arquivo
            $arquivoRemote = "$caminhoProd/$arquivo"
            
            Write-Log "Processando: $arquivo" -Level "INFO"
            
            # Calcular hash do arquivo local
            $hashLocal = Get-FileHashSHA256 -FilePath $arquivoLocal
            Write-Log "  Hash local: $hashLocal" -Level "DEBUG"
            
            if (-not $DryRun) {
                try {
                    # Copiar arquivo via SCP
                    Write-Log "  Copiando arquivo para servidor..." -Level "INFO"
                    scp $arquivoLocal "root@${servidorProd}:${arquivoRemote}" 2>&1 | Out-Null
                    
                    if ($LASTEXITCODE -ne 0) {
                        throw "Falha ao copiar arquivo via SCP"
                    }
                    
                    Write-Log "  Arquivo copiado com sucesso" -Level "SUCCESS"
                    
                    # Ajustar permissões (644 para arquivos)
                    Write-Log "  Ajustando permissoes..." -Level "DEBUG"
                    ssh root@$servidorProd "chmod 644 '$arquivoRemote'" 2>&1 | Out-Null
                    
                    # Calcular hash do arquivo no servidor
                    Write-Log "  Calculando hash no servidor..." -Level "DEBUG"
                    $hashRemote = Get-RemoteFileHashSHA256 -RemoteFilePath $arquivoRemote
                    Write-Log "  Hash remoto: $hashRemote" -Level "DEBUG"
                    
                    # Validar integridade
                    if ($hashLocal -eq $hashRemote) {
                        Write-Log "  [OK] Integridade validada: Hashes coincidem" -Level "SUCCESS"
                        $resultados[$arquivo] = @{
                            HashLocal = $hashLocal
                            HashRemote = $hashRemote
                            Status = "OK"
                            Tipo = if ($arquivosJS -contains $arquivo) { "JS" } else { "PHP" }
                        }
                        $deployados++
                    } else {
                        Write-Log "  [ERRO] Hashes nao coincidem!" -Level "ERROR"
                        Write-Log "    Local:  $hashLocal" -Level "ERROR"
                        Write-Log "    Remote: $hashRemote" -Level "ERROR"
                        $resultados[$arquivo] = @{
                            HashLocal = $hashLocal
                            HashRemote = $hashRemote
                            Status = "ERROR"
                            Tipo = if ($arquivosJS -contains $arquivo) { "JS" } else { "PHP" }
                        }
                        $erros++
                        throw "Falha na validacao de integridade para $arquivo"
                    }
                } catch {
                    Write-Log "  [ERRO] Falha ao fazer deploy de $arquivo : $_" -Level "ERROR"
                    $resultados[$arquivo] = @{
                        HashLocal = $hashLocal
                        HashRemote = "N/A"
                        Status = "ERROR"
                        Tipo = if ($arquivosJS -contains $arquivo) { "JS" } else { "PHP" }
                    }
                    $erros++
                    throw
                }
            } else {
                Write-Log "[DRY-RUN] Copiaria: $arquivoLocal -> $arquivoRemote" -Level "INFO"
                $resultados[$arquivo] = @{
                    HashLocal = $hashLocal
                    HashRemote = "N/A (DRY-RUN)"
                    Status = "DRY-RUN"
                    Tipo = if ($arquivosJS -contains $arquivo) { "JS" } else { "PHP" }
                }
            }
        }
        
        # Gerar documento de hash SHA256
        Write-Log "========================================" -Level "INFO"
        Write-Log "Gerando documento de hash SHA256..." -Level "INFO"
        Write-Log "========================================" -Level "INFO"
        
        $docHashFile = Join-Path $docDir "HASHES_ARQUIVOS_DEPLOY_PROD_$timestamp.md"
        
        if (-not (Test-Path $docDir)) {
            New-Item -ItemType Directory -Path $docDir -Force | Out-Null
        }
        
        $dataAtual = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $totalArquivosDoc = $todosArquivos.Count
        
        $docContent = '# Hash SHA256 dos Arquivos Deployados em PROD' + "`n`n"
        $docContent += '**Data:** ' + $dataAtual + "`n"
        $docContent += '**Fase:** FASE 5 - Deploy para Servidor PROD' + "`n"
        $docContent += '**Projeto:** PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md' + "`n`n"
        $docContent += '## Resumo' + "`n`n"
        $docContent += '- **Total de arquivos:** ' + $totalArquivosDoc + "`n"
        $docContent += '- **Deployados com sucesso:** ' + $deployados + "`n"
        $docContent += '- **Erros:** ' + $erros + "`n"
        $docContent += '- **Status:** ' + $(if ($DryRun) { 'DRY-RUN' } else { if ($erros -eq 0) { 'CONCLUIDO' } else { 'ERRO' } }) + "`n`n"
        $docContent += '## Arquivos JavaScript' + "`n`n"
        $docContent += '| Arquivo | Hash Local | Hash Remoto | Status |' + "`n"
        $docContent += '|---------|------------|-------------|--------|' + "`n"
        
        foreach ($arquivo in $arquivosJS) {
            if ($resultados.ContainsKey($arquivo)) {
                $result = $resultados[$arquivo]
                $docContent += '| ' + $arquivo + ' | ' + $result.HashLocal + ' | ' + $result.HashRemote + ' | ' + $result.Status + ' |' + "`n"
            }
        }
        
        $docContent += "`n" + '## Arquivos PHP' + "`n`n"
        $docContent += '| Arquivo | Hash Local | Hash Remoto | Status |' + "`n"
        $docContent += '|---------|------------|-------------|--------|' + "`n"
        
        foreach ($arquivo in $arquivosPHP) {
            if ($resultados.ContainsKey($arquivo)) {
                $result = $resultados[$arquivo]
                $docContent += '| ' + $arquivo + ' | ' + $result.HashLocal + ' | ' + $result.HashRemote + ' | ' + $result.Status + ' |' + "`n"
            }
        }
        
        $docContent += "`n" + '## Validacao de Integridade' + "`n`n"
        $docContent += 'Todos os arquivos foram copiados de PROD local para servidor PROD e seus hashes SHA256 foram validados.' + "`n`n"
        $docContent += '**Diretorio PROD Local:** ' + $prodDirLocal + "`n"
        $docContent += '**Servidor PROD:** ' + $servidorProd + "`n"
        $docContent += '**Caminho no servidor:** ' + $caminhoProd + "`n`n"
        $docContent += '## Próximos Passos' + "`n`n"
        $docContent += '- FASE 6: Validacao de Integridade' + "`n"
        $docContent += '- FASE 7: Validacao de Funcionamento' + "`n"
        $docContent += '- FASE 8: Documentacao Final' + "`n"
        
        if (-not $DryRun) {
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($docHashFile, $docContent, $utf8NoBom)
            Write-Log "Documento de hash criado: $docHashFile" -Level "SUCCESS"
        } else {
            Write-Log "[DRY-RUN] Criaria documento: $docHashFile" -Level "INFO"
        }
        
        # Resumo final
        Write-Log "========================================" -Level "INFO"
        if ($erros -eq 0) {
            Write-Log "FASE 5 CONCLUIDA COM SUCESSO" -Level "SUCCESS"
        } else {
            Write-Log "FASE 5 CONCLUIDA COM ERROS" -Level "ERROR"
        }
        Write-Log "========================================" -Level "INFO"
        Write-Log "Arquivos processados: $($todosArquivos.Count)" -Level "INFO"
        Write-Log "Arquivos deployados: $deployados" -Level $(if ($deployados -eq $todosArquivos.Count) { "SUCCESS" } else { "WARN" })
        Write-Log "Erros encontrados: $erros" -Level $(if ($erros -eq 0) { "SUCCESS" } else { "ERROR" })
        Write-Log "Servidor PROD: $servidorProd" -Level "INFO"
        Write-Log "Caminho no servidor: $caminhoProd" -Level "INFO"
        Write-Log "Documento de hash: $docHashFile" -Level "INFO"
        Write-Log "Log salvo em: $LogFile" -Level "INFO"
        
        if ($erros -gt 0) {
            throw "Deploy concluido com $erros erro(s). Verifique o log para detalhes."
        }
        
        return $resultados
        
    } catch {
        Write-Log "ERRO CRITICO: $_" -Level "ERROR"
        Write-Log "Stack trace: $($_.ScriptStackTrace)" -Level "ERROR"
        Write-Log "Consulte o log: $LogFile" -Level "ERROR"
        throw
    }
}

# ============================================================================
# EXECUCAO
# ============================================================================

Start-DeployToProd

