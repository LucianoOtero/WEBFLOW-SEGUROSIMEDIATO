# 📋 PROJETO: Deploy Completo para Produção - Todas as Alterações Pendentes

**Data de Criação:** 27/11/2025  
**Data de Atualização:** 27/11/2025 (Logs Enhanced Conversions)  
**Versão:** 1.4.1  
**Status:** 📋 **AGUARDANDO AUTORIZAÇÃO**  
**Auditoria:** ✅ **APROVADO COM RECOMENDAÇÕES** (27/11/2025) - Ver `AUDITORIA_PROJETO_DEPLOY_PRODUCAO_COMPLETO_20251127.md`  
**Ambiente:** 🔴 **PRODUÇÃO (PROD)** - `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)

---

## 🚨 AVISOS CRÍTICOS

### **⚠️ PROCEDIMENTO PARA PRODUÇÃO:**
- 🚨 **STATUS:** O procedimento para atualizar o ambiente de produção **será definido posteriormente**
- 🚨 **VALIDAÇÃO AUTOMÁTICA OBRIGATÓRIA:** Verificar arquivo `.env.production_access` antes de executar QUALQUER comando
- 🚨 **BLOQUEIO:** Não executar comandos ou modificações em produção até que procedimento seja oficialmente definido
- ⚠️ **EXCEÇÃO FUTURA:** Após definição oficial do procedimento, modificar produção apenas quando houver instrução **EXPLÍCITA** do usuário

### **⚠️ CACHE CLOUDFLARE:**
- 🚨 **OBRIGATÓRIO:** Após atualizar arquivos `.js` ou `.php` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare
- ⚠️ O Cloudflare pode manter versões antigas em cache, causando erros como uso de credenciais antigas, código desatualizado, etc.

---

## 📋 RESUMO EXECUTIVO

### **Objetivo:**
Realizar deploy completo e cuidadoso de todas as alterações pendentes do ambiente de desenvolvimento (DEV) para o ambiente de produção (PROD), garantindo integridade, rastreabilidade e reversibilidade.

### **Período de Alterações:**
- **Última Replicação PROD:** 16/11/2025
- **Período de Alterações:** 16/11/2025 até 27/11/2025
- **Duração:** 11 dias de alterações acumuladas

### **Estatísticas:**
- **Arquivos JavaScript Modificados:** 3 arquivos
  - `FooterCodeSiteDefinitivoCompleto.js`: ✅ Enhanced Conversions implementado + logs específicos
  - `MODAL_WHATSAPP_DEFINITIVO.js`: ✅ Enhanced Conversions implementado + logs específicos
  - `webflow_injection_limpo.js`: ✅ Sem alterações de Enhanced Conversions
- **Arquivos PHP Modificados:** 9 arquivos
- **Configurações PHP-FPM:** Variáveis de ambiente (AWS SES + novas variáveis)
- **Banco de Dados:** 1 alteração de schema (ENUM TRACE)
- **Projetos Implementados:** 6 projetos principais + Enhanced Conversions Google Ads
  - ✅ Formulário Webflow: Implementado + logs específicos
  - ✅ Modal WhatsApp: Implementado + logs específicos

### **Prioridades:**
- 🔴 **CRÍTICO:** Banco de dados (ENUM TRACE), Arquivos com suporte a TRACE, Integração Sentry
- 🟡 **ALTO:** Eliminação de hardcode, Correções AWS SES, Enhanced Conversions Google Ads
- 🟢 **MÉDIO:** Projeto Mover Parâmetros para PHP (quando validado)

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### **Objetivos do Usuário com o Projeto:**

1. **Sincronizar Ambiente de Produção com Desenvolvimento:**
   - ✅ Replicar todas as alterações acumuladas em DEV para PROD
   - ✅ Garantir que produção tenha as mesmas funcionalidades e correções de desenvolvimento
   - ✅ Manter consistência entre ambientes DEV e PROD

2. **Garantir Integridade e Rastreabilidade:**
   - ✅ Realizar deploy com verificação de integridade (hash SHA256)
   - ✅ Manter rastreabilidade completa de todas as alterações
   - ✅ Garantir que arquivos sejam copiados corretamente sem corrupção

3. **Garantir Reversibilidade:**
   - ✅ Criar backups completos antes de cada alteração crítica
   - ✅ Ter capacidade de reverter alterações se necessário
   - ✅ Manter plano de rollback documentado e testável

4. **Minimizar Risco de Downtime:**
   - ✅ Realizar deploy em fases sequenciais com validação após cada fase
   - ✅ Identificar e respeitar dependências entre alterações
   - ✅ Garantir que alterações não quebrem funcionalidades existentes

5. **Melhorar Rastreamento de Conversões:**
   - ✅ Implementar Enhanced Conversions do Google Ads com formato E.164 no formulário Webflow
   - ✅ Implementar Enhanced Conversions do Google Ads com formato E.164 no modal WhatsApp
   - ✅ Adicionar logs específicos de Enhanced Conversions para facilitar verificação no console
   - ✅ Melhorar correspondência de conversões no Google Ads
   - ✅ Simplificar eventos GTM (remover eventos desnecessários do formulário Webflow)
   - ✅ Manter compatibilidade com código existente

---

### **Funcionalidades Solicitadas pelo Usuário:**

1. **Deploy de Arquivos JavaScript:**
   - ✅ Deploy de `FooterCodeSiteDefinitivoCompleto.js` (Sentry, TRACE, hardcode)
   - ✅ Deploy de `MODAL_WHATSAPP_DEFINITIVO.js` (timeout, logs, Sentry, Enhanced Conversions)
   - ✅ Deploy de `webflow_injection_limpo.js` (mapeamento NOME → nome)

2. **Deploy de Arquivos PHP:**
   - ✅ Deploy de 9 arquivos PHP com eliminação de hardcode
   - ✅ Deploy de arquivos com suporte a nível TRACE
   - ✅ Deploy de correções AWS SES e integrações

3. **Atualização de Configurações:**
   - ✅ Atualizar variáveis de ambiente PHP-FPM (AWS SES, OCTADESK_FROM)
   - ✅ Adicionar novas variáveis (se projeto "Mover Parâmetros" for aplicado)
   - ✅ Verificar/corrigir variáveis booleanas

4. **Alteração de Schema do Banco de Dados:**
   - ✅ Adicionar 'TRACE' ao ENUM em 3 tabelas
   - ✅ Garantir que alteração seja aplicada antes dos arquivos que dependem dela

5. **Validação e Testes:**
   - ✅ Validação de integridade após cada deploy (hash SHA256)
   - ✅ Testes funcionais após todas as fases
   - ✅ Testes de performance e segurança
   - ✅ Validação específica de Enhanced Conversions

---

### **Requisitos Não-Funcionais:**

1. **Integridade:**
   - ✅ Verificação obrigatória de hash SHA256 antes e depois de cada cópia
   - ✅ Comparação de hashes DEV vs PROD para identificar arquivos que precisam ser atualizados
   - ✅ Validação de integridade após cada fase

2. **Segurança:**
   - ✅ Backups obrigatórios antes de cada alteração crítica
   - ✅ Validação de credenciais e variáveis de ambiente antes do deploy
   - ✅ Consideração de privacidade (telefone visível no dataLayer documentado)

3. **Rastreabilidade:**
   - ✅ Documentação completa de todas as alterações
   - ✅ Histórico de versões mantido
   - ✅ Tracking de alterações atualizado

4. **Reversibilidade:**
   - ✅ Plano de rollback completo documentado
   - ✅ Backups obrigatórios antes de cada fase crítica
   - ✅ Capacidade de reverter alterações individuais ou completas

5. **Conformidade:**
   - ✅ Seguir diretivas do `.cursorrules`
   - ✅ Respeitar procedimento de produção (quando definido)
   - ✅ Avisar sobre necessidade de limpar cache do Cloudflare

6. **Performance:**
   - ✅ Verificar que não há degradação de performance após deploy
   - ✅ Monitorar logs para verificar que não estão sendo gerados excessivamente
   - ✅ Validar que funcionalidades críticas mantêm performance esperada

---

### **Critérios de Aceitação do Usuário:**

1. **Critério 1: Integridade dos Arquivos**
   - ✅ Hash SHA256 de cada arquivo no servidor PROD coincide com hash do arquivo DEV local
   - ✅ Nenhum arquivo foi corrompido durante o processo de cópia
   - ✅ Todos os arquivos foram copiados corretamente

2. **Critério 2: Funcionalidades Funcionando**
   - ✅ Todas as funcionalidades existentes continuam funcionando após deploy
   - ✅ Novas funcionalidades (Sentry, Enhanced Conversions, TRACE) funcionam corretamente
   - ✅ Integrações (Octadesk, EspoCRM, AWS SES) funcionam corretamente

3. **Critério 3: Validações Bem-Sucedidas**
   - ✅ Validação de CPF funciona corretamente
   - ✅ Validação de placa funciona corretamente
   - ✅ Validação de email funciona corretamente

4. **Critério 4: Logging Funcionando**
   - ✅ Logging com nível TRACE funciona corretamente
   - ✅ Logs são salvos no banco de dados corretamente
   - ✅ Logs não estão sendo gerados excessivamente

5. **Critério 5: Sentry Funcionando**
   - ✅ Sentry inicializa corretamente em produção
   - ✅ Erros são capturados e enviados ao Sentry
   - ✅ Environment está correto (prod em PROD, dev em DEV)

6. **Critério 6: Enhanced Conversions Funcionando (Webflow + Modal)**
   - ✅ Objeto `user_data` está presente no dataLayer para `form_submit_valid` (Webflow)
   - ✅ Objeto `user_data` está presente no dataLayer para `whatsapp_modal_initial_contact` (Modal)
   - ✅ Telefone está no formato E.164 (+5511999999999) em ambos os eventos
   - ✅ Campos existentes foram mantidos para compatibilidade
   - ✅ Eventos GTM desnecessários removidos (`form_submit_invalid_proceed`, `form_submit_network_error_proceed`)

7. **Critério 7: Sem Quebra de Funcionalidades**
   - ✅ Nenhuma funcionalidade existente foi quebrada
   - ✅ Formulários continuam funcionando
   - ✅ Integrações continuam funcionando
   - ✅ Emails continuam sendo enviados

8. **Critério 8: Performance Mantida**
   - ✅ Não há degradação de performance após deploy
   - ✅ Tempo de resposta mantido
   - ✅ Logs não estão impactando performance

---

### **Restrições e Limitações Conhecidas:**

1. **Procedimento para Produção:**
   - 🚨 **STATUS:** O procedimento para atualizar o ambiente de produção **será definido posteriormente**
   - 🚨 **BLOQUEIO:** Não executar comandos ou modificações em produção até que procedimento seja oficialmente definido
   - ⚠️ **VALIDAÇÃO:** Verificar arquivo `.env.production_access` antes de executar QUALQUER comando

2. **Cache do Cloudflare:**
   - ⚠️ **LIMITAÇÃO:** Após atualizar arquivos `.js` ou `.php` no servidor, é necessário limpar o cache do Cloudflare
   - ⚠️ **IMPACTO:** Cloudflare pode manter versões antigas em cache, causando erros
   - ✅ **MITIGAÇÃO:** Avisar ao usuário sobre necessidade de limpar cache após cada deploy

3. **Alteração de Schema do Banco de Dados:**
   - ⚠️ **IRREVERSÍVEL:** Alteração de ENUM não pode ser revertida facilmente (requer backup e restore)
   - ⚠️ **CRÍTICO:** Deve ser aplicada ANTES dos arquivos que dependem dela
   - ✅ **MITIGAÇÃO:** Backup completo obrigatório antes de aplicar

4. **Dependências entre Alterações:**
   - ⚠️ **LIMITAÇÃO:** Ordem de deploy deve ser respeitada (banco de dados primeiro, depois arquivos)
   - ⚠️ **CRÍTICO:** Arquivos PHP/JavaScript que usam TRACE dependem do ENUM TRACE no banco
   - ✅ **MITIGAÇÃO:** Fases de implementação definidas com ordem correta

5. **Variáveis de Ambiente:**
   - ⚠️ **REQUISITO:** Todas as variáveis de ambiente devem estar configuradas em PROD antes do deploy
   - ⚠️ **CRÍTICO:** Arquivos PHP sem hardcode dependem de variáveis de ambiente
   - ✅ **MITIGAÇÃO:** Verificação obrigatória antes de cada deploy

6. **Enhanced Conversions - Privacidade:**
   - ⚠️ **LIMITAÇÃO:** Telefone completo será visível no `dataLayer` (console do navegador)
   - ✅ **MITIGAÇÃO:** Google Ads faz hash dos dados antes do processamento
   - ✅ **MITIGAÇÃO:** Dados mascarados mantidos para logs/visualização

---

### **Expectativas de Resultado:**

1. **Ambiente de Produção Atualizado:**
   - ✅ Todas as alterações de DEV replicadas em PROD
   - ✅ Ambiente PROD consistente com DEV
   - ✅ Funcionalidades e correções disponíveis em produção

2. **Rastreamento Melhorado:**
   - ✅ Enhanced Conversions funcionando e melhorando correspondência de conversões
   - ✅ Sentry funcionando e capturando erros em tempo real
   - ✅ Logging com nível TRACE funcionando

3. **Segurança e Integridade:**
   - ✅ Todos os arquivos deployados com integridade verificada
   - ✅ Backups completos criados antes de alterações críticas
   - ✅ Capacidade de rollback disponível se necessário

4. **Documentação Atualizada:**
   - ✅ Tracking de alterações atualizado
   - ✅ Histórico de replicações atualizado
   - ✅ Documentação de deploy completa

---

## 👥 STAKEHOLDERS

### **Stakeholders Identificados:**

1. **Usuário Final:**
   - **Impacto:** Alto
   - **Interesse:** Funcionalidades funcionando corretamente, melhor rastreamento de conversões
   - **Responsabilidades:** Aprovar projeto, validar resultados

2. **Equipe de Desenvolvimento:**
   - **Impacto:** Alto
   - **Interesse:** Deploy bem-sucedido, código funcionando em produção
   - **Responsabilidades:** Executar deploy, validar funcionamento, criar backups

3. **Infraestrutura/DevOps:**
   - **Impacto:** Médio
   - **Interesse:** Servidor estável, configurações corretas
   - **Responsabilidades:** Fornecer acesso ao servidor PROD, validar configurações PHP-FPM

4. **Administrador do Sistema:**
   - **Impacto:** Alto
   - **Interesse:** Sistema funcionando, backups criados, rollback disponível
   - **Responsabilidades:** Aprovar procedimento de produção, validar backups

5. **Equipe de Marketing:**
   - **Impacto:** Médio
   - **Interesse:** Enhanced Conversions funcionando, melhor rastreamento de conversões
   - **Responsabilidades:** Validar Enhanced Conversions no Google Ads

6. **Equipe de Qualidade/Testes:**
   - **Impacto:** Médio
   - **Interesse:** Funcionalidades testadas, qualidade mantida
   - **Responsabilidades:** Validar testes funcionais, performance e segurança

---

## 📁 CATEGORIA 1: ARQUIVOS JAVASCRIPT (.js)

### **1.1. `FooterCodeSiteDefinitivoCompleto.js`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: 23/11/2025 - correção GCLID)
- **Hash SHA256 DEV:** `1FA6FA90A81A80F30F4DD709A4DBE25441434279E64B94498B557E734F638D1B`
- **Hash SHA256 PROD:** `A3CC0589CB085B78E28FB79314D4F965A597EAF5FD2C40D3B8846326621512A2` (versão antiga)

#### **Alterações Pendentes para PROD:**

**1.1.1. Eliminação de Variáveis Hardcoded (21/11/2025):**
- Removidos fallbacks hardcoded
- Removida leitura de 8 data-attributes (movidos para PHP)
- Adicionada validação fail-fast para variáveis injetadas pelo PHP

**1.1.2. Adicionar 'TRACE' como Nível Válido (21/11/2025):**
- Adicionado 'TRACE' à lista de níveis válidos (linha ~414):
  ```javascript
  const validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE'];
  ```

**1.1.3. Correção de Inicialização do Sentry (27/11/2025):**
- Removida verificação de `Sentry.getCurrentHub()` que não existe no CDN bundle
- Simplificada verificação de inicialização usando apenas `window.SENTRY_INITIALIZED`

**1.1.4. Simplificação e Movimentação do Sentry para Início (27/11/2025):**
- **Removido:** Código antigo de inicialização do Sentry (linhas ~685-898)
- **Adicionado:** Código simplificado no início do arquivo (após linha ~87)
- Simplificada lógica de inicialização (função centralizada `initializeSentry()`)
- Adicionados console.log indicando status do Sentry (carregado, inicializado, environment, timestamp)
- Resolve race condition identificada
- Código executa antes de qualquer outro código

**1.1.5. Enhanced Conversions Google Ads - Formato E.164 + Simplificação de Eventos GTM (27/11/2025):**
- **Objetivo:** Implementar Enhanced Conversions no formulário Webflow e simplificar eventos GTM
- **Status:** ✅ **IMPLEMENTADO** (27/11/2025) - Logs específicos adicionados
- **Alterações no evento `form_submit_valid` (linhas ~3151-3197):**
  - Formatação de telefone para E.164 (+55...):
    - Combinar DDD + celular usando `window.onlyDigits($DDD.val() + $CEL.val())`
    - Validar tamanho (10-11 dígitos) antes de formatar
    - Adicionar prefixo "+55" para números válidos
    - Tratar números que já contêm código do país (12 dígitos começando com "55")
  - Adicionado objeto `user_data` ao evento GTM:
    ```javascript
    'user_data': {
        'phone_number': rawPhone, // E.164 formatado (+5511999999999)
        'email': emailValue || undefined // Email se disponível
    }
    ```
  - Mantidos campos existentes para compatibilidade:
    - `form_type`: 'cotacao_seguro' (mantido)
    - `validation_status`: 'valid' (mantido)
  - **Adicionados logs específicos de Enhanced Conversions (linhas ~3199-3212):**
    - Log de sucesso quando `user_data.phone_number` existe: `✅ Enhanced Conversions enviado`
    - Log de aviso quando ausente: `⚠️ Enhanced Conversions não enviado`
    - Usa `window.novo_log()` para logging centralizado
    - Mostra telefone E.164 formatado, email (se presente) e objeto `user_data` completo
    - **Código adicionado:**
      ```javascript
      // ✅ LOG ESPECÍFICO PARA ENHANCED CONVERSIONS
      if (gtmEventData.user_data && gtmEventData.user_data.phone_number) {
        window.novo_log('INFO', 'GTM', '✅ Enhanced Conversions enviado', {
          event: gtmEventData.event,
          phone_number: gtmEventData.user_data.phone_number,
          has_email: !!gtmEventData.user_data.email,
          user_data: gtmEventData.user_data
        }, 'OPERATION', 'MEDIUM');
      } else {
        window.novo_log('WARN', 'GTM', '⚠️ Enhanced Conversions não enviado', {
          event: gtmEventData.event,
          reason: 'user_data ausente ou phone_number não formatado',
          has_user_data: !!gtmEventData.user_data
        }, 'OPERATION', 'MEDIUM');
      }
      ```
- **Remoção de eventos GTM desnecessários:**
  - **Removido:** Evento `form_submit_invalid_proceed` (linhas ~3233-3241)
  - **Removido:** Evento `form_submit_network_error_proceed` (linhas ~3309-3317)
  - **Mantido:** Apenas `form_submit_valid` com Enhanced Conversions
- **Benefícios:**
  - Melhora correspondência de conversões no Google Ads
  - Alinhado com Enhanced Conversions (formato E.164 obrigatório)
  - Simplifica rastreamento (apenas conversões válidas)
  - Mantém compatibilidade com código existente
- **Considerações de Segurança:**
  - ⚠️ Telefone completo será visível no `dataLayer` (console do navegador)
  - ✅ Google Ads faz hash dos dados antes do processamento
  - ✅ Email incluído apenas se disponível e válido

#### **Impacto:**
- 🔴 **CRÍTICO:** Arquivo contém múltiplas correções críticas (Sentry, TRACE, hardcode)
- 🟡 **ALTO:** Enhanced Conversions melhora rastreamento de conversões no Google Ads
- ⚠️ **DEPENDÊNCIA:** Requer que `config_env.js.php` esteja atualizado em PROD (se projeto "Mover Parâmetros" for aplicado)

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Copiar arquivo de DEV local para PROD local
3. Verificar hash SHA256 antes de copiar para servidor
4. Copiar para servidor de produção
5. Verificar hash SHA256 após cópia
6. Limpar cache do Cloudflare
7. Validar funcionamento

---

### **1.2. `MODAL_WHATSAPP_DEFINITIVO.js`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**1.2.1. Eliminação de Variáveis Hardcoded (21/11/2025):**
- Removidos fallbacks hardcoded
- Atualizadas mensagens de erro para refletir que variáveis vêm de `config_env.js.php`

**1.2.2. Eliminação dos Últimos Hardcodes Restantes (22/11/2025):**
- Substituídos hardcodes `phone: '551132301422'` e `message: 'Olá! Quero uma cotação de seguro.'` por `window.WHATSAPP_PHONE` e `window.WHATSAPP_DEFAULT_MESSAGE`
- Adicionada validação fail-fast no início do arquivo

**1.2.3. Correções de Erro Intermitente + Integração Sentry (26/11/2025):**
- Aumentado timeout do AbortController de 30s para 60s na função `fetchWithRetry`
- Adicionados logs detalhados no `fetchWithRetry` (tipo de erro, tempo de execução, stack trace)
- Corrigida função `logEvent` para erros (não mostrar campos vazios incorretamente)
- Adicionada função `logErrorToSentry` para captura de erros no Sentry
- Integrado `logErrorToSentry` nos pontos críticos:
  - `fetchWithRetry` (quando todas as tentativas falham)
  - `enviarMensagemInicialOctadesk` (quando erro ocorre)
  - `atualizarLeadEspoCRM` (quando erro ocorre)

**1.2.4. Enhanced Conversions Google Ads - Formato E.164 (27/11/2025):**
- **Objetivo:** Implementar suporte a Enhanced Conversions do Google Ads com formato E.164
- **Status:** ✅ **IMPLEMENTADO** (27/11/2025) - Correção aplicada e logs específicos adicionados
- **Problemas Identificados (27/11/2025):**
  - ❌ Telefone não estava sendo formatado em E.164 (+55...)
  - ❌ Objeto `user_data` não estava presente no evento GTM
  - ❌ Função `registrarConversaoInicialGTM` apenas armazenava `phone_ddd` e `phone_number: '***'` (mascarado)
- **Correções Implementadas (27/11/2025):**
  - ✅ Formatação de telefone para E.164 implementada
  - ✅ Objeto `user_data` adicionado ao evento GTM
  - ✅ Logs específicos de Enhanced Conversions adicionados (confirmação de envio)
- **Alterações Necessárias na função `registrarConversaoInicialGTM` (linhas ~1653-1736):**
  - **1. Formatação de telefone para E.164 (+55...):**
    - Combinar DDD + celular usando `onlyDigits(ddd + celular)`
    - Validar tamanho (10-11 dígitos) antes de formatar
    - Adicionar prefixo "+55" para números válidos
    - Tratar números que já contêm código do país (12 dígitos começando com "55")
    - **Código a adicionar:**
      ```javascript
      // Formatar telefone para E.164 (+55...) para Enhanced Conversions
      var rawPhone = '';
      if (ddd && celular && typeof onlyDigits === 'function') {
        const combined = onlyDigits(ddd + celular);
        if (combined.length >= 10 && combined.length <= 11) {
          rawPhone = "+55" + combined;
        } else if (combined.length === 12 && combined.startsWith('55')) {
          rawPhone = "+" + combined;
        }
      }
      ```
  - **2. Adicionar objeto `user_data` ao `gtmEventData`:**
    - Adicionar objeto `user_data` com `phone_number` formatado em E.164
    - **Código a adicionar:**
      ```javascript
      // Construir objeto user_data para Enhanced Conversions
      const userData = {};
      if (rawPhone) {
        userData.phone_number = rawPhone;
      }
      
      // Adicionar user_data ao gtmEventData
      if (Object.keys(userData).length > 0) {
        gtmEventData.user_data = userData;
      }
      ```
  - **3. Adicionar logs específicos de Enhanced Conversions (linhas ~1752-1766):**
    - Log de sucesso quando `user_data.phone_number` existe: `ENHANCED_CONVERSIONS_ENVIADO`
    - Log de aviso quando ausente: `ENHANCED_CONVERSIONS_NAO_ENVIADO`
    - Usa `debugLog()` para formatação automática (emojis, timestamps, JSON)
    - Mostra telefone E.164 formatado, email (se presente) e objeto `user_data` completo
    - **Código adicionado:**
      ```javascript
      // ✅ LOG ESPECÍFICO PARA ENHANCED CONVERSIONS
      if (gtmEventData.user_data && gtmEventData.user_data.phone_number) {
        debugLog('GTM', 'ENHANCED_CONVERSIONS_ENVIADO', {
          event: gtmEventData.event,
          phone_number: gtmEventData.user_data.phone_number,
          has_email: !!gtmEventData.user_data.email,
          user_data: gtmEventData.user_data
        }, 'info');
      } else {
        debugLog('GTM', 'ENHANCED_CONVERSIONS_NAO_ENVIADO', {
          event: gtmEventData.event,
          reason: 'user_data ausente ou phone_number não formatado',
          has_user_data: !!gtmEventData.user_data
        }, 'warn');
      }
      ```
  - **4. Manter campos existentes para compatibilidade:**
    - `phone_ddd`: DDD separado (mantido)
    - `phone_number`: '***' (mantido para visualização/logs)
    - `has_phone`: boolean (mantido)
    - Todos os outros campos existentes (gclid, utm_*, page_url, etc.)
- **Estrutura Final do Evento GTM:**
  ```javascript
  {
    'event': 'whatsapp_modal_initial_contact',
    'form_type': 'whatsapp_modal',
    'contact_stage': 'initial',
    'phone_ddd': ddd || '',
    'phone_number': '***', // Mantido para compatibilidade
    'has_phone': !!celular,
    'gclid': gclid || '',
    // ... outros campos existentes ...
    'user_data': {  // ✅ NOVO: Objeto para Enhanced Conversions
      'phone_number': rawPhone // E.164 formatado (+5511999999999)
    }
  }
  ```
- **Benefícios:**
  - Melhora correspondência de conversões no Google Ads
  - Alinhado com Enhanced Conversions (formato E.164 obrigatório)
  - Mantém compatibilidade com código existente
  - Padronização com formulário Webflow (mesma estrutura `user_data`)
- **Considerações de Segurança:**
  - ⚠️ Telefone completo será visível no `dataLayer` (console do navegador)
  - ✅ Google Ads faz hash dos dados antes do processamento
  - ✅ Dados mascarados mantidos para logs/visualização (`phone_number: '***'`)
- **Status:** ✅ **IMPLEMENTADO** (27/11/2025) - Pronto para deploy

#### **Impacto:**
- 🟡 **ALTO:** Arquivo contém correções importantes (timeout, logs, Sentry)
- ✅ **IMPLEMENTADO:** Enhanced Conversions implementado corretamente com logs específicos
- 🟡 **ALTO:** Enhanced Conversions melhora rastreamento de conversões no Google Ads
- ⚠️ **DEPENDÊNCIA:** Requer que Sentry esteja inicializado (via `FooterCodeSiteDefinitivoCompleto.js`)
- ⚠️ **OBSERVAÇÃO:** Telefone completo será enviado ao dataLayer (visível no console)
- ✅ **LOGS ADICIONADOS:** Logs específicos facilitam verificação de Enhanced Conversions no console

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Copiar arquivo de DEV local para PROD local
3. Verificar hash SHA256 antes de copiar para servidor
4. Copiar para servidor de produção
5. Verificar hash SHA256 após cópia
6. Limpar cache do Cloudflare
7. Validar funcionamento

---

### **1.3. `webflow_injection_limpo.js`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** `53CC20E91EC611260A9186DDAD7DD7BE8DE43685A3C37CAD7D55E47E727C1D14`
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**1.3.1. Eliminação de Variáveis Hardcoded (21/11/2025):**
- Removidos fallbacks hardcoded
- Atualizadas mensagens de erro para refletir que variáveis vêm de `config_env.js.php`

**1.3.2. Correção Mapeamento NOME → nome (24/11/2025):**
- Adicionado mapeamento `'NOME': 'nome'` na função `applyFieldConversions()` (linha ~2684)
- Garante compatibilidade com formulários Webflow que enviam `NOME` (maiúsculas)
- Mantém compatibilidade retroativa com formulários que enviam `nome` (minúsculas)
- Resolve erro "Undefined array key 'nome'" no backend PHP

#### **Impacto:**
- 🟡 **ALTO:** Arquivo contém correção crítica de mapeamento de campo
- ⚠️ **DEPENDÊNCIA:** Requer que backend PHP esteja atualizado para processar corretamente

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Copiar arquivo de DEV local para PROD local
3. Verificar hash SHA256 antes de copiar para servidor
4. Copiar para servidor de produção
5. Verificar hash SHA256 após cópia
6. Limpar cache do Cloudflare
7. Validar funcionamento

---

## 📁 CATEGORIA 2: ARQUIVOS PHP (.php)

### **2.1. `config.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.1.1. Eliminação de Variáveis Hardcoded (21/11/2025):**
- Removidos fallbacks hardcoded
- Implementado fail-fast para variáveis críticas
- Variáveis agora lidas exclusivamente de `$_ENV`

