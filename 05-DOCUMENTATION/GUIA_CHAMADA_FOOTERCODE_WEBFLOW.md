# 📋 GUIA: Como Chamar FooterCodeSiteDefinitivoCompleto.js no Webflow

**Data:** 11/11/2025  
**Versão:** 2.0.0 (com Data Attributes)  
**Status:** ✅ **ATUALIZADO**

---

## 🎯 FORMA CORRETA DE CHAMADA

### ⚠️ **IMPORTANTE:** O arquivo agora **REQUER** data attributes no script tag

O `FooterCodeSiteDefinitivoCompleto.js` foi atualizado para ler variáveis de ambiente diretamente dos **data attributes** do próprio script tag, eliminando a necessidade de carregar `config_env.js.php` separadamente.

---

## 📝 CÓDIGO PARA WEBFLOW FOOTER CODE

### Ambiente DEV (Desenvolvimento)

```html
<!-- FooterCodeSiteDefinitivoCompleto.js -->
<script 
  src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://dev.bssegurosimediato.com.br"
  data-app-environment="development">
</script>

<!-- MODAL_WHATSAPP_DEFINITIVO.js -->
<script src="https://dev.bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js" defer></script>

<!-- webflow_injection_limpo.js -->
<script src="https://dev.bssegurosimediato.com.br/webflow_injection_limpo.js" defer></script>
```

### Ambiente PROD (Produção)

```html
<!-- FooterCodeSiteDefinitivoCompleto.js -->
<script 
  src="https://bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://bssegurosimediato.com.br"
  data-app-environment="production">
</script>

<!-- MODAL_WHATSAPP_DEFINITIVO.js -->
<script src="https://bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js" defer></script>

<!-- webflow_injection_limpo.js -->
<script src="https://bssegurosimediato.com.br/webflow_injection_limpo.js" defer></script>
```

---

## 🔑 ATRIBUTOS OBRIGATÓRIOS

### `data-app-base-url` (OBRIGATÓRIO)
- **Descrição:** URL base do ambiente (dev ou prod)
- **DEV:** `https://dev.bssegurosimediato.com.br`
- **PROD:** `https://bssegurosimediato.com.br`
- **⚠️ Sem este atributo, o script lançará um erro e não funcionará**

### `data-app-environment` (OPCIONAL)
- **Descrição:** Ambiente atual
- **DEV:** `development`
- **PROD:** `production`
- **Padrão:** `development` (se não especificado)

---

## 📊 COMPARAÇÃO: ANTES vs. DEPOIS

### ❌ ANTES (Forma Antiga - NÃO USAR MAIS)

```html
<!-- Forma antiga - NÃO FUNCIONA MAIS -->
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" defer></script>
```

**Problemas:**
- Requeria carregar `config_env.js.php` primeiro
- Usava polling de 3 segundos
- Mais lento e complexo

### ✅ DEPOIS (Forma Nova - USAR AGORA)

```html
<!-- Forma nova - CORRETA -->
<script 
  src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://dev.bssegurosimediato.com.br"
  data-app-environment="development">
</script>
```

**Vantagens:**
- ✅ Não precisa de `config_env.js.php`
- ✅ Variáveis disponíveis imediatamente (zero latência)
- ✅ Mais simples e rápido
- ✅ Sem polling

---

## 🔧 COMO CONFIGURAR NO WEBFLOW

### Passo 1: Acessar Webflow Dashboard
1. Acesse o **Webflow Dashboard**
2. Selecione seu site
3. Vá em **Site Settings** → **Custom Code** → **Footer Code**

### Passo 2: Adicionar o Código

**Cole o código completo abaixo no Footer Code:**

#### Para DEV:
```html
<script 
  src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://dev.bssegurosimediato.com.br"
  data-app-environment="development">
</script>
<script src="https://dev.bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js" defer></script>
<script src="https://dev.bssegurosimediato.com.br/webflow_injection_limpo.js" defer></script>
```

#### Para PROD:
```html
<script 
  src="https://bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://bssegurosimediato.com.br"
  data-app-environment="production">
</script>
<script src="https://bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js" defer></script>
<script src="https://bssegurosimediato.com.br/webflow_injection_limpo.js" defer></script>
```

### Passo 3: Publicar o Site
1. Clique em **Save** no Webflow
2. Publique o site (Publish → Publish to Site)

---

## ✅ VERIFICAÇÃO

Após configurar, verifique no console do navegador:

