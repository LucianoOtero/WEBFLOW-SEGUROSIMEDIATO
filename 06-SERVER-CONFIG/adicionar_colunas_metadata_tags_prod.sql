-- Script para adicionar colunas metadata e tags à tabela application_logs
-- Data: 16/11/2025

USE rpa_logs_prod;

ALTER TABLE application_logs 
ADD COLUMN metadata JSON NULL COMMENT 'Metadados adicionais em formato JSON' AFTER server_name,
ADD COLUMN tags VARCHAR(255) NULL COMMENT 'Tags separadas por vírgula para busca' AFTER metadata;

-- Verificar estrutura
DESCRIBE application_logs;

