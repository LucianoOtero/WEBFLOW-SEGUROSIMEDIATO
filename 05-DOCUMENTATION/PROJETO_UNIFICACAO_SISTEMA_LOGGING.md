# 🔧 PROJETO: Unificação do Sistema de Logging

**Data de Criação:** 16/11/2025  
**Status:** 📋 **PLANO ATUALIZADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.1.0 (Atualizado após análise crítica do desenvolvedor)  
**Prioridade:** 🔴 **CRÍTICA** (unifica todos os sistemas de logging, resolve inconsistências)  
**Última Atualização:** 16/11/2025 - Simplificações aplicadas após análise crítica

---

## 🎯 OBJETIVO

Unificar todos os sistemas de logging do projeto em um sistema único, padronizado e parametrizável que:

1. ✅ Identifique automaticamente: programa, linha, classificação, timestamp, descrição estruturada
2. ✅ Permita registro no banco de dados (parametrizável: ligar/desligar, nível de severidade)
3. ✅ Permita exibição no console (parametrizável: ligar/desligar, nível de severidade)
4. ✅ Elimine logs em arquivo texto (exceto fallback do PHP para erros de banco)
5. ✅ Prevenha chamadas recursivas/infinitas
6. ✅ Siga boas práticas de sistemas de logging

---

## 📊 SITUAÇÃO ATUAL

### **Problemas Identificados (Análise Completa):**

#### **JavaScript:**
- ❌ 6 sistemas diferentes de logging coexistem
- ❌ `logClassified()` não persiste no banco (285+ ocorrências)
- ❌ `logUnified()` deprecated mas funcional
- ❌ `debugLog()` e `logEvent()` específicos do modal
- ❌ `console.*` direto não padronizado

#### **PHP:**
- ❌ 5 sistemas diferentes de logging coexistem
- ❌ `logDevWebhook()` / `logProdWebhook()` não persistem no banco
- ❌ `logProdWebhook()` tem formato diferente em arquivos diferentes
- ❌ Webhooks não usam `ProfessionalLogger`

### **Sistemas Atuais:**

| Sistema | Linguagem | Persiste no Banco | Parametrizável | Status |
|---------|-----------|-------------------|----------------|--------|
| `logClassified()` | JS | ❌ Não | ✅ Sim | ✅ Ativo |
| `sendLogToProfessionalSystem()` | JS | ✅ Sim | ✅ Sim | ✅ Ativo |
| `logUnified()` | JS | ✅ Sim | ✅ Sim | ⚠️ Deprecated |
| `debugLog()` / `logEvent()` | JS | ❌ Não | ✅ Sim | ✅ Ativo |
| `ProfessionalLogger` | PHP | ✅ Sim | ✅ Sim | ✅ Ativo |
| `logDevWebhook()` / `logProdWebhook()` | PHP | ❌ Não | ⚠️ Parcial | ✅ Ativo |

---

## 🎯 OBJETIVOS DO PROJETO

### **1. Sistema Unificado de Logging**

**JavaScript:**
- ✅ Criar `UnifiedLogger` que substitua todos os sistemas atuais
- ✅ Captura automática: programa, linha, função, timestamp
- ✅ Classificação: DEBUG, INFO, WARN, ERROR, FATAL
- ✅ Descrição estruturada (5Ws: When, Who, What, Where, Why)

**PHP:**
- ✅ Aprimorar `ProfessionalLogger` para ser o sistema único
- ✅ Substituir `logDevWebhook()` / `logProdWebhook()` por `ProfessionalLogger`
- ✅ Manter fallback para arquivo apenas em erros críticos de banco

### **2. Parametrização Completa**

**Configuração via Variáveis de Ambiente:**

```javascript
// JavaScript (window.LOG_CONFIG) - Com valores padrão sensatos
window.LOG_CONFIG = window.LOG_CONFIG || {
  enabled: true,
  database: {
    enabled: true,
    minLevel: 'INFO'  // Padrão sensato: apenas INFO e acima no banco
  },
  console: {
    enabled: true,
    minLevel: 'DEBUG'  // Padrão sensato: DEBUG e acima no console
  },
  preventRecursion: true,
  maxRecursionDepth: 3
};
```

**Simplificação:** Sistema funciona out-of-the-box, configuração é opcional

```php
// PHP ($_ENV)
LOG_ENABLED=true
LOG_DATABASE_ENABLED=true
LOG_DATABASE_MIN_LEVEL=INFO
LOG_CONSOLE_ENABLED=true
LOG_CONSOLE_MIN_LEVEL=DEBUG
LOG_PREVENT_RECURSION=true
LOG_MAX_RECURSION_DEPTH=3
```

### **3. Prevenção de Recursão Infinita (SIMPLIFICADO)**

**Mecanismos Essenciais:**
- ✅ Flag de controle de recursão (simples)
- ✅ Limite máximo de profundidade de recursão (simples)
- ⚠️ Stack de chamadas (opcional - apenas se necessário)
- ❌ Lista de exclusão (não necessário inicialmente)
- ❌ Timeout (não necessário - operações são síncronas)

**Simplificação:** Flag + limite de profundidade resolve 99% dos casos

### **4. Estrutura de Log Padronizada (SIMPLIFICADA)**

