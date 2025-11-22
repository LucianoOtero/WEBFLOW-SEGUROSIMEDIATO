# 🔄 PROCESSO DE TRACKING DE ALTERAÇÕES NO BANCO DE DADOS

**Data de Criação:** 21/11/2025  
**Versão:** 1.0.0  
**Propósito:** Processo obrigatório para garantir rastreabilidade e replicação correta em PROD

---

## 🎯 OBJETIVO

Estabelecer processo obrigatório para registrar **TODAS** as alterações no banco de dados DEV antes de executá-las, garantindo:
- ✅ Rastreabilidade completa
- ✅ Replicação idêntica em PROD
- ✅ Auditoria de alterações
- ✅ Prevenção de erros

---

## 📋 PROCESSO OBRIGATÓRIO

### **FASE 1: REGISTRO ANTES DA ALTERAÇÃO** ⚠️ **OBRIGATÓRIO**

**ANTES de executar QUALQUER comando SQL no banco DEV:**

1. **Criar entrada no documento de tracking:**
   - Abrir: `TRACKING_ALTERACOES_BANCO_DADOS.md`
   - Criar nova entrada usando template
   - Preencher: Data, Hora, Motivo, Tabelas Afetadas

2. **Criar script SQL documentado:**
   - Criar script em `06-SERVER-CONFIG/`
   - Incluir comentários explicativos
   - Incluir verificações antes/depois
   - Tornar script idempotente (pode executar múltiplas vezes)

3. **Registrar comandos SQL que serão executados:**
   - Copiar comandos SQL exatos para documento de tracking
   - Documentar ordem de execução
   - Documentar dependências entre comandos

4. **Criar script SQL para PROD:**
   - Criar versão do script para PROD
   - Ajustar nomes de banco/tabelas se necessário
   - Incluir mesmas verificações e comentários

**Checklist Obrigatório:**
- [ ] Entrada criada em `TRACKING_ALTERACOES_BANCO_DADOS.md`
- [ ] Script SQL para DEV criado e documentado
- [ ] Script SQL para PROD criado e documentado
- [ ] Comandos SQL registrados no documento de tracking
- [ ] Verificações antes/depois documentadas

---

### **FASE 2: EXECUÇÃO DA ALTERAÇÃO**

**DURANTE a execução:**

1. **Executar verificações pré-alteração:**
   - Executar queries de verificação do estado atual
   - Registrar resultados no documento de tracking
   - Tirar "foto" do estado antes da alteração

2. **Executar comandos SQL:**
   - Executar script SQL documentado
   - Registrar saída/comandos executados
   - Documentar erros (se houver)

3. **Executar verificações pós-alteração:**
   - Executar queries de verificação do estado após alteração
   - Registrar resultados no documento de tracking
   - Comparar antes/depois

4. **Executar testes de validação:**
   - Testar funcionalidade afetada
   - Verificar que alteração funcionou como esperado
   - Documentar resultados dos testes

**Checklist Obrigatório:**
- [ ] Verificação pré-alteração executada e registrada
- [ ] Comandos SQL executados conforme documentado
- [ ] Verificação pós-alteração executada e registrada
- [ ] Testes de validação executados
- [ ] Resultados documentados

---

### **FASE 3: ATUALIZAÇÃO DO REGISTRO**

**APÓS a execução:**

1. **Atualizar documento de tracking:**
   - Preencher seção "Verificação Pré-Alteração"
   - Preencher seção "Verificação Pós-Alteração"
   - Preencher seção "Teste de Validação"
   - Preencher seção "Resultado"
   - Atualizar status para "✅ APLICADA"

2. **Atualizar histórico:**
   - Adicionar entrada na tabela de histórico
   - Marcar status como "Aplicada em DEV"
   - Marcar status PROD como "⏳ Pendente"

3. **Validar scripts para PROD:**
   - Revisar script SQL para PROD
   - Garantir que está idêntico (exceto nomes de banco)
   - Documentar qualquer diferença necessária

**Checklist Obrigatório:**
- [ ] Documento de tracking atualizado completamente
- [ ] Histórico atualizado
- [ ] Script SQL para PROD validado
- [ ] Status atualizado para "Aplicada em DEV"

---

### **FASE 4: REPLICAÇÃO EM PROD** (Quando Aplicável)

**ANTES de replicar em PROD:**

1. **Validação em DEV:**
   - ✅ Alteração validada e testada em DEV por período adequado
   - ✅ Nenhum problema identificado
   - ✅ Documentação completa

2. **Preparação para PROD:**
   - Revisar checklist de replicação em `TRACKING_ALTERACOES_BANCO_DADOS.md`
   - Criar backup do banco PROD (se aplicável)
   - Revisar script SQL para PROD
   - Agendar horário de manutenção (se necessário)

