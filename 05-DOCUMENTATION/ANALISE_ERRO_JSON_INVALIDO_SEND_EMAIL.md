# 🔍 ANÁLISE: Erro JSON Inválido em send_email_notification_endpoint.php

**Data:** 11/11/2025  
**Request ID:** `req_69139ce14e84a8.78944294`  
**Timestamp:** 2025-11-11 20:30:25.000000

---

## 📋 PROBLEMA IDENTIFICADO

### Erro Reportado

```
❌ ERROR
[EMAIL-ENDPOINT] Erro: JSON inválido: Syntax error
Arquivo: send_email_notification_endpoint.php:61
Request ID: req_69139ce14e84a8.78944294
```

### Contexto

- ✅ Email chegou (enviado com sucesso)
- ✅ Lead foi inserido no espoCRM
- ❌ Foi gerado um email de erro no endpoint de log

---

## 🔍 CAUSA RAIZ

### Fluxo do Problema

1. **ProfessionalLogger.php** detecta um erro (ERROR ou FATAL)
2. **ProfessionalLogger.php** tenta enviar notificação por email via `send_email_notification_endpoint.php`
3. **ProfessionalLogger.php** constrói um payload JSON com:
   - Dados do erro (`$data`)
   - Stack trace (`$stackTrace`)
   - Informações do log (`$logData`)
4. **ProfessionalLogger.php** usa `json_encode()` para serializar o payload
5. **ProfessionalLogger.php** envia via `file_get_contents()` com `stream_context_create()`
6. **send_email_notification_endpoint.php** recebe o JSON e tenta fazer `json_decode()`
7. ❌ **FALHA:** `json_decode()` retorna erro de sintaxe

### Possíveis Causas

1. **Dados não serializáveis:**
   - `$data` pode conter recursos PHP (file handles, database connections, etc.)
   - `$stackTrace` pode conter objetos ou recursos
   - `$logData` pode conter estruturas complexas não serializáveis

2. **JSON malformado:**
   - `json_encode()` pode falhar silenciosamente e retornar `false`
   - `file_get_contents()` pode enviar `false` como string `"false"` ou string vazia
   - Caracteres especiais não escapados corretamente

3. **Encoding issues:**
   - Caracteres especiais (emojis, acentos) podem causar problemas
   - UTF-8 malformado

---

## 🔧 SOLUÇÃO PROPOSTA

### 1. Validar JSON antes de enviar

No `ProfessionalLogger.php`, antes de enviar:

```php
$jsonPayload = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);

if ($jsonPayload === false) {
    // Logar erro e não enviar
    error_log("[ProfessionalLogger] Erro ao serializar JSON: " . json_last_error_msg());
    return;
}
```

### 2. Sanitizar dados antes de serializar

Converter recursos e objetos não serializáveis:

```php
// Sanitizar $data
if (is_resource($data)) {
    $data = '[Resource não serializável]';
} elseif (is_object($data)) {
    $data = '[Objeto não serializável: ' . get_class($data) . ']';
} elseif (is_array($data)) {
    $data = array_map(function($item) {
        if (is_resource($item)) {
            return '[Resource]';
        } elseif (is_object($item)) {
            return '[Objeto: ' . get_class($item) . ']';
        }
        return $item;
    }, $data);
}
```

### 3. Validar JSON recebido no endpoint

No `send_email_notification_endpoint.php`, adicionar validação mais robusta:

```php
$rawInput = file_get_contents('php://input');

// Verificar se o input não está vazio
if (empty($rawInput)) {
    throw new Exception('JSON vazio recebido');
}

// Tentar decodificar
$data = json_decode($rawInput, true);

if (json_last_error() !== JSON_ERROR_NONE) {
    // Logar o raw input para debug (limitado a 500 caracteres)
    $preview = substr($rawInput, 0, 500);
    error_log("[EMAIL-ENDPOINT] JSON inválido recebido. Preview: " . $preview);
    throw new Exception('JSON inválido: ' . json_last_error_msg());
}
```

### 4. Adicionar tratamento de erro no ProfessionalLogger

Capturar e logar erros sem causar loop:

```php
try {
    $result = @file_get_contents($endpoint, false, $context);
    
    if ($result === false) {
        $error = error_get_last();
        error_log("[ProfessionalLogger] Falha ao enviar email: " . ($error['message'] ?? 'Erro desconhecido'));
    }
} catch (Exception $e) {
    error_log("[ProfessionalLogger] Exceção ao enviar email: " . $e->getMessage());
}
```

---

## 📊 IMPACTO

### Severidade: **MÉDIA**

- ✅ Funcionalidade principal não afetada (email enviado, lead inserido)
- ❌ Email de erro gerado incorretamente
- ⚠️ Pode causar confusão nos administradores

### Frequência

- Ocorre quando `ProfessionalLogger` tenta enviar notificação de erro
- Depende da estrutura dos dados do erro

---

## ✅ AÇÃO RECOMENDADA

1. **Corrigir `ProfessionalLogger.php`:**
   - Validar JSON antes de enviar
   - Sanitizar dados não serializáveis
   - Adicionar tratamento de erro robusto

2. **Melhorar `send_email_notification_endpoint.php`:**
   - Adicionar validação mais robusta do JSON recebido
   - Logar preview do JSON inválido para debug

3. **Testar:**
   - Simular erro que aciona `ProfessionalLogger.sendEmailNotification()`
   - Verificar se JSON é válido
   - Confirmar que email é enviado corretamente

---

**Status:** 🔍 **ANÁLISE CONCLUÍDA - AGUARDANDO CORREÇÃO**

