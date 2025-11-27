# 🔍 ANÁLISE: Erros de Conexão entre FlyingDonkeys e bssegurosimediato

**Data:** 25/11/2025  
**Status:** 🔍 **ANÁLISE COMPLETA - APENAS INVESTIGAÇÃO**  
**Frequência:** 1-2 erros por dia  
**Ambiente:** Production

---

## 📊 SUMÁRIO EXECUTIVO

Erros estão sendo reportados diariamente com a mensagem "Erro ao enviar notificação" na categoria EMAIL. Os erros são capturados no `ProfessionalLogger.php` linha 444 (dentro de `captureCallerInfo()`), mas essa é apenas a localização onde o stack trace é capturado, não onde o erro real está ocorrendo.

### **Fluxo do Erro Identificado:**

1. **MODAL_WHATSAPP_DEFINITIVO.js:840** → `sendAdminEmailNotification()` captura exceção
2. **FooterCodeSiteDefinitivoCompleto.js:430** → `sendLogToProfessionalSystem()` envia log ERROR
3. **log_endpoint.php** → Recebe log e chama `ProfessionalLogger->log('ERROR', ...)`
4. **ProfessionalLogger.php:859** → Detecta ERROR e chama `sendEmailNotification()`
5. **ProfessionalLogger.php:1053** → `file_get_contents()` tenta chamar `send_email_notification_endpoint.php`
6. **Erro ocorre** → Mas não há logs detalhados suficientes para identificar a causa raiz

---

## 🔍 ANÁLISE DETALHADA DO FLUXO

### **1. Origem do Erro (MODAL_WHATSAPP_DEFINITIVO.js)**

**Linha 838-846:**
```javascript
catch (error) {
  if (window.novo_log) {
    window.novo_log('ERROR', 'EMAIL', 'Erro ao enviar notificação', error, 'ERROR_HANDLING', 'VERBOSE');
  }
  return {
    success: false,
    error: error.message
  };
}
```

**Problema identificado:**
- ❌ O erro capturado pode ser de várias origens:
  - Timeout na requisição fetch para `send_email_notification_endpoint.php`
  - Erro de rede (DNS, conexão, SSL)
  - Erro de parse JSON na resposta
  - Erro de validação no endpoint
- ❌ O log não inclui informações suficientes sobre:
  - Status HTTP da resposta
  - Tempo de resposta
  - Tipo de erro (network, timeout, parse, etc.)
  - URL completa que foi chamada
  - Payload que foi enviado

### **2. Envio do Log (FooterCodeSiteDefinitivoCompleto.js)**

**Linha 430 (stack trace mostra):**
- `sendLogToProfessionalSystem()` é chamado com nível ERROR
- O erro original é passado como `data` no log
- Mas o objeto `error` JavaScript pode não ser serializado corretamente

**Problema identificado:**
- ⚠️ Objetos Error do JavaScript podem não ser serializados corretamente para JSON
- ⚠️ Informações importantes (stack, name, code) podem ser perdidas

### **3. Processamento do Log (ProfessionalLogger.php)**

**Linha 857-864:**
```php
if ($logId !== false && ($level === 'ERROR' || $level === 'FATAL') && !$isInsideEmailEndpoint) {
    try {
        $this->sendEmailNotification($level, $message, $data, $category, $stackTrace, $logData);
    } catch (Exception $e) {
        // Silenciosamente ignorar erros de envio de email (não quebrar aplicação)
        error_log('[ProfessionalLogger] Erro ao enviar email de notificação: ' . $e->getMessage());
    }
}
```

**Problema identificado:**
- ✅ Erros são capturados e logados em `error_log()`
- ❌ Mas não há verificação se o erro é relacionado a conexão com flyingdonkeys
- ❌ Não há distinção entre erros de rede e erros de processamento

### **4. Envio de Email (ProfessionalLogger.php::sendEmailNotification)**

**Linha 1053-1068:**
```php
$result = @file_get_contents($endpoint, false, $context);

if ($result === false) {
    $error = error_get_last();
    error_log("[ProfessionalLogger] Falha ao enviar email: " . ($error['message'] ?? 'Erro desconhecido') . " | Endpoint: " . $endpoint);
} else {
    $responseData = @json_decode($result, true);
    if ($responseData && isset($responseData['success'])) {
        error_log("[ProfessionalLogger] Email enviado: " . ($responseData['success'] ? 'SUCESSO' : 'FALHOU') . " | Total enviado: " . ($responseData['total_sent'] ?? 0) . " | Endpoint: " . $endpoint);
    } else {
        error_log("[ProfessionalLogger] Resposta inesperada do endpoint: " . substr($result, 0, 200) . " | Endpoint: " . $endpoint);
    }
}
```

