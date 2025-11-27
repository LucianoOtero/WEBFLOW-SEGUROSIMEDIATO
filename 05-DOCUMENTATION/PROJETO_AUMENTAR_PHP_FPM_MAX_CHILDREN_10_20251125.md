# 🔧 PROJETO: Aumentar PHP-FPM pm.max_children para 10 Workers

**Data de Criação:** 25/11/2025  
**Última Atualização:** 25/11/2025  
**Status:** 📋 **PROJETO APRIMORADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.1.0  
**Ambiente:** Development primeiro, depois Production

---

## 🎯 OBJETIVO DO PROJETO

Aumentar o limite de workers PHP-FPM de 5 para 10 em desenvolvimento, testar, e depois aplicar em produção após resize do servidor.

### **Objetivos Específicos:**

1. ✅ Aumentar `pm.max_children` de 5 para 10 em DEV
2. ✅ Ajustar configurações relacionadas (`pm.start_servers`, `pm.min_spare_servers`, `pm.max_spare_servers`)
3. ✅ Testar em ambiente DEV
4. ✅ Monitorar performance e estabilidade
5. ✅ Documentar processo para aplicação em PROD após resize

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### **Objetivos do Usuário:**

1. ✅ **Resolver problema de sobrecarga do PHP-FPM**
   - Eliminar warnings "server reached pm.max_children setting (5)"
   - Reduzir requisições rejeitadas ou com timeout
   - Melhorar disponibilidade do sistema

2. ✅ **Melhorar diagnóstico de erros de conexão**
   - Substituir `file_get_contents()` por cURL para melhor diagnóstico
   - Obter informações detalhadas sobre falhas de conexão
   - Identificar tipo de erro (DNS, timeout, SSL, conexão)

3. ✅ **Garantir estabilidade e performance**
   - Não degradar performance existente
   - Manter funcionalidades atuais funcionando
   - Preparar para crescimento futuro

### **Funcionalidades Solicitadas:**

1. ✅ **Aumento de capacidade PHP-FPM**
   - Aumentar limite de workers de 5 para 10
   - Ajustar configurações relacionadas proporcionalmente
   - Manter comportamento dinâmico do pool

2. ✅ **Melhor diagnóstico de erros**
   - Implementar função wrapper cURL com fallback
   - Adicionar logs detalhados de diagnóstico
   - Identificar tipo de erro específico

### **Requisitos Não-Funcionais:**

1. ✅ **Performance:**
   - Não degradar tempo de resposta das requisições
   - Manter latência atual ou melhorar
   - Suportar picos de tráfego sem rejeitar requisições

2. ✅ **Disponibilidade:**
   - Zero downtime durante implementação (usar `reload` ao invés de `restart`)
   - Fallback automático se cURL não disponível
   - Rollback rápido se necessário

3. ✅ **Segurança:**
   - Não expor credenciais ou informações sensíveis
   - Manter logs seguros (sem dados sensíveis)
   - Validar entrada adequadamente

4. ✅ **Manutenibilidade:**
   - Código bem documentado
   - Funções reutilizáveis
   - Fácil de entender e modificar

### **Critérios de Aceitação do Usuário:**

1. ✅ **Critério 1: Resolução do Problema de Sobrecarga**
   - **Aceitação:** Zero ou muito raro (menos de 1 por semana) warnings "server reached pm.max_children"
   - **Métrica:** Contagem de warnings no log PHP-FPM
   - **Validação:** Monitorar por 1 semana após implementação

2. ✅ **Critério 2: Melhor Diagnóstico de Erros**
   - **Aceitação:** Logs devem mostrar tipo específico de erro (DNS, timeout, SSL, conexão)
   - **Métrica:** Presença de `error_category` nos logs de erro
   - **Validação:** Verificar logs após ocorrência de erro

3. ✅ **Critério 3: Sem Degradação de Performance**
   - **Aceitação:** Tempo de resposta não deve aumentar mais de 10%
   - **Métrica:** Tempo médio de resposta das requisições
   - **Validação:** Comparar antes e depois da implementação

4. ✅ **Critério 4: Funcionalidades Existentes Funcionando**
   - **Aceitação:** Todas as funcionalidades atuais devem continuar funcionando
   - **Métrica:** Testes funcionais completos
   - **Validação:** Testar todas as funcionalidades principais após implementação

### **Restrições e Limitações:**