**Formato Estruturado (5Ws - Essencial):**
```json
{
  "when": "2025-11-16T17:30:00.123Z",
  "who": {
    "file": "webflow_injection_limpo.js",
    "line": 2891,
    "function": "handleFormSubmit"
  },
  "what": {
    "level": "INFO",
    "category": "RPA",
    "message": "Iniciando processo RPA"
  },
  "where": {
    "url": "https://dev.bssegurosimediato.com.br/",
    "environment": "development"
  },
  "why": {
    "data": {
      "form_fields": 15,
      "validation_passed": true
    },
    "context": "OPERATION"
  }
}
```

**Simplificação:** Mantém essencial, remove detalhes desnecessários (file_path completo, class_name, session_id, description gerada automaticamente)

---

## 📁 ARQUIVOS ENVOLVIDOS

### **Arquivos a Criar:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/UnifiedLogger.js` (novo sistema JavaScript)
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php` (aprimorar existente)

### **Arquivos a Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
  - ✅ Criar aliases de compatibilidade para `logClassified()`, `logUnified()`, `logInfo()`, `logError()`, `logWarn()`, `logDebug()`
  - ✅ Atualizar `sendLogToProfessionalSystem()` para usar `UnifiedLogger` internamente
  - ⚠️ **NÃO remover funções antigas** - Aliases mantêm compatibilidade total
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`
  - ✅ **NENHUMA modificação necessária** - Aliases em `FooterCodeSiteDefinitivoCompleto.js` já resolvem
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`
  - ✅ Criar wrappers simplificados para `debugLog()` e `logEvent()`
  - ⚠️ **NÃO remover funções antigas** - Wrappers mantêm compatibilidade total
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`
  - ✅ Criar wrappers simplificados para `logDevWebhook()` e `logProdWebhook()`
  - ⚠️ **NÃO remover funções antigas** - Wrappers mantêm compatibilidade total
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_webflow_octa.php`
  - ✅ Criar wrappers simplificados para `logProdWebhook()`
  - ⚠️ **NÃO remover funções antigas** - Wrappers mantêm compatibilidade total
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`
  - ✅ Adicionar variáveis de ambiente de logging (com valores padrão sensatos)

### **Arquivos de Documentação:**
- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/ANALISE_COMPLETA_PADROES_LOGGING.md`
- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PROJETO_CORRECAO_LOGCLASSIFIED_SENDLOG.md`

---

## 📁 BACKUPS A CRIAR

### **Antes de Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/2025-11-16_UNIFICACAO_LOGGING/`
  - `FooterCodeSiteDefinitivoCompleto.js.backup_ANTES_[timestamp]`
  - `webflow_injection_limpo.js.backup_ANTES_[timestamp]`
  - `MODAL_WHATSAPP_DEFINITIVO.js.backup_ANTES_[timestamp]`
  - `add_flyingdonkeys.php.backup_ANTES_[timestamp]`
  - `add_webflow_octa.php.backup_ANTES_[timestamp]`
  - `ProfessionalLogger.php.backup_ANTES_[timestamp]`
  - `php-fpm_www_conf_DEV.conf.backup_ANTES_[timestamp]`

---

## 🔄 FASES DO PROJETO (SIMPLIFICADAS)

### **FASE 1: Pesquisa e Design** ✅
- [x] Pesquisar boas práticas de logging (✅ já realizado)
- [x] Definir estrutura de log padronizada (5Ws - simplificada)
- [x] Definir mecanismos de prevenção de recursão (simplificados: flag + limite)
- [x] Criar especificação técnica completa
- [x] Validar design com análise de riscos (✅ auditoria técnica concluída)
- [x] Análise crítica do desenvolvedor (✅ simplificações aplicadas)

### **FASE 2: Implementação do UnifiedLogger.js** ⏳
- [ ] Criar classe `UnifiedLogger` com:
  - Captura automática de caller info (arquivo, linha, função) - simplificada
  - Estrutura de log padronizada (5Ws) - essencial apenas (campos opcionais se necessário)
  - Prevenção de recursão infinita - simplificada (flag + limite)
  - Parametrização completa (banco, console) - com valores padrão sensatos
  - Integração com `sendLogToProfessionalSystem()` - ⚠️ **CRÍTICO:** Adicionar flag de exclusão para evitar recursão
- [ ] Testar `UnifiedLogger` isoladamente
- [ ] Validar prevenção de recursão (flag + limite) - ⚠️ **OBRIGATÓRIO:** Testar recursão direta e indireta
- [ ] ⚠️ **CRÍTICO:** Validar que `UnifiedLogger` não causa loop infinito com `sendLogToProfessionalSystem()`

### **FASE 3: Aprimoramento do ProfessionalLogger.php** ⏳
- [ ] Adicionar prevenção de recursão infinita - simplificada (flag + limite)
- [ ] Adicionar parametrização completa (banco, console) - com valores padrão sensatos
- [ ] Aprimorar captura de caller info - simplificada
- [ ] Estrutura de log padronizada (5Ws) - essencial apenas
- [ ] Manter fallback para arquivo apenas em erros críticos
- [ ] Testar `ProfessionalLogger` aprimorado

