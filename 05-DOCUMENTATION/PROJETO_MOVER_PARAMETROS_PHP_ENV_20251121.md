# 🎯 PROJETO: Mover Parâmetros de Data Attributes para Variáveis de Ambiente PHP

**Data de Criação:** 21/11/2025  
**Versão:** 1.1.0  
**Status:** 📋 **PLANEJAMENTO** - Aguardando autorização para implementação  
**Última Atualização:** 21/11/2025 - Versão 1.1.0 (aprimorado para satisfazer findings da auditoria)

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Mover 8 parâmetros que atualmente são passados via `data-attributes` no Webflow para serem lidos diretamente das variáveis de ambiente do PHP e expostos via `config_env.js.php`. Isso reduz a complexidade da configuração no Webflow e centraliza mais configurações no servidor.

### Parâmetros a Mover para PHP

1. `data-apilayer-key` → `APILAYER_KEY`
2. `data-safety-ticket` → `SAFETY_TICKET`
3. `data-safety-api-key` → `SAFETY_API_KEY`
4. `data-viacep-base-url` → `VIACEP_BASE_URL`
5. `data-apilayer-base-url` → `APILAYER_BASE_URL`
6. `data-safetymails-optin-base` → `SAFETYMAILS_OPTIN_BASE`
7. `data-rpa-api-base-url` → `RPA_API_BASE_URL`
8. `data-safetymails-base-domain` → `SAFETYMAILS_BASE_DOMAIN`

### Parâmetros que Permanecem no Webflow

1. `data-app-base-url` → `APP_BASE_URL`
2. `data-app-environment` → `APP_ENVIRONMENT`
3. `data-rpa-enabled` → `rpaEnabled`
4. `data-use-phone-api` → `USE_PHONE_API`
5. `data-validar-ph3a` → `VALIDAR_PH3A`
6. `data-success-page-url` → `SUCCESS_PAGE_URL`
7. `data-whatsapp-api-base` → `WHATSAPP_API_BASE`
8. `data-whatsapp-phone` → `WHATSAPP_PHONE`
9. `data-whatsapp-default-message` → `WHATSAPP_DEFAULT_MESSAGE`

### Escopo

- **Arquivos a Modificar:**
  - `config_env.js.php` - Adicionar exposição das 8 novas variáveis
  - `FooterCodeSiteDefinitivoCompleto.js` - Remover leitura de data-attributes e usar variáveis do `window` injetadas pelo PHP
  - `MODAL_WHATSAPP_DEFINITIVO.js` - Verificar uso e atualizar se necessário
  - `webflow_injection_limpo.js` - Verificar uso e atualizar se necessário
- **Arquivos de Configuração:**
  - `php-fpm_www_conf_DEV.txt` - Verificar se variáveis já estão definidas (já estão)
- **Documentação:**
  - `GUIA_ATUALIZACAO_WEBFLOW_SCRIPT_TAG_20251121.md` - Atualizar removendo os 8 parâmetros

### Impacto Esperado

- ✅ **Redução de Complexidade:** Menos parâmetros no Webflow (de 17 para 9)
- ✅ **Centralização:** Configurações sensíveis (API keys) ficam apenas no servidor
- ✅ **Manutenibilidade:** Mudanças de URLs e keys não requerem atualização no Webflow
- ✅ **Segurança:** API keys não precisam ser configuradas no Webflow
- ✅ **Consistência:** Variáveis de ambiente já existem no PHP-FPM config

### Impacto em Performance ⭐ **NOVO**

**Impacto Esperado:** Mínimo ou nulo.

**Justificativa Técnica:**
- A adição de 8 variáveis ao `config_env.js.php` adiciona aproximadamente **~500 bytes** ao arquivo JavaScript gerado
- O arquivo `config_env.js.php` é carregado uma única vez e em cache pelo navegador
- A leitura de variáveis do `window` no JavaScript é uma operação síncrona e extremamente rápida (nanossegundos)
- A remoção de leitura de 8 `data-attributes` compensa parcialmente o overhead adicional

**Métricas Esperadas:**
- **Tamanho do `config_env.js.php`:** Aumento de ~500 bytes (de ~200 bytes para ~700 bytes)
- **Tempo de Carregamento:** Aumento marginal (< 5ms) devido ao tamanho adicional do arquivo
- **Tempo de Inicialização do JavaScript:** Redução marginal (< 2ms) devido à remoção de leitura de data-attributes
- **Uso de Memória:** Não deve haver aumento significativo (8 variáveis string no `window`)

**Plano de Monitoramento:**
- Após o deploy, monitorar o tempo de carregamento do `config_env.js.php` no navegador (aba Network no DevTools)
- Comparar tempo de carregamento antes/depois da mudança
- Verificar tamanho do arquivo gerado no servidor
- Monitorar tempo de inicialização do JavaScript (console.time/console.timeEnd)

