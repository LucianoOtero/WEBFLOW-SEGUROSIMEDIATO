# ============================================================================
# SCRIPT: Copiar Arquivos de DEV para PROD Local (Windows)
# ============================================================================
# Projeto: PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md
# Fase: FASE 2 - Cópia para PROD Local (Windows)
# Versão: 1.0.0
# Data: 23/11/2025
# Ambiente: LOCAL (Windows)
# Objetivo: Copiar arquivos de DEV local para PROD local e validar integridade
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$LogFile = "copiar_dev_para_prod_local_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$devDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"
$prodDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"
$backupDir = Join-Path $prodDir "backups"
$docDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION"

# Arquivos JavaScript a copiar (3 arquivos)
$arquivosJS = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js"
)

# Arquivos PHP a copiar (9 arquivos)
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

# Scripts PowerShell para referência (opcional)
$scriptsPowerShell = @(
    "scripts\atualizar_variaveis_ambiente_prod.ps1"
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
# FUNÇÃO: Calcular Hash SHA256
# ============================================================================

function Get-FileHashSHA256 {
    param(
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        throw "Arquivo não encontrado: $FilePath"
    }
    
    $hash = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash.ToUpper()
    return $hash
}

# ============================================================================
# FUNÇÃO PRINCIPAL: Copiar Arquivos DEV -> PROD Local
# ============================================================================

function Start-CopyDevToProdLocal {
    Write-Log "========================================" -Level "INFO"
    Write-Log "FASE 2: CÓPIA DEV -> PROD LOCAL" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN ATIVADO - Nenhuma modificação será realizada" -Level "WARN"
    }
    
    try {
        # Criar diretórios se não existirem
        Write-Log "Criando diretórios necessários..." -Level "INFO"
        if (-not $DryRun) {
            if (-not (Test-Path $prodDir)) {
                New-Item -ItemType Directory -Path $prodDir -Force | Out-Null
                Write-Log "Diretório PROD criado: $prodDir" -Level "SUCCESS"
            } else {
                Write-Log "Diretório PROD já existe: $prodDir" -Level "INFO"
            }
            
            if (-not (Test-Path $backupDir)) {
                New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
                Write-Log "Diretório de backups criado: $backupDir" -Level "SUCCESS"
            } else {
                Write-Log "Diretório de backups já existe: $backupDir" -Level "INFO"
            }
        } else {
            Write-Log "[DRY-RUN] Criaria diretórios: $prodDir, $backupDir" -Level "INFO"
        }
        
        # Verificar se arquivos DEV existem
        Write-Log "Verificando arquivos em DEV..." -Level "INFO"
        $arquivosFaltando = @()
        foreach ($arquivo in $todosArquivos) {
            $arquivoDev = Join-Path $devDir $arquivo
            if (-not (Test-Path $arquivoDev)) {
                $arquivosFaltando += $arquivo
                Write-Log "ARQUIVO NÃO ENCONTRADO EM DEV: $arquivo" -Level "ERROR"
            }
        }
        
        if ($arquivosFaltando.Count -gt 0) {
            throw "Arquivos não encontrados em DEV: $($arquivosFaltando -join ', ')"
        }
        
        $totalArquivos = $todosArquivos.Count
        $mensagem = 'Todos os arquivos encontrados em DEV (' + $totalArquivos + ' arquivos)'
        Write-Log $mensagem -Level "SUCCESS"
        
        # Copiar arquivos e calcular hashes
        Write-Log "========================================" -Level "INFO"
        Write-Log "Copiando arquivos e calculando hashes..." -Level "INFO"
        Write-Log "========================================" -Level "INFO"
        
        $resultados = @{}
        $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        
        foreach ($arquivo in $todosArquivos) {
            $arquivoDev = Join-Path $devDir $arquivo
            $arquivoProd = Join-Path $prodDir $arquivo
            
            Write-Log "Processando: $arquivo" -Level "INFO"
            
            # Calcular hash do arquivo DEV
            $hashDev = Get-FileHashSHA256 -FilePath $arquivoDev
            Write-Log "  Hash DEV: $hashDev" -Level "DEBUG"
            
            if (-not $DryRun) {
                # Fazer backup do arquivo PROD existente (se houver)
                if (Test-Path $arquivoProd) {
                    $backupFile = Join-Path $backupDir "$arquivo.backup_$timestamp"
                    Copy-Item -Path $arquivoProd -Destination $backupFile -Force
                    Write-Log "  Backup do arquivo PROD existente criado: $backupFile" -Level "DEBUG"
                }
                
                # Copiar arquivo DEV -> PROD
                $arquivoProdDir = Split-Path $arquivoProd -Parent
                if (-not (Test-Path $arquivoProdDir)) {
                    New-Item -ItemType Directory -Path $arquivoProdDir -Force | Out-Null
                }
                
                Copy-Item -Path $arquivoDev -Destination $arquivoProd -Force
                Write-Log "  Arquivo copiado: $arquivoProd" -Level "SUCCESS"
                
                # Calcular hash do arquivo PROD copiado
                $hashProd = Get-FileHashSHA256 -FilePath $arquivoProd
                Write-Log "  Hash PROD: $hashProd" -Level "DEBUG"
                
                # Validar integridade
                if ($hashDev -eq $hashProd) {
                    Write-Log "  ✅ Integridade validada: Hashes coincidem" -Level "SUCCESS"
                    $resultados[$arquivo] = @{
                        "Tipo" = if ($arquivosJS -contains $arquivo) { "JS" } else { "PHP" }
                        "HashDev" = $hashDev
                        "HashProd" = $hashProd
                        "Status" = "OK"
                    }
                } else {
                    Write-Log "  ❌ ERRO: Hashes não coincidem!" -Level "ERROR"
                    $resultados[$arquivo] = @{
                        "Tipo" = if ($arquivosJS -contains $arquivo) { "JS" } else { "PHP" }
                        "HashDev" = $hashDev
                        "HashProd" = $hashProd
                        "Status" = "ERROR"
                    }
                    throw "Falha na validação de integridade para $arquivo"
                }
            } else {
                Write-Log "[DRY-RUN] Copiaria: $arquivoDev -> $arquivoProd" -Level "INFO"
                $resultados[$arquivo] = @{
                    "Tipo" = if ($arquivosJS -contains $arquivo) { "JS" } else { "PHP" }
                    "HashDev" = $hashDev
                    "HashProd" = "N/A (DRY-RUN)"
                    "Status" = "DRY-RUN"
                }
            }
        }
        
        # Copiar scripts PowerShell (opcional, para referência)
        Write-Log "========================================" -Level "INFO"
        Write-Log "Copiando scripts PowerShell (referência)..." -Level "INFO"
        Write-Log "========================================" -Level "INFO"
        
        foreach ($script in $scriptsPowerShell) {
            $scriptDev = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\$script"
            if (Test-Path $scriptDev) {
                $scriptProd = Join-Path $prodDir (Split-Path $script -Leaf)
                if (-not $DryRun) {
                    Copy-Item -Path $scriptDev -Destination $scriptProd -Force
                    Write-Log "Script copiado: $scriptProd" -Level "SUCCESS"
                } else {
                    Write-Log "[DRY-RUN] Copiaria: $scriptDev -> $scriptProd" -Level "INFO"
                }
            } else {
                Write-Log "Script não encontrado (opcional): $script" -Level "WARN"
            }
        }
        
        # Gerar documento de hash SHA256
        Write-Log "========================================" -Level "INFO"
        Write-Log "Gerando documento de hash SHA256..." -Level "INFO"
        Write-Log "========================================" -Level "INFO"
        
        $docHashFile = Join-Path $docDir "HASHES_ARQUIVOS_PROD_LOCAL_$timestamp.md"
        
        if (-not (Test-Path $docDir)) {
            New-Item -ItemType Directory -Path $docDir -Force | Out-Null
        }
        
        $dataAtual = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $totalArquivosDoc = $todosArquivos.Count
        $totalJS = $arquivosJS.Count
        $totalPHP = $arquivosPHP.Count
        $statusDoc = if ($DryRun) { "DRY-RUN" } else { "CONCLUÍDO" }
        
        $docContent = '# Hash SHA256 dos Arquivos em PROD Local' + "`n`n"
        $docContent += '**Data:** ' + $dataAtual + "`n"
        $docContent += '**Fase:** FASE 2 - Cópia para PROD Local (Windows)' + "`n"
        $docContent += '**Projeto:** PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md' + "`n`n"
        $docContent += '## Resumo' + "`n`n"
        $docContent += '- **Total de arquivos:** ' + $totalArquivosDoc + "`n"
        $docContent += '- **Arquivos JavaScript:** ' + $totalJS + "`n"
        $docContent += '- **Arquivos PHP:** ' + $totalPHP + "`n"
        $docContent += '- **Status:** ' + $statusDoc + "`n`n"
        $docContent += '## Arquivos JavaScript' + "`n`n"
        $docContent += '| Arquivo | Hash SHA256 | Status |' + "`n"
        $docContent += '|---------|-------------|--------|' + "`n"
        
        foreach ($arquivo in $arquivosJS) {
            if ($resultados.ContainsKey($arquivo)) {
                $docContent += '| ' + $arquivo + ' | ' + $resultados[$arquivo].HashDev + ' | ' + $resultados[$arquivo].Status + ' |' + "`n"
            }
        }
        
        $docContent += "`n" + '## Arquivos PHP' + "`n`n"
        $docContent += '| Arquivo | Hash SHA256 | Status |' + "`n"
        $docContent += '|---------|-------------|--------|' + "`n"
        
        foreach ($arquivo in $arquivosPHP) {
            if ($resultados.ContainsKey($arquivo)) {
                $docContent += '| ' + $arquivo + ' | ' + $resultados[$arquivo].HashDev + ' | ' + $resultados[$arquivo].Status + ' |' + "`n"
            }
        }
        
        $docContent += "`n" + '## Validação de Integridade' + "`n`n"
        $docContent += 'Todos os arquivos foram copiados de DEV para PROD local e seus hashes SHA256 foram validados.' + "`n`n"
        $docContent += '**Diretório DEV:** ' + $devDir + "`n"
        $docContent += '**Diretório PROD:** ' + $prodDir + "`n`n"
        $docContent += '## Próximos Passos' + "`n`n"
        $docContent += '- FASE 3: Backup Completo em PROD (já concluída)' + "`n"
        $docContent += '- FASE 4: Validação de Arquivos Locais' + "`n"
        $docContent += '- FASE 5: Deploy para Servidor PROD' + "`n"
        
        if (-not $DryRun) {
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($docHashFile, $docContent, $utf8NoBom)
            Write-Log "Documento de hash criado: $docHashFile" -Level "SUCCESS"
        } else {
            Write-Log "[DRY-RUN] Criaria documento: $docHashFile" -Level "INFO"
        }
        
        # Resumo final
        Write-Log '========================================' -Level 'SUCCESS'
        Write-Log 'FASE 2 CONCLUIDA COM SUCESSO' -Level 'SUCCESS'
        Write-Log '========================================' -Level 'SUCCESS'
        Write-Log ('Arquivos processados: ' + $todosArquivos.Count) -Level 'INFO'
        Write-Log ('Arquivos JavaScript: ' + $arquivosJS.Count) -Level 'INFO'
        Write-Log ('Arquivos PHP: ' + $arquivosPHP.Count) -Level 'INFO'
        Write-Log ('Diretorio PROD: ' + $prodDir) -Level 'INFO'
        Write-Log ('Documento de hash: ' + $docHashFile) -Level 'INFO'
        Write-Log ('Log salvo em: ' + $LogFile) -Level 'INFO'
        
        return $resultados
        
    } catch {
        Write-Log ('ERRO CRITICO: ' + $_.ToString()) -Level 'ERROR'
        Write-Log ('Stack trace: ' + $_.ScriptStackTrace) -Level 'ERROR'
        Write-Log ('Consulte o log: ' + $LogFile) -Level 'ERROR'
        throw
    }
}

# ============================================================================
# EXECUÇÃO
# ============================================================================

Start-CopyDevToProdLocal

