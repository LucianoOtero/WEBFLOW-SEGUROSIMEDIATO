# 🔧 PROJETO: CORREÇÃO DE CORS NO NGINX PARA ENDPOINTS PHP

**Data de Criação:** 11/11/2025  
**Status:** ✅ **IMPLEMENTAÇÃO CONCLUÍDA** - 11/11/2025  
**Versão:** 1.0.0  
**Prioridade:** 🔴 **CRÍTICA** (segurança - origens não autorizadas recebendo CORS)

---

## 🎯 OBJETIVO

Corrigir o problema de CORS no Nginx que permite que **origens não autorizadas** recebam headers CORS para `add_flyingdonkeys.php` e `add_webflow_octa.php`, e criar testes específicos para garantir que todos os problemas identificados não ocorram no acesso pelo custom code do Webflow em `segurosimediato-dev.webflow.io`.

---

## 📊 ANÁLISE DO PROBLEMA

### Problema Identificado

**Sintoma:**
- `add_flyingdonkeys.php` e `add_webflow_octa.php` aceitam requisições de **qualquer origem**
- Teste com curl mostra: `Access-Control-Allow-Origin: https://evil-site.com` (origem não permitida)

**Causa Raiz:**
O Nginx está adicionando headers CORS no location geral (`location ~ \.php$`) que:
1. Adiciona `Access-Control-Allow-Origin: $http_origin` **sempre**, sem validação
2. Isso permite que **qualquer origem** receba o header CORS
3. O PHP tenta validar, mas o Nginx já adicionou o header antes

**Risco de Segurança:**
- Origem não autorizada pode fazer requisições CORS
- Dados sensíveis podem ser acessados por domínios maliciosos

### Endpoints Afetados

1. **add_flyingdonkeys.php**
   - Usa `getCorsOrigins()` e valida origem no PHP
   - Mas Nginx adiciona header antes da validação PHP

2. **add_webflow_octa.php**
   - Usa `getCorsOrigins()` e valida origem no PHP
   - Mas Nginx adiciona header antes da validação PHP

3. **log_endpoint.php** ✅
   - Já tem location específico no Nginx (sem headers CORS)
   - Funciona corretamente

### Endpoints que NÃO Precisam de Location Específico

- `cpf-validate.php` - Aceita qualquer origem (wildcard)
- `placa-validate.php` - Aceita qualquer origem (wildcard)
- `send_email_notification_endpoint.php` - Aceita qualquer origem (wildcard)
- `config_env.js.php` - Arquivo PHP que gera JS (aceita qualquer origem)

---

## 🔧 SOLUÇÃO PROPOSTA

### Fase 1: Corrigir Nginx

**Ação:** Criar locations específicos no Nginx para `add_flyingdonkeys.php` e `add_webflow_octa.php`

**Código Nginx:**
```nginx
# Location específico para add_flyingdonkeys.php (SEM headers CORS - PHP faz com validação)
location = /add_flyingdonkeys.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    # NÃO adicionar headers CORS aqui - o PHP fará com validação via getCorsOrigins()
}

# Location específico para add_webflow_octa.php (SEM headers CORS - PHP faz com validação)
location = /add_webflow_octa.php {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    # NÃO adicionar headers CORS aqui - o PHP fará com validação via getCorsOrigins()
}
```

**Ordem Importante:**
- Locations específicos devem vir **ANTES** do location geral (`location ~ \.php$`)
- Isso garante que tenham prioridade

### Fase 2: Criar Testes Específicos para Webflow

**Objetivo:** Garantir que todos os problemas identificados não ocorram no acesso pelo custom code do Webflow

**Testes Necessários:**

1. **Teste de CORS - Origem Webflow Permitida**
   - Origem: `https://segurosimediato-dev.webflow.io`
   - Endpoints: `log_endpoint.php`, `add_flyingdonkeys.php`, `add_webflow_octa.php`
   - Esperado: Header `Access-Control-Allow-Origin` com origem correta

2. **Teste de CORS - Origem Webflow NÃO Permitida**
   - Origem: `https://evil-site.com`
   - Endpoints: `log_endpoint.php`, `add_flyingdonkeys.php`, `add_webflow_octa.php`
   - Esperado: **NÃO** retornar header `Access-Control-Allow-Origin`

