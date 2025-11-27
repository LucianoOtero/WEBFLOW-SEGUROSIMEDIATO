# 🔧 PROJETO: Aprimoramento de Logs para Identificar Erros de Conexão FlyingDonkeys

**Data de Criação:** 25/11/2025  
**Status:** 📋 **PROJETO CRIADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.0.0  
**Ambiente:** Production (`prod.bssegurosimediato.com.br`)

---

## 🎯 OBJETIVO DO PROJETO

Aprimorar o sistema de logs para identificar com precisão a causa raiz dos erros de conexão entre `flyingdonkeys.com.br` e `prod.bssegurosimediato.com.br`, que ocorrem com frequência de 1-2 erros por dia.

### **Problema Atual:**
- ❌ Erros são reportados como "Erro ao enviar notificação" sem detalhes suficientes
- ❌ Não há informações sobre tipo de erro (timeout, rede, DNS, SSL, etc.)
- ❌ Não há logs de tempo de resposta
- ❌ Não há logs de status HTTP específicos
- ❌ Não há logs de conexão de rede nos servidores

### **Objetivo:**
- ✅ Implementar logs detalhados em todas as camadas (JavaScript, PHP, Servidor)
- ✅ Capturar informações completas sobre erros de conexão
- ✅ Identificar padrões e causas raiz dos erros
- ✅ Facilitar diagnóstico e resolução de problemas

---

## 📊 ANÁLISE DA SITUAÇÃO ATUAL

### **1. Fluxo de Erro Identificado**

```
1. MODAL_WHATSAPP_DEFINITIVO.js:840
   └─> sendAdminEmailNotification() captura exceção
   
2. FooterCodeSiteDefinitivoCompleto.js:430
   └─> sendLogToProfessionalSystem() envia log ERROR
   
3. log_endpoint.php
   └─> Recebe log e chama ProfessionalLogger->log('ERROR', ...)
   
4. ProfessionalLogger.php:859
   └─> Detecta ERROR e chama sendEmailNotification()
   
5. ProfessionalLogger.php:1053
   └─> file_get_contents() tenta chamar send_email_notification_endpoint.php
   
6. ❌ ERRO OCORRE (mas não há logs detalhados suficientes)
```

### **2. Logs Atuais Disponíveis**

#### **A. Logs em Código (JavaScript/PHP):**
- ✅ `error_log()` do PHP com mensagens básicas
- ✅ Logs no banco de dados (`application_logs`)
- ✅ Logs no console do navegador (não persistidos)
- ❌ **FALTANDO:** Logs detalhados de tempo, status HTTP, tipo de erro

#### **B. Logs no Servidor (Nginx/PHP-FPM):**
- ✅ `access_log` do Nginx (`/var/log/nginx/dev_access.log`)
- ✅ `error_log` do Nginx (`/var/log/nginx/dev_error.log`)
- ✅ Logs do PHP-FPM (se `catch_workers_output` estiver habilitado)
- ❌ **FALTANDO:** Logs específicos para endpoints críticos
- ❌ **FALTANDO:** Logs de tempo de resposta por endpoint
- ❌ **FALTANDO:** Logs de conexões de rede (DNS, timeout, SSL)

### **3. Análise de Necessidade de Logs nos Servidores**

#### **✅ SIM, é necessário implementar logs nos servidores porque:**

1. **Logs de Rede (Nginx):**
   - ⚠️ Nginx não loga automaticamente erros de conexão HTTP (timeout, DNS, SSL)
   - ⚠️ Não há logs de tempo de resposta por endpoint
   - ⚠️ Não há logs de requisições que falharam antes de chegar ao PHP

2. **Logs de PHP-FPM:**
   - ⚠️ `catch_workers_output` pode estar desabilitado (verificar)
   - ⚠️ Não há logs de tempo de execução por script
   - ⚠️ Não há logs de conexões externas (cURL, file_get_contents)

3. **Logs de Sistema (Linux):**
   - ⚠️ Não há logs de conexões de rede (DNS, firewall, timeout)
   - ⚠️ Não há logs de monitoramento de conectividade com flyingdonkeys.com.br

