# 📖 EXPLICAÇÃO: Sistema de Classificação de Logs

**Data:** 11/11/2025  
**Objetivo:** Explicar como funcionará a classificação de logs e onde será configurada

---

## 🎯 COMO FUNCIONA A CLASSIFICAÇÃO

### 1. Função `logClassified()` - Onde os Logs são Classificados

**Localização:** Será adicionada em `FooterCodeSiteDefinitivoCompleto.js` (antes de ser usada)

**Função:**
```javascript
function logClassified(level, category, message, data, context = 'OPERATION', verbosity = 'SIMPLE') {
  // Esta função recebe 6 parâmetros:
  // 1. level: 'CRITICAL' | 'ERROR' | 'WARN' | 'INFO' | 'DEBUG' | 'TRACE'
  // 2. category: string (ex: 'EMAIL_DEBUG', 'JSON_DEBUG', 'CONFIG', etc.)
  // 3. message: string (mensagem do log)
  // 4. data: object (dados opcionais)
  // 5. context: 'INIT' | 'OPERATION' | 'ERROR_HANDLING' | 'PERFORMANCE' | 'DATA_FLOW' | 'UI'
  // 6. verbosity: 'SIMPLE' | 'MEDIUM' | 'VERBOSE'
  
  // A função verifica DEBUG_CONFIG e decide se deve exibir o log ou não
}
```

**Exemplo de Uso:**
```javascript
// ANTES (não respeita DEBUG_CONFIG):
console.log('🔍 [DEBUG] Email generation:', { ddd, celular, email });

// DEPOIS (respeita DEBUG_CONFIG):
logClassified('TRACE', 'EMAIL_DEBUG', 'Email generation', { ddd, celular, email }, 'DATA_FLOW', 'MEDIUM');
```

---

## ⚙️ ONDE SERÁ CONFIGURADA

### 2. `DEBUG_CONFIG` - Onde o Usuário Configura

**Localização:** Já existe em `FooterCodeSiteDefinitivoCompleto.js` (linha ~184)

**Configuração Atual:**
```javascript
window.DEBUG_CONFIG = window.DEBUG_CONFIG || {
  level: 'info',           // Nível de severidade
  enabled: true,           // Habilitar/desabilitar logs
  exclude: [],             // Categorias a excluir
  environment: 'auto'      // Ambiente (dev/prod)
};
```

**Configuração Expandida (após implementação):**
```javascript
window.DEBUG_CONFIG = window.DEBUG_CONFIG || {
  // ======================
  // PARÂMETRO 1: level (OBRIGATÓRIO)
  // ======================
  level: 'info',  // 'none' | 'critical' | 'error' | 'warn' | 'info' | 'debug' | 'trace' | 'all'
  
  // ======================
  // PARÂMETRO 2: enabled (OBRIGATÓRIO)
  // ======================
  enabled: true,  // true | false - Se false, bloqueia TODOS os logs (exceto CRITICAL)
  
  // ======================
  // PARÂMETRO 3: exclude (OPCIONAL)
  // ======================
  exclude: [],  // Array de categorias a excluir
  // Exemplo: ['EMAIL_DEBUG', 'JSON_DEBUG', 'UI_TRACE']
  
  // ======================
  // PARÂMETRO 4: excludeContexts (NOVO - OPCIONAL)
  // ======================
  excludeContexts: [],  // Array de contextos a excluir
  // Exemplo: ['UI', 'PERFORMANCE']
  
  // ======================
  // PARÂMETRO 5: maxVerbosity (NOVO - OPCIONAL)
  // ======================
  maxVerbosity: 'VERBOSE',  // 'SIMPLE' | 'MEDIUM' | 'VERBOSE'
  
  // ======================
  // PARÂMETRO 6: environment (OPCIONAL)
  // ======================
  environment: 'auto'  // 'auto' | 'dev' | 'prod'
};
```

---

## 📊 QUANTOS PARÂMETROS?

### Resposta: 6 parâmetros no total

**Parâmetros Obrigatórios (2):**
1. `level` - Nível de severidade (já existe)
2. `enabled` - Habilitar/desabilitar (já existe)

**Parâmetros Opcionais (4):**
3. `exclude` - Categorias a excluir (já existe)
4. `excludeContexts` - Contextos a excluir (NOVO)
5. `maxVerbosity` - Verbosidade máxima (NOVO)
6. `environment` - Ambiente (já existe)

---

## 🎯 COMO FUNCIONA A DECISÃO

### Fluxo de Decisão da Função `logClassified()`:

