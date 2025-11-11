# ✅ CHECKLIST DE CORREÇÕES - AUDITORIA DE CÓDIGO

**Data:** 11/11/2025  
**Projeto:** PROJETO_AUDITORIA_CODIGO_4_ARQUIVOS  
**Status:** 📋 **CHECKLIST CRIADO**

---

## 🔴 PRIORIDADE 1 - CRÍTICOS (Corrigir Imediatamente)

### FooterCodeSiteDefinitivoCompleto.js
- [ ] **CRÍTICO:** Mover definição de `logClassified()` para antes das linhas 110-116
  - **Localização:** Linha 521 (definição) → Mover para antes da linha 110
  - **Impacto:** Quebra completa do script se `APP_BASE_URL` não estiver definido
  - **Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

---

## 🟠 PRIORIDADE 2 - ALTOS (Corrigir em Breve)

### FooterCodeSiteDefinitivoCompleto.js
- [ ] **ALTO:** Substituir 10 `console.*` diretos por `window.logClassified()` com verificação
  - **Localização:** Múltiplas linhas (10 ocorrências)
  - **Impacto:** Logs podem aparecer em produção mesmo quando `DEBUG_CONFIG.enabled === false`
  
- [x] **ALTO:** ~~Implementar sistema de rastreamento e limpeza de `setInterval`~~ ✅ **RESOLVIDO** (11/11/2025)
  - **Localização:** ~~Linhas 1685-1693~~ → Substituído por `MutationObserver` (linhas 1684-1754)
  - **Impacto:** ✅ Memory leak eliminado, performance melhorada
  - **Status:** ✅ `setInterval` eliminado, `MutationObserver` implementado com função de limpeza
  
- [ ] **MÉDIO:** Implementar sistema de rastreamento centralizado para os outros `setTimeout`
  - **Localização:** 13 `setTimeout` restantes (linhas 1386, 1598, 1607, 1677, 1706, 1742, 2485, 2500, 2501, 2504, 2505)
  - **Impacto:** Possível memory leak nos outros timeouts (o do modal já tem limpeza)
  
- [ ] **ALTO:** Mover 4 URLs hardcoded para variáveis de ambiente ou constantes configuráveis
  - **Localização:** 
    - Linha 1063: `https://viacep.com.br/ws/`
    - Linha 1117: `https://apilayer.net/api/validate`
    - Linha 1164: `https://${window.SAFETY_TICKET}.safetymails.com/api/`
    - Linha 1408: `https://api.whatsapp.com/send?phone=551141718837`
  - **Impacto:** Dificulta mudanças de configuração

### MODAL_WHATSAPP_DEFINITIVO.js
- [ ] **ALTO:** Substituir 19 `console.*` diretos por `window.logClassified()` com verificação
  - **Localização:** Linhas 246, 322, 325, 328, 331, 373, 379, 459, 469, 641, 694, 990, 1046, 1191, 1232, 1252, 1430, 1534, 1556
  - **Impacto:** Logs podem aparecer em produção mesmo quando `DEBUG_CONFIG.enabled === false`
  
- [ ] **ALTO:** Adicionar verificação de `window.APP_BASE_URL` antes de operações críticas e impedir execução se não estiver disponível
  - **Localização:** Linhas 167-168, 725-728
  - **Impacto:** Falhas silenciosas em operações críticas se `APP_BASE_URL` não estiver definido

### webflow_injection_limpo.js
- [ ] **ALTO:** Substituir 7 `console.*` diretos por `window.logClassified()` com verificação
  - **Localização:** Linhas 3191, 3202, 3205, 3216, 3218, 3231, 3233
  - **Impacto:** Logs podem aparecer em produção mesmo quando `DEBUG_CONFIG.enabled === false`
  
- [ ] **ALTO:** Mover URL hardcoded de webhook.site para variável de ambiente ou constante configurável
  - **Localização:** Linha 3224: `https://webhook.site/6431c548...`
  - **Impacto:** Dificulta mudanças de configuração

### Integração Entre Arquivos
- [ ] **ALTO:** Documentar ordem de carregamento esperada dos arquivos
  - **Arquivos:** Todos
  - **Impacto:** Garantir que dependências estejam disponíveis quando necessárias
  