#### **Impacto:**
- 🟡 **ALTO:** Arquivo crítico de configuração - requer que variáveis de ambiente estejam configuradas corretamente em PROD

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Verificar que todas as variáveis de ambiente necessárias estão configuradas em PROD
3. Copiar arquivo de DEV local para PROD local
4. Verificar hash SHA256 antes de copiar para servidor
5. Copiar para servidor de produção
6. Verificar hash SHA256 após cópia
7. Validar funcionamento (testar endpoints que dependem deste arquivo)

---

### **2.2. `config_env.js.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.2.1. Mover Parâmetros para Variáveis de Ambiente PHP (21/11/2025):**
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

#### **Impacto:**
- 🟡 **ALTO:** Arquivo crítico - requer que variáveis de ambiente estejam configuradas em PROD
- ⚠️ **DEPENDÊNCIA:** Requer que variáveis sejam adicionadas ao PHP-FPM config em PROD
- ⚠️ **DEPENDÊNCIA:** Requer que Webflow seja atualizado com novo script tag (se projeto "Mover Parâmetros" for aplicado)

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Verificar que todas as 8 novas variáveis estão configuradas no PHP-FPM config de PROD
3. Copiar arquivo de DEV local para PROD local
4. Verificar hash SHA256 antes de copiar para servidor
5. Copiar para servidor de produção
6. Verificar hash SHA256 após cópia
7. Validar funcionamento (verificar que variáveis são expostas corretamente)

