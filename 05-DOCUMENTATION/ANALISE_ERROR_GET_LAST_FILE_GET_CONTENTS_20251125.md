# 🔍 ANÁLISE: `error_get_last()` com `@file_get_contents()` - Dados ou Vazio?

**Data:** 25/11/2025  
**Status:** 🔍 **ANÁLISE TÉCNICA**

---

## ❓ PERGUNTA

**No momento do erro (quando `file_get_contents()` retorna `false`), o `error_get_last()` teria os dados do erro ou estaria vazio também?**

---

## ✅ RESPOSTA DIRETA

### **⚠️ `error_get_last()` PODE ESTAR VAZIO ou TER DADOS INCORRETOS**

**Por quê:**
1. ❌ **`@file_get_contents()` suprime erros** - PHP não registra erro automaticamente
2. ❌ **`error_get_last()` retorna ÚLTIMO erro** - pode ser de outra operação
3. ❌ **Erros de timeout/DNS/SSL** podem não ser capturados corretamente

---

## 🔍 ANÁLISE DO CÓDIGO

### **Código Atual:**
```php
$result = @file_get_contents($endpoint, false, $context);

if ($result === false) {
    $error = error_get_last();
    error_log("[ProfessionalLogger] Falha ao enviar email: " . ($error['message'] ?? 'Erro desconhecido') . " | Endpoint: " . $endpoint);
}
```

### **Problemas Identificados:**

#### **1. `@` Suprime o Erro**
- ⚠️ **`@file_get_contents()`** suprime TODOS os erros/warnings
- ⚠️ **PHP não registra erro automaticamente** quando `@` é usado
- ⚠️ **`error_get_last()` pode retornar `null`** ou erro de outra operação

#### **2. `error_get_last()` Não é Confiável**
- ⚠️ **Retorna ÚLTIMO erro do PHP**, não necessariamente do `file_get_contents()`
- ⚠️ **Se outra operação gerou erro antes**, `error_get_last()` retorna esse erro
- ⚠️ **Se não houver erro registrado**, retorna `null`

#### **3. Erros de Rede Não São Capturados**
- ⚠️ **Timeout:** Pode não gerar erro PHP (apenas retorna `false`)
- ⚠️ **DNS:** Pode gerar warning, mas `@` suprime
- ⚠️ **SSL:** Pode gerar warning, mas `@` suprime
- ⚠️ **Conexão:** Pode não gerar erro PHP (apenas retorna `false`)

---

## 📊 CENÁRIOS POSSÍVEIS

### **Cenário 1: Timeout (10 segundos)**
```php
$result = @file_get_contents($endpoint, false, $context); // Timeout após 10s
// $result = false

$error = error_get_last();
// $error pode ser:
// - null (nenhum erro registrado)
// - ['message' => 'Erro de outra operação anterior']
// - ['message' => 'Erro genérico não relacionado']
```

**Resultado no log:**
```
[ProfessionalLogger] Falha ao enviar email: Erro desconhecido | Endpoint: https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php
```

**Ou:**
```
[ProfessionalLogger] Falha ao enviar email: [mensagem de erro anterior não relacionada] | Endpoint: ...
```

---

### **Cenário 2: Erro de DNS**
```php
$result = @file_get_contents('https://endpoint-inexistente.com.br/...', false, $context);
// $result = false
// PHP gera warning: "php_network_getaddresses: getaddrinfo failed"

$error = error_get_last();
// $error pode ser:
// - null (se @ suprimiu completamente)
// - ['message' => 'php_network_getaddresses: getaddrinfo failed: Name or service not known']
```

**Resultado no log:**
```
[ProfessionalLogger] Falha ao enviar email: php_network_getaddresses: getaddrinfo failed: Name or service not known | Endpoint: ...
```

**Ou (se suprimido):**
```
[ProfessionalLogger] Falha ao enviar email: Erro desconhecido | Endpoint: ...
```

---

### **Cenário 3: Erro de SSL**
```php
$result = @file_get_contents($endpoint, false, $context);
// $result = false
// PHP gera warning sobre certificado SSL

$error = error_get_last();
// $error pode ser:
// - null (se @ suprimiu completamente)
// - ['message' => 'SSL certificate problem: ...']
```

**Resultado no log:**
```
[ProfessionalLogger] Falha ao enviar email: SSL certificate problem: unable to get local issuer certificate | Endpoint: ...
```

