# 🔧 PROJETO: Tabela de Dados Capturados do Modal WhatsApp

**Data de Criação:** 25/11/2025  
**Última Atualização:** 25/11/2025  
**Status:** 📋 **PROJETO APRIMORADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.1.0  
**Ambiente:** Development e Production

---

## 🎯 OBJETIVO DO PROJETO

Criar um sistema para armazenar e consultar os dados capturados pelo modal WhatsApp, permitindo análise histórica e rastreamento de interações dos usuários.

### **Objetivos Específicos:**

1. ✅ Criar tabela no banco de dados para armazenar dados do modal
2. ✅ Criar função PHP para inserir dados na tabela
3. ✅ Modificar `coletarTodosDados()` para chamar função de inserção
4. ✅ Criar script PHP para consultar dados localmente no Windows

---

## 📊 ANÁLISE DA SITUAÇÃO ATUAL

### **1. Função `coletarTodosDados()`**

**Localização:** `MODAL_WHATSAPP_DEFINITIVO.js` (linha 560)

**Dados Capturados:**
- `DDD` - DDD do telefone
- `CELULAR` - Número do celular
- `CPF` - CPF do usuário
- `NOME` - Nome completo
- `EMAIL` - Email (gerado automaticamente se vazio)
- `CEP` - CEP do endereço
- `PLACA` - Placa do veículo
- `ENDERECO` - Endereço completo
- `GCLID` - Google Click ID (do cookie)

**Dados Adicionais Necessários:**
- `timestamp` - Data/hora da captura (servidor)
- `session_id` - ID da sessão do usuário

### **2. Sistema de Sessão Atual**

**Localização:** `FooterCodeSiteDefinitivoCompleto.js` (linha 1001-1004)

**Código:**
```javascript
if (!window.sessionId) {
  window.sessionId = 'sess_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
}
```

**Disponibilidade:** `window.sessionId` está disponível globalmente

### **3. Banco de Dados Atual**

**Ambiente DEV:** `rpa_logs_dev`  
**Ambiente PROD:** `rpa_logs_prod`  
**Conexão:** Via `ProfessionalLogger.php` usando variáveis de ambiente

**Variáveis de Ambiente:**
- `LOG_DB_HOST` - Host do MySQL
- `LOG_DB_NAME` - Nome do banco (`rpa_logs_dev` ou `rpa_logs_prod`)
- `LOG_DB_USER` - Usuário do MySQL
- `LOG_DB_PASS` - Senha do MySQL
- `LOG_DB_PORT` - Porta do MySQL (padrão: 3306)

---

## 💡 ABORDAGEM SIMPLIFICADA

### **Opção 1: Usar Sistema de Logging Existente (RECOMENDADO)**

**Vantagens:**
- ✅ Não precisa criar endpoint PHP separado
- ✅ Usa infraestrutura existente (`log_endpoint.php`)
- ✅ Função JavaScript simples que chama `window.novo_log()`
- ✅ Dados salvos na tabela `application_logs` (já existe)

**Desvantagens:**
- ⚠️ Dados ficam na tabela `application_logs` (não em tabela específica)
- ⚠️ Consulta precisa filtrar por categoria/level

**Implementação:**
```javascript
// Ao final de coletarTodosDados():
const dadosColetados = {
  // ... dados já coletados ...
  session_id: window.sessionId || null,
  timestamp: new Date().toISOString()
};

// Usar sistema de logging existente
if (window.novo_log) {
  window.novo_log('INFO', 'MODAL_DATA', 'Dados capturados do modal', dadosColetados, 'DATA_CAPTURE', 'SIMPLE');
}
```

---

### **Opção 2: Criar Endpoint PHP Específico (ORIGINAL)**

**Vantagens:**
- ✅ Tabela específica `modal_data` (dados organizados)
- ✅ Consulta mais simples e direta
- ✅ Estrutura otimizada para os dados do modal

**Desvantagens:**
- ⚠️ Precisa criar endpoint PHP separado
- ⚠️ Mais código para manter

---

## 📁 ARQUIVOS A CRIAR/MODIFICAR

### **FASE 1: Criar Tabela no Banco de Dados**

#### **1.1. Script SQL para Criar Tabela**

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabela_modal_data_dev.sql`  
**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabela_modal_data_prod.sql`

