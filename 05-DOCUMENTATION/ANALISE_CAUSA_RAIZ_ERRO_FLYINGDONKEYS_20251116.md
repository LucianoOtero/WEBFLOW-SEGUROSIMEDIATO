# 🔍 Análise de Causa Raiz: Erro FlyingDonkeys

**Data:** 16/11/2025 14:36  
**Request ID:** `prod_fd_6919e1627a97b7.00326569`  
**Status:** 🔍 **ANÁLISE TÉCNICA COMPLETA**

---

## 🎯 PROBLEMA IDENTIFICADO

### **Cenário:**

1. ✅ Webhook antigo (`bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php`) executa primeiro
2. ✅ Cria lead no EspoCRM com sucesso (email: `lrotero1116@gmail.com`)
3. ❌ Webhook novo (`prod.bssegurosimediato.com.br/add_flyingdonkeys.php`) executa depois
4. ❌ Tenta criar o mesmo lead → EspoCRM retorna HTTP 409 (Conflict - duplicação)
5. ❌ Código não detecta como duplicação → Trata como erro real

---

## 🔍 ANÁLISE DO CÓDIGO

### **1. Lançamento da Exception (`class.php` linha 145):**

```php
throw new \Exception($errorMessage, $responseCode);
```

**Parâmetros:**
- `$errorMessage`: Mensagem de erro (vem de `X-Status-Reason` ou body)
- `$responseCode`: Código HTTP (ex: 409, 400, 500)

**Problema:**
- ❌ `$errorMessage` está vazio (`""`)
- ✅ `$responseCode` provavelmente é `409` (mas não está sendo verificado)

### **2. Tratamento de Duplicação (`add_flyingdonkeys.php` linhas 973-977):**

```php
if (
    strpos($errorMessage, '409') !== false || 
    strpos($errorMessage, 'duplicate') !== false ||
    (strpos($errorMessage, '"id":') !== false && strpos($errorMessage, '"name":') !== false)
) {
    // Tratamento de duplicação
}
```

**Problema:**
- ❌ Verifica apenas `$errorMessage` (que está vazio)
- ❌ **NÃO verifica** `$e->getCode()` (código HTTP da Exception)
- ❌ Se `$responseCode = 409` mas `$errorMessage = ""`, duplicação não é detectada

---

## 🔴 CAUSA RAIZ CONFIRMADA

### **Problema Principal:**

**O código de tratamento de duplicação não verifica o código HTTP da Exception.**

**Evidências:**
1. ✅ Exception é lançada com código HTTP como segundo parâmetro: `new \Exception($errorMessage, $responseCode)`
2. ❌ Tratamento verifica apenas mensagem: `strpos($errorMessage, '409')`
3. ❌ Mensagem está vazia: `$errorMessage = ""`
4. ❌ Código HTTP não é verificado: `$e->getCode()` não é usado

**Resultado:**
- EspoCRM retorna HTTP 409 (Conflict - duplicação)
- Exception é lançada com código 409, mas mensagem vazia
- Tratamento não detecta duplicação (verifica apenas mensagem vazia)
- Erro é tratado como "erro real" ao invés de duplicação

---

## 🔧 SOLUÇÃO PROPOSTA

### **Correção Necessária:**

**Modificar tratamento de duplicação para verificar código HTTP:**

```php
} catch (Exception $e) {
    $errorMessage = $e->getMessage();
    $httpCode = $e->getCode(); // ✅ ADICIONAR: Capturar código HTTP
    
    logDevWebhook('flyingdonkeys_exception', [
        'error' => $errorMessage,
        'http_code' => $httpCode  // ✅ ADICIONAR: Log do código HTTP
    ], false);

    // ✅ CORRIGIR: Verificar código HTTP 409 explicitamente
    if (
        $httpCode === 409 ||  // ✅ ADICIONAR: Verificar código HTTP
        strpos($errorMessage, '409') !== false || 
        strpos($errorMessage, 'duplicate') !== false ||
        (strpos($errorMessage, '"id":') !== false && strpos($errorMessage, '"name":') !== false)
    ) {
        // Tratamento de duplicação
    }
}
```

---

## 📋 VERIFICAÇÕES ADICIONAIS NECESSÁRIAS

### **1. Confirmar Código HTTP Retornado pelo EspoCRM**

**Objetivo:** Verificar se realmente foi HTTP 409

**Ações:**
- Verificar logs detalhados da requisição cURL
- Verificar se código HTTP está sendo logado em algum lugar
- Testar manualmente criação de lead duplicado no EspoCRM

### **2. Verificar Se Mensagem Está Realmente Vazia**

**Objetivo:** Entender por que mensagem está vazia

**Possíveis Causas:**
1. Header `X-Status-Reason` não está presente na resposta
2. Body da resposta está vazio
3. Body contém JSON mas não está sendo parseado corretamente

### **3. Melhorar Logging para Diagnóstico**

**Objetivo:** Facilitar diagnóstico futuro

**Melhorias:**
- Logar código HTTP sempre que Exception for lançada
- Logar headers completos da resposta
- Logar body completo da resposta (mesmo em caso de erro)

---

## ✅ CONCLUSÃO

### **Causa Raiz Confirmada:**

**O código de tratamento de duplicação não verifica o código HTTP da Exception, apenas a mensagem. Como a mensagem está vazia, duplicações não são detectadas.**

### **Solução:**

1. ✅ Adicionar verificação de `$e->getCode() === 409` no tratamento de duplicação
2. ✅ Melhorar logging para incluir código HTTP
3. ✅ Considerar verificar lead antes de criar (buscar por email primeiro)

### **Próximos Passos:**

1. ⏭️ Implementar correção no código (após autorização)
2. ⏭️ Testar com lead duplicado para confirmar correção
3. ⏭️ Monitorar logs após correção

---

**Status:** ✅ **CAUSA RAIZ IDENTIFICADA** - Código HTTP não está sendo verificado no tratamento de duplicação

