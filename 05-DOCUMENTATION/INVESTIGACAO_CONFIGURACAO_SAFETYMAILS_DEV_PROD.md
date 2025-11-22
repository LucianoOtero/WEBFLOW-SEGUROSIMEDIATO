# 🔍 Investigação: Configuração SafetyMails DEV vs PROD

**Data:** 16/11/2025  
**Objetivo:** Investigar se existe configuração separada para DEV e PROD para as secret keys e API keys do SafetyMails

---

## 📊 RESUMO EXECUTIVO

### **Conclusão:**

❌ **NÃO existe configuração separada para DEV e PROD para as secret keys e API keys do SafetyMails.**

**Evidências:**
1. ✅ As credenciais estão **hardcoded** no JavaScript (`FooterCodeSiteDefinitivoCompleto.js`)
2. ✅ **Mesmas credenciais** são usadas em DEV e PROD
3. ✅ **Não há lógica condicional** baseada em `window.APP_ENVIRONMENT` ou outras variáveis
4. ✅ **Não há variáveis de ambiente** PHP-FPM para SafetyMails (apenas para outras APIs)
5. ✅ **Não há exposição via `config_env.js.php`** para SafetyMails

---

## 🔍 INVESTIGAÇÃO DETALHADA

### **1. Arquivos JavaScript (FooterCodeSiteDefinitivoCompleto.js)**

#### **1.1. Ambiente de Desenvolvimento (02-DEVELOPMENT)**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Linha 240-245:**
```javascript
// ⚠️ AMBIENTE: DESENVOLVIMENTO
window.USE_PHONE_API = true;
window.APILAYER_KEY = 'dce92fa84152098a3b5b7b8db24debbc';
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // DEV: Ticket origem atualizado
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
window.VALIDAR_PH3A = false;
```

**Análise:**
- ✅ Credenciais estão **hardcoded** (não vêm de variáveis de ambiente)
- ✅ **Não há lógica condicional** baseada em ambiente
- ✅ Comentário indica "DEV: Ticket origem atualizado"
- ✅ Comentário indica "Mesmo para DEV e PROD" na API key

#### **1.2. Ambiente de Produção (03-PRODUCTION)**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/FooterCodeSiteDefinitivoCompleto.js`

**Linha 240-245:**
```javascript
// ⚠️ AMBIENTE: DESENVOLVIMENTO
window.USE_PHONE_API = true;
window.APILAYER_KEY = 'dce92fa84152098a3b5b7b8db24debbc';
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // DEV: Ticket origem atualizado
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
window.VALIDAR_PH3A = false;
```

**Análise:**
- ✅ **IDÊNTICO ao ambiente de desenvolvimento**
- ✅ Mesmas credenciais hardcoded
- ⚠️ **PROBLEMA:** Comentário ainda diz "AMBIENTE: DESENVOLVIMENTO"
- ⚠️ **PROBLEMA:** Comentário ainda diz "DEV: Ticket origem atualizado"

---

### **2. Verificação de Lógica Condicional**

#### **2.1. Busca por `window.APP_ENVIRONMENT`**

**Resultado:** ❌ **NÃO encontrado** uso de `window.APP_ENVIRONMENT` para diferenciar credenciais SafetyMails

**Busca realizada:**
- `grep -i "APP_ENVIRONMENT.*SAFETY"` → Nenhum resultado
- `grep -i "SAFETY.*APP_ENVIRONMENT"` → Nenhum resultado
- `grep -i "window.APP_ENVIRONMENT"` → Encontrado apenas para outras funcionalidades (não SafetyMails)

#### **2.2. Busca por `isDevelopment()` ou `isProduction()`**

**Resultado:** ❌ **NÃO encontrado** uso de funções de detecção de ambiente para SafetyMails

**Busca realizada:**
- `grep -i "isDevelopment.*SAFETY"` → Nenhum resultado
- `grep -i "isProduction.*SAFETY"` → Nenhum resultado
- `grep -i "SAFETY.*isDevelopment"` → Nenhum resultado

#### **2.3. Busca por Configuração Condicional**

**Resultado:** ❌ **NÃO encontrado** nenhuma lógica condicional para SafetyMails

**Padrões verificados:**
- `if (window.APP_ENVIRONMENT === 'production')` → Não encontrado para SafetyMails
- `window.SAFETY_TICKET = window.APP_ENVIRONMENT === 'production' ? ... : ...` → Não encontrado
- `window.SAFETY_API_KEY = ...` → Sempre hardcoded, sem condicional

---

### **3. Verificação de Variáveis de Ambiente PHP-FPM**

#### **3.1. Arquivo PHP-FPM DEV**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`

**Busca por variáveis SafetyMails:**
```bash
grep -i "SAFETY" php-fpm_www_conf_DEV.conf
```

**Resultado:** ❌ **NÃO encontrado** variáveis de ambiente para SafetyMails

**Variáveis encontradas no arquivo:**
- `APP_BASE_DIR`
- `APP_BASE_URL`
- `PHP_ENV`
- `LOG_DIR`
- `APP_CORS_ORIGINS`
- `ESPOCRM_URL`
- `ESPOCRM_API_KEY`
- `LOG_DB_*`
- `WEBFLOW_SECRET_*`
- **NÃO há:** `SAFETY_TICKET`, `SAFETY_API_KEY`

#### **3.2. Arquivo PHP-FPM PROD**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`

**Busca por variáveis SafetyMails:**
```bash
grep -i "SAFETY" php-fpm_www_conf_PROD.conf
```

**Resultado:** ❌ **NÃO encontrado** variáveis de ambiente para SafetyMails

**Conclusão:** Não há variáveis de ambiente PHP-FPM para SafetyMails em nenhum ambiente.

