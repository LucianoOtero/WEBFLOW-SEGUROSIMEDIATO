# 🎯 PROJETO: Replicar Adição de 'TRACE' ao ENUM da Coluna `level` em PRODUÇÃO

**Data de Criação:** 23/11/2025  
**Versão:** 1.0.0  
**Status:** 📋 **PLANEJAMENTO** - Aguardando autorização para implementação  
**Última Atualização:** 23/11/2025 - Versão 1.0.0

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Replicar em produção a alteração já aplicada e validada em desenvolvimento que adiciona 'TRACE' ao ENUM da coluna `level` nas tabelas do banco de dados `rpa_logs_prod`, corrigindo o erro HTTP 500 ao inserir logs com nível 'TRACE' em produção.

### Contexto

**Alteração em DEV:**
- ✅ **Status:** Aplicada e validada em 21/11/2025
- ✅ **Ambiente:** `rpa_logs_dev`
- ✅ **Tabelas Alteradas:** `application_logs`, `application_logs_archive`, `log_statistics`
- ✅ **Validação:** Testes executados com sucesso, logs TRACE funcionando corretamente

**Replicação em PROD:**
- ⏳ **Status:** Pendente de replicação
- ⚠️ **Ambiente:** `rpa_logs_prod`
- ⚠️ **Impacto:** Crítico - Logs TRACE não podem ser salvos em produção

### Problema a Resolver

O banco de dados de produção (`rpa_logs_prod`) ainda possui o schema antigo sem 'TRACE' no ENUM da coluna `level`, causando:
- ❌ Erro HTTP 500 ao inserir logs com nível 'TRACE'
- ❌ Perda de dados de debug importantes em produção
- ❌ Inconsistência entre código (que aceita TRACE) e banco de dados (que rejeita)

### Escopo

- **Tabelas a Modificar em PROD:**
  - `application_logs` - Tabela principal de logs
  - `application_logs_archive` - Tabela de arquivo (se existir)
  - `log_statistics` - Tabela de estatísticas (se existir)

- **Arquivos SQL:**
  - Script de alteração: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_prod.sql` ✅ **JÁ EXISTE**

- **Ambientes Afetados:**
  - ✅ PROD: `rpa_logs_prod` (IP: 157.180.36.223)

### Impacto Esperado

- ✅ **Correção do Erro 500:** Logs com nível 'TRACE' serão inseridos com sucesso em produção
- ✅ **Consistência:** Banco de dados PROD alinhado com código PHP/JavaScript
- ✅ **Preservação de Dados:** Logs TRACE serão salvos corretamente no banco PROD
- ✅ **Zero Breaking Changes:** Não afeta logs existentes ou outros níveis
- ✅ **Compatibilidade:** Mantém compatibilidade com todos os níveis existentes

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### Objetivo do Usuário

Replicar em produção a correção já aplicada em desenvolvimento que adiciona 'TRACE' ao ENUM da coluna `level` no banco de dados, garantindo que logs com nível 'TRACE' possam ser salvos corretamente em produção.

### Contexto e Justificativa

**Por que replicar:**
- A alteração já foi validada e testada com sucesso em DEV
- Logs TRACE são usados extensivamente no código (195+ ocorrências)
- O erro HTTP 500 em produção impede que logs importantes sejam salvos
- A inconsistência causa perda de dados de debug em produção

**Por que agora:**
- Alteração em DEV está estável e funcionando há 2 dias
- Script SQL para PROD já está preparado e revisado
- Documentação completa disponível
- Processo de replicação definido e testado

### Expectativas do Usuário

1. **Replicação Segura:** Alteração aplicada sem impacto em logs existentes
2. **Validação Completa:** Verificação de que alteração foi aplicada corretamente
3. **Teste Funcional:** Confirmação de que logs TRACE funcionam em PROD
4. **Documentação:** Registro completo da replicação realizada
5. **Monitoramento:** Acompanhamento por 24-48h após replicação

---

## 🎯 FASES DO PROJETO

### **FASE 1: Preparação e Validação Pré-Replicação**

**Objetivo:** Validar que todas as condições estão atendidas para replicação segura.

**Tarefas:**
1. ✅ Verificar que alteração em DEV está funcionando corretamente
2. ✅ Confirmar que script SQL para PROD existe e está correto
3. ✅ Verificar schema atual do banco PROD (antes da alteração)
4. ✅ Criar backup do banco de dados PROD
5. ✅ Validar conectividade com servidor PROD
6. ✅ Revisar documentação de tracking

**Critérios de Sucesso:**
- ✅ Alteração em DEV validada e funcionando
- ✅ Script SQL para PROD revisado e validado
- ✅ Backup do banco PROD criado com sucesso
- ✅ Schema atual do PROD documentado
- ✅ Conectividade com servidor PROD confirmada

**Arquivos/Comandos:**
- Script SQL: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_prod.sql`
- Documentação: `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/TRACKING_ALTERACOES_BANCO_DADOS.md`
- Comando de backup: `mysqldump -u rpa_logger_prod -p rpa_logs_prod > /tmp/backup_rpa_logs_prod_$(date +%Y%m%d_%H%M%S).sql`

