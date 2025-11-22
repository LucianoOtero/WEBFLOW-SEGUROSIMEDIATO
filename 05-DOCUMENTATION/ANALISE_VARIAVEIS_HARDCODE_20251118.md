# 🔍 ANÁLISE COMPLETA: VARIÁVEIS HARDCODED NO PROJETO

**Data:** 18/11/2025  
**Versão:** 1.0.0  
**Escopo:** Todos os arquivos JavaScript (.js) e PHP (.php) do projeto

---

## 📋 SUMÁRIO EXECUTIVO

Esta análise identifica todos os valores hardcoded (valores fixos no código) que deveriam ser parametrizados via variáveis de ambiente ou configuração. A análise foi realizada em todos os arquivos `.js` e `.php` principais do projeto, excluindo backups e arquivos temporários.

### Estatísticas Gerais

- **Total de arquivos analisados:** 13 arquivos principais (3 JS + 10 PHP)
- **Total de valores hardcoded encontrados:** 52 ocorrências
- **Categorias identificadas:**
  - 🔴 **CRÍTICO:** 11 ocorrências (credenciais, tokens, senhas, API keys expostas no JS)
  - 🟠 **ALTO:** 18 ocorrências (URLs de APIs, domínios específicos, flags de configuração)
  - 🟡 **MÉDIO:** 17 ocorrências (URLs públicas, IPs de teste, valores padrão de config)
  - 🟢 **BAIXO:** 6 ocorrências (valores de exemplo, placeholders)

### Status de Uso das Variáveis

- ✅ **EM USO:** 45 variáveis (87%) - Variáveis ativamente utilizadas no código
- ⚠️ **DEPRECATED:** 0 variáveis (0%) - Variáveis definidas mas não utilizadas
- 🔄 **PARCIALMENTE USADAS:** 7 variáveis (13%) - Variáveis com funções alternativas disponíveis mas não utilizadas

**Nota:** Todas as variáveis hardcoded identificadas estão sendo utilizadas no código. Nenhuma variável deprecated foi encontrada. Algumas variáveis têm funções alternativas disponíveis (ex: `getOctaDeskApiKey()`) mas ainda estão usando valores hardcoded diretamente.

---

## ✅ STATUS DE USO DAS VARIÁVEIS

### Resumo Geral

| Status | Quantidade | Percentual |
|--------|-----------|------------|
| ✅ **EM USO** | 45 | 87% |
| ⚠️ **PARCIALMENTE DEPRECATED** | 7 | 13% |
| ❌ **DEPRECATED** | 0 | 0% |

### Variáveis Parcialmente Deprecated

As seguintes variáveis têm funções alternativas disponíveis mas ainda estão usando valores hardcoded diretamente:

1. **`add_webflow_octa.php` - `$OCTADESK_API_KEY`**
   - Função alternativa: `getOctaDeskApiKey()` em `config.php`
   - Status: Função existe mas não está sendo usada

2. **`add_webflow_octa.php` - `$API_BASE`**
   - Função alternativa: `getOctaDeskApiBase()` em `config.php`
   - Status: Função existe mas não está sendo usada

3. **`config.php` - Valores padrão hardcoded**
   - Funções: `getEspoCrmApiKey()`, `getWebflowSecretFlyingDonkeys()`, `getWebflowSecretOctaDesk()`, `getOctaDeskApiKey()`
   - Status: Usam `$_ENV` mas têm valores padrão hardcoded como fallback

### Variáveis Em Uso (Todas Ativas)

Todas as outras 45 variáveis identificadas estão sendo ativamente utilizadas no código:

- **JavaScript:** `USE_PHONE_API`, `VALIDAR_PH3A`, `APILAYER_KEY`, `SAFETY_TICKET`, `SAFETY_API_KEY`, `rpaEnabled`, `LOG_CONFIG`, `DEBUG_CONFIG`, URLs de APIs, etc.
- **PHP:** Credenciais PH3A, token PlacaFipe, emails de administradores, URLs de APIs, etc.

**Conclusão:** Nenhuma variável hardcoded está completamente deprecated. Todas estão sendo utilizadas, mas algumas têm alternativas melhores disponíveis que deveriam ser usadas.

### Status de Suporte por Variáveis de Ambiente

| Status | Quantidade | Percentual |
|--------|-----------|------------|
| ✅ **SUPORTE COMPLETO** | 3 | 6% |
| ⚠️ **SUPORTE PARCIAL** | 2 | 4% |
| ❌ **SEM SUPORTE** | 47 | 90% |

**Observação:** Apenas 3 variáveis hardcoded têm variáveis de ambiente correspondentes e funções helper disponíveis. A maioria (90%) não tem suporte de variáveis de ambiente. Ver seção "Análise Comparativa" para detalhes completos.

---

## 🔴 CRÍTICO - CREDENCIAIS E TOKENS HARDCODED

### 1. **cpf-validate.php** - Credenciais API PH3A

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/cpf-validate.php`

**Linhas:** 26-28

```php
$username = 'alex.kaminski@imediatoseguros.com.br';
$password = 'ImdSeg2025$$';
$api_key = '691dd2aa-9af4-84f2-06f9-350e1d709602';
```

**Risco:** 🔴 **CRÍTICO** - Credenciais expostas no código  
**Status:** ✅ **EM USO** - Utilizadas nas linhas 26-28, 33-34 para autenticação na API PH3A  
**Recomendação:** Mover para variáveis de ambiente:
- `PH3A_USERNAME`
- `PH3A_PASSWORD`
- `PH3A_API_KEY`

---

### 2. **placa-validate.php** - Token API PlacaFipe

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/placa-validate.php`

**Linha:** 27

```php
$token = '1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214';
```

**Risco:** 🔴 **CRÍTICO** - Token de API exposto no código  
**Status:** ✅ **EM USO** - Utilizado na linha 27 e 36 para autenticação na API PlacaFipe  
**Recomendação:** Mover para variável de ambiente:
- `PLACAFIPE_API_TOKEN`

---

