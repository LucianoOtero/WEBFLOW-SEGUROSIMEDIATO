# 📧 USO DOS TEMPLATES DE EMAIL

**Data:** 11/11/2025  
**Versão:** 1.0

---

## 🎯 RESUMO

Os templates de email são utilizados por **2 programas principais**:

1. **`send_email_notification_endpoint.php`** - Endpoint de notificação de administradores
2. **`ProfessionalLogger.php`** - Sistema de logging profissional (erros ERROR/FATAL)

---

## 📊 FLUXO DE USO

### **FLUXO 1: Notificação de Administradores (Modal WhatsApp)**

```
┌─────────────────────────────────────────────────────────────┐
│ JavaScript (FooterCodeSiteDefinitivoCompleto.js ou          │
│              MODAL_WHATSAPP_DEFINITIVO.js)                  │
│                                                              │
│ - Cliente preenche telefone no modal                        │
│ - Chama: sendEmailNotification()                            │
└───────────────────────┬─────────────────────────────────────┘
                         │
                         ▼ HTTP POST
┌─────────────────────────────────────────────────────────────┐
│ send_email_notification_endpoint.php                        │
│                                                              │
│ - Recebe JSON com dados do cliente                          │
│ - Valida dados (DDD, celular)                               │
│ - Prepara array $emailData                                  │
│ - Chama: enviarNotificacaoAdministradores($emailData)       │
└───────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ send_admin_notification_ses.php                             │
│                                                              │
│ - Valida AWS SDK e credenciais                               │
│ - Cria cliente SES                                           │
│ - Chama: renderEmailTemplate($dados)                        │
└───────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ email_template_loader.php                                    │
│                                                              │
│ - detectTemplateType($dados) → identifica tipo              │
│ - Carrega template apropriado:                               │
│   • template_modal.php (contato completo)                   │
│   • template_primeiro_contato.php (apenas telefone)         │
│   • template_logging.php (erros técnicos)                   │
│ - Retorna: ['subject', 'html', 'text']                      │
└───────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ send_admin_notification_ses.php (continuação)               │
│                                                              │
│ - Extrai: $subject, $htmlBody, $textBody                    │
│ - Envia email via AWS SES para cada administrador           │
│ - Retorna resultado                                          │
└─────────────────────────────────────────────────────────────┘
```

### **FLUXO 2: Notificação de Erros (ProfessionalLogger)**

```
┌─────────────────────────────────────────────────────────────┐
│ Código PHP (qualquer arquivo)                                │
│                                                              │
│ - Ocorre erro ERROR ou FATAL                                │
│ - Chama: $logger->error() ou $logger->fatal()               │
└───────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ ProfessionalLogger.php                                       │
│                                                              │
│ - Registra log no banco de dados                            │
│ - Se nível = ERROR ou FATAL:                                 │
│   → Prepara dados do erro                                    │
│   → Chama: enviarNotificacaoAdministradores($dados)         │
└───────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ send_admin_notification_ses.php                             │
│                                                              │
│ - (mesmo fluxo do FLUXO 1)                                   │
│ - Chama: renderEmailTemplate($dados)                         │
└───────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│ email_template_loader.php                                    │
│                                                              │
│ - detectTemplateType($dados) → identifica 'logging'          │
│ - Carrega: template_logging.php                             │
│ - Retorna: ['subject', 'html', 'text']                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔍 DETALHAMENTO POR PROGRAMA

### **1. send_email_notification_endpoint.php**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_email_notification_endpoint.php`

**Função:**
- Endpoint HTTP que recebe requisições POST do JavaScript
- Valida e processa dados do cliente do modal WhatsApp
- Envia notificações por email aos administradores

**Chamada dos templates:**
```php
// Linha 50: Carrega função de notificação
require_once __DIR__ . '/send_admin_notification_ses.php';

// Linha 103: Chama função que usa templates
$result = enviarNotificacaoAdministradores($emailData);
```

**Dados enviados:**
```php
$emailData = [
    'ddd' => '11',
    'celular' => '987654321',
    'nome' => 'João Silva',
    'cpf' => '123.456.789-00',
    'email' => 'joao@email.com',
    'cep' => '01234-567',
    'placa' => 'ABC1234',
    'gclid' => 'test-123',
    'momento' => 'initial', // ou 'update'
    'momento_descricao' => 'Primeiro Contato - Apenas Telefone',
    'momento_emoji' => '📞',
    'erro' => null // ou array com informações de erro
];
```

**Templates usados:**
- `template_primeiro_contato.php` - Se `momento === 'initial'` e CPF/CEP/Placa vazios
- `template_modal.php` - Para outros casos (contato completo ou atualização)

**Chamado por:**
- JavaScript: `FooterCodeSiteDefinitivoCompleto.js`
- JavaScript: `MODAL_WHATSAPP_DEFINITIVO.js`

---

### **2. ProfessionalLogger.php**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Função:**
- Sistema de logging profissional
- Registra logs no banco de dados
- Envia notificações por email quando ocorrem erros ERROR ou FATAL

