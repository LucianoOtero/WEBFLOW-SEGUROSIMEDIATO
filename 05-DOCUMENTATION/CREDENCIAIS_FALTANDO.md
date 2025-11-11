# 🔐 CREDENCIAIS FALTANDO - ANÁLISE COMPLETA

**Data:** 08/11/2025  
**Status:** ✅ **INVENTÁRIO COMPLETO**

---

## 🎯 OBJETIVO

Identificar todas as credenciais usadas no sistema e quais estão faltando nas variáveis de ambiente do Docker.

---

## 📋 CREDENCIAIS IDENTIFICADAS NO CÓDIGO

### **1. JavaScript (FooterCodeSiteDefinitivoCompleto.js):**

| Credencial | Valor Atual (DEV) | Valor PROD | Status |
|------------|-------------------|------------|--------|
| `APILAYER_KEY` | `dce92fa84152098a3b5b7b8db24debbc` | ❌ **FALTANDO** | Hardcoded |
| `SAFETY_TICKET` | `fc5e18c10c4aa883b2c31a305f1c09fea3834138` | ❌ **FALTANDO** | Hardcoded |
| `SAFETY_API_KEY` | `20a7a1c297e39180bd80428ac13c363e882a531f` | ✅ Mesmo (compartilhado) | Hardcoded |

---

### **2. PHP (add_travelangels.php - DEV):**

| Credencial | Valor Atual | Fonte | Status |
|------------|-------------|-------|--------|
| `WEBFLOW_SECRET_TRAVELANGELS` | `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` | `dev_config.php` | ⚠️ Em arquivo separado |
| `ESPOCRM_URL` | ❓ | `$DEV_ESPOCRM_CREDENTIALS['url']` | ⚠️ Em `dev_config.php` |
| `ESPOCRM_API_KEY` | ❓ | `$DEV_ESPOCRM_CREDENTIALS['api_key']` | ⚠️ Em `dev_config.php` |

---

### **3. PHP (add_flyingdonkeys.php - PROD):**

| Credencial | Valor Atual | Fonte | Status |
|------------|-------------|-------|--------|
| `WEBFLOW_SECRET_TRAVELANGELS` | `ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990` | Hardcoded | ❌ Hardcoded |
| `FLYINGDONKEYS_API_URL` | `https://flyingdonkeys.com.br` | Hardcoded | ❌ Hardcoded |
| `FLYINGDONKEYS_API_KEY` | `82d5f667f3a65a9a43341a0705be2b0c` | Hardcoded | ❌ Hardcoded |

---

### **4. PHP (add_webflow_octa.php - PROD):**

| Credencial | Valor Atual | Fonte | Status |
|------------|-------------|-------|--------|
| `OCTADESK_API_KEY` | `b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b` | Hardcoded | ❌ Hardcoded |
| `OCTADESK_FROM` | `+551132301422` | Hardcoded | ❌ Hardcoded |
| `WEBFLOW_SECRET_OCTADESK` | `4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f` | Hardcoded | ❌ Hardcoded |
| `OCTADESK_API_BASE` | `https://o205242-d60.api004.octadesk.services` | Hardcoded | ❌ Hardcoded |

---

## ❌ CREDENCIAIS FALTANDO NO DOCKER

### **Variáveis de Ambiente que DEVEM ser adicionadas:**

#### **Para JavaScript (via config_env.js.php):**

**DEV:**
- ❌ `APILAYER_KEY_DEV` - Chave da API Layer (validação de telefone)
- ❌ `SAFETY_TICKET_DEV` - Ticket do SafetyMails (validação de email)
- ✅ `SAFETY_API_KEY` - API Key do SafetyMails (compartilhado dev/prod)

**PROD:**
- ❌ `APILAYER_KEY_PROD` - Chave da API Layer (validação de telefone) - **FALTANDO VALOR**
- ❌ `SAFETY_TICKET_PROD` - Ticket do SafetyMails (validação de email) - **FALTANDO VALOR**
- ✅ `SAFETY_API_KEY` - API Key do SafetyMails (compartilhado dev/prod)

---

#### **Para PHP (add_travelangels.php - DEV):**

**DEV:**
- ❌ `WEBFLOW_SECRET_TRAVELANGELS_DEV` - Secret do Webflow para TravelAngels
- ❌ `ESPOCRM_URL_DEV` - URL do EspoCRM de desenvolvimento
- ❌ `ESPOCRM_API_KEY_DEV` - API Key do EspoCRM de desenvolvimento

**PROD:**
- ❌ `WEBFLOW_SECRET_TRAVELANGELS_PROD` - Secret do Webflow para TravelAngels (produção)
- ❌ `ESPOCRM_URL_PROD` - URL do EspoCRM de produção
- ❌ `ESPOCRM_API_KEY_PROD` - API Key do EspoCRM de produção

---

#### **Para PHP (add_flyingdonkeys.php - PROD):**

