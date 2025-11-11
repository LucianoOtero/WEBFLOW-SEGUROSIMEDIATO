# 🔧 ANÁLISE TÉCNICA - Engenheiro de Infraestrutura Linux/Nginx/PHP

**Data:** 09/11/2025  
**Analista:** Engenheiro de IT - Especialista em Infraestrutura Linux Ubuntu, Nginx e PHP  
**Documento Base:** `RELATORIO_DETALHADO_ERROS_HTTP_500.md`

---

## 📊 SUMÁRIO EXECUTIVO TÉCNICO

Após análise detalhada do relatório e inspeção do ambiente, identifiquei **múltiplas falhas de configuração de infraestrutura** que explicam os erros HTTP 500 intermitentes. O problema não é apenas o bug de código PHP, mas uma combinação de:

1. **Configuração inadequada do Nginx** para requisições POST/FastCGI
2. **Configuração de error_reporting do PHP** que pode tratar warnings como fatais
3. **Bug crítico no rate limiting** (já identificado)
4. **Falta de otimizações de buffer e timeout** no Nginx
5. **Ausência de monitoramento adequado** de logs

---

## 🔴 PROBLEMA CRÍTICO #1: CONFIGURAÇÃO NGINX INCOMPLETA

### **Análise da Configuração Atual**

**Arquivo:** `/etc/nginx/conf.d/dev.conf`

```nginx
location ~ \.php$ {
    fastcgi_pass php-dev:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
}
```

### **Problemas Identificados**

#### **1.1. Falta de Timeouts para FastCGI**

**Problema:**
- Não há `fastcgi_read_timeout` configurado
- Não há `fastcgi_send_timeout` configurado
- **Padrão do Nginx:** `fastcgi_read_timeout = 60s`
- **Risco:** Requisições podem expirar silenciosamente

**Impacto:**
- Requisições POST com body grande podem ser cortadas
- PHP-FPM pode não receber dados completos
- Timeout padrão pode ser insuficiente sob carga

#### **1.2. Falta de Buffers para FastCGI**

**Problema:**
- Não há `fastcgi_buffers` configurado
- Não há `fastcgi_buffer_size` configurado
- **Padrão do Nginx:** `fastcgi_buffers = 8 4k/8k` (depende da versão)
- **Risco:** Body de requisições POST pode não ser completamente bufferizado

**Impacto:**
- `php://input` pode retornar dados incompletos
- Requisições grandes podem falhar silenciosamente
- Dados JSON podem ser truncados

#### **1.3. Falta de `client_max_body_size`**

**Problema:**
- Não há `client_max_body_size` configurado no `server` block
- **Padrão do Nginx:** `1MB`
- **Risco:** Requisições POST maiores que 1MB são rejeitadas com HTTP 413

**Impacto:**
- Requisições com payload grande podem ser rejeitadas antes de chegar ao PHP
- Erro HTTP 413 pode ser confundido com HTTP 500

### **Solução Recomendada**

```nginx
server {
    listen 443 ssl http2;
    server_name dev.bssegurosimediato.com.br;
    
    # Limite de tamanho do body da requisição
    client_max_body_size 10M;
    
    # Timeouts para requisições longas
    client_body_timeout 60s;
    client_header_timeout 60s;
    
    root /var/www/html/dev/root;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }
    
    location ~ \.php$ {
        fastcgi_pass php-dev:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        
        # ✅ CORREÇÕES CRÍTICAS:
        
        # Timeouts para FastCGI
        fastcgi_read_timeout 300s;      # 5 minutos para leitura
        fastcgi_send_timeout 300s;      # 5 minutos para envio
        fastcgi_connect_timeout 60s;    # 1 minuto para conexão
        
        # Buffers para FastCGI
        fastcgi_buffers 16 16k;         # 16 buffers de 16KB = 256KB total
        fastcgi_buffer_size 32k;       # Buffer inicial de 32KB
        fastcgi_busy_buffers_size 64k;  # Buffer ocupado de 64KB
        
        # Otimizações adicionais
        fastcgi_temp_file_write_size 128k;  # Tamanho de escrita temporária
        fastcgi_intercept_errors on;         # Interceptar erros do PHP
        fastcgi_ignore_client_abort off;     # Não ignorar abort do cliente
    }
    
    location ~ \.js$ {
        add_header Content-Type application/javascript;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

---

## 🔴 PROBLEMA CRÍTICO #2: CONFIGURAÇÃO PHP error_reporting

### **Análise da Configuração Atual**

**Valor Atual:** `error_reporting => 22527`

**Decodificação:**
```php
E_ERROR           = 1      (1)
E_WARNING         = 2      (2)
E_PARSE           = 4      (4)
E_NOTICE          = 8      (8)
E_CORE_ERROR      = 16     (16)
E_CORE_WARNING    = 32     (32)
E_COMPILE_ERROR   = 64     (64)
E_COMPILE_WARNING = 128    (128)
E_USER_ERROR      = 256    (256)
E_USER_WARNING    = 512    (512)
E_USER_NOTICE     = 1024   (1024)
E_STRICT          = 2048   (2048)
E_RECOVERABLE_ERROR = 4096 (4096)
E_DEPRECATED      = 8192   (8192)
E_USER_DEPRECATED = 16384  (16384)

