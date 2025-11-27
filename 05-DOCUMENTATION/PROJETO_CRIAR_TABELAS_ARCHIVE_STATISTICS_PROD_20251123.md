# 🎯 PROJETO: Criar Tabelas `application_logs_archive` e `log_statistics` em PRODUÇÃO

**Data de Criação:** 23/11/2025  
**Versão:** 1.2.0  
**Status:** ✅ **CONCLUÍDO** - Tabelas criadas com sucesso em PROD  
**Última Atualização:** 23/11/2025 - Versão 1.2.0 (Projeto concluído - FASE 8 finalizada)

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Criar as tabelas `application_logs_archive` e `log_statistics` no banco de dados de produção (`rpa_logs_prod`), idênticas às existentes no banco de dados de desenvolvimento (`rpa_logs_dev`), garantindo consistência entre ambientes e preparando o sistema para funcionalidades futuras de arquivamento e estatísticas de logs.

### Contexto

**Situação Atual:**
- ✅ **DEV:** As 3 tabelas existem (`application_logs`, `application_logs_archive`, `log_statistics`)
- ⚠️ **PROD:** Apenas 1 tabela existe (`application_logs`)
- ❌ **PROD:** `application_logs_archive` não existe
- ❌ **PROD:** `log_statistics` não existe

**Impacto da Inconsistência:**
- Scripts SQL que alteram múltiplas tabelas falham em PROD (ex: adicionar TRACE ao ENUM)
- Funcionalidades futuras de arquivamento não podem ser implementadas em PROD
- Estatísticas agregadas não podem ser geradas em PROD
- Inconsistência entre ambientes dificulta manutenção e replicação

### Problema a Resolver

O banco de dados de produção está incompleto em relação ao banco de desenvolvimento, faltando 2 tabelas essenciais do sistema de logging:
- `application_logs_archive` - Para arquivamento de logs antigos
- `log_statistics` - Para estatísticas agregadas de logs

Essa inconsistência causa:
- ❌ Falhas em scripts SQL que tentam alterar essas tabelas
- ❌ Impossibilidade de implementar funcionalidades de arquivamento em PROD
- ❌ Impossibilidade de gerar estatísticas agregadas em PROD
- ❌ Dificuldade em manter scripts SQL compatíveis entre DEV e PROD

### Escopo

- **Tabelas a Criar em PROD:**
  - `application_logs_archive` - Tabela de arquivo de logs antigos
  - `log_statistics` - Tabela de estatísticas agregadas

