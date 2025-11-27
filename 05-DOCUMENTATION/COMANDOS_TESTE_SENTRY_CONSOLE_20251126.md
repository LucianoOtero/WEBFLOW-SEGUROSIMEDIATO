# Comandos para Testar Sentry no Console do Navegador

**Data:** 26/11/2025  
**Uso:** Execute estes comandos no console do navegador (`F12` → Aba "Console")

---

## 🔍 TESTE 1: Verificação Básica

### **Comando:**
```javascript
// Verificar se Sentry está carregado e inicializado
console.log('=== TESTE 1: Verificação Básica ===');
console.log('Sentry carregado?', typeof Sentry !== 'undefined');
console.log('Sentry inicializado?', window.SENTRY_INITIALIZED);
console.log('Tipo de Sentry:', typeof Sentry);
```

### **Resultados Esperados:**

#### ✅ **Se Sentry Estiver Funcionando:**
```
=== TESTE 1: Verificação Básica ===
Sentry carregado? true
Sentry inicializado? true
Tipo de Sentry: object
```

#### ❌ **Se Sentry NÃO Estiver Inicializado:**
```
=== TESTE 1: Verificação Básica ===
Sentry carregado? true
Sentry inicializado? undefined
Tipo de Sentry: object
```

---

## 🔍 TESTE 2: Verificação Detalhada (Compatível com CDN)

### **Comando:**
```javascript
// Verificação detalhada usando métodos disponíveis na versão CDN
console.log('=== TESTE 2: Verificação Detalhada ===');

if (typeof Sentry !== 'undefined') {
  console.log('✅ Sentry está carregado');
  
  // Verificar métodos disponíveis
  console.log('Métodos disponíveis:', Object.keys(Sentry).slice(0, 10));
  
  // Tentar verificar inicialização usando getCurrentHub (se disponível)
  try {
    if (typeof Sentry.getCurrentHub === 'function') {
      const hub = Sentry.getCurrentHub();
      const client = hub.getClient();
      if (client) {
        console.log('✅ Sentry está inicializado e funcionando!');
        console.log('Environment:', client.getOptions()?.environment);
        console.log('DSN:', client.getDsn()?.toString());
      } else {
        console.warn('⚠️ Sentry carregado mas não inicializado (client não encontrado)');
      }
    } else {
      console.log('ℹ️ getCurrentHub não disponível (versão CDN)');
      // Verificar apenas a flag
      if (window.SENTRY_INITIALIZED) {
        console.log('✅ Sentry inicializado (verificado via flag)');
      } else {
        console.warn('⚠️ Flag SENTRY_INITIALIZED não definida');
      }
    }
  } catch (error) {
    console.error('❌ Erro ao verificar:', error.message);
  }
} else {
  console.error('❌ Sentry não está carregado');
}
```

---

## 🧪 TESTE 3: Teste de Captura de Mensagem

### **Comando:**
```javascript
// Testar captura de mensagem no Sentry
console.log('=== TESTE 3: Captura de Mensagem ===');

if (typeof Sentry !== 'undefined') {
  try {
    const testMessage = '🧪 Teste Sentry Console - ' + new Date().toISOString();
    Sentry.captureMessage(testMessage, 'info');
    console.log('✅ Mensagem enviada ao Sentry:', testMessage);
    console.log('📋 Verifique no painel do Sentry em alguns segundos:');
    console.log('   https://sentry.io/organizations/[seu-org]/issues/');
  } catch (error) {
    console.error('❌ Erro ao enviar mensagem:', error.message);
    console.error('Stack:', error.stack);
  }
} else {
  console.error('❌ Sentry não está disponível');
}
```

### **Como Verificar:**
1. Execute o comando acima
2. Aguarde 10-30 segundos
3. Acesse: https://sentry.io/organizations/[seu-org]/issues/
4. Procure por uma mensagem com o texto: `🧪 Teste Sentry Console`
5. Se aparecer, o Sentry está funcionando! ✅

---

## 🧪 TESTE 4: Teste de Captura de Exceção

### **Comando:**
```javascript
// Testar captura de exceção no Sentry
console.log('=== TESTE 4: Captura de Exceção ===');

if (typeof Sentry !== 'undefined') {
  try {
    // Criar um erro de teste
    const testError = new Error('🧪 Teste de Exceção Sentry - ' + new Date().toISOString());
    testError.name = 'TestError';
    
    Sentry.captureException(testError);
    console.log('✅ Exceção enviada ao Sentry:', testError.message);
    console.log('📋 Verifique no painel do Sentry em alguns segundos');
  } catch (error) {
    console.error('❌ Erro ao enviar exceção:', error.message);
    console.error('Stack:', error.stack);
  }
} else {
  console.error('❌ Sentry não está disponível');
}
```

---

## 🧪 TESTE 5: Teste de Captura com Contexto

### **Comando:**
```javascript
// Testar captura com contexto adicional
console.log('=== TESTE 5: Captura com Contexto ===');

if (typeof Sentry !== 'undefined') {
  try {
    Sentry.withScope(function(scope) {
      scope.setTag('test', 'console_test');
      scope.setLevel('info');
      scope.setContext('test_context', {
        timestamp: new Date().toISOString(),
        userAgent: navigator.userAgent,
        url: window.location.href
      });
      
      Sentry.captureMessage('🧪 Teste com Contexto - ' + new Date().toISOString(), 'info');
      console.log('✅ Mensagem com contexto enviada ao Sentry');
      console.log('📋 Verifique no painel do Sentry');
    });
  } catch (error) {
    console.error('❌ Erro ao enviar mensagem com contexto:', error.message);
  }
} else {
  console.error('❌ Sentry não está disponível');
}
```

