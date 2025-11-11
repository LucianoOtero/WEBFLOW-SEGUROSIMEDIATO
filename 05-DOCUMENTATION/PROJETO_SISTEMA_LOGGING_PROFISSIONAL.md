# 📋 PROJETO: SISTEMA DE LOGGING PROFISSIONAL EM SQL

**Data de Criação:** 08/11/2025  
**Status:** 📝 **PROJETO PROPOSTO** - Aguardando Autorização  
**Ambiente:** DEV e PROD  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Implementar um sistema de logging profissional que armazene todos os logs em banco de dados SQL, registrando:
- Tipo de log (nível de severidade)
- Arquivo que está registrando o log
- Linha de chamada
- Timestamp preciso
- Informações contextuais completas
- Sistema de recuperação e consulta eficiente

---

## 📚 PESQUISA DE BOAS PRÁTICAS DE MERCADO

### **1. Estrutura de Logs (Structured Logging)**
- ✅ **Formato estruturado:** JSON ou campos específicos no banco
- ✅ **Níveis padronizados:** DEBUG, INFO, WARN, ERROR, FATAL
- ✅ **Contexto completo:** Arquivo, linha, função, stack trace
- ✅ **Metadados:** IP, user agent, session, request ID

### **2. Performance e Escalabilidade**
- ✅ **Índices otimizados:** Timestamp, nível, arquivo, linha
- ✅ **Particionamento:** Por data para grandes volumes
- ✅ **Arquivamento:** Logs antigos movidos para tabelas de arquivo
- ✅ **Retenção configurável:** Políticas por nível de log

### **3. Segurança e Privacidade**
- ✅ **Sanitização:** Dados sensíveis mascarados
- ✅ **Controle de acesso:** Apenas usuários autorizados
- ✅ **Auditoria:** Log de quem acessa os logs
- ✅ **LGPD/GDPR:** Conformidade com regulamentações

### **4. Consulta e Análise**
- ✅ **API RESTful:** Endpoints para consulta
- ✅ **Filtros avançados:** Data, nível, arquivo, linha, texto
- ✅ **Paginação:** Para grandes volumes
- ✅ **Exportação:** CSV, JSON, PDF
- ✅ **Agregações:** Estatísticas e relatórios

### **5. Monitoramento e Alertas**
- ✅ **Alertas em tempo real:** Erros críticos
- ✅ **Dashboards:** Visualização de métricas
- ✅ **Tendências:** Análise de padrões

---

## 🗄️ ESTRUTURA DO BANCO DE DADOS

### **1. Tabela Principal: `application_logs`**

```sql
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
    
    -- Índice Full-Text para Busca
    FULLTEXT idx_message_fulltext (message),
    
    -- Particionamento (opcional, para grandes volumes)
    -- PARTITION BY RANGE (TO_DAYS(timestamp)) (
    --     PARTITION p2025_11 VALUES LESS THAN (TO_DAYS('2025-12-01')),
    --     PARTITION p2025_12 VALUES LESS THAN (TO_DAYS('2026-01-01')),
    --     PARTITION p_future VALUES LESS THAN MAXVALUE
    -- )
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Tabela principal de logs da aplicação';
```

### **2. Tabela de Arquivo: `application_logs_archive`**

```sql
CREATE TABLE application_logs_archive (
    -- Mesma estrutura da tabela principal
    -- Usada para logs arquivados (mais de X dias)
    -- Pode ser particionada por mês/ano
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Logs arquivados (logs antigos)';
```

### **3. Tabela de Estatísticas: `log_statistics`**

```sql
CREATE TABLE log_statistics (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL') NOT NULL,
    count INT UNSIGNED NOT NULL DEFAULT 0,
    file_name VARCHAR(255) NULL,
    environment ENUM('development', 'production', 'staging') NOT NULL,
    
    UNIQUE KEY uk_date_level_file_env (date, level, file_name(100), environment),
    INDEX idx_date (date),
    INDEX idx_level (level)
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Estatísticas agregadas de logs (para performance)';
```

### **4. Tabela de Configuração: `log_config`**

```sql
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
```

---

## 🔧 IMPLEMENTAÇÃO PHP

### **1. Classe Principal: `ProfessionalLogger.php`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Funcionalidades:**
- Captura automática de arquivo e linha usando `debug_backtrace()`
- Conexão com banco de dados usando PDO
- Sanitização de dados sensíveis
- Rate limiting
- Retry logic para falhas de conexão
- Buffer de logs para performance (opcional)

### **2. Endpoint de Logging: `log_endpoint.php`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`

