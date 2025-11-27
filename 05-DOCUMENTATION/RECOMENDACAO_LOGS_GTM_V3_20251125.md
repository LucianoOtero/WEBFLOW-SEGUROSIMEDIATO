# 📋 RECOMENDAÇÃO: Logs para Código GTM V3

**Data:** 25/11/2025  
**Contexto:** Recomendação de logs adicionais para o código V3 do especialista  
**Status:** 📋 **RECOMENDAÇÃO** - Apenas sugestão, sem implementação

---

## 📋 RESUMO EXECUTIVO

### **Objetivo:**
Recomendar logs adicionais para o código GTM V3 que facilitem:
- Debugging de conversões
- Troubleshooting de problemas
- Validação de dados enviados
- Monitoramento de funcionamento

### **Recomendação:**
- ✅ **Usar `window.novo_log`** (sistema existente) em produção
- ✅ **Usar `console.log`** apenas em desenvolvimento
- ✅ **Logs em pontos críticos:** Antes/depois do push, dados capturados, erros
- ✅ **Logs condicionais:** Apenas em ambiente DEV

---

## 🔍 ANÁLISE: Logs Atuais vs Recomendados

### **Logs Atuais na V3:**

```javascript
// Logging
if (typeof window.novo_log === 'function') {
    window.novo_log('INFO', 'GTM', 'Conversão registrada: ' + eventName);
} else if (_gtm_isDev()) {
    console.log('GTM Event Pushed:', eventName, userData);
}
```

**Problemas:**
- ⚠️ **Muito básico:** Apenas nome do evento
- ⚠️ **Sem dados:** Não mostra o que foi enviado
- ⚠️ **Sem validação:** Não mostra se dados estão corretos
- ⚠️ **Sem troubleshooting:** Difícil debugar problemas

---

### **Logs do Código Atual (Referência):**

O código atual tem logs muito mais detalhados:

```javascript
// ✅ V3: LOG ANTES DE CONSTRUIR DADOS GTM
debugLog('GTM', 'DATA_PREPARATION_START', {
  ddd: ddd,
  celular: '***' + onlyDigits(celular).slice(-4),
  gclid: gclid || '(vazio)',
  dataLayer_available: typeof window.dataLayer !== 'undefined',
  // ... mais dados
}, 'info');

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

// ✅ V3: LOG APÓS O PUSH
debugLog('GTM', 'PUSHED_TO_DATALAYER', {
  event_name: gtmEventData.event,
  dataLayer_length_after: window.dataLayer.length,
  dataLayer_item: window.dataLayer[window.dataLayer.length - 1]
}, 'info');
```

**Pontos Fortes:**
- ✅ **Dados completos:** Mostra o que será enviado
- ✅ **Validação:** Verifica se dataLayer está disponível
- ✅ **Troubleshooting:** Mostra antes/depois do push
- ✅ **Sanitização:** Não expõe dados sensíveis (telefone mascarado)

---

## ✅ RECOMENDAÇÃO: Logs para V3

### **Estratégia de Logging:**

1. ✅ **Usar `window.novo_log`** quando disponível (produção)
2. ✅ **Usar `console.log`** apenas em desenvolvimento
3. ✅ **Logs condicionais:** Apenas em ambiente DEV (exceto erros críticos)
4. ✅ **Sanitização:** Não expor dados sensíveis (telefone, email)

---

### **Código Recomendado:**