---

### **2.3. `cpf-validate.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.3.1. Eliminação de Variáveis Hardcoded (21/11/2025):**
- Removidos fallbacks hardcoded
- Variáveis lidas exclusivamente de `$_ENV`

#### **Impacto:**
- 🟢 **MÉDIO:** Arquivo de validação - requer que variáveis de ambiente estejam configuradas

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Copiar arquivo de DEV local para PROD local
3. Verificar hash SHA256 antes de copiar para servidor
4. Copiar para servidor de produção
5. Verificar hash SHA256 após cópia
6. Validar funcionamento (testar validação de CPF)

---

### **2.4. `placa-validate.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.4.1. Eliminação de Variáveis Hardcoded (21/11/2025):**
- Removidos fallbacks hardcoded
- Variáveis lidas exclusivamente de `$_ENV`

#### **Impacto:**
- 🟢 **MÉDIO:** Arquivo de validação - requer que variáveis de ambiente estejam configuradas

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Copiar arquivo de DEV local para PROD local
3. Verificar hash SHA256 antes de copiar para servidor
4. Copiar para servidor de produção
5. Verificar hash SHA256 após cópia
6. Validar funcionamento (testar validação de placa)

---

### **2.5. `aws_ses_config.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.5.1. Eliminação de Variáveis Hardcoded (21/11/2025):**
- Removidos fallbacks hardcoded
- Variáveis lidas exclusivamente de `$_ENV`

