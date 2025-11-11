# 📋 RESUMO - VERIFICAÇÃO DE URLs HARDCODED

**Data:** 10/11/2025  
**Status:** ⚠️ **11 PROBLEMAS ENCONTRADOS**

---

## 🔴 PROBLEMAS CRÍTICOS (5)

### URLs Externas Hardcoded (`mdmidia.com.br`)

1. **FooterCodeSiteDefinitivoCompleto.js:964** - `validateCPF()`
   - Fallback: `'https://mdmidia.com.br/cpf-validate.php'`
   
2. **FooterCodeSiteDefinitivoCompleto.js:1024** - `validatePlaca()`
   - Fallback: `'https://mdmidia.com.br/placa-validate.php'`
   
3. **FooterCodeSiteDefinitivoCompleto.js:1518** - Injeção `webflow_injection_limpo.js`
   - Fallback: `'https://mdmidia.com.br/webflow_injection_limpo.js'`
   
4. **webflow_injection_limpo.js:2117** - Validação de placa
   - Fallback: `'https://mdmidia.com.br/placa-validate.php'`
   
5. **webflow_injection_limpo.js:2795, 2810** - Código legado
   - URLs hardcoded: `'https://mdmidia.com.br/add_tra...'` e `'https://mdmidia.com.br/add_we...'`

---

## 🟡 PROBLEMAS MÉDIOS (6)

### Fallbacks DEV/PROD Hardcoded

6. **FooterCodeSiteDefinitivoCompleto.js:342** - `sendLogToProfessionalSystem()`
   - Fallback: `'https://dev.bssegurosimediato.com.br'`
   
7. **FooterCodeSiteDefinitivoCompleto.js:1594** - Injeção `MODAL_WHATSAPP_DEFINITIVO.js`
   - Fallback: `'https://dev.bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js'`
   
8. **MODAL_WHATSAPP_DEFINITIVO.js:158-160** - `getEndpointUrl()` fallback
   - Fallback: `'https://dev.bssegurosimediato.com.br'` ou `'https://bssegurosimediato.com.br'`
   
9. **MODAL_WHATSAPP_DEFINITIVO.js:721-722** - `sendAdminEmailNotification()` fallback
   - Fallback: `'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php'` ou PROD
   
10. **add_flyingdonkeys.php:38-49** - Lista CORS hardcoded
    - Lista de origens permitidas hardcoded (deveria usar `getCorsOrigins()`)
    
11. **add_webflow_octa.php:23-34** - Lista CORS hardcoded
    - Lista de origens permitidas hardcoded (deveria usar `getCorsOrigins()`)

---

## ✅ FALLBACKS ACEITÁVEIS (Não Corrigir)

- `config.php:62-66` - Fallback em `getBaseUrl()` (aceitável - último recurso)
- `config_env.js.php:18` - Fallback em variável (aceitável - último recurso)
- `ProfessionalLogger.php:594-597` - Fallback em variável (aceitável - último recurso)

---

## 📊 ESTATÍSTICAS

- **Total de Problemas:** 11
- **Críticos (URLs Externas):** 5
- **Médios (Fallbacks DEV/PROD):** 6
- **Arquivos Afetados:** 4 arquivos principais

---

## 🎯 PRIORIDADE DE CORREÇÃO

### Prioridade 1 (Crítico)
- Substituir todos os fallbacks para `mdmidia.com.br`
- Remover código legado em `webflow_injection_limpo.js`

### Prioridade 2 (Médio)
- Substituir fallbacks DEV/PROD por `detectServerBaseUrl()`
- Usar `getCorsOrigins()` em `add_flyingdonkeys.php` e `add_webflow_octa.php`

---

**Documento criado em:** 10/11/2025

