# 🔍 ANÁLISE: Relatório do Especialista em Infraestrutura - 26/11/2025

**Data:** 26/11/2025  
**Contexto:** Análise crítica do relatório de investigação por especialista em infraestrutura  
**Status:** 📋 **ANÁLISE TÉCNICA** - Considerações e refinamentos

---

## 📋 RESUMO EXECUTIVO

### **Pontos de Concordância:**
- ✅ Timeout de 30s do AbortController é o **gatilho imediato** do erro
- ✅ Erro é intermitente, compatível com flutuações de rede
- ✅ Nginx e PHP-FPM não apresentam sinais de exaustão no momento do erro
- ✅ Erros vêm do JavaScript (`fetchWithRetry`), não de cURL/PHP

### **Pontos de Refinamento:**
- ⚠️ **Simplificação perigosa:** "requisição não chega ao servidor por causa do timeout"
- ⚠️ **Tecnicamente:** Se browser já enviou requisição HTTP, Nginx normalmente loga mesmo que cliente aborte depois
- ⚠️ **Ausência de log sugere:** Requisição nunca chegou a ser enviada OU conexão não foi estabelecida

### **Causa Raiz Refinada:**
**Problema "misto":**
- **Aplicação:** Timeout curto (30s) no front-end
- **Rede:** Latência/instabilidade que faz conexão às vezes demorar >30s

---

## 🔍 ANÁLISE DETALHADA DO RELATÓRIO

### **1. Sobre a "Simplificação Perigosa"**

#### **Minha Afirmação Original:**
> "Timeout de 30s do AbortController cancela requisição antes de chegar ao servidor."

#### **Correção do Especialista:**
**Tecnicamente, isso nem sempre é verdade:**

**Cenário 1: AbortController cancela ANTES de enviar requisição**
- ✅ Nada chega ao Nginx
- ✅ Nenhum log no access.log
- ✅ **Este é o caso observado**

**Cenário 2: AbortController cancela DEPOIS de enviar requisição**
- ✅ Nginx recebe e processa requisição
- ✅ Nginx loga no access.log (mesmo que cliente já tenha ido embora)
- ✅ Requisição é processada normalmente

**Conclusão:**
- ⚠️ A ausência de log significa que **requisição nunca foi enviada** ou **handshake TCP/TLS não completou**
- ⚠️ Não significa necessariamente que "timeout cancelou antes de chegar"
- ⚠️ Pode significar que **conexão nunca foi estabelecida** dentro da janela de 30s

---

### **2. O Que a Ausência de Log Realmente Indica**

#### **Possibilidades Técnicas:**

**1. Handshake TCP/TLS não completou dentro de 30s**
- Cliente inicia conexão
- Handshake demora >30s
- AbortController cancela antes de completar
- Nginx nunca recebe requisição HTTP
- **Resultado:** Nenhum log no access.log

**2. Requisição nunca saiu do cliente**
- Problema no browser (extensão, bloqueador)
- Problema na rede local (Wi-Fi, roteador)
- Problema no cliente (firewall local)
- **Resultado:** Nenhum log no access.log

**3. Problema em ponto intermediário**
- ISP bloqueando ou limitando
- Cloudflare bloqueando ou rate limiting
- Rota instável ou congestionada
- DNS lento ou não resolvendo
- **Resultado:** Nenhum log no access.log

**4. Filtro de logs muito estrito**
- Regex não capturou requisição
- Horário levemente deslocado
- Formato de log diferente
- **Resultado:** Falso negativo (requisição existe mas não foi encontrada)

---

### **3. Refinamento da Causa Raiz**

#### **Minha Conclusão Original:**
> "Causa raiz: Timeout de 30 segundos do AbortController no JavaScript cancelando requisições antes de chegarem ao servidor."

#### **Conclusão Refinada pelo Especialista:**
> "Causa imediata: timeout de 30s no front (AbortController) faz o usuário receber erro antes do servidor responder.
> 
> Possível causa subjacente: latência de rede / handshake lento / rota instável em alguns clientes, que faz a conexão/navegação às vezes demorar >30s."

**Versão Final Refinada:**
> "Os erros intermitentes são causados pelo timeout de 30 segundos do AbortController no JavaScript, que encerra as chamadas antes que o servidor consiga responder em situações de latência de rede/handshake mais alta. O servidor não apresenta sinais de exaustão (PHP-FPM, Nginx ou banco), mas a combinação de timeout curto no front com picos de latência faz com que algumas requisições nunca cheguem a ser totalmente estabelecidas ou processadas."

