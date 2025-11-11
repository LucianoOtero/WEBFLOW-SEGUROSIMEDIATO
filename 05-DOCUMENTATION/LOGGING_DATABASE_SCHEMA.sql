-- =====================================================
-- SISTEMA DE LOGGING PROFISSIONAL - ESTRUTURA DO BANCO
-- Versão: 1.0.0
-- Data: 2025-11-08
-- =====================================================

-- Criar banco de dados (se não existir)
-- Para DEV: rpa_logs_dev
-- Para PROD: rpa_logs_prod
CREATE DATABASE IF NOT EXISTS rpa_logs_dev 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

USE rpa_logs_dev;

-- =====================================================
-- TABELA PRINCIPAL: application_logs
-- =====================================================
CREATE TABLE application_logs (
    -- Identificação
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    log_id VARCHAR(64) UNIQUE NOT NULL COMMENT 'ID único do log (uniqid)',
    request_id VARCHAR(64) NOT NULL COMMENT 'ID da requisição HTTP',
    
    -- Timestamps
    timestamp DATETIME(6) NOT NULL COMMENT 'Timestamp do servidor (precisão microsegundos)',
    client_timestamp DATETIME(6) NULL COMMENT 'Timestamp do cliente (browser)',
    server_time DECIMAL(20,6) NOT NULL COMMENT 'Unix timestamp com microsegundos',
    
    -- Nível e Categoria
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL') NOT NULL DEFAULT 'INFO',
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
    
    -- Índices para Performance
    INDEX idx_timestamp (timestamp),
    INDEX idx_level (level),
    INDEX idx_category (category),
    INDEX idx_file_name (file_name(100)),
    INDEX idx_line_number (line_number),
    INDEX idx_session_id (session_id),
    INDEX idx_request_id (request_id),
    INDEX idx_environment (environment),
    INDEX idx_timestamp_level (timestamp, level),
    INDEX idx_file_line (file_name(100), line_number),
    INDEX idx_category_level (category, level),
    
    -- Índice Full-Text para Busca
    FULLTEXT idx_message_fulltext (message)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Tabela principal de logs da aplicação';

-- =====================================================
-- TABELA DE ARQUIVO: application_logs_archive
-- =====================================================
CREATE TABLE application_logs_archive (
    -- Mesma estrutura da tabela principal
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    log_id VARCHAR(64) NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    timestamp DATETIME(6) NOT NULL,
    client_timestamp DATETIME(6) NULL,
    server_time DECIMAL(20,6) NOT NULL,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL') NOT NULL DEFAULT 'INFO',
    category VARCHAR(50) NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NULL,
    line_number INT UNSIGNED NULL,
    function_name VARCHAR(255) NULL,
    class_name VARCHAR(255) NULL,
    message TEXT NOT NULL,
    data JSON NULL,
    stack_trace TEXT NULL,
    url TEXT NULL,
    session_id VARCHAR(64) NULL,
    user_id VARCHAR(64) NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    environment ENUM('development', 'production', 'staging') NOT NULL DEFAULT 'development',
    server_name VARCHAR(255) NULL,
    metadata JSON NULL,
    tags VARCHAR(255) NULL,
    
    -- Índices básicos para arquivo
    INDEX idx_timestamp (timestamp),
    INDEX idx_level (level),
    INDEX idx_file_name (file_name(100))
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Logs arquivados (logs antigos)';

-- =====================================================
-- TABELA DE ESTATÍSTICAS: log_statistics
-- =====================================================
CREATE TABLE log_statistics (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL') NOT NULL,
    count INT UNSIGNED NOT NULL DEFAULT 0,
    file_name VARCHAR(255) NULL,
    environment ENUM('development', 'production', 'staging') NOT NULL,
    
    UNIQUE KEY uk_date_level_file_env (date, level, file_name(100), environment),
    INDEX idx_date (date),
    INDEX idx_level (level),
    INDEX idx_environment (environment)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Estatísticas agregadas de logs (para performance)';

-- =====================================================
-- TABELA DE CONFIGURAÇÃO: log_config
-- =====================================================
CREATE TABLE log_config (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value TEXT NOT NULL,
    description TEXT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_key (config_key)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Configurações do sistema de logging';

-- =====================================================
-- INSERIR CONFIGURAÇÕES PADRÃO
-- =====================================================
INSERT INTO log_config (config_key, config_value, description) VALUES
('retention_days_debug', '30', 'Dias para retenção de logs DEBUG'),
('retention_days_info', '90', 'Dias para retenção de logs INFO'),
('retention_days_warn', '180', 'Dias para retenção de logs WARN'),
('retention_days_error', '365', 'Dias para retenção de logs ERROR'),
('retention_days_fatal', '730', 'Dias para retenção de logs FATAL'),
('archive_enabled', '1', 'Habilitar arquivamento automático (1=sim, 0=não)'),
('archive_days', '30', 'Arquivar logs mais antigos que X dias'),
('max_log_size_mb', '10000', 'Tamanho máximo da tabela de logs em MB'),
('cleanup_enabled', '1', 'Habilitar limpeza automática (1=sim, 0=não)'),
('max_logs_per_request', '1000', 'Máximo de logs retornados por requisição');

-- =====================================================
-- PROCEDURES ARMAZENADAS
-- =====================================================

-- Procedure para inserir log
DELIMITER //
CREATE PROCEDURE sp_insert_log(
    IN p_log_id VARCHAR(64),
    IN p_request_id VARCHAR(64),
    IN p_timestamp DATETIME(6),
    IN p_client_timestamp DATETIME(6),
    IN p_server_time DECIMAL(20,6),
    IN p_level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'),
    IN p_category VARCHAR(50),
    IN p_file_name VARCHAR(255),
    IN p_file_path TEXT,
    IN p_line_number INT UNSIGNED,
    IN p_function_name VARCHAR(255),
    IN p_class_name VARCHAR(255),
    IN p_message TEXT,
    IN p_data JSON,
    IN p_stack_trace TEXT,
    IN p_url TEXT,
    IN p_session_id VARCHAR(64),
    IN p_user_id VARCHAR(64),
    IN p_ip_address VARCHAR(45),
    IN p_user_agent TEXT,
    IN p_environment ENUM('development', 'production', 'staging'),
    IN p_server_name VARCHAR(255),
    IN p_metadata JSON,
    IN p_tags VARCHAR(255)
)
BEGIN
    INSERT INTO application_logs (
        log_id, request_id, timestamp, client_timestamp, server_time,
        level, category, file_name, file_path, line_number,
        function_name, class_name, message, data, stack_trace,
        url, session_id, user_id, ip_address, user_agent,
        environment, server_name, metadata, tags
    ) VALUES (
        p_log_id, p_request_id, p_timestamp, p_client_timestamp, p_server_time,
        p_level, p_category, p_file_name, p_file_path, p_line_number,
        p_function_name, p_class_name, p_message, p_data, p_stack_trace,
        p_url, p_session_id, p_user_id, p_ip_address, p_user_agent,
        p_environment, p_server_name, p_metadata, p_tags
    );
END //
DELIMITER ;

-- Procedure para arquivar logs antigos
DELIMITER //
CREATE PROCEDURE sp_archive_old_logs(IN p_days INT)
BEGIN
    DECLARE v_archive_date DATETIME(6);
    SET v_archive_date = DATE_SUB(NOW(6), INTERVAL p_days DAY);
    
    INSERT INTO application_logs_archive
    SELECT * FROM application_logs
    WHERE timestamp < v_archive_date;
    
    DELETE FROM application_logs
    WHERE timestamp < v_archive_date;
    
    SELECT ROW_COUNT() AS archived_count;
END //
DELIMITER ;

-- Procedure para limpar logs antigos (conforme retenção)
DELIMITER //
CREATE PROCEDURE sp_cleanup_logs()
BEGIN
    DECLARE v_debug_days INT;
    DECLARE v_info_days INT;
    DECLARE v_warn_days INT;
    DECLARE v_error_days INT;
    DECLARE v_fatal_days INT;
    
    -- Obter configurações
    SELECT CAST(config_value AS UNSIGNED) INTO v_debug_days FROM log_config WHERE config_key = 'retention_days_debug';
    SELECT CAST(config_value AS UNSIGNED) INTO v_info_days FROM log_config WHERE config_key = 'retention_days_info';
    SELECT CAST(config_value AS UNSIGNED) INTO v_warn_days FROM log_config WHERE config_key = 'retention_days_warn';
    SELECT CAST(config_value AS UNSIGNED) INTO v_error_days FROM log_config WHERE config_key = 'retention_days_error';
    SELECT CAST(config_value AS UNSIGNED) INTO v_fatal_days FROM log_config WHERE config_key = 'retention_days_fatal';
    
    -- Limpar logs DEBUG
    DELETE FROM application_logs_archive WHERE level = 'DEBUG' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_debug_days DAY);
    
    -- Limpar logs INFO
    DELETE FROM application_logs_archive WHERE level = 'INFO' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_info_days DAY);
    
    -- Limpar logs WARN
    DELETE FROM application_logs_archive WHERE level = 'WARN' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_warn_days DAY);
    
    -- Limpar logs ERROR
    DELETE FROM application_logs_archive WHERE level = 'ERROR' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_error_days DAY);
    
    -- Limpar logs FATAL
    DELETE FROM application_logs_archive WHERE level = 'FATAL' AND timestamp < DATE_SUB(NOW(6), INTERVAL v_fatal_days DAY);
    
    SELECT 'Cleanup completed' AS result;
