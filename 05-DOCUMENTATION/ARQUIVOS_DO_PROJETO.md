# 📁 ARQUIVOS DO PROJETO - Imediato Seguros RPA

**Data de Criação:** 10/11/2025  
**Última Atualização:** 10/11/2025

---

## 📋 RESUMO EXECUTIVO

Este documento lista todos os arquivos que compõem o projeto, organizados por categoria e função. Os arquivos são copiados para o servidor via script `copiar_arquivos_servidor.ps1`.

**Total de Arquivos do Projeto:** 15 arquivos principais

---

## 🔴 ARQUIVOS CRÍTICOS (PHP - Core)

### 1. `config.php`
- **Função:** Configuração central do sistema
- **Conteúdo:**
  - Detecção de ambiente (DEV/PROD)
  - Funções: `isDevelopment()`, `getBaseUrl()`, `getCorsOrigins()`
  - Função `requireFile()` para includes
  - Configuração de CORS
- **Dependências:** Nenhuma
- **Usado por:** Todos os arquivos PHP

### 2. `class.php`
- **Função:** Classes compartilhadas e utilitários
- **Conteúdo:** Classes e funções auxiliares
- **Dependências:** `config.php`
- **Usado por:** Múltiplos arquivos PHP

### 3. `config_env.js.php`
- **Função:** Expor variáveis de ambiente do PHP para JavaScript
- **Conteúdo:**
  - `window.APP_BASE_URL`
  - `window.APP_ENVIRONMENT`
  - Função helper `window.getEndpointUrl()`
- **Dependências:** Variáveis de ambiente do servidor
- **Usado por:** Todos os arquivos JavaScript

---

## 🔵 ARQUIVOS DE INTEGRAÇÃO (PHP - Endpoints)

### 4. `add_flyingdonkeys.php`
- **Função:** Endpoint de integração com FlyingDonkeys CRM
- **Método:** POST
- **Dependências:** `config.php`, `class.php`
- **Usado por:** `MODAL_WHATSAPP_DEFINITIVO.js`

### 5. `add_webflow_octa.php`
- **Função:** Endpoint de integração com OctaDesk
- **Método:** POST
- **Dependências:** `config.php`, `class.php`
- **Usado por:** `MODAL_WHATSAPP_DEFINITIVO.js`

---

## 🟢 ARQUIVOS DE EMAIL (PHP)

### 6. `send_email_notification_endpoint.php`
- **Função:** Endpoint para envio de notificações por email
- **Método:** POST
- **Dependências:** `config.php`, `ProfessionalLogger.php`, `send_admin_notification_ses.php`
- **Usado por:** `MODAL_WHATSAPP_DEFINITIVO.js`

### 7. `send_admin_notification_ses.php`
- **Função:** Função para envio de emails via AWS SES
- **Dependências:** AWS SDK (via Composer), variáveis de ambiente AWS
- **Usado por:** `send_email_notification_endpoint.php`

---

## 🟡 ARQUIVOS DE VALIDAÇÃO (PHP)

### 8. `cpf-validate.php`
- **Função:** Validação de CPF
- **Dependências:** `config.php`
- **Usado por:** Múltiplos endpoints

### 9. `placa-validate.php`
- **Função:** Validação de placa de veículo
- **Dependências:** `config.php`
- **Usado por:** Múltiplos endpoints

---

## 🟣 ARQUIVOS DE LOGGING (PHP)

### 10. `ProfessionalLogger.php`
- **Função:** Sistema de logging profissional
- **Conteúdo:**
  - Classe `ProfessionalLogger`
  - Métodos: `debug()`, `info()`, `warn()`, `error()`, `fatal()`
  - Conexão com MySQL
  - Captura automática de arquivo/linha
- **Dependências:** MySQL, variáveis de ambiente de banco de dados
- **Usado por:** `send_email_notification_endpoint.php`, `log_endpoint.php`

### 11. `log_endpoint.php`
- **Função:** Endpoint para receber logs do JavaScript
- **Método:** POST
- **Dependências:** `config.php`, `ProfessionalLogger.php`
- **Usado por:** `FooterCodeSiteDefinitivoCompleto.js`

---

## 🔷 ARQUIVOS JAVASCRIPT (Frontend)

### 12. `MODAL_WHATSAPP_DEFINITIVO.js`
- **Função:** Modal de WhatsApp para captura de leads
- **Conteúdo:**
  - Interface do modal
  - Validações de formulário
  - Integração com FlyingDonkeys (`add_flyingdonkeys.php`)
  - Integração com OctaDesk (`add_webflow_octa.php`)
  - Envio de notificações por email (`send_email_notification_endpoint.php`)
- **Dependências:** `config_env.js.php`, jQuery
- **Usado por:** Webflow (injetado no site)

