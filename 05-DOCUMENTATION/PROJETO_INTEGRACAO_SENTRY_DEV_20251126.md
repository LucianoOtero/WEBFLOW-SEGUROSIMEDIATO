# 📋 PROJETO: Integração Sentry em Desenvolvimento (DEV)

**Data de Criação:** 26/11/2025  
**Versão:** 1.0.0  
**Status:** 📋 **PROJETO CRIADO** - Aguardando autorização para execução  
**Ambiente:** 🟢 **DESENVOLVIMENTO (DEV)** - `dev.bssegurosimediato.com.br`

---

## 📋 RESUMO EXECUTIVO

### **Objetivo:**
Integrar o Sentry no ambiente de desenvolvimento para capturar e monitorar erros JavaScript em tempo real, permitindo diagnóstico rápido de problemas intermitentes como timeouts e falhas de requisições.

### **Escopo:**
- ✅ Incluir SDK do Sentry via CDN no `FooterCodeSiteDefinitivoCompleto.js`
- ✅ Configurar inicialização do Sentry com sanitização de dados sensíveis
- ✅ Integrar função de logging de erros no `MODAL_WHATSAPP_DEFINITIVO.js`
- ✅ Adicionar captura de erros nos pontos críticos (fetchWithRetry, endpoints)
- ✅ Configurar ambiente DEV no Sentry
- ✅ Testar integração e validar funcionamento