**Problema identificado:**
- ✅ Há logs em `error_log()`, mas:
  - ❌ Não há log do tempo de resposta
  - ❌ Não há log do status HTTP (se houver)
  - ❌ Não há log de tentativas de retry
  - ❌ Não há log de timeout específico
  - ❌ Não há log de erros de conexão específicos

### **5. Endpoint de Email (send_email_notification_endpoint.php)**

**Linha 103:**
```php
$result = enviarNotificacaoAdministradores($emailData);
```

**Problema identificado:**
- ⚠️ Não há logs detalhados sobre:
  - Tempo de processamento do endpoint
  - Tempo de conexão com AWS SES
  - Erros específicos do AWS SES
  - Timeout na conexão com AWS

---

## 🔍 POSSÍVEIS CAUSAS RAIZ

### **1. Timeout na Conexão HTTP**

**Cenário:**
- `file_get_contents()` com timeout de 10 segundos pode não ser suficiente
- Se `send_email_notification_endpoint.php` demorar mais de 10s (ex: AWS SES lento), a requisição falha

**Evidências:**
- Erros ocorrem 1-2 vezes por dia (pode ser pico de tráfego)
- Não há logs de timeout específico

### **2. Problema de Rede entre Servidores**

**Cenário:**
- Problema intermitente de rede entre `bssegurosimediato.com.br` e `flyingdonkeys.com.br`
- DNS pode estar falhando intermitentemente
- Firewall pode estar bloqueando conexões

**Evidências:**
- Erros são intermitentes (1-2 por dia)
- Não há logs de erro de rede específico

### **3. Timeout no AWS SES**

**Cenário:**
- `enviarNotificacaoAdministradores()` pode estar demorando mais que o esperado
- AWS SES pode estar lento em alguns momentos
- Pode haver rate limiting do AWS SES

**Evidências:**
- Não há logs de tempo de resposta do AWS SES
- Não há logs de erros específicos do AWS SES

### **4. Erro de Parse JSON**

**Cenário:**
- Resposta do `send_email_notification_endpoint.php` pode não ser JSON válido em alguns casos
- Pode haver output antes dos headers (causando resposta inválida)

**Evidências:**
- Não há logs de resposta raw quando há erro de parse

### **5. Problema de Concorrência**

**Cenário:**
- Múltiplas requisições simultâneas podem estar causando problemas
- PHP-FPM pode estar com poucos workers disponíveis

**Evidências:**
- Erros ocorrem esporadicamente (pode ser pico de tráfego)

---

## 📋 LOGS ATUAIS DISPONÍVEIS

### **1. Logs em `error_log()` do PHP:**
- ✅ `[ProfessionalLogger] Falha ao enviar email: ...`
- ✅ `[ProfessionalLogger] Email enviado: ...`
- ✅ `[ProfessionalLogger] Resposta inesperada do endpoint: ...`
- ✅ `[EMAIL-ENDPOINT] Erro: ...`

### **2. Logs no Banco de Dados (application_logs):**
- ✅ Logs ERROR são salvos no banco
- ✅ Mas não há informações detalhadas sobre o erro de conexão

### **3. Logs no Console do Navegador:**
- ✅ `[LOG] Erro HTTP na resposta`
- ✅ `[LOG] Detalhes completos do erro`
- ⚠️ Mas esses logs não são persistidos

---

## 🚨 LOGS ADICIONAIS NECESSÁRIOS

### **1. Logs Detalhados em `sendAdminEmailNotification()` (MODAL_WHATSAPP_DEFINITIVO.js)**

**Adicionar antes do fetch (linha 786):**
- ✅ Timestamp de início da requisição
- ✅ URL completa que será chamada
- ✅ Payload que será enviado (sanitizado)
- ✅ Tempo de timeout configurado

**Adicionar após o fetch (linha 793):**
- ✅ Status HTTP da resposta
- ✅ Tempo de resposta (ms)
- ✅ Headers da resposta
- ✅ Tamanho da resposta
- ✅ Se houve timeout
- ✅ Se houve erro de rede
- ✅ Tipo específico de erro (NetworkError, TimeoutError, etc.)

**Adicionar no catch (linha 838):**
- ✅ Tipo de erro (error.name, error.code)
- ✅ Mensagem completa do erro
- ✅ Stack trace completo
- ✅ Timestamp do erro
- ✅ URL que foi chamada
- ✅ Payload que foi enviado

### **2. Logs Detalhados em `sendEmailNotification()` (ProfessionalLogger.php)**

**Adicionar antes de `file_get_contents()` (linha 1052):**
- ✅ Timestamp de início
- ✅ Endpoint que será chamado
- ✅ Timeout configurado
- ✅ Tamanho do payload

