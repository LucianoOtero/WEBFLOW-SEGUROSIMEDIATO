# Script para mover arquivos que nao fazem parte do projeto para TMP
# Uso: .\mover_arquivos_tmp.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "ORGANIZACAO DE ARQUIVOS - MOVENDO PARA TMP" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

# Lista de arquivos do projeto (19 arquivos essenciais)
$arquivosProjeto = @(
    # Arquivos principais
    "FooterCodeSiteDefinitivoCompleto.js",
    "config_env.js.php",
    "log_endpoint.php",
    "cpf-validate.php",
    "placa-validate.php",
    "webflow_injection_limpo.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "add_flyingdonkeys.php",
    "add_webflow_octa.php",
    "send_email_notification_endpoint.php",
    "config.php",
    "class.php",
    "ProfessionalLogger.php",
    "send_admin_notification_ses.php",
    "aws_ses_config.php",
    "email_template_loader.php",
    "composer.json",
    
    # Scripts de deploy (manter)
    "copiar_arquivos_servidor.ps1",
    "verificar_integridade_arquivos.ps1",
    "verificar_arquivos_projeto.ps1",
    "mover_arquivos_tmp.ps1"
)

# Diretorios que devem ser mantidos
$diretoriosManter = @(
    "backups",
    "email_templates",
    "config",
    "Lixo"
)

# Criar diretorio TMP se nao existir
$tmpDir = Join-Path $scriptDir "TMP"
if (-not (Test-Path $tmpDir)) {
    New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null
    Write-Host "Diretorio TMP criado" -ForegroundColor Green
}

Write-Host "Arquivos do projeto (serao mantidos):" -ForegroundColor Yellow
foreach ($arquivo in $arquivosProjeto) {
    Write-Host "  - $arquivo" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Diretorios que serao mantidos:" -ForegroundColor Yellow
foreach ($dir in $diretoriosManter) {
    Write-Host "  - $dir/" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Procurando arquivos para mover..." -ForegroundColor Yellow

$movidos = 0
$erros = 0

# Obter todos os arquivos no diretorio (nao recursivo)
$todosArquivos = Get-ChildItem -Path $scriptDir -File | Where-Object { 
    $_.Name -notlike ".*" -and 
    $_.Extension -ne ".lock" 
}

foreach ($arquivo in $todosArquivos) {
    $nomeArquivo = $arquivo.Name
    
    # Verificar se arquivo nao esta na lista do projeto
    if ($arquivosProjeto -notcontains $nomeArquivo) {
        try {
            $destino = Join-Path $tmpDir $nomeArquivo
            Move-Item -Path $arquivo.FullName -Destination $destino -Force
            Write-Host "  [MOVIDO] $nomeArquivo -> TMP/" -ForegroundColor Green
            $movidos++
        } catch {
            Write-Host "  [ERRO] Falha ao mover $nomeArquivo : $($_.Exception.Message)" -ForegroundColor Red
            $erros++
        }
    }
}

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "RESUMO" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""
Write-Host "Arquivos movidos: $movidos" -ForegroundColor Green
Write-Host "Erros: $erros" -ForegroundColor $(if ($erros -eq 0) { "Green" } else { "Red" })
Write-Host ""
Write-Host "Arquivos do projeto mantidos no diretorio principal" -ForegroundColor Green
Write-Host ""

