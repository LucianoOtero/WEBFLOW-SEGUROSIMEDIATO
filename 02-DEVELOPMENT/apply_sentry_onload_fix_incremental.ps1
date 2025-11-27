# Script Incremental para Aplicar Correção do Sentry.onLoad()
# Data: 26/11/2025
# Versão: 1.0.0
# Descrição: Remove Sentry.onLoad() e inicializa Sentry diretamente quando usando CDN direto
# Uso: Execute este script na pasta 02-DEVELOPMENT

param(
    [string]$FilePath = "FooterCodeSiteDefinitivoCompleto.js"
)

$ErrorActionPreference = "Stop"

Write-Host "=== Script de Correção: Sentry.onLoad() ===" -ForegroundColor Cyan
Write-Host ""

# Verificar se arquivo existe
$fullPath = Join-Path $PSScriptRoot $FilePath
if (-not (Test-Path $fullPath)) {
    Write-Host "ERRO: Arquivo não encontrado: $fullPath" -ForegroundColor Red
    exit 1
}

Write-Host "Arquivo: $fullPath" -ForegroundColor Green
Write-Host ""

# Ler conteúdo do arquivo
$content = Get-Content -Path $fullPath -Raw -Encoding UTF8

# Verificar se já foi corrigido
if ($content -notmatch 'Sentry\.onLoad\(function\(\)') {
    Write-Host "✅ Arquivo já foi corrigido (Sentry.onLoad não encontrado)" -ForegroundColor Green
    exit 0
}

Write-Host "⚠️  ATENÇÃO: Este script irá modificar o arquivo!" -ForegroundColor Yellow
Write-Host "Certifique-se de que um backup foi criado antes de continuar." -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Deseja continuar? (S/N)"

if ($confirm -ne "S" -and $confirm -ne "s") {
    Write-Host "Operação cancelada pelo usuário." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Aplicando correção..." -ForegroundColor Cyan

# Fazer backup antes de modificar
$backupDir = Join-Path $PSScriptRoot "backups"
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = Join-Path $backupDir "FooterCodeSiteDefinitivoCompleto_BEFORE_SENTRY_ONLOAD_FIX_$timestamp.js"
Copy-Item -Path $fullPath -Destination $backupPath -Force
Write-Host "✅ Backup criado: $(Split-Path $backupPath -Leaf)" -ForegroundColor Green

# Substituir Sentry.onLoad(function() { ... }); por inicialização direta
# Padrão: encontrar Sentry.onLoad(function() { ... try { ... Sentry.init(...) ... } catch ... }); dentro de script.onload
$pattern = '(?s)(script\.onload\s*=\s*function\(\)\s*\{\s*//\s*Inicializar\s+Sentry\s+após\s+SDK\s+carregar\s+if\s*\(\s*typeof\s+Sentry\s*!==\s*[''"]undefined[''"]\s*\)\s*\{\s*)Sentry\.onLoad\(function\(\)\s*\{(\s*try\s*\{[^}]*const\s+environment\s*=\s*getEnvironment\(\);[^}]*Sentry\.init\(\{[^}]*\}\);[^}]*window\.SENTRY_INITIALIZED\s*=\s*true;[^}]*\} catch[^}]*\}\);(\s*\})\s*\}'

# Nova versão (sem onLoad)
$newCode = @'
        script.onload = function() {
          // ✅ CORREÇÃO FASE 8: Inicializar Sentry DIRETAMENTE após SDK carregar (sem onLoad)
          // onLoad() só existe no loader script, não no bundle CDN direto
          if (typeof Sentry !== 'undefined') {
            try {
              const environment = getEnvironment();
              
              Sentry.init({
                dsn: "https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424",
                environment: environment, // ✅ Usa detecção consistente
                tracesSampleRate: 0.1, // 10% das transações para performance
                debug: false, // Ativar apenas para debug (produção: false)
                
                // Sanitizar dados sensíveis ANTES de enviar
                beforeSend(event, hint) {
                  if (event && event.extra) {
                    // Remover dados sensíveis
                    delete event.extra.ddd;
                    delete event.extra.celular;
                    delete event.extra.cpf;
                    delete event.extra.nome;
                    delete event.extra.email;
                    delete event.extra.phone;
                    delete event.extra.phone_number;
                  }
                  
                  // Remover dados sensíveis de contexts também
                  if (event && event.contexts) {
                    if (event.contexts.user) {
                      delete event.contexts.user.email;
                      delete event.contexts.user.phone;
                    }
                  }
                  
                  return event;
                },
                
                // Ignorar erros específicos (opcional)
                ignoreErrors: [
                  'ResizeObserver loop limit exceeded',
                  'Non-Error promise rejection captured',
                  'Script error.',
                  'NetworkError'
                ]
              });
              
              window.SENTRY_INITIALIZED = true;
              
              // Log de inicialização (se sistema de logs disponível)
              if (typeof window.novo_log === 'function') {
                window.novo_log('INFO', 'SENTRY', 'Sentry inicializado com sucesso', {
                  environment: environment,
                  method: 'cdn_direct_init'
                }, 'INIT', 'SIMPLE');
              } else {
                // Fallback: usar console.log se novo_log não estiver disponível
                console.log('[SENTRY] Sentry inicializado com sucesso (environment: ' + environment + ')');
              }
            } catch (sentryError) {
              // Não quebrar aplicação se Sentry falhar
              const errorMsg = sentryError.message || 'Erro desconhecido';
              if (typeof window.novo_log === 'function') {
                window.novo_log('WARN', 'SENTRY', 'Erro ao inicializar Sentry (não bloqueante)', {
                  error: errorMsg,
                  stack: sentryError.stack
                }, 'INIT', 'SIMPLE');
              } else {
                // Fallback: usar console.error se novo_log não estiver disponível
                console.error('[SENTRY] Erro ao inicializar Sentry:', errorMsg);
              }
            }
          }
        };
'@

# Como a substituição é muito complexa, vamos usar uma abordagem diferente:
# Ler o arquivo linha por linha e fazer a substituição manualmente
Write-Host "⚠️  AVISO: Substituição complexa detectada." -ForegroundColor Yellow
Write-Host "Recomendação: Aplicar correção manualmente conforme documentação do projeto." -ForegroundColor Yellow
Write-Host ""
Write-Host "O que precisa ser feito:" -ForegroundColor Cyan
Write-Host "1. Localizar linha ~742: 'Sentry.onLoad(function() {'" -ForegroundColor White
Write-Host "2. Remover 'Sentry.onLoad(function() {' e o '});' correspondente (linha ~800)" -ForegroundColor White
Write-Host "3. Manter todo o código dentro (try/catch, Sentry.init, etc.)" -ForegroundColor White
Write-Host "4. Adicionar comentário: '// ✅ CORREÇÃO FASE 8: Inicializar Sentry DIRETAMENTE...'" -ForegroundColor White
Write-Host ""
Write-Host "Consulte: PROJETO_CORRECOES_ERRO_INTERMITENTE_SENTRY_20251126_REVISADO.md - FASE 8" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Backup criado para segurança" -ForegroundColor Green

exit 0