### **Arquivos Afetados:**
1. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
2. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`

### **Benefícios:**
- ✅ Monitoramento em tempo real de erros JavaScript
- ✅ Diagnóstico rápido de problemas intermitentes
- ✅ Stack traces completos para debugging
- ✅ Contexto detalhado de erros (URL, user agent, tentativas, duração)
- ✅ Sanitização automática de dados sensíveis (LGPD/GDPR compliant)
- ✅ Dashboard centralizado para visualização de erros

### **Quantidade de Chamadas ao Sentry:**
- ✅ **5 chamadas potenciais** (Opção Mínima - Recomendada)
  - 2 automáticas (event listeners - apenas quando erro ocorre)
  - 3 manuais (pontos críticos de erro)
- ⚠️ **Frequência:** Apenas quando erro ocorre (não em cada requisição)
- ✅ **Estimativa:** 2-4 eventos por dia (baseado em investigação de 26/11)
- ✅ **Plano gratuito:** 5.000 eventos/mês = ~166 eventos/dia (muito abaixo do limite)

### **Contexto:**
Este projeto é resultado da investigação de erros intermitentes em produção (`whatsapp_modal_octadesk_initial_error`, `whatsapp_modal_espocrm_update_error`) que identificou necessidade de melhor observabilidade de erros JavaScript no navegador.

---

## 🎯 ESPECIFICAÇÕES DO USUÁRIO

### **Requisitos Funcionais:**

1. ✅ **Capturar erros JavaScript automaticamente:**
   - Erros não tratados (unhandled errors)
   - Rejeições de Promise não tratadas (unhandled promise rejections)
   - Erros em funções críticas (fetchWithRetry, endpoints)

2. ✅ **Logar erros manualmente em pontos específicos:**
   - Quando `fetchWithRetry` falha após todas as tentativas
   - Quando endpoints retornam erro
   - Quando timeouts ocorrem

3. ✅ **Sanitizar dados sensíveis:**
   - Remover DDD, celular, CPF, nome, email antes de enviar
   - Manter apenas metadados seguros (erro, componente, tentativa, duração)

4. ✅ **Configurar ambiente DEV:**
   - Identificar automaticamente ambiente DEV vs PROD
   - Tagar eventos com ambiente correto
   - Filtrar eventos por ambiente no dashboard

5. ✅ **Testar integração:**
   - Validar que Sentry está capturando erros
   - Verificar que dados sensíveis são sanitizados
   - Confirmar que eventos aparecem no dashboard

### **Requisitos Não Funcionais:**

1. ✅ **Segurança:**
   - Dados sensíveis nunca enviados ao Sentry
   - Conformidade LGPD/GDPR
   - HTTPS obrigatório

2. ✅ **Performance:**
   - SDK assíncrono (não bloqueia aplicação)
   - Sampling de transações (10% para performance)
   - Não impactar tempo de carregamento da página

3. ✅ **Manutenibilidade:**
   - Código limpo e documentado
   - Funções reutilizáveis
   - Fácil de desabilitar se necessário

4. ✅ **Observabilidade:**
   - Dashboard completo no Sentry
   - Alertas configuráveis (opcional)
   - Histórico de erros

### **Critérios de Aceitação:**

1. ✅ **Sentry está funcionando:**
   - SDK carregado e inicializado
   - Eventos de teste aparecem no dashboard
   - Erros são capturados automaticamente

2. ✅ **Dados sensíveis são sanitizados:**
   - DDD, celular, CPF, nome, email não aparecem no Sentry
   - Apenas metadados seguros são enviados

3. ✅ **Erros são logados corretamente:**
   - Erros em `fetchWithRetry` são capturados
   - Erros em endpoints são capturados
   - Contexto completo está disponível (tentativas, duração, URL)

4. ✅ **Ambiente DEV está configurado:**
   - Eventos são tagados com `environment: dev`
   - Filtros por ambiente funcionam no dashboard

5. ✅ **Não há impacto negativo:**
   - Página carrega normalmente
   - Performance não é afetada
   - Funcionalidades existentes continuam funcionando

---

## 📊 ANÁLISE TÉCNICA

### **Estrutura Atual:**

#### **1. FooterCodeSiteDefinitivoCompleto.js**

**Características:**
- Arquivo JavaScript principal do site
- Carregado em todas as páginas
- Contém funções globais e helpers
- Local ideal para inicializar Sentry

**Onde incluir Sentry:**
- Início do arquivo (após helpers básicos)
- Ou no final do arquivo (antes de funções específicas)

#### **2. MODAL_WHATSAPP_DEFINITIVO.js**

**Características:**
- Contém função `fetchWithRetry` (linha 479)
- Contém função `logEvent` (linha 259)
- Contém funções de erro (`enviarMensagemInicialOctadesk`, `atualizarLeadEspoCRM`)
- Local ideal para integrar logging do Sentry

**Onde integrar:**
- Função `fetchWithRetry` - capturar erros de timeout/rede
- Função `logEvent` - adicionar logging do Sentry
- Funções de erro - capturar erros específicos

---

### **Configuração do Sentry:**

#### **DSN e Configuração:**
- **DSN:** `https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424`
- **SDK CDN:** `https://js-de.sentry-cdn.com/9cbeefde9ce7c0b959b51a4c5e6e52dd.min.js`
- **Ambiente:** DEV (detectado automaticamente via `window.location.hostname`)

#### **Sanitização de Dados:**
```javascript
beforeSend(event, hint) {
  if (event.extra) {
    delete event.extra.ddd;
    delete event.extra.celular;
    delete event.extra.cpf;
    delete event.extra.nome;
    delete event.extra.email;
    delete event.extra.phone;
    delete event.extra.phone_number;
  }
  return event;
}
```

---

## 🔧 IMPLEMENTAÇÃO

### **FASE 1: Preparação e Backup**

#### **1.1. Criar Backups**

**Arquivos a fazer backup:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`

**Localização dos backups:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/FooterCodeSiteDefinitivoCompleto_SENTRY_backup_YYYYMMDD_HHMMSS.js`
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/MODAL_WHATSAPP_DEFINITIVO_SENTRY_backup_YYYYMMDD_HHMMSS.js`

**Comando:**
```bash
# Criar diretório de backups se não existir
mkdir -p "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups"

# Criar backups com timestamp
cp "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js" "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/FooterCodeSiteDefinitivoCompleto_SENTRY_backup_$(date +%Y%m%d_%H%M%S).js"
cp "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js" "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/MODAL_WHATSAPP_DEFINITIVO_SENTRY_backup_$(date +%Y%m%d_%H%M%S).js"
```

---

### **FASE 2: Incluir SDK e Configuração no FooterCode**

#### **2.1. Localização da Inclusão**

**Onde incluir:**
- Início do arquivo (após helpers básicos, antes de linha ~200)
- Ou no final do arquivo (antes de funções específicas)

**Estrutura proposta:**
```javascript
// FooterCodeSiteDefinitivoCompleto.js

