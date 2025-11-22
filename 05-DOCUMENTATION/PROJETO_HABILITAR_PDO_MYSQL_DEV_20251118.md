# 🔧 PROJETO: Habilitar Extensão pdo_mysql no PHP do Servidor DEV

**Data de Criação:** 18/11/2025  
**Status:** 📝 **AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.1.0  
**Última Atualização:** 18/11/2025 - Correções após auditoria  
**Prioridade:** 🔴 **CRÍTICA** (necessária para funcionamento do sistema de logging unificado)  
**Ambiente:** 🟢 **DESENVOLVIMENTO** (`dev.bssegurosimediato.com.br` - IP: 65.108.156.14)

---

## 🎯 OBJETIVO

Habilitar a extensão `pdo_mysql` no PHP do servidor de desenvolvimento para permitir que o `ProfessionalLogger` funcione corretamente, resolvendo o erro `Undefined constant PDO::MYSQL_ATTR_INIT_COMMAND` que está causando HTTP 500 no endpoint de envio de email.

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### **Objetivos do Usuário com o Projeto:**

O usuário solicitou um projeto para habilitar a extensão `pdo_mysql` no PHP do servidor de desenvolvimento, com documentação minuciosa para implementação posterior em produção.

### **Funcionalidades Solicitadas:**

1. ✅ **Habilitar extensão `pdo_mysql` no servidor DEV:**
   - Instalar extensão se não estiver instalada
   - Configurar extensão no PHP-FPM
   - Verificar se extensão está funcionando corretamente

2. ✅ **Documentar minuciosamente para produção:**
   - Criar guia completo de implementação
   - Documentar procedimentos de teste
   - Documentar procedimentos de rollback
   - Incluir checklist de verificação

### **Requisitos Não-Funcionais:**

1. ✅ **Não quebrar funcionalidades existentes:**
   - Não alterar outras extensões PHP
   - Não alterar configurações existentes
   - Manter compatibilidade com código atual

2. ✅ **Testes completos após implementação:**
   - Verificar se extensão está habilitada
   - Testar conexão com banco de dados
   - Testar endpoint de email
   - Verificar se logs estão sendo inseridos

3. ✅ **Documentação completa:**
   - Procedimentos passo-a-passo
   - Comandos exatos a serem executados
   - Procedimentos de rollback
   - Checklist de verificação

### **Critérios de Aceitação:**

1. ✅ Extensão `pdo_mysql` habilitada e funcionando
2. ✅ `ProfessionalLogger` pode ser instanciado sem erros
3. ✅ Endpoint de email retorna HTTP 200 (não mais HTTP 500)
4. ✅ Logs são inseridos no banco de dados corretamente
5. ✅ Documentação completa para produção criada

---

## 📊 ANÁLISE DO ESTADO ATUAL

### **Problema Identificado:**

**Erro:** `Undefined constant PDO::MYSQL_ATTR_INIT_COMMAND`

**Causa Raiz:**
- Extensão `pdo_mysql` não está habilitada no PHP do servidor
- Apenas `PDO` está disponível (sem driver MySQL)
- Constante `PDO::MYSQL_ATTR_INIT_COMMAND` não existe porque extensão não está carregada

**Impacto:**
- ❌ `ProfessionalLogger` não pode ser instanciado
- ❌ Conexão com banco de dados não pode ser criada
- ❌ Logs não podem ser inseridos no banco
- ❌ Erro fatal causa HTTP 500 no endpoint de email
- ✅ Email ainda é enviado (AWS SES funciona independentemente)

### **Informações do Servidor:**

**Ambiente:** Desenvolvimento  
**Servidor:** `dev.bssegurosimediato.com.br`  
**IP:** `65.108.156.14`  
**Versão PHP:** PHP 8.4.14 (CLI)  
**Distribuição:** Ubuntu 24.04.3 LTS (Noble Numbat)  
**PHP-FPM:** PHP 8.4 (a ser verificado)

**Observação Importante:**
- ✅ PHP 8.4.14 está instalado
- ⚠️ Extensão `php8.3-mysql` está instalada (versão antiga)
- ❌ Extensão `php8.4-mysql` **NÃO** está instalada
- ⚠️ Links simbólicos em `/etc/php/8.4/fpm/conf.d/` apontam para PHP 8.3

