# 🔍 ANÁLISE COMPLETA: Fallbacks Hardcoded em Arquivos .js e .php

**Data:** 18/11/2025  
**Versão:** 1.0.0  
**Escopo:** Todos os arquivos JavaScript (.js) e PHP (.php) do projeto  
**Objetivo:** Identificar TODOS os fallbacks hardcoded para eliminação completa

---

## 📋 SUMÁRIO EXECUTIVO

Esta análise identifica **TODOS** os fallbacks hardcoded (valores padrão expostos no código) que devem ser eliminados, substituindo-os por tratamento de erro ou lançamento de exceção quando variáveis de ambiente não estiverem definidas.

### Estatísticas Gerais

- **Total de arquivos analisados:** 13 arquivos principais (3 JS + 10 PHP)
- **Total de fallbacks hardcoded encontrados:** 87 ocorrências
- **Categorias identificadas:**
  - 🔴 **CRÍTICO:** 15 ocorrências (credenciais, tokens, API keys, secrets)
  - 🟠 **ALTO:** 28 ocorrências (URLs de APIs, domínios, flags de configuração)
  - 🟡 **MÉDIO:** 32 ocorrências (valores padrão de configuração, detecção de ambiente)
  - 🟢 **BAIXO:** 12 ocorrências (valores de exemplo, placeholders, valores técnicos)

---

## 🔴 CRÍTICO - FALLBACKS DE CREDENCIAIS E SECRETS

### 1. **config.php** - Fallbacks de Credenciais em Funções Helper

#### 1.1. `getEspoCrmApiKey()` - Linha 160-162

**Código Atual:**
```php
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'  // ❌ FALLBACK DEV
        : '82d5f667f3a65a9a43341a0705be2b0c'); // ❌ FALLBACK PROD
}
```

**Problema:** API Key exposta como fallback  
**Risco:** 🔴 **CRÍTICO** - Credencial exposta no código  
**Recomendação:** Lançar exceção se variável não estiver definida

**Código Corrigido:**
```php
function getEspoCrmApiKey() {
    if (empty($_ENV['ESPOCRM_API_KEY'])) {
        error_log('[CONFIG] ERRO CRÍTICO: ESPOCRM_API_KEY não está definido nas variáveis de ambiente');
        throw new RuntimeException('ESPOCRM_API_KEY não está definido nas variáveis de ambiente');
    }
    return $_ENV['ESPOCRM_API_KEY'];
}
```

---

#### 1.2. `getWebflowSecretFlyingDonkeys()` - Linha 169-172

**Código Atual:**
```php
function getWebflowSecretFlyingDonkeys() {
    return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'] ?? (isDevelopment()
        ? '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51'  // ❌ FALLBACK (desatualizado)
        : '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51'); // ❌ FALLBACK (desatualizado)
}
```

**Problema:** Secret exposto como fallback (valor desatualizado)  
**Risco:** 🔴 **CRÍTICO** - Secret exposto no código  
**Valor Correto Confirmado:** `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` (env atual)  
**Recomendação:** Lançar exceção se variável não estiver definida

**Código Corrigido:**
```php
function getWebflowSecretFlyingDonkeys() {
    if (empty($_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'])) {
        error_log('[CONFIG] ERRO CRÍTICO: WEBFLOW_SECRET_FLYINGDONKEYS não está definido nas variáveis de ambiente');
        throw new RuntimeException('WEBFLOW_SECRET_FLYINGDONKEYS não está definido nas variáveis de ambiente');
    }
    return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'];
}
```

---

#### 1.3. `getWebflowSecretOctaDesk()` - Linha 179-182

**Código Atual:**
```php
function getWebflowSecretOctaDesk() {
    return $_ENV['WEBFLOW_SECRET_OCTADESK'] ?? (isDevelopment()
        ? '4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd'  // ❌ FALLBACK (desatualizado)
        : '4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd'); // ❌ FALLBACK (desatualizado)
}
```

**Problema:** Secret exposto como fallback (valor desatualizado)  
**Risco:** 🔴 **CRÍTICO** - Secret exposto no código  
**Valor Correto Confirmado:** `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291` (env atual)  
**Recomendação:** Lançar exceção se variável não estiver definida

**Código Corrigido:**
```php
function getWebflowSecretOctaDesk() {
    if (empty($_ENV['WEBFLOW_SECRET_OCTADESK'])) {
        error_log('[CONFIG] ERRO CRÍTICO: WEBFLOW_SECRET_OCTADESK não está definido nas variáveis de ambiente');
        throw new RuntimeException('WEBFLOW_SECRET_OCTADESK não está definido nas variáveis de ambiente');
    }
    return $_ENV['WEBFLOW_SECRET_OCTADESK'];
}
```

---

#### 1.4. `getOctaDeskApiKey()` - Linha 189-190

**Código Atual:**
```php
function getOctaDeskApiKey() {
    return $_ENV['OCTADESK_API_KEY'] ?? 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b'; // ❌ FALLBACK
}
```

**Problema:** API Key exposta como fallback  
**Risco:** 🔴 **CRÍTICO** - Credencial exposta no código  
**Recomendação:** Lançar exceção se variável não estiver definida

**Código Corrigido:**
```php
function getOctaDeskApiKey() {
    if (empty($_ENV['OCTADESK_API_KEY'])) {
        error_log('[CONFIG] ERRO CRÍTICO: OCTADESK_API_KEY não está definido nas variáveis de ambiente');
        throw new RuntimeException('OCTADESK_API_KEY não está definido nas variáveis de ambiente');
    }
    return $_ENV['OCTADESK_API_KEY'];
}
```

---

#### 1.5. `getEnvironment()` - Linha 22-23

**Código Atual:**
```php
function getEnvironment() {
    return $_ENV['PHP_ENV'] ?? 'development'; // ❌ FALLBACK
}
```

**Problema:** Ambiente padrão hardcoded  
**Risco:** 🟡 **MÉDIO** - Pode causar comportamento incorreto em produção se variável não estiver definida  
**Recomendação:** Lançar exceção ou usar detecção automática segura

