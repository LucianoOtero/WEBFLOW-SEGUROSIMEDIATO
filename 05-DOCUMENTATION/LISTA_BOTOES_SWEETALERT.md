# 📋 LISTA: Opções de Botões de Cada SweetAlert

**Data:** 12/11/2025  
**Status:** ✅ **LISTAGEM CONCLUÍDA**  
**Tipo:** Comando de Investigação (apenas listagem, sem modificação)

---

## 🎯 OBJETIVO

Listar todas as opções de botões de cada chamada SweetAlert no projeto, incluindo:
- Texto do botão de confirmação (`confirmButtonText`)
- Texto do botão de cancelamento (`cancelButtonText`)
- Ordem dos botões (`reverseButtons`)
- Outras configurações relevantes

---

## 📋 FUNÇÕES HELPER

### **1. Função `saWarnConfirmCancel`**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js` (linha 2206)

**Configuração Padrão:**
```javascript
{
  icon: 'warning',
  showCancelButton: true,
  confirmButtonText: 'Corrigir',
  cancelButtonText: 'Não',
  reverseButtons: true,
  allowOutsideClick: false,
  allowEscapeKey: true
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (ENTER aciona este botão)
- **Botão de Cancelamento:** "Não"
- **Ordem Visual:** Invertida (`reverseButtons: true`)

---

### **2. Função `saInfoConfirmCancel`**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js` (linha 2217)

**Configuração Padrão:**
```javascript
{
  icon: 'info',
  showCancelButton: true,
  confirmButtonText: 'Prosseguir assim mesmo',
  cancelButtonText: 'Corrigir',
  reverseButtons: true,
  allowOutsideClick: false,
  allowEscapeKey: true
}
```

**Botões:**
- **Botão de Confirmação:** "Prosseguir assim mesmo" (ENTER aciona este botão)
- **Botão de Cancelamento:** "Corrigir"
- **Ordem Visual:** Invertida (`reverseButtons: true`)

---

## 📋 CHAMADAS DE SWEETALERT

### **ARQUIVO: `FooterCodeSiteDefinitivoCompleto.js`**

---

#### **1. CPF Inválido (Algoritmo)**

**Localização:** Linha 2239

**Função:** `saWarnConfirmCancel`

