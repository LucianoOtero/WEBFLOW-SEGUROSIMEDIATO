# 📋 PLANO DE DEPLOY: Unificação de Função de Log - Servidor DEV

**Data:** 17/11/2025  
**Status:** 📝 **PLANO CRIADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.0.0  
**Projeto:** Unificar Função de Log - Uma Única Função Centralizada

---

## 🎯 OBJETIVO

Realizar deploy da implementação de unificação de função de log para o servidor de desenvolvimento, incluindo:
- Cópia de arquivos JavaScript modificados
- Verificação de integridade (hash SHA256)
- Testes de conexão do banco de dados
- Testes dos endpoints PHP de log
- Verificação de sensibilização do banco de dados (logs sendo inseridos)

---

## 📊 INFORMAÇÕES DO SERVIDOR

**Servidor DEV:**
- **Hostname:** `dev.bssegurosimediato.com.br`
- **IP:** `65.108.156.14`
- **Caminho no servidor:** `/var/www/html/dev/root/`
- **Usuário SSH:** `root`
- **Ambiente:** Desenvolvimento

**Banco de Dados DEV:**
- **Tabela de logs:** `rpa_logs_dev` (ou conforme configuração)
- **Tabela:** `application_logs`

---

## 📋 FASES DO DEPLOY

### **FASE 1: Preparação e Verificação Pré-Deploy**

#### **FASE 1.1: Verificar Arquivos Locais**
- ✅ Verificar que `FooterCodeSiteDefinitivoCompleto.js` foi modificado
- ✅ Verificar hash SHA256 do arquivo local:
  - Hash atual: `5E881DC1F5A469DECA74AF9B83CE11B2729E4DC7AEB4924CED5FC49A8A412D6B`
- ✅ Verificar que backup local foi criado
- ✅ Verificar que não há erros de sintaxe

#### **FASE 1.2: Verificar Conectividade com Servidor**
- ✅ Testar conexão SSH com servidor DEV
- ✅ Verificar acesso ao diretório `/var/www/html/dev/root/`
- ✅ Verificar permissões de escrita

#### **FASE 1.3: Verificar Estado Atual do Servidor**
- ✅ Verificar hash SHA256 do arquivo atual no servidor
- ✅ Verificar se há backups recentes no servidor
- ✅ Verificar configuração PHP-FPM atual (variáveis de ambiente existentes)

---

### **FASE 2: Backup dos Arquivos no Servidor**

#### **FASE 2.1: Criar Backup no Servidor**
- ✅ Criar diretório de backup: `/var/www/html/dev/root/backups_YYYYMMDD_HHMMSS/`
- ✅ Copiar `FooterCodeSiteDefinitivoCompleto.js` para diretório de backup
- ✅ Documentar localização do backup

**Comando:**
```bash
# Via SSH
ssh root@dev.bssegurosimediato.com.br "mkdir -p /var/www/html/dev/root/backups_$(date +%Y%m%d_%H%M%S) && cp /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js /var/www/html/dev/root/backups_$(date +%Y%m%d_%H%M%S)/FooterCodeSiteDefinitivoCompleto.js.backup"
```

#### **FASE 2.2: Verificar Hash do Arquivo no Servidor (Antes)**
- ✅ Calcular hash SHA256 do arquivo atual no servidor
- ✅ Documentar hash para comparação pós-deploy

**Comando:**
```bash
# Via SSH
ssh root@dev.bssegurosimediato.com.br "sha256sum /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js"
```

---

### **FASE 3: Cópia de Arquivos para Servidor DEV**

#### **FASE 3.1: Copiar Arquivo JavaScript**
- ✅ Copiar `FooterCodeSiteDefinitivoCompleto.js` de local para servidor DEV
- ✅ **OBRIGATÓRIO:** Usar caminho completo do workspace
- ✅ **OBRIGATÓRIO:** Usar `scp` para transferência segura

**Comando (PowerShell):**
```powershell
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$sourceFile = Join-Path $workspacePath "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js"
$serverPath = "root@dev.bssegurosimediato.com.br:/var/www/html/dev/root/"

scp $sourceFile $serverPath
```

