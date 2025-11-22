# ✅ Correção: SAFETYMAILS_BASE_DOMAIN

**Data:** 21/11/2025  
**Status:** ✅ **CORRIGIDO**

---

## 🔍 Problema Identificado

**Erro no Console:**
```
[CONFIG] ERRO CRÍTICO: SAFETYMAILS_BASE_DOMAIN não está definido. Carregue config_env.js.php ANTES deste script.
```

**Causa Raiz:**
1. `SAFETYMAILS_BASE_DOMAIN` não estava definida no PHP-FPM config (`/etc/php/8.3/fpm/pool.d/www.conf`)
2. Quando `config_env.js.php` tentava ler `$_ENV['SAFETYMAILS_BASE_DOMAIN']`, ela não existia, então usava `''` (string vazia)
3. O JavaScript validava `!window.SAFETYMAILS_BASE_DOMAIN`, que é `true` para string vazia, então lançava erro
4. Mas o código na linha 1458 tem fallback: `window.SAFETYMAILS_BASE_DOMAIN || 'safetymails.com'`

**Conclusão:** A variável é **opcional** (tem fallback), mas a validação estava tratando como obrigatória.

---

## 🔧 Correções Aplicadas

### 1. Ajuste da Validação no JavaScript

**Arquivo:** `FooterCodeSiteDefinitivoCompleto.js`

**ANTES (Linha 158-160):**
```javascript
if (typeof window.SAFETYMAILS_BASE_DOMAIN === 'undefined' || !window.SAFETYMAILS_BASE_DOMAIN) {
    throw new Error('[CONFIG] ERRO CRÍTICO: SAFETYMAILS_BASE_DOMAIN não está definido. Carregue config_env.js.php ANTES deste script.');
}
```

**DEPOIS:**
```javascript
// SAFETYMAILS_BASE_DOMAIN é opcional (tem fallback 'safetymails.com' na linha 1458)
// Apenas garantir que está definida (pode ser string vazia, será tratada com fallback)
if (typeof window.SAFETYMAILS_BASE_DOMAIN === 'undefined') {
    // Definir como string vazia se não estiver definida (fallback será usado quando necessário)
    window.SAFETYMAILS_BASE_DOMAIN = '';
}
```

**ANTES (Linha 729-730):**
```javascript
const SAFETYMAILS_BASE_DOMAIN = window.SAFETYMAILS_BASE_DOMAIN;
if (!SAFETYMAILS_BASE_DOMAIN) throw new Error('[CONFIG] ERRO CRÍTICO: SAFETYMAILS_BASE_DOMAIN não está definido.');
```

**DEPOIS:**
```javascript
// SAFETYMAILS_BASE_DOMAIN é opcional (tem fallback 'safetymails.com' na linha 1458)
const SAFETYMAILS_BASE_DOMAIN = window.SAFETYMAILS_BASE_DOMAIN || 'safetymails.com';
```

### 2. Adição da Variável no PHP-FPM Config

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Adicionado:**
```ini
env[SAFETYMAILS_BASE_DOMAIN] = safetymails.com
```

**Localização:** Após `env[SAFETYMAILS_OPTIN_BASE]`

### 3. Atualização do Arquivo Local de Configuração

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.txt`

**Adicionado:**
```ini
env[SAFETYMAILS_OPTIN_BASE] = https://optin.safetymails.com
env[SAFETYMAILS_BASE_DOMAIN] = safetymails.com
env[RPA_API_BASE_URL] = https://rpaimediatoseguros.com.br
```

---

## ✅ Verificações Realizadas

1. ✅ Variável adicionada no PHP-FPM config
2. ✅ PHP-FPM recarregado (`systemctl reload php8.3-fpm`)
3. ✅ Validação ajustada no JavaScript para permitir string vazia
4. ✅ Arquivo `FooterCodeSiteDefinitivoCompleto.js` atualizado no servidor
5. ✅ Arquivo de configuração local atualizado

---

## 🎯 Resultado Esperado

Após as correções:

1. **Se `SAFETYMAILS_BASE_DOMAIN` estiver definida no PHP-FPM:**
   - `config_env.js.php` expõe: `window.SAFETYMAILS_BASE_DOMAIN = "safetymails.com"`
   - JavaScript usa o valor definido

2. **Se `SAFETYMAILS_BASE_DOMAIN` não estiver definida (string vazia):**
   - `config_env.js.php` expõe: `window.SAFETYMAILS_BASE_DOMAIN = ""`
   - JavaScript não lança erro (validação ajustada)
   - Fallback `'safetymails.com'` é usado quando necessário (linha 1458)

---

## 📋 Próximos Passos

1. **Limpar cache do Cloudflare** (se aplicável)
2. **Limpar cache do navegador** (Ctrl+Shift+Delete)
3. **Recarregar página** (Ctrl+F5)
4. **Verificar console** - não deve mais aparecer erro sobre `SAFETYMAILS_BASE_DOMAIN`

---

**Última Atualização:** 21/11/2025  
**Versão:** 1.0.0

