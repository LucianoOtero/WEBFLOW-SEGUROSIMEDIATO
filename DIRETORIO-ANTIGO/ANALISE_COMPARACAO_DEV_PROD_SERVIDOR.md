# 🔍 ANÁLISE DE COMPARAÇÃO DEV vs PROD - ARQUIVOS NO SERVIDOR

**Data de Criação:** 05/11/2025  
**Status:** ⏳ Aguardando Acesso aos Arquivos do Servidor  
**Versão:** 1.0

---

## 🎯 OBJETIVO

Comparar o conteúdo dos arquivos DEV e PROD **no servidor** para identificar se as diferenças são apenas relacionadas ao ambiente (endpoints, configurações, URLs, etc) ou se há diferenças funcionais significativas.

---

## 📋 ARQUIVOS A COMPARAR NO SERVIDOR

### **1. JavaScript - Footer Codes**

#### **DEV:**
- **Caminho no Servidor:** `/var/www/html/dev/webhooks/FooterCodeSiteDefinitivoCompleto.js`
- **URL:** `https://dev.bpsegurosimediato.com.br/webhooks/FooterCodeSiteDefinitivoCompleto.js`
- **Versão Esperada:** `1.5.0`

#### **PROD:**
- **Caminho no Servidor:** `/var/www/html/dev/webhooks/FooterCodeSiteDefinitivoCompleto_prod.js` ⚠️ (temporariamente em DEV)
- **URL:** `https://dev.bpsegurosimediato.com.br/webhooks/FooterCodeSiteDefinitivoCompleto_prod.js`
- **Versão Esperada:** `1.3_PROD`

**Comparação Anterior (02/11/2025):**
- ✅ Diferenças identificadas: Reordenação de constantes globais (correção de bug) + Workaround modal WhatsApp
- ✅ Diferenças de parametrização: Headers, URLs, comentários de ambiente

---

### **2. JavaScript - Modal WhatsApp**

#### **Arquivo Único:**
- **Caminho no Servidor:** `/var/www/html/dev/webhooks/MODAL_WHATSAPP_DEFINITIVO.js`
- **URL:** `https://dev.bpsegurosimediato.com.br/webhooks/MODAL_WHATSAPP_DEFINITIVO.js`
- **Versão:** `v24`

**Observação:** O modal detecta o ambiente automaticamente via `isDevelopmentEnvironment()` e chama endpoints diferentes conforme o ambiente.

---

### **3. PHP - Endpoints EspoCRM**

#### **DEV:**
- **Caminho no Servidor:** `/var/www/html/dev/webhooks/add_travelangels_dev.php`
- **URL:** `https://bpsegurosimediato.com.br/dev/webhooks/add_travelangels_dev.php`

#### **PROD:**
- **Caminho no Servidor:** `/var/www/html/webhooks/add_flyingdonkeys_v2.php`
- **URL:** `https://bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php`

**Diferenças Esperadas:**
- Nome do arquivo
- URL de acesso
- Possivelmente configurações de ambiente dentro do arquivo

---

### **4. PHP - Endpoints OctaDesk**

#### **DEV:**
- **Caminho no Servidor:** `/var/www/html/dev/webhooks/add_webflow_octa_dev.php`
- **URL:** `https://bpsegurosimediato.com.br/dev/webhooks/add_webflow_octa_dev.php`

#### **PROD:**
- **Caminho no Servidor:** `/var/www/html/webhooks/add_webflow_octa_v2.php`
- **URL:** `https://bpsegurosimediato.com.br/webhooks/add_webflow_octa_v2.php`

**Diferenças Esperadas:**
- Nome do arquivo
- URL de acesso
- Possivelmente configurações de ambiente dentro do arquivo

---

### **5. PHP - Endpoint Email Notification**

#### **DEV:**
- **Caminho no Servidor:** `/var/www/html/dev/webhooks/send_email_notification_endpoint.php`
- **URL:** `https://dev.bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint.php`

#### **PROD:**
- **Caminho no Servidor:** `/var/www/html/webhooks/send_email_notification_endpoint.php`
- **URL:** `https://bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint.php`

**Diferenças Esperadas:**
- URL de acesso
- Possivelmente configurações de ambiente dentro do arquivo

---

## 🔍 ASPECTOS A COMPARAR

### **1. FooterCodeSiteDefinitivoCompleto.js (DEV vs PROD)**

#### **Diferenças Esperadas (Apenas Ambiente):**
- ✅ Headers de versão (`VERSÃO: 1.5` vs `VERSÃO: 1.3_PROD`)
- ✅ URLs de localização nos comentários
- ✅ Comentários de ambiente (`⚠️ AMBIENTE: DEV` vs `⚠️ AMBIENTE: PRODUÇÃO`)
- ✅ SafetyMails Ticket (pode ser diferente se configurado)
- ✅ URL do modal WhatsApp (pode ser diferente se corrigido o Nginx)

#### **Diferenças Funcionais Identificadas Anteriormente:**
- ⚠️ **Reordenação de Constantes Globais** (correção de bug aplicada em PROD)
- ⚠️ **URL do Modal WhatsApp** (workaround temporário em PROD)

#### **Verificar:**
- [ ] Se as constantes globais estão na mesma ordem em ambos
- [ ] Se a URL do modal está correta em ambos
- [ ] Se há outras diferenças funcionais além das já identificadas

---

### **2. MODAL_WHATSAPP_DEFINITIVO.js**

#### **Diferenças Esperadas:**
- ✅ Nenhuma (arquivo único usado por ambos os ambientes)
- ✅ Detecção automática de ambiente via `isDevelopmentEnvironment()`
- ✅ Chamadas de endpoints diferentes conforme ambiente detectado

