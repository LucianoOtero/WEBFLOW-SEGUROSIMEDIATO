# 🔍 Investigação: Secret Keys SafetyMails em Produção

**Data:** 16/11/2025  
**Ambiente:** Produção (`prod.bssegurosimediato.com.br`)  
**Objetivo:** Identificar quais secret keys do SafetyMails estão sendo utilizadas em produção

---

## 📊 RESUMO EXECUTIVO

### **Secret Keys Identificadas em Produção:**

| Credencial | Valor | Localização | Status |
|------------|-------|-------------|--------|
| **SAFETY_TICKET** | `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` | `FooterCodeSiteDefinitivoCompleto.js` (linha 243) | ⚠️ **PROBLEMA IDENTIFICADO** |
| **SAFETY_API_KEY** | `20a7a1c297e39180bd80428ac13c363e882a531f` | `FooterCodeSiteDefinitivoCompleto.js` (linha 244) | ✅ Confirmado |

### **⚠️ PROBLEMA CRÍTICO IDENTIFICADO:**

O arquivo de produção (`03-PRODUCTION/FooterCodeSiteDefinitivoCompleto.js`) contém:
- **Comentário na linha 78-79:** `⚠️ AMBIENTE: DESENVOLVIMENTO`
- **Comentário na linha 243:** `// DEV: Ticket origem atualizado`
- **Comentário na linha 244:** `// Mesmo para DEV e PROD`

**Isso indica que:**
1. ⚠️ As credenciais podem estar incorretas para produção
2. ⚠️ O ticket origem pode ser de desenvolvimento, não de produção
3. ⚠️ Pode ser necessário criar/verificar ticket origem específico para produção

---

## 🔍 INVESTIGAÇÃO DETALHADA

### **1. Arquivo Local de Produção (Windows)**

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
- ✅ `SAFETY_API_KEY` está definida: `20a7a1c297e39180bd80428ac13c363e882a531f`
- ⚠️ `SAFETY_TICKET` está definida: `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- ⚠️ **PROBLEMA:** Comentário indica "DEV: Ticket origem atualizado"
- ⚠️ **PROBLEMA:** Comentário no cabeçalho indica "AMBIENTE: DESENVOLVIMENTO"

---

### **2. Arquivo no Servidor de Produção**

**Servidor:** `157.180.36.223` (`prod.bssegurosimediato.com.br`)  
**Arquivo:** `/var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js`

**Verificação via SSH:**
```bash
ssh root@157.180.36.223 "grep -E 'SAFETY_TICKET|SAFETY_API_KEY' /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js"
```

**Resultado:**
```
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // DEV: Ticket origem atualizado
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
```

**Análise:**
- ✅ Arquivo no servidor está idêntico ao arquivo local
- ⚠️ **PROBLEMA:** Mesmas credenciais de desenvolvimento estão sendo usadas em produção
- ⚠️ **PROBLEMA:** Comentário ainda indica "DEV: Ticket origem atualizado"

---

### **3. Comparação com Ambiente de Desenvolvimento**

**Arquivo DEV:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

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
- ⚠️ **PRODUÇÃO E DESENVOLVIMENTO ESTÃO USANDO AS MESMAS CREDENCIAIS**
- ⚠️ Ambos usam o mesmo `SAFETY_TICKET`: `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- ✅ Ambos usam o mesmo `SAFETY_API_KEY`: `20a7a1c297e39180bd80428ac13c363e882a531f`

---

## ⚠️ PROBLEMAS IDENTIFICADOS

### **1. Credenciais de Desenvolvimento em Produção**

**Problema:**
- O arquivo de produção está usando as mesmas credenciais de desenvolvimento
- O comentário indica "DEV: Ticket origem atualizado"
- Não há diferenciação entre ambientes DEV e PROD

**Impacto:**
- ⚠️ Pode causar problemas de validação de origem no SafetyMails
- ⚠️ Pode não funcionar corretamente se o ticket origem não tiver as origens de produção cadastradas
- ⚠️ Dificulta rastreamento e auditoria de uso por ambiente

### **2. Comentários Incorretos**

**Problema:**
- Comentário no cabeçalho do arquivo diz "AMBIENTE: DESENVOLVIMENTO"
- Comentário na linha do ticket diz "DEV: Ticket origem atualizado"
- Arquivo está em `03-PRODUCTION/` mas tem comentários de desenvolvimento

