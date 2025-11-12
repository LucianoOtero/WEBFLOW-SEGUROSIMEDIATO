# 📚 REFERÊNCIA: API SAFETYMAILS

**Data:** 12/11/2025  
**Status:** ✅ **DOCUMENTADO**

---

## 🎯 OBJETIVO

Este documento serve como referência para integração com a API SafetyMails, incluindo:
- Como fazer chamadas à API
- Como interpretar respostas
- Parâmetros que definem se um email é válido ou não
- Exemplos de respostas

---

## 🔐 CREDENCIAIS

### **Ambiente de Desenvolvimento (DEV):**
- **Ticket Origem:** `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- **API Key:** `20a7a1c297e39180bd80428ac13c363e882a531f`
- **URL Base:** `https://05bf2ec47128ca0b917f8b955bada1bd3cadd47e.safetymails.com`

---

## 📡 COMO FAZER CHAMADAS À API

### **1. Preparação:**

**1.1. Calcular `code`:**
```javascript
const code = await sha1(ticket);
// Exemplo: sha1('05bf2ec47128ca0b917f8b955bada1bd3cadd47e')
```

**1.2. Construir URL:**
```javascript
const url = `https://${ticket}.safetymails.com/api/${code}`;
// Exemplo: https://05bf2ec47128ca0b917f8b955bada1bd3cadd47e.safetymails.com/api/[code]
```

**1.3. Calcular HMAC:**
```javascript
const hmac = await hmacSHA256(email, api_key);
// HMAC-SHA256 do email usando a API Key
```

### **2. Requisição:**

```javascript
const form = new FormData();
form.append('email', email);

const response = await fetch(url, {
    method: "POST",
    headers: { "Sf-Hmac": hmac },
    body: form
});
```

### **3. Processar Resposta:**

```javascript
if (!response.ok) {
    console.error(`HTTPCode ${response.status}`);
    return;
}

const data = await response.json();

if (!data.Success) {
    console.error("Response error", data);
    return;
}

// Processar dados
console.log("Response success", data);
```

---

## 📊 ESTRUTURA DA RESPOSTA

### **Campos da Resposta:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `Success` | boolean | Indica se a requisição foi bem-sucedida (não indica se email é válido) |
| `Status` | string | Status do email: `"VALIDO"`, `"PENDENTE"`, `"INVALIDO"`, etc. |
| `DomainStatus` | string | Status do domínio: `"VALIDO"`, `"UNKNOWN"`, etc. |
| `Advice` | string | Conselho/Recomendação: `"Valid"`, `"Unknown"`, etc. |
| `IdStatus` | number | ID numérico do status |
| `IdAdvice` | number | ID numérico do conselho |
| `Email` | string | Email validado |
| `Balance` | number | Saldo disponível na conta |
| `Environment` | string | Ambiente: `"PRODUCTION"`, `"DEVELOPMENT"`, etc. |
| `Method` | string | Método usado: `"NEW"`, etc. |
| `Limited` | boolean | Se a validação está limitada |
| `Public` | boolean | Se o resultado é público |
| `Mx` | string | Registros MX do domínio |
| `Referer` | string | Referer da requisição |

---

## ✅ COMO DETERMINAR SE EMAIL É VÁLIDO

### **⚠️ IMPORTANTE: `Success: true` NÃO indica email válido!**

O campo `Success: true` apenas indica que a **requisição foi bem-sucedida**, não que o email é válido.

### **Parâmetros para Determinar Validade:**

#### **1. Campo `Status` (Principal):**
- ✅ **`"VALIDO"`** → Email é válido
- ⚠️ **`"PENDENTE"`** → Status desconhecido/pendente (não é válido)
- ❌ **`"INVALIDO"** → Email é inválido
- ⚠️ Outros valores → Verificar documentação

