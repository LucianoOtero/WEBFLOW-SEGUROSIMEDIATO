# 🔐 VERIFICAÇÃO DE SECRET KEYS - Endpoints COM e SEM Secret Key

**Data:** 10/11/2025  
**Importante:** Os endpoints devem funcionar COM e SEM secret keys

---

## 📋 CONFIGURAÇÃO ATUAL

### Secret Keys Configuradas no Servidor

**Variáveis de ambiente (PHP-FPM):**
- `WEBFLOW_SECRET_FLYINGDONKEYS` = `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` (DEV)
- `WEBFLOW_SECRET_OCTADESK` = `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291` (DEV)

**Funções em config.php:**
- `getWebflowSecretFlyingDonkeys()` - Retorna secret para DEV ou PROD
- `getWebflowSecretOctaDesk()` - Retorna secret para DEV ou PROD

---

## 🔍 COMPORTAMENTO DOS ENDPOINTS

### add_flyingdonkeys.php

**Validação condicional (linhas 518-550):**
- ✅ **SEM signature:** Aceita requisição (requisição do navegador/modal)
- ✅ **COM signature:** Valida signature (requisição do Webflow)

**Lógica:**
```php
if (!empty($signature) && !empty($timestamp)) {
    // Validar signature
    if (!validateWebflowSignatureProd(...)) {
        // Rejeitar
    }
} else {
    // Aceitar sem validação (requisição do navegador)
}
```

**Secret key usada:**
- DEV: `$DEV_WEBFLOW_SECRETS['flyingdonkeys']` (se existir) ou `getWebflowSecretFlyingDonkeys()`
- PROD: `'ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990'` (hardcoded)

---

### add_webflow_octa.php

**Validação condicional (linhas 329-363):**
- ✅ **SEM signature:** Aceita requisição (requisição do navegador/modal)
- ✅ **COM signature:** Valida signature (requisição do Webflow)

**Lógica:**
```php
if (!empty($signature) && !empty($timestamp)) {
    // Validar signature
    if (!validateWebflowSignature(...)) {
        // Rejeitar
    }
} else {
    // Aceitar sem validação (requisição do navegador)
}
```

**Secret key usada:**
- `$WEBFLOW_SECRET_OCTADESK` (definida no arquivo)

---

## ✅ CONCLUSÃO

**Status:** ✅ **ENDPOINTS CONFIGURADOS CORRETAMENTE**

**Comportamento:**
1. ✅ Funcionam **SEM** secret key (requisições do navegador/modal)
2. ✅ Funcionam **COM** secret key (requisições do Webflow com validação)

**Secret keys:**
- ✅ Configuradas no servidor via variáveis de ambiente
- ✅ Funções em `config.php` retornam valores corretos para DEV
- ✅ Endpoints usam validação condicional (aceita com ou sem signature)

**Não é necessário modificar os endpoints** - eles já estão funcionando corretamente com ambos os cenários.

---

**Teste disponível:** `test_secret_keys.php` - Testa ambos os cenários (com e sem secret key)