### **Extensões Atuais:**

**Disponíveis:**
- ✅ `PDO` (genérico, sem driver MySQL)

**Não Disponíveis:**
- ❌ `pdo_mysql` (driver específico para MySQL)

---

## 🔧 FASES DO PROJETO

### **FASE 0: Pré-requisitos e Verificações Iniciais**

**Objetivo:** Verificar estado atual do servidor e preparar ambiente

**Tarefas:**

1. **Verificar versão do PHP:**
   ```bash
   php -v
   ```

2. **Verificar distribuição Linux:**
   ```bash
   cat /etc/os-release
   ```

3. **Verificar extensões PHP instaladas:**
   ```bash
   dpkg -l | grep -i 'php.*mysql'
   ```

4. **Verificar extensões PHP carregadas:**
   ```bash
   php -m | grep -i 'pdo\|mysql'
   ```

5. **Verificar diretório de configuração PHP-FPM:**
   ```bash
   php -i | grep -i 'Scan this dir for additional .ini files'
   ls -la /etc/php/*/fpm/conf.d/
   ```

6. **Verificar se extensão já está instalada mas não habilitada:**
   ```bash
   find /etc/php -name "*mysql*.ini" 2>/dev/null
   ```

7. **Verificar versão do PHP-FPM em uso (CRÍTICO):**
   ```bash
   # Verificar qual versão do PHP-FPM está realmente rodando
   systemctl list-units | grep -i 'php.*fpm'
   
   # Verificar status do PHP-FPM 8.4 especificamente
   systemctl status php8.4-fpm
   
   # Verificar versão do PHP-FPM via processo
   ps aux | grep php-fpm | head -n 1
   
   # Verificar versão do PHP-FPM via binário
   php-fpm8.4 -v 2>&1 || echo "PHP-FPM 8.4 não encontrado"
   ```

8. **Verificar repositórios configurados:**
   ```bash
   # Verificar se repositório necessário está configurado
   grep -r "ondrej/php" /etc/apt/sources.list.d/ 2>/dev/null
   
   # Verificar se pacote está disponível nos repositórios
   apt-cache search php8.4-mysql
   ```

**Critério de Sucesso:**
- ✅ Informações do servidor coletadas
- ✅ Estado atual das extensões identificado
- ✅ Versão do PHP-FPM em uso confirmada
- ✅ Disponibilidade do pacote verificada
- ✅ Próximos passos definidos

---

### **FASE 1: Instalação da Extensão pdo_mysql**

**Objetivo:** Instalar extensão `pdo_mysql` no servidor

**Tarefas:**

1. **Identificar versão exata do PHP:**
   ```bash
   php -v | head -n 1
   ```

2. **Atualizar lista de pacotes:**
   ```bash
   apt-get update
   ```

3. **Verificar disponibilidade do pacote ANTES de instalar (CRÍTICO):**
   ```bash
   # Verificar se pacote está disponível nos repositórios
   PACKAGE_AVAILABLE=$(apt-cache search php8.4-mysql | grep -i 'php8.4-mysql' | head -n 1)
   
   if [ -z "$PACKAGE_AVAILABLE" ]; then
       echo "⚠️ ATENÇÃO: Pacote php8.4-mysql não encontrado nos repositórios"
       echo "Verificando alternativas..."
       
       # Verificar pacotes alternativos
       apt-cache search php.*mysql | grep -i '8.4'
       
       # Verificar se repositório necessário está configurado
       if ! grep -r "ondrej/php" /etc/apt/sources.list.d/ > /dev/null 2>&1; then
           echo "❌ ERRO: Repositório ondrej/php não está configurado"
           echo "É necessário adicionar repositório antes de continuar"
           echo "Comando sugerido: add-apt-repository ppa:ondrej/php"
           exit 1
       fi
       
       echo "❌ ERRO: Pacote não disponível. Verificar repositórios ou versão do PHP"
       exit 1
   else
       echo "✅ Pacote php8.4-mysql encontrado: $PACKAGE_AVAILABLE"
   fi
   ```

