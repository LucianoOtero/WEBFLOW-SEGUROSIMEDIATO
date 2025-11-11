# ✅ SOLUÇÃO - JAVASCRIPT CHAMANDO OUTRO JAVASCRIPT

**Data:** 08/11/2025  
**Status:** ✅ **SOLUÇÃO COMPLETA**

---

## 🎯 PROBLEMA IDENTIFICADO

**Cenário:** Um arquivo JavaScript precisa carregar outro arquivo JavaScript dinamicamente.

**Exemplo:**
- `FooterCodeSiteDefinitivoCompleto.js` carrega `webflow_injection_limpo.js`
- `FooterCodeSiteDefinitivoCompleto.js` carrega `MODAL_WHATSAPP_DEFINITIVO.js`

**Problema:** Como saber a URL base para carregar esses scripts?

---

## ✅ SOLUÇÃO

### **Estratégia: Aguardar `window.APP_ENV` antes de carregar outros scripts**

**Como funciona:**
1. **Primeiro script carrega `config_env.js.php`** (detecção automática)
2. **Aguarda `window.APP_ENV` estar disponível**
3. **Usa `window.APP_ENV.getScriptUrl()`** para carregar outros scripts

---

## 🔧 IMPLEMENTAÇÃO

### **1. Função Helper para Carregar Scripts**

**Adicionar função reutilizável:**

```javascript
/**
 * Carregar script JavaScript dinamicamente usando variáveis de ambiente
 * @param {string} scriptName - Nome do script (ex: 'webflow_injection_limpo.js')
 * @param {Object} options - Opções de carregamento
 * @returns {Promise} Promise que resolve quando o script é carregado
 */
function loadScriptWithEnv(scriptName, options = {}) {
    return new Promise((resolve, reject) => {
        // Aguardar window.APP_ENV estar disponível
        function waitForAppEnv() {
            return new Promise((envResolve) => {
                if (window.APP_ENV) {
                    envResolve(window.APP_ENV);
                    return;
                }
                
                // Aguardar evento de carregamento
                window.addEventListener('appEnvLoaded', () => {
                    envResolve(window.APP_ENV);
                }, { once: true });
                
                // Timeout de segurança (5 segundos)
                setTimeout(() => {
                    console.warn('[SCRIPT] Timeout aguardando APP_ENV, usando fallback');
                    envResolve(null);
                }, 5000);
            });
        }
        
        // Aguardar APP_ENV e então carregar script
        waitForAppEnv().then((appEnv) => {
            let scriptUrl;
            
            if (appEnv && appEnv.getScriptUrl) {
                // Usar variáveis de ambiente
                scriptUrl = appEnv.getScriptUrl(scriptName);
                console.log('[SCRIPT] Carregando via APP_ENV:', scriptUrl);
            } else {
                // Fallback: detecção automática
                const scripts = document.getElementsByTagName('script');
                let baseUrl = 'https://dev.bssegurosimediato.com.br';
                
                for (let script of scripts) {
                    if (script.src && script.src.includes('bssegurosimediato.com.br')) {
                        try {
                            baseUrl = new URL(script.src).origin;
                            break;
                        } catch (e) {
                            // Continuar
                        }
                    }
                }
                
                scriptUrl = baseUrl + '/' + scriptName.replace(/^\//, '');
                console.warn('[SCRIPT] Usando fallback:', scriptUrl);
            }
            
            // Verificar se script já foi carregado
            const existingScript = document.querySelector(`script[src="${scriptUrl}"]`);
            if (existingScript) {
                console.log('[SCRIPT] Script já carregado:', scriptUrl);
                resolve();
                return;
            }
            
            // Criar elemento script
            const script = document.createElement('script');
            script.src = scriptUrl;
            script.async = options.async !== false; // Padrão: async
            script.defer = options.defer || false;
            
            // Adicionar query params se especificado
            if (options.queryParams) {
                const params = new URLSearchParams(options.queryParams);
                script.src += '?' + params.toString();
            }
            
            // Callbacks
            script.onload = () => {
                console.log('[SCRIPT] ✅ Carregado com sucesso:', scriptUrl);
                if (options.onLoad) {
                    options.onLoad();
                }
                resolve();
            };
            
            script.onerror = () => {
                console.error('[SCRIPT] ❌ Erro ao carregar:', scriptUrl);
                if (options.onError) {
                    options.onError();
                }
                reject(new Error(`Falha ao carregar script: ${scriptUrl}`));
            };
            
            // Inserir no head
            document.head.appendChild(script);
        });
    });
}
```

---

### **2. Exemplo de Uso - Carregar webflow_injection_limpo.js**

**Antes (hardcoded):**
```javascript
const script = document.createElement('script');
script.src = 'https://mdmidia.com.br/webflow_injection_limpo.js';
script.onload = () => {
    window.logInfo('RPA', '✅ Script RPA carregado com sucesso');
    resolve();
};
script.onerror = () => {
    window.logError('RPA', '❌ Erro ao carregar script RPA');
    reject(new Error('Falha ao carregar script RPA'));
};
document.head.appendChild(script);
```

