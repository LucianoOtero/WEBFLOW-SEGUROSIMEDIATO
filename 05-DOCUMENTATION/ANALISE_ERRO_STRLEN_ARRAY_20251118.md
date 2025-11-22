# Análise: TypeError strlen() recebendo array em ProfessionalLogger.php:725

**Data:** 2025-11-18  
**Erro Identificado:** `TypeError: strlen(): Argument #1 ($string) must be of type string, array given`  
**Localização:** `/var/www/html/dev/root/ProfessionalLogger.php:725`  
**Status:** 🔍 **INVESTIGAÇÃO CONCLUÍDA - Aguardando autorização para correção**

---

## 📋 Resumo Executivo

Após habilitar `catch_workers_output` no PHP-FPM, foi identificado um erro fatal PHP que causa HTTP 500 no endpoint de email. O erro ocorre quando `strlen()` recebe um array em vez de uma string na linha 725 de `ProfessionalLogger.php`, durante o tratamento de exceções PDO.

---

## 🔍 Causa Raiz Identificada

### Problema Principal

**Linha 725 de `ProfessionalLogger.php`:**
```php
'data_length' => $logData['data'] !== null ? strlen($logData['data']) : 0,
```

**Causa:** `$logData['data']` pode ser um **array** quando `insertLog()` é chamado diretamente sem passar por `prepareLogData()`, que converte arrays para JSON string.

### Chamadas Diretas Identificadas

Foram identificadas **4 chamadas diretas** a `insertLog()` em `send_admin_notification_ses.php` que passam `'data' => [...]` como array:

1. **Linha 183:** Log de sucesso de envio de email
2. **Linha 210:** Log de erro AWS ao enviar email
3. **Linha 241:** Log de erro na configuração/cliente AWS
4. **Linha 264:** Log de erro geral

**Exemplo (linha 183-191):**
```php
$logger->insertLog([
    'level' => 'INFO',
    'category' => 'EMAIL',
    'message' => "SES: Email enviado com sucesso para {$adminEmail}",
    'data' => [  // ❌ ARRAY, não string JSON
        'email' => $adminEmail,
        'message_id' => $result['MessageId']
    ]
]);
```

### Fluxo Normal vs. Fluxo Direto

#### ✅ Fluxo Normal (via `log()`):
1. `log()` → `prepareLogData()` → converte `$data` (array) para `$dataJson` (string JSON)
2. `insertLog()` recebe `$logData['data']` como **string JSON**
3. Linha 725 funciona corretamente: `strlen($logData['data'])` recebe string

#### ❌ Fluxo Direto (via `insertLog()`):
1. `insertLog()` chamado diretamente com `'data' => [...]` (array)
2. Linha 669: PDO pode aceitar array (conversão automática) ou falhar
3. Se PDOException ocorrer, linha 725 tenta `strlen($logData['data'])` → **ERRO: array não é string**

---

## 📊 Análise Técnica Detalhada

### Código Problemático

**`ProfessionalLogger.php` linha 725 (dentro do `catch (PDOException $e)`):**
```php
$errorDetails = [
    // ... outros campos ...
    'has_data' => $logData['data'] !== null,
    'data_length' => $logData['data'] !== null ? strlen($logData['data']) : 0,  // ❌ ERRO AQUI
    // ...
];
```

### Verificação de Tipo Necessária

A linha 725 assume que `$logData['data']` é sempre string, mas pode ser:
- ✅ **String JSON** (quando vem de `prepareLogData()`)
- ❌ **Array** (quando `insertLog()` é chamado diretamente)
- ✅ **null** (quando não há dados)

### Outras Ocorrências

Verificação de outras linhas que usam `$logData['data']`:

- **Linha 669:** `':data' => $logData['data']` → PDO aceita array (conversão automática)
- **Linha 724:** `'has_data' => $logData['data'] !== null` → ✅ OK (verifica null)
- **Linha 725:** `'data_length' => strlen($logData['data'])` → ❌ **ERRO se array**
- **Linha 727:** `'stack_trace_length' => strlen($logData['stack_trace'])` → ✅ OK (sempre string ou null)
- **Linha 807:** `'data_length' => strlen($logData['data'])` → ❌ **MESMO PROBLEMA** (outro catch block)

