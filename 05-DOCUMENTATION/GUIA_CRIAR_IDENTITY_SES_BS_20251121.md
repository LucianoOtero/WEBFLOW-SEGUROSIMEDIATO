# 🚀 GUIA PASSO A PASSO - Criar Identity AWS SES para bssegurosimediato.com.br

**Data:** 21/11/2025  
**Domínio:** `bssegurosimediato.com.br`  
**Objetivo:** Verificar domínio no AWS SES para permitir envio de emails

---

## 📋 PRÉ-REQUISITOS

- ✅ Acesso ao console AWS SES
- ✅ Acesso ao painel DNS do domínio `bssegurosimediato.com.br`
- ✅ Permissões para criar registros DNS

---

## 🌍 PASSO 1: ACESSAR CONSOLE SES E ESCOLHER REGIÃO

### **1.1. Acessar Console AWS SES**

1. Acesse: https://console.aws.amazon.com/ses
2. Faça login na sua conta AWS

### **1.2. Escolher Região**

⚠️ **IMPORTANTE:** Escolha a mesma região que você usou para `bpsegurosimediato.com.br`!

1. **No canto superior direito**, clique no dropdown de região
2. **Verifique qual região você usou para `bpsegurosimediato.com.br`**
   - Provavelmente: **sa-east-1** (São Paulo) ou **us-east-1** (N. Virginia)
3. **Selecione a mesma região** (recomendo manter consistente)

**Você verá:** Interface do SES na região selecionada

---

## ✅ PASSO 2: CRIAR NOVA IDENTITY

### **2.1. Acessar Verified Identities**

1. No menu lateral esquerdo, clique em **"Verified identities"**
2. Você verá a lista de identidades verificadas:
   - `bpsegurosimediato.com.br` ✅ Verified
   - `alex.kaminski@imediatoseguros.com.br` ✅ Verified
   - `lrotero@gmail.com` ✅ Verified
   - `alexkaminski70@gmail.com` ✅ Verified

### **2.2. Criar Nova Identity**

1. Clique no botão **"Create identity"** (canto superior direito)

### **2.3. Escolher Tipo de Identity**

1. Escolha: **"Domain"** (domínio completo)
   - ⚠️ **NÃO escolha "Email address"** (permite apenas um email)
2. Clique em **"Next"**

### **2.4. Informar Domínio**

1. No campo **"Domain"**, digite: `bssegurosimediato.com.br`
   - ⚠️ **Sem "www"** e **sem "http://"** - apenas o domínio
   - ⚠️ **Sem espaços** antes ou depois
2. Deixe as opções padrão marcadas:
   - ✅ **"Use a DKIM signing key pair"** (já vem marcado)
   - ✅ **"Easy DKIM"** (já selecionado)
3. Clique em **"Create identity"**

**Você verá:** Mensagem de sucesso e uma tela com **registros DNS a configurar**

---

## 📝 PASSO 3: COPIAR REGISTROS DNS

⚠️ **MOMENTO CRÍTICO:** Copie TODOS os registros antes de fechar esta tela!

### **3.1. Registros a Copiar**

Você verá uma seção chamada **"DNS records"** com vários registros:

**REGISTRO 1 - TXT (SPF):**
```
Tipo: TXT
Nome: _amazonses.bssegurosimediato.com.br
Valor: [Uma string longa gerada automaticamente]
```

**REGISTROS 2-4 - CNAME (DKIM):**
```
Tipo: CNAME
Nome: [chave1]._domainkey.bssegurosimediato.com.br
Valor: [chave1].dkim.amazonses.com

Tipo: CNAME
Nome: [chave2]._domainkey.bssegurosimediato.com.br
Valor: [chave2].dkim.amazonses.com

Tipo: CNAME
Nome: [chave3]._domainkey.bssegurosimediato.com.br
Valor: [chave3].dkim.amazonses.com
```

### **3.2. Salvar Registros**

⚠️ **IMPORTANTE:** 
- **Copie TODOS os registros** para um arquivo temporário
- **Ou tire print da tela**
- **Ou mantenha a aba aberta** até configurar no DNS

**Você precisará desses registros para configurar no DNS do domínio!**

---

## 🌐 PASSO 4: CONFIGURAR DNS NO PAINEL DO DOMÍNIO

Agora você precisa adicionar esses registros no DNS do seu domínio.

### **4.1. Acessar Painel DNS**

1. Acesse o painel onde o DNS de `bssegurosimediato.com.br` está gerenciado
   - Pode ser: Cloudflare, GoDaddy, Registro.br, AWS Route 53, etc.
2. Localize a seção de **"DNS Records"** ou **"Zona DNS"**

### **4.2. Adicionar Registro TXT (SPF)**

1. Clique em **"Add record"** ou **"Adicionar registro"**
2. Preencha:
   - **Tipo:** `TXT`
   - **Nome/Host:** 
     - Cole o nome completo: `_amazonses.bssegurosimediato.com.br`
     - ⚠️ Alguns painéis pedem apenas `_amazonses` (sem o domínio)
     - Se o painel pedir apenas o subdomínio, use: `_amazonses`
   - **Valor:** Cole o valor completo que copiou do SES
   - **TTL:** Deixar padrão (3600 ou auto)
3. Salvar

### **4.3. Adicionar Registros CNAME (DKIM)**

**Repita este processo para CADA registro CNAME:**

1. Clique em **"Add record"** ou **"Adicionar registro"**
2. Preencha:
   - **Tipo:** `CNAME`
   - **Nome/Host:** 
     - Cole o nome completo (ex: `xxxxxx._domainkey.bssegurosimediato.com.br`)
     - ⚠️ Alguns painéis pedem apenas o subdomínio (ex: `xxxxxx._domainkey`)
   - **Valor/Destino:** Cole o valor completo (ex: `xxxxxx.dkim.amazonses.com`)
   - **TTL:** Deixar padrão