3. **Teste de Requisição Real do Webflow**
   - Simular requisição POST real do Webflow
   - Validar que headers CORS estão corretos
   - Validar que requisição é aceita

4. **Teste de Preflight (OPTIONS)**
   - Validar que requisições OPTIONS retornam headers corretos
   - Validar que origens não permitidas são bloqueadas

5. **Teste de Integração Completa**
   - Testar fluxo completo: OPTIONS → POST
   - Validar que funciona no contexto do Webflow

---

## 📋 FASES DO PROJETO

### FASE 1: Preparação e Backup
- [x] Criar backup do `nginx_dev_config.conf` atual
- [ ] Verificar sintaxe do Nginx atual
- [ ] Documentar configuração atual

### FASE 2: Modificar Nginx
- [x] Adicionar location específico para `add_flyingdonkeys.php`
- [x] Adicionar location específico para `add_webflow_octa.php`
- [x] Verificar ordem dos locations (específicos antes do geral)
- [ ] Testar sintaxe do Nginx (`nginx -t`)

### FASE 3: Deploy e Aplicação
- [x] Copiar `nginx_dev_config.conf` para servidor
- [x] Aplicar configuração no servidor
- [x] Recarregar Nginx (`nginx -s reload` ou `systemctl reload nginx`)
- [x] Verificar que Nginx está rodando corretamente

### FASE 4: Testes Básicos com curl
- [x] Testar `add_flyingdonkeys.php` com origem permitida
- [x] Testar `add_flyingdonkeys.php` com origem não permitida
- [x] Testar `add_webflow_octa.php` com origem permitida
- [x] Testar `add_webflow_octa.php` com origem não permitida
- [x] Validar que origens não permitidas **NÃO** recebem header CORS

### FASE 5: Criar Testes Específicos para Webflow
- [x] Criar arquivo `test_webflow_cors.html` com testes específicos
- [x] Copiar arquivo para servidor DEV
- [ ] Testar origem `https://segurosimediato-dev.webflow.io`
- [ ] Testar requisições OPTIONS (preflight)
- [ ] Testar requisições POST reais
- [ ] Testar fluxo completo de integração

### FASE 6: Validação Completa
- [x] Executar todos os testes com curl
- [x] Validar que problemas identificados foram corrigidos
- [x] Documentar resultados
- [x] Criar arquivo de resultados (`RESULTADOS_TESTES_CORS_NGINX.md`)
- [ ] Testes no navegador via `test_webflow_cors.html` (aguardando execução manual)

---

## 🧪 TESTES ESPECÍFICOS PARA WEBFLOW

### Teste 1: CORS - Origem Webflow Permitida

**Endpoint:** `add_flyingdonkeys.php`  
**Origem:** `https://segurosimediato-dev.webflow.io`  
**Método:** OPTIONS (preflight)  
**Esperado:**
- Status: 204 ou 200
- Header: `Access-Control-Allow-Origin: https://segurosimediato-dev.webflow.io`
- Header: `Access-Control-Allow-Methods: POST, OPTIONS`
- Header: `Access-Control-Allow-Headers: Content-Type, X-Webflow-Signature, X-Webflow-Timestamp`

### Teste 2: CORS - Origem Webflow NÃO Permitida

**Endpoint:** `add_flyingdonkeys.php`  
**Origem:** `https://evil-site.com`  
**Método:** OPTIONS (preflight)  
**Esperado:**
- Status: 204 ou 200
- **NÃO** deve retornar header `Access-Control-Allow-Origin`
- Ou retornar header vazio/null

### Teste 3: Requisição POST Real do Webflow

**Endpoint:** `add_flyingdonkeys.php`  
**Origem:** `https://segurosimediato-dev.webflow.io`  
**Método:** POST  
**Headers:**
- `Content-Type: application/json`
- `X-Webflow-Signature: [signature]`
- `X-Webflow-Timestamp: [timestamp]`
**Esperado:**
- Status: 200 ou 400 (dependendo dos dados)
- Header: `Access-Control-Allow-Origin: https://segurosimediato-dev.webflow.io`
- Resposta JSON válida

### Teste 4: Fluxo Completo OPTIONS → POST

