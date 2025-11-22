# 📋 PROJETO: Correção de Detecção de Duplicação - FlyingDonkeys

**Data de Criação:** 16/11/2025  
**Status:** ✅ **IMPLEMENTADO E CONCLUÍDO**  
**Prioridade:** 🔴 **ALTA** (Erro em produção)

---

## 🎯 OBJETIVO

Corrigir a detecção de duplicação de leads e oportunidades no `add_flyingdonkeys.php` para que o código identifique corretamente erros HTTP 409 (Conflict - duplicação) mesmo quando a mensagem de erro está vazia.

---

## 🔍 PROBLEMA IDENTIFICADO

### **Causa Raiz:**

O código de tratamento de duplicação verifica apenas a mensagem de erro (`$errorMessage`), mas não verifica o código HTTP da Exception (`$e->getCode()`). Quando o EspoCRM retorna HTTP 409 com mensagem vazia, a duplicação não é detectada.

### **Evidências:**

1. ✅ Exception é lançada com código HTTP 409, mas mensagem vazia
2. ❌ Tratamento verifica apenas mensagem: `strpos($errorMessage, '409')`
3. ❌ Mensagem está vazia: `$errorMessage = ""`
4. ❌ Código HTTP não é verificado: `$e->getCode()` não é usado
5. ❌ Resultado: Duplicação não detectada → Erro tratado como "erro real"

### **Locais Afetados:**

1. **Tratamento de Duplicação de LEAD:**
   - DEV: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php` (linha ~974-977)
   - PROD: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/add_flyingdonkeys.php` (linha ~974-977)

2. **Tratamento de Duplicação de OPPORTUNITY:**
   - DEV: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php` (linha ~1231)
   - PROD: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/add_flyingdonkeys.php` (linha ~1231)

**Total:** 4 correções (2 locais × 2 ambientes)

---

## 🔧 SOLUÇÃO PROPOSTA

### **Correção 1: Tratamento de Duplicação de LEAD**

**Localização:** Linha ~969-1009 (bloco catch para criação de lead)

**Modificação:**
```php
} catch (Exception $e) {
    $errorMessage = $e->getMessage();
    $httpCode = $e->getCode(); // ✅ ADICIONAR: Capturar código HTTP
    
    logDevWebhook('flyingdonkeys_exception', [
        'error' => $errorMessage,
        'http_code' => $httpCode  // ✅ ADICIONAR: Log do código HTTP
    ], false);

    // ✅ CORRIGIR: Verificar código HTTP 409 explicitamente
    if (
        $httpCode === 409 ||  // ✅ ADICIONAR: Verificar código HTTP
        strpos($errorMessage, '409') !== false || 
        strpos($errorMessage, 'duplicate') !== false ||
        (strpos($errorMessage, '"id":') !== false && strpos($errorMessage, '"name":') !== false)
    ) {
        // ... (resto do código permanece igual)
    }
}
```

### **Correção 2: Tratamento de Duplicação de OPPORTUNITY**

**Localização:** Linha ~1226-1241 (bloco catch para criação de oportunidade)

**Modificação:**
```php
} catch (Exception $e) {
    $errorMessage = $e->getMessage();
    $httpCode = $e->getCode(); // ✅ ADICIONAR: Capturar código HTTP
    
    logDevWebhook('opportunity_exception', [
        'error' => $errorMessage,
        'http_code' => $httpCode  // ✅ ADICIONAR: Log do código HTTP
    ], false);

    // ✅ CORRIGIR: Verificar código HTTP 409 explicitamente
    if (
        $httpCode === 409 ||  // ✅ ADICIONAR: Verificar código HTTP
        strpos($errorMessage, '409') !== false || 
        strpos($errorMessage, 'duplicate') !== false
    ) {
        // ... (resto do código permanece igual)
    }
}
```

---

## 📋 PROCESSO DE IMPLEMENTAÇÃO

Seguindo o **Fluxo de Trabalho para Correção de Erros em Arquivos .js e .php** definido no `.cursorrules`:

### **FASE 1: Atualizar em Desenvolvimento (Local)**

**Objetivo:** Aplicar correções no arquivo de desenvolvimento local

**Processo:**
1. ✅ Criar backup do arquivo original:
   - `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php.backup_ANTES_CORRECAO_DUPLICACAO_$(Get-Date -Format 'yyyyMMdd_HHmmss')`
2. ✅ Modificar arquivo `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`:
   - **Correção 1:** Adicionar verificação de código HTTP no tratamento de duplicação de LEAD (linha ~969)
   - **Correção 2:** Adicionar verificação de código HTTP no tratamento de duplicação de OPPORTUNITY (linha ~1226)
