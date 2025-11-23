# 📋 Análise: Por que GCLID funciona em DEV mas não em PROD?

**Data:** 23/11/2025  
**Problema:** GCLID funciona em desenvolvimento mas não em produção  
**Status:** ⚠️ **ANÁLISE CONCLUÍDA - CAUSA PROVÁVEL IDENTIFICADA**

---

## 🔍 VERIFICAÇÕES REALIZADAS

### ✅ **1. Arquivos são idênticos**
- **Hash SHA256 DEV:** `A3CC0589CB085B78E28FB79314D4F965A597EAF5FD2C40D3B8846326621512A2`
- **Hash SHA256 PROD:** `A3CC0589CB085B78E28FB79314D4F965A597EAF5FD2C40D3B8846326621512A2`
- **Conclusão:** Arquivos são **100% idênticos** - problema não está no código

### ✅ **2. Captura imediata funciona em ambos**
- **DEV:** ✅ GCLID capturado e salvo em cookie
- **PROD:** ✅ GCLID capturado e salvo em cookie (`Teste-producao-202511231315`)
- **Conclusão:** Captura imediata funciona em ambos os ambientes

### ❌ **3. Preenchimento funciona apenas em DEV**
- **DEV:** ✅ `executeGCLIDFill()` executa e preenche campos
- **PROD:** ❌ `executeGCLIDFill()` **NÃO executa** (não há logs)

---

## 🔍 CAUSA PROVÁVEL IDENTIFICADA

### **Problema: `waitForDependencies()` não está completando em PROD**

**Análise do código (linhas 1922-1943):**

```javascript
function waitForDependencies(callback, maxWait = 5000) {
  const startTime = Date.now();
  
  function check() {
    const hasJQuery = typeof jQuery !== 'undefined';
    const hasUtils = typeof window.onlyDigits === 'function';
    
    if (hasJQuery && hasUtils) {
      callback(); // Chama init()
    } else if (Date.now() - startTime < maxWait) {
      setTimeout(check, 50);
    } else {
      // Timeout após 5 segundos
      window.novo_log('ERROR', 'FOOTER', '[FOOTER COMPLETO] Timeout aguardando dependências:', {
        jQuery: hasJQuery,
        Utils: hasUtils
      }, 'ERROR_HANDLING', 'SIMPLE');
      callback(); // Executa mesmo assim
    }
  }
  
  check();
}
```

**Condições para `init()` ser chamada:**
1. ✅ `jQuery` deve estar disponível (`typeof jQuery !== 'undefined'`)
2. ✅ `window.onlyDigits` deve estar disponível (`typeof window.onlyDigits === 'function'`)

**Se qualquer uma dessas condições falhar por mais de 5 segundos:**
- `waitForDependencies()` faz timeout
- Chama `callback()` (que é `init()`) mesmo assim
- Mas pode haver erro silencioso que impede `executeGCLIDFill()` de executar

---

## 🔍 DIFERENÇAS ENTRE DEV E PROD

### **1. Ordem de Carregamento de Scripts**

**Possível diferença:** Em PROD, scripts podem estar carregando em ordem diferente ou mais lentamente.

**Evidência:**
- Em DEV: jQuery e Utils carregam antes do timeout
- Em PROD: jQuery ou Utils podem não estar disponíveis quando `waitForDependencies()` executa

**Verificação necessária:**
- Verificar ordem de scripts no Webflow PROD vs DEV
- Verificar se jQuery está sendo carregado antes de `FooterCodeSiteDefinitivoCompleto.js`

### **2. jQuery não está disponível em PROD**

**Possibilidade:** jQuery pode não estar carregado no Webflow PROD, ou está carregando de forma assíncrona.

**Evidência:**
- `waitForDependencies()` espera por `jQuery`
- Se jQuery não estiver disponível, faz timeout após 5 segundos
- Mas `init()` pode falhar silenciosamente se jQuery for necessário para outras partes do código

**Verificação necessária:**
- Verificar se jQuery está sendo carregado no Webflow PROD
- Verificar ordem de carregamento: jQuery deve carregar ANTES de `FooterCodeSiteDefinitivoCompleto.js`

### **3. `window.onlyDigits` não está disponível em PROD**

