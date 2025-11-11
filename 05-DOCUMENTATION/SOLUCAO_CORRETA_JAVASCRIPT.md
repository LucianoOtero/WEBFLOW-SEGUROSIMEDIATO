# ✅ SOLUÇÃO CORRETA - JAVASCRIPT COM VARIÁVEIS DE AMBIENTE

**Data:** 08/11/2025  
**Status:** ✅ **SOLUÇÃO DEFINITIVA**

---

## 🎯 PROBLEMA IDENTIFICADO

A detecção automática não é confiável porque:
- ❌ Não sabemos se estamos em produção ou dev
- ❌ Pode falhar em diferentes contextos
- ❌ Não usa as variáveis de ambiente do Docker

---

## ✅ SOLUÇÃO CORRETA

**Usar variáveis de ambiente do Docker via PHP para JavaScript**

### **Como funciona:**

1. **PHP lê variáveis de ambiente do Docker** (`$_ENV['APP_BASE_URL']`)
2. **PHP gera JavaScript** com essas variáveis
3. **JavaScript usa as variáveis** diretamente

---

## 🔧 IMPLEMENTAÇÃO

### **Opção 1: Arquivo PHP que gera JavaScript (RECOMENDADO)**

**Criar arquivo:** `config_env.js.php`

```php
<?php
/**
 * CONFIGURAÇÃO DE VARIÁVEIS DE AMBIENTE PARA JAVASCRIPT
 * 
 * Este arquivo lê as variáveis de ambiente do Docker e as expõe para JavaScript.
 * 
 * Uso no HTML:
 *   <script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
 */

header('Content-Type: application/javascript');

// Ler variáveis de ambiente do Docker
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
$base_dir = $_ENV['APP_BASE_DIR'] ?? '/var/www/html/dev/root';
$environment = $_ENV['PHP_ENV'] ?? 'development';

// Escapar para JavaScript
$js_base_url = json_encode($base_url, JSON_UNESCAPED_SLASHES);
$js_base_dir = json_encode($base_dir, JSON_UNESCAPED_SLASHES);
$js_environment = json_encode($environment, JSON_UNESCAPED_SLASHES);

// Gerar JavaScript
?>
(function() {
    'use strict';
    
    // Variáveis de ambiente do Docker (lidas via PHP)
    window.APP_ENV = {
        baseUrl: <?php echo $js_base_url; ?>,
        baseDir: <?php echo $js_base_dir; ?>,
        environment: <?php echo $js_environment; ?>,
        
        // Função helper para obter URL completa de um endpoint
        getEndpointUrl: function(endpoint) {
            return this.baseUrl + '/' + endpoint;
        },
        
        // Função helper para obter URL completa de um script
        getScriptUrl: function(script) {
            return this.baseUrl + '/' + script;
        },
        
        // Verificar se está em desenvolvimento
        isDev: function() {
            return this.environment === 'development';
        },
        
        // Verificar se está em produção
        isProd: function() {
            return this.environment === 'production';
        }
    };
    
    console.log('[ENV] ✅ Variáveis de ambiente carregadas:', {
        baseUrl: window.APP_ENV.baseUrl,
        environment: window.APP_ENV.environment
    });
})();
```

**Uso no JavaScript:**
```javascript
// Carregar config_env.js.php ANTES dos outros scripts
// <script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>

// Usar em todos os fetch()
fetch(window.APP_ENV.getEndpointUrl('debug_logger_db.php'), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
});

// Verificar ambiente
if (window.APP_ENV.isDev()) {
    console.log('Ambiente de desenvolvimento');
}
```

---

### **Opção 2: Script Inline no HTML (se tiver acesso ao HTML)**

**Se você tiver um arquivo PHP que gera HTML:**