#### **FASE 3.2: Verificar Integridade Pós-Cópia**
- ✅ **OBRIGATÓRIO:** Calcular hash SHA256 do arquivo no servidor após cópia
- ✅ **OBRIGATÓRIO:** Comparar hash local vs servidor (case-insensitive)
- ✅ Confirmar que hash coincide antes de considerar deploy concluído
- ✅ Se hash não coincidir, tentar copiar novamente

**Comando:**
```powershell
# Hash local
$hashLocal = (Get-FileHash -Path $sourceFile -Algorithm SHA256).Hash.ToUpper()

# Hash servidor (via SSH)
$hashServidor = (ssh root@dev.bssegurosimediato.com.br "sha256sum /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js | cut -d' ' -f1").ToUpper()

# Comparar
if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ Hash coincide - arquivo copiado corretamente" -ForegroundColor Green
} else {
    Write-Host "❌ Hash não coincide - tentar copiar novamente" -ForegroundColor Red
    Write-Host "Local:    $hashLocal"
    Write-Host "Servidor: $hashServidor"
}
```

---

### **FASE 4: Verificação de Funcionamento Básico**

#### **FASE 4.1: Verificar Acessibilidade do Arquivo**
- ✅ Verificar que arquivo está acessível via HTTP
- ✅ URL: `https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js`
- ✅ Verificar que arquivo não retorna erro 404

#### **FASE 4.2: Verificar Console do Navegador**
- ✅ Acessar `https://dev.bssegurosimediato.com.br/` (ou `https://segurosimediato-dev.webflow.io/`)
- ✅ Abrir console do navegador (F12)
- ✅ Verificar que não há erros de sintaxe JavaScript
- ✅ Verificar que função `novo_log` está disponível (`window.novo_log`)

---

### **FASE 5: Testes de Conexão do Banco de Dados**

#### **FASE 5.1: Testar Conexão PHP com Banco de Dados**
- ✅ Verificar que `ProfessionalLogger.php` consegue conectar ao banco
- ✅ Testar query simples: `SELECT 1`
- ✅ Verificar que não há erros de conexão

**Comando (via SSH):**
```bash
# Testar conexão via PHP
ssh root@dev.bssegurosimediato.com.br "php -r \"
require_once '/var/www/html/dev/root/ProfessionalLogger.php';
\$logger = ProfessionalLogger::getInstance();
\$pdo = \$logger->connect();
if (\$pdo) {
    \$stmt = \$pdo->query('SELECT 1');
    echo '✅ Conexão com banco OK\n';
} else {
    echo '❌ Erro na conexão com banco\n';
}
\""
```

#### **FASE 5.2: Verificar Tabela de Logs**
- ✅ Verificar que tabela `application_logs` existe
- ✅ Verificar estrutura da tabela
- ✅ Verificar que tabela está acessível para inserção

**Comando (via SSH):**
```bash
# Verificar estrutura da tabela
ssh root@dev.bssegurosimediato.com.br "php -r \"
require_once '/var/www/html/dev/root/config.php';
\$pdo = new PDO('mysql:host=' . \$_ENV['DB_HOST'] . ';dbname=' . \$_ENV['DB_NAME'], \$_ENV['DB_USER'], \$_ENV['DB_PASS']);
\$stmt = \$pdo->query('DESCRIBE application_logs');
\$columns = \$stmt->fetchAll(PDO::FETCH_ASSOC);
echo '✅ Tabela application_logs existe com ' . count(\$columns) . ' colunas\n';
\""
```

---

### **FASE 6: Testes dos Endpoints PHP de Log**

#### **FASE 6.1: Testar `log_endpoint.php`**
- ✅ Enviar requisição POST para `https://dev.bssegurosimediato.com.br/log_endpoint.php`
- ✅ Verificar resposta HTTP 200
- ✅ Verificar que log foi inserido no banco de dados
- ✅ Verificar `log_id` na resposta

**Comando (PowerShell):**
```powershell
$endpoint = "https://dev.bssegurosimediato.com.br/log_endpoint.php"
$payload = @{
    level = "INFO"
    category = "TEST"
    message = "Teste de deploy - Unificação de Log"
    data = @{
        test = $true
        timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    } | ConvertTo-Json
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri $endpoint -Method POST -Body $payload -ContentType "application/json"
Write-Host "✅ Resposta do endpoint:" -ForegroundColor Green
$response | ConvertTo-Json -Depth 10
```

