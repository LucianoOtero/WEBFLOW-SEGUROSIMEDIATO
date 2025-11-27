# 📋 GUIA COMPLETO: Busca de Logs em Produção

**Data de Criação:** 25/11/2025  
**Versão:** 1.0.0  
**Servidor:** `prod.bssegurosimediato.com.br` (157.180.36.223)

---

## 🎯 OBJETIVO

Este guia fornece scripts prontos e funcionais para buscar logs em produção, evitando retrabalho e buscas ineficientes.

---

## 📂 LOCALIZAÇÃO DOS ARQUIVOS DE LOG

### **Arquivos de Log do Sistema:**

| Tipo | Arquivo | Caminho Completo |
|------|---------|-------------------|
| **Nginx Error** | `dev_error.log` | `/var/log/nginx/dev_error.log` |
| **Nginx Access** | `access.log` | `/var/log/nginx/access.log` |
| **PHP-FPM** | `php8.3-fpm.log` | `/var/log/php8.3-fpm.log` |
| **Systemd PHP-FPM** | `journalctl` | `journalctl -u php8.3-fpm` |

### **Arquivos de Log da Aplicação:**

| Tipo | Arquivo | Caminho Completo |
|------|---------|-------------------|
| **FlyingDonkeys** | `flyingdonkeys_prod.txt` | `/var/log/webflow-segurosimediato/flyingdonkeys_prod.txt` |
| **OctaDesk** | `webhook_octadesk_prod.txt` | `/var/log/webflow-segurosimediato/webhook_octadesk_prod.txt` |
| **ProfessionalLogger Errors** | `professional_logger_errors.txt` | `/var/log/webflow-segurosimediato/professional_logger_errors.txt` |
| **Log Endpoint Debug** | `log_endpoint_debug.txt` | `/var/log/webflow-segurosimediato/log_endpoint_debug.txt` |

### **Banco de Dados:**

| Tipo | Banco | Tabela |
|------|-------|--------|
| **Application Logs** | `rpa_logs_prod` | `application_logs` |

---

## 🔍 SCRIPTS PRONTOS PARA BUSCA DE LOGS

> **⚠️ IMPORTANTE:** Todos os scripts abaixo foram testados e estão funcionais. Copie e cole diretamente no terminal.

---

### **1. LOGS DO PROFESSIONALLOGGER (cURL)**

#### **Buscar logs do cURL no Nginx (últimas 20 ocorrências):**
```bash
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL' /var/log/nginx/dev_error.log | tail -20"
```

#### **Buscar logs de sucesso do cURL:**
```bash
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL.*sucesso' /var/log/nginx/dev_error.log | tail -20"
```

#### **Buscar logs de falha do cURL:**
```bash
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL.*falhou' /var/log/nginx/dev_error.log | tail -20"
```

#### **Buscar logs do ProfessionalLogger relacionados a email:**
```bash
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*Email|\[ProfessionalLogger\].*Falha detalhada' /var/log/nginx/dev_error.log | tail -20"
```

#### **Buscar TODOS os logs do ProfessionalLogger (últimas 30 linhas):**
```bash
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\]' /var/log/nginx/dev_error.log | tail -30"
```

#### **Buscar logs do ProfessionalLogger de hoje:**
```bash
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\]' /var/log/nginx/dev_error.log | grep \"$(date '+%Y/%m/%d')\" | tail -30"
```

---

### **2. LOGS DE EMAIL (AWS SES)**

#### **Buscar emails enviados com sucesso (últimas 20 ocorrências):**
```bash
ssh root@157.180.36.223 "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | tail -20"
```

#### **Buscar emails enviados hoje:**
```bash
ssh root@157.180.36.223 "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | grep \"$(date '+%Y/%m/%d')\" | tail -20"
```

#### **Contar emails enviados hoje:**
```bash
ssh root@157.180.36.223 "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | grep \"$(date '+%Y/%m/%d')\" | wc -l"
```

#### **Buscar emails enviados em timestamp específico (ex: 22:50):**
```bash
ssh root@157.180.36.223 "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | grep '22:50' | tail -10"
```

---

