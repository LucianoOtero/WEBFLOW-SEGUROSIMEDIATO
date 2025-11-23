# 🔍 ANÁLISE: Variáveis de Ambiente DEV vs PROD

**Data:** 22/11/2025  
**Última Replicação PROD:** 16/11/2025  
**Status:** ⚠️ **APENAS ANÁLISE** - Nenhuma alteração realizada  
**Tipo de Análise:** Comparação completa DEV vs PROD para identificar variáveis que precisam ser adicionadas/modificadas em PROD

---

## 🎯 OBJETIVO

Identificar **TODAS** as variáveis de ambiente que precisam ser:
1. **Adicionadas** em PROD (existem em DEV mas não em PROD)
2. **Modificadas** em PROD (valores diferentes entre DEV e PROD)
3. **Verificadas** em PROD (formato ou estrutura diferente)

---

## 📊 RESUMO EXECUTIVO

### **Estatísticas:**

| Métrica | DEV | PROD | Diferença |
|---------|-----|------|-----------|
| **Total de Variáveis** | 40 | 20 | **-20 variáveis** |
| **Variáveis a Adicionar** | - | - | **20 variáveis** |
| **Variáveis a Modificar** | - | - | **5 variáveis** |
| **Variáveis Específicas de Ambiente** | 7 | 7 | ✅ OK |

### **Prioridades:**

- 🔴 **CRÍTICO:** 9 variáveis (AWS SES modificadas + novas variáveis críticas)
- 🟡 **ALTO:** 8 variáveis (novas variáveis para projeto "Mover Parâmetros")
- 🟢 **MÉDIO:** 3 variáveis (formato boolean + OCTADESK_FROM)

---

## 🔴 CATEGORIA 1: VARIÁVEIS A MODIFICAR EM PROD (5 variáveis)

### **1.1. Variáveis AWS SES (4 variáveis)**

#### **1.1.1. `AWS_ACCESS_KEY_ID`**
- **DEV:** `AKIA3JCQSJTSLPFUVP26`
- **PROD:** `AKIA3JCQSJTSMSKFZPW3`
- **Status:** ⚠️ **VALORES DIFERENTES** (esperado - credenciais diferentes por ambiente)
- **Ação:** ✅ **MANTER** valor atual de PROD (não modificar)
- **Nota:** Credenciais diferentes são esperadas entre DEV e PROD

#### **1.1.2. `AWS_SECRET_ACCESS_KEY`**
- **DEV:** `BD7yp5e9+noGG7F/n3IYOdrToVX/GPmmX8GKvQ5r`
- **PROD:** `tfgqmsB0bG4FfHjYjej0ZXdMDouhA5tJ0xk4Pn4z`
- **Status:** ⚠️ **VALORES DIFERENTES** (esperado - credenciais diferentes por ambiente)
- **Ação:** ✅ **MANTER** valor atual de PROD (não modificar)
- **Nota:** Credenciais diferentes são esperadas entre DEV e PROD

#### **1.1.3. `AWS_REGION`**
- **DEV:** `sa-east-1`
- **PROD:** `sa-east-1`
- **Status:** ✅ **VALORES IGUAIS** (já atualizado em PROD)
- **Ação:** ✅ **NENHUMA** (já está correto)

#### **1.1.4. `AWS_SES_FROM_EMAIL`**
- **DEV:** `noreply@bpsegurosimediato.com.br`
- **PROD:** `noreply@bssegurosimediato.com.br`
- **Status:** ⚠️ **VALORES DIFERENTES**
- **Ação:** 🔴 **MODIFICAR** em PROD para `noreply@bpsegurosimediato.com.br`
- **Motivo:** Documentação indica que DEV foi revertido para `bpsegurosimediato.com.br` (domínio verificado no AWS SES)
- **Prioridade:** 🔴 **CRÍTICO** (pode causar falhas no envio de emails)

### **1.2. Variável AWS SES Adicional**

#### **1.2.1. `AWS_SES_FROM_NAME`**
- **DEV:** `BP Seguros Imediato`
- **PROD:** ❌ **NÃO EXISTE**
- **Status:** ⚠️ **AUSENTE EM PROD**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[AWS_SES_FROM_NAME] = BP Seguros Imediato`
- **Prioridade:** 🟡 **ALTO** (melhora identificação dos emails)

---

## 🟢 CATEGORIA 2: VARIÁVEIS A ADICIONAR EM PROD (20 variáveis)

### **2.1. Variáveis do Projeto "Mover Parâmetros para PHP" (8 variáveis)**

#### **2.1.1. `APILAYER_KEY`**
- **DEV:** `dce92fa84152098a3b5b7b8db24debbc`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🔴 **ADICIONAR** em PROD: `env[APILAYER_KEY] = "dce92fa84152098a3b5b7b8db24debbc"`
- **Prioridade:** 🔴 **CRÍTICO** (necessário para validação de CPF/CNPJ)
- **Uso:** Chave de API do APILayer

#### **2.1.2. `SAFETY_TICKET`**
- **DEV:** `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🔴 **ADICIONAR** em PROD: `env[SAFETY_TICKET] = "05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`
- **Prioridade:** 🔴 **CRÍTICO** (necessário para autenticação SafetyMails)
- **Uso:** Ticket de autenticação SafetyMails

