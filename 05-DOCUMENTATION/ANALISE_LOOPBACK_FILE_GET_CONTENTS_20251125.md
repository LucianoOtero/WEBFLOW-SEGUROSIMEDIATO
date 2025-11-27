# 🔍 ANÁLISE: Loopback em `file_get_contents()` - Como Funciona e Possibilidades

**Data:** 25/11/2025  
**Status:** 🔍 **ANÁLISE COMPLETA - APENAS INVESTIGAÇÃO**  
**Objetivo:** Analisar como funciona o loopback e se logs do Nginx/PHP capturam os erros

---

## 📊 ANÁLISE DO CÓDIGO

### **1. Construção do Endpoint**

**Arquivo:** `ProfessionalLogger.php` (linha 954-959)

```php
// Determinar URL do endpoint
$baseUrl = $_ENV['APP_BASE_URL'] ?? '';
if (empty($baseUrl)) {
    error_log('[ProfessionalLogger] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');
    throw new RuntimeException('APP_BASE_URL não está definido nas variáveis de ambiente');
}
$endpoint = $baseUrl . '/send_email_notification_endpoint.php';
```

**Resultado:**
- **DEV:** `https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php`
- **PROD:** `https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php`

**Conclusão:** ✅ É uma **URL externa completa**, não localhost.

---

### **2. Requisição HTTP**

**Arquivo:** `ProfessionalLogger.php` (linha 1037-1053)

```php
$context = stream_context_create([
    'http' => [
        'method' => 'POST',
        'header' => $headerString,
        'content' => $jsonPayload,
        'timeout' => 10, // Timeout de 10 segundos
        'ignore_errors' => true
    ],
    'ssl' => [
        'verify_peer' => false,
        'verify_peer_name' => false,
        'allow_self_signed' => true
    ]
]);

$result = @file_get_contents($endpoint, false, $context);
```

**Características:**
- ✅ Usa `file_get_contents()` com contexto HTTP
- ✅ Timeout configurado: **10 segundos**
- ✅ SSL desabilitado (não verifica certificado)
- ✅ Ignora erros HTTP (não lança exceção)

---

## 🔍 FLUXO DA REQUISIÇÃO LOOPBACK

### **Cenário: Servidor chamando a si mesmo**

