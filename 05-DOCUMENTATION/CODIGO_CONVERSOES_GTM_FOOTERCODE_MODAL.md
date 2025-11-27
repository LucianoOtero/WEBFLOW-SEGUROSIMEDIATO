# 📊 Código de Registros de Conversão - Google Tag Manager

**Data:** 25/11/2025  
**Arquivos:** `FooterCodeSiteDefinitivoCompleto.js` e `MODAL_WHATSAPP_DEFINITIVO.js`

---

## 📋 RESUMO

Este documento apresenta todo o código relacionado ao registro de conversões no Google Tag Manager (GTM) presente nos arquivos `FooterCodeSiteDefinitivoCompleto.js` e `MODAL_WHATSAPP_DEFINITIVO.js`.

---

## 🎯 FOOTERCODE - Registros de Conversão

### **Arquivo:** `FooterCodeSiteDefinitivoCompleto.js`

### **1. Conversão: Dados Válidos (Linhas 2992-3000)**

**Quando dispara:** Quando o formulário é submetido com dados válidos

```2992:3000:WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js
                // 🎯 CAPTURAR CONVERSÃO GTM - DADOS VÁLIDOS
                window.novo_log('INFO','GTM', '🎯 Registrando conversão - dados válidos');
                if (typeof window.dataLayer !== 'undefined') {
                  window.dataLayer.push({
                    'event': 'form_submit_valid',
                    'form_type': 'cotacao_seguro',
                    'validation_status': 'valid'
                  });
                }
```

**Evento GTM:** `form_submit_valid`  
**Dados enviados:**
- `event`: `'form_submit_valid'`
- `form_type`: `'cotacao_seguro'`
- `validation_status`: `'valid'`

---

### **2. Conversão: Usuário Prosseguiu com Dados Inválidos (Linhas 3074-3082)**

**Quando dispara:** Quando o usuário escolhe prosseguir mesmo com dados inválidos

```3074:3082:WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js
                    // 🎯 CAPTURAR CONVERSÃO GTM - USUÁRIO PROSSEGUIU COM DADOS INVÁLIDOS
                    window.novo_log('INFO','GTM', '🎯 Registrando conversão - usuário prosseguiu com dados inválidos');
                    if (typeof window.dataLayer !== 'undefined') {
                      window.dataLayer.push({
                        'event': 'form_submit_invalid_proceed',
                        'form_type': 'cotacao_seguro',
                        'validation_status': 'invalid_proceed'
                      });
                    }
```

**Evento GTM:** `form_submit_invalid_proceed`  
**Dados enviados:**
- `event`: `'form_submit_invalid_proceed'`
- `form_type`: `'cotacao_seguro'`
- `validation_status`: `'invalid_proceed'`

---

### **3. Conversão: Usuário Prosseguiu Após Erro de Rede (Linhas 3150-3158)**

**Quando dispara:** Quando o usuário escolhe prosseguir após erro de rede na validação

```3150:3158:WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js
                  // 🎯 CAPTURAR CONVERSÃO GTM - USUÁRIO PROSSEGUIU APÓS ERRO DE REDE
                  window.novo_log('INFO','GTM', '🎯 Registrando conversão - usuário prosseguiu após erro de rede');
                  if (typeof window.dataLayer !== 'undefined') {
                    window.dataLayer.push({
                      'event': 'form_submit_network_error_proceed',
                      'form_type': 'cotacao_seguro',
                      'validation_status': 'network_error_proceed'
                    });
                  }
```

**Evento GTM:** `form_submit_network_error_proceed`  
**Dados enviados:**
- `event`: `'form_submit_network_error_proceed'`
- `form_type`: `'cotacao_seguro'`
- `validation_status`: `'network_error_proceed'`

---

## 🎯 MODAL - Registros de Conversão

### **Arquivo:** `MODAL_WHATSAPP_DEFINITIVO.js`

### **1. Variáveis Configuráveis GTM (Linhas 86-98)**

**Variáveis que podem ser configuradas antes do registro:**