**Funcionalidades:**
- Recebe logs via POST JSON
- Valida entrada
- Insere no banco de dados
- Retorna resposta JSON

### **3. Endpoint de Consulta: `log_query.php`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_query.php`

**Funcionalidades:**
- API RESTful para consulta de logs
- Filtros: data, nível, arquivo, linha, texto
- Paginação
- Ordenação
- Exportação (CSV, JSON)

### **4. Script de Manutenção: `log_maintenance.php`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_maintenance.php`

**Funcionalidades:**
- Arquivamento de logs antigos
- Limpeza de logs (conforme política de retenção)
- Geração de estatísticas
- Otimização de índices

---

## 📊 SISTEMA DE CONSULTA E RECUPERAÇÃO

### **1. API RESTful de Consulta**

**Endpoint:** `GET /log_query.php`

**Parâmetros:**
- `start_date`: Data inicial (YYYY-MM-DD)
- `end_date`: Data final (YYYY-MM-DD)
- `level`: Nível do log (DEBUG, INFO, WARN, ERROR, FATAL)
- `file_name`: Nome do arquivo (filtro)
- `line_number`: Número da linha (filtro)
- `category`: Categoria do log
- `search`: Busca full-text na mensagem
- `session_id`: ID da sessão
- `request_id`: ID da requisição
- `page`: Número da página (paginação)
- `limit`: Itens por página (padrão: 100)
- `sort`: Campo para ordenação (padrão: timestamp)
- `order`: Direção (ASC ou DESC, padrão: DESC)

**Exemplo de Resposta:**
```json
{
    "success": true,
    "data": [
        {
            "id": 12345,
            "log_id": "log_690ff8bca92660.55421836",
            "timestamp": "2025-11-08 23:13:16.692865",
            "level": "DEBUG",
            "category": "UTILS",
            "file_name": "FooterCodeSiteDefinitivoCompleto.js",
            "line_number": 1255,
            "function_name": "logDebug",
            "message": "🔍 Funções de debug disponíveis:",
            "data": null,
            "url": "https://segurosimediato-dev.webflow.io/",
            "session_id": "sess_1762654395625_3vzleofbj",
            "ip_address": "191.9.24.241"
        }
    ],
    "pagination": {
        "page": 1,
        "limit": 100,
        "total": 1234,
        "total_pages": 13
    },
    "filters_applied": {
        "start_date": "2025-11-08",
        "end_date": "2025-11-09",
        "level": "DEBUG"
    }
}
```

### **2. Endpoint de Estatísticas**

**Endpoint:** `GET /log_statistics.php`

**Funcionalidades:**
- Contagem de logs por nível
- Contagem por arquivo
- Contagem por categoria
- Gráficos de tendências
- Top 10 arquivos com mais erros

### **3. Endpoint de Exportação**

**Endpoint:** `GET /log_export.php`

**Formatos:**
- CSV
- JSON
- PDF (relatório formatado)

---

## 🔒 SEGURANÇA E PRIVACIDADE

### **1. Sanitização de Dados Sensíveis**

- **Senhas:** Sempre mascaradas (`****`)
- **CPF:** Apenas últimos 4 dígitos
- **Cartão de crédito:** Apenas últimos 4 dígitos
- **Tokens:** Primeiros e últimos caracteres apenas

### **2. Controle de Acesso**

- Autenticação via API key ou token
- Rate limiting por IP
- Logs de acesso à API de consulta

### **3. Conformidade LGPD/GDPR**

- Política de retenção configurável
- Exclusão de logs por solicitação
- Anonimização de dados pessoais

---

## ⚙️ CONFIGURAÇÃO

### **1. Variáveis de Ambiente (Docker)**

```yaml
# docker-compose.yml
environment:
  - LOG_DB_HOST=localhost
  - LOG_DB_PORT=3306
  - LOG_DB_NAME=rpa_logs
  - LOG_DB_USER=rpa_logger_dev
  - LOG_DB_PASS=<senha>
  - LOG_RETENTION_DAYS=90
  - LOG_ARCHIVE_DAYS=30
  - LOG_MAX_SIZE_MB=10000
```

### **2. Configurações no Banco**

```sql
INSERT INTO log_config (config_key, config_value, description) VALUES
('retention_days_debug', '30', 'Dias para retenção de logs DEBUG'),
('retention_days_info', '90', 'Dias para retenção de logs INFO'),
('retention_days_warn', '180', 'Dias para retenção de logs WARN'),
('retention_days_error', '365', 'Dias para retenção de logs ERROR'),
('retention_days_fatal', '730', 'Dias para retenção de logs FATAL'),
('archive_enabled', '1', 'Habilitar arquivamento automático'),
('max_log_size_mb', '10000', 'Tamanho máximo da tabela de logs em MB');
```

