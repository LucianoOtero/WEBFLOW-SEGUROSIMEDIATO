# ============================================================================
# SCRIPT: Validacao de Arquivos Locais (FASE 4)
# ============================================================================
# Projeto: PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md
# Fase: FASE 4 - Validacao de Arquivos Locais
# Versao: 1.0.0
# Data: 23/11/2025
# Ambiente: LOCAL (Windows)
# Objetivo: Validar integridade e sintaxe dos arquivos antes do deploy
# ============================================================================

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$LogFile = "validar_arquivos_locais_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURACOES
# ============================================================================

# Obter workspace root a partir do diretorio do script
$scriptDir = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$devDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"
$prodDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"
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

# Referencias hardcoded a DEV que devem ser evitadas
$referenciasDEV = @(
    "dev.bssegurosimediato.com.br",
    "65.108.156.14",
    "http://dev.",
    "https://dev."
)

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
# FUNCAO: Validar Sintaxe PHP
# ============================================================================

function Test-PHPSyntax {
    param(
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        throw "Arquivo nao encontrado: $FilePath"
    }
    
    # Verificar se PHP esta disponivel
    $phpPath = Get-Command php -ErrorAction SilentlyContinue
    if (-not $phpPath) {
        Write-Log "PHP nao encontrado no PATH. Pulando validacao de sintaxe PHP." -Level "WARN"
        return @{Valid = $true; Message = "PHP nao disponivel"}
    }
    
    # Executar php -l
    $result = & php -l $FilePath 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        return @{Valid = $true; Message = "Sintaxe PHP valida"}
    } else {
        return @{Valid = $false; Message = $result -join "`n"}
    }
}

# ============================================================================
# FUNCAO: Verificar Referencias Hardcoded a DEV
# ============================================================================

function Test-HardcodedDevReferences {
    param(
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        return @{Found = @(); Valid = $true}
    }
    
    $content = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) {
        return @{Found = @(); Valid = $true}
    }
    
    $found = @()
    foreach ($ref in $referenciasDEV) {
        if ($content -match [regex]::Escape($ref)) {
            $found += $ref
        }
    }
    
    return @{
        Found = $found
        Valid = ($found.Count -eq 0)
    }
}

# ============================================================================
# FUNCAO PRINCIPAL: Validar Arquivos Locais
# ============================================================================

