# 📊 ANÁLISE: Logs que Respeitam DEBUG_CONFIG

**Data:** 11/11/2025  
**Objetivo:** Verificar quais logs respeitam a configuração `DEBUG_CONFIG` e quais não respeitam

---

## ✅ LOGS QUE RESPEITAM DEBUG_CONFIG

### FooterCodeSiteDefinitivoCompleto.js

**Total aproximado:** ~150 ocorrências

**Método:** Via `window.logUnified()` e aliases:
- `window.logInfo()`
- `window.logError()`
- `window.logWarn()`
- `window.logDebug()`

**Como funciona:**
```javascript
window.logUnified = function(level, category, message, data) {
  // ✅ VERIFICAÇÃO PRIORITÁRIA: Bloquear ANTES de qualquer execução
  if (window.DEBUG_CONFIG && 
      (window.DEBUG_CONFIG.enabled === false || window.DEBUG_CONFIG.enabled === 'false')) {
    return; // Bloquear TODOS os logs se disabled
  }
  
  // ✅ Verifica nível (error, warn, info, debug, all)
  const levels = { 'none': 0, 'error': 1, 'warn': 2, 'info': 3, 'debug': 4, 'all': 5 };
  const currentLevel = levels[config.level] || levels['info'];
  const messageLevel = levels[level] || levels['info'];
  if (messageLevel > currentLevel) return;
  
  // ✅ Verifica exclusão de categoria
  if (config.exclude && config.exclude.length > 0) {
    if (category && config.exclude.includes(category)) return;
  }
  
  // ... exibe log apenas se passou todas as verificações
}
```

**Exemplos de logs que respeitam:**
- `window.logInfo('UTILS', '🔄 Carregando Footer Code Utils...')` - Linha ~659
- `window.logError('UTILS', '❌ Funções de CPF não disponíveis')` - Linha ~987
- `window.logWarn('UTILS', '⚠️ VALIDAR_PH3A não disponível')` - Linha ~1003
- `window.logDebug('GCLID', '🔍 Iniciando captura - URL:', ...)` - Linha ~1340
- `window.logInfo('RPA', '🎯 Carregando script RPA...')` - Linha ~1560
- `window.logInfo('MODAL', '✅ Modal já carregado')` - Linha ~1637
- `window.logError('RPA', '❌ Erro ao carregar script RPA')` - Linha ~1585

**Status:** ✅ **TODOS ESTES LOGS RESPEITAM DEBUG_CONFIG**

---

## ❌ LOGS QUE NÃO RESPEITAM DEBUG_CONFIG

### FooterCodeSiteDefinitivoCompleto.js

**Total aproximado:** ~30 ocorrências

#### 1. Logs de Configuração (Linhas ~122, ~133, ~144, ~148)
```javascript
console.error('[CONFIG] Não foi possível detectar URL base do servidor');
console.error('[CONFIG] Erro crítico: Não foi possível detectar URL base do servidor');
console.log('[CONFIG] config_env.js.php carregado com sucesso. APP_BASE_URL:', window.APP_BASE_URL);
console.error('[CONFIG] Erro crítico: Não foi possível carregar config_env.js.php');
```
**Status:** ❌ **NÃO respeitam DEBUG_CONFIG** - São críticos de inicialização

#### 2. Logs de Debug Temporário (Linhas ~584-588)
```javascript
console.log('[DEBUG-TEMP] window.DEBUG_CONFIG existe?', !!window.DEBUG_CONFIG);
console.log('[DEBUG-TEMP] window.DEBUG_CONFIG:', window.DEBUG_CONFIG);
console.log('[DEBUG-TEMP] enabled value:', window.DEBUG_CONFIG?.enabled);
console.log('[DEBUG-TEMP] enabled === false?', window.DEBUG_CONFIG?.enabled === false);
console.log('[DEBUG-TEMP] enabled type:', typeof window.DEBUG_CONFIG?.enabled);
```
**Status:** ❌ **NÃO respeitam DEBUG_CONFIG** - Debug temporário que deve ser removido

