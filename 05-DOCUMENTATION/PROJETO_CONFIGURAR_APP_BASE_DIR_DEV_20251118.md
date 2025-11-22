# 📋 PROJETO: Configurar APP_BASE_DIR e APP_BASE_URL no PHP-FPM DEV

**Data de Criação:** 18/11/2025  
**Status:** 📝 **PLANO DE PROJETO**  
**Prioridade:** 🔴 **CRÍTICA**  
**Versão:** 1.1.0

---

## 📝 HISTÓRICO DE VERSÕES

### **Versão 1.1.0 (18/11/2025)**
- ✅ Adicionada seção "HISTÓRICO DE VERSÕES"
- ✅ Melhorado tratamento de erros na FASE 3 (verificação de sintaxe)
- ✅ Melhorado tratamento de erros na FASE 5 (reinício do PHP-FPM)
- ✅ Melhorado tratamento de erros na FASE 6 (verificação de variáveis)
- ✅ Melhorado tratamento de erros na FASE 7 (teste do endpoint)
- ✅ Adicionados passos de diagnóstico detalhados em todas as fases críticas
- ✅ Adicionados procedimentos de recuperação em caso de falha

### **Versão 1.0.0 (18/11/2025)**
- ✅ Versão inicial do projeto
- ✅ 9 fases definidas
- ✅ Especificações do usuário completas
- ✅ Plano de rollback documentado

---

## 🎯 OBJETIVO

Configurar as variáveis de ambiente `APP_BASE_DIR` e `APP_BASE_URL` no PHP-FPM 8.3 do servidor de desenvolvimento para corrigir o erro HTTP 500 no endpoint `send_email_notification_endpoint.php`.

**Problema Identificado:**
- `config.php` lança exceção quando `APP_BASE_DIR` não está definido
- Endpoint `send_email_notification_endpoint.php` retorna HTTP 500
- Variáveis de ambiente não estão configuradas no PHP-FPM

**Solução:**
- Configurar `APP_BASE_DIR` e `APP_BASE_URL` no arquivo de pool do PHP-FPM
- Reiniciar PHP-FPM para aplicar alterações
- Verificar que variáveis estão disponíveis via `$_ENV`

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### **Requisitos Funcionais:**
1. ✅ Variável `APP_BASE_DIR` deve estar definida e acessível via `$_ENV['APP_BASE_DIR']`
2. ✅ Variável `APP_BASE_URL` deve estar definida e acessível via `$_ENV['APP_BASE_URL']`
3. ✅ Endpoint `send_email_notification_endpoint.php` deve funcionar sem HTTP 500
4. ✅ `config.php` deve carregar sem lançar exceção

### **Requisitos Não Funcionais:**
1. ✅ Configuração deve ser persistente (sobreviver a reinicializações)
2. ✅ Não deve afetar outras variáveis de ambiente já configuradas
3. ✅ Deve seguir padrão de configuração do PHP-FPM
4. ✅ Deve ser documentado para replicação em produção

### **Critérios de Aceitação:**
1. ✅ `$_ENV['APP_BASE_DIR']` retorna `/var/www/html/dev/root` quando testado via web
2. ✅ `$_ENV['APP_BASE_URL']` retorna `https://dev.bssegurosimediato.com.br` quando testado via web
3. ✅ Endpoint `send_email_notification_endpoint.php` retorna HTTP 200 (não 500)
4. ✅ `config.php` carrega sem lançar exceção

### **Limitações Conhecidas:**
- ⚠️ Configuração é específica para PHP-FPM 8.3
- ⚠️ Valores são específicos para ambiente DEV
- ⚠️ Requer acesso root ao servidor

### **Resultados Esperados:**
- ✅ Endpoint de email funcionando corretamente
- ✅ Sistema de logging funcionando corretamente
- ✅ Todas as funcionalidades que dependem de `config.php` funcionando

---

## 🚨 REGRAS CRÍTICAS (Conforme ./cursorrules)

