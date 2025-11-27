# 📋 PLANEJAMENTO: Instalação Datadog Agent - Servidor DEV

**Data:** 25/11/2025  
**Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)  
**Status:** 📋 **PLANEJAMENTO** - Aguardando aprovação para execução  
**Prioridade:** Alta (monitoramento de produção)  
**Tempo Estimado:** 30-45 minutos

---

## 📋 SUMÁRIO EXECUTIVO

### **Objetivo:**
Instalar e configurar o Datadog Agent no servidor de desenvolvimento para monitoramento em tempo real do ambiente.

### **Contexto:**
- ✅ Servidor DEV: `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
- ✅ Sistema Operacional: Ubuntu (confirmar versão)
- ✅ Script de instalação fornecido pelo Datadog
- ✅ API Key fornecida: `a71e54e1268b8623f7bf0f64e402b07e`

### **Benefícios Esperados:**
- ✅ Monitoramento em tempo real do servidor
- ✅ Métricas de sistema (CPU, RAM, Disco, Rede)
- ✅ APM (Application Performance Monitoring) para PHP
- ✅ Logs centralizados
- ✅ Alertas automáticos

---

## 🔍 ANÁLISE DO SCRIPT FORNECIDO

### **Script de Instalação:**

```bash
DD_API_KEY=a71e54e1268b8623f7bf0f64e402b07e \
DD_SITE="datadoghq.com" \
DD_REMOTE_UPDATES=true \
DD_APM_INSTRUMENTATION_ENABLED=host \
DD_ENV=dev \
DD_APM_INSTRUMENTATION_LIBRARIES=java:1,python:3,js:5,php:1,dotnet:3,ruby:2 \
bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)"
```

### **Variáveis de Ambiente Configuradas:**

| Variável | Valor | Descrição |
|----------|-------|-----------|
| `DD_API_KEY` | `a71e54e1268b8623f7bf0f64e402b07e` | Chave de API do Datadog |
| `DD_SITE` | `datadoghq.com` | Site do Datadog (padrão) |
| `DD_REMOTE_UPDATES` | `true` | Permitir atualizações remotas |
| `DD_APM_INSTRUMENTATION_ENABLED` | `host` | Habilitar APM no host |
| `DD_ENV` | `dev` | Ambiente: desenvolvimento |
| `DD_APM_INSTRUMENTATION_LIBRARIES` | `java:1,python:3,js:5,php:1,dotnet:3,ruby:2` | Bibliotecas APM habilitadas |

### **Análise das Configurações:**

✅ **Configurações Corretas:**
- ✅ `DD_ENV=dev` - Ambiente correto (desenvolvimento)
- ✅ `DD_APM_INSTRUMENTATION_ENABLED=host` - APM habilitado
- ✅ `DD_APM_INSTRUMENTATION_LIBRARIES=php:1` - PHP habilitado (necessário para monitoramento)

⚠️ **Observações:**
- ⚠️ `DD_REMOTE_UPDATES=true` - Permite atualizações remotas (verificar se é desejado)
- ⚠️ Bibliotecas não-PHP habilitadas (java, python, js, dotnet, ruby) - Não são necessárias para este projeto, mas não causam problemas

---

## 📝 FASES DO PLANEJAMENTO

### **FASE 1: Verificação Pré-Instalação**

**Objetivo:** Verificar requisitos e estado atual do servidor

**Tarefas:**
- [ ] Verificar versão do Ubuntu no servidor
- [ ] Verificar se Datadog Agent já está instalado
- [ ] Verificar conectividade com internet (para download do script)
- [ ] Verificar espaço em disco disponível
- [ ] Verificar permissões de root/usuário

**Comandos de Verificação:**
```bash
# Verificar versão do Ubuntu
ssh root@65.108.156.14 "lsb_release -a"

# Verificar se Datadog já está instalado
ssh root@65.108.156.14 "systemctl status datadog-agent 2>/dev/null || echo 'Datadog não instalado'"

# Verificar espaço em disco
ssh root@65.108.156.14 "df -h"

