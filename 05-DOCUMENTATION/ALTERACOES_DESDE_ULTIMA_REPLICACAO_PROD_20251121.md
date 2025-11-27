# 📋 ALTERAÇÕES DESDE A ÚLTIMA REPLICAÇÃO PARA PRODUÇÃO

**Data de Criação:** 21/11/2025  
**Última Atualização:** 27/11/2025 (Variável Global Versão)  
**Período:** 16/11/2025 até 27/11/2025  
**Última Replicação PROD:** 16/11/2025  
**Status:** ⏳ **ALTERAÇÕES PENDENTES DE REPLICAÇÃO** (exceto FooterCodeSiteDefinitivoCompleto.js - correção GCLID já deployado em PROD)

---

## 🎯 OBJETIVO

Este documento consolida **TODAS** as alterações realizadas no ambiente de desenvolvimento (DEV) desde a última replicação para produção (16/11/2025), organizadas por categoria para facilitar a replicação em PROD.

---

## 📊 RESUMO EXECUTIVO

### **Estatísticas Gerais:**
- **Período:** 6 dias (16/11/2025 a 22/11/2025)
- **Projetos Implementados:** 5 projetos principais
- **Arquivos Modificados:** 15 arquivos de código (12 anteriores + 3 novos)
- **Configurações Alteradas:** PHP-FPM (variáveis de ambiente)
- **Alterações no Banco de Dados:** 1 alteração de schema
- **Variáveis de Ambiente Adicionadas:** 9 novas variáveis (8 anteriores + 1 nova: `OCTADESK_FROM`)
- **Variáveis de Ambiente Modificadas:** 4 variáveis AWS SES

---

## 📁 CATEGORIA 1: ALTERAÇÕES EM CÓDIGO PHP

### **1.1. Arquivos PHP Modificados**

#### **1.1.1. `config.php`**
- **Data:** 21/11/2025
- **Projeto:** Eliminação de Variáveis Hardcoded + Mover Parâmetros para PHP
- **Alterações:**
  - Removidos fallbacks hardcoded
  - Implementado fail-fast para variáveis críticas
  - Variáveis agora lidas exclusivamente de `$_ENV`
- **Status:** ✅ Deployado em DEV

#### **1.1.2. `config_env.js.php`**
- **Data:** 21/11/2025
- **Projeto:** Mover Parâmetros para Variáveis de Ambiente PHP
- **Alterações:**
  - Adicionadas 8 novas variáveis expostas ao JavaScript:
    - `APILAYER_KEY`
    - `SAFETY_TICKET`
    - `SAFETY_API_KEY`
    - `VIACEP_BASE_URL`
    - `APILAYER_BASE_URL`
    - `SAFETYMAILS_OPTIN_BASE`
    - `RPA_API_BASE_URL`
    - `SAFETYMAILS_BASE_DOMAIN`
  - Implementada validação fail-fast para API keys críticas
- **Status:** ✅ Implementado localmente, ⏳ Pendente deploy em DEV

#### **1.1.3. `cpf-validate.php`**
- **Data:** 21/11/2025
- **Projeto:** Eliminação de Variáveis Hardcoded
- **Alterações:**
  - Removidos fallbacks hardcoded
  - Variáveis lidas exclusivamente de `$_ENV`
- **Status:** ✅ Deployado em DEV

#### **1.1.4. `placa-validate.php`**
- **Data:** 21/11/2025
- **Projeto:** Eliminação de Variáveis Hardcoded
- **Alterações:**
  - Removidos fallbacks hardcoded
  - Variáveis lidas exclusivamente de `$_ENV`
- **Status:** ✅ Deployado em DEV

#### **1.1.5. `aws_ses_config.php`**
- **Data:** 21/11/2025
- **Projeto:** Eliminação de Variáveis Hardcoded
- **Alterações:**
  - Removidos fallbacks hardcoded
  - Variáveis lidas exclusivamente de `$_ENV`
- **Status:** ✅ Deployado em DEV

#### **1.1.6. `add_webflow_octa.php`**
- **Data:** 21/11/2025
- **Projeto:** Eliminação de Variáveis Hardcoded
- **Alterações:**
  - Removidos fallbacks hardcoded
  - Variáveis lidas exclusivamente de `$_ENV`
- **Status:** ✅ Deployado em DEV

