# 🏗️ ARQUITETURA: Parametrização de Logging

**Data:** 16/11/2025  
**Status:** ✅ **ARQUITETURA DEFINIDA**  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Criar uma arquitetura de parametrização unificada que permita controlar o sistema de logging através de variáveis globais, configuráveis via:
1. ✅ Variáveis de ambiente (PHP)
2. ✅ Data attributes do script tag (JavaScript)
3. ✅ Parâmetros de execução (JavaScript)
4. ✅ Utilizável por todos os `.js` e `.php`

---

## 📊 ARQUITETURA PROPOSTA

### **1. Estrutura de Configuração**

#### **1.1. Variáveis de Configuração**

```javascript
// JavaScript - window.LOG_CONFIG
window.LOG_CONFIG = {
    // Controle principal
    enabled: true,                    // true/false - Habilita/desabilita todos os logs
    level: 'info',                   // 'none' | 'error' | 'warn' | 'info' | 'debug' | 'all'
    
    // Controles granulares
    database: {
        enabled: true,               // true/false - Habilita/desabilita logs no banco
        min_level: 'info'            // Nível mínimo para salvar no banco
    },
    console: {
        enabled: true,               // true/false - Habilita/desabilita console.log
        min_level: 'info'            // Nível mínimo para exibir no console
    },
    file: {
        enabled: true,               // true/false - Habilita/desabilita logs em arquivo
        min_level: 'error'           // Nível mínimo para salvar em arquivo
    },
    
    // Filtros
    exclude_categories: [],          // ['CATEGORY1', 'CATEGORY2'] - Categorias a ignorar
    exclude_contexts: [],            // ['CONTEXT1', 'CONTEXT2'] - Contextos a ignorar
    
    // Ambiente
    environment: 'auto'              // 'auto' | 'dev' | 'prod' - Auto-detecta se 'auto'
};
```

```php
// PHP - $_ENV['LOG_*']
$_ENV['LOG_ENABLED'] = 'true';              // 'true' | 'false'
$_ENV['LOG_LEVEL'] = 'info';                // 'none' | 'error' | 'warn' | 'info' | 'debug' | 'all'
$_ENV['LOG_DATABASE_ENABLED'] = 'true';     // 'true' | 'false'
$_ENV['LOG_DATABASE_MIN_LEVEL'] = 'info';   // Nível mínimo para banco
$_ENV['LOG_CONSOLE_ENABLED'] = 'true';      // 'true' | 'false' (error_log)
$_ENV['LOG_CONSOLE_MIN_LEVEL'] = 'info';    // Nível mínimo para error_log
$_ENV['LOG_FILE_ENABLED'] = 'true';         // 'true' | 'false'
$_ENV['LOG_FILE_MIN_LEVEL'] = 'error';      // Nível mínimo para arquivo
$_ENV['LOG_EXCLUDE_CATEGORIES'] = '';       // 'CATEGORY1,CATEGORY2' - Separado por vírgula
$_ENV['LOG_EXCLUDE_CONTEXTS'] = '';         // 'CONTEXT1,CONTEXT2' - Separado por vírgula
```

---

### **2. Fontes de Configuração (Ordem de Prioridade)**

#### **2.1. JavaScript - Ordem de Prioridade:**

1. ✅ **Data attributes do script tag** (maior prioridade)
2. ✅ **Variáveis globais definidas no código** (`window.LOG_CONFIG`)
3. ✅ **Valores padrão** (fallback)

#### **2.2. PHP - Ordem de Prioridade:**

1. ✅ **Variáveis de ambiente** (`$_ENV['LOG_*']`) (maior prioridade)
2. ✅ **Valores padrão** (fallback)

---

### **3. Implementação JavaScript**

#### **3.1. Leitura de Data Attributes**