```
┌─────────────────────────────────────────────────────────────┐
│ ProfessionalLogger.php (executando no servidor)             │
│ Linha 1053: file_get_contents($endpoint)                    │
│ $endpoint = "https://dev.bssegurosimediato.com.br/..."      │
└─────────────────────────────────────────────────────────────┘
                        │
                        │ (1) Resolução DNS
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ Sistema Operacional (Linux)                                 │
│ - Resolve "dev.bssegurosimediato.com.br"                    │
│ - Pode usar DNS externo ou /etc/hosts                       │
└─────────────────────────────────────────────────────────────┘
                        │
                        │ (2) Conexão TCP
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ Nginx (porta 443)                                           │
│ - Recebe requisição HTTPS                                    │
│ - Processa SSL/TLS                                           │
│ - Roteia para PHP-FPM                                        │
└─────────────────────────────────────────────────────────────┘
                        │
                        │ (3) Processamento PHP
                        ▼
┌─────────────────────────────────────────────────────────────┐
│ PHP-FPM                                                     │
│ - Executa send_email_notification_endpoint.php              │
│ - Processa requisição                                        │
│ - Retorna resposta                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ O QUE OS LOGS CAPTURAM

### **1. Logs do Nginx**

**Se a requisição chegar ao Nginx:**

#### **A. Access Log (`/var/log/nginx/dev_access.log`)**
- ✅ **Registra:** Requisição HTTP completa
- ✅ **Informações:**
  - IP de origem (será IP do servidor ou 127.0.0.1)
  - Método (POST)
  - URL (`/send_email_notification_endpoint.php`)
  - Status HTTP (200, 500, 502, 504, etc.)
  - Tempo de resposta
  - Tamanho da resposta

**Exemplo de log:**
```
127.0.0.1 - - [25/Nov/2025:12:56:29 +0000] "POST /send_email_notification_endpoint.php HTTP/1.1" 200 1234 "-" "ProfessionalLogger-EmailNotification/1.0"
```

#### **B. Error Log (`/var/log/nginx/dev_error.log`)**
- ✅ **Registra:** Erros de conexão, timeout, SSL
- ✅ **Informações:**
  - Erros de SSL/TLS
  - Timeout de conexão
  - Erros de upstream (PHP-FPM)
  - Erros 502/503/504

**Exemplo de log:**
```
2025/11/25 12:56:29 [error] upstream timed out (110: Connection timed out) while reading response header from upstream
```

---

### **2. Logs do PHP-FPM**

**Se a requisição chegar ao PHP-FPM:**

#### **A. Error Log (`/var/log/php8.3-fpm.log`)**
- ✅ **Registra:** Erros de PHP, exceções, warnings
- ✅ **Condição:** `catch_workers_output = yes` no `php-fpm.conf`
- ✅ **Informações:**
  - Erros de sintaxe
  - Exceções não capturadas
  - Warnings e notices
  - Erros de conexão com banco de dados

**Exemplo de log:**
```
[25-Nov-2025 12:56:29] WARNING: [pool www] child 1234 exited on signal 11 (SIGSEGV)
```

#### **B. Slow Log (`/var/log/php8.3-fpm-slow.log`)**
- ✅ **Registra:** Scripts que demoram mais que `request_slowlog_timeout`
- ✅ **Informações:**
  - Stack trace do script lento
  - Tempo de execução
  - Script que está executando

---

### **3. Logs do Sistema (Linux)**

**Se houver problema de rede:**

#### **A. `/var/log/syslog`**
- ✅ **Registra:** Erros de sistema, DNS, rede
- ✅ **Informações:**
  - Erros de DNS (se usar resolver do sistema)
  - Erros de rede
  - Problemas de firewall

---

## ❌ O QUE OS LOGS NÃO CAPTURAM

### **1. Erros ANTES de chegar ao Nginx**

#### **A. DNS (Resolução de Nome)**
- ❌ **Problema:** `file_get_contents()` não consegue resolver `dev.bssegurosimediato.com.br`
- ❌ **Causa:** DNS do servidor com problema, `/etc/hosts` incorreto
- ❌ **Sintoma:** `file_get_contents()` retorna `false` com erro "Could not resolve host"
- ❌ **Logs:** Não aparece no Nginx (requisição não chega)
- ✅ **Onde aparece:** `error_log()` do PHP (linha 1059)

#### **B. Timeout de Conexão TCP**
- ❌ **Problema:** Não consegue estabelecer conexão TCP com o servidor
- ❌ **Causa:** Firewall bloqueando, servidor não responde, porta fechada
- ❌ **Sintoma:** `file_get_contents()` retorna `false` após timeout
- ❌ **Logs:** Não aparece no Nginx (conexão não estabelecida)
- ✅ **Onde aparece:** `error_log()` do PHP (linha 1059)

#### **C. Erro de SSL/TLS**
- ❌ **Problema:** Certificado SSL inválido ou erro de handshake
- ❌ **Causa:** Certificado expirado, cadeia quebrada, configuração SSL incorreta
- ❌ **Sintoma:** `file_get_contents()` retorna `false` com erro SSL
- ❌ **Logs:** Não aparece no Nginx (handshake falha antes)
- ✅ **Onde aparece:** `error_log()` do PHP (linha 1059)
- ⚠️ **NOTA:** Código atual desabilita verificação SSL (`verify_peer => false`), então esse erro é menos provável

---

### **2. Erros DURANTE a Requisição (mas não capturados)**

#### **A. Timeout de Requisição HTTP**
- ⚠️ **Problema:** Requisição demora mais que 10 segundos
- ⚠️ **Causa:** PHP-FPM lento, banco de dados lento, processamento longo
- ⚠️ **Sintoma:** `file_get_contents()` retorna `false` após 10s
- ✅ **Logs Nginx:** Pode aparecer como timeout de upstream (504)
- ✅ **Logs PHP:** Aparece em `error_log()` (linha 1059)

#### **B. PHP-FPM Não Responde**
- ⚠️ **Problema:** PHP-FPM não processa requisição (sobrecarregado, travado)
- ⚠️ **Causa:** Workers esgotados, deadlock, erro fatal
- ⚠️ **Sintoma:** Nginx retorna 502 Bad Gateway
- ✅ **Logs Nginx:** Aparece como erro 502
- ✅ **Logs PHP-FPM:** Pode aparecer se houver erro fatal

---

## 🔍 POSSIBILIDADES DE ERRO (Baseado no Código)

### **Cenário 1: DNS Não Resolve**

**O que acontece:**
1. `file_get_contents()` tenta resolver `dev.bssegurosimediato.com.br`
2. DNS do servidor não consegue resolver
3. `file_get_contents()` retorna `false`
4. `error_get_last()` retorna erro de DNS

**Logs:**
- ❌ Nginx: Não aparece (requisição não chega)
- ✅ PHP `error_log()`: Aparece (linha 1059)
- ✅ Mensagem: "Could not resolve host: dev.bssegurosimediato.com.br"

**Como verificar:**
```bash
# No servidor
nslookup dev.bssegurosimediato.com.br
dig dev.bssegurosimediato.com.br
cat /etc/hosts | grep bssegurosimediato
```

---

### **Cenário 2: Timeout de Conexão TCP**

**O que acontece:**
1. DNS resolve corretamente
2. `file_get_contents()` tenta conectar na porta 443
3. Conexão TCP não estabelece (timeout, firewall, servidor não responde)
4. `file_get_contents()` retorna `false` após timeout

**Logs:**
- ❌ Nginx: Não aparece (conexão não estabelecida)
- ✅ PHP `error_log()`: Aparece (linha 1059)
- ✅ Mensagem: "Connection timed out" ou "Connection refused"

**Como verificar:**
```bash
# No servidor
curl -v https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php
telnet dev.bssegurosimediato.com.br 443
netstat -tuln | grep 443
```

---

### **Cenário 3: Timeout de Requisição HTTP (10 segundos)**

**O que acontece:**
1. Conexão TCP estabelecida
2. Requisição HTTP enviada
3. PHP-FPM demora mais que 10 segundos para processar
4. `file_get_contents()` retorna `false` após timeout

**Logs:**
- ✅ Nginx: Aparece como timeout de upstream (504 Gateway Timeout)
- ✅ PHP `error_log()`: Aparece (linha 1059)
- ✅ PHP-FPM Slow Log: Aparece se script demorar muito

**Como verificar:**
```bash
# Verificar logs do Nginx
tail -f /var/log/nginx/dev_error.log | grep timeout