3. **Execução em PROD:**
   - Executar verificações pré-alteração em PROD
   - Executar script SQL para PROD
   - Executar verificações pós-alteração em PROD
   - Executar testes de validação em PROD

4. **Documentação da Replicação:**
   - Atualizar documento de tracking com data/hora da replicação
   - Atualizar histórico marcando como "✅ REPLICADA"
   - Documentar qualquer problema encontrado
   - Registrar resultados dos testes em PROD

**Checklist Obrigatório:**
- [ ] Validação em DEV confirmada
- [ ] Backup do banco PROD criado (se aplicável)
- [ ] Script SQL para PROD revisado
- [ ] Alteração executada em PROD
- [ ] Verificações executadas em PROD
- [ ] Testes executados em PROD
- [ ] Documentação atualizada

---

## 🚨 REGRAS CRÍTICAS

### **NUNCA Execute Alterações Sem:**

1. ❌ **NUNCA** execute comandos SQL diretamente sem registrar primeiro
2. ❌ **NUNCA** altere o banco sem criar script SQL documentado
3. ❌ **NUNCA** execute alterações sem verificar antes/depois
4. ❌ **NUNCA** replique em PROD sem validação completa em DEV

### **SEMPRE:**

1. ✅ **SEMPRE** registre alteração ANTES de executar
2. ✅ **SEMPRE** crie script SQL documentado
3. ✅ **SEMPRE** execute verificações antes/depois
4. ✅ **SEMPRE** documente resultados
5. ✅ **SEMPRE** crie script SQL para PROD junto com DEV

---

## 📊 ESTRUTURA DE DOCUMENTAÇÃO

### **Documento Principal:**
- `TRACKING_ALTERACOES_BANCO_DADOS.md` - Registro de todas as alterações

### **Scripts SQL:**
- `06-SERVER-CONFIG/alterar_XXX_dev.sql` - Script para DEV
- `06-SERVER-CONFIG/alterar_XXX_prod.sql` - Script para PROD
- `06-SERVER-CONFIG/verificar_XXX.sql` - Script de verificação

### **Documentação Relacionada:**
- Documentos de projeto em `05-DOCUMENTATION/`
- Documentos de análise em `05-DOCUMENTATION/`
- Documentos de auditoria em `05-DOCUMENTATION/`

---

## 🔍 EXEMPLO DE USO

### **Cenário:** Adicionar nova coluna `metadata` à tabela `application_logs`

**FASE 1: Registro Antes da Alteração**
1. Abrir `TRACKING_ALTERACOES_BANCO_DADOS.md`
2. Criar entrada "Alteração #002"
3. Preencher: Data, Motivo, Tabelas Afetadas
4. Criar script SQL: `alterar_adicionar_coluna_metadata_dev.sql`
5. Criar script SQL: `alterar_adicionar_coluna_metadata_prod.sql`
6. Registrar comandos SQL no documento

**FASE 2: Execução**
1. Executar verificação pré-alteração
2. Executar script SQL em DEV
3. Executar verificação pós-alteração
4. Testar funcionalidade

**FASE 3: Atualização**
1. Atualizar documento com resultados
2. Marcar como "✅ APLICADA"
3. Atualizar histórico

**FASE 4: Replicação PROD (quando aplicável)**
1. Validar em DEV
2. Executar script SQL em PROD
3. Atualizar documento marcando como "✅ REPLICADA"

---

## 📋 CHECKLIST GERAL

### **Para Qualquer Alteração:**

- [ ] Entrada criada em `TRACKING_ALTERACOES_BANCO_DADOS.md`
- [ ] Script SQL para DEV criado
- [ ] Script SQL para PROD criado
- [ ] Comandos SQL registrados
- [ ] Verificações antes/depois documentadas
- [ ] Alteração executada em DEV
- [ ] Resultados documentados
- [ ] Status atualizado

### **Para Replicação em PROD:**

- [ ] Validação em DEV confirmada
- [ ] Backup do banco PROD criado (se aplicável)
- [ ] Script SQL para PROD revisado
- [ ] Alteração executada em PROD
- [ ] Verificações executadas em PROD
- [ ] Testes executados em PROD
- [ ] Documentação atualizada

---

## 🎯 BENEFÍCIOS

1. **Rastreabilidade:** Todas as alterações são registradas
2. **Replicação:** Scripts prontos para PROD
3. **Auditoria:** Histórico completo de alterações
4. **Prevenção:** Processo obrigatório previne erros
5. **Documentação:** Tudo documentado para referência futura

---

**Processo criado para garantir rastreabilidade e replicação correta em PROD.**

