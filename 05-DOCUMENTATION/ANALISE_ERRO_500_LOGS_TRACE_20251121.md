# Análise: Erro HTTP 500 ao Enviar Logs com Nível 'TRACE'

**Data:** 2025-11-21  
**Tipo:** Análise de Problema  
**Status:** 🔴 Problema Identificado

---

## 📋 Resumo Executivo

Logs com nível 'TRACE' estão retornando erro HTTP 500 (`Failed to insert log`, `Database insertion failed`) ao tentar inserir no banco de dados, enquanto logs com outros níveis (INFO, ERROR, etc.) funcionam normalmente.

---

## 🔍 Análise do Problema

### Sintomas Observados

1. **Erros HTTP 500** ao tentar enviar logs com `level: 'TRACE'`
2. **Mensagem de erro:** `Failed to insert log`, `Database insertion failed`
3. **Padrão consistente:** Apenas logs TRACE falham; outros níveis funcionam
4. **Request IDs que falharam (exemplos do log):**
   - `req_1763766913117_cbw9ylwcu` - TRACE
   - `req_1763766913118_2ayo4ypv4` - TRACE
   - `req_1763766913118_5hb3vy5cv` - TRACE
   - `req_1763766913118_uhbjkjzjd` - TRACE
   - `req_1763766913119_hkjmpm8u6` - TRACE
   - `req_1763766913119_1nbd8nwr5` - TRACE

### Causa Raiz Identificada

**PROBLEMA:** A coluna `level` na tabela `application_logs` está definida como um ENUM que **não inclui 'TRACE'**.

**Schema Atual do Banco de Dados:**

```sql
level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL') NOT NULL DEFAULT 'INFO',
```

**Localização:** 
- Arquivo de schema: `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/LOGGING_DATABASE_SCHEMA.sql` (linha 31)
- Arquivo de criação PROD: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabela_application_logs_prod.sql` (linha 22)

### Por Que Isso Causa Erro 500?

1. O código PHP valida 'TRACE' como nível válido em `log_endpoint.php` (linha 267)
2. O código PHP valida 'TRACE' em `LogConfig::shouldLog()` após correção anterior
3. O código PHP tenta inserir o log no banco de dados com `level = 'TRACE'`
4. **O MySQL rejeita a inserção** porque 'TRACE' não é um valor válido no ENUM
5. O PDO lança uma exceção `PDOException`
6. O código PHP captura a exceção e retorna HTTP 500

### Fluxo do Erro

```
JavaScript (Frontend)
  ↓ Envia log com level: 'TRACE'
log_endpoint.php
  ↓ Valida nível (TRACE está em validLevels) ✅
LogConfig::shouldLog()
  ↓ Valida nível (TRACE está em $levels) ✅
ProfessionalLogger->log()
  ↓ Prepara INSERT INTO application_logs
  ↓ Tenta inserir com level = 'TRACE'
MySQL Database
  ↓ Rejeita: 'TRACE' não está no ENUM ❌
  ↓ Lança PDOException
ProfessionalLogger->insertLog()
  ↓ Captura PDOException
  ↓ Retorna false
log_endpoint.php
  ↓ Detecta que logId === false
  ↓ Retorna HTTP 500 com mensagem "Database insertion failed"
```

---

## 📊 Evidências

### 1. Schema do Banco de Dados

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/LOGGING_DATABASE_SCHEMA.sql`

```sql
-- Linha 31
level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL') NOT NULL DEFAULT 'INFO',
```

**Observação:** 'TRACE' não está presente no ENUM.

### 2. Validação no Código PHP

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`

```php
// Linha 267
$validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE'];
```

**Observação:** 'TRACE' está presente na validação do código PHP.

### 3. Validação em LogConfig

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

```php
// Linha 132 (após correção anterior)
$levels = ['none' => 0, 'error' => 1, 'warn' => 2, 'info' => 3, 'debug' => 4, 'trace' => 5, 'all' => 6];
```

**Observação:** 'TRACE' está presente na validação do LogConfig após correção anterior.

### 4. Inserção no Banco de Dados

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

```php
// Linha 673
':level' => $logData['level'],  // Se level = 'TRACE', MySQL rejeita
```

**Observação:** O código tenta inserir 'TRACE', mas o MySQL rejeita porque não está no ENUM.

---

## 🎯 Impacto

### Arquivos Afetados

1. **Banco de Dados:**
   - Tabela `application_logs` no banco `rpa_logs_dev`
   - Tabela `application_logs` no banco `rpa_logs_prod` (se existir)
   - Tabela `application_logs_archive` (se existir)
   - Tabela `log_statistics` (se existir)

2. **Código PHP:**
   - ✅ `log_endpoint.php` - Já valida 'TRACE' corretamente
   - ✅ `ProfessionalLogger.php` - Já valida 'TRACE' corretamente (após correção anterior)

3. **Código JavaScript:**
   - ✅ `FooterCodeSiteDefinitivoCompleto.js` - Já valida 'TRACE' corretamente (após correção anterior)

### Funcionalidades Afetadas

- ❌ **Logs com nível 'TRACE' não podem ser salvos no banco de dados**
- ✅ Logs com outros níveis (DEBUG, INFO, WARN, ERROR, FATAL) funcionam normalmente
- ⚠️ Logs TRACE podem estar sendo salvos em arquivo (fallback), mas não no banco

---

## 🔧 Solução Necessária

### Alteração no Banco de Dados

**AÇÃO REQUERIDA:** Alterar a definição da coluna `level` na tabela `application_logs` para incluir 'TRACE' no ENUM.

**SQL Necessário:**

```sql
ALTER TABLE application_logs 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';
```

**Tabelas que Precisam ser Alteradas:**

1. `application_logs` (tabela principal)
2. `application_logs_archive` (se existir)
3. `log_statistics` (se existir)

**Ambientes Afetados:**

- ✅ DEV: `rpa_logs_dev`
- ⚠️ PROD: `rpa_logs_prod` (se existir)

---

## 📝 Observações Adicionais

### Correções Já Aplicadas (Anteriores)

1. ✅ **JavaScript:** 'TRACE' adicionado à validação em `FooterCodeSiteDefinitivoCompleto.js` (linha 414)
2. ✅ **PHP log_endpoint.php:** 'TRACE' adicionado à validação (linha 267)
3. ✅ **PHP LogConfig:** 'TRACE' adicionado ao array `$levels` em todos os métodos (linhas 132, 160, 177, 194)

### O Que Falta

❌ **Banco de Dados:** A coluna `level` ainda não inclui 'TRACE' no ENUM

---

## 🚨 Conclusão

O problema é uma **inconsistência entre o código PHP/JavaScript e o schema do banco de dados**:

- ✅ **Código:** Valida e aceita 'TRACE' como nível válido
- ❌ **Banco de Dados:** Rejeita 'TRACE' porque não está no ENUM

**Solução:** Alterar o schema do banco de dados para incluir 'TRACE' no ENUM da coluna `level`.

---

## 📋 Próximos Passos Recomendados

1. **Verificar schema atual** no banco de dados DEV
2. **Criar script SQL** para alterar o ENUM incluindo 'TRACE'
3. **Aplicar alteração** no banco de dados DEV
4. **Testar** inserção de logs com nível 'TRACE'
5. **Aplicar alteração** no banco de dados PROD (se aplicável)
6. **Atualizar documentação** do schema para incluir 'TRACE'

---

**Análise realizada seguindo as diretivas do projeto - apenas investigação, sem modificação de código.**