### **3. LOGS DO PHP-FPM**

#### **Buscar erros no PHP-FPM:**
```bash
ssh root@157.180.36.223 "grep -E 'ERROR|WARNING|FATAL' /var/log/php8.3-fpm.log | tail -20"
```

#### **Buscar avisos de max_children:**
```bash
ssh root@157.180.36.223 "grep -E 'max_children|reached' /var/log/php8.3-fpm.log | tail -20"
```

#### **Buscar logs do ProfessionalLogger no PHP-FPM:**
```bash
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\]' /var/log/php8.3-fpm.log | tail -20"
```

#### **Ver últimas linhas do PHP-FPM:**
```bash
ssh root@157.180.36.223 "tail -50 /var/log/php8.3-fpm.log"
```

---

### **4. LOGS DO NGINX**

#### **Buscar erros HTTP (500, 502, 503) - últimas 20 ocorrências:**
```bash
ssh root@157.180.36.223 "grep -E '500|502|503' /var/log/nginx/dev_error.log | tail -20"
```

#### **Contar erros HTTP de hoje:**
```bash
ssh root@157.180.36.223 "grep -E '500|502|503' /var/log/nginx/dev_error.log | grep \"$(date '+%Y/%m/%d')\" | wc -l"
```

#### **Ver últimas 50 linhas do Nginx (geral):**
```bash
ssh root@157.180.36.223 "tail -50 /var/log/nginx/dev_error.log"
```

#### **Ver últimas 100 linhas do Nginx (mais contexto):**
```bash
ssh root@157.180.36.223 "tail -100 /var/log/nginx/dev_error.log"
```

---

### **5. LOGS NO BANCO DE DADOS**

#### **Últimos 20 logs (formato simples):**
```bash
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e 'SELECT timestamp, level, category, LEFT(message, 100) as message_preview FROM application_logs ORDER BY timestamp DESC LIMIT 20;'"
```

#### **Logs de erro das últimas 24 horas:**
```bash
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE level IN ('ERROR', 'FATAL', 'WARN') AND timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR) ORDER BY timestamp DESC LIMIT 30;\""
```

#### **Logs relacionados a email (últimas 2 horas):**
```bash
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE category = 'EMAIL' AND timestamp >= DATE_SUB(NOW(), INTERVAL 2 HOUR) ORDER BY timestamp DESC LIMIT 20;\""
```

#### **Logs do ProfessionalLogger (últimas 2 horas):**
```bash
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE file_name LIKE '%ProfessionalLogger%' AND timestamp >= DATE_SUB(NOW(), INTERVAL 2 HOUR) ORDER BY timestamp DESC LIMIT 20;\""
```

#### **Estatísticas por categoria (últimas 24 horas):**
```bash
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT category, COUNT(*) as total, SUM(CASE WHEN level = 'ERROR' THEN 1 ELSE 0 END) as erros FROM application_logs WHERE timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR) GROUP BY category ORDER BY total DESC;\""
```

#### **Total de logs no banco:**
```bash
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e 'SELECT COUNT(*) as total_logs FROM application_logs;'"
```

---

### **6. LOGS DE ARQUIVOS DA APLICAÇÃO**

#### **Últimas linhas do FlyingDonkeys:**
```bash
ssh root@157.180.36.223 "tail -50 /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt"
```

#### **Últimas linhas do OctaDesk:**
```bash
ssh root@157.180.36.223 "tail -50 /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt"
```

#### **Buscar erros no FlyingDonkeys:**
```bash
ssh root@157.180.36.223 "grep -E '\"success\":false' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -20"
```

---

### **7. BUSCA POR TIMESTAMP ESPECÍFICO**

#### **Buscar logs do Nginx em timestamp específico (formato: 2025/11/25 19:19):**
```bash
# Substituir data/hora conforme necessário
ssh root@157.180.36.223 "grep '2025/11/25 19:19' /var/log/nginx/dev_error.log | tail -30"
```

#### **Buscar logs do PHP-FPM em timestamp específico (formato: 2025-11-25 19:19):**
```bash
# Substituir data/hora conforme necessário
ssh root@157.180.36.223 "grep '2025-11-25 19:19' /var/log/php8.3-fpm.log | tail -30"
```