- **Arquivos SQL:**
  - Script de criação: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabelas_archive_statistics_prod.sql` (será criado)

- **Ambientes Afetados:**
  - ✅ PROD: `rpa_logs_prod` (IP: 157.180.36.223)

- **Arquivos de Referência:**
  - Schema DEV: `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/LOGGING_DATABASE_SCHEMA.sql`
  - Tabelas DEV existentes para comparação

### Impacto Esperado

- ✅ **Consistência:** Banco PROD alinhado com banco DEV
- ✅ **Compatibilidade:** Scripts SQL funcionarão em ambos os ambientes
- ✅ **Preparação:** Sistema pronto para funcionalidades futuras de arquivamento
- ✅ **Estatísticas:** Capacidade de gerar estatísticas agregadas em PROD
- ✅ **Manutenção:** Facilita manutenção e replicação de alterações
- ✅ **Zero Breaking Changes:** Não afeta funcionalidades existentes

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### Objetivo do Usuário

Criar as tabelas `application_logs_archive` e `log_statistics` no banco de dados de produção, idênticas às existentes no banco de dados de desenvolvimento, garantindo consistência entre ambientes.

### Contexto e Justificativa

**Por que criar essas tabelas:**
- Consistência entre ambientes DEV e PROD
- Scripts SQL que alteram múltiplas tabelas falham em PROD quando essas tabelas não existem
- Preparação para funcionalidades futuras de arquivamento e estatísticas
- Facilita manutenção e replicação de alterações entre ambientes

**Por que agora:**
- Inconsistência foi identificada durante execução de script SQL em PROD
- Tabelas já existem e funcionam corretamente em DEV
- Schema completo já está documentado
- Processo de criação de tabelas é simples e seguro

### Expectativas do Usuário

1. **Criação Idêntica:** Tabelas criadas exatamente como em DEV
2. **Validação Completa:** Verificação de que tabelas foram criadas corretamente
3. **Documentação:** Registro completo da criação realizada
4. **Segurança:** Processo seguro sem impacto em funcionalidades existentes
5. **Consistência:** Banco PROD alinhado com banco DEV

---

## 🎯 FASES DO PROJETO

### **FASE 1: Preparação e Verificação Pré-Criação**

**Objetivo:** Verificar condições prévias e preparar ambiente para criação das tabelas.

**Tarefas:**
1. ✅ Verificar schema das tabelas em DEV
2. ✅ Confirmar que tabelas não existem em PROD
3. ✅ Verificar conectividade com servidor PROD
4. ✅ Documentar schema atual das tabelas em DEV

**Entregas:**
- Documentação do schema das tabelas em DEV
- Verificação de que tabelas não existem em PROD
- Confirmação de conectividade com PROD

**Critérios de Sucesso:**
- Schema das tabelas em DEV documentado
- Confirmação de que tabelas não existem em PROD
- Conectividade com PROD confirmada

---

### **FASE 2: Criação de Todos os Arquivos**

**Objetivo:** Criar todos os arquivos necessários antes de validar e executar.

**Tarefas:**
1. ✅ Extrair schema das tabelas de DEV
2. ✅ Criar script SQL com CREATE TABLE para `application_logs_archive`
3. ✅ Criar script SQL com CREATE TABLE para `log_statistics`
4. ✅ Adicionar comentários e documentação no script
5. ✅ Criar script PowerShell para cópia do SQL para servidor (se necessário)
6. ✅ Criar script PowerShell para validação do SQL (se necessário)
7. ✅ Criar script PowerShell para execução do SQL (se necessário)

**Entregas:**
- Script SQL: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabelas_archive_statistics_prod.sql`
- Script PowerShell de cópia: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/copiar_sql_criar_tabelas_prod.ps1` (se necessário)
- Script PowerShell de validação: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/validar_sql_criar_tabelas_prod.ps1` (se necessário)
- Script PowerShell de execução: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/executar_sql_criar_tabelas_prod.ps1` (se necessário)

**Critérios de Sucesso:**
- Todos os arquivos criados
- Script SQL com schema idêntico ao DEV
- Scripts PowerShell criados (se necessário)
- Todos os arquivos documentados com comentários

---

### **FASE 3: Validação de Todos os Arquivos**

**Objetivo:** Validar todos os arquivos criados antes de copiar para produção.

**Tarefas:**
1. ✅ Validar sintaxe SQL do script SQL (parênteses, aspas, comandos)
2. ✅ Comparar schema do script SQL com tabelas em DEV
3. ✅ Verificar que script SQL é idempotente (pode executar múltiplas vezes)
4. ✅ Validar nomes de tabelas e colunas no script SQL
5. ✅ Verificar tipos de dados e constraints no script SQL
6. ✅ Validar sintaxe PowerShell dos scripts PowerShell (se criados)
7. ✅ Validar funções e comandos nos scripts PowerShell (se criados)
8. ✅ Executar validação completa usando script de validação

**Entregas:**
- Relatório de validação do script SQL
- Relatório de validação dos scripts PowerShell (se criados)
- Confirmação de que todos os arquivos estão válidos

**Critérios de Sucesso:**
- Sintaxe SQL válida
- Schema idêntico ao DEV
- Script SQL idempotente
- Sintaxe PowerShell válida (se scripts criados)
- Todos os arquivos validados sem erros

---

### **FASE 4: Cópia para Produção e Verificação de Integridade**

**Objetivo:** Copiar arquivos para servidor de produção e verificar integridade usando hash SHA256.

**Tarefas:**
1. ✅ Calcular hash SHA256 do arquivo local ANTES de copiar
2. ✅ Copiar script SQL para servidor PROD via SCP (usar caminho completo do workspace)
3. ✅ Calcular hash SHA256 do arquivo no servidor APÓS cópia
4. ✅ Comparar hashes (ignorando diferenças de maiúsculas/minúsculas - case-insensitive)
5. ✅ Se hashes não coincidirem, tentar copiar novamente
6. ✅ Confirmar que arquivo está no servidor
7. ✅ Verificar permissões do arquivo no servidor
8. ✅ Documentar hash do arquivo copiado no log da operação

**Processo de Verificação de Hash (OBRIGATÓRIO):**
```powershell
# Calcular hash local (Windows PowerShell)
$hashLocal = (Get-FileHash -Path "arquivo.sql" -Algorithm SHA256).Hash.ToUpper()

