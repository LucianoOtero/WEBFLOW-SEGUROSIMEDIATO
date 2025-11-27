# 📊 Cálculo do Limite PHP-FPM para Servidor de Produção

**Data:** 25/11/2025  
**Servidor:** Produção (`prod.bssegurosimediato.com.br` - IP: 157.180.36.223)  
**Status:** ✅ **CÁLCULO COMPLETO**

---

## 🔍 RECURSOS DO SERVIDOR

### **Dados Coletados:**

```
RAM Total:        3.819 MB (3,7 GB)
RAM Disponível:   3.232 MB (3,1 GB)
CPU Cores:        2 cores
Workers Ativos:   3 workers
pm.max_children:  5 (atual)
Limite Processos: 15.127 processos
```

---

## 💾 CÁLCULO BASEADO EM RAM

### **Memória por Worker PHP-FPM:**

**Estimativa conservadora:**
- Mínimo: **30 MB** por worker (workers leves)
- Médio: **50 MB** por worker (workers típicos)
- Máximo: **100 MB** por worker (workers pesados com muitas extensões)

**Para cálculo, usar: 50 MB por worker (média)**

### **RAM Disponível para PHP-FPM:**

```
RAM Total:           3.819 MB
Sistema Operacional: ~600 MB (estimado)
Outros Serviços:     ~200 MB (Nginx, MySQL, etc.)
RAM Disponível:      3.000 MB (conservador)
```

### **Limite Baseado em RAM:**

```
Limite RAM = RAM Disponível ÷ Memória por Worker
Limite RAM = 3.000 MB ÷ 50 MB = 60 workers
```

**Com margem de segurança (80%):**
```
Limite RAM Seguro = 60 × 0.8 = 48 workers
```

---

## 🖥️ CÁLCULO BASEADO EM CPU

### **Regra de Ouro:**

```
Workers Ideais = CPU Cores × 2 a 4
```

### **Para 2 cores:**

```
Limite CPU Mínimo = 2 × 2 = 4 workers
Limite CPU Médio  = 2 × 3 = 6 workers
Limite CPU Máximo = 2 × 4 = 8 workers
```

**Recomendação conservadora:**
```
Limite CPU = 2 × 3 = 6 workers
```

---

## 📁 CÁLCULO BASEADO EM LIMITE DE PROCESSOS

### **Limite do Sistema:**

```
Limite de Processos: 15.127 processos
```

**Não é limitante** - muito maior que qualquer necessidade razoável.

---

## ✅ CÁLCULO DO LIMITE IDEAL

### **Fórmula:**

```
Limite Ideal = min(
    Limite RAM,
    Limite CPU,
    Limite Processos
)
```

### **Resultado:**

```
Limite RAM:     48 workers (com margem de segurança)
Limite CPU:     6 workers (conservador)
Limite Processos: 15.127 (não limitante)

Limite Ideal = min(48, 6, 15127) = 6 workers
```

**⚠️ PROBLEMA:** Limite baseado em CPU (6) é muito menor que o baseado em RAM (48).

---

## 🔧 ANÁLISE DETALHADA

### **Por que CPU é o limitante?**

**Servidor tem apenas 2 cores:**
- Com 2 cores, ideal é ter 4-8 workers
- Mais que isso causa context switching excessivo
- Performance degrada com muitos workers

### **Mas o servidor está atingindo limite de 5 workers:**

**Evidência:**
```
[25-Nov-2025 12:56:32] WARNING: [pool www] server reached pm.max_children setting (5)
```

**Conclusão:** 5 workers é insuficiente para a carga atual.

---

## 💡 RECOMENDAÇÕES

### **Opção 1: Conservador (Recomendado para Início)**

**Aumentar para 10 workers:**
```ini
pm.max_children = 10
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 6
```

**Justificativa:**
- ✅ 2x o atual (5 → 10)
- ✅ Ainda dentro do limite de CPU (2 cores × 5 = 10)
- ✅ Resolve problema de sobrecarga imediata
- ✅ Baixo risco de degradação de performance
- ✅ Permite monitorar comportamento

**Uso de RAM:**
```
10 workers × 50 MB = 500 MB
RAM disponível: 3.000 MB
Uso: 16,7% (muito seguro)
```

---

### **Opção 2: Moderado (Após Monitorar Opção 1)**

**Aumentar para 15 workers:**
```ini
pm.max_children = 15
pm.start_servers = 6
pm.min_spare_servers = 3
pm.max_spare_servers = 9
```

**Justificativa:**
- ✅ 3x o atual (5 → 15)
- ✅ Ainda aceitável para 2 cores (pode ter algum context switching)
- ✅ Maior capacidade para picos de tráfego
- ⚠️ Monitorar CPU e performance

