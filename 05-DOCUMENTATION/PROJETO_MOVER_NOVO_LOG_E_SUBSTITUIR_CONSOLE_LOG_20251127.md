# 📋 PROJETO: Mover novo_log() para Início e Substituir console.log por Função Centralizada

**Data de Criação:** 27/11/2025  
**Data de Atualização:** 27/11/2025  
**Versão:** 1.1.0  
**Status:** 📋 **AGUARDANDO AUTORIZAÇÃO**  
**Ambiente:** 🟢 **DESENVOLVIMENTO (DEV)** - `dev.bssegurosimediato.com.br`

---

## 📋 RESUMO EXECUTIVO

### **Objetivo:**
Mover a função `window.novo_log()` para o início do arquivo `FooterCodeSiteDefinitivoCompleto.js`, garantir que a variável `window.versao` e o log de carregamento apareçam antes de qualquer outra mensagem, e substituir todos os `console.log` do Sentry e GCLID por chamadas à função centralizada `window.novo_log()`.

### **Problema Identificado:**
- ❌ `window.novo_log()` está definida após o código do Sentry (linha ~764), impedindo seu uso no início
- ❌ Variável `window.versao` está no início, mas o log de carregamento só executa após `novo_log()` estar disponível
- ❌ 5 `console.log` do Sentry não usam função centralizada (linhas 189, 193, 216, 222, 232)
- ❌ 7 `console.log` do GCLID não usam função centralizada (linhas 2164, 2227, 2351, 2416, 2430, 2448, 2456)
- ❌ Mensagem de versão não aparece como primeira no console, dificultando verificação de qual versão foi carregada

### **Causa Raiz:**
1. **Ordem de definição:** `window.novo_log()` está definida dentro de um IIFE que executa após o código do Sentry
2. **Dependências circulares:** Código do Sentry usa `console.log` porque `novo_log()` ainda não está disponível
3. **Log de versão tardio:** Log de carregamento só executa após `novo_log()` estar disponível, aparecendo depois das mensagens do Sentry

### **Escopo:**
- ✅ Mover `window.novo_log()` e suas dependências para o início do arquivo (após variável `versao`)
- ✅ Mover log de carregamento para executar imediatamente após `novo_log()` estar disponível
- ✅ Substituir 5 `console.log` do Sentry por `window.novo_log()`
- ✅ Substituir 7 `console.log` do GCLID por `window.novo_log()`
- ✅ Garantir que mensagem de versão seja a primeira a aparecer no console

### **Arquivos Afetados:**
1. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
   - **Mover:** Função `novo_log()` e dependências para início (após linha 87)
   - **Mover:** Log de carregamento para executar imediatamente após `novo_log()`
   - **Substituir:** 5 `console.log` do Sentry (linhas 189, 193, 216, 222, 232)
   - **Substituir:** 7 `console.log` do GCLID (linhas 2164, 2227, 2351, 2416, 2430, 2448, 2456)
   - **Remover:** Definição duplicada de `novo_log()` da posição atual (linha ~764)

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### **Objetivos do Usuário:**
1. **Centralizar Logging:**
   - Todos os logs devem usar função centralizada `window.novo_log()`
   - Eliminar uso direto de `console.log` (exceto casos críticos de loop infinito)
   - Facilitar controle e filtragem de logs

2. **Facilitar Análise:**
   - Mensagem de versão deve aparecer como primeira no console
   - Facilita verificação rápida de qual versão foi carregada
   - Melhora debugging e troubleshooting

3. **Manter Funcionalidade:**
   - Sentry deve continuar funcionando normalmente
   - GCLID deve continuar funcionando normalmente
   - Logs devem aparecer no console e no banco de dados

### **Requisitos Funcionais:**
1. **Ordem de Execução:**
   - Variável `window.versao` definida no início (já está)
   - Função `window.novo_log()` definida logo após `versao`
   - Log de carregamento executado imediatamente após `novo_log()` estar disponível
   - Código do Sentry executa após `novo_log()` estar disponível
   - Código do GCLID executa após `novo_log()` estar disponível

2. **Substituição de console.log:**
   - Todos os `console.log` do Sentry substituídos por `window.novo_log('INFO', 'SENTRY', ...)`
   - Todos os `console.log` do GCLID substituídos por `window.novo_log('INFO', 'GCLID', ...)`
   - Manter nível de log apropriado (INFO, DEBUG, WARN, ERROR)

