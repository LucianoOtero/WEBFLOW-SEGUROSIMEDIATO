# 📋 ANÁLISE COMPLETA - ALTERAÇÕES NECESSÁRIAS

**Data:** 08/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA**

---

## 🎯 RESUMO EXECUTIVO

**Total de arquivos a modificar:** 3 arquivos JavaScript  
**Total de alterações:** 11 substituições de URLs + 3 funções a adicionar  
**Arquivos a remover:** 1 (`config.js.php`)

---

## 📊 ARQUIVO 1: FooterCodeSiteDefinitivoCompleto.js

### **Localização do arquivo:**
`WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

### **Alteração A1: Adicionar função `getServerBaseUrl()`**

**Localização:** Após linha 80 (após `(function() { 'use strict'; try {`)

**Código a inserir:**
```javascript
    // ==================== FUNÇÃO UTILITÁRIA - DETECÇÃO AUTOMÁTICA ====================
    /**
     * Obter URL base do servidor automaticamente
     * Usa detecção inteligente baseada no contexto
     */
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
    // ==================== FIM FUNÇÃO UTILITÁRIA ====================
```

---

### **Alteração B1: Substituir URL debug_logger_db.php**

**Localização:** Linha ~1129

**Código atual:**
```javascript
        fetch('https://bpsegurosimediato.com.br/logging_system/debug_logger_db.php', {
```

**Código novo:**
```javascript
        fetch(`${getServerBaseUrl()}/debug_logger_db.php`, {
```

**Nota:** Remover `/logging_system/` do caminho (arquivo está na raiz)

---

### **Alteração B2: Substituir URL cpf-validate.php**

**Localização:** Linha ~639

**Código atual:**
```javascript
    return fetch('https://mdmidia.com.br/cpf-validate.php', {
```

**Código novo:**
```javascript
    return fetch(`${getServerBaseUrl()}/cpf-validate.php`, {
```

---

### **Alteração B3: Substituir URL placa-validate.php**

**Localização:** Linha ~698

**Código atual:**
```javascript
    return fetch('https://mdmidia.com.br/placa-validate.php', {
```

**Código novo:**
```javascript
    return fetch(`${getServerBaseUrl()}/placa-validate.php`, {
```

---

### **Alteração B4: Substituir URL webflow_injection_limpo.js**

**Localização:** Linha ~1232

**Código atual:**
```javascript
          script.src = 'https://mdmidia.com.br/webflow_injection_limpo.js';
```

**Código novo:**
```javascript
          script.src = `${getServerBaseUrl()}/webflow_injection_limpo.js`;
```

---

### **Alteração B5: Substituir URL MODAL_WHATSAPP_DEFINITIVO.js**

**Localização:** Linha ~1295

**Código atual:**
```javascript
        script.src = 'https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js?v=24&force=' + Math.random();
```

**Código novo:**
```javascript
        script.src = `${getServerBaseUrl()}/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=` + Math.random();
```

**Nota:** Remover `/webhooks/` e `_dev` do nome do arquivo

---

### **URLs a MANTER (externas):**
- ✅ Linha ~679: `https://viacep.com.br/ws/` (API externa)
- ✅ Linha ~729: `https://apilayer.net/api/validate` (API externa)
- ✅ Linha ~776: `https://${window.SAFETY_TICKET}.safetymails.com/api/` (API externa dinâmica)

---

## 📊 ARQUIVO 2: MODAL_WHATSAPP_DEFINITIVO.js

### **Localização do arquivo:**
`WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`

### **Alteração A2: Adicionar função `getServerBaseUrl()`**

**Localização:** Após linha 80 (após `(function() { 'use strict'; try {`)

**Código:** Mesmo código da Alteração A1

---

### **Alteração C1: Reescrever função `getEndpointUrl()`**

**Localização:** Linha ~152-192

**Código atual (completo):**
```javascript
  function getEndpointUrl(endpoint) {
    const hostname = window.location.hostname;
    
    // SOLUÇÃO DEFINITIVA: FORÇAR _dev para webflow.io SEMPRE
    if (hostname.indexOf('webflow.io') !== -1) {
      console.log('✅ [ENDPOINT] FORÇANDO DEV para webflow.io');
      const devEndpoints = {
        travelangels: 'https://bpsegurosimediato.com.br/dev/webhooks/add_travelangels_dev.php',
        octadesk: 'https://bpsegurosimediato.com.br/dev/webhooks/add_webflow_octa_dev.php'
      };
      const url = devEndpoints[endpoint];
      console.log('🌍 [ENDPOINT] URL FORÇADA (webflow.io):', url);
      return url;
    }
    
    // Para outros ambientes, usar detecção normal
    const isDev = isDevelopmentEnvironment();
    
    const endpoints = {
      travelangels: {
        dev: 'https://bpsegurosimediato.com.br/dev/webhooks/add_travelangels_dev.php',
        prod: 'https://bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_prod.php'
      },
      octadesk: {
        dev: 'https://bpsegurosimediato.com.br/dev/webhooks/add_webflow_octa_dev.php',
        prod: 'https://bpsegurosimediato.com.br/webhooks/add_webflow_octa_prod.php'
      }
    };
    
    const env = isDev ? 'dev' : 'prod';
    let url = endpoints[endpoint][env];
    
    console.log('🌍 [ENDPOINT] hostname:', hostname);
    console.log('🌍 [ENDPOINT] isDev:', isDev);
    console.log('🌍 [ENDPOINT] env:', env);
    console.log('🌍 [ENDPOINT] URL escolhida:', url);
    
    return url;
  }
```

**Código novo (simplificado):**
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

### **Alteração C2: Substituir detecção de email endpoint**

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

## 📊 ARQUIVO 3: webflow_injection_limpo.js

### **Localização do arquivo:**
`WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`

### **Alteração A3: Adicionar função `getServerBaseUrl()`**

**Localização:** Linha ~1-30 (no início do arquivo, antes de qualquer código)

**Código:** Mesmo código da Alteração A1

---

### **Alteração D1: Modificar `apiBaseUrl` no construtor**

**Localização:** Linha ~1081

**Código atual:**
```javascript
            this.apiBaseUrl = 'https://rpaimediatoseguros.com.br';
```

**Código novo:**
```javascript
            this.apiBaseUrl = getServerBaseUrl();
```

**Nota:** Verificar se `apiBaseUrl` é usado para endpoints PHP ou para API externa. Se for API externa, manter original.

---

### **Alteração D2: Substituir URL de validação de placa**

**Localização:** Linha ~2117

**Código atual:**
```javascript
                const response = await fetch('https://mdmidia.com.br/placa-validate.php', {
```

**Código novo:**
```javascript
                const response = await fetch(`${getServerBaseUrl()}/placa-validate.php`, {
```

---

### **URLs a MANTER (externas):**
- ✅ Linha ~2527: `https://rpaimediatoseguros.com.br/api/rpa/start` (API externa RPA)
- ✅ Linha ~2779: `https://webhook.site/...` (Webhook externo)
- ✅ Linha ~2794: `https://mdmidia.com.br/add_tra...` (Webhook externo)
- ✅ Linha ~2809: `https://mdmidia.com.br/add_we...` (Webhook externo)

---

## 🗑️ ARQUIVOS A REMOVER

### **1. config.js.php (Local)**
**Caminho:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.js.php`  
**Ação:** Deletar arquivo

### **2. config.js.php (Servidor)**
**Caminho:** `/opt/webhooks-server/dev/root/config.js.php`  
**Ação:** Deletar via SSH: `ssh root@65.108.156.14 "rm /opt/webhooks-server/dev/root/config.js.php"`

---

## 📋 CHECKLIST COMPLETO

### **FooterCodeSiteDefinitivoCompleto.js:**
- [ ] A1: Adicionar função `getServerBaseUrl()` após linha 80
- [ ] B1: Substituir URL debug_logger_db.php (linha ~1129)
- [ ] B2: Substituir URL cpf-validate.php (linha ~639)
- [ ] B3: Substituir URL placa-validate.php (linha ~698)
- [ ] B4: Substituir URL webflow_injection_limpo.js (linha ~1232)
- [ ] B5: Substituir URL MODAL_WHATSAPP_DEFINITIVO.js (linha ~1295)

### **MODAL_WHATSAPP_DEFINITIVO.js:**
- [ ] A2: Adicionar função `getServerBaseUrl()` após linha 80
- [ ] C1: Reescrever função `getEndpointUrl()` (linha ~152)
- [ ] C2: Substituir detecção de email endpoint (linha ~727)

### **webflow_injection_limpo.js:**
- [ ] A3: Adicionar função `getServerBaseUrl()` no início (linha ~1)
- [ ] D1: Modificar `apiBaseUrl` (linha ~1081) - **VERIFICAR SE É API EXTERNA**
- [ ] D2: Substituir URL de validação de placa (linha ~2117)

### **Limpeza:**
- [ ] Deletar `config.js.php` local
- [ ] Deletar `config.js.php` do servidor

---

## ⚠️ NOTAS IMPORTANTES

1. **Verificar `apiBaseUrl` em webflow_injection_limpo.js:**
   - Se for usado para API externa RPA → **MANTER** original
   - Se for usado para endpoints PHP → **SUBSTITUIR** por `getServerBaseUrl()`

2. **Caminhos dos arquivos:**
   - Remover `/logging_system/` de debug_logger_db.php
   - Remover `/webhooks/` e `_dev` de MODAL_WHATSAPP_DEFINITIVO.js
   - Arquivos estão na raiz: `/var/www/html/dev/root/`

3. **URLs externas:**
   - ViaCEP, APILayer, SafetyMails → **MANTER**
   - rpaimediatoseguros.com.br → **VERIFICAR** se é externa
   - webhook.site, mdmidia.com.br/add_* → **MANTER** (externos)

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