1. ⚠️ **Recursos do Servidor DEV:**
   - CPU: 2 cores (pode ter algum context switching com 10 workers)
   - RAM: ~4 GB (suficiente para 10 workers)
   - **Limitação:** Performance pode não ser ideal, mas aceitável para teste

2. ⚠️ **Recursos do Servidor PROD:**
   - CPU: 2 cores atualmente (precisa resize para 4 cores antes de aplicar)
   - RAM: ~4 GB (suficiente para 10 workers)
   - **Limitação:** Aplicar em PROD apenas após resize do servidor

3. ⚠️ **Downtime:**
   - **Aceitável:** Breve downtime (alguns segundos) durante `reload` do PHP-FPM
   - **Não aceitável:** Downtime prolongado ou perda de requisições em andamento
   - **Mitigação:** Usar `reload` ao invés de `restart`

### **Expectativas de Resultado:**

1. ✅ **Resultado Imediato:**
   - Eliminação de warnings de sobrecarga PHP-FPM
   - Melhor diagnóstico de erros de conexão
   - Sistema mais estável e responsivo

2. ✅ **Resultado de Médio Prazo (1 semana):**
   - Confirmação de que problema foi resolvido
   - Validação de que não há degradação de performance
   - Preparação para aplicação em PROD

3. ✅ **Resultado de Longo Prazo (após PROD):**
   - Sistema escalável e preparado para crescimento
   - Diagnóstico melhorado facilita resolução de problemas futuros
   - Base sólida para futuras melhorias

---

## 👥 STAKEHOLDERS

### **Stakeholders Identificados:**

1. ✅ **Usuário Final / Cliente**
   - **Interesse:** Sistema funcionando sem erros, sem timeouts
   - **Impacto:** Alto - Beneficia diretamente com melhor disponibilidade
   - **Responsabilidade:** Validar que problema foi resolvido

2. ✅ **Equipe de Desenvolvimento**
   - **Interesse:** Melhor diagnóstico de erros, código de qualidade
   - **Impacto:** Médio - Facilita debugging e manutenção
   - **Responsabilidade:** Implementar, testar e monitorar

3. ✅ **Equipe de Infraestrutura / DevOps**
   - **Interesse:** Sistema estável, recursos adequados
   - **Impacto:** Alto - Responsável por servidores e configuração
   - **Responsabilidade:** Aplicar configuração, monitorar recursos

4. ✅ **Administrador do Sistema**
   - **Interesse:** Sistema funcionando, logs claros
   - **Impacto:** Alto - Responsável por operação do sistema
   - **Responsabilidade:** Aprovar implementação, validar resultados

### **Comunicação com Stakeholders:**

1. ✅ **Antes da Implementação:**
   - Apresentar projeto e objetivos
   - Obter aprovação para execução
   - Agendar horário de implementação (se necessário)

2. ✅ **Durante a Implementação:**
   - Notificar início da implementação
   - Informar progresso (se houver problemas)
   - Notificar conclusão

3. ✅ **Após a Implementação:**
   - Apresentar resultados do monitoramento
   - Validar que critérios de aceitação foram atendidos
   - Obter aprovação para aplicação em PROD (após resize)

---

## 📊 ANÁLISE DA SITUAÇÃO ATUAL

### **Configuração Atual (DEV e PROD):**

```ini
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
```

### **Problema Identificado:**

- ⚠️ Servidor PROD atingindo limite de 5 workers frequentemente
- ⚠️ WARNING: "server reached pm.max_children setting (5)"
- ⚠️ Requisições sendo rejeitadas ou tendo timeout

### **Solução Proposta:**

- ✅ Aumentar para 10 workers (2x o atual)
- ✅ Ajustar configurações relacionadas proporcionalmente
- ✅ Testar em DEV antes de aplicar em PROD

---

## 📁 ARQUIVOS A MODIFICAR

### **FASE 1: Modificar Configuração DEV**

#### **1.1. Arquivo: `php-fpm_www_conf_DEV.conf`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`

**Alterações:**
```ini
; ANTES:
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3

; DEPOIS:
pm.max_children = 10
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 6
```

**Justificativa:**
- `pm.max_children`: 5 → 10 (2x o atual)
- `pm.start_servers`: 2 → 4 (2x o atual, 40% do máximo)
- `pm.min_spare_servers`: 1 → 2 (2x o atual, 20% do máximo)
- `pm.max_spare_servers`: 3 → 6 (2x o atual, 60% do máximo)

---

