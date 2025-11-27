#!/bin/bash
# Script de Implementação Datadog PHP-FPM - dev.flyingdonkeys.com.br
# Data: 25/11/2025
# Baseado na implementação bem-sucedida em dev.bssegurosimediato.com.br

set -e  # Parar em caso de erro

echo "=========================================="
echo "INSTALAÇÃO DATADOG PHP-FPM - FLYINGDONKEYS"
echo "Data: $(date)"
echo "=========================================="

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Função para exibir mensagens
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# PASSO 1: Verificar Datadog Agent
log_info "Verificando Datadog Agent..."
if ! systemctl is-active --quiet datadog-agent 2>/dev/null; then
    log_error "Datadog Agent não está instalado ou não está rodando"
    log_info "Por favor, instale o Datadog Agent primeiro"
    exit 1
fi
log_info "✅ Datadog Agent está rodando"

# PASSO 2: Identificar versão PHP e socket Unix
log_info "Identificando configuração PHP-FPM..."

# Tentar encontrar versão PHP
PHP_VERSION=""
for version in 8.3 8.2 8.1 8.0 7.4; do
    if systemctl list-units --type=service | grep -q "php${version}-fpm"; then
        PHP_VERSION=$version
        break
    fi
done

if [ -z "$PHP_VERSION" ]; then
    log_error "Não foi possível identificar versão do PHP-FPM"
    log_info "Versões testadas: 8.3, 8.2, 8.1, 8.0, 7.4"
    exit 1
fi

log_info "✅ PHP-FPM versão identificada: $PHP_VERSION"

# Identificar socket Unix
SOCKET_PATH=""
if [ -f "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" ]; then
    SOCKET_PATH=$(grep "^listen\s*=" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf | grep -v "^;" | head -1 | awk -F'=' '{print $2}' | tr -d ' ')
elif [ -f "/etc/php/${PHP_VERSION}/fpm/pool.d/default.conf" ]; then
    SOCKET_PATH=$(grep "^listen\s*=" /etc/php/${PHP_VERSION}/fpm/pool.d/default.conf | grep -v "^;" | head -1 | awk -F'=' '{print $2}' | tr -d ' ')
fi

if [ -z "$SOCKET_PATH" ]; then
    # Tentar caminhos comuns
    for common_path in "/run/php/php${PHP_VERSION}-fpm.sock" "/var/run/php/php${PHP_VERSION}-fpm.sock" "/var/run/php-fpm/php${PHP_VERSION}-fpm.sock"; do
        if [ -S "$common_path" ]; then
            SOCKET_PATH=$common_path
            break
        fi
    done
fi

if [ -z "$SOCKET_PATH" ] || [ ! -S "$SOCKET_PATH" ]; then
    log_error "Não foi possível identificar socket Unix do PHP-FPM"
    log_info "Socket procurado em: /etc/php/${PHP_VERSION}/fpm/pool.d/"
    log_info "Caminhos comuns testados: /run/php/php${PHP_VERSION}-fpm.sock, /var/run/php/php${PHP_VERSION}-fpm.sock"
    exit 1
fi

log_info "✅ Socket Unix identificado: $SOCKET_PATH"

# PASSO 3: Verificar permissões do socket
log_info "Verificando permissões do socket..."
SOCKET_OWNER=$(stat -c '%U:%G' "$SOCKET_PATH")
log_info "Proprietário do socket: $SOCKET_OWNER"

# PASSO 4: Verificar usuário dd-agent
log_info "Verificando usuário dd-agent..."
if ! id dd-agent &>/dev/null; then
    log_error "Usuário dd-agent não existe"
    exit 1
fi

# Verificar se dd-agent está no grupo www-data
if id -nG dd-agent | grep -qw www-data; then
    log_info "✅ dd-agent já está no grupo www-data"
else
    log_info "Adicionando dd-agent ao grupo www-data..."
    usermod -a -G www-data dd-agent
    if id -nG dd-agent | grep -qw www-data; then
        log_info "✅ dd-agent adicionado ao grupo www-data"
    else
        log_error "Falha ao adicionar dd-agent ao grupo www-data"
        exit 1
    fi
