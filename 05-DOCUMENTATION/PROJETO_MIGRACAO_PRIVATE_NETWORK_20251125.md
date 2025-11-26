# 🚀 PROJETO: Migração para Private Network Hetzner

**Data de Criação:** 25/11/2025  
**Status:** 📋 **PLANEJAMENTO** - Aguardando autorização para execução  
**Prioridade:** Alta (melhoria de segurança e performance)  
**Tempo Estimado:** 2-3 horas

---

## 📋 SUMÁRIO EXECUTIVO

### **Objetivo:**
Eliminar todas as chamadas HTTP entre os servidores **DEV** (`dev.bssegurosimediato.com.br` e `dev.flyingdonkeys.com.br`) que passam pela internet pública, migrando para comunicação via **Private Network do Hetzner**.

### **Benefícios Esperados:**
- ✅ **Segurança:** Comunicação isolada da internet pública
- ✅ **Performance:** Latência reduzida (rede privada é mais rápida)
- ✅ **Confiabilidade:** Menos pontos de falha (não depende de DNS público)
- ✅ **Custo:** Redução de tráfego de saída (não conta no limite de tráfego)
- ✅ **Estabilidade:** Elimina problemas de conectividade intermitente

### **Contexto Atual:**
- ✅ Private Network já configurada no Hetzner
- ✅ Servidor DEV (`dev.bssegurosimediato.com.br`) já configurado para acessar `dev.flyingdonkeys.com.br` via private network
- ✅ **AMBIENTE:** Apenas DEV por enquanto (PROD será feito posteriormente)
- ✅ IPs privados confirmados:
  - `dev.flyingdonkeys.com.br` = `10.0.0.2`
  - `dev.bssegurosimediato.com.br` = `10.0.0.3`

---

## 🎯 ESCOPO DO PROJETO

### **O Que Será Modificado:**

1. **Variáveis de Ambiente PHP-FPM:**
   - Adicionar variável `FLYINGDONKEYS_PRIVATE_IP` (IP privado do servidor flyingdonkeys)
   - Adicionar variável `FLYINGDONKEYS_PRIVATE_URL` (URL usando IP privado)

2. **Arquivos PHP:**
   - `ProfessionalLogger.php` - Modificar `makeHttpRequest()` para usar IP privado quando disponível
   - `add_flyingdonkeys.php` - Modificar URL do EspoCRM para usar IP privado
   - Qualquer outro arquivo que faça chamadas para `flyingdonkeys.com.br`

3. **Configurações PHP-FPM:**
   - `php-fpm_www_conf_DEV.conf` - Adicionar variáveis de ambiente
   - ⚠️ `php-fpm_www_conf_PROD.conf` - Será feito quando PROD estiver disponível

### **O Que NÃO Será Modificado:**
- ❌ Configuração da Private Network (já está feita)
- ❌ Configuração do Nginx (não é necessária)
- ❌ Certificados SSL (não são necessários para HTTP na rede privada)

---

## 🔍 ANÁLISE TÉCNICA

### **Situação Atual:**

**Chamadas Identificadas (AMBIENTE DEV):**

1. **ProfessionalLogger.php → send_email_notification_endpoint.php:**
   - **Atual:** `https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php`
   - **Problema:** Passa pela internet pública
   - **Solução:** Usar IP privado do servidor DEV

2. **add_flyingdonkeys.php → EspoCRM (dev.flyingdonkeys.com.br):**
   - **Atual:** `https://dev.flyingdonkeys.com.br` (via variável `ESPOCRM_URL`)
   - **Problema:** Passa pela internet pública
   - **Solução:** Usar IP privado do servidor flyingdonkeys DEV

### **Arquitetura Proposta:**

**ANTES (Internet Pública):**
```
dev.bssegurosimediato.com.br
    ↓ HTTPS (porta 443)
    ↓ Internet Pública
    ↓ DNS Resolution
    ↓
dev.flyingdonkeys.com.br
```

**DEPOIS (Private Network):**
```
dev.bssegurosimediato.com.br (10.0.0.3)
    ↓ HTTP (porta 80) - Rede Privada
    ↓ Private Network Hetzner
    ↓ IP Privado Direto
    ↓
dev.flyingdonkeys.com.br (10.0.0.2)
```

### **Considerações de Segurança:**

✅ **HTTP na Private Network é Seguro:**
- ✅ Rede privada é isolada da internet pública
- ✅ Apenas servidores na mesma Private Network podem acessar
- ✅ Não há necessidade de SSL/TLS na rede privada
- ✅ Reduz complexidade (não precisa de certificados)

