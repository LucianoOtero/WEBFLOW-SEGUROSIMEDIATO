# 📊 Limites do PHP-FPM: Por que não aumentar para 1.000 workers?

**Data:** 25/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA**  
**Objetivo:** Explicar por que não aumentar `pm.max_children` arbitrariamente

---

## 🎯 RESPOSTA DIRETA

**Não aumentar para 1.000 porque cada worker consome recursos do servidor (RAM, CPU).**

### **Cálculo Básico:**

```
Se cada worker consome ~50 MB de RAM:
- 1.000 workers = 1.000 × 50 MB = 50.000 MB = 50 GB de RAM
- Servidor típico tem 4-8 GB de RAM
- ❌ IMPOSSÍVEL: Servidor não tem RAM suficiente
```

---

## 💾 LIMITE 1: MEMÓRIA RAM

### **Cada Worker Consome RAM**

**Exemplo Real:**
- Cada processo PHP-FPM: **~30-100 MB** de RAM (depende do código)
- Servidor com **4 GB de RAM** disponível
- Sistema operacional e outros serviços: **~1 GB**
- RAM disponível para PHP-FPM: **~3 GB**

### **Cálculo do Limite:**

```
RAM disponível: 3.000 MB
Memória por worker: 50 MB (média)
Limite máximo: 3.000 MB ÷ 50 MB = 60 workers
```

**Com margem de segurança (80%):**
```
Limite seguro: 3.000 MB × 0.8 ÷ 50 MB = 48 workers
```

### **Se aumentar para 1.000:**

```
1.000 workers × 50 MB = 50.000 MB = 50 GB
Servidor tem: 4 GB
❌ IMPOSSÍVEL: Servidor travaria (OOM - Out of Memory)
```

---

## 🖥️ LIMITE 2: CPU

### **Cada Worker Usa CPU**

**Problemas com muitos workers:**

1. **Context Switching:**
   - Sistema operacional precisa alternar entre processos
   - Com 1.000 workers, CPU gasta mais tempo alternando do que processando
   - Performance **PIORA** ao invés de melhorar

2. **Limite de Cores:**
   - Servidor típico: 2-4 cores de CPU
   - 1.000 workers competindo por 4 cores = **sobrecarga**
   - Workers ficam esperando CPU disponível

### **Regra de Ouro:**

```
Workers ideais = Número de cores × 2 a 4
Exemplo: 4 cores × 3 = 12 workers ideais
```

**Com 1.000 workers:**
- 4 cores tentando processar 1.000 workers
- Cada worker recebe ~0.4% do tempo de CPU
- **Performance catastrófica**

---

## 📁 LIMITE 3: RECURSOS DO SISTEMA

### **A. Limite de Processos (ulimit)**

**Verificar limite:**
```bash
ulimit -u  # Limite de processos por usuário
```

**Típico:**
- Limite padrão: **4.096 processos**
- Se aumentar para 1.000 workers, pode atingir limite
- Outros processos do sistema também contam

### **B. Limite de Arquivos Abertos**

**Cada worker pode abrir arquivos:**
- Conexões de banco de dados
- Arquivos de log
- Arquivos de configuração
- Conexões de rede

**Limite típico:**
- 1.024 arquivos por processo
- 1.000 workers × 10 arquivos = 10.000 arquivos abertos
- Pode atingir limite do sistema

### **C. Limite de Conexões de Rede**

**Cada worker pode fazer conexões:**
- Banco de dados MySQL
- APIs externas
- Requisições HTTP

**Limite típico:**
- ~65.000 portas TCP disponíveis
- Mas cada conexão usa uma porta
- Com 1.000 workers, pode esgotar portas disponíveis

---

## 📊 CÁLCULO DO LIMITE IDEAL

### **Fórmula:**

```
Limite = min(
    RAM disponível ÷ Memória por worker,
    CPU cores × 4,
    Limite de processos do sistema
)
```

### **Exemplo Real (Servidor Típico):**

