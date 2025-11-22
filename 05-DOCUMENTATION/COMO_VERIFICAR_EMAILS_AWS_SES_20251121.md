# 📧 COMO VERIFICAR EMAILS NO AWS SES

**Data:** 21/11/2025  
**Status:** 📋 **GUIA DE REFERÊNCIA**

---

## 🔍 VERIFICAR STATUS ATUAL

### **Passo 1: Acessar Console AWS SES**

1. **Acesse:** https://console.aws.amazon.com/ses/
2. **IMPORTANTE:** Verifique se está na região correta:
   - **US East (N. Virginia) us-east-1** ← **Esta é a região que estamos usando**

### **Passo 2: Verificar Identidades Existentes**

1. **No menu lateral esquerdo, clique em:**
   - **"Verified identities"** ou **"Identidades verificadas"**

2. **Você verá uma lista de identidades verificadas:**
   - **Domains** (Domínios)
   - **Email addresses** (Endereços de email)

3. **Verifique se os emails estão listados:**
   - `lrotero@gmail.com`
   - `alex.kaminski@imediatoseguros.com.br`
   - `alexkaminski70@gmail.com`

### **Passo 3: Verificar Status**

- ✅ **Se aparecer "Verified"** → Email já está verificado
- ❌ **Se não aparecer** → Precisa verificar novamente
- ⚠️ **Se aparecer em outra região** → Precisa verificar na região `us-east-1`

---

## ✅ COMO VERIFICAR UM EMAIL

### **Se o email NÃO estiver verificado:**

1. **Na página "Verified identities", clique em:**
   - **"Create identity"** ou **"Criar identidade"**

2. **Selecione:**
   - **"Email address"** (não Domain)

3. **Digite o email:**
   - Exemplo: `lrotero@gmail.com`
   - Clique em **"Create identity"**

4. **AWS enviará um email de verificação:**
   - 📧 Abra a caixa de entrada do email
   - 📧 Procure por email da AWS com assunto: "Amazon SES Address Verification Request"
   - 📧 Clique no link de verificação no email

5. **Após clicar no link:**
   - ✅ O email será verificado
   - ✅ Você verá "Verified" na lista

6. **Repita para cada email:**
   - `alex.kaminski@imediatoseguros.com.br`
   - `alexkaminski70@gmail.com`

---

## 🔄 VERIFICAR EM MÚLTIPLAS REGIÕES

**IMPORTANTE:** A verificação de email é **específica por região**. Se você verificou em `us-west-2` mas está usando `us-east-1`, precisa verificar novamente.

### **Como verificar em qual região está:**

1. **No topo direito do Console AWS SES, veja a região selecionada**
2. **Certifique-se de estar em:** `US East (N. Virginia) us-east-1`

### **Se precisar verificar em outra região:**

1. **Altere a região no seletor do topo**
2. **Repita o processo de verificação**

---

## 📋 CHECKLIST DE VERIFICAÇÃO

- [ ] Acessar Console AWS SES
- [ ] Verificar região: `us-east-1`
- [ ] Ir em "Verified identities"
- [ ] Verificar se `lrotero@gmail.com` está listado e "Verified"
- [ ] Verificar se `alex.kaminski@imediatoseguros.com.br` está listado e "Verified"
- [ ] Verificar se `alexkaminski70@gmail.com` está listado e "Verified"
- [ ] Se algum não estiver verificado, criar identidade e verificar via email

---

## 🎯 APÓS VERIFICAR

Após verificar todos os emails, teste novamente:

```bash
curl -k -s https://127.0.0.1/TMP/test_email_direct.php | grep -E "success|error"
```

Se aparecer `"success": true`, está funcionando! 🎉

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

