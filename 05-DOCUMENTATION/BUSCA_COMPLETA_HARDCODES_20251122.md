# 🔍 BUSCA COMPLETA: Variáveis Hardcoded em Arquivos PHP e JavaScript

**Data:** 22/11/2025  
**Tipo de Análise:** ⚠️ **APENAS BUSCA E DOCUMENTAÇÃO** - Nenhuma alteração realizada  
**Escopo:** Todos os arquivos `.php` e `.js` em `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`

---

## 🎯 OBJETIVO

Realizar busca minuciosa e completa em todos os arquivos `.php` e `.js` para identificar variáveis hardcoded que deveriam estar em variáveis de ambiente ou data attributes.

---

## 📋 METODOLOGIA

### **Padrões Buscados:**

1. **Credenciais e Tokens:**
   - Strings com 32+ caracteres alfanuméricos (possíveis API keys, tokens, secrets)
   - Padrões de hash (SHA256, MD5)

2. **URLs Hardcoded:**
   - URLs completas de APIs (`https://api.`, `http://`)
   - URLs de endpoints internos

3. **Números de Telefone:**
   - Padrões `+55` seguidos de números
   - Números de telefone completos

4. **Emails Hardcoded:**
   - Emails completos (`@imediatoseguros.com.br`, etc.)

5. **Valores de Configuração:**
   - Domínios hardcoded
   - Valores de configuração que variam por ambiente

---

## 🔍 RESULTADOS DA BUSCA

### **ARQUIVOS PHP**

#### **1. `add_webflow_octa.php`**

**Linha 56:**
```php
$OCTADESK_FROM = '+551132301422'; // TODO: Mover para variável de ambiente se necessário
```

**Tipo:** Número de telefone hardcoded  
**Categoria:** 🔴 **CRÍTICO**  
**Status:** ❌ **HARDCODED**  
**Variável de Ambiente:** Não existe (`OCTADESK_FROM` não configurada no PHP-FPM)

---

#### **2. `add_flyingdonkeys.php`**

**Linha 384:**
```php
'pageUrl' => 'https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io/',
```

**Tipo:** URL hardcoded  
**Categoria:** 🟡 **MÉDIO**  
**Status:** ❌ **HARDCODED**  
**Observação:** URL do Webflow hardcoded

**Linha 396:**
```php
'Email' => $data[1] ?? 'email@nao.informado.com'
```

**Tipo:** Email fallback hardcoded  
**Categoria:** 🟢 **BAIXO**  
**Status:** ⚠️ **FALLBACK** (não crítico, mas deveria ser variável)

**Linha 703:**
```php
$webpage = 'mdmidia.com.br'; // Ambiente de produção
```

**Tipo:** Domínio hardcoded  
**Categoria:** 🟡 **MÉDIO**  
**Status:** ❌ **HARDCODED**  
**Observação:** Comentário indica que é para produção, mas está hardcoded

---

#### **3. `cpf-validate.php`**

**Linha 99:**
```php
$data_url = "https://api.ph3a.com.br/DataBusca/data";
```

**Tipo:** URL de API hardcoded  
**Categoria:** 🟡 **MÉDIO**  
**Status:** ❌ **HARDCODED**  
**Observação:** URL da API PH3A hardcoded (deveria usar função helper)

---

#### **4. `placa-validate.php`**

✅ **SEM HARDCODES ENCONTRADOS**  
**Status:** ✅ Usa funções helper corretamente (`getPlacaFipeApiToken()`, `getPlacaFipeApiUrl()`)

---

#### **5. `aws_ses_config.php`**

✅ **SEM HARDCODES ENCONTRADOS**  
**Status:** ✅ Usa funções helper corretamente (`getAwsAccessKeyId()`, `getAwsSecretAccessKey()`, etc.)

---

#### **6. `config.php`**

✅ **SEM HARDCODES ENCONTRADOS**  
**Status:** ✅ Arquivo de configuração usa apenas variáveis de ambiente

---

### **ARQUIVOS JAVASCRIPT**

#### **1. `FooterCodeSiteDefinitivoCompleto.js`**

✅ **SEM HARDCODES CRÍTICOS ENCONTRADOS**  
**Status:** ✅ Usa data attributes corretamente

**Observações:**
- Linha 185: Usa `getRequiredDataAttribute()` para ler variáveis
- Todas as variáveis são lidas de data attributes do script tag

---

#### **2. `MODAL_WHATSAPP_DEFINITIVO.js`**

**Linha 68-69:**
```javascript
whatsapp: {
  phone: '551132301422',
  message: 'Olá! Quero uma cotação de seguro.'
}
```

