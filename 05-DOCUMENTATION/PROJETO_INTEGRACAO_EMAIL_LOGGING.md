# 📧 PROJETO: INTEGRAÇÃO DE EMAIL NO SISTEMA DE LOGGING

**Data:** 09/11/2025  
**Status:** 📝 **PROJETO PROPOSTO** - Aguardando Autorização  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Integrar o endpoint de envio de emails ao sistema de logging profissional, enviando notificações automáticas por email quando logs de nível **ERROR** ou **FATAL** forem acionados.

---

## 📊 ESCOPO DO PROJETO

### **Arquivos a Modificar:**

1. **`ProfessionalLogger.php`** (DEV)
   - Adicionar método `sendEmailNotification()` privado
   - Modificar métodos `error()` e `fatal()` para enviar email após log
   - Garantir que email não bloqueie o processo de logging

2. **Arquivos que usam ProfessionalLogger** (quando autorizado)
   - Verificar se há necessidade de ajustes
   - Manter compatibilidade total

---

## 🔄 FUNCIONALIDADE PROPOSTA

### **Fluxo Atual:**
```
ERROR/FATAL → ProfessionalLogger → MySQL (application_logs)
```

### **Fluxo Novo:**
```
ERROR/FATAL → ProfessionalLogger → MySQL (application_logs) → Email Notification (assíncrono)
```

### **Comportamento:**
- ✅ **ERROR:** Log no banco + Email para administradores
- ✅ **FATAL:** Log no banco + Email para administradores (prioridade alta)
- ✅ **DEBUG/INFO/WARN:** Apenas log no banco (sem email)
- ✅ **Assíncrono:** Email não bloqueia o processo de logging
- ✅ **Fallback:** Se email falhar, logging continua normalmente

---

## 📋 ESPECIFICAÇÃO TÉCNICA

### **1. Método `sendEmailNotification()` em ProfessionalLogger**

**Localização:** `ProfessionalLogger.php` (método privado)

**Parâmetros:**
- `$level` (string): 'ERROR' ou 'FATAL'
- `$message` (string): Mensagem do log
- `$data` (array|null): Dados adicionais
- `$category` (string|null): Categoria do log
- `$stackTrace` (string|null): Stack trace completo

**Funcionalidade:**
1. Preparar payload para `send_email_notification_endpoint.php`
2. Fazer requisição HTTP POST (assíncrona, não bloqueia)
3. Não quebrar aplicação se email falhar
4. Logar falha de email silenciosamente (se necessário)

**Payload do Email:**
```php
[
    'ddd' => '00', // Não aplicável para logs
    'celular' => '000000000', // Não aplicável para logs
    'nome' => 'Sistema de Logging',
    'cpf' => 'N/A',
    'email' => 'N/A',
    'cep' => 'N/A',
    'placa' => 'N/A',
    'gclid' => 'N/A',
    'momento' => 'error' ou 'fatal',
    'momento_descricao' => 'Erro no Sistema' ou 'Erro Fatal no Sistema',
    'momento_emoji' => '❌' ou '🚨',
    'erro' => [
        'message' => $message,
        'level' => $level,
        'category' => $category,
        'data' => $data,
        'stack_trace' => $stackTrace,
        'file_name' => $logData['file_name'],
        'line_number' => $logData['line_number'],
        'function_name' => $logData['function_name']
    ]
]
```

### **2. Modificação dos Métodos `error()` e `fatal()`**

**Método `error()`:**
```php
public function error($message, $data = null, $category = null, $exception = null) {
    $stackTrace = null;
    if ($exception instanceof Exception) {
        $stackTrace = $exception->getTraceAsString();
    }
    $logId = $this->log('ERROR', $message, $data, $category, $stackTrace);
    
    // NOVO: Enviar email após log bem-sucedido
    if ($logId !== false) {
        $this->sendEmailNotification('ERROR', $message, $data, $category, $stackTrace);
    }
    
    return $logId;
}
```

