# 🔍 FERRAMENTAS DE AUDITORIA (AUDIT) NO LINUX

**Data:** 21/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **FERRAMENTAS DOCUMENTADAS**

---

## 🎯 OBJETIVO

Documentar ferramentas de **auditoria (audit)** disponíveis no Linux para:
- ✅ Gravar todas as atividades no servidor
- ✅ Monitorar mudanças em arquivos
- ✅ Rastrear comandos executados
- ✅ Auditoria completa e auditável

---

## 🔐 AUDITD (LINUX AUDIT DAEMON) ⭐⭐⭐⭐⭐

### **1. Descrição**

**auditd** é o daemon de auditoria nativo do Linux que:
- ✅ Grava eventos do sistema em logs
- ✅ Monitora acesso a arquivos
- ✅ Monitora execução de comandos
- ✅ Monitora mudanças em configurações
- ✅ Fornece rastreabilidade completa

---

### **2. Instalação**

#### **Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install auditd audispd-plugins
sudo systemctl enable auditd
sudo systemctl start auditd
```

#### **CentOS/RHEL:**
```bash
sudo yum install audit
sudo systemctl enable auditd
sudo systemctl start auditd
```

#### **Verificar Status:**
```bash
sudo systemctl status auditd
sudo auditctl -s
```

---

### **3. Comandos Principais**

#### **3.1. auditctl** - Configurar Regras de Auditoria

**Descrição:** Comando para adicionar/remover regras de auditoria

**Sintaxe:**
```bash
auditctl [opções] [regras]
```

**Exemplos:**

```bash
# Monitorar execução de SCP
sudo auditctl -a always,exit -F arch=b64 -S execve -F path=/usr/bin/scp -F key=scp_usage

# Monitorar diretório de desenvolvimento
sudo auditctl -w /var/www/html/dev/root -p rwxa -k dev_file_changes

# Monitorar diretório de produção
sudo auditctl -w /var/www/html/prod/root -p rwxa -k prod_file_changes

# Monitorar configuração PHP-FPM
sudo auditctl -w /etc/php/8.3/fpm/pool.d/www.conf -p rwxa -k php_fpm_config

# Monitorar configuração Nginx
sudo auditctl -w /etc/nginx/sites-available/ -p rwxa -k nginx_config

# Listar regras ativas
sudo auditctl -l

# Limpar todas as regras
sudo auditctl -D
```

**Parâmetros:**
- `-w` = Watch (monitorar arquivo/diretório)
- `-p` = Permissões (r=read, w=write, x=execute, a=attribute change)
- `-k` = Key (chave para identificar eventos)
- `-a` = Action (always,exit = sempre registrar na saída)
- `-S` = Syscall (chamada de sistema)
- `-F` = Field (campo de filtro)

---

#### **3.2. ausearch** - Consultar Logs de Auditoria

**Descrição:** Comando para buscar e consultar logs de auditoria

**Sintaxe:**
```bash
ausearch [opções] [filtros]
```

**Exemplos:**

```bash
# Buscar eventos por chave
sudo ausearch -k scp_usage

# Buscar eventos por chave com formato legível
sudo ausearch -k scp_usage -i

# Buscar eventos de hoje
sudo ausearch -k scp_usage --start today -i

# Buscar eventos de um período específico
sudo ausearch -k scp_usage --start 2025-11-21 00:00:00 --end 2025-11-21 23:59:59 -i

# Buscar eventos por arquivo específico
sudo ausearch -k dev_file_changes -f /var/www/html/dev/root/config.php -i

# Buscar eventos por usuário
sudo ausearch -k dev_file_changes -ui root -i

# Buscar eventos de criação de arquivo
sudo ausearch -k dev_file_changes -sc file -i

# Buscar eventos de modificação de arquivo
sudo ausearch -k dev_file_changes -sc file -i | grep -i "modify"

# Exportar para arquivo
sudo ausearch -k scp_usage -i > /var/log/audit_scp_$(date +%Y%m%d).log
```

**Parâmetros:**
- `-k` = Key (chave)
- `-i` = Interpret (formato legível)
- `-f` = File (arquivo específico)
- `-ui` = User ID (usuário)
- `-sc` = System call (chamada de sistema)
- `--start` = Data/hora inicial
- `--end` = Data/hora final

---

#### **3.3. aureport** - Relatórios de Auditoria

**Descrição:** Comando para gerar relatórios resumidos de auditoria

**Sintaxe:**
```bash
aureport [opções]
```

**Exemplos:**

```bash
# Relatório de eventos por chave
sudo aureport -k

# Relatório de eventos por usuário
sudo aureport -u

# Relatório de eventos por arquivo
sudo aureport -f