### **FASE 2: Criar Backup da Configuração Atual**

#### **2.1. Backup no Servidor DEV**

**Comando:**
```bash
# Criar backup com timestamp
cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_$(date +%Y%m%d_%H%M%S)
```

**Localização do backup:** `/etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS`

---

### **FASE 3: Aplicar Configuração no Servidor DEV**

#### **3.1. Copiar Arquivo para Servidor**

**Processo:**
1. Modificar arquivo local: `php-fpm_www_conf_DEV.conf`
2. Copiar para servidor DEV via SCP
3. Verificar integridade (hash)
4. Aplicar configuração

**Comando SCP:**
```bash
scp "WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf" root@65.108.156.14:/etc/php/8.3/fpm/pool.d/www.conf
```

---

### **FASE 4: Recarregar PHP-FPM**

#### **4.1. Recarregar Serviço (Sem Reiniciar Servidor)**

**Comando:**
```bash
systemctl reload php8.3-fpm
```

**Vantagem:** Não interrompe requisições em andamento, apenas recarrega configuração.

---

### **FASE 5: Verificar e Testar**

#### **5.1. Verificar Configuração Aplicada**

**Comandos:**
```bash
# Verificar se configuração foi aplicada
grep "pm.max_children" /etc/php/8.3/fpm/pool.d/www.conf

# Verificar status do PHP-FPM
systemctl status php8.3-fpm

# Verificar workers ativos
ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l
```

#### **5.2. Testar Aplicação**

**Verificações:**
- ✅ Site responde normalmente
- ✅ Requisições são processadas
- ✅ Não há erros nos logs
- ✅ Workers não atingem limite de 10

---

### **FASE 6: Monitoramento (1 semana)**

#### **6.1. Métricas a Monitorar**

**Comandos de monitoramento:**
```bash
# Verificar se ainda atinge limite
grep "reached pm.max_children" /var/log/php8.3-fpm.log | wc -l

# Verificar workers ativos periodicamente
watch -n 5 'ps aux | grep "php-fpm: pool www" | grep -v grep | wc -l'

# Verificar uso de RAM
free -h

# Verificar uso de CPU
top -bn1 | grep "Cpu(s)"
```

**Métricas:**
- Quantas vezes atinge `pm.max_children` (deve ser zero ou muito raro)
- Uso de RAM do servidor
- Uso de CPU do servidor
- Tempo de resposta das requisições
- Erros de conexão/timeout

---

### **FASE 7: Preparar para PROD (Após Resize)**

#### **7.1. Arquivo: `php-fpm_www_conf_PROD.conf`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`

**Alterações (mesmas de DEV):**
```ini
pm.max_children = 10
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 6
```

**⚠️ IMPORTANTE:** Aplicar em PROD **APENAS APÓS** resize do servidor para 4 cores.

---

## 🔧 ESPECIFICAÇÕES TÉCNICAS

### **1. Função Wrapper cURL com Fallback**

**Localização:** `ProfessionalLogger.php` (novo método privado)