#### **FASE 6.2: Verificar Log Inserido no Banco**
- ✅ Consultar banco de dados para verificar se log foi inserido
- ✅ Verificar campos: `level`, `category`, `message`, `log_data`
- ✅ Verificar `request_id` (se aplicável)

**Comando (via SSH):**
```bash
# Consultar último log inserido
ssh root@dev.bssegurosimediato.com.br "php -r \"
require_once '/var/www/html/dev/root/config.php';
\$pdo = new PDO('mysql:host=' . \$_ENV['DB_HOST'] . ';dbname=' . \$_ENV['DB_NAME'], \$_ENV['DB_USER'], \$_ENV['DB_PASS']);
\$stmt = \$pdo->query('SELECT * FROM application_logs ORDER BY id DESC LIMIT 1');
\$log = \$stmt->fetch(PDO::FETCH_ASSOC);
if (\$log) {
    echo '✅ Log inserido com sucesso:\n';
    echo 'ID: ' . \$log['id'] . '\n';
    echo 'Level: ' . \$log['level'] . '\n';
    echo 'Category: ' . \$log['category'] . '\n';
    echo 'Message: ' . \$log['message'] . '\n';
} else {
    echo '❌ Nenhum log encontrado\n';
}
\""
```

---

### **FASE 7: Testes de Sensibilização do Banco de Dados**

#### **FASE 7.1: Testar Logs do Console do Navegador**
- ✅ Acessar `https://dev.bssegurosimediato.com.br/` (ou `https://segurosimediato-dev.webflow.io/`)
- ✅ Abrir console do navegador (F12)
- ✅ Executar manualmente: `window.novo_log('INFO', 'TEST', 'Teste manual de novo_log', {test: true})`
- ✅ Verificar que log aparece no console
- ✅ Verificar que log é enviado para o endpoint PHP
- ✅ Verificar que log é inserido no banco de dados

#### **FASE 7.2: Verificar Logs Inseridos Durante Carregamento da Página**
- ✅ Acessar página e aguardar carregamento completo
- ✅ Consultar banco de dados para contar logs inseridos
- ✅ Verificar que logs do console foram inseridos no banco
- ✅ Verificar que `novo_log()` está funcionando corretamente

**Comando (via SSH):**
```bash
# Contar logs inseridos nas últimas 5 minutos
ssh root@dev.bssegurosimediato.com.br "php -r \"
require_once '/var/www/html/dev/root/config.php';
\$pdo = new PDO('mysql:host=' . \$_ENV['DB_HOST'] . ';dbname=' . \$_ENV['DB_NAME'], \$_ENV['DB_USER'], \$_ENV['DB_PASS']);
\$stmt = \$pdo->query('SELECT COUNT(*) as total FROM application_logs WHERE created_at >= DATE_SUB(NOW(), INTERVAL 5 MINUTE)');
\$result = \$stmt->fetch(PDO::FETCH_ASSOC);
echo '✅ Total de logs inseridos nos últimos 5 minutos: ' . \$result['total'] . '\n';
\""
```

#### **FASE 7.3: Verificar Categorias e Níveis de Log**
- ✅ Consultar banco para verificar diversidade de categorias
- ✅ Verificar que diferentes níveis de log estão sendo inseridos (INFO, DEBUG, WARN, ERROR)
- ✅ Verificar que `request_id` está sendo propagado corretamente

**Comando (via SSH):**
```bash
# Verificar categorias e níveis
ssh root@dev.bssegurosimediato.com.br "php -r \"
require_once '/var/www/html/dev/root/config.php';
\$pdo = new PDO('mysql:host=' . \$_ENV['DB_HOST'] . ';dbname=' . \$_ENV['DB_NAME'], \$_ENV['DB_USER'], \$_ENV['DB_PASS']);
\$stmt = \$pdo->query('SELECT level, category, COUNT(*) as total FROM application_logs WHERE created_at >= DATE_SUB(NOW(), INTERVAL 5 MINUTE) GROUP BY level, category ORDER BY total DESC');
\$results = \$stmt->fetchAll(PDO::FETCH_ASSOC);
echo '✅ Distribuição de logs:\n';
foreach (\$results as \$row) {
    echo '  ' . \$row['level'] . ' / ' . \$row['category'] . ': ' . \$row['total'] . '\n';
}
\""
```