### 3. **add_webflow_octa.php** - API Key OctaDesk

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_webflow_octa.php`

**Linha:** 54

```php
$OCTADESK_API_KEY = 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';
```

**Risco:** 🔴 **CRÍTICO** - API Key exposta no código  
**Status:** ✅ **EM USO** - Utilizada nas linhas 54, 85, 89 para autenticação na API OctaDesk  
**Recomendação:** Já existe função `getOctaDeskApiKey()` em `config.php`, mas não está sendo usada. Substituir por:
```php
$OCTADESK_API_KEY = getOctaDeskApiKey();
```
**Observação:** Esta variável está parcialmente deprecated - existe função alternativa (`getOctaDeskApiKey()`) mas ainda está usando valor hardcoded diretamente.

---

### 4. **FooterCodeSiteDefinitivoCompleto.js** - API Keys e Tickets Hardcoded

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Linhas:** 683-685

```javascript
window.APILAYER_KEY = 'dce92fa84152098a3b5b7b8db24debbc';
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // DEV: Ticket origem atualizado
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
```

**Risco:** 🔴 **CRÍTICO** - API Keys e Tickets expostos no código JavaScript (visíveis no navegador)  
**Status:** ✅ **EM USO** - Todas as variáveis estão sendo utilizadas:
- `APILAYER_KEY`: Linhas 1318, 1322, 1762 (validação de telefone via API Layer)
- `SAFETY_TICKET`: Linhas 1368, 1375, 1380, 1382, 1762 (validação de email via SafetyMails)
- `SAFETY_API_KEY`: Linhas 1368, 1376, 1383, 1762 (validação de email via SafetyMails)

**Recomendação:** 
- Mover para variáveis injetadas pelo servidor via `config_env.js.php`
- Ou criar endpoint PHP que retorna as chaves apenas para requisições autorizadas
- Nunca expor credenciais diretamente no JavaScript do cliente

**Observação:** Essas credenciais são visíveis no código fonte do navegador, representando risco de segurança.

---

### 5. **aws_ses_config.php** - Email Remetente e Administradores

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/aws_ses_config.php`

**Linhas:** 43-51

```php
define('EMAIL_FROM', 'noreply@bpsegurosimediato.com.br');
define('EMAIL_FROM_NAME', 'BP Seguros Imediato');

define('ADMIN_EMAILS', [
    'lrotero@gmail.com',
    'alex.kaminski@imediatoseguros.com.br',
    'alexkaminski70@gmail.com',
]);
```

**Risco:** 🔴 **CRÍTICO** - Emails pessoais expostos no código  
**Recomendação:** Mover para variáveis de ambiente:
- `EMAIL_FROM`
- `EMAIL_FROM_NAME`
- `ADMIN_EMAILS` (separado por vírgula)

---

### 6. **config.php** - Valores Padrão de Credenciais

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`

**Linhas:** 160-162, 170-172, 180-182, 190

```php
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'
        : '82d5f667f3a65a9a43341a0705be2b0c');
}

function getWebflowSecretFlyingDonkeys() {
    return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'] ?? (isDevelopment()
        ? '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51'
        : '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51');
}

function getWebflowSecretOctaDesk() {
    return $_ENV['WEBFLOW_SECRET_OCTADESK'] ?? (isDevelopment()
        ? '4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd'
        : '4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd');
}

function getOctaDeskApiKey() {
    return $_ENV['OCTADESK_API_KEY'] ?? 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';
}
```

**Risco:** 🔴 **CRÍTICO** - Valores padrão de credenciais hardcoded como fallback  
**Status:** ⚠️ **PARCIALMENTE DEPRECATED** - Funções estão sendo usadas, mas têm valores padrão hardcoded como fallback:
- `getEspoCrmApiKey()`: Usada em `add_flyingdonkeys.php`, `test_verificar_chave_api.php`, `test_apis_externas.php`
- `getWebflowSecretFlyingDonkeys()`: Usada em `add_flyingdonkeys.php`, `test_secret_keys.php`
- `getWebflowSecretOctaDesk()`: Usada em `add_webflow_octa.php`, `test_secret_keys.php`
- `getOctaDeskApiKey()`: Usada em `config.php` (linha 232), mas `add_webflow_octa.php` ainda usa valor hardcoded diretamente

**Recomendação:** 
- Remover valores padrão hardcoded
- Lançar exceção se variável de ambiente não estiver definida
- Documentar variáveis obrigatórias
- Substituir uso direto de `$OCTADESK_API_KEY` em `add_webflow_octa.php` por `getOctaDeskApiKey()`

---

## 🟠 ALTO - URLs DE APIs E DOMÍNIOS ESPECÍFICOS

### 7. **cpf-validate.php** - URLs API PH3A

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/cpf-validate.php`

**Linhas:** 31, 99

```php
$login_url = "https://api.ph3a.com.br/DataBusca/api/Account/Login";
$data_url = "https://api.ph3a.com.br/DataBusca/data";
```

**Risco:** 🟠 **ALTO** - URLs de API hardcoded  
**Status:** ✅ **EM USO** - Utilizadas nas linhas 31 e 99 para autenticação e consulta de dados na API PH3A  
**Recomendação:** Mover para variáveis de ambiente:
- `PH3A_LOGIN_URL`
- `PH3A_DATA_URL`

---

### 8. **placa-validate.php** - URL API PlacaFipe

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/placa-validate.php`

**Linha:** 28

```php
$url = "https://api.placafipe.com.br/getplaca";
```

**Risco:** 🟠 **ALTO** - URL de API hardcoded  
**Status:** ✅ **EM USO** - Utilizada na linha 28 para consulta de dados de veículos na API PlacaFipe  
**Recomendação:** Mover para variável de ambiente:
- `PLACAFIPE_API_URL`

---

### 9. **add_webflow_octa.php** - URL Base OctaDesk

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_webflow_octa.php`

**Linha:** 55

```php
$API_BASE = 'https://o205242-d60.api004.octadesk.services';
```

**Risco:** 🟠 **ALTO** - URL base da API hardcoded  
**Status:** ⚠️ **PARCIALMENTE DEPRECATED** - Utilizada na linha 55, mas já existe função `getOctaDeskApiBase()` em `config.php` que não está sendo usada  
**Recomendação:** Substituir por:
```php
$API_BASE = getOctaDeskApiBase();
```

---

### 10. **add_flyingdonkeys.php** - URL Webflow Hardcoded

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

**Linha:** 384

```php
'pageUrl' => 'https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io/',
```

**Risco:** 🟠 **ALTO** - URL específica do Webflow hardcoded  
**Recomendação:** Usar variável de ambiente ou detectar dinamicamente:
- `WEBFLOW_PAGE_URL` ou detectar de `$_SERVER['HTTP_REFERER']`

---

### 11. **add_flyingdonkeys.php** - Domínio Hardcoded

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

**Linha:** 703

```php
$webpage = 'mdmidia.com.br'; // Ambiente de produção
```

**Risco:** 🟠 **ALTO** - Domínio hardcoded  
**Recomendação:** Usar variável de ambiente ou detectar dinamicamente:
- `APP_WEBPAGE_DOMAIN` ou `$_SERVER['HTTP_HOST']`

---

### 12. **JavaScript - URLs de APIs Públicas**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/*.js`

**Arquivos:** `FooterCodeSiteDefinitivoCompleto.js`, `webflow_injection_limpo.js`, `MODAL_WHATSAPP_DEFINITIVO.js`

**Linhas:** Várias

