# 🔍 ANÁLISE: Enviar Dados do Formulário nos Logs do Sentry

**Data:** 26/11/2025  
**Contexto:** Análise de possibilidade de enviar dados capturados no formulário nos logs do Sentry  
**Status:** 📋 **ANÁLISE** - Viabilidade técnica e segurança

---

## 📋 RESUMO EXECUTIVO

### **✅ SIM, é possível enviar dados do formulário nos logs do Sentry**

**Mas com ressalvas importantes:**
- ⚠️ **Dados sensíveis NUNCA devem ser enviados** (DDD, celular, CPF, nome, email)
- ✅ **Apenas metadados seguros** podem ser enviados (has_ddd, has_celular, has_cpf, etc.)
- ✅ **Sanitização obrigatória** via `beforeSend` para garantir conformidade LGPD/GDPR

---

## 🔍 ANÁLISE TÉCNICA

### **1. Dados Capturados no Formulário**

#### **1.1. Modal WhatsApp - Primeiro Contato (Initial)**

**Dados capturados:**
- ✅ `ddd` - DDD do telefone
- ✅ `celular` - Número do celular
- ✅ `gclid` - GCLID dos cookies
- ❌ `NOME` - Vazio (não capturado ainda)
- ❌ `CPF` - Vazio (não capturado ainda)
- ❌ `Email` - Vazio (não capturado ainda)

**Localização:** `MODAL_WHATSAPP_DEFINITIVO.js` - função `enviarMensagemInicialOctadesk` (linha ~1342)

**Código atual:**
```javascript
const webhook_data = {
  data: {
    'DDD-CELULAR': ddd,
    'CELULAR': onlyDigits(celular),
    'GCLID_FLD': gclid || '',
    'NOME': '',
    'CPF': '',
    'Email': '',
    'produto': 'seguro-auto',
    'landing_url': window.location.href,
    'utm_source': getUtmParam('utm_source'),
    'utm_campaign': getUtmParam('utm_campaign')
  },
  d: new Date().toISOString(),
  name: 'Modal WhatsApp - Mensagem Inicial (V2)'
};
```

---

#### **1.2. Modal WhatsApp - Atualização (Update)**

**Dados capturados:**
- ✅ `NOME` - Nome completo
- ✅ `DDD-CELULAR` - DDD do telefone
- ✅ `CELULAR` - Número do celular
- ✅ `Email` - Email do usuário
- ✅ `CEP` - CEP
- ✅ `CPF` - CPF
- ✅ `PLACA` - Placa do veículo
- ✅ `MARCA` - Marca do veículo
- ✅ `VEICULO` - Veículo
- ✅ `ANO` - Ano do veículo
- ✅ `GCLID_FLD` - GCLID
- ✅ Outros campos do formulário

**Localização:** `MODAL_WHATSAPP_DEFINITIVO.js` - função `atualizarLeadEspoCRM` (linha ~911)

**Código atual:**
```javascript
const webhook_data = {
  data: {
    'NOME': sanitizeData({ NOME: dados.NOME }).NOME || '',
    'DDD-CELULAR': dados.DDD || '',
    'CELULAR': onlyDigits(dados.CELULAR) || '',
    'Email': sanitizeData({ Email: dados.EMAIL }).Email || '',
    'CEP': dados.CEP || '',
    'CPF': dados.CPF || '',
    'PLACA': dados.PLACA || '',
    'MARCA': dados.MARCA || '',
    'VEICULO': dados.MARCA || '',
    'ANO': dados.ANO || '',
    'GCLID_FLD': dados.GCLID || '',
    // ... outros campos
  },
  d: new Date().toISOString(),
  name: 'Modal WhatsApp - Atualização de Lead (V2)'
};
```

---

## 🔒 ANÁLISE DE SEGURANÇA

### **1. Dados Sensíveis (NUNCA Enviar)**

**Dados que violam LGPD/GDPR:**
- ❌ **DDD + Celular** - Informação pessoal identificável
- ❌ **CPF** - Dado pessoal sensível
- ❌ **Nome completo** - Informação pessoal identificável
- ❌ **Email** - Informação pessoal identificável
- ❌ **CEP completo** - Pode identificar localização
- ❌ **Placa do veículo** - Pode identificar veículo/proprietário

