#!/bin/bash
# Script para verificar logs de email em produção após 14:24 de hoje

echo "=== VERIFICAÇÃO DE LOGS DE EMAIL - PRODUÇÃO ==="
echo "Data/Hora atual: $(date)"
echo "Buscando logs após 14:24:00 de 16/11/2025"
echo ""

echo "--- 1. LOGS DO NGINX (Requisições ao endpoint) ---"
grep 'send_email_notification_endpoint' /var/log/nginx/access.log | tail -n 10
echo ""

echo "--- 2. LOGS DO PHP-FPM (Erros/Sucessos SES) ---"
grep -i 'SES: Email enviado\|SES: Erro\|EMAIL-ENDPOINT' /var/log/php8.3-fpm.log | tail -n 20
echo ""

echo "--- 3. LOGS DO BANCO DE DADOS (application_logs) ---"
mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod << 'SQL'
SELECT 
    id, 
    level, 
    category, 
    LEFT(message, 150) as message, 
    created_at 
FROM application_logs 
WHERE created_at >= '2025-11-16 14:24:00' 
AND (message LIKE '%email%' OR message LIKE '%send_email%' OR message LIKE '%SES%' OR category LIKE '%EMAIL%') 
ORDER BY created_at DESC 
LIMIT 30;
SQL
echo ""

echo "--- 4. LOGS DE DEBUG (log_endpoint_debug.txt) ---"
tail -n 50 /var/log/webflow-segurosimediato/log_endpoint_debug.txt | grep -i 'email\|send_email' | tail -n 10
echo ""

echo "=== VERIFICAÇÃO CONCLUÍDA ==="

