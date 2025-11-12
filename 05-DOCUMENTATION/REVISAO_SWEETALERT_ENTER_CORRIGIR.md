# 🔍 REVISÃO: SweetAlert - Funcionalidade ENTER aciona "Corrigir"

**Data:** 12/11/2025  
**Status:** ✅ **REVISÃO CONCLUÍDA**  
**Tipo:** Comando de Investigação (apenas análise, sem modificação)

---

## 🎯 OBJETIVO DA REVISÃO

Revisar todas as chamadas do SweetAlert para verificar quais não respeitam a funcionalidade de que, quando o SweetAlert está aberto, se o usuário apertar "ENTER", o botão "CORRIGIR" deve ser acionado.

---

## 📋 COMPORTAMENTO ESPERADO DO SWEETALERT2

### **Como funciona o ENTER no SweetAlert2:**

1. **Por padrão:** O ENTER aciona o botão `confirmButton` (botão de confirmação)
2. **`reverseButtons: true`:** Apenas inverte a ordem **visual** dos botões, mas o ENTER continua acionando o `confirmButton`
3. **Para ENTER acionar "Corrigir":** O botão "Corrigir" deve ser definido como `confirmButtonText`

### **Configuração Correta:**

```javascript
Swal.fire({
  confirmButtonText: 'Corrigir',  // ✅ ENTER aciona este botão
  cancelButtonText: 'Não Corrigir',
  reverseButtons: true  // Inverte ordem visual, mas ENTER continua no confirmButton
})
```

### **Configuração Incorreta:**

```javascript
Swal.fire({
  confirmButtonText: 'Prosseguir assim mesmo',  // ❌ ENTER aciona este botão
  cancelButtonText: 'Corrigir',  // ❌ ENTER NÃO aciona este botão
  reverseButtons: true
})
```

---

## 🔍 ANÁLISE DETALHADA DAS CHAMADAS

### **1. Função Helper: `saWarnConfirmCancel`**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js` (linha 2206)

**Configuração:**
```javascript
function saWarnConfirmCancel(opts) {
  return Swal.fire(Object.assign({
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Corrigir',  // ✅ CORRETO
    cancelButtonText: 'Não',
    reverseButtons: true,
    allowOutsideClick: false,
    allowEscapeKey: true
  }, opts));
}
```

**Status:** ✅ **CORRETO**
- `confirmButtonText: 'Corrigir'` → ENTER aciona "Corrigir"
- `reverseButtons: true` → Inverte ordem visual, mas ENTER continua no confirmButton

**Uso:**
- Linha 2239: CPF inválido
- Linha 2302: CEP inválido
- Linha 2322: Placa inválida
- Linha 2357: DDD incompleto
- Linha 2366: DDD inválido
- Linha 2384: DDD inválido (blur celular)
- Linha 2393: Celular incompleto
- Linha 2408: Celular inválido (API)
- Linha 2468: E-mail inválido (SafetyMails)
- Linha 2478: E-mail não verificado (SafetyMails)

**Conclusão:** ✅ Todas as chamadas usando `saWarnConfirmCancel` estão corretas.

---

### **2. Função Helper: `saInfoConfirmCancel`**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js` (linha 2217)

**Configuração:**
```javascript
function saInfoConfirmCancel(opts) {
  return Swal.fire(Object.assign({
    icon: 'info',
    showCancelButton: true,
    confirmButtonText: 'Prosseguir assim mesmo',  // ❌ INCORRETO
    cancelButtonText: 'Corrigir',  // ❌ ENTER NÃO aciona este botão
    reverseButtons: true,
    allowOutsideClick: false,
    allowEscapeKey: true
  }, opts));
}
```

**Status:** ❌ **INCORRETO**
- `confirmButtonText: 'Prosseguir assim mesmo'` → ENTER aciona "Prosseguir assim mesmo"
- `cancelButtonText: 'Corrigir'` → ENTER **NÃO** aciona "Corrigir"
- `reverseButtons: true` → Apenas inverte ordem visual, mas ENTER continua no confirmButton

**Uso:**
- Linha 2272: CPF não encontrado (API PH3A)

**Problema:** Quando o usuário pressiona ENTER, o botão "Prosseguir assim mesmo" é acionado, não "Corrigir".

**Correção Necessária:** Trocar `confirmButtonText` e `cancelButtonText` para que "Corrigir" seja o botão de confirmação.

---

### **3. Chamada Direta: Submit com Dados Inválidos**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js` (linha 2632)

