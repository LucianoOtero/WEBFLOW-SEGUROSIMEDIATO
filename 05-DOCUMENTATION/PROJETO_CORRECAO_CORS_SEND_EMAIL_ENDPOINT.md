# 🔧 PROJETO: CORREÇÃO DE CORS NO send_email_notification_endpoint.php

**Data de Criação:** 11/11/2025  
**Status:** ✅ **IMPLEMENTAÇÃO CONCLUÍDA** - 11/11/2025  
**Versão:** 1.0.0  
**Prioridade:** 🔴 **CRÍTICA** (bloqueia envio de notificações por email)

---

## 🎯 OBJETIVO

Corrigir o erro de CORS no `send_email_notification_endpoint.php` que está causando falha nas requisições de notificação por email do JavaScript.

**Erro Identificado:**
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

### Solução

Seguir o mesmo padrão usado para `log_endpoint.php`, `add_flyingdonkeys.php` e `add_webflow_octa.php`:

1. **Criar location específico no Nginx** (sem headers CORS do Nginx)
2. **Modificar PHP para usar `setCorsHeaders()`** do `config.php` (valida origem)

---

## 📋 FASES DO PROJETO

### FASE 1: Preparação e Backup
- [x] Criar backup do `send_email_notification_endpoint.php` atual
- [x] Criar backup do `nginx_dev_config.conf` atual
- [x] Verificar sintaxe do Nginx atual
- [x] Documentar configuração atual

### FASE 2: Modificar Nginx
- [x] Adicionar location específico para `send_email_notification_endpoint.php`
- [x] Remover headers CORS do Nginx neste location
- [x] Verificar ordem dos locations (específicos antes do geral)
- [x] Testar sintaxe do Nginx (`nginx -t`)

### FASE 3: Modificar PHP
- [x] Incluir `config.php` no início do arquivo (ANTES de qualquer header)
- [x] Substituir `header('Access-Control-Allow-Origin: *')` por `setCorsHeaders()`
- [x] Manter outros headers CORS (métodos, headers permitidos)
- [x] Atualizar versão do arquivo (1.2)

### FASE 4: Deploy e Aplicação
- [x] Copiar `nginx_dev_config.conf` para servidor
- [x] Copiar `send_email_notification_endpoint.php` para servidor
- [x] Aplicar configuração no servidor
- [x] Recarregar Nginx (`nginx -s reload` ou `systemctl reload nginx`)
- [x] Verificar que Nginx está rodando corretamente

### FASE 5: Testes e Validação
- [x] Testar com curl - origem permitida
- [x] Testar com curl - origem não permitida
- [x] Validar que origens não permitidas **NÃO** recebem header CORS
- [ ] Testar requisição POST real do Webflow (aguardando teste manual)
- [ ] Verificar que email é enviado corretamente (aguardando teste manual)

---

## 🔧 DETALHAMENTO TÉCNICO

### Arquivos a Modificar

#### 1. nginx_dev_config.conf
- **Local:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_config.conf`
- **Servidor:** `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`
- **Ação:** Adicionar location específico para `send_email_notification_endpoint.php`

#### 2. send_email_notification_endpoint.php
- **Local:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_email_notification_endpoint.php`
- **Servidor:** `/var/www/html/dev/root/send_email_notification_endpoint.php`
- **Ação:** Substituir headers CORS hardcoded por `setCorsHeaders()`

### Código ANTES (INCORRETO)

**send_email_notification_endpoint.php:**
```php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');  // ❌ PROBLEMA: Conflita com Nginx
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Tratar OPTIONS (preflight CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}
```

**nginx_dev_config.conf:**
```nginx
# Location geral para outros arquivos PHP (COM headers CORS do Nginx)
location ~ \.php$ {
    ...
    add_header 'Access-Control-Allow-Origin' '$http_origin' always;  // ❌ PROBLEMA: Conflita com PHP
    ...
}
```

### Código DEPOIS (CORRETO)

**send_email_notification_endpoint.php:**
```php
// Incluir config.php ANTES de qualquer header ou output
require_once __DIR__ . '/config.php';

// Headers CORS (usar função do config.php para evitar duplicação com Nginx)
// IMPORTANTE: Headers devem ser enviados ANTES de qualquer output
header('Content-Type: application/json; charset=utf-8');
// Usar setCorsHeaders() do config.php - valida origem e envia apenas um valor no header
setCorsHeaders();
// Adicionar headers específicos do send_email_notification_endpoint.php após setCorsHeaders()
header('Access-Control-Allow-Headers: Content-Type');

// Nota: setCorsHeaders() já trata requisições OPTIONS (preflight) e envia os headers corretos
// Não é necessário código adicional para OPTIONS
```

