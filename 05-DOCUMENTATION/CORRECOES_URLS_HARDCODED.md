# 🔧 CORREÇÕES NECESSÁRIAS - URLs HARDCODED

**Data:** 10/11/2025  
**Prioridade:** 🔴 **ALTA** - URLs externas hardcoded encontradas

---

## 📊 RESUMO

**Total de Problemas:** 11 URLs hardcoded  
**Críticos:** 5 (URLs externas `mdmidia.com.br`)  
**Médios:** 6 (Fallbacks DEV/PROD)

---

## 🔴 CORREÇÕES CRÍTICAS (URLs Externas)

### 1. FooterCodeSiteDefinitivoCompleto.js

#### Correção 1.1: Linha ~342 - `sendLogToProfessionalSystem()`
**Atual:**
```javascript
const baseUrl = window.APP_BASE_URL || 'https://dev.bssegurosimediato.com.br';
```

**Correto:**
```javascript
const baseUrl = window.APP_BASE_URL || detectServerBaseUrl();
```

---

#### Correção 1.2: Linha ~964 - `validateCPF()`
**Atual:**
```javascript
const cpfUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/cpf-validate.php' : 'https://mdmidia.com.br/cpf-validate.php';
```

**Correto:**
```javascript
const cpfUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/cpf-validate.php' : detectServerBaseUrl() + '/cpf-validate.php';
```

---

#### Correção 1.3: Linha ~1024 - `validatePlaca()`
**Atual:**
```javascript
const placaUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/placa-validate.php' : 'https://mdmidia.com.br/placa-validate.php';
```

**Correto:**
```javascript
const placaUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/placa-validate.php' : detectServerBaseUrl() + '/placa-validate.php';
```

---

#### Correção 1.4: Linha ~1518 - Injeção `webflow_injection_limpo.js`
**Atual:**
```javascript
script.src = window.APP_BASE_URL ? window.APP_BASE_URL + '/webflow_injection_limpo.js' : 'https://mdmidia.com.br/webflow_injection_limpo.js';
```

**Correto:**
```javascript
script.src = window.APP_BASE_URL ? window.APP_BASE_URL + '/webflow_injection_limpo.js' : detectServerBaseUrl() + '/webflow_injection_limpo.js';
```

---

#### Correção 1.5: Linha ~1594 - Injeção `MODAL_WHATSAPP_DEFINITIVO.js`
**Atual:**
```javascript
script.src = window.APP_BASE_URL ? window.APP_BASE_URL + '/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random() : 'https://dev.bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random();
```

**Correto:**
```javascript
script.src = window.APP_BASE_URL ? window.APP_BASE_URL + '/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random() : detectServerBaseUrl() + '/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random();
```

---

### 2. MODAL_WHATSAPP_DEFINITIVO.js

#### Correção 2.1: Linhas ~158-160 - `getEndpointUrl()` fallback
**Atual:**
```javascript
const isDev = isDevelopmentEnvironment();
const fallbackBase = isDev 
  ? 'https://dev.bssegurosimediato.com.br'
  : 'https://bssegurosimediato.com.br';
```

**Correto:**
```javascript
// Usar detectServerBaseUrl() se disponível, senão usar detecção de ambiente
const fallbackBase = (typeof detectServerBaseUrl === 'function') 
  ? detectServerBaseUrl() 
  : (isDev ? 'https://dev.bssegurosimediato.com.br' : 'https://bssegurosimediato.com.br');
```

**Nota:** Idealmente, `detectServerBaseUrl()` deveria estar disponível globalmente ou ser importado.

---

#### Correção 2.2: Linhas ~721-722 - `sendAdminEmailNotification()` fallback
**Atual:**
```javascript
emailEndpoint = window.APP_BASE_URL 
  ? window.APP_BASE_URL + '/send_email_notification_endpoint.php'
  : (isDevelopmentEnvironment() 
      ? 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php'
      : 'https://bssegurosimediato.com.br/send_email_notification_endpoint.php');
```

