# 🔍 EXPLICAÇÃO DETALHADA: Fluxo da Função de Log em PHP

**Data:** 18/11/2025  
**Arquivo Principal:** `ProfessionalLogger.php`  
**Versão:** 1.0.0

---

## 📋 VISÃO GERAL

O sistema de logging em PHP é centralizado na classe `ProfessionalLogger`, que substitui todas as outras funções de log e garante que **todos os logs** sejam:

1. ✅ Verificados contra parametrização (nível, categoria, destino)
2. ✅ Exibidos no console do servidor via `error_log()` (se configurado)
3. ✅ Inseridos no banco de dados via `insertLog()` (se configurado)
4. ✅ Salvos em arquivo de fallback quando banco está indisponível (se configurado)
5. ✅ Enviados por email para administradores quando nível é ERROR ou FATAL (após FASE 7)

---

## 🔄 FLUXO COMPLETO DA FUNÇÃO DE LOG EM PHP

### **Pontos de Entrada:**

1. **`log_endpoint.php`** - Recebe logs do JavaScript via HTTP POST
2. **`send_email_notification_endpoint.php`** - Loga operações de envio de email
3. **`send_admin_notification_ses.php`** - Loga operações de envio de email via SES
4. **Código PHP direto** - Qualquer código PHP pode chamar `ProfessionalLogger` diretamente

---

## 📊 FLUXO PASSO A PASSO

### **ETAPA 1: Inicialização do ProfessionalLogger**

**Código:**
```php
$logger = new ProfessionalLogger();
```

**⚠️ NOTA:** Atualmente, `ProfessionalLogger` não implementa padrão Singleton. Alguns arquivos (como `send_admin_notification_ses.php`) tentam usar `ProfessionalLogger::getInstance()`, mas esse método não existe. Cada instância cria um novo `requestId` e uma nova conexão PDO.

**O que acontece:**

1. ✅ **Construtor (`__construct()`):**
   - Gera `requestId` único: `uniqid('req_', true)`
   - Detecta ambiente: `development` ou `production` (via `$_ENV['PHP_ENV']`)
   - Carrega configuração do banco de dados (`loadConfig()`)

2. ✅ **Detecção de Ambiente (`detectEnvironment()`):**
   - Verifica `$_ENV['PHP_ENV']`
   - Retorna `'production'` se valor for `'production'` ou `'prod'`
   - Caso contrário, retorna `'development'`

3. ✅ **Carregamento de Configuração (`loadConfig()`):**
   - Detecta se está rodando em Docker (verifica `/.dockerenv`)
   - Se Docker: descobre gateway da rede Docker automaticamente
   - Se não Docker: usa `localhost`
   - Carrega configuração de variáveis de ambiente:
     - `LOG_DB_HOST` (padrão: gateway Docker ou localhost)
     - `LOG_DB_PORT` (padrão: 3306)
     - `LOG_DB_NAME` (padrão: `rpa_logs_dev`)
     - `LOG_DB_USER` (padrão: `rpa_logger_dev`)
     - `LOG_DB_PASS` (padrão: string vazia)
   - Configura opções PDO (charset utf8mb4, modo de erro, timeout, etc.)

---

### **ETAPA 2: Chamada de Método de Log**

**Métodos Disponíveis:**

1. **`log($level, $message, $data, $category, $stackTrace, $jsFileInfo)`** - Método genérico
2. **`debug($message, $data, $category)`** - Chama `log('DEBUG', ...)`
3. **`info($message, $data, $category)`** - Chama `log('INFO', ...)`
4. **`warn($message, $data, $category)`** - Chama `log('WARN', ...)`
5. **`error($message, $data, $category, $exception)`** - Chama `log('ERROR', ...)` + envia email
6. **`fatal($message, $data, $category, $exception)`** - Chama `log('FATAL', ...)` + envia email
7. **`insertLog($logData)`** - Inserção direta (público, usado por `send_admin_notification_ses.php`)

**Exemplo de Chamada:**
```php
// Via log_endpoint.php (recebe do JavaScript)
$logger->log('INFO', 'Mensagem', ['data' => 'adicional'], 'RPA', null, $jsFileInfo);

// Via código PHP direto
$logger->error('Erro crítico', ['code' => 500], 'SYSTEM', $exception);

// Via insertLog direto (send_admin_notification_ses.php)
$logger->insertLog([
    'log_id' => uniqid('log_', true),
    'level' => 'INFO',
    'message' => 'Email enviado',
    // ... outros campos
]);
```

---

### **ETAPA 3: Preparação de Dados (`prepareLogData()`)**

**O que acontece:**

