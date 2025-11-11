# ✅ SOLUÇÃO SEGURA - JAVASCRIPT COM VARIÁVEIS DE AMBIENTE

**Data:** 08/11/2025  
**Status:** ✅ **SOLUÇÃO DEFINITIVA E SEGURA**

---

## 🎯 PROBLEMA IDENTIFICADO

**Problema:** Como o JavaScript sabe onde está `config_env.js.php` para carregá-lo?

**Ciclo vicioso:**
1. JavaScript precisa carregar `config_env.js.php` para saber a URL base
2. Mas precisa saber a URL base para carregar `config_env.js.php`
3. ❌ **Problema circular!**

---

## ✅ SOLUÇÃO SEGURA

### **Estratégia: Detecção Automática + Variáveis de Ambiente**

**Como funciona:**
1. **JavaScript detecta automaticamente** a URL base do script atual (para encontrar `config_env.js.php`)
2. **Carrega `config_env.js.php`** dinamicamente
3. **`config_env.js.php` expõe variáveis de ambiente** do Docker
4. **JavaScript usa variáveis de ambiente** para todas as outras chamadas

---

## 🔧 IMPLEMENTAÇÃO

### **1. Criar função de carregamento dinâmico**

**Adicionar no início de cada arquivo JavaScript:**

```javascript
/**
 * Carregar configuração de variáveis de ambiente do Docker
 * Detecta automaticamente a URL base e carrega config_env.js.php
 */
(function() {
    'use strict';
    
    // Evitar carregar múltiplas vezes
    if (window.APP_ENV_LOADED) {
        return;
    }
    window.APP_ENV_LOADED = true;
    
    // Função para detectar URL base do servidor
    function detectServerBaseUrl() {
        // 1. Tentar detectar do script atual
        const scripts = document.getElementsByTagName('script');
        for (let script of scripts) {
            if (script.src && script.src.includes('bssegurosimediato.com.br')) {
                try {
                    const url = new URL(script.src);
                    return url.origin; // https://dev.bssegurosimediato.com.br
                } catch (e) {
                    // Continuar tentando
                }
            }
        }
        
        // 2. Se estiver no mesmo domínio, usar origin
        if (window.location.hostname.includes('bssegurosimediato.com.br')) {
            return window.location.origin;
        }
        
        // 3. Detectar ambiente pelo hostname
        const hostname = window.location.hostname;
        if (hostname.includes('webflow.io') || 
            hostname.includes('localhost') || 
            hostname.includes('127.0.0.1')) {
            return 'https://dev.bssegurosimediato.com.br';
        }
        
        // 4. Fallback: produção
        return 'https://bssegurosimediato.com.br';
    }
    
    // Detectar URL base
    const serverBaseUrl = detectServerBaseUrl();
    
    // Carregar config_env.js.php dinamicamente
    const script = document.createElement('script');
    script.src = serverBaseUrl + '/config_env.js.php';
    script.async = false; // Carregar de forma síncrona (importante!)
    
    // Aguardar carregamento antes de continuar
    script.onload = function() {
        console.log('[ENV] ✅ Configuração de ambiente carregada:', {
            baseUrl: window.APP_ENV?.baseUrl,
            environment: window.APP_ENV?.environment
        });
        
        // Disparar evento para outros scripts saberem que está pronto
        window.dispatchEvent(new CustomEvent('appEnvLoaded', {
            detail: window.APP_ENV
        }));
    };
    
    script.onerror = function() {
        console.error('[ENV] ❌ Erro ao carregar config_env.js.php');
        // Fallback: usar detecção automática
        window.APP_ENV = {
            baseUrl: serverBaseUrl,
            environment: serverBaseUrl.includes('dev.') ? 'development' : 'production',
            getEndpointUrl: function(endpoint) {
                return this.baseUrl + '/' + endpoint;
            },
            isDev: function() {
                return this.environment === 'development';
            },
            isProd: function() {
                return this.environment === 'production';
            }
        };
    };
    
    // Inserir no head
    document.head.appendChild(script);
})();
```

---

### **2. Criar `config_env.js.php` no servidor**

**Arquivo:** `/opt/webhooks-server/dev/root/config_env.js.php`

```php
<?php
/**
 * CONFIGURAÇÃO DE VARIÁVEIS DE AMBIENTE PARA JAVASCRIPT
 * 
 * Este arquivo lê as variáveis de ambiente do Docker e as expõe para JavaScript.
 * 
 * Carregado dinamicamente pelo JavaScript que detecta automaticamente a URL base.
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
            // Remover barra inicial se existir
            endpoint = endpoint.replace(/^\//, '');
            return this.baseUrl + '/' + endpoint;
        },
        
        // Função helper para obter URL completa de um script
        getScriptUrl: function(script) {
            script = script.replace(/^\//, '');
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
    
    console.log('[ENV] ✅ Variáveis de ambiente carregadas do Docker:', {
        baseUrl: window.APP_ENV.baseUrl,
        environment: window.APP_ENV.environment,
        baseDir: window.APP_ENV.baseDir
    });
})();
```

---

### **3. Usar nos arquivos JavaScript**

**Aguardar carregamento antes de usar:**

```javascript
// Aguardar carregamento do APP_ENV
function waitForAppEnv() {
    return new Promise((resolve) => {
        if (window.APP_ENV) {
            resolve(window.APP_ENV);
            return;
        }
        
        window.addEventListener('appEnvLoaded', () => {
            resolve(window.APP_ENV);
        }, { once: true });
    });
}

// Usar em funções assíncronas
async function logToServer(data) {
    await waitForAppEnv();
    
    fetch(window.APP_ENV.getEndpointUrl('debug_logger_db.php'), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
}

// OU usar diretamente (se já carregou)
if (window.APP_ENV) {
    fetch(window.APP_ENV.getEndpointUrl('debug_logger_db.php'), {...});
}
```

---

## 🔄 FLUXO COMPLETO

```
1. JavaScript é carregado no browser
   ↓
2. Função detectServerBaseUrl() executa
   ↓
3. Detecta URL base do script atual (ex: https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js)
   ↓
4. Extrai origin: https://dev.bssegurosimediato.com.br
   ↓
5. Carrega dinamicamente: https://dev.bssegurosimediato.com.br/config_env.js.php
   ↓
6. config_env.js.php lê $_ENV['APP_BASE_URL'] e $_ENV['PHP_ENV'] do Docker
   ↓
7. config_env.js.php expõe window.APP_ENV com variáveis de ambiente
   ↓
8. JavaScript usa window.APP_ENV para todas as chamadas
```

---

## ✅ VANTAGENS

1. ✅ **Seguro:** JavaScript detecta automaticamente onde está o servidor
2. ✅ **Usa variáveis Docker:** Depois de carregar, usa variáveis de ambiente
3. ✅ **Sabe dev/prod:** `window.APP_ENV.environment` tem o valor correto
4. ✅ **Fallback:** Se config_env.js.php falhar, usa detecção automática
5. ✅ **Zero configuração:** Não precisa modificar HTML

---

## 📋 RESUMO

| Aspecto | Solução |
|---------|---------|
| **Como encontrar config_env.js.php** | ✅ Detecção automática do script atual |
| **Como saber dev/prod** | ✅ Variáveis de ambiente do Docker (`window.APP_ENV.environment`) |
| **Como usar URLs** | ✅ `window.APP_ENV.getEndpointUrl('arquivo.php')` |
| **Segurança** | ✅ Funciona em qualquer contexto, com fallback |

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