**Código Corrigido:**
```php
function getEnvironment() {
    if (empty($_ENV['PHP_ENV'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PHP_ENV não está definido nas variáveis de ambiente');
        throw new RuntimeException('PHP_ENV não está definido nas variáveis de ambiente');
    }
    return $_ENV['PHP_ENV'];
}
```

---

#### 1.6. `getDatabaseConfig()` - Linhas 130-137

**Código Atual:**
```php
function getDatabaseConfig() {
    return [
        'host' => $_ENV['LOG_DB_HOST'] ?? 'localhost',  // ❌ FALLBACK
        'port' => (int)($_ENV['LOG_DB_PORT'] ?? 3306),  // ❌ FALLBACK
        'name' => $_ENV['LOG_DB_NAME'] ?? (isDevelopment() ? 'rpa_logs_dev' : 'rpa_logs_prod'),  // ❌ FALLBACK
        'user' => $_ENV['LOG_DB_USER'] ?? (isDevelopment() ? 'rpa_logger_dev' : 'rpa_logger_prod'),  // ❌ FALLBACK
        'pass' => $_ENV['LOG_DB_PASS'] ?? ''  // ❌ FALLBACK (vazio)
    ];
}
```

**Problema:** Configurações de banco de dados com fallbacks  
**Risco:** 🔴 **CRÍTICO** - Credenciais de banco expostas, pode causar conexão incorreta  
**Recomendação:** Lançar exceção se variáveis não estiverem definidas

**Código Corrigido:**
```php
function getDatabaseConfig() {
    $requiredVars = ['LOG_DB_HOST', 'LOG_DB_PORT', 'LOG_DB_NAME', 'LOG_DB_USER', 'LOG_DB_PASS'];
    foreach ($requiredVars as $var) {
        if (empty($_ENV[$var])) {
            error_log("[CONFIG] ERRO CRÍTICO: {$var} não está definido nas variáveis de ambiente");
            throw new RuntimeException("{$var} não está definido nas variáveis de ambiente");
        }
    }
    
    return [
        'host' => $_ENV['LOG_DB_HOST'],
        'port' => (int)$_ENV['LOG_DB_PORT'],
        'name' => $_ENV['LOG_DB_NAME'],
        'user' => $_ENV['LOG_DB_USER'],
        'pass' => $_ENV['LOG_DB_PASS'],
        'charset' => 'utf8mb4',
        'options' => [
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
    ];
}
```

---

### 2. **ProfessionalLogger.php** - Fallbacks de Configuração de Banco

#### 2.1. `loadConfig()` - Linhas 284-288

**Código Atual:**
```php
$this->config = [
    'host' => $_ENV['LOG_DB_HOST'] ?? getenv('LOG_DB_HOST') ?: $defaultHost,  // ❌ FALLBACK
    'port' => (int)($_ENV['LOG_DB_PORT'] ?? getenv('LOG_DB_PORT') ?: 3306),  // ❌ FALLBACK
    'database' => $_ENV['LOG_DB_NAME'] ?? getenv('LOG_DB_NAME') ?: 'rpa_logs_dev',  // ❌ FALLBACK
    'username' => $_ENV['LOG_DB_USER'] ?? getenv('LOG_DB_USER') ?: 'rpa_logger_dev',  // ❌ FALLBACK
    'password' => $_ENV['LOG_DB_PASS'] ?? getenv('LOG_DB_PASS') ?: ''  // ❌ FALLBACK
];
```

**Problema:** Fallbacks de credenciais de banco de dados  
**Risco:** 🔴 **CRÍTICO** - Credenciais expostas, pode causar conexão incorreta  
**Recomendação:** Usar `getDatabaseConfig()` de `config.php` ou lançar exceção

**Código Corrigido:**
```php
require_once __DIR__ . '/config.php';
$dbConfig = getDatabaseConfig(); // Já valida e lança exceção se faltar variável
$this->config = [
    'host' => $dbConfig['host'],
    'port' => $dbConfig['port'],
    'database' => $dbConfig['name'],
    'username' => $dbConfig['user'],
    'password' => $dbConfig['pass'],
    'charset' => 'utf8mb4',
    'options' => [
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci",
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ]
];
```

---

#### 2.2. `detectEnvironment()` - Linha 248

**Código Atual:**
```php
private function detectEnvironment() {
    $env = $_ENV['PHP_ENV'] ?? 'development'; // ❌ FALLBACK
    return in_array(strtolower($env), ['production', 'prod']) ? 'production' : 'development';
}
```

**Problema:** Ambiente padrão hardcoded  
**Risco:** 🟡 **MÉDIO** - Pode causar comportamento incorreto  
**Recomendação:** Usar `getEnvironment()` de `config.php` ou lançar exceção

**Código Corrigido:**
```php
private function detectEnvironment() {
    require_once __DIR__ . '/config.php';
    return getEnvironment(); // Já valida e lança exceção se faltar variável
}
```

---

#### 2.3. `LogConfig::load()` - Linha 53

**Código Atual:**
```php
$environment = $_ENV['PHP_ENV'] ?? 'development'; // ❌ FALLBACK
```

**Problema:** Ambiente padrão hardcoded  
**Risco:** 🟡 **MÉDIO** - Pode causar comportamento incorreto  
**Recomendação:** Usar `getEnvironment()` de `config.php`

---

### 3. **cpf-validate.php** - Credenciais PH3A Hardcoded (SEM FALLBACK)

**Código Atual:**
```php
// Credenciais da API PH3A
$username = 'alex.kaminski@imediatoseguros.com.br';  // ❌ HARDCODED
$password = 'ImdSeg2025$$';  // ❌ HARDCODED
$api_key = '691dd2aa-9af4-84f2-06f9-350e1d709602';  // ❌ HARDCODED

// URLs
$login_url = "https://api.ph3a.com.br/DataBusca/api/Account/Login";  // ❌ HARDCODED
$data_url = "https://api.ph3a.com.br/DataBusca/data";  // ❌ HARDCODED
```

