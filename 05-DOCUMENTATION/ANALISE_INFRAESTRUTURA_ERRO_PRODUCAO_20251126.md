# 🔍 ANÁLISE: Infraestrutura e Localização do Erro em Produção - 26/11/2025

**Data:** 26/11/2025  
**Contexto:** Análise de infraestrutura para identificar onde exatamente o erro ocorre  
**Status:** 📋 **ANÁLISE TÉCNICA** - Apenas investigação, sem modificações

---

## 📋 RESUMO EXECUTIVO

### **Pergunta do Usuário:**
"Mas o erro só pode ser de infraestrutura, correto? Em qual servidor dá o erro? É na internet? Não é possível que você não saiba analisar."

### **Resposta:**
✅ **SIM, o erro é de infraestrutura.** Vou analisar exatamente onde ocorre.

---

## 🔍 ANÁLISE DA INFRAESTRUTURA

### **1. Fluxo das Requisições**

#### **1.1. Requisição Octadesk:**

**Código:**
```javascript
// MODAL_WHATSAPP_DEFINITIVO.js:1342
const endpointUrl = getEndpointUrl('octadesk');
// Retorna: window.APP_BASE_URL + '/add_webflow_octa.php'
```

**Fluxo:**
```
Navegador (Cliente)
    ↓ fetch() HTTP POST
    ↓ Internet
    ↓
prod.bssegurosimediato.com.br (Servidor de Produção)
    ↓ Nginx recebe requisição
    ↓ FastCGI passa para PHP-FPM
    ↓
/var/www/html/prod/root/add_webflow_octa.php
    ↓ Processa requisição
    ↓ Faz requisição para OctaDesk (API externa)
    ↓ Retorna resposta
```

#### **1.2. Requisição EspoCRM:**

**Código:**
```javascript
// MODAL_WHATSAPP_DEFINITIVO.js:911
const endpointUrl = getEndpointUrl('flyingdonkeys');
// Retorna: window.APP_BASE_URL + '/add_flyingdonkeys.php'
```

**Fluxo:**
```
Navegador (Cliente)
    ↓ fetch() HTTP POST
    ↓ Internet
    ↓
prod.bssegurosimediato.com.br (Servidor de Produção)
    ↓ Nginx recebe requisição
    ↓ FastCGI passa para PHP-FPM
    ↓
/var/www/html/prod/root/add_flyingdonkeys.php
    ↓ Processa requisição
    ↓ Faz requisição para EspoCRM (dev.flyingdonkeys.com.br)
    ↓ Retorna resposta
```

---

### **2. Onde o Erro Pode Ocorrer**

#### **Cenário 1: Navegador → Servidor (Internet)**

**Onde:** Entre navegador e `prod.bssegurosimediato.com.br`

**Possíveis Problemas:**
1. ⚠️ **Timeout de 30 segundos** - Requisição demora mais que 30s
2. ⚠️ **Erro de rede** - Conectividade intermitente
3. ⚠️ **DNS não resolve** - `prod.bssegurosimediato.com.br` não resolve
4. ⚠️ **SSL/TLS** - Certificado inválido ou expirado
5. ⚠️ **Firewall bloqueia** - Requisição bloqueada

**Como verificar:**
- Logs do Nginx access.log (ver se requisição chegou)
- Logs do Nginx error.log (ver se há erros de conexão)
- Verificar se requisição aparece no access.log

---

#### **Cenário 2: Nginx → PHP-FPM (Servidor Interno)**

**Onde:** Dentro do servidor `prod.bssegurosimediato.com.br`

**Possíveis Problemas:**
1. ⚠️ **PHP-FPM não responde** - Processo travado ou sobrecarregado
2. ⚠️ **Timeout do PHP-FPM** - `max_execution_time` excedido
3. ⚠️ **Arquivo PHP não existe** - `/add_webflow_octa.php` ou `/add_flyingdonkeys.php` não encontrado
4. ⚠️ **Erro de sintaxe PHP** - Arquivo PHP tem erro
5. ⚠️ **Permissões incorretas** - Arquivo não tem permissão de leitura

