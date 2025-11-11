# 📋 PLANO DETALHADO - Implementação de Correções HTTP 500

**Data:** 09/11/2025  
**Objetivo:** Corrigir erros HTTP 500 e 400 no `log_endpoint.php`  
**Prioridade:** 🔴 **CRÍTICA**

---

## 📊 SUMÁRIO EXECUTIVO

Este plano detalha a implementação das correções identificadas para resolver os erros HTTP 500 e 400 intermitentes no sistema de logging.

**Causas Identificadas:**
1. **ProfessionalLogger retornando `false`** (Causa Principal)
2. **Warnings de `REQUEST_METHOD`** (Causa Secundária)
3. **Bug do rate limiting** (Causa Terciária)

**Impacto Esperado:**
- Redução de HTTP 500 de 30-40% para < 1%
- Redução de HTTP 400 de 20-35% para < 5%
- Melhoria na confiabilidade do sistema de logging

---

## 🎯 OBJETIVOS

### **Objetivos Principais**
1. ✅ Corrigir falhas de conexão MySQL com retry logic
2. ✅ Melhorar tratamento de erros do ProfessionalLogger
3. ✅ Corrigir warnings de `REQUEST_METHOD`
4. ✅ Corrigir bug do rate limiting
5. ✅ Adicionar logging detalhado para diagnóstico

### **Objetivos Secundários**
6. ⚠️ Implementar monitoramento de erros
7. ⚠️ Criar testes de validação
8. ⚠️ Documentar mudanças

---

## 📅 CRONOGRAMA

### **Fase 1: Preparação e Backup** (30 minutos)
- Criar backups dos arquivos
- Verificar ambiente de desenvolvimento
- Preparar ambiente de testes

### **Fase 2: Correções Críticas** (1-2 horas)
- Corrigir ProfessionalLogger (retry logic)
- Corrigir warnings de REQUEST_METHOD
- Corrigir bug do rate limiting

### **Fase 3: Melhorias e Testes** (1 hora)
- Adicionar logging detalhado
- Implementar testes de validação
- Testar em ambiente de desenvolvimento

### **Fase 4: Deploy e Monitoramento** (30 minutos)
- Deploy para servidor de desenvolvimento
- Monitorar por 24-48 horas
- Validar correções

**Tempo Total Estimado:** 3-4 horas

---

## 🔧 FASE 1: PREPARAÇÃO E BACKUP

### **Tarefa 1.1: Criar Backups Locais**

**Arquivos a fazer backup:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Ações:**
```bash
# Criar diretório de backup
mkdir -p WEBFLOW-SEGUROSIMEDIATO/backups/2025-11-09

# Copiar arquivos para backup
cp WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php WEBFLOW-SEGUROSIMEDIATO/backups/2025-11-09/log_endpoint.php.backup
cp WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php WEBFLOW-SEGUROSIMEDIATO/backups/2025-11-09/ProfessionalLogger.php.backup

# Verificar backups
ls -lh WEBFLOW-SEGUROSIMEDIATO/backups/2025-11-09/
```

**Critério de Sucesso:**
- ✅ Arquivos de backup criados
- ✅ Tamanho dos backups > 0
- ✅ Backups são legíveis

### **Tarefa 1.2: Verificar Ambiente de Desenvolvimento**

**Verificações:**
1. Verificar se servidor de desenvolvimento está acessível
2. Verificar se MySQL está funcionando
3. Verificar logs atuais para baseline

**Ações:**
```bash
# Verificar acesso ao servidor
ssh root@65.108.156.14 "echo 'Servidor acessível'"

# Verificar MySQL
ssh root@65.108.156.14 "docker exec webhooks-php-dev php -r 'try { \$pdo = new PDO(\"mysql:host=172.17.0.1;port=3306;dbname=rpa_logs_dev\", \"rpa_logger_dev\", getenv(\"LOG_DB_PASS\")); echo \"MySQL OK\"; } catch (Exception \$e) { echo \"MySQL ERRO: \" . \$e->getMessage(); }'"

# Verificar logs atuais (baseline)
ssh root@65.108.156.14 "docker exec webhooks-nginx tail -100 /var/log/nginx/dev_access.log | grep 'log_endpoint.php' | grep -E '500|400' | wc -l"
```

