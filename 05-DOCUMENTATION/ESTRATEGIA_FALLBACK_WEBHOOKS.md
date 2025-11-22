# 🔄 Estratégia de Fallback - Webhooks

**Data:** 16/11/2025  
**Objetivo:** Documentar estratégia de fallback para webhooks do Webflow  
**Status:** ✅ **DOCUMENTADO**

---

## 📋 RESUMO EXECUTIVO

### **Situação Atual:**

O sistema possui **dois conjuntos de webhooks** configurados no Webflow:

1. **Webhooks Antigos (Fallback):**
   - Servidor: `bpsegurosimediato.com.br` (não documentado)
   - Endpoints:
     - `https://bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php`
     - `https://bpsegurosimediato.com.br/webhooks/add_webflow_octa_v2.php`
   - Status: ✅ **ATIVOS** (funcionando como fallback)

2. **Webhooks Novos (Implementação Atual):**
   - Servidor: `prod.bssegurosimediato.com.br` (157.180.36.223)
   - Endpoints:
     - `https://prod.bssegurosimediato.com.br/add_flyingdonkeys.php`
     - `https://prod.bssegurosimediato.com.br/add_webflow_octa.php`
   - Status: ✅ **ATIVOS** (implementação atual)

---

## 🎯 ESTRATÉGIA DE FALLBACK

### **1. Configuração Atual (Fallback Duplo):**

**Vantagens:**
- ✅ **Redundância:** Se um servidor falhar, o outro continua funcionando
- ✅ **Alta Disponibilidade:** Webflow tenta ambos os webhooks
- ✅ **Transição Segura:** Permite migração gradual sem interrupção

**Desvantagens:**
- ⚠️ **Duplicação:** Ambos os webhooks são executados, causando:
  - Leads duplicados no EspoCRM (se detecção de duplicação falhar)
  - Múltiplas mensagens no OctaDesk (2 chamadas legítimas)
  - Logs duplicados

---

### **2. Cenários de Fallback:**

#### **Cenário 1: Servidor Novo Funcionando Normalmente**
```
Webflow → prod.bssegurosimediato.com.br ✅
Webflow → bpsegurosimediato.com.br ✅ (fallback)
Resultado: 2 processamentos (duplicação)
```

#### **Cenário 2: Servidor Novo Indisponível**
```
Webflow → prod.bssegurosimediato.com.br ❌ (timeout/erro)
Webflow → bpsegurosimediato.com.br ✅ (fallback ativo)
Resultado: 1 processamento (fallback funcionando)
```

#### **Cenário 3: Servidor Antigo Indisponível**
```
Webflow → prod.bssegurosimediato.com.br ✅
Webflow → bpsegurosimediato.com.br ❌ (timeout/erro)
Resultado: 1 processamento (servidor novo funcionando)
```

#### **Cenário 4: Ambos os Servidores Funcionando**
```
Webflow → prod.bssegurosimediato.com.br ✅
Webflow → bpsegurosimediato.com.br ✅
Resultado: 2 processamentos (duplicação, mas ambos funcionando)
```

---

## 🔍 ANÁLISE DE DUPLICAÇÃO

### **Problema Identificado:**

**FlyingDonkeys (EspoCRM):**
- ⚠️ Webhook antigo cria lead primeiro
- ⚠️ Webhook novo tenta criar mesmo lead
- ⚠️ EspoCRM retorna HTTP 409 (Conflict)
- ✅ **CORRIGIDO:** Código agora detecta HTTP 409 e atualiza lead existente

**OctaDesk:**
- ✅ 2 chamadas legítimas (ambos os webhooks funcionando)
- ✅ Não é erro, é comportamento esperado do fallback
- ✅ OctaDesk processa ambas as mensagens

---

## 📊 MATRIZ DE DECISÃO

### **Quando Manter Fallback Ativo:**

| Situação | Ação | Justificativa |
|----------|------|---------------|
| Migração em andamento | ✅ Manter ambos | Transição segura |
| Servidor novo instável | ✅ Manter ambos | Garantir disponibilidade |
| Testes em produção | ✅ Manter ambos | Comparar resultados |
| Sistema estável há >30 dias | ⚠️ Considerar desativar antigo | Reduzir duplicação |

### **Quando Desativar Fallback:**

