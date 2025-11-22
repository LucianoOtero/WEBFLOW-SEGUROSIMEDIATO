# 📋 PROJETO: Criar Função `novo_log_console_e_banco()`

**Data de Criação:** 17/11/2025  
**Status:** 📝 **AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Criar uma nova função `novo_log_console_e_banco()` que:
1. ✅ Chama o console de acordo com a categoria/nível de chamada (`console.log/error/warn/debug`)
2. ✅ Insere um log no banco de dados via `fetch()` direto (sem passar por `novo_log()` ou `sendLogToProfessionalSystem()`)
3. ✅ Pode ser usada dentro de `sendLogToProfessionalSystem()` e `novo_log()` sem causar loops infinitos
4. ✅ Garante que TODAS as chamadas de console sejam acompanhadas de inserção no banco

---

## 📊 ANÁLISE DO PROBLEMA ATUAL

### **Problema Identificado:**

- ❌ Chamadas de `console.log()` dentro de `sendLogToProfessionalSystem()` não enviam para banco (19 chamadas)
- ❌ Chamada de `console.error()` dentro de `novo_log()` (linha 835) não envia para banco
- ⚠️ Essas chamadas não podem usar `novo_log()` porque causariam loop infinito

### **Solução Proposta:**

Criar função `novo_log_console_e_banco()` que:
- ✅ Chama `console.log/error/warn/debug` diretamente
- ✅ Envia para banco via `fetch()` direto (sem passar por `novo_log()` ou `sendLogToProfessionalSystem()`)
- ✅ Não causa loops infinitos (não chama `novo_log()` nem `sendLogToProfessionalSystem()`)
- ✅ Pode ser usada dentro de qualquer função, incluindo `sendLogToProfessionalSystem()` e `novo_log()`

---

## 🎯 ESPECIFICAÇÃO DA FUNÇÃO

### **Assinatura:**

```javascript
function novo_log_console_e_banco(level, category, message, data, options = {})
```

### **Parâmetros:**

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|-----------|
| `level` | String | ✅ Sim | Nível do log: 'DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'CRITICAL' |
| `category` | String | ❌ Não | Categoria do log (ex: 'LOG_INTERNAL', 'LOG_SYSTEM', 'RPA') |
| `message` | String | ✅ Sim | Mensagem do log |
| `data` | Object | ❌ Não | Dados adicionais do log |
| `options` | Object | ❌ Não | Opções adicionais: `{ skipConsole: false, skipDatabase: false, requestId: null }` |

### **Funcionalidades:**

1. ✅ **Chamar console de acordo com nível:**
   - `CRITICAL`, `ERROR`, `FATAL` → `console.error()`
   - `WARN`, `WARNING` → `console.warn()`
   - `DEBUG` → `console.debug()` (se disponível) ou `console.log()`
   - `INFO`, `TRACE` → `console.log()`

2. ✅ **Inserir no banco via `fetch()` direto:**
   - Não passa por `novo_log()` nem `sendLogToProfessionalSystem()`
   - Usa `fetch()` diretamente para `log_endpoint.php`
   - Não causa loops infinitos

3. ✅ **Tratamento de erros silencioso:**
   - Não quebra aplicação se logging falhar
   - Erros são ignorados silenciosamente

4. ✅ **Parametrização opcional:**
   - Respeita `window.shouldLog()` e `window.shouldLogToDatabase()` se disponíveis
   - Pode ser desabilitado via `options.skipConsole` ou `options.skipDatabase`

---

## 📋 IMPLEMENTAÇÃO PROPOSTA

### **Código da Função:**

