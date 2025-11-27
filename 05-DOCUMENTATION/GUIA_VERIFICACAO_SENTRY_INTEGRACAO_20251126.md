# Guia de Verificação da Integração Sentry

**Data:** 26/11/2025  
**Contexto:** Verificar se a integração do Sentry está funcionando corretamente após implementação

---

## 🎯 OBJETIVO

Este guia fornece métodos práticos para verificar se o Sentry está:
1. ✅ Carregado no navegador
2. ✅ Inicializado corretamente
3. ✅ Capturando erros automaticamente
4. ✅ Enviando eventos para o painel do Sentry

---

## 🔍 MÉTODO 1: Verificação Rápida no Console do Navegador

### **Passo 1: Abrir Console do Navegador**
- **Chrome/Edge:** `F12` ou `Ctrl+Shift+I` → Aba "Console"
- **Firefox:** `F12` ou `Ctrl+Shift+K` → Aba "Console"

### **Passo 2: Executar Comandos de Verificação**

Cole e execute os seguintes comandos no console:

```javascript
// ============================================
// VERIFICAÇÃO 1: Sentry está carregado?
// ============================================
console.log('🔍 Verificando Sentry...');
console.log('Sentry carregado?', typeof Sentry !== 'undefined');
console.log('Sentry inicializado?', window.SENTRY_INITIALIZED);

// ============================================
// VERIFICAÇÃO 2: Configuração do Sentry
// ============================================
if (typeof Sentry !== 'undefined') {
  try {
    const client = Sentry.getClient();
    if (client) {
      console.log('✅ Sentry está inicializado');
      console.log('DSN:', client.getDsn()?.toString());
      console.log('Environment:', client.getOptions()?.environment);
      console.log('Traces Sample Rate:', client.getOptions()?.tracesSampleRate);
    } else {
      console.warn('⚠️ Sentry está carregado mas não inicializado');
    }
  } catch (error) {
    console.error('❌ Erro ao verificar Sentry:', error);
  }
} else {
  console.error('❌ Sentry não está carregado');
}
```

### **Resultados Esperados:**

#### ✅ **Se Sentry Estiver Funcionando:**
```
🔍 Verificando Sentry...
Sentry carregado? true
Sentry inicializado? true
✅ Sentry está inicializado
DSN: https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424
Environment: dev
Traces Sample Rate: 0.1
```

#### ❌ **Se Sentry NÃO Estiver Funcionando:**
```
🔍 Verificando Sentry...
Sentry carregado? false
Sentry inicializado? undefined
❌ Sentry não está carregado
```

---

## 🧪 MÉTODO 2: Teste de Captura Manual de Erro

### **Passo 1: Executar Teste no Console**

```javascript
// ============================================
// TESTE: Capturar mensagem manualmente
// ============================================
if (typeof Sentry !== 'undefined') {
  try {
    Sentry.captureMessage('🧪 Teste de integração Sentry - ' + new Date().toISOString(), 'info');
    console.log('✅ Mensagem de teste enviada ao Sentry');
    console.log('📋 Verifique no painel do Sentry em alguns segundos');
  } catch (error) {
    console.error('❌ Erro ao enviar mensagem ao Sentry:', error);
  }
} else {
  console.error('❌ Sentry não está disponível para teste');
}
```

### **Passo 2: Verificar no Painel do Sentry**

1. Acesse: https://sentry.io/organizations/[seu-org]/issues/
2. Aguarde alguns segundos (pode levar até 30 segundos)
3. Procure por uma mensagem com o texto: `🧪 Teste de integração Sentry`
4. Se aparecer, o Sentry está funcionando! ✅

---

## 🧪 MÉTODO 3: Teste de Captura de Exceção

### **Passo 1: Executar Teste no Console**

```javascript
// ============================================
// TESTE: Capturar exceção manualmente
// ============================================
if (typeof Sentry !== 'undefined') {
  try {
    // Criar um erro de teste
    const testError = new Error('🧪 Teste de exceção Sentry - ' + new Date().toISOString());
    Sentry.captureException(testError);
    console.log('✅ Exceção de teste enviada ao Sentry');
    console.log('📋 Verifique no painel do Sentry em alguns segundos');
  } catch (error) {
    console.error('❌ Erro ao enviar exceção ao Sentry:', error);
  }
} else {
  console.error('❌ Sentry não está disponível para teste');
}
```

### **Passo 2: Verificar no Painel do Sentry**

1. Acesse: https://sentry.io/organizations/[seu-org]/issues/
2. Aguarde alguns segundos
3. Procure por uma exceção com o texto: `🧪 Teste de exceção Sentry`
4. Se aparecer, o Sentry está capturando exceções! ✅

---

## 🔍 MÉTODO 4: Verificar Logs de Inicialização

### **Passo 1: Verificar Logs no Console**

No console do navegador, procure por:

```
[SENTRY] Sentry inicializado com sucesso {environment: 'dev'}
```

ou

