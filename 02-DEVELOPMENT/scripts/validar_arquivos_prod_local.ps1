# Validar arquivos em PROD Local e calcular hashes
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$devDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"
$prodDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"

$arquivos = @(
    "FooterCodeSiteDefinitivoCompleto.js",
    "MODAL_WHATSAPP_DEFINITIVO.js",
    "webflow_injection_limpo.js",
    "config.php",
    "config_env.js.php",
    "add_webflow_octa.php",
    "add_flyingdonkeys.php",
    "cpf-validate.php",
    "placa-validate.php",
    "log_endpoint.php",
    "ProfessionalLogger.php",
    "aws_ses_config.php"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VALIDACAO DE ARQUIVOS PROD LOCAL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$resultados = @{}
$validados = 0
$faltando = 0

foreach ($arquivo in $arquivos) {
    $arquivoDev = Join-Path $devDir $arquivo
    $arquivoProd = Join-Path $prodDir $arquivo
    
    if (Test-Path $arquivoDev) {
        $hashDev = (Get-FileHash -Path $arquivoDev -Algorithm SHA256).Hash.ToUpper()
        
        if (Test-Path $arquivoProd) {
            $hashProd = (Get-FileHash -Path $arquivoProd -Algorithm SHA256).Hash.ToUpper()
            
            if ($hashDev -eq $hashProd) {
                Write-Host "[OK] $arquivo - Hash validado" -ForegroundColor Green
                $resultados[$arquivo] = @{
                    HashDev = $hashDev
                    HashProd = $hashProd
                    Status = "OK"
                }
                $validados++
            } else {
                Write-Host "[DIFERENTE] $arquivo - Hashes diferentes!" -ForegroundColor Yellow
                Write-Host "  DEV:  $hashDev" -ForegroundColor Gray
                Write-Host "  PROD: $hashProd" -ForegroundColor Gray
                $resultados[$arquivo] = @{
                    HashDev = $hashDev
                    HashProd = $hashProd
                    Status = "DIFERENTE"
                }
                # Copiar arquivo DEV para PROD
                Copy-Item -Path $arquivoDev -Destination $arquivoProd -Force
                Write-Host "  Arquivo atualizado em PROD" -ForegroundColor Green
                $validados++
            }
        } else {
            Write-Host "[COPIANDO] $arquivo - Copiando de DEV para PROD" -ForegroundColor Yellow
            Copy-Item -Path $arquivoDev -Destination $arquivoProd -Force
            $hashProd = (Get-FileHash -Path $arquivoProd -Algorithm SHA256).Hash.ToUpper()
            Write-Host "[OK] $arquivo - Copiado e validado" -ForegroundColor Green
            $resultados[$arquivo] = @{
                HashDev = $hashDev
                HashProd = $hashProd
                Status = "OK"
            }
            $validados++
        }
    } else {
        Write-Host "[FALTANDO] $arquivo - Arquivo nao encontrado em DEV" -ForegroundColor Red
        $faltando++
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESUMO:" -ForegroundColor Cyan
Write-Host "  Validados/Copiados: $validados" -ForegroundColor Green
Write-Host "  Faltando: $faltando" -ForegroundColor $(if ($faltando -gt 0) { "Red" } else { "Green" })
Write-Host "========================================" -ForegroundColor Cyan

# Salvar documento de hash
$docDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION"
if (-not (Test-Path $docDir)) {
    New-Item -ItemType Directory -Path $docDir -Force | Out-Null
}

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$docFile = Join-Path $docDir "HASHES_ARQUIVOS_PROD_LOCAL_$timestamp.md"

$docContent = "# Hash SHA256 dos Arquivos em PROD Local`n`n"
$docContent += "**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
$docContent += "**Fase:** FASE 2 - Copia para PROD Local (Windows)`n`n"
$docContent += "## Resumo`n`n"
$docContent += "- **Total de arquivos:** $($arquivos.Count)`n"
$docContent += "- **Validados/Copiados:** $validados`n"
$docContent += "- **Faltando:** $faltando`n`n"
$docContent += "## Arquivos`n`n"
$docContent += "| Arquivo | Hash SHA256 | Status |`n"
$docContent += "|---------|-------------|--------|`n"

foreach ($arquivo in $arquivos) {
    if ($resultados.ContainsKey($arquivo)) {
        $docContent += "| $arquivo | $($resultados[$arquivo].HashDev) | $($resultados[$arquivo].Status) |`n"
    } else {
        $docContent += "| $arquivo | N/A | FALTANDO |`n"
    }
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($docFile, $docContent, $utf8NoBom)

Write-Host "Documento de hash salvo em: $docFile" -ForegroundColor Green

