# 🏗️ ARQUITETURA DE SERVIDORES - WEBFLOW SEGUROS IMEDIATO

**Data de Criação:** 11/11/2025  
**Última Atualização:** 11/11/2025  
**Status:** ✅ **ATIVO**

---

## 🖥️ SERVIDORES

### **SERVIDOR DEV (Desenvolvimento)**

| Item | Valor |
|------|-------|
| **IP Público** | `65.108.156.14` |
| **Provedor** | Hetzner Cloud |
| **Domínio** | `dev.bssegurosimediato.com.br` |
| **Ambiente** | Development |
| **Diretório Base** | `/var/www/html/dev/root/` |
| **URL Base** | `https://dev.bssegurosimediato.com.br` |
| **Status** | ✅ Ativo |

**Configurações:**
- Nginx configurado para `dev.bssegurosimediato.com.br`
- PHP-FPM com variáveis de ambiente DEV
- Certificado SSL Let's Encrypt ativo
- CORS configurado para origens de desenvolvimento

---

### **SERVIDOR PROD (Produção)**

| Item | Valor |
|------|-------|
| **IP Público** | `157.180.36.223` |
| **Provedor** | Hetzner Cloud |
| **Domínio** | `prod.bssegurosimediato.com.br` |
| **Ambiente** | Production |
| **Diretório Base** | `/var/www/html/prod/root/` |
| **URL Base** | `https://prod.bssegurosimediato.com.br` |
| **Status** | ✅ Criado (aguardando configuração) |

**Configurações:**
- Criado a partir de snapshot do servidor DEV
- Nginx será configurado para `prod.bssegurosimediato.com.br`
- PHP-FPM será ajustado com variáveis de ambiente PROD
- Certificado SSL Let's Encrypt será obtido após configuração DNS
- CORS configurado para origens de produção

---

## 🌐 DOMÍNIOS E DNS

### **Domínios Configurados**

| Domínio | Servidor | IP | Status |
|---------|----------|----|----|
| `dev.bssegurosimediato.com.br` | DEV | `65.108.156.14` | ✅ Ativo |
| `prod.bssegurosimediato.com.br` | PROD | `157.180.36.223` | ⏳ Aguardando DNS |

---

## 🔧 CONFIGURAÇÕES DE SERVIDOR

### **Servidor DEV (65.108.156.14)**

**Nginx:**
- Arquivo de configuração: `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`
- Document root: `/var/www/html/dev/root`
- SSL: Let's Encrypt (`/etc/letsencrypt/live/dev.bssegurosimediato.com.br/`)

**PHP-FPM:**
- Pool: `/etc/php/8.3/fpm/pool.d/www.conf`
- Variáveis de ambiente: DEV configuradas
- `APP_BASE_DIR`: `/var/www/html/dev/root`
- `APP_BASE_URL`: `https://dev.bssegurosimediato.com.br`
- `APP_ENVIRONMENT`: `development`

**Estrutura de Diretórios:**
```
/var/www/html/dev/root/
├── *.php (arquivos PHP)
├── *.js (arquivos JavaScript)
├── email_templates/
│   ├── template_modal.php
│   ├── template_primeiro_contato.php
│   └── template_logging.php
└── TESTES/
```

---

### **Servidor PROD (157.180.36.223)**

**Nginx:**
- Arquivo de configuração: `/etc/nginx/sites-available/prod.bssegurosimediato.com.br` (a criar)
- Document root: `/var/www/html/prod/root`
- SSL: Let's Encrypt (a obter após DNS)

**PHP-FPM:**
- Pool: `/etc/php/8.3/fpm/pool.d/www.conf` (a ajustar)
- Variáveis de ambiente: PROD (a configurar)
- `APP_BASE_DIR`: `/var/www/html/prod/root` (a configurar)
- `APP_BASE_URL`: `https://prod.bssegurosimediato.com.br` (a configurar)
- `APP_ENVIRONMENT`: `production` (a configurar)

**Estrutura de Diretórios:**
```
/var/www/html/prod/root/
├── *.php (arquivos PHP - a copiar)
├── *.js (arquivos JavaScript - a copiar)
├── email_templates/ (a copiar)
│   ├── template_modal.php
│   ├── template_primeiro_contato.php
│   └── template_logging.php
└── TESTES/ (opcional)
```

