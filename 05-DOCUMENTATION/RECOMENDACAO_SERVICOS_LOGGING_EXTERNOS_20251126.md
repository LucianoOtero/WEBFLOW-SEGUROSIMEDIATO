# 🔍 RECOMENDAÇÃO: Serviços Externos de Logging para JavaScript

**Data:** 26/11/2025  
**Contexto:** Serviços externos de grande disponibilidade para logging temporário de erros via JavaScript  
**Status:** 📋 **RECOMENDAÇÃO** - Opções práticas e implementáveis

---

## 📋 RESUMO EXECUTIVO

### **Objetivo:**
Usar serviço externo de grande disponibilidade para registrar logs de erro via JavaScript, independente do servidor próprio (que pode estar com problemas de latência/conectividade).

### **Recomendações por Categoria:**

1. **🟢 Serviços Profissionais (Recomendados para Produção):**
   - Sentry (gratuito até 5k eventos/mês)
   - LogRocket (gratuito até 1k sessões/mês)
   - Rollbar (gratuito até 5k eventos/mês)

2. **🟡 Serviços Simples (Ideal para Teste Temporário):**
   - webhook.site (gratuito, ilimitado)
   - RequestBin (gratuito, temporário)
   - httpbin.org (gratuito, para testes)

3. **🔵 Serviços de Logging Dedicados:**
   - Better Stack (Logtail) - gratuito até 1GB/mês
   - Axiom - gratuito até 500MB/mês
   - Loggly - gratuito até 200MB/mês

---

## 🟢 OPÇÃO 1: Sentry (Recomendado para Produção)

### **Características:**
- ✅ **Gratuito:** Até 5.000 eventos/mês
- ✅ **Alta disponibilidade:** 99.9% SLA
- ✅ **Fácil integração:** SDK JavaScript simples
- ✅ **Rico em features:** Stack traces, contexto, breadcrumbs
- ✅ **Dashboard:** Interface web completa

### **Integração JavaScript:**

```javascript
// 1. Incluir SDK no HTML
<script src="https://browser.sentry-cdn.com/7.91.0/bundle.min.js"></script>

// 2. Inicializar
Sentry.init({
  dsn: "https://SEU_DSN@sentry.io/PROJECT_ID",
  environment: window.location.hostname.includes('dev') ? 'dev' : 'prod',
  tracesSampleRate: 0.1, // 10% das transações
});

// 3. Capturar erro
try {
  // código que pode falhar
} catch (error) {
  Sentry.captureException(error, {
    tags: {
      component: 'MODAL',
      action: 'octadesk_initial'
    },
    extra: {
      ddd: ddd,
      celular: celular,
      attempt: attempt
    }
  });
}

// 4. Capturar mensagem customizada
Sentry.captureMessage('whatsapp_modal_octadesk_initial_error', {
  level: 'error',
  tags: {
    component: 'MODAL',
    action: 'octadesk_initial'
  },
  extra: {
    error: errorMsg,
    attempt: attempt,
    duration: duration
  }
});
```

### **Vantagens:**
- ✅ Muito popular e confiável
- ✅ Dashboard completo
- ✅ Alertas por email/Slack
- ✅ Integração com GitHub, Jira, etc.
- ✅ Suporte a source maps

### **Desvantagens:**
- ⚠️ Requer cadastro e configuração
- ⚠️ Limite de 5k eventos/mês no plano gratuito

### **Link:**
- https://sentry.io/

---

## 🟡 OPÇÃO 2: webhook.site (⚠️ APENAS PARA TESTE - NÃO RECOMENDADO PARA PRODUÇÃO)

### **Características:**
- ✅ **Gratuito:** Ilimitado
- ✅ **Sem cadastro:** Gera URL única instantaneamente
- ✅ **Tempo de vida:** URL válida por tempo configurável
- ✅ **Visualização:** Interface web mostra requisições em tempo real
- ✅ **Simples:** Apenas fazer POST para URL