#### **Buscar logs no banco de dados por timestamp (intervalo de 1 minuto):**
```bash
# Substituir data/hora conforme necessário
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE timestamp >= '2025-11-25 19:19:00' AND timestamp <= '2025-11-25 19:20:00' ORDER BY timestamp DESC;\""
```

#### **Buscar logs no banco de dados por timestamp (última hora):**
```bash
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE timestamp >= DATE_SUB(NOW(), INTERVAL 1 HOUR) ORDER BY timestamp DESC LIMIT 30;\""
```

---

### **8. VERIFICAÇÕES DE SISTEMA**

#### **Status do PHP-FPM:**
```bash
ssh root@157.180.36.223 "systemctl status php8.3-fpm --no-pager | head -15"
```

#### **Workers ativos do PHP-FPM:**
```bash
ssh root@157.180.36.223 "ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l"
```

#### **Configuração PHP-FPM (max_children):**
```bash
ssh root@157.180.36.223 "grep -E 'pm.max_children|pm.start_servers|pm.min_spare_servers|pm.max_spare_servers' /etc/php/8.3/fpm/pool.d/www.conf | grep -v '^;'"
```

#### **Verificar se cURL está disponível:**
```bash
ssh root@157.180.36.223 "php -m | grep -i curl"
```

---

## 📊 SCRIPTS DE ANÁLISE RÁPIDA (Bash)

### **Script 1: Análise Completa de Erros (Últimas 2 Horas)**

**Arquivo:** `analise_erros_2h.sh`

```bash
#!/bin/bash
# Script: analise_erros_2h.sh
# Uso: bash analise_erros_2h.sh

echo "=== ANÁLISE DE ERROS - ÚLTIMAS 2 HORAS ==="
echo ""

echo "1. Erros no Nginx:"
ssh root@157.180.36.223 "tail -1000 /var/log/nginx/dev_error.log | grep -E 'error|Error|ERROR' | wc -l"

echo "2. Erros no PHP-FPM:"
ssh root@157.180.36.223 "tail -500 /var/log/php8.3-fpm.log | grep -E 'ERROR|WARNING|FATAL' | wc -l"

echo "3. Erros no Banco de Dados (últimas 2h):"
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT COUNT(*) as total FROM application_logs WHERE level IN ('ERROR', 'FATAL', 'WARN') AND timestamp >= DATE_SUB(NOW(), INTERVAL 2 HOUR);\""

echo "4. Emails enviados hoje:"
ssh root@157.180.36.223 "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | grep \"\$(date '+%Y/%m/%d')\" | wc -l"
```

---

### **Script 2: Busca Específica de Logs do cURL**

**Arquivo:** `buscar_logs_curl.sh`

```bash
#!/bin/bash
# Script: buscar_logs_curl.sh
# Uso: bash buscar_logs_curl.sh

TIMESTAMP=$(date '+%Y/%m/%d')

echo "=== BUSCA DE LOGS DO CURL ==="
echo "Data: $TIMESTAMP"
echo ""

echo "1. Logs de sucesso do cURL:"
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL.*sucesso' /var/log/nginx/dev_error.log | grep \"$TIMESTAMP\" | tail -10"

echo ""
echo "2. Logs de falha do cURL:"
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL.*falhou' /var/log/nginx/dev_error.log | grep \"$TIMESTAMP\" | tail -10"

echo ""
echo "3. Logs detalhados do ProfessionalLogger:"
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*Falha detalhada' /var/log/nginx/dev_error.log | grep \"$TIMESTAMP\" | tail -10"
```

---

### **Script 3: Verificação de Saúde do Sistema**

**Arquivo:** `verificar_saude_sistema.sh`