#### 3. Logs em sendLogToProfessionalSystem() (Linhas ~361, ~366, ~384, ~400, ~455-469, ~483, ~501, ~509, ~513, ~522, ~533, ~537, ~550)
```javascript
console.warn('[LOG] sendLogToProfessionalSystem chamado sem level válido');
console.warn('[LOG] sendLogToProfessionalSystem chamado sem message válido');
console.warn('[LOG] APP_BASE_URL não disponível após aguardar. Log não enviado.');
console.warn('[LOG] Level inválido:', level, '- usando INFO como fallback');
console.group(`[LOG] 📤 Enviando log para ${endpoint}`, requestId);
console.log('📋 Payload:', {...});
console.log('📦 Payload completo:', logData);
console.log('🔗 Endpoint:', endpoint);
console.log('⏰ Timestamp:', new Date().toISOString());
console.log(`[LOG] 📥 Resposta recebida (${Math.round(fetchDuration)}ms):`, {...});
console.error('[LOG] ❌ Erro HTTP na resposta:', {...});
console.error('[LOG] ❌ Detalhes completos do erro:', errorData);
console.error('[LOG] ❌ Debug info do servidor:', errorData.debug);
console.log(`[LOG] ✅ Sucesso (${Math.round(fetchDuration)}ms):`, {...});
console.debug(`[LOG] Enviado: ${result.log_id}`); // ⚠️ Este verifica DEBUG_CONFIG mas é dentro de um grupo
console.error(`[LOG] ❌ Erro ao enviar log (${Math.round(fetchDuration)}ms):`, {...});
console.error('[LOG] Erro ao enviar log:', error); // ⚠️ Este verifica DEBUG_CONFIG mas é dentro de um grupo
```
**Status:** ❌ **NÃO respeitam DEBUG_CONFIG** - Logs verbosos de debug interno

#### 4. Logs em logDebug() local (Linhas ~1504, ~1509, ~1517, ~1540)
```javascript
console.warn('[LOG] logDebug chamado sem level válido:', level);
console.warn('[LOG] logDebug chamado sem message válido:', message);
console.warn('[LOG] logDebug chamado com level inválido:', level, '- usando INFO como fallback');
console.log(`[${level}] ${message}`, data); // ⚠️ Este verifica DEBUG_CONFIG mas é função local
```
**Status:** ⚠️ **PARCIALMENTE** - Alguns verificam, mas são logs internos

---

### MODAL_WHATSAPP_DEFINITIVO.js

**Total aproximado:** ~79 ocorrências

**Todos os logs são diretos com `console.*`:**

```javascript
console.log('✅ [ENV] Hardcode DEV: webflow.io detectado');
console.log('✅ [ENV] DEV via hostname padrão');
console.log('✅ [ENV] DEV via URL path');
console.log('✅ [ENV] DEV via parâmetro GET');
console.log('✅ [ENV] DEV via variável global');
console.log('❌ [ENV] PRODUÇÃO detectado');
console.error('[ENDPOINT] APP_BASE_URL não disponível');
console.log(`[${severity.toUpperCase()}] ${eventType}`, {...});
console.error(logMessage, formattedData);
console.warn(logMessage, formattedData);
console.debug(logMessage, formattedData);
console.log(logMessage, formattedData);
console.log('💾 [MODAL] Estado do lead salvo:', {...});
console.warn('⚠️ [MODAL] Não foi possível salvar estado (localStorage indisponível)');
console.warn(`⚠️ [MODAL] Tentativa ${attempt + 1}/${maxRetries + 1} falhou, tentando novamente...`);
console.log('🚀 [MODAL] Abrindo WhatsApp:', url);
console.log('🔍 [DEBUG] Email generation:', {...});
console.log('🔍 [DEBUG] coletarTodosDados() executada - dados coletados:', {...});
console.log('🔍 [DEBUG] Email sendo enviado para EspoCRM:', email);
console.error('❌ [EMAIL] Erro ao identificar momento:', error);
console.warn('📧 [EMAIL] Dados insuficientes para enviar email - DDD ou celular ausente');
console.error('[EMAIL] APP_BASE_URL não disponível');
console.log(`${modalMoment.emoji} [EMAIL-${modalMoment.color_name}] Enviando notificação ${modalMoment.description}`);
console.error('❌ [EMAIL-ERRO] Erro ao parsear resposta JSON:', parseError);
console.error('❌ [EMAIL-ERRO] Resposta recebida:', responseText.substring(0, 500));
console.error(`❌ [EMAIL-ERRO] Resposta não é JSON. Status: ${response.status}...`);
console.log(`📧 [EMAIL-ENVIADO] Notificação de ${statusTipo} enviada com SUCESSO: ${modalMoment.description}`);
console.error(`❌ [EMAIL-FALHA] Falha ao enviar notificação ${modalMoment.description}:`, result.error || 'Erro desconhecido');
console.error('❌ [EMAIL-EXCEPTION] Erro ao enviar notificação:', error);
console.error('❌ [CRÍTICO] webhook_data.data é STRING! Corrigindo...');
console.error('❌ [CRÍTICO] Erro ao parsear data:', e);
console.log('🔍 [DEBUG JSON] Objeto webhook_data original:', webhook_data);
console.log('🔍 [DEBUG JSON] JSON serializado (JSON.stringify):', jsonBody);
console.log('🔍 [DEBUG JSON] Tipo do campo data:', typeof webhook_data.data);
console.log('🔍 [DEBUG JSON] Data é objeto?', webhook_data.data instanceof Object && !Array.isArray(webhook_data.data));
console.log('🔍 [DEBUG JSON] Tamanho do JSON:', jsonBody.length, 'caracteres');
console.log('✅ [DEBUG JSON] JSON válido - pode fazer parse:', testParse.data ? 'Data presente' : 'Data ausente');
console.error('❌ [DEBUG JSON] JSON INVÁLIDO:', e.message);
console.error('❌ [EMAIL] Erro ao enviar email (não bloqueante):', error);
console.warn('⚠️ [MODAL] Erro ao criar lead no EspoCRM:', responseData);
console.error('❌ [EMAIL] Erro ao enviar email de notificação (não bloqueante):', error);
console.error('❌ [MODAL] Erro ao enviar mensagem via Octadesk:', error);
console.warn('⚠️ [MODAL] dataLayer não disponível para registro de conversão');
console.log('✅ [MODAL] Conversão registrada no Google Ads');
console.log('🔍 [MODAL] DDD + Celular preenchidos, expandindo DIV 2');
console.log('📞 [MODAL] Processando registro inicial (paralelo): EspoCRM + Octadesk + GTM...');
console.log('✅ [MODAL] Lead criado no EspoCRM:', espocrmResult.id || 'sem ID');
console.warn('⚠️ [MODAL] Erro ao criar lead (não bloqueante):', espocrmResult.error);
console.log('✅ [MODAL] Mensagem inicial enviada via Octadesk');
console.warn('⚠️ [MODAL] Erro ao enviar mensagem (não bloqueante):', octadeskResult.error);
console.log('✅ [MODAL] Conversão inicial registrada no GTM');
console.warn('⚠️ [MODAL] Erro ao registrar conversão (não bloqueante):', gtmResult.error);
console.warn('⚠️ [MODAL] Erros no processamento inicial (não bloqueante):', error);
console.log('📞 [MODAL] Processando registro inicial (paralelo): EspoCRM + Octadesk + GTM (sem API)...');
console.log('✅ [MODAL] Lead criado no EspoCRM:', espocrmResult.id || 'sem ID');
console.log('✅ [MODAL] Mensagem inicial enviada via Octadesk');
```

