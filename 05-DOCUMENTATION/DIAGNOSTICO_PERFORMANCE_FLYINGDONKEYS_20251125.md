# 🔍 DIAGNÓSTICO DE PERFORMANCE: Servidor FlyingDonkeys

**Data:** 25/11/2025  
**Servidor:** `flyingdonkeys.com.br`  
**Status:** 🔍 **DIAGNÓSTICO EM ANDAMENTO**

---

## 📋 INFORMAÇÕES NECESSÁRIAS

### **1. Acesso ao Servidor**

**IP Público:** `?` (a preencher)  
**Acesso SSH:** `ssh root@[IP_DO_FLYINGDONKEYS]`  
**Provedor:** Hetzner Cloud  
**Tipo:** Cloud / Dedicado (a verificar)

---

## 🔍 CHECKLIST DE DIAGNÓSTICO

### **FASE 1: Verificação de Recursos do Sistema**

#### **1.1. CPU e Memória**

```bash
# Conectar ao servidor
ssh root@[IP_DO_FLYINGDONKEYS]

# Verificar uso de CPU e memória
top
# ou
htop

# Verificar memória detalhada
free -h

# Verificar CPU
lscpu

# Verificar load average
uptime
```

**O que verificar:**
- ✅ CPU usage > 80% por períodos prolongados?
- ✅ Memória RAM esgotada?
- ✅ Swap sendo usado?
- ✅ Load average > número de cores CPU?

---

#### **1.2. Disco (I/O e Espaço)**

```bash
# Verificar espaço em disco
df -h

# Verificar I/O do disco
iostat -x 1 5

# Verificar inodes
df -i

# Verificar processos com maior I/O
iotop
```

**O que verificar:**
- ✅ Disco > 80% cheio?
- ✅ I/O wait alto?
- ✅ Inodes esgotados?
- ✅ Processos com I/O excessivo?

---

#### **1.3. Rede**

```bash
# Verificar conexões de rede
netstat -tuln | head -20

# Verificar conexões ativas
ss -tun | wc -l

# Verificar tráfego de rede
iftop
# ou
nethogs

# Verificar latência
ping -c 10 8.8.8.8
```

**O que verificar:**
- ✅ Muitas conexões abertas?
- ✅ Tráfego de rede excessivo?
- ✅ Latência alta?
- ✅ Conexões em TIME_WAIT?

---

### **FASE 2: Verificação de Serviços**

#### **2.1. PHP-FPM (se aplicável)**

```bash
# Verificar status do PHP-FPM
systemctl status php8.3-fpm
# ou
systemctl status php-fpm

# Verificar workers do PHP-FPM
ps aux | grep php-fpm | wc -l

# Verificar configuração
cat /etc/php/8.3/fpm/pool.d/www.conf | grep -E "pm\.(max_children|start_servers|min_spare|max_spare)"

# Verificar logs de erro
tail -f /var/log/php8.3-fpm.log
# ou
tail -f /var/log/php-fpm.log
```

**O que verificar:**
- ✅ PHP-FPM está rodando?
- ✅ Workers esgotados (`pm.max_children` atingido)?
- ✅ Erros nos logs?
- ✅ Workers idle vs active?

---

#### **2.2. Nginx (se aplicável)**

```bash
# Verificar status do Nginx
systemctl status nginx

# Verificar processos Nginx
ps aux | grep nginx

# Verificar configuração
nginx -t

# Verificar logs de acesso
tail -f /var/log/nginx/access.log

# Verificar logs de erro
tail -f /var/log/nginx/error.log

# Verificar conexões ativas
netstat -an | grep :80 | wc -l
netstat -an | grep :443 | wc -l
```

**O que verificar:**
- ✅ Nginx está rodando?
- ✅ Erros nos logs?
- ✅ Muitas requisições simultâneas?
- ✅ Timeouts?

---

#### **2.3. MySQL/MariaDB (se aplicável)**

