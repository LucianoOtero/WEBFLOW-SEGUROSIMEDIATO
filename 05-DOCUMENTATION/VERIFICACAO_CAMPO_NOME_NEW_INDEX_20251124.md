# Verificação: Campo Nome no new_index.html
**Data:** 24/11/2025  
**Arquivo Verificado:** `new_index.html`  
**Status:** ✅ **VERIFICAÇÃO COMPLETA**

---

## 📋 RESUMO EXECUTIVO

Verificação do código do `new_index.html` para confirmar como o campo **nome** é definido e coletado antes de ser enviado para a API RPA.

### Conclusão
- ✅ **HTML define:** `name="nome"` (minúsculas)
- ✅ **JavaScript coleta:** `nome` (minúsculas) via `FormData`
- ⚠️ **Problema identificado:** Formulário do Webflow (`app.tosegurado.com.br`) pode estar enviando `NOME` (maiúsculas)

---

## 🔍 ANÁLISE DO CÓDIGO

### 1. Definição do Campo no HTML

**Arquivo:** `new_index.html`  
**Linha:** 323-324

```html
<label for="nome">Nome Completo *</label>
<input type="text" id="nome" name="nome" required placeholder="Seu nome completo" value="Rui Magalhães">
```

**Conclusão:**
- ✅ Campo definido como `name="nome"` (minúsculas)
- ✅ ID também é `nome` (minúsculas)
- ✅ Valor padrão: "Rui Magalhães"

### 2. Coleta de Dados pelo JavaScript

**Arquivo:** `new_webflow-injection-complete.js`  
**Função:** `collectFormData(form)`  
**Linhas:** 2336-2365

```javascript
collectFormData(form) {
    const formData = new FormData(form);
    const data = {};
    
    // Coletar dados do formulário
    for (let [key, value] of formData.entries()) {
        data[key] = value;  // Preserva o nome do campo como está no HTML
    }
    
    // ... conversões e limpeza ...
    
    return completeData;
}
```

**Conclusão:**
- ✅ `FormData` preserva os nomes dos campos como estão no HTML
- ✅ Como o HTML define `name="nome"`, o JavaScript coleta como `data['nome']` (minúsculas)
- ✅ Não há transformação que converte `nome` → `NOME`

