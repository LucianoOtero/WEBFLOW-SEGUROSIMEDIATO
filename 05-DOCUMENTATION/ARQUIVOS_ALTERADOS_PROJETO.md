# 📁 ARQUIVOS QUE SERÃO ALTERADOS PELO PROJETO

**Data:** 11/11/2025  
**Projeto:** Data Attributes + Classificação e Controle de Logs

---

## 📋 RESUMO

**Total de arquivos a serem alterados:** 3 arquivos JavaScript + 0 arquivos PHP + 1 configuração Webflow

---

## 📁 ARQUIVOS JAVASCRIPT (3 arquivos)

### 1. FooterCodeSiteDefinitivoCompleto.js
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`

**Modificações:**
- ✅ **Remover:** Função `detectServerBaseUrl()` (linhas ~89-124)
- ✅ **Remover:** Código de carregamento dinâmico de `config_env.js.php` (linhas ~104-126)
- ✅ **Remover:** Polling de 3 segundos em `sendLogToProfessionalSystem()` (linhas ~370-389)
- ✅ **Remover:** Funções `waitForAppEnv()` em `loadRPAScript()` e `loadWhatsAppModal()` (linhas ~1514-1520, ~1593-1601)
- ✅ **Remover:** Logs de debug temporário (linhas ~584-588) - 5 logs
- ✅ **Adicionar:** Código para ler data attributes do script tag (~30 linhas)
- ✅ **Adicionar:** Função `logClassified()` com sistema de classificação (~60 linhas)
- ✅ **Substituir:** ~30 logs diretos `console.*` por `logClassified()` com classificação apropriada

**Linhas estimadas:**
- Removidas: ~105 linhas (código complexo + logs temporários)
- Adicionadas: ~90 linhas (data attributes + logClassified)
- Modificadas: ~30 linhas (substituição de logs)
- **Total:** ~165 linhas alteradas

---

### 2. MODAL_WHATSAPP_DEFINITIVO.js
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`

**Modificações:**
- ✅ **Substituir:** ~79 logs diretos `console.*` por `logClassified()` com classificação apropriada
  - Logs de ambiente: `DEBUG` nível
  - Logs de erro: `ERROR` nível
  - Logs de evento: `INFO/DEBUG` nível baseado em `severity`
  - Logs de estado: `DEBUG` nível
  - Logs de retry: `WARN` nível
  - Logs de WhatsApp: `INFO` nível
  - Logs de debug de email: `TRACE` nível, categoria `EMAIL_DEBUG`
  - Logs de envio de email: `ERROR/INFO` nível apropriado
  - Logs de webhook data: `TRACE` nível, categoria `JSON_DEBUG`
  - Logs de erro não bloqueante: `WARN` nível
  - Logs de integração: `ERROR` nível
  - Logs de Google Ads: `WARN/INFO` nível
  - Logs de UI: `DEBUG` nível
  - Logs de operação: `INFO` nível

**Linhas estimadas:**
- Modificadas: ~79 linhas (substituição de logs)
- **Total:** ~79 linhas alteradas

---

### 3. webflow_injection_limpo.js
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`

**Modificações:**
- ✅ **Substituir:** ~151 logs diretos `console.*` por `logClassified()` com classificação apropriada
  - Logs de SpinnerTimer: `DEBUG/TRACE` nível, contexto `UI`
  - Logs de ProgressModalRPA: `DEBUG/ERROR` nível apropriado
  - Logs de dados de progresso: `TRACE` nível, categoria `PROGRESS_TRACE`
  - Logs de atualização de UI: `TRACE` nível, categoria `UI_TRACE`
  - Logs de estimativas e resultados: `DEBUG/INFO/WARN` nível apropriado
  - Logs de atualização de valores: `TRACE` nível, categoria `DATA_TRACE`
  - Logs de validação: `ERROR/DEBUG` nível apropriado

**Linhas estimadas:**
- Modificadas: ~151 linhas (substituição de logs)
- **Total:** ~151 linhas alteradas

---

## 📁 ARQUIVOS PHP (0 arquivos)

**Nenhum arquivo PHP será modificado neste projeto.**

**Nota:** Os arquivos PHP não precisam ser modificados porque:
- Eles já usam `config.php` que lê variáveis de ambiente via `$_ENV`
- Eles não têm logs diretos `console.*` (logs são apenas em JavaScript)
- A classificação de logs é apenas para JavaScript

---

## 🌐 CONFIGURAÇÃO WEBFLOW (1 alteração)

### Webflow Footer Code
**Localização:** Webflow Dashboard → Site Settings → Custom Code → Footer Code

**Modificação:**
```html
<!-- ANTES -->
<script src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" defer></script>