1. ✅ **SEMPRE criar backup** antes de modificar arquivos de configuração
2. ✅ **SEMPRE criar arquivo localmente** antes de copiar para servidor
3. ✅ **SEMPRE verificar hash SHA256** após cópia
4. ✅ **SEMPRE testar** após modificações
5. ✅ **SEMPRE documentar** alterações realizadas
6. ❌ **NUNCA modificar** diretamente no servidor sem backup
7. ❌ **NUNCA modificar** configurações sem testar sintaxe primeiro

---

## 📊 ANÁLISE TÉCNICA

### **Arquivo de Configuração:**
- **Localização:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Seção:** `[www]`
- **Formato:** `env[VARIAVEL] = valor`

### **Valores para DEV:**
- `APP_BASE_DIR = /var/www/html/dev/root`
- `APP_BASE_URL = https://dev.bssegurosimediato.com.br`

### **Comando de Verificação:**
- `php-fpm8.3 -t` (testar sintaxe)
- `systemctl restart php8.3-fpm` (aplicar alterações)

---

## 📝 FASES DO PROJETO

### **FASE 0: Verificação do Estado Atual**

**Objetivo:** Verificar estado atual das variáveis de ambiente e configuração do PHP-FPM

**Tarefas:**

1. **Verificar se variáveis já estão configuradas:**
   ```bash
   grep -E 'env\[APP_BASE_DIR\]|env\[APP_BASE_URL\]' /etc/php/8.3/fpm/pool.d/www.conf
   ```

2. **Verificar valores atuais via web:**
   - Criar script de teste temporário
   - Acessar via HTTP e verificar `$_ENV`

3. **Verificar sintaxe atual do PHP-FPM:**
   ```bash
   php-fpm8.3 -t
   ```

4. **Documentar estado atual:**
   - Listar todas as variáveis `env[]` configuradas
   - Verificar se há conflitos ou duplicações

**Critério de Sucesso:**
- ✅ Estado atual documentado
- ✅ Sintaxe do PHP-FPM válida
- ✅ Variáveis `APP_BASE_DIR` e `APP_BASE_URL` identificadas como ausentes

---

### **FASE 1: Criar Backup do Arquivo de Configuração**

**Objetivo:** Criar backup do arquivo `www.conf` antes de modificações

**Tarefas:**

1. **Criar backup com timestamp:**
   ```bash
   cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_$(date +%Y%m%d_%H%M%S)
   ```

2. **Verificar backup criado:**
   ```bash
   ls -lh /etc/php/8.3/fpm/pool.d/www.conf.backup_*
   ```

3. **Calcular hash SHA256 do arquivo original:**
   ```bash
   sha256sum /etc/php/8.3/fpm/pool.d/www.conf
   ```

**Critério de Sucesso:**
- ✅ Backup criado com sucesso
- ✅ Hash SHA256 calculado e documentado
- ✅ Backup pode ser restaurado se necessário

---

### **FASE 2: Criar Arquivo de Configuração Localmente**

**Objetivo:** Criar arquivo localmente com as configurações necessárias

**Tarefas:**

1. **Baixar arquivo atual do servidor:**
   ```bash
   scp root@65.108.156.14:/etc/php/8.3/fpm/pool.d/www.conf WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/www.conf.dev.backup_$(date +%Y%m%d_%H%M%S)
   ```

2. **Ler arquivo baixado e identificar seção `[www]`**

3. **Adicionar variáveis de ambiente após outras variáveis `env[]` existentes:**
   ```ini
   env[APP_BASE_DIR] = /var/www/html/dev/root
   env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br
   ```

4. **Salvar arquivo modificado localmente:**
   - `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/www.conf.dev_APP_BASE_DIR_20251118`

**Critério de Sucesso:**
- ✅ Arquivo baixado do servidor
- ✅ Arquivo modificado localmente
- ✅ Variáveis adicionadas corretamente
- ✅ Sintaxe INI válida

---

### **FASE 3: Verificar Sintaxe do Arquivo Modificado**

**Objetivo:** Verificar que arquivo modificado tem sintaxe válida

**Tarefas:**

1. **Copiar arquivo modificado para servidor temporariamente:**
   ```bash
   scp WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/www.conf.dev_APP_BASE_DIR_20251118 root@65.108.156.14:/tmp/www.conf.test
   ```

2. **Verificar sintaxe no servidor:**
   ```bash
   ssh root@65.108.156.14 "php-fpm8.3 -t -y /tmp/www.conf.test"
   ```