⚠️ **IMPORTANTE:**
- ⚠️ Usar **HTTP** (não HTTPS) na rede privada
- ⚠️ Certificados SSL não funcionam com IPs privados
- ⚠️ HTTP na rede privada é seguro (isolado da internet)

---

## 📝 FASES DO PROJETO

### **FASE 1: Identificação e Mapeamento** ✅

**Objetivo:** Identificar todos os pontos de chamada entre servidores

**Tarefas:**
- [x] Identificar arquivos que fazem chamadas para `flyingdonkeys.com.br`
- [x] Identificar arquivos que fazem chamadas para `bssegurosimediato.com.br`
- [x] Mapear variáveis de ambiente relacionadas
- [x] Documentar IPs privados de cada servidor

**Arquivos Identificados:**
1. `ProfessionalLogger.php` - `makeHttpRequest()` para `send_email_notification_endpoint.php`
2. `add_flyingdonkeys.php` - Usa `ESPOCRM_URL` para acessar EspoCRM
3. Variáveis de ambiente PHP-FPM - `ESPOCRM_URL`

---

### **FASE 2: Configuração de Variáveis de Ambiente**

**Objetivo:** Adicionar variáveis de ambiente para IPs privados

**Tarefas:**
- [x] IPs privados confirmados:
  - `dev.flyingdonkeys.com.br` = `10.0.0.2`
  - `dev.bssegurosimediato.com.br` = `10.0.0.3`
- [ ] Adicionar variável `FLYINGDONKEYS_PRIVATE_IP` no PHP-FPM DEV
- [ ] Adicionar variável `BS_SEGUROS_PRIVATE_IP_DEV` no PHP-FPM DEV

**Arquivos a Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`
- ⚠️ **PROD:** Será implementado posteriormente quando ambiente PROD estiver disponível

**Exemplo de Adição:**
```ini
; Private Network Hetzner - DEV
env[FLYINGDONKEYS_PRIVATE_IP] = 10.0.0.2
env[BS_SEGUROS_PRIVATE_IP_DEV] = 10.0.0.3
```

---

### **FASE 3: Modificação do ProfessionalLogger.php**

**Objetivo:** Modificar `makeHttpRequest()` para usar IP privado quando disponível

**Tarefas:**
- [ ] Criar backup de `ProfessionalLogger.php`
- [ ] Adicionar função helper para detectar se endpoint é interno
- [ ] Modificar `makeHttpRequest()` para usar IP privado quando endpoint for interno
- [ ] Manter fallback para URL pública se IP privado não estiver disponível

**Arquivo a Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Lógica Proposta:**
```php
private function getPrivateNetworkUrl($publicUrl) {
    // Detectar se URL é para servidor interno
    $hostname = parse_url($publicUrl, PHP_URL_HOST);
    
    // Se for flyingdonkeys.com.br, usar IP privado
    if ($hostname === 'flyingdonkeys.com.br' || $hostname === 'dev.flyingdonkeys.com.br') {
        $privateIp = $_ENV['FLYINGDONKEYS_PRIVATE_IP'] ?? null;
        if ($privateIp) {
            return str_replace($hostname, $privateIp, $publicUrl);
        }
    }
    
    // Se for bssegurosimediato.com.br, usar IP privado
    if (strpos($hostname, 'bssegurosimediato.com.br') !== false) {
        $privateIp = $_ENV['BS_SEGUROS_PRIVATE_IP_' . strtoupper($_ENV['APP_ENVIRONMENT'])] ?? null;
        if ($privateIp) {
            return str_replace($hostname, $privateIp, $publicUrl);
        }
    }
    
    // Fallback: retornar URL original
    return $publicUrl;
}

private function makeHttpRequest($endpoint, $payload, $timeout = 10) {
    // Converter HTTPS para HTTP se for IP privado
    $privateEndpoint = $this->getPrivateNetworkUrl($endpoint);
    
    // Se endpoint foi convertido para IP privado, usar HTTP
    if (strpos($privateEndpoint, '10.0.0.') !== false) {
        $privateEndpoint = str_replace('https://', 'http://', $privateEndpoint);
    }
    
    // Continuar com lógica existente usando $privateEndpoint
    // ...
}
```

---

### **FASE 4: Modificação do add_flyingdonkeys.php**

**Objetivo:** Modificar URL do EspoCRM para usar IP privado

**Tarefas:**
- [ ] Criar backup de `add_flyingdonkeys.php`
- [ ] Modificar uso de `ESPOCRM_URL` para usar IP privado quando disponível
- [ ] Manter fallback para URL pública

**Arquivo a Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`