---

## 📋 FASES DE IMPLEMENTAÇÃO

### **Fase 1: Estrutura do Banco de Dados**
- [ ] Criar script SQL de criação das tabelas
- [ ] Criar índices otimizados
- [ ] Configurar particionamento (se necessário)
- [ ] Testar estrutura

### **Fase 2: Classe ProfessionalLogger**
- [ ] Implementar captura de arquivo/linha
- [ ] Implementar conexão com banco
- [ ] Implementar sanitização
- [ ] Implementar rate limiting
- [ ] Testes unitários

### **Fase 3: Endpoint de Logging**
- [ ] Criar `log_endpoint.php`
- [ ] Implementar validação
- [ ] Implementar inserção no banco
- [ ] Testes de integração

### **Fase 4: Sistema de Consulta**
- [ ] Criar `log_query.php`
- [ ] Implementar filtros
- [ ] Implementar paginação
- [ ] Implementar exportação
- [ ] Testes de performance

### **Fase 5: Scripts de Manutenção**
- [ ] Criar `log_maintenance.php`
- [ ] Implementar arquivamento
- [ ] Implementar limpeza
- [ ] Implementar estatísticas
- [ ] Agendar execução (cron)

### **Fase 6: Integração com Código Existente**
- [ ] Modificar `debug_logger_db.php` para usar novo sistema
- [ ] Atualizar JavaScript para enviar arquivo/linha
- [ ] Testes end-to-end

### **Fase 7: Documentação e Deploy**
- [ ] Documentar API
- [ ] Criar guia de uso
- [ ] Deploy em DEV
- [ ] Testes em DEV
- [ ] Deploy em PROD

---

## 🧪 TESTES

### **1. Testes Unitários**
- Captura de arquivo/linha
- Sanitização de dados
- Validação de entrada

### **2. Testes de Integração**
- Inserção no banco
- Consulta de logs
- Exportação

### **3. Testes de Performance**
- Volume de logs (1000+ por segundo)
- Consultas complexas
- Índices

### **4. Testes de Segurança**
- SQL Injection
- XSS
- Rate limiting

---

## 📊 MÉTRICAS E MONITORAMENTO

### **1. Métricas do Sistema**
- Logs por segundo
- Tamanho da tabela
- Tempo de resposta das consultas
- Taxa de erros

### **2. Alertas**
- Tabela de logs > 80% do tamanho máximo
- Taxa de erros > 10% em 5 minutos
- Falha na inserção de logs

---

## 📁 ESTRUTURA DE ARQUIVOS

```
WEBFLOW-SEGUROSIMEDIATO/
├── 02-DEVELOPMENT/
│   ├── ProfessionalLogger.php          # Classe principal
│   ├── log_endpoint.php                # Endpoint de logging
│   ├── log_query.php                   # API de consulta
│   ├── log_statistics.php              # API de estatísticas
│   ├── log_export.php                  # API de exportação
│   └── log_maintenance.php             # Scripts de manutenção
├── 05-DOCUMENTATION/
│   ├── PROJETO_SISTEMA_LOGGING_PROFISSIONAL.md  # Este arquivo
│   ├── LOGGING_API_DOCUMENTATION.md             # Documentação da API
│   └── LOGGING_DATABASE_SCHEMA.sql              # Script SQL
└── 04-BACKUPS/
    └── [backup dos arquivos modificados]
```

---

## ✅ CHECKLIST DE CONFORMIDADE COM DIRETIVAS

| Diretiva | Status | Observação |
|----------|--------|------------|
| **Autorização prévia** | ⏳ Pendente | Aguardando autorização do projeto |
| **Modificações locais** | ✅ Sim | Todos os arquivos serão criados localmente |
| **Backups locais** | ✅ Sim | Backups antes de modificar arquivos existentes |
| **Não modificar no servidor** | ✅ Sim | Criar localmente e copiar via scp |
| **Variáveis de ambiente** | ✅ Sim | Usar variáveis do Docker |
| **Documentação** | ✅ Sim | Documentação completa incluída |

---

## 🎯 PRÓXIMOS PASSOS

1. **Aguardar autorização do projeto**
2. **Criar backups dos arquivos existentes**
3. **Criar estrutura do banco de dados**
4. **Implementar classe ProfessionalLogger**
5. **Implementar endpoints**
6. **Testes e validação**
7. **Deploy em DEV**
8. **Deploy em PROD**

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0.0  
**Autor:** Sistema de IA (seguindo diretivas do projeto)

