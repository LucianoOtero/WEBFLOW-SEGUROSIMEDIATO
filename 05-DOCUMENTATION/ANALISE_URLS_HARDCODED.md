# 🔍 ANÁLISE: URLs HARDCODED vs VARIÁVEIS DE AMBIENTE

**Data:** 10/11/2025  
**Objetivo:** Identificar todas as chamadas hardcoded que não usam variáveis de ambiente

---

## 📊 RESUMO EXECUTIVO

**Total de Problemas Encontrados:** 8 URLs hardcoded  
**Arquivos Afetados:** 4 arquivos principais

---

## ⚠️ PROBLEMAS IDENTIFICADOS

### 1. FooterCodeSiteDefinitivoCompleto.js

#### Problema 1.1: Fallback hardcoded em `sendLogToProfessionalSystem()`
**Linha:** ~342
```javascript
const baseUrl = window.APP_BASE_URL || 'https://dev.bssegurosimediato.com.br';
```
**Status:** ⚠️ **FALLBACK HARDCODED**  
**Impacto:** Médio - Usa fallback apenas se `APP_BASE_URL` não estiver disponível  
**Correção:** Usar `detectServerBaseUrl()` como fallback

#### Problema 1.2: Fallback hardcoded em `validateCPF()`
**Linha:** ~964
```javascript
const cpfUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/cpf-validate.php' : 'https://mdmidia.com.br/cpf-validate.php';
```
**Status:** ❌ **FALLBACK HARDCODED (URL EXTERNA)**  
**Impacto:** Alto - Fallback aponta para URL externa (`mdmidia.com.br`)  
**Correção:** Usar `detectServerBaseUrl()` como fallback

#### Problema 1.3: Fallback hardcoded em `validatePlaca()`
**Linha:** ~1024
```javascript
const placaUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/placa-validate.php' : 'https://mdmidia.com.br/placa-validate.php';
```
**Status:** ❌ **FALLBACK HARDCODED (URL EXTERNA)**  
**Impacto:** Alto - Fallback aponta para URL externa (`mdmidia.com.br`)  
**Correção:** Usar `detectServerBaseUrl()` como fallback

#### Problema 1.4: Fallback hardcoded em injeção de `webflow_injection_limpo.js`
**Linha:** ~1518
```javascript
script.src = window.APP_BASE_URL ? window.APP_BASE_URL + '/webflow_injection_limpo.js' : 'https://mdmidia.com.br/webflow_injection_limpo.js';
```
**Status:** ❌ **FALLBACK HARDCODED (URL EXTERNA)**  
**Impacto:** Alto - Fallback aponta para URL externa (`mdmidia.com.br`)  
**Correção:** Usar `detectServerBaseUrl()` como fallback

#### Problema 1.5: Fallback hardcoded em injeção de `MODAL_WHATSAPP_DEFINITIVO.js`
**Linha:** ~1594
```javascript
script.src = window.APP_BASE_URL ? window.APP_BASE_URL + '/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random() : 'https://dev.bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random();
```
**Status:** ⚠️ **FALLBACK HARDCODED**  
**Impacto:** Médio - Fallback aponta para DEV hardcoded  
**Correção:** Usar `detectServerBaseUrl()` como fallback

---

### 2. MODAL_WHATSAPP_DEFINITIVO.js

#### Problema 2.1: Fallback hardcoded em `getEndpointUrl()`
**Linhas:** ~158-160
```javascript
const isDev = isDevelopmentEnvironment();
const fallbackBase = isDev 
  ? 'https://dev.bssegurosimediato.com.br'
  : 'https://bssegurosimediato.com.br';
```
**Status:** ⚠️ **FALLBACK HARDCODED**  
**Impacto:** Médio - Usa detecção de ambiente como fallback  
**Correção:** Usar `detectServerBaseUrl()` como fallback

#### Problema 2.2: Fallback hardcoded em `sendAdminEmailNotification()`
**Linhas:** ~721-722
```javascript
emailEndpoint = window.APP_BASE_URL 
  ? window.APP_BASE_URL + '/send_email_notification_endpoint.php'
  : (isDevelopmentEnvironment() 
      ? 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php'
      : 'https://bssegurosimediato.com.br/send_email_notification_endpoint.php');
```
**Status:** ⚠️ **FALLBACK HARDCODED**  
**Impacto:** Médio - Usa detecção de ambiente como fallback  
**Correção:** Usar `detectServerBaseUrl()` como fallback

---

### 3. webflow_injection_limpo.js

#### Problema 3.1: Fallback hardcoded em validação de placa
**Linha:** ~2117
```javascript
const placaUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/placa-validate.php' : 'https://mdmidia.com.br/placa-validate.php';
```
**Status:** ❌ **FALLBACK HARDCODED (URL EXTERNA)**  
**Impacto:** Alto - Fallback aponta para URL externa (`mdmidia.com.br`)  
**Correção:** Usar `detectServerBaseUrl()` como fallback