22527 = 1 + 2 + 4 + 8 + 16 + 32 + 64 + 128 + 256 + 512 + 1024 + 2048 + 4096 + 8192 + 16384
     = E_ALL & ~E_DEPRECATED & ~E_STRICT (aproximadamente)
```

### **Problema Identificado**

**Análise:**
- `error_reporting = 22527` inclui `E_WARNING` (2)
- O bug na linha 125 gera `PHP Warning: Trying to access array offset on null`
- **Se `display_errors = Off` e `log_errors = On`:** Warning é logado, mas não causa HTTP 500
- **MAS:** Se houver um handler de erro customizado ou se o PHP-FPM estiver configurado para tratar warnings como fatais, pode causar HTTP 500

### **Verificação Necessária**

```bash
# Verificar configuração do PHP-FPM
docker exec webhooks-php-dev cat /usr/local/etc/php-fpm.d/www.conf | grep -E 'php_admin_value|php_flag|catch_workers_output'
```

### **Solução Recomendada**

**Opção 1: Corrigir o Bug (RECOMENDADO)**
- Corrigir o bug do rate limiting para não gerar warnings
- Manter `error_reporting` como está

**Opção 2: Ajustar error_reporting (TEMPORÁRIO)**
```ini
; php.ini ou php-fpm.conf
error_reporting = E_ALL & ~E_WARNING & ~E_NOTICE & ~E_DEPRECATED
```

**⚠️ AVISO:** Opção 2 é uma solução temporária. O correto é corrigir o bug.

---

## 🔴 PROBLEMA CRÍTICO #3: BUG DO RATE LIMITING

### **Análise do Código Problemático**

**Arquivo:** `log_endpoint.php`, linha 123-125

```php
if (file_exists($rateLimitFile)) {
    $data = json_decode(file_get_contents($rateLimitFile), true);
    if ($now - $data['first_request'] < $window) {  // ⚠️ ERRO AQUI
```

### **Cenários de Falha**

1. **Arquivo existe mas está vazio:**
   ```bash
   # Arquivo: /tmp/log_rate_limit_*.tmp
   # Conteúdo: (vazio)
   # json_decode('', true) = null
   # $data['first_request'] = PHP Warning
   ```

2. **Arquivo existe mas JSON está corrompido:**
   ```bash
   # Arquivo: /tmp/log_rate_limit_*.tmp
   # Conteúdo: {"first_request":1234567890,"count":5
   # json_decode('{"first_request":1234567890,"count":5', true) = null
   # $data['first_request'] = PHP Warning
   ```

3. **Race condition em requisições simultâneas:**
   ```php
   // Requisição 1: Lê arquivo (vazio ou corrompido)
   // Requisição 2: Lê arquivo (vazio ou corrompido) - simultaneamente
   // Ambas tentam acessar $data['first_request'] = PHP Warning
   ```

### **Solução Técnica Completa**

```php
// Rate limiting simples (por IP)
$clientIP = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$rateLimitFile = sys_get_temp_dir() . '/log_rate_limit_' . md5($clientIP) . '.tmp';
$now = time();
$window = 60; // 1 minuto
$maxRequests = 100; // máximo 100 requests por minuto

// ✅ CORREÇÃO: Usar file locking para evitar race conditions
$fp = null;
if (file_exists($rateLimitFile)) {
    $fp = fopen($rateLimitFile, 'r+');
    if ($fp && flock($fp, LOCK_EX)) {  // Lock exclusivo
        $content = file_get_contents($rateLimitFile);
        $data = json_decode($content, true);
        
        // ✅ CORREÇÃO: Validar $data antes de usar
        if (!is_array($data) || !isset($data['first_request']) || !isset($data['count'])) {
            // Arquivo corrompido ou inválido - recriar
            $data = ['first_request' => $now, 'count' => 1];
        } else if ($now - $data['first_request'] < $window) {
            if ($data['count'] >= $maxRequests) {
                flock($fp, LOCK_UN);
                fclose($fp);
                http_response_code(429);
                echo json_encode([
                    'success' => false,
                    'error' => 'Rate limit exceeded',
                    'retry_after' => $window - ($now - $data['first_request'])
                ]);
                exit;
            }
            $data['count']++;
        } else {
            // Janela expirou - resetar
            $data = ['first_request' => $now, 'count' => 1];
        }
        
        // Escrever dados atualizados
        ftruncate($fp, 0);
        rewind($fp);
        fwrite($fp, json_encode($data));
        flock($fp, LOCK_UN);
        fclose($fp);
    } else {
        // Falha ao obter lock - usar valores padrão
        if ($fp) fclose($fp);
        $data = ['first_request' => $now, 'count' => 1];
    }
} else {
    // Arquivo não existe - criar
    $data = ['first_request' => $now, 'count' => 1];
    file_put_contents($rateLimitFile, json_encode($data), LOCK_EX);
}
```

**Melhorias Adicionais:**
- ✅ File locking para evitar race conditions
- ✅ Validação robusta de `$data`
- ✅ Tratamento de arquivo corrompido
- ✅ Fallback seguro em caso de falha

---

## ⚠️ PROBLEMA #4: FALTA DE MONITORAMENTO DE LOGS

### **Análise Atual**

**Logs Disponíveis:**
- ✅ Nginx access log: `/var/log/nginx/dev_access.log`
- ✅ Nginx error log: `/var/log/nginx/dev_error.log`
- ⚠️ PHP error log: `/var/log/php/error.log` (não acessível ou não existe)

### **Problemas Identificados**

1. **PHP error log não acessível:**
   - Volume pode ser read-only
   - Arquivo pode não existir
   - Permissões podem estar incorretas

2. **Falta de log estruturado:**
   - Erros não são logados antes de retornar HTTP 500
   - Não há rastreamento de requisições
   - Não há métricas de performance

### **Solução Recomendada**

#### **4.1. Verificar e Corrigir PHP Error Log**

```bash
# Verificar se o diretório existe
docker exec webhooks-php-dev ls -la /var/log/php/

# Criar diretório se não existir
docker exec webhooks-php-dev mkdir -p /var/log/php
docker exec webhooks-php-dev chown www-data:www-data /var/log/php
docker exec webhooks-php-dev chmod 755 /var/log/php

# Verificar permissões
docker exec webhooks-php-dev ls -la /var/log/php/
```

#### **4.2. Adicionar Logging Detalhado no PHP**

```php
// No início de log_endpoint.php
$logFile = '/var/log/php/log_endpoint_debug.log';
$logEntry = [
    'timestamp' => date('Y-m-d H:i:s.u'),
    'method' => $_SERVER['REQUEST_METHOD'] ?? 'UNKNOWN',
    'uri' => $_SERVER['REQUEST_URI'] ?? 'UNKNOWN',
    'ip' => $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN',
    'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'UNKNOWN',
    'content_length' => $_SERVER['CONTENT_LENGTH'] ?? 0,
    'php_input_length' => strlen(file_get_contents('php://input')),
    'php_input_preview' => substr(file_get_contents('php://input'), 0, 200)
];
file_put_contents($logFile, json_encode($logEntry) . PHP_EOL, FILE_APPEND | LOCK_EX);
```

---

## 🔧 PROBLEMA #5: CONFIGURAÇÃO PHP-FPM

### **Análise Necessária**

**Verificações Pendentes:**
1. Configuração de pool do PHP-FPM
2. Limites de processos (`pm.max_children`, `pm.start_servers`, etc.)
3. Timeouts do PHP-FPM
4. Configuração de `request_terminate_timeout`

### **Comandos de Diagnóstico**

```bash
# Verificar configuração do PHP-FPM
docker exec webhooks-php-dev cat /usr/local/etc/php-fpm.d/www.conf | grep -E 'pm\.|request_terminate_timeout|max_execution_time'

# Verificar processos PHP-FPM ativos
docker exec webhooks-php-dev ps aux | grep php-fpm

# Verificar logs do PHP-FPM
docker exec webhooks-php-dev tail -50 /var/log/php-fpm.log
```

### **Configuração Recomendada**

```ini
; /usr/local/etc/php-fpm.d/www.conf

[www]
pm = dynamic
pm.max_children = 50
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
pm.max_requests = 500

; Timeouts
request_terminate_timeout = 300s  ; 5 minutos
request_slowlog_timeout = 10s     ; Log de requisições lentas

; Logs
catch_workers_output = yes
php_admin_value[error_log] = /var/log/php/error.log
php_admin_flag[log_errors] = on
```

---

## 📋 PLANO DE AÇÃO PRIORITÁRIO

### **🔴 PRIORIDADE CRÍTICA (Implementar Imediatamente)**

1. **Corrigir bug do rate limiting:**
   - Implementar validação de `$data`
   - Adicionar file locking
   - Testar em ambiente de desenvolvimento

2. **Atualizar configuração do Nginx:**
   - Adicionar `fastcgi_read_timeout`
   - Adicionar `fastcgi_buffers`
   - Adicionar `client_max_body_size`
   - Reiniciar Nginx após alterações

3. **Verificar e corrigir PHP error log:**
   - Criar diretório se não existir
   - Ajustar permissões
   - Testar escrita de logs

### **⚠️ PRIORIDADE ALTA (Implementar em 24h)**

4. **Adicionar logging detalhado:**
   - Implementar logging no `log_endpoint.php`
   - Criar endpoint de diagnóstico
   - Monitorar logs por 24h

5. **Revisar configuração PHP-FPM:**
   - Ajustar limites de processos
   - Configurar timeouts adequados
   - Otimizar para carga esperada

### **📋 PRIORIDADE MÉDIA (Implementar em 1 semana)**

6. **Implementar monitoramento:**
   - Configurar alertas para HTTP 500
   - Criar dashboard de métricas
   - Implementar rate limiting mais robusto (Redis/Memcached)

7. **Otimizações de performance:**
   - Implementar cache de conexão MySQL
   - Otimizar queries do banco
   - Implementar connection pooling

---

## 🧪 TESTES DE VALIDAÇÃO

### **Teste 1: Verificar Configuração Nginx**

```bash
# Testar configuração do Nginx
docker exec webhooks-nginx nginx -t

# Recarregar configuração
docker exec webhooks-nginx nginx -s reload
```

### **Teste 2: Verificar PHP Error Log**

```bash
# Testar escrita no log
docker exec webhooks-php-dev php -r "error_log('TEST: PHP error log funcionando');"

# Verificar se foi escrito
docker exec webhooks-php-dev tail -5 /var/log/php/error.log
```

### **Teste 3: Testar Requisição POST Completa**

```bash
# Teste com curl
curl -X POST https://dev.bssegurosimediato.com.br/log_endpoint.php \
  -H 'Content-Type: application/json' \
  -d '{"level":"INFO","message":"Teste de requisição POST"}' \
  -v

# Verificar logs
docker exec webhooks-php-dev tail -20 /var/log/php/error.log
docker exec webhooks-nginx tail -20 /var/log/nginx/dev_error.log
```

---

## 📊 MÉTRICAS DE SUCESSO

### **Antes das Correções:**
- Taxa de erro HTTP 500: **30-40%**
- Tempo médio de resposta: **N/A** (muitas falhas)
- Logs acessíveis: **Parcialmente**

### **Após as Correções (Esperado):**
- Taxa de erro HTTP 500: **< 1%**
- Tempo médio de resposta: **< 200ms**
- Logs acessíveis: **100%**
- Rate limiting funcionando: **100%**

---

## 🔐 CONSIDERAÇÕES DE SEGURANÇA

### **1. Rate Limiting**
- ✅ Implementar file locking para evitar race conditions
- ✅ Validar dados antes de usar
- ⚠️ Considerar migrar para Redis/Memcached para melhor performance

### **2. Logs**
- ✅ Não logar dados sensíveis (CPF, senhas, tokens)
- ✅ Implementar rotação de logs
- ✅ Limitar tamanho dos logs

### **3. Nginx**
- ✅ Limitar `client_max_body_size` para evitar DoS
- ✅ Configurar timeouts adequados
- ✅ Implementar rate limiting no nível do Nginx (opcional)

---

## 📝 CONCLUSÃO

Os erros HTTP 500 intermitentes são causados por uma **combinação de problemas de infraestrutura e código**:

1. **Bug crítico no rate limiting** (causa raiz principal)
2. **Configuração inadequada do Nginx** (agravante)
3. **Falta de monitoramento** (dificulta diagnóstico)

**Recomendação Final:**
- Implementar todas as correções de **PRIORIDADE CRÍTICA** imediatamente
- Monitorar por 24-48h após implementação
- Implementar melhorias de **PRIORIDADE ALTA** em seguida

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Próxima revisão:** Após implementação das correções críticas

