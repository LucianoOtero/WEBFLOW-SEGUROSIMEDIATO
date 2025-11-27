# 🔍 Guia de Verificação do Sentry no Console

**Data:** 27/11/2025  
**Versão:** 1.0.0  
**Projeto:** Correção de Inicialização do Sentry - Remover Verificação getCurrentHub()

---

## 📋 COMANDOS PARA VERIFICAR NO CONSOLE

### **1. Verificação Básica de Inicialização**

Execute estes comandos no console do navegador (F12 → Console):

```javascript
// Verificar se Sentry está carregado
console.log('Sentry carregado?', typeof Sentry !== 'undefined');

// Verificar se foi inicializado (flag)
console.log('Sentry inicializado?', window.SENTRY_INITIALIZED);

// Verificar se Sentry.init existe
console.log('Sentry.init existe?', typeof Sentry.init === 'function');
```

**Resultado Esperado:**
```
Sentry carregado? true
Sentry inicializado? true
Sentry.init existe? true
```

---

### **2. Verificação Detalhada do Environment**

```javascript
// Verificar função getEnvironment (se exposta globalmente)
console.log('getEnvironment existe?', typeof window.getEnvironment === 'function');

// Verificar environment detectado
if (typeof window.getEnvironment === 'function') {
  console.log('Environment detectado:', window.getEnvironment());
}

// Verificar environment no Sentry (se inicializado)
if (typeof Sentry !== 'undefined' && window.SENTRY_INITIALIZED) {
  try {
    const client = Sentry.getCurrentHub ? Sentry.getCurrentHub().getClient() : null;
    if (client) {
      console.log('Environment no Sentry:', client.getOptions().environment);
    } else {
      console.log('Environment no Sentry: (não disponível via getCurrentHub)');
    }
  } catch (e) {
    console.log('Environment no Sentry: (erro ao obter)', e.message);
  }
}
```

**Resultado Esperado (DEV):**
```
getEnvironment existe? true
Environment detectado: dev
Environment no Sentry: dev
```

---

### **3. Verificação Completa (Comando Único)**

Copie e cole este comando completo no console:

```javascript
(function() {
  console.log('=== VERIFICAÇÃO SENTRY ===');
  console.log('');
  
  // 1. Verificar carregamento
  console.log('1. Sentry carregado?', typeof Sentry !== 'undefined');
  
  // 2. Verificar inicialização
  console.log('2. SENTRY_INITIALIZED?', window.SENTRY_INITIALIZED);
  
  // 3. Verificar funções
  console.log('3. Sentry.init existe?', typeof Sentry.init === 'function');
  console.log('4. getEnvironment existe?', typeof window.getEnvironment === 'function');
  
  // 4. Verificar environment
  if (typeof window.getEnvironment === 'function') {
    console.log('5. Environment detectado:', window.getEnvironment());
  }
  
  // 5. Tentar capturar mensagem de teste
  if (typeof Sentry !== 'undefined' && window.SENTRY_INITIALIZED) {
    try {
      Sentry.captureMessage('Teste de inicialização do Sentry', 'info');
      console.log('6. ✅ Teste de captura enviado com sucesso!');
    } catch (e) {
      console.log('6. ❌ Erro ao capturar mensagem:', e.message);
    }
  } else {
    console.log('6. ⚠️ Sentry não inicializado - não é possível testar captura');
  }
  
  console.log('');
  console.log('=== FIM DA VERIFICAÇÃO ===');
})();
```

**Resultado Esperado:**
```
=== VERIFICAÇÃO SENTRY ===

1. Sentry carregado? true
2. SENTRY_INITIALIZED? true
3. Sentry.init existe? true
4. getEnvironment existe? true
5. Environment detectado: dev
6. ✅ Teste de captura enviado com sucesso!

=== FIM DA VERIFICAÇÃO ===
```

---

### **4. Teste de Captura de Erro**

Para testar se o Sentry está capturando erros corretamente:

```javascript
// Teste 1: Capturar mensagem
if (typeof Sentry !== 'undefined' && window.SENTRY_INITIALIZED) {
  Sentry.captureMessage('Teste de captura de mensagem', 'info');
  console.log('✅ Mensagem de teste enviada ao Sentry');
}

// Teste 2: Capturar exceção
if (typeof Sentry !== 'undefined' && window.SENTRY_INITIALIZED) {
  try {
    throw new Error('Teste de captura de erro do Sentry');
  } catch (error) {
    Sentry.captureException(error);
    console.log('✅ Exceção de teste enviada ao Sentry');
  }
}
```