**Status:** ❌ **NENHUM LOG RESPEITA DEBUG_CONFIG** - Todos são diretos com `console.*`

---

### webflow_injection_limpo.js

**Total aproximado:** ~151 ocorrências

**Todos os logs são diretos com `console.*`:**

```javascript
console.log('🔄 Inicializando SpinnerTimer...');
console.log('📍 spinnerCenter encontrado:', !!this.elements.spinnerCenter);
console.log('📍 timerMessage encontrado:', !!this.elements.timerMessage);
console.warn('⚠️ Elementos do spinner timer não encontrados');
console.log('✅ Iniciando timer...');
console.log('⏰ Timer iniciado:', this.remainingSeconds, 'segundos');
console.log('🔄 Timer atualizado:', timerText);
console.warn('⚠️ spinnerCenter não encontrado para atualizar');
console.log('🚀 ProgressModalRPA inicializado com sessionId:', this.sessionId);
console.log('🔄 SessionId atualizado:', this.sessionId);
console.log('✅ SpinnerTimer inicializado e iniciado');
console.log('⏹️ SpinnerTimer parado');
console.log('✅ Spinner timer escondido');
console.error('Erro ao parar spinner timer:', error);
console.log('✅ Spinner escondido via fallback');
console.error('❌ Session ID não encontrado');
console.log('🔄 Iniciando polling do progresso...');
console.log(`🔄 Polling ${this.pollCount}/${this.maxPolls}`);
console.error('❌ Timeout: Processamento demorou mais de 10 minutos');
console.log('⏹️ Polling interrompido');
console.log('📊 Dados do progresso:', data);
console.log('📊 Objeto progress:', data.progress);
console.log('📊 Etapa atual:', data.progress?.etapa_atual);
console.log('📊 Fase atual:', data.progress?.fase_atual);
console.log('📊 Status:', data.progress?.status);
console.log('📊 Mensagem:', data.progress?.mensagem);
console.log('📊 Código de erro:', data.progress?.error_code);
console.log('📊 Código de status:', data.progress?.status_code);
console.log('🔍 DEBUG - Dados completos do progresso:', {...});
console.error('❌ Erro detectado no RPA:', {...});
console.log('🎉 Status success detectado → forçando fase 16 (finalização completa)');
console.log(`📈 Fase ${currentPhase}: ${percentual}% (Status: ${currentStatus})`);
console.log(`📊 Percentual calculado pela fase: ${percentual}`);
console.log('🎉 RPA concluído com sucesso!');
console.error('❌ Erro ao atualizar progresso:', error);
console.error('🚨 Tratando erro do RPA:', { mensagem, errorCode });
console.log(`🔄 Atualizando elementos: ${percentual}%, Fase ${currentPhase}, Status: ${currentStatus}`);
console.log('✅ Progress text atualizado:', progressText.textContent);
console.log('✅ Current phase atualizado:', message);
console.log('✅ Sub phase atualizado:', subMessage);
console.log('✅ Stage info atualizado:', stageInfo.textContent);
console.log('✅ Progress fill atualizado:', progressFill.style.width);
console.log('💰 Atualizando estimativa inicial:', data);
console.log('💰 Estimativas encontradas:', estimativas);
console.log('💰 Valor inicial formatado:', valorFormatado);
console.log('⚠️ Valor inicial não encontrado nas estimativas');
console.log('⚠️ Nenhuma estimativa encontrada nos dados');
console.log('📊 Atualizando resultados finais:', data);
console.log('📊 Estrutura completa dos dados:', JSON.stringify(data, null, 2));
console.log('✅ Dados encontrados em resultados_finais.dados.dados_finais');
console.log('✅ Dados encontrados em timeline[final].dados_extra');
console.log('✅ Dados encontrados em dados_extra direto');
console.log('🔍 DEBUG - Estrutura completa:', {...});
console.log('📊 Resultados encontrados:', { planoRecomendado, planoAlternativo });
console.log('⚠️ Nenhum resultado final encontrado em nenhuma estrutura');
console.log(`🔍 DEBUG - updateCardValue chamado:`, { elementId, valor, tipo: typeof valor });
console.log(`🔍 DEBUG - Elemento encontrado:`, element);
console.log(`✅ Valor ${elementId} atualizado:`, valorFormatado);
console.error(`❌ Elemento #${elementId} não encontrado no DOM`);
console.warn(`⚠️ Valor vazio para ${elementId}:`, valor);
console.log(`🔍 DEBUG - Atualizando detalhes do plano ${prefix}:`, plano);
console.log(`✅ Campo ${elementId} atualizado:`, value);
console.log('💰 Valor já formatado:', value);
console.warn('⚠️ Valor inválido para formatação:', value);
console.log('💰 Valor formatado:', value, '→', formatted);
console.error('[RPA] APP_BASE_URL não disponível para validação de placa');
console.log('❌ [VALIDACAO] Numero inválido - length:', n.length, 'esperado: 9');
console.log('❌ [VALIDACAO] Numero não começa com 9 - primeiro dígito:', n[0]);
```

**Status:** ❌ **NENHUM LOG RESPEITA DEBUG_CONFIG** - Todos são diretos com `console.*`

---

## 📊 RESUMO

### ✅ Logs que RESPEITAM DEBUG_CONFIG
- **FooterCodeSiteDefinitivoCompleto.js:** ~150 ocorrências via `window.logUnified()` e aliases
- **Total:** ~150 logs

### ❌ Logs que NÃO RESPEITAM DEBUG_CONFIG
- **FooterCodeSiteDefinitivoCompleto.js:** ~30 ocorrências (config, debug temp, sendLogToProfessionalSystem)
- **MODAL_WHATSAPP_DEFINITIVO.js:** ~79 ocorrências (todos diretos)
- **webflow_injection_limpo.js:** ~151 ocorrências (todos diretos)
- **Total:** ~260 logs

---

## 🎯 CONCLUSÃO

**Apenas ~37% dos logs respeitam DEBUG_CONFIG.**

**Problemas identificados:**
1. ❌ ~260 logs não respeitam a configuração
2. ❌ Logs verbosos em `sendLogToProfessionalSystem()` sempre executam
3. ❌ Logs de debug temporário sempre executam
4. ❌ Todos os logs em `MODAL_WHATSAPP_DEFINITIVO.js` não respeitam
5. ❌ Todos os logs em `webflow_injection_limpo.js` não respeitam

**Impacto:**
- Mesmo com `DEBUG_CONFIG.enabled = false`, ~260 logs ainda serão exibidos
- Mesmo com `DEBUG_CONFIG.level = 'error'`, logs de debug/info ainda serão exibidos
- Performance degradada por logs desnecessários em produção

---

**Status:** ❌ **MAIORIA DOS LOGS NÃO RESPEITAM DEBUG_CONFIG**

