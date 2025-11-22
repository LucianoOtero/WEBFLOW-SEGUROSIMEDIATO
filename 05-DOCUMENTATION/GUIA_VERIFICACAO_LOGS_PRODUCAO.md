# 📋 GUIA: Verificação de Logs - Ambiente de Produção

**Data:** 16/11/2025  
**Servidor:** `prod.bssegurosimediato.com.br` (157.180.36.223)  
**Status:** ✅ **GUIA PREPARADO**

---

## 🎯 OBJETIVO

Este guia documenta como verificar os logs dos webhooks e do sistema de envio de emails no ambiente de produção.

---

## 📂 LOCALIZAÇÃO DOS ARQUIVOS DE LOG

### **Diretório Base de Logs**

**Caminho:** `/var/log/webflow-segurosimediato/`

**Variável de Ambiente:** `LOG_DIR = /var/log/webflow-segurosimediato`

**Permissões:** `755 www-data:www-data`

---

## 📋 ARQUIVOS DE LOG DOS WEBHOOKS

### **1. add_flyingdonkeys.php**

**Arquivo de Log:** `flyingdonkeys_prod.txt`

**Caminho Completo:**
```
/var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
```

**Formato do Log:**
- Prefixo: `[PROD-FLYINGDONKEYS]`
- Formato: JSON com timestamp, environment, webhook, event, success, data, request_id, memory_usage, execution_time

**Eventos Principais:**
- `webhook_started` - Início do processamento
- `signature_validation` - Validação de assinatura
- `data_received` - Dados recebidos
- `flyingdonkeys_lead_creation_started` - Início da criação de lead
- `flyingdonkeys_lead_created` - Lead criado com sucesso
- `flyingdonkeys_exception` - Erros/exceções

---

### **2. add_webflow_octa.php**

**Arquivo de Log:** `webhook_octadesk_prod.txt`

**Caminho Completo:**
```
/var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
```

**Formato do Log:**
- Prefixo: `[OCTADESK-PROD]`
- Formato: `[timestamp] [STATUS] [OCTADESK-PROD] action | Data: {...}`

**Eventos Principais:**
- `webhook_received` - Webhook recebido
- `signature_validation` - Validação de assinatura
- `contact_data_mapped` - Dados do contato mapeados
- `webhook_success` - Webhook processado com sucesso
- `webhook_error` - Erros no processamento

---

## 📧 LOGS DO SISTEMA DE ENVIO DE EMAILS

### **1. send_email_notification_endpoint.php**

**Arquivo de Log:** `professional_logger_errors.txt` (apenas em caso de erro)

**Caminho Completo:**
```
/var/log/webflow-segurosimediato/professional_logger_errors.txt
```

**Observação:** Este endpoint usa `ProfessionalLogger` que escreve no banco de dados. Logs de arquivo só são criados em caso de erro ao inserir no banco.

---

### **2. send_admin_notification_ses.php**

**Arquivo de Log:** `professional_logger_errors.txt` (apenas em caso de erro)

**Caminho Completo:**
```
/var/log/webflow-segurosimediato/professional_logger_errors.txt
```

**Observação:** Este endpoint também usa `ProfessionalLogger` que escreve no banco de dados. Logs de arquivo só são criados em caso de erro ao inserir no banco.

---

### **3. Logs de Email via ProfessionalLogger**

**Banco de Dados:**
- **Tabela:** `rpa_logs_prod` (ambiente PROD)
- **Usuário:** `rpa_logger_prod`
- **Host:** `localhost`

**Observação:** Os logs de envio de emails são armazenados principalmente no banco de dados via `ProfessionalLogger`. Para verificar logs de email, é necessário consultar o banco de dados.

---

## 🔍 COMANDOS PARA VERIFICAÇÃO

### **1. Verificar Existência dos Arquivos de Log**

```bash
# Conectar ao servidor PROD
ssh root@157.180.36.223

# Verificar diretório de logs
ls -lh /var/log/webflow-segurosimediato/

# Verificar se arquivos específicos existem
ls -lh /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
ls -lh /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
ls -lh /var/log/webflow-segurosimediato/professional_logger_errors.txt
```

---

### **2. Ver Últimas Linhas dos Logs**

```bash
# Últimas 50 linhas do log do FlyingDonkeys
tail -n 50 /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt

# Últimas 50 linhas do log do OctaDesk
tail -n 50 /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Últimas 50 linhas do log de erros
tail -n 50 /var/log/webflow-segurosimediato/professional_logger_errors.txt
```

---

### **3. Monitorar Logs em Tempo Real**

```bash
# Monitorar log do FlyingDonkeys em tempo real
tail -f /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt

# Monitorar log do OctaDesk em tempo real
tail -f /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Monitorar log de erros em tempo real
tail -f /var/log/webflow-segurosimediato/professional_logger_errors.txt
```

---

