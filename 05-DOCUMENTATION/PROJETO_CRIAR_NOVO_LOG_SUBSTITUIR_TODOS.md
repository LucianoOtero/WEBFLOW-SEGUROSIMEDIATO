# 🎯 PROJETO: Criar novo_log() e Substituir Todas as Chamadas de Log

**Data de Criação:** 16/11/2025  
**Status:** 📋 **PROJETO ELABORADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.0.0  
**Prioridade:** 🔴 **CRÍTICA**

---

## 🎯 OBJETIVO

Criar uma função única `novo_log()` que:
1. ✅ Chama `console.log()` (para exibir no Console do Navegador)
2. ✅ Chama o endpoint `insertLog()` via `sendLogToProfessionalSystem()` (para persistir no banco)

E substituir **TODAS** as chamadas de log existentes por essa nova função.

---

## 📊 SITUAÇÃO ATUAL

### **JavaScript - Funções de Log Identificadas:**

1. **`logClassified()`** - 519+ ocorrências
2. **`logUnified()`** - 1+ ocorrência (deprecated)
3. **`debugLog()`** - 30+ ocorrências
4. **`logEvent()`** - 10+ ocorrências
5. **`logInfo()` / `logError()` / `logWarn()`** - 50+ ocorrências
6. **`sendLogToProfessionalSystem()`** - Chamado diretamente em alguns lugares

**Total JavaScript:** ~610+ chamadas de log

### **PHP - Funções de Log Identificadas:**

1. **`logDevWebhook()`** - 130+ ocorrências em `add_flyingdonkeys.php`
2. **`logProdWebhook()`** - 153+ ocorrências (130+ em `add_flyingdonkeys.php`, 23+ em `add_webflow_octa.php`)
3. **`error_log()` direto** - Múltiplas ocorrências
4. **`file_put_contents()` para logs** - Múltiplas ocorrências

**Total PHP:** ~283+ chamadas de log

---

## ✅ SOLUÇÃO PROPOSTA

### **1. Criar Função `novo_log()` em JavaScript**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js`

**Assinatura:**
```javascript
function novo_log(level, category, message, data = null) {
    // 1. console.log() no navegador
    const formattedMessage = category ? `[${category}] ${message}` : message;
    switch(level.toUpperCase()) {
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
    
    // 2. insertLog() via endpoint (assíncrono, não bloqueia)
    if (typeof window.sendLogToProfessionalSystem === 'function') {
        window.sendLogToProfessionalSystem(level, category, message, data).catch(() => {
            // Falha silenciosa - não bloquear execução
        });
    }
}
```

**Características:**
- ✅ Simples e direta
- ✅ Faz console.log + insertLog()
- ✅ Não tem validações complexas (deixa para `sendLogToProfessionalSystem()`)
- ✅ Não causa loop (não chama outras funções de log internamente)

---

### **2. Substituir Todas as Chamadas JavaScript**

#### **2.1. Substituir `logClassified()` por `novo_log()`**

**Arquivos:**
- `FooterCodeSiteDefinitivoCompleto.js` - 231+ ocorrências
- `webflow_injection_limpo.js` - 288+ ocorrências

**Mapeamento:**
```javascript
// ANTES:
logClassified('INFO', 'TEST', 'Mensagem', { dados: 'exemplo' });

// DEPOIS:
novo_log('INFO', 'TEST', 'Mensagem', { dados: 'exemplo' });
```

#### **2.2. Substituir `logUnified()` por `novo_log()`**

**Arquivo:** `FooterCodeSiteDefinitivoCompleto.js` - 1+ ocorrência

**Mapeamento:**
```javascript
// ANTES:
logUnified('info', 'TEST', 'Mensagem', { dados: 'exemplo' });

// DEPOIS:
novo_log('INFO', 'TEST', 'Mensagem', { dados: 'exemplo' });
```

#### **2.3. Substituir `debugLog()` por `novo_log()`**

