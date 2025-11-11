# 🔍 INVESTIGAÇÃO HTTP 500 - Log Endpoint

**Data:** 09/11/2025  
**Status:** 🔄 **EM INVESTIGAÇÃO**

---

## 📊 SITUAÇÃO ATUAL

- ✅ **HTTP 400:** Corrigido (erros pararam)
- ❌ **HTTP 500:** Persistem (requer investigação)

---

## 🔧 LOGGING DETALHADO IMPLEMENTADO

Foi implementado logging extremamente detalhado no `log_endpoint.php` para capturar exatamente onde os erros HTTP 500 estão ocorrendo.

### **Função de Logging Adicionada:**

```php
function logDebug($message, $data = null) {
    $logData = [
        'timestamp' => date('Y-m-d H:i:s.u'),
        'message' => $message,
        'data' => $data,
        'memory' => memory_get_usage(true),
        'peak_memory' => memory_get_peak_usage(true)
    ];
    error_log("log_endpoint.php [DEBUG]: " . json_encode($logData, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
}
```

### **Pontos de Logging Adicionados:**

1. **Início da Requisição:**
   - Método HTTP
   - IP do cliente
   - User-Agent
   - Content-Type
   - Content-Length

2. **Carregamento do ProfessionalLogger:**
   - Verificação de existência do arquivo
   - Sucesso/falha no carregamento
   - Stack trace em caso de erro

3. **Leitura do Input:**
   - Tamanho do input
   - Preview dos primeiros 200 caracteres
   - Erros de JSON parsing

4. **Validação de JSON:**
   - Level recebido
   - Tamanho da mensagem
   - Chaves presentes no input
   - Erros de validação

5. **Criação do Logger:**
   - Request ID gerado
   - Exceções durante criação
   - Stack trace completo

6. **Chamada logger->log():**
   - Parâmetros passados
   - Log ID retornado
   - Exceções durante execução

7. **Falha na Inserção:**
   - Status da conexão
   - Tentativa de obter conexão
   - Erros durante verificação

8. **Sucesso:**
   - Duração da requisição
   - Uso de memória
   - Log ID gerado

9. **Exceções:**
   - Tipo de exceção
   - Mensagem completa
   - Arquivo e linha
   - Stack trace completo
   - Código de erro
   - Exceção anterior (se houver)

---

## 📋 COMO VERIFICAR OS LOGS

### **1. Ver logs em tempo real:**

```bash
ssh root@65.108.156.14
docker exec webhooks-php-dev tail -f /var/log/php/error.log | grep "log_endpoint.php \[DEBUG\]"
```

### **2. Ver últimos erros HTTP 500:**

```bash
ssh root@65.108.156.14
docker exec webhooks-php-dev tail -100 /var/log/php/error.log | grep -A 10 "log_endpoint.php \[DEBUG\]" | tail -50
```

### **3. Filtrar por request ID:**

Quando um erro HTTP 500 ocorrer, o console do navegador mostrará o erro. Use o request ID (se disponível) para rastrear no log:

```bash
docker exec webhooks-php-dev grep "req_[ID_AQUI]" /var/log/php/error.log
```

---

## 🔍 PONTOS DE INVESTIGAÇÃO

Com base nos logs detalhados, verificar:

1. **Onde o erro está ocorrendo:**
   - Durante carregamento do ProfessionalLogger?
   - Durante criação da instância?
   - Durante chamada de logger->log()?
   - Durante inserção no banco?

2. **Qual é o erro específico:**
   - PDOException?
   - Outra Exception?
   - Fatal Error?
   - Warning convertido em erro?

3. **Status da conexão:**
   - Conexão estabelecida?
   - Conexão perdida?
   - Timeout?
   - Credenciais incorretas?

4. **Dados recebidos:**
   - JSON válido?
   - Campos obrigatórios presentes?
   - Tamanho do input?

---

## 📝 PRÓXIMOS PASSOS

1. ✅ **Logging detalhado implementado**
2. ⏳ **Aguardar ocorrência de HTTP 500**
3. ⏳ **Analisar logs detalhados**
4. ⏳ **Identificar causa raiz**
5. ⏳ **Implementar correção**

---

## 🎯 INFORMAÇÕES PARA COLETA

Quando um HTTP 500 ocorrer, coletar:

1. **Timestamp exato do erro**
2. **Request ID (se disponível no console)**
3. **Última mensagem de log antes do erro**
4. **Stack trace completo**
5. **Tipo de exceção**
6. **Status da conexão com banco**

---

**Documento criado em:** 09/11/2025  
**Última atualização:** 09/11/2025  
**Status:** 🔄 **AGUARDANDO DADOS DOS LOGS**