```javascript
// FooterCodeSiteDefinitivoCompleto.js (início do arquivo)
(function() {
    'use strict';
    
    // ==================== CONFIGURAÇÃO DE LOGGING ====================
    // Ler configuração do data attribute do script tag
    const currentScript = document.currentScript;
    let logConfigFromAttribute = {};
    
    if (currentScript && currentScript.dataset) {
        // Ler configurações de logging do data attribute
        if (currentScript.dataset.logEnabled !== undefined) {
            logConfigFromAttribute.enabled = currentScript.dataset.logEnabled === 'true' || currentScript.dataset.logEnabled === '1';
        }
        if (currentScript.dataset.logLevel !== undefined) {
            logConfigFromAttribute.level = currentScript.dataset.logLevel;
        }
        if (currentScript.dataset.logDatabaseEnabled !== undefined) {
            logConfigFromAttribute.database = logConfigFromAttribute.database || {};
            logConfigFromAttribute.database.enabled = currentScript.dataset.logDatabaseEnabled === 'true' || currentScript.dataset.logDatabaseEnabled === '1';
        }
        if (currentScript.dataset.logDatabaseMinLevel !== undefined) {
            logConfigFromAttribute.database = logConfigFromAttribute.database || {};
            logConfigFromAttribute.database.min_level = currentScript.dataset.logDatabaseMinLevel;
        }
        if (currentScript.dataset.logConsoleEnabled !== undefined) {
            logConfigFromAttribute.console = logConfigFromAttribute.console || {};
            logConfigFromAttribute.console.enabled = currentScript.dataset.logConsoleEnabled === 'true' || currentScript.dataset.logConsoleEnabled === '1';
        }
        if (currentScript.dataset.logConsoleMinLevel !== undefined) {
            logConfigFromAttribute.console = logConfigFromAttribute.console || {};
            logConfigFromAttribute.console.min_level = currentScript.dataset.logConsoleMinLevel;
        }
        if (currentScript.dataset.logExcludeCategories !== undefined) {
            logConfigFromAttribute.exclude_categories = currentScript.dataset.logExcludeCategories.split(',').map(c => c.trim());
        }
        if (currentScript.dataset.logEnvironment !== undefined) {
            logConfigFromAttribute.environment = currentScript.dataset.logEnvironment;
        }
    }
    
    // ==================== CONFIGURAÇÃO PADRÃO ====================
    // Valores padrão (usados se não definidos via data attribute ou código)
    const defaultLogConfig = {
        enabled: true,
        level: 'info',
        database: {
            enabled: true,
            min_level: 'info'
        },
        console: {
            enabled: true,
            min_level: 'info'
        },
        file: {
            enabled: true,
            min_level: 'error'
        },
        exclude_categories: [],
        exclude_contexts: [],
        environment: 'auto'
    };
    
    // Auto-detectar ambiente se 'auto'
    let detectedEnvironment = 'prod';
    if (logConfigFromAttribute.environment === 'auto' || (!logConfigFromAttribute.environment && defaultLogConfig.environment === 'auto')) {
        const hostname = window.location.hostname;
        if (hostname.includes('webflow.io') || hostname.includes('localhost') || hostname.includes('dev.')) {
            detectedEnvironment = 'dev';
        }
    }
    
    // Em produção, usar nível mais restritivo se não especificado
    if (detectedEnvironment === 'prod' && !logConfigFromAttribute.level && !window.LOG_CONFIG?.level) {
        defaultLogConfig.level = 'error';
        defaultLogConfig.database.min_level = 'error';
        defaultLogConfig.console.min_level = 'error';
    }
    
    // ==================== MERGE DE CONFIGURAÇÕES ====================
    // Prioridade: window.LOG_CONFIG > data attributes > valores padrão
    window.LOG_CONFIG = {
        ...defaultLogConfig,
        ...logConfigFromAttribute,
        ...(window.LOG_CONFIG || {}),
        database: {
            ...defaultLogConfig.database,
            ...(logConfigFromAttribute.database || {}),
            ...(window.LOG_CONFIG?.database || {})
        },
        console: {
            ...defaultLogConfig.console,
            ...(logConfigFromAttribute.console || {}),
            ...(window.LOG_CONFIG?.console || {})
        },
        file: {
            ...defaultLogConfig.file,
            ...(logConfigFromAttribute.file || {}),
            ...(window.LOG_CONFIG?.file || {})
        },
        environment: detectedEnvironment
    };
    
    // Função helper para verificar se log deve ser executado
    window.shouldLog = function(level, category, context) {
        const config = window.LOG_CONFIG || {};
        
        // 1. Verificar se logging está habilitado
        if (config.enabled === false || config.enabled === 'false') {
            return false;
        }
        
        // 2. Verificar nível de severidade
        const levels = {
            'none': 0,
            'error': 1,
            'warn': 2,
            'info': 3,
            'debug': 4,
            'all': 5
        };
        const configLevel = levels[config.level?.toLowerCase()] || levels['info'];
        const messageLevel = levels[level?.toLowerCase()] || levels['info'];
        if (messageLevel > configLevel) {
            return false;
        }
        
        // 3. Verificar exclusão de categoria
        if (config.exclude_categories && config.exclude_categories.length > 0) {
            if (category && config.exclude_categories.includes(category)) {
                return false;
            }
        }
        
        // 4. Verificar exclusão de contexto
        if (config.exclude_contexts && config.exclude_contexts.length > 0) {
            if (context && config.exclude_contexts.includes(context)) {
                return false;
            }
        }
        
        return true;
    };
    
    // Função helper para verificar se deve salvar no banco
    window.shouldLogToDatabase = function(level) {
        const config = window.LOG_CONFIG || {};
        if (config.database?.enabled === false || config.database?.enabled === 'false') {
            return false;
        }
        const levels = { 'none': 0, 'error': 1, 'warn': 2, 'info': 3, 'debug': 4, 'all': 5 };
        const minLevel = levels[config.database?.min_level?.toLowerCase()] || levels['info'];
        const messageLevel = levels[level?.toLowerCase()] || levels['info'];
        return messageLevel <= minLevel;
    };
    
    // Função helper para verificar se deve exibir no console
    window.shouldLogToConsole = function(level) {
        const config = window.LOG_CONFIG || {};
        if (config.console?.enabled === false || config.console?.enabled === 'false') {
            return false;
        }
        const levels = { 'none': 0, 'error': 1, 'warn': 2, 'info': 3, 'debug': 4, 'all': 5 };
        const minLevel = levels[config.console?.min_level?.toLowerCase()] || levels['info'];
        const messageLevel = levels[level?.toLowerCase()] || levels['info'];
        return messageLevel <= minLevel;
    };
    
    console.log('[LOG_CONFIG] Configuração de logging carregada:', window.LOG_CONFIG);
    // ==================== FIM CONFIGURAÇÃO DE LOGGING ====================
})();
```

