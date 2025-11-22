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

**Última Atualização:** 21/11/2025 - Alteração #001 registrada

---

## 📚 DOCUMENTAÇÃO RELACIONADA

- **Histórico de Replicações:** `HISTORICO_REPLICACAO_PRODUCAO.md` - Registro de todas as replicações para PROD
- **Processo de Tracking:** `PROCESSO_TRACKING_ALTERACOES_BANCO_DADOS.md` - Processo obrigatório para alterações