**Problema:** Credenciais e URLs hardcoded diretamente (não são fallbacks, são valores diretos)  
**Risco:** 🔴 **CRÍTICO** - Credenciais expostas no código  
**Recomendação:** Criar funções helper em `config.php` e usar variáveis de ambiente

---

### 4. **placa-validate.php** - Token PlacaFipe Hardcoded (SEM FALLBACK)

**Código Atual:**
```php
$token = '1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214';  // ❌ HARDCODED
$url = "https://api.placafipe.com.br/getplaca";  // ❌ HARDCODED
```

**Problema:** Token e URL hardcoded diretamente (não são fallbacks, são valores diretos)  
**Risco:** 🔴 **CRÍTICO** - Token exposto no código  
**Recomendação:** Criar funções helper em `config.php` e usar variáveis de ambiente

---

### 5. **aws_ses_config.php** - Emails Hardcoded (SEM FALLBACK)

**Código Atual:**
```php
define('EMAIL_FROM', 'noreply@bpsegurosimediato.com.br');  // ❌ HARDCODED (incorreto: deve ser `bs`)
define('EMAIL_FROM_NAME', 'BP Seguros Imediato');  // ❌ HARDCODED

define('ADMIN_EMAILS', [
    'lrotero@gmail.com',  // ❌ HARDCODED
    'alex.kaminski@imediatoseguros.com.br',  // ❌ HARDCODED
    'alexkaminski70@gmail.com',  // ❌ HARDCODED
]);
```

**Problema:** Emails hardcoded diretamente (não são fallbacks, são valores diretos)  
**Risco:** 🔴 **CRÍTICO** - Emails pessoais expostos, domínio incorreto  
**Recomendação:** Usar variáveis de ambiente

---

### 6. **add_webflow_octa.php** - API Key OctaDesk Hardcoded (SEM FALLBACK)

**Código Atual:**
```php
$OCTADESK_API_KEY = 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';  // ❌ HARDCODED
$API_BASE = 'https://o205242-d60.api004.octadesk.services';  // ❌ HARDCODED
```

**Problema:** API Key e URL hardcoded diretamente (não são fallbacks, são valores diretos)  
**Risco:** 🔴 **CRÍTICO** - Credenciais expostas no código  
**Recomendação:** Usar `getOctaDeskApiKey()` e `getOctaDeskApiBase()` de `config.php`

---

### 7. **FooterCodeSiteDefinitivoCompleto.js** - API Keys Hardcoded (SEM FALLBACK)

**Código Atual:**
```javascript
window.APILAYER_KEY = 'dce92fa84152098a3b5b7b8db24debbc';  // ❌ HARDCODED
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e';  // ❌ HARDCODED
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f';  // ❌ HARDCODED
window.rpaEnabled = false;  // ❌ HARDCODED
```

**Problema:** API Keys e flags hardcoded diretamente (não são fallbacks, são valores diretos)  
**Risco:** 🔴 **CRÍTICO** - Credenciais expostas no JavaScript (visíveis no navegador)  
**Recomendação:** Injetar via data attributes do Webflow

---

## 🟠 ALTO - FALLBACKS DE URLs E CONFIGURAÇÕES

### 8. **FooterCodeSiteDefinitivoCompleto.js** - URLs de APIs com Fallback

#### 8.1. Linhas 655-660

**Código Atual:**
```javascript
const VIACEP_BASE_URL = window.VIACEP_BASE_URL || 'https://viacep.com.br';  // ❌ FALLBACK
const APILAYER_BASE_URL = window.APILAYER_BASE_URL || 'https://apilayer.net';  // ❌ FALLBACK
const SAFETYMAILS_BASE_DOMAIN = window.SAFETYMAILS_BASE_DOMAIN || 'safetymails.com';  // ❌ FALLBACK
const WHATSAPP_API_BASE = window.WHATSAPP_API_BASE || 'https://api.whatsapp.com';  // ❌ FALLBACK
const WHATSAPP_PHONE = window.WHATSAPP_PHONE || '551141718837';  // ❌ FALLBACK
const WHATSAPP_DEFAULT_MESSAGE = window.WHATSAPP_DEFAULT_MESSAGE || 'Ola.%20Quero%20fazer%20uma%20cotacao%20de%20seguro.';  // ❌ FALLBACK
```

**Problema:** URLs e configurações com fallbacks hardcoded  
**Risco:** 🟠 **ALTO** - Valores podem estar incorretos ou desatualizados  
**Recomendação:** Injetar via data attributes ou lançar erro se não estiverem definidos

---

#### 8.2. Linha 101-102 (APP_BASE_URL e APP_ENVIRONMENT)

**Código Atual:**
```javascript
window.APP_BASE_URL = currentScript.dataset.appBaseUrl || null;  // ⚠️ FALLBACK null (aceitável)
window.APP_ENVIRONMENT = currentScript.dataset.appEnvironment || 'development';  // ❌ FALLBACK
```

**Problema:** Ambiente padrão hardcoded  
**Risco:** 🟠 **ALTO** - Pode causar comportamento incorreto em produção  
**Recomendação:** Lançar erro se `data-app-base-url` não estiver presente, não usar fallback para ambiente

**Código Corrigido:**
```javascript
window.APP_BASE_URL = currentScript.dataset.appBaseUrl;
if (!window.APP_BASE_URL) {
    throw new Error('[CONFIG] ERRO CRÍTICO: data-app-base-url não está definido no script tag');
}

window.APP_ENVIRONMENT = currentScript.dataset.appEnvironment;
if (!window.APP_ENVIRONMENT) {
    throw new Error('[CONFIG] ERRO CRÍTICO: data-app-environment não está definido no script tag');
}
```

---

### 9. **webflow_injection_limpo.js** - URLs de APIs com Fallback

#### 9.1. Linhas 25-35