#### **1.1.7. `send_admin_notification_ses.php`**
- **Data:** 21/11/2025
- **Projeto:** Correção de Timeout e Credenciais AWS SES
- **Alterações:**
  - Adicionado timeout HTTP ao cliente AWS SES:
    ```php
    'http' => [
        'timeout' => 10,
        'connect_timeout' => 5,
    ]
    ```
  - Adicionados logs detalhados de debug para erros AWS SES
  - Correção de loop infinito (prevenção de requisições HTTP para si mesmo)
- **Status:** ✅ Modificado em DEV (não documentado em projeto formal)

#### **1.1.8. `ProfessionalLogger.php`**
- **Data:** 21/11/2025
- **Projeto:** Adicionar 'TRACE' como Nível Válido
- **Alterações:**
  - Adicionado 'trace' ao array `$levels` em `LogConfig`:
    - `shouldLog()`
    - `shouldLogToDatabase()`
    - `shouldLogToConsole()`
    - `shouldLogToFile()`
  - Adicionada prevenção de loop infinito ao enviar emails de notificação
- **Status:** ✅ Implementado localmente, ⏳ Pendente deploy em DEV

#### **1.1.9. `log_endpoint.php`**
- **Data:** 21/11/2025
- **Projeto:** Adicionar 'TRACE' como Nível Válido
- **Alterações:**
  - Adicionado 'TRACE' à lista de níveis válidos (linha 267):
    ```php
    $validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE'];
    ```
- **Status:** ✅ Implementado localmente, ⏳ Pendente deploy em DEV

---

## 📁 CATEGORIA 2: ALTERAÇÕES EM CÓDIGO JAVASCRIPT

### **2.1. Arquivos JavaScript Modificados**

#### **2.1.1. `FooterCodeSiteDefinitivoCompleto.js`**
- **Data:** 21/11/2025 (primeira modificação)
- **Projetos:** 
  - Eliminação de Variáveis Hardcoded
  - Mover Parâmetros para Variáveis de Ambiente PHP
  - Adicionar 'TRACE' como Nível Válido
- **Alterações:**
  - Removidos fallbacks hardcoded
  - Removida leitura de 8 data-attributes (movidos para PHP):
    - `data-apilayer-key`
    - `data-safety-ticket`
    - `data-safety-api-key`
    - `data-viacep-base-url`
    - `data-apilayer-base-url`
    - `data-safetymails-optin-base`
    - `data-rpa-api-base-url`
    - `data-safetymails-base-domain`
  - Adicionada validação fail-fast para variáveis injetadas pelo PHP
  - Adicionado 'TRACE' à lista de níveis válidos (linha 414):
    ```javascript
    const validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE'];
    ```
- **Status:** ✅ Deployado em DEV

- **Data:** 23/11/2025 (segunda modificação - correções GCLID)
- **Projeto:** Correção de Captura e Preenchimento de GCLID
- **Alterações:**
  - Corrigida captura de GCLID da URL e salvamento em cookie
  - Corrigido preenchimento automático de campos `GCLID_FLD`
  - Adicionada função `executeGCLIDFill` com verificação de `document.readyState`
  - Adicionada função `fillGCLIDFields` com busca por ID e NAME
  - Adicionado `MutationObserver` para campos dinâmicos
  - Adicionado retry com intervalos de 1s e 3s
  - Adicionada validação final com log de confirmação
  - Melhorado tratamento de erros e logging
- **Status:** ✅ Deployado em DEV e ✅ **DEPLOYADO EM PROD** (23/11/2025)
- **Hash SHA256 PROD:** `A3CC0589CB085B78E28FB79314D4F965A597EAF5FD2C40D3B8846326621512A2`
- **Backup PROD:** `/var/www/html/prod/root/backups/deploy_footercode_20251123_130756/FooterCodeSiteDefinitivoCompleto.js`
- **Relatório:** `RELATORIO_DEPLOY_FOOTERCODE_PROD_GCLID_20251123.md`

- **Data:** 27/11/2025 (terceira modificação - correção inicialização Sentry)
- **Projeto:** Correção de Inicialização do Sentry - Remover Verificação getCurrentHub()
- **Alterações:**
  - Removida verificação de `Sentry.getCurrentHub()` que não existe no CDN bundle (linhas 824-842)
  - Simplificada verificação de inicialização usando apenas `window.SENTRY_INITIALIZED`
  - Mantido tratamento de erros existente
  - Mantidos logs existentes
