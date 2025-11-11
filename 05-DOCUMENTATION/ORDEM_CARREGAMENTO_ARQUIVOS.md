# 📋 ORDEM DE CARREGAMENTO DOS ARQUIVOS JAVASCRIPT

**Data de Criação:** 11/11/2025  
**Projeto:** PROJETO_CORRECAO_AUDITORIA_CODIGO  
**Status:** ✅ **DOCUMENTADO**

---

## 🎯 OBJETIVO

Documentar a ordem esperada de carregamento dos arquivos JavaScript no projeto Webflow, garantindo que todas as dependências estejam disponíveis quando necessárias.

---

## 📊 ARQUIVOS DO PROJETO

### 1. **config_env.js.php**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config_env.js.php`
- **Tipo:** PHP que gera JavaScript
- **Dependências:** Nenhuma
- **Expõe:**
  - `window.APP_BASE_URL`
  - `window.APP_ENVIRONMENT`
  - `window.DEBUG_CONFIG` (se configurado)
- **Ordem:** **PRIMEIRO** - Deve ser carregado antes de todos os outros arquivos

### 2. **FooterCodeSiteDefinitivoCompleto.js**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
- **Tipo:** JavaScript
- **Dependências:**
  - `window.APP_BASE_URL` (de `config_env.js.php` ou data attributes)
  - `window.APP_ENVIRONMENT` (de `config_env.js.php` ou data attributes)
- **Expõe:**
  - `window.logClassified()` - Sistema de logging classificado
  - `window.logUnified()` - Sistema de logging unificado (deprecated)
  - `window.logInfo()`, `window.logError()`, `window.logWarn()`, `window.logDebug()` - Aliases
  - `window.sendLogToProfessionalSystem()` - Envio de logs para sistema profissional
  - `window.setFieldValue()` - Função para preencher campos de formulário
  - `window.validarCepViaCep()` - Validação de CEP via ViaCEP
  - `window.validarCelularApi()` - Validação de celular via Apilayer
  - `window.validarEmailSafetyMails()` - Validação de email via SafetyMails
  - `window.onlyDigits()` - Função utilitária para extrair apenas dígitos
- **Ordem:** **SEGUNDO** - Deve ser carregado após `config_env.js.php` e antes dos arquivos que dependem de `logClassified()`

### 3. **MODAL_WHATSAPP_DEFINITIVO.js**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`
- **Tipo:** JavaScript
- **Dependências:**
  - `window.APP_BASE_URL` (obrigatório - lança erro se não estiver disponível)
  - `window.logClassified()` (opcional - verifica antes de usar)
  - `window.logDebug()`, `window.logInfo()`, `window.logError()`, `window.logWarn()` (opcionais)
  - jQuery (opcional - verifica antes de usar)
- **Expõe:**
  - Funções de modal WhatsApp
  - `registrarPrimeiroContatoEspoCRM()`
  - `atualizarLeadEspoCRM()`
  - `enviarMensagemInicialOctadesk()`
  - `sendAdminEmailNotification()`
  - `registrarConversaoGoogleAds()`
- **Ordem:** **TERCEIRO** - Deve ser carregado após `FooterCodeSiteDefinitivoCompleto.js`

### 4. **webflow_injection_limpo.js**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`
- **Tipo:** JavaScript
- **Dependências:**
  - `window.APP_BASE_URL` (verificado antes de usar)
  - `window.logClassified()` (opcional - verifica antes de usar)
  - `window.setFieldValue()` (usa se disponível, mas também define internamente)
- **Expõe:**
  - `MainPage` class (instanciada automaticamente)
  - `FormValidator` class
  - `SpinnerTimer` class
  - `ProgressModalRPA` class
  - `window.setFieldValue()` - Função para preencher campos (se não estiver definida)
- **Ordem:** **QUARTO** - Pode ser carregado após `FooterCodeSiteDefinitivoCompleto.js` (usa `setFieldValue` se disponível, mas também define)

---

## 🔄 ORDEM RECOMENDADA DE CARREGAMENTO

### No Webflow Footer Code:

```html
<!-- 1. PRIMEIRO: Configuração de variáveis de ambiente -->
<script src="https://dev.bssegurosimediato.com.br/webhooks/config_env.js.php" 
        data-app-base-url="https://dev.bssegurosimediato.com.br" 
        data-app-environment="development"></script>

<!-- 2. SEGUNDO: Footer Code Utils e sistema de logging -->
<script src="https://dev.bssegurosimediato.com.br/webhooks/FooterCodeSiteDefinitivoCompleto.js" 
        data-app-base-url="https://dev.bssegurosimediato.com.br" 
        data-app-environment="development"></script>

<!-- 3. TERCEIRO: Modal WhatsApp -->
<script src="https://dev.bssegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO.js"></script>

<!-- 4. QUARTO: Injeção Webflow (RPA) -->
<script src="https://dev.bssegurosimediato.com.br/webhooks/webflow_injection_limpo.js"></script>
```

---

## 📋 DEPENDÊNCIAS DETALHADAS

### Dependências de `config_env.js.php`
- ✅ Nenhuma - arquivo base

