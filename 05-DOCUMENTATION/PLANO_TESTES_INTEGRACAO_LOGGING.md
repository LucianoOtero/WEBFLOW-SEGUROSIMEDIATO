# 🧪 PLANO DE TESTES - INTEGRAÇÃO DE LOGGING

**Data:** 09/11/2025  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Plano completo de testes para validar a integração do novo sistema de logging profissional.

---

## 📋 TESTES JAVASCRIPT

### **Teste 1: Captura de Arquivo/Linha**
**Objetivo:** Verificar se arquivo e linha são capturados corretamente

**Passos:**
1. Executar: `window.logInfo('TEST', 'Teste de captura');`
2. Verificar no banco de dados:
   ```sql
   SELECT file_name, line_number, function_name, message 
   FROM application_logs 
   WHERE message LIKE '%Teste de captura%' 
   ORDER BY id DESC LIMIT 1;
   ```
3. **Esperado:**
   - `file_name` = "FooterCodeSiteDefinitivoCompleto.js"
   - `line_number` = número da linha onde `logInfo` foi chamado
   - `function_name` = função que chamou `logInfo`

**Critério de Sucesso:** ✅ Arquivo e linha corretos

---

### **Teste 2: Todos os Níveis de Log**
**Objetivo:** Verificar se todos os níveis são salvos corretamente

**Passos:**
1. Executar:
   ```javascript
   window.logDebug('TEST', 'Debug');
   window.logInfo('TEST', 'Info');
   window.logWarn('TEST', 'Warn');
   window.logError('TEST', 'Error');
   ```
2. Verificar no banco:
   ```sql
   SELECT level, message 
   FROM application_logs 
   WHERE category = 'TEST' 
   ORDER BY id DESC LIMIT 4;
   ```
3. **Esperado:**
   - 4 logs com níveis: DEBUG, INFO, WARN, ERROR

**Critério de Sucesso:** ✅ Todos os níveis salvos corretamente

---

### **Teste 3: Categorias**
**Objetivo:** Verificar se categorias são salvas corretamente

**Passos:**
1. Executar:
   ```javascript
   window.logInfo('UTILS', 'Mensagem UTILS');
   window.logInfo('MODAL', 'Mensagem MODAL');
   window.logInfo('RPA', 'Mensagem RPA');
   window.logInfo('GCLID', 'Mensagem GCLID');
   ```
2. Verificar no banco:
   ```sql
   SELECT category, message 
   FROM application_logs 
   WHERE message LIKE 'Mensagem%' 
   ORDER BY id DESC;
   ```
3. **Esperado:**
   - Categorias corretas: UTILS, MODAL, RPA, GCLID

**Critério de Sucesso:** ✅ Categorias corretas

---

### **Teste 4: Dados Adicionais (JSON)**
**Objetivo:** Verificar se dados adicionais são salvos em JSON

**Passos:**
1. Executar:
   ```javascript
   window.logInfo('TEST', 'Mensagem com dados', {
     key: 'value',
     number: 123,
     array: [1, 2, 3],
     object: { nested: 'value' }
   });
   ```
2. Verificar no banco:
   ```sql
   SELECT data, message 
   FROM application_logs 
   WHERE message = 'Mensagem com dados' 
   ORDER BY id DESC LIMIT 1;
   ```
3. **Esperado:**
   - Campo `data` contém JSON válido com os dados enviados

**Critério de Sucesso:** ✅ Dados salvos em JSON válido

---

### **Teste 5: Contexto Completo**
**Objetivo:** Verificar se contexto (URL, sessão, IP, etc.) é capturado

**Passos:**
1. Executar: `window.logInfo('TEST', 'Teste de contexto');`
2. Verificar no banco:
   ```sql
   SELECT url, session_id, ip_address, user_agent, environment 
   FROM application_logs 
   WHERE message = 'Teste de contexto' 
   ORDER BY id DESC LIMIT 1;
   ```