1. ✅ **Captura de Informações do Chamador:**
   - Se `$jsFileInfo` foi fornecido (logs vindos do JavaScript): usa essas informações
   - Caso contrário: chama `captureCallerInfo()` para capturar automaticamente:
     - Arquivo PHP que chamou o log
     - Linha de código
     - Função/método que chamou
     - Classe (se aplicável)

2. ✅ **Captura de Informações do Cliente (`getClientInfo()`):**
   - URL da requisição
   - IP do cliente
   - User-Agent
   - Nome do servidor

3. ✅ **Sanitização de Dados (`sanitizeData()`):**
   - Remove recursos não serializáveis
   - Converte objetos não serializáveis em strings descritivas
   - Garante que dados possam ser convertidos para JSON

4. ✅ **Conversão de Dados para JSON:**
   - Arrays/objetos: converte para JSON
   - Strings: verifica se já é JSON válido, senão converte
   - Outros tipos: converte para JSON
   - Valida JSON antes de inserir
   - Limita tamanho a 10KB (trunca se necessário)

5. ✅ **Preparação do Array `$logData`:**
   - `log_id`: ID único gerado (`uniqid('log_', true) + timestamp + random`)
   - `request_id`: ID da requisição (gerado no construtor)
   - `timestamp`: Data/hora atual com microsegundos
   - `client_timestamp`: Timestamp do cliente (se fornecido via header)
   - `server_time`: Microtime do servidor
   - `level`: Nível do log (uppercase)
   - `category`: Categoria do log
   - `file_name`, `file_path`, `line_number`, `function_name`, `class_name`: Informações do chamador
   - `message`: Mensagem do log
   - `data`: Dados adicionais (JSON)
   - `stack_trace`: Stack trace completo (se fornecido)
   - `url`, `session_id`, `user_id`, `ip_address`, `user_agent`: Informações do cliente
   - `environment`: Ambiente (development/production)
   - `server_name`: Nome do servidor
   - `metadata`, `tags`: Campos adicionais (null por padrão)

**Retorno:** Array `$logData` completo pronto para inserção no banco

---

### **ETAPA 4: Verificação de Parametrização (`insertLog()` - Início)**

**Código:**
```php
public function insertLog($logData) {
    $level = $logData['level'] ?? 'INFO';
    $category = $logData['category'] ?? null;
    
    // Verificar se deve logar
    if (!LogConfig::shouldLog($level, $category)) {
        return false;
    }
    
    // Verificar destinos
    $shouldLogToConsole = LogConfig::shouldLogToConsole($level);
    $shouldLogToDatabase = LogConfig::shouldLogToDatabase($level);
    $shouldLogToFile = LogConfig::shouldLogToFile($level);
    
    // Se não deve logar em nenhum lugar, retornar
    if (!$shouldLogToConsole && !$shouldLogToDatabase && !$shouldLogToFile) {
        return false;
    }
}
```

**O que acontece:**

1. ✅ **Verificação Global (`LogConfig::shouldLog()`):**
   - Verifica se logging está habilitado (`LOG_ENABLED`)
   - Verifica nível mínimo (`LOG_LEVEL`)
   - Verifica exclusões por categoria (`LOG_EXCLUDE_CATEGORIES`)
   - Se qualquer verificação falhar, retorna `false` imediatamente

2. ✅ **Verificação de Destinos:**
   - `shouldLogToConsole`: Verifica se deve exibir no console (`LOG_CONSOLE_ENABLED` + `LOG_CONSOLE_MIN_LEVEL`)
   - `shouldLogToDatabase`: Verifica se deve salvar no banco (`LOG_DATABASE_ENABLED` + `LOG_DATABASE_MIN_LEVEL`)
   - `shouldLogToFile`: Verifica se deve salvar em arquivo (`LOG_FILE_ENABLED` + `LOG_FILE_MIN_LEVEL`)

3. ✅ **Retorno Antecipado:**
   - Se nenhum destino estiver habilitado, retorna `false` imediatamente (não processa mais nada)

---

### **ETAPA 5: Log no Console (`error_log()`)**

**Código:**
```php
if ($shouldLogToConsole) {
    $logMessage = "ProfessionalLogger [{$level}]";
    if ($category) {
        $logMessage .= " [{$category}]";
    }
    $logMessage .= ": " . ($logData['message'] ?? 'N/A');
    error_log($logMessage);
}
```

**O que acontece:**

- ✅ Se `shouldLogToConsole = true`, exibe mensagem formatada no error_log do PHP
- ✅ Formato: `ProfessionalLogger [LEVEL] [CATEGORY]: mensagem`
- ✅ Aparece nos logs do servidor (Nginx/PHP-FPM)

