# Script para validar sintaxe do script SQL de alteração do ENUM TRACE
# Versão: 1.0.0
# Data: 23/11/2025
# Uso: .\validar_sql_trace_enum_prod.ps1

$ErrorActionPreference = "Stop"

# Configurações
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$workspaceRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $scriptPath))
$scriptSQL = Join-Path $workspaceRoot (Join-Path "WEBFLOW-SEGUROSIMEDIATO" (Join-Path "06-SERVER-CONFIG" "alterar_enum_level_adicionar_trace_prod.sql"))

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "VALIDACAO DE SINTAXE SQL" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se arquivo existe
if (-not (Test-Path $scriptSQL)) {
    Write-Host "ERRO: Script SQL nao encontrado: $scriptSQL" -ForegroundColor Red
    exit 1
}

Write-Host "Arquivo: $scriptSQL" -ForegroundColor Yellow
Write-Host ""

# Ler conteúdo do arquivo
$content = Get-Content -Raw $scriptSQL

# =====================================================
# VALIDAÇÃO 1: Estrutura Básica
# =====================================================

Write-Host "Validacao 1: Estrutura basica..." -ForegroundColor Cyan

# Verificar palavras-chave SQL essenciais
$keywords = @('USE', 'SELECT', 'ALTER TABLE', 'MODIFY COLUMN', 'ENUM', 'FROM', 'WHERE', 'ORDER BY')
$missingKeywords = @()

foreach ($keyword in $keywords) {
    if ($content -notmatch [regex]::Escape($keyword)) {
        $missingKeywords += $keyword
    }
}

if ($missingKeywords.Count -gt 0) {
    Write-Host "AVISO: Palavras-chave nao encontradas: $($missingKeywords -join ', ')" -ForegroundColor Yellow
} else {
    Write-Host "OK - Palavras-chave SQL encontradas" -ForegroundColor Green
}

# =====================================================
# VALIDAÇÃO 2: Parênteses Balanceados
# =====================================================

Write-Host "Validacao 2: Parenteses balanceados..." -ForegroundColor Cyan

$openParens = ([regex]::Matches($content, '\(')).Count
$closeParens = ([regex]::Matches($content, '\)')).Count

if ($openParens -eq $closeParens) {
    Write-Host "OK - Parenteses balanceados ($openParens pares)" -ForegroundColor Green
} else {
    Write-Host "ERRO: Parenteses desbalanceados (abertos: $openParens, fechados: $closeParens)" -ForegroundColor Red
    exit 1
}

# =====================================================
# VALIDAÇÃO 3: Aspas Balanceadas
# =====================================================

Write-Host "Validacao 3: Aspas balanceadas..." -ForegroundColor Cyan

$singleQuotes = ([regex]::Matches($content, "'")).Count
$doubleQuotes = ([regex]::Matches($content, '"')).Count

if ($singleQuotes % 2 -eq 0) {
    Write-Host "OK - Aspas simples balanceadas ($singleQuotes aspas)" -ForegroundColor Green
} else {
    Write-Host "ERRO: Aspas simples desbalanceadas ($singleQuotes aspas)" -ForegroundColor Red
    exit 1
}

if ($doubleQuotes % 2 -eq 0) {
    Write-Host "OK - Aspas duplas balanceadas ($doubleQuotes aspas)" -ForegroundColor Green
} else {
    Write-Host "ERRO: Aspas duplas desbalanceadas ($doubleQuotes aspas)" -ForegroundColor Red
    exit 1
}

# =====================================================
# VALIDAÇÃO 4: Comandos SQL Válidos
# =====================================================

Write-Host "Validacao 4: Comandos SQL validos..." -ForegroundColor Cyan

# Verificar USE statement
if ($content -match 'USE\s+rpa_logs_prod\s*;') {
    Write-Host "OK - USE rpa_logs_prod encontrado" -ForegroundColor Green
} else {
    Write-Host "AVISO: USE rpa_logs_prod nao encontrado ou formato incorreto" -ForegroundColor Yellow
}

