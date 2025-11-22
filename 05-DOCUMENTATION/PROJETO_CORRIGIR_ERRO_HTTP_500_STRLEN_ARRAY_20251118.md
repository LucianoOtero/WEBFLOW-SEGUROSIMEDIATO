# Projeto: Corrigir Erro HTTP 500 - strlen() recebendo array

**Versão:** 1.1.0  
**Data de Criação:** 2025-11-18  
**Última Atualização:** 2025-11-18  
**Status:** 📋 **PROJETO CRIADO E CORRIGIDO - Aguardando autorização para implementação**  
**Ambiente:** DEV (`dev.bssegurosimediato.com.br` - IP: 65.108.156.14)

---

## 📋 Resumo Executivo

Este projeto corrige o erro HTTP 500 causado por `TypeError: strlen(): Argument #1 ($string) must be of type string, array given` na linha 725 de `ProfessionalLogger.php`. O erro ocorre quando `insertLog()` é chamado diretamente com `'data' => [...]` (array) em vez de string JSON, e uma PDOException é lançada durante a inserção no banco.

---

## 🎯 Objetivos

1. **Corrigir erro fatal PHP** que causa HTTP 500 no endpoint de email
2. **Normalizar `$logData['data']`** no início de `insertLog()` para garantir que sempre seja string JSON
3. **Substituir chamadas diretas** a `insertLog()` por `log()` em `send_admin_notification_ses.php`
4. **Garantir robustez** do sistema de logging mesmo com chamadas diretas futuras
5. **Testar** endpoint de email após correção
6. **Verificar** ausência de erros nos logs do PHP-FPM

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### Objetivo do Usuário

O usuário solicitou a correção do erro HTTP 500 no endpoint de email que está impedindo o funcionamento correto do sistema de notificações por email.

### Requisitos Explícitos do Usuário

1. **Corrigir erro HTTP 500** no endpoint `send_email_notification_endpoint.php`
2. **Eliminar erro fatal PHP** `TypeError: strlen(): Argument #1 ($string) must be of type string, array given`
3. **Garantir que sistema de logging funcione corretamente** mesmo com chamadas diretas a `insertLog()`
4. **Manter compatibilidade** com código existente
5. **Não quebrar funcionalidades existentes** de envio de email e logging

### Requisitos Não-Funcionais

1. **Performance:** Normalização não deve impactar significativamente a performance (overhead mínimo esperado: ~0.1ms por chamada)
2. **Robustez:** Sistema deve funcionar mesmo se `insertLog()` for chamado diretamente com array
3. **Manutenibilidade:** Código deve seguir padrões do projeto e ser fácil de manter
4. **Conformidade:** Deve seguir diretivas do projeto (backup, hash SHA256, deploy apenas em DEV)

### Critérios de Aceitação do Usuário

1. ✅ **Endpoint de email não retorna mais HTTP 500**
   - Endpoint `send_email_notification_endpoint.php` deve retornar HTTP 200 ou HTTP 400/500 com mensagem de erro válida (não erro fatal PHP)

2. ✅ **Logs do PHP-FPM não mostram mais erros de `strlen()`**
   - Logs do PHP-FPM não devem conter erros `TypeError: strlen(): Argument #1 ($string) must be of type string, array given`

3. ✅ **Emails são enviados corretamente**
   - Sistema de envio de emails deve continuar funcionando normalmente
   - Notificações de erro devem ser enviadas quando apropriado

4. ✅ **Logs são inseridos no banco de dados corretamente**
   - Logs devem ser inseridos no banco de dados sem erros
   - Campo `data` deve estar sempre em formato JSON válido

5. ✅ **Sistema de logging é robusto**
   - Sistema deve funcionar mesmo se `insertLog()` for chamado diretamente com array
   - Não deve haver erros fatais mesmo em casos extremos

### Restrições e Limitações

1. **Ambiente:** Apenas ambiente DEV (`dev.bssegurosimediato.com.br`)
2. **Produção:** Não modificar produção até que procedimento seja definido
3. **Backward Compatibility:** Deve manter compatibilidade com código existente
4. **Performance:** Não deve degradar performance significativamente