3. **Compatibilidade:**
   - Função `novo_log()` deve funcionar mesmo quando movida para o início
   - Dependências de `novo_log()` devem estar disponíveis antes de sua definição
   - Não quebrar funcionalidades existentes

### **Requisitos Não-Funcionais:**
1. **Modificações Incrementais:**
   - Mover código sem alterar lógica
   - Substituir `console.log` por `novo_log()` mantendo mesma informação
   - Manter estrutura existente do arquivo

2. **Validação:**
   - Mensagem de versão aparece como primeira no console
   - Todos os logs do Sentry usam `novo_log()`
   - Todos os logs do GCLID usam `novo_log()`
   - Funcionalidades continuam funcionando

### **Critérios de Aceitação:**
- [ ] `window.novo_log()` está definida no início do arquivo (após `window.versao`)
- [ ] Log de carregamento aparece como primeira mensagem no console
- [ ] Todos os 5 `console.log` do Sentry foram substituídos por `novo_log()`
- [ ] Todos os 7 `console.log` do GCLID foram substituídos por `novo_log()`
- [ ] Sentry continua funcionando normalmente
- [ ] GCLID continua funcionando normalmente
- [ ] Logs aparecem no console e no banco de dados
- [ ] Não há erros no console relacionados às mudanças
- [ ] Código não quebra funcionalidades existentes

---

## 🔍 ANÁLISE DO CÓDIGO ATUAL

### **Localização Atual:**

#### **1. Variável versao:**
- **Localização:** Linha 87 (já está no início)
- **Código:**
  ```javascript
  window.versao = '1.7.0';
  ```

#### **2. Função novo_log():**
- **Localização:** Linhas ~764-841 (dentro de IIFE que começa antes)
- **Dependências:**
  - `window.shouldLog` (linha ~463)
  - `window.shouldLogToConsole` (linha ~497)
  - `window.shouldLogToDatabase` (linha ~486)
  - `window.sendLogToProfessionalSystem` (linha ~532)
  - `window.LOG_CONFIG` (linha ~440)
  - `window.DEBUG_CONFIG` (verificação opcional)
  - `window.APP_BASE_URL` (necessário para `sendLogToProfessionalSystem`)

#### **3. Log de carregamento:**
- **Localização:** Linhas ~847-870 (após definição de `novo_log()`)
- **Código:** IIFE que aguarda DOM pronto e chama `window.novo_log()`

#### **4. console.log do Sentry:**
- **Linha 189:** `console.log('[SENTRY] Sentry inicializado com sucesso (environment: ' + environment + ')');`
- **Linha 193:** `console.log('[SENTRY] Status:', {...});`
- **Linha 216:** `console.log('[SENTRY] Sentry já está carregado, inicializando...');`
- **Linha 222:** `console.log('[SENTRY] Carregando SDK do Sentry...');`
- **Linha 232:** `console.log('[SENTRY] SDK do Sentry carregado com sucesso, inicializando...');`

#### **5. console.log do GCLID:**
- **Linha 2164:** `console.log('[GCLID] executeGCLIDFill() iniciada');`
- **Linha 2227:** `console.log('[GCLID] ' + logMsg);`
- **Linha 2351:** `console.log('[GCLID] ' + confirmationMsg);`
- **Linha 2416:** `console.log('[GCLID] Campo adicionado dinamicamente detectado');`
- **Linha 2430:** `console.log('[GCLID] MutationObserver configurado');`
- **Linha 2448:** `console.log('[GCLID] DOM ainda carregando - Adicionando listener');`
- **Linha 2456:** `console.log('[GCLID] DOM já pronto - Executando imediatamente');`

### **Problemas Identificados:**
1. **Dependências de novo_log():**
   - `window.LOG_CONFIG` e funções helper (`shouldLog`, `shouldLogToConsole`, `shouldLogToDatabase`) são definidas antes de `novo_log()`
   - `window.sendLogToProfessionalSystem` é definida antes de `novo_log()`
   - Essas dependências precisam ser movidas junto com `novo_log()` ou antes dela

2. **Ordem de execução:**
   - Código do Sentry executa antes de `novo_log()` estar disponível
   - Código do GCLID executa antes de `novo_log()` estar disponível
   - Log de carregamento só executa após `novo_log()` estar disponível