4. **Instalar extensão pdo_mysql para PHP 8.4:**
   ```bash
   # IMPORTANTE: Instalar versão específica para PHP 8.4
   # Apenas executar se verificação anterior passou
   apt-get install -y php8.4-mysql
   
   # Verificar se instalação foi bem-sucedida
   if [ $? -eq 0 ]; then
       echo "✅ Extensão php8.4-mysql instalada com sucesso"
   else
       echo "❌ ERRO: Falha ao instalar extensão"
       exit 1
   fi
   ```

5. **Verificar instalação:**
   ```bash
   dpkg -l | grep -i 'php.*mysql'
   
   # Verificar especificamente php8.4-mysql
   dpkg -l | grep -i 'php8.4-mysql'
   
   # Verificar arquivos instalados
   dpkg -L php8.4-mysql 2>/dev/null | head -n 10
   ```

**Critério de Sucesso:**
- ✅ Pacote `php8.4-mysql` (ou equivalente) instalado
- ✅ Arquivos da extensão presentes no sistema

---

### **FASE 2: Habilitar Extensão no PHP-FPM**

**Objetivo:** Habilitar extensão no PHP-FPM para que esteja disponível via web

**Tarefas:**

1. **Verificar versão do PHP-FPM em uso (CRÍTICO - ANTES DE PROCEDER):**
   ```bash
   # Verificar qual versão do PHP-FPM está realmente rodando
   ACTIVE_FPM=$(systemctl list-units --type=service --state=running | grep -i 'php.*fpm' | head -n 1 | awk '{print $1}')
   
   if [ -z "$ACTIVE_FPM" ]; then
       echo "❌ ERRO: Nenhum serviço PHP-FPM encontrado rodando"
       exit 1
   fi
   
   echo "✅ Serviço PHP-FPM ativo: $ACTIVE_FPM"
   
   # Verificar se é PHP-FPM 8.4
   if [[ "$ACTIVE_FPM" == *"8.4"* ]]; then
       echo "✅ PHP-FPM 8.4 confirmado como versão ativa"
   else
       echo "⚠️ ATENÇÃO: Versão do PHP-FPM ativo não é 8.4"
       echo "Versão detectada: $ACTIVE_FPM"
       echo "Verificar se esta é a versão correta antes de continuar"
       read -p "Continuar mesmo assim? (s/N): " -n 1 -r
       echo
       if [[ ! $REPLY =~ ^[Ss]$ ]]; then
           echo "Operação cancelada pelo usuário"
           exit 1
       fi
   fi
   
   # Verificar status do PHP-FPM 8.4 especificamente
   systemctl status php8.4-fpm --no-pager | head -n 5
   ```

2. **Verificar se arquivo de configuração já existe:**
   ```bash
   ls -la /etc/php/8.4/fpm/conf.d/ | grep -i mysql
   ```

3. **Verificar se extensão foi instalada corretamente:**
   ```bash
   # Verificar biblioteca compartilhada
   find /usr/lib/php -name "*mysql*.so" 2>/dev/null
   
   # Verificar módulos disponíveis
   ls -la /etc/php/8.4/mods-available/ | grep -i mysql
   ```

4. **Habilitar extensão usando phpenmod (se disponível):**
   ```bash
   # Verificar se phpenmod está disponível
   which phpenmod
   
   # Se disponível, habilitar extensão
   phpenmod -v 8.4 mysql
   ```

5. **OU criar link simbólico manualmente:**
   ```bash
   # Verificar se arquivo de configuração existe em mods-available
   if [ -f /etc/php/8.4/mods-available/mysql.ini ]; then
       # Criar link simbólico em conf.d
       ln -s /etc/php/8.4/mods-available/mysql.ini /etc/php/8.4/fpm/conf.d/20-mysql.ini
   fi
   
   # Verificar também pdo_mysql especificamente
   if [ -f /etc/php/8.4/mods-available/pdo_mysql.ini ]; then
       ln -s /etc/php/8.4/mods-available/pdo_mysql.ini /etc/php/8.4/fpm/conf.d/20-pdo_mysql.ini
   fi
   ```