**PROD:**
- ❌ `WEBFLOW_SECRET_TRAVELANGELS_PROD` - Secret do Webflow (já listado acima)
- ❌ `FLYINGDONKEYS_API_URL` - URL da API FlyingDonkeys
- ❌ `FLYINGDONKEYS_API_KEY_PROD` - API Key do FlyingDonkeys

**DEV:**
- ❌ `FLYINGDONKEYS_API_URL_DEV` - URL da API FlyingDonkeys (dev, se existir)
- ❌ `FLYINGDONKEYS_API_KEY_DEV` - API Key do FlyingDonkeys (dev, se existir)

---

#### **Para PHP (add_webflow_octa.php - PROD):**

**PROD:**
- ❌ `OCTADESK_API_KEY_PROD` - API Key do OctaDesk
- ❌ `OCTADESK_FROM_PROD` - Número de origem do OctaDesk
- ❌ `WEBFLOW_SECRET_OCTADESK_PROD` - Secret do Webflow para OctaDesk
- ❌ `OCTADESK_API_BASE_PROD` - URL base da API OctaDesk

**DEV:**
- ❌ `OCTADESK_API_KEY_DEV` - API Key do OctaDesk (dev, se existir)
- ❌ `OCTADESK_FROM_DEV` - Número de origem do OctaDesk (dev, se existir)
- ❌ `WEBFLOW_SECRET_OCTADESK_DEV` - Secret do Webflow para OctaDesk (dev)
- ❌ `OCTADESK_API_BASE_DEV` - URL base da API OctaDesk (dev, se existir)

---

## 📊 RESUMO - CREDENCIAIS FALTANDO

### **JavaScript (3 credenciais):**

| Credencial | DEV | PROD | Status |
|------------|-----|------|--------|
| `APILAYER_KEY` | ✅ Tem valor | ❌ **FALTANDO VALOR** | Precisa adicionar ao Docker |
| `SAFETY_TICKET` | ✅ Tem valor | ❌ **FALTANDO VALOR** | Precisa adicionar ao Docker |
| `SAFETY_API_KEY` | ✅ Tem valor | ✅ Mesmo valor | Precisa adicionar ao Docker |

---

### **PHP - TravelAngels (3 credenciais):**

| Credencial | DEV | PROD | Status |
|------------|-----|------|--------|
| `WEBFLOW_SECRET_TRAVELANGELS` | ✅ Tem valor | ✅ Tem valor | Precisa adicionar ao Docker |
| `ESPOCRM_URL` | ❓ Em dev_config.php | ❌ **FALTANDO** | Precisa adicionar ao Docker |
| `ESPOCRM_API_KEY` | ❓ Em dev_config.php | ❌ **FALTANDO** | Precisa adicionar ao Docker |

---

### **PHP - FlyingDonkeys (2 credenciais):**

| Credencial | DEV | PROD | Status |
|------------|-----|------|--------|
| `FLYINGDONKEYS_API_URL` | ❌ **FALTANDO** | ✅ Tem valor | Precisa adicionar ao Docker |
| `FLYINGDONKEYS_API_KEY` | ❌ **FALTANDO** | ✅ Tem valor | Precisa adicionar ao Docker |

---

### **PHP - OctaDesk (4 credenciais):**

| Credencial | DEV | PROD | Status |
|------------|-----|------|--------|
| `OCTADESK_API_KEY` | ❌ **FALTANDO** | ✅ Tem valor | Precisa adicionar ao Docker |
| `OCTADESK_FROM` | ❌ **FALTANDO** | ✅ Tem valor | Precisa adicionar ao Docker |
| `WEBFLOW_SECRET_OCTADESK` | ❌ **FALTANDO** | ✅ Tem valor | Precisa adicionar ao Docker |
| `OCTADESK_API_BASE` | ❌ **FALTANDO** | ✅ Tem valor | Precisa adicionar ao Docker |

---

## 📋 LISTA COMPLETA DE CREDENCIAIS PARA ADICIONAR AO DOCKER

### **php-dev (Desenvolvimento):**

```yaml
environment:
  - PHP_ENV=development
  - APP_BASE_DIR=/var/www/html/dev/root
  - APP_BASE_URL=https://dev.bssegurosimediato.com.br
  - APP_CORS_ORIGINS=...
  
  # JavaScript Credentials
  - APILAYER_KEY_DEV=dce92fa84152098a3b5b7b8db24debbc
  - SAFETY_TICKET_DEV=fc5e18c10c4aa883b2c31a305f1c09fea3834138
  - SAFETY_API_KEY=20a7a1c297e39180bd80428ac13c363e882a531f
  
  # PHP - TravelAngels
  - WEBFLOW_SECRET_TRAVELANGELS_DEV=888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
  - ESPOCRM_URL_DEV=??? # ❌ FALTANDO - Precisa obter valor
  - ESPOCRM_API_KEY_DEV=??? # ❌ FALTANDO - Precisa obter valor
  
  # PHP - FlyingDonkeys (se existir em dev)
  - FLYINGDONKEYS_API_URL_DEV=??? # ❌ FALTANDO - Precisa verificar se existe
  - FLYINGDONKEYS_API_KEY_DEV=??? # ❌ FALTANDO - Precisa verificar se existe
  
  # PHP - OctaDesk (se existir em dev)
  - OCTADESK_API_KEY_DEV=??? # ❌ FALTANDO - Precisa verificar se existe
  - OCTADESK_FROM_DEV=??? # ❌ FALTANDO - Precisa verificar se existe
  - WEBFLOW_SECRET_OCTADESK_DEV=??? # ❌ FALTANDO - Precisa verificar se existe
  - OCTADESK_API_BASE_DEV=??? # ❌ FALTANDO - Precisa verificar se existe
```