```javascript
function logClassified(level, category, message, data, context = 'OPERATION', verbosity = 'SIMPLE') {
  
  // ======================
  // ETAPA 1: Verificar enabled
  // ======================
  if (window.DEBUG_CONFIG && 
      (window.DEBUG_CONFIG.enabled === false || window.DEBUG_CONFIG.enabled === 'false')) {
    // CRITICAL sempre exibe, mesmo se disabled
    if (level !== 'CRITICAL') return;  // ❌ BLOQUEADO
  }
  
  // ======================
  // ETAPA 2: Verificar nível de severidade
  // ======================
  const levels = { 
    'none': 0, 
    'critical': 1,  // Sempre exibir
    'error': 2, 
    'warn': 3, 
    'info': 4, 
    'debug': 5, 
    'trace': 6, 
    'all': 7 
  };
  const currentLevel = levels[window.DEBUG_CONFIG?.level] || levels['info'];
  const messageLevel = levels[level.toLowerCase()] || levels['info'];
  if (messageLevel > currentLevel) return;  // ❌ BLOQUEADO (nível muito baixo)
  
  // ======================
  // ETAPA 3: Verificar exclusão de categoria
  // ======================
  if (window.DEBUG_CONFIG?.exclude && window.DEBUG_CONFIG.exclude.length > 0) {
    if (category && window.DEBUG_CONFIG.exclude.includes(category)) return;  // ❌ BLOQUEADO
  }
  
  // ======================
  // ETAPA 4: Verificar exclusão de contexto
  // ======================
  if (window.DEBUG_CONFIG?.excludeContexts && window.DEBUG_CONFIG.excludeContexts.length > 0) {
    if (context && window.DEBUG_CONFIG.excludeContexts.includes(context)) return;  // ❌ BLOQUEADO
  }
  
  // ======================
  // ETAPA 5: Verificar verbosidade máxima
  // ======================
  const verbosityLevels = { 'SIMPLE': 1, 'MEDIUM': 2, 'VERBOSE': 3 };
  const maxVerbosity = verbosityLevels[window.DEBUG_CONFIG?.maxVerbosity] || verbosityLevels['VERBOSE'];
  const messageVerbosity = verbosityLevels[verbosity] || verbosityLevels['SIMPLE'];
  if (messageVerbosity > maxVerbosity) return;  // ❌ BLOQUEADO (muito verboso)
  
  // ======================
  // ETAPA 6: Se passou todas as verificações, EXIBIR
  // ======================
  const formattedMessage = category ? `[${category}] ${message}` : message;
  switch(level) {
    case 'CRITICAL':
    case 'ERROR':
      console.error(formattedMessage, data || '');
      break;
    case 'WARN':
      console.warn(formattedMessage, data || '');
      break;
    case 'INFO':
    case 'DEBUG':
    case 'TRACE':
    default:
      console.log(formattedMessage, data || '');
      break;
  }
}
```

---

## 📋 EXEMPLOS PRÁTICOS DE CONFIGURAÇÃO

### Exemplo 1: Produção (Apenas Erros)
```javascript
window.DEBUG_CONFIG = {
  level: 'error',      // Apenas CRITICAL + ERROR
  enabled: true,
  exclude: [],
  excludeContexts: [],
  maxVerbosity: 'SIMPLE',
  environment: 'prod'
};
```
**Resultado:** ~37 logs exibidos (2 CRITICAL + ~35 ERROR)

### Exemplo 2: Desenvolvimento (Todos os Logs)
```javascript
window.DEBUG_CONFIG = {
  level: 'trace',      // Todos os logs
  enabled: true,
  exclude: [],
  excludeContexts: [],
  maxVerbosity: 'VERBOSE',
  environment: 'dev'
};
```
**Resultado:** ~192 logs exibidos (todos)

### Exemplo 3: Desenvolvimento (Sem Debug de Email/JSON)
```javascript
window.DEBUG_CONFIG = {
  level: 'debug',      // Até DEBUG
  enabled: true,
  exclude: ['EMAIL_DEBUG', 'JSON_DEBUG'],  // Excluir categorias específicas
  excludeContexts: [],
  maxVerbosity: 'VERBOSE',
  environment: 'dev'
};
```
**Resultado:** ~180 logs exibidos (exclui ~12 logs de EMAIL_DEBUG e JSON_DEBUG)

### Exemplo 4: Produção (Sem Logs de UI e Performance)
```javascript
window.DEBUG_CONFIG = {
  level: 'warn',       // Até WARN
  enabled: true,
  exclude: [],
  excludeContexts: ['UI', 'PERFORMANCE'],  // Excluir contextos específicos
  maxVerbosity: 'SIMPLE',
  environment: 'prod'
};
```
**Resultado:** ~50 logs exibidos (exclui logs de UI e PERFORMANCE)

### Exemplo 5: Desabilitar Todos os Logs
```javascript
window.DEBUG_CONFIG = {
  level: 'error',
  enabled: false,      // Bloqueia TODOS os logs
  exclude: [],
  excludeContexts: [],
  maxVerbosity: 'VERBOSE',
  environment: 'prod'
};
```
**Resultado:** 2 logs exibidos (apenas CRITICAL, que sempre exibe)

### Exemplo 6: Apenas Logs Simples
```javascript
window.DEBUG_CONFIG = {
  level: 'info',
  enabled: true,
  exclude: [],
  excludeContexts: [],
  maxVerbosity: 'SIMPLE',  // Apenas logs simples
  environment: 'dev'
};
```
**Resultado:** ~60 logs exibidos (apenas logs com verbosidade SIMPLE)

---

## 🎯 RESUMO

### Onde a Classificação Acontece:
1. **No código:** Cada `console.*` será substituído por `logClassified()` com classificação apropriada
2. **Na função:** `logClassified()` verifica `DEBUG_CONFIG` e decide se exibe ou não

### Onde a Configuração Acontece:
1. **Webflow Footer Code:** `window.DEBUG_CONFIG = { ... }` (já existe)
2. **6 parâmetros no total:**
   - 2 obrigatórios: `level`, `enabled`
   - 4 opcionais: `exclude`, `excludeContexts`, `maxVerbosity`, `environment`

### Quantos Parâmetros o Usuário Precisa Configurar?
**Resposta:** Apenas 1 parâmetro é obrigatório (`level`), mas pode usar até 6 para controle fino.

**Configuração Mínima:**
```javascript
window.DEBUG_CONFIG = { level: 'error' };  // Apenas 1 parâmetro
```

**Configuração Completa:**
```javascript
window.DEBUG_CONFIG = {
  level: 'info',
  enabled: true,
  exclude: ['EMAIL_DEBUG'],
  excludeContexts: ['UI'],
  maxVerbosity: 'MEDIUM',
  environment: 'dev'
};  // 6 parâmetros para controle total
```

---

**Status:** ✅ **EXPLICAÇÃO COMPLETA**