**Arquivo:** `MODAL_WHATSAPP_DEFINITIVO.js` - 30+ ocorrências

**Mapeamento:**
```javascript
// ANTES:
debugLog('GTM', 'PUSHING_TO_DATALAYER', { data: 'exemplo' }, 'info');

// DEPOIS:
novo_log('INFO', 'GTM', 'PUSHING_TO_DATALAYER', { data: 'exemplo' });
```

#### **2.4. Substituir `logEvent()` por `novo_log()`**

**Arquivo:** `MODAL_WHATSAPP_DEFINITIVO.js` - 10+ ocorrências

**Mapeamento:**
```javascript
// ANTES:
logEvent('whatsapp_modal_gtm_initial_conversion', { data: 'exemplo' }, 'info');

// DEPOIS:
novo_log('INFO', 'EVENT', 'whatsapp_modal_gtm_initial_conversion', { data: 'exemplo' });
```

#### **2.5. Substituir `logInfo()` / `logError()` / `logWarn()` por `novo_log()`**

**Arquivo:** `FooterCodeSiteDefinitivoCompleto.js` - 50+ ocorrências

**Mapeamento:**
```javascript
// ANTES:
logInfo('TEST', 'Mensagem', { dados: 'exemplo' });
logError('TEST', 'Mensagem', { dados: 'exemplo' });
logWarn('TEST', 'Mensagem', { dados: 'exemplo' });

// DEPOIS:
novo_log('INFO', 'TEST', 'Mensagem', { dados: 'exemplo' });
novo_log('ERROR', 'TEST', 'Mensagem', { dados: 'exemplo' });
novo_log('WARN', 'TEST', 'Mensagem', { dados: 'exemplo' });
```

#### **2.6. Substituir `sendLogToProfessionalSystem()` direto por `novo_log()`**

**Arquivos:** Todos os arquivos que chamam diretamente

**Mapeamento:**
```javascript
// ANTES:
sendLogToProfessionalSystem('INFO', 'TEST', 'Mensagem', { dados: 'exemplo' });

// DEPOIS:
novo_log('INFO', 'TEST', 'Mensagem', { dados: 'exemplo' });
```

---

### **3. Substituir Todas as Chamadas PHP**

#### **3.1. Substituir `logDevWebhook()` e `logProdWebhook()` por `ProfessionalLogger`**

**Arquivos:**
- `add_flyingdonkeys.php` - 130+ ocorrências
- `add_webflow_octa.php` - 23+ ocorrências

**Mapeamento:**
```php
// ANTES:
logProdWebhook('event_name', $data, true);
logDevWebhook('event_name', $data, false);

// DEPOIS:
$logger = new ProfessionalLogger();
$logger->info('event_name', $data, 'FLYINGDONKEYS');  // ou 'OCTADESK'
$logger->error('event_name', $data, 'FLYINGDONKEYS');
```

**Ou criar wrapper para compatibilidade:**
```php
function logProdWebhook($event, $data, $success = true) {
    static $logger = null;
    if ($logger === null) {
        require_once __DIR__ . '/ProfessionalLogger.php';
        $logger = new ProfessionalLogger();
    }
    
    $level = $success ? 'info' : 'error';
    $category = 'FLYINGDONKEYS';  // ou 'OCTADESK'
    $logger->$level($event, $data, $category);
}

function logDevWebhook($event, $data, $success = true) {
    return logProdWebhook($event, $data, $success);
}
```

#### **3.2. Substituir `error_log()` direto por `ProfessionalLogger`**

**Arquivos:** Todos os arquivos PHP que usam `error_log()` para logging

**Mapeamento:**
```php
// ANTES:
error_log("Mensagem de log");

// DEPOIS:
$logger = new ProfessionalLogger();
$logger->info("Mensagem de log");
```

#### **3.3. Substituir `file_put_contents()` para logs por `ProfessionalLogger`**

