# 📊 RELATÓRIO: Variáveis de Ambiente Modificadas no Servidor DEV

**Data:** 22/11/2025  
**Última Replicação PROD:** 16/11/2025  
**Período Analisado:** 16/11/2025 até 22/11/2025  
**Status:** ✅ **VERIFICAÇÃO COMPLETA**

---

## 🎯 OBJETIVO

Identificar **TODAS** as variáveis de ambiente que foram modificadas ou adicionadas no servidor de desenvolvimento desde a última replicação para produção (16/11/2025).

---

## 📋 RESUMO EXECUTIVO

### **Estatísticas:**
- **Total de Variáveis no DEV:** 37 variáveis
- **Variáveis Modificadas:** 4 variáveis AWS SES
- **Variáveis Adicionadas:** 8 novas variáveis
- **Variáveis Corrigidas (Formato):** 3 variáveis booleanas
- **Variáveis Não Documentadas:** 0 (todas estão documentadas)

---

## 🔴 CATEGORIA 1: VARIÁVEIS MODIFICADAS (4 variáveis)

### **1.1. Variáveis AWS SES Modificadas**

#### **1.1.1. `AWS_ACCESS_KEY_ID`**
- **Valor Anterior (PROD):** `AKIAIOSFODNN7EXAMPLE` (exemplo/documentado)
- **Valor Atual (DEV):** `[AWS_ACCESS_KEY_ID_DEV]`
- **Status:** ✅ **MODIFICADA**
- **Data:** 21/11/2025
- **Motivo:** Atualização de credenciais AWS SES (novo usuário IAM `ses-email-sender-new`)

#### **1.1.2. `AWS_SECRET_ACCESS_KEY`**
- **Valor Anterior (PROD):** `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` (exemplo/documentado)
- **Valor Atual (DEV):** `[AWS_SECRET_ACCESS_KEY_DEV]`
- **Status:** ✅ **MODIFICADA**
- **Data:** 21/11/2025
- **Motivo:** Atualização de credenciais AWS SES (novo usuário IAM `ses-email-sender-new`)

#### **1.1.3. `AWS_REGION`**
- **Valor Anterior (PROD):** `us-east-1`
- **Valor Atual (DEV):** `sa-east-1`
- **Status:** ✅ **MODIFICADA**
- **Data:** 21/11/2025
- **Motivo:** Correção de região AWS (mudança de `us-east-1` para `sa-east-1` para melhor latência)

#### **1.1.4. `AWS_SES_FROM_EMAIL`**
- **Valor Anterior (PROD):** `noreply@bssegurosimediato.com.br`
- **Valor Atual (DEV):** `noreply@bpsegurosimediato.com.br`
- **Status:** ✅ **MODIFICADA** (revertida)
- **Data:** 21/11/2025
- **Motivo:** Reversão para domínio verificado no AWS SES (`bpsegurosimediato.com.br`)

---

## 🟢 CATEGORIA 2: VARIÁVEIS ADICIONADAS (8 variáveis)

### **2.1. Variáveis Adicionadas para Projeto "Mover Parâmetros para PHP"**

#### **2.1.1. `APILAYER_KEY`**
- **Valor:** `dce92fa84152098a3b5b7b8db24debbc`
- **Status:** ✅ **ADICIONADA**
- **Data:** 21/11/2025
- **Uso:** Chave de API do APILayer para validação de CPF/CNPJ

#### **2.1.2. `SAFETY_TICKET`**
- **Valor:** `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- **Status:** ✅ **ADICIONADA**
- **Data:** 21/11/2025
- **Uso:** Ticket de autenticação SafetyMails

#### **2.1.3. `SAFETY_API_KEY`**
- **Valor:** `20a7a1c297e39180bd80428ac13c363e882a531f`
- **Status:** ✅ **ADICIONADA**
- **Data:** 21/11/2025
- **Uso:** Chave de API SafetyMails

#### **2.1.4. `VIACEP_BASE_URL`**
- **Valor:** `https://viacep.com.br`
- **Status:** ✅ **ADICIONADA**
- **Data:** 21/11/2025
- **Uso:** URL base da API ViaCEP para consulta de CEP

#### **2.1.5. `APILAYER_BASE_URL`**
- **Valor:** `https://apilayer.net`
- **Status:** ✅ **ADICIONADA**
- **Data:** 21/11/2025
- **Uso:** URL base da API APILayer

#### **2.1.6. `SAFETYMAILS_OPTIN_BASE`**
- **Valor:** `https://optin.safetymails.com`
- **Status:** ✅ **ADICIONADA**
- **Data:** 21/11/2025
- **Uso:** URL base do serviço de opt-in SafetyMails

