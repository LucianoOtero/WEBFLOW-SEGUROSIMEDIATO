# 📋 Lista Precisa: Chamadas de `ProfessionalLogger->insertLog()`

**Data:** 17/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA**  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Listar **PRECISAMENTE** todas as chamadas da função `ProfessionalLogger->insertLog()` em todos os arquivos do projeto, incluindo:
- Arquivo
- Linha exata
- Contexto
- Código completo da chamada

---

## 📊 CHAMADAS IDENTIFICADAS

### **1. `log_endpoint.php` - 1 Chamada Indireta (Via `$logger->log()`)**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`  
**Linha:** **445**  
**Contexto:** Chamada via método `log()` após criar instância do logger

**Código Completo:**
```php
try {
    $logger = new ProfessionalLogger();
    logDebug("ProfessionalLogger instance created", [
        'request_id' => $logger->getRequestId()
    ]);
} catch (Exception $e) {
    // ... tratamento de erro ...
}

// ... código intermediário (validação, preparação de dados) ...

// Linha 445:
try {
    $logStartTime = microtime(true);
    $logId = $logger->log($level, $message, $data, $category, $stackTrace, $jsFileInfo);  // ← LINHA 445
    $logDuration = microtime(true) - $logStartTime;
    logDebug("logger->log() returned", [
        'log_id' => $logId,
        'duration_ms' => round($logDuration * 1000, 2),
        // ...
    ]);
} catch (Exception $e) {
    // ... tratamento de erro ...
}
```

**Fluxo:**
- Recebe requisição HTTP POST de JavaScript
- Valida dados recebidos
- Prepara dados do log (`$level`, `$message`, `$data`, `$category`, `$stackTrace`, `$jsFileInfo`)
- Chama `$logger->log()` → que chama `insertLog()` internamente (linha 838 de `ProfessionalLogger.php`)

**Status:** ✅ **Chamada Indireta** (via método intermediário `log()`)

**Observação:** Esta é a chamada intermediária que recebe todas as requisições JavaScript via `log_endpoint.php`. Ela usa `log()` que internamente chama `insertLog()`.

---

### **2. `send_admin_notification_ses.php` - 4 Chamadas Diretas**

#### **Chamada 1: Linha 183**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_admin_notification_ses.php`  
**Linha:** **183**  
**Contexto:** Log de sucesso ao enviar email para um administrador específico

**Código Completo:**
```php
try {
    $result = $sesClient->sendEmail([...]);
    $results[] = [
        'email' => $adminEmail,
        'success' => true,
        'message_id' => $result['MessageId'],
    ];
    $successCount++;
    
    // Log de sucesso usando ProfessionalLogger
    try {
        require_once __DIR__ . '/ProfessionalLogger.php';
        $logger = ProfessionalLogger::getInstance();
        $logger->insertLog([                    // ← LINHA 183
            'level' => 'INFO',
            'category' => 'EMAIL',
            'message' => "SES: Email enviado com sucesso para {$adminEmail}",
            'data' => [
                'email' => $adminEmail,
                'message_id' => $result['MessageId']
            ]
        ]);
    } catch (Exception $logException) {
        // Fallback para error_log se ProfessionalLogger falhar
        error_log("✅ SES: Email enviado com sucesso para {$adminEmail} - MessageId: {$result['MessageId']}");
    }
    
} catch (\Aws\Exception\AwsException $e) {
    // ... tratamento de erro ...
}
```

**Status:** ✅ **Chamada Direta** (dentro de try-catch)

---

#### **Chamada 2: Linha 210**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_admin_notification_ses.php`  
**Linha:** **210**  
**Contexto:** Log de erro ao enviar email para um administrador específico

**Código Completo:**
```php
} catch (\Aws\Exception\AwsException $e) {
    $results[] = [
        'email' => $adminEmail,
        'success' => false,
        'error' => $e->getAwsErrorMessage(),
        'code' => $e->getAwsErrorCode(),
    ];
    $failCount++;
    
    // Log de erro usando ProfessionalLogger
    try {
        require_once __DIR__ . '/ProfessionalLogger.php';
        $logger = ProfessionalLogger::getInstance();
        $logger->insertLog([                    // ← LINHA 210
            'level' => 'ERROR',
            'category' => 'EMAIL',
            'message' => "SES: Erro ao enviar para {$adminEmail}",
            'data' => [
                'email' => $adminEmail,
                'error_code' => $e->getAwsErrorCode(),
                'error_message' => $e->getAwsErrorMessage()
            ]
        ]);
    } catch (Exception $logException) {
        // Fallback para error_log se ProfessionalLogger falhar
        error_log("❌ SES: Erro ao enviar para {$adminEmail} - {$e->getAwsErrorCode()}: {$e->getAwsErrorMessage()}");
    }
}
```

**Status:** ✅ **Chamada Direta** (dentro de try-catch)

---

#### **Chamada 3: Linha 241**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_admin_notification_ses.php`  
**Linha:** **241**  
**Contexto:** Log de erro na configuração/cliente SES

