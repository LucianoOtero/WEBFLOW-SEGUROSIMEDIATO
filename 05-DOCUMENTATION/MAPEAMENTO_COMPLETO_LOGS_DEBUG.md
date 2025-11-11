# 📊 MAPEAMENTO COMPLETO: Todos os Logs de Debug

**Data:** 11/11/2025  
**Objetivo:** Mapear todos os logs de debug, info, warn, error em todos os arquivos JavaScript

---

## 📁 ARQUIVOS ANALISADOS

1. `FooterCodeSiteDefinitivoCompleto.js` (2.538 linhas)
2. `MODAL_WHATSAPP_DEFINITIVO.js`
3. `webflow_injection_limpo.js`

---

## 📋 FooterCodeSiteDefinitivoCompleto.js

### Logs Diretos com `console.*` (NÃO respeitam DEBUG_CONFIG)

#### Seção: Carregamento de Variáveis de Ambiente
- **Linha ~122:** `console.error('[CONFIG] Não foi possível detectar URL base do servidor')` - ❌ Direto
- **Linha ~133:** `console.error('[CONFIG] Erro crítico: Não foi possível detectar URL base do servidor')` - ❌ Direto
- **Linha ~144:** `console.log('[CONFIG] config_env.js.php carregado com sucesso. APP_BASE_URL:', window.APP_BASE_URL)` - ❌ Direto
- **Linha ~148:** `console.error('[CONFIG] Erro crítico: Não foi possível carregar config_env.js.php')` - ❌ Direto

#### Seção: sendLogToProfessionalSystem()
- **Linha ~361:** `console.warn('[LOG] sendLogToProfessionalSystem chamado sem level válido')` - ❌ Direto
- **Linha ~366:** `console.warn('[LOG] sendLogToProfessionalSystem chamado sem message válido')` - ❌ Direto
- **Linha ~384:** `console.warn('[LOG] APP_BASE_URL não disponível após aguardar. Log não enviado.')` - ❌ Direto (removido com Data Attributes)
- **Linha ~400:** `console.warn('[LOG] Level inválido:', level, '- usando INFO como fallback')` - ❌ Direto
- **Linha ~455:** `console.group('[LOG] 📤 Enviando log para ${endpoint}', requestId)` - ❌ Direto, VERBOSO
- **Linha ~456:** `console.log('📋 Payload:', {...})` - ❌ Direto, VERBOSO (objeto grande)
- **Linha ~467:** `console.log('📦 Payload completo:', logData)` - ❌ Direto, MUITO VERBOSO (objeto completo)
- **Linha ~468:** `console.log('🔗 Endpoint:', endpoint)` - ❌ Direto
- **Linha ~469:** `console.log('⏰ Timestamp:', new Date().toISOString())` - ❌ Direto
- **Linha ~483:** `console.log('[LOG] 📥 Resposta recebida (${Math.round(fetchDuration)}ms):', {...})` - ❌ Direto, VERBOSO (objeto grande)
- **Linha ~501:** `console.error('[LOG] ❌ Erro HTTP na resposta:', {...})` - ❌ Direto, VERBOSO (objeto grande)
- **Linha ~509:** `console.error('[LOG] ❌ Detalhes completos do erro:', errorData)` - ❌ Direto, VERBOSO
- **Linha ~513:** `console.error('[LOG] ❌ Debug info do servidor:', errorData.debug)` - ❌ Direto, VERBOSO
- **Linha ~522:** `console.log('[LOG] ✅ Sucesso (${Math.round(fetchDuration)}ms):', {...})` - ❌ Direto, MUITO VERBOSO (objeto com `full_response`)
- **Linha ~529:** `console.groupEnd()` - ❌ Direto
- **Linha ~533:** `console.debug('[LOG] Enviado: ${result.log_id}')` - ❌ Direto (mas verifica DEBUG_CONFIG)
- **Linha ~537:** `console.error('[LOG] ❌ Erro ao enviar log (${Math.round(fetchDuration)}ms):', {...})` - ❌ Direto, MUITO VERBOSO (stack trace completo)
- **Linha ~545:** `console.groupEnd()` - ❌ Direto
- **Linha ~550:** `console.error('[LOG] Erro ao enviar log:', error)` - ❌ Direto (mas verifica DEBUG_CONFIG)