**Lógica Proposta:**
```php
// No início do arquivo, após carregar variáveis de ambiente
$espocrmUrl = $_ENV['ESPOCRM_URL'] ?? 'https://flyingdonkeys.com.br';

// Se IP privado estiver disponível, usar HTTP com IP privado
$flyingdonkeysPrivateIp = $_ENV['FLYINGDONKEYS_PRIVATE_IP'] ?? null;
if ($flyingdonkeysPrivateIp) {
    $espocrmUrl = "http://{$flyingdonkeysPrivateIp}";
}

// Usar $espocrmUrl no resto do código
```

---

### **FASE 5: Deploy e Testes**

**Objetivo:** Fazer deploy das alterações e testar funcionamento

**Tarefas:**
- [ ] Fazer deploy para servidor DEV
- [ ] Testar envio de email via ProfessionalLogger
- [ ] Testar integração com EspoCRM via add_flyingdonkeys.php
- [ ] Verificar logs para confirmar uso de IP privado
- [ ] Fazer deploy para servidor PROD (após validação em DEV)

**Testes a Realizar:**
1. **Teste de Email:**
   - Disparar erro que gera notificação de email
   - Verificar logs para confirmar que chamada foi feita via IP privado
   - Confirmar que email foi enviado com sucesso

2. **Teste de EspoCRM:**
   - Submeter formulário que cria lead no EspoCRM
   - Verificar logs para confirmar que chamada foi feita via IP privado
   - Confirmar que lead foi criado no EspoCRM

3. **Teste de Conectividade:**
   - Verificar que ping funciona entre servidores via IP privado
   - Verificar que HTTP funciona na rede privada

---

### **FASE 6: Documentação e Auditoria**

**Objetivo:** Documentar alterações e realizar auditoria

**Tarefas:**
- [ ] Documentar alterações realizadas
- [ ] Atualizar documentação de arquitetura
- [ ] Realizar auditoria pós-implementação
- [ ] Atualizar documento de tracking de alterações

---

## 📊 ARQUIVOS ENVOLVIDOS

### **Arquivos a Modificar:**

1. **`WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`**
   - Adicionar variáveis de ambiente para IPs privados

2. **`WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`**
   - Adicionar variáveis de ambiente para IPs privados

3. **`WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`**
   - Modificar `makeHttpRequest()` para usar IP privado

4. **`WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/add_flyingdonkeys.php`**
   - Modificar URL do EspoCRM para usar IP privado

### **Arquivos de Backup (Criar Antes de Modificar):**

1. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/ProfessionalLogger.php.backup_YYYYMMDD_HHMMSS`
2. `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/add_flyingdonkeys.php.backup_YYYYMMDD_HHMMSS`
3. `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf.backup_YYYYMMDD_HHMMSS`
4. `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf.backup_YYYYMMDD_HHMMSS`

---

## 🔧 DETALHAMENTO TÉCNICO

### **Como Funcionará:**

**1. Detecção Automática de Endpoints Internos:**

O código detectará automaticamente se uma URL é para um servidor interno (flyingdonkeys ou bssegurosimediato) e substituirá pelo IP privado correspondente.

**2. Conversão HTTPS → HTTP:**

Quando detectar que a URL foi convertida para IP privado, automaticamente converterá `https://` para `http://` (pois certificados SSL não funcionam com IPs privados).

**3. Fallback para URL Pública:**

Se IP privado não estiver disponível (variável de ambiente não configurada), manterá comportamento atual usando URL pública.

**4. Logs Detalhados:**

Adicionar logs para indicar quando está usando IP privado vs URL pública, facilitando diagnóstico.

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Riscos Identificados:**

1. **Risco: IP Privado Incorreto**
   - **Mitigação:** Verificar IPs privados antes de configurar variáveis de ambiente
   - **Teste:** Fazer ping entre servidores antes de deploy

2. **Risco: Private Network Não Funcionando**
   - **Mitigação:** Testar conectividade antes de fazer deploy
   - **Fallback:** Código mantém fallback para URL pública

3. **Risco: Certificado SSL na Rede Privada**
   - **Mitigação:** Usar HTTP (não HTTPS) na rede privada
   - **Segurança:** Rede privada é isolada, HTTP é seguro