#### **Verificar:**
- [ ] Se o arquivo é realmente o mesmo em ambos os ambientes
- [ ] Se a detecção de ambiente está funcionando corretamente

---

### **3. Endpoints PHP (DEV vs PROD)**

#### **Diferenças Esperadas (Apenas Ambiente):**
- ✅ Nome do arquivo
- ✅ URLs de acesso
- ✅ Configurações de ambiente (se houver)
- ✅ Credenciais de API (se diferentes entre ambientes)
- ✅ URLs de retorno/callback (se diferentes)

#### **Verificar:**
- [ ] Se a lógica de negócio é idêntica
- [ ] Se apenas configurações de ambiente diferem
- [ ] Se há diferenças funcionais além das esperadas

---

## 📊 COMPARAÇÃO ANTERIOR (02/11/2025)

### **FooterCodeSiteDefinitivoCompleto.js:**

**Resumo:**
- **Linhas DEV:** 1.772
- **Linhas PROD:** 1.785
- **Diferença:** +13 linhas no PROD

**Alterações Identificadas:**

1. **✅ Parametrizações Esperadas:**
   - Headers de versão
   - URLs de localização
   - Comentários de ambiente
   - Mesmas credenciais SafetyMails

2. **⚠️ Alterações Funcionais:**
   - **Reordenação de Constantes Globais:** Constantes movidas para ANTES do Utils em PROD (correção de bug)
   - **URL do Modal WhatsApp:** Workaround temporário usando diretório DEV em PROD

**Conclusão Anterior:**
- ✅ Alterações apropriadas - apenas correções de bug e workaround temporário documentado
- ⚠️ Recomendação: Aplicar mesma correção de constantes no arquivo DEV

---

## 🔄 PROCESSO DE COMPARAÇÃO

### **Opção 1: Via SSH (Recomendado)**

```bash
# Conectar ao servidor
ssh root@46.62.174.150

# Comparar Footer Codes
diff /var/www/html/dev/webhooks/FooterCodeSiteDefinitivoCompleto.js \
     /var/www/html/dev/webhooks/FooterCodeSiteDefinitivoCompleto_prod.js > /tmp/footercode_diff.txt

# Comparar Endpoints EspoCRM
diff /var/www/html/dev/webhooks/add_travelangels_dev.php \
     /var/www/html/webhooks/add_flyingdonkeys_v2.php > /tmp/espocrm_diff.txt

# Comparar Endpoints OctaDesk
diff /var/www/html/dev/webhooks/add_webflow_octa_dev.php \
     /var/www/html/webhooks/add_webflow_octa_v2.php > /tmp/octadesk_diff.txt
```

### **Opção 2: Baixar Arquivos para Comparação Local**

```bash
# Baixar arquivos DEV
scp root@46.62.174.150:/var/www/html/dev/webhooks/FooterCodeSiteDefinitivoCompleto.js ./temp_dev.js
scp root@46.62.174.150:/var/www/html/dev/webhooks/add_travelangels_dev.php ./temp_dev_espocrm.php
scp root@46.62.174.150:/var/www/html/dev/webhooks/add_webflow_octa_dev.php ./temp_dev_octa.php

# Baixar arquivos PROD
scp root@46.62.174.150:/var/www/html/dev/webhooks/FooterCodeSiteDefinitivoCompleto_prod.js ./temp_prod.js
scp root@46.62.174.150:/var/www/html/webhooks/add_flyingdonkeys_v2.php ./temp_prod_espocrm.php
scp root@46.62.174.150:/var/www/html/webhooks/add_webflow_octa_v2.php ./temp_prod_octa.php
```

---

## ✅ CHECKLIST DE COMPARAÇÃO

### **FooterCodeSiteDefinitivoCompleto.js:**
- [ ] Comparar headers e metadados
- [ ] Comparar constantes globais (ordem e valores)
- [ ] Comparar URLs de endpoints
- [ ] Comparar URLs de modal WhatsApp
- [ ] Comparar credenciais SafetyMails
- [ ] Comparar lógica de detecção de ambiente
- [ ] Identificar diferenças funcionais (se houver)

### **MODAL_WHATSAPP_DEFINITIVO.js:**
- [ ] Verificar se é o mesmo arquivo em ambos os ambientes
- [ ] Verificar detecção de ambiente
- [ ] Verificar chamadas de endpoints

### **Endpoints PHP:**
- [ ] Comparar lógica de negócio
- [ ] Comparar configurações de ambiente
- [ ] Comparar credenciais de API
- [ ] Comparar URLs de retorno
- [ ] Identificar diferenças funcionais (se houver)

---

## 📝 RESULTADO ESPERADO

### **Cenário Ideal:**
- ✅ Diferenças apenas relacionadas ao ambiente (URLs, configurações, credenciais)
- ✅ Lógica de negócio idêntica entre DEV e PROD
- ✅ Correções de bugs aplicadas em ambos os ambientes

### **Cenário com Problemas:**
- ⚠️ Diferenças funcionais significativas entre DEV e PROD
- ⚠️ Correções aplicadas apenas em um ambiente
- ⚠️ Configurações inconsistentes

---

## ⚠️ STATUS ATUAL

**Aguardando:**
- Acesso SSH ao servidor, OU
- Arquivos do servidor fornecidos para comparação local

**Próximo Passo:**
Após acesso aos arquivos, realizar comparação detalhada linha por linha e documentar todas as diferenças identificadas.

---

**Documento criado em:** 05/11/2025  
**Status:** ⏳ Aguardando Acesso aos Arquivos  
**Próxima Ação:** Comparar arquivos no servidor quando acesso estiver disponível