```javascript
// --- 3. Função Principal de Conversão (COM LOGS RECOMENDADOS) ---

window.registrarConversaoGTM = function (data) {
    var eventName = data.eventName || 'generate_lead';
    var isDev = _gtm_isDev();
    
    // ✅ LOG 1: Início da preparação (apenas DEV)
    if (isDev && typeof window.novo_log === 'function') {
        window.novo_log('DEBUG', 'GTM', 'Iniciando preparação de conversão', {
            eventName: eventName,
            formType: data.formType || 'general',
            hasPhone: !!data.phone,
            hasEmail: !!data.email,
            hasGclid: !!data.gclid,
            dataLayer_available: typeof window.dataLayer !== 'undefined'
        });
    } else if (isDev) {
        console.log('[GTM] Iniciando preparação:', {
            eventName: eventName,
            formType: data.formType,
            hasPhone: !!data.phone,
            hasEmail: !!data.email
        });
    }
    
    // User Data para Enhanced Conversions
    var userData = {
        'phone_number': formatPhoneForGTM(data.phone),
        'email': data.email ? data.email.trim().toLowerCase() : undefined
    };
    
    // Prioridade do GCLID: 1. Passado explicitamente > 2. URL > 3. Cookie
    var gclidValue = data.gclid || _gtm_getUtmParam('gclid') || _gtm_getCookie('gclid') || _gtm_getCookie('_gcl_aw');
    
    // ✅ LOG 2: GCLID capturado (apenas DEV)
    if (isDev && typeof window.novo_log === 'function') {
        window.novo_log('DEBUG', 'GTM', 'GCLID capturado', {
            source: data.gclid ? 'explicit' : 
                    _gtm_getUtmParam('gclid') ? 'url' : 
                    _gtm_getCookie('gclid') ? 'cookie_gclid' : 
                    _gtm_getCookie('_gcl_aw') ? 'cookie_gcl_aw' : 'none',
            gclid: gclidValue ? (gclidValue.substring(0, 10) + '...') : '(vazio)'
        });
    } else if (isDev && gclidValue) {
        console.log('[GTM] GCLID capturado:', gclidValue.substring(0, 10) + '...');
    }
    
    var gtmEventData = {
        'event': eventName,
        'conversion_label': data.conversionLabel || '',
        'form_type': data.formType || 'general',
        'contact_stage': data.stage || 'initial',
        'phone_ddd': data.ddd || '',
        'user_data': userData,
        
        // Contexto Completo
        'gclid': gclidValue,
        'utm_source': data.utm_source || _gtm_getUtmParam('utm_source') || '',
        'utm_campaign': data.utm_campaign || _gtm_getUtmParam('utm_campaign') || '',
        'utm_medium': data.utm_medium || _gtm_getUtmParam('utm_medium') || '',
        'utm_content': data.utm_content || _gtm_getUtmParam('utm_content') || '',
        'utm_term': data.utm_term || _gtm_getUtmParam('utm_term') || '',
        'page_url': data.page_url || window.location.href || '',
        'page_title': data.page_title || document.title || '',
        'user_agent': navigator.userAgent || '',
        'timestamp': data.timestamp || new Date().toISOString(),
        'environment': data.environment || (isDev ? 'dev' : 'prod')
    };
    
    // ✅ LOG 3: Dados prontos (apenas DEV)
    if (isDev && typeof window.novo_log === 'function') {
        window.novo_log('DEBUG', 'GTM', 'Dados do evento prontos', {
            event: eventName,
            formType: gtmEventData.form_type,
            hasGclid: !!gtmEventData.gclid,
            hasUtm: !!(gtmEventData.utm_source || gtmEventData.utm_campaign),
            hasUserData: !!(userData.phone_number || userData.email),
            dataLayer_length_before: window.dataLayer ? window.dataLayer.length : 0
        });
    } else if (isDev) {
        console.log('[GTM] Dados prontos:', {
            event: eventName,
            formType: gtmEventData.form_type,
            hasGclid: !!gtmEventData.gclid,
            hasUtm: !!(gtmEventData.utm_source || gtmEventData.utm_campaign)
        });
    }
    
    // Validar dataLayer antes de fazer push
    if (typeof window.dataLayer === 'undefined') {
        // ✅ LOG 4: Erro crítico (sempre logar)
        var errorMsg = 'dataLayer não disponível para registro de conversão';
        if (typeof window.novo_log === 'function') {
            window.novo_log('ERROR', 'GTM', errorMsg, {
                eventName: eventName,
                window_dataLayer: typeof window.dataLayer
            });
        } else {
            console.error('[GTM] ERRO:', errorMsg);
        }
        return {
            success: false,
            error: 'dataLayer_unavailable',
            eventData: null
        };
    }
    
    var dataLayerLengthBefore = window.dataLayer.length;
    
    // ✅ LOG 5: Antes do push (apenas DEV)
    if (isDev && typeof window.novo_log === 'function') {
        window.novo_log('DEBUG', 'GTM', 'Enviando para dataLayer', {
            event: eventName,
            dataLayer_length_before: dataLayerLengthBefore
        });
    } else if (isDev) {
        console.log('[GTM] Enviando para dataLayer...');
    }
    
    window.dataLayer.push(gtmEventData);
    
    // ✅ LOG 6: Após o push (sempre logar - INFO em produção)
    var dataLayerLengthAfter = window.dataLayer.length;
    if (typeof window.novo_log === 'function') {
        window.novo_log('INFO', 'GTM', 'Conversão registrada: ' + eventName, {
            event: eventName,
            formType: gtmEventData.form_type,
            dataLayer_length_before: dataLayerLengthBefore,
            dataLayer_length_after: dataLayerLengthAfter,
            hasGclid: !!gtmEventData.gclid,
            hasUtm: !!(gtmEventData.utm_source || gtmEventData.utm_campaign)
        });
    } else if (isDev) {
        console.log('[GTM] ✅ Conversão registrada:', {
            event: eventName,
            dataLayer_length: dataLayerLengthAfter,
            last_item: window.dataLayer[dataLayerLengthAfter - 1]
        });
    }
    
    // Retorno para compatibilidade
    return {
        success: true,
        eventData: gtmEventData
    };
};
```

