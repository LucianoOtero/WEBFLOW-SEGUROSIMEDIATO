# 📊 ANÁLISE: Logs do cURL no Nginx e PHP

**Data:** 25/11/2025  
**Contexto:** Investigação sobre onde os logs do cURL aparecem nos logs do Nginx e PHP  
**Fonte:** Documentação oficial do Nginx e PHP

---

## 🎯 OBJETIVO

Entender onde e como os logs do cURL (gerados via `error_log()` no PHP) aparecem nos logs do Nginx e PHP-FPM, baseado na documentação oficial.

---

## 📚 DOCUMENTAÇÃO CONSULTADA

### **1. Nginx - Logging**
- **Fonte:** https://docs.nginx.com/nginx/admin-guide/monitoring/logging/
- **Foco:** Como o Nginx captura logs do PHP-FPM

### **2. PHP - error_log()**
- **Fonte:** Documentação oficial do PHP
- **Foco:** Onde `error_log()` escreve os logs

### **3. PHP-FPM - catch_workers_output**
- **Fonte:** Documentação do PHP-FPM
- **Foco:** Como capturar stderr do PHP-FPM

---

## 🔍 CONCLUSÕES DA DOCUMENTAÇÃO

### **1. Como o PHP error_log() Funciona**

**Comportamento Padrão:**
- `error_log()` escreve para o destino configurado em `error_log` (php.ini ou PHP-FPM pool)
- Se `error_log` não estiver definido, escreve para **STDERR**
- STDERR é capturado pelo PHP-FPM e pode ser redirecionado

**Configuração no PHP-FPM:**
```ini
php_admin_flag[log_errors] = on
php_admin_value[error_log] = /var/log/php-fpm/www-error.log
```

**Se não configurado:**
- `error_log()` escreve para **STDERR**
- STDERR é capturado pelo PHP-FPM
- PHP-FPM pode redirecionar STDERR para arquivo ou para o Nginx

---

### **2. Como o Nginx Captura Logs do PHP-FPM**

**Mecanismo:**
- Nginx usa **FastCGI** para comunicação com PHP-FPM
- PHP-FPM envia **STDERR** para o Nginx através do FastCGI
- Nginx captura STDERR e escreve no `error_log` do Nginx

**Configuração no Nginx:**
```nginx
error_log /var/log/nginx/error.log warn;
fastcgi_intercept_errors on;  # Intercepta erros do FastCGI
```

**Comportamento:**
- Quando PHP-FPM envia STDERR, Nginx captura e escreve no `error_log`
- Mensagens aparecem com prefixo: `FastCGI sent in stderr:`
- Formato: `[timestamp] [error_level] [worker_id]: FastCGI sent in stderr: "PHP message: ..."`

---

### **3. PHP-FPM catch_workers_output**

**Diretiva Importante:**
```ini
catch_workers_output = yes
```

**Comportamento:**
- Se `catch_workers_output = yes`: PHP-FPM captura STDERR dos workers e escreve no log do PHP-FPM
- Se `catch_workers_output = no`: STDERR vai direto para o Nginx (via FastCGI)

**Localização dos Logs:**
- **Se `catch_workers_output = yes`:** Logs aparecem em `/var/log/php8.3-fpm.log`
- **Se `catch_workers_output = no`:** Logs aparecem no Nginx `error_log` (com prefixo FastCGI)

---

## 📊 ONDE OS LOGS DO CURL APARECEM

### **Cenário 1: catch_workers_output = yes**

**Comportamento:**
- `error_log()` → STDERR → PHP-FPM captura → `/var/log/php8.3-fpm.log`

**Resultado:**
- ✅ Logs do cURL aparecem em `/var/log/php8.3-fpm.log`
- ❌ Logs do cURL **NÃO aparecem** no Nginx `error_log`

**Verificação:**
```bash
grep -E '\[ProfessionalLogger\].*cURL' /var/log/php8.3-fpm.log
```

---

### **Cenário 2: catch_workers_output = no**

**Comportamento:**
- `error_log()` → STDERR → PHP-FPM envia para Nginx → Nginx `error_log`

**Resultado:**
- ✅ Logs do cURL aparecem no Nginx `error_log` (com prefixo FastCGI)
- ❌ Logs do cURL **NÃO aparecem** em `/var/log/php8.3-fpm.log`

**Formato no Nginx:**
```
[timestamp] [error] [worker_id]: FastCGI sent in stderr: "PHP message: [ProfessionalLogger] cURL sucesso..."
```

**Verificação:**
```bash
grep -E '\[ProfessionalLogger\].*cURL' /var/log/nginx/dev_error.log
```

---

### **Cenário 3: error_log Configurado no PHP-FPM**

**Comportamento:**
- `error_log()` → Arquivo configurado em `php_admin_value[error_log]`

**Resultado:**
- ✅ Logs do cURL aparecem no arquivo configurado
- ❌ Logs do cURL **NÃO aparecem** no Nginx `error_log`
- ❌ Logs do cURL **NÃO aparecem** em `/var/log/php8.3-fpm.log`

**Verificação:**
```bash
# Verificar configuração
grep 'error_log' /etc/php/8.3/fpm/pool.d/www.conf

# Buscar no arquivo configurado
grep -E '\[ProfessionalLogger\].*cURL' /caminho/configurado/error.log
```

---

## 🔍 VERIFICAÇÃO NO SERVIDOR ATUAL

### **Configuração Atual (Produção):**

**PHP-FPM (`/etc/php/8.3/fpm/pool.d/www.conf`):**
```ini
catch_workers_output = no  # (verificar no servidor)
```