# Calcular hash remoto (via SSH)
$hashRemote = (ssh root@servidor "sha256sum /tmp/arquivo.sql | cut -d' ' -f1").ToUpper()

# Comparar (case-insensitive - ambos convertidos para maiúsculas)
if ($hashLocal -eq $hashRemote) {
    Write-Host "✅ Hash coincide - arquivo copiado corretamente"
} else {
    Write-Host "❌ Hash não coincide - tentar copiar novamente"
    # Tentar copiar novamente
}
```

**Entregas:**
- Script SQL no servidor PROD: `/tmp/criar_tabelas_archive_statistics_prod.sql`
- Hash SHA256 do arquivo local (antes da cópia)
- Hash SHA256 do arquivo no servidor (após cópia)
- Confirmação de que hashes coincidem (case-insensitive)
- Log da operação com hash documentado

**Critérios de Sucesso:**
- Arquivo copiado com sucesso via SCP
- Hash local calculado ANTES da cópia
- Hash remoto calculado APÓS cópia
- Hashes coincidem (case-insensitive)
- Arquivo existe no servidor com permissões corretas
- Hash documentado no log da operação
- **NUNCA considerar deploy concluído sem verificação de hash bem-sucedida**

---

### **FASE 5: Execução dos SQLs no Servidor**

**Objetivo:** Executar script SQL para criar as tabelas em PROD.

**Tarefas:**
1. ✅ Executar script SQL no banco PROD via MySQL
2. ✅ Verificar se execução foi bem-sucedida (exit code 0)
3. ✅ Verificar se não houve erros durante execução
4. ✅ Verificar se tabelas foram criadas
5. ✅ Verificar schema das tabelas criadas
6. ✅ Documentar resultado da execução

**Entregas:**
- Tabelas criadas em PROD
- Schema das tabelas verificado
- Log de execução do script SQL
- Confirmação de que execução foi bem-sucedida

**Critérios de Sucesso:**
- Script executado sem erros (exit code 0)
- Tabelas criadas com sucesso
- Schema idêntico ao DEV
- Nenhum erro durante execução

---

### **FASE 6: Validação Pós-Criação**

**Objetivo:** Validar que as tabelas foram criadas corretamente em PROD.

**Tarefas:**
1. ✅ Verificar que tabelas existem em PROD
2. ✅ Comparar schema das tabelas PROD com DEV
3. ✅ Verificar índices e constraints
4. ✅ Verificar tipos de dados e ENUMs
5. ✅ Validar comentários das tabelas
6. ✅ Verificar que ENUM inclui 'TRACE' (se aplicável)

**Entregas:**
- Relatório de validação pós-criação
- Comparação de schemas DEV vs PROD
- Confirmação de que tabelas estão corretas

**Critérios de Sucesso:**
- Tabelas existem em PROD
- Schema idêntico ao DEV
- Todos os índices e constraints presentes
- ENUMs corretos (incluindo TRACE se aplicável)

---

### **FASE 7: Teste Funcional (Opcional)**

**Objetivo:** Testar funcionalidades básicas das tabelas criadas.

**Tarefas:**
1. ✅ Testar INSERT em `application_logs_archive` (se aplicável)
2. ✅ Testar INSERT em `log_statistics` (se aplicável)
3. ✅ Verificar que ENUMs funcionam corretamente (incluindo TRACE)
4. ✅ Verificar que índices funcionam corretamente
5. ✅ Verificar que constraints funcionam corretamente

**Entregas:**
- Relatório de testes funcionais
- Confirmação de que funcionalidades básicas funcionam

**Critérios de Sucesso:**
- INSERTs funcionam corretamente
- ENUMs validam valores corretamente
- Índices funcionam corretamente
- Constraints funcionam corretamente

---

### **FASE 8: Documentação e Finalização**

**Objetivo:** Documentar a criação das tabelas e atualizar documentação do projeto.

**Tarefas:**
1. ✅ Atualizar `TRACKING_ALTERACOES_BANCO_DADOS.md`
2. ✅ Criar relatório de execução do projeto
3. ✅ Documentar schema das tabelas criadas
4. ✅ Atualizar documentação de arquitetura (se aplicável)
5. ✅ Registrar hash dos arquivos criados e copiados

**Entregas:**
- Relatório de execução: `RELATORIO_CRIAR_TABELAS_ARCHIVE_STATISTICS_PROD_20251123.md`
- Documentação atualizada
- Tracking de alterações atualizado

**Critérios de Sucesso:**
- Documentação completa e atualizada
- Relatório de execução criado
- Tracking de alterações atualizado
- Hash dos arquivos documentado

---

## 📊 ANÁLISE DE RISCOS

### **Riscos Identificados**

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Script SQL com erro de sintaxe | Baixa | Alto | Validação completa antes de executar |
| Tabelas criadas com schema incorreto | Baixa | Alto | Comparação com schema DEV antes de executar |
| Falha na conexão com servidor PROD | Média | Médio | Verificar conectividade antes de executar |
| Impacto em funcionalidades existentes | Muito Baixa | Baixo | Tabelas são novas, não afetam código existente |
| Inconsistência entre DEV e PROD | Baixa | Médio | Comparação de schemas após criação |

### **Plano de Contingência**

- **Se script SQL falhar:** Parar imediatamente, analisar erro, corrigir script e tentar novamente
- **Se tabelas criadas incorretamente:** Dropar tabelas e recriar com script corrigido
- **Se validação falhar:** Corrigir schema e recriar tabelas

---

## 📋 CRITÉRIOS DE ACEITAÇÃO

### **Critérios Obrigatórios**

1. ✅ Tabelas `application_logs_archive` e `log_statistics` criadas em PROD
2. ✅ Schema das tabelas idêntico ao DEV
3. ✅ Script SQL executado sem erros
4. ✅ Validação pós-criação bem-sucedida
5. ✅ Documentação atualizada

### **Critérios Opcionais**

1. ⚠️ Teste funcional realizado (INSERTs, ENUMs, índices)
2. ⚠️ Backup do banco PROD criado antes da criação

---

## 📁 ARQUIVOS DO PROJETO

### **Arquivos a Criar (FASE 2)**

**Arquivos SQL:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabelas_archive_statistics_prod.sql`

