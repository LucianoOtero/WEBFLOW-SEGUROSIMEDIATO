# 🔒 ANÁLISE: Bloqueio de Portas 25 e 465 - Hetzner

**Data:** 25/11/2025  
**Contexto:** Transferência de servidor entre projetos Hetzner  
**Mensagem Recebida:** "Outgoing traffic to ports 25 and 465 are blocked on this server after transfer. Sending mails from this server will no longer be possible."

---

## 📋 RESUMO EXECUTIVO

### **✅ IMPACTO NO SISTEMA ATUAL: ZERO**

**Motivo:**
- ✅ Sistema usa **AWS SES** (API REST), não SMTP direto
- ✅ AWS SES usa **HTTPS (porta 443)**, não portas 25/465
- ✅ Bloqueio de portas SMTP **NÃO afeta** envio via AWS SES

**Conclusão:**
- ✅ **Nenhuma ação necessária**
- ✅ Emails continuarão funcionando normalmente
- ✅ Sistema não será afetado

---

## 🔍 O QUE SIGNIFICA O BLOQUEIO?

### **Portas Bloqueadas:**

**Porta 25 (SMTP):**
- Usada para envio de emails via SMTP tradicional
- Bloqueada para prevenir spam

**Porta 465 (SMTPS):**
- Usada para envio de emails via SMTP com SSL/TLS
- Bloqueada para prevenir spam

### **Por Que o Hetzner Bloqueia:**

**Motivo:**
- ✅ Prevenir servidores comprometidos de enviar spam
- ✅ Reduzir risco de IPs serem listados em blacklists
- ✅ Política padrão para **TODOS os servidores** (não apenas transferências)

**Quando é Bloqueado:**
- ✅ **TODOS os servidores** por padrão (política geral)
- Servidores novos
- Transferências entre projetos
- Servidores com histórico de spam

**⚠️ IMPORTANTE:**
- ❌ **NÃO é apenas na transferência** - é política padrão permanente
- ✅ Bloqueio permanece até solicitação de desbloqueio ser aprovada

---

## 🔍 COMO O SISTEMA ATUAL ENVIA EMAILS?

### **Arquitetura Atual:**

```
Aplicação PHP
    ↓
AWS SES SDK (PHP)
    ↓
HTTPS (porta 443)
    ↓
AWS SES API (REST)
    ↓
Entrega de Email
```

### **Detalhes Técnicos:**

**1. Biblioteca Usada:**
- ✅ **AWS SDK for PHP** (`aws/aws-sdk-php`)
- ✅ Cliente: `\Aws\Ses\SesClient`

**2. Protocolo:**
- ✅ **HTTPS (porta 443)** - API REST da AWS
- ❌ **NÃO usa SMTP** (portas 25, 465, 587)

**3. Configuração:**
```php
$sesClient = new \Aws\Ses\SesClient([
    'version' => 'latest',
    'region'  => AWS_REGION,
    'credentials' => [
        'key'    => AWS_ACCESS_KEY_ID,
        'secret' => AWS_SECRET_ACCESS_KEY,
    ],
    'http' => [
        'timeout' => 10,
        'connect_timeout' => 5,
    ],
]);
```

**4. Endpoint AWS SES:**
- ✅ `https://email.sa-east-1.amazonaws.com` (porta 443)
- ✅ **NÃO usa** `smtp.email.amazonaws.com` (porta 25/465/587)

---

## ✅ POR QUE NÃO AFETA O SISTEMA?

### **Comparação:**

| Aspecto | SMTP (Portas 25/465) | AWS SES API (Porta 443) |
|--------|---------------------|-------------------------|
| **Porta** | 25, 465, 587 | 443 (HTTPS) |
| **Protocolo** | SMTP/SMTPS | HTTPS (REST API) |
| **Bloqueio Hetzner** | ❌ Bloqueado | ✅ **NÃO bloqueado** |
| **Sistema Atual** | ❌ Não usa | ✅ **USA** |

### **Conclusão:**

✅ **Sistema atual usa porta 443 (HTTPS)**
- ✅ Porta 443 **NÃO está bloqueada** pelo Hetzner
- ✅ AWS SES API funciona normalmente
- ✅ Emails continuarão sendo enviados