### Expectativas de Resultado

O usuário espera que após a implementação:
- O endpoint de email funcione sem erros HTTP 500
- O sistema de logging seja robusto e confiável
- Não haja regressões em funcionalidades existentes
- O código seja mais manutenível e alinhado aos padrões do projeto

---

## 🔍 Análise do Problema

### Erro Identificado

```
TypeError: strlen(): Argument #1 ($string) must be of type string, array given
Location: /var/www/html/dev/root/ProfessionalLogger.php:725
```

### Causa Raiz

1. **4 chamadas diretas** a `insertLog()` em `send_admin_notification_ses.php` passam `'data' => [...]` como array
2. Quando ocorre PDOException, linha 725 tenta `strlen($logData['data'])` → **ERRO: array não é string**
3. Linha 807 tem o mesmo problema em outro catch block

### Arquivos Afetados

1. **`ProfessionalLogger.php`**
   - Linha 725: `'data_length' => strlen($logData['data'])` → ❌ ERRO se array
   - Linha 807: `'data_length' => strlen($logData['data'])` → ❌ MESMO PROBLEMA

2. **`send_admin_notification_ses.php`**
   - Linha 183: Chamada direta `insertLog()` com array
   - Linha 210: Chamada direta `insertLog()` com array
   - Linha 241: Chamada direta `insertLog()` com array
   - Linha 264: Chamada direta `insertLog()` com array

---

## 📐 Especificações Técnicas

### Solução Implementada

**Estratégia:** Normalização Global + Correção de Chamadas Diretas

1. **Normalização Global (Opção 2):**
   - Adicionar normalização de `$logData['data']` no início de `insertLog()`
   - Garante que `$logData['data']` sempre seja string JSON dentro de `insertLog()`
   - Previne problemas futuros em outras linhas

2. **Correção de Chamadas Diretas (Opção 3):**
   - Substituir todas as chamadas diretas a `insertLog()` por `log()`
   - Alinha código ao design padrão do sistema
   - Usa `prepareLogData()` automaticamente

### Impacto em Performance

**Avaliação:**
- **Overhead Adicionado:** ~0.1ms por chamada a `insertLog()` quando `$logData['data']` é array
- **Impacto Real:** Desprezível - Normalização ocorre apenas uma vez no início do método
- **Frequência:** Normalização só ocorre quando `$logData['data']` é array (4 chamadas diretas identificadas)
- **Otimização:** Normalização usa `json_encode()` nativo do PHP, altamente otimizado

**Conclusão:** Impacto em performance é mínimo e não requer otimizações adicionais.

---

## ⚠️ ANÁLISE DE RISCOS

### Riscos Técnicos

#### **Risco 1: Normalização pode falhar em casos extremos**
- **Severidade:** Média
- **Probabilidade:** Baixa
- **Descrição:** Se `json_encode()` falhar com array muito grande ou circular, normalização pode gerar erro
- **Mitigação:** 
  - `json_encode()` é robusto e trata casos extremos automaticamente
  - Try/catch já existe em `insertLog()` para capturar exceções
  - Arrays muito grandes são raros no contexto de logging
- **Plano de Contingência:** Se ocorrer, erro será capturado pelo try/catch existente e log será salvo em arquivo de fallback

#### **Risco 2: Normalização pode afetar performance se chamada muitas vezes**
- **Severidade:** Baixa
- **Probabilidade:** Baixa
- **Descrição:** Se `insertLog()` for chamado muitas vezes com arrays grandes, pode haver impacto em performance
- **Mitigação:**
  - Overhead é mínimo (~0.1ms por chamada)
  - Normalização só ocorre quando necessário (se já é string, não normaliza)
  - Chamadas diretas são raras (4 identificadas)
- **Plano de Contingência:** Monitorar performance após implementação; se necessário, otimizar

### Riscos Funcionais