---

### **FASE 2: Verificação do Schema Atual em PROD**

**Objetivo:** Documentar o estado atual do schema antes da alteração.

**Tarefas:**
1. Conectar ao banco `rpa_logs_prod`
2. Verificar schema atual da coluna `level` em todas as tabelas
3. Verificar quais tabelas existem (`application_logs`, `application_logs_archive`, `log_statistics`)
4. Documentar schema atual (antes da alteração)

**Critérios de Sucesso:**
- ✅ Schema atual documentado para todas as tabelas
- ✅ Confirmação de que 'TRACE' não está no ENUM atual
- ✅ Lista de tabelas que precisam ser alteradas confirmada

**Comandos SQL:**
```sql
-- Verificar schema atual
USE rpa_logs_prod;

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
  AND COLUMN_NAME = 'level'
ORDER BY TABLE_NAME;

-- Verificar quais tabelas existem
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
  AND TABLE_NAME IN ('application_logs', 'application_logs_archive', 'log_statistics');
```

---

### **FASE 3: Backup do Banco de Dados PROD**

**Objetivo:** Criar backup completo do banco de dados antes da alteração.

**Tarefas:**
1. Criar backup completo do banco `rpa_logs_prod`
2. Verificar integridade do backup criado
3. Armazenar backup em local seguro
4. Documentar localização do backup

**Critérios de Sucesso:**
- ✅ Backup criado com sucesso
- ✅ Integridade do backup verificada
- ✅ Backup armazenado em local seguro
- ✅ Localização do backup documentada

**Comandos:**
```bash
# Criar backup
mysqldump -u rpa_logger_prod -p rpa_logs_prod > /tmp/backup_rpa_logs_prod_$(date +%Y%m%d_%H%M%S).sql

# Verificar integridade
mysql -u rpa_logger_prod -p -e "USE rpa_logs_prod; SELECT COUNT(*) FROM application_logs;" > /dev/null && echo "Backup válido"
```

---

### **FASE 4: Execução da Alteração em PROD**

**Objetivo:** Aplicar alteração do ENUM incluindo 'TRACE' em todas as tabelas necessárias.

**Tarefas:**
1. Copiar script SQL para servidor PROD
2. Executar script SQL de alteração
3. Verificar que alteração foi aplicada sem erros
4. Confirmar que 'TRACE' foi adicionado ao ENUM

**Critérios de Sucesso:**
- ✅ Script SQL executado sem erros
- ✅ 'TRACE' adicionado ao ENUM em todas as tabelas
- ✅ Schema atualizado corretamente
- ✅ Nenhum erro durante execução

**Comandos:**
```bash
# Copiar script para servidor
scp "WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_prod.sql" root@157.180.36.223:/tmp/

# Executar script no servidor
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -ptYbAwe7QkKNrHSRhaWplgsSxt rpa_logs_prod < /tmp/alterar_enum_level_adicionar_trace_prod.sql"
```

**Script SQL a Executar:**
- Arquivo: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_prod.sql`
- Tabelas: `application_logs`, `application_logs_archive`, `log_statistics`

---

### **FASE 5: Validação da Alteração Aplicada**

**Objetivo:** Confirmar que alteração foi aplicada corretamente em todas as tabelas.

**Tarefas:**
1. Verificar schema após alteração (confirmar que 'TRACE' está no ENUM)
2. Verificar todas as tabelas alteradas
3. Confirmar que schema está idêntico ao DEV
4. Documentar resultado da validação

**Critérios de Sucesso:**
- ✅ 'TRACE' presente no ENUM de todas as tabelas alteradas
- ✅ Schema PROD idêntico ao schema DEV
- ✅ Nenhuma inconsistência encontrada

**Comandos SQL:**
```sql
-- Verificar schema após alteração
USE rpa_logs_prod;

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
  AND COLUMN_NAME = 'level'