3. **Estrutura atual:**
   - Tudo está dentro de um IIFE grande que começa antes da linha 400
   - `novo_log()` está dentro desse IIFE
   - Precisamos mover o bloco completo ou reorganizar

---

## 📋 PLANO DE IMPLEMENTAÇÃO

### **FASE 1: Preparação e Backup**
1. Criar backup do arquivo atual
2. Verificar hash SHA256 do arquivo atual
3. Documentar localização exata de todas as funções e dependências

### **FASE 2: Mover Dependências de novo_log() para o Início**
1. **Validar dependência `window.APP_BASE_URL`:**
   - Verificar se `window.APP_BASE_URL` está disponível antes de mover `sendLogToProfessionalSystem`
   - Se não estiver disponível, adicionar verificação e fallback (usar `console.log` direto se necessário)
   - Documentar resultado da validação
2. Mover definição de `window.LOG_CONFIG` e funções helper para início (após `window.versao`)
3. Mover `window.sendLogToProfessionalSystem` para início (após funções helper)
4. Adicionar verificação de dependências críticas antes de usar `sendLogToProfessionalSystem`

### **FASE 3: Mover novo_log() para o Início**
1. Mover função `novo_log()` para início (após dependências)
2. Expor `window.novo_log` globalmente
3. Remover definição duplicada da posição atual

### **FASE 4: Mover Log de Carregamento para o Início**
1. Mover IIFE de log de carregamento para executar imediatamente após `novo_log()` estar disponível
2. Garantir que log apareça antes de qualquer outra mensagem

### **FASE 5: Substituir console.log do Sentry**
1. Substituir linha 189: `window.novo_log('INFO', 'SENTRY', 'Sentry inicializado com sucesso', { environment: environment })`
2. Substituir linha 193: `window.novo_log('INFO', 'SENTRY', 'Status', { carregado: ..., inicializado: ..., environment: ..., timestamp: ... })`
3. Substituir linha 216: `window.novo_log('INFO', 'SENTRY', 'Sentry já está carregado, inicializando...')`
4. Substituir linha 222: `window.novo_log('INFO', 'SENTRY', 'Carregando SDK do Sentry...')`
5. Substituir linha 232: `window.novo_log('INFO', 'SENTRY', 'SDK do Sentry carregado com sucesso, inicializando...')`

### **FASE 6: Substituir console.log do GCLID**
1. Substituir linha 2164: `window.novo_log('INFO', 'GCLID', 'executeGCLIDFill() iniciada')`
2. Substituir linha 2227: `window.novo_log('INFO', 'GCLID', logMsg)`
3. Substituir linha 2351: `window.novo_log('INFO', 'GCLID', confirmationMsg)`
4. Substituir linha 2416: `window.novo_log('INFO', 'GCLID', 'Campo adicionado dinamicamente detectado')`
5. Substituir linha 2430: `window.novo_log('INFO', 'GCLID', 'MutationObserver configurado')`
6. Substituir linha 2448: `window.novo_log('INFO', 'GCLID', 'DOM ainda carregando - Adicionando listener')`
7. Substituir linha 2456: `window.novo_log('INFO', 'GCLID', 'DOM já pronto - Executando imediatamente')`

### **FASE 7: Validação e Testes**
1. **Testes Funcionais Básicos:**
   - Verificar que mensagem de versão aparece como primeira no console
   - Verificar que todos os logs do Sentry usam `novo_log()`
   - Verificar que todos os logs do GCLID usam `novo_log()`
   - Testar funcionalidade do Sentry
   - Testar funcionalidade do GCLID
   - Verificar logs no banco de dados

2. **Testes de Casos Extremos:**
   - **Cenário 1: `window.APP_BASE_URL` não disponível**
     - Simular ausência de `window.APP_BASE_URL`
     - Verificar que `sendLogToProfessionalSystem` não quebra aplicação
     - Verificar que logs ainda aparecem no console mesmo sem envio para banco
   - **Cenário 2: `window.novo_log()` falha durante execução**
     - Simular erro em `novo_log()` (ex: `shouldLog` retorna erro)
     - Verificar que aplicação não quebra
     - Verificar que tratamento de erro silencioso funciona
   - **Cenário 3: DOM não está pronto quando log de carregamento executa**
     - Verificar que IIFE aguarda `DOMContentLoaded` corretamente
     - Verificar que log aparece mesmo se DOM já estiver pronto
     - Verificar que não há erro se DOM não estiver disponível
   - **Cenário 4: Dependências de `novo_log()` não estão disponíveis**
     - Simular ausência de `window.LOG_CONFIG`
     - Simular ausência de `window.shouldLog`
     - Verificar que `novo_log()` tem fallback adequado

