# 🚨 ALERTAS: Erro PHP-FPM "server reached pm.max_children"

**Data:** 25/11/2025  
**Contexto:** Sistema de alertas para monitorar erro de PHP-FPM max_children

---

## 📋 RESUMO EXECUTIVO

### **Tipos de Alertas Disponíveis:**

1. ✅ **Email** (via sistema de email existente)
2. ✅ **Log em arquivo** (registro de ocorrências)
3. ✅ **Notificação via ProfessionalLogger** (integração com sistema de logging)
4. ✅ **Slack/Telegram** (se configurado)
5. ✅ **SMS** (se configurado)

### **Frequência de Verificação:**

- ⏰ **A cada hora** (recomendado para início)
- ⏰ **A cada 15 minutos** (se problema for crítico)
- ⏰ **A cada 5 minutos** (se problema for muito crítico)

---

## 📧 ALERTA 1: Email (Recomendado)

### **Opção A: Script Bash Simples com `mail`**

**Arquivo:** `alerta_php_fpm_max_children.sh`

```bash
#!/bin/bash
# Alerta por email para erros de PHP-FPM max_children

LOG_FILE="/var/log/php8.3-fpm.log"
DATE_TODAY=$(date +%d-%b-%Y)
THRESHOLD=5  # Alertar se houver mais de 5 ocorrências hoje
ALERT_EMAIL="admin@bssegurosimediato.com.br"

# Contar ocorrências de hoje
COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | wc -l)

if [ "$COUNT" -gt "$THRESHOLD" ]; then
    # Preparar email
    SUBJECT="⚠️ ALERTA: PHP-FPM max_children atingido $COUNT vezes hoje"
    
    BODY="O limite de PHP-FPM max_children foi atingido $COUNT vezes hoje ($DATE_TODAY).\n\n"
    BODY+="=== Detalhes ===\n"
    BODY+="Data: $DATE_TODAY\n"
    BODY+="Ocorrências: $COUNT\n"
    BODY+="Threshold: $THRESHOLD\n"
    BODY+="Servidor: $(hostname)\n\n"
    BODY+="=== Últimas 10 Ocorrências ===\n"
    BODY+="$(grep 'reached pm.max_children' "$LOG_FILE" | grep "$DATE_TODAY" | tail -10)\n\n"
    BODY+="=== Ação Recomendada ===\n"
    BODY+="1. Verificar carga do servidor\n"
    BODY+="2. Verificar se há processos travados\n"
    BODY+="3. Considerar aumentar pm.max_children se problema persistir\n"
    BODY+="4. Verificar logs: tail -50 /var/log/php8.3-fpm.log\n"
    
    # Enviar email
    echo -e "$BODY" | mail -s "$SUBJECT" "$ALERT_EMAIL"
    
    echo "[$(date)] Alerta enviado: $COUNT ocorrências detectadas"
else
    echo "[$(date)] OK: $COUNT ocorrências (abaixo do threshold de $THRESHOLD)"
fi
```

**Configurar no Cron (executar a cada hora):**
```bash
# Editar crontab
crontab -e

# Adicionar linha
0 * * * * /path/to/alerta_php_fpm_max_children.sh >> /var/log/php_fpm_alerts.log 2>&1
```

---

### **Opção B: Usar Sistema de Email Existente (ProfessionalLogger)**

**Arquivo:** `alerta_php_fpm_max_children.php`