**Método `fatal()`:**
```php
public function fatal($message, $data = null, $category = null, $exception = null) {
    $stackTrace = null;
    if ($exception instanceof Exception) {
        $stackTrace = $exception->getTraceAsString();
    }
    $logId = $this->log('FATAL', $message, $data, $category, $stackTrace);
    
    // NOVO: Enviar email após log bem-sucedido
    if ($logId !== false) {
        $this->sendEmailNotification('FATAL', $message, $data, $category, $stackTrace);
    }
    
    return $logId;
}
```

### **3. Detalhes de Implementação**

**URL do Endpoint:**
- Usar `$_ENV['APP_BASE_URL']` se disponível
- Fallback: `https://dev.bssegurosimediato.com.br` (DEV) ou `https://bssegurosimediato.com.br` (PROD)

**Requisição HTTP:**
- Método: POST
- Content-Type: application/json
- Assíncrono: Usar `file_get_contents()` com contexto stream (não bloqueia)
- Timeout: 2 segundos (não travar aplicação)

**Tratamento de Erros:**
- Se email falhar, não quebrar aplicação
- Logar falha silenciosamente (opcional)
- Não retornar erro para o chamador

---

## ✅ CONFORMIDADE COM DIRETIVAS

| Diretiva | Status | Observação |
|----------|--------|------------|
| **Autorização prévia** | ⏳ Pendente | Aguardando autorização |
| **Modificações locais** | ✅ Sim | PHP modificado localmente primeiro |
| **Backups locais** | ✅ Sim | Backup antes de modificar |
| **Não modificar no servidor** | ✅ Sim | PHP local, depois copiar |
| **Variáveis de ambiente** | ✅ Sim | Usar `$_ENV['APP_BASE_URL']` |
| **Documentação** | ✅ Sim | Documentação completa |

---

## 📋 FASES DE IMPLEMENTAÇÃO

### **FASE 1: Preparação e Backups** (15 min)
- [ ] Criar backup de `ProfessionalLogger.php`
- [ ] Verificar estrutura atual do código
- [ ] Documentar métodos existentes

### **FASE 2: Implementar Método `sendEmailNotification()`** (1 hora)
- [ ] Criar método privado `sendEmailNotification()`
- [ ] Implementar preparação de payload
- [ ] Implementar requisição HTTP assíncrona
- [ ] Adicionar tratamento de erros
- [ ] Testar método isoladamente

### **FASE 3: Modificar Métodos `error()` e `fatal()`** (30 min)
- [ ] Adicionar chamada a `sendEmailNotification()` em `error()`
- [ ] Adicionar chamada a `sendEmailNotification()` em `fatal()`
- [ ] Garantir que email só é enviado após log bem-sucedido
- [ ] Testar métodos modificados

### **FASE 4: Testes Locais** (30 min)
- [ ] Testar log ERROR com email
- [ ] Testar log FATAL com email
- [ ] Testar falha de email (não deve quebrar logging)
- [ ] Verificar logs no banco de dados
- [ ] Verificar recebimento de emails

### **FASE 5: Deploy e Testes no Servidor** (30 min)
- [ ] Copiar `ProfessionalLogger.php` para servidor DEV
- [ ] Testar endpoint de email no servidor
- [ ] Verificar logs no banco
- [ ] Confirmar recebimento de emails

### **FASE 6: Validação Final** (15 min)
- [ ] Testar cenários reais
- [ ] Verificar performance (não deve degradar)
- [ ] Validar que emails não bloqueiam aplicação

**Total Estimado:** 3-4 horas

---

## 🧪 PLANO DE TESTES

### **Teste 1: Log ERROR com Email**
**Objetivo:** Verificar se email é enviado quando ERROR é logado

**Passos:**
1. Executar: `$logger->error('Teste de erro', ['test' => true], 'TEST');`
2. Verificar no banco: Log salvo com nível ERROR
3. Verificar email: Email recebido pelos administradores
4. Verificar conteúdo: Email contém mensagem, dados e stack trace

