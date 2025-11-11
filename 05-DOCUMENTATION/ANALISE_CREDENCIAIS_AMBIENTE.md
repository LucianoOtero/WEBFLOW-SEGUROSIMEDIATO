# 🔐 ANÁLISE - CREDENCIAIS E DETECÇÃO DE AMBIENTE

**Data:** 08/11/2025  
**Status:** ⚠️ **PROBLEMA IDENTIFICADO**

---

## 🎯 SITUAÇÃO ATUAL

### **JavaScript (FooterCodeSiteDefinitivoCompleto.js):**

**Linha ~98-103:**
```javascript
// ⚠️ AMBIENTE: DESENVOLVIMENTO
window.USE_PHONE_API = true;
window.APILAYER_KEY = 'dce92fa84152098a3b5b7b8db24debbc';
window.SAFETY_TICKET = 'fc5e18c10c4aa883b2c31a305f1c09fea3834138'; // DEV
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
window.VALIDAR_PH3A = false;
```

**Problemas:**
- ❌ **Hardcoded** - Credenciais estão fixas no código
- ❌ **Sempre DEV** - Comentário diz "AMBIENTE: DESENVOLVIMENTO"
- ❌ **Não detecta ambiente** - Não escolhe credenciais diferentes para dev/prod
- ❌ **Mesmo arquivo para dev e prod** - Usa as mesmas credenciais

---

### **PHP (add_travelangels.php):**

**Linha ~57:**
```php
// Configurações específicas do webhook de desenvolvimento
$WEBFLOW_SECRET_TRAVELANGELS = $DEV_WEBFLOW_SECRETS['travelangels'];
```

**Como funciona:**
- ✅ Usa `dev_config.php` que tem `$DEV_WEBFLOW_SECRETS`
- ✅ Arquivo específico para DEV
- ⚠️ Mas não usa variáveis de ambiente do Docker

---

### **PHP (add_flyingdonkeys.php):**

**Linha ~52:**
```php
// ✅ SECRET DO WEBFLOW DE PRODUÇÃO
$WEBFLOW_SECRET_TRAVELANGELS = 'ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990';
```

**Como funciona:**
- ✅ Secret de produção hardcoded
- ⚠️ Arquivo específico para PROD
- ⚠️ Não usa variáveis de ambiente do Docker

---

## ❌ PROBLEMAS IDENTIFICADOS

### **1. JavaScript não detecta ambiente para credenciais:**
- ❌ `APILAYER_KEY` sempre a mesma (dev)
- ❌ `SAFETY_TICKET` sempre a mesma (dev)
- ❌ `SAFETY_API_KEY` mesma para dev/prod (ok, mas deveria vir de variável)

### **2. PHP não usa variáveis de ambiente para credenciais:**
- ❌ `WEBFLOW_SECRET` hardcoded ou em `dev_config.php`
- ❌ Não lê de `$_ENV['WEBFLOW_SECRET_DEV']` ou `$_ENV['WEBFLOW_SECRET_PROD']`
- ❌ Depende de arquivos diferentes para dev/prod

### **3. Não há variáveis de ambiente para credenciais no Docker:**
- ❌ `docker-compose.yml` não tem variáveis para API keys
- ❌ `docker-compose.yml` não tem variáveis para secret keys

---

## ✅ SOLUÇÃO PROPOSTA

### **1. Adicionar variáveis de ambiente no Docker:**

**docker-compose.yml:**
```yaml
php-dev:
  environment:
    - PHP_ENV=development
    - APP_BASE_DIR=/var/www/html/dev/root
    - APP_BASE_URL=https://dev.bssegurosimediato.com.br
    - APP_CORS_ORIGINS=...
    # Credenciais DEV
    - APILAYER_KEY_DEV=dce92fa84152098a3b5b7b8db24debbc
    - SAFETY_TICKET_DEV=fc5e18c10c4aa883b2c31a305f1c09fea3834138
    - SAFETY_API_KEY=20a7a1c297e39180bd80428ac13c363e882a531f
    - WEBFLOW_SECRET_TRAVELANGELS_DEV=888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
    - FLYINGDONKEYS_API_KEY_DEV=...

php-prod:
  environment:
    - PHP_ENV=production
    - APP_BASE_DIR=/var/www/html/prod/root
    - APP_BASE_URL=https://bssegurosimediato.com.br
    - APP_CORS_ORIGINS=...
    # Credenciais PROD
    - APILAYER_KEY_PROD=...
    - SAFETY_TICKET_PROD=...
    - SAFETY_API_KEY=20a7a1c297e39180bd80428ac13c363e882a531f
    - WEBFLOW_SECRET_TRAVELANGELS_PROD=ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990
    - FLYINGDONKEYS_API_KEY_PROD=82d5f667f3a65a9a43341a0705be2b0c
```