**Função:**
```php
/**
 * Fazer requisição HTTP usando cURL com fallback para file_get_contents
 * @param string $endpoint URL do endpoint
 * @param string $payload Payload JSON
 * @param int $timeout Timeout em segundos
 * @return array Resultado com informações detalhadas
 */
private function makeHttpRequest($endpoint, $payload, $timeout = 10) {
    // Verificar se cURL está disponível
    if (!function_exists('curl_init')) {
        // Fallback para file_get_contents
        return $this->makeHttpRequestFileGetContents($endpoint, $payload, $timeout);
    }
    
    // Usar cURL para melhor diagnóstico
    $ch = curl_init($endpoint);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => $timeout,
        CURLOPT_CONNECTTIMEOUT => 5,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_SSL_VERIFYHOST => false,
        CURLOPT_HTTPHEADER => [
            'Content-Type: application/json',
            'User-Agent: ProfessionalLogger-EmailNotification/1.0'
        ],
        CURLOPT_POST => true,
        CURLOPT_POSTFIELDS => $payload
    ]);
    
    $startTime = microtime(true);
    $result = curl_exec($ch);
    $duration = microtime(true) - $startTime;
    
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curlError = curl_error($ch);
    $curlErrno = curl_errno($ch);
    $connectTime = curl_getinfo($ch, CURLINFO_CONNECT_TIME);
    
    curl_close($ch);
    
    // Identificar tipo de erro
    $errorCategory = 'NONE';
    if ($result === false) {
        if ($curlErrno === CURLE_OPERATION_TIMEOUTED) {
            $errorCategory = 'TIMEOUT';
        } elseif ($curlErrno === CURLE_COULDNT_RESOLVE_HOST) {
            $errorCategory = 'DNS';
        } elseif ($curlErrno === CURLE_SSL_CONNECT_ERROR) {
            $errorCategory = 'SSL';
        } elseif ($curlErrno === CURLE_COULDNT_CONNECT) {
            $errorCategory = 'CONNECTION_REFUSED';
        } else {
            $errorCategory = 'UNKNOWN';
        }
    }
    
    // Logar resultado detalhado
    if ($result === false) {
        error_log("[ProfessionalLogger] cURL falhou após " . round($duration, 2) . "s | Tipo: {$errorCategory} | Erro: {$curlError} | Código: {$curlErrno} | Endpoint: {$endpoint}");
    } else {
        error_log("[ProfessionalLogger] cURL sucesso após " . round($duration, 2) . "s | HTTP: {$httpCode} | Conexão: " . round($connectTime, 2) . "s | Endpoint: {$endpoint}");
    }
    
    return [
        'success' => $result !== false && $httpCode === 200,
        'data' => $result,
        'http_code' => $httpCode,
        'error' => $curlError,
        'errno' => $curlErrno,
        'error_category' => $errorCategory,
        'duration' => $duration,
        'connect_time' => $connectTime
    ];
}

/**
 * Fallback: Fazer requisição HTTP usando file_get_contents
 * @param string $endpoint URL do endpoint
 * @param string $payload Payload JSON
 * @param int $timeout Timeout em segundos
 * @return array Resultado com informações básicas
 */
private function makeHttpRequestFileGetContents($endpoint, $payload, $timeout = 10) {
    $headerString = "Content-Type: application/json\r\n" .
                   "User-Agent: ProfessionalLogger-EmailNotification/1.0";
    
    $context = stream_context_create([
        'http' => [
            'method' => 'POST',
            'header' => $headerString,
            'content' => $payload,
            'timeout' => $timeout,
            'ignore_errors' => true
        ],
        'ssl' => [
            'verify_peer' => false,
            'verify_peer_name' => false,
            'allow_self_signed' => true
        ]
    ]);
    
    $startTime = microtime(true);
    $result = @file_get_contents($endpoint, false, $context);
    $duration = microtime(true) - $startTime;
    
    if ($result === false) {
        $error = error_get_last();
        error_log("[ProfessionalLogger] file_get_contents falhou após " . round($duration, 2) . "s | Erro: " . ($error['message'] ?? 'Desconhecido') . " | Endpoint: {$endpoint}");
    }
    
    return [
        'success' => $result !== false,
        'data' => $result,
        'http_code' => null,
        'error' => $result === false ? ($error['message'] ?? 'Erro desconhecido') : null,
        'errno' => null,
        'error_category' => 'UNKNOWN',
        'duration' => $duration,
        'connect_time' => null
    ];
}
```

**Uso na função `sendEmailNotification()`:**
```php
// Substituir:
$result = @file_get_contents($endpoint, false, $context);

// Por:
$response = $this->makeHttpRequest($endpoint, $jsonPayload, 10);
$result = $response['data'];

// Usar informações detalhadas para logs
if (!$response['success']) {
    error_log("[ProfessionalLogger] Falha detalhada | Tipo: {$response['error_category']} | HTTP: {$response['http_code']} | Erro: {$response['error']}");
}
```

---

### **2. Configuração PHP-FPM**

**Process Manager:** `dynamic` (já configurado)

**Valores Propostos:**
```ini
pm = dynamic
pm.max_children = 10
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 6
```

**Explicação:**
- `pm.max_children = 10`: Máximo de 10 workers simultâneos
- `pm.start_servers = 4`: Inicia com 4 workers ao iniciar PHP-FPM
- `pm.min_spare_servers = 2`: Mantém mínimo de 2 workers ociosos
- `pm.max_spare_servers = 6`: Mantém máximo de 6 workers ociosos

**Comportamento:**
- PHP-FPM inicia com 4 workers
- Se houver demanda, cria até 10 workers
- Se workers ficarem ociosos, mantém entre 2-6 workers ociosos
- Se houver mais de 6 ociosos, mata os extras

---

### **2. Recursos do Servidor DEV**