**Conclusão:** O impacto em performance é **insignificante** e não deve ser perceptível pelo usuário final.

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO ⭐ **NOVO**

### Objetivo do Usuário

O usuário solicitou mover 8 parâmetros específicos que atualmente são passados via `data-attributes` no Webflow para serem lidos diretamente das variáveis de ambiente do PHP, **sem chamá-los pelo Webflow**. Os demais parâmetros permanecem como estão (sendo passados via Webflow).

### Parâmetros Solicitados para Mover

O usuário especificou explicitamente os seguintes 8 parâmetros a mover:

1. `data-apilayer-key` → `APILAYER_KEY`
2. `data-safety-ticket` → `SAFETY_TICKET`
3. `data-safety-api-key` → `SAFETY_API_KEY`
4. `data-viacep-base-url` → `VIACEP_BASE_URL`
5. `data-apilayer-base-url` → `APILAYER_BASE_URL`
6. `data-safetymails-optin-base` → `SAFETYMAILS_OPTIN_BASE`
7. `data-rpa-api-base-url` → `RPA_API_BASE_URL`
8. `data-safetymails-base-domain` → `SAFETYMAILS_BASE_DOMAIN`

### Contexto e Justificativa

**Por que mover esses parâmetros específicos:**
- **Redução de Complexidade no Webflow:** Reduzir de 17 para 9 parâmetros no script tag do Webflow facilita manutenção
- **Centralização de Configurações Sensíveis:** API keys e URLs de APIs ficam apenas no servidor, não precisam ser configuradas no Webflow
- **Segurança:** API keys não precisam ser expostas no código HTML do Webflow
- **Manutenibilidade:** Mudanças de URLs e keys não requerem atualização manual no Webflow
- **Consistência:** Variáveis de ambiente já existem no PHP-FPM config, apenas precisam ser expostas para JavaScript

**Por que manter os outros 9 parâmetros no Webflow:**
- `APP_BASE_URL` e `APP_ENVIRONMENT`: Podem variar entre ambientes e são mais fáceis de gerenciar via Webflow
- `rpaEnabled`, `USE_PHONE_API`, `VALIDAR_PH3A`: Flags de configuração que podem precisar ser alteradas rapidamente sem deploy
- `SUCCESS_PAGE_URL`, `WHATSAPP_*`: URLs e configurações específicas do frontend que fazem sentido estar no Webflow

### Expectativas do Usuário

1. **Redução de Complexidade:** Script tag no Webflow deve ter menos parâmetros (de 17 para 9)
2. **Funcionalidade Preservada:** Todas as funcionalidades existentes devem continuar funcionando normalmente
3. **Manutenibilidade:** Mudanças futuras de API keys e URLs devem ser feitas apenas no servidor (PHP-FPM config)
4. **Segurança:** API keys não devem mais aparecer no código HTML do Webflow
5. **Performance:** Não deve haver impacto negativo significativo na performance

### Critérios de Aceitação do Usuário

- [ ] Script tag no Webflow tem apenas 9 `data-attributes` (removidos os 8 parâmetros solicitados)
- [ ] `config_env.js.php` é carregado ANTES de `FooterCodeSiteDefinitivoCompleto.js` no Webflow
- [ ] Todas as funcionalidades continuam funcionando normalmente (validação CPF, telefone, SafetyMails, RPA)
- [ ] Não há erros no console do navegador
- [ ] API keys não aparecem mais no código HTML do Webflow (inspecionar elemento)
- [ ] Mudanças de API keys podem ser feitas apenas no servidor (PHP-FPM config), sem necessidade de atualizar Webflow
- [ ] Performance não degrada significativamente (tempo de carregamento mantido ou melhorado)

---

## 🎯 OBJETIVOS ESPECÍFICOS

### 1. Atualizar `config_env.js.php`

- Adicionar leitura das 8 variáveis de ambiente do PHP
- Expor como variáveis globais no `window`
- Implementar validação e erro se variáveis críticas não estiverem definidas
- Manter compatibilidade com variáveis existentes (`APP_BASE_URL`, `APP_ENVIRONMENT`)

### 2. Atualizar `FooterCodeSiteDefinitivoCompleto.js`

- Remover leitura de `data-attributes` para as 8 variáveis movidas
- Substituir por leitura direta das variáveis do `window` injetadas pelo PHP
- Manter leitura de `data-attributes` para as 9 variáveis que permanecem
- Implementar verificação de existência das variáveis do `window` (fail-fast)
- Atualizar mensagens de erro para refletir nova origem das variáveis

### 3. Atualizar Arquivos JavaScript Secundários

