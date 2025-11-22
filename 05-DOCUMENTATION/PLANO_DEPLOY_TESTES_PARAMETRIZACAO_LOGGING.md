# 📋 PLANO DE DEPLOY E TESTES: Parametrização de Logging

**Data:** 17/11/2025  
**Status:** 📝 **PLANO CRIADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.0.0  
**Ambiente:** DEV (Desenvolvimento)

---

## 🎯 OBJETIVO

Realizar deploy completo da implementação de parametrização de logging para o servidor de desenvolvimento, incluindo:
1. Cópia de arquivos modificados
2. Atualização de variáveis de ambiente PHP-FPM (sem prejudicar existentes)
3. Testes de conexão do banco de dados
4. Testes dos endpoints PHP de log
5. Verificação de que o banco de dados foi configurado corretamente

---

## 📊 INFORMAÇÕES DO SERVIDOR DEV

- **Servidor:** `dev.bssegurosimediato.com.br`
- **IP:** `65.108.156.14`
- **Usuário SSH:** `root`
- **Caminho raiz:** `/var/www/html/dev/root/`
- **Caminho PHP-FPM config:** `/etc/php/8.3/fpm/pool.d/www.conf` (ou similar)
- **Banco de dados DEV:**
  - Host: `localhost`
  - Port: `3306`
  - Database: `rpa_logs_dev`
  - User: `rpa_logger_dev`
  - Password: `tYbAwe7QkKNrHSRhaWplgsSxt`

---

## 📁 ARQUIVOS QUE SERÃO COPIADOS

### **JavaScript:**
1. `FooterCodeSiteDefinitivoCompleto.js`
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
   - Destino: `/var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js`

### **PHP:**
1. `ProfessionalLogger.php`
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
   - Destino: `/var/www/html/dev/root/ProfessionalLogger.php`

2. `log_endpoint.php`
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/log_endpoint.php`
   - Destino: `/var/www/html/dev/root/log_endpoint.php`

3. `send_email_notification_endpoint.php`
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_email_notification_endpoint.php`
   - Destino: `/var/www/html/dev/root/send_email_notification_endpoint.php`

### **Configuração PHP-FPM:**
1. `php-fpm_www_conf_DEV.conf`
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`
   - Destino: `/etc/php/8.3/fpm/pool.d/www.conf` (ou caminho correto no servidor)

---

## 🚀 PLANO DE DEPLOY - PASSO A PASSO

### **FASE 1: Preparação e Verificação Pré-Deploy**

#### **1.1. Verificar Acesso ao Servidor**
```bash
# Testar conexão SSH
ssh root@65.108.156.14 "echo 'Conexão SSH OK'"
```

#### **1.2. Verificar Estrutura de Diretórios no Servidor**
```bash
# Verificar se diretório existe
ssh root@65.108.156.14 "ls -la /var/www/html/dev/root/ | head -20"

# Verificar se diretório de logs existe
ssh root@65.108.156.14 "ls -la /var/log/webflow-segurosimediato/ 2>/dev/null || echo 'Diretório de logs não existe - será criado'"
```

#### **1.3. Verificar Configuração PHP-FPM Atual**
```bash
# Identificar caminho correto do arquivo de configuração PHP-FPM
ssh root@65.108.156.14 "php-fpm8.3 -t 2>&1 | grep 'Configuration File' || find /etc -name 'www.conf' -path '*/fpm/pool.d/*' 2>/dev/null | head -1"

# Fazer backup do arquivo PHP-FPM atual
ssh root@65.108.156.14 "PHP_FPM_CONF=\$(find /etc -name 'www.conf' -path '*/fpm/pool.d/*' 2>/dev/null | head -1); if [ -n \"\$PHP_FPM_CONF\" ]; then cp \"\$PHP_FPM_CONF\" \"\${PHP_FPM_CONF}.backup_\$(date +%Y%m%d_%H%M%S)\"; echo \"Backup criado: \${PHP_FPM_CONF}.backup_*\"; else echo 'Arquivo PHP-FPM não encontrado'; fi"
```

#### **1.4. Verificar Hash dos Arquivos Locais (Antes de Copiar)**
```powershell
# PowerShell - Calcular hash dos arquivos locais
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
cd $workspacePath

$files = @(
    "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js",
    "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php",
    "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\log_endpoint.php",
    "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_email_notification_endpoint.php"
)

