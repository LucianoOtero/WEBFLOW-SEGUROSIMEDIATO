# 🔧 CORREÇÃO: APP_BASE_URL - Problema de Timing

**Data:** 10/11/2025  
**Problema:** `APP_BASE_URL` não estava disponível quando `sendLogToProfessionalSystem()` era chamado

---

## 🐛 PROBLEMA IDENTIFICADO

**Erro no console:**
```
[LOG] APP_BASE_URL não disponível. Aguardando carregamento...
[LOG] Erro ao enviar log: Error: APP_BASE_URL não disponível
```

**Causa raiz:**
1. O código carrega `config_env.js.php` de forma **assíncrona** (linha 127-156)
2. Mas logo em seguida, na linha 642, já tenta usar `window.logInfo('UTILS', '🔄 Carregando Footer Code Utils...')`
3. `window.logInfo()` → `window.logUnified()` → `sendLogToProfessionalSystem()`
4. `sendLogToProfessionalSystem()` precisa de `APP_BASE_URL`, mas ele ainda não foi carregado
5. Resultado: erro "APP_BASE_URL não disponível"

**Fluxo do problema:**
```
FooterCodeSiteDefinitivoCompleto.js carrega
  ↓
Carrega config_env.js.php (assíncrono)
  ↓
Executa window.logInfo('UTILS', ...) (linha 642) ← ANTES de APP_BASE_URL estar disponível
  ↓
sendLogToProfessionalSystem() tenta usar APP_BASE_URL
  ↓
❌ ERRO: APP_BASE_URL não disponível
```

---

## ✅ CORREÇÃO APLICADA

**Arquivo:** `FooterCodeSiteDefinitivoCompleto.js`

**Função modificada:** `sendLogToProfessionalSystem()` (linha 352)

### Antes:
```javascript
if (!window.APP_BASE_URL) {
  console.error('[LOG] APP_BASE_URL não disponível. Aguardando carregamento...');
  throw new Error('APP_BASE_URL não disponível');
}
```

### Depois:
```javascript
// Aguardar APP_BASE_URL estar disponível (se ainda não estiver)
if (!window.APP_BASE_URL) {
  // Se ainda não foi carregado, aguardar até 3 segundos
  return new Promise((resolve) => {
    let attempts = 0;
    const maxAttempts = 30; // 30 tentativas de 100ms = 3 segundos
    const checkInterval = setInterval(() => {
      attempts++;
      if (window.APP_BASE_URL) {
        clearInterval(checkInterval);
        // Retry após APP_BASE_URL estar disponível
        sendLogToProfessionalSystem(level, category, message, data).then(resolve).catch(() => resolve(false));
      } else if (attempts >= maxAttempts) {
        clearInterval(checkInterval);
        console.warn('[LOG] APP_BASE_URL não disponível após aguardar. Log não enviado.');
        resolve(false);
      }
    }, 100);
  });
}
```

---

## ✅ RESULTADO

**Comportamento agora:**
1. ✅ Se `APP_BASE_URL` estiver disponível → envia log imediatamente
2. ✅ Se `APP_BASE_URL` não estiver disponível → aguarda até 3 segundos
3. ✅ Quando `APP_BASE_URL` fica disponível → retry automático do log
4. ✅ Se após 3 segundos ainda não estiver disponível → log não é enviado (mas não quebra a aplicação)

**Fluxo corrigido:**
```
FooterCodeSiteDefinitivoCompleto.js carrega
  ↓
Carrega config_env.js.php (assíncrono)
  ↓
Executa window.logInfo('UTILS', ...) (linha 642)
  ↓
sendLogToProfessionalSystem() verifica APP_BASE_URL
  ↓
APP_BASE_URL não disponível → aguarda (até 3 segundos)
  ↓
config_env.js.php carrega → APP_BASE_URL fica disponível
  ↓
✅ Retry automático → log enviado com sucesso
```

---

## 🧪 TESTE DISPONÍVEL

**Arquivo:** `test_simulacao_webflow.html`

Este arquivo simula o comportamento do Webflow carregando o `FooterCodeSiteDefinitivoCompleto.js` e verifica se `APP_BASE_URL` é carregado corretamente.

**Acesso:** `https://dev.bssegurosimediato.com.br/test_simulacao_webflow.html`

---

**Status:** ✅ **CORRIGIDO**

O arquivo foi atualizado no servidor e está pronto para teste.

