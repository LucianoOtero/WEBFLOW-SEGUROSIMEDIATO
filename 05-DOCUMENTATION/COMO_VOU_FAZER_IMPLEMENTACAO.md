# 📋 COMO VOU FAZER A IMPLEMENTAÇÃO

**Data:** 08/11/2025  
**Status:** ✅ **PLANO DETALHADO**

---

## 🎯 OBJETIVO

Migrar todos os arquivos JavaScript para usar variáveis de ambiente do Docker, substituindo URLs hardcoded por variáveis globais simples (`window.APP_BASE_URL`, `window.APP_ENVIRONMENT`).

---

## 📋 PROCESSO COMPLETO - PASSO A PASSO

### **FASE 1: BACKUP LOCAL** ✅

**O que vou fazer:**
1. Criar diretório de backup com timestamp:
   ```
   WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/2025-11-08_MIGRACAO_VARIAVEIS_AMBIENTE_[TIMESTAMP]/
   ```

2. Fazer backup dos 3 arquivos JavaScript:
   - `FooterCodeSiteDefinitivoCompleto.js`
   - `MODAL_WHATSAPP_DEFINITIVO.js`
   - `webflow_injection_limpo.js`

3. Criar log do backup com informações:
   - Data/hora
   - Lista de arquivos backupados
   - Tamanho de cada arquivo
   - Instruções de restauração

**Resultado:**
- ✅ 3 arquivos de backup criados
- ✅ Log de backup documentado
- ✅ Pode restaurar se necessário

---

### **FASE 2: CRIAR config_env.js.php** ✅

**O que vou fazer:**

1. **Criar arquivo local:**
   - `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config_env.js.php`

2. **Conteúdo do arquivo:**
   ```php
   <?php
   header('Content-Type: application/javascript');
   
   // Ler variáveis de ambiente do Docker
   $base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
   $environment = $_ENV['PHP_ENV'] ?? 'development';
   
   // Expor como variáveis globais simples (NÃO objeto de configuração)
   ?>
   window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
   window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;
   
   // Função helper simples (opcional)
   window.getEndpointUrl = function(endpoint) {
       return window.APP_BASE_URL + '/' + endpoint.replace(/^\//, '');
   };
   ```

3. **Deploy para servidor:**
   - Criar no servidor DEV: `/opt/webhooks-server/dev/root/config_env.js.php`
   - ⚠️ **NÃO criar em PROD** - Apenas DEV por enquanto

**Resultado:**
- ✅ Arquivo PHP criado localmente
- ✅ Arquivo PHP criado no servidor
- ✅ Expõe variáveis de ambiente para JavaScript

---

### **FASE 3: MODIFICAR FooterCodeSiteDefinitivoCompleto.js** ✅

**O que vou fazer:**

1. **Adicionar função de detecção automática e carregamento de config_env.js.php** (no início do arquivo, após linha 83):
   ```javascript
   // Função para detectar URL base do servidor
   function detectServerBaseUrl() {
       const scripts = document.getElementsByTagName('script');
       for (let script of scripts) {
           if (script.src && script.src.includes('bssegurosimediato.com.br')) {
               try {
                   return new URL(script.src).origin;
               } catch (e) {}
           }
       }
       // Fallback...
   }
   
   // Carregar config_env.js.php dinamicamente
   (function() {
       if (window.APP_ENV_LOADED) return;
       window.APP_ENV_LOADED = true;
       
       const serverBaseUrl = detectServerBaseUrl();
       const script = document.createElement('script');
       script.src = serverBaseUrl + '/config_env.js.php';
       script.async = false;
       script.onload = () => {
           window.dispatchEvent(new CustomEvent('appEnvLoaded'));
       };
       document.head.appendChild(script);
   })();
   ```

2. **Substituir URLs hardcoded:**
   - Linha ~1129: `fetch('https://bpsegurosimediato.com.br/logging_system/debug_logger_db.php'` 
     → `fetch(window.APP_BASE_URL + '/debug_logger_db.php'`
   
   - Linha ~639: `fetch('https://mdmidia.com.br/cpf-validate.php'`
     → `fetch(window.APP_BASE_URL + '/cpf-validate.php'`
   
   - Linha ~698: `fetch('https://mdmidia.com.br/placa-validate.php'`
     → `fetch(window.APP_BASE_URL + '/placa-validate.php'`