# Relatório de eventos de hoje
sudo aureport --start today

# Relatório de eventos de um período
sudo aureport --start 2025-11-21 00:00:00 --end 2025-11-21 23:59:59

# Relatório de eventos de SCP
sudo aureport -k --key scp_usage

# Relatório de eventos de mudanças em arquivos
sudo aureport -k --key dev_file_changes
```

---

#### **3.4. autrace** - Rastrear Processo Específico

**Descrição:** Comando para rastrear um processo específico

**Sintaxe:**
```bash
autrace [opções] comando
```

**Exemplo:**

```bash
# Rastrear execução de SCP
sudo autrace /usr/bin/scp arquivo.php servidor:/destino/

# Rastrear execução de script PHP
sudo autrace /usr/bin/php script.php
```

---

### **4. Configuração Permanente**

#### **4.1. Criar Arquivo de Regras**

**Arquivo:** `/etc/audit/rules.d/dev-audit.rules`

```bash
# Regras de auditoria para ambiente de desenvolvimento
# Criado em: 21/11/2025

# Monitorar execução de SCP
-a always,exit -F arch=b64 -S execve -F path=/usr/bin/scp -F key=scp_usage
-a always,exit -F arch=b32 -S execve -F path=/usr/bin/scp -F key=scp_usage

# Monitorar diretório de desenvolvimento
-w /var/www/html/dev/root -p rwxa -k dev_file_changes

# Monitorar diretório de produção
-w /var/www/html/prod/root -p rwxa -k prod_file_changes

# Monitorar configuração PHP-FPM DEV
-w /etc/php/8.3/fpm/pool.d/www.conf -p rwxa -k php_fpm_dev_config

# Monitorar configuração PHP-FPM PROD
-w /etc/php/8.3/fpm/pool.d/prod.conf -p rwxa -k php_fpm_prod_config

# Monitorar configurações Nginx
-w /etc/nginx/sites-available/ -p rwxa -k nginx_config
-w /etc/nginx/sites-enabled/ -p rwxa -k nginx_config

# Monitorar execução de comandos PHP
-a always,exit -F arch=b64 -S execve -F path=/usr/bin/php -F key=php_execution
-a always,exit -F arch=b64 -S execve -F path=/usr/bin/php8.3 -F key=php_execution

# Monitorar execução de comandos MySQL
-a always,exit -F arch=b64 -S execve -F path=/usr/bin/mysql -F key=mysql_execution

# Não excluir regras ao reiniciar
-D
```

#### **4.2. Aplicar Regras**

```bash
# Recarregar regras
sudo auditctl -R /etc/audit/rules.d/dev-audit.rules

# Ou reiniciar auditd
sudo systemctl restart auditd

# Verificar regras aplicadas
sudo auditctl -l
```

---

### **5. Consultar Logs**

#### **5.1. Localização dos Logs**

**Arquivo padrão:** `/var/log/audit/audit.log`

```bash
# Ver logs em tempo real
sudo tail -f /var/log/audit/audit.log

# Ver últimos 100 eventos
sudo tail -n 100 /var/log/audit/audit.log

# Buscar eventos específicos
sudo grep "scp_usage" /var/log/audit/audit.log

# Buscar eventos de hoje
sudo grep "$(date +%Y-%m-%d)" /var/log/audit/audit.log
```

#### **5.2. Formato dos Logs**

**Exemplo de log:**
```
type=SYSCALL msg=audit(1734825600.123:456): arch=c000003e syscall=59 
success=yes exit=0 a0=7ffd12345678 a1=7ffd12345679 a2=7ffd1234567a 
items=2 ppid=1234 pid=5678 auid=1000 uid=0 gid=0 euid=0 suid=0 
fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=1 comm="scp" 
exe="/usr/bin/scp" key="scp_usage"

type=PATH msg=audit(1734825600.123:456): item=0 name="/var/www/html/dev/root/config.php" 
inode=12345 dev=08:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 
nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
```

**Campos importantes:**
- `type` = Tipo de evento (SYSCALL, PATH, etc.)
- `msg=audit(...)` = Timestamp e ID do evento
- `comm` = Nome do comando executado
- `exe` = Caminho do executável
- `key` = Chave da regra de auditoria
- `name` = Caminho do arquivo acessado
- `nametype` = Tipo de operação (CREATE, MODIFY, DELETE)

---

### **6. Scripts Úteis**

#### **6.1. Script para Consultar Eventos de SCP**

**Arquivo:** `/usr/local/bin/consultar-scp-events.sh`

```bash
#!/bin/bash
# Script para consultar eventos de SCP

DATA_INICIO=${1:-$(date +%Y-%m-%d)}
DATA_FIM=${2:-$(date +%Y-%m-%d)}