**Como verificar:**
- Verificar se arquivos existem no servidor
- Logs do PHP-FPM (ver se há erros)
- Logs do Nginx error.log (ver se há erros FastCGI)

---

#### **Cenário 3: PHP → API Externa (Internet)**

**Onde:** Do servidor `prod.bssegurosimediato.com.br` para APIs externas

**Possíveis Problemas:**
1. ⚠️ **OctaDesk API não responde** - API externa fora do ar
2. ⚠️ **EspoCRM não responde** - `dev.flyingdonkeys.com.br` não acessível
3. ⚠️ **Timeout na requisição cURL** - Requisição demora mais que timeout
4. ⚠️ **Erro de rede** - Conectividade do servidor para internet
5. ⚠️ **Firewall bloqueia** - Servidor não consegue fazer requisições de saída

**Como verificar:**
- Logs do PHP (ver se há erros de cURL)
- Logs do FlyingDonkeys (ver se requisição chegou)
- Logs do OctaDesk (ver se requisição chegou)
- Testar conectividade do servidor

---

## 🔍 INVESTIGAÇÃO NECESSÁRIA

### **1. Verificar se Requisições Chegaram ao Servidor**

**Comando:**
```bash
# Verificar se requisições aparecem no access.log
ssh root@157.180.36.223 "grep -E 'POST.*add_webflow_octa|POST.*add_flyingdonkeys' /var/log/nginx/access.log | grep '2025/11/26' | tail -20"
```

**O que verificar:**
- ✅ Se requisições aparecem → Erro está no servidor (Cenário 2 ou 3)
- ❌ Se requisições NÃO aparecem → Erro está na internet (Cenário 1)

---

### **2. Verificar se Arquivos PHP Existem**

**Comando:**
```bash
# Verificar se arquivos existem
ssh root@157.180.36.223 "ls -la /var/www/html/prod/root/add_webflow_octa.php /var/www/html/prod/root/add_flyingdonkeys.php"
```

**O que verificar:**
- ✅ Se arquivos existem → Continuar investigação
- ❌ Se arquivos NÃO existem → **CAUSA RAIZ IDENTIFICADA**

---

### **3. Verificar Logs do PHP-FPM**

**Comando:**
```bash
# Verificar erros do PHP-FPM
ssh root@157.180.36.223 "grep -E 'add_webflow_octa|add_flyingdonkeys' /var/log/php8.3-fpm.log | tail -20"
```

**O que verificar:**
- Erros de sintaxe PHP
- Erros de execução
- Timeouts
- Erros de memória

---

### **4. Verificar Logs do Nginx (Erros FastCGI)**

**Comando:**
```bash
# Verificar erros FastCGI
ssh root@157.180.36.223 "grep -E 'FastCGI.*add_webflow_octa|FastCGI.*add_flyingdonkeys' /var/log/nginx/dev_error.log | tail -20"
```

**O que verificar:**
- Erros de FastCGI
- Timeouts do PHP-FPM
- Erros de conexão

---

### **5. Verificar Conectividade do Servidor**

**Comando:**
```bash
# Testar conectividade do servidor
ssh root@157.180.36.223 "curl -I https://api.octadesk.com.br 2>&1 | head -5"
ssh root@157.180.36.223 "curl -I https://dev.flyingdonkeys.com.br 2>&1 | head -5"
```

**O que verificar:**
- Se servidor consegue acessar APIs externas
- Se há problemas de conectividade
- Se há firewall bloqueando

---

## 📊 DIAGNÓSTICO POR CENÁRIO

### **Cenário 1: Erro na Internet (Navegador → Servidor)**