#### **3.2. Atualizar `novo_log()` para Usar Configuração**

```javascript
window.novo_log = function(level, category, message, data) {
    // 1. Verificar se deve logar
    if (!window.shouldLog(level, category)) {
        return; // Silenciosamente ignorar
    }
    
    // 2. console.log (se habilitado e nível permitido)
    if (window.shouldLogToConsole(level)) {
        const formattedMessage = category ? `[${category}] ${message}` : message;
        switch(level.toUpperCase()) {
            case 'ERROR':
            case 'FATAL':
                console.error(formattedMessage, data || '');
                break;
            case 'WARN':
                console.warn(formattedMessage, data || '');
                break;
            default:
                console.log(formattedMessage, data || '');
        }
    }
    
    // 3. Enviar para sistema profissional (se habilitado e nível permitido)
    if (window.shouldLogToDatabase(level)) {
        if (typeof window.sendLogToProfessionalSystem === 'function') {
            window.sendLogToProfessionalSystem(level, category, message, data).catch(() => {
                // Falha silenciosa - não bloquear execução
            });
        }
    }
};
```

---

### **4. Implementação PHP**

#### **4.1. Classe de Configuração**

```php
// ProfessionalLogger.php
class LogConfig {
    private static $config = null;
    
    /**
     * Carregar configuração (uma vez só)
     */
    public static function load() {
        if (self::$config !== null) {
            return self::$config;
        }
        
        // Valores padrão
        $defaultConfig = [
            'enabled' => true,
            'level' => 'info',
            'database' => [
                'enabled' => true,
                'min_level' => 'info'
            ],
            'console' => [
                'enabled' => true,
                'min_level' => 'info'
            ],
            'file' => [
                'enabled' => true,
                'min_level' => 'error'
            ],
            'exclude_categories' => [],
            'exclude_contexts' => []
        ];
        
        // Ler de variáveis de ambiente
        $envConfig = [
            'enabled' => self::parseBool($_ENV['LOG_ENABLED'] ?? 'true'),
            'level' => strtolower($_ENV['LOG_LEVEL'] ?? 'info'),
            'database' => [
                'enabled' => self::parseBool($_ENV['LOG_DATABASE_ENABLED'] ?? 'true'),
                'min_level' => strtolower($_ENV['LOG_DATABASE_MIN_LEVEL'] ?? 'info')
            ],
            'console' => [
                'enabled' => self::parseBool($_ENV['LOG_CONSOLE_ENABLED'] ?? 'true'),
                'min_level' => strtolower($_ENV['LOG_CONSOLE_MIN_LEVEL'] ?? 'info')
            ],
            'file' => [
                'enabled' => self::parseBool($_ENV['LOG_FILE_ENABLED'] ?? 'true'),
                'min_level' => strtolower($_ENV['LOG_FILE_MIN_LEVEL'] ?? 'error')
            ],
            'exclude_categories' => self::parseArray($_ENV['LOG_EXCLUDE_CATEGORIES'] ?? ''),
            'exclude_contexts' => self::parseArray($_ENV['LOG_EXCLUDE_CONTEXTS'] ?? '')
        ];
        
        // Merge: ambiente > padrão
        self::$config = array_merge_recursive($defaultConfig, $envConfig);
        
        // Em produção, usar nível mais restritivo se não especificado
        $environment = strtolower($_ENV['PHP_ENV'] ?? 'development');
        if ($environment === 'production' || $environment === 'prod') {
            if (!isset($_ENV['LOG_LEVEL'])) {
                self::$config['level'] = 'error';
                self::$config['database']['min_level'] = 'error';
                self::$config['console']['min_level'] = 'error';
            }
        }
        
        return self::$config;
    }
    
    /**
     * Verificar se deve logar
     */
    public static function shouldLog($level, $category = null, $context = null) {
        $config = self::load();
        
        // 1. Verificar se logging está habilitado
        if (!$config['enabled']) {
            return false;
        }
        
        // 2. Verificar nível de severidade
        $levels = ['none' => 0, 'error' => 1, 'warn' => 2, 'info' => 3, 'debug' => 4, 'all' => 5];
        $configLevel = $levels[$config['level']] ?? $levels['info'];
        $messageLevel = $levels[strtolower($level)] ?? $levels['info'];
        if ($messageLevel > $configLevel) {
            return false;
        }
        
        // 3. Verificar exclusão de categoria
        if (!empty($config['exclude_categories']) && $category) {
            if (in_array(strtoupper($category), array_map('strtoupper', $config['exclude_categories']))) {
                return false;
            }
        }
        
        // 4. Verificar exclusão de contexto
        if (!empty($config['exclude_contexts']) && $context) {
            if (in_array(strtoupper($context), array_map('strtoupper', $config['exclude_contexts']))) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Verificar se deve salvar no banco
     */
    public static function shouldLogToDatabase($level) {
        $config = self::load();
        if (!$config['database']['enabled']) {
            return false;
        }
        $levels = ['none' => 0, 'error' => 1, 'warn' => 2, 'info' => 3, 'debug' => 4, 'all' => 5];
        $minLevel = $levels[$config['database']['min_level']] ?? $levels['info'];
        $messageLevel = $levels[strtolower($level)] ?? $levels['info'];
        return $messageLevel <= $minLevel;
    }
    
    /**
     * Verificar se deve usar error_log
     */
    public static function shouldLogToConsole($level) {
        $config = self::load();
        if (!$config['console']['enabled']) {
            return false;
        }
        $levels = ['none' => 0, 'error' => 1, 'warn' => 2, 'info' => 3, 'debug' => 4, 'all' => 5];
        $minLevel = $levels[$config['console']['min_level']] ?? $levels['info'];
        $messageLevel = $levels[strtolower($level)] ?? 'info'] ?? $levels['info'];
        return $messageLevel <= $minLevel;
    }
    
    /**
     * Verificar se deve salvar em arquivo
     */
    public static function shouldLogToFile($level) {
        $config = self::load();
        if (!$config['file']['enabled']) {
            return false;
        }
        $levels = ['none' => 0, 'error' => 1, 'warn' => 2, 'info' => 3, 'debug' => 4, 'all' => 5];
        $minLevel = $levels[$config['file']['min_level']] ?? $levels['error'];
        $messageLevel = $levels[strtolower($level)] ?? $levels['info'];
        return $messageLevel <= $minLevel;
    }
    
    /**
     * Parsear boolean de string
     */
    private static function parseBool($value) {
        if (is_bool($value)) {
            return $value;
        }
        $value = strtolower(trim($value));
        return in_array($value, ['true', '1', 'yes', 'on']);
    }
    
    /**
     * Parsear array de string separada por vírgula
     */
    private static function parseArray($value) {
        if (empty($value)) {
            return [];
        }
        return array_map('trim', explode(',', $value));
    }
}
```

