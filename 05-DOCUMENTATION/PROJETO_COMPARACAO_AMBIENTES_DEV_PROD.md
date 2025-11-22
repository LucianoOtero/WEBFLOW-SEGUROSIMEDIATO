# 📋 PROJETO: Comparação de Ambientes DEV vs PROD

**Data:** 12/11/2025  
**Status:** ✅ **SCRIPT CRIADO**  
**Objetivo:** Identificar diferenças entre DEV e PROD para ajustar produção

---

## 🎯 OBJETIVO

Elaborar um script que compare os dois ambientes (produção e desenvolvimento) identificando quais diferenças existem entre o servidor de produção e desenvolvimento, com o objetivo de ajustar o ambiente de produção para que todos os arquivos `.js` e `.php` funcionem corretamente.

---

## 📋 REQUISITOS IDENTIFICADOS NA DOCUMENTAÇÃO

### **1. Arquivos do Projeto**

#### **Arquivos JavaScript (.js)**
- `FooterCodeSiteDefinitivoCompleto.js`
- `MODAL_WHATSAPP_DEFINITIVO.js`
- `webflow_injection_limpo.js`

#### **Arquivos PHP (.php)**
- `add_flyingdonkeys.php`
- `add_webflow_octa.php`
- `config.php`
- `config_env.js.php`
- `class.php`
- `ProfessionalLogger.php`
- `log_endpoint.php`
- `send_email_notification_endpoint.php`
- `send_admin_notification_ses.php`
- `cpf-validate.php`
- `placa-validate.php`
- `email_template_loader.php`

#### **Templates de Email**
- `email_templates/template_modal.php`
- `email_templates/template_primeiro_contato.php`
- `email_templates/template_logging.php`

### **2. Variáveis de Ambiente PHP-FPM**

#### **Variáveis Críticas**
- `APP_BASE_DIR` - Diretório base físico
- `APP_BASE_URL` - URL base HTTP
- `APP_ENVIRONMENT` / `PHP_ENV` - Ambiente (development/production)
- `LOG_DIR` - Diretório de logs
- `WEBFLOW_SECRET_FLYINGDONKEYS` - Secret key webhook FlyingDonkeys
- `WEBFLOW_SECRET_OCTADESK` - Secret key webhook OctaDesk
- `ESPOCRM_URL` - URL do EspoCRM
- `LOG_DB_NAME` - Nome do banco de dados de logs
- `LOG_DB_USER` - Usuário do banco de dados de logs

#### **Valores Esperados**

**DEV:**
- `APP_BASE_DIR`: `/var/www/html/dev/root`
- `APP_BASE_URL`: `https://dev.bssegurosimediato.com.br`
- `APP_ENVIRONMENT`: `development`
- `LOG_DIR`: `/var/log/webflow-segurosimediato`
- `ESPOCRM_URL`: `https://dev.flyingdonkeys.com.br`
- `LOG_DB_NAME`: `rpa_logs_dev`

**PROD:**
- `APP_BASE_DIR`: `/var/www/html/prod/root`
- `APP_BASE_URL`: `https://prod.bssegurosimediato.com.br`
- `APP_ENVIRONMENT`: `production`
- `LOG_DIR`: `/var/log/webflow-segurosimediato`
- `ESPOCRM_URL`: `https://flyingdonkeys.com.br`
- `LOG_DB_NAME`: `rpa_logs_prod`

### **3. Configuração Nginx**

#### **Arquivos de Configuração**
- DEV: `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`
- PROD: `/etc/nginx/sites-available/prod.bssegurosimediato.com.br`

#### **Locations Específicos (DEV)**
- `location = /placa-validate.php` - Sem headers CORS (PHP faz validação)
- `location = /cpf-validate.php` - Sem headers CORS (PHP faz validação)

### **4. Certificados SSL**

#### **Domínios**
- DEV: `dev.bssegurosimediato.com.br`
- PROD: `prod.bssegurosimediato.com.br`

#### **Localização**
- `/etc/letsencrypt/live/{domain}/`