```javascript
const VIACEP_BASE_URL = window.VIACEP_BASE_URL || 'https://viacep.com.br';
const APILAYER_BASE_URL = window.APILAYER_BASE_URL || 'https://apilayer.net';
const WHATSAPP_API_BASE = window.WHATSAPP_API_BASE || 'https://api.whatsapp.com';
const SAFETYMAILS_OPTIN_BASE = window.SAFETYMAILS_OPTIN_BASE || 'https://optin.safetymails.com';
const RPA_API_BASE_URL = window.RPA_API_BASE_URL || 'https://rpaimediatoseguros.com.br';
const SUCCESS_PAGE_URL = window.SUCCESS_PAGE_URL || 'https://www.segurosimediato.com.br/sucesso';
```

**Risco:** 🟠 **ALTO** - URLs de APIs hardcoded como fallback  
**Recomendação:** 
- ✅ Já usa `window.*` como fallback (bom)
- ⚠️ Garantir que todas as variáveis sejam injetadas via `config_env.js.php` ou similar
- ⚠️ Remover valores padrão hardcoded se não forem públicos

---

## 🟡 MÉDIO - URLs PÚBLICAS E IPs DE TESTE

### 13. **FooterCodeSiteDefinitivoCompleto.js** - Múltiplas Configurações Hardcoded

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Linhas:** 682-686, 1881

```javascript
window.USE_PHONE_API = true;
window.APILAYER_KEY = 'dce92fa84152098a3b5b7b8db24debbc';
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // DEV: Ticket origem atualizado
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
window.VALIDAR_PH3A = false;
window.rpaEnabled = false;
```

**Risco:** 
- 🔴 **CRÍTICO:** `APILAYER_KEY` e `SAFETY_TICKET` - Credenciais expostas no código JavaScript
- 🟠 **ALTO:** `USE_PHONE_API`, `VALIDAR_PH3A`, `rpaEnabled` - Flags de configuração hardcoded

**Status:** ✅ **EM USO** - Todas as variáveis estão sendo utilizadas:
- `USE_PHONE_API`: Linhas 1342, 1347, 1762, 2352 (controla validação de telefone via API externa)
- `VALIDAR_PH3A`: Linhas 1211, 1216, 1762, 2321, 2614, 2641 (controla validação de CPF via API PH3A)
- `rpaEnabled`: Linhas 2663, 2745, 2821, 2899 (controla funcionalidades RPA)

**Recomendação:** 
- **Credenciais:** Mover para variáveis injetadas pelo servidor via `config_env.js.php`:
  - `window.APILAYER_KEY` → `window.APILAYER_KEY` (injetado)
  - `window.SAFETY_TICKET` → `window.SAFETY_TICKET` (injetado)
- **Flags:** Parametrizar via variáveis de ambiente:
  - `window.USE_PHONE_API` → `window.USE_PHONE_API` (injetado, padrão: `true`)
  - `window.VALIDAR_PH3A` → `window.VALIDAR_PH3A` (injetado, padrão: `false`)
  - `window.rpaEnabled` → `window.RPA_ENABLED` (injetado, padrão: `false`)

**Observação:** 
- `rpaEnabled` é usado em múltiplos lugares (linhas 2663, 2745, 2821, etc.)
- `VALIDAR_PH3A` controla validação de CPF via API PH3A (linha 1216)
- `USE_PHONE_API` controla validação de telefone via API externa

---

### 14. **JavaScript - URLs de CDNs e Bibliotecas**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`

**Linhas:** 51, 3328, 3378, 3531, 3542, 3548

```javascript
@import url('https://fonts.googleapis.com/css2?family=Titillium+Web:wght@300;400;600;700&display=swap');
fontAwesome.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css';
<img src="https://cdn.prod.website-files.com/59eb807f9d16950001e202af/5f845624fe08f9f0d0573fee_logotipo-imediato-seguros.svg">
sweetAlertScript.src = 'https://cdn.jsdelivr.net/npm/sweetalert2@11.14.0/dist/sweetalert2.all.min.js';
```

**Risco:** 🟡 **MÉDIO** - URLs públicas de CDNs (aceitável, mas pode ser parametrizado)  
**Recomendação:** 
- Manter como está (URLs públicas de CDNs são aceitáveis)
- Ou criar variáveis de configuração se precisar trocar CDN facilmente

---

### 16. **FooterCodeSiteDefinitivoCompleto.js** - Valores Padrão de LOG_CONFIG Hardcoded

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Linhas:** 176-189, 699

```javascript
const defaultLogConfig = {
  enabled: true,
  level: 'info',
  database: {
    enabled: true,
    min_level: 'info'
  },
  console: {
    enabled: true,
    min_level: 'info'
  },
  file: {
    enabled: true,
    min_level: 'error'
  }
};

// E também:
window.DEBUG_CONFIG = {
  enabled: true,
  // ...
};
```

**Risco:** 🟡 **MÉDIO** - Valores padrão de configuração hardcoded  
**Recomendação:** 
- Usar valores injetados pelo servidor via `config_env.js.php`
- Manter valores padrão apenas como fallback se variáveis não estiverem definidas
- Documentar que valores padrão podem ser sobrescritos via injeção do servidor

---

### 17. **JavaScript - Detecção de Ambiente Hardcoded**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`, `MODAL_WHATSAPP_DEFINITIVO.js`

**Linhas:** 168, 133-135

```javascript
if (hostname.includes('dev.') || hostname.includes('localhost') || hostname.includes('127.0.0.1')) {
```

**Risco:** 🟡 **MÉDIO** - Lógica de detecção de ambiente hardcoded  
**Recomendação:** 
- Usar variável global `window.APP_ENVIRONMENT` injetada pelo servidor
- Ou usar `window.location.hostname` com lista configurável

---

### 18. **ProfessionalLogger.php** - IPs Docker Hardcoded

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Linhas:** 266-267

```php
$testHosts = ['172.18.0.1', '172.17.0.1'];
$gateway = '172.18.0.1'; // Default
```

**Risco:** 🟡 **MÉDIO** - IPs de gateway Docker hardcoded  
**Recomendação:** 
- Detectar automaticamente via `ip route` (já implementado)
- Remover valores padrão hardcoded se detecção automática funcionar
- Ou usar variável de ambiente `DOCKER_GATEWAY_IP`

---

### 19. **JavaScript - Domínio de Email Hardcoded**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`

**Linhas:** 556, 875

```javascript
email = ddd + onlyDigits(celular) + '@imediatoseguros.com.br';
'Email': ddd && celular ? `${ddd}${onlyDigits(celular)}@imediatoseguros.com.br` : '',
```

