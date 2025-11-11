# 🌳 ÁRVORE COMPLETA DE DEPENDÊNCIAS DO PROJETO

**Data de Criação:** 10/11/2025  
**Análise Baseada em:** `FooterCodeSiteDefinitivoCompleto.js`

---

## 📊 RESUMO EXECUTIVO

Esta árvore mapeia **TODOS** os arquivos do projeto, começando pelo arquivo raiz `FooterCodeSiteDefinitivoCompleto.js` e seguindo todas as dependências até os arquivos mais profundos.

**Total de Arquivos Identificados:** 23 arquivos (incluindo templates)

---

## 🌲 ÁRVORE DE DEPENDÊNCIAS

```
FooterCodeSiteDefinitivoCompleto.js (RAIZ)
│
├── 📄 config_env.js.php (carregado dinamicamente)
│   └── Dependências: Nenhuma (usa apenas $_ENV)
│
├── 📄 log_endpoint.php (chamado via fetch)
│   ├── 📄 config.php (via require_once)
│   └── 📄 ProfessionalLogger.php (via require_once)
│       └── Dependências: MySQL, variáveis de ambiente
│
├── 📄 cpf-validate.php (chamado via fetch)
│   └── Dependências: Nenhuma (arquivo independente)
│
├── 📄 placa-validate.php (chamado via fetch)
│   └── Dependências: Nenhuma (arquivo independente)
│
├── 📄 webflow_injection_limpo.js (injetado dinamicamente)
│   ├── 📄 placa-validate.php (chamado via fetch)
│   │   └── Dependências: Nenhuma
│   │
│   └── APIs Externas:
│       ├── https://viacep.com.br/ws/{cep}/json/
│       ├── https://apilayer.net/api/validate
│       └── https://rpaimediatoseguros.com.br/api/rpa/*
│
└── 📄 MODAL_WHATSAPP_DEFINITIVO.js (injetado dinamicamente)
    │
    ├── 📄 add_flyingdonkeys.php (chamado via fetch)
    │   ├── 📄 config.php (via require_once)
    │   │   └── Dependências: Variáveis de ambiente
    │   │
    │   └── 📄 class.php (via require_once)
    │       └── Dependências: Nenhuma
    │
    ├── 📄 add_webflow_octa.php (chamado via fetch)
    │   └── Dependências: Nenhuma (arquivo independente)
    │
    └── 📄 send_email_notification_endpoint.php (chamado via fetch)
        ├── 📄 config.php (via require_once)
        │   └── Dependências: Variáveis de ambiente
        │
        ├── 📄 ProfessionalLogger.php (via require_once)
        │   └── Dependências: MySQL, variáveis de ambiente
        │
        └── 📄 send_admin_notification_ses.php (via require_once)
            ├── 📄 aws_ses_config.php (via require_once)
            │   └── Dependências: Variáveis de ambiente AWS
            │
            ├── 📄 email_template_loader.php (via require_once) ⚠️
            │   ├── Status: Arquivo faltante (existe apenas em backup)
            │   ├── 📄 email_templates/template_logging.php
            │   ├── 📄 email_templates/template_modal.php
            │   └── 📄 email_templates/template_primeiro_contato.php (referenciado, pode não existir)
            │
            └── 📄 vendor/autoload.php (via require)
                └── Dependências: Composer, aws/aws-sdk-php
```

---

## 📋 LISTA COMPLETA DE ARQUIVOS

### 🟢 Nível 1 - Arquivo Raiz
1. **FooterCodeSiteDefinitivoCompleto.js** - Arquivo principal do site

### 🟡 Nível 2 - Arquivos Carregados/Chamados pelo Raiz
2. **config_env.js.php** - Variáveis de ambiente para JavaScript
3. **log_endpoint.php** - Endpoint de logging
4. **cpf-validate.php** - Validação de CPF
5. **placa-validate.php** - Validação de placa
6. **webflow_injection_limpo.js** - Script de injeção Webflow
7. **MODAL_WHATSAPP_DEFINITIVO.js** - Modal WhatsApp

### 🔵 Nível 3 - Arquivos Chamados pelo Modal
8. **add_flyingdonkeys.php** - Integração FlyingDonkeys CRM
9. **add_webflow_octa.php** - Integração OctaDesk
10. **send_email_notification_endpoint.php** - Endpoint de email

### 🟣 Nível 4 - Arquivos Base e Dependências
11. **config.php** - Configuração central (usado por múltiplos arquivos)
12. **class.php** - Classes compartilhadas
13. **ProfessionalLogger.php** - Sistema de logging
14. **send_admin_notification_ses.php** - Função de envio AWS SES

