# 🔍 VERIFICAÇÃO: Inserção de Lead e Oportunidade no EspoCRM

**Data:** 25/11/2025  
**Status:** 🔍 **VERIFICAÇÃO - APENAS CONSULTA**  
**Ambiente:** Production (`prod.bssegurosimediato.com.br`)

---

## 📊 COMO O CÓDIGO VERIFICA INSERÇÃO

### **1. Verificação de Lead**

**Localização:** `add_flyingdonkeys.php` (linhas 951-968)

**Processo:**
1. ✅ Cria/atualiza lead via `$client->request('POST', 'Lead', $lead_data)` ou `PATCH`
2. ✅ Verifica se resposta contém `id`: `$leadIdFlyingDonkeys = $responseFlyingDonkeys['id'] ?? null;`
3. ✅ Se `id` não existe, lança exceção: `throw new Exception('Lead criado mas ID não retornado na resposta');`
4. ✅ Loga sucesso: `logDevWebhook('flyingdonkeys_lead_created', ['lead_id' => $leadIdFlyingDonkeys], true);`

**Limitação:**
- ⚠️ **Apenas verifica se a API retornou um ID** - não confirma se realmente foi inserido no EspoCRM
- ⚠️ **Não faz consulta GET** para confirmar que o lead existe no EspoCRM

### **2. Verificação de Oportunidade**

**Localização:** `add_flyingdonkeys.php` (linhas 1229-1231)

**Processo:**
1. ✅ Cria oportunidade via `$client->request('POST', 'Opportunity', $opportunityPayload)`
2. ✅ Extrai ID da resposta: `$opportunityIdFlyingDonkeys = $responseOpportunity['id'];`
3. ✅ Loga sucesso: `logDevWebhook('opportunity_created', ['opportunity_id' => $opportunityIdFlyingDonkeys], true);`

**Limitação:**
- ⚠️ **Apenas verifica se a API retornou um ID** - não confirma se realmente foi inserida no EspoCRM
- ⚠️ **Não faz consulta GET** para confirmar que a oportunidade existe no EspoCRM

---

## ✅ MÉTODOS DE VERIFICAÇÃO DISPONÍVEIS

### **Método 1: Verificar Resposta da API (Atual)**

**O que verifica:**
- ✅ Se a API retornou um ID (indica que a inserção foi aceita)
- ✅ Se não houve exceção durante a chamada

**O que NÃO verifica:**
- ❌ Se o lead/oportunidade realmente existe no EspoCRM
- ❌ Se os dados foram salvos corretamente
- ❌ Se houve erro silencioso no EspoCRM

**Código atual:**
```php
// Lead
$responseFlyingDonkeys = $client->request('POST', 'Lead', $lead_data);
$leadIdFlyingDonkeys = $responseFlyingDonkeys['id'] ?? null;
if (!$leadIdFlyingDonkeys) {
    throw new Exception('Lead criado mas ID não retornado na resposta');
}

// Oportunidade
$responseOpportunity = $client->request('POST', 'Opportunity', $opportunityPayload);
$opportunityIdFlyingDonkeys = $responseOpportunity['id'];
```

### **Método 2: Consulta GET para Confirmar (NÃO IMPLEMENTADO)**

**O que faria:**
- ✅ Consultaria o EspoCRM via GET para confirmar que o lead/oportunidade existe
- ✅ Verificaria se os dados foram salvos corretamente
- ✅ Confirmaria inserção real no banco de dados do EspoCRM

**Como implementar (sugestão):**
```php
// Após criar lead
$responseFlyingDonkeys = $client->request('POST', 'Lead', $lead_data);
$leadIdFlyingDonkeys = $responseFlyingDonkeys['id'] ?? null;

// ✅ VERIFICAÇÃO ADICIONAL: Consultar lead criado
if ($leadIdFlyingDonkeys) {
    try {
        $verificationLead = $client->request('GET', 'Lead/' . $leadIdFlyingDonkeys);
        if (isset($verificationLead['id']) && $verificationLead['id'] === $leadIdFlyingDonkeys) {
            logDevWebhook('lead_verification_success', ['lead_id' => $leadIdFlyingDonkeys], true);
        } else {
            logDevWebhook('lead_verification_failed', ['lead_id' => $leadIdFlyingDonkeys], false);
        }
    } catch (Exception $e) {
        logDevWebhook('lead_verification_error', ['lead_id' => $leadIdFlyingDonkeys, 'error' => $e->getMessage()], false);
    }
}

// Após criar oportunidade
$responseOpportunity = $client->request('POST', 'Opportunity', $opportunityPayload);
$opportunityIdFlyingDonkeys = $responseOpportunity['id'];

// ✅ VERIFICAÇÃO ADICIONAL: Consultar oportunidade criada
if ($opportunityIdFlyingDonkeys) {
    try {
        $verificationOpportunity = $client->request('GET', 'Opportunity/' . $opportunityIdFlyingDonkeys);
        if (isset($verificationOpportunity['id']) && $verificationOpportunity['id'] === $opportunityIdFlyingDonkeys) {
            logDevWebhook('opportunity_verification_success', ['opportunity_id' => $opportunityIdFlyingDonkeys], true);
        } else {
            logDevWebhook('opportunity_verification_failed', ['opportunity_id' => $opportunityIdFlyingDonkeys], false);
        }
    } catch (Exception $e) {
        logDevWebhook('opportunity_verification_error', ['opportunity_id' => $opportunityIdFlyingDonkeys, 'error' => $e->getMessage()], false);
    }
}
```