---

## 📊 COMPARAÇÃO DEV vs PROD

| Aspecto | DEV | PROD |
|---------|-----|------|
| **IP** | `65.108.156.14` | `157.180.36.223` |
| **Domínio** | `dev.bssegurosimediato.com.br` | `prod.bssegurosimediato.com.br` |
| **Diretório** | `/var/www/html/dev/root/` | `/var/www/html/prod/root/` |
| **URL Base** | `https://dev.bssegurosimediato.com.br` | `https://prod.bssegurosimediato.com.br` |
| **Ambiente** | `development` | `production` |
| **CORS Origins** | `segurosimediato-dev.webflow.io` | `segurosimediato.com.br` |
| **Banco de Dados** | `rpa_logs_dev` | `rpa_logs_prod` |
| **EspoCRM** | `dev.flyingdonkeys.com.br` | `flyingdonkeys.com.br` |

---

## 🔐 SEGURANÇA E ACESSO

### **SSH Access**

**Servidor DEV:**
```bash
ssh root@65.108.156.14
```

**Servidor PROD:**
```bash
ssh root@157.180.36.223
```

### **Firewall**

Ambos os servidores devem ter:
- Porta 22 (SSH) - aberta
- Porta 80 (HTTP) - aberta (para redirecionamento e Certbot)
- Porta 443 (HTTPS) - aberta

---

## 📝 VARIÁVEIS DE AMBIENTE

### **Variáveis Comuns (DEV e PROD)**

Estas variáveis são **iguais** em ambos os ambientes:

- `VIACEP_BASE_URL`
- `APILAYER_BASE_URL`
- `SAFETYMAILS_BASE_DOMAIN`
- `WHATSAPP_API_BASE`
- `RPA_API_BASE_URL`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

### **Variáveis Específicas por Ambiente**

| Variável | DEV | PROD |
|----------|-----|------|
| `APP_BASE_DIR` | `/var/www/html/dev/root` | `/var/www/html/prod/root` |
| `APP_BASE_URL` | `https://dev.bssegurosimediato.com.br` | `https://prod.bssegurosimediato.com.br` |
| `APP_ENVIRONMENT` | `development` | `production` |
| `APP_CORS_ORIGINS` | `segurosimediato-dev.webflow.io,...` | `segurosimediato.com.br,...` |
| `LOG_DB_NAME` | `rpa_logs_dev` | `rpa_logs_prod` |
| `LOG_DB_USER` | `rpa_logger_dev` | `rpa_logger_prod` |
| `ESPOCRM_URL` | `https://dev.flyingdonkeys.com.br` | `https://flyingdonkeys.com.br` |
| `WEBFLOW_SECRET_FLYINGDONKEYS` | Secret key DEV | Secret key PROD |
| `WEBFLOW_SECRET_OCTADESK` | Secret key DEV | Secret key PROD |

---

## 🔐 SECRET KEYS DE WEBHOOKS WEBFLOW

### **O que são Secret Keys?**

As secret keys são chaves de autenticação fornecidas pelo Webflow para validar que as requisições de webhook são realmente originadas do Webflow e não de fontes não autorizadas.

### **Onde são Armazenadas?**

#### **1. Variáveis de Ambiente PHP-FPM (Prioridade Máxima)**

**Localização:** `/etc/php/8.3/fpm/pool.d/www.conf` (no servidor)

**Variáveis:**
- `env[WEBFLOW_SECRET_FLYINGDONKEYS]` - Secret key para webhook `add_flyingdonkeys`
- `env[WEBFLOW_SECRET_OCTADESK]` - Secret key para webhook `add_webflow_octa`

**Como são usadas:**
- Carregadas automaticamente em todas as requisições PHP
- Acessíveis via `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']` e `$_ENV['WEBFLOW_SECRET_OCTADESK']`

#### **2. Arquivo `config.php` (Fallback)**

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/config.php`

**Funções:**
- `getWebflowSecretFlyingDonkeys()` - Retorna secret key para DEV ou PROD
- `getWebflowSecretOctaDesk()` - Retorna secret key para DEV ou PROD

**Lógica:**
1. Tenta usar variável de ambiente `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']`
2. Se não existir, usa fallback hardcoded baseado em `isDevelopment()`