---

## ⚠️ QUANDO SERIA UM PROBLEMA?

### **Cenários que Seriam Afetados:**

**1. Se o Sistema Usasse SMTP Direto:**
```php
// ❌ ISSO seria afetado (mas não é o caso)
$mail = new PHPMailer();
$mail->isSMTP();
$mail->Host = 'smtp.gmail.com';
$mail->Port = 465; // ❌ Bloqueado
```

**2. Se o Sistema Usasse Sendmail:**
```php
// ❌ ISSO seria afetado (mas não é o caso)
mail($to, $subject, $message); // Usa porta 25
```

**3. Se o Sistema Usasse SMTP do AWS SES:**
```php
// ❌ ISSO seria afetado (mas não é o caso)
$mail->Host = 'email-smtp.sa-east-1.amazonaws.com';
$mail->Port = 465; // ❌ Bloqueado
```

### **Cenários que NÃO São Afetados:**

✅ **AWS SES via API REST (porta 443)** - **CASO ATUAL**
✅ **Serviços de email via API** (SendGrid, Mailgun, etc.)
✅ **Qualquer serviço que use HTTPS**

---

## 🔍 VERIFICAÇÃO: COMO CONFIRMAR QUE ESTÁ FUNCIONANDO?

### **1. Verificar Configuração Atual:**

**Arquivo:** `send_admin_notification_ses.php`

**Verificar:**
- ✅ Usa `\Aws\Ses\SesClient` (API REST)
- ✅ **NÃO usa** `PHPMailer` com SMTP
- ✅ **NÃO usa** `mail()` do PHP
- ✅ **NÃO usa** `sendmail`

### **2. Testar Envio de Email:**

**Opção 1: Teste Manual**
```bash
# Acessar endpoint de teste (se existir)
curl https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php
```

**Opção 2: Verificar Logs**
```bash
# Verificar logs de envio de email
ssh root@dev.bssegurosimediato.com.br "grep -i 'email enviado' /var/log/php8.3-fpm.log | tail -5"
```

### **3. Verificar Conexão com AWS SES:**

**Teste de Conectividade:**
```bash
# Testar conexão HTTPS com AWS SES
curl -I https://email.sa-east-1.amazonaws.com
```

**Resultado Esperado:**
- ✅ Conexão bem-sucedida (porta 443 funciona)
- ✅ Resposta HTTP da AWS

---

## 📊 COMPARAÇÃO: SMTP vs API REST

### **SMTP (Portas 25/465) - BLOQUEADO:**

**Vantagens:**
- ✅ Padrão universal
- ✅ Compatível com qualquer servidor de email

**Desvantagens:**
- ❌ Requer portas específicas (25, 465, 587)
- ❌ Pode ser bloqueado por provedores
- ❌ Mais complexo de configurar
- ❌ **BLOQUEADO no Hetzner após transferência**

### **API REST (Porta 443) - FUNCIONANDO:**

**Vantagens:**
- ✅ Usa HTTPS (porta 443) - nunca bloqueada
- ✅ Mais seguro (autenticação via API keys)
- ✅ Melhor para aplicações modernas
- ✅ **NÃO é afetado por bloqueios SMTP**
- ✅ ✅ **CASO ATUAL - FUNCIONANDO**

**Desvantagens:**
- ⚠️ Requer SDK/biblioteca específica
- ⚠️ Depende de serviço externo (AWS SES)

---

## ✅ CONCLUSÃO

### **Resposta Direta:**

**❓ "O bloqueio das portas 25 e 465 afeta o sistema?"**

**✅ NÃO - Zero impacto no sistema atual**

**Motivos:**
1. ✅ Sistema usa **AWS SES via API REST** (porta 443)
2. ✅ Porta 443 **NÃO está bloqueada** pelo Hetzner
3. ✅ Bloqueio afeta apenas **SMTP direto** (portas 25/465)
4. ✅ Sistema **NÃO usa SMTP direto**

### **Ações Necessárias:**

**✅ NENHUMA ação necessária**
- ✅ Emails continuarão funcionando normalmente
- ✅ Sistema não precisa ser modificado
- ✅ Configuração atual está correta

