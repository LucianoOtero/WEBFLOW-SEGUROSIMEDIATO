# 📍 MAPEAMENTO COMPLETO DE ALTERAÇÕES

**Data:** 08/11/2025  
**Status:** 📋 **MAPEAMENTO DETALHADO**

---

## 🎯 OBJETIVO

Substituir todas as URLs hardcoded por detecção automática usando `getServerBaseUrl()`.

---

## 📊 ARQUIVO 1: FooterCodeSiteDefinitivoCompleto.js

### **A. Adicionar função `getServerBaseUrl()`**

**Localização:** Após linha ~80 (após tratamento de erro global, antes das constantes)

**Código a adicionar:**
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

### **B. Substituir URLs hardcoded**

#### **1. Linha ~1129 - debug_logger_db.php**
**Código atual:**
```javascript
fetch('https://bpsegurosimediato.com.br/logging_system/debug_logger_db.php', {
```

**Código novo:**
```javascript
fetch(`${getServerBaseUrl()}/debug_logger_db.php`, {
```

---

#### **2. Linha ~639 - cpf-validate.php**
**Código atual:**
```javascript
return fetch('https://mdmidia.com.br/cpf-validate.php', {
```

**Código novo:**
```javascript
return fetch(`${getServerBaseUrl()}/cpf-validate.php`, {
```

---

#### **3. Linha ~698 - placa-validate.php**
**Código atual:**
```javascript
return fetch('https://mdmidia.com.br/placa-validate.php', {
```

**Código novo:**
```javascript
return fetch(`${getServerBaseUrl()}/placa-validate.php`, {
```

---

#### **4. Linha ~679 - viacep (MANTER)**
**Código atual:**
```javascript
return fetch('https://viacep.com.br/ws/' + cep + '/json/')
```
**Ação:** ✅ **MANTER** (URL externa, não precisa alterar)

---

#### **5. Linha ~729 - apilayer (MANTER)**
**Código atual:**
```javascript
return fetch('https://apilayer.net/api/validate?access_key=' + window.APILAYER_KEY + '&country_code=BR&number=' + nat)
```
**Ação:** ✅ **MANTER** (URL externa, não precisa alterar)

---

#### **6. Linha ~776 - safetymails (MANTER)**
**Código atual:**
```javascript
const url = `https://${window.SAFETY_TICKET}.safetymails.com/api/${code}`;
```
**Ação:** ✅ **MANTER** (URL externa dinâmica, não precisa alterar)

---

#### **7. Linha ~1232 - webflow_injection_limpo.js**
**Código atual:**
```javascript
script.src = 'https://mdmidia.com.br/webflow_injection_limpo.js';
```

**Código novo:**
```javascript
script.src = `${getServerBaseUrl()}/webflow_injection_limpo.js`;
```

---

#### **8. Linha ~1295 - MODAL_WHATSAPP_DEFINITIVO.js**
**Código atual:**
```javascript
script.src = 'https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js?v=24&force=' + Math.random();
```

**Código novo:**
```javascript
script.src = `${getServerBaseUrl()}/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=` + Math.random();
```

---

### **C. Remover referências a window.APP_CONFIG (se existirem)**

**Verificar linhas:** ~1130-1132, ~1240, ~1304-1306  
**Ação:** Se houver código verificando `window.APP_CONFIG`, remover e usar `getServerBaseUrl()` diretamente

---

## 📊 ARQUIVO 2: MODAL_WHATSAPP_DEFINITIVO.js

### **A. Adicionar função `getServerBaseUrl()`**

**Localização:** Após linha ~80 (após tratamento de erro, antes das funções utilitárias)

**Código:** Mesmo código do arquivo 1

---

### **B. Reescrever função `getEndpointUrl()`**

**Localização:** Linha ~152-192

**Código atual:**
```javascript
function getEndpointUrl(endpoint) {
    // Usar window.APP_CONFIG se disponível
    if (window.APP_CONFIG && window.APP_CONFIG.getEndpointUrl) {
        // ... código com APP_CONFIG
    }
    
    // Fallback para lógica antiga
    const hostname = window.location.hostname;
    // ... código complexo de detecção
}
```

**Código novo:**
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

---

### **C. Substituir detecção de email endpoint**

**Localização:** Linha ~727-731

**Código atual:**
```javascript
// Determinar URL do endpoint (dev ou prod)
const isDev = isDevelopmentEnvironment();
const emailEndpoint = isDev 
    ? 'https://dev.bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint_dev.php'
    : 'https://bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint_prod.php';
