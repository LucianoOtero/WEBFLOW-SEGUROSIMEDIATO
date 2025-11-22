# 📋 PROJETO: Unificar Função de Log - Uma Única Função Centralizada

**Data de Criação:** 17/11/2025  
**Data de Refatoração:** 17/11/2025 (baseado em auditoria completa)  
**Status:** 📝 **DOCUMENTO REFATORADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 2.0.0

---

## 🎯 OBJETIVO

Criar **UMA ÚNICA função de log centralizada** que substitua todas as funções de log existentes (`logClassified()`, `sendLogToProfessionalSystem()`, `logUnified()`, `logDebug()`), eliminando confusão e problemas de manutenção futura.

**Especificação Original:**
- ✅ Uma função única que chama `console.log()` E `insertLog()` (endpoint)
- ✅ Substituir TODAS as chamadas de log por essa função única
- ✅ Centralização completa - sem múltiplas funções

**Problema Atual:**
- ❌ Múltiplas funções de log: `logClassified()`, `sendLogToProfessionalSystem()`, `logUnified()`, `logDebug()`
- ❌ Confusão sobre qual função usar
- ❌ Manutenção difícil
- ❌ Inconsistências (algumas enviam para banco, outras não)

**Solução:**
- ✅ Criar função única `novo_log()` (ou `log()`)
- ✅ Substituir TODAS as chamadas existentes
- ✅ Função faz: `console.log()` + `sendLogToProfessionalSystem()` (respeitando parametrização)
- ✅ Única função de log no sistema

---

## 📊 ANÁLISE DO ESTADO ATUAL

**Baseado em:** `ANALISE_EXATA_CHAMADAS_LOG.md` (análise criteriosa linha por linha)

### **Funções de Log Existentes:**

1. **`logClassified()` (linha 295):**
   - ✅ Parametrização via `DEBUG_CONFIG`
   - ✅ Exibe no console
   - ❌ NÃO envia para banco
   - 📊 **16 chamadas** (exato, não estimado)

2. **`sendLogToProfessionalSystem()` (linha 587):**
   - ✅ Parametrização via `window.LOG_CONFIG`
   - ✅ Envia para banco
   - ❌ NÃO exibe no console (apenas logs internos)
   - 📊 **4 chamadas diretas** (exato, não estimado)

3. **`logUnified()` (linha ~812):**
   - ⚠️ DEPRECATED
   - ❌ Não deve ser usada
   - 📊 **4 chamadas** (exato, todas deprecated)

4. **`logDebug()` (linhas 921 e 2027):**
   - ⚠️ **DUAS DEFINIÇÕES COM ASSINATURAS DIFERENTES:**
     - **Linha 921:** `window.logDebug = (cat, msg, data) => { ... }` - **Assinatura: (category, message, data)**
     - **Linha 2027:** `function logDebug(level, message, data = null) { ... }` - **Assinatura: (level, message, data)**
   - ✅ As 43 chamadas usam `window.logDebug(category, message, data)` (compatível com linha 921)
   - 📊 **43 chamadas** (exato: 42 via `window.` + 1 local)

### **Total de Chamadas:**

**Total Exato: 67 chamadas** (baseado em análise criteriosa)

| Função | Chamadas | Observações |
|--------|----------|-------------|
| `logClassified()` | **16** | Chamadas diretas e via `window.` |
| `sendLogToProfessionalSystem()` | **4** | Chamadas diretas (não inclui chamadas dentro de `logDebug()`) |
| `logUnified()` | **4** | Todas deprecated, dentro de funções deprecated |
| `logDebug()` | **43** | 42 via `window.` + 1 local |
| **TOTAL** | **67** | **67 chamadas para substituir** |

**Nota Importante:**
- As 4 chamadas de `logUnified()` estão dentro de funções deprecated que já chamam `logClassified()`, então são redundantes
- A função `logDebug()` internamente já chama `sendLogToProfessionalSystem()` e `logClassified()`, então substituir as 43 chamadas de `logDebug()` já resolve a questão