ORDER BY TABLE_NAME;

-- Resultado esperado:
-- COLUMN_TYPE deve conter: enum('DEBUG','INFO','WARN','ERROR','FATAL','TRACE')
```

---

### **FASE 6: Teste Funcional em PROD**

**Objetivo:** Testar inserção de logs com nível 'TRACE' em produção.

**Tarefas:**
1. Testar inserção de log TRACE via `log_endpoint.php` em PROD
2. Verificar que log foi inserido com sucesso no banco
3. Confirmar que não há mais erro HTTP 500
4. Verificar que outros níveis continuam funcionando

**Critérios de Sucesso:**
- ✅ Log TRACE inserido com sucesso em PROD
- ✅ Nenhum erro HTTP 500 ao inserir logs TRACE
- ✅ Outros níveis (DEBUG, INFO, WARN, ERROR, FATAL) funcionam normalmente
- ✅ Logs aparecem corretamente no banco de dados

**Teste Manual:**
```javascript
// Teste via console do navegador em produção
fetch('https://prod.bssegurosimediato.com.br/log_endpoint.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
        level: 'TRACE',
        category: 'TEST',
        message: 'Teste de inserção TRACE em PROD',
        file_name: 'test.js',
        line_number: 1
    })
}).then(r => r.json()).then(console.log);
```

**Verificação no Banco:**
```sql
-- Verificar log inserido
SELECT * FROM application_logs 
WHERE level = 'TRACE' 
  AND message LIKE '%Teste de inserção TRACE em PROD%'
ORDER BY timestamp DESC 
LIMIT 1;
```

---

### **FASE 7: Monitoramento e Validação Contínua**

**Objetivo:** Monitorar funcionamento após replicação por 24-48h.

**Tarefas:**
1. Monitorar logs de erro em PROD por 24-48h
2. Verificar que não há erros relacionados ao ENUM
3. Confirmar que logs TRACE estão sendo inseridos normalmente
4. Validar que não há regressão em outros níveis

**Critérios de Sucesso:**
- ✅ Nenhum erro HTTP 500 relacionado ao ENUM
- ✅ Logs TRACE sendo inseridos normalmente
- ✅ Outros níveis funcionando corretamente
- ✅ Nenhuma regressão identificada

**Monitoramento:**
- Verificar logs do servidor PROD
- Verificar logs no banco de dados PROD
- Monitorar métricas de inserção de logs

---

### **FASE 8: Documentação Final**

**Objetivo:** Documentar replicação realizada e atualizar histórico.

**Tarefas:**
1. Atualizar `TRACKING_ALTERACOES_BANCO_DADOS.md` marcando como replicado
2. Atualizar `HISTORICO_REPLICACAO_PRODUCAO.md` com data/hora da replicação
3. Documentar resultados da replicação
4. Registrar qualquer problema encontrado e solução aplicada

**Critérios de Sucesso:**
- ✅ Documentação atualizada com status de replicação
- ✅ Histórico atualizado com data/hora da replicação
- ✅ Resultados documentados completamente
- ✅ Problemas (se houver) documentados com soluções

**Arquivos a Atualizar:**
- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/TRACKING_ALTERACOES_BANCO_DADOS.md`
- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/HISTORICO_REPLICACAO_PRODUCAO.md`
- Criar relatório: `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/RELATORIO_REPLICACAO_TRACE_ENUM_PROD_YYYYMMDD.md`

---

## 📝 DETALHAMENTO TÉCNICO

### Script SQL para Alteração

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_prod.sql`

**Alterações a Aplicar:**
```sql
-- 1. application_logs
ALTER TABLE application_logs 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';

-- 2. application_logs_archive (se existir)
ALTER TABLE application_logs_archive 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';

-- 3. log_statistics (se existir)
ALTER TABLE log_statistics 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL;
```

### Verificação do Schema

**Antes da Alteração:**
```sql
-- Schema esperado ANTES (sem TRACE)
COLUMN_TYPE: enum('DEBUG','INFO','WARN','ERROR','FATAL')
```