**Configuração:**
```javascript
Swal.fire({
  icon: 'info',
  title: 'Atenção!',
  html: "...",
  showCancelButton: true,
  confirmButtonText: 'Prosseguir assim mesmo',  // ❌ INCORRETO
  cancelButtonText: 'Corrigir',  // ❌ ENTER NÃO aciona este botão
  reverseButtons: true,
  allowOutsideClick: false,
  allowEscapeKey: true
})
```

**Status:** ❌ **INCORRETO**
- `confirmButtonText: 'Prosseguir assim mesmo'` → ENTER aciona "Prosseguir assim mesmo"
- `cancelButtonText: 'Corrigir'` → ENTER **NÃO** aciona "Corrigir"

**Problema:** Quando o usuário pressiona ENTER, o botão "Prosseguir assim mesmo" é acionado, não "Corrigir".

**Correção Necessária:** Trocar `confirmButtonText` e `cancelButtonText` para que "Corrigir" seja o botão de confirmação.

---

### **4. Chamada Direta: Erro de Rede**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js` (linha 2708)

**Configuração:**
```javascript
Swal.fire({
  icon: 'info',
  title: 'Não foi possível validar agora',
  html: 'Deseja prosseguir assim mesmo?',
  showCancelButton: true,
  confirmButtonText: 'Prosseguir assim mesmo',  // ❌ INCORRETO
  cancelButtonText: 'Corrigir',  // ❌ ENTER NÃO aciona este botão
  reverseButtons: true,
  allowOutsideClick: false,
  allowEscapeKey: true
})
```

**Status:** ❌ **INCORRETO**
- `confirmButtonText: 'Prosseguir assim mesmo'` → ENTER aciona "Prosseguir assim mesmo"
- `cancelButtonText: 'Corrigir'` → ENTER **NÃO** aciona "Corrigir"

**Problema:** Quando o usuário pressiona ENTER, o botão "Prosseguir assim mesmo" é acionado, não "Corrigir".

**Correção Necessária:** Trocar `confirmButtonText` e `cancelButtonText` para que "Corrigir" seja o botão de confirmação.

---

### **5. Chamada Direta: Validação RPA (`webflow_injection_limpo.js`)**

**Localização:** `webflow_injection_limpo.js` (linha 3115)

**Configuração:**
```javascript
const result = await Swal.fire({
  icon: 'info',
  title: 'Atenção!',
  html: "...",
  showCancelButton: true,
  confirmButtonText: 'Prosseguir assim mesmo',  // ❌ INCORRETO
  cancelButtonText: 'Corrigir',  // ❌ ENTER NÃO aciona este botão
  reverseButtons: true,
  allowOutsideClick: false,
  allowEscapeKey: true
});
```

**Status:** ❌ **INCORRETO**
- `confirmButtonText: 'Prosseguir assim mesmo'` → ENTER aciona "Prosseguir assim mesmo"
- `cancelButtonText: 'Corrigir'` → ENTER **NÃO** aciona "Corrigir"

**Problema:** Quando o usuário pressiona ENTER, o botão "Prosseguir assim mesmo" é acionado, não "Corrigir".

**Correção Necessária:** Trocar `confirmButtonText` e `cancelButtonText` para que "Corrigir" seja o botão de confirmação.

---

### **6. Chamada Especial: E-mail Inválido (Local)**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js` (linha 2439)

**Configuração:**
```javascript
saWarnConfirmCancel({
  title: 'E-mail inválido',
  html: `...`,
  cancelButtonText: 'Não Corrigir',
  confirmButtonText: 'Corrigir'  // ✅ CORRETO (sobrescreve padrão)
}).then(r=>{ if (r.isConfirmed) $EMAIL.focus(); });
```

**Status:** ✅ **CORRETO**
- `confirmButtonText: 'Corrigir'` → ENTER aciona "Corrigir"
- `cancelButtonText: 'Não Corrigir'` → Sobrescreve o padrão "Não" da função helper

**Conclusão:** Esta chamada está correta, pois sobrescreve o padrão da função helper.

---

## 📊 RESUMO DA ANÁLISE

### **✅ Chamadas CORRETAS (ENTER aciona "Corrigir"):**

| Localização | Função/Chamada | Status |
|------------|----------------|--------|
| `FooterCodeSiteDefinitivoCompleto.js:2206` | `saWarnConfirmCancel` (helper) | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2239` | CPF inválido | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2302` | CEP inválido | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2322` | Placa inválida | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2357` | DDD incompleto | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2366` | DDD inválido | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2384` | DDD inválido (blur) | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2393` | Celular incompleto | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2408` | Celular inválido (API) | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2439` | E-mail inválido (local) | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2468` | E-mail inválido (SafetyMails) | ✅ CORRETO |
| `FooterCodeSiteDefinitivoCompleto.js:2478` | E-mail não verificado (SafetyMails) | ✅ CORRETO |