#### **Impacto:**
- 🟡 **ALTO:** Arquivo crítico de configuração AWS SES - requer que credenciais AWS estejam configuradas corretamente em PROD

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Verificar que credenciais AWS estão configuradas corretamente em PROD (região `sa-east-1`, domínio correto)
3. Copiar arquivo de DEV local para PROD local
4. Verificar hash SHA256 antes de copiar para servidor
5. Copiar para servidor de produção
6. Verificar hash SHA256 após cópia
7. Validar funcionamento (testar envio de email)

---

### **2.6. `add_webflow_octa.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.6.1. Eliminação de Variáveis Hardcoded (21/11/2025):**
- Removidos fallbacks hardcoded
- Variáveis lidas exclusivamente de `$_ENV`

#### **Impacto:**
- 🟡 **ALTO:** Arquivo crítico de integração Octadesk - requer que variáveis de ambiente estejam configuradas

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Copiar arquivo de DEV local para PROD local
3. Verificar hash SHA256 antes de copiar para servidor
4. Copiar para servidor de produção
5. Verificar hash SHA256 após cópia
6. Validar funcionamento (testar integração Octadesk)

---

### **2.7. `send_admin_notification_ses.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.7.1. Correção de Timeout e Credenciais AWS SES (21/11/2025):**
- Adicionado timeout HTTP ao cliente AWS SES:
  ```php
  'http' => [
      'timeout' => 10,
      'connect_timeout' => 5,
  ]
  ```
