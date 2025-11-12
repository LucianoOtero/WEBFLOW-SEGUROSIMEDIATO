# 🔍 ANÁLISE: ERRO CORS - HEADER DUPLICADO NO PLACA-VALIDATE.PHP

**Data:** 12/11/2025  
**Status:** ✅ **ANÁLISE CONCLUÍDA**  
**Problema:** Header `Access-Control-Allow-Origin` contém múltiplos valores duplicados

---

## 📋 ERRO RELATADO

```
Access to fetch at 'https://dev.bssegurosimediato.com.br/placa-validate.php' 
from origin 'https://segurosimediato-dev.webflow.io' has been blocked by CORS policy: 
The 'Access-Control-Allow-Origin' header contains multiple values 
'https://segurosimediato-dev.webflow.io, https://segurosimediato-dev.webflow.io', 
but only one is allowed.
```

**Análise do Erro:**
- Header `Access-Control-Allow-Origin` está sendo enviado **duas vezes**
- Ambos os valores são idênticos: `https://segurosimediato-dev.webflow.io`
- Browser bloqueia porque apenas um valor é permitido

---

## 🔍 ANÁLISE DO CÓDIGO

### **1. Código do `placa-validate.php`**

**Código Atual (linhas 1-11):**
```php
<?php
// Incluir config.php ANTES de qualquer header ou output para usar setCorsHeaders()
require_once __DIR__ . '/config.php';

// Headers CORS (usar função do config.php para evitar duplicação com Nginx)
// IMPORTANTE: Headers devem ser enviados ANTES de qualquer output
header('Content-Type: application/json; charset=utf-8');
// Usar setCorsHeaders() do config.php - valida origem e envia apenas um valor no header
setCorsHeaders();
// Adicionar headers específicos após setCorsHeaders() se necessário
header('Access-Control-Allow-Headers: Content-Type');
```

**Análise:**
- ✅ Arquivo usa `setCorsHeaders()` do `config.php`
- ✅ Não há header hardcoded `Access-Control-Allow-Origin` no PHP
- ✅ Código parece correto

---

### **2. Função `setCorsHeaders()` no `config.php`**

**Código da Função (linhas 101-120):**
```php
function setCorsHeaders($origin = null) {
    // Obter origem da requisição
    if ($origin === null) {
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    }
    
    // Verificar se origem é permitida
    if (!empty($origin) && isCorsOriginAllowed($origin)) {
        header('Access-Control-Allow-Origin: ' . $origin);
    }
    
    // Headers padrão CORS
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    header('Access-Control-Allow-Credentials: true');
    
    // Tratar requisição OPTIONS (preflight)
    if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
        http_response_code(200);
        exit;
    }
}
```

**Análise:**
- ✅ Função envia apenas **um** header `Access-Control-Allow-Origin`
- ✅ Valida origem antes de enviar
- ✅ Código parece correto

---

### **3. Configuração do Nginx**

**Configuração Encontrada:**
```nginx
add_header 'Access-Control-Allow-Origin' '$http_origin' always;
```

**Análise:**
- ⚠️ Nginx está enviando header `Access-Control-Allow-Origin` com `$http_origin`
- ⚠️ Diretiva `always` faz com que header seja enviado sempre
- ⚠️ Isso causa duplicação quando PHP também envia o header

---

## ⚠️ PROBLEMA IDENTIFICADO

### **CAUSA RAIZ:**

**O header `Access-Control-Allow-Origin` está sendo enviado DUAS VEZES:**

1. **PHP (via `setCorsHeaders()`):**
   - Envia: `Access-Control-Allow-Origin: https://segurosimediato-dev.webflow.io`

2. **Nginx (via `add_header`):**
   - Envia: `Access-Control-Allow-Origin: https://segurosimediato-dev.webflow.io`

**Resultado:**
- Browser recebe: `Access-Control-Allow-Origin: https://segurosimediato-dev.webflow.io, https://segurosimediato-dev.webflow.io`
- Browser bloqueia porque apenas um valor é permitido

---

## 🔍 ANÁLISE DETALHADA

### **Por Que Acontece:**

1. **Nginx processa primeiro:**
   - Nginx recebe requisição
   - Nginx adiciona header `Access-Control-Allow-Origin: $http_origin`
   - Nginx passa requisição para PHP-FPM

2. **PHP processa depois:**
   - PHP recebe requisição
   - PHP chama `setCorsHeaders()`
   - PHP adiciona header `Access-Control-Allow-Origin: https://segurosimediato-dev.webflow.io`

3. **Resultado:**
   - Dois headers `Access-Control-Allow-Origin` na resposta
   - Browser interpreta como valor duplicado
   - CORS policy bloqueia requisição

---

### **Por Que Não Foi Detectado Antes:**