```bash
#!/bin/bash
# Script: verificar_saude_sistema.sh
# Uso: bash verificar_saude_sistema.sh

echo "=== VERIFICAÇÃO DE SAÚDE DO SISTEMA ==="
echo ""

echo "1. Status do PHP-FPM:"
ssh root@157.180.36.223 "systemctl is-active php8.3-fpm"

echo ""
echo "2. Workers ativos:"
ssh root@157.180.36.223 "ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l"

echo ""
echo "3. Erros HTTP (últimas 100 linhas):"
ssh root@157.180.36.223 "tail -100 /var/log/nginx/dev_error.log | grep -E '500|502|503' | wc -l"

echo ""
echo "4. Avisos de max_children (hoje):"
ssh root@157.180.36.223 "grep -E 'max_children.*reached' /var/log/php8.3-fpm.log | grep \"\$(date '+%Y-%m-%d')\" | wc -l"
```

---

## 🔧 SCRIPTS POWER SHELL (Windows)

> **⚠️ IMPORTANTE:** Execute estes scripts no PowerShell do Windows.

---

### **Script 1: Buscar Logs do cURL (PowerShell)**

**Arquivo:** `Buscar-LogsCurl.ps1`

```powershell
# Script: Buscar-LogsCurl.ps1
# Uso: .\Buscar-LogsCurl.ps1

$servidor = "157.180.36.223"
$data = Get-Date -Format "yyyy/MM/dd"

Write-Host "=== BUSCA DE LOGS DO CURL ===" -ForegroundColor Cyan
Write-Host "Data: $data" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Logs de sucesso do cURL:" -ForegroundColor Yellow
ssh root@$servidor "grep -E '\[ProfessionalLogger\].*cURL.*sucesso' /var/log/nginx/dev_error.log | grep `"$data`" | tail -10"

Write-Host ""
Write-Host "2. Logs de falha do cURL:" -ForegroundColor Yellow
ssh root@$servidor "grep -E '\[ProfessionalLogger\].*cURL.*falhou' /var/log/nginx/dev_error.log | grep `"$data`" | tail -10"

Write-Host ""
Write-Host "3. Logs detalhados do ProfessionalLogger:" -ForegroundColor Yellow
ssh root@$servidor "grep -E '\[ProfessionalLogger\].*Falha detalhada' /var/log/nginx/dev_error.log | grep `"$data`" | tail -10"
```

---

### **Script 2: Buscar Logs de Email (PowerShell)**

**Arquivo:** `Buscar-LogsEmail.ps1`

```powershell
# Script: Buscar-LogsEmail.ps1
# Uso: .\Buscar-LogsEmail.ps1

$servidor = "157.180.36.223"
$data = Get-Date -Format "yyyy/MM/dd"

Write-Host "=== BUSCA DE LOGS DE EMAIL ===" -ForegroundColor Cyan
Write-Host "Data: $data" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Emails enviados hoje:" -ForegroundColor Yellow
ssh root@$servidor "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | grep `"$data`" | tail -20"

Write-Host ""
Write-Host "2. Total de emails enviados hoje:" -ForegroundColor Yellow
$total = ssh root@$servidor "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | grep `"$data`" | wc -l"
Write-Host "Total: $total" -ForegroundColor Green
```

---

### **Script 3: Buscar Logs no Banco de Dados (PowerShell)**

**Arquivo:** `Buscar-LogsBancoDados.ps1`

```powershell
# Script: Buscar-LogsBancoDados.ps1
# Uso: .\Buscar-LogsBancoDados.ps1

$servidor = "157.180.36.223"
$senha = "tYbAwe7QkKNrHSRhaWplgsSxt"

Write-Host "=== BUSCA DE LOGS NO BANCO DE DADOS ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Últimos 20 logs:" -ForegroundColor Yellow
ssh root@$servidor "mysql -u rpa_logger_prod -p$senha rpa_logs_prod -e 'SELECT timestamp, level, category, LEFT(message, 100) as message_preview FROM application_logs ORDER BY timestamp DESC LIMIT 20;'"

Write-Host ""
Write-Host "2. Erros das últimas 24 horas:" -ForegroundColor Yellow
ssh root@$servidor "mysql -u rpa_logger_prod -p$senha rpa_logs_prod -e `"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE level IN ('ERROR', 'FATAL', 'WARN') AND timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR) ORDER BY timestamp DESC LIMIT 30;`""
```

---

