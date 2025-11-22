# 📋 Análise: Erro AWS SDK Não Instalado - PROD

**Data:** 16/11/2025  
**Problema:** Erro ao enviar email de notificação "Primeiro Contato - Apenas Telefone"  
**Erro:** `AWS SDK não instalado. Execute: composer require aws/aws-sdk-php`

---

## 🔍 PROBLEMA IDENTIFICADO

### **Sintoma:**
- Erro no console do navegador quando usuário insere DDD e telefone no modal
- Mensagem: `[EMAIL] Falha ao enviar notificação Primeiro Contato - Apenas Telefone`
- Erro: `{error: 'AWS SDK não instalado. Execute: composer require aws/aws-sdk-php'}`

### **Contexto:**
- Erro ocorre em produção (`prod.bssegurosimediato.com.br`)
- Função `sendAdminEmailNotification` é chamada quando usuário preenche telefone no modal
- Endpoint `send_email_notification_endpoint.php` tenta usar `send_admin_notification_ses.php`
- `send_admin_notification_ses.php` verifica se AWS SDK está disponível
- AWS SDK não está instalado no servidor de produção

---

## 🔍 ANÁLISE DETALHADA

### **1. Fluxo de Execução:**

#### **JavaScript (MODAL_WHATSAPP_DEFINITIVO.js):**

```javascript
// Linha ~732: Função sendAdminEmailNotification
async function sendAdminEmailNotification(modalPayload, responseData, errorInfo = null) {
    // ... preparação de dados ...
    
    // Determinar URL do endpoint (dev ou prod)
    const isDev = isDevelopmentEnvironment();
    const emailEndpoint = isDev 
        ? 'https://dev.bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint.php'
        : 'https://bpsegurosimediato.com.br/webhooks/send_email_notification_endpoint.php';
    
    // Fazer chamada para endpoint de email
    const response = await fetch(emailEndpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(emailPayload)
    });
    
    // ... tratamento de resposta ...
}
```

**Problema Identificado:**
- ⚠️ URL do endpoint em produção está usando `bpsegurosimediato.com.br` (antigo)
- ⚠️ Deveria usar `prod.bssegurosimediato.com.br` (novo)

#### **PHP (send_email_notification_endpoint.php):**

```php
// Linha ~50: Carrega send_admin_notification_ses.php
require_once __DIR__ . '/send_admin_notification_ses.php';

// ... processamento ...

// Chama função para enviar email
$resultado = enviarNotificacaoAdministradores($dados);
```

#### **PHP (send_admin_notification_ses.php):**

```php
// Linha ~27: Verifica se vendor/autoload.php existe
$vendorPath = __DIR__ . '/vendor/autoload.php';

if (file_exists($vendorPath)) {
    require $vendorPath;
    // Verifica se classe existe
    if (class_exists('Aws\Ses\SesClient')) {
        $awsSdkAvailable = true;
    }
} else {
    // Arquivo não existe
    error_log('⚠️ AWS SDK não encontrado! Arquivo não existe: ' . $vendorPath);
}

// Linha ~88: Se AWS SDK não disponível, retorna erro
if (!$awsSdkAvailable) {
    return [
        'success' => false,
        'error' => 'AWS SDK não instalado. Execute: composer require aws/aws-sdk-php',
        // ...
    ];
}
```

---

## 🔴 CAUSA RAIZ IDENTIFICADA

### **Problema 1: Diretório vendor não existe em PROD**

**Verificação:**
- ❌ Diretório `/var/www/html/prod/root/vendor/` não existe
- ❌ Arquivo `/var/www/html/prod/root/vendor/autoload.php` não existe
- ❌ AWS SDK não está instalado no servidor de produção

### **Problema 2: URL do Endpoint (Verificado - OK)**

**Verificação Realizada:**
- ✅ JavaScript usa `window.APP_BASE_URL` para determinar endpoint dinamicamente
- ✅ URL é construída corretamente: `window.APP_BASE_URL + '/send_email_notification_endpoint.php'`
- ✅ Em produção, `window.APP_BASE_URL` deve ser `https://prod.bssegurosimediato.com.br`

**Código Atual:**
```javascript
// Linha ~801: Usa window.APP_BASE_URL (correto)
const emailEndpoint = window.APP_BASE_URL + '/send_email_notification_endpoint.php';
```

**Status:** ✅ **OK - URL do endpoint está correta**

---

## 🔍 VERIFICAÇÕES REALIZADAS

### **1. Diretório vendor em PROD:**
- ❌ **Não existe:** `/var/www/html/prod/root/vendor/`
- ❌ **Resultado:** AWS SDK não pode ser carregado

### **2. Diretório vendor em DEV:**
- ✅ **Existe:** `/var/www/html/dev/root/vendor/` (verificado)
- ✅ **Status:** AWS SDK está instalado em DEV

### **3. Composer no servidor PROD:**
- ✅ **Instalado:** `/usr/bin/composer` (verificado)
- ✅ **Status:** Composer está disponível para instalação do AWS SDK

---

## 🔧 SOLUÇÃO PROPOSTA

### **Opção 1: Instalar AWS SDK via Composer (RECOMENDADO)**

**Processo:**
1. Verificar se Composer está instalado no servidor PROD
2. Se não estiver, instalar Composer
3. Executar `composer require aws/aws-sdk-php` no diretório `/var/www/html/prod/root/`
4. Verificar que `vendor/autoload.php` foi criado
5. Testar envio de email

