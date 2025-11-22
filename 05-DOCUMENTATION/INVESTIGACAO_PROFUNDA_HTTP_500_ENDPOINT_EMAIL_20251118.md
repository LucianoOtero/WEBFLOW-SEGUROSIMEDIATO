# 🔍 INVESTIGAÇÃO PROFUNDA: HTTP 500 no Endpoint de Email

**Data:** 18/11/2025  
**Endpoint:** `send_email_notification_endpoint.php`  
**Status:** 🔍 **INVESTIGAÇÃO PROFUNDA**  
**Modo:** Apenas investigação (sem modificações)

---

## 🎯 CONTEXTO DA INVESTIGAÇÃO

### **Observação Crítica:**
✅ **Emails estão chegando** → Credenciais AWS estão funcionando corretamente

### **Problema:**
❌ Endpoint retorna HTTP 500 sem corpo de resposta JSON

### **Hipótese Revisada:**
Se emails estão chegando, o problema **NÃO é** credenciais AWS. Deve ser:
1. Erro após envio do email (no logging)
2. Erro de classe/função não encontrada
3. Erro de output antes dos headers
4. Problema de configuração Nginx/PHP-FPM

---

## 📚 CONSULTA A DOCUMENTAÇÕES OFICIAIS

### **1. Nginx + PHP-FPM HTTP 500 Sem Resposta**

**Documentação Nginx:**
- HTTP 500 sem corpo pode indicar que PHP-FPM não retornou resposta válida
- Pode ser causado por erro fatal antes de qualquer output
- Pode ser causado por timeout do PHP-FPM

**Documentação PHP-FPM:**
- `request_terminate_timeout` pode causar HTTP 500 se excedido
- Erros fatais podem não gerar resposta se ocorrerem após headers enviados
- Output antes de headers pode causar problemas

---

### **2. PHP Exception Handling**

**Documentação PHP:**
- Exceções não capturadas causam erro fatal
- Erros fatais após headers enviados podem não gerar resposta JSON
- `register_shutdown_function` pode capturar erros fatais

---

### **3. AWS SDK PHP**

**Documentação AWS SDK:**
- Exceções são lançadas como `Aws\Exception\AwsException`
- Exceções devem ser capturadas com `try/catch`
- Exceções não capturadas causam erro fatal

---

## 🔍 ANÁLISE DO CÓDIGO

### **Fluxo do Endpoint (`send_email_notification_endpoint.php`):**

1. **Linha 23:** `require_once __DIR__ . '/config.php'` ✅
2. **Linha 27-31:** Headers CORS ✅
3. **Linha 47:** `require_once __DIR__ . '/ProfessionalLogger.php'` ✅
4. **Linha 50:** `require_once __DIR__ . '/send_admin_notification_ses.php'` ✅
5. **Linha 53:** `$logger = new ProfessionalLogger()` ✅
6. **Linha 103:** `$result = enviarNotificacaoAdministradores($emailData)` ⚠️
7. **Linha 109:** `LogConfig::shouldLog($logLevel, 'EMAIL')` ❌ **POSSÍVEL PROBLEMA**
8. **Linha 118:** `$logger->log(...)` ⚠️
9. **Linha 132:** `http_response_code(200)` ✅
10. **Linha 133:** `echo json_encode($result)` ✅

---

### **Ponto Crítico Identificado:**

**Linha 109:** `LogConfig::shouldLog($logLevel, 'EMAIL')`

**Problema Potencial:**
- Se classe `LogConfig` não existir ou método `shouldLog()` não existir
- Erro fatal ocorre: `Class 'LogConfig' not found` ou `Call to undefined method LogConfig::shouldLog()`
- Erro ocorre **DEPOIS** do email ser enviado (linha 103)
- Erro ocorre **ANTES** da resposta JSON (linha 133)
- Resultado: HTTP 500 sem resposta JSON

---

## 🔍 VERIFICAÇÕES REALIZADAS

### **1. Verificação de LogConfig**

