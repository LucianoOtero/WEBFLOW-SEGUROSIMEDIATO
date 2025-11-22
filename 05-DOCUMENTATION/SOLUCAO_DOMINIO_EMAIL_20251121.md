# ✅ SOLUÇÃO: Domínio do Email Remetente

**Data:** 21/11/2025  
**Status:** ⚠️ **AÇÃO NECESSÁRIA**  
**Problema:** Email não está chegando porque domínio do remetente não está verificado no AWS SES

---

## 🔍 SITUAÇÃO ATUAL

### **Domínios Verificados no AWS SES:**

| Identity | Tipo | Status |
|----------|------|--------|
| `bpsegurosimediato.com.br` | Domain | ✅ Verified |
| `alex.kaminski@imediatoseguros.com.br` | Email address | ✅ Verified |
| `lrotero@gmail.com` | Email address | ✅ Verified |
| `alexkaminski70@gmail.com` | Email address | ✅ Verified |

### **Configuração Atual do Código:**

- **Servidor DEV:** `env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br`
- **Domínio tentado:** `bssegurosimediato.com.br` ❌ **NÃO VERIFICADO**
- **Domínio verificado:** `bpsegurosimediato.com.br` ✅ **VERIFICADO**

---

## ⚠️ PROBLEMA IDENTIFICADO

**Causa Raiz:**
- Código está tentando enviar emails de `noreply@bssegurosimediato.com.br`
- Mas apenas `bpsegurosimediato.com.br` está verificado no AWS SES
- AWS SES **rejeita** emails de domínios não verificados
- Email não é entregue aos destinatários

---

## ✅ SOLUÇÕES DISPONÍVEIS

### **OPÇÃO 1: Usar Domínio Já Verificado (RECOMENDADO - MAIS RÁPIDO)**

**Vantagens:**
- ✅ Não requer alterações no DNS
- ✅ Não requer verificação no AWS SES
- ✅ Pode ser implementado imediatamente
- ✅ Domínio já está verificado e funcionando

**Desvantagens:**
- ⚠️ Usa domínio diferente do atual (`bp` vs `bs`)

**Ação Necessária:**
1. Atualizar `AWS_SES_FROM_EMAIL` no PHP-FPM config para `noreply@bpsegurosimediato.com.br`
2. Recarregar PHP-FPM
3. Testar envio de email

**Tempo estimado:** 5 minutos

---

### **OPÇÃO 2: Verificar Novo Domínio no AWS SES**

**Vantagens:**
- ✅ Usa domínio correto (`bssegurosimediato.com.br`)
- ✅ Mantém consistência com outros serviços

**Desvantagens:**
- ⚠️ Requer acesso ao DNS do domínio `bssegurosimediato.com.br`
- ⚠️ Requer configuração de registros DNS (SPF, DKIM, DMARC)
- ⚠️ Requer verificação no AWS SES
- ⚠️ Pode levar algumas horas para propagação DNS

**Ação Necessária:**
1. Criar nova identity no AWS SES para `bssegurosimediato.com.br`
2. Configurar registros DNS no domínio `bssegurosimediato.com.br`
3. Aguardar verificação no AWS SES
4. Testar envio de email

**Tempo estimado:** 1-24 horas (dependendo da propagação DNS)

---

## 📋 GUIA PASSO A PASSO

### **OPÇÃO 1: Usar Domínio Já Verificado**

#### **Passo 1: Atualizar PHP-FPM Config no Servidor DEV**

```bash
# Conectar ao servidor DEV
ssh root@65.108.156.14

# Fazer backup do arquivo atual
cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_$(date +%Y%m%d_%H%M%S)

# Editar arquivo
nano /etc/php/8.3/fpm/pool.d/www.conf

# Localizar linha:
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br

# Alterar para:
env[AWS_SES_FROM_EMAIL] = noreply@bpsegurosimediato.com.br

# Salvar e sair (Ctrl+X, Y, Enter)

# Testar configuração
php-fpm8.3 -t

# Recarregar PHP-FPM
systemctl reload php8.3-fpm
```