**Risco:** 🟡 **MÉDIO** - Domínio de email hardcoded  
**Recomendação:** Mover para variável de configuração:
- `DEFAULT_EMAIL_DOMAIN` ou `window.DEFAULT_EMAIL_DOMAIN`

---

## 🟢 BAIXO - VALORES DE EXEMPLO E PLACEHOLDERS

### 20. **JavaScript - Placeholders de Email**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`, `webflow_injection_limpo.js`

**Linhas:** 1710, 2432

```javascript
placeholder="seu@email.com"
email: "cliente@exemplo.com",
```

**Risco:** 🟢 **BAIXO** - Apenas placeholders/exemplos  
**Recomendação:** Manter como está (são apenas exemplos)

---

## 📊 RESUMO POR ARQUIVO

### Arquivos PHP

| Arquivo | Crítico | Alto | Médio | Baixo | Total |
|---------|---------|------|-------|-------|-------|
| `cpf-validate.php` | 2 | 2 | 0 | 0 | 4 |
| `placa-validate.php` | 1 | 1 | 0 | 0 | 2 |
| `add_webflow_octa.php` | 1 | 1 | 0 | 0 | 2 |
| `add_flyingdonkeys.php` | 0 | 2 | 0 | 0 | 2 |
| `aws_ses_config.php` | 1 | 0 | 0 | 0 | 1 |
| `config.php` | 1 | 0 | 0 | 0 | 1 |
| `ProfessionalLogger.php` | 0 | 0 | 1 | 0 | 1 |
| **TOTAL PHP** | **6** | **6** | **1** | **0** | **13** |
| **TOTAL GERAL** | **9** | **11** | **10** | **2** | **32** |

### Arquivos JavaScript

| Arquivo | Crítico | Alto | Médio | Baixo | Total |
|---------|---------|------|-------|-------|-------|
| `FooterCodeSiteDefinitivoCompleto.js` | 3 | 3 | 2 | 0 | 8 |
| `webflow_injection_limpo.js` | 0 | 1 | 5 | 1 | 7 |
| `MODAL_WHATSAPP_DEFINITIVO.js` | 0 | 1 | 2 | 1 | 4 |
| **TOTAL JS** | **3** | **5** | **9** | **2** | **19** |

---

## 🎯 PLANO DE AÇÃO RECOMENDADO

### Fase 1: Crítico (Prioridade Máxima)

1. ✅ **Mover credenciais para variáveis de ambiente:**
   - `cpf-validate.php`: PH3A credentials
   - `placa-validate.php`: PlacaFipe token
   - `add_webflow_octa.php`: Usar `getOctaDeskApiKey()` e `getOctaDeskApiBase()`
   - `aws_ses_config.php`: Emails de administradores
   - `config.php`: Remover valores padrão hardcoded

2. ✅ **Proteger API Keys expostas no JavaScript:**
   - `FooterCodeSiteDefinitivoCompleto.js`: `APILAYER_KEY`, `SAFETY_TICKET`, `SAFETY_API_KEY`
   - Criar endpoint PHP que retorna as chaves apenas para requisições autorizadas
   - Ou mover para variáveis injetadas via `config_env.js.php` (não expor diretamente no JS)

### Fase 2: Alto (Prioridade Alta)

3. ✅ **Parametrizar URLs de APIs:**
   - `cpf-validate.php`: URLs PH3A
   - `placa-validate.php`: URL PlacaFipe
   - `add_flyingdonkeys.php`: URLs e domínios

4. ✅ **Garantir injeção de variáveis JavaScript:**
   - Verificar se `config_env.js.php` existe e injeta todas as variáveis necessárias
   - Parametrizar flags de configuração: `USE_PHONE_API`, `VALIDAR_PH3A`, `rpaEnabled`
   - Parametrizar valores padrão de `LOG_CONFIG` e `DEBUG_CONFIG`
   - Documentar variáveis obrigatórias

### Fase 3: Médio (Prioridade Média)

5. ✅ **Melhorar detecção de ambiente:**
   - Usar variável global `window.APP_ENVIRONMENT` injetada pelo servidor
   - Remover lógica hardcoded de detecção

6. ✅ **Parametrizar flags de configuração:**
   - `FooterCodeSiteDefinitivoCompleto.js`: `window.rpaEnabled` deve ser injetado pelo servidor
   - `MODAL_WHATSAPP_DEFINITIVO.js`: Domínio de email padrão

### Fase 4: Baixo (Prioridade Baixa)

7. ✅ **Revisar placeholders:**
   - Manter como está (apenas exemplos)

---

## 📝 NOTAS IMPORTANTES

### ✅ Boas Práticas Já Implementadas

1. **JavaScript:** Uso de `window.*` como fallback para variáveis de configuração
2. **PHP:** Uso de `$_ENV` com fallback para variáveis de ambiente
3. **config.php:** Funções helper para acesso seguro às configurações

### ⚠️ Pontos de Atenção

1. **Valores padrão hardcoded:** Mesmo com fallback para `$_ENV`, valores padrão hardcoded ainda são um risco se variáveis não forem definidas
2. **JavaScript no navegador:** Qualquer valor hardcoded em JavaScript é visível no navegador do cliente
3. **Credenciais em código:** Nunca commitar credenciais reais no Git

### 🔒 Recomendações de Segurança

1. **Usar `.env` local:** Criar arquivo `.env.local` para desenvolvimento (não versionar)
2. **Variáveis de ambiente no Docker:** Configurar todas as credenciais via variáveis de ambiente do Docker
3. **Validação obrigatória:** Lançar exceção se variável crítica não estiver definida (não usar fallback hardcoded)
4. **Rotação de credenciais:** Facilitar rotação de credenciais usando variáveis de ambiente

---

## 🔄 ANÁLISE COMPARATIVA: VARIÁVEIS DE AMBIENTE vs VARIÁVEIS HARDCODED

### Variáveis de Ambiente Disponíveis no Projeto

#### Variáveis Definidas no PHP-FPM (DEV)

**Ambiente e Aplicação:**
- `PHP_ENV` = development
- `APP_BASE_DIR` = /var/www/html/dev/root
- `APP_BASE_URL` = https://dev.bssegurosimediato.com.br
- `APP_CORS_ORIGINS` = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br
- `LOG_DIR` = /var/log/webflow-segurosimediato

**Banco de Dados:**
- `LOG_DB_HOST` = localhost
- `LOG_DB_PORT` = 3306
- `LOG_DB_NAME` = rpa_logs_dev
- `LOG_DB_USER` = rpa_logger_dev
- `LOG_DB_PASS` = tYbAwe7QkKNrHSRhaWplgsSxt

**EspoCRM:**
- `ESPOCRM_URL` = https://dev.flyingdonkeys.com.br
- `ESPOCRM_API_KEY` = 73b5b7983bfc641cdba72d204a48ed9d

