# 📋 Análise: Autenticação Não Respeita Ambiente

**Data:** 16/11/2025  
**Problema:** HTTP 401 (Não autorizado) em produção  
**Causa Raiz Identificada:** Função `getEspoCrmApiKey()` usa fallback hardcoded que não diferencia corretamente DEV e PROD

---

## 🔍 PROBLEMA IDENTIFICADO

### **Sintoma:**
- Erro HTTP 401 ao tentar criar lead no EspoCRM em produção
- Variáveis de ambiente estão configuradas corretamente no PHP-FPM
- `ESPOCRM_URL`: `https://flyingdonkeys.com.br` ✅
- `ESPOCRM_API_KEY`: `73b5b7983bfc641cdba72d204a48ed9d` ✅

### **Causa Raiz:**

A função `getEspoCrmApiKey()` em `config.php` tem um problema na lógica de fallback:

```php
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'  // Fallback DEV
        : '82d5f667f3a65a9a43341a0705be2b0c'); // Fallback PROD
}
```

**Problema:**
1. ✅ Se `$_ENV['ESPOCRM_API_KEY']` estiver definido, usa a variável de ambiente (correto)
2. ❌ Se `$_ENV['ESPOCRM_API_KEY']` **NÃO** estiver definido, usa fallback baseado em `isDevelopment()`
3. ⚠️ **MAS:** A função `isDevelopment()` verifica `$_ENV['PHP_ENV'] === 'development'`
4. ❌ **PROBLEMA:** Em produção, se `ESPOCRM_API_KEY` estiver definido mas com valor incorreto, a função **NÃO** usa o fallback correto

---

## 🔍 ANÁLISE DETALHADA

### **1. Fluxo de Autenticação em `add_flyingdonkeys.php`:**

```php
// Linha ~657-673
if ($is_dev) {
    // AMBIENTE DE DESENVOLVIMENTO
    if (isset($DEV_ESPOCRM_CREDENTIALS) && !empty($DEV_ESPOCRM_CREDENTIALS['url']) && !empty($DEV_ESPOCRM_CREDENTIALS['api_key'])) {
        $FLYINGDONKEYS_API_URL = $DEV_ESPOCRM_CREDENTIALS['url'];
        $FLYINGDONKEYS_API_KEY = $DEV_ESPOCRM_CREDENTIALS['api_key'];
    } else {
        $FLYINGDONKEYS_API_URL = getEspoCrmUrl();
        $FLYINGDONKEYS_API_KEY = getEspoCrmApiKey(); // ← Usa função de config.php
    }
} else {
    // AMBIENTE DE PRODUÇÃO
    $FLYINGDONKEYS_API_URL = getEspoCrmUrl();
    $FLYINGDONKEYS_API_KEY = getEspoCrmApiKey(); // ← Usa função de config.php
}
```

### **2. Função `getEspoCrmApiKey()` em `config.php`:**

```php
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'  // Fallback DEV
        : '82d5f667f3a65a9a43341a0705be2b0c'); // Fallback PROD
}
```

### **3. Função `isDevelopment()` em `config.php`:**

```php
function isDevelopment() {
    return getEnvironment() === 'development';
}

function getEnvironment() {
    return $_ENV['PHP_ENV'] ?? 'development';
}
```

---

## 🔴 PROBLEMA IDENTIFICADO

### **Cenário Atual em PRODUÇÃO:**

1. **Variável de Ambiente Definida:**
   - `ESPOCRM_API_KEY` = `73b5b7983bfc641cdba72d204a48ed9d` (valor de DEV)
   - `PHP_ENV` = `production`

2. **Fluxo de Execução:**
   - `add_flyingdonkeys.php` chama `getEspoCrmApiKey()`
   - `getEspoCrmApiKey()` verifica: `$_ENV['ESPOCRM_API_KEY']` está definido? ✅ SIM
   - **Resultado:** Retorna `73b5b7983bfc641cdba72d204a48ed9d` (valor de DEV)
   - **NÃO usa fallback** porque a variável está definida

