# 🔍 DIAGNÓSTICO: config_env.js.php Não Está Sendo Carregado

**Data:** 21/11/2025 21:04 UTC  
**Ambiente:** DEV (`dev.bssegurosimediato.com.br`)  
**Status:** 🔴 **PROBLEMA IDENTIFICADO**

---

## 🚨 PROBLEMA IDENTIFICADO

### Erro nos Logs do Nginx

```
connect() to unix:/run/php/php8.3-fpm.sock failed (11: Resource temporarily unavailable)
```

**Causa Raiz:** Todos os 20 processos PHP-FPM estão ocupados e não há processos disponíveis para processar novas requisições.

---

## 📊 STATUS ATUAL DO PHP-FPM

```
Status: "Processes active: 20, idle: 0, Requests: 997, slow: 0, Traffic: 1.80req/sec"
Processos ativos: 20/20 (100% ocupados)
Processos idle: 0/20 (0% disponíveis)
```

**Problema:** 
- ✅ Limite aumentado para 20 processos
- ❌ Todos os 20 processos estão ocupados
- ❌ Nenhum processo disponível para novas requisições
- ❌ Nginx não consegue conectar ao PHP-FPM socket

---

## 🔍 ANÁLISE

### 1. Arquivo `config_env.js.php` Está OK

- ✅ Arquivo existe: `/var/www/html/dev/root/config_env.js.php`
- ✅ Permissões corretas: `www-data:www-data`
- ✅ Sintaxe PHP válida
- ✅ Não tem includes/requires que possam travar

### 2. Configuração Nginx Está OK

- ✅ Location block para `.php` configurado corretamente
- ✅ FastCGI pass configurado: `unix:/run/php/php8.3-fpm.sock`
- ✅ Redirecionamento HTTP → HTTPS funcionando

### 3. Problema: PHP-FPM Sem Processos Disponíveis

**Sintoma:**
- Nginx tenta conectar ao socket PHP-FPM
- Socket retorna: `Resource temporarily unavailable` (EAGAIN)
- Isso significa que **todos os processos estão ocupados**

**Possíveis causas:**
1. **Muitas requisições simultâneas** para `send_email_notification_endpoint.php`
2. **Processos ainda processando requisições antigas** (mesmo com timeout)
3. **Limite de 20 processos ainda insuficiente** para a carga atual
4. **Requisições demorando muito** para processar (mesmo com timeout AWS)

---

## 💡 SOLUÇÕES RECOMENDADAS

### 🔴 SOLUÇÃO IMEDIATA (Crítica)

**Aumentar ainda mais o limite de processos PHP-FPM:**

```ini
pm.max_children = 50        # Aumentar de 20 para 50
pm.start_servers = 10       # Aumentar de 5 para 10
pm.min_spare_servers = 5    # Aumentar de 3 para 5
pm.max_spare_servers = 20   # Aumentar de 10 para 20
```

**Justificativa:**
- Tráfego atual: 1.80 req/sec
- Se cada requisição demora ~1 segundo, precisamos de pelo menos 2 processos
- Com requisições de email (que podem demorar mais), precisamos de mais processos
- 50 processos permite lidar com picos de tráfego

### 🟡 SOLUÇÃO CURTO PRAZO

**Verificar se há processos travados novamente:**

```bash
# Verificar processos há mais de 60 segundos
ps aux | grep 'php-fpm: pool www' | awk '$10 > 60 {print}'

# Se houver processos travados, matar e recarregar
kill -9 [PID]
systemctl reload php8.3-fpm
```

### 🟢 SOLUÇÃO LONGO PRAZO

1. **Implementar fila de emails** (Redis/RabbitMQ) para processar assincronamente
2. **Monitoramento proativo** de processos PHP-FPM travados
3. **Alertas automáticos** quando `pm.max_children` for atingido
4. **Otimizar requisições de email** para serem mais rápidas

---

## 📝 PRÓXIMOS PASSOS

1. ✅ Verificar se há processos travados novamente
2. ✅ Aumentar limite de processos para 50
3. ✅ Monitorar sistema após aumento
4. ✅ Verificar se `config_env.js.php` carrega após aumento

---

**Status:** 🔴 **AGUARDANDO AUMENTO DE LIMITE DE PROCESSOS**