# Verificar slow log do PHP-FPM
tail -f /var/log/php8.3-fpm-slow.log
```

---

### **Cenário 4: PHP-FPM Não Responde (502 Bad Gateway)**

**O que acontece:**
1. Conexão TCP estabelecida
2. Requisição HTTP enviada
3. Nginx tenta enviar para PHP-FPM
4. PHP-FPM não responde (sobrecarregado, travado, erro fatal)
5. Nginx retorna 502 Bad Gateway

**Logs:**
- ✅ Nginx Access Log: Aparece como 502
- ✅ Nginx Error Log: Aparece como erro de upstream
- ✅ PHP `error_log()`: Aparece (linha 1059) - mas pode não ter detalhes
- ✅ PHP-FPM Error Log: Aparece se houver erro fatal

**Como verificar:**
```bash
# Verificar status do PHP-FPM
systemctl status php8.3-fpm
ps aux | grep php-fpm

# Verificar logs do PHP-FPM
tail -f /var/log/php8.3-fpm.log
```

---

### **Cenário 5: Erro de Processamento no PHP**

**O que acontece:**
1. Conexão estabelecida
2. Requisição chega ao PHP-FPM
3. `send_email_notification_endpoint.php` executa
4. Erro ocorre durante processamento (exceção, erro fatal)
5. PHP retorna erro 500 ou exceção

**Logs:**
- ✅ Nginx Access Log: Aparece como 500 (se erro fatal) ou 200 (se exceção capturada)
- ✅ PHP-FPM Error Log: Aparece erro/exceção
- ✅ PHP `error_log()`: Aparece (linha 1059) - mas pode não ter detalhes do erro interno

**Como verificar:**
```bash
# Verificar logs do PHP-FPM
tail -f /var/log/php8.3-fpm.log

# Verificar se há erros no endpoint
grep -i error /var/log/php8.3-fpm.log | grep send_email
```

---

## ✅ CONCLUSÃO

### **Resposta à Pergunta:**

**SIM, os logs do Nginx e PHP capturam a maioria dos erros de loopback**, MAS:

1. ✅ **Se a requisição chegar ao Nginx:**
   - Access Log: Registra requisição e status HTTP
   - Error Log: Registra erros de upstream, timeout, SSL

2. ✅ **Se a requisição chegar ao PHP-FPM:**
   - Error Log: Registra erros de PHP, exceções
   - Slow Log: Registra scripts lentos

3. ❌ **Se a requisição NÃO chegar ao Nginx:**
   - DNS: Não aparece no Nginx (só no `error_log()` do PHP)
   - Timeout TCP: Não aparece no Nginx (só no `error_log()` do PHP)
   - SSL: Não aparece no Nginx (só no `error_log()` do PHP)

### **Recomendação:**

**Adicionar logs detalhados no `ProfessionalLogger.php`** para capturar erros que não chegam ao Nginx:

```php
if ($result === false) {
    $error = error_get_last();
    $errorType = $error['type'] ?? 'UNKNOWN';
    $errorMessage = $error['message'] ?? 'Erro desconhecido';
    
    // Identificar tipo de erro
    $errorCategory = 'UNKNOWN';
    if (strpos($errorMessage, 'resolve') !== false || strpos($errorMessage, 'DNS') !== false) {
        $errorCategory = 'DNS';
    } elseif (strpos($errorMessage, 'timeout') !== false || strpos($errorMessage, 'timed out') !== false) {
        $errorCategory = 'TIMEOUT';
    } elseif (strpos($errorMessage, 'SSL') !== false || strpos($errorMessage, 'certificate') !== false) {
        $errorCategory = 'SSL';
    } elseif (strpos($errorMessage, 'Connection refused') !== false) {
        $errorCategory = 'CONNECTION_REFUSED';
    }
    
    error_log("[ProfessionalLogger] Falha ao enviar email | Tipo: {$errorCategory} | Erro: {$errorMessage} | Endpoint: {$endpoint}");
}
```

---

**Documento criado em:** 25/11/2025  
**Status:** 🔍 **ANÁLISE COMPLETA**