## 📋 CHECKLIST DE BUSCA DE LOGS

### **Antes de Buscar:**

- [ ] Identificar tipo de log necessário (cURL, email, erro, etc.)
- [ ] Identificar período de tempo (últimas 2h, 24h, timestamp específico)
- [ ] Escolher script apropriado do guia
- [ ] Verificar se arquivo de log existe (usar `ls -lh`)

### **Durante a Busca:**

- [ ] **SEMPRE usar script pronto do guia** (não criar novo)
- [ ] **SEMPRE limitar resultados** com `tail -N` (ex: `tail -20`)
- [ ] **SEMPRE usar padrões específicos** no `grep` (não buscar tudo)
- [ ] **SEMPRE verificar múltiplos locais** se não encontrar no primeiro

### **Após a Busca:**

- [ ] Documentar resultados encontrados
- [ ] Se não encontrar, verificar outros locais de log listados no guia
- [ ] Se necessário, ajustar script para busca mais específica (mas manter padrão do guia)

---

## ⚠️ ERROS COMUNS A EVITAR

### **❌ NÃO FAZER:**

1. ❌ **Buscar em todos os arquivos sem filtro:**
   ```bash
   # ERRADO - muito lento e ineficiente
   ssh root@157.180.36.223 "grep -r 'ProfessionalLogger' /var/log/"
   ```

2. ❌ **Buscar sem limitar resultados:**
   ```bash
   # ERRADO - pode retornar milhares de linhas
   ssh root@157.180.36.223 "grep 'ProfessionalLogger' /var/log/nginx/dev_error.log"
   ```

3. ❌ **Buscar com padrões muito amplos:**
   ```bash
   # ERRADO - retorna muitos resultados irrelevantes
   ssh root@157.180.36.223 "grep -E 'error|Error|ERROR' /var/log/nginx/dev_error.log"
   ```

4. ❌ **Buscar em arquivos muito grandes sem `tail` primeiro:**
   ```bash
   # ERRADO - muito lento em arquivos grandes
   ssh root@157.180.36.223 "grep 'ProfessionalLogger' /var/log/nginx/dev_error.log"
   ```

5. ❌ **Criar novos scripts sem verificar se já existe no guia:**
   ```bash
   # ERRADO - retrabalho desnecessário
   # Sempre verificar guia primeiro
   ```

### **✅ FAZER:**

1. ✅ **SEMPRE usar scripts prontos do guia**
2. ✅ **SEMPRE limitar resultados** com `tail -N` (ex: `tail -20`)
3. ✅ **SEMPRE usar padrões específicos** no `grep` (ex: `\[ProfessionalLogger\].*cURL`)
4. ✅ **SEMPRE filtrar por data/timestamp** quando possível
5. ✅ **SEMPRE usar `tail` antes de `grep`** em arquivos grandes:
   ```bash
   # CORRETO - limita volume antes de buscar
   ssh root@157.180.36.223 "tail -1000 /var/log/nginx/dev_error.log | grep 'ProfessionalLogger' | tail -20"
   ```

---

## 📊 EXEMPLOS DE USO PRÁTICO

### **Exemplo 1: Verificar se cURL está funcionando após deploy**

**Cenário:** Deploy realizado, verificar se logs do cURL aparecem.

```bash
# 1. Buscar logs de sucesso do cURL (últimas 10 ocorrências)
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL.*sucesso' /var/log/nginx/dev_error.log | tail -10"

# 2. Se não encontrar, verificar se emails estão sendo enviados
ssh root@157.180.36.223 "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | tail -10"

# 3. Verificar se cURL está disponível
ssh root@157.180.36.223 "php -m | grep -i curl"
```

**Resultado esperado:**
- Se cURL funcionando: logs com formato `[ProfessionalLogger] cURL sucesso após Xs | HTTP: 200...`
- Se não funcionando: apenas emails sendo enviados, sem logs do cURL

---

### **Exemplo 2: Investigar erro específico por timestamp**

**Cenário:** Erro ocorreu às 19:19, investigar causa.