### **FASE 4: Criar Aliases de Compatibilidade JavaScript** ⏳
- [ ] Criar backup de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Adicionar aliases de compatibilidade (após criação do `UnifiedLogger`):
  ```javascript
  // Aliases simples e diretos - manter permanentemente
  window.logClassified = function(level, category, message, data, context = 'OPERATION', verbosity = 'SIMPLE') {
      // verbosity é ignorado (não usado no UnifiedLogger, mas aceito para compatibilidade)
      return UnifiedLogger.log(level, category, message, data, context);
  };
  
  window.logUnified = function(level, category, message, data) {
      return UnifiedLogger.log(level, category, message, data, 'OPERATION');
  };
  
  window.logInfo = (cat, msg, data) => UnifiedLogger.info(cat, msg, data, 'OPERATION');
  window.logError = (cat, msg, data) => UnifiedLogger.error(cat, msg, data, 'ERROR_HANDLING');
  window.logWarn = (cat, msg, data) => UnifiedLogger.warn(cat, msg, data, 'ERROR_HANDLING');
  window.logDebug = (cat, msg, data) => UnifiedLogger.debug(cat, msg, data, 'OPERATION');
  ```
- [ ] ⚠️ **CRÍTICO:** Resolver dependência circular entre `sendLogToProfessionalSystem()` e `UnifiedLogger`:
  - **Opção 1 (RECOMENDADO):** Melhorar prevenção de recursão em `UnifiedLogger.logToDatabase()` para detectar especificamente `sendLogToProfessionalSystem()` na stack
  - **Opção 2 (ALTERNATIVA):** Adicionar flag específica em `logToDatabase()` para verificar se já está dentro de `sendLogToProfessionalSystem()`
  - **Opção 3 (FALLBACK):** Usar `console.log` direto em `sendLogToProfessionalSystem()` (quebra funcionalidade, mas elimina risco)
- [ ] Validar sintaxe JavaScript
- ⚠️ **NÃO remover funções antigas** - Aliases mantêm compatibilidade total
- 🔴 **NOTA TÉCNICA:** `sendLogToProfessionalSystem()` usa `logClassified()` internamente. Se `logClassified()` usar `UnifiedLogger`, e `UnifiedLogger.logToDatabase()` chamar `sendLogToProfessionalSystem()`, teremos loop infinito. **Solução recomendada:** Melhorar prevenção de recursão (Opção 1 ou 2) ao invés de quebrar funcionalidade (Opção 3).

