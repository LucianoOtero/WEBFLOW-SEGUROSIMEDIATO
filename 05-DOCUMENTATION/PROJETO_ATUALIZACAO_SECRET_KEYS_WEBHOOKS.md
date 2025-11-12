# 🔐 PROJETO: ATUALIZAÇÃO DE SECRET KEYS DE WEBHOOKS WEBFLOW

**Data:** 11/11/2025  
**Status:** 📋 **PLANEJAMENTO**  
**Ambiente:** DEV (preparação para PROD)

---

## 🎯 OBJETIVO

Atualizar as secret keys de webhooks do Webflow no ambiente de desenvolvimento e preparar a arquitetura para atualização em produção.

---

## 📋 NOVAS SECRET KEYS

### **Secret Keys Criadas no Webflow (DEV):**

| Webhook | Secret Key | Substitui |
|---------|-----------|-----------|
| `add_flyingdonkeys` | `5e93a6f31e520738ce8bf4770f32929bec207696ad9ca54f6f5e67813c33ae40` | `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` |
| `add_webflow_octa` | `000b928364360d28af0db403c33aa5ec39d8ea9a8358add26a41f9ef951e6246` | `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291` |

**Origem:** Webflow Dashboard → `segurosimediato-dev.webflow.io` → Webhooks

---

## 🔍 ONDE AS SECRET KEYS ESTÃO ARMAZENADAS

### **1. Arquivo `config.php` (Funções com Fallback)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`

**Funções:**
- `getWebflowSecretFlyingDonkeys()` (linha 169-173)
- `getWebflowSecretOctaDesk()` (linha 179-183)

**Lógica:**
```php
function getWebflowSecretFlyingDonkeys() {
    return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'] ?? (isDevelopment()
        ? '888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142'  // ← ATUALIZAR
        : 'ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990');
}

function getWebflowSecretOctaDesk() {
    return $_ENV['WEBFLOW_SECRET_OCTADESK'] ?? (isDevelopment()
        ? '1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291'  // ← ATUALIZAR
        : '4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f');
}
```

**Prioridade:**
1. ✅ Variável de ambiente `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']` (se existir)
2. ⚠️ Fallback hardcoded baseado em `isDevelopment()`

---

### **2. Variáveis de Ambiente PHP-FPM (Servidor DEV)**

**Localização:** `/etc/php/8.3/fpm/pool.d/www.conf` (no servidor)

**Variáveis:**
```ini
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142  # ← ATUALIZAR
env[WEBFLOW_SECRET_OCTADESK] = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291  # ← ATUALIZAR
```

**Como são carregadas:**
- PHP-FPM carrega essas variáveis em todas as requisições PHP
- Acessíveis via `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']` e `$_ENV['WEBFLOW_SECRET_OCTADESK']`

---

### **3. Arquivo `dev_config.php` (Configuração de Desenvolvimento)**

**Localização:** `dev_config.php` (raiz do projeto)

**Array:**
```php
$DEV_WEBFLOW_SECRETS = [
    'travelangels' => '888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142',  // ← ATUALIZAR
    'octadesk' => '1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291'  // ← ATUALIZAR
];
```

**Uso:**
- Carregado por `add_flyingdonkeys.php` quando `$is_dev && isset($DEV_WEBFLOW_SECRETS)`
- Usado como fallback se variável de ambiente não estiver disponível

---

### **4. Arquivo `add_flyingdonkeys.php` (Lógica de Seleção)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

**Lógica (linhas 66-82):**
```php
if ($is_dev && isset($DEV_WEBFLOW_SECRETS) && isset($DEV_LOGGING)) {
    // AMBIENTE DE DESENVOLVIMENTO
    $WEBFLOW_SECRET_TRAVELANGELS = $DEV_WEBFLOW_SECRETS['flyingdonkeys'] ?? $DEV_WEBFLOW_SECRETS['travelangels'] ?? '';
    // ...
} else {
    // AMBIENTE DE PRODUÇÃO
    $WEBFLOW_SECRET_TRAVELANGELS = 'ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990';
    // ...
}
```

**Ordem de prioridade:**
1. ✅ `$DEV_WEBFLOW_SECRETS['flyingdonkeys']` (se `dev_config.php` carregado)
2. ✅ `$DEV_WEBFLOW_SECRETS['travelangels']` (fallback)
3. ⚠️ Hardcoded para PROD

**Nota:** Este arquivo também pode usar `getWebflowSecretFlyingDonkeys()` se `$DEV_WEBFLOW_SECRETS` não estiver disponível.

---

### **5. Arquivo `add_webflow_octa.php` (Variável Local)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_webflow_octa.php`

**Variável (linha 57):**
```php
$WEBFLOW_SECRET_OCTADESK = '4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f'; // ← PROD
```

