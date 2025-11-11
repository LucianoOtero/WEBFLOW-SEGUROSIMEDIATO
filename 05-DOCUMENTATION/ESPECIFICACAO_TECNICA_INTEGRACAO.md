# 🔧 ESPECIFICAÇÃO TÉCNICA - INTEGRAÇÃO DE LOGGING

**Data:** 09/11/2025  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Especificação técnica detalhada para integrar o novo sistema de logging profissional aos arquivos JavaScript e PHP existentes.

---

## 📐 ARQUITETURA DA SOLUÇÃO

### **Fluxo Atual (Antigo):**
```
JavaScript → fetch() → debug_logger_db.php → MySQL (tabela antiga)
```

### **Fluxo Novo:**
```
JavaScript → fetch() → log_endpoint.php → ProfessionalLogger.php → MySQL (application_logs)
PHP → ProfessionalLogger.php → MySQL (application_logs)
```

---

## 💻 IMPLEMENTAÇÃO JAVASCRIPT

### **1. Função de Captura de Arquivo/Linha**

```javascript
/**
 * Captura informações do arquivo e linha que chamou a função de log
 * @returns {Object} {file_name, file_path, line_number, function_name}
 */
function getCallerInfo() {
  try {
    const stack = new Error().stack;
    if (!stack) return { file_name: 'unknown', line_number: null, function_name: null };
    
    const stackLines = stack.split('\n');
    
    // Ignorar:
    // - linha 0: "Error"
    // - linha 1: getCallerInfo()
    // - linha 2: sendLogToProfessionalSystem()
    // - linha 3: window.logUnified()
    // Procurar a partir da linha 4 (primeira chamada real)
    
    for (let i = 4; i < stackLines.length; i++) {
      const line = stackLines[i].trim();
      
      // Padrão 1: "at functionName (file.js:123:45)"
      let match = line.match(/at\s+(?:\w+\.)?(\w+)\s+\(([^:]+):(\d+):(\d+)\)/);
      if (match) {
        const filePath = match[2];
        const fileName = filePath.split('/').pop().split('\\').pop();
        return {
          file_name: fileName,
          file_path: filePath,
          line_number: parseInt(match[3]),
          function_name: match[1]
        };
      }
      
      // Padrão 2: "at file.js:123:45"
      match = line.match(/at\s+([^:]+):(\d+):(\d+)/);
      if (match) {
        const filePath = match[1];
        const fileName = filePath.split('/').pop().split('\\').pop();
        return {
          file_name: fileName,
          file_path: filePath,
          line_number: parseInt(match[2]),
          function_name: null
        };
      }
    }
  } catch (e) {
    console.warn('[LOG] Erro ao capturar caller info:', e);
  }
  
  return {
    file_name: 'unknown',
    file_path: null,
    line_number: null,
    function_name: null
  };
}
```

### **2. Função de Envio para Novo Sistema**

```javascript
/**
 * Envia log para o novo sistema profissional
 * @param {string} level - Nível do log (DEBUG, INFO, WARN, ERROR, FATAL)
 * @param {string} category - Categoria do log (UTILS, MODAL, RPA, etc.)
 * @param {string} message - Mensagem do log
 * @param {*} data - Dados adicionais (opcional)
 * @returns {Promise<boolean>} true se enviado com sucesso
 */
async function sendLogToProfessionalSystem(level, category, message, data) {
  // Verificar se logs estão desabilitados
  if (window.DEBUG_CONFIG && 
      (window.DEBUG_CONFIG.enabled === false || window.DEBUG_CONFIG.enabled === 'false')) {
    return false;
  }
  
  try {
    // Capturar informações do caller
    const callerInfo = getCallerInfo();
    
    // Construir URL do endpoint
    const baseUrl = window.APP_BASE_URL || 'https://dev.bssegurosimediato.com.br';
    const endpoint = baseUrl + '/log_endpoint.php';
    
    // Preparar payload
    const logData = {
      level: level.toUpperCase(), // Garantir maiúsculas
      category: category || null,
      message: message,
      data: data || null,
      session_id: window.sessionId || null,
      url: window.location.href
    };
    
    // Enviar requisição
    const response = await fetch(endpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(logData),
      mode: 'cors',
      credentials: 'omit'
    });
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    
    const result = await response.json();
    
    if (result.success) {
      // Log no console apenas se DEBUG_CONFIG permitir
      if (!window.DEBUG_CONFIG || 
          (window.DEBUG_CONFIG.enabled !== false && window.DEBUG_CONFIG.enabled !== 'false')) {
        console.debug(`[LOG] Enviado: ${result.log_id}`);
      }
      return true;
    } else {
      console.error('[LOG] Erro no servidor:', result.error);
      return false;
    }
    
  } catch (error) {
    // Não quebrar aplicação se logging falhar
    console.error('[LOG] Erro ao enviar log:', error);
    return false;
  }
}
```

### **3. Integração com window.logUnified()**