### **FASE 5: Criar Wrappers de Compatibilidade MODAL_WHATSAPP_DEFINITIVO.js** ⏳
- [ ] Criar backup de `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Adicionar wrappers simplificados (substituir implementação atual):
  ```javascript
  // Wrapper simplificado para debugLog
  function debugLog(category, action, data = {}, level = 'info') {
      const levelMap = {
          'error': 'error',
          'warn': 'warn',
          'debug': 'debug',
          'info': 'info'
      };
      const method = levelMap[level] || 'info';
      return UnifiedLogger[method](category, action, data, 'OPERATION');
  }
  
  // Wrapper simplificado para logEvent
  function logEvent(eventType, data, severity = 'info') {
      const severityMap = {
          'error': 'error',
          'warning': 'warn',
          'info': 'info'
      };
      const method = severityMap[severity] || 'info';
      return UnifiedLogger[method]('MODAL', eventType, data, 'OPERATION');
  }
  ```
- [ ] Validar sintaxe JavaScript
- ⚠️ **NÃO remover funções antigas** - Wrappers mantêm compatibilidade total

### **FASE 6: Criar Wrappers de Compatibilidade PHP** ⏳
- [ ] Criar backup de `add_flyingdonkeys.php` e `add_webflow_octa.php`
- [ ] Adicionar wrappers simplificados (substituir implementação atual):
  ```php
  // Wrapper simplificado - usar mapeamento direto
  function logDevWebhook($event, $data, $success = true) {
      static $logger = null;
      if ($logger === null) {
          $logger = new ProfessionalLogger();
      }
      
      $level = $success ? 'info' : 'error';
      $category = 'FLYINGDONKEYS';  // ou 'OCTADESK' para add_webflow_octa.php
      
      return $logger->$level($event, $data, $category);
  }
  
  function logProdWebhook($event, $data, $success = true) {
      return logDevWebhook($event, $data, $success);
  }
  ```
- [ ] Validar sintaxe PHP
- ⚠️ **NÃO remover funções antigas** - Wrappers mantêm compatibilidade total

### **FASE 7: webflow_injection_limpo.js - NENHUMA MODIFICAÇÃO** ✅
- ✅ **NENHUMA modificação necessária** - Aliases em `FooterCodeSiteDefinitivoCompleto.js` já resolvem todas as chamadas
- ✅ Todas as 288 chamadas `logClassified()` funcionarão automaticamente via alias

### **FASE 8: Configuração de Variáveis de Ambiente** ⏳
- [ ] Adicionar variáveis de ambiente em `php-fpm_www_conf_DEV.conf` (com valores padrão sensatos):
  - `LOG_ENABLED=true` (padrão: true)
  - `LOG_DATABASE_ENABLED=true` (padrão: true)
  - `LOG_DATABASE_MIN_LEVEL=INFO` (padrão: INFO)
  - `LOG_CONSOLE_ENABLED=true` (padrão: true)
  - `LOG_CONSOLE_MIN_LEVEL=DEBUG` (padrão: DEBUG)
  - `LOG_PREVENT_RECURSION=true` (padrão: true)
  - `LOG_MAX_RECURSION_DEPTH=3` (padrão: 3)
- [ ] Documentar variáveis de ambiente JavaScript (`window.LOG_CONFIG`) - com valores padrão
- ⚠️ **Configuração é opcional** - Sistema funciona out-of-the-box

### **FASE 9: Deploy para Servidor DEV** ⏳
- [ ] Copiar arquivos modificados para servidor DEV
- [ ] Verificar hash após cópia
- [ ] Atualizar PHP-FPM com novas variáveis
- [ ] Reiniciar PHP-FPM
- [ ] Verificar permissões dos arquivos

### **FASE 10: Testes e Verificação** ⏳
- [ ] Testar logging em JavaScript (console e banco)
- [ ] Testar logging em PHP (console e banco)
- [ ] Testar prevenção de recursão
- [ ] Testar parametrização (ligar/desligar banco e console)
- [ ] Testar níveis de severidade
- [ ] Verificar logs no banco de dados
- [ ] Verificar logs no console

### **FASE 11: Documentação e Auditoria** ⏳
- [ ] Documentar sistema unificado
- [ ] Criar guia de uso
- [ ] Atualizar arquitetura do sistema
- [ ] Realizar auditoria pós-implementação
- [ ] Registrar conversa e atualizar histórico

---

## 📚 BOAS PRÁTICAS DE LOGGING (PESQUISADAS)

### **1. Estruturação de Logs (5Ws):**
- ✅ **When (Quando):** Timestamp preciso com timezone
- ✅ **Who (Quem):** Programa, linha, função, classe
- ✅ **What (O que):** Nível, categoria, mensagem, descrição
- ✅ **Where (Onde):** URL, sessão, ambiente, IP
- ✅ **Why (Por que):** Dados adicionais, contexto, metadata

### **2. Níveis de Log Padronizados:**
- ✅ **DEBUG:** Informações detalhadas para desenvolvimento
- ✅ **INFO:** Informações gerais sobre operações normais
- ✅ **WARN:** Avisos sobre situações anômalas mas não críticas
- ✅ **ERROR:** Erros que impedem operações específicas
- ✅ **FATAL:** Erros críticos que impedem o sistema

### **3. Prevenção de Recursão:**
- ✅ **Flag de controle:** Impedir múltiplas chamadas simultâneas
- ✅ **Stack de chamadas:** Detectar loops na pilha de execução
- ✅ **Limite de profundidade:** Máximo de níveis de recursão
- ✅ **Lista de exclusão:** Funções/arquivos que não devem ser logados
- ✅ **Timeout:** Limitar tempo de operações de logging

### **4. Parametrização:**
- ✅ **Ligar/desligar:** Controle global do sistema
- ✅ **Destinos configuráveis:** Banco, console, arquivo
- ✅ **Níveis de severidade:** Filtrar por nível mínimo
- ✅ **Configuração dinâmica:** Via variáveis de ambiente

### **5. Segurança:**
- ✅ **Sanitização de dados:** Remover informações sensíveis
- ✅ **Validação de entrada:** Verificar parâmetros antes de processar
- ✅ **Tratamento de erros:** Não quebrar aplicação se logging falhar
- ✅ **Fallback seguro:** Usar error_log nativo em caso de falha crítica

### **6. Performance:**
- ✅ **Operações assíncronas:** Não bloquear execução principal
- ✅ **Rate limiting:** Limitar quantidade de logs por tempo
- ✅ **Timeout:** Limitar tempo de operações
- ✅ **Lazy loading:** Carregar recursos apenas quando necessário

### **7. Padronização:**
- ✅ **Formato único:** Estrutura consistente para todos os logs
- ✅ **Nomenclatura:** Convenções claras de níveis e categorias
- ✅ **Documentação:** Guia de uso e boas práticas

---

## 🔧 ESPECIFICAÇÃO TÉCNICA

### **1. UnifiedLogger.js (JavaScript)**

#### **1.1. Estrutura da Classe:**

```javascript
class UnifiedLogger {
  constructor() {
    // Configuração padrão
    this.config = {
      enabled: true,
      database: {
        enabled: true,
        minLevel: 'INFO'  // DEBUG, INFO, WARN, ERROR, FATAL
      },
      console: {
        enabled: true,
        minLevel: 'DEBUG'
      },
      preventRecursion: true,
      maxRecursionDepth: 3,
      recursionStack: new Set(),  // Prevenir recursão
      excludedFunctions: [
        'sendLogToProfessionalSystem',
        'logClassified',
        'logUnified',
        'UnifiedLogger.log'
      ]
    };
    
    // Carregar configuração de window.LOG_CONFIG
    this.loadConfig();
  }
  
  loadConfig() {
    if (window.LOG_CONFIG) {
      this.config = { ...this.config, ...window.LOG_CONFIG };
    }
  }
  
  // Método principal de logging
  log(level, category, message, data, context = 'OPERATION') {
    // Prevenção de recursão
    if (this.config.preventRecursion) {
      if (this.isRecursiveCall()) {
        return false; // Silenciosamente ignorar
      }
      this.addToRecursionStack();
    }
    
    try {
      // Capturar informações do caller
      const callerInfo = this.captureCallerInfo();
      
      // Estruturar log (5Ws)
      const logEntry = this.structureLog(level, category, message, data, context, callerInfo);
      
      // Registrar no banco (se habilitado e nível suficiente)
      if (this.shouldLogToDatabase(level)) {
        this.logToDatabase(logEntry);
      }
      
      // Exibir no console (se habilitado e nível suficiente)
      if (this.shouldLogToConsole(level)) {
        this.logToConsole(logEntry);
      }
      
      return true;
    } catch (error) {
      // Em caso de erro, usar console.error nativo (não usar UnifiedLogger)
      console.error('[UnifiedLogger] Erro ao processar log:', error);
      return false;
    } finally {
      // Remover da stack de recursão
      if (this.config.preventRecursion) {
        this.removeFromRecursionStack();
      }
    }
  }
  
