# 🚀 GUIA: Configuração do Sentry para JavaScript no Navegador

**Data:** 26/11/2025  
**Contexto:** Passo a passo para configurar Sentry para logging de erros JavaScript em produção  
**Status:** 📋 **GUIA COMPLETO** - Configuração detalhada

---

## 📋 RESUMO EXECUTIVO

### **✅ Plataforma Correta:**
**"Browser JavaScript"** ou **"JavaScript"** (dependendo da versão do Sentry)

### **Por quê:**
- ✅ Código JavaScript roda no navegador do cliente
- ✅ Não é Node.js (servidor)
- ✅ Não é React/Vue/Angular (framework específico)
- ✅ É JavaScript puro no navegador

---

## 🎯 PASSO A PASSO: Configuração do Sentry

### **1. Criar Conta no Sentry**

1. Acessar: https://sentry.io/signup/
2. Criar conta (email + senha)
3. Confirmar email

---

### **2. Criar Projeto**

1. Após login, clicar em **"Create Project"**
2. Escolher plataforma: **"Browser JavaScript"** ou **"JavaScript"**
   - ⚠️ **NÃO escolher:** Node.js, React, Vue, Angular
   - ✅ **Escolher:** Browser JavaScript ou JavaScript
3. Nome do projeto: `bssegurosimediato-frontend` (ou nome de sua preferência)
4. Clicar em **"Create Project"**

---

### **3. Obter DSN (Data Source Name)**

Após criar projeto, Sentry fornece:

```
DSN: https://SEU_DSN@sentry.io/PROJECT_ID
```

**Exemplo:**
```
https://abc123def456@o123456.ingest.sentry.io/789012
```

**Onde encontrar:**
- Dashboard do projeto → **Settings** → **Client Keys (DSN)**
- Ou na tela inicial após criar projeto

**⚠️ IMPORTANTE:**
- DSN é **público** (pode estar no código JavaScript)
- DSN **NÃO permite ler dados**, apenas **enviar**
- É seguro expor DSN no código JavaScript

---

### **4. Configurar no Código JavaScript**

#### **4.1. Incluir SDK no HTML**

**Onde:** No `FooterCodeSiteDefinitivoCompleto.js` ou no HTML do Webflow

**Código:**
```html
<!-- Antes de </body> ou no início do FooterCode -->
<script src="https://browser.sentry-cdn.com/7.91.0/bundle.min.js"></script>
```

**Versão mais recente:**
- Verificar versão mais recente em: https://docs.sentry.io/platforms/javascript/install/cdn/
- Atualmente: `7.91.0` (pode mudar)

---

#### **4.2. Inicializar Sentry**

**Onde:** No `FooterCodeSiteDefinitivoCompleto.js` (após SDK ser carregado)

**Código:**
```javascript
// Inicializar Sentry (após SDK ser carregado)
if (typeof Sentry !== 'undefined') {
  Sentry.init({
    dsn: "https://SEU_DSN@sentry.io/PROJECT_ID", // Substituir pelo seu DSN
    environment: window.location.hostname.includes('dev') ? 'dev' : 'prod',
    tracesSampleRate: 0.1, // 10% das transações para performance
    
    // Sanitizar dados sensíveis ANTES de enviar
    beforeSend(event, hint) {
      // Remover dados sensíveis
      if (event.extra) {
        delete event.extra.ddd;
        delete event.extra.celular;
        delete event.extra.cpf;
        delete event.extra.nome;
        delete event.extra.email;
        delete event.extra.phone;
        delete event.extra.phone_number;
      }
      
      // Manter apenas metadados seguros
      return event;
    },
    
    // Ignorar erros específicos (opcional)
    ignoreErrors: [
      'ResizeObserver loop limit exceeded',
      'Non-Error promise rejection captured'
    ]
  });
}
```

---

#### **4.3. Função para Logar Erros**

**Onde:** No `MODAL_WHATSAPP_DEFINITIVO.js` ou onde erros são capturados