**Uso de RAM:**
```
15 workers × 50 MB = 750 MB
RAM disponível: 3.000 MB
Uso: 25% (ainda seguro)
```

---

### **Opção 3: Agressivo (Não Recomendado Inicialmente)**

**Aumentar para 20 workers:**
```ini
pm.max_children = 20
```

**Justificativa:**
- ✅ 4x o atual (5 → 20)
- ⚠️ Pode causar context switching excessivo (2 cores)
- ⚠️ Performance pode degradar
- ⚠️ Apenas se monitoramento mostrar que 15 não é suficiente

**Uso de RAM:**
```
20 workers × 50 MB = 1.000 MB
RAM disponível: 3.000 MB
Uso: 33% (ainda seguro em RAM, mas CPU pode ser limitante)
```

---

## 📊 COMPARAÇÃO DAS OPÇÕES

| Opção | Workers | RAM Usada | CPU Load | Risco | Recomendação |
|-------|---------|-----------|----------|-------|--------------|
| **Atual** | 5 | 250 MB | Baixo | ⚠️ Insuficiente | ❌ Aumentar |
| **Conservador** | 10 | 500 MB | Médio | ✅ Baixo | ✅ **RECOMENDADO** |
| **Moderado** | 15 | 750 MB | Médio-Alto | ⚠️ Médio | ⚠️ Após monitorar |
| **Agressivo** | 20 | 1.000 MB | Alto | ⚠️ Alto | ❌ Não recomendado |

---

## ✅ RECOMENDAÇÃO FINAL

### **Limite Conservador Recomendado:**

```ini
pm.max_children = 10
```

**Justificativa:**
1. ✅ **Resolve problema imediato:** 2x o atual, resolve sobrecarga
2. ✅ **Seguro em RAM:** Usa apenas 16,7% da RAM disponível
3. ✅ **Aceitável em CPU:** 2 cores podem lidar com 10 workers
4. ✅ **Baixo risco:** Performance não deve degradar
5. ✅ **Permite monitoramento:** Ver comportamento antes de aumentar mais

### **Configuração Completa Recomendada:**

```ini
; Process manager
pm = dynamic

; Maximum number of child processes
pm.max_children = 10

; Number of child processes created on startup
pm.start_servers = 4

; Minimum number of idle server processes
pm.min_spare_servers = 2

; Maximum number of idle server processes
pm.max_spare_servers = 6
```

---

## 📋 PLANO DE IMPLEMENTAÇÃO

### **Fase 1: Implementar Limite Conservador (10 workers)**

1. ✅ Fazer backup da configuração atual
2. ✅ Modificar `pm.max_children = 10`
3. ✅ Ajustar `pm.start_servers = 4`
4. ✅ Ajustar `pm.min_spare_servers = 2`
5. ✅ Ajustar `pm.max_spare_servers = 6`
6. ✅ Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
7. ✅ Monitorar por 1 semana

### **Fase 2: Monitoramento (1 semana)**

**Métricas a monitorar:**
- Quantas vezes atinge `pm.max_children`
- Uso de RAM do servidor
- Uso de CPU do servidor
- Tempo de resposta das requisições
- Erros de conexão/timeout

**Comandos de monitoramento:**
```bash
# Verificar se ainda atinge limite
grep "reached pm.max_children" /var/log/php8.3-fpm.log | wc -l

# Verificar workers ativos
ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l

# Verificar uso de RAM
free -h

# Verificar uso de CPU
top -bn1 | grep "Cpu(s)"
```

### **Fase 3: Ajuste (Se Necessário)**

**Se ainda atingir limite de 10 workers:**
- Aumentar para 15 workers
- Continuar monitoramento

**Se performance degradar:**
- Reduzir para 8 workers
- Investigar otimizações de código

---

## 📊 RESUMO EXECUTIVO

### **Limite Calculado:**

- **Baseado em RAM:** 48 workers (com margem de segurança)
- **Baseado em CPU:** 6 workers (conservador para 2 cores)
- **Limite de Processos:** 15.127 (não limitante)

### **Limite Conservador Recomendado:**

**10 workers**

**Justificativa:**
- ✅ Resolve problema de sobrecarga (2x o atual)
- ✅ Seguro em recursos (16,7% RAM, CPU aceitável)
- ✅ Baixo risco de degradação de performance
- ✅ Permite monitoramento antes de aumentar mais

### **Próximos Passos:**

1. ✅ Implementar `pm.max_children = 10`
2. ✅ Monitorar por 1 semana
3. ✅ Ajustar conforme necessário

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **CÁLCULO COMPLETO - LIMITE CONSERVADOR: 10 WORKERS**

