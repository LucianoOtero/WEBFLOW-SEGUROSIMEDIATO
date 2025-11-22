# 🔧 SOLUÇÃO: Erro APILAYER_KEY não está definido

**Data:** 21/11/2025  
**Status:** ⚠️ **CORREÇÃO NECESSÁRIA NO WEBFLOW**  
**Erro:** `[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido. Carregue config_env.js.php ANTES deste script.`

---

## 🔍 PROBLEMA IDENTIFICADO

**Erro no Console:**
```
[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido. Carregue config_env.js.php ANTES deste script.
```

**Causa Raiz:**
- O script `config_env.js.php` **NÃO está sendo carregado** no Webflow Footer Code
- Ou está sendo carregado **DEPOIS** de `FooterCodeSiteDefinitivoCompleto.js`
- O código JavaScript precisa das variáveis injetadas pelo PHP antes de executar

---

## ✅ SOLUÇÃO: Atualizar Footer Code no Webflow

### **Passo 1: Acessar Webflow Designer**

1. Acesse o Webflow Designer
2. Vá em **Settings** → **Custom Code**
3. Localize a seção **Footer Code**

### **Passo 2: Verificar Código Atual**

**Código INCORRETO (causa o erro):**
```html
<!-- ERRADO: FooterCodeSiteDefinitivoCompleto.js sem config_env.js.php -->
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

### **Passo 3: Substituir por Código Correto**

**Código CORRETO (copie e cole):**
```html
<!-- 1. Carregar variáveis de ambiente do PHP (OBRIGATÓRIO - ANTES do script principal) -->
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>

<!-- 2. Carregar script principal (usa variáveis do window injetadas pelo PHP) -->
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

### **Passo 4: Salvar e Publicar**

1. Clique em **Save** no Webflow
2. Publique o site (ou faça preview)
3. Limpe o cache do navegador (Ctrl+F5 ou Cmd+Shift+R)
4. Recarregue a página

---

## ⚠️ ORDEM CRÍTICA

**A ordem dos scripts é CRÍTICA:**

1. ✅ **PRIMEIRO:** `<script src="...config_env.js.php"></script>`
2. ✅ **SEGUNDO:** `<script src="...FooterCodeSiteDefinitivoCompleto.js"></script>`

**Se a ordem estiver invertida, o erro continuará ocorrendo!**

---

## 🧪 VERIFICAÇÃO

Após atualizar, verifique no console do navegador:

**✅ Sucesso (sem erros):**
- Não deve aparecer erro sobre `APILAYER_KEY`
- Não deve aparecer erro sobre outras variáveis do PHP
- Console deve estar limpo (apenas erros de extensões do navegador, se houver)

**❌ Se ainda aparecer erro:**
- Verifique se `config_env.js.php` está ANTES de `FooterCodeSiteDefinitivoCompleto.js`
- Limpe o cache do navegador
- Limpe o cache do Cloudflare
- Recarregue a página

---

## 📋 CHECKLIST

- [ ] Script `config_env.js.php` adicionado ANTES de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Ordem dos scripts está correta (config_env primeiro)
- [ ] Código salvo no Webflow
- [ ] Site publicado ou preview atualizado
- [ ] Cache do navegador limpo
- [ ] Cache do Cloudflare limpo (se aplicável)
- [ ] Página recarregada
- [ ] Console verificado (sem erros sobre variáveis)

---

## 🔍 VERIFICAÇÃO ADICIONAL

### Verificar se `config_env.js.php` está acessível

No navegador, acesse diretamente:
```
https://dev.bssegurosimediato.com.br/config_env.js.php
```

**Resultado Esperado:**
```javascript
window.APP_BASE_URL = "https://dev.bssegurosimediato.com.br";
window.APP_ENVIRONMENT = "development";
window.APILAYER_KEY = "dce92fa84152098a3b5b7b8db24debbc";
window.SAFETY_TICKET = "05bf2ec47128ca0b917f8b955bada1bd3cadd47e";
window.SAFETY_API_KEY = "20a7a1c297e39180bd80428ac13c363e882a531f";
window.VIACEP_BASE_URL = "https://viacep.com.br";
window.APILAYER_BASE_URL = "https://apilayer.net";
window.SAFETYMAILS_OPTIN_BASE = "https://optin.safetymails.com";
window.RPA_API_BASE_URL = "https://rpaimediatoseguros.com.br";
window.SAFETYMAILS_BASE_DOMAIN = "safetymails.com";
```

**Se retornar 404 ou erro:**
- Arquivo não está no servidor
- Verificar se arquivo foi copiado corretamente para o servidor DEV

---

## 🚨 IMPORTANTE

**Os outros erros no console (content.js, CookieYes, i18next) são de extensões do navegador e não afetam o funcionamento do site.** O erro crítico que está travando tudo é o `APILAYER_KEY não está definido`, que será resolvido ao adicionar o `config_env.js.php` antes do script principal.

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

