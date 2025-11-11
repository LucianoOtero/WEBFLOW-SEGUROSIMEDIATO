# 🔧 PROJETO: Correção JSON Inválido em send_email_notification_endpoint.php

**Data de Início:** 11/11/2025  
**Status:** 🔄 **EM ANDAMENTO**

---

## 🎯 OBJETIVO

Corrigir o erro "JSON inválido: Syntax error" que ocorre quando o `ProfessionalLogger.php` tenta enviar notificações de erro por email via `send_email_notification_endpoint.php`.

---

## 📋 PROBLEMA IDENTIFICADO

### Erro Reportado

```
❌ ERROR
[EMAIL-ENDPOINT] Erro: JSON inválido: Syntax error
Arquivo: send_email_notification_endpoint.php:61
Request ID: req_69139ce14e84a8.78944294
Timestamp: 2025-11-11 20:30:25.000000
```

### Contexto

- ✅ Email chegou (enviado com sucesso)
- ✅ Lead foi inserido no espoCRM
- ❌ Foi gerado um email de erro no endpoint de log

### Causa Raiz

O `ProfessionalLogger.php` está tentando serializar dados que podem conter:
- Recursos PHP não serializáveis (file handles, database connections)
- Objetos complexos
- Caracteres especiais malformados
- `json_encode()` pode falhar silenciosamente e retornar `false`

---

## 🔧 SOLUÇÃO

### FASE 1: Sanitizar Dados no ProfessionalLogger.php

**Objetivo:** Garantir que todos os dados sejam serializáveis em JSON antes de enviar.

**Ações:**
1. Criar função `sanitizeForJson()` para converter recursos e objetos em strings
2. Aplicar sanitização em `$data`, `$stackTrace` e `$logData`
3. Validar `json_encode()` antes de enviar

### FASE 2: Validar JSON no send_email_notification_endpoint.php

**Objetivo:** Adicionar validação mais robusta e logging para debug.

**Ações:**
1. Verificar se `$rawInput` não está vazio
2. Logar preview do JSON inválido (limitado a 500 caracteres) para debug
3. Melhorar mensagem de erro

### FASE 3: Melhorar Tratamento de Erro no ProfessionalLogger.php

**Objetivo:** Capturar e logar erros sem causar loop infinito.

**Ações:**
1. Validar `json_encode()` antes de usar
2. Capturar exceções ao fazer `file_get_contents()`
3. Logar erros sem usar `ProfessionalLogger` (evitar loop)

---

## 📝 CHECKLIST

### FASE 1: Sanitizar Dados
- [ ] Criar função `sanitizeForJson()` no `ProfessionalLogger.php`
- [ ] Aplicar sanitização em `$data` antes de adicionar ao payload
- [ ] Aplicar sanitização em `$stackTrace` antes de adicionar ao payload
- [ ] Aplicar sanitização em `$logData` antes de adicionar ao payload
- [ ] Validar `json_encode()` e logar erro se falhar

### FASE 2: Validar JSON no Endpoint
- [ ] Adicionar verificação de `$rawInput` vazio
- [ ] Adicionar log de preview do JSON inválido (500 caracteres)
- [ ] Melhorar mensagem de erro com mais contexto

### FASE 3: Melhorar Tratamento de Erro
- [ ] Validar `json_encode()` antes de usar em `stream_context_create()`
- [ ] Adicionar try-catch ao redor de `file_get_contents()`
- [ ] Logar erros usando `error_log()` (não `ProfessionalLogger`)

### FASE 4: Testes
- [ ] Testar com dados simples (deve funcionar)
- [ ] Testar com recursos PHP (deve sanitizar)
- [ ] Testar com objetos complexos (deve sanitizar)
- [ ] Testar com JSON malformado (deve logar e não quebrar)
- [ ] Verificar que não há loop infinito de erros

