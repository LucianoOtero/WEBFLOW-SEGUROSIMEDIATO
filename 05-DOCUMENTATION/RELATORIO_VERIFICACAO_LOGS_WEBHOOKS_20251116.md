# 📋 Relatório: Verificação de Logs dos Webhooks - Produção

**Data:** 16/11/2025 14:36  
**Servidor:** `prod.bssegurosimediato.com.br` (157.180.36.223)  
**Status:** ✅ **WEBHOOKS PROCESSADOS** (com erro no FlyingDonkeys)

---

## 📊 RESUMO EXECUTIVO

| Webhook | Status | Validação Assinatura | Processamento | Observações |
|---------|--------|---------------------|----------------|-------------|
| **add_flyingdonkeys.php** | ⚠️ **PARCIAL** | ✅ Válida | ❌ **ERRO** | Erro ao criar lead no CRM |
| **add_webflow_octa.php** | ✅ **SUCESSO** | ✅ Válida | ✅ **SUCESSO** | Template enviado com sucesso |

---

## 📋 DETALHAMENTO DOS LOGS

### **1. add_flyingdonkeys.php**

#### ✅ **Eventos Bem-Sucedidos:**
- ✅ **Validação de Assinatura:** Assinatura validada com sucesso
- ✅ **Webhook Recebido:** Requisição recebida e processada
- ✅ **Webhook Completado:** Processamento finalizado

#### ❌ **Erros Identificados:**

**Erro 1: `crm_error`**
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

**Análise:**
- ❌ **Erro ao criar lead no EspoCRM**
- ❌ **Localização:** `class.php` linha 145 (método `EspoApiClient->request()`)
- ❌ **Mensagem de erro vazia:** Campo `error` está vazio, dificultando diagnóstico
- ⚠️ **Request ID:** `prod_fd_6919e1627a97b7.00326569`

**Possíveis Causas:**
1. Credenciais do EspoCRM incorretas
2. URL do EspoCRM incorreta
3. Erro na API do EspoCRM (timeout, conexão, etc.)
4. Dados inválidos sendo enviados ao CRM

---

### **2. add_webflow_octa.php**

#### ✅ **Eventos Bem-Sucedidos:**

1. ✅ **webhook_received** - Webhook recebido com sucesso
   - Método: POST
   - Headers: Cloudflare, Webflow Signature, Timestamp
   - Input length: 2103 bytes

2. ✅ **signature_validation** - Assinatura validada
   ```json
   {
       "status": "valid",
       "source": "webflow",
       "signature_received": "da2c23509e28e1ed...",
       "timestamp_received": "1763303777976"
   }
   ```

3. ✅ **webflow_data_parsed** - Dados do formulário parseados
   - Formulário: "Home"
   - Dados recebidos: NOME, DDD-CELULAR, CELULAR, Email, CEP, CPF, PLACA, ANO, MARCA, GCLID

4. ✅ **contact_data_mapped** - Dados do contato mapeados
   - Nome: "TESTE LUCIANO 1116 - NAO LIGAR"
   - Email: "lrotero1116@gmail.com"
   - Telefone: "+5511976687668"
   - GCLID: "Teste-producao-202511161116"

5. ✅ **octadesk_send_template_payload** - Payload preparado
   - Template: "site_cotacao"
   - Idioma: "pt_BR"
   - Telefone E164: "+5511976687668"

6. ✅ **OCTA_REQ** - Requisição enviada ao OctaDesk
   - Método: POST
   - URL: `https://o205242-d60.api004.octadesk.services/chat/conversation/send-template`

7. ✅ **OCTA_RES** - Resposta do OctaDesk
   - HTTP Status: **201 Created**
   - Message Key: `10bcafd0-9d09-4d83-8655-582118ce5280`
   - Room Key: `408c4ee3-273e-40fa-8b11-7650d55dcc43`

8. ✅ **webhook_success** - Webhook processado com sucesso
   ```json
   {
       "form_name": "Home",
       "phone": "1197***68",
       "http_code": 201
   }
   ```

---

## ✅ CONCLUSÕES

### **add_webflow_octa.php:**
- ✅ **100% FUNCIONAL**
- ✅ Assinatura validada corretamente
- ✅ Dados parseados corretamente
- ✅ Template WhatsApp enviado com sucesso ao OctaDesk
- ✅ HTTP 201 (Created) - mensagem criada no OctaDesk

### **add_flyingdonkeys.php:**
- ⚠️ **ERRO AO CRIAR LEAD NO ESPOCRM**
- ✅ Assinatura validada corretamente
- ✅ Webhook recebido e processado
- ❌ **Falha ao criar lead no EspoCRM** (erro em `class.php` linha 145)
- ⚠️ **Necessário investigar:**
  1. Verificar credenciais do EspoCRM em produção
  2. Verificar URL do EspoCRM (`ESPOCRM_URL`)
  3. Verificar logs do `class.php` para mais detalhes do erro
  4. Verificar se a API do EspoCRM está acessível

---

## 🔍 PRÓXIMOS PASSOS

### **1. Investigar Erro no FlyingDonkeys**

**Ações Necessárias:**
1. ✅ Verificar variável `ESPOCRM_URL` no PHP-FPM de produção
2. ✅ Verificar variável `ESPOCRM_API_KEY` no PHP-FPM de produção
3. ✅ Verificar arquivo `class.php` linha 145 para entender o erro
4. ✅ Testar conexão com EspoCRM manualmente
5. ✅ Verificar logs do EspoCRM (se disponíveis)

**Comandos Sugeridos:**
```bash
# Verificar variáveis de ambiente
ssh root@157.180.36.223 "grep 'ESPOCRM' /etc/php/8.3/fpm/pool.d/www.conf"

# Verificar arquivo class.php linha 145
ssh root@157.180.36.223 "sed -n '140,150p' /var/www/html/prod/root/class.php"

# Testar conexão com EspoCRM
ssh root@157.180.36.223 "curl -I https://flyingdonkeys.com.br"
```

---

## 📝 DADOS DO FORMULÁRIO SUBMETIDO

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

**Status:** ✅ **OctaDesk funcionando** | ⚠️ **FlyingDonkeys com erro no CRM**

