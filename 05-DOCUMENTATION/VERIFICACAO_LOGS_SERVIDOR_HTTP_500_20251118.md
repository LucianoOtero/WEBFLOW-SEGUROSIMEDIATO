# 🔍 VERIFICAÇÃO DE LOGS DO SERVIDOR PARA HTTP 500

**Data:** 18/11/2025  
**Problema:** HTTP 500 no endpoint `send_email_notification_endpoint.php`  
**Servidor:** DEV (`dev.bssegurosimediato.com.br` - IP: 65.108.156.14)  
**Modo:** Apenas investigação (sem modificações)

---

## 📋 LOGS VERIFICADOS

### **1. Logs do PHP-FPM**
**Caminho:** `/var/log/php8.3-fpm.log`

**Status:** Aguardando verificação

**O que procurar:**
- Erros fatais relacionados ao endpoint
- Exceções não tratadas
- Erros de conexão com banco de dados
- Erros de carregamento de classes/funções

---

### **2. Logs do Nginx**
**Caminho:** `/var/log/nginx/error.log`

**Status:** Aguardando verificação

**O que procurar:**
- Erros 500 do FastCGI
- Timeouts do PHP-FPM
- Erros de comunicação com PHP-FPM

---

### **3. Logs de Erro do PHP**
**Caminho:** Configurado via `ini_get('error_log')`

**Status:** Aguardando verificação

**O que procurar:**
- Erros fatais do PHP
- Warnings e notices
- Erros de `error_log()` calls

---

### **4. Arquivos de Log do ProfessionalLogger**
**Caminhos possíveis:**
- `/var/www/html/dev/root/logs/professional_logger_errors.txt`
- `/var/www/html/dev/root/logs/professional_logger_fallback.txt`
- `/var/www/html/dev/root/logs/professional_logger_operations.txt`

**Status:** Aguardando verificação

**O que procurar:**
- Logs de erros capturados pelo sistema de logging
- Fallbacks de banco de dados
- Operações de logging

---

## ⚙️ CONFIGURAÇÕES VERIFICADAS

### **1. PHP Error Reporting**
- `display_errors`: Aguardando verificação
- `log_errors`: Aguardando verificação
- `error_reporting`: Aguardando verificação

### **2. PHP-FPM catch_workers_output**
- **Configuração:** Aguardando verificação
- **Importância:** Se `catch_workers_output = yes`, erros dos workers são capturados no log principal

### **3. PHP-FPM php_admin_value[error_log]**
- **Configuração:** Aguardando verificação
- **Importância:** Define onde os erros do PHP são logados

---

## 🔍 POSSÍVEIS CAUSAS DE LOGS AUSENTES

### **1. Logs Não Configurados**
- `catch_workers_output` pode estar desabilitado
- `error_log` pode não estar configurado
- Logs podem estar sendo escritos em outro local

### **2. Logs Rotacionados**
- Logs antigos podem ter sido rotacionados
- Arquivos de log podem ter sido limpos
- Logs podem estar em arquivos comprimidos (`.gz`)

### **3. Erros Silenciosos**
- Exceções podem estar sendo capturadas silenciosamente
- `@` pode estar suprimindo erros
- `error_reporting` pode estar desabilitado

### **4. Permissões**
- Arquivos de log podem não ter permissões de escrita
- Usuário do PHP-FPM pode não ter acesso ao diretório de logs

---

## 📊 RESULTADOS DA VERIFICAÇÃO

### **1. Logs do PHP-FPM** (`/var/log/php8.3-fpm.log`)
**Status:** ⚠️ **SEM ERROS ESPECÍFICOS**

**Encontrado:**
- Apenas mensagens NOTICE de inicialização/reinicialização do PHP-FPM
- Nenhum erro fatal relacionado ao endpoint
- Nenhuma exceção relacionada a `send_email_notification_endpoint.php`

**Possíveis Causas:**
- `catch_workers_output` pode estar desabilitado
- Erros podem estar sendo logados em outro local
- Erros podem estar sendo suprimidos silenciosamente

---