  // Métodos auxiliares
  captureCallerInfo() { ... }
  structureLog(level, category, message, data, context, callerInfo) { ... }
  shouldLogToDatabase(level) { ... }
  shouldLogToConsole(level) { ... }
  logToDatabase(logEntry) { ... }
  logToConsole(logEntry) { ... }
  isRecursiveCall() { ... }
  addToRecursionStack() { ... }
  removeFromRecursionStack() { ... }
  
  // Métodos de conveniência
  debug(category, message, data, context) { ... }
  info(category, message, data, context) { ... }
  warn(category, message, data, context) { ... }
  error(category, message, data, context) { ... }
  fatal(category, message, data, context) { ... }
}
```

#### **1.2. Prevenção de Recursão:**

```javascript
isRecursiveCall() {
  const stack = new Error().stack;
  const stackLines = stack.split('\n');
  
  // Contar quantas vezes UnifiedLogger aparece na stack
  let unifiedLoggerCount = 0;
  for (const line of stackLines) {
    if (line.includes('UnifiedLogger') || 
        line.includes('sendLogToProfessionalSystem') ||
        this.config.excludedFunctions.some(fn => line.includes(fn))) {
      unifiedLoggerCount++;
    }
  }
  
  // Se aparecer mais de maxRecursionDepth vezes, é recursão
  return unifiedLoggerCount > this.config.maxRecursionDepth;
}

addToRecursionStack() {
  const stackTrace = new Error().stack;
  const hash = this.hashStackTrace(stackTrace);
  
  if (this.config.recursionStack.has(hash)) {
    throw new Error('Recursive logging detected');
  }
  
  this.config.recursionStack.add(hash);
  
  // Limpar stack após timeout (prevenir memory leak)
  setTimeout(() => {
    this.config.recursionStack.delete(hash);
  }, 1000);
}
```

#### **1.3. Estrutura de Log (5Ws):**

```javascript
structureLog(level, category, message, data, context, callerInfo) {
  return {
    // WHEN - Quando ocorreu
    when: {
      timestamp: new Date().toISOString(),
      unix_timestamp: Date.now(),
      timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
    },
    
    // WHO - Quem chamou (programa, linha, função)
    who: {
      file_name: callerInfo.file_name,
      file_path: callerInfo.file_path,
      line_number: callerInfo.line_number,
      function_name: callerInfo.function_name,
      class_name: callerInfo.class_name,
      stack_trace: callerInfo.stack_trace
    },
    
    // WHAT - O que aconteceu (classificação, mensagem)
    what: {
      level: level.toUpperCase(),  // DEBUG, INFO, WARN, ERROR, FATAL
      category: category || 'GENERAL',
      message: message,
      description: this.generateDescription(level, category, message, data),
      context: context
    },
    
    // WHERE - Onde ocorreu (URL, sessão, ambiente)
    where: {
      url: window.location.href,
      session_id: window.sessionId || null,
      environment: window.APP_ENVIRONMENT || 'unknown',
      user_agent: navigator.userAgent,
      referrer: document.referrer || null
    },
    
    // WHY - Por que ocorreu (dados adicionais, contexto)
    why: {
      data: this.sanitizeData(data),
      metadata: {
        request_id: this.generateRequestId(),
        log_id: this.generateLogId()
      }
    }
  };
}
```

#### **1.4. Parametrização:**

```javascript
shouldLogToDatabase(level) {
  if (!this.config.enabled) return false;
  if (!this.config.database.enabled) return false;
  
  const levels = { 'DEBUG': 0, 'INFO': 1, 'WARN': 2, 'ERROR': 3, 'FATAL': 4 };
  const minLevel = levels[this.config.database.minLevel] || 1;
  const currentLevel = levels[level.toUpperCase()] || 1;
  
  return currentLevel >= minLevel;
}

shouldLogToConsole(level) {
  if (!this.config.enabled) return false;
  if (!this.config.console.enabled) return false;
  
  const levels = { 'DEBUG': 0, 'INFO': 1, 'WARN': 2, 'ERROR': 3, 'FATAL': 4 };
  const minLevel = levels[this.config.console.minLevel] || 0;
  const currentLevel = levels[level.toUpperCase()] || 1;
  
  return currentLevel >= minLevel;
}

logToDatabase(logEntry) {
  // Usar sendLogToProfessionalSystem() existente
  if (typeof window.sendLogToProfessionalSystem === 'function') {
    window.sendLogToProfessionalSystem(
      logEntry.what.level,
      logEntry.what.category,
      logEntry.what.message,
      logEntry.why.data
    ).catch(() => {
      // Falha silenciosa - não bloquear execução
    });
  }
}

