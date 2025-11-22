# ✅ TODO: Correção de Duplicação de Leads e Oportunidades

**Data de Criação:** 16/11/2025  
**Status:** 📋 **PENDENTE**  
**Prioridade:** 🟡 **MÉDIA** (Não crítico, mas importante)

---

## 🎯 OBJETIVO

Corrigir a duplicação de leads e oportunidades que está ocorrendo no sistema. Identificar a causa raiz e implementar solução para evitar duplicações futuras.

---

## 🔍 PROBLEMA IDENTIFICADO

### **Sintoma:**
- Leads e oportunidades estão sendo duplicados no EspoCRM
- Múltiplas entradas para o mesmo lead/oportunidade

### **Contexto:**
- Problema identificado após correção da API key do EspoCRM
- Sistema está funcionando (autenticação OK), mas criando duplicatas

### **Possíveis Causas:**
1. **Múltiplos webhooks ativos:**
   - Webhooks antigos em `bpsegurosimediato.com.br` ainda ativos
   - Webhooks novos em `prod.bssegurosimediato.com.br` também ativos
   - Ambos processando a mesma submissão de formulário

2. **Falta de validação de duplicação antes de criar:**
   - Sistema não verifica se lead/oportunidade já existe antes de criar
   - Depende apenas da detecção de erro HTTP 409 após tentativa de criação

3. **Lógica de detecção de duplicação:**
   - Correção de detecção de duplicação foi implementada
   - Mas pode não estar sendo acionada corretamente
   - Ou pode haver duplicação antes mesmo de chegar ao EspoCRM

---

## 🔧 INVESTIGAÇÃO NECESSÁRIA

### **1. Verificar Webhooks Ativos**

**Ação:** Identificar todos os webhooks ativos no Webflow

**Webhooks Conhecidos:**
- `https://bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php` (antigo)
- `https://prod.bssegurosimediato.com.br/add_flyingdonkeys.php` (novo)

**Verificar:**
- Quantos webhooks estão configurados no Webflow?
- Todos estão ativos?
- Todos estão processando a mesma submissão?

---

### **2. Analisar Logs de Duplicação**

**Ação:** Verificar logs para identificar padrão de duplicação

**Verificar:**
- Quantas requisições chegam para o mesmo lead?
- Request IDs diferentes para o mesmo email?
- Timestamps das requisições (simultâneas ou sequenciais)?

**Comandos:**
```bash
# Buscar por mesmo email em diferentes requisições
grep -i "LROTERO1329@GMAIL.COM" /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt

# Contar requisições por email
grep -oP '"email":\s*"[^"]+"' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | sort | uniq -c | sort -rn
```

---

### **3. Verificar Lógica de Detecção de Duplicação**

**Ação:** Validar se a correção de detecção de duplicação está funcionando

**Verificar:**
- HTTP 409 está sendo capturado corretamente?
- `duplicate_lead_detected` está sendo gerado?
- `lead_updated` está sendo executado?

**Teste Necessário:**
- Submeter formulário com email que já existe no EspoCRM
- Verificar se lead é atualizado ao invés de criado novamente

---

## 🔧 SOLUÇÕES PROPOSTAS

### **Opção 1: Desativar Webhooks Antigos (RECOMENDADO)**

**Ação:** Desativar webhooks antigos em `bpsegurosimediato.com.br`

**Vantagens:**
- ✅ Solução simples e direta
- ✅ Elimina duplicação na origem
- ✅ Não requer modificação de código

**Desvantagens:**
- ⚠️ Remove fallback (se houver necessidade)

**Processo:**
1. Identificar webhooks antigos no Webflow
2. Desativar webhooks de `bpsegurosimediato.com.br`
3. Manter apenas webhooks de `prod.bssegurosimediato.com.br`
4. Testar submissão de formulário
5. Verificar que não há mais duplicação

---

### **Opção 2: Implementar Validação Antes de Criar**

**Ação:** Verificar se lead/oportunidade já existe antes de criar

**Vantagens:**
- ✅ Previne duplicação proativamente
- ✅ Funciona mesmo com múltiplos webhooks
- ✅ Mais robusto

**Desvantagens:**
- ⚠️ Requer modificação de código
- ⚠️ Adiciona requisição extra ao EspoCRM (busca antes de criar)

**Processo:**
1. Antes de criar lead, buscar por email no EspoCRM
2. Se encontrar, atualizar ao invés de criar
3. Aplicar mesma lógica para oportunidades

---

### **Opção 3: Implementar Idempotência**

**Ação:** Usar request ID ou hash dos dados para garantir idempotência

**Vantagens:**
- ✅ Garante que mesma requisição não seja processada duas vezes
- ✅ Funciona mesmo com múltiplos webhooks
- ✅ Padrão de API RESTful

**Desvantagens:**
- ⚠️ Requer modificação de código
- ⚠️ Requer armazenamento de request IDs processados

---

## 📋 PLANO DE AÇÃO (Quando Implementar)

### **FASE 1: Investigação**

1. ⏭️ Identificar todos os webhooks ativos no Webflow
2. ⏭️ Analisar logs para identificar padrão de duplicação
3. ⏭️ Verificar se correção de detecção de duplicação está funcionando
4. ⏭️ Testar com email duplicado para validar detecção

### **FASE 2: Implementação**

1. ⏭️ Escolher solução (Opção 1, 2 ou 3)
2. ⏭️ Implementar solução escolhida
3. ⏭️ Testar em desenvolvimento
4. ⏭️ Deploy em produção

### **FASE 3: Validação**

1. ⏭️ Testar submissão de formulário
2. ⏭️ Verificar que não há mais duplicação
3. ⏭️ Monitorar logs por alguns dias

---

## 📝 NOTAS

- **Prioridade:** Média (não crítico, mas importante)
- **Impacto:** Duplicação de leads/oportunidades no EspoCRM
- **Complexidade:** Depende da solução escolhida (baixa a média)
- **Tempo Estimado:** 2-4 horas (dependendo da solução)

---

## 🔗 RELACIONADO

- **Correção de Detecção de Duplicação:** `PROJETO_CORRECAO_DETECCAO_DUPLICACAO_FLYINGDONKEYS.md` (✅ Implementado)
- **Análise de Autenticação:** `ANALISE_AUTENTICACAO_NAO_RESPEITA_AMBIENTE.md`
- **Correção API Key:** `PROJETO_CORRECAO_ESPOCRM_API_KEY_PROD.md` (✅ Implementado)

---

**Status:** 📋 **PENDENTE - AGUARDANDO IMPLEMENTAÇÃO**