---

## 🔍 TESTE 6: Verificar Configuração Atual

### **Comando:**
```javascript
// Verificar configuração atual do Sentry
console.log('=== TESTE 6: Configuração Atual ===');

if (typeof Sentry !== 'undefined') {
  try {
    if (typeof Sentry.getCurrentHub === 'function') {
      const hub = Sentry.getCurrentHub();
      const client = hub.getClient();
      
      if (client) {
        const options = client.getOptions();
        console.log('✅ Configuração do Sentry:');
        console.log('  - Environment:', options.environment);
        console.log('  - DSN:', options.dsn);
        console.log('  - Traces Sample Rate:', options.tracesSampleRate);
        console.log('  - Ignore Errors:', options.ignoreErrors);
        console.log('  - Before Send:', typeof options.beforeSend === 'function' ? 'Definido' : 'Não definido');
      } else {
        console.warn('⚠️ Cliente não encontrado - Sentry pode não estar inicializado');
      }
    } else {
      console.log('ℹ️ getCurrentHub não disponível - usando verificação básica');
      console.log('  - Flag SENTRY_INITIALIZED:', window.SENTRY_INITIALIZED);
    }
  } catch (error) {
    console.error('❌ Erro ao verificar configuração:', error.message);
  }
} else {
  console.error('❌ Sentry não está carregado');
}
```

---

## 🧪 TESTE 7: Teste Completo (Todos os Testes)

### **Comando:**
```javascript
// Executar todos os testes em sequência
console.log('=== TESTE COMPLETO DO SENTRY ===\n');

// Teste 1: Verificação Básica
console.log('1️⃣ Verificação Básica:');
console.log('   Sentry carregado?', typeof Sentry !== 'undefined');
console.log('   Sentry inicializado?', window.SENTRY_INITIALIZED);

// Teste 2: Verificação Detalhada
console.log('\n2️⃣ Verificação Detalhada:');
if (typeof Sentry !== 'undefined') {
  try {
    if (typeof Sentry.getCurrentHub === 'function') {
      const hub = Sentry.getCurrentHub();
      const client = hub.getClient();
      if (client) {
        console.log('   ✅ Sentry funcionando!');
        console.log('   Environment:', client.getOptions()?.environment);
      } else {
        console.log('   ⚠️ Sentry carregado mas não inicializado');
      }
    } else {
      console.log('   ℹ️ Versão CDN - usando flag:', window.SENTRY_INITIALIZED);
    }
  } catch (e) {
    console.log('   ❌ Erro:', e.message);
  }
} else {
  console.log('   ❌ Sentry não carregado');
}

// Teste 3: Captura de Mensagem
console.log('\n3️⃣ Teste de Captura:');
if (typeof Sentry !== 'undefined') {
  try {
    const testMsg = '🧪 Teste Completo - ' + new Date().toISOString();
    Sentry.captureMessage(testMsg, 'info');
    console.log('   ✅ Mensagem enviada:', testMsg);
    console.log('   📋 Verifique no painel do Sentry');
  } catch (e) {
    console.log('   ❌ Erro:', e.message);
  }
} else {
  console.log('   ❌ Sentry não disponível');
}

console.log('\n=== FIM DO TESTE COMPLETO ===');
```

---

## 📋 CHECKLIST DE TESTES

Use este checklist para verificar o Sentry:

- [ ] **Teste 1:** Sentry está carregado? (`typeof Sentry !== 'undefined'`)
- [ ] **Teste 1:** Sentry está inicializado? (`window.SENTRY_INITIALIZED === true`)
- [ ] **Teste 2:** Verificação detalhada passa sem erros?
- [ ] **Teste 3:** Mensagem de teste aparece no painel do Sentry?
- [ ] **Teste 4:** Exceção de teste aparece no painel do Sentry?
- [ ] **Teste 5:** Mensagem com contexto aparece no painel do Sentry?
- [ ] **Teste 6:** Configuração está correta (environment, DSN, etc.)?

---

## 🎯 INTERPRETAÇÃO DOS RESULTADOS

### **Cenário A: Sentry Funcionando Perfeitamente**
```
✅ Sentry carregado? true
✅ Sentry inicializado? true
✅ Mensagens aparecem no painel do Sentry
✅ Configuração correta
```
**Ação:** Nenhuma - Sentry está funcionando corretamente!

---

### **Cenário B: Sentry Carregado Mas Não Inicializado**
```
✅ Sentry carregado? true
❌ Sentry inicializado? undefined
❌ Mensagens NÃO aparecem no painel do Sentry
```
**Causa:** Problema na inicialização (usando `onLoad()` quando já está carregado)  
**Ação:** Implementar correção proposta na análise

---

### **Cenário C: Sentry Não Carregado**
```
❌ Sentry carregado? false
❌ Sentry inicializado? undefined
```
**Causa:** Script do Sentry não foi carregado  
**Ação:** Verificar:
- Script está sendo carregado?
- Bloqueador de anúncios bloqueando?
- Erro de rede ao carregar script?

---

## 💡 DICAS

1. **Execute os testes em ordem:** Comece pelo Teste 1 e vá avançando
2. **Aguarde alguns segundos:** Mensagens podem levar 10-30 segundos para aparecer no painel
3. **Verifique o painel do Sentry:** https://sentry.io/organizations/[seu-org]/issues/
4. **Use o Teste 7:** Executa todos os testes de uma vez
5. **Copie e cole:** Os comandos podem ser copiados e colados diretamente no console

---

**Documento criado em:** 26/11/2025  
**Última atualização:** 26/11/2025

