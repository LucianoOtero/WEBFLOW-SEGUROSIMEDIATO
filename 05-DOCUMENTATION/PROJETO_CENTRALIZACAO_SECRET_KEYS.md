# 🔐 PROJETO: CENTRALIZAÇÃO DE SECRET KEYS EM UM ÚNICO LUGAR

**Data:** 11/11/2025  
**Status:** 📋 **PLANEJAMENTO**  
**Objetivo:** Definir secret keys em um único lugar (PHP-FPM) com fallback seguro

---

## 🎯 OBJETIVO

Centralizar todas as secret keys de webhooks em **um único lugar** para eliminar confusão, reduzir manutenção e garantir consistência.

**Fonte única:** PHP-FPM (variáveis de ambiente)  
**Fallback:** `config.php` (apenas se PHP-FPM falhar)

**Tarefas adicionais:**
- ✅ Remover referências legadas a "travelangels" (nome antigo de "flyingdonkeys")
- ✅ Limpar código de fallbacks desnecessários

**Nota:** `add_webflow_octa.php` continuará chamando OctaDesk em produção (sem simulador).

---

## 📋 SITUAÇÃO ATUAL (PROBLEMA)

### **Secret Keys Definidas em 4 Lugares Diferentes:**

1. **PHP-FPM** (`/etc/php/8.3/fpm/pool.d/www.conf`)
   - ✅ Prioridade máxima (mas ignorada por alguns arquivos)

2. **`config.php`** (funções com fallback)
   - ⚠️ Fallback hardcoded (necessário, mas deve ser último recurso)

3. **`dev_config.php`** (array `$DEV_WEBFLOW_SECRETS`)
   - ❌ Usado primeiro por `add_flyingdonkeys.php` (ignora PHP-FPM)

4. **`add_flyingdonkeys.php`** (hardcoded)
   - ❌ Secret key hardcoded para PROD (linha 78)

5. **`add_webflow_octa.php`** (hardcoded)
   - ❌ Secret key hardcoded (linha 57)

**Problema:** Ordem de prioridade inconsistente e confusa.

---

## ✅ SOLUÇÃO PROPOSTA

### **Arquitetura Centralizada:**

```
┌─────────────────────────────────────┐
│   PHP-FPM (Fonte Única)            │
│   /etc/php/8.3/fpm/pool.d/www.conf │
│   env[WEBFLOW_SECRET_FLYINGDONKEYS] │ ← PRIORIDADE MÁXIMA
│   env[WEBFLOW_SECRET_OCTADESK]     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   config.php                        │
│   getWebflowSecretFlyingDonkeys()   │ ← Lê $_ENV primeiro
│   getWebflowSecretOctaDesk()        │ ← Fallback apenas se necessário
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   add_flyingdonkeys.php            │ ← Usa getWebflowSecretFlyingDonkeys()
│   add_webflow_octa.php             │ ← Usa getWebflowSecretOctaDesk()
└─────────────────────────────────────┘
```

**Ordem de Prioridade (Única e Consistente):**
1. ✅ `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']` (PHP-FPM)
2. ✅ Fallback hardcoded em `config.php` (apenas se PHP-FPM falhar)

---

## 📝 PLANO DE IMPLEMENTAÇÃO

### **FASE 1: Refatorar `add_flyingdonkeys.php`**

**Objetivo:** Remover lógica de secret key e usar função de `config.php`

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

**Alterações:**

**ANTES (linhas 66-82):**
```php
if ($is_dev && isset($DEV_WEBFLOW_SECRETS) && isset($DEV_LOGGING)) {
    // AMBIENTE DE DESENVOLVIMENTO
    $WEBFLOW_SECRET_TRAVELANGELS = $DEV_WEBFLOW_SECRETS['flyingdonkeys'] ?? $DEV_WEBFLOW_SECRETS['travelangels'] ?? '';
    if (empty($DEV_LOGGING['flyingdonkeys'])) {
        $DEBUG_LOG_FILE = rtrim($logDir, '/\\') . '/flyingdonkeys_dev.txt';
    } else {
        $DEBUG_LOG_FILE = $DEV_LOGGING['flyingdonkeys'];
    }
    $LOG_PREFIX = '[DEV-FLYINGDONKEYS] ';
    $ENVIRONMENT = 'development';
} else {
    // AMBIENTE DE PRODUÇÃO
    $WEBFLOW_SECRET_TRAVELANGELS = 'ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990';
    $DEBUG_LOG_FILE = rtrim($logDir, '/\\') . '/flyingdonkeys_prod.txt';
    $LOG_PREFIX = '[PROD-FLYINGDONKEYS] ';
    $ENVIRONMENT = 'production';
}
```

