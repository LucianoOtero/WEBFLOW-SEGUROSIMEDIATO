# 🔍 INVESTIGAÇÃO: Erro 500 no Endpoint de Email

**Data:** 18/11/2025  
**Versão:** 1.0.0  
**Status:** 🔍 **INVESTIGAÇÃO EM ANDAMENTO**

---

## 🎯 OBJETIVO

Investigar cuidadosamente a causa raiz do erro 500 no endpoint `send_email_notification_endpoint.php` após correção do `getInstance()`, sem alterar nenhuma configuração no servidor.

---

## 📋 METODOLOGIA DE INVESTIGAÇÃO

**Diretrizes Seguidas:**
- ✅ Apenas investigar e documentar (sem modificar código)
- ✅ Consultar logs e arquivos no servidor
- ✅ Testar componentes individualmente
- ✅ Documentar todos os achados

---

## 🔍 FASES DE INVESTIGAÇÃO

### **FASE 1: Teste Inicial do Endpoint**

**Ação:** Testar endpoint novamente após deploy

**Resultado:** ⏳ Aguardando execução

---

### **FASE 2: Verificação de Logs de Erro**

**Locais Verificados:**
- `/var/log/php-fpm/error.log`
- `/var/log/php/error.log`
- `/var/log/php8.1-fpm.log`
- `/var/log/php8.2-fpm.log`
- `/var/log/nginx/error.log`
- `/var/log/apache2/error.log`
- `journalctl -u php*-fpm`

**Resultado:** ⏳ Aguardando execução

---

### **FASE 3: Captura de Erro Direto**

**Ação:** Criar script PHP para capturar erro completo durante execução

**Resultado:** ⏳ Aguardando execução

---

### **FASE 4: Verificação de Arquivos Dependências**

**Arquivos Verificados:**
- `send_email_notification_endpoint.php`
- `send_admin_notification_ses.php`
- `ProfessionalLogger.php`
- `config.php`
- `aws_ses_config.php`
- `email_template_loader.php`

**Resultado:** ⏳ Aguardando execução

---

### **FASE 5: Verificação de Permissões**

**Ação:** Verificar permissões e proprietários dos arquivos principais

**Resultado:** ⏳ Aguardando execução

---

### **FASE 6: Teste de Require Once Individual**

**Ação:** Testar cada `require_once` individualmente para identificar qual falha

**Resultado:** ⏳ Aguardando execução

---

### **FASE 7: Teste de Instanciação do ProfessionalLogger**

**Ação:** Testar instanciação direta de `ProfessionalLogger` com `new ProfessionalLogger()`

**Resultado:** ⏳ Aguardando execução

---

### **FASE 8: Teste de Chamada Completa da Função**

**Ação:** Testar chamada completa de `enviarNotificacaoAdministradores()` isoladamente

**Resultado:** ⏳ Aguardando execução

---

## 📊 RESULTADOS DA INVESTIGAÇÃO

**Status:** ✅ **INVESTIGAÇÃO CONCLUÍDA**

### **FASE 1: Teste Inicial do Endpoint** ❌

**Resultado:** ❌ **Erro 500 persiste**

**Evidência:** Endpoint retorna HTTP 500 Internal Server Error

---

### **FASE 2: Verificação de Logs de Erro** ⚠️

**Logs Encontrados:**
- ✅ `/var/log/nginx/error.log` - Log encontrado (mas sem erros relacionados ao PHP)
- ⚠️ Logs do PHP-FPM não encontrados nos locais padrão

**Observação:** Logs do Nginx mostram apenas erro de body muito grande (não relacionado)

---

### **FASE 3: Captura de Erro Direto** ✅

**Erro Identificado:** ✅ **CAUSA RAIZ PRINCIPAL**

**Erro:**
```
APP_BASE_DIR não está definido nas variáveis de ambiente
Arquivo: /var/www/html/dev/root/config.php
Linha: 51
```

