# 🔍 BUSCA: Referências a "travelangels" no Projeto

**Data:** 11/11/2025  
**Objetivo:** Identificar todas as referências a "travelangels" antes do projeto de centralização

---

## 📋 RESULTADO DA BUSCA

### **✅ ENCONTRADAS REFERÊNCIAS**

Foram encontradas referências a "travelangels" em **2 arquivos principais**:

---

## 🔍 ARQUIVOS COM REFERÊNCIAS

### **1. `add_flyingdonkeys.php`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

**Referências encontradas:**

**Linha 68:**
```php
$WEBFLOW_SECRET_TRAVELANGELS = $DEV_WEBFLOW_SECRETS['flyingdonkeys'] ?? $DEV_WEBFLOW_SECRETS['travelangels'] ?? '';
```

**Contexto:**
- Usa `$DEV_WEBFLOW_SECRETS['travelangels']` como **fallback** se `$DEV_WEBFLOW_SECRETS['flyingdonkeys']` não existir
- Variável `$WEBFLOW_SECRET_TRAVELANGELS` é usada para validação de signature (linha 526)

**Impacto:**
- ⚠️ **Compatibilidade legada** - mantém suporte ao nome antigo "travelangels"
- ⚠️ Será removido no projeto de centralização (usará `getWebflowSecretFlyingDonkeys()`)

---

### **2. `dev_config.php`**

**Localização:** `dev_config.php` (raiz do projeto)

**Referências encontradas:**

**Linha 28 - Array `$DEV_WEBHOOK_URLS`:**
```php
$DEV_WEBHOOK_URLS = [
    'travelangels' => 'https://bpsegurosimediato.com.br/dev/webhooks/add_travelangels.php',
    'octadesk' => 'https://bpsegurosimediato.com.br/dev/webhooks/add_webflow_octa.php',
    'health' => 'https://bpsegurosimediato.com.br/dev/webhooks/health.php'
];
```

**Linha 35 - Array `$DEV_WEBFLOW_SECRETS`:**
```php
$DEV_WEBFLOW_SECRETS = [
    'travelangels' => '888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142',
    'octadesk' => '1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291'
];
```

**Linha 41 - Array `$DEV_LOGGING`:**
```php
$DEV_LOGGING = [
    'travelangels' => '/var/www/html/dev/logs/travelangels_dev.txt',
    'octadesk' => '/var/www/html/dev/logs/octadesk_dev.txt',
    'general' => '/var/www/html/dev/logs/general_dev.txt',
    'errors' => '/var/www/html/dev/logs/errors_dev.txt'
];
```

**Linha 49 - Array `$DEV_TEST_DATA`:**
```php
$DEV_TEST_DATA = [
    'travelangels' => [
        'name' => 'TESTE DEV TRAVELANGELS',
        'email' => 'teste.travelangels@dev.com',
        'phone' => '11999999999',
        'source' => 'webflow_dev_travelangels',
        'test_mode' => true
    ],
    // ...
];
```

**Impacto:**
- ⚠️ **Será removido no projeto** - `$DEV_WEBFLOW_SECRETS['travelangels']` será eliminado
- ⚠️ Outras referências (`$DEV_WEBHOOK_URLS`, `$DEV_LOGGING`, `$DEV_TEST_DATA`) podem ser mantidas se não forem usadas

---

## ✅ ARQUIVOS SEM REFERÊNCIAS (Atualizados)

### **`MODAL_WHATSAPP_DEFINITIVO.js`**

**Status:** ✅ **SEM REFERÊNCIAS**

**Verificação:**
- ✅ Não encontrou nenhuma referência a "travelangels"
- ✅ Já atualizado para usar 'flyingdonkeys' e 'octadesk'
- ✅ Função `getEndpointUrl()` usa 'flyingdonkeys' (linha 188)

---

## 📊 RESUMO

### **Arquivos Principais com Referências:**

| Arquivo | Referências | Tipo | Ação no Projeto |
|---------|-------------|------|-----------------|
| `add_flyingdonkeys.php` | 1 (linha 68) | Fallback de secret key | ✅ Será removido (usará função) |
| `dev_config.php` | 4 (linhas 28, 35, 41, 49) | Arrays de configuração | ✅ Será removido (`$DEV_WEBFLOW_SECRETS`) |

### **Arquivos Atualizados (Sem Referências):**

| Arquivo | Status |
|---------|--------|
| `MODAL_WHATSAPP_DEFINITIVO.js` | ✅ Sem referências |
| `add_webflow_octa.php` | ✅ Sem referências |
| `config.php` | ✅ Sem referências |

---

## 🎯 IMPACTO NO PROJETO DE CENTRALIZAÇÃO

### **Mudanças Necessárias:**

1. **`add_flyingdonkeys.php` (linha 68):**
   - **Remover:** `$DEV_WEBFLOW_SECRETS['travelangels']` do fallback
   - **Substituir por:** `getWebflowSecretFlyingDonkeys()` (já prioriza PHP-FPM)

2. **`dev_config.php`:**
   - **Remover:** `$DEV_WEBFLOW_SECRETS['travelangels']` do array
   - **Manter (opcional):** `$DEV_WEBHOOK_URLS['travelangels']`, `$DEV_LOGGING['travelangels']`, `$DEV_TEST_DATA['travelangels']` (se não forem usados, podem ser removidos também)

---

## ✅ CONCLUSÃO

**Total de referências encontradas:** **5 referências** em **2 arquivos principais**

**Arquivos afetados pelo projeto:**
- ✅ `add_flyingdonkeys.php` - 1 referência (será removida)
- ✅ `dev_config.php` - 4 referências (1 será removida, outras podem ser mantidas se não usadas)

**Arquivos já atualizados:**
- ✅ `MODAL_WHATSAPP_DEFINITIVO.js` - Sem referências

**Status:** ✅ **Pronto para projeto de centralização**

---

**Documento criado em:** 11/11/2025  
**Última atualização:** 11/11/2025  
**Versão:** 1.0