- Adicionados logs detalhados de debug para erros AWS SES
- Correção de loop infinito (prevenção de requisições HTTP para si mesmo)

#### **Impacto:**
- 🟡 **ALTO:** Arquivo crítico de notificações - contém correções importantes de timeout e loop infinito

#### **Plano de Deploy:**
1. Criar backup do arquivo atual em PROD
2. Copiar arquivo de DEV local para PROD local
3. Verificar hash SHA256 antes de copiar para servidor
4. Copiar para servidor de produção
5. Verificar hash SHA256 após cópia
6. Validar funcionamento (testar envio de notificações)

---

### **2.8. `ProfessionalLogger.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.8.1. Adicionar 'TRACE' como Nível Válido (21/11/2025):**
- Adicionado 'trace' ao array `$levels` em `LogConfig`:
  - `shouldLog()`
  - `shouldLogToDatabase()`
  - `shouldLogToConsole()`
  - `shouldLogToFile()`
- Adicionada prevenção de loop infinito ao enviar emails de notificação

#### **Impacto:**
- 🔴 **CRÍTICO:** Arquivo crítico de logging - requer que banco de dados tenha ENUM TRACE atualizado
- ⚠️ **DEPENDÊNCIA:** Requer que banco de dados PROD tenha ENUM TRACE aplicado ANTES do deploy deste arquivo

#### **Plano de Deploy:**
1. **PRÉ-REQUISITO:** Verificar que banco de dados PROD tem ENUM TRACE aplicado
2. Criar backup do arquivo atual em PROD
3. Copiar arquivo de DEV local para PROD local
4. Verificar hash SHA256 antes de copiar para servidor
5. Copiar para servidor de produção
6. Verificar hash SHA256 após cópia
7. Validar funcionamento (testar logging com nível TRACE)

---

### **2.9. `log_endpoint.php`**

#### **Status Atual:**
- **DEV:** ✅ Deployado e funcionando
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Hash SHA256 DEV:** (será verificado durante validação)
- **Hash SHA256 PROD:** (será verificado durante validação)

#### **Alterações Pendentes para PROD:**

**2.9.1. Adicionar 'TRACE' como Nível Válido (21/11/2025):**
- Adicionado 'TRACE' à lista de níveis válidos (linha 267):
  ```php
  $validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE'];
  ```

#### **Impacto:**
- 🔴 **CRÍTICO:** Arquivo crítico de endpoint de logging - requer que banco de dados tenha ENUM TRACE atualizado
- ⚠️ **DEPENDÊNCIA:** Requer que banco de dados PROD tenha ENUM TRACE aplicado ANTES do deploy deste arquivo

#### **Plano de Deploy:**
1. **PRÉ-REQUISITO:** Verificar que banco de dados PROD tem ENUM TRACE aplicado
2. Criar backup do arquivo atual em PROD
3. Copiar arquivo de DEV local para PROD local
4. Verificar hash SHA256 antes de copiar para servidor
5. Copiar para servidor de produção
6. Verificar hash SHA256 após cópia
7. Validar funcionamento (testar endpoint com nível TRACE)

---

## 📁 CATEGORIA 3: CONFIGURAÇÕES PHP-FPM

### **3.1. Variáveis de Ambiente AWS SES (Modificar)**

#### **Status Atual:**
- **DEV:** ✅ Configurado
- **PROD:** ⚠️ Versão antiga (última atualização: antes de 21/11/2025)
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

#### **Alterações Pendentes para PROD:**

**3.1.1. Atualizar Credenciais AWS SES (21/11/2025):**
- `env[AWS_ACCESS_KEY_ID]`: Atualizar para credenciais de produção
- `env[AWS_SECRET_ACCESS_KEY]`: Atualizar para credenciais de produção
- `env[AWS_REGION]`: `us-east-1` → `sa-east-1`
- `env[AWS_SES_FROM_EMAIL]`: Verificar domínio correto (`noreply@bpsegurosimediato.com.br`)

#### **Impacto:**
- 🟡 **ALTO:** Configuração crítica de envio de emails - requer credenciais AWS válidas de produção

#### **Plano de Deploy:**
1. Criar backup do arquivo de configuração atual em PROD
2. Verificar credenciais AWS de produção
3. Atualizar variáveis de ambiente no arquivo `/etc/php/8.3/fpm/pool.d/www.conf`
4. Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
5. Validar funcionamento (testar envio de email)

---

### **3.2. Variáveis Novas (Adicionar - Projeto Mover Parâmetros)**

#### **Status Atual:**
- **DEV:** ⏳ Pendente adicionar ao PHP-FPM config
- **PROD:** ⚠️ Não configurado
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

#### **Alterações Pendentes para PROD:**

**3.2.1. Adicionar 8 Novas Variáveis (21/11/2025):**
- `env[APILAYER_KEY] = "dce92fa84152098a3b5b7b8db24debbc"`
- `env[SAFETY_TICKET] = "05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`
- `env[SAFETY_API_KEY] = "20a7a1c297e39180bd80428ac13c363e882a531f"`
- `env[VIACEP_BASE_URL] = "https://viacep.com.br"`
- `env[APILAYER_BASE_URL] = "https://apilayer.net"`
- `env[SAFETYMAILS_OPTIN_BASE] = "https://optin.safetymails.com"`
- `env[RPA_API_BASE_URL] = "https://rpaimediatoseguros.com.br"`
- `env[SAFETYMAILS_BASE_DOMAIN] = "safetymails.com"`

#### **Impacto:**
- 🟢 **MÉDIO:** Variáveis necessárias apenas se projeto "Mover Parâmetros" for aplicado
- ⚠️ **DEPENDÊNCIA:** Requer que `config_env.js.php` seja atualizado em PROD

#### **Plano de Deploy:**
1. **PRÉ-REQUISITO:** Decidir se projeto "Mover Parâmetros" será aplicado em PROD
2. Se SIM: Criar backup do arquivo de configuração atual em PROD
3. Adicionar 8 novas variáveis ao arquivo `/etc/php/8.3/fpm/pool.d/www.conf`
4. Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
5. Validar funcionamento (verificar que variáveis estão disponíveis via `$_ENV`)

---

### **3.3. Variável OCTADESK_FROM (Adicionar)**

#### **Status Atual:**
- **DEV:** ✅ Configurado
- **PROD:** ⚠️ Não configurado
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

#### **Alterações Pendentes para PROD:**