**Tipo:** Número de telefone e mensagem hardcoded  
**Categoria:** 🔴 **CRÍTICO**  
**Status:** ❌ **HARDCODED**  
**Observação:** Número de WhatsApp e mensagem padrão hardcoded

**Linha 560:**
```javascript
email = ddd + onlyDigits(celular) + '@imediatoseguros.com.br';
```

**Tipo:** Domínio de email hardcoded  
**Categoria:** 🟡 **MÉDIO**  
**Status:** ❌ **HARDCODED**  
**Observação:** Domínio `@imediatoseguros.com.br` hardcoded

**Linha 879:**
```javascript
'Email': ddd && celular ? `${ddd}${onlyDigits(celular)}@imediatoseguros.com.br` : '',
```

**Tipo:** Domínio de email hardcoded  
**Categoria:** 🟡 **MÉDIO**  
**Status:** ❌ **HARDCODED**  
**Observação:** Mesmo padrão da linha 560

**Linha 1714:**
```javascript
placeholder="seu@email.com"
```

**Tipo:** Placeholder de email  
**Categoria:** 🟢 **BAIXO**  
**Status:** ⚠️ **PLACEHOLDER** (não crítico, mas poderia ser variável)

---

#### **3. `webflow_injection_limpo.js`**

**Linha 45:**
```javascript
const SAFETYMAILS_OPTIN_PATH = window.SAFETYMAILS_OPTIN_PATH || '/main/safetyoptin/20a7a1c297e39180bd80428ac13c363e882a531f/9bab7f0c2711c5accfb83588c859dc1103844a94/';
```

**Tipo:** Path com credenciais hardcoded  
**Categoria:** 🔴 **CRÍTICO**  
**Status:** ❌ **HARDCODED** (com fallback)  
**Observação:** Path contém API key e ticket do SafetyMails hardcoded como fallback

**Linha 2455:**
```javascript
email: "cliente@exemplo.com",
```

**Tipo:** Email de exemplo  
**Categoria:** 🟢 **BAIXO**  
**Status:** ⚠️ **EXEMPLO** (não crítico, mas poderia ser variável)

**Linhas 3351, 3554:**
```javascript
fontAwesome.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css';
```

**Tipo:** URL de CDN hardcoded  
**Categoria:** 🟢 **BAIXO**  
**Status:** ⚠️ **CDN** (não crítico, mas poderia ser variável)

**Linhas 3565, 3571:**
```javascript
sweetAlertScript.src = 'https://cdn.jsdelivr.net/npm/sweetalert2@11.14.0/dist/sweetalert2.all.min.js';
sweetAlertCSS.href = 'https://cdn.jsdelivr.net/npm/sweetalert2@11.14.0/dist/sweetalert2.min.css';
```

**Tipo:** URLs de CDN hardcoded  
**Categoria:** 🟢 **BAIXO**  
**Status:** ⚠️ **CDN** (não crítico, mas poderia ser variável)

---

## 📊 RESUMO EXECUTIVO

### **Estatísticas Gerais:**

| Categoria | Quantidade | Status |
|-----------|------------|--------|
| 🔴 **CRÍTICO** | 3 | Requer correção imediata |
| 🟡 **MÉDIO** | 5 | Requer correção |
| 🟢 **BAIXO** | 4 | Pode ser corrigido posteriormente |
| **TOTAL** | **12** | |

---

### **Hardcodes por Arquivo:**

| Arquivo | Quantidade | Crítico | Médio | Baixo |
|---------|------------|---------|-------|-------|
| `add_webflow_octa.php` | 1 | 1 | 0 | 0 |
| `add_flyingdonkeys.php` | 3 | 0 | 2 | 1 |
| `cpf-validate.php` | 1 | 0 | 1 | 0 |
| `MODAL_WHATSAPP_DEFINITIVO.js` | 4 | 1 | 2 | 1 |
| `webflow_injection_limpo.js` | 3 | 1 | 0 | 2 |
| **TOTAL** | **12** | **3** | **5** | **4** |

---

## 🔴 HARDCODES CRÍTICOS (Correção Imediata)

### **1. `add_webflow_octa.php` - Linha 56**

```php
$OCTADESK_FROM = '+551132301422'; // TODO: Mover para variável de ambiente se necessário
```

**Ação Necessária:**
1. Adicionar `env[OCTADESK_FROM] = +551132301422` ao PHP-FPM config
2. Criar função `getOctaDeskFrom()` em `config.php`
3. Substituir hardcode por `$OCTADESK_FROM = getOctaDeskFrom();`

---

