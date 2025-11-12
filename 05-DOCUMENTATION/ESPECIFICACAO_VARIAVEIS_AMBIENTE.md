# 📋 ESPECIFICAÇÃO - VARIÁVEIS DE AMBIENTE

**Data:** 08/11/2025  
**Status:** ✅ **CONFIRMADO**

---

## 🎯 VARIÁVEIS DE AMBIENTE

### **2 Variáveis que Especificam os Locais:**

| Variável | Descrição | Exemplo (DEV) | Exemplo (PROD) |
|----------|-----------|---------------|----------------|
| `APP_BASE_DIR` | **Diretório físico no servidor** onde estão os arquivos `.php` e `.js` | `/var/www/html/dev/root` | `/var/www/html/prod/root` |
| `APP_BASE_URL` | **URL base HTTP** para acessar os arquivos `.php` e `.js` via browser | `https://dev.bssegurosimediato.com.br` | `https://prod.bssegurosimediato.com.br` |

---

## 📁 LOCALIZAÇÃO DOS ARQUIVOS

### **PHP e JavaScript estão no MESMO diretório:**

**DEV:**
- **Diretório físico:** `/var/www/html/dev/root/` (dentro do container)
- **Mapeamento no host:** `/opt/webhooks-server/dev/root/`
- **URL de acesso:** `https://dev.bssegurosimediato.com.br/`

**PROD:**
- **Diretório físico:** `/var/www/html/prod/root/` (dentro do container)
- **Mapeamento no host:** `/opt/webhooks-server/prod/root/`
- **URL de acesso:** `https://prod.bssegurosimediato.com.br/`

### **Estrutura do Diretório:**
```
/var/www/html/dev/root/
├── FooterCodeSiteDefinitivoCompleto.js  ← JavaScript
├── MODAL_WHATSAPP_DEFINITIVO.js        ← JavaScript
├── webflow_injection_limpo.js          ← JavaScript
├── debug_logger_db.php                 ← PHP
├── add_travelangels.php                ← PHP
├── add_flyingdonkeys.php               ← PHP
├── add_webflow_octa.php                 ← PHP
├── cpf-validate.php                    ← PHP
├── placa-validate.php                  ← PHP
├── send_email_notification_endpoint.php ← PHP
├── send_admin_notification_ses.php     ← PHP
├── class.php                           ← PHP
└── config.php                          ← PHP
```

**✅ Todos os arquivos `.php` e `.js` estão no MESMO diretório raiz.**

---

## 🔧 COMO SÃO CHAMADOS

### **1. Arquivos JavaScript (`.js`):**

**São chamados por `fetch()` (requisições HTTP do browser):**

```javascript
// JavaScript fazendo requisição HTTP para PHP
fetch(`${getServerBaseUrl()}/debug_logger_db.php`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
})
```

**Por quê `fetch()`?**
- JavaScript roda no **browser** (cliente)
- PHP roda no **servidor**
- Para comunicação cliente ↔ servidor, precisa de **requisição HTTP**
- Mesmo que os arquivos estejam no mesmo diretório físico, o JavaScript precisa fazer uma requisição HTTP para acessar o PHP

---

### **2. Arquivos PHP (`.php`):**

**São chamados diretamente (via `require_once` ou `include`):**

```php
// PHP incluindo outro arquivo PHP diretamente
require_once __DIR__ . '/class.php';
require_once $_ENV['APP_BASE_DIR'] . '/config.php';
```

**Por quê direto?**
- PHP roda no **servidor**
- Arquivos PHP podem incluir outros arquivos PHP diretamente do sistema de arquivos
- Não precisa de requisição HTTP (está tudo no mesmo servidor)

---

## 📊 RESUMO

| Aspecto | Resposta |
|---------|----------|
| **Variáveis de ambiente** | ✅ 2 variáveis: `APP_BASE_DIR` (diretório físico) e `APP_BASE_URL` (URL HTTP) |
| **Localização PHP e JS** | ✅ **MESMO diretório:** `/var/www/html/dev/root/` |
| **Como JavaScript chama PHP** | ✅ Via `fetch()` (requisição HTTP) |
| **Como PHP chama PHP** | ✅ Diretamente (`require_once`, `include`) |

---

## 🔍 EXEMPLO PRÁTICO

### **Cenário: JavaScript precisa chamar `debug_logger_db.php`**

**1. Arquivos no servidor:**
```
/var/www/html/dev/root/
├── FooterCodeSiteDefinitivoCompleto.js  ← JavaScript aqui
└── debug_logger_db.php                  ← PHP aqui (mesmo diretório)
```

**2. JavaScript fazendo requisição:**
```javascript
// JavaScript no browser (cliente)
// Precisa fazer requisição HTTP porque está em outro domínio
fetch('https://dev.bssegurosimediato.com.br/debug_logger_db.php', {...})
```

**3. PHP incluindo outro PHP:**
```php
// PHP no servidor
// Pode incluir diretamente do sistema de arquivos
require_once __DIR__ . '/class.php';  // ✅ Direto, sem HTTP
```

---

## ✅ CONCLUSÃO

**Confirmação:**
- ✅ **2 variáveis:** `APP_BASE_DIR` (físico) e `APP_BASE_URL` (HTTP)
- ✅ **Mesmo diretório:** PHP e JavaScript estão juntos em `/var/www/html/dev/root/`
- ✅ **JavaScript → PHP:** Via `fetch()` (requisição HTTP)
- ✅ **PHP → PHP:** Diretamente (`require_once`, `include`)

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