logToConsole(logEntry) {
  const formattedMessage = `[${logEntry.what.category}] ${logEntry.what.message}`;
  const consoleData = {
    when: logEntry.when,
    who: logEntry.who,
    what: logEntry.what,
    where: logEntry.where,
    why: logEntry.why
  };
  
  switch(logEntry.what.level) {
    case 'FATAL':
    case 'ERROR':
      console.error(formattedMessage, consoleData);
      break;
    case 'WARN':
      console.warn(formattedMessage, consoleData);
      break;
    case 'INFO':
    case 'DEBUG':
    default:
      console.log(formattedMessage, consoleData);
      break;
  }
}
```

#### **1.5. Sanitização de Dados:**

```javascript
sanitizeData(data) {
  if (!data) return null;
  
  // Lista de campos sensíveis a mascarar
  const sensitiveFields = ['password', 'senha', 'token', 'api_key', 'secret', 'credential'];
  
  if (typeof data === 'object') {
    const sanitized = { ...data };
    
    for (const key in sanitized) {
      if (sensitiveFields.some(field => key.toLowerCase().includes(field))) {
        sanitized[key] = '***MASKED***';
      } else if (typeof sanitized[key] === 'object') {
        sanitized[key] = this.sanitizeData(sanitized[key]);
      }
    }
    
    return sanitized;
  }
  
  return data;
}
```

#### **1.6. Geração de Descrição Estruturada:**

```javascript
generateDescription(level, category, message, data) {
  // Gerar descrição detalhada baseada em boas práticas
  let description = message;
  
  if (data) {
    const dataKeys = Object.keys(data);
    if (dataKeys.length > 0) {
      description += ` | Contexto: ${dataKeys.join(', ')}`;
    }
  }
  
  // Adicionar informações específicas por nível
  switch(level.toUpperCase()) {
    case 'ERROR':
    case 'FATAL':
      description += ' | Ação requerida: Investigar e corrigir';
      break;
    case 'WARN':
      description += ' | Ação sugerida: Monitorar';
      break;
  }
  
  return description;
}
```

---

### **2. ProfessionalLogger.php (Aprimorado)**

#### **2.1. Prevenção de Recursão:**

```php
class ProfessionalLogger {
    private static $recursionStack = [];
    private static $maxRecursionDepth = 3;
    private static $isLogging = false;  // Flag de controle
    
    public function log($level, $message, $data = null, $category = null, $stackTrace = null, $callerInfo = null) {
        // Prevenção de recursão
        if (self::$isLogging) {
            // Se já está logando, usar error_log nativo (não usar ProfessionalLogger)
            error_log("ProfessionalLogger: Recursive call detected - " . $message);
            return false;
        }
        
        // Verificar profundidade de recursão
        $stackDepth = $this->getRecursionDepth();
        if ($stackDepth > self::$maxRecursionDepth) {
            error_log("ProfessionalLogger: Max recursion depth exceeded - " . $message);
            return false;
        }
        
        // Marcar como logando
        self::$isLogging = true;
        
        try {
            // ... lógica de logging ...
            
            return $logId;
        } catch (Exception $e) {
            // Em caso de erro, usar error_log nativo (não usar ProfessionalLogger)
            error_log("ProfessionalLogger: Exception - " . $e->getMessage());
            return false;
        } finally {
            // Desmarcar flag
            self::$isLogging = false;
        }
    }
    
    private function getRecursionDepth() {
        $trace = debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 20);
        $depth = 0;
        
        foreach ($trace as $frame) {
            if (isset($frame['class']) && $frame['class'] === 'ProfessionalLogger') {
                $depth++;
            }
        }
        
        return $depth;
    }
}
```

#### **2.2. Parametrização:**

```php
private function shouldLogToDatabase($level) {
    $enabled = $_ENV['LOG_ENABLED'] ?? true;
    $dbEnabled = $_ENV['LOG_DATABASE_ENABLED'] ?? true;
    $minLevel = $_ENV['LOG_DATABASE_MIN_LEVEL'] ?? 'INFO';
    
    if (!$enabled || !$dbEnabled) return false;
    
    $levels = ['DEBUG' => 0, 'INFO' => 1, 'WARN' => 2, 'ERROR' => 3, 'FATAL' => 4];
    $minLevelValue = $levels[$minLevel] ?? 1;
    $currentLevelValue = $levels[$level] ?? 1;
    
    return $currentLevelValue >= $minLevelValue;
}

private function shouldLogToConsole($level) {
    $enabled = $_ENV['LOG_ENABLED'] ?? true;
    $consoleEnabled = $_ENV['LOG_CONSOLE_ENABLED'] ?? true;
    $minLevel = $_ENV['LOG_CONSOLE_MIN_LEVEL'] ?? 'DEBUG';
    
    if (!$enabled || !$consoleEnabled) return false;
    
    $levels = ['DEBUG' => 0, 'INFO' => 1, 'WARN' => 2, 'ERROR' => 3, 'FATAL' => 4];
    $minLevelValue = $levels[$minLevel] ?? 0;
    $currentLevelValue = $levels[$level] ?? 1;
    
    return $currentLevelValue >= $minLevelValue;
}
```

#### **2.3. Estrutura de Log Padronizada (5Ws):**

```php
private function structureLog($level, $message, $data, $category, $stackTrace, $callerInfo) {
    return [
        // WHEN - Quando ocorreu
        'when' => [
            'timestamp' => date('Y-m-d H:i:s.u'),
            'unix_timestamp' => microtime(true),
            'timezone' => date_default_timezone_get()
        ],
        
        // WHO - Quem chamou (programa, linha, função)
        'who' => [
            'file_name' => $callerInfo['file_name'] ?? 'unknown',
            'file_path' => $callerInfo['file_path'] ?? null,
            'line_number' => $callerInfo['line_number'] ?? null,
            'function_name' => $callerInfo['function_name'] ?? null,
            'class_name' => $callerInfo['class_name'] ?? null,
            'stack_trace' => $stackTrace
        ],
        
        // WHAT - O que aconteceu (classificação, mensagem)
        'what' => [
            'level' => strtoupper($level),
            'category' => $category ?? 'GENERAL',
            'message' => $message,
            'description' => $this->generateDescription($level, $category, $message, $data)
        ],
        
        // WHERE - Onde ocorreu (URL, sessão, ambiente)
        'where' => [
            'url' => $_SERVER['REQUEST_URI'] ?? null,
            'session_id' => session_id() ?: null,
            'environment' => $this->environment,
            'ip_address' => $_SERVER['REMOTE_ADDR'] ?? null,
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? null
        ],
        
        // WHY - Por que ocorreu (dados adicionais, contexto)
        'why' => [
            'data' => $this->sanitizeData($data),
            'metadata' => [
                'request_id' => $this->requestId,
                'log_id' => $this->generateLogId()
            ]
        ]
    ];
}