3. Salvar

**Repita para todos os 3 registros CNAME (DKIM)**

---

## ⏱️ PASSO 5: AGUARDAR PROPAGAÇÃO DNS

### **5.1. Tempo de Propagação**

- **Mínimo:** 5-10 minutos
- **Máximo:** 24-48 horas (geralmente leva 1-2 horas)
- **Recomendado:** Aguardar 30 minutos antes de verificar

### **5.2. Verificar Propagação (Opcional)**

Você pode verificar se os registros foram propagados usando ferramentas online:

**Para registro TXT:**
1. Acesse: https://mxtoolbox.com/TXTLookup.aspx
2. Digite: `_amazonses.bssegurosimediato.com.br`
3. Verifique se aparece o registro TXT que você configurou

**Para registros CNAME:**
1. Acesse: https://mxtoolbox.com/CNAMELookup.aspx
2. Digite: `[chave]._domainkey.bssegurosimediato.com.br`
3. Verifique se aparece o registro CNAME que você configurou

---

## ✅ PASSO 6: VERIFICAR STATUS NO AWS SES

### **6.1. Voltar ao Console AWS SES**

1. Acesse: https://console.aws.amazon.com/ses
2. Certifique-se de estar na **mesma região** que você escolheu no Passo 1
3. Menu lateral → **"Verified identities"**

### **6.2. Verificar Status**

1. Procure por `bssegurosimediato.com.br` na lista
2. Verifique o status:
   - **"Pending verification"** ⏳ = Aguardando verificação (DNS ainda não propagou)
   - **"Verified"** ✅ = Domínio verificado e pronto para uso!

### **6.3. Se Status Estiver "Pending verification"**

- ⏳ Aguarde mais alguns minutos
- 🔄 Atualize a página (F5)
- ⚠️ Se após 24 horas ainda estiver "Pending", verifique os registros DNS novamente

---

## 🔧 PASSO 7: ATUALIZAR CONFIGURAÇÃO DO SERVIDOR

Após o domínio estar **"Verified"**, você precisa garantir que o código está usando o domínio correto.

### **7.1. Verificar Configuração Atual**

**No servidor DEV, verificar:**
```bash
ssh root@65.108.156.14 "grep 'AWS_SES_FROM_EMAIL' /etc/php/8.3/fpm/pool.d/www.conf"
```

**Resultado esperado:**
```
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
```

✅ **Se já está correto:** Pode pular para Passo 7.3

### **7.2. Atualizar Configuração (Se Necessário)**

**Se o resultado mostrar `bpsegurosimediato.com.br` ou outro valor:**

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

### **7.3. Atualizar Arquivo Local de Configuração**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.txt`

**Linha 571:**
```ini
# Garantir que está assim:
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
```

✅ **Se já está correto:** Não precisa alterar nada

---

## 🧪 PASSO 8: TESTAR ENVIO DE EMAIL

### **8.1. Teste via cURL**

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

### **8.2. Verificar Resposta**

**Resposta esperada:**
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
      "message_id": "..."
    },
    ...
  ]
}
```

### **8.3. Verificar Logs do Servidor**

```bash
ssh root@65.108.156.14 "tail -50 /var/log/php8.3-fpm.log | grep -i 'SES\|email\|MessageId'"
```

**Procurar por:**
- ✅ `SES: Email enviado com sucesso`
- ✅ `MessageId: ...`
- ❌ Se aparecer erros, verificar logs detalhados

### **8.4. Verificar Recebimento**

1. Verificar caixa de entrada dos emails de administradores:
   - `lrotero@gmail.com`
   - `alex.kaminski@imediatoseguros.com.br`
   - `alexkaminski70@gmail.com`
2. Verificar pasta de **spam/lixo eletrônico** também
3. Aguardar alguns minutos (emails podem levar alguns minutos para chegar)

---

## ✅ CHECKLIST FINAL

- [ ] Identity criada no AWS SES para `bssegurosimediato.com.br`
- [ ] Registros DNS configurados no painel do domínio
- [ ] Status no AWS SES mostra **"Verified"**
- [ ] Configuração do servidor atualizada (se necessário)
- [ ] PHP-FPM recarregado (se necessário)
- [ ] Teste de envio realizado
- [ ] Emails recebidos pelos administradores

---

## 🚨 PROBLEMAS COMUNS E SOLUÇÕES

### **Problema 1: Status continua "Pending verification" após 24 horas**

**Possíveis causas:**
- Registros DNS não foram configurados corretamente
- Registros DNS foram configurados no painel errado
- Propagação DNS está demorando mais que o normal

**Solução:**
1. Verificar novamente os registros DNS no painel
2. Verificar se os registros estão corretos usando ferramentas online (mxtoolbox.com)
3. Aguardar mais algumas horas
4. Se persistir, deletar e recriar a identity no AWS SES

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

## 📝 NOTAS IMPORTANTES

1. **Região AWS:** Sempre use a mesma região para todas as identities (recomendo `sa-east-1` para Brasil)

2. **Propagação DNS:** Pode levar de alguns minutos a 48 horas, mas geralmente leva 1-2 horas

3. **Sandbox Mode:** Se sua conta AWS SES estiver em sandbox, você só pode enviar para emails verificados. Para enviar para qualquer email, solicite saída do sandbox.

4. **Múltiplos Domínios:** Você pode ter múltiplos domínios verificados no AWS SES. Cada um precisa ter seus próprios registros DNS configurados.

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

