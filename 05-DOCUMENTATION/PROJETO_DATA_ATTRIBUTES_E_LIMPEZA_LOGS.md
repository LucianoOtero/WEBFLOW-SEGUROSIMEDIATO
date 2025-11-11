# 📋 PROJETO: Data Attributes + Classificação e Controle de Logs

**Data de Criação:** 11/11/2025  
**Status:** Planejamento (NÃO EXECUTAR)  
**Workspace:** imediatoseguros-rpa-playwright

---

## 📋 OBJETIVO

1. Implementar solução Data Attributes para eliminar polling e carregamento assíncrono
2. Classificar todos os logs por natureza, contexto e importância
3. Implementar sistema de controle granular via `DEBUG_CONFIG` (nível, categoria, contexto, verbosidade)
4. **NÃO eliminar logs** - apenas controlar quando são exibidos via classificação
5. **Garantir que modificações não interfiram em funcionalidades** - estratégia completa de validação e testes implementada

---

## 🎯 PARTE 1: IMPLEMENTAÇÃO DATA ATTRIBUTES

### 1.1. Objetivo
Eliminar polling de 3 segundos e carregamento assíncrono de `config_env.js.php`, substituindo por leitura direta de data attributes do script tag.

### 1.2. Arquivos a Modificar

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Modificações:**
- **Remover:** Função `detectServerBaseUrl()` (linhas ~89-124)
- **Remover:** Código de carregamento dinâmico de `config_env.js.php` (linhas ~104-126)
- **Remover:** Polling de 3 segundos em `sendLogToProfessionalSystem()` (linhas ~370-389)
- **Remover:** Funções `waitForAppEnv()` em `loadRPAScript()` e `loadWhatsAppModal()` (linhas ~1514-1520, ~1593-1601)
- **Adicionar:** Código para ler data attributes do script tag (~30 linhas)

**Código a Adicionar:**
```javascript
// ======================
// CARREGAMENTO DE VARIÁVEIS DE AMBIENTE (DATA ATTRIBUTES)
// ======================
const currentScript = document.currentScript;
if (currentScript && currentScript.dataset) {
  window.APP_BASE_URL = currentScript.dataset.appBaseUrl || null;
  window.APP_ENVIRONMENT = currentScript.dataset.appEnvironment || 'development';
} else {
  // Fallback: buscar em todos os scripts
  const scripts = document.getElementsByTagName('script');
  for (let script of scripts) {
    if (script.src && script.src.includes('bssegurosimediato.com.br') && script.dataset && script.dataset.appBaseUrl) {
      window.APP_BASE_URL = script.dataset.appBaseUrl;
      window.APP_ENVIRONMENT = script.dataset.appEnvironment || 'development';
      break;
    }
  }
}

if (!window.APP_BASE_URL) {
  console.error('[CONFIG] ERRO CRÍTICO: data-app-base-url não está definido no script tag');
  throw new Error('APP_BASE_URL não está definido - verifique data-app-base-url no script tag');
}
```

### 1.3. Modificação no Webflow Footer Code

**Arquivo:** Webflow Dashboard → Site Settings → Custom Code → Footer Code

**Modificação:**
```html
<!-- ANTES -->
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" defer></script>

<!-- DEPOIS -->
<script 
  src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://dev.bssegurosimediato.com.br"
  data-app-environment="development">
</script>
```

### 1.4. Resultado Esperado
- ✅ Eliminação completa do polling de 3 segundos
- ✅ Eliminação de requisição HTTP adicional para `config_env.js.php`
- ✅ Variáveis disponíveis imediatamente (zero latência)
- ✅ Código mais simples (-105 linhas complexas, +30 linhas simples)

---

## 🎯 PARTE 2: CLASSIFICAÇÃO E CONTROLE DE LOGS

### 2.1. Objetivo
Classificar todos os logs por natureza, contexto e importância, permitindo controle granular via `DEBUG_CONFIG` sem eliminar logs, apenas controlando quando são exibidos.

### 2.2. Sistema de Classificação Proposto

**📋 Níveis de Severidade:**
- **CRITICAL:** Erros críticos que impedem funcionamento (sempre exibir) - 2 logs
- **ERROR:** Erros que afetam funcionalidade (exibir em produção) - ~35 logs
- **WARN:** Avisos importantes (exibir em produção) - ~25 logs
- **INFO:** Informações úteis (exibir apenas em dev) - ~20 logs
- **DEBUG:** Debug detalhado (exibir apenas em debug profundo) - ~50 logs
- **TRACE:** Rastreamento extremamente detalhado (exibir apenas em troubleshooting) - ~60 logs

**📋 Contextos:**
- **INIT:** Inicialização/configuração
- **OPERATION:** Operação normal do sistema
- **ERROR_HANDLING:** Tratamento de erros
- **PERFORMANCE:** Métricas de performance
- **DATA_FLOW:** Fluxo de dados
- **UI:** Interface do usuário

**📋 Categorias Especiais:**
- `EMAIL_DEBUG` - Logs de debug de email
- `JSON_DEBUG` - Logs de debug de JSON
- `UI_TRACE` - Logs de rastreamento de UI
- `PROGRESS_TRACE` - Logs de rastreamento de progresso
- `DATA_TRACE` - Logs de rastreamento de dados
- `POLLING_TRACE` - Logs de rastreamento de polling