END //
DELIMITER ;

-- =====================================================
-- VIEWS ÚTEIS
-- =====================================================

-- View para logs de erro
CREATE VIEW v_error_logs AS
SELECT 
    id, log_id, timestamp, level, category,
    file_name, line_number, function_name,
    message, url, session_id, ip_address
FROM application_logs
WHERE level IN ('ERROR', 'FATAL')
ORDER BY timestamp DESC;

-- View para estatísticas diárias
CREATE VIEW v_daily_statistics AS
SELECT 
    DATE(timestamp) AS date,
    level,
    COUNT(*) AS count,
    environment
FROM application_logs
GROUP BY DATE(timestamp), level, environment
ORDER BY date DESC, level;

-- =====================================================
-- TRIGGERS (Opcional - para auditoria)
-- =====================================================

-- Trigger para atualizar estatísticas (opcional, pode impactar performance)
-- DELIMITER //
-- CREATE TRIGGER trg_update_statistics
-- AFTER INSERT ON application_logs
-- FOR EACH ROW
-- BEGIN
--     INSERT INTO log_statistics (date, level, count, file_name, environment)
--     VALUES (DATE(NEW.timestamp), NEW.level, 1, NEW.file_name, NEW.environment)
--     ON DUPLICATE KEY UPDATE count = count + 1;
-- END //
-- DELIMITER ;

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================