#### **Risco 3: Se normalização falhar, logs podem não ser inseridos**
- **Severidade:** Média
- **Probabilidade:** Baixa
- **Descrição:** Se normalização gerar erro não capturado, log pode não ser inserido no banco
- **Mitigação:**
  - Try/catch existente em `insertLog()` captura exceções
  - Sistema de fallback para arquivo existe (`logToFileFallback()`)
  - Normalização usa funções nativas do PHP que são robustas
- **Plano de Contingência:** Log será salvo em arquivo de fallback se inserção no banco falhar

#### **Risco 4: Substituição de chamadas diretas pode introduzir bugs**
- **Severidade:** Baixa
- **Probabilidade:** Baixa
- **Descrição:** Se substituição de `insertLog()` por `log()` for feita incorretamente, pode quebrar funcionalidade
- **Mitigação:**
  - Substituições são diretas e bem documentadas (ANTES/DEPOIS)
  - Verificação de sintaxe PHP incluída (FASE 3)
  - Testes funcionais incluídos (FASE 5)
- **Plano de Contingência:** Rollback imediato se bugs forem detectados

### Riscos de Implementação

#### **Risco 5: Erro de sintaxe pode quebrar endpoint**
- **Severidade:** Alta
- **Probabilidade:** Baixa
- **Descrição:** Se houver erro de sintaxe no código modificado, endpoint pode retornar HTTP 500
- **Mitigação:**
  - Verificação de sintaxe PHP incluída (FASE 3)
  - Backup criado antes de modificar (FASE 0)
  - Plano de rollback detalhado
- **Plano de Contingência:** Rollback imediato usando backups

#### **Risco 6: Deploy pode falhar ou arquivo pode ser corrompido**
- **Severidade:** Média
- **Probabilidade:** Baixa
- **Descrição:** Se deploy falhar ou arquivo for corrompido durante cópia, endpoint pode quebrar
- **Mitigação:**
  - Verificação de hash SHA256 após cópia (FASE 4)
  - Backup no servidor antes de copiar
  - Comando `scp` é confiável
- **Plano de Contingência:** Restaurar backup do servidor se hash não coincidir

### Riscos de Negócio

#### **Risco 7: Endpoint de email pode ficar indisponível durante deploy**
- **Severidade:** Baixa
- **Probabilidade:** Baixa
- **Descrição:** Durante deploy, se houver erro, endpoint pode ficar indisponível temporariamente
- **Mitigação:**
  - Deploy é rápido (< 1 minuto)
  - Backup permite rollback imediato
  - Ambiente DEV não afeta produção
- **Plano de Contingência:** Rollback imediato se endpoint ficar indisponível

### Matriz de Riscos

| Risco | Severidade | Probabilidade | Prioridade | Status |
|-------|------------|---------------|------------|--------|
| R1: Normalização falhar | Média | Baixa | Baixa | Mitigado |
| R2: Impacto em performance | Baixa | Baixa | Baixa | Mitigado |
| R3: Logs não inseridos | Média | Baixa | Média | Mitigado |
| R4: Bugs em substituição | Baixa | Baixa | Baixa | Mitigado |
| R5: Erro de sintaxe | Alta | Baixa | Alta | Mitigado |
| R6: Deploy falhar | Média | Baixa | Média | Mitigado |
| R7: Endpoint indisponível | Baixa | Baixa | Baixa | Mitigado |

**Conclusão:** Todos os riscos identificados têm baixa probabilidade e estão adequadamente mitigados.

---

## 📋 Fases do Projeto

### FASE 0: Pré-requisitos e Preparação

**Objetivo:** Verificar ambiente e criar backups  
**Estimativa de Tempo:** ~10 minutos