**📋 Verbosidade:**
- **SIMPLE:** Mensagem simples (1 linha)
- **MEDIUM:** Mensagem com dados básicos (2-5 linhas)
- **VERBOSE:** Mensagem com objetos grandes (5+ linhas)

**📄 Documento Completo:** Ver `CLASSIFICACAO_DETALHADA_LOGS.md` para classificação linha por linha de todos os ~192 logs.

### 2.3. Análise Completa: Logs que NÃO Respeitam DEBUG_CONFIG

**📊 RESUMO DA ANÁLISE:**
- ✅ **Logs que RESPEITAM:** ~150 ocorrências (via `window.logUnified()` e aliases)
- ❌ **Logs que NÃO RESPEITAM:** ~260 ocorrências (chamadas diretas `console.*`)
- **Percentual:** Apenas ~37% dos logs respeitam `DEBUG_CONFIG`

**Impacto Crítico:**
- Mesmo com `DEBUG_CONFIG.enabled = false`, ~260 logs ainda serão exibidos
- Mesmo com `DEBUG_CONFIG.level = 'error'`, logs de debug/info ainda serão exibidos
- Performance degradada por logs desnecessários em produção

### 2.4. Arquivos a Revisar

#### 2.3.1. FooterCodeSiteDefinitivoCompleto.js

**Total de logs que NÃO respeitam:** ~30 ocorrências

**Problemas identificados:**

1. **Logs de Configuração (Linhas ~122, ~133, ~144, ~148)** - 4 ocorrências
   ```javascript
   console.error('[CONFIG] Não foi possível detectar URL base do servidor');
   console.error('[CONFIG] Erro crítico: Não foi possível detectar URL base do servidor');
   console.log('[CONFIG] config_env.js.php carregado com sucesso. APP_BASE_URL:', window.APP_BASE_URL);
   console.error('[CONFIG] Erro crítico: Não foi possível carregar config_env.js.php');
   ```
   **Ação:** Manter apenas erros críticos, remover logs de sucesso

2. **Logs de Debug Temporário (Linhas ~584-588)** - 5 ocorrências
   ```javascript
   console.log('[DEBUG-TEMP] window.DEBUG_CONFIG existe?', !!window.DEBUG_CONFIG);
   console.log('[DEBUG-TEMP] window.DEBUG_CONFIG:', window.DEBUG_CONFIG);
   console.log('[DEBUG-TEMP] enabled value:', window.DEBUG_CONFIG?.enabled);
   console.log('[DEBUG-TEMP] enabled === false?', window.DEBUG_CONFIG?.enabled === false);
   console.log('[DEBUG-TEMP] enabled type:', typeof window.DEBUG_CONFIG?.enabled);
   ```
   **Ação:** ❌ **REMOVER COMPLETAMENTE** - Debug temporário que não deve estar em produção

3. **Logs Verbosos em `sendLogToProfessionalSystem()` (Linhas ~361, ~366, ~384, ~400, ~455-550)** - ~21 ocorrências
   - `console.warn('[LOG] sendLogToProfessionalSystem chamado sem level válido')` - Linha ~361
   - `console.warn('[LOG] sendLogToProfessionalSystem chamado sem message válido')` - Linha ~366
   - `console.warn('[LOG] APP_BASE_URL não disponível após aguardar. Log não enviado.')` - Linha ~384
   - `console.warn('[LOG] Level inválido:', level, '- usando INFO como fallback')` - Linha ~400
   - `console.group()` e `console.groupEnd()` - Linhas ~455, ~529, ~545
   - `console.log('📋 Payload:', {...})` - Linha ~456
   - `console.log('📦 Payload completo:', logData)` - Linha ~467 (objeto completo - MUITO VERBOSO)
   - `console.log('🔗 Endpoint:', endpoint)` - Linha ~468
   - `console.log('⏰ Timestamp:', new Date().toISOString())` - Linha ~469
   - `console.log('[LOG] 📥 Resposta recebida...')` - Linha ~483 (objeto grande)
   - `console.error('[LOG] ❌ Erro HTTP na resposta:', {...})` - Linha ~501 (objeto grande)
   - `console.error('[LOG] ❌ Detalhes completos do erro:', errorData)` - Linha ~509 (VERBOSO)
   - `console.error('[LOG] ❌ Debug info do servidor:', errorData.debug)` - Linha ~513
   - `console.log('[LOG] ✅ Sucesso...')` com `full_response` - Linha ~522 (objeto grande)
   - `console.debug('[LOG] Enviado: ${result.log_id}')` - Linha ~533 (verifica DEBUG_CONFIG mas dentro de grupo)
   - `console.error('[LOG] ❌ Erro ao enviar log...')` com stack trace completo - Linha ~537 (MUITO VERBOSO)
   - `console.error('[LOG] Erro ao enviar log:', error)` - Linha ~550 (verifica DEBUG_CONFIG mas dentro de grupo)
   
   **Ação:** 
   - ❌ Remover `console.group()` e `console.groupEnd()`
   - ❌ Remover logs verbosos com objetos grandes
   - ❌ Remover stack traces completos
   - ✅ Manter apenas logs de erro crítico (mensagem simples, sem objetos)