---

## 📋 CONSIDERAÇÕES TÉCNICAS

### **1. Sobre o Comportamento do Nginx access.log**

**Comportamento Técnico:**
- ✅ Nginx loga no `access.log` **após receber requisição HTTP completa**
- ✅ Se cliente fecha conexão **depois** de Nginx receber requisição, log ainda é escrito
- ✅ Se cliente fecha conexão **antes** de Nginx receber requisição, log não é escrito

**Implicação:**
- ⚠️ Ausência de log = Requisição HTTP nunca chegou ao Nginx
- ⚠️ Isso pode ser:
  - Handshake TCP/TLS não completou
  - Requisição nunca saiu do cliente
  - Problema em ponto intermediário

---

### **2. Sobre a Infraestrutura**

**Evidências Coletadas:**
- ✅ PHP-FPM: 8 processos ativos de 10 (80% de utilização)
- ✅ RAM: 86% livre (3.2 GB de 3.7 GB)
- ✅ Nenhum log de "max_children" no dia 26/11
- ✅ Nginx: Configuração padrão (timeouts de 60s)

**Conclusão do Especialista:**
- ✅ **Não há evidência de que servidor estava "quebrando"** no momento do erro
- ✅ **Mas fato de front precisar esperar perto de 30s indica latência anormal** que vale investigar

---

### **3. Sobre o Banco de Dados**

**Observação do Especialista:**
- ✅ Para **essa ocorrência específica**, banco não entrou no jogo (nenhuma requisição chegou)
- ⚠️ Mas isso **não significa que DB nunca seja problema**
- ⚠️ Vale revisar em paralelo:
  - Índices nas tabelas
  - Tempo de resposta médio das queries
  - Uso de conexão persistente

---

## 📋 RECOMENDAÇÕES PRÁTICAS DO ESPECIALISTA

### **5.1 Front-end / JavaScript (Impacto Imediato)**

#### **1. Aumentar Timeout do AbortController para ≥ 60s**

**Código Atual:**
```javascript
const timeoutId = setTimeout(() => controller.abort(), 30000); // 30s
```

**Código Recomendado:**
```javascript
const timeoutId = setTimeout(() => controller.abort(), 60000); // 60s
```

**Justificativa:**
- Alinhar com `fastcgi_read_timeout` / `proxy_read_timeout` do Nginx (60s)
- Reduzir drasticamente ocorrências de timeout

---

#### **2. Logar Tempo da Tentativa Antes do Erro**

**O que medir:**
- Tempo desde início do `fetch()` até o erro
- `requestDurationMs`, `attempt`, `error.name`

**Onde logar:**
- `log_endpoint.php` (banco de dados)
- Logs do navegador (console)

**Exemplo:**
```javascript
const startTime = Date.now();
try {
  const response = await fetch(url, options);
  const duration = Date.now() - startTime;
  // Logar duration
} catch (error) {
  const duration = Date.now() - startTime;
  logEvent('error', {
    error: error.name,
    duration: duration,
    attempt: attempt
  });
}
```

---

#### **3. Melhorar logEvent**

**Problema Atual:**
- `logEvent` recebe `{ error, attempt }` quando há erro
- Mas verifica `data.ddd`, `data.celular`, etc.
- Campos não existem → aparece `has_ddd: false`

**Solução 1: Passar dados relevantes junto com erro**
```javascript
logEvent('whatsapp_modal_octadesk_initial_error', {
  error: errorMsg,
  attempt: result.attempt + 1,
  ddd: ddd,           // Passar dados reais
  celular: celular,   // Passar dados reais
  // ... outros dados
}, 'error');
```

**Solução 2: Ajustar logEvent para estrutura diferente quando severity === 'error'**
```javascript
function logEvent(eventType, data, severity = 'info') {
  if (severity === 'error') {
    // Estrutura diferente para erros
    window.novo_log(logLevel, 'MODAL', `[ERROR] ${eventType}`, {
      error: data.error,
      attempt: data.attempt,
      duration: data.duration,
      // ... não verificar ddd, celular, etc.
    }, 'OPERATION', 'SIMPLE');
  } else {
    // Estrutura normal para outros casos
    // ...
  }
}
```

---

### **5.2 Nginx (Observabilidade e Segurança de Timeout)**

#### **1. Criar log_format com Tempos e Causa de Fechamento**