**Código Completo:**
```php
} catch (\Aws\Exception\AwsException $e) {
    // Log de erro usando ProfessionalLogger
    try {
        require_once __DIR__ . '/ProfessionalLogger.php';
        $logger = ProfessionalLogger::getInstance();
        $logger->insertLog([                    // ← LINHA 241
            'level' => 'ERROR',
            'category' => 'EMAIL',
            'message' => "SES: Erro na configuração/cliente",
            'data' => [
                'error_code' => $e->getAwsErrorCode(),
                'error_message' => $e->getAwsErrorMessage()
            ]
        ]);
    } catch (Exception $logException) {
        // Fallback para error_log se ProfessionalLogger falhar
        error_log("❌ SES: Erro na configuração/cliente - {$e->getAwsErrorCode()}: {$e->getAwsErrorMessage()}");
    }
    return [
        'success' => false,
        'error' => $e->getAwsErrorMessage(),
        'code' => $e->getAwsErrorCode(),
    ];
}
```

**Status:** ✅ **Chamada Direta** (dentro de try-catch)

---

#### **Chamada 4: Linha 264**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_admin_notification_ses.php`  
**Linha:** **264**  
**Contexto:** Log de erro geral na função

**Código Completo:**
```php
} catch (Exception $e) {
    // Log de erro usando ProfessionalLogger
    try {
        require_once __DIR__ . '/ProfessionalLogger.php';
        $logger = ProfessionalLogger::getInstance();
        $logger->insertLog([                    // ← LINHA 264
            'level' => 'ERROR',
            'category' => 'EMAIL',
            'message' => "SES: Erro geral",
            'data' => [
                'error_message' => $e->getMessage()
            ]
        ]);
    } catch (Exception $logException) {
        // Fallback para error_log se ProfessionalLogger falhar
        error_log("❌ SES: Erro geral - {$e->getMessage()}");
    }
    return [
        'success' => false,
        'error' => $e->getMessage(),
    ];
}
```

**Status:** ✅ **Chamada Direta** (dentro de try-catch)

---

### **3. `send_email_notification_endpoint.php` - 2 Chamadas Via Métodos Intermediários**

#### **Chamada 1: Linha 118 (Via `$logger->log()`)**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_email_notification_endpoint.php`  
**Linha:** **118**  
**Contexto:** Log de sucesso no envio de email para administradores

**Código Completo:**
```php
// Enviar email
$result = enviarNotificacaoAdministradores($emailData);

// Log de resultado usando sistema profissional
$logLevel = $result['success'] ? 'INFO' : 'WARN';

// FASE 8: Verificar parametrização antes de logar
if (LogConfig::shouldLog($logLevel, 'EMAIL')) {
    $logMessage = sprintf(
        "[EMAIL-ENDPOINT] Momento: %s | DDD: %s | Celular: %s*** | Sucesso: %s | Erro: %s",
        $emailData['momento'],
        $ddd,
        substr($celular, 0, 3),
        $result['success'] ? 'SIM' : 'NÃO',
        ($emailData['erro'] !== null) ? 'SIM' : 'NÃO'
    );
    $logger->log($logLevel, $logMessage, [     // ← LINHA 118
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

**Fluxo:**
- `$logger->log()` → chama `insertLog()` internamente (linha 838 de `ProfessionalLogger.php`)

**Status:** ✅ **Chamada Indireta** (via método intermediário `log()`)

---

#### **Chamada 2: Linha 139 (Via `$logger->error()`)**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_email_notification_endpoint.php`  
**Linha:** **139**  
**Contexto:** Log de erro no envio de email

**Código Completo:**
```php
} catch (Exception $e) {
    // Log de erro usando sistema profissional
    // FASE 8: Verificar parametrização antes de logar
    if (isset($logger) && LogConfig::shouldLog('ERROR', 'EMAIL')) {
        $logger->error("[EMAIL-ENDPOINT] Erro: " . $e->getMessage(), [  // ← LINHA 139
            'exception' => get_class($e),
            'file' => $e->getFile(),
            'line' => $e->getLine()
        ], 'EMAIL', $e);
    } else {
        // Fallback: sempre logar erros críticos no error_log mesmo se parametrização desabilitar
        error_log("[EMAIL-ENDPOINT] Erro: " . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
```

**Fluxo:**
- `$logger->error()` → chama `log()` → chama `insertLog()` internamente (linha 838 de `ProfessionalLogger.php`)

**Status:** ✅ **Chamada Indireta** (via método intermediário `error()` → `log()`)

---

### **4. `ProfessionalLogger.php` - 1 Chamada Interna (Recursiva)**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`  
**Linha:** **838**  
**Contexto:** Método `log()` que chama `insertLog()` internamente

**Código Completo:**
```php
/**
 * Método genérico de log
 */
public function log($level, $message, $data = null, $category = null, $stackTrace = null, $jsFileInfo = null) {
    $logData = $this->prepareLogData($level, $message, $data, $category, $stackTrace, $jsFileInfo);
    return $this->insertLog($logData);          // ← LINHA 838
}
```

