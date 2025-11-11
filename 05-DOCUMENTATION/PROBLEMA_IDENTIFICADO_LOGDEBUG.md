# 🚨 PROBLEMA IDENTIFICADO - Conflito de Assinaturas em logDebug

**Data:** 09/11/2025  
**Status:** 🔴 **PROBLEMA CRÍTICO IDENTIFICADO**

---

## 🔍 PROBLEMA ENCONTRADO

Há **DUAS definições diferentes** de `logDebug` com **assinaturas diferentes**:

### **1. Alias Global (linha 531):**
```javascript
window.logDebug = (cat, msg, data) => window.logUnified('debug', cat, msg, data);
```
**Assinatura:** `(category, message, data)`

### **2. Função Local (linha 1364):**
```javascript
function logDebug(level, message, data = null) {
    // ...
    window.sendLogToProfessionalSystem(level, null, validMessage, data);
}
```
**Assinatura:** `(level, message, data)`

---

## ⚠️ CONSEQUÊNCIA

Quando o código chama:
- `window.logDebug('GCLID', 'message')` → Usa o alias global → Chama `logUnified('debug', 'GCLID', 'message')` ✅ **CORRETO**
- `logDebug('INFO', 'message')` → Usa função local → Chama `sendLogToProfessionalSystem('INFO', null, 'message', null)` ✅ **CORRETO**

**MAS:**

A função local `logDebug` é exposta globalmente na linha 1414:
```javascript
window.logDebug = logDebug;
```

Isso **SOBRESCREVE** o alias global definido na linha 531!

---

## 🎯 RESULTADO

Após a linha 1414, `window.logDebug` passa a ser a função local que espera `(level, message, data)`, mas o código continua chamando com `(category, message, data)`.

**Exemplo:**
```javascript
window.logDebug('GCLID', '🔍 Iniciando captura - URL:', window.location.href);
```

Isso é interpretado como:
- `level = 'GCLID'` (não é um nível válido!)
- `message = '🔍 Iniciando captura - URL:'`
- `data = window.location.href`

Quando `'GCLID'` não está em `['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL']`, a validação pode falhar ou usar fallback 'INFO', mas o problema é que a **ordem dos parâmetros está errada**.

---

## 🔧 SOLUÇÃO

Precisamos garantir que:
1. `window.logDebug` seja sempre o alias que chama `logUnified` com nível 'debug'
2. A função local `logDebug` seja usada apenas internamente
3. Ou unificar as duas funções

---

## 📝 PRÓXIMOS PASSOS

1. Remover a linha que expõe `logDebug` globalmente (linha 1414)
2. Ou renomear a função local para não conflitar
3. Ou ajustar todas as chamadas para usar a assinatura correta

---

**Status:** 🔴 **AGUARDANDO CORREÇÃO**