3. **Analisar resultado da verificação:**
   - ✅ **Se sintaxe válida:** Prosseguir para FASE 4
   - ❌ **Se sintaxe inválida:** Executar diagnóstico detalhado

4. **Diagnóstico em caso de erro de sintaxe:**
   ```bash
   # Capturar saída completa do erro
   ssh root@65.108.156.14 "php-fpm8.3 -t -y /tmp/www.conf.test 2>&1" > sintaxe_erro.log
   
   # Verificar linha específica do erro
   ssh root@65.108.156.14 "grep -n 'env\[APP_BASE_DIR\]' /tmp/www.conf.test"
   ssh root@65.108.156.14 "grep -n 'env\[APP_BASE_URL\]' /tmp/www.conf.test"
   
   # Verificar formato INI geral
   ssh root@65.108.156.14 "cat /tmp/www.conf.test | grep -A 2 -B 2 'env\[APP_BASE'"
   ```

5. **Correção de erros comuns:**
   - **Erro: "unexpected character"** → Verificar espaços em branco ou caracteres especiais
   - **Erro: "unknown directive"** → Verificar se variáveis estão na seção `[www]`
   - **Erro: "duplicate directive"** → Verificar se variáveis já existem no arquivo original
   - **Solução:** Corrigir arquivo localmente e repetir FASE 3

6. **Verificação adicional após correção:**
   ```bash
   # Verificar se arquivo foi corrigido corretamente
   ssh root@65.108.156.14 "php-fpm8.3 -t -y /tmp/www.conf.test"
   
   # Se ainda houver erro, documentar e considerar rollback
   if [ $? -ne 0 ]; then
       echo "ERRO: Sintaxe ainda inválida após correção"
       echo "Considerar restaurar backup e revisar processo"
   fi
   ```

**Critério de Sucesso:**
- ✅ Sintaxe do PHP-FPM válida
- ✅ Nenhum erro de configuração reportado
- ✅ Arquivo pronto para substituir original
- ✅ Erros diagnosticados e corrigidos (se houver)

**Procedimento de Recuperação em Caso de Falha:**
- Se sintaxe inválida persistir após 2 tentativas de correção:
  1. Restaurar arquivo original do backup (FASE 1)
  2. Revisar processo de modificação (FASE 2)
  3. Verificar se arquivo original tem sintaxe válida
  4. Considerar abordagem alternativa (editar diretamente no servidor com backup)

---

### **FASE 4: Aplicar Configuração no Servidor**

**Objetivo:** Substituir arquivo original pelo modificado

**Tarefas:**

1. **Copiar arquivo modificado para servidor:**
   ```bash
   scp WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/www.conf.dev_APP_BASE_DIR_20251118 root@65.108.156.14:/etc/php/8.3/fpm/pool.d/www.conf
   ```

2. **Verificar hash SHA256 após cópia:**
   ```bash
   # Local
   Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\www.conf.dev_APP_BASE_DIR_20251118" -Algorithm SHA256
   
   # Servidor
   ssh root@65.108.156.14 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf"
   ```

3. **Verificar sintaxe novamente:**
   ```bash
   ssh root@65.108.156.14 "php-fpm8.3 -t"
   ```

**Critério de Sucesso:**
- ✅ Arquivo copiado com sucesso
- ✅ Hash SHA256 coincide (case-insensitive)
- ✅ Sintaxe PHP-FPM válida

---

### **FASE 5: Reiniciar PHP-FPM**

**Objetivo:** Aplicar novas configurações reiniciando PHP-FPM

**Tarefas:**

1. **Verificar estado atual antes de reiniciar:**
   ```bash
   # Verificar se PHP-FPM está rodando
   ssh root@65.108.156.14 "systemctl is-active php8.3-fpm"
   
   # Verificar processos ativos
   ssh root@65.108.156.14 "ps aux | grep php-fpm | grep -v grep"
   
   # Verificar última modificação do arquivo de configuração
   ssh root@65.108.156.14 "stat /etc/php/8.3/fpm/pool.d/www.conf | grep Modify"
   ```

