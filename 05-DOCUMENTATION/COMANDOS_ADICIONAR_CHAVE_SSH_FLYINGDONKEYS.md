# 🔑 Comandos para Adicionar Chave SSH ao dev.flyingdonkeys.com.br

**Data:** 25/11/2025  
**Objetivo:** Adicionar chave SSH local ao servidor para permitir acesso

---

## 📋 PASSO A PASSO

### **PASSO 1: Obter sua Chave SSH Pública Local**

**No PowerShell (Windows):**
```powershell
# Verificar se chave existe e exibir conteúdo
type $env:USERPROFILE\.ssh\id_rsa.pub

# OU se usar ed25519:
type $env:USERPROFILE\.ssh\id_ed25519.pub
```

**Se não tiver chave SSH, criar uma:**
```powershell
ssh-keygen -t ed25519 -C "seu-email@exemplo.com"
```

**Copiar o conteúdo da chave** (será usado no próximo passo)

---

### **PASSO 2: Adicionar Chave ao Servidor**

**Opção A: Via SSH (se já tiver acesso temporário):**
```bash
# Conectar ao servidor (se tiver acesso)
ssh root@dev.flyingdonkeys.com.br

# Dentro do servidor, editar arquivo authorized_keys
nano /root/.ssh/authorized_keys

# OU usar echo para adicionar (substituir CHAVE_PUBLICA pelo conteúdo da sua chave)
echo "CHAVE_PUBLICA_AQUI" >> /root/.ssh/authorized_keys

# Ajustar permissões (importante!)
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh
```

**Opção B: Via comando único (se tiver acesso temporário):**
```bash
# Substituir CHAVE_PUBLICA_AQUI pelo conteúdo completo da sua chave pública
ssh root@dev.flyingdonkeys.com.br "echo 'CHAVE_PUBLICA_AQUI' >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && chmod 700 /root/.ssh"
```

**Opção C: Via painel Hetzner (se disponível):**
- Acessar painel Hetzner Cloud
- Selecionar servidor `dev.flyingdonkeys.com.br`
- Acessar "SSH Keys" ou "Access"
- Adicionar chave pública

---

### **PASSO 3: Testar Acesso**

```bash
# Testar conexão SSH
ssh root@dev.flyingdonkeys.com.br

# Se funcionar, você estará conectado ao servidor
```

---

## ⚠️ IMPORTANTE

1. **Permissões Corretas:**
   - `/root/.ssh/authorized_keys` deve ter permissão `600`
   - `/root/.ssh/` deve ter permissão `700`

2. **Formato da Chave:**
   - A chave pública deve estar em uma única linha
   - Formato: `ssh-ed25519 AAAA... email@exemplo.com` ou `ssh-rsa AAAA... email@exemplo.com`

3. **Backup:**
   - Fazer backup do arquivo antes de modificar:
   ```bash
   cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.backup
   ```

---

## 🔧 COMANDOS COMPLETOS (Copiar/Colar)

### **1. Obter Chave SSH Local (PowerShell):**
```powershell
# Exibir chave pública
type $env:USERPROFILE\.ssh\id_ed25519.pub
# OU
type $env:USERPROFILE\.ssh\id_rsa.pub
```

### **2. Adicionar ao Servidor (via SSH temporário ou painel):**
```bash
# Se tiver acesso temporário, executar no servidor:
nano /root/.ssh/authorized_keys
# Colar sua chave pública em uma nova linha
# Salvar (Ctrl+O, Enter, Ctrl+X)

# Ajustar permissões
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh
```

---

**Após adicionar a chave, me avise para continuar com a implementação do Datadog!**