Write-Host "`n📊 HASHES DOS ARQUIVOS LOCAIS:`n" -ForegroundColor Cyan
foreach ($file in $files) {
    if (Test-Path $file) {
        $hash = (Get-FileHash -Path $file -Algorithm SHA256).Hash.ToUpper()
        Write-Host "$(Split-Path $file -Leaf): $hash" -ForegroundColor Gray
    }
}
```

---

### **FASE 2: Backup dos Arquivos no Servidor**

#### **2.1. Criar Backups no Servidor (Com Timestamp)**
```bash
# Criar backups de todos os arquivos que serão substituídos
ssh root@65.108.156.14 << 'EOF'
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/www/html/dev/root/backups_${TIMESTAMP}"
mkdir -p "$BACKUP_DIR"

# Arquivos a fazer backup
FILES=(
    "/var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js"
    "/var/www/html/dev/root/ProfessionalLogger.php"
    "/var/www/html/dev/root/log_endpoint.php"
    "/var/www/html/dev/root/send_email_notification_endpoint.php"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "${BACKUP_DIR}/$(basename $file).backup_${TIMESTAMP}"
        echo "✅ Backup criado: $(basename $file)"
    else
        echo "⚠️ Arquivo não existe: $file"
    fi
done

echo "📁 Backups salvos em: $BACKUP_DIR"
EOF
```

---

### **FASE 3: Cópia de Arquivos para Servidor DEV**

#### **3.1. Copiar Arquivo JavaScript**
```powershell
# PowerShell - Copiar FooterCodeSiteDefinitivoCompleto.js
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$localFile = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js"
$remotePath = "root@65.108.156.14:/var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js"

Write-Host "📤 Copiando FooterCodeSiteDefinitivoCompleto.js..." -ForegroundColor Cyan
scp $localFile $remotePath

# Verificar hash após cópia
Write-Host "`n🔍 Verificando hash após cópia..." -ForegroundColor Cyan
$hashLocal = (Get-FileHash -Path $localFile -Algorithm SHA256).Hash.ToUpper()
$hashRemote = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js | cut -d' ' -f1").ToUpper()

if ($hashLocal -eq $hashRemote) {
    Write-Host "✅ Hash coincide - arquivo copiado corretamente" -ForegroundColor Green
} else {
    Write-Host "❌ Hash não coincide!" -ForegroundColor Red
    Write-Host "   Local:    $hashLocal" -ForegroundColor Yellow
    Write-Host "   Servidor: $hashRemote" -ForegroundColor Yellow
}
```

#### **3.2. Copiar Arquivos PHP**
```powershell
# PowerShell - Copiar arquivos PHP
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$phpFiles = @(
    "ProfessionalLogger.php",
    "log_endpoint.php",
    "send_email_notification_endpoint.php"
)

foreach ($phpFile in $phpFiles) {
    $localFile = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\$phpFile"
    $remotePath = "root@65.108.156.14:/var/www/html/dev/root/$phpFile"
    
    Write-Host "`n📤 Copiando $phpFile..." -ForegroundColor Cyan
    scp $localFile $remotePath
    
    # Verificar hash após cópia
    Write-Host "🔍 Verificando hash após cópia..." -ForegroundColor Cyan
    $hashLocal = (Get-FileHash -Path $localFile -Algorithm SHA256).Hash.ToUpper()
    $hashRemote = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/$phpFile | cut -d' ' -f1").ToUpper()
    
    if ($hashLocal -eq $hashRemote) {
        Write-Host "✅ Hash coincide - $phpFile copiado corretamente" -ForegroundColor Green
    } else {
        Write-Host "❌ Hash não coincide para $phpFile!" -ForegroundColor Red
        Write-Host "   Local:    $hashLocal" -ForegroundColor Yellow
        Write-Host "   Servidor: $hashRemote" -ForegroundColor Yellow
    }
}
```

---

### **FASE 4: Atualizar Variáveis de Ambiente PHP-FPM**

#### **4.1. Identificar Arquivo PHP-FPM Correto**
```bash
# Identificar caminho do arquivo PHP-FPM
ssh root@65.108.156.14 "PHP_FPM_CONF=\$(find /etc -name 'www.conf' -path '*/fpm/pool.d/*' 2>/dev/null | head -1); if [ -n \"\$PHP_FPM_CONF\" ]; then echo \"\$PHP_FPM_CONF\"; else echo 'ERRO: Arquivo não encontrado'; fi"
```

#### **4.2. Verificar Hash do Arquivo PHP-FPM Local vs Servidor**
```powershell
# PowerShell - Comparar hash do arquivo PHP-FPM
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$localFile = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_www_conf_DEV.conf"

# Obter caminho do arquivo no servidor
$remotePath = (ssh root@65.108.156.14 "find /etc -name 'www.conf' -path '*/fpm/pool.d/*' 2>/dev/null | head -1").Trim()

if ($remotePath) {
    Write-Host "📊 Comparando arquivos PHP-FPM..." -ForegroundColor Cyan
    Write-Host "   Local:  $localFile" -ForegroundColor Gray
    Write-Host "   Remoto: $remotePath" -ForegroundColor Gray
    
    # Baixar arquivo do servidor para comparação
    $tempFile = "$env:TEMP\php-fpm_www_conf_DEV_SERVER.conf"
    scp "root@65.108.156.14:$remotePath" $tempFile
    
    # Comparar hashes
    $hashLocal = (Get-FileHash -Path $localFile -Algorithm SHA256).Hash.ToUpper()
    $hashRemote = (Get-FileHash -Path $tempFile -Algorithm SHA256).Hash.ToUpper()
    
    if ($hashLocal -eq $hashRemote) {
        Write-Host "✅ Arquivos idênticos - pode atualizar com segurança" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Arquivos diferentes - será necessário fazer merge das variáveis" -ForegroundColor Yellow
        Write-Host "   Local:    $hashLocal" -ForegroundColor Gray
        Write-Host "   Servidor: $hashRemote" -ForegroundColor Gray
    }
    
    Remove-Item $tempFile -ErrorAction SilentlyContinue
} else {
    Write-Host "❌ Arquivo PHP-FPM não encontrado no servidor" -ForegroundColor Red
}
```

#### **4.3. Adicionar Variáveis de Ambiente (Sem Remover Existentes)**

**Opção A: Se arquivos forem idênticos (apenas adicionar variáveis)**
```bash
# Adicionar variáveis de logging ao final do arquivo PHP-FPM (sem remover existentes)
ssh root@65.108.156.14 << 'EOF'
PHP_FPM_CONF=$(find /etc -name 'www.conf' -path '*/fpm/pool.d/*' 2>/dev/null | head -1)

if [ -n "$PHP_FPM_CONF" ]; then
    # Verificar se variáveis já existem
    if grep -q "LOG_ENABLED" "$PHP_FPM_CONF"; then
        echo "⚠️ Variáveis de logging já existem no arquivo"
    else
        # Adicionar variáveis ao final do arquivo
        cat >> "$PHP_FPM_CONF" << 'VAREOF'

; ==================== VARIÁVEIS DE LOGGING DEV (FASE 9) ====================
; Configuração de logging para ambiente de desenvolvimento
env[LOG_ENABLED] = true
env[LOG_LEVEL] = all
env[LOG_DATABASE_ENABLED] = true
env[LOG_DATABASE_MIN_LEVEL] = all
env[LOG_CONSOLE_ENABLED] = true
env[LOG_CONSOLE_MIN_LEVEL] = all
env[LOG_FILE_ENABLED] = true
env[LOG_FILE_MIN_LEVEL] = error
VAREOF
        echo "✅ Variáveis de logging adicionadas ao arquivo PHP-FPM"
    fi
else
    echo "❌ Arquivo PHP-FPM não encontrado"
fi
EOF
```

**Opção B: Se arquivos forem diferentes (fazer merge manual)**
```bash
# Baixar arquivo do servidor, fazer merge localmente, e copiar de volta
# (Processo manual - ver seção "FASE 4.4: Merge Manual se Necessário")
```

#### **4.4. Verificar Sintaxe do Arquivo PHP-FPM**
```bash
# Verificar sintaxe antes de reiniciar
ssh root@65.108.156.14 "php-fpm8.3 -t"
```

#### **4.5. Reiniciar PHP-FPM**
```bash
# Reiniciar PHP-FPM para aplicar novas variáveis de ambiente
ssh root@65.108.156.14 "systemctl restart php8.3-fpm && systemctl status php8.3-fpm --no-pager | head -10"
```

---

### **FASE 5: Verificação de Integridade Pós-Deploy**

#### **5.1. Verificar Hash de Todos os Arquivos Copiados**
```powershell
# PowerShell - Verificar hash de todos os arquivos
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$files = @(
    @{Local="WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js"; Remote="/var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js"},
    @{Local="WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php"; Remote="/var/www/html/dev/root/ProfessionalLogger.php"},
    @{Local="WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\log_endpoint.php"; Remote="/var/www/html/dev/root/log_endpoint.php"},
    @{Local="WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_email_notification_endpoint.php"; Remote="/var/www/html/dev/root/send_email_notification_endpoint.php"}
)

Write-Host "`n🔍 VERIFICAÇÃO DE INTEGRIDADE PÓS-DEPLOY:`n" -ForegroundColor Cyan

$allOk = $true
foreach ($file in $files) {
    $localPath = Join-Path $workspacePath $file.Local
    $remotePath = $file.Remote
    
    if (Test-Path $localPath) {
        $hashLocal = (Get-FileHash -Path $localPath -Algorithm SHA256).Hash.ToUpper()
        $hashRemote = (ssh root@65.108.156.14 "sha256sum $remotePath 2>/dev/null | cut -d' ' -f1").ToUpper()
        
        if ($hashLocal -eq $hashRemote) {
            Write-Host "✅ $(Split-Path $file.Local -Leaf): OK" -ForegroundColor Green
        } else {
            Write-Host "❌ $(Split-Path $file.Local -Leaf): HASH NÃO COINCIDE" -ForegroundColor Red
            $allOk = $false
        }
    }
}

if ($allOk) {
    Write-Host "`n✅ Todos os arquivos foram copiados corretamente" -ForegroundColor Green
} else {
    Write-Host "`n❌ Alguns arquivos não foram copiados corretamente - verificar" -ForegroundColor Red
}
```

---

## 🧪 PLANO DE TESTES

### **FASE 6: Testes de Conexão do Banco de Dados**

#### **6.1. Verificar se Banco de Dados Existe**
```bash
# Verificar se banco de dados rpa_logs_dev existe
ssh root@65.108.156.14 << 'EOF'
mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' -e "SHOW DATABASES LIKE 'rpa_logs_dev';" 2>&1
EOF
```

#### **6.2. Verificar se Tabela application_logs Existe**
```bash
# Verificar se tabela application_logs existe
ssh root@65.108.156.14 << 'EOF'
mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e "SHOW TABLES LIKE 'application_logs';" 2>&1
EOF
```

#### **6.3. Verificar Estrutura da Tabela application_logs**
```bash
# Verificar estrutura da tabela
ssh root@65.108.156.14 << 'EOF'
mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e "DESCRIBE application_logs;" 2>&1
EOF
```

#### **6.4. Testar Conexão via PHP (Script de Teste)**
```bash
# Criar script de teste de conexão
ssh root@65.108.156.14 << 'EOF'
cat > /var/www/html/dev/root/test_db_connection.php << 'PHPEOF'
<?php
/**
 * Script de teste de conexão com banco de dados
 * FASE 6: Verificar se banco foi configurado corretamente
 */

require_once __DIR__ . '/ProfessionalLogger.php';

header('Content-Type: application/json');

try {
    $logger = new ProfessionalLogger();
    $connection = $logger->getConnection();
    
    if ($connection === null) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'Database connection failed - getConnection() returned null',
            'message' => 'Verifique as variáveis de ambiente LOG_DB_*'
        ], JSON_PRETTY_PRINT);
        exit;
    }
    
    // Testar query simples
    $stmt = $connection->query('SELECT 1 as test, DATABASE() as current_db, USER() as current_user');
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Verificar se tabela application_logs existe
    $stmt = $connection->query("SHOW TABLES LIKE 'application_logs'");
    $tableExists = $stmt->rowCount() > 0;
    
    // Se tabela existe, verificar estrutura
    $tableStructure = null;
    if ($tableExists) {
        $stmt = $connection->query("DESCRIBE application_logs");
        $tableStructure = $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    // Contar registros na tabela (se existir)
    $recordCount = null;
    if ($tableExists) {
        $stmt = $connection->query("SELECT COUNT(*) as count FROM application_logs");
        $recordCount = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
    }
    
    echo json_encode([
        'success' => true,
        'connection' => [
            'status' => 'connected',
            'database' => $result['current_db'],
            'user' => $result['current_user']
        ],
        'table' => [
            'exists' => $tableExists,
            'structure' => $tableStructure,
            'record_count' => $recordCount
        ],
        'environment' => [
            'LOG_DB_HOST' => $_ENV['LOG_DB_HOST'] ?? 'NOT_SET',
            'LOG_DB_PORT' => $_ENV['LOG_DB_PORT'] ?? 'NOT_SET',
            'LOG_DB_NAME' => $_ENV['LOG_DB_NAME'] ?? 'NOT_SET',
            'LOG_DB_USER' => $_ENV['LOG_DB_USER'] ?? 'NOT_SET',
            'LOG_DB_PASS' => isset($_ENV['LOG_DB_PASS']) ? '***SET***' : 'NOT_SET'
        ]
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString()
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}
PHPEOF

echo "✅ Script de teste criado: /var/www/html/dev/root/test_db_connection.php"
EOF
```

#### **6.5. Executar Teste de Conexão**
```bash
# Executar teste via curl
curl -s "https://dev.bssegurosimediato.com.br/test_db_connection.php" | jq .
```

---

### **FASE 7: Testes dos Endpoints PHP de Log**

#### **7.1. Teste do Endpoint log_endpoint.php - Log Básico**
```bash
# Teste 1: Enviar log básico (deve funcionar)
curl -X POST "https://dev.bssegurosimediato.com.br/log_endpoint.php" \
  -H "Content-Type: application/json" \
  -d '{
    "level": "INFO",
    "category": "TEST",
    "message": "Teste de log básico - FASE 7.1",
    "data": {"test": true, "phase": "7.1"}
  }' | jq .
```

#### **7.2. Teste do Endpoint log_endpoint.php - Verificar Parametrização (LOG_ENABLED=false)**
```bash
# Teste 2: Verificar se parametrização funciona (requer alterar LOG_ENABLED=false temporariamente)
# NOTA: Este teste requer alterar variável de ambiente temporariamente
# Será feito manualmente após verificar que endpoint funciona
```

#### **7.3. Teste do Endpoint log_endpoint.php - Diferentes Níveis**
```bash
# Teste 3: Enviar logs de diferentes níveis
for level in DEBUG INFO WARN ERROR FATAL; do
  echo "Testando nível: $level"
  curl -X POST "https://dev.bssegurosimediato.com.br/log_endpoint.php" \
    -H "Content-Type: application/json" \
    -d "{
      \"level\": \"$level\",
      \"category\": \"TEST\",
      \"message\": \"Teste de log nível $level - FASE 7.3\",
      \"data\": {\"test\": true, \"level\": \"$level\", \"phase\": \"7.3\"}
    }" | jq -r '.success, .log_id, .inserted'
  echo "---"