3. **Modificar função loadRPAScript()** (linha ~1232):
   ```javascript
   // Antes:
   script.src = 'https://mdmidia.com.br/webflow_injection_limpo.js';
   
   // Depois:
   function loadRPAScript() {
       return new Promise((resolve, reject) => {
           // Aguardar APP_BASE_URL estar disponível
           function waitForAppEnv() {
               return new Promise((envResolve) => {
                   if (window.APP_BASE_URL) {
                       envResolve();
                       return;
                   }
                   window.addEventListener('appEnvLoaded', () => envResolve(), { once: true });
               });
           }
           
           waitForAppEnv().then(() => {
               const script = document.createElement('script');
               script.src = window.APP_BASE_URL + '/webflow_injection_limpo.js';
               script.onload = () => resolve();
               script.onerror = () => reject();
               document.head.appendChild(script);
           });
       });
   }
   ```

4. **Modificar função loadWhatsAppModal()** (linha ~1295):
   ```javascript
   // Antes:
   script.src = 'https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO_dev.js?v=24&force=' + Math.random();
   
   // Depois:
   function loadWhatsAppModal() {
       if (window.whatsappModalLoaded) return;
       
       function waitForAppEnv() {
           return new Promise((resolve) => {
               if (window.APP_BASE_URL) {
                   resolve();
                   return;
               }
               window.addEventListener('appEnvLoaded', () => resolve(), { once: true });
           });
       }
       
       waitForAppEnv().then(() => {
           const script = document.createElement('script');
           script.src = window.APP_BASE_URL + '/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random();
           script.onload = () => { window.whatsappModalLoaded = true; };
           script.onerror = () => { window.logError('MODAL', '❌ Erro ao carregar modal'); };
           document.head.appendChild(script);
       });
   }
   ```

**Resultado:**
- ✅ Função de carregamento de config_env.js.php adicionada
- ✅ 3 URLs hardcoded substituídas
- ✅ 2 funções de carregamento dinâmico modificadas
- ✅ Aguarda window.APP_BASE_URL antes de usar

---

### **FASE 4: MODIFICAR MODAL_WHATSAPP_DEFINITIVO.js** ✅

**O que vou fazer:**

1. **Reescrever função getEndpointUrl()** (linha ~152):
   ```javascript
   // Antes: Lógica complexa com URLs hardcoded
   
   // Depois:
   function getEndpointUrl(endpoint) {
       if (!window.APP_BASE_URL) {
           console.warn('[ENDPOINT] APP_BASE_URL não disponível ainda');
           return null;
       }
       
       const endpoints = {
           travelangels: '/add_travelangels.php',
           octadesk: '/add_webflow_octa.php'
       };
       
       return window.APP_BASE_URL + (endpoints[endpoint] || '/add_flyingdonkeys.php');
   }
   ```

2. **Substituir detecção de email endpoint** (linha ~727):
   ```javascript
   // Antes:
   const isDev = isDevelopmentEnvironment();
   const emailEndpoint = isDev 
       ? 'https://dev.bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint_dev.php'
       : 'https://bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint_prod.php';
   
   // Depois:
   const emailEndpoint = window.APP_BASE_URL 
       ? window.APP_BASE_URL + '/send_email_notification_endpoint.php'
       : null;
   ```

**Resultado:**
- ✅ Função getEndpointUrl() simplificada
- ✅ Email endpoint usa window.APP_BASE_URL
- ✅ Remove lógica complexa de detecção de ambiente

---

### **FASE 5: MODIFICAR webflow_injection_limpo.js** ✅

**O que vou fazer:**

1. **Substituir URL de validação de placa** (linha ~2117):
   ```javascript
   // Antes:
   const response = await fetch('https://mdmidia.com.br/placa-validate.php', {
   
   // Depois:
   const placaUrl = window.APP_BASE_URL 
       ? window.APP_BASE_URL + '/placa-validate.php'
       : 'https://mdmidia.com.br/placa-validate.php'; // Fallback
   
   const response = await fetch(placaUrl, {
   ```