6. **Verificar arquivo php.ini do PHP-FPM:**
   ```bash
   php-fpm8.4 -i | grep -i 'Loaded Configuration File'
   ```

7. **Verificar se extensão está habilitada:**
   ```bash
   php-fpm8.4 -m | grep -i 'pdo_mysql'
   ```

**Critério de Sucesso:**
- ✅ Extensão `pdo_mysql` aparece na lista de módulos do PHP-FPM
- ✅ Arquivo de configuração presente em `/etc/php/8.4/fpm/conf.d/`

---

### **FASE 3: Reiniciar PHP-FPM**

**Objetivo:** Aplicar mudanças reiniciando serviço PHP-FPM

**Tarefas:**

1. **Verificar status atual do PHP-FPM:**
   ```bash
   systemctl status php8.4-fpm
   ```

2. **Testar configuração antes de reiniciar:**
   ```bash
   php-fpm8.4 -t
   ```

3. **Reiniciar PHP-FPM:**
   ```bash
   systemctl restart php8.4-fpm
   ```

4. **Verificar se reiniciou com sucesso:**
   ```bash
   systemctl status php8.4-fpm
   ```

**Critério de Sucesso:**
- ✅ PHP-FPM reiniciado sem erros
- ✅ Serviço está rodando corretamente

---

### **FASE 4: Verificação da Extensão**

**Objetivo:** Verificar se extensão está funcionando corretamente

**Tarefas:**

1. **Verificar extensão via CLI:**
   ```bash
   php -m | grep -i 'pdo_mysql'
   ```

2. **Verificar extensão via PHP-FPM (web):**
   ```bash
   # Criar arquivo temporário de teste
   echo "<?php phpinfo(); ?>" > /var/www/html/dev/root/TMP/test_pdo_mysql.php
   
   # Acessar via web e verificar seção PDO
   # https://dev.bssegurosimediato.com.br/TMP/test_pdo_mysql.php
   ```

3. **Verificar constante específica:**
   ```bash
   php -r "echo defined('PDO::MYSQL_ATTR_INIT_COMMAND') ? 'OK' : 'ERRO';"
   ```

4. **Testar conexão PDO MySQL:**
   ```bash
   php -r "
   try {
       \$pdo = new PDO('mysql:host=localhost;port=3306', 'root', '');
       echo 'Conexão OK';
   } catch (Exception \$e) {
       echo 'Erro: ' . \$e->getMessage();
   }
   "
   ```

**Critério de Sucesso:**
- ✅ Extensão `pdo_mysql` aparece na lista de módulos
- ✅ Constante `PDO::MYSQL_ATTR_INIT_COMMAND` está definida
- ✅ Conexão PDO MySQL funciona

---

### **FASE 5: Teste do ProfessionalLogger**

**Objetivo:** Verificar se `ProfessionalLogger` funciona corretamente após habilitar extensão

**Tarefas:**

1. **Criar script de teste:**
   ```php
   <?php
   // /var/www/html/dev/root/TMP/test_professional_logger.php
   error_reporting(E_ALL);
   ini_set('display_errors', 1);
   
   require_once __DIR__ . '/../ProfessionalLogger.php';
   
   try {
       $logger = new ProfessionalLogger();
       echo "✅ ProfessionalLogger instanciado com sucesso\n";
       
       $logId = $logger->insertLog([
           'level' => 'INFO',
           'category' => 'TEST',
           'message' => 'Teste de log após habilitar pdo_mysql',
           'data' => ['test' => true]
       ]);
       
       if ($logId !== false) {
           echo "✅ Log inserido com sucesso. ID: $logId\n";
       } else {
           echo "❌ Falha ao inserir log\n";
       }
   } catch (Exception $e) {
       echo "❌ Erro: " . $e->getMessage() . "\n";
       echo "Trace: " . $e->getTraceAsString() . "\n";
   }
   ?>
   ```

2. **Executar teste via CLI:**
   ```bash
   php /var/www/html/dev/root/TMP/test_professional_logger.php
   ```

