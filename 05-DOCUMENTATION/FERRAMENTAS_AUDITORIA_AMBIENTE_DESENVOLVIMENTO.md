# 🔍 FERRAMENTAS DE AUDITORIA E GRAVAÇÃO: Ambiente de Desenvolvimento

**Data:** 21/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **RECOMENDAÇÕES COMPILADAS**

---

## 🎯 OBJETIVO

Documentar ferramentas disponíveis para **gravar e auditar** todas as atividades no ambiente de desenvolvimento:
- ✅ Cada arquivo copiado
- ✅ Cada script executado
- ✅ Cada comando rodado
- ✅ Cada mudança feita
- ✅ Histórico completo e auditável

---

## 🔐 FERRAMENTAS DE GRAVAÇÃO DE SESSÃO SSH

### **1. tlog (Terminal I/O Logger)** ⭐⭐⭐⭐⭐
- **Descrição:** Gravação completa de sessões SSH/Terminal
- **Funcionalidades:**
  - Grava todos os comandos executados
  - Grava toda a saída dos comandos
  - Grava timestamps precisos
  - Reprodução de sessões completas
  - Busca e filtragem de comandos
- **Instalação:**
  ```bash
  # Ubuntu/Debian
  sudo apt install tlog
  
  # CentOS/RHEL
  sudo yum install tlog
  ```
- **Configuração:**
  ```bash
  # Configurar em /etc/tlog/tlog-rec-session.conf
  # Gravar todas as sessões SSH
  ```
- **Uso no Projeto:**
  - Gravar todas as sessões SSH para servidores DEV/PROD
  - Auditoria completa de comandos executados
  - Reprodução de sessões para troubleshooting

### **2. script (Built-in Linux)** ⭐⭐⭐⭐
- **Descrição:** Ferramenta nativa do Linux para gravar sessões de terminal
- **Funcionalidades:**
  - Grava tudo que aparece no terminal
  - Arquivo de log timestampado
  - Simples e leve
- **Uso:**
  ```bash
  # Iniciar gravação
  script -a ~/sessao_$(date +%Y%m%d_%H%M%S).log
  
  # Executar comandos normalmente
  # Todos os comandos e saídas são gravados
  
  # Parar gravação
  exit
  ```
- **Uso no Projeto:**
  - Gravar sessões específicas de deploy
  - Documentar processos manuais
  - Criar histórico de comandos executados

### **3. asciinema** ⭐⭐⭐⭐
- **Descrição:** Gravação de sessões de terminal com reprodução
- **Funcionalidades:**
  - Gravação de sessões completas
  - Reprodução interativa
  - Compartilhamento de sessões
  - Exportação para texto/HTML
- **Instalação:**
  ```bash
  pip install asciinema
  ```
- **Uso:**
  ```bash
  # Gravar sessão
  asciinema rec sessao_deploy.cast
  
  # Reproduzir sessão
  asciinema play sessao_deploy.cast
  
  # Exportar para texto
  asciinema cat sessao_deploy.cast > sessao_deploy.txt
  ```
- **Uso no Projeto:**
  - Gravar processos de deploy
  - Documentar troubleshooting
  - Treinamento e onboarding

---

## 🔍 FERRAMENTAS DE AUDITORIA DE SISTEMA (Linux)

### **4. auditd (Linux Audit Daemon)** ⭐⭐⭐⭐⭐
- **Descrição:** Sistema de auditoria nativo do Linux
- **Funcionalidades:**
  - Monitora acesso a arquivos
  - Monitora execução de comandos
  - Monitora mudanças em configurações
  - Logs detalhados de todas as atividades
- **Instalação:**
  ```bash
  sudo apt install auditd
  sudo systemctl enable auditd
  sudo systemctl start auditd
  ```
- **Configuração para Monitorar Diretório de Desenvolvimento:**
  ```bash
  # Monitorar diretório de desenvolvimento
  sudo auditctl -w /var/www/html/dev/root -p rwxa -k dev_changes
  
  # Monitorar diretório de produção
  sudo auditctl -w /var/www/html/prod/root -p rwxa -k prod_changes
  
  # Ver logs
  sudo ausearch -k dev_changes
  ```