---

## 📋 DETALHAMENTO TÉCNICO

### **Estrutura Proposta (Início do Arquivo):**

```javascript
// ======================
// VARIÁVEL GLOBAL DE VERSÃO
// ======================
window.versao = '1.7.0';

// ======================
// CONFIGURAÇÃO DE LOGGING (MOVIDA PARA O INÍCIO)
// ======================
// ... código de LOG_CONFIG e funções helper ...

// ======================
// FUNÇÃO sendLogToProfessionalSystem (MOVIDA PARA O INÍCIO)
// ======================
// ... código de sendLogToProfessionalSystem ...

// ======================
// FUNÇÃO novo_log() (MOVIDA PARA O INÍCIO)
// ======================
// ... código de novo_log() ...
window.novo_log = novo_log;

// ======================
// LOG DE CARREGAMENTO DO ARQUIVO (MOVIDO PARA O INÍCIO)
// ======================
(function logFileLoad() {
  try {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function() {
        window.novo_log('INFO', 'FOOTER_CODE', 'FooterCodeSiteDefinitivoCompleto.js carregado', {
          versao: window.versao || 'não definida',
          timestamp: new Date().toISOString(),
          readyState: document.readyState
        }, 'INIT', 'MEDIUM');
      });
    } else {
      window.novo_log('INFO', 'FOOTER_CODE', 'FooterCodeSiteDefinitivoCompleto.js carregado', {
        versao: window.versao || 'não definida',
        timestamp: new Date().toISOString(),
        readyState: document.readyState
      }, 'INIT', 'MEDIUM');
    }
  } catch (error) {
    console.warn('[FOOTER_CODE] Erro ao logar carregamento:', error);
  }
})();

// ======================
// SENTRY ERROR TRACKING
// ======================
// ... código do Sentry usando window.novo_log() ...
```

### **Substituições Propostas:**

#### **Sentry:**
1. **Linha 189:**
   ```javascript
   // ANTES:
   console.log('[SENTRY] Sentry inicializado com sucesso (environment: ' + environment + ')');
   
   // DEPOIS:
   window.novo_log('INFO', 'SENTRY', 'Sentry inicializado com sucesso', {
     environment: environment,
     method: 'simplified_init'
   }, 'INIT', 'MEDIUM');
   ```

2. **Linha 193:**
   ```javascript
   // ANTES:
   console.log('[SENTRY] Status:', {
     carregado: typeof Sentry !== 'undefined',
     inicializado: window.SENTRY_INITIALIZED,
     environment: environment,
     timestamp: new Date().toISOString()
   });
   
   // DEPOIS:
   window.novo_log('INFO', 'SENTRY', 'Status', {
     carregado: typeof Sentry !== 'undefined',
     inicializado: window.SENTRY_INITIALIZED,
     environment: environment,
     timestamp: new Date().toISOString()
   }, 'INIT', 'MEDIUM');
   ```

3. **Linha 216:**
   ```javascript
   // ANTES:
   console.log('[SENTRY] Sentry já está carregado, inicializando...');
   
   // DEPOIS:
   window.novo_log('INFO', 'SENTRY', 'Sentry já está carregado, inicializando...', null, 'INIT', 'MEDIUM');
   ```

4. **Linha 222:**
   ```javascript
   // ANTES:
   console.log('[SENTRY] Carregando SDK do Sentry...');
   
   // DEPOIS:
   window.novo_log('INFO', 'SENTRY', 'Carregando SDK do Sentry...', null, 'INIT', 'MEDIUM');
   ```

5. **Linha 232:**
   ```javascript
   // ANTES:
   console.log('[SENTRY] SDK do Sentry carregado com sucesso, inicializando...');
   
   // DEPOIS:
   window.novo_log('INFO', 'SENTRY', 'SDK do Sentry carregado com sucesso, inicializando...', null, 'INIT', 'MEDIUM');
   ```

#### **GCLID:**
1. **Linha 2164:**
   ```javascript
   // ANTES:
   console.log('[GCLID] executeGCLIDFill() iniciada');
   
   // DEPOIS:
   window.novo_log('INFO', 'GCLID', 'executeGCLIDFill() iniciada', null, 'OPERATION', 'MEDIUM');
   ```

