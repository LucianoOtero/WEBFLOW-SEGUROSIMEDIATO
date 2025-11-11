# 🔐 CREDENCIAIS CORRIGIDAS - ANÁLISE ATUALIZADA

**Data:** 08/11/2025  
**Status:** ✅ **CORRIGIDO COM BASE NAS INFORMAÇÕES**

---

## ✅ CORREÇÕES APLICADAS

### **1. TravelAngels não é mais utilizado**
- ❌ **Remover** todas as credenciais relacionadas a TravelAngels
- ✅ **Não adicionar** ao Docker

### **2. APILAYER_KEY é a mesma para dev e prod**
- ✅ **Uma única variável:** `APILAYER_KEY` (sem sufixo _DEV ou _PROD)
- ✅ Valor: `dce92fa84152098a3b5b7b8db24debbc`

### **3. SAFETY_TICKET é a mesma para dev e prod**
- ✅ **Uma única variável:** `SAFETY_TICKET` (sem sufixo _DEV ou _PROD)
- ✅ Valor: `fc5e18c10c4aa883b2c31a305f1c09fea3834138`

### **4. SAFETY_API_KEY é a mesma para dev e prod**
- ✅ **Uma única variável:** `SAFETY_API_KEY` (sem sufixo _DEV ou _PROD)
- ✅ Valor: `20a7a1c297e39180bd80428ac13c363e882a531f`

### **5. OctaDesk pode usar a mesma para dev e prod**
- ✅ **Dev é simulador** - pode usar credenciais de produção
- ✅ **Uma única variável** para cada credencial (sem sufixo _DEV ou _PROD)

### **6. FlyingDonkeys DEV:**
- ✅ **URL DEV:** `dev.flyingdonkeys.com.br`
- ✅ **API_KEY DEV:** `73b5b7983bfc641cdba72d204a48ed9d` ✅ **ENCONTRADA**

---

## 📋 CREDENCIAIS CORRIGIDAS PARA ADICIONAR AO DOCKER

### **php-dev (Desenvolvimento):**

```yaml
environment:
  - PHP_ENV=development
  - APP_BASE_DIR=/var/www/html/dev/root
  - APP_BASE_URL=https://dev.bssegurosimediato.com.br
  - APP_CORS_ORIGINS=...
  
  # JavaScript Credentials (compartilhadas dev/prod)
  - APILAYER_KEY=dce92fa84152098a3b5b7b8db24debbc
  - SAFETY_TICKET=fc5e18c10c4aa883b2c31a305f1c09fea3834138
  - SAFETY_API_KEY=20a7a1c297e39180bd80428ac13c363e882a531f
  
  # PHP - FlyingDonkeys (EspoCRM DEV)
  - FLYINGDONKEYS_API_URL_DEV=https://dev.flyingdonkeys.com.br
  - FLYINGDONKEYS_API_KEY_DEV=73b5b7983bfc641cdba72d204a48ed9d
  
  # PHP - OctaDesk (compartilhado dev/prod, dev é simulador)
  - OCTADESK_API_KEY=b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
  - OCTADESK_FROM=+551132301422
  - WEBFLOW_SECRET_OCTADESK=4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f
  - OCTADESK_API_BASE=https://o205242-d60.api004.octadesk.services
```

---

### **php-prod (Produção):**

```yaml
environment:
  - PHP_ENV=production
  - APP_BASE_DIR=/var/www/html/prod/root
  - APP_BASE_URL=https://bssegurosimediato.com.br
  - APP_CORS_ORIGINS=...
  
  # JavaScript Credentials (compartilhadas dev/prod)
  - APILAYER_KEY=dce92fa84152098a3b5b7b8db24debbc
  - SAFETY_TICKET=fc5e18c10c4aa883b2c31a305f1c09fea3834138
  - SAFETY_API_KEY=20a7a1c297e39180bd80428ac13c363e882a531f
  
  # PHP - FlyingDonkeys (EspoCRM PROD)
  - FLYINGDONKEYS_API_URL_PROD=https://flyingdonkeys.com.br
  - FLYINGDONKEYS_API_KEY_PROD=82d5f667f3a65a9a43341a0705be2b0c
  
  # PHP - OctaDesk (compartilhado dev/prod)
  - OCTADESK_API_KEY=b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
  - OCTADESK_FROM=+551132301422
  - WEBFLOW_SECRET_OCTADESK=4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f
  - OCTADESK_API_BASE=https://o205242-d60.api004.octadesk.services
```

---

## ❌ CREDENCIAIS REMOVIDAS (não são mais utilizadas)

- ❌ `WEBFLOW_SECRET_TRAVELANGELS_DEV` - TravelAngels não é mais utilizado
- ❌ `WEBFLOW_SECRET_TRAVELANGELS_PROD` - TravelAngels não é mais utilizado
- ❌ `ESPOCRM_URL_DEV` - Não é EspoCRM direto, é FlyingDonkeys
- ❌ `ESPOCRM_API_KEY_DEV` - Não é EspoCRM direto, é FlyingDonkeys
- ❌ `ESPOCRM_URL_PROD` - Não é EspoCRM direto, é FlyingDonkeys
- ❌ `ESPOCRM_API_KEY_PROD` - Não é EspoCRM direto, é FlyingDonkeys

---

## ✅ CREDENCIAIS SIMPLIFICADAS

### **JavaScript (3 credenciais - compartilhadas):**
- ✅ `APILAYER_KEY` - Mesma para dev/prod
- ✅ `SAFETY_TICKET` - Mesma para dev/prod
- ✅ `SAFETY_API_KEY` - Mesma para dev/prod

### **PHP - FlyingDonkeys (2 credenciais - separadas):**
- ✅ `FLYINGDONKEYS_API_URL_DEV` - `https://dev.flyingdonkeys.com.br`
- ✅ `FLYINGDONKEYS_API_KEY_DEV` - `73b5b7983bfc641cdba72d204a48ed9d` ✅ **ENCONTRADA**
- ✅ `FLYINGDONKEYS_API_URL_PROD` - `https://flyingdonkeys.com.br`
- ✅ `FLYINGDONKEYS_API_KEY_PROD` - `82d5f667f3a65a9a43341a0705be2b0c`

### **PHP - OctaDesk (4 credenciais - compartilhadas):**
- ✅ `OCTADESK_API_KEY` - Mesma para dev/prod
- ✅ `OCTADESK_FROM` - Mesma para dev/prod
- ✅ `WEBFLOW_SECRET_OCTADESK` - Mesma para dev/prod
- ✅ `OCTADESK_API_BASE` - Mesma para dev/prod

---

## ✅ TODAS AS CREDENCIAIS ENCONTRADAS

**Status:** Todas as credenciais necessárias foram identificadas e documentadas.

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.1 - ✅ FLYINGDONKEYS_API_KEY_DEV encontrada: `73b5b7983bfc641cdba72d204a48ed9d`