**Exemplo:**
```
ProfessionalLogger [ERROR] [RPA]: Erro ao processar requisição
```

---

### **ETAPA 6: Verificação de Destino Banco de Dados**

**Código:**
```php
if (!$shouldLogToDatabase) {
    return false; // Já logou no console se configurado
}
```

**O que acontece:**

- ✅ Se `shouldLogToDatabase = false`, retorna `false` imediatamente
- ✅ Log já foi exibido no console (se configurado), mas não será salvo no banco

---

### **ETAPA 7: Conexão com Banco de Dados (`connect()`)**

**Código:**
```php
$pdo = $this->connect();
if ($pdo === null) {
    // Fallback para arquivo
    if ($shouldLogToFile) {
        $this->logToFileFallback($logData, new Exception("Database connection failed"));
    }
    $this->logToFile("Database connection failed");
    return false;
}
```

**O que acontece:**

1. ✅ **Verificação de Conexão Existente:**
   - Se `$this->pdo !== null`, verifica se conexão ainda está válida (`SELECT 1`)
   - Se válida, retorna conexão existente
   - Se inválida, reseta `$this->pdo = null` e tenta reconectar

2. ✅ **Tentativa de Conexão (com Retry):**
   - Máximo de 3 tentativas
   - Delay de 1 segundo entre tentativas
   - Usa configuração carregada em `loadConfig()`
   - Cria PDO com opções configuradas

3. ✅ **Tratamento de Falha:**
   - Se todas as tentativas falharem:
     - Se `shouldLogToFile = true`: salva log em arquivo de fallback (`professional_logger_fallback.txt`)
     - Loga erro em arquivo (`professional_logger_errors.txt`)
     - Loga erro no `error_log` do PHP
     - Retorna `null`

4. ✅ **Fallback para Arquivo:**
   - Se conexão falhar, salva log completo em `professional_logger_fallback.txt`
   - Formato JSON com todos os dados do log + informações da exceção
   - Garante que log não seja perdido mesmo se banco estiver indisponível

---

### **ETAPA 8: Inserção no Banco de Dados**

**Código:**
```php
try {
    $sql = "INSERT INTO application_logs (...) VALUES (...)";
    $stmt = $pdo->prepare($sql);
    $result = $stmt->execute([...]);
    
    return $result ? $logData['log_id'] : false;
} catch (PDOException $e) {
    // Tratamento de erro...
}
```

**O que acontece:**

1. ✅ **Preparação da Query SQL:**
   - Query INSERT com todos os campos da tabela `application_logs`
   - Usa prepared statements (seguro contra SQL injection)

2. ✅ **Execução:**
   - Executa query com todos os parâmetros do `$logData`
   - Retorna `log_id` se sucesso, `false` se falha

3. ✅ **Tratamento de Erros Específicos:**

   **a) Deadlock (código 1213):**
   - Detecta deadlock
   - Aguarda 100ms
   - Tenta inserir novamente uma vez
   - Se sucesso, retorna `log_id`
   - Se falha, continua tratamento de erro

   **b) Timeout (código 2006):**
   - Detecta timeout
   - Aguarda 500ms
   - Tenta inserir novamente uma vez
   - Se sucesso, retorna `log_id`
   - Se falha, continua tratamento de erro

   **c) Duplicate Entry (código 23000):**
   - Detecta entrada duplicada
   - Loga erro em arquivo
   - Retorna `false`

   **d) Data Too Long (código 22001):**
   - Detecta dados muito longos
   - Loga tamanho dos dados em arquivo
   - Retorna `false`

   **e) SQL Syntax Error (código 42000):**
   - Detecta erro de sintaxe SQL
   - Loga erro em arquivo
   - Retorna `false`

   **f) Outros Erros:**
   - Loga todos os detalhes do erro em arquivo
   - Loga no `error_log` do PHP
   - Retorna `false`

4. ✅ **Fallback para Arquivo em Caso de Erro:**
   - Se `shouldLogToFile = true`, salva log completo em `professional_logger_fallback.txt`
   - Inclui dados do log + informações da exceção PDO
   - Garante que log não seja perdido mesmo se inserção falhar

---

### **ETAPA 9: Envio de Email para Administradores (FASE 7 - Após `log()`)**

**⚠️ NOTA:** Após a implementação da FASE 7, o método `log()` será modificado para enviar email automaticamente quando nível for ERROR ou FATAL.

**Fluxo Atual (Antes da FASE 7):**

```php
// log_endpoint.php chama:
$logger->log('ERROR', $message, $data, $category, $stackTrace, $jsFileInfo);
// ↓
// log() apenas insere no banco, NÃO envia email
```

**Fluxo Proposto (Após FASE 7):**