```86:98:WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js
  // ==================== VARIÁVEIS GOOGLE TAG MANAGER (Configuráveis) ====================
  
  // CONFIGURAÇÃO GTM - VARIÁVEIS (preencher depois no GTM ou no código)
  window.GTM_EVENT_NAME_INITIAL = window.GTM_EVENT_NAME_INITIAL || 'whatsapp_modal_initial_contact'; // Nome do evento GTM
  window.GTM_FORM_TYPE = window.GTM_FORM_TYPE || 'whatsapp_modal';                                   // Tipo de formulário
  window.GTM_CONTACT_STAGE = window.GTM_CONTACT_STAGE || 'initial';                                  // Estágio do contato
  window.GTM_UTM_SOURCE = window.GTM_UTM_SOURCE || null;                                            // UTM Source (auto-preenchido se null)
  window.GTM_UTM_CAMPAIGN = window.GTM_UTM_CAMPAIGN || null;                                         // UTM Campaign (auto-preenchido se null)
  window.GTM_UTM_MEDIUM = window.GTM_UTM_MEDIUM || null;                                            // UTM Medium (auto-preenchido se null)
  window.GTM_UTM_TERM = window.GTM_UTM_TERM || null;                                                // UTM Term (auto-preenchido se null)
  window.GTM_UTM_CONTENT = window.GTM_UTM_CONTENT || null;                                          // UTM Content (auto-preenchido se null)
  window.GTM_PAGE_URL = window.GTM_PAGE_URL || null;                                                // URL da página (auto-preenchido se null)
  window.GTM_PAGE_TITLE = window.GTM_PAGE_TITLE || null;                                            // Título da página (auto-preenchido se null)
  window.GTM_USER_AGENT = window.GTM_USER_AGENT || null;                                            // User Agent (auto-preenchido se null)
```

**Variáveis disponíveis:**
- `GTM_EVENT_NAME_INITIAL`: Nome do evento (padrão: `'whatsapp_modal_initial_contact'`)
- `GTM_FORM_TYPE`: Tipo de formulário (padrão: `'whatsapp_modal'`)
- `GTM_CONTACT_STAGE`: Estágio do contato (padrão: `'initial'`)
- `GTM_UTM_SOURCE`: UTM Source (auto-preenchido da URL se null)
- `GTM_UTM_CAMPAIGN`: UTM Campaign (auto-preenchido da URL se null)
- `GTM_UTM_MEDIUM`: UTM Medium (auto-preenchido da URL se null)
- `GTM_UTM_TERM`: UTM Term (auto-preenchido da URL se null)
- `GTM_UTM_CONTENT`: UTM Content (auto-preenchido da URL se null)
- `GTM_PAGE_URL`: URL da página (auto-preenchido se null)
- `GTM_PAGE_TITLE`: Título da página (auto-preenchido se null)
- `GTM_USER_AGENT`: User Agent (auto-preenchido se null)

---

### **2. Função: registrarConversaoInicialGTM (Linhas 1496-1586)**

**Função completa de registro de conversão inicial:**