3. ✅ Verificar sintaxe PHP: `php -l add_flyingdonkeys.php`

**Arquivos a Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

---

### **FASE 2: Copiar de Desenvolvimento para Servidor de Desenvolvimento**

**Objetivo:** Deploy da correção para ambiente DEV para testes

**Processo:**
1. ✅ Criar backup no servidor DEV:
   ```bash
   ssh root@65.108.156.14 "cp /var/www/html/dev/root/add_flyingdonkeys.php /var/www/html/dev/root/add_flyingdonkeys.php.backup_ANTES_CORRECAO_DUPLICACAO_$(date +%Y%m%d_%H%M%S)"
   ```
2. ✅ Copiar arquivo corrigido para servidor DEV:
   ```bash
   scp "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\add_flyingdonkeys.php" root@65.108.156.14:/var/www/html/dev/root/
   ```
3. ✅ Verificar hash SHA256 após cópia:
   - Calcular hash do arquivo local
   - Calcular hash do arquivo no servidor
   - Comparar hashes (case-insensitive)
   - Confirmar que coincidem
4. ✅ Ajustar permissões:
   ```bash
   ssh root@65.108.156.14 "chown www-data:www-data /var/www/html/dev/root/add_flyingdonkeys.php && chmod 644 /var/www/html/dev/root/add_flyingdonkeys.php"
   ```

**Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)  
**Caminho:** `/var/www/html/dev/root/add_flyingdonkeys.php`

---

### **FASE 3: Testar em Desenvolvimento**

**Objetivo:** Confirmar que a correção funciona corretamente em DEV

**Testes Necessários:**

1. ✅ **Teste 1: Duplicação de Lead (HTTP 409)**
   - Submeter formulário com email já existente no EspoCRM
   - Verificar logs: Deve detectar `duplicate_lead_detected`
   - Verificar logs: Deve encontrar lead existente (`existing_lead_found`)
   - Verificar logs: Deve atualizar lead (`lead_updated`)
   - **Critério de Sucesso:** Lead atualizado ao invés de erro

2. ✅ **Teste 2: Duplicação de Oportunidade (HTTP 409)**
   - Criar oportunidade duplicada (se aplicável)
   - Verificar logs: Deve detectar `duplicate_opportunity_detected`
   - Verificar logs: Deve criar oportunidade com `duplicate = yes`
   - **Critério de Sucesso:** Oportunidade criada com sucesso

3. ✅ **Teste 3: Erro Real (não 409)**
   - Simular erro diferente de 409 (ex: 400, 500)
   - Verificar logs: Deve tratar como "erro real"
   - **Critério de Sucesso:** Erro não tratado como duplicação

**Comandos de Verificação:**
```bash
# Verificar logs do FlyingDonkeys
ssh root@65.108.156.14 "tail -n 50 /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt | grep -E 'duplicate_lead_detected|existing_lead_found|lead_updated|http_code'"

# Verificar se código HTTP está sendo logado
ssh root@65.108.156.14 "grep 'http_code' /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt | tail -n 10"
```

**Critério de Aprovação:**
- ✅ Todos os testes passam
- ✅ Logs mostram detecção correta de duplicação
- ✅ Código HTTP está sendo logado
- ✅ Nenhum erro inesperado nos logs

**⚠️ IMPORTANTE:** Se algum teste falhar, **PARAR** e corrigir em DEV antes de prosseguir para produção.

---

### **FASE 4: Atualizar de Desenvolvimento para Produção (Local)**

**Objetivo:** Copiar arquivo corrigido de DEV para PROD local (somente após sucesso em DEV)

**Processo:**
1. ✅ **SOMENTE APÓS** confirmação de sucesso em DEV (FASE 3)
2. ✅ Copiar arquivo de DEV para PROD:
   ```powershell
   Copy-Item "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\add_flyingdonkeys.php" "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\add_flyingdonkeys.php" -Force
   ```
3. ✅ Verificar que arquivo foi copiado corretamente
4. ✅ Comparar hash SHA256 dos arquivos DEV e PROD:
   - Calcular hash do arquivo DEV
   - Calcular hash do arquivo PROD
   - Confirmar que são idênticos

**Arquivos:**
- Origem: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`
- Destino: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/add_flyingdonkeys.php`

---

### **FASE 5: Copiar de Produção para Servidor de Produção**

**Objetivo:** Deploy da correção para ambiente PROD (somente após arquivo estar em PROD local)

