# 🔐 GUIA DE SEGURANÇA - CREDENCIAIS AWS

**Data:** 11/11/2025  
**Status:** ✅ **IMPLEMENTADO**

---

## 📋 RESUMO

Este guia documenta como as credenciais AWS SES são armazenadas e gerenciadas de forma segura no projeto.

---

## 🎯 SOLUÇÃO IMPLEMENTADA

### **1. Arquivo `.env.local` (Recomendado para desenvolvimento local)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/.env.local`

**Características:**
- ✅ **NÃO é versionado** no Git (adicionado ao `.gitignore`)
- ✅ Carregado automaticamente pelo `aws_ses_config.php`
- ✅ Apenas no seu computador local
- ✅ Fácil de usar e modificar

**Conteúdo:**
```ini
AWS_ACCESS_KEY_ID=[CONFIGURE_AWS_ACCESS_KEY_ID]
AWS_SECRET_ACCESS_KEY=[CONFIGURE_AWS_SECRET_ACCESS_KEY]
AWS_REGION=sa-east-1
```

### **2. Arquivo de Referência Local**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/CREDENCIAIS_AWS_REFERENCIA.txt`

**Características:**
- ✅ **NÃO é versionado** no Git
- ✅ Apenas para referência local
- ✅ Contém as credenciais para consulta rápida

### **3. Variáveis de Ambiente no Servidor (Recomendado para produção)**

**Localização no servidor:** Configurado no PHP-FPM pool ou Docker

**Como configurar:**
```bash
# No servidor, adicionar ao PHP-FPM pool ou docker-compose.yml
env[AWS_ACCESS_KEY_ID] = [CONFIGURE_AWS_ACCESS_KEY_ID]
env[AWS_SECRET_ACCESS_KEY] = [CONFIGURE_AWS_SECRET_ACCESS_KEY]
env[AWS_REGION] = sa-east-1
```

---

## 🔄 PRIORIDADE DE CARREGAMENTO

O arquivo `aws_ses_config.php` carrega as credenciais na seguinte ordem:

1. **Variáveis de ambiente** (`$_ENV`) - **MAIOR PRIORIDADE**
2. **Arquivo `.env.local`** (se existir localmente)
3. **Valores padrão** (apenas se nenhum dos anteriores estiver disponível)

---

## 🛡️ PROTEÇÕES IMPLEMENTADAS

### **`.gitignore`**

Os seguintes arquivos são **automaticamente ignorados** pelo Git:

```
.env.local
.env
*.env.local
*.env
aws_ses_config.php
*_ses_config*.php
CREDENCIAIS_AWS_REFERENCIA.txt
**/backups/**/aws_ses_config*.php
```

### **Verificação**

Para verificar se os arquivos estão protegidos:

```bash
git status
# Os arquivos acima NÃO devem aparecer como "untracked"
```

---

## 📱 GERENCIADORES DE SENHAS RECOMENDADOS

### **1. Bitwarden** (Gratuito e Open Source)
- ✅ Gratuito
- ✅ Código aberto
- ✅ Sincronização entre dispositivos
- ✅ Extensão para navegadores
- 🔗 https://bitwarden.com

### **2. 1Password** (Pago, mas muito seguro)
- ✅ Interface excelente
- ✅ Integração com navegadores
- ✅ Compartilhamento seguro de equipes
- 🔗 https://1password.com

### **3. LastPass** (Freemium)
- ✅ Versão gratuita disponível
- ✅ Extensões para navegadores
- ✅ Compartilhamento de equipes
- 🔗 https://www.lastpass.com

### **4. KeePass** (Gratuito e Local)
- ✅ Totalmente gratuito
- ✅ Armazena localmente (sem nuvem)
- ✅ Muito seguro
- 🔗 https://keepass.info

---

## 🔧 COMO USAR

### **Desenvolvimento Local:**

1. O arquivo `.env.local` já foi criado com as credenciais
2. O `aws_ses_config.php` carrega automaticamente
3. **Não precisa fazer nada** - funciona automaticamente

### **Servidor (Produção/DEV):**

1. Configurar variáveis de ambiente no PHP-FPM ou Docker
2. O `aws_ses_config.php` usa automaticamente as variáveis de ambiente
3. **Não precisa** do arquivo `.env.local` no servidor

---

## ⚠️ IMPORTANTE

1. **NUNCA commite** arquivos com credenciais no Git
2. **NUNCA compartilhe** credenciais por email ou chat
3. **SEMPRE use** variáveis de ambiente no servidor
4. **MANTENHA** o `.gitignore` atualizado
5. **ROTACIONE** as credenciais periodicamente (a cada 90 dias)

---

## 🔄 RECUPERAÇÃO DE CREDENCIAIS

Se você precisar recuperar as credenciais:

1. **Arquivo local:** `CREDENCIAIS_AWS_REFERENCIA.txt`
2. **Gerenciador de senhas:** Se você salvou lá
3. **AWS Console:** IAM → Users → Security credentials
4. **Servidor:** Verificar variáveis de ambiente configuradas

---

## 📝 CREDENCIAIS ATUAIS

**AWS Access Key ID:** `[CONFIGURE_AWS_ACCESS_KEY_ID]`  
**AWS Secret Access Key:** `[CONFIGURE_AWS_SECRET_ACCESS_KEY]`  
**AWS Region:** `sa-east-1`

**⚠️ IMPORTANTE:** As credenciais reais estão armazenadas apenas em:
- `.env.local` (local, não versionado)
- `CREDENCIAIS_AWS_REFERENCIA.txt` (local, não versionado)
- Bitwarden (gerenciador de senhas)
- Variáveis de ambiente no servidor

**⚠️ Estas credenciais estão armazenadas em:**
- ✅ `.env.local` (local, não versionado)
- ✅ `CREDENCIAIS_AWS_REFERENCIA.txt` (local, não versionado)
- ✅ Este documento (apenas para referência)

---

## ✅ CHECKLIST DE SEGURANÇA

- [x] Credenciais removidas dos arquivos versionados
- [x] `.gitignore` configurado corretamente
- [x] Arquivo `.env.local` criado (não versionado)
- [x] Arquivo de referência criado (não versionado)
- [x] `aws_ses_config.php` modificado para usar variáveis de ambiente
- [ ] Credenciais salvas em gerenciador de senhas (recomendado)
- [ ] Variáveis de ambiente configuradas no servidor (produção)

---

**Última atualização:** 11/11/2025

