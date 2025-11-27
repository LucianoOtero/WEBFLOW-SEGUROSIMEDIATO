# ✅ Upgrade Hetzner sem Reinstalar - Como Funciona

**Data:** 25/11/2025  
**Servidor:** Produção (`prod.bssegurosimediato.com.br`)  
**Status:** ✅ **PROCESSO DOCUMENTADO**

---

## 🎯 RESPOSTA DIRETA

**SIM, é possível fazer upgrade sem reinstalar!**

O Hetzner Cloud permite fazer **resize** (redimensionamento) do servidor que:
- ✅ **Preserva todos os dados**
- ✅ **Preserva todas as configurações**
- ✅ **Preserva todos os arquivos**
- ✅ **Não requer reinstalação**
- ✅ **Processo automático**

---

## 🔧 COMO FUNCIONA O RESIZE

### **O que acontece:**

1. **Hetzner aumenta recursos do servidor:**
   - CPU: 2 → 4 cores
   - RAM: 4 GB → 8 GB
   - Disco: 40 GB → 160 GB (se aplicável)

2. **Sistema operacional detecta novos recursos:**
   - Kernel reconhece novos cores de CPU
   - Sistema reconhece nova RAM
   - Disco é expandido automaticamente

3. **Servidor é reiniciado:**
   - Reinicialização automática
   - Todos os dados permanecem intactos
   - Configurações permanecem intactas

4. **Após reinicialização:**
   - Servidor volta online com novos recursos
   - Tudo funciona normalmente
   - Apenas mais recursos disponíveis

---

## 📋 PROCESSO PASSO A PASSO

### **Passo 1: Fazer Backup (Recomendado)**

**Mesmo que dados sejam preservados, backup é sempre recomendado:**

```bash
# Backup de configurações importantes
# (opcional, mas recomendado)

# Backup PHP-FPM
cp /etc/php/8.3/fpm/pool.d/www.conf /root/backup_www.conf

# Backup Nginx
cp /etc/nginx/sites-available/prod.bssegurosimediato.com.br /root/backup_nginx.conf

# Backup banco de dados (se aplicável)
mysqldump -u root -p rpa_logs_prod > /root/backup_db_$(date +%Y%m%d).sql
```

---

### **Passo 2: Acessar Hetzner Cloud Console**

1. Acessar: https://console.hetzner.cloud/
2. Fazer login
3. Selecionar projeto
4. Clicar no servidor de produção

---

### **Passo 3: Fazer Resize**

1. **Clicar em "Resize"** (ou "Redimensionar")
2. **Selecionar novo plano:** CPX31 (4 cores, 8 GB RAM)
3. **Confirmar upgrade**
4. **Aguardar processamento** (1-2 minutos)

**⚠️ IMPORTANTE:**
- Servidor será **reiniciado automaticamente**
- Pode levar 2-5 minutos para reiniciar
- Servidor ficará **indisponível durante reinicialização**

---

### **Passo 4: Aguardar Reinicialização**

**O que acontece:**
- Servidor desliga
- Hetzner ajusta recursos
- Servidor reinicia
- Sistema operacional detecta novos recursos
- Servidor volta online

**Tempo estimado:** 2-5 minutos

---

### **Passo 5: Verificar Após Reinicialização**

**Conectar via SSH e verificar:**

```bash
# Verificar CPU (deve mostrar 4 cores)
lscpu | grep "CPU(s)"

# Verificar RAM (deve mostrar 8 GB)
free -h

# Verificar disco (se foi expandido)
df -h

# Verificar se serviços estão rodando
systemctl status php8.3-fpm
systemctl status nginx
systemctl status mysql  # se aplicável
```

---

### **Passo 6: Ajustar Configuração PHP-FPM**

**Agora que tem 4 cores, pode aumentar workers:**

```bash
# Editar configuração
nano /etc/php/8.3/fpm/pool.d/www.conf

# Alterar:
pm.max_children = 20
pm.start_servers = 8
pm.min_spare_servers = 4
pm.max_spare_servers = 12

# Recarregar PHP-FPM (sem reiniciar servidor)
systemctl reload php8.3-fpm
```

---

## ⚠️ O QUE NÃO É PERDIDO

### **✅ Preservado:**

