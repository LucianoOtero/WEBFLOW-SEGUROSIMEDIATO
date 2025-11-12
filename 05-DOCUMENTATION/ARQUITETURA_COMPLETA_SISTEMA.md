# 🏗️ ARQUITETURA COMPLETA DO SISTEMA

**Data:** 08/11/2025  
**Última Atualização:** 11/11/2025  
**Status:** ✅ **DOCUMENTAÇÃO COMPLETA**

---

## 🖥️ SERVIDORES

### **Servidor DEV:**
- **IP:** `65.108.156.14`
- **Domínio:** `dev.bssegurosimediato.com.br`
- **URL Base:** `https://dev.bssegurosimediato.com.br`

### **Servidor PROD:**
- **IP:** `157.180.36.223`
- **Domínio:** `prod.bssegurosimediato.com.br`
- **URL Base:** `https://prod.bssegurosimediato.com.br`

📖 **Para detalhes completos dos servidores, consulte:** `ARQUITETURA_SERVIDORES.md`

---

## 🎯 VISÃO GERAL

Este documento explica **passo a passo** como o sistema funciona, desde o carregamento inicial até a execução completa.

---

## 📋 PASSO 1: WEBFLOW CARREGA O FOOTER CODE

### **Onde:**
- **Webflow Dashboard** → **Site Settings** → **Custom Code** → **Footer Code**

### **O que está lá:**
```html
<!-- jQuery (carrega primeiro) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- jQuery Mask (carrega após jQuery) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"></script>

<!-- SweetAlert2 (pode ter defer) -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.0/dist/sweetalert2.all.min.js" defer></script>

<!-- ⭐ SCRIPT PRINCIPAL (carrega por último) -->
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" defer></script>
```

### **Ordem de carregamento:**
1. ✅ jQuery carrega primeiro (síncrono)
2. ✅ jQuery Mask carrega segundo (síncrono)
3. ✅ SweetAlert2 carrega terceiro (defer)
4. ✅ **FooterCodeSiteDefinitivoCompleto.js** carrega quarto (defer)

---

## 📋 PASSO 2: FooterCodeSiteDefinitivoCompleto.js É CARREGADO

### **Quando:**
- Quando o Webflow renderiza a página
- O script é carregado via `<script src="...">` no Footer Code
- Com `defer`, executa após o DOM estar pronto

### **O que acontece:**
1. **Browser faz requisição HTTP:**
   ```
   GET https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js
   ```

2. **Nginx recebe requisição:**
   - Verifica que é arquivo `.js`
   - Serve o arquivo estático do diretório `/var/www/html/dev/root/`

3. **Browser recebe o JavaScript:**
   - Executa o código imediatamente (com `defer`, após DOM)

---

## 📋 PASSO 3: FooterCodeSiteDefinitivoCompleto.js EXECUTA

### **Estrutura do arquivo:**

```javascript
(function() {
    'use strict';
    
    try {
        // ======================
        // PARTE 1: FOOTER CODE UTILS
        // ======================
        // Define funções utilitárias:
        // - window.onlyDigits()
        // - window.validarCPF()
        // - window.validarPlaca()
        // - window.logUnified()
        // etc.
        
        // ======================
        // PARTE 2: CÓDIGO PRINCIPAL
        // ======================
        // Aguarda DOMContentLoaded
        // Inicializa validações
        // Configura handlers
        
        // ======================
        // PARTE 3: CARREGAMENTO DINÂMICO
        // ======================
        // Carrega outros scripts:
        // - webflow_injection_limpo.js
        // - MODAL_WHATSAPP_DEFINITIVO.js
    } catch (error) {
        console.error('Erro no FooterCodeSiteDefinitivoCompleto.js:', error);
    }
})();
```

### **O que acontece na execução:**

1. **Define funções utilitárias** (Parte 1)
   - Expõe funções via `window.functionName`
   - Define constantes globais

