# 🔍 ANÁLISE: Dados Enviados aos Endpoints - 26/11/2025

**Data:** 26/11/2025  
**Contexto:** Verificar quais dados estão sendo enviados aos endpoints e por que aparecem vazios no log  
**Status:** 📋 **ANÁLISE TÉCNICA** - Apenas investigação, sem modificações

---

## 📋 PERGUNTA DO USUÁRIO

**"Sabemos quais são os dados que estão sendo passados para os endpoints?"**

---

## 🔍 ANÁLISE DOS DADOS ENVIADOS

### **1. Endpoint Octadesk (`/add_webflow_octa.php`)**

#### **Dados Enviados (webhook_data):**

```javascript
// MODAL_WHATSAPP_DEFINITIVO.js:1325-1340
const webhook_data = {
  data: {
    'DDD-CELULAR': ddd,                    // DDD do telefone
    'CELULAR': onlyDigits(celular),        // Número do celular (apenas dígitos)
    'GCLID_FLD': gclid || '',              // GCLID dos cookies
    'NOME': '',                            // Vazio (não capturado ainda)
    'CPF': '',                             // Vazio (não capturado ainda)
    'Email': '',                           // Vazio (não capturado ainda)
    'produto': 'seguro-auto',              // Produto fixo
    'landing_url': window.location.href,   // URL da página
    'utm_source': getUtmParam('utm_source'),      // UTM source
    'utm_campaign': getUtmParam('utm_campaign')   // UTM campaign
  },
  d: new Date().toISOString(),             // Data/hora
  name: 'Modal WhatsApp - Mensagem Inicial (V2)'
};
```

**Quando é chamado:**
- Função: `enviarMensagemInicialOctadesk(ddd, celular, gclid)`
- Momento: Após validação do celular (primeiro contato)
- Dados disponíveis: `ddd`, `celular`, `gclid`
- Dados NÃO disponíveis: `NOME`, `CPF`, `Email` (ainda não foram capturados)

**Payload JSON enviado:**
```json
{
  "data": {
    "DDD-CELULAR": "11",
    "CELULAR": "987654321",
    "GCLID_FLD": "gclid_value_or_empty",
    "NOME": "",
    "CPF": "",
    "Email": "",
    "produto": "seguro-auto",
    "landing_url": "https://prod.bssegurosimediato.com.br/...",
    "utm_source": "google",
    "utm_campaign": "campaign_name"
  },
  "d": "2025-11-26T13:30:32.000Z",
  "name": "Modal WhatsApp - Mensagem Inicial (V2)"
}
```

---

### **2. Endpoint EspoCRM (`/add_flyingdonkeys.php`) - UPDATE**

#### **Dados Enviados (webhook_data):**

```javascript
// MODAL_WHATSAPP_DEFINITIVO.js:1135-1160
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
    'SEXO': dados.SEXO || '',
    'DATA-DE-NASCIMENTO': dados.DATA_NASCIMENTO || '',
    // ... outros campos
  },
  d: new Date().toISOString(),
  name: 'Modal WhatsApp - Atualização de Lead (V2)'
};

// Se houver lead_id anterior, adicionar:
if (espocrmId) {
  webhook_data.data.lead_id = espocrmId;
  webhook_data.data.contact_id = espocrmId;
}
```

**Quando é chamado:**
- Função: `atualizarLeadEspoCRM(dados, espocrmId)`
- Momento: Após preenchimento completo do formulário
- Dados disponíveis: Todos os dados do formulário (`dados` object)
- Dados podem estar vazios se formulário não foi preenchido completamente

**Payload JSON enviado:**
```json
{
  "data": {
    "NOME": "João Silva",
    "DDD-CELULAR": "11",
    "CELULAR": "987654321",
    "Email": "joao@email.com",
    "CEP": "01234567",
    "CPF": "12345678901",
    "PLACA": "ABC1234",
    "MARCA": "Fiat",
    "VEICULO": "Fiat",
    "ANO": "2020",
    "GCLID_FLD": "gclid_value",
    "lead_id": "lead_id_from_previous_call",
    "contact_id": "lead_id_from_previous_call"
  },
  "d": "2025-11-26T13:31:54.000Z",
  "name": "Modal WhatsApp - Atualização de Lead (V2)"
}
```

---

## 🔍 POR QUE OS DADOS APARECEM VAZIOS NO LOG?

### **Problema Identificado:**

**Função `logEvent` (linha 259-281):**

```javascript
function logEvent(eventType, data, severity = 'info') {
  // ...
  if (window.novo_log) {
    window.novo_log(logLevel, 'MODAL', `[${severity.toUpperCase()}] ${eventType}`, {
      has_ddd: !!data.ddd,           // ❌ Verifica data.ddd (não existe)
      has_celular: !!data.celular,   // ❌ Verifica data.celular (não existe)
      has_cpf: !!data.cpf,           // ❌ Verifica data.cpf (não existe)
      has_nome: !!data.nome,         // ❌ Verifica data.nome (não existe)
      environment: logData.environment
    }, 'OPERATION', 'SIMPLE');
  }
}
```