#### **2.1.3. `SAFETY_API_KEY`**
- **DEV:** `20a7a1c297e39180bd80428ac13c363e882a531f`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🔴 **ADICIONAR** em PROD: `env[SAFETY_API_KEY] = "20a7a1c297e39180bd80428ac13c363e882a531f"`
- **Prioridade:** 🔴 **CRÍTICO** (necessário para API SafetyMails)
- **Uso:** Chave de API SafetyMails

#### **2.1.4. `VIACEP_BASE_URL`**
- **DEV:** `https://viacep.com.br`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[VIACEP_BASE_URL] = "https://viacep.com.br"`
- **Prioridade:** 🟡 **ALTO** (necessário para consulta de CEP)
- **Uso:** URL base da API ViaCEP

#### **2.1.5. `APILAYER_BASE_URL`**
- **DEV:** `https://apilayer.net`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[APILAYER_BASE_URL] = "https://apilayer.net"`
- **Prioridade:** 🟡 **ALTO** (necessário para API APILayer)
- **Uso:** URL base da API APILayer

#### **2.1.6. `SAFETYMAILS_OPTIN_BASE`**
- **DEV:** `https://optin.safetymails.com`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[SAFETYMAILS_OPTIN_BASE] = "https://optin.safetymails.com"`
- **Prioridade:** 🟡 **ALTO** (necessário para serviço de opt-in)
- **Uso:** URL base do serviço de opt-in SafetyMails

#### **2.1.7. `RPA_API_BASE_URL`**
- **DEV:** `https://rpaimediatoseguros.com.br`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[RPA_API_BASE_URL] = "https://rpaimediatoseguros.com.br"`
- **Prioridade:** 🟡 **ALTO** (necessário para API RPA)
- **Uso:** URL base da API RPA

#### **2.1.8. `SAFETYMAILS_BASE_DOMAIN`**
- **DEV:** `safetymails.com`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[SAFETYMAILS_BASE_DOMAIN] = "safetymails.com"`
- **Prioridade:** 🟡 **ALTO** (necessário para domínio SafetyMails)
- **Uso:** Domínio base do SafetyMails

### **2.2. Variáveis Booleanas (3 variáveis)**

#### **2.2.1. `RPA_ENABLED`**
- **DEV:** `false` (com aspas)
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟢 **ADICIONAR** em PROD: `env[RPA_ENABLED] = "false"`
- **Prioridade:** 🟢 **MÉDIO** (formato boolean com aspas)
- **Nota:** Formato com aspas garante leitura correta pelo PHP

#### **2.2.2. `USE_PHONE_API`**
- **DEV:** `true` (com aspas)
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟢 **ADICIONAR** em PROD: `env[USE_PHONE_API] = "true"`
- **Prioridade:** 🟢 **MÉDIO** (formato boolean com aspas)
- **Nota:** Formato com aspas garante leitura correta pelo PHP

#### **2.2.3. `VALIDAR_PH3A`**
- **DEV:** `false` (com aspas)
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟢 **ADICIONAR** em PROD: `env[VALIDAR_PH3A] = "false"`
- **Prioridade:** 🟢 **MÉDIO** (formato boolean com aspas)
- **Nota:** Formato com aspas garante leitura correta pelo PHP

### **2.3. Variáveis PH3A (4 variáveis)**

#### **2.3.1. `PH3A_API_KEY`**
- **DEV:** `691dd2aa-9af4-84f2-06f9-350e1d709602`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[PH3A_API_KEY] = "691dd2aa-9af4-84f2-06f9-350e1d709602"`
- **Prioridade:** 🟡 **ALTO** (necessário para API PH3A)
- **Uso:** Chave de API PH3A

#### **2.3.2. `PH3A_DATA_URL`**
- **DEV:** `https://api.ph3a.com.br/DataBusca/api/Data/GetData`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[PH3A_DATA_URL] = "https://api.ph3a.com.br/DataBusca/api/Data/GetData"`
- **Prioridade:** 🟡 **ALTO** (necessário para API PH3A)
- **Uso:** URL de dados PH3A

#### **2.3.3. `PH3A_LOGIN_URL`**
- **DEV:** `https://api.ph3a.com.br/DataBusca/api/Account/Login`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[PH3A_LOGIN_URL] = "https://api.ph3a.com.br/DataBusca/api/Account/Login"`
- **Prioridade:** 🟡 **ALTO** (necessário para API PH3A)
- **Uso:** URL de login PH3A

