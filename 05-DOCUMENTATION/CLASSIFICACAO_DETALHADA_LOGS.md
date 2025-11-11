# 📊 CLASSIFICAÇÃO DETALHADA: Todos os Logs do Projeto

**Data:** 11/11/2025  
**Objetivo:** Classificar cada log por natureza, contexto e importância para controle via `DEBUG_CONFIG`

---

## 🎯 SISTEMA DE CLASSIFICAÇÃO

### Níveis de Severidade
- **CRITICAL:** Erros críticos que impedem funcionamento (sempre exibir)
- **ERROR:** Erros que afetam funcionalidade (exibir em produção)
- **WARN:** Avisos importantes (exibir em produção)
- **INFO:** Informações úteis (exibir apenas em dev)
- **DEBUG:** Debug detalhado (exibir apenas em debug profundo)
- **TRACE:** Rastreamento extremamente detalhado (exibir apenas em troubleshooting)

### Contextos
- **INIT:** Inicialização/configuração
- **OPERATION:** Operação normal do sistema
- **ERROR_HANDLING:** Tratamento de erros
- **PERFORMANCE:** Métricas de performance
- **DATA_FLOW:** Fluxo de dados
- **UI:** Interface do usuário

### Verbosidade
- **SIMPLE:** Mensagem simples (1 linha)
- **MEDIUM:** Mensagem com dados básicos (2-5 linhas)
- **VERBOSE:** Mensagem com objetos grandes (5+ linhas)

---

## 📁 FooterCodeSiteDefinitivoCompleto.js

### Seção: Configuração e Inicialização

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~122 | `console.error('[CONFIG] Não foi possível detectar URL base do servidor')` | **ERROR** | Erro de configuração | INIT | SIMPLE | Manter - sempre exibir |
| ~133 | `console.error('[CONFIG] Erro crítico: Não foi possível detectar URL base do servidor')` | **CRITICAL** | Erro crítico de inicialização | INIT | SIMPLE | Manter - sempre exibir |
| ~144 | `console.log('[CONFIG] config_env.js.php carregado com sucesso. APP_BASE_URL:', window.APP_BASE_URL)` | **INFO** | Confirmação de carregamento | INIT | MEDIUM | Controlar via DEBUG_CONFIG.level = 'info' |
| ~148 | `console.error('[CONFIG] Erro crítico: Não foi possível carregar config_env.js.php')` | **CRITICAL** | Erro crítico de inicialização | INIT | SIMPLE | Manter - sempre exibir |

### Seção: sendLogToProfessionalSystem()

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~361 | `console.warn('[LOG] sendLogToProfessionalSystem chamado sem level válido')` | **WARN** | Validação de parâmetros | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~366 | `console.warn('[LOG] sendLogToProfessionalSystem chamado sem message válido')` | **WARN** | Validação de parâmetros | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~384 | `console.warn('[LOG] APP_BASE_URL não disponível após aguardar. Log não enviado.')` | **WARN** | Timeout de configuração | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~400 | `console.warn('[LOG] Level inválido:', level, '- usando INFO como fallback')` | **WARN** | Validação de parâmetros | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~455 | `console.group('[LOG] 📤 Enviando log para ${endpoint}', requestId)` | **DEBUG** | Agrupamento de logs | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~456 | `console.log('📋 Payload:', {...})` | **DEBUG** | Detalhes do payload | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~467 | `console.log('📦 Payload completo:', logData)` | **TRACE** | Payload completo | DATA_FLOW | VERBOSE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'TRACE' |
| ~468 | `console.log('🔗 Endpoint:', endpoint)` | **DEBUG** | Informação de endpoint | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~469 | `console.log('⏰ Timestamp:', new Date().toISOString())` | **DEBUG** | Timestamp | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~483 | `console.log('[LOG] 📥 Resposta recebida (${Math.round(fetchDuration)}ms):', {...})` | **DEBUG** | Resposta HTTP | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~501 | `console.error('[LOG] ❌ Erro HTTP na resposta:', {...})` | **ERROR** | Erro HTTP | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~509 | `console.error('[LOG] ❌ Detalhes completos do erro:', errorData)` | **DEBUG** | Detalhes do erro | ERROR_HANDLING | VERBOSE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~513 | `console.error('[LOG] ❌ Debug info do servidor:', errorData.debug)` | **DEBUG** | Debug do servidor | ERROR_HANDLING | VERBOSE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~522 | `console.log('[LOG] ✅ Sucesso (${Math.round(fetchDuration)}ms):', {...})` | **INFO** | Confirmação de sucesso | OPERATION | MEDIUM | Controlar via DEBUG_CONFIG.level = 'info' |
| ~529 | `console.groupEnd()` | **DEBUG** | Fechamento de grupo | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~533 | `console.debug('[LOG] Enviado: ${result.log_id}')` | **DEBUG** | Confirmação simples | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~537 | `console.error('[LOG] ❌ Erro ao enviar log (${Math.round(fetchDuration)}ms):', {...})` | **ERROR** | Erro de envio | ERROR_HANDLING | VERBOSE | Controlar via DEBUG_CONFIG.level = 'error' (mas simplificar stack trace) |
| ~545 | `console.groupEnd()` | **DEBUG** | Fechamento de grupo | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~550 | `console.error('[LOG] Erro ao enviar log:', error)` | **ERROR** | Erro de envio | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~559 | `console.error('[LOG] Erro ao enviar log:', error)` | **ERROR** | Erro de envio | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |

### Seção: logUnified() - Debug Temporário

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~584 | `console.log('[DEBUG-TEMP] window.DEBUG_CONFIG existe?', !!window.DEBUG_CONFIG)` | **TRACE** | Debug temporário | INIT | SIMPLE | **REMOVER** - não deve estar em produção |
| ~585 | `console.log('[DEBUG-TEMP] window.DEBUG_CONFIG:', window.DEBUG_CONFIG)` | **TRACE** | Debug temporário | INIT | MEDIUM | **REMOVER** - não deve estar em produção |
| ~586 | `console.log('[DEBUG-TEMP] enabled value:', window.DEBUG_CONFIG?.enabled)` | **TRACE** | Debug temporário | INIT | SIMPLE | **REMOVER** - não deve estar em produção |
| ~587 | `console.log('[DEBUG-TEMP] enabled === false?', window.DEBUG_CONFIG?.enabled === false)` | **TRACE** | Debug temporário | INIT | SIMPLE | **REMOVER** - não deve estar em produção |
| ~588 | `console.log('[DEBUG-TEMP] enabled type:', typeof window.DEBUG_CONFIG?.enabled)` | **TRACE** | Debug temporário | INIT | SIMPLE | **REMOVER** - não deve estar em produção |

### Seção: logDebug() local

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1504 | `console.warn('[LOG] logDebug chamado sem level válido:', level)` | **WARN** | Validação de parâmetros | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1509 | `console.warn('[LOG] logDebug chamado sem message válido:', message)` | **WARN** | Validação de parâmetros | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1517 | `console.warn('[LOG] logDebug chamado com level inválido:', level, '- usando INFO como fallback')` | **WARN** | Validação de parâmetros | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1540 | `console.log('[${level}] ${message}', data)` | **DEBUG** | Log genérico | OPERATION | VARIÁVEL | Controlar via DEBUG_CONFIG.level baseado no `level` |

---

## 📁 MODAL_WHATSAPP_DEFINITIVO.js

### Seção: Detecção de Ambiente

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~113 | `console.log('✅ [ENV] Hardcode DEV: webflow.io detectado')` | **DEBUG** | Detecção de ambiente | INIT | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~121 | `console.log('✅ [ENV] DEV via hostname padrão')` | **DEBUG** | Detecção de ambiente | INIT | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~126 | `console.log('✅ [ENV] DEV via URL path')` | **DEBUG** | Detecção de ambiente | INIT | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~133 | `console.log('✅ [ENV] DEV via parâmetro GET')` | **DEBUG** | Detecção de ambiente | INIT | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~139 | `console.log('✅ [ENV] DEV via variável global')` | **DEBUG** | Detecção de ambiente | INIT | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~143 | `console.log('❌ [ENV] PRODUÇÃO detectado')` | **INFO** | Detecção de ambiente | INIT | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~155 | `console.error('[ENDPOINT] APP_BASE_URL não disponível')` | **ERROR** | Erro de configuração | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'error' |