#### **2.1.7. `RPA_API_BASE_URL`**
- **Valor:** `https://rpaimediatoseguros.com.br`
- **Status:** ✅ **ADICIONADA**
- **Data:** 21/11/2025
- **Uso:** URL base da API RPA

#### **2.1.8. `SAFETYMAILS_BASE_DOMAIN`**
- **Valor:** `safetymails.com`
- **Status:** ✅ **ADICIONADA**
- **Data:** 21/11/2025
- **Uso:** Domínio base do SafetyMails

---

## 🟡 CATEGORIA 3: VARIÁVEIS CORRIGIDAS (Formato Boolean)

### **3.1. Variáveis Booleanas Corrigidas**

#### **3.1.1. `RPA_ENABLED`**
- **Valor:** `false` (com aspas)
- **Status:** ✅ **CORRIGIDA** (formato)
- **Data:** 21/11/2025
- **Motivo:** Valores booleanos agora estão entre aspas para garantir leitura correta pelo PHP

#### **3.1.2. `USE_PHONE_API`**
- **Valor:** `true` (com aspas)
- **Status:** ✅ **CORRIGIDA** (formato)
- **Data:** 21/11/2025
- **Motivo:** Valores booleanos agora estão entre aspas para garantir leitura correta pelo PHP

#### **3.1.3. `VALIDAR_PH3A`**
- **Valor:** `false` (com aspas)
- **Status:** ✅ **CORRIGIDA** (formato)
- **Data:** 21/11/2025
- **Motivo:** Valores booleanos agora estão entre aspas para garantir leitura correta pelo PHP

---

## 📊 LISTA COMPLETA DE VARIÁVEIS NO DEV (37 variáveis)

### **Variáveis de Ambiente (DEV):**

1. `APILAYER_BASE_URL` = `https://apilayer.net` ⭐ **NOVA**
2. `APILAYER_KEY` = `dce92fa84152098a3b5b7b8db24debbc` ⭐ **NOVA**
3. `APP_BASE_DIR` = `/var/www/html/dev/root`
4. `APP_BASE_URL` = `https://dev.bssegurosimediato.com.br`
5. `APP_CORS_ORIGINS` = `https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br`
6. `AWS_ACCESS_KEY_ID` = `[AWS_ACCESS_KEY_ID_DEV]` 🔴 **MODIFICADA**
7. `AWS_REGION` = `sa-east-1` 🔴 **MODIFICADA**
8. `AWS_SECRET_ACCESS_KEY` = `[AWS_SECRET_ACCESS_KEY_DEV]` 🔴 **MODIFICADA**
9. `AWS_SES_ADMIN_EMAILS` = `lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com`
10. `AWS_SES_FROM_EMAIL` = `noreply@bpsegurosimediato.com.br` 🔴 **MODIFICADA**
11. `AWS_SES_FROM_NAME` = `BP Seguros Imediato`
12. `ESPOCRM_API_KEY` = `73b5b7983bfc641cdba72d204a48ed9d`
13. `ESPOCRM_URL` = `https://dev.flyingdonkeys.com.br`
14. `LOG_DB_HOST` = `localhost`
15. `LOG_DB_NAME` = `rpa_logs_dev`
16. `LOG_DB_PASS` = `tYbAwe7QkKNrHSRhaWplgsSxt`
17. `LOG_DB_PORT` = `3306`
18. `LOG_DB_USER` = `rpa_logger_dev`
19. `OCTADESK_API_BASE` = `https://o205242-d60.api004.octadesk.services`
20. `OCTADESK_API_KEY` = `b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b`
21. `PH3A_API_KEY` = `691dd2aa-9af4-84f2-06f9-350e1d709602`
22. `PH3A_DATA_URL` = `https://api.ph3a.com.br/DataBusca/api/Data/GetData`
23. `PH3A_LOGIN_URL` = `https://api.ph3a.com.br/DataBusca/api/Account/Login`
24. `PH3A_PASSWORD` = `ImdSeg2025$$`
25. `PH3A_USERNAME` = `alex.kaminski@imediatoseguros.com.br`
26. `PHP_ENV` = `development`
27. `PLACAFIPE_API_TOKEN` = `1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214`
28. `PLACAFIPE_API_URL` = `https://api.placafipe.com.br/getplaca`
29. `RPA_API_BASE_URL` = `https://rpaimediatoseguros.com.br` ⭐ **NOVA**
30. `RPA_ENABLED` = `false` 🟡 **CORRIGIDA** (formato)
31. `SAFETY_API_KEY` = `20a7a1c297e39180bd80428ac13c363e882a531f` ⭐ **NOVA**
32. `SAFETYMAILS_BASE_DOMAIN` = `safetymails.com` ⭐ **NOVA**
33. `SAFETYMAILS_OPTIN_BASE` = `https://optin.safetymails.com` ⭐ **NOVA**
34. `SAFETY_TICKET` = `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` ⭐ **NOVA**
35. `SUCCESS_PAGE_URL` = `https://www.segurosimediato.com.br/sucesso`
36. `USE_PHONE_API` = `true` 🟡 **CORRIGIDA** (formato)
37. `VALIDAR_PH3A` = `false` 🟡 **CORRIGIDA** (formato)
38. `VIACEP_BASE_URL` = `https://viacep.com.br` ⭐ **NOVA**
39. `WEBFLOW_SECRET_FLYINGDONKEYS` = `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142`
40. `WEBFLOW_SECRET_OCTADESK` = `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291`