// ... código existente (helpers básicos) ...

// ======================
// SENTRY ERROR TRACKING
// Integração: 26/11/2025
// Ambiente: DEV
// ======================

// Incluir SDK do Sentry (via CDN)
(function() {
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initSentry);
  } else {
    initSentry();
  }
  
  function initSentry() {
    // Carregar SDK do Sentry
    const script = document.createElement('script');
    script.src = 'https://js-de.sentry-cdn.com/9cbeefde9ce7c0b959b51a4c5e6e52dd.min.js';
    script.crossOrigin = 'anonymous';
    script.onload = function() {
      // Inicializar Sentry após SDK carregar
      if (typeof Sentry !== 'undefined') {
        Sentry.onLoad(function() {
          Sentry.init({
            dsn: "https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424",
            environment: window.location.hostname.includes('dev') ? 'dev' : 'prod',
            tracesSampleRate: 0.1, // 10% das transações para performance
            
            // Sanitizar dados sensíveis ANTES de enviar
            beforeSend(event, hint) {
              if (event.extra) {
                delete event.extra.ddd;
                delete event.extra.celular;
                delete event.extra.cpf;
                delete event.extra.nome;
                delete event.extra.email;
                delete event.extra.phone;
                delete event.extra.phone_number;
              }
              return event;
            },
            
            // Ignorar erros específicos (opcional)
            ignoreErrors: [
              'ResizeObserver loop limit exceeded',
              'Non-Error promise rejection captured'
            ]
          });
        });
      }
    };
    document.head.appendChild(script);
  }
})();

// ... resto do código existente ...
```

---

### **FASE 3: Integrar Função de Logging no Modal**

#### **3.1. Adicionar Função logErrorToSentry**

**Onde adicionar:**
- No `MODAL_WHATSAPP_DEFINITIVO.js`, após função `logEvent` (após linha ~281)

**Código:**
```javascript
// MODAL_WHATSAPP_DEFINITIVO.js

// ... função logEvent existente (linha 259-281) ...

/**
 * Função para logar erro no Sentry
 * 
 * @param {Object} errorData - Dados do erro
 * @param {string} errorData.error - Mensagem de erro
 * @param {string} errorData.component - Componente onde erro ocorreu
 * @param {string} errorData.action - Ação que causou erro
 * @param {number} errorData.attempt - Número da tentativa
 * @param {number} errorData.duration - Duração em ms
 */
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
        url: window.location.href,
        userAgent: navigator.userAgent,
        // ⚠️ Dados sensíveis serão removidos pelo beforeSend
        ddd: errorData.ddd,
        celular: errorData.celular,
      }
    });
  } catch (err) {
    console.error('Falha ao logar no Sentry:', err);
  }
}
```

---

#### **3.2. Integrar em fetchWithRetry**

**Onde integrar:**
- Na função `fetchWithRetry` (linha 479), quando erro ocorre após todas as tentativas

**Código:**
```javascript
// MODAL_WHATSAPP_DEFINITIVO.js - função fetchWithRetry (linha 479)