**Configuração Recomendada:**
```nginx
log_format timed '$remote_addr - $remote_user [$time_local] '
                 '"$request" $status $body_bytes_sent '
                 '"$http_referer" "$http_user_agent" '
                 'rt=$request_time urt=$upstream_response_time '
                 'ua="$upstream_addr"';

access_log /var/log/nginx/access.log timed;
```

**O que isso mostra:**
- `rt=$request_time` - Tempo total de request
- `urt=$upstream_response_time` - Tempo de resposta de upstream (PHP-FPM)
- `ua="$upstream_addr"` - Endereço do upstream

**Benefício:**
- Identificar requisições lentas
- Correlacionar tempo de resposta com erros
- Detectar gargalos no PHP-FPM

---

#### **2. Registrar Erros de Cliente que Fecha Conexão**

**Verificar no error.log:**
```bash
grep -E 'client timed out|client prematurely closed connection' /var/log/nginx/error.log
```

**Se não aparecer nada:**
- Subir nível de log temporariamente:
```nginx
error_log /var/log/nginx/error.log notice;
```

**Benefício:**
- Detectar quando cliente fecha conexão antes de completar
- Identificar padrões de timeout do cliente

---

#### **3. Conferir e Explicitar Timeouts**

**Configuração Recomendada:**
```nginx
location ~ \.php$ {
    fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    
    # Explicitar timeouts
    fastcgi_connect_timeout 60s;
    fastcgi_send_timeout    60s;
    fastcgi_read_timeout    60s;
}
```

**Benefício:**
- Garantir que servidor não corta antes do cliente (que agora terá 60s)
- Alinhar timeouts do servidor com timeout do cliente

---

### **5.3 PHP-FPM**

#### **1. Habilitar slowlog para Pegar Requisições Lentas**

**Configuração Recomendada:**
```ini
; /etc/php/8.3/fpm/pool.d/www.conf
request_slowlog_timeout = 5s
slowlog = /var/log/php8.3-fpm.slow.log
```

**Benefício:**
- Se algum script demorar >5s, vai cair nesse log
- Permite confirmar se há requisições perto de 30s de processamento
- Identificar queries SQL lentas ou operações bloqueantes

---

#### **2. Dimensionar Melhor pm.max_children**

**Situação Atual:**
- RAM total: 3.7 GB
- RAM livre: 3.2 GB (86%)
- `pm.max_children = 10`
- Processos ativos: 8 de 10 (80%)

**Recomendação:**
1. Medir consumo médio de RAM de cada child:
```bash
ps aux | grep 'php-fpm: pool www' | awk '{sum+=$6} END {print sum/NR " KB por processo"}'
```

2. Calcular limite seguro:
- 40-60% da RAM para PHP-FPM
- Exemplo: 3.7 GB * 0.5 = 1.85 GB
- Se cada processo consome ~50 MB: 1.85 GB / 50 MB = ~37 processos

3. Ajustar `pm.max_children`:
```ini
pm.max_children = 20  ; Valor conservador inicial
; ou
pm.max_children = 30  ; Valor mais robusto (se RAM permitir)
```

**Benefício:**
- Evitar fila em horários de pico
- Reduzir rejeições de requisições
- Melhorar capacidade de processamento

---

### **5.4 Rede / Cloudflare / DNS**

#### **1. Ativar e Revisar Logs do Cloudflare**

**O que verificar:**
- Bloqueios de requisições
- Timeouts ou handshakes muito lentos
- Rate limiting ativo
- WAF (Web Application Firewall) bloqueando

**Como verificar:**
- Dashboard do Cloudflare → Analytics → Logs
- Verificar período 13:30-13:31 do dia 26/11
- Procurar por requisições bloqueadas ou com timeout

---

#### **2. Testes de Conectividade Automatizados**

**Script de Teste:**
```bash
#!/bin/bash
# test_connectivity.sh

ENDPOINT="https://prod.bssegurosimediato.com.br/add_webflow_octa.php"
TIMEOUT=120

while true; do
    echo "=== Teste em $(date) ==="
    curl -v "$ENDPOINT" \
         --max-time $TIMEOUT \
         -w "\nTempo total: %{time_total}s\n" \
         -o /dev/null \
         -s 2>&1 | grep -E 'time_total|HTTP|error|timeout'
    sleep 60
done
```

**Benefício:**
- Detectar instabilidades esporádicas
- Medir tempos de resposta reais
- Identificar padrões de latência

---

## 📊 MINHAS CONSIDERAÇÕES SOBRE O RELATÓRIO

### **1. Pontos Onde Estava Correto:**