2. **Reiniciar PHP-FPM 8.3:**
   ```bash
   ssh root@65.108.156.14 "systemctl restart php8.3-fpm"
   ```

3. **Aguardar estabilização (2 segundos):**
   ```bash
   sleep 2
   ```

4. **Verificar status do serviço:**
   ```bash
   ssh root@65.108.156.14 "systemctl status php8.3-fpm --no-pager"
   ```

5. **Diagnóstico detalhado se serviço não iniciar:**
   ```bash
   # Verificar se serviço está ativo
   STATUS=$(ssh root@65.108.156.14 "systemctl is-active php8.3-fpm")
   
   if [ "$STATUS" != "active" ]; then
       echo "ERRO: PHP-FPM não está ativo. Status: $STATUS"
       
       # Verificar logs detalhados
       ssh root@65.108.156.14 "journalctl -u php8.3-fpm -n 50 --no-pager"
       
       # Verificar sintaxe novamente
       ssh root@65.108.156.14 "php-fpm8.3 -t"
       
       # Verificar permissões do arquivo
       ssh root@65.108.156.14 "ls -la /etc/php/8.3/fpm/pool.d/www.conf"
       
       # Verificar se há processos órfãos
       ssh root@65.108.156.14 "ps aux | grep php-fpm"
   fi
   ```

6. **Verificar logs por erros:**
   ```bash
   # Logs do systemd
   ssh root@65.108.156.14 "journalctl -u php8.3-fpm -n 30 --no-pager"
   
   # Logs do PHP-FPM
   ssh root@65.108.156.14 "tail -n 30 /var/log/php8.3-fpm.log"
   
   # Verificar erros específicos
   ssh root@65.108.156.14 "grep -i 'error\|fatal\|warning' /var/log/php8.3-fpm.log | tail -n 20"
   ```

7. **Verificar processos PHP-FPM:**
   ```bash
   # Verificar se processos estão rodando
   PROCESS_COUNT=$(ssh root@65.108.156.14 "ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l")
   
   if [ "$PROCESS_COUNT" -eq 0 ]; then
       echo "ERRO: Nenhum processo PHP-FPM encontrado"
       echo "Considerar rollback"
   else
       echo "✅ Processos PHP-FPM encontrados: $PROCESS_COUNT"
   fi
   ```

**Critério de Sucesso:**
- ✅ PHP-FPM reiniciado com sucesso
- ✅ Serviço está rodando (`active (running)`)
- ✅ Nenhum erro nos logs
- ✅ Processos PHP-FPM ativos

**Procedimento de Recuperação em Caso de Falha:**
- Se PHP-FPM não iniciar após reinício:
  1. Verificar sintaxe do arquivo de configuração novamente
  2. Verificar logs detalhados para identificar erro específico
  3. Se erro não puder ser corrigido rapidamente, executar rollback (ver seção "PLANO DE ROLLBACK")
  4. Após rollback, verificar se serviço volta a funcionar
  5. Revisar modificações antes de tentar novamente

---

### **FASE 6: Verificar Variáveis de Ambiente**

**Objetivo:** Confirmar que variáveis estão disponíveis via `$_ENV`

**Tarefas:**

1. **Criar script de teste temporário:**
   ```php
   <?php
   header('Content-Type: application/json');
   
   $result = [
       'APP_BASE_DIR' => $_ENV['APP_BASE_DIR'] ?? 'NÃO DEFINIDO',
       'APP_BASE_URL' => $_ENV['APP_BASE_URL'] ?? 'NÃO DEFINIDO',
       'PHP_VERSION' => PHP_VERSION,
       'SAPI' => php_sapi_name(),
       'variables_order' => ini_get('variables_order'),
       'all_env_vars' => []
   ];
   
   // Listar todas as variáveis de ambiente que começam com APP_
   foreach ($_ENV as $key => $value) {
       if (strpos($key, 'APP_') === 0) {
           $result['all_env_vars'][$key] = $value;
       }
   }
   
   echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
   ?>
   ```

2. **Salvar script localmente:**
   - Salvar como `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/TMP/test_env_vars.php`

3. **Copiar script para servidor:**
   ```bash
   scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\TMP\test_env_vars.php" root@65.108.156.14:/var/www/html/dev/root/TMP/test_env_vars.php
   ```