**Possibilidade:** Função `onlyDigits` pode não estar sendo definida antes de `waitForDependencies()` executar.

**Evidência:**
- `waitForDependencies()` verifica `typeof window.onlyDigits === 'function'`
- Se `onlyDigits` não estiver disponível, faz timeout
- Mas logs mostram: `✅ Footer Code Utils carregado - 26 funções disponíveis`
- Isso sugere que Utils estão carregando, mas pode haver problema de timing

**Verificação necessária:**
- Verificar se `onlyDigits` está sendo definida antes de `waitForDependencies()` executar
- Verificar timing: `onlyDigits` é definida na linha 957, mas `waitForDependencies()` pode executar antes

### **4. Timing de Execução**

**Possibilidade:** Em PROD, o código pode estar executando em momento diferente devido a:
- Cache do Cloudflare servindo versão antiga
- Scripts carregando mais lentamente
- DOM carregando em ordem diferente

**Evidência:**
- Código verifica `document.readyState` (linha 3386)
- Se `readyState === 'loading'`, adiciona listener `DOMContentLoaded`
- Se `readyState !== 'loading'`, executa imediatamente
- Em PROD, pode estar executando em momento diferente

---

## 🔍 ANÁLISE DO FLUXO DE EXECUÇÃO

### **Fluxo Esperado:**

```
1. FooterCodeSiteDefinitivoCompleto.js carrega
   ↓
2. Captura imediata do GCLID executa (linha 1889) ✅ FUNCIONA EM PROD
   ↓
3. Verifica document.readyState (linha 3386)
   ↓
4. Se 'loading': adiciona listener DOMContentLoaded
   Se não 'loading': executa waitForDependencies(init) imediatamente
   ↓
5. waitForDependencies() verifica dependências:
   - jQuery disponível?
   - window.onlyDigits disponível?
   ↓
6. Se dependências OK: chama init() ✅ DEVERIA ACONTECER
   Se timeout: chama init() mesmo assim ⚠️ PODE FALHAR
   ↓
7. init() define executeGCLIDFill() (linha 1964)
   ↓
8. executeGCLIDFill() verifica readyState (linha 2250)
   ↓
9. Se 'loading': adiciona listener DOMContentLoaded
   Se não 'loading': executa fillGCLIDFields() imediatamente
   ↓
10. fillGCLIDFields() preenche campos GCLID_FLD ✅ DEVERIA ACONTECER
```

### **Onde pode estar falhando em PROD:**

**Ponto 5-6:** `waitForDependencies()` pode não estar completando corretamente
- jQuery pode não estar disponível
- `window.onlyDigits` pode não estar disponível
- Timeout pode estar ocorrendo mas `init()` falha silenciosamente

**Ponto 7-8:** `init()` pode estar sendo chamada mas `executeGCLIDFill()` não executa
- Código dentro de `init()` pode estar falhando antes de chegar em `executeGCLIDFill()`
- Verificação de `readyState` pode estar incorreta

---

## 📋 CONCLUSÃO

**Causa Provável:** `waitForDependencies()` não está completando corretamente em PROD devido a:

1. **jQuery não disponível:** jQuery pode não estar carregado no Webflow PROD ou está carregando após o timeout
2. **Timing diferente:** Scripts podem estar carregando em ordem/timing diferente em PROD
3. **Erro silencioso:** `init()` pode estar sendo chamada mas falhando silenciosamente antes de `executeGCLIDFill()` executar

**Evidência:**
- Arquivos são idênticos (mesmo hash SHA256)
- Captura imediata funciona em ambos
- Preenchimento funciona apenas em DEV
- Não há logs de `executeGCLIDFill()` em PROD

**Próximos Passos:**
1. Verificar se jQuery está sendo carregado no Webflow PROD
2. Verificar ordem de carregamento de scripts no Webflow PROD
3. Adicionar logs adicionais em `waitForDependencies()` e `init()` para identificar onde está falhando
4. Verificar se há diferenças na configuração do Webflow entre DEV e PROD

---

**Análise realizada em:** 23/11/2025  
**Causa Provável:** jQuery ou dependências não disponíveis em PROD quando `waitForDependencies()` executa