```php
<?php
/**
 * Alerta por email para erros de PHP-FPM max_children
 * Usa o sistema ProfessionalLogger existente
 */

require_once __DIR__ . '/ProfessionalLogger.php';

$logFile = '/var/log/php8.3-fpm.log';
$dateToday = date('d-M-Y');
$threshold = 5; // Alertar se houver mais de 5 ocorrências hoje

// Contar ocorrências de hoje
$command = "grep 'reached pm.max_children' $logFile | grep '$dateToday' | wc -l";
$count = (int)trim(shell_exec($command));

if ($count > $threshold) {
    // Buscar últimas ocorrências
    $command = "grep 'reached pm.max_children' $logFile | grep '$dateToday' | tail -10";
    $lastOccurrences = shell_exec($command);
    
    // Preparar mensagem
    $message = "O limite de PHP-FPM max_children foi atingido $count vezes hoje ($dateToday).\n\n";
    $message .= "=== Detalhes ===\n";
    $message .= "Data: $dateToday\n";
    $message .= "Ocorrências: $count\n";
    $message .= "Threshold: $threshold\n";
    $message .= "Servidor: " . gethostname() . "\n\n";
    $message .= "=== Últimas 10 Ocorrências ===\n";
    $message .= $lastOccurrences . "\n\n";
    $message .= "=== Ação Recomendada ===\n";
    $message .= "1. Verificar carga do servidor\n";
    $message .= "2. Verificar se há processos travados\n";
    $message .= "3. Considerar aumentar pm.max_children se problema persistir\n";
    
    // Usar ProfessionalLogger para enviar email
    $logger = new ProfessionalLogger();
    $logger->log('WARNING', $message, [
        'type' => 'php_fpm_max_children_alert',
        'count' => $count,
        'threshold' => $threshold,
        'date' => $dateToday,
        'server' => gethostname()
    ], 'PHP-FPM', null, [
        'file_name' => __FILE__,
        'line_number' => __LINE__,
        'function_name' => __FUNCTION__,
        'class_name' => __CLASS__,
        'timestamp' => date('Y-m-d H:i:s')
    ]);
    
    echo "[$dateToday] Alerta enviado: $count ocorrências detectadas\n";
} else {
    echo "[$dateToday] OK: $count ocorrências (abaixo do threshold de $threshold)\n";
}
```

**Configurar no Cron:**
```bash
# Executar a cada hora
0 * * * * /usr/bin/php /path/to/alerta_php_fpm_max_children.php >> /var/log/php_fpm_alerts.log 2>&1
```

---

## 📝 ALERTA 2: Log em Arquivo

### **Script para Registrar Ocorrências em Arquivo:**

**Arquivo:** `registrar_erros_php_fpm.sh`

```bash
#!/bin/bash
# Registrar erros de PHP-FPM max_children em arquivo

LOG_FILE="/var/log/php8.3-fpm.log"
ALERT_LOG="/var/log/webflow-segurosimediato/php_fpm_max_children_alerts.log"
DATE_TODAY=$(date +%d-%b-%Y)
THRESHOLD=5

# Contar ocorrências de hoje
COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | wc -l)

if [ "$COUNT" -gt "$THRESHOLD" ]; then
    # Registrar em arquivo
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ALERTA: $COUNT ocorrências detectadas hoje" >> "$ALERT_LOG"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Últimas 5 ocorrências:" >> "$ALERT_LOG"
    grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | tail -5 >> "$ALERT_LOG"
    echo "" >> "$ALERT_LOG"
fi
```

**Configurar no Cron:**
```bash
# Executar a cada hora
0 * * * * /path/to/registrar_erros_php_fpm.sh
```

---

## 🔔 ALERTA 3: Notificação via ProfessionalLogger

### **Integração com Sistema de Logging Existente:**

**Arquivo:** `alerta_php_fpm_professional_logger.php`

```php
<?php
/**
 * Alerta via ProfessionalLogger para erros de PHP-FPM max_children
 */

require_once __DIR__ . '/ProfessionalLogger.php';

$logFile = '/var/log/php8.3-fpm.log';
$dateToday = date('d-M-Y');
$threshold = 5;

// Contar ocorrências de hoje
$command = "grep 'reached pm.max_children' $logFile | grep '$dateToday' | wc -l";
$count = (int)trim(shell_exec($command));

if ($count > $threshold) {
    // Buscar últimas ocorrências
    $command = "grep 'reached pm.max_children' $logFile | grep '$dateToday' | tail -10";
    $lastOccurrences = explode("\n", trim(shell_exec($command)));
    
    // Preparar dados
    $data = [
        'type' => 'php_fpm_max_children_alert',
        'count' => $count,
        'threshold' => $threshold,
        'date' => $dateToday,
        'server' => gethostname(),
        'last_occurrences' => $lastOccurrences
    ];
    
    // Usar ProfessionalLogger
    $logger = new ProfessionalLogger();
    $logger->log('WARNING', "PHP-FPM max_children atingido $count vezes hoje", $data, 'PHP-FPM');
    
    echo "[$dateToday] Alerta registrado: $count ocorrências\n";
} else {
    echo "[$dateToday] OK: $count ocorrências\n";
}
```

**Vantagens:**
- ✅ Integra com sistema de logging existente
- ✅ Email automático via ProfessionalLogger
- ✅ Registro no banco de dados
- ✅ Histórico completo

---

## 📊 ALERTA 4: Dashboard/API (Consulta Manual)

### **Criar Endpoint para Consultar Status:**

