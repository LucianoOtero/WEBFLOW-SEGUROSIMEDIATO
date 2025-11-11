# Script para copiar arquivos do Windows para o servidor
# Uso: .\copiar_arquivos_servidor.ps1

# Configuracoes
$servidor = "root@65.108.156.14"
# Obter diretorio do script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$devLocal = $scriptDir
$devRemoto = "/var/www/html/dev/root"

Write-Host "Iniciando copia de arquivos para o servidor..." -ForegroundColor Cyan
Write-Host ""

# Verificar integridade antes de copiar
Write-Host "Verificando integridade dos arquivos..." -ForegroundColor Yellow
$scriptVerificacao = Join-Path $devLocal "verificar_integridade_arquivos.ps1"
if (Test-Path $scriptVerificacao) {
    & $scriptVerificacao
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "[ERRO] Verificacao de integridade falhou!" -ForegroundColor Red
        Write-Host "   Corrija os erros antes de copiar arquivos." -ForegroundColor Red
        exit 1
    }
    Write-Host ""
} else {
    Write-Host "[AVISO] Script de verificacao nao encontrado. Continuando sem verificacao..." -ForegroundColor Yellow
    Write-Host ""
}

# Verificar se diretorio local existe
if (-not (Test-Path $devLocal)) {
    Write-Host "[ERRO] Diretorio DEV nao encontrado: $devLocal" -ForegroundColor Red
    exit 1
}

# Arquivos PHP para DEV
$arquivosPHPDev = @(
    "config.php",
    "add_flyingdonkeys.php",
    "add_webflow_octa.php",
    "send_email_notification_endpoint.php",
    "send_admin_notification_ses.php",
    "class.php",
    "cpf-validate.php",
    "placa-validate.php",
    "composer.json",
    "config_env.js.php"
)

# Arquivos adicionais para DEV (se existirem)
$arquivosAdicionaisDev = @(
    "ProfessionalLogger.php",
    "log_endpoint.php",
    "email_template_loader.php"
    # ⚠️ aws_ses_config.php REMOVIDO - NÃO copiar automaticamente
    # Use: .\copiar_aws_ses_config_servidor.ps1 (com verificação de segurança)
    # Motivo: Arquivo modificado para usar variáveis de ambiente
    #         Requer verificação antes de copiar para não quebrar servidor
)

# ⚠️ ARQUIVOS EXCLUÍDOS DO DEPLOY AUTOMÁTICO (contêm credenciais ou são específicos do servidor)
$arquivosExcluidos = @(
    "aws_ses_config.php",  # Contém credenciais - usar script específico
    ".env.local",           # Arquivo local com credenciais
    "CREDENCIAIS_AWS_REFERENCIA.txt"  # Arquivo de referência local
)

# Arquivos JS para DEV
$arquivosJSDev = @(
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "FooterCodeSiteDefinitivoCompleto.js",
    "webflow_injection_limpo.js"
)

# Copiar arquivos DEV
Write-Host "Copiando arquivos DEV..." -ForegroundColor Cyan
$copiadosDev = 0
$falhasDev = 0

foreach ($arquivo in ($arquivosPHPDev + $arquivosAdicionaisDev + $arquivosJSDev)) {
    $origem = Join-Path $devLocal $arquivo
    if (Test-Path $origem) {
        try {
            Write-Host "  [OK] Copiando: $arquivo" -ForegroundColor Green
            scp -q $origem "${servidor}:${devRemoto}/"
            $copiadosDev++
        } catch {
            Write-Host "  [ERRO] Erro ao copiar: $arquivo - $($_.Exception.Message)" -ForegroundColor Red
            $falhasDev++
        }
    } else {
        Write-Host "  [AVISO] Nao encontrado: $arquivo" -ForegroundColor Yellow
        $falhasDev++
    }
}

Write-Host ""
Write-Host "DEV: $copiadosDev copiados, $falhasDev falhas" -ForegroundColor $(if ($falhasDev -eq 0) { "Green" } else { "Yellow" })

# Resumo final
Write-Host ""
$separador = "=" * 50
Write-Host $separador -ForegroundColor Cyan
Write-Host "Copia concluida!" -ForegroundColor Green
Write-Host "  DEV: $copiadosDev arquivos copiados para /var/www/html/dev/root/" -ForegroundColor Green
Write-Host "  Acessivel via: https://dev.bssegurosimediato.com.br/" -ForegroundColor Green
Write-Host $separador -ForegroundColor Cyan