### **⚠️ AVISOS DE SEGURANÇA:**
- ❌ **NÃO é seguro para dados sensíveis** (DDD, celular, CPF, etc.)
- ❌ **URL pode ser descoberta** se código JavaScript for inspecionado
- ❌ **Dados são públicos** para quem tiver a URL
- ❌ **Sem criptografia end-to-end**
- ❌ **Sem garantia de privacidade** (LGPD/GDPR)
- ❌ **Sem SLA de disponibilidade**
- ⚠️ **Adequado APENAS para testes** sem dados sensíveis

### **Integração JavaScript:**

```javascript
// 1. Gerar URL única em https://webhook.site
// Exemplo: https://webhook.site/unique-id-12345

// 2. Função para logar erro
async function logErrorToWebhook(errorData) {
  const webhookUrl = 'https://webhook.site/unique-id-12345';
  
  try {
    await fetch(webhookUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        timestamp: new Date().toISOString(),
        error: errorData.error,
        component: errorData.component || 'MODAL',
        action: errorData.action || 'unknown',
        data: {
          ddd: errorData.ddd,
          celular: errorData.celular,
          attempt: errorData.attempt,
          duration: errorData.duration,
          url: window.location.href,
          userAgent: navigator.userAgent
        }
      })
    });
  } catch (err) {
    console.error('Falha ao logar no webhook:', err);
  }
}

// 3. Usar
logErrorToWebhook({
  error: 'whatsapp_modal_octadesk_initial_error',
  component: 'MODAL',
  action: 'octadesk_initial',
  ddd: ddd,
  celular: celular,
  attempt: attempt,
  duration: duration
});
```

### **Vantagens:**
- ✅ Zero configuração
- ✅ Ilimitado
- ✅ Visualização em tempo real
- ✅ Perfeito para testes temporários
- ✅ Não requer cadastro

### **Desvantagens:**
- ⚠️ URL temporária (expira após tempo configurado)
- ⚠️ Sem histórico permanente (apenas visualização)
- ⚠️ Não é adequado para produção

### **Link:**
- https://webhook.site/

---

## 🟡 OPÇÃO 3: RequestBin (Similar ao webhook.site)

### **Características:**
- ✅ **Gratuito:** Temporário
- ✅ **Sem cadastro:** Gera bin único
- ✅ **Tempo de vida:** 48 horas (gratuito) ou permanente (pago)
- ✅ **Visualização:** Interface web mostra requisições
- ✅ **Simples:** Apenas fazer POST para URL

### **Integração JavaScript:**

```javascript
// 1. Criar bin em https://requestbin.com
// Exemplo: https://requestbin.com/r/unique-id-12345

// 2. Função para logar erro (mesma estrutura do webhook.site)
async function logErrorToRequestBin(errorData) {
  const requestBinUrl = 'https://requestbin.com/r/unique-id-12345';
  
  try {
    await fetch(requestBinUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        timestamp: new Date().toISOString(),
        error: errorData.error,
        component: errorData.component || 'MODAL',
        action: errorData.action || 'unknown',
        data: errorData
      })
    });
  } catch (err) {
    console.error('Falha ao logar no RequestBin:', err);
  }
}
```

### **Vantagens:**
- ✅ Zero configuração
- ✅ Visualização em tempo real
- ✅ Perfeito para testes temporários

### **Desvantagens:**
- ⚠️ URL temporária (48h no plano gratuito)
- ⚠️ Não é adequado para produção

### **Link:**
- https://requestbin.com/

---

## 🔵 OPÇÃO 4: Better Stack (Logtail) - Logging Dedicado

### **Características:**
- ✅ **Gratuito:** Até 1GB/mês
- ✅ **Alta disponibilidade:** 99.9% SLA
- ✅ **Fácil integração:** API REST simples
- ✅ **Dashboard:** Interface web completa
- ✅ **Query:** Busca avançada nos logs

### **Integração JavaScript:**