---

## 🎯 SOLUÇÃO PROPOSTA

### **Criar Função Única: `novo_log()`**

**Assinatura:**
```javascript
function novo_log(level, category, message, data, context = 'OPERATION', verbosity = 'SIMPLE')
```

**Funcionalidades:**
1. ✅ Verificar parametrização (`window.shouldLog()`, `window.shouldLogToDatabase()`, `window.shouldLogToConsole()`)
2. ✅ Verificar `DEBUG_CONFIG` (compatibilidade com código existente)
3. ✅ Exibir no console (`console.log/error/warn`) se `shouldLogToConsole()` retornar true
4. ✅ Enviar para banco (`sendLogToProfessionalSystem()`) se `shouldLogToDatabase()` retornar true
5. ✅ Tratamento de erros silencioso (não quebrar aplicação)
6. ✅ Chamada assíncrona para banco (não bloquear execução)

**Fluxo:**
```
novo_log(level, category, message, data, context, verbosity)
  ↓
1. Verificar window.shouldLog(level, category)
   Se false → retornar (não fazer nada)
  ↓
2. Verificar DEBUG_CONFIG (compatibilidade)
   Se desabilitado → retornar (exceto CRITICAL)
  ↓
3. Verificar window.shouldLogToConsole(level)
   Se true → console.log/error/warn(formattedMessage, data)
  ↓
4. Verificar window.shouldLogToDatabase(level)
   Se true → sendLogToProfessionalSystem(level, category, message, data)
   (assíncrono, com try-catch silencioso)
  ↓
5. Retornar
```

---

## 📋 FASES DO PROJETO

### **FASE 0: Correções Críticas e Prevenção de Loops**

#### **FASE 0.1: Verificar Prevenção de Loops**
- ✅ **JÁ FEITO:** `sendLogToProfessionalSystem()` usa `console.log` direto, não `logClassified()`
- ✅ Verificar que `novo_log()` não chama a si mesma recursivamente
- ✅ Garantir que `novo_log()` chama `sendLogToProfessionalSystem()` diretamente (sem intermediários)

#### **FASE 0.2: Verificar Dependências**
- ✅ Verificar que `window.shouldLog()`, `window.shouldLogToDatabase()`, `window.shouldLogToConsole()` existem
- ✅ Verificar que `sendLogToProfessionalSystem()` existe
- ✅ Adicionar verificações de existência antes de chamar

---

### **FASE 1: Preparação e Backup**

#### **FASE 1.1: Criar Backup do Arquivo**
- ✅ Criar backup de `FooterCodeSiteDefinitivoCompleto.js`
- ✅ Salvar em `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/`
- ✅ Nome: `FooterCodeSiteDefinitivoCompleto.js.backup_ANTES_UNIFICACAO_LOG_YYYYMMDD_HHMMSS.js`
- ✅ **OBRIGATÓRIO:** Usar caminho completo do workspace ao criar backup

#### **FASE 1.2: Verificar Hash do Arquivo Atual**
- ✅ Calcular hash SHA256 do arquivo atual
- ✅ Documentar hash para verificação pós-modificação

#### **FASE 1.3: Mapear Todas as Chamadas**
- ✅ **JÁ FEITO:** Análise exata identificou 67 chamadas (ver `ANALISE_EXATA_CHAMADAS_LOG.md`)
- ✅ Criar lista completa de substituições com mapeamento detalhado:
  - `logClassified()`: 16 chamadas → mapeamento 1:1
  - `sendLogToProfessionalSystem()`: 4 chamadas → mapeamento 1:1
  - `logUnified()`: 4 chamadas → mapeamento com conversão de nível
  - `logDebug()`: 43 chamadas → mapeamento especial (category → level='DEBUG')

---

### **FASE 2: Criar Função `novo_log()`**