# Verificar conectividade
ssh root@65.108.156.14 "curl -I https://install.datadoghq.com/scripts/install_script_agent7.sh"
```

---

### **FASE 2: Preparação do Script Local**

**Objetivo:** Criar script local para instalação (seguindo diretivas do projeto)

**Tarefas:**
- [ ] Criar script de instalação localmente
- [ ] Adicionar validações e verificações
- [ ] Adicionar logs de instalação
- [ ] Adicionar tratamento de erros

**Arquivo a Criar:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/install_datadog_agent_dev.sh`

**Estrutura do Script:**
```bash
#!/bin/bash
# Script de Instalação Datadog Agent - Servidor DEV
# Data: 25/11/2025
# Servidor: dev.bssegurosimediato.com.br

set -e  # Parar em caso de erro

# Variáveis de ambiente
export DD_API_KEY="a71e54e1268b8623f7bf0f64e402b07e"
export DD_SITE="datadoghq.com"
export DD_REMOTE_UPDATES=true
export DD_APM_INSTRUMENTATION_ENABLED=host
export DD_ENV=dev
export DD_APM_INSTRUMENTATION_LIBRARIES="java:1,python:3,js:5,php:1,dotnet:3,ruby:2"

# Log de instalação
LOG_FILE="/var/log/datadog_install_$(date +%Y%m%d_%H%M%S).log"

echo "==========================================" | tee -a "$LOG_FILE"
echo "INSTALAÇÃO DATADOG AGENT - SERVIDOR DEV" | tee -a "$LOG_FILE"
echo "Data: $(date)" | tee -a "$LOG_FILE"
echo "==========================================" | tee -a "$LOG_FILE"

# Verificações pré-instalação
echo "[INFO] Verificando requisitos..." | tee -a "$LOG_FILE"

# Verificar se já está instalado
if systemctl is-active --quiet datadog-agent 2>/dev/null; then
    echo "[WARN] Datadog Agent já está instalado e rodando" | tee -a "$LOG_FILE"
    echo "[INFO] Versão instalada:" | tee -a "$LOG_FILE"
    datadog-agent version | tee -a "$LOG_FILE"
    read -p "Deseja continuar com a instalação? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "[INFO] Instalação cancelada pelo usuário" | tee -a "$LOG_FILE"
        exit 0
    fi
fi

# Verificar espaço em disco
DISK_AVAILABLE=$(df -h / | awk 'NR==2 {print $4}')
echo "[INFO] Espaço em disco disponível: $DISK_AVAILABLE" | tee -a "$LOG_FILE"

# Verificar conectividade
echo "[INFO] Verificando conectividade com Datadog..." | tee -a "$LOG_FILE"
if ! curl -I https://install.datadoghq.com/scripts/install_script_agent7.sh >/dev/null 2>&1; then
    echo "[ERROR] Não foi possível conectar ao servidor de instalação do Datadog" | tee -a "$LOG_FILE"
    exit 1
fi

# Executar instalação
echo "[INFO] Iniciando instalação do Datadog Agent..." | tee -a "$LOG_FILE"
bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)" 2>&1 | tee -a "$LOG_FILE"

# Verificar instalação
if systemctl is-active --quiet datadog-agent; then
    echo "[SUCCESS] Datadog Agent instalado e rodando com sucesso!" | tee -a "$LOG_FILE"
    echo "[INFO] Status do serviço:" | tee -a "$LOG_FILE"
    systemctl status datadog-agent --no-pager | tee -a "$LOG_FILE"
    echo "[INFO] Versão instalada:" | tee -a "$LOG_FILE"
    datadog-agent version | tee -a "$LOG_FILE"
else
    echo "[ERROR] Falha na instalação do Datadog Agent" | tee -a "$LOG_FILE"
    echo "[INFO] Verificar logs em: $LOG_FILE" | tee -a "$LOG_FILE"
    exit 1
fi

echo "[INFO] Instalação concluída. Log salvo em: $LOG_FILE" | tee -a "$LOG_FILE"
```

---

### **FASE 3: Execução da Instalação**

**Objetivo:** Executar instalação do Datadog Agent no servidor

**Tarefas:**
- [ ] Copiar script para servidor
- [ ] Executar script de instalação
- [ ] Monitorar processo de instalação
- [ ] Verificar logs de instalação

