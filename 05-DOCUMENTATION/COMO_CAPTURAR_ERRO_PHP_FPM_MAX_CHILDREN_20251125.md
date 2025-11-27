# 🔍 COMO CAPTURAR ERRO PHP-FPM "server reached pm.max_children"

**Data:** 25/11/2025  
**Contexto:** Métodos para capturar e monitorar erro de PHP-FPM max_children

---

## 📋 RESUMO EXECUTIVO

### **Erro a Capturar:**
```
WARNING: [pool www] server reached pm.max_children setting (5)
```

### **Métodos Disponíveis:**

1. ✅ **Logs do PHP-FPM** (já existe - automático)
2. ✅ **Scripts de busca** (manual ou agendado)
3. ✅ **Monitoramento em tempo real** (watch, tail -f)
4. ✅ **Alertas automáticos** (cron + email)
5. ✅ **Integração com sistema de logging** (Graylog, ELK, etc.)

---

## 🔍 MÉTODO 1: Logs do PHP-FPM (Automático)

### **Localização do Log:**

**Produção:**
```bash
/var/log/php8.3-fpm.log
```

**Desenvolvimento:**
```bash
/var/log/php8.3-fpm.log
```

### **O Erro Já É Capturado Automaticamente:**

O PHP-FPM **já registra automaticamente** esse erro no log quando o limite é atingido.

**Formato do Log:**
```
[25-Nov-2025 12:56:32] WARNING: [pool www] server reached pm.max_children setting (5), consider raising it
```

### **Verificar se Erro Ocorreu:**

```bash
# Buscar ocorrências do erro
grep "reached pm.max_children" /var/log/php8.3-fpm.log

# Contar quantas vezes ocorreu
grep "reached pm.max_children" /var/log/php8.3-fpm.log | wc -l

# Buscar ocorrências nas últimas 24 horas
grep "reached pm.max_children" /var/log/php8.3-fpm.log | grep "$(date +%d-%b-%Y)"

# Buscar ocorrências em um período específico
grep "reached pm.max_children" /var/log/php8.3-fpm.log | grep "25-Nov-2025"
```

---

## 📊 MÉTODO 2: Scripts de Busca (Manual ou Agendado)

### **Script 1: Buscar Erros Recentes**

**Arquivo:** `buscar_erros_php_fpm.sh`

```bash
#!/bin/bash
# Buscar erros de PHP-FPM max_children nas últimas 24 horas

LOG_FILE="/var/log/php8.3-fpm.log"
DATE_TODAY=$(date +%d-%b-%Y)

echo "=== Erros de PHP-FPM max_children nas últimas 24 horas ==="
echo ""

# Buscar erros de hoje
grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | tail -20

echo ""
echo "=== Total de ocorrências hoje ==="
grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | wc -l
```

**Uso:**
```bash
chmod +x buscar_erros_php_fpm.sh
./buscar_erros_php_fpm.sh
```

---

### **Script 2: Monitorar em Tempo Real**

**Arquivo:** `monitorar_php_fpm.sh`

```bash
#!/bin/bash
# Monitorar erros de PHP-FPM em tempo real

LOG_FILE="/var/log/php8.3-fpm.log"

echo "=== Monitorando erros de PHP-FPM max_children (Ctrl+C para sair) ==="
echo ""

tail -f "$LOG_FILE" | grep --line-buffered "reached pm.max_children"
```

**Uso:**
```bash
chmod +x monitorar_php_fpm.sh
./monitorar_php_fpm.sh
```

---

### **Script 3: Estatísticas de Erros**

**Arquivo:** `estatisticas_php_fpm.sh`

```bash
#!/bin/bash
# Estatísticas de erros de PHP-FPM max_children

LOG_FILE="/var/log/php8.3-fpm.log"
DATE_TODAY=$(date +%d-%b-%Y)
DATE_YESTERDAY=$(date -d "yesterday" +%d-%b-%Y 2>/dev/null || date -v-1d +%d-%b-%Y 2>/dev/null)

echo "=== Estatísticas de Erros PHP-FPM max_children ==="
echo ""

# Total de ocorrências hoje
TODAY_COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | wc -l)

# Total de ocorrências ontem
YESTERDAY_COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_YESTERDAY" | wc -l)

# Total geral
TOTAL_COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | wc -l)

echo "Hoje ($DATE_TODAY): $TODAY_COUNT ocorrências"
echo "Ontem ($DATE_YESTERDAY): $YESTERDAY_COUNT ocorrências"
echo "Total geral: $TOTAL_COUNT ocorrências"
echo ""

# Últimas 10 ocorrências
echo "=== Últimas 10 ocorrências ==="
grep "reached pm.max_children" "$LOG_FILE" | tail -10
```