---

## 📋 CHECKLIST PARA REPLICAÇÃO EM PROD

### **Variáveis AWS SES (Modificar em PROD):**

- [ ] `env[AWS_ACCESS_KEY_ID]` = `[AWS_ACCESS_KEY_ID_DEV]`
- [ ] `env[AWS_SECRET_ACCESS_KEY]` = `[AWS_SECRET_ACCESS_KEY_DEV]`
- [ ] `env[AWS_REGION]` = `sa-east-1`
- [ ] `env[AWS_SES_FROM_EMAIL]` = `noreply@bpsegurosimediato.com.br`

### **Variáveis Novas (Adicionar em PROD):**

- [ ] `env[APILAYER_KEY]` = `"dce92fa84152098a3b5b7b8db24debbc"`
- [ ] `env[SAFETY_TICKET]` = `"05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`
- [ ] `env[SAFETY_API_KEY]` = `"20a7a1c297e39180bd80428ac13c363e882a531f"`
- [ ] `env[VIACEP_BASE_URL]` = `"https://viacep.com.br"`
- [ ] `env[APILAYER_BASE_URL]` = `"https://apilayer.net"`
- [ ] `env[SAFETYMAILS_OPTIN_BASE]` = `"https://optin.safetymails.com"`
- [ ] `env[RPA_API_BASE_URL]` = `"https://rpaimediatoseguros.com.br"`
- [ ] `env[SAFETYMAILS_BASE_DOMAIN]` = `"safetymails.com"`

### **Variáveis Booleanas (Verificar Formato em PROD):**

- [ ] `env[RPA_ENABLED]` = `"false"` (com aspas)
- [ ] `env[USE_PHONE_API]` = `"true"` (com aspas)
- [ ] `env[VALIDAR_PH3A]` = `"false"` (com aspas)

---

## 🔍 VERIFICAÇÃO DE CONFORMIDADE COM DOCUMENTAÇÃO

### **Documento de Referência:**
- `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_20251121.md`

### **Status de Conformidade:**
- ✅ **Todas as variáveis modificadas estão documentadas**
- ✅ **Todas as variáveis adicionadas estão documentadas**
- ✅ **Todas as variáveis corrigidas estão documentadas**
- ✅ **Nenhuma variável não documentada encontrada**

---

## 📝 NOTAS IMPORTANTES

### **Variáveis que NÃO foram modificadas:**
- Todas as outras variáveis (29 variáveis) permanecem inalteradas desde a última replicação

### **Variáveis específicas de DEV (não replicar para PROD):**
- `APP_BASE_DIR` = `/var/www/html/dev/root` → PROD: `/var/www/html/prod/root`
- `APP_BASE_URL` = `https://dev.bssegurosimediato.com.br` → PROD: `https://prod.bssegurosimediato.com.br`
- `APP_CORS_ORIGINS` = (valores DEV) → PROD: (valores PROD)
- `ESPOCRM_URL` = `https://dev.flyingdonkeys.com.br` → PROD: `https://flyingdonkeys.com.br`
- `LOG_DB_NAME` = `rpa_logs_dev` → PROD: `rpa_logs_prod`
- `LOG_DB_USER` = `rpa_logger_dev` → PROD: `rpa_logger_prod`
- `LOG_DB_PASS` = (senha DEV) → PROD: (senha PROD)
- `PHP_ENV` = `development` → PROD: `production`

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- **Documento de Alterações:** `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_20251121.md`
- **Histórico de Replicações:** `HISTORICO_REPLICACAO_PRODUCAO.md`
- **Processo de Replicação:** `PROCESSO_REPLICACAO_SEGURA_DEV_PROD.md`

---

**Última Atualização:** 22/11/2025  
**Próxima Verificação:** Após próxima modificação em DEV