**Status:** ✅ **Chamada Interna** (método `log()` chama `insertLog()`)

**Observação:** Esta é uma chamada interna do próprio `ProfessionalLogger`. Métodos como `error()`, `warn()`, `info()`, `debug()` também chamam `log()`, que por sua vez chama `insertLog()`.

---

## 📊 RESUMO PRECISO

### **Chamadas Diretas de `insertLog()`:**

| # | Arquivo | Linha | Contexto | Tipo |
|---|---------|-------|----------|------|
| 1 | `send_admin_notification_ses.php` | **183** | Sucesso ao enviar email para admin | Direta |
| 2 | `send_admin_notification_ses.php` | **210** | Erro ao enviar email para admin | Direta |
| 3 | `send_admin_notification_ses.php` | **241** | Erro na configuração/cliente SES | Direta |
| 4 | `send_admin_notification_ses.php` | **264** | Erro geral na função | Direta |

**Total de Chamadas Diretas:** **4 chamadas**

---

### **Chamadas Indiretas (Via Métodos Intermediários):**

| # | Arquivo | Linha | Método Intermediário | Contexto |
|---|---------|-------|----------------------|----------|
| 5 | `log_endpoint.php` | **445** | `$logger->log()` | Intermediário para requisições JS |
| 6 | `send_email_notification_endpoint.php` | **118** | `$logger->log()` | Sucesso no envio de email |
| 7 | `send_email_notification_endpoint.php` | **139** | `$logger->error()` → `log()` | Erro no envio de email |

**Total de Chamadas Indiretas:** **3 chamadas**

---

### **Chamada Interna (Recursiva):**

| # | Arquivo | Linha | Contexto |
|---|---------|-------|----------|
| 8 | `ProfessionalLogger.php` | **838** | Método `log()` chama `insertLog()` |

**Total de Chamadas Internas:** **1 chamada**

---

## 📊 TOTAL GERAL

### **Resumo:**

- **Chamadas Diretas:** 4
- **Chamadas Indiretas:** 3
- **Chamadas Internas:** 1
- **TOTAL:** **8 chamadas** (4 diretas + 3 indiretas + 1 interna)

---

## 🔍 DETALHAMENTO POR ARQUIVO

### **`log_endpoint.php`:**
- ✅ **1 chamada indireta** (linha 445 via `log()`)

### **`send_admin_notification_ses.php`:**
- ✅ **4 chamadas diretas** (linhas 183, 210, 241, 264)

### **`send_email_notification_endpoint.php`:**
- ✅ **2 chamadas indiretas** (linhas 118, 139) via `log()` e `error()`

### **`ProfessionalLogger.php`:**
- ✅ **1 chamada interna** (linha 838) no método `log()`

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **1. Chamadas Condicionais:**

- Todas as chamadas em `send_admin_notification_ses.php` estão dentro de `try-catch` com fallback para `error_log()`
- Chamadas em `send_email_notification_endpoint.php` são condicionais (dependem de `LogConfig::shouldLog()`)

### **2. Fluxo de Chamadas:**

```
JavaScript:
  novo_log() → sendLogToProfessionalSystem() → fetch() → log_endpoint.php → insertLog() (linha 360)

PHP Direto:
  send_admin_notification_ses.php → insertLog() (linhas 183, 210, 241, 264)
  send_email_notification_endpoint.php → log() → insertLog() (linha 838) → insertLog() (linha 587)
```

### **3. Chamadas Recursivas:**

- `ProfessionalLogger->log()` chama `insertLog()` internamente (linha 838)
- Métodos como `error()`, `warn()`, `info()`, `debug()` chamam `log()`, que chama `insertLog()`

---

## ✅ CONCLUSÃO

### **Resposta Precisa:**

**Total de chamadas de `ProfessionalLogger->insertLog()`:**

- **4 chamadas diretas** em arquivos PHP
- **3 chamadas indiretas** via métodos intermediários
- **1 chamada interna** no próprio `ProfessionalLogger`
- **TOTAL: 8 chamadas**

### **Localizações Exatas:**

**Chamadas Diretas (4):**
1. ✅ `send_admin_notification_ses.php` - Linha **183**
2. ✅ `send_admin_notification_ses.php` - Linha **210**
3. ✅ `send_admin_notification_ses.php` - Linha **241**
4. ✅ `send_admin_notification_ses.php` - Linha **264**

**Chamadas Indiretas (3):**
5. ✅ `log_endpoint.php` - Linha **445** (via `log()`)
6. ✅ `send_email_notification_endpoint.php` - Linha **118** (via `log()`)
7. ✅ `send_email_notification_endpoint.php` - Linha **139** (via `error()` → `log()`)

**Chamada Interna (1):**
8. ✅ `ProfessionalLogger.php` - Linha **838** (método `log()` chama `insertLog()`)

---

**Análise concluída em:** 17/11/2025  
**Versão do documento:** 1.0.0