**DEPOIS:**
```php
// Usar função de config.php (prioriza $_ENV do PHP-FPM)
$WEBFLOW_SECRET_TRAVELANGELS = getWebflowSecretFlyingDonkeys();

// Detectar ambiente baseado em variável de ambiente
$ENVIRONMENT = isDevelopment() ? 'development' : 'production';
$LOG_PREFIX = isDevelopment() ? '[DEV-FLYINGDONKEYS] ' : '[PROD-FLYINGDONKEYS] ';

// Configurar arquivo de log
if (isDevelopment()) {
    // Se dev_config.php existir e tiver configuração de log, usar
    if (isset($DEV_LOGGING) && !empty($DEV_LOGGING['flyingdonkeys'])) {
        $DEBUG_LOG_FILE = $DEV_LOGGING['flyingdonkeys'];
    } else {
        $DEBUG_LOG_FILE = rtrim($logDir, '/\\') . '/flyingdonkeys_dev.txt';
    }
} else {
    $DEBUG_LOG_FILE = rtrim($logDir, '/\\') . '/flyingdonkeys_prod.txt';
}
```

**Benefícios:**
- ✅ Usa `getWebflowSecretFlyingDonkeys()` (prioriza PHP-FPM)
- ✅ Remove dependência de `$DEV_WEBFLOW_SECRETS` para secret keys
- ✅ **Remove referência legada a "travelangels"** (fallback antigo)
- ✅ Remove secret key hardcoded
- ✅ Mantém compatibilidade com `$DEV_LOGGING` (apenas para logs)

---

### **FASE 2: Refatorar `add_webflow_octa.php`**

**Objetivo:** Remover secret key hardcoded e usar função de `config.php` (mantém chamada para OctaDesk em produção)

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_webflow_octa.php`

**Alterações:**

**ANTES (linha 57):**
```php
$WEBFLOW_SECRET_OCTADESK = '4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f'; // ✅ Secret obtido do Webflow Dashboard
```

**DEPOIS:**
```php
// Usar função de config.php (prioriza $_ENV do PHP-FPM)
$WEBFLOW_SECRET_OCTADESK = getWebflowSecretOctaDesk();
```

**Nota:** O arquivo continuará chamando OctaDesk em produção (sem simulador). Apenas a secret key será centralizada.

**Benefícios:**
- ✅ Usa `getWebflowSecretOctaDesk()` (prioriza PHP-FPM)
- ✅ Remove secret key hardcoded
- ✅ Consistente com `add_flyingdonkeys.php`
- ✅ Mantém comportamento atual (sempre produção)

---

### **FASE 3: Remover Secret Keys de `dev_config.php`**

**Objetivo:** `dev_config.php` não deve mais conter secret keys e referências a "travelangels"

**Arquivo:** `dev_config.php`

**Alterações:**

**ANTES (linhas 33-37):**
```php
// Secret keys para desenvolvimento (usando secrets reais do Webflow)
$DEV_WEBFLOW_SECRETS = [
    'travelangels' => '888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142',
    'octadesk' => '1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291'
];
```

**DEPOIS:**
```php
// ⚠️ SECRET KEYS REMOVIDAS - Agora centralizadas em PHP-FPM
// Use getWebflowSecretFlyingDonkeys() e getWebflowSecretOctaDesk() de config.php
// $DEV_WEBFLOW_SECRETS removido - não é mais necessário
```

**Benefícios:**
- ✅ Secret keys não estão mais em `dev_config.php`
- ✅ Força uso de funções de `config.php`
- ✅ Reduz pontos de manutenção
- ✅ Remove referências legadas a "travelangels"

**Nota:** `dev_config.php` ainda pode existir para outras configurações (logging, headers, etc.), mas não para secret keys.

---

### **FASE 3.1: Remover Referências a "travelangels" em `add_flyingdonkeys.php`**

**Objetivo:** Remover fallback legado para "travelangels"

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

**Alterações:**

**ANTES (linha 68):**
```php
$WEBFLOW_SECRET_TRAVELANGELS = $DEV_WEBFLOW_SECRETS['flyingdonkeys'] ?? $DEV_WEBFLOW_SECRETS['travelangels'] ?? '';
```

**DEPOIS:**
```php
// Usar função de config.php (prioriza $_ENV do PHP-FPM)
$WEBFLOW_SECRET_TRAVELANGELS = getWebflowSecretFlyingDonkeys();
```

**Benefícios:**
- ✅ Remove referência legada a "travelangels"
- ✅ Usa função centralizada de `config.php`
- ✅ Prioriza PHP-FPM automaticamente

---

### **FASE 4: Atualizar `config.php` (Manter Fallback)**

**Objetivo:** Manter fallback hardcoded apenas como último recurso

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`