- **Status:** ✅ Deployado em DEV
- **Hash SHA256 DEV:** `F450C73A89DDE03E3E43A883F3B0E05C380E7E12B7C25F44B07326E45A3F30AF`
- **Backup Local:** `02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js.backup_20251127_083912`
- **Documentação:** `PROJETO_CORRECAO_SENTRY_GETCURRENTHUB_20251126.md`
- **Auditoria:** `AUDITORIA_PROJETO_CORRECAO_SENTRY_GETCURRENTHUB_20251126.md`

- **Data:** 27/11/2025 (quarta modificação - simplificação e movimentação para início)
- **Projeto:** Simplificação e Movimentação do Sentry para Início do Arquivo
- **Alterações:**
  - **Removido:** Código antigo de inicialização do Sentry (linhas ~685-898)
  - **Adicionado:** Código simplificado no início do arquivo (após linha ~87)
  - Simplificada lógica de inicialização (função centralizada `initializeSentry()`)
  - Adicionados console.log indicando status do Sentry (carregado, inicializado, environment, timestamp)
  - Resolve race condition identificada
  - Código executa antes de qualquer outro código
  - **Código removido:**
    - Função `initSentryTracking()` completa (linhas ~685-898)
    - Verificações complexas desnecessárias
  - **Código adicionado:**
    - Função `initSentryTracking()` simplificada no início do arquivo
    - Função centralizada `initializeSentry()` que pode ser chamada de qualquer lugar
    - Console.log quando Sentry será carregado
    - Console.log quando Sentry foi carregado
    - Console.log quando Sentry foi inicializado com status completo
- **Status:** ✅ Deployado em DEV
- **Hash SHA256 DEV:** `1FA6FA90A81A80F30F4DD709A4DBE25441434279E64B94498B557E734F638D1B`
- **Backup Local:** `02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js.backup_20251127_091358`
- **Documentação:** `PROJETO_SIMPLIFICACAO_SENTRY_INICIO_20251127.md`

- **Data:** 27/11/2025 (quinta modificação - variável global versão)
- **Projeto:** Adicionar Variável Global de Versão e Log de Carregamento
- **Alterações:**
  - Adicionada variável global `window.versao = '1.7.0'` no início do arquivo (linha 87)
  - Implementado log automático de carregamento do arquivo usando `window.novo_log()`
  - Log inclui versão, timestamp e estado do DOM (`readyState`)
  - Log executado após definição de `window.novo_log()` para garantir disponibilidade
  - Tratamento de erro silencioso implementado
- **Status:** ✅ Deployado em DEV
- **Hash SHA256 DEV:** `F4D1B16EB36A7DAFD3D87A396FB544920907887D13D5DA71BD942CCF6BCAC81B`
- **Backup Local:** `02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js.backup_YYYYMMDD_HHMMSS`

#### **2.1.2. `MODAL_WHATSAPP_DEFINITIVO.js`**
- **Data:** 21/11/2025 (primeira modificação)
- **Projetos:**
  - Eliminação de Variáveis Hardcoded
  - Mover Parâmetros para Variáveis de Ambiente PHP
- **Alterações:**
  - Removidos fallbacks hardcoded
  - Atualizadas mensagens de erro para refletir que variáveis vêm de `config_env.js.php`
- **Status:** ✅ Deployado em DEV

- **Data:** 22/11/2025 (segunda modificação)
- **Projeto:** Eliminação dos Últimos Hardcodes Restantes
- **Alterações:**
  - Substituídos hardcodes `phone: '551132301422'` e `message: 'Olá! Quero uma cotação de seguro.'` por `window.WHATSAPP_PHONE` e `window.WHATSAPP_DEFAULT_MESSAGE`
  - Adicionada validação fail-fast no início do arquivo para garantir que variáveis globais estão disponíveis
- **Status:** ✅ Deployado em DEV

#### **2.1.3. `webflow_injection_limpo.js`**
- **Data:** 21/11/2025 (primeira modificação)
- **Projetos:**
  - Eliminação de Variáveis Hardcoded
  - Mover Parâmetros para Variáveis de Ambiente PHP
- **Alterações:**
  - Removidos fallbacks hardcoded
  - Atualizadas mensagens de erro para refletir que variáveis vêm de `config_env.js.php`
- **Status:** ✅ Deployado em DEV

- **Data:** 24/11/2025 (segunda modificação - correção mapeamento NOME)
- **Projeto:** Corrigir Mapeamento de Campo NOME → nome no RPA
- **Alterações:**
  - Adicionado mapeamento `'NOME': 'nome'` na função `applyFieldConversions()` (linha ~2684)
  - Garante compatibilidade com formulários Webflow que enviam `NOME` (maiúsculas)
  - Mantém compatibilidade retroativa com formulários que enviam `nome` (minúsculas)
  - Resolve erro "Undefined array key 'nome'" no backend PHP