**Atual:**
```
CPU: 2 cores
RAM: ~4 GB
```

**Com 10 workers:**
```
RAM necessária: 10 × 50 MB = 500 MB
RAM disponível: ~3 GB
Uso: ~16,7% (muito seguro)
```

**CPU:**
```
10 workers ÷ 2 cores = 5 workers por core
Aceitável para teste, mas pode ter algum context switching
```

---

### **3. Recursos do Servidor PROD (Após Resize)**

**Após resize para CPX31:**
```
CPU: 4 cores
RAM: 8 GB
```

**Com 10 workers:**
```
RAM necessária: 10 × 50 MB = 500 MB
RAM disponível: ~7 GB
Uso: ~7% (muito seguro)
```

**CPU:**
```
10 workers ÷ 4 cores = 2,5 workers por core
Ideal - performance otimizada
```

---

## 📋 FASES DO PROJETO

### **FASE 1: Preparação e Backup** ⏱️ 10 minutos

**Objetivo:** Criar backup e preparar arquivo de configuração

**Tarefas:**
1. ✅ Criar backup da configuração atual no servidor DEV
2. ✅ Ler arquivo atual `php-fpm_www_conf_DEV.conf`
3. ✅ Modificar valores conforme especificado
4. ✅ Verificar sintaxe do arquivo

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`

---

### **FASE 1.5: Substituir `file_get_contents()` por cURL** ⏱️ 30 minutos

**Objetivo:** Melhorar diagnóstico de erros de conexão substituindo `file_get_contents()` por cURL

**Justificativa:**
- ✅ Apenas 1 uso real precisa ser substituído (`ProfessionalLogger.php:1053`)
- ✅ Uso raro (1-2 vezes/dia) - baixo risco
- ✅ Alto benefício - melhor diagnóstico quando falha
- ✅ cURL já está disponível em DEV e PROD (verificado)

**Tarefas:**
1. ✅ Criar função wrapper `makeHttpRequest()` com fallback
2. ✅ Substituir `file_get_contents()` por cURL em `ProfessionalLogger.php`
3. ✅ Adicionar logs detalhados de diagnóstico
4. ✅ Testar em DEV
5. ✅ Verificar que fallback funciona se cURL não disponível

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
- `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/ProfessionalLogger.php`

---

### **FASE 2: Aplicar em DEV** ⏱️ 20 minutos

**Objetivo:** Aplicar nova configuração PHP-FPM e código atualizado no servidor DEV

**Tarefas:**
1. ✅ Copiar arquivo PHP-FPM modificado para servidor DEV
2. ✅ Verificar hash após cópia
3. ✅ Copiar `ProfessionalLogger.php` atualizado para servidor DEV
4. ✅ Verificar hash após cópia
5. ✅ Validar sintaxe PHP-FPM: `php-fpm8.3 -tt`
6. ✅ Validar sintaxe PHP: `php -l ProfessionalLogger.php`
7. ✅ Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
8. ✅ Verificar se serviço está rodando

**Comandos:**
```bash
# Copiar configuração PHP-FPM
scp php-fpm_www_conf_DEV.conf root@65.108.156.14:/etc/php/8.3/fpm/pool.d/www.conf

# Copiar ProfessionalLogger.php
scp ProfessionalLogger.php root@65.108.156.14:/var/www/html/dev/root/ProfessionalLogger.php

# Validar sintaxe PHP-FPM
ssh root@65.108.156.14 "php-fpm8.3 -tt"

# Validar sintaxe PHP
ssh root@65.108.156.14 "php -l /var/www/html/dev/root/ProfessionalLogger.php"

# Recarregar
ssh root@65.108.156.14 "systemctl reload php8.3-fpm"

# Verificar status
ssh root@65.108.156.14 "systemctl status php8.3-fpm"
```

---

### **FASE 3: Verificação Imediata** ⏱️ 10 minutos

**Objetivo:** Verificar se configuração foi aplicada corretamente

**Tarefas:**
1. ✅ Verificar configuração no servidor
2. ✅ Verificar workers ativos
3. ✅ Testar aplicação (site responde)
4. ✅ Verificar logs de erro

**Comandos:**
```bash
# Verificar configuração
ssh root@65.108.156.14 "grep 'pm.max_children\|pm.start_servers\|pm.min_spare_servers\|pm.max_spare_servers' /etc/php/8.3/fpm/pool.d/www.conf"