**Estrutura da Tabela:**
```sql
CREATE TABLE IF NOT EXISTS modal_data (
    telefone VARCHAR(25) NOT NULL PRIMARY KEY COMMENT 'Telefone completo (DDD + CELULAR) - CHAVE PRIMÁRIA',
    session_id VARCHAR(64) NOT NULL COMMENT 'ID da sessão do usuário',
    timestamp DATETIME(6) NOT NULL COMMENT 'Timestamp da captura (precisão microsegundos)',
    ddd VARCHAR(3) NULL COMMENT 'DDD do telefone',
    celular VARCHAR(20) NULL COMMENT 'Número do celular',
    cpf VARCHAR(14) NULL COMMENT 'CPF do usuário',
    nome VARCHAR(255) NULL COMMENT 'Nome completo',
    email VARCHAR(255) NULL COMMENT 'Email do usuário',
    cep VARCHAR(10) NULL COMMENT 'CEP do endereço',
    placa VARCHAR(10) NULL COMMENT 'Placa do veículo',
    endereco VARCHAR(500) NULL COMMENT 'Endereço completo',
    gclid VARCHAR(255) NULL COMMENT 'Google Click ID',
    url TEXT NULL COMMENT 'URL da página onde o modal foi aberto',
    ip_address VARCHAR(45) NULL COMMENT 'IP do cliente',
    user_agent TEXT NULL COMMENT 'User agent do navegador',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação do registro',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de última atualização',
    
    -- Índices para performance
    INDEX idx_session_id (session_id),
    INDEX idx_timestamp (timestamp),
    INDEX idx_cpf (cpf),
    INDEX idx_email (email),
    INDEX idx_created_at (created_at),
    INDEX idx_updated_at (updated_at),
    INDEX idx_session_timestamp (session_id, timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Características:**
- ✅ **Chave Primária:** `telefone` é a chave primária (única por telefone)
- ✅ **Atualização Automática:** Se telefone já existir, registro é atualizado (não duplicado)
- ✅ Campos NULL permitidos (exceto telefone, session_id, timestamp)
- ✅ Índices otimizados para consultas por sessão, timestamp, CPF, email
- ✅ Timestamp com precisão de microsegundos
- ✅ Campos adicionais para contexto (URL, IP, user agent)
- ✅ `updated_at` rastreia última atualização do registro

---

### **FASE 2: Criar Função PHP para Inserir Dados**

#### **2.1. Arquivo PHP: `save_modal_data_endpoint.php`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/save_modal_data_endpoint.php`  
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/save_modal_data_endpoint.php`

**Funcionalidades:**
- ✅ Receber dados via POST JSON
- ✅ Validar dados recebidos (telefone obrigatório)
- ✅ **Inserir ou atualizar** dados na tabela `modal_data` (INSERT ... ON DUPLICATE KEY UPDATE)
- ✅ Retornar resposta JSON com sucesso/erro e indicador se foi inserção ou atualização
- ✅ Usar variáveis de ambiente para conexão com banco
- ✅ Tratamento de erros completo
- ✅ CORS configurado

**Estrutura Completa:**
```php
<?php
require_once __DIR__ . '/config.php';
setCorsHeaders();
header('Content-Type: application/json; charset=utf-8');

// Validar método POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Method not allowed']);
    exit;
}

