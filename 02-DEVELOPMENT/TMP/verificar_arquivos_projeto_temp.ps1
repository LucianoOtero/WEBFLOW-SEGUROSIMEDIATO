# Script temporário para verificar arquivos do projeto
$arquivosEsperados = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js",
    "add_flyingdonkeys.php",
    "add_webflow_octa.php",
    "aws_ses_config.php",
    "class.php",
    "config_env.js.php",
    "config.php",
    "cpf-validate.php",
    "email_template_loader.php",
    "log_endpoint.php",
    "placa-validate.php",
    "ProfessionalLogger.php",
    "send_admin_notification_ses.php",
    "send_email_notification_endpoint.php",
    "composer.json"
)

Write-Host "=== VERIFICACAO DE ARQUIVOS DO PROJETO ===" -ForegroundColor Cyan
Write-Host ""

$faltantes = @()
$presentes = @()

foreach ($arquivo in $arquivosEsperados) {
    if (Test-Path $arquivo) {
        Write-Host "[OK] $arquivo" -ForegroundColor Green
        $presentes += $arquivo
    } else {
        Write-Host "[FALTANDO] $arquivo" -ForegroundColor Red
        $faltantes += $arquivo
    }
}

Write-Host ""
Write-Host "Templates de email:" -ForegroundColor Cyan

if (Test-Path "email_templates\template_logging.php") {
    Write-Host "[OK] email_templates\template_logging.php" -ForegroundColor Green
    $presentes += "email_templates\template_logging.php"
} else {
    Write-Host "[FALTANDO] email_templates\template_logging.php" -ForegroundColor Red
    $faltantes += "email_templates\template_logging.php"
}

if (Test-Path "email_templates\template_modal.php") {
    Write-Host "[OK] email_templates\template_modal.php" -ForegroundColor Green
    $presentes += "email_templates\template_modal.php"
} else {
    Write-Host "[FALTANDO] email_templates\template_modal.php" -ForegroundColor Red
    $faltantes += "email_templates\template_modal.php"
}

Write-Host ""
Write-Host "=== RESUMO ===" -ForegroundColor Cyan
Write-Host "Arquivos presentes: $($presentes.Count)" -ForegroundColor Green
Write-Host "Arquivos faltando: $($faltantes.Count)" -ForegroundColor $(if ($faltantes.Count -eq 0) { "Green" } else { "Red" })

if ($faltantes.Count -eq 0) {
    Write-Host ""
    Write-Host "RESULTADO: Todos os 19 arquivos estao presentes no DEV do Windows!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "RESULTADO: $($faltantes.Count) arquivo(s) faltando:" -ForegroundColor Red
    $faltantes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

