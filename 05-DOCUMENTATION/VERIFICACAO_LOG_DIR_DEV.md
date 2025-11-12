# 🔍 Verificação de LOG_DIR no Servidor DEV

## 📋 Resultado da Verificação

**Data:** 2025-11-12  
**Servidor:** DEV (`dev.bssegurosimediato.com.br` - IP: 65.108.156.14)  
**Método:** Script PHP executado via web (acesso às variáveis do PHP-FPM)

---

## ✅ Resultados da Verificação

### **1. Variável LOG_DIR**

**Status:** ❌ **NÃO DEFINIDA**

**Resultado:** `LOG_DIR` não está definida nas variáveis de ambiente do PHP-FPM.

---

### **2. Variável APP_BASE_DIR**

**Status:** ✅ **DEFINIDA**

**Valor:** `/var/www/html/dev/root`

**Verificação no PHP-FPM:**
```bash
grep -E 'env\[APP_BASE_DIR\]' /etc/php/8.3/fpm/pool.d/www.conf
```
**Resultado:** `env[APP_BASE_DIR] = /var/www/html/dev/root`

---

### **3. Diretório de Logs Calculado**

Como `LOG_DIR` não está definida, o código usa o fallback:
```php
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
```

**Diretório Final:** `/var/www/html/dev/root/logs`

**Status:** ✅ **EXISTE E ESTÁ FUNCIONANDO**

---

### **4. Verificação Completa do Diretório de Logs**

**Diretório:** `/var/www/html/dev/root/logs`

**Permissões:**
- Permissões: `0755` (drwxr-xr-x)
- Proprietário: `www-data`
- Grupo: `www-data`
- Gravável: ✅ **SIM**

**Arquivos Existentes:**
| Arquivo | Tamanho | Última Modificação |
|---------|---------|-------------------|
| `flyingdonkeys_prod.txt` | 243,465 B (237 KB) | 2025-11-11 23:04:01 |
| `log_endpoint_debug.txt` | 296,124 B (289 KB) | 2025-11-12 20:33:07 |
| `webhook_octadesk_prod.txt` | 28,350 B (28 KB) | 2025-11-11 23:02:47 |

**Observações:**
- Diretório existe e tem permissões corretas (`www-data:www-data`)
- Diretório é gravável pelo PHP-FPM
- Já contém arquivos de log de execuções anteriores

---

## 📊 Resumo

| Variável | Status | Valor |
|----------|--------|-------|
| `LOG_DIR` | ❌ Não definida | - |
| `APP_BASE_DIR` | ✅ Definida | `/var/www/html/dev/root` |
| **Diretório de Logs Usado** | ✅ Calculado | `/var/www/html/dev/root/logs` |

---

## 🎯 Conclusão

1. **`LOG_DIR` não está definida** no PHP-FPM
2. **O código usa o fallback** `getBaseDir() . '/logs'`
3. **Diretório final:** `/var/www/html/dev/root/logs`
4. **Diretório existe e está funcionando** (contém arquivos de log)

### **Arquivos de Log dos Webhooks:**

- **add_flyingdonkeys.php:** `/var/www/html/dev/root/logs/flyingdonkeys_dev.txt`
- **add_webflow_octa.php:** `/var/www/html/dev/root/logs/webhook_octadesk_prod.txt`

**Nota:** O arquivo `flyingdonkeys_prod.txt` existe no diretório, mas o código em DEV deve criar `flyingdonkeys_dev.txt`. Isso pode indicar que:
- O código foi executado em modo produção anteriormente, OU
- O arquivo `flyingdonkeys_dev.txt` será criado na próxima execução em modo DEV

---

## 📝 Variáveis de Ambiente Verificadas

| Variável | Valor |
|----------|-------|
| `PHP_ENV` | `development` |
| `APP_BASE_URL` | `https://dev.bssegurosimediato.com.br` |
| `APP_ENVIRONMENT` | `development` |
| `APP_BASE_DIR` | `/var/www/html/dev/root` |
| `LOG_DIR` | ❌ Não definida (usa fallback) |

---

## 🔧 Script Utilizado

Foi criado o script `check_log_dir.php` localmente em `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/` e copiado para o servidor para verificação via web, garantindo acesso às variáveis de ambiente do PHP-FPM.

---

**Data de Verificação:** 2025-11-12  
**Ambiente:** DEV (`dev.bssegurosimediato.com.br`)