```php
public function log($level, $message, $data = null, $category = null, $stackTrace = null, $jsFileInfo = null) {
    $logData = $this->prepareLogData($level, $message, $data, $category, $stackTrace, $jsFileInfo);
    $logId = $this->insertLog($logData);
    
    // ✅ NOVO: Se log foi bem-sucedido e nível é ERROR ou FATAL, enviar email automaticamente
    if ($logId !== false && ($level === 'ERROR' || $level === 'FATAL')) {
        try {
            $this->sendEmailNotification($level, $message, $data, $category, $stackTrace, $logData);
        } catch (Exception $e) {
            // Silenciosamente ignorar erros de envio de email (não quebrar aplicação)
            error_log('[ProfessionalLogger] Erro ao enviar email de notificação: ' . $e->getMessage());
        }
    }
    
    return $logId;
}
```

**O que acontece:**

1. ✅ **Verificação de Condições:**
   - Verifica se `$logId !== false` (inserção foi bem-sucedida)
   - Verifica se nível é `'ERROR'` ou `'FATAL'`

2. ✅ **Chamada de `sendEmailNotification()`:**
   - Prepara payload JSON com todos os dados do log
   - Faz HTTP POST para `send_email_notification_endpoint.php`
   - Requisição é assíncrona (não bloqueia execução)
   - Timeout de 10 segundos
   - Ignora erros HTTP (`ignore_errors = true`)

3. ✅ **Tratamento de Erro:**
   - Se envio de email falhar, erro é capturado silenciosamente
   - Loga erro no `error_log` do PHP (não usa `ProfessionalLogger` para evitar loop)
   - Não quebra aplicação se email falhar

---

### **ETAPA 10: Envio de Email (`sendEmailNotification()`)**

**Código:**
```php
private function sendEmailNotification($level, $message, $data = null, $category = null, $stackTrace = null, $logData = null) {
    // 1. Determinar URL do endpoint
    $endpoint = $_ENV['APP_BASE_URL'] . '/send_email_notification_endpoint.php';
    
    // 2. Sanitizar dados para JSON
    $sanitizedData = $this->sanitizeForJson($data);
    
    // 3. Preparar payload
    $payload = [
        'momento' => strtolower($level),
        'momento_descricao' => $level === 'FATAL' ? 'Erro Fatal no Sistema' : 'Erro no Sistema',
        'momento_emoji' => $level === 'FATAL' ? '🚨' : '❌',
        'erro' => [
            'message' => $message,
            'level' => $level,
            'category' => $category,
            'data' => $sanitizedData,
            'stack_trace' => $sanitizedStackTrace,
            'file_name' => $logData['file_name'] ?? null,
            'line_number' => $logData['line_number'] ?? null,
            'function_name' => $logData['function_name'] ?? null,
            'class_name' => $logData['class_name'] ?? null,
            'timestamp' => $logData['timestamp'] ?? date('Y-m-d H:i:s'),
            'request_id' => $this->requestId,
            'environment' => $this->environment
        ]
    ];
    
    // 4. Fazer requisição HTTP POST
    $result = @file_get_contents($endpoint, false, $context);
}
```

**O que acontece:**

1. ✅ **Preparação do Payload:**
   - Sanitiza dados para garantir JSON válido
   - Prepara payload com formato esperado pelo endpoint de email
   - Inclui todos os detalhes do log (mensagem, nível, categoria, stack trace, arquivo, linha, etc.)

2. ✅ **Validação de JSON:**
   - Valida que payload pode ser serializado para JSON
   - Se falhar, tenta payload simplificado
   - Se ainda falhar, não envia email

3. ✅ **Requisição HTTP POST:**
   - Usa `file_get_contents()` com contexto HTTP
   - Método: POST
   - Content-Type: application/json
   - Timeout: 10 segundos
   - Ignora erros HTTP (`ignore_errors = true`)

4. ✅ **Log de Resultado:**
   - Se falhar: loga erro no `error_log` do PHP
   - Se sucesso: loga sucesso no `error_log` do PHP
   - Não usa `ProfessionalLogger` para evitar loop infinito

---

### **ETAPA 11: Processamento no Endpoint de Email (`send_email_notification_endpoint.php`)**

**Fluxo:**

1. ✅ **Recebe Requisição HTTP POST:**
   - Valida JSON
   - Extrai dados do payload

2. ✅ **Chama `enviarNotificacaoAdministradores()`:**
   - Prepara template de email
   - Envia via AWS SES para 3 administradores:
     - `lrotero@gmail.com`
     - `alex.kaminski@imediatoseguros.com.br`
     - `alexkaminski70@gmail.com`

