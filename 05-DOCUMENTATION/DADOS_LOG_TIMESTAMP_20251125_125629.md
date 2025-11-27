# 📋 Dados do Log - Timestamp 2025-11-25T12:56:29.225Z

**Data da Consulta:** 25/11/2025  
**Servidor:** Produção (`prod.bssegurosimediato.com.br` - IP: 157.180.36.223)  
**Banco de Dados:** `rpa_logs_prod`  
**Tabela:** `application_logs`  
**Status:** ✅ **DADOS ENCONTRADOS**

---

## 📊 LOG PRINCIPAL ENCONTRADO

### **Request ID:** `req_6925a77d8bf6d6.04980051`

**Dados do Log:**
```json
{
    "log_id": "log_6925a77d8c0004.16778508_1764075389.5734_7803",
    "level": "ERROR",
    "category": "EMAIL",
    "message": "Erro ao enviar notificação",
    "file_name": "ProfessionalLogger.php",
    "line_number": 444,
    "function_name": "captureCallerInfo",
    "timestamp": "2025-11-25 12:56:29.000000",
    "request_id": "req_6925a77d8bf6d6.04980051",
    "data": [],
    "stack_trace": "@https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js:430:34\nsendLogToProfessionalSystem@https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js:368:52\nnovo_log@https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js:662:45\n@https://prod.bssegurosimediato.com.br/MODAL_WHATSAPP_DEFINITIVO.js:840:24"
}
```

---

## 🔍 ANÁLISE DO STACK TRACE

### **Fluxo do Erro:**

1. **MODAL_WHATSAPP_DEFINITIVO.js:840**
   - Origem do erro (captura de exceção)

2. **FooterCodeSiteDefinitivoCompleto.js:662**
   - `novo_log()` chamado

3. **FooterCodeSiteDefinitivoCompleto.js:368**
   - `sendLogToProfessionalSystem()` chamado

4. **FooterCodeSiteDefinitivoCompleto.js:430**
   - Envio do log para o backend

5. **ProfessionalLogger.php:444**
   - `captureCallerInfo()` - onde o stack trace foi capturado

---

## 📋 OUTROS LOGS NO MESMO TIMESTAMP

### **Logs Encontrados no Intervalo 12:56:29 - 12:56:30:**

1. **log_6925a77e62f3a9.60509785_1764075390.4053_9157**
   - **Level:** ERROR
   - **Category:** MODAL
   - **Message:** `[ERROR] whatsapp_modal_octadesk_initial_error`
   - **Request ID:** `req_6925a77e62ce07.85615509`
   - **Timestamp:** 2025-11-25 12:56:30.000000

2. **log_6925a77d8c4b02.32623693_1764075389.5747_6733**
   - **Level:** ERROR
   - **Category:** ESPOCRM
   - **Message:** `INITIAL_REQUEST_ERROR`
   - **Request ID:** `req_6925a77d8ba846.48934611`
   - **Timestamp:** 2025-11-25 12:56:29.000000

3. **log_6925a77d8b9374.14383381_1764075389.5717_7719**
   - **Level:** ERROR
   - **Category:** OCTADESK
   - **Message:** `INITIAL_REQUEST_ERROR`
   - **Request ID:** `req_6925a77d8ae748.07044929`
   - **Timestamp:** 2025-11-25 12:56:29.000000

4. **log_6925a77d8c0004.16778508_1764075389.5734_7803** ⭐ **PRINCIPAL**
   - **Level:** ERROR
   - **Category:** EMAIL
   - **Message:** `Erro ao enviar notificação`
   - **Request ID:** `req_6925a77d8bf6d6.04980051`
   - **Timestamp:** 2025-11-25 12:56:29.000000

---

## ✅ CONCLUSÃO

### **Dados Encontrados:**

✅ **Log principal identificado:** `log_6925a77d8c0004.16778508_1764075389.5734_7803`  
✅ **Request ID:** `req_6925a77d8bf6d6.04980051`  
✅ **Timestamp:** `2025-11-25 12:56:29.000000` (corresponde ao `2025-11-25T12:56:29.225Z`)  
✅ **Categoria:** EMAIL  
✅ **Mensagem:** "Erro ao enviar notificação"  
✅ **Stack trace completo disponível**

### **Observações:**

- ⚠️ **Campo `data` está vazio:** `[]` - não há dados adicionais no log
- ⚠️ **Erro ocorre em `ProfessionalLogger.php:444`:** Função `captureCallerInfo()` - onde o stack trace é capturado, não onde o erro real ocorre
- ✅ **Stack trace mostra origem:** `MODAL_WHATSAPP_DEFINITIVO.js:840` - onde a exceção foi capturada

### **Próximos Passos Sugeridos:**

1. Consultar logs relacionados ao mesmo request_id para ver contexto completo
2. Verificar se há logs de requisições HTTP relacionadas (timeout, erro de conexão, etc.)
3. Verificar logs do servidor (Nginx, PHP-FPM) para o mesmo timestamp

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Status:** ✅ Dados encontrados e documentados