### **2. `MODAL_WHATSAPP_DEFINITIVO.js` - Linha 68-69**

```javascript
whatsapp: {
  phone: '551132301422',
  message: 'Olá! Quero uma cotação de seguro.'
}
```

**Ação Necessária:**
1. Adicionar `data-whatsapp-phone` e `data-whatsapp-default-message` ao script tag do Webflow
2. Ler valores de data attributes em vez de hardcode

---

### **3. `webflow_injection_limpo.js` - Linha 45**

```javascript
const SAFETYMAILS_OPTIN_PATH = window.SAFETYMAILS_OPTIN_PATH || '/main/safetyoptin/20a7a1c297e39180bd80428ac13c363e882a531f/9bab7f0c2711c5accfb83588c859dc1103844a94/';
```

**Ação Necessária:**
1. Remover fallback com credenciais hardcoded
2. Lançar erro se `SAFETYMAILS_OPTIN_PATH` não estiver definido
3. Construir path dinamicamente usando variáveis de ambiente

---

## 🟡 HARDCODES MÉDIOS (Correção Recomendada)

### **1. `add_flyingdonkeys.php` - Linha 384**

```php
'pageUrl' => 'https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io/',
```

**Ação Necessária:**
- Usar variável de ambiente ou função helper para URL do Webflow

---

### **2. `add_flyingdonkeys.php` - Linha 703**

```php
$webpage = 'mdmidia.com.br'; // Ambiente de produção
```

**Ação Necessária:**
- Criar variável de ambiente `WEBPAGE_DOMAIN` ou função helper

---

### **3. `cpf-validate.php` - Linha 99**

```php
$data_url = "https://api.ph3a.com.br/DataBusca/data";
```

**Ação Necessária:**
- Criar função `getPh3aDataUrl()` em `config.php` ou usar variável de ambiente

---

### **4. `MODAL_WHATSAPP_DEFINITIVO.js` - Linhas 560, 879**

```javascript
email = ddd + onlyDigits(celular) + '@imediatoseguros.com.br';
'Email': ddd && celular ? `${ddd}${onlyDigits(celular)}@imediatoseguros.com.br` : '',
```

**Ação Necessária:**
- Criar variável `EMAIL_DOMAIN` ou data attribute `data-email-domain`

---

## 🟢 HARDCODES BAIXOS (Correção Opcional)

### **1. `add_flyingdonkeys.php` - Linha 396**

```php
'Email' => $data[1] ?? 'email@nao.informado.com'
```

**Observação:** Fallback não crítico, mas poderia ser variável

---

### **2. `MODAL_WHATSAPP_DEFINITIVO.js` - Linha 1714**

```javascript
placeholder="seu@email.com"
```

**Observação:** Placeholder não crítico

---

### **3. `webflow_injection_limpo.js` - Linhas 3351, 3554, 3565, 3571**

**Observação:** URLs de CDN não críticas, mas poderiam ser variáveis

---

## 📋 CHECKLIST DE CORREÇÃO

### **Prioridade CRÍTICA:**

- [ ] **`add_webflow_octa.php`:** Adicionar `OCTADESK_FROM` ao PHP-FPM e criar função helper
- [ ] **`MODAL_WHATSAPP_DEFINITIVO.js`:** Mover número WhatsApp e mensagem para data attributes
- [ ] **`webflow_injection_limpo.js`:** Remover fallback com credenciais do SafetyMails

### **Prioridade MÉDIA:**

- [ ] **`add_flyingdonkeys.php`:** Mover URL Webflow e domínio para variáveis de ambiente
- [ ] **`cpf-validate.php`:** Criar função helper para URL da API PH3A
- [ ] **`MODAL_WHATSAPP_DEFINITIVO.js`:** Mover domínio de email para variável

### **Prioridade BAIXA:**

- [ ] **`add_flyingdonkeys.php`:** Mover fallback de email para variável
- [ ] **`MODAL_WHATSAPP_DEFINITIVO.js`:** Mover placeholder para variável
- [ ] **`webflow_injection_limpo.js`:** Mover URLs de CDN para variáveis (opcional)

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- **Análise Situação Hardcode:** `ANALISE_SITUACAO_HARDCODE_POS_PROJETO.md`
- **Projeto Eliminação Hardcode:** `PROJETO_ELIMINAR_VARIAVEIS_HARDCODE_20251118.md`
- **Verificação OctaDesk:** `VERIFICACAO_VARIAVEIS_OCTADESK_PRODUCAO.md`

---

**Última Atualização:** 22/11/2025  
**Status:** ✅ **BUSCA CONCLUÍDA** - Nenhuma alteração realizada (conforme solicitado)

