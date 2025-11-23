# Script simples para copiar arquivos DEV -> PROD Local
$workspaceRoot = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$devDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"
$prodDir = Join-Path $workspaceRoot "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION"

# Criar diretorio PROD se nao existir
if (-not (Test-Path $prodDir)) {
    New-Item -ItemType Directory -Path $prodDir -Force | Out-Null
    Write-Host "Diretorio PROD criado: $prodDir" -ForegroundColor Green
}

# Arquivos a copiar
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
Write-Host "FASE 2: COPIA DEV -> PROD LOCAL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$copiados = 0
$faltando = 0
$resultados = @{}

foreach ($arquivo in $arquivos) {
    $origem = Join-Path $devDir $arquivo
    $destino = Join-Path $prodDir $arquivo
    
    if (Test-Path $origem) {
        # Calcular hash do arquivo DEV
        $hashDev = (Get-FileHash -Path $origem -Algorithm SHA256).Hash.ToUpper()
        
        # Copiar arquivo
        Copy-Item -Path $origem -Destination $destino -Force
        
        # Calcular hash do arquivo PROD copiado
        $hashProd = (Get-FileHash -Path $destino -Algorithm SHA256).Hash.ToUpper()
        
        # Validar integridade
        if ($hashDev -eq $hashProd) {
            Write-Host "[OK] $arquivo - Hash validado" -ForegroundColor Green
            $resultados[$arquivo] = @{
                HashDev = $hashDev
                HashProd = $hashProd
                Status = "OK"
            }
            $copiados++
        } else {
            Write-Host "[ERRO] $arquivo - Hashes nao coincidem!" -ForegroundColor Red
            $resultados[$arquivo] = @{
                HashDev = $hashDev
                HashProd = $hashProd
                Status = "ERROR"
            }
            $faltando++
        }
    } else {
        Write-Host "[FALTANDO] $arquivo - Arquivo nao encontrado em DEV" -ForegroundColor Yellow
        $faltando++
    }
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESUMO:" -ForegroundColor Cyan
Write-Host "  Copiados com sucesso: $copiados" -ForegroundColor Green
Write-Host "  Erros/Faltando: $faltando" -ForegroundColor $(if ($faltando -gt 0) { "Red" } else { "Green" })
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
$docContent += "- **Copiados com sucesso:** $copiados`n"
$docContent += "- **Erros/Faltando:** $faltando`n`n"
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