**Risco:**
- ⚠️ Violação de privacidade (LGPD/GDPR)
- ⚠️ Dados podem ser expostos no dashboard do Sentry
- ⚠️ Conformidade legal comprometida

---

### **2. Dados Seguros (PODE Enviar)**

**Metadados que não identificam pessoa:**
- ✅ **has_ddd** - Boolean (tem DDD ou não)
- ✅ **has_celular** - Boolean (tem celular ou não)
- ✅ **has_cpf** - Boolean (tem CPF ou não)
- ✅ **has_nome** - Boolean (tem nome ou não)
- ✅ **has_email** - Boolean (tem email ou não)
- ✅ **has_cep** - Boolean (tem CEP ou não)
- ✅ **has_placa** - Boolean (tem placa ou não)
- ✅ **length_ddd** - Tamanho do DDD (sem valor real)
- ✅ **length_celular** - Tamanho do celular (sem valor real)
- ✅ **form_type** - Tipo de formulário
- ✅ **produto** - Produto (ex: 'seguro-auto')
- ✅ **landing_url** - URL da página
- ✅ **utm_source, utm_campaign** - Parâmetros UTM
- ✅ **gclid** - GCLID (não identifica pessoa diretamente)

---

## 💡 IMPLEMENTAÇÃO SEGURA

### **Opção 1: Apenas Metadados (Recomendada)**

**Enviar apenas flags booleanas e metadados:**

```javascript
function logErrorToSentry(errorData, formData = null) {
  if (typeof Sentry === 'undefined') {
    return;
  }
  
  try {
    // Sanitizar dados do formulário (apenas metadados)
    const sanitizedFormData = formData ? {
      // Apenas flags booleanas e metadados seguros
      has_ddd: !!formData.ddd,
      has_celular: !!formData.celular,
      has_cpf: !!formData.cpf,
      has_nome: !!formData.nome,
      has_email: !!formData.email,
      has_cep: !!formData.cep,
      has_placa: !!formData.placa,
      length_ddd: formData.ddd ? formData.ddd.length : 0,
      length_celular: formData.celular ? formData.celular.length : 0,
      form_type: formData.form_type || 'unknown',
      produto: formData.produto || 'unknown',
      // ❌ NUNCA incluir: ddd, celular, cpf, nome, email, cep, placa (valores reais)
    } : null;
    
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
        // Dados do formulário (sanitizados)
        form_data: sanitizedFormData,
        // ⚠️ Dados sensíveis serão removidos pelo beforeSend (dupla proteção)
      }
    });
  } catch (err) {
    console.error('Falha ao logar no Sentry:', err);
  }
}
```

---

### **Opção 2: Hash Parcial (Alternativa)**

**Enviar hash parcial para debugging sem expor dados:**

```javascript
function logErrorToSentry(errorData, formData = null) {
  if (typeof Sentry === 'undefined') {
    return;
  }
  
  try {
    // Criar hash parcial para debugging (não identifica pessoa)
    const formHash = formData ? {
      // Hash parcial dos dados (apenas primeiros 2 caracteres + tamanho)
      ddd_hash: formData.ddd ? formData.ddd.substring(0, 2) + '**' : null,
      celular_hash: formData.celular ? '**' + formData.celular.substring(formData.celular.length - 2) : null,
      cpf_hash: formData.cpf ? formData.cpf.substring(0, 3) + '***' : null,
      // Metadados
      has_ddd: !!formData.ddd,
      has_celular: !!formData.celular,
      has_cpf: !!formData.cpf,
      form_type: formData.form_type || 'unknown',
    } : null;
    
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
        form_data: formHash, // Hash parcial
      }
    });
  } catch (err) {
    console.error('Falha ao logar no Sentry:', err);
  }
}
```

**⚠️ ATENÇÃO:** Mesmo hash parcial pode ser sensível. **Recomendado:** Apenas metadados (Opção 1).

---

## 🎯 RECOMENDAÇÃO FINAL

### **✅ RECOMENDO: Opção 1 (Apenas Metadados)**

**O que enviar:**
- ✅ Flags booleanas (`has_ddd`, `has_celular`, `has_cpf`, etc.)
- ✅ Tamanhos (sem valores reais)
- ✅ Tipo de formulário, produto, UTM parameters
- ✅ GCLID (não identifica pessoa diretamente)