---

## 📁 ARQUIVOS A MODIFICAR

### **FASE 1: Logs em Código JavaScript**

#### **1.1. MODAL_WHATSAPP_DEFINITIVO.js**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`
- **Função:** `sendAdminEmailNotification()` (linhas 709-847)
- **Alterações:**
  - Adicionar logs detalhados antes do fetch (linha 786)
  - Adicionar logs detalhados após o fetch (linha 793)
  - Adicionar logs detalhados no catch (linha 838)
  - Capturar informações completas do erro (tipo, status HTTP, tempo, etc.)

#### **1.2. FooterCodeSiteDefinitivoCompleto.js**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
- **Função:** `sendLogToProfessionalSystem()` (linhas 368-574)
- **Alterações:**
  - Melhorar serialização de objetos Error do JavaScript
  - Adicionar logs de tempo de resposta
  - Adicionar logs de status HTTP detalhado

### **FASE 2: Logs em Código PHP**

#### **2.1. ProfessionalLogger.php**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
- **Método:** `sendEmailNotification()` (linhas 951-1074)
- **Alterações:**
  - Adicionar logs detalhados antes de `file_get_contents()` (linha 1052)
  - Adicionar logs detalhados após `file_get_contents()` (linha 1053)
  - Capturar `$http_response_header` para obter status HTTP
  - Logar tempo de resposta, tipo de erro, código de erro do PHP

#### **2.2. send_email_notification_endpoint.php**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_email_notification_endpoint.php`
- **Alterações:**
  - Adicionar logs de tempo de processamento
  - Adicionar logs antes/depois de chamar `enviarNotificacaoAdministradores()`
  - Logar erros específicos do AWS SES

#### **2.3. add_flyingdonkeys.php** (se aplicável)
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`
- **Alterações:**
  - Adicionar logs de tempo de conexão com API FlyingDonkeys
  - Adicionar logs de status HTTP das respostas da API
  - Adicionar logs de timeout na API

### **FASE 3: Logs no Servidor (Nginx)**

#### **3.1. nginx_prod_bssegurosimediato_com_br.conf**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_prod_bssegurosimediato_com_br.conf`
- **Alterações:**
  - Adicionar formato de log customizado com tempo de resposta
  - Adicionar logs específicos para endpoints críticos:
    - `send_email_notification_endpoint.php`
    - `log_endpoint.php`
    - `add_flyingdonkeys.php`
  - Adicionar logs de erros de conexão upstream (PHP-FPM)
  - Adicionar logs de timeout

**Formato de log customizado sugerido:**
```nginx
log_format detailed '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" '
                    'rt=$request_time uct="$upstream_connect_time" '
                    'uht="$upstream_header_time" urt="$upstream_response_time" '
                    'upstream_status="$upstream_status"';

access_log /var/log/nginx/prod_detailed_access.log detailed;
```

#### **3.2. nginx_dev_bssegurosimediato_com_br.conf** (para testes)
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_bssegurosimediato_com_br.conf`
- **Alterações:** Mesmas do arquivo de produção

### **FASE 4: Logs no Servidor (PHP-FPM)**

#### **4.1. php-fpm_www_conf_PROD.conf**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`
- **Alterações:**
  - Verificar e habilitar `catch_workers_output = yes` (se estiver desabilitado)
  - Adicionar `slowlog` para identificar scripts lentos
  - Configurar `request_slowlog_timeout` para 10 segundos
  - Configurar `request_terminate_timeout` para 60 segundos (já configurado)

**Configurações sugeridas:**
```ini
catch_workers_output = yes
php_admin_value[error_log] = /var/log/php8.3-fpm.log
php_admin_flag[log_errors] = on
slowlog = /var/log/php8.3-fpm-slow.log
request_slowlog_timeout = 10s
```

