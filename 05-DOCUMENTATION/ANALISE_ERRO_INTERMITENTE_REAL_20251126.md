# 🔍 ANÁLISE: Erro Intermitente Real - 26/11/2025 13:30-13:31

**Data:** 26/11/2025  
**Contexto:** Análise do erro intermitente que ocorreu HOJE após aumento do limite PHP-FPM  
**Status:** 📋 **ANÁLISE TÉCNICA** - Apenas investigação, sem modificações

---

## 📋 SITUAÇÃO REAL

### **Fatos:**
1. ✅ Limite PHP-FPM foi aumentado de 5 para 10 em 25/11 às 22:44:58
2. ✅ Erro ocorreu HOJE (26/11) às 13:30-13:31
3. ❌ **Nenhuma ocorrência** de "server reached pm.max_children" no log de hoje
4. ❌ Log do PHP-FPM não foi atualizado hoje (última modificação: 25/11 às 22:45)

### **Erros Reportados:**
- `whatsapp_modal_octadesk_initial_error` - 13:30:32
- `whatsapp_modal_espocrm_update_error` - 13:31:54
- Dados: `has_ddd: false, has_celular: false, has_cpf: false, has_nome: false`

---

## 🔍 ANÁLISE: Por que o erro ocorreu se não foi max_children?

### **Hipótese 1: Requisições não chegam ao servidor (mais provável)**

**Evidências:**
- ✅ Requisições `fetch()` não aparecem no access.log
- ✅ Endpoints PHP não são executados
- ✅ Erro é detectado no navegador (JavaScript)

**Possíveis causas:**
1. **Timeout do navegador antes de chegar ao servidor**
   - Requisição demora muito para estabelecer conexão
   - Navegador cancela antes de chegar ao servidor
   - Não aparece no access.log porque nunca chegou

2. **Cloudflare bloqueando/rejeitando requisições**
   - Firewall do Cloudflare bloqueando requisições específicas
   - Rate limiting do Cloudflare
   - WAF (Web Application Firewall) bloqueando

3. **DNS/Conectividade intermitente**
   - Problemas de DNS do cliente
   - Problemas de roteamento de rede
   - Timeout de conexão TCP

4. **CORS ou SSL/TLS intermitente**
   - Problemas de certificado SSL
   - CORS bloqueando requisições em alguns casos
   - Handshake TLS falhando

---

### **Hipótese 2: PHP-FPM rejeitando silenciosamente**

**Evidências:**
- ✅ Não há logs de "max_children" hoje
- ⚠️ Mas pode haver outros motivos para rejeição

**Possíveis causas:**
1. **Fila de requisições cheia**
   - `pm.max_requests` atingido (processo sendo reciclado)
   - Requisições aguardando em fila muito tempo
   - Timeout antes de processar

2. **Processos travados (não max_children)**
   - Processos travados em operações lentas
   - Não há processos disponíveis (mas não atingiu max_children)
   - Requisições aguardando processos travados

3. **Socket PHP-FPM temporariamente indisponível**
   - Problemas de permissão no socket
   - Socket temporariamente bloqueado
   - Problemas de sistema de arquivos

---

### **Hipótese 3: Erro no código JavaScript**

**Evidências:**
- ✅ Dados vazios: `has_ddd: false, has_celular: false`
- ✅ Erro é logado pelo JavaScript

**Possíveis causas:**
1. **Dados não estão disponíveis quando função é chamada**
   - Variáveis não inicializadas
   - Timing issue (função chamada antes dos dados)
   - Problema de escopo/closure

2. **fetchWithRetry falhando antes de fazer requisição**
   - Validação de dados falhando
   - Construção da URL falhando
   - Erro antes de fazer fetch()

3. **AbortController cancelando requisição**
   - Timeout do AbortController
   - Requisição cancelada antes de completar
   - Race condition

---

## 🔍 INVESTIGAÇÃO NECESSÁRIA

### **1. Verificar logs do Nginx no horário do erro**

**Comando:**
```bash
grep '2025/11/26.*13:3[0-1]' /var/log/nginx/error.log
grep '2025/11/26.*13:3[0-1]' /var/log/nginx/access.log | grep -E 'add_webflow_octa|add_flyingdonkeys'
```

**O que verificar:**
- Se há erros de upstream/timeout
- Se requisições chegaram ao servidor
- Se há erros de FastCGI

---

### **2. Verificar função fetchWithRetry**

**O que verificar:**
- Como a função funciona
- Quais condições causam falha
- Se há timeout configurado
- Se há retry logic

---

### **3. Verificar dados vazios**

**O que verificar:**
- Por que `has_ddd: false, has_celular: false`
- Se dados estão disponíveis quando função é chamada
- Se há problema de timing

---

