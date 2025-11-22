# 📋 Lista Completa: Chamadas de `console.` em `.js` e `.php`

**Data:** 17/11/2025  
**Status:** ✅ **LISTA COMPLETA**  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Listar **TODOS** os pontos onde `console.` é chamado em todos os arquivos `.js` e `.php` do projeto.

---

## 📊 RESUMO GERAL

### **Total de Chamadas:**

| Tipo | Arquivo | Quantidade |
|------|---------|------------|
| **JavaScript** | `FooterCodeSiteDefinitivoCompleto.js` | **26 chamadas** (24 diretas + 2 interceptações) |
| **JavaScript** | `webflow_injection_limpo.js` | **3 chamadas** |
| **JavaScript** | `MODAL_WHATSAPP_DEFINITIVO.js` | **4 chamadas** |
| **PHP** | Todos os arquivos | **0 chamadas diretas** |
| **PHP** | `config_env.js.php` | **Código JS gerado** (não conta como PHP) |
| **TOTAL** | - | **33 chamadas** (31 diretas + 2 interceptações) |

---

## 📁 ARQUIVOS JAVASCRIPT (.js)

### **1. `FooterCodeSiteDefinitivoCompleto.js`**

**Total:** **26 chamadas** (24 chamadas diretas + 2 interceptações)

#### **Chamadas dentro de `sendLogToProfessionalSystem()` (19 chamadas):**

| Linha | Método | Código | Contexto |
|-------|--------|--------|----------|
| **553** | `console.warn` | `console.warn('[LOG] sendLogToProfessionalSystem chamado sem level válido');` | Validação de parâmetros |
| **559** | `console.warn` | `console.warn('[LOG] sendLogToProfessionalSystem chamado sem message válido');` | Validação de parâmetros |
| **566** | `console.error` | `console.error('[LOG] CRITICAL: APP_BASE_URL não está disponível');` | Validação crítica |
| **567** | `console.error` | `console.error('[LOG] CRITICAL: Verifique se data-app-base-url está definido...');` | Validação crítica |
| **581** | `console.warn` | `console.warn('[LOG] Level inválido: ' + level + ' - usando INFO como fallback', {...});` | Validação de nível |
| **636** | `console.log` | `console.log('[LOG] Enviando log para', endpoint, { requestId: requestId });` | Debug interno |
| **637** | `console.log` | `console.log('[LOG] Payload', {...});` | Debug interno |
| **648** | `console.log` | `console.log('[LOG] Payload completo', logData);` | Debug interno |
| **649** | `console.log` | `console.log('[LOG] Endpoint', { endpoint: endpoint });` | Debug interno |
| **650** | `console.log` | `console.log('[LOG] Timestamp', { timestamp: new Date().toISOString() });` | Debug interno |
| **665** | `console.log` | `console.log('[LOG] Resposta recebida (' + Math.round(fetchDuration) + 'ms)', {...});` | Debug interno |
| **683** | `console.error` | `console.error('[LOG] Erro HTTP na resposta', {...});` | Tratamento de erro |
| **691** | `console.log` | `console.log('[LOG] Detalhes completos do erro', errorData);` | Debug interno |
| **695** | `console.log` | `console.log('[LOG] Debug info do servidor', errorData.debug);` | Debug interno |
| **705** | `console.log` | `console.log('[LOG] Sucesso (' + Math.round(fetchDuration) + 'ms)', {...});` | Debug interno |
| **714** | `console.log` | `console.log('[LOG] Enviado', { log_id: result.log_id });` | Debug interno |
| **719** | `console.error` | `console.error('[LOG] Erro ao enviar log (' + Math.round(fetchDuration) + 'ms)', {...});` | Tratamento de erro |
| **729** | `console.error` | `console.error('[LOG] Erro ao enviar log', error);` | Tratamento de erro |
| **735** | `console.error` | `console.error('[LOG] Erro ao enviar log', error);` | Tratamento de erro (catch) |