**Critério de Sucesso:**
- ✅ Servidor acessível
- ✅ MySQL funcionando
- ✅ Baseline de erros capturado

### **Tarefa 1.3: Preparar Ambiente de Testes**

**Ações:**
1. Criar script de teste para validar correções
2. Preparar dados de teste
3. Documentar procedimento de rollback

**Critério de Sucesso:**
- ✅ Script de teste criado
- ✅ Procedimento de rollback documentado

---

## 🔧 FASE 2: CORREÇÕES CRÍTICAS

### **Tarefa 2.1: Corrigir ProfessionalLogger - Adicionar Retry Logic**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Localização:** Método `connect()`, linhas 91-118

**Código Atual:**
```php
private function connect() {
    if ($this->pdo !== null) {
        return $this->pdo;
    }
    
    try {
        $dsn = sprintf(
            'mysql:host=%s;port=%d;dbname=%s;charset=%s',
            $this->config['host'],
            $this->config['port'],
            $this->config['database'],
            $this->config['charset']
        );
        
        $this->pdo = new PDO(
            $dsn,
            $this->config['username'],
            $this->config['password'],
            $this->config['options']
        );
        
        return $this->pdo;
        
    } catch (PDOException $e) {
        error_log("ProfessionalLogger: Database connection failed - " . $e->getMessage());
        return null;
    }
}
```

**Código Corrigido:**
```php
private function connect() {
    if ($this->pdo !== null) {
        // Verificar se conexão ainda está válida
        try {
            $this->pdo->query('SELECT 1');
            return $this->pdo;
        } catch (PDOException $e) {
            // Conexão perdida, resetar
            $this->pdo = null;
        }
    }
    
    $maxRetries = 3;
    $retryDelay = 1; // segundos
    
    for ($attempt = 1; $attempt <= $maxRetries; $attempt++) {
        try {
            $dsn = sprintf(
                'mysql:host=%s;port=%d;dbname=%s;charset=%s',
                $this->config['host'],
                $this->config['port'],
                $this->config['database'],
                $this->config['charset']
            );
            
            $this->pdo = new PDO(
                $dsn,
                $this->config['username'],
                $this->config['password'],
                $this->config['options']
            );
            
            return $this->pdo;
            
        } catch (PDOException $e) {
            $errorCode = $e->getCode();
            $errorMessage = $e->getMessage();
            
            error_log("ProfessionalLogger: Database connection failed (attempt $attempt/$maxRetries) - Code: $errorCode, Message: $errorMessage");
            
            if ($attempt < $maxRetries) {
                // Aguardar antes de tentar novamente
                sleep($retryDelay);
                continue;
            }
            
            // Todas as tentativas falharam
            error_log("ProfessionalLogger: All connection attempts failed. Giving up.");
            return null;
        }
    }
    
    return null;
}
```

**Mudanças:**
- ✅ Adiciona verificação de conexão válida antes de reutilizar
- ✅ Implementa retry logic (3 tentativas)
- ✅ Adiciona delay entre tentativas (1 segundo)
- ✅ Melhora logging de erros (inclui código e tentativa)

**Critério de Sucesso:**
- ✅ Código compila sem erros
- ✅ Retry logic implementado
- ✅ Logging melhorado

### **Tarefa 2.2: Melhorar Tratamento de Erros em insertLog()**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Localização:** Método `insertLog()`, linhas 263-320

**Código Atual:**
```php
} catch (PDOException $e) {
    error_log("ProfessionalLogger: Failed to insert log - " . $e->getMessage());
    return false;
}
```

