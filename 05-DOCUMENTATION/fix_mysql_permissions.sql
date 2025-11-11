-- Script para corrigir permissões do usuário MySQL
-- Execute: mysql -u root -p < fix_mysql_permissions.sql

GRANT ALL PRIVILEGES ON rpa_logs_dev.* TO 'rpa_logger_dev'@'%' IDENTIFIED BY 'tYbAwe7QkKNrHSRhaWplgsSxt';
FLUSH PRIVILEGES;

-- Verificar permissões
SELECT user, host FROM mysql.user WHERE user='rpa_logger_dev';