### **Método 3: Verificar Logs do EspoCRM (Manual)**

**O que verifica:**
- ✅ Logs do próprio EspoCRM (se acessível)
- ✅ Histórico de inserções no banco de dados do EspoCRM

**Limitação:**
- ⚠️ Requer acesso ao EspoCRM ou banco de dados
- ⚠️ Não é automático

---

## 📋 VERIFICAÇÃO ATUAL NO CÓDIGO

### **Status Atual:**

#### **✅ Lead:**
- ✅ Código verifica se API retornou ID
- ✅ Código lança exceção se ID não existe
- ✅ Código loga sucesso quando ID existe
- ❌ **NÃO faz consulta GET para confirmar inserção real**

#### **✅ Oportunidade:**
- ✅ Código verifica se API retornou ID
- ✅ Código loga sucesso quando ID existe
- ❌ **NÃO faz consulta GET para confirmar inserção real**

---

## 🔍 COMO VERIFICAR MANUALMENTE

### **1. Verificar Logs do Webhook**

**Arquivo de log:** `/var/www/html/prod/root/logs/flyingdonkeys_prod.txt`

**Comandos:**
```bash
# Verificar última inserção de lead bem-sucedida
grep "flyingdonkeys_lead_created" /var/www/html/prod/root/logs/flyingdonkeys_prod.txt | tail -1

# Verificar última inserção de oportunidade bem-sucedida
grep "opportunity_created" /var/www/html/prod/root/logs/flyingdonkeys_prod.txt | tail -1

# Verificar resposta da API
grep "flyingdonkeys_api_response" /var/www/html/prod/root/logs/flyingdonkeys_prod.txt | tail -1
```

**Indicadores de sucesso:**
- ✅ `flyingdonkeys_lead_created` com `lead_id` válido
- ✅ `opportunity_created` com `opportunity_id` válido
- ✅ `flyingdonkeys_api_response` com `has_id: true`

### **2. Verificar Resposta HTTP do Webhook**

**O que verificar:**
- ✅ Resposta contém `leadIdFlyingDonkeys` (não null)
- ✅ Resposta contém `opportunityIdFlyingDonkeys` (não null)
- ✅ Resposta contém `success: true`

**Exemplo de resposta esperada:**
```json
{
  "success": true,
  "message": "Lead e Oportunidade processados com sucesso",
  "data": {
    "leadIdFlyingDonkeys": "67890abcdef",
    "opportunityIdFlyingDonkeys": "12345abcdef",
    "environment": "production",
    "api_version": "2.0",
    "webhook": "flyingdonkeys-v2",
    "request_id": "prod_fd_..."
  }
}
```

### **3. Consultar EspoCRM Diretamente (Manual)**

**Usando script de teste:**
```php
<?php
require_once __DIR__ . '/class.php';
require_once __DIR__ . '/config.php';

$FLYINGDONKEYS_API_URL = getEspoCrmUrl();
$FLYINGDONKEYS_API_KEY = getEspoCrmApiKey();

$client = new EspoApiClient($FLYINGDONKEYS_API_URL);
$client->setApiKey($FLYINGDONKEYS_API_KEY);

// Substituir pelo ID do lead que você quer verificar
$leadId = '67890abcdef';

try {
    $lead = $client->request('GET', 'Lead/' . $leadId);
    echo "✅ Lead encontrado:\n";
    echo json_encode($lead, JSON_PRETTY_PRINT);
} catch (Exception $e) {
    echo "❌ Lead não encontrado: " . $e->getMessage() . "\n";
}

// Substituir pelo ID da oportunidade que você quer verificar
$opportunityId = '12345abcdef';

try {
    $opportunity = $client->request('GET', 'Opportunity/' . $opportunityId);
    echo "✅ Oportunidade encontrada:\n";
    echo json_encode($opportunity, JSON_PRETTY_PRINT);
} catch (Exception $e) {
    echo "❌ Oportunidade não encontrada: " . $e->getMessage() . "\n";
}
?>
```

---

## ⚠️ CONCLUSÃO

### **Status Atual da Verificação:**

1. **✅ Verificação Básica (Implementada):**
   - Código verifica se API retornou ID
   - Código lança exceção se ID não existe
   - Código loga sucesso quando ID existe

2. **❌ Verificação Completa (NÃO Implementada):**
   - Código NÃO faz consulta GET para confirmar inserção real
   - Código NÃO verifica se dados foram salvos corretamente
   - Código NÃO confirma inserção real no banco de dados do EspoCRM

### **Recomendação:**

**Para verificação completa, seria necessário:**
1. ✅ Adicionar consulta GET após criar lead/oportunidade
2. ✅ Verificar se o ID retornado realmente existe no EspoCRM
3. ✅ Verificar se os dados foram salvos corretamente
4. ✅ Logar resultado da verificação

**Isso seria uma melhoria futura, não uma correção de bug.**

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Status:** 🔍 Verificação completa - Código atual verifica apenas se API retornou ID, não confirma inserção real no EspoCRM