# Verificar workers
ssh root@65.108.156.14 "ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l"

# Testar site
curl -I https://dev.bssegurosimediato.com.br

# Verificar logs
ssh root@65.108.156.14 "tail -20 /var/log/php8.3-fpm.log"
```

---

### **FASE 4: Monitoramento (1 semana)** ⏱️ Contínuo

**Objetivo:** Monitorar performance e estabilidade

**Tarefas:**
1. ✅ Monitorar se atinge limite de 10 workers
2. ✅ Monitorar uso de RAM
3. ✅ Monitorar uso de CPU
4. ✅ Monitorar tempo de resposta
5. ✅ Verificar erros nos logs

**Script de Monitoramento:**
```bash
#!/bin/bash
# monitor_phpfpm.sh

echo "=== Monitoramento PHP-FPM $(date) ==="
echo "Workers ativos: $(ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l)"
echo "Limite atingido: $(grep -c 'reached pm.max_children' /var/log/php8.3-fpm.log)"
echo "RAM: $(free -h | grep Mem | awk '{print $3 "/" $2}')"
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')"
```

---

### **FASE 5: Preparar para PROD** ⏱️ 10 minutos

**Objetivo:** Preparar configuração para PROD (aplicar após resize)

**Tarefas:**
1. ✅ Modificar `php-fpm_www_conf_PROD.conf` com mesmos valores
2. ✅ Documentar processo de aplicação em PROD
3. ✅ Criar checklist para aplicação em PROD

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`

**⚠️ IMPORTANTE:** Não aplicar em PROD até resize do servidor estar completo.

---

## ⚠️ CONSIDERAÇÕES IMPORTANTES

### **1. Riscos de Negócio**

#### **1.1. Impacto em Usuários**

**Riscos Identificados:**
- ⚠️ **Downtime durante implementação:** Breve downtime (alguns segundos) durante `reload` do PHP-FPM
- ⚠️ **Possível degradação de performance:** Se recursos não forem suficientes, pode haver degradação
- ⚠️ **Erros durante implementação:** Se houver erro de sintaxe ou configuração, pode causar indisponibilidade

**Mitigações:**
- ✅ Usar `reload` ao invés de `restart` (não interrompe requisições em andamento)
- ✅ Validar sintaxe antes de aplicar (`php-fpm8.3 -tt`)
- ✅ Fazer em horário de baixo tráfego (se possível)
- ✅ Ter plano de rollback pronto

**Impacto Esperado:**
- **Downtime:** Mínimo (alguns segundos durante reload)
- **Degradação:** Nenhuma esperada (recursos são suficientes)
- **Erros:** Improvável (validação de sintaxe antes de aplicar)

---

#### **1.2. Impacto em Métricas de Negócio**

**Métricas Afetadas:**
- ✅ **Disponibilidade:** Esperada melhoria (menos rejeições de requisições)
- ✅ **Tempo de Resposta:** Esperada melhoria ou manutenção (mais workers disponíveis)
- ✅ **Taxa de Erro:** Esperada redução (menos timeouts e erros de conexão)
- ✅ **Satisfação do Usuário:** Esperada melhoria (sistema mais responsivo)

**Monitoramento:**
- ✅ Monitorar métricas antes e depois da implementação
- ✅ Comparar resultados após 1 semana de monitoramento
- ✅ Validar que métricas melhoraram ou mantiveram-se estáveis

---

#### **1.3. Impacto Financeiro**

**Custos:**
- ✅ **Custo de Implementação:** Zero (apenas tempo de desenvolvimento)
- ✅ **Custo de Infraestrutura:** Zero (não requer upgrade imediato)
- ✅ **Custo de Manutenção:** Zero (código é auto-suficiente)

**Benefícios:**
- ✅ **Redução de Suporte:** Menos problemas = menos tempo de suporte
- ✅ **Melhor Disponibilidade:** Menos perda de requisições = melhor conversão
- ✅ **Preparação para Crescimento:** Sistema preparado para aumento de tráfego

**ROI Esperado:**
- ✅ **Investimento:** ~75 minutos de desenvolvimento + 1 semana de monitoramento
- ✅ **Retorno:** Melhor disponibilidade, menos problemas, melhor diagnóstico
- ✅ **Payback:** Imediato (problema resolvido)

---

### **2. Substituição de `file_get_contents()` por cURL**

