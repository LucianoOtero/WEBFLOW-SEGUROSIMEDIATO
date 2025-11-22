# 📋 Instruções Visuais - Atualização do Webflow
**Data:** 21/11/2025  
**Versão:** 1.0.0  
**Ambiente:** DEV

---

## 🎯 Objetivo

Atualizar o Footer Code no Webflow para:
1. Adicionar carregamento de `config_env.js.php` ANTES do script principal
2. Remover 8 `data-attributes` que foram movidos para PHP
3. Manter apenas 9 `data-attributes` necessários

---

## 📍 Onde Fazer a Alteração

1. Acesse o **Webflow Designer**
2. Clique em **Project Settings** (ícone de engrenagem no canto inferior esquerdo)
3. Vá para a aba **Custom Code**
4. Localize a seção **Footer Code**
5. Encontre o script tag que carrega `FooterCodeSiteDefinitivoCompleto.js`

---

## 🔍 Como Identificar o Script Tag Atual

Procure por algo assim no Footer Code:

```html
<script 
    src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    data-app-base-url="..."
    data-apilayer-key="..."  ← ESTE precisa ser REMOVIDO
    data-safety-ticket="..."  ← ESTE precisa ser REMOVIDO
    ... (outros data-attributes)
></script>
```

---

## ✂️ O Que REMOVER

Remova os seguintes 8 `data-attributes` do script tag (se estiverem presentes):

1. ❌ `data-apilayer-key="dce92fa84152098a3b5b7b8db24debbc"`
2. ❌ `data-safety-ticket="05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`
3. ❌ `data-safety-api-key="20a7a1c297e39180bd80428ac13c363e882a531f"`
4. ❌ `data-viacep-base-url="https://viacep.com.br"`
5. ❌ `data-apilayer-base-url="https://apilayer.net"`
6. ❌ `data-safetymails-optin-base="https://optin.safetymails.com"`
7. ❌ `data-rpa-api-base-url="https://rpaimediatoseguros.com.br"`
8. ❌ `data-safetymails-base-domain="safetymails.com"`

**Por quê?** Esses parâmetros agora são carregados automaticamente pelo `config_env.js.php` a partir das variáveis de ambiente do servidor.

---

## ➕ O Que ADICIONAR

### Passo 1: Adicionar Script do config_env.js.php

**ANTES** do script tag do `FooterCodeSiteDefinitivoCompleto.js`, adicione:

```html
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
```

**⚠️ CRÍTICO:** Este script DEVE estar ANTES do `FooterCodeSiteDefinitivoCompleto.js`. A ordem incorreta causará erros.

---

## ✅ Código Final Completo para DEV

Copie e cole este código completo no Footer Code do Webflow:

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

---

## 📋 Checklist de Atualização

Use este checklist para garantir que tudo está correto:

- [ ] Script `config_env.js.php` adicionado ANTES de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Removido `data-apilayer-key` do script tag
- [ ] Removido `data-safety-ticket` do script tag
- [ ] Removido `data-safety-api-key` do script tag
- [ ] Removido `data-viacep-base-url` do script tag
- [ ] Removido `data-apilayer-base-url` do script tag
- [ ] Removido `data-safetymails-optin-base` do script tag
- [ ] Removido `data-rpa-api-base-url` do script tag
- [ ] Removido `data-safetymails-base-domain` do script tag
- [ ] Mantidos os 9 `data-attributes` necessários:
  - [ ] `data-app-base-url`
  - [ ] `data-app-environment`
  - [ ] `data-rpa-enabled`
  - [ ] `data-use-phone-api`
  - [ ] `data-validar-ph3a`
  - [ ] `data-success-page-url`
  - [ ] `data-whatsapp-api-base`
  - [ ] `data-whatsapp-phone`
  - [ ] `data-whatsapp-default-message`
- [ ] Clicado em **Save** no Webflow
- [ ] Publicado o site no Webflow

---

## 🔍 Como Verificar se Está Funcionando

### 1. Após Publicar no Webflow

1. Acesse o site publicado no navegador
2. Abra o **Console do Desenvolvedor** (F12 ou Ctrl+Shift+I)
3. Vá para a aba **Console**

### 2. Verificar Variáveis do PHP

No console, digite e pressione Enter:

```javascript
// Verificar variáveis injetadas pelo PHP (config_env.js.php)
console.log('APILAYER_KEY:', window.APILAYER_KEY);
console.log('SAFETY_TICKET:', window.SAFETY_TICKET);
console.log('SAFETY_API_KEY:', window.SAFETY_API_KEY);
console.log('VIACEP_BASE_URL:', window.VIACEP_BASE_URL);
console.log('RPA_API_BASE_URL:', window.RPA_API_BASE_URL);
```

**Resultado Esperado:**
- ✅ Todas as variáveis devem ter valores (não devem ser `undefined` ou `null`)
- ✅ Não deve haver erros no console

### 3. Verificar Variáveis do Webflow (Data Attributes)