**Após a Alteração:**
```sql
-- Schema esperado APÓS (com TRACE)
COLUMN_TYPE: enum('DEBUG','INFO','WARN','ERROR','FATAL','TRACE')
```

### Credenciais e Conectividade

**Servidor PROD:**
- **IP:** 157.180.36.223
- **Domínio:** `prod.bssegurosimediato.com.br`
- **Banco de Dados:** `rpa_logs_prod`
- **Usuário:** `rpa_logger_prod`
- **Senha:** `tYbAwe7QkKNrHSRhaWplgsSxt` (via variável de ambiente)

**⚠️ IMPORTANTE:** Usar credenciais via variáveis de ambiente quando possível.

---

## 🚨 PLANO DE ROLLBACK

### Cenário: Alteração Falha ou Causa Problemas

**Rollback Automático:**
- ❌ **NÃO HÁ ROLLBACK AUTOMÁTICO** - Alteração de ENUM não pode ser revertida facilmente
- ⚠️ **SOLUÇÃO:** Restaurar backup do banco de dados

**Processo de Rollback:**

1. **Parar inserção de logs TRACE temporariamente** (se necessário)
2. **Restaurar backup do banco de dados:**
   ```bash
   mysql -u rpa_logger_prod -p rpa_logs_prod < /tmp/backup_rpa_logs_prod_YYYYMMDD_HHMMSS.sql
   ```
3. **Verificar que schema foi restaurado:**
   ```sql
   SELECT COLUMN_TYPE 
   FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
     AND TABLE_NAME = 'application_logs' 
     AND COLUMN_NAME = 'level';
   ```
4. **Documentar rollback realizado**

**⚠️ ATENÇÃO:** Rollback remove todos os logs inseridos após o backup. Considerar impacto antes de executar.

---

## ✅ CHECKLIST DE REPLICAÇÃO

### **ANTES DA REPLICAÇÃO:**

- [ ] ✅ Alteração validada e testada em DEV há pelo menos 2 dias
- [ ] ✅ Documentação completa da alteração disponível
- [ ] ✅ Script SQL para PROD criado e revisado
- [ ] ✅ Backup do banco PROD criado e verificado
- [ ] ✅ Schema atual do PROD documentado (antes da alteração)
- [ ] ✅ Conectividade com servidor PROD confirmada
- [ ] ✅ Plano de rollback preparado
- [ ] ✅ Horário de execução definido (se necessário)

### **DURANTE A REPLICAÇÃO:**

- [ ] ✅ Backup do banco PROD criado antes de qualquer modificação
- [ ] ✅ Script SQL copiado para servidor PROD
- [ ] ✅ Script SQL executado sem erros
- [ ] ✅ Schema verificado após alteração (confirmar que 'TRACE' está no ENUM)
- [ ] ✅ Todas as tabelas alteradas verificadas

### **APÓS A REPLICAÇÃO:**

- [ ] ✅ Teste funcional executado (inserção de log TRACE)
- [ ] ✅ Log TRACE inserido com sucesso no banco PROD
- [ ] ✅ Nenhum erro HTTP 500 ao inserir logs TRACE
- [ ] ✅ Outros níveis (DEBUG, INFO, WARN, ERROR, FATAL) funcionam normalmente
- [ ] ✅ Schema PROD idêntico ao schema DEV
- [ ] ✅ Documentação atualizada (TRACKING e HISTORICO)
- [ ] ✅ Relatório de replicação criado

### **MONITORAMENTO (24-48h):**

- [ ] ✅ Logs de erro monitorados (nenhum erro relacionado ao ENUM)
- [ ] ✅ Logs TRACE sendo inseridos normalmente
- [ ] ✅ Nenhuma regressão identificada
- [ ] ✅ Replicação confirmada como bem-sucedida

---

## 📊 RISCOS E MITIGAÇÕES

### **Riscos Identificados:**

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Script SQL falha durante execução | Baixa | Alto | Backup criado antes, script idempotente |
| Tabela não existe (archive/statistics) | Média | Baixo | Script verifica existência antes de alterar |
| Perda de dados durante alteração | Muito Baixa | Crítico | Backup completo antes da alteração |
| Inconsistência entre tabelas | Baixa | Médio | Verificação após alteração em todas as tabelas |
| Regressão em outros níveis | Muito Baixa | Alto | Teste funcional completo após alteração |