try {
    // Ler dados do POST
    $rawInput = file_get_contents('php://input');
    $data = json_decode($rawInput, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('JSON inválido: ' . json_last_error_msg());
    }
    
    // Validar dados obrigatórios
    if (empty($data['telefone'])) {
        throw new Exception('Telefone é obrigatório');
    }
    if (empty($data['session_id'])) {
        throw new Exception('session_id é obrigatório');
    }
    if (empty($data['timestamp'])) {
        throw new Exception('timestamp é obrigatório');
    }
    
    // Validar e sanitizar telefone (apenas números)
    $telefone = preg_replace('/[^0-9]/', '', $data['telefone']);
    if (strlen($telefone) < 10 || strlen($telefone) > 11) {
        throw new Exception('Telefone inválido. Deve ter 10 ou 11 dígitos');
    }
    
    // Conectar ao banco de dados
    $host = $_ENV['LOG_DB_HOST'] ?? 'localhost';
    $dbname = $_ENV['LOG_DB_NAME'] ?? 'rpa_logs_dev';
    $user = $_ENV['LOG_DB_USER'] ?? 'rpa_logger_dev';
    $pass = $_ENV['LOG_DB_PASS'] ?? '';
    $port = $_ENV['LOG_DB_PORT'] ?? 3306;
    
    $pdo = new PDO(
        "mysql:host={$host};port={$port};dbname={$dbname};charset=utf8mb4",
        $user,
        $pass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
    );
    
    // Verificar se registro já existe (para detectar inserção vs atualização)
    $stmtCheck = $pdo->prepare("SELECT telefone FROM modal_data WHERE telefone = :telefone");
    $stmtCheck->execute(['telefone' => $telefone]);
    $exists = $stmtCheck->fetch() !== false;
    
    // Preparar INSERT ... ON DUPLICATE KEY UPDATE
    $sql = "INSERT INTO modal_data (
        telefone, session_id, timestamp, ddd, celular, cpf, nome, email,
        cep, placa, endereco, gclid, url, ip_address, user_agent
    ) VALUES (
        :telefone, :session_id, :timestamp, :ddd, :celular, :cpf, :nome, :email,
        :cep, :placa, :endereco, :gclid, :url, :ip_address, :user_agent
    )
    ON DUPLICATE KEY UPDATE
        session_id = VALUES(session_id),
        timestamp = VALUES(timestamp),
        ddd = VALUES(ddd),
        celular = VALUES(celular),
        cpf = VALUES(cpf),
        nome = VALUES(nome),
        email = VALUES(email),
        cep = VALUES(cep),
        placa = VALUES(placa),
        endereco = VALUES(endereco),
        gclid = VALUES(gclid),
        url = VALUES(url),
        ip_address = VALUES(ip_address),
        user_agent = VALUES(user_agent),
        updated_at = CURRENT_TIMESTAMP";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        'telefone' => $telefone,
        'session_id' => $data['session_id'],
        'timestamp' => $data['timestamp'],
        'ddd' => $data['ddd'] ?? null,
        'celular' => $data['celular'] ?? null,
        'cpf' => $data['cpf'] ?? null,
        'nome' => $data['nome'] ?? null,
        'email' => $data['email'] ?? null,
        'cep' => $data['cep'] ?? null,
        'placa' => $data['placa'] ?? null,
        'endereco' => $data['endereco'] ?? null,
        'gclid' => $data['gclid'] ?? null,
        'url' => $data['url'] ?? null,
        'ip_address' => $data['ip_address'] ?? $_SERVER['REMOTE_ADDR'] ?? null,
        'user_agent' => $data['user_agent'] ?? $_SERVER['HTTP_USER_AGENT'] ?? null
    ]);
    
    // Determinar ação (inserção ou atualização)
    $action = $exists ? 'updated' : 'inserted';
    
    // Retornar resposta JSON
    echo json_encode([
        'success' => true,
        'action' => $action,
        'telefone' => $telefone,
        'message' => $action === 'inserted' ? 'Dados inseridos com sucesso' : 'Dados atualizados com sucesso'
    ]);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Erro ao salvar dados: ' . $e->getMessage(),
        'code' => 'DB_ERROR'
    ]);
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'code' => 'VALIDATION_ERROR'
    ]);
}
?>
```

**Query SQL (INSERT ... ON DUPLICATE KEY UPDATE):**
```sql
INSERT INTO modal_data (
    telefone, session_id, timestamp, ddd, celular, cpf, nome, email, 
    cep, placa, endereco, gclid, url, ip_address, user_agent
) VALUES (
    :telefone, :session_id, :timestamp, :ddd, :celular, :cpf, :nome, :email,
    :cep, :placa, :endereco, :gclid, :url, :ip_address, :user_agent
)
ON DUPLICATE KEY UPDATE
    session_id = VALUES(session_id),
    timestamp = VALUES(timestamp),
    ddd = VALUES(ddd),
    celular = VALUES(celular),
    cpf = VALUES(cpf),
    nome = VALUES(nome),
    email = VALUES(email),
    cep = VALUES(cep),
    placa = VALUES(placa),
    endereco = VALUES(endereco),
    gclid = VALUES(gclid),
    url = VALUES(url),
    ip_address = VALUES(ip_address),
    user_agent = VALUES(user_agent),
    updated_at = CURRENT_TIMESTAMP;
```

**Comportamento:**
- ✅ Se telefone **não existir:** Insere novo registro
- ✅ Se telefone **já existir:** Atualiza registro existente
- ✅ `created_at` mantém data original (não é atualizado)
- ✅ `updated_at` é atualizado automaticamente quando registro é modificado

---

### **FASE 3: Modificar Função `coletarTodosDados()`**

#### **3.1. Arquivo: `MODAL_WHATSAPP_DEFINITIVO.js`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`  
**Localização:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/MODAL_WHATSAPP_DEFINITIVO.js`

**Alteração:**
- ✅ Adicionar chamada à função de inserção no final de `coletarTodosDados()`
- ✅ Capturar `session_id` de `window.sessionId`
- ✅ Capturar `timestamp` do servidor (via fetch ou usar timestamp do cliente)
- ✅ Enviar dados via POST para `save_modal_data_endpoint.php`
- ✅ Tratamento de erro silencioso (não quebrar fluxo se inserção falhar)

**Código a Adicionar:**
```javascript
// Ao final de coletarTodosDados(), antes do return:
const dadosColetados = {
  // ... dados já coletados ...
  session_id: window.sessionId || null,
  timestamp: new Date().toISOString()
};