#### **4.2. php-fpm_www_conf_DEV.conf** (para testes)
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`
- **Alterações:** Mesmas do arquivo de produção

### **FASE 5: Scripts de Monitoramento (Opcional - Futuro)**

#### **5.1. Script de Monitoramento de Conectividade**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/monitor_flyingdonkeys_connectivity.sh`
- **Função:** Monitorar conectividade com flyingdonkeys.com.br periodicamente
- **Logs:**
  - Teste de DNS (resolução de nome)
  - Teste de conectividade TCP (porta 443)
  - Teste de SSL/TLS
  - Tempo de resposta HTTP
  - Status HTTP

#### **5.2. Script de Análise de Logs**
- **Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/analyze_connection_errors.sh`
- **Função:** Analisar logs e identificar padrões de erros
- **Funcionalidades:**
  - Agrupar erros por tipo (timeout, DNS, SSL, HTTP)
  - Identificar horários mais frequentes de erros
  - Calcular tempo médio de resposta
  - Gerar relatório de erros

---

## 🔄 FASES DO PROJETO

### **FASE 1: Preparação e Backup**
1. ✅ Criar diretório de backup
2. ✅ Fazer backup de todos os arquivos que serão modificados
3. ✅ Verificar configurações atuais dos servidores
4. ✅ Documentar estado atual dos logs

### **FASE 2: Implementação de Logs em Código JavaScript**
1. ✅ Modificar `MODAL_WHATSAPP_DEFINITIVO.js`
   - Adicionar logs detalhados em `sendAdminEmailNotification()`
2. ✅ Modificar `FooterCodeSiteDefinitivoCompleto.js`
   - Melhorar logs em `sendLogToProfessionalSystem()`

### **FASE 3: Implementação de Logs em Código PHP**
1. ✅ Modificar `ProfessionalLogger.php`
   - Adicionar logs detalhados em `sendEmailNotification()`
2. ✅ Modificar `send_email_notification_endpoint.php`
   - Adicionar logs de tempo de processamento
3. ✅ Modificar `add_flyingdonkeys.php` (se aplicável)
   - Adicionar logs de conexão com API

### **FASE 4: Implementação de Logs no Servidor (Nginx)**
1. ✅ Criar arquivo de configuração Nginx com formato de log customizado
2. ✅ Adicionar logs específicos para endpoints críticos
3. ✅ Testar configuração em DEV antes de aplicar em PROD

### **FASE 5: Implementação de Logs no Servidor (PHP-FPM)**
1. ✅ Verificar configuração atual do PHP-FPM
2. ✅ Habilitar `catch_workers_output` (se necessário)
3. ✅ Configurar `slowlog` para identificar scripts lentos
4. ✅ Testar configuração em DEV antes de aplicar em PROD

### **FASE 6: Deploy e Testes**
1. ✅ Deploy em ambiente DEV
2. ✅ Testar logs em DEV
3. ✅ Verificar se logs estão sendo gerados corretamente
4. ✅ Validar que logs contêm informações necessárias
5. ✅ Deploy em ambiente PROD (após validação em DEV)

### **FASE 7: Monitoramento e Análise**
1. ✅ Coletar logs por 1 semana
2. ✅ Analisar padrões de erros
3. ✅ Identificar causas raiz
4. ✅ Documentar descobertas

### **FASE 8: Otimização (Futuro)**
1. ⚠️ Implementar scripts de monitoramento (FASE 5 - Opcional)
2. ⚠️ Implementar alertas automáticos
3. ⚠️ Implementar dashboard de monitoramento

---

## 📋 ESPECIFICAÇÕES TÉCNICAS

### **1. Logs em JavaScript**

#### **Informações a Logar:**
- ✅ Timestamp de início/fim da requisição
- ✅ URL completa chamada
- ✅ Método HTTP (POST, GET, etc.)
- ✅ Payload enviado (sanitizado)
- ✅ Tempo de resposta (ms)
- ✅ Status HTTP
- ✅ Headers da resposta
- ✅ Tipo de erro (NetworkError, TimeoutError, TypeError, etc.)
- ✅ Mensagem completa do erro
- ✅ Stack trace completo
- ✅ Tamanho da resposta

#### **Formato de Log:**
```javascript
{
  timestamp: '2025-11-25T12:56:29.000Z',
  operation: 'sendAdminEmailNotification',
  url: 'https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php',
  method: 'POST',
  request_start: 1234567890.123,
  request_end: 1234567891.456,
  duration_ms: 1333,
  status: 200,
  status_text: 'OK',
  response_size: 1024,
  error_type: null,
  error_message: null,
  error_stack: null,
  payload: { /* sanitizado */ }
}
```

### **2. Logs em PHP**

#### **Informações a Logar:**
- ✅ Timestamp de início/fim da operação
- ✅ Endpoint chamado
- ✅ Timeout configurado
- ✅ Tempo de resposta (ms)
- ✅ Status HTTP (via `$http_response_header`)
- ✅ Tamanho da resposta
- ✅ Tipo de erro (timeout, connection, SSL, etc.)
- ✅ Código de erro do PHP (`error_get_last()`)
- ✅ Payload enviado (sanitizado)

#### **Formato de Log:**
```php
[
  'timestamp' => '2025-11-25 12:56:29.000000',
  'operation' => 'sendEmailNotification',
  'endpoint' => 'https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php',
  'timeout' => 10,
  'request_start' => 1234567890.123,
  'request_end' => 1234567891.456,
  'duration_ms' => 1333,
  'http_status' => 200,
  'response_size' => 1024,
  'error_type' => null,
  'error_code' => null,
  'error_message' => null,
  'http_response_headers' => [ /* headers */ ]
]
```

### **3. Logs no Nginx**

#### **Formato de Log Customizado:**
```nginx
log_format detailed '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent" '
                    'rt=$request_time uct="$upstream_connect_time" '
                    'uht="$upstream_header_time" urt="$upstream_response_time" '
                    'upstream_status="$upstream_status" '
                    'upstream_addr="$upstream_addr"';
