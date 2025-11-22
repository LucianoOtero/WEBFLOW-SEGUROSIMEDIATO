# 💾 FUNÇÕES QUE INSEREM REGISTROS NO BANCO DE DADOS

**Data:** 16/11/2025  
**Objetivo:** Identificar todas as funções que inserem registros no banco de dados  
**Status:** ✅ **ANÁLISE CONCLUÍDA**

---

## 🎯 OBJETIVO

Responder à pergunta: **"Qual função, ou quais funções, inserem registros no banco de dados?"**

---

## ✅ RESPOSTA DIRETA

### **Apenas 1 classe PHP insere diretamente no banco:**

**`ProfessionalLogger` (PHP)** - Classe em `ProfessionalLogger.php`

---

## 📊 ANÁLISE DETALHADA

### **1. ProfessionalLogger (PHP) - INSERE DIRETAMENTE NO BANCO**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Método principal que insere no banco:**
- **`insertLog()`** (método privado, linha ~400-500)
  - Executa `INSERT INTO application_logs`
  - Usa PDO para inserção
  - Retorna `log_id` do registro inserido

**Métodos públicos que chamam `insertLog()`:**
1. **`log()`** (método genérico, linha ~541)
   - Método base que todos os outros chamam
   - Parâmetros: `($level, $message, $data = null, $category = null, $stackTrace = null, $jsFileInfo = null)`

2. **`debug()`** (linha ~549)
   - Chama `log('DEBUG', ...)`

3. **`info()`** (linha ~556)
   - Chama `log('INFO', ...)`

4. **`warn()`** (linha ~563)
   - Chama `log('WARN', ...)`

5. **`error()`** (linha ~570)
   - Chama `log('ERROR', ...)`

6. **`fatal()`** (linha ~577)
   - Chama `log('FATAL', ...)`

**Código de inserção:**
```php
private function insertLog($logData) {
    // ... preparação de dados ...
    
    $sql = "INSERT INTO application_logs (
        level, category, message, data, 
        file_name, file_path, line_number, function_name, class_name,
        stack_trace, url, session_id, environment,
        ip_address, user_agent, metadata, tags,
        created_at
    ) VALUES (
        :level, :category, :message, :data,
        :file_name, :file_path, :line_number, :function_name, :class_name,
        :stack_trace, :url, :session_id, :environment,
        :ip_address, :user_agent, :metadata, :tags,
        NOW()
    )";
    
    $stmt = $this->pdo->prepare($sql);
    $stmt->execute($params);
    
    return $this->pdo->lastInsertId();
}
```

**Tabela de destino:**
- **`application_logs`** (banco de dados MySQL/MariaDB)

---

### **2. sendLogToProfessionalSystem() (JavaScript) - ENVIA PARA PHP**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Função:** `sendLogToProfessionalSystem()` (linha ~421-609)

**O que faz:**
- **NÃO insere diretamente no banco**
- Envia dados via HTTP POST para `/log_endpoint.php`
- Usa `fetch()` para requisição assíncrona

**Fluxo:**
```
sendLogToProfessionalSystem() (JavaScript)
         │
         │ (HTTP POST)
         ▼
log_endpoint.php (PHP)
         │
         │ (instancia)
         ▼
ProfessionalLogger (PHP)
         │
         │ (chama insertLog())
         ▼
INSERT INTO application_logs
```

**Código relevante:**
```javascript
async function sendLogToProfessionalSystem(level, category, message, data) {
    // ... validações ...
    
    const endpoint = window.APP_BASE_URL + '/log_endpoint.php';
    
    fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(logData)
    })
    // ...
}
```

---

### **3. log_endpoint.php (PHP) - RECEBE E DELEGA**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`

**O que faz:**
- Recebe requisições HTTP POST de `sendLogToProfessionalSystem()`
- Valida dados recebidos
- Instancia `ProfessionalLogger`
- Chama métodos de `ProfessionalLogger` (que inserem no banco)

**Código relevante:**
```php
require_once __DIR__ . '/ProfessionalLogger.php';

// ... validações ...

$logger = new ProfessionalLogger();

// Chamar método apropriado baseado no level
switch(strtoupper($logData['level'])) {
    case 'DEBUG':
        $logger->debug($logData['message'], $logData['data'], $logData['category']);
        break;
    case 'INFO':
        $logger->info($logData['message'], $logData['data'], $logData['category']);
        break;
    case 'WARN':
        $logger->warn($logData['message'], $logData['data'], $logData['category']);
        break;
    case 'ERROR':
        $logger->error($logData['message'], $logData['data'], $logData['category']);
        break;
    case 'FATAL':
        $logger->fatal($logData['message'], $logData['data'], $logData['category']);
        break;
    default:
        $logger->info($logData['message'], $logData['data'], $logData['category']);
}
```

