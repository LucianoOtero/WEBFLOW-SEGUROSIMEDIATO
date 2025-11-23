-- Script para corrigir senha do usuário MySQL rpa_logger_prod@localhost em PROD
-- Baseado na documentação oficial MySQL e comparação com ambiente DEV
-- Data: 16/11/2025

-- 1. Verificar plugin de autenticação atual
SELECT user, host, plugin, authentication_string FROM mysql.user WHERE user='rpa_logger_prod' AND host='localhost';

-- 2. Corrigir senha usando mysql_native_password (como em DEV)
-- Sintaxe para MariaDB: usar SET PASSWORD ou ALTER USER sem WITH
SET PASSWORD FOR 'rpa_logger_prod'@'localhost' = PASSWORD('tYbAwe7QkKNrHSRhaWplgsSxt');

-- 3. Atualizar privilégios
FLUSH PRIVILEGES;

-- 4. Verificar correção
SELECT user, host, plugin FROM mysql.user WHERE user='rpa_logger_prod' AND host='localhost';