**Processo:**
1. ✅ **SOMENTE APÓS** arquivo estar em `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/`
2. ✅ Criar backup no servidor PROD:
   ```bash
   ssh root@157.180.36.223 "cp /var/www/html/prod/root/add_flyingdonkeys.php /var/www/html/prod/root/add_flyingdonkeys.php.backup_ANTES_CORRECAO_DUPLICACAO_$(date +%Y%m%d_%H%M%S)"
   ```
3. ✅ Copiar arquivo corrigido para servidor PROD:
   ```bash
   scp "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\add_flyingdonkeys.php" root@157.180.36.223:/var/www/html/prod/root/
   ```
4. ✅ Verificar hash SHA256 após cópia:
   - Calcular hash do arquivo local (PROD)
   - Calcular hash do arquivo no servidor PROD
   - Comparar hashes (case-insensitive)
   - Confirmar que coincidem
5. ✅ Ajustar permissões:
   ```bash
   ssh root@157.180.36.223 "chown www-data:www-data /var/www/html/prod/root/add_flyingdonkeys.php && chmod 644 /var/www/html/prod/root/add_flyingdonkeys.php"
   ```

**Servidor:** `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)  
**Caminho:** `/var/www/html/prod/root/add_flyingdonkeys.php`

---

### **FASE 6: Verificação Final**

**Objetivo:** Confirmar que a correção está funcionando em produção

**Verificações:**
1. ✅ Testar funcionalidade corrigida no ambiente PROD
2. ✅ Verificar logs do servidor PROD após submissão de formulário
3. ✅ Confirmar que duplicação é detectada corretamente
4. ✅ Confirmar que lead é atualizado ao invés de gerar erro
5. 🚨 **OBRIGATÓRIO - CACHE CLOUDFLARE:** Avisar ao usuário sobre necessidade de limpar cache do Cloudflare

**Comandos de Verificação:**
```bash
# Verificar logs do FlyingDonkeys em PROD
ssh root@157.180.36.223 "tail -n 50 /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | grep -E 'duplicate_lead_detected|existing_lead_found|lead_updated|http_code'"