✅ **Timeout de 30s é o gatilho imediato** - Confirmado pelo especialista  
✅ **Erro é intermitente** - Confirmado pelo especialista  
✅ **Nginx e PHP-FPM não apresentam sinais de exaustão** - Confirmado pelo especialista  
✅ **Erros vêm do JavaScript** - Confirmado pelo especialista  

---

### **2. Pontos Onde Precisei Refinar:**

⚠️ **Simplificação perigosa:** "requisição não chega ao servidor por causa do timeout"
- **Correção:** Tecnicamente, se browser já enviou requisição HTTP, Nginx normalmente loga mesmo que cliente aborte depois
- **Refinamento:** Ausência de log sugere que requisição nunca foi enviada OU handshake não completou

⚠️ **Causa raiz muito simplificada:**
- **Correção:** É um problema "misto" - aplicação (timeout curto) + rede (latência/instabilidade)
- **Refinamento:** Não é apenas "timeout cancela antes de chegar", mas sim "latência faz conexão demorar >30s, timeout cancela antes de completar"

---

### **3. Pontos Adicionais Importantes:**

✅ **Banco de dados:** Para essa ocorrência específica, não entrou no jogo, mas vale revisar em paralelo

✅ **Observabilidade:** Especialista forneceu recomendações práticas muito detalhadas para melhorar observabilidade:
- Logs com tempos no Nginx
- Slowlog do PHP-FPM
- Logs detalhados no JavaScript
- Testes de conectividade

✅ **Dimensionamento:** Especialista forneceu metodologia para dimensionar `pm.max_children` corretamente

---

## 📋 PLANO DE AÇÃO REFINADO

### **Ações Imediatas (Alto Impacto):**

1. ✅ **Aumentar timeout do AbortController para 60s**
   - Arquivo: `MODAL_WHATSAPP_DEFINITIVO.js`
   - Linha: 484
   - Alteração: `30000` → `60000`

2. ✅ **Melhorar logEvent para erros**
   - Passar dados relevantes junto com erro
   - Ou ajustar estrutura quando `severity === 'error'`

3. ✅ **Adicionar logs de tempo de resposta**
   - Medir `requestDurationMs` antes de logar erro
   - Incluir no payload enviado para `log_endpoint.php`

---

### **Ações de Médio Prazo (Observabilidade):**

4. ✅ **Configurar log_format com tempos no Nginx**
   - Adicionar `rt=$request_time` e `urt=$upstream_response_time`
   - Facilitar análise de requisições lentas

5. ✅ **Habilitar slowlog do PHP-FPM**
   - `request_slowlog_timeout = 5s`
   - Identificar requisições que demoram >5s

6. ✅ **Explicitar timeouts no Nginx**
   - `fastcgi_connect_timeout 60s`
   - `fastcgi_send_timeout 60s`
   - `fastcgi_read_timeout 60s`

---

### **Ações de Longo Prazo (Otimização):**

7. ✅ **Dimensionar pm.max_children corretamente**
   - Medir consumo médio de RAM por processo
   - Calcular limite seguro (40-60% da RAM)
   - Ajustar `pm.max_children` para valor mais robusto

8. ✅ **Revisar queries SQL e performance**
   - Verificar índices nas tabelas
   - Medir tempo de resposta médio das queries
   - Otimizar queries lentas

9. ✅ **Monitorar Cloudflare e conectividade**
   - Ativar logs do Cloudflare
   - Implementar testes de conectividade automatizados
   - Identificar padrões de latência

---

## 🎯 CONCLUSÃO FINAL

### **Aprendizados Principais:**

1. ✅ **Técnica importante:** Nginx loga no access.log mesmo que cliente aborte depois de receber requisição
2. ✅ **Ausência de log = Requisição nunca chegou** (handshake não completou ou requisição nunca saiu do cliente)
3. ✅ **Problema é "misto":** Aplicação (timeout curto) + Rede (latência/instabilidade)
4. ✅ **Observabilidade é crítica:** Logs com tempos, slowlog, métricas são essenciais para diagnóstico

### **Recomendações do Especialista são Excelentes:**

- ✅ Práticas e implementáveis
- ✅ Baseadas em experiência real
- ✅ Focadas em observabilidade e prevenção
- ✅ Abrangem todos os aspectos (front, back, infra, rede)

### **Próximos Passos:**

1. Implementar ações imediatas (timeout, logs)
2. Configurar observabilidade (Nginx, PHP-FPM)
3. Monitorar e ajustar (dimensionamento, otimização)

---

**Documento criado em:** 26/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA** - Relatório do especialista analisado e refinamentos documentados

