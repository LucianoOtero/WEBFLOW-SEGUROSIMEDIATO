# 🔑 COMO CRIAR NOVA CHAVE DE ACESSO PARA SES-EMAIL-SENDER

**Data:** 21/11/2025  
**Usuário IAM:** `ses-email-sender`  
**Access Key ID Atual:** `AKIA3JCQSJTSMSKFZPW3`

---

## 📋 PASSO A PASSO

### **Passo 1: Acessar o Usuário**

1. **No Console AWS IAM:**
   - Você já está vendo o usuário `ses-email-sender`
   - Clique no nome do usuário para abrir os detalhes

### **Passo 2: Acessar Security Credentials**

1. **Na página do usuário, clique na aba:**
   - **"Security credentials"** ou **"Credenciais de segurança"**

2. **Você verá a seção "Access keys"**

### **Passo 3: Criar Nova Chave**

1. **Na seção "Access keys", clique em:**
   - **"Create access key"** ou **"Criar chave de acesso"**

2. **Selecione o caso de uso:**
   - Escolha **"Application running outside AWS"** ou **"Aplicação em execução fora da AWS"**
   - Clique em **"Next"**

3. **Confirmação:**
   - Clique em **"Create access key"** novamente

### **Passo 4: COPIAR AS CREDENCIAIS (CRÍTICO!)**

1. **Você verá uma tela com:**
   - **Access key ID:** Começa com `AKIA...` (exemplo: `AKIA3JCQSJTSMSKFZPW3`)
   - **Secret access key:** Uma string longa (exemplo: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`)

2. **⚠️ CRÍTICO - FAÇA AGORA:**
   - **Clique em "Show"** para revelar o Secret access key
   - **COPIE AMBAS AS CREDENCIAIS** e salve em um lugar seguro
   - **O Secret access key só aparece UMA VEZ**
   - Se você fechar esta página sem copiar, precisará criar outra chave

3. **Recomendação:**
   - Cole em um editor de texto temporário
   - Salve em um gerenciador de senhas (1Password, LastPass, etc.)
   - **NÃO** compartilhe por email ou mensagem não criptografada

### **Passo 5: Desativar Chave Antiga (Opcional mas Recomendado)**

1. **Na mesma página "Security credentials":**
   - Você verá a chave antiga (`AKIA3JCQSJTSMSKFZPW3`)
   - Clique nos **3 pontos** ao lado da chave
   - Selecione **"Deactivate"** ou **"Desativar"**
   - Confirme a desativação

2. **Por que desativar?**
   - Se a chave antiga foi comprometida ou você não tem o Secret salvo
   - Melhor prática de segurança
   - Você pode reativar depois se necessário

---

## 🔧 ATUALIZAR NO SERVIDOR

Após obter as novas credenciais, atualize no servidor:

### **1. Conectar ao servidor:**

```bash
ssh root@65.108.156.14
```

### **2. Editar arquivo de configuração:**

```bash
nano /etc/php/8.3/fpm/pool.d/www.conf
```

### **3. Localizar e atualizar as linhas:**

Procure por:
```ini
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

Substitua por (use as credenciais reais que você copiou):
```ini
env[AWS_ACCESS_KEY_ID] = AKIA3JCQSJTSMSKFZPW3
env[AWS_SECRET_ACCESS_KEY] = sua-chave-secreta-real-aqui
```

**⚠️ IMPORTANTE:**
- Não deixe espaços ao redor do `=`
- Não use aspas
- Use a chave nova que você acabou de criar (não a antiga)

### **4. Salvar e sair:**

- Pressione `Ctrl + X`
- Digite `Y` para confirmar
- Pressione `Enter`

### **5. Validar sintaxe:**

```bash
php-fpm -t
```

Se aparecer "syntax ok", está correto.

### **6. Recarregar PHP-FPM:**

```bash
systemctl reload php8.3-fpm
```

### **7. Verificar status:**

```bash
systemctl status php8.3-fpm
```

---

## ✅ TESTAR

Após atualizar, teste o envio de email:

```bash
curl -k -s https://127.0.0.1/TMP/test_email_direct.php | grep -E "success|error|Code:"
```

Se aparecer `"success": true`, as credenciais estão corretas!

---

## 🔐 SEGURANÇA

### **Boas Práticas:**

1. ✅ **Nunca commite credenciais no Git**
2. ✅ **Use variáveis de ambiente** (já está sendo feito)
3. ✅ **Rotacione credenciais periodicamente** (a cada 90 dias)
4. ✅ **Monitore uso no CloudTrail**
5. ✅ **Desative chaves antigas** quando criar novas

### **Se precisar de ajuda:**

- Verifique se copiou o Secret Access Key corretamente
- Verifique se não há espaços extras no arquivo de configuração
- Verifique se o PHP-FPM foi recarregado após a alteração

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