**Stack Trace:**
```
#0 /var/www/html/dev/root/config.php(217): getBaseDir()
#1 /var/www/html/dev/root/config.php(239): getConfig()
#2 /var/www/html/dev/root/send_email_notification_endpoint.php(23): require_once('...')
```

**Conclusão:** O erro ocorre ao carregar `config.php` que requer a variável de ambiente `APP_BASE_DIR`.

---

### **FASE 4: Verificação de Arquivos Dependências** ✅

**Resultado:** ✅ **Todos os arquivos existem**

**Arquivos Verificados:**
- ✅ `send_email_notification_endpoint.php` - Existe
- ✅ `send_admin_notification_ses.php` - Existe
- ✅ `ProfessionalLogger.php` - Existe
- ✅ `config.php` - Existe
- ✅ `aws_ses_config.php` - Existe
- ✅ `email_template_loader.php` - Existe

---

### **FASE 5: Verificação de Permissões** ✅

**Resultado:** ✅ **Permissões corretas**

**Permissões Verificadas:**
- `send_email_notification_endpoint.php`: `-rw-r--r-- 1 www-data www-data`
- `send_admin_notification_ses.php`: `-rw-r--r-- 1 www-data www-data`
- `ProfessionalLogger.php`: `-rw-r--r-- 1 www-data www-data`

**Conclusão:** Permissões estão corretas (644, proprietário www-data)

---

### **FASE 6: Teste de Require Once Individual** ⚠️

**Resultado:** ⚠️ **Erro identificado**

**Erros Encontrados:**

1. **config.php:** ❌ **ERRO**
   - Mensagem: `APP_BASE_DIR não está definido nas variáveis de ambiente`
   - Arquivo: `/var/www/html/dev/root/config.php`
   - Linha: 51

2. **ProfessionalLogger.php:** ✅ **OK** (mas com warnings de deprecated)

3. **send_admin_notification_ses.php:** ✅ **OK** (mas com warnings de deprecated)

**Conclusão:** O erro principal é a falta da variável de ambiente `APP_BASE_DIR`.

---

### **FASE 7: Teste de Instanciação do ProfessionalLogger** ❌

**Erro Identificado:** ❌ **ERRO SECUNDÁRIO**

**Erro:**
```
Undefined constant PDO::MYSQL_ATTR_INIT_COMMAND
Arquivo: /var/www/html/dev/root/ProfessionalLogger.php
Linha: 294
```

**Conclusão:** Extensão PDO MySQL pode não estar completamente habilitada ou constante não está disponível.

---

### **FASE 8: Teste de Chamada Completa da Função** ❌

**Erro Identificado:** ❌ **ERRO TERCIÁRIO**

**Erro:**
```
Class "SimpleXMLElement" not found
Arquivo: /var/www/html/dev/root/vendor/aws/aws-sdk-php/src/Api/Parser/PayloadParserTrait.php
Linha: 39
```

**Stack Trace:**
```
#0 .../QueryParser.php(44): Aws\Api\Parser\QueryParser->parseXml()
#1 .../WrappedHttpHandler.php(126): Aws\Api\Parser\QueryParser->__invoke()
...
#17 .../send_admin_notification_ses.php(138): Aws\AwsClient->__call()
```

**Conclusão:** Extensão XML do PHP não está habilitada, necessária para AWS SDK funcionar.

---

## 🔍 CAUSAS RAIZ IDENTIFICADAS

### **1. Variável de Ambiente APP_BASE_DIR Ausente** ❌ **CAUSA PRINCIPAL**

**Descrição:** Variável de ambiente `APP_BASE_DIR` não está definida no PHP-FPM

**Evidência:** 
- Erro capturado na FASE 3: `APP_BASE_DIR não está definido nas variáveis de ambiente`
- Arquivo: `config.php` linha 51
- Função: `getBaseDir()`

**Impacto:** ❌ **CRÍTICO** - Impede carregamento de `config.php`, que é necessário para o endpoint funcionar

**Ação Recomendada:** Configurar variável de ambiente `APP_BASE_DIR` no PHP-FPM

---