**Total:** 12 chamadas corretas

---

### **❌ Chamadas INCORRETAS (ENTER NÃO aciona "Corrigir"):**

| Localização | Função/Chamada | Problema | Correção Necessária |
|------------|----------------|----------|---------------------|
| `FooterCodeSiteDefinitivoCompleto.js:2217` | `saInfoConfirmCancel` (helper) | ENTER aciona "Prosseguir assim mesmo" | Trocar `confirmButtonText` e `cancelButtonText` |
| `FooterCodeSiteDefinitivoCompleto.js:2272` | CPF não encontrado (API PH3A) | Usa `saInfoConfirmCancel` incorreto | Corrigir função helper ou sobrescrever |
| `FooterCodeSiteDefinitivoCompleto.js:2632` | Submit com dados inválidos | ENTER aciona "Prosseguir assim mesmo" | Trocar `confirmButtonText` e `cancelButtonText` |
| `FooterCodeSiteDefinitivoCompleto.js:2708` | Erro de rede | ENTER aciona "Prosseguir assim mesmo" | Trocar `confirmButtonText` e `cancelButtonText` |
| `webflow_injection_limpo.js:3115` | Validação RPA | ENTER aciona "Prosseguir assim mesmo" | Trocar `confirmButtonText` e `cancelButtonText` |

**Total:** 5 chamadas incorretas

---

## 🎯 CONCLUSÃO DA REVISÃO

### **Resumo:**

**Chamadas Corretas:** 12 ✅  
**Chamadas Incorretas:** 5 ❌

### **Problemas Identificados:**

1. **Função Helper `saInfoConfirmCancel`:**
   - ❌ `confirmButtonText: 'Prosseguir assim mesmo'` → ENTER aciona este botão
   - ❌ `cancelButtonText: 'Corrigir'` → ENTER **NÃO** aciona este botão
   - **Impacto:** 1 chamada afetada (CPF não encontrado)

2. **Chamadas Diretas com "Prosseguir assim mesmo":**
   - ❌ 3 chamadas diretas têm `confirmButtonText: 'Prosseguir assim mesmo'`
   - ❌ ENTER aciona "Prosseguir assim mesmo" em vez de "Corrigir"
   - **Impacto:** 3 chamadas afetadas (submit inválido, erro de rede, validação RPA)

### **Correções Necessárias:**

1. **Corrigir função helper `saInfoConfirmCancel`:**
   - Trocar `confirmButtonText` e `cancelButtonText`
   - Ou criar nova função helper específica para casos onde "Corrigir" deve ser o botão de confirmação

2. **Corrigir chamadas diretas:**
   - Trocar `confirmButtonText` e `cancelButtonText` em todas as chamadas diretas
   - Ajustar lógica de `result.isConfirmed` para refletir a mudança

3. **Considerações:**
   - Quando "Corrigir" é o botão de confirmação, `result.isConfirmed` será `true` quando o usuário escolher "Corrigir"
   - Quando "Prosseguir assim mesmo" é o botão de confirmação, `result.isConfirmed` será `true` quando o usuário escolher "Prosseguir assim mesmo"
   - **Atenção:** Trocar os botões pode afetar a lógica existente que verifica `result.isConfirmed`

---

## 📋 RECOMENDAÇÕES

### **Para Implementação:**

1. **Criar nova função helper para casos onde "Corrigir" deve ser confirmButton:**
   ```javascript
   function saInfoCorrigirCancel(opts) {
     return Swal.fire(Object.assign({
       icon: 'info',
       showCancelButton: true,
       confirmButtonText: 'Corrigir',  // ✅ ENTER aciona "Corrigir"
       cancelButtonText: 'Prosseguir assim mesmo',
       reverseButtons: true,
       allowOutsideClick: false,
       allowEscapeKey: true
     }, opts));
   }
   ```

2. **Corrigir chamadas diretas:**
   - Trocar `confirmButtonText` e `cancelButtonText`
   - Inverter lógica de `result.isConfirmed` (se necessário)

3. **Manter função `saInfoConfirmCancel` para casos onde "Prosseguir assim mesmo" deve ser confirmButton:**
   - Manter função existente para casos onde o comportamento atual é desejado
   - Documentar claramente quando usar cada função

---

**Revisão realizada por:** Assistente AI  
**Data:** 12/11/2025  
**Status:** ✅ **REVISÃO CONCLUÍDA**  
**Tipo:** Investigação (sem modificação de código)