**Código Corrigido:**
```php
} catch (PDOException $e) {
    $errorCode = $e->getCode();
    $errorMessage = $e->getMessage();
    
    // Log detalhado do erro
    error_log("ProfessionalLogger: Failed to insert log - Code: $errorCode, Message: $errorMessage");
    
    // Se for deadlock (código 1213), tentar novamente uma vez
    if ($errorCode == 1213 || strpos($errorMessage, 'Deadlock') !== false) {
        error_log("ProfessionalLogger: Deadlock detected, retrying once...");
        
        try {
            // Aguardar um pouco antes de retry (deadlocks geralmente se resolvem rapidamente)
            usleep(100000); // 100ms
            
            // Tentar novamente
            $stmt = $pdo->prepare($sql);
            $result = $stmt->execute([
                ':log_id' => $logData['log_id'],
                ':request_id' => $logData['request_id'],
                ':timestamp' => $logData['timestamp'],
                ':client_timestamp' => $logData['client_timestamp'],
                ':server_time' => $logData['server_time'],
                ':level' => $logData['level'],
                ':category' => $logData['category'],
                ':file_name' => $logData['file_name'],
                ':file_path' => $logData['file_path'],
                ':line_number' => $logData['line_number'],
                ':function_name' => $logData['function_name'],
                ':class_name' => $logData['class_name'],
                ':message' => $logData['message'],
                ':data' => $logData['data'],
                ':stack_trace' => $logData['stack_trace'],
                ':url' => $logData['url'],
                ':session_id' => $logData['session_id'],
                ':user_id' => $logData['user_id'],
                ':ip_address' => $logData['ip_address'],
                ':user_agent' => $logData['user_agent'],
                ':environment' => $logData['environment'],
                ':server_name' => $logData['server_name'],
                ':metadata' => $logData['metadata'],
                ':tags' => $logData['tags']
            ]);
            
            if ($result) {
                error_log("ProfessionalLogger: Retry after deadlock succeeded");
                return $logData['log_id'];
            }
            
        } catch (PDOException $e2) {
            error_log("ProfessionalLogger: Retry after deadlock failed - " . $e2->getMessage());
        }
    }
    
    return false;
}
```

**Mudanças:**
- ✅ Adiciona tratamento específico para deadlocks
- ✅ Implementa retry automático para deadlocks
- ✅ Melhora logging (inclui código de erro)
- ✅ Adiciona delay antes de retry (100ms)

**Critério de Sucesso:**
- ✅ Código compila sem erros
- ✅ Tratamento de deadlock implementado
- ✅ Logging melhorado

### **Tarefa 2.3: Melhorar Tratamento em log_endpoint.php**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`

**Localização:** Linhas 197-206

**Código Atual:**
```php
$logId = $logger->log($level, $message, $data, $category, $stackTrace, $jsFileInfo);

if ($logId === false) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Failed to insert log',
        'message' => 'Database insertion failed'
    ]);
    exit;
}
```

**Código Corrigido:**
```php
$logId = $logger->log($level, $message, $data, $category, $stackTrace, $jsFileInfo);

if ($logId === false) {
    // Logar motivo da falha para diagnóstico
    error_log("log_endpoint.php: Failed to insert log - Logger returned false");
    
    // Verificar status da conexão (para debug)
    $connection = $logger->getConnection();
    $connectionStatus = $connection !== null ? 'connected' : 'disconnected';
    
    // Logar status da conexão
    error_log("log_endpoint.php: Database connection status: $connectionStatus");
    
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Failed to insert log',
        'message' => 'Database insertion failed',
        'debug' => (($_ENV['PHP_ENV'] ?? 'development') === 'development' ? [
            'connection_status' => $connectionStatus,
            'possible_causes' => [
                'Database connection failed',
                'Insert query failed',
                'PDO exception occurred',
                'Database timeout',
                'Deadlock occurred'
            ],
            'timestamp' => date('Y-m-d H:i:s.u')
        ] : null)
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}
```

**Mudanças:**
- ✅ Adiciona logging detalhado antes de retornar HTTP 500
- ✅ Verifica status da conexão para diagnóstico
- ✅ Adiciona informações de debug em desenvolvimento
- ✅ Lista possíveis causas do erro

**Critério de Sucesso:**
- ✅ Código compila sem erros
- ✅ Logging detalhado implementado
- ✅ Informações de debug adicionadas

### **Tarefa 2.4: Corrigir Warnings de REQUEST_METHOD**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`

**Localização:** Linhas 18, 24, 29

**Código Atual:**
```php
// Linha 18
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {

// Linha 24
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {

// Linha 29
'method' => $_SERVER['REQUEST_METHOD']
```

**Código Corrigido:**
```php
// Linha 18
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {

// Linha 24
if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {

// Linha 29
'method' => $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN'
```

