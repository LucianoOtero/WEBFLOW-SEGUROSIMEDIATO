# 🔍 REAVALIAÇÃO: I/O Wait Alto em CPX31 com NVMe

**Data:** 25/11/2025  
**Servidor:** `flyingdonkeys.com.br` (37.27.1.242)  
**Plano Atual:** **CPX31** (já tem NVMe)  
**Problema:** I/O Wait alto (9-18%) mesmo com NVMe

---

## ⚠️ DESCOBERTA IMPORTANTE

**Servidor já é CPX31:**
- ✅ **CPU:** 4 cores
- ✅ **RAM:** 7.6 GB (deve ser 16 GB - verificar)
- ✅ **Disco:** NVMe (já incluído no CPX31)
- ⚠️ **I/O Wait:** 9-18% (ALTO mesmo com NVMe)

**Conclusão:** O problema **NÃO é disco lento**. NVMe já está presente.

---

## 🔍 NOVAS CAUSAS POSSÍVEIS

Se o servidor já tem NVMe e I/O wait está alto, as causas podem ser:

### **1. Queries Lentas do Banco de Dados**

**Sintomas:**
- Muitas queries simultâneas
- Queries sem índices adequados
- Queries fazendo full table scan
- Locks de tabela

**Como verificar:**
```bash
# Verificar queries lentas (requer acesso MySQL)
docker exec espocrm-db mysql -uroot -p -e "SHOW PROCESSLIST;"
docker exec espocrm-db mysql -uroot -p -e "SHOW ENGINE INNODB STATUS\G"
```

**Solução:**
- Otimizar queries
- Adicionar índices
- Verificar locks

---

### **2. Muitas Operações de I/O Simultâneas**

**Sintomas:**
- Muitos processos acessando disco ao mesmo tempo
- Logs sendo escritos constantemente
- Cache do sistema insuficiente

**Como verificar:**
```bash
# Verificar processos com maior I/O
iotop
# ou
iostat -x 1 5
```

**Solução:**
- Reduzir frequência de logs
- Aumentar cache do sistema
- Otimizar operações de escrita

---

### **3. Configuração Inadequada do MySQL/MariaDB**

**Sintomas:**
- Buffer pool muito pequeno
- Cache insuficiente
- Configurações não otimizadas para NVMe

**Como verificar:**
```bash
# Verificar configuração do MySQL
docker exec espocrm-db mysql -uroot -p -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';"
docker exec espocrm-db mysql -uroot -p -e "SHOW VARIABLES LIKE 'innodb_log_file_size';"
```

**Solução:**
- Aumentar buffer pool
- Otimizar configurações para NVMe
- Ajustar cache

---

### **4. Logs Muito Grandes (140 MB/dia)**

**Sintomas:**
- Logs sendo escritos constantemente
- Muitas operações de escrita em disco
- I/O wait alto durante escrita de logs

**Solução:**
- Implementar rotação de logs
- Reduzir nível de log (se aplicável)
- Limpar logs antigos

---

### **5. Container Docker com I/O Alto**

**Sintomas:**
- Container espocrm-daemon com CPU alto (11.79%)
- Muitas operações de I/O do container

**Solução:**
- Verificar o que o daemon está fazendo
- Otimizar processos do container

---

## 📊 ANÁLISE: Por que I/O Wait Alto com NVMe?

### **NVMe vs I/O Wait:**

**NVMe é rápido, mas:**
- ⚠️ I/O wait alto pode ocorrer mesmo com NVMe se:
  - Há muitas operações simultâneas
  - Queries do banco são lentas
  - Cache é insuficiente
  - Configurações não estão otimizadas

**I/O Wait não é apenas velocidade do disco:**
- É também sobre **quantidade** de operações
- É sobre **eficiência** das operações
- É sobre **configuração** do sistema

---

## 🎯 PRÓXIMOS PASSOS DE INVESTIGAÇÃO

### **1. Verificar Queries do Banco de Dados**

```bash
# Verificar queries ativas
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW PROCESSLIST;" 2>/dev/null

# Verificar queries lentas (se log estiver habilitado)
docker exec espocrm-db cat /var/log/mysql/slow-query.log 2>/dev/null | tail -50
```

---

### **2. Verificar Configuração do MySQL**

```bash
# Verificar buffer pool
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';" 2>/dev/null

# Verificar outras configurações importantes
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb%';" 2>/dev/null | head -20
```

---

### **3. Verificar Processos com Maior I/O**

```bash
# Verificar processos com I/O
ssh espo@37.27.1.242 "iotop -o -d 1 -n 5 2>/dev/null || echo 'iotop não disponível'"
```

---

### **4. Verificar Logs do EspoCRM**

```bash
# Verificar tamanho e frequência de escrita
ssh espo@37.27.1.242 "ls -lh /var/www/espocrm/data/logs/ && echo '---' && tail -f /var/www/espocrm/data/logs/espo-$(date +%Y-%m-%d).log | head -20"
```

---

## 💡 SOLUÇÕES PROPOSTAS

### **Solução 1: Otimizar MySQL/MariaDB**

**Ações:**
1. Aumentar `innodb_buffer_pool_size` (se muito pequeno)
2. Otimizar configurações para NVMe
3. Verificar e otimizar queries lentas
4. Adicionar índices onde necessário

**Impacto esperado:** Redução de I/O wait para 5-10%

---

### **Solução 2: Implementar Rotação de Logs**

**Ações:**
1. Configurar rotação automática de logs
2. Limpar logs antigos
3. Reduzir frequência de escrita

**Impacto esperado:** Redução parcial de I/O wait

---

### **Solução 3: Otimizar Container espocrm-daemon**

**Ações:**
1. Verificar o que o daemon está processando
2. Otimizar processos em background
3. Reduzir carga do daemon

**Impacto esperado:** Redução de CPU e possível I/O

---

## 📋 CHECKLIST DE INVESTIGAÇÃO

- [ ] Verificar queries lentas do banco de dados
- [ ] Verificar configuração do MySQL/MariaDB
- [ ] Verificar processos com maior I/O
- [ ] Verificar frequência de escrita de logs
- [ ] Verificar o que o container espocrm-daemon está fazendo
- [ ] Identificar causa raiz do I/O wait alto

---

## ⚠️ CONCLUSÃO

**Servidor já tem NVMe (CPX31):**
- ✅ Disco não é o problema
- ⚠️ I/O wait alto tem outra causa

**Causas mais prováveis:**
1. Queries lentas do banco de dados
2. Configuração inadequada do MySQL
3. Muitas operações de I/O simultâneas
4. Logs sendo escritos constantemente

**Próximo passo:** Investigar queries do banco de dados e configuração do MySQL.

---

**Documento criado em:** 25/11/2025  
**Status:** 🔍 **REAVALIAÇÃO CONCLUÍDA - NOVAS CAUSAS IDENTIFICADAS**

