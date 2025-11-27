# 🔍 ANÁLISE: Integração PHP-FPM com Datadog

**Data:** 25/11/2025  
**Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)  
**Contexto:** Análise das instruções de integração PHP-FPM com Datadog Agent  
**Status:** 📋 **ANÁLISE COMPLETA** - Apenas análise, sem implementação

---

## 📋 RESUMO EXECUTIVO

### **Objetivo da Análise:**
Analisar as instruções fornecidas pelo Datadog para integrar monitoramento do PHP-FPM e identificar o que seria necessário para configurar a integração no servidor DEV.

### **Conclusão:**
- ✅ Integração é **viável e recomendada**
- ⚠️ Requer configuração de endpoints `/status` e `/ping` no Nginx
- ⚠️ Requer configuração do arquivo `php_fpm.d/conf.yaml` do Datadog
- ✅ Benefícios: Monitoramento de processos, requisições lentas, requisições aceitas

---

## 🔍 ANÁLISE DAS INSTRUÇÕES DO DATADOG

### **1. Requisitos da Integração:**

**O Que É Necessário:**
1. ✅ **Datadog Agent instalado** - ✅ Já instalado
2. ✅ **Arquivo de configuração** - `php_fpm.d/conf.yaml`
3. ⚠️ **Endpoints PHP-FPM** - `/status` e `/ping` (precisam ser configurados)
4. ⚠️ **Configuração Nginx** - Para rotear `/status` e `/ping` para PHP-FPM

### **2. Configuração Necessária:**

**Arquivo:** `/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml`

**Configuração Mínima:**
```yaml
init_config:

instances:
  - status_url: http://localhost/status
    ping_url: http://localhost/ping
    use_fastcgi: false
    ping_reply: pong
```

**Opções Disponíveis:**
- `status_url`: URL para obter métricas do pool FPM
- `ping_url`: URL para verificação de saúde do pool FPM
- `use_fastcgi`: Comunicar diretamente com PHP-FPM via FastCGI (bypass Nginx)
- `ping_reply`: Resposta esperada do ping (padrão: "pong")

---

## 🔍 VERIFICAÇÃO DA CONFIGURAÇÃO ATUAL

### **1. Configuração PHP-FPM (VERIFICADA):**

**Status Path:**
- ⚠️ **Não configurado explicitamente** - Usa padrão `/status` (habilitado por padrão)
- ⚠️ **Ping Path:** Não configurado explicitamente - Usa padrão `/ping` (habilitado por padrão)

**Listen:**
- ✅ **Configurado:** Socket Unix
- ✅ **Caminho:** `/run/php/php8.3-fpm.sock`
- ✅ **Permissões:** `660` (rw-rw----)
- ✅ **Proprietário:** `www-data:www-data`

**Análise:**
- ✅ PHP-FPM usa socket Unix (mais eficiente)
- ⚠️ Socket pertence a `www-data:www-data` (usuário `dd-agent` não tem acesso direto)
- ⚠️ Endpoints `/status` e `/ping` não estão acessíveis via HTTP (Nginx retorna 404)

---

### **2. Configuração Nginx (Necessária):**

**O Que Precisa Ser Configurado:**

**Opção A: Via Nginx (Recomendado):**
```nginx
location ~ ^/(status|ping)$ {
    access_log off;
    fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;  # ou TCP
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
```

**Opção B: Via FastCGI Direto:**
- Configurar `use_fastcgi: true` no Datadog
- Usar socket Unix diretamente: `unix:///var/run/php/php8.3-fpm.sock/status`

**Análise:**
- ⚠️ **Nginx NÃO está configurado** para rotear `/status` e `/ping` (retorna 404)
- ✅ **Socket Unix existe:** `/run/php/php8.3-fpm.sock`
- ⚠️ **Permissões do socket:** `www-data:www-data` (usuário `dd-agent` não tem acesso)
- ✅ **FastCGI direto** requer ajuste de permissões do socket

---

## 📊 ANÁLISE DETALHADA DAS OPÇÕES

### **OPÇÃO 1: Via Nginx (HTTP)**

**Vantagens:**
- ✅ Usa infraestrutura existente (Nginx)
- ✅ Não requer acesso direto ao socket Unix
- ✅ Funciona mesmo se socket estiver em outro servidor
- ✅ Mais flexível (pode ter múltiplos pools)

**Desvantagens:**
- ⚠️ Requer configuração adicional no Nginx
- ⚠️ Depende do Nginx estar funcionando
- ⚠️ Pode ter latência adicional (passa pelo Nginx)

**Configuração Necessária:**
1. Adicionar location blocks no Nginx para `/status` e `/ping`
2. Configurar `php_fpm.d/conf.yaml` com URLs HTTP
3. Reiniciar Nginx e Datadog Agent

---

### **OPÇÃO 2: Via FastCGI Direto (Socket Unix)**

