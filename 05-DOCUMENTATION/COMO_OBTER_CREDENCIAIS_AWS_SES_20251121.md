# 🔑 COMO OBTER CREDENCIAIS AWS SES

**Data:** 21/11/2025  
**Status:** 📋 **GUIA DE REFERÊNCIA**

---

## 📋 ONDE ENCONTRAR AS CREDENCIAIS AWS

As credenciais AWS SES são na verdade **credenciais IAM** (Identity and Access Management) que têm permissão para usar o serviço SES.

### **Opção 1: Verificar se já existem credenciais criadas**

1. **Acesse o Console AWS:**
   - URL: https://console.aws.amazon.com/
   - Faça login com sua conta AWS

2. **Navegue para IAM:**
   - No menu superior, procure por "IAM" ou acesse diretamente: https://console.aws.amazon.com/iam/

3. **Acesse "Users" (Usuários):**
   - No menu lateral esquerdo, clique em **"Users"** ou **"Usuários"**

4. **Procure por um usuário relacionado ao SES:**
   - Procure por usuários com nomes como:
     - `ses-user`
     - `ses-sender`
     - `email-sender`
     - Ou qualquer usuário que você tenha criado para envio de emails

5. **Acesse as credenciais de acesso:**
   - Clique no usuário
   - Vá para a aba **"Security credentials"** ou **"Credenciais de segurança"**
   - Procure por **"Access keys"** ou **"Chaves de acesso"**

6. **Se já existir uma chave:**
   - Você pode ver o **Access Key ID** (começa com `AKIA...`)
   - **MAS NÃO** pode ver o **Secret Access Key** novamente (ela só é mostrada uma vez na criação)
   - Se você não tiver o Secret Access Key salvo, precisará criar uma nova chave

---

## 🔑 COMO CRIAR NOVAS CREDENCIAIS AWS SES

### **Passo 1: Criar Usuário IAM (se não existir)**

1. **Acesse IAM Console:**
   - https://console.aws.amazon.com/iam/

2. **Clique em "Users" → "Add users" ou "Adicionar usuários"**

3. **Configure o usuário:**
   - **Nome do usuário:** `ses-email-sender` (ou outro nome de sua escolha)
   - **Tipo de acesso:** Selecione **"Access key - Programmatic access"** ou **"Chave de acesso - Acesso programático"**

4. **Clique em "Next: Permissions"**

### **Passo 2: Anexar Política de Permissões**

1. **Selecione "Attach existing policies directly"** ou **"Anexar políticas existentes diretamente"**

2. **Procure e selecione a política:**
   - Digite `AmazonSESFullAccess` na busca
   - **OU** para mais segurança, use `AmazonSESSendingAccess` (apenas envio, sem configuração)

3. **Clique em "Next: Tags"** (pode pular tags)

4. **Clique em "Next: Review"**

5. **Revise e clique em "Create user"** ou **"Criar usuário"**

### **Passo 3: Obter as Credenciais**

1. **Após criar o usuário, você verá a tela de sucesso**

2. **IMPORTANTE:** Nesta tela você verá:
   - **Access Key ID:** Começa com `AKIA...` (exemplo: `AKIAIOSFODNN7EXAMPLE`)
   - **Secret Access Key:** Uma string longa (exemplo: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`)

3. **⚠️ CRÍTICO:** 
   - **COPIE E SALVE AMBAS AS CREDENCIAIS AGORA**
   - O **Secret Access Key** só é mostrado **UMA VEZ**
   - Se você fechar esta página sem copiar, precisará criar uma nova chave

4. **Recomendação:** Salve em um gerenciador de senhas seguro (1Password, LastPass, etc.)

---

## 🔍 COMO VERIFICAR SE AS CREDENCIAIS ESTÃO CORRETAS

### **Teste via AWS CLI (se tiver instalado):**

```bash
aws configure
# Digite:
# AWS Access Key ID: [sua-chave]
# AWS Secret Access Key: [sua-chave-secreta]
# Default region: us-east-1
# Default output format: json

# Testar envio de email
aws ses send-email \
  --from noreply@bpsegurosimediato.com.br \
  --to seu-email@exemplo.com \
  --subject "Teste" \
  --text "Teste de credenciais"
```

### **Teste via Console AWS:**

1. Acesse: https://console.aws.amazon.com/ses/
2. Vá em **"Verified identities"** → **"Email addresses"**
3. Se você conseguir ver suas identidades verificadas, as credenciais estão funcionando

---

## 📝 ONDE ATUALIZAR NO SERVIDOR

Após obter as credenciais reais, você precisa atualizá-las no arquivo de configuração do PHP-FPM:

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Linhas a atualizar:**

```ini
env[AWS_ACCESS_KEY_ID] = AKIA...SUA_CHAVE_REAL_AQUI
env[AWS_SECRET_ACCESS_KEY] = sua-chave-secreta-real-aqui
```

**⚠️ IMPORTANTE:**
- Não deixe espaços ao redor do `=`
- Não use aspas
- Após atualizar, recarregue o PHP-FPM: `systemctl reload php8.3-fpm`

---

## 🔐 SEGURANÇA

### **Boas Práticas:**

1. **Nunca commite credenciais no Git**
2. **Use o mínimo de permissões necessárias** (`AmazonSESSendingAccess` ao invés de `AmazonSESFullAccess`)
3. **Rotacione credenciais periodicamente** (a cada 90 dias recomendado)
4. **Use variáveis de ambiente** (como já está sendo feito)
5. **Monitore o uso das credenciais** no CloudTrail da AWS

### **Se as credenciais forem comprometidas:**

1. **Desative imediatamente** a chave de acesso no IAM
2. **Crie uma nova chave** seguindo os passos acima
3. **Atualize no servidor** imediatamente
4. **Revise logs** para verificar se houve uso não autorizado

---

## 📞 SUPORTE

Se você não tiver acesso ao console AWS ou não souber qual conta AWS usar:

1. **Verifique com o administrador da conta AWS**
2. **Procure por emails antigos** que possam conter as credenciais
3. **Verifique documentação do projeto** em `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/`

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

