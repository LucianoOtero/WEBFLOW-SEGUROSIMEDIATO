# 🔑 Como Alterar Senha do Root no Servidor

**Data:** 2025-11-18  
**Objetivo:** Explicar como alterar a senha do usuário root no servidor Linux

---

## 🔧 COMANDO PRINCIPAL

### **Comando `passwd`:**

```bash
passwd
```

**Como usar:**

1. **Conectar ao servidor:**
   ```bash
   ssh root@157.180.36.223
   ```

2. **Executar comando:**
   ```bash
   passwd
   ```

3. **Seguir prompts:**
   ```
   New password: [digite nova senha]
   Retype new password: [digite nova senha novamente]
   ```

4. **Confirmação:**
   ```
   passwd: password updated successfully
   ```

---

## 📋 DETALHES DO COMANDO

### **Para Usuário Root:**

```bash
# Alterar senha do root (usuário atual)
passwd

# Ou explicitamente
passwd root
```

### **Para Outro Usuário (como root):**

```bash
# Alterar senha de outro usuário (requer privilégios root)
passwd nome_usuario
```

---

## ⚠️ IMPORTANTE

### **1. Requer Privilégios:**

- ✅ Se você está logado como `root`, pode alterar diretamente
- ✅ Se você está logado como outro usuário, precisa de `sudo`:
  ```bash
  sudo passwd root
  ```

### **2. Segurança:**

- ✅ Use senha forte (mínimo 12 caracteres, mistura de letras, números, símbolos)
- ✅ Não compartilhe senha
- ✅ Considere usar chaves SSH em vez de senha quando possível

### **3. Autenticação SSH:**

- ⚠️ Se SSH está configurado para aceitar apenas chaves (`PasswordAuthentication no`), alterar senha não afetará acesso SSH
- ⚠️ Para habilitar autenticação por senha, editar `/etc/ssh/sshd_config`:
  ```bash
  PasswordAuthentication yes
  systemctl restart sshd
  ```

---

## 🔍 VERIFICAR CONFIGURAÇÃO SSH

### **Ver se autenticação por senha está habilitada:**

```bash
# Ver configuração SSH
grep PasswordAuthentication /etc/ssh/sshd_config

# Se mostrar:
# PasswordAuthentication no  → Senha não funciona para SSH
# PasswordAuthentication yes → Senha funciona para SSH
```

---

## 📝 PROCESSO COMPLETO

### **1. Conectar ao Servidor:**

```bash
ssh root@157.180.36.223
```

### **2. Alterar Senha:**

```bash
passwd
```

### **3. Digitar Nova Senha (2 vezes):**

- Primeira vez: digite nova senha
- Segunda vez: confirme nova senha

### **4. Verificar:**

```bash
# Testar login com nova senha (em outro terminal)
ssh root@157.180.36.223
# Digitar nova senha quando solicitado
```

---

## 🔄 ALTERAR SENHA SEM ESTAR LOGADO

### **Se você tem acesso ao console do Hetzner:**

1. **Acessar Hetzner Cloud Console:**
   - URL: https://console.hetzner.com/
   - Selecionar servidor

2. **Abrir Console:**
   - Botão: **"Console"** ou **"VNC Console"**

3. **Alterar senha via console:**
   ```bash
   passwd root
   ```

---

## 🚨 RECUPERAÇÃO DE SENHA ESQUECIDA

### **Via Hetzner Cloud Console:**

1. **Acessar Console do Hetzner**
2. **Reiniciar servidor em modo de recuperação**
3. **Montar sistema de arquivos**
4. **Alterar senha diretamente no arquivo `/etc/shadow`**

**⚠️ Processo complexo - requer conhecimento avançado**

---

## ✅ RESUMO

**Comando:** `passwd`

**Processo:**
1. Conectar ao servidor: `ssh root@157.180.36.223`
2. Executar: `passwd`
3. Digitar nova senha (2 vezes)
4. Confirmar alteração

**Importante:**
- ✅ Use senha forte
- ⚠️ Verifique se SSH aceita autenticação por senha
- ⚠️ Considere usar chaves SSH em vez de senha

