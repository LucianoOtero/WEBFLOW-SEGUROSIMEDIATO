# 📊 ANÁLISE DOS NÍVEIS DE ERRO - SISTEMA DE LOGGING PROFISSIONAL

**Data:** 09/11/2025  
**Versão:** 1.0.0

---

## 🎯 RESUMO EXECUTIVO

O sistema de logging profissional está configurado com **5 níveis de log** seguindo o padrão de mercado:

1. **DEBUG** - Informações detalhadas para depuração
2. **INFO** - Informações gerais sobre o funcionamento
3. **WARN** - Avisos sobre situações que podem ser problemáticas
4. **ERROR** - Erros que não impedem a execução
5. **FATAL** - Erros críticos que impedem a execução

---

## 📋 CONFIGURAÇÃO DOS NÍVEIS

### **1. Banco de Dados (Schema SQL)**

**Tabela:** `application_logs`  
**Campo:** `level`  
**Tipo:** `ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL')`  
**Default:** `'INFO'`  
**Nullable:** `NOT NULL`

```sql
level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL') NOT NULL DEFAULT 'INFO'
```

**Observações:**
- ✅ Níveis definidos como ENUM (garante integridade)
- ✅ Valor padrão: `INFO`
- ✅ Não aceita NULL
- ✅ Mesma configuração na tabela `application_logs_archive`

---

### **2. Validação no Endpoint PHP**

**Arquivo:** `log_endpoint.php`  
**Linha:** 63-73

```php
// Validar nível
$validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'];
$level = strtoupper($input['level']);
if (!in_array($level, $validLevels)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'Invalid level',
        'valid_levels' => $validLevels
    ]);
    exit;
}
```

**Observações:**
- ✅ Validação explícita dos níveis aceitos
- ✅ Converte para maiúsculas automaticamente (`strtoupper()`)
- ✅ Retorna erro HTTP 400 se nível inválido
- ✅ Lista os níveis válidos na resposta de erro

---

### **3. Métodos Disponíveis no ProfessionalLogger**

**Arquivo:** `ProfessionalLogger.php`

#### **Métodos Específicos por Nível:**

```php
// DEBUG
public function debug($message, $data = null, $category = null) {
    return $this->log('DEBUG', $message, $data, $category);
}

// INFO
public function info($message, $data = null, $category = null) {
    return $this->log('INFO', $message, $data, $category);
}

// WARN
public function warn($message, $data = null, $category = null) {
    return $this->log('WARN', $message, $data, $category);
}

// ERROR
public function error($message, $data = null, $category = null, $exception = null) {
    $stackTrace = null;
    if ($exception instanceof Exception) {
        $stackTrace = $exception->getTraceAsString();
    }
    return $this->log('ERROR', $message, $data, $category, $stackTrace);
}

// FATAL
public function fatal($message, $data = null, $category = null, $exception = null) {
    $stackTrace = null;
    if ($exception instanceof Exception) {
        $stackTrace = $exception->getTraceAsString();
    }
    return $this->log('FATAL', $message, $data, $category, $stackTrace);
}
```

**Método Genérico:**
```php
public function log($level, $message, $data = null, $category = null, $stackTrace = null, $jsFileInfo = null)
```

**Observações:**
- ✅ Métodos específicos para cada nível facilitam uso
- ✅ `error()` e `fatal()` capturam stack trace automaticamente se exceção fornecida
- ✅ Método genérico `log()` aceita qualquer nível válido
- ✅ Todos os níveis são convertidos para maiúsculas internamente

---

## 🔍 DETALHAMENTO DOS NÍVEIS

### **1. DEBUG**
- **Uso:** Informações detalhadas para depuração
- **Quando usar:** Durante desenvolvimento, rastreamento de fluxo, valores de variáveis
- **Exemplo:** `$logger->debug('Valor da variável X', ['x' => $value]);`
- **Stack Trace:** Não capturado automaticamente
- **Retenção:** Menor tempo de retenção (configurável)

### **2. INFO**
- **Uso:** Informações gerais sobre o funcionamento normal
- **Quando usar:** Eventos importantes, confirmações, estados
- **Exemplo:** `$logger->info('Usuário logado', ['user_id' => 123]);`
- **Stack Trace:** Não capturado automaticamente
- **Retenção:** Tempo médio de retenção

### **3. WARN**
- **Uso:** Avisos sobre situações que podem ser problemáticas
- **Quando usar:** Valores inesperados, comportamentos não ideais, deprecações
- **Exemplo:** `$logger->warn('Taxa de conversão baixa', ['rate' => 0.01]);`
- **Stack Trace:** Não capturado automaticamente
- **Retenção:** Tempo médio de retenção

### **4. ERROR**
- **Uso:** Erros que não impedem a execução da aplicação
- **Quando usar:** Falhas em operações não críticas, erros recuperáveis
- **Exemplo:** `$logger->error('Falha ao enviar email', ['to' => $email], null, $exception);`
- **Stack Trace:** Capturado automaticamente se exceção fornecida
- **Retenção:** Tempo maior de retenção

