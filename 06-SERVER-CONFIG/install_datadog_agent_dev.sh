#!/bin/bash
# Script de Instalação Datadog Agent - Servidor DEV
# Data: 25/11/2025
# Servidor: dev.bssegurosimediato.com.br (65.108.156.14)

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
    datadog-agent version 2>&1 | tee -a "$LOG_FILE"
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

# Verificar RAM disponível
RAM_AVAILABLE=$(free -h | awk 'NR==2 {print $7}')
echo "[INFO] RAM disponível: $RAM_AVAILABLE" | tee -a "$LOG_FILE"

# Verificar conectividade
echo "[INFO] Verificando conectividade com Datadog..." | tee -a "$LOG_FILE"
if ! curl -I https://install.datadoghq.com/scripts/install_script_agent7.sh >/dev/null 2>&1; then
    echo "[ERROR] Não foi possível conectar ao servidor de instalação do Datadog" | tee -a "$LOG_FILE"
    exit 1
fi

# Executar instalação
echo "[INFO] Iniciando instalação do Datadog Agent..." | tee -a "$LOG_FILE"
echo "[INFO] API Key: ${DD_API_KEY:0:8}..." | tee -a "$LOG_FILE"
echo "[INFO] Ambiente: $DD_ENV" | tee -a "$LOG_FILE"
echo "[INFO] APM habilitado: $DD_APM_INSTRUMENTATION_ENABLED" | tee -a "$LOG_FILE"

bash -c "$(curl -L https://install.datadoghq.com/scripts/install_script_agent7.sh)" 2>&1 | tee -a "$LOG_FILE"

# Verificar instalação
echo "[INFO] Verificando instalação..." | tee -a "$LOG_FILE"
sleep 5  # Aguardar serviço iniciar

if systemctl is-active --quiet datadog-agent; then
    echo "[SUCCESS] Datadog Agent instalado e rodando com sucesso!" | tee -a "$LOG_FILE"
    echo "[INFO] Status do serviço:" | tee -a "$LOG_FILE"
    systemctl status datadog-agent --no-pager | head -15 | tee -a "$LOG_FILE"
    echo "[INFO] Versão instalada:" | tee -a "$LOG_FILE"
    datadog-agent version 2>&1 | tee -a "$LOG_FILE"
    echo "[INFO] Status do agente:" | tee -a "$LOG_FILE"
    datadog-agent status 2>&1 | head -30 | tee -a "$LOG_FILE"
else
    echo "[ERROR] Falha na instalação do Datadog Agent" | tee -a "$LOG_FILE"
    echo "[INFO] Verificar logs em: $LOG_FILE" | tee -a "$LOG_FILE"
    echo "[INFO] Verificar logs do sistema:" | tee -a "$LOG_FILE"
    journalctl -u datadog-agent --no-pager -n 20 | tee -a "$LOG_FILE"
    exit 1
fi

echo "[INFO] Instalação concluída. Log salvo em: $LOG_FILE" | tee -a "$LOG_FILE"
echo "[INFO] Próximos passos:" | tee -a "$LOG_FILE"
echo "[INFO] 1. Verificar métricas no dashboard Datadog" | tee -a "$LOG_FILE"
echo "[INFO] 2. Configurar integrações adicionais se necessário" | tee -a "$LOG_FILE"
echo "[INFO] 3. Monitorar consumo de recursos do agente" | tee -a "$LOG_FILE"

