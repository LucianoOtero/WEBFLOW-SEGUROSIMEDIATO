# 🔧 PROJETO: CORREÇÃO CORS E ATUALIZAÇÃO SAFETYMAILS

**Data:** 11/11/2025  
**Status:** 📋 **PLANEJADO**  
**Ambiente:** 🟢 **DESENVOLVIMENTO (DEV)** - `dev.bssegurosimediato.com.br`

---

## 🎯 OBJETIVOS

### **1. Corrigir Erro CORS - Duplicação de Headers**
- Remover headers CORS hardcoded de `placa-validate.php` e `cpf-validate.php`
- Usar `setCorsHeaders()` de `config.php` para evitar duplicação com Nginx
- Eliminar erro: `The 'Access-Control-Allow-Origin' header contains multiple values`

### **2. Atualizar Credenciais SafetyMails**
- Atualizar `SAFETY_TICKET` no `FooterCodeSiteDefinitivoCompleto.js`
- Manter `SAFETY_API_KEY` (mesma)
- Resolver erro 403 da API SafetyMails

---

## 📋 ARQUIVOS A MODIFICAR

### **1. `placa-validate.php`**
**Problema:** Header CORS hardcoded `Access-Control-Allow-Origin: *` (linha 3)  
**Solução:** Usar `setCorsHeaders()` de `config.php`

**Mudanças:**
- Adicionar `require_once __DIR__ . '/config.php';` no início
- Remover linha 3: `header("Access-Control-Allow-Origin: *");`
- Remover linhas 4-5: headers CORS hardcoded
- Remover bloco OPTIONS (linhas 7-10) - `setCorsHeaders()` já trata
- Adicionar `setCorsHeaders();` após `require_once`

### **2. `cpf-validate.php`**
**Problema:** Header CORS hardcoded `Access-Control-Allow-Origin: *` (linha 3)  
**Solução:** Usar `setCorsHeaders()` de `config.php`

**Mudanças:**
- Adicionar `require_once __DIR__ . '/config.php';` no início
- Remover linha 3: `header("Access-Control-Allow-Origin: *");`
- Remover linhas 4-5: headers CORS hardcoded
- Remover bloco OPTIONS (linhas 7-10) - `setCorsHeaders()` já trata
- Adicionar `setCorsHeaders();` após `require_once`

### **3. `FooterCodeSiteDefinitivoCompleto.js`**
**Problema:** `SAFETY_TICKET` desatualizado  
**Solução:** Atualizar com novo ticket

**Mudanças:**
- Linha 243: Atualizar `window.SAFETY_TICKET` de `'fc5e18c10c4aa883b2c31a305f1c09fea3834138'` para `'05bf2ec47128ca0b917f8b955bada1bd3cadd47e'`
- Linha 244: Manter `window.SAFETY_API_KEY` como `'20a7a1c297e39180bd80428ac13c363e882a531f'` (mesma)

---

## 🔐 CREDENCIAIS SAFETYMAILS

### **Novas Credenciais:**
- **API Key:** `20a7a1c297e39180bd80428ac13c363e882a531f` (mantida)
- **Ticket Origem:** `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` (nova)

### **Credenciais Antigas:**
- **API Key:** `20a7a1c297e39180bd80428ac13c363e882a531f` (mesma)
- **Ticket Origem:** `fc5e18c10c4aa883b2c31a305f1c09fea3834138` (antiga)

---

## 📝 PLANO DE IMPLEMENTAÇÃO

### **FASE 1: Preparação e Backups**

**1.1. Criar backups locais:**
- ✅ Criar backup de `placa-validate.php` → `backups/placa-validate.php.backup_ANTES_CORRECAO_CORS_YYYYMMDD_HHMMSS`
- ✅ Criar backup de `cpf-validate.php` → `backups/cpf-validate.php.backup_ANTES_CORRECAO_CORS_YYYYMMDD_HHMMSS`
- ✅ Criar backup de `FooterCodeSiteDefinitivoCompleto.js` → `backups/FooterCodeSiteDefinitivoCompleto.js.backup_ANTES_ATUALIZACAO_SAFETYMAILS_YYYYMMDD_HHMMSS`

**1.2. Verificar função `setCorsHeaders()`:**
- ✅ Confirmar que `config.php` tem função `setCorsHeaders()`
- ✅ Verificar que função valida origem e trata OPTIONS

---

### **FASE 2: Correção CORS - `placa-validate.php`**

**2.1. Modificar arquivo localmente:**

**Antes:**
```php
<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit;
}
```

**Depois:**
```php
<?php
// Incluir config.php ANTES de qualquer header ou output para usar setCorsHeaders()
require_once __DIR__ . '/config.php';

// Headers CORS (usar função do config.php para evitar duplicação com Nginx)
// IMPORTANTE: Headers devem ser enviados ANTES de qualquer output
header('Content-Type: application/json; charset=utf-8');
// Usar setCorsHeaders() do config.php - valida origem e envia apenas um valor no header
setCorsHeaders();
// Adicionar headers específicos após setCorsHeaders() se necessário
header('Access-Control-Allow-Headers: Content-Type');

// Nota: setCorsHeaders() já trata requisições OPTIONS (preflight) e envia os headers corretos
// Não é necessário código adicional para OPTIONS
```