#### Seção: logUnified() - Debug Temporário
- **Linha ~584:** `console.log('[DEBUG-TEMP] window.DEBUG_CONFIG existe?', !!window.DEBUG_CONFIG)` - ❌ Direto, DEBUG TEMPORÁRIO
- **Linha ~585:** `console.log('[DEBUG-TEMP] window.DEBUG_CONFIG:', window.DEBUG_CONFIG)` - ❌ Direto, DEBUG TEMPORÁRIO
- **Linha ~586:** `console.log('[DEBUG-TEMP] enabled value:', window.DEBUG_CONFIG?.enabled)` - ❌ Direto, DEBUG TEMPORÁRIO
- **Linha ~587:** `console.log('[DEBUG-TEMP] enabled === false?', window.DEBUG_CONFIG?.enabled === false)` - ❌ Direto, DEBUG TEMPORÁRIO
- **Linha ~588:** `console.log('[DEBUG-TEMP] enabled type:', typeof window.DEBUG_CONFIG?.enabled)` - ❌ Direto, DEBUG TEMPORÁRIO

#### Seção: logUnified() - Console Output
- **Linha ~639:** `console.error(formattedMessage, data || '')` - ✅ Via logUnified (respeita DEBUG_CONFIG)
- **Linha ~642:** `console.warn(formattedMessage, data || '')` - ✅ Via logUnified (respeita DEBUG_CONFIG)
- **Linha ~647:** `console.log(formattedMessage, data || '')` - ✅ Via logUnified (respeita DEBUG_CONFIG)

#### Seção: logDebug() local
- **Linha ~1517:** `console.warn('[LOG] logDebug chamado com level inválido:', level, '- usando INFO como fallback')` - ❌ Direto
- **Linha ~1540:** `console.log('[${level}] ${message}', data)` - ❌ Direto (mas verifica DEBUG_CONFIG)

### Logs via Sistema Unificado (RESPEITAM DEBUG_CONFIG)

#### Via window.logUnified() / window.logInfo() / window.logError() / window.logWarn() / window.logDebug()

**Total aproximado:** ~150 ocorrências

**Categorias identificadas:**
- `UTILS` - Logs de carregamento de utilitários
- `GCLID` - Logs de captura de GCLID
- `MODAL` - Logs do modal WhatsApp
- `RPA` - Logs do sistema RPA
- `FOOTER` - Logs do footer code
- `GTM` - Logs do Google Tag Manager
- `DEBUG` - Logs de debug
- Outras categorias

**Exemplos:**
- `window.logInfo('UTILS', '🔄 Carregando Footer Code Utils...')` - Linha ~642
- `window.logDebug('GCLID', '🔍 Iniciando captura - URL:', window.location.href)` - Linha ~1340
- `window.logInfo('GCLID', '✅ Capturado da URL e salvo em cookie:', trackingId)` - Linha ~1356
- `window.logError('GCLID', '❌ Erro ao salvar cookie:', error)` - Linha ~1362
- `window.logWarn('GCLID', '⚠️ gclsrc bloqueou salvamento:', gclsrc)` - Linha ~1365
- `window.logWarn('GCLID', '⚠️ Nenhum trackingId encontrado na URL')` - Linha ~1368
- `window.logInfo('RPA', '🎯 Carregando script RPA...')` - Linha ~1511
- `window.logInfo('RPA', '✅ Script RPA carregado com sucesso')` - Linha ~1524
- `window.logError('RPA', '❌ Erro ao carregar script RPA')` - Linha ~1528
- `window.logInfo('MODAL', '✅ Modal já carregado')` - Linha ~1579
- `window.logInfo('MODAL', '🔄 Carregando modal...')` - Linha ~1590
- `window.logInfo('MODAL', '✅ Modal carregado com sucesso')` - Linha ~1595
- `window.logError('MODAL', '❌ Erro ao carregar modal')` - Linha ~1598
- `window.logDebug('MODAL', '🔄 Abrindo modal WhatsApp')` - Linha ~1639
- `window.logDebug('MODAL', '⚠️ Modal já está sendo aberto, ignorando chamada duplicada')` - Linha ~1634
- `window.logDebug('DEBUG', '🔍 Funções de debug disponíveis:')` - Linha ~2513
- `window.logWarn('DEBUG', '⚠️ Erros detectados durante inicialização:', errors)` - Linha ~2505
- `window.logDebug('DEBUG', '✅ Nenhum erro detectado durante inicialização')` - Linha ~2507
- `window.logDebug('DEBUG', '🔍 === FIM DA DETECÇÃO DE CONFLITOS ===')` - Linha ~2511

---