- **Uso no Projeto:**
  - Monitorar todas as mudanças em arquivos PHP/JS
  - Auditoria de quem modificou o quê
  - Rastreamento de alterações não autorizadas

### **5. inotify-tools** ⭐⭐⭐⭐
- **Descrição:** Monitoramento de mudanças em arquivos/diretórios
- **Funcionalidades:**
  - Detecta criação, modificação, exclusão de arquivos
  - Scripts customizados para ações
  - Logging de eventos
- **Instalação:**
  ```bash
  sudo apt install inotify-tools
  ```
- **Uso:**
  ```bash
  # Monitorar diretório
  inotifywait -m -r /var/www/html/dev/root --format '%w%f %e' -e create,modify,delete
  
  # Script para logar mudanças
  #!/bin/bash
  inotifywait -m -r /var/www/html/dev/root -e create,modify,delete |
  while read path action file; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') - $action - $path$file" >> /var/log/dev_changes.log
  done
  ```
- **Uso no Projeto:**
  - Monitorar mudanças em arquivos em tempo real
  - Criar log automático de alterações
  - Alertar sobre mudanças não autorizadas

---

## 📊 FERRAMENTAS DE VERSIONAMENTO E TRACKING

### **6. Git + GitLens** ⭐⭐⭐⭐⭐
- **Descrição:** Sistema de controle de versão + extensão VS Code
- **Funcionalidades:**
  - Rastreamento de todas as mudanças em código
  - Histórico completo de commits
  - Quem fez o quê e quando
  - Comparação entre versões
- **Uso no Projeto:**
  - Já implementado
  - Rastrear mudanças em arquivos locais
  - Histórico completo de desenvolvimento

### **7. Git Hooks (Pre-commit, Post-commit)** ⭐⭐⭐⭐
- **Descrição:** Scripts executados automaticamente em eventos Git
- **Funcionalidades:**
  - Validar código antes de commit
  - Registrar informações adicionais
  - Executar testes automáticos
- **Configuração:**
  ```bash
  # .git/hooks/pre-commit
  #!/bin/bash
  echo "Commit realizado em $(date)" >> ~/git_activity.log
  echo "Arquivos modificados:" >> ~/git_activity.log
  git diff --cached --name-only >> ~/git_activity.log
  ```
- **Uso no Projeto:**
  - Registrar automaticamente cada commit
  - Validar código antes de commit
  - Criar histórico de atividades Git

---

## 🛠️ FERRAMENTAS DE CI/CD E AUTOMAÇÃO

### **8. GitHub Actions / GitLab CI** ⭐⭐⭐⭐⭐
- **Descrição:** Pipelines de CI/CD com logs completos
- **Funcionalidades:**
  - Logs de todas as execuções
  - Histórico de deploys
  - Rastreamento de mudanças
  - Notificações automáticas
- **Uso no Projeto:**
  - Automatizar deploys com logs completos
  - Rastrear todas as execuções de scripts
  - Histórico auditável de todas as ações

### **9. Jenkins** ⭐⭐⭐⭐
- **Descrição:** Servidor de automação com logs detalhados
- **Funcionalidades:**
  - Logs de todas as builds
  - Histórico de execuções
  - Rastreamento de mudanças
  - Relatórios detalhados
- **Uso no Projeto:**
  - Automatizar processos de deploy
  - Criar histórico completo de execuções
  - Auditoria de todas as ações automatizadas

---

## 💻 EXTENSÕES VS CODE / CURSOR

### **10. Activity Bar** ⭐⭐⭐
- **ID:** `actboy168.activity-bar`
- **Descrição:** Mostra atividade recente no workspace
- **Funcionalidades:**
  - Arquivos modificados recentemente
  - Comandos executados
  - Histórico de atividades