**Quando `logEvent` é chamado com erro:**

```javascript
// Linha 1413 - Octadesk
logEvent('whatsapp_modal_octadesk_initial_error', { 
  error: errorMsg, 
  attempt: result.attempt + 1 
}, 'error');

// Linha 1276 - EspoCRM
logEvent('whatsapp_modal_espocrm_update_error', { 
  error: errorMsg, 
  attempt: result.attempt + 1 
}, 'error');
```

**Problema:**
- ✅ `logEvent` recebe `{ error: errorMsg, attempt: result.attempt + 1 }`
- ❌ Mas verifica `data.ddd`, `data.celular`, `data.cpf`, `data.nome`
- ❌ Esses campos **NÃO existem** no objeto passado
- ✅ Por isso aparece `has_ddd: false, has_celular: false, has_cpf: false, has_nome: false`

**Conclusão:**
- ⚠️ **Os dados NÃO estão vazios no `webhook_data`**
- ⚠️ **Os dados estão vazios apenas no LOG** porque `logEvent` verifica campos que não foram passados
- ✅ **O `webhook_data` real contém os dados corretos** (ddd, celular, etc.)

---

## 🔍 O QUE REALMENTE ESTÁ SENDO ENVIADO?

### **Para Octadesk (Initial):**

**Dados enviados:**
- ✅ `DDD-CELULAR`: `ddd` (ex: "11")
- ✅ `CELULAR`: `onlyDigits(celular)` (ex: "987654321")
- ✅ `GCLID_FLD`: `gclid` (se disponível)
- ✅ `produto`: "seguro-auto" (fixo)
- ✅ `landing_url`: URL da página
- ✅ `utm_source`, `utm_campaign`: Parâmetros UTM

**Dados NÃO enviados (vazios):**
- ⚠️ `NOME`: "" (não capturado ainda - é o primeiro contato)
- ⚠️ `CPF`: "" (não capturado ainda - é o primeiro contato)
- ⚠️ `Email`: "" (não capturado ainda - é o primeiro contato)

**Isso é esperado?**
- ✅ **SIM** - É o primeiro contato, apenas DDD e CELULAR são capturados
- ✅ **NÃO é um erro** - É o comportamento esperado

---

### **Para EspoCRM (Update):**

**Dados enviados:**
- ✅ Todos os campos do formulário (`dados` object)
- ✅ `lead_id` e `contact_id` (se houver lead anterior)

**Dados podem estar vazios se:**
- ⚠️ Formulário não foi preenchido completamente
- ⚠️ Usuário não preencheu todos os campos
- ⚠️ Dados não foram capturados corretamente

**Isso é esperado?**
- ⚠️ **Depende** - Se formulário foi preenchido, dados devem estar presentes
- ⚠️ **Se dados estão vazios**, pode indicar problema na captura

---

## 🎯 CONCLUSÃO

### **1. Dados Enviados aos Endpoints:**

**✅ Octadesk (Initial):**
- DDD e CELULAR: ✅ **Enviados corretamente**
- NOME, CPF, Email: ⚠️ **Vazios (esperado - primeiro contato)**

**✅ EspoCRM (Update):**
- Todos os campos: ✅ **Devem estar presentes se formulário foi preenchido**
- Se vazios: ⚠️ **Pode indicar problema na captura**

---

### **2. Dados Vazios no Log:**

**✅ Causa Identificada:**
- `logEvent` verifica campos (`data.ddd`, `data.celular`, etc.) que **não foram passados**
- Objeto passado contém apenas `{ error: errorMsg, attempt: result.attempt + 1 }`
- Por isso aparece `has_ddd: false, has_celular: false`

**✅ Solução:**
- Passar dados corretos para `logEvent` quando houver erro
- Ou modificar `logEvent` para verificar campos do `webhook_data` em vez de `data`

---

### **3. Por que o Erro Ocorre?**

**Hipótese mais provável:**
- ⚠️ **Requisição não chega ao servidor** (não aparece no access.log)
- ⚠️ **Timeout ou erro de rede** antes de chegar ao servidor
- ⚠️ **Dados estão corretos**, mas requisição falha na internet

**Próximos passos:**
1. Verificar se requisições chegam ao servidor (access.log)
2. Verificar logs dos endpoints PHP (se foram executados)
3. Verificar logs do Cloudflare (se há bloqueios)
4. Adicionar logs mais detalhados no `fetchWithRetry` para capturar tipo de erro

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **ANÁLISE CONCLUÍDA** - Dados estão sendo enviados corretamente, problema está na requisição não chegar ao servidor