4. **Logs em logDebug() local (Linhas ~1504, ~1509, ~1517, ~1540)** - 4 ocorrências
   ```javascript
   console.warn('[LOG] logDebug chamado sem level válido:', level);
   console.warn('[LOG] logDebug chamado sem message válido:', message);
   console.warn('[LOG] logDebug chamado com level inválido:', level, '- usando INFO como fallback');
   console.log(`[${level}] ${message}`, data); // ⚠️ Verifica DEBUG_CONFIG mas é função local
   ```
   **Ação:** Substituir por `window.logUnified()` ou remover se não essenciais

**Modificações:**
- **Remover:** `console.group()` e `console.groupEnd()`
- **Remover:** `console.log('📦 Payload completo:', logData)`
- **Remover:** `console.log('[LOG] ✅ Sucesso...')` com `full_response`
- **Simplificar:** `console.error('[LOG] ❌ Erro...')` - remover stack trace completo, manter apenas mensagem
- **Remover:** Logs de debug temporário (linhas ~582-589)
- **Substituir:** Todos os `console.*` diretos por `window.logUnified()` que respeita `DEBUG_CONFIG`
- **Reduzir:** Logs de sucesso - apenas log_id, sem objetos grandes
- **Reduzir:** Logs de erro - apenas mensagem e status, sem stack trace completo

**Código a Modificar em `sendLogToProfessionalSystem()`:**
```javascript
// ANTES (verboso):
console.group(`[LOG] 📤 Enviando log para ${endpoint}`, requestId);
console.log('📋 Payload:', {...});
console.log('📦 Payload completo:', logData);
console.log('🔗 Endpoint:', endpoint);
console.log('⏰ Timestamp:', new Date().toISOString());
// ... múltiplos logs ...
console.groupEnd();

// DEPOIS (simplificado):
// Apenas log de erro se houver problema, sem grupos, sem objetos grandes
```

#### 2.3.2. MODAL_WHATSAPP_DEFINITIVO.js

**Total de logs que NÃO respeitam:** ~79 ocorrências

**Problemas identificados:**
- ❌ **100% dos logs não respeitam `DEBUG_CONFIG`** - Todos são chamadas diretas `console.*`
- Logs de debug/info desnecessários (~50 ocorrências)
- Logs verbosos com objetos grandes (~10 ocorrências)
- Logs de sucesso detalhados (~15 ocorrências)

**Exemplos de logs problemáticos:**
- `console.log('✅ [ENV] Hardcode DEV: webflow.io detectado')` - Debug desnecessário
- `console.log('🔍 [DEBUG] Email generation:', {...})` - Debug temporário
- `console.log('🔍 [DEBUG JSON] Objeto webhook_data original:', webhook_data)` - MUITO VERBOSO
- `console.log('📧 [EMAIL-ENVIADO] Notificação...')` - Info desnecessário
- `console.log('✅ [MODAL] Lead criado no EspoCRM:', espocrmResult.id)` - Info desnecessário

**Modificações:**
- **Substituir:** Todos os `console.log()`, `console.error()`, `console.warn()` por `window.logUnified()` ou funções que respeitam `DEBUG_CONFIG`
- **Eliminar:** ~50 logs de debug/info desnecessários
- **Manter:** Apenas logs de warning, error e fatal (~29 logs essenciais)
- **Simplificar:** Remover objetos grandes dos logs restantes

#### 2.3.3. webflow_injection_limpo.js

**Total de logs que NÃO respeitam:** ~151 ocorrências

**Problemas identificados:**
- ❌ **100% dos logs não respeitam `DEBUG_CONFIG`** - Todos são chamadas diretas `console.*`
- Logs de debug/info desnecessários (~120 ocorrências)
- Logs verbosos com objetos grandes (~20 ocorrências)
- Logs de sucesso detalhados (~10 ocorrências)

**Exemplos de logs problemáticos:**
- `console.log('🔄 Inicializando SpinnerTimer...')` - Debug desnecessário
- `console.log('📊 Dados do progresso:', data)` - MUITO VERBOSO (objeto grande)
- `console.log('📊 Estrutura completa dos dados:', JSON.stringify(data, null, 2))` - EXTREMAMENTE VERBOSO
- `console.log('✅ Progress text atualizado:', progressText.textContent)` - Debug desnecessário
- `console.log('💰 Valor formatado:', value, '→', formatted)` - Debug desnecessário

**Modificações:**
- **Substituir:** Todos os `console.*` por funções que respeitam `DEBUG_CONFIG`
- **Eliminar:** ~120 logs de debug/info desnecessários
- **Manter:** Apenas logs de warning, error e fatal (~31 logs essenciais)
- **Simplificar:** Remover objetos grandes e JSON.stringify dos logs restantes

### 2.5. Mapeamento Detalhado por Arquivo

#### FooterCodeSiteDefinitivoCompleto.js
- **Logs que respeitam:** ~150 (via `window.logUnified()`)
- **Logs que NÃO respeitam:** ~30
  - Configuração: 4
  - Debug temporário: 5 (REMOVER)
  - sendLogToProfessionalSystem: ~21 (SIMPLIFICAR)
  - logDebug local: 4

