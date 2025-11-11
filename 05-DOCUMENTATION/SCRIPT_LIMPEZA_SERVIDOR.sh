#!/bin/bash
# Script de limpeza completa do servidor
# Remove todos os containers Docker e arquivos antigos

set -e  # Parar em caso de erro

echo "🗑️  INICIANDO LIMPEZA COMPLETA DO SERVIDOR"
echo "=========================================="
echo ""

# Confirmar ação
read -p "⚠️  Esta ação irá REMOVER TODOS os containers Docker e arquivos antigos. Continuar? (sim/não): " confirmacao
if [ "$confirmacao" != "sim" ]; then
    echo "❌ Operação cancelada."
    exit 1
fi

echo ""
echo "1️⃣  Parando containers..."
docker stop $(docker ps -aq) 2>/dev/null || echo "  Nenhum container rodando"

echo ""
echo "2️⃣  Removendo containers..."
docker rm $(docker ps -aq) 2>/dev/null || echo "  Nenhum container para remover"

echo ""
echo "3️⃣  Removendo imagens..."
docker rmi $(docker images -q) 2>/dev/null || echo "  Nenhuma imagem para remover"

echo ""
echo "4️⃣  Removendo volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null || echo "  Nenhum volume para remover"

echo ""
echo "5️⃣  Removendo networks..."
docker network prune -f

echo ""
echo "6️⃣  Limpando sistema Docker..."
docker system prune -a -f --volumes

echo ""
echo "7️⃣  Removendo arquivos antigos..."
rm -rf /opt/webhooks-server/dev/root/*
rm -rf /opt/webhooks-server/prod/root/*
rm -rf /opt/webhooks-server/dev/logs/*
rm -rf /opt/webhooks-server/prod/logs/*
rm -rf /opt/webhooks-server/docker-compose.yml
rm -rf /opt/webhooks-server/Dockerfile
rm -rf /opt/webhooks-server/.dockerignore

echo ""
echo "8️⃣  Verificando limpeza..."
echo "  Containers: $(docker ps -aq | wc -l)"
echo "  Imagens: $(docker images -q | wc -l)"
echo "  Volumes: $(docker volume ls -q | wc -l)"

echo ""
echo "✅ Limpeza concluída!"
echo ""
echo "📋 PRÓXIMOS PASSOS:"
echo "  1. Instalar PHP, Nginx, MySQL (FASE 2)"
echo "  2. Configurar variáveis de ambiente (FASE 3)"
echo "  3. Copiar arquivos do Windows (FASE 4)"





