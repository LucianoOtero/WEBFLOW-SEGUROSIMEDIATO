# 🔍 ANÁLISE HTTP 500 - Dados do Console

**Data:** 09/11/2025  
**Status:** 🔄 **ANÁLISE EM ANDAMENTO**

---

## 📊 OBSERVAÇÕES DO CONSOLE

### **Padrão Observado:**

1. **Muitos logs com sucesso (HTTP 200):**
   - ✅ A maioria dos logs está sendo processada com sucesso
   - ✅ Logs INFO, DEBUG, WARN estão funcionando
   - ✅ Duração média: ~1000ms (1 segundo)

2. **Erros HTTP 500 intermitentes:**
   - ❌ Alguns logs específicos estão falhando
   - ❌ Request IDs dos erros:
     - `req_1762729181030_wi9jsbv54` (Cookie verificado após salvamento)
     - `req_1762729181041_j9pzrsyw0` (Handler click configurado: whatsappfone2)
     - `req_1762729181030_04jff1sde` (Campo GCLID_FLD[0] preenchido)
     - `req_1762729181033_nrzdbnv8v` (Cookie já existe)
     - `req_1762729181028_2ga5vue96` (Todas as constantes disponíveis)
     - `req_1762729181041_yb1kw0ouq` (Handler click configurado: whatsappfone2)
     - `req_1762729181034_pl8yjed9e` (CollectChatAttributes configurado)
     - `req_1762729181040_k3h3kdlnt` (Handler click configurado: whatsapplink)
     - `req_1762729181150_6kq057hm8` (jQuery disponível)

3. **Padrão dos erros:**
   - Não parece ser relacionado a um tipo específico de log
   - Não parece ser relacionado a um nível específico (DEBUG, INFO, etc.)
   - Ocorre intermitentemente
   - Alguns logs similares funcionam, outros falham

---

## 🔍 INFORMAÇÕES CAPTURADAS

### **Do Console JavaScript:**

- ✅ Payload completo sendo enviado
- ✅ Request ID único para cada requisição
- ✅ Status HTTP da resposta
- ⚠️ `response_data` está colapsado (`{…}`) - precisa expandir

### **Próximos Passos:**

1. **Expandir logging no JavaScript** para mostrar `response_data` completo
2. **Verificar logs do servidor PHP** para ver detalhes do erro
3. **Identificar padrão** nos logs que falham

---

## 📋 REQUEST IDs DOS ERROS

Para rastrear no servidor, use estes Request IDs:

```
req_1762729181030_wi9jsbv54
req_1762729181041_j9pzrsyw0
req_1762729181030_04jff1sde
req_1762729181033_nrzdbnv8v
req_1762729181028_2ga5vue96
req_1762729181041_yb1kw0ouq
req_1762729181034_pl8yjed9e
req_1762729181040_k3h3kdlnt
req_1762729181150_6kq057hm8
```

---

## 🎯 AÇÕES TOMADAS

1. ✅ **Logging expandido no JavaScript:**
   - Agora mostra `response_data` completo
   - Mostra `debug` info separadamente se disponível
   - Logs mais detalhados para facilitar análise

2. ⏳ **Verificando logs do servidor:**
   - Buscando por exceções
   - Buscando por erros de conexão
   - Buscando por falhas de inserção

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Status:** 🔄 **AGUARDANDO LOGS DO SERVIDOR**