```1496:1586:WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js
  /**
   * Registrar conversão inicial no Google Tag Manager
   * @param {string} ddd - DDD do telefone
   * @param {string} celular - Número do celular
   * @param {string} gclid - GCLID dos cookies
   * @returns {Object} Resultado do registro
   */
  function registrarConversaoInicialGTM(ddd, celular, gclid) {
    // ✅ V3: LOG ANTES DE CONSTRUIR DADOS GTM
    debugLog('GTM', 'DATA_PREPARATION_START', {
      ddd: ddd,
      celular: '***' + onlyDigits(celular).slice(-4),
      gclid: gclid || '(vazio)',
      dataLayer_available: typeof window.dataLayer !== 'undefined',
      gtm_variables: {
        GTM_EVENT_NAME_INITIAL: window.GTM_EVENT_NAME_INITIAL || '(não definido)',
        GTM_FORM_TYPE: window.GTM_FORM_TYPE || '(não definido)',
        GTM_CONTACT_STAGE: window.GTM_CONTACT_STAGE || '(não definido)',
        GTM_UTM_SOURCE: window.GTM_UTM_SOURCE || '(null - será preenchido)',
        GTM_UTM_CAMPAIGN: window.GTM_UTM_CAMPAIGN || '(null - será preenchido)',
        GTM_PAGE_URL: window.GTM_PAGE_URL || '(null - será preenchido)',
        GTM_PAGE_TITLE: window.GTM_PAGE_TITLE || '(null - será preenchido)'
      },
      utm_params_from_url: {
        utm_source: getUtmParam('utm_source') || '(vazio)',
        utm_campaign: getUtmParam('utm_campaign') || '(vazio)',
        utm_medium: getUtmParam('utm_medium') || '(vazio)',
        utm_term: getUtmParam('utm_term') || '(vazio)',
        utm_content: getUtmParam('utm_content') || '(vazio)'
      }
    }, 'info');
    
    if (typeof window.dataLayer === 'undefined') {
      debugLog('GTM', 'DATALAYER_UNAVAILABLE', {
        message: 'dataLayer não disponível para registro de conversão inicial',
        window_dataLayer: typeof window.dataLayer
      }, 'warn');
      logEvent('whatsapp_modal_gtm_initial_datalayer_unavailable', {}, 'warning');
      return { success: false, error: 'dataLayer_unavailable' };
    }
    
    // Construir dados do evento GTM usando variáveis configuráveis
    const gtmEventData = {
      'event': window.GTM_EVENT_NAME_INITIAL || 'whatsapp_modal_initial_contact',
      'form_type': window.GTM_FORM_TYPE || 'whatsapp_modal',
      'contact_stage': window.GTM_CONTACT_STAGE || 'initial',
      'phone_ddd': ddd || '',
      'phone_number': '***',
      'has_phone': !!celular,
      'gclid': gclid || '',
      'utm_source': window.GTM_UTM_SOURCE || getUtmParam('utm_source') || '',
      'utm_campaign': window.GTM_UTM_CAMPAIGN || getUtmParam('utm_campaign') || '',
      'utm_medium': window.GTM_UTM_MEDIUM || getUtmParam('utm_medium') || '',
      'utm_term': window.GTM_UTM_TERM || getUtmParam('utm_term') || '',
      'utm_content': window.GTM_UTM_CONTENT || getUtmParam('utm_content') || '',
      'page_url': window.GTM_PAGE_URL || window.location.href || '',
      'page_title': window.GTM_PAGE_TITLE || document.title || '',
      'user_agent': window.GTM_USER_AGENT || navigator.userAgent || '',
      'timestamp': new Date().toISOString(),
      'environment': isDevelopmentEnvironment() ? 'dev' : 'prod'
    };
    
    // ✅ V3: LOG DO OBJETO COMPLETO QUE SERÁ ENVIADO AO GTM
    debugLog('GTM', 'EVENT_DATA_READY', {
      event_data: gtmEventData,
      event_name: gtmEventData.event,
      dataLayer_length_before: window.dataLayer.length
    }, 'info');
    
    // ✅ V3: LOG ANTES DO PUSH
    debugLog('GTM', 'PUSHING_TO_DATALAYER', {
      event_name: gtmEventData.event,
      dataLayer_length_before: window.dataLayer.length
    }, 'info');
    
    window.dataLayer.push(gtmEventData);
    
    // ✅ V3: LOG APÓS O PUSH
    debugLog('GTM', 'PUSHED_TO_DATALAYER', {
      event_name: gtmEventData.event,
      dataLayer_length_after: window.dataLayer.length,
      dataLayer_item: window.dataLayer[window.dataLayer.length - 1]
    }, 'info');
    
    logEvent('whatsapp_modal_gtm_initial_conversion', { 
      event_name: gtmEventData.event,
      has_gclid: !!gtmEventData.gclid
    }, 'info');
    
    return { success: true, eventData: gtmEventData };
  }
```

**Evento GTM:** `whatsapp_modal_initial_contact` (configurável via `GTM_EVENT_NAME_INITIAL`)  
**Dados enviados:**
- `event`: Nome do evento (padrão: `'whatsapp_modal_initial_contact'`)
- `form_type`: Tipo de formulário (padrão: `'whatsapp_modal'`)
- `contact_stage`: Estágio do contato (padrão: `'initial'`)
- `phone_ddd`: DDD do telefone
- `phone_number`: `'***'` (mascarado por privacidade)
- `has_phone`: Boolean indicando se tem telefone
- `gclid`: GCLID dos cookies (se disponível)
- `utm_source`: UTM Source (da URL ou variável)
- `utm_campaign`: UTM Campaign (da URL ou variável)
- `utm_medium`: UTM Medium (da URL ou variável)
- `utm_term`: UTM Term (da URL ou variável)
- `utm_content`: UTM Content (da URL ou variável)
- `page_url`: URL da página atual
- `page_title`: Título da página
- `user_agent`: User Agent do navegador
- `timestamp`: Timestamp ISO da conversão
- `environment`: Ambiente (`'dev'` ou `'prod'`)

---

### **3. Função: registrarConversaoGoogleAds (Linhas 1588-1616)**

**Função de registro de conversão no Google Ads (compatibilidade):**

```1588:1617:WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js
  /**
   * Registrar conversão no Google Ads (mantida para compatibilidade)
   * @param {Object} dados - Dados do formulário
   */
  function registrarConversaoGoogleAds(dados) {
    if (typeof window.dataLayer === 'undefined') {
      if (window.novo_log) {
        window.novo_log('WARN', 'MODAL', 'dataLayer não disponível para registro de conversão', null, 'ERROR_HANDLING', 'SIMPLE');
      }
      logEvent('whatsapp_modal_googleads_datalayer_unavailable', {}, 'warning');
      return;
    }
    
    window.dataLayer.push({
      'event': 'whatsapp_modal_submit',
      'form_type': 'whatsapp_modal',
      'validation_status': 'valid',
      'phone': dados.CELULAR ? '***' : '', // Não logar telefone completo
      'has_cpf': !!dados.CPF,
      'has_placa': !!dados.PLACA,
      'has_cep': !!dados.CEP,
      'has_nome': !!dados.NOME,
      'gclid': dados.GCLID || ''
    });
    
    logEvent('whatsapp_modal_googleads_conversion', { 
      has_cpf: !!dados.CPF,
      has_placa: !!dados.PLACA 
    }, 'info');
  }
```