---

### **FASE 8: Verificação de Parametrização**

#### **FASE 8.1: Verificar Variáveis de Ambiente PHP-FPM**
- ✅ Verificar que variáveis de ambiente de logging estão configuradas
- ✅ Verificar valores: `LOG_ENABLED`, `LOG_LEVEL`, `LOG_DATABASE_ENABLED`, etc.
- ✅ **NOTA:** Não modificar variáveis de ambiente existentes, apenas verificar

**Comando (via SSH):**
```bash
# Verificar variáveis de ambiente (sem modificar)
ssh root@dev.bssegurosimediato.com.br "php -r \"
echo 'Variáveis de ambiente de logging:\n';
echo 'LOG_ENABLED: ' . (\$_ENV['LOG_ENABLED'] ?? 'não definido') . '\n';
echo 'LOG_LEVEL: ' . (\$_ENV['LOG_LEVEL'] ?? 'não definido') . '\n';
echo 'LOG_DATABASE_ENABLED: ' . (\$_ENV['LOG_DATABASE_ENABLED'] ?? 'não definido') . '\n';
echo 'LOG_DATABASE_MIN_LEVEL: ' . (\$_ENV['LOG_DATABASE_MIN_LEVEL'] ?? 'não definido') . '\n';
\""
```

#### **FASE 8.2: Testar Parametrização (Opcional)**
- ✅ Testar que logs são filtrados conforme parametrização
- ✅ Testar que logs desabilitados não são inseridos
- ✅ Testar que níveis abaixo do mínimo não são inseridos

---

### **FASE 9: Verificação de Performance**

#### **FASE 9.1: Verificar Tempo de Resposta**
- ✅ Medir tempo de resposta do `log_endpoint.php`
- ✅ Verificar que chamadas assíncronas não bloqueiam execução
- ✅ Verificar que não há degradação significativa de performance

#### **FASE 9.2: Verificar Logs de Erro do Servidor**
- ✅ Verificar logs de erro do PHP (`/var/log/php-fpm/error.log`)
- ✅ Verificar logs de erro do Nginx (`/var/log/nginx/error.log`)
- ✅ Verificar que não há erros relacionados ao novo sistema de log

**Comando (via SSH):**
```bash
# Verificar últimos erros do PHP-FPM
ssh root@dev.bssegurosimediato.com.br "tail -n 50 /var/log/php-fpm/error.log | grep -i 'log\|novo_log\|ProfessionalLogger' || echo '✅ Nenhum erro relacionado a logging encontrado'"
```

---

### **FASE 10: Validação Final e Documentação**

#### **FASE 10.1: Validação Final**
- ✅ Confirmar que todas as 67 chamadas foram substituídas
- ✅ Confirmar que `novo_log()` está funcionando corretamente
- ✅ Confirmar que logs estão sendo inseridos no banco de dados
- ✅ Confirmar que não há erros no console do navegador
- ✅ Confirmar que performance não foi afetada

#### **FASE 10.2: Documentar Resultados**
- ✅ Criar documento de resultados do deploy: `RESULTADO_DEPLOY_UNIFICACAO_LOG_DEV_YYYYMMDD.md`
- ✅ Documentar:
  - Hash do arquivo antes e depois
  - Resultados dos testes de conexão
  - Resultados dos testes de endpoints
  - Resultados da sensibilização do banco
  - Logs inseridos (contagem e distribuição)
  - Problemas encontrados (se houver)
  - Ações corretivas (se houver)

#### **FASE 10.3: Aviso sobre Cache Cloudflare**
- 🚨 **OBRIGATÓRIO:** Avisar ao usuário sobre necessidade de limpar cache do Cloudflare
- ✅ Documentar no relatório de deploy

---

## ⚠️ PROCEDIMENTO DE ROLLBACK