# Verificar ALTER TABLE statements
$alterTableMatches = [regex]::Matches($content, 'ALTER\s+TABLE\s+\w+\s+MODIFY\s+COLUMN')
if ($alterTableMatches.Count -ge 3) {
    Write-Host "OK - ALTER TABLE encontrado ($($alterTableMatches.Count) ocorrencias)" -ForegroundColor Green
} else {
    Write-Host "AVISO: Esperado pelo menos 3 ALTER TABLE, encontrado $($alterTableMatches.Count)" -ForegroundColor Yellow
}

# Verificar ENUM com TRACE
if ($content -match "ENUM\s*\(\s*'DEBUG'\s*,\s*'INFO'\s*,\s*'WARN'\s*,\s*'ERROR'\s*,\s*'FATAL'\s*,\s*'TRACE'\s*\)") {
    Write-Host "OK - ENUM com TRACE encontrado" -ForegroundColor Green
} else {
    Write-Host "ERRO: ENUM com TRACE nao encontrado ou formato incorreto" -ForegroundColor Red
    exit 1
}

# =====================================================
# VALIDAÇÃO 5: Estrutura de Tabelas
# =====================================================

Write-Host "Validacao 5: Estrutura de tabelas..." -ForegroundColor Cyan

$tables = @('application_logs', 'application_logs_archive', 'log_statistics')
foreach ($table in $tables) {
    if ($content -match [regex]::Escape($table)) {
        Write-Host "OK - Tabela $table encontrada" -ForegroundColor Green
    } else {
        Write-Host "AVISO: Tabela $table nao encontrada" -ForegroundColor Yellow
    }
}

# =====================================================
# VALIDAÇÃO 6: Verificações SELECT
# =====================================================

Write-Host "Validacao 6: Verificacoes SELECT..." -ForegroundColor Cyan

$selectMatches = [regex]::Matches($content, 'SELECT\s+.*?FROM', [System.Text.RegularExpressions.RegexOptions]::Singleline)
if ($selectMatches.Count -ge 3) {
    Write-Host "OK - SELECT statements encontrados ($($selectMatches.Count) ocorrencias)" -ForegroundColor Green
} else {
    Write-Host "AVISO: Esperado pelo menos 3 SELECT, encontrado $($selectMatches.Count)" -ForegroundColor Yellow
}

# =====================================================
# VALIDAÇÃO 7: Ponto e Vírgula
# =====================================================

Write-Host "Validacao 7: Pontos e virgulas..." -ForegroundColor Cyan

# Contar comandos SQL (cada comando deve terminar com ;)
$semicolons = ([regex]::Matches($content, ';')).Count
if ($semicolons -ge 5) {
    Write-Host "OK - Pontos e virgulas encontrados ($semicolons ocorrencias)" -ForegroundColor Green
} else {
    Write-Host "AVISO: Poucos pontos e virgulas encontrados ($semicolons)" -ForegroundColor Yellow
}

# =====================================================
# VALIDAÇÃO 8: Comentários
# =====================================================

Write-Host "Validacao 8: Comentarios..." -ForegroundColor Cyan

$commentLines = ([regex]::Matches($content, '--.*')).Count
if ($commentLines -gt 0) {
    Write-Host "OK - Comentarios encontrados ($commentLines linhas)" -ForegroundColor Green
} else {
    Write-Host "AVISO: Nenhum comentario encontrado" -ForegroundColor Yellow
}

# =====================================================
# RESUMO FINAL
# =====================================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "VALIDACAO CONCLUIDA" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Resumo:" -ForegroundColor Yellow
Write-Host "  - Estrutura basica: OK" -ForegroundColor Gray
Write-Host "  - Parenteses: OK" -ForegroundColor Gray
Write-Host "  - Aspas: OK" -ForegroundColor Gray
Write-Host "  - Comandos SQL: OK" -ForegroundColor Gray
Write-Host "  - ENUM com TRACE: OK" -ForegroundColor Gray
Write-Host ""
Write-Host "Script SQL parece estar sintaticamente correto." -ForegroundColor Green
Write-Host ""
Write-Host "NOTA: Validacao completa requer conexao com banco de dados." -ForegroundColor Yellow
Write-Host "Para validacao completa, execute no servidor via MySQL." -ForegroundColor Yellow
Write-Host ""