**Resultado Esperado:**
- Console mostra: `✅ Mensagem de teste enviada ao Sentry`
- Console mostra: `✅ Exceção de teste enviada ao Sentry`
- **IMPORTANTE:** Verifique no dashboard do Sentry se as mensagens apareceram (pode levar alguns segundos)

---

### **5. Verificação de Problemas Comuns**

Se algo não estiver funcionando, execute este diagnóstico:

```javascript
(function() {
  console.log('=== DIAGNÓSTICO SENTRY ===');
  console.log('');
  
  // Verificar se Sentry está definido
  if (typeof Sentry === 'undefined') {
    console.log('❌ PROBLEMA: Sentry não está carregado');
    console.log('   Verifique se o script do Sentry foi carregado corretamente');
    return;
  }
  
  console.log('✅ Sentry está carregado');
  
  // Verificar se foi inicializado
  if (!window.SENTRY_INITIALIZED) {
    console.log('❌ PROBLEMA: Sentry não foi inicializado');
    console.log('   window.SENTRY_INITIALIZED =', window.SENTRY_INITIALIZED);
    console.log('   Verifique se initSentryTracking() foi executado');
    return;
  }
  
  console.log('✅ Sentry foi inicializado');
  
  // Verificar environment
  if (typeof window.getEnvironment === 'function') {
    const env = window.getEnvironment();
    console.log('✅ Environment detectado:', env);
    
    if (env !== 'dev' && window.location.hostname.includes('dev')) {
      console.log('⚠️ ATENÇÃO: Environment pode estar incorreto');
      console.log('   Hostname:', window.location.hostname);
      console.log('   Environment detectado:', env);
    }
  } else {
    console.log('⚠️ getEnvironment não está disponível globalmente');
  }
  
  // Verificar se pode capturar
  try {
    Sentry.captureMessage('Teste de diagnóstico', 'debug');
    console.log('✅ Sentry pode capturar mensagens');
  } catch (e) {
    console.log('❌ ERRO ao capturar mensagem:', e.message);
  }
  
  console.log('');
  console.log('=== FIM DO DIAGNÓSTICO ===');
})();
```

---

## ✅ CHECKLIST DE VERIFICAÇÃO

Após executar os comandos acima, verifique:

- [ ] `Sentry carregado?` = `true`
- [ ] `SENTRY_INITIALIZED?` = `true`
- [ ] `Sentry.init existe?` = `true`
- [ ] `getEnvironment existe?` = `true`
- [ ] `Environment detectado:` = `dev` (em ambiente de desenvolvimento)
- [ ] Teste de captura enviado com sucesso
- [ ] Não há erros no console relacionados ao Sentry

---

## 🚨 PROBLEMAS COMUNS E SOLUÇÕES

### **Problema 1: `SENTRY_INITIALIZED` é `undefined`**
**Causa:** Sentry não foi inicializado  
**Solução:** 
- Verifique se o código `initSentryTracking()` foi executado
- Verifique se há erros no console que impediram a inicialização
- Limpe o cache do Cloudflare e recarregue a página

### **Problema 2: `Sentry` é `undefined`**
**Causa:** Script do Sentry não foi carregado  
**Solução:**
- Verifique se o script do Sentry está sendo carregado corretamente
- Verifique a aba Network no DevTools para ver se o script foi baixado
- Verifique se há erros de CORS ou bloqueio de conteúdo

### **Problema 3: Environment está incorreto**
**Causa:** Função `getEnvironment()` pode estar detectando incorretamente  
**Solução:**
- Verifique o hostname atual: `console.log(window.location.hostname)`
- Verifique se `window.APP_ENVIRONMENT` está definido: `console.log(window.APP_ENVIRONMENT)`
- Verifique se `window.LOG_CONFIG.environment` está definido: `console.log(window.LOG_CONFIG?.environment)`

### **Problema 4: Erro "getCurrentHub is not a function"**
**Causa:** Código antigo ainda está em cache  
**Solução:**
- Limpe o cache do Cloudflare
- Limpe o cache do navegador (Ctrl+Shift+Delete)
- Recarregue a página com cache limpo (Ctrl+F5)

---

## 📊 VERIFICAÇÃO NO DASHBOARD DO SENTRY

Após executar os testes de captura:

1. Acesse o dashboard do Sentry: https://sentry.io/
2. Navegue até o projeto: `imediatoseguros-rpa-playwright`
3. Verifique se as mensagens de teste apareceram:
   - "Teste de inicialização do Sentry"
   - "Teste de captura de mensagem"
   - "Teste de captura de erro do Sentry"
4. Verifique se o environment está correto (`dev` em desenvolvimento)

---

**Documento criado em:** 27/11/2025  
**Versão:** 1.0.0