---

## 🎯 Solução Proposta

### Opção 1: Converter Array para JSON na Linha 725 (Correção Local)

**Vantagens:**
- Correção mínima e cirúrgica
- Não afeta outras partes do código
- Mantém compatibilidade com chamadas diretas

**Implementação:**
```php
'data_length' => $logData['data'] !== null 
    ? (is_array($logData['data']) || is_object($logData['data'])
        ? strlen(json_encode($logData['data'], JSON_UNESCAPED_UNICODE))
        : strlen($logData['data']))
    : 0,
```

### Opção 2: Normalizar `$logData['data']` no Início de `insertLog()` (Correção Global)

**Vantagens:**
- Garante que `$logData['data']` sempre seja string JSON dentro de `insertLog()`
- Previne problemas futuros em outras linhas
- Centraliza a lógica de conversão

**Implementação:**
Adicionar no início de `insertLog()` (após linha 587):
```php
// Normalizar $logData['data'] para string JSON se necessário
if (isset($logData['data']) && $logData['data'] !== null) {
    if (is_array($logData['data']) || is_object($logData['data'])) {
        $logData['data'] = json_encode($logData['data'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    } elseif (!is_string($logData['data'])) {
        $logData['data'] = json_encode($logData['data'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }
}
```

### Opção 3: Corrigir Chamadas Diretas em `send_admin_notification_ses.php` (Prevenção)

**Vantagens:**
- Alinha todas as chamadas ao fluxo padrão
- Usa `log()` em vez de `insertLog()` diretamente
- Mais consistente com o design do sistema

**Implementação:**
Substituir chamadas diretas:
```php
// ANTES (linha 183):
$logger->insertLog([
    'level' => 'INFO',
    'category' => 'EMAIL',
    'message' => "SES: Email enviado com sucesso para {$adminEmail}",
    'data' => [...]
]);

// DEPOIS:
$logger->log('INFO', "SES: Email enviado com sucesso para {$adminEmail}", [
    'email' => $adminEmail,
    'message_id' => $result['MessageId']
], 'EMAIL');
```

---

## 📝 Recomendação

**Recomendação:** Implementar **Opção 2 (Normalização Global)** + **Opção 3 (Corrigir Chamadas Diretas)**.

**Justificativa:**
1. **Opção 2** garante robustez: mesmo se outras chamadas diretas forem adicionadas no futuro, `insertLog()` sempre receberá dados normalizados.
2. **Opção 3** alinha o código ao design padrão do sistema, usando `log()` em vez de `insertLog()` diretamente.
3. **Opção 1** pode ser aplicada como medida temporária se necessário, mas não resolve a causa raiz.

---

## 🔗 Arquivos Envolvidos

1. **`ProfessionalLogger.php`** (linha 725, linha 807)
   - Adicionar normalização de `$logData['data']` no início de `insertLog()`

2. **`send_admin_notification_ses.php`** (linhas 183, 210, 241, 264)
   - Substituir chamadas diretas a `insertLog()` por `log()`

---

## ✅ Próximos Passos

1. **Aguardar autorização explícita** do usuário para implementar correção
2. **Criar backup** de `ProfessionalLogger.php` e `send_admin_notification_ses.php`
3. **Implementar Opção 2** (normalização global)
4. **Implementar Opção 3** (corrigir chamadas diretas)
5. **Testar** endpoint de email após correção
6. **Verificar logs** do PHP-FPM para confirmar ausência de erros
7. **Documentar** correção em relatório de implementação

---

## 📚 Referências

- **Erro Original:** Capturado em `/var/log/php8.3-fpm.log` após habilitar `catch_workers_output`
- **Documento Relacionado:** `ERRO_IDENTIFICADO_HTTP_500_20251118.md`
- **Implementação Anterior:** `RELATORIO_IMPLEMENTACAO_CATCH_WORKERS_OUTPUT_20251118.md`

---

**Status:** 🔍 **INVESTIGAÇÃO CONCLUÍDA**  
**Aguardando:** ✅ Autorização explícita do usuário para implementar correção