**Tarefas:**
1. ✅ Verificar que estamos no ambiente DEV
2. ✅ Verificar que arquivos existem localmente
3. ✅ Criar backup de `ProfessionalLogger.php`
4. ✅ Criar backup de `send_admin_notification_ses.php`
5. ✅ Calcular hash SHA256 dos arquivos originais

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_admin_notification_ses.php`

**Backups:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/ProfessionalLogger.php.backup_CORRECAO_STRLEN_ARRAY_YYYYMMDD_HHMMSS`
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/send_admin_notification_ses.php.backup_CORRECAO_STRLEN_ARRAY_YYYYMMDD_HHMMSS`

---

### FASE 1: Normalizar `$logData['data']` em `insertLog()`

**Objetivo:** Adicionar normalização de `$logData['data']` no início de `insertLog()` para garantir que sempre seja string JSON  
**Estimativa de Tempo:** ~15 minutos

**Localização:** `ProfessionalLogger.php`, após linha 587 (início de `insertLog()`)

**Código a Adicionar:**
```php
// Normalizar $logData['data'] para string JSON se necessário
// Isso garante que mesmo chamadas diretas a insertLog() funcionem corretamente
if (isset($logData['data']) && $logData['data'] !== null) {
    if (is_array($logData['data']) || is_object($logData['data'])) {
        $logData['data'] = json_encode($logData['data'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    } elseif (!is_string($logData['data'])) {
        // Outros tipos (int, float, bool): converter para JSON
        $logData['data'] = json_encode($logData['data'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }
    // Se já é string, manter como está (pode ser JSON válido ou não)
}
```

**Justificativa:**
- Garante que `$logData['data']` sempre seja string dentro de `insertLog()`
- Previne erros em linhas 725 e 807
- Compatível com chamadas via `log()` (que já passam JSON) e chamadas diretas (que passam array)

---

### FASE 2: Substituir Chamadas Diretas em `send_admin_notification_ses.php`

**Objetivo:** Substituir todas as chamadas diretas a `insertLog()` por `log()` para alinhar ao design padrão  
**Estimativa de Tempo:** ~20 minutos

**Localizações:**

#### 2.1. Linha 183 - Log de Sucesso de Email

**ANTES:**
```php
$logger->insertLog([
    'level' => 'INFO',
    'category' => 'EMAIL',
    'message' => "SES: Email enviado com sucesso para {$adminEmail}",
    'data' => [
        'email' => $adminEmail,
        'message_id' => $result['MessageId']
    ]
]);
```

**DEPOIS:**
```php
$logger->log('INFO', "SES: Email enviado com sucesso para {$adminEmail}", [
    'email' => $adminEmail,
    'message_id' => $result['MessageId']
], 'EMAIL');
```

#### 2.2. Linha 210 - Log de Erro AWS ao Enviar Email

**ANTES:**
```php
$logger->insertLog([
    'level' => 'ERROR',
    'category' => 'EMAIL',
    'message' => "SES: Erro ao enviar para {$adminEmail}",
    'data' => [
        'email' => $adminEmail,
        'error_code' => $e->getAwsErrorCode(),
        'error_message' => $e->getAwsErrorMessage()
    ]
]);
```

**DEPOIS:**
```php
$logger->log('ERROR', "SES: Erro ao enviar para {$adminEmail}", [
    'email' => $adminEmail,
    'error_code' => $e->getAwsErrorCode(),
    'error_message' => $e->getAwsErrorMessage()
], 'EMAIL');
```

#### 2.3. Linha 241 - Log de Erro na Configuração/Cliente AWS

**ANTES:**
```php
$logger->insertLog([
    'level' => 'ERROR',
    'category' => 'EMAIL',
    'message' => "SES: Erro na configuração/cliente",
    'data' => [
        'error_code' => $e->getAwsErrorCode(),
        'error_message' => $e->getAwsErrorMessage()
    ]
]);
```

**DEPOIS:**
```php
$logger->log('ERROR', "SES: Erro na configuração/cliente", [
    'error_code' => $e->getAwsErrorCode(),
    'error_message' => $e->getAwsErrorMessage()
], 'EMAIL');
```

#### 2.4. Linha 264 - Log de Erro Geral

**ANTES:**
```php
$logger->insertLog([
    'level' => 'ERROR',
    'category' => 'EMAIL',
    'message' => "SES: Erro geral",
    'data' => [
        'error_message' => $e->getMessage()
    ]
]);
```

**DEPOIS:**
```php
$logger->log('ERROR', "SES: Erro geral", [
    'error_message' => $e->getMessage()
], 'EMAIL');
```

**Justificativa:**
- Alinha código ao design padrão do sistema
- Usa `log()` que automaticamente chama `prepareLogData()`
- Mais consistente e manutenível

---

### FASE 3: Verificação de Sintaxe PHP

**Objetivo:** Verificar que os arquivos modificados não têm erros de sintaxe  
**Estimativa de Tempo:** ~5 minutos

**Tarefas:**
1. Executar `php -l ProfessionalLogger.php` localmente
2. Executar `php -l send_admin_notification_ses.php` localmente
3. Verificar que não há erros de sintaxe

**Comandos:**
```bash
php -l "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php"
php -l "WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_admin_notification_ses.php"
```

---

### FASE 4: Deploy para Servidor DEV

**Objetivo:** Copiar arquivos corrigidos para servidor DEV  
**Estimativa de Tempo:** ~10 minutos

**Tarefas:**
1. Criar backup no servidor antes de copiar
2. Copiar `ProfessionalLogger.php` para servidor DEV
3. Copiar `send_admin_notification_ses.php` para servidor DEV
4. Verificar hash SHA256 após cópia (case-insensitive)
5. Confirmar que arquivos foram copiados corretamente

**Comandos:**
```bash
# Backup no servidor
ssh root@65.108.156.14 "cp /var/www/html/dev/root/ProfessionalLogger.php /var/www/html/dev/root/ProfessionalLogger.php.backup_CORRECAO_STRLEN_ARRAY_$(date +%Y%m%d_%H%M%S)"
ssh root@65.108.156.14 "cp /var/www/html/dev/root/send_admin_notification_ses.php /var/www/html/dev/root/send_admin_notification_ses.php.backup_CORRECAO_STRLEN_ARRAY_$(date +%Y%m%d_%H%M%S)"

# Copiar arquivos
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" root@65.108.156.14:/var/www/html/dev/root/
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_admin_notification_ses.php" root@65.108.156.14:/var/www/html/dev/root/

# Verificar hash SHA256 (case-insensitive)
# Local
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
# Servidor
$hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/ProfessionalLogger.php | cut -d' ' -f1").ToUpper()
# Comparar
if ($hashLocal -eq $hashServidor) { Write-Host "✅ Hash coincide" } else { Write-Host "❌ Hash não coincide" }
```

**Caminho no Servidor:**
- `/var/www/html/dev/root/ProfessionalLogger.php`
- `/var/www/html/dev/root/send_admin_notification_ses.php`

---

### FASE 5: Testes Funcionais

**Objetivo:** Verificar que correção resolve o erro HTTP 500  
**Estimativa de Tempo:** ~15 minutos

**Tarefas:**
1. Testar endpoint de email via HTTP POST
2. Verificar que não há HTTP 500
3. Verificar logs do PHP-FPM para confirmar ausência de erros
4. Verificar que emails são enviados corretamente
5. Verificar que logs são inseridos no banco de dados

**Teste do Endpoint:**
```bash
# Simular requisição POST para send_email_notification_endpoint.php
curl -X POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{
    "momento": "teste",
    "ddd": "11",
    "celular": "987654321",
    "erro": null
  }'
```

**Verificação de Logs PHP-FPM:**
```bash
ssh root@65.108.156.14 "tail -n 50 /var/log/php8.3-fpm.log | grep -i 'strlen\|TypeError\|ProfessionalLogger'"
```

**Verificação de Logs no Banco:**
- Verificar que logs de EMAIL são inseridos corretamente
- Verificar que campo `data` está em formato JSON válido

---

### FASE 6: Verificação Final

**Objetivo:** Confirmar que todas as correções foram aplicadas e funcionam corretamente  
**Estimativa de Tempo:** ~10 minutos

**Estimativa Total do Projeto:** ~85 minutos (~1h25min)

**Checklist:**
- [ ] Backup criado localmente
- [ ] Backup criado no servidor
- [ ] Normalização adicionada em `insertLog()`
- [ ] 4 chamadas diretas substituídas em `send_admin_notification_ses.php`
- [ ] Sintaxe PHP verificada sem erros
- [ ] Arquivos copiados para servidor DEV
- [ ] Hash SHA256 verificado após cópia
- [ ] Endpoint de email testado sem HTTP 500
- [ ] Logs PHP-FPM verificados sem erros de `strlen()`
- [ ] Emails sendo enviados corretamente
- [ ] Logs sendo inseridos no banco corretamente

---

## 🔄 Plano de Rollback

Se houver problemas após a implementação:

1. **Restaurar arquivos do servidor:**
   ```bash
   ssh root@65.108.156.14 "cp /var/www/html/dev/root/ProfessionalLogger.php.backup_CORRECAO_STRLEN_ARRAY_* /var/www/html/dev/root/ProfessionalLogger.php"
   ssh root@65.108.156.14 "cp /var/www/html/dev/root/send_admin_notification_ses.php.backup_CORRECAO_STRLEN_ARRAY_* /var/www/html/dev/root/send_admin_notification_ses.php"
   ```

2. **Restaurar arquivos localmente:**
   - Copiar backups de `backups/` para `02-DEVELOPMENT/`

3. **Verificar funcionamento após rollback:**
   - Testar endpoint de email
   - Verificar logs do PHP-FPM

---

## 📊 Verificação de Hash SHA256

### Antes da Modificação

**Arquivos Originais:**
- `ProfessionalLogger.php`: [SERÁ CALCULADO NA FASE 0]
- `send_admin_notification_ses.php`: [SERÁ CALCULADO NA FASE 0]

### Após Modificação Local

**Arquivos Modificados:**
- `ProfessionalLogger.php`: [SERÁ CALCULADO APÓS FASE 1]
- `send_admin_notification_ses.php`: [SERÁ CALCULADO APÓS FASE 2]

### Após Deploy no Servidor

**Verificação Obrigatória:**
- Hash local vs. hash servidor devem coincidir (case-insensitive)
- Se não coincidirem, tentar copiar novamente

---

## 🚨 Avisos Importantes

1. **⚠️ CACHE CLOUDFLARE:** Após atualizar arquivos `.php` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.

2. **Ambiente:** Este projeto é apenas para **DEV**. Não modificar produção.

3. **Backup:** Sempre criar backup antes de modificar arquivos.

4. **Hash:** Sempre verificar hash SHA256 após cópia para garantir integridade.

---

## 📝 Documentação de Referência

- **Análise do Erro:** `ANALISE_ERRO_STRLEN_ARRAY_20251118.md`
- **Erro Identificado:** `ERRO_IDENTIFICADO_HTTP_500_20251118.md`
- **Implementação Anterior:** `RELATORIO_IMPLEMENTACAO_CATCH_WORKERS_OUTPUT_20251118.md`

---

## ✅ Critérios de Sucesso

1. ✅ Endpoint de email não retorna mais HTTP 500
2. ✅ Logs do PHP-FPM não mostram mais erros de `strlen()` com array
3. ✅ Emails são enviados corretamente
4. ✅ Logs são inseridos no banco de dados corretamente
5. ✅ Campo `data` está sempre em formato JSON válido

---

## 📝 HISTÓRICO DE VERSÕES

### **Versão 1.1.0 (2025-11-18)**
- ✅ Adicionada seção "## 📋 ESPECIFICAÇÕES DO USUÁRIO" (crítica)
- ✅ Adicionada seção "## ⚠️ ANÁLISE DE RISCOS" detalhada
- ✅ Adicionada avaliação de "Impacto em Performance"
- ✅ Adicionadas estimativas de tempo em cada fase
- ✅ Adicionada seção "## 📝 HISTÓRICO DE VERSÕES"
- ✅ Correções baseadas em auditoria do projeto

### **Versão 1.0.0 (2025-11-18)**
- ✅ Versão inicial do projeto
- ✅ Definição de objetivos e fases
- ✅ Plano de implementação detalhado
- ✅ Plano de rollback
- ✅ Critérios de sucesso

---

**Status:** 📋 **PROJETO CRIADO E CORRIGIDO**  
**Próximo Passo:** Aguardar autorização explícita do usuário para iniciar implementação