async function fetchWithRetry(url, options, maxRetries = 2, retryDelay = 1000) {
  const startTime = Date.now(); // Medir duração
  
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 30000); // 30s timeout
      
      const response = await fetch(url, {
        ...options,
        signal: controller.signal
      });
      
      clearTimeout(timeoutId);
      
      if (response.ok || response.status < 500) {
        return { success: true, response, attempt };
      }
      
      // Retry apenas para erros 5xx (servidor) ou timeout
      if (attempt < maxRetries && (response.status >= 500 || response.status === 408)) {
        if (window.novo_log) {
          window.novo_log('WARN', 'MODAL', `Tentativa ${attempt + 1}/${maxRetries + 1} falhou, tentando novamente...`, null, 'ERROR_HANDLING', 'SIMPLE');
        }
        await new Promise(resolve => setTimeout(resolve, retryDelay * (attempt + 1)));
        continue;
      }
      
      return { success: false, response, attempt };
      
    } catch (error) {
      const duration = Date.now() - startTime; // Calcular duração
      
      // Erro de rede ou timeout - tentar retry
      if (attempt < maxRetries && (error.name === 'TypeError' || error.name === 'AbortError')) {
        if (window.novo_log) {
          window.novo_log('WARN', 'MODAL', `Erro de rede na tentativa ${attempt + 1}/${maxRetries + 1}, retry...`, null, 'ERROR_HANDLING', 'SIMPLE');
        }
        await new Promise(resolve => setTimeout(resolve, retryDelay * (attempt + 1)));
        continue;
      }
      
      // Todas as tentativas falharam - logar no Sentry
      if (typeof logErrorToSentry === 'function') {
        logErrorToSentry({
          error: error.name === 'AbortError' ? 'fetch_timeout' : 'fetch_network_error',
          component: 'MODAL',
          action: 'fetchWithRetry',
          attempt: attempt + 1,
          duration: duration,
          errorMessage: error.message,
          url: url
        });
      }
      
      return { success: false, error, attempt };
    }
  }
}
```

---

#### **3.3. Integrar em Funções de Erro Específicas**

**Onde integrar:**
- Função `enviarMensagemInicialOctadesk` (linha ~1342) - quando erro ocorre
- Função `atualizarLeadEspoCRM` (linha ~911) - quando erro ocorre

**Código (exemplo para Octadesk):**
```javascript
// MODAL_WHATSAPP_DEFINITIVO.js - função enviarMensagemInicialOctadesk (linha ~1342)

// ... código existente ...

if (result.response && result.response.ok) {
  return { success: result.response.ok, attempt: result.attempt + 1 };
} else {
  const errorMsg = result.error?.message || 'Erro desconhecido';
  
  // Logar no sistema próprio (existente)
  debugLog('OCTADESK', 'INITIAL_REQUEST_ERROR', {
    error: errorMsg,
    attempt: result.attempt + 1
  }, 'error');
  logEvent('whatsapp_modal_octadesk_initial_error', { 
    error: errorMsg, 
    attempt: result.attempt + 1 
  }, 'error');
  
  // Logar no Sentry (novo)
  if (typeof logErrorToSentry === 'function') {
    logErrorToSentry({
      error: 'whatsapp_modal_octadesk_initial_error',
      component: 'MODAL',
      action: 'octadesk_initial',
      attempt: result.attempt + 1,
      duration: result.duration || 0,
      errorMessage: errorMsg,
      ddd: ddd,        // Será sanitizado pelo beforeSend
      celular: celular // Será sanitizado pelo beforeSend
    });
  }
  
  return { success: false, error: errorMsg, attempt: result.attempt + 1 };
}
```

---

### **FASE 4: Adicionar Captura Automática de Erros**

#### **4.1. Capturar Erros Não Tratados**

**Onde adicionar:**
- No `FooterCodeSiteDefinitivoCompleto.js`, após inicialização do Sentry

**Código:**
```javascript
// FooterCodeSiteDefinitivoCompleto.js - após inicialização do Sentry