// Validar que telefone existe antes de salvar
if (dadosColetados.TELEFONE && dadosColetados.TELEFONE.trim() !== '') {
  // Chamar função de inserção/atualização (assíncrono, não bloqueia)
  salvarDadosModal(dadosColetados).catch(() => {
    // Silenciosamente ignorar erros (não quebrar fluxo)
  });
}
```

**Nova Função:**
```javascript
async function salvarDadosModal(dados) {
  try {
    // Validar telefone obrigatório
    const telefone = dados.TELEFONE || (dados.ddd && dados.celular ? dados.ddd + dados.celular : null);
    if (!telefone || telefone.trim() === '') {
      throw new Error('Telefone é obrigatório');
    }
    
    // Preparar dados para envio
    const dadosEnvio = {
      telefone: telefone.replace(/\D/g, ''), // Apenas números
      session_id: dados.session_id || window.sessionId || null,
      timestamp: dados.timestamp || new Date().toISOString(),
      ddd: dados.DDD || dados.ddd || null,
      celular: dados.CELULAR || dados.celular || null,
      cpf: dados.CPF || dados.cpf || null,
      nome: dados.NOME || dados.nome || null,
      email: dados.EMAIL || dados.email || null,
      cep: dados.CEP || dados.cep || null,
      placa: dados.PLACA || dados.placa || null,
      endereco: dados.ENDERECO || dados.endereco || null,
      gclid: dados.GCLID || dados.gclid || null,
      url: window.location.href || null,
      ip_address: null, // Será capturado no servidor
      user_agent: navigator.userAgent || null
    };
    
    const endpoint = window.APP_BASE_URL + '/save_modal_data_endpoint.php';
    const response = await fetch(endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(dadosEnvio),
      mode: 'cors',
      credentials: 'omit'
    });
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    
    const result = await response.json();
    if (!result.success) {
      throw new Error(result.error || 'Erro desconhecido');
    }
    
    // Log sucesso (opcional, apenas para debug)
    if (window.novo_log && result.action) {
      window.novo_log('INFO', 'MODAL', `Dados do modal ${result.action === 'inserted' ? 'inseridos' : 'atualizados'}`, { telefone: result.telefone, action: result.action }, 'DATA_FLOW', 'SIMPLE');
    }
    
    return result;
  } catch (error) {
    // Log silencioso (não quebrar aplicação)
    if (window.novo_log) {
      window.novo_log('WARN', 'MODAL', 'Falha ao salvar dados do modal', { error: error.message }, 'DATA_FLOW', 'SIMPLE');
    }
    throw error;
  }
}
```

---

### **FASE 4: Criar Script PHP para Consulta Local (Windows)**

#### **4.1. Arquivo: `consultar_dados_modal.php`**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/consultar_dados_modal.php`

**Funcionalidades:**
- ✅ Conectar ao banco de dados usando variáveis de ambiente ou configuração local
- ✅ Permitir seleção de período por timestamp
- ✅ Exibir dados em formato legível (tabela HTML ou JSON)
- ✅ Opção de exportar para CSV
- ✅ Filtros adicionais (session_id, telefone, CPF, email)

**Características:**
- ✅ Rodar localmente no Windows (via PHP CLI ou servidor local)
- ✅ Configuração via arquivo de configuração ou variáveis de ambiente
- ✅ Interface simples (HTML ou JSON)
- ✅ Suporte a parâmetros via linha de comando ou formulário HTML

**Estrutura:**
```php
<?php
// Configuração de conexão
// Função para conectar ao banco
// Função para consultar dados
// Função para formatar saída (HTML/JSON/CSV)
// Interface de linha de comando ou HTML
?>
```

---

## 🔧 ESPECIFICAÇÕES TÉCNICAS

### **1. Estrutura da Tabela `modal_data`**

**Campos:**
| Campo | Tipo | Descrição |
|-------|------|-----------|
| `telefone` | VARCHAR(25) | **CHAVE PRIMÁRIA** - Telefone completo (DDD + CELULAR) - OBRIGATÓRIO |
| `session_id` | VARCHAR(64) | ID da sessão (obrigatório) |
| `timestamp` | DATETIME(6) | Timestamp da captura (obrigatório) |
| `ddd` | VARCHAR(3) | DDD do telefone |
| `celular` | VARCHAR(20) | Número do celular |
| `cpf` | VARCHAR(14) | CPF do usuário |
| `nome` | VARCHAR(255) | Nome completo |
| `email` | VARCHAR(255) | Email do usuário |
| `cep` | VARCHAR(10) | CEP do endereço |
| `placa` | VARCHAR(10) | Placa do veículo |
| `endereco` | VARCHAR(500) | Endereço completo |
| `gclid` | VARCHAR(255) | Google Click ID |
| `url` | TEXT | URL da página |
| `ip_address` | VARCHAR(45) | IP do cliente |
| `user_agent` | TEXT | User agent do navegador |
| `created_at` | TIMESTAMP | Data de criação (auto) |
| `updated_at` | TIMESTAMP | Data de última atualização (auto) |