### Seção: Logging de Eventos

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~232 | `console.log('[${severity.toUpperCase()}] ${eventType}', {...})` | **INFO/DEBUG** | Log de evento | OPERATION | MEDIUM | Controlar via DEBUG_CONFIG.level baseado em `severity` |
| ~308 | `console.error(logMessage, formattedData)` | **ERROR** | Log de erro | ERROR_HANDLING | VARIÁVEL | Controlar via DEBUG_CONFIG.level = 'error' |
| ~311 | `console.warn(logMessage, formattedData)` | **WARN** | Log de aviso | ERROR_HANDLING | VARIÁVEL | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~314 | `console.debug(logMessage, formattedData)` | **DEBUG** | Log de debug | OPERATION | VARIÁVEL | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~317 | `console.log(logMessage, formattedData)` | **INFO** | Log de informação | OPERATION | VARIÁVEL | Controlar via DEBUG_CONFIG.level = 'info' |

### Seção: Estado do Modal

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~359 | `console.log('💾 [MODAL] Estado do lead salvo:', {...})` | **DEBUG** | Estado do modal | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~365 | `console.warn('⚠️ [MODAL] Não foi possível salvar estado (localStorage indisponível)')` | **WARN** | Aviso de funcionalidade | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |

### Seção: Retry Logic

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~445 | `console.warn('⚠️ [MODAL] Tentativa ${attempt + 1}/${maxRetries + 1} falhou, tentando novamente...')` | **WARN** | Retry de requisição | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~455 | `console.warn('⚠️ [MODAL] Erro de rede na tentativa ${attempt + 1}/${maxRetries + 1}, retry...')` | **WARN** | Retry de rede | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |

### Seção: WhatsApp

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~496 | `console.log('🚀 [MODAL] Abrindo WhatsApp:', url)` | **INFO** | Ação do usuário | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |

### Seção: Debug de Email

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~512 | `console.log('🔍 [DEBUG] Email generation:', {...})` | **TRACE** | Debug de email | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'EMAIL_DEBUG' |
| ~521 | `console.log('🔍 [DEBUG] coletarTodosDados() executada - dados coletados:', {...})` | **TRACE** | Debug de dados | DATA_FLOW | VERBOSE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'EMAIL_DEBUG' |
| ~531 | `console.log('🔍 [DEBUG] Email sendo enviado para EspoCRM:', email)` | **TRACE** | Debug de email | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'EMAIL_DEBUG' |

### Seção: Envio de Email

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~619 | `console.error('❌ [EMAIL] Erro ao identificar momento:', error)` | **ERROR** | Erro de lógica | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~672 | `console.warn('📧 [EMAIL] Dados insuficientes para enviar email - DDD ou celular ausente')` | **WARN** | Validação de dados | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~703 | `console.error('[EMAIL] APP_BASE_URL não disponível')` | **ERROR** | Erro de configuração | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'error' |
| ~709 | `console.log('${modalMoment.emoji} [EMAIL-${modalMoment.color_name}] Enviando notificação ${modalMoment.description}')` | **INFO** | Início de operação | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~730 | `console.error('❌ [EMAIL-ERRO] Erro ao parsear resposta JSON:', parseError)` | **ERROR** | Erro de parsing | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~731 | `console.error('❌ [EMAIL-ERRO] Resposta recebida:', responseText.substring(0, 500))` | **DEBUG** | Debug de resposta | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~738 | `console.error('❌ [EMAIL-ERRO] Resposta não é JSON. Status: ${response.status}...')` | **ERROR** | Erro de formato | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~749 | `console.log('📧 [EMAIL-ENVIADO] Notificação de ${statusTipo} enviada com SUCESSO: ${modalMoment.description}')` | **INFO** | Confirmação de sucesso | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~751 | `console.error('❌ [EMAIL-FALHA] Falha ao enviar notificação ${modalMoment.description}:', result.error || 'Erro desconhecido')` | **ERROR** | Falha de envio | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~757 | `console.error('❌ [EMAIL-EXCEPTION] Erro ao enviar notificação:', error)` | **ERROR** | Exceção | ERROR_HANDLING | VERBOSE | Controlar via DEBUG_CONFIG.level = 'error' (mas simplificar stack trace) |