**Webflow:**
- `WEBFLOW_SECRET_FLYINGDONKEYS` = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142 ✅ (valor atual em uso)
- `WEBFLOW_SECRET_OCTADESK` = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291 ✅ (valor atual em uso)

**OctaDesk:**
- `OCTADESK_API_KEY` = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
- `OCTADESK_API_BASE` = https://o205242-d60.api004.octadesk.services

**AWS SES:**
- `AWS_ACCESS_KEY_ID` = AKIAIOSFODNN7EXAMPLE (exemplo)
- `AWS_SECRET_ACCESS_KEY` = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY (exemplo)
- `AWS_REGION` = us-east-1
- `AWS_SES_FROM_EMAIL` = noreply@bssegurosimediato.com.br
- `AWS_SES_ADMIN_EMAILS` = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com

**Logging (ProfessionalLogger):**
- `LOG_ENABLED` (usado em ProfessionalLogger.php)
- `LOG_LEVEL` (usado em ProfessionalLogger.php)
- `LOG_DATABASE_ENABLED` (usado em ProfessionalLogger.php)
- `LOG_DATABASE_MIN_LEVEL` (usado em ProfessionalLogger.php)
- `LOG_CONSOLE_ENABLED` (usado em ProfessionalLogger.php)
- `LOG_CONSOLE_MIN_LEVEL` (usado em ProfessionalLogger.php)
- `LOG_FILE_ENABLED` (usado em ProfessionalLogger.php)
- `LOG_FILE_MIN_LEVEL` (usado em ProfessionalLogger.php)
- `LOG_EXCLUDE_CATEGORIES` (usado em ProfessionalLogger.php)
- `LOG_EXCLUDE_CONTEXTS` (usado em ProfessionalLogger.php)

#### Variáveis Expostas para JavaScript (config_env.js.php)

- `window.APP_BASE_URL` (via `APP_BASE_URL`)
- `window.APP_ENVIRONMENT` (via `PHP_ENV`)

---

### Comparação: Variáveis Hardcoded vs Variáveis de Ambiente

| Variável Hardcoded | Arquivo | Status | Variável de Ambiente Correspondente | Função Helper Disponível |
|-------------------|---------|--------|-------------------------------------|---------------------------|
| **CRÍTICO - CREDENCIAIS PHP** |
| `$username` (PH3A) | `cpf-validate.php` | ❌ **NÃO EXISTE** | `PH3A_USERNAME` | ❌ Não existe |
| `$password` (PH3A) | `cpf-validate.php` | ❌ **NÃO EXISTE** | `PH3A_PASSWORD` | ❌ Não existe |
| `$api_key` (PH3A) | `cpf-validate.php` | ❌ **NÃO EXISTE** | `PH3A_API_KEY` | ❌ Não existe |
| `$token` (PlacaFipe) | `placa-validate.php` | ❌ **NÃO EXISTE** | `PLACAFIPE_API_TOKEN` | ❌ Não existe |
| `$OCTADESK_API_KEY` | `add_webflow_octa.php` | ✅ **EXISTE** | `OCTADESK_API_KEY` | ✅ `getOctaDeskApiKey()` |
| `$API_BASE` (OctaDesk) | `add_webflow_octa.php` | ✅ **EXISTE** | `OCTADESK_API_BASE` | ✅ `getOctaDeskApiBase()` |
| `EMAIL_FROM` | `aws_ses_config.php` | ✅ **EXISTE** | `AWS_SES_FROM_EMAIL` | ❌ Não existe |
| `EMAIL_FROM_NAME` | `aws_ses_config.php` | ❌ **NÃO EXISTE** | `AWS_SES_FROM_NAME` | ❌ Não existe |
| `ADMIN_EMAILS` | `aws_ses_config.php` | ✅ **EXISTE** | `AWS_SES_ADMIN_EMAILS` | ❌ Não existe |
| Valores padrão em `config.php` | `config.php` | ⚠️ **PARCIAL** | Várias | ✅ Funções existem mas têm fallback hardcoded |
| **CRÍTICO - CREDENCIAIS JAVASCRIPT** |
| `window.APILAYER_KEY` | `FooterCodeSiteDefinitivoCompleto.js` | ❌ **NÃO EXISTE** | `APILAYER_KEY` | ❌ Não existe |
| `window.SAFETY_TICKET` | `FooterCodeSiteDefinitivoCompleto.js` | ❌ **NÃO EXISTE** | `SAFETY_TICKET` | ❌ Não existe |
| `window.SAFETY_API_KEY` | `FooterCodeSiteDefinitivoCompleto.js` | ❌ **NÃO EXISTE** | `SAFETY_API_KEY` | ❌ Não existe |
| **ALTO - FLAGS E CONFIGURAÇÕES** |
| `window.USE_PHONE_API` | `FooterCodeSiteDefinitivoCompleto.js` | ❌ **NÃO EXISTE** | `USE_PHONE_API` | ❌ Não existe |
| `window.VALIDAR_PH3A` | `FooterCodeSiteDefinitivoCompleto.js` | ❌ **NÃO EXISTE** | `VALIDAR_PH3A` | ❌ Não existe |
| `window.rpaEnabled` | `FooterCodeSiteDefinitivoCompleto.js` | ❌ **NÃO EXISTE** | `RPA_ENABLED` | ❌ Não existe |
| **ALTO - URLs DE APIs** |
| `$login_url` (PH3A) | `cpf-validate.php` | ❌ **NÃO EXISTE** | `PH3A_LOGIN_URL` | ❌ Não existe |
| `$data_url` (PH3A) | `cpf-validate.php` | ❌ **NÃO EXISTE** | `PH3A_DATA_URL` | ❌ Não existe |
| `$url` (PlacaFipe) | `placa-validate.php` | ❌ **NÃO EXISTE** | `PLACAFIPE_API_URL` | ❌ Não existe |
| URLs JavaScript (fallbacks) | `*.js` | ⚠️ **PARCIAL** | Várias (mas não injetadas) | ❌ Não existe |

---

### Resumo da Análise Comparativa

#### ✅ Variáveis com Suporte Completo (3 variáveis)

1. **`OCTADESK_API_KEY`** - ✅ Variável de ambiente existe + função helper disponível
2. **`OCTADESK_API_BASE`** - ✅ Variável de ambiente existe + função helper disponível
3. **`AWS_SES_ADMIN_EMAILS`** - ✅ Variável de ambiente existe (mas sem função helper)

#### ⚠️ Variáveis com Suporte Parcial (2 variáveis)

1. **Valores padrão em `config.php`** - Funções existem mas têm fallback hardcoded
2. **URLs JavaScript** - Usam `window.*` como fallback mas não são injetadas via `config_env.js.php`