**Ou (se suprimido):**
```
[ProfessionalLogger] Falha ao enviar email: Erro desconhecido | Endpoint: ...
```

---

### **Cenário 4: HTTP 500 (Endpoint Retorna Erro)**
```php
$result = @file_get_contents($endpoint, false, $context);
// $result = "<html>Internal Server Error</html>" (não é false!)
// Mas pode ser false se conexão falhar antes

$error = error_get_last();
// $error pode ser null (porque não houve erro PHP, apenas HTTP 500)
```

**Resultado no log:**
- ⚠️ **NÃO entra no `if ($result === false)`** se endpoint retornar HTML de erro
- ⚠️ **Entra no `else`** e loga "Resposta inesperada do endpoint"

---

## 🚨 PROBLEMA CRÍTICO IDENTIFICADO

### **Por que o log pode estar vazio ou com "Erro desconhecido":**

1. **`@file_get_contents()` suprime erros:**
   - ⚠️ PHP não registra erro automaticamente
   - ⚠️ `error_get_last()` pode retornar `null`

2. **`error_get_last()` não é confiável:**
   - ⚠️ Retorna último erro, não necessariamente do `file_get_contents()`
   - ⚠️ Pode retornar erro de outra operação anterior

3. **Erros de rede não geram erro PHP:**
   - ⚠️ Timeout: apenas retorna `false`, não gera erro
   - ⚠️ DNS: pode gerar warning, mas `@` suprime
   - ⚠️ SSL: pode gerar warning, mas `@` suprime

---

## ✅ SOLUÇÃO RECOMENDADA

### **Substituir `@file_get_contents()` por `curl` com logs detalhados:**

```php
// ANTES (não confiável):
$result = @file_get_contents($endpoint, false, $context);
if ($result === false) {
    $error = error_get_last();
    error_log("[ProfessionalLogger] Falha: " . ($error['message'] ?? 'Erro desconhecido'));
}

// DEPOIS (confiável):
$ch = curl_init($endpoint);
curl_setopt_array($ch, [
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $jsonPayload,
    CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT => 10,
    CURLOPT_CONNECTTIMEOUT => 5,
    CURLOPT_SSL_VERIFYPEER => false,
    CURLOPT_SSL_VERIFYHOST => false,
]);

$result = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);
$curlErrno = curl_errno($ch);
curl_close($ch);

if ($result === false || $httpCode !== 200) {
    $errorDetails = [
        'curl_error' => $curlError ?: 'N/A',
        'curl_errno' => $curlErrno ?: 'N/A',
        'http_code' => $httpCode ?: 'N/A',
        'endpoint' => $endpoint
    ];
    error_log("[ProfessionalLogger] Falha ao enviar email: " . json_encode($errorDetails));
}
```

**Vantagens:**
- ✅ Captura erro específico do cURL (`curl_error()`)
- ✅ Captura código HTTP da resposta
- ✅ Captura código de erro do cURL (`curl_errno()`)
- ✅ Não depende de `error_get_last()` (não confiável)

---

## 📋 CONCLUSÃO

### **Resposta à Pergunta:**

**⚠️ `error_get_last()` PODE ESTAR VAZIO ou TER DADOS INCORRETOS**

**Cenários:**
1. **Timeout:** `error_get_last()` provavelmente retorna `null` → log: "Erro desconhecido"
2. **DNS:** `error_get_last()` pode ter mensagem de DNS OU `null` (se suprimido)
3. **SSL:** `error_get_last()` pode ter mensagem de SSL OU `null` (se suprimido)
4. **HTTP 500:** `error_get_last()` provavelmente retorna `null` (não é erro PHP)

**Por isso:**
- ⚠️ Logs podem mostrar "Erro desconhecido" mesmo quando há erro real
- ⚠️ Logs podem mostrar erro de outra operação (não relacionado)
- ⚠️ Não há informação confiável sobre tipo de erro (timeout, DNS, SSL, HTTP)

**Recomendação:**
- ✅ **Substituir `@file_get_contents()` por `curl`** com logs detalhados
- ✅ **Capturar `curl_error()`, `curl_errno()`, e código HTTP**
- ✅ **Não depender de `error_get_last()`**

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Status:** ✅ Análise completa - Problema identificado