#### MODAL_WHATSAPP_DEFINITIVO.js
- **Logs que respeitam:** 0
- **Logs que NÃO respeitam:** ~79
  - Debug/info desnecessários: ~50 (ELIMINAR)
  - Verbosos com objetos: ~10 (SIMPLIFICAR)
  - Sucesso detalhados: ~15 (SIMPLIFICAR)
  - Warning/error essenciais: ~29 (MANTER, mas usar `window.logUnified()`)

#### webflow_injection_limpo.js
- **Logs que respeitam:** 0
- **Logs que NÃO respeitam:** ~151
  - Debug/info desnecessários: ~120 (ELIMINAR)
  - Verbosos com objetos: ~20 (SIMPLIFICAR)
  - Sucesso detalhados: ~10 (SIMPLIFICAR)
  - Warning/error essenciais: ~31 (MANTER, mas usar `window.logUnified()`)

### 2.6. Sistema de Controle Proposto

**Função Wrapper para Logs Classificados:**
```javascript
function logClassified(level, category, message, data, context = 'OPERATION', verbosity = 'SIMPLE') {
  // 1. Verificar DEBUG_CONFIG.enabled
  if (window.DEBUG_CONFIG && 
      (window.DEBUG_CONFIG.enabled === false || window.DEBUG_CONFIG.enabled === 'false')) {
    // CRITICAL sempre exibe, mesmo se disabled
    if (level !== 'CRITICAL') return;
  }
  
  // 2. Verificar nível de severidade
  const levels = { 
    'none': 0, 
    'critical': 1,  // Sempre exibir
    'error': 2, 
    'warn': 3, 
    'info': 4, 
    'debug': 5, 
    'trace': 6, 
    'all': 7 
  };
  const currentLevel = levels[window.DEBUG_CONFIG?.level] || levels['info'];
  const messageLevel = levels[level.toLowerCase()] || levels['info'];
  if (messageLevel > currentLevel) return;
  
  // 3. Verificar exclusão de categoria
  if (window.DEBUG_CONFIG?.exclude && window.DEBUG_CONFIG.exclude.length > 0) {
    if (category && window.DEBUG_CONFIG.exclude.includes(category)) return;
  }
  
  // 4. Verificar exclusão de contexto
  if (window.DEBUG_CONFIG?.excludeContexts && window.DEBUG_CONFIG.excludeContexts.length > 0) {
    if (context && window.DEBUG_CONFIG.excludeContexts.includes(context)) return;
  }
  
  // 5. Verificar verbosidade máxima
  const verbosityLevels = { 'SIMPLE': 1, 'MEDIUM': 2, 'VERBOSE': 3 };
  const maxVerbosity = verbosityLevels[window.DEBUG_CONFIG?.maxVerbosity] || verbosityLevels['VERBOSE'];
  const messageVerbosity = verbosityLevels[verbosity] || verbosityLevels['SIMPLE'];
  if (messageVerbosity > maxVerbosity) return;
  
  // 6. Exibir log com método apropriado
  const formattedMessage = category ? `[${category}] ${message}` : message;
  switch(level) {
    case 'CRITICAL':
    case 'ERROR':
      console.error(formattedMessage, data || '');
      break;
    case 'WARN':
      console.warn(formattedMessage, data || '');
      break;
    case 'INFO':
    case 'DEBUG':
    case 'TRACE':
    default:
      console.log(formattedMessage, data || '');
      break;
  }
}
```

**Exemplo de Uso:**
```javascript
// Antes (não respeita DEBUG_CONFIG):
console.log('🔍 [DEBUG] Email generation:', { ddd, celular, email });

// Depois (respeita DEBUG_CONFIG):
logClassified('TRACE', 'EMAIL_DEBUG', 'Email generation', { ddd, celular, email }, 'DATA_FLOW', 'MEDIUM');
```

### 2.7. Regras de Classificação (NÃO Eliminação)

**Classificar e Controlar:**
- ✅ **CRITICAL:** Sempre exibir (2 logs) - Erros críticos de inicialização
- ✅ **ERROR:** Controlar via `DEBUG_CONFIG.level = 'error'` (~35 logs)
- ✅ **WARN:** Controlar via `DEBUG_CONFIG.level = 'warn'` (~25 logs)
- ✅ **INFO:** Controlar via `DEBUG_CONFIG.level = 'info'` (~20 logs)
- ✅ **DEBUG:** Controlar via `DEBUG_CONFIG.level = 'debug'` (~50 logs)
- ✅ **TRACE:** Controlar via `DEBUG_CONFIG.level = 'trace'` ou categoria específica (~60 logs)

**Categorias Especiais para Controle Fino:**
- `EMAIL_DEBUG` - Pode ser excluído via `DEBUG_CONFIG.exclude = ['EMAIL_DEBUG']`
- `JSON_DEBUG` - Pode ser excluído via `DEBUG_CONFIG.exclude = ['JSON_DEBUG']`
- `UI_TRACE` - Pode ser excluído via `DEBUG_CONFIG.exclude = ['UI_TRACE']`
- `PROGRESS_TRACE` - Pode ser excluído via `DEBUG_CONFIG.exclude = ['PROGRESS_TRACE']`
- `DATA_TRACE` - Pode ser excluído via `DEBUG_CONFIG.exclude = ['DATA_TRACE']`
- `POLLING_TRACE` - Pode ser excluído via `DEBUG_CONFIG.exclude = ['POLLING_TRACE']`