No console, digite e pressione Enter:

```javascript
// Verificar variáveis do Webflow (data-attributes)
console.log('APP_BASE_URL:', window.APP_BASE_URL);
console.log('APP_ENVIRONMENT:', window.APP_ENVIRONMENT);
console.log('rpaEnabled:', window.rpaEnabled);
console.log('USE_PHONE_API:', window.USE_PHONE_API);
```

**Resultado Esperado:**
- ✅ Todas as variáveis devem ter valores
- ✅ Não deve haver erros no console

### 4. Verificar se Há Erros

**Se `config_env.js.php` não foi carregado antes, você verá:**
```
[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido. Carregue config_env.js.php ANTES deste script.
```

**Solução:** Verifique se o script `config_env.js.php` está ANTES de `FooterCodeSiteDefinitivoCompleto.js` no Footer Code.

**Se algum `data-attribute` estiver faltando, você verá:**
```
[CONFIG] ERRO CRÍTICO: data-app-base-url não está definido no script tag. Variável APP_BASE_URL é obrigatória.
```

**Solução:** Adicione o `data-attribute` faltante ao script tag.

---

## ⚠️ Erros Comuns e Soluções

### Erro 1: "APILAYER_KEY não está definido"

**Causa:** `config_env.js.php` não foi carregado ou foi carregado DEPOIS de `FooterCodeSiteDefinitivoCompleto.js`

**Solução:**
1. Verifique a ordem dos scripts no Footer Code
2. Certifique-se de que `config_env.js.php` está ANTES de `FooterCodeSiteDefinitivoCompleto.js`
3. Publique novamente no Webflow

### Erro 2: Variáveis do PHP são `undefined`

**Causa:** `config_env.js.php` não está sendo carregado ou há erro no servidor

**Solução:**
1. Verifique se o arquivo existe: `https://dev.bssegurosimediato.com.br/config_env.js.php`
2. Abra o arquivo diretamente no navegador para verificar se há erros
3. Verifique a aba **Network** no DevTools para ver se o arquivo está sendo carregado

### Erro 3: "data-app-base-url não está definido"

**Causa:** `data-attribute` foi removido acidentalmente

**Solução:**
1. Adicione de volta o `data-attribute` faltante ao script tag
2. Publique novamente no Webflow

---

## 📸 Exemplo Visual da Estrutura

### ❌ Estrutura INCORRETA (Antiga)

```html
<!-- ERRADO: FooterCodeSiteDefinitivoCompleto.js carregado antes de config_env.js.php -->
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" ...></script>
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
```

### ✅ Estrutura CORRETA (Nova)

```html
<!-- 1. PRIMEIRO: Carregar variáveis do PHP -->
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>

<!-- 2. SEGUNDO: Carregar script principal (usa variáveis do window) -->
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" ...></script>
```

---

## 📊 Comparação: Antes vs. Depois

### ANTES (17 data-attributes)

```html
<script 
    src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    data-app-base-url="..."
    data-app-environment="..."
    data-rpa-enabled="..."
    data-use-phone-api="..."
    data-validar-ph3a="..."
    data-apilayer-key="..."           ← REMOVIDO
    data-safety-ticket="..."          ← REMOVIDO
    data-safety-api-key="..."         ← REMOVIDO
    data-viacep-base-url="..."        ← REMOVIDO
    data-apilayer-base-url="..."      ← REMOVIDO
    data-safetymails-optin-base="..." ← REMOVIDO
    data-rpa-api-base-url="..."       ← REMOVIDO
    data-success-page-url="..."
    data-safetymails-base-domain="..." ← REMOVIDO
    data-whatsapp-api-base="..."
    data-whatsapp-phone="..."
    data-whatsapp-default-message="..."
></script>
```

### DEPOIS (9 data-attributes + 1 script)

```html
<!-- NOVO: Script do PHP -->
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>

<script 
    src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    data-app-base-url="..."
    data-app-environment="..."
    data-rpa-enabled="..."
    data-use-phone-api="..."
    data-validar-ph3a="..."
    data-success-page-url="..."
    data-whatsapp-api-base="..."
    data-whatsapp-phone="..."
    data-whatsapp-default-message="..."
></script>
```

---

## 🚀 Passos Finais

1. ✅ Copiar código completo acima para o Footer Code do Webflow
2. ✅ Clicar em **Save**
3. ✅ Publicar o site no Webflow
4. ✅ Limpar cache do Cloudflare
5. ✅ Testar no navegador
6. ✅ Verificar console do navegador para erros

---

## 📞 Suporte

Se encontrar problemas:

1. Verifique o console do navegador para erros específicos
2. Verifique se `config_env.js.php` está sendo carregado (aba Network no DevTools)
3. Verifique se a ordem dos scripts está correta
4. Verifique se todos os 9 `data-attributes` estão presentes

---

**Última Atualização:** 21/11/2025  
**Versão:** 1.0.0

