# ⚠️ ANÁLISE: Risco de Crash - Instalação Datadog Agent

**Data:** 25/11/2025  
**Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)  
**Contexto:** Análise de risco de crash durante/após instalação do Datadog Agent

---

## 📋 RESUMO EXECUTIVO

### **Risco de Crash: BAIXO a MÉDIO**

**Durante Instalação:**
- ✅ **Risco BAIXO** - Instalação é rápida e não consome muitos recursos
- ⚠️ **Risco MÉDIO** - Se servidor já estiver no limite, instalação pode causar problemas temporários

**Após Instalação:**
- ✅ **Risco BAIXO** - Datadog Agent consome ~100-200 MB RAM (aceitável)
- ⚠️ **Risco MÉDIO** - Se servidor já estiver com pouca RAM livre, pode impactar PHP-FPM

**Conclusão:**
- ✅ **Instalação é SEGURA** se servidor tiver > 500 MB RAM livre
- ⚠️ **CUIDADO** se servidor tiver < 500 MB RAM livre
- ✅ **Recomendação:** Verificar recursos disponíveis ANTES de instalar

---

## 🔍 ANÁLISE DETALHADA DE RISCOS

### **1. RISCO DE CRASH DURANTE INSTALAÇÃO**

#### **Cenários de Risco:**

**1.1. Falta de Espaço em Disco:**
- **Risco:** Instalação do Datadog Agent requer ~500 MB de espaço em disco
- **Impacto:** Instalação falha, mas NÃO causa crash do servidor
- **Mitigação:** Verificar espaço em disco antes de instalar
- **Probabilidade:** BAIXA (servidor geralmente tem espaço suficiente)

**1.2. Falta de Memória RAM Durante Instalação:**
- **Risco:** Processo de instalação pode usar ~200-300 MB RAM temporariamente
- **Impacto:** Se servidor já estiver no limite, pode causar:
  - OOM (Out of Memory) killer ativar
  - Processos serem encerrados (possivelmente PHP-FPM workers)
  - Servidor ficar lento temporariamente
- **Mitigação:** Verificar RAM livre antes de instalar, instalar em horário de baixo tráfego
- **Probabilidade:** MÉDIA (depende de recursos disponíveis)

**1.3. Falha na Conexão com Internet:**
- **Risco:** Script tenta baixar pacotes do Datadog
- **Impacto:** Instalação falha, mas NÃO causa crash
- **Mitigação:** Verificar conectividade antes de instalar
- **Probabilidade:** BAIXA (servidor tem internet)

**1.4. Conflito com Serviços Existentes:**
- **Risco:** Datadog pode conflitar com outros serviços de monitoramento
- **Impacto:** Serviços podem parar, mas NÃO causa crash do servidor
- **Mitigação:** Verificar se há outros agentes de monitoramento instalados
- **Probabilidade:** BAIXA (não há outros agentes conhecidos)

---

### **2. RISCO DE CRASH APÓS INSTALAÇÃO**

#### **Cenários de Risco:**

**2.1. Consumo de Memória RAM:**
- **Risco:** Datadog Agent consome ~100-200 MB RAM continuamente
- **Impacto:** Se servidor já estiver no limite:
  - PHP-FPM pode atingir `pm.max_children` mais rapidamente
  - OOM killer pode ativar e encerrar processos
  - Servidor pode ficar lento ou instável
- **Mitigação:** Verificar RAM livre antes de instalar, monitorar após instalação
- **Probabilidade:** MÉDIA (depende de recursos disponíveis)

**2.2. Consumo de CPU:**
- **Risco:** Datadog Agent consome ~0.1 cores (10% de 1 core)
- **Impacto:** Baixo impacto, mas pode afetar se CPU já estiver no limite
- **Mitigação:** Monitorar CPU após instalação
- **Probabilidade:** BAIXA (consumo é baixo)

**2.3. Consumo de Disco:**
- **Risco:** Logs do Datadog podem crescer se não configurados
- **Impacto:** Disco pode encher, causando problemas
- **Mitigação:** Configurar rotação de logs, monitorar espaço em disco
- **Probabilidade:** BAIXA (se logs forem configurados corretamente)

**2.4. Tráfego de Rede:**
- **Risco:** Datadog envia métricas continuamente para nuvem
- **Impacto:** Pode consumir largura de banda, mas não causa crash
- **Mitigação:** Monitorar tráfego de rede
- **Probabilidade:** BAIXA (tráfego é baixo)

---

## 📊 RECURSOS DO SERVIDOR DEV

### **Recursos Conhecidos (Estimativa):**

**Servidor DEV (`dev.bssegurosimediato.com.br`):**
- **CPU:** 2 cores (estimado)
- **RAM:** ~3-4 GB total (estimado)
- **RAM Disponível:** ~2-3 GB (estimado)
- **PHP-FPM Workers:** 5 workers (atual)
- **Uso de RAM PHP-FPM:** ~250 MB (5 workers × 50 MB)