**Comandos:**
```bash
# 1. Verificar se composer está instalado
which composer

# 2. Se não estiver, instalar composer
cd /tmp
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# 3. Instalar AWS SDK
cd /var/www/html/prod/root
composer require aws/aws-sdk-php --no-interaction

# 4. Verificar instalação
ls -la vendor/autoload.php
php -r "require 'vendor/autoload.php'; echo class_exists('Aws\Ses\SesClient') ? 'OK' : 'ERRO';"
```

**Vantagens:**
- ✅ Solução padrão e recomendada
- ✅ Gerenciamento de dependências via Composer
- ✅ Fácil atualização futura

**Desvantagens:**
- ⚠️ Requer Composer instalado no servidor
- ⚠️ Requer acesso SSH ao servidor

---

### **Opção 2: Copiar vendor de DEV para PROD**

**Processo:**
1. ✅ Vendor existe em DEV (verificado)
2. Copiar diretório vendor de DEV para PROD
3. Verificar permissões
4. Testar envio de email

**Comandos:**
```bash
# 1. Verificar vendor em DEV (já verificado - existe)
ls -la /var/www/html/dev/root/vendor/

# 2. Copiar para PROD
scp -r root@65.108.156.14:/var/www/html/dev/root/vendor /var/www/html/prod/root/

# 3. Ajustar permissões
chown -R www-data:www-data /var/www/html/prod/root/vendor
chmod -R 755 /var/www/html/prod/root/vendor

# 4. Verificar
ls -la /var/www/html/prod/root/vendor/autoload.php
php -r "require '/var/www/html/prod/root/vendor/autoload.php'; echo class_exists('Aws\Ses\SesClient') ? 'OK' : 'ERRO';"
```

**Vantagens:**
- ✅ Rápido (vendor já existe em DEV)
- ✅ Não requer instalação de Composer em PROD
- ✅ Usa mesma versão do AWS SDK que está funcionando em DEV

**Desvantagens:**
- ⚠️ Não é gerenciamento de dependências ideal
- ⚠️ Requer sincronização manual se DEV for atualizado

---

### **Opção 3: Instalar AWS SDK Localmente e Copiar**

**Processo:**
1. Instalar AWS SDK localmente no Windows (se possível)
2. Copiar diretório vendor para servidor PROD
3. Verificar permissões
4. Testar envio de email

**Vantagens:**
- ✅ Controle total sobre versão instalada
- ✅ Pode testar localmente antes

**Desvantagens:**
- ⚠️ Requer Composer no Windows
- ⚠️ Mais complexo

---

## 📋 VERIFICAÇÕES NECESSÁRIAS

### **1. Verificar URL do Endpoint no JavaScript**

**Arquivo:** `MODAL_WHATSAPP_DEFINITIVO.js`

**Verificar:**
- Qual URL está sendo usada em produção?
- Está usando `bpsegurosimediato.com.br` (antigo) ou `prod.bssegurosimediato.com.br` (novo)?

**Localização:** Linha ~707-710

### **2. Verificar se vendor existe em DEV**

**Ação:** Verificar se diretório vendor existe no servidor DEV

**Comando:**
```bash
ssh root@65.108.156.14 "ls -la /var/www/html/dev/root/vendor/ 2>&1 | head -n 5"
```

### **3. Verificar se Composer está instalado em PROD**

**Ação:** Verificar se Composer está disponível no servidor PROD

**Comando:**
```bash
ssh root@157.180.36.223 "which composer || echo 'Composer não encontrado'"
```

---

## 🎯 RECOMENDAÇÃO

### **Solução Recomendada: Opção 2 (Copiar vendor de DEV para PROD)**

**Justificativa:**
1. ✅ Mais rápido (vendor já existe em DEV)
2. ✅ Usa mesma versão que está funcionando em DEV
3. ✅ Não requer instalação de Composer (já está instalado, mas não precisa usar)
4. ✅ Menos risco (usa versão testada)

**Processo:**
1. ✅ Vendor existe em DEV (verificado)
2. ✅ Composer está instalado em PROD (verificado)
3. Copiar diretório vendor de DEV para PROD
4. Ajustar permissões
5. Verificar instalação
6. Testar envio de email

**Alternativa (se preferir):**
- Opção 1 (Instalar via Composer) também é válida e segue boas práticas
- Recomendada se quiser gerenciamento de dependências mais formal

---

## 📝 NOTAS

- **Prioridade:** 🟡 **MÉDIA** (funcionalidade não crítica, mas importante)
- **Impacto:** Emails de notificação não são enviados quando usuário preenche telefone
- **Complexidade:** Baixa (instalação de dependência)
- **Tempo Estimado:** 30-60 minutos

---

## 🔗 RELACIONADO

- **Documentação Anterior:** `RECUPERACAO_ENDPOINT_EMAIL.md` (instalação em DEV)
- **Arquivo Afetado:** `send_admin_notification_ses.php`
- **Endpoint:** `send_email_notification_endpoint.php`

---

**Status:** ✅ **ANÁLISE CONCLUÍDA**  
**Causa Raiz:** ✅ **IDENTIFICADA** (vendor/autoload.php não existe em PROD)  
**Solução:** ✅ **PROPOSTA** (Instalar AWS SDK via Composer)

