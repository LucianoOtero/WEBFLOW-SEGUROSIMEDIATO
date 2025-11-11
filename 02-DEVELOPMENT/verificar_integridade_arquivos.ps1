# Script para verificar integridade de todos os arquivos antes de copiar para o servidor
# Uso: .\verificar_integridade_arquivos.ps1

# Obter diretorio do script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# O script esta em WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/, entao o basePath e o parent do scriptDir
$basePath = Split-Path -Parent $scriptDir

$devLocal = Join-Path $basePath "02-DEVELOPMENT"
$prodLocal = Join-Path $basePath "03-PRODUCTION"

Write-Host "VERIFICACAO DE INTEGRIDADE DOS ARQUIVOS" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

$erros = @()
$avisos = @()
$sucessos = 0

# Funcao para verificar arquivo
function Testar-Arquivo {
    param(
        [string]$Caminho,
        [string]$Tipo,
        [string]$NomeExibicao
    )
    
    if (-not (Test-Path $Caminho)) {
        $script:erros += "[ERRO] ARQUIVO NAO ENCONTRADO: $NomeExibicao ($Caminho)"
        return $false
    }
    
    $arquivo = Get-Item $Caminho
    
    # Verificar se arquivo esta vazio
    if ($arquivo.Length -eq 0) {
        $script:erros += "[ERRO] ARQUIVO VAZIO: $NomeExibicao ($Caminho)"
        return $false
    }
    
    # Verificar tamanho minimo
    if ($arquivo.Length -lt 10) {
        $script:avisos += "[AVISO] ARQUIVO MUITO PEQUENO: $NomeExibicao ($Caminho) - $($arquivo.Length) bytes"
    }
    
    # Verificar sintaxe PHP basica
    if ($Tipo -eq "PHP") {
        try {
            $conteudo = Get-Content $Caminho -Raw -ErrorAction Stop -Encoding UTF8
            if ($conteudo -notmatch '^\s*<\?php') {
                $script:avisos += "[AVISO] ARQUIVO PHP SEM TAG DE ABERTURA: $NomeExibicao"
            }
        } catch {
            $script:erros += "[ERRO] ERRO AO LER ARQUIVO: $NomeExibicao - $($_.Exception.Message)"
            return $false
        }
    }
    
    # Verificar sintaxe JavaScript basica
    if ($Tipo -eq "JS") {
        try {
            $conteudo = Get-Content $Caminho -Raw -ErrorAction Stop -Encoding UTF8
            if ($conteudo.Length -gt 100 -and $conteudo -notmatch '(function|const|let|var|class)\s+') {
                $script:avisos += "[AVISO] ARQUIVO JS PODE ESTAR INCOMPLETO: $NomeExibicao"
            }
        } catch {
            $script:erros += "[ERRO] ERRO AO LER ARQUIVO: $NomeExibicao - $($_.Exception.Message)"
            return $false
        }
    }
    
    # Verificar JSON
    if ($Tipo -eq "JSON") {
        try {
            $conteudo = Get-Content $Caminho -Raw -ErrorAction Stop -Encoding UTF8
            $null = $conteudo | ConvertFrom-Json -ErrorAction Stop
        } catch {
            $script:erros += "[ERRO] JSON INVALIDO: $NomeExibicao - $($_.Exception.Message)"
            return $false
        }
    }
    
    $script:sucessos++
    Write-Host "  [OK] $NomeExibicao" -ForegroundColor Green
    return $true
}

# Verificar diretorios
Write-Host "Verificando diretorios..." -ForegroundColor Cyan
if (-not (Test-Path $devLocal)) {
    $erros += "[ERRO] DIRETORIO DEV NAO ENCONTRADO: $devLocal"
    Write-Host "  [ERRO] Diretorio DEV nao encontrado!" -ForegroundColor Red
} else {
    Write-Host "  [OK] Diretorio DEV encontrado" -ForegroundColor Green
}

if (-not (Test-Path $prodLocal)) {
    $erros += "[ERRO] DIRETORIO PROD NAO ENCONTRADO: $prodLocal"
    Write-Host "  [ERRO] Diretorio PROD nao encontrado!" -ForegroundColor Red
} else {
    Write-Host "  [OK] Diretorio PROD encontrado" -ForegroundColor Green
}

Write-Host ""

# ARQUIVOS DEV
Write-Host "Verificando arquivos DEV..." -ForegroundColor Cyan

