# 🔍 ANÁLISE: Parâmetros Automáticos do insertLog()

**Data:** 16/11/2025  
**Objetivo:** Analisar se programa, linha e timestamp são capturados automaticamente ou precisam ser parâmetros  
**Status:** ✅ **ANÁLISE CONCLUÍDA**

---

## ❓ PERGUNTA DO USUÁRIO

**"Os parâmetros incluem o programa que chamou, a linha onde foi chamado e o timestamp?"**

---

## ✅ RESPOSTA DIRETA

### **✅ NÃO precisam ser parâmetros - são capturados AUTOMATICAMENTE!**

**Informações capturadas automaticamente:**
- ✅ **Programa (arquivo):** Capturado via `captureCallerInfo()` usando `debug_backtrace()`
- ✅ **Linha:** Capturado via `captureCallerInfo()` usando `debug_backtrace()`
- ✅ **Timestamp:** Gerado automaticamente em `prepareLogData()`
- ✅ **Função:** Capturado via `captureCallerInfo()` usando `debug_backtrace()`

**Parâmetros necessários:**
- ✅ `$level` - Nível do log (INFO, ERROR, etc.)
- ✅ `$message` - Mensagem do log
- ✅ `$data` - Dados adicionais (opcional)
- ✅ `$category` - Categoria do log (opcional)

**Parâmetros opcionais (para sobrescrever captura automática):**
- ⚠️ `$stackTrace` - Stack trace (opcional, capturado automaticamente se null)
- ⚠️ `$jsFileInfo` - Informações do JavaScript (opcional, apenas para logs vindos do JS)

---

## 📊 ANÁLISE DETALHADA

### **1. Captura Automática de Informações**

#### **`captureCallerInfo()` - Captura Automática:**

```php
private function captureCallerInfo() {
    $trace = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 10);
    
    // Ignorar chamadas dentro da própria classe ProfessionalLogger
    foreach ($trace as $frame) {
        // Pular frames da própria classe
        if (isset($frame['class']) && $frame['class'] === 'ProfessionalLogger') {
            continue;
        }
        
        // Retornar primeiro frame que não é da classe ProfessionalLogger
        return [
            'file_name' => basename($frame['file'] ?? 'unknown'),
            'file_path' => $frame['file'] ?? null,
            'line_number' => $frame['line'] ?? null,
            'function_name' => $frame['function'] ?? null,
            'class_name' => $frame['class'] ?? null
        ];
    }
    
    return [
        'file_name' => 'unknown',
        'file_path' => null,
        'line_number' => null,
        'function_name' => null,
        'class_name' => null
    ];
}
```

**O que captura automaticamente:**
- ✅ **Arquivo:** `$frame['file']` → `basename($frame['file'])` → `file_name`
- ✅ **Linha:** `$frame['line']` → `line_number`
- ✅ **Função:** `$frame['function']` → `function_name`
- ✅ **Classe:** `$frame['class']` → `class_name` (se aplicável)

---

### **2. Geração Automática de Timestamp**

#### **`prepareLogData()` - Gera Timestamp Automaticamente:**

```php
private function prepareLogData($level, $message, $data = null, $category = null, $stackTrace = null, $jsFileInfo = null) {
    // ...
    
    return [
        'log_id' => uniqid('log_', true) . '_' . microtime(true) . '_' . random_int(1000, 9999),
        'request_id' => $this->requestId,
        'timestamp' => date('Y-m-d H:i:s.u'),  // ✅ GERADO AUTOMATICAMENTE
        'client_timestamp' => isset($_SERVER['HTTP_X_CLIENT_TIMESTAMP']) 
            ? date('Y-m-d H:i:s.u', strtotime($_SERVER['HTTP_X_CLIENT_TIMESTAMP']))
            : null,
        'server_time' => microtime(true),  // ✅ GERADO AUTOMATICAMENTE
        // ...
        'file_name' => $callerInfo['file_name'],  // ✅ CAPTURADO AUTOMATICAMENTE
        'file_path' => $callerInfo['file_path'],  // ✅ CAPTURADO AUTOMATICAMENTE
        'line_number' => $callerInfo['line_number'],  // ✅ CAPTURADO AUTOMATICAMENTE
        'function_name' => $callerInfo['function_name'],  // ✅ CAPTURADO AUTOMATICAMENTE
        // ...
    ];
}
```