2. **Aguarda DOM estar pronto**
   - Usa `DOMContentLoaded` ou `jQuery.ready()`

3. **Inicializa validações**
   - Configura máscaras de input
   - Configura validações de formulário

4. **Carrega scripts dinamicamente** (quando necessário)
   - `webflow_injection_limpo.js` (RPA)
   - `MODAL_WHATSAPP_DEFINITIVO.js` (Modal WhatsApp)

---

## 📋 PASSO 4: FooterCodeSiteDefinitivoCompleto.js CARREGA OUTROS SCRIPTS

### **4.1. Carregamento de webflow_injection_limpo.js**

**Quando:** Quando RPA é necessário (ex: formulário é submetido)

**Código atual (linha ~1232):**
```javascript
function loadRPAScript() {
    return new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = 'https://mdmidia.com.br/webflow_injection_limpo.js'; // ❌ HARDCODED
        script.onload = () => resolve();
        script.onerror = () => reject();
        document.head.appendChild(script);
    });
}
```

**Problema:**
- ❌ URL hardcoded: `https://mdmidia.com.br/webflow_injection_limpo.js`
- ❌ Não usa variáveis de ambiente
- ❌ Não sabe se está em dev ou prod

---

### **4.2. Carregamento de MODAL_WHATSAPP_DEFINITIVO.js**

**Quando:** Quando modal WhatsApp é necessário

**Código atual (linha ~1295):**
```javascript
function loadWhatsAppModal() {
    const script = document.createElement('script');
    script.src = 'https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js?v=24&force=' + Math.random(); // ❌ HARDCODED
    script.onload = function() {
        window.whatsappModalLoaded = true;
    };
    document.head.appendChild(script);
}
```

**Problema:**
- ❌ URL hardcoded: `https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js`
- ❌ Não usa variáveis de ambiente
- ❌ Não sabe se está em dev ou prod

---

## 📋 PASSO 5: SCRIPTS CARREGADOS EXECUTAM

### **5.1. webflow_injection_limpo.js executa**

**O que faz:**
- Inicializa sistema RPA
- Configura interceptação de formulários
- Configura modal de progresso

**Problema:**
- ❌ Tem URLs hardcoded para endpoints PHP
- ❌ Não usa variáveis de ambiente

---

### **5.2. MODAL_WHATSAPP_DEFINITIVO.js executa**

**O que faz:**
- Inicializa modal WhatsApp
- Configura handlers de click
- Configura integração com formulários

**Problema:**
- ❌ Tem URLs hardcoded para endpoints PHP
- ❌ Não usa variáveis de ambiente

---

## 🔄 FLUXO COMPLETO (ATUAL)

```
1. Webflow renderiza página
   ↓
2. Footer Code é executado
   ↓
3. FooterCodeSiteDefinitivoCompleto.js é carregado
   ↓
4. FooterCodeSiteDefinitivoCompleto.js executa:
   - Define funções utilitárias
   - Aguarda DOM
   - Inicializa validações
   ↓
5. Quando necessário, carrega dinamicamente:
   - webflow_injection_limpo.js (URL hardcoded ❌)
   - MODAL_WHATSAPP_DEFINITIVO.js (URL hardcoded ❌)
   ↓
6. Scripts carregados executam:
   - Fazem fetch() para endpoints PHP (URLs hardcoded ❌)
   - Não sabem se estão em dev ou prod ❌
```

---

## ❌ PROBLEMAS IDENTIFICADOS

### **Problema 1: URLs Hardcoded**
- ❌ `https://mdmidia.com.br/webflow_injection_limpo.js`
- ❌ `https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js`
- ❌ `https://bpsegurosimediato.com.br/logging_system/debug_logger_db.php`

### **Problema 2: Não Usa Variáveis de Ambiente**
- ❌ JavaScript não tem acesso a `$_ENV['APP_BASE_URL']`
- ❌ JavaScript não sabe se está em dev ou prod