#### **3. Arquivo `dev_config.php` (Opcional - Desenvolvimento)**

**Localização:** `dev_config.php` (raiz do projeto)

**Array:**
```php
$DEV_WEBFLOW_SECRETS = [
    'flyingdonkeys' => '...',
    'octadesk' => '...'
];
```

**Uso:**
- Carregado por `add_flyingdonkeys.php` quando em ambiente de desenvolvimento
- Usado como fallback adicional se variável de ambiente não estiver disponível

### **Como Atualizar Secret Keys?**

**Processo completo documentado em:** `PROJETO_ATUALIZACAO_SECRET_KEYS_WEBHOOKS.md`

**Resumo:**
1. Obter novas secret keys do Webflow Dashboard
2. Atualizar `config.php` (fallback DEV)
3. Atualizar variáveis PHP-FPM no servidor
4. Reiniciar PHP-FPM
5. Testar webhooks

**⚠️ IMPORTANTE:**
- Secret keys DEV e PROD são diferentes
- Nunca commitar secret keys no Git
- Sempre fazer backup antes de atualizar
- Testar em DEV antes de atualizar PROD

---

## 🌍 CLOUDFLARE / DNS

### **Configuração DNS Necessária**

**Para o servidor PROD (`157.180.36.223`):**

1. **Registro A:**
   - **Nome:** `prod`
   - **Tipo:** A
   - **Conteúdo:** `157.180.36.223`
   - **TTL:** 3600 (ou Auto)

### **Status DNS**

| Domínio | IP Atual | IP Esperado | Status |
|---------|----------|-------------|--------|
| `prod.bssegurosimediato.com.br` | ? | `157.180.36.223` | ⏳ Aguardando atualização |

**⚠️ IMPORTANTE:** 
- Atualize os registros DNS no Cloudflare **ANTES** de obter certificado SSL
- Aguarde propagação DNS (15 minutos a 1 hora, máximo 48 horas)

---

## 📋 CHECKLIST DE CONFIGURAÇÃO PROD

### **Fase 1: Servidor Criado**
- [x] Servidor PROD criado a partir de snapshot
- [x] IP anotado: `157.180.36.223`
- [ ] Conectado via SSH ao servidor PROD

### **Fase 2: Ajuste de Configurações**
- [ ] Script `ajustar_dev_para_prod.sh` executado
- [ ] Variáveis de ambiente ajustadas para PROD
- [ ] Configuração Nginx PROD criada
- [ ] Estrutura de diretórios PROD criada
- [ ] Serviços reiniciados (Nginx, PHP-FPM)

### **Fase 3: Cópia de Arquivos**
- [ ] Arquivos PHP copiados para `/var/www/html/prod/root/`
- [ ] Arquivos JavaScript copiados
- [ ] Templates de email copiados
- [ ] Permissões configuradas

### **Fase 4: DNS e SSL**
- [ ] Registros DNS atualizados no Cloudflare
  - 📖 **Guia:** `GUIA_CONFIGURACAO_CLOUDFLARE_PROD.md`
  - **IP:** `157.180.36.223`
  - **Domínio:** `prod.bssegurosimediato.com.br`
- [ ] DNS propagado (verificado com `nslookup`)
- [ ] Certificado SSL obtido via Certbot
- [ ] HTTPS funcionando

### **Fase 5: Testes**
- [ ] Acesso HTTPS testado
- [ ] Endpoints PHP testados
- [ ] Arquivos JavaScript carregando
- [ ] Emails sendo enviados
- [ ] Logs funcionando

---

## 🔗 REFERÊNCIAS

- **Guia de Clonagem:** `GUIA_CLONAGEM_SERVIDOR_HETZNER.md`
- **Guia Rápido Snapshot:** `GUIA_RAPIDO_SNAPSHOT_PROD.md`
- **Script de Ajuste:** `06-SERVER-CONFIG/ajustar_dev_para_prod.sh`
- **Especificação Variáveis:** `ESPECIFICACAO_VARIAVEIS_AMBIENTE.md`

---

**Última atualização:** 11/11/2025

