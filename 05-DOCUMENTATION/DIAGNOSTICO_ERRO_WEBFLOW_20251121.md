# 🔍 Diagnóstico: Erro no Console do Navegador

**Data:** 21/11/2025  
**Erro Reportado:** `window.novo_log is not a function` na linha 3133

---

## 🔍 Análise do Erro

### Erro Principal
```
FooterCodeSiteDefinitivoCompleto.js:3133 Uncaught TypeError: window.novo_log is not a function
```

### Causa Raiz

O erro ocorre porque:

1. **Validações das variáveis do PHP executam ANTES de `novo_log` ser definida:**
   - Linhas 137-160: Validações das 8 variáveis do PHP (`APILAYER_KEY`, `SAFETY_TICKET`, etc.)
   - Linha 597: Função `novo_log` é definida
   - Linha 674: `window.novo_log = novo_log;` (exposição global)
   - Linha 3133: Bloco `catch` tenta usar `window.novo_log`

2. **Se `config_env.js.php` não foi carregado antes:**
   - Validações nas linhas 137-160 lançam erro imediatamente
   - Código vai para o bloco `catch` na linha 3132
   - Bloco `catch` tenta usar `window.novo_log`, mas função ainda não foi definida
   - Erro: `window.novo_log is not a function`

---

## ✅ Correção Aplicada

Corrigido o bloco `catch` para verificar se `novo_log` existe antes de usar:

```javascript
} catch (error) {
  // Usar console.error diretamente porque novo_log pode não estar definida ainda
  if (typeof window.novo_log === 'function') {
    window.novo_log('ERROR', 'UNIFIED', 'Erro crítico no Footer Code Unificado:', error, 'ERROR_HANDLING', 'SIMPLE');
    window.novo_log('ERROR', 'UNIFIED', 'Stack trace:', error.stack, 'ERROR_HANDLING', 'SIMPLE');
  } else {
    console.error('[CONFIG] ERRO CRÍTICO no Footer Code Unificado:', error);
    console.error('[CONFIG] Stack trace:', error.stack);
    // Se o erro for sobre variáveis do PHP não definidas, dar instrução clara
    if (error.message && error.message.includes('config_env.js.php')) {
      console.error('[CONFIG] SOLUÇÃO: Adicione <script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script> ANTES de FooterCodeSiteDefinitivoCompleto.js no Webflow Footer Code');
    }
  }
}
```

---

## 🔍 Verificações Necessárias

### 1. Verificar se `config_env.js.php` está acessível

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
// ... outras variáveis
```

**Se retornar 404 ou erro:**
- Arquivo não está no servidor ou caminho está incorreto
- Verificar se arquivo foi copiado corretamente

### 2. Verificar Ordem dos Scripts no Webflow

**Ordem CORRETA:**
```html
<!-- 1. PRIMEIRO -->
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>

<!-- 2. SEGUNDO -->
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" ...></script>
```

**Ordem INCORRETA (causa erro):**
```html
<!-- ERRADO: FooterCodeSiteDefinitivoCompleto.js antes de config_env.js.php -->
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" ...></script>
<script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script>
```

### 3. Verificar Console do Navegador

Após corrigir a ordem, verifique se há erros sobre variáveis não definidas:

**Se aparecer:**
```
[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido. Carregue config_env.js.php ANTES deste script.
```

**Significa:** `config_env.js.php` não foi carregado antes ou não está gerando as variáveis corretamente.

---

## 🛠️ Passos para Resolver

1. **Verificar se `config_env.js.php` está acessível:**
   - Acesse `https://dev.bssegurosimediato.com.br/config_env.js.php` no navegador
   - Deve mostrar código JavaScript com variáveis

2. **Verificar ordem dos scripts no Webflow:**
   - `config_env.js.php` deve estar ANTES de `FooterCodeSiteDefinitivoCompleto.js`
   - Verificar se não há outros scripts entre eles

3. **Limpar cache:**
   - Limpar cache do Cloudflare
   - Limpar cache do navegador (Ctrl+Shift+Delete)
   - Recarregar página (Ctrl+F5)

4. **Verificar console novamente:**
   - Após correções, verificar se erros desapareceram
   - Verificar se variáveis estão disponíveis: `console.log(window.APILAYER_KEY)`

---

## 📋 Checklist de Diagnóstico

- [ ] `config_env.js.php` está acessível via navegador?
- [ ] Ordem dos scripts está correta no Webflow?
- [ ] Cache do Cloudflare foi limpo?
- [ ] Cache do navegador foi limpo?
- [ ] Página foi recarregada após mudanças?
- [ ] Console mostra variáveis do PHP disponíveis?

---

**Última Atualização:** 21/11/2025  
**Versão:** 1.0.0