### **Problema 3: Dependência Circular**
- ❌ Para carregar `config_env.js.php`, precisa saber a URL base
- ❌ Mas a URL base vem de `config_env.js.php`
- ❌ **Ciclo vicioso!**

---

## ✅ SOLUÇÃO PROPOSTA

### **Estratégia: Detecção Automática + Variáveis de Ambiente**

**Como funciona:**

1. **FooterCodeSiteDefinitivoCompleto.js detecta automaticamente sua própria URL**
   - Se está em: `https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js`
   - Extrai: `https://dev.bssegurosimediato.com.br`

2. **Carrega `config_env.js.php` dinamicamente**
   - Usa URL detectada: `https://dev.bssegurosimediato.com.br/config_env.js.php`

3. **`config_env.js.php` lê variáveis de ambiente do Docker**
   - Lê `$_ENV['APP_BASE_URL']` e `$_ENV['PHP_ENV']`
   - Expõe `window.APP_ENV` para JavaScript

4. **JavaScript usa `window.APP_ENV` para todas as chamadas**
   - Carregar outros scripts: `window.APP_ENV.getScriptUrl('webflow_injection_limpo.js')`
   - Chamar endpoints: `window.APP_ENV.getEndpointUrl('debug_logger_db.php')`
   - Verificar ambiente: `window.APP_ENV.isDev()`

---

## 🔄 FLUXO COMPLETO (PROPOSTO)

```
1. Webflow renderiza página
   ↓
2. Footer Code é executado
   ↓
3. FooterCodeSiteDefinitivoCompleto.js é carregado
   ↓
4. FooterCodeSiteDefinitivoCompleto.js executa:
   a. Detecta sua própria URL automaticamente
      Ex: https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js
      Extrai: https://dev.bssegurosimediato.com.br
   ↓
   b. Carrega config_env.js.php dinamicamente
      URL: https://dev.bssegurosimediato.com.br/config_env.js.php
   ↓
   c. config_env.js.php lê $_ENV do Docker
      - APP_BASE_URL=https://dev.bssegurosimediato.com.br
      - PHP_ENV=development
      Expõe: window.APP_ENV
   ↓
   d. Define funções utilitárias
   ↓
   e. Aguarda DOM
   ↓
   f. Inicializa validações
   ↓
5. Quando necessário, carrega outros scripts:
   - webflow_injection_limpo.js
     URL: window.APP_ENV.getScriptUrl('webflow_injection_limpo.js') ✅
   - MODAL_WHATSAPP_DEFINITIVO.js
     URL: window.APP_ENV.getScriptUrl('MODAL_WHATSAPP_DEFINITIVO.js') ✅
   ↓
6. Scripts carregados executam:
   - Fazem fetch() para endpoints PHP
     URL: window.APP_ENV.getEndpointUrl('debug_logger_db.php') ✅
   - Sabem se estão em dev ou prod
     window.APP_ENV.isDev() ✅
```

---

## ✅ VANTAGENS DA SOLUÇÃO

1. ✅ **Seguro:** Detecta automaticamente onde está o servidor
2. ✅ **Usa variáveis Docker:** Depois de carregar, usa variáveis de ambiente
3. ✅ **Sabe dev/prod:** `window.APP_ENV.environment` tem o valor correto
4. ✅ **Zero configuração:** Não precisa modificar HTML do Webflow
5. ✅ **Funciona sempre:** Independente de onde o script é carregado

---

## 📋 RESUMO

| Aspecto | Atual | Proposto |
|---------|-------|----------|
| **URLs** | ❌ Hardcoded | ✅ Variáveis de ambiente |
| **Dev/Prod** | ❌ Não sabe | ✅ `window.APP_ENV.environment` |
| **Carregar scripts** | ❌ URLs hardcoded | ✅ `window.APP_ENV.getScriptUrl()` |
| **Chamar endpoints** | ❌ URLs hardcoded | ✅ `window.APP_ENV.getEndpointUrl()` |
| **Configuração** | ❌ Múltiplas URLs | ✅ Uma única detecção automática |