**Arquivos:** Todos os arquivos PHP que usam `file_put_contents()` para logging

**Mapeamento:**
```php
// ANTES:
file_put_contents($logFile, $logLine, FILE_APPEND | LOCK_EX);

// DEPOIS:
$logger = new ProfessionalLogger();
$logger->info("Mensagem de log");
// insertLog() faz banco + arquivo (fallback) + error_log() automaticamente
```

---

## 📁 ARQUIVOS A MODIFICAR

### **JavaScript:**

1. **`FooterCodeSiteDefinitivoCompleto.js`**
   - ✅ Criar função `novo_log()`
   - ✅ Substituir `logClassified()` por `novo_log()` (231+ ocorrências)
   - ✅ Substituir `logUnified()` por `novo_log()` (1+ ocorrência)
   - ✅ Substituir `logInfo()` / `logError()` / `logWarn()` por `novo_log()` (50+ ocorrências)
   - ✅ Substituir `sendLogToProfessionalSystem()` direto por `novo_log()` (se houver)
   - ✅ Atualizar `sendLogToProfessionalSystem()` para usar `console.log` direto (evitar loop)

2. **`webflow_injection_limpo.js`**
   - ✅ Substituir `logClassified()` por `novo_log()` (288+ ocorrências)

3. **`MODAL_WHATSAPP_DEFINITIVO.js`**
   - ✅ Substituir `debugLog()` por `novo_log()` (30+ ocorrências)
   - ✅ Substituir `logEvent()` por `novo_log()` (10+ ocorrências)

### **PHP:**

1. **`add_flyingdonkeys.php`**
   - ✅ Refatorar `logDevWebhook()` e `logProdWebhook()` para usar `ProfessionalLogger` (130+ ocorrências)

2. **`add_webflow_octa.php`**
   - ✅ Refatorar `logProdWebhook()` para usar `ProfessionalLogger` (23+ ocorrências)

3. **Outros arquivos PHP (a identificar)**
   - ✅ Substituir `error_log()` direto por `ProfessionalLogger`
   - ✅ Substituir `file_put_contents()` para logs por `ProfessionalLogger`

---

## 🔄 FASES DO PROJETO

### **FASE 1: Criar `novo_log()` em JavaScript** ⏳

- [ ] Criar backup de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Criar função `novo_log()` após `logClassified()` (linha ~185)
- [ ] Expor globalmente: `window.novo_log = novo_log;`
- [ ] Testar função isoladamente

### **FASE 2: Substituir Chamadas JavaScript** ⏳

- [ ] Substituir `logClassified()` por `novo_log()` em `FooterCodeSiteDefinitivoCompleto.js` (231+ ocorrências)
- [ ] Substituir `logClassified()` por `novo_log()` em `webflow_injection_limpo.js` (288+ ocorrências)
- [ ] Substituir `logUnified()` por `novo_log()` em `FooterCodeSiteDefinitivoCompleto.js` (1+ ocorrência)
- [ ] Substituir `debugLog()` por `novo_log()` em `MODAL_WHATSAPP_DEFINITIVO.js` (30+ ocorrências)
- [ ] Substituir `logEvent()` por `novo_log()` em `MODAL_WHATSAPP_DEFINITIVO.js` (10+ ocorrências)
- [ ] Substituir `logInfo()` / `logError()` / `logWarn()` por `novo_log()` (50+ ocorrências)
- [ ] Atualizar `sendLogToProfessionalSystem()` para usar `console.log` direto (evitar loop)

### **FASE 3: Substituir Chamadas PHP** ⏳

- [ ] Criar backup de `add_flyingdonkeys.php` e `add_webflow_octa.php`
- [ ] Substituir `logDevWebhook()` e `logProdWebhook()` em `add_flyingdonkeys.php` por `$logger = new ProfessionalLogger(); $logger->info()/error()`
- [ ] Substituir `logProdWebhook()` em `add_webflow_octa.php` por `$logger = new ProfessionalLogger(); $logger->info()/error()`
- [ ] Identificar e substituir `error_log()` direto por `$logger = new ProfessionalLogger(); $logger->info()/error()`
- [ ] Identificar e substituir `file_put_contents()` para logs por `$logger = new ProfessionalLogger(); $logger->info()/error()`