#### **4.2. Atualizar `insertLog()` para Usar Configuração**

```php
public function insertLog($level, $message, $data = null, $category = null) {
    // 1. Verificar se deve logar
    if (!LogConfig::shouldLog($level, $category)) {
        return false; // Silenciosamente ignorar
    }
    
    // 2. Preparar dados do log
    $logData = $this->prepareLogData($level, $message, $data, $category);
    
    // 3. error_log() (se habilitado e nível permitido)
    if (LogConfig::shouldLogToConsole($level)) {
        error_log(sprintf(
            "[%s] [%s] [%s] %s | File: %s:%s | Function: %s",
            $logData['timestamp'],
            $logData['level'],
            $logData['category'] ?? 'N/A',
            $logData['message'],
            $logData['file_name'],
            $logData['line_number'],
            $logData['function_name'] ?? 'N/A'
        ));
    }
    
    // 4. Tentar inserir no banco (se habilitado e nível permitido)
    if (LogConfig::shouldLogToDatabase($level)) {
        try {
            $pdo = $this->connect();
            if ($pdo) {
                $stmt = $pdo->prepare("INSERT INTO application_logs (...) VALUES (...)");
                $stmt->execute([...]);
                return $logData['log_id'];
            }
        } catch (Exception $e) {
            // Fallback para arquivo se banco falhar
            if (LogConfig::shouldLogToFile($level)) {
                $this->logToFileFallback($logData, $e);
            }
        }
    }
    
    // 5. Fallback: Log em arquivo (se habilitado e nível permitido)
    if (LogConfig::shouldLogToFile($level)) {
        if (!$pdo) {
            $this->logToFileFallback($logData, new Exception('Conexão PDO falhou'));
        }
    }
    
    return false;
}
```