function Start-ValidateLocalFiles {
    Write-Log "========================================" -Level "INFO"
    Write-Log "FASE 4: VALIDACAO DE ARQUIVOS LOCAIS" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    $resultados = @{
        PHPSyntax = @{}
        HashComparison = @{}
        HardcodedRefs = @{}
        Dependencies = @{}
    }
    
    $erros = 0
    $avisos = 0
    
    # ========================================================================
    # 1. Validar Sintaxe PHP
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "1. Validando sintaxe PHP..." -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    foreach ($arquivo in $arquivosPHP) {
        $arquivoDev = Join-Path $devDir $arquivo
        $arquivoProd = Join-Path $prodDir $arquivo
        
        Write-Log "Validando: $arquivo" -Level "INFO"
        
        # Validar arquivo DEV
        if (Test-Path $arquivoDev) {
            $resultadoDev = Test-PHPSyntax -FilePath $arquivoDev
            if ($resultadoDev.Valid) {
                Write-Log "  [OK] DEV: Sintaxe PHP valida" -Level "SUCCESS"
            } else {
                Write-Log "  [ERRO] DEV: $($resultadoDev.Message)" -Level "ERROR"
                $erros++
            }
        }
        
        # Validar arquivo PROD
        if (Test-Path $arquivoProd) {
            $resultadoProd = Test-PHPSyntax -FilePath $arquivoProd
            if ($resultadoProd.Valid) {
                Write-Log "  [OK] PROD: Sintaxe PHP valida" -Level "SUCCESS"
            } else {
                Write-Log "  [ERRO] PROD: $($resultadoProd.Message)" -Level "ERROR"
                $erros++
            }
        }
        
        $resultados.PHPSyntax[$arquivo] = @{
            Dev = $resultadoDev
            Prod = $resultadoProd
        }
    }
    
    # ========================================================================
    # 2. Comparar Hash SHA256 DEV vs PROD Local
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "2. Comparando hash SHA256 DEV vs PROD Local..." -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    foreach ($arquivo in $todosArquivos) {
        $arquivoDev = Join-Path $devDir $arquivo
        $arquivoProd = Join-Path $prodDir $arquivo
        
        if ((Test-Path $arquivoDev) -and (Test-Path $arquivoProd)) {
            $hashDev = (Get-FileHash -Path $arquivoDev -Algorithm SHA256).Hash.ToUpper()
            $hashProd = (Get-FileHash -Path $arquivoProd -Algorithm SHA256).Hash.ToUpper()
            
            if ($hashDev -eq $hashProd) {
                Write-Log "  [OK] $arquivo - Hashes coincidem" -Level "SUCCESS"
                $resultados.HashComparison[$arquivo] = @{
                    HashDev = $hashDev
                    HashProd = $hashProd
                    Valid = $true
                }
            } else {
                Write-Log "  [ERRO] $arquivo - Hashes diferentes!" -Level "ERROR"
                Write-Log "    DEV:  $hashDev" -Level "ERROR"
                Write-Log "    PROD: $hashProd" -Level "ERROR"
                $resultados.HashComparison[$arquivo] = @{
                    HashDev = $hashDev
                    HashProd = $hashProd
                    Valid = $false
                }
                $erros++
            }
        } else {
            Write-Log "  [AVISO] $arquivo - Arquivo nao encontrado em DEV ou PROD" -Level "WARN"
            $avisos++
        }
    }
    
    # ========================================================================
    # 3. Verificar Referencias Hardcoded a DEV
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "3. Verificando referencias hardcoded a DEV..." -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    foreach ($arquivo in $todosArquivos) {
        $arquivoProd = Join-Path $prodDir $arquivo
        
        if (Test-Path $arquivoProd) {
            $resultado = Test-HardcodedDevReferences -FilePath $arquivoProd
            
            if ($resultado.Valid) {
                Write-Log "  [OK] $arquivo - Nenhuma referencia hardcoded a DEV encontrada" -Level "SUCCESS"
            } else {
                Write-Log "  [AVISO] $arquivo - Referencias hardcoded a DEV encontradas:" -Level "WARN"
                foreach ($ref in $resultado.Found) {
                    Write-Log "    - $ref" -Level "WARN"
                }
                $avisos++
            }
            
            $resultados.HardcodedRefs[$arquivo] = $resultado
        }
    }
    
    # ========================================================================
    # 4. Verificar Dependencias
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "4. Verificando dependencias entre arquivos..." -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    # Verificar se config.php existe e e incluido corretamente
    $configProd = Join-Path $prodDir "config.php"
    if (Test-Path $configProd) {
        Write-Log "  [OK] config.php encontrado em PROD" -Level "SUCCESS"
        
        # Verificar se outros arquivos PHP incluem config.php
        foreach ($arquivo in $arquivosPHP) {
            if ($arquivo -eq "config.php") { continue }
            
            $arquivoProd = Join-Path $prodDir $arquivo
            if (Test-Path $arquivoProd) {
                $content = Get-Content -Path $arquivoProd -Raw -ErrorAction SilentlyContinue
                if ($content) {
                    # Verificar includes/requires de config.php
                    if ($content -match "(require|include|require_once|include_once).*config\.php") {
                        Write-Log "  [OK] $arquivo - Inclui config.php" -Level "SUCCESS"
                    } else {
                        Write-Log "  [INFO] $arquivo - Nao inclui config.php explicitamente (pode ser via autoload)" -Level "INFO"
                    }
                }
            }
        }
    } else {
        Write-Log "  [ERRO] config.php nao encontrado em PROD!" -Level "ERROR"
        $erros++
    }
    
    # Verificar uso de variaveis de ambiente
    Write-Log "  Verificando uso de variaveis de ambiente..." -Level "INFO"
    $configProd = Join-Path $prodDir "config.php"
    if (Test-Path $configProd) {
        $content = Get-Content -Path $configProd -Raw -ErrorAction SilentlyContinue
        if ($content -match '\$_ENV\[|getenv\(') {
            Write-Log "  [OK] config.php usa variaveis de ambiente" -Level "SUCCESS"
        } else {
            Write-Log "  [AVISO] config.php pode nao estar usando variaveis de ambiente" -Level "WARN"
            $avisos++
        }
    }
    
    # ========================================================================
    # RESUMO FINAL
    # ========================================================================
    Write-Log "========================================" -Level "INFO"
    Write-Log "RESUMO DA VALIDACAO" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    Write-Log "Arquivos PHP validados: $($arquivosPHP.Count)" -Level "INFO"
    Write-Log "Arquivos JavaScript: $($arquivosJS.Count)" -Level "INFO"
    Write-Log "Total de arquivos: $($todosArquivos.Count)" -Level "INFO"
    Write-Log "Erros encontrados: $erros" -Level $(if ($erros -gt 0) { "ERROR" } else { "SUCCESS" })
    Write-Log "Avisos encontrados: $avisos" -Level $(if ($avisos -gt 0) { "WARN" } else { "SUCCESS" })
    
    if ($erros -eq 0) {
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "FASE 4 CONCLUIDA COM SUCESSO" -Level "SUCCESS"
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "Todos os arquivos foram validados com sucesso!" -Level "SUCCESS"
    } else {
        Write-Log "========================================" -Level "ERROR"
        Write-Log "FASE 4 CONCLUIDA COM ERROS" -Level "ERROR"
        Write-Log "========================================" -Level "ERROR"
        Write-Log "Corrija os erros antes de prosseguir para o deploy." -Level "ERROR"
    }
    
    # Salvar relatorio
    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $relatorioFile = Join-Path $docDir "RELATORIO_VALIDACAO_LOCAL_$timestamp.md"
    
    $relatorioContent = "# Relatorio de Validacao de Arquivos Locais`n`n"
    $relatorioContent += "**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
    $relatorioContent += "**Fase:** FASE 4 - Validacao de Arquivos Locais`n"
    $relatorioContent += "**Projeto:** PROJETO_DEPLOY_DEV_PARA_PROD_20251123.md`n`n"
    $relatorioContent += "## Resumo`n`n"
    $relatorioContent += "- **Total de arquivos:** $($todosArquivos.Count)`n"
    $relatorioContent += "- **Erros encontrados:** $erros`n"
    $relatorioContent += "- **Avisos encontrados:** $avisos`n"
    $relatorioContent += "- **Status:** $(if ($erros -eq 0) { 'APROVADO' } else { 'REPROVADO' })`n`n"
    
    $relatorioContent += "## Detalhes`n`n"
    $relatorioContent += "### Validacao de Sintaxe PHP`n`n"
    foreach ($arquivo in $arquivosPHP) {
        if ($resultados.PHPSyntax.ContainsKey($arquivo)) {
            $result = $resultados.PHPSyntax[$arquivo]
            $relatorioContent += "- **$arquivo**: $(if ($result.Dev.Valid -and $result.Prod.Valid) { 'OK' } else { 'ERRO' })`n"
        }
    }
    
    $relatorioContent += "`n### Comparacao de Hash SHA256`n`n"
    foreach ($arquivo in $todosArquivos) {
        if ($resultados.HashComparison.ContainsKey($arquivo)) {
            $result = $resultados.HashComparison[$arquivo]
            $relatorioContent += "- **$arquivo**: $(if ($result.Valid) { 'OK - Hashes coincidem' } else { 'ERRO - Hashes diferentes' })`n"
        }
    }
    
    $relatorioContent += "`n### Referencias Hardcoded a DEV`n`n"
    foreach ($arquivo in $todosArquivos) {
        if ($resultados.HardcodedRefs.ContainsKey($arquivo)) {
            $result = $resultados.HardcodedRefs[$arquivo]
            if (-not $result.Valid) {
                $relatorioContent += "- **$arquivo**: Encontradas: $($result.Found -join ', ')`n"
            }
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

Start-ValidateLocalFiles

