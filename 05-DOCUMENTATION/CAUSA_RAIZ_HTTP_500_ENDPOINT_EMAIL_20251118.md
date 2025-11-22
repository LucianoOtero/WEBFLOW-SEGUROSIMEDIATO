# 🔍 CAUSA RAIZ: HTTP 500 no Endpoint de Email

**Data:** 18/11/2025  
**Status:** ✅ **CAUSA RAIZ IDENTIFICADA**  
**Problema:** Endpoint `send_email_notification_endpoint.php` retorna HTTP 500

---

## 🎯 CAUSA RAIZ IDENTIFICADA

### **Problema Principal:**

**`config.php` lança exceção quando `APP_BASE_DIR` não está definido nas variáveis de ambiente do PHP-FPM**

**Evidência:**
1. `config.php` linha 47-51:
   ```php
   function getBaseDir() {
       $baseDir = $_ENV['APP_BASE_DIR'] ?? '';
       if (empty($baseDir)) {
           error_log('[CONFIG] ERRO CRÍTICO: APP_BASE_DIR não está definido nas variáveis de ambiente');
           throw new RuntimeException('APP_BASE_DIR não está definido nas variáveis de ambiente');
       }
       return rtrim($baseDir, '/\\');
   }
   ```

2. `send_email_notification_endpoint.php` linha 23:
   ```php
   require_once __DIR__ . '/config.php';
   ```

3. `config.php` linha 239 (executado automaticamente):
   ```php
   $CONFIG = getConfig(); // Chama getBaseDir() que lança exceção
   ```

**Fluxo do Erro:**
1. Endpoint recebe requisição POST
2. Linha 23: `require_once __DIR__ . '/config.php'`
3. `config.php` é carregado e executa `$CONFIG = getConfig()` (linha 239)
4. `getConfig()` chama `getBaseDir()` (linha 217)
5. `getBaseDir()` verifica `$_ENV['APP_BASE_DIR']`
6. Se não estiver definido → **lança RuntimeException**
7. Exceção não capturada → **HTTP 500**

---

## 🔍 POR QUE O ERRO ORIGINAL FOI CONFUNDIDO

### **Erro Original Reportado:**
- `Undefined constant PDO::MYSQL_ATTR_INIT_COMMAND`

### **Por Que Foi Confundido:**
1. O erro `PDO::MYSQL_ATTR_INIT_COMMAND` **também existe** e precisa ser corrigido
2. Mas o erro que está causando HTTP 500 **não é esse**
3. O erro real é: **`APP_BASE_DIR não está definido`**
4. A investigação focou no erro errado

### **Evidência:**
- Log de erro capturado mostra: `[CONFIG] ERRO CRÍTICO: APP_BASE_DIR não está definido`
- Teste passo-a-passo passou porque não chamou `getConfig()` diretamente
- Endpoint real falha porque `config.php` executa `$CONFIG = getConfig()` automaticamente

---

## ✅ SOLUÇÃO

### **Opção 1: Configurar Variáveis de Ambiente no PHP-FPM (RECOMENDADO)**

Adicionar `APP_BASE_DIR` e `APP_BASE_URL` nas variáveis de ambiente do PHP-FPM:

**Arquivo:** `/etc/systemd/system/php8.3-fpm.service.d/environment.conf`

```ini
[Service]
Environment="APP_BASE_DIR=/var/www/html/dev/root"
Environment="APP_BASE_URL=https://dev.bssegurosimediato.com.br"
Environment="APP_CORS_ORIGINS=https://segurosimediato-dev.webflow.io,https://dev.bssegurosimediato.com.br"
```

**Depois:** Reiniciar PHP-FPM: `systemctl restart php8.3-fpm`

---

### **Opção 2: Modificar config.php para Não Lançar Exceção (NÃO RECOMENDADO)**

Remover a exceção e usar fallback. **NÃO RECOMENDADO** porque vai contra a especificação de usar variáveis de ambiente.

---

## 📊 CONCLUSÃO

**Causa Raiz:** `APP_BASE_DIR` não está definido nas variáveis de ambiente do PHP-FPM, causando exceção em `config.php` que não é capturada, resultando em HTTP 500.

**Erro Original:** O erro `PDO::MYSQL_ATTR_INIT_COMMAND` também existe e foi corrigido, mas não era a causa do HTTP 500 atual.

**Solução:** Configurar variáveis de ambiente no PHP-FPM.

---

**Documento criado em:** 18/11/2025  
**Status:** ✅ **CAUSA RAIZ IDENTIFICADA**