3. **Esperado:**
   - `url` = URL atual da página
   - `session_id` = ID da sessão (se disponível)
   - `ip_address` = IP do cliente
   - `user_agent` = User agent do navegador
   - `environment` = "development" ou "production"

**Critério de Sucesso:** ✅ Todos os campos de contexto preenchidos

---

### **Teste 6: Compatibilidade com DEBUG_CONFIG**
**Objetivo:** Verificar se `window.DEBUG_CONFIG.enabled = false` bloqueia logs

**Passos:**
1. Executar:
   ```javascript
   window.DEBUG_CONFIG = { enabled: false };
   window.logInfo('TEST', 'Este log não deve ser salvo');
   ```
2. Verificar no banco:
   ```sql
   SELECT COUNT(*) as count 
   FROM application_logs 
   WHERE message = 'Este log não deve ser salvo';
   ```
3. **Esperado:**
   - `count` = 0 (nenhum log salvo)

**Critério de Sucesso:** ✅ Logs bloqueados quando `enabled = false`

---

### **Teste 7: Performance (Não Bloqueia Execução)**
**Objetivo:** Verificar se logging não bloqueia execução

**Passos:**
1. Executar:
   ```javascript
   const start = performance.now();
   for (let i = 0; i < 100; i++) {
     window.logInfo('TEST', `Log ${i}`);
   }
   const end = performance.now();
   console.log(`Tempo: ${end - start}ms`);
   ```
2. **Esperado:**
   - Execução completa sem travamentos
   - Tempo razoável (< 5 segundos para 100 logs)

**Critério de Sucesso:** ✅ Não bloqueia execução

---

### **Teste 8: Fallback em Caso de Erro**
**Objetivo:** Verificar se falha de logging não quebra aplicação

**Passos:**
1. Desabilitar endpoint temporariamente (renomear `log_endpoint.php`)
2. Executar: `window.logInfo('TEST', 'Teste com endpoint offline');`
3. **Esperado:**
   - Aplicação continua funcionando normalmente
   - Erro logado no console (não quebra execução)

**Critério de Sucesso:** ✅ Aplicação não quebra se logging falhar

---

## 🐘 TESTES PHP

### **Teste 9: Integração ProfessionalLogger**
**Objetivo:** Verificar se PHP consegue usar ProfessionalLogger

**Passos:**
1. Criar arquivo de teste:
   ```php
   <?php
   require_once __DIR__ . '/ProfessionalLogger.php';
   $logger = new ProfessionalLogger();
   $logger->info('Teste PHP', ['test' => true], 'TEST');
   ```
2. Executar via browser ou CLI
3. Verificar no banco:
   ```sql
   SELECT file_name, line_number, level, category, message 
   FROM application_logs 
   WHERE message = 'Teste PHP' 
   ORDER BY id DESC LIMIT 1;
   ```
4. **Esperado:**
   - `file_name` = nome do arquivo PHP
   - `line_number` = linha onde `info()` foi chamado
   - `level` = "INFO"
   - `category` = "TEST"

**Critério de Sucesso:** ✅ Log salvo com informações corretas

---

### **Teste 10: Todos os Níveis PHP**
**Objetivo:** Verificar todos os níveis de log em PHP

**Passos:**
1. Executar:
   ```php
   $logger = new ProfessionalLogger();
   $logger->debug('Debug');
   $logger->info('Info');
   $logger->warn('Warn');
   $logger->error('Error');
   $logger->fatal('Fatal');
   ```
2. Verificar no banco:
   ```sql
   SELECT level, message 
   FROM application_logs 
   WHERE message IN ('Debug', 'Info', 'Warn', 'Error', 'Fatal') 
   ORDER BY id DESC LIMIT 5;
   ```
3. **Esperado:**
   - 5 logs com níveis: DEBUG, INFO, WARN, ERROR, FATAL

**Critério de Sucesso:** ✅ Todos os níveis funcionando

---

### **Teste 11: Stack Trace em Erros**
**Objetivo:** Verificar se stack trace é capturado em erros