**Índices:**
- **PRIMARY KEY:** `telefone` - Chave primária (única por telefone)
- `idx_session_id` - Consultas por sessão
- `idx_timestamp` - Consultas por período
- `idx_cpf` - Consultas por CPF
- `idx_email` - Consultas por email
- `idx_created_at` - Consultas por data de criação
- `idx_updated_at` - Consultas por data de atualização
- `idx_session_timestamp` - Consultas combinadas (sessão + período)

**Comportamento de Inserção:**
- ✅ **INSERT ... ON DUPLICATE KEY UPDATE:** Se telefone já existir, atualiza registro existente
- ✅ **Campos atualizados:** Todos os campos (exceto `created_at` que mantém data original)
- ✅ **`updated_at`:** Atualizado automaticamente quando registro é modificado

---

### **2. Endpoint `save_modal_data_endpoint.php`**

**Método:** POST  
**Content-Type:** application/json

**Payload de Entrada:**
```json
{
  "session_id": "sess_1234567890_abc123",
  "timestamp": "2025-11-25T12:56:29.225Z",
  "ddd": "11",
  "celular": "987654321",
  "cpf": "123.456.789-00",
  "nome": "João Silva",
  "email": "joao@example.com",
  "cep": "01234-567",
  "placa": "ABC1234",
  "endereco": "Rua Exemplo, 123",
  "gclid": "EAIaIQobChMI..."
}
```

**Resposta de Sucesso (Inserção):**
```json
{
  "success": true,
  "action": "inserted",
  "telefone": "11987654321",
  "message": "Dados inseridos com sucesso"
}
```

**Resposta de Sucesso (Atualização):**
```json
{
  "success": true,
  "action": "updated",
  "telefone": "11987654321",
  "message": "Dados atualizados com sucesso"
}
```

**Resposta de Erro:**
```json
{
  "success": false,
  "error": "Mensagem de erro",
  "code": "ERROR_CODE"
}
```

**Validações:**
- ✅ **`telefone` obrigatório** (chave primária)
- ✅ `session_id` obrigatório
- ✅ `timestamp` obrigatório
- ✅ Validar formato de telefone (DDD + CELULAR, apenas números)
- ✅ Validar formato de email (se fornecido)
- ✅ Validar formato de CPF (se fornecido)
- ✅ Validar formato de CEP (se fornecido)
- ✅ Sanitizar dados antes de inserir/atualizar
- ✅ Garantir que telefone não está vazio ou nulo

---

### **3. Função JavaScript `salvarDadosModal()`**

**Localização:** `MODAL_WHATSAPP_DEFINITIVO.js`

**Características:**
- ✅ Assíncrona (não bloqueia execução)
- ✅ Tratamento de erro silencioso
- ✅ Usa `window.APP_BASE_URL` para construir endpoint
- ✅ Log de erro via `window.novo_log` (se disponível)
- ✅ Não quebra aplicação se falhar

**Fluxo:**
1. Validar que telefone existe e não está vazio
2. Validar que `window.APP_BASE_URL` está disponível
3. Preparar dados (sanitizar telefone - apenas números)
4. Construir endpoint: `APP_BASE_URL + '/save_modal_data_endpoint.php'`
5. Fazer fetch POST com dados
6. Verificar resposta
7. Logar sucesso/erro (se `window.novo_log` disponível)
8. Indicar se foi inserção ou atualização

---

### **4. Script de Consulta `consultar_dados_modal.php`**

**Modo de Uso:**

**A. Via Linha de Comando:**
```bash
php consultar_dados_modal.php --start "2025-11-25 00:00:00" --end "2025-11-25 23:59:59" --format json
```

**B. Via Navegador (HTML):**
```
http://localhost/consultar_dados_modal.php?start=2025-11-25%2000:00:00&end=2025-11-25%2023:59:59&format=html
```

**Parâmetros:**
- `--start` ou `?start=` - Data/hora inicial (formato: YYYY-MM-DD HH:MM:SS)
- `--end` ou `?end=` - Data/hora final (formato: YYYY-MM-DD HH:MM:SS)
- `--format` ou `?format=` - Formato de saída: `json`, `html`, `csv` (padrão: `html`)
- `--session_id` ou `?session_id=` - Filtrar por session_id (opcional)
- `--telefone` ou `?telefone=` - Filtrar por telefone (opcional)
- `--cpf` ou `?cpf=` - Filtrar por CPF (opcional)

