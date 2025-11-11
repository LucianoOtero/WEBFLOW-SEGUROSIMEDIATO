#!/bin/bash
# Script de execução rápida dos testes de email
# Uso: ./executar_testes_email.sh [opções]

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║              EXECUTOR DE TESTES - SISTEMA DE ENVIO DE EMAIL                   ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se PHP está disponível
if ! command -v php &> /dev/null; then
    echo -e "${RED}❌ PHP não encontrado!${NC}"
    exit 1
fi

# Verificar se estamos no diretório correto
if [ ! -f "test_email_system_completo.php" ]; then
    echo -e "${RED}❌ Arquivo test_email_system_completo.php não encontrado!${NC}"
    echo "   Execute este script no diretório WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/"
    exit 1
fi

# Menu de opções
echo -e "${CYAN}Escolha o tipo de teste:${NC}"
echo ""
echo "  1) Teste completo (sem enviar emails)"
echo "  2) Teste completo (ENVIANDO emails reais)"
echo "  3) Teste de configuração apenas"
echo "  4) Teste da função apenas"
echo "  5) Teste do endpoint apenas"
echo "  6) Teste de integração apenas"
echo "  7) Teste de validação apenas"
echo "  8) Teste de conectividade AWS apenas"
echo "  9) Teste do endpoint HTTP"
echo "  0) Sair"
echo ""
read -p "Opção: " opcao

case $opcao in
    1)
        echo -e "${GREEN}Executando teste completo (sem enviar emails)...${NC}"
        php test_email_system_completo.php
        ;;
    2)
        echo -e "${YELLOW}⚠️  ATENÇÃO: Emails REAIS serão enviados!${NC}"
        read -p "Continuar? (s/N): " confirmar
        if [[ $confirmar =~ ^[Ss]$ ]]; then
            php test_email_system_completo.php --send-email
        else
            echo "Cancelado."
        fi
        ;;
    3)
        php test_email_system_completo.php --test=config
        ;;
    4)
        php test_email_system_completo.php --test=function
        ;;
    5)
        php test_email_system_completo.php --test=endpoint
        ;;
    6)
        echo -e "${YELLOW}⚠️  Este teste pode enviar emails reais${NC}"
        read -p "Enviar emails reais? (s/N): " enviar
        if [[ $enviar =~ ^[Ss]$ ]]; then
            php test_email_system_completo.php --test=integration --send-email
        else
            php test_email_system_completo.php --test=integration
        fi
        ;;
    7)
        php test_email_system_completo.php --test=validation
        ;;
    8)
        php test_email_system_completo.php --test=connectivity
        ;;
    9)
        echo -e "${YELLOW}⚠️  Este teste pode enviar emails reais${NC}"
        read -p "Enviar emails reais? (s/N): " enviar
        if [[ $enviar =~ ^[Ss]$ ]]; then
            php test_email_endpoint_http.php --send-email
        else
            php test_email_endpoint_http.php
        fi
        ;;
    0)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo -e "${RED}Opção inválida!${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Testes concluídos!${NC}"

