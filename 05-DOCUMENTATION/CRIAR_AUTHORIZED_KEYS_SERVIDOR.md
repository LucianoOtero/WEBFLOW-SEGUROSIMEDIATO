# 🔧 CRIAR authorized_keys no Servidor

**Data:** 21/11/2025  
**Servidor:** Produção (`157.180.36.223`)  
**Status:** ⚠️ Arquivo não existe - Precisa criar

---

## 📋 COMANDOS PARA CRIAR E CONFIGURAR

### **1. Criar diretório .ssh (se não existir):**

```bash
mkdir -p /root/.ssh
```

---

### **2. Criar arquivo authorized_keys:**

```bash
touch /root/.ssh/authorized_keys
```

---

### **3. Adicionar sua chave SSH ao arquivo:**

```bash
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3F0cOtZFLcJjFZ34GvgS4w6CkCUKUhNwfSgvFpgpjrPFW6Oxrhvs0HTEC8J+MFyOJhlvzkpvoeL/3IhoWxqKTX7ccyksjgVjcHv5V6n2PXh9y6ZyKiJVUp6vQAb94dvKe8SGUHBd0/UXW5+3yvJN1nzKc6TaDjbOkufIRxoUyOFKdCBzGZvkcNehVNYomTsXjZiqIQ3fJgeTYiDVkGsR5IFWkAj1I16vfoP7xZ6jOVm4R9zZF7b7zQw3/WICwjMzMtY8emwq6W37S3jJAZXMDGs/1U9YTkNxG7LqizI91RP1AmgR5P96psbjEgeIM10J6eoJ9lZarGTWckZSuBoNKXa0auNMq3lvq3TobkBUk6Y+sEzeBza+0Ql2MFUNWkc0OCnqygwzHUD06nOyNb4wHkTGRyaw0x/BHeGZHT6vge3X+jyS1IvvQJN4EC0jv5rbNc+abT8WJarTo6KmRQudvvn7zPRDF5fkRj+65TO+jJ1tMCC35JAYAtjssx9vmaZyleuGjdfyEQbTcJtMq2qhafUJ8KDiE6nI/Vn0/zWmywQUNo3wg87ox0sPeMUJJv+2i5aUfz0tebiCekw+jNsEhgAZE3gLwD2r63P73WqqxuR8cfci5MpEvg/oYT9Ij5GQeaEkJ2DiA3fQW/EbOk7Uab89q1XkeJ1tagq6PmXQ2uw== lrotero@gmail.com" > /root/.ssh/authorized_keys
```

---

### **4. Definir permissões corretas (CRÍTICO):**

```bash
# Permissões do diretório .ssh
chmod 700 /root/.ssh

# Permissões do arquivo authorized_keys
chmod 600 /root/.ssh/authorized_keys
```

**⚠️ IMPORTANTE:** Sem essas permissões, o SSH não funcionará!

---

### **5. Verificar se foi criado corretamente:**

```bash
# Verificar arquivo
ls -la /root/.ssh/authorized_keys

# Ver conteúdo
cat /root/.ssh/authorized_keys

# Verificar fingerprint
ssh-keygen -lf /root/.ssh/authorized_keys
```

**Saída esperada:**
```
-rw------- 1 root root 1234 Nov 21 10:00 /root/.ssh/authorized_keys
```

---

## 🚀 COMANDO COMPLETO (TUDO DE UMA VEZ)

**Execute este comando único que faz tudo:**