**Categoria:** ✅ **Logs Internos Legítimos** (dentro de `sendLogToProfessionalSystem()`)

---

#### **Chamadas dentro de `novo_log()` (4 chamadas):**

| Linha | Método | Código | Contexto |
|-------|--------|--------|----------|
| **808** | `console.error` | `console.error(formattedMessage, data || '');` | Log de nível CRITICAL/ERROR/FATAL |
| **812** | `console.warn` | `console.warn(formattedMessage, data || '');` | Log de nível WARN/WARNING |
| **818** | `console.log` | `console.log(formattedMessage, data || '');` | Log de nível INFO/DEBUG/TRACE |
| **835** | `console.error` | `console.error('[LOG] Erro em novo_log():', error);` | Tratamento de erro crítico (catch) |

**Categoria:** ✅ **Logs Internos Legítimos** (dentro de `novo_log()`)

---

#### **Chamada fora de funções de logging (1 chamada):**

| Linha | Método | Código | Contexto |
|-------|--------|--------|----------|
| **274** | `console.log` | `console.log('[LOG_CONFIG] Configuração de logging carregada:', window.LOG_CONFIG);` | Log de configuração (apenas em dev) |

**Categoria:** ⚠️ **Log de Configuração** (deveria usar `novo_log()`?)

**Observação:** Esta chamada está dentro de um bloco condicional que só executa em ambiente `dev`:
```javascript
if (detectedEnvironment === 'dev' && window.console && window.console.log) {
  console.log('[LOG_CONFIG] Configuração de logging carregada:', window.LOG_CONFIG);
}
```

---

### **2. `webflow_injection_limpo.js`**

**Total:** **3 chamadas**

| Linha | Método | Código | Contexto |
|-------|--------|--------|----------|
| **3218** | `console.log` | `console.log('🔗 Executando webhooks...');` | Log de operação RPA |
| **3229** | `console.log` | `console.log('✅ Todos os webhooks executados com sucesso');` | Log de sucesso RPA |
| **3232** | `console.warn` | `console.warn('⚠️ Erro ao executar webhooks:', error);` | Log de erro RPA |

**Categoria:** ⚠️ **Logs Externos** (deveriam usar `novo_log()`?)

**Observação:** Estas chamadas estão fora de funções de logging e deveriam ser substituídas por `novo_log()`.

---

### **3. `MODAL_WHATSAPP_DEFINITIVO.js`**

**Total:** **4 chamadas**

| Linha | Método | Código | Contexto |
|-------|--------|--------|----------|
| **334** | `console.error` | `console.error(logMessage, ...additionalData);` | Fallback quando `novo_log()` não disponível |
| **337** | `console.warn` | `console.warn(logMessage, ...additionalData);` | Fallback quando `novo_log()` não disponível |
| **340** | `console.debug` | `console.debug(logMessage, ...additionalData);` | Fallback quando `novo_log()` não disponível |
| **343** | `console.log` | `console.log(logMessage, ...additionalData);` | Fallback quando `novo_log()` não disponível |

**Categoria:** ✅ **Fallback Legítimo** (quando `novo_log()` não está disponível)

**Código Relevante:**
```javascript
// Tentar usar novo_log() se disponível
if (typeof window.novo_log === 'function') {
  window.novo_log(level, 'MODAL', logMessage, additionalData);
} else {
  // Fallback para console se novo_log() não estiver disponível
  switch(level) {
    case 'ERROR': console.error(logMessage, ...additionalData); break;
    case 'WARN': console.warn(logMessage, ...additionalData); break;
    case 'DEBUG': console.debug(logMessage, ...additionalData); break;
    default: console.log(logMessage, ...additionalData); break;
  }
}
```

---

## 📁 ARQUIVOS PHP (.php)

### **Resultado:**

**Total:** **0 chamadas diretas**