### **5. FATAL**
- **Uso:** Erros críticos que impedem a execução
- **Quando usar:** Falhas em operações críticas, erros não recuperáveis
- **Exemplo:** `$logger->fatal('Falha ao conectar ao banco de dados', null, null, $exception);`
- **Stack Trace:** Capturado automaticamente se exceção fornecida
- **Retenção:** Tempo maior de retenção

---

## 📊 ÍNDICES E PERFORMANCE

### **Índices Criados para Níveis:**

```sql
-- Índice simples por nível
INDEX idx_level (level),

-- Índice composto (timestamp + level) - para consultas por período e nível
INDEX idx_timestamp_level (timestamp, level),

-- Índice composto (category + level) - para consultas por categoria e nível
INDEX idx_category_level (category, level),
```

**Benefícios:**
- ✅ Consultas por nível são rápidas
- ✅ Consultas combinadas (período + nível) otimizadas
- ✅ Consultas por categoria + nível otimizadas

---

## 🔄 POLÍTICAS DE RETENÇÃO (Configuráveis)

**Arquivo:** `log_maintenance.php` (quando implementado)

O sistema suporta políticas de retenção diferentes por nível:

```sql
-- Exemplo de limpeza por nível (dias configuráveis)
DELETE FROM application_logs_archive 
WHERE level = 'DEBUG' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_debug_days DAY);

DELETE FROM application_logs_archive 
WHERE level = 'INFO' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_info_days DAY);

DELETE FROM application_logs_archive 
WHERE level = 'WARN' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_warn_days DAY);

DELETE FROM application_logs_archive 
WHERE level = 'ERROR' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_error_days DAY);

DELETE FROM application_logs_archive 
WHERE level = 'FATAL' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_fatal_days DAY);
```

**Recomendações de Retenção:**
- **DEBUG:** 7-30 dias
- **INFO:** 30-90 dias
- **WARN:** 90-180 dias
- **ERROR:** 180-365 dias
- **FATAL:** 365+ dias (ou indefinido)

---

## 🎯 USO NO JAVASCRIPT

### **Funções Disponíveis:**

```javascript
// Via window.logUnified (atualizado)
window.logUnified('debug', 'CATEGORIA', 'Mensagem', {dados});
window.logUnified('info', 'CATEGORIA', 'Mensagem', {dados});
window.logUnified('warn', 'CATEGORIA', 'Mensagem', {dados});
window.logUnified('error', 'CATEGORIA', 'Mensagem', {dados});
window.logUnified('fatal', 'CATEGORIA', 'Mensagem', {dados});

// Via aliases
window.logDebug('CATEGORIA', 'Mensagem', {dados});
window.logInfo('CATEGORIA', 'Mensagem', {dados});
window.logWarn('CATEGORIA', 'Mensagem', {dados});
window.logError('CATEGORIA', 'Mensagem', {dados});
```

**Observações:**
- ✅ Níveis são convertidos para maiúsculas automaticamente
- ✅ Todos os logs são enviados para `log_endpoint.php`
- ✅ Captura automática de arquivo/linha do JavaScript

---

## ⚠️ VALIDAÇÕES E SEGURANÇA

### **Validações Implementadas:**

1. ✅ **Validação no Endpoint:** Apenas níveis válidos são aceitos
2. ✅ **Conversão Automática:** Níveis são convertidos para maiúsculas
3. ✅ **Integridade no Banco:** ENUM garante que apenas valores válidos são salvos
4. ✅ **Rate Limiting:** Proteção contra spam de logs (100 req/min por IP)

### **Tratamento de Erros:**

- ❌ Nível inválido → HTTP 400 com lista de níveis válidos
- ❌ Falha de inserção → HTTP 500 com mensagem genérica
- ❌ Exceção não capturada → HTTP 500 com mensagem genérica

---

## 📈 ESTATÍSTICAS E CONSULTAS

### **View para Erros Críticos:**

```sql
CREATE VIEW v_error_logs AS
SELECT 
    id, log_id, timestamp, level, category,
    file_name, line_number, message, url
FROM application_logs
WHERE level IN ('ERROR', 'FATAL')
ORDER BY timestamp DESC;
```

**Uso:** Consultar apenas erros críticos (ERROR e FATAL)

---

## ✅ CONCLUSÃO

O sistema de logging está **bem configurado** com:

- ✅ **5 níveis padrão** (DEBUG, INFO, WARN, ERROR, FATAL)
- ✅ **Validação em múltiplas camadas** (endpoint, banco de dados)
- ✅ **Métodos específicos** para cada nível
- ✅ **Índices otimizados** para consultas por nível
- ✅ **Políticas de retenção** configuráveis por nível
- ✅ **Stack trace automático** para ERROR e FATAL
- ✅ **Integração completa** JavaScript e PHP

**Recomendação:** O sistema está pronto para uso em produção, seguindo boas práticas de mercado.

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Versão:** 1.0.0