---

### **5. Exemplos de Uso**

#### **5.1. HTML - Data Attributes**

```html
<!-- Produção: Apenas erros -->
<script 
    src="https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    defer
    data-app-base-url="https://prod.bssegurosimediato.com.br/"
    data-app-environment="production"
    data-log-enabled="true"
    data-log-level="error"
    data-log-database-enabled="true"
    data-log-database-min-level="error"
    data-log-console-enabled="true"
    data-log-console-min-level="error"
    data-log-exclude-categories="DEBUG,RPA"
></script>

<!-- Desenvolvimento: Todos os logs -->
<script 
    src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    defer
    data-app-base-url="https://dev.bssegurosimediato.com.br/"
    data-app-environment="development"
    data-log-enabled="true"
    data-log-level="all"
    data-log-database-enabled="true"
    data-log-database-min-level="debug"
    data-log-console-enabled="true"
    data-log-console-min-level="debug"
></script>

<!-- Desabilitar completamente -->
<script 
    src="https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    defer
    data-log-enabled="false"
></script>
```

#### **5.2. PHP-FPM - Variáveis de Ambiente**

```ini
; php-fpm_www_conf_PROD.conf
env[LOG_ENABLED] = true
env[LOG_LEVEL] = error
env[LOG_DATABASE_ENABLED] = true
env[LOG_DATABASE_MIN_LEVEL] = error
env[LOG_CONSOLE_ENABLED] = true
env[LOG_CONSOLE_MIN_LEVEL] = error
env[LOG_FILE_ENABLED] = true
env[LOG_FILE_MIN_LEVEL] = error
env[LOG_EXCLUDE_CATEGORIES] = DEBUG,RPA
```