**Vantagens:**
- ✅ Mais rápido (bypassa Nginx)
- ✅ Não requer configuração do Nginx
- ✅ Mais direto (comunicação direta com PHP-FPM)
- ✅ Menos pontos de falha

**Desvantagens:**
- ⚠️ Requer acesso ao socket Unix do PHP-FPM
- ⚠️ **Socket atual:** `/run/php/php8.3-fpm.sock` pertence a `www-data:www-data`
- ⚠️ **Usuário `dd-agent`:** Não está no grupo `www-data`, precisa ajustar permissões
- ⚠️ Pode precisar ajustar permissões do socket ou adicionar `dd-agent` ao grupo `www-data`

**Configuração Necessária:**
1. Verificar caminho do socket Unix do PHP-FPM
2. Verificar permissões do socket (acessível por `dd-agent`)
3. Configurar `php_fpm.d/conf.yaml` com `use_fastcgi: true`
4. Usar URLs no formato: `unix:///caminho/socket.sock/status`
5. Reiniciar Datadog Agent

---

## 🔍 VERIFICAÇÕES NECESSÁRIAS

### **1. Verificar Configuração PHP-FPM:**

**Comandos:**
```bash
# Verificar status_path e ping.path
grep -E 'pm\.status_path|ping\.path' /etc/php/8.3/fpm/pool.d/www.conf

# Verificar listen (socket ou TCP)
grep -E 'listen\s*=' /etc/php/8.3/fpm/pool.d/www.conf

# Verificar se status está habilitado
grep -E 'pm\.status_path' /etc/php/8.3/fpm/pool.d/www.conf | grep -v '^;'
```

**O Que Verificar:**
- ✅ `pm.status_path` está configurado? (padrão: `/status`)
- ✅ `ping.path` está configurado? (padrão: `/ping`)
- ✅ `listen` é socket Unix ou TCP? (socket Unix é mais comum)

---

### **2. Verificar Configuração Nginx:**

**Comandos:**
```bash
# Verificar se há location para /status ou /ping
grep -r "location.*status\|location.*ping" /etc/nginx/

# Verificar fastcgi_pass configurado
grep -r "fastcgi_pass" /etc/nginx/

# Testar se endpoints respondem
curl http://localhost/status
curl http://localhost/ping
```

**O Que Verificar:**
- ⚠️ Existe location block para `/status`?
- ⚠️ Existe location block para `/ping`?
- ⚠️ Endpoints respondem corretamente?

---

### **3. Verificar Permissões (Se Usar FastCGI Direto):**

**Comandos:**
```bash
# Verificar caminho do socket
grep "listen" /etc/php/8.3/fpm/pool.d/www.conf | grep -v '^;'

# Verificar permissões do socket
ls -la /var/run/php/php8.3-fpm.sock  # ou caminho configurado

# Verificar grupo do usuário dd-agent
id dd-agent
```

**O Que Verificar:**
- ⚠️ Socket Unix existe e está acessível?
- ⚠️ Usuário `dd-agent` tem permissão para acessar socket?
- ⚠️ Grupo do socket inclui `dd-agent`?

---

## 📋 CONFIGURAÇÃO NECESSÁRIA (Resumo)

### **Cenário 1: Via Nginx (HTTP) - RECOMENDADO**

**Passos Necessários:**
1. ✅ **PHP-FPM:** `pm.status_path` e `ping.path` habilitados por padrão (verificado)
2. ⚠️ **Adicionar location blocks no Nginx** para `/status` e `/ping` (NÃO configurado - retorna 404)
3. ⚠️ **Criar arquivo** `/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml`
4. ⚠️ **Configurar** URLs HTTP (`http://localhost/status`, `http://localhost/ping`)
5. ⚠️ **Proteger endpoints** (restringir acesso apenas para localhost)
6. ⚠️ **Reiniciar** Nginx e Datadog Agent
7. ⚠️ **Validar** integração

**Arquivos a Modificar:**
- `/etc/nginx/sites-available/dev.bssegurosimediato.com.br` (ou arquivo de configuração do site)
- `/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml` (criar)

---

### **Cenário 2: Via FastCGI Direto (Socket Unix)**

**Passos Necessários:**
1. ✅ **Socket Unix:** `/run/php/php8.3-fpm.sock` (verificado)
2. ⚠️ **Permissões atuais:** `www-data:www-data` (660) - `dd-agent` não tem acesso
3. ⚠️ **Ajustar permissões:** Adicionar `dd-agent` ao grupo `www-data` OU ajustar permissões do socket
4. ⚠️ **Criar arquivo** `/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml`
5. ⚠️ **Configurar** URLs: `unix:///run/php/php8.3-fpm.sock/status` e `unix:///run/php/php8.3-fpm.sock/ping`
6. ⚠️ **Configurar** `use_fastcgi: true`
7. ⚠️ **Reiniciar** Datadog Agent
8. ⚠️ **Validar** integração