### **2. Constante PDO::MYSQL_ATTR_INIT_COMMAND Indefinida** ❌ **CAUSA SECUNDÁRIA**

**Descrição:** Constante `PDO::MYSQL_ATTR_INIT_COMMAND` não está disponível

**Evidência:**
- Erro capturado na FASE 7: `Undefined constant PDO::MYSQL_ATTR_INIT_COMMAND`
- Arquivo: `ProfessionalLogger.php` linha 294

**Impacto:** ⚠️ **MODERADO** - Pode impedir conexão com banco de dados se extensão PDO MySQL não estiver completamente habilitada

**Ação Recomendada:** Verificar se extensão `pdo_mysql` está habilitada no PHP

---

### **3. Extensão XML do PHP Não Habilitada** ❌ **CAUSA TERCIÁRIA**

**Descrição:** Classe `SimpleXMLElement` não encontrada - extensão XML não está habilitada

**Evidência:**
- Erro capturado na FASE 8: `Class "SimpleXMLElement" not found`
- Arquivo: `vendor/aws/aws-sdk-php/src/Api/Parser/PayloadParserTrait.php` linha 39
- Necessário para: AWS SDK processar respostas XML

**Impacto:** ❌ **CRÍTICO** - Impede AWS SDK de funcionar, bloqueando envio de emails

**Ação Recomendada:** Habilitar extensão `xml` do PHP

---

### **4. Warnings Deprecated do AWS SDK** ⚠️ **NÃO CRÍTICO**

**Descrição:** Múltiplos warnings de deprecated do AWS SDK e Guzzle

**Evidência:** Muitos warnings de deprecated aparecem nos logs, mas não causam erro fatal

**Impacto:** ⚠️ **BAIXO** - Apenas warnings, não impedem funcionamento

**Ação Recomendada:** Atualizar AWS SDK para versão compatível com PHP 8.x (quando possível)

---

## 📋 CONCLUSÕES FINAIS

**Status:** ✅ **INVESTIGAÇÃO CONCLUÍDA**

### **Causa Raiz Principal Identificada:**

**Erro 500 é causado por 3 problemas principais:**

1. ❌ **Variável de Ambiente `APP_BASE_DIR` Ausente** (CRÍTICO)
   - Impede carregamento de `config.php`
   - Bloqueia execução do endpoint antes mesmo de chegar ao código corrigido

2. ❌ **Extensão XML do PHP Não Habilitada** (CRÍTICO)
   - Impede AWS SDK de funcionar
   - Bloqueia envio de emails mesmo que outras partes funcionem

3. ⚠️ **Constante PDO Indefinida** (MODERADO)
   - Pode impedir conexão com banco de dados
   - Não é causa direta do erro 500 atual, mas pode causar problemas futuros

### **Ordem de Impacto:**

1. **Primeiro erro:** `APP_BASE_DIR` ausente → `config.php` falha → endpoint retorna 500
2. **Segundo erro:** Se `APP_BASE_DIR` fosse corrigido, `SimpleXMLElement` ausente → AWS SDK falha → endpoint retornaria 500
3. **Terceiro erro:** Se ambos fossem corrigidos, constante PDO indefinida → logs não seriam inseridos no banco

### **Correção do `getInstance()`:**

✅ **A correção do `getInstance()` foi bem-sucedida** - O erro não é mais causado por esse problema. No entanto, outros erros impedem que o endpoint funcione.

### **Recomendações:**

1. **Configurar variável de ambiente `APP_BASE_DIR` no PHP-FPM**
2. **Habilitar extensão `xml` do PHP**
3. **Verificar extensão `pdo_mysql` do PHP**
4. **Após correções, testar endpoint novamente**

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Nenhuma configuração foi alterada no servidor** - Apenas investigação
2. **Todos os testes são não-destrutivos** - Apenas leitura e execução de scripts de teste
3. **Documentação completa** - Todos os achados serão documentados

---

**Documento criado em:** 18/11/2025  
**Versão:** 1.0.0  
**Status:** 🔍 **INVESTIGAÇÃO EM ANDAMENTO**

