# 📋 Verificação de Logs - Submissão do Formulário

## 📅 Data/Hora da Verificação

**Data:** 2025-11-12  
**Hora da Verificação:** 21:00:48 UTC (após submissão)

---

## 📊 Status dos Arquivos de Log

### **1. flyingdonkeys_dev.txt**

**Última Modificação:** 2025-11-12 21:00:48  
**Total de Linhas:** 635  
**Localização:** `/var/log/webflow-segurosimediato/flyingdonkeys_dev.txt` ✅

**Últimas Entradas:**
- **Timestamp:** 2025-11-12 21:00:48
- **Evento:** `signature_validation_failed`
- **Status:** ❌ Falha na validação de assinatura
- **IP:** 104.23.211.186
- **Motivo:** `signature_invalid`

**Observação:** A requisição foi recebida mas falhou na validação de assinatura do Webflow. Isso pode indicar:
- Secret key incorreta no Webflow Dashboard
- Payload modificado durante transmissão
- Timestamp incorreto

---

### **2. webhook_octadesk_prod.txt**

**Última Modificação:** 2025-11-12 21:00:48  
**Total de Linhas:** 10  
**Localização:** `/var/log/webflow-segurosimediato/webhook_octadesk_prod.txt` ✅

**Últimas Entradas:**
- **Timestamp:** 2025-11-12 21:00:48
- **Evento:** `webhook_received`
- **Status:** ✅ Requisição recebida
- **IP:** 35.170.124.222 (Cloudflare)
- **Headers:** Contém `X-Webflow-Signature` e `X-Webflow-Timestamp`
- **Erro:** `invalid_signature` - Falha na validação de assinatura

**Observação:** A requisição foi recebida mas também falhou na validação de assinatura.

---

## 🔍 Análise Detalhada

### **Requisições Detectadas**

**1. Requisição às 21:00:48 (add_flyingdonkeys.php)**
- ✅ Webhook foi chamado
- ❌ Validação de assinatura falhou
- ✅ Log foi escrito em `/var/log/webflow-segurosimediato/` (LOG_DIR correto)

**2. Requisição às 21:00:48 (add_webflow_octa.php)**
- ✅ Webhook foi chamado
- ❌ Validação de assinatura falhou
- ✅ Log foi escrito em `/var/log/webflow-segurosimediato/` (LOG_DIR correto)

### **Problema Identificado**

Ambos os webhooks falharam na validação de assinatura (`signature_invalid`). Isso indica que:

1. **Secret Keys podem estar incorretas** no Webflow Dashboard
2. **OU** as secret keys no servidor DEV não correspondem às configuradas no Webflow
3. **OU** há problema na geração/transmissão da assinatura

### **Verificação de LOG_DIR**

✅ **CONFIRMADO:** Ambos os logs foram escritos no diretório correto:
- `/var/log/webflow-segurosimediato/flyingdonkeys_dev.txt` ✅
- `/var/log/webflow-segurosimediato/webhook_octadesk_prod.txt` ✅

**Conclusão:** `LOG_DIR` está sendo respeitado corretamente.

---

## 📝 Recomendações

1. **Verificar Secret Keys no Webflow Dashboard:**
   - Confirmar que as secret keys configuradas no Webflow correspondem às do servidor DEV
   - Verificar se as secret keys foram atualizadas recentemente

2. **Verificar Secret Keys no Servidor:**
   - Confirmar valores em `/etc/php/8.3/fpm/pool.d/www.conf`:
     - `env[WEBFLOW_SECRET_FLYINGDONKEYS]`
     - `env[WEBFLOW_SECRET_OCTADESK]`

3. **Testar sem Validação de Assinatura:**
   - Temporariamente, testar se os webhooks funcionam sem assinatura (requisições do navegador)
   - Isso confirmaria que o problema é apenas na validação de assinatura

---

**Data da Verificação:** 2025-11-12  
**Status LOG_DIR:** ✅ **CORRETO** - Logs sendo escritos em `/var/log/webflow-segurosimediato/`