**Nota:** Este arquivo define a secret key localmente, mas também pode usar `getWebflowSecretOctaDesk()` de `config.php`.

---

## 📝 PLANO DE IMPLEMENTAÇÃO

### **FASE 1: Atualizar Arquivos Locais (DEV)**

#### **1.1. Atualizar `config.php`**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`

**Alterações:**
- Linha 171: Atualizar fallback DEV de `getWebflowSecretFlyingDonkeys()`
- Linha 181: Atualizar fallback DEV de `getWebflowSecretOctaDesk()`

**Valores novos:**
- `WEBFLOW_SECRET_FLYINGDONKEYS` (DEV): `5e93a6f31e520738ce8bf4770f32929bec207696ad9ca54f6f5e67813c33ae40`
- `WEBFLOW_SECRET_OCTADESK` (DEV): `000b928364360d28af0db403c33aa5ec39d8ea9a8358add26a41f9ef951e6246`

---

#### **1.2. Atualizar `dev_config.php`**

**Arquivo:** `dev_config.php`

**Alterações:**
- Linha 35: Atualizar `$DEV_WEBFLOW_SECRETS['travelangels']` (ou `['flyingdonkeys']`)
- Linha 36: Atualizar `$DEV_WEBFLOW_SECRETS['octadesk']`

**Valores novos:**
- `'travelangels'` ou `'flyingdonkeys'`: `5e93a6f31e520738ce8bf4770f32929bec207696ad9ca54f6f5e67813c33ae40`
- `'octadesk'`: `000b928364360d28af0db403c33aa5ec39d8ea9a8358add26a41f9ef951e6246`

---

### **FASE 2: Atualizar Servidor DEV**

#### **2.1. Conectar ao Servidor DEV**

**⚠️ IMPORTANTE:** Conectar apenas ao servidor DEV (65.108.156.14) com autorização expressa.

**Comando:**
```bash
ssh root@65.108.156.14
```

---

#### **2.2. Fazer Backup do PHP-FPM Pool**

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Comando:**
```bash
cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup.$(date +%Y%m%d_%H%M%S)
```

---

#### **2.3. Atualizar Variáveis de Ambiente PHP-FPM**

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Comandos:**
```bash
# Atualizar WEBFLOW_SECRET_FLYINGDONKEYS
sed -i 's|env\[WEBFLOW_SECRET_FLYINGDONKEYS\] = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142|env[WEBFLOW_SECRET_FLYINGDONKEYS] = 5e93a6f31e520738ce8bf4770f32929bec207696ad9ca54f6f5e67813c33ae40|g' /etc/php/8.3/fpm/pool.d/www.conf

# Atualizar WEBFLOW_SECRET_OCTADESK
sed -i 's|env\[WEBFLOW_SECRET_OCTADESK\] = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291|env[WEBFLOW_SECRET_OCTADESK] = 000b928364360d28af0db403c33aa5ec39d8ea9a8358add26a41f9ef951e6246|g' /etc/php/8.3/fpm/pool.d/www.conf
```

**Verificação:**
```bash
grep "WEBFLOW_SECRET" /etc/php/8.3/fpm/pool.d/www.conf
```

---

#### **2.4. Reiniciar PHP-FPM**

**Comando:**
```bash
systemctl restart php8.3-fpm
systemctl status php8.3-fpm
```

---

#### **2.5. Copiar Arquivos Atualizados para o Servidor**

**Arquivos:**
- `config.php`
- `dev_config.php` (se existir no servidor)

**Comando (do Windows):**
```powershell
# Copiar config.php
scp WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php root@65.108.156.14:/var/www/html/dev/root/config.php

# Copiar dev_config.php (se necessário)
scp dev_config.php root@65.108.156.14:/var/www/html/dev/root/dev_config.php
```

---

### **FASE 3: Testes e Validação**

#### **3.1. Verificar Variáveis de Ambiente no Servidor**

**Criar script de teste:**
```php
<?php
// test_secret_keys.php
require_once __DIR__ . '/config.php';

echo "WEBFLOW_SECRET_FLYINGDONKEYS: " . substr(getWebflowSecretFlyingDonkeys(), 0, 16) . '...' . PHP_EOL;
echo "WEBFLOW_SECRET_OCTADESK: " . substr(getWebflowSecretOctaDesk(), 0, 16) . '...' . PHP_EOL;
echo PHP_EOL;
echo "Esperado (primeiros 16 chars):" . PHP_EOL;
echo "FLYINGDONKEYS: 5e93a6f31e520738" . PHP_EOL;
echo "OCTADESK: 000b928364360d28" . PHP_EOL;
?>
```

**Executar:**
```bash
php /var/www/html/dev/root/test_secret_keys.php
```

---