**Configuração:**
```javascript
{
  title: 'CPF inválido',
  html: 'Deseja corrigir?'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (padrão da função helper)
- **Botão de Cancelamento:** "Não" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo CPF (`$CPF.focus()`)

---

#### **2. CPF Não Encontrado (API PH3A)**

**Localização:** Linha 2272

**Função:** `saInfoConfirmCancel`

**Configuração:**
```javascript
{
  title: 'CPF não encontrado',
  html: 'O CPF é válido, mas não foi encontrado na nossa base de dados.<br><br>Deseja preencher os dados manualmente?'
}
```

**Botões:**
- **Botão de Confirmação:** "Prosseguir assim mesmo" (padrão da função helper)
- **Botão de Cancelamento:** "Corrigir" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Limpa campos SEXO, DATA-DE-NASCIMENTO, ESTADO-CIVIL

**⚠️ PROBLEMA:** ENTER aciona "Prosseguir assim mesmo", não "Corrigir"

---

#### **3. CEP Inválido**

**Localização:** Linha 2302

**Função:** `saWarnConfirmCancel`

**Configuração:**
```javascript
{
  title: 'CEP inválido',
  html: 'Deseja corrigir?'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (padrão da função helper)
- **Botão de Cancelamento:** "Não" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo CEP (`$CEP.focus()`)

---

#### **4. Placa Inválida**

**Localização:** Linha 2322

**Função:** `saWarnConfirmCancel`

**Configuração:**
```javascript
{
  title: 'Placa inválida',
  html: 'Deseja corrigir?'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (padrão da função helper)
- **Botão de Cancelamento:** "Não" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo PLACA (`$PLACA.focus()`)

---

#### **5. DDD Incompleto (Blur DDD)**

**Localização:** Linha 2357

**Função:** `saWarnConfirmCancel`

**Configuração:**
```javascript
{
  title: 'DDD incompleto',
  html: 'O DDD precisa ter 2 dígitos.<br><br>Deseja corrigir?'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (padrão da função helper)
- **Botão de Cancelamento:** "Não" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo DDD (`$DDD.focus()`)

---

#### **6. DDD Inválido (Blur DDD)**

**Localização:** Linha 2366

**Função:** `saWarnConfirmCancel`

**Configuração:**
```javascript
{
  title: 'DDD inválido',
  html: 'O DDD deve ter exatamente 2 dígitos.<br><br>Deseja corrigir?'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (padrão da função helper)
- **Botão de Cancelamento:** "Não" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo DDD (`$DDD.focus()`)

---

#### **7. DDD Inválido (Blur Celular)**

**Localização:** Linha 2384

**Função:** `saWarnConfirmCancel`

**Configuração:**
```javascript
{
  title: 'DDD inválido',
  html: 'O DDD precisa ter 2 dígitos.<br><br>Deseja corrigir?'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (padrão da função helper)
- **Botão de Cancelamento:** "Não" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo DDD (`$DDD.focus()`)

---

#### **8. Celular Incompleto**

**Localização:** Linha 2393

**Função:** `saWarnConfirmCancel`

**Configuração:**
```javascript
{
  title: 'Celular incompleto',
  html: 'O celular precisa ter 9 dígitos.<br><br>Deseja corrigir?'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (padrão da função helper)
- **Botão de Cancelamento:** "Não" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo CELULAR (`$CEL.focus()`)

---

#### **9. Celular Inválido (API)**

**Localização:** Linha 2408

**Função:** `saWarnConfirmCancel`

**Configuração:**
```javascript
{
  title: 'Celular inválido',
  html: `Parece que o celular informado<br><br><b>${numero}</b><br><br>não é válido.<br><br>Deseja corrigir?`
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (padrão da função helper)
- **Botão de Cancelamento:** "Não" (padrão da função helper)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo CELULAR (`$CEL.focus()`)

---

#### **10. E-mail Inválido (Validação Local)**

**Localização:** Linha 2439

**Função:** `saWarnConfirmCancel` (com sobrescrita)

**Configuração:**
```javascript
{
  title: 'E-mail inválido',
  html: `O e-mail informado:<br><br><b>${v}</b><br><br>não parece válido.<br><br>Deseja corrigir?`,
  cancelButtonText: 'Não Corrigir',  // Sobrescreve padrão
  confirmButtonText: 'Corrigir'  // Sobrescreve padrão
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (sobrescrito)
- **Botão de Cancelamento:** "Não Corrigir" (sobrescrito)
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar:** Foca no campo EMAIL (`$EMAIL.focus()`)

---

#### **11. E-mail Inválido (SafetyMails - Status INVALIDO)**

**Localização:** Linha 2468

**Função:** `saWarnConfirmCancel` (com sobrescrita)

**Configuração:**
```javascript
{
  title: 'E-mail Inválido',
  html: `O e-mail informado:<br><br><b>${v}</b><br><br>não é válido segundo nosso verificador.<br><br>Por favor, verifique se digitou corretamente ou use outro endereço de e-mail.`,
  cancelButtonText: 'Manter',
  confirmButtonText: 'Corrigir',
  icon: 'error'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (sobrescrito)
- **Botão de Cancelamento:** "Manter" (sobrescrito)
- **Ordem Visual:** Invertida (`reverseButtons: true`)
- **Ícone:** `error` (sobrescreve padrão `warning`)

**Ação ao Confirmar:** Foca no campo EMAIL (`$EMAIL.focus()`)

---

#### **12. E-mail Não Verificado (SafetyMails - Status PENDENTE)**

**Localização:** Linha 2478

**Função:** `saWarnConfirmCancel` (com sobrescrita)

**Configuração:**
```javascript
{
  title: 'E-mail Não Verificado',
  html: `Não foi possível verificar o e-mail:<br><br><b>${v}</b><br><br>O endereço pode estar correto, mas nosso verificador não conseguiu confirmá-lo no momento.<br><br>Deseja corrigir ou prosseguir com este e-mail?`,
  cancelButtonText: 'Prosseguir',
  confirmButtonText: 'Corrigir',
  icon: 'warning'
}
```

**Botões:**
- **Botão de Confirmação:** "Corrigir" (sobrescrito)
- **Botão de Cancelamento:** "Prosseguir" (sobrescrito)
- **Ordem Visual:** Invertida (`reverseButtons: true`)
- **Ícone:** `warning` (padrão da função helper)

**Ação ao Confirmar:** Foca no campo EMAIL (`$EMAIL.focus()`)

---

#### **13. Submit com Dados Inválidos**

**Localização:** Linha 2632

**Função:** Chamada direta `Swal.fire`

**Configuração:**
```javascript
{
  icon: 'info',
  title: 'Atenção!',
  html: "⚠️ Os campos CPF, CEP, PLACA, CELULAR e E-MAIL corretamente preenchidos são necessários para efetuar o cálculo do seguro.\n\n" +
        "Campos com problema:\n\n" + linhas + "\n" +
        "Caso decida prosseguir assim mesmo, um especialista entrará em contato para coletar esses dados.",
  showCancelButton: true,
  confirmButtonText: 'Prosseguir assim mesmo',
  cancelButtonText: 'Corrigir',
  reverseButtons: true,
  allowOutsideClick: false,
  allowEscapeKey: true
}
```

**Botões:**
- **Botão de Confirmação:** "Prosseguir assim mesmo" (ENTER aciona este botão)
- **Botão de Cancelamento:** "Corrigir"
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar (`result.isConfirmed`):** Processa formulário com dados inválidos (RPA ou Webflow)

**Ação ao Cancelar (`!result.isConfirmed`):** Foca no primeiro campo com erro

**⚠️ PROBLEMA:** ENTER aciona "Prosseguir assim mesmo", não "Corrigir"

---

#### **14. Erro de Rede (Catch do Submit)**

**Localização:** Linha 2708

**Função:** Chamada direta `Swal.fire`

**Configuração:**
```javascript
{
  icon: 'info',
  title: 'Não foi possível validar agora',
  html: 'Deseja prosseguir assim mesmo?',
  showCancelButton: true,
  confirmButtonText: 'Prosseguir assim mesmo',
  cancelButtonText: 'Corrigir',
  reverseButtons: true,
  allowOutsideClick: false,
  allowEscapeKey: true
}
```

**Botões:**
- **Botão de Confirmação:** "Prosseguir assim mesmo" (ENTER aciona este botão)
- **Botão de Cancelamento:** "Corrigir"
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar (`result.isConfirmed`):** Processa formulário após erro de rede (RPA ou Webflow)

**⚠️ PROBLEMA:** ENTER aciona "Prosseguir assim mesmo", não "Corrigir"

---

### **ARQUIVO: `webflow_injection_limpo.js`**

---

#### **15. Validação RPA - Dados Inválidos**

**Localização:** Linha 3115

**Função:** Chamada direta `Swal.fire`

**Configuração:**
```javascript
{
  icon: 'info',
  title: 'Atenção!',
  html: "⚠️ Os campos CPF, CEP, PLACA, CELULAR e E-MAIL corretamente preenchidos são necessários para efetuar o cálculo do seguro.\n\n" +
        "Campos com problema:\n\n" + errorLines + "\n" +
        "Caso decida prosseguir assim mesmo, um especialista entrará em contato para coletar esses dados.",
  showCancelButton: true,
  confirmButtonText: 'Prosseguir assim mesmo',
  cancelButtonText: 'Corrigir',
  reverseButtons: true,
  allowOutsideClick: false,
  allowEscapeKey: true
}
```

**Botões:**
- **Botão de Confirmação:** "Prosseguir assim mesmo" (ENTER aciona este botão)
- **Botão de Cancelamento:** "Corrigir"
- **Ordem Visual:** Invertida (`reverseButtons: true`)

**Ação ao Confirmar (`result.isConfirmed`):** Redireciona para página de sucesso (`SUCCESS_PAGE_URL`)

**Ação ao Cancelar (`!result.isConfirmed`):** Foca no primeiro campo com erro (`focusFirstErrorField`)

**⚠️ PROBLEMA:** ENTER aciona "Prosseguir assim mesmo", não "Corrigir"

---

#### **16. Erro RPA (Catch)**

**Localização:** Linha 1773

**Função:** Chamada direta `Swal.fire`

**Configuração:**
```javascript
{
  icon: 'error',
  title: 'Erro',
  text: 'Ocorreu um erro ao processar sua solicitação. Por favor, tente novamente.',
  confirmButtonText: 'OK'
}
```

**Botões:**
- **Botão de Confirmação:** "OK"
- **Botão de Cancelamento:** Não há (`showCancelButton: false` ou não definido)
- **Ordem Visual:** Padrão (não invertida)

**Ação ao Confirmar:** Apenas fecha o alerta

---

#### **17. Erro RPA (Fallback)**

**Localização:** Linha 1789

**Função:** Chamada direta `Swal.fire`

**Configuração:**
```javascript
{
  icon: 'error',
  title: 'Erro',
  text: 'Não foi possível carregar o sistema de processamento. Por favor, recarregue a página.',
  confirmButtonText: 'OK'
}
```

**Botões:**
- **Botão de Confirmação:** "OK"
- **Botão de Cancelamento:** Não há (`showCancelButton: false` ou não definido)
- **Ordem Visual:** Padrão (não invertida)

**Ação ao Confirmar:** Apenas fecha o alerta

---

## 📊 RESUMO POR TIPO DE BOTÃO

### **Botões de Confirmação:**

| Texto | Quantidade | Arquivo(s) |
|-------|-----------|------------|
| "Corrigir" | 12 | `FooterCodeSiteDefinitivoCompleto.js` |
| "Prosseguir assim mesmo" | 4 | `FooterCodeSiteDefinitivoCompleto.js` (3), `webflow_injection_limpo.js` (1) |
| "OK" | 2 | `webflow_injection_limpo.js` |

### **Botões de Cancelamento:**

| Texto | Quantidade | Arquivo(s) |
|-------|-----------|------------|
| "Não" | 9 | `FooterCodeSiteDefinitivoCompleto.js` |
| "Corrigir" | 4 | `FooterCodeSiteDefinitivoCompleto.js` (3), `webflow_injection_limpo.js` (1) |
| "Não Corrigir" | 1 | `FooterCodeSiteDefinitivoCompleto.js` |
| "Manter" | 1 | `FooterCodeSiteDefinitivoCompleto.js` |
| "Prosseguir" | 1 | `FooterCodeSiteDefinitivoCompleto.js` |

---

## 📋 RESUMO POR FUNCIONALIDADE

### **✅ SweetAlerts onde ENTER aciona "Corrigir" (12):**

1. CPF inválido (algoritmo)
2. CEP inválido
3. Placa inválida
4. DDD incompleto (blur DDD)
5. DDD inválido (blur DDD)
6. DDD inválido (blur celular)
7. Celular incompleto
8. Celular inválido (API)
9. E-mail inválido (validação local)
10. E-mail inválido (SafetyMails - INVALIDO)
11. E-mail não verificado (SafetyMails - PENDENTE)
12. *(Nenhuma outra - todas as outras têm problemas)*

### **❌ SweetAlerts onde ENTER NÃO aciona "Corrigir" (5):**

1. CPF não encontrado (API PH3A) - ENTER aciona "Prosseguir assim mesmo"
2. Submit com dados inválidos - ENTER aciona "Prosseguir assim mesmo"
3. Erro de rede (catch submit) - ENTER aciona "Prosseguir assim mesmo"
4. Validação RPA - dados inválidos - ENTER aciona "Prosseguir assim mesmo"
5. *(Erros RPA não têm botão "Corrigir" - apenas "OK")*

---

## 🎯 CONCLUSÃO

**Total de SweetAlerts analisados:** 17

**SweetAlerts com botão "Corrigir":** 16
- ✅ ENTER aciona "Corrigir": 12
- ❌ ENTER NÃO aciona "Corrigir": 4

**SweetAlerts sem botão "Corrigir":** 2 (apenas "OK")

---

**Listagem realizada por:** Assistente AI  
**Data:** 12/11/2025  
**Status:** ✅ **LISTAGEM CONCLUÍDA**  
**Tipo:** Investigação (sem modificação de código)