### Seção: Webhook Data

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~815 | `console.error('❌ [CRÍTICO] webhook_data.data é STRING! Corrigindo...')` | **WARN** | Correção de dados | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~819 | `console.error('❌ [CRÍTICO] Erro ao parsear data:', e)` | **ERROR** | Erro de parsing | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~858 | `console.log('🔍 [DEBUG JSON] Objeto webhook_data original:', webhook_data)` | **TRACE** | Debug de JSON | DATA_FLOW | VERBOSE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'JSON_DEBUG' |
| ~859 | `console.log('🔍 [DEBUG JSON] JSON serializado (JSON.stringify):', jsonBody)` | **TRACE** | Debug de JSON | DATA_FLOW | VERBOSE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'JSON_DEBUG' |
| ~860 | `console.log('🔍 [DEBUG JSON] Tipo do campo data:', typeof webhook_data.data)` | **TRACE** | Debug de JSON | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'JSON_DEBUG' |
| ~861 | `console.log('🔍 [DEBUG JSON] Data é objeto?', webhook_data.data instanceof Object && !Array.isArray(webhook_data.data))` | **TRACE** | Debug de JSON | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'JSON_DEBUG' |
| ~862 | `console.log('🔍 [DEBUG JSON] Data é objeto?', webhook_data.data instanceof Object && !Array.isArray(webhook_data.data))` | **TRACE** | Debug de JSON | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'JSON_DEBUG' |
| ~862 | `console.log('🔍 [DEBUG JSON] Tamanho do JSON:', jsonBody.length, 'caracteres')` | **TRACE** | Debug de JSON | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'JSON_DEBUG' |
| ~867 | `console.log('✅ [DEBUG JSON] JSON válido - pode fazer parse:', testParse.data ? 'Data presente' : 'Data ausente')` | **TRACE** | Debug de JSON | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'JSON_DEBUG' |
| ~869 | `console.error('❌ [DEBUG JSON] JSON INVÁLIDO:', e.message)` | **ERROR** | Erro de JSON | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'error' |

### Seção: Erros de Email (Não Bloqueantes)

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~937 | `console.error('❌ [EMAIL] Erro ao enviar email (não bloqueante):', error)` | **WARN** | Erro não bloqueante | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~942 | `console.warn('⚠️ [MODAL] Erro ao criar lead no EspoCRM:', responseData)` | **WARN** | Erro não bloqueante | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~954, ~974, ~994, ~1139, ~1157, ~1178, ~1198 | `console.error('❌ [EMAIL] Erro ao enviar email de notificação (não bloqueante):', error)` | **WARN** | Erro não bloqueante | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |

### Seção: OctaDesk

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1376 | `console.error('❌ [MODAL] Erro ao enviar mensagem via Octadesk:', error)` | **ERROR** | Erro de integração | ERROR_HANDLING | VERBOSE | Controlar via DEBUG_CONFIG.level = 'error' (mas simplificar stack trace) |

### Seção: Google Ads

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1480 | `console.warn('⚠️ [MODAL] dataLayer não disponível para registro de conversão')` | **WARN** | Aviso de funcionalidade | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1502 | `console.log('✅ [MODAL] Conversão registrada no Google Ads')` | **INFO** | Confirmação de sucesso | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |

### Seção: UI do Modal

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1825 | `console.log('🔍 [MODAL] DDD + Celular preenchidos, expandindo DIV 2')` | **DEBUG** | Ação de UI | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1913 | `console.log('📞 [MODAL] Processando registro inicial (paralelo): EspoCRM + Octadesk + GTM...')` | **INFO** | Início de operação | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~1949 | `console.log('✅ [MODAL] Lead criado no EspoCRM:', espocrmResult.id || 'sem ID')` | **INFO** | Confirmação de sucesso | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~1966 | `console.warn('⚠️ [MODAL] Erro ao criar lead (não bloqueante):', espocrmResult.error)` | **WARN** | Erro não bloqueante | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1970 | `console.log('✅ [MODAL] Mensagem inicial enviada via Octadesk')` | **INFO** | Confirmação de sucesso | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~1972 | `console.warn('⚠️ [MODAL] Erro ao enviar mensagem (não bloqueante):', octadeskResult.error)` | **WARN** | Erro não bloqueante | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1976 | `console.log('✅ [MODAL] Conversão inicial registrada no GTM')` | **INFO** | Confirmação de sucesso | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~1978 | `console.warn('⚠️ [MODAL] Erro ao registrar conversão (não bloqueante):', gtmResult.error)` | **WARN** | Erro não bloqueante | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1989 | `console.warn('⚠️ [MODAL] Erros no processamento inicial (não bloqueante):', error)` | **WARN** | Erro não bloqueante | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~2024 | `console.log('📞 [MODAL] Processando registro inicial (paralelo): EspoCRM + Octadesk + GTM (sem API)...')` | **INFO** | Início de operação | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~2059 | `console.log('✅ [MODAL] Lead criado no EspoCRM:', espocrmResult.id || 'sem ID')` | **INFO** | Confirmação de sucesso | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~2075 | `console.log('✅ [MODAL] Mensagem inicial enviada via Octadesk')` | **INFO** | Confirmação de sucesso | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |

---

## 📁 webflow_injection_limpo.js

### Seção: SpinnerTimer

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~981 | `console.log('🔄 Inicializando SpinnerTimer...')` | **DEBUG** | Inicialização | INIT | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~982 | `console.log('📍 spinnerCenter encontrado:', !!this.elements.spinnerCenter)` | **DEBUG** | Estado de elemento | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~983 | `console.log('📍 timerMessage encontrado:', !!this.elements.timerMessage)` | **DEBUG** | Estado de elemento | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~986 | `console.warn('⚠️ Elementos do spinner timer não encontrados')` | **WARN** | Aviso de elemento | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~990 | `console.log('✅ Iniciando timer...')` | **DEBUG** | Ação de timer | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1000 | `console.log('⏰ Timer iniciado:', this.remainingSeconds, 'segundos')` | **DEBUG** | Estado de timer | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1050 | `console.log('🔄 Timer atualizado:', timerText)` | **TRACE** | Atualização de timer | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'UI_TRACE' |
| ~1052 | `console.warn('⚠️ spinnerCenter não encontrado para atualizar')` | **WARN** | Aviso de elemento | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |

### Seção: ProgressModalRPA

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1162 | `console.log('🚀 ProgressModalRPA inicializado com sessionId:', this.sessionId)` | **DEBUG** | Inicialização | INIT | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1167 | `console.log('🔄 SessionId atualizado:', this.sessionId)` | **DEBUG** | Atualização de estado | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1201 | `console.log('✅ SpinnerTimer inicializado e iniciado')` | **DEBUG** | Confirmação | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1221 | `console.log('⏹️ SpinnerTimer parado')` | **DEBUG** | Estado de timer | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1232 | `console.log('✅ Spinner timer escondido')` | **DEBUG** | Estado de UI | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1235 | `console.error('Erro ao parar spinner timer:', error)` | **ERROR** | Erro de operação | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~1241 | `console.log('✅ Spinner escondido via fallback')` | **DEBUG** | Fallback | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1248 | `console.error('❌ Session ID não encontrado')` | **ERROR** | Erro de configuração | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'error' |
| ~1252 | `console.log('🔄 Iniciando polling do progresso...')` | **DEBUG** | Início de operação | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1258 | `console.log('🔄 Polling ${this.pollCount}/${this.maxPolls}')` | **TRACE** | Progresso de polling | PERFORMANCE | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'POLLING_TRACE' |
| ~1261 | `console.error('❌ Timeout: Processamento demorou mais de 10 minutos')` | **ERROR** | Timeout | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'error' |
| ~1279 | `console.log('⏹️ Polling interrompido')` | **DEBUG** | Estado de polling | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |

### Seção: Dados de Progresso

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1290 | `console.log('📊 Dados do progresso:', data)` | **TRACE** | Dados completos | DATA_FLOW | VERBOSE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'PROGRESS_TRACE' |
| ~1291-1297 | `console.log('📊 Objeto progress:', ...)` (múltiplos) | **TRACE** | Detalhes de progresso | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'PROGRESS_TRACE' |
| ~1307 | `console.log('🔍 DEBUG - Dados completos do progresso:', {...})` | **TRACE** | Debug completo | DATA_FLOW | VERBOSE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'PROGRESS_TRACE' |
| ~1323 | `console.error('❌ Erro detectado no RPA:', {...})` | **ERROR** | Erro de RPA | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~1338 | `console.log('🎉 Status success detectado → forçando fase 16 (finalização completa)')` | **DEBUG** | Lógica de estado | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1344-1345 | `console.log('📈 Fase ${currentPhase}: ${percentual}% (Status: ${currentStatus})')` | **TRACE** | Progresso detalhado | PERFORMANCE | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'PROGRESS_TRACE' |
| ~1362 | `console.log('🎉 RPA concluído com sucesso!')` | **INFO** | Confirmação de sucesso | OPERATION | SIMPLE | Controlar via DEBUG_CONFIG.level = 'info' |
| ~1372 | `console.error('❌ Erro ao atualizar progresso:', error)` | **ERROR** | Erro de atualização | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |

### Seção: Atualização de UI

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1678 | `console.error('🚨 Tratando erro do RPA:', { mensagem, errorCode })` | **ERROR** | Tratamento de erro | ERROR_HANDLING | MEDIUM | Controlar via DEBUG_CONFIG.level = 'error' |
| ~1725 | `console.log('🔄 Atualizando elementos: ${percentual}%, Fase ${currentPhase}, Status: ${currentStatus}')` | **TRACE** | Atualização de UI | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'UI_TRACE' |
| ~1736, ~1742, ~1748, ~1753, ~1758 | `console.log('✅ ... atualizado:', ...)` (múltiplos) | **TRACE** | Confirmação de atualização | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'UI_TRACE' |

### Seção: Estimativas e Resultados

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1773 | `console.log('💰 Atualizando estimativa inicial:', data)` | **DEBUG** | Atualização de dados | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1781 | `console.log('💰 Estimativas encontradas:', estimativas)` | **DEBUG** | Dados encontrados | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1799 | `console.log('💰 Valor inicial formatado:', valorFormatado)` | **TRACE** | Formatação | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'DATA_TRACE' |
| ~1809, ~1812 | `console.log('⚠️ Valor inicial não encontrado...')` | **WARN** | Aviso de dados | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1824 | `console.log('📊 Atualizando resultados finais:', data)` | **DEBUG** | Atualização de dados | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1825 | `console.log('📊 Estrutura completa dos dados:', JSON.stringify(data, null, 2))` | **TRACE** | Dados completos | DATA_FLOW | VERBOSE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'DATA_TRACE' |
| ~1837, ~1846, ~1854 | `console.log('✅ Dados encontrados em...')` | **DEBUG** | Confirmação de dados | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~1857 | `console.log('🔍 DEBUG - Estrutura completa:', {...})` | **TRACE** | Debug completo | DATA_FLOW | VERBOSE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'DATA_TRACE' |
| ~1866 | `console.log('📊 Resultados encontrados:', { planoRecomendado, planoAlternativo })` | **INFO** | Resultados finais | OPERATION | MEDIUM | Controlar via DEBUG_CONFIG.level = 'info' |
| ~1878 | `console.log('⚠️ Nenhum resultado final encontrado em nenhuma estrutura')` | **WARN** | Aviso de dados | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |

### Seção: Atualização de Valores

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~1883, ~1887 | `console.log('🔍 DEBUG - updateCardValue chamado:...')` | **TRACE** | Debug de função | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'DATA_TRACE' |
| ~1892 | `console.log('✅ Valor ${elementId} atualizado:...')` | **TRACE** | Confirmação de atualização | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'UI_TRACE' |
| ~1894 | `console.error('❌ Elemento #${elementId} não encontrado no DOM')` | **ERROR** | Erro de elemento | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'error' |
| ~1897 | `console.warn('⚠️ Valor vazio para ${elementId}:', valor)` | **WARN** | Aviso de dados | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1904 | `console.log('🔍 DEBUG - Atualizando detalhes do plano ${prefix}:', plano)` | **TRACE** | Debug de função | DATA_FLOW | MEDIUM | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'DATA_TRACE' |
| ~1948 | `console.log('✅ Campo ${elementId} atualizado:', value)` | **TRACE** | Confirmação de atualização | UI | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'UI_TRACE' |
| ~1968 | `console.log('💰 Valor já formatado:', value)` | **TRACE** | Formatação | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'DATA_TRACE' |
| ~1984 | `console.warn('⚠️ Valor inválido para formatação:', value)` | **WARN** | Aviso de dados | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'warn' |
| ~1994 | `console.log('💰 Valor formatado:', value, '→', formatted)` | **TRACE** | Formatação | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'trace' ou categoria 'DATA_TRACE' |

### Seção: Validação de Placa

| Linha | Código | Classificação | Natureza | Contexto | Verbosidade | Ação |
|-------|--------|---------------|----------|----------|-------------|------|
| ~2118 | `console.error('[RPA] APP_BASE_URL não disponível para validação de placa')` | **ERROR** | Erro de configuração | ERROR_HANDLING | SIMPLE | Controlar via DEBUG_CONFIG.level = 'error' |
| ~2149 | `console.log('❌ [VALIDACAO] Numero inválido - length:', n.length, 'esperado: 9')` | **DEBUG** | Validação de dados | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |
| ~2153 | `console.log('❌ [VALIDACAO] Numero não começa com 9 - primeiro dígito:', n[0])` | **DEBUG** | Validação de dados | DATA_FLOW | SIMPLE | Controlar via DEBUG_CONFIG.level = 'debug' |

---

## 📊 RESUMO POR CLASSIFICAÇÃO

### CRITICAL (Sempre Exibir)
- **Total:** 2 logs
- **Arquivos:** FooterCodeSiteDefinitivoCompleto.js (linhas ~133, ~148)
- **Ação:** Manter sempre visíveis, independente de `DEBUG_CONFIG`

### ERROR (Exibir em Produção)
- **Total:** ~35 logs
- **Ação:** Controlar via `DEBUG_CONFIG.level = 'error'` ou superior

### WARN (Exibir em Produção)
- **Total:** ~25 logs
- **Ação:** Controlar via `DEBUG_CONFIG.level = 'warn'` ou superior

### INFO (Exibir apenas em Dev)
- **Total:** ~20 logs
- **Ação:** Controlar via `DEBUG_CONFIG.level = 'info'` ou superior

### DEBUG (Exibir apenas em Debug)
- **Total:** ~50 logs
- **Ação:** Controlar via `DEBUG_CONFIG.level = 'debug'` ou superior

### TRACE (Exibir apenas em Troubleshooting)
- **Total:** ~60 logs
- **Ação:** Controlar via `DEBUG_CONFIG.level = 'trace'` ou categoria específica

---

## 🎯 PROPOSTA DE IMPLEMENTAÇÃO

### Sistema de Classificação Integrado

Criar função wrapper que classifica e controla logs:

```javascript
function logClassified(level, category, message, data, context = 'OPERATION', verbosity = 'SIMPLE') {
  // Verificar se deve exibir baseado em:
  // 1. DEBUG_CONFIG.enabled
  // 2. DEBUG_CONFIG.level (CRITICAL > ERROR > WARN > INFO > DEBUG > TRACE)
  // 3. DEBUG_CONFIG.categories (exclude/include)
  // 4. DEBUG_CONFIG.contexts (exclude/include)
  // 5. DEBUG_CONFIG.verbosity (SIMPLE, MEDIUM, VERBOSE)
}
```

### Categorias Especiais
- `EMAIL_DEBUG` - Logs de debug de email
- `JSON_DEBUG` - Logs de debug de JSON
- `UI_TRACE` - Logs de rastreamento de UI
- `PROGRESS_TRACE` - Logs de rastreamento de progresso
- `DATA_TRACE` - Logs de rastreamento de dados
- `POLLING_TRACE` - Logs de rastreamento de polling

---

**Status:** ✅ **CLASSIFICAÇÃO COMPLETA REALIZADA**

