# 🧪 PLANO DE TESTES - INTEGRAÇÃO DE EMAIL NO LOGGING

**Data:** 09/11/2025  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Plano completo de testes para validar a integração de envio de emails automático no sistema de logging profissional.

---

## 📋 TESTES FUNCIONAIS

### **Teste 1: Log ERROR Envia Email**
**Objetivo:** Verificar se email é enviado quando ERROR é logado

**Pré-condições:**
- Sistema de logging funcionando
- Endpoint de email acessível
- AWS SES configurado

**Passos:**
1. Executar: `$logger->error('Teste de erro', ['test' => true], 'TEST');`
2. Aguardar 3 segundos
3. Verificar no banco de dados:
   ```sql
   SELECT * FROM application_logs 
   WHERE level = 'ERROR' AND message LIKE '%Teste de erro%' 
   ORDER BY id DESC LIMIT 1;
   ```
4. Verificar email recebido:
   - Assunto contém "❌ Erro no Sistema"
   - Corpo contém mensagem do erro
   - Corpo contém dados adicionais
   - Corpo contém informações de arquivo/linha

**Critério de Sucesso:**
- ✅ Log salvo no banco com nível ERROR
- ✅ Email recebido pelos 3 administradores
- ✅ Email contém todas as informações do log

---

### **Teste 2: Log FATAL Envia Email**
**Objetivo:** Verificar se email é enviado quando FATAL é logado

**Passos:**
1. Criar exceção de teste:
   ```php
   $exception = new Exception('Teste de exceção fatal');
   ```
2. Executar: `$logger->fatal('Teste fatal', null, 'TEST', $exception);`
3. Aguardar 3 segundos
4. Verificar no banco de dados:
   ```sql
   SELECT * FROM application_logs 
   WHERE level = 'FATAL' AND message LIKE '%Teste fatal%' 
   ORDER BY id DESC LIMIT 1;
   ```
5. Verificar email recebido:
   - Assunto contém "🚨 Erro Fatal no Sistema"
   - Corpo contém stack trace completo
   - Corpo contém informações de exceção

**Critério de Sucesso:**
- ✅ Log salvo no banco com nível FATAL
- ✅ Email recebido pelos 3 administradores
- ✅ Email contém stack trace completo

---

### **Teste 3: Outros Níveis Não Enviam Email**
**Objetivo:** Verificar que apenas ERROR e FATAL enviam email

**Passos:**
1. Executar: `$logger->debug('Debug message');`
2. Executar: `$logger->info('Info message');`
3. Executar: `$logger->warn('Warning message');`
4. Aguardar 5 segundos
5. Verificar emails recebidos: Nenhum email deve ser recebido

**Critério de Sucesso:**
- ✅ Logs salvos no banco
- ✅ Nenhum email enviado

---

### **Teste 4: Falha de Email Não Quebra Logging**
**Objetivo:** Verificar que falha de email não impede logging

**Pré-condições:**
- Endpoint de email temporariamente inacessível (ou simular falha)

**Passos:**
1. Desabilitar endpoint temporariamente (ou simular erro)
2. Executar: `$logger->error('Teste com email falhando');`
3. Verificar no banco de dados: Log deve estar salvo
4. Verificar aplicação: Deve continuar funcionando normalmente
5. Verificar logs de erro: Não deve haver erro relacionado a email

**Critério de Sucesso:**
- ✅ Log salvo no banco normalmente
- ✅ Aplicação continua funcionando
- ✅ Nenhum erro relacionado a email

---

### **Teste 5: Email Assíncrono Não Bloqueia**
**Objetivo:** Verificar que email não bloqueia execução

**Passos:**
1. Medir tempo de execução:
   ```php
   $start = microtime(true);
   $logger->error('Teste de performance');
   $end = microtime(true);
   $time = ($end - $start) * 1000; // em milissegundos
   ```
2. Verificar: Tempo deve ser < 100ms (logging + preparação de email)
3. Verificar email: Deve ser recebido (mesmo que requisição ainda esteja processando)

**Critério de Sucesso:**
- ✅ Tempo de execução < 100ms
- ✅ Email recebido (mesmo que assíncrono)

---

## 📋 TESTES DE INTEGRAÇÃO

### **Teste 6: Integração com Endpoint Existente**
**Objetivo:** Verificar que payload é compatível com endpoint

**Passos:**
1. Executar: `$logger->error('Teste de integração');`
2. Verificar payload enviado (via logs do endpoint):
   - DDD e celular devem ser "00" e "000000000"
   - Momento deve ser "error"
   - Erro deve conter todas as informações

**Critério de Sucesso:**
- ✅ Payload válido e aceito pelo endpoint
- ✅ Email enviado com sucesso

---

### **Teste 7: Múltiplos Erros Simultâneos**
**Objetivo:** Verificar comportamento com múltiplos erros

**Passos:**
1. Executar 5 erros simultaneamente:
   ```php
   for ($i = 1; $i <= 5; $i++) {
       $logger->error("Erro $i", ['index' => $i], 'TEST');
   }
   ```
2. Aguardar 5 segundos
3. Verificar no banco: 5 logs salvos
4. Verificar emails: 5 emails recebidos (um para cada erro)

**Critério de Sucesso:**
- ✅ Todos os logs salvos
- ✅ Todos os emails enviados
- ✅ Sem bloqueio ou degradação de performance

---

## 📋 TESTES DE PERFORMANCE

### **Teste 8: Performance com Email**
**Objetivo:** Verificar que email não degrada performance significativamente

**Passos:**
1. Medir tempo de `error()` sem email (baseline)
2. Medir tempo de `error()` com email
3. Comparar: Diferença deve ser < 50ms

**Critério de Sucesso:**
- ✅ Diferença < 50ms
- ✅ Performance não degradada significativamente

---

## 📋 TESTES DE SEGURANÇA

### **Teste 9: Dados Sensíveis Sanitizados**
**Objetivo:** Verificar que dados sensíveis não são expostos no email

**Passos:**
1. Executar: `$logger->error('Teste', ['password' => 'senha123', 'token' => 'abc123']);`
2. Verificar email: Dados sensíveis devem estar mascarados

**Critério de Sucesso:**
- ✅ Senhas mascaradas
- ✅ Tokens mascarados
- ✅ API keys mascaradas

---

## 📋 TESTES DE CONFIABILIDADE

### **Teste 10: Rate Limiting**
**Objetivo:** Verificar comportamento com rate limiting

**Passos:**
1. Executar 150 erros rapidamente (acima do rate limit de 100/min)
2. Verificar: Alguns emails podem falhar, mas logging continua
3. Verificar no banco: Todos os logs salvos

**Critério de Sucesso:**
- ✅ Todos os logs salvos
- ✅ Alguns emails podem falhar (rate limit)
- ✅ Aplicação continua funcionando

---

## ✅ CRITÉRIOS DE ACEITAÇÃO

### **Funcionalidade:**
- ✅ ERROR envia email
- ✅ FATAL envia email
- ✅ Outros níveis não enviam email
- ✅ Email contém todas as informações do log

### **Performance:**
- ✅ Email não bloqueia logging
- ✅ Tempo de execução < 100ms
- ✅ Sem degradação significativa

### **Confiabilidade:**
- ✅ Falha de email não quebra logging
- ✅ Logging sempre tem prioridade
- ✅ Tratamento de erros silencioso

### **Segurança:**
- ✅ Dados sensíveis sanitizados
- ✅ Payload válido e seguro

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Versão:** 1.0.0