#### **Passo 2: Atualizar Arquivo Local de Configuração**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.txt`

**Linha 571:**
```ini
# ANTES:
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br

# DEPOIS:
env[AWS_SES_FROM_EMAIL] = noreply@bpsegurosimediato.com.br
```

#### **Passo 3: Testar Envio de Email**

```bash
# Testar via curl
curl -X POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{
    "level": "INFO",
    "category": "EMAIL",
    "message": "Teste de email após correção de domínio",
    "data": {
      "ddd": "11",
      "celular": "976543210",
      "momento": "test"
    }
  }'
```

---

### **OPÇÃO 2: Verificar Novo Domínio no AWS SES**

#### **Passo 1: Criar Identity no AWS SES**

1. Acessar console AWS SES: https://console.aws.amazon.com/ses
2. Selecionar região: `sa-east-1` (São Paulo)
3. Menu lateral → **"Verified identities"**
4. Clicar em **"Create identity"**
5. Escolher tipo: **"Domain"**
6. No campo **"Domain"**, digitar: `bssegurosimediato.com.br`
7. Deixar opções padrão marcadas:
   - ✅ **"Use a DKIM signing key pair"**
   - ✅ **"Easy DKIM"**
8. Clicar em **"Create identity"**

#### **Passo 2: Configurar Registros DNS**

**Você receberá 3 registros DNS para configurar:**

**REGISTRO 1 - TXT (SPF):**
```
Tipo: TXT
Nome: _amazonses.bssegurosimediato.com.br
Valor: [String longa gerada automaticamente]
TTL: 3600 (ou padrão)
```

**REGISTRO 2 - CNAME (DKIM):**
```
Tipo: CNAME
Nome: [chave1]._domainkey.bssegurosimediato.com.br
Valor: [chave1].dkim.amazonses.com
TTL: 3600 (ou padrão)
```

**REGISTRO 3 - CNAME (DKIM):**
```
Tipo: CNAME
Nome: [chave2]._domainkey.bssegurosimediato.com.br
Valor: [chave2].dkim.amazonses.com
TTL: 3600 (ou padrão)
```

**REGISTRO 4 - CNAME (DKIM):**
```
Tipo: CNAME
Nome: [chave3]._domainkey.bssegurosimediato.com.br
Valor: [chave3].dkim.amazonses.com
TTL: 3600 (ou padrão)
```

**Ação Necessária:**
1. Acessar painel DNS do domínio `bssegurosimediato.com.br`
2. Adicionar todos os registros acima
3. Aguardar propagação DNS (pode levar algumas horas)

#### **Passo 3: Aguardar Verificação**

1. Voltar ao console AWS SES
2. Verificar status da identity `bssegurosimediato.com.br`
3. Status mudará de **"Pending verification"** para **"Verified"** quando DNS propagar

#### **Passo 4: Testar Envio de Email**

Após verificação, testar envio de email conforme Passo 3 da Opção 1.

---

## 🎯 RECOMENDAÇÃO

**Recomendo OPÇÃO 1 (usar domínio já verificado)** porque:
- ✅ Implementação imediata (5 minutos)
- ✅ Não requer alterações no DNS
- ✅ Domínio já está verificado e funcionando
- ✅ Pode resolver o problema imediatamente

**Se preferir OPÇÃO 2 (verificar novo domínio):**
- ⚠️ Requer acesso ao DNS do domínio
- ⚠️ Pode levar algumas horas para propagação
- ✅ Mantém consistência com outros serviços usando `bssegurosimediato.com.br`

---

## 📝 PRÓXIMOS PASSOS

1. ✅ **Escolher opção** (1 ou 2)
2. ✅ **Implementar solução escolhida**
3. ✅ **Testar envio de email**
4. ✅ **Verificar se emails estão chegando**

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