**Uso:**
```bash
chmod +x estatisticas_php_fpm.sh
./estatisticas_php_fpm.sh
```

---

## 🚨 MÉTODO 3: Alertas Automáticos (Cron + Email)

### **Script de Alerta:**

**Arquivo:** `alerta_php_fpm_max_children.sh`

```bash
#!/bin/bash
# Alerta automático para erros de PHP-FPM max_children

LOG_FILE="/var/log/php8.3-fpm.log"
DATE_TODAY=$(date +%d-%b-%Y)
THRESHOLD=5  # Alertar se houver mais de 5 ocorrências hoje

# Contar ocorrências de hoje
COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | wc -l)

if [ "$COUNT" -gt "$THRESHOLD" ]; then
    # Enviar email de alerta
    SUBJECT="⚠️ ALERTA: PHP-FPM max_children atingido $COUNT vezes hoje"
    BODY="O limite de PHP-FPM max_children foi atingido $COUNT vezes hoje ($DATE_TODAY).\n\n"
    BODY+="Últimas ocorrências:\n"
    BODY+="$(grep 'reached pm.max_children' "$LOG_FILE" | grep "$DATE_TODAY" | tail -10)\n\n"
    BODY+="Ação recomendada: Verificar carga do servidor e considerar aumentar pm.max_children."
    
    # Enviar email (ajustar comando conforme sistema de email)
    echo -e "$BODY" | mail -s "$SUBJECT" admin@bssegurosimediato.com.br
    
    # Ou usar sendmail
    # echo -e "$BODY" | sendmail admin@bssegurosimediato.com.br
    
    echo "Alerta enviado: $COUNT ocorrências detectadas"
else
    echo "OK: $COUNT ocorrências (abaixo do threshold de $THRESHOLD)"
fi
```

### **Configurar Cron para Executar a Cada Hora:**

```bash
# Editar crontab
crontab -e

# Adicionar linha (executar a cada hora)
0 * * * * /path/to/alerta_php_fpm_max_children.sh >> /var/log/php_fpm_alerts.log 2>&1
```

---

## 📈 MÉTODO 4: Monitoramento em Tempo Real (Watch)

### **Comando Watch:**

```bash
# Monitorar a cada 5 segundos
watch -n 5 'grep "reached pm.max_children" /var/log/php8.3-fpm.log | tail -10'

# Monitorar contagem
watch -n 5 'echo "Ocorrências hoje: $(grep \"reached pm.max_children\" /var/log/php8.3-fpm.log | grep \"$(date +%d-%b-%Y)\" | wc -l)"'
```

---

## 🔧 MÉTODO 5: Integração com Sistema de Logging

### **Opção 1: Graylog**

**Configurar PHP-FPM para enviar logs ao Graylog:**

1. Instalar `rsyslog` ou `syslog-ng`
2. Configurar para enviar logs do PHP-FPM ao Graylog
3. Criar dashboard no Graylog para monitorar erros

**Vantagens:**
- ✅ Centralização de logs
- ✅ Alertas automáticos
- ✅ Dashboards visuais
- ✅ Histórico completo

**Desvantagens:**
- ⚠️ Requer infraestrutura adicional
- ⚠️ Mais complexo de configurar

---

### **Opção 2: ELK Stack (Elasticsearch, Logstash, Kibana)**

**Configurar Logstash para processar logs do PHP-FPM:**

1. Instalar Logstash
2. Configurar input para ler `/var/log/php8.3-fpm.log`
3. Criar filtros para identificar erros de max_children
4. Enviar para Elasticsearch
5. Criar visualizações no Kibana

**Vantagens:**
- ✅ Busca poderosa
- ✅ Visualizações avançadas
- ✅ Alertas configuráveis

**Desvantagens:**
- ⚠️ Requer infraestrutura significativa
- ⚠️ Consome recursos

---

### **Opção 3: Sistema de Logging Simples (Recomendado para Início)**

**Criar API/Endpoint para consultar logs:**

```php
<?php
// api_php_fpm_status.php

header('Content-Type: application/json');

$logFile = '/var/log/php8.3-fpm.log';
$dateToday = date('d-M-Y');

// Buscar erros de hoje
$command = "grep 'reached pm.max_children' $logFile | grep '$dateToday'";
$output = shell_exec($command);
$lines = explode("\n", trim($output));

$errors = [];
foreach ($lines as $line) {
    if (!empty($line)) {
        $errors[] = $line;
    }
}

echo json_encode([
    'date' => $dateToday,
    'count' => count($errors),
    'errors' => array_slice($errors, -20) // Últimas 20
], JSON_PRETTY_PRINT);
```

