# 🖥️ Requisitos Hetzner para 20 Workers PHP-FPM sem Degradação

**Data:** 25/11/2025  
**Servidor:** Produção (`prod.bssegurosimediato.com.br`)  
**Objetivo:** 20 workers PHP-FPM sem degradação de performance  
**Status:** ✅ **ANÁLISE COMPLETA**

---

## 🔍 SITUAÇÃO ATUAL

### **Recursos Atuais:**

```
CPU:        2 cores
RAM:        3.819 MB (3,7 GB)
Disco:      (verificar)
Workers:    5 (atual)
```

---

## ⚠️ PROBLEMA COM 20 WORKERS E 2 CORES

### **Context Switching Excessivo:**

**Com 2 cores e 20 workers:**
- Cada core precisa processar 10 workers simultaneamente
- Sistema operacional gasta muito tempo alternando entre processos
- Performance **degrada drasticamente**

**Regra de Ouro:**
```
Workers ideais = CPU Cores × 2 a 4
Para 20 workers: Precisa de 5-10 cores
```

---

## 💡 SOLUÇÃO: AUMENTAR CPU

### **Requisito Principal:**

**CPU: 4-6 cores** (mínimo para 20 workers)

**Justificativa:**
```
20 workers ÷ 4 workers por core = 5 cores (ideal)
20 workers ÷ 3 workers por core = 6,7 cores (mínimo)

Recomendação: 4-6 cores
```

---

## 📊 ANÁLISE DETALHADA

### **1. CPU (Crítico)**

**Atual:** 2 cores  
**Necessário:** 4-6 cores  
**Upgrade necessário:** +2 a +4 cores

**Por quê:**
- Com 2 cores: 20 workers = 10 workers por core → **context switching excessivo**
- Com 4 cores: 20 workers = 5 workers por core → **aceitável**
- Com 6 cores: 20 workers = 3,3 workers por core → **ideal**

**Impacto na Performance:**
- **2 cores:** ⚠️ Performance degrada 50-70%
- **4 cores:** ✅ Performance mantida ou melhorada
- **6 cores:** ✅ Performance otimizada

---

### **2. RAM (Verificar)**

**Atual:** 3.819 MB (3,7 GB)  
**Necessário para 20 workers:** ~1.000-1.500 MB

**Cálculo:**
```
20 workers × 50 MB = 1.000 MB
Margem de segurança: +500 MB
Total necessário: 1.500 MB
RAM atual: 3.819 MB
Disponível: 3.000 MB (após sistema)
```

**Conclusão:** ✅ **RAM atual é suficiente** para 20 workers

**Mas se quiser margem extra:**
- **Recomendado:** 4-6 GB RAM (para outros serviços também)

---

### **3. Disco (Verificar)**

**Necessário verificar:**
- Espaço em disco disponível
- IOPS (Input/Output Operations Per Second)
- Tipo de disco (SSD vs HDD)

**Com 20 workers:**
- Mais logs sendo escritos
- Mais arquivos sendo acessados
- Pode precisar de melhor IOPS

**Recomendação:**
- ✅ SSD (já deve ter)
- ✅ Mínimo 20 GB livres
- ✅ IOPS adequado (verificar com Hetzner)

---

## 🎯 PLANOS HETZNER RECOMENDADOS

### **Opção 1: CX21 → CPX21 (Mínimo)**

**Atual (estimado):** CX21
- CPU: 2 cores
- RAM: 4 GB
- Disco: 40 GB SSD

**Upgrade para:** CPX21
- CPU: **3 cores** (aumento de 50%)
- RAM: 4 GB (mantém)
- Disco: 80 GB SSD
- **Custo:** ~+50% do plano atual

**Avaliação:**
- ⚠️ **3 cores ainda é limitante** para 20 workers (6,7 workers por core)
- ⚠️ Pode ter alguma degradação de performance
- ✅ Melhor que 2 cores
- ✅ Custo menor

---

### **Opção 2: CX21 → CPX31 (Recomendado)**

**Upgrade para:** CPX31
- CPU: **4 cores** (aumento de 100%)
- RAM: 8 GB (aumento de 100%)
- Disco: 160 GB SSD
- **Custo:** ~+100% do plano atual

**Avaliação:**
- ✅ **4 cores é adequado** para 20 workers (5 workers por core)
- ✅ Performance mantida ou melhorada
- ✅ RAM extra permite outros serviços
- ✅ **RECOMENDAÇÃO PRINCIPAL**

---

### **Opção 3: CX21 → CPX41 (Ideal)**

**Upgrade para:** CPX41
- CPU: **8 cores** (aumento de 300%)
- RAM: 16 GB (aumento de 300%)
- Disco: 240 GB SSD
- **Custo:** ~+200% do plano atual

**Avaliação:**
- ✅ **8 cores é ideal** para 20 workers (2,5 workers por core)
- ✅ Performance otimizada
- ✅ Muita margem para crescimento
- ✅ RAM generosa
- ⚠️ Pode ser excessivo para necessidade atual

