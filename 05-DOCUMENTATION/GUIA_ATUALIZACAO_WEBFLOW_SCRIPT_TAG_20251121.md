# Guia de Atualização do Script Tag no Webflow
**Data:** 21/11/2025  
**Versão:** 2.0.0  
**Ambiente:** DEV e PROD  
**Última Atualização:** 21/11/2025 - Versão 2.0.0 (atualizado após mover 8 parâmetros para PHP)

---

## 📋 Objetivo

Este guia mostra como atualizar o script tag no Webflow após mover 8 parâmetros para variáveis de ambiente PHP. Agora é necessário carregar `config_env.js.php` ANTES de `FooterCodeSiteDefinitivoCompleto.js`, e apenas 9 `data-attributes` são necessários (removidos os 8 parâmetros movidos para PHP).

---

## 🎯 Onde Atualizar

No **Webflow Designer**, localize o **Footer Code** (ou **Custom Code** no footer) e encontre o script tag que carrega o arquivo `FooterCodeSiteDefinitivoCompleto.js`.

---

## ⚠️ IMPORTANTE: Ordem de Carregamento

**CRÍTICO:** `config_env.js.php` deve ser carregado **ANTES** de `FooterCodeSiteDefinitivoCompleto.js`. A ordem incorreta causará erros no console.

---

## 📝 Script Tags Completos para DEV

### Versão Formatada (Recomendada)

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

**Nota:** Os 8 parâmetros abaixo foram movidos para PHP e não precisam mais ser passados via `data-attributes`:
- `data-apilayer-key` → Agora vem de `config_env.js.php`
- `data-safety-ticket` → Agora vem de `config_env.js.php`
- `data-safety-api-key` → Agora vem de `config_env.js.php`
- `data-viacep-base-url` → Agora vem de `config_env.js.php`
- `data-apilayer-base-url` → Agora vem de `config_env.js.php`
- `data-safetymails-optin-base` → Agora vem de `config_env.js.php`
- `data-rpa-api-base-url` → Agora vem de `config_env.js.php`
- `data-safetymails-base-domain` → Agora vem de `config_env.js.php`

### Versão em Uma Linha (Alternativa)

```html
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" data-app-base-url="https://dev.bssegurosimediato.com.br" data-app-environment="development" data-rpa-enabled="false" data-use-phone-api="true" data-validar-ph3a="false" data-success-page-url="https://www.segurosimediato.com.br/sucesso" data-whatsapp-api-base="https://api.whatsapp.com" data-whatsapp-phone="551141718837" data-whatsapp-default-message="Ola.%20Quero%20fazer%20uma%20cotacao%20de%20seguro."></script>
```

---

## 📝 Script Tags Completos para PROD

### Versão Formatada (Recomendada)

```html
<!-- 1. Carregar variáveis de ambiente do PHP (OBRIGATÓRIO - ANTES do script principal) -->
<script src="https://prod.bssegurosimediato.com.br/config_env.js.php"></script>

<!-- 2. Carregar script principal (usa variáveis do window injetadas pelo PHP) -->
<script 
    src="https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    data-app-base-url="https://prod.bssegurosimediato.com.br"
    data-app-environment="production"
    data-rpa-enabled="false"
    data-use-phone-api="true"
    data-validar-ph3a="false"
    data-success-page-url="https://www.segurosimediato.com.br/sucesso"
    data-whatsapp-api-base="https://api.whatsapp.com"
    data-whatsapp-phone="551141718837"
    data-whatsapp-default-message="Ola.%20Quero%20fazer%20uma%20cotacao%20de%20seguro."
></script>
```

**⚠️ NOTA:** As variáveis movidas para PHP (`APILAYER_KEY`, `SAFETY_TICKET`, `SAFETY_API_KEY`, etc.) são carregadas automaticamente pelo `config_env.js.php` a partir das variáveis de ambiente do servidor.

---

## 📋 Tabela de Data Attributes (Atualizada)

### Data Attributes Necessários (9 parâmetros)

| Data Attribute | Tipo | Valor DEV | Descrição |
|----------------|------|-----------|-----------|
| `data-app-base-url` | String | `https://dev.bssegurosimediato.com.br` | URL base da aplicação |
| `data-app-environment` | String | `development` | Ambiente (development/production) |
| `data-rpa-enabled` | Boolean | `false` | Habilita/desabilita RPA |
| `data-use-phone-api` | Boolean | `true` | Habilita uso de API de telefone |
| `data-validar-ph3a` | Boolean | `false` | Habilita validação PH3A |
| `data-success-page-url` | String | `https://www.segurosimediato.com.br/sucesso` | URL da página de sucesso |
| `data-whatsapp-api-base` | String | `https://api.whatsapp.com` | URL base API WhatsApp |
| `data-whatsapp-phone` | String | `551141718837` | Telefone WhatsApp |
| `data-whatsapp-default-message` | String | `Ola.%20Quero%20fazer%20uma%20cotacao%20de%20seguro.` | Mensagem padrão WhatsApp (URL encoded) |

### Variáveis Movidas para PHP (8 parâmetros - NÃO precisam mais de data-attributes)

| Variável | Origem | Descrição |
|----------|--------|-----------|
| `APILAYER_KEY` | `config_env.js.php` | Chave da API Layer |
| `SAFETY_TICKET` | `config_env.js.php` | Ticket SafetyMails |
| `SAFETY_API_KEY` | `config_env.js.php` | Chave API SafetyMails |
| `VIACEP_BASE_URL` | `config_env.js.php` | URL base ViaCEP |
| `APILAYER_BASE_URL` | `config_env.js.php` | URL base API Layer |
| `SAFETYMAILS_OPTIN_BASE` | `config_env.js.php` | URL base SafetyMails Optin |
| `RPA_API_BASE_URL` | `config_env.js.php` | URL base API RPA |
| `SAFETYMAILS_BASE_DOMAIN` | `config_env.js.php` | Domínio base SafetyMails |