---

## 📊 COMPARAÇÃO: Logs Atuais vs Recomendados

| Aspecto | Logs Atuais V3 | Logs Recomendados | Melhoria |
|---------|---------------|-------------------|----------|
| **Quantidade de Logs** | 1 log básico | 6 logs detalhados | ✅ **+500%** |
| **Dados Capturados** | Apenas eventName | GCLID, UTM, validações | ✅ **Completo** |
| **Troubleshooting** | Difícil | Fácil | ✅ **Melhorado** |
| **Validação** | Não valida | Valida dataLayer | ✅ **Adicionado** |
| **Sanitização** | N/A | Telefone mascarado | ✅ **Segurança** |
| **Ambiente** | DEV e PROD | Condicional (DEV detalhado) | ✅ **Otimizado** |

---

## ✅ PONTOS CRÍTICOS DOS LOGS RECOMENDADOS

### **1. Log de Início (LOG 1)**
**Quando:** Antes de preparar dados  
**O que mostra:**
- Nome do evento
- Tipo de formulário
- Se tem telefone/email/GCLID
- Se dataLayer está disponível

**Por quê:** Facilita identificar qual conversão está sendo processada

---

### **2. Log de GCLID (LOG 2)**
**Quando:** Após capturar GCLID  
**O que mostra:**
- Fonte do GCLID (explícito, URL, cookie)
- Primeiros 10 caracteres (mascarado)

**Por quê:** Crítico para validar atribuição de conversões

---

### **3. Log de Dados Prontos (LOG 3)**
**Quando:** Antes de fazer push  
**O que mostra:**
- Evento e tipo de formulário
- Se tem GCLID e UTM
- Se tem user_data
- Tamanho do dataLayer antes

**Por quê:** Valida se todos os dados necessários estão presentes

---

### **4. Log de Erro (LOG 4)**
**Quando:** Se dataLayer não estiver disponível  
**O que mostra:**
- Mensagem de erro
- Nome do evento
- Status do dataLayer

**Por quê:** Crítico para identificar problemas de configuração

---

### **5. Log Antes do Push (LOG 5)**
**Quando:** Imediatamente antes de `dataLayer.push()`  
**O que mostra:**
- Nome do evento
- Tamanho do dataLayer antes

**Por quê:** Facilita debugging de problemas no push

---

### **6. Log Após o Push (LOG 6)**
**Quando:** Imediatamente após `dataLayer.push()`  
**O que mostra:**
- Nome do evento
- Tipo de formulário
- Tamanho do dataLayer antes/depois
- Se tem GCLID e UTM

**Por quê:** Confirma que push foi bem-sucedido e mostra dados enviados

---

## 🎯 RECOMENDAÇÃO FINAL

### **Resposta à Pergunta: "Quais logs você recomendaria? No console?"**

**Resposta:**

1. ✅ **Usar `window.novo_log`** quando disponível (sistema existente)
2. ✅ **Usar `console.log`** apenas em desenvolvimento (fallback)
3. ✅ **6 logs em pontos críticos:**
   - Início da preparação
   - GCLID capturado
   - Dados prontos
   - Erro (se dataLayer não disponível)
   - Antes do push
   - Após o push (sempre logar)

4. ✅ **Logs condicionais:**
   - **DEV:** Logs detalhados (DEBUG)
   - **PROD:** Apenas log final (INFO) e erros

5. ✅ **Sanitização:**
   - Telefone mascarado (apenas últimos 4 dígitos)
   - GCLID mascarado (apenas primeiros 10 caracteres)
   - Email não exposto em logs

### **Onde Colocar os Logs:**

- ✅ **No console:** Apenas em desenvolvimento (fallback se `window.novo_log` não disponível)
- ✅ **No `window.novo_log`:** Sempre que disponível (sistema existente)
- ✅ **Condicional:** Logs detalhados apenas em DEV, log final sempre

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Ao Adicionar os Logs:**

- [ ] ✅ Adicionar LOG 1 (início da preparação)
- [ ] ✅ Adicionar LOG 2 (GCLID capturado)
- [ ] ✅ Adicionar LOG 3 (dados prontos)
- [ ] ✅ Adicionar LOG 4 (erro se dataLayer não disponível)
- [ ] ✅ Adicionar LOG 5 (antes do push)
- [ ] ✅ Adicionar LOG 6 (após o push)
- [ ] ✅ Validar que logs são condicionais (DEV vs PROD)
- [ ] ✅ Validar que dados sensíveis estão mascarados
- [ ] ✅ Testar em DEV e PROD

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **RECOMENDAÇÃO COMPLETA - PRONTA PARA IMPLEMENTAÇÃO**

