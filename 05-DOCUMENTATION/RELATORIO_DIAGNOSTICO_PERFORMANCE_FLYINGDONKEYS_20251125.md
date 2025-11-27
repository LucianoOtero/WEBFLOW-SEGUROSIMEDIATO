# 🔍 RELATÓRIO DE DIAGNÓSTICO: Performance Servidor FlyingDonkeys

**Data:** 25/11/2025 13:22  
**Servidor:** `flyingdonkeys.com.br` (37.27.1.242)  
**Usuário:** `espo@37.27.1.242`  
**Status:** 🔍 **INVESTIGAÇÃO CONCLUÍDA - APENAS LEITURA**

---

## 📊 RESUMO EXECUTIVO

### **Problemas Identificados:**

1. ⚠️ **I/O Wait Alto (9-18%)** - Gargalo de disco identificado
2. ⚠️ **Logs do EspoCRM Muito Grandes (98-143MB/dia)** - Pode impactar performance
3. ⚠️ **Container espocrm-daemon com CPU Alto (11.79%)** - Acima da média
4. ⚠️ **Nginx do Sistema Falhado** - Mas Nginx do Docker está funcionando
5. ✅ **Recursos de Sistema OK** - CPU, RAM, Disco com espaço adequado

---

## 🖥️ ESPECIFICAÇÕES DO SERVIDOR

| Item | Valor |
|------|-------|
| **IP Público** | `37.27.1.242` |
| **Uptime** | 48 dias, 6 horas |
| **CPU** | 4 cores (AMD EPYC-Rome Processor) |
| **RAM Total** | 7.6 GB |
| **RAM Usada** | 2.0 GB (26%) |
| **RAM Disponível** | 5.6 GB (74%) |
| **Swap** | 4.0 GB (1.2 MB usado) |
| **Disco Principal** | 150 GB (15% usado - 22 GB / 123 GB livre) |
| **Disco Dados** | 196 GB (1% usado - 32 KB / 186 GB livre) |
| **Load Average** | 0.52, 0.53, 0.54 (normal para 4 cores) |

---

## 🔍 ANÁLISE DETALHADA

### **1. CPU E MEMÓRIA**

**Status:** ✅ **NORMAL**

- **Load Average:** 0.52, 0.53, 0.54 (normal para 4 cores)
- **CPU Idle:** 74-85% (boa margem)
- **Memória:** 26% usada (2.0 GB / 7.6 GB)
- **Swap:** Praticamente não usado (1.2 MB)

**Top Processos por CPU:**
- `mariadbd` (PID 197451): 17.4% CPU, 9.7% RAM (773 MB)
- `espo` (systemd user): 10.3% CPU (temporário)
- `php cron.php`: 1.3% CPU

**Top Processos por Memória:**
- `mariadbd` (PID 197451): 773 MB
- `mysql` (PID 91690): 342 MB
- `dockerd`: 48 MB

**Conclusão:** CPU e memória estão saudáveis, sem problemas de recursos.

---

### **2. DISCO E I/O**

**Status:** ⚠️ **PROBLEMA IDENTIFICADO**

**I/O Wait:**
- **Média:** 9-18% (ALTO - ideal < 5%)
- **Leitura:** 1,200-2,700 ops/s
- **Escrita:** 15-289 ops/s
- **Utilização do Disco:** 36-75%

**Espaço em Disco:**
- ✅ Disco principal: 15% usado (123 GB livres)
- ✅ Disco dados: 1% usado (186 GB livres)
- ✅ Inodes: 2% usado (9.5M livres)

**Análise:**
- ⚠️ **I/O wait alto indica gargalo de disco**
- ⚠️ **Disco está sendo muito utilizado (36-75% de utilização)**
- ⚠️ **Pode estar causando lentidão em operações de banco de dados**

**Possíveis Causas:**
1. Logs do EspoCRM muito grandes (98-143MB/dia)
2. Queries do banco de dados com muitas operações de I/O
3. Cache do sistema/espaço de swap em disco
4. Operações de backup ou sincronização

**Recomendação:** Investigar queries lentas do banco de dados e considerar otimização de logs.

---

### **3. SERVIÇOS E CONTAINERS DOCKER**

**Status:** ⚠️ **MISTO (Alguns problemas)**

#### **3.1. Containers Docker**

| Container | CPU % | RAM | Status |
|-----------|-------|-----|--------|
| `espocrm-nginx` | 0.61% | 16.73 MB | ✅ OK |
| `espocrm` | 0.42% | 153.6 MB | ✅ OK |
| `espocrm-websocket` | 0.00% | 19.31 MB | ✅ OK |
| `espocrm-daemon` | **11.79%** | 125.6 MB | ⚠️ **CPU ALTO** |
| `espocrm-db` | 0.56% | 752 MB | ✅ OK |