#### **2.3.4. `PH3A_PASSWORD`**
- **DEV:** `ImdSeg2025$$`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[PH3A_PASSWORD] = "ImdSeg2025$$"`
- **Prioridade:** 🟡 **ALTO** (necessário para autenticação PH3A)
- **Uso:** Senha PH3A

#### **2.3.5. `PH3A_USERNAME`**
- **DEV:** `alex.kaminski@imediatoseguros.com.br`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[PH3A_USERNAME] = "alex.kaminski@imediatoseguros.com.br"`
- **Prioridade:** 🟡 **ALTO** (necessário para autenticação PH3A)
- **Uso:** Usuário PH3A

### **2.4. Variáveis PLACAFIPE (2 variáveis)**

#### **2.4.1. `PLACAFIPE_API_TOKEN`**
- **DEV:** `1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[PLACAFIPE_API_TOKEN] = "1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214"`
- **Prioridade:** 🟡 **ALTO** (necessário para API PLACAFIPE)
- **Uso:** Token de API PLACAFIPE

#### **2.4.2. `PLACAFIPE_API_URL`**
- **DEV:** `https://api.placafipe.com.br/getplaca`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[PLACAFIPE_API_URL] = "https://api.placafipe.com.br/getplaca"`
- **Prioridade:** 🟡 **ALTO** (necessário para API PLACAFIPE)
- **Uso:** URL da API PLACAFIPE

### **2.5. Variável OCTADESK_FROM**

#### **2.5.1. `OCTADESK_FROM`**
- **DEV:** `+551132301422`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟢 **ADICIONAR** em PROD: `env[OCTADESK_FROM] = "+551132301422"`
- **Prioridade:** 🟢 **MÉDIO** (necessário para projeto "Eliminar Últimos Hardcodes")
- **Uso:** Número remetente OctaDesk (formato E.164)
- **Nota:** Adicionada em DEV em 22/11/2025 para eliminar hardcode em `add_webflow_octa.php`

### **2.6. Variável SUCCESS_PAGE_URL**

#### **2.6.1. `SUCCESS_PAGE_URL`**
- **DEV:** `https://www.segurosimediato.com.br/sucesso`
- **PROD:** ❌ **NÃO EXISTE**
- **Ação:** 🟡 **ADICIONAR** em PROD: `env[SUCCESS_PAGE_URL] = "https://www.segurosimediato.com.br/sucesso"`
- **Prioridade:** 🟡 **ALTO** (necessário para redirecionamento após sucesso)
- **Uso:** URL da página de sucesso

---

## ✅ CATEGORIA 3: VARIÁVEIS ESPECÍFICAS DE AMBIENTE (7 variáveis)

### **3.1. Variáveis que DEVEM ter valores diferentes em PROD**

Estas variáveis já estão corretas em PROD e **NÃO devem ser modificadas**:

1. ✅ `APP_BASE_DIR` = `/var/www/html/prod/root` (PROD) vs `/var/www/html/dev/root` (DEV)
2. ✅ `APP_BASE_URL` = `https://prod.bssegurosimediato.com.br` (PROD) vs `https://dev.bssegurosimediato.com.br` (DEV)
3. ✅ `APP_CORS_ORIGINS` = Valores PROD vs Valores DEV
4. ✅ `ESPOCRM_URL` = `https://flyingdonkeys.com.br` (PROD) vs `https://dev.flyingdonkeys.com.br` (DEV)
5. ✅ `ESPOCRM_API_KEY` = Valores diferentes (esperado)
6. ✅ `LOG_DB_NAME` = `rpa_logs_prod` (PROD) vs `rpa_logs_dev` (DEV)
7. ✅ `LOG_DB_USER` = `rpa_logger_prod` (PROD) vs `rpa_logger_dev` (DEV)
8. ✅ `PHP_ENV` = `production` (PROD) vs `development` (DEV)
9. ✅ `WEBFLOW_SECRET_FLYINGDONKEYS` = Valores diferentes (esperado)
10. ✅ `WEBFLOW_SECRET_OCTADESK` = Valores diferentes (esperado)

**Ação:** ✅ **NENHUMA** - Estas variáveis estão corretas e não devem ser modificadas

---

## 📋 RESUMO DE AÇÕES NECESSÁRIAS

### **🔴 CRÍTICO - Modificar (1 variável):**

1. ⚠️ `AWS_SES_FROM_EMAIL`: Modificar de `noreply@bssegurosimediato.com.br` para `noreply@bpsegurosimediato.com.br`