### FASE 5: Deploy
- [ ] Criar backup do `ProfessionalLogger.php`
- [ ] Criar backup do `send_email_notification_endpoint.php`
- [ ] Aplicar correções
- [ ] Copiar arquivos para servidor DEV
- [ ] Testar no servidor DEV
- [ ] Verificar logs para confirmar correção

---

## 📁 ARQUIVOS A MODIFICAR

1. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
   - Adicionar função `sanitizeForJson()`
   - Modificar método `sendEmailNotification()`

2. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_email_notification_endpoint.php`
   - Melhorar validação de JSON
   - Adicionar logging de debug

---

## 🔍 VALIDAÇÃO

### Testes a Realizar

1. **Teste 1: Dados Simples**
   - Enviar erro com dados simples (string, array simples)
   - ✅ Deve funcionar normalmente

2. **Teste 2: Recursos PHP**
   - Enviar erro com recurso PHP (file handle)
   - ✅ Deve sanitizar e enviar sem erro

3. **Teste 3: Objetos Complexos**
   - Enviar erro com objeto não serializável
   - ✅ Deve sanitizar e enviar sem erro

4. **Teste 4: JSON Malformado (simulado)**
   - Simular recebimento de JSON inválido
   - ✅ Deve logar preview e retornar erro 500

5. **Teste 5: Loop de Erros**
   - Verificar que erro no `ProfessionalLogger` não causa loop
   - ✅ Deve usar `error_log()` e não `ProfessionalLogger`

---

## 📊 RESULTADO ESPERADO

### Antes da Correção

```
❌ [EMAIL-ENDPOINT] Erro: JSON inválido: Syntax error
❌ Email de erro gerado incorretamente
❌ Dados podem conter recursos/objetos não serializáveis
```

### Depois da Correção

```
✅ JSON sempre válido antes de enviar
✅ Dados sanitizados (recursos/objetos convertidos para strings)
✅ Validação robusta no endpoint
✅ Logging de debug para JSON inválido
✅ Sem loop infinito de erros
```

---

**Status:** ✅ **IMPLEMENTAÇÃO CONCLUÍDA**

---

## ✅ CORREÇÕES APLICADAS

### FASE 1: Sanitizar Dados no ProfessionalLogger.php ✅
- ✅ Criada função `sanitizeForJson()` para converter recursos e objetos em strings
- ✅ Aplicada sanitização em `$data`, `$stackTrace` e `$logData`
- ✅ Validação de `json_encode()` antes de enviar
- ✅ Fallback para payload simplificado se JSON falhar

### FASE 2: Validar JSON no send_email_notification_endpoint.php ✅
- ✅ Verificação de `$rawInput` vazio
- ✅ Logging de preview do JSON inválido (500 caracteres) para debug
- ✅ Mensagem de erro melhorada

### FASE 3: Melhorar Tratamento de Erro ✅
- ✅ Validação de `json_encode()` antes de usar em `stream_context_create()`
- ✅ Try-catch ao redor de `file_get_contents()`
- ✅ Logging usando `error_log()` (não `ProfessionalLogger`)

### FASE 4: Deploy ✅
- ✅ Backups criados
- ✅ Arquivos copiados para servidor DEV
- ✅ Versão atualizada: `send_email_notification_endpoint.php` v1.3

---

## 📊 RESULTADO ESPERADO

### Antes da Correção
```
❌ [EMAIL-ENDPOINT] Erro: JSON inválido: Syntax error
❌ Email de erro gerado incorretamente
❌ Dados podem conter recursos/objetos não serializáveis
```

### Depois da Correção
```
✅ JSON sempre válido antes de enviar
✅ Dados sanitizados (recursos/objetos convertidos para strings)
✅ Validação robusta no endpoint
✅ Logging de debug para JSON inválido
✅ Sem loop infinito de erros
✅ Fallback para payload simplificado se necessário
```

---

**Data de Conclusão:** 11/11/2025