```bash
# Verificar status do MySQL
systemctl status mysql
# ou
systemctl status mariadb

# Verificar conexões
mysqladmin -u root -p processlist

# Verificar queries lentas
mysql -u root -p -e "SHOW PROCESSLIST;"

# Verificar configuração
cat /etc/mysql/my.cnf | grep -E "(max_connections|innodb_buffer_pool_size)"

# Verificar logs
tail -f /var/log/mysql/error.log
```

**O que verificar:**
- ✅ MySQL está rodando?
- ✅ Muitas conexões abertas?
- ✅ Queries lentas?
- ✅ Buffer pool adequado?

---

#### **2.4. EspoCRM (Aplicação)**

```bash
# Verificar logs do EspoCRM
tail -f /var/www/html/data/logs/*.log

# Verificar cache do EspoCRM
ls -lh /var/www/html/data/cache/

# Verificar tamanho do banco de dados
mysql -u root -p -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables WHERE table_schema = 'espocrm' GROUP BY table_schema;"

# Verificar processos PHP relacionados ao EspoCRM
ps aux | grep espocrm
```

**O que verificar:**
- ✅ Erros nos logs do EspoCRM?
- ✅ Cache muito grande?
- ✅ Banco de dados muito grande?
- ✅ Processos PHP travados?

---

### **FASE 3: Análise de Logs**

#### **3.1. Logs do Sistema**

```bash
# Verificar logs do sistema
journalctl -xe | tail -50

# Verificar erros recentes
journalctl -p err -n 50

# Verificar logs de kernel
dmesg | tail -50
```

**O que verificar:**
- ✅ Erros de sistema?
- ✅ OOM (Out of Memory) kills?
- ✅ Erros de hardware?
- ✅ Erros de rede?

---

#### **3.2. Logs de Aplicação**

```bash
# Verificar logs do EspoCRM
find /var/www/html -name "*.log" -type f -exec ls -lh {} \;

# Verificar logs de webhooks
grep -r "webhook" /var/www/html/data/logs/ | tail -20

# Verificar logs de API
grep -r "api" /var/www/html/data/logs/ | tail -20
```

**O que verificar:**
- ✅ Erros de aplicação?
- ✅ Timeouts?
- ✅ Erros de conexão?
- ✅ Erros de banco de dados?

---

### **FASE 4: Análise de Processos**

#### **4.1. Processos Consumindo Recursos**

```bash
# Top 10 processos por CPU
ps aux --sort=-%cpu | head -11

# Top 10 processos por memória
ps aux --sort=-%mem | head -11

# Processos por usuário
ps aux | awk '{print $1}' | sort | uniq -c | sort -rn

# Verificar processos zumbi
ps aux | grep defunct
```

**O que verificar:**
- ✅ Processos consumindo muita CPU?
- ✅ Processos consumindo muita memória?
- ✅ Processos zumbi?
- ✅ Processos travados?

---

#### **4.2. Análise de Threads**

```bash
# Verificar threads por processo
ps -eLf | wc -l

# Verificar threads do PHP-FPM
ps -eLf | grep php-fpm | wc -l

# Verificar threads do MySQL
ps -eLf | grep mysql | wc -l
```

**O que verificar:**
- ✅ Muitas threads?
- ✅ Threads travadas?
- ✅ Thread leaks?

---

### **FASE 5: Análise de Banco de Dados**

#### **5.1. Queries Lentas**

```bash
# Habilitar log de queries lentas (se não estiver habilitado)
mysql -u root -p -e "SET GLOBAL slow_query_log = 'ON'; SET GLOBAL long_query_time = 2;"

# Verificar queries lentas
tail -f /var/log/mysql/slow-query.log

# Verificar queries ativas
mysql -u root -p -e "SHOW PROCESSLIST;"

# Verificar locks
mysql -u root -p -e "SHOW ENGINE INNODB STATUS\G" | grep -A 20 "TRANSACTIONS"
```

**O que verificar:**
- ✅ Queries lentas (> 2 segundos)?
- ✅ Queries travadas?
- ✅ Locks de tabela?
- ✅ Deadlocks?

---

#### **5.2. Índices e Otimização**

