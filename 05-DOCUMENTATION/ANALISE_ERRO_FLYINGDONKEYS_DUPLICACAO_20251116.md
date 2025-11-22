# 📋 Análise: Erro FlyingDonkeys - Verificação de Duplicação

**Data:** 16/11/2025 14:36  
**Servidor:** `prod.bssegurosimediato.com.br` (157.180.36.223)  
**Request ID:** `prod_fd_6919e1627a97b7.00326569`  
**Status:** 🔍 **ANÁLISE EM ANDAMENTO**

---

## 🎯 OBJETIVO

Verificar se o erro no `add_flyingdonkeys.php` foi causado por duplicação de lead (lead já existente no CRM).

---

## 📊 ANÁLISE DOS LOGS

### **Eventos da Requisição:**

1. ✅ `webhook_started` - Webhook iniciado
2. ✅ `signature_validation` - Assinatura validada
3. ✅ `data_received` - Dados recebidos
4. ✅ `api_v2_payload_decoded` - Payload decodificado
5. ✅ `data_processing_complete` - Processamento de dados completo
6. ✅ `crm_connection` - Conexão com CRM estabelecida
7. ✅ `field_mapping` - Campos mapeados
8. ✅ `lead_data_prepared` - Dados do lead preparados
9. ✅ `espocrm_request_details` - Detalhes da requisição ao EspoCRM
10. ✅ `processing_flyingdonkeys` - Processamento FlyingDonkeys iniciado
11. ✅ `payload_ids_analysis` - Análise de IDs do payload
12. ✅ `curl_request_complete_lead` - Requisição cURL completa para criar lead
13. ✅ `flyingdonkeys_lead_creation_started` - Início da criação de lead
14. ❌ `flyingdonkeys_exception` - **EXCEÇÃO CAPTURADA**
15. ❌ `real_error_creating_lead` - **ERRO REAL (não duplicação)**
16. ❌ `crm_error` - **ERRO NO CRM**

---

## 🔍 DETALHES DO ERRO

### **Erro Capturado:**

```json
{
    "timestamp": "2025-11-16 14:36:18",
    "environment": "production",
    "webhook": "flyingdonkeys-v2",
    "event": "flyingdonkeys_exception",
    "success": false,
    "data": {
        "error": ""
    },
    "request_id": "prod_fd_6919e1627a97b7.00326569"
}
```

### **Erro no CRM:**

```json
{
    "timestamp": "2025-11-16 14:36:18",
    "environment": "production",
    "webhook": "flyingdonkeys-v2",
    "event": "crm_error",
    "success": false,
    "data": {
        "error": "",
        "file": "/var/www/html/prod/root/class.php",
        "line": 145,
        "trace": "#0 /var/www/html/prod/root/add_flyingdonkeys.php(951): EspoApiClient->request()\n#1 {main}"
    },
    "request_id": "prod_fd_6919e1627a97b7.00326569"
}
```

---

## ⚠️ PROBLEMA IDENTIFICADO

### **1. Mensagem de Erro Vazia**

- ❌ Campo `error` está vazio (`""`)
- ❌ Não há indicação clara do que causou o erro
- ❌ Dificulta diagnóstico

### **2. Não Foi Detectado Como Duplicação**

- ❌ **Nenhum evento** `duplicate_lead_detected` encontrado nos logs
- ❌ **Nenhum evento** `existing_lead_found` encontrado nos logs
- ❌ **Nenhum evento** `duplicate_lead_not_found` encontrado nos logs
- ✅ Código de tratamento de duplicação existe (linhas 973-1008 de `add_flyingdonkeys.php`)
- ❌ **Mas não foi acionado** - indica que o erro não foi reconhecido como duplicação

### **3. Código de Tratamento de Duplicação**

O código verifica:
- ✅ HTTP 409 (Conflict)
- ✅ Palavra "duplicate" na mensagem
- ✅ Presença de `"id"` e `"name"` na resposta (EspoCRM retorna lead existente como "erro")

**Se nenhuma dessas condições foi atendida, o erro foi tratado como "erro real" (`real_error_creating_lead`).**

---

## 🔍 POSSÍVEIS CAUSAS

### **1. Erro Não É Duplicação**

- ⚠️ O erro pode ser outro tipo de problema:
  - Credenciais incorretas
  - URL do EspoCRM incorreta
  - Timeout na conexão
  - Erro de validação de dados
  - Problema de rede

### **2. Mensagem de Erro Vazia do EspoCRM**

- ⚠️ O EspoCRM pode ter retornado erro sem mensagem clara
- ⚠️ O header `X-Status-Reason` pode estar vazio
- ⚠️ O body da resposta pode estar vazio ou não conter mensagem de erro

### **3. Endpoints Antigos Ainda Ativos**

- ⚠️ **Hipótese do usuário:** Endpoints antigos em `bpsegurosimediato.com.br` ainda funcionando
- ⚠️ Pode haver conflito ou confusão entre endpoints antigos e novos
- ⚠️ Webhook pode estar chamando endpoint antigo que não está configurado corretamente

---

## 📋 VERIFICAÇÕES NECESSÁRIAS

### **1. Verificar Resposta Completa do EspoCRM**

```bash
# Verificar logs detalhados da requisição
ssh root@157.180.36.223 "grep -A 50 'curl_request_complete_lead' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | grep -A 50 'prod_fd_6919e1627a97b7'"
```

### **2. Verificar Código HTTP da Resposta**

- Verificar se foi HTTP 409 (Conflict - duplicação)
- Verificar se foi HTTP 400 (Bad Request)
- Verificar se foi HTTP 401 (Unauthorized)
- Verificar se foi HTTP 500 (Internal Server Error)

### **3. Verificar Endpoints Configurados no Webflow**

- Verificar se o webhook está apontando para o endpoint correto
- Verificar se há endpoints antigos ainda configurados
- Verificar se há conflito entre `bpsegurosimediato.com.br` e `prod.bssegurosimediato.com.br`

### **4. Verificar Credenciais do EspoCRM**

- Verificar `ESPOCRM_URL` no PHP-FPM
- Verificar `ESPOCRM_API_KEY` no PHP-FPM
- Testar conexão manual com EspoCRM

---

## ✅ CONCLUSÃO PRELIMINAR

### **Não Foi Erro de Duplicação**

**Evidências:**
1. ❌ Nenhum evento de duplicação detectado nos logs
2. ❌ Código de tratamento de duplicação não foi acionado
3. ❌ Erro foi tratado como "erro real" (`real_error_creating_lead`)
4. ⚠️ Mensagem de erro vazia dificulta diagnóstico preciso

### **Próximos Passos:**

1. ✅ Verificar resposta completa do EspoCRM (código HTTP, headers, body)
2. ✅ Verificar se endpoints antigos estão causando conflito
3. ✅ Verificar credenciais e URL do EspoCRM
4. ✅ Testar conexão manual com EspoCRM

---

**Status:** 🔍 **ANÁLISE EM ANDAMENTO** - Não foi erro de duplicação, mas causa ainda não identificada

