# 🔧 PROJETO: Habilitar Extensão pdo_mysql no PHP 8.3 do Servidor DEV

**Data de Criação:** 18/11/2025  
**Status:** 📝 **EM IMPLEMENTAÇÃO**  
**Versão:** 1.0.0  
**Prioridade:** 🔴 **CRÍTICA** (necessária para funcionamento do sistema de logging unificado)  
**Ambiente:** 🟢 **DESENVOLVIMENTO** (`dev.bssegurosimediato.com.br` - IP: 65.108.156.14)

---

## 🎯 OBJETIVO

Habilitar extensão `pdo_mysql` no **PHP-FPM 8.3** do servidor de desenvolvimento para resolver erro `Undefined constant PDO::MYSQL_ATTR_INIT_COMMAND`.

**Contexto:**
- PHP CLI: 8.4.14 ✅
- PHP-FPM: 8.3 (ativo) ⚠️
- Extensão `php8.3-mysql`: ✅ **JÁ INSTALADA**
- Extensão habilitada: ❌ **NÃO HABILITADA**

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### **Requisitos Funcionais:**

1. ✅ Habilitar extensão `pdo_mysql` no PHP-FPM 8.3
2. ✅ Resolver erro `Undefined constant PDO::MYSQL_ATTR_INIT_COMMAND`
3. ✅ Garantir que `ProfessionalLogger` funcione corretamente
4. ✅ Garantir que endpoint de email retorne HTTP 200 (não mais HTTP 500)
5. ✅ Garantir que logs sejam inseridos no banco de dados

### **Requisitos Não-Funcionais:**

1. ✅ Não quebrar funcionalidades existentes
2. ✅ Não causar downtime significativo
3. ✅ Manter compatibilidade com PHP 8.3
4. ✅ Documentar processo para produção

### **Critérios de Aceitação:**

1. ✅ Extensão `pdo_mysql` habilitada e funcionando
2. ✅ `ProfessionalLogger` pode ser instanciado sem erros
3. ✅ Endpoint de email retorna HTTP 200 (não mais HTTP 500)
4. ✅ Logs são inseridos no banco de dados corretamente
5. ✅ Constante `PDO::MYSQL_ATTR_INIT_COMMAND` está definida

---

## 🔍 ANÁLISE DO ESTADO ATUAL

### **Estado Atual:**

- ✅ PHP-FPM 8.3 está rodando: `php8.3-fpm.service`
- ✅ Extensão `php8.3-mysql` está instalada
- ✅ Arquivos de configuração existem em `/etc/php/8.3/mods-available/`
- ❌ Extensão não está habilitada no PHP-FPM 8.3
- ❌ Links simbólicos não existem em `/etc/php/8.3/fpm/conf.d/`

### **Arquivos Encontrados:**

- `/etc/php/8.3/mods-available/pdo_mysql.ini` ✅
- `/etc/php/8.3/mods-available/mysqlnd.ini` ✅
- `/etc/php/8.3/mods-available/mysqli.ini` ✅

### **Problema Identificado:**

Extensão está instalada mas não habilitada no PHP-FPM 8.3.

---

## 📊 FASES DO PROJETO

### **FASE 0: Verificação do Estado Atual**

**Objetivo:** Confirmar estado atual antes de proceder

**Tarefas:**

1. **Verificar PHP-FPM 8.3 está rodando:**
   ```bash
   systemctl status php8.3-fpm
   ```

2. **Verificar extensão está instalada:**
   ```bash
   dpkg -l | grep -i 'php8.3-mysql'
   ```

3. **Verificar arquivos de configuração:**
   ```bash
   ls -la /etc/php/8.3/mods-available/ | grep -i mysql
   ```

4. **Verificar se extensão está habilitada:**
   ```bash
   php-fpm8.3 -m | grep -i 'pdo_mysql'
   ```

**Critério de Sucesso:**
- ✅ PHP-FPM 8.3 está rodando
- ✅ Extensão está instalada
- ✅ Arquivos de configuração existem
- ✅ Extensão não está habilitada (confirmar que precisa habilitar)

---

### **FASE 1: Habilitar Extensão no PHP-FPM 8.3**

