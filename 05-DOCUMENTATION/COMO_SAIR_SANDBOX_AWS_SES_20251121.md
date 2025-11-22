# 📧 COMO SAIR DO SANDBOX DO AWS SES

**Data:** 21/11/2025  
**Status:** 📋 **GUIA DE REFERÊNCIA**

---

## 🎯 PROBLEMA IDENTIFICADO

O AWS SES está em modo **Sandbox** (ambiente de teste). No Sandbox:
- ✅ Você só pode enviar emails para **endereços verificados**
- ❌ Não pode enviar para qualquer email
- ✅ Ideal para testes
- ❌ Não adequado para produção

---

## ✅ SOLUÇÃO: SAIR DO SANDBOX

### **Passo 1: Acessar o Console AWS SES**

1. **Acesse:** https://console.aws.amazon.com/ses/
2. **Selecione a região:** `US East (N. Virginia) us-east-1` (ou a região que você está usando)

### **Passo 2: Acessar Account Dashboard**

1. **No menu lateral esquerdo, clique em:**
   - **"Account dashboard"** ou **"Painel da conta"**

2. **Você verá uma seção chamada:**
   - **"Sending statistics"** ou **"Estatísticas de envio"**
   - **"Account status"** ou **"Status da conta"**

### **Passo 3: Verificar Status Atual**

1. **Procure por:**
   - **"Sending mode"** ou **"Modo de envio"**
   - Se aparecer **"Sandbox"**, você está em modo de teste

### **Passo 4: Solicitar Acesso de Produção**

1. **Na mesma página, procure por:**
   - **"Request production access"** ou **"Solicitar acesso de produção"**
   - **"Move out of the Amazon SES sandbox"** ou **"Sair do sandbox do Amazon SES"**

2. **Clique no botão:** **"Request production access"**

### **Passo 5: Preencher Formulário**

Você precisará fornecer:

1. **Mail Type (Tipo de Email):**
   - **Transactional** (Transacional) - Para notificações, confirmações, etc.
   - **Marketing** (Marketing) - Para campanhas, newsletters, etc.
   - **Ambos** - Se você enviar ambos os tipos

2. **Website URL:**
   - URL do seu site: `https://dev.bssegurosimediato.com.br` ou `https://bssegurosimediato.com.br`

3. **Use case description (Descrição do caso de uso):**
   - Exemplo:
   ```
   Envio de notificações transacionais para administradores quando 
   clientes preenchem formulários de cotação de seguros no site 
   bssegurosimediato.com.br. Os emails são enviados apenas para 
   administradores internos (lrotero@gmail.com, alex.kaminski@imediatoseguros.com.br, 
   alexkaminski70@gmail.com) e não são emails de marketing.
   ```

4. **Compliance:**
   - Marque as caixas sobre:
     - **SPF records** (já configurado se você verificou o domínio)
     - **DKIM records** (já configurado se você verificou o domínio)
     - **DMARC policy** (recomendado ter configurado)

5. **Acknowledgment (Reconhecimento):**
   - Marque que você entende as políticas do AWS SES

### **Passo 6: Enviar Solicitação**

1. **Revise todas as informações**
2. **Clique em "Submit request"** ou **"Enviar solicitação"**

### **Passo 7: Aguardar Aprovação**

- ⏱️ **Tempo estimado:** 24-48 horas
- 📧 **Você receberá um email** quando a solicitação for aprovada
- ✅ **Após aprovação:** Você poderá enviar para qualquer email

---

## 🔄 SOLUÇÃO TEMPORÁRIA: VERIFICAR EMAILS DE DESTINO

Enquanto aguarda a aprovação, você pode verificar os emails de destino:

### **Passo 1: Verificar Email Address**

1. **No Console AWS SES:**
   - Vá para **"Verified identities"** → **"Email addresses"**
   - Clique em **"Create identity"** → **"Email address"**

2. **Digite o email:**
   - `lrotero@gmail.com`
   - Clique em **"Create identity"**

3. **Verifique o email:**
   - AWS enviará um email de verificação
   - Abra o email e clique no link de verificação

4. **Repita para cada email:**
   - `alex.kaminski@imediatoseguros.com.br`
   - `alexkaminski70@gmail.com`

### **Passo 2: Testar Envio**

Após verificar os emails, o envio deve funcionar mesmo no Sandbox.

---

## 📋 CHECKLIST

- [ ] Credenciais AWS atualizadas no servidor ✅
- [ ] PHP-FPM recarregado ✅
- [ ] Credenciais funcionando (erro mudou de `InvalidClientTokenId` para `MessageRejected`) ✅
- [ ] Solicitar saída do Sandbox AWS SES
- [ ] Aguardar aprovação (24-48h)
- [ ] OU verificar emails de destino temporariamente

---

## 🎯 PRÓXIMOS PASSOS

1. **Imediato:** Verificar os 3 emails de destino para funcionar agora
2. **Produção:** Solicitar saída do Sandbox para funcionar com qualquer email

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

