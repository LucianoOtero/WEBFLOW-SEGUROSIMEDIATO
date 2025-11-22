# 📋 Projeto: Atualizar Assunto do Email de Submissão Completa

**Data:** 16/11/2025  
**Status:** 📋 **PENDENTE**  
**Objetivo:** Substituir ❌ por 📞 (telefone verde) no assunto do email de submissão completa

---

## 🎯 OBJETIVO

Atualizar o assunto do email de "Submissão Completa - Todos os Dados" para substituir o emoji ❌ por um emoji de telefone verde (📞) quando a submissão for completa.

---

## 🔍 ANÁLISE

### **Localização do Assunto:**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/email_templates/template_modal.php`

**Linha ~49-54:**
```php
// Assunto do email
$subject = sprintf(
    '%s %s - Modal WhatsApp - %s',
    $momento_emoji,
    $momento_descricao,
    $telefoneCompleto
);
```

**Problema Identificado:**
- O assunto usa `$momento_emoji` diretamente
- Quando é "Submissão Completa - Todos os Dados", o `$momento_emoji` pode ser ❌
- O usuário quer substituir ❌ por 📞 (telefone verde) no assunto

**Observação:**
- Já existe lógica para trocar ❌ por ✅ no banner (linha ~35-39)
- Mas essa lógica não afeta o assunto do email
- O assunto ainda usa `$momento_emoji` original

---

## 🔧 SOLUÇÃO PROPOSTA

### **Modificação no Assunto:**

**Lógica:**
- Se `$momento_descricao === 'Submissão Completa - Todos os Dados'` E `$momento_emoji === '❌'`
- Então usar 📞 (telefone verde) no assunto ao invés de ❌
- Caso contrário, usar `$momento_emoji` normalmente

**Código Proposto:**
```php
// Determinar emoji para o assunto
$emojiAssunto = $momento_emoji;
if ($momento_descricao === 'Submissão Completa - Todos os Dados' && $momento_emoji === '❌') {
    $emojiAssunto = '📞'; // Telefone verde
}

// Assunto do email
$subject = sprintf(
    '%s %s - Modal WhatsApp - %s',
    $emojiAssunto,  // Usar $emojiAssunto ao invés de $momento_emoji
    $momento_descricao,
    $telefoneCompleto
);
```

---

## 📋 FASES DO PROJETO

### **FASE 1: Criar backup do template_modal.php** ✅

**Objetivo:** Preservar versão original antes de modificar

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/email_templates/template_modal.php`

**Status:** ⏭️ **PENDENTE**

---

### **FASE 2: Atualizar template_modal.php localmente** ⏭️

**Objetivo:** Adicionar lógica para substituir ❌ por 📞 no assunto

**Mudanças:**
- Adicionar variável `$emojiAssunto` com lógica condicional
- Atualizar `$subject` para usar `$emojiAssunto` ao invés de `$momento_emoji`

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/email_templates/template_modal.php`

**Status:** ⏭️ **PENDENTE**

---

### **FASE 3: Copiar para PROD local** ⏭️

**Objetivo:** Manter consistência entre DEV e PROD

**Processo:**
- Copiar arquivo atualizado de `02-DEVELOPMENT/` para `03-PRODUCTION/`

**Status:** ⏭️ **PENDENTE**

---

### **FASE 4: Copiar para servidor DEV** ⏭️

**Objetivo:** Deploy em desenvolvimento

**Processo:**
- Copiar arquivo de `02-DEVELOPMENT/` para servidor DEV
- Verificar hash após cópia

**Status:** ⏭️ **PENDENTE**

---

### **FASE 5: Testar em DEV** ⏭️

**Objetivo:** Validar que mudança funciona corretamente

**Teste:**
- Enviar email com `momento_descricao = 'Submissão Completa - Todos os Dados'` e `momento_emoji = '❌'`
- Verificar se assunto do email tem 📞 ao invés de ❌

**Status:** ⏭️ **PENDENTE**

---

### **FASE 6: Copiar para servidor PROD** ⏭️

**Objetivo:** Deploy em produção

**Processo:**
- Copiar arquivo de `03-PRODUCTION/` para servidor PROD
- Verificar hash após cópia
- Avisar sobre cache Cloudflare

**Status:** ⏭️ **PENDENTE**

---

## 📊 CHECKLIST DE EXECUÇÃO

- [ ] **FASE 1:** Backup do template_modal.php criado
- [ ] **FASE 2:** Arquivo local atualizado
- [ ] **FASE 3:** Arquivo copiado para PROD local
- [ ] **FASE 4:** Arquivo copiado para servidor DEV
- [ ] **FASE 5:** Teste em DEV realizado
- [ ] **FASE 6:** Arquivo copiado para servidor PROD

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **1. Emoji de Telefone Verde**
- 📞 é o emoji padrão de telefone (não é especificamente verde, mas é o emoji de telefone)
- Se o usuário quiser um emoji especificamente verde, pode usar combinação: 🟢📞 ou 📱 (smartphone)
- Por padrão, usaremos 📞 que é o emoji de telefone mais comum

### **2. Lógica Condicional**
- A substituição só ocorre quando:
  - `$momento_descricao === 'Submissão Completa - Todos os Dados'` E
  - `$momento_emoji === '❌'`
- Caso contrário, usa o emoji original

### **3. Consistência**
- O banner já tem lógica para trocar ❌ por ✅
- O assunto agora terá lógica para trocar ❌ por 📞
- Ambas as lógicas são independentes e corretas

---

## 🔗 RELACIONADO

- **Template:** `email_templates/template_modal.php`
- **Documentação Anterior:** `PROJETO_MODIFICACAO_TEXTOS_TEMPLATES_EMAIL.md`

---

**Status:** 📋 **PENDENTE - AGUARDANDO AUTORIZAÇÃO PARA IMPLEMENTAÇÃO**