---

---

## 📝 VARIÁVEIS DE AMBIENTE - LOG_DIR

### **O que é LOG_DIR?**

`LOG_DIR` é a variável de ambiente que define o diretório onde todos os arquivos de log do sistema são armazenados.

### **Onde é Definida?**

**Localização:** `/etc/php/8.3/fpm/pool.d/www.conf` (no servidor)

**Variável:**
```
env[LOG_DIR] = /var/log/webflow-segurosimediato
```

**Como é usada:**
- Carregada automaticamente em todas as requisições PHP via PHP-FPM
- Acessível via `$_ENV['LOG_DIR']` em qualquer script PHP
- Se não estiver definida, o código usa fallback: `getBaseDir() . '/logs'`

### **Diretório Padrão**

**DEV:** `/var/log/webflow-segurosimediato`  
**PROD:** `/var/log/webflow-segurosimediato` (a definir quando procedimento for oficializado)

**Permissões:**
- Proprietário: `www-data:www-data`
- Permissões: `0755` (rwxr-xr-x)
- Gravável pelo PHP-FPM: ✅ Sim

---

## 📋 SISTEMA DE LOGGING

### **Arquivos de Log do Sistema**

Todos os arquivos de log são armazenados no diretório definido por `LOG_DIR` e respeitam a variável de ambiente usando o padrão:
```php
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
```

#### **1. flyingdonkeys_dev.txt**
- **Origem:** `add_flyingdonkeys.php`
- **Quando:** Requisições webhook em ambiente DEV
- **Formato:** JSON com prefixo `[DEV-FLYINGDONKEYS]`
- **Conteúdo:** Eventos do webhook FlyingDonkeys (EspoCRM)
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)
- **Caminho:** `{LOG_DIR}/flyingdonkeys_dev.txt`

#### **2. flyingdonkeys_prod.txt**
- **Origem:** `add_flyingdonkeys.php`
- **Quando:** Requisições webhook em ambiente PROD
- **Formato:** JSON com prefixo `[PROD-FLYINGDONKEYS]`
- **Conteúdo:** Eventos do webhook FlyingDonkeys (EspoCRM)
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)
- **Caminho:** `{LOG_DIR}/flyingdonkeys_prod.txt`

#### **3. webhook_octadesk_prod.txt**
- **Origem:** `add_webflow_octa.php`
- **Quando:** Requisições webhook OctaDesk
- **Formato:** Texto com prefixo `[OCTADESK-PROD]`
- **Conteúdo:** Eventos do webhook OctaDesk (WhatsApp)
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)
- **Caminho:** `{LOG_DIR}/webhook_octadesk_prod.txt`

#### **4. professional_logger_errors.txt**
- **Origem:** `ProfessionalLogger.php`
- **Quando:** Erros ao inserir logs no banco de dados
- **Formato:** Texto com timestamp
- **Conteúdo:** Erros críticos do sistema de logging profissional
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)
- **Caminho:** `{LOG_DIR}/professional_logger_errors.txt`

#### **5. log_endpoint_debug.txt**
- **Origem:** `log_endpoint.php`
- **Quando:** Debugging do endpoint de logging
- **Formato:** Texto com timestamp e informações de memória
- **Conteúdo:** Logs de debug do endpoint de logging
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)
- **Caminho:** `{LOG_DIR}/log_endpoint_debug.txt`

### **Verificação de Conformidade**

✅ **Todos os arquivos de log respeitam `LOG_DIR`** usando o padrão:
```php
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
```

**Arquivos verificados:**
- ✅ `add_flyingdonkeys.php`
- ✅ `add_webflow_octa.php`
- ✅ `ProfessionalLogger.php`
- ✅ `log_endpoint.php`

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 12/11/2025  
**Versão:** 2.0

