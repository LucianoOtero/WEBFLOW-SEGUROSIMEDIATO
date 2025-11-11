# Script para verificar prontidao do projeto
Write-Host "=== VERIFICACAO DE PRONTIDAO DO PROJETO ===" -ForegroundColor Cyan
Write-Host ""

$pronto = $true
$problemas = @()

# Arquivos que serao modificados
$arquivosModificar = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js",
    "add_flyingdonkeys.php",
    "add_webflow_octa.php",
    "config.php",
    "config_env.js.php",
    "ProfessionalLogger.php"
)

Write-Host "1. Verificando arquivos que serao modificados..." -ForegroundColor Yellow
foreach ($arquivo in $arquivosModificar) {
    if (Test-Path $arquivo) {
        Write-Host "  [OK] $arquivo" -ForegroundColor Green
    } else {
        Write-Host "  [FALTANDO] $arquivo" -ForegroundColor Red
        $problemas += "Arquivo faltando: $arquivo"
        $pronto = $false
    }
}

Write-Host ""
Write-Host "2. Verificando estrutura de backups..." -ForegroundColor Yellow
if (Test-Path "backups") {
    Write-Host "  [OK] Diretorio de backups existe" -ForegroundColor Green
} else {
    Write-Host "  [AVISO] Diretorio de backups nao existe (sera criado)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "3. Verificando projeto documentado..." -ForegroundColor Yellow
$projetoDoc = "..\05-DOCUMENTATION\PROJETO_ELIMINAR_URLS_HARDCODED.md"
if (Test-Path $projetoDoc) {
    Write-Host "  [OK] Projeto documentado em 05-DOCUMENTATION/" -ForegroundColor Green
} else {
    Write-Host "  [ERRO] Projeto nao encontrado em 05-DOCUMENTATION/" -ForegroundColor Red
    $problemas += "Projeto nao encontrado"
    $pronto = $false
}

Write-Host ""
Write-Host "=== RESUMO ===" -ForegroundColor Cyan
if ($pronto) {
    Write-Host "STATUS: PRONTO PARA EXECUTAR" -ForegroundColor Green
    Write-Host ""
    Write-Host "Total de arquivos a modificar: $($arquivosModificar.Count)" -ForegroundColor Cyan
    Write-Host "Total de problemas identificados: 24" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Proximo passo: Aguardar autorizacao para iniciar Fase 1 (Backups)" -ForegroundColor Yellow
} else {
    Write-Host "STATUS: NAO PRONTO" -ForegroundColor Red
    Write-Host ""
    Write-Host "Problemas encontrados:" -ForegroundColor Red
    $problemas | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}

