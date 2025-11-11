# Script para verificar se todos os arquivos do projeto estao no raiz de 02-DEVELOPMENT

Write-Host "=== VERIFICACAO DE ARQUIVOS NO RAIZ DEV ===" -ForegroundColor Cyan
Write-Host ""

# Lista de arquivos do projeto (baseada na arvore de dependencias)
$arquivosProjeto = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js",
    "config.php",
    "config_env.js.php",
    "add_flyingdonkeys.php",
    "add_webflow_octa.php",
    "ProfessionalLogger.php",
    "log_endpoint.php",
    "send_email_notification_endpoint.php",
    "send_admin_notification_ses.php",
    "class.php",
    "cpf-validate.php",
    "placa-validate.php",
    "email_template_loader.php"
)

# Obter todos os arquivos no diretorio (excluindo diretorios e arquivos .ps1)
$arquivosNoDiretorio = Get-ChildItem -Path . -File | Where-Object { 
    $_.Extension -ne '.ps1' -and 
    $_.Name -notlike '*.backup*' -and
    $_.Name -notlike '*_backup*'
} | Select-Object -ExpandProperty Name

Write-Host "Arquivos do projeto esperados: $($arquivosProjeto.Count)" -ForegroundColor Yellow
Write-Host "Arquivos encontrados no diretorio: $($arquivosNoDiretorio.Count)" -ForegroundColor Yellow
Write-Host ""

# Verificar quais arquivos do projeto estao presentes
$arquivosPresentes = @()
$arquivosFaltando = @()

foreach ($arquivo in $arquivosProjeto) {
    if ($arquivosNoDiretorio -contains $arquivo) {
        $arquivosPresentes += $arquivo
        Write-Host "[OK] $arquivo" -ForegroundColor Green
    } else {
        $arquivosFaltando += $arquivo
        Write-Host "[FALTANDO] $arquivo" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== ARQUIVOS QUE NAO SAO DO PROJETO ===" -ForegroundColor Cyan
Write-Host ""

# Verificar quais arquivos no diretorio nao sao do projeto
$arquivosNaoProjeto = @()
foreach ($arquivo in $arquivosNoDiretorio) {
    if ($arquivosProjeto -notcontains $arquivo) {
        $arquivosNaoProjeto += $arquivo
        Write-Host "[NAO PROJETO] $arquivo" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== RESUMO ===" -ForegroundColor Cyan
Write-Host "Arquivos do projeto presentes: $($arquivosPresentes.Count)/$($arquivosProjeto.Count)" -ForegroundColor $(if ($arquivosPresentes.Count -eq $arquivosProjeto.Count) { "Green" } else { "Yellow" })
Write-Host "Arquivos do projeto faltando: $($arquivosFaltando.Count)" -ForegroundColor $(if ($arquivosFaltando.Count -eq 0) { "Green" } else { "Red" })
Write-Host "Arquivos nao do projeto: $($arquivosNaoProjeto.Count)" -ForegroundColor $(if ($arquivosNaoProjeto.Count -eq 0) { "Green" } else { "Yellow" })

if ($arquivosFaltando.Count -gt 0) {
    Write-Host ""
    Write-Host "ARQUIVOS FALTANDO:" -ForegroundColor Red
    $arquivosFaltando | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

if ($arquivosNaoProjeto.Count -gt 0) {
    Write-Host ""
    Write-Host "ARQUIVOS NAO DO PROJETO (podem ser utilitarios ou temporarios):" -ForegroundColor Yellow
    $arquivosNaoProjeto | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}