**Alterações:** Nenhuma (já está correto)

**Lógica atual (correta):**
```php
function getWebflowSecretFlyingDonkeys() {
    // 1. PRIMEIRA PRIORIDADE: $_ENV (PHP-FPM)
    return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'] ?? 
    // 2. FALLBACK: Hardcoded (apenas se PHP-FPM falhar)
           (isDevelopment()
               ? '888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142'  // DEV
               : 'ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990'); // PROD
}
```

**Benefícios:**
- ✅ Já prioriza `$_ENV` (PHP-FPM)
- ✅ Fallback apenas se necessário
- ✅ Não precisa alterar

---

### **FASE 5: Atualizar PHP-FPM (Fonte Única)**

**Objetivo:** PHP-FPM será a única fonte de verdade

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf` (no servidor)

**Ação:** Atualizar secret keys quando necessário

**Comando:**
```bash
# Atualizar no servidor
sed -i 's|env\[WEBFLOW_SECRET_FLYINGDONKEYS\] = .*|env[WEBFLOW_SECRET_FLYINGDONKEYS] = NOVA_SECRET_KEY|g' /etc/php/8.3/fpm/pool.d/www.conf
sed -i 's|env\[WEBFLOW_SECRET_OCTADESK\] = .*|env[WEBFLOW_SECRET_OCTADESK] = NOVA_SECRET_KEY|g' /etc/php/8.3/fpm/pool.d/www.conf
systemctl restart php8.3-fpm
```

**Benefícios:**
- ✅ Única fonte de verdade
- ✅ Fácil de atualizar
- ✅ Não precisa modificar código

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **FASE 1: Refatorar `add_flyingdonkeys.php`**
- [ ] Fazer backup do arquivo
- [ ] Remover lógica de `$DEV_WEBFLOW_SECRETS` para secret keys
- [ ] **Remover referência a "travelangels"** (fallback legado)
- [ ] Substituir por `getWebflowSecretFlyingDonkeys()`
- [ ] Remover secret key hardcoded para PROD
- [ ] Manter compatibilidade com `$DEV_LOGGING` (apenas logs)
- [ ] Testar em DEV
- [ ] Verificar que usa `$_ENV` do PHP-FPM

### **FASE 2: Refatorar `add_webflow_octa.php`**
- [ ] Fazer backup do arquivo
- [ ] Remover secret key hardcoded (linha 57)
- [ ] Substituir por `getWebflowSecretOctaDesk()`
- [ ] **Manter comportamento atual** (sempre chama OctaDesk em produção)
- [ ] Testar em DEV
- [ ] Verificar que usa `$_ENV` do PHP-FPM

### **FASE 3: Remover Secret Keys de `dev_config.php`**
- [ ] Fazer backup do arquivo
- [ ] Remover array `$DEV_WEBFLOW_SECRETS` (inclui 'travelangels' e 'octadesk')
- [ ] **Remover referência a "travelangels"** de `$DEV_WEBFLOW_SECRETS`
- [ ] Adicionar comentário explicando remoção
- [ ] Verificar que não quebra outros usos de `dev_config.php`
- [ ] **Nota:** Outras referências a "travelangels" (`$DEV_WEBHOOK_URLS`, `$DEV_LOGGING`, `$DEV_TEST_DATA`) podem ser mantidas se não forem usadas

### **FASE 4: Verificar `config.php`**
- [ ] Confirmar que funções estão corretas
- [ ] Confirmar que priorizam `$_ENV`
- [ ] Confirmar que fallbacks estão atualizados

### **FASE 5: Testes e Validação**
- [ ] Testar `add_flyingdonkeys.php` com secret key do PHP-FPM
- [ ] Testar `add_webflow_octa.php` com secret key do PHP-FPM
- [ ] Testar fallback (simular PHP-FPM sem variável)
- [ ] Verificar logs para confirmar uso correto
- [ ] Documentar mudanças

---

## 📊 COMPARAÇÃO: ANTES vs DEPOIS

### **ANTES (Confuso - 4 Lugares):**

| Arquivo | Secret Key | Prioridade |
|---------|-----------|------------|
| `add_flyingdonkeys.php` | `$DEV_WEBFLOW_SECRETS` | 1º (se dev_config.php existir) |
| `add_flyingdonkeys.php` | Hardcoded PROD | 2º |
| `dev_config.php` | `$DEV_WEBFLOW_SECRETS` | 1º (usado por add_flyingdonkeys.php) |
| `config.php` | `$_ENV` | Ignorado se dev_config.php existir |
| `config.php` | Fallback | Último recurso |

**Problema:** Ordem inconsistente, PHP-FPM ignorado.

---

### **DEPOIS (Simples - 1 Lugar):**

| Arquivo | Secret Key | Prioridade |
|---------|-----------|------------|
| **PHP-FPM** | `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']` | **1º (Fonte Única)** |
| `config.php` | Fallback hardcoded | 2º (apenas se PHP-FPM falhar) |

