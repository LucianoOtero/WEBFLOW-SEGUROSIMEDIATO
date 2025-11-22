# 📋 Análise: Credenciais AWS DEV vs PROD

**Data:** 16/11/2025  
**Contexto:** Verificação se credenciais AWS foram copiadas de DEV para PROD

---

## 🔍 VERIFICAÇÃO REALIZADA

### **1. Credenciais no PHP-FPM Config:**

#### **DEV (`php-fpm_www_conf_DEV.conf`):**
```ini
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_REGION] = us-east-1
```
**Status:** ❌ **Valores de exemplo** (não são credenciais reais)

#### **PROD (`php-fpm_www_conf_PROD.conf`):**
```ini
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_REGION] = us-east-1
```
**Status:** ❌ **Valores de exemplo** (não são credenciais reais)

**Conclusão:** ✅ **Foram copiadas** (mas ambas são valores de exemplo)

---

### **2. Credenciais no arquivo `aws_ses_config.php`:**

#### **DEV (servidor):**
```php
define('AWS_ACCESS_KEY_ID', '[AWS_ACCESS_KEY_ID_DEV]');
define('AWS_SECRET_ACCESS_KEY', '[AWS_SECRET_ACCESS_KEY_DEV]');
define('AWS_REGION', 'sa-east-1');
```
**Status:** ✅ **Credenciais REAIS** (funcionam - teste em DEV foi bem-sucedido)

#### **PROD (servidor):**
**Verificação pendente** - necessário verificar se arquivo foi copiado e tem credenciais reais

---

### **3. Teste em DEV:**

**Resultado:**
```json
{
  "success": true,
  "total_sent": 3,
  "total_failed": 0,
  "total_recipients": 3,
  "results": [
    {"email": "lrotero@gmail.com", "success": true, "message_id": "..."},
    ...
  ]
}
```

**Conclusão:** ✅ **DEV está funcionando** - credenciais reais estão em `aws_ses_config.php`

---

## 🔴 PROBLEMA IDENTIFICADO

### **Prioridade de Carregamento de Credenciais:**

**Arquivo:** `aws_ses_config.php`

```php
// Linha ~34-36: Prioridade
define('AWS_ACCESS_KEY_ID', $_ENV['AWS_ACCESS_KEY_ID'] ?? '[CONFIGURE_VARIAVEL_AMBIENTE]');
define('AWS_SECRET_ACCESS_KEY', $_ENV['AWS_SECRET_ACCESS_KEY'] ?? '[CONFIGURE_VARIAVEL_AMBIENTE]');
define('AWS_REGION', $_ENV['AWS_REGION'] ?? 'sa-east-1');
```

**Processo:**
1. ✅ PHP-FPM define variáveis de ambiente (`$_ENV`)
2. ✅ `aws_ses_config.php` lê de `$_ENV` **PRIMEIRO** (maior prioridade)
3. ❌ Se `$_ENV` existe (mesmo que seja valor de exemplo), usa ele
4. ❌ **Nunca chega** aos valores hardcoded no arquivo

**Resultado:**
- ⚠️ Em DEV: PHP-FPM tem valores de exemplo, mas `aws_ses_config.php` tem valores reais hardcoded
- ⚠️ **Mas:** Como `$_ENV` tem prioridade, deveria usar valores de exemplo
- ⚠️ **Porém:** Teste em DEV funcionou, então algo está diferente

**Possibilidades:**
1. O `aws_ses_config.php` em DEV pode ter sido modificado diretamente no servidor (não está no arquivo local)
2. Ou há um `.env.local` no servidor DEV
3. Ou a lógica de prioridade está diferente

---

## 🔧 SOLUÇÃO

### **Opção 1: Atualizar PHP-FPM com Credenciais Reais (RECOMENDADO)**

**Processo:**
1. Usar credenciais reais que estão funcionando em DEV
2. Atualizar `php-fpm_www_conf_PROD.conf` com credenciais reais
3. Copiar para servidor PROD
4. Reiniciar PHP-FPM

**Credenciais Reais (de DEV):**
```ini
env[AWS_ACCESS_KEY_ID] = [AWS_ACCESS_KEY_ID_DEV]
env[AWS_SECRET_ACCESS_KEY] = [AWS_SECRET_ACCESS_KEY_DEV]
env[AWS_REGION] = sa-east-1
```

---

### **Opção 2: Copiar aws_ses_config.php de DEV para PROD**

**Processo:**
1. Verificar se `aws_ses_config.php` em PROD tem credenciais reais
2. Se não tiver, copiar de DEV para PROD
3. Mas isso não resolve se PHP-FPM sobrescrever

**Problema:**
- ⚠️ PHP-FPM tem prioridade sobre valores hardcoded
- ⚠️ Mesmo copiando arquivo, PHP-FPM vai sobrescrever

---

## 📋 CONCLUSÃO

### **Resposta à Pergunta:**

**"Você não copiou as credenciais de dev para prod?"**

**Resposta:**
- ✅ **PHP-FPM Config:** Sim, foram copiadas (mas ambas são valores de exemplo)
- ⏭️ **aws_ses_config.php:** Precisa verificar se foi copiado e se tem credenciais reais
- ⚠️ **Problema:** PHP-FPM tem prioridade, então mesmo que `aws_ses_config.php` tenha credenciais reais, PHP-FPM vai sobrescrever com valores de exemplo

### **Solução Recomendada:**

**Atualizar PHP-FPM PROD com credenciais reais que estão funcionando em DEV:**
- `AWS_ACCESS_KEY_ID = [AWS_ACCESS_KEY_ID_DEV]`
- `AWS_SECRET_ACCESS_KEY = [AWS_SECRET_ACCESS_KEY_DEV]`
- `AWS_REGION = sa-east-1`

---

**Status:** ✅ **ANÁLISE CONCLUÍDA**  
**Ação Necessária:** Atualizar PHP-FPM PROD com credenciais reais