```javascript
/**
 * Função para logar no console E no banco de dados simultaneamente
 * Pode ser usada dentro de novo_log() e sendLogToProfessionalSystem() sem causar loops infinitos
 * 
 * @param {string} level - Nível do log: 'DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'CRITICAL'
 * @param {string} category - Categoria do log (opcional)
 * @param {string} message - Mensagem do log
 * @param {object} data - Dados adicionais do log (opcional)
 * @param {object} options - Opções adicionais: { skipConsole: false, skipDatabase: false, requestId: null }
 * @returns {boolean} - true se log foi processado, false caso contrário
 */
function novo_log_console_e_banco(level, category, message, data, options = {}) {
  try {
    // Validar parâmetros obrigatórios
    if (!level || !message) {
      return false;
    }
    
    // Normalizar nível
    const validLevel = String(level).toUpperCase().trim();
    const validLevels = ['DEBUG', 'INFO', 'WARN', 'WARNING', 'ERROR', 'FATAL', 'CRITICAL', 'TRACE'];
    if (!validLevels.includes(validLevel)) {
      return false;
    }
    
    // Validar mensagem
    const validMessage = String(message);
    if (!validMessage || validMessage.trim() === '') {
      return false;
    }
    
    // Opções padrão
    const opts = {
      skipConsole: options.skipConsole || false,
      skipDatabase: options.skipDatabase || false,
      requestId: options.requestId || null,
      ...options
    };
    
    // Verificar parametrização (se disponível)
    if (typeof window.shouldLog === 'function') {
      if (!window.shouldLog(validLevel, category)) {
        return false; // Não deve logar
      }
    }
    
    // 1. Chamar console de acordo com nível
    if (!opts.skipConsole) {
      const formattedMessage = category ? `[${category}] ${validMessage}` : validMessage;
      
      switch(validLevel) {
        case 'CRITICAL':
        case 'ERROR':
        case 'FATAL':
          console.error(formattedMessage, data || '');
          break;
        case 'WARN':
        case 'WARNING':
          console.warn(formattedMessage, data || '');
          break;
        case 'DEBUG':
          if (console.debug) {
            console.debug(formattedMessage, data || '');
          } else {
            console.log(formattedMessage, data || '');
          }
          break;
        case 'INFO':
        case 'TRACE':
        default:
          console.log(formattedMessage, data || '');
          break;
      }
    }
    
    // 2. Inserir no banco via fetch() direto (sem passar por novo_log() ou sendLogToProfessionalSystem())
    if (!opts.skipDatabase && window.APP_BASE_URL) {
      // Verificar parametrização de banco (se disponível)
      let shouldLogToDatabase = true;
      if (typeof window.shouldLogToDatabase === 'function') {
        shouldLogToDatabase = window.shouldLogToDatabase(validLevel);
      }
      
      if (shouldLogToDatabase) {
        // Preparar payload
        const logData = {
          level: validLevel,
          category: category || 'LOG_INTERNAL',
          message: validMessage,
          data: data || null,
          session_id: window.sessionId || null,
          url: window.location.href,
          request_id: opts.requestId || null
        };
        
        // Enviar para banco via fetch() direto (assíncrono, não bloqueia)
        const endpoint = window.APP_BASE_URL + '/log_endpoint.php';
        fetch(endpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(logData),
          mode: 'cors',
          credentials: 'omit'
        }).then(response => {
          // Verificar resposta mas não fazer nada (silencioso)
          if (!response.ok) {
            // Erro silencioso - não quebrar aplicação
          }
        }).catch(error => {
          // Erro silencioso - não quebrar aplicação
        });
      }
    }
    
    return true;
  } catch (error) {
    // Tratamento de erro silencioso - não quebrar aplicação se logging falhar
    // Usar console.error direto para prevenir loop infinito
    console.error('[LOG] Erro em novo_log_console_e_banco():', error);
    return false;
  }
}

// Expor função globalmente
window.novo_log_console_e_banco = novo_log_console_e_banco;
```

---

## 📋 FASES DO PROJETO

### **FASE 0: Preparação e Backup**

**Objetivo:** Criar backups de todos os arquivos que serão modificados

**Ações:**
1. ✅ Criar backup de `FooterCodeSiteDefinitivoCompleto.js`
2. ✅ Calcular hash SHA256 do arquivo original
3. ✅ Documentar hash em arquivo de controle