#### **FASE 2.1: Implementar Função `novo_log()`**
- ✅ Criar função `novo_log()` com todas as funcionalidades
- ✅ Integrar verificações de parametrização (`window.shouldLog()`, etc.)
- ✅ Integrar verificações de `DEBUG_CONFIG` (compatibilidade)
- ✅ Implementar chamada a `console.log/error/warn`
- ✅ Implementar chamada a `sendLogToProfessionalSystem()` (assíncrona)
- ✅ Adicionar tratamento de erros silencioso
- ✅ Mapear níveis de log corretamente

#### **FASE 2.2: Expor Função Globalmente**
- ✅ Expor como `window.novo_log = novo_log`
- ✅ Manter compatibilidade com código existente (se necessário)

#### **FASE 2.3: Resolver Assinatura de `logDebug()` (CRÍTICO)**
- 🔴 **OBRIGATÓRIO:** Verificar assinatura real de `window.logDebug()` (linha 921)
- ✅ **CONFIRMADO:** `window.logDebug(category, message, data)` - primeiro parâmetro é categoria
- ✅ Documentar mapeamento: `window.logDebug(category, message, data)` → `novo_log('DEBUG', category, message, data)`
- ✅ Criar função helper ou wrapper se necessário para compatibilidade

---

### **FASE 3: Substituir Todas as Chamadas**

#### **FASE 3.1: Substituir Chamadas de `logClassified()`**
- ✅ Substituir todas as **16 chamadas** por `novo_log()`
- ✅ Mapear parâmetros corretamente:
  - `logClassified(level, category, message, data, context, verbosity)`
  - → `novo_log(level, category, message, data, context, verbosity)`
- ✅ **Mapeamento:** 1:1 (direto, sem conversão)

#### **FASE 3.2: Substituir Chamadas de `sendLogToProfessionalSystem()`**
- ✅ Substituir todas as **4 chamadas diretas** por `novo_log()`
- ✅ Mapear parâmetros corretamente:
  - `sendLogToProfessionalSystem(level, category, message, data)`
  - → `novo_log(level, category, message, data)` (context e verbosity com defaults)
- ✅ **Mapeamento:** 1:1 (direto, com defaults)

#### **FASE 3.3: Substituir Chamadas de `logUnified()`**
- ✅ Substituir todas as **4 chamadas** legadas por `novo_log()`
- ✅ **CRÍTICO:** Converter nível para maiúsculas (`.toUpperCase()`)
- ✅ Mapear parâmetros corretamente:
  - `logUnified(level, category, message, data)` (level em minúsculas: 'info', 'error', 'warn', 'debug')
  - → `novo_log(level.toUpperCase(), category, message, data)` (level em maiúsculas: 'INFO', 'ERROR', 'WARN', 'DEBUG')
- ✅ **Mapeamento:** Com conversão de nível

#### **FASE 3.4: Substituir Chamadas de `logDebug()`**
- ✅ Substituir todas as **43 chamadas** por `novo_log()`
- ✅ **CRÍTICO:** Mapear primeiro parâmetro como categoria (não nível)
- ✅ Mapear parâmetros corretamente:
  - `window.logDebug(category, message, data)` (primeiro parâmetro é categoria)
  - → `novo_log('DEBUG', category, message, data)` (nível padrão: 'DEBUG')
- ✅ **Mapeamento:** Especial (category → level='DEBUG')

---

### **FASE 4: Remover Funções Antigas (Opcional)**

#### **FASE 4.1: Marcar Funções como Deprecated**
- ✅ Adicionar comentário `@deprecated` em `logClassified()`
- ✅ Adicionar comentário `@deprecated` em `logUnified()`
- ✅ Adicionar comentário `@deprecated` em `window.logDebug()` (linha 921)
- ✅ Adicionar comentário `@deprecated` em `logDebug()` local (linha 2027)
- ✅ Manter funções por compatibilidade temporária (se necessário)

