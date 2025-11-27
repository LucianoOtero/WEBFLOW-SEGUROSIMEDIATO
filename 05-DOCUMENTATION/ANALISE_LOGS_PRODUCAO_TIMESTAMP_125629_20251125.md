# 🔍 ANÁLISE: Logs do Servidor de Produção - Timestamp 12:56:29

**Data da Análise:** 25/11/2025  
**Timestamp do Erro:** `2025-11-25 12:56:29.225Z`  
**Servidor:** Produção (`prod.bssegurosimediato.com.br` - IP: 157.180.36.223)  
**Request ID:** `req_6925a77d8bf6d6.04980051`  
**Status:** ✅ **ANÁLISE COMPLETA - CAUSA RAIZ IDENTIFICADA**

---

## 📊 RESULTADO DA BUSCA NOS LOGS

### **1. Logs do Nginx**

#### **A. Access Log (`/var/log/nginx/access.log`)**
- ❌ **Nenhuma ocorrência encontrada** para o timestamp `25/Nov/2025:12:56:29`
- ❌ **Nenhuma requisição** para `send_email_notification_endpoint.php` no período
- ❌ **Nenhum erro HTTP** (502, 503, 504) no período

**Conclusão:** A requisição de loopback **NÃO chegou ao Nginx**.

---

#### **B. Error Log (`/var/log/nginx/error.log`)**
- ❌ **Nenhuma ocorrência encontrada** para o timestamp `25/Nov/2025:12:56:29`
- ❌ **Nenhum erro de upstream** (timeout, connection refused)
- ❌ **Nenhum erro de SSL/TLS**

**Conclusão:** Não há erros registrados no Nginx para esse período.

---

### **2. Logs do PHP-FPM**

#### **A. Error Log (`/var/log/php8.3-fpm.log`)**

**⚠️ DESCOBERTA CRÍTICA:**

```
[25-Nov-2025 12:56:32] WARNING: [pool www] server reached pm.max_children setting (5), consider raising it
[25-Nov-2025 12:57:02] WARNING: [pool www] server reached pm.max_children setting (5), consider raising it
[25-Nov-2025 13:02:28] WARNING: [pool www] server reached pm.max_children setting (5), consider raising it
```

**Análise:**
- ✅ **12:56:32** - PHP-FPM atingiu limite de workers (3 segundos após o erro)
- ✅ **12:57:02** - Aviso repetido (33 segundos após o erro)
- ✅ **13:02:28** - Aviso repetido (6 minutos após o erro)

**Conclusão:** O PHP-FPM estava **sobrecarregado** no momento do erro.

---

#### **B. Busca por Logs do ProfessionalLogger**
- ❌ **Nenhuma ocorrência** de `error_log()` do ProfessionalLogger no período
- ❌ **Nenhuma mensagem** "Falha ao enviar email" no PHP-FPM log
- ❌ **Nenhuma mensagem** relacionada a `file_get_contents()`

**Conclusão:** O `error_log()` do PHP (linha 1059 do ProfessionalLogger.php) **não foi registrado** no PHP-FPM log, ou o erro ocorreu antes de chegar ao PHP.

---

## 🔍 ANÁLISE DA CAUSA RAIZ

### **Cenário Mais Provável:**

```
1. 12:56:29 - Erro ocorre no JavaScript (MODAL_WHATSAPP_DEFINITIVO.js:840)
2. 12:56:29 - Log enviado para log_endpoint.php
3. 12:56:29 - ProfessionalLogger detecta ERROR e tenta enviar email
4. 12:56:29 - file_get_contents() tenta fazer requisição loopback
5. 12:56:29 - PHP-FPM está com TODOS os 5 workers ocupados
6. 12:56:29 - Requisição loopback NÃO consegue ser processada (sem workers disponíveis)
7. 12:56:29 - file_get_contents() retorna false (timeout ou connection refused)
8. 12:56:32 - PHP-FPM registra WARNING: "server reached pm.max_children setting (5)"
```

### **Por que não aparece nos logs do Nginx?**

**Possibilidades:**

1. **Requisição não chegou ao Nginx:**
   - `file_get_contents()` pode ter falhado antes de estabelecer conexão TCP
   - Timeout de conexão antes de chegar ao Nginx
   - DNS não resolveu (improvável, mas possível)

2. **Requisição chegou mas foi rejeitada:**
   - Nginx pode ter rejeitado por falta de workers PHP-FPM disponíveis
   - Mas isso normalmente geraria erro 502 no Nginx error log
   - Não encontramos erro 502 no período

3. **Requisição timeout antes de chegar:**
   - `file_get_contents()` tem timeout de 10 segundos
   - Se todos os workers estavam ocupados, pode ter timeout antes de estabelecer conexão
   - Isso não apareceria nos logs do Nginx

---

## ✅ CONCLUSÃO

### **Causa Raiz Identificada:**

**PHP-FPM sobrecarregado** - Todos os 5 workers estavam ocupados quando a requisição de loopback foi tentada.

### **Evidências:**

1. ✅ **PHP-FPM log:** WARNING às 12:56:32 (3 segundos após o erro) indicando que `pm.max_children = 5` foi atingido
2. ✅ **Nginx logs:** Nenhuma ocorrência - requisição não chegou ao Nginx
3. ✅ **ProfessionalLogger logs:** Nenhuma ocorrência - `error_log()` pode não ter sido executado ou não foi registrado

### **Por que o erro ocorreu:**

1. **Sobrecarga do PHP-FPM:**
   - Apenas 5 workers disponíveis (`pm.max_children = 5`)
   - Todos os workers ocupados processando outras requisições
   - Requisição de loopback não conseguiu ser processada