done
```

#### **7.4. Teste do Endpoint log_endpoint.php - Verificar Fallback para Arquivo**
```bash
# Teste 4: Simular falha de banco (desabilitar temporariamente) e verificar fallback
# NOTA: Este teste requer desabilitar banco temporariamente
# Verificar se arquivo professional_logger_fallback.txt foi criado
ssh root@65.108.156.14 "ls -lh /var/log/webflow-segurosimediato/professional_logger_fallback.txt 2>/dev/null || echo 'Arquivo de fallback não existe ainda'"
```

#### **7.5. Verificar Logs Inseridos no Banco**
```bash
# Verificar se logs foram inseridos no banco
ssh root@65.108.156.14 << 'EOF'
mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e "
SELECT 
    log_id,
    level,
    category,
    LEFT(message, 50) as message_preview,
    timestamp
FROM application_logs 
WHERE category = 'TEST' 
ORDER BY timestamp DESC 
LIMIT 10;
" 2>&1
EOF
```

#### **7.6. Teste do Endpoint send_email_notification_endpoint.php**
```bash
# Teste 5: Testar endpoint de email (não deve quebrar com parametrização)
curl -X POST "https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php" \
  -H "Content-Type: application/json" \
  -d '{
    "ddd": "11",
    "celular": "987654321",
    "nome": "Teste Parametrização",
    "email": "teste@example.com",
    "momento": "test_parametrizacao"
  }' | jq .