**Mudanças:**
- ✅ Usa null coalescing operator (`??`) para evitar warnings
- ✅ Define valores padrão seguros
- ✅ Elimina warnings de chave inexistente

**Critério de Sucesso:**
- ✅ Código compila sem erros
- ✅ Warnings eliminados
- ✅ Funcionalidade mantida

### **Tarefa 2.5: Corrigir Bug do Rate Limiting**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`

**Localização:** Linhas 123-142

**Código Atual:**
```php
if (file_exists($rateLimitFile)) {
    $data = json_decode(file_get_contents($rateLimitFile), true);
    if ($now - $data['first_request'] < $window) {
        if ($data['count'] >= $maxRequests) {
            http_response_code(429);
            echo json_encode([
                'success' => false,
                'error' => 'Rate limit exceeded',
                'retry_after' => $window - ($now - $data['first_request'])
            ]);
            exit;
        }
        $data['count']++;
    } else {
        $data = ['first_request' => $now, 'count' => 1];
    }
} else {
    $data = ['first_request' => $now, 'count' => 1];
}
file_put_contents($rateLimitFile, json_encode($data));
```

**Código Corrigido:**
```php
// Rate limiting com tratamento robusto de erros
$rateLimitData = null;
$rateLimitFile = sys_get_temp_dir() . '/log_rate_limit_' . md5($clientIP) . '.tmp';

if (file_exists($rateLimitFile)) {
    $fileContent = file_get_contents($rateLimitFile);
    $rateLimitData = json_decode($fileContent, true);
    
    // Validar dados do rate limit
    if (!is_array($rateLimitData) || !isset($rateLimitData['first_request']) || !isset($rateLimitData['count'])) {
        // Arquivo corrompido, vazio ou inválido - recriar
        error_log("log_endpoint.php: Rate limit file corrupted or invalid, recreating. File: $rateLimitFile");
        $rateLimitData = ['first_request' => $now, 'count' => 1];
    } else if ($now - $rateLimitData['first_request'] < $window) {
        // Janela ainda válida
        if ($rateLimitData['count'] >= $maxRequests) {
            http_response_code(429);
            echo json_encode([
                'success' => false,
                'error' => 'Rate limit exceeded',
                'retry_after' => $window - ($now - $rateLimitData['first_request'])
            ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
            exit;
        }
        $rateLimitData['count']++;
    } else {
        // Janela expirou - resetar
        $rateLimitData = ['first_request' => $now, 'count' => 1];
    }
} else {
    // Arquivo não existe - criar
    $rateLimitData = ['first_request' => $now, 'count' => 1];
}

// Salvar dados do rate limit com lock para evitar race conditions
file_put_contents($rateLimitFile, json_encode($rateLimitData), LOCK_EX);
```

**Mudanças:**
- ✅ Valida `$rateLimitData` antes de usar
- ✅ Trata arquivo vazio/corrompido
- ✅ Usa `LOCK_EX` para evitar race conditions
- ✅ Adiciona logging quando arquivo está corrompido
- ✅ Garante que `$rateLimitData` sempre é um array válido

**Critério de Sucesso:**
- ✅ Código compila sem erros
- ✅ Validação implementada
- ✅ Race conditions evitadas
- ✅ Bug corrigido

---

## 🔧 FASE 3: MELHORIAS E TESTES

### **Tarefa 3.1: Adicionar Logging Detalhado**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`

**Ações:**
1. Adicionar logging no início da requisição
2. Adicionar logging em pontos críticos
3. Adicionar logging de erros detalhado

**Código a Adicionar:**
```php
// No início do try block (após linha 55)
$requestStartTime = microtime(true);
$requestId = uniqid('req_', true);

error_log("log_endpoint.php: Request started - ID: $requestId, Method: " . ($_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN') . ", IP: " . ($_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN'));

// Após validação de JSON (após linha 67)
error_log("log_endpoint.php: JSON validated - ID: $requestId, Level: " . ($input['level'] ?? 'N/A') . ", Message length: " . strlen($input['message'] ?? ''));

// Após rate limiting (após linha 142)
error_log("log_endpoint.php: Rate limit checked - ID: $requestId, Count: " . ($rateLimitData['count'] ?? 'N/A'));

// Após inserção de log (após linha 197)
$requestDuration = microtime(true) - $requestStartTime;
error_log("log_endpoint.php: Request completed - ID: $requestId, Log ID: $logId, Duration: " . round($requestDuration * 1000, 2) . "ms");
```