**Arquivos PowerShell (opcionais, se necessário):**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/copiar_sql_criar_tabelas_prod.ps1` (se necessário)
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/validar_sql_criar_tabelas_prod.ps1` (se necessário)
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/executar_sql_criar_tabelas_prod.ps1` (se necessário)

**Arquivos de Documentação:**
- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/RELATORIO_CRIAR_TABELAS_ARCHIVE_STATISTICS_PROD_20251123.md` (FASE 8)

### **Arquivos a Atualizar**

- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/TRACKING_ALTERACOES_BANCO_DADOS.md` (FASE 8)

### **Arquivos de Referência**

- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/LOGGING_DATABASE_SCHEMA.sql`
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/copiar_sql_trace_enum_prod.ps1` (como referência para script de cópia)
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/validar_sql_trace_enum_prod.ps1` (como referência para script de validação)

---

## 🔧 ESPECIFICAÇÕES TÉCNICAS

### **Schema das Tabelas**

#### **1. `application_logs_archive`**

```sql
CREATE TABLE application_logs_archive (
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
```

#### **2. `log_statistics`**

```sql
CREATE TABLE log_statistics (
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

### **Comandos SQL**

**Criar tabelas:**
```sql
USE rpa_logs_prod;

-- Criar application_logs_archive
CREATE TABLE IF NOT EXISTS application_logs_archive (...);

-- Criar log_statistics
CREATE TABLE IF NOT EXISTS log_statistics (...);
```

**Verificar criação:**
```sql
-- Verificar que tabelas existem
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
  AND TABLE_NAME IN ('application_logs_archive', 'log_statistics');

