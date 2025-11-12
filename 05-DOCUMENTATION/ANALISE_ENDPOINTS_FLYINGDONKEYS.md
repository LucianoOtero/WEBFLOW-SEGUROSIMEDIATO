# 🔍 ANÁLISE: Endpoints FlyingDonkeys (DEV e PROD)

**Data:** 11/11/2025  
**Objetivo:** Identificar onde os endpoints de desenvolvimento e produção do FlyingDonkeys são definidos

---

## 📋 RESUMO EXECUTIVO

Os endpoints do FlyingDonkeys são definidos através da **variável de ambiente `ESPOCRM_URL`** no PHP-FPM, lida pela função `getEspoCrmUrl()` de `config.php`.

**DEV:** `https://dev.flyingdonkeys.com.br`  
**PROD:** `https://flyingdonkeys.com.br`

---

## 🔍 ONDE SÃO DEFINIDOS

### **1. PHP-FPM (Fonte Única - Prioridade Máxima)**

**Localização:** `/etc/php/8.3/fpm/pool.d/www.conf` (no servidor)

**Variável:**
```ini
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br  # DEV
env[ESPOCRM_URL] = https://flyingdonkeys.com.br      # PROD
```

**Como funciona:**
- PHP-FPM carrega a variável em todas as requisições PHP
- Acessível via `$_ENV['ESPOCRM_URL']`
- Diferente para cada ambiente (DEV vs PROD)

---

### **2. `config.php` (Função que Lê a Variável)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`

**Função (linhas 146-153):**
```php
function getEspoCrmUrl() {
    $url = $_ENV['ESPOCRM_URL'] ?? '';
    if (empty($url)) {
        error_log('[CONFIG] ERRO CRÍTICO: ESPOCRM_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('ESPOCRM_URL não está definido nas variáveis de ambiente');
    }
    return $url;
}
```

**Características:**
- ✅ Lê `$_ENV['ESPOCRM_URL']` (do PHP-FPM)
- ❌ **NÃO tem fallback hardcoded** (lança exceção se não existir)
- ✅ Retorna URL correta para DEV ou PROD baseado na variável de ambiente

---

### **3. `add_flyingdonkeys.php` (Uso da Função)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

**Código (linhas 656-672):**
```php
// Usar getEspoCrmUrl() e getEspoCrmApiKey() de config.php
if ($is_dev) {
    // AMBIENTE DE DESENVOLVIMENTO
    // Priorizar DEV_ESPOCRM_CREDENTIALS se existir, senão usar funções de config.php
    if (isset($DEV_ESPOCRM_CREDENTIALS) && !empty($DEV_ESPOCRM_CREDENTIALS['url']) && !empty($DEV_ESPOCRM_CREDENTIALS['api_key'])) {
        $FLYINGDONKEYS_API_URL = $DEV_ESPOCRM_CREDENTIALS['url'];
        $FLYINGDONKEYS_API_KEY = $DEV_ESPOCRM_CREDENTIALS['api_key'];
    } else {
        // Usar funções de config.php que retornam valores corretos para dev
        $FLYINGDONKEYS_API_URL = getEspoCrmUrl();
        $FLYINGDONKEYS_API_KEY = getEspoCrmApiKey();
    }
} else {
    // AMBIENTE DE PRODUÇÃO
    $FLYINGDONKEYS_API_URL = getEspoCrmUrl();
    $FLYINGDONKEYS_API_KEY = getEspoCrmApiKey();
}
```

**Ordem de Prioridade:**
1. ✅ `$DEV_ESPOCRM_CREDENTIALS['url']` (se existir em `dev_config.php` e estiver em DEV)
2. ✅ `getEspoCrmUrl()` (lê `$_ENV['ESPOCRM_URL']` do PHP-FPM)

**Uso:**
```php
$client = new EspoApiClient($FLYINGDONKEYS_API_URL);
$client->setApiKey($FLYINGDONKEYS_API_KEY);
```

---

## 📊 VALORES POR AMBIENTE

### **Desenvolvimento (DEV):**

| Localização | Variável/Valor |
|-------------|----------------|
| **PHP-FPM** | `env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br` |
| **`getEspoCrmUrl()`** | Retorna: `https://dev.flyingdonkeys.com.br` |
| **`add_flyingdonkeys.php`** | Usa: `getEspoCrmUrl()` → `https://dev.flyingdonkeys.com.br` |

---