#### **2. Campo `DomainStatus`:**
- ✅ **`"VALIDO"`** → Domínio é válido
- ⚠️ **`"UNKNOWN"`** → Domínio desconhecido (não é válido)
- ❌ **`"INVALIDO"** → Domínio é inválido

#### **3. Campo `Advice`:**
- ✅ **`"Valid"`** → Email é válido
- ⚠️ **`"Unknown"`** → Status desconhecido (não é válido)
- ❌ **`"Invalid"`** → Email é inválido

#### **4. Campo `IdStatus` (IDs Numéricos):**
- ✅ **`9000`** → Status válido
- ⚠️ **`9011`** → Status pendente/desconhecido
- ❌ Outros valores → Verificar documentação

#### **5. Campo `IdAdvice` (IDs Numéricos):**
- ✅ **`5200`** → Advice válido
- ⚠️ **`5204`** → Advice desconhecido
- ❌ Outros valores → Verificar documentação

---

## 📋 EXEMPLOS DE RESPOSTAS

### **Exemplo 1: Email Válido**

**Email:** `lrotero@gmail.com`

**Resposta:**
```json
{
  "Advice": "Valid",
  "Balance": 178825,
  "DomainStatus": "VALIDO",
  "Email": "lrotero@gmail.com",
  "Environment": "PRODUCTION",
  "IdAdvice": 5200,
  "IdStatus": 9000,
  "Limited": false,
  "Method": "NEW",
  "Mx": "",
  "Public": true,
  "Referer": "https://panel.safetymails.com/",
  "Status": "VALIDO",
  "Success": true
}
```

**Análise:**
- ✅ `Status: "VALIDO"` → Email válido
- ✅ `DomainStatus: "VALIDO"` → Domínio válido
- ✅ `Advice: "Valid"` → Conselho válido
- ✅ `IdStatus: 9000` → ID de status válido
- ✅ `IdAdvice: 5200` → ID de advice válido
- ✅ `Success: true` → Requisição bem-sucedida

**Conclusão:** ✅ **EMAIL VÁLIDO**

---

### **Exemplo 2: Email Pendente/Desconhecido**

**Email:** `lrotero@gmail1536.com`

**Resposta:**
```json
{
  "Advice": "Unknown",
  "Balance": 178825,
  "DomainStatus": "UNKNOWN",
  "Email": "lrotero@gmail1536.com",
  "Environment": "PRODUCTION",
  "IdAdvice": 5204,
  "IdStatus": 9011,
  "Limited": false,
  "Method": "NEW",
  "Mx": "",
  "Public": false,
  "Referer": "https://panel.safetymails.com/",
  "Status": "PENDENTE",
  "Success": true
}
```

**Análise:**
- ⚠️ `Status: "PENDENTE"` → Status pendente (não é válido)
- ⚠️ `DomainStatus: "UNKNOWN"` → Domínio desconhecido (não é válido)
- ⚠️ `Advice: "Unknown"` → Conselho desconhecido (não é válido)
- ⚠️ `IdStatus: 9011` → ID de status pendente
- ⚠️ `IdAdvice: 5204` → ID de advice desconhecido
- ✅ `Success: true` → Requisição bem-sucedida (mas email não é válido!)

**Conclusão:** ⚠️ **EMAIL NÃO VÁLIDO** (Status pendente/desconhecido)

---

## 🔍 LÓGICA DE VALIDAÇÃO RECOMENDADA

### **Função de Validação:**

```javascript
function isEmailValidSafetyMails(data) {
  // Verificar se requisição foi bem-sucedida
  if (!data || !data.Success) {
    return false;
  }
  
  // Verificar Status (principal)
  if (data.Status === 'VALIDO') {
    return true;
  }
  
  // Verificar DomainStatus
  if (data.DomainStatus === 'VALIDO') {
    return true;
  }
  
  // Verificar Advice
  if (data.Advice === 'Valid') {
    return true;
  }
  
  // Verificar IdStatus
  if (data.IdStatus === 9000) {
    return true;
  }
  
  // Verificar IdAdvice
  if (data.IdAdvice === 5200) {
    return true;
  }
  
  // Se nenhum indicador de válido, considerar não válido
  return false;
}
```

### **Validação Simplificada (Recomendada):**

```javascript
function isEmailValidSafetyMails(data) {
  if (!data || !data.Success) {
    return false;
  }
  
  // Verificar Status principal
  return data.Status === 'VALIDO';
}
```

---

## ⚠️ CÓDIGOS DE STATUS CONHECIDOS

### **Status (String):**
- `"VALIDO"` → Email válido
- `"PENDENTE"` → Status pendente/desconhecido
- `"INVALIDO"` → Email inválido
- (Outros valores podem existir - verificar documentação oficial)

### **DomainStatus (String):**
- `"VALIDO"` → Domínio válido
- `"UNKNOWN"` → Domínio desconhecido
- `"INVALIDO"` → Domínio inválido
- (Outros valores podem existir - verificar documentação oficial)

### **Advice (String):**
- `"Valid"` → Email válido
- `"Unknown"` → Status desconhecido
- `"Invalid"` → Email inválido
- (Outros valores podem existir - verificar documentação oficial)

### **IdStatus (Number):**
- `9000` → Status válido
- `9011` → Status pendente/desconhecido
- (Outros valores podem existir - verificar documentação oficial)

### **IdAdvice (Number):**
- `5200` → Advice válido
- `5204` → Advice desconhecido
- (Outros valores podem existir - verificar documentação oficial)

---

## 🔧 IMPLEMENTAÇÃO NO CÓDIGO

### **Código Atual:**

```javascript
const data = await response.json();
return data.Success ? data : null;
```

**Problema:** Retorna dados mesmo quando `Status !== "VALIDO"`

### **Código Recomendado:**

```javascript
const data = await response.json();