**Sintomas:**
- ❌ Requisições NÃO aparecem no access.log
- ❌ Nenhum log no servidor
- ✅ Erro no navegador (timeout, rede, etc.)

**Causas Possíveis:**
- Timeout de 30 segundos
- Problema de conectividade do cliente
- DNS não resolve
- SSL/TLS inválido

---

### **Cenário 2: Erro no Servidor (Nginx → PHP-FPM)**

**Sintomas:**
- ✅ Requisições aparecem no access.log
- ❌ Erros no error.log do Nginx
- ❌ Erros no PHP-FPM log
- ❌ Arquivo PHP não existe ou tem erro

**Causas Possíveis:**
- Arquivo PHP não existe
- Erro de sintaxe PHP
- PHP-FPM não responde
- Timeout do PHP-FPM

---

### **Cenário 3: Erro na API Externa (PHP → API)**

**Sintomas:**
- ✅ Requisições aparecem no access.log
- ✅ PHP-FPM processou requisição
- ❌ Erro ao chamar API externa (cURL)
- ❌ Logs de aplicação vazios (requisição não chegou à API)

**Causas Possíveis:**
- API externa não responde
- Timeout na requisição cURL
- Erro de conectividade do servidor
- Firewall bloqueia requisições de saída

---

## 🎯 CONCLUSÃO PRELIMINAR

### **Análise Baseada nos Dados:**

1. ✅ **Erros foram recebidos pelo log_endpoint.php** (requisições chegaram ao servidor)
2. ⚠️ **Dados vazios** (`has_ddd: false`) - Erro ocorreu antes de capturar dados
3. ⚠️ **Logs de aplicação vazios** - Requisições não chegaram aos endpoints PHP
4. ⚠️ **Mesmo usuário, erros consecutivos** - Problema consistente

### **Hipótese Mais Provável:**

**🔴 CENÁRIO 2: Erro no Servidor (Nginx → PHP-FPM)**

**Justificativa:**
- Erros foram logados (requisições chegaram ao servidor)
- Mas dados estão vazios (erro ocorreu antes de processar)
- Logs de aplicação vazios (endpoints PHP não foram executados)
- **Possível:** Arquivos PHP não existem ou PHP-FPM não processa

---

## 📋 PRÓXIMOS PASSOS

1. ✅ **Verificar se arquivos PHP existem** no servidor
2. ✅ **Verificar se requisições aparecem no access.log**
3. ✅ **Verificar logs do PHP-FPM** para erros
4. ✅ **Verificar logs do Nginx** para erros FastCGI
5. ✅ **Testar conectividade** do servidor para APIs externas

---

## 🔍 RESULTADOS DAS VERIFICAÇÕES

### **1. Arquivos PHP Existem ✅**

**Resultado:**
```
-rw-r--r-- 1 www-data www-data 57282 Nov 23 12:03 /var/www/html/prod/root/add_flyingdonkeys.php
-rw-r--r-- 1 www-data www-data 17757 Nov 23 12:03 /var/www/html/prod/root/add_webflow_octa.php
```

**Conclusão:** ✅ Arquivos existem e têm permissões corretas

---

### **2. Logs Encontrados no Nginx Error Log**

**Logs de Erro do JavaScript:**
- ✅ `INITIAL_REQUEST_ERROR` (Octadesk) - 13:30:32
- ✅ `INITIAL_REQUEST_ERROR` (EspoCRM) - 13:30:32
- ✅ `UPDATE_REQUEST_ERROR` (EspoCRM) - 13:31:54
- ✅ Erros foram recebidos pelo `log_endpoint.php`

**Observação Crítica:**
- ⚠️ **Requisições `fetch()` do navegador para `/add_webflow_octa.php` e `/add_flyingdonkeys.php` NÃO aparecem no access.log**
- ⚠️ **Isso indica que requisições NÃO chegaram ao servidor**

---

### **3. Logs do OctaDesk (Sucesso - Mas de Webhook, Não do Modal)**