**Observação:** PHP não possui `console.` (é uma API do JavaScript/browser). PHP usa `error_log()` para logging.

### **Arquivo Especial: `config_env.js.php`**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config_env.js.php`

**Observação:** Este arquivo PHP **gera código JavaScript** que contém chamadas `console.`, mas o próprio PHP não chama `console.` diretamente.

**Código Gerado (JavaScript):**
- Linha 24: `echo "console.error('[CONFIG] ERRO CRÍTICO: APP_BASE_URL não está definido...');";`
- Linhas 40-41: Código JavaScript gerado que pode conter `console.warn()`

**Status:** ⚠️ **Código JavaScript gerado** - Não conta como chamada PHP direta

---

## 📊 RESUMO POR CATEGORIA

### **Logs Internos Legítimos (23 chamadas diretas):**

| Arquivo | Quantidade | Contexto |
|---------|------------|----------|
| `FooterCodeSiteDefinitivoCompleto.js` | 19 | Dentro de `sendLogToProfessionalSystem()` |
| `FooterCodeSiteDefinitivoCompleto.js` | 4 | Dentro de `novo_log()` |
| **TOTAL** | **23** | - |

### **Interceptações de Debug (2 chamadas):**

| Arquivo | Quantidade | Contexto |
|---------|------------|----------|
| `FooterCodeSiteDefinitivoCompleto.js` | 2 | Interceptação de `console.error` para debug |
| **TOTAL** | **2** | - |

**Status:** ✅ **MANTIDAS** - São logs internos necessários para evitar loops infinitos

---

### **Logs Externos (4 chamadas):**

| Arquivo | Linha | Método | Contexto |
|---------|-------|--------|----------|
| `FooterCodeSiteDefinitivoCompleto.js` | 274 | `console.log` | Log de configuração (dev) |
| `webflow_injection_limpo.js` | 3218 | `console.log` | Log de operação RPA |
| `webflow_injection_limpo.js` | 3229 | `console.log` | Log de sucesso RPA |
| `webflow_injection_limpo.js` | 3232 | `console.warn` | Log de erro RPA |

**Status:** ⚠️ **DEVERIAM SER SUBSTITUÍDAS** por `novo_log()` para garantir inserção no banco

---

### **Fallback Legítimo (4 chamadas):**

| Arquivo | Linhas | Método | Contexto |
|---------|--------|--------|----------|
| `MODAL_WHATSAPP_DEFINITIVO.js` | 334, 337, 340, 343 | `console.error/warn/debug/log` | Fallback quando `novo_log()` não disponível |

**Status:** ✅ **MANTIDAS** - São fallbacks legítimos quando `novo_log()` não está disponível

---

## 📋 LISTA DETALHADA POR ARQUIVO

### **`FooterCodeSiteDefinitivoCompleto.js` - 26 Chamadas** (24 diretas + 2 interceptações)

#### **Dentro de `sendLogToProfessionalSystem()` (19 chamadas):**

