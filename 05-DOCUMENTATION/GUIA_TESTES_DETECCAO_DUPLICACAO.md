# 📋 Guia: Testes de Detecção de Duplicação

**Data:** 16/11/2025  
**Objetivo:** Validar correção de detecção de duplicação antes da implementação

---

## 🎯 OBJETIVO DOS TESTES

Validar que a correção de detecção de duplicação funciona corretamente quando o EspoCRM retorna HTTP 409 (Conflict) com mensagem de erro vazia.

---

## 📂 ARQUIVOS DE TESTE

### **1. test_deteccao_duplicacao_lead.php**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/test_deteccao_duplicacao_lead.php`

**Objetivo:** Testar detecção de duplicação de LEAD

**Testes Incluídos:**
- ✅ Teste 1: HTTP 409 com mensagem vazia (caso real)
- ✅ Teste 2: HTTP 409 com mensagem contendo "409"
- ✅ Teste 3: HTTP 400 (não é duplicação - deve tratar como erro real)

**Como Executar:**
```bash
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\TMP"
php test_deteccao_duplicacao_lead.php
```

---

### **2. test_deteccao_duplicacao_opportunity.php**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/test_deteccao_duplicacao_opportunity.php`

**Objetivo:** Testar detecção de duplicação de OPPORTUNITY

**Testes Incluídos:**
- ✅ Teste 1: HTTP 409 com mensagem vazia (caso real)
- ✅ Teste 2: HTTP 409 com mensagem contendo "duplicate"
- ✅ Teste 3: HTTP 500 (não é duplicação - deve tratar como erro real)

**Como Executar:**
```bash
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\TMP"
php test_deteccao_duplicacao_opportunity.php
```

---

### **3. test_deteccao_duplicacao_completo.php**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/test_deteccao_duplicacao_completo.php`

**Objetivo:** Executar todos os testes e gerar relatório completo

**Testes Incluídos:**
- ✅ Teste 1: Detecção de duplicação de LEAD (código atual vs corrigido)
- ✅ Teste 2: Detecção de duplicação de OPPORTUNITY (código atual vs corrigido)
- ✅ Teste 3: Verificar que erros não-409 não são detectados como duplicação

**Como Executar:**
```bash
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\TMP"
php test_deteccao_duplicacao_completo.php
```

**Saída Esperada:**
- Estatísticas de testes (total, passou, falhou)
- Resultados detalhados por tipo de teste
- Conclusão final (todos passaram ou alguns falharam)

---

## ✅ CRITÉRIOS DE SUCESSO

### **Teste 1: HTTP 409 com mensagem vazia**

**Código Atual:**
- ❌ **Esperado:** NÃO detecta duplicação (problema identificado)
- ✅ **Resultado:** Confirma que código atual tem o problema

**Código Corrigido:**
- ✅ **Esperado:** DETECTA duplicação corretamente
- ✅ **Resultado:** Deve detectar e atualizar lead/oportunidade

### **Teste 2: HTTP 409 com mensagem**

**Ambos os Códigos:**
- ✅ **Esperado:** DETECTAM duplicação corretamente
- ✅ **Resultado:** Ambos devem funcionar (verificação redundante)

### **Teste 3: Erro não-409 (400, 500, etc.)**

**Código Corrigido:**
- ✅ **Esperado:** NÃO detecta como duplicação
- ✅ **Resultado:** Deve tratar como erro real

---

## 📊 INTERPRETAÇÃO DOS RESULTADOS

### **Cenário 1: Todos os testes passam**

✅ **Significado:** Correção está funcionando corretamente  
✅ **Ação:** Prosseguir com implementação (FASE 1 do projeto)

### **Cenário 2: Alguns testes falham**

❌ **Significado:** Correção precisa ser revisada  
⚠️ **Ação:** Revisar código da correção antes de implementar

### **Cenário 3: Teste 1 falha (código atual)**

✅ **Significado:** Confirma que problema existe (esperado)  
✅ **Ação:** Prosseguir com correção

---

## 🔍 VALIDAÇÃO ADICIONAL

Após implementar a correção, validar também:

1. ✅ **Teste em ambiente DEV:**
   - Submeter formulário com email já existente no EspoCRM
   - Verificar logs: `duplicate_lead_detected`
   - Verificar logs: `http_code: 409`
   - Verificar logs: `lead_updated`

2. ✅ **Teste de erro real:**
   - Simular erro diferente de 409
   - Verificar logs: `real_error_creating_lead`
   - Verificar que não foi tratado como duplicação

---

## 📝 NOTAS

- Os testes são **simulados** e não fazem requisições reais ao EspoCRM
- Os testes validam apenas a **lógica de detecção** de duplicação
- Testes reais em ambiente DEV são necessários após implementação

---

**Status:** ✅ **ARQUIVOS DE TESTE CRIADOS**

