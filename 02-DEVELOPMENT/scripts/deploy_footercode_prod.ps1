# ============================================================================
# SCRIPT: Deploy do FooterCodeSiteDefinitivoCompleto.js para Produção
# ============================================================================
# Projeto: PROJETO_DEPLOY_FOOTERCODE_PROD_GCLID_20251123.md
# Versão: 1.0.0
# Data: 23/11/2025
# Ambiente: PRODUÇÃO (PROD)
# Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
# Objetivo: Copiar arquivo de PROD local para servidor PROD com validação completa
# ============================================================================

param(
    [switch]$DryRun,
    [switch]$Verbose,
    [string]$Server = "157.180.36.223"
)

$ErrorActionPreference = "Stop"
$LogFile = "deploy_footercode_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

$servidorProd = $Server
$caminhoProd = "/var/www/html/prod/root"
# Obter diretório do script e calcular workspace root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$workspaceRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$arquivo = "FooterCodeSiteDefinitivoCompleto.js"
$arquivoLocal = Join-Path $workspaceRoot "03-PRODUCTION\$arquivo"
$arquivoRemoto = "$caminhoProd/$arquivo"

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

function Invoke-SafeSSHCommand {
    param(
        [string]$Command
    )
    
    Write-Log "Executando comando SSH: $Command" -Level "DEBUG"
    $result = ssh root@$servidorProd $Command 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -ne 0) {
        Write-Log "Erro ao executar comando SSH (exit code: $exitCode)" -Level "ERROR"
        Write-Log "Saída: $result" -Level "ERROR"
        throw "SSH command failed with exit code $exitCode"
    }
    
    return $result
}

# ============================================================================
# FUNÇÃO PRINCIPAL: Deploy
# ============================================================================

function Start-Deploy {
    Write-Log "========================================" -Level "INFO"
    Write-Log "INICIANDO DEPLOY EM PRODUÇÃO" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    if ($DryRun) {
        Write-Log "MODO DRY-RUN ATIVADO - Nenhuma modificação será realizada" -Level "WARN"
    }
    
    try {
        # Verificar se arquivo local existe
        if (-not (Test-Path $arquivoLocal)) {
            throw "Arquivo local não encontrado: $arquivoLocal"
        }
        Write-Log "Arquivo local encontrado: $arquivoLocal" -Level "SUCCESS"
        
        # Calcular hash SHA256 do arquivo local
        Write-Log "Calculando hash SHA256 do arquivo local..." -Level "INFO"
        $hashLocal = (Get-FileHash -Path $arquivoLocal -Algorithm SHA256).Hash.ToUpper()
        Write-Log "Hash SHA256 local: $hashLocal" -Level "INFO"
        
        if (-not $DryRun) {
            # Copiar arquivo via SCP
            Write-Log "Copiando arquivo para servidor PROD..." -Level "INFO"
            Write-Log "Origem: $arquivoLocal" -Level "DEBUG"
            Write-Log "Destino: root@${servidorProd}:${arquivoRemoto}" -Level "DEBUG"
            
            scp $arquivoLocal "root@${servidorProd}:${arquivoRemoto}" 2>&1 | Out-Null
            
            if ($LASTEXITCODE -ne 0) {
                throw "Falha ao copiar arquivo para servidor"
            }
            Write-Log "Arquivo copiado com sucesso" -Level "SUCCESS"
            
            # Ajustar permissões
            Write-Log "Ajustando permissões do arquivo..." -Level "INFO"
            Invoke-SafeSSHCommand -Command "chmod 644 $arquivoRemoto" | Out-Null
            Write-Log "Permissões ajustadas: 644" -Level "SUCCESS"
            
            # Calcular hash SHA256 do arquivo no servidor
            Write-Log "Calculando hash SHA256 do arquivo no servidor..." -Level "INFO"
            $hashRemotoResult = Invoke-SafeSSHCommand -Command "sha256sum $arquivoRemoto | cut -d' ' -f1"
            $hashRemoto = $hashRemotoResult.Trim().ToUpper()
            Write-Log "Hash SHA256 remoto: $hashRemoto" -Level "INFO"
            
            # Comparar hashes
            Write-Log "Comparando hashes SHA256..." -Level "INFO"
            if ($hashLocal -eq $hashRemoto) {
                Write-Log "✅ Hash SHA256 local e remoto são idênticos" -Level "SUCCESS"
            } else {
                Write-Log "❌ Hash SHA256 não coincide!" -Level "ERROR"
                Write-Log "Local:  $hashLocal" -Level "ERROR"
                Write-Log "Remoto: $hashRemoto" -Level "ERROR"
                throw "Hash SHA256 não coincide - integridade do arquivo comprometida"
            }
            
            # Criar documento de deploy
            $deployInfoFile = Join-Path $workspaceRoot "05-DOCUMENTATION\DEPLOY_INFO_FOOTERCODE_$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
            $deployInfoContent = @"
# 📋 Informações de Deploy - FooterCodeSiteDefinitivoCompleto.js

**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Projeto:** PROJETO_DEPLOY_FOOTERCODE_PROD_GCLID_20251123.md  
**Fase:** FASE 5 - Deploy para Servidor PROD

---

## 📊 INFORMAÇÕES DO DEPLOY

- **Arquivo Local:** `$arquivoLocal`
- **Arquivo Remoto:** `$arquivoRemoto`
- **Hash SHA256 Local:** `$hashLocal`
- **Hash SHA256 Remoto:** `$hashRemoto`
- **Status:** ✅ OK (hashes coincidem)

---

## 📋 VALIDAÇÕES

- ✅ Arquivo copiado com sucesso
- ✅ Permissões ajustadas (644)
- ✅ Hash SHA256 local e remoto idênticos
- ✅ Integridade do arquivo confirmada

---

**Deploy realizado em:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
"@
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::WriteAllText($deployInfoFile, $deployInfoContent, $utf8NoBom)
            Write-Log "Documento de informações de deploy criado: $deployInfoFile" -Level "SUCCESS"
            
        } else {
            Write-Log "[DRY-RUN] Deploy simulado." -Level "INFO"
            Write-Log "[DRY-RUN] Arquivo local: $arquivoLocal" -Level "INFO"
            Write-Log "[DRY-RUN] Arquivo remoto: $arquivoRemoto" -Level "INFO"
            Write-Log "[DRY-RUN] Hash SHA256 local: $hashLocal" -Level "INFO"
        }
        
        Write-Log "========================================" -Level "SUCCESS"
        Write-Log "DEPLOY CONCLUÍDO COM SUCESSO" -Level "SUCCESS"
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

Start-Deploy

