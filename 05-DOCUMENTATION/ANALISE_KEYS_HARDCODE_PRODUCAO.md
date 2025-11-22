# 🔍 ANÁLISE: Keys Hardcoded no Servidor de Produção

**Data:** 22/11/2025  
**Servidor:** Produção (`157.180.36.223`)  
**Arquivos Analisados:**
- `add_webflow_octa.php`
- `add_flyingdonkeys.php`

**Tipo de Análise:** ⚠️ **APENAS VERIFICAÇÃO** - Nenhuma alteração realizada

---

## 🎯 OBJETIVO

Verificar se existem keys/credenciais registradas em hardcode nos arquivos `add_webflow_octa.php` e `add_flyingdonkeys.php` no servidor de produção.

---

## 📋 RESULTADO DA ANÁLISE

### ✅ **ARQUIVO 1: `add_webflow_octa.php`**

#### **🔴 KEYS HARDCODED ENCONTRADAS:**

**1. `OCTADESK_API_KEY` (Linha 60)**
```php
$OCTADESK_API_KEY = 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';
```
- **Status:** 🔴 **HARDCODED**
- **Valor:** `b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b`
- **Tipo:** Chave de API do OctaDesk
- **Recomendação:** Deve usar variável de ambiente `$_ENV['OCTADESK_API_KEY']`

**2. `API_BASE` (Linha 61)**
```php
$API_BASE = 'https://o205242-d60.api004.octadesk.services';
```
- **Status:** 🔴 **HARDCODED**
- **Valor:** `https://o205242-d60.api004.octadesk.services`
- **Tipo:** URL base da API OctaDesk
- **Recomendação:** Deve usar variável de ambiente `$_ENV['OCTADESK_API_BASE']`

**3. `OCTADESK_FROM` (Linha 62)**
```php
$OCTADESK_FROM = '+551132301422';
```
- **Status:** 🔴 **HARDCODED**
- **Valor:** `+551132301422`
- **Tipo:** Número de telefone remetente OctaDesk
- **Recomendação:** Deve usar variável de ambiente `$_ENV['OCTADESK_FROM']`

#### **✅ KEYS CORRETAS (Usando Funções de config.php):**

**1. `WEBFLOW_SECRET_OCTADESK` (Linha 64)**
```php
$WEBFLOW_SECRET_OCTADESK = getWebflowSecretOctaDesk();
```
- **Status:** ✅ **CORRETO**
- **Método:** Usa função `getWebflowSecretOctaDesk()` de `config.php`
- **Comportamento:** Prioriza `$_ENV['WEBFLOW_SECRET_OCTADESK']` do PHP-FPM

---

### ✅ **ARQUIVO 2: `add_flyingdonkeys.php`**

#### **✅ NENHUMA KEY HARDCODED ENCONTRADA:**

**1. `WEBFLOW_SECRET_TRAVELANGELS` (Linha 70)**
```php
$WEBFLOW_SECRET_TRAVELANGELS = getWebflowSecretFlyingDonkeys();
```
- **Status:** ✅ **CORRETO**
- **Método:** Usa função `getWebflowSecretFlyingDonkeys()` de `config.php`
- **Comportamento:** Prioriza `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']` do PHP-FPM

**2. Credenciais EspoCRM (Linhas 600-610)**
```php
$FLYINGDONKEYS_API_URL = getEspoCrmUrl();
$FLYINGDONKEYS_API_KEY = getEspoCrmApiKey();
```
- **Status:** ✅ **CORRETO**
- **Método:** Usa funções `getEspoCrmUrl()` e `getEspoCrmApiKey()` de `config.php`
- **Comportamento:** Prioriza variáveis de ambiente `$_ENV['ESPOCRM_URL']` e `$_ENV['ESPOCRM_API_KEY']` do PHP-FPM

---

## 📊 RESUMO EXECUTIVO

### **Estatísticas:**

| Arquivo | Keys Hardcoded | Keys Corretas | Total |
|---------|----------------|---------------|-------|
| `add_webflow_octa.php` | **3** 🔴 | 1 ✅ | 4 |
| `add_flyingdonkeys.php` | **0** ✅ | 3 ✅ | 3 |
| **TOTAL** | **3** 🔴 | **4** ✅ | **7** |

---

## 🔴 PROBLEMAS IDENTIFICADOS

### **Arquivo `add_webflow_octa.php`:**

1. **`OCTADESK_API_KEY`** - Hardcoded na linha 60
   - **Risco:** 🔴 **ALTO** - Credencial exposta no código
   - **Impacto:** Se código for comprometido, chave fica exposta

2. **`API_BASE`** - Hardcoded na linha 61
   - **Risco:** 🟡 **MÉDIO** - URL hardcoded dificulta mudanças de ambiente
   - **Impacto:** Dificulta migração ou mudança de endpoint