#### **FASE 4.2: Remover Funções (Futuro)**
- ⚠️ **NÃO fazer agora:** Remover funções antigas pode quebrar código legado
- ✅ Documentar que funções serão removidas em versão futura
- ✅ Criar plano de remoção gradual

---

### **FASE 5: Testes Locais**

#### **FASE 5.1: Testar Sintaxe**
- ✅ Verificar que arquivo não tem erros de sintaxe
- ✅ Verificar que não há erros de lint

#### **FASE 5.2: Testar Funcionalidade**
- ✅ Testar que `novo_log()` exibe no console
- ✅ Testar que `novo_log()` envia para o banco
- ✅ Testar que parametrização funciona (desabilitar logging e verificar que não envia)
- ✅ Testar que não há loops infinitos
- ✅ **OBRIGATÓRIO:** Testar mapeamento de parâmetros para cada tipo de função:
  - Testar mapeamento de `logClassified()` → `novo_log()` (16 chamadas)
  - Testar mapeamento de `sendLogToProfessionalSystem()` → `novo_log()` (4 chamadas)
  - Testar mapeamento de `logUnified()` → `novo_log()` com conversão de nível (4 chamadas)
  - Testar mapeamento de `logDebug()` → `novo_log()` com category → level='DEBUG' (43 chamadas)
- ✅ Verificar que todas as 67 chamadas antigas foram substituídas

---

### **FASE 6: Deploy para Servidor DEV**

#### **FASE 6.1: Criar Backup no Servidor**
- ✅ Criar backup do arquivo atual no servidor DEV
- ✅ Salvar em `/var/www/html/dev/root/backups_YYYYMMDD_HHMMSS/`
- ✅ **OBRIGATÓRIO:** Usar caminho completo do workspace ao criar backup

