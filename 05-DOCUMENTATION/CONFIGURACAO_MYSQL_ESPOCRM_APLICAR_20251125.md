# 🔧 CONFIGURAÇÃO MYSQL ESPOCRM: Aplicar Otimizações

**Data:** 25/11/2025  
**Servidor:** `flyingdonkeys.com.br` (37.27.1.242)  
**Arquivo:** `/etc/mysql/mariadb.conf.d/50-server.cnf`  
**Container:** `espocrm-db`

---

## 📋 ANÁLISE DO ARQUIVO ATUAL

**Observações:**
- ✅ Arquivo existe e está acessível
- ⚠️ Maioria das configurações estão comentadas
- ⚠️ `innodb_buffer_pool_size` está comentado (linha 100)
- ✅ Comentário indica "80% da RAM" (mas recomendação EspoCRM é 70%)
- ⚠️ `nano` não está disponível no container

---

## 🎯 CONFIGURAÇÕES A ADICIONAR

### **Configurações Recomendadas (70% RAM = ~5.3 GB):**

```ini
[mysqld]
# Buffer pool (70% da RAM = 5.3 GB para 7.6 GB RAM)
innodb_buffer_pool_size = 5G

# Flush log (melhor performance, risco mínimo)
innodb_flush_log_at_trx_commit = 2

# Log file size
innodb_log_file_size = 256M

# Sort buffer
sort_buffer_size = 2M
```

---

## 🔧 MÉTODO 1: Usar `vi` (Disponível no Container)

### **Passo a Passo:**

1. **Acessar container:**
```bash
ssh espo@37.27.1.242
docker exec -it espocrm-db bash
```

2. **Editar arquivo com vi:**
```bash
vi /etc/mysql/mariadb.conf.d/50-server.cnf
```

3. **No vi, fazer:**
   - Pressionar `i` para entrar em modo de inserção
   - Navegar até a seção `[mysqld]` (linha ~15)
   - Adicionar as configurações após a linha `[mysqld]`:

```ini
[mysqld]

# Performance optimizations (added 2025-11-25)
innodb_buffer_pool_size = 5G
innodb_flush_log_at_trx_commit = 2
innodb_log_file_size = 256M
sort_buffer_size = 2M
```

4. **Salvar e sair:**
   - Pressionar `Esc` para sair do modo de inserção
   - Digitar `:wq` e pressionar `Enter` para salvar e sair

5. **Sair do container:**
```bash
exit
```

6. **Reiniciar container:**
```bash
docker restart espocrm-db
```

---

## 🔧 MÉTODO 2: Usar `echo` e `>>` (Append)

### **Passo a Passo:**

1. **Acessar container:**
```bash
ssh espo@37.27.1.242
docker exec -it espocrm-db bash
```

2. **Adicionar configurações ao final do arquivo:**
```bash
cat >> /etc/mysql/mariadb.conf.d/50-server.cnf << 'EOF'

# Performance optimizations (added 2025-11-25)
[mysqld]
innodb_buffer_pool_size = 5G
innodb_flush_log_at_trx_commit = 2
innodb_log_file_size = 256M
sort_buffer_size = 2M
EOF
```

3. **Verificar que foi adicionado:**
```bash
tail -10 /etc/mysql/mariadb.conf.d/50-server.cnf
```

4. **Sair do container:**
```bash
exit
```

5. **Reiniciar container:**
```bash
docker restart espocrm-db
```

---

## 🔧 MÉTODO 3: Criar Arquivo Local e Copiar (RECOMENDADO)

### **Passo a Passo:**

1. **Criar arquivo local no Windows:**
   - Criar arquivo: `50-server-optimized.cnf`
   - Conteúdo completo (arquivo atual + otimizações):