3. **Executar teste via web:**
   ```bash
   # Acessar: https://dev.bssegurosimediato.com.br/TMP/test_professional_logger.php
   ```

**Critério de Sucesso:**
- ✅ `ProfessionalLogger` instancia sem erros
- ✅ Log é inserido no banco de dados com sucesso
- ✅ Nenhum erro relacionado a `PDO::MYSQL_ATTR_INIT_COMMAND`

---

### **FASE 6: Teste do Endpoint de Email**

**Objetivo:** Verificar se endpoint de email funciona corretamente após correção

**Tarefas:**

1. **Testar endpoint via HTTP:**
   ```bash
   curl -X POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php \
     -H "Content-Type: application/json" \
     -d '{
       "ddd": "11",
       "celular": "987654321",
       "momento": "test",
       "momento_descricao": "Teste após habilitar pdo_mysql"
     }'
   ```

2. **Verificar resposta:**
   - Deve retornar HTTP 200 (não mais HTTP 500)
   - Deve retornar JSON com `success: true`
   - Não deve ter erro `Undefined constant`

3. **Verificar logs no banco:**
   ```bash
   # Consultar logs via endpoint
   curl "https://dev.bssegurosimediato.com.br/TMP/query_logs_endpoint.php?limit=5&category=EMAIL"
   ```

**Critério de Sucesso:**
- ✅ Endpoint retorna HTTP 200
- ✅ Resposta JSON válida
- ✅ Logs são inseridos no banco de dados
- ✅ Nenhum erro relacionado a `PDO::MYSQL_ATTR_INIT_COMMAND`

---

### **FASE 7: Limpeza e Documentação**

**Objetivo:** Limpar arquivos temporários e documentar implementação

**Tarefas:**

1. **Remover arquivos temporários de teste:**
   ```bash
   rm -f /var/www/html/dev/root/TMP/test_pdo_mysql.php
   rm -f /var/www/html/dev/root/TMP/test_professional_logger.php
   ```

2. **Documentar versão da extensão instalada:**
   ```bash
   dpkg -l | grep -i 'php.*mysql' > /tmp/pdo_mysql_version.txt
   ```

3. **Criar documento de implementação para produção:**
   - Copiar este projeto
   - Adaptar para ambiente de produção
   - Incluir procedimentos de rollback
   - Incluir checklist de verificação

**Critério de Sucesso:**
- ✅ Arquivos temporários removidos
- ✅ Documentação criada
- ✅ Versão da extensão documentada

---

## 🔄 PLANO DE ROLLBACK

### **Cenário: Extensão Causa Problemas**

**Procedimento Detalhado:**

#### **ETAPA 1: Verificar Estado Antes do Rollback**

1. **Documentar estado atual:**
   ```bash
   # Criar backup do estado atual antes de rollback
   BACKUP_DIR="/tmp/rollback_backup_$(date +%Y%m%d_%H%M%S)"
   mkdir -p "$BACKUP_DIR"
   
   # Documentar extensões habilitadas
   php-fpm8.4 -m > "$BACKUP_DIR/extensions_before_rollback.txt"
   
   # Documentar arquivos de configuração
   ls -la /etc/php/8.4/fpm/conf.d/*mysql* > "$BACKUP_DIR/config_files_before_rollback.txt" 2>/dev/null || echo "Nenhum arquivo MySQL encontrado" > "$BACKUP_DIR/config_files_before_rollback.txt"
   
   # Documentar versão do PHP-FPM
   php-fpm8.4 -v > "$BACKUP_DIR/php_fpm_version.txt"
   
   echo "✅ Estado atual documentado em: $BACKUP_DIR"
   ```

2. **Verificar se extensão está realmente causando problemas:**
   ```bash
   # Verificar logs de erro do PHP-FPM
   tail -n 50 /var/log/php8.4-fpm.log | grep -i 'error\|fatal\|warning'
   
   # Verificar logs do Nginx
   tail -n 50 /var/log/nginx/error.log | grep -i 'php\|fpm'
   
   # Testar endpoint que estava falhando
   curl -X POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php \
     -H "Content-Type: application/json" \
     -d '{"ddd": "11", "celular": "999999999", "momento": "test"}' \
     -v 2>&1 | head -n 20
   ```