```ini
; php-fpm_www_conf_DEV.conf
env[LOG_ENABLED] = true
env[LOG_LEVEL] = all
env[LOG_DATABASE_ENABLED] = true
env[LOG_DATABASE_MIN_LEVEL] = debug
env[LOG_CONSOLE_ENABLED] = true
env[LOG_CONSOLE_MIN_LEVEL] = debug
env[LOG_FILE_ENABLED] = true
env[LOG_FILE_MIN_LEVEL] = error
```

#### **5.3. JavaScript - Override Programático**

```javascript
// Override via código (maior prioridade)
window.LOG_CONFIG = {
    enabled: true,
    level: 'debug',
    database: {
        enabled: true,
        min_level: 'debug'
    },
    console: {
        enabled: true,
        min_level: 'debug'
    },
    exclude_categories: ['GTM', 'MODAL']
};
```

---

## 📋 RESUMO DA ARQUITETURA

### **Fontes de Configuração:**

| Fonte | JavaScript | PHP | Prioridade |
|-------|------------|-----|------------|
| **Data Attributes** | ✅ | ❌ | Alta |
| **Variáveis Globais** | ✅ (`window.LOG_CONFIG`) | ❌ | Média |
| **Variáveis de Ambiente** | ❌ | ✅ (`$_ENV['LOG_*']`) | Alta |
| **Valores Padrão** | ✅ | ✅ | Baixa |

### **Controles Disponíveis:**

| Controle | Descrição | Valores |
|----------|-----------|---------|
| **enabled** | Habilita/desabilita todos os logs | `true` / `false` |
| **level** | Nível mínimo de log | `none` / `error` / `warn` / `info` / `debug` / `all` |
| **database.enabled** | Habilita/desabilita logs no banco | `true` / `false` |
| **database.min_level** | Nível mínimo para banco | `none` / `error` / `warn` / `info` / `debug` / `all` |
| **console.enabled** | Habilita/desabilita console.log | `true` / `false` |
| **console.min_level** | Nível mínimo para console | `none` / `error` / `warn` / `info` / `debug` / `all` |
| **file.enabled** | Habilita/desabilita logs em arquivo | `true` / `false` |
| **file.min_level** | Nível mínimo para arquivo | `none` / `error` / `warn` / `info` / `debug` / `all` |
| **exclude_categories** | Categorias a ignorar | Array de strings |
| **exclude_contexts** | Contextos a ignorar | Array de strings |

---

## ✅ VANTAGENS

1. ✅ **Unificado:** Mesma estrutura em JavaScript e PHP
2. ✅ **Flexível:** Múltiplas fontes de configuração
3. ✅ **Granular:** Controle por destino (banco, console, arquivo)
4. ✅ **Simples:** Fácil de usar e entender
5. ✅ **Performático:** Verificações rápidas antes de logar
6. ✅ **Ambiente-aware:** Auto-ajusta para dev/prod

---

**Status:** ✅ **ARQUITETURA DEFINIDA**  
**Última atualização:** 16/11/2025