- **Status:** ✅ Deployado em DEV
- **Hash SHA256 DEV:** `53CC20E91EC611260A9186DDAD7DD7BE8DE43685A3C37CAD7D55E47E727C1D14`
- **Backup Local:** `02-DEVELOPMENT/backups/webflow_injection_limpo.js.backup_20251124_151453`
- **Documentação:** `PROJETO_CORRIGIR_MAPEAMENTO_NOME_RPA_20251124.md`

---

## 📁 CATEGORIA 3: ALTERAÇÕES EM CONFIGURAÇÕES (PHP-FPM)

### **3.1. Variáveis de Ambiente Adicionadas**

#### **3.1.1. Variáveis AWS SES (Modificadas)**
- **Data:** 21/11/2025
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Alterações:**
  - `env[AWS_ACCESS_KEY_ID]`: `AKIAIOSFODNN7EXAMPLE` → `[AWS_ACCESS_KEY_ID_DEV]`
  - `env[AWS_SECRET_ACCESS_KEY]`: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` → `[AWS_SECRET_ACCESS_KEY_DEV]`
  - `env[AWS_REGION]`: `us-east-1` → `sa-east-1`
  - `env[AWS_SES_FROM_EMAIL]`: `noreply@bssegurosimediato.com.br` → `noreply@bpsegurosimediato.com.br` (revertido)
- **Status:** ✅ Configurado em DEV

#### **3.1.2. Variáveis Novas (Adicionadas para Projeto Mover Parâmetros)**
- **Data:** 21/11/2025
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Variáveis Adicionadas:**
  - `env[APILAYER_KEY] = "dce92fa84152098a3b5b7b8db24debbc"`
  - `env[SAFETY_TICKET] = "05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`
  - `env[SAFETY_API_KEY] = "20a7a1c297e39180bd80428ac13c363e882a531f"`
  - `env[VIACEP_BASE_URL] = "https://viacep.com.br"`
  - `env[APILAYER_BASE_URL] = "https://apilayer.net"`
  - `env[SAFETYMAILS_OPTIN_BASE] = "https://optin.safetymails.com"`
  - `env[RPA_API_BASE_URL] = "https://rpaimediatoseguros.com.br"`
  - `env[SAFETYMAILS_BASE_DOMAIN] = "safetymails.com"`
- **Status:** ⏳ Pendente adicionar ao PHP-FPM config em DEV

#### **3.1.3. Variável OCTADESK_FROM (Adicionada para Projeto Eliminar Últimos Hardcodes)**
- **Data:** 22/11/2025
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Variável Adicionada:**
  - `env[OCTADESK_FROM] = "+551132301422"`
- **Status:** ✅ Configurado em DEV

#### **3.1.4. Variáveis Booleanas (Corrigidas)**
- **Data:** 21/11/2025
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Correção:** Valores booleanos colocados entre aspas:
  - `env[RPA_ENABLED] = "false"`
  - `env[USE_PHONE_API] = "true"`
  - `env[VALIDAR_PH3A] = "false"`
- **Status:** ✅ Corrigido em DEV

---

## 📁 CATEGORIA 4: ALTERAÇÕES NO BANCO DE DADOS

### **4.1. Alteração de Schema**

#### **4.1.1. Adicionar 'TRACE' ao ENUM da coluna `level`**
- **Data:** 21/11/2025
- **Projeto:** Adicionar 'TRACE' ao ENUM do Banco de Dados
- **Ambiente:** DEV (`rpa_logs_dev`)
- **Tabelas Afetadas:**
  1. `application_logs` - Tabela principal
  2. `application_logs_archive` - Tabela de arquivo
  3. `log_statistics` - Tabela de estatísticas
- **Comando SQL Executado:**
  ```sql
  ALTER TABLE application_logs 
  MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';
  
  ALTER TABLE application_logs_archive 
  MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';
  
  ALTER TABLE log_statistics 
  MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL;
  ```
- **Script SQL:** `06-SERVER-CONFIG/alterar_enum_level_adicionar_trace_dev.sql`
- **Status:** ✅ Aplicado em DEV
- **Status PROD:** ⏳ Pendente replicação

---

## 📁 CATEGORIA 5: PROJETOS IMPLEMENTADOS