**Formato de Saída:**

**JSON:**
```json
{
  "success": true,
  "count": 10,
  "data": [
    {
      "telefone": "11987654321",
      "session_id": "sess_1234567890_abc123",
      "timestamp": "2025-11-25 12:56:29.225000",
      "ddd": "11",
      "celular": "987654321",
      "cpf": "123.456.789-00",
      "nome": "João Silva",
      "email": "joao@example.com",
      "cep": "01234-567",
      "placa": "ABC1234",
      "endereco": "Rua Exemplo, 123",
      "gclid": "EAIaIQobChMI...",
      "url": "https://prod.bssegurosimediato.com.br/",
      "created_at": "2025-11-25 12:56:29",
      "updated_at": "2025-11-25 15:30:45"
    }
  ]
}
```

**HTML:**
- Tabela formatada com todos os dados
- Filtros de pesquisa
- Paginação (se muitos resultados)
- Exportação para CSV

**CSV:**
- Arquivo CSV para download
- Cabeçalhos: telefone, session_id, timestamp, ddd, celular, cpf, nome, email, cep, placa, endereco, gclid, url, created_at, updated_at

---

## 📋 FASES DO PROJETO

### **FASE 1: Criar Tabela no Banco de Dados** ⏱️ 15 minutos

**Objetivo:** Criar estrutura da tabela `modal_data` nos bancos DEV e PROD

**Tarefas:**
1. ✅ Criar script SQL para DEV: `criar_tabela_modal_data_dev.sql`
2. ✅ Criar script SQL para PROD: `criar_tabela_modal_data_prod.sql`
3. ✅ Executar script no banco DEV
4. ✅ Executar script no banco PROD
5. ✅ Verificar criação da tabela

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabela_modal_data_dev.sql`
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabela_modal_data_prod.sql`

---

### **FASE 2: Implementar Salvamento de Dados** ⏱️ 10 minutos (Opção 1) ou 30 minutos (Opção 2)

#### **OPÇÃO 1: Usar Sistema de Logging Existente (RECOMENDADO)**

**Objetivo:** Usar `window.novo_log()` para salvar dados na tabela `application_logs`

**Tarefas:**
1. ✅ Modificar `coletarTodosDados()` para chamar `window.novo_log()` ao final
2. ✅ Passar dados como objeto no campo `data`
3. ✅ Usar categoria `MODAL_DATA` para facilitar consultas
4. ✅ Testar em DEV
5. ✅ Copiar para PROD

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`
- `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/MODAL_WHATSAPP_DEFINITIVO.js`

**Vantagem:** Não precisa criar endpoint PHP separado!

---

#### **OPÇÃO 2: Criar Endpoint PHP Específico**

**Objetivo:** Criar endpoint que recebe dados do modal e insere ou atualiza na tabela `modal_data`

**Tarefas:**
1. ✅ Criar arquivo `save_modal_data_endpoint.php` em DEV
2. ✅ Implementar validação de dados (telefone obrigatório)
3. ✅ Implementar conexão com banco
4. ✅ Implementar **INSERT ... ON DUPLICATE KEY UPDATE** na tabela `modal_data`
5. ✅ Detectar se foi inserção ou atualização
6. ✅ Retornar indicador de ação (inserted/updated)
7. ✅ Implementar tratamento de erros
8. ✅ Testar endpoint localmente
9. ✅ Copiar para PROD

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/save_modal_data_endpoint.php`
- `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/save_modal_data_endpoint.php`

---

### **FASE 3: Modificar Função `coletarTodosDados()`** ⏱️ 10 minutos (Opção 1) ou 20 minutos (Opção 2)

**Objetivo:** Adicionar chamada para salvar dados após coleta

#### **OPÇÃO 1: Usar Sistema de Logging Existente**

**Tarefas:**
1. ✅ Modificar `coletarTodosDados()` para chamar `window.novo_log()` ao final
2. ✅ Passar dados coletados como objeto no campo `data`
3. ✅ Usar categoria `MODAL_DATA` e level `INFO`
4. ✅ Testar em ambiente DEV
5. ✅ Copiar para PROD

**Código:**
```javascript
// Ao final de coletarTodosDados(), antes do return:
const dadosColetados = {
  // ... dados já coletados ...
  session_id: window.sessionId || null,
  timestamp: new Date().toISOString()
};

// Salvar usando sistema de logging existente
if (window.novo_log) {
  window.novo_log('INFO', 'MODAL_DATA', 'Dados capturados do modal WhatsApp', dadosColetados, 'DATA_CAPTURE', 'SIMPLE');
}
```

