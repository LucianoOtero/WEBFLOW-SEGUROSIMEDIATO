# 📋 INSTRUÇÕES: Configurar Data Attributes no Webflow

**Data:** 10/11/2025  
**Objetivo:** Configurar data attributes no Webflow Footer Code para eliminar polling e melhorar performance

---

## 🎯 O QUE FAZER

### Passo 1: Acessar Webflow Footer Code

1. Acesse o **Webflow Dashboard**
2. Vá em **Site Settings** → **Custom Code** → **Footer Code**

---

### Passo 2: Modificar o Script Tag

**ANTES (código atual):**
```html
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" defer></script>
```

**DEPOIS (com data attributes):**
```html
<script 
  src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://dev.bssegurosimediato.com.br"
  data-app-environment="development">
</script>
```

---

## 🌍 CONFIGURAÇÃO POR AMBIENTE

### Ambiente DEV (Desenvolvimento)

```html
<script 
  src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://dev.bssegurosimediato.com.br"
  data-app-environment="development">
</script>
```

### Ambiente PROD (Produção)

```html
<script 
  src="https://bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://bssegurosimediato.com.br"
  data-app-environment="production">
</script>
```

---

## ✅ VERIFICAÇÃO

Após modificar, verifique no console do navegador:

1. Abra o DevTools (F12)
2. Vá na aba Console
3. Procure por: `[CONFIG] ✅ Variáveis de ambiente carregadas`
4. Deve mostrar:
   ```
   [CONFIG] ✅ Variáveis de ambiente carregadas: {
     APP_BASE_URL: "https://dev.bssegurosimediato.com.br",
     APP_ENVIRONMENT: "development"
   }
   ```

---

## ⚠️ IMPORTANTE

- ✅ **data-app-base-url** é **OBRIGATÓRIO**
- ⚠️ **data-app-environment** é opcional (padrão: "development")
- ✅ Use a URL correta para cada ambiente (dev ou prod)
- ✅ Mantenha o atributo `defer` no script tag

---

## 🔧 TROUBLESHOOTING

### Erro: "APP_BASE_URL não está definido"

**Causa:** Data attribute não foi adicionado ou está incorreto

**Solução:**
1. Verifique se `data-app-base-url` está presente no script tag
2. Verifique se o valor está correto (sem aspas extras, sem espaços)
3. Verifique se está no Footer Code (não no Head Code)

### Erro: "data-app-base-url não está definido no script tag"

**Causa:** Script tag não tem o data attribute

**Solução:**
1. Adicione `data-app-base-url="https://dev.bssegurosimediato.com.br"` ao script tag
2. Publique o site no Webflow

---

**Status:** ✅ **INSTRUÇÕES COMPLETAS**

