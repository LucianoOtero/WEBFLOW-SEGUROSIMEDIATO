# 📚 DOCUMENTAÇÃO DA API - SISTEMA DE LOGGING PROFISSIONAL

**Versão:** 1.0.0  
**Data:** 08/11/2025  
**Base URL:** `https://dev.bssegurosimediato.com.br/` (DEV) ou `https://bssegurosimediato.com.br/` (PROD)

---

## 🔐 AUTENTICAÇÃO

Todas as requisições requerem autenticação via API Key no header:

```
X-API-Key: sua-api-key-aqui
```

---

## 📝 ENDPOINT: Inserir Log

### **POST** `/log_endpoint.php`

Insere um novo log no banco de dados.

### **Headers:**
```
Content-Type: application/json
X-API-Key: sua-api-key-aqui
```

### **Body (JSON):**
```json
{
    "level": "DEBUG",
    "category": "UTILS",
    "message": "🔍 Funções de debug disponíveis:",
    "data": null,
    "url": "https://segurosimediato-dev.webflow.io/",
    "session_id": "sess_1762654395625_3vzleofbj",
    "user_id": "user_123",
    "metadata": {
        "custom_field": "value"
    },
    "tags": "debug,utils,test"
}
```

### **Campos:**
- `level` (obrigatório): `DEBUG`, `INFO`, `WARN`, `ERROR`, `FATAL`
- `category` (opcional): Categoria do log (ex: `UTILS`, `MODAL`, `RPA`)
- `message` (obrigatório): Mensagem do log
- `data` (opcional): Dados adicionais (objeto, array ou string)
- `url` (opcional): URL da página
- `session_id` (opcional): ID da sessão
- `user_id` (opcional): ID do usuário
- `metadata` (opcional): Metadados adicionais em JSON
- `tags` (opcional): Tags separadas por vírgula

**Nota:** `file_name`, `line_number`, `function_name` são capturados automaticamente pelo servidor.

### **Resposta de Sucesso (200):**
```json
{
    "success": true,
    "log_id": "log_690ff8bca92660.55421836",
    "request_id": "req_690ff8bca92811.30743769",
    "timestamp": "2025-11-08 23:13:16.692865",
    "inserted": true
}
```

### **Resposta de Erro (400):**
```json
{
    "success": false,
    "error": "Invalid input",
    "details": {
        "level": "Level is required",
        "message": "Message is required"
    }
}
```

---

## 🔍 ENDPOINT: Consultar Logs

### **GET** `/log_query.php`

Consulta logs com filtros avançados.

### **Parâmetros de Query:**
- `start_date` (opcional): Data inicial (formato: `YYYY-MM-DD` ou `YYYY-MM-DD HH:MM:SS`)
- `end_date` (opcional): Data final (formato: `YYYY-MM-DD` ou `YYYY-MM-DD HH:MM:SS`)
- `level` (opcional): Nível do log (`DEBUG`, `INFO`, `WARN`, `ERROR`, `FATAL`)
- `category` (opcional): Categoria do log
- `file_name` (opcional): Nome do arquivo (filtro parcial)
- `line_number` (opcional): Número da linha
- `function_name` (opcional): Nome da função
- `search` (opcional): Busca full-text na mensagem
- `session_id` (opcional): ID da sessão
- `request_id` (opcional): ID da requisição
- `environment` (opcional): Ambiente (`development`, `production`, `staging`)
- `tags` (opcional): Tag para filtrar
- `page` (opcional): Número da página (padrão: 1)
- `limit` (opcional): Itens por página (padrão: 100, máximo: 1000)
- `sort` (opcional): Campo para ordenação (padrão: `timestamp`)
- `order` (opcional): Direção (`ASC` ou `DESC`, padrão: `DESC`)

### **Exemplo de Requisição:**
```
GET /log_query.php?start_date=2025-11-08&end_date=2025-11-09&level=ERROR&page=1&limit=50
```

### **Resposta de Sucesso (200):**
```json
{
    "success": true,
    "data": [
        {
            "id": 12345,
            "log_id": "log_690ff8bca92660.55421836",
            "timestamp": "2025-11-08 23:13:16.692865",
            "client_timestamp": "2025-11-09T02:13:15.661Z",
            "level": "ERROR",
            "category": "MODAL",
            "file_name": "MODAL_WHATSAPP_DEFINITIVO.js",
            "file_path": "/var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js",
            "line_number": 152,
            "function_name": "getEndpointUrl",
            "class_name": null,
            "message": "Erro ao obter endpoint URL",
            "data": {
                "endpoint": "travelangels",
                "error": "APP_BASE_URL não disponível"
            },
            "stack_trace": null,
            "url": "https://segurosimediato-dev.webflow.io/",
            "session_id": "sess_1762654395625_3vzleofbj",
            "user_id": null,
            "ip_address": "191.9.24.241",
            "user_agent": "Mozilla/5.0...",
            "environment": "development",
            "server_name": "webhooks-php-dev",
            "metadata": null,
            "tags": "error,modal,endpoint"
        }
    ],
    "pagination": {
        "page": 1,
        "limit": 50,
        "total": 1234,
        "total_pages": 25
    },
    "filters_applied": {
        "start_date": "2025-11-08",
        "end_date": "2025-11-09",
        "level": "ERROR"
    }
}
```

