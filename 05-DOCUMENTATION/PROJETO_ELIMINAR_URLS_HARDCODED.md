# 📋 PROJETO: ELIMINAÇÃO COMPLETA DE URLs E DIRETÓRIOS HARDCODED

**Data de Criação:** 10/11/2025  
**Status:** ✅ **CONCLUÍDO** - 10/11/2025  
**Prioridade:** 🔴 **CRÍTICA**  
**Versão:** 1.1.0

---

## 🎯 OBJETIVO

Eliminar **TODAS** as URLs e diretórios hardcoded do projeto, garantindo que **TODAS** as chamadas utilizem exclusivamente variáveis de ambiente. **NÃO HAVERÁ FALLBACKS HARDCODED**.

---

## 🚨 REGRAS CRÍTICAS

1. ❌ **NUNCA usar** URLs hardcoded (`https://dev.bssegurosimediato.com.br`, `https://mdmidia.com.br`, etc.)
2. ❌ **NUNCA usar** diretórios hardcoded (`/var/www/html/dev/logs/`, `/tmp/`, etc.)
3. ❌ **NUNCA usar** fallbacks hardcoded
4. ✅ **SEMPRE usar** `window.APP_BASE_URL` (JavaScript) ou `$_ENV['APP_BASE_URL']` (PHP) para URLs
5. ✅ **SEMPRE usar** `getBaseDir()` de `config.php` ou `$_ENV['APP_BASE_DIR']` para diretórios
6. ✅ **SEMPRE usar** `getCorsOrigins()` de `config.php` para CORS
7. ✅ **SEMPRE garantir** que variáveis de ambiente estejam disponíveis antes de fazer chamadas
8. ❌ **NUNCA criar** arquivos novos no raiz de `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`
9. ✅ **SEMPRE criar** novos arquivos nos diretórios apropriados:
   - Documentação: `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/`
   - Backups: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/` ou `WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/`
   - Testes: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/`
   - Configuração: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/`

---

## 📊 PROBLEMAS IDENTIFICADOS

### 🔴 CRÍTICOS (24 problemas)

#### JavaScript (11 problemas)

1. **FooterCodeSiteDefinitivoCompleto.js:342**
   - Problema: Fallback hardcoded em `sendLogToProfessionalSystem()`
   - Correção: Remover fallback, garantir que `APP_BASE_URL` esteja disponível

2. **FooterCodeSiteDefinitivoCompleto.js:964**
   - Problema: Fallback para `mdmidia.com.br` em `validateCPF()`
   - Correção: Remover fallback, usar apenas `window.APP_BASE_URL`

3. **FooterCodeSiteDefinitivoCompleto.js:1024**
   - Problema: Fallback para `mdmidia.com.br` em `validatePlaca()`
   - Correção: Remover fallback, usar apenas `window.APP_BASE_URL`

4. **FooterCodeSiteDefinitivoCompleto.js:1518**
   - Problema: Fallback para `mdmidia.com.br` em injeção de `webflow_injection_limpo.js`
   - Correção: Remover fallback, usar apenas `window.APP_BASE_URL`

5. **FooterCodeSiteDefinitivoCompleto.js:1594**
   - Problema: Fallback para DEV em injeção de `MODAL_WHATSAPP_DEFINITIVO.js`
   - Correção: Remover fallback, usar apenas `window.APP_BASE_URL`

6. **MODAL_WHATSAPP_DEFINITIVO.js:158-160**
   - Problema: Fallback DEV/PROD hardcoded em `getEndpointUrl()`
   - Correção: Remover fallback, garantir que `APP_BASE_URL` esteja disponível

7. **MODAL_WHATSAPP_DEFINITIVO.js:721-722**
   - Problema: Fallback DEV/PROD hardcoded em `sendAdminEmailNotification()`
   - Correção: Remover fallback, usar apenas `window.APP_BASE_URL`

8. **webflow_injection_limpo.js:2117**
   - Problema: Fallback para `mdmidia.com.br` em validação de placa
   - Correção: Remover fallback, usar apenas `window.APP_BASE_URL`

9. **webflow_injection_limpo.js:2795, 2810**
   - Problema: URLs hardcoded para `mdmidia.com.br` (código legado)
   - Correção: Remover código legado completamente

#### PHP (13 problemas)

10. **add_flyingdonkeys.php:38-49**
    - Problema: Lista CORS hardcoded
    - Correção: Usar `getCorsOrigins()` de `config.php`

11. **add_webflow_octa.php:23-34**
    - Problema: Lista CORS hardcoded
    - Correção: Usar `getCorsOrigins()` de `config.php`

12. **FooterCodeSiteDefinitivoCompleto.js:100-101** - `detectServerBaseUrl()`
    - Problema: Fallback hardcoded para `'https://dev.bssegurosimediato.com.br'`
    - Correção: Remover fallback, retornar `null` ou lançar erro

13. **FooterCodeSiteDefinitivoCompleto.js:117-122** - Carregamento `config_env.js.php`
    - Problema: Fallback que usa `detectServerBaseUrl()` (que tem fallback hardcoded)
    - Correção: Remover fallback, garantir que `config_env.js.php` seja carregado corretamente

14. **config.php:62-66** - `getBaseUrl()`
    - Problema: Fallback hardcoded DEV/PROD
    - Correção: Remover fallback, garantir que `APP_BASE_URL` esteja sempre definido

15. **config.php:162-163** - `getFlyingDonkeysApiUrl()`
    - Problema: Fallback hardcoded para FlyingDonkeys API
    - Correção: Remover fallback, usar apenas variável de ambiente

16. **config.php:209** - `getOctadeskApiBase()`
    - Problema: Fallback hardcoded para OctaDesk API
    - Correção: Remover fallback, usar apenas variável de ambiente

17. **config_env.js.php:18** - Fallback hardcoded
    - Problema: Fallback para `'https://dev.bssegurosimediato.com.br'`
    - Correção: Remover fallback, garantir que variável esteja sempre definida

18. **ProfessionalLogger.php:594-597** - Fallback hardcoded
    - Problema: Fallback DEV/PROD hardcoded
    - Correção: Remover fallback, usar apenas variável de ambiente

19. **add_flyingdonkeys.php:74** - Diretório de log hardcoded (DEV)
    - Problema: `/var/www/html/dev/logs/flyingdonkeys_dev.txt` hardcoded
    - Correção: Usar `getBaseDir()` + variável de ambiente para logs

20. **add_flyingdonkeys.php:80** - Diretório de log hardcoded (PROD)
    - Problema: `/var/www/html/logs/flyingdonkeys_prod.txt` hardcoded
    - Correção: Usar `getBaseDir()` + variável de ambiente para logs

21. **add_webflow_octa.php:70** - Diretório de log hardcoded
    - Problema: `/var/www/html/logs/webhook_octadesk_prod.txt` hardcoded
    - Correção: Usar `getBaseDir()` + variável de ambiente para logs

22. **ProfessionalLogger.php:316-318** - Caminhos de log hardcoded
    - Problema: Múltiplos caminhos hardcoded (`/var/www/html/dev/root/`, `/opt/webhooks-server/dev/root/`)
    - Correção: Usar `getBaseDir()` para todos os caminhos

23. **ProfessionalLogger.php:330** - Diretório fallback hardcoded
    - Problema: `/tmp/professional_logger_errors.txt` hardcoded como fallback
    - Correção: Remover fallback, usar apenas `getBaseDir()` + variável de ambiente

24. **config.php:48** - Fallback `__DIR__` em `getBaseDir()`
    - Problema: Fallback para `__DIR__` quando `APP_BASE_DIR` não está definido
    - Correção: Remover fallback, garantir que `APP_BASE_DIR` esteja sempre definido

---

## 📋 FASES DE IMPLEMENTAÇÃO

### Fase 1: Preparação e Backups ⏳
- [ ] Criar diretório de backup: `WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/2025-11-10_ELIMINACAO_URLS_HARDCODED/`
- [ ] Fazer backup de todos os arquivos que serão modificados
- [ ] Documentar estado atual de cada arquivo em `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/`

### Fase 2: Correções JavaScript ⏳
- [ ] FooterCodeSiteDefinitivoCompleto.js - Remover todos os fallbacks
- [ ] MODAL_WHATSAPP_DEFINITIVO.js - Remover todos os fallbacks
- [ ] webflow_injection_limpo.js - Remover fallbacks e código legado

### Fase 3: Correções PHP ⏳
- [ ] add_flyingdonkeys.php - Usar `getCorsOrigins()`
- [ ] add_webflow_octa.php - Usar `getCorsOrigins()`

### Fase 4: Validação ⏳
- [ ] Verificar que todas as chamadas usam variáveis de ambiente
- [ ] Testar que não há fallbacks hardcoded
- [ ] Verificar que `config_env.js.php` está sendo carregado corretamente

### Fase 5: Deploy ⏳
- [ ] Copiar arquivos corrigidos para servidor
- [ ] Verificar funcionamento no servidor

---

## 🔧 CORREÇÕES DETALHADAS

### FooterCodeSiteDefinitivoCompleto.js

#### Correção 1: Linha 342 - `sendLogToProfessionalSystem()`
**Antes:**
```javascript
const baseUrl = window.APP_BASE_URL || 'https://dev.bssegurosimediato.com.br';
```

**Depois:**
```javascript
if (!window.APP_BASE_URL) {
  console.error('[LOG] APP_BASE_URL não disponível. Aguardando carregamento...');
  throw new Error('APP_BASE_URL não disponível');
}
const baseUrl = window.APP_BASE_URL;
```

#### Correção 2: Linha 964 - `validateCPF()`
**Antes:**
```javascript
const cpfUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/cpf-validate.php' : 'https://mdmidia.com.br/cpf-validate.php';
```

**Depois:**
```javascript
if (!window.APP_BASE_URL) {
  return Promise.reject(new Error('APP_BASE_URL não disponível para validação de CPF'));
}
const cpfUrl = window.APP_BASE_URL + '/cpf-validate.php';
```

#### Correção 3: Linha 1024 - `validatePlaca()`
**Antes:**
```javascript
const placaUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/placa-validate.php' : 'https://mdmidia.com.br/placa-validate.php';
```

**Depois:**
```javascript
if (!window.APP_BASE_URL) {
  return Promise.reject(new Error('APP_BASE_URL não disponível para validação de placa'));
}
const placaUrl = window.APP_BASE_URL + '/placa-validate.php';
```

#### Correção 4: Linha 1518 - Injeção `webflow_injection_limpo.js`
**Antes:**
```javascript
script.src = window.APP_BASE_URL ? window.APP_BASE_URL + '/webflow_injection_limpo.js' : 'https://mdmidia.com.br/webflow_injection_limpo.js';
```

**Depois:**
```javascript
if (!window.APP_BASE_URL) {
  console.error('[FOOTER] APP_BASE_URL não disponível para carregar webflow_injection_limpo.js');
  return;
}
script.src = window.APP_BASE_URL + '/webflow_injection_limpo.js';
```

#### Correção 5: Linha 1594 - Injeção `MODAL_WHATSAPP_DEFINITIVO.js`
**Antes:**
```javascript
script.src = window.APP_BASE_URL ? window.APP_BASE_URL + '/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random() : 'https://dev.bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random();
```

**Depois:**
```javascript
if (!window.APP_BASE_URL) {
  console.error('[FOOTER] APP_BASE_URL não disponível para carregar MODAL_WHATSAPP_DEFINITIVO.js');
  return;
}
script.src = window.APP_BASE_URL + '/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random();
```

---

### MODAL_WHATSAPP_DEFINITIVO.js

#### Correção 6: Linhas 158-160 - `getEndpointUrl()` fallback
**Antes:**
```javascript
const isDev = isDevelopmentEnvironment();
const fallbackBase = isDev 
  ? 'https://dev.bssegurosimediato.com.br'
  : 'https://bssegurosimediato.com.br';
