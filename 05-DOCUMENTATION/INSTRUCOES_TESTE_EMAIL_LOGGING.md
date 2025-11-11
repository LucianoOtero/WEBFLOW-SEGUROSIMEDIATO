# 🧪 INSTRUÇÕES PARA TESTE DE EMAIL NO LOGGING

**Data:** 09/11/2025  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Este documento fornece instruções para testar o envio automático de emails quando logs de nível ERROR ou FATAL são registrados.

---

## 📋 ARQUIVO DE TESTE

**Arquivo:** `test_email_logging_categories.php`  
**Localização no servidor:** `/opt/webhooks-server/dev/root/test_email_logging_categories.php`  
**URL de acesso:** `https://dev.bssegurosimediato.com.br/test_email_logging_categories.php`

---

## 🚀 COMO EXECUTAR O TESTE

### **Opção 1: Via Navegador (Recomendado)**

1. Abra o navegador
2. Acesse: `https://dev.bssegurosimediato.com.br/test_email_logging_categories.php`
3. A página mostrará:
   - Resultado de cada teste
   - Log ID de cada log registrado
   - Resumo dos testes
   - Instruções para verificar emails

### **Opção 2: Via CLI (Servidor)**

```bash
ssh root@65.108.156.14
docker exec webhooks-php-dev sh -c 'php /var/www/html/dev/root/test_email_logging_categories.php'
```

---

## 📊 TESTES REALIZADOS

O arquivo de teste executa **6 testes**:

### **Testes ERROR (3 testes):**
1. ✅ **ERROR - DATABASE:** Falha ao conectar ao banco de dados
2. ✅ **ERROR - API:** Erro ao chamar API externa
3. ✅ **ERROR - VALIDATION:** Erro de validação de dados

### **Testes FATAL (3 testes):**
4. ✅ **FATAL - SYSTEM:** Erro fatal no sistema (com exceção)
5. ✅ **FATAL - SECURITY:** Tentativa de acesso não autorizado (com exceção)
6. ✅ **FATAL - CRITICAL:** Erro crítico que impede funcionamento (com exceção)

---

## 📧 VERIFICAÇÃO DE EMAILS

### **Destinatários:**
Os emails devem ser recebidos pelos seguintes administradores:

1. `lrotero@gmail.com`
2. `alex.kaminski@imediatoseguros.com.br`
3. `alexkaminski70@gmail.com`

### **O que verificar:**

#### **Para ERROR:**
- ✅ Assunto: "❌ Erro no Sistema - Modal WhatsApp - (00) 000000000"
- ✅ Banner vermelho com "❌ Erro no Sistema"
- ✅ Mensagem do erro
- ✅ Categoria (DATABASE, API, VALIDATION)
- ✅ Dados adicionais (JSON)
- ✅ Arquivo e linha onde ocorreu
- ✅ Timestamp

#### **Para FATAL:**
- ✅ Assunto: "🚨 Erro Fatal no Sistema - Modal WhatsApp - (00) 000000000"
- ✅ Banner vermelho com "🚨 Erro Fatal no Sistema"
- ✅ Mensagem do erro
- ✅ Categoria (SYSTEM, SECURITY, CRITICAL)
- ✅ Dados adicionais (JSON)
- ✅ **Stack trace completo**
- ✅ Arquivo e linha onde ocorreu
- ✅ Timestamp

### **Quantidade Esperada:**
- ✅ **6 emails por administrador** (3 ERROR + 3 FATAL)
- ✅ **Total: 18 emails** (6 testes × 3 administradores)

---

## ⏱️ TEMPO DE ENTREGA

- ⏱️ **Tempo estimado:** 5-30 segundos após execução
- ⏱️ **Motivo:** Emails são enviados de forma assíncrona
- ⏱️ **Se não receber:** Verificar spam/lixo eletrônico

---

## 🔍 VERIFICAÇÃO NO BANCO DE DADOS

Para verificar se os logs foram salvos:

```sql
SELECT 
    level, 
    category, 
    LEFT(message, 60) as message, 
    file_name, 
    line_number,
    timestamp
FROM application_logs 
WHERE message LIKE '%Teste%' 
   OR message LIKE '%Falha ao conectar%'
   OR message LIKE '%Erro ao chamar%'
   OR message LIKE '%Erro de validação%'
   OR message LIKE '%Erro fatal%'
   OR message LIKE '%Tentativa de acesso%'
   OR message LIKE '%Erro crítico%'
ORDER BY id DESC 
LIMIT 6;
```

---

## ✅ CRITÉRIOS DE SUCESSO

### **Teste Bem-Sucedido se:**
- ✅ Todos os 6 logs foram salvos no banco de dados
- ✅ Todos os 6 logs têm Log ID válido
- ✅ Você recebeu 6 emails (3 ERROR + 3 FATAL)
- ✅ Cada email contém todas as informações do log
- ✅ Emails FATAL contêm stack trace completo

### **Se Algum Email Não For Recebido:**
1. Verificar spam/lixo eletrônico
2. Verificar logs do AWS SES no console AWS
3. Verificar logs do endpoint: `/var/log/php/dev/error.log`
4. Verificar se AWS SES está configurado corretamente
5. Verificar se emails estão verificados no AWS SES (se em sandbox)

---

## 🐛 TROUBLESHOOTING

### **Problema: Nenhum email recebido**

**Verificações:**
1. ✅ Verificar se `ProfessionalLogger.php` está atualizado no servidor
2. ✅ Verificar se `send_email_notification_endpoint.php` está acessível
3. ✅ Verificar logs do PHP: `tail -f /var/log/php/dev/error.log`
4. ✅ Verificar se AWS SES está funcionando
5. ✅ Verificar se emails estão verificados no AWS SES

### **Problema: Apenas alguns emails recebidos**

**Possíveis causas:**
- Rate limiting do endpoint (100 req/min)
- Falha temporária do AWS SES
- Emails em spam

**Solução:**
- Aguardar alguns minutos e verificar novamente
- Verificar logs do endpoint

---

## 📝 NOTAS IMPORTANTES

- ⚠️ **Não executar múltiplas vezes rapidamente** (pode atingir rate limit)
- ⚠️ **Aguardar entre execuções** (pelo menos 1 minuto)
- ⚠️ **Verificar spam** se emails não chegarem
- ✅ **Emails são assíncronos** (podem levar alguns segundos)

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Versão:** 1.0.0