#### **ETAPA 2: Desabilitar Extensão**

3. **Identificar arquivos de configuração da extensão:**
   ```bash
   # Listar todos os arquivos relacionados a MySQL no PHP-FPM
   MYSQL_CONFIG_FILES=$(find /etc/php/8.4/fpm/conf.d/ -name "*mysql*" -o -name "*pdo*" 2>/dev/null)
   
   if [ -z "$MYSQL_CONFIG_FILES" ]; then
       echo "⚠️ Nenhum arquivo de configuração MySQL encontrado"
       echo "Verificando se extensão está habilitada de outra forma..."
       php-fpm8.4 -m | grep -i 'pdo_mysql'
   else
       echo "Arquivos encontrados:"
       echo "$MYSQL_CONFIG_FILES"
   fi
   ```

4. **Desabilitar extensão (método 1 - renomear arquivo):**
   ```bash
   # Renomear arquivo de configuração para desabilitar
   for config_file in $MYSQL_CONFIG_FILES; do
       if [ -f "$config_file" ]; then
           mv "$config_file" "${config_file}.disabled"
           echo "✅ Arquivo desabilitado: $config_file"
       fi
   done
   ```

5. **OU desabilitar extensão (método 2 - usar phpdismod):**
   ```bash
   # Se phpdismod estiver disponível
   if command -v phpdismod &> /dev/null; then
       phpdismod -v 8.4 mysql pdo_mysql
       echo "✅ Extensão desabilitada via phpdismod"
   fi
   ```

#### **ETAPA 3: Reiniciar PHP-FPM**

6. **Testar configuração antes de reiniciar:**
   ```bash
   # Testar configuração do PHP-FPM
   php-fpm8.4 -t
   
   if [ $? -ne 0 ]; then
       echo "❌ ERRO: Configuração do PHP-FPM inválida"
       echo "Restaurando arquivos antes do rollback..."
       for config_file in $MYSQL_CONFIG_FILES; do
           if [ -f "${config_file}.disabled" ]; then
               mv "${config_file}.disabled" "$config_file"
           fi
       done
       exit 1
   fi
   ```

7. **Reiniciar PHP-FPM:**
   ```bash
   systemctl restart php8.4-fpm
   
   # Aguardar alguns segundos para garantir que reiniciou
   sleep 3
   
   # Verificar se reiniciou com sucesso
   if systemctl is-active --quiet php8.4-fpm; then
       echo "✅ PHP-FPM reiniciado com sucesso"
   else
       echo "❌ ERRO: PHP-FPM não iniciou após rollback"
       echo "Verificar logs: systemctl status php8.4-fpm"
       exit 1
   fi
   ```

#### **ETAPA 4: Verificar Rollback**

8. **Verificar se extensão foi desabilitada:**
   ```bash
   # Verificar módulos carregados
   php-fpm8.4 -m | grep -i 'pdo_mysql'
   
   if [ $? -eq 0 ]; then
       echo "⚠️ ATENÇÃO: Extensão ainda aparece na lista de módulos"
       echo "Pode ser necessário reiniciar novamente ou verificar outros arquivos"
   else
       echo "✅ Extensão pdo_mysql não está mais carregada"
   fi
   
   # Verificar via CLI também
   php -m | grep -i 'pdo_mysql'
   ```

9. **Verificar se aplicação ainda funciona:**
   ```bash
   # Testar endpoint de email
   RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php \
     -H "Content-Type: application/json" \
     -d '{"ddd": "11", "celular": "999999999", "momento": "test"}')
   
   echo "Status HTTP do endpoint: $RESPONSE"
   
   if [ "$RESPONSE" = "200" ] || [ "$RESPONSE" = "500" ]; then
       echo "✅ Endpoint responde (mesmo que com erro, aplicação não quebrou)"
   else
       echo "⚠️ Endpoint retornou código inesperado: $RESPONSE"
   fi
   
   # Verificar logs de erro
   echo "Últimos erros do PHP-FPM:"
   tail -n 20 /var/log/php8.4-fpm.log | grep -i 'error\|fatal' || echo "Nenhum erro crítico encontrado"
   ```