### **Se Deploy Falhar ou Causar Problemas:**

1. ✅ Restaurar arquivo do backup criado na FASE 2.1
2. ✅ Verificar hash do arquivo restaurado
3. ✅ Testar funcionamento básico
4. ✅ Documentar problema e rollback

**Comando de Rollback:**
```bash
# Restaurar do backup
ssh root@dev.bssegurosimediato.com.br "cp /var/www/html/dev/root/backups_YYYYMMDD_HHMMSS/FooterCodeSiteDefinitivoCompleto.js.backup /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js"
```

---

## 📋 CHECKLIST DE DEPLOY

### **Pré-Deploy:**
- [ ] Backup local criado
- [ ] Hash SHA256 do arquivo local documentado
- [ ] Conexão SSH com servidor testada
- [ ] Backup no servidor criado
- [ ] Hash SHA256 do arquivo no servidor (antes) documentado

### **Deploy:**
- [ ] Arquivo copiado para servidor
- [ ] Hash SHA256 verificado após cópia (coincide)
- [ ] Arquivo acessível via HTTP
- [ ] Nenhum erro de sintaxe no console

### **Testes:**
- [ ] Conexão com banco de dados testada
- [ ] Tabela `application_logs` verificada
- [ ] Endpoint `log_endpoint.php` testado
- [ ] Log inserido no banco verificado
- [ ] Logs do console inseridos no banco verificados
- [ ] Sensibilização do banco confirmada

### **Validação:**
- [ ] Função `novo_log()` funcionando
- [ ] Todas as 67 chamadas substituídas
- [ ] Nenhum erro no console
- [ ] Performance não afetada
- [ ] Cache Cloudflare avisado ao usuário

---

## 🚨 AVISOS IMPORTANTES

### **1. Cache Cloudflare**
⚠️ **OBRIGATÓRIO:** Após atualizar arquivo `.js` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.

### **2. Backups**
✅ **OBRIGATÓRIO:** Sempre criar backup antes de qualquer modificação.

### **3. Verificação de Hash**
✅ **OBRIGATÓRIO:** Sempre verificar hash (SHA256) após cópia de arquivos, comparando case-insensitive.

### **4. Ambiente**
✅ **PADRÃO:** Trabalhar apenas no ambiente de **DESENVOLVIMENTO** (DEV).

### **5. Variáveis de Ambiente**
⚠️ **CRÍTICO:** Não modificar variáveis de ambiente existentes. Apenas verificar se estão configuradas corretamente.

---

## 📊 CRITÉRIOS DE SUCESSO

1. ✅ Arquivo copiado com sucesso (hash coincide)
2. ✅ Nenhum erro de sintaxe no console
3. ✅ Função `novo_log()` disponível e funcionando
4. ✅ Conexão com banco de dados funcionando
5. ✅ Endpoint `log_endpoint.php` respondendo corretamente
6. ✅ Logs sendo inseridos no banco de dados
7. ✅ Banco de dados sensibilizado (logs do console aparecem no banco)
8. ✅ Performance não afetada
9. ✅ Nenhum erro nos logs do servidor

---

## ⏱️ TEMPO ESTIMADO

- **FASE 1:** ~10 minutos (preparação)
- **FASE 2:** ~5 minutos (backup)
- **FASE 3:** ~5 minutos (cópia e verificação)
- **FASE 4:** ~5 minutos (verificação básica)
- **FASE 5:** ~10 minutos (testes de banco)
- **FASE 6:** ~10 minutos (testes de endpoints)
- **FASE 7:** ~15 minutos (sensibilização)
- **FASE 8:** ~5 minutos (parametrização)
- **FASE 9:** ~10 minutos (performance)
- **FASE 10:** ~15 minutos (validação e documentação)

**Total:** ~1h30min

---

## 📝 NOTAS

- Este plano segue todas as diretivas definidas em `./cursorrules`
- Trabalha apenas no ambiente de desenvolvimento (DEV)
- Não modifica variáveis de ambiente existentes
- Cria backups antes de qualquer modificação
- Verifica hash após cópia
- Avisa sobre cache Cloudflare

---

**Status:** 📝 **PLANO CRIADO - AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**