**Critério de Sucesso:** ✅ Log salvo + Email enviado

---

### **Teste 2: Log FATAL com Email**
**Objetivo:** Verificar se email é enviado quando FATAL é logado

**Passos:**
1. Executar: `$logger->fatal('Teste fatal', null, 'TEST', $exception);`
2. Verificar no banco: Log salvo com nível FATAL
3. Verificar email: Email recebido com prioridade alta
4. Verificar conteúdo: Email contém stack trace completo

**Critério de Sucesso:** ✅ Log salvo + Email enviado

---

### **Teste 3: Falha de Email Não Quebra Logging**
**Objetivo:** Verificar que falha de email não impede logging

**Passos:**
1. Simular falha de endpoint (desligar endpoint temporariamente)
2. Executar: `$logger->error('Teste com email falhando');`
3. Verificar no banco: Log salvo normalmente
4. Verificar aplicação: Continua funcionando normalmente

**Critério de Sucesso:** ✅ Log salvo mesmo com email falhando

---

### **Teste 4: Outros Níveis Não Enviam Email**
**Objetivo:** Verificar que apenas ERROR e FATAL enviam email

**Passos:**
1. Executar: `$logger->debug('Debug');`
2. Executar: `$logger->info('Info');`
3. Executar: `$logger->warn('Warn');`
4. Verificar emails: Nenhum email enviado

**Critério de Sucesso:** ✅ Apenas ERROR e FATAL enviam email

---

### **Teste 5: Performance**
**Objetivo:** Verificar que email não degrada performance

**Passos:**
1. Medir tempo de `error()` sem email
2. Medir tempo de `error()` com email
3. Comparar: Diferença deve ser < 100ms (assíncrono)

**Critério de Sucesso:** ✅ Performance não degradada significativamente

---

## ⚠️ RISCOS E MITIGAÇÕES

| Risco | Probabilidade | Impacto | Mitigação |
|-------|---------------|---------|-----------|
| Email bloqueia aplicação | Baixa | Alto | Requisição assíncrona com timeout curto |
| Endpoint de email falha | Média | Baixo | Tratamento de erro silencioso, logging continua |
| Performance degradada | Baixa | Médio | Requisição assíncrona, não bloqueia |
| Emails duplicados | Baixa | Baixo | Email só enviado após log bem-sucedido |
| Rate limiting do endpoint | Baixa | Baixo | Endpoint já tem rate limiting implementado |

---

## 📚 DOCUMENTAÇÃO A SER CRIADA

1. ✅ `PROJETO_INTEGRACAO_EMAIL_LOGGING.md` - Este arquivo
2. ⏳ `ESPECIFICACAO_TECNICA_EMAIL_LOGGING.md` - Especificação técnica detalhada
3. ⏳ `PLANO_TESTES_EMAIL_LOGGING.md` - Plano de testes completo
4. ⏳ `RESUMO_EXECUTIVO_EMAIL_LOGGING.md` - Resumo executivo

---

## 🎯 BENEFÍCIOS

- ✅ **Notificação Imediata:** Administradores são alertados instantaneamente de erros críticos
- ✅ **Visibilidade:** Erros não passam despercebidos
- ✅ **Rastreabilidade:** Email contém todas as informações do log (arquivo, linha, stack trace)
- ✅ **Não Invasivo:** Email assíncrono não afeta performance
- ✅ **Confiável:** Falha de email não quebra logging

---

## 📞 SOLICITAÇÃO DE AUTORIZAÇÃO

**Posso iniciar o projeto "Integração de Email no Sistema de Logging" agora?**

Este projeto irá:
- ✅ Integrar envio de emails automático para ERROR e FATAL
- ✅ Manter 100% de compatibilidade com código existente
- ✅ Não afetar performance (requisições assíncronas)
- ✅ Seguir todas as diretivas do projeto
- ✅ Criar backups antes de qualquer modificação

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Versão:** 1.0.0