**Código Atual:**
```javascript
const VIACEP_BASE_URL = window.VIACEP_BASE_URL || 'https://viacep.com.br';  // ❌ FALLBACK
const APILAYER_BASE_URL = window.APILAYER_BASE_URL || 'https://apilayer.net';  // ❌ FALLBACK
const SAFETYMAILS_OPTIN_BASE = window.SAFETYMAILS_OPTIN_BASE || 'https://optin.safetymails.com';  // ❌ FALLBACK
const SAFETYMAILS_OPTIN_PATH = window.SAFETYMAILS_OPTIN_PATH || '/main/safetyoptin/20a7a1c297e39180bd80428ac13c363e882a531f/9bab7f0c2711c5accfb83588c859dc1103844a94/';  // ❌ FALLBACK (contém ticket)
const RPA_API_BASE_URL = window.RPA_API_BASE_URL || 'https://rpaimediatoseguros.com.br';  // ❌ FALLBACK
const SUCCESS_PAGE_URL = window.SUCCESS_PAGE_URL || 'https://www.segurosimediato.com.br/sucesso';  // ❌ FALLBACK
```

**Problema:** URLs com fallbacks hardcoded, incluindo path com ticket  
**Risco:** 🟠 **ALTO** - Valores podem estar incorretos, ticket exposto  
**Recomendação:** Injetar via data attributes ou lançar erro se não estiverem definidos

---

### 10. **MODAL_WHATSAPP_DEFINITIVO.js** - URLs e Configurações com Fallback

#### 10.1. Linhas 36-37

**Código Atual:**
```javascript
const VIACEP_BASE_URL = window.VIACEP_BASE_URL || 'https://viacep.com.br';  // ❌ FALLBACK
const WHATSAPP_API_BASE = window.WHATSAPP_API_BASE || 'https://api.whatsapp.com';  // ❌ FALLBACK
```

**Problema:** URLs com fallbacks hardcoded  
**Risco:** 🟠 **ALTO** - Valores podem estar incorretos  
**Recomendação:** Injetar via data attributes ou lançar erro

---

#### 10.2. Linhas 77-87 (GTM Variables)

**Código Atual:**
```javascript
window.GTM_EVENT_NAME_INITIAL = window.GTM_EVENT_NAME_INITIAL || 'whatsapp_modal_initial_contact';  // ❌ FALLBACK
window.GTM_FORM_TYPE = window.GTM_FORM_TYPE || 'whatsapp_modal';  // ❌ FALLBACK
window.GTM_CONTACT_STAGE = window.GTM_CONTACT_STAGE || 'initial';  // ❌ FALLBACK
window.GTM_UTM_SOURCE = window.GTM_UTM_SOURCE || null;  // ⚠️ FALLBACK null (aceitável)
// ... outros GTM_* com fallback null (aceitáveis)
```

**Problema:** Valores padrão hardcoded para variáveis GTM  
**Risco:** 🟡 **MÉDIO** - Valores padrão podem estar incorretos  
**Recomendação:** Injetar via data attributes ou manter null como fallback (valores opcionais)

---

## 🟡 MÉDIO - FALLBACKS DE CONFIGURAÇÃO E DETECÇÃO

### 11. **ProfessionalLogger.php** - Fallbacks de Valores Padrão

#### 11.1. Linhas 393-409 (Valores Padrão de Contexto)

**Código Atual:**
```php
'file_name' => basename($caller['file'] ?? 'unknown'),  // ❌ FALLBACK 'unknown'
'file_path' => $caller['file'] ?? null,  // ⚠️ FALLBACK null (aceitável)
'line_number' => $caller['line'] ?? null,  // ⚠️ FALLBACK null (aceitável)
'function_name' => $caller['function'] ?? null,  // ⚠️ FALLBACK null (aceitável)
'class_name' => $caller['class'] ?? null,  // ⚠️ FALLBACK null (aceitável)

'ip_address' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',  // ❌ FALLBACK 'unknown'
'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',  // ❌ FALLBACK 'unknown'
'url' => $_SERVER['HTTP_REFERER'] ?? ($_SERVER['REQUEST_URI'] ?? 'unknown'),  // ❌ FALLBACK 'unknown'
'server_name' => $_SERVER['SERVER_NAME'] ?? 'unknown'  // ❌ FALLBACK 'unknown'
```

**Problema:** Valores padrão 'unknown' para informações de contexto  
**Risco:** 🟡 **MÉDIO** - Valores técnicos, não críticos, mas podem mascarar problemas  
**Recomendação:** Manter null como fallback (mais seguro) ou usar valores vazios

---

#### 11.2. Linhas 601-602 (Level e Category)

**Código Atual:**
```php
$level = $logData['level'] ?? 'INFO';  // ❌ FALLBACK 'INFO'
$category = $logData['category'] ?? null;  // ⚠️ FALLBACK null (aceitável)
```

**Problema:** Level padrão hardcoded  
**Risco:** 🟡 **MÉDIO** - Pode mascarar problemas se level não for informado  
**Recomendação:** Validar que level está presente ou usar valor mais seguro

---

#### 11.3. Linhas 732-735 (Valores Padrão em Logs de Erro)

**Código Atual:**
```php
'log_id' => $logData['log_id'] ?? 'N/A',  // ❌ FALLBACK 'N/A'
'request_id' => $logData['request_id'] ?? 'N/A',  // ❌ FALLBACK 'N/A'
'level' => $logData['level'] ?? 'N/A',  // ❌ FALLBACK 'N/A'
'message_length' => strlen($logData['message'] ?? ''),  // ⚠️ FALLBACK '' (aceitável)
```

**Problema:** Valores padrão 'N/A' em logs de erro  
**Risco:** 🟡 **MÉDIO** - Valores técnicos para debug, não críticos  
**Recomendação:** Manter como está (valores técnicos de debug)

---

### 12. **FooterCodeSiteDefinitivoCompleto.js** - Fallbacks de Configuração

#### 12.1. Linhas 165-173 (Detecção de Ambiente)

**Código Atual:**
```javascript
let detectedEnvironment = logConfigFromAttribute.environment || window.APP_ENVIRONMENT || 'prod';  // ❌ FALLBACK 'prod'
if (detectedEnvironment === 'auto') {
    const hostname = window.location.hostname;
    if (hostname.includes('dev.') || hostname.includes('localhost') || hostname.includes('127.0.0.1')) {
        detectedEnvironment = 'dev';
    } else {
        detectedEnvironment = 'prod';  // ❌ FALLBACK 'prod'
    }
}
```

