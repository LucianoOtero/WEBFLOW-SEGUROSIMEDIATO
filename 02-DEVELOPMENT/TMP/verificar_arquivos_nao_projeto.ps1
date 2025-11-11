# Script para verificar arquivos que não são do projeto
$arquivosProjeto = @(
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

Write-Host "=== ARQUIVOS NO DEV DO WINDOWS ===" -ForegroundColor Cyan
Write-Host ""

$todosArquivos = Get-ChildItem -File | Select-Object -ExpandProperty Name
Write-Host "Total de arquivos no diretorio: $($todosArquivos.Count)" -ForegroundColor Cyan
Write-Host ""

Write-Host "Arquivos que NAO sao do projeto:" -ForegroundColor Yellow
Write-Host ""

$naoProjeto = @()
foreach ($arquivo in $todosArquivos) {
    if ($arquivosProjeto -notcontains $arquivo) {
        $naoProjeto += $arquivo
        Write-Host "  - $arquivo" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== RESUMO ===" -ForegroundColor Cyan
Write-Host "Arquivos do projeto: $($arquivosProjeto.Count)" -ForegroundColor Green
Write-Host "Arquivos que NAO sao do projeto: $($naoProjeto.Count)" -ForegroundColor $(if ($naoProjeto.Count -eq 0) { "Green" } else { "Yellow" })

if ($naoProjeto.Count -gt 0) {
    Write-Host ""
    Write-Host "Categorizacao:" -ForegroundColor Cyan
    $scripts = $naoProjeto | Where-Object { $_ -like "*.ps1" }
    $documentacao = $naoProjeto | Where-Object { $_ -like "*.md" }
    $outros = $naoProjeto | Where-Object { $_ -notlike "*.ps1" -and $_ -notlike "*.md" }
    
    if ($scripts.Count -gt 0) {
        Write-Host "  Scripts PowerShell ($($scripts.Count)):" -ForegroundColor Cyan
        $scripts | ForEach-Object { Write-Host "    - $_" -ForegroundColor Gray }
    }
    
    if ($documentacao.Count -gt 0) {
        Write-Host "  Documentacao ($($documentacao.Count)):" -ForegroundColor Cyan
        $documentacao | ForEach-Object { Write-Host "    - $_" -ForegroundColor Gray }
    }
    
    if ($outros.Count -gt 0) {
        Write-Host "  Outros ($($outros.Count)):" -ForegroundColor Cyan
        $outros | ForEach-Object { Write-Host "    - $_" -ForegroundColor Gray }
    }
}

