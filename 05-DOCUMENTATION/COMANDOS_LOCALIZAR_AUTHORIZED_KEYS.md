# 🔍 COMANDOS: Localizar authorized_keys no Servidor

**Data:** 21/11/2025  
**Servidor:** Produção (`157.180.36.223`)  
**Status SSH:** ⚠️ Bloqueado - Use Hetzner Cloud Console

---

## 📍 LOCALIZAÇÃO DO ARQUIVO

**Caminho completo:**
```
/root/.ssh/authorized_keys
```

---

## 🔧 COMANDOS PARA EXECUTAR NO SERVIDOR

### **1. Verificar se o arquivo existe:**

```bash
ls -la /root/.ssh/authorized_keys
```

**Saída esperada se existir:**
```
-rw------- 1 root root 1234 Nov 21 10:00 /root/.ssh/authorized_keys
```

**Se não existir:**
```
ls: cannot access '/root/.ssh/authorized_keys': No such file or directory
```

---

### **2. Verificar se o diretório .ssh existe:**

```bash
ls -la /root/.ssh/
```

**Saída esperada:**
```
drwx------ 2 root root 4096 Nov 21 10:00 .
drwx------ 3 root root 4096 Nov 21 10:00 ..
-rw------- 1 root root 1234 Nov 21 10:00 authorized_keys
```

---

### **3. Ver conteúdo do arquivo authorized_keys:**

```bash
cat /root/.ssh/authorized_keys
```

**Saída esperada (exemplo):**
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3F0cOtZFLcJjFZ34GvgS4w6CkCUKUhNwfSgvFpgpjrPFW6Oxrhvs0HTEC8J+MFyOJhlvzkpvoeL/3IhoWxqKTX7ccyksjgVjcHv5V6n2PXh9y6ZyKiJVUp6vQAb94dvKe8SGUHBd0/UXW5+3yvJN1nzKc6TaDjbOkufIRxoUyOFKdCBzGZvkcNehVNYomTsXjZiqIQ3fJgeTYiDVkGsR5IFWkAj1I16vfoP7xZ6jOVm4R9zZF7b7zQw3/WICwjMzMtY8emwq6W37S3jJAZXMDGs/1U9YTkNxG7LqizI91RP1AmgR5P96psbjEgeIM10J6eoJ9lZarGTWckZSuBoNKXa0auNMq3lvq3TobkBUk6Y+sEzeBza+0Ql2MFUNWkc0OCnqygwzHUD06nOyNb4wHkTGRyaw0x/BHeGZHT6vge3X+jyS1IvvQJN4EC0jv5rbNc+abT8WJarTo6KmRQudvvn7zPRDF5fkRj+65TO+jJ1tMCC35JAYAtjssx9vmaZyleuGjdfyEQbTcJtMq2qhafUJ8KDiE6nI/Vn0/zWmywQUNo3wg87ox0sPeMUJJv+2i5aUfz0tebiCekw+jNsEhgAZE3gLwD2r63P73WqqxuR8cfci5MpEvg/oYT9Ij5GQeaEkJ2DiA3fQW/EbOk7Uab89q1XkeJ1tagq6PmXQ2uw== lrotero@gmail.com
```

---

### **4. Ver conteúdo com numeração de linhas:**

```bash
cat -n /root/.ssh/authorized_keys
```

**Útil para identificar qual linha corresponde à sua chave**

---

### **5. Verificar fingerprint das chaves:**

```bash
ssh-keygen -lf /root/.ssh/authorized_keys
```

**Saída esperada:**
```
4096 SHA256:4U3qnH3TpUb9ENLzRWTO4JQdIMen5/ySzY/pFfF8uIU lrotero@gmail.com (RSA)
```

**Comparar com sua chave local:**
- **Sua chave local:** `SHA256:4U3qnH3TpUb9ENLzRWTO4JQdIMen5/ySzY/pFfF8uIU`
- **Se coincidir:** ✅ Chave está autorizada
- **Se não coincidir:** ⚠️ Chave não está autorizada ou é diferente

---

### **6. Verificar permissões do arquivo:**

```bash
stat /root/.ssh/authorized_keys
```

**Permissões corretas:**
- **Arquivo:** `600` (`-rw-------`)
- **Diretório:** `700` (`drwx------`)

---

### **7. Buscar sua chave específica no arquivo:**

```bash
grep "lrotero@gmail.com" /root/.ssh/authorized_keys
```

**Se encontrar:** ✅ Sua chave está no arquivo  
**Se não encontrar:** ❌ Sua chave não está autorizada

---

### **8. Verificar se chave está comentada (bloqueada):**

```bash
grep "^#.*lrotero@gmail.com" /root/.ssh/authorized_keys
```

**Se encontrar:** ⚠️ Chave está comentada (bloqueada)  
**Se não encontrar:** ✅ Chave não está comentada

---

## 🔍 COMANDO COMPLETO DE VERIFICAÇÃO

**Execute este comando para ver tudo de uma vez:**

```bash
echo "=== Verificando diretório .ssh ===" && \
ls -la /root/.ssh/ && \
echo -e "\n=== Conteúdo do authorized_keys ===" && \
cat -n /root/.ssh/authorized_keys && \
echo -e "\n=== Fingerprints das chaves ===" && \
ssh-keygen -lf /root/.ssh/authorized_keys && \
echo -e "\n=== Buscando sua chave ===" && \
grep "lrotero@gmail.com" /root/.ssh/authorized_keys && \
echo -e "\n=== Verificando se está comentada ===" && \
grep "^#.*lrotero@gmail.com" /root/.ssh/authorized_keys || echo "Chave não está comentada"
```

---

## 📋 CHECKLIST DE VERIFICAÇÃO

Execute os comandos acima e verifique:

- [ ] Arquivo `/root/.ssh/authorized_keys` existe?
- [ ] Permissões estão corretas (`600` para arquivo, `700` para diretório)?
- [ ] Sua chave (`lrotero@gmail.com`) está no arquivo?
- [ ] Fingerprint da chave no servidor coincide com sua chave local?
- [ ] Chave não está comentada (sem `#` no início da linha)?