### Dependências de `FooterCodeSiteDefinitivoCompleto.js`
- ✅ `window.APP_BASE_URL` (de `config_env.js.php` ou data attributes)
- ✅ `window.APP_ENVIRONMENT` (de `config_env.js.php` ou data attributes)
- ✅ `window.DEBUG_CONFIG` (opcional - de `config_env.js.php`)

### Dependências de `MODAL_WHATSAPP_DEFINITIVO.js`
- ✅ `window.APP_BASE_URL` (obrigatório - lança erro se não estiver disponível)
- ✅ `window.logClassified()` (opcional - verifica antes de usar)
- ✅ `window.logDebug()`, `window.logInfo()`, `window.logError()`, `window.logWarn()` (opcionais)
- ⚠️ jQuery (opcional - verifica antes de usar, mas é recomendado)

### Dependências de `webflow_injection_limpo.js`
- ✅ `window.APP_BASE_URL` (verificado antes de usar)
- ✅ `window.logClassified()` (opcional - verifica antes de usar)
- ✅ `window.setFieldValue()` (usa se disponível, mas também define internamente)

---

## 🔗 DIAGRAMA DE DEPENDÊNCIAS

```
config_env.js.php
    │
    ├─► Expõe: APP_BASE_URL, APP_ENVIRONMENT, DEBUG_CONFIG
    │
    ▼
FooterCodeSiteDefinitivoCompleto.js
    │
    ├─► Depende de: APP_BASE_URL, APP_ENVIRONMENT
    │
    ├─► Expõe: logClassified(), logUnified(), setFieldValue(), validarCepViaCep(), etc.
    │
    ▼
MODAL_WHATSAPP_DEFINITIVO.js
    │
    ├─► Depende de: APP_BASE_URL (obrigatório), logClassified() (opcional)
    │
    ├─► Expõe: Funções de modal WhatsApp
    │
    ▼
webflow_injection_limpo.js
    │
    ├─► Depende de: APP_BASE_URL (verificado), logClassified() (opcional), setFieldValue() (opcional)
    │
    └─► Expõe: MainPage, FormValidator, SpinnerTimer, ProgressModalRPA, setFieldValue()
```

---

## ⚠️ VERIFICAÇÕES DE SEGURANÇA

### Verificações Implementadas

1. **FooterCodeSiteDefinitivoCompleto.js:**
   - ✅ Verifica `APP_BASE_URL` antes de usar
   - ✅ Lança erro se `APP_BASE_URL` não estiver definido
   - ✅ `logClassified()` definida antes de ser usada (FASE 2 - Correção CRÍTICA)

2. **MODAL_WHATSAPP_DEFINITIVO.js:**
   - ✅ Verifica `APP_BASE_URL` antes de operações críticas
   - ✅ Lança erro se `APP_BASE_URL` não estiver disponível
   - ✅ Verifica `window.logClassified` antes de usar

3. **webflow_injection_limpo.js:**
   - ✅ Verifica `APP_BASE_URL` antes de usar
   - ✅ Verifica `window.logClassified` antes de usar
   - ✅ Usa `window.setFieldValue` se disponível, mas também define internamente

---

## 🎯 PONTOS CRÍTICOS

### 1. `logClassified()` deve estar disponível
- **Arquivo:** `FooterCodeSiteDefinitivoCompleto.js`
- **Problema Original:** `logClassified()` era chamada antes de ser definida
- **Solução:** Função movida para antes da linha 110 (FASE 2 - Correção CRÍTICA)
- **Status:** ✅ **CORRIGIDO**

### 2. `APP_BASE_URL` deve estar disponível
- **Arquivos:** Todos
- **Problema:** Operações críticas falhavam silenciosamente se `APP_BASE_URL` não estivesse disponível
- **Solução:** Verificações implementadas com lançamento de erros
- **Status:** ✅ **CORRIGIDO**

### 3. Ordem de carregamento
- **Problema:** Não estava documentada
- **Solução:** Este documento
- **Status:** ✅ **DOCUMENTADO**

---

## 📝 NOTAS IMPORTANTES

1. **Data Attributes:** `FooterCodeSiteDefinitivoCompleto.js` pode ler `APP_BASE_URL` e `APP_ENVIRONMENT` de data attributes do próprio script tag, eliminando a necessidade de `config_env.js.php` em alguns casos.

2. **Fallbacks:** Todos os arquivos implementam verificações defensivas e fallbacks quando possível.

3. **jQuery:** `MODAL_WHATSAPP_DEFINITIVO.js` depende de jQuery, mas verifica antes de usar. É recomendado carregar jQuery antes deste arquivo.

4. **Sistema de Logging:** `logClassified()` é o sistema recomendado. `logUnified()` e `logDebug()` estão deprecated mas mantidos por compatibilidade.

---

## ✅ VALIDAÇÃO

Para validar a ordem de carregamento:

1. Abrir console do navegador
2. Verificar que `window.APP_BASE_URL` está definido
3. Verificar que `window.logClassified` está definido
4. Verificar que não há erros de dependências não encontradas
5. Verificar que todas as funcionalidades funcionam corretamente

---

**Status:** ✅ **DOCUMENTAÇÃO COMPLETA**