**Controle de Verbosidade:**
- `DEBUG_CONFIG.maxVerbosity = 'SIMPLE'` - Apenas logs simples
- `DEBUG_CONFIG.maxVerbosity = 'MEDIUM'` - Logs simples e médios
- `DEBUG_CONFIG.maxVerbosity = 'VERBOSE'` - Todos os logs (padrão)

**Controle de Contexto:**
- `DEBUG_CONFIG.excludeContexts = ['UI', 'PERFORMANCE']` - Excluir logs de UI e performance

### 2.8. Resultado Esperado

**Controle de Logs:**
- **Antes:** ~410 logs totais (~260 não respeitam `DEBUG_CONFIG`)
- **Depois:** ~410 logs totais (todos respeitam `DEBUG_CONFIG` via classificação)
- **Redução:** 0 logs eliminados (todos mantidos, apenas controlados)

**Respeito a DEBUG_CONFIG:**
- **Antes:** ~37% respeitam (`DEBUG_CONFIG.enabled = false` ainda exibe ~260 logs)
- **Depois:** 100% respeitam (`DEBUG_CONFIG.enabled = false` bloqueia TODOS os logs, exceto CRITICAL)

**Controle Granular:**
- `DEBUG_CONFIG.level = 'error'` → Exibe apenas CRITICAL + ERROR (~37 logs)
- `DEBUG_CONFIG.level = 'warn'` → Exibe CRITICAL + ERROR + WARN (~62 logs)
- `DEBUG_CONFIG.level = 'info'` → Exibe CRITICAL + ERROR + WARN + INFO (~82 logs)
- `DEBUG_CONFIG.level = 'debug'` → Exibe até DEBUG (~132 logs)
- `DEBUG_CONFIG.level = 'trace'` → Exibe todos os logs (~192 logs)
- `DEBUG_CONFIG.exclude = ['EMAIL_DEBUG', 'JSON_DEBUG']` → Exclui categorias específicas
- `DEBUG_CONFIG.maxVerbosity = 'SIMPLE'` → Exibe apenas logs simples

**Performance:**
- ✅ Console do navegador controlável (0 logs quando `DEBUG_CONFIG.enabled = false`, exceto CRITICAL)
- ✅ Controle granular por nível (error, warn, info, debug, trace)
- ✅ Controle por categoria (excluir EMAIL_DEBUG, JSON_DEBUG, etc.)
- ✅ Controle por contexto (excluir UI, PERFORMANCE, etc.)
- ✅ Controle por verbosidade (SIMPLE, MEDIUM, VERBOSE)
- ✅ Performance otimizada (zero overhead quando `DEBUG_CONFIG.enabled = false`)
- ✅ Todos os logs respeitam `DEBUG_CONFIG` (100%)

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### Fase 1: Preparação e Baseline

#### 1.1. Backup
- [ ] Criar backup de `FooterCodeSiteDefinitivoCompleto.js` ANTES de modificar
- [ ] Criar backup de `MODAL_WHATSAPP_DEFINITIVO.js` ANTES de modificar
- [ ] Criar backup de `webflow_injection_limpo.js` ANTES de modificar
- [ ] Criar backup de todos os arquivos PHP que serão modificados

#### 1.2. Criar Baseline de Funcionalidades
- [ ] Executar testes unitários de todas as funcionalidades críticas
- [ ] Executar testes de integração end-to-end
- [ ] Documentar resultados em `BASELINE_RESULTADOS.md`
- [ ] Criar scripts de teste automatizados (`test_baseline_funcionalidades.html`, `test_baseline_endpoints.php`)
- [ ] Validar que todas as funcionalidades estão funcionando antes de modificar

### Fase 2: Implementação Data Attributes

#### 2.1. Modificações
- [ ] Remover função `detectServerBaseUrl()` de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Remover código de carregamento dinâmico de `config_env.js.php`
- [ ] Remover polling de 3 segundos em `sendLogToProfessionalSystem()`
- [ ] Remover funções `waitForAppEnv()` em `loadRPAScript()` e `loadWhatsAppModal()`
- [ ] Adicionar código para ler data attributes do script tag

#### 2.2. Validação Imediata
- [ ] Validar que `window.APP_BASE_URL` está disponível após carregamento
- [ ] Validar que `window.APP_ENVIRONMENT` está disponível após carregamento
- [ ] Validar que data attributes são lidos corretamente
- [ ] Validar que fallback funciona se data attributes não estiverem presentes
- [ ] Verificar console do navegador (sem erros)
- [ ] Executar testes específicos de carregamento de variáveis

### Fase 3: Classificação de Logs - FooterCodeSiteDefinitivoCompleto.js

#### 3.1. Modificações
- [ ] Remover logs de debug temporário (linhas ~584-588) - 5 logs (não devem estar em produção)
- [ ] Criar função `logClassified()` com sistema de classificação (versão otimizada)
- [ ] Substituir logs de configuração por `logClassified()` com nível apropriado:
  - Linha ~122: `logClassified('ERROR', 'CONFIG', 'Não foi possível detectar URL base do servidor', null, 'INIT', 'SIMPLE')`
  - Linha ~133: `logClassified('CRITICAL', 'CONFIG', 'Erro crítico: Não foi possível detectar URL base do servidor', null, 'INIT', 'SIMPLE')`
  - Linha ~144: `logClassified('INFO', 'CONFIG', 'config_env.js.php carregado com sucesso', { APP_BASE_URL: window.APP_BASE_URL }, 'INIT', 'MEDIUM')`
  - Linha ~148: `logClassified('CRITICAL', 'CONFIG', 'Erro crítico: Não foi possível carregar config_env.js.php', null, 'INIT', 'SIMPLE')`