**Chamada dos templates:**
```php
// Quando nível = ERROR ou FATAL
if ($level === 'ERROR' || $level === 'FATAL') {
    // Prepara dados do erro
    $emailData = [
        'ddd' => '00', // Valores padrão do sistema de logging
        'celular' => '000000000',
        'erro' => [
            'level' => $level,
            'category' => $category,
            'message' => $message,
            'file_name' => $fileName,
            'line_number' => $lineNumber,
            'stack_trace' => $stackTrace,
            // ... outros dados técnicos
        ]
    ];
    
    // Chama função que usa templates
    require_once __DIR__ . '/send_admin_notification_ses.php';
    enviarNotificacaoAdministradores($emailData);
}
```

**Dados enviados:**
```php
$emailData = [
    'ddd' => '00', // Valores padrão
    'celular' => '000000000',
    'erro' => [
        'level' => 'ERROR', // ou 'FATAL'
        'category' => 'EMAIL', // ou outra categoria
        'message' => 'Mensagem do erro',
        'file_name' => 'send_email_notification_endpoint.php',
        'line_number' => 61,
        'function_name' => 'enviarNotificacaoAdministradores',
        'class_name' => null,
        'stack_trace' => 'Stack trace completo...',
        'data' => [...], // Dados adicionais
        'timestamp' => '2025-11-11 22:00:00',
        'request_id' => 'req_1234567890',
        'environment' => 'development'
    ]
];
```

**Templates usados:**
- `template_logging.php` - Sempre (detectado por `erro.level` e `erro.category`)

**Chamado por:**
- Qualquer código PHP que use `$logger->error()` ou `$logger->fatal()`
- Exemplos:
  - `send_email_notification_endpoint.php` (quando há erro)
  - `log_endpoint.php` (quando há erro no processamento)
  - Qualquer outro arquivo PHP que use o sistema de logging

---

## 📋 TEMPLATES E SEUS USOS

### **template_modal.php**

**Usado por:**
- `send_email_notification_endpoint.php` (contatos completos ou atualizações)

**Quando é usado:**
- Cliente preencheu telefone + outros dados (CPF, CEP, Placa)
- Momento = 'update' (atualização de dados)
- Fallback quando `template_primeiro_contato.php` não existe

**Dados exibidos:**
- Telefone, Nome, CPF, Email, CEP, Placa, GCLID, Data/Hora
- Seção de erro (se houver)

---

### **template_primeiro_contato.php**

**Usado por:**
- `send_email_notification_endpoint.php` (primeiro contato)

**Quando é usado:**
- Cliente preencheu apenas telefone (primeiro contato)
- Momento = 'initial' ou 'initial_error'
- CPF, CEP e Placa estão vazios ou "Não informado"

**Dados exibidos:**
- Telefone, Nome, Email, GCLID, Data/Hora
- **NÃO exibe:** CPF, CEP, PLACA
- Seção de erro (se houver)

---

### **template_logging.php**

**Usado por:**
- `ProfessionalLogger.php` (erros ERROR/FATAL)

**Quando é usado:**
- Sistema detecta `erro.level` e `erro.category` nos dados
- E `erro.file_name` ou `erro.stack_trace` existe
- Valores padrão: DDD='00', celular='000000000'

**Dados exibidos:**
- Nível (ERROR/WARN/FATAL)
- Mensagem do erro
- Categoria
- Arquivo e linha
- Stack trace
- Dados adicionais
- Timestamp, Request ID, Ambiente

---

## 🔄 RESUMO DE USO

| Template | Usado Por | Quando | Dados Principais |
|----------|-----------|--------|------------------|
| `template_modal.php` | `send_email_notification_endpoint.php` | Contato completo ou atualização | Telefone, Nome, CPF, Email, CEP, Placa, GCLID |
| `template_primeiro_contato.php` | `send_email_notification_endpoint.php` | Primeiro contato (apenas telefone) | Telefone, Nome, Email, GCLID |
| `template_logging.php` | `ProfessionalLogger.php` | Erros ERROR/FATAL | Level, Mensagem, Arquivo, Linha, Stack Trace |

---

## 📝 ARQUIVOS RELACIONADOS

### **Arquivos Principais:**
1. `email_template_loader.php` - Carregador de templates
2. `send_admin_notification_ses.php` - Função que usa templates
3. `send_email_notification_endpoint.php` - Endpoint HTTP
4. `ProfessionalLogger.php` - Sistema de logging

### **Templates:**
1. `email_templates/template_modal.php`
2. `email_templates/template_primeiro_contato.php`
3. `email_templates/template_logging.php`

### **JavaScript (chamadores):**
1. `FooterCodeSiteDefinitivoCompleto.js`
2. `MODAL_WHATSAPP_DEFINITIVO.js`

---

## ✅ CONCLUSÃO

Os templates de email são utilizados por **2 programas principais**:

1. **`send_email_notification_endpoint.php`** - Para notificações de contatos do modal WhatsApp
   - Usa `template_modal.php` ou `template_primeiro_contato.php`

2. **`ProfessionalLogger.php`** - Para notificações de erros do sistema
   - Usa `template_logging.php`

Ambos passam por `send_admin_notification_ses.php` que chama `email_template_loader.php` para renderizar o template apropriado.

---

**Última atualização:** 11/11/2025