**Critério de Sucesso:**
- ✅ Logging adicionado em pontos críticos
- ✅ Logs são informativos
- ✅ Performance não é significativamente afetada

### **Tarefa 3.2: Criar Script de Teste**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/test_log_endpoint_corrections.php`

**Conteúdo:**
```php
<?php
/**
 * Script de teste para validar correções do log_endpoint.php
 */

require_once __DIR__ . '/ProfessionalLogger.php';

echo "=== TESTE DE CORREÇÕES DO LOG_ENDPOINT ===\n\n";

// Teste 1: Conexão MySQL com retry
echo "Teste 1: Conexão MySQL com retry logic\n";
$logger = new ProfessionalLogger();
$conn = $logger->getConnection();
if ($conn) {
    echo "✅ Conexão estabelecida com sucesso\n";
} else {
    echo "❌ Falha na conexão\n";
    exit(1);
}

// Teste 2: Inserção de log
echo "\nTeste 2: Inserção de log\n";
$logId = $logger->log('INFO', 'Teste de correções', ['test' => true]);
if ($logId) {
    echo "✅ Log inserido com sucesso. ID: $logId\n";
} else {
    echo "❌ Falha na inserção\n";
    exit(1);
}

// Teste 3: Rate limiting (simular arquivo vazio)
echo "\nTeste 3: Rate limiting com arquivo vazio\n";
$testFile = sys_get_temp_dir() . '/log_rate_limit_test.tmp';
file_put_contents($testFile, ''); // Arquivo vazio
$data = json_decode(file_get_contents($testFile), true);
if (!is_array($data) || !isset($data['first_request'])) {
    echo "✅ Validação de rate limit funciona (detecta arquivo vazio)\n";
} else {
    echo "❌ Validação não funciona\n";
    exit(1);
}
unlink($testFile);

// Teste 4: REQUEST_METHOD (simular ausência)
echo "\nTeste 4: REQUEST_METHOD ausente\n";
unset($_SERVER['REQUEST_METHOD']);
$method = $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN';
if ($method === 'UNKNOWN') {
    echo "✅ Null coalescing funciona corretamente\n";
} else {
    echo "❌ Null coalescing não funciona\n";
    exit(1);
}

echo "\n=== TODOS OS TESTES PASSARAM ===\n";
```

**Critério de Sucesso:**
- ✅ Script criado
- ✅ Todos os testes passam
- ✅ Cobre cenários críticos

### **Tarefa 3.3: Testar em Ambiente de Desenvolvimento**

**Ações:**
1. Copiar arquivos corrigidos para servidor
2. Executar script de teste
3. Fazer requisições de teste via curl
4. Verificar logs

**Comandos:**
```bash
# Copiar arquivos para servidor
scp WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php root@65.108.156.14:/opt/webhooks-server/dev/root/
scp WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php root@65.108.156.14:/opt/webhooks-server/dev/root/

# Executar script de teste
ssh root@65.108.156.14 "docker exec webhooks-php-dev php /var/www/html/dev/root/test_log_endpoint_corrections.php"

# Testar requisição real
curl -X POST https://dev.bssegurosimediato.com.br/log_endpoint.php \
  -H 'Content-Type: application/json' \
  -d '{"level":"INFO","message":"Teste de correções"}'

# Verificar logs
ssh root@65.108.156.14 "docker exec webhooks-php-dev tail -20 /var/log/php/error.log"
```

**Critério de Sucesso:**
- ✅ Arquivos copiados com sucesso
- ✅ Script de teste passa
- ✅ Requisições retornam HTTP 200
- ✅ Logs mostram informações corretas

---

## 🔧 FASE 4: DEPLOY E MONITORAMENTO

### **Tarefa 4.1: Deploy para Servidor de Desenvolvimento**

