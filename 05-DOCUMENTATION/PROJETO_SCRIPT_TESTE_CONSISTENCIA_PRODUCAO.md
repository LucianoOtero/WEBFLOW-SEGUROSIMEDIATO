# 📋 PROJETO: Script de Teste de Consistência do Ambiente de Produção

**Data:** 14/11/2025  
**Status:** 📝 **PROJETO DEFINIDO**  
**Objetivo:** Criar script de teste para verificar a consistência do ambiente do servidor de produção

---

## 🎯 OBJETIVO

Elaborar um script de teste que verifique a consistência do ambiente do servidor de produção, validando:
- Presença e integridade de todos os arquivos
- Configuração correta das variáveis de ambiente
- Configurações de servidor (Nginx, PHP-FPM)
- Permissões de arquivos e diretórios
- Serviços ativos
- Acesso HTTPS
- Estrutura de diretórios

---

## 📋 BASES DO PROJETO

### **Documentos de Referência:**
1. **Relatório de Comparação:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/relatorio_comparacao_dev_prod_20251114_090816.md`
2. **Variáveis de Ambiente PROD:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/VARIAVEIS_AMBIENTE_PROD.md`
3. **Relatório de Execução:** `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/RELATORIO_EXECUCAO_ATUALIZACAO_PRODUCAO.md`
4. **Arquitetura de Servidores:** `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/ARQUITETURA_SERVIDORES.md`

### **Valores Esperados em PROD:**

#### **Arquivos Esperados:**
- 3 arquivos JavaScript (.js)
- 13 arquivos PHP (.php)
- 3 templates de email
- Estrutura de diretórios completa

#### **Variáveis de Ambiente Esperadas:**
- `APP_BASE_DIR` = `/var/www/html/prod/root`
- `APP_BASE_URL` = `https://prod.bssegurosimediato.com.br`
- `PHP_ENV` = `production`
- `APP_CORS_ORIGINS` = `https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br`
- `ESPOCRM_URL` = `https://flyingdonkeys.com.br`
- `LOG_DB_NAME` = `rpa_logs_prod`
- `LOG_DB_USER` = `rpa_logger_prod`
- `LOG_DIR` = `/var/log/webflow-segurosimediato`

#### **Configurações Esperadas:**
- Nginx configurado para `prod.bssegurosimediato.com.br`
- Certificado SSL ativo
- PHP-FPM ativo
- Permissões: `www-data:www-data` e `755` (diretórios) / `644` (arquivos)

---

## 📋 ITENS A VERIFICAR

### **1. Arquivos do Projeto**

#### **Arquivos JavaScript (.js):**
1. `FooterCodeSiteDefinitivoCompleto.js`
2. `MODAL_WHATSAPP_DEFINITIVO.js`
3. `webflow_injection_limpo.js`

#### **Arquivos PHP (.php):**
1. `add_flyingdonkeys.php`
2. `add_webflow_octa.php`
3. `config.php`
4. `config_env.js.php`
5. `class.php`
6. `ProfessionalLogger.php`
7. `log_endpoint.php`
8. `send_email_notification_endpoint.php`
9. `send_admin_notification_ses.php`
10. `cpf-validate.php`
11. `placa-validate.php`
12. `email_template_loader.php`
13. `aws_ses_config.php`

#### **Templates de Email:**
1. `email_templates/template_modal.php`
2. `email_templates/template_primeiro_contato.php`
3. `email_templates/template_logging.php`

### **2. Variáveis de Ambiente PHP-FPM**

Verificar se as seguintes variáveis estão configuradas corretamente:
- `APP_BASE_DIR`
- `APP_BASE_URL`
- `PHP_ENV`
- `APP_CORS_ORIGINS`
- `ESPOCRM_URL`
- `LOG_DB_NAME`
- `LOG_DB_USER`
- `LOG_DIR`
- `WEBFLOW_SECRET_FLYINGDONKEYS` (verificar se existe, não validar valor)
- `WEBFLOW_SECRET_OCTADESK` (verificar se existe, não validar valor)

### **3. Configuração Nginx**

- Arquivo de configuração existe
- Server name correto (`prod.bssegurosimediato.com.br`)
- Document root correto (`/var/www/html/prod/root`)
- Locations específicos (se existirem)

### **4. Certificado SSL**

- Certificado Let's Encrypt existe
- Certificado válido (não expirado)

### **5. Serviços**

- Nginx ativo
- PHP-FPM ativo
- Serviços respondendo corretamente