### **4. Buscar Eventos Específicos**

```bash
# Buscar por validação de assinatura
grep "signature_validation" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
grep "signature_validation" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Buscar por erros
grep -i "error\|false\|exception" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
grep -i "error\|false\|exception" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Buscar por sucesso
grep '"success":true' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
grep "SUCCESS" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Buscar por criação de lead
grep "flyingdonkeys_lead_created" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
```

---

### **5. Verificar Tamanho e Última Modificação**

```bash
# Verificar tamanho e última modificação
stat /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
stat /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
stat /var/log/webflow-segurosimediato/professional_logger_errors.txt

# Verificar tamanho em formato legível
ls -lh /var/log/webflow-segurosimediato/*.txt
```

---

### **6. Contar Requisições**

```bash
# Contar requisições bem-sucedidas no FlyingDonkeys
grep -c '"success":true' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt

# Contar requisições com erro no FlyingDonkeys
grep -c '"success":false' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt

# Contar requisições bem-sucedidas no OctaDesk
grep -c "SUCCESS" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Contar total de linhas (aproximadamente requisições)
wc -l /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
wc -l /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
```

---

### **7. Verificar Logs de Email no Banco de Dados**

```bash
# Conectar ao MySQL
mysql -u rpa_logger_prod -p rpa_logs_prod

# Ver últimas 20 entradas de log
SELECT * FROM logs ORDER BY created_at DESC LIMIT 20;

# Ver logs de email especificamente
SELECT * FROM logs WHERE category = 'EMAIL' ORDER BY created_at DESC LIMIT 20;

# Ver logs de erro de email
SELECT * FROM logs WHERE category = 'EMAIL' AND level = 'ERROR' ORDER BY created_at DESC LIMIT 20;

# Sair do MySQL
exit;
```

---

## 📊 RESUMO RÁPIDO

| Log | Arquivo | Caminho Completo (PROD) |
|-----|---------|------------------------|
| `add_flyingdonkeys.php` | `flyingdonkeys_prod.txt` | `/var/log/webflow-segurosimediato/flyingdonkeys_prod.txt` |
| `add_webflow_octa.php` | `webhook_octadesk_prod.txt` | `/var/log/webflow-segurosimediato/webhook_octadesk_prod.txt` |
| Erros do ProfessionalLogger | `professional_logger_errors.txt` | `/var/log/webflow-segurosimediato/professional_logger_errors.txt` |
| Logs de Email | Banco de dados | `rpa_logs_prod.logs` (tabela) |

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **1. Diretório de Logs**
- `$_ENV['LOG_DIR']` está definido no PHP-FPM como `/var/log/webflow-segurosimediato`
- Todos os logs são escritos neste diretório centralizado
- Diretório criado com permissões `755 www-data:www-data`

### **2. Permissões**
- Os arquivos de log são criados automaticamente pelo PHP
- O usuário do PHP-FPM (`www-data`) tem permissão de escrita no diretório

### **3. Logs de Email**
- **Principalmente no banco de dados:** `rpa_logs_prod.logs`
- **Arquivo de log:** Apenas em caso de erro ao inserir no banco (`professional_logger_errors.txt`)

### **4. Monitoramento em Tempo Real**
- Use `tail -f` para monitorar os logs em tempo real durante os testes
- Isso permite ver imediatamente quando uma requisição é processada

---

## 🔧 COMANDOS ÚTEIS PARA ANÁLISE

### **Ver Logs Recentes (Últimas 2 Horas)**

```bash
# FlyingDonkeys - últimas 2 horas
find /var/log/webflow-segurosimediato -name "flyingdonkeys_prod.txt" -mmin -120 -exec tail -n 100 {} \;

# OctaDesk - últimas 2 horas
find /var/log/webflow-segurosimediato -name "webhook_octadesk_prod.txt" -mmin -120 -exec tail -n 100 {} \;
```

### **Ver Apenas Erros**

```bash
# Erros no FlyingDonkeys
grep -i "error\|false\|exception" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 50

# Erros no OctaDesk
grep -i "error\|false\|exception" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt | tail -n 50
```

### **Ver Logs de Hoje**

```bash
# FlyingDonkeys - hoje
grep "$(date +%Y-%m-%d)" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt

# OctaDesk - hoje
grep "$(date +%Y-%m-%d)" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
```

---

## 📝 PRÓXIMOS PASSOS

Após verificar os logs, você pode:

1. ✅ Identificar problemas de validação de assinatura
2. ✅ Verificar se os webhooks estão sendo processados corretamente
3. ✅ Analisar erros de criação de leads
4. ✅ Verificar logs de envio de emails no banco de dados
5. ✅ Monitorar performance e uso de memória

---

**Data de Criação:** 16/11/2025  
**Última Atualização:** 16/11/2025  
**Ambiente:** PROD (`prod.bssegurosimediato.com.br`)

