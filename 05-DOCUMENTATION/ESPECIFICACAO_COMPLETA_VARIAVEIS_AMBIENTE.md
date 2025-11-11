# 📋 ESPECIFICAÇÃO COMPLETA - USO DE VARIÁVEIS DE AMBIENTE

**Data:** 08/11/2025  
**Versão:** 1.0  
**Status:** ✅ **ESPECIFICAÇÃO DEFINITIVA**

---

## 🎯 OBJETIVO

Usar **variáveis de ambiente do Docker** para localizar onde estão os arquivos `.js` e `.php`, eliminando URLs hardcoded e permitindo mudança fácil de ambiente (dev/prod).

---

## 🔧 VARIÁVEIS DE AMBIENTE NO DOCKER

### **Configuração no `docker-compose.yml`:**

```yaml
php-dev:
  environment:
    - PHP_ENV=development
    - APP_BASE_DIR=/var/www/html/dev/root
    - APP_BASE_URL=https://dev.bssegurosimediato.com.br
    - APP_CORS_ORIGINS=https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,...

php-prod:
  environment:
    - PHP_ENV=production
    - APP_BASE_DIR=/var/www/html/prod/root
    - APP_BASE_URL=https://bssegurosimediato.com.br
    - APP_CORS_ORIGINS=https://www.segurosimediato.com.br,...
```

### **Variáveis Disponíveis:**

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `APP_BASE_DIR` | Diretório físico no servidor onde estão os arquivos | `/var/www/html/dev/root` |
| `APP_BASE_URL` | URL base para acessar os arquivos via HTTP | `https://dev.bssegurosimediato.com.br` |
| `APP_CORS_ORIGINS` | Origens permitidas para CORS | `https://segurosimediato-dev.webflow.io,...` |

---

## ✅ ESPECIFICAÇÃO PARA PHP

### **Como PHP deve usar:**

1. **Ler variáveis de ambiente diretamente:**
   ```php
   $base_dir = $_ENV['APP_BASE_DIR'] ?? __DIR__;
   $base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
   $cors_origins = $_ENV['APP_CORS_ORIGINS'] ?? '';
   ```

2. **Usar `APP_BASE_DIR` para includes locais:**
   ```php
   require_once $_ENV['APP_BASE_DIR'] . '/class.php';
   // OU
   require_once $CONFIG['paths']['class']; // Se usar config.php
   ```

3. **Usar `APP_BASE_URL` para construir URLs (se necessário):**
   ```php
   $endpoint_url = $_ENV['APP_BASE_URL'] . '/debug_logger_db.php';
   ```

4. **Usar `APP_CORS_ORIGINS` para CORS:**
   ```php
   $allowed_origins = array_map('trim', explode(',', $_ENV['APP_CORS_ORIGINS']));
   ```

### **Arquivo `config.php` (já está correto):**

```php
<?php
// Ler variáveis de ambiente
$base_dir = $_ENV['APP_BASE_DIR'] ?? __DIR__;
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
$cors_origins = $_ENV['APP_CORS_ORIGINS'] ?? '';

// Configuração
$CONFIG = [
    'base_dir' => $base_dir,
    'base_url' => $base_url,
    'paths' => [
        'class' => $base_dir . '/class.php',
        'aws_ses_config' => $base_dir . '/aws_ses_config.php',
    ],
    'cors' => [
        'allowed_origins' => array_map('trim', explode(',', $cors_origins)),
    ],
];

// Função para aplicar CORS
function applyCorsHeaders() {
    global $CONFIG;
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    if (in_array($origin, $CONFIG['cors']['allowed_origins'])) {
        header('Access-Control-Allow-Origin: ' . $origin);
    }
    // ... resto dos headers
}
```

**Status:** ✅ **JÁ ESTÁ CORRETO**

---

## ✅ ESPECIFICAÇÃO PARA JAVASCRIPT

### **Como JavaScript deve usar:**

**IMPORTANTE:** JavaScript **NÃO tem acesso direto** às variáveis de ambiente do Docker (elas são do servidor). Portanto:

### **Opção 1: Caminhos Relativos (RECOMENDADO)**

Usar caminhos relativos baseados na URL atual da página:

```javascript
// Se a página está em: https://segurosimediato-dev.webflow.io/
// E o PHP está em: https://dev.bssegurosimediato.com.br/

// ❌ ERRADO: Caminho relativo não funciona (resolveria para webflow.io)
fetch('./debug_logger_db.php', {...}) // ❌ Vai para webflow.io

// ✅ CORRETO: Usar URL absoluta baseada no domínio do servidor
const serverBaseUrl = 'https://dev.bssegurosimediato.com.br';
fetch(`${serverBaseUrl}/debug_logger_db.php`, {...})
```