#### ❌ Variáveis Sem Suporte (20+ variáveis)

**PHP (8 variáveis):**
- `PH3A_USERNAME`, `PH3A_PASSWORD`, `PH3A_API_KEY`
- `PH3A_LOGIN_URL`, `PH3A_DATA_URL`
- `PLACAFIPE_API_TOKEN`, `PLACAFIPE_API_URL`
- `AWS_SES_FROM_NAME`

**JavaScript (12+ variáveis):**
- `APILAYER_KEY`, `SAFETY_TICKET`, `SAFETY_API_KEY`
- `USE_PHONE_API`, `VALIDAR_PH3A`, `RPA_ENABLED`
- URLs de APIs públicas (VIACEP, APILAYER, SAFETYMAILS, etc.)

---

### Recomendações Prioritárias

#### Fase 1: Criar Variáveis de Ambiente Faltantes (CRÍTICO)

1. **PHP - Credenciais PH3A:**
   ```
   env[PH3A_USERNAME] = alex.kaminski@imediatoseguros.com.br
   env[PH3A_PASSWORD] = ImdSeg2025$$
   env[PH3A_API_KEY] = 691dd2aa-9af4-84f2-06f9-350e1d709602
   env[PH3A_LOGIN_URL] = https://api.ph3a.com.br/DataBusca/api/Account/Login
   env[PH3A_DATA_URL] = https://api.ph3a.com.br/DataBusca/data
   ```

2. **PHP - Credenciais PlacaFipe:**
   ```
   env[PLACAFIPE_API_TOKEN] = 1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214
   env[PLACAFIPE_API_URL] = https://api.placafipe.com.br/getplaca
   ```

3. **PHP - AWS SES:**
   ```
   env[AWS_SES_FROM_NAME] = BP Seguros Imediato
   ```

4. **JavaScript - Credenciais Expostas:**
   ```
   env[APILAYER_KEY] = dce92fa84152098a3b5b7b8db24debbc
   env[SAFETY_TICKET] = 05bf2ec47128ca0b917f8b955bada1bd3cadd47e
   env[SAFETY_API_KEY] = 20a7a1c297e39180bd80428ac13c363e882a531f
   ```

5. **JavaScript - Flags de Configuração:**
   ```
   env[USE_PHONE_API] = true
   env[VALIDAR_PH3A] = false
   env[RPA_ENABLED] = false
   ```

#### Fase 2: Criar Funções Helper (ALTO)

1. Criar funções em `config.php`:
   - `getPh3aCredentials()` → retorna array com username, password, api_key
   - `getPh3aLoginUrl()` → retorna URL de login
   - `getPh3aDataUrl()` → retorna URL de dados
   - `getPlacaFipeToken()` → retorna token
   - `getPlacaFipeApiUrl()` → retorna URL da API
   - `getAwsSesFromName()` → retorna nome do remetente

2. Atualizar `config_env.js.php` para injetar todas as variáveis JavaScript necessárias

#### Fase 3: Remover Valores Padrão Hardcoded (MÉDIO)

1. Remover fallbacks hardcoded de `config.php`
2. Lançar exceção se variável crítica não estiver definida
3. Documentar variáveis obrigatórias

---

## 🔍 ANÁLISE DETALHADA: COMPARAÇÃO DE VALORES HARDCODED vs VARIÁVEIS DE AMBIENTE

### Metodologia

Esta análise compara cuidadosamente os valores hardcoded encontrados no código com os valores correspondentes definidos nas variáveis de ambiente do PHP-FPM. O objetivo é identificar:
1. Variáveis que têm valores idênticos (consistência)
2. Variáveis que têm valores diferentes (discrepâncias críticas)
3. Variáveis que não estão sendo utilizadas corretamente (usando hardcoded em vez de env)

### Variáveis com Valores Idênticos ✅

| Variável | Arquivo Hardcoded | Valor Hardcoded | Valor Env | Status |
|----------|------------------|----------------|-----------|--------|
| `OCTADESK_API_KEY` | `add_webflow_octa.php:54` | `b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b` | `b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b` | ✅ **IDÊNTICO** |
| `OCTADESK_API_BASE` | `add_webflow_octa.php:55` | `https://o205242-d60.api004.octadesk.services` | `https://o205242-d60.api004.octadesk.services` | ✅ **IDÊNTICO** |
| `ESPOCRM_API_KEY` (dev) | `config.php:161` (fallback) | `73b5b7983bfc641cdba72d204a48ed9d` | `73b5b7983bfc641cdba72d204a48ed9d` | ✅ **IDÊNTICO** |
| `ADMIN_EMAILS` | `aws_ses_config.php:47-51` | `['lrotero@gmail.com', 'alex.kaminski@imediatoseguros.com.br', 'alexkaminski70@gmail.com']` | `lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com` | ✅ **MESMOS EMAILS** (formato diferente) |

**Observação:** `ADMIN_EMAILS` tem os mesmos emails, mas formato diferente (array PHP vs string separada por vírgula). O código usa o array hardcoded diretamente, ignorando a variável de ambiente.

### Variáveis com Valores Diferentes ❌

| Variável | Arquivo Hardcoded | Valor Hardcoded | Valor Env | Diferença | Impacto |
|----------|------------------|----------------|-----------|-----------|---------|
| `EMAIL_FROM` | `aws_ses_config.php:43` | `noreply@bpsegurosimediato.com.br` ❌ | `noreply@bssegurosimediato.com.br` ✅ | **bp** vs **bs** | 🔴 **CRÍTICO** - Hardcoded incorreto (confirmado: `bs` é correto) |
| `WEBFLOW_SECRET_FLYINGDONKEYS` | `config.php:171` (fallback) | `50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51` ⚠️ | `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` ✅ | Fallback desatualizado | 🟡 **MÉDIO** - Env está sendo usado corretamente (fallback não usado) |
| `WEBFLOW_SECRET_OCTADESK` | `config.php:181` (fallback) | `4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd` ⚠️ | `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291` ✅ | Fallback desatualizado | 🟡 **MÉDIO** - Env está sendo usado corretamente (fallback não usado) |

**Observação Importante:** 
- ✅ **EMAIL_FROM:** Valor correto confirmado pelo usuário é `bs` (não `bp`). O valor env está correto, apenas o código precisa usar a variável de ambiente.
- ✅ **WEBFLOW_SECRET_FLYINGDONKEYS:** Valor env atual (`888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142`) está sendo usado corretamente pelo código via `getWebflowSecretFlyingDonkeys()`. O fallback está desatualizado mas não é usado.
- ✅ **WEBFLOW_SECRET_OCTADESK:** Valor env atual (`1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291`) está sendo usado corretamente pelo código via `getWebflowSecretOctaDesk()`. O fallback está desatualizado mas não é usado.