```javascript
// Função unificada de log (ATUALIZADA)
window.logUnified = function(level, category, message, data) {
  // VERIFICAÇÃO PRIORITÁRIA: Bloquear ANTES de qualquer execução
  if (window.DEBUG_CONFIG && 
      (window.DEBUG_CONFIG.enabled === false || window.DEBUG_CONFIG.enabled === 'false')) {
    return;
  }
  
  // Enviar para novo sistema profissional (assíncrono, não bloqueia)
  sendLogToProfessionalSystem(level, category, message, data).catch(() => {
    // Silenciosamente ignorar erros de logging
  });
  
  // Manter comportamento original do console (filtros, etc.)
  const config = window.DEBUG_CONFIG || {};
  const env = (config.environment === 'auto') ? 
    (window.location.hostname.includes('webflow.io') || 
     window.location.hostname.includes('localhost') ||
     window.location.hostname.includes('dev.')) ? 'dev' : 'prod' 
    : config.environment;
  
  if (env === 'prod' && !config.level) {
    config.level = 'error';
  }
  
  const levels = { 'none': 0, 'error': 1, 'warn': 2, 'info': 3, 'debug': 4, 'all': 5 };
  const currentLevel = levels[config.level] || levels['info'];
  const messageLevel = levels[level] || levels['info'];
  
  if (messageLevel > currentLevel) return;
  
  if (config.exclude && config.exclude.length > 0) {
    if (category && config.exclude.includes(category)) return;
  }
  
  const formattedMessage = category ? `[${category}] ${message}` : message;
  
  switch(level) {
    case 'error':
      console.error(formattedMessage, data || '');
      break;
    case 'warn':
      console.warn(formattedMessage, data || '');
      break;
    case 'info':
    case 'debug':
    default:
      console.log(formattedMessage, data || '');
      break;
  }
};

// Aliases mantidos (sem alteração)
window.logInfo = (cat, msg, data) => window.logUnified('info', cat, msg, data);
window.logError = (cat, msg, data) => window.logUnified('error', cat, msg, data);
window.logWarn = (cat, msg, data) => window.logUnified('warn', cat, msg, data);
window.logDebug = (cat, msg, data) => window.logUnified('debug', cat, msg, data);
```

### **4. Atualizar função logDebug() existente**

**Localização:** Linha ~1156 em `FooterCodeSiteDefinitivoCompleto.js`

**Substituir:**
```javascript
function logDebug(level, message, data = null) {
  // ... código atual ...
  const debugLoggerUrl = window.APP_BASE_URL + '/debug_logger_db.php';
  // ... resto do código ...
}
```

**Por:**
```javascript
function logDebug(level, message, data = null) {
  // Verificar se logs estão desabilitados
  if (window.DEBUG_CONFIG && 
      (window.DEBUG_CONFIG.enabled === false || window.DEBUG_CONFIG.enabled === 'false')) {
    return;
  }
  
  // Usar novo sistema profissional
  sendLogToProfessionalSystem(level, null, message, data);
  
  // Manter console.log para desenvolvimento local
  if (!window.DEBUG_CONFIG || 
      (window.DEBUG_CONFIG.enabled !== false && window.DEBUG_CONFIG.enabled !== 'false')) {
    console.log(`[${level}] ${message}`, data);
  }
}
```

---

## 🐘 IMPLEMENTAÇÃO PHP

### **Padrão de Integração**

**Em cada arquivo PHP que precisa de logging:**

```php
<?php
// No início do arquivo, após outras includes
require_once __DIR__ . '/ProfessionalLogger.php';

// Criar instância (reutilizar se possível)
$logger = new ProfessionalLogger();

// Usar em pontos de logging
try {
    // Código...
    $logger->info('Operação realizada com sucesso', ['id' => $id], 'CATEGORY');
} catch (Exception $e) {
    $logger->error('Erro na operação', ['error' => $e->getMessage()], 'CATEGORY', $e);
}
```

### **Categorias Sugeridas para PHP:**
- `API` - Chamadas de API externas
- `VALIDATION` - Validações (CPF, placa, etc.)
- `EMAIL` - Envio de emails
- `DATABASE` - Operações de banco de dados
- `WEBHOOK` - Processamento de webhooks

---

## 🔄 COMPATIBILIDADE

### **Manter Compatibilidade:**
- ✅ Todas as chamadas existentes de `window.logUnified()` continuam funcionando
- ✅ Todos os aliases (`logInfo`, `logError`, etc.) continuam funcionando
- ✅ `window.DEBUG_CONFIG` continua funcionando
- ✅ Filtros de nível e categoria continuam funcionando

### **Melhorias Adicionais:**
- ✅ Captura automática de arquivo/linha
- ✅ Logs salvos em banco de dados estruturado
- ✅ Consulta e recuperação eficiente
- ✅ Estatísticas e análises

---

## ⚠️ CONSIDERAÇÕES IMPORTANTES

### **Performance:**
- Logs são enviados de forma assíncrona (não bloqueiam execução)
- Se logging falhar, não quebra a aplicação
- Rate limiting no servidor protege contra spam

### **Segurança:**
- Dados sensíveis são sanitizados automaticamente
- CORS configurado corretamente
- Validação de entrada no servidor

### **Manutenibilidade:**
- Código centralizado e reutilizável
- Fácil de adicionar novos pontos de log
- Consulta e análise facilitadas

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025