- Verificar `MODAL_WHATSAPP_DEFINITIVO.js` para uso das variáveis
- Verificar `webflow_injection_limpo.js` para uso das variáveis
- Atualizar se necessário para usar variáveis do `window` ao invés de data-attributes

### 4. Atualizar Documentação

- Atualizar `GUIA_ATUALIZACAO_WEBFLOW_SCRIPT_TAG_20251121.md` removendo os 8 parâmetros
- Criar guia de atualização do `config_env.js.php` no Webflow (se necessário)
- Documentar ordem de carregamento: `config_env.js.php` deve ser carregado ANTES de `FooterCodeSiteDefinitivoCompleto.js`

---

## 📊 ANÁLISE DETALHADA

### Variáveis de Ambiente (PHP-FPM Config)

**Status:** ✅ **JÁ DEFINIDAS**

Todas as 8 variáveis já estão definidas no `php-fpm_www_conf_DEV.txt`:

```ini
env[APILAYER_KEY] = dce92fa84152098a3b5b7b8db24debbc
env[SAFETY_TICKET] = 05bf2ec47128ca0b917f8b955bada1bd3cadd47e
env[SAFETY_API_KEY] = 20a7a1c297e39180bd80428ac13c363e882a531f
env[VIACEP_BASE_URL] = https://viacep.com.br
env[APILAYER_BASE_URL] = https://apilayer.net
env[SAFETYMAILS_OPTIN_BASE] = https://optin.safetymails.com
env[RPA_API_BASE_URL] = https://rpaimediatoseguros.com.br
env[SAFETYMAILS_BASE_DOMAIN] = safetymails.com
```

**Ação Necessária:** Nenhuma - variáveis já estão configuradas.

### Arquivos JavaScript Afetados

#### `FooterCodeSiteDefinitivoCompleto.js`

**Linhas Afetadas:** ~140-151

**Antes:**
```javascript
window.APILAYER_KEY = getRequiredDataAttribute(scriptElement, 'apilayerKey', 'APILAYER_KEY');
window.SAFETY_TICKET = getRequiredDataAttribute(scriptElement, 'safetyTicket', 'SAFETY_TICKET');
window.SAFETY_API_KEY = getRequiredDataAttribute(scriptElement, 'safetyApiKey', 'SAFETY_API_KEY');
window.VIACEP_BASE_URL = getRequiredDataAttribute(scriptElement, 'viacepBaseUrl', 'VIACEP_BASE_URL');
window.APILAYER_BASE_URL = getRequiredDataAttribute(scriptElement, 'apilayerBaseUrl', 'APILAYER_BASE_URL');
window.SAFETYMAILS_OPTIN_BASE = getRequiredDataAttribute(scriptElement, 'safetymailsOptinBase', 'SAFETYMAILS_OPTIN_BASE');
window.RPA_API_BASE_URL = getRequiredDataAttribute(scriptElement, 'rpaApiBaseUrl', 'RPA_API_BASE_URL');
window.SUCCESS_PAGE_URL = getRequiredDataAttribute(scriptElement, 'successPageUrl', 'SUCCESS_PAGE_URL');
```

**Depois:**
```javascript
// Variáveis injetadas pelo PHP (config_env.js.php)
window.APILAYER_KEY = window.APILAYER_KEY;
window.SAFETY_TICKET = window.SAFETY_TICKET;
window.SAFETY_API_KEY = window.SAFETY_API_KEY;
window.VIACEP_BASE_URL = window.VIACEP_BASE_URL;
window.APILAYER_BASE_URL = window.APILAYER_BASE_URL;
window.SAFETYMAILS_OPTIN_BASE = window.SAFETYMAILS_OPTIN_BASE;
window.RPA_API_BASE_URL = window.RPA_API_BASE_URL;
window.SAFETYMAILS_BASE_DOMAIN = window.SAFETYMAILS_BASE_DOMAIN;

// Validação fail-fast
if (!window.APILAYER_KEY) throw new Error('[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido. Carregue config_env.js.php antes deste script.');
if (!window.SAFETY_TICKET) throw new Error('[CONFIG] ERRO CRÍTICO: SAFETY_TICKET não está definido. Carregue config_env.js.php antes deste script.');
// ... (validações para todas as 8 variáveis)
```

**Nota:** `SUCCESS_PAGE_URL` permanece como data-attribute (não está na lista de parâmetros a mover).

#### `MODAL_WHATSAPP_DEFINITIVO.js`

**Verificação Necessária:** Verificar se usa `VIACEP_BASE_URL` ou outras variáveis movidas.

#### `webflow_injection_limpo.js`

**Verificação Necessária:** Verificar se usa variáveis movidas.

---

## 🔧 FASES DE IMPLEMENTAÇÃO

