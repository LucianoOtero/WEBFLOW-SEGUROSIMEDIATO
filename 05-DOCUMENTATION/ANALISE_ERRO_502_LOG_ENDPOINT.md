# 🔍 ANÁLISE: Erro 502 Bad Gateway no log_endpoint.php

**Data:** 11/11/2025  
**Status:** 🔍 **ANÁLISE CONCLUÍDA**  
**Prioridade:** 🔴 **CRÍTICA**

---

## 📊 ERRO IDENTIFICADO

### Erro no Console do Navegador
```
POST https://dev.bssegurosimediato.com.br/log_endpoint.php net::ERR_FAILED 502 (Bad Gateway)
```

### Erro nos Logs do Nginx
```
upstream sent too big header while reading response header from upstream
```

---

## 🔍 ANÁLISE DO PROBLEMA

### 1. Erro 502 Bad Gateway

**O que significa:**
- O Nginx está funcionando corretamente
- O Nginx não consegue se comunicar com o PHP-FPM OU
- O PHP-FPM está retornando uma resposta inválida

### 2. Erro "upstream sent too big header"

**O que significa:**
- O PHP-FPM está enviando headers HTTP muito grandes para o Nginx
- O Nginx tem um limite de tamanho de buffer para headers
- Quando os headers excedem esse limite, o Nginx retorna 502

**Limite padrão do Nginx:**
- `fastcgi_buffer_size`: 4KB ou 8KB (padrão)
- Headers maiores que isso causam o erro

---

## 🚨 CAUSA RAIZ IDENTIFICADA

### Problema: Output Antes dos Headers

**Código Atual (PROBLEMÁTICO):**
```php
// Linha 110-114: logDebug() ANTES dos headers
logDebug("Starting request", [
    'method' => $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN',
    'uri' => $_SERVER['REQUEST_URI'] ?? 'UNKNOWN',
    'ip' => $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN'
]);

// Linha 116: Headers enviados DEPOIS
header('Content-Type: application/json');
setCorsHeaders();
```

**Problema:**
1. `logDebug()` chama `error_log()` que pode gerar output
2. `error_log()` no PHP-FPM envia mensagens para stderr
3. Essas mensagens são capturadas pelo Nginx como parte da resposta
4. Se houver muitas mensagens de log, os headers ficam muito grandes
5. Nginx retorna 502: "upstream sent too big header"

**Evidência nos Logs:**
```
FastCGI sent in stderr: "PHP message: log_endpoint_debug: [2025-11-11 18:49:33.000000] Starting request | Memory: 2.097.152 bytes | Peak: 2.097.152 bytes | Data: {...}"
```

**Análise:**
- Os logs de debug estão sendo enviados via `error_log()` para stderr
- O Nginx captura stderr do PHP-FPM e inclui nas respostas
- Múltiplas chamadas de `logDebug()` geram muitas mensagens
- Isso aumenta o tamanho dos headers além do limite do Nginx

---

## 🔧 SOLUÇÕES POSSÍVEIS

### SOLUÇÃO 1: Mover logDebug() para DEPOIS dos Headers (RECOMENDADA)

**Vantagens:**
- Resolve o problema de "headers already sent"
- Mantém logging funcional
- Não requer mudanças no Nginx

**Implementação:**
```php
// Headers PRIMEIRO
header('Content-Type: application/json');
setCorsHeaders();
header('Access-Control-Allow-Headers: ...');

// Logging DEPOIS dos headers
logDebug("Starting request", [...]);
```

### SOLUÇÃO 2: Aumentar Buffer do Nginx

**Vantagens:**
- Não requer mudanças no código PHP
- Resolve o problema imediatamente

**Desvantagens:**
- Não resolve a causa raiz (output antes dos headers)
- Pode mascarar outros problemas

**Implementação:**
```nginx
location = /log_endpoint.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    
    # Aumentar buffers para headers grandes
    fastcgi_buffer_size 16k;
    fastcgi_buffers 4 16k;
    fastcgi_busy_buffers_size 32k;
}
```

### SOLUÇÃO 3: Desabilitar Captura de stderr no Nginx

**Vantagens:**
- Evita que logs apareçam nos headers
- Mantém logging funcional

**Desvantagens:**
- Perde visibilidade de erros do PHP no Nginx
- Não é recomendado para produção

---

## ✅ RECOMENDAÇÃO

**Implementar SOLUÇÃO 1 + SOLUÇÃO 2:**

1. **Mover `logDebug()` para depois dos headers** (corrige a causa raiz)
2. **Aumentar buffers do Nginx** (proteção adicional)

**Por quê:**
- Solução 1 corrige o problema fundamental (output antes de headers)
- Solução 2 adiciona proteção contra headers grandes no futuro
- Ambas são seguras e não causam efeitos colaterais

---

## 📋 ORDEM CORRETA DE EXECUÇÃO

### Ordem INCORRETA (Atual - Causa o Erro)
```php
1. require_once config.php
2. function logDebug() { ... }
3. logDebug("Starting request")  // ❌ Gera output antes dos headers
4. header('Content-Type: ...')   // ❌ Headers enviados depois do output
5. setCorsHeaders()
```

### Ordem CORRETA (Recomendada)
```php
1. require_once config.php
2. function logDebug() { ... }
3. header('Content-Type: ...')   // ✅ Headers PRIMEIRO
4. setCorsHeaders()               // ✅ Headers PRIMEIRO
5. header('Access-Control-Allow-Headers: ...')  // ✅ Headers PRIMEIRO
6. logDebug("Starting request")  // ✅ Logging DEPOIS dos headers
```

---

## 🔍 VERIFICAÇÃO ADICIONAL

### Sintaxe PHP
- ✅ **Verificado:** `php -l` não encontrou erros de sintaxe
- ✅ **Status:** Sintaxe PHP está correta

### PHP-FPM
- ✅ **Status:** PHP-FPM está rodando corretamente
- ✅ **Processos:** 3 processos ativos, 0 lentos

### Logs do Nginx
- ⚠️ **Problema:** Muitas mensagens de `log_endpoint_debug` sendo enviadas via stderr
- ⚠️ **Impacto:** Headers ficam muito grandes, causando 502

---

## 📝 PRÓXIMOS PASSOS

1. **Corrigir ordem de execução:**
   - Mover `logDebug("Starting request")` para DEPOIS dos headers
   - Garantir que todos os headers sejam enviados antes de qualquer output

2. **Aumentar buffers do Nginx:**
   - Adicionar configuração de buffers no location específico do `log_endpoint.php`

3. **Testar:**
   - Verificar que requisições funcionam sem erro 502
   - Verificar que logs ainda são gerados corretamente

---

**Status:** 🔍 **ANÁLISE CONCLUÍDA - AGUARDANDO CORREÇÃO**