# Verificar se código HTTP está sendo logado
ssh root@157.180.36.223 "grep 'http_code' /var/log/webflow-segurosimediato/flyingdonkeys_prod.txt | tail -n 10"
```

---

## 📝 DETALHAMENTO DAS CORREÇÕES

### **Correção 1: Tratamento de Duplicação de LEAD**

**Arquivo:** `add_flyingdonkeys.php`  
**Localização:** Linha ~969-1009 (bloco catch)

**Código Atual:**
```php
} catch (Exception $e) {
    $errorMessage = $e->getMessage();
    logDevWebhook('flyingdonkeys_exception', ['error' => $errorMessage], false);

    if (
        strpos($errorMessage, '409') !== false || 
        strpos($errorMessage, 'duplicate') !== false ||
        (strpos($errorMessage, '"id":') !== false && strpos($errorMessage, '"name":') !== false)
    ) {
        // Tratamento de duplicação
    }
}
```

**Código Corrigido:**
```php
} catch (Exception $e) {
    $errorMessage = $e->getMessage();
    $httpCode = $e->getCode(); // ✅ ADICIONAR: Capturar código HTTP
    
    logDevWebhook('flyingdonkeys_exception', [
        'error' => $errorMessage,
        'http_code' => $httpCode  // ✅ ADICIONAR: Log do código HTTP
    ], false);

    // ✅ CORRIGIR: Verificar código HTTP 409 explicitamente
    if (
        $httpCode === 409 ||  // ✅ ADICIONAR: Verificar código HTTP
        strpos($errorMessage, '409') !== false || 
        strpos($errorMessage, 'duplicate') !== false ||
        (strpos($errorMessage, '"id":') !== false && strpos($errorMessage, '"name":') !== false)
    ) {
        logDevWebhook('duplicate_lead_detected', ['email' => $email], true);

        $existingLead = findLeadByEmail($email, $client, null);
        if ($existingLead) {
            logDevWebhook('existing_lead_found', ['lead_id' => $existingLead['id']], true);

            // Atualizar lead existente
            $updateResponse = $client->request('PATCH', 'Lead/' . $existingLead['id'], $lead_data);
            logDevWebhook('lead_updated', ['lead_id' => $existingLead['id']], true);
            $leadIdFlyingDonkeys = $existingLead['id'];
        } else {
            // ... (resto do código permanece igual)
        }
    } else {
        logDevWebhook('real_error_creating_lead', ['error' => $errorMessage], false);
        throw $e;
    }
}
```

### **Correção 2: Tratamento de Duplicação de OPPORTUNITY**

**Arquivo:** `add_flyingdonkeys.php`  
**Localização:** Linha ~1226-1241 (bloco catch)

**Código Atual:**
```php
} catch (Exception $e) {
    $errorMessage = $e->getMessage();
    logDevWebhook('opportunity_exception', ['error' => $errorMessage], false);

    if (strpos($errorMessage, '409') !== false || strpos($errorMessage, 'duplicate') !== false) {
        // Tratamento de duplicação
    }
}
```

**Código Corrigido:**
```php
} catch (Exception $e) {
    $errorMessage = $e->getMessage();
    $httpCode = $e->getCode(); // ✅ ADICIONAR: Capturar código HTTP
    
    logDevWebhook('opportunity_exception', [
        'error' => $errorMessage,
        'http_code' => $httpCode  // ✅ ADICIONAR: Log do código HTTP
    ], false);

    // ✅ CORRIGIR: Verificar código HTTP 409 explicitamente
    if (
        $httpCode === 409 ||  // ✅ ADICIONAR: Verificar código HTTP
        strpos($errorMessage, '409') !== false || 
        strpos($errorMessage, 'duplicate') !== false
    ) {
        logDevWebhook('duplicate_opportunity_detected', ['creating_with_duplicate_yes' => true], true);

        $opportunityPayload['duplicate'] = 'yes';
        $responseOpportunity = $client->request('POST', 'Opportunity', $opportunityPayload);
        $opportunityIdFlyingDonkeys = $responseOpportunity['id'];
        logDevWebhook('duplicate_opportunity_created', ['opportunity_id' => $opportunityIdFlyingDonkeys], true);
    } else {
        logDevWebhook('real_error_creating_opportunity', ['error' => $errorMessage], false);
    }
}
```

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **FASE 1: Desenvolvimento Local**
- [ ] Backup criado: `add_flyingdonkeys.php.backup_ANTES_CORRECAO_DUPLICACAO_*`
- [ ] Correção 1 aplicada (tratamento de duplicação de LEAD)
- [ ] Correção 2 aplicada (tratamento de duplicação de OPPORTUNITY)
- [ ] Sintaxe PHP verificada: `php -l add_flyingdonkeys.php`

### **FASE 2: Deploy DEV**
- [ ] Backup criado no servidor DEV
- [ ] Arquivo copiado para servidor DEV
- [ ] Hash SHA256 verificado (local vs servidor)
- [ ] Permissões ajustadas (`www-data:www-data`, `644`)

### **FASE 3: Testes DEV**
- [ ] Teste 1: Duplicação de Lead (HTTP 409) - PASSOU
- [ ] Teste 2: Duplicação de Oportunidade (HTTP 409) - PASSOU
- [ ] Teste 3: Erro Real (não 409) - PASSOU
- [ ] Logs verificados: `duplicate_lead_detected` aparece
- [ ] Logs verificados: `http_code` está sendo logado
- [ ] Nenhum erro inesperado nos logs

### **FASE 4: Atualização PROD Local**
- [ ] Confirmação de sucesso em DEV recebida
- [ ] Arquivo copiado de DEV para PROD local
- [ ] Hash SHA256 comparado (DEV vs PROD local - devem ser idênticos)

### **FASE 5: Deploy PROD**
- [ ] Arquivo confirmado em `03-PRODUCTION/`
- [ ] Backup criado no servidor PROD
- [ ] Arquivo copiado para servidor PROD
- [ ] Hash SHA256 verificado (PROD local vs servidor PROD)
- [ ] Permissões ajustadas (`www-data:www-data`, `644`)

### **FASE 6: Verificação Final**
- [ ] Funcionalidade testada em PROD
- [ ] Logs verificados em PROD
- [ ] Duplicação detectada corretamente em PROD
- [ ] Lead atualizado com sucesso em PROD
- [ ] Usuário avisado sobre cache do Cloudflare

---

## 📊 RESUMO

**Arquivos a Modificar:** 2 (DEV e PROD)  
**Locais por Arquivo:** 2 (LEAD e OPPORTUNITY)  
**Total de Correções:** 4

**Impacto Esperado:**
- ✅ Duplicação de leads será detectada corretamente mesmo com mensagem vazia
- ✅ Leads duplicados serão atualizados ao invés de gerar erro
- ✅ Duplicação de oportunidades será detectada corretamente
- ✅ Logs incluirão código HTTP para melhor diagnóstico

**Risco:** 🟢 **BAIXO** - Correção adiciona verificação adicional sem alterar lógica existente

---

**Status:** 📋 **PRONTO PARA IMPLEMENTAÇÃO**