### **🔴 CRÍTICO - Adicionar (3 variáveis):**

1. ⚠️ `APILAYER_KEY`: Adicionar `env[APILAYER_KEY] = "dce92fa84152098a3b5b7b8db24debbc"`
2. ⚠️ `SAFETY_TICKET`: Adicionar `env[SAFETY_TICKET] = "05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`
3. ⚠️ `SAFETY_API_KEY`: Adicionar `env[SAFETY_API_KEY] = "20a7a1c297e39180bd80428ac13c363e882a531f"`

### **🟡 ALTO - Adicionar (13 variáveis):**

1. ⚠️ `AWS_SES_FROM_NAME`: Adicionar `env[AWS_SES_FROM_NAME] = BP Seguros Imediato`
2. ⚠️ `VIACEP_BASE_URL`: Adicionar `env[VIACEP_BASE_URL] = "https://viacep.com.br"`
3. ⚠️ `APILAYER_BASE_URL`: Adicionar `env[APILAYER_BASE_URL] = "https://apilayer.net"`
4. ⚠️ `SAFETYMAILS_OPTIN_BASE`: Adicionar `env[SAFETYMAILS_OPTIN_BASE] = "https://optin.safetymails.com"`
5. ⚠️ `RPA_API_BASE_URL`: Adicionar `env[RPA_API_BASE_URL] = "https://rpaimediatoseguros.com.br"`
6. ⚠️ `SAFETYMAILS_BASE_DOMAIN`: Adicionar `env[SAFETYMAILS_BASE_DOMAIN] = "safetymails.com"`
7. ⚠️ `PH3A_API_KEY`: Adicionar `env[PH3A_API_KEY] = "691dd2aa-9af4-84f2-06f9-350e1d709602"`
8. ⚠️ `PH3A_DATA_URL`: Adicionar `env[PH3A_DATA_URL] = "https://api.ph3a.com.br/DataBusca/api/Data/GetData"`
9. ⚠️ `PH3A_LOGIN_URL`: Adicionar `env[PH3A_LOGIN_URL] = "https://api.ph3a.com.br/DataBusca/api/Account/Login"`
10. ⚠️ `PH3A_PASSWORD`: Adicionar `env[PH3A_PASSWORD] = "ImdSeg2025$$"`
11. ⚠️ `PH3A_USERNAME`: Adicionar `env[PH3A_USERNAME] = "alex.kaminski@imediatoseguros.com.br"`
12. ⚠️ `PLACAFIPE_API_TOKEN`: Adicionar `env[PLACAFIPE_API_TOKEN] = "1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214"`
13. ⚠️ `PLACAFIPE_API_URL`: Adicionar `env[PLACAFIPE_API_URL] = "https://api.placafipe.com.br/getplaca"`
14. ⚠️ `SUCCESS_PAGE_URL`: Adicionar `env[SUCCESS_PAGE_URL] = "https://www.segurosimediato.com.br/sucesso"`

### **🟢 MÉDIO - Adicionar (4 variáveis):**

1. ⚠️ `RPA_ENABLED`: Adicionar `env[RPA_ENABLED] = "false"`
2. ⚠️ `USE_PHONE_API`: Adicionar `env[USE_PHONE_API] = "true"`
3. ⚠️ `VALIDAR_PH3A`: Adicionar `env[VALIDAR_PH3A] = "false"`
4. ⚠️ `OCTADESK_FROM`: Adicionar `env[OCTADESK_FROM] = "+551132301422"`

---

## 📊 TOTAL DE VARIÁVEIS A PROCESSAR

- **Modificar:** 1 variável
- **Adicionar:** 20 variáveis
- **Total:** 21 variáveis

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **Variável que existe em PROD mas NÃO em DEV:**

#### **`LOG_DIR`**
- **PROD:** `env[LOG_DIR] = /var/log/webflow-segurosimediato`
- **DEV:** ❌ **NÃO EXISTE**
- **Status:** ⚠️ **VARIÁVEL EXISTE APENAS EM PROD**
- **Ação:** ℹ️ **INFORMATIVO** - Esta variável existe em PROD mas não em DEV
- **Nota:** Pode ser necessário adicionar em DEV também, mas isso está fora do escopo desta análise (foco: atualizar PROD)

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- **Documento de Alterações:** `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_20251121.md`
- **Relatório de Variáveis Modificadas:** `RELATORIO_VARIAVEIS_AMBIENTE_MODIFICADAS_DEV.md`
- **Projeto Eliminar Hardcodes:** `PROJETO_ELIMINAR_ULTIMOS_HARDCODES_20251122.md`

---

**Última Atualização:** 22/11/2025  
**Próxima Ação:** Criar script PowerShell para atualizar variáveis em PROD

