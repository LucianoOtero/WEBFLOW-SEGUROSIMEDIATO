# 📋 ESPECIFICAÇÃO FINAL - IMPLEMENTAÇÃO

**Data:** 08/11/2025  
**Status:** ✅ **PRONTO PARA IMPLEMENTAR**

---

## 🎯 OBJETIVO

Implementar detecção automática de URL base usando função `getServerBaseUrl()`, substituindo todas as URLs hardcoded nos arquivos JavaScript.

---

## 📊 ARQUIVOS E ALTERAÇÕES

### **ARQUIVO 1: FooterCodeSiteDefinitivoCompleto.js**

#### **Alteração 1.1: Adicionar função `getServerBaseUrl()`**
- **Localização:** Linha ~83 (após `try {`, antes das constantes)
- **Código:** Ver função completa abaixo

#### **Alteração 1.2: Substituir URL debug_logger_db.php**
- **Linha:** ~1129
- **De:** `fetch('https://bpsegurosimediato.com.br/logging_system/debug_logger_db.php'`
- **Para:** `fetch(\`\${getServerBaseUrl()}/debug_logger_db.php\``

#### **Alteração 1.3: Substituir URL cpf-validate.php**
- **Linha:** ~639
- **De:** `fetch('https://mdmidia.com.br/cpf-validate.php'`
- **Para:** `fetch(\`\${getServerBaseUrl()}/cpf-validate.php\``

#### **Alteração 1.4: Substituir URL placa-validate.php**
- **Linha:** ~698
- **De:** `fetch('https://mdmidia.com.br/placa-validate.php'`
- **Para:** `fetch(\`\${getServerBaseUrl()}/placa-validate.php\``

#### **Alteração 1.5: Substituir URL webflow_injection_limpo.js**
- **Linha:** ~1232
- **De:** `script.src = 'https://mdmidia.com.br/webflow_injection_limpo.js'`
- **Para:** `script.src = \`\${getServerBaseUrl()}/webflow_injection_limpo.js\``

#### **Alteração 1.6: Substituir URL MODAL_WHATSAPP_DEFINITIVO.js**
- **Linha:** ~1295
- **De:** `script.src = 'https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js?v=24&force=' + Math.random()`
- **Para:** `script.src = \`\${getServerBaseUrl()}/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=\` + Math.random()`

#### **Manter (URLs externas):**
- ✅ Linha ~679: `https://viacep.com.br/ws/` (API externa)
- ✅ Linha ~729: `https://apilayer.net/api/validate` (API externa)
- ✅ Linha ~776: `https://${window.SAFETY_TICKET}.safetymails.com/api/` (API externa)

---

### **ARQUIVO 2: MODAL_WHATSAPP_DEFINITIVO.js**

#### **Alteração 2.1: Adicionar função `getServerBaseUrl()`**
- **Localização:** Linha ~83 (após `try {`, antes das funções utilitárias)
- **Código:** Ver função completa abaixo

#### **Alteração 2.2: Reescrever função `getEndpointUrl()`**
- **Localização:** Linha ~152-192
- **Substituir todo o bloco por:**
```javascript
  function getEndpointUrl(endpoint) {
    const baseUrl = getServerBaseUrl();
    const endpoints = {
      travelangels: '/add_travelangels.php',
      octadesk: '/add_webflow_octa.php'
    };
    return baseUrl + (endpoints[endpoint] || '/add_flyingdonkeys.php');
  }
```

#### **Alteração 2.3: Substituir detecção de email endpoint**
- **Localização:** Linha ~727-731
- **De:**
```javascript
const isDev = isDevelopmentEnvironment();
const emailEndpoint = isDev 
  ? 'https://dev.bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint_dev.php'
  : 'https://bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint_prod.php';
```
- **Para:**
```javascript
const emailEndpoint = getServerBaseUrl() + '/send_email_notification_endpoint.php';
```

---

### **ARQUIVO 3: webflow_injection_limpo.js**

#### **Alteração 3.1: Adicionar função `getServerBaseUrl()`**
- **Localização:** Linha ~17 (após `'use strict';`, antes do CSS)
- **Código:** Ver função completa abaixo

#### **Alteração 3.2: Substituir URL de validação de placa**
- **Localização:** Linha ~2117
- **De:** `fetch('https://mdmidia.com.br/placa-validate.php'`
- **Para:** `fetch(\`\${getServerBaseUrl()}/placa-validate.php\``

#### **Manter (URLs externas):**
- ✅ Linha ~1081: `this.apiBaseUrl = 'https://rpaimediatoseguros.com.br'` (API externa RPA)
- ✅ Linha ~2527: `https://rpaimediatoseguros.com.br/api/rpa/start` (API externa)
- ✅ Linha ~2779: `https://webhook.site/...` (Webhook externo)
- ✅ Linha ~2794: `https://mdmidia.com.br/add_tra...` (Webhook externo)
- ✅ Linha ~2809: `https://mdmidia.com.br/add_we...` (Webhook externo)

---

## 🔧 FUNÇÃO `getServerBaseUrl()` - CÓDIGO COMPLETO

```javascript
// ==================== FUNÇÃO UTILITÁRIA - DETECÇÃO AUTOMÁTICA ====================
/**
 * Obter URL base do servidor automaticamente
 * Usa detecção inteligente baseada no contexto
 */
(function() {
    'use strict';
    
    if (typeof window.getServerBaseUrl === 'undefined') {
        window.getServerBaseUrl = function() {
            // 1. Tentar detectar do script atual (mais confiável)
            const scripts = document.getElementsByTagName('script');
            for (let script of scripts) {
                if (script.src && script.src.includes('bssegurosimediato.com.br')) {
                    try {
                        const url = new URL(script.src);
                        return url.origin;
                    } catch (e) {
                        // Continuar tentando
                    }
                }
            }
            
            // 2. Se estiver no mesmo domínio, usar origin
            if (window.location.hostname.includes('bssegurosimediato.com.br')) {
                return window.location.origin;
            }
            
            // 3. Detectar ambiente pelo hostname atual
            const hostname = window.location.hostname;
            if (hostname.includes('webflow.io') || 
                hostname.includes('localhost') || 
                hostname.includes('127.0.0.1')) {
                return 'https://dev.bssegurosimediato.com.br';
            }
            
            // 4. Fallback: produção
            return 'https://bssegurosimediato.com.br';
        };
    }
})();
// ==================== FIM FUNÇÃO UTILITÁRIA ====================
```

---

## 🗑️ ARQUIVOS A REMOVER

### **1. config.js.php (Local)**
- **Caminho:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.js.php`
- **Ação:** Deletar

### **2. config.js.php (Servidor)**
- **Caminho:** `/opt/webhooks-server/dev/root/config.js.php`
- **Ação:** Deletar via SSH

---

## 📋 RESUMO

| Arquivo | Função a Adicionar | URLs a Substituir | Total |
|---------|-------------------|-------------------|-------|
| `FooterCodeSiteDefinitivoCompleto.js` | ✅ 1x | ✅ 5x | 6 alterações |
| `MODAL_WHATSAPP_DEFINITIVO.js` | ✅ 1x | ✅ 2x (funções) | 3 alterações |
| `webflow_injection_limpo.js` | ✅ 1x | ✅ 1x | 2 alterações |
| **TOTAL** | **3** | **8** | **11 alterações** |

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