```bash
# 1. Buscar no Nginx (formato: 2025/11/25 19:19)
ssh root@157.180.36.223 "grep '2025/11/25 19:19' /var/log/nginx/dev_error.log | tail -30"

# 2. Buscar no PHP-FPM (formato: 2025-11-25 19:19)
ssh root@157.180.36.223 "grep '2025-11-25 19:19' /var/log/php8.3-fpm.log | tail -30"

# 3. Buscar no banco de dados (intervalo de 1 minuto)
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE timestamp >= '2025-11-25 19:19:00' AND timestamp <= '2025-11-25 19:20:00' ORDER BY timestamp DESC;\""
```

**Resultado esperado:**
- Logs relacionados ao erro no timestamp especificado
- Informações sobre causa do erro

---

### **Exemplo 3: Verificar saúde do sistema**

**Cenário:** Verificação rápida de saúde após deploy.

```bash
# 1. Status do PHP-FPM
ssh root@157.180.36.223 "systemctl status php8.3-fpm --no-pager | head -15"

# 2. Workers ativos
ssh root@157.180.36.223 "ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l"

# 3. Erros HTTP recentes (últimas 100 linhas)
ssh root@157.180.36.223 "tail -100 /var/log/nginx/dev_error.log | grep -E '500|502|503' | wc -l"

# 4. Avisos de max_children (hoje)
ssh root@157.180.36.223 "grep -E 'max_children.*reached' /var/log/php8.3-fpm.log | grep \"\$(date '+%Y-%m-%d')\" | wc -l"
```

**Resultado esperado:**
- PHP-FPM ativo
- Workers dentro do limite
- Poucos ou nenhum erro HTTP
- Poucos ou nenhum aviso de max_children

---

### **Exemplo 4: Buscar logs de email após lead gerado**

**Cenário:** Lead gerado, verificar se email foi enviado.

```bash
# 1. Buscar emails enviados hoje
ssh root@157.180.36.223 "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | grep \"\$(date '+%Y/%m/%d')\" | tail -10"

# 2. Buscar logs relacionados a email no banco de dados (últimas 2 horas)
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE category = 'EMAIL' AND timestamp >= DATE_SUB(NOW(), INTERVAL 2 HOUR) ORDER BY timestamp DESC LIMIT 20;\""
```

**Resultado esperado:**
- Email enviado com sucesso (mensagem SES)
- Log no banco de dados com categoria EMAIL

---

## 🔍 TROUBLESHOOTING

### **Problema 1: Script não retorna resultados**

**Sintomas:** Comando executa mas não retorna nada.

**Solução passo a passo:**

1. **Verificar se arquivo de log existe:**
   ```bash
   ssh root@157.180.36.223 "ls -lh /var/log/nginx/dev_error.log"
   ```

2. **Verificar se há conteúdo no arquivo:**
   ```bash
   ssh root@157.180.36.223 "wc -l /var/log/nginx/dev_error.log"
   ```

3. **Verificar últimas linhas do arquivo (ver se está sendo escrito):**
   ```bash
   ssh root@157.180.36.223 "tail -20 /var/log/nginx/dev_error.log"
   ```

4. **Se arquivo existe mas não há resultados, verificar padrão:**
   ```bash
   ssh root@157.180.36.223 "grep 'ProfessionalLogger' /var/log/nginx/dev_error.log | head -5"
   ```

---

### **Problema 2: Script muito lento**

**Sintomas:** Comando demora muito para executar.

**Solução:**

1. **SEMPRE usar `tail` antes de `grep` em arquivos grandes:**
   ```bash
   # CORRETO - limita volume antes de buscar
   ssh root@157.180.36.223 "tail -1000 /var/log/nginx/dev_error.log | grep 'ProfessionalLogger' | tail -20"
   ```

2. **Limitar período de busca (usar timestamp específico):**
   ```bash
   # CORRETO - busca apenas em período específico
   ssh root@157.180.36.223 "grep '2025/11/25 19:19' /var/log/nginx/dev_error.log | tail -30"
   ```

---

### **Problema 3: Padrão de busca não encontra resultados**

**Sintomas:** Padrão parece correto mas não encontra nada.

**Solução:**