- [ ] Substituir logs em `sendLogToProfessionalSystem()` por `logClassified()` com níveis apropriados:
  - Linhas ~361, ~366, ~384, ~400: `WARN` nível
  - Linhas ~455-469: `DEBUG` nível (grupos e payloads)
  - Linha ~467: `TRACE` nível (payload completo)
  - Linhas ~483, ~501, ~509, ~513: `DEBUG` nível (detalhes de resposta)
  - Linha ~522: `INFO` nível (sucesso)
  - Linhas ~537, ~550, ~559: `ERROR` nível (erros)
- [ ] Substituir logs em `logDebug()` local por `logClassified()` (linhas ~1504, ~1509, ~1517, ~1540)

#### 3.2. Validação Imediata
- [ ] Validar que `logClassified()` funciona corretamente
- [ ] Validar que todos os logs respeitam `DEBUG_CONFIG` via classificação
- [ ] Validar que `window.logUnified()` e aliases ainda funcionam
- [ ] Validar que `sendLogToProfessionalSystem()` ainda funciona
- [ ] Validar que funções de CPF, placa, celular ainda funcionam
- [ ] Validar que GCLID ainda funciona
- [ ] Verificar console do navegador (sem erros)
- [ ] Executar testes específicos do arquivo

### Fase 4: Classificação de Logs - MODAL_WHATSAPP_DEFINITIVO.js

#### 4.1. Modificações
- [ ] Identificar todos os ~79 `console.*` diretos
- [ ] Substituir todos por `logClassified()` com classificação apropriada:
  - Logs de ambiente (linhas ~113, ~121, ~126, ~133, ~139, ~143): `DEBUG` nível
  - Logs de erro (linha ~155): `ERROR` nível
  - Logs de evento (linha ~232): `INFO/DEBUG` nível baseado em `severity`
  - Logs de estado (linha ~359): `DEBUG` nível
  - Logs de retry (linhas ~445, ~455): `WARN` nível
  - Logs de WhatsApp (linha ~496): `INFO` nível
  - Logs de debug de email (linhas ~512, ~521, ~531): `TRACE` nível, categoria `EMAIL_DEBUG`
  - Logs de envio de email (linhas ~619, ~672, ~703, ~709, ~730, ~738, ~749, ~751, ~757): `ERROR/INFO` nível apropriado
  - Logs de webhook data (linhas ~815, ~819, ~858-862, ~867, ~869): `TRACE` nível, categoria `JSON_DEBUG`
  - Logs de erro não bloqueante (linhas ~937, ~942, ~954, etc.): `WARN` nível
  - Logs de integração (linha ~1376): `ERROR` nível
  - Logs de Google Ads (linhas ~1480, ~1502): `WARN/INFO` nível
  - Logs de UI (linha ~1825): `DEBUG` nível
  - Logs de operação (linhas ~1913, ~1949, ~1970, etc.): `INFO` nível

#### 4.2. Validação Imediata
- [ ] Validar que modal abre e fecha corretamente
- [ ] Validar que validações de formulário funcionam
- [ ] Validar que `registrarPrimeiroContatoEspoCRM()` funciona
- [ ] Validar que `sendAdminEmailNotification()` funciona
- [ ] Validar que `enviarMensagemOctadesk()` funciona
- [ ] Validar que `registrarConversaoGoogleAds()` funciona
- [ ] Validar que todos os logs respeitam `DEBUG_CONFIG` via classificação
- [ ] Verificar console do navegador (sem erros)
- [ ] Executar testes específicos do arquivo

### Fase 5: Classificação de Logs - webflow_injection_limpo.js ✅

#### 5.1. Modificações ✅
- [x] Identificar todos os ~151 `console.*` diretos
- [x] Substituir todos por `logClassified()` com classificação apropriada:
  - [x] Logs de SpinnerTimer: `DEBUG/TRACE` nível, contexto `UI`, categoria `UI_TRACE`
  - [x] Logs de ProgressModalRPA: `DEBUG/ERROR` nível apropriado
  - [x] Logs de dados de progresso: `TRACE` nível, categoria `PROGRESS_TRACE`
  - [x] Logs de atualização de UI: `TRACE` nível, categoria `UI_TRACE`
  - [x] Logs de estimativas e resultados: `DEBUG/INFO/WARN` nível apropriado
  - [x] Logs de atualização de valores: `TRACE` nível, categoria `DATA_TRACE`
  - [x] Logs de validação: `ERROR/DEBUG` nível apropriado
  - [x] Logs de MainPage: `DEBUG/INFO/ERROR` nível apropriado
  - [x] Logs de FormValidator: `TRACE/ERROR/WARN` nível apropriado
  - [x] Logs de inicialização: `DEBUG/INFO` nível, contexto `INIT`