**Arquivo:** `api_php_fpm_status.php`

```php
<?php
/**
 * API para consultar status de PHP-FPM max_children
 */

header('Content-Type: application/json');

$logFile = '/var/log/php8.3-fpm.log';
$dateToday = date('d-M-Y');
$dateYesterday = date('d-M-Y', strtotime('-1 day'));

// Contar ocorrências de hoje
$command = "grep 'reached pm.max_children' $logFile | grep '$dateToday' | wc -l";
$countToday = (int)trim(shell_exec($command));

// Contar ocorrências de ontem
$command = "grep 'reached pm.max_children' $logFile | grep '$dateYesterday' | wc -l";
$countYesterday = (int)trim(shell_exec($command));

// Buscar últimas ocorrências
$command = "grep 'reached pm.max_children' $logFile | grep '$dateToday' | tail -10";
$lastOccurrences = explode("\n", trim(shell_exec($command) ?: ''));

// Status
$status = $countToday > 5 ? 'WARNING' : 'OK';

echo json_encode([
    'status' => $status,
    'date' => $dateToday,
    'count_today' => $countToday,
    'count_yesterday' => $countYesterday,
    'threshold' => 5,
    'last_occurrences' => array_filter($lastOccurrences),
    'server' => gethostname()
], JSON_PRETTY_PRINT);
```

**Acesso:**
```bash
curl https://prod.bssegurosimediato.com.br/api_php_fpm_status.php
```

**Resposta:**
```json
{
    "status": "WARNING",
    "date": "25-Nov-2025",
    "count_today": 8,
    "count_yesterday": 3,
    "threshold": 5,
    "last_occurrences": [
        "[25-Nov-2025 12:56:32] WARNING: [pool www] server reached pm.max_children setting (5)",
        "[25-Nov-2025 12:57:02] WARNING: [pool www] server reached pm.max_children setting (5)"
    ],
    "server": "prod.bssegurosimediato.com.br"
}
```

---

## 🎯 ALERTA 5: Monitoramento Contínuo (Watch)

### **Script para Monitoramento em Tempo Real:**

**Arquivo:** `monitor_php_fpm_continuo.sh`

```bash
#!/bin/bash
# Monitoramento contínuo de erros PHP-FPM max_children

LOG_FILE="/var/log/php8.3-fpm.log"
ALERT_LOG="/var/log/webflow-segurosimediato/php_fpm_monitor.log"
THRESHOLD=5
CHECK_INTERVAL=300  # Verificar a cada 5 minutos

echo "[$(date)] Iniciando monitoramento contínuo de PHP-FPM max_children"
echo "[$(date)] Threshold: $THRESHOLD ocorrências"
echo "[$(date)] Intervalo de verificação: $CHECK_INTERVAL segundos"
echo ""

while true; do
    DATE_TODAY=$(date +%d-%b-%Y)
    COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | wc -l)
    
    if [ "$COUNT" -gt "$THRESHOLD" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️ ALERTA: $COUNT ocorrências detectadas hoje" | tee -a "$ALERT_LOG"
        
        # Enviar email (se configurado)
        # echo "Alerta: $COUNT ocorrências" | mail -s "Alerta PHP-FPM" admin@bssegurosimediato.com.br
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] OK: $COUNT ocorrências"
    fi
    
    sleep $CHECK_INTERVAL
done
```

**Executar como serviço:**
```bash
# Criar serviço systemd
sudo nano /etc/systemd/system/php-fpm-monitor.service
```

**Conteúdo do serviço:**
```ini
[Unit]
Description=PHP-FPM Max Children Monitor
After=network.target

[Service]
Type=simple
ExecStart=/path/to/monitor_php_fpm_continuo.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Ativar serviço:**
```bash
sudo systemctl enable php-fpm-monitor
sudo systemctl start php-fpm-monitor
```

---

## 📋 EXEMPLO COMPLETO: Sistema de Alertas Híbrido

### **Solução Recomendada (Combinação de Métodos):**

**1. Script Principal (`alerta_php_fpm_completo.sh`):**

```bash
#!/bin/bash
# Sistema completo de alertas para PHP-FPM max_children

LOG_FILE="/var/log/php8.3-fpm.log"
ALERT_LOG="/var/log/webflow-segurosimediato/php_fpm_alerts.log"
DATE_TODAY=$(date +%d-%b-%Y)
THRESHOLD=5
ALERT_EMAIL="admin@bssegurosimediato.com.br"