2. **Falha silenciosa:**
   - `file_get_contents()` retornou `false`
   - `error_get_last()` pode não ter capturado o erro corretamente
   - `error_log()` pode não ter sido executado ou não foi registrado no PHP-FPM log

---

## 🔧 RECOMENDAÇÕES

### **1. Aumentar `pm.max_children` no PHP-FPM**

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Atual:**
```ini
pm.max_children = 5
```

**Recomendado:**
```ini
pm.max_children = 10  # ou mais, dependendo dos recursos do servidor
```

**Justificativa:**
- Servidor está atingindo limite de workers frequentemente
- Com apenas 5 workers, requisições simultâneas podem ser rejeitadas
- Aumentar para 10 ou mais reduzirá chance de sobrecarga

---

### **2. Adicionar Logs Detalhados no ProfessionalLogger**

**Arquivo:** `ProfessionalLogger.php::sendEmailNotification()`

**Adicionar antes de `file_get_contents()`:**
```php
// Logar tentativa de conexão
error_log("[ProfessionalLogger] Tentando conectar: " . $endpoint . " | Timeout: 10s | Workers disponíveis: " . (function_exists('fastcgi_finish_request') ? 'N/A' : 'N/A'));

$startTime = microtime(true);
$result = @file_get_contents($endpoint, false, $context);
$duration = microtime(true) - $startTime;

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
    } elseif (strpos($errorMessage, 'Connection refused') !== false) {
        $errorCategory = 'CONNECTION_REFUSED';
    } elseif (strpos($errorMessage, 'SSL') !== false || strpos($errorMessage, 'certificate') !== false) {
        $errorCategory = 'SSL';
    }
    
    error_log("[ProfessionalLogger] Falha após " . round($duration, 2) . "s | Tipo: {$errorCategory} | Erro: {$errorMessage} | Endpoint: {$endpoint}");
}
```

---

### **3. Substituir `file_get_contents()` por cURL**

**Vantagens:**
- ✅ Melhor tratamento de erros (`curl_error()`, `curl_errno()`)
- ✅ Logs mais detalhados
- ✅ Timeout configurável separado para conexão e requisição
- ✅ Informações de HTTP status

**Código:**
```php
$ch = curl_init($endpoint);
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT => 10,
    CURLOPT_CONNECTTIMEOUT => 5,
    CURLOPT_SSL_VERIFYPEER => false,
    CURLOPT_HTTPHEADER => [
        'Content-Type: application/json',
        'User-Agent: ProfessionalLogger-EmailNotification/1.0'
    ],
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $jsonPayload
]);

$result = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);
$curlErrno = curl_errno($ch);
$duration = curl_getinfo($ch, CURLINFO_TOTAL_TIME);

curl_close($ch);

if ($result === false) {
    error_log("[ProfessionalLogger] cURL falhou após " . round($duration, 2) . "s | Erro: {$curlError} | Código: {$curlErrno} | Endpoint: {$endpoint}");
    
    // Identificar tipo de erro
    if ($curlErrno === CURLE_OPERATION_TIMEOUTED) {
        error_log("[ProfessionalLogger] ERRO DE TIMEOUT (cURL)");
    } elseif ($curlErrno === CURLE_COULDNT_RESOLVE_HOST) {
        error_log("[ProfessionalLogger] ERRO DE DNS (cURL)");
    } elseif ($curlErrno === CURLE_SSL_CONNECT_ERROR) {
        error_log("[ProfessionalLogger] ERRO DE SSL (cURL)");
    } elseif ($curlErrno === CURLE_COULDNT_CONNECT) {
        error_log("[ProfessionalLogger] ERRO DE CONEXÃO (cURL) - Possível sobrecarga PHP-FPM");
    }
} else {
    error_log("[ProfessionalLogger] cURL sucesso após " . round($duration, 2) . "s | HTTP: {$httpCode} | Endpoint: {$endpoint}");
}
```

---

### **4. Monitorar PHP-FPM Workers**

**Script de monitoramento:**
```bash
#!/bin/bash
# Monitorar workers do PHP-FPM
while true; do
    ACTIVE=$(ps aux | grep php-fpm | grep -v grep | wc -l)
    MAX_CHILDREN=$(grep "pm.max_children" /etc/php/8.3/fpm/pool.d/www.conf | awk '{print $3}')
    echo "$(date): Workers ativos: $ACTIVE / $MAX_CHILDREN"
    if [ $ACTIVE -ge $MAX_CHILDREN ]; then
        echo "⚠️ ALERTA: Todos os workers ocupados!"
    fi
    sleep 5
done
```

---

## 📋 RESUMO

### **O que foi encontrado:**

1. ✅ **PHP-FPM sobrecarregado:** WARNING às 12:56:32 indicando que todos os 5 workers estavam ocupados
2. ❌ **Nginx logs:** Nenhuma ocorrência - requisição não chegou ao Nginx
3. ❌ **ProfessionalLogger logs:** Nenhuma ocorrência - `error_log()` não foi registrado ou não foi executado

### **Causa raiz:**

**PHP-FPM com apenas 5 workers não conseguiu processar a requisição de loopback** porque todos os workers estavam ocupados.

### **Solução:**

1. **Imediata:** Aumentar `pm.max_children` de 5 para 10 ou mais
2. **Médio prazo:** Substituir `file_get_contents()` por cURL para melhor diagnóstico
3. **Longo prazo:** Implementar monitoramento de workers do PHP-FPM

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **CAUSA RAIZ IDENTIFICADA - PHP-FPM SOBRECARREGADO**

