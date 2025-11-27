-- =====================================================
-- SCRIPT SQL: Criar Tabelas application_logs_archive e log_statistics em PRODUÇÃO
-- =====================================================
-- Projeto: Criar Tabelas Archive Statistics PROD
-- Data: 23/11/2025
-- Versão: 1.0.0
-- Ambiente: PRODUÇÃO (rpa_logs_prod)
-- Servidor: prod.bssegurosimediato.com.br (IP: 157.180.36.223)
-- =====================================================
-- 
-- OBJETIVO:
-- Criar as tabelas application_logs_archive e log_statistics no banco de dados
-- de produção (rpa_logs_prod), idênticas às existentes no banco de desenvolvimento
-- (rpa_logs_dev), garantindo consistência entre ambientes.
--
-- TABELAS A CRIAR:
-- 1. application_logs_archive - Tabela de arquivo de logs antigos
-- 2. log_statistics - Tabela de estatísticas agregadas de logs
--
-- CARACTERÍSTICAS:
-- - Script idempotente (pode ser executado múltiplas vezes)
-- - Usa CREATE TABLE IF NOT EXISTS para evitar erros se tabelas já existirem
-- - Schema idêntico ao ambiente DEV
-- - Inclui ENUM com 'TRACE' (conforme alteração #001 do tracking)
--
-- VALIDAÇÃO:
-- Após execução, validar que tabelas foram criadas corretamente:
-- SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
-- WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
--   AND TABLE_NAME IN ('application_logs_archive', 'log_statistics');
-- =====================================================

-- Selecionar banco de dados de produção
USE rpa_logs_prod;

-- =====================================================
-- TABELA 1: application_logs_archive
-- =====================================================
-- Tabela para armazenar logs arquivados (logs antigos)
-- Mesma estrutura da tabela principal application_logs
-- =====================================================

CREATE TABLE IF NOT EXISTS application_logs_archive (
    -- Identificação
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    log_id VARCHAR(64) NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    
    -- Timestamps
    timestamp DATETIME(6) NOT NULL COMMENT 'Timestamp do servidor (precisão microsegundos)',
    client_timestamp DATETIME(6) NULL COMMENT 'Timestamp do cliente (browser)',
    server_time DECIMAL(20,6) NOT NULL COMMENT 'Unix timestamp com microsegundos',
    
    -- Nível e Categoria
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO',
    category VARCHAR(50) NULL COMMENT 'Categoria do log (UTILS, MODAL, RPA, etc.)',
    
    -- Localização do Código
    file_name VARCHAR(255) NOT NULL COMMENT 'Nome do arquivo que gerou o log',
    file_path TEXT NULL COMMENT 'Caminho completo do arquivo',
    line_number INT UNSIGNED NULL COMMENT 'Número da linha onde o log foi gerado',
    function_name VARCHAR(255) NULL COMMENT 'Nome da função/método',
    class_name VARCHAR(255) NULL COMMENT 'Nome da classe (se aplicável)',
    
    -- Mensagem e Dados
    message TEXT NOT NULL COMMENT 'Mensagem do log',
    data JSON NULL COMMENT 'Dados adicionais em formato JSON',
    stack_trace TEXT NULL COMMENT 'Stack trace completo (para erros)',
    
    -- Contexto da Requisição
    url TEXT NULL COMMENT 'URL da página onde o log foi gerado',
    session_id VARCHAR(64) NULL COMMENT 'ID da sessão do usuário',
    user_id VARCHAR(64) NULL COMMENT 'ID do usuário (se autenticado)',
    ip_address VARCHAR(45) NULL COMMENT 'Endereço IP do cliente (IPv4 ou IPv6)',
    user_agent TEXT NULL COMMENT 'User agent do navegador',
    
    -- Ambiente
    environment ENUM('development', 'production', 'staging') NOT NULL DEFAULT 'development',
    server_name VARCHAR(255) NULL COMMENT 'Nome do servidor',
    
    -- Metadados
    metadata JSON NULL COMMENT 'Metadados adicionais em formato JSON',
    tags VARCHAR(255) NULL COMMENT 'Tags separadas por vírgula para busca',
    
    -- Índices básicos para arquivo (otimizados para consultas de arquivo)
    INDEX idx_timestamp (timestamp),
    INDEX idx_level (level),
    INDEX idx_file_name (file_name(100))
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Logs arquivados (logs antigos)';

-- =====================================================
-- TABELA 2: log_statistics
-- =====================================================
-- Tabela para armazenar estatísticas agregadas de logs
-- Usada para melhorar performance de consultas estatísticas
-- =====================================================

CREATE TABLE IF NOT EXISTS log_statistics (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL COMMENT 'Data da estatística',
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL COMMENT 'Nível do log',
    count INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Contagem de logs para esta combinação',
    file_name VARCHAR(255) NULL COMMENT 'Nome do arquivo (opcional, para estatísticas por arquivo)',
    environment ENUM('development', 'production', 'staging') NOT NULL COMMENT 'Ambiente',
    
    -- Chave única composta para evitar duplicatas
    UNIQUE KEY uk_date_level_file_env (date, level, file_name(100), environment),
    
    -- Índices para performance
    INDEX idx_date (date),
    INDEX idx_level (level),
    INDEX idx_environment (environment)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Estatísticas agregadas de logs (para performance)';

-- =====================================================
-- VERIFICAÇÃO PÓS-CRIAÇÃO
-- =====================================================
-- Executar após criação para validar que tabelas foram criadas corretamente
-- =====================================================

-- Verificar que tabelas existem
-- SELECT TABLE_NAME 
-- FROM INFORMATION_SCHEMA.TABLES 
-- WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
--   AND TABLE_NAME IN ('application_logs_archive', 'log_statistics');

-- Verificar schema das tabelas criadas
-- SELECT 
--     TABLE_NAME,
--     COLUMN_NAME, 
--     COLUMN_TYPE, 
--     IS_NULLABLE, 
--     COLUMN_DEFAULT,
--     COLUMN_COMMENT
-- FROM INFORMATION_SCHEMA.COLUMNS 
-- WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
--   AND TABLE_NAME IN ('application_logs_archive', 'log_statistics')
-- ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
-- 
-- PRÓXIMOS PASSOS:
-- 1. Validar sintaxe SQL antes de executar
-- 2. Copiar script para servidor PROD via SCP
-- 3. Verificar hash SHA256 após cópia
-- 4. Executar script no banco PROD
-- 5. Validar que tabelas foram criadas corretamente
-- 6. Comparar schema com DEV para garantir consistência
-- =====================================================