```
RAM: 4 GB (3 GB disponível para PHP)
CPU: 4 cores
Memória por worker: 50 MB
Limite de processos: 4.096

Cálculo:
- RAM: 3.000 MB ÷ 50 MB = 60 workers
- CPU: 4 cores × 4 = 16 workers
- Processos: 4.096 (não é limitante)

Limite ideal: min(60, 16) = 16 workers
Limite seguro: 16 × 0.8 = 12-15 workers
```

---

## ⚠️ PROBLEMAS DE AUMENTAR DEMAIS

### **1. Degradação de Performance**

**Com poucos workers (5):**
- ✅ Cada worker recebe 100% do tempo de CPU quando necessário
- ✅ Requisições processadas rapidamente
- ❌ Pode ter fila de espera em picos

**Com muitos workers (1.000):**
- ❌ Cada worker recebe 0.1% do tempo de CPU
- ❌ Requisições demoram MUITO mais
- ❌ Sistema operacional gasta mais tempo alternando processos
- ❌ **Performance PIORA drasticamente**

### **2. Out of Memory (OOM)**

**O que acontece:**
```
1. Servidor tenta criar 1.000 workers
2. RAM esgota rapidamente
3. Sistema operacional mata processos aleatórios
4. Servidor pode travar completamente
```

### **3. Context Switching Overhead**

**O que é:**
- Sistema operacional precisa alternar entre processos
- Com 1.000 workers, CPU gasta mais tempo alternando do que processando

**Impacto:**
- Requisições demoram 10-100x mais
- CPU fica 100% ocupada apenas alternando processos
- Nenhum trabalho útil sendo feito

---

## ✅ VALORES RECOMENDADOS

### **Servidor Pequeno (2 GB RAM, 2 cores):**
```ini
pm.max_children = 10-15
```

### **Servidor Médio (4 GB RAM, 4 cores):**
```ini
pm.max_children = 20-30
```

### **Servidor Grande (8 GB RAM, 8 cores):**
```ini
pm.max_children = 40-60
```

### **Servidor Muito Grande (16+ GB RAM, 16+ cores):**
```ini
pm.max_children = 80-120
```

---

## 🔧 COMO CALCULAR PARA SEU SERVIDOR

### **Passo 1: Verificar Recursos**

```bash
# RAM total
free -h

# CPU cores
nproc

# Memória por worker PHP-FPM
ps aux | grep 'php-fpm: pool www' | awk '{sum+=$6} END {print sum/NR/1024 " MB por worker"}'
```

### **Passo 2: Calcular Limite**

```bash
# RAM disponível (em MB)
RAM_AVAILABLE=3000

# Memória por worker (em MB)
MEM_PER_WORKER=50

# CPU cores
CPU_CORES=4

# Limite baseado em RAM
LIMIT_RAM=$((RAM_AVAILABLE / MEM_PER_WORKER))

# Limite baseado em CPU
LIMIT_CPU=$((CPU_CORES * 4))

# Limite ideal (menor dos dois)
LIMIT_IDEAL=$((LIMIT_RAM < LIMIT_CPU ? LIMIT_RAM : LIMIT_CPU))

echo "Limite ideal: $LIMIT_IDEAL workers"
```

### **Passo 3: Ajustar com Margem de Segurança**

```
Limite final = Limite ideal × 0.8
```

---

## 📋 RESUMO

### **Por que não 1.000 workers:**

1. ❌ **RAM insuficiente:** 1.000 × 50 MB = 50 GB (servidor típico tem 4 GB)
2. ❌ **CPU sobrecarregado:** 1.000 workers competindo por 4 cores
3. ❌ **Performance piora:** Context switching consome mais tempo que processamento
4. ❌ **Risco de OOM:** Sistema pode travar completamente

### **Valor ideal:**

- **Baseado em RAM:** RAM disponível ÷ Memória por worker
- **Baseado em CPU:** Número de cores × 2-4
- **Usar o menor dos dois** com margem de segurança (80%)

### **Para seu servidor (5 workers atual):**

**Recomendação:** Aumentar para **15-20 workers** (3-4x o atual)
- ✅ Resolve o problema de sobrecarga
- ✅ Não esgota recursos do servidor
- ✅ Melhora capacidade sem degradar performance

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA**

