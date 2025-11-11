# 🔐 GUIA COMPLETO - INSTALAÇÃO E USO DO BITWARDEN

**Data:** 11/11/2025  
**Objetivo:** Armazenar credenciais AWS SES de forma segura

---

## 📥 INSTALAÇÃO DO BITWARDEN

### **Opção 1: Extensão para Navegador (Recomendado para uso diário)**

#### **Google Chrome / Microsoft Edge:**
1. Acesse: https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb
2. Clique em **"Adicionar ao Chrome"**
3. Confirme a instalação

#### **Mozilla Firefox:**
1. Acesse: https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/
2. Clique em **"Adicionar ao Firefox"**
3. Confirme a instalação

### **Opção 2: Aplicativo Desktop (Windows)**

1. Acesse: https://bitwarden.com/download/
2. Baixe o instalador para Windows
3. Execute o instalador
4. Siga as instruções de instalação

### **Opção 3: Aplicativo Mobile**

#### **Android:**
- Google Play Store: https://play.google.com/store/apps/details?id=com.x8bit.bitwarden

#### **iOS:**
- App Store: https://apps.apple.com/app/bitwarden/id1352778147

---

## 🚀 CONFIGURAÇÃO INICIAL

### **Passo 1: Criar Conta Gratuita**

1. Acesse: https://vault.bitwarden.com/
2. Clique em **"Create Account"** (Criar Conta)
3. Preencha:
   - Email: seu email
   - Nome: seu nome
   - Senha Mestra: **Crie uma senha forte e segura** (você precisará dela para acessar tudo)
   - Confirme a senha
4. Aceite os termos
5. Clique em **"Submit"** (Enviar)

### **Passo 2: Verificar Email**

1. Verifique sua caixa de entrada
2. Clique no link de verificação enviado pelo Bitwarden
3. Sua conta estará ativada

### **Passo 3: Fazer Login**

1. Na extensão do navegador ou aplicativo:
   - Clique no ícone do Bitwarden
   - Digite seu email e senha mestra
   - Clique em **"Unlock"** (Desbloquear)

---

## 💾 SALVAR CREDENCIAIS AWS SES

### **Método 1: Criar Item Manualmente**

1. **Abra o Bitwarden** (clique no ícone no navegador)
2. Clique em **"+"** (Adicionar Item) ou **"Add Item"**
3. Selecione **"Secure Note"** ou **"Card"**
4. Preencha:

   **Nome:** `AWS SES - Seguros Imediato`
   
   **Tipo:** Secure Note
   
   **Notas:**
   ```
   AWS Access Key ID: [CONFIGURE_AWS_ACCESS_KEY_ID]
   AWS Secret Access Key: [CONFIGURE_AWS_SECRET_ACCESS_KEY]
   AWS Region: sa-east-1
   
   Uso: Configuração AWS SES para envio de emails de notificação
   Projeto: WEBFLOW-SEGUROSIMEDIATO
   Data: 11/11/2025
   ```

5. Clique em **"Save"** (Salvar)

### **Método 2: Usar Template de Login (Recomendado)**

1. Clique em **"+"** (Adicionar Item)
2. Selecione **"Login"**
3. Preencha:

   **Nome:** `AWS SES - Seguros Imediato`
   
   **Username:** `[CONFIGURE_AWS_ACCESS_KEY_ID]` (Access Key ID)
   
   **Password:** `[CONFIGURE_AWS_SECRET_ACCESS_KEY]` (Secret Access Key)
   
   **URI:** `https://console.aws.amazon.com/ses/`
   
   **Notas:**
   ```
   AWS Region: sa-east-1
   
   Uso: Configuração AWS SES para envio de emails de notificação
   Projeto: WEBFLOW-SEGUROSIMEDIATO
   Data: 11/11/2025
   
   Arquivos locais:
   - .env.local (WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/)
   - CREDENCIAIS_AWS_REFERENCIA.txt
   ```

4. Clique em **"Save"** (Salvar)

---

## 🔍 COMO ACESSAR AS CREDENCIAIS

### **Via Extensão do Navegador:**

1. Clique no ícone do Bitwarden na barra de ferramentas
2. Digite sua senha mestra (se necessário)
3. Procure por **"AWS SES"** na busca
4. Clique no item
5. As credenciais estarão visíveis

### **Via Aplicativo Desktop:**

1. Abra o aplicativo Bitwarden
2. Faça login com sua senha mestra
3. Use a busca para encontrar **"AWS SES"**
4. Clique no item para ver as credenciais

### **Via Site (Vault):**

1. Acesse: https://vault.bitwarden.com/
2. Faça login
3. Use a busca para encontrar **"AWS SES"**
4. Clique no item para ver as credenciais

---

## 🔐 RECOMENDAÇÕES DE SEGURANÇA

### **Senha Mestra:**

- ✅ Use uma senha **forte e única**
- ✅ **NUNCA compartilhe** sua senha mestra
- ✅ Considere usar uma **frase-senha** (passphrase)
- ✅ Exemplo: `MinhaCasa@2025#Segura!`

### **Autenticação de Dois Fatores (2FA):**

1. Acesse: https://vault.bitwarden.com/
2. Vá em **Settings** → **Security**
3. Ative **Two-step Login**
4. Escolha um método (Authenticator App recomendado)
5. Siga as instruções

### **Backup:**

- ✅ Bitwarden faz backup automático na nuvem
- ✅ Você pode exportar suas credenciais (Settings → Tools → Export Vault)
- ✅ **Mantenha** o arquivo de exportação em local seguro

---

## 📋 CHECKLIST DE CONFIGURAÇÃO

- [ ] Bitwarden instalado (extensão ou aplicativo)
- [ ] Conta criada no Bitwarden
- [ ] Email verificado
- [ ] Login realizado com sucesso
- [ ] Credenciais AWS SES salvas no Bitwarden
- [ ] Autenticação de dois fatores ativada (recomendado)
- [ ] Senha mestra forte configurada

---

## 🆘 TROUBLESHOOTING

### **Esqueci minha senha mestra:**
- ⚠️ **Não há recuperação** - você perderá acesso a todas as credenciais
- ✅ Use a opção de **"Export Vault"** regularmente como backup
- ✅ Considere usar um **gerenciador de senhas mestras** separado

### **Extensão não funciona:**
- Verifique se está logado
- Tente fazer logout e login novamente
- Reinstale a extensão se necessário

### **Sincronização não funciona:**
- Verifique sua conexão com a internet
- Clique em **"Sync"** manualmente no Bitwarden
- Verifique se está logado na mesma conta em todos os dispositivos

---

## 📚 RECURSOS ADICIONAIS

- **Site oficial:** https://bitwarden.com
- **Documentação:** https://bitwarden.com/help/
- **Blog de segurança:** https://bitwarden.com/blog/
- **Fórum da comunidade:** https://community.bitwarden.com/

---

## ✅ PRÓXIMOS PASSOS

Após salvar as credenciais no Bitwarden:

1. ✅ Verificar se as credenciais estão salvas corretamente
2. ✅ Testar acesso às credenciais
3. ✅ Considerar remover o arquivo `CREDENCIAIS_AWS_REFERENCIA.txt` (opcional, após confirmar que está no Bitwarden)
4. ✅ Manter o `.env.local` para uso local (mais prático para desenvolvimento)

---

**Última atualização:** 11/11/2025

