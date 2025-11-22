# 📋 PRÓXIMOS PASSOS: Após Configurar DNS

**Data:** 21/11/2025  
**Status:** ⏳ Aguardando verificação do domínio  
**Domínio:** `bssegurosimediato.com.br`

---

## ✅ PASSO 1: AGUARDAR PROPAGAÇÃO DNS

### **1.1. Tempo de Propagação**

- **Mínimo:** 5-10 minutos
- **Normal:** 30 minutos a 2 horas
- **Máximo:** 24-48 horas (raro)
- **Recomendado:** Aguardar 30 minutos antes de verificar

### **1.2. O Que Está Acontecendo?**

Os registros DNS que você configurou estão sendo propagados pelos servidores DNS ao redor do mundo. O AWS SES precisa conseguir ler esses registros para verificar que você realmente controla o domínio.

---

## 🔍 PASSO 2: VERIFICAR PROPAGAÇÃO DNS (OPCIONAL)

Você pode verificar se os registros foram propagados antes de verificar no AWS SES:

### **2.1. Verificar Registro TXT (SPF)**

1. Acesse: https://mxtoolbox.com/TXTLookup.aspx
2. Digite: `_amazonses.bssegurosimediato.com.br`
3. Clique em **"TXT Lookup"**
4. **Resultado esperado:** Deve aparecer o registro TXT que você configurou

**Se aparecer:** ✅ DNS propagado  
**Se não aparecer:** ⏳ Aguardar mais alguns minutos

### **2.2. Verificar Registros CNAME (DKIM)**

1. Acesse: https://mxtoolbox.com/CNAMELookup.aspx
2. Digite: `[chave1]._domainkey.bssegurosimediato.com.br` (substitua `[chave1]` pela chave real)
3. Clique em **"CNAME Lookup"**
4. **Resultado esperado:** Deve aparecer `[chave1].dkim.amazonses.com`

**Repita para cada registro CNAME**

**Se aparecer:** ✅ DNS propagado  
**Se não aparecer:** ⏳ Aguardar mais alguns minutos

---

## ✅ PASSO 3: VERIFICAR STATUS NO AWS SES

### **3.1. Acessar Console AWS SES**

1. Acesse: https://console.aws.amazon.com/ses
2. **IMPORTANTE:** Certifique-se de estar na **mesma região** que você usou para criar a identity
   - Provavelmente: **sa-east-1** (São Paulo) ou **us-east-1** (N. Virginia)
   - Verifique no canto superior direito

### **3.2. Verificar Status da Identity**

1. No menu lateral esquerdo, clique em **"Verified identities"**
2. Procure por `bssegurosimediato.com.br` na lista
3. Verifique o status:

**Status Possíveis:**

| Status | Significado | Ação |
|--------|-------------|------|
| 🟡 **"Pending verification"** | Aguardando verificação | ⏳ Aguardar mais alguns minutos e atualizar página (F5) |
| 🟢 **"Verified"** | Domínio verificado e pronto! | ✅ Prosseguir para Passo 4 |
| 🔴 **"Failed"** | Falha na verificação | ⚠️ Verificar registros DNS novamente |

### **3.3. Se Status Estiver "Pending verification"**

- ⏳ Aguarde mais 10-15 minutos
- 🔄 Atualize a página (F5)
- 🔄 Verifique novamente o status
- ⚠️ Se após 24 horas ainda estiver "Pending", verifique os registros DNS novamente

---

## 🔧 PASSO 4: VERIFICAR CONFIGURAÇÃO DO SERVIDOR

Após o domínio estar **"Verified"**, verifique se o código está usando o domínio correto.

### **4.1. Verificar Configuração Atual no Servidor DEV**

Execute este comando:

```bash
ssh root@65.108.156.14 "grep 'AWS_SES_FROM_EMAIL' /etc/php/8.3/fpm/pool.d/www.conf"
```

**Resultado esperado:**
```
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
```

### **4.2. Se Estiver Correto**

✅ **Não precisa fazer nada!** O código já está configurado corretamente.

### **4.3. Se Estiver Incorreto (mostra `bpsegurosimediato.com.br`)**

Você precisa atualizar a configuração:

```bash
# Conectar ao servidor DEV
ssh root@65.108.156.14

# Fazer backup do arquivo atual
cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_$(date +%Y%m%d_%H%M%S)

# Editar arquivo
nano /etc/php/8.3/fpm/pool.d/www.conf

# Localizar linha (aproximadamente linha 571):
env[AWS_SES_FROM_EMAIL] = noreply@bpsegurosimediato.com.br

# Alterar para:
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br

# Salvar e sair (Ctrl+X, Y, Enter)

# Testar configuração
php-fpm8.3 -t

# Se teste passar, recarregar PHP-FPM
systemctl reload php8.3-fpm
```

