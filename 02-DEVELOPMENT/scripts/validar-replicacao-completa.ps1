# Script para validar replicação completa comparando DEV vs PROD
# Uso: .\validar-replicacao-completa.ps1

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "VALIDACAO COMPLETA: DEV vs PROD" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Configurações
$servidorDev = "root@65.108.156.14"
$servidorProd = "root@157.180.36.223"
$caminhoDev = "/var/www/html/dev/root"
$caminhoProd = "/var/www/html/prod/root"

# Lista de arquivos para validar (do documento de tracking)
$arquivosPHP = @(
    "config.php",
    "config_env.js.php",
    "cpf-validate.php",
    "placa-validate.php",
    "aws_ses_config.php",
    "add_webflow_octa.php",
    "send_admin_notification_ses.php",
    "ProfessionalLogger.php",
    "log_endpoint.php"
)

$arquivosJS = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js"
)

$erros = 0
$sucessos = 0

Write-Host "🔍 Validando arquivos PHP..." -ForegroundColor Cyan
Write-Host ""

foreach ($arquivo in $arquivosPHP) {
    Write-Host "  📄 $arquivo..." -ForegroundColor Gray -NoNewline
    
    # Obter hash DEV
    $hashDev = (ssh $servidorDev "sha256sum ${caminhoDev}/${arquivo} 2>/dev/null | cut -d' ' -f1").ToUpper()
    
    # Obter hash PROD
    $hashProd = (ssh $servidorProd "sha256sum ${caminhoProd}/${arquivo} 2>/dev/null | cut -d' ' -f1").ToUpper()
    
    if ([string]::IsNullOrEmpty($hashDev)) {
        Write-Host " ⚠️ Não existe em DEV" -ForegroundColor Yellow
        $erros++
    } elseif ([string]::IsNullOrEmpty($hashProd)) {
        Write-Host " ⚠️ Não existe em PROD" -ForegroundColor Yellow
        $erros++
    } elseif ($hashDev -eq $hashProd) {
        Write-Host " ✅ OK" -ForegroundColor Green
        $sucessos++
    } else {
        Write-Host " ❌ Hash diferente" -ForegroundColor Red
        Write-Host "    DEV:  $hashDev" -ForegroundColor Red
        Write-Host "    PROD: $hashProd" -ForegroundColor Red
        $erros++
    }
}

Write-Host ""
Write-Host "🔍 Validando arquivos JavaScript..." -ForegroundColor Cyan
Write-Host ""

foreach ($arquivo in $arquivosJS) {
    Write-Host "  📄 $arquivo..." -ForegroundColor Gray -NoNewline
    
    # Obter hash DEV
    $hashDev = (ssh $servidorDev "sha256sum ${caminhoDev}/${arquivo} 2>/dev/null | cut -d' ' -f1").ToUpper()
    
    # Obter hash PROD
    $hashProd = (ssh $servidorProd "sha256sum ${caminhoProd}/${arquivo} 2>/dev/null | cut -d' ' -f1").ToUpper()
    
    if ([string]::IsNullOrEmpty($hashDev)) {
        Write-Host " ⚠️ Não existe em DEV" -ForegroundColor Yellow
        $erros++
    } elseif ([string]::IsNullOrEmpty($hashProd)) {
        Write-Host " ⚠️ Não existe em PROD" -ForegroundColor Yellow
        $erros++
    } elseif ($hashDev -eq $hashProd) {
        Write-Host " ✅ OK" -ForegroundColor Green
        $sucessos++
    } else {
        Write-Host " ❌ Hash diferente" -ForegroundColor Red
        Write-Host "    DEV:  $hashDev" -ForegroundColor Red
        Write-Host "    PROD: $hashProd" -ForegroundColor Red
        $erros++
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "RESULTADO DA VALIDACAO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Sucessos: $sucessos" -ForegroundColor Green
Write-Host "❌ Erros: $erros" -ForegroundColor $(if ($erros -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($erros -eq 0) {
    Write-Host "🎉 VALIDAÇÃO COMPLETA: Todos os arquivos estão sincronizados!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "⚠️ ATENÇÃO: Encontrados $erros arquivo(s) com diferenças" -ForegroundColor Yellow
    Write-Host "   Revise os arquivos listados acima" -ForegroundColor Yellow
    exit 1
}

