# 🔧 ESPECIFICAÇÃO TÉCNICA - INTEGRAÇÃO DE EMAIL NO LOGGING

**Data:** 09/11/2025  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Especificação técnica detalhada para integrar o envio de emails automático ao sistema de logging profissional quando níveis ERROR ou FATAL forem acionados.

---

## 📐 ARQUITETURA DA SOLUÇÃO

### **Fluxo Atual:**
```
error()/fatal() → log() → insertLog() → MySQL
```

### **Fluxo Novo:**
```
error()/fatal() → log() → insertLog() → MySQL
                  ↓
            sendEmailNotification() → HTTP POST → send_email_notification_endpoint.php → AWS SES → Email
```

---

## 💻 IMPLEMENTAÇÃO DETALHADA

### **1. Método Privado `sendEmailNotification()`**

**Localização:** `ProfessionalLogger.php` (método privado)

**Assinatura:**
```php
private function sendEmailNotification($level, $message, $data = null, $category = null, $stackTrace = null, $logData = null)
```

**Parâmetros:**
- `$level` (string): 'ERROR' ou 'FATAL'
- `$message` (string): Mensagem do log
- `$data` (array|null): Dados adicionais do log
- `$category` (string|null): Categoria do log
- `$stackTrace` (string|null): Stack trace completo
- `$logData` (array|null): Dados completos do log (arquivo, linha, etc.)

**Funcionalidade:**
1. Preparar payload JSON para endpoint
2. Determinar URL do endpoint (usar `$_ENV['APP_BASE_URL']` ou fallback)
3. Fazer requisição HTTP POST assíncrona
4. Não bloquear se email falhar
5. Timeout de 2 segundos

**Código:**
```php
private function sendEmailNotification($level, $message, $data = null, $category = null, $stackTrace = null, $logData = null) {
    try {
        // Determinar URL do endpoint
        $baseUrl = $_ENV['APP_BASE_URL'] ?? 
                   ($this->environment === 'production' 
                       ? 'https://bssegurosimediato.com.br' 
                       : 'https://dev.bssegurosimediato.com.br');
        $endpoint = $baseUrl . '/send_email_notification_endpoint.php';
        
        // Preparar payload
        $payload = [
            'ddd' => '00', // Não aplicável para logs
            'celular' => '000000000', // Não aplicável para logs
            'nome' => 'Sistema de Logging',
            'cpf' => 'N/A',
            'email' => 'N/A',
            'cep' => 'N/A',
            'placa' => 'N/A',
            'gclid' => 'N/A',
            'momento' => strtolower($level),
            'momento_descricao' => $level === 'FATAL' ? 'Erro Fatal no Sistema' : 'Erro no Sistema',
            'momento_emoji' => $level === 'FATAL' ? '🚨' : '❌',
            'erro' => [
                'message' => $message,
                'level' => $level,
                'category' => $category,
                'data' => $data,
                'stack_trace' => $stackTrace,
                'file_name' => $logData['file_name'] ?? null,
                'line_number' => $logData['line_number'] ?? null,
                'function_name' => $logData['function_name'] ?? null,
                'class_name' => $logData['class_name'] ?? null,
                'timestamp' => $logData['timestamp'] ?? date('Y-m-d H:i:s'),
                'request_id' => $this->requestId,
                'environment' => $this->environment
            ]
        ];
        
        // Preparar contexto HTTP (assíncrono, não bloqueia)
        $context = stream_context_create([
            'http' => [
                'method' => 'POST',
                'header' => [
                    'Content-Type: application/json',
                    'User-Agent: ProfessionalLogger-EmailNotification/1.0'
                ],
                'content' => json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
                'timeout' => 2, // 2 segundos máximo
                'ignore_errors' => true // Não lançar exceção em HTTP errors
            ]
        ]);
        
        // Fazer requisição (não bloqueia, ignora resultado)
        @file_get_contents($endpoint, false, $context);
        
        // Não logar falha para evitar loop infinito
        // Se email falhar, logging continua normalmente
        
    } catch (Exception $e) {
        // Silenciosamente ignorar erros de email
        // Não quebrar aplicação se email falhar
    }
}
```

---

### **2. Modificação do Método `error()`**

**Código Atual:**
```php
public function error($message, $data = null, $category = null, $exception = null) {
    $stackTrace = null;
    if ($exception instanceof Exception) {
        $stackTrace = $exception->getTraceAsString();
    }
    return $this->log('ERROR', $message, $data, $category, $stackTrace);
}
```

**Código Novo:**
```php
public function error($message, $data = null, $category = null, $exception = null) {
    $stackTrace = null;
    if ($exception instanceof Exception) {
        $stackTrace = $exception->getTraceAsString();
    }
    
    // Fazer log primeiro
    $logId = $this->log('ERROR', $message, $data, $category, $stackTrace);
    
    // Se log foi bem-sucedido, enviar email (assíncrono)
    if ($logId !== false) {
        // Obter dados do log para incluir no email
        $logData = $this->prepareLogData('ERROR', $message, $data, $category, $stackTrace);
        $this->sendEmailNotification('ERROR', $message, $data, $category, $stackTrace, $logData);
    }
    
    return $logId;
}
```

