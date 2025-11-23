# 📋 FASE 2: Análise do Fluxo de Execução até `init()`

**Data:** 23/11/2025  
**Fase:** FASE 2 do PROJETO_ANALISE_CAUSA_RAIZ_GCLID_PROD_20251123.md  
**Status:** ✅ **CONCLUÍDA**

---

## 🔍 MAPEAMENTO DO FLUXO DE EXECUÇÃO

### **Linha 87-90: Início do IIFE**
```javascript
(function() {
  'use strict';
  try {
```
- **Status:** ✅ Executa normalmente
- **Não bloqueia:** Apenas inicia escopo

### **Linha 98: `document.currentScript`**
```javascript
const currentScript = document.currentScript;
```
- **Status:** ✅ Executa normalmente
- **Possível problema:** `document.currentScript` pode ser `null` se script foi carregado dinamicamente
- **Fallback:** Linha 118-126 tem função `findScriptWithAttributes()` como fallback

### **Linha 128-132: Validação de `scriptElement`**
```javascript
const scriptElement = currentScript || findScriptWithAttributes();

if (!scriptElement || !scriptElement.dataset) {
  throw new Error('[CONFIG] ERRO CRÍTICO: Script tag não encontrado ou sem data attributes');
}
```
- **Status:** ⚠️ **PONTO CRÍTICO**
- **Se falhar:** Lança erro que seria capturado pelo `catch` (linha 3395)
- **Impacto:** Se erro ocorrer aqui, código não chega até `init()`

### **Linhas 137-157: Validações de Variáveis Obrigatórias**
```javascript
if (typeof window.APILAYER_KEY === 'undefined' || !window.APILAYER_KEY) {
    throw new Error('[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido...');
}
// ... mais 6 validações similares
```
- **Status:** ⚠️ **PONTOS CRÍTICOS**
- **Se qualquer uma falhar:** Lança erro que seria capturado pelo `catch`
- **Impacto:** Se erro ocorrer aqui, código não chega até `init()`
- **Evidência do console:** Logs mostram que variáveis foram carregadas ✅

### **Linha 177-185: Leitura de Data Attributes**
```javascript
window.APP_BASE_URL = getRequiredDataAttribute(scriptElement, 'appBaseUrl', 'APP_BASE_URL');
window.APP_ENVIRONMENT = getRequiredDataAttribute(scriptElement, 'appEnvironment', 'APP_ENVIRONMENT');
// ... mais atributos
```
- **Status:** ⚠️ **PONTOS CRÍTICOS**
- **Se `getRequiredDataAttribute()` falhar:** Lança erro (linha 106)
- **Impacto:** Se erro ocorrer aqui, código não chega até `init()`
- **Evidência do console:** Log mostra `APP_ENVIRONMENT: 'production'` ✅

### **Linha 708-712: Validação de `APP_BASE_URL`**
```javascript
if (!window.APP_BASE_URL) {
  novo_log('CRITICAL', 'CONFIG', 'data-app-base-url não está definido...', ...);
  throw new Error('APP_BASE_URL não está definido...');
}
```
- **Status:** ⚠️ **PONTO CRÍTICO**
- **Se falhar:** Lança erro que seria capturado pelo `catch`
- **Impacto:** Se erro ocorrer aqui, código não chega até `init()`
- **Evidência do console:** Log mostra `APP_BASE_URL: 'https://prod.bssegurosimediato.com.br'` ✅

### **Linha 1889-1919: Captura Imediata do GCLID**
```javascript
// Captura imediata de GCLID/GBRAID da URL (executa ANTES do DOM)
novo_log('DEBUG', 'GCLID', '🔍 Iniciando captura - URL:', window.location.href);
// ... código de captura ...
```
- **Status:** ✅ **FUNCIONA EM PROD**
- **Evidência:** Console mostra `[GCLID] ✅ Capturado da URL e salvo em cookie: Teste-producao-202511231315`
- **Conclusão:** Código chegou até aqui sem erros

### **Linha 1922-1944: Definição de `waitForDependencies()`**
```javascript
function waitForDependencies(callback, maxWait = 5000) {
  // ... código ...
}
```
- **Status:** ✅ **DEVE ESTAR DEFINIDA**
- **Conclusão:** Função é definida antes de ser chamada

### **Linha 1947: Definição de `init()`**
```javascript
function init() {
  // ... código ...
}
```
- **Status:** ❌ **PROBLEMA: `init` está `undefined` no console**
- **Conclusão:** Código **NÃO chegou até aqui** OU função não está sendo definida

---

## 🔍 ANÁLISE CRÍTICA

### **Problema Identificado:**

**Evidências:**
1. ✅ Captura imediata do GCLID funciona (linha 1889) - código chegou até lá
2. ✅ Logs de configuração aparecem no console
3. ❌ `init` está `undefined` quando verificamos no console
4. ❌ `executeGCLIDFill()` nunca executa

**Conclusão:**
- Código executa até a linha 1919 (captura imediata do GCLID)
- Código **NÃO chega** até a linha 1947 onde `init()` é definida
- Há um erro ocorrendo entre as linhas 1919-1946 que está sendo capturado silenciosamente

### **Possíveis Causas:**

**Causa 1: Erro silencioso entre linhas 1919-1946**
- Código entre essas linhas pode estar lançando erro
- Erro está sendo capturado pelo `catch` (linha 3395)
- Mas erro não está sendo logado (talvez `novo_log` não esteja disponível ainda?)

**Causa 2: `novo_log('DEBUG', ...)` falhando silenciosamente**
- Linha 1890: `novo_log('DEBUG', 'GCLID', ...)`
- Em PROD, `LOG_CONFIG.level = 'error'` (linha 270)
- `shouldLog('DEBUG', 'GCLID')` retorna `false` em PROD
- Mas `novo_log()` apenas retorna `false`, não lança erro
- **NÃO deveria impedir execução**

**Causa 3: Código entre linhas 1920-1946**
- Há apenas comentário e definição de `waitForDependencies()`
- Não há código executável que possa falhar

---

## 🔍 PRÓXIMA INVESTIGAÇÃO NECESSÁRIA

**Verificar código entre linhas 1919-1946:**
- Verificar se há código executável que não foi identificado
- Verificar se há algum problema de sintaxe ou referência
- Comparar com versão DEV para identificar diferenças

---

**FASE 2 concluída em:** 23/11/2025  
**Próxima fase:** FASE 3 - Análise de Configuração de Logging e Impacto