4. **Verificar se arquivo foi copiado corretamente:**
   ```bash
   ssh root@65.108.156.14 "ls -la /var/www/html/dev/root/TMP/test_env_vars.php"
   ```

5. **Acessar via HTTP e verificar resposta:**
   ```powershell
   try {
       $response = Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/TMP/test_env_vars.php" -UseBasicParsing -ErrorAction Stop
       $jsonResult = $response.Content | ConvertFrom-Json
       
       Write-Host "Status HTTP: $($response.StatusCode)" -ForegroundColor Green
       Write-Host "APP_BASE_DIR: $($jsonResult.APP_BASE_DIR)" -ForegroundColor $(if ($jsonResult.APP_BASE_DIR -eq '/var/www/html/dev/root') { 'Green' } else { 'Red' })
       Write-Host "APP_BASE_URL: $($jsonResult.APP_BASE_URL)" -ForegroundColor $(if ($jsonResult.APP_BASE_URL -eq 'https://dev.bssegurosimediato.com.br') { 'Green' } else { 'Red' })
       Write-Host "PHP Version: $($jsonResult.PHP_VERSION)" -ForegroundColor Gray
       Write-Host "SAPI: $($jsonResult.SAPI)" -ForegroundColor Gray
       Write-Host "variables_order: $($jsonResult.variables_order)" -ForegroundColor Gray
       
       # Verificar se variáveis estão corretas
       if ($jsonResult.APP_BASE_DIR -ne '/var/www/html/dev/root') {
           Write-Host "ERRO: APP_BASE_DIR não está correto!" -ForegroundColor Red
       }
       if ($jsonResult.APP_BASE_URL -ne 'https://dev.bssegurosimediato.com.br') {
           Write-Host "ERRO: APP_BASE_URL não está correto!" -ForegroundColor Red
       }
   } catch {
       Write-Host "ERRO ao acessar endpoint: $($_.Exception.Message)" -ForegroundColor Red
       Write-Host "Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
       
       # Diagnóstico adicional
       Write-Host "`nDiagnóstico:" -ForegroundColor Yellow
       Write-Host "1. Verificar se arquivo existe no servidor" -ForegroundColor Gray
       Write-Host "2. Verificar permissões do arquivo" -ForegroundColor Gray
       Write-Host "3. Verificar logs do PHP-FPM" -ForegroundColor Gray
       Write-Host "4. Verificar se PHP-FPM está rodando" -ForegroundColor Gray
   }
   ```

6. **Diagnóstico se variáveis não estiverem disponíveis:**
   ```bash
   # Verificar se variáveis estão no arquivo de configuração
   ssh root@65.108.156.14 "grep -E 'env\[APP_BASE_DIR\]|env\[APP_BASE_URL\]' /etc/php/8.3/fpm/pool.d/www.conf"
   
   # Verificar se clear_env está configurado corretamente
   ssh root@65.108.156.14 "grep 'clear_env' /etc/php/8.3/fpm/pool.d/www.conf"
   
   # Verificar variables_order no php.ini
   ssh root@65.108.156.14 "grep 'variables_order' /etc/php/8.3/fpm/php.ini | grep -v '^;'"
   
   # Testar via CLI (não deve funcionar, mas ajuda no diagnóstico)
   ssh root@65.108.156.14 "php -r \"echo getenv('APP_BASE_DIR') ?: 'NÃO DEFINIDO VIA CLI';\""
   ```

7. **Verificar valores esperados:**
   - `APP_BASE_DIR` deve ser `/var/www/html/dev/root`
   - `APP_BASE_URL` deve ser `https://dev.bssegurosimediato.com.br`
   - `variables_order` deve conter `E` (Environment)
   - `clear_env` deve ser `no` (se configurado)

**Critério de Sucesso:**
- ✅ Variáveis disponíveis via `$_ENV`
- ✅ Valores corretos conforme especificação
- ✅ Acessíveis via web (PHP-FPM)
- ✅ `variables_order` contém `E`
- ✅ Nenhum erro ao acessar endpoint de teste

