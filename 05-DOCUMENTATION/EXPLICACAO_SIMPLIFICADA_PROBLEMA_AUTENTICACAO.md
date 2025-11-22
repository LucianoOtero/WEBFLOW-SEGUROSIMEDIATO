# 📋 Explicação Simplificada: Problema de Autenticação

**Data:** 16/11/2025  
**Problema:** HTTP 401 (Não autorizado) ao tentar criar lead no EspoCRM em produção

---

## 🎯 O PROBLEMA EM POUCAS PALAVRAS

**O sistema está usando a chave de API de DESENVOLVIMENTO em PRODUÇÃO.**

Isso causa erro HTTP 401 porque a chave de DEV não funciona no ambiente de PRODUÇÃO.

---

## 🔍 COMO FUNCIONA ATUALMENTE

### **1. O Código Busca a Chave de API:**

Quando o `add_flyingdonkeys.php` precisa autenticar no EspoCRM, ele chama a função `getEspoCrmApiKey()` do arquivo `config.php`.

### **2. A Função Verifica a Variável de Ambiente:**

```php
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'  // Chave de DEV
        : '82d5f667f3a65a9a43341a0705be2b0c'); // Chave de PROD
}
```

**O que essa função faz:**
1. Primeiro, verifica se existe a variável `$_ENV['ESPOCRM_API_KEY']`
2. Se **EXISTIR**, usa o valor da variável
3. Se **NÃO EXISTIR**, usa um valor padrão (fallback) baseado no ambiente:
   - Se for DEV → usa chave de DEV
   - Se for PROD → usa chave de PROD

### **3. O Problema:**

No servidor de PRODUÇÃO, a variável `ESPOCRM_API_KEY` está definida, mas com o valor **ERRADO**:

```
ESPOCRM_API_KEY = 73b5b7983bfc641cdba72d204a48ed9d  ← Valor de DEV (ERRADO!)
```

**O que acontece:**
- A função encontra a variável definida ✅
- Usa o valor da variável (que é de DEV) ❌
- **NÃO** usa o fallback correto de PROD
- Tenta autenticar em PROD com chave de DEV
- EspoCRM rejeita → HTTP 401 ❌

---

## 📊 COMPARAÇÃO: O QUE ESTÁ vs O QUE DEVERIA ESTAR

### **Em PRODUÇÃO (Atual - ERRADO):**

```ini
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d  ← Chave de DEV
```

**Resultado:** ❌ HTTP 401 (Não autorizado)

### **Em PRODUÇÃO (Correto - DEVERIA SER):**

```ini
env[ESPOCRM_API_KEY] = 82d5f667f3a65a9a43341a0705be2b0c  ← Chave de PROD
```

**Resultado:** ✅ Autenticação funciona

---

## 🔧 A SOLUÇÃO

### **Passo 1: Identificar o Arquivo**

O arquivo que precisa ser corrigido está em:
- **Servidor:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Local (Windows):** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`

### **Passo 2: Corrigir o Valor**

**Encontrar esta linha:**
```ini
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d
```

**Substituir por:**
```ini
env[ESPOCRM_API_KEY] = 82d5f667f3a65a9a43341a0705be2b0c
```

### **Passo 3: Aplicar no Servidor**

1. Copiar arquivo corrigido para o servidor
2. Reiniciar PHP-FPM (para carregar nova variável)
3. Testar autenticação

---

## 🎯 POR QUE ISSO ACONTECEU?

Provavelmente quando o ambiente de produção foi configurado, a variável foi copiada do ambiente de desenvolvimento sem atualizar o valor.

---

## ✅ APÓS A CORREÇÃO

Depois de corrigir, o fluxo será:

1. `add_flyingdonkeys.php` chama `getEspoCrmApiKey()`
2. Função encontra `ESPOCRM_API_KEY` definida
3. Usa o valor: `82d5f667f3a65a9a43341a0705be2b0c` (chave de PROD) ✅
4. Autentica no EspoCRM de produção
5. EspoCRM aceita → HTTP 200 ✅
6. Lead criado com sucesso ✅

---

## 📝 RESUMO

| Item | Status Atual | Status Correto |
|------|--------------|----------------|
| **Variável definida?** | ✅ Sim | ✅ Sim |
| **Valor da variável** | ❌ Chave de DEV | ✅ Chave de PROD |
| **Resultado** | ❌ HTTP 401 | ✅ HTTP 200 |

**Ação necessária:** Atualizar apenas 1 linha no arquivo de configuração do PHP-FPM.

---

**Status:** ✅ **PROBLEMA IDENTIFICADO E SOLUÇÃO CLARA**