**Comandos:**
```bash
# Copiar script para servidor
scp WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/install_datadog_agent_dev.sh root@65.108.156.14:/tmp/

# Executar instalação
ssh root@65.108.156.14 "chmod +x /tmp/install_datadog_agent_dev.sh && /tmp/install_datadog_agent_dev.sh"
```

---

### **FASE 4: Verificação Pós-Instalação**

**Objetivo:** Verificar que instalação foi bem-sucedida

**Tarefas:**
- [ ] Verificar status do serviço Datadog Agent
- [ ] Verificar versão instalada
- [ ] Verificar conectividade com Datadog
- [ ] Verificar métricas sendo coletadas
- [ ] Verificar logs do agente

**Comandos de Verificação:**
```bash
# Verificar status do serviço
ssh root@65.108.156.14 "systemctl status datadog-agent"

# Verificar versão
ssh root@65.108.156.14 "datadog-agent version"

# Verificar status do agente
ssh root@65.108.156.14 "datadog-agent status"

# Verificar logs
ssh root@65.108.156.14 "tail -50 /var/log/datadog/agent.log"
```

---

### **FASE 5: Configuração Adicional (Opcional)**

**Objetivo:** Configurar integrações adicionais se necessário

**Tarefas:**
- [ ] Configurar integração com Nginx (se necessário)
- [ ] Configurar integração com PHP-FPM (se necessário)
- [ ] Configurar integração com MySQL/MariaDB (se necessário)
- [ ] Configurar tags customizadas

**Arquivos de Configuração:**
- `/etc/datadog-agent/conf.d/nginx.d/conf.yaml`
- `/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml`
- `/etc/datadog-agent/datadog.yaml` (tags)

---

### **FASE 6: Documentação e Validação**

**Objetivo:** Documentar instalação e validar funcionamento

**Tarefas:**
- [ ] Documentar processo de instalação
- [ ] Documentar configurações aplicadas
- [ ] Validar que métricas aparecem no Datadog
- [ ] Criar documentação de uso

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Riscos Identificados:**

1. **Risco: Script de Instalação Externo**
   - **Mitigação:** Verificar URL do script antes de executar, usar script local com validações
   - **Teste:** Verificar conectividade com servidor Datadog antes de executar

2. **Risco: API Key Exposta**
   - **Mitigação:** API Key já está no script fornecido, mas será usada apenas no servidor
   - **Segurança:** API Key será usada apenas durante instalação, depois será armazenada em arquivo de configuração seguro

3. **Risco: Conflito com Instalação Existente**
   - **Mitigação:** Verificar se Datadog já está instalado antes de executar
   - **Teste:** Verificar status do serviço antes de instalar

4. **Risco: Falha na Instalação**
   - **Mitigação:** Script com tratamento de erros, logs detalhados
   - **Rollback:** Se falhar, remover instalação parcial

5. **Risco: Consumo de Recursos**
   - **Mitigação:** Datadog Agent é leve (~100-200 MB RAM), mas monitorar após instalação
   - **Teste:** Verificar consumo de recursos após instalação

---

## ✅ CHECKLIST DE VALIDAÇÃO

### **Antes de Iniciar:**
- [ ] Verificar versão do Ubuntu no servidor
- [ ] Verificar se Datadog já está instalado
- [ ] Verificar conectividade com internet
- [ ] Verificar espaço em disco disponível
- [ ] Criar script local de instalação

### **Durante Instalação:**
- [ ] Copiar script para servidor
- [ ] Executar script de instalação
- [ ] Monitorar processo de instalação
- [ ] Verificar logs de instalação

### **Após Instalação:**
- [ ] Verificar status do serviço Datadog Agent
- [ ] Verificar versão instalada
- [ ] Verificar conectividade com Datadog
- [ ] Verificar métricas sendo coletadas
- [ ] Validar que dados aparecem no dashboard Datadog
- [ ] Documentar instalação

---

## 📊 ARQUIVOS ENVOLVIDOS

### **Arquivos a Criar:**

1. **`WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/install_datadog_agent_dev.sh`**
   - Script de instalação local com validações

2. **`WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/INSTALACAO_DATADOG_DEV_20251125.md`**
   - Documentação do processo de instalação

### **Arquivos no Servidor (Após Instalação):**