```

---

### **FASE 8: Testes de Parametrização**

#### **8.1. Verificar Variáveis de Ambiente Carregadas**
```bash
# Criar script para verificar variáveis de ambiente
ssh root@65.108.156.14 << 'EOF'
cat > /var/www/html/dev/root/test_log_config.php << 'PHPEOF'
<?php
/**
 * Script de teste de configuração de logging
 * FASE 8: Verificar se variáveis de ambiente foram carregadas
 */

require_once __DIR__ . '/ProfessionalLogger.php';

header('Content-Type: application/json');

try {
    $config = LogConfig::load();
    
    echo json_encode([
        'success' => true,
        'log_config' => $config,
        'environment_variables' => [
            'LOG_ENABLED' => $_ENV['LOG_ENABLED'] ?? 'NOT_SET',
            'LOG_LEVEL' => $_ENV['LOG_LEVEL'] ?? 'NOT_SET',
            'LOG_DATABASE_ENABLED' => $_ENV['LOG_DATABASE_ENABLED'] ?? 'NOT_SET',
            'LOG_DATABASE_MIN_LEVEL' => $_ENV['LOG_DATABASE_MIN_LEVEL'] ?? 'NOT_SET',
            'LOG_CONSOLE_ENABLED' => $_ENV['LOG_CONSOLE_ENABLED'] ?? 'NOT_SET',
            'LOG_CONSOLE_MIN_LEVEL' => $_ENV['LOG_CONSOLE_MIN_LEVEL'] ?? 'NOT_SET',
            'LOG_FILE_ENABLED' => $_ENV['LOG_FILE_ENABLED'] ?? 'NOT_SET',
            'LOG_FILE_MIN_LEVEL' => $_ENV['LOG_FILE_MIN_LEVEL'] ?? 'NOT_SET'
        ],
        'tests' => [
            'shouldLog(INFO, null)' => LogConfig::shouldLog('INFO', null),
            'shouldLog(DEBUG, null)' => LogConfig::shouldLog('DEBUG', null),
            'shouldLog(ERROR, null)' => LogConfig::shouldLog('ERROR', null),
            'shouldLogToDatabase(INFO)' => LogConfig::shouldLogToDatabase('INFO'),
            'shouldLogToDatabase(DEBUG)' => LogConfig::shouldLogToDatabase('DEBUG'),
            'shouldLogToConsole(INFO)' => LogConfig::shouldLogToConsole('INFO'),
            'shouldLogToFile(ERROR)' => LogConfig::shouldLogToFile('ERROR')
        ]
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine()
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}
PHPEOF

echo "✅ Script de teste de configuração criado"
EOF
```

#### **8.2. Executar Teste de Configuração**
```bash
# Executar teste de configuração
curl -s "https://dev.bssegurosimediato.com.br/test_log_config.php" | jq .
```

#### **8.3. Testar Parametrização - LOG_ENABLED=false**
```bash
# Teste: Desabilitar logging temporariamente e verificar se endpoint retorna 200 mas não processa
# NOTA: Requer alterar LOG_ENABLED=false no PHP-FPM e reiniciar
# Será feito manualmente após testes básicos
```

---

### **FASE 9: Verificação de Sensibilização do Banco de Dados**

#### **9.1. Verificar se Banco Foi Criado**
```bash
# Verificar se banco rpa_logs_dev existe e está acessível
ssh root@65.108.156.14 << 'EOF'
mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' -e "
SELECT 
    SCHEMA_NAME as database_name,
    DEFAULT_CHARACTER_SET_NAME as charset,
    DEFAULT_COLLATION_NAME as collation
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME = 'rpa_logs_dev';
" 2>&1
EOF
```

#### **9.2. Verificar se Tabela Foi Criada**
```bash
# Verificar estrutura completa da tabela application_logs
ssh root@65.108.156.14 << 'EOF'
mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e "
SHOW CREATE TABLE application_logs;
" 2>&1
EOF
```

#### **9.3. Verificar Permissões do Usuário do Banco**
```bash
# Verificar permissões do usuário rpa_logger_dev
ssh root@65.108.156.14 << 'EOF'
mysql -u root -p -e "
SHOW GRANTS FOR 'rpa_logger_dev'@'localhost';
" 2>&1
EOF
```

#### **9.4. Testar Inserção Manual**
```bash
# Testar inserção manual de log
ssh root@65.108.156.14 << 'EOF'
mysql -u rpa_logger_dev -p'tYbAwe7QkKNrHSRhaWplgsSxt' rpa_logs_dev -e "
INSERT INTO application_logs (
    log_id, request_id, timestamp, level, category, message, environment
) VALUES (
    CONCAT('test_', UNIX_TIMESTAMP(), '_', FLOOR(RAND() * 10000)),
    CONCAT('req_', UNIX_TIMESTAMP()),
    NOW(),
    'INFO',
    'TEST',
    'Teste manual de inserção - FASE 9.4',
    'development'
);

SELECT 
    log_id,
    level,
    category,
    message,
    timestamp
FROM application_logs 
WHERE category = 'TEST' 
ORDER BY timestamp DESC 
LIMIT 1;
" 2>&1
EOF
```

---

### **FASE 10: Testes de Integração JavaScript**

#### **10.1. Verificar se window.LOG_CONFIG Foi Carregado**
```bash
# Criar página de teste HTML simples
ssh root@65.108.156.14 << 'EOF'
cat > /var/www/html/dev/root/test_log_config.html << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <title>Teste LOG_CONFIG</title>
</head>
<body>
    <h1>Teste de Configuração de Logging</h1>
    <div id="results"></div>
    
    <script src="FooterCodeSiteDefinitivoCompleto.js" 
            data-app-base-url="https://dev.bssegurosimediato.com.br"
            data-app-environment="development"
            data-log-enabled="true"
            data-log-level="all"></script>
    
    <script>
        setTimeout(() => {
            const results = document.getElementById('results');
            results.innerHTML = `
                <h2>Resultados:</h2>
                <pre>${JSON.stringify({
                    LOG_CONFIG: window.LOG_CONFIG,
                    shouldLog: typeof window.shouldLog,
                    shouldLogToDatabase: typeof window.shouldLogToDatabase,
                    shouldLogToConsole: typeof window.shouldLogToConsole,
                    APP_BASE_URL: window.APP_BASE_URL,
                    APP_ENVIRONMENT: window.APP_ENVIRONMENT
                }, null, 2)}</pre>
            `;
        }, 1000);
    </script>
</body>
</html>
HTMLEOF

echo "✅ Página de teste criada: /var/www/html/dev/root/test_log_config.html"
EOF
```

#### **10.2. Testar Envio de Log do JavaScript para PHP**
```bash
# Criar script de teste que simula chamada do JavaScript
cat > test_js_to_php_log.sh << 'EOF'
#!/bin/bash
# Teste de envio de log do JavaScript para PHP

curl -X POST "https://dev.bssegurosimediato.com.br/log_endpoint.php" \
  -H "Content-Type: application/json" \
  -H "X-Request-ID: test_js_$(date +%s)" \
  -d '{
    "level": "INFO",
    "category": "JS_TEST",
    "message": "Teste de log enviado do JavaScript - FASE 10.2",
    "data": {
        "source": "javascript",
        "test": true,
        "phase": "10.2"
    },
    "url": "https://dev.bssegurosimediato.com.br/test_log_config.html",
    "session_id": "test_session_123"
  }' | jq .

echo ""
echo "Verificando se log foi inserido no banco..."
EOF

chmod +x test_js_to_php_log.sh
```

---

### **FASE 11: Limpeza e Documentação**

#### **11.1. Remover Scripts de Teste (Opcional)**
```bash
# Remover scripts de teste após validação
ssh root@65.108.156.14 << 'EOF'
# Manter scripts de teste por enquanto para debug
# rm -f /var/www/html/dev/root/test_*.php
# rm -f /var/www/html/dev/root/test_*.html
echo "Scripts de teste mantidos para debug"
EOF
```

#### **11.2. Documentar Resultados dos Testes**
```bash
# Criar relatório de testes
# (Será criado manualmente após execução dos testes)
```

---

## 📋 CHECKLIST DE DEPLOY

### **Antes de Iniciar:**
- [ ] Verificar acesso SSH ao servidor DEV
- [ ] Verificar que backups locais foram criados
- [ ] Verificar que arquivos locais estão corretos
- [ ] Verificar caminho completo do workspace

### **Durante Deploy:**
- [ ] FASE 1: Preparação e verificação pré-deploy
- [ ] FASE 2: Backup dos arquivos no servidor
- [ ] FASE 3: Cópia de arquivos para servidor DEV
- [ ] FASE 4: Atualizar variáveis de ambiente PHP-FPM
- [ ] FASE 5: Verificação de integridade pós-deploy

### **Testes:**
- [ ] FASE 6: Testes de conexão do banco de dados
- [ ] FASE 7: Testes dos endpoints PHP de log
- [ ] FASE 8: Testes de parametrização
- [ ] FASE 9: Verificação de sensibilização do banco
- [ ] FASE 10: Testes de integração JavaScript

### **Após Deploy:**
- [ ] FASE 11: Limpeza e documentação
- [ ] ⚠️ **OBRIGATÓRIO:** Avisar usuário sobre necessidade de limpar cache do Cloudflare
- [ ] Criar relatório de deploy

---

## ⚠️ AVISOS IMPORTANTES

### **1. Cache Cloudflare**
⚠️ **OBRIGATÓRIO:** Após atualizar arquivos `.js` e `.php` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.

### **2. Variáveis de Ambiente Existentes**
✅ **IMPORTANTE:** As variáveis de ambiente de logging serão **ADICIONADAS** ao final do arquivo PHP-FPM, **SEM REMOVER** variáveis existentes.

### **3. Reinício do PHP-FPM**
⚠️ **OBRIGATÓRIO:** Após atualizar arquivo PHP-FPM, **SEMPRE reiniciar** o serviço PHP-FPM para que as novas variáveis de ambiente sejam carregadas.

### **4. Verificação de Hash**
✅ **OBRIGATÓRIO:** Sempre verificar hash (SHA256) após cópia de arquivos, comparando case-insensitive.

### **5. Backups**
✅ **OBRIGATÓRIO:** Backups foram criados localmente e serão criados no servidor antes de qualquer modificação.

---

## 🚨 PROCEDIMENTO DE ROLLBACK (SE NECESSÁRIO)

### **Rollback de Arquivos:**
```bash
# Restaurar arquivos do backup no servidor
ssh root@65.108.156.14 << 'EOF'
BACKUP_DIR="/var/www/html/dev/root/backups_*"  # Substituir * pelo timestamp correto
if [ -d $BACKUP_DIR ]; then
    cp $BACKUP_DIR/*.backup_* /var/www/html/dev/root/
    echo "✅ Arquivos restaurados do backup"
else
    echo "❌ Diretório de backup não encontrado"
fi
EOF
```

### **Rollback de Variáveis PHP-FPM:**
```bash
# Restaurar arquivo PHP-FPM do backup
ssh root@65.108.156.14 << 'EOF'
PHP_FPM_CONF=$(find /etc -name 'www.conf' -path '*/fpm/pool.d/*' 2>/dev/null | head -1)
BACKUP_FILE="${PHP_FPM_CONF}.backup_*"  # Substituir * pelo timestamp correto
if [ -f $BACKUP_FILE ]; then
    cp $BACKUP_FILE $PHP_FPM_CONF
    systemctl restart php8.3-fpm
    echo "✅ Configuração PHP-FPM restaurada"
else
    echo "❌ Backup não encontrado"
fi
EOF
```

---

## 📊 TEMPO ESTIMADO

- **FASE 1-5 (Deploy):** ~30 minutos
- **FASE 6-10 (Testes):** ~45 minutos
- **FASE 11 (Documentação):** ~15 minutos
- **Total:** ~1h30min

---

## ✅ CRITÉRIOS DE SUCESSO

1. ✅ Todos os arquivos foram copiados com hash correto
2. ✅ Variáveis de ambiente foram adicionadas sem remover existentes
3. ✅ PHP-FPM foi reiniciado com sucesso
4. ✅ Conexão com banco de dados funciona
5. ✅ Tabela `application_logs` existe e está acessível
6. ✅ Endpoint `log_endpoint.php` responde corretamente
7. ✅ Logs são inseridos no banco de dados
8. ✅ Parametrização funciona (logs são filtrados conforme configuração)
9. ✅ Fallback para arquivo funciona quando banco está indisponível
10. ✅ JavaScript consegue enviar logs para o endpoint PHP

---

**Status:** 📝 **PLANO CRIADO - PRONTO PARA EXECUÇÃO**