**Nota:** Essas 8 variáveis são carregadas automaticamente pelo `config_env.js.php` a partir das variáveis de ambiente do servidor PHP-FPM.

---

## 🔍 Como Verificar se Está Funcionando

### 1. Abrir o Console do Navegador
- Pressione `F12` ou `Ctrl+Shift+I` (Windows/Linux) ou `Cmd+Option+I` (Mac)
- Vá para a aba **Console**

### 2. Verificar Variáveis Globais
No console, digite e pressione Enter:

```javascript
// Verificar variáveis principais
console.log('APP_BASE_URL:', window.APP_BASE_URL);
console.log('APP_ENVIRONMENT:', window.APP_ENVIRONMENT);
console.log('rpaEnabled:', window.rpaEnabled);
console.log('USE_PHONE_API:', window.USE_PHONE_API);
```

### 3. Verificar se Há Erros
Se algum `data-attribute` estiver faltando, você verá um erro no console:

```
[CONFIG] ERRO CRÍTICO: data-app-base-url não está definido no script tag. Variável APP_BASE_URL é obrigatória.
```

### 4. Verificar Todos os Data Attributes
Para verificar todos os data attributes do script tag:

```javascript
const script = document.querySelector('script[src*="FooterCodeSiteDefinitivoCompleto.js"]');
console.log('Data Attributes:', script?.dataset);
```

### 5. Verificar Carregamento do config_env.js.php
Para verificar se `config_env.js.php` foi carregado corretamente:

```javascript
// Verificar se variáveis do PHP estão disponíveis
const phpVars = ['APILAYER_KEY', 'SAFETY_TICKET', 'SAFETY_API_KEY', 'VIACEP_BASE_URL', 
                 'APILAYER_BASE_URL', 'SAFETYMAILS_OPTIN_BASE', 'RPA_API_BASE_URL', 'SAFETYMAILS_BASE_DOMAIN'];
phpVars.forEach(varName => {
    if (typeof window[varName] === 'undefined' || !window[varName]) {
        console.error(`❌ ${varName} não está definido - config_env.js.php não foi carregado ou variável não está definida no PHP`);
    } else {
        console.log(`✅ ${varName}:`, window[varName]);
    }
});
```

---

## ⚠️ Importante

### Valores Booleanos
Valores booleanos devem ser strings:
- ✅ `data-rpa-enabled="false"` (correto)
- ✅ `data-rpa-enabled="true"` (correto)
- ❌ `data-rpa-enabled=false` (incorreto - sem aspas)
- ❌ `data-rpa-enabled=0` (incorreto - deve ser "false")

### Valores URL Encoded
Alguns valores já estão URL encoded (como `data-whatsapp-default-message`). Não adicione encoding adicional.

### Ordem dos Attributes
A ordem dos `data-attributes` não importa, mas é recomendado manter a ordem lógica para facilitar manutenção.

---

## 🔄 Processo de Atualização

1. **Acessar Webflow Designer**
   - Faça login no Webflow
   - Abra o projeto
   - Vá para **Project Settings** → **Custom Code**

2. **Localizar Footer Code**
   - Encontre a seção **Footer Code**
   - Localize o script tag atual do `FooterCodeSiteDefinitivoCompleto.js`

3. **Substituir Script Tag**
   - Copie o script tag completo (versão formatada recomendada)
   - Substitua o script tag antigo pelo novo
   - **IMPORTANTE:** Mantenha apenas um script tag (não duplique)

4. **Salvar e Publicar**
   - Clique em **Save**
   - Publique o site (ou faça publish apenas do código customizado)

5. **Verificar no Navegador**
   - Acesse o site publicado
   - Abra o console do navegador
   - Verifique se não há erros
   - Verifique se as variáveis estão definidas

6. **Limpar Cache**
   - Limpe o cache do Cloudflare
   - Limpe o cache do navegador (Ctrl+Shift+Delete)
   - Recarregue a página (Ctrl+F5)

---

## 📞 Suporte

Se encontrar problemas:

1. Verifique o console do navegador para erros específicos
2. Verifique se todos os `data-attributes` estão presentes
3. Verifique se os valores estão corretos (especialmente booleanos)
4. Verifique se o script está sendo carregado corretamente (aba Network no DevTools)

---

## ✅ Checklist de Atualização

- [ ] `config_env.js.php` adicionado ANTES de `FooterCodeSiteDefinitivoCompleto.js` no Webflow
- [ ] Script tag atualizado no Webflow
- [ ] Apenas 9 `data-attributes` presentes (removidos os 8 parâmetros movidos para PHP)
- [ ] Valores booleanos entre aspas (`"true"` ou `"false"`)
- [ ] URLs corretas para o ambiente (DEV ou PROD)
- [ ] Site publicado no Webflow
- [ ] Cache do Cloudflare limpo
- [ ] Console do navegador verificado (sem erros)
- [ ] Variáveis globais verificadas no console (data-attributes e variáveis do PHP)
- [ ] Variáveis do PHP (`APILAYER_KEY`, `SAFETY_TICKET`, etc.) verificadas no console
- [ ] Funcionalidades testadas (validação CPF, telefone, SafetyMails, RPA)

---

**Última Atualização:** 21/11/2025  
**Versão do Documento:** 1.0.0