**Evento GTM:** `whatsapp_modal_submit`  
**Dados enviados:**
- `event`: `'whatsapp_modal_submit'`
- `form_type`: `'whatsapp_modal'`
- `validation_status`: `'valid'`
- `phone`: `'***'` (mascarado por privacidade)
- `has_cpf`: Boolean indicando se tem CPF
- `has_placa`: Boolean indicando se tem placa
- `has_cep`: Boolean indicando se tem CEP
- `has_nome`: Boolean indicando se tem nome
- `gclid`: GCLID dos cookies (se disponível)

---

## 📊 RESUMO DOS EVENTOS GTM

### **FooterCode - Eventos:**

| Evento | Quando Dispara | Dados Enviados |
|--------|----------------|----------------|
| `form_submit_valid` | Dados válidos | `form_type`, `validation_status: 'valid'` |
| `form_submit_invalid_proceed` | Usuário prosseguiu com dados inválidos | `form_type`, `validation_status: 'invalid_proceed'` |
| `form_submit_network_error_proceed` | Usuário prosseguiu após erro de rede | `form_type`, `validation_status: 'network_error_proceed'` |

### **Modal - Eventos:**

| Evento | Quando Dispara | Dados Enviados |
|--------|----------------|----------------|
| `whatsapp_modal_initial_contact` | Primeiro contato via WhatsApp | Dados completos (UTM, GCLID, telefone, etc.) |
| `whatsapp_modal_submit` | Submissão do formulário WhatsApp | `form_type`, `validation_status`, `phone`, `has_cpf`, `has_placa`, `has_cep`, `has_nome`, `gclid` |

---

## 🔍 ONDE SÃO CHAMADAS AS FUNÇÕES

### **FooterCode:**
- **Linha 2995:** `dataLayer.push()` para `form_submit_valid`
- **Linha 3077:** `dataLayer.push()` para `form_submit_invalid_proceed`
- **Linha 3153:** `dataLayer.push()` para `form_submit_network_error_proceed`

### **Modal:**
- **Linha 2041:** `registrarConversaoInicialGTM()` chamada em paralelo com EspoCRM e Octadesk
- **Linha 2168:** `registrarConversaoInicialGTM()` chamada em paralelo (sem API)
- **Linha 1601:** `registrarConversaoGoogleAds()` chamada para conversão Google Ads

---

## ⚙️ CONFIGURAÇÃO GTM NECESSÁRIA

### **Tags a Configurar no GTM:**

1. **Tag para `form_submit_valid`:**
   - Tipo: Google Ads - Conversão
   - Acionador: Evento personalizado `form_submit_valid`
   - ID de conversão: Configurar conforme necessário

2. **Tag para `form_submit_invalid_proceed`:**
   - Tipo: Google Ads - Conversão
   - Acionador: Evento personalizado `form_submit_invalid_proceed`
   - ID de conversão: Configurar conforme necessário

3. **Tag para `form_submit_network_error_proceed`:**
   - Tipo: Google Ads - Conversão
   - Acionador: Evento personalizado `form_submit_network_error_proceed`
   - ID de conversão: Configurar conforme necessário

4. **Tag para `whatsapp_modal_initial_contact`:**
   - Tipo: Google Ads - Conversão
   - Acionador: Evento personalizado `whatsapp_modal_initial_contact`
   - ID de conversão: `AW-815139667/WhatsApp_Contact`

5. **Tag para `whatsapp_modal_submit`:**
   - Tipo: Google Ads - Conversão
   - Acionador: Evento personalizado `whatsapp_modal_submit`
   - ID de conversão: Configurar conforme necessário

---

## ✅ VALIDAÇÕES IMPLEMENTADAS

### **FooterCode:**
- ✅ Verifica se `window.dataLayer` existe antes de fazer push
- ✅ Logs informativos antes de cada push

### **Modal:**
- ✅ Verifica se `window.dataLayer` existe antes de fazer push
- ✅ Logs detalhados em cada etapa (preparação, push, resultado)
- ✅ Retorna objeto com `success` e `eventData` ou `error`
- ✅ Tratamento de erros com logs apropriados

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **CÓDIGO COMPLETO DOCUMENTADO**