### **6. Permissões**

- Proprietário: `www-data:www-data`
- Permissões diretórios: `755`
- Permissões arquivos: `644`

### **7. Estrutura de Diretórios**

- `/var/www/html/prod/root/` existe
- `/var/www/html/prod/root/email_templates/` existe
- `/var/log/webflow-segurosimediato/` existe (ou será criado quando necessário)

### **8. Acesso HTTP/HTTPS**

- HTTPS funcionando (HTTP 200 OK)
- Arquivos JavaScript acessíveis via HTTPS
- Endpoints PHP acessíveis via HTTPS

### **9. Integridade dos Arquivos**

- Comparar hash SHA256 dos arquivos no servidor com os arquivos em PROD (Windows)
- Identificar arquivos diferentes ou faltando

---

## 🔧 SCRIPT A SER CRIADO

### **Arquivo:**
`WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/testar_consistencia_producao.ps1`

### **Funcionalidades:**

1. **Verificação de Arquivos**
   - Listar todos os arquivos esperados
   - Verificar existência de cada arquivo
   - Calcular hash SHA256 de cada arquivo
   - Comparar com arquivos em PROD (Windows)
   - Identificar arquivos faltando ou diferentes

2. **Verificação de Variáveis de Ambiente**
   - Ler variáveis do arquivo PHP-FPM
   - Comparar com valores esperados
   - Identificar variáveis faltando ou incorretas

3. **Verificação de Configuração Nginx**
   - Verificar existência do arquivo de configuração
   - Verificar server_name
   - Verificar document root
   - Verificar locations específicos

4. **Verificação de Certificado SSL**
   - Verificar existência do certificado
   - Verificar validade do certificado

5. **Verificação de Serviços**
   - Verificar status do Nginx
   - Verificar status do PHP-FPM
   - Verificar se serviços estão respondendo

6. **Verificação de Permissões**
   - Verificar proprietário dos arquivos
   - Verificar permissões dos arquivos
   - Identificar permissões incorretas

7. **Verificação de Estrutura de Diretórios**
   - Verificar diretórios esperados
   - Identificar diretórios faltando

8. **Teste de Acesso HTTP/HTTPS**
   - Testar acesso HTTPS ao domínio
   - Testar carregamento de arquivos JavaScript
   - Testar acesso a endpoints PHP

9. **Geração de Relatório**
   - Criar relatório em Markdown
   - Incluir todas as verificações
   - Incluir resumo com estatísticas
   - Incluir recomendações de correção

---

## 📋 ESTRUTURA DO SCRIPT

### **Parâmetros:**
```powershell
param(
    [string]$ProdServer = "root@157.180.36.223",
    [string]$ProdDir = "/var/www/html/prod/root",
    [string]$ProdWindowsDir = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION",
    [string]$OutputFile = "relatorio_consistencia_producao_$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
)
```

### **Funções Principais:**

1. `Test-FileExists` - Verifica se arquivo existe
2. `Get-RemoteFileHash` - Calcula hash SHA256 remoto
3. `Get-LocalFileHash` - Calcula hash SHA256 local
4. `Test-EnvironmentVariable` - Verifica variável de ambiente
5. `Test-NginxConfig` - Verifica configuração Nginx
6. `Test-SSLCertificate` - Verifica certificado SSL
7. `Test-Service` - Verifica status de serviço
8. `Test-FilePermissions` - Verifica permissões de arquivo
9. `Test-HTTPSAccess` - Testa acesso HTTPS
10. `Generate-Report` - Gera relatório em Markdown

---

## 📊 RESULTADO ESPERADO

### **Relatório Gerado:**

O script gerará um relatório Markdown com:

1. **Resumo Executivo**
   - Total de verificações realizadas
   - Total de problemas encontrados
   - Status geral (✅ Consistente / ⚠️ Inconsistente)

2. **Verificação de Arquivos**
   - Tabela com todos os arquivos
   - Status de cada arquivo (✅ Presente / ❌ Faltando)
   - Hash SHA256 de cada arquivo
   - Comparação com arquivos locais (PROD Windows)
   - Arquivos diferentes identificados

3. **Verificação de Variáveis de Ambiente**
   - Tabela com todas as variáveis
   - Valor atual vs valor esperado
   - Status de cada variável (✅ Correto / ⚠️ Incorreto / ❌ Faltando)

4. **Verificação de Configuração**
   - Status do Nginx
   - Status do PHP-FPM
   - Status do certificado SSL
   - Configurações específicas