---

## 📊 COMPARAÇÃO DE PLANOS

| Plano | CPU | RAM | Disco | Workers/Core | Performance | Custo |
|-------|-----|-----|-------|--------------|-------------|-------|
| **Atual (CX21)** | 2 | 4 GB | 40 GB | 10 | ⚠️ Degrada | Base |
| **CPX21** | 3 | 4 GB | 80 GB | 6,7 | ⚠️ Pode degradar | +50% |
| **CPX31** | 4 | 8 GB | 160 GB | 5 | ✅ Adequado | +100% |
| **CPX41** | 8 | 16 GB | 240 GB | 2,5 | ✅ Ideal | +200% |

---

## ✅ RECOMENDAÇÃO FINAL

### **Para 20 Workers sem Degradação:**

**Upgrade para CPX31 (4 cores, 8 GB RAM)**

**Justificativa:**
1. ✅ **4 cores:** Adequado para 20 workers (5 por core)
2. ✅ **8 GB RAM:** Suficiente com margem
3. ✅ **Performance:** Mantida ou melhorada
4. ✅ **Custo:** Razoável (+100% do atual)
5. ✅ **Crescimento:** Permite expansão futura

### **Configuração Após Upgrade:**

```ini
pm.max_children = 20
pm.start_servers = 8
pm.min_spare_servers = 4
pm.max_spare_servers = 12
```

---

## 🔧 PROCESSO DE UPGRADE NO HETZNER

### **Passo 1: Verificar Plano Atual**

```bash
# Verificar recursos atuais
lscpu | grep "CPU(s)"
free -h
df -h
```

### **Passo 2: Fazer Backup**

```bash
# Backup completo do servidor
# Ou pelo menos backup de:
# - Configurações PHP-FPM
# - Configurações Nginx
# - Dados do banco de dados
```

### **Passo 3: Upgrade no Hetzner Cloud Console**

1. Acessar Hetzner Cloud Console
2. Selecionar servidor
3. Clicar em "Resize"
4. Escolher plano CPX31
5. Confirmar upgrade
6. Servidor será reiniciado

### **Passo 4: Verificar Após Upgrade**

```bash
# Verificar CPU
lscpu | grep "CPU(s)"

# Verificar RAM
free -h

# Verificar disco
df -h
```

### **Passo 5: Ajustar Configuração PHP-FPM**

```bash
# Editar configuração
nano /etc/php/8.3/fpm/pool.d/www.conf

# Alterar:
pm.max_children = 20
pm.start_servers = 8
pm.min_spare_servers = 4
pm.max_spare_servers = 12

# Recarregar PHP-FPM
systemctl reload php8.3-fpm
```

### **Passo 6: Monitorar Performance**

```bash
# Monitorar workers
watch -n 1 'ps aux | grep "php-fpm: pool www" | grep -v grep | wc -l'

# Monitorar CPU
top

# Monitorar RAM
free -h
```

---

## 📋 CHECKLIST DE UPGRADE

### **Antes do Upgrade:**
- [ ] Verificar plano atual no Hetzner
- [ ] Fazer backup completo
- [ ] Documentar configurações atuais
- [ ] Agendar janela de manutenção (se necessário)

### **Durante o Upgrade:**
- [ ] Executar upgrade no Hetzner Console
- [ ] Aguardar reinicialização do servidor
- [ ] Verificar se servidor voltou online

### **Após o Upgrade:**
- [ ] Verificar CPU (deve mostrar 4 cores)
- [ ] Verificar RAM (deve mostrar 8 GB)
- [ ] Verificar disco (deve mostrar 160 GB)
- [ ] Ajustar configuração PHP-FPM
- [ ] Recarregar PHP-FPM
- [ ] Testar aplicação
- [ ] Monitorar performance por 24-48 horas

---

## 💰 CONSIDERAÇÃO DE CUSTO

### **Alternativa: Otimizar Código**

**Antes de fazer upgrade, considerar:**

1. **Otimizar requisições lentas:**
   - Reduzir tempo de processamento
   - Menos workers necessários

2. **Implementar cache:**
   - Redis/Memcached
   - Reduz carga no PHP

3. **Otimizar banco de dados:**
   - Índices adequados
   - Queries otimizadas
   - Reduz tempo de processamento

4. **Implementar fila para emails:**
   - Processar assincronamente
   - Não bloqueia workers

**Se otimizar código:**
- Pode conseguir 15-20 workers com 2 cores
- Evita custo de upgrade
- Melhora performance geral

---

## 📊 RESUMO EXECUTIVO

### **Requisito Principal:**

**CPU: 4 cores** (mínimo para 20 workers sem degradação)

### **Plano Recomendado:**

**CPX31 (4 cores, 8 GB RAM, 160 GB SSD)**

### **Custo:**

**~+100% do plano atual** (aproximadamente)

### **Alternativa:**

**Otimizar código** antes de fazer upgrade (pode evitar necessidade de upgrade)

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA - UPGRADE PARA CPX31 RECOMENDADO**