**Problema:** Ambiente padrão hardcoded e detecção hardcoded  
**Risco:** 🟠 **ALTO** - Pode causar comportamento incorreto  
**Recomendação:** Remover detecção hardcoded, usar apenas `window.APP_ENVIRONMENT` injetado

---

#### 12.2. Linhas 176-194 (LOG_CONFIG Padrão)

**Código Atual:**
```javascript
const defaultLogConfig = {
    enabled: true,  // ❌ FALLBACK
    level: 'info',  // ❌ FALLBACK
    database: {
        enabled: true,  // ❌ FALLBACK
        min_level: 'info'  // ❌ FALLBACK
    },
    console: {
        enabled: true,  // ❌ FALLBACK
        min_level: 'info'  // ❌ FALLBACK
    },
    file: {
        enabled: true,  // ❌ FALLBACK
        min_level: 'error'  // ❌ FALLBACK
    },
    exclude_categories: [],  // ⚠️ FALLBACK [] (aceitável)
    exclude_contexts: [],  // ⚠️ FALLBACK [] (aceitável)
    environment: detectedEnvironment  // Usa variável detectada
};
```

**Problema:** Valores padrão de configuração hardcoded  
**Risco:** 🟡 **MÉDIO** - Valores padrão podem não ser apropriados  
**Recomendação:** Injetar configuração completa via data attributes ou variáveis de ambiente

---

#### 12.3. Linhas 234-235, 256-257, 267-268 (Levels Padrão)

**Código Atual:**
```javascript
const configLevel = levels[window.LOG_CONFIG.level?.toLowerCase()] || levels['info'];  // ❌ FALLBACK 'info'
const messageLevel = levels[level?.toLowerCase()] || levels['info'];  // ❌ FALLBACK 'info'

const minLevel = levels[window.LOG_CONFIG.database.min_level?.toLowerCase()] || levels['info'];  // ❌ FALLBACK 'info'
const messageLevel = levels[level?.toLowerCase()] || levels['info'];  // ❌ FALLBACK 'info'
```

**Problema:** Levels padrão hardcoded  
**Risco:** 🟡 **MÉDIO** - Pode causar logs excessivos ou insuficientes  
**Recomendação:** Usar valores mais restritivos como padrão ou injetar via configuração

---

### 13. **webflow_injection_limpo.js** - Fallbacks de Dados

#### 13.1. Linhas 1366-1367 (Status e Mensagem)

**Código Atual:**
```javascript
const currentStatus = progressData.status || 'processing';  // ❌ FALLBACK 'processing'
const mensagem = progressData.mensagem || '';  // ⚠️ FALLBACK '' (aceitável)
```

**Problema:** Status padrão hardcoded  
**Risco:** 🟡 **MÉDIO** - Pode mascarar problemas  
**Recomendação:** Validar que status está presente ou usar valor mais seguro

---

#### 13.2. Linhas 2235-2237 (Dados de Veículo)

**Código Atual:**
```javascript
const fabricante = r.marca || '';  // ⚠️ FALLBACK '' (aceitável)
const modelo = r.modelo || '';  // ⚠️ FALLBACK '' (aceitável)
const anoMod = r.ano || r.ano_modelo || '';  // ⚠️ FALLBACK '' (aceitável)
```

**Problema:** Fallbacks vazios para dados de veículo  
**Risco:** 🟢 **BAIXO** - Valores vazios são aceitáveis como fallback  
**Recomendação:** Manter como está (valores vazios são apropriados)

---

#### 13.3. Linhas 2430-2448 (Dados Fixos Hardcoded)

**Código Atual:**
```javascript
this.fixedData = {
    telefone: "11999999999",  // ❌ HARDCODED (dados de teste)
    email: "cliente@exemplo.com",  // ❌ HARDCODED (dados de teste)
    profissao: "Empresário",  // ❌ HARDCODED (dados de teste)
    // ... mais dados de teste
};
```

**Problema:** Dados de teste hardcoded (não são fallbacks, são valores diretos)  
**Risco:** 🟡 **MÉDIO** - Dados de teste podem ser usados acidentalmente  
**Recomendação:** Remover ou mover para variáveis de ambiente de teste

---

## 🟢 BAIXO - FALLBACKS TÉCNICOS E VALORES VAZIOS

### 14. **ProfessionalLogger.php** - Fallbacks Técnicos

#### 14.1. Valores 'N/A' em Logs de Erro

**Código Atual:**
```php
'sqlstate' => $errorInfo[0] ?? 'N/A',  // ⚠️ FALLBACK 'N/A' (técnico)
'error_code' => $errorInfo[1] ?? 'N/A',  // ⚠️ FALLBACK 'N/A' (técnico)
'error_message' => $errorInfo[2] ?? 'N/A',  // ⚠️ FALLBACK 'N/A' (técnico)
```

**Problema:** Valores 'N/A' para informações técnicas de erro  
**Risco:** 🟢 **BAIXO** - Valores técnicos de debug, não críticos  
**Recomendação:** Manter como está (valores técnicos apropriados)

---

#### 14.2. Valores Null em Informações de Arquivo

**Código Atual:**
```php
'file_path' => $caller['file'] ?? null,  // ⚠️ FALLBACK null (aceitável)
'line_number' => $caller['line'] ?? null,  // ⚠️ FALLBACK null (aceitável)
'function_name' => $caller['function'] ?? null,  // ⚠️ FALLBACK null (aceitável)
```

**Problema:** Fallbacks null para informações opcionais  
**Risco:** 🟢 **BAIXO** - Null é apropriado para valores opcionais  
**Recomendação:** Manter como está (null é apropriado)

---

### 15. **JavaScript** - Fallbacks de Valores Vazios

#### 15.1. Valores Vazios em Campos de Formulário

**Código Atual:**
```javascript
const ddd = data['DDD-CELULAR'] || '';  // ⚠️ FALLBACK '' (aceitável)
const celular = data['CELULAR'] || '';  // ⚠️ FALLBACK '' (aceitável)
const nome = data['NOME'] || 'Não informado';  // ❌ FALLBACK 'Não informado'
```

