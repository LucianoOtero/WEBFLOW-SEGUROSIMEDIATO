-- =====================================================
-- SCRIPT: Verificar ENUM da coluna `level`
-- Ambiente: DEV ou PROD (ajustar USE conforme necessário)
-- Data: 21/11/2025
-- Projeto: Adicionar 'TRACE' ao ENUM da Coluna `level` no Banco de Dados
-- =====================================================

-- Ajustar USE conforme ambiente necessário
-- USE rpa_logs_dev;  -- Para DEV
-- USE rpa_logs_prod; -- Para PROD

-- =====================================================
-- VERIFICAÇÃO: application_logs
-- =====================================================

SELECT 
    'application_logs' as tabela,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    CASE 
        WHEN COLUMN_TYPE LIKE '%TRACE%' THEN '✅ TRACE presente'
        ELSE '❌ TRACE ausente'
    END as status_trace
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'application_logs' 
  AND COLUMN_NAME = 'level';

-- =====================================================
-- VERIFICAÇÃO: application_logs_archive (se existir)
-- =====================================================

SELECT 
    'application_logs_archive' as tabela,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    CASE 
        WHEN COLUMN_TYPE LIKE '%TRACE%' THEN '✅ TRACE presente'
        ELSE '❌ TRACE ausente'
    END as status_trace
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'application_logs_archive' 
  AND COLUMN_NAME = 'level';

-- =====================================================
-- VERIFICAÇÃO: log_statistics (se existir)
-- =====================================================

SELECT 
    'log_statistics' as tabela,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    CASE 
        WHEN COLUMN_TYPE LIKE '%TRACE%' THEN '✅ TRACE presente'
        ELSE '❌ TRACE ausente'
    END as status_trace
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'log_statistics' 
  AND COLUMN_NAME = 'level';

-- =====================================================
-- VERIFICAÇÃO: Todas as tabelas com coluna level
-- =====================================================

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    CASE 
        WHEN COLUMN_TYPE LIKE '%TRACE%' THEN '✅ TRACE presente'
        ELSE '❌ TRACE ausente'
    END as status_trace
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = DATABASE()
  AND COLUMN_NAME = 'level'
ORDER BY TABLE_NAME;

-- =====================================================
-- TESTE: Tentar inserir log com nível TRACE
-- =====================================================

-- Teste de inserção (apenas se necessário)
-- Descomentar para testar inserção

/*
INSERT INTO application_logs (
    log_id, request_id, timestamp, server_time,
    level, category, file_name, message
) VALUES (
    CONCAT('test_trace_', UNIX_TIMESTAMP()), 
    CONCAT('req_test_', UNIX_TIMESTAMP()), 
    NOW(), 
    UNIX_TIMESTAMP(NOW(6)),
    'TRACE', 
    'TEST', 
    'verificar_enum_level.sql', 
    'Teste de inserção de log TRACE'
);

-- Verificar inserção
SELECT * FROM application_logs 
WHERE log_id LIKE 'test_trace_%' 
ORDER BY timestamp DESC 
LIMIT 1;

-- Limpar teste (opcional)
-- DELETE FROM application_logs WHERE log_id LIKE 'test_trace_%';
*/

