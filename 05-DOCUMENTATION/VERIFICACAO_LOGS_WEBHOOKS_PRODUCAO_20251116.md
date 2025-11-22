# 📋 Verificação de Logs dos Webhooks - Produção

**Data:** 16/11/2025  
**Servidor:** `prod.bssegurosimediato.com.br` (157.180.36.223)  
**Status:** 🔍 **AGUARDANDO SUBMISSÃO DO FORMULÁRIO**

---

## 🎯 OBJETIVO

Verificar os logs dos webhooks `add_flyingdonkeys.php` e `add_webflow_octa.php` após submissão do formulário no website de produção.

---

## 📂 LOCALIZAÇÃO DOS LOGS

### **1. add_flyingdonkeys.php**

**Arquivo de Log:** `flyingdonkeys_prod.txt`  
**Caminho Completo:** `/var/log/webflow-segurosimediato/flyingdonkeys_prod.txt`  
**Formato:** JSON com prefixo `[PROD-FLYINGDONKEYS]`

### **2. add_webflow_octa.php**

**Arquivo de Log:** `webhook_octadesk_prod.txt`  
**Caminho Completo:** `/var/log/webflow-segurosimediato/webhook_octadesk_prod.txt`  
**Formato:** Texto com prefixo `[OCTADESK-PROD]`

---

## 🔍 COMANDOS PARA VERIFICAÇÃO

### **1. Verificar Última Modificação (Antes da Submissão)**

```bash
# Verificar timestamp atual dos arquivos
ssh root@157.180.36.223 "stat -c '%y' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt"
ssh root@157.180.36.223 "stat -c '%y' /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt"
```

### **2. Ver Últimas Linhas dos Logs (Após Submissão)**

```bash
# Últimas 20 linhas do log do FlyingDonkeys
ssh root@157.180.36.223 "tail -n 20 /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt"

# Últimas 20 linhas do log do OctaDesk
ssh root@157.180.36.223 "tail -n 20 /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt"
```

### **3. Verificar Eventos Específicos**

```bash
# Buscar validação de assinatura no FlyingDonkeys
ssh root@157.180.36.223 "grep 'signature_validation' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 5"

# Buscar validação de assinatura no OctaDesk
ssh root@157.180.36.223 "grep 'signature_validation' /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt | tail -n 5"

# Buscar criação de lead (FlyingDonkeys)
ssh root@157.180.36.223 "grep 'flyingdonkeys_lead_created' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 5"

# Buscar sucesso no OctaDesk
ssh root@157.180.36.223 "grep 'webhook_success' /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt | tail -n 5"
```

### **4. Verificar Erros**

```bash
# Erros no FlyingDonkeys
ssh root@157.180.36.223 "grep -i '\"success\":false\|exception\|error' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 10"

# Erros no OctaDesk
ssh root@157.180.36.223 "grep -i 'ERROR\|error\|exception' /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt | tail -n 10"
```

### **5. Verificar Logs de Hoje**

```bash
# FlyingDonkeys - hoje
ssh root@157.180.36.223 "grep \"\$(date +%Y-%m-%d)\" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 20"

# OctaDesk - hoje
ssh root@157.180.36.223 "grep \"\$(date +%Y-%m-%d)\" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt | tail -n 20"
```

---

## 📊 EVENTOS ESPERADOS NOS LOGS

### **add_flyingdonkeys.php**

1. ✅ `webhook_started` - Início do processamento
2. ✅ `signature_validation` - Validação de assinatura (status: valid)
3. ✅ `data_received` - Dados recebidos
4. ✅ `flyingdonkeys_lead_creation_started` - Início da criação de lead
5. ✅ `flyingdonkeys_lead_created` - Lead criado com sucesso

### **add_webflow_octa.php**

1. ✅ `webhook_received` - Webhook recebido
2. ✅ `signature_validation` - Validação de assinatura (status: valid)
3. ✅ `contact_data_mapped` - Dados do contato mapeados
4. ✅ `webhook_success` - Webhook processado com sucesso

---

## ⚠️ POSSÍVEIS PROBLEMAS

### **1. Validação de Assinatura Falhou**

**Sintoma:**
- `signature_validation` com `status: failed` ou `status: missing`
- `"success":false` no log

**Causa Possível:**
- Secret key incorreta no PHP-FPM
- Timestamp inválido
- Payload corrompido

### **2. Erro na Criação de Lead**

**Sintoma:**
- `flyingdonkeys_exception` no log
- `"success":false` após `flyingdonkeys_lead_creation_started`

**Causa Possível:**
- Erro na API do EspoCRM
- Credenciais incorretas
- Dados inválidos

### **3. Erro no OctaDesk**

**Sintoma:**
- `webhook_error` no log
- `ERROR` no status

**Causa Possível:**
- Erro na API do OctaDesk
- Telefone inválido
- API key incorreta

---

## 📝 PRÓXIMOS PASSOS

Após submissão do formulário:

1. ✅ Verificar última modificação dos arquivos de log
2. ✅ Ver últimas linhas dos logs
3. ✅ Verificar eventos específicos (signature_validation, success, etc.)
4. ✅ Verificar se há erros
5. ✅ Analisar se webhooks foram processados corretamente

---

**Status:** 🔍 **AGUARDANDO SUBMISSÃO DO FORMULÁRIO**

