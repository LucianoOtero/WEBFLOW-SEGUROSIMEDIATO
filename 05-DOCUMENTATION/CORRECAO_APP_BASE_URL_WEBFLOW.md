# 🔧 CORREÇÃO: APP_BASE_URL não disponível no Webflow

**Data:** 10/11/2025  
**Problema:** `APP_BASE_URL` não estava sendo detectado quando o script é carregado do Webflow

---

## 🐛 PROBLEMA IDENTIFICADO

**Erro no console:**
```
[LOG] APP_BASE_URL não disponível. Aguardando carregamento...
[LOG] Erro ao enviar log: Error: APP_BASE_URL não disponível
```

**Causa:**
- O `FooterCodeSiteDefinitivoCompleto.js` tenta detectar a URL base do servidor procurando scripts que contenham `bssegurosimediato.com.br`
- Quando o script é carregado do Webflow (`segurosimediato-dev.webflow.io`), não encontra nenhum script com essa URL
- `detectServerBaseUrl()` retorna `null`
- Tentativa de carregar `null + '/config_env.js.php'` falha

---

## ✅ CORREÇÃO APLICADA

**Arquivo:** `FooterCodeSiteDefinitivoCompleto.js`

### 1. Melhorias na função `detectServerBaseUrl()`

Adicionados métodos adicionais de detecção:

1. **Método 1 (original):** Procurar em scripts já carregados
2. **Método 2 (novo):** Se estiver em ambiente Webflow (`webflow.io`), usar URL DEV diretamente
3. **Método 3 (novo):** Tentar detectar pelo próprio script atual (`document.currentScript`)

**Código adicionado:**
```javascript
// Método 2: Se estiver em ambiente de desenvolvimento (webflow.io), usar URL DEV
const hostname = window.location.hostname;
if (hostname.includes('webflow.io') || hostname.includes('dev.')) {
  return 'https://dev.bssegurosimediato.com.br';
}

// Método 3: Tentar detectar pelo próprio script atual
const currentScript = document.currentScript;
if (currentScript && currentScript.src) {
  try {
    const url = new URL(currentScript.src);
    if (url.hostname.includes('bssegurosimediato.com.br')) {
      return url.origin;
    }
  } catch (e) {
    // Ignorar erro
  }
}
```

### 2. Validação antes de carregar config_env.js.php

Adicionada validação para garantir que `serverBaseUrl` não seja `null`:

```javascript
const serverBaseUrl = detectServerBaseUrl();
if (!serverBaseUrl) {
  console.error('[CONFIG] Erro crítico: Não foi possível detectar URL base do servidor');
  window.dispatchEvent(new CustomEvent('appEnvError', { 
    detail: { message: 'Não foi possível detectar URL base do servidor' } 
  }));
  return;
}
```

### 3. Log de sucesso

Adicionado log quando `config_env.js.php` é carregado com sucesso:

```javascript
script.onload = () => {
  console.log('[CONFIG] config_env.js.php carregado com sucesso. APP_BASE_URL:', window.APP_BASE_URL);
  window.dispatchEvent(new CustomEvent('appEnvLoaded'));
};
```

---

## ✅ RESULTADO

Agora o `detectServerBaseUrl()` consegue detectar a URL base mesmo quando:
- ✅ O script é carregado do Webflow (`segurosimediato-dev.webflow.io`)
- ✅ Não há scripts pré-existentes com `bssegurosimediato.com.br`
- ✅ O ambiente é de desenvolvimento

**URL detectada:** `https://dev.bssegurosimediato.com.br`

**Comportamento:**
1. Detecta que está em `webflow.io` → retorna `https://dev.bssegurosimediato.com.br`
2. Carrega `config_env.js.php` de `https://dev.bssegurosimediato.com.br/config_env.js.php`
3. `APP_BASE_URL` fica disponível para uso

---

**Status:** ✅ **CORRIGIDO**

O arquivo foi atualizado no servidor e está pronto para teste.
