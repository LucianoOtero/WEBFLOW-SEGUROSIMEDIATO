# ============================================================================
# SCRIPT: Validação de Integridade - FooterCodeSiteDefinitivoCompleto.js
# ============================================================================
# Projeto: PROJETO_DEPLOY_FOOTERCODE_PROD_GCLID_20251123.md
# Versão: 1.0.0
# Data: 23/11/2025
# Ambiente: PRODUÇÃO (PROD)
# Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
# Objetivo: Validar integridade e acessibilidade do arquivo após deploy
# ============================================================================

param(
    [switch]$Verbose,
    [string]$Server = "157.180.36.223"
)

$ErrorActionPreference = "Stop"
$LogFile = "validar_integridade_footercode_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ============================================================================
# CONFIGURAÇÕES
# ============================================================================

$servidorProd = $Server
$caminhoProd = "/var/www/html/prod/root"
$arquivo = "FooterCodeSiteDefinitivoCompleto.js"
$arquivoRemoto = "$caminhoProd/$arquivo"
$urlArquivo = "https://prod.bssegurosimediato.com.br/$arquivo"

# Obter diretório do script e calcular workspace root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$workspaceRoot = Split-Path -Parent (Split-Path -Parent $scriptDir)
$arquivoLocal = Join-Path $workspaceRoot "03-PRODUCTION\$arquivo"

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
# FUNÇÃO PRINCIPAL: Validação
# ============================================================================

function Start-Validation {
    Write-Log "========================================" -Level "INFO"
    Write-Log "INICIANDO VALIDAÇÃO DE INTEGRIDADE" -Level "INFO"
    Write-Log "========================================" -Level "INFO"
    
    $erros = 0
    $avisos = 0
    
    try {
        # 1. Validar sintaxe JavaScript no servidor
        Write-Log "1. Validando sintaxe JavaScript no servidor..." -Level "INFO"
        
        if (Get-Command node -ErrorAction SilentlyContinue) {
            # Baixar arquivo temporariamente para validar
            $tempFile = Join-Path $env:TEMP "temp_$arquivo"
            try {
                scp "root@${servidorProd}:${arquivoRemoto}" $tempFile 2>&1 | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    $syntaxCheck = node --check $tempFile 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        Write-Log "✅ Sintaxe JavaScript válida" -Level "SUCCESS"
                    } else {
                        Write-Log "❌ Erro de sintaxe JavaScript:" -Level "ERROR"
                        Write-Log $syntaxCheck -Level "ERROR"
                        $erros++
                    }
                } else {
                    Write-Log "⚠️ Não foi possível baixar arquivo para validação" -Level "WARN"
                    $avisos++
                }
            } finally {
                Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
            }
        } else {
            Write-Log "⚠️ Node.js não disponível - pulando validação de sintaxe" -Level "WARN"
            $avisos++
        }
        
        Write-Host ""
        
        # 2. Verificar acessibilidade via HTTP
        Write-Log "2. Verificando acessibilidade via HTTP..." -Level "INFO"
        Write-Log "URL: $urlArquivo" -Level "DEBUG"
        
        try {
            $response = Invoke-WebRequest -Uri $urlArquivo -Method Head -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Log "✅ Arquivo acessível via HTTP (Status: 200)" -Level "SUCCESS"
                Write-Log "Tamanho via HTTP: $($response.Headers.'Content-Length') bytes" -Level "INFO"
            } else {
                Write-Log "❌ Status HTTP inesperado: $($response.StatusCode)" -Level "ERROR"
                $erros++
            }
        } catch {
            Write-Log "❌ Erro ao acessar arquivo via HTTP: $_" -Level "ERROR"
            $erros++
        }
        
        Write-Host ""
        
        # 3. Comparar hash SHA256 final
        Write-Log "3. Comparando hash SHA256 final..." -Level "INFO"
        
        # Hash local
        $hashLocal = (Get-FileHash -Path $arquivoLocal -Algorithm SHA256).Hash.ToUpper()
        Write-Log "Hash SHA256 local: $hashLocal" -Level "INFO"
        
        # Hash remoto
        $hashRemotoResult = Invoke-SafeSSHCommand -Command "sha256sum $arquivoRemoto | cut -d' ' -f1"
        $hashRemoto = $hashRemotoResult.Trim().ToUpper()
        Write-Log "Hash SHA256 remoto: $hashRemoto" -Level "INFO"
        
        if ($hashLocal -eq $hashRemoto) {
            Write-Log "✅ Hash SHA256 local e remoto são idênticos" -Level "SUCCESS"
        } else {
            Write-Log "❌ Hash SHA256 não coincide!" -Level "ERROR"
            Write-Log "Local:  $hashLocal" -Level "ERROR"
            Write-Log "Remoto: $hashRemoto" -Level "ERROR"
            $erros++
        }
        
        Write-Host ""
        
        # 4. Verificar logs do servidor (últimas 50 linhas)
        Write-Log "4. Verificando logs do servidor..." -Level "INFO"
        
        try {
            $nginxErrorLog = Invoke-SafeSSHCommand -Command "tail -n 50 /var/log/nginx/error.log 2>/dev/null | grep -i '$arquivo' || echo 'Nenhum erro encontrado relacionado ao arquivo'"
            $phpErrorLog = Invoke-SafeSSHCommand -Command "tail -n 50 /var/log/php8.3-fpm.log 2>/dev/null | grep -i '$arquivo' || echo 'Nenhum erro encontrado relacionado ao arquivo'"
            
            if ($nginxErrorLog -match "error|erro|fail|falha" -or $phpErrorLog -match "error|erro|fail|falha") {
                Write-Log "⚠️ Possíveis erros encontrados nos logs:" -Level "WARN"
                if ($nginxErrorLog -match "error|erro|fail|falha") {
                    Write-Log "Nginx: $nginxErrorLog" -Level "WARN"
                }
                if ($phpErrorLog -match "error|erro|fail|falha") {
                    Write-Log "PHP-FPM: $phpErrorLog" -Level "WARN"
                }
                $avisos++
            } else {
                Write-Log "✅ Nenhum erro crítico encontrado nos logs" -Level "SUCCESS"
            }
        } catch {
            Write-Log "⚠️ Não foi possível verificar logs do servidor: $_" -Level "WARN"
            $avisos++
        }
        
        Write-Host ""
        
        # Resumo final
        Write-Log "========================================" -Level "INFO"
        Write-Log "RESUMO DA VALIDAÇÃO" -Level "INFO"
        Write-Log "========================================" -Level "INFO"
        
        if ($erros -eq 0) {
            Write-Log "✅ VALIDAÇÃO CONCLUÍDA COM SUCESSO" -Level "SUCCESS"
            if ($avisos -gt 0) {
                Write-Log "⚠️ $avisos aviso(s) encontrado(s) (não críticos)" -Level "WARN"
            }
            Write-Host ""
            Write-Log "Arquivo validado e pronto para uso em produção" -Level "SUCCESS"
        } else {
            Write-Log "❌ VALIDAÇÃO FALHOU - $erros erro(s) encontrado(s)" -Level "ERROR"
            Write-Host ""
            Write-Log "Arquivo pode não estar funcionando corretamente" -Level "ERROR"
            exit 1
        }
        
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

Start-Validation

