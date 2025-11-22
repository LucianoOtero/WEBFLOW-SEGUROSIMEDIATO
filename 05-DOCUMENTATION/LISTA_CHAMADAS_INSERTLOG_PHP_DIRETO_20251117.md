# 📋 Lista: Chamadas Diretas de `ProfessionalLogger->insertLog()` em PHP

**Data:** 17/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA**  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Listar **TODAS** as chamadas diretas de `ProfessionalLogger->insertLog()` em arquivos PHP (não via JavaScript → `log_endpoint.php`).

---

## 📊 CHAMADAS IDENTIFICADAS

### **1. `log_endpoint.php` - 1 Chamada (Intermediário)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`

**Linha:** ~360

**Código:**
```php
$logger = ProfessionalLogger::getInstance();
$result = $logger->insertLog($logData);
```

**Contexto:**
- ✅ Recebe requisições HTTP POST de JavaScript
- ✅ Valida dados recebidos
- ✅ Chama `insertLog()` para inserir no banco
- ⚠️ **É intermediário** - todas as chamadas JavaScript passam por aqui

**Status:** ✅ **Existente**

**Observação:** Esta chamada é o **ponto de entrada** para todas as requisições JavaScript. Não conta como chamada adicional, pois é o intermediário necessário.

---

### **2. `send_email_notification_endpoint.php` - 2 Chamadas (Via Métodos Intermediários)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_email_notification_endpoint.php`

**Chamadas Identificadas:**

#### **Chamada 1: Linha ~118 (Sucesso no envio de email)**

**Código:**
```php
// FASE 8: Verificar parametrização antes de logar
if (LogConfig::shouldLog($logLevel, 'EMAIL')) {
    $logger->log($logLevel, $logMessage, [
        'momento' => $emailData['momento'],
        'ddd' => $ddd,
        'celular_masked' => substr($celular, 0, 3) . '***',
        'success' => $result['success'],
        'has_error' => ($emailData['erro'] !== null),
        'total_sent' => $result['total_sent'] ?? 0,
        'total_failed' => $result['total_failed'] ?? 0
    ], 'EMAIL');
}
```

**Contexto:** Log de sucesso no envio de email para administradores

**Método:** `$logger->log()` → chama `insertLog()` internamente (linha 838 de `ProfessionalLogger.php`)

**Status:** ✅ **Existente** (via método intermediário)

---

#### **Chamada 2: Linha ~139 (Erro no envio de email)**

**Código:**
```php
} catch (Exception $e) {
    // Log de erro usando sistema profissional
    // FASE 8: Verificar parametrização antes de logar
    if (isset($logger) && LogConfig::shouldLog('ERROR', 'EMAIL')) {
        $logger->error("[EMAIL-ENDPOINT] Erro: " . $e->getMessage(), [
            'exception' => get_class($e),
            'file' => $e->getFile(),
            'line' => $e->getLine()
        ], 'EMAIL', $e);
    }
}
```

**Contexto:** Log de erro no envio de email

**Método:** `$logger->error()` → chama `insertLog()` internamente (via método `log()` na linha 838)

**Status:** ✅ **Existente** (via método intermediário)

---

**Total em `send_email_notification_endpoint.php`:** **2 chamadas** (condicionais, via métodos intermediários `log()` e `error()`)

---

### **3. `send_admin_notification_ses.php` - 4 Chamadas**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_admin_notification_ses.php`

**Chamadas Identificadas:**

#### **Chamada 1: Linha 183 (Sucesso no envio para um administrador)**

**Código:**
```php
$logger->insertLog([
    'level' => 'INFO',
    'category' => 'EMAIL',
    'message' => "Email enviado com sucesso para administrador",
    'data' => [
        'admin_email' => $adminEmail,
        'subject' => $subject,
        'success' => true
    ]
]);
```

**Contexto:** Log de sucesso ao enviar email para um administrador específico

**Status:** ✅ **Existente**

---