### 🔴 Nível 5 - Dependências Profundas
15. **aws_ses_config.php** - Configuração AWS SES
16. **email_template_loader.php** - ⚠️ **ARQUIVO NÃO ENCONTRADO**
17. **vendor/autoload.php** - Autoloader do Composer (gerado)
18. **composer.json** - Dependências PHP

### 🟠 Templates de Email (Carregados por email_template_loader.php)
19. **email_templates/template_logging.php** - Template para logs de erro
20. **email_templates/template_modal.php** - Template para emails do modal
21. **email_templates/template_primeiro_contato.php** - ⚠️ Referenciado mas pode não existir

### 🔴 Arquivos de Configuração (Não são dependências diretas)
22. **nginx_dev_config.conf** - Configuração Nginx (em 06-SERVER-CONFIG/)
23. **config/dev_config.php** - ⚠️ Configuração DEV (condicional, pode não existir)

---

## 🔍 ANÁLISE DETALHADA POR ARQUIVO

### 1. FooterCodeSiteDefinitivoCompleto.js
**Chamadas Identificadas:**
- `config_env.js.php` (carregado dinamicamente via script tag)
- `log_endpoint.php` (via `sendLogToProfessionalSystem()`)
- `cpf-validate.php` (via `window.validateCPF()`)
- `placa-validate.php` (via `window.validatePlaca()`)
- `webflow_injection_limpo.js` (injetado dinamicamente)
- `MODAL_WHATSAPP_DEFINITIVO.js` (injetado dinamicamente)

**APIs Externas:**
- `https://viacep.com.br/ws/{cep}/json/` (busca CEP)

---

### 2. config_env.js.php
**Dependências:** Nenhuma
**Função:** Expõe `window.APP_BASE_URL` e `window.APP_ENVIRONMENT`
**Usado por:** Todos os arquivos JavaScript

---

### 3. log_endpoint.php
**Dependências:**
- `config.php` (via `require_once`)
- `ProfessionalLogger.php` (via `require_once`)

**Função:** Recebe logs do JavaScript e salva no banco de dados
**Chamado por:** `FooterCodeSiteDefinitivoCompleto.js` → `sendLogToProfessionalSystem()`

---

### 4. cpf-validate.php
**Dependências:** Nenhuma
**Função:** Valida CPF
**Chamado por:** `FooterCodeSiteDefinitivoCompleto.js` → `window.validateCPF()`

---

### 5. placa-validate.php
**Dependências:** Nenhuma
**Função:** Valida placa de veículo
**Chamado por:** 
- `FooterCodeSiteDefinitivoCompleto.js` → `window.validatePlaca()`
- `webflow_injection_limpo.js` → validação de placa

---

### 6. webflow_injection_limpo.js
**Chamadas Identificadas:**
- `placa-validate.php` (via fetch)
- APIs externas (ViaCEP, APILayer, SafetyMails, RPA API)

**Função:** Script de injeção no Webflow com funcionalidades RPA
**Injetado por:** `FooterCodeSiteDefinitivoCompleto.js`

---

### 7. MODAL_WHATSAPP_DEFINITIVO.js
**Chamadas Identificadas:**
- `add_flyingdonkeys.php` (via `getEndpointUrl('flyingdonkeys')`)
- `add_webflow_octa.php` (via `getEndpointUrl('octadesk')`)
- `send_email_notification_endpoint.php` (via fetch direto)

**Função:** Modal de WhatsApp para captura de leads
**Injetado por:** `FooterCodeSiteDefinitivoCompleto.js`

---

### 8. add_flyingdonkeys.php
**Dependências:**
- `config.php` (via `require_once`)
- `class.php` (via `require_once`)
- `config/dev_config.php` (condicional, apenas em DEV)

**Função:** Integração com FlyingDonkeys CRM
**Chamado por:** `MODAL_WHATSAPP_DEFINITIVO.js`

---

### 9. add_webflow_octa.php
**Dependências:** Nenhuma
**Função:** Integração com OctaDesk
**Chamado por:** `MODAL_WHATSAPP_DEFINITIVO.js`

---

### 10. send_email_notification_endpoint.php
**Dependências:**
- `config.php` (via `require_once`)
- `ProfessionalLogger.php` (via `require_once`)
- `send_admin_notification_ses.php` (via `require_once`)

**Função:** Endpoint para envio de notificações por email
**Chamado por:** `MODAL_WHATSAPP_DEFINITIVO.js`

---

### 11. config.php
**Dependências:** Variáveis de ambiente (`$_ENV`)
**Função:** Configuração central do sistema
**Usado por:** Múltiplos arquivos PHP

---

### 12. class.php
**Dependências:** Nenhuma
**Função:** Classes compartilhadas e utilitários
**Usado por:** `add_flyingdonkeys.php`

