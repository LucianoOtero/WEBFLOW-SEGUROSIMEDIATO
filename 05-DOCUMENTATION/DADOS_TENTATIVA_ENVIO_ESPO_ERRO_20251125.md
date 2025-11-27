# 📋 Dados da Tentativa de Envio para EspoCRM que Deu Erro

**Data:** 25/11/2025  
**Status:** 🔍 **CONSULTA DE LOGS EXISTENTES**  
**Fonte:** Relatórios de análise anteriores

---

## 📊 DADOS DISPONÍVEIS NOS LOGS

### **1. Erro Reportado em 16/11/2025 14:36:18**

**Request ID:** `prod_fd_6919e1627a97b7.00326569`

**Log de Erro (`crm_error`):**
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

**Dados do Formulário Submetido:**
- **Nome:** TESTE LUCIANO 1116 - NAO LIGAR
- **Email:** lrotero1116@gmail.com
- **DDD:** 11
- **Celular:** 97668-7668
- **CEP:** 03317-000
- **CPF:** 924.029.710-37
- **Placa:** FPG-8D63
- **Ano:** 2016
- **Marca:** NISSAN / MARCH 16SV
- **GCLID:** Teste-producao-202511161116

---

### **2. Erro Reportado em 16/11/2025 16:16:34**

**Request ID:** `prod_fd_6919f8e2656105.76637017`

**Log de Erro (`flyingdonkeys_exception`):**
```json
{
    "event": "flyingdonkeys_exception",
    "success": false,
    "data": {
        "error": "",
        "http_code": 401
    }
}
```

**Dados do Formulário Submetido:**
- **Email:** LROTERO1315@GMAIL.COM
- **Nome:** LUCIANO TESTE NAO LIGAR 1315
- **CPF:** 344.334.130-62
- **Placa:** FPG-8D63
- **Request ID:** `prod_fd_6919f8e2656105.76637017`

**Análise:**
- ❌ **HTTP 401 (Não autorizado)** - Problema de autenticação com EspoCRM
- ❌ **Mensagem de erro vazia** - Campo `error` está vazio

---

## ⚠️ DADOS FALTANDO NOS LOGS

### **O que NÃO está sendo logado atualmente:**

1. **❌ Payload Completo Enviado ao EspoCRM:**
   - Não há log do payload `$lead_data` completo antes de enviar
   - Não há log do payload `$opportunityPayload` completo antes de enviar
   - Apenas há log de `payload_keys` (chaves do array, não valores)

2. **❌ Resposta Completa do EspoCRM:**
   - Não há log do body completo da resposta HTTP
   - Não há log dos headers completos da resposta
   - Não há log do status HTTP detalhado

3. **❌ Detalhes da Requisição HTTP:**
   - Não há log da URL completa chamada
   - Não há log dos headers enviados
   - Não há log do tempo de resposta
   - Não há log de erros de conexão (timeout, DNS, SSL)

4. **❌ Informações de Rede:**
   - Não há log de tempo de conexão
   - Não há log de tempo de resposta
   - Não há log de tamanho da requisição/resposta

---

## 📋 O QUE ESTÁ SENDO LOGADO ATUALMENTE

### **Logs Disponíveis:**

#### **1. Antes de Enviar Lead (`flyingdonkeys_lead_creation_started`):**
```php
logProdWebhook('flyingdonkeys_lead_creation_started', [
    'email' => $email,
    'name' => $name,
    'payload_keys' => array_keys($lead_data)  // ⚠️ Apenas chaves, não valores
], true);
```

**Limitação:** ⚠️ Apenas loga as **chaves** do payload, não os **valores**

#### **2. Após Resposta da API (`flyingdonkeys_api_response`):**
```php
logProdWebhook('flyingdonkeys_api_response', [
    'response_keys' => array_keys($responseFlyingDonkeys),
    'has_id' => isset($responseFlyingDonkeys['id']),
    'response_preview' => json_encode($responseFlyingDonkeys)  // ✅ Preview completo
], true);
```

**Limitação:** ⚠️ Loga preview, mas pode estar truncado

#### **3. Em Caso de Erro (`flyingdonkeys_exception`):**
```php
logDevWebhook('flyingdonkeys_exception', [
    'error' => $errorMessage,
    'http_code' => $httpCode  // ✅ Código HTTP capturado
], false);
```

**Limitação:** ⚠️ Mensagem de erro pode estar vazia

#### **4. Erro Real (`real_error_creating_lead`):**
```php
logDevWebhook('real_error_creating_lead', [
    'error' => $errorMessage
], false);
```

**Limitação:** ⚠️ Mensagem de erro pode estar vazia

---

## 🔍 ONDE OS DADOS ESTÃO ARMAZENADOS

### **Arquivos de Log no Servidor:**

**Produção:**
- `/var/www/html/prod/root/logs/flyingdonkeys_prod.txt`

**Desenvolvimento:**
- `/var/www/html/dev/root/logs/flyingdonkeys_dev.txt`

### **Como Consultar:**

```bash
# Verificar último erro
grep "crm_error\|flyingdonkeys_exception\|real_error_creating_lead" /var/www/html/prod/root/logs/flyingdonkeys_prod.txt | tail -1

# Verificar por Request ID específico
grep "prod_fd_6919e1627a97b7.00326569" /var/www/html/prod/root/logs/flyingdonkeys_prod.txt

# Verificar payload enviado (se logado)
grep "flyingdonkeys_lead_creation_started\|espocrm_request_details" /var/www/html/prod/root/logs/flyingdonkeys_prod.txt | tail -1
```

---

## 📊 RESUMO DOS DADOS DISPONÍVEIS

### **✅ Dados Disponíveis:**
- ✅ Request ID
- ✅ Timestamp
- ✅ Dados do formulário (nome, email, CPF, etc.)
- ✅ Código HTTP do erro (quando capturado)
- ✅ Arquivo e linha onde erro ocorreu
- ✅ Stack trace
- ✅ Preview da resposta (pode estar truncado)

### **❌ Dados Faltando:**
- ❌ Payload completo enviado ao EspoCRM (`$lead_data` completo)
- ❌ Payload completo da oportunidade (`$opportunityPayload` completo)
- ❌ URL completa chamada
- ❌ Headers completos da requisição
- ❌ Body completo da resposta HTTP
- ❌ Headers completos da resposta HTTP
- ❌ Tempo de resposta
- ❌ Tempo de conexão
- ❌ Mensagem de erro detalhada (quando vazia)

---

## 🚨 CONCLUSÃO

### **Status dos Dados nos Logs:**

**✅ Dados Parciais Disponíveis:**
- Há informações sobre o erro (código HTTP, localização, stack trace)
- Há dados do formulário submetido
- Há Request ID para rastreamento

**❌ Dados Completos Faltando:**
- **Payload completo enviado** não está sendo logado
- **Resposta completa do EspoCRM** não está sendo logada
- **Detalhes da requisição HTTP** não estão sendo logados

### **Recomendação:**

Para obter dados completos da tentativa de envio que deu erro, seria necessário:

1. **Consultar logs no servidor** para ver se há mais detalhes:
   ```bash
   ssh root@157.180.36.223 "grep 'prod_fd_6919e1627a97b7.00326569' /var/www/html/prod/root/logs/flyingdonkeys_prod.txt"
   ```

2. **Implementar logs adicionais** (conforme projeto de aprimoramento de logs):
   - Logar payload completo antes de enviar
   - Logar resposta completa do EspoCRM
   - Logar detalhes da requisição HTTP

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Status:** 🔍 Dados parciais disponíveis - Dados completos não estão sendo logados atualmente