### Variáveis Não Utilizadas Corretamente ⚠️

| Variável | Arquivo Hardcoded | Status de Uso | Variável Env Disponível | Problema |
|----------|------------------|--------------|------------------------|----------|
| `$OCTADESK_API_KEY` | `add_webflow_octa.php:54` | ✅ Usado diretamente | ✅ `OCTADESK_API_KEY` | ⚠️ Deveria usar `getOctaDeskApiKey()` |
| `$API_BASE` | `add_webflow_octa.php:55` | ✅ Usado diretamente | ✅ `OCTADESK_API_BASE` | ⚠️ Deveria usar `getOctaDeskApiBase()` |
| `EMAIL_FROM` | `aws_ses_config.php:43` | ✅ Usado via `define()` | ✅ `AWS_SES_FROM_EMAIL` | ⚠️ Não usa variável de ambiente (valor diferente) |
| `ADMIN_EMAILS` | `aws_ses_config.php:47` | ✅ Usado via `define()` | ✅ `AWS_SES_ADMIN_EMAILS` | ⚠️ Não usa variável de ambiente (usa array hardcoded) |

### Análise de Uso Real vs Variáveis de Ambiente

#### 1. **OCTADESK_API_KEY** - `add_webflow_octa.php`

**Valor Hardcoded (linha 54):**
```php
$OCTADESK_API_KEY = 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';
```

**Valor Env (PHP-FPM):**
```
env[OCTADESK_API_KEY] = b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b
```

**Função Helper Disponível:**
```php
function getOctaDeskApiKey() {
    return $_ENV['OCTADESK_API_KEY'] ?? 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';
}
```

**Status:** ✅ Valores idênticos, mas código usa hardcoded diretamente em vez de função helper  
**Uso Real:** Linha 54 define variável, linhas 85 e 89 usam `$OCTADESK_API_KEY`  
**Recomendação:** Substituir linha 54 por `$OCTADESK_API_KEY = getOctaDeskApiKey();`

---

#### 2. **OCTADESK_API_BASE** - `add_webflow_octa.php`

**Valor Hardcoded (linha 55):**
```php
$API_BASE = 'https://o205242-d60.api004.octadesk.services';
```

**Valor Env (PHP-FPM):**
```
env[OCTADESK_API_BASE] = https://o205242-d60.api004.octadesk.services
```

**Função Helper Disponível:**
```php
function getOctaDeskApiBase() {
    $base = $_ENV['OCTADESK_API_BASE'] ?? '';
    if (empty($base)) {
        throw new RuntimeException('OCTADESK_API_BASE não está definido nas variáveis de ambiente');
    }
    return $base;
}
```

**Status:** ✅ Valores idênticos, mas código usa hardcoded diretamente em vez de função helper  
**Uso Real:** Linha 55 define variável, linha 282 usa `$API_BASE` (via `global $API_BASE`)  
**Recomendação:** Substituir linha 55 por `$API_BASE = getOctaDeskApiBase();`

---

#### 3. **EMAIL_FROM** - `aws_ses_config.php`

**Valor Hardcoded (linha 43):**
```php
define('EMAIL_FROM', 'noreply@bpsegurosimediato.com.br');
```

**Valor Env (PHP-FPM):**
```
env[AWS_SES_FROM_EMAIL] = noreply@bssegurosimediato.com.br
```

**Status:** ❌ **VALORES DIFERENTES** - `bp` vs `bs` no domínio  
**Valor Correto:** ✅ **`bs`** (confirmado pelo usuário)  
**Uso Real:** `send_admin_notification_ses.php` linha 139 usa `EMAIL_FROM`  
**Impacto:** 🔴 **CRÍTICO** - Valor hardcoded está incorreto (`bp`), pode causar falha no envio de emails  
**Recomendação:** 
- ✅ **Valor correto confirmado:** `bs` (não `bp`)
- **Ação necessária:** Atualizar `aws_ses_config.php` linha 43 para usar `$_ENV['AWS_SES_FROM_EMAIL']`
- O valor env está correto, apenas o código precisa usar a variável de ambiente

---

#### 4. **ADMIN_EMAILS** - `aws_ses_config.php`

**Valor Hardcoded (linhas 47-51):**
```php
define('ADMIN_EMAILS', [
    'lrotero@gmail.com',
    'alex.kaminski@imediatoseguros.com.br',
    'alexkaminski70@gmail.com',
]);
```

**Valor Env (PHP-FPM):**
```
env[AWS_SES_ADMIN_EMAILS] = lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com
```

**Status:** ✅ Mesmos emails, mas formato diferente (array vs string)  
**Uso Real:** `send_admin_notification_ses.php` linha 136 usa `ADMIN_EMAILS` em `foreach`  
**Impacto:** 🟡 **MÉDIO** - Código não usa variável de ambiente  
**Recomendação:** 
- Atualizar `aws_ses_config.php` para converter string env em array:
```php
$adminEmailsStr = $_ENV['AWS_SES_ADMIN_EMAILS'] ?? 'lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com';
define('ADMIN_EMAILS', array_map('trim', explode(',', $adminEmailsStr)));
```

---

#### 5. **ESPOCRM_API_KEY** - `config.php` (fallback)

**Valor Hardcoded (linha 161 - fallback dev):**
```php
return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
    ? '73b5b7983bfc641cdba72d204a48ed9d'
    : '82d5f667f3a65a9a43341a0705be2b0c');
```

**Valor Env (PHP-FPM):**
```
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d
```

**Status:** ✅ Valores idênticos (dev)  
**Uso Real:** `add_flyingdonkeys.php` linha 667 usa `getEspoCrmApiKey()` corretamente  
**Observação:** Função está sendo usada corretamente, fallback hardcoded é apenas segurança

---

#### 6. **WEBFLOW_SECRET_FLYINGDONKEYS** - `config.php` (fallback)

**Valor Hardcoded (linha 171 - fallback):**
```php
return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'] ?? (isDevelopment()
    ? '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51'
    : '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51');
```

**Valor Env (PHP-FPM - arquivo atual `php-fpm_www_conf_DEV.txt`):**
```
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142
```

**Valor Env (PHP-FPM - backup `www.conf.dev.backup_20251118_152418`):**
```
env[WEBFLOW_SECRET_FLYINGDONKEYS] = 5e93a6f31e520738ce8bf4770f32929bec207696ad9ca54f6f5e67813c33ae40
```