**Depois (usando variáveis de ambiente):**
```javascript
loadScriptWithEnv('webflow_injection_limpo.js', {
    onLoad: () => {
        window.logInfo('RPA', '✅ Script RPA carregado com sucesso');
    },
    onError: () => {
        window.logError('RPA', '❌ Erro ao carregar script RPA');
    }
})
.then(() => {
    resolve();
})
.catch((error) => {
    reject(error);
});
```

---

### **3. Exemplo de Uso - Carregar MODAL_WHATSAPP_DEFINITIVO.js**

**Antes (hardcoded):**
```javascript
script.src = 'https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js?v=24&force=' + Math.random();
script.onload = function() {
    window.whatsappModalLoaded = true;
    window.logInfo('MODAL', '✅ Modal carregado com sucesso');
};
script.onerror = function() {
    window.logError('MODAL', '❌ Erro ao carregar modal');
};
document.head.appendChild(script);
```

**Depois (usando variáveis de ambiente):**
```javascript
loadScriptWithEnv('MODAL_WHATSAPP_DEFINITIVO.js', {
    queryParams: {
        v: '24',
        force: Math.random()
    },
    onLoad: () => {
        window.whatsappModalLoaded = true;
        window.logInfo('MODAL', '✅ Modal carregado com sucesso');
    },
    onError: () => {
        window.logError('MODAL', '❌ Erro ao carregar modal');
    }
});
```

---

### **4. Ordem de Carregamento Garantida**

**No início do arquivo principal (FooterCodeSiteDefinitivoCompleto.js):**

```javascript
(function() {
    'use strict';
    
    // 1. PRIMEIRO: Carregar config_env.js.php
    // (código de detecção automática e carregamento)
    
    // 2. SEGUNDO: Aguardar APP_ENV estar disponível
    window.addEventListener('appEnvLoaded', () => {
        console.log('[INIT] ✅ APP_ENV carregado, scripts podem ser carregados');
        
        // 3. TERCEIRO: Carregar outros scripts usando APP_ENV
        // Exemplo:
        loadScriptWithEnv('webflow_injection_limpo.js', {
            onLoad: () => {
                console.log('[INIT] ✅ webflow_injection_limpo.js carregado');
            }
        });
    }, { once: true });
    
    // Se APP_ENV já estiver disponível (carregado antes)
    if (window.APP_ENV) {
        window.dispatchEvent(new CustomEvent('appEnvLoaded', {
            detail: window.APP_ENV
        }));
    }
})();
```

---

## 🔄 FLUXO COMPLETO

```
1. FooterCodeSiteDefinitivoCompleto.js é carregado
   ↓
2. Detecta URL base automaticamente
   ↓
3. Carrega config_env.js.php dinamicamente
   ↓
4. config_env.js.php expõe window.APP_ENV
   ↓
5. Evento 'appEnvLoaded' é disparado
   ↓
6. FooterCodeSiteDefinitivoCompleto.js escuta o evento
   ↓
7. Usa loadScriptWithEnv() para carregar outros scripts
   ↓
8. loadScriptWithEnv() usa window.APP_ENV.getScriptUrl()
   ↓
9. Scripts são carregados com URLs corretas
```

---

## ✅ VANTAGENS

1. ✅ **Seguro:** Aguarda APP_ENV antes de carregar scripts
2. ✅ **Usa variáveis Docker:** Todos os scripts usam variáveis de ambiente
3. ✅ **Fallback:** Se APP_ENV não carregar, usa detecção automática
4. ✅ **Reutilizável:** Função `loadScriptWithEnv()` pode ser usada em qualquer lugar
5. ✅ **Ordem garantida:** Scripts são carregados na ordem correta

---

## 📋 RESUMO

| Cenário | Solução |
|---------|---------|
| **JavaScript carregando outro JavaScript** | ✅ `loadScriptWithEnv('script.js')` |
| **Aguardar APP_ENV** | ✅ Função aguarda automaticamente |
| **Usar variáveis Docker** | ✅ `window.APP_ENV.getScriptUrl()` |
| **Fallback** | ✅ Detecção automática se APP_ENV falhar |

---

## 🔧 EXEMPLO COMPLETO

```javascript
// No início do arquivo
(function() {
    'use strict';
    
    // Carregar config_env.js.php primeiro
    // ... (código de carregamento)
    
    // Função helper
    function loadScriptWithEnv(scriptName, options = {}) {
        // ... (código da função)
    }
    
    // Aguardar APP_ENV e carregar scripts
    function initScripts() {
        return Promise.all([
            loadScriptWithEnv('webflow_injection_limpo.js'),
            loadScriptWithEnv('MODAL_WHATSAPP_DEFINITIVO.js', {
                queryParams: { v: '24', force: Math.random() }
            })
        ]);
    }
    
    // Inicializar quando APP_ENV estiver pronto
    if (window.APP_ENV) {
        initScripts();
    } else {
        window.addEventListener('appEnvLoaded', initScripts, { once: true });
    }
})();
```

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