#### **FASE 6.2: Copiar Arquivo para Servidor**
- ✅ Copiar `FooterCodeSiteDefinitivoCompleto.js` para servidor DEV
- ✅ Servidor DEV: `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
- ✅ Caminho no servidor: `/var/www/html/dev/root/`
- ✅ **OBRIGATÓRIO:** Usar caminho completo do workspace ao copiar arquivos
- ✅ **OBRIGATÓRIO:** Verificar hash SHA256 após cópia (case-insensitive)
- ✅ Confirmar que hash coincide antes de considerar deploy concluído

#### **FASE 6.3: Verificar Funcionamento**
- ✅ Testar que logs aparecem no console
- ✅ Testar que logs são inseridos no banco
- ✅ Verificar que não há erros no console
- ✅ Verificar que todos os logs do console agora aparecem no banco
- 🚨 **OBRIGATÓRIO - CACHE CLOUDFLARE:** Avisar ao usuário sobre necessidade de limpar cache do Cloudflare

---

### **FASE 7: Validação e Documentação**

#### **FASE 7.1: Validar Resultados**
- ✅ Verificar que todos os logs do console agora aparecem no banco
- ✅ Verificar que parametrização funciona corretamente
- ✅ Verificar que não há loops infinitos
- ✅ Verificar que performance não foi afetada
- ✅ Verificar que não há erros no console
- ✅ Verificar que todas as 67 chamadas foram substituídas corretamente

#### **FASE 7.2: Documentar Mudanças**
- ✅ Documentar criação de `novo_log()`
- ✅ Documentar substituição de todas as funções antigas (67 chamadas)
- ✅ Documentar mapeamentos especiais (logDebug, logUnified)
- ✅ Atualizar documentação do sistema de logging
- ✅ Criar relatório de implementação

#### **FASE 7.3: Auditoria Pós-Implementação (OBRIGATÓRIA)**
- ✅ Realizar auditoria de código: Verificar todos os arquivos alterados
- ✅ Realizar auditoria de funcionalidade: Comparar com backup original
- ✅ Criar documento de auditoria formal: `AUDITORIA_UNIFICACAO_LOG.md`
- ✅ Documentar problemas encontrados e correções aplicadas
- ✅ Confirmar que nenhuma funcionalidade foi prejudicada
- ✅ Verificar que todas as 67 chamadas foram substituídas corretamente
- ✅ Verificar que mapeamentos estão corretos (especialmente logDebug e logUnified)

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Risco 1: Loop Infinito**
- **Risco:** `novo_log()` chama `sendLogToProfessionalSystem()` que chama `novo_log()` novamente
- **Mitigação:** 
  - ✅ `sendLogToProfessionalSystem()` usa `console.log` direto, não `novo_log()` (já verificado)
  - ✅ Verificar que não há chamadas circulares
  - ✅ Adicionar flag de prevenção de loop (se necessário)

### **Risco 2: Substituições Incorretas**
- **Risco:** Substituir chamadas incorretamente pode quebrar funcionalidade
- **Mitigação:** 
  - ✅ Mapear cuidadosamente todos os parâmetros (67 chamadas mapeadas)
  - ✅ **CRÍTICO:** Atenção especial para `logDebug()` (category → level='DEBUG')
  - ✅ **CRÍTICO:** Atenção especial para `logUnified()` (conversão de nível)
  - ✅ Testar cada substituição
  - ✅ Manter backup para rollback

### **Risco 3: Performance**
- **Risco:** Adicionar chamadas HTTP para cada log pode impactar performance
- **Mitigação:** 
  - ✅ Chamar `sendLogToProfessionalSystem()` de forma assíncrona (não bloquear)
  - ✅ Verificar parametrização antes de enviar (evitar chamadas desnecessárias)
  - ✅ Usar `catch` silencioso para não quebrar aplicação

### **Risco 4: Dependências**
- **Risco:** Funções podem não estar disponíveis quando `novo_log()` é chamado
- **Mitigação:** 
  - ✅ Verificar se funções existem antes de chamar
  - ✅ Usar `try-catch` para tratamento de erros
  - ✅ Não quebrar aplicação se logging falhar

### **Risco 5: Compatibilidade**
- **Risco:** Código legado pode depender de funções antigas
- **Mitigação:** 
  - ✅ Manter funções antigas como deprecated (temporariamente)
  - ✅ Criar aliases se necessário
  - ✅ Documentar plano de remoção gradual

### **Risco 6: Mapeamento Incorreto de `logDebug()`**
- **Risco:** Assinatura diferente pode causar erros se mapeamento estiver incorreto
- **Mitigação:** 
  - ✅ **VERIFICADO:** `window.logDebug(category, message, data)` → `novo_log('DEBUG', category, message, data)`
  - ✅ Testar especificamente mapeamento de `logDebug()` (43 chamadas)
  - ✅ Documentar claramente o mapeamento especial

### **Risco 7: Conversão de Nível em `logUnified()`**
- **Risco:** Nível em minúsculas pode causar erro se não converter
- **Mitigação:** 
  - ✅ Adicionar conversão `.toUpperCase()` ao mapear parâmetros
  - ✅ Testar especificamente mapeamento de `logUnified()` (4 chamadas)

---

## 📊 ARQUIVOS ENVOLVIDOS

### **Arquivos a Modificar:**
1. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
   - Criar função `novo_log()` (nova função única)
   - Substituir todas as chamadas a `logClassified()` (16 chamadas)
   - Substituir todas as chamadas a `sendLogToProfessionalSystem()` (4 chamadas)
   - Substituir todas as chamadas a `logUnified()` (4 chamadas, com conversão de nível)
   - Substituir todas as chamadas a `logDebug()` (43 chamadas, com mapeamento especial)
   - Marcar funções antigas como deprecated

### **Arquivos de Backup:**
1. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/FooterCodeSiteDefinitivoCompleto.js.backup_ANTES_UNIFICACAO_LOG_*.js`