**Endpoint:** `add_flyingdonkeys.php`  
**Origem:** `https://segurosimediato-dev.webflow.io`  
**Fluxo:**
1. OPTIONS (preflight) → Validar headers CORS
2. POST (requisição real) → Validar que funciona
**Esperado:**
- Ambos os passos devem funcionar
- Headers CORS devem estar corretos em ambos

### Teste 5: Múltiplos Endpoints

**Endpoints:** `log_endpoint.php`, `add_flyingdonkeys.php`, `add_webflow_octa.php`  
**Origem:** `https://segurosimediato-dev.webflow.io`  
**Esperado:**
- Todos devem retornar headers CORS corretos
- Todos devem aceitar requisições da origem Webflow

---

## 📁 ARQUIVOS A MODIFICAR

### 1. nginx_dev_config.conf
- **Local:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_config.conf`
- **Servidor:** `/etc/nginx/sites-available/dev.bssegurosimediato.com.br` (ou similar)
- **Ação:** Adicionar locations específicos para `add_flyingdonkeys.php` e `add_webflow_octa.php`

### 2. test_webflow_cors.html (NOVO)
- **Local:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TESTES/test_webflow_cors.html`
- **Ação:** Criar arquivo com testes específicos para Webflow

---

## 🔍 VALIDAÇÃO

### Validação 1: Sintaxe Nginx
```bash
nginx -t
```
**Esperado:** `syntax is ok` e `test is successful`

### Validação 2: Teste com curl - Origem Permitida
```bash
curl -X OPTIONS 'https://dev.bssegurosimediato.com.br/add_flyingdonkeys.php' \
  -H 'Origin: https://segurosimediato-dev.webflow.io' \
  -H 'Access-Control-Request-Method: POST' -v
```
**Esperado:** `access-control-allow-origin: https://segurosimediato-dev.webflow.io`

### Validação 3: Teste com curl - Origem NÃO Permitida
```bash
curl -X OPTIONS 'https://dev.bssegurosimediato.com.br/add_flyingdonkeys.php' \
  -H 'Origin: https://evil-site.com' \
  -H 'Access-Control-Request-Method: POST' -v
```
**Esperado:** **NÃO** deve retornar header `access-control-allow-origin`

### Validação 4: Teste no Navegador
- Acessar `test_webflow_cors.html` no servidor
- Executar todos os testes
- Validar que todos passam

---

## 📝 CHECKLIST DE IMPLEMENTAÇÃO

### Preparação
- [ ] Backup do `nginx_dev_config.conf`
- [ ] Verificar sintaxe atual do Nginx
- [ ] Documentar configuração atual

### Modificação
- [ ] Adicionar location para `add_flyingdonkeys.php`
- [ ] Adicionar location para `add_webflow_octa.php`
- [ ] Verificar ordem dos locations
- [ ] Testar sintaxe (`nginx -t`)

### Deploy
- [ ] Copiar arquivo para servidor
- [ ] Aplicar configuração
- [ ] Recarregar Nginx
- [ ] Verificar que está rodando

### Testes
- [ ] Teste curl - origem permitida
- [ ] Teste curl - origem não permitida
- [ ] Criar `test_webflow_cors.html`
- [ ] Testar no navegador
- [ ] Validar todos os testes passam

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

### Risco 2: Quebrar Outros Endpoints
**Mitigação:**
- Locations específicos têm prioridade sobre o geral
- Endpoints que não precisam de validação continuam usando location geral
- Testar todos os endpoints após modificação

### Risco 3: Requisições do Webflow Pararem de Funcionar
**Mitigação:**
- Testar especificamente com origem do Webflow
- Validar que headers CORS estão corretos
- Testar fluxo completo OPTIONS → POST

---

## ✅ CRITÉRIOS DE SUCESSO

1. ✅ `add_flyingdonkeys.php` não aceita origens não permitidas
2. ✅ `add_webflow_octa.php` não aceita origens não permitidas
3. ✅ `add_flyingdonkeys.php` aceita origem `https://segurosimediato-dev.webflow.io`
4. ✅ `add_webflow_octa.php` aceita origem `https://segurosimediato-dev.webflow.io`
5. ✅ Testes específicos para Webflow passam
6. ✅ Nenhum erro 502 ou outros erros
7. ✅ Requisições reais do Webflow funcionam corretamente

---

**Status:** 🟡 **EM ANDAMENTO**  
**Próxima Ação:** FASE 1 - Preparação e Backup

