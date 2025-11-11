# 📋 PLANO DE ALTERAÇÕES - DETECÇÃO AUTOMÁTICA

**Data:** 08/11/2025  
**Status:** 📋 **ANÁLISE COMPLETA**

---

## 🎯 OBJETIVO

Implementar detecção automática de URL base do servidor em todos os arquivos JavaScript, substituindo URLs hardcoded e removendo referências a `window.APP_CONFIG`.

---

## 📊 ARQUIVOS A MODIFICAR

### **1. FooterCodeSiteDefinitivoCompleto.js**
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Alterações necessárias:**

#### **A. Adicionar função `getServerBaseUrl()` no início:**
- **Linha:** ~80-100 (após tratamento de erro global, antes das constantes)
- **Ação:** Adicionar função utilitária completa

#### **B. Substituir URLs hardcoded (8 locais):**

| # | Linha Aprox. | Código Atual | Código Novo |
|---|--------------|--------------|-------------|
| 1 | ~1129 | `fetch('https://dev.bssegurosimediato.com.br/debug_logger_db.php'` | `fetch(\`\${getServerBaseUrl()}/debug_logger_db.php\`` |
| 2 | ~639 | `fetch('https://mdmidia.com.br/cpf-validate.php'` | `fetch(\`\${getServerBaseUrl()}/cpf-validate.php\`` |
| 3 | ~698 | `fetch('https://mdmidia.com.br/placa-validate.php'` | `fetch(\`\${getServerBaseUrl()}/placa-validate.php\`` |
| 4 | ~679 | `fetch('https://viacep.com.br/ws/'` | Manter (URL externa) |
| 5 | ~729 | `fetch('https://apilayer.net/api/validate'` | Manter (URL externa) |
| 6 | ~776 | `` `https://${window.SAFETY_TICKET}.safetymails.com/api/${code}` `` | Manter (URL externa) |
| 7 | ~1232 | `script.src = 'https://mdmidia.com.br/webflow_injection_limpo.js'` | `script.src = \`\${getServerBaseUrl()}/webflow_injection_limpo.js\`` |
| 8 | ~1295 | `script.src = 'https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js'` | `script.src = \`\${getServerBaseUrl()}/MODAL_WHATSAPP_DEFINITIVO.js\`` |

#### **C. Remover referências a `window.APP_CONFIG`:**
- **Linhas:** ~1130-1132, ~1240, ~1304-1306
- **Ação:** Remover código que verifica `window.APP_CONFIG` e usar `getServerBaseUrl()` diretamente

---

### **2. MODAL_WHATSAPP_DEFINITIVO.js**
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`

**Alterações necessárias:**

#### **A. Adicionar função `getServerBaseUrl()` no início:**
- **Linha:** ~80-100 (após tratamento de erro, antes das funções utilitárias)
- **Ação:** Adicionar função utilitária completa

#### **B. Modificar função `getEndpointUrl()`:**
- **Linha:** ~152-204
- **Ação:** Substituir lógica atual por:
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

#### **C. Modificar detecção de email endpoint:**
- **Linha:** ~740-749
- **Ação:** Substituir por:
  ```javascript
  const emailEndpoint = getServerBaseUrl() + '/send_email_notification_endpoint.php';
  ```

#### **D. Remover referências a `window.APP_CONFIG`:**
- **Linhas:** ~154-164, ~741-742
- **Ação:** Remover código que verifica `window.APP_CONFIG`

---

### **3. webflow_injection_limpo.js**
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`

**Alterações necessárias:**

#### **A. Adicionar função `getServerBaseUrl()` no início:**
- **Linha:** ~1-50 (no início do arquivo, antes das classes)
- **Ação:** Adicionar função utilitária completa

#### **B. Modificar `apiBaseUrl` no construtor:**
- **Linha:** ~1081-1084
- **Ação:** Substituir por:
  ```javascript
  this.apiBaseUrl = getServerBaseUrl();
  ```

#### **C. Substituir URL de validação de placa:**
- **Linha:** ~2120-2123
- **Ação:** Substituir por:
  ```javascript
  const placaValidateUrl = getServerBaseUrl() + '/placa-validate.php';
  ```