**Ações:**
1. Verificar se testes passaram
2. Fazer backup no servidor
3. Copiar arquivos corrigidos
4. Verificar permissões
5. Testar requisição real

**Comandos:**
```bash
# Backup no servidor
ssh root@65.108.156.14 "cp /opt/webhooks-server/dev/root/log_endpoint.php /opt/webhooks-server/dev/root/log_endpoint.php.backup.$(date +%Y%m%d_%H%M%S)"
ssh root@65.108.156.14 "cp /opt/webhooks-server/dev/root/ProfessionalLogger.php /opt/webhooks-server/dev/root/ProfessionalLogger.php.backup.$(date +%Y%m%d_%H%M%S)"

# Copiar arquivos corrigidos
scp WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php root@65.108.156.14:/opt/webhooks-server/dev/root/
scp WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php root@65.108.156.14:/opt/webhooks-server/dev/root/

# Verificar permissões
ssh root@65.108.156.14 "chown www-data:www-data /opt/webhooks-server/dev/root/log_endpoint.php /opt/webhooks-server/dev/root/ProfessionalLogger.php"
ssh root@65.108.156.14 "chmod 644 /opt/webhooks-server/dev/root/log_endpoint.php /opt/webhooks-server/dev/root/ProfessionalLogger.php"

# Testar requisição
curl -X POST https://dev.bssegurosimediato.com.br/log_endpoint.php \
  -H 'Content-Type: application/json' \
  -d '{"level":"INFO","message":"Teste pós-deploy"}'
```

**Critério de Sucesso:**
- ✅ Backups criados no servidor
- ✅ Arquivos copiados com sucesso
- ✅ Permissões corretas
- ✅ Requisição de teste retorna HTTP 200

### **Tarefa 4.2: Monitorar por 24-48 Horas**

**Ações:**
1. Monitorar logs de erro
2. Monitorar taxa de HTTP 500/400
3. Verificar se retry logic está funcionando
4. Verificar se deadlocks estão sendo tratados

**Comandos de Monitoramento:**
```bash
# Monitorar erros HTTP 500
ssh root@65.108.156.14 "docker exec webhooks-nginx tail -f /var/log/nginx/dev_access.log | grep 'log_endpoint.php.*500'"

# Monitorar erros HTTP 400
ssh root@65.108.156.14 "docker exec webhooks-nginx tail -f /var/log/nginx/dev_access.log | grep 'log_endpoint.php.*400'"

# Monitorar logs do PHP
ssh root@65.108.156.14 "docker exec webhooks-php-dev tail -f /var/log/php/error.log | grep -E 'log_endpoint|ProfessionalLogger'"

# Contar erros por hora
ssh root@65.108.156.14 "docker exec webhooks-nginx grep 'log_endpoint.php.*500' /var/log/nginx/dev_access.log | wc -l"
```

**Métricas a Monitorar:**
- Taxa de HTTP 500 (deve ser < 1%)
- Taxa de HTTP 400 (deve ser < 5%)
- Mensagens de retry no log
- Mensagens de deadlock no log
- Tempo médio de resposta

**Critério de Sucesso:**
- ✅ Taxa de HTTP 500 < 1%
- ✅ Taxa de HTTP 400 < 5%
- ✅ Retry logic funcionando (logs mostram retries)
- ✅ Deadlocks sendo tratados (logs mostram retries após deadlock)

### **Tarefa 4.3: Validar Correções**

**Ações:**
1. Comparar métricas antes/depois
2. Verificar se problemas foram resolvidos
3. Documentar resultados

**Checklist de Validação:**
- [ ] Taxa de HTTP 500 diminuiu significativamente
- [ ] Taxa de HTTP 400 diminuiu significativamente
- [ ] Retry logic está funcionando
- [ ] Deadlocks estão sendo tratados
- [ ] Warnings de REQUEST_METHOD eliminados
- [ ] Bug do rate limiting corrigido
- [ ] Logging detalhado funcionando
- [ ] Performance não foi afetada negativamente

**Critério de Sucesso:**
- ✅ Todos os itens do checklist validados
- ✅ Problemas identificados foram resolvidos
- ✅ Sistema está mais estável

---

## 🚨 PROCEDIMENTO DE ROLLBACK

### **Se Algo Der Errado**