**Procedimento de Recuperação em Caso de Falha:**
- Se variáveis não estiverem disponíveis:
  1. Verificar se variáveis estão no arquivo de configuração
  2. Verificar se `clear_env = no` está configurado
  3. Verificar se `variables_order` contém `E` no php.ini
  4. Reiniciar PHP-FPM novamente (FASE 5)
  5. Se persistir, verificar se há conflito com outras configurações
  6. Considerar rollback se problema não puder ser resolvido

---

### **FASE 7: Testar Endpoint de Email**

**Objetivo:** Verificar que endpoint funciona sem HTTP 500

**Tarefas:**

1. **Preparar payload de teste:**
   ```powershell
   $payload = @{
       ddd = "11"
       celular = "987654321"
       momento = "test"
       momento_descricao = "Teste configuração APP_BASE_DIR"
   } | ConvertTo-Json
   ```

2. **Testar endpoint via HTTP POST:**
   ```powershell
   try {
       $response = Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php" -Method POST -Headers @{"Content-Type"="application/json"} -Body $payload -UseBasicParsing -ErrorAction Stop
       
       Write-Host "✅ Status HTTP: $($response.StatusCode)" -ForegroundColor Green
       
       # Tentar parsear JSON
       try {
           $jsonResult = $response.Content | ConvertFrom-Json
           Write-Host "✅ Resposta JSON válida" -ForegroundColor Green
           Write-Host "Conteúdo:" -ForegroundColor Cyan
           Write-Host ($jsonResult | ConvertTo-Json -Depth 5) -ForegroundColor Gray
           
           # Verificar se há erros na resposta
           if ($jsonResult.error) {
               Write-Host "⚠️ Resposta contém erro: $($jsonResult.error)" -ForegroundColor Yellow
               
               # Verificar se erro está relacionado a APP_BASE_DIR
               if ($jsonResult.error -like '*APP_BASE_DIR*') {
                   Write-Host "❌ ERRO CRÍTICO: Erro relacionado a APP_BASE_DIR!" -ForegroundColor Red
                   Write-Host "Variável não está disponível corretamente" -ForegroundColor Red
               }
           }
           
           # Verificar se sucesso está presente
           if ($jsonResult.success -eq $true) {
               Write-Host "✅ Endpoint funcionando corretamente" -ForegroundColor Green
           } else {
               Write-Host "⚠️ Endpoint retornou success=false" -ForegroundColor Yellow
           }
       } catch {
           Write-Host "⚠️ Resposta não é JSON válido" -ForegroundColor Yellow
           Write-Host "Conteúdo (primeiros 500 caracteres):" -ForegroundColor Gray
           Write-Host $response.Content.Substring(0, [Math]::Min(500, $response.Content.Length)) -ForegroundColor Gray
       }
   } catch {
       $statusCode = $_.Exception.Response.StatusCode.value__
       Write-Host "❌ ERRO ao acessar endpoint" -ForegroundColor Red
       Write-Host "Status HTTP: $statusCode" -ForegroundColor Red
       Write-Host "Mensagem: $($_.Exception.Message)" -ForegroundColor Red
       
       # Diagnóstico detalhado para HTTP 500
       if ($statusCode -eq 500) {
           Write-Host "`n🔍 DIAGNÓSTICO HTTP 500:" -ForegroundColor Yellow
           Write-Host "1. Verificar logs do PHP-FPM" -ForegroundColor Gray
           Write-Host "2. Verificar se config.php está carregando corretamente" -ForegroundColor Gray
           Write-Host "3. Verificar se APP_BASE_DIR está disponível" -ForegroundColor Gray
           Write-Host "4. Verificar logs de erro do servidor web" -ForegroundColor Gray
           
           # Tentar capturar conteúdo de erro
           try {
               $errorStream = $_.Exception.Response.GetResponseStream()
               $reader = New-Object System.IO.StreamReader($errorStream)
               $errorContent = $reader.ReadToEnd()
               Write-Host "`nConteúdo do erro (primeiros 1000 caracteres):" -ForegroundColor Gray
               Write-Host $errorContent.Substring(0, [Math]::Min(1000, $errorContent.Length)) -ForegroundColor Gray
           } catch {
               Write-Host "Não foi possível capturar conteúdo do erro" -ForegroundColor Gray
           }
       }
   }
   ```

3. **Verificar logs do servidor após teste:**
   ```bash
   # Verificar logs do PHP-FPM
   ssh root@65.108.156.14 "tail -n 30 /var/log/php8.3-fpm.log | grep -i 'error\|fatal\|APP_BASE_DIR'"
   
   # Verificar logs do Nginx (se disponível)
   ssh root@65.108.156.14 "tail -n 20 /var/log/nginx/error.log 2>/dev/null || echo 'Logs do Nginx não disponíveis'"
   ```

4. **Verificar resposta esperada:**
   - Status HTTP deve ser 200 (não 500)
   - Resposta deve ser JSON válido
   - Não deve conter mensagem de erro sobre `APP_BASE_DIR`
   - Campo `success` deve ser `true` (se presente)

**Critério de Sucesso:**
- ✅ Endpoint retorna HTTP 200
- ✅ Resposta JSON válida
- ✅ Nenhum erro relacionado a `APP_BASE_DIR`
- ✅ Endpoint processa requisição corretamente

**Procedimento de Recuperação em Caso de Falha:**
- Se endpoint retornar HTTP 500:
  1. Verificar logs do PHP-FPM para erro específico
  2. Verificar se `config.php` está carregando (FASE 8)
  3. Verificar se variáveis estão disponíveis (FASE 6)
  4. Se erro persistir, verificar se há outros problemas não relacionados a `APP_BASE_DIR`
  5. Considerar rollback se problema não puder ser resolvido rapidamente

---

### **FASE 8: Testar config.php**

**Objetivo:** Verificar que `config.php` carrega sem lançar exceção

**Tarefas:**

1. **Criar script de teste:**
   ```php
   <?php
   header('Content-Type: application/json');
   try {
       require_once __DIR__ . '/../config.php';
       $baseDir = getBaseDir();
       $baseUrl = getBaseUrl();
       echo json_encode([
           'success' => true,
           'APP_BASE_DIR' => $baseDir,
           'APP_BASE_URL' => $baseUrl
       ], JSON_PRETTY_PRINT);
   } catch (Exception $e) {
       http_response_code(500);
       echo json_encode([
           'success' => false,
           'error' => $e->getMessage(),
           'file' => $e->getFile(),
           'line' => $e->getLine()
       ], JSON_PRETTY_PRINT);
   }
   ?>
   ```

2. **Copiar e testar:**
   ```bash
   scp test_config.php root@65.108.156.14:/var/www/html/dev/root/TMP/test_config.php
   ```

3. **Acessar via HTTP e verificar:**
   ```powershell
   $response = Invoke-WebRequest -Uri "https://dev.bssegurosimediato.com.br/TMP/test_config.php" -UseBasicParsing
   $response.Content | ConvertFrom-Json
   ```

**Critério de Sucesso:**
- ✅ `config.php` carrega sem exceção
- ✅ `getBaseDir()` retorna valor correto
- ✅ `getBaseUrl()` retorna valor correto

---

### **FASE 9: Limpeza**

**Objetivo:** Remover arquivos temporários de teste

**Tarefas:**

1. **Remover scripts de teste do servidor:**
   ```bash
   ssh root@65.108.156.14 "rm -f /var/www/html/dev/root/TMP/test_env_vars.php /var/www/html/dev/root/TMP/test_config.php"
   ```

2. **Manter arquivos locais para documentação:**
   - Manter backup do servidor
   - Manter arquivo modificado localmente

**Critério de Sucesso:**
- ✅ Arquivos temporários removidos
- ✅ Arquivos de documentação mantidos

---

## 🔄 PLANO DE ROLLBACK

### **Se Algo Der Errado:**

1. **Restaurar backup do arquivo original:**
   ```bash
   ssh root@65.108.156.14 "cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf"
   ```

2. **Verificar sintaxe:**
   ```bash
   ssh root@65.108.156.14 "php-fpm8.3 -t"
   ```

3. **Reiniciar PHP-FPM:**
   ```bash
   ssh root@65.108.156.14 "systemctl restart php8.3-fpm"
   ```

4. **Verificar status:**
   ```bash
   ssh root@65.108.156.14 "systemctl status php8.3-fpm"
   ```

**Critério de Rollback:**
- ✅ Arquivo original restaurado
- ✅ PHP-FPM funcionando normalmente
- ✅ Sistema voltou ao estado anterior

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

- [ ] FASE 0: Estado atual verificado
- [ ] FASE 1: Backup criado
- [ ] FASE 2: Arquivo modificado localmente
- [ ] FASE 3: Sintaxe verificada
- [ ] FASE 4: Configuração aplicada no servidor
- [ ] FASE 5: PHP-FPM reiniciado
- [ ] FASE 6: Variáveis verificadas via web
- [ ] FASE 7: Endpoint de email testado
- [ ] FASE 8: config.php testado
- [ ] FASE 9: Limpeza realizada
- [ ] Hash SHA256 verificado após cópia
- [ ] Documentação atualizada

---

## 📊 MATRIZ DE RISCOS

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Sintaxe inválida no arquivo | Baixa | Alto | Verificar sintaxe antes de aplicar (FASE 3) |
| PHP-FPM não reinicia | Baixa | Alto | Verificar logs e status (FASE 5) |
| Variáveis não disponíveis | Média | Alto | Testar via web após reiniciar (FASE 6) |
| Conflito com outras variáveis | Baixa | Médio | Verificar estado atual primeiro (FASE 0) |
| Perda de outras configurações | Baixa | Alto | Criar backup antes de modificar (FASE 1) |

---

## 📝 NOTAS IMPORTANTES

1. ⚠️ **IMPORTANTE:** Este projeto é específico para ambiente DEV
2. ⚠️ **IMPORTANTE:** Valores são específicos para servidor DEV (`65.108.156.14`)
3. ⚠️ **IMPORTANTE:** Após implementação, será necessário criar projeto similar para PROD
4. ✅ **OBSERVAÇÃO:** Variáveis devem ser configuradas no arquivo de pool, não no systemd
5. ✅ **OBSERVAÇÃO:** PHP-FPM lê variáveis do arquivo de pool, não do systemd

---

## 📋 PRÓXIMOS PASSOS (Pós-Implementação)

1. ✅ Criar projeto similar para ambiente PROD
2. ✅ Documentar processo para futuras referências
3. ✅ Adicionar variáveis à documentação de arquitetura
4. ✅ Verificar se outras funcionalidades dependem dessas variáveis

---

---

## 📊 MELHORIAS IMPLEMENTADAS (Versão 1.1.0)

### **1. Histórico de Versões**
- ✅ Seção "HISTÓRICO DE VERSÕES" adicionada
- ✅ Versão 1.0.0 documentada como versão inicial
- ✅ Versão 1.1.0 documentada com melhorias

### **2. Tratamento de Erros Aprimorado**
- ✅ FASE 3: Diagnóstico detalhado de erros de sintaxe
- ✅ FASE 3: Procedimento de recuperação em caso de falha
- ✅ FASE 5: Diagnóstico detalhado se PHP-FPM não iniciar
- ✅ FASE 5: Verificação de processos e logs detalhados
- ✅ FASE 6: Tratamento de erros ao acessar endpoint de teste
- ✅ FASE 6: Diagnóstico se variáveis não estiverem disponíveis
- ✅ FASE 7: Análise detalhada de resposta JSON
- ✅ FASE 7: Diagnóstico específico para HTTP 500

### **3. Detalhes de Diagnóstico Adicionados**
- ✅ FASE 3: Verificação de linha específica do erro
- ✅ FASE 3: Verificação de formato INI geral
- ✅ FASE 5: Verificação de estado antes de reiniciar
- ✅ FASE 5: Verificação de processos PHP-FPM
- ✅ FASE 6: Verificação de `variables_order` e `clear_env`
- ✅ FASE 6: Listagem de todas as variáveis APP_*
- ✅ FASE 7: Captura de conteúdo de erro em caso de falha
- ✅ FASE 7: Verificação de logs após teste

---

**Documento criado em:** 18/11/2025  
**Última atualização:** 18/11/2025  
**Versão:** 1.1.0  
**Status:** 📝 **PLANO DE PROJETO - APRIMORADO**

