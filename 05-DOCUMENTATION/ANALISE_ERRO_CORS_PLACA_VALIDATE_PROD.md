# 🔍 Análise: Erro CORS placa-validate.php em Produção

**Data:** 16/11/2025  
**Ambiente:** Produção (`prod.bssegurosimediato.com.br`)  
**Erro:** HTTP CORS - Header `Access-Control-Allow-Origin` duplicado

---

## 🎯 RESUMO EXECUTIVO

### **Erro Identificado:**

```
Access to fetch at 'https://prod.bssegurosimediato.com.br/placa-validate.php' 
from origin 'https://www.segurosimediato.com.br' has been blocked by CORS policy: 
The 'Access-Control-Allow-Origin' header contains multiple values 
'https://www.segurosimediato.com.br, https://www.segurosimediato.com.br', 
but only one is allowed.
```

**Status HTTP:** `200 (OK)` - O servidor responde corretamente, mas o navegador bloqueia devido ao CORS.

---

## 🔍 ANÁLISE DETALHADA

### **1. Causa Raiz do Erro**

**Problema:** O header `Access-Control-Allow-Origin` está sendo enviado **duas vezes** com o mesmo valor:
- Uma vez pelo **Nginx** (via location geral `location ~ \.php$`)
- Uma vez pelo **PHP** (via `setCorsHeaders()`)

**Resultado:** O navegador recebe:
```
Access-Control-Allow-Origin: https://www.segurosimediato.com.br, https://www.segurosimediato.com.br
```

**Esperado:** Apenas um valor:
```
Access-Control-Allow-Origin: https://www.segurosimediato.com.br
```

---

### **2. Verificações Realizadas**

#### **2.1. Arquivo PHP no Servidor**

**Arquivo:** `/var/www/html/prod/root/placa-validate.php`

**Conteúdo (linhas 1-11):**
```php
<?php
// Incluir config.php ANTES de qualquer header ou output para usar setCorsHeaders()
require_once __DIR__ . '/config.php';

// Headers CORS (usar função do config.php para evitar duplicação com Nginx)
// IMPORTANTE: Headers devem ser enviados ANTES de qualquer output
header('Content-Type: application/json; charset=utf-8');
// Usar setCorsHeaders() do config.php - valida origem e envia apenas um valor no header
setCorsHeaders();
// Adicionar headers específicos após setCorsHeaders() se necessário
header('Access-Control-Allow-Headers: Content-Type');
```

**Análise:**
- ✅ Arquivo PHP está correto
- ✅ Usa `setCorsHeaders()` do `config.php`
- ✅ Não tem headers CORS hardcoded
- ✅ Segue padrão arquitetural correto

#### **2.2. Configuração Nginx em Produção**

**Arquivo:** `/etc/nginx/sites-available/prod.bssegurosimediato.com.br`

**Verificações Realizadas:**
- ✅ Arquivo Nginx existe em produção
- ❌ **NÃO existe location específico** para `placa-validate.php` em produção
- ❌ `placa-validate.php` está usando o **location geral** `location ~ \.php$`
- ❌ O location geral **adiciona headers CORS do Nginx**:

```nginx
add_header 'Access-Control-Allow-Origin' '$http_origin' always;
add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
add_header 'Access-Control-Allow-Headers' 'Content-Type, X-Webflow-Signature, X-Webflow-Timestamp' always;
add_header 'Access-Control-Allow-Credentials' 'true' always;
```

**Resultado:**
- Nginx adiciona: `Access-Control-Allow-Origin: https://www.segurosimediato.com.br`
- PHP adiciona: `Access-Control-Allow-Origin: https://www.segurosimediato.com.br`
- **Total:** Header duplicado → Erro CORS

---

### **3. Comparação com Ambiente DEV**

#### **3.1. Ambiente DEV (Correto)**

**Configuração Nginx DEV:**
```nginx
# Location específico para placa-validate.php (SEM headers CORS - PHP faz com validação)
# Deve vir ANTES do location geral para ter prioridade
location = /placa-validate.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    # NÃO adicionar headers CORS aqui - o PHP fará com validação via setCorsHeaders()
}
```

**Resultado em DEV:**
- ✅ Location específico existe
- ✅ Nginx **NÃO adiciona** headers CORS
- ✅ PHP adiciona headers CORS via `setCorsHeaders()`
- ✅ **Sem duplicação** → Funciona corretamente

#### **3.2. Ambiente PROD (Problema)**

**Configuração Nginx PROD:**
- ❌ **NÃO existe** location específico para `placa-validate.php`
- ❌ `placa-validate.php` usa location geral `location ~ \.php$`
- ❌ Location geral **adiciona** headers CORS do Nginx

**Resultado em PROD:**
- ❌ Nginx adiciona headers CORS
- ❌ PHP adiciona headers CORS
- ❌ **Duplicação** → Erro CORS

---

## 🔧 CAUSA RAIZ CONFIRMADA

### **Problema:**

A configuração do Nginx em **produção** não tem o location específico para `placa-validate.php`, fazendo com que ele use o location geral que adiciona headers CORS. Isso causa duplicação com os headers CORS enviados pelo PHP via `setCorsHeaders()`.

### **Solução Necessária:**

Adicionar location específico para `placa-validate.php` no Nginx de produção, seguindo o mesmo padrão do ambiente DEV:
- Location específico **SEM headers CORS do Nginx**
- PHP controla CORS via `setCorsHeaders()`
- Evita duplicação de headers

---

## 📋 VERIFICAÇÕES ADICIONAIS NECESSÁRIAS

### **1. Verificar Configuração Nginx Completa em PROD**

**Ação:**
- Verificar se existe location específico para `cpf-validate.php` em produção
- Verificar se outros endpoints têm locations específicos
- Comparar configuração PROD com DEV

### **2. Verificar se Mesmo Problema Acontece com cpf-validate.php**

**Ação:**
- Testar `cpf-validate.php` em produção
- Verificar se também tem erro de CORS duplicado
- Se sim, aplicar mesma solução

---

## 🎯 CONCLUSÃO

### **Causa Raiz:**

O erro de CORS duplicado em `placa-validate.php` em produção ocorre porque:

1. ✅ **Arquivo PHP está correto:** Usa `setCorsHeaders()` corretamente
2. ❌ **Nginx PROD não tem location específico:** `placa-validate.php` usa location geral
3. ❌ **Location geral adiciona headers CORS:** Causa duplicação com PHP
4. ❌ **Resultado:** Header `Access-Control-Allow-Origin` enviado duas vezes

### **Solução:**

Adicionar location específico para `placa-validate.php` no Nginx de produção, seguindo o padrão do ambiente DEV:
- Location específico **ANTES** do location geral
- **SEM headers CORS** do Nginx
- PHP controla CORS via `setCorsHeaders()`

---

## 📝 PRÓXIMOS PASSOS

1. ✅ **Verificar configuração Nginx completa em PROD**
2. ✅ **Verificar se `cpf-validate.php` tem mesmo problema**
3. ⏭️ **Aguardar autorização** para implementar correção
4. ⏭️ **Adicionar locations específicos** no Nginx PROD (se autorizado)

---

**Data de Análise:** 16/11/2025  
**Análise Realizada por:** Sistema Automatizado  
**Status:** 🔍 **ANÁLISE COMPLETA - CAUSA RAIZ IDENTIFICADA: FALTA DE LOCATION ESPECÍFICO NO NGINX PROD**