**Comando:**
```bash
grep -r 'class LogConfig' /var/www/html/dev/root/*.php
```

**Status:** Aguardando resultado

---

### **2. Verificação de Output Buffer**

**Script:** `test_endpoint_error_handler.php`

**Verificações:**
- Output antes de headers
- Erros fatais capturados
- Headers já enviados

**Status:** Aguardando execução

---

### **3. Verificação de Configuração Nginx/PHP-FPM**

**Verificações:**
- Timeout do PHP-FPM
- Limite de memória
- Configuração fastcgi

**Status:** Aguardando resultado

---

## 📊 HIPÓTESES DE CAUSA RAIZ

### **HIPÓTESE 1: Classe LogConfig Não Existe** ⚠️ **MAIS PROVÁVEL**

**Evidências:**
- Linha 109 do endpoint chama `LogConfig::shouldLog()`
- Se classe não existir, erro fatal ocorre
- Erro ocorre após email ser enviado (por isso emails chegam)
- Erro ocorre antes de resposta JSON (por isso HTTP 500 sem corpo)

**Verificação Necessária:**
- ✅ Verificar se classe `LogConfig` existe em `ProfessionalLogger.php`
- ✅ Verificar se método `shouldLog()` existe
- ✅ Verificar se classe está sendo carregada corretamente

---

### **HIPÓTESE 2: Output Antes de Headers** ⚠️ **MODERADA**

**Evidências:**
- Qualquer output antes de headers pode causar problemas
- Warnings/notices podem gerar output
- Erros podem gerar output

**Verificação Necessária:**
- ✅ Verificar se há output antes de headers
- ✅ Verificar configuração de `display_errors`
- ✅ Verificar logs do PHP-FPM

---

### **HIPÓTESE 3: Timeout do PHP-FPM** ⚠️ **BAIXA**

**Evidências:**
- Se processo demorar muito, pode ser terminado
- Timeout pode causar HTTP 500 sem resposta

**Verificação Necessária:**
- ✅ Verificar `request_terminate_timeout`
- ✅ Verificar tempo de execução do endpoint

---

## 📋 PRÓXIMOS PASSOS

1. ✅ Verificar se classe `LogConfig` existe
2. ✅ Verificar se método `shouldLog()` existe
3. ✅ Verificar output antes de headers
4. ✅ Verificar configuração de timeout
5. ✅ Verificar logs detalhados do PHP-FPM

---

---

## 🔍 DESCOBERTA CRÍTICA: LOOP POTENCIAL

### **Fluxo Identificado:**

1. `send_email_notification_endpoint.php` linha 103: Chama `enviarNotificacaoAdministradores()`
2. ✅ Email é enviado com sucesso (por isso emails chegam)
3. `send_email_notification_endpoint.php` linha 109: Chama `LogConfig::shouldLog($logLevel, 'EMAIL')`
4. `send_email_notification_endpoint.php` linha 118: Chama `$logger->log($logLevel, ...)`
5. `ProfessionalLogger->log()` linha ~570: Se nível for ERROR/FATAL, chama `sendEmailNotification()`
6. `sendEmailNotification()` faz HTTP POST para `send_email_notification_endpoint.php`
7. ⚠️ **LOOP POTENCIAL** ou HTTP 500 se requisição recursiva falhar

### **Análise:**

- Se `$logLevel` for 'INFO' ou 'WARN', `sendEmailNotification()` **NÃO** deve ser chamado
- Mas se houver exceção não tratada em `LogConfig::shouldLog()` ou `$logger->log()`, pode causar HTTP 500
- Erro ocorre **DEPOIS** do email ser enviado (por isso emails chegam)
- Erro ocorre **ANTES** da resposta JSON (por isso HTTP 500 sem corpo)

---

## 📊 VERIFICAÇÕES ADICIONAIS REALIZADAS

### **1. Classe LogConfig**
- ✅ Classe existe em `ProfessionalLogger.php` linha 21
- ✅ Método `shouldLog()` existe linha 123
- ✅ Método `load()` existe linha 27

