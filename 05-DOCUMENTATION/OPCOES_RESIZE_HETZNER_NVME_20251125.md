# 📋 OPÇÕES DE RESIZE: Hetzner Cloud com NVMe

**Data:** 25/11/2025  
**Servidor Atual:** `flyingdonkeys.com.br` (37.27.1.242)  
**Recursos Atuais:** 4 CPU, 7.6 GB RAM, 150 GB disco  
**Objetivo:** Upgrade para disco NVMe para resolver I/O wait alto

---

## 🎯 PLANOS HETZNER CLOUD COM NVMe

### **Série CPX (Cloud Performance X) - COM NVMe**

Todos os planos da série **CPX** incluem disco **NVMe** por padrão.

---

### **CPX11** (Plano Básico)

| Recurso | Especificação |
|---------|---------------|
| **CPU** | 2 vCPU |
| **RAM** | 4 GB |
| **Disco NVMe** | 40 GB |
| **Rede** | 20 TB tráfego |
| **Preço** | ~€4.75/mês |

**Análise:**
- ❌ **Menor que atual** (CPU e RAM)
- ✅ **NVMe incluído**
- ⚠️ **Não recomendado** (downgrade de recursos)

---

### **CPX21** (Recomendado para Upgrade)

| Recurso | Especificação |
|---------|---------------|
| **CPU** | 3 vCPU |
| **RAM** | 8 GB |
| **Disco NVMe** | 80 GB |
| **Rede** | 20 TB tráfego |
| **Preço** | ~€9.50/mês |

**Análise:**
- ✅ **CPU similar** (3 vs 4 cores - aceitável)
- ✅ **RAM similar** (8 GB vs 7.6 GB - ligeiramente melhor)
- ✅ **NVMe incluído** (resolve I/O wait)
- ✅ **Disco maior** (80 GB vs 150 GB - mas NVMe é mais rápido)
- ✅ **Boa opção** para upgrade

**Recomendação:** ✅ **RECOMENDADO** - Boa relação custo/benefício

---

### **CPX31** (Ideal para Performance)

| Recurso | Especificação |
|---------|---------------|
| **CPU** | 4 vCPU |
| **RAM** | 16 GB |
| **Disco NVMe** | 160 GB |
| **Rede** | 20 TB tráfego |
| **Preço** | ~€19.00/mês |

**Análise:**
- ✅ **CPU igual** (4 cores - mantém)
- ✅ **RAM maior** (16 GB vs 7.6 GB - margem para crescimento)
- ✅ **NVMe incluído** (resolve I/O wait)
- ✅ **Disco maior** (160 GB vs 150 GB - similar)
- ✅ **Excelente opção** para performance e crescimento

**Recomendação:** ✅ **IDEAL** - Melhor performance e margem futura

---

### **CPX41** (Alto Desempenho)

| Recurso | Especificação |
|---------|---------------|
| **CPU** | 8 vCPU |
| **RAM** | 32 GB |
| **Disco NVMe** | 240 GB |
| **Rede** | 20 TB tráfego |
| **Preço** | ~€38.00/mês |

**Análise:**
- ✅ **CPU maior** (8 cores - muito acima do necessário)
- ✅ **RAM muito maior** (32 GB - muito acima do necessário)
- ✅ **NVMe incluído** (resolve I/O wait)
- ✅ **Disco maior** (240 GB)
- ⚠️ **Overkill** para necessidades atuais

**Recomendação:** ⚠️ **APENAS se planeja crescimento significativo**

---

### **CPX51** (Máximo Desempenho)

| Recurso | Especificação |
|---------|---------------|
| **CPU** | 16 vCPU |
| **RAM** | 64 GB |
| **Disco NVMe** | 360 GB |
| **Rede** | 20 TB tráfego |
| **Preço** | ~€76.00/mês |

**Análise:**
- ✅ **CPU muito maior** (16 cores - muito acima do necessário)
- ✅ **RAM muito maior** (64 GB - muito acima do necessário)
- ✅ **NVMe incluído** (resolve I/O wait)
- ✅ **Disco maior** (360 GB)
- ❌ **Muito caro** para necessidades atuais

**Recomendação:** ❌ **NÃO recomendado** - Muito acima das necessidades

---

## 📊 COMPARAÇÃO: Atual vs Opções

| Plano | CPU | RAM | Disco | NVMe | Preço/mês | Recomendação |
|-------|-----|-----|-------|------|-----------|--------------|
| **Atual** | 4 | 7.6 GB | 150 GB | ❌ | ? | - |
| **CPX11** | 2 | 4 GB | 40 GB | ✅ | ~€4.75 | ❌ Downgrade |
| **CPX21** | 3 | 8 GB | 80 GB | ✅ | ~€9.50 | ✅ **Recomendado** |
| **CPX31** | 4 | 16 GB | 160 GB | ✅ | ~€19.00 | ✅ **Ideal** |
| **CPX41** | 8 | 32 GB | 240 GB | ✅ | ~€38.00 | ⚠️ Overkill |
| **CPX51** | 16 | 64 GB | 360 GB | ✅ | ~€76.00 | ❌ Muito caro |