**Diretório de Backup:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/`

**Tempo Estimado:** ~5 minutos

---

### **FASE 1: Implementar Função `novo_log_console_e_banco()`**

**Objetivo:** Adicionar a nova função em `FooterCodeSiteDefinitivoCompleto.js`

**Ações:**
1. ✅ Localizar posição apropriada para inserir função (após `sendLogToProfessionalSystem()`, antes de `novo_log()`)
2. ✅ Implementar função `novo_log_console_e_banco()` conforme especificação
3. ✅ Expor função globalmente via `window.novo_log_console_e_banco`
4. ✅ Verificar sintaxe do arquivo
5. ✅ Calcular hash SHA256 do arquivo modificado
6. ✅ Documentar alteração

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Localização:** Após `sendLogToProfessionalSystem()` (após linha 741), antes de `novo_log()` (antes de linha 764)

**Tempo Estimado:** ~20 minutos

---

### **FASE 2: Substituir Chamadas em `sendLogToProfessionalSystem()`**

**Objetivo:** Substituir chamadas de `console.log/error/warn()` por `novo_log_console_e_banco()`

**Ações:**
1. ✅ Identificar todas as chamadas de `console.log/error/warn()` dentro de `sendLogToProfessionalSystem()`
2. ✅ Substituir cada chamada por `novo_log_console_e_banco()` com parâmetros apropriados
3. ✅ Mapear níveis: `console.error()` → `'ERROR'`, `console.warn()` → `'WARN'`, `console.log()` → `'DEBUG'` ou `'INFO'`
4. ✅ Usar categoria `'LOG_INTERNAL'` para todas as chamadas dentro de `sendLogToProfessionalSystem()`
5. ✅ Verificar sintaxe do arquivo
6. ✅ Calcular hash SHA256 do arquivo modificado
7. ✅ Documentar alterações

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Chamadas a Substituir:** 19 chamadas (linhas 553-735)

**Tempo Estimado:** ~30 minutos

---

### **FASE 3: Substituir Chamada em `novo_log()`**

**Objetivo:** Substituir chamada de `console.error()` na linha 835 por `novo_log_console_e_banco()`

**Ações:**
1. ✅ Localizar linha 835 (tratamento de erro no catch de `novo_log()`)
2. ✅ Substituir `console.error()` por `novo_log_console_e_banco()` com parâmetros apropriados
3. ✅ Usar nível `'ERROR'` e categoria `'LOG_SYSTEM'`
4. ✅ Verificar sintaxe do arquivo
5. ✅ Calcular hash SHA256 do arquivo modificado
6. ✅ Documentar alteração

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Chamada a Substituir:** 1 chamada (linha 835)

**Tempo Estimado:** ~10 minutos

---

### **FASE 4: Verificação e Validação**

**Objetivo:** Verificar que todas as substituições foram feitas corretamente e que não há loops infinitos

**Ações:**
1. ✅ Buscar todas as chamadas de `console.log/error/warn/debug` restantes dentro de `sendLogToProfessionalSystem()` e `novo_log()`
2. ✅ Verificar que todas foram substituídas por `novo_log_console_e_banco()`
3. ✅ Verificar que não há chamadas de `novo_log()` ou `sendLogToProfessionalSystem()` dentro de `novo_log_console_e_banco()`
4. ✅ Verificar sintaxe de todos os arquivos modificados
5. ✅ Verificar que não há loops infinitos
6. ✅ Documentar resultados da verificação

**Tempo Estimado:** ~15 minutos

---

### **FASE 5: Testes Locais**

**Objetivo:** Testar que os arquivos modificados não têm erros de sintaxe

**Ações:**
1. ✅ Verificar sintaxe JavaScript dos arquivos modificados (se possível)
2. ✅ Verificar que não há erros de referência a funções não definidas
3. ✅ Verificar que `novo_log_console_e_banco()` está disponível globalmente
4. ✅ Documentar resultados dos testes

**Tempo Estimado:** ~10 minutos

---

### **FASE 6: Documentação**

**Objetivo:** Documentar todas as alterações realizadas

**Ações:**
1. ✅ Criar documento de resumo das alterações
2. ✅ Listar todos os arquivos modificados
3. ✅ Listar todas as chamadas substituídas
4. ✅ Documentar hashes SHA256 dos arquivos modificados
5. ✅ Criar checklist de deploy
6. ✅ Documentar exemplos de uso da nova função

**Tempo Estimado:** ~15 minutos

---

## ⏱️ TEMPO TOTAL ESTIMADO

**Tempo Total:** ~1h45min

| Fase | Tempo Estimado |
|------|----------------|
| FASE 0: Preparação e Backup | ~5 min |
| FASE 1: Implementar Função | ~20 min |
| FASE 2: Substituir em `sendLogToProfessionalSystem()` | ~30 min |
| FASE 3: Substituir em `novo_log()` | ~10 min |
| FASE 4: Verificação e Validação | ~15 min |
| FASE 5: Testes Locais | ~10 min |
| FASE 6: Documentação | ~15 min |
| **TOTAL** | **~1h45min** |

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Risco 1: Loop Infinito**

**Descrição:** Se `novo_log_console_e_banco()` chamar `novo_log()` ou `sendLogToProfessionalSystem()`, causaria loop infinito.

**Mitigação:**
- ✅ `novo_log_console_e_banco()` usa `fetch()` direto (não chama `novo_log()` nem `sendLogToProfessionalSystem()`)
- ✅ Não há chamadas recursivas

**Probabilidade:** Baixa (se seguir especificação)  
**Impacto:** Crítico (aplicação travaria)  
**Status:** ✅ Mitigado

---

### **Risco 2: Erro de Sintaxe**

**Descrição:** Erros de sintaxe introduzidos durante implementação podem quebrar a aplicação.

**Mitigação:**
- ✅ Verificar sintaxe após cada modificação
- ✅ Testar arquivos modificados antes de deploy
- ✅ Manter backups de todos os arquivos originais

**Probabilidade:** Baixa (se seguir especificação)  
**Impacto:** Crítico (aplicação não funcionaria)  
**Status:** ✅ Mitigado

---

### **Risco 3: Performance**

**Descrição:** Múltiplas chamadas de `fetch()` podem impactar performance.

**Mitigação:**
- ✅ `fetch()` é assíncrono e não bloqueia execução
- ✅ Erros são ignorados silenciosamente
- ✅ Chamadas são feitas apenas quando necessário

**Probabilidade:** Baixa  
**Impacto:** Médio (pode impactar performance em casos extremos)  
**Status:** ✅ Mitigado

---

### **Risco 4: Duplicação de Logs**

**Descrição:** Se `novo_log()` já envia para banco e `novo_log_console_e_banco()` também envia, pode haver duplicação.

**Mitigação:**
- ✅ `novo_log_console_e_banco()` será usada apenas dentro de `sendLogToProfessionalSystem()` e `novo_log()` para logs internos
- ✅ Logs principais continuam usando `novo_log()` normalmente
- ✅ Categoria `'LOG_INTERNAL'` diferencia logs internos de logs principais

**Probabilidade:** Baixa  
**Impacto:** Baixo (apenas logs internos seriam duplicados)  
**Status:** ✅ Mitigado

---

## ✅ CONFORMIDADE COM `./cursorrules`

### **Diretivas Respeitadas:**

1. ✅ **Autorização Prévia:** Projeto apresentado para autorização antes de implementação
2. ✅ **Backup ObrIGATÓRIO:** FASE 0 cria backups de todos os arquivos antes de modificar
3. ✅ **Modificação Local:** Todas as modificações serão feitas localmente primeiro
4. ✅ **Verificação de Hash:** Hashes SHA256 serão calculados e documentados
5. ✅ **Documentação:** Todas as alterações serão documentadas
6. ✅ **Auditoria Pós-Implementação:** FASE 4 inclui verificação completa
7. ✅ **Não Modificar Servidor Diretamente:** Apenas modificações locais
8. ✅ **Organização de Arquivos:** Backups em diretório apropriado

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Pré-Implementação:**
- [ ] Projeto apresentado ao usuário
- [ ] Autorização explícita recebida
- [ ] Backups criados (FASE 0)
- [ ] Hashes SHA256 dos arquivos originais documentados

### **Implementação:**
- [ ] FASE 1: Função `novo_log_console_e_banco()` implementada
- [ ] FASE 2: Substituições em `sendLogToProfessionalSystem()` concluídas
- [ ] FASE 3: Substituição em `novo_log()` concluída
- [ ] FASE 4: Verificação e validação concluída
- [ ] FASE 5: Testes locais concluídos
- [ ] FASE 6: Documentação concluída

### **Pós-Implementação:**
- [ ] Hashes SHA256 dos arquivos modificados documentados
- [ ] Documento de resumo das alterações criado
- [ ] Checklist de deploy criado
- [ ] Auditoria pós-implementação realizada

---

## 📊 RESUMO

### **Objetivo:**
Criar função `novo_log_console_e_banco()` que chama console E insere no banco simultaneamente, sem causar loops infinitos.

### **Arquivos a Modificar:**
1. `FooterCodeSiteDefinitivoCompleto.js` - Adicionar função e substituir 20 chamadas

### **Chamadas a Substituir:**
- 19 chamadas dentro de `sendLogToProfessionalSystem()` (linhas 553-735)
- 1 chamada dentro de `novo_log()` (linha 835)

### **Resultado Esperado:**
- ✅ Todas as chamadas de console dentro de `sendLogToProfessionalSystem()` e `novo_log()` enviam para banco
- ✅ Não há loops infinitos
- ✅ Função pode ser reutilizada em outros contextos

---

## 📝 EXEMPLOS DE USO

### **Exemplo 1: Uso dentro de `sendLogToProfessionalSystem()`**

**ANTES:**
```javascript
console.log('[LOG] Enviando log para', endpoint, { requestId: requestId });
```

**DEPOIS:**
```javascript
window.novo_log_console_e_banco('DEBUG', 'LOG_INTERNAL', 'Enviando log para ' + endpoint, { requestId: requestId });
```

---

### **Exemplo 2: Uso dentro de `novo_log()`**

**ANTES:**
```javascript
console.error('[LOG] Erro em novo_log():', error);
```

**DEPOIS:**
```javascript
window.novo_log_console_e_banco('ERROR', 'LOG_SYSTEM', 'Erro em novo_log()', {
  error_message: error?.message || String(error),
  error_stack: error?.stack,
  error_name: error?.name
});
```

---

### **Exemplo 3: Uso com opções**

```javascript
// Apenas console, sem banco
window.novo_log_console_e_banco('INFO', 'CATEGORY', 'Mensagem', data, { skipDatabase: true });

// Apenas banco, sem console
window.novo_log_console_e_banco('INFO', 'CATEGORY', 'Mensagem', data, { skipConsole: true });

// Com requestId customizado
window.novo_log_console_e_banco('INFO', 'CATEGORY', 'Mensagem', data, { requestId: 'custom_id' });
```

---

**Projeto criado em:** 17/11/2025  
**Versão do documento:** 1.0.0  
**Status:** 📝 **AGUARDANDO AUTORIZAÇÃO PARA IMPLEMENTAÇÃO**