#### **D. Remover referências a `window.APP_CONFIG`:**
- **Linhas:** ~1082-1084, ~2121-2123
- **Ação:** Remover código que verifica `window.APP_CONFIG`

---

## 🗑️ ARQUIVOS A REMOVER

### **1. config.js.php**
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.js.php`  
**Ação:** Deletar arquivo (não é necessário)

**Também remover do servidor:**
- `/opt/webhooks-server/dev/root/config.js.php`

---

## ✅ ARQUIVOS QUE NÃO PRECISAM MODIFICAÇÃO

### **Arquivos PHP:**
- ✅ `config.php` - Já está correto (usa `$_ENV`)
- ✅ `add_travelangels.php` - Já usa `config.php` corretamente
- ✅ `add_flyingdonkeys.php` - Já usa `config.php` corretamente
- ✅ `add_webflow_octa.php` - Já usa `config.php` corretamente
- ✅ Todos os outros arquivos PHP - Já estão corretos

---

## 📝 RESUMO DAS ALTERAÇÕES

### **Arquivos JavaScript (3 arquivos):**

| Arquivo | Função a Adicionar | URLs a Substituir | Referências APP_CONFIG a Remover |
|---------|-------------------|-------------------|----------------------------------|
| `FooterCodeSiteDefinitivoCompleto.js` | ✅ Sim (~linha 80) | ✅ 6 URLs | ✅ 3 locais |
| `MODAL_WHATSAPP_DEFINITIVO.js` | ✅ Sim (~linha 80) | ✅ 2 funções | ✅ 2 locais |
| `webflow_injection_limpo.js` | ✅ Sim (~linha 1) | ✅ 2 URLs | ✅ 2 locais |

### **Arquivos a Remover:**
- ❌ `config.js.php` (local e servidor)

---

## 🔧 FUNÇÃO A ADICIONAR

### **Código completo da função:**

```javascript
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
```

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **FooterCodeSiteDefinitivoCompleto.js:**
- [ ] Adicionar função `getServerBaseUrl()` no início
- [ ] Substituir `fetch('https://dev.bssegurosimediato.com.br/debug_logger_db.php'` → `fetch(\`\${getServerBaseUrl()}/debug_logger_db.php\``
- [ ] Substituir `fetch('https://mdmidia.com.br/cpf-validate.php'` → `fetch(\`\${getServerBaseUrl()}/cpf-validate.php\``
- [ ] Substituir `fetch('https://mdmidia.com.br/placa-validate.php'` → `fetch(\`\${getServerBaseUrl()}/placa-validate.php\``
- [ ] Substituir `script.src = 'https://mdmidia.com.br/webflow_injection_limpo.js'` → `script.src = \`\${getServerBaseUrl()}/webflow_injection_limpo.js\``
- [ ] Substituir `script.src = 'https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js'` → `script.src = \`\${getServerBaseUrl()}/MODAL_WHATSAPP_DEFINITIVO.js\``
- [ ] Remover referências a `window.APP_CONFIG`

### **MODAL_WHATSAPP_DEFINITIVO.js:**
- [ ] Adicionar função `getServerBaseUrl()` no início
- [ ] Reescrever função `getEndpointUrl()` para usar `getServerBaseUrl()`
- [ ] Substituir detecção de email endpoint
- [ ] Remover referências a `window.APP_CONFIG`

### **webflow_injection_limpo.js:**
- [ ] Adicionar função `getServerBaseUrl()` no início
- [ ] Substituir `this.apiBaseUrl = 'https://rpaimediatoseguros.com.br'` → `this.apiBaseUrl = getServerBaseUrl()`
- [ ] Substituir URL de validação de placa
- [ ] Remover referências a `window.APP_CONFIG`

### **Limpeza:**
- [ ] Deletar `config.js.php` local
- [ ] Deletar `config.js.php` do servidor

---

## 🎯 ORDEM DE EXECUÇÃO

1. **Adicionar função `getServerBaseUrl()`** em cada arquivo .js
2. **Substituir URLs hardcoded** por `getServerBaseUrl()`
3. **Remover referências a `window.APP_CONFIG`**
4. **Deletar `config.js.php`** (local e servidor)
5. **Testar** cada arquivo

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