2. **Linha 2227:**
   ```javascript
   // ANTES:
   console.log('[GCLID] ' + logMsg);
   
   // DEPOIS:
   window.novo_log('INFO', 'GCLID', logMsg, null, 'OPERATION', 'MEDIUM');
   ```

3. **Linha 2351:**
   ```javascript
   // ANTES:
   console.log('[GCLID] ' + confirmationMsg);
   
   // DEPOIS:
   window.novo_log('INFO', 'GCLID', confirmationMsg, null, 'OPERATION', 'MEDIUM');
   ```

4. **Linha 2416:**
   ```javascript
   // ANTES:
   console.log('[GCLID] Campo adicionado dinamicamente detectado');
   
   // DEPOIS:
   window.novo_log('INFO', 'GCLID', 'Campo adicionado dinamicamente detectado', null, 'OPERATION', 'MEDIUM');
   ```

5. **Linha 2430:**
   ```javascript
   // ANTES:
   console.log('[GCLID] MutationObserver configurado');
   
   // DEPOIS:
   window.novo_log('INFO', 'GCLID', 'MutationObserver configurado', null, 'OPERATION', 'MEDIUM');
   ```

6. **Linha 2448:**
   ```javascript
   // ANTES:
   console.log('[GCLID] DOM ainda carregando - Adicionando listener');
   
   // DEPOIS:
   window.novo_log('INFO', 'GCLID', 'DOM ainda carregando - Adicionando listener', null, 'OPERATION', 'MEDIUM');
   ```

7. **Linha 2456:**
   ```javascript
   // ANTES:
   console.log('[GCLID] DOM já pronto - Executando imediatamente');
   
   // DEPOIS:
   window.novo_log('INFO', 'GCLID', 'DOM já pronto - Executando imediatamente', null, 'OPERATION', 'MEDIUM');
   ```

---

## 📋 RISCOS E MITIGAÇÕES

### **Risco 1: Dependências Circulares**
- **Probabilidade:** Média
- **Impacto:** Alto
- **Mitigação:**
  - Verificar todas as dependências de `novo_log()` antes de mover
  - Mover dependências junto com `novo_log()`
  - Testar que todas as dependências estão disponíveis antes de usar

### **Risco 2: Quebra de Funcionalidades**
- **Probabilidade:** Baixa
- **Impacto:** Alto
- **Mitigação:**
  - Manter lógica idêntica ao mover código
  - Testar Sentry após mudanças
  - Testar GCLID após mudanças
  - Verificar logs no banco de dados

### **Risco 3: Ordem de Execução**
- **Probabilidade:** Média
- **Impacto:** Médio
- **Mitigação:**
  - Garantir que `window.APP_BASE_URL` esteja disponível antes de `sendLogToProfessionalSystem`
  - Usar IIFE para garantir ordem de execução
  - Testar que log de versão aparece primeiro

### **Risco 4: Loop Infinito em Logging**
- **Probabilidade:** Baixa
- **Impacto:** Alto
- **Mitigação:**
  - Manter tratamento de erro silencioso em `novo_log()`
  - Não usar `novo_log()` dentro de `sendLogToProfessionalSystem` (já está assim)
  - Testar que não há recursão

### **Risco 5: APP_BASE_URL Não Disponível**
- **Probabilidade:** Média
- **Impacto:** Médio
- **Mitigação:**
  - Validar `window.APP_BASE_URL` antes de mover `sendLogToProfessionalSystem`
  - Adicionar verificação e fallback em `sendLogToProfessionalSystem`
  - Garantir que logs aparecem no console mesmo se envio para banco falhar
  - Testar cenário de `APP_BASE_URL` não disponível

---

## 📋 PLANO DE ROLLBACK

### **Objetivo:**
Documentar processo completo de reversão caso a implementação falhe ou cause problemas em produção.

### **Cenários de Rollback:**
1. **Implementação falha durante desenvolvimento:**
   - Arquivo corrompido ou com erros de sintaxe
   - Funcionalidades quebradas após implementação
   - Erros no console que impedem execução

2. **Problemas detectados após deploy em DEV:**
   - Sentry não inicializa corretamente
   - GCLID não funciona
   - Logs não aparecem no console ou banco
   - Performance degradada

