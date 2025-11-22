# 🔄 FLUXO COMPLETO: Chamada do insertLog() via Endpoint

**Data:** 16/11/2025  
**Objetivo:** Documentar o fluxo completo de como o JavaScript chama `insertLog()` via endpoint  
**Status:** ✅ **DOCUMENTAÇÃO CONCLUÍDA**

---

## ❓ PERGUNTA DO USUÁRIO

**"A chamada do insertLog() será por um endpoint acessado pelo javascript?"**

---

## ✅ RESPOSTA DIRETA

### **SIM, correto!**

**A chamada do `insertLog()` é feita INDIRETAMENTE através do endpoint `log_endpoint.php` acessado pelo JavaScript.**

---

## 📊 FLUXO COMPLETO

### **1. JavaScript (Navegador) → Endpoint PHP**

```
┌─────────────────────────────────────────────────────────────┐
│ JavaScript (Navegador)                                      │
│                                                              │
│ logClassified('INFO', 'TEST', 'Mensagem de teste')         │
│         │                                                     │
│         ├─→ console.log('[TEST] Mensagem de teste')         │
│         │   ✅ Aparece no Console do Navegador (F12)        │
│         │                                                     │
│         └─→ sendLogToProfessionalSystem(                    │
│             'INFO',                                          │
│             'TEST',                                          │
│             'Mensagem de teste',                            │
│             null                                             │
│         )                                                     │
│             │                                                 │
│             └─→ HTTP POST → log_endpoint.php                 │
│                 │                                             │
│                 │ URL: window.APP_BASE_URL + '/log_endpoint.php'
│                 │ Method: POST                                │
│                 │ Headers: { 'Content-Type': 'application/json' }
│                 │ Body: {                                     │
│                 │   level: 'INFO',                              │
│                 │   category: 'TEST',                     │
│                 │   message: 'Mensagem de teste',             │
│                 │   data: null,                               │
│                 │   session_id: '...',                        │
│                 │   url: 'https://...',                       │
│                 │   stack_trace: '...',                       │
│                 │   file_name: '...',                         │
│                 │   line_number: ...                           │
│                 │ }                                           │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
```

### **2. Endpoint PHP (log_endpoint.php) → ProfessionalLogger**

```
┌─────────────────────────────────────────────────────────────┐
│ PHP (Servidor) - log_endpoint.php                           │
│                                                              │
│ Recebe HTTP POST do JavaScript                              │
│         │                                                     │
│         ├─→ Valida requisição (POST, JSON válido)           │
│         ├─→ Extrai dados do JSON:                            │
│         │   - level: 'INFO'                                   │
│         │   - category: 'TEST'                                │
│         │   - message: 'Mensagem de teste'                  │
│         │   - data: null                                     │
│         │   - stack_trace: '...'                             │
│         │   - file_name: '...'                               │
│         │   - line_number: ...                               │
│         │                                                     │
│         └─→ Instancia ProfessionalLogger                     │
│             $logger = new ProfessionalLogger();               │
│                 │                                             │
│                 └─→ Chama método público:                    │
│                     $logger->log(                             │
│                         'INFO',                               │
│                         'Mensagem de teste',                  │
│                         null,                                 │
│                         'TEST',                               │
│                         '...',  // stack_trace                │
│                         [...]   // jsFileInfo                 │
│                     )                                         │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
```

### **3. ProfessionalLogger->log() → insertLog()**

```
┌─────────────────────────────────────────────────────────────┐
│ PHP (Servidor) - ProfessionalLogger                         │
│                                                              │
│ ProfessionalLogger->log('INFO', 'Mensagem de teste', ...)   │
│         │                                                     │
│         ├─→ prepareLogData()                                 │
│         │   - Gera log_id único                              │
│         │   - Prepara estrutura completa do log              │
│         │   - Captura informações do caller                   │
│         │   - Sanitiza dados                                 │
│         │                                                     │
│         └─→ insertLog($logData)                              │
│             │                                                 │
│             └─→ Método PRIVADO (não acessível diretamente)   │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
```

### **4. insertLog() → Banco + Arquivo + error_log()**

```
┌─────────────────────────────────────────────────────────────┐
│ PHP (Servidor) - ProfessionalLogger->insertLog()            │
│                                                              │
│ insertLog($logData)                                         │
│         │                                                     │
│         ├─→ connect() → PDO connection                       │
│         │   ✅ Se conexão OK: continua                       │
│         │   ❌ Se conexão falhar: vai para fallback          │
│         │                                                     │
│         ├─→ INSERT INTO application_logs (...)               │
│         │   ✅ Se inserção OK: retorna log_id                │
│         │   ❌ Se inserção falhar: vai para fallback         │
│         │                                                     │
│         ├─→ FALLBACK (se banco falhar):                     │
│         │   insertLogToFile($logData, $exception)            │
│         │   - Salva em professional_logger_fallback.txt      │
│         │                                                     │
│         └─→ error_log() (SEMPRE, sucesso ou falha)          │
│             - Aparece nos logs do servidor PHP               │
│             - Visível via tail -f /var/log/php/error.log     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 RESUMO DO FLUXO

### **Cadeia de Chamadas:**

```
JavaScript (Navegador)
    │
    └─→ sendLogToProfessionalSystem()
        │
        └─→ HTTP POST → log_endpoint.php
            │
            └─→ ProfessionalLogger->log()
                │
                └─→ ProfessionalLogger->insertLog() (PRIVADO)
                    │
                    ├─→ Banco de dados (INSERT INTO application_logs)
                    ├─→ Arquivo (se banco falhar)
                    └─→ error_log() (sempre)