```php
<?php
// Ler variáveis de ambiente
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
$environment = $_ENV['PHP_ENV'] ?? 'development';
?>
<!DOCTYPE html>
<html>
<head>
    <!-- ✅ Script inline com variáveis de ambiente -->
    <script>
        window.APP_ENV = {
            baseUrl: <?php echo json_encode($base_url); ?>,
            environment: <?php echo json_encode($environment); ?>,
            getEndpointUrl: function(endpoint) {
                return this.baseUrl + '/' + endpoint;
            },
            isDev: function() {
                return this.environment === 'development';
            }
        };
    </script>
</head>
<body>
    <!-- Seus scripts aqui -->
</body>
</html>
```

---

### **Opção 3: Meta Tag (alternativa)**

```php
<?php
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
$environment = $_ENV['PHP_ENV'] ?? 'development';
?>
<!DOCTYPE html>
<html>
<head>
    <!-- ✅ Meta tags com variáveis de ambiente -->
    <meta name="app-base-url" content="<?php echo htmlspecialchars($base_url); ?>">
    <meta name="app-environment" content="<?php echo htmlspecialchars($environment); ?>">
</head>
<body>
    <script>
        // ✅ JavaScript lê meta tags
        function getServerBaseUrl() {
            const meta = document.querySelector('meta[name="app-base-url"]');
            return meta ? meta.getAttribute('content') : 'https://dev.bssegurosimediato.com.br';
        }
        
        function getEnvironment() {
            const meta = document.querySelector('meta[name="app-environment"]');
            return meta ? meta.getAttribute('content') : 'development';
        }
        
        const baseUrl = getServerBaseUrl();
        const environment = getEnvironment();
        
        fetch(`${baseUrl}/debug_logger_db.php`, {...});
    </script>
</body>
</html>
```

---

## 🎯 RECOMENDAÇÃO FINAL

### **Solução Recomendada: `config_env.js.php`**

**Vantagens:**
- ✅ Usa variáveis de ambiente do Docker diretamente
- ✅ Sabemos exatamente se está em dev ou prod
- ✅ Não precisa modificar HTML
- ✅ Simples e direto
- ✅ Funciona automaticamente em dev e prod

**Como usar:**
1. Criar arquivo `config_env.js.php` no servidor
2. Carregar ANTES dos outros scripts JavaScript:
   ```html
   <script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
   <script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"></script>
   ```
3. Usar `window.APP_ENV` em todos os fetch()

---

## 📋 COMPARAÇÃO

| Solução | Usa Variáveis Docker | Sabe Dev/Prod | Complexidade |
|---------|---------------------|---------------|--------------|
| **Detecção Automática** | ❌ Não | ❌ Não | Baixa |
| **config_env.js.php** | ✅ Sim | ✅ Sim | Baixa |
| **Script Inline** | ✅ Sim | ✅ Sim | Média |
| **Meta Tag** | ✅ Sim | ✅ Sim | Média |

---

## 🔧 IMPLEMENTAÇÃO PRÁTICA

### **1. Criar `config_env.js.php` no servidor:**

```bash
# No servidor
/opt/webhooks-server/dev/root/config_env.js.php
/opt/webhooks-server/prod/root/config_env.js.php
```

### **2. Carregar no Webflow (Footer Code):**

```html
<!-- Carregar ANTES dos outros scripts -->
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"></script>
```

### **3. Usar nos arquivos JavaScript:**

```javascript
// Antes (hardcoded):
fetch('https://dev.bssegurosimediato.com.br/debug_logger_db.php', {...})

// Depois (usando variáveis de ambiente):
fetch(window.APP_ENV.getEndpointUrl('debug_logger_db.php'), {...})

// Verificar ambiente:
if (window.APP_ENV.isDev()) {
    console.log('Desenvolvimento');
}
```

---

## ✅ CONCLUSÃO

**Solução correta:**
- ✅ Criar `config_env.js.php` que lê `$_ENV` do Docker
- ✅ Expor `window.APP_ENV` para JavaScript
- ✅ JavaScript usa `window.APP_ENV.baseUrl` e `window.APP_ENV.environment`
- ✅ Sabemos exatamente se está em dev ou prod
- ✅ Usa variáveis de ambiente do Docker diretamente

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