**Benefício:** Ordem única e consistente, PHP-FPM sempre usado primeiro.

---

## 🎯 RESULTADO ESPERADO

Após a implementação:

1. ✅ **PHP-FPM é a única fonte de verdade** para secret keys
2. ✅ **Todos os arquivos usam** `getWebflowSecretFlyingDonkeys()` e `getWebflowSecretOctaDesk()`
3. ✅ **Ordem de prioridade consistente** em todo o código
4. ✅ **Fallback apenas se PHP-FPM falhar** (desenvolvimento local, erro de configuração)
5. ✅ **Manutenção simplificada** - atualizar apenas PHP-FPM
6. ✅ **Sem confusão** - um único lugar para atualizar

---

## 📝 PROCESSO DE ATUALIZAÇÃO (DEPOIS DO PROJETO)

### **Como Atualizar Secret Keys (Simplificado):**

1. **Atualizar PHP-FPM:**
   ```bash
   # No servidor
   sed -i 's|env\[WEBFLOW_SECRET_FLYINGDONKEYS\] = .*|env[WEBFLOW_SECRET_FLYINGDONKEYS] = NOVA_SECRET_KEY|g' /etc/php/8.3/fpm/pool.d/www.conf
   systemctl restart php8.3-fpm
   ```

2. **Opcional: Atualizar fallback em `config.php`** (apenas se quiser fallback atualizado)

**Pronto!** Não precisa atualizar mais nada.

---

## ⚠️ NOTAS IMPORTANTES

### **Por que manter fallback em `config.php`?**

1. **Desenvolvimento local:** Variáveis do PHP-FPM não existem fora do servidor
2. **Resiliência:** Sistema funciona se PHP-FPM falhar (erro de configuração, etc.)
3. **Testes:** Permite testar sem configurar PHP-FPM

### **Por que remover de `dev_config.php`?**

1. **Elimina confusão:** Não há mais múltiplas fontes
2. **Força uso correto:** Código deve usar funções de `config.php`
3. **Reduz manutenção:** Um lugar a menos para atualizar

---

## 🔄 MIGRAÇÃO

### **Ordem de Execução:**

1. ✅ **FASE 1:** Refatorar `add_flyingdonkeys.php` (remover "travelangels")
2. ✅ **FASE 2:** Refatorar `add_webflow_octa.php`
3. ✅ **FASE 3:** Remover secret keys de `dev_config.php` (remover "travelangels")
4. ✅ **FASE 3.1:** Remover referências a "travelangels" em `add_flyingdonkeys.php`
5. ✅ **FASE 4:** Verificar `config.php` (já está correto)
6. ✅ **FASE 5:** Testar tudo
7. ✅ **FASE 6:** Atualizar documentação

---

## 📋 RESUMO

**Problema:** Secret keys definidas em 4 lugares diferentes, ordem de prioridade confusa, referências legadas a "travelangels".

**Solução:** Centralizar em PHP-FPM (fonte única) com fallback em `config.php` e remover referências legadas.

**Benefícios:**
- ✅ Um único lugar para atualizar (PHP-FPM)
- ✅ Ordem de prioridade consistente
- ✅ Código mais limpo e manutenível
- ✅ Sem confusão
- ✅ **Remove referências legadas a "travelangels"**

---

**Status:** 📋 **AGUARDANDO AUTORIZAÇÃO PARA IMPLEMENTAÇÃO**