```

#### **Informações Capturadas:**
- ✅ IP do cliente
- ✅ Timestamp
- ✅ Requisição completa
- ✅ Status HTTP
- ✅ Tamanho da resposta
- ✅ Tempo de resposta total (`request_time`)
- ✅ Tempo de conexão upstream (`upstream_connect_time`)
- ✅ Tempo de header upstream (`upstream_header_time`)
- ✅ Tempo de resposta upstream (`upstream_response_time`)
- ✅ Status upstream (`upstream_status`)
- ✅ Endereço upstream (`upstream_addr`)

### **4. Logs no PHP-FPM**

#### **Configurações:**
```ini
catch_workers_output = yes
php_admin_value[error_log] = /var/log/php8.3-fpm.log
php_admin_flag[log_errors] = on
slowlog = /var/log/php8.3-fpm-slow.log
request_slowlog_timeout = 10s
```

#### **Informações Capturadas:**
- ✅ Erros dos workers PHP-FPM
- ✅ Scripts que demoram mais de 10 segundos
- ✅ Stack trace de erros
- ✅ Tempo de execução de scripts lentos

---

## 🚨 CONTROLES NOS SERVIDORES

### **1. Verificação de Necessidade**

#### **✅ SIM, é necessário implementar controles nos servidores porque:**

1. **Logs de Nginx:**
   - ⚠️ Atualmente não capturam informações suficientes sobre conexões upstream
   - ⚠️ Não há logs de tempo de resposta por endpoint
   - ⚠️ Não há logs de erros de conexão HTTP (timeout, DNS, SSL)

2. **Logs de PHP-FPM:**
   - ⚠️ `catch_workers_output` pode estar desabilitado
   - ⚠️ Não há logs de scripts lentos (`slowlog`)
   - ⚠️ Não há logs de conexões externas (cURL, file_get_contents)

3. **Logs de Sistema:**
   - ⚠️ Não há monitoramento de conectividade com flyingdonkeys.com.br
   - ⚠️ Não há logs de DNS, firewall, ou problemas de rede

### **2. Controles a Implementar**

#### **A. Nginx:**
- ✅ Formato de log customizado com tempo de resposta
- ✅ Logs específicos para endpoints críticos
- ✅ Logs de erros upstream (PHP-FPM)

#### **B. PHP-FPM:**
- ✅ Habilitar `catch_workers_output`
- ✅ Configurar `slowlog` para scripts lentos
- ✅ Logs de erros detalhados

#### **C. Sistema (Opcional - Futuro):**
- ⚠️ Script de monitoramento de conectividade
- ⚠️ Logs de DNS, firewall, rede

---

## 📁 BACKUPS A CRIAR

### **Antes de Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/[timestamp]_APRIMORAMENTO_LOGS_CONEXAO/`
  - `MODAL_WHATSAPP_DEFINITIVO.js.backup`
  - `FooterCodeSiteDefinitivoCompleto.js.backup`
  - `ProfessionalLogger.php.backup`
  - `send_email_notification_endpoint.php.backup`
  - `add_flyingdonkeys.php.backup` (se aplicável)
  - `nginx_prod_bssegurosimediato_com_br.conf.backup`
  - `nginx_dev_bssegurosimediato_com_br.conf.backup`
  - `php-fpm_www_conf_PROD.conf.backup`
  - `php-fpm_www_conf_DEV.conf.backup`