### **Arquivos de Documentação:**
1. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PROJETO_UNIFICAR_FUNCAO_LOG.md` (este arquivo)
2. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/ANALISE_EXATA_CHAMADAS_LOG.md` (análise exata)
3. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/AUDITORIA_COMPLETA_PROJETO_UNIFICAR_FUNCAO_LOG.md` (auditoria)
4. `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/AUDITORIA_UNIFICACAO_LOG.md` (após implementação)

---

## 📋 MAPEAMENTO DETALHADO DE PARÂMETROS

### **1. `logClassified()` → `novo_log()` (16 chamadas)**

**Mapeamento:** 1:1 (direto, sem conversão)

```javascript
// Antes:
logClassified(level, category, message, data, context, verbosity)

// Depois:
novo_log(level, category, message, data, context, verbosity)
```

**Exemplo:**
```javascript
// Antes:
logClassified('INFO', 'CONFIG', 'Variáveis carregadas', {url: '...'}, 'INIT', 'SIMPLE');

// Depois:
novo_log('INFO', 'CONFIG', 'Variáveis carregadas', {url: '...'}, 'INIT', 'SIMPLE');
```

---

### **2. `sendLogToProfessionalSystem()` → `novo_log()` (4 chamadas)**

**Mapeamento:** 1:1 (direto, com defaults)

```javascript
// Antes:
sendLogToProfessionalSystem(level, category, message, data)

// Depois:
novo_log(level, category, message, data)  // context='OPERATION', verbosity='SIMPLE' (defaults)
```

**Exemplo:**
```javascript
// Antes:
sendLogToProfessionalSystem('INFO', 'LOG', 'Mensagem', {data: '...'});

// Depois:
novo_log('INFO', 'LOG', 'Mensagem', {data: '...'});  // context e verbosity com defaults
```

---

### **3. `logUnified()` → `novo_log()` (4 chamadas)**

**Mapeamento:** Com conversão de nível (`.toUpperCase()`)

```javascript
// Antes:
logUnified(level, category, message, data)  // level em minúsculas: 'info', 'error', 'warn', 'debug'

// Depois:
novo_log(level.toUpperCase(), category, message, data)  // level em maiúsculas: 'INFO', 'ERROR', 'WARN', 'DEBUG'
```

**Exemplo:**
```javascript
// Antes:
window.logUnified('info', 'CONFIG', 'Mensagem', {data: '...'});

// Depois:
novo_log('INFO', 'CONFIG', 'Mensagem', {data: '...'});  // 'info' → 'INFO'
```

---

### **4. `logDebug()` → `novo_log()` (43 chamadas)**

**Mapeamento:** Especial (category → level='DEBUG')

```javascript
// Antes:
window.logDebug(category, message, data)  // primeiro parâmetro é categoria, não nível

// Depois:
novo_log('DEBUG', category, message, data)  // nível padrão: 'DEBUG', primeiro parâmetro vira category
```

**Exemplo:**
```javascript
// Antes:
window.logDebug('GCLID', '🔍 Iniciando captura - URL:', window.location.href);

// Depois:
novo_log('DEBUG', 'GCLID', '🔍 Iniciando captura - URL:', window.location.href);  // 'GCLID' vira category, level='DEBUG'
```

**Exemplo 2:**
```javascript
// Antes:
window.logDebug('MODAL', '⚠️ Modal já está sendo aberto...');