#### 5.2. Validação Imediata ⏳
- [ ] Validar que SpinnerTimer funciona corretamente
- [ ] Validar que ProgressModalRPA funciona corretamente
- [ ] Validar que polling de progresso funciona
- [ ] Validar que UI é atualizada corretamente
- [ ] Validar que `validatePlaca()` funciona corretamente
- [x] Validar que todos os logs respeitam `DEBUG_CONFIG` via classificação
- [x] Verificar console do navegador (sem erros de sintaxe)
- [ ] Executar testes específicos do arquivo

**Status:** ✅ **LOGS CLASSIFICADOS** - 144 logs ativos substituídos (7 logs restantes estão em código comentado/não executado)

### Fase 6: Validação de Funcionalidades

#### 6.1. Criar Baseline (ANTES das Modificações)
- [ ] Executar testes unitários de todas as funcionalidades críticas
- [ ] Executar testes de integração end-to-end
- [ ] Documentar resultados em `BASELINE_RESULTADOS.md`
- [ ] Criar scripts de teste automatizados
- [ ] Validar que todas as funcionalidades estão funcionando

#### 6.2. Validação Durante Modificações (Incremental)
- [ ] Para cada arquivo modificado, executar testes específicos
- [ ] Validar funcionalidades críticas do arquivo modificado
- [ ] Verificar console do navegador (sem erros)
- [ ] Verificar logs do servidor (sem erros)
- [ ] Documentar resultados de cada modificação

#### 6.3. Testes de Sistema de Logs
- [ ] Testar carregamento de variáveis via data attributes
- [ ] Testar que logs não aparecem quando `DEBUG_CONFIG.enabled === false` (deve bloquear TODOS os logs, exceto CRITICAL)
- [ ] Testar que apenas CRITICAL + ERROR aparecem quando `DEBUG_CONFIG.level = 'error'` (~37 logs)
- [ ] Testar que CRITICAL + ERROR + WARN aparecem quando `DEBUG_CONFIG.level = 'warn'` (~62 logs)
- [ ] Testar que até INFO aparecem quando `DEBUG_CONFIG.level = 'info'` (~82 logs)
- [ ] Testar que até DEBUG aparecem quando `DEBUG_CONFIG.level = 'debug'` (~132 logs)
- [ ] Testar que todos aparecem quando `DEBUG_CONFIG.level = 'trace'` (~192 logs)
- [ ] Testar exclusão de categorias: `DEBUG_CONFIG.exclude = ['EMAIL_DEBUG', 'JSON_DEBUG']`
- [ ] Testar exclusão de contextos: `DEBUG_CONFIG.excludeContexts = ['UI', 'PERFORMANCE']`
- [ ] Testar controle de verbosidade: `DEBUG_CONFIG.maxVerbosity = 'SIMPLE'`

#### 6.4. Testes de Funcionalidades Críticas
- [ ] **FooterCodeSiteDefinitivoCompleto.js:**
  - [ ] `window.APP_BASE_URL` disponível após carregamento
  - [ ] `window.logUnified()` e aliases funcionam
  - [ ] `loadRPAScript()` e `loadWhatsAppModal()` funcionam
  - [ ] `sendLogToProfessionalSystem()` envia logs corretamente
  - [ ] Funções de CPF, placa, celular funcionam
  - [ ] GCLID é capturado e salvo corretamente
- [ ] **MODAL_WHATSAPP_DEFINITIVO.js:**
  - [ ] Modal abre e fecha corretamente
  - [ ] Validações de formulário funcionam
  - [ ] `registrarPrimeiroContatoEspoCRM()` cria lead corretamente
  - [ ] `sendAdminEmailNotification()` envia emails corretamente
  - [ ] `enviarMensagemOctadesk()` envia mensagens corretamente
  - [ ] `registrarConversaoGoogleAds()` registra conversões corretamente
- [ ] **webflow_injection_limpo.js:**
  - [ ] SpinnerTimer funciona corretamente
  - [ ] ProgressModalRPA funciona corretamente
  - [ ] Polling de progresso funciona
  - [ ] UI é atualizada corretamente
  - [ ] `validatePlaca()` funciona corretamente
- [ ] **Arquivos PHP:**
  - [ ] `add_flyingdonkeys.php` recebe webhook e cria lead corretamente
  - [ ] `add_webflow_octa.php` recebe webhook e envia mensagem corretamente
  - [ ] `cpf-validate.php` valida CPF corretamente
  - [ ] `send_email_notification_endpoint.php` envia emails corretamente
  - [ ] `log_endpoint.php` recebe e grava logs corretamente

#### 6.5. Testes de Integração End-to-End
- [ ] Modal WhatsApp abre e funciona completamente
- [ ] Formulário do modal valida e envia dados
- [ ] Lead é criado no EspoCRM
- [ ] Email é enviado corretamente
- [ ] Mensagem é enviada para OctaDesk
- [ ] Conversão é registrada no GTM
- [ ] RPA funciona completamente
- [ ] Logs são enviados corretamente

#### 6.6. Testes de Regressão
- [ ] Executar todos os testes do baseline novamente
- [ ] Comparar resultados com baseline
- [ ] Validar que diferenças são esperadas (logs controlados, etc.)
- [ ] Identificar e corrigir qualquer regressão

