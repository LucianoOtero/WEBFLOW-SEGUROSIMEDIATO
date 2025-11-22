# 🔴 CORREÇÕES OBRIGATÓRIAS: Análise de Engenharia de Software

**Data:** 16/11/2025  
**Autor:** Engenheiro de Software  
**Status:** ⚠️ **CORREÇÕES OBRIGATÓRIAS IDENTIFICADAS**

---

## 🚨 CORREÇÕES OBRIGATÓRIAS ANTES DE IMPLEMENTAR

### **1. Dependência Circular - CRÍTICO** 🔴

**Problema:**
- `sendLogToProfessionalSystem()` usa `logClassified()` internamente (linhas 430, 435, 441, 442, 455, 510-524, 538-600)
- `logClassified()` será substituído por `UnifiedLogger.log()`
- `UnifiedLogger.log()` chama `sendLogToProfessionalSystem()` para persistir no banco
- **Resultado:** Loop infinito 🔴

**Solução Obrigatória:**
```javascript
// ❌ NÃO FAZER: Usar UnifiedLogger em sendLogToProfessionalSystem()
async function sendLogToProfessionalSystem(level, category, message, data) {
    // ...
    UnifiedLogger.log('WARN', 'LOG', '...');  // ❌ CAUSA LOOP INFINITO
}

// ✅ FAZER: Usar console.log direto
async function sendLogToProfessionalSystem(level, category, message, data) {
    // ...
    console.warn('[LOG] sendLogToProfessionalSystem chamado sem level válido');  // ✅ SEGURO
    console.debug('[LOG] Enviando log para', endpoint);  // ✅ SEGURO
}
```

**Arquivo:** `FooterCodeSiteDefinitivoCompleto.js`  
**Linhas afetadas:** 430, 435, 441, 442, 455, 510-524, 538-600  
**Status:** ⚠️ **REQUER CORREÇÃO ANTES DE IMPLEMENTAR**

---

### **2. Prevenção de Recursão - Validação Obrigatória** ⚠️

**Problema:**
- Prevenção simplificada (flag + limite) pode não detectar todos os casos
- Pode bloquear logs legítimos em casos de logging aninhado

**Solução Obrigatória:**
- ✅ Criar testes unitários para recursão direta
- ✅ Criar testes unitários para recursão indireta
- ✅ Criar testes para logging aninhado legítimo
- ⚠️ Adicionar fallback (stack de chamadas) se necessário

**Cenários de Teste Obrigatórios:**
```javascript
// Teste 1: Recursão direta
UnifiedLogger.log('INFO', 'TEST', 'Message');
// Deve ser bloqueado

// Teste 2: Recursão indireta
function A() { UnifiedLogger.info('A', 'Message'); B(); }
function B() { UnifiedLogger.info('B', 'Message'); C(); }
function C() { UnifiedLogger.info('C', 'Message'); A(); }
// Deve ser detectado e bloqueado

// Teste 3: Logging aninhado legítimo
UnifiedLogger.info('CAT1', 'Message 1');
// ... código ...
UnifiedLogger.info('CAT2', 'Message 2');
// NÃO deve ser bloqueado
```

**Status:** ⚠️ **REQUER VALIDAÇÃO EM TESTES**

---

### **3. Ordem de Carregamento - Documentação Obrigatória** ⚠️

**Problema:**
- `webflow_injection_limpo.js` depende de aliases em `FooterCodeSiteDefinitivoCompleto.js`
- Se ordem de carregamento mudar, logs não funcionarão

**Solução Obrigatória:**
1. ✅ Documentar que `FooterCodeSiteDefinitivoCompleto.js` deve carregar antes
2. ✅ Adicionar validação no início de `webflow_injection_limpo.js`:
   ```javascript
   // No início de webflow_injection_limpo.js
   if (!window.logClassified && !window.UnifiedLogger) {
       console.error('[webflow_injection_limpo.js] logClassified ou UnifiedLogger não disponível. Verifique ordem de carregamento.');
       // Fallback ou aguardar
   }
   ```

**Arquivo:** `webflow_injection_limpo.js`  
**Status:** ⚠️ **REQUER DOCUMENTAÇÃO E VALIDAÇÃO**

---

### **4. Validação em Wrappers PHP - Recomendado** ⚠️

**Problema:**
- `$logger->$level()` pode falhar se método não existir
- Edge cases não tratados

**Solução Recomendada:**
```php
// Adicionar validação
if (!method_exists($logger, $level)) {
    $level = 'info';  // Fallback
}
```

**Status:** ⚠️ **RECOMENDADO** (não crítico, mas importante)

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

Antes de iniciar implementação, verificar:

- [ ] 🔴 **CRÍTICO:** Dependência circular resolvida (`sendLogToProfessionalSystem()` usa `console.log` direto)
- [ ] ⚠️ **OBRIGATÓRIO:** Testes de recursão criados e validados
- [ ] ⚠️ **OBRIGATÓRIO:** Ordem de carregamento documentada e validada
- [ ] ⚠️ **RECOMENDADO:** Validação em wrappers PHP adicionada
- [ ] ⚠️ **RECOMENDADO:** Campos opcionais em 5Ws adicionados

---

**Status:** ⚠️ **CORREÇÕES OBRIGATÓRIAS IDENTIFICADAS**  
**Última atualização:** 16/11/2025

