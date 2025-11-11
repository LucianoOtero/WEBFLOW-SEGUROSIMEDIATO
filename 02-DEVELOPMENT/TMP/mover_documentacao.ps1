# Script para mover arquivo de documentação
$arquivo = "PROJETO_ELIMINAR_URLS_HARDCODED.md"
$origem = Join-Path $PSScriptRoot "..\$arquivo"
$destino = Join-Path $PSScriptRoot "..\..\05-DOCUMENTATION\$arquivo"

Write-Host "=== MOVENDO ARQUIVO DE DOCUMENTACAO ===" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $origem) {
    $destinoDir = Split-Path $destino -Parent
    if (-not (Test-Path $destinoDir)) {
        New-Item -ItemType Directory -Path $destinoDir -Force | Out-Null
        Write-Host "Diretorio criado: $destinoDir" -ForegroundColor Yellow
    }
    
    Move-Item -Path $origem -Destination $destino -Force
    Write-Host "[OK] Arquivo movido:" -ForegroundColor Green
    Write-Host "  De: $origem" -ForegroundColor Gray
    Write-Host "  Para: $destino" -ForegroundColor Gray
} else {
    Write-Host "[ERRO] Arquivo nao encontrado: $origem" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== VERIFICACAO ===" -ForegroundColor Cyan
if (Test-Path $destino) {
    Write-Host "[OK] Arquivo confirmado em 05-DOCUMENTATION/" -ForegroundColor Green
} else {
    Write-Host "[ERRO] Arquivo nao encontrado no destino" -ForegroundColor Red
    exit 1
}

