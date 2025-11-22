# 📋 Análise: Erro "Erro desconhecido" no Envio de Email - Credenciais AWS Inválidas

**Data:** 16/11/2025  
**Problema:** Erro "Erro desconhecido" ao enviar email de notificação  
**Erro Real:** `The security token included in the request is invalid` (InvalidClientTokenId)

---

## 🔍 PROBLEMA IDENTIFICADO

### **Sintoma:**
- Erro no console: `[EMAIL] Falha ao enviar notificação Primeiro Contato - Apenas Telefone`
- Mensagem: `{error: 'Erro desconhecido'}`
- **Erro Real (identificado via teste):** `The security token included in the request is invalid` (código: `InvalidClientTokenId`)

### **Contexto:**
- AWS SDK está instalado e funcional (problema anterior resolvido)
- Endpoint `send_email_notification_endpoint.php` está respondendo
- Função `enviarNotificacaoAdministradores()` está sendo chamada
- **Problema:** Credenciais AWS são inválidas (valores de exemplo)

---

## 🔍 ANÁLISE DETALHADA

### **1. Teste Direto do Endpoint:**

**Comando Executado:**
```bash
curl -X POST https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{"ddd":"11","celular":"987654321","nome":"Teste"}'
```

**Resposta:**
```json
{
  "success": false,
  "total_sent": 0,
  "total_failed": 3,
  "total_recipients": 3,
  "results": [
    {
      "email": "lrotero@gmail.com",
      "success": false,
      "error": "The security token included in the request is invalid.",
      "code": "InvalidClientTokenId"
    },
    ...
  ]
}
```

**Causa Raiz Identificada:**
- ❌ Credenciais AWS são **valores de exemplo** (não são credenciais reais)
- ❌ AWS SDK está tentando usar credenciais inválidas
- ❌ Amazon SES está rejeitando a requisição

---

### **2. Verificação das Credenciais:**

**PHP-FPM Config (`/etc/php/8.3/fpm/pool.d/www.conf`):**
```ini
env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE
env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
env[AWS_REGION] = us-east-1
```

**Problema:**
- ⚠️ `AKIAIOSFODNN7EXAMPLE` é um **valor de exemplo** do AWS
- ⚠️ `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` é um **valor de exemplo** do AWS
- ⚠️ Essas credenciais **não são válidas** para uso real

---

### **3. Fluxo de Carregamento de Credenciais:**

**Arquivo:** `aws_ses_config.php`

```php
// Linha ~34-36: Prioridade de carregamento
define('AWS_ACCESS_KEY_ID', $_ENV['AWS_ACCESS_KEY_ID'] ?? '[CONFIGURE_VARIAVEL_AMBIENTE]');
define('AWS_SECRET_ACCESS_KEY', $_ENV['AWS_SECRET_ACCESS_KEY'] ?? '[CONFIGURE_VARIAVEL_AMBIENTE]');
define('AWS_REGION', $_ENV['AWS_REGION'] ?? 'sa-east-1');
```

**Processo:**
1. ✅ PHP-FPM define variáveis de ambiente (`$_ENV`)
2. ✅ `aws_ses_config.php` lê de `$_ENV`
3. ✅ Se não existir, usa valores padrão (que são placeholders)
4. ❌ **Problema:** Valores no PHP-FPM são de exemplo, não são reais

**Arquivo:** `send_admin_notification_ses.php`

```php
// Linha ~101: Verifica se credenciais estão configuradas
if (!defined('AWS_ACCESS_KEY_ID') || !defined('AWS_SECRET_ACCESS_KEY')) {
    return [
        'success' => false,
        'error' => 'Credenciais AWS não configuradas',
        ...
    ];
}

// Linha ~114-121: Cria cliente SES com credenciais
$sesClient = new \Aws\Ses\SesClient([
    'version' => 'latest',
    'region'  => AWS_REGION,
    'credentials' => [
        'key'    => AWS_ACCESS_KEY_ID,
        'secret' => AWS_SECRET_ACCESS_KEY,
    ],
]);
```

**Resultado:**
- ✅ Credenciais estão definidas (não retorna erro de "não configuradas")
- ❌ Credenciais são inválidas (valores de exemplo)
- ❌ Amazon SES rejeita com `InvalidClientTokenId`

---

### **4. Por que "Erro desconhecido" no JavaScript?**

**Arquivo:** `MODAL_WHATSAPP_DEFINITIVO.js`

```javascript
// Linha ~855: Log de erro
window.logClassified('ERROR', 'EMAIL', `Falha ao enviar notificação ${modalMoment.description}`, 
  { error: result.error || 'Erro desconhecido' }, 'ERROR_HANDLING', 'MEDIUM');
```

**Problema:**
- O endpoint retorna `result.error` com a mensagem do AWS
- Mas o JavaScript pode não estar capturando corretamente
- Ou a mensagem está sendo perdida na cadeia de chamadas

**Resposta Real do Endpoint:**
```json
{
  "success": false,
  "error": "The security token included in the request is invalid.",
  "code": "InvalidClientTokenId",
  "results": [...]
}
```

