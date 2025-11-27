# 🔍 ANÁLISE: Tela de Setup do Sentry

**Data:** 26/11/2025  
**Contexto:** Análise da tela "Get Started with Sentry Issues"  
**Status:** 📋 **ANÁLISE** - Explicação do que é e o que fazer

---

## 📋 O QUE É ESSA TELA?

### **Tela de Onboarding do Sentry**

Esta é a tela inicial de configuração do projeto no Sentry. Ela aparece após criar um novo projeto e guia você pelos passos para começar a usar o Sentry.

---

## 🔍 ANÁLISE DOS PASSOS

### **PASSO 1: Install (Instalar SDK)**

**O que mostra:**
```
npm install --save @sentry/browser
```

**O que significa:**
- Instala o SDK do Sentry via npm (Node Package Manager)
- Usado quando você tem um projeto Node.js/Bundler (Webpack, Vite, etc.)
- Cria dependência no `package.json`

**⚠️ IMPORTANTE:**
- **Você NÃO precisa fazer isso** se estiver usando o CDN (script tag)
- Você já tem o script CDN configurado:
  ```html
  <script src="https://js-de.sentry-cdn.com/9cbeefde9ce7c0b959b51a4c5e6e52dd.min.js"></script>
  ```
- **CDN e npm são formas diferentes de incluir o mesmo SDK**
- **Use apenas UMA forma** (CDN ou npm, não ambos)

---

### **PASSO 2: Configure SDK (Configurar SDK)**

**O que significa:**
- Configurar o Sentry no seu código JavaScript
- Inicializar com `Sentry.init()`
- Configurar DSN, ambiente, sanitização, etc.

**✅ VOCÊ JÁ TEM ISSO:**
- Você já tem a configuração no arquivo `sentry.config.local.js`
- Código de inicialização já está pronto:
  ```javascript
  Sentry.onLoad(function() {
    Sentry.init({
      dsn: "https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424",
      // ... configurações
    });
  });
  ```

**O que fazer:**
- ✅ **Já está feito** - você tem a configuração
- ⚠️ **Mas precisa:** Incluir no código JavaScript do site (FooterCode ou Modal)

---

### **PASSO 3: Verify (Verificar)**

**O que significa:**
- Testar se o Sentry está funcionando
- Enviar um evento de teste
- Verificar se aparece no dashboard

**O que fazer:**
- ✅ **Precisa fazer:** Testar após incluir no código
- ✅ **Como testar:** Usar função `myUndefinedFunction()` ou enviar evento manual

---

## 🎯 O QUE VOCÊ PRECISA FAZER?

### **✅ JÁ TEM (Não precisa fazer):**
1. ✅ Conta criada no Sentry
2. ✅ Projeto criado (Browser JavaScript)
3. ✅ DSN obtido
4. ✅ Configuração pronta no `sentry.config.local.js`

### **⚠️ PRECISA FAZER:**

#### **1. Incluir Script e Configuração no Código JavaScript**

**Onde:** No `FooterCodeSiteDefinitivoCompleto.js` ou no HTML do Webflow

**Código a incluir:**
```html
<!-- Script do Sentry (antes de </body> ou no início do FooterCode) -->
<script
  src="https://js-de.sentry-cdn.com/9cbeefde9ce7c0b959b51a4c5e6e52dd.min.js"
  crossorigin="anonymous"
></script>

<!-- Inicialização do Sentry (após o script acima) -->
<script>
  Sentry.onLoad(function() {
    Sentry.init({
      dsn: "https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424",
      environment: window.location.hostname.includes('dev') ? 'dev' : 'prod',
      tracesSampleRate: 0.1,
      
      beforeSend(event, hint) {
        if (event.extra) {
          delete event.extra.ddd;
          delete event.extra.celular;
          delete event.extra.cpf;
          delete event.extra.nome;
          delete event.extra.email;
        }
        return event;
      }
    });
  });
</script>
```

---

#### **2. Integrar Função de Logging Onde Erros Ocorrem**

**Onde:** No `MODAL_WHATSAPP_DEFINITIVO.js` (onde erros são capturados)

