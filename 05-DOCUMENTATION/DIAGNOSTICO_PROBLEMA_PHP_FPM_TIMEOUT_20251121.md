# 🔍 DIAGNÓSTICO: Problema Crítico PHP-FPM - Timeout e Processos Travados

**Data:** 21/11/2025 20:47 UTC  
**Ambiente:** DEV (`dev.bssegurosimediato.com.br`)  
**Severidade:** 🔴 **CRÍTICA**

---

## 📋 RESUMO EXECUTIVO

O servidor DEV está **completamente indisponível** para processar requisições PHP devido a **todos os 5 processos PHP-FPM estarem travados** há mais de 3 horas fazendo requisições para AWS SES sem timeout configurado.

---

## 🚨 PROBLEMA IDENTIFICADO

### Status Atual dos Serviços

#### ✅ Nginx
- **Status:** Ativo e funcionando corretamente
- **Configuração:** Sintaxe válida
- **Portas:** 80 e 443 escutando corretamente

#### ❌ PHP-FPM 8.3
- **Status:** Ativo, mas **SEM PROCESSOS DISPONÍVEIS**
- **Processos ativos:** 5/5 (100% ocupados)
- **Processos idle:** 0/5 (0% disponíveis)
- **Total de requisições processadas:** 1.911
- **Tráfego:** 0.10 req/sec

### 🔴 Problema Principal

**Todos os 5 processos PHP-FPM estão travados há mais de 3 horas:**

```
PID     ELAPSED TIME    STATE    COMMAND
566161  03:13:16        S (Sleep) php-fpm: pool www
566162  03:13:16        S (Sleep) php-fpm: pool www
566263  03:20:21        S (Sleep) php-fpm: pool www
566266  03:20:20        S (Sleep) php-fpm: pool www
566270  03:20:21        S (Sleep) php-fpm: pool www
```

### 🔍 Causa Raiz Identificada

1. **Processos travados em requisições AWS SES:**
   - Todos os 5 processos têm conexões ESTABLISHED para `ec2-44-207-80-153.compute-1.amazonaws.com:443` (AWS SES)
   - Conexões estabelecidas há mais de 3 horas
   - Requisições não completaram nem falharam

2. **Falta de timeout no AWS SDK:**
   - O arquivo `send_admin_notification_ses.php` cria o cliente SES **SEM configuração de timeout**:
   ```php
   $sesClient = new \Aws\Ses\SesClient([
       'version' => 'latest',
       'region'  => AWS_REGION,
       'credentials' => [...],
       // ❌ FALTA: 'http' => ['timeout' => X, 'connect_timeout' => Y]
   ]);
   ```

3. **Limite de processos muito baixo:**
   - `pm.max_children = 5` (muito baixo para a carga atual)
   - Quando todos os 5 processos estão ocupados, **nenhuma nova requisição pode ser processada**

### 📊 Impacto

#### ❌ Arquivos PHP não carregam:
- `config_env.js.php` → **Timeout (504)**
- `send_email_notification_endpoint.php` → **Timeout (504)**
- Qualquer outro arquivo PHP → **Timeout (504)**

#### ❌ Logs de erro do Nginx:
```
upstream timed out (110: Connection timed out) while reading response header from upstream
GET /config_env.js.php HTTP/2.0 → 504 Gateway Timeout
POST /send_email_notification_endpoint.php HTTP/2.0 → 504 Gateway Timeout
```

#### ❌ Webflow não consegue carregar scripts:
- `config_env.js.php` não carrega → JavaScript não funciona
- `FooterCodeSiteDefinitivoCompleto.js` depende do PHP → não funciona
- **Sistema completamente indisponível**

---

## 🔍 INVESTIGAÇÃO DETALHADA

### 1. Conexões de Rede Ativas

Todos os processos PHP-FPM têm conexões ESTABLISHED para AWS:

```bash
tcp ESTAB 0 0 65.108.156.14:35578 → 44.207.80.153:443 (PID 566270)
tcp ESTAB 0 0 65.108.156.14:35568 → 44.207.80.153:443 (PID 566263)
tcp ESTAB 0 0 65.108.156.14:35554 → 44.207.80.153:443 (PID 566161)
tcp ESTAB 0 0 65.108.156.14:46106 → 44.207.80.153:443 (PID 566162)
tcp ESTAB 0 0 65.108.156.14:35558 → 44.207.80.153:443 (PID 566266)
```