### **5. Estrutura de Diretórios**

#### **DEV**
- `/var/www/html/dev/root/` - Arquivos da aplicação
- `/var/www/html/dev/root/email_templates/` - Templates de email
- `/var/log/webflow-segurosimediato/` - Logs

#### **PROD**
- `/var/www/html/prod/root/` - Arquivos da aplicação
- `/var/www/html/prod/root/email_templates/` - Templates de email
- `/var/log/webflow-segurosimediato/` - Logs

### **6. Permissões de Arquivos**

- Proprietário: `www-data:www-data`
- Permissões: `755` (diretórios) / `644` (arquivos)

---

## 🔧 SCRIPT CRIADO

### **Arquivo**
`WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/comparar_ambientes_dev_prod.ps1`

### **Funcionalidades**

1. **Comparação de Arquivos**
   - Lista todos os arquivos .js e .php em DEV e PROD
   - Calcula hash SHA256 de cada arquivo
   - Identifica arquivos faltando em PROD
   - Identifica arquivos com diferenças

2. **Comparação de Variáveis de Ambiente**
   - Obtém variáveis PHP-FPM de ambos os ambientes
   - Compara valores das variáveis críticas
   - Identifica variáveis faltando ou com valores incorretos

3. **Comparação de Configuração Nginx**
   - Verifica existência de arquivos de configuração
   - Compara configurações entre DEV e PROD

4. **Comparação de Certificados SSL**
   - Verifica existência de certificados Let's Encrypt
   - Identifica certificados faltando

5. **Comparação de Estrutura de Diretórios**
   - Lista diretórios em ambos os ambientes
   - Identifica diretórios faltando

6. **Geração de Relatório**
   - Cria relatório em Markdown com todas as diferenças
   - Inclui recomendações de ações
   - Salva relatório com timestamp

---

## 📊 PARÂMETROS DO SCRIPT

### **Parâmetros Opcionais**

```powershell
param(
    [string]$DevServer = "root@65.108.156.14",
    [string]$ProdServer = "root@157.180.36.223",
    [string]$DevDir = "/var/www/html/dev/root",
    [string]$ProdDir = "/var/www/html/prod/root",
    [string]$OutputFile = "relatorio_comparacao_dev_prod_$(Get-Date -Format 'yyyyMMdd_HHmmss').md"
)
```

### **Uso**

```powershell
# Uso padrão (usa valores padrão)
.\comparar_ambientes_dev_prod.ps1

# Uso com parâmetros customizados
.\comparar_ambientes_dev_prod.ps1 -DevServer "root@65.108.156.14" -ProdServer "root@157.180.36.223"
```

---

## 📋 ESTRUTURA DO RELATÓRIO GERADO

O script gera um relatório Markdown com as seguintes seções:

1. **Arquivos do Projeto** - Lista de arquivos .js e .php
2. **Comparação de Arquivos** - Tabela com status, hashes e diferenças
3. **Variáveis de Ambiente PHP-FPM** - Comparação de variáveis críticas
4. **Configuração Nginx** - Status das configurações
5. **Certificados SSL** - Status dos certificados
6. **Estrutura de Diretórios** - Lista de diretórios em ambos os ambientes
7. **Resumo da Comparação** - Estatísticas e totais
8. **Recomendações** - Ações prioritárias para ajustar PROD
9. **Próximos Passos** - Checklist de ações

---

## ✅ FUNCIONALIDADES IMPLEMENTADAS

### **1. Comparação de Arquivos**
- ✅ Lista arquivos .js e .php em DEV
- ✅ Verifica existência em PROD
- ✅ Calcula hash SHA256 (case-insensitive)
- ✅ Identifica arquivos faltando
- ✅ Identifica arquivos com diferenças
- ✅ Identifica arquivos idênticos

### **2. Comparação de Variáveis de Ambiente**
- ✅ Obtém variáveis PHP-FPM de DEV
- ✅ Obtém variáveis PHP-FPM de PROD
- ✅ Compara variáveis críticas
- ✅ Identifica variáveis faltando
- ✅ Identifica valores diferentes