**Acesso:**
```bash
curl https://prod.bssegurosimediato.com.br/api_php_fpm_status.php
```

---

## 📊 MÉTODO 6: Monitoramento via PHP-FPM Status

### **Habilitar Status do PHP-FPM:**

**Editar `/etc/php/8.3/fpm/pool.d/www.conf`:**
```ini
pm.status_path = /status
ping.path = /ping
```

**Configurar Nginx:**
```nginx
location ~ ^/(status|ping)$ {
    access_log off;
    allow 127.0.0.1;
    deny all;
    include fastcgi_params;
    fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
```

**Acessar Status:**
```bash
curl http://localhost/status
```

**Informações Retornadas:**
- `active processes`: Processos ativos
- `max active processes`: Máximo de processos ativos
- `max children reached`: Quantas vezes o limite foi atingido

**Monitorar:**
```bash
# Verificar se max_children foi atingido
curl -s http://localhost/status | grep "max children reached"
```

---

## ✅ RECOMENDAÇÃO: Solução Híbrida

### **Para Início (Imediato):**

1. ✅ **Usar logs do PHP-FPM** (já existe)
2. ✅ **Criar script de busca** (`buscar_erros_php_fpm.sh`)
3. ✅ **Configurar cron para alertas** (se ocorrências > threshold)

### **Para Médio Prazo:**

1. ✅ **Criar API simples** para consultar status
2. ✅ **Dashboard básico** (HTML + JavaScript)
3. ✅ **Alertas por email** automáticos

### **Para Longo Prazo (Se Necessário):**

1. ✅ **Graylog ou ELK Stack** (se volume de logs crescer)
2. ✅ **Monitoramento profissional** (Prometheus + Grafana)
3. ✅ **Alertas avançados** (Slack, PagerDuty, etc.)

---

## 📝 EXEMPLO PRÁTICO: Script Completo

**Arquivo:** `monitor_php_fpm_max_children.sh`

```bash
#!/bin/bash
# Monitor completo de erros PHP-FPM max_children

LOG_FILE="/var/log/php8.3-fpm.log"
DATE_TODAY=$(date +%d-%b-%Y)
ALERT_EMAIL="admin@bssegurosimediato.com.br"
THRESHOLD=5

echo "=== Monitor PHP-FPM max_children ==="
echo "Data: $DATE_TODAY"
echo ""

# Contar ocorrências
COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | wc -l)

echo "Ocorrências hoje: $COUNT"

if [ "$COUNT" -gt "$THRESHOLD" ]; then
    echo "⚠️ ALERTA: Threshold excedido!"
    
    # Últimas ocorrências
    echo ""
    echo "Últimas 10 ocorrências:"
    grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | tail -10
    
    # Enviar alerta (se configurado)
    if [ -n "$ALERT_EMAIL" ]; then
        SUBJECT="⚠️ ALERTA: PHP-FPM max_children - $COUNT ocorrências hoje"
        BODY="O limite de PHP-FPM max_children foi atingido $COUNT vezes hoje.\n\n"
        BODY+="Ação recomendada: Verificar carga do servidor."
        echo -e "$BODY" | mail -s "$SUBJECT" "$ALERT_EMAIL"
        echo "Alerta enviado para $ALERT_EMAIL"
    fi
else
    echo "✅ OK: Abaixo do threshold ($THRESHOLD)"
fi

echo ""
echo "=== Últimas 5 ocorrências ==="
grep "reached pm.max_children" "$LOG_FILE" | tail -5
```

**Uso:**
```bash
chmod +x monitor_php_fpm_max_children.sh
./monitor_php_fpm_max_children.sh

# Ou agendar no cron (a cada hora)
0 * * * * /path/to/monitor_php_fpm_max_children.sh
```

---

## 🎯 CONCLUSÃO

### **Métodos Disponíveis:**

1. ✅ **Logs do PHP-FPM** - Já existe, automático
2. ✅ **Scripts de busca** - Manual ou agendado
3. ✅ **Monitoramento em tempo real** - `tail -f` ou `watch`
4. ✅ **Alertas automáticos** - Cron + email
5. ✅ **Integração com sistema de logging** - Graylog, ELK, etc.
6. ✅ **PHP-FPM Status** - Endpoint `/status`

### **Recomendação Imediata:**

1. ✅ Usar logs do PHP-FPM (já existe)
2. ✅ Criar script de busca (`buscar_erros_php_fpm.sh`)
3. ✅ Configurar cron para alertas se necessário

**O erro já é capturado automaticamente nos logs do PHP-FPM. Basta consultar o log quando necessário.**

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **GUIA COMPLETO - MÚLTIPLAS OPÇÕES DISPONÍVEIS**