// Capturar erros não tratados automaticamente
if (typeof Sentry !== 'undefined') {
  window.addEventListener('error', function(event) {
    Sentry.captureException(event.error, {
      tags: {
        component: 'GLOBAL',
        type: 'unhandled_error'
      },
      extra: {
        message: event.message,
        filename: event.filename,
        lineno: event.lineno,
        colno: event.colno
      }
    });
  });
  
  // Capturar rejeições de Promise não tratadas
  window.addEventListener('unhandledrejection', function(event) {
    Sentry.captureException(event.reason, {
      tags: {
        component: 'GLOBAL',
        type: 'unhandled_promise_rejection'
      },
      extra: {
        reason: event.reason
      }
    });
  });
}
```

---

### **FASE 5: Testar Integração**

#### **5.1. Teste Manual**

**Teste 1: Verificar se SDK está carregado**
```javascript
// No console do navegador
console.log(typeof Sentry); // Deve retornar "object"
```

**Teste 2: Enviar evento de teste**
```javascript
// No console do navegador
if (typeof Sentry !== 'undefined') {
  Sentry.captureMessage('Teste de integração Sentry DEV', {
    level: 'info',
    tags: { test: true, environment: 'dev' }
  });
  console.log('✅ Evento de teste enviado! Verifique o dashboard do Sentry.');
}
```

**Teste 3: Causar erro proposital**
```javascript
// No console do navegador
myUndefinedFunction(); // Vai causar erro e ser capturado pelo Sentry
```

**Teste 4: Verificar sanitização**
```javascript
// No console do navegador
if (typeof Sentry !== 'undefined') {
  Sentry.captureMessage('Teste de sanitização', {
    level: 'info',
    extra: {
      ddd: '11',
      celular: '987654321',
      cpf: '12345678901',
      nome: 'Teste',
      email: 'teste@teste.com'
    }
  });
  // Verificar no dashboard que dados sensíveis foram removidos
}
```

---

#### **5.2. Teste Funcional**

**Teste 1: Simular erro em fetchWithRetry**
- Fazer requisição que vai falhar (timeout ou erro de rede)
- Verificar se erro aparece no Sentry
- Verificar se contexto está completo (tentativas, duração, URL)

**Teste 2: Simular erro em endpoint**
- Fazer requisição para endpoint que retorna erro
- Verificar se erro aparece no Sentry
- Verificar se dados sensíveis foram sanitizados

**Teste 3: Verificar performance**
- Medir tempo de carregamento da página antes e depois
- Verificar se não há impacto negativo

---

### **FASE 6: Deploy para Servidor DEV**

#### **6.1. Copiar Arquivos para Servidor**

**Servidor:** `dev.bssegurosimediato.com.br` (65.108.156.14)  
**Caminho:** `/var/www/html/dev/root/`

**Comandos:**
```bash
# Copiar FooterCodeSiteDefinitivoCompleto.js
scp "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js" root@65.108.156.14:/var/www/html/dev/root/

# Copiar MODAL_WHATSAPP_DEFINITIVO.js
scp "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js" root@65.108.156.14:/var/www/html/dev/root/

# Verificar hash após cópia
ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js"
ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js"
```

---

#### **6.2. Verificar Funcionamento no Servidor**

**Testes:**
1. Acessar `https://dev.bssegurosimediato.com.br/`
2. Abrir console do navegador
3. Verificar se Sentry está carregado (`typeof Sentry`)
4. Enviar evento de teste
5. Verificar no dashboard do Sentry se evento aparece

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Risco 1: SDK do Sentry Não Carrega**

**Probabilidade:** Baixa  
**Impacto:** Médio  
**Mitigação:**
- Verificar se CDN está acessível
- Adicionar fallback (tentar outro CDN)
- Verificar console do navegador para erros de carregamento
- Testar em diferentes navegadores

---

### **Risco 2: Dados Sensíveis Enviados ao Sentry**

**Probabilidade:** Baixa  
**Impacto:** Alto (LGPD/GDPR)  
**Mitigação:**
- ✅ `beforeSend` remove dados sensíveis automaticamente
- ✅ Testar sanitização antes de deploy
- ✅ Revisar eventos no dashboard após deploy
- ✅ Monitorar logs do Sentry para garantir sanitização

---

### **Risco 3: Impacto na Performance**

**Probabilidade:** Baixa  
**Impacto:** Baixo  
**Mitigação:**
- ✅ SDK é assíncrono (não bloqueia aplicação)
- ✅ Sampling de transações (10% apenas)
- ✅ Testar tempo de carregamento antes e depois
- ✅ Monitorar performance no Sentry

---

### **Risco 4: Quebrar Funcionalidades Existentes**

**Probabilidade:** Baixa  
**Impacto:** Médio  
**Mitigação:**
- ✅ Criar backups antes de modificar
- ✅ Testar todas as funcionalidades após integração
- ✅ Verificar se `logEvent` e outras funções continuam funcionando
- ✅ Plano de rollback documentado

---

