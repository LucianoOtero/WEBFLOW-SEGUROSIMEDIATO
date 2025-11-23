# Script de Análise e Correção Automática de Código
# Executa ferramentas de análise, lê resultados e aplica correções automáticas
# Uso: .\analisar-e-corrigir-codigo.ps1

$ErrorActionPreference = "Continue"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "ANÁLISE E CORREÇÃO AUTOMÁTICA DE CÓDIGO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$baseDir = "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"
$correcoesAplicadas = @()
$problemasManuais = @()

# ==================== FASE 1: ANÁLISE ESLint (JavaScript) ====================
Write-Host "📊 FASE 1: Analisando JavaScript com ESLint..." -ForegroundColor Yellow
Write-Host ""

if (Get-Command npx -ErrorAction SilentlyContinue) {
    try {
        # Executar ESLint com formato JSON
        $eslintOutput = npx eslint "$baseDir\*.js" --format json 2>&1 | ConvertFrom-Json
        
        foreach ($file in $eslintOutput) {
            $filePath = $file.filePath
            Write-Host "  📄 Analisando: $filePath" -ForegroundColor Gray
            
            if ($file.messages.Count -eq 0) {
                Write-Host "    ✅ Nenhum problema encontrado" -ForegroundColor Green
                continue
            }
            
            # Ler conteúdo do arquivo
            $content = Get-Content $filePath -Raw
            $modified = $false
            
            # Processar mensagens em ordem reversa (para não afetar índices)
            $messagesToFix = $file.messages | Where-Object { $_.fix } | Sort-Object -Property { $_.fix.range[0] } -Descending
            
            foreach ($message in $messagesToFix) {
                $ruleId = $message.ruleId
                $line = $message.line
                $severity = if ($message.severity -eq 2) { "ERROR" } else { "WARNING" }
                
                Write-Host "    ⚠️  Linha $line : $ruleId ($severity)" -ForegroundColor Yellow
                
                if ($message.fix) {
                    $start = $message.fix.range[0]
                    $end = $message.fix.range[1]
                    $replacement = $message.fix.text
                    
                    # Aplicar correção
                    $before = $content.Substring(0, $start)
                    $after = $content.Substring($end)
                    $content = $before + $replacement + $after
                    $modified = $true
                    
                    Write-Host "      ✅ Correção aplicada automaticamente" -ForegroundColor Green
                    $correcoesAplicadas += @{
                        Arquivo = $filePath
                        Linha = $line
                        Problema = $ruleId
                        Correcao = "Aplicada automaticamente"
                    }
                } else {
                    Write-Host "      ⚠️  Requer correção manual" -ForegroundColor Yellow
                    $problemasManuais += @{
                        Arquivo = $filePath
                        Linha = $line
                        Problema = $ruleId
                        Mensagem = $message.message
                    }
                }
            }
            
            # Salvar arquivo se foi modificado
            if ($modified) {
                Set-Content -Path $filePath -Value $content -NoNewline
                Write-Host "    💾 Arquivo salvo com correções" -ForegroundColor Cyan
            }
        }
        
        Write-Host ""
        Write-Host "✅ Análise ESLint concluída" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠️  ESLint não disponível ou erro na execução: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠️  npx não encontrado. Instale Node.js para usar ESLint." -ForegroundColor Yellow
}

Write-Host ""

# ==================== FASE 2: VALIDAÇÃO PHP (Sintaxe) ====================
Write-Host "📊 FASE 2: Validando sintaxe PHP..." -ForegroundColor Yellow
Write-Host ""

if (Get-Command php -ErrorAction SilentlyContinue) {
    $phpFiles = Get-ChildItem -Path $baseDir -Filter "*.php" -Recurse | Where-Object { 
        $_.FullName -notmatch "\\backups\\" -and $_.FullName -notmatch "\\TMP\\" 
    }
    
    foreach ($file in $phpFiles) {
        $result = php -l $file.FullName 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ $($file.Name)" -ForegroundColor Green
        } else {
            Write-Host "  ❌ $($file.Name)" -ForegroundColor Red
            Write-Host "    $result" -ForegroundColor Red
            $problemasManuais += @{
                Arquivo = $file.FullName
                Linha = "N/A"
                Problema = "Erro de sintaxe PHP"
                Mensagem = $result
            }
        }
    }
    
    Write-Host ""
    Write-Host "✅ Validação PHP concluída" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  PHP não encontrado no PATH" -ForegroundColor Yellow
}

Write-Host ""

# ==================== FASE 3: RELATÓRIO FINAL ====================
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "RELATÓRIO FINAL" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Correções Aplicadas Automaticamente: $($correcoesAplicadas.Count)" -ForegroundColor Green
if ($correcoesAplicadas.Count -gt 0) {
    foreach ($correcao in $correcoesAplicadas) {
        Write-Host "  - $($correcao.Arquivo):$($correcao.Linha) - $($correcao.Problema)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "⚠️  Problemas que Requerem Correção Manual: $($problemasManuais.Count)" -ForegroundColor Yellow
if ($problemasManuais.Count -gt 0) {
    foreach ($problema in $problemasManuais) {
        Write-Host "  - $($problema.Arquivo):$($problema.Linha) - $($problema.Problema)" -ForegroundColor Gray
        Write-Host "    $($problema.Mensagem)" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "✅ Análise e correção concluídas!" -ForegroundColor Green