**2.2. Verificar sintaxe PHP:**
- ✅ Executar `php -l placa-validate.php` localmente (se possível)
- ✅ Verificar que não há erros de sintaxe

---

### **FASE 3: Correção CORS - `cpf-validate.php`**

**3.1. Modificar arquivo localmente:**

**Antes:**
```php
<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit;
}
```

**Depois:**
```php
<?php
// Incluir config.php ANTES de qualquer header ou output para usar setCorsHeaders()
require_once __DIR__ . '/config.php';

// Headers CORS (usar função do config.php para evitar duplicação com Nginx)
// IMPORTANTE: Headers devem ser enviados ANTES de qualquer output
header('Content-Type: application/json; charset=utf-8');
// Usar setCorsHeaders() do config.php - valida origem e envia apenas um valor no header
setCorsHeaders();
// Adicionar headers específicos após setCorsHeaders() se necessário
header('Access-Control-Allow-Headers: Content-Type');

// Nota: setCorsHeaders() já trata requisições OPTIONS (preflight) e envia os headers corretos
// Não é necessário código adicional para OPTIONS
```

**3.2. Verificar sintaxe PHP:**
- ✅ Executar `php -l cpf-validate.php` localmente (se possível)
- ✅ Verificar que não há erros de sintaxe

---

### **FASE 4: Atualização SafetyMails - `FooterCodeSiteDefinitivoCompleto.js`**

**4.1. Modificar arquivo localmente:**

**Antes:**
```javascript
window.SAFETY_TICKET = 'fc5e18c10c4aa883b2c31a305f1c09fea3834138'; // DEV: Ticket origem correto (segurosimediato-8119bf26e77bf4ff336a58e.webflow.io)
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
```

**Depois:**
```javascript
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // DEV: Ticket origem atualizado
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
```

**4.2. Verificar sintaxe JavaScript:**
- ✅ Verificar que não há erros de sintaxe
- ✅ Confirmar que valores estão corretos

---

### **FASE 5: Deploy para Servidor DEV**

**⚠️ IMPORTANTE:** Este projeto trabalha **APENAS** no ambiente de desenvolvimento (DEV)

**5.1. Copiar arquivos para servidor DEV:**
- ✅ Copiar `placa-validate.php` para servidor DEV: `/var/www/html/dev/root/`
- ✅ Copiar `cpf-validate.php` para servidor DEV: `/var/www/html/dev/root/`
- ✅ Copiar `FooterCodeSiteDefinitivoCompleto.js` para servidor DEV: `/var/www/html/dev/root/`
- ✅ **Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
- ⚠️ **NÃO modificar** servidor de produção sem instrução explícita

**5.2. Criar backups no servidor DEV:**
- ✅ Criar backup de `placa-validate.php` no servidor DEV antes de sobrescrever
- ✅ Criar backup de `cpf-validate.php` no servidor DEV antes de sobrescrever
- ✅ Criar backup de `FooterCodeSiteDefinitivoCompleto.js` no servidor DEV antes de sobrescrever

**5.3. Verificar sintaxe no servidor DEV:**
- ✅ Executar `php -l /var/www/html/dev/root/placa-validate.php` no servidor DEV
- ✅ Executar `php -l /var/www/html/dev/root/cpf-validate.php` no servidor DEV

**5.4. Testar funcionamento no ambiente DEV:**
- ✅ Testar `placa-validate.php` via `https://dev.bssegurosimediato.com.br/placa-validate.php`
- ✅ Testar `cpf-validate.php` via `https://dev.bssegurosimediato.com.br/cpf-validate.php`
- ✅ Verificar que não há mais erro de duplicação de headers CORS
- ✅ Testar validação SafetyMails no `FooterCodeSiteDefinitivoCompleto.js` no ambiente DEV

---

### **FASE 6: Auditoria Pós-Implementação**

**6.1. Auditoria de Código:**
- ✅ Verificar sintaxe de todos os arquivos modificados
- ✅ Verificar que `require_once` está correto
- ✅ Verificar que `setCorsHeaders()` está sendo chamado corretamente
- ✅ Verificar que headers hardcoded foram removidos
- ✅ Verificar que credenciais SafetyMails foram atualizadas corretamente

**6.2. Auditoria de Funcionalidade:**
- ✅ Comparar código modificado com backups originais
- ✅ Confirmar que nenhuma funcionalidade foi removida
- ✅ Confirmar que apenas headers CORS foram modificados
- ✅ Confirmar que apenas credenciais SafetyMails foram atualizadas
- ✅ Verificar que lógica de validação permanece intacta