1. Abra o DevTools (F12)
2. Vá na aba **Console**
3. Procure por: `[CONFIG] ✅ Variáveis de ambiente carregadas`
4. Deve mostrar:
   ```
   [CONFIG] ✅ Variáveis de ambiente carregadas: {
     APP_BASE_URL: "https://dev.bssegurosimediato.com.br",
     APP_ENVIRONMENT: "development"
   }
   ```

### ✅ Se aparecer esta mensagem: **SUCESSO!**
### ❌ Se aparecer erro: Verifique os data attributes

---

## ⚠️ ERROS COMUNS E SOLUÇÕES

### Erro 1: "APP_BASE_URL não está definido - verifique data-app-base-url no script tag"

**Causa:** Data attribute `data-app-base-url` não foi adicionado ou está incorreto

**Solução:**
1. Verifique se `data-app-base-url` está presente no script tag
2. Verifique se o valor está correto (sem aspas extras, sem espaços)
3. Verifique se está no Footer Code (não no Head Code)
4. Publique o site novamente no Webflow

### Erro 2: "data-app-base-url não está definido no script tag"

**Causa:** Script tag não tem o data attribute

**Solução:**
1. Adicione `data-app-base-url="https://dev.bssegurosimediato.com.br"` ao script tag
2. Certifique-se de usar a URL correta para o ambiente (dev ou prod)
3. Publique o site no Webflow

### Erro 3: Script não carrega

**Causa:** URL do arquivo incorreta ou servidor inacessível

**Solução:**
1. Verifique se a URL está correta:
   - DEV: `https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js`
   - PROD: `https://bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js`
2. Teste a URL diretamente no navegador
3. Verifique se o arquivo foi copiado para o servidor

---

## 📋 CHECKLIST DE CONFIGURAÇÃO

- [ ] Acessei o Webflow Dashboard → Site Settings → Custom Code → Footer Code
- [ ] Adicionei o script tag com `data-app-base-url`
- [ ] Adicionei o script tag com `data-app-environment` (opcional, mas recomendado)
- [ ] Usei a URL correta para o ambiente (dev ou prod)
- [ ] Mantive o atributo `defer` no script tag
- [ ] Publiquei o site no Webflow
- [ ] Verifiquei no console do navegador que não há erros
- [ ] Confirmei que a mensagem `[CONFIG] ✅ Variáveis de ambiente carregadas` aparece

---

## 🔄 ORDEM DE CARREGAMENTO

A ordem recomendada é:

1. **FooterCodeSiteDefinitivoCompleto.js** (primeiro - define `logClassified()` e constantes)
2. **MODAL_WHATSAPP_DEFINITIVO.js** (segundo - usa `logClassified()`)
3. **webflow_injection_limpo.js** (terceiro - usa `logClassified()` e `setFieldValue()`)

**Nota:** Não é mais necessário carregar `config_env.js.php` antes.

---

## 📊 RESUMO

| Item | Valor |
|------|-------|
| **Data Attribute Obrigatório** | `data-app-base-url` |
| **Data Attribute Opcional** | `data-app-environment` |
| **Atributo Mantido** | `defer` |
| **Arquivo Removido** | `config_env.js.php` (não é mais necessário) |
| **URL DEV** | `https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js` |
| **URL PROD** | `https://bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js` |

---

## ✅ EXEMPLO COMPLETO (DEV)

```html
<!-- FooterCodeSiteDefinitivoCompleto.js - PRIMEIRO -->
<script 
  src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://dev.bssegurosimediato.com.br"
  data-app-environment="development">
</script>

<!-- MODAL_WHATSAPP_DEFINITIVO.js - SEGUNDO -->
<script src="https://dev.bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js" defer></script>

<!-- webflow_injection_limpo.js - TERCEIRO -->
<script src="https://dev.bssegurosimediato.com.br/webflow_injection_limpo.js" defer></script>
```

---

## ✅ EXEMPLO COMPLETO (PROD)

```html
<!-- FooterCodeSiteDefinitivoCompleto.js - PRIMEIRO -->
<script 
  src="https://bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://bssegurosimediato.com.br"
  data-app-environment="production">
</script>

<!-- MODAL_WHATSAPP_DEFINITIVO.js - SEGUNDO -->
<script src="https://bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js" defer></script>

<!-- webflow_injection_limpo.js - TERCEIRO -->
<script src="https://bssegurosimediato.com.br/webflow_injection_limpo.js" defer></script>
```

---

**Status:** ✅ **GUIA COMPLETO**  
**Última atualização:** 11/11/2025