### FASE 1: Preparação e Análise ✅

**Objetivo:** Analisar código atual e confirmar escopo.

**Tarefas:**
- [x] Identificar todas as ocorrências dos 8 parâmetros no código JavaScript
- [x] Verificar se variáveis de ambiente já estão definidas no PHP-FPM config
- [x] Documentar ordem de carregamento necessária

**Resultado Esperado:** Documento de análise completo.

---

### FASE 2: Atualizar `config_env.js.php`

**Objetivo:** Adicionar exposição das 8 novas variáveis de ambiente para JavaScript.

**Tarefas:**
- [ ] Criar backup do arquivo `config_env.js.php`
- [ ] Adicionar leitura das 8 variáveis de ambiente:
  - `APILAYER_KEY`
  - `SAFETY_TICKET`
  - `SAFETY_API_KEY`
  - `VIACEP_BASE_URL`
  - `APILAYER_BASE_URL`
  - `SAFETYMAILS_OPTIN_BASE`
  - `RPA_API_BASE_URL`
  - `SAFETYMAILS_BASE_DOMAIN`
- [ ] Expor como variáveis globais no `window`
- [ ] Implementar validação fail-fast (lançar erro se variável crítica não estiver definida)
- [ ] Testar sintaxe PHP (`php -l`)

**Código Esperado:**
```php
<?php
header('Content-Type: application/javascript');

// Variáveis existentes
$base_url = $_ENV['APP_BASE_URL'] ?? '';
$environment = $_ENV['PHP_ENV'] ?? 'development';

// Novas variáveis
$apilayer_key = $_ENV['APILAYER_KEY'] ?? '';
$safety_ticket = $_ENV['SAFETY_TICKET'] ?? '';
$safety_api_key = $_ENV['SAFETY_API_KEY'] ?? '';
$viacep_base_url = $_ENV['VIACEP_BASE_URL'] ?? '';
$apilayer_base_url = $_ENV['APILAYER_BASE_URL'] ?? '';
$safetymails_optin_base = $_ENV['SAFETYMAILS_OPTIN_BASE'] ?? '';
$rpa_api_base_url = $_ENV['RPA_API_BASE_URL'] ?? '';
$safetymails_base_domain = $_ENV['SAFETYMAILS_BASE_DOMAIN'] ?? '';

// Validação fail-fast
if (empty($base_url)) {
    http_response_code(500);
    header('Content-Type: application/javascript');
    echo "console.error('[CONFIG] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');";
    echo "throw new Error('APP_BASE_URL não está definido');";
    exit;
}

// Validação para variáveis críticas (API keys)
$critical_vars = [
    'APILAYER_KEY' => $apilayer_key,
    'SAFETY_TICKET' => $safety_ticket,
    'SAFETY_API_KEY' => $safety_api_key
];

foreach ($critical_vars as $name => $value) {
    if (empty($value)) {
        http_response_code(500);
        header('Content-Type: application/javascript');
        echo "console.error('[CONFIG] ERRO CRÍTICO: {$name} não está definido nas variáveis de ambiente');";
        echo "throw new Error('{$name} não está definido');";
        exit;
    }
}

// Expor como variáveis globais
?>
window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;

// Novas variáveis expostas
window.APILAYER_KEY = <?php echo json_encode($apilayer_key, JSON_UNESCAPED_SLASHES); ?>;
window.SAFETY_TICKET = <?php echo json_encode($safety_ticket, JSON_UNESCAPED_SLASHES); ?>;
window.SAFETY_API_KEY = <?php echo json_encode($safety_api_key, JSON_UNESCAPED_SLASHES); ?>;
window.VIACEP_BASE_URL = <?php echo json_encode($viacep_base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APILAYER_BASE_URL = <?php echo json_encode($apilayer_base_url, JSON_UNESCAPED_SLASHES); ?>;
window.SAFETYMAILS_OPTIN_BASE = <?php echo json_encode($safetymails_optin_base, JSON_UNESCAPED_SLASHES); ?>;
window.RPA_API_BASE_URL = <?php echo json_encode($rpa_api_base_url, JSON_UNESCAPED_SLASHES); ?>;
window.SAFETYMAILS_BASE_DOMAIN = <?php echo json_encode($safetymails_base_domain, JSON_UNESCAPED_SLASHES); ?>;
```

**Tempo Estimado:** 1 hora

---

### FASE 3: Atualizar `FooterCodeSiteDefinitivoCompleto.js`

**Objetivo:** Remover leitura de data-attributes para as 8 variáveis movidas e usar variáveis do `window` injetadas pelo PHP.