---

### **2. Modificar config_env.js.php para incluir credenciais:**

```php
<?php
header('Content-Type: application/javascript');

// Ler variáveis de ambiente do Docker
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
$environment = $_ENV['PHP_ENV'] ?? 'development';

// Ler credenciais baseadas no ambiente
$apilayer_key = $_ENV['APILAYER_KEY_' . strtoupper($environment)] ?? '';
$safety_ticket = $_ENV['SAFETY_TICKET_' . strtoupper($environment)] ?? '';
$safety_api_key = $_ENV['SAFETY_API_KEY'] ?? ''; // Mesmo para dev/prod

// Expor variáveis globais
?>
window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;

// Credenciais baseadas no ambiente
window.APILAYER_KEY = <?php echo json_encode($apilayer_key); ?>;
window.SAFETY_TICKET = <?php echo json_encode($safety_ticket); ?>;
window.SAFETY_API_KEY = <?php echo json_encode($safety_api_key); ?>;
```

---

### **3. Modificar PHP para usar variáveis de ambiente:**

**add_travelangels.php:**
```php
// Antes:
$WEBFLOW_SECRET_TRAVELANGELS = $DEV_WEBFLOW_SECRETS['travelangels'];

// Depois:
$environment = $_ENV['PHP_ENV'] ?? 'development';
$webflow_secret_key = 'WEBFLOW_SECRET_TRAVELANGELS_' . strtoupper($environment);
$WEBFLOW_SECRET_TRAVELANGELS = $_ENV[$webflow_secret_key] ?? '';
```

**add_flyingdonkeys.php:**
```php
// Antes:
$WEBFLOW_SECRET_TRAVELANGELS = 'ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990';

// Depois:
$environment = $_ENV['PHP_ENV'] ?? 'production';
$webflow_secret_key = 'WEBFLOW_SECRET_TRAVELANGELS_' . strtoupper($environment);
$WEBFLOW_SECRET_TRAVELANGELS = $_ENV[$webflow_secret_key] ?? '';
```

---

## 📋 RESUMO DA SITUAÇÃO ATUAL

| Aspecto | JavaScript | PHP |
|---------|------------|-----|
| **Detecção de ambiente** | ❌ Não detecta | ⚠️ Parcial (arquivos separados) |
| **Credenciais DEV** | ❌ Hardcoded | ⚠️ Em dev_config.php |
| **Credenciais PROD** | ❌ Não existe | ⚠️ Hardcoded |
| **Usa variáveis Docker** | ❌ Não | ❌ Não |
| **Mesmo arquivo dev/prod** | ❌ Sim (problema) | ✅ Não (arquivos separados) |

---

## ✅ SOLUÇÃO COMPLETA

### **1. Adicionar variáveis de ambiente no Docker:**
- ✅ Adicionar todas as credenciais no `docker-compose.yml`
- ✅ Separar DEV e PROD

### **2. Modificar config_env.js.php:**
- ✅ Ler credenciais de `$_ENV` baseado em `PHP_ENV`
- ✅ Expor para JavaScript

### **3. Modificar JavaScript:**
- ✅ Remover credenciais hardcoded
- ✅ Usar `window.APILAYER_KEY`, `window.SAFETY_TICKET`, etc. de `config_env.js.php`

### **4. Modificar PHP:**
- ✅ Ler credenciais de `$_ENV` baseado em `PHP_ENV`
- ✅ Remover hardcoded e `dev_config.php`

---

## 🎯 VANTAGENS DA SOLUÇÃO

1. ✅ **Centralizado** - Todas as credenciais no Docker
2. ✅ **Seguro** - Não expostas no código
3. ✅ **Automático** - Escolhe baseado em `PHP_ENV`
4. ✅ **Consistente** - Mesma lógica para dev/prod
5. ✅ **Fácil manutenção** - Mudar apenas no Docker

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