# Contar ocorrências de hoje
COUNT=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | wc -l)

# Registrar em arquivo sempre
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Verificação: $COUNT ocorrências hoje" >> "$ALERT_LOG"

if [ "$COUNT" -gt "$THRESHOLD" ]; then
    # Buscar últimas ocorrências
    LAST_OCCURRENCES=$(grep "reached pm.max_children" "$LOG_FILE" | grep "$DATE_TODAY" | tail -10)
    
    # Preparar email
    SUBJECT="⚠️ ALERTA: PHP-FPM max_children - $COUNT ocorrências hoje"
    BODY="O limite de PHP-FPM max_children foi atingido $COUNT vezes hoje.\n\n"
    BODY+="=== Detalhes ===\n"
    BODY+="Data: $DATE_TODAY\n"
    BODY+="Ocorrências: $COUNT\n"
    BODY+="Threshold: $THRESHOLD\n"
    BODY+="Servidor: $(hostname)\n\n"
    BODY+="=== Últimas 10 Ocorrências ===\n"
    BODY+="$LAST_OCCURRENCES\n\n"
    BODY+="=== Ação Recomendada ===\n"
    BODY+="1. Verificar carga: top, htop, uptime\n"
    BODY+="2. Verificar processos: ps aux | grep php-fpm\n"
    BODY+="3. Verificar logs: tail -50 /var/log/php8.3-fpm.log\n"
    BODY+="4. Considerar aumentar pm.max_children se problema persistir\n"
    
    # Enviar email
    echo -e "$BODY" | mail -s "$SUBJECT" "$ALERT_EMAIL"
    
    # Registrar alerta em arquivo
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️ ALERTA ENVIADO: $COUNT ocorrências" >> "$ALERT_LOG"
    echo "$LAST_OCCURRENCES" >> "$ALERT_LOG"
    echo "" >> "$ALERT_LOG"
    
    echo "[$(date)] ⚠️ Alerta enviado: $COUNT ocorrências"
else
    echo "[$(date)] OK: $COUNT ocorrências (abaixo do threshold)"
fi
```

**2. Configurar no Cron (a cada hora):**
```bash
# Editar crontab
crontab -e

# Adicionar linha
0 * * * * /path/to/alerta_php_fpm_completo.sh >> /var/log/php_fpm_alerts_cron.log 2>&1
```

**3. Criar diretório de logs (se não existir):**
```bash
mkdir -p /var/log/webflow-segurosimediato
chmod 755 /var/log/webflow-segurosimediato
```

---

## 🎯 RECOMENDAÇÃO FINAL

### **Para Início (Imediato):**

1. ✅ **Script Bash simples** com email (`alerta_php_fpm_max_children.sh`)
2. ✅ **Cron a cada hora** para verificar
3. ✅ **Log em arquivo** para histórico

### **Para Médio Prazo:**

1. ✅ **Integração com ProfessionalLogger** (usar sistema existente)
2. ✅ **API de status** para consulta manual
3. ✅ **Dashboard básico** (HTML + JavaScript)

### **Para Longo Prazo (Se Necessário):**

1. ✅ **Monitoramento contínuo** (serviço systemd)
2. ✅ **Alertas avançados** (Slack, Telegram, SMS)
3. ✅ **Integração com Graylog/ELK** (se volume crescer)

---

## 📝 EXEMPLO DE EMAIL ENVIADO

**Assunto:**
```
⚠️ ALERTA: PHP-FPM max_children - 8 ocorrências hoje
```

**Corpo:**
```
O limite de PHP-FPM max_children foi atingido 8 vezes hoje.

=== Detalhes ===
Data: 25-Nov-2025
Ocorrências: 8
Threshold: 5
Servidor: prod.bssegurosimediato.com.br

=== Últimas 10 Ocorrências ===
[25-Nov-2025 12:56:32] WARNING: [pool www] server reached pm.max_children setting (5)
[25-Nov-2025 12:57:02] WARNING: [pool www] server reached pm.max_children setting (5)
[25-Nov-2025 13:02:28] WARNING: [pool www] server reached pm.max_children setting (5)
...

=== Ação Recomendada ===
1. Verificar carga do servidor
2. Verificar se há processos travados
3. Considerar aumentar pm.max_children se problema persistir
4. Verificar logs: tail -50 /var/log/php8.3-fpm.log
```

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **GUIA COMPLETO - MÚLTIPLAS OPÇÕES DE ALERTAS**