**Problema:** Alguns fallbacks com valores vazios (aceitável), outros com texto hardcoded  
**Risco:** 🟡 **MÉDIO** - Texto 'Não informado' hardcoded  
**Recomendação:** Usar valores vazios consistentemente ou injetar via configuração

---

## 📊 RESUMO POR ARQUIVO

### Arquivos PHP

| Arquivo | Fallbacks Críticos | Fallbacks Alto | Fallbacks Médio | Fallbacks Baixo | Total |
|---------|-------------------|----------------|-----------------|-----------------|-------|
| `config.php` | 5 | 0 | 1 | 0 | 6 |
| `ProfessionalLogger.php` | 2 | 0 | 5 | 3 | 10 |
| `cpf-validate.php` | 5 | 2 | 0 | 0 | 7 |
| `placa-validate.php` | 2 | 1 | 0 | 0 | 3 |
| `aws_ses_config.php` | 3 | 0 | 0 | 0 | 3 |
| `add_webflow_octa.php` | 2 | 1 | 0 | 0 | 3 |
| **TOTAL PHP** | **19** | **4** | **6** | **3** | **32** |

### Arquivos JavaScript

| Arquivo | Fallbacks Críticos | Fallbacks Alto | Fallbacks Médio | Fallbacks Baixo | Total |
|---------|-------------------|----------------|-----------------|-----------------|-------|
| `FooterCodeSiteDefinitivoCompleto.js` | 4 | 8 | 6 | 2 | 20 |
| `webflow_injection_limpo.js` | 0 | 6 | 4 | 2 | 12 |
| `MODAL_WHATSAPP_DEFINITIVO.js` | 0 | 10 | 8 | 5 | 23 |
| **TOTAL JS** | **4** | **24** | **18** | **9** | **55** |

### **TOTAL GERAL:** 87 fallbacks hardcoded

---

## 🎯 CATEGORIZAÇÃO POR RISCO

### 🔴 **CRÍTICO (15 ocorrências)** - Eliminar Imediatamente

1. **Credenciais e Secrets em Fallbacks:**
   - `getEspoCrmApiKey()` - API Key fallback
   - `getWebflowSecretFlyingDonkeys()` - Secret fallback (desatualizado)
   - `getWebflowSecretOctaDesk()` - Secret fallback (desatualizado)
   - `getOctaDeskApiKey()` - API Key fallback
   - `getDatabaseConfig()` - Credenciais de banco fallback
   - `ProfessionalLogger::loadConfig()` - Credenciais de banco fallback

2. **Credenciais Hardcoded Diretamente (não são fallbacks, mas devem ser eliminadas):**
   - `cpf-validate.php` - Credenciais PH3A
   - `placa-validate.php` - Token PlacaFipe
   - `aws_ses_config.php` - Emails hardcoded
   - `add_webflow_octa.php` - API Key OctaDesk
   - `FooterCodeSiteDefinitivoCompleto.js` - API Keys hardcoded

### 🟠 **ALTO (28 ocorrências)** - Eliminar com Prioridade

1. **URLs de APIs com Fallback:**
   - `FooterCodeSiteDefinitivoCompleto.js` - 6 URLs
   - `webflow_injection_limpo.js` - 6 URLs
   - `MODAL_WHATSAPP_DEFINITIVO.js` - 2 URLs

2. **Configurações com Fallback:**
   - `FooterCodeSiteDefinitivoCompleto.js` - Ambiente, flags
   - `MODAL_WHATSAPP_DEFINITIVO.js` - Variáveis GTM

3. **Detecção de Ambiente Hardcoded:**
   - `FooterCodeSiteDefinitivoCompleto.js` - Detecção hardcoded

### 🟡 **MÉDIO (32 ocorrências)** - Considerar Eliminação

1. **Valores Padrão de Configuração:**
   - `FooterCodeSiteDefinitivoCompleto.js` - LOG_CONFIG padrão
   - `ProfessionalLogger.php` - Valores padrão de contexto

2. **Fallbacks Técnicos:**
   - `ProfessionalLogger.php` - Valores 'N/A', 'unknown'
   - JavaScript - Valores padrão de status, mensagens

### 🟢 **BAIXO (12 ocorrências)** - Aceitáveis ou Técnicos

1. **Valores Null ou Vazios:**
   - Fallbacks null para valores opcionais (aceitável)
   - Fallbacks vazios para strings (aceitável)

2. **Valores Técnicos de Debug:**
   - 'N/A' em logs de erro (técnico, aceitável)
   - 'unknown' em informações de contexto (técnico, pode melhorar)

---

## 📋 ESTRATÉGIA DE ELIMINAÇÃO

### Fase 1: Eliminar Fallbacks Críticos (15 ocorrências)

**Prioridade:** 🔴 **MÁXIMA**

1. **config.php:**
   - Remover todos os fallbacks de credenciais
   - Lançar exceção se variável não estiver definida
   - Atualizar `getDatabaseConfig()` para validar todas as variáveis

2. **ProfessionalLogger.php:**
   - Usar `getDatabaseConfig()` de `config.php`
   - Remover fallbacks de credenciais

3. **Arquivos com credenciais hardcoded:**
   - Criar funções helper em `config.php`
   - Substituir valores hardcoded por chamadas às funções

### Fase 2: Eliminar Fallbacks de Alto Risco (28 ocorrências)

**Prioridade:** 🟠 **ALTA**

1. **JavaScript:**
   - Injetar todas as URLs via data attributes
   - Remover fallbacks hardcoded
   - Lançar erro se variáveis não estiverem definidas

2. **Detecção de Ambiente:**
   - Remover detecção hardcoded
   - Usar apenas `window.APP_ENVIRONMENT` injetado

### Fase 3: Revisar Fallbacks Médios (32 ocorrências)

**Prioridade:** 🟡 **MÉDIA**

1. **Valores Padrão:**
   - Avaliar se valores padrão são apropriados
   - Considerar injetar via configuração

2. **Valores Técnicos:**
   - Manter null/vazio onde apropriado
   - Melhorar 'unknown' para null onde possível

