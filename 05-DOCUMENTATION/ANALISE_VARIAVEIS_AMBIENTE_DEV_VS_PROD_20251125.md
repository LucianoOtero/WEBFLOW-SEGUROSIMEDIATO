# 📊 ANÁLISE: Variáveis de Ambiente DEV vs PROD

**Data:** 25/11/2025  
**Tipo:** Análise Comparativa  
**Status:** ✅ **ANÁLISE COMPLETA**

---

## 📋 RESUMO EXECUTIVO

### **Contagem de Variáveis:**

| Ambiente | Quantidade de Variáveis |
|----------|------------------------|
| **DEV** | **41 variáveis** |
| **PROD** | **42 variáveis** |
| **Diferença** | **+1 variável em PROD** |

---

## 🔍 VARIÁVEIS POR AMBIENTE

### **AMBIENTE DE DESENVOLVIMENTO (DEV) - 41 variáveis:**

1. `APILAYER_BASE_URL`
2. `APILAYER_KEY`
3. `APP_BASE_DIR`
4. `APP_BASE_URL`
5. `APP_CORS_ORIGINS`
6. `AWS_ACCESS_KEY_ID`
7. `AWS_REGION`
8. `AWS_SECRET_ACCESS_KEY`
9. `AWS_SES_ADMIN_EMAILS`
10. `AWS_SES_FROM_EMAIL`
11. `AWS_SES_FROM_NAME`
12. `ESPOCRM_API_KEY`
13. `ESPOCRM_URL`
14. `LOG_DB_HOST`
15. `LOG_DB_NAME`
16. `LOG_DB_PASS`
17. `LOG_DB_PORT`
18. `LOG_DB_USER`
19. `OCTADESK_API_BASE`
20. `OCTADESK_API_KEY`
21. `OCTADESK_FROM`
22. `PH3A_API_KEY`
23. `PH3A_DATA_URL`
24. `PH3A_LOGIN_URL`
25. `PH3A_PASSWORD`
26. `PH3A_USERNAME`
27. `PHP_ENV`
28. `PLACAFIPE_API_TOKEN`
29. `PLACAFIPE_API_URL`
30. `RPA_API_BASE_URL`
31. `RPA_ENABLED`
32. `SAFETY_API_KEY`
33. `SAFETYMAILS_BASE_DOMAIN`
34. `SAFETYMAILS_OPTIN_BASE`
35. `SAFETY_TICKET`
36. `SUCCESS_PAGE_URL`
37. `USE_PHONE_API`
38. `VALIDAR_PH3A`
39. `VIACEP_BASE_URL`
40. `WEBFLOW_SECRET_FLYINGDONKEYS`
41. `WEBFLOW_SECRET_OCTADESK`

---

### **AMBIENTE DE PRODUÇÃO (PROD) - 42 variáveis:**

1. `APILAYER_BASE_URL`
2. `APILAYER_KEY`
3. `APP_BASE_DIR`
4. `APP_BASE_URL`
5. `APP_CORS_ORIGINS`
6. `AWS_ACCESS_KEY_ID`
7. `AWS_REGION`
8. `AWS_SECRET_ACCESS_KEY`
9. `AWS_SES_ADMIN_EMAILS`
10. `AWS_SES_FROM_EMAIL`
11. `AWS_SES_FROM_NAME`
12. `ESPOCRM_API_KEY`
13. `ESPOCRM_URL`
14. `LOG_DB_HOST`
15. `LOG_DB_NAME`
16. `LOG_DB_PASS`
17. `LOG_DB_PORT`
18. `LOG_DB_USER`
19. **`LOG_DIR`** ⚠️ **APENAS EM PROD**
20. `OCTADESK_API_BASE`
21. `OCTADESK_API_KEY`
22. `OCTADESK_FROM`
23. `PH3A_API_KEY`
24. `PH3A_DATA_URL`
25. `PH3A_LOGIN_URL`
26. `PH3A_PASSWORD`
27. `PH3A_USERNAME`
28. `PHP_ENV`
29. `PLACAFIPE_API_TOKEN`
30. `PLACAFIPE_API_URL`
31. `RPA_API_BASE_URL`
32. `RPA_ENABLED`
33. `SAFETY_API_KEY`
34. `SAFETYMAILS_BASE_DOMAIN`
35. `SAFETYMAILS_OPTIN_BASE`
36. `SAFETY_TICKET`
37. `SUCCESS_PAGE_URL`
38. `USE_PHONE_API`
39. `VALIDAR_PH3A`
40. `VIACEP_BASE_URL`
41. `WEBFLOW_SECRET_FLYINGDONKEYS`
42. `WEBFLOW_SECRET_OCTADESK`

