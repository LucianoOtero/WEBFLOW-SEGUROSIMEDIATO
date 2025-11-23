-- Script para criar tabela application_logs no banco rpa_logs_prod
-- Baseado na documentação: LOGGING_DATABASE_SCHEMA.sql
-- Data: 16/11/2025

USE rpa_logs_prod;

-- =====================================================
-- TABELA PRINCIPAL: application_logs
-- =====================================================
CREATE TABLE IF NOT EXISTS application_logs (
    -- Identificação
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    log_id VARCHAR(64) UNIQUE NOT NULL COMMENT 'ID único do log (uniqid)',
    request_id VARCHAR(64) NOT NULL COMMENT 'ID da requisição HTTP',
    
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
    environment ENUM('development', 'production', 'staging') NOT NULL DEFAULT 'production',
    server_name VARCHAR(255) NULL COMMENT 'Nome do servidor',
    
    -- Índices para performance
    INDEX idx_log_id (log_id),
    INDEX idx_request_id (request_id),
    INDEX idx_timestamp (timestamp),
    INDEX idx_level (level),
    INDEX idx_category (category),
    INDEX idx_file_name (file_name(100)),
    INDEX idx_session_id (session_id),
    INDEX idx_environment (environment),
    INDEX idx_timestamp_level (timestamp, level),
    INDEX idx_category_level (category, level)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Logs principais do sistema de logging profissional';

-- Verificar criação
SHOW TABLES LIKE 'application_logs';
DESCRIBE application_logs;