```javascript
// 1. Obter Source Token em https://betterstack.com
const LOGTAIL_SOURCE_TOKEN = 'seu-source-token-aqui';

// 2. Função para logar erro
async function logErrorToLogtail(errorData) {
  const logtailUrl = 'https://in.logtail.com/';
  
  try {
    await fetch(logtailUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${LOGTAIL_SOURCE_TOKEN}`
      },
      body: JSON.stringify({
        dt: new Date().toISOString(),
        level: 'error',
        message: errorData.error,
        component: errorData.component || 'MODAL',
        action: errorData.action || 'unknown',
        ddd: errorData.ddd,
        celular: errorData.celular,
        attempt: errorData.attempt,
        duration: errorData.duration,
        url: window.location.href,
        userAgent: navigator.userAgent
      })
    });
  } catch (err) {
    console.error('Falha ao logar no Logtail:', err);
  }
}
```

### **Vantagens:**
- ✅ Focado em logging
- ✅ Query avançada
- ✅ Dashboard completo
- ✅ 1GB/mês gratuito (generoso)

### **Desvantagens:**
- ⚠️ Requer cadastro
- ⚠️ Limite de 1GB/mês no plano gratuito

### **Link:**
- https://betterstack.com/logtail

---

## 🔵 OPÇÃO 5: Axiom - Logging Dedicado

### **Características:**
- ✅ **Gratuito:** Até 500MB/mês
- ✅ **Alta disponibilidade:** 99.9% SLA
- ✅ **Fácil integração:** API REST simples
- ✅ **Dashboard:** Interface web completa
- ✅ **Query:** SQL-like queries

### **Integração JavaScript:**

```javascript
// 1. Obter API Token em https://axiom.co
const AXIOM_API_TOKEN = 'seu-api-token-aqui';
const AXIOM_DATASET = 'seu-dataset-aqui';