#### **Chamada 2: Linha 210 (Erro no envio para um administrador)**

**Código:**
```php
$logger->insertLog([
    'level' => 'ERROR',
    'category' => 'EMAIL',
    'message' => "Erro ao enviar email para administrador",
    'data' => [
        'admin_email' => $adminEmail,
        'error' => $e->getMessage(),
        'success' => false
    ]
]);
```

**Contexto:** Log de erro ao enviar email para um administrador específico

**Status:** ✅ **Existente**

---

#### **Chamada 3: Linha 241 (Resumo final de sucesso)**

**Código:**
```php
$logger->insertLog([
    'level' => 'INFO',
    'category' => 'EMAIL',
    'message' => "Notificação enviada com sucesso para todos os administradores",
    'data' => [
        'total_sent' => $successCount,
        'total_failed' => $failCount,
        'total_recipients' => count(ADMIN_EMAILS)
    ]
]);
```

**Contexto:** Log de resumo final quando todos os emails foram enviados com sucesso

**Status:** ✅ **Existente**

---

#### **Chamada 4: Linha 264 (Resumo final de erro)**

**Código:**
```php
$logger->insertLog([
    'level' => 'ERROR',
    'category' => 'EMAIL',
    'message' => "Erro ao enviar notificação para administradores",
    'data' => [
        'error' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'total_sent' => $successCount,
        'total_failed' => $failCount
    ]
]);
```

**Contexto:** Log de erro geral quando a função falha completamente

**Status:** ✅ **Existente**

---

**Total em `send_admin_notification_ses.php`:** **4 chamadas** (condicionais - dependem do fluxo)

---

### **4. Outros Arquivos PHP**

**Busca realizada:** Nenhuma outra chamada direta encontrada em outros arquivos PHP.

**Arquivos verificados:**
- ✅ `ProfessionalLogger.php` - Contém apenas a definição de `insertLog()`
- ✅ `config.php` - Não contém chamadas de `insertLog()`
- ✅ `aws_ses_config.php` - Não contém chamadas de `insertLog()`
- ✅ `email_template_loader.php` - Não contém chamadas de `insertLog()`

**Total em Outros PHP:** **0 chamadas**

---

## 📊 RESUMO

### **Chamadas Diretas em PHP:**

| Arquivo | Linha | Contexto | Quantidade |
|---------|-------|----------|------------|
| `log_endpoint.php` | ~360 | Intermediário (recebe requisições JS) | 1 |
| `send_email_notification_endpoint.php` | ~120, ~140 | Logs de sucesso/erro no envio de email | 2 |
| `send_admin_notification_ses.php` | 183, 210, 241, 264 | Logs de sucesso/erro por administrador e resumo | 4 |
| Outros PHP | - | Nenhuma encontrada | 0 |
| **TOTAL** | - | - | **7 chamadas** |

---

## ✅ CONCLUSÃO

### **Resposta:**

**Total de chamadas diretas de `ProfessionalLogger->insertLog()` em PHP:** **7 chamadas**

### **Detalhamento:**

1. ✅ **`log_endpoint.php`:** 1 chamada (intermediário para requisições JavaScript)
2. ✅ **`send_email_notification_endpoint.php`:** 2 chamadas (logs de sucesso/erro)
3. ✅ **`send_admin_notification_ses.php`:** 4 chamadas (logs detalhados de envio de email)

### **Observações:**

- ⚠️ **Chamadas Condicionais:** Todas as chamadas em `send_email_notification_endpoint.php` e `send_admin_notification_ses.php` são condicionais (dependem do fluxo de execução)
- ✅ **`log_endpoint.php`:** É intermediário - todas as 403 chamadas JavaScript passam por aqui antes de chegar a `insertLog()`
- ✅ **Total Real:** 7 chamadas diretas em PHP + 403 chamadas via JavaScript = **~410 chamadas totais**

---

**Análise concluída em:** 17/11/2025  
**Versão do documento:** 1.0.0