**Adicionar após `file_get_contents()` (linha 1053):**
- ✅ Tempo de resposta (ms)
- ✅ Status HTTP (se disponível via `$http_response_header`)
- ✅ Tamanho da resposta
- ✅ Se houve timeout
- ✅ Tipo específico de erro (timeout, connection, SSL, etc.)
- ✅ Código de erro do PHP (`error_get_last()` completo)

**Adicionar verificação de `$http_response_header`:**
- ✅ Status HTTP da resposta
- ✅ Headers da resposta
- ✅ Se resposta é HTTP 200, 500, 504, etc.

### **3. Logs Detalhados em `send_email_notification_endpoint.php`**

**Adicionar no início do processamento (linha 103):**
- ✅ Timestamp de início
- ✅ Tamanho do payload recebido
- ✅ Tempo de processamento do JSON

**Adicionar antes de chamar `enviarNotificacaoAdministradores()` (linha 103):**
- ✅ Timestamp antes do envio
- ✅ Dados que serão enviados (sanitizados)

**Adicionar após `enviarNotificacaoAdministradores()` (linha 103):**
- ✅ Tempo de processamento (ms)
- ✅ Resultado detalhado (sucesso, falha, erro específico)
- ✅ Se houve timeout
- ✅ Erros específicos do AWS SES (se houver)

### **4. Logs de Conexão com FlyingDonkeys**

**Verificar se há logs em `add_flyingdonkeys_v2.php`:**
- ✅ Tempo de conexão com API
- ✅ Erros de conexão específicos
- ✅ Timeout na API
- ✅ Status HTTP das respostas da API

---

## 📊 RECOMENDAÇÕES

### **1. Implementar Logs Adicionais (PRIORIDADE ALTA)**

**Arquivos a modificar:**
1. `MODAL_WHATSAPP_DEFINITIVO.js` → Adicionar logs detalhados em `sendAdminEmailNotification()`
2. `ProfessionalLogger.php` → Adicionar logs detalhados em `sendEmailNotification()`
3. `send_email_notification_endpoint.php` → Adicionar logs de tempo de processamento

**Informações a logar:**
- Timestamp de início/fim de cada operação
- Tempo de resposta (ms)
- Status HTTP
- Tipo de erro específico
- Payload enviado/recebido (sanitizado)
- Stack trace completo (quando aplicável)

### **2. Melhorar Tratamento de Erros (PRIORIDADE MÉDIA)**

**Melhorias:**
- Distinguir entre erros de rede, timeout, parse, e processamento
- Adicionar retry automático para erros de rede (com backoff exponencial)
- Adicionar timeout configurável (aumentar de 10s para 30s se necessário)

### **3. Monitoramento Proativo (PRIORIDADE BAIXA)**

**Implementar:**
- Dashboard de monitoramento de erros de conexão
- Alertas quando taxa de erro exceder threshold
- Métricas de tempo de resposta

---

## ❓ CONCLUSÃO

### **Resposta à Pergunta: "É necessário implementar algum log adicional?"**

**✅ SIM, é altamente recomendado implementar logs adicionais para:**

1. **Identificar causa raiz dos erros:**
   - Atualmente não há informações suficientes para determinar se o erro é:
     - Timeout na conexão HTTP
     - Problema de rede
     - Timeout no AWS SES
     - Erro de parse JSON
     - Problema de concorrência

2. **Facilitar diagnóstico:**
   - Com logs detalhados, será possível identificar padrões:
     - Horários específicos quando erros ocorrem
     - Tipos de erro mais comuns
     - Tempo de resposta quando há erro vs sucesso

3. **Melhorar resolução de problemas:**
   - Logs detalhados permitirão:
     - Corrigir problemas específicos (ex: aumentar timeout se for timeout)
     - Implementar retry automático para erros transitórios
     - Identificar problemas de infraestrutura (rede, DNS, etc.)

### **Próximos Passos Recomendados:**

1. ✅ **Implementar logs adicionais** conforme especificado acima
2. ✅ **Coletar dados por 1 semana** após implementação
3. ✅ **Analisar padrões** nos logs coletados
4. ✅ **Implementar correções** baseadas nos padrões identificados

---

## 📝 NOTAS TÉCNICAS

- **Ambiente:** Production (`prod.bssegurosimediato.com.br`)
- **Frequência:** 1-2 erros por dia
- **Stack Trace:** Mostra erro em `ProfessionalLogger.php:444` (captureCallerInfo), mas erro real está em outro lugar
- **Categoria:** EMAIL
- **Request ID:** Presente nos logs (permite rastreamento)

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Status:** 🔍 Análise completa - Aguardando decisão sobre implementação de logs adicionais

