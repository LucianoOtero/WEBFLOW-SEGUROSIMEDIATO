# 🔬 INVESTIGAÇÃO DAS CAUSAS REAIS DE HTTP 500

**Data:** 09/11/2025  
**Foco:** Investigar as causas mais prováveis de HTTP 500 baseado no conhecimento do sistema

---

## 🎯 HIPÓTESES PRINCIPAIS

Baseado no conhecimento do sistema, as causas mais prováveis são:

1. **ProfessionalLogger retornando `false` (linha 197)** → HTTP 500
2. **Warnings de `REQUEST_METHOD` (linhas 18, 24, 29)** → HTTP 500

---

## 🔴 CAUSA #1: ProfessionalLogger Retornando `false`

### **Análise do Código**

**Arquivo:** `log_endpoint.php`, linha 197-206

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

### **Quando ProfessionalLogger Retorna `false`?**

#### **Cenário 1.1: Conexão MySQL Falha**

**Arquivo:** `ProfessionalLogger.php`, linhas 91-118

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
        return null;  // ⚠️ Retorna null em caso de falha
    }
}
```

**Análise:**
- ✅ Se conexão MySQL falhar, `connect()` retorna `null`
- ✅ `insertLog()` verifica se `$pdo === null` e retorna `false`
- ✅ `log()` retorna `false` se `insertLog()` retornar `false`
- ✅ `log_endpoint.php` recebe `false` → HTTP 500

**Quando acontece:**
- MySQL está offline ou inacessível
- Credenciais incorretas
- Timeout de conexão (PDO::ATTR_TIMEOUT => 5)
- Firewall bloqueando conexão
- Banco de dados não existe

#### **Cenário 1.2: Inserção no Banco Falha**

**Arquivo:** `ProfessionalLogger.php`, linhas 316-319

```php
} catch (PDOException $e) {
    error_log("ProfessionalLogger: Failed to insert log - " . $e->getMessage());
    return false;  // ⚠️ Retorna false em caso de exceção
}
```

**Análise:**
- ✅ Se inserção falhar (exceção PDO), retorna `false`
- ✅ `log_endpoint.php` recebe `false` → HTTP 500

**Quando acontece:**
- Tabela não existe
- Stored procedure não existe ou tem erro
- Violação de constraint
- Timeout durante inserção
- Deadlock no banco

#### **Cenário 1.3: Verificação de Conexão em insertLog()**

**Arquivo:** `ProfessionalLogger.php`, linhas 240-250 (aproximado)

```php
private function insertLog($logData) {
    $pdo = $this->connect();
    
    if ($pdo === null) {
        return false;  // ⚠️ Retorna false se conexão falhar
    }
    
    // ... resto do código
}
```

**Análise:**
- ✅ Se `connect()` retornar `null`, `insertLog()` retorna `false` imediatamente
- ✅ Não tenta inserir no banco
- ✅ `log_endpoint.php` recebe `false` → HTTP 500

### **Por que Isso Causa HTTP 500 Intermitente?**

**Cenários Intermitentes:**

1. **Timeout de Conexão:**
   - MySQL pode estar lento ou sobrecarregado
   - `PDO::ATTR_TIMEOUT => 5` pode expirar
   - Conexão falha intermitentemente

2. **Deadlock no Banco:**
   - Múltiplas inserções simultâneas podem causar deadlock
   - MySQL retorna erro, ProfessionalLogger retorna `false`
   - HTTP 500 intermitente

3. **Conexão Perdida:**
   - Conexão PDO pode ser perdida entre requisições
   - Próxima requisição tenta usar conexão inválida
   - Falha e retorna `false`

### **Evidência nos Logs**

**O que procurar:**
```
ProfessionalLogger: Database connection failed - ...
ProfessionalLogger: Failed to insert log - ...
```

**Verificação necessária:**
- Verificar logs do PHP para essas mensagens
- Verificar logs do MySQL para erros de conexão
- Verificar se há timeouts ou deadlocks

---

## 🔴 CAUSA #2: Warnings de REQUEST_METHOD

### **Análise do Código**

**Arquivo:** `log_endpoint.php`, linhas 18, 24, 29

```php
// Linha 18
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {

// Linha 24
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {

// Linha 29
'method' => $_SERVER['REQUEST_METHOD']
```

### **Evidência nos Logs**

**Logs encontrados:**
```
[09-Nov-2025 15:24:30] PHP Warning: Undefined array key "REQUEST_METHOD" in /var/www/html/dev/root/log_endpoint.php on line 18
[09-Nov-2025 15:24:30] PHP Warning: Undefined array key "REQUEST_METHOD" in /var/www/html/dev/root/log_endpoint.php on line 24
[09-Nov-2025 15:24:30] PHP Warning: Undefined array key "REQUEST_METHOD" in /var/www/html/dev/root/log_endpoint.php on line 29
```

### **Por que Isso Causa HTTP 500?**

#### **Cenário 2.1: PHP 8+ Trata Warnings Diferentemente**

**PHP 8+ Mudanças:**
- Acessar chave inexistente em array gera `Warning` (antes era `Notice`)
- Se `error_reporting` incluir `E_WARNING`, warning é gerado
- Se warning não for tratado, pode causar problemas

**Configuração Atual:**
```
error_reporting = 22527  // Inclui E_WARNING (2)
```

**Análise:**
- ✅ `error_reporting` inclui `E_WARNING`
- ✅ Acessar `$_SERVER['REQUEST_METHOD']` sem verificar gera warning
- ⚠️ Warning pode causar HTTP 500 se:
  - PHP-FPM estiver configurado para tratar warnings como fatais
  - Output do warning acontecer antes dos headers
  - Handler de erro customizado tratar warning como fatal

#### **Cenário 2.2: Output Antes dos Headers**

**Fluxo Problemático:**
```php
// Se warning gerar output antes deste ponto:
header('Content-Type: application/json');  // ⚠️ Headers já foram enviados
```

**Resultado:**
- PHP não pode enviar headers após output
- HTTP 500 é retornado

#### **Cenário 2.3: Quando REQUEST_METHOD Não Existe?**

**Quando acontece:**
1. **Script executado via CLI:**
   - `php log_endpoint.php` (sem servidor web)
   - `$_SERVER['REQUEST_METHOD']` não existe

2. **Requisição sem método HTTP:**
   - Configuração incorreta do servidor web
   - Proxy/Load balancer não passa método corretamente

3. **FastCGI mal configurado:**
   - Nginx não passa `REQUEST_METHOD` para PHP-FPM
   - Variável não está disponível

### **Por que Isso Causa HTTP 500 Intermitente?**

**Cenários Intermitentes:**

1. **Requisições via CLI vs Web:**
   - Algumas requisições podem ser executadas via CLI (testes, cron)
   - Outras via web (requisições normais)
   - Intermitente dependendo da origem

2. **Configuração do Nginx:**
   - Se `fastcgi_param REQUEST_METHOD` não estiver configurado
   - Algumas requisições podem não ter a variável
   - Intermitente

3. **Proxy/Load Balancer:**
   - Se houver proxy na frente, pode não passar método corretamente
   - Intermitente dependendo do proxy

---

## 🔍 ANÁLISE COMPARATIVA

### **Qual Causa é Mais Provável?**

#### **ProfessionalLogger Retornando `false`**

**Probabilidade:** 🔴 **ALTA**

**Razões:**
- ✅ Código claramente retorna `false` em múltiplos cenários
- ✅ Conexão MySQL pode falhar intermitentemente
- ✅ Timeout de 5 segundos pode expirar
- ✅ Deadlocks podem acontecer sob carga
- ✅ Não há tratamento de retry ou fallback

**Evidência:**
- ⚠️ Não encontrei logs específicos, mas código mostra que pode acontecer
- ⚠️ Requisições intermitentes sugerem problema de conexão/banco

#### **Warnings de REQUEST_METHOD**

**Probabilidade:** 🟡 **MÉDIA**

**Razões:**
- ✅ Warnings encontrados nos logs
- ✅ Código acessa `$_SERVER['REQUEST_METHOD']` sem verificar
- ⚠️ Mas warnings normalmente não causam HTTP 500 sozinhos
- ⚠️ Requer configuração específica do PHP-FPM

**Evidência:**
- ✅ Warnings encontrados nos logs
- ⚠️ Mas não há evidência de que causem HTTP 500 diretamente

---

## 🎯 CONCLUSÃO

### **Causa Mais Provável: ProfessionalLogger Retornando `false`**

**Razões:**
1. ✅ Código mostra claramente que pode retornar `false`
2. ✅ Problemas de conexão/banco são comuns e intermitentes
3. ✅ Não há tratamento de erro ou retry
4. ✅ Timeout de 5 segundos pode expirar facilmente
5. ✅ Deadlocks podem acontecer sob carga

### **Causa Secundária: Warnings de REQUEST_METHOD**

**Razões:**
1. ✅ Warnings encontrados nos logs
2. ⚠️ Mas normalmente não causam HTTP 500 sozinhos
3. ⚠️ Requer configuração específica para ser fatal

---

## ✅ RECOMENDAÇÕES DE CORREÇÃO

### **1. Corrigir ProfessionalLogger (PRIORIDADE CRÍTICA)**

#### **1.1. Adicionar Retry Logic**

```php
private function connect() {
    if ($this->pdo !== null) {
        return $this->pdo;
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
            error_log("ProfessionalLogger: Database connection failed (attempt $attempt/$maxRetries) - " . $e->getMessage());
            
            if ($attempt < $maxRetries) {
                sleep($retryDelay);
                continue;
            }
            
            return null;
        }
    }
    
    return null;
}
```

#### **1.2. Melhorar Tratamento de Erros em insertLog()**

```php
private function insertLog($logData) {
    $pdo = $this->connect();
    
    if ($pdo === null) {
        error_log("ProfessionalLogger: Cannot insert log - Database connection failed");
        return false;
    }
    
    try {
        // ... código de inserção ...
        
    } catch (PDOException $e) {
        $errorCode = $e->getCode();
        $errorMessage = $e->getMessage();
        
        // Log detalhado do erro
        error_log("ProfessionalLogger: Failed to insert log - Code: $errorCode, Message: $errorMessage");
        
        // Se for deadlock, tentar novamente uma vez
        if ($errorCode == 1213 || strpos($errorMessage, 'Deadlock') !== false) {
            error_log("ProfessionalLogger: Deadlock detected, retrying once...");
            try {
                // Tentar novamente
                // ... código de inserção ...
                return $result ? $logData['log_id'] : false;
            } catch (PDOException $e2) {
                error_log("ProfessionalLogger: Retry failed - " . $e2->getMessage());
                return false;
            }
        }
        
        return false;
    }
}
```

#### **1.3. Melhorar Tratamento em log_endpoint.php**

```php
$logId = $logger->log($level, $message, $data, $category, $stackTrace, $jsFileInfo);

if ($logId === false) {
    // ✅ ADICIONAR: Logar motivo da falha
    error_log("log_endpoint.php: Failed to insert log - Logger returned false");
    
    // ✅ ADICIONAR: Verificar se é problema de conexão
    $connection = $logger->getConnection();
    $connectionStatus = $connection !== null ? 'connected' : 'disconnected';
    
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
            ]
        ] : null)
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}
```

### **2. Corrigir Warnings de REQUEST_METHOD (PRIORIDADE ALTA)**

```php
// Linha 18
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {

// Linha 24
if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {

// Linha 29
'method' => $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN'
```

---

## 🧪 TESTES DE VALIDAÇÃO

### **Teste 1: Simular Falha de Conexão MySQL**

```bash
# Parar MySQL temporariamente
docker stop mysql-container

# Fazer requisição
curl -X POST https://dev.bssegurosimediato.com.br/log_endpoint.php \
  -H 'Content-Type: application/json' \
  -d '{"level":"INFO","message":"teste"}'

# Deve retornar HTTP 500: "Failed to insert log"
# Verificar logs: "ProfessionalLogger: Database connection failed"
```

### **Teste 2: Simular Timeout de Conexão**

```bash
# Configurar timeout muito baixo no ProfessionalLogger
# Fazer requisição
# Deve retornar HTTP 500 se timeout expirar
```

### **Teste 3: Verificar Warnings de REQUEST_METHOD**

```bash
# Executar script via CLI
docker exec webhooks-php-dev php /var/www/html/dev/root/log_endpoint.php

# Deve gerar warnings (mas não HTTP 500 se executado via CLI)
```

---

## 📝 PRÓXIMOS PASSOS

1. ✅ **Implementar correções do ProfessionalLogger** (retry logic, melhor tratamento de erros)
2. ✅ **Corrigir warnings de REQUEST_METHOD** (usar `??` operator)
3. ✅ **Adicionar logging detalhado** para capturar erros reais
4. ✅ **Monitorar por 24-48h** após implementação
5. ✅ **Validar se frequência de HTTP 500 diminuiu**

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025

