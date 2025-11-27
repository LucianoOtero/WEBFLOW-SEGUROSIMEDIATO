# 📘 GUIA DE IMPLEMENTAÇÃO: Integração Datadog + PHP-FPM

**Versão:** 1.0.0  
**Data:** 25/11/2025  
**Método:** FastCGI Direto (Socket Unix)  
**Status:** ✅ **TESTADO E VALIDADO**

---

## 📋 ÍNDICE

1. [Pré-requisitos](#pré-requisitos)
2. [Verificações Iniciais](#verificações-iniciais)
3. [Implementação Passo a Passo](#implementação-passo-a-passo)
4. [Validação](#validação)
5. [Troubleshooting](#troubleshooting)
6. [Reversão](#reversão)
7. [Checklist Completo](#checklist-completo)

---

## 🔍 PRÉ-REQUISITOS

### **Requisitos do Servidor:**
- ✅ Datadog Agent instalado e rodando
- ✅ PHP-FPM instalado e configurado
- ✅ Acesso root ou sudo no servidor
- ✅ Socket Unix do PHP-FPM configurado

### **Informações Necessárias:**
- Caminho do socket Unix do PHP-FPM (geralmente `/run/php/php*-fpm.sock`)
- Versão do PHP-FPM (ex: 8.3, 8.2, etc.)
- Usuário do Datadog Agent (geralmente `dd-agent`)

---

## 🔍 VERIFICAÇÕES INICIAIS

### **1. Verificar Datadog Agent:**

```bash
# Verificar se Datadog Agent está instalado e rodando
systemctl status datadog-agent

# Verificar versão
datadog-agent version
```

**Resultado Esperado:** Serviço `active (running)`

---

### **2. Verificar PHP-FPM:**

```bash
# Verificar status do PHP-FPM
systemctl status php8.3-fpm  # Ajustar versão conforme necessário

# Verificar caminho do socket Unix
grep "listen" /etc/php/8.3/fpm/pool.d/www.conf | grep -v "^;"

# Verificar se socket existe
ls -la /run/php/php8.3-fpm.sock  # Ajustar caminho conforme necessário
```

**Resultado Esperado:**
- PHP-FPM `active (running)`
- Socket Unix existe e pertence a `www-data:www-data`

---

### **3. Verificar Usuário Datadog Agent:**

```bash
# Verificar usuário dd-agent
id dd-agent

# Verificar grupos do usuário
groups dd-agent
```

**Resultado Esperado:** Usuário `dd-agent` existe

---

## 🚀 IMPLEMENTAÇÃO PASSO A PASSO

### **PASSO 1: Identificar Socket Unix do PHP-FPM**

```bash
# Verificar configuração do PHP-FPM
grep "listen" /etc/php/8.3/fpm/pool.d/www.conf | grep -v "^;"

# Exemplo de saída:
# listen = /run/php/php8.3-fpm.sock
```

**⚠️ IMPORTANTE:** Anotar o caminho completo do socket (será usado no Passo 4)

---

### **PASSO 2: Verificar Permissões do Socket**

```bash
# Verificar permissões e proprietário do socket
ls -la /run/php/php8.3-fpm.sock

# Exemplo de saída:
# srw-rw---- 1 www-data www-data 0 Nov 26 10:00 /run/php/php8.3-fpm.sock
```

**Análise:**
- Proprietário: `www-data:www-data`
- Permissões: `660` (rw-rw----)
- Usuário `dd-agent` precisa estar no grupo `www-data` para acessar

---

### **PASSO 3: Adicionar dd-agent ao Grupo www-data**

```bash
# Adicionar dd-agent ao grupo www-data
usermod -a -G www-data dd-agent

# Verificar se foi adicionado corretamente
id dd-agent

# Resultado esperado:
# uid=999(dd-agent) gid=988(dd-agent) groups=988(dd-agent),33(www-data)
```

**✅ Validação:**
- Verificar se `www-data` aparece nos grupos do `dd-agent`
- Se não aparecer, verificar se comando foi executado com sucesso

---

### **PASSO 4: Verificar Acesso ao Socket**

```bash
# Testar se dd-agent consegue acessar o socket
sudo -u dd-agent test -r /run/php/php8.3-fpm.sock && echo "✅ Socket acessível" || echo "❌ Socket NÃO acessível"
```

**✅ Resultado Esperado:** `✅ Socket acessível`

**❌ Se falhar:**
- Verificar se `dd-agent` foi adicionado ao grupo `www-data`
- Verificar se socket existe e tem permissões corretas
- Pode ser necessário reiniciar sessão do `dd-agent` (não é necessário reiniciar serviço)

---

### **PASSO 5: Criar Backup (Se Configuração Existir)**

```bash
# Verificar se arquivo de configuração já existe
if [ -f /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml ]; then
    # Criar backup com timestamp
    cp /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml \
       /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml.backup_$(date +%Y%m%d_%H%M%S)
    echo "✅ Backup criado"
else
    echo "ℹ️ Arquivo não existe - não precisa backup"
fi
```

---

### **PASSO 6: Criar Arquivo de Configuração**

**⚠️ IMPORTANTE:** Substituir `/run/php/php8.3-fpm.sock` pelo caminho real do socket identificado no Passo 1.

```bash
# Criar arquivo de configuração
cat > /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml << 'EOFYAML'
init_config:

instances:
  - status_url: unix:///run/php/php8.3-fpm.sock/status
    ping_url: unix:///run/php/php8.3-fpm.sock/ping
    use_fastcgi: true
    ping_reply: pong
EOFYAML

# Verificar conteúdo do arquivo
cat /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml
```

**⚠️ AJUSTES NECESSÁRIOS:**
- Se socket for diferente: Substituir `/run/php/php8.3-fpm.sock` pelo caminho real
- Se versão PHP for diferente: Ajustar caminho conforme necessário (ex: `/run/php/php8.2-fpm.sock`)

**Exemplo para PHP 8.2:**
```yaml
status_url: unix:///run/php/php8.2-fpm.sock/status
ping_url: unix:///run/php/php8.2-fpm.sock/ping
```

---

### **PASSO 7: Validar Sintaxe da Configuração**

```bash
# Validar sintaxe YAML e configuração
datadog-agent configcheck 2>&1 | grep -A 10 php_fpm
```

**✅ Resultado Esperado:**
```
=== php_fpm check ===
Configuration provider: file
Configuration source: file:/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml
Config for instance ID: php_fpm:...
ping_reply: pong
ping_url: unix:///run/php/php8.3-fpm.sock/ping
status_url: unix:///run/php/php8.3-fpm.sock/status
use_fastcgi: true
```

**❌ Se houver erro:**
- Verificar sintaxe YAML (indentação, espaços, etc.)
- Verificar se caminho do socket está correto
- Verificar se todas as linhas estão corretas

---

### **PASSO 8: Reiniciar Datadog Agent**

```bash
# Reiniciar Datadog Agent para carregar nova configuração
systemctl restart datadog-agent

# Aguardar alguns segundos para serviço iniciar
sleep 5

# Verificar status
systemctl status datadog-agent --no-pager | head -15
```

**✅ Resultado Esperado:** `Active: active (running)`

---

### **PASSO 9: Validar Integração**

```bash
# Verificar status da integração PHP-FPM
datadog-agent status 2>&1 | grep -A 20 php_fpm
```

**✅ Resultado Esperado:**
```
php_fpm (6.1.0)
--------------
  Instance ID: php_fpm:... [OK]
  Configuration Source: file:/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml[0]
  Total Runs: 1
  Service Checks: Last Run: 1, Total: 1
  Last Successful Execution Date: ...
```

**✅ Indicadores de Sucesso:**
- Status: `[OK]`
- `Last Successful Execution Date` presente
- `Service Checks: Last Run: 1` ou maior

---

### **PASSO 10: Validar Funcionalidade do PHP-FPM**

```bash
# Verificar se PHP-FPM continua funcionando normalmente
systemctl status php8.3-fpm --no-pager | head -10

# Testar requisição HTTP (se aplicável)
curl -s -o /dev/null -w 'HTTP Status: %{http_code}\n' http://localhost/
```

**✅ Resultado Esperado:**
- PHP-FPM: `Active: active (running)`
- HTTP Status: `200` (ou código apropriado)

---

## ✅ VALIDAÇÃO

### **Checklist de Validação Completa:**

```bash
# 1. Verificar integração Datadog
echo "=== 1. Status Integração Datadog ==="
datadog-agent status 2>&1 | grep -A 15 php_fpm

# 2. Verificar PHP-FPM
echo "=== 2. Status PHP-FPM ==="
systemctl status php8.3-fpm --no-pager | head -10

# 3. Verificar permissões
echo "=== 3. Permissões dd-agent ==="
id dd-agent | grep www-data && echo "✅ dd-agent está no grupo www-data" || echo "❌ dd-agent NÃO está no grupo www-data"

# 4. Verificar acesso ao socket
echo "=== 4. Acesso ao Socket ==="
sudo -u dd-agent test -r /run/php/php8.3-fpm.sock && echo "✅ Socket acessível" || echo "❌ Socket NÃO acessível"

# 5. Verificar arquivo de configuração
echo "=== 5. Arquivo de Configuração ==="
cat /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml

# 6. Verificar logs (últimas 20 linhas)
echo "=== 6. Logs Datadog (últimas 20 linhas) ==="
tail -20 /var/log/datadog-agent/collector.log 2>/dev/null | grep -i php_fpm || echo "Sem logs de erro relacionados a php_fpm"
```

**✅ Todos os itens devem estar OK**

---

## 🔧 TROUBLESHOOTING

### **Problema 1: Integração não aparece no status**

**Sintomas:**
```bash
datadog-agent status | grep php_fpm
# Não retorna nada
```

**Soluções:**
1. Verificar se arquivo de configuração existe:
   ```bash
   ls -la /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml
   ```

2. Verificar sintaxe YAML:
   ```bash
   datadog-agent configcheck 2>&1 | grep php_fpm
   ```

3. Verificar permissões do arquivo:
   ```bash
   ls -la /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml
   # Deve ser legível por dd-agent
   ```

---

### **Problema 2: Status [ERROR] ou [WARN]**

**Sintomas:**
```bash
datadog-agent status | grep php_fpm
# Instance ID: php_fpm:... [ERROR]
```

**Soluções:**
1. Verificar acesso ao socket:
   ```bash
   sudo -u dd-agent test -r /run/php/php8.3-fpm.sock
   ```

2. Verificar se `dd-agent` está no grupo `www-data`:
   ```bash
   id dd-agent | grep www-data
   ```

3. Verificar logs de erro:
   ```bash
   tail -50 /var/log/datadog-agent/collector.log | grep -i php_fpm
   ```

4. Verificar se socket existe:
   ```bash
   ls -la /run/php/php8.3-fpm.sock
   ```

---

### **Problema 3: Socket não acessível**

**Sintomas:**
```bash
sudo -u dd-agent test -r /run/php/php8.3-fpm.sock
# Retorna erro
```

**Soluções:**
1. Verificar se `dd-agent` está no grupo `www-data`:
   ```bash
   id dd-agent
   # Deve mostrar www-data nos grupos
   ```

2. Se não estiver, adicionar:
   ```bash
   usermod -a -G www-data dd-agent
   id dd-agent  # Verificar novamente
   ```

3. Verificar permissões do socket:
   ```bash
   ls -la /run/php/php8.3-fpm.sock
   # Deve ser www-data:www-data com permissões 660
   ```

4. Se socket não existir, verificar PHP-FPM:
   ```bash
   systemctl status php8.3-fpm
   ```

---

### **Problema 4: Erro de sintaxe YAML**

**Sintomas:**
```bash
datadog-agent configcheck 2>&1 | grep php_fpm
# yaml: line X: did not find expected key
```

**Soluções:**
1. Verificar indentação (YAML é sensível a espaços):
   ```bash
   cat -A /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml
   # Verificar se usa espaços (não tabs)
   ```

2. Verificar estrutura YAML:
   ```yaml
   init_config:
   
   instances:
     - status_url: unix:///run/php/php8.3-fpm.sock/status
       ping_url: unix:///run/php/php8.3-fpm.sock/ping
       use_fastcgi: true
       ping_reply: pong
   ```

3. Recriar arquivo se necessário (copiar template correto)

---

### **Problema 5: PHP-FPM parou de funcionar**

**Sintomas:**
```bash
systemctl status php8.3-fpm
# Active: failed ou inactive
```

**Soluções:**
1. Verificar se problema é relacionado à implementação:
   ```bash
   # Reverter mudanças (ver seção Reversão)
   ```

2. Verificar logs do PHP-FPM:
   ```bash
   journalctl -u php8.3-fpm -n 50
   ```

3. Verificar configuração do PHP-FPM:
   ```bash
   php-fpm8.3 -t
   ```

**⚠️ IMPORTANTE:** A implementação NÃO deve afetar o PHP-FPM. Se PHP-FPM parou, provavelmente é problema não relacionado.

---

## 🔄 REVERSÃO

### **Reversão Completa (Se Necessário):**

```bash
# 1. Remover arquivo de configuração
rm /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml

# 2. Remover dd-agent do grupo www-data
gpasswd -d dd-agent www-data

# 3. Reiniciar Datadog Agent
systemctl restart datadog-agent

# 4. Verificar status
datadog-agent status | grep php_fpm
systemctl status php8.3-fpm
```

**✅ Após reversão:**
- Integração PHP-FPM não deve aparecer no status do Datadog
- PHP-FPM deve continuar funcionando normalmente
- `dd-agent` não deve estar no grupo `www-data`

---

## 📋 CHECKLIST COMPLETO

### **Antes de Iniciar:**
- [ ] Datadog Agent instalado e rodando
- [ ] PHP-FPM instalado e rodando
- [ ] Acesso root ou sudo disponível
- [ ] Caminho do socket Unix identificado

### **Durante Implementação:**
- [ ] Socket Unix identificado e anotado
- [ ] Permissões do socket verificadas
- [ ] `dd-agent` adicionado ao grupo `www-data`
- [ ] Acesso ao socket verificado
- [ ] Backup criado (se necessário)
- [ ] Arquivo de configuração criado
- [ ] Sintaxe YAML validada
- [ ] Datadog Agent reiniciado
- [ ] Integração validada no status

### **Após Implementação:**
- [ ] Integração aparece no status como `[OK]`
- [ ] Service checks sendo executados
- [ ] PHP-FPM funcionando normalmente
- [ ] Aplicação respondendo corretamente
- [ ] Logs sem erros críticos

---

## 📊 MÉTRICAS COLETADAS

Após implementação bem-sucedida, as seguintes métricas estarão disponíveis no Datadog:

### **Process States:**
- `php_fpm.processes.idle` - Processos ociosos
- `php_fpm.processes.active` - Processos ativos
- `php_fpm.processes.total` - Total de processos

### **Slow Requests:**
- `php_fpm.processes.slow` - Requisições lentas

### **Accepted Requests:**
- `php_fpm.requests.accepted` - Requisições aceitas
- `php_fpm.requests.total` - Total de requisições

### **Pool Information:**
- `php_fpm.process_manager` - Gerenciador de processos
- `php_fpm.processes.max_children` - Máximo de processos filhos

### **Service Checks:**
- `php_fpm.can_ping` - Verificação de saúde do pool FPM

**⚠️ NOTA:** Métricas podem levar alguns minutos para aparecer no dashboard Datadog.

---

## 📝 NOTAS IMPORTANTES

### **1. Versões Diferentes de PHP:**
- Se servidor usar PHP 8.2, ajustar caminho: `/run/php/php8.2-fpm.sock`
- Se servidor usar PHP 8.1, ajustar caminho: `/run/php/php8.1-fpm.sock`
- Sempre verificar caminho real com: `grep "listen" /etc/php/*/fpm/pool.d/www.conf`

### **2. Múltiplos Pools PHP-FPM:**
- Se houver múltiplos pools, configurar múltiplas instâncias no `conf.yaml`
- Cada pool precisa de uma entrada separada no arquivo de configuração

### **3. Socket TCP (Alternativa):**
- Se usar socket TCP em vez de Unix, ajustar configuração:
  ```yaml
  status_url: http://localhost:9000/status
  ping_url: http://localhost:9000/ping
  use_fastcgi: false
  ```

### **4. Performance:**
- Integração faz polling a cada 15 segundos (padrão)
- Overhead mínimo na performance do servidor
- Socket Unix é mais eficiente que HTTP

---

## ✅ CONCLUSÃO

Este guia fornece todos os passos necessários para implementar a integração Datadog + PHP-FPM em qualquer servidor.

**Tempo Estimado de Implementação:** 5-10 minutos

**Complexidade:** Baixa a Média

**Risco:** Baixo (se seguir passos corretamente)

---

**Documento criado em:** 25/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **TESTADO E VALIDADO**