### **5.1. Projeto: Eliminação de Variáveis Hardcoded**
- **Data:** 18/11/2025 - 21/11/2025
- **Status:** ✅ Deployado em DEV (21/11/2025)
- **Arquivos Modificados:** 8 arquivos (5 PHP, 3 JavaScript)
- **Documentação:** `PROJETO_DEPLOY_ELIMINAR_HARDCODE_DEV_20251121.md`
- **Relatório:** `RELATORIO_DEPLOY_ELIMINAR_HARDCODE_DEV_20251121.md`

### **5.2. Projeto: Mover Parâmetros para Variáveis de Ambiente PHP**
- **Data:** 21/11/2025
- **Status:** ✅ Implementado localmente, ⏳ Pendente deploy em DEV
- **Arquivos Modificados:** 4 arquivos (1 PHP, 3 JavaScript)
- **Documentação:** `PROJETO_MOVER_PARAMETROS_PHP_ENV_20251121.md`
- **Relatório:** `RELATORIO_IMPLEMENTACAO_MOVER_PARAMETROS_PHP_ENV_20251121.md`

### **5.3. Projeto: Adicionar 'TRACE' como Nível Válido**
- **Data:** 21/11/2025
- **Status:** ✅ Implementado localmente, ⏳ Pendente deploy em DEV
- **Arquivos Modificados:** 2 arquivos (1 PHP, 1 JavaScript)
- **Documentação:** `PROJETO_ADICIONAR_TRACE_NIVEL_VALIDO_20251121.md`

### **5.4. Projeto: Adicionar 'TRACE' ao ENUM do Banco de Dados**
- **Data:** 21/11/2025
- **Status:** ✅ Aplicado em DEV
- **Scripts SQL:** 
  - DEV: `alterar_enum_level_adicionar_trace_dev.sql` ✅ Aplicado
  - PROD: `alterar_enum_level_adicionar_trace_prod.sql` ⏳ Pendente
- **Documentação:** `PROJETO_ADICIONAR_TRACE_ENUM_BANCO_DADOS_20251121.md`

---

## 📁 CATEGORIA 6: CORREÇÕES E AJUSTES

### **6.1. Correções AWS SES**
- **Data:** 21/11/2025
- **Problema:** Credenciais AWS inválidas, região incorreta, domínio não verificado
- **Correções:**
  1. Credenciais AWS atualizadas (novo usuário IAM `ses-email-sender-new`)
  2. Região alterada de `us-east-1` para `sa-east-1`
  3. Domínio revertido de `bssegurosimediato.com.br` para `bpsegurosimediato.com.br`
  4. Timeout HTTP adicionado ao cliente AWS SES
- **Status:** ✅ Corrigido em DEV

### **6.2. Correção de Loop Infinito no ProfessionalLogger**
- **Data:** 21/11/2025
- **Problema:** `ProfessionalLogger` fazia requisições HTTP para si mesmo ao enviar emails de notificação
- **Correção:** Adicionada verificação `isInsideEmailEndpoint()` para prevenir loop
- **Status:** ✅ Corrigido localmente, ⏳ Pendente deploy em DEV

---

## 📋 CHECKLIST DE REPLICAÇÃO PARA PROD

### **Arquivos de Código para Replicar:**

#### **PHP (8 arquivos):**
- [ ] `config.php`
- [ ] `config_env.js.php` ⚠️ **NOVO** - Adicionar 8 variáveis
- [ ] `cpf-validate.php`
- [ ] `placa-validate.php`
- [ ] `aws_ses_config.php`
- [ ] `add_webflow_octa.php`
- [ ] `send_admin_notification_ses.php` ⚠️ **MODIFICADO** - Timeout e logs
- [ ] `ProfessionalLogger.php` ⚠️ **MODIFICADO** - Suporte a TRACE
- [ ] `log_endpoint.php` ⚠️ **MODIFICADO** - Suporte a TRACE