<!-- DEPOIS -->
<script 
  src="https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://dev.bssegurosimediato.com.br"
  data-app-environment="development">
</script>
```

**Observação:** Esta modificação é feita manualmente no Webflow Dashboard, não é um arquivo do projeto.

---

## 📊 RESUMO DE ALTERAÇÕES

### Arquivos JavaScript Modificados: 3
1. `FooterCodeSiteDefinitivoCompleto.js` - ~165 linhas alteradas
2. `MODAL_WHATSAPP_DEFINITIVO.js` - ~79 linhas alteradas
3. `webflow_injection_limpo.js` - ~151 linhas alteradas

### Arquivos PHP Modificados: 0
- Nenhum arquivo PHP será modificado

### Configurações Externas: 1
- Webflow Footer Code (modificação manual)

### Total de Linhas Alteradas: ~395 linhas

---

## 📋 ARQUIVOS QUE NÃO SERÃO ALTERADOS

### Arquivos JavaScript que NÃO serão modificados:
- `config_env.js.php` - Não será mais usado (substituído por data attributes)
- Outros arquivos JavaScript do projeto

### Arquivos PHP que NÃO serão modificados:
- `config.php` - Já está correto
- `add_flyingdonkeys.php` - Não precisa de modificação
- `add_webflow_octa.php` - Não precisa de modificação
- `cpf-validate.php` - Não precisa de modificação
- `send_email_notification_endpoint.php` - Não precisa de modificação
- `log_endpoint.php` - Não precisa de modificação
- `send_admin_notification_ses.php` - Não precisa de modificação
- `email_template_loader.php` - Não precisa de modificação
- `aws_ses_config.php` - Não precisa de modificação
- `class.php` - Não precisa de modificação
- `ProfessionalLogger.php` - Não precisa de modificação
- Outros arquivos PHP do projeto

---

## 🔄 ARQUIVOS DE BACKUP

### Arquivos que serão criados como backup:
1. `FooterCodeSiteDefinitivoCompleto.js.backup_YYYYMMDD_HHMMSS`
2. `MODAL_WHATSAPP_DEFINITIVO.js.backup_YYYYMMDD_HHMMSS`
3. `webflow_injection_limpo.js.backup_YYYYMMDD_HHMMSS`

**Localização dos backups:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/` ou `WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/`

---

## 📄 ARQUIVOS DE DOCUMENTAÇÃO (criados, não modificados)

### Arquivos de documentação que serão criados:
1. `BASELINE_RESULTADOS.md` - Resultados dos testes antes das modificações
2. `test_baseline_funcionalidades.html` - Script de teste automatizado (JavaScript)
3. `test_baseline_endpoints.php` - Script de teste automatizado (PHP)
4. `ESTRATEGIA_VALIDACAO_FUNCIONALIDADES.md` - ✅ Já criado
5. `CLASSIFICACAO_DETALHADA_LOGS.md` - ✅ Já criado
6. `ANALISE_PERFORMANCE_CLASSIFICACAO_LOGS.md` - ✅ Já criado
7. `EXPLICACAO_CLASSIFICACAO_LOGS.md` - ✅ Já criado

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/`

---

## ✅ CHECKLIST DE ARQUIVOS

### Arquivos a Modificar:
- [ ] `FooterCodeSiteDefinitivoCompleto.js` - Modificar
- [ ] `MODAL_WHATSAPP_DEFINITIVO.js` - Modificar
- [ ] `webflow_injection_limpo.js` - Modificar

### Arquivos a Criar (Backup):
- [ ] `FooterCodeSiteDefinitivoCompleto.js.backup_*` - Criar backup ANTES de modificar
- [ ] `MODAL_WHATSAPP_DEFINITIVO.js.backup_*` - Criar backup ANTES de modificar
- [ ] `webflow_injection_limpo.js.backup_*` - Criar backup ANTES de modificar

### Arquivos a Criar (Documentação):
- [ ] `BASELINE_RESULTADOS.md` - Criar após testes iniciais
- [ ] `test_baseline_funcionalidades.html` - Criar para testes
- [ ] `test_baseline_endpoints.php` - Criar para testes

### Configurações Externas:
- [ ] Webflow Footer Code - Atualizar manualmente no dashboard

---

**Status:** ✅ **LISTA COMPLETA DE ARQUIVOS IDENTIFICADA**