### **Risco 5: Sentry Indisponível**

**Probabilidade:** Muito Baixa (99.9% SLA)  
**Impacto:** Baixo  
**Mitigação:**
- ✅ Verificar se Sentry está disponível antes de usar
- ✅ Fallback: continuar usando sistema de logging próprio
- ✅ Não bloquear aplicação se Sentry falhar
- ✅ Monitorar status do Sentry

---

## 🔄 PLANO DE ROLLBACK

### **Cenário 1: Sentry Causa Problemas**

**Passos:**
1. Remover código do Sentry dos arquivos JavaScript
2. Restaurar backups originais
3. Copiar arquivos restaurados para servidor DEV
4. Verificar hash após cópia
5. Testar funcionalidades
6. Limpar cache do Cloudflare

**Comandos:**
```bash
# Restaurar backups
cp "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/FooterCodeSiteDefinitivoCompleto_SENTRY_backup_YYYYMMDD_HHMMSS.js" "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js"
cp "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/MODAL_WHATSAPP_DEFINITIVO_SENTRY_backup_YYYYMMDD_HHMMSS.js" "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js"

# Copiar para servidor
scp "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js" root@65.108.156.14:/var/www/html/dev/root/
scp "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js" root@65.108.156.14:/var/www/html/dev/root/

# Verificar hash
ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js"
ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js"
```

---

### **Cenário 2: Desabilitar Sentry Temporariamente**

**Passos:**
1. Comentar inicialização do Sentry
2. Comentar chamadas a `logErrorToSentry`
3. Manter código para reativar facilmente
4. Copiar arquivos modificados para servidor

**Código:**
```javascript
// Desabilitar Sentry temporariamente
/*
if (typeof Sentry !== 'undefined') {
  Sentry.init({ ... });
}
*/

// Comentar chamadas
/*
if (typeof logErrorToSentry === 'function') {
  logErrorToSentry({ ... });
}
*/
```

---

## 👥 STAKEHOLDERS

### **Stakeholders Identificados:**

1. **Usuário Final:**
   - **Impacto:** Positivo - Melhor diagnóstico de erros, menos problemas
   - **Interesse:** Alta - Quer que sistema funcione corretamente

2. **Equipe de Desenvolvimento:**
   - **Impacto:** Positivo - Melhor observabilidade, diagnóstico mais rápido
   - **Interesse:** Alta - Facilita debugging e resolução de problemas

3. **Infraestrutura:**
   - **Impacto:** Neutro - Não afeta infraestrutura diretamente
   - **Interesse:** Média - Monitoramento adicional pode ajudar

4. **Administrador do Sistema:**
   - **Impacto:** Positivo - Dashboard centralizado, alertas configuráveis
   - **Interesse:** Alta - Melhor visibilidade de problemas

---

## 📅 CRONOGRAMA

### **Tempo Estimado:** 2-3 horas

| Fase | Descrição | Tempo Estimado |
|------|-----------|----------------|
| **FASE 1** | Preparação e Backup | 15 minutos |
| **FASE 2** | Incluir SDK e Configuração no FooterCode | 30 minutos |
| **FASE 3** | Integrar Função de Logging no Modal | 45 minutos |
| **FASE 4** | Adicionar Captura Automática de Erros | 20 minutos |
| **FASE 5** | Testar Integração | 30 minutos |
| **FASE 6** | Deploy para Servidor DEV | 20 minutos |
| **TOTAL** | | **2h 40min** |

---

## ✅ TESTES E VALIDAÇÃO

### **Testes Obrigatórios:**

1. ✅ **Teste de Carregamento:**
   - SDK do Sentry carrega corretamente
   - Sentry inicializa sem erros
   - Console do navegador não mostra erros

2. ✅ **Teste de Captura:**
   - Erros não tratados são capturados
   - Rejeições de Promise são capturadas
   - Erros manuais são logados corretamente

3. ✅ **Teste de Sanitização:**
   - Dados sensíveis não aparecem no Sentry
   - Apenas metadados seguros são enviados
   - `beforeSend` funciona corretamente

