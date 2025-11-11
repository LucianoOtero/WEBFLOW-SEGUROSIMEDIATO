# 🔐 PROTOCOLO DE SEGURANÇA - DEPLOY aws_ses_config.php

**Data:** 11/11/2025  
**Status:** ✅ **IMPLEMENTADO**

---

## ⚠️ PROBLEMA IDENTIFICADO

O arquivo `aws_ses_config.php` foi modificado para:
- ✅ Remover credenciais hardcoded
- ✅ Usar variáveis de ambiente (`$_ENV`)
- ✅ Carregar de `.env.local` (apenas localmente)

**RISCO:** Se copiarmos este arquivo para o servidor sem as variáveis de ambiente configuradas, o sistema pode parar de funcionar.

---

## 🛡️ SOLUÇÃO IMPLEMENTADA

### **1. Remoção do Deploy Automático**

O arquivo `aws_ses_config.php` foi **REMOVIDO** da lista de arquivos copiados automaticamente pelo script `copiar_arquivos_servidor.ps1`.

**Antes:**
```powershell
$arquivosAdicionaisDev = @(
    "aws_ses_config.php"  # ❌ Copiado automaticamente
)
```

**Depois:**
```powershell
$arquivosAdicionaisDev = @(
    # ⚠️ aws_ses_config.php REMOVIDO - NÃO copiar automaticamente
    # Use: .\copiar_aws_ses_config_servidor.ps1 (com verificação de segurança)
)
```

### **2. Script de Deploy Seguro**

Criado script específico: `copiar_aws_ses_config_servidor.ps1`

**Características:**
- ✅ Verifica se variáveis de ambiente estão configuradas no servidor
- ✅ Cria backup automático antes de copiar
- ✅ Solicita confirmação explícita do usuário
- ✅ Fornece instruções se variáveis não estiverem configuradas
- ✅ Valida arquivo após cópia

---

## 📋 PROTOCOLO DE DEPLOY

### **Cenário 1: Variáveis de Ambiente JÁ Configuradas no Servidor**

1. Execute: `.\copiar_aws_ses_config_servidor.ps1`
2. Script verifica variáveis → ✅ Encontradas
3. Cria backup automático
4. Copia arquivo
5. Valida cópia
6. ✅ **Concluído com sucesso**

### **Cenário 2: Variáveis de Ambiente NÃO Configuradas**

1. Execute: `.\copiar_aws_ses_config_servidor.ps1`
2. Script verifica variáveis → ❌ Não encontradas
3. Script apresenta 3 opções:
   - **Opção 1:** Configurar variáveis primeiro (RECOMENDADO)
   - **Opção 2:** Manter arquivo atual no servidor
   - **Opção 3:** Copiar mesmo assim (NÃO RECOMENDADO)

---

## 🔧 CONFIGURAÇÃO DE VARIÁVEIS NO SERVIDOR

### **Método 1: PHP-FPM Pool (Recomendado)**

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Adicionar:**
```ini
[www]
clear_env = no

env[AWS_ACCESS_KEY_ID] = [CONFIGURE_AWS_ACCESS_KEY_ID]
env[AWS_SECRET_ACCESS_KEY] = [CONFIGURE_AWS_SECRET_ACCESS_KEY]
env[AWS_REGION] = sa-east-1
```

**Reiniciar PHP-FPM:**
```bash
systemctl restart php8.3-fpm
```

### **Método 2: Docker (se usar Docker)**

**Arquivo:** `docker-compose.yml`

```yaml
php-dev:
  environment:
    - AWS_ACCESS_KEY_ID=[CONFIGURE_AWS_ACCESS_KEY_ID]
    - AWS_SECRET_ACCESS_KEY=[CONFIGURE_AWS_SECRET_ACCESS_KEY]
    - AWS_REGION=sa-east-1
```

---

## ✅ CHECKLIST ANTES DE COPIAR

Antes de executar `copiar_aws_ses_config_servidor.ps1`, verifique:

- [ ] Variáveis de ambiente AWS configuradas no servidor?
- [ ] PHP-FPM reiniciado após configurar variáveis?
- [ ] Backup do arquivo atual no servidor criado?
- [ ] Teste de envio de email funcionando?

---

## 🧪 VERIFICAÇÃO PÓS-DEPLOY

Após copiar o arquivo, verifique:

### **1. Verificar Variáveis no Servidor:**

```bash
ssh root@65.108.156.14
cd /var/www/html/dev/root
php -r "echo getenv('AWS_ACCESS_KEY_ID') ? 'OK' : 'NAO_CONFIGURADO';"
```

**Resultado esperado:** `OK`

### **2. Testar Carregamento do Arquivo:**

```bash
php -r "require 'aws_ses_config.php'; echo AWS_ACCESS_KEY_ID;"
```

**Resultado esperado:** `[CONFIGURE_AWS_ACCESS_KEY_ID]` (não `[CONFIGURE_VARIAVEL_AMBIENTE]`)

### **3. Testar Envio de Email:**

Execute um teste real de envio de email para confirmar que tudo funciona.

---

## 🔄 FLUXO RECOMENDADO

```
┌─────────────────────────────────────┐
│ 1. Modificar aws_ses_config.php    │
│    (localmente)                     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 2. Verificar variáveis no servidor  │
│    (via SSH ou script)              │
└──────────────┬──────────────────────┘
               │
               ├─✅ Configuradas
               │  └─► 3. Copiar arquivo (script seguro)
               │
               └─❌ Não configuradas
                  └─► 3a. Configurar variáveis primeiro
                      └─► 3b. Depois copiar arquivo
```

---

## 📝 ARQUIVOS RELACIONADOS

- **Script de deploy seguro:** `02-DEVELOPMENT/copiar_aws_ses_config_servidor.ps1`
- **Script de deploy geral:** `02-DEVELOPMENT/copiar_arquivos_servidor.ps1` (exclui aws_ses_config.php)
- **Arquivo modificado:** `02-DEVELOPMENT/aws_ses_config.php`
- **Documentação:** Este arquivo

---

## ⚠️ AVISOS IMPORTANTES

1. **NUNCA copie** `aws_ses_config.php` sem verificar variáveis de ambiente
2. **SEMPRE crie backup** antes de modificar no servidor
3. **SEMPRE teste** após copiar para garantir funcionamento
4. **MANTENHA** as credenciais seguras (Bitwarden, .env.local)

---

## 🔍 VERIFICAÇÃO RÁPIDA

Para verificar rapidamente se está tudo OK:

```bash
# No servidor
cd /var/www/html/dev/root
php -r "
require 'aws_ses_config.php';
echo 'AWS_ACCESS_KEY_ID: ' . (defined('AWS_ACCESS_KEY_ID') ? AWS_ACCESS_KEY_ID : 'NAO_DEFINIDO') . PHP_EOL;
echo 'Status: ' . (AWS_ACCESS_KEY_ID !== '[CONFIGURE_VARIAVEL_AMBIENTE]' ? 'OK' : 'ERRO') . PHP_EOL;
"
```

**Resultado esperado:**
```
AWS_ACCESS_KEY_ID: [CONFIGURE_AWS_ACCESS_KEY_ID]
Status: OK
```

---

**Última atualização:** 11/11/2025

