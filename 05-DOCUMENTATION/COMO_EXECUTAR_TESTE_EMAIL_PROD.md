# 📧 Como Executar Teste de Email em Produção

**Data:** 16/11/2025  
**Objetivo:** Documentar como executar teste de envio de 3 emails em produção

---

## 🚀 MÉTODO 1: Via PHP CLI (Recomendado)

### **Arquivo de Teste:**
`WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/test_email_prod_3_emails.php`

### **Comando:**
```bash
cd WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\TMP
php test_email_prod_3_emails.php
```

### **O que o arquivo faz:**
1. ✅ Prepara dados de teste (simulando primeiro contato)
2. ✅ Cria requisição HTTP POST usando cURL (via PHP)
3. ✅ Envia para: `https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php`
4. ✅ Exibe resultado detalhado (JSON formatado)
5. ✅ Mostra status de cada email enviado

### **Vantagens:**
- ✅ Resultado formatado e fácil de ler
- ✅ Validação de resposta JSON
- ✅ Exibição detalhada de cada email
- ✅ Tratamento de erros

---

## 🚀 MÉTODO 2: Via cURL Direto

### **Comando:**
```bash
curl -X POST https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{"ddd":"11","celular":"987654321","nome":"Teste"}'
```

### **Vantagens:**
- ✅ Não requer arquivo PHP
- ✅ Pode ser executado de qualquer lugar
- ✅ Útil para testes rápidos

### **Desvantagens:**
- ⚠️ Resposta JSON não formatada
- ⚠️ Menos detalhes sobre cada email

---

## 📊 DETALHES TÉCNICOS

### **1. Ambiente de Execução:**
- **Sistema:** Windows PowerShell
- **PHP CLI:** Comando `php` disponível no PATH
- **Localização:** Executado localmente no Windows
- **Conexão:** Requisição HTTP para servidor de produção

### **2. Requisição HTTP:**
- **Método:** POST
- **URL:** `https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php`
- **Headers:**
  - `Content-Type: application/json`
  - `Accept: application/json`
- **Body:** JSON com dados de teste

### **3. Biblioteca Utilizada:**
- **cURL:** Via funções PHP `curl_*`
- **SSL:** Verificação desabilitada para teste local (`CURLOPT_SSL_VERIFYPEER => false`)
- **Timeout:** 30 segundos (conexão: 10 segundos)

### **4. Dados Enviados:**
```json
{
  "ddd": "11",
  "celular": "987654321",
  "nome": "Teste Sistema Email",
  "email": "teste@email.com",
  "cpf": "123.456.789-00",
  "cep": "01234-567",
  "placa": "TEST1234",
  "gclid": "test-gclid-123",
  "momento": "initial",
  "momento_descricao": "Primeiro Contato - Apenas Telefone",
  "momento_emoji": "📞"
}
```

### **5. Resultado Esperado:**
```json
{
  "success": true,
  "total_sent": 3,
  "total_failed": 0,
  "total_recipients": 3,
  "results": [
    {
      "email": "lrotero@gmail.com",
      "success": true,
      "message_id": "0103019a8db357e4-..."
    },
    {
      "email": "alex.kaminski@imediatoseguros.com.br",
      "success": true,
      "message_id": "0103019a8db35966-..."
    },
    {
      "email": "alexkaminski70@gmail.com",
      "success": true,
      "message_id": "0103019a8db35adf-..."
    }
  ]
}
```

---

## 🔍 FLUXO DE EXECUÇÃO

### **Passo a Passo:**

1. **Preparação:**
   - Arquivo PHP carrega dados de teste
   - Prepara array com informações do cliente

2. **Requisição HTTP:**
   - Inicializa cURL com URL do endpoint
   - Configura headers (Content-Type, Accept)
   - Converte dados para JSON
   - Envia requisição POST

3. **Processamento no Servidor:**
   - Endpoint recebe requisição
   - Valida dados recebidos
   - Renderiza template de email
   - Envia 3 emails via AWS SES (1 para cada administrador)

4. **Resposta:**
   - Servidor retorna JSON com resultado
   - PHP parseia resposta JSON
   - Exibe resultado formatado no console

5. **Validação:**
   - Verifica se `success === true`
   - Confirma que `total_sent === 3`
   - Lista status de cada email

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **1. SSL Verification:**
- ⚠️ Verificação SSL desabilitada no arquivo PHP (`CURLOPT_SSL_VERIFYPEER => false`)
- ✅ Isso é apenas para teste local
- ⚠️ Em produção, SSL deve estar habilitado

### **2. Timeout:**
- ⏱️ Timeout de 30 segundos (pode ser ajustado)
- ⏱️ Timeout de conexão de 10 segundos

### **3. Dados de Teste:**
- 📋 Dados simulam "Primeiro Contato - Apenas Telefone"
- 📋 Podem ser modificados no arquivo PHP conforme necessário

### **4. Emails Enviados:**
- 📧 3 emails são enviados (1 para cada administrador)
- 📧 Configurados em `ADMIN_EMAILS` no `aws_ses_config.php`
- 📧 Emails: `lrotero@gmail.com`, `alex.kaminski@imediatoseguros.com.br`, `alexkaminski70@gmail.com`

---

## 📝 EXEMPLO DE SAÍDA

```
=== TESTE DE ENVIO DE EMAIL - PRODUÇÃO ===

📋 Dados de teste:
Array
(
    [ddd] => 11
    [celular] => 987654321
    [nome] => Teste Sistema Email
    ...
)

📤 Enviando requisição para: https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php

📊 Status HTTP: 200

📧 RESULTADO:
{
    "success": true,
    "total_sent": 3,
    "total_failed": 0,
    "total_recipients": 3,
    "results": [...]
}

✅ SUCESSO!
   📧 Total enviados: 3
   ❌ Total falhados: 0
   👥 Total destinatários: 3

✅ PERFEITO! 3 emails enviados (1 para cada administrador)
   Verifique as caixas de entrada de:
   ✅ lrotero@gmail.com
   ✅ alex.kaminski@imediatoseguros.com.br
   ✅ alexkaminski70@gmail.com

=== TESTE CONCLUÍDO ===
```

---

## 🔗 ARQUIVOS RELACIONADOS

- **Arquivo de Teste:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/test_email_prod_3_emails.php`
- **Endpoint:** `send_email_notification_endpoint.php`
- **Configuração:** `aws_ses_config.php`
- **Função de Envio:** `send_admin_notification_ses.php`

---

**Documento criado em:** 16/11/2025  
**Última atualização:** 16/11/2025