**Arquivos a Modificar:**
- `/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml` (criar)
- Permissões do socket Unix (ajustar grupo ou permissões)

**Ajuste de Permissões Necessário:**
```bash
# Opção 1: Adicionar dd-agent ao grupo www-data (RECOMENDADO)
usermod -a -G www-data dd-agent

# Opção 2: Ajustar permissões do socket (menos seguro, não persistente)
chmod 666 /run/php/php8.3-fpm.sock  # OU ajustar no PHP-FPM config
```

---

## ⚠️ CONSIDERAÇÕES IMPORTANTES

### **1. Segurança:**

**Endpoints `/status` e `/ping`:**
- ⚠️ **Devem ser protegidos** - Não devem ser acessíveis publicamente
- ✅ **Recomendação:** Restringir acesso apenas para localhost ou IPs específicos
- ✅ **Nginx:** Usar `allow 127.0.0.1; deny all;` nos location blocks

**Exemplo de Configuração Segura:**
```nginx
location ~ ^/(status|ping)$ {
    allow 127.0.0.1;
    deny all;
    access_log off;
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;  # Caminho verificado no servidor
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
```

---

### **2. Múltiplos Pools PHP-FPM:**

**Se houver múltiplos pools:**
- ⚠️ Configurar múltiplos location blocks no Nginx
- ⚠️ Configurar múltiplas instâncias no `php_fpm.d/conf.yaml`
- ✅ Usar URLs diferentes (`/status1`, `/status2`, etc.)

---

### **3. Validação:**

**Após Configuração:**
```bash
# Verificar status do Datadog Agent
datadog-agent status | grep php_fpm

# Verificar logs do Datadog
tail -f /var/log/datadog-agent/collector.log | grep php_fpm

# Testar endpoints manualmente
curl http://localhost/status
curl http://localhost/ping
```

---

## 📊 MÉTRICAS QUE SERÃO COLETADAS

### **Métricas do PHP-FPM:**

**Process States:**
- `php_fpm.processes.idle` - Processos ociosos
- `php_fpm.processes.active` - Processos ativos
- `php_fpm.processes.total` - Total de processos

**Slow Requests:**
- `php_fpm.processes.slow` - Requisições lentas

**Accepted Requests:**
- `php_fpm.requests.accepted` - Requisições aceitas
- `php_fpm.requests.total` - Total de requisições

**Pool Information:**
- `php_fpm.process_manager` - Gerenciador de processos (static, dynamic, ondemand)
- `php_fpm.processes.max_children` - Máximo de processos filhos

---

## ✅ CONCLUSÃO DA ANÁLISE

### **Viabilidade:**
✅ **Integração é VIÁVEL e RECOMENDADA**

### **Complexidade:**
⚠️ **MÉDIA** - Requer configuração do Nginx ou ajuste de permissões

### **Recomendação:**

**Opção Recomendada: Via Nginx (HTTP)**
- ✅ Mais flexível
- ✅ Usa infraestrutura existente
- ✅ Mais fácil de manter
- ⚠️ Requer configuração do Nginx

**Opção Alternativa: Via FastCGI Direto**
- ✅ Mais rápido
- ✅ Não requer Nginx
- ⚠️ Requer ajuste de permissões do socket

### **Próximos Passos (Se Implementar):**

**Status Atual Verificado:**
- ✅ PHP-FPM: Socket Unix `/run/php/php8.3-fpm.sock` (www-data:www-data)
- ✅ PHP-FPM: `pm.status_path` e `ping.path` habilitados por padrão
- ❌ Nginx: Endpoints `/status` e `/ping` NÃO configurados (retornam 404)
- ❌ Datadog: Arquivo `php_fpm.d/conf.yaml` não existe (apenas exemplo)
- ⚠️ Permissões: `dd-agent` não tem acesso ao socket Unix

**Passos para Implementação:**
1. ✅ **Verificação concluída:** Configuração atual do PHP-FPM e Nginx verificada
2. ⚠️ **Escolher método:** HTTP via Nginx (recomendado) OU FastCGI direto
3. ⚠️ **Se HTTP via Nginx:**
   - Adicionar location blocks no Nginx para `/status` e `/ping`
   - Proteger endpoints (apenas localhost)
   - Criar `php_fpm.d/conf.yaml` com URLs HTTP
4. ⚠️ **Se FastCGI direto:**
   - Adicionar `dd-agent` ao grupo `www-data` OU ajustar permissões do socket
   - Criar `php_fpm.d/conf.yaml` com URLs Unix socket
   - Configurar `use_fastcgi: true`
5. ⚠️ **Reiniciar serviços:** Nginx (se HTTP) e Datadog Agent
6. ⚠️ **Validar integração:** Verificar status do Datadog Agent e métricas coletadas

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA - SEM IMPLEMENTAÇÃO**