**Análise:**
- ⚠️ **Container `espocrm-daemon` está usando 11.79% CPU** (acima da média dos outros containers)
- ✅ Outros containers estão com uso normal de recursos
- ✅ MariaDB está usando 752 MB de RAM (normal para banco de dados)

#### **3.2. Nginx**

**Status:** ⚠️ **PROBLEMA IDENTIFICADO**

- **Nginx do Sistema (systemd):** ❌ **FALHADO** desde 13/11/2025
  - Erro: Não consegue ler certificado SSL (`/etc/letsencrypt/live/flyingdonkeys.com.br/fullchain.pem`)
  - Erro: "Permission denied"
  - **Mas:** Nginx do Docker está funcionando normalmente

- **Nginx do Docker:** ✅ **FUNCIONANDO**
  - Processo master: PID 198990
  - 4 workers rodando
  - Portas 80 e 443 abertas e funcionando

**Conclusão:** Nginx do sistema está falhado, mas o Nginx do Docker está funcionando. Isso não está causando problema imediato, mas pode ser um problema futuro se o Docker for reiniciado.

---

### **4. PHP-FPM**

**Status:** ✅ **FUNCIONANDO**

- **Serviço:** Ativo desde 02/11/2025 (3 semanas)
- **Workers:** 7 processos PHP-FPM rodando
- **Configuração:**
  - `pm.max_children = 5`
  - `pm.start_servers = 2`
  - `pm.min_spare_servers = 1`
  - `pm.max_spare_servers = 3`

**Análise:**
- ✅ PHP-FPM está funcionando normalmente
- ⚠️ Apenas 5 workers máximo (pode ser limitante em picos de tráfego)
- ✅ Não há evidência de workers esgotados

---

### **5. BANCO DE DADOS (MariaDB)**

**Status:** ⚠️ **NÃO FOI POSSÍVEL VERIFICAR COMPLETAMENTE**

- **Serviço:** Ativo desde 11/10/2025 (1 mês e 14 dias)
- **Processo Principal:** `mariadbd` (PID 197451) - 17.4% CPU, 773 MB RAM
- **Container Docker:** `espocrm-db` - 752 MB RAM

**Limitações da Investigação:**
- ❌ Não foi possível acessar MySQL diretamente (sem credenciais)
- ❌ Não foi possível verificar queries lentas
- ❌ Não foi possível verificar conexões ativas

**Observações:**
- ⚠️ MariaDB está usando bastante CPU (17.4%) - pode indicar queries pesadas
- ⚠️ 752 MB de RAM usado pelo container (normal, mas pode ser otimizado)

**Recomendação:** Verificar queries lentas e otimizar banco de dados.

---

### **6. LOGS DO ESPOCRM**

**Status:** ⚠️ **LOGS MUITO GRANDES**

**Tamanho dos Logs (últimos 7 dias):**
- 19/11: 142 MB
- 20/11: 141 MB
- 21/11: 142 MB
- 22/11: 140 MB
- 23/11: 140 MB
- 24/11: 143 MB
- 25/11: 98 MB (até 13:25)

**Análise:**
- ⚠️ **Logs estão gerando ~140 MB por dia** (muito alto!)
- ⚠️ **Em 30 dias = ~4.2 GB de logs**
- ⚠️ **Pode estar impactando I/O do disco**
- ⚠️ **Pode estar causando lentidão em operações de escrita**

**Recomendação:** 
1. Verificar nível de log do EspoCRM (pode estar em DEBUG/TRACE)
2. Implementar rotação de logs
3. Limpar logs antigos
4. Considerar reduzir nível de log para produção

---

### **7. REDE**

**Status:** ✅ **NORMAL**

- **Conexões Ativas:** 5 conexões TCP
- **Portas Abertas:** 80, 443, 8080
- **Nginx:** Muitas conexões WebSocket (normal para EspoCRM)

**Análise:**
- ✅ Rede está funcionando normalmente
- ✅ Muitas conexões WebSocket são esperadas (EspoCRM usa WebSocket para notificações em tempo real)
- ✅ Não há evidência de problemas de rede

---

## 🎯 PROBLEMAS IDENTIFICADOS E PRIORIDADES

### **🔴 ALTA PRIORIDADE**

1. **I/O Wait Alto (9-18%)**
   - **Impacto:** Pode causar lentidão em operações de banco de dados e escrita de logs
   - **Causa Provável:** Logs muito grandes + queries do banco de dados
   - **Recomendação:** 
     - Verificar queries lentas do banco de dados
     - Reduzir nível de log do EspoCRM
     - Implementar rotação de logs

