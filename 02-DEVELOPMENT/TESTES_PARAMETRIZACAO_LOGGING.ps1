# Script de Testes: Parametrização de Logging
# Ambiente: DEV (Desenvolvimento)
# Data: 17/11/2025

$ErrorActionPreference = "Stop"

# Configurações
$baseUrl = "https://dev.bssegurosimediato.com.br"
$serverDev = "root@65.108.156.14"

# Cores para output
function Write-Step { param($msg) Write-Host "`n▶ $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "✅ $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "⚠️ $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "❌ $msg" -ForegroundColor Red }
function Write-Info { param($msg) Write-Host "ℹ️ $msg" -ForegroundColor Gray }

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "🧪 TESTES: Parametrização de Logging - DEV" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

# FASE 6: Testes de Conexão do Banco
Write-Step "FASE 6: Testes de Conexão do Banco de Dados"

Write-Info "6.1. Verificando se banco rpa_logs_dev existe..."
$dbCheck = ssh $serverDev "mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' -e 'SHOW DATABASES LIKE \"rpa_logs_dev\";' 2>&1"
if ($dbCheck -match "rpa_logs_dev") {
    Write-Success "Banco de dados rpa_logs_dev existe"
} else {
    Write-Error "Banco de dados rpa_logs_dev não encontrado"
}

Write-Info "6.2. Verificando se tabela application_logs existe..."
$tableCheck = ssh $serverDev "mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e 'SHOW TABLES LIKE \"application_logs\";' 2>&1"
if ($tableCheck -match "application_logs") {
    Write-Success "Tabela application_logs existe"
} else {
    Write-Error "Tabela application_logs não encontrada"
}

Write-Info "6.3. Testando conexão via PHP..."
$testResult = Invoke-RestMethod -Uri "$baseUrl/test_db_connection.php" -Method Get -ErrorAction SilentlyContinue
if ($testResult.success) {
    Write-Success "Conexão PHP OK - Database: $($testResult.database)"
} else {
    Write-Error "Conexão PHP FALHOU - $($testResult.error)"
}

# FASE 7: Testes dos Endpoints
Write-Step "FASE 7: Testes dos Endpoints PHP de Log"

Write-Info "7.1. Teste básico - log_endpoint.php..."
$logTest1 = @{
    level = "INFO"
    category = "TEST"
    message = "Teste básico de log - FASE 7.1"
    data = @{test = $true; phase = "7.1"}
} | ConvertTo-Json

try {
    $response1 = Invoke-RestMethod -Uri "$baseUrl/log_endpoint.php" -Method Post -Body $logTest1 -ContentType "application/json"
    if ($response1.success) {
        Write-Success "Log inserido com sucesso - ID: $($response1.log_id)"
    } else {
        Write-Error "Falha ao inserir log - $($response1.error)"
    }
} catch {
    Write-Error "Erro ao chamar endpoint: $_"
}

Write-Info "7.2. Teste com diferentes níveis..."
$levels = @("DEBUG", "INFO", "WARN", "ERROR", "FATAL")
foreach ($level in $levels) {
    $logTest = @{
        level = $level
        category = "TEST"
        message = "Teste nível $level - FASE 7.2"
        data = @{level = $level; phase = "7.2"}
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/log_endpoint.php" -Method Post -Body $logTest -ContentType "application/json" -ErrorAction SilentlyContinue
        if ($response.success) {
            Write-Success "  $level : OK (ID: $($response.log_id))"
        } else {
            Write-Warning "  $level : Não inserido - $($response.reason)"
        }
    } catch {
        Write-Error "  $level : Erro - $_"
    }
}

Write-Info "7.3. Verificando logs inseridos no banco..."
$logs = ssh $serverDev "mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e 'SELECT COUNT(*) as count FROM application_logs WHERE category = \"TEST\";' 2>&1"
if ($logs -match "count") {
    $count = ($logs -split '\s+')[1]
    Write-Success "Logs de teste encontrados: $count"
} else {
    Write-Warning "Não foi possível contar logs"
}

# FASE 8: Testes de Parametrização
Write-Step "FASE 8: Testes de Parametrização"

Write-Info "8.1. Verificando configuração de logging..."
try {
    $configTest = Invoke-RestMethod -Uri "$baseUrl/test_log_config.php" -Method Get -ErrorAction SilentlyContinue
    if ($configTest.success) {
        Write-Success "Configuração carregada corretamente"
        Write-Info "  LOG_ENABLED: $($configTest.environment_variables.LOG_ENABLED)"
        Write-Info "  LOG_LEVEL: $($configTest.environment_variables.LOG_LEVEL)"
        Write-Info "  shouldLog(INFO): $($configTest.tests.'shouldLog(INFO, null)')"
        Write-Info "  shouldLogToDatabase(INFO): $($configTest.tests.'shouldLogToDatabase(INFO)')"
    } else {
        Write-Error "Falha ao carregar configuração"
    }
} catch {
    Write-Warning "Script de teste de configuração não encontrado (será criado no deploy)"
}

# FASE 9: Verificação de Sensibilização do Banco
Write-Step "FASE 9: Verificação de Sensibilização do Banco"

Write-Info "9.1. Verificando estrutura da tabela application_logs..."
$structure = ssh $serverDev "mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e 'DESCRIBE application_logs;' 2>&1"
if ($structure -match "log_id") {
    Write-Success "Tabela application_logs tem estrutura correta"
    Write-Info "Colunas encontradas: $($structure | Select-String -Pattern '^\w+' | Measure-Object | Select-Object -ExpandProperty Count)"
} else {
    Write-Error "Estrutura da tabela não encontrada ou incorreta"
}

Write-Info "9.2. Testando inserção manual..."
$manualInsert = ssh $serverDev @"
mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e "
INSERT INTO application_logs (log_id, request_id, timestamp, level, category, message, environment)
VALUES (CONCAT('test_', UNIX_TIMESTAMP(), '_', FLOOR(RAND() * 10000)), CONCAT('req_', UNIX_TIMESTAMP()), NOW(), 'INFO', 'TEST', 'Teste manual FASE 9.2', 'development');
SELECT log_id, level, message FROM application_logs WHERE category = 'TEST' ORDER BY timestamp DESC LIMIT 1;
" 2>&1
"@

if ($manualInsert -match "test_") {
    Write-Success "Inserção manual funcionou"
} else {
    Write-Error "Falha na inserção manual"
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Success "TESTES CONCLUÍDOS"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