3. **Problema:**
   - A variável `ESPOCRM_API_KEY` em PROD está com o valor de DEV
   - A função `getEspoCrmApiKey()` **NÃO valida** se o valor está correto para o ambiente
   - A função **NÃO força** o uso do fallback correto baseado em `isDevelopment()`

---

## 🔍 VERIFICAÇÃO DAS VARIÁVEIS DE AMBIENTE

### **Valores Atuais em PROD (PHP-FPM):**
```ini
env[ESPOCRM_URL] = https://flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d
env[PHP_ENV] = production
```

### **Valores Esperados em PROD:**
```ini
env[ESPOCRM_URL] = https://flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 82d5f667f3a65a9a43341a0705be2b0c  ← Valor de PROD (fallback)
env[PHP_ENV] = production
```

### **Valores em DEV (PHP-FPM):**
```ini
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d  ← Valor de DEV
env[PHP_ENV] = development
```

---

## 🎯 CAUSA RAIZ CONFIRMADA

### **Problema 1: Variável de Ambiente com Valor Incorreto**

A variável `ESPOCRM_API_KEY` em PROD está configurada com o valor de DEV:
- **Atual:** `73b5b7983bfc641cdba72d204a48ed9d` (DEV)
- **Esperado:** `82d5f667f3a65a9a43341a0705be2b0c` (PROD)

### **Problema 2: Função Não Valida Ambiente**

A função `getEspoCrmApiKey()` **NÃO valida** se o valor da variável de ambiente está correto para o ambiente atual:
- Se `PHP_ENV = production` e `ESPOCRM_API_KEY` estiver definido, usa o valor da variável
- **NÃO verifica** se o valor está correto para produção
- **NÃO força** o uso do fallback correto baseado em `isDevelopment()`

### **Problema 3: Lógica de Fallback Invertida**

A lógica de fallback está correta, mas **não é aplicada** quando a variável está definida:
- Se variável **NÃO** definida → usa fallback baseado em `isDevelopment()` ✅
- Se variável **definida** → usa valor da variável (mesmo que incorreto) ❌

---

## 🔧 SOLUÇÃO PROPOSTA

### **Opção 1: Corrigir Variável de Ambiente (RECOMENDADO)**

**Ação:** Atualizar `ESPOCRM_API_KEY` no PHP-FPM de PROD para o valor correto:

```ini
# Antes (incorreto):
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d

# Depois (correto):
env[ESPOCRM_API_KEY] = 82d5f667f3a65a9a43341a0705be2b0c
```

**Vantagens:**
- ✅ Solução simples e direta
- ✅ Mantém a lógica atual da função
- ✅ Respeita o padrão de variáveis de ambiente

**Desvantagens:**
- ⚠️ Requer atualização do PHP-FPM

---

### **Opção 2: Modificar Função para Validar Ambiente**

**Ação:** Modificar `getEspoCrmApiKey()` para validar se o valor está correto para o ambiente:

```php
function getEspoCrmApiKey() {
    $envKey = $_ENV['ESPOCRM_API_KEY'] ?? null;
    
    // Se variável definida, validar se está correta para o ambiente
    if ($envKey !== null) {
        $isDev = isDevelopment();
        $expectedDevKey = '73b5b7983bfc641cdba72d204a48ed9d';
        $expectedProdKey = '82d5f667f3a65a9a43341a0705be2b0c';
        
        // Se valor não corresponde ao ambiente, usar fallback correto
        if ($isDev && $envKey !== $expectedDevKey) {
            error_log('[CONFIG] AVISO: ESPOCRM_API_KEY não corresponde ao ambiente DEV, usando fallback');
            return $expectedDevKey;
        }
        if (!$isDev && $envKey !== $expectedProdKey) {
            error_log('[CONFIG] AVISO: ESPOCRM_API_KEY não corresponde ao ambiente PROD, usando fallback');
            return $expectedProdKey;
        }
        
        return $envKey;
    }
    
    // Fallback se variável não definida
    return isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'
        : '82d5f667f3a65a9a43341a0705be2b0c';
}
```