if (!data.Success) {
    return null;
}

// Verificar se email é realmente válido
if (data.Status === 'VALIDO') {
    return data;
}

// Se não é válido, retornar null ou objeto com informação de invalidade
return null;
```

### **Código com Logs Extensivos:**

```javascript
const data = await response.json();

if (!data.Success) {
    window.logError('SAFETYMAILS', 'Requisição não foi bem-sucedida', data);
    return null;
}

if (data.Status === 'VALIDO') {
    window.logInfo('SAFETYMAILS', 'Email válido', {
        email: data.Email,
        status: data.Status,
        domainStatus: data.DomainStatus
    });
    return data;
} else {
    window.logWarn('SAFETYMAILS', 'Email não válido', {
        email: data.Email,
        status: data.Status,
        domainStatus: data.DomainStatus,
        advice: data.Advice
    });
    return null;
}
```

---

## 📝 NOTAS IMPORTANTES

1. **`Success: true` não significa email válido:**
   - `Success: true` apenas indica que a requisição HTTP foi bem-sucedida
   - Sempre verificar `Status === "VALIDO"` para confirmar validade

2. **Múltiplos indicadores de validade:**
   - `Status: "VALIDO"` é o indicador principal
   - `DomainStatus: "VALIDO"` também indica validade
   - `Advice: "Valid"` também indica validade
   - IDs numéricos (`IdStatus: 9000`, `IdAdvice: 5200`) também indicam validade

3. **Status "PENDENTE" não é válido:**
   - `Status: "PENDENTE"` significa que o email não foi validado como válido
   - Deve ser tratado como não válido

4. **Verificar sempre o campo `Status`:**
   - É o campo mais confiável para determinar validade
   - Outros campos podem ser usados como confirmação

---

## 🔗 REFERÊNCIAS

- **Documentação SafetyMails:** Ver painel do SafetyMails
- **Ticket Origem:** `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- **API Key:** `20a7a1c297e39180bd80428ac13c363e882a531f`
- **URL Base:** `https://05bf2ec47128ca0b917f8b955bada1bd3cadd47e.safetymails.com`

---

**Status:** ✅ **DOCUMENTADO**  
**Data:** 12/11/2025  
**Última Atualização:** 12/11/2025