3. **Problemas críticos em produção:**
   - Aplicação quebrada
   - Funcionalidades críticas não funcionam
   - Erros que afetam usuários

### **Processo de Rollback:**

#### **FASE 1: Identificar Problema**
1. Verificar logs do console do navegador
2. Verificar logs do servidor (Nginx, PHP-FPM)
3. Verificar logs no banco de dados (`application_logs`)
4. Identificar arquivo e linha específica do problema
5. Documentar erro encontrado

#### **FASE 2: Decidir Rollback**
1. Avaliar severidade do problema:
   - **Crítico:** Aplicação quebrada, funcionalidades críticas não funcionam
   - **Alto:** Funcionalidades importantes afetadas, mas aplicação funciona
   - **Médio:** Problemas menores, não afetam funcionalidades críticas
2. Se problema for **Crítico** ou **Alto:** Proceder com rollback imediato
3. Se problema for **Médio:** Avaliar se correção rápida é possível antes de rollback

#### **FASE 3: Executar Rollback**
1. **Localizar backup:**
   - Backup criado na FASE 1: `FooterCodeSiteDefinitivoCompleto.js.backup_YYYYMMDD_HHMMSS`
   - Verificar hash SHA256 do backup
   - Confirmar que backup é da versão anterior à implementação

2. **Restaurar arquivo:**
   ```bash
   # No servidor DEV
   cd /var/www/html/dev/root/
   cp FooterCodeSiteDefinitivoCompleto.js.backup_YYYYMMDD_HHMMSS FooterCodeSiteDefinitivoCompleto.js
   ```

3. **Verificar integridade:**
   ```bash
   # Calcular hash do arquivo restaurado
   sha256sum FooterCodeSiteDefinitivoCompleto.js
   # Comparar com hash do backup
   ```

4. **Validar restauração:**
   - Verificar que arquivo foi restaurado corretamente
   - Verificar que hash coincide com backup
   - Testar funcionalidades básicas (Sentry, GCLID)
   - Verificar logs no console

#### **FASE 4: Validação Pós-Rollback**
1. **Testes Funcionais:**
   - [ ] Sentry inicializa corretamente
   - [ ] GCLID funciona normalmente
   - [ ] Logs aparecem no console
   - [ ] Logs aparecem no banco de dados
   - [ ] Não há erros no console
   - [ ] Aplicação funciona normalmente

2. **Verificação de Integridade:**
   - [ ] Hash SHA256 do arquivo restaurado coincide com backup
   - [ ] Arquivo não está corrompido
   - [ ] Sintaxe JavaScript está correta

3. **Limpeza:**
   - [ ] Limpar cache do Cloudflare (se necessário)
   - [ ] Documentar rollback realizado
   - [ ] Atualizar histórico de alterações

### **Prevenção de Rollback:**
1. **Validação Pré-Deploy:**
   - Validar sintaxe JavaScript antes de copiar para servidor
   - Testar localmente (quando possível)
   - Verificar dependências antes de mover código

2. **Validação Pós-Deploy:**
   - Verificar hash SHA256 após cópia
   - Testar funcionalidades imediatamente após deploy
   - Monitorar logs por período determinado

3. **Backup Automático:**
   - Sempre criar backup antes de modificar
   - Manter múltiplos backups (últimas 3 versões)
   - Documentar hash de cada backup

### **Documentação de Rollback:**
- Registrar data e hora do rollback
- Documentar motivo do rollback
- Registrar hash SHA256 do arquivo restaurado
- Documentar problemas encontrados
- Registrar validação pós-rollback

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Preparação:**
- [ ] Backup criado do arquivo atual
- [ ] Hash SHA256 do arquivo atual registrado
- [ ] Localização de todas as funções documentada

### **Fase 2: Mover Dependências:**
- [ ] `window.APP_BASE_URL` validado e disponível
- [ ] Verificação de dependências críticas adicionada
- [ ] `window.LOG_CONFIG` e funções helper movidas para início
- [ ] `window.sendLogToProfessionalSystem` movida para início
- [ ] Dependências removidas da posição atual

### **Fase 3: Mover novo_log():**
- [ ] Função `novo_log()` movida para início
- [ ] `window.novo_log` exposta globalmente
- [ ] Definição duplicada removida da posição atual

### **Fase 4: Mover Log de Carregamento:**
- [ ] IIFE de log de carregamento movida para início
- [ ] Log executado imediatamente após `novo_log()` estar disponível