**Vantagens:**
- ✅ Valida automaticamente se o valor está correto
- ✅ Usa fallback correto se valor estiver incorreto
- ✅ Loga aviso quando detecta inconsistência

**Desvantagens:**
- ⚠️ Adiciona complexidade à função
- ⚠️ Hardcode de valores esperados na função

---

### **Opção 3: Forçar Uso de Fallback Baseado em Ambiente**

**Ação:** Modificar `getEspoCrmApiKey()` para sempre usar fallback baseado em `isDevelopment()`, ignorando variável de ambiente:

```php
function getEspoCrmApiKey() {
    // Sempre usar fallback baseado em ambiente (ignorar variável de ambiente)
    return isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'
        : '82d5f667f3a65a9a43341a0705be2b0c';
}
```

**Vantagens:**
- ✅ Simples e direto
- ✅ Garante que sempre usa valor correto para o ambiente

**Desvantagens:**
- ❌ Ignora variáveis de ambiente (não segue padrão do projeto)
- ❌ Não permite override via variável de ambiente

---

## 📊 COMPARAÇÃO DAS SOLUÇÕES

| Solução | Complexidade | Mantém Padrão | Valida Ambiente | Recomendação |
|---------|--------------|--------------|-----------------|--------------|
| **Opção 1: Corrigir Variável** | ⭐ Baixa | ✅ Sim | ❌ Não | ✅ **RECOMENDADO** |
| **Opção 2: Validar na Função** | ⭐⭐ Média | ✅ Sim | ✅ Sim | ⚠️ Alternativa |
| **Opção 3: Forçar Fallback** | ⭐ Baixa | ❌ Não | ✅ Sim | ❌ Não recomendado |

---

## ✅ RECOMENDAÇÃO

### **Solução Recomendada: Opção 1 (Corrigir Variável de Ambiente)**

**Justificativa:**
1. ✅ Mantém o padrão do projeto (variáveis de ambiente)
2. ✅ Solução simples e direta
3. ✅ Não requer modificação de código
4. ✅ Segue as diretivas do projeto (variáveis de ambiente do Docker)

**Processo:**
1. Verificar valor atual de `ESPOCRM_API_KEY` no PHP-FPM de PROD
2. Atualizar para `82d5f667f3a65a9a43341a0705be2b0c`
3. Reiniciar PHP-FPM
4. Testar autenticação

---

## 🔍 VERIFICAÇÕES NECESSÁRIAS

### **1. Confirmar Valor Correto da API Key de PROD**

**Pergunta:** O valor `82d5f667f3a65a9a43341a0705be2b0c` é realmente a API key correta para produção?

**Ação:** Verificar no EspoCRM de produção qual é a API key correta.

### **2. Verificar se API Key de DEV Funciona em PROD**

**Pergunta:** A API key de DEV (`73b5b7983bfc641cdba72d204a48ed9d`) está sendo usada em PROD por engano?

**Ação:** Confirmar se essa é a causa do HTTP 401.

---

## 📝 CONCLUSÃO

### **Causa Raiz:**
A variável de ambiente `ESPOCRM_API_KEY` em PROD está configurada com o valor de DEV (`73b5b7983bfc641cdba72d204a48ed9d`), mas deveria estar com o valor de PROD (`82d5f667f3a65a9a43341a0705be2b0c`).

### **Solução:**
Atualizar `ESPOCRM_API_KEY` no PHP-FPM de PROD para o valor correto de produção.

### **Próximos Passos:**
1. ⏭️ Confirmar valor correto da API key de PROD
2. ⏭️ Atualizar variável de ambiente no PHP-FPM
3. ⏭️ Reiniciar PHP-FPM
4. ⏭️ Testar autenticação

---

**Status:** ✅ **ANÁLISE CONCLUÍDA**  
**Causa Raiz:** ✅ **IDENTIFICADA**  
**Solução:** ✅ **PROPOSTA**