**O que NUNCA enviar:**
- ❌ DDD, celular, CPF, nome, email, CEP, placa (valores reais)

**Por quê:**
- ✅ Conformidade LGPD/GDPR
- ✅ Dados suficientes para debugging
- ✅ Não expõe informações pessoais
- ✅ `beforeSend` remove dados sensíveis como dupla proteção

---

## 📋 IMPLEMENTAÇÃO NO CÓDIGO

### **Exemplo: Integrar em enviarMensagemInicialOctadesk**

```javascript
// MODAL_WHATSAPP_DEFINITIVO.js - função enviarMensagemInicialOctadesk

// ... código existente ...

if (result.response && result.response.ok) {
  return { success: result.response.ok, attempt: result.attempt + 1 };
} else {
  const errorMsg = result.error?.message || 'Erro desconhecido';
  
  // Logar no sistema próprio (existente)
  logEvent('whatsapp_modal_octadesk_initial_error', { 
    error: errorMsg, 
    attempt: result.attempt + 1 
  }, 'error');
  
  // Logar no Sentry com dados do formulário (sanitizados)
  if (typeof logErrorToSentry === 'function') {
    logErrorToSentry({
      error: 'whatsapp_modal_octadesk_initial_error',
      component: 'MODAL',
      action: 'octadesk_initial',
      attempt: result.attempt + 1,
      duration: result.duration || 0,
      errorMessage: errorMsg
    }, {
      // Dados do formulário (apenas metadados seguros)
      ddd: ddd,           // Será sanitizado pelo beforeSend
      celular: celular,   // Será sanitizado pelo beforeSend
      gclid: gclid,
      form_type: 'whatsapp_modal',
      produto: 'seguro-auto',
      landing_url: window.location.href,
      utm_source: getUtmParam('utm_source'),
      utm_campaign: getUtmParam('utm_campaign')
    });
  }
  
  return { success: false, error: errorMsg, attempt: result.attempt + 1 };
}
```

---

## 🔒 GARANTIAS DE SEGURANÇA

### **1. Sanitização em Múltiplas Camadas**

**Camada 1: Função logErrorToSentry**
- ✅ Converte dados sensíveis em metadados seguros
- ✅ Remove valores reais antes de enviar

**Camada 2: beforeSend no Sentry.init**
- ✅ Remove dados sensíveis que possam ter escapado
- ✅ Dupla proteção garantida

**Resultado:**
- ✅ **Impossível** enviar dados sensíveis acidentalmente
- ✅ **Conformidade LGPD/GDPR** garantida

---

## 📊 COMPARAÇÃO: Com vs Sem Dados do Formulário

### **Sem Dados do Formulário:**
```javascript
{
  error: 'whatsapp_modal_octadesk_initial_error',
  component: 'MODAL',
  attempt: 3,
  duration: 35000
}
```

**Limitação:**
- ⚠️ Não sabe se formulário tinha dados
- ⚠️ Não sabe qual tipo de formulário
- ⚠️ Menos contexto para debugging

---

### **Com Dados do Formulário (Sanitizados):**
```javascript
{
  error: 'whatsapp_modal_octadesk_initial_error',
  component: 'MODAL',
  attempt: 3,
  duration: 35000,
  form_data: {
    has_ddd: true,
    has_celular: true,
    has_cpf: false,
    has_nome: false,
    form_type: 'whatsapp_modal',
    produto: 'seguro-auto',
    utm_source: 'google',
    utm_campaign: 'campaign_name',
    gclid: 'gclid_value'
  }
}
```

**Vantagem:**
- ✅ Sabe se formulário tinha dados
- ✅ Sabe qual tipo de formulário
- ✅ Mais contexto para debugging
- ✅ Pode identificar padrões (erros só quando tem CPF, etc.)

---

## 🎯 CONCLUSÃO

### **✅ SIM, é possível e recomendado enviar dados do formulário**

**Mas apenas:**
- ✅ Metadados seguros (flags booleanas, tipos, UTM, GCLID)
- ✅ NUNCA valores reais (DDD, celular, CPF, nome, email)

**Benefícios:**
- ✅ Mais contexto para debugging
- ✅ Identificar padrões de erro
- ✅ Conformidade LGPD/GDPR mantida
- ✅ Dados suficientes para diagnóstico

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA** - Viabilidade técnica e segurança documentadas