**IP de destino:** `44.207.80.153` = `ec2-44-207-80-153.compute-1.amazonaws.com` (AWS SES)

### 2. Análise do Código

**Arquivo:** `send_admin_notification_ses.php` (linha 114-121)

```php
// ❌ PROBLEMA: Sem timeout configurado
$sesClient = new \Aws\Ses\SesClient([
    'version' => 'latest',
    'region'  => AWS_REGION,
    'credentials' => [
        'key'    => AWS_ACCESS_KEY_ID,
        'secret' => AWS_SECRET_ACCESS_KEY,
    ],
    // ❌ FALTA: Configuração de timeout HTTP
]);
```

**Solução necessária:**
```php
$sesClient = new \Aws\Ses\SesClient([
    'version' => 'latest',
    'region'  => AWS_REGION,
    'credentials' => [
        'key'    => AWS_ACCESS_KEY_ID,
        'secret' => AWS_SECRET_ACCESS_KEY,
    ],
    // ✅ ADICIONAR: Timeout para evitar travamento
    'http' => [
        'timeout' => 10,           // Timeout total da requisição (segundos)
        'connect_timeout' => 5,   // Timeout de conexão (segundos)
    ],
]);
```

### 3. Configuração PHP-FPM

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

```ini
pm.max_children = 5              # ❌ Muito baixo
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
request_terminate_timeout = 0    # ❌ Desabilitado (sem timeout global)
```

**Problemas:**
- `pm.max_children = 5` é muito baixo para a carga atual
- `request_terminate_timeout = 0` significa que processos podem rodar indefinidamente

---

## 💡 SOLUÇÕES RECOMENDADAS

### 🔴 SOLUÇÃO IMEDIATA (Crítica - Fazer AGORA)

1. **Matar processos travados:**
   ```bash
   # Identificar processos travados
   ps aux | grep 'php-fpm: pool www' | grep -v grep
   
   # Matar processos travados (forçar kill)
   kill -9 566161 566162 566263 566266 566270
   
   # PHP-FPM vai recriar processos automaticamente
   ```

2. **Recarregar PHP-FPM:**
   ```bash
   systemctl reload php8.3-fpm
   ```

### 🟡 SOLUÇÃO CURTO PRAZO (Hoje)

1. **Adicionar timeout no AWS SDK:**
   - Modificar `send_admin_notification_ses.php` para incluir timeout
   - Deploy imediato para DEV

2. **Aumentar limite de processos PHP-FPM:**
   ```ini
   pm.max_children = 20           # Aumentar de 5 para 20
   pm.start_servers = 5           # Aumentar de 2 para 5
   pm.min_spare_servers = 3       # Aumentar de 1 para 3
   pm.max_spare_servers = 10      # Aumentar de 3 para 10
   ```

3. **Configurar timeout global PHP-FPM:**
   ```ini
   request_terminate_timeout = 60  # Matar processos após 60 segundos
   ```

### 🟢 SOLUÇÃO LONGO PRAZO (Esta semana)

1. **Implementar retry com backoff exponencial** para requisições AWS SES
2. **Monitoramento proativo** de processos PHP-FPM travados
3. **Alertas automáticos** quando `pm.max_children` for atingido
4. **Revisão de todas as requisições HTTP externas** para garantir timeouts configurados

---

## 📝 ARQUIVOS ENVOLVIDOS

- `/var/www/html/dev/root/send_admin_notification_ses.php` (linha 114-121)
- `/etc/php/8.3/fpm/pool.d/www.conf`
- `/var/www/html/dev/root/ProfessionalLogger.php` (também faz requisições HTTP sem timeout adequado)

---

## ✅ CHECKLIST DE CORREÇÃO

- [ ] Matar processos travados
- [ ] Recarregar PHP-FPM
- [ ] Adicionar timeout no AWS SDK (`send_admin_notification_ses.php`)
- [ ] Aumentar `pm.max_children` para 20
- [ ] Configurar `request_terminate_timeout = 60`
- [ ] Testar envio de email após correções
- [ ] Verificar se `config_env.js.php` carrega corretamente
- [ ] Monitorar processos PHP-FPM por 24h após correções

---

## 🔗 REFERÊNCIAS

- [AWS SDK PHP - HTTP Handler Configuration](https://docs.aws.amazon.com/sdk-for-php/v3/developer-guide/guide_configuration.html#http-handler)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [Nginx upstream timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout)

---

**Status:** 🔴 **AGUARDANDO CORREÇÃO IMEDIATA**