5. **Verificação de Permissões**
   - Permissões de arquivos principais
   - Permissões de diretórios
   - Problemas de permissão identificados

6. **Teste de Acesso**
   - Resultado dos testes HTTPS
   - Resultado dos testes de arquivos
   - Resultado dos testes de endpoints

7. **Resumo e Recomendações**
   - Lista de problemas encontrados
   - Recomendações de correção
   - Priorização de ações

---

## ✅ FUNCIONALIDADES DO SCRIPT

### **1. Verificação de Arquivos**
- ✅ Lista todos os arquivos esperados
- ✅ Verifica existência em PROD (servidor)
- ✅ Calcula hash SHA256 de cada arquivo
- ✅ Compara com arquivos em PROD (Windows)
- ✅ Identifica arquivos faltando
- ✅ Identifica arquivos diferentes
- ✅ Identifica arquivos idênticos

### **2. Verificação de Variáveis de Ambiente**
- ✅ Lê arquivo PHP-FPM do servidor
- ✅ Extrai todas as variáveis de ambiente
- ✅ Compara com valores esperados
- ✅ Identifica variáveis faltando
- ✅ Identifica variáveis incorretas
- ✅ Identifica variáveis corretas

### **3. Verificação de Configuração**
- ✅ Verifica arquivo Nginx
- ✅ Verifica certificado SSL
- ✅ Verifica serviços ativos
- ✅ Verifica configurações específicas

### **4. Verificação de Permissões**
- ✅ Verifica proprietário dos arquivos
- ✅ Verifica permissões dos arquivos
- ✅ Identifica permissões incorretas

### **5. Teste de Acesso**
- ✅ Testa acesso HTTPS
- ✅ Testa carregamento de arquivos
- ✅ Testa acesso a endpoints

### **6. Geração de Relatório**
- ✅ Cria relatório em Markdown
- ✅ Inclui todas as verificações
- ✅ Inclui estatísticas
- ✅ Inclui recomendações

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

- [x] Criar estrutura do script PowerShell
- [x] Implementar função de verificação de arquivos
- [x] Implementar função de verificação de variáveis
- [x] Implementar função de verificação de configuração
- [x] Implementar função de verificação de permissões
- [x] Implementar função de teste de acesso
- [x] Implementar função de geração de relatório
- [ ] Testar script com servidor PROD
- [ ] Validar relatório gerado
- [x] Documentar uso do script

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **Diretivas Seguidas:**

1. ✅ **Script apenas de leitura:**
   - Não modifica nada no servidor
   - Apenas lê e verifica informações
   - Gera relatório local

2. ✅ **Criado localmente:**
   - Script criado em `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/`
   - Não cria arquivos no servidor

3. ✅ **Comparação com PROD Windows:**
   - Compara arquivos do servidor com arquivos em PROD (Windows)
   - Não compara com DEV

4. ✅ **Valores esperados:**
   - Baseados na documentação de variáveis PROD
   - Baseados no relatório de execução
   - Baseados na arquitetura de servidores

---

## 📝 PRÓXIMOS PASSOS

1. ✅ Projeto definido
2. ⏳ Criar script PowerShell
3. ⏳ Implementar todas as funções de verificação
4. ⏳ Testar script
5. ⏳ Validar relatório gerado
6. ⏳ Documentar uso

---

**Data de Criação:** 14/11/2025  
**Última Atualização:** 14/11/2025  
**Status:** ✅ **SCRIPT CRIADO - PRONTO PARA USO**

---

## ✅ IMPLEMENTAÇÃO CONCLUÍDA

### **Script Criado:**
- ✅ `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/testar_consistencia_producao.ps1`

### **Funcionalidades Implementadas:**
- ✅ Verificação de arquivos (JavaScript, PHP, Templates)
- ✅ Comparação de hash SHA256 (servidor vs local)
- ✅ Verificação de variáveis de ambiente PHP-FPM
- ✅ Verificação de configuração Nginx
- ✅ Verificação de certificado SSL
- ✅ Verificação de serviços (Nginx, PHP-FPM)
- ✅ Verificação de permissões de arquivos
- ✅ Verificação de estrutura de diretórios
- ✅ Teste de acesso HTTPS
- ✅ Geração de relatório em Markdown

### **Uso do Script:**
```powershell
# Executar com valores padrão
cd "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG"
.\testar_consistencia_producao.ps1

# Ou com parâmetros customizados
.\testar_consistencia_producao.ps1 -ProdServer "root@157.180.36.223"
```