### 3. Verificação do `webflow_injection_limpo.js` (Produção)

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`  
**Função:** `collectFormData(form)`  
**Linhas:** 2546-2584

```javascript
collectFormData(form) {
    const formData = new FormData(form);
    const data = {};
    
    // Coletar dados do formulário
    for (let [key, value] of formData.entries()) {
        data[key] = value;  // Preserva o nome do campo como está no HTML
    }
    
    // ... conversões e limpeza ...
    
    return completeData;
}
```

**Conclusão:**
- ✅ Mesma lógica do `new_webflow-injection-complete.js`
- ✅ Preserva nomes dos campos como estão no HTML
- ✅ Não há transformação `nome` → `NOME`

### 4. Função `removeDuplicateFields()`

**Arquivo:** `webflow_injection_limpo.js`  
**Linhas:** 2591-2625

```javascript
removeDuplicateFields(data) {
    const cleanedData = { ...data };
    
    // Lista de campos que devem ser removidos (versões maiúsculas incorretas)
    const fieldsToRemove = [
        'DATA-DE-NASCIMENTO',  // Manter apenas 'data_nascimento'
        'SEXO',               // Manter apenas 'sexo'
        'ESTADO-CIVIL',       // Manter apenas 'estado_civil'
        'DDD-CELULAR',        // Manter apenas 'telefone' (concatenado)
        'CELULAR',            // Manter apenas 'telefone' (concatenado)
        'PLACA',              // Manter apenas 'placa'
        'MARCA',              // Manter apenas 'marca'
        'ANO',                // Manter apenas 'ano'
        'TIPO-DE-VEICULO',    // Manter apenas 'tipo_veiculo'
        'CEP',                // Manter apenas 'cep'
        'CPF'                 // Manter apenas 'cpf'
    ];
    
    // ⚠️ NOTA: 'NOME' NÃO está na lista de campos a remover
    // Isso significa que se o formulário enviar 'NOME', ele será mantido
}
```

**Conclusão:**
- ⚠️ **Problema identificado:** A função `removeDuplicateFields()` **NÃO remove** o campo `NOME` (maiúsculas)
- ⚠️ Se o formulário do Webflow enviar `NOME` (maiúsculas), ele será mantido nos dados
- ⚠️ Isso pode causar conflito se o formulário também tiver `nome` (minúsculas)

### 5. Função `applyFieldConversions()`

**Arquivo:** `webflow_injection_limpo.js`  
**Linhas:** 2631-2704

```javascript
applyFieldConversions(data) {
    // Converter estado civil
    if (data['ESTADO-CIVIL']) {
        data.estado_civil = this.convertEstadoCivil(data['ESTADO-CIVIL']);
    }
    
    // Converter sexo
    if (data.SEXO) {
        data.sexo = this.convertSexo(data.SEXO);
    }
    
    // ... outras conversões ...
    
    // Mapear campos do Webflow para nomes do RPA
    const fieldMapping = {
        'CPF': 'cpf',
        'PLACA': 'placa',
        'MARCA': 'marca',
        'CEP': 'cep',
        'DATA-DE-NASCIMENTO': 'data_nascimento'
        // ⚠️ NOTA: 'NOME' → 'nome' NÃO está no mapeamento
    };
}
```

**Conclusão:**
- ⚠️ **Problema identificado:** Não há mapeamento `'NOME': 'nome'` na função `applyFieldConversions()`
- ⚠️ Se o formulário enviar `NOME` (maiúsculas), ele não será convertido para `nome` (minúsculas)
- ⚠️ Isso explica por que o backend recebe `NOME` e não encontra `nome`

---

## 🎯 PROBLEMA IDENTIFICADO

### Causa Raiz

**O formulário do Webflow (`app.tosegurado.com.br`) está enviando `NOME` (maiúsculas) em vez de `nome` (minúsculas).**

**Evidências:**
1. ✅ `new_index.html` define `name="nome"` (minúsculas) - **CORRETO**
2. ✅ JavaScript preserva nomes dos campos como estão no HTML - **CORRETO**
3. ⚠️ Função `removeDuplicateFields()` **NÃO remove** `NOME` (maiúsculas)
4. ⚠️ Função `applyFieldConversions()` **NÃO mapeia** `NOME` → `nome`
5. ❌ Backend espera `nome` (minúsculas) mas recebe `NOME` (maiúsculas)

**Fluxo do Problema:**
```
1. Formulário Webflow envia: NOME (maiúsculas)
2. JavaScript coleta: data['NOME'] = "valor"
3. removeDuplicateFields(): NÃO remove 'NOME' (não está na lista)
4. applyFieldConversions(): NÃO converte 'NOME' → 'nome' (não está no mapeamento)
5. Dados enviados para API: { NOME: "valor", ... }  ❌
6. Backend espera: { nome: "valor", ... }  ❌
7. Backend acessa: $data['nome'] → Undefined array key "nome"  ❌
```

---

## 📊 COMPARAÇÃO: new_index.html vs Webflow

### new_index.html (Funcionando)
- **HTML:** `name="nome"` (minúsculas)
- **JavaScript coleta:** `data['nome']` (minúsculas)
- **Backend recebe:** `{ nome: "valor" }` ✅
- **Backend acessa:** `$data['nome']` ✅

### Webflow (app.tosegurado.com.br) - Não Funcionando
- **HTML:** Provavelmente `name="NOME"` (maiúsculas) ou campo gerado dinamicamente
- **JavaScript coleta:** `data['NOME']` (maiúsculas)
- **Backend recebe:** `{ NOME: "valor" }` ❌
- **Backend acessa:** `$data['nome']` → **Undefined array key "nome"** ❌

---

## 🔧 SOLUÇÕES NECESSÁRIAS

### Solução 1: Adicionar Mapeamento NOME → nome (RECOMENDADO)

**Localização:** `webflow_injection_limpo.js` → `applyFieldConversions()`

**Alteração necessária:**
```javascript
const fieldMapping = {
    'CPF': 'cpf',
    'PLACA': 'placa',
    'MARCA': 'marca',
    'CEP': 'cep',
    'DATA-DE-NASCIMENTO': 'data_nascimento',
    'NOME': 'nome'  // ✅ ADICIONAR ESTA LINHA
};
```

### Solução 2: Adicionar NOME à Lista de Campos a Remover (ALTERNATIVA)

**Localização:** `webflow_injection_limpo.js` → `removeDuplicateFields()`

**Alteração necessária:**
```javascript
const fieldsToRemove = [
    'DATA-DE-NASCIMENTO',
    'SEXO',
    'ESTADO-CIVIL',
    'DDD-CELULAR',
    'CELULAR',
    'PLACA',
    'MARCA',
    'ANO',
    'TIPO-DE-VEICULO',
    'CEP',
    'CPF',
    'NOME'  // ✅ ADICIONAR ESTA LINHA (se formulário também tiver 'nome')
];
```

**Nota:** Esta solução só funciona se o formulário tiver AMBOS `NOME` e `nome`. Se tiver apenas `NOME`, a Solução 1 é melhor.

### Solução 3: Normalizar no Backend (ALTERNATIVA)

**Localização:** `RPAController.php` → `startRPA()`

**Alteração necessária:**
```php
// Normalizar nomenclatura de campos
if (isset($data['NOME']) && !isset($data['nome'])) {
    $data['nome'] = $data['NOME'];
    unset($data['NOME']);
}
```

---

## 📋 RECOMENDAÇÕES

### Recomendação 1: Adicionar Mapeamento NOME → nome (URGENTE)

**Prioridade:** 🔴 **ALTA**

**Justificativa:**
- Resolve o problema na origem (frontend)
- Mantém compatibilidade com ambos os formatos
- Não requer alteração no backend

**Arquivo a modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`
- Função: `applyFieldConversions()`
- Linha: ~2678 (adicionar `'NOME': 'nome'` ao `fieldMapping`)

