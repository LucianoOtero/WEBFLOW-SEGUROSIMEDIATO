# 📋 Projeto: Instalar AWS SDK em Produção

**Data:** 16/11/2025  
**Status:** 📋 **PENDENTE**  
**Prioridade:** 🟡 **MÉDIA**

---

## 🎯 OBJETIVO

Instalar AWS SDK no servidor de produção para habilitar envio de emails de notificação quando usuário preenche telefone no modal.

---

## 🔍 PROBLEMA

- ❌ Diretório `/var/www/html/prod/root/vendor/` não existe
- ❌ AWS SDK não pode ser carregado
- ❌ Emails de notificação falham com erro: `AWS SDK não instalado`

---

## ✅ SOLUÇÃO ESCOLHIDA

**Opção 2: Copiar vendor de DEV para PROD**

**Justificativa:**
- ✅ Mais rápido (vendor já existe em DEV)
- ✅ Usa mesma versão testada em DEV
- ✅ Menos risco
- ✅ Consistência entre ambientes

---

## 📋 FASES DO PROJETO

### **FASE 1: Verificar vendor em DEV**

**Objetivo:** Confirmar que vendor existe e está funcional em DEV

**Comandos:**
```bash
# Verificar se vendor existe
ssh root@65.108.156.14 "ls -la /var/www/html/dev/root/vendor/autoload.php"

# Verificar se AWS SDK está funcional
ssh root@65.108.156.14 "php -r \"require '/var/www/html/dev/root/vendor/autoload.php'; echo class_exists('Aws\Ses\SesClient') ? 'OK' : 'ERRO';\""
```

**Resultado Esperado:**
- ✅ Arquivo `vendor/autoload.php` existe
- ✅ Classe `Aws\Ses\SesClient` está disponível

---

### **FASE 2: Criar backup em PROD (se vendor existir parcialmente)**

**Objetivo:** Fazer backup de qualquer vendor existente antes de copiar

**Comandos:**
```bash
# Verificar se vendor existe parcialmente
ssh root@157.180.36.223 "ls -la /var/www/html/prod/root/vendor/ 2>&1"

# Se existir, criar backup
ssh root@157.180.36.223 "if [ -d '/var/www/html/prod/root/vendor' ]; then mv /var/www/html/prod/root/vendor /var/www/html/prod/root/vendor.backup_\$(date +%Y%m%d_%H%M%S); fi"
```

**Resultado Esperado:**
- ✅ Backup criado (se necessário)
- ✅ Diretório pronto para receber vendor de DEV

---

### **FASE 3: Copiar vendor de DEV para PROD**

**Objetivo:** Transferir diretório vendor completo de DEV para PROD

**Comandos:**
```bash
# Copiar vendor de DEV para PROD via SCP
scp -r root@65.108.156.14:/var/www/html/dev/root/vendor /var/www/html/prod/root/

# OU via SSH direto (mais rápido se ambos servidores permitirem)
ssh root@157.180.36.223 "scp -r root@65.108.156.14:/var/www/html/dev/root/vendor /var/www/html/prod/root/"
```

**Resultado Esperado:**
- ✅ Diretório `vendor/` copiado para `/var/www/html/prod/root/`
- ✅ Arquivo `vendor/autoload.php` existe

---

### **FASE 4: Ajustar permissões**

**Objetivo:** Garantir que PHP-FPM (www-data) pode ler arquivos do vendor

**Comandos:**
```bash
# Ajustar proprietário e grupo
ssh root@157.180.36.223 "chown -R www-data:www-data /var/www/html/prod/root/vendor"

# Ajustar permissões
ssh root@157.180.36.223 "chmod -R 755 /var/www/html/prod/root/vendor"

# Verificar permissões
ssh root@157.180.36.223 "ls -la /var/www/html/prod/root/vendor/autoload.php"
```

**Resultado Esperado:**
- ✅ Proprietário: `www-data:www-data`
- ✅ Permissões: `755` (diretórios) e `644` (arquivos)
- ✅ Arquivo `autoload.php` acessível

---

### **FASE 5: Verificar instalação**

**Objetivo:** Confirmar que AWS SDK está funcional em PROD