---

## 🔍 DIFERENÇAS IDENTIFICADAS

### **1. Variáveis Presentes Apenas em PROD:**

| Variável | Valor em PROD |
|----------|---------------|
| **`LOG_DIR`** | `/var/log/webflow-segurosimediato` |

**Análise:** Esta variável está presente apenas em PROD. Em DEV, ela não está definida no PHP-FPM, mas pode estar sendo usada de outra forma ou não ser necessária.

---

### **2. Variáveis com Valores Diferentes:**

#### **A. Variáveis de Ambiente (URLs e Diretórios):**

| Variável | DEV | PROD |
|----------|-----|------|
| `APP_BASE_DIR` | `/var/www/html/dev/root` | `/var/www/html/prod/root` |
| `APP_BASE_URL` | `https://dev.bssegurosimediato.com.br` | `https://prod.bssegurosimediato.com.br` |
| `APP_CORS_ORIGINS` | `https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br` | `https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br` |
| `ESPOCRM_URL` | `https://dev.flyingdonkeys.com.br` | `https://flyingdonkeys.com.br` |
| `PHP_ENV` | `development` | `production` |

#### **B. Variáveis de Banco de Dados:**

| Variável | DEV | PROD |
|----------|-----|------|
| `LOG_DB_NAME` | `rpa_logs_dev` | `rpa_logs_prod` |
| `LOG_DB_USER` | `rpa_logger_dev` | `rpa_logger_prod` |

#### **C. Variáveis de Credenciais (AWS, EspoCRM, Webflow):**

| Variável | DEV | PROD |
|----------|-----|------|
| `AWS_ACCESS_KEY_ID` | `AKIA3JCQSJTSLPFUVP26` | `AKIA3JCQSJTSMSKFZPW3` |
| `AWS_SECRET_ACCESS_KEY` | `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` | `tfgqmsB0bG4FfHjYjej0ZXdMDouhA5tJ0xk4Pn4z` |
| `ESPOCRM_API_KEY` | `73b5b7983bfc641cdba72d204a48ed9d` | `82d5f667f3a65a9a43341a0705be2b0c` |
| `SAFETY_TICKET` | `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` | `9bab7f0c2711c5accfb83588c859dc1103844a94` |
| `WEBFLOW_SECRET_FLYINGDONKEYS` | `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` | `50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51` |
| `WEBFLOW_SECRET_OCTADESK` | `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291` | `4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd` |

#### **D. Variáveis com Aspas (Formatação):**

**PROD tem aspas em algumas variáveis, DEV não tem:**

