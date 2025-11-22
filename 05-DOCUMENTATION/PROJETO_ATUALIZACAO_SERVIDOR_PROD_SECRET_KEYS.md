# 📋 PROJETO: ATUALIZAÇÃO DO SERVIDOR DE PRODUÇÃO

**Data:** 16/11/2025  
**Status:** 📝 **PROJETO DEFINIDO**  
**Objetivo:** Atualizar o servidor de produção com arquivos do diretório PROD Windows e configurar secret keys

---

## 🎯 OBJETIVO

Atualizar o servidor de produção copiando todos os arquivos do diretório de produção no Windows para o servidor de produção, e atualizar as secret keys do Webflow no PHP-FPM.

**Fluxo obrigatório:** PROD Windows → PROD Servidor

---

## 📁 DIRETÓRIOS E SERVIDORES

### **Windows (Máquina Local):**
- **Diretório PROD:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/`

### **Servidor PROD:**
- **IP:** `157.180.36.223`
- **Diretório:** `/var/www/html/prod/root/`
- **URL:** `https://prod.bssegurosimediato.com.br`

---

## 📋 FASES DO PROJETO

### **FASE 1: BACKUP NO SERVIDOR PROD**

**Objetivo:** Criar backup completo do diretório de produção no servidor antes de qualquer modificação.

**Processo:**
1. Criar backup no servidor com timestamp
2. Verificar backup criado

---

### **FASE 2: CÓPIA PROD WINDOWS → PROD SERVIDOR**

**Objetivo:** Copiar todos os arquivos do diretório de produção no Windows para o servidor de produção.

**Arquivos a Copiar:**
- 3 arquivos JavaScript (.js)
- 13 arquivos PHP (.php)
- 3 templates de email
- composer.json (se necessário)

**Processo:**
1. Copiar arquivos JavaScript
2. Copiar arquivos PHP
3. Copiar templates de email
4. Ajustar permissões no servidor
5. Verificar hash SHA256 de todos os arquivos copiados (case-insensitive)

---

### **FASE 3: ATUALIZAÇÃO DE SECRET KEYS NO PHP-FPM**

**Objetivo:** Atualizar as secret keys do Webflow no arquivo PHP-FPM do servidor de produção.

**Secret Keys a Atualizar:**
- `WEBFLOW_SECRET_FLYINGDONKEYS`: `50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51`
- `WEBFLOW_SECRET_OCTADESK`: `4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd`

**Processo:**
1. Criar backup do arquivo PHP-FPM no servidor
2. Baixar arquivo atual do servidor para local
3. Criar backup local do arquivo baixado
4. Aplicar correções no arquivo local (atualizar secret keys)
5. Copiar arquivo corrigido para servidor
6. Verificar hash após cópia
7. Testar configuração PHP-FPM
8. Reiniciar PHP-FPM
9. Verificar variáveis aplicadas

---

### **FASE 4: VERIFICAÇÃO E TESTES**

**Objetivo:** Verificar que todos os arquivos foram copiados corretamente e testar o funcionamento.

**Processo:**
1. Verificar arquivos no servidor PROD
2. Verificar diretório de templates
3. Testar acesso HTTPS
4. Testar carregamento de arquivo JavaScript
5. Testar endpoint PHP
6. Verificar logs

---

## 📋 CHECKLIST COMPLETO

### **Fase 1: Backup Servidor PROD**
- [ ] Criar backup no servidor com timestamp
- [ ] Verificar backup criado

### **Fase 2: Cópia PROD Windows → PROD Servidor**
- [ ] Copiar arquivos JavaScript para servidor (3 arquivos)
- [ ] Copiar arquivos PHP para servidor (13 arquivos)
- [ ] Criar diretório de templates no servidor e copiar (3 arquivos)
- [ ] Ajustar permissões no servidor
- [ ] Verificar hash SHA256 de todos os arquivos copiados (19 arquivos)
- [ ] Confirmar que todos os hashes coincidem

### **Fase 3: Atualização Secret Keys PHP-FPM**
- [ ] Criar backup do arquivo PHP-FPM no servidor
- [ ] Baixar arquivo atual do servidor para local
- [ ] Criar backup local do arquivo baixado
- [ ] Aplicar correções no arquivo local (2 secret keys)
- [ ] Copiar arquivo corrigido para servidor
- [ ] Verificar hash após cópia
- [ ] Testar configuração PHP-FPM
- [ ] Reiniciar PHP-FPM
- [ ] Verificar secret keys aplicadas

### **Fase 4: Verificação e Testes**
- [ ] Verificar arquivos no servidor PROD
- [ ] Verificar diretório de templates
- [ ] Testar acesso HTTPS
- [ ] Testar carregamento de arquivo JavaScript
- [ ] Testar endpoint PHP
- [ ] Verificar logs

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **Diretivas Obrigatórias Seguidas:**

1. ✅ **Backups Obrigatórios:**
   - Backup do servidor PROD antes de modificar
   - Backup do arquivo PHP-FPM antes de modificar

2. ✅ **Verificação de Hash:**
   - Hash SHA256 verificado após cada cópia
   - Comparação case-insensitive
   - Re-cópia se hash não coincidir

3. ✅ **Caminhos Completos:**
   - Sempre usar caminho completo do workspace
   - Não usar caminhos relativos

4. ✅ **Fluxo Correto:**
   - PROD Windows → PROD Servidor
   - Nunca copiar diretamente de DEV para servidor PROD

5. ✅ **Arquivos Criados Localmente:**
   - Arquivo PHP-FPM corrigido criado localmente primeiro
   - Copiado para servidor via SCP

---

## 📝 SECRET KEYS

### **Valores a Atualizar:**

| Webhook | Nova Secret Key |
|---------|----------------|
| `add_flyingdonkeys` | `50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51` |
| `add_webflow_octa` | `4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd` |

---

**Data de Criação:** 16/11/2025  
**Status:** 📝 **PROJETO DEFINIDO - AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**