**3.3.1. Adicionar Variável OCTADESK_FROM (22/11/2025):**
- `env[OCTADESK_FROM] = "+551132301422"`

#### **Impacto:**
- 🟡 **ALTO:** Variável necessária para integração Octadesk funcionar corretamente

#### **Plano de Deploy:**
1. Criar backup do arquivo de configuração atual em PROD
2. Adicionar variável `env[OCTADESK_FROM] = "+551132301422"` ao arquivo `/etc/php/8.3/fpm/pool.d/www.conf`
3. Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
4. Validar funcionamento (testar integração Octadesk)

---

### **3.4. Variáveis Booleanas (Verificar)**

#### **Status Atual:**
- **DEV:** ✅ Corrigido (valores entre aspas)
- **PROD:** ⚠️ Verificar se valores estão entre aspas
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

#### **Alterações Pendentes para PROD:**

**3.4.1. Verificar Valores Booleanos (21/11/2025):**
- `env[RPA_ENABLED] = "false"` (com aspas)
- `env[USE_PHONE_API] = "true"` (com aspas)
- `env[VALIDAR_PH3A] = "false"` (com aspas)

#### **Impacto:**
- 🟢 **MÉDIO:** Correção de formatação - garante que valores booleanos sejam lidos corretamente

#### **Plano de Deploy:**
1. Verificar valores atuais em PROD
2. Se não estiverem entre aspas, corrigir
3. Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
4. Validar funcionamento

---

## 📁 CATEGORIA 4: BANCO DE DADOS

### **4.1. Alteração de Schema - Adicionar 'TRACE' ao ENUM**

#### **Status Atual:**
- **DEV:** ✅ Aplicado (21/11/2025)
- **PROD:** ⚠️ Pendente
- **Banco:** `rpa_logs_prod`
- **Tabelas Afetadas:**
  1. `application_logs` - Tabela principal
  2. `application_logs_archive` - Tabela de arquivo
  3. `log_statistics` - Tabela de estatísticas

#### **Alterações Pendentes para PROD:**

**4.1.1. Adicionar 'TRACE' ao ENUM da coluna `level` (21/11/2025):**
```sql
ALTER TABLE application_logs 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';

ALTER TABLE application_logs_archive 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL DEFAULT 'INFO';

ALTER TABLE log_statistics 
MODIFY COLUMN level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE') NOT NULL;
```

#### **Impacto:**
- 🔴 **CRÍTICO:** Alteração de schema - **DEVE SER APLICADA ANTES** de fazer deploy dos arquivos PHP/JavaScript que usam nível TRACE
- ⚠️ **IRREVERSÍVEL:** Alteração de ENUM não pode ser revertida facilmente (requer backup e restore)

#### **Plano de Deploy:**
1. **PRÉ-REQUISITO:** Criar backup completo do banco de dados PROD
2. Verificar que backup foi criado com sucesso
3. Executar script SQL no banco `rpa_logs_prod`
4. Verificar que 'TRACE' foi adicionado ao ENUM em todas as 3 tabelas
5. Validar funcionamento (testar inserção de log com nível TRACE)

---

## 📋 FASES DE IMPLEMENTAÇÃO

### **FASE 1: Preparação e Validação (OBRIGATÓRIA)**

**Objetivo:** Validar que todos os pré-requisitos estão atendidos antes de iniciar o deploy.

**Tarefas:**
1. ✅ Verificar arquivo `.env.production_access` (se existir)
2. ✅ Verificar que procedimento para produção foi definido oficialmente
3. ✅ Criar backup completo do servidor de produção (arquivos + banco de dados)
4. ✅ Verificar hashes SHA256 de todos os arquivos DEV vs PROD
5. ✅ Identificar arquivos que realmente precisam ser atualizados (hashes diferentes)
6. ✅ Documentar ordem de deploy recomendada
7. ✅ Validar que todas as dependências estão claras

**Checklist:**
- [ ] Backup completo do servidor PROD criado
- [ ] Backup completo do banco de dados PROD criado
- [ ] Hashes SHA256 de todos os arquivos DEV vs PROD comparados
- [ ] Lista de arquivos que precisam ser atualizados validada
- [ ] Ordem de deploy definida e documentada
- [ ] Todas as dependências identificadas

---

### **FASE 2: Banco de Dados (PRIMEIRA - CRÍTICA)**

**Objetivo:** Aplicar alteração de schema no banco de dados PROD antes de fazer deploy dos arquivos que dependem dela.

**Tarefas:**
1. ✅ Criar backup completo do banco de dados PROD
2. ✅ Verificar que backup foi criado com sucesso
3. ✅ Executar script SQL para adicionar 'TRACE' ao ENUM
4. ✅ Verificar que alteração foi aplicada corretamente em todas as 3 tabelas
5. ✅ Validar funcionamento (testar inserção de log com nível TRACE)

**Checklist:**
- [ ] Backup do banco de dados PROD criado
- [ ] Script SQL executado com sucesso
- [ ] ENUM TRACE verificado em `application_logs`
- [ ] ENUM TRACE verificado em `application_logs_archive`
- [ ] ENUM TRACE verificado em `log_statistics`
- [ ] Teste de inserção de log com nível TRACE bem-sucedido

---

### **FASE 3: Arquivos PHP com Suporte a TRACE (SEGUNDA - CRÍTICA)**

**Objetivo:** Fazer deploy dos arquivos PHP que dependem do ENUM TRACE no banco de dados.

**Arquivos:**
1. `ProfessionalLogger.php`
2. `log_endpoint.php`

**Tarefas (por arquivo):**
1. ✅ Criar backup do arquivo atual em PROD
2. ✅ Copiar arquivo de DEV local para PROD local
3. ✅ Verificar hash SHA256 antes de copiar para servidor
4. ✅ Copiar para servidor de produção
5. ✅ Verificar hash SHA256 após cópia
6. ✅ Validar funcionamento

**Checklist:**
- [ ] Backup de `ProfessionalLogger.php` criado em PROD
- [ ] `ProfessionalLogger.php` copiado de DEV local para PROD local
- [ ] Hash SHA256 de `ProfessionalLogger.php` verificado antes de copiar
- [ ] `ProfessionalLogger.php` copiado para servidor PROD
- [ ] Hash SHA256 de `ProfessionalLogger.php` verificado após cópia
- [ ] Backup de `log_endpoint.php` criado em PROD
- [ ] `log_endpoint.php` copiado de DEV local para PROD local
- [ ] Hash SHA256 de `log_endpoint.php` verificado antes de copiar
- [ ] `log_endpoint.php` copiado para servidor PROD
- [ ] Hash SHA256 de `log_endpoint.php` verificado após cópia
- [ ] Teste de logging com nível TRACE bem-sucedido

---

### **FASE 4: Arquivos JavaScript com Suporte a TRACE e Sentry (TERCEIRA - CRÍTICA)**

**Objetivo:** Fazer deploy dos arquivos JavaScript que dependem do ENUM TRACE e contêm integração Sentry.

**Arquivos:**
1. `FooterCodeSiteDefinitivoCompleto.js` (contém TRACE + Sentry + Enhanced Conversions Google Ads)
2. `MODAL_WHATSAPP_DEFINITIVO.js` (contém Sentry + Enhanced Conversions Google Ads)

**Tarefas (por arquivo):**
1. ✅ Criar backup do arquivo atual em PROD
2. ✅ Copiar arquivo de DEV local para PROD local
3. ✅ Verificar hash SHA256 antes de copiar para servidor
4. ✅ Copiar para servidor de produção
5. ✅ Verificar hash SHA256 após cópia
6. ✅ Limpar cache do Cloudflare
7. ✅ Validar funcionamento