**Tarefas:**
- [ ] Criar backup do arquivo `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Remover chamadas `getRequiredDataAttribute()` para as 8 variáveis movidas:
  - `apilayerKey`
  - `safetyTicket`
  - `safetyApiKey`
  - `viacepBaseUrl`
  - `apilayerBaseUrl`
  - `safetymailsOptinBase`
  - `rpaApiBaseUrl`
  - `safetymailsBaseDomain`
- [ ] Substituir por leitura direta das variáveis do `window`
- [ ] Adicionar validação fail-fast para garantir que variáveis foram injetadas pelo PHP
- [ ] Atualizar mensagens de erro para indicar necessidade de carregar `config_env.js.php`
- [ ] Manter leitura de data-attributes para as 9 variáveis que permanecem
- [ ] Testar sintaxe JavaScript

**Código Esperado:**
```javascript
// Variáveis injetadas pelo PHP (config_env.js.php) - OBRIGATÓRIAS
// Estas variáveis devem ser carregadas ANTES deste script via config_env.js.php
if (typeof window.APILAYER_KEY === 'undefined' || !window.APILAYER_KEY) {
    throw new Error('[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido. Carregue config_env.js.php ANTES deste script.');
}
if (typeof window.SAFETY_TICKET === 'undefined' || !window.SAFETY_TICKET) {
    throw new Error('[CONFIG] ERRO CRÍTICO: SAFETY_TICKET não está definido. Carregue config_env.js.php ANTES deste script.');
}
// ... (validações para todas as 8 variáveis)

// Atribuir variáveis do window (já validadas acima)
window.APILAYER_KEY = window.APILAYER_KEY;
window.SAFETY_TICKET = window.SAFETY_TICKET;
window.SAFETY_API_KEY = window.SAFETY_API_KEY;
window.VIACEP_BASE_URL = window.VIACEP_BASE_URL;
window.APILAYER_BASE_URL = window.APILAYER_BASE_URL;
window.SAFETYMAILS_OPTIN_BASE = window.SAFETYMAILS_OPTIN_BASE;
window.RPA_API_BASE_URL = window.RPA_API_BASE_URL;
window.SAFETYMAILS_BASE_DOMAIN = window.SAFETYMAILS_BASE_DOMAIN;

