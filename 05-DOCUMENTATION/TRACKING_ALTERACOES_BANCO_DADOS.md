# 📋 TRACKING DE ALTERAÇÕES NO BANCO DE DADOS

**Data de Criação:** 21/11/2025  
**Versão:** 1.0.0  
**Propósito:** Registrar todas as alterações no banco de dados DEV para replicação em PROD

---

## 🎯 OBJETIVO

Este documento registra **TODAS** as alterações feitas no banco de dados DEV (`rpa_logs_dev`) para garantir rastreabilidade completa e facilitar a replicação idêntica em PROD (`rpa_logs_prod`).

---

## 📋 REGISTRO DE ALTERAÇÕES

### **Alteração #001 - 21/11/2025 - Adicionar 'TRACE' ao ENUM da coluna `level`**

**Data:** 21/11/2025  
**Hora:** ~23:30 UTC  
**Ambiente:** DEV (`rpa_logs_dev`)  
**Status:** ✅ **APLICADA**

#### **Motivo:**
Corrigir erro HTTP 500 ao inserir logs com nível 'TRACE' no banco de dados. O código PHP/JavaScript já aceita 'TRACE' como válido, mas o schema do banco não incluía 'TRACE' no ENUM.

#### **Tabelas Afetadas:**
1. `application_logs` - Tabela principal
2. `application_logs_archive` - Tabela de arquivo
3. `log_statistics` - Tabela de estatísticas

#### **Comandos SQL Executados:**

```sql
-- 1. application_logs
ALTER TABLE application_logs 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';

-- 2. application_logs_archive
ALTER TABLE application_logs_archive 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';

-- 3. log_statistics
ALTER TABLE log_statistics 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL;
```

#### **Scripts SQL Utilizados:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_dev.sql`
- Executado via: `mysql -u rpa_logger_dev -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_dev < /tmp/alterar_enum_trace.sql`

#### **Verificação Pré-Alteração:**
```sql
-- Schema ANTES da alteração
COLUMN_TYPE: enum('DEBUG','INFO','WARN','ERROR','FATAL')
```

#### **Verificação Pós-Alteração:**
```sql
-- Schema APÓS a alteração
COLUMN_TYPE: enum('DEBUG','INFO','WARN','ERROR','FATAL','TRACE')
```

#### **Teste de Validação:**
- ✅ Teste de inserção SQL executado com sucesso
- ✅ Log com nível 'TRACE' inserido corretamente
- ✅ Verificação via `INFORMATION_SCHEMA.COLUMNS` confirmou alteração

#### **Resultado:**
- ✅ Alteração aplicada com sucesso em todas as tabelas
- ✅ 'TRACE' adicionado ao ENUM em todas as tabelas afetadas
- ✅ Views atualizadas automaticamente pelo MySQL

#### **Arquivos Relacionados:**
- Script SQL: `06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_dev.sql`
- Script SQL PROD: `06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_prod.sql`
- Documentação: `ANALISE_ERRO_500_LOGS_TRACE_20251121.md`
- Projeto: `PROJETO_ADICIONAR_TRACE_ENUM_BANCO_DADOS_20251121.md`

#### **Status de Replicação em PROD:**
- ⏳ **PENDENTE** - Aguardando validação completa em DEV

---

### **Alteração #002 - 23/11/2025 - Criar tabelas `application_logs_archive` e `log_statistics` em PROD**

**Data:** 23/11/2025  
**Hora:** ~21:06 UTC  
**Ambiente:** PROD (`rpa_logs_prod`)  
**Status:** ✅ **APLICADA**

#### **Motivo:**
Criar as tabelas `application_logs_archive` e `log_statistics` no banco de dados de produção, idênticas às existentes no banco de desenvolvimento, garantindo consistência entre ambientes e preparando o sistema para funcionalidades futuras de arquivamento e estatísticas de logs.

#### **Tabelas Criadas:**
1. `application_logs_archive` - Tabela de arquivo de logs antigos
2. `log_statistics` - Tabela de estatísticas agregadas de logs

#### **Comandos SQL Executados:**

