# 🔍 ANÁLISE: Erro CORS em send_email_notification_endpoint.php

**Data:** 11/11/2025  
**Status:** 🔍 **PROBLEMA IDENTIFICADO**

---

## 🚨 ERRO IDENTIFICADO

```
Access to fetch at 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php' 
from origin 'https://segurosimediato-dev.webflow.io' has been blocked by CORS policy: 
The 'Access-Control-Allow-Origin' header contains multiple values '*, https://segurosimediato-dev.webflow.io', 
but only one is allowed.
```

---

## 📊 ANÁLISE DO PROBLEMA

### Causa Raiz

O endpoint `send_email_notification_endpoint.php` está enviando **dois headers CORS diferentes**:

1. **PHP (linha 19):** `Access-Control-Allow-Origin: *`
2. **Nginx (location geral):** `Access-Control-Allow-Origin: $http_origin` (que se torna `https://segurosimediato-dev.webflow.io`)

**Resultado:** Múltiplos valores no header (não permitido pelo navegador)

### Código Atual (INCORRETO)

**send_email_notification_endpoint.php (linhas 18-21):**
```php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');  // ❌ PROBLEMA: Conflita com Nginx
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
```

**nginx_dev_config.conf (location geral):**
```nginx
location ~ \.php$ {
    ...
    add_header 'Access-Control-Allow-Origin' '$http_origin' always;  // ❌ PROBLEMA: Conflita com PHP
    ...
}
```

---

## ✅ VERIFICAÇÃO DOS LOGS

### add_flyingdonkeys.php e add_webflow_octa.php

**Logs do Nginx (access.log):**
```
172.71.238.206 - - [11/Nov/2025:19:52:06 +0000] "OPTIONS /add_flyingdonkeys.php HTTP/2.0" 200 0 
  "https://segurosimediato-dev.webflow.io/" "Mozilla/5.0..."
172.71.238.207 - - [11/Nov/2025:19:52:06 +0000] "OPTIONS /add_webflow_octa.php HTTP/2.0" 200 0 
  "https://segurosimediato-dev.webflow.io/" "Mozilla/5.0..."
172.71.238.206 - - [11/Nov/2025:19:52:06 +0000] "POST /add_flyingdonkeys.php HTTP/2.0" 200 544 
  "https://segurosimediato-dev.webflow.io/" "Mozilla/5.0..."
172.71.238.206 - - [11/Nov/2025:19:52:08 +0000] "POST /add_webflow_octa.php HTTP/2.0" 200 106 
  "https://segurosimediato-dev.webflow.io/" "Mozilla/5.0..."
```

**Status:** ✅ **FUNCIONANDO CORRETAMENTE**
- Requisições OPTIONS retornam 200
- Requisições POST retornam 200
- Origem: `https://segurosimediato-dev.webflow.io/` (correto)

**Conclusão:** As correções no Nginx para `add_flyingdonkeys.php` e `add_webflow_octa.php` estão funcionando perfeitamente!

---

### send_email_notification_endpoint.php

**Logs do Nginx (error.log):**
```
2025/11/11 19:52:09 [error] 319239#319239: *1099 FastCGI sent in stderr: 
  "PHP message: ✅ SES: Email enviado com sucesso..."
```

**Status:** ⚠️ **EMAIL ENVIADO COM SUCESSO, MAS CORS FALHANDO**
- O endpoint está processando a requisição corretamente
- O email está sendo enviado
- Mas o navegador bloqueia a resposta devido a múltiplos headers CORS

**Teste com curl:**
```bash
curl -X OPTIONS 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php' \
  -H 'Origin: https://segurosimediato-dev.webflow.io' \
  -H 'Access-Control-Request-Method: POST' -v
```

**Resultado:**
```
< HTTP/2 204 
< access-control-allow-origin: https://segurosimediato-dev.webflow.io
```

**Observação:** Com curl, apenas um header é retornado (do Nginx). Mas quando o PHP também adiciona um header, o navegador vê múltiplos valores.

---

## 🔧 SOLUÇÃO PROPOSTA

### Opção 1: Criar Location Específico no Nginx (RECOMENDADA)

**Vantagens:**
- Segue o mesmo padrão usado para `log_endpoint.php`, `add_flyingdonkeys.php` e `add_webflow_octa.php`
- Permite que PHP valide origem usando `setCorsHeaders()`
- Mantém consistência na configuração

**Ação:**
1. Adicionar location específico no Nginx para `send_email_notification_endpoint.php`
2. Modificar PHP para usar `setCorsHeaders()` em vez de `Access-Control-Allow-Origin: *`

### Opção 2: Remover Header CORS do PHP

**Vantagens:**
- Mais simples
- Deixa Nginx gerenciar CORS

**Desvantagens:**
- Nginx não valida origem (usa `$http_origin` sempre)
- Menos seguro

---

## 📋 PLANO DE CORREÇÃO

### FASE 1: Modificar Nginx
- [ ] Adicionar location específico para `send_email_notification_endpoint.php`
- [ ] Remover headers CORS do Nginx neste location
- [ ] Testar sintaxe do Nginx

### FASE 2: Modificar PHP
- [ ] Incluir `config.php` no início do arquivo
- [ ] Substituir `header('Access-Control-Allow-Origin: *')` por `setCorsHeaders()`
- [ ] Manter outros headers CORS (métodos, headers permitidos)

### FASE 3: Deploy e Testes
- [ ] Copiar arquivos para servidor
- [ ] Recarregar Nginx
- [ ] Testar com curl
- [ ] Testar no navegador

---

## ✅ CONCLUSÃO

1. **add_flyingdonkeys.php e add_webflow_octa.php:** ✅ **FUNCIONANDO CORRETAMENTE**
   - Logs confirmam requisições bem-sucedidas do Webflow
   - CORS funcionando perfeitamente

2. **send_email_notification_endpoint.php:** ❌ **REQUER CORREÇÃO**
   - Mesmo problema que tínhamos com `log_endpoint.php`
   - Múltiplos headers CORS sendo enviados
   - Solução: Criar location específico no Nginx + usar `setCorsHeaders()` no PHP

---

**Status:** 🔍 **ANÁLISE CONCLUÍDA - PRONTO PARA CORREÇÃO**

