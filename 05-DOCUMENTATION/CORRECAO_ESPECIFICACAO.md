# ⚠️ CORREÇÃO NECESSÁRIA - ESPECIFICAÇÃO

**Data:** 08/11/2025  
**Status:** ⚠️ **PRECISA CORREÇÃO**

---

## 🎯 ESPECIFICAÇÃO CORRETA

A especificação era:
- ✅ **Usar variáveis de ambiente do Docker** (`APP_BASE_DIR`, `APP_BASE_URL`)
- ✅ **JavaScript deve usar caminhos relativos** ou detectar URL base da página
- ✅ **PHP já usa variáveis de ambiente** (correto)
- ❌ **NÃO criar** `config.js.php` ou `window.APP_CONFIG`

---

## ❌ O QUE FOI IMPLEMENTADO ERRADO

### **1. Criado `config.js.php`:**
- ❌ Arquivo que gera `window.APP_CONFIG`
- ❌ Não era a especificação

### **2. JavaScript usando `window.APP_CONFIG`:**
- ❌ Código modificado para usar `window.APP_CONFIG?.getEndpointUrl()`
- ❌ Deveria usar caminhos relativos ou variáveis de ambiente diretamente

---

## ✅ O QUE DEVERIA SER

### **JavaScript:**
```javascript
// CORRETO: Usar caminhos relativos
fetch('./debug_logger_db.php', {...})

// OU: Detectar URL base da página atual
const baseUrl = window.location.origin;
fetch(`${baseUrl}/debug_logger_db.php`, {...})

// NÃO criar window.APP_CONFIG
```

### **PHP (já está correto):**
```php
// ✅ CORRETO: Usar variáveis de ambiente
$base_dir = $_ENV['APP_BASE_DIR'] ?? __DIR__;
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
```

---

## 🔧 CORREÇÃO NECESSÁRIA

### **1. Remover `config.js.php`:**
- ❌ Não deveria existir
- ❌ Deletar do servidor

### **2. Ajustar JavaScript:**
- ✅ Usar caminhos relativos (`./arquivo.php`)
- ✅ OU usar `window.location.origin` para detectar URL base
- ❌ Remover referências a `window.APP_CONFIG`

### **3. PHP está correto:**
- ✅ `config.php` já usa `$_ENV['APP_BASE_DIR']` e `$_ENV['APP_BASE_URL']`
- ✅ Manter como está

---

## 📋 PRÓXIMOS PASSOS

1. **Confirmar especificação** com o usuário
2. **Remover `config.js.php`** do servidor
3. **Ajustar JavaScript** para usar caminhos relativos
4. **Manter PHP** como está (já está correto)

---

**Aguardando confirmação para corrigir...**