**Observação:**
- `log_endpoint.php` **NÃO insere diretamente no banco**
- Apenas recebe dados e delega para `ProfessionalLogger`

---

## 📊 RESUMO

### **Funções que inserem diretamente no banco:**

| Função/Método | Arquivo | Tipo | Insere Diretamente? |
|---------------|---------|------|---------------------|
| **`ProfessionalLogger->insertLog()`** | `ProfessionalLogger.php` | PHP (privado) | ✅ **SIM** |
| **`ProfessionalLogger->log()`** | `ProfessionalLogger.php` | PHP (público) | ✅ **SIM** (via `insertLog()`) |
| **`ProfessionalLogger->debug()`** | `ProfessionalLogger.php` | PHP (público) | ✅ **SIM** (via `log()`) |
| **`ProfessionalLogger->info()`** | `ProfessionalLogger.php` | PHP (público) | ✅ **SIM** (via `log()`) |
| **`ProfessionalLogger->warn()`** | `ProfessionalLogger.php` | PHP (público) | ✅ **SIM** (via `log()`) |
| **`ProfessionalLogger->error()`** | `ProfessionalLogger.php` | PHP (público) | ✅ **SIM** (via `log()`) |
| **`ProfessionalLogger->fatal()`** | `ProfessionalLogger.php` | PHP (público) | ✅ **SIM** (via `log()`) |

### **Funções que enviam dados para inserção (indiretamente):**

| Função | Arquivo | Tipo | Insere Diretamente? |
|--------|---------|------|---------------------|
| **`sendLogToProfessionalSystem()`** | `FooterCodeSiteDefinitivoCompleto.js` | JavaScript | ❌ **NÃO** (envia HTTP POST) |
| **`log_endpoint.php`** | `log_endpoint.php` | PHP | ❌ **NÃO** (delega para `ProfessionalLogger`) |

---

## 🔄 FLUXO COMPLETO DE INSERÇÃO

### **Caminho 1: JavaScript → PHP → Banco**

```
Código JavaScript
    │
    │ (chama)
    ▼
sendLogToProfessionalSystem() (JavaScript)
    │
    │ (HTTP POST)
    ▼
log_endpoint.php (PHP)
    │
    │ (instancia e chama)
    ▼
ProfessionalLogger->info/error/warn/debug/fatal() (PHP)
    │
    │ (chama)
    ▼
ProfessionalLogger->log() (PHP)
    │
    │ (chama)
    ▼
ProfessionalLogger->insertLog() (PHP)
    │
    │ (executa SQL)
    ▼
INSERT INTO application_logs (MySQL/MariaDB)
```

### **Caminho 2: PHP Direto → Banco**

```
Código PHP
    │
    │ (instancia e chama)
    ▼
ProfessionalLogger->info/error/warn/debug/fatal() (PHP)
    │
    │ (chama)
    ▼
ProfessionalLogger->log() (PHP)
    │
    │ (chama)
    ▼
ProfessionalLogger->insertLog() (PHP)
    │
    │ (executa SQL)
    ▼
INSERT INTO application_logs (MySQL/MariaDB)
```

---

## 📋 TABELA DE DESTINO

**Tabela:** `application_logs`

**Banco de dados:**
- **DEV:** `rpa_logs_dev`
- **PROD:** `rpa_logs_prod`

**Estrutura (colunas principais):**
- `id` (AUTO_INCREMENT)
- `level` (DEBUG, INFO, WARN, ERROR, FATAL)
- `category` (ex: FLYINGDONKEYS, OCTADESK, MODAL, etc.)
- `message` (texto da mensagem)
- `data` (JSON com dados adicionais)
- `file_name`, `file_path`, `line_number`, `function_name`, `class_name`
- `stack_trace`
- `url`, `session_id`, `environment`
- `ip_address`, `user_agent`
- `metadata`, `tags`
- `created_at` (timestamp)

---

## ✅ CONCLUSÃO

### **Resposta direta:**

**Apenas 1 classe PHP insere diretamente no banco de dados:**

**`ProfessionalLogger`** (arquivo: `ProfessionalLogger.php`)

**Métodos que inserem:**
- `insertLog()` (privado - executa SQL)
- `log()` (público - chama `insertLog()`)
- `debug()`, `info()`, `warn()`, `error()`, `fatal()` (públicos - chamam `log()`)

**Funções que enviam dados (mas não inserem diretamente):**
- `sendLogToProfessionalSystem()` (JavaScript) - envia HTTP POST
- `log_endpoint.php` (PHP) - recebe e delega para `ProfessionalLogger`

**Tabela de destino:**
- `application_logs` (banco: `rpa_logs_dev` ou `rpa_logs_prod`)

---

**Status:** ✅ **ANÁLISE CONCLUÍDA**  
**Última atualização:** 16/11/2025