**nginx_dev_config.conf:**
```nginx
# Location específico para send_email_notification_endpoint.php (SEM headers CORS - PHP faz com validação)
# Deve vir ANTES do location geral para ter prioridade
location = /send_email_notification_endpoint.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    # NÃO adicionar headers CORS aqui - o PHP fará com validação via setCorsHeaders()
}

# Location geral para outros arquivos PHP (COM headers CORS do Nginx)
location ~ \.php$ {
    ...
}
```

---

## 🔍 VALIDAÇÃO

### Validação 1: Sintaxe Nginx
```bash
nginx -t
```
**Esperado:** `syntax is ok` e `test is successful`

### Validação 2: Teste com curl - Origem Permitida
```bash
curl -X OPTIONS 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php' \
  -H 'Origin: https://segurosimediato-dev.webflow.io' \
  -H 'Access-Control-Request-Method: POST' -v
```
**Esperado:** `access-control-allow-origin: https://segurosimediato-dev.webflow.io`

### Validação 3: Teste com curl - Origem NÃO Permitida
```bash
curl -X OPTIONS 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php' \
  -H 'Origin: https://evil-site.com' \
  -H 'Access-Control-Request-Method: POST' -v
```
**Esperado:** **NÃO** deve retornar header `access-control-allow-origin`

### Validação 4: Teste POST Real
```bash
curl -X POST 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php' \
  -H 'Origin: https://segurosimediato-dev.webflow.io' \
  -H 'Content-Type: application/json' \
  -d '{"ddd":"11","celular":"999999999","nome":"Teste"}' -v
```
**Esperado:** 
- Status: 200
- Header: `access-control-allow-origin: https://segurosimediato-dev.webflow.io`
- Resposta JSON válida

---

## 📝 CHECKLIST DE IMPLEMENTAÇÃO

### Preparação
- [ ] Backup do `send_email_notification_endpoint.php`
- [ ] Backup do `nginx_dev_config.conf`
- [ ] Verificar sintaxe atual do Nginx
- [ ] Documentar configuração atual

### Modificação
- [ ] Adicionar location para `send_email_notification_endpoint.php` no Nginx
- [ ] Incluir `config.php` no início do PHP
- [ ] Substituir `header('Access-Control-Allow-Origin: *')` por `setCorsHeaders()`
- [ ] Remover código de tratamento OPTIONS (já tratado por `setCorsHeaders()`)
- [ ] Atualizar versão do arquivo
- [ ] Testar sintaxe (`nginx -t`)

### Deploy
- [ ] Copiar arquivos para servidor
- [ ] Aplicar configuração
- [ ] Recarregar Nginx
- [ ] Verificar que está rodando

### Testes
- [ ] Teste curl - origem permitida
- [ ] Teste curl - origem não permitida
- [ ] Teste POST real
- [ ] Validar que email é enviado
- [ ] Testar no navegador

### Documentação
- [ ] Atualizar documentação
- [ ] Registrar resultados
- [ ] Atualizar status do projeto

---

## 🚨 RISCOS E MITIGAÇÕES

### Risco 1: Nginx Parar de Funcionar
**Mitigação:**
- Testar sintaxe antes de aplicar (`nginx -t`)
- Fazer backup antes de modificar
- Ter acesso SSH para reverter se necessário

### Risco 2: Quebrar Envio de Emails
**Mitigação:**
- Manter lógica de envio de email inalterada
- Apenas modificar headers CORS
- Testar envio de email após correção

### Risco 3: Requisições do Webflow Pararem de Funcionar
**Mitigação:**
- Testar especificamente com origem do Webflow
- Validar que headers CORS estão corretos
- Testar fluxo completo de envio de email

---

## ✅ CRITÉRIOS DE SUCESSO

1. ✅ `send_email_notification_endpoint.php` não aceita origens não permitidas
2. ✅ `send_email_notification_endpoint.php` aceita origem `https://segurosimediato-dev.webflow.io`
3. ✅ Nenhum erro de CORS no navegador
4. ✅ Emails são enviados corretamente
5. ✅ Nenhum erro 502 ou outros erros
6. ✅ Requisições reais do Webflow funcionam corretamente

---

**Status:** 🟡 **EM ANDAMENTO**  
**Próxima Ação:** FASE 1 - Preparação e Backup