| Situação | Ação | Justificativa |
|----------|------|---------------|
| Servidor novo estável há >30 dias | ✅ Desativar antigo | Eliminar duplicação |
| Duplicação causando problemas | ✅ Desativar antigo | Resolver problema imediato |
| Manutenção do servidor antigo difícil | ✅ Desativar antigo | Simplificar arquitetura |

---

## 🛠️ PROCEDIMENTO DE DESATIVAÇÃO (Futuro)

### **Quando Decidir Desativar Webhooks Antigos:**

#### **Fase 1: Preparação**
1. ✅ Confirmar que servidor novo está estável há >30 dias
2. ✅ Verificar logs de erros no servidor novo
3. ✅ Confirmar que detecção de duplicação está funcionando
4. ✅ Documentar procedimento de rollback

#### **Fase 2: Desativação no Webflow**
1. Acessar Webflow Dashboard
2. Navegar para: `segurosimediato.webflow.io` → Webhooks
3. Desativar webhooks antigos:
   - `https://bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php`
   - `https://bpsegurosimediato.com.br/webhooks/add_webflow_octa_v2.php`
4. Manter apenas webhooks novos ativos

#### **Fase 3: Monitoramento**
1. ✅ Monitorar logs por 7 dias
2. ✅ Verificar se não há erros
3. ✅ Confirmar que leads estão sendo criados corretamente
4. ✅ Verificar que mensagens OctaDesk estão sendo enviadas

#### **Fase 4: Documentação**
1. ✅ Atualizar documentação de arquitetura
2. ✅ Remover referências a servidor antigo
3. ✅ Documentar decisão de desativação

---

## 📋 CHECKLIST DE FALLBACK

### **Status Atual:**

- [x] Webhooks antigos configurados e ativos
- [x] Webhooks novos configurados e ativos
- [x] Detecção de duplicação implementada (HTTP 409)
- [x] Logs funcionando em ambos os servidores
- [x] Documentação de fallback criada

### **Próximos Passos (Opcional):**

- [ ] Monitorar estabilidade do servidor novo por 30 dias
- [ ] Avaliar necessidade de manter fallback
- [ ] Decidir sobre desativação de webhooks antigos
- [ ] Executar procedimento de desativação (se necessário)

---

## 🔐 SEGURANÇA E MANUTENÇÃO

### **Servidor Antigo (bpsegurosimediato.com.br):**

**Status de Acesso:**
- ❌ IP não documentado
- ❌ Credenciais SSH não documentadas
- ⚠️ Acesso não disponível para modificações

**Recomendações:**
- ⚠️ Manter servidor antigo funcionando enquanto fallback for necessário
- ⚠️ Não modificar servidor antigo (diretiva do `.cursorrules`)
- ⚠️ Considerar documentar acesso quando necessário para manutenção crítica

### **Servidor Novo (prod.bssegurosimediato.com.br):**

**Status de Acesso:**
- ✅ IP documentado: `157.180.36.223`
- ✅ Credenciais SSH disponíveis
- ✅ Procedimento de modificação documentado

---

## 📊 MÉTRICAS DE MONITORAMENTO

### **Métricas para Avaliar Fallback:**

1. **Taxa de Sucesso:**
   - % de webhooks processados com sucesso
   - Comparar servidor novo vs. antigo

2. **Taxa de Duplicação:**
   - % de leads duplicados no EspoCRM
   - % de mensagens duplicadas no OctaDesk

3. **Tempo de Resposta:**
   - Tempo médio de processamento
   - Comparar servidor novo vs. antigo

4. **Disponibilidade:**
   - Uptime de cada servidor
   - Frequência de falhas

---

## ✅ CONCLUSÃO

### **Estratégia Atual:**

✅ **Fallback Duplo Ativo:**
- Webhooks antigos e novos funcionando simultaneamente
- Redundância garantida
- Duplicação gerenciada (detecção de HTTP 409 implementada)

### **Recomendação:**

✅ **Manter fallback ativo por enquanto:**
- Sistema novo ainda em estabilização
- Fallback garante alta disponibilidade
- Duplicação está sendo gerenciada corretamente

### **Próxima Revisão:**

📅 **Revisar estratégia após 30 dias:**
- Avaliar estabilidade do servidor novo
- Decidir sobre desativação de webhooks antigos
- Documentar decisão final

---

**Status:** ✅ **ESTRATÉGIA DOCUMENTADA - FALLBACK ATIVO**

**Última atualização:** 16/11/2025

