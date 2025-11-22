# 🔍 ONDE SÃO EXECUTADAS AS FUNÇÕES LogConfig::shouldLog() e $logger->log()

**Data:** 18/11/2025  
**Funções:** `LogConfig::shouldLog()` e `$logger->log()`  
**Arquivo:** `send_email_notification_endpoint.php` (linhas 109 e 118)

---

## 📍 LOCALIZAÇÃO DA EXECUÇÃO

### **Servidor de Execução:**
✅ **SERVIDOR DEV** (`dev.bssegurosimediato.com.br`)

**IP:** `65.108.156.14`  
**Ambiente:** Desenvolvimento  
**Caminho no Servidor:** `/var/www/html/dev/root/`

---

## 🔄 FLUXO DE EXECUÇÃO

### **1. Arquivo Local (Windows):**
```
C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\
WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_email_notification_endpoint.php
```

**Status:** Arquivo de desenvolvimento local (não executado aqui)

---

### **2. Arquivo no Servidor DEV:**
```
/var/www/html/dev/root/send_email_notification_endpoint.php
```

**Status:** Arquivo executado quando endpoint é chamado via HTTP

---

### **3. Execução via HTTP POST:**

**Requisição:**
```
POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php
```

**Fluxo:**
1. Cliente (JavaScript no navegador) faz requisição HTTP POST
2. Nginx recebe requisição em `dev.bssegurosimediato.com.br`
3. Nginx encaminha para PHP-FPM (FastCGI Process Manager)
4. PHP-FPM executa código PHP no servidor DEV
5. Código PHP carrega arquivos:
   - `config.php`
   - `ProfessionalLogger.php` (contém classe `LogConfig`)
   - `send_admin_notification_ses.php`
6. Código PHP executa:
   - Linha 103: `enviarNotificacaoAdministradores()` → **Email enviado**
   - Linha 109: `LogConfig::shouldLog($logLevel, 'EMAIL')` → **EXECUTADO NO SERVIDOR DEV**
   - Linha 118: `$logger->log($logLevel, ...)` → **EXECUTADO NO SERVIDOR DEV**

---

## 🖥️ AMBIENTE DE EXECUÇÃO

### **Servidor DEV:**
- **Hostname:** `dev.bssegurosimediato.com.br`
- **IP:** `65.108.156.14`
- **Sistema Operacional:** Linux
- **Servidor Web:** Nginx
- **Processador PHP:** PHP-FPM 8.3
- **Caminho Raiz:** `/var/www/html/dev/root/`

### **Onde o Código PHP é Executado:**
✅ **NO SERVIDOR DEV** (`65.108.156.14`)

**Processo:**
- PHP-FPM recebe requisição do Nginx
- PHP-FPM cria processo worker PHP
- Processo worker executa código PHP no servidor
- Código PHP acessa:
  - Variáveis de ambiente do PHP-FPM (`$_ENV`)
  - Sistema de arquivos do servidor (`/var/www/html/dev/root/`)
  - Banco de dados MySQL/MariaDB (via PDO)
  - Serviços externos (AWS SES)

---

## 📊 ONDE CADA FUNÇÃO É EXECUTADA

### **`LogConfig::shouldLog()` (Linha 109):**

**Localização:**
- **Arquivo:** `/var/www/html/dev/root/ProfessionalLogger.php` (linha 123)
- **Executado em:** Servidor DEV (`65.108.156.14`)
- **Processo:** PHP-FPM worker process
- **Acessa:**
  - `$_ENV` (variáveis de ambiente do PHP-FPM)
  - `LogConfig::load()` (método estático)
  - `LogConfig::parseBool()` e `LogConfig::parseArray()` (métodos estáticos)

**Contexto:**
- Executado **DEPOIS** do email ser enviado (linha 103)
- Executado **ANTES** de `$logger->log()` (linha 118)
- Executado **NO SERVIDOR**, não no cliente

---

### **`$logger->log()` (Linha 118):**

**Localização:**
- **Arquivo:** `/var/www/html/dev/root/ProfessionalLogger.php` (linha 836)
- **Executado em:** Servidor DEV (`65.108.156.14`)
- **Processo:** PHP-FPM worker process
- **Acessa:**
  - `$this->prepareLogData()` (método da instância)
  - `$this->insertLog()` (método da instância)
  - `LogConfig::shouldLog()` novamente (dentro de `insertLog()`)
  - Banco de dados MySQL/MariaDB (via PDO)
  - Sistema de arquivos (para fallback de logs)

**Contexto:**
- Executado **DEPOIS** de `LogConfig::shouldLog()` retornar `true`
- Executado **NO SERVIDOR**, não no cliente
- Pode falhar se:
  - Conexão com banco de dados falhar
  - Sistema de arquivos estiver indisponível
  - Exceção não tratada for lançada

---

## 🔍 DIFERENÇA ENTRE LOCAL E SERVIDOR

### **Arquivo Local (Windows):**
- **Propósito:** Desenvolvimento e edição
- **Não executado:** Código PHP não roda no Windows
- **Deploy:** Copiado para servidor via SCP quando necessário

### **Arquivo no Servidor (Linux):**
- **Propósito:** Execução em produção/desenvolvimento
- **Executado:** Código PHP roda no servidor Linux via PHP-FPM
- **Acesso:** Via HTTP POST de qualquer cliente (navegador, JavaScript, etc.)

---

## ⚠️ IMPORTANTE

### **As funções são executadas NO SERVIDOR DEV, não no cliente:**

1. ✅ Cliente (JavaScript no navegador) faz requisição HTTP POST
2. ✅ Servidor DEV recebe requisição via Nginx
3. ✅ PHP-FPM executa código PHP no servidor
4. ✅ `LogConfig::shouldLog()` executa no servidor
5. ✅ `$logger->log()` executa no servidor
6. ✅ Resposta JSON é enviada de volta ao cliente

### **Logs e Erros:**

- **Logs do PHP:** `/var/log/php8.3-fpm.log` (no servidor DEV)
- **Logs do Nginx:** `/var/log/nginx/error.log` (no servidor DEV)
- **Logs do ProfessionalLogger:** Banco de dados ou arquivos no servidor DEV

---

## 📋 RESUMO

| Item | Valor |
|------|-------|
| **Servidor** | DEV (`dev.bssegurosimediato.com.br`) |
| **IP** | `65.108.156.14` |
| **Sistema Operacional** | Linux |
| **Processador PHP** | PHP-FPM 8.3 |
| **Caminho no Servidor** | `/var/www/html/dev/root/` |
| **Onde executa** | **NO SERVIDOR DEV** (não no cliente) |
| **Processo** | PHP-FPM worker process |
| **Acesso** | Via HTTP POST de qualquer cliente |

---

**Documento criado em:** 18/11/2025  
**Status:** ✅ **CONCLUÍDO**