### **11. Git History** ⭐⭐⭐⭐
- **ID:** `donjayamanne.githistory`
- **Descrição:** Visualização completa do histórico Git
- **Funcionalidades:**
  - Histórico de commits
  - Diferenças entre versões
  - Busca no histórico

### **12. Command Runner** ⭐⭐⭐
- **ID:** `edwardhsu.vscode-command-runner`
- **Descrição:** Executa comandos e mantém histórico
- **Funcionalidades:**
  - Histórico de comandos executados
  - Reexecução de comandos
  - Logs de execução

---

## 🔧 SOLUÇÃO RECOMENDADA PARA O PROJETO

### **Stack Completo de Auditoria:**

#### **1. Para Servidores (SSH):**
- ✅ **tlog** - Gravação completa de sessões SSH
- ✅ **auditd** - Auditoria de sistema (mudanças em arquivos)
- ✅ **inotify-tools** - Monitoramento em tempo real

#### **2. Para Desenvolvimento Local:**
- ✅ **Git + GitLens** - Rastreamento de código (já implementado)
- ✅ **Git Hooks** - Registro automático de commits
- ✅ **Scripts PowerShell** - Logging de comandos executados

#### **3. Para Automação:**
- ✅ **GitHub Actions** - Logs de pipelines (se implementado)
- ✅ **Scripts de deploy** - Com logging integrado

---

## 📋 IMPLEMENTAÇÃO PRÁTICA

### **FASE 1: Gravação de Sessões SSH**

**Instalar tlog no servidor DEV:**
```bash
ssh root@65.108.156.14
apt install tlog
systemctl enable tlog-rec-session
systemctl start tlog-rec-session
```

**Configurar gravação automática:**
```bash
# /etc/tlog/tlog-rec-session.conf
session {
    shell "/bin/bash"
    record_path "/var/log/tlog/sessions"
    record_size 100M
    record_count 10
}
```

**Consultar sessões gravadas:**
```bash
# Listar sessões
tlog-play -l

# Reproduzir sessão
tlog-play -r <session-id>

# Buscar comandos específicos
tlog-play -s "scp" -r <session-id>
```

---

### **FASE 2: Auditoria de Arquivos**

**Instalar auditd:**
```bash
ssh root@65.108.156.14
apt install auditd
systemctl enable auditd
systemctl start auditd
```

**Configurar regras de auditoria:**
```bash
# Monitorar diretório de desenvolvimento
auditctl -w /var/www/html/dev/root -p rwxa -k dev_changes

# Monitorar diretório de produção
auditctl -w /var/www/html/prod/root -p rwxa -k prod_changes

# Tornar regras permanentes
# Adicionar em /etc/audit/rules.d/dev-audit.rules
-w /var/www/html/dev/root -p rwxa -k dev_changes
-w /var/www/html/prod/root -p rwxa -k prod_changes
```

**Consultar logs de auditoria:**
```bash
# Ver mudanças em arquivos
ausearch -k dev_changes -i

# Ver mudanças específicas
ausearch -k dev_changes -f /var/www/html/dev/root/config.php

# Exportar para arquivo
ausearch -k dev_changes -i > /var/log/audit_dev_changes.log
```

---

### **FASE 3: Monitoramento em Tempo Real**

**Script de monitoramento com inotify:**
```bash
#!/bin/bash
# /usr/local/bin/monitor-dev-changes.sh

LOG_FILE="/var/log/dev_changes_$(date +%Y%m%d).log"
WATCH_DIR="/var/www/html/dev/root"

echo "Iniciando monitoramento de $WATCH_DIR em $(date)" >> $LOG_FILE

inotifywait -m -r "$WATCH_DIR" \
    --format '%T %w%f %e' \
    --timefmt '%Y-%m-%d %H:%M:%S' \
    -e create,modify,delete,move \
    >> $LOG_FILE
```

