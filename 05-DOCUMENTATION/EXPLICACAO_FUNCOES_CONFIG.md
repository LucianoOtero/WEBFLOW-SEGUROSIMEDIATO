# 📚 EXPLICAÇÃO DAS FUNÇÕES DE CONFIGURAÇÃO

**Data:** 10/11/2025  
**Arquivo:** `config.php`

---

## 🔍 FUNÇÕES PRINCIPAIS

### 1. `getBaseDir()`

**O que faz:** Retorna o diretório base físico no servidor.

**Como funciona:**
```php
function getBaseDir() {
    // 1. Lê a variável de ambiente APP_BASE_DIR
    $baseDir = $_ENV['APP_BASE_DIR'] ?? '';
    
    // 2. Valida se está definida (SEM FALLBACK)
    if (empty($baseDir)) {
        error_log('[CONFIG] ERRO CRÍTICO: APP_BASE_DIR não está definido');
        throw new RuntimeException('APP_BASE_DIR não está definido');
    }
    
    // 3. Remove barras no final (normaliza)
    return rtrim($baseDir, '/\\');
}
```

**Exemplo de uso:**
```php
// Em add_flyingdonkeys.php
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
// Resultado: /var/www/html/dev/root/logs
```

**Valor no servidor DEV:**
- Variável: `APP_BASE_DIR = /var/www/html/dev/root`
- Retorna: `/var/www/html/dev/root`

**Quando usar:**
- Para caminhos de arquivos locais
- Para diretórios de logs
- Para `file_get_contents()` de arquivos locais
- Para `require_once` de arquivos relativos

---

### 2. `getCorsOrigins()`

**O que faz:** Retorna um array com todas as origens permitidas para CORS.

**Como funciona:**
```php
function getCorsOrigins() {
    // 1. Lê a variável de ambiente APP_CORS_ORIGINS (string separada por vírgulas)
    $corsOrigins = $_ENV['APP_CORS_ORIGINS'] ?? '';
    
    // 2. Valida se está definida (SEM FALLBACK)
    if (empty($corsOrigins)) {
        error_log('[CONFIG] ERRO CRÍTICO: APP_CORS_ORIGINS não está definido');
        throw new RuntimeException('APP_CORS_ORIGINS não está definido');
    }
    
    // 3. Separa por vírgula e remove espaços
    $origins = array_map('trim', explode(',', $corsOrigins));
    
    // 4. Remove valores vazios
    return array_filter($origins);
}
```

**Exemplo de uso:**
```php
// Em add_flyingdonkeys.php
$allowed_origins = getCorsOrigins();
// Resultado: ['https://segurosimediato-dev.webflow.io', 'https://dev.bssegurosimediato.com.br', ...]

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if (in_array($origin, $allowed_origins)) {
    header('Access-Control-Allow-Origin: ' . $origin);
}
```

**Valor no servidor DEV:**
- Variável: `APP_CORS_ORIGINS = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br`
- Retorna: 
  ```php
  [
      'https://segurosimediato-dev.webflow.io',
      'https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io',
      'https://dev.bssegurosimediato.com.br'
  ]
  ```

**Quando usar:**
- Para validar origens CORS em endpoints PHP
- Para configurar headers `Access-Control-Allow-Origin`
- Substitui listas hardcoded de origens permitidas

---

### 3. `getEspoCrmUrl()`

**O que faz:** Retorna a URL base da API do EspoCRM (FlyingDonkeys).

**Como funciona:**
```php
function getEspoCrmUrl() {
    // 1. Lê a variável de ambiente ESPOCRM_URL
    $url = $_ENV['ESPOCRM_URL'] ?? '';
    
    // 2. Valida se está definida (SEM FALLBACK)
    if (empty($url)) {
        error_log('[CONFIG] ERRO CRÍTICO: ESPOCRM_URL não está definido');
        throw new RuntimeException('ESPOCRM_URL não está definido');
    }
    
    // 3. Retorna a URL
    return $url;
}
```

**Exemplo de uso:**
```php
// Em add_flyingdonkeys.php
$FLYINGDONKEYS_API_URL = getEspoCrmUrl();
// Resultado: https://dev.flyingdonkeys.com.br (DEV) ou https://flyingdonkeys.com.br (PROD)

// Fazer requisição para o EspoCRM
$response = file_get_contents($FLYINGDONKEYS_API_URL . '/api/v1/Lead', ...);
```

**Valor no servidor DEV:**
- Variável: `ESPOCRM_URL = https://dev.flyingdonkeys.com.br`
- Retorna: `https://dev.flyingdonkeys.com.br`

**Valor no servidor PROD:**
- Variável: `ESPOCRM_URL = https://flyingdonkeys.com.br`
- Retorna: `https://flyingdonkeys.com.br`