echo "Consultando eventos de SCP de $DATA_INICIO até $DATA_FIM..."
echo ""

sudo ausearch -k scp_usage \
    --start "$DATA_INICIO 00:00:00" \
    --end "$DATA_FIM 23:59:59" \
    -i | grep -E "(comm=|name=|nametype=)" | head -50
```

**Uso:**
```bash
chmod +x /usr/local/bin/consultar-scp-events.sh
/usr/local/bin/consultar-scp-events.sh
/usr/local/bin/consultar-scp-events.sh 2025-11-21 2025-11-21
```

#### **6.2. Script para Consultar Mudanças em Arquivos**

**Arquivo:** `/usr/local/bin/consultar-mudancas-arquivos.sh`

```bash
#!/bin/bash
# Script para consultar mudanças em arquivos DEV

CHAVE=${1:-dev_file_changes}
DATA_INICIO=${2:-$(date +%Y-%m-%d)}

echo "Consultando mudanças em arquivos (chave: $CHAVE) desde $DATA_INICIO..."
echo ""

sudo ausearch -k "$CHAVE" \
    --start "$DATA_INICIO 00:00:00" \
    -i | grep -E "(name=|nametype=)" | sort | uniq
```

**Uso:**
```bash
chmod +x /usr/local/bin/consultar-mudancas-arquivos.sh
/usr/local/bin/consultar-mudancas-arquivos.sh dev_file_changes
```

---

### **7. Integração com Scripts PowerShell**

#### **7.1. Consultar Logs via PowerShell**

```powershell
# Consultar eventos de SCP do servidor
$servidor = "root@65.108.156.14"
$resultado = ssh $servidor "ausearch -k scp_usage --start today -i | head -20"
Write-Host $resultado

# Consultar mudanças em arquivos DEV
$resultado = ssh $servidor "ausearch -k dev_file_changes --start today -i | grep 'name=' | head -20"
Write-Host $resultado
```

---

### **8. Configuração de Retenção de Logs**

#### **8.1. Configurar Rotação de Logs**

**Arquivo:** `/etc/audit/auditd.conf`

```bash
# Número máximo de arquivos de log
num_logs = 5

# Tamanho máximo de cada arquivo de log (MB)
max_log_file = 50

# Ação quando espaço em disco está baixo
space_left = 100
space_left_action = email
admin_space_left = 50
admin_space_left_action = suspend
disk_full_action = suspend
disk_error_action = suspend
```

#### **8.2. Aplicar Configuração**

```bash
sudo systemctl restart auditd
```

---

## 📊 RESUMO DOS COMANDOS AUDITD

| Comando | Função | Exemplo |
|---------|--------|---------|
| **auditctl** | Configurar regras | `auditctl -w /path -p rwxa -k key` |
| **ausearch** | Consultar logs | `ausearch -k key -i` |
| **aureport** | Gerar relatórios | `aureport -k` |
| **autrace** | Rastrear processo | `autrace comando` |
| **auditctl -l** | Listar regras | `auditctl -l` |
| **auditctl -D** | Limpar regras | `auditctl -D` |

---

## ✅ CHECKLIST DE INSTALAÇÃO E CONFIGURAÇÃO

### **Instalação:**
- [ ] Instalar auditd: `apt install auditd`
- [ ] Habilitar serviço: `systemctl enable auditd`
- [ ] Iniciar serviço: `systemctl start auditd`
- [ ] Verificar status: `systemctl status auditd`

### **Configuração:**
- [ ] Criar arquivo de regras: `/etc/audit/rules.d/dev-audit.rules`
- [ ] Aplicar regras: `auditctl -R /etc/audit/rules.d/dev-audit.rules`
- [ ] Verificar regras: `auditctl -l`
- [ ] Configurar retenção: `/etc/audit/auditd.conf`

### **Teste:**
- [ ] Executar SCP e verificar log: `ausearch -k scp_usage -i`
- [ ] Modificar arquivo e verificar log: `ausearch -k dev_file_changes -i`
- [ ] Gerar relatório: `aureport -k`

---

## 🎯 CONCLUSÃO

### **Ferramentas de Auditoria Linux:**

**auditd (Essencial):**
- ✅ **auditctl** - Configurar regras de auditoria
- ✅ **ausearch** - Consultar logs de auditoria
- ✅ **aureport** - Gerar relatórios de auditoria
- ✅ **autrace** - Rastrear processos específicos

**Com auditd configurado:**
- ✅ Todas as atividades gravadas
- ✅ Mudanças em arquivos rastreadas
- ✅ Comandos executados registrados
- ✅ Histórico completo e auditável

---

**Ferramentas de auditoria Linux documentadas completamente.**