private function generateDescription($level, $category, $message, $data) {
    $description = $message;
    
    if ($data && is_array($data)) {
        $dataKeys = array_keys($data);
        if (count($dataKeys) > 0) {
            $description .= ' | Contexto: ' . implode(', ', $dataKeys);
        }
    }
    
    // Adicionar informações específicas por nível
    switch(strtoupper($level)) {
        case 'ERROR':
        case 'FATAL':
            $description .= ' | Ação requerida: Investigar e corrigir';
            break;
        case 'WARN':
            $description .= ' | Ação sugerida: Monitorar';
            break;
    }
    
    return $description;
}

private function sanitizeData($data) {
    if (!$data) return null;
    
    $sensitiveFields = ['password', 'senha', 'token', 'api_key', 'secret', 'credential'];
    
    if (is_array($data)) {
        $sanitized = [];
        
        foreach ($data as $key => $value) {
            $keyLower = strtolower($key);
            $isSensitive = false;
            
            foreach ($sensitiveFields as $field) {
                if (strpos($keyLower, $field) !== false) {
                    $isSensitive = true;
                    break;
                }
            }
            
            if ($isSensitive) {
                $sanitized[$key] = '***MASKED***';
            } elseif (is_array($value)) {
                $sanitized[$key] = $this->sanitizeData($value);
            } else {
                $sanitized[$key] = $value;
            }
        }
        
        return $sanitized;
    }
    
    return $data;
}
```

#### **2.4. Log para Console (PHP):**

```php
private function logToConsole($logEntry) {
    if (!$this->shouldLogToConsole($logEntry['what']['level'])) {
        return;
    }
    
    $formattedMessage = sprintf(
        "[%s] [%s] %s",
        $logEntry['what']['level'],
        $logEntry['what']['category'],
        $logEntry['what']['message']
    );
    
    $consoleData = [
        'when' => $logEntry['when'],
        'who' => $logEntry['who'],
        'what' => $logEntry['what'],
        'where' => $logEntry['where'],
        'why' => $logEntry['why']
    ];
    
    switch($logEntry['what']['level']) {
        case 'FATAL':
        case 'ERROR':
            error_log($formattedMessage . ' | ' . json_encode($consoleData, JSON_UNESCAPED_UNICODE));
            break;
        case 'WARN':
            error_log($formattedMessage . ' | ' . json_encode($consoleData, JSON_UNESCAPED_UNICODE));
            break;
        case 'INFO':
        case 'DEBUG':
        default:
            error_log($formattedMessage . ' | ' . json_encode($consoleData, JSON_UNESCAPED_UNICODE));
            break;
    }
}
```

---

### **3. Boas Práticas Implementadas**

#### **3.1. Estruturação (5Ws):**
- ✅ **When:** Timestamp preciso com timezone
- ✅ **Who:** Programa, linha, função, classe
- ✅ **What:** Nível, categoria, mensagem, descrição
- ✅ **Where:** URL, sessão, ambiente, IP
- ✅ **Why:** Dados adicionais, contexto, metadata

#### **3.2. Prevenção de Recursão:**
- ✅ Flag de controle (`isLogging`)
- ✅ Stack de chamadas para detectar loops
- ✅ Limite máximo de profundidade
- ✅ Lista de funções excluídas
- ✅ Timeout para operações

#### **3.3. Parametrização:**
- ✅ Ligar/desligar sistema completo
- ✅ Ligar/desligar banco de dados
- ✅ Ligar/desligar console
- ✅ Níveis de severidade configuráveis
- ✅ Configuração via variáveis de ambiente

#### **3.4. Segurança:**
- ✅ Sanitização de dados sensíveis
- ✅ Validação de entrada
- ✅ Tratamento de erros robusto
- ✅ Fallback seguro (error_log nativo)

#### **3.5. Performance:**
- ✅ Operações assíncronas (JavaScript)
- ✅ Não bloqueia execução principal
- ✅ Rate limiting (já implementado)
- ✅ Timeout para operações

---

## ✅ CONFORMIDADE COM DIRETIVAS

| Diretiva | Status | Observação |
|----------|--------|------------|
| **Autorização prévia** | ⏳ | Aguardando autorização explícita |
| **Modificações locais** | ✅ | Arquivos modificados localmente primeiro |
| **Backups locais** | ✅ | Backup antes de modificar |
| **Não modificar no servidor** | ✅ | Criar localmente, depois copiar |
| **Variáveis de ambiente** | ✅ | Usa variáveis de ambiente do PHP-FPM |
| **Documentação** | ✅ | Documentação completa criada |
| **Organização de arquivos** | ✅ | Arquivos em `02-DEVELOPMENT/`, docs em `05-DOCUMENTATION/` |
| **Ambiente DEV apenas** | ✅ | Trabalhando apenas em DEV (isolamento de produção) |
| **Auditoria pós-implementação** | ✅ | Fase 12 inclui auditoria formal |

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Risco 1: Quebrar código existente durante migração**
- **Mitigação:** Criar backups completos, migrar gradualmente, testar após cada fase

### **Risco 2: Chamadas recursivas não detectadas**
- **Mitigação:** Múltiplos mecanismos de prevenção (flag, stack, profundidade, timeout)

### **Risco 3: Performance degradada**
- **Mitigação:** Operações assíncronas, não bloquear execução, rate limiting

### **Risco 4: Perda de logs durante migração**
- **Mitigação:** Manter sistemas antigos durante transição, aliases de compatibilidade

### **Risco 5: Configuração incorreta**
- **Mitigação:** Valores padrão seguros, validação de configuração, documentação clara

---

## 📊 ESTIMATIVA DE IMPACTO

### **Código:**
- **Arquivos novos:** 1 (`UnifiedLogger.js`)
- **Arquivos modificados:** 6 (JavaScript: 3, PHP: 2, Config: 1)
- **Linhas modificadas:** ~500-800 linhas
- **Linhas removidas:** ~200-300 linhas (sistemas antigos)

### **Funcionalidade:**
- ✅ Sistema unificado e padronizado
- ✅ Prevenção de recursão implementada
- ✅ Parametrização completa
- ✅ Estrutura de log padronizada (5Ws)
- ✅ Logs persistidos no banco de dados
- ✅ Logs exibidos no console (configurável)

### **Impacto em Outros Arquivos:**
- ✅ **Migração gradual:** Sistemas antigos mantidos durante transição
- ✅ **Aliases de compatibilidade:** Facilitar migração
- ✅ **Testes extensivos:** Garantir que nada quebrou

---

## 🎯 PRÓXIMOS PASSOS

1. ⏳ **Aguardar autorização explícita** para iniciar projeto
2. ⏳ Executar Fase 1 (Pesquisa e Design)
3. ⏳ Executar Fase 2-3 (Implementação)
4. ⏳ Executar Fase 4-8 (Migração)
5. ⏳ Executar Fase 9 (Configuração)
6. ⏳ Executar Fase 10 (Deploy)
7. ⏳ Executar Fase 11 (Testes)
8. ⏳ Executar Fase 12 (Documentação e Auditoria)

---

## 📋 RESUMO DO PROJETO

### **O que será feito:**
- Unificar todos os sistemas de logging em um sistema único
- Implementar captura automática: programa, linha, função, timestamp
- Implementar estrutura padronizada (5Ws)
- Implementar prevenção de recursão infinita
- Parametrizar banco de dados e console (ligar/desligar, níveis)
- Eliminar logs em arquivo texto (exceto fallback PHP)

### **Arquivos envolvidos:**
- 1 arquivo novo: `UnifiedLogger.js`
- 6 arquivos a modificar
- 1 arquivo de configuração a atualizar

### **Fases:**
- 12 fases sequenciais (pesquisa → implementação → migração → testes → documentação)

### **Ambiente:**
- ✅ **APENAS DESENVOLVIMENTO** (DEV isolado conforme diretiva)

---

## 📋 EXEMPLO DE USO

### **JavaScript:**

```javascript
// Inicializar UnifiedLogger
const logger = new UnifiedLogger();