// Variáveis que permanecem via data-attributes (Webflow)
window.APP_BASE_URL = getRequiredDataAttribute(scriptElement, 'appBaseUrl', 'APP_BASE_URL');
window.APP_ENVIRONMENT = getRequiredDataAttribute(scriptElement, 'appEnvironment', 'APP_ENVIRONMENT');
window.rpaEnabled = getRequiredBooleanDataAttribute(scriptElement, 'rpaEnabled', 'rpaEnabled');
window.USE_PHONE_API = getRequiredBooleanDataAttribute(scriptElement, 'usePhoneApi', 'USE_PHONE_API');
window.VALIDAR_PH3A = getRequiredBooleanDataAttribute(scriptElement, 'validarPh3a', 'VALIDAR_PH3A');
window.SUCCESS_PAGE_URL = getRequiredDataAttribute(scriptElement, 'successPageUrl', 'SUCCESS_PAGE_URL');
window.WHATSAPP_API_BASE = getRequiredDataAttribute(scriptElement, 'whatsappApiBase', 'WHATSAPP_API_BASE');
window.WHATSAPP_PHONE = getRequiredDataAttribute(scriptElement, 'whatsappPhone', 'WHATSAPP_PHONE');
window.WHATSAPP_DEFAULT_MESSAGE = getRequiredDataAttribute(scriptElement, 'whatsappDefaultMessage', 'WHATSAPP_DEFAULT_MESSAGE');
```

**Tempo Estimado:** 2 horas

---

### FASE 4: Verificar e Atualizar Arquivos JavaScript Secundários

**Objetivo:** Verificar se `MODAL_WHATSAPP_DEFINITIVO.js` e `webflow_injection_limpo.js` usam as variáveis movidas e atualizar se necessário.

**Tarefas:**
- [ ] Verificar `MODAL_WHATSAPP_DEFINITIVO.js` para uso de variáveis movidas
- [ ] Verificar `webflow_injection_limpo.js` para uso de variáveis movidas
- [ ] Atualizar se necessário para usar variáveis do `window` ao invés de data-attributes
- [ ] Adicionar validação fail-fast se necessário
- [ ] Testar sintaxe JavaScript

**Tempo Estimado:** 1 hora

---

### FASE 5: Atualizar Documentação

**Objetivo:** Atualizar guias e documentação para refletir mudanças.

**Tarefas:**
- [ ] Atualizar `GUIA_ATUALIZACAO_WEBFLOW_SCRIPT_TAG_20251121.md`:
  - Remover os 8 parâmetros da lista de data-attributes
  - Adicionar instrução para carregar `config_env.js.php` ANTES de `FooterCodeSiteDefinitivoCompleto.js`
  - Atualizar exemplo de script tag no Webflow
- [ ] Criar/atualizar guia de ordem de carregamento de scripts
- [ ] Documentar mudanças no changelog

**Tempo Estimado:** 1 hora

---

### FASE 6: Testes e Validação

**Objetivo:** Testar que todas as funcionalidades continuam funcionando.

#### 6.1. Testes Unitários ⭐ **NOVO**

**Tarefas:**
- [ ] **Teste Unitário 1: Validação de Variáveis no PHP (`config_env.js.php`)**
  - Criar script de teste que simula variáveis de ambiente ausentes
  - Verificar que erro é lançado corretamente quando variável crítica não está definida
  - Verificar que variáveis são expostas corretamente quando definidas
- [ ] **Teste Unitário 2: Validação de Variáveis no JavaScript (`FooterCodeSiteDefinitivoCompleto.js`)**
  - Criar teste isolado que verifica validação de variáveis do `window`
  - Verificar que erro é lançado quando variável não está disponível
  - Verificar que variáveis são atribuídas corretamente quando disponíveis
- [ ] **Teste Unitário 3: Função de Validação de Data Attributes**
  - Testar função `getRequiredDataAttribute()` isoladamente
  - Verificar comportamento com atributos presentes e ausentes
  - Verificar mensagens de erro

**Tempo Estimado:** 0.5 horas

#### 6.2. Testes de Integração

**Tarefas:**
- [ ] Testar carregamento de `config_env.js.php` no navegador
- [ ] Verificar que todas as 8 variáveis estão disponíveis no `window`
- [ ] Testar carregamento de `FooterCodeSiteDefinitivoCompleto.js` após `config_env.js.php`
- [ ] Verificar que não há erros no console
- [ ] Verificar ordem de carregamento (inspecionar Network tab no DevTools)

**Tempo Estimado:** 0.5 horas

#### 6.3. Testes de Sistema

**Tarefas:**
- [ ] Testar funcionalidades que usam as variáveis movidas:
  - Validação de CPF (usa `VIACEP_BASE_URL`)
  - Validação de telefone (usa `APILAYER_KEY`, `APILAYER_BASE_URL`)
  - SafetyMails (usa `SAFETY_TICKET`, `SAFETY_API_KEY`, `SAFETYMAILS_OPTIN_BASE`, `SAFETYMAILS_BASE_DOMAIN`)
  - RPA (usa `RPA_API_BASE_URL`)
- [ ] Verificar que funcionalidades que usam variáveis mantidas no Webflow continuam funcionando

**Tempo Estimado:** 0.5 horas

#### 6.4. Testes de Casos Extremos ⭐ **NOVO**

**Tarefas:**
- [ ] **Caso Extremo 1: Variável Não Definida no PHP**
  - Remover temporariamente uma variável crítica do PHP-FPM config
  - Verificar que `config_env.js.php` lança erro JavaScript
  - Restaurar variável
- [ ] **Caso Extremo 2: `config_env.js.php` Não Carregado**
  - Carregar `FooterCodeSiteDefinitivoCompleto.js` sem carregar `config_env.js.php` antes
  - Verificar que erro é lançado indicando necessidade de carregar `config_env.js.php`
- [ ] **Caso Extremo 3: Ordem de Carregamento Incorreta**
  - Carregar `FooterCodeSiteDefinitivoCompleto.js` antes de `config_env.js.php`
  - Verificar que erro é lançado
- [ ] **Caso Extremo 4: Variável com Valor Vazio**
  - Definir variável de ambiente com valor vazio
  - Verificar que validação fail-fast funciona corretamente

**Tempo Estimado:** 0.5 horas

**Tempo Total Estimado:** 2 horas

---

### FASE 7: Deploy para Servidor DEV

**Objetivo:** Fazer deploy das alterações para o servidor de desenvolvimento.

**Tarefas:**
- [ ] Criar backups no servidor DEV
- [ ] Copiar `config_env.js.php` atualizado para servidor DEV
- [ ] Copiar `FooterCodeSiteDefinitivoCompleto.js` atualizado para servidor DEV
- [ ] Copiar arquivos JavaScript secundários atualizados (se houver)
- [ ] Verificar hash SHA256 após cópia
- [ ] Verificar sintaxe PHP e JavaScript no servidor
- [ ] Testar funcionalidades no servidor DEV

**Tempo Estimado:** 1 hora

---

### FASE 8: Atualizar Webflow

**Objetivo:** Atualizar script tags no Webflow para remover os 8 parâmetros e adicionar carregamento de `config_env.js.php`.

**Tarefas:**
- [ ] Atualizar script tag no Webflow DEV:
  - Remover os 8 `data-attributes` movidos
  - Adicionar `<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>` ANTES de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Publicar alterações no Webflow DEV
- [ ] Testar no navegador após publicação
- [ ] Verificar console do navegador para erros
- [ ] Documentar processo para atualização em PROD (quando aplicável)

**Tempo Estimado:** 1 hora

---

## ⏱️ ESTIMATIVA DE TEMPO TOTAL

| Fase | Tempo Estimado | Buffer | Tempo Total |
|------|----------------|--------|-------------|
| FASE 1: Preparação | 0.5h | 0.1h | 0.6h |
| FASE 2: config_env.js.php | 1h | 0.2h | 1.2h |
| FASE 3: FooterCodeSiteDefinitivoCompleto.js | 2h | 0.4h | 2.4h |
| FASE 4: Arquivos Secundários | 1h | 0.2h | 1.2h |
| FASE 5: Documentação | 1h | 0.2h | 1.2h |
| FASE 6: Testes (inclui unitários) | 2h | 0.4h | 2.4h |
| FASE 7: Deploy DEV | 1h | 0.2h | 1.2h |
| FASE 8: Atualizar Webflow | 1h | 0.2h | 1.2h |
| **TOTAL** | **9.5h** | **2h** | **11.5h** |

**Nota:** Tempo total mantido, mas FASE 6 agora inclui testes unitários detalhados.

**Tempo Total com Buffer:** ~12 horas

---

## 👥 RECURSOS HUMANOS

### Equipe Necessária

- **Desenvolvedor(a) Full-Stack (PHP/JavaScript):** Responsável pela implementação das fases 2-4, testes e deploy.
- **Administrador(a) de Sistema (DevOps):** Suporte durante deploy (se necessário).

### Competências Técnicas

- **Obrigatórias:**
  - Conhecimento avançado em PHP e JavaScript
  - Experiência com variáveis de ambiente e PHP-FPM
  - Familiaridade com Webflow (atualização de script tags)
  - Habilidade em depuração de aplicações web

### Disponibilidade

- **Desenvolvedor(a):** Disponibilidade para 12 horas de trabalho (com buffer).
- **Administrador(a) de Sistema:** Disponibilidade sob demanda durante FASE 7.

### Treinamento Necessário ⭐ **NOVO**

- **Revisão do Projeto:** Equipe deve revisar este documento para entender:
  - Quais parâmetros estão sendo movidos e por quê
  - Ordem de carregamento obrigatória (`config_env.js.php` antes de `FooterCodeSiteDefinitivoCompleto.js`)
  - Processo de atualização do Webflow
- **Familiarização com Webflow:** Se necessário, treinamento sobre como atualizar script tags no Webflow Designer
- **Processo de Deploy:** Revisão do processo de deploy para servidor DEV (FASE 7)

---

## ⚠️ RISCOS E MITIGAÇÕES

### Risco 1: Ordem de Carregamento Incorreta

**Descrição:** Se `config_env.js.php` não for carregado antes de `FooterCodeSiteDefinitivoCompleto.js`, as variáveis não estarão disponíveis.

**Probabilidade:** Média  
**Impacto:** Alto  
**Mitigação:**
- Documentar claramente ordem de carregamento
- Implementar validação fail-fast no JavaScript
- Mensagens de erro claras indicando necessidade de carregar `config_env.js.php` primeiro

### Risco 2: Variáveis de Ambiente Não Definidas

**Descrição:** Se variáveis não estiverem definidas no PHP-FPM config, o sistema falhará.

**Probabilidade:** Baixa (variáveis já estão definidas)  
**Impacto:** Alto  
**Mitigação:**
- Verificar que variáveis já estão no PHP-FPM config antes de iniciar
- Implementar validação fail-fast no PHP (`config_env.js.php`)
- Testar cenário de erro durante FASE 6

### Risco 3: Quebra de Funcionalidades Existentes

**Descrição:** Mudança pode quebrar funcionalidades que dependem das variáveis.

**Probabilidade:** Média  
**Impacto:** Alto  
**Mitigação:**
- Testes completos na FASE 6
- Deploy apenas em DEV primeiro
- Manter backups de todos os arquivos modificados
- Plano de rollback documentado

### Risco 4: Cache do Cloudflare

**Descrição:** Cache pode servir versão antiga do `config_env.js.php`.

**Probabilidade:** Média  
**Impacto:** Médio  
**Mitigação:**
- Limpar cache do Cloudflare após deploy
- Adicionar versão/query string ao `config_env.js.php` se necessário
- Documentar necessidade de limpar cache

---

## 📋 PLANO DE ROLLBACK

### Condições para Rollback

- Erros críticos no console do navegador após deploy
- Funcionalidades quebradas (validação CPF, telefone, etc.)
- Variáveis não disponíveis no `window`

### Processo de Rollback

1. **Restaurar arquivos do backup:**
   - `config_env.js.php` → Restaurar versão anterior
   - `FooterCodeSiteDefinitivoCompleto.js` → Restaurar versão anterior
   - Arquivos JavaScript secundários → Restaurar versões anteriores

2. **Restaurar script tag no Webflow:**
   - Adicionar de volta os 8 `data-attributes` removidos
   - Remover carregamento de `config_env.js.php`

3. **Limpar cache do Cloudflare**

4. **Testar funcionalidades**

5. **Documentar motivo do rollback**

---

## ✅ CRITÉRIOS DE ACEITAÇÃO

- [ ] Todas as 8 variáveis estão disponíveis no `window` após carregar `config_env.js.php`
- [ ] `FooterCodeSiteDefinitivoCompleto.js` não lê mais os 8 parâmetros via data-attributes
- [ ] `FooterCodeSiteDefinitivoCompleto.js` usa variáveis do `window` injetadas pelo PHP
- [ ] Script tag no Webflow tem apenas 9 `data-attributes` (removidos os 8)
- [ ] `config_env.js.php` é carregado ANTES de `FooterCodeSiteDefinitivoCompleto.js` no Webflow
- [ ] Todas as funcionalidades continuam funcionando (validação CPF, telefone, SafetyMails, RPA)
- [ ] Não há erros no console do navegador
- [ ] Mensagens de erro são claras quando variáveis não estão disponíveis
- [ ] Documentação atualizada

---

## 📝 NOTAS TÉCNICAS

### Ordem de Carregamento no Webflow

**Ordem Correta:**
```html
<!-- 1. Carregar variáveis de ambiente do PHP -->
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>