**Checklist:**
- [ ] Backup de `FooterCodeSiteDefinitivoCompleto.js` criado em PROD
- [ ] `FooterCodeSiteDefinitivoCompleto.js` copiado de DEV local para PROD local
- [ ] Hash SHA256 de `FooterCodeSiteDefinitivoCompleto.js` verificado antes de copiar
- [ ] `FooterCodeSiteDefinitivoCompleto.js` copiado para servidor PROD
- [ ] Hash SHA256 de `FooterCodeSiteDefinitivoCompleto.js` verificado após cópia
- [ ] Cache do Cloudflare limpo
- [ ] Backup de `MODAL_WHATSAPP_DEFINITIVO.js` criado em PROD
- [ ] `MODAL_WHATSAPP_DEFINITIVO.js` copiado de DEV local para PROD local
- [ ] Hash SHA256 de `MODAL_WHATSAPP_DEFINITIVO.js` verificado antes de copiar
- [ ] `MODAL_WHATSAPP_DEFINITIVO.js` copiado para servidor PROD
- [ ] Hash SHA256 de `MODAL_WHATSAPP_DEFINITIVO.js` verificado após cópia
- [ ] Cache do Cloudflare limpo
- [ ] Teste de Sentry bem-sucedido (verificar console do navegador)
- [ ] Teste de logging com nível TRACE bem-sucedido
- [ ] Teste de Enhanced Conversions bem-sucedido (verificar objeto `user_data` no dataLayer)
- [ ] Verificar formato E.164 do telefone no dataLayer (+5511999999999)

---

### **FASE 5: Arquivos PHP com Eliminação de Hardcode (QUARTA - ALTA)**

**Objetivo:** Fazer deploy dos arquivos PHP que tiveram hardcode removido.

**Arquivos:**
1. `config.php`
2. `cpf-validate.php`
3. `placa-validate.php`
4. `aws_ses_config.php`
5. `add_webflow_octa.php`
6. `send_admin_notification_ses.php`

**Tarefas (por arquivo):**
1. ✅ Criar backup do arquivo atual em PROD
2. ✅ Verificar que variáveis de ambiente necessárias estão configuradas em PROD
3. ✅ Copiar arquivo de DEV local para PROD local
4. ✅ Verificar hash SHA256 antes de copiar para servidor
5. ✅ Copiar para servidor de produção
6. ✅ Verificar hash SHA256 após cópia
7. ✅ Validar funcionamento

**Checklist:**
- [ ] Backup de `config.php` criado em PROD
- [ ] Variáveis de ambiente necessárias para `config.php` verificadas em PROD
- [ ] `config.php` copiado de DEV local para PROD local
- [ ] Hash SHA256 de `config.php` verificado antes de copiar
- [ ] `config.php` copiado para servidor PROD
- [ ] Hash SHA256 de `config.php` verificado após cópia
- [ ] (Repetir para cada arquivo PHP restante)
- [ ] Testes de funcionamento bem-sucedidos

---

### **FASE 6: Arquivos JavaScript com Eliminação de Hardcode (QUINTA - ALTA)**

**Objetivo:** Fazer deploy dos arquivos JavaScript que tiveram hardcode removido.

**Arquivos:**
1. `webflow_injection_limpo.js` (contém correção de mapeamento NOME → nome)

**Tarefas:**
1. ✅ Criar backup do arquivo atual em PROD
2. ✅ Copiar arquivo de DEV local para PROD local
3. ✅ Verificar hash SHA256 antes de copiar para servidor
4. ✅ Copiar para servidor de produção
5. ✅ Verificar hash SHA256 após cópia
6. ✅ Limpar cache do Cloudflare
7. ✅ Validar funcionamento

**Checklist:**
- [ ] Backup de `webflow_injection_limpo.js` criado em PROD
- [ ] `webflow_injection_limpo.js` copiado de DEV local para PROD local
- [ ] Hash SHA256 de `webflow_injection_limpo.js` verificado antes de copiar
- [ ] `webflow_injection_limpo.js` copiado para servidor PROD
- [ ] Hash SHA256 de `webflow_injection_limpo.js` verificado após cópia
- [ ] Cache do Cloudflare limpo
- [ ] Teste de mapeamento NOME → nome bem-sucedido

---

### **FASE 7: Configurações PHP-FPM (SEXTA - ALTA)**

**Objetivo:** Atualizar variáveis de ambiente no PHP-FPM config de PROD.

**Tarefas:**
1. ✅ Criar backup do arquivo de configuração atual em PROD
2. ✅ Atualizar variáveis AWS SES (credenciais, região, domínio)
3. ✅ Adicionar variável `OCTADESK_FROM`
4. ✅ Verificar/corrigir variáveis booleanas (valores entre aspas)
5. ✅ (Opcional) Adicionar 8 novas variáveis do projeto "Mover Parâmetros" (se aplicado)
6. ✅ Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
7. ✅ Validar funcionamento

**Checklist:**
- [ ] Backup do arquivo `/etc/php/8.3/fpm/pool.d/www.conf` criado em PROD
- [ ] Variáveis AWS SES atualizadas em PROD
- [ ] Variável `OCTADESK_FROM` adicionada em PROD
- [ ] Variáveis booleanas verificadas/corrigidas em PROD
- [ ] (Opcional) 8 novas variáveis adicionadas em PROD (se projeto "Mover Parâmetros" for aplicado)
- [ ] PHP-FPM recarregado com sucesso
- [ ] Testes de funcionamento bem-sucedidos

---

### **FASE 8: Projeto Mover Parâmetros para PHP (SÉTIMA - MÉDIA - OPCIONAL)**

**Objetivo:** Aplicar projeto "Mover Parâmetros para PHP" em PROD (apenas se validado e aprovado).

**Arquivos:**
1. `config_env.js.php` (já incluído na FASE 5, mas requer variáveis PHP-FPM da FASE 7)
2. Atualização do Webflow (adicionar script tag `config_env.js.php`)

**Tarefas:**
1. ✅ Verificar que variáveis PHP-FPM foram adicionadas (FASE 7)
2. ✅ Verificar que `config_env.js.php` foi atualizado (FASE 5)
3. ✅ Atualizar Webflow com novo script tag
4. ✅ Remover 8 data-attributes do Webflow
5. ✅ Validar funcionamento

**Checklist:**
- [ ] Variáveis PHP-FPM adicionadas (verificado na FASE 7)
- [ ] `config_env.js.php` atualizado (verificado na FASE 5)
- [ ] Webflow atualizado com script tag `config_env.js.php`
- [ ] 8 data-attributes removidos do Webflow
- [ ] Testes de funcionamento bem-sucedidos

---

## 📋 VALIDAÇÃO PÓS-DEPLOY

### **Validação Obrigatória Após Cada Fase:**

1. **Validação de Integridade:**
   - ✅ Hash SHA256 do arquivo no servidor PROD coincide com hash do arquivo DEV local
   - ✅ Arquivo foi copiado corretamente (sem corrupção)

2. **Validação de Funcionamento:**
   - ✅ Arquivo não causa erros no servidor
   - ✅ Funcionalidade específica do arquivo funciona corretamente
   - ✅ Logs não mostram erros relacionados ao arquivo

3. **Validação de Compatibilidade:**
   - ✅ Arquivo é compatível com outros arquivos já deployados
   - ✅ Não quebra funcionalidades existentes

### **Validação Final Após Todas as Fases:**

1. **Testes Funcionais:**
   - ✅ Testar envio de formulário completo
   - ✅ Testar validação de CPF
   - ✅ Testar validação de placa
   - ✅ Testar integração Octadesk
   - ✅ Testar integração EspoCRM
   - ✅ Testar envio de emails
   - ✅ Testar logging com nível TRACE
   - ✅ Testar Sentry (verificar console do navegador)
   - ✅ **Testar Enhanced Conversions Google Ads (Webflow):**
     - Preencher e submeter formulário Webflow com dados válidos
     - Abrir console do navegador (F12) e verificar `window.dataLayer`
     - Confirmar que evento `form_submit_valid` contém objeto `user_data`
     - Verificar que `user_data.phone_number` está no formato E.164 (+5511999999999)
     - Verificar que `user_data.email` está presente se email foi preenchido
     - Confirmar que eventos `form_submit_invalid_proceed` e `form_submit_network_error_proceed` foram removidos
   - ✅ **Testar Enhanced Conversions Google Ads (Modal):**
     - Preencher DDD + Celular no modal WhatsApp
     - Abrir console do navegador (F12) e verificar `window.dataLayer`
     - Confirmar que evento `whatsapp_modal_initial_contact` contém objeto `user_data`
     - Verificar que `user_data.phone_number` está no formato E.164 (+5511999999999)
     - Verificar que campos existentes foram mantidos (`phone_ddd`, `phone_number_masked`, `has_phone`)