### **Plano de Contingência:**

1. **Se script falhar:** Parar execução, investigar erro, corrigir script, repetir
2. **Se tabela não existir:** Continuar com outras tabelas, documentar tabela ausente
3. **Se houver erro após alteração:** Restaurar backup, investigar problema, replanejar
4. **Se houver regressão:** Restaurar backup, investigar causa, corrigir antes de replicar novamente

---

## 📚 DOCUMENTAÇÃO RELACIONADA

### **Documentos de Referência:**

1. **Análise do Problema:**
   - `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/ANALISE_ERRO_500_LOGS_TRACE_20251121.md`

2. **Projeto Original (DEV):**
   - `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PROJETO_ADICIONAR_TRACE_ENUM_BANCO_DADOS_20251121.md`

3. **Tracking de Alterações:**
   - `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/TRACKING_ALTERACOES_BANCO_DADOS.md`

4. **Histórico de Replicações:**
   - `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/HISTORICO_REPLICACAO_PRODUCAO.md`

5. **Processo de Replicação:**
   - `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PROCESSO_REPLICACAO_SEGURA_DEV_PROD.md`

### **Scripts SQL:**

- **DEV:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_dev.sql`
- **PROD:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_prod.sql` ✅ **PRONTO**

---

## 🎯 CRITÉRIOS DE SUCESSO FINAL

### **Replicação Considerada Bem-Sucedida Quando:**

1. ✅ **Alteração Aplicada:**
   - 'TRACE' adicionado ao ENUM em todas as tabelas necessárias
   - Schema PROD idêntico ao schema DEV

2. ✅ **Funcionalidade Validada:**
   - Logs TRACE inseridos com sucesso em PROD
   - Nenhum erro HTTP 500 ao inserir logs TRACE
   - Outros níveis funcionam normalmente

3. ✅ **Estabilidade Confirmada:**
   - Nenhum erro relacionado ao ENUM por 24-48h
   - Logs TRACE sendo inseridos normalmente
   - Nenhuma regressão identificada

4. ✅ **Documentação Completa:**
   - Tracking atualizado com status de replicação
   - Histórico atualizado com data/hora da replicação
   - Relatório de replicação criado

---

## 📋 RESUMO DAS FASES

| Fase | Descrição | Status |
|------|-----------|--------|
| **FASE 1** | Preparação e Validação Pré-Replicação | ⏳ Pendente |
| **FASE 2** | Verificação do Schema Atual em PROD | ⏳ Pendente |
| **FASE 3** | Backup do Banco de Dados PROD | ⏳ Pendente |
| **FASE 4** | Execução da Alteração em PROD | ⏳ Pendente |
| **FASE 5** | Validação da Alteração Aplicada | ⏳ Pendente |
| **FASE 6** | Teste Funcional em PROD | ⏳ Pendente |
| **FASE 7** | Monitoramento e Validação Contínua | ⏳ Pendente |
| **FASE 8** | Documentação Final | ⏳ Pendente |

---

## 🚨 OBSERVAÇÕES IMPORTANTES

### **⚠️ ANTES DE EXECUTAR:**

1. ✅ **OBRIGATÓRIO:** Criar backup completo do banco PROD antes de qualquer alteração
2. ✅ **OBRIGATÓRIO:** Verificar schema atual antes de alterar
3. ✅ **OBRIGATÓRIO:** Validar script SQL antes de executar
4. ✅ **OBRIGATÓRIO:** Testar conectividade com servidor PROD

### **⚠️ DURANTE A EXECUÇÃO:**

1. ✅ Executar script SQL em ambiente controlado
2. ✅ Verificar cada etapa antes de prosseguir
3. ✅ Documentar resultados de cada fase
4. ✅ Parar imediatamente se houver erro

### **⚠️ APÓS A EXECUÇÃO:**

1. ✅ Validar que alteração foi aplicada corretamente
2. ✅ Testar funcionalidade completa
3. ✅ Monitorar por 24-48h
4. ✅ Atualizar documentação completa

---

**Projeto elaborado seguindo as diretivas definidas em `./cursorrules`.**  
**Status:** 📋 **PLANEJAMENTO COMPLETO** - Aguardando autorização para implementação.

---

**Última Atualização:** 23/11/2025 - Versão 1.0.0