**Impacto:**
- ⚠️ Pode causar confusão durante manutenção
- ⚠️ Pode levar a decisões incorretas sobre qual ticket usar

### **3. Falta de Diferenciação de Ambientes**

**Problema:**
- Não há variáveis de ambiente ou configuração condicional para diferenciar DEV e PROD
- As credenciais estão hardcoded no JavaScript

**Impacto:**
- ⚠️ Dificulta gerenciamento de credenciais
- ⚠️ Requer modificação manual do código para alterar credenciais

---

## 🔍 VERIFICAÇÕES NECESSÁRIAS

### **1. Verificar no Painel SafetyMails**

**Ações necessárias:**
1. Acessar painel do SafetyMails
2. Verificar ticket origem: `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
3. Verificar quais origens estão cadastradas para esse ticket:
   - `https://www.segurosimediato.com.br` (produção)
   - `https://segurosimediato.com.br` (produção)
   - `https://segurosimediato-dev.webflow.io` (desenvolvimento)
   - `https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io` (desenvolvimento)
4. Confirmar se o ticket suporta múltiplas origens (DEV e PROD)

### **2. Verificar se Precisa Criar Novo Ticket para Produção**

**Cenário 1: Ticket atual suporta múltiplas origens**
- ✅ Se o ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` já tem as origens de produção cadastradas
- ✅ Pode continuar usando o mesmo ticket e API key
- ✅ Apenas corrigir comentários no código

**Cenário 2: Ticket atual NÃO suporta múltiplas origens**
- ⚠️ Se o ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` é apenas para desenvolvimento
- ⚠️ Precisa criar novo ticket origem para produção
- ⚠️ Pode precisar de nova API key (dependendo da configuração do SafetyMails)
- ⚠️ Atualizar código de produção com novo ticket

### **3. Verificar Funcionamento Atual**

**Ações necessárias:**
1. Testar validação de email em produção
2. Verificar logs do SafetyMails para erros de origem
3. Confirmar se requisições de produção estão sendo aceitas

---

## 📋 RECOMENDAÇÕES

### **1. Verificar Painel SafetyMails (PRIORITÁRIO)**

**Ação imediata:**
- Acessar painel do SafetyMails
- Verificar configuração do ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- Confirmar se origens de produção estão cadastradas

### **2. Corrigir Comentários no Código**

**Ação:**
- Atualizar comentários em `03-PRODUCTION/FooterCodeSiteDefinitivoCompleto.js`
- Remover referências a "DESENVOLVIMENTO"
- Adicionar comentários claros indicando ambiente de produção

### **3. Criar Novo Ticket para Produção (se necessário)**

**Ação (apenas se ticket atual não suportar produção):**
- Criar novo ticket origem no painel SafetyMails para produção
- Cadastrar origens de produção: `www.segurosimediato.com.br` e `segurosimediato.com.br`
- Atualizar código de produção com novo ticket
- Documentar novo ticket e API key

### **4. Implementar Diferenciação de Ambientes (FUTURO)**

**Ação (melhoria futura):**
- Usar variáveis de ambiente ou data attributes para definir credenciais
- Evitar hardcode de credenciais no JavaScript
- Facilitar gerenciamento de credenciais por ambiente

---

## 📊 CONCLUSÃO

### **Secret Keys Atualmente em Produção:**

| Credencial | Valor | Status |
|------------|-------|--------|
| **SAFETY_TICKET** | `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` | ⚠️ **VERIFICAR SE É CORRETO PARA PROD** |
| **SAFETY_API_KEY** | `20a7a1c297e39180bd80428ac13c363e882a531f` | ✅ Confirmado (mesmo para DEV e PROD) |

### **Próximos Passos:**

1. ✅ **VERIFICAR** no painel SafetyMails se o ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` tem as origens de produção cadastradas
2. ✅ **CORRIGIR** comentários no código de produção para refletir ambiente correto
3. ✅ **CRIAR** novo ticket para produção (se necessário)
4. ✅ **ATUALIZAR** código de produção com credenciais corretas (se necessário)

---

**Data de Investigação:** 16/11/2025  
**Investigação Realizada por:** Sistema Automatizado  
**Status:** ✅ **INVESTIGAÇÃO COMPLETA - AGUARDANDO VERIFICAÇÃO NO PAINEL SAFETYMAILS**