2. **Testes de Performance:**
   - ✅ Verificar que não há degradação de performance
   - ✅ Verificar que logs não estão sendo gerados excessivamente

3. **Testes de Segurança:**
   - ✅ Verificar que credenciais não estão expostas
   - ✅ Verificar que validações estão funcionando

---

## 📋 PLANO DE ROLLBACK

### **Cenários de Rollback:**

1. **Rollback de Arquivo Individual:**
   - Restaurar backup do arquivo específico
   - Verificar hash SHA256 após restauração
   - Limpar cache do Cloudflare (se arquivo JavaScript)
   - Validar funcionamento

2. **Rollback de Fase Completa:**
   - Restaurar todos os arquivos da fase
   - Verificar hashes SHA256 após restauração
   - Limpar cache do Cloudflare
   - Validar funcionamento

3. **Rollback Completo:**
   - Restaurar backup completo do servidor
   - Restaurar backup completo do banco de dados
   - Limpar cache do Cloudflare
   - Validar funcionamento

### **Backups Obrigatórios:**

1. **Antes de FASE 2 (Banco de Dados):**
   - Backup completo do banco de dados PROD

2. **Antes de Cada Fase de Deploy:**
   - Backup dos arquivos que serão modificados

3. **Antes de FASE 7 (PHP-FPM):**
   - Backup do arquivo `/etc/php/8.3/fpm/pool.d/www.conf`

---

## 📋 RISCOS E MITIGAÇÕES

### **Riscos Identificados:**

1. **Risco: Alteração de Schema do Banco de Dados**
   - **Probabilidade:** Baixa
   - **Impacto:** Alto
   - **Mitigação:** Backup completo antes de aplicar, validação imediata após aplicação

2. **Risco: Quebra de Funcionalidades Existentes**
   - **Probabilidade:** Média
   - **Impacto:** Alto
   - **Mitigação:** Testes extensivos após cada fase, rollback imediato se necessário

3. **Risco: Cache do Cloudflare**
   - **Probabilidade:** Alta
   - **Impacto:** Médio
   - **Mitigação:** Limpar cache do Cloudflare após cada deploy de arquivo JavaScript

4. **Risco: Variáveis de Ambiente Não Configuradas**
   - **Probabilidade:** Média
   - **Impacto:** Alto
   - **Mitigação:** Verificar todas as variáveis antes de fazer deploy dos arquivos que dependem delas

5. **Risco: Dependências Não Respeitadas**
   - **Probabilidade:** Baixa
   - **Impacto:** Alto
   - **Mitigação:** Seguir ordem de deploy definida, validar pré-requisitos antes de cada fase

6. **Risco: Enhanced Conversions - Telefone Visível no dataLayer**
   - **Probabilidade:** Alta (por design)
   - **Impacto:** Médio (privacidade)
   - **Mitigação:** 
     - ✅ Google Ads faz hash dos dados antes do processamento
     - ✅ Dados mascarados mantidos para logs/visualização
     - ✅ Documentar que telefone completo será visível no console do navegador
     - ⚠️ Considerar hash SHA256 do telefone antes de enviar (opcional, mais seguro)

---

## 📋 CHECKLIST COMPLETO DE DEPLOY

### **Pré-Deploy:**
- [ ] Backup completo do servidor PROD criado
- [ ] Backup completo do banco de dados PROD criado
- [ ] Hashes SHA256 de todos os arquivos DEV vs PROD comparados
- [ ] Lista de arquivos que precisam ser atualizados validada
- [ ] Ordem de deploy definida e documentada
- [ ] Todas as dependências identificadas
- [ ] Procedimento para produção definido oficialmente

### **FASE 2: Banco de Dados**
- [ ] Backup do banco de dados PROD criado
- [ ] Script SQL executado com sucesso
- [ ] ENUM TRACE verificado em todas as 3 tabelas
- [ ] Teste de inserção de log com nível TRACE bem-sucedido

### **FASE 3: Arquivos PHP com TRACE**
- [ ] `ProfessionalLogger.php` deployado e validado
- [ ] `log_endpoint.php` deployado e validado

### **FASE 4: Arquivos JavaScript com TRACE e Sentry**
- [x] ✅ **IMPLEMENTADO:** Correção de Enhanced Conversions no `MODAL_WHATSAPP_DEFINITIVO.js` implementada (27/11/2025)
- [x] ✅ **IMPLEMENTADO:** Logs específicos de Enhanced Conversions adicionados em ambos os arquivos (27/11/2025)
- [ ] `FooterCodeSiteDefinitivoCompleto.js` deployado e validado
- [ ] `MODAL_WHATSAPP_DEFINITIVO.js` deployado e validado
- [ ] Cache do Cloudflare limpo
- [ ] Sentry funcionando corretamente
- [ ] Enhanced Conversions Google Ads funcionando no Webflow (objeto `user_data` no evento `form_submit_valid`)
- [ ] Enhanced Conversions Google Ads funcionando no Modal (objeto `user_data` no evento `whatsapp_modal_initial_contact`)
- [ ] Formato E.164 do telefone validado (+5511999999999) em ambos os eventos
- [ ] Eventos GTM desnecessários removidos (`form_submit_invalid_proceed`, `form_submit_network_error_proceed`)

### **FASE 5: Arquivos PHP com Eliminação de Hardcode**
- [ ] `config.php` deployado e validado
- [ ] `cpf-validate.php` deployado e validado
- [ ] `placa-validate.php` deployado e validado
- [ ] `aws_ses_config.php` deployado e validado
- [ ] `add_webflow_octa.php` deployado e validado
- [ ] `send_admin_notification_ses.php` deployado e validado
- [ ] `config_env.js.php` deployado e validado (se projeto "Mover Parâmetros" for aplicado)

### **FASE 6: Arquivos JavaScript com Eliminação de Hardcode**
- [ ] `webflow_injection_limpo.js` deployado e validado
- [ ] Cache do Cloudflare limpo

### **FASE 7: Configurações PHP-FPM**
- [ ] Variáveis AWS SES atualizadas
- [ ] Variável `OCTADESK_FROM` adicionada
- [ ] Variáveis booleanas verificadas/corrigidas
- [ ] (Opcional) 8 novas variáveis adicionadas
- [ ] PHP-FPM recarregado

### **FASE 8: Projeto Mover Parâmetros (Opcional)**
- [ ] Webflow atualizado com script tag
- [ ] 8 data-attributes removidos do Webflow

### **Pós-Deploy:**
- [ ] Todos os testes funcionais bem-sucedidos
- [ ] Todos os testes de performance bem-sucedidos
- [ ] Todos os testes de segurança bem-sucedidos
- [ ] Documentação atualizada
- [ ] Tracking de alterações atualizado

---

## 📋 DOCUMENTAÇÃO RELACIONADA

- **Tracking de Alterações:** `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_20251121.md`
- **Tracking de Alterações no Banco:** `TRACKING_ALTERACOES_BANCO_DADOS.md`
- **Histórico de Replicações:** `HISTORICO_REPLICACAO_PRODUCAO.md`
- **Projeto Correções Sentry:** `PROJETO_CORRECOES_ERRO_INTERMITENTE_SENTRY_20251126_REVISADO.md`
- **Projeto Simplificação Sentry:** `PROJETO_SIMPLIFICACAO_SENTRY_INICIO_20251127.md`
- **Enhanced Conversions Google Ads (Webflow + Modal):** Baseado em análise de especialista em Google Ads (27/11/2025)
  - Implementado em `FooterCodeSiteDefinitivoCompleto.js` (formulário Webflow)
  - Implementado em `MODAL_WHATSAPP_DEFINITIVO.js` (modal WhatsApp)
  - Eventos GTM desnecessários removidos do formulário Webflow (`form_submit_invalid_proceed`, `form_submit_network_error_proceed`)

---

**Data de Criação:** 27/11/2025  
**Data de Atualização:** 27/11/2025  
**Versão:** 1.2.0  
**Status:** 📋 **AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**  
**Auditoria:** ✅ **APROVADO COM RESALVAS CRÍTICAS** (27/11/2025) - Seção de Especificações do Usuário adicionada

