# 🔧 Solução: Timeout SSH em dev.flyingdonkeys.com.br

**Data:** 25/11/2025  
**Problema:** Timeout na porta 22 após adicionar chave SSH  
**Causa Provável:** Firewall ou servidor não acessível via IP público

---

## 🔍 DIAGNÓSTICO

### **Problema:**
- ✅ Chave SSH adicionada com sucesso
- ❌ Timeout na porta 22 (conectividade, não autenticação)
- ⚠️ Servidor pode estar com firewall bloqueando ou sem acesso público

---

## ✅ SOLUÇÕES

### **SOLUÇÃO 1: Verificar IP Público do Servidor**

**Via Painel Hetzner:**
1. Acessar painel Hetzner Cloud
2. Selecionar servidor `dev.flyingdonkeys.com.br`
3. Verificar IP público listado
4. Tentar conectar diretamente pelo IP:
   ```bash
   ssh root@[IP_PUBLICO]
   ```

---

### **SOLUÇÃO 2: Verificar Firewall (via Console Hetzner)**

**Se servidor tem console web:**
1. Acessar console do servidor via painel Hetzner
2. Verificar firewall:
   ```bash
   # Verificar se firewall está bloqueando
   ufw status
   # OU
   iptables -L -n
   
   # Se necessário, liberar porta 22
   ufw allow 22/tcp
   # OU
   iptables -A INPUT -p tcp --dport 22 -j ACCEPT
   ```

---

### **SOLUÇÃO 3: Acessar via Console Hetzner (Recomendado)**

**Via Painel Hetzner Cloud:**
1. Acessar painel Hetzner Cloud
2. Selecionar servidor `dev.flyingdonkeys.com.br`
3. Clicar em "Console" ou "VNC Console"
4. Acessar servidor via console web
5. Executar comandos diretamente no console

**Vantagens:**
- ✅ Não depende de SSH
- ✅ Funciona mesmo com firewall bloqueado
- ✅ Permite configurar firewall/SSH

---

### **SOLUÇÃO 4: Configurar Firewall via Console**

**Se conseguir acessar via console, executar:**

```bash
# Verificar status do firewall
ufw status verbose

# Se firewall estiver ativo e bloqueando, liberar porta 22
ufw allow 22/tcp
ufw reload

# OU se usar iptables diretamente
iptables -I INPUT -p tcp --dport 22 -j ACCEPT
iptables-save > /etc/iptables/rules.v4  # Salvar regras
```

---

### **SOLUÇÃO 5: Verificar se Servidor está Acessível**

**Testar conectividade:**
```bash
# Testar ping (se ICMP não estiver bloqueado)
ping dev.flyingdonkeys.com.br

# Testar porta 22
telnet dev.flyingdonkeys.com.br 22
# OU
nc -zv dev.flyingdonkeys.com.br 22
```

---

### **SOLUÇÃO 6: Usar IP Privado (se estiver na mesma rede)**

**Se você estiver acessando de outro servidor Hetzner na mesma rede privada:**
```bash
# Tentar via IP privado (se estiver na mesma rede)
ssh root@10.0.0.2
```

**⚠️ NOTA:** Isso só funciona se você estiver acessando de dentro da rede privada Hetzner.

---

## 🎯 RECOMENDAÇÃO

### **Passo a Passo Recomendado:**

1. **Acessar Console Hetzner:**
   - Painel Hetzner → Servidor → Console
   - Acessar servidor via console web

2. **Verificar Firewall:**
   ```bash
   ufw status
   ```

3. **Liberar Porta 22 (se necessário):**
   ```bash
   ufw allow 22/tcp
   ufw reload
   ```

4. **Verificar SSH está rodando:**
   ```bash
   systemctl status ssh
   # OU
   systemctl status sshd
   ```

5. **Se SSH não estiver rodando, iniciar:**
   ```bash
   systemctl start ssh
   systemctl enable ssh
   ```

6. **Testar conexão novamente:**
   ```bash
   # Do seu computador local
   ssh root@dev.flyingdonkeys.com.br
   # OU
   ssh root@[IP_PUBLICO]
   ```

---

## 📋 CHECKLIST DE VERIFICAÇÃO

- [ ] Verificar IP público do servidor no painel Hetzner
- [ ] Acessar console do servidor via painel Hetzner
- [ ] Verificar se firewall está bloqueando porta 22
- [ ] Verificar se serviço SSH está rodando
- [ ] Liberar porta 22 no firewall (se necessário)
- [ ] Testar conexão SSH novamente

---

## ⚠️ ALTERNATIVA: Implementação via Console

**Se não conseguir resolver SSH, posso criar um script para você executar via console Hetzner:**

1. Acessar console do servidor
2. Executar script de implementação do Datadog
3. Validar implementação

**Me avise se prefere essa abordagem!**

---

**Após resolver o acesso SSH, me avise para continuar com a implementação do Datadog!**