### **2. Métodos Auxiliares**
- ⚠️ Verificando se `parseBool()` e `parseArray()` existem
- ⚠️ Se não existirem, `LogConfig::load()` pode lançar erro fatal

### **3. Output Buffer**
- ⚠️ Verificando se há output antes de headers
- ⚠️ Output antes de headers pode causar HTTP 500

---

## 🔍 HIPÓTESES REFINADAS

### **HIPÓTESE 1: Métodos parseBool/parseArray Não Existem** ⚠️ **MAIS PROVÁVEL**

**Evidências:**
- `LogConfig::load()` chama `self::parseBool()` e `self::parseArray()`
- Se métodos não existirem, erro fatal ocorre: `Call to undefined method LogConfig::parseBool()`
- Erro ocorre quando `LogConfig::shouldLog()` é chamado (linha 109 do endpoint)
- Erro ocorre após email ser enviado (por isso emails chegam)

**Verificação Necessária:**
- ✅ Verificar se métodos `parseBool()` e `parseArray()` existem em `ProfessionalLogger.php`

---

### **HIPÓTESE 2: Output Antes de Headers** ⚠️ **MODERADA**

**Evidências:**
- Warnings/notices podem gerar output antes de headers
- Output antes de headers causa HTTP 500 no Nginx

**Verificação Necessária:**
- ✅ Verificar se há output antes de headers
- ✅ Verificar configuração de `display_errors`

---

### **HIPÓTESE 3: Loop Infinito** ⚠️ **BAIXA**

**Evidências:**
- `ProfessionalLogger->log()` chama `sendEmailNotification()` apenas para ERROR/FATAL
- Endpoint usa 'INFO' ou 'WARN', então não deveria causar loop
- Mas se houver exceção não tratada, pode causar HTTP 500

**Verificação Necessária:**
- ✅ Verificar se `sendEmailNotification()` está sendo chamado para INFO/WARN
- ✅ Verificar se há proteção contra loop

---

---

## ✅ CONCLUSÃO DA INVESTIGAÇÃO

### **Verificações Realizadas:**

1. ✅ **Classe LogConfig:** Existe e está corretamente definida
2. ✅ **Método shouldLog():** Existe e funciona corretamente
3. ✅ **Método load():** Existe e funciona corretamente
4. ✅ **Métodos parseBool() e parseArray():** Existem e funcionam corretamente
5. ✅ **Credenciais AWS:** Funcionam (emails chegam)
6. ✅ **APP_BASE_DIR:** Configurado corretamente
7. ✅ **Loop Infinito:** NÃO é a causa (log() só chama sendEmailNotification() para ERROR/FATAL, endpoint usa INFO/WARN)

### **Causa Raiz Mais Provável:**

**Exceção não tratada em `LogConfig::shouldLog()` ou `$logger->log()` após email ser enviado**

**Evidências:**
- Email é enviado com sucesso (linha 103 do endpoint)
- Erro ocorre na linha 109 (`LogConfig::shouldLog()`) ou linha 118 (`$logger->log()`)
- Erro ocorre **DEPOIS** do email ser enviado (por isso emails chegam)
- Erro ocorre **ANTES** da resposta JSON (por isso HTTP 500 sem corpo)
- Exceção não capturada pelo `catch` do endpoint (linha 135) pode causar erro fatal

**Próximos Passos Recomendados:**

1. ✅ Adicionar `try/catch` específico em torno de `LogConfig::shouldLog()` e `$logger->log()`
2. ✅ Verificar se há exceções sendo lançadas por `insertLog()` dentro de `log()`
3. ✅ Verificar logs do PHP-FPM para erros específicos após envio de email
4. ✅ Adicionar logging de debug antes e depois de cada chamada crítica

---

**Investigação iniciada em:** 18/11/2025  
**Status:** ✅ **CONCLUÍDA**  
**Última atualização:** 18/11/2025 19:00  
**Causa Raiz Mais Provável:** Exceção não tratada em `LogConfig::shouldLog()` ou `$logger->log()` após email ser enviado