-- Verificar schema das tabelas
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
  AND TABLE_NAME IN ('application_logs_archive', 'log_statistics')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
```

---

## 📋 CHECKLIST DE EXECUÇÃO

### **FASE 1: Preparação**

- [ ] Schema das tabelas em DEV verificado
- [ ] Confirmação de que tabelas não existem em PROD
- [ ] Conectividade com servidor PROD verificada
- [ ] Schema atual documentado

### **FASE 2: Criação de Arquivos**

- [ ] Script SQL criado (`criar_tabelas_archive_statistics_prod.sql`)
- [ ] Scripts PowerShell criados (se necessário)
- [ ] Todos os arquivos documentados com comentários
- [ ] Schema extraído de DEV e incluído no script SQL

### **FASE 3: Validação de Arquivos**

- [ ] Sintaxe SQL validada (parênteses, aspas, comandos)
- [ ] Schema comparado com tabelas em DEV
- [ ] Script SQL verificado como idempotente
- [ ] Sintaxe PowerShell validada (se scripts criados)
- [ ] Todos os arquivos validados sem erros

### **FASE 4: Cópia e Verificação de Integridade**

- [ ] Script SQL copiado para servidor PROD via SCP
- [ ] Hash SHA256 do arquivo local calculado
- [ ] Hash SHA256 do arquivo no servidor calculado
- [ ] Hashes comparados e coincidem (case-insensitive)
- [ ] Arquivo verificado no servidor com permissões corretas

### **FASE 5: Execução dos SQLs**

- [ ] Script SQL executado no banco PROD
- [ ] Execução sem erros confirmada (exit code 0)
- [ ] Tabelas criadas verificadas
- [ ] Schema das tabelas criadas verificado

### **FASE 6: Validação Pós-Criação**

- [ ] Tabelas existem em PROD verificadas
- [ ] Schema das tabelas PROD comparado com DEV
- [ ] Índices e constraints verificados
- [ ] Tipos de dados e ENUMs verificados

### **FASE 7: Teste Funcional (Opcional)**

- [ ] INSERTs testados em ambas as tabelas
- [ ] ENUMs validam valores corretamente
- [ ] Índices funcionam corretamente

### **FASE 8: Documentação**

- [ ] Tracking de alterações atualizado
- [ ] Relatório de execução criado
- [ ] Hash dos arquivos documentado
- [ ] Documentação completa e atualizada

---

## 📝 NOTAS IMPORTANTES

1. **Idempotência:** Script SQL usa `CREATE TABLE IF NOT EXISTS` para ser idempotente
2. **Segurança:** Tabelas são novas e não afetam código existente
3. **Consistência:** Schema deve ser idêntico ao DEV
4. **Validação:** Sempre validar schema após criação
5. **Documentação:** Atualizar tracking de alterações após criação

---

## 🎯 CONCLUSÃO

Este projeto visa criar as tabelas `application_logs_archive` e `log_statistics` no banco de dados de produção, garantindo consistência entre ambientes DEV e PROD, e preparando o sistema para funcionalidades futuras de arquivamento e estatísticas de logs.

**Status:** ✅ **CONCLUÍDO** - Tabelas criadas com sucesso em PROD em 23/11/2025

---

**Execução Realizada:**
1. ✅ **FASE 1:** Preparação e verificação pré-criação - CONCLUÍDA
2. ✅ **FASE 2:** Criar todos os arquivos (SQL e PowerShell) - CONCLUÍDA
3. ✅ **FASE 3:** Validar todos os arquivos criados - CONCLUÍDA
4. ✅ **FASE 4:** Copiar para produção e verificar integridade (hash) - CONCLUÍDA
5. ✅ **FASE 5:** Executar SQLs no servidor - CONCLUÍDA
6. ✅ **FASE 6:** Validar criação pós-execução - CONCLUÍDA
7. ⚠️ **FASE 7:** Teste funcional (opcional) - NÃO EXECUTADO
8. ✅ **FASE 8:** Documentar e finalizar - CONCLUÍDA

**Relatório de Execução:**
- `RELATORIO_CRIAR_TABELAS_ARCHIVE_STATISTICS_PROD_20251123.md` - Relatório completo da execução