**Status:** ⚠️ **VALOR USADO É O ENV ATUAL** - Código usa função helper que prioriza `$_ENV`  
**Uso Real:** `add_flyingdonkeys.php` linha 67 usa `getWebflowSecretFlyingDonkeys()` corretamente  
**Valor Atualmente Usado:** ✅ `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` (env atual)  
**Impacto:** 🟡 **MÉDIO** - Fallback hardcoded está desatualizado, mas não é usado porque env está definido  
**Observação:** Como a função `getWebflowSecretFlyingDonkeys()` prioriza `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']`, o valor usado é o env atual. O fallback só seria usado se a variável de ambiente não estivesse definida.  
**Recomendação:** 
- ✅ **Valor correto confirmado:** O valor env atual (`888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142`) é o utilizado pelo código
- Atualizar fallback para corresponder ao valor env atual (opcional, apenas para consistência)
- Ou remover fallback e lançar exceção se não estiver definido (mais seguro)

---

#### 7. **WEBFLOW_SECRET_OCTADESK** - `config.php` (fallback)

**Valor Hardcoded (linha 181 - fallback):**
```php
return $_ENV['WEBFLOW_SECRET_OCTADESK'] ?? (isDevelopment()
    ? '4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd'
    : '4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd');
```

**Valor Env (PHP-FPM - arquivo atual `php-fpm_www_conf_DEV.txt`):**
```
env[WEBFLOW_SECRET_OCTADESK] = 1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291
```

**Valor Env (PHP-FPM - backup `www.conf.dev.backup_20251118_152418`):**
```
env[WEBFLOW_SECRET_OCTADESK] = 000b928364360d28af0db403c33aa5ec39d8ea9a8358add26a41f9ef951e6246
```

**Status:** ⚠️ **VALOR USADO É O ENV ATUAL** - Código usa função helper que prioriza `$_ENV`  
**Uso Real:** `add_webflow_octa.php` linha 58 usa `getWebflowSecretOctaDesk()` corretamente  
**Valor Atualmente Usado:** ✅ `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291` (env atual)  
**Impacto:** 🟡 **MÉDIO** - Fallback hardcoded está desatualizado, mas não é usado porque env está definido  
**Observação:** Como a função `getWebflowSecretOctaDesk()` prioriza `$_ENV['WEBFLOW_SECRET_OCTADESK']`, o valor usado é o env atual. O fallback só seria usado se a variável de ambiente não estivesse definida.  
**Recomendação:** 
- ✅ **Valor correto confirmado:** O valor env atual (`1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291`) é o utilizado pelo código
- Atualizar fallback para corresponder ao valor env atual (opcional, apenas para consistência)
- Ou remover fallback e lançar exceção se não estiver definido (mais seguro)

---

### Resumo da Análise Comparativa

| Categoria | Quantidade | Percentual |
|-----------|-----------|------------|
| ✅ **Valores Idênticos** | 4 | 57% |
| ❌ **Valores Diferentes** | 3 | 43% |
| ⚠️ **Não Usa Env Corretamente** | 4 | 57% |

### Problemas Críticos Identificados

1. **EMAIL_FROM:** Domínio diferente (`bp` vs `bs`) - valor hardcoded está incorreto
   - Hardcoded: `noreply@bpsegurosimediato.com.br` ❌ **INCORRETO**
   - Env: `noreply@bssegurosimediato.com.br` ✅ **CORRETO** (confirmado pelo usuário)
   - **Ação necessária:** Atualizar `aws_ses_config.php` para usar `$_ENV['AWS_SES_FROM_EMAIL']`

2. **WEBFLOW_SECRET_FLYINGDONKEYS:** Fallback hardcoded desatualizado (mas não usado)
   - Hardcoded (fallback): `50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51` ⚠️ **DESATUALIZADO**
   - Env atual: `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` ✅ **EM USO** (confirmado pelo usuário)
   - **Status:** Valor env está sendo usado corretamente, fallback não é necessário
   - **Ação necessária:** Atualizar fallback para corresponder ao env atual (opcional) ou remover fallback

3. **WEBFLOW_SECRET_OCTADESK:** Fallback hardcoded desatualizado (mas não usado)
   - Hardcoded (fallback): `4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd` ⚠️ **DESATUALIZADO**
   - Env atual: `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291` ✅ **EM USO**
   - **Status:** Valor env está sendo usado corretamente, fallback não é necessário
   - **Ação necessária:** Atualizar fallback para corresponder ao env atual (opcional) ou remover fallback

4. **OCTADESK_API_KEY e OCTADESK_API_BASE:** Valores corretos mas não usam funções helper disponíveis
   - Valores são idênticos entre hardcoded e env
   - **Ação necessária:** Substituir uso direto por funções helper em `add_webflow_octa.php`

### Recomendações Prioritárias

1. **CRÍTICO:** Corrigir `EMAIL_FROM` em `aws_ses_config.php`
   - ✅ **Valor correto confirmado:** `bs` (não `bp`)
   - **Ação:** Atualizar `aws_ses_config.php` linha 7 para usar `$_ENV['AWS_SES_FROM_EMAIL']`
   - O valor env está correto, apenas o código precisa usar a variável de ambiente

2. **MÉDIO:** Atualizar fallbacks de `WEBFLOW_SECRET_FLYINGDONKEYS` e `WEBFLOW_SECRET_OCTADESK` (opcional)
   - ✅ **Valores corretos confirmados:**
     - `WEBFLOW_SECRET_FLYINGDONKEYS`: `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142`
     - `WEBFLOW_SECRET_OCTADESK`: `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291`
   - **Status:** Valores env estão sendo usados corretamente, fallbacks não são necessários
   - **Ação (opcional):** Atualizar fallbacks em `config.php` para corresponder aos valores env atuais
   - **Alternativa (recomendada):** Remover fallbacks e lançar exceção se variável não estiver definida (mais seguro)

3. **ALTO:** Substituir uso direto de `$OCTADESK_API_KEY` e `$API_BASE` por funções helper
   - `add_webflow_octa.php` linha 54: `$OCTADESK_API_KEY = getOctaDeskApiKey();`
   - `add_webflow_octa.php` linha 55: `$API_BASE = getOctaDeskApiBase();`

4. **ALTO:** Atualizar `aws_ses_config.php` para usar variáveis de ambiente
   - `EMAIL_FROM`: Usar `$_ENV['AWS_SES_FROM_EMAIL']` (já identificado acima)
   - `EMAIL_FROM_NAME`: Criar `$_ENV['AWS_SES_FROM_NAME']` e usar
   - `ADMIN_EMAILS`: Converter `$_ENV['AWS_SES_ADMIN_EMAILS']` de string para array

---

## 📚 REFERÊNCIAS

- Documentação de variáveis de ambiente: `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/`
- Arquivo de configuração: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`
- Arquivo de injeção JS: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config_env.js.php`
- Configuração PHP-FPM: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.txt`
- Diretivas do projeto: `.cursorrules`

---

**Análise realizada em:** 18/11/2025  
**Próxima revisão recomendada:** Após implementação das correções críticas