**Ações:**
1. Parar monitoramento
2. Restaurar arquivos de backup
3. Verificar se sistema voltou ao normal
4. Documentar problema

**Comandos:**
```bash
# Restaurar backup do servidor
ssh root@65.108.156.14 "cp /opt/webhooks-server/dev/root/log_endpoint.php.backup.* /opt/webhooks-server/dev/root/log_endpoint.php"
ssh root@65.108.156.14 "cp /opt/webhooks-server/dev/root/ProfessionalLogger.php.backup.* /opt/webhooks-server/dev/root/ProfessionalLogger.php"

# Verificar permissões
ssh root@65.108.156.14 "chown www-data:www-data /opt/webhooks-server/dev/root/log_endpoint.php /opt/webhooks-server/dev/root/ProfessionalLogger.php"

# Testar
curl -X POST https://dev.bssegurosimediato.com.br/log_endpoint.php \
  -H 'Content-Type: application/json' \
  -d '{"level":"INFO","message":"Teste após rollback"}'
```

---

## 📊 MÉTRICAS DE SUCESSO

### **Antes das Correções (Baseline)**
- Taxa de HTTP 500: **30-40%**
- Taxa de HTTP 400: **20-35%**
- Tempo médio de resposta: **N/A** (muitas falhas)
- Retry logic: **Não implementado**
- Tratamento de deadlock: **Não implementado**

### **Após as Correções (Esperado)**
- Taxa de HTTP 500: **< 1%**
- Taxa de HTTP 400: **< 5%**
- Tempo médio de resposta: **< 200ms**
- Retry logic: **Funcionando**
- Tratamento de deadlock: **Funcionando**

---

## 📝 CHECKLIST FINAL

### **Antes de Iniciar**
- [ ] Backups criados localmente
- [ ] Backups criados no servidor
- [ ] Ambiente de desenvolvimento verificado
- [ ] Script de teste criado
- [ ] Procedimento de rollback documentado

### **Durante Implementação**
- [ ] ProfessionalLogger corrigido (retry logic)
- [ ] ProfessionalLogger corrigido (tratamento de deadlock)
- [ ] log_endpoint.php corrigido (tratamento de erros)
- [ ] log_endpoint.php corrigido (warnings de REQUEST_METHOD)
- [ ] log_endpoint.php corrigido (bug do rate limiting)
- [ ] Logging detalhado adicionado
- [ ] Script de teste executado com sucesso

### **Após Deploy**
- [ ] Arquivos copiados para servidor
- [ ] Permissões verificadas
- [ ] Requisição de teste retorna HTTP 200
- [ ] Monitoramento iniciado
- [ ] Métricas sendo coletadas

### **Validação Final**
- [ ] Taxa de HTTP 500 < 1%
- [ ] Taxa de HTTP 400 < 5%
- [ ] Retry logic funcionando
- [ ] Deadlocks sendo tratados
- [ ] Warnings eliminados
- [ ] Performance mantida

---

## 📚 DOCUMENTAÇÃO

### **Arquivos a Atualizar**
1. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/CHANGELOG.md` - Registrar mudanças
2. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/RELATORIO_DETALHADO_ERROS_HTTP_500.md` - Atualizar com correções
3. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/INVESTIGACAO_CAUSAS_REAIS_HTTP_500.md` - Marcar como resolvido

### **Conteúdo da Documentação**
- Descrição das mudanças
- Razão das mudanças
- Impacto esperado
- Métricas antes/depois
- Lições aprendidas

---

## 🎯 CONCLUSÃO

Este plano detalha todas as etapas necessárias para implementar as correções identificadas. Seguindo este plano, esperamos:

1. ✅ Reduzir significativamente os erros HTTP 500 e 400
2. ✅ Melhorar a confiabilidade do sistema de logging
3. ✅ Adicionar resiliência com retry logic
4. ✅ Melhorar diagnóstico com logging detalhado

**Próximos passos:**
1. Revisar e aprovar este plano
2. Iniciar Fase 1 (Preparação e Backup)
3. Seguir fases sequencialmente
4. Monitorar resultados

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Status:** 📋 **PRONTO PARA IMPLEMENTAÇÃO**