---

## ✅ CRITÉRIOS DE ACEITAÇÃO

### **1. Logs em Código:**
- ✅ Todos os erros de conexão incluem tipo de erro específico
- ✅ Todos os erros incluem tempo de resposta
- ✅ Todos os erros incluem status HTTP (quando disponível)
- ✅ Todos os erros incluem stack trace completo
- ✅ Logs são persistidos no banco de dados

### **2. Logs no Servidor:**
- ✅ Nginx gera logs com formato customizado
- ✅ PHP-FPM captura erros dos workers
- ✅ PHP-FPM loga scripts lentos (>10s)
- ✅ Logs são acessíveis e analisáveis

### **3. Diagnóstico:**
- ✅ É possível identificar causa raiz dos erros
- ✅ É possível identificar padrões (horários, tipos, etc.)
- ✅ É possível calcular tempo médio de resposta
- ✅ É possível identificar problemas de rede

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Riscos Identificados:**

1. **Performance:**
   - ⚠️ Logs adicionais podem impactar performance
   - ✅ **Mitigação:** Logs assíncronos quando possível, sanitização de dados

2. **Espaço em Disco:**
   - ⚠️ Logs detalhados podem consumir muito espaço
   - ✅ **Mitigação:** Rotação de logs, retenção de 30 dias

3. **Complexidade:**
   - ⚠️ Muitos logs podem dificultar análise
   - ✅ **Mitigação:** Formato estruturado, scripts de análise

4. **Configuração do Servidor:**
   - ⚠️ Alterações no Nginx/PHP-FPM podem causar problemas
   - ✅ **Mitigação:** Testar em DEV primeiro, backup completo

---

## 📊 MÉTRICAS DE SUCESSO

### **Após 1 Semana de Coleta:**
- ✅ Identificar causa raiz de pelo menos 80% dos erros
- ✅ Identificar padrões de erros (horários, tipos, etc.)
- ✅ Calcular tempo médio de resposta
- ✅ Identificar se erros são de rede, timeout, ou processamento

---

## 📝 NOTAS IMPORTANTES

1. **Ambiente de Trabalho:**
   - ✅ Trabalhar apenas em DEV primeiro
   - ✅ Testar completamente em DEV antes de aplicar em PROD
   - ✅ Seguir diretivas do projeto (backups, documentação, etc.)

2. **Cache Cloudflare:**
   - ⚠️ Após atualizar arquivos `.js` no servidor, avisar sobre necessidade de limpar cache do Cloudflare

3. **Produção:**
   - 🚨 **ALERTA:** Procedimento para produção será seguido conforme diretivas
   - ⚠️ Aplicar em PROD apenas após validação completa em DEV

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- `ANALISE_ERROS_CONEXAO_FLYINGDONKEYS_20251125.md` - Análise inicial do problema
- `VERIFICACAO_LOGS_SERVIDOR_HTTP_500_20251118.md` - Verificação de logs do servidor
- `DIAGNOSTICO_PROBLEMA_PHP_FPM_TIMEOUT_20251121.md` - Diagnóstico de timeout PHP-FPM

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Status:** 📋 Projeto criado - Aguardando autorização para iniciar implementação

