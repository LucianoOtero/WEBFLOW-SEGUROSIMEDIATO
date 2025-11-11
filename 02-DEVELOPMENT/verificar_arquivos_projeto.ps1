# Script para verificar se todos os arquivos do projeto estao presentes
# Uso: .\verificar_arquivos_projeto.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "VERIFICACAO DE ARQUIVOS DO PROJETO" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

$faltantes = @()
$presentes = @()

# Arquivos principais (baseado na arvore de dependencias completa)
$arquivos = @(
    # Nivel 1 - Raiz
    "FooterCodeSiteDefinitivoCompleto.js",
    
    # Nivel 2 - Carregados pelo raiz
    "config_env.js.php",
    "log_endpoint.php",
    "cpf-validate.php",
    "placa-validate.php",
    "webflow_injection_limpo.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    
    # Nivel 3 - Chamados pelo modal
    "add_flyingdonkeys.php",
    "add_webflow_octa.php",
    "send_email_notification_endpoint.php",
    
    # Nivel 4 - Base e dependencias
    "config.php",
    "class.php",
    "ProfessionalLogger.php",
    "send_admin_notification_ses.php",
    
    # Nivel 5 - Dependencias profundas
    "aws_ses_config.php",
    "email_template_loader.php",
    "composer.json"
)

Write-Host "Verificando arquivos principais..." -ForegroundColor Yellow
foreach ($arquivo in $arquivos) {
    if (Test-Path $arquivo) {
        $presentes += $arquivo
        Write-Host "  [OK] $arquivo" -ForegroundColor Green
    } else {
        $faltantes += $arquivo
        Write-Host "  [FALTANDO] $arquivo" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Verificando templates de email..." -ForegroundColor Yellow
$templates = @(
    "email_templates\template_logging.php",
    "email_templates\template_modal.php",
    "email_templates\template_primeiro_contato.php"
)

foreach ($template in $templates) {
    if (Test-Path $template) {
        Write-Host "  [OK] $template" -ForegroundColor Green
    } else {
        if ($template -like "*template_primeiro_contato*") {
            Write-Host "  [OPCIONAL] $template (nao existe, pode ser opcional)" -ForegroundColor Yellow
        } else {
            Write-Host "  [FALTANDO] $template" -ForegroundColor Red
            $faltantes += $template
        }
    }
}

Write-Host ""
Write-Host "Verificando arquivos de configuracao..." -ForegroundColor Yellow
if (Test-Path "config\dev_config.php") {
    Write-Host "  [OK] config/dev_config.php" -ForegroundColor Green
} else {
    Write-Host "  [CONDICIONAL] config/dev_config.php (nao existe, e condicional)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "RESUMO" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""
Write-Host "Arquivos presentes: $($presentes.Count)" -ForegroundColor Green
Write-Host "Arquivos faltantes: $($faltantes.Count)" -ForegroundColor $(if ($faltantes.Count -eq 0) { "Green" } else { "Red" })

if ($faltantes.Count -gt 0) {
    Write-Host ""
    Write-Host "ARQUIVOS FALTANTES:" -ForegroundColor Red
    foreach ($arquivo in $faltantes) {
        Write-Host "  - $arquivo" -ForegroundColor Yellow
    }
    
    # Verificar se existe em backup
    Write-Host ""
    Write-Host "Verificando se existem em backup..." -ForegroundColor Yellow
    foreach ($arquivo in $faltantes) {
        $nomeArquivo = Split-Path -Leaf $arquivo
        $backup = Get-ChildItem -Path "backups" -Recurse -Filter "*$nomeArquivo*" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($backup) {
            Write-Host "  [BACKUP ENCONTRADO] $arquivo -> $($backup.FullName)" -ForegroundColor Cyan
        }
    }
} else {
    Write-Host ""
    Write-Host "TODOS OS ARQUIVOS PRINCIPAIS ESTAO PRESENTES!" -ForegroundColor Green
}

Write-Host ""