### **Recomendação:**

**✅ Continuar usando AWS SES via API REST**
- ✅ Mais seguro
- ✅ Não é afetado por bloqueios SMTP
- ✅ Melhor para produção

---

## 📋 CHECKLIST DE VERIFICAÇÃO

**Após Transferência do Servidor:**

- [ ] Verificar que emails estão sendo enviados normalmente
- [ ] Verificar logs de envio de email
- [ ] Confirmar que AWS SES está respondendo (porta 443)
- [ ] Testar envio de email de notificação
- [ ] Documentar que sistema não é afetado

**Status Atual:**
- ✅ Sistema usa AWS SES via API REST (porta 443)
- ✅ Porta 443 não está bloqueada
- ✅ Nenhuma ação necessária

---

## 📚 DOCUMENTAÇÃO OFICIAL HETZNER

### **Política de Bloqueio:**

**Fonte:** [Documentação Oficial Hetzner](https://docs.hetzner.com/cloud/servers/faq)

**Resumo:**
- ✅ Portas 25 e 465 são bloqueadas **por padrão em TODOS os servidores**
- ❌ **NÃO é apenas na transferência** - é política permanente
- ✅ Bloqueio permanece até solicitação de desbloqueio ser aprovada

### **Como Desbloquear as Portas 25 e 465:**

**Requisitos Obrigatórios:**
1. ✅ **Tempo de uso:** Conta ativa por pelo menos **1 mês**
2. ✅ **Pagamento:** Primeira fatura **paga**
3. ✅ **Solicitação formal:** Enviar solicitação detalhando o caso de uso

**Processo:**
1. Acessar suporte do Hetzner
2. Enviar solicitação formal explicando:
   - Por que precisa das portas 25/465
   - Caso de uso específico
   - Garantias de que não será usado para spam
3. Aguardar avaliação (caso a caso)
4. Se aprovado, Hetzner desbloqueia as portas

**Tempo Estimado:**
- ⚠️ Depende da avaliação do suporte
- ⚠️ Pode levar alguns dias úteis

### **Alternativa: Porta 587 (NÃO BLOQUEADA)**

**Importante:**
- ✅ **Porta 587 NÃO está bloqueada** pelo Hetzner
- ✅ Pode ser usada para envio de emails via SMTP
- ✅ Não requer solicitação de desbloqueio
- ✅ Funciona imediatamente

**Quando Usar Porta 587:**
- Se precisar usar SMTP direto (não é o caso atual)
- Se quiser evitar processo de desbloqueio
- Se serviço de email suportar porta 587

**Exemplo:**
```php
// Se fosse necessário usar SMTP (não é o caso)
$mail->Port = 587; // ✅ NÃO bloqueada
$mail->SMTPSecure = 'tls';
```

---

## ✅ CONCLUSÃO ATUALIZADA

### **Resposta às Perguntas:**

**❓ "O bloqueio ocorre apenas na transferência?"**

**❌ NÃO** - O bloqueio é política padrão para **TODOS os servidores**, não apenas transferências.

**❓ "É possível desbloquear depois?"**

**✅ SIM** - É possível desbloquear, mas requer:
- Conta ativa há pelo menos 1 mês
- Primeira fatura paga
- Solicitação formal ao suporte Hetzner
- Avaliação caso a caso

**❓ "Precisa desbloquear para o sistema atual?"**

**❌ NÃO** - Sistema atual usa AWS SES via API REST (porta 443), que **NÃO está bloqueada**.

### **Recomendação:**

**✅ NÃO é necessário desbloquear as portas 25/465**
- ✅ Sistema atual não usa essas portas
- ✅ AWS SES via API REST funciona perfeitamente
- ✅ Não há necessidade de mudar para SMTP

**Se no futuro precisar usar SMTP:**
- ✅ Usar porta 587 (não bloqueada)
- ✅ Ou solicitar desbloqueio das portas 25/465 (se atender requisitos)

---

**Documento criado em:** 25/11/2025  
**Atualizado em:** 25/11/2025 (com informações da documentação oficial Hetzner)  
**Status:** ✅ **ANÁLISE COMPLETA - DOCUMENTAÇÃO OFICIAL CONSULTADA**