---

## 📊 ENDPOINT: Estatísticas

### **GET** `/log_statistics.php`

Retorna estatísticas agregadas dos logs.

### **Parâmetros de Query:**
- `start_date` (opcional): Data inicial
- `end_date` (opcional): Data final
- `group_by` (opcional): Agrupar por (`level`, `category`, `file_name`, `day`)
- `environment` (opcional): Ambiente

### **Exemplo de Requisição:**
```
GET /log_statistics.php?start_date=2025-11-08&end_date=2025-11-09&group_by=level
```

### **Resposta de Sucesso (200):**
```json
{
    "success": true,
    "statistics": {
        "total": 12345,
        "by_level": {
            "DEBUG": 8000,
            "INFO": 3000,
            "WARN": 1000,
            "ERROR": 400,
            "FATAL": 45
        },
        "by_category": {
            "UTILS": 5000,
            "MODAL": 3000,
            "RPA": 2000,
            "GCLID": 1500,
            "OTHER": 845
        },
        "top_files": [
            {
                "file_name": "FooterCodeSiteDefinitivoCompleto.js",
                "count": 5000,
                "errors": 200
            },
            {
                "file_name": "MODAL_WHATSAPP_DEFINITIVO.js",
                "count": 3000,
                "errors": 150
            }
        ]
    },
    "period": {
        "start_date": "2025-11-08",
        "end_date": "2025-11-09"
    }
}
```

---

## 📥 ENDPOINT: Exportar Logs

### **GET** `/log_export.php`

Exporta logs em diferentes formatos.

### **Parâmetros de Query:**
- Todos os parâmetros de filtro do `/log_query.php`
- `format` (obrigatório): Formato de exportação (`csv`, `json`, `pdf`)

### **Exemplo de Requisição:**
```
GET /log_export.php?start_date=2025-11-08&level=ERROR&format=csv
```

### **Resposta:**
- **CSV:** Arquivo CSV para download
- **JSON:** JSON array de logs
- **PDF:** Relatório formatado em PDF

---

## ⚠️ CÓDIGOS DE STATUS HTTP

- `200 OK`: Requisição bem-sucedida
- `400 Bad Request`: Dados inválidos
- `401 Unauthorized`: API key inválida ou ausente
- `403 Forbidden`: Acesso negado
- `404 Not Found`: Recurso não encontrado
- `429 Too Many Requests`: Rate limit excedido
- `500 Internal Server Error`: Erro no servidor

---

## 🔒 RATE LIMITING

- **Limite padrão:** 1000 requisições por minuto por IP
- **Limite de inserção:** 100 logs por segundo por IP
- **Headers de resposta:**
  - `X-RateLimit-Limit`: Limite total
  - `X-RateLimit-Remaining`: Requisições restantes
  - `X-RateLimit-Reset`: Timestamp de reset

---

## 📝 EXEMPLOS DE USO

### **JavaScript (Fetch API):**
```javascript
// Inserir log
fetch('https://dev.bssegurosimediato.com.br/log_endpoint.php', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'X-API-Key': 'sua-api-key'
    },
    body: JSON.stringify({
        level: 'INFO',
        category: 'MODAL',
        message: 'Modal aberto com sucesso',
        url: window.location.href,
        session_id: window.sessionId
    })
})
.then(response => response.json())
.then(data => console.log('Log inserido:', data));

// Consultar logs
fetch('https://dev.bssegurosimediato.com.br/log_query.php?level=ERROR&limit=10', {
    headers: {
        'X-API-Key': 'sua-api-key'
    }
})
.then(response => response.json())
.then(data => console.log('Logs:', data));
```

### **PHP (cURL):**
```php
$ch = curl_init('https://dev.bssegurosimediato.com.br/log_endpoint.php');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'X-API-Key: sua-api-key'
]);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
    'level' => 'ERROR',
    'message' => 'Erro ao processar requisição',
    'data' => ['error_code' => 500]
]));

$response = curl_exec($ch);
curl_close($ch);
```

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0.0