---

### **php-prod (Produção):**

```yaml
environment:
  - PHP_ENV=production
  - APP_BASE_DIR=/var/www/html/prod/root
  - APP_BASE_URL=https://bssegurosimediato.com.br
  - APP_CORS_ORIGINS=...
  
  # JavaScript Credentials
  - APILAYER_KEY_PROD=??? # ❌ FALTANDO - Precisa obter valor de produção
  - SAFETY_TICKET_PROD=??? # ❌ FALTANDO - Precisa obter valor de produção
  - SAFETY_API_KEY=20a7a1c297e39180bd80428ac13c363e882a531f
  
  # PHP - TravelAngels
  - WEBFLOW_SECRET_TRAVELANGELS_PROD=ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990
  - ESPOCRM_URL_PROD=??? # ❌ FALTANDO - Precisa obter valor
  - ESPOCRM_API_KEY_PROD=??? # ❌ FALTANDO - Precisa obter valor
  
  # PHP - FlyingDonkeys
  - FLYINGDONKEYS_API_URL_PROD=https://flyingdonkeys.com.br
  - FLYINGDONKEYS_API_KEY_PROD=82d5f667f3a65a9a43341a0705be2b0c
  
  # PHP - OctaDesk
  - OCTADESK_API_KEY_PROD=b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
  - OCTADESK_FROM_PROD=+551132301422
  - WEBFLOW_SECRET_OCTADESK_PROD=4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f
  - OCTADESK_API_BASE_PROD=https://o205242-d60.api004.octadesk.services
```

---

## ❌ CREDENCIAIS QUE PRECISAM SER OBTIDAS

### **Valores que não estão no código e precisam ser obtidos:**

1. **APILAYER_KEY_PROD** - Chave de produção da API Layer
2. **SAFETY_TICKET_PROD** - Ticket de produção do SafetyMails
3. **ESPOCRM_URL_DEV** - URL do EspoCRM de desenvolvimento
4. **ESPOCRM_API_KEY_DEV** - API Key do EspoCRM de desenvolvimento
5. **ESPOCRM_URL_PROD** - URL do EspoCRM de produção
6. **ESPOCRM_API_KEY_PROD** - API Key do EspoCRM de produção
7. **FLYINGDONKEYS_API_URL_DEV** - URL de dev do FlyingDonkeys (se existir)
8. **FLYINGDONKEYS_API_KEY_DEV** - API Key de dev do FlyingDonkeys (se existir)
9. **OCTADESK_*_DEV** - Todas as credenciais de dev do OctaDesk (se existir)

---

## 📋 CHECKLIST DE CREDENCIAIS

### **Valores que JÁ TEMOS (podem ser adicionados ao Docker):**

- ✅ `APILAYER_KEY_DEV`
- ✅ `SAFETY_TICKET_DEV`
- ✅ `SAFETY_API_KEY` (compartilhado)
- ✅ `WEBFLOW_SECRET_TRAVELANGELS_DEV`
- ✅ `WEBFLOW_SECRET_TRAVELANGELS_PROD`
- ✅ `FLYINGDONKEYS_API_URL_PROD`
- ✅ `FLYINGDONKEYS_API_KEY_PROD`
- ✅ `OCTADESK_API_KEY_PROD`
- ✅ `OCTADESK_FROM_PROD`
- ✅ `WEBFLOW_SECRET_OCTADESK_PROD`
- ✅ `OCTADESK_API_BASE_PROD`

### **Valores que FALTAM (precisam ser obtidos):**

- ❌ `APILAYER_KEY_PROD`
- ❌ `SAFETY_TICKET_PROD`
- ❌ `ESPOCRM_URL_DEV`
- ❌ `ESPOCRM_API_KEY_DEV`
- ❌ `ESPOCRM_URL_PROD`
- ❌ `ESPOCRM_API_KEY_PROD`
- ❌ `FLYINGDONKEYS_API_URL_DEV` (se existir)
- ❌ `FLYINGDONKEYS_API_KEY_DEV` (se existir)
- ❌ `OCTADESK_*_DEV` (se existir)

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