**Riscos Identificados:**
- ✅ **Dependência de cURL:** Verificado - cURL está disponível em DEV e PROD
- ⚠️ **Mudança de formato de erro:** Adaptar código para novo formato
- ⚠️ **Complexidade do código:** Criar função wrapper para encapsular

**Mitigações:**
- ✅ Função wrapper com fallback para `file_get_contents()` se cURL não disponível
- ✅ Logs detalhados de diagnóstico (tipo de erro, HTTP status, tempo)
- ✅ Testes em DEV antes de aplicar em PROD

**Benefícios:**
- ✅ Melhor diagnóstico de erros (DNS, timeout, SSL, conexão)
- ✅ Informações de HTTP status code
- ✅ Tempo de conexão vs tempo total separados
- ✅ Identificação precisa do tipo de erro

---

### **2. Backup Obrigatório**

- ✅ **SEMPRE criar backup** antes de modificar configuração
- ✅ Backup com timestamp para rastreabilidade
- ✅ Manter backup local também

### **3. Validação de Sintaxe**

- ✅ **SEMPRE validar sintaxe** antes de recarregar: `php-fpm8.3 -tt`
- ✅ Se houver erro de sintaxe, **NÃO recarregar**
- ✅ Corrigir erro antes de prosseguir

### **4. Recarregar vs Reiniciar**

- ✅ **Usar `reload`** ao invés de `restart`
- ✅ `reload` não interrompe requisições em andamento
- ✅ `restart` interrompe todas as requisições

### **5. Monitoramento Pós-Implementação**

- ✅ Monitorar por **pelo menos 1 semana**
- ✅ Verificar se resolve problema de sobrecarga
- ✅ Verificar se não causa degradação de performance

### **6. Aplicação em PROD**

- ⚠️ **APENAS após resize do servidor** para 4 cores
- ⚠️ **APENAS após teste bem-sucedido em DEV**
- ⚠️ Fazer em horário de baixo tráfego
- ⚠️ Ter plano de rollback pronto

---

## 📊 RESUMO DAS ALTERAÇÕES

### **Alterações em Código PHP:**

1. ✅ **`ProfessionalLogger.php`** - Substituir `file_get_contents()` por cURL
   - Adicionar método `makeHttpRequest()` (cURL com diagnóstico detalhado)
   - Adicionar método `makeHttpRequestFileGetContents()` (fallback)
   - Modificar `sendEmailNotification()` para usar novo método
   - Adicionar logs detalhados de diagnóstico

---

## 📊 RESUMO DAS ALTERAÇÕES DE CONFIGURAÇÃO

### **Arquivos a Modificar:**

1. ✅ `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`
   - `pm.max_children`: 5 → 10
   - `pm.start_servers`: 2 → 4
   - `pm.min_spare_servers`: 1 → 2
   - `pm.max_spare_servers`: 3 → 6