**Objetivo:** Habilitar extensão `pdo_mysql` no PHP-FPM 8.3

**Tarefas:**

1. **Habilitar extensão usando phpenmod:**
   ```bash
   phpenmod -v 8.3 pdo_mysql
   ```

2. **OU criar link simbólico manualmente:**
   ```bash
   # Verificar se arquivo existe
   if [ -f /etc/php/8.3/mods-available/pdo_mysql.ini ]; then
       # Criar link simbólico
       ln -sf /etc/php/8.3/mods-available/pdo_mysql.ini /etc/php/8.3/fpm/conf.d/20-pdo_mysql.ini
       echo "✅ Link criado"
   fi
   ```

3. **Verificar link foi criado:**
   ```bash
   ls -la /etc/php/8.3/fpm/conf.d/ | grep -i pdo_mysql
   ```

**Critério de Sucesso:**
- ✅ Link simbólico criado em `/etc/php/8.3/fpm/conf.d/`
- ✅ Arquivo de configuração existe

---

### **FASE 2: Reiniciar PHP-FPM 8.3**

**Objetivo:** Reiniciar PHP-FPM para carregar extensão

**Tarefas:**

1. **Testar configuração antes de reiniciar:**
   ```bash
   php-fpm8.3 -t
   ```

2. **Reiniciar PHP-FPM:**
   ```bash
   systemctl restart php8.3-fpm
   ```

3. **Verificar se reiniciou com sucesso:**
   ```bash
   systemctl is-active php8.3-fpm
   ```

**Critério de Sucesso:**
- ✅ Configuração válida
- ✅ PHP-FPM reiniciado sem erros
- ✅ Status: active

---

### **FASE 3: Verificação da Extensão**

**Objetivo:** Confirmar que extensão está habilitada e funcionando

**Tarefas:**

1. **Verificar extensão via PHP-FPM:**
   ```bash
   php-fpm8.3 -m | grep -i 'pdo_mysql'
   ```

2. **Verificar constante específica:**
   ```bash
   php-fpm8.3 -r "echo defined('PDO::MYSQL_ATTR_INIT_COMMAND') ? 'OK' : 'ERRO';"
   ```

3. **Criar arquivo de teste via web:**
   ```php
   <?php
   header('Content-Type: text/plain; charset=utf-8');
   echo "Extensão carregada: " . (extension_loaded('pdo_mysql') ? 'SIM' : 'NÃO') . "\n";
   echo "Constante definida: " . (defined('PDO::MYSQL_ATTR_INIT_COMMAND') ? 'SIM' : 'NÃO') . "\n";
   ?>
   ```

**Critério de Sucesso:**
- ✅ Extensão `pdo_mysql` encontrada na lista de módulos
- ✅ Constante `PDO::MYSQL_ATTR_INIT_COMMAND` está definida
- ✅ Teste via web confirma extensão carregada

---

### **FASE 4: Teste do ProfessionalLogger**

**Objetivo:** Verificar se `ProfessionalLogger` funciona corretamente

**Tarefas:**

1. **Criar script de teste:**
   ```php
   <?php
   require_once __DIR__ . '/../ProfessionalLogger.php';
   try {
       $logger = new ProfessionalLogger();
       echo "✅ ProfessionalLogger instanciado\n";
       $logId = $logger->insertLog([
           'level' => 'INFO',
           'category' => 'TEST',
           'message' => 'Teste após habilitar pdo_mysql PHP 8.3'
       ]);
       echo "✅ Log inserido: $logId\n";
   } catch (Exception $e) {
       echo "❌ Erro: " . $e->getMessage() . "\n";
   }
   ?>
   ```

2. **Testar via CLI:**
   ```bash
   php /var/www/html/dev/root/TMP/test_professional_logger.php
   ```

3. **Testar via web:**
   ```bash
   curl https://dev.bssegurosimediato.com.br/TMP/test_professional_logger.php
   ```

**Critério de Sucesso:**
- ✅ `ProfessionalLogger` instanciado sem erros
- ✅ Log inserido com sucesso
- ✅ Nenhum erro relacionado a constante