3. ✅ **Loga Resultado:**
   - Se `LogConfig::shouldLog()` permitir, loga resultado usando `ProfessionalLogger->log()`
   - Se erro ocorrer e `LogConfig::shouldLog('ERROR', 'EMAIL')` permitir, loga erro usando `ProfessionalLogger->error()`

---

## 🔗 FLUXO COMPLETO: Código PHP → ProfessionalLogger → Banco de Dados → Email

### **Fluxo Visual:**

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Código PHP chama ProfessionalLogger                      │
│    $logger->log('ERROR', 'Erro crítico', $data, 'SYSTEM')   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. log() prepara dados                                       │
│    • prepareLogData()                                        │
│    • Captura arquivo/linha automaticamente                   │
│    • Sanitiza dados                                          │
│    • Converte para JSON                                      │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. log() chama insertLog()                                   │
│    • Verifica parametrização (LogConfig::shouldLog())        │
│    • Verifica destinos (console, banco, arquivo)             │
└────────────────────┬────────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
┌──────────────────┐   ┌──────────────────────────────┐
│ 4a. Log no       │   │ 4b. Conexão com Banco        │
│     Console      │   │                              │
│                  │   │ connect()                    │
│ error_log()      │   │ • Verifica conexão existente │
│                  │   │ • Tenta conectar (3x retry)  │
│                  │   │ • Se falhar: fallback arquivo│
└──────────────────┘   └──────────┬───────────────────┘
                                  │
                                  ▼
                     ┌──────────────────────────────┐
                     │ 5. Inserção no Banco         │
                     │    • INSERT INTO application_logs │
                     │    • Prepared statement      │
                     │    • Retry se deadlock/timeout│
                     │    • Fallback arquivo se erro │
                     └──────────┬───────────────────┘
                                │
                                ▼
                     ┌──────────────────────────────┐
                     │ 6. Verificação de Nível      │
                     │    (Após FASE 7)             │
                     │    • Se ERROR ou FATAL       │
                     │    • E inserção bem-sucedida │
                     │    • Enviar email            │
                     └──────────┬───────────────────┘
                                │
                                ▼
                     ┌──────────────────────────────┐
                     │ 7. sendEmailNotification()   │
                     │    • Prepara payload JSON    │
                     │    • HTTP POST assíncrono    │
                     │    • Para send_email_notification_endpoint.php │
                     └──────────┬───────────────────┘
                                │
                                ▼
                     ┌──────────────────────────────┐
                     │ 8. send_email_notification_endpoint.php │
                     │    • Recebe payload          │
                     │    • Valida dados            │
                     │    • Chama enviarNotificacaoAdministradores() │
                     └──────────┬───────────────────┘
                                │
                                ▼
                     ┌──────────────────────────────┐
                     │ 9. send_admin_notification_ses.php │
                     │    • Prepara template de email│
                     │    • Envia via AWS SES        │
                     │    • Para 3 administradores  │
                     └──────────────────────────────┘