#### **3.2. Testar Webhooks**

**Testar `add_flyingdonkeys.php`:**
```bash
curl -X POST https://dev.bssegurosimediato.com.br/add_flyingdonkeys.php \
  -H "Content-Type: application/json" \
  -H "X-Webflow-Signature: test" \
  -H "X-Webflow-Timestamp: $(date +%s)" \
  -d '{"test": "data"}'
```

**Testar `add_webflow_octa.php`:**
```bash
curl -X POST https://dev.bssegurosimediato.com.br/add_webflow_octa.php \
  -H "Content-Type: application/json" \
  -H "X-Webflow-Signature: test" \
  -H "X-Webflow-Timestamp: $(date +%s)" \
  -d '{"test": "data"}'
```

---

### **FASE 4: Preparação para PROD**

#### **4.1. Documentar Processo para PROD**

**Criar guia:** `GUIA_ATUALIZACAO_SECRET_KEYS_PROD.md`

**Conteúdo:**
- Passos para obter secret keys PROD do Webflow
- Processo de atualização no servidor PROD (157.180.36.223)
- Checklist de validação

---

#### **4.2. Atualizar Arquitetura**

**Arquivo:** `ARQUITETURA_COMPLETA_SISTEMA.md`

**Adicionar seção:**
- Localização das secret keys
- Processo de atualização
- Variáveis de ambiente relacionadas

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **FASE 1: Arquivos Locais**
- [ ] Atualizar `config.php` (fallback DEV)
- [ ] Atualizar `dev_config.php` (se existir)
- [ ] Criar backup dos arquivos antes de modificar
- [ ] Verificar que não há referências hardcoded antigas

### **FASE 2: Servidor DEV**
- [ ] Conectar ao servidor DEV (com autorização)
- [ ] Fazer backup do `www.conf`
- [ ] Atualizar variáveis PHP-FPM
- [ ] Reiniciar PHP-FPM
- [ ] Copiar arquivos atualizados para servidor
- [ ] Verificar permissões dos arquivos

### **FASE 3: Testes**
- [ ] Criar script de teste de secret keys
- [ ] Executar teste e verificar valores
- [ ] Testar webhook `add_flyingdonkeys.php`
- [ ] Testar webhook `add_webflow_octa.php`
- [ ] Verificar logs de erro

### **FASE 4: Documentação**
- [ ] Criar guia para PROD
- [ ] Atualizar arquitetura
- [ ] Documentar processo completo
- [ ] Registrar data de atualização

---

## 🔒 SEGURANÇA

### **Boas Práticas:**
1. ✅ **Nunca commitar secret keys no Git**
2. ✅ **Usar variáveis de ambiente como prioridade**
3. ✅ **Manter fallback hardcoded apenas para compatibilidade**
4. ✅ **Fazer backup antes de qualquer alteração**
5. ✅ **Testar em DEV antes de PROD**

### **Arquivos que NÃO devem conter secret keys:**
- ❌ `.gitignore` deve ignorar arquivos com secret keys
- ❌ Documentação não deve conter secret keys reais
- ❌ Logs não devem registrar secret keys completas

---

## 📊 MAPA DE ARQUIVOS

### **Arquivos a Modificar:**

| Arquivo | Localização | Tipo | Prioridade |
|---------|-------------|------|------------|
| `config.php` | `02-DEVELOPMENT/` | Código | 🔴 Alta |
| `dev_config.php` | Raiz | Config | 🟡 Média |
| `www.conf` | Servidor DEV | Config | 🔴 Alta |

### **Arquivos de Referência (NÃO modificar):**

| Arquivo | Descrição |
|---------|-----------|
| `add_flyingdonkeys.php` | Usa secret keys via `config.php` ou `dev_config.php` |
| `add_webflow_octa.php` | Usa secret keys via `config.php` |

---

## 🎯 RESULTADO ESPERADO

Após a implementação:

1. ✅ Secret keys atualizadas em `config.php` (fallback DEV)
2. ✅ Secret keys atualizadas em `dev_config.php` (se existir)
3. ✅ Variáveis PHP-FPM atualizadas no servidor DEV
4. ✅ PHP-FPM reiniciado e funcionando
5. ✅ Arquivos copiados para servidor DEV
6. ✅ Testes validando secret keys corretas
7. ✅ Webhooks funcionando com novas secret keys
8. ✅ Documentação atualizada para PROD

---

## 📝 NOTAS

- **Data de criação:** 11/11/2025
- **Ambiente:** DEV (preparação para PROD)
- **Secret keys:** Geradas no Webflow Dashboard
- **Validação:** Requer testes com webhooks reais do Webflow

---

**Status:** 📋 **AGUARDANDO AUTORIZAÇÃO PARA IMPLEMENTAÇÃO**

