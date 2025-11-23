-- =====================================================
-- SCRIPT: Adicionar 'TRACE' ao ENUM da coluna `level`
-- Ambiente: DEV (rpa_logs_dev)
-- Data: 21/11/2025
-- Projeto: Adicionar 'TRACE' ao ENUM da Coluna `level` no Banco de Dados
-- =====================================================

-- Verificar banco de dados atual
USE rpa_logs_dev;

-- =====================================================
-- TABELA: application_logs
-- =====================================================

-- Verificar schema atual antes de alterar
SELECT 
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rpa_logs_dev' 
  AND TABLE_NAME = 'application_logs' 
  AND COLUMN_NAME = 'level';

-- Alterar ENUM para incluir 'TRACE'
-- Script é idempotente: pode ser executado múltiplas vezes
ALTER TABLE application_logs 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';

-- Verificar alteração aplicada
SELECT 
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rpa_logs_dev' 
  AND TABLE_NAME = 'application_logs' 
  AND COLUMN_NAME = 'level';

-- =====================================================
-- TABELA: application_logs_archive (se existir)
-- =====================================================

-- Verificar se tabela existe antes de alterar
SELECT COUNT(*) as table_exists
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'rpa_logs_dev' 
  AND TABLE_NAME = 'application_logs_archive';

-- Alterar ENUM se tabela existir
-- Nota: Este comando falhará silenciosamente se tabela não existir
-- Para executar condicionalmente, use o script de verificação primeiro
ALTER TABLE application_logs_archive 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';

-- =====================================================
-- TABELA: log_statistics (se existir)
-- =====================================================

-- Verificar se tabela existe antes de alterar
SELECT COUNT(*) as table_exists
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'rpa_logs_dev' 
  AND TABLE_NAME = 'log_statistics';

-- Alterar ENUM se tabela existir
-- Nota: Esta tabela não tem DEFAULT, então não incluímos DEFAULT na alteração
ALTER TABLE log_statistics 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL;

-- =====================================================
-- VERIFICAÇÃO FINAL
-- =====================================================

-- Verificar todas as tabelas alteradas
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rpa_logs_dev' 
  AND COLUMN_NAME = 'level'
ORDER BY TABLE_NAME;

-- Mensagem de sucesso
SELECT '✅ Alteração aplicada com sucesso! Verifique os resultados acima.' as status;

