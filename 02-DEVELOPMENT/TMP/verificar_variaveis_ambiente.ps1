# Script para verificar se todas as chamadas de .php e .js usam variaveis de ambiente

Write-Host "=== VERIFICACAO DE VARIAVEIS DE AMBIENTE ===" -ForegroundColor Cyan
Write-Host ""

# Arquivos principais do projeto (excluindo TMP, backups, Lixo)
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
    "email_template_loader.php",
    "aws_ses_config.php"
)

Write-Host "COMO AS VARIAVEIS SAO LIDAS:" -ForegroundColor Yellow
Write-Host "  PHP: via `$_ENV['VARIAVEL']` (definidas no PHP-FPM pool)" -ForegroundColor Cyan
Write-Host "  JavaScript: via `window.APP_BASE_URL` (definido em config_env.js.php)" -ForegroundColor Cyan
Write-Host ""

$problemas = @()
$arquivosOK = @()

foreach ($arquivo in $arquivosProjeto) {
    if (-not (Test-Path $arquivo)) {
        Write-Host "[AVISO] Arquivo nao encontrado: $arquivo" -ForegroundColor Yellow
        continue
    }
    
    $conteudo = Get-Content $arquivo -Raw
    $problemasArquivo = @()
    
    # Verificar URLs hardcoded
    if ($conteudo -match "https?://(dev\.)?bssegurosimediato\.com\.br|https?://mdmidia\.com\.br|https?://flyingdonkeys\.com\.br") {
        $matches = [regex]::Matches($conteudo, "https?://(dev\.)?bssegurosimediato\.com\.br|https?://mdmidia\.com\.br|https?://flyingdonkeys\.com\.br")
        foreach ($match in $matches) {
            # Verificar se nao e comentario ou documentacao
            $linha = ($conteudo.Substring(0, $match.Index) -split "`n").Count
            $contexto = ($conteudo.Substring([Math]::Max(0, $match.Index - 50), [Math]::Min(100, $match.Index)))
            if ($contexto -notmatch "^\s*//|^\s*\*|^\s*#|documentacao|exemplo|ex:") {
                $problemasArquivo += "Linha ~$linha: URL hardcoded encontrada: $($match.Value)"
            }
        }
    }
    
    # Verificar diretorios hardcoded
    if ($conteudo -match "/var/www/html|/tmp/|/opt/webhooks") {
        $matches = [regex]::Matches($conteudo, "/var/www/html|/tmp/|/opt/webhooks")
        foreach ($match in $matches) {
            $linha = ($conteudo.Substring(0, $match.Index) -split "`n").Count
            $contexto = ($conteudo.Substring([Math]::Max(0, $match.Index - 50), [Math]::Min(100, $match.Index)))
            if ($contexto -notmatch "^\s*//|^\s*\*|^\s*#|documentacao|exemplo|comentario") {
                $problemasArquivo += "Linha ~$linha: Diretorio hardcoded encontrado: $($match.Value)"
            }
        }
    }
    
    # Verificar chamadas de arquivos .php ou .js hardcoded
    if ($conteudo -match "['\"](https?://[^'\"]+)?/[^'\"]+\.(php|js)['\"]") {
        $matches = [regex]::Matches($conteudo, "['\"](https?://[^'\"]+)?/[^'\"]+\.(php|js)['\"]")
        foreach ($match in $matches) {
            $valor = $match.Value
            # Ignorar se usar variaveis de ambiente
            if ($valor -notmatch '\$_ENV|window\.APP_BASE_URL|getBaseUrl|getEndpointUrl|getBaseDir') {
                $linha = ($conteudo.Substring(0, $match.Index) -split "`n").Count
                $contexto = ($conteudo.Substring([Math]::Max(0, $match.Index - 50), [Math]::Min(100, $match.Index)))
                if ($contexto -notmatch "^\s*//|^\s*\*|^\s*#|documentacao|exemplo|comentario|backup") {
                    $problemasArquivo += "Linha ~$linha: Chamada hardcoded encontrada: $valor"
                }
            }
        }
    }
    
    # Verificar fallbacks hardcoded
    if ($conteudo -match "\?\?\s*['\"](https?://|/var/www|/tmp)") {
        $matches = [regex]::Matches($conteudo, "\?\?\s*['\"](https?://|/var/www|/tmp)")
        foreach ($match in $matches) {
            $linha = ($conteudo.Substring(0, $match.Index) -split "`n").Count
            $problemasArquivo += "Linha ~$linha: Fallback hardcoded encontrado: $($match.Value)"
        }
    }
    
    if ($problemasArquivo.Count -gt 0) {
        Write-Host "[PROBLEMA] $arquivo" -ForegroundColor Red
        $problemasArquivo | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
        $problemas += @{
            Arquivo = $arquivo
            Problemas = $problemasArquivo
        }
    } else {
        Write-Host "[OK] $arquivo" -ForegroundColor Green
        $arquivosOK += $arquivo
    }
}

Write-Host ""
Write-Host "=== RESUMO ===" -ForegroundColor Cyan
Write-Host "Arquivos OK: $($arquivosOK.Count)/$($arquivosProjeto.Count)" -ForegroundColor $(if ($arquivosOK.Count -eq $arquivosProjeto.Count) { "Green" } else { "Yellow" })
Write-Host "Arquivos com problemas: $($problemas.Count)" -ForegroundColor $(if ($problemas.Count -eq 0) { "Green" } else { "Red" })

if ($problemas.Count -gt 0) {
    Write-Host ""
    Write-Host "PROBLEMAS ENCONTRADOS:" -ForegroundColor Red
    foreach ($problema in $problemas) {
        Write-Host ""
        Write-Host "  $($problema.Arquivo):" -ForegroundColor Yellow
        $problema.Problemas | ForEach-Object { Write-Host "    - $_" -ForegroundColor Red }
    }
}

