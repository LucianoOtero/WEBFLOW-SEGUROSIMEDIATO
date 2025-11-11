# 📊 MAPEAMENTO COMPLETO - INTEGRAÇÃO DE LOGGING

**Data:** 09/11/2025  
**Versão:** 1.0.0

---

## 📁 ARQUIVOS JAVASCRIPT - ANÁLISE DETALHADA

### **1. FooterCodeSiteDefinitivoCompleto.js**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Funções de Logging Identificadas:**
- `window.logUnified()` (linha ~252) - Função principal
- `window.logInfo()` (linha ~320) - Alias para logUnified('info')
- `window.logError()` (linha ~321) - Alias para logUnified('error')
- `window.logWarn()` (linha ~322) - Alias para logUnified('warn')
- `window.logDebug()` (linha ~323) - Alias para logUnified('debug')
- `logDebug()` (linha ~1156) - Função que envia para `debug_logger_db.php`

**Chamadas Identificadas:**
- `window.logUnified()`: ~280+ chamadas
- `window.logInfo()`: ~50+ chamadas
- `window.logError()`: ~30+ chamadas
- `window.logWarn()`: ~20+ chamadas
- `window.logDebug()`: ~100+ chamadas

**Endpoint Atual:**
- Linha ~1174: `debug_logger_db.php`

**Alterações Necessárias:**
1. Substituir endpoint `debug_logger_db.php` por `log_endpoint.php`
2. Adicionar captura de arquivo/linha na função `logDebug()`
3. Manter compatibilidade com `window.logUnified()`
4. Atualizar formato do payload para novo sistema

---

### **2. MODAL_WHATSAPP_DEFINITIVO.js**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`

**Funções de Logging Identificadas:**
- `window.logDebug()` (linhas 256, 336) - Usa função do FooterCode

**Chamadas Identificadas:**
- ~10 chamadas de `window.logDebug()`

**Alterações Necessárias:**
- Nenhuma alteração direta necessária (usa `window.logDebug` do FooterCode)
- Garantir que categoria "MODAL" seja passada automaticamente

---

### **3. webflow_injection_limpo.js**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`

**Análise:**
- Verificar se há chamadas de logging
- Se houver, integrar com novo sistema

---

## 📁 ARQUIVOS PHP - ANÁLISE DETALHADA

### **Arquivos que Podem Ter Logging:**

1. **add_flyingdonkeys.php**
   - Verificar uso de `error_log()` ou logs manuais
   - Integrar `ProfessionalLogger` se necessário

2. **add_webflow_octa.php**
   - Verificar uso de `error_log()` ou logs manuais
   - Integrar `ProfessionalLogger` se necessário

3. **add_travelangels.php**
   - Verificar uso de `error_log()` ou logs manuais
   - Integrar `ProfessionalLogger` se necessário

4. **cpf-validate.php**
   - Verificar uso de `error_log()` ou logs manuais
   - Integrar `ProfessionalLogger` se necessário

5. **placa-validate.php**
   - Verificar uso de `error_log()` ou logs manuais
   - Integrar `ProfessionalLogger` se necessário

6. **send_email_notification_endpoint.php**
   - Verificar uso de `error_log()` ou logs manuais
   - Integrar `ProfessionalLogger` se necessário

---

## 🔄 MAPEAMENTO DE MUDANÇAS

### **JavaScript - Antes e Depois**

**ANTES:**
```javascript
const debugLoggerUrl = window.APP_BASE_URL + '/debug_logger_db.php';
fetch(debugLoggerUrl, {
  method: 'POST',
  body: JSON.stringify({
    level: level,
    message: message,
    data: data,
    timestamp: new Date().toISOString(),
    sessionId: window.sessionId,
    url: window.location.href,
    userAgent: navigator.userAgent
  })
});
```

**DEPOIS:**
```javascript
const logEndpointUrl = window.APP_BASE_URL + '/log_endpoint.php';
const callerInfo = getCallerInfo(); // Captura arquivo/linha
fetch(logEndpointUrl, {
  method: 'POST',
  body: JSON.stringify({
    level: level.toUpperCase(), // DEBUG, INFO, WARN, ERROR, FATAL
    category: category || null,
    message: message,
    data: data || null,
    session_id: window.sessionId || null,
    url: window.location.href
    // Arquivo/linha será capturado automaticamente pelo servidor
  })
});
```