---

#### **OPÇÃO 2: Criar Função JavaScript com Endpoint Separado**

**Tarefas:**
1. ✅ Criar função `salvarDadosModal()` em `MODAL_WHATSAPP_DEFINITIVO.js`
2. ✅ Modificar `coletarTodosDados()` para chamar função de salvamento
3. ✅ Adicionar captura de `session_id` e `timestamp`
4. ✅ Testar em ambiente DEV
5. ✅ Copiar para PROD

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`
- `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/MODAL_WHATSAPP_DEFINITIVO.js`

---

### **FASE 4: Criar Script de Consulta Local** ⏱️ 45 minutos

**Objetivo:** Criar script PHP para consultar dados localmente no Windows

**Tarefas:**
1. ✅ Criar arquivo `consultar_dados_modal.php`
2. ✅ Implementar conexão com banco (configurável)
3. ✅ Implementar consulta por período
4. ✅ Implementar filtros adicionais
5. ✅ Implementar formatos de saída (JSON, HTML, CSV)
6. ✅ Criar interface HTML (opcional)
7. ✅ Testar localmente

**Arquivos:**
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/consultar_dados_modal.php`

---

## ⚠️ CONSIDERAÇÕES IMPORTANTES

### **1. Segurança**

- ✅ **Sanitização:** Todos os dados devem ser sanitizados antes de inserir/atualizar
- ✅ **Validação:** Validar formato de dados (telefone obrigatório, email, CPF, CEP)
- ✅ **CORS:** Configurar CORS corretamente no endpoint
- ✅ **Rate Limiting:** Considerar rate limiting para evitar spam
- ✅ **SQL Injection:** Usar prepared statements sempre
- ✅ **Chave Primária:** Telefone como chave primária garante unicidade e previne duplicatas

### **2. Performance**

- ✅ **Assíncrono:** Inserção não deve bloquear execução do modal
- ✅ **Índices:** Índices otimizados para consultas frequentes
- ✅ **Timeout:** Timeout curto para requisição de inserção (não afetar UX)

### **3. Confiabilidade**

- ✅ **Tratamento de Erro:** Erros não devem quebrar aplicação
- ✅ **Logging:** Logar erros de inserção (via `window.novo_log`)
- ✅ **Fallback:** Continuar funcionamento mesmo se inserção falhar

### **4. Privacidade e LGPD**

- ⚠️ **Dados Sensíveis:** CPF, telefone, email são dados sensíveis
- ⚠️ **Armazenamento:** Considerar políticas de retenção de dados
- ⚠️ **Acesso:** Restringir acesso à tabela e scripts de consulta
- ⚠️ **Criptografia:** Considerar criptografia de dados sensíveis (futuro)

---

## 📊 RESUMO DAS ALTERAÇÕES

### **Arquivos a Criar:**
1. ✅ `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabela_modal_data_dev.sql`
2. ✅ `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/criar_tabela_modal_data_prod.sql`
3. ✅ `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/save_modal_data_endpoint.php`
4. ✅ `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/save_modal_data_endpoint.php`
5. ✅ `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/consultar_dados_modal.php`

### **Arquivos a Modificar:**
1. ✅ `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/MODAL_WHATSAPP_DEFINITIVO.js`
2. ✅ `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/MODAL_WHATSAPP_DEFINITIVO.js`

### **Banco de Dados:**
1. ✅ Criar tabela `modal_data` no banco `rpa_logs_dev`
2. ✅ Criar tabela `modal_data` no banco `rpa_logs_prod`

---

## ⏱️ TEMPO ESTIMADO TOTAL

### **OPÇÃO 1: Usar Sistema de Logging Existente (RECOMENDADO)**

**Total:** ~70 minutos (1h 10min)

- FASE 1: 15 minutos (criar tabela `modal_data` - opcional, pode usar `application_logs`)
- FASE 2: 10 minutos (modificar JavaScript)
- FASE 3: 10 minutos (modificar `coletarTodosDados()`)
- FASE 4: 45 minutos (script de consulta)

**Vantagem:** Mais rápido, usa infraestrutura existente!

---

### **OPÇÃO 2: Criar Endpoint PHP Específico**

**Total:** ~110 minutos (1h 50min)

- FASE 1: 15 minutos
- FASE 2: 30 minutos
- FASE 3: 20 minutos
- FASE 4: 45 minutos

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **FASE 1: Tabela**
- [ ] Criar script SQL para DEV
- [ ] Criar script SQL para PROD
- [ ] Executar script no banco DEV
- [ ] Executar script no banco PROD
- [ ] Verificar criação da tabela