```bash
mkdir -p /root/.ssh && \
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3F0cOtZFLcJjFZ34GvgS4w6CkCUKUhNwfSgvFpgpjrPFW6Oxrhvs0HTEC8J+MFyOJhlvzkpvoeL/3IhoWxqKTX7ccyksjgVjcHv5V6n2PXh9y6ZyKiJVUp6vQAb94dvKe8SGUHBd0/UXW5+3yvJN1nzKc6TaDjbOkufIRxoUyOFKdCBzGZvkcNehVNYomTsXjZiqIQ3fJgeTYiDVkGsR5IFWkAj1I16vfoP7xZ6jOVm4R9zZF7b7zQw3/WICwjMzMtY8emwq6W37S3jJAZXMDGs/1U9YTkNxG7LqizI91RP1AmgR5P96psbjEgeIM10J6eoJ9lZarGTWckZSuBoNKXa0auNMq3lvq3TobkBUk6Y+sEzeBza+0Ql2MFUNWkc0OCnqygwzHUD06nOyNb4wHkTGRyaw0x/BHeGZHT6vge3X+jyS1IvvQJN4EC0jv5rbNc+abT8WJarTo6KmRQudvvn7zPRDF5fkRj+65TO+jJ1tMCC35JAYAtjssx9vmaZyleuGjdfyEQbTcJtMq2qhafUJ8KDiE6nI/Vn0/zWmywQUNo3wg87ox0sPeMUJJv+2i5aUfz0tebiCekw+jNsEhgAZE3gLwD2r63P73WqqxuR8cfci5MpEvg/oYT9Ij5GQeaEkJ2DiA3fQW/EbOk7Uab89q1XkeJ1tagq6PmXQ2uw== lrotero@gmail.com" > /root/.ssh/authorized_keys && \
chmod 700 /root/.ssh && \
chmod 600 /root/.ssh/authorized_keys && \
echo "✅ Arquivo criado com sucesso!" && \
ls -la /root/.ssh/authorized_keys && \
echo -e "\n📋 Conteúdo:" && \
cat /root/.ssh/authorized_keys && \
echo -e "\n🔑 Fingerprint:" && \
ssh-keygen -lf /root/.ssh/authorized_keys
```

---

## ✅ CHECKLIST APÓS EXECUTAR

Verifique se tudo está correto:

- [ ] Arquivo `/root/.ssh/authorized_keys` foi criado?
- [ ] Permissões do diretório `.ssh` estão `700` (`drwx------`)?
- [ ] Permissões do arquivo estão `600` (`-rw-------`)?
- [ ] Sua chave está no arquivo?
- [ ] Fingerprint coincide com sua chave local?

---

## 🔍 VERIFICAÇÃO FINAL

**Execute estes comandos para confirmar:**

```bash
# Verificar permissões
stat /root/.ssh/authorized_keys

# Ver conteúdo
cat /root/.ssh/authorized_keys

# Verificar fingerprint
ssh-keygen -lf /root/.ssh/authorized_keys

# Verificar se sua chave está lá
grep "lrotero@gmail.com" /root/.ssh/authorized_keys
```

---

## 🚨 SE DER ERRO

### **Erro: "Permission denied"**

```bash
# Verificar usuário atual
whoami

# Se não for root, usar sudo
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3F0cOtZFLcJjFZ34GvgS4w6CkCUKUhNwfSgvFpgpjrPFW6Oxrhvs0HTEC8J+MFyOJhlvzkpvoeL/3IhoWxqKTX7ccyksjgVjcHv5V6n2PXh9y6ZyKiJVUp6vQAb94dvKe8SGUHBd0/UXW5+3yvJN1nzKc6TaDjbOkufIRxoUyOFKdCBzGZvkcNehVNYomTsXjZiqIQ3fJgeTYiDVkGsR5IFWkAj1I16vfoP7xZ6jOVm4R9zZF7b7zQw3/WICwjMzMtY8emwq6W37S3jJAZXMDGs/1U9YTkNxG7LqizI91RP1AmgR5P96psbjEgeIM10J6eoJ9lZarGTWckZSuBoNKXa0auNMq3lvq3TobkBUk6Y+sEzeBza+0Ql2MFUNWkc0OCnqygwzHUD06nOyNb4wHkTGRyaw0x/BHeGZHT6vge3X+jyS1IvvQJN4EC0jv5rbNc+abT8WJarTo6KmRQudvvn7zPRDF5fkRj+65TO+jJ1tMCC35JAYAtjssx9vmaZyleuGjdfyEQbTcJtMq2qhafUJ8KDiE6nI/Vn0/zWmywQUNo3wg87ox0sPeMUJJv+2i5aUfz0tebiCekw+jNsEhgAZE3gLwD2r63P73WqqxuR8cfci5MpEvg/oYT9Ij5GQeaEkJ2DiA3fQW/EbOk7Uab89q1XkeJ1tagq6PmXQ2uw== lrotero@gmail.com" | sudo tee /root/.ssh/authorized_keys > /dev/null
sudo chmod 600 /root/.ssh/authorized_keys
```

---

## 📝 PRÓXIMOS PASSOS

Após criar o arquivo:

1. ✅ **Configurar Firewall no Hetzner Console** para permitir SSH do seu IP
2. ✅ **Testar conexão SSH** do seu computador
3. ✅ **Verificar se autenticação funciona** sem senha

---

**Documento criado com comandos prontos para executar.**