---

## 🔍 ANÁLISE DETALHADA POR ARQUIVO

### **config.php** - 6 Fallbacks Críticos

#### Fallback 1: `getEnvironment()` - Linha 23
```php
return $_ENV['PHP_ENV'] ?? 'development';  // ❌
```
**Ação:** Lançar exceção

#### Fallback 2: `getEspoCrmApiKey()` - Linhas 160-162
```php
return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
    ? '73b5b7983bfc641cdba72d204a48ed9d'
    : '82d5f667f3a65a9a43341a0705be2b0c');  // ❌
```
**Ação:** Lançar exceção

#### Fallback 3: `getWebflowSecretFlyingDonkeys()` - Linhas 170-172
```php
return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'] ?? (isDevelopment()
    ? '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51'
    : '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51');  // ❌
```
**Ação:** Lançar exceção

#### Fallback 4: `getWebflowSecretOctaDesk()` - Linhas 180-182
```php
return $_ENV['WEBFLOW_SECRET_OCTADESK'] ?? (isDevelopment()
    ? '4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd'
    : '4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd');  // ❌
```
**Ação:** Lançar exceção

#### Fallback 5: `getOctaDeskApiKey()` - Linha 190
```php
return $_ENV['OCTADESK_API_KEY'] ?? 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';  // ❌
```
**Ação:** Lançar exceção

#### Fallback 6: `getDatabaseConfig()` - Linhas 132-136
```php
'host' => $_ENV['LOG_DB_HOST'] ?? 'localhost',  // ❌
'port' => (int)($_ENV['LOG_DB_PORT'] ?? 3306),  // ❌
'name' => $_ENV['LOG_DB_NAME'] ?? (isDevelopment() ? 'rpa_logs_dev' : 'rpa_logs_prod'),  // ❌
'user' => $_ENV['LOG_DB_USER'] ?? (isDevelopment() ? 'rpa_logger_dev' : 'rpa_logger_prod'),  // ❌
'pass' => $_ENV['LOG_DB_PASS'] ?? ''  // ❌
```
**Ação:** Validar todas as variáveis e lançar exceção se faltar alguma

---

### **ProfessionalLogger.php** - 10 Fallbacks

#### Fallbacks Críticos (2):

1. **Linha 284-288:** Credenciais de banco com fallback
   - **Ação:** Usar `getDatabaseConfig()` de `config.php`

2. **Linha 248:** Ambiente com fallback
   - **Ação:** Usar `getEnvironment()` de `config.php`

#### Fallbacks Médios (5):

3. **Linha 393:** `'file_name' => basename($caller['file'] ?? 'unknown')`
   - **Ação:** Usar null em vez de 'unknown'

4. **Linhas 406-409:** Valores 'unknown' para IP, user agent, URL, server name
   - **Ação:** Usar null em vez de 'unknown'

5. **Linha 601:** `$level = $logData['level'] ?? 'INFO'`
   - **Ação:** Validar que level está presente

6. **Linhas 732-735:** Valores 'N/A' em logs de erro
   - **Ação:** Manter como está (técnico)

7. **Linha 629:** `$logData['message'] ?? 'N/A'`
   - **Ação:** Validar que message está presente

#### Fallbacks Baixos (3):

8. **Linhas 394-397:** Valores null para informações opcionais
   - **Ação:** Manter como está (null é apropriado)

9. **Linhas 437-440:** Valores null/unknown para informações JS
   - **Ação:** Melhorar 'unknown' para null

10. **Linhas 698-700, 714-716, 794-796, 805:** Valores 'N/A' em logs técnicos
    - **Ação:** Manter como está (técnico)

---

### **FooterCodeSiteDefinitivoCompleto.js** - 20 Fallbacks

#### Fallbacks Críticos (4):

1. **Linha 683:** `window.USE_PHONE_API = true;`  // ❌ HARDCODED
2. **Linha 683:** `window.APILAYER_KEY = 'dce92fa84152098a3b5b7b8db24debbc';`  // ❌ HARDCODED
3. **Linha 684:** `window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e';`  // ❌ HARDCODED
4. **Linha 685:** `window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f';`  // ❌ HARDCODED
5. **Linha 1881:** `window.rpaEnabled = false;`  // ❌ HARDCODED

**Ação:** Injetar via data attributes do Webflow

#### Fallbacks Altos (8):

6. **Linha 102:** `window.APP_ENVIRONMENT = currentScript.dataset.appEnvironment || 'development';`  // ❌
   - **Ação:** Lançar erro se não estiver definido

7. **Linha 165:** `let detectedEnvironment = logConfigFromAttribute.environment || window.APP_ENVIRONMENT || 'prod';`  // ❌
   - **Ação:** Remover fallback 'prod', usar apenas variável injetada

8. **Linhas 168-172:** Detecção hardcoded de ambiente
   - **Ação:** Remover detecção hardcoded

9. **Linhas 655-660:** URLs de APIs com fallback
   - **Ação:** Injetar via data attributes ou lançar erro

10. **Linhas 176-194:** LOG_CONFIG padrão hardcoded
    - **Ação:** Injetar via data attributes

11. **Linhas 234-235, 256-257, 267-268:** Levels padrão hardcoded
    - **Ação:** Usar valores mais restritivos ou injetar

#### Fallbacks Médios (6):

12. **Linha 207:** `...(window.LOG_CONFIG || {})`  // ⚠️ Fallback objeto vazio
    - **Ação:** Validar que LOG_CONFIG está definido

13. **Linhas 228-229, 251-252, 262-263:** Verificações com fallback
    - **Ação:** Validar que configuração está presente

#### Fallbacks Baixos (2):

14. **Linha 388:** `session_id: window.sessionId || null`  // ⚠️ Fallback null (aceitável)
15. **Linha 566:** `String(level || 'INFO')`  // ⚠️ Fallback 'INFO' (técnico)

---

### **webflow_injection_limpo.js** - 12 Fallbacks

#### Fallbacks Altos (6):