- [ ] **ALTO:** Consolidar sistema de logging em um único sistema (`logClassified`) e deprecar `logUnified` e `logDebug`
  - **Arquivos:** `FooterCodeSiteDefinitivoCompleto.js`, `MODAL_WHATSAPP_DEFINITIVO.js`
  - **Impacto:** Evitar confusão e garantir comportamento consistente

---

## 🟡 PRIORIDADE 3 - MÉDIOS (Corrigir Quando Possível)

### FooterCodeSiteDefinitivoCompleto.js
- [ ] **MÉDIO:** Melhorar verificação de jQuery (já existe, mas pode ser mais robusta)
  - **Localização:** Linhas 1704-1705
  - **Impacto:** Baixo - há fallback implementado, mas verificação pode ser mais explícita
  
- [ ] **MÉDIO:** Declarar `modalOpening` no escopo apropriado ou documentar como variável global
  - **Localização:** Linhas 1707, 1717
  - **Impacto:** Possível criação de variável global não intencional

### MODAL_WHATSAPP_DEFINITIVO.js
- [ ] **MÉDIO:** Modificar `debugLog()` para respeitar `window.DEBUG_CONFIG.enabled`
  - **Localização:** Linhas 271-332
  - **Impacto:** Logs de debug podem aparecer em produção
  
- [ ] **MÉDIO:** Modificar `logEvent()` para usar `window.logClassified()` ao invés de `console.log` direto
  - **Localização:** Linhas 240-262
  - **Impacto:** Logs de eventos sempre aparecem no console
  
- [ ] **MÉDIO:** Implementar fallback para `localStorage` (usar `sessionStorage` ou variável em memória)
  - **Localização:** Linhas 373-379
  - **Impacto:** Estado do lead pode ser perdido se `localStorage` não estiver disponível

### webflow_injection_limpo.js
- [ ] **MÉDIO:** Implementar estratégia de retry ou fallback para validação de placa quando `APP_BASE_URL` não estiver disponível
  - **Localização:** Linhas 2262-2267
  - **Impacto:** Validação de placa pode falhar silenciosamente
  
- [ ] **MÉDIO:** Implementar sistema de rastreamento e limpeza de `setTimeout`/`setInterval`
  - **Localização:** 11 ocorrências
  - **Impacto:** Memory leak, execução de código após destruição do componente

### config_env.js.php
- [ ] **MÉDIO:** Modificar `getEndpointUrl` para verificar `DEBUG_CONFIG` antes de logar
  - **Localização:** Linhas 35-41
  - **Impacto:** Logs podem aparecer em produção mesmo quando `DEBUG_CONFIG.enabled === false`

---

## 🟢 PRIORIDADE 4 - BAIXOS (Melhorias)

### FooterCodeSiteDefinitivoCompleto.js
- [ ] **BAIXO:** Atualizar comentário com URL correta (domínio `bssegurosimediato.com.br` ao invés de `bpsegurosimediato.com.br`)
  - **Localização:** Linha 69
  - **Impacto:** Informação desatualizada, pode causar confusão

### webflow_injection_limpo.js
- [ ] **BAIXO:** Remover comentários sobre código removido ou mover para documentação
  - **Localização:** Linhas 3200, 3237
  - **Impacto:** Código comentado pode causar confusão

---

## 📊 RESUMO DE PROGRESSO

- **Total de Itens:** 25
- **CRÍTICOS:** 1 (0% concluído)
- **ALTOS:** 8 (1 resolvido - 12.5% concluído)
- **MÉDIOS:** 11 (0% concluído)
- **BAIXOS:** 3 (0% concluído)
- **✅ RESOLVIDOS:** 1 (setInterval eliminado - 11/11/2025)

---

## 📝 NOTAS

- Este checklist deve ser atualizado conforme as correções forem implementadas
- Priorizar correções CRÍTICAS antes de prosseguir com outras
- Testar cada correção antes de marcar como concluída
- Criar backup antes de cada correção

---

**Status:** 📋 **CHECKLIST CRIADO - AGUARDANDO IMPLEMENTAÇÃO DAS CORREÇÕES**