### **FASE 2: Salvamento de Dados**

**OPÇÃO 1 (Recomendado):**
- [ ] Modificar `coletarTodosDados()` para chamar `window.novo_log()`
- [ ] Testar em DEV
- [ ] Copiar para PROD

**OPÇÃO 2:**
- [ ] Criar arquivo `save_modal_data_endpoint.php` em DEV
- [ ] Implementar validação (telefone obrigatório)
- [ ] Implementar conexão com banco
- [ ] Implementar INSERT ... ON DUPLICATE KEY UPDATE
- [ ] Implementar detecção de inserção vs atualização
- [ ] Testar endpoint (inserção e atualização)
- [ ] Copiar para PROD

### **FASE 3: JavaScript**

**OPÇÃO 1 (Recomendado):**
- [ ] Adicionar chamada `window.novo_log()` ao final de `coletarTodosDados()` em DEV
- [ ] Testar em DEV
- [ ] Copiar para PROD

**OPÇÃO 2:**
- [ ] Criar função `salvarDadosModal()` em DEV
- [ ] Modificar `coletarTodosDados()` em DEV
- [ ] Testar em DEV
- [ ] Copiar para PROD

### **FASE 4: Consulta**
- [ ] Criar `consultar_dados_modal.php`
- [ ] Implementar conexão configurável
- [ ] Implementar consulta por período
- [ ] Implementar formatos de saída
- [ ] Testar localmente

---

---

## 📝 HISTÓRICO DE VERSÕES

### **Versão 1.1.0 (25/11/2025)**
- ✅ Alterada chave primária de `id` (auto-increment) para `telefone`
- ✅ Implementado INSERT ... ON DUPLICATE KEY UPDATE (atualiza se telefone duplicado)
- ✅ Adicionado campo `updated_at` para rastrear atualizações
- ✅ Validação de telefone obrigatório
- ✅ Resposta indica se foi inserção ou atualização

### **Versão 1.0.0 (25/11/2025)**
- ✅ Criação inicial do projeto
- ✅ Definição de estrutura da tabela
- ✅ Especificações técnicas

---

## ⚠️ CONSIDERAÇÕES IMPORTANTES - ATUALIZAÇÃO

### **1. Chave Primária: Telefone**

**Vantagens:**
- ✅ **Único por telefone:** Garante que cada telefone tenha apenas um registro
- ✅ **Atualização automática:** Registros duplicados são atualizados automaticamente
- ✅ **Consulta direta:** Consulta por telefone é muito rápida (chave primária)
- ✅ **Sem duplicatas:** Impossível ter registros duplicados do mesmo telefone

**Considerações:**
- ⚠️ **Telefone obrigatório:** Campo telefone não pode ser NULL ou vazio
- ⚠️ **Formato consistente:** Telefone deve estar no formato DDD+CELULAR (apenas números)
- ⚠️ **Validação necessária:** Validar formato antes de inserir/atualizar

---

### **2. Comportamento de Inserção/Atualização**

**INSERT ... ON DUPLICATE KEY UPDATE:**

**Quando telefone NÃO existe:**
- ✅ Insere novo registro
- ✅ `created_at` = data atual
- ✅ `updated_at` = data atual
- ✅ Resposta: `"action": "inserted"`

**Quando telefone JÁ existe:**
- ✅ Atualiza registro existente
- ✅ `created_at` = mantém data original (não altera)
- ✅ `updated_at` = data atual (atualizado automaticamente)
- ✅ Resposta: `"action": "updated"`

**Campos atualizados:**
- ✅ Todos os campos são atualizados (exceto `created_at`)
- ✅ Última interação sempre reflete dados mais recentes
- ✅ Histórico de `created_at` preservado

---

### **3. Validação de Telefone**

**Formato Esperado:**
- ✅ Apenas números (DDD + CELULAR)
- ✅ Exemplo: `11987654321` (11 = DDD, 987654321 = CELULAR)
- ✅ Tamanho: 10-11 dígitos (DDD 2 dígitos + CELULAR 8-9 dígitos)

**Validação no Endpoint:**
```php
// Validar telefone
if (empty($data['telefone'])) {
    throw new Exception('Telefone é obrigatório');
}

// Remover caracteres não numéricos
$telefone = preg_replace('/[^0-9]/', '', $data['telefone']);

// Validar formato (10-11 dígitos)
if (strlen($telefone) < 10 || strlen($telefone) > 11) {
    throw new Exception('Telefone inválido. Deve ter 10 ou 11 dígitos');
}
```

---

**Documento criado em:** 25/11/2025  
**Última atualização:** 25/11/2025  
**Versão:** 1.1.0  
**Status:** 📋 **PROJETO APRIMORADO - AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**