**Comandos:**
```bash
# Verificar se arquivo existe
ssh root@157.180.36.223 "ls -la /var/www/html/prod/root/vendor/autoload.php"

# Verificar se classe está disponível
ssh root@157.180.36.223 "php -r \"require '/var/www/html/prod/root/vendor/autoload.php'; echo class_exists('Aws\Ses\SesClient') ? 'OK - AWS SDK funcional' : 'ERRO - Classe não encontrada';\""

# Verificar tamanho do diretório (deve ser similar ao DEV)
ssh root@157.180.36.223 "du -sh /var/www/html/prod/root/vendor"
```

**Resultado Esperado:**
- ✅ Arquivo `vendor/autoload.php` existe
- ✅ Classe `Aws\Ses\SesClient` está disponível
- ✅ Tamanho do diretório similar ao DEV

---

### **FASE 6: Testar envio de email**

**Objetivo:** Validar que sistema de email funciona em produção

**Teste Manual:**
1. Acessar site em produção
2. Preencher formulário com DDD e telefone
3. Verificar console do navegador (não deve ter erro de AWS SDK)
4. Verificar se email foi enviado (se possível)

**Comandos de Verificação:**
```bash
# Verificar logs do PHP-FPM para erros
ssh root@157.180.36.223 "tail -n 50 /var/log/php8.3-fpm.log | grep -i 'aws\|ses\|email'"

# Verificar logs do sistema de logging profissional
ssh root@157.180.36.223 "tail -n 50 /var/log/webflow-segurosimediato/application_logs.txt | grep -i 'email'"
```

**Resultado Esperado:**
- ✅ Sem erros de AWS SDK nos logs
- ✅ Email enviado com sucesso (ou erro diferente, não relacionado ao AWS SDK)

---

## 📊 CHECKLIST DE EXECUÇÃO

- [ ] **FASE 1:** Verificar vendor em DEV
- [ ] **FASE 2:** Criar backup em PROD (se necessário)
- [ ] **FASE 3:** Copiar vendor de DEV para PROD
- [ ] **FASE 4:** Ajustar permissões
- [ ] **FASE 5:** Verificar instalação
- [ ] **FASE 6:** Testar envio de email

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **1. Tamanho do Diretório vendor**
- O diretório `vendor/` pode ser grande (vários MB)
- A cópia pode levar alguns minutos dependendo da conexão

### **2. Permissões**
- ⚠️ **CRÍTICO:** PHP-FPM roda como `www-data`
- ⚠️ **CRÍTICO:** Diretório vendor deve ser legível por `www-data`
- ⚠️ **CRÍTICO:** Verificar permissões após cópia

### **3. Sincronização Futura**
- Se AWS SDK for atualizado em DEV, será necessário copiar novamente
- Alternativa futura: Usar Composer em PROD para gerenciar dependências

### **4. Backup**
- Sempre criar backup antes de modificar vendor em PROD
- Manter backup por pelo menos 7 dias

---

## 🔄 ALTERNATIVA FUTURA

### **Opção 1: Instalar via Composer (Recomendada para Futuro)**

**Quando usar:**
- Quando quiser gerenciamento formal de dependências
- Quando precisar atualizar AWS SDK independentemente de DEV
- Quando quiser seguir boas práticas de gerenciamento de dependências

**Comandos:**
```bash
# 1. Criar composer.json (se não existir)
cd /var/www/html/prod/root
composer init --no-interaction

# 2. Instalar AWS SDK
composer require aws/aws-sdk-php --no-interaction

# 3. Verificar
php -r "require 'vendor/autoload.php'; echo class_exists('Aws\Ses\SesClient') ? 'OK' : 'ERRO';"
```

**Vantagens:**
- ✅ Gerenciamento formal de dependências
- ✅ Fácil atualização (`composer update`)
- ✅ Versionamento de dependências

**Desvantagens:**
- ⚠️ Requer Composer instalado (já está)
- ⚠️ Pode instalar versão diferente de DEV

---

## 📝 NOTAS

- **Prioridade:** 🟡 **MÉDIA** (funcionalidade não crítica, mas importante)
- **Impacto:** Emails de notificação não são enviados quando usuário preenche telefone
- **Complexidade:** Baixa (cópia de diretório)
- **Tempo Estimado:** 15-30 minutos

---

## 🔗 RELACIONADO

- **Análise:** `ANALISE_ERRO_AWS_SDK_NAO_INSTALADO_PROD.md`
- **Documentação DEV:** `RECUPERACAO_ENDPOINT_EMAIL.md`
- **Arquivo Afetado:** `send_admin_notification_ses.php`

---

**Status:** 📋 **PENDENTE - AGUARDANDO AUTORIZAÇÃO PARA IMPLEMENTAÇÃO**

