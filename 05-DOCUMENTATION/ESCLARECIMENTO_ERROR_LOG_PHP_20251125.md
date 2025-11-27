# 🔍 ESCLARECIMENTO: O que `error_log()` envia/registra?

**Data:** 25/11/2025  
**Versão:** 1.0.0

---

## ✅ RESPOSTA DIRETA

### **`error_log()` escreve mensagens em arquivos de log do servidor, NÃO no banco de dados.**

---

## 📊 O QUE É `error_log()`

### **Função PHP:**
```php
error_log('Mensagem de log');
```

**O que faz:**
- ✅ **Escreve mensagem** em arquivo de log do servidor
- ✅ **Não retorna nada** (void)
- ✅ **Não lança exceção** se falhar
- ✅ **Não envia para banco de dados** (é diferente do `ProfessionalLogger`)

---

## 📁 ONDE OS LOGS SÃO SALVOS

### **1. Localização Padrão (Configurado no PHP)**

**Como descobrir onde está configurado:**
```php
$errorLogPath = ini_get('error_log');
echo "Logs aparecem em: " . $errorLogPath;
```

**Locais comuns:**
- `/var/log/php/error.log`
- `/var/log/php-fpm/error.log`
- `/var/log/php8.3-fpm.log`
- `/var/log/php_errors.log`
- `stderr` (saída padrão de erro, capturada pelo servidor web)

---

### **2. Configuração no PHP-FPM**

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Configurações relacionadas:**
```ini
; Log de erros do PHP
php_admin_value[error_log] = /var/log/php8.3-fpm.log
php_admin_flag[log_errors] = on

; Capturar saída dos workers (importante!)
catch_workers_output = yes
```

**⚠️ IMPORTANTE:**
- Se `catch_workers_output = yes` está **comentado** (desabilitado), erros podem não aparecer nos logs
- Se `log_errors = off`, `error_log()` não escreve nada

---

## 📋 O QUE APARECE NOS LOGS

### **Exemplo de Log Gerado:**

**Código:**
```php
error_log("[ProfessionalLogger] Falha ao enviar email: Timeout | Endpoint: https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php");
```

**O que aparece no arquivo de log:**
```
[25-Nov-2025 12:56:29 UTC] [ProfessionalLogger] Falha ao enviar email: Timeout | Endpoint: https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php
```

**Formato:**
- `[Data Hora Timezone]` + `[Mensagem]`

---

## 🔍 DIFERENÇA: `error_log()` vs `ProfessionalLogger`

### **`error_log()` (PHP nativo):**
- ✅ Escreve em **arquivo de log do servidor**
- ✅ Não vai para **banco de dados**
- ✅ Não tem estrutura (apenas texto)
- ✅ Não tem categorização, níveis, etc.
- ✅ Rápido (não faz conexão com banco)

### **`ProfessionalLogger` (Sistema customizado):**
- ✅ Escreve em **banco de dados** (`application_logs`)
- ✅ Tem estrutura (nível, categoria, dados JSON, etc.)
- ✅ Tem rastreamento (request_id, stack trace, etc.)
- ✅ Pode também usar `error_log()` se configurado (`LOG_CONSOLE_ENABLED`)

---

## 📊 NO CONTEXTO DO ERRO ANALISADO

### **Código em `ProfessionalLogger.php:1059`:**
```php
if ($result === false) {
    $error = error_get_last();
    error_log("[ProfessionalLogger] Falha ao enviar email: " . ($error['message'] ?? 'Erro desconhecido') . " | Endpoint: " . $endpoint);
}
```

**O que acontece:**
1. ✅ `file_get_contents()` retorna `false` (erro)
2. ✅ `error_get_last()` tenta capturar último erro do PHP
3. ✅ `error_log()` escreve mensagem em arquivo de log do servidor
4. ❌ **NÃO aparece no banco de dados** `application_logs`
5. ❌ **NÃO aparece no log do ProfessionalLogger** (para evitar loop)

**Onde procurar:**
- ✅ Arquivo de log do PHP-FPM: `/var/log/php8.3-fpm.log`
- ✅ Ou caminho configurado em `ini_get('error_log')`

---

## 🔍 COMO CONSULTAR OS LOGS

### **1. Descobrir onde está configurado:**
```bash
ssh root@157.180.36.223 "php -r \"echo ini_get('error_log');\""
```

### **2. Ver últimas linhas:**
```bash
ssh root@157.180.36.223 "tail -n 50 /var/log/php8.3-fpm.log"
```

### **3. Filtrar por ProfessionalLogger:**
```bash
ssh root@157.180.36.223 "grep 'ProfessionalLogger' /var/log/php8.3-fpm.log | tail -20"
```

### **4. Acompanhar em tempo real:**
```bash
ssh root@157.180.36.223 "tail -f /var/log/php8.3-fpm.log | grep ProfessionalLogger"
```

---

## ⚠️ PROBLEMA IDENTIFICADO

### **Por que não vemos os logs de `error_log()` no banco de dados:**

**Causa:**
- ❌ `error_log()` **NÃO escreve no banco de dados**
- ❌ `error_log()` escreve apenas em **arquivo de log do servidor**
- ❌ Se `catch_workers_output` estiver desabilitado, logs podem não aparecer

**Solução:**
- ✅ Consultar arquivo de log do PHP-FPM diretamente
- ✅ Ou habilitar `catch_workers_output = yes` no PHP-FPM
- ✅ Ou modificar código para também logar no banco (mas com cuidado para evitar loop)

---

## 📋 RESUMO

| Item | `error_log()` | `ProfessionalLogger` |
|------|---------------|---------------------|
| **Onde salva** | Arquivo de log do servidor | Banco de dados (`application_logs`) |
| **Estrutura** | Texto simples | JSON estruturado |
| **Níveis** | Não tem | DEBUG, INFO, WARN, ERROR, FATAL |
| **Categorias** | Não tem | Sim (EMAIL, ESPOCRM, etc.) |
| **Request ID** | Não tem | Sim |
| **Stack Trace** | Não tem | Sim |
| **Consulta** | Arquivo de texto | SQL (banco de dados) |
| **Performance** | Muito rápido | Mais lento (conexão com banco) |

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Status:** ✅ Explicação completa