---

### **4. Verificação de `config_env.js.php`**

#### **4.1. Arquivo DEV**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config_env.js.php`

**Conteúdo:**
```php
window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;
```

**Análise:**
- ✅ Expõe apenas `APP_BASE_URL` e `APP_ENVIRONMENT`
- ❌ **NÃO expõe** `SAFETY_TICKET` ou `SAFETY_API_KEY`

#### **4.2. Arquivo PROD**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/config_env.js.php`

**Conteúdo:**
```php
window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;
```

**Análise:**
- ✅ **IDÊNTICO ao arquivo DEV**
- ✅ Expõe apenas `APP_BASE_URL` e `APP_ENVIRONMENT`
- ❌ **NÃO expõe** `SAFETY_TICKET` ou `SAFETY_API_KEY`

---

### **5. Comparação com Outras APIs (Padrão de Configuração)**

#### **5.1. Configuração de Outras APIs (PHP)**

**Exemplo: `config.php` - EspoCRM API Key**

```php
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'  // DEV
        : '82d5f667f3a65a9a43341a0705be2b0c'); // PROD
}
```

**Análise:**
- ✅ **Há diferenciação** entre DEV e PROD
- ✅ Usa variáveis de ambiente com fallback
- ✅ Usa `isDevelopment()` para determinar ambiente

#### **5.2. Configuração SafetyMails (JavaScript)**

**Exemplo: `FooterCodeSiteDefinitivoCompleto.js` - SafetyMails**

```javascript
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // DEV: Ticket origem atualizado
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
```

**Análise:**
- ❌ **NÃO há diferenciação** entre DEV e PROD
- ❌ **Hardcoded** (não usa variáveis de ambiente)
- ❌ **Sem lógica condicional**

---

## ⚠️ PROBLEMAS IDENTIFICADOS

### **1. Falta de Diferenciação de Ambientes**

**Problema:**
- As credenciais SafetyMails estão hardcoded no JavaScript
- Não há lógica condicional baseada em ambiente
- Mesmas credenciais são usadas em DEV e PROD

**Impacto:**
- ⚠️ Dificulta gerenciamento de credenciais
- ⚠️ Pode causar problemas se ticket origem não suportar múltiplas origens
- ⚠️ Dificulta auditoria e rastreamento por ambiente

### **2. Falta de Variáveis de Ambiente**

**Problema:**
- Não há variáveis de ambiente PHP-FPM para SafetyMails
- Não há exposição via `config_env.js.php`
- Credenciais estão hardcoded no código

**Impacto:**
- ⚠️ Requer modificação manual do código para alterar credenciais
- ⚠️ Dificulta deploy automatizado
- ⚠️ Aumenta risco de exposição de credenciais no código

### **3. Comentários Incorretos**

**Problema:**
- Arquivo de produção tem comentários de desenvolvimento
- Comentário indica "DEV: Ticket origem atualizado" em produção

**Impacto:**
- ⚠️ Pode causar confusão durante manutenção
- ⚠️ Pode levar a decisões incorretas

---

## 📋 CONCLUSÃO

### **Resposta Direta:**

❌ **NÃO existe configuração separada para DEV e PROD para as secret keys e API keys do SafetyMails.**

### **Evidências:**

1. ✅ **Credenciais hardcoded:** Ambas as credenciais (`SAFETY_TICKET` e `SAFETY_API_KEY`) estão hardcoded no JavaScript
2. ✅ **Mesmas credenciais:** DEV e PROD usam exatamente as mesmas credenciais
3. ✅ **Sem lógica condicional:** Não há uso de `window.APP_ENVIRONMENT` ou outras variáveis para diferenciar
4. ✅ **Sem variáveis de ambiente:** Não há variáveis PHP-FPM para SafetyMails
5. ✅ **Sem exposição via config_env.js.php:** O arquivo `config_env.js.php` não expõe credenciais SafetyMails

### **Comparação com Outras APIs:**

| API | Diferenciação DEV/PROD | Variáveis de Ambiente | Lógica Condicional |
|-----|------------------------|----------------------|-------------------|
| **EspoCRM** | ✅ Sim | ✅ Sim | ✅ Sim (`isDevelopment()`) |
| **Webflow Secrets** | ✅ Sim | ✅ Sim | ✅ Sim (`isDevelopment()`) |
| **SafetyMails** | ❌ Não | ❌ Não | ❌ Não |

---

## 🔍 RECOMENDAÇÕES

### **1. Implementar Diferenciação de Ambientes (FUTURO)**

**Ação sugerida:**
- Adicionar variáveis de ambiente PHP-FPM para SafetyMails:
  - `SAFETY_TICKET_DEV`
  - `SAFETY_TICKET_PROD`
  - `SAFETY_API_KEY` (pode ser compartilhado se for o mesmo)
- Expor via `config_env.js.php` ou usar lógica condicional no JavaScript
- Atualizar `FooterCodeSiteDefinitivoCompleto.js` para usar variáveis de ambiente

### **2. Verificar se Ticket Atual Suporta Múltiplas Origens**

**Ação imediata:**
- Verificar no painel SafetyMails se o ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` suporta múltiplas origens
- Se sim → Pode continuar usando o mesmo ticket
- Se não → Criar novo ticket para produção

### **3. Corrigir Comentários**

**Ação imediata:**
- Atualizar comentários em `03-PRODUCTION/FooterCodeSiteDefinitivoCompleto.js`
- Remover referências a "DESENVOLVIMENTO"
- Adicionar comentários claros indicando ambiente de produção

---

**Data de Investigação:** 16/11/2025  
**Investigação Realizada por:** Sistema Automatizado  
**Status:** ✅ **INVESTIGAÇÃO COMPLETA**

