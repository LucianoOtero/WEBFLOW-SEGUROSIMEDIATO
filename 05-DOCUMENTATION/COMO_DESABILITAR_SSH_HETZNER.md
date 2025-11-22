# 🔒 Como Desabilitar SSH no Hetzner

**Data:** 2025-11-18  
**Objetivo:** Explicar como desabilitar acesso SSH no servidor Hetzner

---

## ⚠️ ALERTA IMPORTANTE

**ATENÇÃO:** Desabilitar SSH completamente pode **bloquear seu acesso ao servidor**. Certifique-se de ter:
- ✅ Console de gerenciamento remoto (Hetzner Cloud Console)
- ✅ Acesso físico ao servidor (se aplicável)
- ✅ Outro método de acesso antes de desabilitar SSH

**Recomendação:** Em vez de desabilitar completamente, considere **restringir acesso por IP** ou usar **chaves SSH** (mais seguro).

---

## 🔧 OPÇÕES PARA DESABILITAR/RESTRINGIR SSH

### **OPÇÃO 1: Firewall do Hetzner Cloud Console (RECOMENDADO)**

**Como funciona:**
Bloqueia conexões SSH externas via firewall do Hetzner, mas mantém acesso via console.

**Passos:**

1. **Acessar Hetzner Cloud Console:**
   - URL: https://console.hetzner.com/
   - Login com suas credenciais

2. **Navegar para Firewalls:**
   - Menu lateral: **"Firewalls"**
   - Ou: **"Networking" → "Firewalls"**

3. **Criar ou Editar Firewall:**
   - Se já existe firewall aplicado ao servidor: **Editar**
   - Se não existe: **Criar novo firewall**

4. **Adicionar Regra de Bloqueio SSH:**
   - **Direção:** Inbound (Entrada)
   - **Protocolo:** TCP
   - **Porta:** 22 (porta padrão SSH)
   - **Ação:** **DENY** (Negar)
   - **Fonte:** 0.0.0.0/0 (todos os IPs) ou IPs específicos

5. **Aplicar Firewall ao Servidor:**
   - Selecionar servidor de produção (`157.180.36.223`)
   - Aplicar firewall

**Resultado:**
- ✅ Conexões SSH externas bloqueadas
- ✅ Acesso via Hetzner Cloud Console mantido
- ✅ Servidor ainda acessível para gerenciamento

**Vantagens:**
- ✅ Não requer acesso SSH para configurar
- ✅ Pode ser revertido facilmente via console
- ✅ Mantém acesso via console de gerenciamento

**Desvantagens:**
- ⚠️ Bloqueia todos os acessos SSH externos
- ⚠️ Você também não conseguirá acessar via SSH

---

### **OPÇÃO 2: Restringir SSH por IP (MAIS SEGURO)**

**Como funciona:**
Permite SSH apenas de IPs específicos (seu IP, escritório, etc.).

**Passos:**

1. **Via Firewall do Hetzner Cloud Console:**

   - Criar/editar firewall
   - **Regra 1 (Permitir seu IP):**
     - Direção: Inbound
     - Protocolo: TCP
     - Porta: 22
     - Ação: **ALLOW** (Permitir)
     - Fonte: Seu IP específico (ex: `123.45.67.89/32`)
   
   - **Regra 2 (Bloquear resto):**
     - Direção: Inbound
     - Protocolo: TCP
     - Porta: 22
     - Ação: **DENY** (Negar)
     - Fonte: 0.0.0.0/0 (todos os outros IPs)
   
   - **Importante:** Ordem das regras importa - regra de permissão deve vir ANTES da regra de bloqueio

2. **Via Firewall no Servidor (UFW):**

   ```bash
   # Conectar ao servidor primeiro
   ssh root@157.180.36.223
   
   # Remover regra geral de SSH
   sudo ufw delete allow ssh
   
   # Permitir apenas seu IP específico
   sudo ufw allow from SEU_IP_AQUI to any port 22
   
   # Verificar regras
   sudo ufw status numbered
   ```

**Resultado:**
- ✅ SSH permitido apenas do seu IP
- ✅ Todos os outros IPs bloqueados
- ✅ Mais seguro que desabilitar completamente

**Vantagens:**
- ✅ Mantém acesso SSH do seu IP
- ✅ Bloqueia acessos não autorizados
- ✅ Mais seguro que desabilitar completamente

**Desvantagens:**
- ⚠️ Requer saber seu IP atual
- ⚠️ Se IP mudar, precisará atualizar regra

---

### **OPÇÃO 3: Desabilitar Serviço SSH no Servidor**

**Como funciona:**
Para o serviço SSH completamente no servidor.

**Passos:**

```bash
# Conectar ao servidor primeiro
ssh root@157.180.36.223

# Parar serviço SSH
sudo systemctl stop sshd

# Desabilitar serviço SSH (não inicia automaticamente)
sudo systemctl disable sshd

# Verificar status
sudo systemctl status sshd
```

**Para reabilitar:**

```bash
# Habilitar serviço SSH
sudo systemctl enable sshd

# Iniciar serviço SSH
sudo systemctl start sshd
```

**Resultado:**
- ✅ Serviço SSH parado
- ✅ Nenhuma conexão SSH possível
- ❌ Você também não conseguirá acessar via SSH

**Vantagens:**
- ✅ Bloqueio completo de SSH
- ✅ Fácil de implementar

**Desvantagens:**
- ❌ **BLOQUEIA SEU ACESSO TAMBÉM**
- ❌ Requer console de gerenciamento para reabilitar
- ❌ Risco de ficar bloqueado do servidor

---

### **OPÇÃO 4: Alterar Porta SSH (Ocultação)**

**Como funciona:**
Muda porta SSH padrão (22) para outra porta, dificultando descoberta.