// Configurar (opcional)
window.LOG_CONFIG = {
  enabled: true,
  database: {
    enabled: true,
    minLevel: 'INFO'
  },
  console: {
    enabled: true,
    minLevel: 'DEBUG'
  }
};

// Usar logger
logger.info('RPA', 'Iniciando processo RPA', { formFields: 15 }, 'OPERATION');
logger.error('VALIDACAO', 'CPF inválido', { cpf: '123.456.789-00' }, 'ERROR_HANDLING');
logger.debug('DATA_FLOW', 'Dados coletados', { campos: Object.keys(data).length }, 'DATA_FLOW');
```

### **PHP:**

```php
// Usar ProfessionalLogger
$logger = new ProfessionalLogger();

// Log INFO
$logger->info('Processo RPA iniciado', ['formFields' => 15], 'RPA');

// Log ERROR
$logger->error('CPF inválido', ['cpf' => '123.456.789-00'], 'VALIDACAO');

// Log DEBUG
$logger->debug('Dados coletados', ['campos' => count($data)], 'DATA_FLOW');
```

---

## 🔍 VALIDAÇÃO E TESTES

### **Testes de Prevenção de Recursão:**

1. ✅ Testar chamada recursiva direta
2. ✅ Testar loop infinito via múltiplas funções
3. ✅ Testar limite de profundidade
4. ✅ Testar timeout de operações

### **Testes de Parametrização:**

1. ✅ Testar ligar/desligar banco de dados
2. ✅ Testar ligar/desligar console
3. ✅ Testar níveis de severidade
4. ✅ Testar configuração via variáveis de ambiente

### **Testes de Funcionalidade:**

1. ✅ Testar captura automática de caller info
2. ✅ Testar estrutura de log (5Ws)
3. ✅ Testar sanitização de dados sensíveis
4. ✅ Testar persistência no banco de dados
5. ✅ Testar exibição no console

---

**Status:** 📋 **PLANO CRIADO - AGUARDANDO AUTORIZAÇÃO**  
**Documento criado em:** 16/11/2025  
**Versão:** 1.0.0