**Código a adicionar:**
```javascript
// Função para logar erro no Sentry
function logErrorToSentry(errorData) {
  if (typeof Sentry === 'undefined') {
    return; // Sentry não disponível
  }
  
  try {
    Sentry.captureMessage(errorData.error || 'unknown_error', {
      level: 'error',
      tags: {
        component: errorData.component || 'MODAL',
        action: errorData.action || 'unknown',
        environment: window.location.hostname.includes('dev') ? 'dev' : 'prod'
      },
      extra: {
        error: errorData.error,
        attempt: errorData.attempt,
        duration: errorData.duration,
        url: window.location.href
      }
    });
  } catch (err) {
    console.error('Falha ao logar no Sentry:', err);
  }
}

// Usar quando erro ocorrer
if (result.success === false) {
  const errorMsg = result.error?.message || 'Erro desconhecido';
  
  // Logar no sistema próprio (existente)
  logEvent('whatsapp_modal_octadesk_initial_error', { 
    error: errorMsg, 
    attempt: result.attempt + 1 
  }, 'error');
  
  // Logar no Sentry (novo)
  logErrorToSentry({
    error: 'whatsapp_modal_octadesk_initial_error',
    component: 'MODAL',
    action: 'octadesk_initial',
    attempt: result.attempt + 1,
    duration: duration
  });
}
```

---

#### **3. Testar (Verify)**

**Como testar:**
```javascript
// Teste 1: Enviar mensagem de teste
if (typeof Sentry !== 'undefined') {
  Sentry.captureMessage('Teste de integração Sentry', {
    level: 'info',
    tags: { test: true }
  });
  console.log('✅ Sentry está funcionando! Verifique o dashboard.');
}

// Teste 2: Causar erro proposital (após implementar)
// myUndefinedFunction(); // Vai causar erro e ser capturado pelo Sentry
```

**Verificar no Dashboard:**
1. Acessar: https://sentry.io/
2. Ir para projeto criado
3. Verificar se evento de teste aparece em **"Issues"** ou **"Events"**

---

## 📊 RESUMO: O QUE FAZER?

### **❌ NÃO precisa fazer:**
- ❌ Instalar via npm (`npm install @sentry/browser`)
- ❌ Criar projeto (já criado)
- ❌ Obter DSN (já obtido)

### **✅ PRECISA fazer:**
1. ✅ **Incluir script e configuração** no código JavaScript do site
2. ✅ **Integrar função de logging** onde erros ocorrem
3. ✅ **Testar** se está funcionando
4. ✅ **Verificar** no dashboard do Sentry

---

## 🎯 PRÓXIMOS PASSOS

### **Opção 1: Fazer Agora (Implementação Imediata)**
1. Incluir script e configuração no `FooterCodeSiteDefinitivoCompleto.js`
2. Adicionar função `logErrorToSentry()` no `MODAL_WHATSAPP_DEFINITIVO.js`
3. Integrar onde erros ocorrem
4. Testar e verificar

### **Opção 2: Criar Projeto Primeiro (Recomendado)**
1. Criar projeto de integração do Sentry
2. Documentar todas as mudanças necessárias
3. Implementar em uma única vez
4. Testar completamente

---

## 💡 RECOMENDAÇÃO

### **✅ RECOMENDO: Criar Projeto Primeiro**

**Motivos:**
- ✅ Organização melhor
- ✅ Documentação completa
- ✅ Implementação controlada
- ✅ Testes mais robustos
- ✅ Rollback mais fácil se necessário

**Quando criar projeto:**
- Após definir exatamente onde integrar
- Após documentar todas as mudanças
- Antes de fazer deploy em produção

---

## 📋 CHECKLIST

### **Já Feito:**
- [x] Conta criada no Sentry
- [x] Projeto criado (Browser JavaScript)
- [x] DSN obtido
- [x] Configuração pronta no arquivo local

### **Pendente:**
- [ ] Incluir script e configuração no código JavaScript
- [ ] Integrar função de logging onde erros ocorrem
- [ ] Testar integração
- [ ] Verificar no dashboard do Sentry
- [ ] Configurar alertas (opcional)

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA** - Explicação do que é e o que fazer