**Passos:**

```bash
# Conectar ao servidor
ssh root@157.180.36.223

# Editar configuração SSH
sudo nano /etc/ssh/sshd_config

# Alterar linha:
# Port 22
# Para:
# Port 2222  # Ou outra porta de sua escolha

# Reiniciar serviço SSH
sudo systemctl restart sshd

# Verificar se está funcionando na nova porta
sudo netstat -tlnp | grep sshd
```

**Ajustar Firewall:**

```bash
# Remover regra antiga
sudo ufw delete allow 22/tcp

# Adicionar regra nova porta
sudo ufw allow 2222/tcp
```

**Resultado:**
- ✅ Porta SSH padrão bloqueada
- ✅ SSH acessível apenas na nova porta
- ✅ Reduz ataques automatizados na porta 22

**Vantagens:**
- ✅ Mantém acesso SSH
- ✅ Reduz ataques automatizados
- ✅ Não bloqueia completamente

**Desvantagens:**
- ⚠️ Ainda permite acesso SSH (apenas em porta diferente)
- ⚠️ Não é bloqueio real, apenas ocultação

---

## 🎯 RECOMENDAÇÃO PARA SEU CASO

### **Para Bloquear Acesso do Assistente AI:**

**Opção Recomendada:** **Restringir SSH por IP** (Opção 2)

**Por quê:**
- ✅ Mantém seu acesso SSH
- ✅ Bloqueia acessos não autorizados
- ✅ Pode ser configurado via Hetzner Cloud Console (sem precisar SSH)
- ✅ Mais seguro que desabilitar completamente

**Implementação:**

1. **Identificar seu IP atual:**
   ```powershell
   # No PowerShell
   (Invoke-WebRequest -Uri "https://api.ipify.org").Content
   ```

2. **Configurar Firewall no Hetzner Cloud Console:**
   - Permitir SSH apenas do seu IP
   - Bloquear todos os outros IPs

3. **Resultado:**
   - ✅ Você consegue acessar via SSH
   - ✅ Assistente AI não consegue (IP diferente)
   - ✅ Outros não conseguem acessar

---

## 📋 PASSOS DETALHADOS: Restringir SSH por IP no Hetzner Cloud Console

### **1. Acessar Hetzner Cloud Console**

- URL: https://console.hetzner.com/
- Login com suas credenciais

### **2. Navegar para Firewalls**

- Menu lateral: **"Firewalls"**
- Ou: **"Networking" → "Firewalls"**

### **3. Criar Novo Firewall (ou Editar Existente)**

**Se criar novo:**
- Botão: **"Add Firewall"**
- Nome: `firewall-producao-ssh-restrito`
- Descrição: `Firewall para restringir SSH apenas ao IP do administrador`

**Se editar existente:**
- Selecionar firewall aplicado ao servidor de produção
- Botão: **"Edit"**

### **4. Adicionar Regra de Permissão (Seu IP)**

- Botão: **"Add Rule"**
- **Direção:** Inbound
- **Protocolo:** TCP
- **Porta:** 22
- **Ação:** **ALLOW**
- **Fonte:** Seu IP específico (ex: `123.45.67.89/32`)
- **Descrição:** `Permitir SSH apenas do IP do administrador`

**Importante:** Esta regra deve ser a **PRIMEIRA** na lista (ordem importa)

### **5. Adicionar Regra de Bloqueio (Todos os Outros)**

- Botão: **"Add Rule"**
- **Direção:** Inbound
- **Protocolo:** TCP
- **Porta:** 22
- **Ação:** **DENY**
- **Fonte:** `0.0.0.0/0` (todos os IPs)
- **Descrição:** `Bloquear SSH de todos os outros IPs`

**Importante:** Esta regra deve vir **DEPOIS** da regra de permissão

### **6. Aplicar Firewall ao Servidor**

- Selecionar servidor de produção (`157.180.36.223`)
- Seção: **"Applied to"**
- Botão: **"Assign Resources"**
- Selecionar servidor de produção
- Botão: **"Apply"**

### **7. Verificar Funcionamento**

**Testar do seu IP (deve funcionar):**
```powershell
ssh root@157.180.36.223 "echo 'SSH funcionando'"
```

**Testar de outro IP (deve falhar):**
- Tentar de outro computador/rede
- Deve retornar timeout ou conexão recusada

---

## 🔄 COMO REVERTER

### **Para Permitir SSH Novamente:**

1. **Via Hetzner Cloud Console:**
   - Editar firewall
   - Remover regra de bloqueio
   - Ou remover firewall do servidor

2. **Via Servidor (se tiver acesso):**
   ```bash
   # Permitir SSH novamente
   sudo ufw allow ssh
   sudo ufw reload
   ```

---

## ✅ CHECKLIST ANTES DE DESABILITAR SSH

- [ ] Tenho acesso ao Hetzner Cloud Console?
- [ ] Sei qual é meu IP atual?
- [ ] Tenho outro método de acesso ao servidor?
- [ ] Entendo que desabilitar SSH pode bloquear meu acesso?
- [ ] Preferi restringir por IP em vez de desabilitar completamente?

---

## 📚 DOCUMENTAÇÃO RELACIONADA

- **Arquitetura de Servidores:** `ARQUITETURA_SERVIDORES.md`
- **Análise de Causa Raiz:** `ANALISE_CAUSA_RAIZ_VIOLACAO_DIRETIVAS_PRODUCAO_20251118.md`
- **Controle de Acesso:** `EXPLICACAO_DETALHADA_CONTROLE_ACESSO_PRODUCAO.md`

---

**Recomendação Final:** Use **Opção 2 (Restringir por IP)** em vez de desabilitar completamente. Isso mantém seu acesso enquanto bloqueia acessos não autorizados.