1. **`/etc/datadog-agent/datadog.yaml`**
   - Configuração principal do Datadog Agent

2. **`/var/log/datadog/agent.log`**
   - Logs do Datadog Agent

3. **`/var/log/datadog_install_YYYYMMDD_HHMMSS.log`**
   - Log da instalação

---

## 🔧 DETALHAMENTO TÉCNICO

### **Requisitos do Sistema:**

- ✅ **Sistema Operacional:** Ubuntu (versão a verificar)
- ✅ **Espaço em Disco:** ~500 MB (estimado)
- ✅ **RAM:** ~100-200 MB (após instalação)
- ✅ **Conectividade:** Internet (para download e envio de métricas)
- ✅ **Permissões:** Root (para instalação)

### **O Que Será Instalado:**

1. **Datadog Agent 7.x**
   - Agente de monitoramento
   - Coleta de métricas do sistema
   - Envio de métricas para Datadog

2. **APM (Application Performance Monitoring)**
   - Monitoramento de aplicações PHP
   - Rastreamento de requisições
   - Análise de performance

3. **Integrações (Opcionais)**
   - Nginx (se configurado)
   - PHP-FPM (se configurado)
   - MySQL/MariaDB (se configurado)

---

## 📝 NOTAS IMPORTANTES

### **API Key:**
- ⚠️ **API Key:** `a71e54e1268b8623f7bf0f64e402b07e`
- ✅ Será armazenada em `/etc/datadog-agent/datadog.yaml` após instalação
- ✅ Arquivo protegido com permissões restritas (root apenas)

### **Ambiente:**
- ✅ **DD_ENV=dev** - Ambiente de desenvolvimento
- ✅ Métricas serão marcadas com tag `env:dev`

### **APM:**
- ✅ **PHP habilitado** - Monitoramento de aplicações PHP
- ✅ Outras linguagens habilitadas mas não serão usadas (não causam problemas)

### **Atualizações:**
- ⚠️ **DD_REMOTE_UPDATES=true** - Permite atualizações remotas
- ⚠️ Verificar se é desejado (pode ser alterado após instalação)

---

## 🚀 COMO SERÁ FEITO

### **Passo a Passo:**

1. **Verificação Pré-Instalação:**
   - Conectar via SSH ao servidor DEV
   - Verificar requisitos do sistema
   - Verificar se Datadog já está instalado

2. **Criação do Script Local:**
   - Criar script de instalação localmente
   - Adicionar validações e tratamento de erros
   - Adicionar logs detalhados

3. **Execução da Instalação:**
   - Copiar script para servidor
   - Executar script de instalação
   - Monitorar processo

4. **Verificação Pós-Instalação:**
   - Verificar status do serviço
   - Verificar logs
   - Validar que métricas aparecem no Datadog

5. **Documentação:**
   - Documentar processo de instalação
   - Documentar configurações aplicadas
   - Criar guia de uso

---

## ✅ CONCLUSÃO

### **Resumo do Planejamento:**

1. ✅ **Verificação Pré-Instalação:** Validar requisitos do sistema
2. ✅ **Criação de Script Local:** Script com validações e tratamento de erros
3. ✅ **Execução da Instalação:** Instalar Datadog Agent no servidor DEV
4. ✅ **Verificação Pós-Instalação:** Validar que instalação foi bem-sucedida
5. ✅ **Documentação:** Documentar processo e configurações

### **Tempo Estimado:**
- Verificação: 5 minutos
- Criação do script: 10 minutos
- Instalação: 15-20 minutos
- Verificação: 5 minutos
- Documentação: 5 minutos
- **Total: 30-45 minutos**

---

**Documento criado em:** 25/11/2025  
**Status:** 📋 **PLANEJAMENTO COMPLETO - AGUARDANDO APROVAÇÃO PARA EXECUÇÃO**

---

## ❓ PRÓXIMOS PASSOS

**Aguardando aprovação para iniciar execução do planejamento.**

**Após aprovação, seguirei a sequência:**
1. Verificar requisitos do servidor DEV
2. Criar script local de instalação
3. Executar instalação no servidor
4. Verificar instalação bem-sucedida
5. Documentar processo completo