### 13. `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Código JavaScript principal do site
- **Conteúdo:**
  - Funções utilitárias
  - Sistema de logging (`log_endpoint.php`)
  - Integrações diversas
  - Gerenciamento de GCLID
- **Dependências:** `config_env.js.php`
- **Usado por:** Webflow (injetado no footer)

### 14. `webflow_injection_limpo.js`
- **Função:** Script de injeção no Webflow
- **Conteúdo:** Lógica de injeção de scripts
- **Dependências:** Nenhuma
- **Usado por:** Webflow

---

## 📦 ARQUIVOS DE CONFIGURAÇÃO

### 15. `composer.json`
- **Função:** Dependências PHP (Composer)
- **Conteúdo:**
  - `aws/aws-sdk-php` (para AWS SES)
  - Outras dependências
- **Dependências:** Composer instalado no servidor
- **Usado por:** Servidor (para instalar dependências via `composer install`)

---

## 📊 ARQUIVOS POR CATEGORIA

### PHP (11 arquivos)
1. `config.php` - Configuração central
2. `class.php` - Classes compartilhadas
3. `config_env.js.php` - Variáveis para JS
4. `add_flyingdonkeys.php` - Integração FlyingDonkeys
5. `add_webflow_octa.php` - Integração OctaDesk
6. `send_email_notification_endpoint.php` - Endpoint de email
7. `send_admin_notification_ses.php` - Envio AWS SES
8. `cpf-validate.php` - Validação CPF
9. `placa-validate.php` - Validação placa
10. `ProfessionalLogger.php` - Sistema de logging
11. `log_endpoint.php` - Endpoint de logs

### JavaScript (3 arquivos)
1. `MODAL_WHATSAPP_DEFINITIVO.js` - Modal WhatsApp
2. `FooterCodeSiteDefinitivoCompleto.js` - Código principal
3. `webflow_injection_limpo.js` - Injeção Webflow

### Configuração (1 arquivo)
1. `composer.json` - Dependências PHP

---

## 🔗 DEPENDÊNCIAS ENTRE ARQUIVOS

### Hierarquia de Dependências:

```
config.php (base)
├── class.php
├── config_env.js.php
├── add_flyingdonkeys.php
├── add_webflow_octa.php
├── send_email_notification_endpoint.php
│   ├── ProfessionalLogger.php
│   └── send_admin_notification_ses.php
├── log_endpoint.php
│   └── ProfessionalLogger.php
├── cpf-validate.php
└── placa-validate.php

JavaScript:
├── MODAL_WHATSAPP_DEFINITIVO.js
│   └── config_env.js.php
├── FooterCodeSiteDefinitivoCompleto.js
│   └── config_env.js.php
└── webflow_injection_limpo.js
```

---

## 📍 LOCALIZAÇÃO DOS ARQUIVOS

### Local (Windows):
- **Diretório:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`
- **Arquivos de Configuração:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/`

### Servidor (Linux):
- **Diretório:** `/var/www/html/dev/root/`
- **Acessível via:** `https://dev.bssegurosimediato.com.br/`

---

## 🚀 DEPLOY

### Script de Cópia:
- **Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/copiar_arquivos_servidor.ps1`
- **Função:** Copia todos os arquivos do projeto para o servidor
- **Validação:** Executa `verificar_integridade_arquivos.ps1` antes de copiar

### Script de Verificação:
- **Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/verificar_integridade_arquivos.ps1`
- **Função:** Verifica integridade, sintaxe e conteúdo dos arquivos antes do deploy

---

## ⚠️ ARQUIVOS NÃO INCLUÍDOS NO PROJETO

### Arquivos de Teste:
- `test_*.php` - Arquivos de teste (não copiados para servidor)
- `debug_*.php` - Arquivos de debug (não copiados para servidor)
- `diagnostico_*.php` - Arquivos de diagnóstico (não copiados para servidor)

### Arquivos Legados:
- `add_travelangels.php` - Substituído por `add_flyingdonkeys.php`
- Arquivos em `Lixo/` - Arquivos antigos não utilizados

### Arquivos de Configuração de Servidor:
- `nginx_*.conf` - Em `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/`
- Não são arquivos do projeto, são configurações de infraestrutura

---

## 📝 NOTAS

1. **Arquivos Essenciais:** Todos os 15 arquivos listados são essenciais para o funcionamento do sistema
2. **Backups:** Sempre criar backup antes de modificar qualquer arquivo
3. **Deploy:** Sempre usar o script `copiar_arquivos_servidor.ps1` para garantir que todos os arquivos sejam copiados
4. **Verificação:** Sempre executar `verificar_integridade_arquivos.ps1` antes do deploy

---

**Documento criado em:** 10/11/2025  
**Mantido por:** Sistema de documentação do projeto