3. **`OCTADESK_FROM`** - Hardcoded na linha 62
   - **Risco:** 🟡 **MÉDIO** - Número hardcoded dificulta mudanças
   - **Impacto:** Dificulta mudança de número remetente

---

## ✅ PONTOS POSITIVOS

### **Arquivo `add_flyingdonkeys.php`:**
- ✅ **Nenhuma key hardcoded encontrada**
- ✅ Todas as credenciais usam funções de `config.php`
- ✅ Prioriza variáveis de ambiente do PHP-FPM
- ✅ Suporta fallback para `dev_config.php` em desenvolvimento

### **Arquivo `add_webflow_octa.php`:**
- ✅ `WEBFLOW_SECRET_OCTADESK` usa função correta de `config.php`

---

## 📋 RECOMENDAÇÕES

### **Para `add_webflow_octa.php`:**

**1. Substituir `OCTADESK_API_KEY` hardcoded:**
```php
// ❌ ATUAL (Hardcoded):
$OCTADESK_API_KEY = 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';

// ✅ RECOMENDADO (Variável de Ambiente):
$OCTADESK_API_KEY = $_ENV['OCTADESK_API_KEY'] ?? null;
if (empty($OCTADESK_API_KEY)) {
    throw new Exception('OCTADESK_API_KEY não configurada no PHP-FPM');
}
```

**2. Substituir `API_BASE` hardcoded:**
```php
// ❌ ATUAL (Hardcoded):
$API_BASE = 'https://o205242-d60.api004.octadesk.services';

// ✅ RECOMENDADO (Variável de Ambiente):
$API_BASE = $_ENV['OCTADESK_API_BASE'] ?? 'https://o205242-d60.api004.octadesk.services';
```

**3. Substituir `OCTADESK_FROM` hardcoded:**
```php
// ❌ ATUAL (Hardcoded):
$OCTADESK_FROM = '+551132301422';

// ✅ RECOMENDADO (Variável de Ambiente):
$OCTADESK_FROM = $_ENV['OCTADESK_FROM'] ?? '+551132301422';
```

**4. Adicionar variáveis ao PHP-FPM config:**
```ini
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services
env[OCTADESK_FROM] = +551132301422
```

---

## 🔍 VERIFICAÇÃO DE VARIÁVEIS DE AMBIENTE

### **Variáveis que DEVEM existir no PHP-FPM:**

**Para `add_webflow_octa.php`:**
- [ ] `OCTADESK_API_KEY` - ⚠️ **NÃO ENCONTRADA** no relatório de variáveis DEV
- [ ] `OCTADESK_API_BASE` - ⚠️ **NÃO ENCONTRADA** no relatório de variáveis DEV
- [ ] `OCTADESK_FROM` - ⚠️ **NÃO ENCONTRADA** no relatório de variáveis DEV
- [x] `WEBFLOW_SECRET_OCTADESK` - ✅ **EXISTE** no relatório de variáveis DEV

**Para `add_flyingdonkeys.php`:**
- [x] `WEBFLOW_SECRET_FLYINGDONKEYS` - ✅ **EXISTE** no relatório de variáveis DEV
- [x] `ESPOCRM_URL` - ✅ **EXISTE** no relatório de variáveis DEV
- [x] `ESPOCRM_API_KEY` - ✅ **EXISTE** no relatório de variáveis DEV

---

## 📝 CONCLUSÃO

### **Resumo:**
- ✅ **Arquivo `add_flyingdonkeys.php`:** Nenhuma key hardcoded encontrada - **CONFORME**
- 🔴 **Arquivo `add_webflow_octa.php`:** 3 keys hardcoded encontradas - **NÃO CONFORME**

### **Ações Necessárias:**
1. ⚠️ **URGENTE:** Remover keys hardcoded de `add_webflow_octa.php`
2. ⚠️ **URGENTE:** Adicionar variáveis de ambiente ao PHP-FPM config
3. ⚠️ **URGENTE:** Atualizar código para usar variáveis de ambiente
4. ✅ **Manter:** `add_flyingdonkeys.php` está correto (não requer alterações)

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- **Relatório de Variáveis DEV:** `RELATORIO_VARIAVEIS_AMBIENTE_MODIFICADAS_DEV.md`
- **Processo de Eliminação de Hardcode:** `PROJETO_DEPLOY_ELIMINAR_HARDCODE_DEV_20251121.md`
- **Diretivas do Projeto:** `.cursorrules`

---

**Última Atualização:** 22/11/2025  
**Status:** ✅ **ANÁLISE CONCLUÍDA** - Nenhuma alteração realizada (conforme solicitado)

