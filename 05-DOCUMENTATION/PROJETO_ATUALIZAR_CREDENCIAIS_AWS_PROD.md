# 📋 Projeto: Atualizar Credenciais AWS no PHP-FPM PROD

**Data:** 16/11/2025  
**Status:** 🔄 **EM EXECUÇÃO**  
**Objetivo:** Atualizar credenciais AWS no PHP-FPM PROD com credenciais reais que funcionam em DEV

---

## 🎯 OBJETIVO

Atualizar as credenciais AWS no PHP-FPM de produção para usar as credenciais reais que estão funcionando em desenvolvimento, resolvendo o erro "InvalidClientTokenId" no envio de emails.

---

## 📋 CREDENCIAIS A ATUALIZAR

### **Valores Atuais (Exemplo - Inválidos):**
```ini
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_REGION] = us-east-1
```

### **Valores Novos (Reais - Funcionam em DEV):**
```ini
env[AWS_ACCESS_KEY_ID] = [AWS_ACCESS_KEY_ID_DEV]
env[AWS_SECRET_ACCESS_KEY] = [AWS_SECRET_ACCESS_KEY_DEV]
env[AWS_REGION] = sa-east-1
```

---

## 📋 FASES DO PROJETO

### **FASE 1: Criar backup do PHP-FPM config no servidor PROD** ✅

**Objetivo:** Criar backup antes de qualquer modificação

**Comandos:**
```bash
ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_aws_$(date +%Y%m%d_%H%M%S)"
```

**Status:** ✅ **CONCLUÍDA**

---

### **FASE 2: Atualizar php-fpm_www_conf_PROD.conf localmente** ✅

**Objetivo:** Modificar arquivo local com credenciais reais

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`

**Mudanças:**
- Linha ~569: `AWS_ACCESS_KEY_ID` atualizado para `[AWS_ACCESS_KEY_ID_DEV]`
- Linha ~570: `AWS_SECRET_ACCESS_KEY` atualizado para `[AWS_SECRET_ACCESS_KEY_DEV]`
- Linha ~571: `AWS_REGION` atualizado para `sa-east-1`

**Status:** ✅ **CONCLUÍDA**

---

### **FASE 3: Copiar arquivo atualizado para servidor PROD** ✅

**Objetivo:** Transferir arquivo modificado para servidor

**Comandos:**
```bash
scp WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf
```

**Status:** ✅ **CONCLUÍDA**

---

### **FASE 4: Verificar hash após cópia** ✅

**Objetivo:** Garantir integridade do arquivo copiado

**Comandos:**
```bash
# Hash local
Get-FileHash -Path "php-fpm_www_conf_PROD.conf" -Algorithm SHA256

# Hash servidor
ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf | cut -d' ' -f1"

# Comparar (case-insensitive)
```

**Status:** ✅ **CONCLUÍDA**

---

### **FASE 5: Verificar sintaxe e reiniciar PHP-FPM** ✅

**Objetivo:** Aplicar mudanças e garantir que PHP-FPM está funcionando

**Comandos:**
```bash
# Verificar sintaxe
ssh root@157.180.36.223 "php-fpm8.3 -t"

# Reiniciar PHP-FPM
ssh root@157.180.36.223 "systemctl restart php8.3-fpm"

# Verificar status
ssh root@157.180.36.223 "systemctl status php8.3-fpm"
```

**Status:** ✅ **CONCLUÍDA**

---

### **FASE 6: Testar envio de email em PROD** ⏭️

**Objetivo:** Validar que credenciais estão funcionando

**Teste:**
```bash
curl -X POST https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{"ddd":"11","celular":"987654321","nome":"Teste"}'
```

**Resultado Esperado:**
```json
{
  "success": true,
  "total_sent": 3,
  "total_failed": 0,
  ...
}
```

**Status:** ✅ **CONCLUÍDA**

**Resultado do Teste:**
```json
{
  "success": true,
  "total_sent": 3,
  "total_failed": 0,
  "total_recipients": 3
}
```

✅ **Email enviado com sucesso!**

---

## 📊 CHECKLIST DE EXECUÇÃO

- [x] **FASE 1:** Backup do PHP-FPM config criado
- [x] **FASE 2:** Arquivo local atualizado
- [x] **FASE 3:** Arquivo copiado para servidor
- [x] **FASE 4:** Hash verificado
- [x] **FASE 5:** PHP-FPM reiniciado
- [x] **FASE 6:** Teste de envio de email ✅ **SUCESSO**

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **1. Segurança das Credenciais**
- ⚠️ Credenciais AWS são sensíveis
- ✅ Arquivo PHP-FPM config não deve ser versionado no Git
- ✅ Credenciais devem ser gerenciadas com cuidado

### **2. Prioridade de Carregamento**
- ✅ PHP-FPM tem prioridade sobre valores hardcoded em `aws_ses_config.php`
- ✅ Variáveis de ambiente do PHP-FPM são usadas primeiro
- ✅ Por isso é necessário atualizar PHP-FPM, não apenas o arquivo PHP

### **3. Região AWS**
- ✅ Região atualizada de `us-east-1` para `sa-east-1` (São Paulo)
- ✅ Região correta para serviços AWS no Brasil

---

## 🔗 RELACIONADO

- **Análise:** `ANALISE_ERRO_EMAIL_CREDENCIAIS_AWS_INVALIDAS.md`
- **Análise Credenciais:** `ANALISE_CREDENCIAIS_AWS_DEV_PROD.md`
- **Arquivo Config:** `php-fpm_www_conf_PROD.conf`

---

**Status:** ✅ **CONCLUÍDO COM SUCESSO**  
**Última Atualização:** 16/11/2025  
**Resultado:** ✅ **Emails sendo enviados com sucesso em PROD**