1. **Linha 553:** `console.warn('[LOG] sendLogToProfessionalSystem chamado sem level válido');`
2. **Linha 559:** `console.warn('[LOG] sendLogToProfessionalSystem chamado sem message válido');`
3. **Linha 566:** `console.error('[LOG] CRITICAL: APP_BASE_URL não está disponível');`
4. **Linha 567:** `console.error('[LOG] CRITICAL: Verifique se data-app-base-url está definido...');`
5. **Linha 581:** `console.warn('[LOG] Level inválido: ' + level + ' - usando INFO como fallback', {...});`
6. **Linha 636:** `console.log('[LOG] Enviando log para', endpoint, { requestId: requestId });`
7. **Linha 637:** `console.log('[LOG] Payload', {...});`
8. **Linha 648:** `console.log('[LOG] Payload completo', logData);`
9. **Linha 649:** `console.log('[LOG] Endpoint', { endpoint: endpoint });`
10. **Linha 650:** `console.log('[LOG] Timestamp', { timestamp: new Date().toISOString() });`
11. **Linha 665:** `console.log('[LOG] Resposta recebida (' + Math.round(fetchDuration) + 'ms)', {...});`
12. **Linha 683:** `console.error('[LOG] Erro HTTP na resposta', {...});`
13. **Linha 691:** `console.log('[LOG] Detalhes completos do erro', errorData);`
14. **Linha 695:** `console.log('[LOG] Debug info do servidor', errorData.debug);`
15. **Linha 705:** `console.log('[LOG] Sucesso (' + Math.round(fetchDuration) + 'ms)', {...});`
16. **Linha 714:** `console.log('[LOG] Enviado', { log_id: result.log_id });`
17. **Linha 719:** `console.error('[LOG] Erro ao enviar log (' + Math.round(fetchDuration) + 'ms)', {...});`
18. **Linha 729:** `console.error('[LOG] Erro ao enviar log', error);`
19. **Linha 735:** `console.error('[LOG] Erro ao enviar log', error);`

#### **Dentro de `novo_log()` (4 chamadas):**

20. **Linha 808:** `console.error(formattedMessage, data || '');` (CRITICAL/ERROR/FATAL)
21. **Linha 812:** `console.warn(formattedMessage, data || '');` (WARN/WARNING)
22. **Linha 818:** `console.log(formattedMessage, data || '');` (INFO/DEBUG/TRACE)
23. **Linha 835:** `console.error('[LOG] Erro em novo_log():', error);` (catch)

#### **Fora de funções de logging (1 chamada):**

24. **Linha 274:** `console.log('[LOG_CONFIG] Configuração de logging carregada:', window.LOG_CONFIG);`

#### **Interceptações de `console.error` (2 chamadas - código de debug):**

25. **Linha 3001:** `const originalError = console.error;` (salvando referência original)
26. **Linha 3003:** `console.error = function(...args) { ... }` (interceptando para debug)

---

### **`webflow_injection_limpo.js` - 3 Chamadas**

1. **Linha 3218:** `console.log('🔗 Executando webhooks...');`
2. **Linha 3229:** `console.log('✅ Todos os webhooks executados com sucesso');`
3. **Linha 3232:** `console.warn('⚠️ Erro ao executar webhooks:', error);`

---

### **`MODAL_WHATSAPP_DEFINITIVO.js` - 4 Chamadas**

1. **Linha 334:** `console.error(logMessage, ...additionalData);` (fallback)
2. **Linha 337:** `console.warn(logMessage, ...additionalData);` (fallback)
3. **Linha 340:** `console.debug(logMessage, ...additionalData);` (fallback)
4. **Linha 343:** `console.log(logMessage, ...additionalData);` (fallback)

---

## ✅ CONCLUSÃO

### **Resumo:**

- **Total de chamadas:** **33 chamadas** (31 diretas + 2 interceptações)
- **Logs internos legítimos:** **23 chamadas diretas** (mantidas)
- **Interceptações de debug:** **2 chamadas** (código de debug)
- **Logs externos:** **4 chamadas** (deveriam ser substituídas)
- **Fallback legítimo:** **4 chamadas** (mantidas)

### **Recomendações:**

1. ✅ **Manter** as 23 chamadas dentro de `sendLogToProfessionalSystem()` e `novo_log()` (logs internos)
2. ✅ **Manter** as 4 chamadas de fallback em `MODAL_WHATSAPP_DEFINITIVO.js` (fallback legítimo)
3. ⚠️ **Substituir** as 4 chamadas externas por `novo_log()`:
   - `FooterCodeSiteDefinitivoCompleto.js` linha 274 (log de configuração)
   - `webflow_injection_limpo.js` linhas 3218, 3229, 3232 (logs RPA)

---

**Lista concluída em:** 17/11/2025  
**Versão do documento:** 1.0.0