**Nginx:**
```nginx
error_log /var/log/nginx/dev_error.log warn;
fastcgi_intercept_errors on;  # (verificar no servidor)
```

**PHP:**
```ini
log_errors = On
error_log = (não especificado - usa padrão)
```

---

## 📋 CONCLUSÕES FINAIS

### **1. Por Que Logs do cURL Não Aparecem no Nginx error_log**

**Causa Mais Provável:**
- `catch_workers_output = yes` no PHP-FPM
- Logs são capturados pelo PHP-FPM e escritos em `/var/log/php8.3-fpm.log`
- Logs **NÃO são enviados** para o Nginx

**Solução:**
- Verificar configuração de `catch_workers_output` no PHP-FPM
- Se `yes`, buscar logs em `/var/log/php8.3-fpm.log`
- Se `no`, buscar logs no Nginx `error_log`

---

### **2. Onde Buscar Logs do cURL**

**Prioridade 1: PHP-FPM Log**
```bash
# Se catch_workers_output = yes
grep -E '\[ProfessionalLogger\].*cURL' /var/log/php8.3-fpm.log | tail -20
```

**Prioridade 2: Nginx Error Log**
```bash
# Se catch_workers_output = no
grep -E '\[ProfessionalLogger\].*cURL' /var/log/nginx/dev_error.log | tail -20
```

**Prioridade 3: Arquivo Configurado**
```bash
# Se error_log configurado no PHP-FPM
grep -E '\[ProfessionalLogger\].*cURL' $(grep 'error_log' /etc/php/8.3/fpm/pool.d/www.conf | cut -d'=' -f2) | tail -20
```

---

### **3. Recomendações**

**Para Garantir que Logs Apareçam no Nginx:**
1. Configurar `catch_workers_output = no` no PHP-FPM
2. Configurar `fastcgi_intercept_errors on` no Nginx
3. Verificar que `log_errors = On` no PHP

**Para Garantir que Logs Apareçam no PHP-FPM:**
1. Configurar `catch_workers_output = yes` no PHP-FPM
2. Verificar que `/var/log/php8.3-fpm.log` existe e tem permissões corretas

**Para Garantir que Logs Apareçam em Arquivo Específico:**
1. Configurar `php_admin_value[error_log] = /caminho/arquivo.log` no PHP-FPM
2. Garantir permissões de escrita no arquivo

---

## 🔧 SCRIPTS DE VERIFICAÇÃO

### **Script 1: Verificar Configuração Atual**

```bash
#!/bin/bash
echo "=== CONFIGURAÇÃO ATUAL ==="
echo ""
echo "1. PHP-FPM catch_workers_output:"
grep 'catch_workers_output' /etc/php/8.3/fpm/pool.d/www.conf | grep -v '^;'

echo ""
echo "2. PHP-FPM error_log:"
grep 'error_log' /etc/php/8.3/fpm/pool.d/www.conf | grep -v '^;'

echo ""
echo "3. PHP log_errors:"
php -r "echo ini_get('log_errors') ? 'On' : 'Off'; echo PHP_EOL;"

echo ""
echo "4. PHP error_log:"
php -r "echo ini_get('error_log') ?: 'STDERR (padrão)'; echo PHP_EOL;"

echo ""
echo "5. Nginx fastcgi_intercept_errors:"
grep 'fastcgi_intercept_errors' /etc/nginx/nginx.conf /etc/nginx/sites-enabled/* 2>/dev/null | grep -v '^;'
```

---

### **Script 2: Buscar Logs do cURL em Todos os Locais Possíveis**

```bash
#!/bin/bash
echo "=== BUSCA DE LOGS DO CURL ==="
echo ""

echo "1. PHP-FPM Log:"
grep -E '\[ProfessionalLogger\].*cURL' /var/log/php8.3-fpm.log 2>/dev/null | tail -10 || echo "Nenhum log encontrado"

echo ""
echo "2. Nginx Error Log:"
grep -E '\[ProfessionalLogger\].*cURL' /var/log/nginx/dev_error.log 2>/dev/null | tail -10 || echo "Nenhum log encontrado"

echo ""
echo "3. Arquivo Configurado (se existir):"
ERROR_LOG_FILE=$(grep 'php_admin_value\[error_log\]' /etc/php/8.3/fpm/pool.d/www.conf 2>/dev/null | grep -v '^;' | cut -d'=' -f2 | tr -d ' ')
if [ -n "$ERROR_LOG_FILE" ] && [ -f "$ERROR_LOG_FILE" ]; then
    grep -E '\[ProfessionalLogger\].*cURL' "$ERROR_LOG_FILE" 2>/dev/null | tail -10 || echo "Nenhum log encontrado"
else
    echo "Nenhum arquivo configurado ou arquivo não existe"
fi
```

---

## 📝 RESUMO EXECUTIVO

### **Conclusão Principal:**

Os logs do cURL (gerados via `error_log()` no PHP) aparecem em **diferentes locais** dependendo da configuração do PHP-FPM:

1. **Se `catch_workers_output = yes`:** Logs aparecem em `/var/log/php8.3-fpm.log`
2. **Se `catch_workers_output = no`:** Logs aparecem no Nginx `error_log` (com prefixo FastCGI)
3. **Se `error_log` configurado:** Logs aparecem no arquivo configurado

### **Recomendação:**

**Verificar configuração atual** e buscar logs no local apropriado. O script de verificação acima pode ser usado para identificar onde os logs estão sendo escritos.

---

**Análise realizada em:** 25/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA BASEADA NA DOCUMENTAÇÃO OFICIAL**