```

**Depois:**
```javascript
if (!window.APP_BASE_URL) {
  console.error('[ENDPOINT] APP_BASE_URL não disponível');
  throw new Error('APP_BASE_URL não disponível para construir endpoint');
}
// Não usar fallback - usar apenas window.APP_BASE_URL
```

#### Correção 7: Linhas 721-722 - `sendAdminEmailNotification()` fallback
**Antes:**
```javascript
emailEndpoint = window.APP_BASE_URL 
  ? window.APP_BASE_URL + '/send_email_notification_endpoint.php'
  : (isDevelopmentEnvironment() 
      ? 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php'
      : 'https://bssegurosimediato.com.br/send_email_notification_endpoint.php');
```

**Depois:**
```javascript
if (!window.APP_BASE_URL) {
  console.error('[EMAIL] APP_BASE_URL não disponível');
  throw new Error('APP_BASE_URL não disponível para envio de email');
}
emailEndpoint = window.APP_BASE_URL + '/send_email_notification_endpoint.php';
```

---

### webflow_injection_limpo.js

#### Correção 8: Linha 2117 - Validação de placa
**Antes:**
```javascript
const placaUrl = window.APP_BASE_URL ? window.APP_BASE_URL + '/placa-validate.php' : 'https://mdmidia.com.br/placa-validate.php';
```

**Depois:**
```javascript
if (!window.APP_BASE_URL) {
  console.error('[RPA] APP_BASE_URL não disponível para validação de placa');
  return Promise.reject(new Error('APP_BASE_URL não disponível'));
}
const placaUrl = window.APP_BASE_URL + '/placa-validate.php';
```

#### Correção 9: Linhas 2795, 2810 - Código legado
**Antes:**
```javascript
async sendToMdmidiaTra(formData) {
    const response = await fetch('https://mdmidia.com.br/add_tra...', {
async sendToMdmidiaWe(formData) {
    const response = await fetch('https://mdmidia.com.br/add_we...', {
```

**Depois:**
**REMOVER COMPLETAMENTE** - Código legado não utilizado

---

### add_flyingdonkeys.php

#### Correção 10: Linhas 38-49 - Lista CORS hardcoded
**Antes:**
```php
$allowed_origins = array(
    'https://www.segurosimediato.com.br',
    'https://segurosimediato.com.br',
    'https://dev.bssegurosimediato.com.br',
    // ... lista hardcoded
);
```

**Depois:**
```php
require_once __DIR__ . '/config.php';
$allowed_origins = getCorsOrigins();
```

---

### add_webflow_octa.php

#### Correção 11: Linhas 23-34 - Lista CORS hardcoded
**Antes:**
```php
$allowed_origins = array(
    'https://www.segurosimediato.com.br',
    'https://segurosimediato.com.br',
    'https://dev.bssegurosimediato.com.br',
    // ... lista hardcoded
);
```

**Depois:**
```php
require_once __DIR__ . '/config.php';
$allowed_origins = getCorsOrigins();
```

---

### FooterCodeSiteDefinitivoCompleto.js (Continuação)

#### Correção 12: Linhas 100-101 - `detectServerBaseUrl()` fallback
**Antes:**
```javascript
function detectServerBaseUrl() {
  // ... código de detecção ...
  // Fallback para dev
  return 'https://dev.bssegurosimediato.com.br';
}
```

**Depois:**
```javascript
function detectServerBaseUrl() {
  const scripts = document.getElementsByTagName('script');
  for (let script of scripts) {
    if (script.src && script.src.includes('bssegurosimediato.com.br')) {
      try {
        return new URL(script.src).origin;
      } catch (e) {
        // Ignorar erro de parsing
      }
    }
  }
  // NÃO usar fallback - retornar null e deixar que o erro seja tratado
  console.error('[CONFIG] Não foi possível detectar URL base do servidor');
  return null;
}
```

#### Correção 13: Linhas 117-122 - Carregamento `config_env.js.php` fallback
**Antes:**
```javascript
script.onerror = () => {
  console.warn('[CONFIG] Erro ao carregar config_env.js.php, usando fallback');
  // Fallback: definir variáveis manualmente se falhar
  if (!window.APP_BASE_URL) {
    window.APP_BASE_URL = serverBaseUrl;
    window.APP_ENVIRONMENT = 'development';
  }
  window.dispatchEvent(new CustomEvent('appEnvLoaded'));
};
```

**Depois:**
```javascript
script.onerror = () => {
  console.error('[CONFIG] Erro crítico: Não foi possível carregar config_env.js.php');
  // NÃO usar fallback - lançar erro
  window.dispatchEvent(new CustomEvent('appEnvError', { 
    detail: { message: 'config_env.js.php não pôde ser carregado' } 
  }));
  throw new Error('config_env.js.php não pôde ser carregado - variáveis de ambiente não disponíveis');
};
```

---

### config.php

#### Correção 14: Linhas 62-66 - `getBaseUrl()` fallback
**Antes:**
```php
function getBaseUrl() {
    $baseUrl = $_ENV['APP_BASE_URL'] ?? '';
    if (empty($baseUrl)) {
        // Fallback baseado no ambiente (apenas se não estiver definido)
        if (isDevelopment()) {
            $baseUrl = 'https://dev.bssegurosimediato.com.br';
        } else {
            $baseUrl = 'https://bssegurosimediato.com.br';
        }
    }
    return rtrim($baseUrl, '/');
}
```

**Depois:**
```php
function getBaseUrl() {
    $baseUrl = $_ENV['APP_BASE_URL'] ?? '';
    if (empty($baseUrl)) {
        error_log('[CONFIG] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('APP_BASE_URL não está definido nas variáveis de ambiente');
    }
    return rtrim($baseUrl, '/');
}
```

#### Correção 15: Linhas 162-163 - `getEspoCrmUrl()` fallback
**Antes:**
```php
function getEspoCrmUrl() {
    return $_ENV['ESPOCRM_URL'] ?? (isDevelopment() 
        ? 'https://dev.flyingdonkeys.com.br' 
        : 'https://flyingdonkeys.com.br');
}
```

**Depois:**
```php
function getEspoCrmUrl() {
    $url = $_ENV['ESPOCRM_URL'] ?? '';
    if (empty($url)) {
        error_log('[CONFIG] ERRO CRÍTICO: ESPOCRM_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('ESPOCRM_URL não está definido nas variáveis de ambiente');
    }
    return $url;
}
```

#### Correção 16: Linha 209 - `getOctaDeskApiBase()` fallback
**Antes:**
```php
function getOctaDeskApiBase() {
    return $_ENV['OCTADESK_API_BASE'] ?? 'https://o205242-d60.api004.octadesk.services';
}
```

**Depois:**
```php
function getOctaDeskApiBase() {
    $base = $_ENV['OCTADESK_API_BASE'] ?? '';
    if (empty($base)) {
        error_log('[CONFIG] ERRO CRÍTICO: OCTADESK_API_BASE não está definido nas variáveis de ambiente');
        throw new RuntimeException('OCTADESK_API_BASE não está definido nas variáveis de ambiente');
    }
    return $base;
}
```

---

### config_env.js.php

#### Correção 17: Linha 18 - Fallback hardcoded
**Antes:**
```php
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
```

**Depois:**
```php
$base_url = $_ENV['APP_BASE_URL'] ?? '';
if (empty($base_url)) {
    http_response_code(500);
    header('Content-Type: application/javascript');
    echo "console.error('[CONFIG] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');";
    echo "throw new Error('APP_BASE_URL não está definido');";
    exit;
}
```

---

### ProfessionalLogger.php

#### Correção 18: Linhas 594-597 - Fallback hardcoded
**Antes:**
```php
$baseUrl = $_ENV['APP_BASE_URL'] ?? 
           ($this->environment === 'production' 
               ? 'https://bssegurosimediato.com.br' 
               : 'https://dev.bssegurosimediato.com.br');
```

**Depois:**
```php
$baseUrl = $_ENV['APP_BASE_URL'] ?? '';
if (empty($baseUrl)) {
    error_log('[ProfessionalLogger] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');
    throw new RuntimeException('APP_BASE_URL não está definido nas variáveis de ambiente');
}
```

---

### add_flyingdonkeys.php (Continuação)

#### Correção 19: Linha 74 - Diretório de log hardcoded (DEV)
**Antes:**
```php
$DEBUG_LOG_FILE = $DEV_LOGGING['flyingdonkeys'] ?? '/var/www/html/dev/logs/flyingdonkeys_dev.txt';
```

**Depois:**
```php
require_once __DIR__ . '/config.php';
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
if (empty($DEV_LOGGING['flyingdonkeys'])) {
    $DEBUG_LOG_FILE = rtrim($logDir, '/\\') . '/flyingdonkeys_dev.txt';
} else {
    $DEBUG_LOG_FILE = $DEV_LOGGING['flyingdonkeys'];
}
```

#### Correção 20: Linha 80 - Diretório de log hardcoded (PROD)
**Antes:**
```php
$DEBUG_LOG_FILE = '/var/www/html/logs/flyingdonkeys_prod.txt';
```

**Depois:**
```php
require_once __DIR__ . '/config.php';
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
$DEBUG_LOG_FILE = rtrim($logDir, '/\\') . '/flyingdonkeys_prod.txt';
```

---

### add_webflow_octa.php (Continuação)

#### Correção 21: Linha 70 - Diretório de log hardcoded
**Antes:**
```php
$logFile = '/var/www/html/logs/webhook_octadesk_prod.txt';
```

**Depois:**
```php
require_once __DIR__ . '/config.php';
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
$logFile = rtrim($logDir, '/\\') . '/webhook_octadesk_prod.txt';
```

---

### ProfessionalLogger.php (Continuação)

#### Correção 22: Linhas 316-318 - Caminhos de log hardcoded
**Antes:**
```php
$possiblePaths = [
    __DIR__ . '/professional_logger_errors.txt',
    '/var/www/html/dev/root/professional_logger_errors.txt',
    '/opt/webhooks-server/dev/root/professional_logger_errors.txt',
];
```

**Depois:**
```php
require_once __DIR__ . '/config.php';
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
$logFile = rtrim($logDir, '/\\') . '/professional_logger_errors.txt';
```

#### Correção 23: Linha 330 - Diretório fallback hardcoded
**Antes:**
```php
$fallbackLogFile = '/tmp/professional_logger_errors.txt';
// ... código que usa fallback ...
```

**Depois:**
```php
// REMOVER completamente o fallback para /tmp
// Se não conseguir gravar no arquivo principal, lançar erro
if (!@file_put_contents($logFile, $logLine, FILE_APPEND | LOCK_EX)) {
    error_log("ProfessionalLogger: ERRO CRÍTICO - Não foi possível gravar log em: $logFile");
    throw new RuntimeException("Não foi possível gravar log em: $logFile");
}
```

---

### config.php (Continuação)

#### Correção 24: Linha 48 - Fallback `__DIR__` em `getBaseDir()`
**Antes:**
```php
function getBaseDir() {
    $baseDir = $_ENV['APP_BASE_DIR'] ?? __DIR__;
    return rtrim($baseDir, '/\\');
}
```

**Depois:**
```php
function getBaseDir() {
    $baseDir = $_ENV['APP_BASE_DIR'] ?? '';
    if (empty($baseDir)) {
        error_log('[CONFIG] ERRO CRÍTICO: APP_BASE_DIR não está definido nas variáveis de ambiente');
        throw new RuntimeException('APP_BASE_DIR não está definido nas variáveis de ambiente');
    }
    return rtrim($baseDir, '/\\');
}
```

---

## ✅ VALIDAÇÃO PÓS-CORREÇÃO

### Checklist de Validação

- [ ] Nenhuma URL hardcoded encontrada via grep
- [ ] Nenhum diretório hardcoded encontrado via grep
- [ ] Todas as chamadas usam `window.APP_BASE_URL` (JS) ou `$_ENV['APP_BASE_URL']` (PHP)
- [ ] Todos os diretórios usam `getBaseDir()` ou `$_ENV['APP_BASE_DIR']`
- [ ] Todas as listas CORS usam `getCorsOrigins()`
- [ ] Todos os caminhos de log usam variáveis de ambiente
- [ ] Código legado removido
- [ ] Testes funcionando no servidor

---

## 📝 NOTAS IMPORTANTES

1. **Sem Fallbacks:** Todas as funções devem falhar explicitamente se variáveis de ambiente não estiverem disponíveis
2. **URLs:** Sempre usar `APP_BASE_URL` (JavaScript: `window.APP_BASE_URL`, PHP: `$_ENV['APP_BASE_URL']`)
3. **Diretórios:** Sempre usar `APP_BASE_DIR` via `getBaseDir()` ou `$_ENV['APP_BASE_DIR']`
4. **Logs:** Usar variável de ambiente `LOG_DIR` ou `getBaseDir() . '/logs'`
5. **Carregamento de `config_env.js.php`:** Deve ser garantido que este arquivo seja carregado ANTES de qualquer chamada
6. **Tratamento de Erros:** Implementar tratamento adequado quando variáveis não estiverem disponíveis

---

**Documento criado em:** 10/11/2025  
**Aguardando autorização para iniciar implementação**