**Criar serviço systemd:**
```bash
# /etc/systemd/system/monitor-dev-changes.service
[Unit]
Description=Monitor Development Directory Changes
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/monitor-dev-changes.sh
Restart=always
StandardOutput=append:/var/log/monitor-dev-changes.log
StandardError=append:/var/log/monitor-dev-changes.log

[Install]
WantedBy=multi-user.target
```

---

### **FASE 4: Logging de Scripts PowerShell**

**Atualizar scripts para logar todas as ações:**
```powershell
# Adicionar no início de cada script
$LOG_FILE = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_SCRIPTS_DEPLOY_$(Get-Date -Format 'yyyyMMdd').log"

function Write-ActivityLog {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $LOG_FILE -Append
}

# Logar início do script
Write-ActivityLog "INICIO: replicar-php-prod.ps1 - Arquivo: $arquivo"

# Logar cada ação importante
Write-ActivityLog "Hash local calculado: $hashLocal"
Write-ActivityLog "Arquivo copiado para servidor: $servidorProd"
Write-ActivityLog "Hash PROD verificado: $hashProd"

# Logar fim do script
Write-ActivityLog "FIM: replicar-php-prod.ps1 - Status: Sucesso"
```

---

## 📊 DASHBOARD DE AUDITORIA

### **Criar Dashboard Unificado:**

**Arquivo: `dashboard-auditoria.html`**
- Visualizar sessões SSH gravadas (tlog)
- Visualizar mudanças em arquivos (auditd)
- Visualizar logs de scripts (PowerShell)
- Visualizar histórico Git (GitLens)
- Busca unificada em todos os logs

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **Servidor DEV:**
- [ ] Instalar tlog
- [ ] Configurar gravação automática de sessões SSH
- [ ] Instalar auditd
- [ ] Configurar regras de auditoria para diretórios DEV
- [ ] Instalar inotify-tools
- [ ] Criar script de monitoramento em tempo real
- [ ] Criar serviço systemd para monitoramento

### **Servidor PROD:**
- [ ] Instalar tlog
- [ ] Configurar gravação automática de sessões SSH
- [ ] Instalar auditd
- [ ] Configurar regras de auditoria para diretórios PROD
- [ ] Instalar inotify-tools
- [ ] Criar script de monitoramento em tempo real

### **Desenvolvimento Local:**
- [ ] Atualizar scripts PowerShell com logging
- [ ] Configurar Git Hooks para registro automático
- [ ] Criar dashboard de auditoria
- [ ] Configurar consultas unificadas

---

## 🔗 LINKS E DOCUMENTAÇÃO

### **Ferramentas:**
- **tlog:** https://github.com/Scribery/tlog
- **auditd:** https://linux.die.net/man/8/auditd
- **inotify-tools:** https://github.com/inotify-tools/inotify-tools
- **asciinema:** https://asciinema.org/

### **Documentação:**
- **tlog:** https://github.com/Scribery/tlog/wiki
- **auditd:** https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/chap-system_auditing
- **inotify:** https://man7.org/linux/man-pages/man7/inotify.7.html

---

## 🎯 CONCLUSÃO

### **Solução Recomendada:**

**Para Gravação Completa:**
1. ✅ **tlog** - Gravação de sessões SSH (servidores)
2. ✅ **auditd** - Auditoria de sistema (mudanças em arquivos)
3. ✅ **inotify-tools** - Monitoramento em tempo real

**Para Rastreamento de Código:**
1. ✅ **Git + GitLens** - Já implementado
2. ✅ **Git Hooks** - Registro automático

**Para Scripts:**
1. ✅ **Logging integrado** - Adicionar logging a todos os scripts
2. ✅ **Histórico de comandos** - Registrar cada execução

**Combinando essas ferramentas, você terá:**
- ✅ Gravação completa de todas as sessões SSH
- ✅ Auditoria de todas as mudanças em arquivos
- ✅ Histórico completo de comandos executados
- ✅ Rastreamento de código via Git
- ✅ Logs de todos os scripts executados

---

**Recomendações criadas para auditoria completa do ambiente de desenvolvimento.**