---

### 13. ProfessionalLogger.php
**Dependências:** 
- MySQL (via PDO)
- Variáveis de ambiente de banco de dados

**Função:** Sistema de logging profissional
**Usado por:** 
- `log_endpoint.php`
- `send_email_notification_endpoint.php`

---

### 14. send_admin_notification_ses.php
**Dependências:**
- `aws_ses_config.php` (via `require_once`)
- `email_template_loader.php` (via `require_once`) ⚠️
- `vendor/autoload.php` (via `require`)

**Função:** Envio de emails via AWS SES
**Usado por:** `send_email_notification_endpoint.php`

---

### 15. aws_ses_config.php
**Dependências:** Variáveis de ambiente AWS
**Função:** Configuração AWS SES
**Usado por:** `send_admin_notification_ses.php`

---

### 16. email_template_loader.php ⚠️
**Status:** **ARQUIVO FALTANTE (existe apenas em backup)**
**Localização Backup:** `backups/20251110_variaveis_ambiente/email_template_loader.php.backup_20251110_125248`
**Referenciado por:** `send_admin_notification_ses.php` (linha 21)
**Observação:** Diretório `email_templates/` existe com `template_logging.php` e `template_modal.php`
**Ação Necessária:** **RESTAURAR DO BACKUP** - Arquivo é necessário para funcionamento do sistema de email

---

### 17. vendor/autoload.php
**Dependências:** Composer, `composer.json`
**Função:** Autoloader do Composer (gerado automaticamente)
**Usado por:** `send_admin_notification_ses.php`

---

### 18. composer.json
**Dependências:** Nenhuma
**Função:** Define dependências PHP (aws/aws-sdk-php)
**Usado por:** Composer para gerar `vendor/autoload.php`

---

## ⚠️ PROBLEMAS IDENTIFICADOS

### 1. Arquivo Faltante - CRÍTICO
- **email_template_loader.php** - Referenciado em `send_admin_notification_ses.php` (linha 21) mas não encontrado
  - **Localização Backup:** `backups/20251110_variaveis_ambiente/email_template_loader.php.backup_20251110_125248`
  - **Impacto:** **ERRO FATAL** - Sistema de email não funcionará sem este arquivo
  - **Ação:** **RESTAURAR DO BACKUP IMEDIATAMENTE**
  - **Templates Dependentes:**
    - `email_templates/template_logging.php` ✅ (existe)
    - `email_templates/template_modal.php` ✅ (existe)
    - `email_templates/template_primeiro_contato.php` ⚠️ (referenciado, verificar se existe)

### 2. Arquivo Condicional
- **config/dev_config.php** - Carregado apenas em ambiente DEV
  - **Status:** Pode não existir em produção
  - **Impacto:** Baixo (carregamento é condicional)

---

## 📊 ESTATÍSTICAS

- **Total de Arquivos:** 23
- **Arquivos JavaScript:** 3
- **Arquivos PHP:** 17 (incluindo templates)
- **Arquivos de Configuração:** 2
- **Arquivos Faltantes:** 1 (email_template_loader.php - existe em backup)
- **Templates de Email:** 2-3 (template_primeiro_contato pode não existir)
- **APIs Externas:** 5+ (ViaCEP, APILayer, SafetyMails, RPA API, Google Fonts)

---

## 🔗 DEPENDÊNCIAS EXTERNAS

### APIs Externas Chamadas:
1. **ViaCEP** - `https://viacep.com.br/ws/{cep}/json/`
2. **APILayer** - `https://apilayer.net/api/validate`
3. **SafetyMails** - `https://{ticket}.safetymails.com/api/{code}`
4. **RPA API** - `https://rpaimediatoseguros.com.br/api/rpa/*`
5. **Google Fonts** - `https://fonts.googleapis.com/css2?family=Titillium+Web`

### Bibliotecas Externas:
1. **SweetAlert2** - `https://cdn.jsdelivr.net/npm/sweetalert2@11.14.0/`
2. **jQuery** - (assumido, usado pelo modal)

---

## 📝 NOTAS IMPORTANTES

1. **Arquivos Gerados:** `vendor/autoload.php` é gerado pelo Composer, não deve ser versionado
2. **Arquivos de Configuração:** `nginx_dev_config.conf` está em `06-SERVER-CONFIG/`, não é parte do código do projeto
3. **Arquivos de Teste:** Não incluídos na árvore (test_*.php, debug_*.php)
4. **Arquivos Legados:** `add_travelangels.php` não está na árvore (substituído por `add_flyingdonkeys.php`)

---

**Documento criado em:** 10/11/2025  
**Última atualização:** 10/11/2025  
**Mantido por:** Sistema de documentação do projeto

