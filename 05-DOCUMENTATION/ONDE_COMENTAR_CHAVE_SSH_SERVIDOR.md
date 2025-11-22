# 🔑 Onde Comentar Chave Pública SSH no Servidor

**Data:** 2025-11-18  
**Objetivo:** Explicar onde ficam as chaves públicas SSH no servidor para comentá-las e bloquear acesso

---

## 📍 LOCALIZAÇÃO DAS CHAVES PÚBLICAS SSH

### **Arquivo Principal: `~/.ssh/authorized_keys`**

**Caminho Completo:**
- **Usuário root:** `/root/.ssh/authorized_keys`
- **Outros usuários:** `/home/USUARIO/.ssh/authorized_keys`

**No seu caso (servidor de produção):**
```
/root/.ssh/authorized_keys
```

---

## 🔍 COMO VERIFICAR

### **1. Conectar ao Servidor:**

```bash
ssh root@157.180.36.223
```

### **2. Verificar se Arquivo Existe:**

```bash
ls -la /root/.ssh/authorized_keys
```

### **3. Ver Conteúdo do Arquivo:**

```bash
cat /root/.ssh/authorized_keys
```

**Formato típico:**
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... usuario@computador
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... outra_chave
```

---

## ✏️ COMO COMENTAR CHAVE SSH

### **Método 1: Comentar Linha Específica**

**Passos:**

1. **Fazer backup do arquivo:**
   ```bash
   cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.backup_$(date +%Y%m%d_%H%M%S)
   ```

2. **Editar arquivo:**
   ```bash
   nano /root/.ssh/authorized_keys
   ```

3. **Comentar linha adicionando `#` no início:**
   ```bash
   # Antes:
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... usuario@computador
   
   # Depois:
   # ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... usuario@computador
   ```

4. **Salvar arquivo:**
   - `Ctrl + O` (salvar)
   - `Enter` (confirmar)
   - `Ctrl + X` (sair)

5. **Verificar permissões (importante):**
   ```bash
   chmod 600 /root/.ssh/authorized_keys
   chmod 700 /root/.ssh
   ```

---

### **Método 2: Remover Linha Completamente**

**Se preferir remover em vez de comentar:**

```bash
# Fazer backup primeiro
cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.backup_$(date +%Y%m%d_%H%M%S)

# Editar arquivo
nano /root/.ssh/authorized_keys

# Deletar linha inteira da chave que deseja bloquear
# Salvar e sair
```

---

### **Método 3: Usar sed (Linha de Comando)**

**Se souber qual linha comentar:**

```bash
# Fazer backup
cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.backup_$(date +%Y%m%d_%H%M%S)

# Comentar linha específica (exemplo: linha 1)
sed -i '1s/^/# /' /root/.ssh/authorized_keys

# Ou comentar linha que contém texto específico
sed -i '/texto_da_chave/s/^/# /' /root/.ssh/authorized_keys
```

---

## 🔍 COMO IDENTIFICAR QUAL CHAVE COMENTAR

### **Opção 1: Ver Chave Pública Local**

**No Windows (PowerShell):**

```powershell
# Ver chave pública SSH local
Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
# Ou
Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
```

**Comparar com chaves no servidor:**
- Copiar parte inicial da chave (primeiros 50 caracteres)
- Procurar no arquivo `authorized_keys` do servidor

---

### **Opção 2: Ver Todas as Chaves no Servidor**

```bash
# Conectar ao servidor
ssh root@157.180.36.223

# Ver arquivo com numeração de linhas
cat -n /root/.ssh/authorized_keys
```

**Saída exemplo:**
```
     1  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... chave1@computador1
     2  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... chave2@computador2
     3  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD... chave3@computador3
```

**Identificar qual linha corresponde à chave que deseja bloquear**

---

### **Opção 3: Testar Conexão com Verbose**

**No Windows (PowerShell):**

```powershell
# Tentar conectar com verbose para ver qual chave está sendo usada
ssh -v root@157.180.36.223
```

**Saída mostrará:**
- Qual chave está sendo tentada
- Se autenticação foi bem-sucedida ou não

---

## ⚠️ CUIDADOS IMPORTANTES

### **1. NÃO Comentar Todas as Chaves**

**Problema:**
- Se comentar todas as chaves, você também não conseguirá acessar
- Pode ficar bloqueado do servidor

**Solução:**
- ✅ Comentar apenas a chave específica que deseja bloquear
- ✅ Manter pelo menos uma chave ativa (sua chave)
- ✅ Fazer backup antes de modificar

---

### **2. Verificar Permissões**

**Permissões corretas:**
```bash
# Arquivo authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Diretório .ssh
chmod 700 /root/.ssh

# Verificar
ls -la /root/.ssh/
```

**Saída esperada:**
```
drwx------ 2 root root 4096 Nov 18 16:00 .
drwx------ 3 root root 4096 Nov 18 16:00 ..
-rw------- 1 root root  500 Nov 18 16:00 authorized_keys
```

---

### **3. Testar Antes de Fechar Conexão**

**Após comentar chave:**

1. **Manter conexão SSH atual aberta**
2. **Abrir NOVA conexão SSH em outro terminal:**
   ```bash
   # Tentar conectar com a chave comentada
   ssh root@157.180.36.223
   ```
3. **Se falhar:** ✅ Funcionou - chave bloqueada
4. **Se funcionar:** ⚠️ Verificar se comentou a chave correta

---

## 🔄 COMO REVERTER (Reabilitar Chave)

### **Se Comentou (Adicionou `#`):**

```bash
# Editar arquivo
nano /root/.ssh/authorized_keys

# Remover `#` do início da linha
# Antes:
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... usuario@computador

# Depois:
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC... usuario@computador

# Salvar e sair
```

### **Se Removeu Linha:**

```bash
# Restaurar de backup
cp /root/.ssh/authorized_keys.backup_* /root/.ssh/authorized_keys

# Ou adicionar linha novamente manualmente
nano /root/.ssh/authorized_keys
# Colar chave pública completa
```

---

## 📋 PROCESSO COMPLETO RECOMENDADO

### **1. Preparação:**

```bash
# Conectar ao servidor
ssh root@157.180.36.223

# Fazer backup
cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.backup_$(date +%Y%m%d_%H%M%S)

# Ver conteúdo atual
cat -n /root/.ssh/authorized_keys
```

### **2. Identificar Chave:**

- Comparar com chave pública local
- Identificar qual linha corresponde à chave a bloquear

### **3. Comentar Chave:**

```bash
# Editar arquivo
nano /root/.ssh/authorized_keys

# Comentar linha específica adicionando # no início
# Salvar (Ctrl+O, Enter, Ctrl+X)
```

### **4. Verificar Permissões:**

```bash
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh
```

### **5. Testar:**

```bash
# Em outro terminal, tentar conectar com chave comentada
# Deve falhar
```

---

## 🎯 RESUMO

**Arquivo:** `/root/.ssh/authorized_keys`

**Para comentar:**
1. Fazer backup
2. Editar arquivo: `nano /root/.ssh/authorized_keys`
3. Adicionar `#` no início da linha da chave
4. Salvar arquivo
5. Verificar permissões: `chmod 600 /root/.ssh/authorized_keys`

**Para reverter:**
- Remover `#` do início da linha
- Ou restaurar de backup

---

**⚠️ IMPORTANTE:** Não comente todas as chaves ou você ficará bloqueado do servidor!