```ini
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]

#
# * Basic Settings
#

#user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
basedir                 = /usr
#datadir                 = /var/lib/mysql
#tmpdir                  = /tmp

# Broken reverse DNS slows down connections considerably and name resolve is
# safe to skip if there are no "host by domain name" access grants
#skip-name-resolve

# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
#bind-address            = 127.0.0.1

#
# * Fine Tuning
#

#key_buffer_size        = 128M
#max_allowed_packet     = 1G
#thread_stack           = 192K
#thread_cache_size      = 8
# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched
#myisam_recover_options = BACKUP
#max_connections        = 100
#table_cache            = 64

#
# * Logging and Replication
#

# Note: The configured log file or its directory need to be created
# and be writable by the mysql user, e.g.:
# $ sudo mkdir -m 2750 /var/log/mysql
# $ sudo chown mysql /var/log/mysql

# Both location gets rotated by the cronjob.
# Be aware that this log type is a performance killer.
# Recommend only changing this at runtime for short testing periods if needed!
#general_log_file       = /var/log/mysql/mysql.log
#general_log            = 1

# When running under systemd, error logging goes via stdout/stderr to journald
# and when running legacy init error logging goes to syslog due to
# /etc/mysql/conf.d/mariadb.conf.d/50-mysqld_safe.cnf
# Enable this if you want to have error logging into a separate file
#log_error = /var/log/mysql/error.log
# Enable the slow query log to see queries with especially long duration
#log_slow_query_file    = /var/log/mysql/mariadb-slow.log
#log_slow_query_time    = 10
#log_slow_verbosity     = query_plan,explain
#log-queries-not-using-indexes
#log_slow_min_examined_row_limit = 1000

# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replica, see README.Debian about other
#       settings you may need to change.
#server-id              = 1
#log_bin                = /var/log/mysql/mysql-bin.log
expire_logs_days        = 10
#max_binlog_size        = 100M

#
# * SSL/TLS
#

# For documentation, please read
# https://mariadb.com/kb/en/securing-connections-for-client-and-server/
#ssl-ca = /etc/mysql/cacert.pem
#ssl-cert = /etc/mysql/server-cert.pem
#ssl-key = /etc/mysql/server-key.pem
#require-secure-transport = on

#
# * Character sets
#

# MySQL/MariaDB default is Latin1, but in Debian we rather default to the full
# utf8 4-byte character set. See also client.cnf
character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci

#
# * InnoDB
#

# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.
# Read the manual for more InnoDB related options. There are many!
# Most important is to give InnoDB 80 % of the system RAM for buffer use:
# https://mariadb.com/kb/en/innodb-system-variables/#innodb_buffer_pool_size
#innodb_buffer_pool_size = 8G

# Performance optimizations (added 2025-11-25)
innodb_buffer_pool_size = 5G
innodb_flush_log_at_trx_commit = 2
innodb_log_file_size = 256M
sort_buffer_size = 2M

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.11 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.11]
```

2. **Fazer backup do arquivo original:**
```bash
ssh espo@37.27.1.242
docker exec espocrm-db cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.backup_$(date +%Y%m%d_%H%M%S)
```

3. **Copiar arquivo para o container:**
```bash
# Do Windows, copiar arquivo para servidor
scp 50-server-optimized.cnf espo@37.27.1.242:/tmp/50-server-optimized.cnf

# No servidor, copiar para dentro do container
docker cp /tmp/50-server-optimized.cnf espocrm-db:/etc/mysql/mariadb.conf.d/50-server.cnf
```

4. **Verificar permissões:**
```bash
docker exec espocrm-db chown mysql:mysql /etc/mysql/mariadb.conf.d/50-server.cnf
docker exec espocrm-db chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf
```

5. **Reiniciar container:**
```bash
docker restart espocrm-db
```

---

## ✅ VERIFICAÇÃO APÓS APLICAÇÃO

### **1. Verificar que MySQL iniciou corretamente:**
```bash
docker logs espocrm-db --tail 50
```

### **2. Verificar configurações aplicadas:**
```bash
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';"
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit';"
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_log_file_size';"
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'sort_buffer_size';"
```

### **3. Verificar I/O wait (deve diminuir):**
```bash
ssh espo@37.27.1.242 "iostat -x 1 3 | grep -E 'avg-cpu|iowait'"
```

---

## 📊 RESULTADO ESPERADO

### **Antes:**
- I/O Wait: 17-18%
- Leituras de disco: 2,400+ ops/s
- Buffer pool: Padrão (pequeno)

### **Depois:**
- I/O Wait: 5-10% (redução significativa)
- Leituras de disco: Redução (mais dados em cache)
- Buffer pool: 5 GB (70% da RAM)

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Sempre fazer backup antes de alterar**
2. **Reiniciar container é necessário** para aplicar configurações
3. **Algumas configurações podem não ser aplicadas** se valores forem muito altos
4. **Monitorar após aplicar** para garantir que funcionou
5. **Se MySQL não iniciar**, restaurar backup

---

## 🚨 TROUBLESHOOTING

### **Problema: MySQL não inicia após alteração**

**Solução:**
```bash
# Restaurar backup
docker exec espocrm-db cp /etc/mysql/mariadb.conf.d/50-server.cnf.backup_* /etc/mysql/mariadb.conf.d/50-server.cnf
docker restart espocrm-db
```

### **Problema: Configuração não foi aplicada**

**Solução:**
- Verificar sintaxe do arquivo
- Verificar que está na seção `[mysqld]`
- Verificar logs do MySQL para erros

---

## 📋 CHECKLIST

- [ ] Fazer backup do arquivo original
- [ ] Escolher método de edição (vi, echo, ou copiar arquivo)
- [ ] Adicionar configurações ao arquivo
- [ ] Verificar sintaxe do arquivo
- [ ] Reiniciar container MySQL
- [ ] Verificar que MySQL iniciou corretamente
- [ ] Verificar que configurações foram aplicadas
- [ ] Monitorar I/O wait (deve diminuir)

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **PRONTO PARA APLICAÇÃO**