```

**Código novo:**
```javascript
const emailEndpoint = getServerBaseUrl() + '/send_email_notification_endpoint.php';
```

---

### **D. Remover referências a window.APP_CONFIG**

**Verificar linhas:** ~154-164, ~741-742  
**Ação:** Remover código que verifica `window.APP_CONFIG`

---

## 📊 ARQUIVO 3: webflow_injection_limpo.js

### **A. Adicionar função `getServerBaseUrl()`**

**Localização:** Linha ~1-50 (no início do arquivo, antes das classes)

**Código:** Mesmo código do arquivo 1

---

### **B. Modificar `apiBaseUrl` no construtor**

**Localização:** Linha ~1081

**Código atual:**
```javascript
this.apiBaseUrl = 'https://rpaimediatoseguros.com.br';
```

**Código novo:**
```javascript
this.apiBaseUrl = getServerBaseUrl();
```

---

### **C. Substituir URL de validação de placa**

**Localização:** Linha ~2117-2125

**Código atual:**
```javascript
const response = await fetch('https://mdmidia.com.br/placa-validate.php', {
```

**Código novo:**
```javascript
const response = await fetch(`${getServerBaseUrl()}/placa-validate.php`, {
```

---

### **D. URLs externas (MANTER)**

**Linhas:** ~2527, ~2779, ~2794, ~2809  
**Ação:** ✅ **MANTER** (URLs externas: rpaimediatoseguros.com.br, webhook.site, mdmidia.com.br/add_*)

---

### **E. Remover referências a window.APP_CONFIG**

**Verificar linhas:** ~1082-1084, ~2121-2123  
**Ação:** Remover código que verifica `window.APP_CONFIG`

---

## 🗑️ ARQUIVOS A REMOVER

### **1. config.js.php (Local)**
**Caminho:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.js.php`  
**Ação:** Deletar arquivo

### **2. config.js.php (Servidor)**
**Caminho:** `/opt/webhooks-server/dev/root/config.js.php`  
**Ação:** Deletar via SSH

---

## 📋 RESUMO DAS ALTERAÇÕES

### **FooterCodeSiteDefinitivoCompleto.js:**
- ✅ Adicionar função `getServerBaseUrl()` (~linha 80)
- ✅ Substituir 4 URLs hardcoded (linhas ~1129, ~639, ~698, ~1232, ~1295)
- ✅ Manter 3 URLs externas (viacep, apilayer, safetymails)
- ✅ Remover referências a `window.APP_CONFIG` (se existirem)

### **MODAL_WHATSAPP_DEFINITIVO.js:**
- ✅ Adicionar função `getServerBaseUrl()` (~linha 80)
- ✅ Reescrever função `getEndpointUrl()` (linha ~152)
- ✅ Substituir detecção de email endpoint (linha ~727)
- ✅ Remover referências a `window.APP_CONFIG` (se existirem)

### **webflow_injection_limpo.js:**
- ✅ Adicionar função `getServerBaseUrl()` (~linha 1)
- ✅ Modificar `apiBaseUrl` (linha ~1081)
- ✅ Substituir URL de validação de placa (linha ~2117)
- ✅ Manter URLs externas (rpaimediatoseguros, webhook.site, mdmidia/add_*)
- ✅ Remover referências a `window.APP_CONFIG` (se existirem)

### **Limpeza:**
- ✅ Deletar `config.js.php` (local e servidor)

---

## 🎯 TOTAL DE ALTERAÇÕES

- **Arquivos JavaScript:** 3
- **Funções a adicionar:** 3 (uma por arquivo)
- **URLs a substituir:** 8
- **URLs a manter:** 7 (externas)
- **Arquivos a deletar:** 1 (`config.js.php`)

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