### **Consumo Estimado Após Instalação:**

**Antes da Instalação:**
- Sistema Operacional: ~600 MB
- Nginx: ~50 MB
- PHP-FPM: ~250 MB
- MySQL/MariaDB: ~200 MB
- Outros serviços: ~100 MB
- **Total usado:** ~1.2 GB
- **RAM livre:** ~1.8-2.8 GB (estimado)

**Após Instalação do Datadog:**
- Datadog Agent: ~150 MB (média)
- **Total usado:** ~1.35 GB
- **RAM livre:** ~1.65-2.65 GB (estimado)

**Análise:**
- ✅ **RAM livre suficiente** para Datadog Agent
- ✅ **Risco de crash BAIXO** se servidor tiver > 1 GB RAM livre
- ⚠️ **Risco de crash MÉDIO** se servidor tiver < 1 GB RAM livre

---

## ⚠️ CENÁRIOS DE RISCO

### **Cenário 1: Servidor com Recursos Adequados (> 1 GB RAM livre)**

**Risco de Crash:** ✅ **BAIXO**

**Motivos:**
- ✅ RAM livre suficiente para Datadog Agent (~150 MB)
- ✅ CPU suficiente para Datadog Agent (~0.1 cores)
- ✅ Espaço em disco suficiente (~500 MB)

**Ação:**
- ✅ **Instalação SEGURA** - Pode prosseguir com instalação

---

### **Cenário 2: Servidor com Recursos Limitados (< 1 GB RAM livre)**

**Risco de Crash:** ⚠️ **MÉDIO**

**Motivos:**
- ⚠️ RAM livre pode não ser suficiente
- ⚠️ PHP-FPM pode atingir limite mais rapidamente
- ⚠️ OOM killer pode ativar

**Ação:**
- ⚠️ **Verificar recursos ANTES de instalar**
- ⚠️ **Considerar otimizar servidor primeiro** (limpar logs, otimizar PHP-FPM)
- ⚠️ **Instalar em horário de baixo tráfego**
- ⚠️ **Monitorar servidor durante e após instalação**

---

### **Cenário 3: Servidor no Limite Crítico (< 500 MB RAM livre)**

**Risco de Crash:** 🚨 **ALTO**

**Motivos:**
- 🚨 RAM livre insuficiente
- 🚨 Instalação pode causar OOM killer
- 🚨 Servidor pode ficar instável

**Ação:**
- 🚨 **NÃO instalar** até otimizar servidor
- 🚨 **Liberar RAM primeiro** (limpar logs, otimizar serviços)
- 🚨 **Considerar aumentar recursos do servidor**

---

## ✅ MITIGAÇÕES ESPECÍFICAS PARA EVITAR CRASH

### **1. Verificação Pré-Instalação (OBRIGATÓRIA):**

```bash
# Verificar RAM livre
free -h

# Verificar espaço em disco
df -h

# Verificar CPU disponível
top -bn1 | grep "Cpu(s)"

# Verificar processos usando mais RAM
ps aux --sort=-%mem | head -10
```

**Critérios de Segurança:**
- ✅ **RAM livre > 1 GB:** Instalação SEGURA
- ⚠️ **RAM livre 500 MB - 1 GB:** Instalação com CUIDADO
- 🚨 **RAM livre < 500 MB:** NÃO instalar até otimizar

---

### **2. Instalação em Horário de Baixo Tráfego:**

**Recomendação:**
- ✅ Instalar em horário de menor uso do servidor
- ✅ Evitar horários de pico de tráfego
- ✅ Monitorar servidor durante instalação

---

### **3. Monitoramento Durante Instalação:**

**Comandos para Monitorar:**
```bash
# Em uma sessão SSH separada, monitorar recursos
watch -n 1 'free -h && echo "---" && df -h && echo "---" && ps aux --sort=-%mem | head -5'
```

**O que Observar:**
- ⚠️ RAM livre diminuindo rapidamente
- ⚠️ CPU aumentando muito
- ⚠️ Espaço em disco diminuindo
- ⚠️ Processos sendo encerrados (OOM killer)

---

### **4. Configuração Otimizada do Datadog:**

**Após Instalação, Configurar:**

```yaml
# /etc/datadog-agent/datadog.yaml
# Limitar consumo de recursos
process_config:
  enabled: false  # Desabilitar monitoramento de processos (economiza RAM)

logs_enabled: false  # Desabilitar coleta de logs (economiza RAM e disco)

apm_config:
  enabled: true  # Manter APM habilitado (necessário para PHP)
  max_traces_per_second: 10  # Limitar traces (economiza recursos)
```

**Benefícios:**
- ✅ Reduz consumo de RAM (~50-100 MB)
- ✅ Reduz consumo de disco (menos logs)
- ✅ Mantém funcionalidades essenciais (métricas + APM)