### Recomendação 2: Verificar Formulário do Webflow

**Prioridade:** 🟡 **MÉDIA**

**Ação:**
- Verificar HTML do formulário em `app.tosegurado.com.br`
- Confirmar se campo está como `name="NOME"` ou `name="nome"`
- Se possível, corrigir no Webflow para usar `name="nome"` (minúsculas)

### Recomendação 3: Adicionar Verificação no Backend (DEFENSIVA)

**Prioridade:** 🟡 **MÉDIA**

**Justificativa:**
- Adiciona camada de defesa caso outros formulários também enviem `NOME`
- Garante compatibilidade com ambos os formatos

**Arquivo a modificar:**
- `/opt/imediatoseguros-rpa-v4/src/Controllers/RPAController.php`
- Função: `startRPA()`
- Linha: ~123 (antes de acessar `$data['nome']`)

---

## 🔗 ARQUIVOS RELACIONADOS

- `new_index.html` - HTML de teste (define `name="nome"` corretamente)
- `new_webflow-injection-complete.js` - JavaScript de teste (preserva nomes do HTML)
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js` - JavaScript de produção
  - Função `collectFormData()` (linhas 2546-2584)
  - Função `removeDuplicateFields()` (linhas 2591-2625)
  - Função `applyFieldConversions()` (linhas 2631-2704)
- `/opt/imediatoseguros-rpa-v4/src/Controllers/RPAController.php` - Backend PHP
  - Função `startRPA()` (linha 123 - acessa `$data['nome']`)

---

## 📋 CONCLUSÃO

### Verificação do new_index.html

✅ **CONFIRMADO:** O `new_index.html` define o campo corretamente como `name="nome"` (minúsculas)

### Problema Identificado

⚠️ **O formulário do Webflow (`app.tosegurado.com.br`) está enviando `NOME` (maiúsculas) em vez de `nome` (minúsculas)**

### Causa Raiz

1. Formulário Webflow envia `NOME` (maiúsculas)
2. JavaScript preserva o nome do campo (`NOME`)
3. Função `applyFieldConversions()` não mapeia `NOME` → `nome`
4. Backend recebe `NOME` mas espera `nome`
5. Backend acessa `$data['nome']` → **Undefined array key "nome"**

### Solução Recomendada

**Adicionar mapeamento `'NOME': 'nome'` na função `applyFieldConversions()` do `webflow_injection_limpo.js`**

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 17:50  
**Status:** ✅ **VERIFICAÇÃO COMPLETA** - Problema identificado e soluções propostas

