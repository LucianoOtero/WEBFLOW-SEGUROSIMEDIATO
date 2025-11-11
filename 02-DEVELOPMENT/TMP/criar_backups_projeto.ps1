# Script para criar backups dos arquivos que serao modificados
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

$backupDir = "..\04-BACKUPS\2025-11-10_ELIMINACAO_URLS_HARDCODED"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "=== CRIANDO BACKUPS ===" -ForegroundColor Cyan
Write-Host ""

$backupsCriados = 0
$erros = 0

foreach ($arquivo in $arquivosModificar) {
    if (Test-Path $arquivo) {
        $backupPath = Join-Path $backupDir "$arquivo.backup_$timestamp"
        try {
            Copy-Item -Path $arquivo -Destination $backupPath -Force
            Write-Host "[OK] Backup criado: $arquivo" -ForegroundColor Green
            $backupsCriados++
        } catch {
            Write-Host "[ERRO] Falha ao criar backup: $arquivo" -ForegroundColor Red
            Write-Host "  Erro: $_" -ForegroundColor Red
            $erros++
        }
    } else {
        Write-Host "[AVISO] Arquivo nao encontrado: $arquivo" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== RESUMO ===" -ForegroundColor Cyan
Write-Host "Backups criados: $backupsCriados" -ForegroundColor Green
Write-Host "Erros: $erros" -ForegroundColor $(if ($erros -eq 0) { "Green" } else { "Red" })
Write-Host "Diretorio: $backupDir" -ForegroundColor Cyan