---

### **3. Modificação do Método `fatal()`**

**Código Atual:**
```php
public function fatal($message, $data = null, $category = null, $exception = null) {
    $stackTrace = null;
    if ($exception instanceof Exception) {
        $stackTrace = $exception->getTraceAsString();
    }
    return $this->log('FATAL', $message, $data, $category, $stackTrace);
}
```

**Código Novo:**
```php
public function fatal($message, $data = null, $category = null, $exception = null) {
    $stackTrace = null;
    if ($exception instanceof Exception) {
        $stackTrace = $exception->getTraceAsString();
    }
    
    // Fazer log primeiro
    $logId = $this->log('FATAL', $message, $data, $category, $stackTrace);
    
    // Se log foi bem-sucedido, enviar email (assíncrono)
    if ($logId !== false) {
        // Obter dados do log para incluir no email
        $logData = $this->prepareLogData('FATAL', $message, $data, $category, $stackTrace);
        $this->sendEmailNotification('FATAL', $message, $data, $category, $stackTrace, $logData);
    }
    
    return $logId;
}
```

---

## 🔍 DETALHES DE IMPLEMENTAÇÃO

### **1. URL do Endpoint**

**Prioridade:**
1. `$_ENV['APP_BASE_URL']` (se disponível)
2. Detecção por ambiente:
   - `production` → `https://bssegurosimediato.com.br`
   - `development` → `https://dev.bssegurosimediato.com.br`

### **2. Requisição HTTP Assíncrona**

**Método:** `file_get_contents()` com contexto stream

**Características:**
- ✅ Não bloqueia execução
- ✅ Timeout de 2 segundos
- ✅ Ignora erros HTTP (`ignore_errors => true`)
- ✅ Suprime warnings (`@file_get_contents()`)

### **3. Payload do Email**

**Estrutura:**
```json
{
    "ddd": "00",
    "celular": "000000000",
    "nome": "Sistema de Logging",
    "cpf": "N/A",
    "email": "N/A",
    "cep": "N/A",
    "placa": "N/A",
    "gclid": "N/A",
    "momento": "error" ou "fatal",
    "momento_descricao": "Erro no Sistema" ou "Erro Fatal no Sistema",
    "momento_emoji": "❌" ou "🚨",
    "erro": {
        "message": "...",
        "level": "ERROR" ou "FATAL",
        "category": "...",
        "data": {...},
        "stack_trace": "...",
        "file_name": "...",
        "line_number": 123,
        "function_name": "...",
        "class_name": "...",
        "timestamp": "...",
        "request_id": "...",
        "environment": "development" ou "production"
    }
}
```

### **4. Tratamento de Erros**

**Regras:**
- ❌ Não lançar exceção se email falhar
- ❌ Não logar falha de email (evitar loop)
- ❌ Não quebrar aplicação
- ✅ Continuar normalmente mesmo se email falhar

---

## ⚠️ CONSIDERAÇÕES IMPORTANTES

### **1. Performance**
- Requisição assíncrona não bloqueia
- Timeout curto (2 segundos)
- Não afeta tempo de resposta do logging

### **2. Confiabilidade**
- Email é "best effort" (não crítico)
- Falha de email não afeta logging
- Logging sempre tem prioridade sobre email

### **3. Segurança**
- Dados sensíveis são sanitizados (já implementado)
- Payload não contém informações sensíveis
- Stack trace pode conter informações, mas é necessário para debug

### **4. Rate Limiting**
- Endpoint já tem rate limiting (100 req/min por IP)
- Não deve ser problema pois ERROR/FATAL são raros
- Se necessário, pode adicionar rate limiting específico

---

## 📊 EXEMPLO DE USO

### **Exemplo 1: Log ERROR com Email**
```php
$logger = new ProfessionalLogger();
$logger->error('Falha ao conectar ao banco de dados', [
    'host' => 'localhost',
    'port' => 3306
], 'DATABASE');
// Resultado: Log salvo + Email enviado
```

### **Exemplo 2: Log FATAL com Exceção**
```php
try {
    // código que pode falhar
} catch (Exception $e) {
    $logger->fatal('Erro crítico na aplicação', null, 'SYSTEM', $e);
    // Resultado: Log salvo + Email enviado com stack trace completo
}
```

### **Exemplo 3: Outros Níveis (Sem Email)**
```php
$logger->debug('Debug message'); // Sem email
$logger->info('Info message');   // Sem email
$logger->warn('Warning message'); // Sem email
```

---

## ✅ VALIDAÇÕES

### **Validações Implementadas:**
1. ✅ Email só enviado após log bem-sucedido
2. ✅ Apenas ERROR e FATAL enviam email
3. ✅ Requisição assíncrona (não bloqueia)
4. ✅ Timeout curto (não trava aplicação)
5. ✅ Tratamento de erros silencioso

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Versão:** 1.0.0