**Correto:**
```javascript
emailEndpoint = window.APP_BASE_URL 
  ? window.APP_BASE_URL + '/send_email_notification_endpoint.php'
  : ((typeof detectServerBaseUrl === 'function') 
      ? detectServerBaseUrl() + '/send_email_notification_endpoint.php'
      : (isDevelopmentEnvironment() 
          ? 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php'
          : 'https://bssegurosimediato.com.br/send_email_notification_endpoint.php'));
```

---

### 3. webflow_injection_limpo.js

#### Correção 3.1: Linha ~2117 - Validação de placa
**Atual:**
```javascript
const placaUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/placa-validate.php' : 'https://mdmidia.com.br/placa-validate.php';
```

**Correto:**
```javascript
const placaUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/placa-validate.php' : (typeof detectServerBaseUrl === 'function' ? detectServerBaseUrl() : window.location.origin) + '/placa-validate.php';
```

---

#### Correção 3.2: Linhas ~2795, 2810 - Código legado
**Atual:**
```javascript
const response = await fetch('https://mdmidia.com.br/add_tra...', {
const response = await fetch('https://mdmidia.com.br/add_we...', {
```

**Correção:** **REMOVER** ou **COMENTAR** este código legado, pois não é mais usado.

---

## 🟡 CORREÇÕES MÉDIAS (CORS Hardcoded)

### 4. add_flyingdonkeys.php

#### Correção 4.1: Usar `getCorsOrigins()` de `config.php`
**Atual:**
```php
$allowed_origins = array(
    'https://www.segurosimediato.com.br',
    'https://segurosimediato.com.br',
    'https://dev.bssegurosimediato.com.br',
    // ... lista hardcoded
);
```

**Correto:**
```php
require_once __DIR__ . '/config.php';
$allowed_origins = getCorsOrigins();
```

---

### 5. add_webflow_octa.php

#### Correção 5.1: Usar `getCorsOrigins()` de `config.php`
**Atual:**
```php
$allowed_origins = array(
    'https://www.segurosimediato.com.br',
    'https://segurosimediato.com.br',
    'https://dev.bssegurosimediato.com.br',
    // ... lista hardcoded
);
```

**Correto:**
```php
require_once __DIR__ . '/config.php';
$allowed_origins = getCorsOrigins();
```

---

## 📋 CHECKLIST DE CORREÇÕES

### JavaScript
- [ ] FooterCodeSiteDefinitivoCompleto.js linha 342
- [ ] FooterCodeSiteDefinitivoCompleto.js linha 964
- [ ] FooterCodeSiteDefinitivoCompleto.js linha 1024
- [ ] FooterCodeSiteDefinitivoCompleto.js linha 1518
- [ ] FooterCodeSiteDefinitivoCompleto.js linha 1594
- [ ] MODAL_WHATSAPP_DEFINITIVO.js linhas 158-160
- [ ] MODAL_WHATSAPP_DEFINITIVO.js linhas 721-722
- [ ] webflow_injection_limpo.js linha 2117
- [ ] webflow_injection_limpo.js linhas 2795, 2810 (remover código legado)

### PHP
- [ ] add_flyingdonkeys.php - Usar `getCorsOrigins()`
- [ ] add_webflow_octa.php - Usar `getCorsOrigins()`

---

## ⚠️ OBSERVAÇÕES

### Fallbacks Aceitáveis (Não Corrigir)
- `config.php` linha 62-66 - Fallback em `getBaseUrl()` (aceitável)
- `config_env.js.php` linha 18 - Fallback em variável (aceitável)
- `ProfessionalLogger.php` linhas 594-597 - Fallback em variável (aceitável)

Estes fallbacks são aceitáveis pois:
1. São usados apenas quando variáveis de ambiente não estão definidas
2. São fallbacks de último recurso
3. Não apontam para URLs externas

---

**Documento criado em:** 10/11/2025