**Passos:**
1. Executar:
   ```php
   try {
     throw new Exception('Erro de teste');
   } catch (Exception $e) {
     $logger->error('Erro capturado', ['context' => 'test'], 'TEST', $e);
   }
   ```
2. Verificar no banco:
   ```sql
   SELECT stack_trace, message 
   FROM application_logs 
   WHERE message = 'Erro capturado' 
   ORDER BY id DESC LIMIT 1;
   ```
3. **Esperado:**
   - Campo `stack_trace` contém stack trace completo

**Critério de Sucesso:** ✅ Stack trace salvo

---

## 🌐 TESTES DE INTEGRAÇÃO

### **Teste 12: Fluxo Completo JavaScript → PHP → Banco**
**Objetivo:** Verificar fluxo completo end-to-end

**Passos:**
1. Abrir página no browser
2. Executar ações que geram logs (abrir modal, preencher formulário, etc.)
3. Verificar no banco:
   ```sql
   SELECT 
     level, category, file_name, line_number, message, 
     url, session_id, ip_address, environment
   FROM application_logs 
   WHERE timestamp >= DATE_SUB(NOW(), INTERVAL 5 MINUTE)
   ORDER BY id DESC;
   ```
4. **Esperado:**
   - Logs de todas as ações aparecem no banco
   - Todos os campos preenchidos corretamente
   - Arquivo e linha corretos

**Critério de Sucesso:** ✅ Fluxo completo funcionando

---

### **Teste 13: Consulta via API**
**Objetivo:** Verificar se API de consulta funciona

**Passos:**
1. Inserir alguns logs via JavaScript
2. Consultar via API:
   ```bash
   curl 'https://dev.bssegurosimediato.com.br/log_query.php?limit=10'
   ```
3. **Esperado:**
   - Resposta JSON válida
   - Logs retornados corretamente
   - Paginação funcionando

**Critério de Sucesso:** ✅ API de consulta funcionando

---

### **Teste 14: Estatísticas**
**Objetivo:** Verificar API de estatísticas

**Passos:**
1. Inserir logs de diferentes níveis e categorias
2. Consultar estatísticas:
   ```bash
   curl 'https://dev.bssegurosimediato.com.br/log_statistics.php?start_date=2025-11-09'
   ```
3. **Esperado:**
   - Estatísticas por nível corretas
   - Estatísticas por categoria corretas
   - Top arquivos corretos

**Critério de Sucesso:** ✅ Estatísticas corretas

---

### **Teste 15: Exportação**
**Objetivo:** Verificar exportação de logs

**Passos:**
1. Inserir alguns logs
2. Exportar:
   ```bash
   curl 'https://dev.bssegurosimediato.com.br/log_export.php?format=csv&limit=10' > logs.csv
   ```
3. **Esperado:**
   - Arquivo CSV gerado
   - Dados corretos no CSV

**Critério de Sucesso:** ✅ Exportação funcionando

---

## ✅ CHECKLIST DE VALIDAÇÃO FINAL

- [ ] Todos os testes JavaScript passando
- [ ] Todos os testes PHP passando
- [ ] Todos os testes de integração passando
- [ ] 100% dos logs sendo salvos no banco
- [ ] 100% dos logs com arquivo e linha
- [ ] 0 erros de conexão
- [ ] API de consulta funcionando
- [ ] API de estatísticas funcionando
- [ ] Exportação funcionando
- [ ] Compatibilidade mantida
- [ ] Performance aceitável
- [ ] Fallback funcionando

---

## 📊 MÉTRICAS DE SUCESSO

- ✅ **Taxa de Sucesso:** 100% dos logs sendo salvos
- ✅ **Precisão:** 100% dos logs com arquivo/linha corretos
- ✅ **Performance:** < 100ms por log (assíncrono)
- ✅ **Disponibilidade:** 99.9% (fallback em caso de erro)
- ✅ **Compatibilidade:** 100% (código existente continua funcionando)

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025