---

## 🎯 RECOMENDAÇÕES

### **Opção 1: CPX21 (Custo-Benefício)** ⭐

**Por quê:**
- ✅ Resolve problema principal (NVMe)
- ✅ Recursos similares ao atual
- ✅ Preço acessível (~€9.50/mês)
- ✅ Boa relação custo/benefício

**Quando escolher:**
- Orçamento limitado
- Recursos atuais são suficientes
- Foco em resolver I/O wait

---

### **Opção 2: CPX31 (Ideal)** ⭐⭐⭐

**Por quê:**
- ✅ Resolve problema principal (NVMe)
- ✅ Mantém CPU atual (4 cores)
- ✅ RAM maior (16 GB - margem para crescimento)
- ✅ Disco similar (160 GB)
- ✅ Preço razoável (~€19.00/mês)

**Quando escolher:**
- Quer margem para crescimento
- Planeja aumentar carga no futuro
- Orçamento permite

---

### **Opção 3: CPX41/CPX51 (Apenas se necessário)**

**Por quê:**
- ✅ Resolve problema principal (NVMe)
- ✅ Muito mais recursos (overkill)

**Quando escolher:**
- Planeja crescimento significativo
- Múltiplas aplicações
- Alto tráfego esperado

---

## 📋 PROCESSO DE RESIZE

### **Passo a Passo:**

1. **Acessar Hetzner Cloud Console:**
   - https://console.hetzner.cloud/
   - Fazer login

2. **Localizar Servidor:**
   - Menu: **Servers** → **Servers**
   - Clicar no servidor `flyingdonkeys` (ou nome do servidor)

3. **Iniciar Resize:**
   - Menu: **Actions** → **Resize**
   - Ou: **Settings** → **Resize**

4. **Escolher Plano:**
   - Selecionar **CPX21** ou **CPX31** (recomendados)
   - Verificar que inclui **NVMe**

5. **Confirmar:**
   - Revisar mudanças
   - Confirmar resize
   - Aguardar conclusão (alguns minutos)

6. **Verificar:**
   - Verificar que servidor está rodando
   - Verificar I/O wait (deve estar < 5%)
   - Monitorar por 24-48 horas

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **1. Downtime:**
- Resize pode causar breve downtime (2-5 minutos)
- Agendar em horário de baixo tráfego

### **2. Backup:**
- **SEMPRE fazer backup antes de resize**
- Verificar que backup está completo

### **3. Dados:**
- Dados devem ser preservados
- Mas sempre fazer backup por segurança

### **4. IP:**
- IP público geralmente é mantido
- Verificar após resize

### **5. Configurações:**
- Configurações devem ser preservadas
- Verificar após resize

---

## 💰 CUSTO ESTIMADO

### **CPX21:**
- **Custo adicional:** ~€9.50/mês (se atual for menor)
- **Custo total:** ~€9.50/mês

### **CPX31:**
- **Custo adicional:** ~€19.00/mês (se atual for menor)
- **Custo total:** ~€19.00/mês

**Nota:** Preços podem variar. Verificar no Hetzner Cloud Console.

---

## ✅ CHECKLIST ANTES DE RESIZE

- [ ] Fazer backup completo do servidor
- [ ] Verificar que backup está completo
- [ ] Agendar resize em horário de baixo tráfego
- [ ] Escolher plano (CPX21 ou CPX31 recomendados)
- [ ] Confirmar que plano inclui NVMe
- [ ] Revisar custo adicional
- [ ] Confirmar resize
- [ ] Monitorar após resize

---

## 📊 RESULTADO ESPERADO APÓS RESIZE

### **Antes (Atual):**
- I/O Wait: 9-18% (ALTO)
- Disco: HDD/SSD básico
- Performance: Limitada por I/O

### **Depois (CPX21/CPX31 com NVMe):**
- I/O Wait: < 5% (NORMAL)
- Disco: NVMe (muito mais rápido)
- Performance: Melhorada significativamente

---

## 🎯 RECOMENDAÇÃO FINAL

### **Para Resolver I/O Wait Alto:**

**Opção Recomendada:** **CPX31**

**Por quê:**
- ✅ Resolve problema principal (NVMe)
- ✅ Mantém recursos atuais (CPU)
- ✅ Margem para crescimento (RAM)
- ✅ Preço razoável (~€19.00/mês)

**Alternativa:** **CPX21** se orçamento for limitado (~€9.50/mês)

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **INFORMAÇÕES COLETADAS**

**Nota:** Preços e especificações podem variar. Verificar no Hetzner Cloud Console para informações atualizadas.