### **PHP - Antes e Depois**

**ANTES:**
```php
error_log("Mensagem de erro");
// ou
file_put_contents('log.txt', "Mensagem\n", FILE_APPEND);
```

**DEPOIS:**
```php
require_once __DIR__ . '/ProfessionalLogger.php';
$logger = new ProfessionalLogger();
$logger->error('Mensagem de erro', ['context' => 'adicional'], 'CATEGORY');
```

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Fase 1: Preparação**
- [ ] Criar diretório de backup
- [ ] Fazer backup de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Fazer backup de `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Fazer backup de `webflow_injection_limpo.js`
- [ ] Documentar estado atual

### **Fase 2: JavaScript - Função Centralizada**
- [ ] Criar função `getCallerInfo()` para capturar arquivo/linha
- [ ] Criar função `sendLogToProfessionalSystem()`
- [ ] Integrar com `window.logUnified()`
- [ ] Manter compatibilidade com código existente

### **Fase 3: JavaScript - Atualizar FooterCode**
- [ ] Substituir endpoint em `logDebug()` (linha ~1174)
- [ ] Adicionar captura de arquivo/linha
- [ ] Atualizar formato do payload
- [ ] Testar todas as funções de log

### **Fase 4: JavaScript - Verificar Outros Arquivos**
- [ ] Verificar `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Verificar `webflow_injection_limpo.js`
- [ ] Garantir compatibilidade

### **Fase 5: PHP - Análise e Integração (quando autorizado)**
- [ ] Analisar cada arquivo PHP
- [ ] Identificar uso de logging
- [ ] Integrar `ProfessionalLogger` onde necessário
- [ ] Testar cada endpoint

### **Fase 6: Deploy e Testes**
- [ ] Deploy dos arquivos `.js` para servidor DEV
- [ ] Testar inserção de logs
- [ ] Verificar captura de arquivo/linha no banco
- [ ] Testar consulta de logs
- [ ] Validar funcionamento completo

---

## 🧪 TESTES DETALHADOS

### **Teste 1: Captura de Arquivo/Linha**
```javascript
window.logInfo('TEST', 'Teste de captura');
// Verificar no banco:
// - file_name deve ser "FooterCodeSiteDefinitivoCompleto.js"
// - line_number deve ser o número da linha onde logInfo foi chamado
```

### **Teste 2: Todos os Níveis**
```javascript
window.logDebug('TEST', 'Debug');
window.logInfo('TEST', 'Info');
window.logWarn('TEST', 'Warn');
window.logError('TEST', 'Error');
// Verificar no banco que todos foram salvos com níveis corretos
```

### **Teste 3: Categorias**
```javascript
window.logInfo('UTILS', 'Mensagem');
window.logInfo('MODAL', 'Mensagem');
window.logInfo('RPA', 'Mensagem');
// Verificar no banco que categoria está correta
```

### **Teste 4: Dados Adicionais**
```javascript
window.logInfo('TEST', 'Mensagem', {key: 'value', number: 123});
// Verificar no banco que data está em JSON
```

### **Teste 5: Contexto**
```javascript
window.logInfo('TEST', 'Mensagem');
// Verificar no banco:
// - url está correto
// - session_id está presente
// - ip_address está presente
// - user_agent está presente
```

---

## 📊 MÉTRICAS DE VALIDAÇÃO

- ✅ 100% dos logs sendo salvos no banco `rpa_logs_dev`
- ✅ 100% dos logs com `file_name` preenchido
- ✅ 100% dos logs com `line_number` preenchido
- ✅ 100% dos logs com `level` correto (DEBUG, INFO, WARN, ERROR, FATAL)
- ✅ 100% dos logs com `category` quando aplicável
- ✅ 0 erros de conexão ou inserção
- ✅ Consulta via API funcionando
- ✅ Compatibilidade mantida com código existente

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025