10. **Documentar estado após rollback:**
    ```bash
    # Documentar estado após rollback
    php-fpm8.4 -m > "$BACKUP_DIR/extensions_after_rollback.txt"
    ls -la /etc/php/8.4/fpm/conf.d/*mysql* > "$BACKUP_DIR/config_files_after_rollback.txt" 2>/dev/null || echo "Nenhum arquivo MySQL encontrado" > "$BACKUP_DIR/config_files_after_rollback.txt"
    
    echo "✅ Estado após rollback documentado em: $BACKUP_DIR"
    ```

#### **ETAPA 5: Desinstalar Extensão (Opcional - Se Necessário)**

11. **Se necessário desinstalar completamente:**
    ```bash
    # ATENÇÃO: Apenas executar se realmente necessário
    # Desinstalar extensão
    apt-get remove -y php8.4-mysql
    
    # OU remover completamente (incluindo configurações)
    # apt-get purge -y php8.4-mysql
    
    echo "✅ Extensão desinstalada"
    ```

**Critério de Sucesso:**
- ✅ Estado antes do rollback documentado
- ✅ Extensão desabilitada com sucesso
- ✅ PHP-FPM reiniciado sem erros
- ✅ Extensão não aparece mais na lista de módulos
- ✅ Aplicação funciona (mesmo sem logs no banco)
- ✅ Estado após rollback documentado
- ✅ Logs de erro verificados

---

## ✅ CHECKLIST DE VERIFICAÇÃO

### **Antes da Implementação:**

- [ ] Backup do estado atual criado
- [ ] Versão do PHP identificada
- [ ] Versão do PHP-FPM em uso confirmada (CRÍTICO)
- [ ] Distribuição Linux identificada
- [ ] Extensões PHP atuais documentadas
- [ ] Disponibilidade do pacote verificada (CRÍTICO)
- [ ] Repositórios necessários verificados
- [ ] Procedimento de rollback revisado

### **Durante a Implementação:**

- [ ] FASE 0: Pré-requisitos verificados
- [ ] FASE 1: Extensão instalada
- [ ] FASE 2: Extensão habilitada no PHP-FPM
- [ ] FASE 3: PHP-FPM reiniciado
- [ ] FASE 4: Extensão verificada
- [ ] FASE 5: ProfessionalLogger testado
- [ ] FASE 6: Endpoint de email testado
- [ ] FASE 7: Limpeza e documentação concluídas

### **Após a Implementação:**

- [ ] Extensão `pdo_mysql` habilitada e funcionando
- [ ] `ProfessionalLogger` instancia sem erros
- [ ] Endpoint de email retorna HTTP 200
- [ ] Logs são inseridos no banco de dados
- [ ] Nenhum erro relacionado a `PDO::MYSQL_ATTR_INIT_COMMAND`
- [ ] Documentação para produção criada

---

## 📋 DOCUMENTAÇÃO PARA PRODUÇÃO

### **Adaptações Necessárias:**