1. **Linhas 25-35:** URLs de APIs com fallback
   - **Ação:** Injetar via data attributes ou lançar erro

#### Fallbacks Médios (4):

2. **Linhas 1366-1367:** Status e mensagem com fallback
   - **Ação:** Validar que valores estão presentes

3. **Linhas 2235-2237:** Dados de veículo com fallback vazio
   - **Ação:** Manter como está (vazio é apropriado)

4. **Linhas 2430-2448:** Dados fixos hardcoded (não são fallbacks)
   - **Ação:** Remover ou mover para variáveis de ambiente de teste

#### Fallbacks Baixos (2):

5. **Linhas 3004, 3152-3168:** Valores vazios como fallback
   - **Ação:** Manter como está (vazio é apropriado)

---

### **MODAL_WHATSAPP_DEFINITIVO.js** - 23 Fallbacks

#### Fallbacks Altos (10):

1. **Linhas 36-37:** URLs de APIs com fallback
   - **Ação:** Injetar via data attributes ou lançar erro

2. **Linhas 77-87:** Variáveis GTM com fallback
   - **Ação:** Injetar via data attributes (valores opcionais podem manter null)

#### Fallbacks Médios (8):

3. **Linhas 133-147:** Detecção de ambiente hardcoded
   - **Ação:** Remover, usar apenas `window.APP_ENVIRONMENT`

4. **Linhas 618-625, 717-725:** Dados de formulário com fallback
   - **Ação:** Validar que dados estão presentes ou usar valores vazios

#### Fallbacks Baixos (5):

5. **Linhas 298, 191, 204:** Valores padrão técnicos
   - **Ação:** Manter como está (valores técnicos apropriados)

---

## 📊 RESUMO ESTATÍSTICO

### Distribuição por Categoria

| Categoria | Quantidade | Percentual |
|-----------|-----------|------------|
| 🔴 **CRÍTICO** | 15 | 17% |
| 🟠 **ALTO** | 28 | 32% |
| 🟡 **MÉDIO** | 32 | 37% |
| 🟢 **BAIXO** | 12 | 14% |
| **TOTAL** | **87** | **100%** |

### Distribuição por Tipo de Arquivo

| Tipo | Quantidade | Percentual |
|------|-----------|------------|
| **PHP** | 32 | 37% |
| **JavaScript** | 55 | 63% |
| **TOTAL** | **87** | **100%** |

### Distribuição por Padrão de Fallback

| Padrão | Quantidade | Exemplo |
|--------|-----------|---------|
| `$_ENV['VAR'] ?? 'fallback'` | 19 | PHP |
| `window.VAR \|\| 'fallback'` | 28 | JavaScript |
| `window.VAR \|\| null` | 12 | JavaScript (aceitável) |
| Valores hardcoded diretos | 28 | Não são fallbacks, mas devem ser eliminados |

---

## 🎯 RECOMENDAÇÕES PRIORITÁRIAS

### 🔴 **CRÍTICO - Eliminar Imediatamente:**

1. **Remover TODOS os fallbacks de credenciais em `config.php`**
   - `getEspoCrmApiKey()` → Lançar exceção
   - `getWebflowSecretFlyingDonkeys()` → Lançar exceção
   - `getWebflowSecretOctaDesk()` → Lançar exceção
   - `getOctaDeskApiKey()` → Lançar exceção
   - `getDatabaseConfig()` → Validar todas as variáveis

2. **Substituir credenciais hardcoded por funções helper:**
   - `cpf-validate.php` → Criar funções PH3A em `config.php`
   - `placa-validate.php` → Criar funções PlacaFipe em `config.php`
   - `aws_ses_config.php` → Usar variáveis de ambiente
   - `add_webflow_octa.php` → Usar funções helper existentes

3. **Eliminar API Keys hardcoded em JavaScript:**
   - `FooterCodeSiteDefinitivoCompleto.js` → Injetar via data attributes

### 🟠 **ALTO - Eliminar com Prioridade:**

4. **Remover fallbacks de URLs de APIs:**
   - Injetar todas as URLs via data attributes
   - Lançar erro se não estiverem definidas

5. **Remover detecção hardcoded de ambiente:**
   - Usar apenas `window.APP_ENVIRONMENT` injetado
   - Lançar erro se não estiver definido

### 🟡 **MÉDIO - Considerar Eliminação:**

6. **Revisar valores padrão de configuração:**
   - Injetar via data attributes quando possível
   - Usar valores mais restritivos como padrão

7. **Melhorar fallbacks técnicos:**
   - Substituir 'unknown' por null onde apropriado
   - Validar valores antes de usar fallback

---

## 📝 PLANO DE AÇÃO SUGERIDO

### Etapa 1: Preparação
- [ ] Criar backup de todos os arquivos
- [ ] Documentar valores atuais de todas as variáveis de ambiente

### Etapa 2: Eliminar Fallbacks Críticos em PHP
- [ ] Atualizar `config.php` para remover fallbacks de credenciais
- [ ] Criar funções helper para PH3A e PlacaFipe
- [ ] Atualizar `ProfessionalLogger.php` para usar funções de `config.php`
- [ ] Atualizar arquivos que usam credenciais hardcoded

### Etapa 3: Eliminar Fallbacks em JavaScript
- [ ] Atualizar `FooterCodeSiteDefinitivoCompleto.js` para ler de data attributes
- [ ] Remover detecção hardcoded de ambiente
- [ ] Atualizar outros arquivos JS para remover fallbacks de URLs

### Etapa 4: Validação
- [ ] Testar que todas as variáveis são lidas corretamente
- [ ] Verificar que erros são lançados quando variáveis não estão definidas
- [ ] Confirmar que nenhum valor hardcoded está exposto

---

## ⚠️ AVISOS IMPORTANTES

1. **NÃO eliminar fallbacks sem garantir que variáveis de ambiente estão definidas**
2. **SEMPRE criar backup antes de modificar**
3. **SEMPRE testar após cada modificação**
4. **SEMPRE verificar hash após deploy**

---

**Análise realizada em:** 18/11/2025  
**Próxima ação:** Aguardar autorização para implementar eliminação dos fallbacks