### **2. Logs do Nginx** (`/var/log/nginx/error.log`)
**Status:** ⚠️ **SEM ERROS RELEVANTES**

**Encontrado:**
- Nenhum erro relacionado ao endpoint
- Nenhum erro de FastCGI/PHP-FPM relacionado ao HTTP 500

---

### **3. Arquivos de Log do ProfessionalLogger**
**Status:** ⚠️ **ARQUIVOS ENCONTRADOS, MAS NÃO CONTÊM ERROS DO ENDPOINT**

**Arquivos encontrados:**
- `/var/www/html/dev/root/logs/log_endpoint_debug.txt` ✅ (contém logs do `log_endpoint.php`, não do `send_email_notification_endpoint.php`)
- `/var/www/html/dev/root/logs/flyingdonkeys_prod.txt` ✅
- `/var/www/html/dev/root/logs/webhook_octadesk_prod.txt` ✅
- `/var/www/html/dev/root/logs/professional_logger_errors.txt` ❌ **NÃO EXISTE**

**Análise:**
- `log_endpoint_debug.txt` contém apenas logs do `log_endpoint.php` (endpoint de logging)
- **Nenhum log relacionado a `send_email_notification_endpoint.php`**
- `professional_logger_errors.txt` não existe (pode não ter sido criado ainda)

---

### **4. Configuração do PHP-FPM**
**Status:** ❌ **catch_workers_output ESTÁ COMENTADO (DESABILITADO)**

**Encontrado:**
```ini
;catch_workers_output = yes
;php_admin_value[error_log] = /var/log/fpm-php.www.log
;php_admin_flag[log_errors] = on
```

**Problema Crítico:**
- `catch_workers_output` está **COMENTADO** (linha começa com `;`)
- Isso significa que erros dos workers PHP-FPM **NÃO estão sendo capturados** no log principal
- Erros podem estar sendo perdidos ou logados em outro local

**Causa Raiz do Problema:**
⚠️ **Esta é provavelmente a causa principal de não termos logs de erros HTTP 500!**

**Recomendação:**
- ✅ **Habilitar `catch_workers_output = yes`** no arquivo `/etc/php/8.3/fpm/pool.d/www.conf`
- ✅ Descomentar as linhas de configuração de logs
- ✅ Reiniciar PHP-FPM após alteração

---

## 🔍 DESCOBERTA CRÍTICA

### **Problema Identificado:**
❌ **`catch_workers_output` ESTÁ COMENTADO (DESABILITADO)**

**Esta é a causa raiz de não termos logs de erros HTTP 500!**

### **Evidências:**
1. ✅ Endpoint retorna HTTP 500 quando testado
2. ❌ Nenhum erro aparece no log do PHP-FPM (`/var/log/php8.3-fpm.log`)
3. ❌ Nenhum erro aparece no log do Nginx (`/var/log/nginx/error.log`)
4. ❌ `catch_workers_output` está comentado no arquivo de configuração
5. ❌ Arquivo `professional_logger_errors.txt` não existe

### **Por que não temos logs:**
- **`catch_workers_output = yes` está comentado** → Erros dos workers não são capturados
- Erros podem estar sendo perdidos completamente
- PHP-FPM não está logando erros dos processos workers

### **Solução:**
✅ **Habilitar `catch_workers_output = yes`** no PHP-FPM para capturar erros

---

## ✅ PRÓXIMOS PASSOS RECOMENDADOS

1. ✅ Verificar conteúdo dos arquivos de log do ProfessionalLogger
2. ✅ Verificar configuração `catch_workers_output` do PHP-FPM
3. ✅ Habilitar `catch_workers_output = yes` se necessário
4. ✅ Verificar se há erros nos arquivos de log específicos do aplicativo
5. ✅ Adicionar debugs nas linhas 109 e 118 do endpoint para capturar erros

---

**Verificação iniciada em:** 18/11/2025  
**Última atualização:** 18/11/2025 19:20  
**Status:** ⚠️ **LOGS NÃO ESTÃO CAPTURANDO ERROS HTTP 500**