---

### **FASE 5: Teste do Endpoint de Email**

**Objetivo:** Verificar se endpoint de email retorna HTTP 200

**Tarefas:**

1. **Testar endpoint via HTTP:**
   ```bash
   curl -X POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php \
     -H "Content-Type: application/json" \
     -d '{"ddd": "11", "celular": "999999999", "momento": "test"}'
   ```

2. **Verificar resposta:**
   - Status HTTP deve ser 200
   - Resposta JSON válida
   - Sem erros relacionados a constante

**Critério de Sucesso:**
- ✅ Endpoint retorna HTTP 200
- ✅ Resposta JSON válida
- ✅ Nenhum erro relacionado a constante

---

### **FASE 6: Limpeza**

**Objetivo:** Remover arquivos temporários de teste

**Tarefas:**

1. **Remover arquivos de teste:**
   ```bash
   rm -f /var/www/html/dev/root/TMP/test_pdo_mysql.php
   rm -f /var/www/html/dev/root/TMP/test_professional_logger.php
   ```

**Critério de Sucesso:**
- ✅ Arquivos temporários removidos

---

## 🔄 PLANO DE ROLLBACK

### **Cenário: Extensão Causa Problemas**

**Procedimento:**

1. **Desabilitar extensão:**
   ```bash
   rm -f /etc/php/8.3/fpm/conf.d/20-pdo_mysql.ini
   ```

2. **Reiniciar PHP-FPM:**
   ```bash
   systemctl restart php8.3-fpm
   ```

3. **Verificar extensão foi desabilitada:**
   ```bash
   php-fpm8.3 -m | grep -i 'pdo_mysql'
   # Não deve aparecer nada
   ```

**Critério de Sucesso:**
- ✅ Extensão desabilitada
- ✅ PHP-FPM reiniciado sem erros
- ✅ Aplicação funciona (mesmo sem logs no banco)

---

## ✅ CHECKLIST DE VERIFICAÇÃO

### **Antes da Implementação:**

- [ ] PHP-FPM 8.3 confirmado como versão ativa
- [ ] Extensão `php8.3-mysql` confirmada como instalada
- [ ] Arquivos de configuração verificados
- [ ] Procedimento de rollback revisado

### **Durante a Implementação:**

- [ ] FASE 0: Estado atual verificado
- [ ] FASE 1: Extensão habilitada
- [ ] FASE 2: PHP-FPM reiniciado
- [ ] FASE 3: Extensão verificada
- [ ] FASE 4: ProfessionalLogger testado
- [ ] FASE 5: Endpoint de email testado
- [ ] FASE 6: Limpeza concluída

### **Após a Implementação:**

- [ ] Extensão funcionando
- [ ] ProfessionalLogger funcionando
- [ ] Endpoint de email retorna HTTP 200
- [ ] Logs sendo inseridos no banco
- [ ] Nenhum erro relacionado a constante

---

## 🚨 PONTOS DE ATENÇÃO

1. **Versão do PHP-FPM:**
   - ⚠️ Confirmar que PHP-FPM 8.3 está realmente em uso
   - Não confundir com PHP CLI 8.4

2. **Reinicialização:**
   - PHP-FPM precisa ser reiniciado após habilitar extensão
   - Verificar se reinicialização não causa downtime

3. **Cache Cloudflare:**
   - ⚠️ Após atualizar extensão PHP, limpar cache do Cloudflare
   - Alterações podem não ser refletidas imediatamente

4. **Produção:**
   - ⚠️ **PROCEDIMENTO NÃO DEFINIDO** para produção
   - ⚠️ **BLOQUEAR** qualquer ação em produção até procedimento oficial

---

## 📊 MATRIZ DE RISCOS

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Reinicialização causa downtime | Baixa | Médio | Agendar em horário de baixo tráfego |
| Extensão não funciona após habilitar | Baixa | Alto | Ter plano de rollback pronto |
| Problemas após implementação | Baixa | Alto | Testes completos após implementação |

---

**Documento criado em:** 18/11/2025  
**Versão:** 1.0.0  
**Status:** 📝 **EM IMPLEMENTAÇÃO**