#### 6.7. Testes de Performance
- [ ] Testar performance (verificar que não há mais polling)
- [ ] Testar que modal carrega mais rápido
- [ ] Medir tempo de carregamento (não deve degradar)
- [ ] Verificar console do navegador (deve estar controlável via configuração)

**📄 Documento Completo:** Ver `ESTRATEGIA_VALIDACAO_FUNCIONALIDADES.md` para detalhes completos da estratégia de validação.

### Fase 7: Validação Final e Deploy

#### 7.1. Validação Final Completa
- [ ] Executar todos os testes unitários
- [ ] Executar todos os testes de integração
- [ ] Comparar resultados com baseline
- [ ] Validar que diferenças são esperadas (logs controlados)
- [ ] Validar que nenhuma funcionalidade foi quebrada
- [ ] Verificar console do navegador (sem erros)
- [ ] Verificar logs do servidor (sem erros)
- [ ] Validar performance (não degradou)

#### 7.2. Deploy
- [ ] Copiar arquivos modificados para servidor
- [ ] Atualizar Webflow Footer Code com data attributes
- [ ] Testar em ambiente DEV
- [ ] Executar testes finais em DEV
- [ ] Verificar logs no console do navegador
- [ ] Verificar performance
- [ ] Validar que todas as funcionalidades funcionam em DEV

#### 7.3. Plano de Rollback (Se Necessário)
- [ ] Se funcionalidades forem quebradas, identificar problema
- [ ] Restaurar arquivo do backup imediatamente
- [ ] Validar que problema foi resolvido
- [ ] Documentar problema e correção
- [ ] Re-aplicar modificação após correção

---

## 📊 ESTIMATIVA DE IMPACTO

### Código
- **Linhas removidas:** ~105 linhas (código complexo de polling e detecção de URL)
- **Linhas adicionadas:** ~200-250 linhas (função `logClassified()` + substituições de logs por classificação)
- **Aumento líquido:** ~95-145 linhas (mas código mais simples e controlável)

### Logs
- **Logs classificados:** ~192 logs (todos mantidos, classificados por nível)
- **Logs CRITICAL:** 2 (sempre exibidos)
- **Logs ERROR:** ~35 (exibidos quando `level >= 'error'`)
- **Logs WARN:** ~25 (exibidos quando `level >= 'warn'`)
- **Logs INFO:** ~20 (exibidos quando `level >= 'info'`)
- **Logs DEBUG:** ~50 (exibidos quando `level >= 'debug'`)
- **Logs TRACE:** ~60 (exibidos quando `level >= 'trace'`)
- **Redução total:** 0 logs eliminados (todos mantidos, apenas controlados)

### Performance
- **Polling eliminado:** 100% (zero overhead)
- **Requisições HTTP reduzidas:** 1 requisição a menos (não precisa carregar `config_env.js.php`)
- **Console controlável:** 0 logs quando `DEBUG_CONFIG.enabled = false` (exceto CRITICAL)
- **Controle granular:** Por nível (error/warn/info/debug/trace), categoria, contexto e verbosidade
- **Respeito a DEBUG_CONFIG:** 100% (antes: ~37%)

### Manutenibilidade
- **Código mais simples:** fácil de entender e manter
- **Menos pontos de falha:** menos complexidade = menos bugs
- **Logs mais úteis:** apenas informações essenciais

---

## ⚠️ RISCOS E MITIGAÇÕES

### Risco 1: Data attributes não funcionarem em navegadores antigos
**Mitigação:** `document.currentScript` é suportado desde IE11. Fallback implementado para buscar em todos os scripts.

### Risco 2: Classificação incorreta de logs
**Mitigação:** Todos os logs são mantidos, apenas classificados. Se classificação estiver incorreta, pode ser ajustada sem perder informações. Logs podem ser reativados via `DEBUG_CONFIG.level` apropriado.

### Risco 3: Webflow Footer Code não ser atualizado
**Mitigação:** Documentar claramente a necessidade de atualizar o Footer Code. Criar instruções passo a passo.

### Risco 4: Modificações quebram funcionalidades existentes
**Mitigação:** 
- Estratégia completa de validação implementada (ver `ESTRATEGIA_VALIDACAO_FUNCIONALIDADES.md`)
- Baseline criado antes das modificações
- Testes incrementais após cada modificação
- Testes de regressão após todas as modificações
- Plano de rollback disponível
- Validação de funcionalidades críticas em cada fase

---

## 📋 PRÓXIMOS PASSOS

1. ✅ Projeto criado e documentado
2. ✅ Classificação detalhada de todos os logs realizada (`CLASSIFICACAO_DETALHADA_LOGS.md`)
3. ✅ Sistema de classificação proposto (`logClassified()`)
4. ✅ Estratégia de validação de funcionalidades criada (`ESTRATEGIA_VALIDACAO_FUNCIONALIDADES.md`)
5. ⏳ Aguardando autorização para executar
6. ⏳ Executar Fase 1 (Preparação e Baseline)
7. ⏳ Executar Fase 2 (Data Attributes) + Validação
8. ⏳ Executar Fase 3-5 (Classificação de Logs) + Validação Incremental
9. ⏳ Executar Fase 6 (Validação Completa)
10. ⏳ Executar Fase 7 (Validação Final e Deploy)

---

**Status:** ✅ **PROJETO CRIADO - AGUARDANDO AUTORIZAÇÃO PARA EXECUTAR**

