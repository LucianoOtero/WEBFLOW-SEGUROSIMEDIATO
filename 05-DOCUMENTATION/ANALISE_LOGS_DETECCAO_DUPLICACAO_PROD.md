# 📋 Análise: Logs Detecção de Duplicação - PROD

**Data:** 16/11/2025  
**Ambiente:** Produção (PROD)  
**Objetivo:** Verificar se a correção de detecção de duplicação está funcionando corretamente

---

## 🎯 OBJETIVOS DA ANÁLISE

### **1. Verificar Detecção de Duplicação de LEAD**

**O que verificar:**
- ✅ Exception capturada com código HTTP 409
- ✅ Log `flyingdonkeys_exception` contém `http_code: 409`
- ✅ Log `duplicate_lead_detected` foi gerado
- ✅ Log `existing_lead_found` foi gerado (se lead encontrado)
- ✅ Log `lead_updated` foi gerado (se atualização bem-sucedida)

**Comandos para verificar:**
```bash
# Ver últimas linhas do log
tail -n 50 /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt

# Buscar por exceções com código 409
grep -i "http_code.*409" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 10

# Buscar por detecção de duplicação
grep -i "duplicate_lead_detected" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 10

# Buscar por atualização de lead
grep -i "lead_updated" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 10
```

---

### **2. Verificar Detecção de Duplicação de OPPORTUNITY**

**O que verificar:**
- ✅ Exception capturada com código HTTP 409
- ✅ Log `opportunity_exception` contém `http_code: 409`
- ✅ Log `duplicate_opportunity_detected` foi gerado
- ✅ Log `duplicate_opportunity_created` foi gerado (se criação bem-sucedida)

**Comandos para verificar:**
```bash
# Buscar por exceções de oportunidade com código 409
grep -i "opportunity_exception" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | grep -i "http_code.*409" | tail -n 10

# Buscar por detecção de duplicação de oportunidade
grep -i "duplicate_opportunity_detected" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 10

# Buscar por criação de oportunidade duplicada
grep -i "duplicate_opportunity_created" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 10
```

---

### **3. Verificar Logs do OctaDesk**

**O que verificar:**
- ✅ Webhook `add_webflow_octa.php` foi chamado
- ✅ Processamento bem-sucedido

**Comandos para verificar:**
```bash
# Ver últimas linhas do log
tail -n 50 /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Buscar por erros
grep -i "error\|exception\|failed" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt | tail -n 10
```

---

### **4. Verificar Logs do Banco de Dados**

**O que verificar:**
- ✅ Logs inseridos no banco `rpa_logs_prod`
- ✅ Tabela `application_logs` contém registros recentes

**Comandos para verificar:**
```bash
# Conectar ao banco e verificar logs recentes
mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt -h localhost rpa_logs_prod -e "SELECT id, log_id, level, category, message, timestamp FROM application_logs ORDER BY timestamp DESC LIMIT 10;"
```

---

## 📊 CHECKLIST DE VERIFICAÇÃO

### **Cenário 1: Duplicação Detectada Corretamente (SUCESSO)**

- [ ] `flyingdonkeys_exception` contém `http_code: 409`
- [ ] `duplicate_lead_detected` foi gerado
- [ ] `existing_lead_found` foi gerado (se lead encontrado)
- [ ] `lead_updated` foi gerado (se atualização bem-sucedida)
- [ ] `duplicate_opportunity_detected` foi gerado (se aplicável)
- [ ] `duplicate_opportunity_created` foi gerado (se aplicável)
- [ ] Nenhum log `real_error_creating_lead` ou `real_error_creating_opportunity`

### **Cenário 2: Erro Real (Não Duplicação)**

- [ ] `flyingdonkeys_exception` contém `http_code` diferente de 409
- [ ] `real_error_creating_lead` ou `real_error_creating_opportunity` foi gerado
- [ ] Nenhum log `duplicate_lead_detected` ou `duplicate_opportunity_detected`

### **Cenário 3: Criação Bem-Sucedida (Sem Duplicação)**

- [ ] `flyingdonkeys_lead_created` foi gerado
- [ ] `opportunity_created` foi gerado
- [ ] Nenhum log de exceção

---

## 🔍 COMANDOS DE ANÁLISE RÁPIDA

### **Verificar Últimas Entradas (Todas)**
```bash
# FlyingDonkeys
tail -n 100 /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt

# OctaDesk
tail -n 100 /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
```

### **Buscar por Timestamp Específico**
```bash
# Substituir YYYY-MM-DD HH:MM:SS pelo timestamp da submissão
grep "YYYY-MM-DD HH:MM:SS" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
```

### **Buscar por Request ID**
```bash
# Substituir REQUEST_ID pelo ID da requisição
grep "REQUEST_ID" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt
```

---

## 📝 TEMPLATE DE ANÁLISE

### **Timestamp da Submissão:**
- Data/Hora: `_________________`

### **Request ID:**
- ID: `_________________`

### **Resultados:**

#### **LEAD:**
- [ ] Duplicação detectada: `SIM / NÃO`
- [ ] Código HTTP: `_____`
- [ ] Lead atualizado: `SIM / NÃO`
- [ ] Lead ID: `_________________`

#### **OPPORTUNITY:**
- [ ] Duplicação detectada: `SIM / NÃO`
- [ ] Código HTTP: `_____`
- [ ] Oportunidade criada: `SIM / NÃO`
- [ ] Oportunidade ID: `_________________`

#### **OctaDesk:**
- [ ] Webhook processado: `SIM / NÃO`
- [ ] Erros: `SIM / NÃO`
- [ ] Detalhes: `_________________`

---

**Status:** ⏳ **AGUARDANDO SUBMISSÃO DO FORMULÁRIO**

