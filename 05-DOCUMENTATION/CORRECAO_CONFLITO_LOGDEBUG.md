# ✅ CORREÇÃO - Conflito de Assinaturas em logDebug

**Data:** 09/11/2025  
**Status:** ✅ **CORRIGIDO**

---

## 🚨 PROBLEMA IDENTIFICADO

Havia **DUAS definições** de `window.logDebug` com **assinaturas diferentes**:

### **1. Alias Global (linha 531):**
```javascript
window.logDebug = (cat, msg, data) => window.logUnified('debug', cat, msg, data);
```
**Assinatura:** `(category, message, data)`

### **2. Função Local Exposta (linha 1414):**
```javascript
window.logDebug = logDebug; // Sobrescreve a primeira!
```
**Assinatura:** `(level, message, data)`

---

## ⚠️ CONSEQUÊNCIA DO PROBLEMA

Quando o código chamava:
```javascript
window.logDebug('GCLID', '🔍 Iniciando captura - URL:', window.location.href);
```

**Após a linha 1414**, isso era interpretado como:
- `level = 'GCLID'` ❌ (não é um nível válido!)
- `message = '🔍 Iniciando captura - URL:'`
- `data = window.location.href`

**Resultado:**
- `'GCLID'` não está em `['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL']`
- A validação falhava ou usava fallback 'INFO'
- Mas o **parâmetro estava na posição errada**!

---

## ✅ CORREÇÃO APLICADA

**Removida a linha 1414** que sobrescrevia `window.logDebug`:

```javascript
// ANTES:
window.logDebug = logDebug; // ❌ Sobrescrevia o alias global

// DEPOIS:
// NÃO expor logDebug globalmente - já existe window.logDebug definido na linha 531
// window.logDebug = logDebug; // REMOVIDO - conflito de assinaturas
```

---

## 📊 RESULTADO

Agora:
- ✅ `window.logDebug` sempre usa o alias global (linha 531)
- ✅ Assinatura correta: `(category, message, data)`
- ✅ Chama `window.logUnified('debug', category, message, data)`
- ✅ Função local `logDebug` permanece para uso interno apenas

---

## 🔍 VERIFICAÇÃO

Todas as chamadas no código usam `window.logDebug(category, message, data)`:
- ✅ `window.logDebug('GCLID', '🔍 Iniciando captura - URL:', window.location.href);`
- ✅ `window.logDebug('MODAL', '✅ Handler click configurado:', id);`
- ✅ `window.logDebug('DEBUG', '🔍 Iniciando verificação...');`

Agora todas funcionam corretamente!

---

## 📝 DEPLOY

- ✅ Arquivo corrigido localmente
- ✅ Arquivo copiado para servidor DEV
- ✅ Pronto para teste

---

**Status:** ✅ **CORREÇÃO APLICADA E DEPLOY REALIZADO**

---

**Documento criado em:** 09/11/2025