### **Opção 2: Meta Tag com Variável de Ambiente (RECOMENDADO)**

PHP gera uma meta tag com a URL base:

```php
<!-- No início do HTML (gerado por PHP ou no Webflow) -->
<meta name="app-base-url" content="<?php echo $_ENV['APP_BASE_URL']; ?>">
```

JavaScript lê a meta tag:

```javascript
// Ler URL base da meta tag
function getBaseUrl() {
    const meta = document.querySelector('meta[name="app-base-url"]');
    if (meta) {
        return meta.getAttribute('content');
    }
    // Fallback: detectar do script atual
    const scripts = document.getElementsByTagName('script');
    for (let script of scripts) {
        if (script.src && script.src.includes('bssegurosimediato.com.br')) {
            return new URL(script.src).origin;
        }
    }
    // Fallback final: usar URL padrão
    return 'https://dev.bssegurosimediato.com.br';
}

// Usar
const baseUrl = getBaseUrl();
fetch(`${baseUrl}/debug_logger_db.php`, {...})
```

### **Opção 3: Script Inline PHP (ALTERNATIVA)**

PHP gera um script inline com a variável:

```php
<!-- No início do HTML -->
<script>
    window.APP_BASE_URL = <?php echo json_encode($_ENV['APP_BASE_URL']); ?>;
</script>
```

JavaScript usa:

```javascript
const baseUrl = window.APP_BASE_URL || 'https://dev.bssegurosimediato.com.br';
fetch(`${baseUrl}/debug_logger_db.php`, {...})
```

### **O QUE NÃO DEVE SER FEITO:**

❌ **NÃO criar `config.js.php`** que gera `window.APP_CONFIG`  
❌ **NÃO criar sistema de configuração centralizado** para JavaScript  
❌ **NÃO usar `window.APP_CONFIG`** com funções helper

---

## 📋 RESUMO DA ESPECIFICAÇÃO

### **PHP:**
- ✅ Usar `$_ENV['APP_BASE_DIR']` para includes locais
- ✅ Usar `$_ENV['APP_BASE_URL']` para construir URLs (se necessário)
- ✅ Usar `$_ENV['APP_CORS_ORIGINS']` para CORS
- ✅ Arquivo `config.php` já está correto

### **JavaScript:**
- ✅ Usar meta tag com `APP_BASE_URL` (gerada por PHP)
- ✅ OU usar script inline com `window.APP_BASE_URL`
- ✅ OU usar URL absoluta baseada no domínio do servidor
- ❌ **NÃO criar** `config.js.php` ou `window.APP_CONFIG`

---

## 🔄 MUDANÇA DE AMBIENTE

### **Como funciona:**

1. **DEV:**
   - Docker: `APP_BASE_URL=https://dev.bssegurosimediato.com.br`
   - PHP: Lê `$_ENV['APP_BASE_URL']` → usa `https://dev.bssegurosimediato.com.br`
   - JavaScript: Lê meta tag → usa `https://dev.bssegurosimediato.com.br`

2. **PROD:**
   - Docker: `APP_BASE_URL=https://bssegurosimediato.com.br`
   - PHP: Lê `$_ENV['APP_BASE_URL']` → usa `https://bssegurosimediato.com.br`
   - JavaScript: Lê meta tag → usa `https://bssegurosimediato.com.br`

**Resultado:** Mudança automática apenas alterando variáveis Docker!

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **PHP:**
- [x] `config.php` lê `$_ENV['APP_BASE_DIR']` ✅
- [x] `config.php` lê `$_ENV['APP_BASE_URL']` ✅
- [x] `config.php` lê `$_ENV['APP_CORS_ORIGINS']` ✅
- [x] Arquivos PHP usam `config.php` ✅

### **JavaScript:**
- [ ] Remover `config.js.php` ❌
- [ ] Remover `window.APP_CONFIG` ❌
- [ ] Implementar leitura de meta tag `app-base-url` ⏳
- [ ] OU implementar script inline com `window.APP_BASE_URL` ⏳
- [ ] Ajustar todos os `fetch()` para usar URL base da meta tag ⏳

---

## 🎯 CONCLUSÃO

**Especificação:**
- ✅ PHP usa variáveis de ambiente diretamente (`$_ENV`)
- ✅ JavaScript lê URL base via meta tag ou script inline (gerado por PHP)
- ❌ **NÃO criar** `config.js.php` ou sistema de configuração centralizado

**Vantagens:**
- ✅ Mudança de ambiente automática (apenas variáveis Docker)
- ✅ Sem arquivos de configuração adicionais
- ✅ Simples e direto

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

