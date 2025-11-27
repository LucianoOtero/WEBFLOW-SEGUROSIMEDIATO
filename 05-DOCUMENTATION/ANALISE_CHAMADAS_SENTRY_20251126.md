# 🔍 ANÁLISE: Quantidade de Chamadas ao Sentry

**Data:** 26/11/2025  
**Contexto:** Análise de quantas chamadas ao Sentry serão feitas nos arquivos JavaScript  
**Status:** 📋 **ANÁLISE** - Contagem detalhada de chamadas

---

## 📊 RESUMO EXECUTIVO

### **Total de Chamadas ao Sentry: 5-8 chamadas potenciais**

**Distribuição:**
- ✅ **2 chamadas automáticas** (event listeners - apenas quando erro ocorre)
- ✅ **3-6 chamadas manuais** (em pontos específicos de erro)

**Frequência:**
- ⚠️ **Apenas quando erro ocorre** (não em cada requisição)
- ⚠️ **Depende de frequência de erros** no sistema

---

## 🔍 ANÁLISE DETALHADA

### **1. Chamadas Automáticas (Event Listeners)**

#### **1.1. Erros Não Tratados (window.addEventListener('error'))**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js`  
**Tipo:** Automático  
**Frequência:** Apenas quando erro JavaScript não tratado ocorre

**Código:**
```javascript
window.addEventListener('error', function(event) {
  Sentry.captureException(event.error, { ... });
});
```

**Quando é chamado:**
- Erro JavaScript não capturado por try/catch
- Erro de sintaxe em tempo de execução
- Erro em código de terceiros

**Estimativa de frequência:**
- ⚠️ **Baixa** - Apenas quando há erro não tratado
- ⚠️ **Depende de qualidade do código** e erros de terceiros

---

#### **1.2. Rejeições de Promise Não Tratadas (window.addEventListener('unhandledrejection'))**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js`  
**Tipo:** Automático  
**Frequência:** Apenas quando Promise rejeitada não é tratada

**Código:**
```javascript
window.addEventListener('unhandledrejection', function(event) {
  Sentry.captureException(event.reason, { ... });
});
```

**Quando é chamado:**
- Promise rejeitada sem `.catch()`
- `async/await` sem try/catch
- Erro em Promise não tratada

**Estimativa de frequência:**
- ⚠️ **Muito baixa** - Apenas quando há Promise não tratada
- ⚠️ **Depende de qualidade do código**

---

### **2. Chamadas Manuais em fetchWithRetry**

#### **2.1. Erro Após Todas as Tentativas**

**Localização:** `MODAL_WHATSAPP_DEFINITIVO.js` - função `fetchWithRetry` (linha 479)  
**Tipo:** Manual  
**Frequência:** Apenas quando todas as 3 tentativas falham

**Código:**
```javascript
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
```

**Quando é chamado:**
- Quando `fetchWithRetry` falha após 3 tentativas (0, 1, 2)
- Timeout de 30s em todas as tentativas
- Erro de rede em todas as tentativas

**Estimativa de frequência:**
- ⚠️ **Baixa** - Apenas quando há erro persistente
- ⚠️ **Baseado em investigação:** 4 erros em 26/11 (intermitente)

**Onde é usado:**
- `enviarMensagemInicialOctadesk` - chama `fetchWithRetry`
- `atualizarLeadEspoCRM` - chama `fetchWithRetry`
- Outras funções que usam `fetchWithRetry`

**Total de pontos que usam fetchWithRetry:** ~2-3 funções

---

### **3. Chamadas Manuais em Funções Específicas**

#### **3.1. Erro em enviarMensagemInicialOctadesk**

**Localização:** `MODAL_WHATSAPP_DEFINITIVO.js` - linha ~1413  
**Tipo:** Manual  
**Frequência:** Apenas quando erro ocorre após `fetchWithRetry`

**Código:**
```javascript
// Logar no Sentry (novo)
if (typeof logErrorToSentry === 'function') {
  logErrorToSentry({
    error: 'whatsapp_modal_octadesk_initial_error',
    component: 'MODAL',
    action: 'octadesk_initial',
    attempt: result.attempt + 1,
    duration: result.duration || 0,
    errorMessage: errorMsg,
    ddd: ddd,
    celular: celular
  });
}
```

**Quando é chamado:**
- Quando `enviarMensagemInicialOctadesk` retorna erro
- Após `fetchWithRetry` falhar

**Estimativa de frequência:**
- ⚠️ **Baixa** - Apenas quando há erro
- ⚠️ **Baseado em investigação:** 2 erros em 26/11

---

#### **3.2. Erro em atualizarLeadEspoCRM**

**Localização:** `MODAL_WHATSAPP_DEFINITIVO.js` - linha ~1276  
**Tipo:** Manual  
**Frequência:** Apenas quando erro ocorre após `fetchWithRetry`

**Código:**
```javascript
// Logar no Sentry (novo)
if (typeof logErrorToSentry === 'function') {
  logErrorToSentry({
    error: 'whatsapp_modal_espocrm_update_error',
    component: 'MODAL',
    action: 'espocrm_update',
    attempt: result.attempt + 1,
    duration: result.duration || 0,
    errorMessage: errorMsg
  });
}
```