**Quando usar:**
- Para fazer requisições à API do EspoCRM
- Para construir URLs de endpoints do EspoCRM
- Substitui URLs hardcoded do FlyingDonkeys

---

## 🔄 FLUXO DE DADOS

### Como as variáveis chegam até as funções:

```
1. Servidor (PHP-FPM Pool)
   └─> /etc/php/8.3/fpm/pool.d/www.conf
       └─> env[APP_BASE_DIR] = /var/www/html/dev/root
       └─> env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,...
       └─> env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br

2. PHP Runtime
   └─> $_ENV['APP_BASE_DIR'] = /var/www/html/dev/root
   └─> $_ENV['APP_CORS_ORIGINS'] = https://segurosimediato-dev.webflow.io,...
   └─> $_ENV['ESPOCRM_URL'] = https://dev.flyingdonkeys.com.br

3. config.php
   └─> getBaseDir() → lê $_ENV['APP_BASE_DIR']
   └─> getCorsOrigins() → lê $_ENV['APP_CORS_ORIGINS']
   └─> getEspoCrmUrl() → lê $_ENV['ESPOCRM_URL']

4. Arquivos do Projeto
   └─> add_flyingdonkeys.php → usa getBaseDir(), getCorsOrigins(), getEspoCrmUrl()
   └─> add_webflow_octa.php → usa getCorsOrigins(), getBaseDir()
   └─> ProfessionalLogger.php → usa getBaseDir()
```

---

## ⚠️ COMPORTAMENTO CRÍTICO

### **SEM FALLBACKS**

Todas as três funções **NÃO têm fallbacks hardcoded**. Se a variável de ambiente não estiver definida:

1. **Registram erro no log:**
   ```php
   error_log('[CONFIG] ERRO CRÍTICO: VARIAVEL não está definida');
   ```

2. **Lançam exceção:**
   ```php
   throw new RuntimeException('VARIAVEL não está definida');
   ```

3. **Interrompem a execução:**
   - O script PHP para imediatamente
   - Erro 500 é retornado ao cliente
   - Força a configuração correta das variáveis

### **Por que sem fallbacks?**

- **Garantia de configuração:** Força que todas as variáveis estejam configuradas
- **Detecção precoce de erros:** Erros aparecem imediatamente, não silenciosamente
- **Ambiente específico:** Cada ambiente (DEV/PROD) deve ter suas próprias variáveis
- **Segurança:** Evita usar valores padrão incorretos

---

## 📝 EXEMPLOS PRÁTICOS

### Exemplo 1: Usar `getBaseDir()` para logs

```php
// ❌ ANTES (hardcoded)
$logFile = '/var/www/html/dev/logs/flyingdonkeys_dev.txt';

// ✅ DEPOIS (usando variável de ambiente)
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
$logFile = rtrim($logDir, '/\\') . '/flyingdonkeys_dev.txt';
```

### Exemplo 2: Usar `getCorsOrigins()` para CORS

```php
// ❌ ANTES (hardcoded)
$allowed_origins = [
    'https://segurosimediato-dev.webflow.io',
    'https://dev.bssegurosimediato.com.br',
    // ...
];

// ✅ DEPOIS (usando variável de ambiente)
$allowed_origins = getCorsOrigins();
```

### Exemplo 3: Usar `getEspoCrmUrl()` para API

```php
// ❌ ANTES (hardcoded)
$apiUrl = 'https://dev.flyingdonkeys.com.br';

// ✅ DEPOIS (usando variável de ambiente)
$apiUrl = getEspoCrmUrl();
```

---

## 🔍 ONDE SÃO USADAS

### `getBaseDir()`
- ✅ `add_flyingdonkeys.php` - Diretórios de log
- ✅ `add_webflow_octa.php` - Diretórios de log
- ✅ `ProfessionalLogger.php` - Diretórios de log
- ✅ `log_endpoint.php` - Diretórios de log

### `getCorsOrigins()`
- ✅ `add_flyingdonkeys.php` - Validação CORS
- ✅ `add_webflow_octa.php` - Validação CORS

### `getEspoCrmUrl()`
- ✅ `add_flyingdonkeys.php` - URL da API EspoCRM

---

## ✅ VANTAGENS

1. **Centralização:** Todas as configurações em um único lugar (`config.php`)
2. **Flexibilidade:** Fácil mudar valores sem alterar código
3. **Ambiente específico:** DEV e PROD têm valores diferentes automaticamente
4. **Validação:** Erros aparecem imediatamente se variáveis não estiverem configuradas
5. **Manutenibilidade:** Fácil adicionar novas variáveis seguindo o mesmo padrão

---

**Documento criado em:** 10/11/2025