```

---

## ✅ PONTOS IMPORTANTES

### **1. Endpoint é OBRIGATÓRIO**

**Por quê?**
- ✅ JavaScript roda no **navegador** (cliente)
- ✅ PHP roda no **servidor** (backend)
- ✅ JavaScript **NÃO pode chamar funções PHP diretamente**
- ✅ **Única forma:** HTTP Request (POST) para endpoint PHP

### **2. Endpoint Atual: `log_endpoint.php`**

**Localização:**
- ✅ `https://dev.bssegurosimediato.com.br/log_endpoint.php` (DEV)
- ✅ `https://prod.bssegurosimediato.com.br/log_endpoint.php` (PROD)

**Como é chamado:**
```javascript
// JavaScript
const endpoint = window.APP_BASE_URL + '/log_endpoint.php';
fetch(endpoint, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
        level: 'INFO',
        category: 'TEST',
        message: 'Mensagem de teste',
        data: null,
        // ... outros campos
    })
});
```

### **3. `insertLog()` é PRIVADO**

**Por quê?**
- ✅ `insertLog()` é método **PRIVADO** da classe `ProfessionalLogger`
- ✅ **NÃO pode ser chamado diretamente** do JavaScript
- ✅ **NÃO pode ser chamado diretamente** de outros arquivos PHP
- ✅ **Só pode ser chamado** internamente pela própria classe `ProfessionalLogger`

**Acesso:**
- ✅ **Direto:** `ProfessionalLogger->log()` / `info()` / `error()` / etc. (métodos públicos)
- ❌ **Indireto:** `ProfessionalLogger->insertLog()` (método privado)

### **4. Fluxo Completo (JavaScript → Banco)**

```
JavaScript
    │
    └─→ sendLogToProfessionalSystem()
        │
        └─→ HTTP POST → log_endpoint.php
            │
            └─→ ProfessionalLogger->log() (PÚBLICO)
                │
                └─→ ProfessionalLogger->insertLog() (PRIVADO)
                    │
                    ├─→ Banco: INSERT INTO application_logs
                    ├─→ Arquivo: professional_logger_fallback.txt (se falhar)
                    └─→ error_log() (sempre)
```

---

## 📋 CÓDIGO RELEVANTE

### **JavaScript (sendLogToProfessionalSystem):**

```javascript
async function sendLogToProfessionalSystem(level, category, message, data) {
    // ...
    const endpoint = window.APP_BASE_URL + '/log_endpoint.php';
    
    const logData = {
        level: level,
        category: category,
        message: message,
        data: data,
        // ... outros campos
    };
    
    // HTTP POST para endpoint
    fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(logData)
    });
}
```

### **PHP (log_endpoint.php):**

```php
<?php
// Recebe POST do JavaScript
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);
    
    // Instancia ProfessionalLogger
    require_once __DIR__ . '/ProfessionalLogger.php';
    $logger = new ProfessionalLogger();
    
    // Chama método público (que internamente chama insertLog())
    $logId = $logger->log(
        $data['level'],
        $data['message'],
        $data['data'],
        $data['category'],
        $data['stack_trace'],
        $data['js_file_info']
    );
    
    // Retorna resposta JSON
    echo json_encode(['success' => true, 'log_id' => $logId]);
}
?>
```

### **PHP (ProfessionalLogger->insertLog):**

```php
class ProfessionalLogger {
    // Método PRIVADO - não pode ser chamado diretamente
    private function insertLog($logData) {
        $pdo = $this->connect();
        if ($pdo === null) {
            // Fallback para arquivo
            $this->insertLogToFile($logData, 'Connection failed');
            error_log("ProfessionalLogger FALLBACK: Connection failed");
            return false;
        }
        
        try {
            // INSERT no banco
            $sql = "INSERT INTO application_logs (...) VALUES (...)";
            $stmt = $pdo->prepare($sql);
            $result = $stmt->execute([...]);
            
            if ($result) {
                // Sucesso: error_log() + retorna log_id
                error_log("ProfessionalLogger SUCCESS: log_id={$logData['log_id']}");
                return $logData['log_id'];
            } else {
                // Falha: fallback para arquivo
                $this->insertLogToFile($logData, 'Insert failed');
                error_log("ProfessionalLogger FALLBACK: Insert failed");
                return false;
            }
        } catch (PDOException $e) {
            // Exceção: fallback para arquivo
            $this->insertLogToFile($logData, $e);
            error_log("ProfessionalLogger FALLBACK: " . $e->getMessage());
            return false;
        }
    }
}
```

---

## ✅ CONCLUSÃO

### **Resposta à pergunta:**

**"A chamada do insertLog() será por um endpoint acessado pelo javascript?"**

**✅ SIM, correto!**

**Fluxo:**
1. ✅ JavaScript chama `sendLogToProfessionalSystem()`
2. ✅ `sendLogToProfessionalSystem()` faz HTTP POST para `log_endpoint.php`
3. ✅ `log_endpoint.php` recebe POST e chama `ProfessionalLogger->log()` (método público)
4. ✅ `ProfessionalLogger->log()` internamente chama `insertLog()` (método privado)
5. ✅ `insertLog()` faz: banco + arquivo (fallback) + error_log()

**Por quê endpoint?**
- ✅ JavaScript roda no navegador (cliente)
- ✅ PHP roda no servidor (backend)
- ✅ JavaScript **NÃO pode chamar funções PHP diretamente**
- ✅ **Única forma:** HTTP Request (POST) para endpoint PHP

**Endpoint atual:**
- ✅ `log_endpoint.php` (já existe e funciona)

---

**Status:** ✅ **DOCUMENTAÇÃO CONCLUÍDA**  
**Última atualização:** 16/11/2025

