# 📧 VERIFICAR EMAIL FROM NO AWS SES

**Data:** 21/11/2025  
**Status:** 🔍 **DIAGNÓSTICO**

---

## 🔍 PROBLEMA IDENTIFICADO

O erro indica que o email **FROM** (`noreply@bpsegurosimediato.com.br`) também precisa estar verificado:

```
Email address is not verified. The following identities failed the check in region US-EAST-1: 
lrotero@gmail.com, BP Seguros Imediato <noreply@bpsegurosimediato.com.br>
```

**Situação atual:**
- ✅ Domínio `bpsegurosimediato.com.br` está verificado
- ✅ Emails de destino estão verificados
- ❓ Email específico `noreply@bpsegurosimediato.com.br` pode não estar verificado

---

## ✅ SOLUÇÃO: VERIFICAR EMAIL FROM ESPECÍFICO

### **Opção 1: Verificar Email Específico (Recomendado)**

1. **No Console AWS SES:**
   - Vá para **"Verified identities"** → **"Email addresses"**
   - Clique em **"Create identity"** → **"Email address"**

2. **Digite o email FROM:**
   - `noreply@bpsegurosimediato.com.br`
   - Clique em **"Create identity"**

3. **Verifique o email:**
   - AWS enviará um email de verificação para `noreply@bpsegurosimediato.com.br`
   - ⚠️ **IMPORTANTE:** Você precisa ter acesso a essa caixa de entrada
   - Se não tiver acesso, use a Opção 2

### **Opção 2: Usar Domínio Verificado (Se DKIM/SPF Configurado)**

Se o domínio `bpsegurosimediato.com.br` está verificado com DKIM e SPF configurados corretamente, você **deve poder** enviar de qualquer email do domínio.

**Verificar configuração do domínio:**

1. **No Console AWS SES:**
   - Vá para **"Verified identities"** → **"Domains"**
   - Clique no domínio `bpsegurosimediato.com.br`

2. **Verifique:**
   - ✅ **DKIM:** Deve estar "Verified" (3 registros CNAME configurados)
   - ✅ **SPF:** Deve ter registro TXT configurado
   - ✅ **DMARC:** Recomendado ter configurado

3. **Se tudo estiver configurado:**
   - O problema pode ser que o AWS SES ainda está em **Sandbox**
   - No Sandbox, mesmo com domínio verificado, pode precisar verificar emails específicos

---

## 🔄 ALTERNATIVA: USAR EMAIL JÁ VERIFICADO

Se você não tem acesso à caixa de `noreply@bpsegurosimediato.com.br`, pode usar um email que já está verificado:

**Opções:**
- `alex.kaminski@imediatoseguros.com.br` (já verificado)
- `lrotero@gmail.com` (já verificado)
- `alexkaminski70@gmail.com` (já verificado)

**Para mudar temporariamente:**

1. **Editar arquivo PHP-FPM:**
   ```bash
   nano /etc/php/8.3/fpm/pool.d/www.conf
   ```

2. **Alterar:**
   ```ini
   env[AWS_SES_FROM_EMAIL] = alex.kaminski@imediatoseguros.com.br
   ```

3. **Recarregar:**
   ```bash
   systemctl reload php8.3-fpm
   ```

---

## 🎯 RECOMENDAÇÃO

**Para produção, o ideal é:**

1. ✅ Verificar o email `noreply@bpsegurosimediato.com.br` especificamente
2. ✅ OU garantir que o domínio está totalmente configurado (DKIM, SPF, DMARC)
3. ✅ Solicitar saída do Sandbox para não precisar verificar emails individuais

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