**Quando é chamado:**
- Quando `atualizarLeadEspoCRM` retorna erro
- Após `fetchWithRetry` falhar

**Estimativa de frequência:**
- ⚠️ **Baixa** - Apenas quando há erro
- ⚠️ **Baseado em investigação:** 2 erros em 26/11

---

## 📊 CONTAGEM TOTAL

### **Chamadas Automáticas:**
1. ✅ `window.addEventListener('error')` - Erros não tratados
2. ✅ `window.addEventListener('unhandledrejection')` - Promise rejeitadas não tratadas

**Total:** 2 chamadas automáticas (apenas quando erro ocorre)

---

### **Chamadas Manuais:**

#### **Opção 1: Mínima (Recomendada para Começar)**
1. ✅ `fetchWithRetry` - Quando todas as tentativas falham
2. ✅ `enviarMensagemInicialOctadesk` - Quando erro ocorre
3. ✅ `atualizarLeadEspoCRM` - Quando erro ocorre

**Total:** 3 chamadas manuais

#### **Opção 2: Completa (Todos os Pontos de Erro)**
1. ✅ `fetchWithRetry` - Quando todas as tentativas falham
2. ✅ `enviarMensagemInicialOctadesk` - Quando erro ocorre
3. ✅ `atualizarLeadEspoCRM` - Quando erro ocorre (initial)
4. ✅ `atualizarLeadEspoCRM` - Quando erro ocorre (update) - linha 1276
5. ✅ `enviarMensagemOctadesk` - Quando erro ocorre (outra função) - linha 1484
6. ✅ Exceções não tratadas - Quando exception ocorre

**Total:** 6 chamadas manuais

---

### **Total Geral:**

**Opção 1 (Mínima):**
- 2 automáticas + 3 manuais = **5 chamadas potenciais**

**Opção 2 (Completa):**
- 2 automáticas + 6 manuais = **8 chamadas potenciais**

---

## 📊 FREQUÊNCIA ESTIMADA

### **Baseado em Investigação (26/11/2025):**

**Erros observados:**
- 4 erros no dia 26/11
- 2 erros de `whatsapp_modal_octadesk_initial_error`
- 2 erros de `whatsapp_modal_espocrm_update_error`

**Estimativa:**
- ⚠️ **4-8 eventos por dia** (se todos os pontos forem integrados)
- ⚠️ **2-4 eventos por dia** (se apenas pontos críticos forem integrados)

**Plano gratuito do Sentry:**
- ✅ **5.000 eventos/mês** = ~166 eventos/dia
- ✅ **Muito abaixo do limite** mesmo com 8 chamadas potenciais

---

## 🎯 RECOMENDAÇÃO

### **Opção 1: Mínima (Recomendada para Começar)**

**Chamadas:**
1. ✅ Event listener para erros não tratados
2. ✅ Event listener para promise rejections
3. ✅ `fetchWithRetry` - quando todas tentativas falham
4. ✅ `enviarMensagemInicialOctadesk` - quando erro ocorre
5. ✅ `atualizarLeadEspoCRM` - quando erro ocorre

**Total:** 5 chamadas potenciais

**Vantagens:**
- ✅ Cobre pontos críticos identificados na investigação
- ✅ Não sobrecarrega com muitos logs
- ✅ Fácil de expandir depois se necessário

---

### **Opção 2: Completa (Todos os Pontos)**

**Chamadas:**
1. ✅ Event listener para erros não tratados
2. ✅ Event listener para promise rejections
3. ✅ `fetchWithRetry` - quando todas tentativas falham
4. ✅ `enviarMensagemInicialOctadesk` - quando erro ocorre
5. ✅ `atualizarLeadEspoCRM` (initial) - quando erro ocorre
6. ✅ `atualizarLeadEspoCRM` (update) - quando erro ocorre
7. ✅ `enviarMensagemOctadesk` - quando erro ocorre
8. ✅ Exceções não tratadas - quando exception ocorre

**Total:** 8 chamadas potenciais

**Vantagens:**
- ✅ Cobertura completa de todos os pontos de erro
- ✅ Máxima observabilidade
- ✅ Ainda dentro do limite gratuito (5k/mês)

---

## 📋 DECISÃO

### **Recomendação: Opção 1 (Mínima)**

**Motivos:**
1. ✅ Cobre pontos críticos identificados na investigação
2. ✅ Não sobrecarrega com logs desnecessários
3. ✅ Fácil de expandir depois se necessário
4. ✅ Mantém foco nos erros mais importantes

**Pode expandir depois:**
- Se identificar necessidade de mais observabilidade
- Se outros pontos de erro se tornarem críticos
- Se plano gratuito for suficiente para mais eventos

---

## 💡 IMPLEMENTAÇÃO RECOMENDADA

### **Fase 1: Implementar Opção 1 (Mínima)**
- 5 chamadas potenciais
- Cobre pontos críticos
- Testar e validar

### **Fase 2: Expandir se Necessário (Opcional)**
- Adicionar mais pontos se necessário
- Monitorar uso do plano gratuito
- Avaliar necessidade de mais observabilidade

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA** - Contagem detalhada de chamadas documentada