4. ✅ **Teste de Ambiente:**
   - Eventos são tagados com `environment: dev`
   - Filtros por ambiente funcionam no dashboard

5. ✅ **Teste de Performance:**
   - Tempo de carregamento não é afetado
   - SDK não bloqueia aplicação
   - Funcionalidades existentes continuam funcionando

6. ✅ **Teste de Funcionalidade:**
   - `logEvent` continua funcionando
   - `fetchWithRetry` continua funcionando
   - Endpoints continuam funcionando
   - Modal WhatsApp continua funcionando

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Preparação:**
- [ ] Criar backups dos arquivos originais
- [ ] Verificar se arquivos de backup foram criados
- [ ] Verificar hash dos arquivos originais

### **Implementação:**
- [ ] Incluir SDK e configuração no FooterCode
- [ ] Adicionar função `logErrorToSentry` no Modal
- [ ] Integrar em `fetchWithRetry`
- [ ] Integrar em funções de erro específicas
- [ ] Adicionar captura automática de erros

### **Testes:**
- [ ] Testar carregamento do SDK
- [ ] Testar captura de erros
- [ ] Testar sanitização de dados
- [ ] Testar ambiente DEV
- [ ] Testar performance
- [ ] Testar funcionalidades existentes

### **Deploy:**
- [ ] Copiar arquivos para servidor DEV
- [ ] Verificar hash após cópia
- [ ] Testar no servidor DEV
- [ ] Verificar eventos no dashboard do Sentry
- [ ] Limpar cache do Cloudflare (avisar usuário)

---

## 📊 MÉTRICAS DE SUCESSO

### **Métricas a Monitorar:**

1. ✅ **Eventos Capturados:**
   - Número de erros capturados por dia
   - Tipos de erros mais comuns
   - Taxa de erros por componente

2. ✅ **Tempo de Resolução:**
   - Tempo médio para identificar causa raiz
   - Tempo médio para resolver problemas
   - Redução no tempo de diagnóstico

3. ✅ **Performance:**
   - Tempo de carregamento da página (antes/depois)
   - Impacto do SDK na performance
   - Taxa de sucesso de requisições

4. ✅ **Qualidade:**
   - Dados sensíveis nunca enviados (0 ocorrências)
   - Eventos corretamente tagados com ambiente
   - Contexto completo disponível

---

## 📝 DOCUMENTAÇÃO RELACIONADA

### **Documentos de Referência:**

1. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/RELATORIO_COMPLETO_INVESTIGACAO_ERRO_PRODUCAO_20251126.md`
   - Contexto da investigação que levou a este projeto

2. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/RECOMENDACAO_LOGGING_PRODUCAO_20251126.md`
   - Recomendação de usar Sentry para produção

3. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/GUIA_CONFIGURACAO_SENTRY_20251126.md`
   - Guia de configuração do Sentry

4. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/sentry.config.local.js`
   - Configuração local do Sentry (não versionado)

5. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/ANALISE_TELA_SETUP_SENTRY_20251126.md`
   - Análise da tela de setup do Sentry

---

## 🎯 PRÓXIMOS PASSOS APÓS IMPLEMENTAÇÃO

### **Após Implementação em DEV:**

1. ✅ **Monitorar por 1-2 semanas:**
   - Verificar se erros estão sendo capturados
   - Analisar padrões de erros
   - Validar que sanitização está funcionando

2. ✅ **Configurar Alertas (Opcional):**
   - Alertas por email quando novo erro ocorre
   - Alertas por Slack (se configurado)
   - Alertas para erros críticos

3. ✅ **Documentar Padrões:**
   - Documentar tipos de erros mais comuns
   - Documentar como usar dashboard do Sentry
   - Criar runbook para análise de erros

4. ✅ **Planejar para Produção:**
   - Avaliar se implementação em DEV foi bem-sucedida
   - Criar projeto para produção (se necessário)
   - Replicar implementação em produção

---

**Documento criado em:** 26/11/2025  
**Status:** 📋 **PROJETO CRIADO** - Aguardando autorização para execução  
**Próximo passo:** Apresentar projeto ao usuário e aguardar autorização