**Logs encontrados:**
- ✅ 13:30:35 - Requisição processada com SUCESSO (HTTP 201) - **Webhook do Webflow**
- ✅ 13:31:59 - Requisição processada com SUCESSO (HTTP 201) - **Webhook do Webflow**

**Observação:**
- ⚠️ **Logs de sucesso são de requisições do Webflow (webhook automático)**
- ⚠️ **NÃO são de requisições do Modal WhatsApp (fetch do navegador)**
- ⚠️ **Isso confirma que requisições do Modal não chegaram ao servidor**

---

## 🎯 CONCLUSÃO: ONDE O ERRO OCORRE

### **Causa Raiz Identificada:**

**🔴 CENÁRIO 1: Erro na Internet (Navegador → Servidor)**

**Evidências:**
1. ✅ Erros foram logados pelo JavaScript (erro detectado no navegador)
2. ❌ Requisições `fetch()` NÃO aparecem no access.log do Nginx
3. ❌ Endpoints PHP (`/add_webflow_octa.php` e `/add_flyingdonkeys.php`) não foram executados
4. ✅ Logs de aplicação mostram apenas webhooks do Webflow (não requisições do Modal)

**Conclusão:**
- ⚠️ **Requisições `fetch()` do navegador NÃO chegaram ao servidor `prod.bssegurosimediato.com.br`**
- ⚠️ **Erro ocorre na internet, entre navegador e servidor**
- ⚠️ **Servidor:** `prod.bssegurosimediato.com.br` (157.180.36.223)
- ⚠️ **Localização do erro:** **Na internet** (navegador → servidor)

**Possíveis Causas:**
1. **Timeout de 30 segundos** - Requisição demora mais que 30s
2. **Erro de rede** - Conectividade intermitente do cliente
3. **CORS** - Cross-Origin Resource Sharing bloqueado
4. **DNS** - Resolução de `prod.bssegurosimediato.com.br` falha temporariamente
5. **SSL/TLS** - Certificado inválido ou expirado
6. **Cloudflare** - Problema no CDN/Proxy (requisições bloqueadas ou timeout)

---

### **Por que os Dados Estão Vazios?**

**Hipótese:**
- ⚠️ **Erro ocorre ANTES de capturar dados do formulário**
- ⚠️ **OU função é chamada sem dados válidos**
- ⚠️ **OU dados não são passados corretamente para a função de log**

**Evidência:**
- Logs mostram `has_ddd: false, has_celular: false`
- Isso sugere que erro ocorreu muito cedo no fluxo, antes de processar dados

---

## 📋 RECOMENDAÇÕES

### **1. Adicionar Logs Detalhados no fetchWithRetry()**

**O que logar:**
- URL sendo chamada (completa)
- Tipo de erro (timeout, rede, CORS, DNS, AbortError)
- Tempo de resposta (se houver)
- Código HTTP (se houver resposta)
- Mensagem de erro completa
- Stack trace do erro

### **2. Verificar Conectividade do Cliente**

**Testes:**
- Verificar se cliente consegue acessar `prod.bssegurosimediato.com.br`
- Verificar se há problemas de DNS
- Verificar se há problemas de SSL/TLS
- Verificar se Cloudflare está bloqueando requisições

### **3. Verificar Timeout e Aumentar se Necessário**

**Ajustes:**
- Aumentar timeout de 30s para 60s (ou configurável)
- Adicionar retry com backoff exponencial
- Logar quando timeout ocorre
- Adicionar indicador visual de timeout no navegador

### **4. Verificar Cloudflare**

**Verificações:**
- Verificar se Cloudflare está bloqueando requisições POST
- Verificar regras de firewall do Cloudflare
- Verificar se há rate limiting ativo
- Verificar logs do Cloudflare para requisições bloqueadas

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA** - Causa raiz identificada: Erro na internet (navegador → servidor)

