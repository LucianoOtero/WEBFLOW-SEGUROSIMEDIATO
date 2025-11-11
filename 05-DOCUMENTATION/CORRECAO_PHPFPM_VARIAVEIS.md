# 🔧 CORREÇÃO: VARIÁVEIS DE AMBIENTE NO PHP-FPM

**Data:** 10/11/2025  
**Problema:** Variáveis de ambiente não estavam disponíveis via `$_ENV`  
**Solução:** Configurar `variables_order = "EGPCS"` no php.ini

---

## 🔍 PROBLEMA IDENTIFICADO

As variáveis de ambiente estavam configuradas corretamente no PHP-FPM pool (`/etc/php/8.3/fpm/pool.d/www.conf`), mas não estavam disponíveis via `$_ENV` no PHP.

**Diagnóstico:**
- ✅ Variáveis disponíveis via `getenv()`
- ✅ Variáveis disponíveis via `$_SERVER`
- ❌ Variáveis **NÃO** disponíveis via `$_ENV`

**Causa:** O `variables_order` no `php.ini` estava configurado como `"GPCS"` (sem o `"E"`), o que impede que a superglobal `$_ENV` seja populada automaticamente.

---

## ✅ SOLUÇÃO APLICADA

### 1. Configurar `variables_order` no php.ini

**Arquivo:** `/etc/php/8.3/fpm/php.ini`

**Antes:**
```ini
variables_order = "GPCS"
```

**Depois:**
```ini
variables_order = "EGPCS"
```

**Onde:**
- `E` = Environment (`$_ENV`)
- `G` = GET (`$_GET`)
- `P` = POST (`$_POST`)
- `C` = COOKIE (`$_COOKIE`)
- `S` = SERVER (`$_SERVER`)

### 2. Reiniciar PHP-FPM

```bash
systemctl restart php8.3-fpm
```

---

## 📋 CONFIGURAÇÕES NECESSÁRIAS

### PHP-FPM Pool (`/etc/php/8.3/fpm/pool.d/www.conf`)

1. **`clear_env = no`** - Permite que variáveis sejam preservadas
2. **`env[VARIAVEL] = valor`** - Define variáveis de ambiente

**Exemplo:**
```ini
[www]
clear_env = no

env[PHP_ENV] = development
env[APP_BASE_DIR] = /var/www/html/dev/root
env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br
env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,...
```

### PHP.ini (`/etc/php/8.3/fpm/php.ini`)

```ini
variables_order = "EGPCS"
```

---

## ✅ VERIFICAÇÃO

### Teste 1: Variáveis via `$_ENV`
```php
<?php
echo $_ENV['APP_BASE_URL']; // ✅ Funciona
echo $_ENV['APP_BASE_DIR']; // ✅ Funciona
?>
```

### Teste 2: Variáveis via `getenv()`
```php
<?php
echo getenv('APP_BASE_URL'); // ✅ Funciona
?>
```

### Teste 3: Funções de `config.php`
```php
<?php
require_once 'config.php';
echo getBaseUrl(); // ✅ Funciona
echo getBaseDir(); // ✅ Funciona
?>
```

---

## 📝 SCRIPTS DE CORREÇÃO

### Script 1: `corrigir_phpfpm_variaveis.sh`
- Verifica e configura `clear_env = no`
- Adiciona variáveis de ambiente ao pool
- Valida e reinicia PHP-FPM

### Script 2: `corrigir_php_variables_order.sh`
- Configura `variables_order = "EGPCS"` no php.ini
- Reinicia PHP-FPM
- Testa se `$_ENV` está funcionando

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/`

---

## 🎯 RESULTADO

✅ **Todas as variáveis de ambiente estão disponíveis via `$_ENV`**  
✅ **Funções de `config.php` funcionam corretamente**  
✅ **`config_env.js.php` funciona corretamente**  
✅ **Todos os arquivos PHP podem usar `$_ENV['VARIAVEL']`**

---

## 📚 REFERÊNCIAS

- [PHP Manual - variables_order](https://www.php.net/manual/en/ini.core.php#ini.variables-order)
- [PHP-FPM Configuration - clear_env](https://www.php.net/manual/en/install.fpm.configuration.php)
- [PHP-FPM Environment Variables](https://www.php.net/manual/en/install.fpm.configuration.php#env)

---

**Documento criado em:** 10/11/2025