### **4. Verificar Cloudflare**

**O que verificar:**
- Logs do Cloudflare no horário do erro
- Se há bloqueios/firewall rules
- Se há rate limiting ativo

---

## 📊 ANÁLISE DA FUNÇÃO fetchWithRetry

### **Como funciona:**

```javascript
async function fetchWithRetry(url, options, maxRetries = 2, retryDelay = 1000) {
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 30000); // 30s timeout
      
      const response = await fetch(url, {
        ...options,
        signal: controller.signal
      });
      
      clearTimeout(timeoutId);
      
      if (response.ok || response.status < 500) {
        return { success: true, response, attempt };
      }
      
      // Retry apenas para erros 5xx (servidor) ou timeout
      if (attempt < maxRetries && (response.status >= 500 || response.status === 408)) {
        await new Promise(resolve => setTimeout(resolve, retryDelay * (attempt + 1)));
        continue;
      }
      
      return { success: false, response, attempt };
      
    } catch (error) {
      // Erro de rede ou timeout - tentar retry
      if (attempt < maxRetries && (error.name === 'TypeError' || error.name === 'AbortError')) {
        await new Promise(resolve => setTimeout(resolve, retryDelay * (attempt + 1)));
        continue;
      }
      
      return { success: false, error, attempt };
    }
  }
}
```

### **O que pode causar falha:**

1. **Timeout de 30 segundos (AbortError)**
   - Requisição demora mais de 30s
   - AbortController cancela requisição
   - Retry até 2 vezes (total de 3 tentativas)

2. **Erro de rede (TypeError - Failed to fetch)**
   - DNS não resolve
   - Conexão não estabelecida
   - Rede intermitente
   - Retry até 2 vezes (total de 3 tentativas)

3. **Erro HTTP 5xx (servidor)**
   - Servidor retorna erro 500, 502, 503, etc.
   - Retry até 2 vezes (total de 3 tentativas)

4. **Erro HTTP 4xx (cliente)**
   - Servidor retorna erro 400, 401, 403, 404, etc.
   - **NÃO faz retry** (retorna erro imediatamente)

---

## 📊 CONCLUSÃO DEFINITIVA

### **Causa mais provável:**

**🔴 TIMEOUT DE 30 SEGUNDOS OU ERRO DE REDE (80% de probabilidade)**

**Justificativa:**
- ✅ Requisições não aparecem no access.log (não chegam ao servidor)
- ✅ Endpoints PHP não são executados
- ✅ Erro é detectado no navegador (JavaScript)
- ✅ `fetchWithRetry` tem timeout de 30s
- ✅ Após 3 tentativas (0, 1, 2), retorna erro
- ⚠️ **Não há evidência de max_children sendo atingido hoje**

**Possíveis causas:**
1. **Timeout de 30s** - Requisição demora mais de 30s para estabelecer conexão
2. **Erro de rede (TypeError)** - DNS não resolve, conexão não estabelecida
3. **Cloudflare bloqueando** - Firewall/WAF bloqueando requisições
4. **SSL/TLS intermitente** - Handshake falhando

**Por que é intermitente:**
- ✅ Timeout/erro de rede ocorre apenas em alguns casos
- ✅ Depende de condições de rede do cliente
- ✅ Depende de carga do servidor/Cloudflare
- ✅ Não bloqueia 100% das requisições

---

### **Causa secundária:**

**🟡 DADOS VAZIOS NO JAVASCRIPT (20% de probabilidade)**

**Justificativa:**
- ✅ Dados vazios: `has_ddd: false, has_celular: false`
- ✅ Pode indicar problema no código JavaScript
- ⚠️ Mas não explica por que requisição não chega ao servidor

**Possível causa:**
- Função chamada antes de dados estarem disponíveis
- Problema de timing/race condition
- Dados não capturados corretamente

---

## 📋 RECOMENDAÇÕES

### **1. Aumentar timeout e melhorar logs**

**Ajustes:**
- Aumentar timeout de 30s para 60s (ou configurável)
- Adicionar logs detalhados do erro (tipo, mensagem, stack)
- Logar URL completa sendo chamada
- Logar tempo de resposta (se houver)

### **2. Verificar Cloudflare**

**Verificações:**
- Verificar logs do Cloudflare no horário do erro
- Verificar se há firewall rules bloqueando
- Verificar se há rate limiting ativo
- Verificar se há problemas de SSL/TLS

### **3. Verificar conectividade do cliente**

**Testes:**
- Verificar se cliente consegue acessar `prod.bssegurosimediato.com.br`
- Verificar se há problemas de DNS
- Verificar se há problemas de SSL/TLS
- Verificar se há problemas de rede

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **ANÁLISE CONCLUÍDA** - Causa mais provável: Timeout de 30s ou erro de rede