### **FASE 4: Deploy e Teste** ⏳

- [ ] Copiar arquivos para servidor DEV
- [ ] Verificar hash após cópia
- [ ] Testar que logs aparecem no console E no banco
- [ ] Verificar que não há loops infinitos
- [ ] Verificar que todas as funcionalidades continuam funcionando

---

## ⚠️ PRECAUÇÕES

### **1. Loop Infinito**

**Risco:** `sendLogToProfessionalSystem()` pode chamar `novo_log()` internamente

**Solução:**
- `novo_log()`` chama `sendLogToProfessionalSystem()` ✅
- `sendLogToProfessionalSystem()` deve usar `console.log` direto (não `novo_log()`) ✅
- **Resultado:** Sem loop!

### **2. Compatibilidade**

**Risco:** Código existente pode depender de assinaturas específicas

**Solução:**
- Manter aliases de compatibilidade se necessário
- Testar todas as funcionalidades após substituição

### **3. Performance**

**Risco:** Muitas chamadas HTTP podem impactar performance

**Solução:**
- `sendLogToProfessionalSystem()` já é assíncrono (não bloqueia)
- Falhas são silenciosas (não quebram aplicação)

---

## ✅ VANTAGENS

1. ✅ **Simplicidade:** Uma única função para tudo
2. ✅ **Consistência:** Todos os logs seguem o mesmo padrão
3. ✅ **Rastreabilidade:** Todos os logs no banco de dados
4. ✅ **Sem loop:** `novo_log()` não chama outras funções de log
5. ✅ **Manutenibilidade:** Menos funções = mais fácil de manter

---

## 📊 ESTATÍSTICAS

### **Chamadas a Substituir:**

| Tipo | Quantidade | Arquivo |
|------|------------|---------|
| `logClassified()` | 519+ | `FooterCodeSiteDefinitivoCompleto.js`, `webflow_injection_limpo.js` |
| `logUnified()` | 1+ | `FooterCodeSiteDefinitivoCompleto.js` |
| `debugLog()` | 30+ | `MODAL_WHATSAPP_DEFINITIVO.js` |
| `logEvent()` | 10+ | `MODAL_WHATSAPP_DEFINITIVO.js` |
| `logInfo/Error/Warn()` | 50+ | `FooterCodeSiteDefinitivoCompleto.js` |
| `logDevWebhook()` | 130+ | `add_flyingdonkeys.php` |
| `logProdWebhook()` | 153+ | `add_flyingdonkeys.php`, `add_webflow_octa.php` |
| **TOTAL** | **~893+ chamadas** | |

---

## ✅ CONCLUSÃO

**Objetivo:** Criar `novo_log()` e substituir todas as chamadas de log existentes  
**Resultado:** Sistema de logging unificado, simples e consistente  
**Risco de loop:** Praticamente zero (com implementação correta)

---

## 📋 ESTRATÉGIA CONFIRMADA PELO USUÁRIO

### **JavaScript:**
- ✅ **Todas as funções de log** → Substituir por `novo_log()`

### **PHP:**
- ✅ **Todas as funções de log** → Substituir por:
  ```php
  $logger = new ProfessionalLogger();
  $logger->info('event_name', $data, 'FLYINGDONKEYS');
  $logger->info("Mensagem");
  ```

**Nota:** `insertLog()` é chamado internamente pelos métodos públicos (`info()`, `error()`, `warn()`, `debug()`, `fatal()`, `log()`)

---

**Status:** 📋 **PROJETO ELABORADO - AGUARDANDO AUTORIZAÇÃO**  
**Última atualização:** 16/11/2025