### **3. Comparação de Configuração Nginx**
- ✅ Verifica existência de configuração DEV
- ✅ Verifica existência de configuração PROD
- ✅ Identifica configuração faltando

### **4. Comparação de Certificados SSL**
- ✅ Verifica certificado DEV
- ✅ Verifica certificado PROD
- ✅ Identifica certificado faltando

### **5. Comparação de Estrutura de Diretórios**
- ✅ Lista diretórios em DEV
- ✅ Lista diretórios em PROD
- ✅ Identifica diferenças

### **6. Geração de Relatório**
- ✅ Cria relatório em Markdown
- ✅ Inclui todas as comparações
- ✅ Inclui recomendações
- ✅ Salva com timestamp

---

## 🎯 RESULTADOS ESPERADOS

### **Arquivos**
- Identificar quais arquivos .js e .php estão faltando em PROD
- Identificar quais arquivos têm diferenças entre DEV e PROD
- Identificar quais arquivos estão idênticos

### **Variáveis de Ambiente**
- Identificar variáveis faltando em PROD
- Identificar variáveis com valores incorretos
- Identificar variáveis que precisam ser ajustadas para PROD

### **Configuração**
- Identificar se configuração Nginx PROD existe
- Identificar se certificado SSL PROD existe
- Identificar diferenças na estrutura de diretórios

### **Relatório**
- Relatório completo em Markdown
- Recomendações de ações prioritárias
- Checklist de próximos passos

---

## 📝 PRÓXIMOS PASSOS APÓS EXECUÇÃO

1. **Revisar Relatório**
   - Analisar todas as diferenças identificadas
   - Priorizar ações necessárias

2. **Copiar Arquivos Faltantes**
   - Copiar arquivos .js e .php faltando em PROD
   - Verificar integridade após cópia (hash)

3. **Atualizar Arquivos Diferentes**
   - Copiar versão DEV para PROD dos arquivos diferentes
   - Verificar integridade após cópia (hash)

4. **Ajustar Variáveis de Ambiente**
   - Atualizar variáveis PHP-FPM em PROD
   - Reiniciar PHP-FPM após alterações

5. **Verificar Configuração Nginx**
   - Criar/ajustar configuração Nginx PROD se necessário
   - Testar configuração (`nginx -t`)
   - Recarregar Nginx

6. **Obter Certificado SSL**
   - Configurar DNS primeiro
   - Executar Certbot após DNS propagado

7. **Testar Funcionamento**
   - Testar acesso HTTPS
   - Testar endpoints PHP
   - Testar carregamento de arquivos JavaScript
   - Verificar logs

---

## 🔗 REFERÊNCIAS

- **Arquitetura de Servidores:** `ARQUITETURA_SERVIDORES.md`
- **Arquitetura Completa:** `ARQUITETURA_COMPLETA_SISTEMA.md`
- **Script de Ajuste DEV→PROD:** `06-SERVER-CONFIG/ajustar_dev_para_prod.sh`
- **Configuração PHP-FPM DEV:** `06-SERVER-CONFIG/php-fpm_www_conf_DEV.conf`
- **Configuração Nginx DEV:** `06-SERVER-CONFIG/nginx_dev_bssegurosimediato_com_br.conf`

---

## ✅ STATUS DO PROJETO

- [x] Análise de requisitos
- [x] Identificação de arquivos do projeto
- [x] Identificação de variáveis de ambiente críticas
- [x] Criação do script de comparação
- [x] Implementação de comparação de arquivos
- [x] Implementação de comparação de variáveis
- [x] Implementação de comparação de configuração
- [x] Implementação de geração de relatório
- [ ] Execução do script (aguardando autorização)
- [ ] Revisão do relatório gerado
- [ ] Implementação de ajustes em PROD

---

**Data de Criação:** 12/11/2025  
**Última Atualização:** 12/11/2025  
**Status:** ✅ **SCRIPT CRIADO - PRONTO PARA USO**

