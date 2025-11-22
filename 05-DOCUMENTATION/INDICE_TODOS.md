# 📋 Índice de TODOs

**Data de Criação:** 16/11/2025  
**Última Atualização:** 16/11/2025

---

## 📝 LISTA DE TODOs PENDENTES

### **1. Correção de Duplicação de Leads e Oportunidades**

**Arquivo:** `TODO_CORRECAO_DUPLICACAO_LEADS_OPPORTUNIDADES.md`  
**Data de Criação:** 16/11/2025  
**Status:** 📋 **PENDENTE**  
**Prioridade:** 🟡 **MÉDIA**

**Descrição:** Corrigir a duplicação de leads e oportunidades que está ocorrendo no sistema. Identificar a causa raiz e implementar solução para evitar duplicações futuras.

**Problema Identificado:**
- Leads e oportunidades estão sendo duplicados no EspoCRM
- Possível causa: múltiplos webhooks ativos (antigos e novos)

**Soluções Propostas:**
1. Desativar webhooks antigos (recomendado)
2. Implementar validação antes de criar
3. Implementar idempotência

---

### **2. Parametrização SafetyMails DEV vs PROD**

**Arquivo:** `TODO_PARAMETRIZACAO_SAFETYMAILS_DEV_PROD.md`  
**Data de Criação:** 16/11/2025  
**Status:** 📋 **PENDENTE**  
**Prioridade:** 🟡 **MÉDIA**

**Descrição:** Implementar um sistema de parametrização para as credenciais do SafetyMails (`SAFETY_TICKET` e `SAFETY_API_KEY`) que diferencie os ambientes de Desenvolvimento (DEV) e Produção (PROD).

**Problema Identificado:**
- Credenciais estão hardcoded no JavaScript
- Mesmas credenciais para DEV e PROD (não ideal)

**Solução Proposta:**
- Utilizar `config_env.js.php` para expor credenciais via variáveis de ambiente

---

## 📊 RESUMO

| # | TODO | Prioridade | Status |
|---|------|------------|--------|
| 1 | Correção de Duplicação de Leads e Oportunidades | 🟡 MÉDIA | 📋 PENDENTE |
| 2 | Parametrização SafetyMails DEV vs PROD | 🟡 MÉDIA | 📋 PENDENTE |

**Total:** 2 TODOs pendentes

---

**Status:** 📋 **ÍNDICE ATUALIZADO**