**6.3. Testes Funcionais:**
- ✅ Testar validação de placa via `placa-validate.php`
- ✅ Testar validação de CPF via `cpf-validate.php`
- ✅ Testar validação de email via SafetyMails
- ✅ Verificar que não há mais erros CORS no console do browser
- ✅ Verificar que não há mais erro 403 do SafetyMails (ou verificar se foi resolvido)

**6.4. Documentação:**
- ✅ Criar relatório de auditoria em `05-DOCUMENTATION/AUDITORIA_CORRECAO_CORS_SAFETYMAILS.md`
- ✅ Listar todos os arquivos modificados
- ✅ Documentar problemas encontrados e correções aplicadas
- ✅ Confirmar que nenhuma funcionalidade foi prejudicada
- ✅ Registrar aprovação da auditoria

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **Preparação:**
- [ ] Criar backups locais de todos os arquivos
- [ ] Verificar função `setCorsHeaders()` em `config.php`

### **Modificações Locais:**
- [ ] Modificar `placa-validate.php` (remover headers hardcoded, adicionar `setCorsHeaders()`)
- [ ] Modificar `cpf-validate.php` (remover headers hardcoded, adicionar `setCorsHeaders()`)
- [ ] Modificar `FooterCodeSiteDefinitivoCompleto.js` (atualizar `SAFETY_TICKET`)

### **Deploy (APENAS DEV):**
- [ ] Copiar arquivos para servidor DEV (`dev.bssegurosimediato.com.br`)
- [ ] Criar backups no servidor DEV antes de sobrescrever
- [ ] Verificar sintaxe PHP no servidor DEV
- [ ] ⚠️ **NÃO fazer deploy em produção** sem instrução explícita

### **Testes:**
- [ ] Testar `placa-validate.php` (verificar CORS)
- [ ] Testar `cpf-validate.php` (verificar CORS)
- [ ] Testar SafetyMails (verificar se erro 403 foi resolvido)

### **Auditoria:**
- [ ] Auditoria de código (sintaxe, lógica)
- [ ] Auditoria de funcionalidade (comparar com backups)
- [ ] Testes funcionais completos
- [ ] Documentar auditoria

---

## 📊 RESUMO DAS MUDANÇAS

| Arquivo | Tipo de Mudança | Linhas Afetadas |
|---------|----------------|-----------------|
| `placa-validate.php` | Correção CORS | Linhas 1-10 (remover headers hardcoded, adicionar `setCorsHeaders()`) |
| `cpf-validate.php` | Correção CORS | Linhas 1-10 (remover headers hardcoded, adicionar `setCorsHeaders()`) |
| `FooterCodeSiteDefinitivoCompleto.js` | Atualização SafetyMails | Linha 243 (atualizar `SAFETY_TICKET`) |

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Risco 1: Quebra de Funcionalidade CORS**
**Mitigação:**
- Usar `setCorsHeaders()` que já está testado em `send_email_notification_endpoint.php`
- Manter headers específicos após `setCorsHeaders()` se necessário
- Testar em ambiente DEV (este projeto trabalha apenas em DEV)

### **Risco 2: Credenciais SafetyMails Incorretas**
**Mitigação:**
- Verificar credenciais antes de atualizar
- Manter backup da versão anterior
- Testar validação de email após atualização

### **Risco 3: Erro de Sintaxe PHP**
**Mitigação:**
- Verificar sintaxe localmente antes de copiar
- Verificar sintaxe no servidor após copiar
- Manter backups para rollback se necessário

---

## 📝 NOTAS

- **Prioridade:** ALTA (erros estão afetando funcionalidade)
- **Complexidade:** BAIXA (mudanças simples e diretas)
- **Tempo estimado:** 30-45 minutos
- **Dependências:** `config.php` deve ter função `setCorsHeaders()` funcionando
- **Ambiente:** 🟢 **APENAS DESENVOLVIMENTO (DEV)** - `dev.bssegurosimediato.com.br`
- ⚠️ **PRODUÇÃO:** Este projeto **NÃO** modifica produção. Para produção, criar projeto separado com autorização explícita.

---

## 🌍 AMBIENTES

### **Desenvolvimento (DEV) - Este Projeto:**
- **URL:** `https://dev.bssegurosimediato.com.br`
- **IP:** `65.108.156.14`
- **Diretório:** `/var/www/html/dev/root/`
- **Status:** ✅ **MODIFICAR** (ambiente padrão deste projeto)

### **Produção (PROD):**
- **URL:** `https://prod.bssegurosimediato.com.br`
- **IP:** `157.180.36.223`
- **Diretório:** `/var/www/html/prod/root/`
- **Status:** ❌ **NÃO MODIFICAR** (sem instrução explícita)

---

**Status:** ✅ **IMPLEMENTADO**  
**Ambiente:** 🟢 **DESENVOLVIMENTO (DEV)**  
**Data de Implementação:** 12/11/2025  
**Auditoria:** ✅ Concluída e aprovada (ver `AUDITORIA_CORRECAO_CORS_SAFETYMAILS.md`)