---

## 🚨 SE O ARQUIVO NÃO EXISTIR

**Criar diretório e arquivo:**

```bash
# Criar diretório .ssh se não existir
mkdir -p /root/.ssh

# Criar arquivo authorized_keys
touch /root/.ssh/authorized_keys

# Definir permissões corretas
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys
```

---

## ✏️ ADICIONAR SUA CHAVE AO ARQUIVO

**Se sua chave não estiver no arquivo, adicionar:**

```bash
# Fazer backup primeiro
cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.backup_$(date +%Y%m%d_%H%M%S)

# Adicionar sua chave (cole a chave completa abaixo)
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3F0cOtZFLcJjFZ34GvgS4w6CkCUKUhNwfSgvFpgpjrPFW6Oxrhvs0HTEC8J+MFyOJhlvzkpvoeL/3IhoWxqKTX7ccyksjgVjcHv5V6n2PXh9y6ZyKiJVUp6vQAb94dvKe8SGUHBd0/UXW5+3yvJN1nzKc6TaDjbOkufIRxoUyOFKdCBzGZvkcNehVNYomTsXjZiqIQ3fJgeTYiDVkGsR5IFWkAj1I16vfoP7xZ6jOVm4R9zZF7b7zQw3/WICwjMzMtY8emwq6W37S3jJAZXMDGs/1U9YTkNxG7LqizI91RP1AmgR5P96psbjEgeIM10J6eoJ9lZarGTWckZSuBoNKXa0auNMq3lvq3TobkBUk6Y+sEzeBza+0Ql2MFUNWkc0OCnqygwzHUD06nOyNb4wHkTGRyaw0x/BHeGZHT6vge3X+jyS1IvvQJN4EC0jv5rbNc+abT8WJarTo6KmRQudvvn7zPRDF5fkRj+65TO+jJ1tMCC35JAYAtjssx9vmaZyleuGjdfyEQbTcJtMq2qhafUJ8KDiE6nI/Vn0/zWmywQUNo3wg87ox0sPeMUJJv+2i5aUfz0tebiCekw+jNsEhgAZE3gLwD2r63P73WqqxuR8cfci5MpEvg/oYT9Ij5GQeaEkJ2DiA3fQW/EbOk7Uab89q1XkeJ1tagq6PmXQ2uw== lrotero@gmail.com" >> /root/.ssh/authorized_keys

# Verificar permissões
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh

# Verificar se foi adicionada
grep "lrotero@gmail.com" /root/.ssh/authorized_keys
```

---

## 🔄 REABILITAR CHAVE COMENTADA

**Se sua chave estiver comentada (bloqueada):**

```bash
# Fazer backup
cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.backup_$(date +%Y%m%d_%H%M%S)

# Remover comentário da linha que contém sua chave
sed -i '/lrotero@gmail.com/s/^# //' /root/.ssh/authorized_keys

# Verificar se foi reabilitada
grep "lrotero@gmail.com" /root/.ssh/authorized_keys
```

---

## 📝 COMO ACESSAR O SERVIDOR (SSH BLOQUEADO)

### **Opção 1: Via Hetzner Cloud Console**

1. Acesse: https://console.hetzner.com/
2. Vá em: **Servers** → Selecione servidor `157.180.36.223`
3. Clique em: **"Console"** ou **"VNC Console"**
4. Execute os comandos acima no console

### **Opção 2: Após Configurar Firewall**

1. Configure firewall no Hetzner Console para permitir SSH do seu IP
2. Conecte via SSH: `ssh root@157.180.36.223`
3. Execute os comandos acima

---

**Documento criado para referência rápida dos comandos necessários.**