```sql
-- Criar application_logs_archive
CREATE TABLE IF NOT EXISTS application_logs_archive (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    log_id VARCHAR(64) NOT NULL,
    request_id VARCHAR(64) NOT NULL,
    timestamp DATETIME(6) NOT NULL,
    client_timestamp DATETIME(6) NULL,
    server_time DECIMAL(20,6) NOT NULL,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO',
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
    INDEX idx_timestamp (timestamp),
    INDEX idx_level (level),
    INDEX idx_file_name (file_name(100))
) ENGINE=InnoDB 
  DEFAULT CHARSET=utf8mb4 
  COLLATE=utf8mb4_unicode_ci
  COMMENT='Logs arquivados (logs antigos)';

-- Criar log_statistics
CREATE TABLE IF NOT EXISTS log_statistics (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL,
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
```

#### **Scripts SQL Utilizados:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabelas_archive_statistics_prod.sql`
- Executado via: `ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod < /tmp/criar_tabelas_archive_statistics_prod.sql"`

#### **Verificação Pré-Criação:**
```sql
-- Tabelas ANTES da criação
SHOW TABLES;
-- Resultado: application_logs, logs (apenas 2 tabelas)
```

#### **Verificação Pós-Criação:**
```sql
-- Tabelas APÓS a criação
SHOW TABLES;
-- Resultado: application_logs, application_logs_archive, log_statistics, logs (4 tabelas)
```

#### **Validação de Schema:**
- ✅ Schema de `application_logs_archive` idêntico ao DEV
- ✅ Schema de `log_statistics` idêntico ao DEV
- ✅ Índices criados corretamente
- ✅ ENUM inclui 'TRACE' em ambas as tabelas
- ✅ Constraints e chaves únicas criadas corretamente

#### **Teste de Validação:**
- ✅ Tabelas criadas com sucesso
- ✅ Schema validado e comparado com DEV
- ✅ Índices verificados
- ✅ ENUMs verificados (incluindo TRACE)

#### **Resultado:**
- ✅ Tabelas criadas com sucesso em PROD
- ✅ Schema idêntico ao DEV confirmado
- ✅ Consistência entre ambientes DEV e PROD garantida
- ✅ Sistema preparado para funcionalidades futuras de arquivamento e estatísticas

#### **Arquivos Relacionados:**
- Script SQL: `06-SERVER-CONFIG/criar_tabelas_archive_statistics_prod.sql`
- Script PowerShell: `02-DEVELOPMENT/scripts/copiar_sql_criar_tabelas_prod.ps1`
- Documentação: `PROJETO_CRIAR_TABELAS_ARCHIVE_STATISTICS_PROD_20251123.md`
- Análise: `ANALISE_PROJETO_CRIAR_TABELAS_ARCHIVE_STATISTICS_PROD_20251123.md`
- Auditoria: `AUDITORIA_PROJETO_CRIAR_TABELAS_ARCHIVE_STATISTICS_PROD_20251123.md`

#### **Status de Replicação em PROD:**
- ✅ **REPLICADA** - Tabelas criadas em PROD em 23/11/2025

---

## 📋 CHECKLIST DE REPLICAÇÃO PARA PROD

### **Antes de Replicar em PROD:**

- [ ] ✅ Alteração validada e testada em DEV
- [ ] ✅ Documentação completa desta alteração
- [ ] ✅ Script SQL para PROD criado e revisado
- [ ] ✅ Backup do banco PROD criado (se aplicável)
- [ ] ✅ Horário de manutenção agendado (se necessário)
- [ ] ✅ Plano de rollback preparado

### **Processo de Replicação:**

1. **Preparação:**
   - [ ] Verificar schema atual do banco PROD
   - [ ] Criar backup do banco PROD (se aplicável)
   - [ ] Revisar script SQL para PROD

2. **Execução:**
   - [ ] Executar script SQL em PROD
   - [ ] Verificar que alteração foi aplicada corretamente
   - [ ] Testar inserção de logs TRACE em PROD

3. **Validação:**
   - [ ] Confirmar que logs TRACE funcionam em PROD
   - [ ] Verificar que outros níveis continuam funcionando
   - [ ] Monitorar logs de erro por 24-48h