2. **Verificar apiBaseUrl** (linha ~1081):
   - Se for usado para API externa RPA → **MANTER** original
   - Se for usado para endpoints PHP → **SUBSTITUIR** por `window.APP_BASE_URL`

**Resultado:**
- ✅ URL de validação de placa usa window.APP_BASE_URL
- ✅ apiBaseUrl verificado (manter se externo)

---

### **FASE 6: DEPLOY PARA SERVIDOR** ✅

**O que vou fazer:**

1. **Deploy dos arquivos JavaScript modificados:**
   - `scp` FooterCodeSiteDefinitivoCompleto.js → servidor DEV
   - `scp` MODAL_WHATSAPP_DEFINITIVO.js → servidor DEV
   - `scp` webflow_injection_limpo.js → servidor DEV

2. **Deploy do config_env.js.php:**
   - `scp` config_env.js.php → servidor DEV
   - ⚠️ **NÃO fazer deploy para PROD** - Apenas DEV por enquanto

3. **Ajustar permissões:**
   - `chmod 644` nos arquivos
   - `chown` apropriado

**Resultado:**
- ✅ Arquivos no servidor atualizados
- ✅ Permissões corretas
- ✅ Pronto para testes

---

### **FASE 7: TESTES** ✅

**O que vou fazer:**

1. **Testar carregamento de config_env.js.php:**
   ```bash
   curl https://dev.bssegurosimediato.com.br/config_env.js.php
   ```

2. **Testar se window.APP_BASE_URL está disponível:**
   - Abrir console do browser
   - Verificar `window.APP_BASE_URL`

3. **Testar carregamento de scripts:**
   - Verificar se FooterCodeSiteDefinitivoCompleto.js carrega
   - Verificar se outros scripts carregam dinamicamente

4. **Testar chamadas a endpoints:**
   - Verificar se fetch() funciona com window.APP_BASE_URL

**Resultado:**
- ✅ Todos os testes passando
- ✅ Sistema funcionando corretamente

---

## 📋 RESUMO DO PROCESSO

| Fase | Ação | Onde |
|------|------|------|
| **1. Backup** | Criar backups locais | `04-BACKUPS/` |
| **2. config_env.js.php** | Criar arquivo PHP | Local e servidor |
| **3. FooterCodeSiteDefinitivoCompleto.js** | Modificar | Local (`02-DEVELOPMENT/`) |
| **4. MODAL_WHATSAPP_DEFINITIVO.js** | Modificar | Local (`02-DEVELOPMENT/`) |
| **5. webflow_injection_limpo.js** | Modificar | Local (`02-DEVELOPMENT/`) |
| **6. Deploy** | Enviar para servidor | Via `scp` |
| **7. Testes** | Validar funcionamento | Browser e servidor |

---

## ✅ GARANTIAS

1. ✅ **Backup antes de tudo** - Pode restaurar se necessário
2. ✅ **Modificações locais** - Não modifica diretamente no servidor
3. ✅ **Usa variáveis Docker** - Lê `$_ENV['APP_BASE_URL']` e `$_ENV['PHP_ENV']`
4. ✅ **Variáveis globais simples** - Não cria objeto de configuração complexo
5. ✅ **Aguarda carregamento** - Scripts aguardam `window.APP_BASE_URL` estar disponível
6. ✅ **Fallback** - Se `window.APP_BASE_URL` não carregar, usa detecção automática

---

## 🎯 ORDEM DE EXECUÇÃO

```
1. Backup local ✅
   ↓
2. Criar config_env.js.php ✅
   ↓
3. Modificar FooterCodeSiteDefinitivoCompleto.js ✅
   ↓
4. Modificar MODAL_WHATSAPP_DEFINITIVO.js ✅
   ↓
5. Modificar webflow_injection_limpo.js ✅
   ↓
6. Deploy para servidor ✅
   ↓
7. Testes ✅
```

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

