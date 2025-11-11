# 🔧 ESPECIFICAÇÃO TÉCNICA - SISTEMA DE TEMPLATES DE EMAIL

**Data:** 09/11/2025  
**Versão:** 1.0.0

---

## 📋 VISÃO GERAL

Sistema modular de templates de email que permite diferentes formatos de email baseados no contexto da notificação.

---

## 🏗️ ARQUITETURA

### **Estrutura de Arquivos:**
```
02-DEVELOPMENT/
├── email_templates/
│   ├── template_modal.php          # Template para modal WhatsApp
│   ├── template_logging.php       # Template para logging (ERROR/WARN/FATAL)
│   └── template_base.php          # Classe base (opcional, futuro)
├── email_template_loader.php       # Carregador de templates
└── send_admin_notification_ses.php # Função principal (modificada)
```

---

## 📧 TEMPLATE MODAL

### **Arquivo:** `email_templates/template_modal.php`

### **Função:**
```php
function renderEmailTemplateModal($dados) {
    // Retorna: ['subject' => string, 'html' => string, 'text' => string]
}
```

### **Parâmetros:**
- `$dados['ddd']` - DDD do telefone
- `$dados['celular']` - Número do celular
- `$dados['nome']` - Nome do cliente
- `$dados['cpf']` - CPF do cliente
- `$dados['email']` - Email do cliente
- `$dados['cep']` - CEP
- `$dados['placa']` - Placa do veículo
- `$dados['gclid']` - GCLID
- `$dados['momento']` - Momento (initial, update, error)
- `$dados['momento_descricao']` - Descrição do momento
- `$dados['momento_emoji']` - Emoji do momento
- `$dados['erro']` - Informações de erro (opcional)

### **Características:**
- Focado em dados do cliente
- Banner colorido baseado em momento/erro
- Campos: Telefone, Nome, CPF, Email, CEP, Placa, GCLID
- Seção de erro (se presente)

---

## 📧 TEMPLATE LOGGING

### **Arquivo:** `email_templates/template_logging.php`

### **Função:**
```php
function renderEmailTemplateLogging($dados) {
    // Retorna: ['subject' => string, 'html' => string, 'text' => string]
}
```

### **Parâmetros:**
- `$dados['erro']['level']` - Nível (ERROR, WARN, FATAL)
- `$dados['erro']['message']` - Mensagem do erro
- `$dados['erro']['category']` - Categoria (DATABASE, API, SYSTEM, etc.)
- `$dados['erro']['file_name']` - Nome do arquivo
- `$dados['erro']['line_number']` - Número da linha
- `$dados['erro']['function_name']` - Nome da função
- `$dados['erro']['stack_trace']` - Stack trace completo
- `$dados['erro']['data']` - Dados adicionais (JSON)
- `$dados['erro']['timestamp']` - Timestamp
- `$dados['erro']['request_id']` - Request ID
- `$dados['erro']['environment']` - Ambiente (dev/prod)

### **Características:**
- Focado em informações técnicas
- Cores por nível:
  - **ERROR:** Vermelho (#F44336)
  - **WARN:** Laranja (#FF9800)
  - **FATAL:** Vermelho escuro (#D32F2F)
- Seções:
  1. Banner com nível e mensagem
  2. Informações principais (categoria, timestamp, ambiente)
  3. Localização (arquivo, linha, função)
  4. Stack trace (formatado, se disponível)
  5. Dados adicionais (JSON formatado)
  6. Request ID e ambiente

### **Design:**
- Layout limpo e profissional
- Código formatado (syntax highlighting visual)
- Stack trace em bloco monospace
- JSON formatado e legível
- Responsivo (mobile-friendly)

---

## 🔄 CARREGADOR DE TEMPLATES

### **Arquivo:** `email_template_loader.php`

### **Função Principal:**
```php
function renderEmailTemplate($dados) {
    // Detecta tipo de template automaticamente
    // Carrega template apropriado
    // Retorna: ['subject' => string, 'html' => string, 'text' => string]
}
```

### **Lógica de Detecção:**
1. Se `$dados['erro']` existe E contém `level` → Template Logging
2. Se `$dados['ddd']` e `$dados['celular']` são válidos (não '00'/'000000000') → Template Modal
3. Fallback: Template Modal (compatibilidade)

### **Funções Auxiliares:**
- `detectTemplateType($dados)` - Detecta tipo de template
- `loadTemplate($type, $dados)` - Carrega template específico
- `validateTemplateData($type, $dados)` - Valida dados do template

---

## 🔄 MODIFICAÇÕES EM `send_admin_notification_ses.php`

### **Antes:**
```php
// HTML inline no código
$htmlBody = '<!DOCTYPE html>...';
```

### **Depois:**
```php
// Carregar sistema de templates
require_once __DIR__ . '/email_template_loader.php';

// Renderizar template
$template = renderEmailTemplate($emailData);
$subject = $template['subject'];
$htmlBody = $template['html'];
$textBody = $template['text'];
```

### **Compatibilidade:**
- ✅ Manter mesma assinatura de função
- ✅ Manter mesmo retorno
- ✅ Não quebrar código existente

---

## 🎨 ESPECIFICAÇÃO DO TEMPLATE DE LOGGING

### **Cores:**
- **ERROR:** #F44336 (Vermelho)
- **WARN:** #FF9800 (Laranja)
- **FATAL:** #D32F2F (Vermelho escuro)

### **Estrutura HTML:**
```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        /* Estilos profissionais */
    </style>
</head>
<body>
    <div class="container">
        <!-- Banner com nível -->
        <!-- Informações principais -->
        <!-- Localização (arquivo/linha) -->
        <!-- Stack trace (se disponível) -->
        <!-- Dados adicionais (JSON) -->
        <!-- Footer -->
    </div>
</body>
</html>
```

### **Seções:**
1. **Banner:** Cor baseada no nível, emoji, nível e mensagem
2. **Informações Principais:** Categoria, timestamp, ambiente, request ID
3. **Localização:** Arquivo, linha, função, classe
4. **Stack Trace:** Código formatado, monospace
5. **Dados Adicionais:** JSON formatado, legível
6. **Footer:** Informações do sistema

---

## ✅ VALIDAÇÃO E TESTES

### **Testes Necessários:**
1. Template Modal (garantir que não quebrou)
2. Template Logging - ERROR
3. Template Logging - WARN
4. Template Logging - FATAL
5. Detecção automática de template
6. Fallback para template modal

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025