**O que é gerado automaticamente:**
- ✅ **Timestamp:** `date('Y-m-d H:i:s.u')` → Gerado no momento da chamada
- ✅ **Server Time:** `microtime(true)` → Timestamp Unix com microsegundos
- ✅ **Log ID:** `uniqid() + microtime() + random_int()` → ID único gerado automaticamente
- ✅ **Request ID:** `$this->requestId` → Gerado no construtor

---

### **3. Assinatura Proposta para `insertLog()`**

#### **Versão Simplificada (sem parâmetros de captura):**

```php
public function insertLog($level, $message, $data = null, $category = null) {
    // 1. Capturar informações automaticamente
    $callerInfo = $this->captureCallerInfo();  // ✅ Arquivo, linha, função capturados automaticamente
    $timestamp = date('Y-m-d H:i:s.u');  // ✅ Timestamp gerado automaticamente
    $serverTime = microtime(true);  // ✅ Server time gerado automaticamente
    
    // 2. Preparar dados do log
    $logData = $this->prepareLogData($level, $message, $data, $category, null, null);
    
    // 3. Inserir no banco + arquivo (fallback) + error_log()
    // ... resto do código existente
}
```

**Parâmetros necessários:**
- ✅ `$level` - 'INFO', 'ERROR', 'WARN', 'DEBUG', 'FATAL'
- ✅ `$message` - Mensagem do log
- ✅ `$data` - Dados adicionais (opcional)
- ✅ `$category` - Categoria do log (opcional)

**Capturado automaticamente:**
- ✅ **Arquivo:** Via `captureCallerInfo()` usando `debug_backtrace()`
- ✅ **Linha:** Via `captureCallerInfo()` usando `debug_backtrace()`
- ✅ **Função:** Via `captureCallerInfo()` usando `debug_backtrace()`
- ✅ **Timestamp:** Gerado automaticamente com `date('Y-m-d H:i:s.u')`
- ✅ **Server Time:** Gerado automaticamente com `microtime(true)`

---

## 📋 EXEMPLO DE USO

### **Uso Simples (tudo automático):**

```php
$logger = new ProfessionalLogger();
$logger->insertLog('INFO', 'Mensagem de log');
```

**O que é capturado automaticamente:**
- ✅ **Arquivo:** `add_flyingdonkeys.php` (arquivo que chamou)
- ✅ **Linha:** `123` (linha onde foi chamado)
- ✅ **Função:** `processWebhook()` (função que chamou)
- ✅ **Timestamp:** `2025-11-16 17:30:45.123456` (gerado automaticamente)
- ✅ **Server Time:** `1734457845.123456` (gerado automaticamente)

### **Uso com Dados:**

```php
$logger = new ProfessionalLogger();
$logger->insertLog('INFO', 'Evento processado', ['event_id' => 123], 'FLYINGDONKEYS');
```

**O que é capturado automaticamente:**
- ✅ **Arquivo:** `add_flyingdonkeys.php`
- ✅ **Linha:** `456`
- ✅ **Função:** `createLead()`
- ✅ **Timestamp:** `2025-11-16 17:30:45.123456`
- ✅ **Server Time:** `1734457845.123456`

---

## ✅ CONCLUSÃO

### **Resposta à pergunta:**

**"Os parâmetros incluem o programa que chamou, a linha onde foi chamado e o timestamp?"**

**✅ NÃO precisam ser parâmetros - são capturados AUTOMATICAMENTE!**

**Assinatura proposta:**
```php
public function insertLog($level, $message, $data = null, $category = null)
```

**Capturado automaticamente:**
- ✅ **Programa (arquivo):** Via `captureCallerInfo()` usando `debug_backtrace()`
- ✅ **Linha:** Via `captureCallerInfo()` usando `debug_backtrace()`
- ✅ **Timestamp:** Gerado automaticamente com `date('Y-m-d H:i:s.u')`
- ✅ **Função:** Via `captureCallerInfo()` usando `debug_backtrace()`
- ✅ **Server Time:** Gerado automaticamente com `microtime(true)`

**Vantagens:**
- ✅ **Simplicidade:** Não precisa passar informações que podem ser capturadas automaticamente
- ✅ **Confiabilidade:** Sempre captura informações corretas
- ✅ **Facilidade de uso:** Apenas 4 parâmetros (2 obrigatórios, 2 opcionais)

---

**Status:** ✅ **ANÁLISE CONCLUÍDA**  
**Resposta:** ✅ **NÃO precisam ser parâmetros - são capturados AUTOMATICAMENTE**  
**Última atualização:** 16/11/2025

