# Guia Completo: Variáveis de Ambiente - Definição e Uso

**Data:** 18/11/2025  
**Versão:** 1.0.0

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Onde são Definidas](#onde-são-definidas)
3. [Como são Carregadas no PHP](#como-são-carregadas-no-php)
4. [Como são Expostas para JavaScript](#como-são-expostas-para-javascript)
5. [Como são Utilizadas](#como-são-utilizadas)
6. [Fluxo Completo](#fluxo-completo)
7. [Exemplos Práticos](#exemplos-práticos)

---

## 🎯 Visão Geral

As variáveis de ambiente são definidas no **PHP-FPM** e ficam disponíveis para:
- **PHP:** Via `$_ENV` e funções helper em `config.php`
- **JavaScript:** Via arquivo `config_env.js.php` que injeta variáveis no `window`

---

## 📍 Onde são Definidas

### 1. Arquivo de Configuração PHP-FPM

**Localização:** `/etc/php/8.2/fpm/pool.d/www.conf` (no servidor)

**Arquivo Local (referência):** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.txt`

**Formato:**
```ini
; Ambiente
env[PHP_ENV] = development
env[APP_BASE_DIR] = /var/www/html/dev/root
env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br

; Banco de Dados
env[LOG_DB_HOST] = localhost
env[LOG_DB_PORT] = 3306
env[LOG_DB_NAME] = rpa_logs_dev
env[LOG_DB_USER] = rpa_logger_dev
env[LOG_DB_PASS] = tYbAwe7QkKNrHSRhaWplgsSxt

; EspoCRM
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d

; Webflow Secrets
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
env[WEBFLOW_SECRET_OCTADESK] = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291

; OctaDesk
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services

; AWS SES
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
env[AWS_SES_FROM_NAME] = Imediato Seguros
env[AWS_SES_ADMIN_EMAILS] = admin@bssegurosimediato.com.br,suporte@bssegurosimediato.com.br
env[AWS_REGION] = us-east-1
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

### 2. Processo de Aplicação

1. **Editar arquivo local:** `php-fpm_www_conf_DEV.txt`
2. **Copiar para servidor:** Via SCP para `/etc/php/8.2/fpm/pool.d/www.conf`
3. **Recarregar PHP-FPM:** `systemctl reload php8.2-fpm`
4. **Verificar:** Testar se variáveis estão disponíveis

---

## 🔄 Como são Carregadas no PHP

### 1. Carregamento Automático pelo PHP-FPM

Quando o PHP-FPM inicia, ele lê o arquivo `www.conf` e disponibiliza todas as variáveis definidas com `env[]` no array `$_ENV` do PHP.

**Exemplo:**
```php
// PHP-FPM automaticamente disponibiliza:
$_ENV['APP_BASE_URL'] = 'https://dev.bssegurosimediato.com.br';
$_ENV['ESPOCRM_API_KEY'] = '73b5b7983bfc641cdba72d204a48ed9d';
// ... etc
```

### 2. Arquivo `config.php` - Funções Helper

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`

Este arquivo fornece funções helper para acesso seguro às variáveis de ambiente:

```php
<?php
// Exemplo de função helper
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'  // Fallback para dev
        : '82d5f667f3a65a9a43341a0705be2b0c'); // Fallback para prod
}

function getWebflowSecretFlyingDonkeys() {
    return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'] ?? (isDevelopment()
        ? '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51'
        : '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51');
}
```

### 3. Uso Direto em Arquivos PHP

**Opção 1: Via `$_ENV` diretamente**
```php
$apiKey = $_ENV['ESPOCRM_API_KEY'] ?? 'fallback_value';
```

**Opção 2: Via função helper (RECOMENDADO)**
```php
require_once __DIR__ . '/config.php';
$apiKey = getEspoCrmApiKey();
```

**Exemplo Real:**
```php
// add_flyingdonkeys.php linha 67
require_once __DIR__ . '/config.php';
$WEBFLOW_SECRET_TRAVELANGELS = getWebflowSecretFlyingDonkeys();
```

---

## 🌐 Como são Expostas para JavaScript

### 1. Arquivo `config_env.js.php`

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config_env.js.php`

Este arquivo PHP é executado pelo servidor e gera código JavaScript que injeta variáveis no objeto `window`:

```php
<?php
header('Content-Type: application/javascript');

// Ler variáveis de ambiente do PHP-FPM
$base_url = $_ENV['APP_BASE_URL'] ?? '';
$environment = $_ENV['PHP_ENV'] ?? 'development';

// Gerar código JavaScript
?>
window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;
```

**Resultado no navegador:**
```javascript
window.APP_BASE_URL = "https://dev.bssegurosimediato.com.br";
window.APP_ENVIRONMENT = "development";
```

### 2. Como Incluir no HTML

**Opção 1: Via tag `<script>`**
```html
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"></script>
```

**Opção 2: Via data attributes (atual)**
```html
<script 
    src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    data-app-base-url="https://dev.bssegurosimediato.com.br"
    data-app-environment="development">
</script>
```

### 3. Leitura no JavaScript

**Arquivo:** `FooterCodeSiteDefinitivoCompleto.js` (linhas 98-113)

```javascript
// Ler do data attribute do próprio script tag
const currentScript = document.currentScript;
if (currentScript && currentScript.dataset) {
    window.APP_BASE_URL = currentScript.dataset.appBaseUrl || null;
    window.APP_ENVIRONMENT = currentScript.dataset.appEnvironment || 'development';
}
```

---

## 💻 Como são Utilizadas

### 1. Em Arquivos PHP

#### Exemplo 1: Usando função helper (RECOMENDADO)
```php
// add_flyingdonkeys.php
require_once __DIR__ . '/config.php';

// Usar função helper
$WEBFLOW_SECRET = getWebflowSecretFlyingDonkeys();
$ESPOCRM_URL = getEspoCrmUrl();
$ESPOCRM_API_KEY = getEspoCrmApiKey();
```

#### Exemplo 2: Usando `$_ENV` diretamente
```php
// aws_ses_config.php (ATUAL - PRECISA CORRIGIR)
define('EMAIL_FROM', 'noreply@bpsegurosimediato.com.br'); // ❌ HARDCODED

// CORREÇÃO NECESSÁRIA:
define('EMAIL_FROM', $_ENV['AWS_SES_FROM_EMAIL'] ?? 'noreply@bssegurosimediato.com.br');
```

#### Exemplo 3: Usando em ProfessionalLogger
```php
// ProfessionalLogger.php linha 283
$this->config = [
    'host' => $_ENV['LOG_DB_HOST'] ?? getenv('LOG_DB_HOST') ?: $defaultHost,
    'port' => $_ENV['LOG_DB_PORT'] ?? getenv('LOG_DB_PORT') ?: 3306,
    'dbname' => $_ENV['LOG_DB_NAME'] ?? getenv('LOG_DB_NAME') ?: 'rpa_logs_dev',
    'username' => $_ENV['LOG_DB_USER'] ?? getenv('LOG_DB_USER') ?: 'rpa_logger_dev',
    'password' => $_ENV['LOG_DB_PASS'] ?? getenv('LOG_DB_PASS') ?: ''
];
```

### 2. Em Arquivos JavaScript

#### Exemplo 1: Usando variáveis injetadas
```javascript
// FooterCodeSiteDefinitivoCompleto.js
const endpointUrl = window.APP_BASE_URL + '/add_flyingdonkeys.php';

// Ou usando função helper
const endpointUrl = window.getEndpointUrl('add_flyingdonkeys.php');
```

#### Exemplo 2: Detecção de ambiente
```javascript
// FooterCodeSiteDefinitivoCompleto.js linha 165
let detectedEnvironment = window.APP_ENVIRONMENT || 'prod';

if (detectedEnvironment === 'auto') {
    const hostname = window.location.hostname;
    if (hostname.includes('dev.') || hostname.includes('localhost')) {
        detectedEnvironment = 'dev';
    } else {
        detectedEnvironment = 'prod';
    }
}
```

#### Exemplo 3: Fallback para valores padrão
```javascript
// webflow_injection_limpo.js linha 25-35
const VIACEP_BASE_URL = window.VIACEP_BASE_URL || 'https://viacep.com.br';
const APILAYER_BASE_URL = window.APILAYER_BASE_URL || 'https://apilayer.net';
const RPA_API_BASE_URL = window.RPA_API_BASE_URL || 'https://rpaimediatoseguros.com.br';
```

---

## 🔄 Fluxo Completo

### Fluxo PHP

```
1. PHP-FPM inicia
   ↓
2. Lê /etc/php/8.2/fpm/pool.d/www.conf
   ↓
3. Carrega variáveis env[] no $_ENV
   ↓
4. Arquivo PHP executa
   ↓
5. require_once 'config.php'
   ↓
6. Usa funções helper: getEspoCrmApiKey(), etc.
   ↓
7. Funções retornam $_ENV['VAR'] ?? fallback
```

### Fluxo JavaScript

```
1. HTML carrega
   ↓
2. <script src="config_env.js.php"></script> executa
   ↓
3. PHP gera JavaScript: window.APP_BASE_URL = "..."
   ↓
4. JavaScript executa e define window.APP_BASE_URL
   ↓
5. FooterCodeSiteDefinitivoCompleto.js carrega
   ↓
6. Lê window.APP_BASE_URL ou data attribute
   ↓
7. Usa variável para construir URLs de endpoints
```

---

## 📝 Exemplos Práticos

### Exemplo 1: Adicionar Nova Variável de Ambiente

**Passo 1:** Adicionar no PHP-FPM config
```ini
; php-fpm_www_conf_DEV.txt
env[NOVA_VARIAVEL] = valor_da_variavel
```

**Passo 2:** Criar função helper em `config.php`
```php
function getNovaVariavel() {
    return $_ENV['NOVA_VARIAVEL'] ?? 'valor_padrao';
}
```

**Passo 3:** Usar em PHP
```php
require_once __DIR__ . '/config.php';
$valor = getNovaVariavel();
```

**Passo 4:** Expor para JavaScript (se necessário)
```php
// config_env.js.php
window.NOVA_VARIAVEL = <?php echo json_encode($_ENV['NOVA_VARIAVEL'] ?? ''); ?>;
```

**Passo 5:** Usar em JavaScript
```javascript
const valor = window.NOVA_VARIAVEL || 'valor_padrao';
```

### Exemplo 2: Corrigir Variável Hardcoded

**ANTES (hardcoded):**
```php
// aws_ses_config.php
define('EMAIL_FROM', 'noreply@bpsegurosimediato.com.br'); // ❌
```

**DEPOIS (usando env):**
```php
// aws_ses_config.php
require_once __DIR__ . '/config.php';
define('EMAIL_FROM', $_ENV['AWS_SES_FROM_EMAIL'] ?? 'noreply@bssegurosimediato.com.br'); // ✅
```

### Exemplo 3: Usar Variável em Requisição AJAX

**JavaScript:**
```javascript
// Construir URL usando variável de ambiente
const endpoint = window.APP_BASE_URL + '/add_flyingdonkeys.php';

fetch(endpoint, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
})
.then(response => response.json())
.then(data => {
    console.log('Sucesso:', data);
});
```

---

## ⚠️ Boas Práticas

### ✅ FAZER

1. **Sempre usar funções helper** quando disponíveis em `config.php`
2. **Sempre verificar se variável existe** antes de usar: `$_ENV['VAR'] ?? 'fallback'`
3. **Documentar novas variáveis** no arquivo PHP-FPM config
4. **Usar fallbacks apropriados** para cada ambiente (dev/prod)
5. **Validar valores** antes de usar (especialmente URLs e credenciais)

### ❌ NÃO FAZER

1. **Nunca hardcodar valores** que devem vir de variáveis de ambiente
2. **Nunca commitar credenciais** no código
3. **Nunca usar `$_ENV` diretamente** sem fallback quando função helper existe
4. **Nunca expor credenciais** no JavaScript (apenas URLs e flags)
5. **Nunca assumir** que variável está definida sem verificar

---

## 📚 Referências

- **Arquivo de Configuração PHP-FPM:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.txt`
- **Funções Helper:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`
- **Injeção JavaScript:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config_env.js.php`
- **Análise de Variáveis Hardcoded:** `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/ANALISE_VARIAVEIS_HARDCODE_20251118.md`

---

**Documento criado em:** 18/11/2025  
**Última atualização:** 18/11/2025