fi

# PASSO 5: Verificar acesso ao socket
log_info "Verificando acesso ao socket..."
if sudo -u dd-agent test -r "$SOCKET_PATH" 2>/dev/null; then
    log_info "✅ Socket acessível pelo dd-agent"
else
    log_warn "Socket não acessível pelo dd-agent (pode ser temporário)"
    log_info "Tentando novamente após 2 segundos..."
    sleep 2
    if sudo -u dd-agent test -r "$SOCKET_PATH" 2>/dev/null; then
        log_info "✅ Socket acessível pelo dd-agent"
    else
        log_error "Socket ainda não acessível. Verificar permissões manualmente."
        exit 1
    fi
fi

# PASSO 6: Criar backup (se arquivo existir)
CONFIG_FILE="/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml"
if [ -f "$CONFIG_FILE" ]; then
    BACKUP_FILE="${CONFIG_FILE}.backup_$(date +%Y%m%d_%H%M%S)"
    log_info "Criando backup: $BACKUP_FILE"
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    log_info "✅ Backup criado"
else
    log_info "Arquivo de configuração não existe (será criado)"
fi

# PASSO 7: Criar arquivo de configuração
log_info "Criando arquivo de configuração..."
mkdir -p /etc/datadog-agent/conf.d/php_fpm.d

cat > "$CONFIG_FILE" << EOF
init_config:

instances:
  - status_url: unix://${SOCKET_PATH}/status
    ping_url: unix://${SOCKET_PATH}/ping
    use_fastcgi: true
    ping_reply: pong
EOF

log_info "✅ Arquivo de configuração criado: $CONFIG_FILE"
log_info "Conteúdo:"
cat "$CONFIG_FILE"

# PASSO 8: Validar sintaxe
log_info "Validando sintaxe da configuração..."
if datadog-agent configcheck 2>&1 | grep -q "php_fpm"; then
    log_info "✅ Configuração válida"
else
    log_warn "Verificando configuração (pode mostrar avisos)..."
    datadog-agent configcheck 2>&1 | grep -A 5 php_fpm || true
fi

# PASSO 9: Reiniciar Datadog Agent
log_info "Reiniciando Datadog Agent..."
systemctl restart datadog-agent
sleep 5

if systemctl is-active --quiet datadog-agent; then
    log_info "✅ Datadog Agent reiniciado com sucesso"
else
    log_error "Falha ao reiniciar Datadog Agent"
    systemctl status datadog-agent --no-pager | head -20
    exit 1
fi

# PASSO 10: Validar integração
log_info "Validando integração PHP-FPM..."
sleep 3
INTEGRATION_STATUS=$(datadog-agent status 2>&1 | grep -A 15 "php_fpm" || echo "")

if echo "$INTEGRATION_STATUS" | grep -q "\[OK\]"; then
    log_info "✅ Integração PHP-FPM funcionando!"
    echo ""
    echo "$INTEGRATION_STATUS"
else
    log_warn "Status da integração:"
    echo "$INTEGRATION_STATUS"
    log_warn "Verificar logs se necessário: tail -f /var/log/datadog-agent/collector.log"
fi

# PASSO 11: Verificar PHP-FPM
log_info "Verificando PHP-FPM..."
if systemctl is-active --quiet "php${PHP_VERSION}-fpm"; then
    log_info "✅ PHP-FPM está rodando"
    systemctl status "php${PHP_VERSION}-fpm" --no-pager | head -10
else
    log_warn "PHP-FPM não está rodando (verificar manualmente)"
fi

echo ""
echo "=========================================="
log_info "IMPLEMENTAÇÃO CONCLUÍDA!"
echo "=========================================="
log_info "Próximos passos:"
log_info "1. Verificar métricas no dashboard Datadog (aguardar alguns minutos)"
log_info "2. Monitorar logs: tail -f /var/log/datadog-agent/collector.log"
log_info "3. Verificar status: datadog-agent status | grep -A 15 php_fpm"
echo ""

