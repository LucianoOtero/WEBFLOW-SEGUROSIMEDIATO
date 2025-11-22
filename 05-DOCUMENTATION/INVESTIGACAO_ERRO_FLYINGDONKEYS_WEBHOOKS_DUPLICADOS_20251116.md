# 🔍 Investigação: Erro FlyingDonkeys - Webhooks Duplicados

**Data:** 16/11/2025 14:36  
**Servidor:** `prod.bssegurosimediato.com.br` (157.180.36.223)  
**Request ID:** `prod_fd_6919e1627a97b7.00326569`  
**Status:** 🔍 **INVESTIGAÇÃO EM ANDAMENTO**

---

## 🎯 CONTEXTO

### **Webhooks Configurados no Webflow:**

1. ✅ `https://bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php` (ANTIGO - Fallback)
2. ✅ `https://prod.bssegurosimediato.com.br/add_flyingdonkeys.php` (NOVO - Implementação atual)
3. ✅ `https://bpsegurosimediato.com.br/webhooks/add_webflow_octa_v2.php` (ANTIGO - Fallback)
4. ✅ `https://prod.bssegurosimediato.com.br/add_webflow_octa.php` (NOVO - Implementação atual)

### **Observação Importante:**

- ✅ **OctaDesk:** 2 chamadas legítimas (ambos os webhooks funcionando corretamente)
- ❌ **FlyingDonkeys:** Erro no webhook novo após webhook antigo provavelmente ter criado o lead

---

## 📊 ANÁLISE DO PROBLEMA

### **Hipótese Principal:**

**Ordem de Execução:**
1. ✅ Webhook antigo (`bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php`) executa primeiro
2. ✅ Cria lead no EspoCRM com sucesso
3. ❌ Webhook novo (`prod.bssegurosimediato.com.br/add_flyingdonkeys.php`) executa depois
4. ❌ Tenta criar o mesmo lead (mesmo email: `lrotero1116@gmail.com`)
5. ❌ EspoCRM retorna erro (lead já existe)
6. ❌ Erro não é detectado como duplicação pelo código

### **Evidências:**

1. ✅ **Timestamp:** Ambos os webhooks executaram em `2025-11-16 14:36:18`
2. ✅ **Email:** `lrotero1116@gmail.com` (mesmo email em ambos)
3. ❌ **Erro:** `crm_error` com mensagem vazia
4. ❌ **Não detectado como duplicação:** Nenhum evento `duplicate_lead_detected` nos logs

---

## 🔍 PROBLEMAS IDENTIFICADOS

### **1. Erro Não Detectado Como Duplicação**

**Código de Tratamento de Duplicação (linhas 973-1008):**
```php
if (
    strpos($errorMessage, '409') !== false || 
    strpos($errorMessage, 'duplicate') !== false ||
    (strpos($errorMessage, '"id":') !== false && strpos($errorMessage, '"name":') !== false)
) {
    // Tratamento de duplicação
}
```

**Problema:**
- ❌ Mensagem de erro está vazia (`""`)
- ❌ Não contém "409" ou "duplicate"
- ❌ Não contém `"id"` e `"name"`
- ❌ Código de tratamento não é acionado

### **2. Mensagem de Erro Vazia**

**Localização do Erro:**
- Arquivo: `class.php` linha 145
- Método: `EspoApiClient->request()`
- Exception lançada com mensagem vazia

**Possíveis Causas:**
1. EspoCRM retornou erro sem mensagem clara
2. Header `X-Status-Reason` está vazio
3. Body da resposta está vazio ou não contém mensagem de erro
4. Código HTTP não está sendo capturado corretamente

### **3. Ordem de Execução dos Webhooks**

**Webflow executa webhooks em paralelo ou sequencialmente:**
- ⚠️ Não há garantia de ordem de execução
- ⚠️ Webhook antigo pode executar antes ou depois do novo
- ⚠️ Se antigo executar primeiro e criar lead, novo falhará

---

## 🔍 INVESTIGAÇÕES NECESSÁRIAS

### **1. Verificar Resposta Completa do EspoCRM**

**Objetivo:** Identificar código HTTP e mensagem de erro real

**Comandos:**
```bash
# Verificar logs detalhados da requisição
ssh root@157.180.36.223 "grep -A 50 'curl_request_complete_lead' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | grep -A 50 'prod_fd_6919e1627a97b7'"

# Verificar código HTTP na resposta
ssh root@157.180.36.223 "grep -E '409|422|400|500' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | grep 'prod_fd_6919e1627a97b7'"
```

### **2. Verificar Se Lead Foi Criado pelo Webhook Antigo**

**Objetivo:** Confirmar se lead já existe no EspoCRM

**Ações:**
- Verificar logs do servidor antigo (se disponíveis)
- Verificar no EspoCRM se lead com email `lrotero1116@gmail.com` foi criado
- Verificar timestamp de criação do lead

### **3. Verificar Código de Tratamento de Erro**

**Objetivo:** Melhorar detecção de duplicação

**Problemas Identificados:**
- Mensagem de erro vazia não permite detecção
- Código HTTP não está sendo verificado
- Resposta do EspoCRM não está sendo analisada completamente

---

## 📋 POSSÍVEIS SOLUÇÕES

### **Solução 1: Melhorar Detecção de Duplicação**

**Modificações Necessárias:**
1. Capturar código HTTP da resposta do EspoCRM
2. Verificar código HTTP 409 (Conflict) explicitamente
3. Analisar body da resposta mesmo quando mensagem está vazia
4. Verificar se resposta contém dados do lead existente

### **Solução 2: Verificar Lead Antes de Criar**

**Modificações Necessárias:**
1. Buscar lead por email antes de tentar criar
2. Se lead existir, atualizar ao invés de criar novo
3. Evitar erro de duplicação completamente

### **Solução 3: Desabilitar Webhook Antigo (Quando Novo Estiver Estável)**

**Ações:**
1. Monitorar webhook novo por período de teste
2. Após confirmação de estabilidade, desabilitar webhook antigo no Webflow
3. Manter apenas webhook novo ativo

---

## ✅ CONCLUSÕES PRELIMINARES

### **Problema Confirmado:**

1. ✅ **Duas chamadas legítimas:** Webhook antigo e novo estão sendo executados
2. ✅ **OctaDesk funcionando:** 2 chamadas legítimas, ambas com sucesso
3. ❌ **FlyingDonkeys com erro:** Webhook novo falhou após webhook antigo provavelmente ter criado o lead
4. ❌ **Erro não detectado como duplicação:** Mensagem vazia impede detecção correta

### **Próximos Passos:**

1. ✅ Verificar resposta completa do EspoCRM (código HTTP, headers, body)
2. ✅ Verificar se lead foi criado pelo webhook antigo
3. ✅ Melhorar código de detecção de duplicação
4. ✅ Considerar verificar lead antes de criar (buscar por email primeiro)

---

**Status:** 🔍 **INVESTIGAÇÃO EM ANDAMENTO** - Erro provavelmente causado por duplicação não detectada