// 2. Função para logar erro
async function logErrorToAxiom(errorData) {
  const axiomUrl = `https://api.axiom.co/v1/datasets/${AXIOM_DATASET}/ingest`;
  
  try {
    await fetch(axiomUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${AXIOM_API_TOKEN}`
      },
      body: JSON.stringify([{
        _time: new Date().toISOString(),
        level: 'error',
        message: errorData.error,
        component: errorData.component || 'MODAL',
        action: errorData.action || 'unknown',
        ddd: errorData.ddd,
        celular: errorData.celular,
        attempt: errorData.attempt,
        duration: errorData.duration,
        url: window.location.href,
        userAgent: navigator.userAgent
      }])
    });
  } catch (err) {
    console.error('Falha ao logar no Axiom:', err);
  }
}
```

### **Vantagens:**
- ✅ Focado em logging
- ✅ Query SQL-like
- ✅ Dashboard completo
- ✅ 500MB/mês gratuito

### **Desvantagens:**
- ⚠️ Requer cadastro
- ⚠️ Limite de 500MB/mês no plano gratuito

### **Link:**
- https://axiom.co/

---

## 🟢 OPÇÃO 6: LogRocket - Error Tracking Profissional

### **Características:**
- ✅ **Gratuito:** Até 1.000 sessões/mês
- ✅ **Alta disponibilidade:** 99.9% SLA
- ✅ **Rico em features:** Session replay, console logs, network logs
- ✅ **Dashboard:** Interface web completa

### **Integração JavaScript:**

```javascript
// 1. Incluir SDK no HTML
<script src="https://cdn.logrocket.io/LogRocket.min.js"></script>

// 2. Inicializar
LogRocket.init('seu-app-id-aqui', {
  environment: window.location.hostname.includes('dev') ? 'dev' : 'prod',
});

// 3. Capturar erro
LogRocket.captureException(new Error('whatsapp_modal_octadesk_initial_error'), {
  tags: {
    component: 'MODAL',
    action: 'octadesk_initial'
  },
  extra: {
    ddd: ddd,
    celular: celular,
    attempt: attempt,
    duration: duration
  }
});

// 4. Capturar mensagem customizada
LogRocket.captureMessage('whatsapp_modal_octadesk_initial_error', {
  level: 'error',
  tags: {
    component: 'MODAL',
    action: 'octadesk_initial'
  },
  extra: {
    error: errorMsg,
    attempt: attempt,
    duration: duration
  }
});
```

### **Vantagens:**
- ✅ Session replay (vê o que usuário fez)
- ✅ Console logs e network logs
- ✅ Dashboard completo
- ✅ Muito popular

### **Desvantagens:**
- ⚠️ Requer cadastro
- ⚠️ Limite de 1k sessões/mês no plano gratuito

### **Link:**
- https://logrocket.com/

---

## 📊 COMPARAÇÃO RÁPIDA

| Serviço | Gratuito | Cadastro | Ideal Para | Complexidade |
|---------|----------|----------|------------|--------------|
| **Sentry** | 5k eventos/mês | Sim | Produção | Média |
| **webhook.site** | Ilimitado | Não | Teste temporário | Baixa |
| **RequestBin** | 48h | Não | Teste temporário | Baixa |
| **Better Stack** | 1GB/mês | Sim | Produção | Média |
| **Axiom** | 500MB/mês | Sim | Produção | Média |
| **LogRocket** | 1k sessões/mês | Sim | Produção | Média |

---

## 🎯 RECOMENDAÇÃO POR CASO DE USO

### **Para Teste Temporário (Imediato):**
✅ **webhook.site** ou **RequestBin**
- Zero configuração
- Ilimitado
- Perfeito para validar se logs estão sendo enviados

### **Para Produção (Longo Prazo):**
✅ **Sentry** ou **Better Stack (Logtail)**
- Alta disponibilidade
- Dashboard completo
- Alertas e integrações
- Histórico permanente

### **Para Debug Avançado:**
✅ **LogRocket**
- Session replay
- Console logs
- Network logs
- Vê exatamente o que usuário fez

---

## 💡 IMPLEMENTAÇÃO RECOMENDADA

### **Abordagem Híbrida (Recomendada):**

```javascript
// Função unificada que tenta múltiplos serviços
async function logErrorExternal(errorData) {
  const logs = [];
  
  // 1. Tentar logar no servidor próprio (fallback)
  try {
    await fetch('/log_endpoint.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(errorData)
    });
    logs.push('servidor_proprio: ok');
  } catch (err) {
    logs.push('servidor_proprio: falhou');
  }
  
  // 2. Tentar logar no webhook.site (temporário)
  try {
    await fetch('https://webhook.site/unique-id-12345', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        ...errorData,
        timestamp: new Date().toISOString(),
        source: 'external_logging'
      })
    });
    logs.push('webhook_site: ok');
  } catch (err) {
    logs.push('webhook_site: falhou');
  }
  
  // 3. Tentar logar no Sentry (se configurado)
  if (typeof Sentry !== 'undefined') {
    try {
      Sentry.captureMessage(errorData.error, {
        level: 'error',
        tags: {
          component: errorData.component,
          action: errorData.action
        },
        extra: errorData
      });
      logs.push('sentry: ok');
    } catch (err) {
      logs.push('sentry: falhou');
    }
  }
  
  console.log('Logs enviados:', logs);
}
```

---

## 📋 PRÓXIMOS PASSOS

### **Para Implementação Imediata (Teste):**

1. ✅ Acessar https://webhook.site/
2. ✅ Copiar URL única gerada
3. ✅ Adicionar função `logErrorToWebhook()` no JavaScript
4. ✅ Chamar função quando erro ocorrer
5. ✅ Visualizar logs em tempo real no webhook.site

### **Para Implementação de Produção:**

1. ✅ Criar conta no Sentry ou Better Stack
2. ✅ Obter DSN/Token
3. ✅ Incluir SDK no HTML
4. ✅ Configurar inicialização
5. ✅ Adicionar captura de erros
6. ✅ Configurar alertas

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **RECOMENDAÇÃO COMPLETA** - Opções práticas e implementáveis documentadas