2. **Logs do EspoCRM Muito Grandes (98-143MB/dia)**
   - **Impacto:** Alto uso de I/O, pode causar lentidão
   - **Causa Provável:** Nível de log muito alto (DEBUG/TRACE)
   - **Recomendação:**
     - Verificar configuração de log do EspoCRM
     - Reduzir para nível INFO ou WARNING em produção
     - Implementar rotação de logs

### **🟡 MÉDIA PRIORIDADE**

3. **Container espocrm-daemon com CPU Alto (11.79%)**
   - **Impacto:** Pode estar consumindo recursos desnecessários
   - **Causa Provável:** Processamento de tarefas em background
   - **Recomendação:** Verificar logs do container para identificar o que está sendo processado

4. **Nginx do Sistema Falhado**
   - **Impacto:** Baixo (Nginx do Docker está funcionando)
   - **Causa:** Permissão de leitura do certificado SSL
   - **Recomendação:** Corrigir permissões ou desabilitar serviço do sistema (já que Docker está funcionando)

### **🟢 BAIXA PRIORIDADE**

5. **PHP-FPM com apenas 5 workers**
   - **Impacto:** Pode ser limitante em picos de tráfego
   - **Recomendação:** Monitorar e aumentar se necessário

---

## 📋 RECOMENDAÇÕES

### **Imediatas (Sem Alterações no Servidor)**

1. ✅ **Monitorar I/O wait** - Verificar se está melhorando ou piorando
2. ✅ **Verificar logs do EspoCRM** - Identificar se há muitos erros ou warnings
3. ✅ **Verificar queries lentas do banco** - Se possível, com acesso ao MySQL

### **Curto Prazo (Requer Acesso Root ou Alterações)**

1. ⚠️ **Reduzir nível de log do EspoCRM** - De DEBUG/TRACE para INFO/WARNING
2. ⚠️ **Implementar rotação de logs** - Evitar logs muito grandes
3. ⚠️ **Limpar logs antigos** - Liberar espaço e reduzir I/O
4. ⚠️ **Otimizar queries do banco de dados** - Se houver queries lentas identificadas
5. ⚠️ **Corrigir Nginx do sistema** - Ou desabilitar se não for necessário

### **Médio Prazo**

1. ⚠️ **Considerar upgrade de disco** - Se I/O wait continuar alto
2. ⚠️ **Monitorar container espocrm-daemon** - Verificar se CPU alto é normal
3. ⚠️ **Ajustar PHP-FPM workers** - Se houver picos de tráfego

---

## 📊 MÉTRICAS COLETADAS

### **Sistema**
- Load Average: 0.52, 0.53, 0.54
- CPU Idle: 74-85%
- RAM Usada: 26% (2.0 GB / 7.6 GB)
- Swap: 1.2 MB usado

### **I/O**
- I/O Wait: 9-18% (ALTO)
- Leitura: 1,200-2,700 ops/s
- Escrita: 15-289 ops/s
- Utilização Disco: 36-75%

### **Containers Docker**
- espocrm-nginx: 0.61% CPU, 16.73 MB RAM
- espocrm: 0.42% CPU, 153.6 MB RAM
- espocrm-websocket: 0.00% CPU, 19.31 MB RAM
- espocrm-daemon: 11.79% CPU, 125.6 MB RAM ⚠️
- espocrm-db: 0.56% CPU, 752 MB RAM

### **Logs**
- Tamanho médio diário: ~140 MB
- Total estimado (30 dias): ~4.2 GB

---

## ⚠️ LIMITAÇÕES DA INVESTIGAÇÃO

1. ❌ **Sem acesso root** - Alguns comandos não puderam ser executados
2. ❌ **Sem credenciais MySQL** - Não foi possível verificar queries lentas
3. ❌ **Sem acesso a logs detalhados** - Alguns logs não puderam ser lidos
4. ❌ **Investigação apenas leitura** - Não foi possível testar correções

---

## 📝 PRÓXIMOS PASSOS SUGERIDOS

1. ✅ **Revisar este relatório** - Validar problemas identificados
2. ⚠️ **Verificar nível de log do EspoCRM** - Reduzir se necessário
3. ⚠️ **Implementar rotação de logs** - Evitar logs muito grandes
4. ⚠️ **Verificar queries lentas do banco** - Com acesso ao MySQL
5. ⚠️ **Monitorar I/O wait** - Verificar se melhora após correções

---

**Relatório gerado em:** 25/11/2025 13:25  
**Investigação realizada por:** Auto (Cursor AI)  
**Tipo:** Apenas leitura (sem alterações no servidor)