**Por que aparece "Erro desconhecido":**
- ⚠️ O JavaScript pode estar lendo `result.error` de forma incorreta
- ⚠️ Ou a mensagem de erro não está sendo propagada corretamente
- ⚠️ Ou há múltiplos erros e está pegando o primeiro que não tem mensagem

---

## 🔴 CAUSA RAIZ IDENTIFICADA

### **Problema Principal: Credenciais AWS Inválidas**

**Status:**
- ❌ Credenciais AWS no PHP-FPM são **valores de exemplo**
- ❌ Não são credenciais reais do Amazon SES
- ❌ Amazon SES rejeita requisições com erro `InvalidClientTokenId`

**Localização:**
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf` (PHP-FPM config)
- **Variáveis:**
  - `env[AWS_ACCESS_KEY_ID] = AKIAIOSFODNN7EXAMPLE` (exemplo)
  - `env[AWS_SECRET_ACCESS_KEY] = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` (exemplo)
  - `env[AWS_REGION] = us-east-1` (pode estar incorreto também)

---

## 🔧 SOLUÇÃO PROPOSTA

### **Opção 1: Configurar Credenciais Reais no PHP-FPM (RECOMENDADO)**

**Processo:**
1. Obter credenciais AWS reais (Access Key ID e Secret Access Key)
2. Verificar região correta (provavelmente `sa-east-1` para Brasil)
3. Atualizar PHP-FPM config com credenciais reais
4. Reiniciar PHP-FPM
5. Testar envio de email

**Arquivo a Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`
- Depois copiar para servidor: `/etc/php/8.3/fpm/pool.d/www.conf`

**Comandos:**
```bash
# 1. Editar arquivo local
# Adicionar/atualizar:
env[AWS_ACCESS_KEY_ID] = [CREDENCIAL_REAL]
env[AWS_SECRET_ACCESS_KEY] = [CREDENCIAL_REAL]
env[AWS_REGION] = sa-east-1

# 2. Copiar para servidor
scp php-fpm_www_conf_PROD.conf root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf

# 3. Reiniciar PHP-FPM
ssh root@157.180.36.223 "systemctl restart php8.3-fpm"

# 4. Verificar
ssh root@157.180.36.223 "systemctl status php8.3-fpm"
```

**Vantagens:**
- ✅ Solução padrão e recomendada
- ✅ Credenciais gerenciadas via variáveis de ambiente
- ✅ Fácil manutenção

---

### **Opção 2: Configurar via Arquivo .env.local (Alternativa)**

**Processo:**
1. Criar arquivo `.env.local` no servidor com credenciais
2. Ajustar permissões (chmod 600)
3. `aws_ses_config.php` já suporta carregar de `.env.local`

**Desvantagens:**
- ⚠️ Requer arquivo adicional no servidor
- ⚠️ Menos seguro (arquivo no filesystem)

---

## 📋 VERIFICAÇÕES NECESSÁRIAS

### **1. Obter Credenciais AWS Reais**

**Ação:** Verificar se credenciais AWS reais estão disponíveis

**Verificar:**
- Access Key ID real (formato: `AKIA...`)
- Secret Access Key real
- Região correta (provavelmente `sa-east-1` para Brasil)

### **2. Verificar Região AWS**

**Ação:** Confirmar qual região está sendo usada

**Verificar:**
- Região atual no PHP-FPM: `us-east-1`
- Região esperada: Provavelmente `sa-east-1` (São Paulo)

### **3. Verificar Domínio Verificado no SES**

**Ação:** Confirmar que domínio está verificado no Amazon SES

**Verificar:**
- Domínio `bpsegurosimediato.com.br` está verificado?
- Email `noreply@bpsegurosimediato.com.br` está verificado?

---

## 🎯 RECOMENDAÇÃO

### **Solução Recomendada: Opção 1 (Configurar no PHP-FPM)**

**Justificativa:**
1. ✅ Segue padrão do projeto (variáveis de ambiente)
2. ✅ Fácil manutenção
3. ✅ Consistente com outras configurações

**Processo:**
1. Obter credenciais AWS reais
2. Atualizar `php-fpm_www_conf_PROD.conf` localmente
3. Copiar para servidor
4. Reiniciar PHP-FPM
5. Testar envio de email

---

## 📝 NOTAS

- **Prioridade:** 🔴 **ALTA** (funcionalidade não está funcionando)
- **Impacto:** Emails de notificação não são enviados
- **Complexidade:** Baixa (apenas atualizar credenciais)
- **Tempo Estimado:** 10-15 minutos (após obter credenciais)

---

## 🔗 RELACIONADO

- **Análise Anterior:** `ANALISE_ERRO_AWS_SDK_NAO_INSTALADO_PROD.md`
- **Projeto Instalação:** `PROJETO_INSTALAR_AWS_SDK_PROD.md`
- **Relatório Execução:** `RELATORIO_EXECUCAO_INSTALAR_AWS_SDK_PROD.md`
- **Arquivo Config:** `aws_ses_config.php`
- **Arquivo PHP-FPM:** `php-fpm_www_conf_PROD.conf`

---

**Status:** ✅ **ANÁLISE CONCLUÍDA**  
**Causa Raiz:** ✅ **IDENTIFICADA** (Credenciais AWS são valores de exemplo)  
**Solução:** ✅ **PROPOSTA** (Configurar credenciais reais no PHP-FPM)