```

---

## 📝 EXEMPLOS PRÁTICOS

### **Exemplo 1: Log Simples de Informação**

```php
$logger = new ProfessionalLogger();
$logger->info('Processo iniciado', ['step' => 1], 'RPA');
```

**Fluxo:**

1. ✅ `info()` chama `log('INFO', 'Processo iniciado', ['step' => 1], 'RPA')`
2. ✅ `log()` chama `prepareLogData()` → prepara array `$logData`
3. ✅ `log()` chama `insertLog($logData)`
4. ✅ `insertLog()` verifica parametrização → se permitido, continua
5. ✅ `insertLog()` verifica `shouldLogToConsole` → se `true`, exibe no `error_log`
6. ✅ `insertLog()` verifica `shouldLogToDatabase` → se `true`, conecta ao banco
7. ✅ `insertLog()` executa INSERT → retorna `log_id`
8. ✅ `log()` verifica nível → `'INFO'` não é ERROR/FATAL → não envia email
9. ✅ Retorna `log_id`

---

### **Exemplo 2: Log de Erro com Email**

```php
$logger = new ProfessionalLogger();
$logger->error('Erro crítico no processo', ['code' => 500], 'SYSTEM', $exception);
```

**Fluxo:**

1. ✅ `error()` extrai stack trace de `$exception`
2. ✅ `error()` chama `log('ERROR', 'Erro crítico...', ['code' => 500], 'SYSTEM', $stackTrace)`
3. ✅ `log()` chama `prepareLogData()` → prepara array `$logData`
4. ✅ `log()` chama `insertLog($logData)`
5. ✅ `insertLog()` verifica parametrização → se permitido, continua
6. ✅ `insertLog()` exibe no console (se configurado)
7. ✅ `insertLog()` conecta ao banco e insere log → retorna `log_id`
8. ✅ `log()` verifica nível → `'ERROR'` → chama `sendEmailNotification()`
9. ✅ `sendEmailNotification()` prepara payload e faz HTTP POST
10. ✅ Email é enviado para 3 administradores via AWS SES
11. ✅ Retorna `log_id`

**⚠️ NOTA:** Após FASE 7, `error()` será simplificado para apenas chamar `log()`, pois `log()` já enviará email automaticamente.

---

### **Exemplo 3: Log com Banco Indisponível**

```php
$logger = new ProfessionalLogger();
$logger->info('Teste de log', [], 'TEST');
```

**Fluxo:**

1. ✅ `info()` chama `log('INFO', 'Teste de log', [], 'TEST')`
2. ✅ `log()` chama `prepareLogData()` → prepara array `$logData`
3. ✅ `log()` chama `insertLog($logData)`
4. ✅ `insertLog()` verifica parametrização → se permitido, continua
5. ✅ `insertLog()` exibe no console (se configurado)
6. ✅ `insertLog()` tenta conectar ao banco → **FALHA** (banco indisponível)
7. ✅ `insertLog()` verifica `shouldLogToFile` → se `true`, chama `logToFileFallback()`
8. ✅ `logToFileFallback()` salva log completo em `professional_logger_fallback.txt`
9. ✅ `insertLog()` loga erro em `professional_logger_errors.txt`
10. ✅ `insertLog()` retorna `false`
11. ✅ `log()` verifica `$logId === false` → não envia email (inserção falhou)
12. ✅ Retorna `false`

---

### **Exemplo 4: Log via log_endpoint.php (do JavaScript)**

**JavaScript:**
```javascript
novo_log('ERROR', 'RPA', 'Erro no processo', { error: 'Fail' });
```

**Fluxo:**

1. ✅ `novo_log()` chama `sendLogToProfessionalSystem('ERROR', 'RPA', 'Erro no processo', { error: 'Fail' })`
2. ✅ `sendLogToProfessionalSystem()` faz `fetch()` POST para `log_endpoint.php`
3. ✅ `log_endpoint.php` recebe requisição:
   - Valida JSON
   - Verifica parametrização (`LogConfig::shouldLog()`)
   - Prepara dados (`$level`, `$message`, `$data`, `$category`, `$stackTrace`, `$jsFileInfo`)
4. ✅ `log_endpoint.php` chama `$logger->log($level, $message, $data, $category, $stackTrace, $jsFileInfo)`
5. ✅ `log()` chama `prepareLogData()` → usa `$jsFileInfo` para capturar arquivo/linha do JavaScript
6. ✅ `log()` chama `insertLog($logData)`
7. ✅ `insertLog()` verifica parametrização → se permitido, continua
8. ✅ `insertLog()` exibe no console (se configurado)
9. ✅ `insertLog()` conecta ao banco e insere log → retorna `log_id`
10. ✅ `log()` verifica nível → `'ERROR'` → chama `sendEmailNotification()` (após FASE 7)
11. ✅ Email é enviado para 3 administradores
12. ✅ `log_endpoint.php` retorna `log_id` para JavaScript

---

## 🔍 DETALHES IMPORTANTES

### **1. Parametrização Completa**

- ✅ **Nível Global:** `LOG_ENABLED`, `LOG_LEVEL`
- ✅ **Destino Console:** `LOG_CONSOLE_ENABLED`, `LOG_CONSOLE_MIN_LEVEL`
- ✅ **Destino Banco:** `LOG_DATABASE_ENABLED`, `LOG_DATABASE_MIN_LEVEL`
- ✅ **Destino Arquivo:** `LOG_FILE_ENABLED`, `LOG_FILE_MIN_LEVEL`
- ✅ **Exclusões:** `LOG_EXCLUDE_CATEGORIES`, `LOG_EXCLUDE_CONTEXTS`

### **2. Fallback Robusto**

- ✅ **Conexão Falha:** Salva em `professional_logger_fallback.txt`
- ✅ **Inserção Falha:** Salva em `professional_logger_fallback.txt`
- ✅ **Formato JSON:** Log completo preservado para recuperação posterior
- ✅ **Dupla Proteção:** Arquivo + `error_log` do PHP

### **3. Retry Automático**

- ✅ **Deadlock:** Retry automático após 100ms
- ✅ **Timeout:** Retry automático após 500ms
- ✅ **Uma Tentativa:** Apenas um retry para evitar loops

### **4. Tratamento de Erro Silencioso**

- ✅ **Email Falha:** Não quebra aplicação
- ✅ **Banco Falha:** Fallback para arquivo
- ✅ **Logging Falha:** Usa `error_log` direto (não usa `ProfessionalLogger`)

### **5. Prevenção de Loops Infinitos**

- ✅ **`sendEmailNotification()`:** Usa `error_log` direto (não usa `ProfessionalLogger`)
- ✅ **`logToFile()`:** Usa `error_log` direto (não usa `ProfessionalLogger`)
- ✅ **`logToFileFallback()`:** Usa `error_log` direto (não usa `ProfessionalLogger`)

---

## 📊 RESUMO DO FLUXO

| Etapa | Ação | Condição | Resultado |
|-------|------|----------|------------|
| 1 | Inicialização | `new ProfessionalLogger()` | `requestId` gerado, config carregado |
| 2 | Chamada método | `log()`, `error()`, `fatal()`, etc. | Prepara dados |
| 3 | Preparação dados | `prepareLogData()` | Array `$logData` completo |
| 4 | Verificação parametrização | `LogConfig::shouldLog()` | Se `false` → retorna `false` |
| 5 | Log no console | `shouldLogToConsole = true` | `error_log()` |
| 6 | Verificação banco | `shouldLogToDatabase = true` | Se `false` → retorna `false` |
| 7 | Conexão banco | `connect()` | Se falhar → fallback arquivo |
| 8 | Inserção banco | `INSERT INTO application_logs` | Retorna `log_id` ou `false` |
| 9 | Retry (se necessário) | Deadlock/timeout | Tenta novamente uma vez |
| 10 | Fallback arquivo | Se inserção falhar | Salva em `professional_logger_fallback.txt` |
| 11 | Envio email (FASE 7) | `ERROR`/`FATAL` + inserção OK | `sendEmailNotification()` |
| 12 | Processamento email | `send_email_notification_endpoint.php` | Envia via AWS SES |

---

## 🔗 PONTOS DE ENTRADA NO SISTEMA

### **1. log_endpoint.php (JavaScript → PHP)**

**Fluxo:**
```
JavaScript (novo_log) 
  → sendLogToProfessionalSystem() 
  → fetch() POST 
  → log_endpoint.php 
  → ProfessionalLogger->log() 
  → insertLog() 
  → Banco de Dados