- A correção anterior removeu header hardcoded do PHP
- Mas não removeu header do Nginx
- Ambos continuam enviando headers
- Duplicação só aparece quando ambos enviam o mesmo valor

---

## 📊 COMPARAÇÃO: ANTES vs DEPOIS DA CORREÇÃO

### **Antes da Correção CORS:**
- ❌ PHP tinha header hardcoded: `Access-Control-Allow-Origin: *`
- ❌ Nginx tinha header: `Access-Control-Allow-Origin: $http_origin`
- ❌ Resultado: Dois headers diferentes (`*` e origem específica)

### **Depois da Correção CORS:**
- ✅ PHP usa `setCorsHeaders()` que valida origem
- ⚠️ Nginx ainda tem header: `Access-Control-Allow-Origin: $http_origin`
- ❌ Resultado: Dois headers com mesmo valor (duplicação)

---

## 🎯 CONCLUSÃO DA ANÁLISE

### **Causa Raiz Identificada:**

**O header `Access-Control-Allow-Origin` está sendo enviado tanto pelo Nginx quanto pelo PHP, causando duplicação.**

### **Problemas Específicos:**

1. **Nginx envia header:**
   - Diretiva `add_header 'Access-Control-Allow-Origin' '$http_origin' always;`
   - Header é enviado sempre (mesmo quando PHP também envia)

2. **PHP também envia header:**
   - Função `setCorsHeaders()` envia header quando origem é permitida
   - Header é enviado após validação

3. **Conflito:**
   - Ambos enviam o mesmo valor
   - Browser recebe header duplicado
   - CORS policy bloqueia requisição

---

## 💡 SOLUÇÕES POSSÍVEIS (APENAS PARA REFERÊNCIA)

### **Opção 1: Remover Header do Nginx**

**Remover diretiva do Nginx:**
```nginx
# Remover esta linha:
# add_header 'Access-Control-Allow-Origin' '$http_origin' always;
```

**Vantagens:**
- PHP controla completamente os headers CORS
- Validação de origem feita no PHP
- Mais seguro (validação centralizada)

**Desvantagens:**
- Requer modificação no Nginx
- Pode afetar outros endpoints

---

### **Opção 2: Remover Header do PHP**

**Não chamar `setCorsHeaders()` no PHP:**
```php
// Remover esta linha:
// setCorsHeaders();
```

**Vantagens:**
- Nginx controla headers CORS
- Mais rápido (sem processamento PHP)

**Desvantagens:**
- Nginx não valida origem (usa `$http_origin` diretamente)
- Menos seguro (permite qualquer origem se configurado incorretamente)

---

### **Opção 3: Configurar Nginx para Não Enviar em Arquivos PHP**

**Adicionar condição no Nginx:**
```nginx
# Enviar header apenas se PHP não enviar
# (mais complexo, requer lua script ou map)
```

**Vantagens:**
- Mantém ambos os sistemas
- Flexibilidade

**Desvantagens:**
- Mais complexo
- Pode não funcionar corretamente

---

## ✅ RECOMENDAÇÃO

### **Solução Recomendada: Opção 1**

**Remover header CORS do Nginx e deixar PHP controlar:**

**Motivos:**
1. ✅ PHP já tem validação de origem (`isCorsOriginAllowed()`)
2. ✅ PHP já valida origem antes de enviar header
3. ✅ Mais seguro (validação centralizada)
4. ✅ Mais fácil de manter (lógica em um lugar só)
5. ✅ Já está implementado e funcionando no PHP

**Ação Necessária:**
- Remover diretiva `add_header 'Access-Control-Allow-Origin' '$http_origin' always;` do Nginx
- Manter `setCorsHeaders()` no PHP

---

## 📋 ARQUIVOS AFETADOS

### **Arquivos que Precisam Ser Modificados:**

1. **Configuração Nginx:**
   - Arquivo: `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`
   - Ação: Remover ou comentar linha `add_header 'Access-Control-Allow-Origin' '$http_origin' always;`

### **Arquivos que NÃO Precisam Ser Modificados:**

1. ✅ `placa-validate.php` - Já está correto
2. ✅ `cpf-validate.php` - Já está correto
3. ✅ `config.php` - Função `setCorsHeaders()` está correta

---

## ✅ CONCLUSÃO

**Problema identificado:** Header `Access-Control-Allow-Origin` está sendo enviado tanto pelo Nginx quanto pelo PHP, causando duplicação.

**Causa raiz:** Nginx tem diretiva `add_header` que envia header sempre, mesmo quando PHP também envia.

**Solução recomendada:** Remover header CORS do Nginx e deixar PHP controlar completamente via `setCorsHeaders()`.

**Status:** ✅ **ANÁLISE CONCLUÍDA**  
**Próximo Passo:** Aguardar autorização para implementar correção