1. **Verificar padrão do log (pode ter espaços, caracteres especiais):**
   ```bash
   ssh root@157.180.36.223 "grep 'ProfessionalLogger' /var/log/nginx/dev_error.log | head -5"
   ```

2. **Usar padrão mais amplo primeiro:**
   ```bash
   ssh root@157.180.36.223 "grep 'Professional' /var/log/nginx/dev_error.log | tail -20"
   ```

3. **Verificar formato exato do log:**
   ```bash
   ssh root@157.180.36.223 "tail -100 /var/log/nginx/dev_error.log | grep -i professional | head -3"
   ```

---

### **Problema 4: Muitos resultados irrelevantes**

**Sintomas:** Script retorna muitos resultados, difícil encontrar o que precisa.

**Solução:**

1. **Usar padrão mais específico:**
   ```bash
   # ERRADO - muito amplo
   ssh root@157.180.36.223 "grep 'error' /var/log/nginx/dev_error.log | tail -20"
   
   # CORRETO - específico
   ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL.*sucesso' /var/log/nginx/dev_error.log | tail -20"
   ```

2. **Filtrar por data/timestamp:**
   ```bash
   ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL' /var/log/nginx/dev_error.log | grep \"\$(date '+%Y/%m/%d')\" | tail -20"
   ```

---

## 📝 NOTAS IMPORTANTES

1. **SEMPRE usar `tail -N`** para limitar resultados (ex: `tail -20`)
2. **SEMPRE usar padrões específicos** no `grep` (não buscar tudo)
3. **SEMPRE verificar múltiplos locais** se não encontrar no primeiro
4. **SEMPRE usar scripts prontos do guia** (não criar novos)
5. **SEMPRE usar `tail` antes de `grep`** em arquivos grandes
6. **SEMPRE filtrar por data/timestamp** quando possível

---

## 🎯 QUICK REFERENCE (Referência Rápida)

### **Comandos Mais Usados:**

```bash
# 1. Logs do cURL (últimas 20)
ssh root@157.180.36.223 "grep -E '\[ProfessionalLogger\].*cURL' /var/log/nginx/dev_error.log | tail -20"

# 2. Emails enviados hoje
ssh root@157.180.36.223 "grep -E '✅ SES: Email enviado com sucesso' /var/log/nginx/dev_error.log | grep \"\$(date '+%Y/%m/%d')\" | tail -20"

# 3. Erros no banco (últimas 24h)
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod -e \"SELECT timestamp, level, category, LEFT(message, 150) as message_preview FROM application_logs WHERE level IN ('ERROR', 'FATAL', 'WARN') AND timestamp >= DATE_SUB(NOW(), INTERVAL 24 HOUR) ORDER BY timestamp DESC LIMIT 30;\""

# 4. Status do PHP-FPM
ssh root@157.180.36.223 "systemctl status php8.3-fpm --no-pager | head -15"

# 5. Workers ativos
ssh root@157.180.36.223 "ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l"
```

---

## 🔄 ATUALIZAÇÕES DO GUIA

**Versão 1.0.0 (25/11/2025):**
- Criação inicial do guia completo
- Scripts testados e funcionais para busca de logs
- Scripts Bash e PowerShell
- Seção de troubleshooting
- Quick reference para comandos mais usados
- Checklist de busca de logs
- Exemplos práticos de uso

---

## 📚 ÍNDICE RÁPIDO

- **Localização dos Logs:** Seção "📂 LOCALIZAÇÃO DOS ARQUIVIVOS DE LOG"
- **Scripts Prontos:** Seção "🔍 SCRIPTS PRONTOS PARA BUSCA DE LOGS"
- **Scripts Bash:** Seção "📊 SCRIPTS DE ANÁLISE RÁPIDA (Bash)"
- **Scripts PowerShell:** Seção "🔧 SCRIPTS POWER SHELL (Windows)"
- **Troubleshooting:** Seção "🔍 TROUBLESHOOTING"
- **Quick Reference:** Seção "🎯 QUICK REFERENCE"

---

**Guia criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Status:** ✅ **GUIA COMPLETO, TESTADO E FUNCIONAL**