4. **Risco: Quebra de Funcionalidade Existente**
   - **Mitigação:** Manter fallback para URL pública
   - **Teste:** Testar todas as funcionalidades após deploy

---

## ✅ CHECKLIST DE VALIDAÇÃO

### **Antes de Iniciar:**
- [x] IPs privados confirmados:
  - `dev.flyingdonkeys.com.br` = `10.0.0.2` ✅
  - `dev.bssegurosimediato.com.br` = `10.0.0.3` ✅
- [ ] Confirmar que Private Network está funcionando (ping entre servidores)
- [ ] Criar backups de todos os arquivos a modificar

### **Durante Implementação:**
- [ ] Adicionar variáveis de ambiente no PHP-FPM DEV
- [ ] Modificar ProfessionalLogger.php
- [ ] Modificar config.php (getEspoCrmUrl)
- [ ] Testar em ambiente DEV
- [ ] ⚠️ PROD será implementado posteriormente quando disponível

### **Após Implementação:**
- [ ] Testar envio de email via ProfessionalLogger
- [ ] Testar integração com EspoCRM
- [ ] Verificar logs para confirmar uso de IP privado
- [ ] Realizar auditoria pós-implementação
- [ ] Documentar alterações realizadas

---

## 📋 RESUMO DAS ALTERAÇÕES

### **Alterações em Variáveis de Ambiente:**

**DEV:**
```ini
env[FLYINGDONKEYS_PRIVATE_IP] = 10.0.0.2
env[BS_SEGUROS_PRIVATE_IP_DEV] = 10.0.0.3
```

**PROD:**
```ini
; Será implementado quando ambiente PROD estiver disponível
```

### **Alterações em Código:**

1. **ProfessionalLogger.php:**
   - Adicionar função `getPrivateNetworkUrl()`
   - Modificar `makeHttpRequest()` para usar IP privado

2. **add_flyingdonkeys.php:**
   - Modificar uso de `ESPOCRM_URL` para usar IP privado quando disponível

---

## 🚀 COMO SERÁ FEITO

### **Passo a Passo:**

1. **Verificar IPs Privados:**
   - Conectar via SSH aos servidores
   - Verificar IPs privados atribuídos
   - Documentar valores exatos

2. **Configurar Variáveis de Ambiente:**
   - Modificar arquivos PHP-FPM localmente
   - Copiar para servidores
   - Recarregar PHP-FPM

3. **Modificar Código PHP:**
   - Criar backups
   - Modificar arquivos localmente
   - Testar sintaxe PHP
   - Fazer deploy para DEV

4. **Testar em DEV:**
   - Testar envio de email
   - Testar integração EspoCRM
   - Verificar logs

5. **Deploy para PROD:**
   - Apenas após validação em DEV
   - Fazer deploy gradual
   - Monitorar logs

---

## 📝 NOTAS IMPORTANTES

### **IPs Privados (Confirmados):**

**Valores Reais:**
- `dev.flyingdonkeys.com.br`: `10.0.0.2` ✅
- `dev.bssegurosimediato.com.br`: `10.0.0.3` ✅

**⚠️ NOTA:** Apenas ambiente DEV está disponível no momento. PROD será implementado posteriormente.

### **Protocolo na Rede Privada:**

- ✅ **Usar HTTP** (não HTTPS) na rede privada
- ✅ Rede privada é isolada, HTTP é seguro
- ✅ Certificados SSL não funcionam com IPs privados

### **Fallback:**

- ✅ Código mantém fallback para URL pública se IP privado não estiver disponível
- ✅ Garante que sistema continue funcionando mesmo se Private Network falhar

---

**Documento criado em:** 25/11/2025  
**Status:** 📋 **AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**

---

## ❓ PRÓXIMOS PASSOS

**Status Atual:**
- ✅ IPs privados confirmados:
  - `dev.flyingdonkeys.com.br` = `10.0.0.2`
  - `dev.bssegurosimediato.com.br` = `10.0.0.3`
- ✅ Escopo definido: Apenas ambiente DEV (PROD posteriormente)

**Aguardando autorização para iniciar execução do projeto.**

**Após autorização, seguirei a sequência:**
1. Criar backups de todos os arquivos
2. Configurar variáveis de ambiente no PHP-FPM DEV
3. Modificar config.php (getEspoCrmUrl)
4. Modificar ProfessionalLogger.php
5. Testar em ambiente DEV
6. Validar funcionamento via Private Network

