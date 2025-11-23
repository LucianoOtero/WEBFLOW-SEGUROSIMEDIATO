# Script de Deploy: Parametrização de Logging
# Ambiente: DEV (Desenvolvimento)
# Data: 17/11/2025

param(
    [switch]$SkipBackup = $false,
    [switch]$SkipTests = $false,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

# Configurações
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$serverDev = "root@65.108.156.14"
$remotePath = "/var/www/html/dev/root"

# Cores para output
function Write-Step { param($msg) Write-Host "`n▶ $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "✅ $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "⚠️ $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "❌ $msg" -ForegroundColor Red }

# Verificar se está no diretório correto
if (-not (Test-Path $workspacePath)) {
    Write-Error "Workspace não encontrado: $workspacePath"
    exit 1
}

Set-Location $workspacePath

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "🚀 DEPLOY: Parametrização de Logging - DEV" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

if ($DryRun) {
    Write-Warning "MODO DRY-RUN: Nenhuma alteração será feita"
    Write-Host ""
}

# FASE 1: Verificar Acesso ao Servidor
Write-Step "FASE 1: Verificando acesso ao servidor..."
try {
    $testResult = ssh $serverDev "echo 'OK'" 2>&1
    if ($testResult -match "OK") {
        Write-Success "Conexão SSH estabelecida"
    } else {
        Write-Error "Falha ao conectar ao servidor"
        exit 1
    }
} catch {
    Write-Error "Erro ao conectar: $_"
    exit 1
}

# FASE 2: Backup no Servidor
if (-not $SkipBackup) {
    Write-Step "FASE 2: Criando backups no servidor..."
    if (-not $DryRun) {
        $backupScript = @"
TIMESTAMP=`$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$remotePath/backups_`${TIMESTAMP}"
mkdir -p "`$BACKUP_DIR"

FILES=(
    "$remotePath/FooterCodeSiteDefinitivoCompleto.js"
    "$remotePath/ProfessionalLogger.php"
    "$remotePath/log_endpoint.php"
    "$remotePath/send_email_notification_endpoint.php"
)

for file in "`${FILES[@]}"; do
    if [ -f "`$file" ]; then
        cp "`$file" "`${BACKUP_DIR}/`$(basename `$file).backup_`${TIMESTAMP}"
        echo "✅ Backup: `$(basename `$file)"
    fi
done

echo "📁 Backups em: `$BACKUP_DIR"
"@
        ssh $serverDev $backupScript
        Write-Success "Backups criados no servidor"
    } else {
        Write-Warning "DRY-RUN: Backup seria criado"
    }
}

# FASE 3: Copiar Arquivos
Write-Step "FASE 3: Copiando arquivos para servidor..."

$files = @(
    @{Local="WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js"; Remote="$remotePath/FooterCodeSiteDefinitivoCompleto.js"},
    @{Local="WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php"; Remote="$remotePath/ProfessionalLogger.php"},
    @{Local="WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\log_endpoint.php"; Remote="$remotePath/log_endpoint.php"},
    @{Local="WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_email_notification_endpoint.php"; Remote="$remotePath/send_email_notification_endpoint.php"}
)

foreach ($file in $files) {
    $localPath = Join-Path $workspacePath $file.Local
    $remotePath = $file.Remote
    
    if (-not (Test-Path $localPath)) {
        Write-Error "Arquivo local não encontrado: $localPath"
        continue
    }
    
    Write-Host "  📤 Copiando $(Split-Path $file.Local -Leaf)..." -ForegroundColor Gray
    
    if (-not $DryRun) {
        scp $localPath "${serverDev}:${remotePath}" 2>&1 | Out-Null
        
        # Verificar hash
        $hashLocal = (Get-FileHash -Path $localPath -Algorithm SHA256).Hash.ToUpper()
        $hashRemote = (ssh $serverDev "sha256sum $remotePath 2>/dev/null | cut -d' ' -f1").ToUpper()
        
        if ($hashLocal -eq $hashRemote) {
            Write-Success "  $(Split-Path $file.Local -Leaf): Hash OK"
        } else {
            Write-Error "  $(Split-Path $file.Local -Leaf): Hash não coincide!"
            Write-Host "     Local:    $hashLocal" -ForegroundColor Yellow
            Write-Host "     Servidor: $hashRemote" -ForegroundColor Yellow
        }
    } else {
        Write-Warning "  DRY-RUN: Seria copiado: $(Split-Path $file.Local -Leaf)"
    }
}

# FASE 4: Atualizar Variáveis PHP-FPM
Write-Step "FASE 4: Atualizando variáveis de ambiente PHP-FPM..."

if (-not $DryRun) {
    $phpFpmScript = @"
PHP_FPM_CONF=`$(find /etc -name 'www.conf' -path '*/fpm/pool.d/*' 2>/dev/null | head -1)

if [ -z "`$PHP_FPM_CONF" ]; then
    echo "❌ Arquivo PHP-FPM não encontrado"
    exit 1
fi

# Fazer backup
cp "`$PHP_FPM_CONF" "`${PHP_FPM_CONF}.backup_`$(date +%Y%m%d_%H%M%S)"
echo "✅ Backup PHP-FPM criado"

# Verificar se variáveis já existem
if grep -q "LOG_ENABLED" "`$PHP_FPM_CONF"; then
    echo "⚠️ Variáveis de logging já existem - pulando adição"
else
    # Adicionar variáveis ao final
    cat >> "`$PHP_FPM_CONF" << 'VAREOF'

; ==================== VARIÁVEIS DE LOGGING DEV (FASE 9) ====================
; Configuração de logging para ambiente de desenvolvimento
env[LOG_ENABLED] = true
env[LOG_LEVEL] = all
env[LOG_DATABASE_ENABLED] = true
env[LOG_DATABASE_MIN_LEVEL] = all
env[LOG_CONSOLE_ENABLED] = true
env[LOG_CONSOLE_MIN_LEVEL] = all
env[LOG_FILE_ENABLED] = true
env[LOG_FILE_MIN_LEVEL] = error
VAREOF
    echo "✅ Variáveis de logging adicionadas"
fi

# Verificar sintaxe
if php-fpm8.3 -t 2>&1 | grep -q "syntax is ok"; then
    echo "✅ Sintaxe PHP-FPM OK"
    systemctl restart php8.3-fpm
    echo "✅ PHP-FPM reiniciado"
else
    echo "❌ Erro de sintaxe no PHP-FPM"
    exit 1
fi
"@
    
    ssh $serverDev $phpFpmScript
    Write-Success "Variáveis PHP-FPM atualizadas"
} else {
    Write-Warning "DRY-RUN: Variáveis PHP-FPM seriam atualizadas"
}

# FASE 5: Testes (se não pular)
if (-not $SkipTests) {
    Write-Step "FASE 5: Executando testes básicos..."
    
    if (-not $DryRun) {
        # Criar script de teste de conexão
        $testScript = @"
cat > $remotePath/test_db_connection.php << 'PHPEOF'
<?php
require_once __DIR__ . '/ProfessionalLogger.php';
header('Content-Type: application/json');
try {
    `$logger = new ProfessionalLogger();
    `$connection = `$logger->getConnection();
    if (`$connection === null) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Connection failed']);
        exit;
    }
    `$stmt = `$connection->query('SELECT 1 as test, DATABASE() as db');
    `$result = `$stmt->fetch(PDO::FETCH_ASSOC);
    echo json_encode(['success' => true, 'database' => `$result['db']], JSON_PRETTY_PRINT);
} catch (Exception `$e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => `$e->getMessage()], JSON_PRETTY_PRINT);
}
PHPEOF
echo "✅ Script de teste criado"
"@
        
        ssh $serverDev $testScript
        
        Write-Host "  🧪 Testando conexão com banco..." -ForegroundColor Gray
        $testResult = curl -s "https://dev.bssegurosimediato.com.br/test_db_connection.php" | ConvertFrom-Json
        if ($testResult.success) {
            Write-Success "  Conexão com banco: OK (Database: $($testResult.database))"
        } else {
            Write-Error "  Conexão com banco: FALHOU - $($testResult.error)"
        }
    } else {
        Write-Warning "DRY-RUN: Testes seriam executados"
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
if ($DryRun) {
    Write-Warning "DEPLOY CONCLUÍDO (DRY-RUN - Nenhuma alteração foi feita)"
} else {
    Write-Success "DEPLOY CONCLUÍDO"
    Write-Host ""
    Write-Warning "⚠️ IMPORTANTE: Limpar cache do Cloudflare para que as alterações sejam refletidas imediatamente"
}
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