```

**Características:**
- ✅ Recebe logs do JavaScript
- ✅ Valida JSON antes de processar
- ✅ Verifica parametrização antes de chamar `log()`
- ✅ Usa `$jsFileInfo` para preservar informações do JavaScript

### **2. send_email_notification_endpoint.php (Email)**

**Fluxo:**
```
sendEmailNotification() 
  → HTTP POST 
  → send_email_notification_endpoint.php 
  → enviarNotificacaoAdministradores() 
  → send_admin_notification_ses.php 
  → AWS SES 
  → Email para administradores
```

**Características:**
- ✅ Recebe requisições de envio de email
- ✅ Valida payload
- ✅ Loga resultado usando `ProfessionalLogger->log()` ou `->error()`
- ✅ Verifica parametrização antes de logar

### **3. send_admin_notification_ses.php (SES)**

**Fluxo:**
```
send_admin_notification_ses.php 
  → new ProfessionalLogger() 
  → insertLog() 
  → Banco de Dados
```

**Características:**
- ✅ Usa `insertLog()` diretamente (não passa por `log()`)
- ✅ Loga operações de envio de email via SES
- ✅ Inclui fallback para `error_log` se `ProfessionalLogger` falhar
- ⚠️ **NOTA:** Código atual tenta usar `ProfessionalLogger::getInstance()`, mas esse método não existe. Deve usar `new ProfessionalLogger()`.

### **4. Código PHP Direto**

**Fluxo:**
```
Código PHP 
  → ProfessionalLogger->log()/error()/fatal() 
  → insertLog() 
  → Banco de Dados