**Código:**
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
        environment: errorData.environment || (window.location.hostname.includes('dev') ? 'dev' : 'prod')
      },
      extra: {
        error: errorData.error,
        attempt: errorData.attempt,
        duration: errorData.duration,
        url: window.location.href,
        userAgent: navigator.userAgent,
        // ⚠️ Dados sensíveis serão removidos pelo beforeSend
        ddd: errorData.ddd,
        celular: errorData.celular,
        // ... outros dados
      }
    });
  } catch (err) {
    console.error('Falha ao logar no Sentry:', err);
  }
}
```

---

#### **4.4. Usar Quando Erro Ocorrer**

**Onde:** No `MODAL_WHATSAPP_DEFINITIVO.js` (onde erros são capturados)

**Código:**
```javascript
// Exemplo: Quando erro ocorre no fetchWithRetry
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
    duration: duration, // Tempo desde início do fetch
    ddd: ddd,        // Será sanitizado pelo beforeSend
    celular: celular // Será sanitizado pelo beforeSend
  });
  
  return { success: false, error: errorMsg, attempt: result.attempt + 1 };
}
```

---

## 🔍 VERIFICAÇÃO DA CONFIGURAÇÃO

### **1. Testar se Sentry Está Funcionando**

**Código de teste:**
```javascript
// Testar Sentry manualmente no console do navegador
if (typeof Sentry !== 'undefined') {
  Sentry.captureMessage('Teste de integração Sentry', {
    level: 'info',
    tags: { test: true }
  });
  console.log('✅ Sentry está funcionando! Verifique o dashboard.');
} else {
  console.error('❌ Sentry não está disponível. Verifique se SDK foi carregado.');
}
```

### **2. Verificar no Dashboard do Sentry**

1. Acessar: https://sentry.io/
2. Ir para projeto criado
3. Verificar se evento de teste aparece em **"Issues"** ou **"Events"**

---

## 📊 CONFIGURAÇÕES AVANÇADAS (Opcional)

### **1. Capturar Erros Automáticos**

**Código:**
```javascript
// Capturar erros não tratados automaticamente
window.addEventListener('error', function(event) {
  if (typeof Sentry !== 'undefined') {
    Sentry.captureException(event.error, {
      tags: {
        component: 'GLOBAL',
        type: 'unhandled_error'
      }
    });
  }
});

// Capturar rejeições de Promise não tratadas
window.addEventListener('unhandledrejection', function(event) {
  if (typeof Sentry !== 'undefined') {
    Sentry.captureException(event.reason, {
      tags: {
        component: 'GLOBAL',
        type: 'unhandled_promise_rejection'
      }
    });
  }
});
```

---

### **2. Adicionar Contexto do Usuário**

**Código:**
```javascript
// Adicionar contexto do usuário (sem dados sensíveis)
if (typeof Sentry !== 'undefined') {
  Sentry.setUser({
    // ❌ NÃO incluir: nome, email, telefone, CPF
    // ✅ APENAS: ID anônimo, se disponível
    id: generateSessionId(), // ID de sessão anônimo
    // ... outros dados não sensíveis
  });
}
```

---

### **3. Configurar Alertas**

1. Acessar: Dashboard do Sentry → **Alerts**
2. Criar alerta:
   - **Condição:** Quando novo erro ocorre
   - **Ação:** Enviar email/Slack
   - **Frequência:** Imediato ou resumo diário

---

## ⚠️ AVISOS IMPORTANTES

### **1. Dados Sensíveis:**
- ❌ **NUNCA enviar:** DDD, celular, CPF, nome, email
- ✅ **SEMPRE sanitizar:** Usar `beforeSend` para remover dados sensíveis
- ✅ **APENAS enviar:** Erro, componente, tentativa, duração, URL

### **2. DSN é Público:**
- ✅ **É seguro** expor DSN no código JavaScript
- ✅ DSN **NÃO permite ler dados**, apenas **enviar**
- ⚠️ Mas **NÃO compartilhar** DSN publicamente (melhor prática)

### **3. Rate Limiting:**
- ⚠️ Plano gratuito: 5.000 eventos/mês
- ⚠️ Se exceder, eventos podem ser descartados
- ✅ Monitorar uso no dashboard

---

## 📋 CHECKLIST DE CONFIGURAÇÃO

- [ ] Conta criada no Sentry
- [ ] Projeto criado com plataforma "Browser JavaScript"
- [ ] DSN obtido e copiado
- [ ] SDK incluído no HTML
- [ ] Sentry inicializado com DSN
- [ ] `beforeSend` configurado para sanitizar dados sensíveis
- [ ] Função `logErrorToSentry()` criada
- [ ] Função integrada onde erros ocorrem
- [ ] Teste realizado e verificado no dashboard
- [ ] Alertas configurados (opcional)

---

## 🎯 PRÓXIMOS PASSOS

1. ✅ **Criar conta e projeto no Sentry**
2. ✅ **Obter DSN**
3. ✅ **Adicionar SDK no HTML**
4. ✅ **Inicializar Sentry no JavaScript**
5. ✅ **Integrar função de logging onde erros ocorrem**
6. ✅ **Testar e verificar no dashboard**
7. ✅ **Configurar alertas (opcional)**

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **GUIA COMPLETO** - Configuração passo a passo documentada

