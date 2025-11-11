# 📋 ESPECIFICAÇÃO CORRETA - VARIÁVEIS DE AMBIENTE

**Data:** 08/11/2025  
**Status:** ⚠️ **PRECISA CORREÇÃO**

---

## 🎯 ESPECIFICAÇÃO ORIGINAL

A especificação era:
- ✅ **Usar variáveis de ambiente do Docker** para localizar onde estão os arquivos .js e .php
- ✅ **Usar variáveis de sistema** (não criar `config.js.php`)
- ❌ **NÃO criar** `window.APP_CONFIG` ou `config.js.php`

---

## ❌ O QUE FOI IMPLEMENTADO ERRADO

### **Erro 1: Criado `config.js.php`**
- ❌ Foi criado um arquivo `config.js.php` que gera `window.APP_CONFIG`
- ❌ Isso não era a especificação

### **Erro 2: Sistema de Config Centralizado**
- ❌ Foi criado um sistema de configuração centralizado
- ❌ A especificação era usar variáveis de ambiente diretamente

---

## ✅ O QUE DEVERIA SER

### **Especificação Correta:**
1. **Variáveis de ambiente no Docker:**
   - `APP_BASE_DIR` - Diretório onde estão os arquivos no servidor
   - `APP_BASE_URL` - URL base para acessar os arquivos

2. **JavaScript deve usar:**
   - Ler `APP_BASE_URL` diretamente (se disponível via meta tag ou script inline)
   - OU usar caminhos relativos baseados na URL atual
   - **NÃO criar** `window.APP_CONFIG`

3. **PHP deve usar:**
   - `$_ENV['APP_BASE_DIR']` para includes locais
   - `$_ENV['APP_BASE_URL']` para construir URLs (se necessário)
   - **Já está correto** no `config.php`

---

## 🔧 CORREÇÃO NECESSÁRIA

### **1. Remover `config.js.php`:**
- ❌ Não deveria existir
- ❌ Não deveria gerar `window.APP_CONFIG`

### **2. JavaScript deve usar:**
- Caminhos relativos (`./arquivo.php`)
- OU detectar URL base da página atual
- OU usar meta tag com `APP_BASE_URL`

### **3. PHP já está correto:**
- ✅ `config.php` usa `$_ENV['APP_BASE_DIR']` e `$_ENV['APP_BASE_URL']`
- ✅ Isso está de acordo com a especificação

---

## 📝 PRÓXIMOS PASSOS

1. **Verificar especificação original** do usuário
2. **Remover `config.js.php`** se não for necessário
3. **Ajustar JavaScript** para usar variáveis de ambiente diretamente
4. **Manter PHP** como está (já está correto)

---

**Documento criado em:** 08/11/2025  
**Status:** ⚠️ Aguardando confirmação da especificação correta