---

## 🧪 PASSO 5: TESTAR ENVIO DE EMAIL

Após o domínio estar verificado e a configuração do servidor estar correta, teste o envio de email.

### **5.1. Teste via cURL**

Execute este comando:

```bash
curl -X POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{
    "level": "INFO",
    "category": "EMAIL",
    "message": "Teste de email após verificação de domínio bssegurosimediato.com.br",
    "data": {
      "ddd": "11",
      "celular": "976543210",
      "momento": "test_verification"
    }
  }'
```

### **5.2. Verificar Resposta**

**Resposta esperada (sucesso):**
```json
{
  "success": true,
  "total_sent": 3,
  "total_failed": 0,
  "total_recipients": 3,
  "results": [
    {
      "email": "lrotero@gmail.com",
      "success": true,
      "message_id": "0100018a..."
    },
    {
      "email": "alex.kaminski@imediatoseguros.com.br",
      "success": true,
      "message_id": "0100018b..."
    },
    {
      "email": "alexkaminski70@gmail.com",
      "success": true,
      "message_id": "0100018c..."
    }
  ]
}
```

**Se aparecer erro:**
- Verifique os logs do servidor (Passo 5.3)
- Verifique se o domínio está realmente "Verified" no AWS SES

### **5.3. Verificar Logs do Servidor**

```bash
ssh root@65.108.156.14 "tail -50 /var/log/php8.3-fpm.log | grep -i 'SES\|email\|MessageId'"
```

**Procurar por:**
- ✅ `SES: Email enviado com sucesso`
- ✅ `MessageId: ...`
- ❌ Se aparecer erros, verificar logs detalhados

### **5.4. Verificar Recebimento**

1. Verificar caixa de entrada dos emails de administradores:
   - `lrotero@gmail.com`
   - `alex.kaminski@imediatoseguros.com.br`
   - `alexkaminski70@gmail.com`
2. Verificar pasta de **spam/lixo eletrônico** também
3. Aguardar alguns minutos (emails podem levar alguns minutos para chegar)

---

## ✅ CHECKLIST FINAL

Marque cada item conforme completar:

- [ ] **DNS configurado** (todos os registros TXT e CNAME adicionados)
- [ ] **Aguardou propagação** (30 minutos a 2 horas)
- [ ] **Status no AWS SES mostra "Verified"** ✅
- [ ] **Configuração do servidor verificada** (mostra `bssegurosimediato.com.br`)
- [ ] **PHP-FPM recarregado** (se foi necessário atualizar configuração)
- [ ] **Teste de envio realizado** (via cURL)
- [ ] **Resposta mostra `success: true`**
- [ ] **Emails recebidos pelos administradores** (verificar caixa de entrada e spam)

---

## 🚨 PROBLEMAS COMUNS E SOLUÇÕES

### **Problema 1: Status continua "Pending verification" após 24 horas**

**Possíveis causas:**
- Registros DNS não foram configurados corretamente
- Registros DNS foram configurados no painel errado
- Registros estão com "Proxied" ativado no Cloudflare (devem estar "DNS only")
- Propagação DNS está demorando mais que o normal

**Solução:**
1. Verificar novamente os registros DNS no painel
2. Verificar se os registros estão corretos usando ferramentas online (mxtoolbox.com)
3. Verificar se registros CNAME estão como "DNS only" (não "Proxied")
4. Aguardar mais algumas horas
5. Se persistir, deletar e recriar a identity no AWS SES

### **Problema 2: Email não está chegando após verificação**

**Possíveis causas:**
- AWS SES ainda está em modo sandbox
- Emails estão indo para spam
- Domínio não está completamente verificado

**Solução:**
1. Verificar se conta AWS SES está em sandbox (só envia para emails verificados)
2. Verificar pasta de spam dos destinatários
3. Verificar logs do AWS SES no console AWS
4. Solicitar saída do sandbox se necessário

### **Problema 3: Erro ao recarregar PHP-FPM**

**Possíveis causas:**
- Sintaxe incorreta no arquivo `www.conf`
- PHP-FPM não está rodando

**Solução:**
1. Verificar sintaxe: `php-fpm8.3 -t`
2. Se houver erro, corrigir e testar novamente
3. Se PHP-FPM não estiver rodando: `systemctl start php8.3-fpm`

---

## 📝 RESUMO DOS PRÓXIMOS PASSOS

1. ⏳ **Aguardar propagação DNS** (30 minutos a 2 horas)
2. ✅ **Verificar status no AWS SES** (deve mostrar "Verified")
3. 🔧 **Verificar configuração do servidor** (deve mostrar `bssegurosimediato.com.br`)
4. 🧪 **Testar envio de email** (via cURL)
5. 📧 **Verificar recebimento** (caixa de entrada e spam)

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