```bash
# Verificar tabelas sem índices
mysql -u root -p espocrm -e "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'espocrm' AND TABLE_NAME NOT IN (SELECT DISTINCT TABLE_NAME FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = 'espocrm');"

# Verificar tamanho das tabelas
mysql -u root -p espocrm -e "SELECT TABLE_NAME, ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'espocrm' ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC LIMIT 10;"

# Verificar fragmentação
mysql -u root -p espocrm -e "SELECT TABLE_NAME, DATA_FREE FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'espocrm' AND DATA_FREE > 0;"
```

**O que verificar:**
- ✅ Tabelas sem índices?
- ✅ Tabelas muito grandes?
- ✅ Fragmentação de tabelas?
- ✅ Índices não utilizados?

---

## 📊 COMANDOS RÁPIDOS DE DIAGNÓSTICO

### **Script Completo de Diagnóstico**

```bash
#!/bin/bash
# Salvar como: diagnostico_performance.sh

echo "=== DIAGNÓSTICO DE PERFORMANCE - FLYINGDONKEYS ==="
echo "Data: $(date)"
echo ""

echo "=== 1. CPU E MEMÓRIA ==="
echo "Load Average:"
uptime
echo ""
echo "Memória:"
free -h
echo ""
echo "Top 5 processos por CPU:"
ps aux --sort=-%cpu | head -6
echo ""

echo "=== 2. DISCO ==="
echo "Espaço em disco:"
df -h
echo ""
echo "I/O wait:"
iostat -x 1 2 | tail -1
echo ""

echo "=== 3. REDE ==="
echo "Conexões ativas:"
ss -tun | wc -l
echo ""
echo "Top 5 conexões:"
netstat -tun | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -5
echo ""

echo "=== 4. PHP-FPM ==="
if systemctl is-active --quiet php8.3-fpm || systemctl is-active --quiet php-fpm; then
    echo "Status: ATIVO"
    echo "Workers:"
    ps aux | grep php-fpm | grep -v grep | wc -l
else
    echo "Status: INATIVO"
fi
echo ""

echo "=== 5. NGINX ==="
if systemctl is-active --quiet nginx; then
    echo "Status: ATIVO"
    echo "Processos:"
    ps aux | grep nginx | grep -v grep | wc -l
else
    echo "Status: INATIVO"
fi
echo ""

echo "=== 6. MYSQL ==="
if systemctl is-active --quiet mysql || systemctl is-active --quiet mariadb; then
    echo "Status: ATIVO"
    echo "Conexões:"
    mysqladmin -u root -p processlist 2>/dev/null | wc -l || echo "Não foi possível verificar"
else
    echo "Status: INATIVO"
fi
echo ""

echo "=== DIAGNÓSTICO CONCLUÍDO ==="
```

**Como usar:**
```bash
# Salvar script
nano diagnostico_performance.sh
chmod +x diagnostico_performance.sh

# Executar
./diagnostico_performance.sh > diagnostico_$(date +%Y%m%d_%H%M%S).txt
```

---

## 🎯 PRÓXIMOS PASSOS

### **1. Coletar Informações**

- [ ] Executar script de diagnóstico
- [ ] Coletar logs dos últimos 24 horas
- [ ] Verificar métricas do Hetzner Cloud Console
- [ ] Verificar uso de recursos (CPU, RAM, Disco, Rede)

### **2. Identificar Causa Raiz**

- [ ] Analisar resultados do diagnóstico
- [ ] Identificar gargalo (CPU, RAM, Disco, Rede, Banco)
- [ ] Verificar se é problema de código ou infraestrutura
- [ ] Verificar se é problema de configuração

### **3. Propor Solução**

- [ ] Ajustar configurações (PHP-FPM, MySQL, Nginx)
- [ ] Otimizar queries do banco de dados
- [ ] Limpar cache e logs antigos
- [ ] Considerar upgrade de recursos (CPU, RAM)

---

## 📝 NOTAS

**Informações a Coletar:**
- IP público do servidor flyingdonkeys
- Tipo de servidor (Cloud / Dedicado)
- Especificações (CPU, RAM, Disco)
- Quando começou a degradação
- Sintomas específicos observados

---

**Documento criado em:** 25/11/2025  
**Status:** 🔍 **AGUARDANDO ACESSO AO SERVIDOR**