- ✅ Todos os arquivos em `/var/www/html/`
- ✅ Todas as configurações (Nginx, PHP-FPM, MySQL)
- ✅ Todos os bancos de dados
- ✅ Todos os logs
- ✅ Todas as variáveis de ambiente
- ✅ Todas as chaves SSH
- ✅ Todos os certificados SSL
- ✅ Todas as permissões de arquivos

### **❌ O que muda:**

- ❌ CPU: 2 → 4 cores (mais recursos)
- ❌ RAM: 4 GB → 8 GB (mais recursos)
- ❌ Disco: pode ser expandido (se aplicável)
- ❌ IP do servidor: **permanece o mesmo**

---

## 🔍 VERIFICAÇÕES PÓS-UPGRADE

### **1. Verificar Recursos**

```bash
# CPU
lscpu | grep "CPU(s)"
# Deve mostrar: CPU(s): 4

# RAM
free -h
# Deve mostrar: Mem: 8.0Gi (ou similar)

# Disco (se expandido)
df -h
# Verificar se disco foi expandido
```

### **2. Verificar Serviços**

```bash
# PHP-FPM
systemctl status php8.3-fpm
# Deve estar: active (running)

# Nginx
systemctl status nginx
# Deve estar: active (running)

# MySQL (se aplicável)
systemctl status mysql
# Deve estar: active (running)
```

### **3. Verificar Aplicação**

```bash
# Testar se site está respondendo
curl -I https://prod.bssegurosimediato.com.br

# Verificar logs de erro
tail -f /var/log/nginx/error.log
tail -f /var/log/php8.3-fpm.log
```

---

## ⏱️ TEMPO DE INDISPONIBILIDADE

### **Estimativa:**

- **Processamento do resize:** 1-2 minutos
- **Reinicialização do servidor:** 2-3 minutos
- **Total:** 3-5 minutos de indisponibilidade

### **Recomendações:**

1. ✅ **Fazer em horário de baixo tráfego** (madrugada, se possível)
2. ✅ **Avisar usuários** se necessário
3. ✅ **Ter plano de rollback** (pode fazer downgrade se necessário)

---

## 🔄 PODE FAZER DOWNGRADE?

**SIM, também é possível fazer downgrade:**

- Pode voltar para plano anterior se necessário
- Processo é o mesmo (resize)
- Dados também são preservados
- Mas recursos diminuem

**⚠️ ATENÇÃO:**
- Se aumentar workers para 20 e depois fazer downgrade para 2 cores
- Pode ter problemas de performance
- Ajustar `pm.max_children` antes de fazer downgrade

---

## 📋 CHECKLIST COMPLETO

### **Antes do Upgrade:**
- [ ] Fazer backup de configurações importantes
- [ ] Verificar horário de baixo tráfego
- [ ] Documentar configuração atual PHP-FPM
- [ ] Verificar espaço em disco disponível

### **Durante o Upgrade:**
- [ ] Acessar Hetzner Cloud Console
- [ ] Selecionar servidor
- [ ] Clicar em "Resize"
- [ ] Escolher CPX31
- [ ] Confirmar upgrade
- [ ] Aguardar reinicialização (3-5 minutos)

### **Após o Upgrade:**
- [ ] Verificar CPU (deve mostrar 4 cores)
- [ ] Verificar RAM (deve mostrar 8 GB)
- [ ] Verificar se serviços estão rodando
- [ ] Testar aplicação
- [ ] Ajustar `pm.max_children = 20`
- [ ] Recarregar PHP-FPM
- [ ] Monitorar performance por 24-48 horas

---

## ✅ RESUMO

### **Pergunta:** É possível fazer upgrade sem reinstalar?

**Resposta:** ✅ **SIM, totalmente possível!**

### **Como:**
1. Acessar Hetzner Cloud Console
2. Clicar em "Resize"
3. Escolher novo plano (CPX31)
4. Confirmar
5. Aguardar reinicialização (3-5 minutos)
6. Pronto! Todos os dados preservados

### **O que é preservado:**
- ✅ Todos os arquivos
- ✅ Todas as configurações
- ✅ Todos os bancos de dados
- ✅ Tudo permanece intacto

### **O que muda:**
- ✅ CPU: 2 → 4 cores
- ✅ RAM: 4 GB → 8 GB
- ✅ Mais recursos disponíveis

### **Tempo de indisponibilidade:**
- ⏱️ 3-5 minutos (apenas durante reinicialização)

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **PROCESSO DOCUMENTADO - UPGRADE SEM REINSTALAÇÃO É POSSÍVEL**