```

**Características:**
- ✅ Qualquer código PHP pode chamar diretamente
- ✅ Captura automática de arquivo/linha
- ✅ Suporte completo a parametrização

---

## 📋 MÉTODOS DA CLASSE ProfessionalLogger

### **Métodos Públicos:**

1. **`log($level, $message, $data, $category, $stackTrace, $jsFileInfo)`**
   - Método genérico de log
   - Chama `prepareLogData()` e `insertLog()`
   - Após FASE 7: envia email se nível for ERROR/FATAL

2. **`insertLog($logData)`**
   - Inserção direta no banco de dados
   - Verifica parametrização
   - Gerencia conexão, inserção, retry, fallback

3. **`debug($message, $data, $category)`**
   - Chama `log('DEBUG', ...)`

4. **`info($message, $data, $category)`**
   - Chama `log('INFO', ...)`

5. **`warn($message, $data, $category)`**
   - Chama `log('WARN', ...)`

6. **`error($message, $data, $category, $exception)`**
   - Chama `log('ERROR', ...)` + envia email
   - Após FASE 7: apenas chama `log()` (que já envia email)

7. **`fatal($message, $data, $category, $exception)`**
   - Chama `log('FATAL', ...)` + envia email
   - Após FASE 7: apenas chama `log()` (que já envia email)

8. **`getRequestId()`**
   - Retorna `requestId` da instância

9. **`getConnection()`**
   - Retorna conexão PDO (para uso em outros scripts)

### **Métodos Privados:**

1. **`prepareLogData(...)`**
   - Prepara array `$logData` completo
   - Captura informações do chamador
   - Sanitiza e converte dados para JSON

2. **`connect()`**
   - Gerencia conexão PDO
   - Retry automático (3 tentativas)
   - Verifica conexão existente

3. **`sendEmailNotification(...)`**
   - Envia email para administradores
   - Requisição HTTP POST assíncrona
   - Tratamento de erro silencioso

4. **`logToFile($message, $data)`**
   - Loga em arquivo (`professional_logger_errors.txt`)
   - Usa `error_log` direto (não usa `ProfessionalLogger`)

5. **`logToFileFallback($logData, $exception)`**
   - Salva log completo em arquivo (`professional_logger_fallback.txt`)
   - Usado quando banco está indisponível
   - Formato JSON completo

6. **`captureCallerInfo()`**
   - Captura arquivo, linha, função, classe do chamador
   - Usa `debug_backtrace()`

7. **`getClientInfo()`**
   - Captura URL, IP, User-Agent, nome do servidor

8. **`sanitizeData($data)`**
   - Remove recursos não serializáveis
   - Converte objetos não serializáveis

9. **`sanitizeForJson($data)`**
   - Sanitiza dados para serialização JSON
   - Usado em `sendEmailNotification()`

---

## 🎯 CARACTERÍSTICAS IMPORTANTES

### **1. Parametrização Completa**

- ✅ Controle por nível (`LOG_LEVEL`)
- ✅ Controle por categoria (`LOG_EXCLUDE_CATEGORIES`)
- ✅ Controle por destino (console, banco, arquivo)
- ✅ Valores padrão permissivos (sempre logar se variáveis não existirem)
- ✅ Valores mais restritivos em produção (se não especificado)

### **2. Fallback Robusto**

- ✅ **Conexão Falha:** Salva em arquivo de fallback
- ✅ **Inserção Falha:** Salva em arquivo de fallback
- ✅ **Dupla Proteção:** Arquivo + `error_log` do PHP
- ✅ **Formato JSON:** Log completo preservado

### **3. Retry Automático**

- ✅ **Deadlock:** Retry após 100ms
- ✅ **Timeout:** Retry após 500ms
- ✅ **Uma Tentativa:** Evita loops

### **4. Tratamento de Erro Silencioso**

- ✅ **Não Quebra Aplicação:** Erros são capturados silenciosamente
- ✅ **Fallback Sempre Disponível:** Arquivo de fallback sempre funciona
- ✅ **Logs de Erro:** Erros são logados em arquivo e `error_log`

### **5. Prevenção de Loops Infinitos**

- ✅ **Métodos Auxiliares:** Usam `error_log` direto (não usam `ProfessionalLogger`)
- ✅ **Tratamento de Erro:** Não chama `ProfessionalLogger` dentro de tratamento de erro
- ✅ **Email:** Não usa `ProfessionalLogger` para logar envio de email

---

## 📊 COMPARAÇÃO: JavaScript vs PHP

| Aspecto | JavaScript (`novo_log()`) | PHP (`ProfessionalLogger->log()`) |
|---------|---------------------------|-----------------------------------|
| **Parametrização** | `window.shouldLog()`, `window.DEBUG_CONFIG` | `LogConfig::shouldLog()` |
| **Console** | `console.log/warn/error()` | `error_log()` |
| **Banco de Dados** | `sendLogToProfessionalSystem()` → `log_endpoint.php` | `insertLog()` direto |
| **Fallback Arquivo** | Não tem (apenas PHP) | `logToFileFallback()` |
| **Email** | Não envia diretamente | `sendEmailNotification()` (ERROR/FATAL) |
| **Assíncrono** | Sim (`fetch()` sem `await`) | Sim (`file_get_contents()` não bloqueia) |
| **Tratamento de Erro** | Try-catch silencioso | Try-catch silencioso |

---

**Documento criado em:** 18/11/2025  
**Versão:** 1.0.0