### **Fase 5: Substituir console.log do Sentry:**
- [ ] Linha 189 substituída
- [ ] Linha 193 substituída
- [ ] Linha 216 substituída
- [ ] Linha 222 substituída
- [ ] Linha 232 substituída

### **Fase 6: Substituir console.log do GCLID:**
- [ ] Linha 2164 substituída
- [ ] Linha 2227 substituída
- [ ] Linha 2351 substituída
- [ ] Linha 2416 substituída
- [ ] Linha 2430 substituída
- [ ] Linha 2448 substituída
- [ ] Linha 2456 substituída

### **Fase 7: Validação:**
- [ ] Mensagem de versão aparece como primeira no console
- [ ] Todos os logs do Sentry usam `novo_log()`
- [ ] Todos os logs do GCLID usam `novo_log()`
- [ ] Sentry funciona normalmente
- [ ] GCLID funciona normalmente
- [ ] Logs aparecem no banco de dados
- [ ] Não há erros no console
- [ ] Hash SHA256 do arquivo modificado registrado
- [ ] **Testes de Casos Extremos:**
  - [ ] Cenário 1: `APP_BASE_URL` não disponível testado
  - [ ] Cenário 2: `novo_log()` falha testado
  - [ ] Cenário 3: DOM não pronto testado
  - [ ] Cenário 4: Dependências não disponíveis testado

---

## 📋 STAKEHOLDERS

### **1. Desenvolvedor:**
- **Impacto:** Alto
- **Interesse:** Código mais organizado, logging centralizado
- **Responsabilidades:** Implementar mudanças, testar funcionalidades

### **2. Equipe de Qualidade:**
- **Impacto:** Médio
- **Interesse:** Facilita debugging, logs mais consistentes
- **Responsabilidades:** Validar que logs aparecem corretamente, testar funcionalidades

### **3. Usuário Final:**
- **Impacto:** Baixo
- **Interesse:** Aplicação continua funcionando normalmente
- **Responsabilidades:** Nenhuma (mudança interna)

---

## 📋 NOTAS TÉCNICAS

### **Dependências de novo_log():**
- `window.LOG_CONFIG`: Configuração de logging (definida antes de `novo_log()`)
- `window.shouldLog`: Função helper (definida antes de `novo_log()`)
- `window.shouldLogToConsole`: Função helper (definida antes de `novo_log()`)
- `window.shouldLogToDatabase`: Função helper (definida antes de `novo_log()`)
- `window.sendLogToProfessionalSystem`: Função de envio (definida antes de `novo_log()`)
- `window.DEBUG_CONFIG`: Configuração legada (opcional, verificação com `typeof`)
- `window.APP_BASE_URL`: Variável de ambiente (vem de data attribute, necessário para `sendLogToProfessionalSystem`)

### **Considerações:**
- `window.APP_BASE_URL` deve estar disponível antes de `sendLogToProfessionalSystem` ser chamada
  - **Validação obrigatória:** Verificar disponibilidade antes de mover código
  - **Fallback:** Se não estiver disponível, `sendLogToProfessionalSystem` deve retornar `false` sem quebrar
  - **Teste:** Validar cenário de `APP_BASE_URL` não disponível
- Função `novo_log()` tem tratamento de erro silencioso, não quebra aplicação se falhar
- Logs do sistema de logging (`sendLogToProfessionalSystem`) continuam usando `console.log` direto para evitar loop infinito (isso está correto)

### **Validação de Dependências Críticas:**
Antes de mover `sendLogToProfessionalSystem` para o início, validar:
1. **`window.APP_BASE_URL`:**
   - Verificar se está disponível via data attribute
   - Se não estiver, adicionar verificação em `sendLogToProfessionalSystem`
   - Documentar resultado da validação

2. **`window.LOG_CONFIG`:**
   - Verificar se será definido antes de `novo_log()` usar
   - Garantir ordem de execução correta

3. **Funções Helper:**
   - `window.shouldLog`
   - `window.shouldLogToConsole`
   - `window.shouldLogToDatabase`
   - Todas devem estar disponíveis antes de `novo_log()` usar

---

## 📋 REFERÊNCIAS

- **Documentação de Logging:** `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/`
- **Projeto Anterior:** `PROJETO_SIMPLIFICACAO_SENTRY_INICIO_20251127.md`
- **Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

---

**Fim do Documento**