$arquivosDev = @(
    @{Nome="config.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "config.php"},
    @{Nome="add_flyingdonkeys.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "add_flyingdonkeys.php"},
    @{Nome="add_webflow_octa.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "add_webflow_octa.php"},
    @{Nome="send_email_notification_endpoint.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "send_email_notification_endpoint.php"},
    @{Nome="send_admin_notification_ses.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "send_admin_notification_ses.php"},
    @{Nome="class.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "class.php"},
    @{Nome="cpf-validate.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "cpf-validate.php"},
    @{Nome="placa-validate.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "placa-validate.php"},
    @{Nome="composer.json"; Tipo="JSON"; Caminho=Join-Path $devLocal "composer.json"},
    @{Nome="MODAL_WHATSAPP_DEFINITIVO.js"; Tipo="JS"; Caminho=Join-Path $devLocal "MODAL_WHATSAPP_DEFINITIVO.js"},
    @{Nome="FooterCodeSiteDefinitivoCompleto.js"; Tipo="JS"; Caminho=Join-Path $devLocal "FooterCodeSiteDefinitivoCompleto.js"},
    @{Nome="webflow_injection_limpo.js"; Tipo="JS"; Caminho=Join-Path $devLocal "webflow_injection_limpo.js"}
)

foreach ($arquivo in $arquivosDev) {
    Testar-Arquivo -Caminho $arquivo.Caminho -Tipo $arquivo.Tipo -NomeExibicao $arquivo.Nome
}

Write-Host ""

# ARQUIVOS PROD
Write-Host "Verificando arquivos PROD..." -ForegroundColor Cyan

$arquivosProd = @(
    @{Nome="config.php"; Tipo="PHP"; Caminho=Join-Path $prodLocal "config.php"},
    @{Nome="add_flyingdonkeys_prod.php"; Tipo="PHP"; Caminho=Join-Path $prodLocal "add_flyingdonkeys_prod.php"},
    @{Nome="add_webflow_octa_prod.php"; Tipo="PHP"; Caminho=Join-Path $prodLocal "add_webflow_octa_prod.php"},
    @{Nome="send_email_notification_endpoint_prod.php"; Tipo="PHP"; Caminho=Join-Path $prodLocal "send_email_notification_endpoint_prod.php"},
    @{Nome="send_admin_notification_ses_prod.php"; Tipo="PHP"; Caminho=Join-Path $prodLocal "send_admin_notification_ses_prod.php"},
    @{Nome="composer.json"; Tipo="JSON"; Caminho=Join-Path $prodLocal "composer.json"},
    @{Nome="MODAL_WHATSAPP_DEFINITIVO_prod.js"; Tipo="JS"; Caminho=Join-Path $prodLocal "MODAL_WHATSAPP_DEFINITIVO_prod.js"},
    @{Nome="FooterCodeSiteDefinitivoCompleto_prod.js"; Tipo="JS"; Caminho=Join-Path $prodLocal "FooterCodeSiteDefinitivoCompleto_prod.js"}
)

foreach ($arquivo in $arquivosProd) {
    Testar-Arquivo -Caminho $arquivo.Caminho -Tipo $arquivo.Tipo -NomeExibicao $arquivo.Nome
}

# Verificar arquivos compartilhados
Write-Host ""
Write-Host "Verificando arquivos compartilhados (DEV -> PROD)..." -ForegroundColor Cyan

$arquivosCompartilhados = @(
    @{Nome="class.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "class.php"},
    @{Nome="cpf-validate.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "cpf-validate.php"},
    @{Nome="placa-validate.php"; Tipo="PHP"; Caminho=Join-Path $devLocal "placa-validate.php"}
)

foreach ($arquivo in $arquivosCompartilhados) {
    Testar-Arquivo -Caminho $arquivo.Caminho -Tipo $arquivo.Tipo -NomeExibicao "$($arquivo.Nome) (compartilhado)"
}

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "RESUMO DA VERIFICACAO" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host ""

Write-Host "Arquivos integros: $sucessos" -ForegroundColor Green
Write-Host "Avisos: $($avisos.Count)" -ForegroundColor Yellow
Write-Host "Erros: $($erros.Count)" -ForegroundColor Red
Write-Host ""

# Exibir avisos
if ($avisos.Count -gt 0) {
    Write-Host "AVISOS:" -ForegroundColor Yellow
    foreach ($aviso in $avisos) {
        Write-Host "  $aviso" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Exibir erros
if ($erros.Count -gt 0) {
    Write-Host "ERROS ENCONTRADOS:" -ForegroundColor Red
    foreach ($erro in $erros) {
        Write-Host "  $erro" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "NAO E SEGURO COPIAR ARQUIVOS COM ERROS!" -ForegroundColor Red
    exit 1
}

# Verificacoes adicionais de conteudo critico
Write-Host "Verificacoes adicionais de conteudo..." -ForegroundColor Cyan

# Verificar se config.php tem funcoes essenciais
$configPath = Join-Path $devLocal "config.php"
if (Test-Path $configPath) {
    $configContent = Get-Content $configPath -Raw -Encoding UTF8
    $checks = @{
        "getCorsOrigins" = $configContent -match 'function\s+getCorsOrigins'
        "isDevelopment" = $configContent -match 'function\s+isDevelopment'
        "getBaseUrl" = $configContent -match 'function\s+getBaseUrl'
    }
    
    foreach ($check in $checks.GetEnumerator()) {
        if (-not $check.Value) {
            $avisos += "[AVISO] config.php pode estar incompleto: funcao '$($check.Key)' nao encontrada"
            Write-Host "  [AVISO] Funcao '$($check.Key)' nao encontrada em config.php" -ForegroundColor Yellow
        } else {
            Write-Host "  [OK] Funcao '$($check.Key)' encontrada em config.php" -ForegroundColor Green
        }
    }
}

# Verificar se add_flyingdonkeys.php tem logica de CORS
$flyingdonkeysPath = Join-Path $devLocal "add_flyingdonkeys.php"
if (Test-Path $flyingdonkeysPath) {
    $fdContent = Get-Content $flyingdonkeysPath -Raw -Encoding UTF8
    if ($fdContent -notmatch 'Access-Control-Allow-Origin') {
        $avisos += "[AVISO] add_flyingdonkeys.php pode nao ter headers CORS configurados"
        Write-Host "  [AVISO] Headers CORS nao encontrados em add_flyingdonkeys.php" -ForegroundColor Yellow
    } else {
        Write-Host "  [OK] Headers CORS encontrados em add_flyingdonkeys.php" -ForegroundColor Green
    }
}

# Verificar se send_admin_notification_ses.php tem verificacao de AWS SDK
$sesPath = Join-Path $devLocal "send_admin_notification_ses.php"
if (Test-Path $sesPath) {
    $sesContent = Get-Content $sesPath -Raw -Encoding UTF8
    if ($sesContent -notmatch 'Aws\\Ses\\SesClient') {
        $avisos += "[AVISO] send_admin_notification_ses.php pode nao ter verificacao de AWS SDK"
        Write-Host "  [AVISO] Verificacao de AWS SDK nao encontrada" -ForegroundColor Yellow
    } else {
        Write-Host "  [OK] Verificacao de AWS SDK encontrada" -ForegroundColor Green
    }
}

# Verificar se MODAL_WHATSAPP_DEFINITIVO.js chama add_flyingdonkeys (nao travelangels)
$modalPath = Join-Path $devLocal "MODAL_WHATSAPP_DEFINITIVO.js"
if (Test-Path $modalPath) {
    $modalContent = Get-Content $modalPath -Raw -Encoding UTF8
    if ($modalContent -match 'add_travelangels') {
        $erros += "[ERRO] MODAL_WHATSAPP_DEFINITIVO.js ainda contem referencia a 'travelangels'"
        Write-Host "  [ERRO] Referencia a 'travelangels' encontrada no modal!" -ForegroundColor Red
    } else {
        Write-Host "  [OK] Nenhuma referencia a 'travelangels' encontrada" -ForegroundColor Green
    }
    
    if ($modalContent -match 'add_flyingdonkeys') {
        Write-Host "  [OK] Referencia a 'flyingdonkeys' encontrada" -ForegroundColor Green
    } else {
        $avisos += "[AVISO] MODAL_WHATSAPP_DEFINITIVO.js pode nao estar chamando add_flyingdonkeys"
        Write-Host "  [AVISO] Referencia a 'flyingdonkeys' nao encontrada" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host ("=" * 60) -ForegroundColor Cyan

# Resultado final
if ($erros.Count -eq 0) {
    Write-Host ""
    Write-Host "TODOS OS ARQUIVOS ESTAO INTEGROS!" -ForegroundColor Green
    Write-Host "SEGURO PARA COPIAR PARA O SERVIDOR" -ForegroundColor Green
    Write-Host ""
    exit 0
} else {
    Write-Host ""
    Write-Host "ERROS ENCONTRADOS - CORRIGIR ANTES DE COPIAR" -ForegroundColor Red
    Write-Host ""
    exit 1
}