4. **Documentação:**
   - [ ] Marcar alteração como replicada em PROD
   - [ ] Registrar data/hora da replicação
   - [ ] Documentar qualquer problema encontrado

---

## 📊 HISTÓRICO DE ALTERAÇÕES

| # | Data | Descrição | Ambiente | Status PROD |
|---|------|-----------|----------|-------------|
| 001 | 21/11/2025 | Adicionar 'TRACE' ao ENUM da coluna `level` | DEV | ⏳ Pendente |
| 002 | 23/11/2025 | Criar tabelas `application_logs_archive` e `log_statistics` | PROD | ✅ Replicada |

---

## 🔧 PROCESSO DE TRACKING

### **Regras Obrigatórias:**

1. **ANTES de executar QUALQUER alteração no banco DEV:**
   - ✅ Criar entrada neste documento
   - ✅ Documentar motivo da alteração
   - ✅ Criar script SQL documentado
   - ✅ Registrar comandos SQL que serão executados

2. **DURANTE a execução:**
   - ✅ Executar comandos SQL documentados
   - ✅ Registrar resultados (antes/depois)
   - ✅ Executar testes de validação
   - ✅ Documentar problemas encontrados

3. **APÓS a execução:**
   - ✅ Atualizar status da alteração
   - ✅ Registrar resultado final
   - ✅ Atualizar checklist de replicação PROD
   - ✅ Criar/atualizar script SQL para PROD

4. **PARA replicação em PROD:**
   - ✅ Seguir checklist de replicação
   - ✅ Usar script SQL específico para PROD
   - ✅ Registrar data/hora da replicação
   - ✅ Atualizar status na tabela de histórico

---

## 📝 TEMPLATE PARA NOVAS ALTERAÇÕES

```markdown
### **Alteração #XXX - DD/MM/YYYY - [Descrição Breve]**

**Data:** DD/MM/YYYY  
**Hora:** HH:MM UTC  
**Ambiente:** DEV (`rpa_logs_dev`)  
**Status:** ⏳ **PENDENTE** / ✅ **APLICADA** / ❌ **FALHOU**

#### **Motivo:**
[Descrição detalhada do motivo da alteração]

#### **Tabelas Afetadas:**
1. `tabela1` - Descrição
2. `tabela2` - Descrição

#### **Comandos SQL Executados:**
```sql
-- Comando SQL 1
ALTER TABLE ...

-- Comando SQL 2
ALTER TABLE ...
```

#### **Scripts SQL Utilizados:**
- `caminho/para/script.sql`
- Executado via: `comando executado`

#### **Verificação Pré-Alteração:**
```sql
-- Resultado antes da alteração
```

#### **Verificação Pós-Alteração:**
```sql
-- Resultado após a alteração
```

#### **Teste de Validação:**
- ✅/❌ Teste 1
- ✅/❌ Teste 2

#### **Resultado:**
[Descrição do resultado]

#### **Arquivos Relacionados:**
- Script SQL: `caminho/script.sql`
- Documentação: `documento.md`
- Projeto: `projeto.md`

#### **Status de Replicação em PROD:**
- ⏳ **PENDENTE** / ✅ **REPLICADA** / ❌ **FALHOU**
```

---

## 🚨 IMPORTANTE

**NUNCA execute alterações no banco de dados sem:**
1. ✅ Registrar neste documento ANTES de executar
2. ✅ Criar script SQL documentado
3. ✅ Executar verificações antes e depois
4. ✅ Documentar resultados

**Para replicação em PROD:**
1. ✅ Aguardar validação completa em DEV
2. ✅ Seguir checklist de replicação
3. ✅ Usar script SQL específico para PROD
4. ✅ Registrar data/hora da replicação

---

**Última Atualização:** 23/11/2025 - Alteração #002 registrada (tabelas criadas em PROD)

---

## 📚 DOCUMENTAÇÃO RELACIONADA

- **Histórico de Replicações:** `HISTORICO_REPLICACAO_PRODUCAO.md` - Registro de todas as replicações para PROD
- **Processo de Tracking:** `PROCESSO_TRACKING_ALTERACOES_BANCO_DADOS.md` - Processo obrigatório para alterações