### **Produção (PROD):**

| Localização | Variável/Valor |
|-------------|----------------|
| **PHP-FPM** | `env[ESPOCRM_URL] = https://flyingdonkeys.com.br` |
| **`getEspoCrmUrl()`** | Retorna: `https://flyingdonkeys.com.br` |
| **`add_flyingdonkeys.php`** | Usa: `getEspoCrmUrl()` → `https://flyingdonkeys.com.br` |

---

## 🔄 FLUXO DE DADOS

```
┌─────────────────────────────────────┐
│   PHP-FPM (Servidor)                │
│   /etc/php/8.3/fpm/pool.d/www.conf  │
│   env[ESPOCRM_URL] = ...            │ ← FONTE ÚNICA
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   PHP Runtime                       │
│   $_ENV['ESPOCRM_URL'] = ...        │ ← Carregado automaticamente
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   config.php                        │
│   getEspoCrmUrl()                   │ ← Lê $_ENV['ESPOCRM_URL']
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   add_flyingdonkeys.php            │
│   $FLYINGDONKEYS_API_URL =          │
│       getEspoCrmUrl()               │ ← Usa função de config.php
│   $client = new EspoApiClient(...)  │ ← Cria cliente com URL
└─────────────────────────────────────┘
```

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **1. Fallback Opcional em `dev_config.php`**

**Código em `add_flyingdonkeys.php` (linhas 660-667):**
```php
if (isset($DEV_ESPOCRM_CREDENTIALS) && !empty($DEV_ESPOCRM_CREDENTIALS['url'])) {
    $FLYINGDONKEYS_API_URL = $DEV_ESPOCRM_CREDENTIALS['url'];  // ← Prioridade se existir
} else {
    $FLYINGDONKEYS_API_URL = getEspoCrmUrl();  // ← Usa PHP-FPM
}
```

**Se `$DEV_ESPOCRM_CREDENTIALS` existir em `dev_config.php`:**
- ⚠️ Será usado primeiro (pode ignorar PHP-FPM)
- ⚠️ Similar ao problema das secret keys

**Recomendação:** Remover `$DEV_ESPOCRM_CREDENTIALS` e usar apenas `getEspoCrmUrl()`.

---

### **2. Sem Fallback Hardcoded**

**`getEspoCrmUrl()` não tem fallback:**
```php
function getEspoCrmUrl() {
    $url = $_ENV['ESPOCRM_URL'] ?? '';
    if (empty($url)) {
        throw new RuntimeException('ESPOCRM_URL não está definido');  // ← Lança exceção
    }
    return $url;
}
```

**Benefício:**
- ✅ Força configuração correta
- ✅ Não permite valores incorretos
- ✅ Erro claro se variável não estiver configurada

---

### **3. API Key Separada**

**Função `getEspoCrmApiKey()` (linhas 159-163):**
```php
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'  // DEV
        : '82d5f667f3a65a9a43341a0705be2b0c'); // PROD
}
```

**Diferença:**
- URL: Sem fallback (força variável de ambiente)
- API Key: Com fallback hardcoded (compatibilidade)

---

## 📝 RESUMO

### **Onde são Definidos:**

1. **PHP-FPM** (`/etc/php/8.3/fpm/pool.d/www.conf`)
   - `env[ESPOCRM_URL]` = URL do ambiente (DEV ou PROD)

2. **`config.php`** (função `getEspoCrmUrl()`)
   - Lê `$_ENV['ESPOCRM_URL']`
   - Sem fallback (lança exceção se não existir)

3. **`add_flyingdonkeys.php`** (uso)
   - Chama `getEspoCrmUrl()`
   - Opcionalmente usa `$DEV_ESPOCRM_CREDENTIALS` (se existir)

### **Valores:**

- **DEV:** `https://dev.flyingdonkeys.com.br`
- **PROD:** `https://flyingdonkeys.com.br`

### **Como Atualizar:**

1. **Atualizar PHP-FPM:**
   ```bash
   sed -i 's|env\[ESPOCRM_URL\] = .*|env[ESPOCRM_URL] = NOVA_URL|g' /etc/php/8.3/fpm/pool.d/www.conf
   systemctl restart php8.3-fpm
   ```

2. **Pronto!** Não precisa atualizar mais nada (sem fallback hardcoded).

---

**Documento criado em:** 11/11/2025  
**Última atualização:** 11/11/2025  
**Versão:** 1.0