---

### **5. Plano de Rollback (Se Necessário):**

**Se Servidor Ficar Instável:**

```bash
# Parar serviço Datadog
systemctl stop datadog-agent

# Desabilitar serviço
systemctl disable datadog-agent

# Remover Datadog (se necessário)
apt remove --purge datadog-agent -y
apt autoremove -y
```

**Tempo de Rollback:** ~5 minutos

---

## 📊 COMPARAÇÃO: Datadog vs Prometheus + Grafana

### **Consumo de Recursos:**

| Solução | RAM | CPU | Disco | Risco de Crash |
|---------|-----|-----|-------|----------------|
| **Datadog Agent** | 100-200 MB | 0.1 cores | 500 MB | ✅ **BAIXO** |
| **Prometheus + Grafana** | 500-1000 MB | 0.15-0.3 cores | 6-18 GB | ⚠️ **MÉDIO** |

**Conclusão:**
- ✅ **Datadog é MAIS SEGURO** que Prometheus + Grafana (consome menos recursos)
- ✅ **Risco de crash MENOR** com Datadog
- ✅ **Melhor escolha** para servidor com recursos limitados

---

## ✅ CHECKLIST DE SEGURANÇA

### **Antes de Instalar (OBRIGATÓRIO):**

- [ ] Verificar RAM livre: `free -h` (deve ter > 1 GB livre)
- [ ] Verificar espaço em disco: `df -h` (deve ter > 1 GB livre)
- [ ] Verificar CPU disponível: `top` (deve ter < 80% uso)
- [ ] Verificar processos usando mais RAM: `ps aux --sort=-%mem | head -10`
- [ ] Escolher horário de baixo tráfego para instalação
- [ ] Preparar sessão SSH separada para monitoramento

### **Durante Instalação:**

- [ ] Monitorar RAM livre continuamente
- [ ] Monitorar CPU continuamente
- [ ] Monitorar espaço em disco continuamente
- [ ] Observar se processos estão sendo encerrados (OOM killer)
- [ ] Se RAM livre < 500 MB, PARAR instalação

### **Após Instalação:**

- [ ] Verificar status do serviço: `systemctl status datadog-agent`
- [ ] Verificar consumo de RAM: `ps aux | grep datadog`
- [ ] Verificar que PHP-FPM continua funcionando normalmente
- [ ] Monitorar servidor por 1-2 horas após instalação
- [ ] Configurar otimizações do Datadog (se necessário)

---

## 🚨 ALERTAS CRÍTICOS

### **Sinais de Alerta (PARAR Instalação Imediatamente):**

1. 🚨 **RAM livre < 500 MB** durante instalação
2. 🚨 **CPU > 90%** por mais de 5 minutos
3. 🚨 **Processos sendo encerrados** (OOM killer ativo)
4. 🚨 **PHP-FPM workers sendo encerrados**
5. 🚨 **Servidor ficando lento ou não responsivo**

**Ação Imediata:**
- 🚨 **PARAR instalação** (Ctrl+C)
- 🚨 **Verificar recursos do servidor**
- 🚨 **Otimizar servidor antes de tentar novamente**

---

## ✅ CONCLUSÃO

### **Risco de Crash: BAIXO a MÉDIO**

**Durante Instalação:**
- ✅ **Risco BAIXO** se servidor tiver > 1 GB RAM livre
- ⚠️ **Risco MÉDIO** se servidor tiver < 1 GB RAM livre

**Após Instalação:**
- ✅ **Risco BAIXO** - Datadog consome ~150 MB RAM (aceitável)
- ⚠️ **Risco MÉDIO** se servidor já estiver no limite

### **Recomendação:**

**✅ Instalação é SEGURA se:**
- RAM livre > 1 GB
- Espaço em disco > 1 GB
- CPU < 80% uso

**⚠️ Instalação com CUIDADO se:**
- RAM livre 500 MB - 1 GB
- Espaço em disco 500 MB - 1 GB
- CPU 80-90% uso

**🚨 NÃO instalar se:**
- RAM livre < 500 MB
- Espaço em disco < 500 MB
- CPU > 90% uso

### **Ação Recomendada:**

**ANTES de instalar, executar verificação obrigatória:**
```bash
# Verificar recursos do servidor
ssh root@65.108.156.14 "free -h && echo '---' && df -h && echo '---' && top -bn1 | grep 'Cpu(s)'"
```

**Se recursos forem adequados (> 1 GB RAM livre):**
- ✅ **Prosseguir com instalação** seguindo planejamento

**Se recursos forem limitados (< 1 GB RAM livre):**
- ⚠️ **Otimizar servidor primeiro** ou **considerar aumentar recursos**

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA - RISCOS IDENTIFICADOS E MITIGADOS**