2. ✅ `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
   - Adicionar função `makeHttpRequest()` com fallback
   - Adicionar função `makeHttpRequestFileGetContents()` (fallback)
   - Substituir `file_get_contents()` por `makeHttpRequest()` em `sendEmailNotification()`
   - Adicionar logs detalhados de diagnóstico

3. ✅ `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/ProfessionalLogger.php`
   - Mesmas alterações (aplicar após testes em DEV)

4. ✅ `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`
   - Mesmas alterações (aplicar após resize)

### **Servidor DEV:**
- ✅ Aplicar configuração imediatamente
- ✅ Testar e monitorar

### **Servidor PROD:**
- ⚠️ Aplicar **APENAS após resize** para CPX31 (4 cores)

---

## ⏱️ TEMPO ESTIMADO TOTAL

**Total:** ~75 minutos (implementação) + 1 semana (monitoramento)

- FASE 1: 10 minutos
- FASE 1.5: 30 minutos (substituir file_get_contents por cURL)
- FASE 2: 20 minutos
- FASE 3: 10 minutos
- FASE 4: 1 semana (monitoramento contínuo)
- FASE 5: 10 minutos

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **FASE 1: Preparação**
- [ ] Criar backup no servidor DEV
- [ ] Ler arquivo `php-fpm_www_conf_DEV.conf`
- [ ] Modificar valores conforme especificado
- [ ] Verificar sintaxe do arquivo

### **FASE 1.5: Substituir file_get_contents por cURL**
- [ ] Criar função wrapper `makeHttpRequest()` com fallback
- [ ] Substituir `file_get_contents()` em `ProfessionalLogger.php`
- [ ] Adicionar logs detalhados de diagnóstico
- [ ] Testar função wrapper localmente
- [ ] Verificar que fallback funciona

### **FASE 2: Aplicar em DEV**
- [ ] Copiar arquivo PHP-FPM para servidor DEV
- [ ] Verificar hash após cópia
- [ ] Copiar `ProfessionalLogger.php` para servidor DEV
- [ ] Verificar hash após cópia
- [ ] Validar sintaxe PHP-FPM
- [ ] Validar sintaxe PHP
- [ ] Recarregar PHP-FPM
- [ ] Verificar status do serviço

### **FASE 3: Verificação**
- [ ] Verificar configuração aplicada
- [ ] Verificar workers ativos
- [ ] Testar aplicação
- [ ] Verificar logs de erro

### **FASE 4: Monitoramento**
- [ ] Monitorar se atinge limite (1 semana)
- [ ] Monitorar uso de RAM
- [ ] Monitorar uso de CPU
- [ ] Monitorar tempo de resposta
- [ ] Verificar erros nos logs

### **FASE 5: Preparar PROD**
- [ ] Modificar `php-fpm_www_conf_PROD.conf`
- [ ] Documentar processo para PROD
- [ ] Criar checklist para PROD
- [ ] Aguardar resize do servidor PROD

---

## 🔄 PLANO DE ROLLBACK

### **Se algo der errado em DEV:**

#### **A. Rollback de Configuração PHP-FPM:**

1. ✅ Restaurar backup:
   ```bash
   cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf
   systemctl reload php8.3-fpm
   ```

2. ✅ Verificar se serviço voltou ao normal
3. ✅ Investigar problema antes de tentar novamente

#### **B. Rollback de Código PHP:**

1. ✅ Restaurar backup do `ProfessionalLogger.php`:
   ```bash
   cp /var/www/html/dev/root/ProfessionalLogger.php.backup_YYYYMMDD_HHMMSS /var/www/html/dev/root/ProfessionalLogger.php
   ```

2. ✅ Verificar se aplicação voltou ao normal
3. ✅ Investigar problema antes de tentar novamente

**Nota:** A função wrapper tem fallback automático para `file_get_contents()`, então mesmo se cURL falhar, código continua funcionando.

---

## 📋 PRÓXIMOS PASSOS APÓS IMPLEMENTAÇÃO

1. ✅ Monitorar DEV por 1 semana
2. ✅ Confirmar que resolve problema de sobrecarga (PHP-FPM)
3. ✅ Confirmar que não causa degradação de performance
4. ✅ Verificar se logs de cURL fornecem melhor diagnóstico
5. ✅ Confirmar que fallback funciona (se necessário)
6. ✅ Fazer resize do servidor PROD para CPX31
7. ✅ Aplicar mesma configuração em PROD
8. ✅ Monitorar PROD por 1 semana

---

---

## 📋 REFERÊNCIAS

### **Documentos Relacionados:**

1. ✅ `CALCULO_LIMITE_PHP_FPM_PRODUCAO_20251125.md` - Cálculo do limite conservador (10 workers)
2. ✅ `ANALISE_RISCOS_SUBSTITUIR_FILE_GET_CONTENTS_CURL_20251125.md` - Análise completa de riscos
3. ✅ `ANALISE_LOGS_PRODUCAO_TIMESTAMP_125629_20251125.md` - Causa raiz identificada (PHP-FPM sobrecarregado)
4. ✅ `REQUISITOS_HETZNER_20_WORKERS_20251125.md` - Requisitos para 20 workers (futuro)
5. ✅ `UPGRADE_HETZNER_SEM_REINSTALAR_20251125.md` - Processo de upgrade Hetzner

---

---

## 📝 HISTÓRICO DE VERSÕES

### **Versão 1.1.0 (25/11/2025)**
- ✅ Adicionada seção "Especificações do Usuário" (recomendação da auditoria)
- ✅ Adicionada seção "Stakeholders" (recomendação da auditoria)
- ✅ Adicionada seção "Riscos de Negócio" (recomendação da auditoria)
- ✅ Aprimorada documentação conforme auditoria

### **Versão 1.0.0 (25/11/2025)**
- ✅ Criação inicial do projeto
- ✅ Definição de objetivos e fases
- ✅ Especificações técnicas
- ✅ Análise de riscos técnicos

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Versão:** 1.1.0  
**Status:** 📋 **PROJETO APRIMORADO - AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**