1. **Alterar ambiente:**
   - Servidor: `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)
   - Caminho: `/var/www/html/prod/root/`

2. **Verificar versão do PHP em produção:**
   - Pode ser diferente da versão em DEV
   - Adaptar comandos de instalação conforme necessário

3. **Procedimentos de rollback mais rigorosos:**
   - Criar backup completo antes de iniciar
   - Testar em horário de baixo tráfego
   - Ter plano de rollback imediato

4. **Testes mais extensivos:**
   - Testar todos os endpoints que usam `ProfessionalLogger`
   - Verificar logs em produção
   - Monitorar erros após implementação

### **Checklist Específico para Produção:**

- [ ] Backup completo do servidor criado
- [ ] Horário de baixo tráfego identificado
- [ ] Equipe de suporte notificada
- [ ] Plano de rollback revisado e testado
- [ ] Monitoramento configurado
- [ ] Testes de validação preparados

---

## 🚨 PONTOS DE ATENÇÃO

1. **Versão do PHP-FPM (CRÍTICO):**
   - ⚠️ **VERIFICAR ANTES DE PROCEDER:** Confirmar qual versão do PHP-FPM está realmente em uso
   - Pode ser PHP 8.3 mesmo que PHP CLI seja 8.4
   - Comando: `systemctl list-units | grep -i 'php.*fpm'`
   - Sempre verificar antes de instalar extensão

2. **Disponibilidade do Pacote (CRÍTICO):**
   - ⚠️ **VERIFICAR ANTES DE INSTALAR:** Confirmar se pacote `php8.4-mysql` está disponível
   - Pode não estar disponível se repositório não estiver configurado
   - Comando: `apt-cache search php8.4-mysql`
   - Se não disponível, adicionar repositório `ppa:ondrej/php` primeiro

3. **Versão do PHP:**
   - Verificar versão exata antes de instalar extensão
   - Usar versão específica: `php8.4-mysql` (não genérico `php-mysql`)
   - Verificar compatibilidade com distribuição Linux

4. **PHP-FPM vs CLI:**
   - Extensão pode estar disponível no CLI mas não no PHP-FPM
   - Sempre verificar ambos os contextos
   - Extensão deve estar habilitada especificamente no PHP-FPM

5. **Reinicialização:**
   - PHP-FPM precisa ser reiniciado após habilitar extensão
   - Verificar se reinicialização não causa downtime
   - Testar configuração antes de reiniciar: `php-fpm8.4 -t`

6. **Compatibilidade:**
   - Verificar se extensão é compatível com versão do PHP
   - Verificar se não conflita com outras extensões
   - Verificar se extensão `php8.3-mysql` existente não causa conflito

7. **Repositórios:**
   - Verificar se repositório `ppa:ondrej/php` está configurado
   - Necessário para pacotes PHP 8.4 no Ubuntu
   - Se não estiver, adicionar antes de instalar extensão

8. **Produção:**
   - ⚠️ **PROCEDIMENTO NÃO DEFINIDO** para produção
   - ⚠️ **BLOQUEAR** qualquer ação em produção até procedimento oficial
   - ⚠️ **EMITIR ALERTA** se detectar tentativa de acesso a produção

---

## 📊 MATRIZ DE RISCOS

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Extensão não compatível com PHP 8.4 | Baixa | Alto | Verificar compatibilidade antes de instalar |
| Pacote php8.4-mysql não disponível | Média | Alto | Verificar disponibilidade ANTES de instalar (FASE 1, tarefa 3) |
| Versão errada do PHP-FPM | Média | Alto | Verificar versão do PHP-FPM ANTES de proceder (FASE 0, tarefa 7 e FASE 2, tarefa 1) |
| Repositório não configurado | Média | Alto | Verificar repositórios ANTES de instalar (FASE 0, tarefa 8) |
| Reinicialização causa downtime | Média | Médio | Agendar em horário de baixo tráfego |
| Conflito com extensão php8.3-mysql | Média | Médio | Verificar extensões instaladas antes, documentar conflito potencial |
| Problemas após implementação | Baixa | Alto | Ter plano de rollback detalhado pronto |
| Rollback não funciona corretamente | Baixa | Alto | Plano de rollback detalhado com verificações (ETAPAS 1-5) |

---

---

## 📝 HISTÓRICO DE VERSÕES

### **Versão 1.1.0 (18/11/2025)**
- ✅ Adicionada verificação de disponibilidade do pacote antes de instalar (FASE 1, tarefa 3)
- ✅ Adicionada verificação de versão do PHP-FPM em uso (FASE 0, tarefa 7 e FASE 2, tarefa 1)
- ✅ Adicionada verificação de repositórios configurados (FASE 0, tarefa 8)
- ✅ Plano de rollback completamente detalhado com 5 etapas e verificações
- ✅ Matriz de riscos atualizada com novos riscos identificados
- ✅ Pontos de atenção expandidos com verificações críticas
- ✅ Checklist atualizado com verificações críticas

### **Versão 1.0.0 (18/11/2025)**
- Versão inicial do projeto

---

**Documento criado em:** 18/11/2025  
**Versão:** 1.1.0  
**Status:** 📝 **AGUARDANDO AUTORIZAÇÃO**