#### **JavaScript (3 arquivos):**
- [ ] `FooterCodeSiteDefinitivoCompleto.js` ⚠️ **MODIFICADO** - Múltiplas alterações
- [ ] `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] `webflow_injection_limpo.js` ⚠️ **MODIFICADO** - Mapeamento NOME → nome (24/11/2025)

### **Configurações PHP-FPM para Replicar:**

#### **Variáveis AWS SES (Modificar):**
- [ ] `env[AWS_ACCESS_KEY_ID]` = `[AWS_ACCESS_KEY_ID_DEV]`
- [ ] `env[AWS_SECRET_ACCESS_KEY]` = `[AWS_SECRET_ACCESS_KEY_DEV]`
- [ ] `env[AWS_REGION]` = `sa-east-1`
- [ ] `env[AWS_SES_FROM_EMAIL]` = `noreply@bpsegurosimediato.com.br`

#### **Variáveis Novas (Adicionar):**
- [ ] `env[APILAYER_KEY]` = `"dce92fa84152098a3b5b7b8db24debbc"`
- [ ] `env[SAFETY_TICKET]` = `"05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`
- [ ] `env[SAFETY_API_KEY]` = `"20a7a1c297e39180bd80428ac13c363e882a531f"`
- [ ] `env[VIACEP_BASE_URL]` = `"https://viacep.com.br"`
- [ ] `env[APILAYER_BASE_URL]` = `"https://apilayer.net"`
- [ ] `env[SAFETYMAILS_OPTIN_BASE]` = `"https://optin.safetymails.com"`
- [ ] `env[RPA_API_BASE_URL]` = `"https://rpaimediatoseguros.com.br"`
- [ ] `env[SAFETYMAILS_BASE_DOMAIN]` = `"safetymails.com"`

#### **Variáveis Booleanas (Verificar):**
- [ ] `env[RPA_ENABLED]` = `"false"` (com aspas)
- [ ] `env[USE_PHONE_API]` = `"true"` (com aspas)
- [ ] `env[VALIDAR_PH3A]` = `"false"` (com aspas)

### **Banco de Dados para Replicar:**

#### **Script SQL:**
- [ ] Executar `alterar_enum_level_adicionar_trace_prod.sql` no banco `rpa_logs_prod`
- [ ] Verificar que 'TRACE' foi adicionado ao ENUM em todas as tabelas

### **Webflow para Atualizar:**

#### **Script Tag:**
- [ ] Adicionar `<script src="config_env.js.php"></script>` ANTES de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Remover 8 data-attributes movidos para PHP:
  - `data-apilayer-key`
  - `data-safety-ticket`
  - `data-safety-api-key`
  - `data-viacep-base-url`
  - `data-apilayer-base-url`
  - `data-safetymails-optin-base`
  - `data-rpa-api-base-url`
  - `data-safetymails-base-domain`
- [ ] Manter 9 data-attributes restantes

---

## 📊 RESUMO POR PRIORIDADE

### **🔴 CRÍTICO - Replicar Imediatamente:**
1. ✅ Alteração do ENUM no banco de dados (já aplicada em DEV)
2. ⚠️ Arquivos PHP com suporte a TRACE (`ProfessionalLogger.php`, `log_endpoint.php`)
3. ⚠️ Arquivos JavaScript com suporte a TRACE (`FooterCodeSiteDefinitivoCompleto.js`)

### **🟡 ALTO - Replicar Após Validação:**
1. ⚠️ Arquivos PHP com eliminação de hardcode (já deployados em DEV)
2. ⚠️ Arquivos JavaScript com eliminação de hardcode (já deployados em DEV)
3. ⚠️ Configurações AWS SES (já configuradas em DEV)

### **🟢 MÉDIO - Replicar Quando Conveniente:**
1. ⚠️ Projeto Mover Parâmetros para PHP (implementado localmente, não deployado em DEV)
2. ⚠️ Variáveis novas no PHP-FPM (não adicionadas em DEV ainda)

---

## 📝 NOTAS IMPORTANTES

### **Dependências:**
1. **Projeto Mover Parâmetros** depende de:
   - `config_env.js.php` atualizado
   - Variáveis adicionadas ao PHP-FPM config
   - Webflow atualizado com novo script tag

2. **Projeto TRACE** depende de:
   - Código PHP/JavaScript atualizado
   - Banco de dados atualizado (ENUM)

### **Ordem de Replicação Recomendada:**
1. Banco de dados (ENUM TRACE)
2. Arquivos PHP com suporte a TRACE
3. Arquivos JavaScript com suporte a TRACE
4. Arquivos PHP com eliminação de hardcode
5. Arquivos JavaScript com eliminação de hardcode
6. Configurações PHP-FPM (AWS SES)
7. Projeto Mover Parâmetros (após validação completa)

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- **Tracking de Alterações no Banco:** `TRACKING_ALTERACOES_BANCO_DADOS.md`
- **Histórico de Replicações:** `HISTORICO_REPLICACAO_PRODUCAO.md`
- **Processo de Tracking:** `PROCESSO_TRACKING_ALTERACOES_BANCO_DADOS.md`

---

**Última Atualização:** 24/11/2025  
**Próxima Revisão:** Após próxima replicação para PROD