```
[SENTRY] Erro ao inicializar Sentry (não bloqueante)
```

### **Passo 2: Verificar Código Fonte**

1. Abra o DevTools (`F12`)
2. Vá para a aba "Sources" ou "Fontes"
3. Procure por `FooterCodeSiteDefinitivoCompleto.js`
4. Procure pela função `initSentryTracking()` (linha ~685)
5. Verifique se o código está presente e correto

---

## 🌐 MÉTODO 5: Verificar no Painel do Sentry

### **Passo 1: Acessar Painel do Sentry**

1. Acesse: https://sentry.io/
2. Faça login na sua conta
3. Selecione o projeto: `bssegurosimediato` (ou nome do seu projeto)

### **Passo 2: Verificar Eventos**

1. Vá para: **Issues** → **All Issues**
2. Filtre por:
   - **Environment:** `dev` (ou `prod`)
   - **Time Range:** Últimas 24 horas
3. Verifique se há eventos sendo capturados

### **Passo 3: Verificar Estatísticas**

1. Vá para: **Dashboard**
2. Verifique:
   - **Events Received:** Deve estar aumentando
   - **Errors:** Deve mostrar erros capturados
   - **Performance:** Deve mostrar transações rastreadas

---

## 🐛 TROUBLESHOOTING

### **Problema 1: Sentry Não Está Carregado**

#### **Sintomas:**
```
Sentry carregado? false
Sentry inicializado? undefined
```

#### **Possíveis Causas:**
1. Script do Sentry não está sendo carregado
2. Bloqueador de anúncios bloqueando o script
3. Erro de rede ao carregar o script
4. Código do Sentry não está sendo executado

#### **Soluções:**
1. Verificar se o script está sendo carregado:
   ```javascript
   // No console do navegador
   document.querySelector('script[src*="sentry"]')
   ```
2. Verificar erros de rede na aba "Network" do DevTools
3. Verificar se há bloqueadores de anúncios ativos
4. Verificar se o código `initSentryTracking()` está sendo executado

---

### **Problema 2: Sentry Está Carregado Mas Não Inicializado**

#### **Sintomas:**
```
Sentry carregado? true
Sentry inicializado? false
```

#### **Possíveis Causas:**
1. Erro na inicialização do Sentry
2. DSN incorreto
3. Problema com detecção de ambiente

#### **Soluções:**
1. Verificar erros no console do navegador
2. Verificar se o DSN está correto
3. Verificar se a detecção de ambiente está funcionando:
   ```javascript
   // Verificar ambiente detectado
   console.log('window.APP_ENVIRONMENT:', window.APP_ENVIRONMENT);
   console.log('window.LOG_CONFIG:', window.LOG_CONFIG);
   console.log('hostname:', window.location.hostname);
   ```

---

### **Problema 3: Sentry Está Funcionando Mas Não Aparece nos Logs**

#### **Sintomas:**
- Sentry está carregado e inicializado
- Mas não há mensagens de log no console

#### **Possíveis Causas:**
1. Timing issue: Sentry inicializa antes dos logs aparecerem
2. Logs não estão sendo exibidos (configuração do console)

#### **Soluções:**
1. Verificar no painel do Sentry se eventos estão sendo capturados
2. Executar testes manuais (Métodos 2 e 3)
3. Se eventos aparecem no painel, o Sentry está funcionando (mesmo sem logs no console)

---

## ✅ CHECKLIST DE VERIFICAÇÃO

Use este checklist para verificar a integração do Sentry:

- [ ] **Método 1:** Sentry está carregado? (`typeof Sentry !== 'undefined'`)
- [ ] **Método 1:** Sentry está inicializado? (`window.SENTRY_INITIALIZED === true`)
- [ ] **Método 1:** Configuração do Sentry está correta? (DSN, Environment, Traces Sample Rate)
- [ ] **Método 2:** Teste de captura manual de mensagem funciona?
- [ ] **Método 3:** Teste de captura manual de exceção funciona?
- [ ] **Método 4:** Logs de inicialização aparecem no console?
- [ ] **Método 5:** Eventos aparecem no painel do Sentry?
- [ ] **Método 5:** Estatísticas do Sentry estão sendo atualizadas?

---

## 📝 NOTAS IMPORTANTES

### **Sobre Logs no Console:**
- O Sentry pode estar funcionando **mesmo sem logs no console**
- O importante é verificar se eventos aparecem no **painel do Sentry**
- Logs no console são apenas para debug, não são obrigatórios

### **Sobre Timing:**
- O Sentry pode inicializar antes dos logs aparecerem
- Isso é normal e não indica problema
- O importante é verificar se o Sentry está funcionando (Métodos 2-5)

### **Sobre Bloqueadores:**
- Bloqueadores de anúncios podem bloquear o script do Sentry
- Verifique se há bloqueadores ativos
- Teste em modo anônimo ou com bloqueadores desativados

---

**Documento criado em:** 26/11/2025  
**Última atualização:** 26/11/2025