<!-- 2. Carregar script principal (usa variáveis do window) -->
<script 
    src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    data-app-base-url="https://dev.bssegurosimediato.com.br"
    data-app-environment="development"
    data-rpa-enabled="false"
    data-use-phone-api="true"
    data-validar-ph3a="false"
    data-success-page-url="https://www.segurosimediato.com.br/sucesso"
    data-whatsapp-api-base="https://api.whatsapp.com"
    data-whatsapp-phone="551141718837"
    data-whatsapp-default-message="Ola.%20Quero%20fazer%20uma%20cotacao%20de%20seguro."
></script>
```

**Ordem Incorreta (causará erros):**
```html
<!-- ERRADO: FooterCodeSiteDefinitivoCompleto.js carregado antes de config_env.js.php -->
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"></script>
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
```

### Variáveis Movidas vs. Mantidas

**Movidas para PHP (8):**
- `APILAYER_KEY`
- `SAFETY_TICKET`
- `SAFETY_API_KEY`
- `VIACEP_BASE_URL`
- `APILAYER_BASE_URL`
- `SAFETYMAILS_OPTIN_BASE`
- `RPA_API_BASE_URL`
- `SAFETYMAILS_BASE_DOMAIN`

**Mantidas no Webflow (9):**
- `APP_BASE_URL`
- `APP_ENVIRONMENT`
- `rpaEnabled`
- `USE_PHONE_API`
- `VALIDAR_PH3A`
- `SUCCESS_PAGE_URL`
- `WHATSAPP_API_BASE`
- `WHATSAPP_PHONE`
- `WHATSAPP_DEFAULT_MESSAGE`

---

## 📚 REFERÊNCIAS

- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PROJETO_ELIMINAR_VARIAVEIS_HARDCODE_20251118.md` - Projeto anterior de eliminação de hardcoded
- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/GUIA_ATUALIZACAO_WEBFLOW_SCRIPT_TAG_20251121.md` - Guia atual de atualização do Webflow
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config_env.js.php` - Arquivo atual que expõe variáveis PHP para JavaScript
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js` - Script principal afetado

---

---

## 📝 NOTAS SOBRE PARALELIZAÇÃO ⭐ **NOVO**

### Atividades que Podem Ser Paralelizadas

Para reduzir tempo total de implementação, as seguintes atividades podem ser executadas em paralelo:

1. **FASE 4 (Arquivos Secundários) e FASE 5 (Documentação):**
   - Verificação de arquivos JavaScript secundários pode ser feita em paralelo com atualização de documentação
   - **Economia estimada:** ~0.5 horas

2. **Alguns Testes da FASE 6:**
   - Testes unitários podem ser executados em paralelo com preparação de ambiente de testes
   - **Economia estimada:** ~0.2 horas

**Nota:** Paralelização é opcional e não afeta a qualidade do projeto. O cronograma sequencial é seguro e recomendado para primeira execução.

---

**Próximo Passo:** Aguardar autorização para iniciar implementação.