## 📋 MODAL_WHATSAPP_DEFINITIVO.js

### Logs Diretos com `console.*` (NÃO respeitam DEBUG_CONFIG)

**Total aproximado:** ~79 ocorrências

**Exemplos identificados:**
- `console.log('✅ [ENV] Hardcode DEV: webflow.io detectado')` - Linha ~113
- `console.log('✅ [ENV] DEV via hostname padrão')` - Linha ~121
- `console.log('✅ [ENV] DEV via URL path')` - Linha ~126
- `console.log('✅ [ENV] DEV via parâmetro GET')` - Linha ~133
- `console.log('✅ [ENV] DEV via variável global')` - Linha ~139
- `console.log('❌ [ENV] PRODUÇÃO detectado')` - Linha ~143
- `console.error('[ENDPOINT] APP_BASE_URL não disponível')` - Linha ~155
- `console.log('${modalMoment.emoji} [EMAIL-${modalMoment.color_name}] Enviando notificação ${modalMoment.description}')` - Linha ~709
- `console.error('❌ [EMAIL-ERRO] Erro ao parsear resposta JSON:', parseError)` - Linha ~730
- `console.error('❌ [EMAIL-ERRO] Resposta recebida:', responseText.substring(0, 500))` - Linha ~731
- `console.error('❌ [EMAIL-ERRO] Resposta não é JSON. Status: ${response.status}, Tipo: ${contentType}, Texto: ${responseText.substring(0, 200)}')` - Linha ~738
- `console.log('📧 [EMAIL-ENVIADO] Notificação de ${statusTipo} enviada com SUCESSO: ${modalMoment.description}')` - Linha ~749
- `console.error('❌ [EMAIL-FALHA] Falha ao enviar notificação ${modalMoment.description}:', result.error || 'Erro desconhecido')` - Linha ~751
- `console.error('❌ [EMAIL-EXCEPTION] Erro ao enviar notificação:', error)` - Linha ~757

**Observação:** Muitos logs de debug/info que não são essenciais.

---

## 📋 webflow_injection_limpo.js

### Logs Diretos com `console.*` (NÃO respeitam DEBUG_CONFIG)

**Total aproximado:** ~151 ocorrências

**Observação:** Arquivo grande com muitos logs de debug/info que não são essenciais.

---

## 📊 RESUMO POR TIPO

### Logs que NÃO respeitam DEBUG_CONFIG

**FooterCodeSiteDefinitivoCompleto.js:**
- `console.*` diretos: ~25 ocorrências
- Logs verbosos em `sendLogToProfessionalSystem()`: ~15 ocorrências
- Logs de debug temporário: 5 ocorrências

**MODAL_WHATSAPP_DEFINITIVO.js:**
- `console.*` diretos: ~79 ocorrências

**webflow_injection_limpo.js:**
- `console.*` diretos: ~151 ocorrências

**Total:** ~275 ocorrências que NÃO respeitam `DEBUG_CONFIG`

---

### Logs que RESPEITAM DEBUG_CONFIG

**FooterCodeSiteDefinitivoCompleto.js:**
- Via `window.logUnified()` e aliases: ~150 ocorrências

**Total:** ~150 ocorrências que respeitam `DEBUG_CONFIG`

---

## 🎯 CLASSIFICAÇÃO POR PRIORIDADE

### CRÍTICO - Remover Imediatamente
1. Logs de debug temporário (linhas ~582-589) - 5 ocorrências
2. Logs verbosos em `sendLogToProfessionalSystem()` - ~15 ocorrências
3. `console.group()` e `console.groupEnd()` - 2 ocorrências

### ALTO - Simplificar/Remover
1. Todos os `console.*` diretos que não verificam `DEBUG_CONFIG` - ~275 ocorrências
2. Logs de debug/info desnecessários - ~200 ocorrências

### MÉDIO - Manter mas Simplificar
1. Logs de warning/error via `logUnified()` - manter, mas simplificar mensagens
2. Logs essenciais para diagnóstico - manter apenas os críticos

### BAIXO - Manter
1. Logs de error/fatal essenciais - manter
2. Logs de warning importantes - manter

---

## 📋 PRÓXIMOS PASSOS

1. ✅ Mapeamento completo realizado
2. ⏳ Aguardando aprovação para criar projeto detalhado de limpeza
3. ⏳ Implementar limpeza seguindo classificação de prioridade

---

**Status:** ✅ **MAPEAMENTO COMPLETO REALIZADO**