#### Problema 3.2: URLs hardcoded em código legado (linhas 2795, 2810)
**Linhas:** ~2795, ~2810
```javascript
const response = await fetch('https://mdmidia.com.br/add_tra...', {
const response = await fetch('https://mdmidia.com.br/add_we...', {
```
**Status:** ❌ **URLS HARDCODED (CÓDIGO LEGADO)**  
**Impacto:** Alto - URLs externas hardcoded  
**Correção:** Remover ou substituir por variáveis de ambiente

---

### 4. config.php

#### Problema 4.1: Fallback hardcoded em `getBaseUrl()`
**Linhas:** ~62-66
```php
if (isDevelopment()) {
    $baseUrl = 'https://dev.bssegurosimediato.com.br';
} else {
    $baseUrl = 'https://bssegurosimediato.com.br';
}
```
**Status:** ⚠️ **FALLBACK HARDCODED**  
**Impacto:** Baixo - Fallback apenas se `APP_BASE_URL` não estiver definido  
**Observação:** Este é um fallback aceitável, mas idealmente deveria usar detecção automática

---

### 5. config_env.js.php

#### Problema 5.1: Fallback hardcoded
**Linha:** ~18
```php
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
```
**Status:** ⚠️ **FALLBACK HARDCODED**  
**Impacto:** Baixo - Fallback apenas se variável não estiver definida  
**Observação:** Este é um fallback aceitável para desenvolvimento

---

### 6. ProfessionalLogger.php

#### Problema 6.1: Fallback hardcoded
**Linhas:** ~594-597
```php
$baseUrl = $_ENV['APP_BASE_URL'] ?? 
    (isProduction() 
        ? 'https://bssegurosimediato.com.br' 
        : 'https://dev.bssegurosimediato.com.br');
```
**Status:** ⚠️ **FALLBACK HARDCODED**  
**Impacto:** Baixo - Fallback apenas se variável não estiver definida  
**Observação:** Este é um fallback aceitável

---

### 7. add_flyingdonkeys.php e add_webflow_octa.php

#### Problema 7.1: Lista de CORS hardcoded
**Linhas:** ~38-49 (add_flyingdonkeys.php), ~23-34 (add_webflow_octa.php)
```php
$allowed_origins = array(
    'https://www.segurosimediato.com.br',
    'https://segurosimediato.com.br',
    'https://dev.bssegurosimediato.com.br',
    // ...
);
```
**Status:** ⚠️ **LISTA HARDCODED**  
**Impacto:** Médio - Lista de origens permitidas hardcoded  
**Observação:** Deveria usar `getCorsOrigins()` de `config.php`

---

## 📋 RESUMO POR PRIORIDADE

### 🔴 CRÍTICO (URLs Externas)
1. `FooterCodeSiteDefinitivoCompleto.js` linha 964 - Fallback para `mdmidia.com.br`
2. `FooterCodeSiteDefinitivoCompleto.js` linha 1024 - Fallback para `mdmidia.com.br`
3. `FooterCodeSiteDefinitivoCompleto.js` linha 1518 - Fallback para `mdmidia.com.br`
4. `webflow_injection_limpo.js` linha 2117 - Fallback para `mdmidia.com.br`
5. `webflow_injection_limpo.js` linhas 2795, 2810 - URLs hardcoded para `mdmidia.com.br`

### 🟡 MÉDIO (Fallbacks DEV/PROD)
6. `FooterCodeSiteDefinitivoCompleto.js` linha 342 - Fallback para DEV
7. `FooterCodeSiteDefinitivoCompleto.js` linha 1594 - Fallback para DEV
8. `MODAL_WHATSAPP_DEFINITIVO.js` linhas 158-160 - Fallback DEV/PROD
9. `MODAL_WHATSAPP_DEFINITIVO.js` linhas 721-722 - Fallback DEV/PROD
10. `add_flyingdonkeys.php` - Lista CORS hardcoded
11. `add_webflow_octa.php` - Lista CORS hardcoded

### 🟢 BAIXO (Fallbacks Aceitáveis)
12. `config.php` - Fallback em `getBaseUrl()` (aceitável)
13. `config_env.js.php` - Fallback em variável (aceitável)
14. `ProfessionalLogger.php` - Fallback em variável (aceitável)

---

## ✅ RECOMENDAÇÕES

### Correções Prioritárias:

1. **Substituir todos os fallbacks para `mdmidia.com.br`** por `detectServerBaseUrl()`
2. **Substituir fallbacks DEV/PROD hardcoded** por `detectServerBaseUrl()`
3. **Usar `getCorsOrigins()` de `config.php`** em vez de listas hardcoded
4. **Remover código legado** com URLs hardcoded em `webflow_injection_limpo.js`

---

**Documento criado em:** 10/11/2025