// Depois:
novo_log('DEBUG', 'MODAL', '⚠️ Modal já está sendo aberto...');  // 'MODAL' vira category, level='DEBUG'
```

---

## ⏱️ TEMPO ESTIMADO

- **FASE 0:** ~15 minutos (verificações)
- **FASE 1:** ~20 minutos (backup e mapeamento)
- **FASE 2:** ~75 minutos (criar função `novo_log()` + resolver assinatura de `logDebug()`)
- **FASE 3:** ~120 minutos (substituir 67 chamadas com mapeamentos especiais)
- **FASE 4:** ~20 minutos (marcar deprecated)
- **FASE 5:** ~45 minutos (testes locais + testes de mapeamento)
- **FASE 6:** ~20 minutos (deploy)
- **FASE 7:** ~60 minutos (validação e documentação)

**Total:** ~5h35min

---

## ✅ CRITÉRIOS DE SUCESSO

1. ✅ Função única `novo_log()` criada e funcionando
2. ✅ Todas as 67 chamadas a funções antigas foram substituídas
3. ✅ `novo_log()` exibe logs no console
4. ✅ `novo_log()` envia logs para o banco de dados
5. ✅ Todos os logs do console aparecem no banco (não apenas alguns)
6. ✅ Parametrização funciona corretamente (logs são filtrados conforme configuração)
7. ✅ Não há loops infinitos
8. ✅ Performance não foi afetada significativamente
9. ✅ Não há erros no console
10. ✅ Funções antigas marcadas como deprecated
11. ✅ Código mantém compatibilidade (funções antigas ainda funcionam temporariamente)
12. ✅ **Mapeamentos corretos:** `logDebug()` e `logUnified()` mapeados corretamente
13. ✅ **Todas as 67 chamadas verificadas:** Nenhuma chamada antiga restante

---

## 🚨 AVISOS IMPORTANTES

### **1. Cache Cloudflare**
⚠️ **OBRIGATÓRIO:** Após atualizar arquivo `.js` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.

### **2. Backups**
✅ **OBRIGATÓRIO:** Sempre criar backup antes de qualquer modificação.

### **3. Verificação de Hash**
✅ **OBRIGATÓRIO:** Sempre verificar hash (SHA256) após cópia de arquivos, comparando case-insensitive.

### **4. Ambiente**
✅ **PADRÃO:** Trabalhar apenas no ambiente de **DESENVOLVIMENTO** (DEV).

### **5. Substituições**
⚠️ **CRÍTICO:** Substituir cuidadosamente todas as chamadas, mapeando parâmetros corretamente:
- ✅ `logClassified()`: mapeamento 1:1 (16 chamadas)
- ✅ `sendLogToProfessionalSystem()`: mapeamento 1:1 (4 chamadas)
- ⚠️ `logUnified()`: **conversão de nível obrigatória** (4 chamadas)
- ⚠️ `logDebug()`: **mapeamento especial obrigatório** (43 chamadas)

### **6. Mapeamento de `logDebug()`**
🔴 **CRÍTICO:** `window.logDebug(category, message, data)` → `novo_log('DEBUG', category, message, data)`
- Primeiro parâmetro é **categoria**, não nível
- Nível padrão é **'DEBUG'**

### **7. Conversão de Nível em `logUnified()`**
🟠 **ALTO:** `logUnified(level, ...)` → `novo_log(level.toUpperCase(), ...)`
- Sempre converter nível para maiúsculas

---

## 📝 NOTAS

- Este projeto unifica todas as funções de log em uma única função centralizada
- Elimina confusão sobre qual função usar
- Facilita manutenção futura
- Segue especificação original: uma função única que faz console.log + insertLog()
- Funções antigas serão mantidas como deprecated temporariamente para compatibilidade
- Plano de remoção gradual será criado após validação
- **Baseado em análise exata:** 67 chamadas identificadas (não estimativa)
- **Auditoria completa realizada:** Ver `AUDITORIA_COMPLETA_PROJETO_UNIFICAR_FUNCAO_LOG.md`

---

## 📚 REFERÊNCIAS

1. `ANALISE_EXATA_CHAMADAS_LOG.md` - Análise criteriosa linha por linha (67 chamadas identificadas)
2. `AUDITORIA_COMPLETA_PROJETO_UNIFICAR_FUNCAO_LOG.md` - Auditoria completa do projeto
3. `PROJETO_IMPLEMENTAR_PARAMETRIZACAO_LOGGING.md` - Projeto de parametrização (já implementado)

---

**Status:** 📝 **DOCUMENTO REFATORADO - AGUARDANDO AUTORIZAÇÃO PARA IMPLEMENTAÇÃO**