| Variável | DEV | PROD |
|----------|-----|------|
| `APILAYER_BASE_URL` | `https://apilayer.net` | `"https://apilayer.net"` |
| `APILAYER_KEY` | `dce92fa84152098a3b5b7b8db24debbc` | `"dce92fa84152098a3b5b7b8db24debbc"` |
| `AWS_SES_FROM_EMAIL` | `noreply@bpsegurosimediato.com.br` | `"noreply@bpsegurosimediato.com.br"` |
| `AWS_SES_FROM_NAME` | `BP Seguros Imediato` | `"BP Seguros Imediato"` |
| `OCTADESK_FROM` | `+551132301422` | `"+551132301422"` |
| `PH3A_API_KEY` | `691dd2aa-9af4-84f2-06f9-350e1d709602` | `"691dd2aa-9af4-84f2-06f9-350e1d709602"` |
| `PH3A_DATA_URL` | `https://api.ph3a.com.br/DataBusca/api/Data/GetData` | `"https://api.ph3a.com.br/DataBusca/api/Data/GetData"` |
| `PH3A_LOGIN_URL` | `https://api.ph3a.com.br/DataBusca/api/Account/Login` | `"https://api.ph3a.com.br/DataBusca/api/Account/Login"` |
| `PH3A_PASSWORD` | `ImdSeg2025$$` | `"ImdSeg2025$$"` |
| `PH3A_USERNAME` | `alex.kaminski@imediatoseguros.com.br` | `"alex.kaminski@imediatoseguros.com.br"` |
| `PLACAFIPE_API_TOKEN` | `1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214` | `"1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214"` |
| `PLACAFIPE_API_URL` | `https://api.placafipe.com.br/getplaca` | `"https://api.placafipe.com.br/getplaca"` |
| `RPA_API_BASE_URL` | `https://rpaimediatoseguros.com.br` | `"https://rpaimediatoseguros.com.br"` |
| `RPA_ENABLED` | `"false"` | `"false"` |
| `SAFETY_API_KEY` | `20a7a1c297e39180bd80428ac13c363e882a531f` | `"20a7a1c297e39180bd80428ac13c363e882a531f"` |
| `SAFETYMAILS_BASE_DOMAIN` | `safetymails.com` | `"safetymails.com"` |
| `SAFETYMAILS_OPTIN_BASE` | `https://optin.safetymails.com` | `"https://optin.safetymails.com"` |
| `SAFETY_TICKET` | `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` | `"9bab7f0c2711c5accfb83588c859dc1103844a94"` |
| `SUCCESS_PAGE_URL` | `https://www.segurosimediato.com.br/sucesso` | `"https://www.segurosimediato.com.br/sucesso"` |
| `USE_PHONE_API` | `"true"` | `"true"` |
| `VALIDAR_PH3A` | `"false"` | `"false"` |
| `VIACEP_BASE_URL` | `https://viacep.com.br` | `"https://viacep.com.br"` |

**Nota:** As aspas em PROD são apenas formatação do arquivo de configuração. O PHP-FPM aceita valores com ou sem aspas, mas as aspas podem ser necessárias para valores que contêm caracteres especiais ou espaços.

---

## 📊 RESUMO DAS DIFERENÇAS

### **Variáveis Idênticas (mesmo nome e valor):**
- Nenhuma (todas têm valores diferentes devido aos ambientes)

### **Variáveis com Mesmo Nome mas Valores Diferentes:**
- **40 variáveis** (todas as variáveis comuns têm valores diferentes entre DEV e PROD, o que é esperado)

### **Variáveis Presentes Apenas em PROD:**
- **1 variável:** `LOG_DIR`

### **Variáveis Presentes Apenas em DEV:**
- **0 variáveis**

---

## ✅ CONCLUSÕES

1. **PROD tem 1 variável a mais que DEV:** `LOG_DIR`
2. **Todas as outras variáveis existem em ambos os ambientes**, mas com valores diferentes (esperado, pois são ambientes diferentes)
3. **As diferenças de valores são esperadas:**
   - URLs diferentes (dev vs prod)
   - Credenciais diferentes (chaves de API, senhas)
   - Configurações de banco de dados diferentes
   - Configurações de ambiente diferentes (`PHP_ENV`)
4. **Formatação diferente:** PROD usa aspas em algumas variáveis, DEV não usa (ambos são válidos no PHP-FPM)

---

## ⚠️ OBSERVAÇÕES

1. **`LOG_DIR` ausente em DEV:** Esta variável está presente apenas em PROD. Se for necessária em DEV, deve ser adicionada.
2. **Formatação com aspas:** PROD usa aspas em muitas variáveis, DEV não usa. Ambos são válidos, mas pode ser interessante padronizar.
3. **Todas as variáveis críticas estão presentes em ambos os ambientes:**
   - `APILAYER_KEY` ✅
   - `SAFETY_TICKET` ✅
   - `SAFETY_API_KEY` ✅
   - `ESPOCRM_API_KEY` ✅
   - `AWS_ACCESS_KEY_ID` ✅
   - `AWS_SECRET_ACCESS_KEY` ✅

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA**

