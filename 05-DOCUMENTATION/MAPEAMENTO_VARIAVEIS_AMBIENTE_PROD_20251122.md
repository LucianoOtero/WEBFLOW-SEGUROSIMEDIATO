# 📋 MAPEAMENTO: Variáveis de Ambiente em Produção

**Data de Criação:** 22/11/2025  
**Ambiente:** PRODUÇÃO (PROD)  
**Servidor:** `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)  
**Arquivo de Configuração:** `/etc/php/8.3/fpm/pool.d/www.conf`  
**Método de Coleta:** `php-fpm8.3 -tt` (teste de configuração)  
**Status:** ✅ **COMPLETO** - Todas as variáveis mapeadas

---

## 📊 RESUMO EXECUTIVO

### Estatísticas

| Métrica | Valor |
|---------|-------|
| **Total de Variáveis** | 20 variáveis |
| **Variáveis de Ambiente** | 20 |
| **Variáveis de Aplicação** | 3 |
| **Variáveis AWS** | 4 |
| **Variáveis de Banco de Dados** | 4 |
| **Variáveis de Integração** | 5 |
| **Variáveis de Sistema** | 4 |

### Categorias

- 🔵 **Aplicação:** 3 variáveis
- 🟢 **AWS SES:** 4 variáveis
- 🟡 **Banco de Dados:** 4 variáveis
- 🟠 **Integrações:** 5 variáveis
- ⚪ **Sistema:** 4 variáveis

---

## 🔵 CATEGORIA 1: VARIÁVEIS DE APLICAÇÃO (3 variáveis)

### **1.1. `APP_BASE_DIR`**
- **Valor:** `/var/www/html/prod/root`
- **Tipo:** Caminho do sistema de arquivos
- **Uso:** Diretório raiz da aplicação em produção
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Específico do ambiente PROD

### **1.2. `APP_BASE_URL`**
- **Valor:** `https://prod.bssegurosimediato.com.br`
- **Tipo:** URL
- **Uso:** URL base da aplicação em produção
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Específico do ambiente PROD

### **1.3. `APP_CORS_ORIGINS`**
- **Valor:** `https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br`
- **Tipo:** Lista de URLs (separadas por vírgula)
- **Uso:** Origens permitidas para CORS (Cross-Origin Resource Sharing)
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Específico do ambiente PROD

---

## 🟢 CATEGORIA 2: VARIÁVEIS AWS SES (4 variáveis)

### **2.1. `AWS_ACCESS_KEY_ID`**
- **Valor:** `AKIA3JCQSJTSMSKFZPW3`
- **Tipo:** Credencial AWS
- **Uso:** Chave de acesso AWS para SES (Simple Email Service)
- **Prioridade:** 🔴 **CRÍTICO**
- **Segurança:** ⚠️ **CREDENCIAL SENSÍVEL** - Não compartilhar
- **Observação:** Credencial específica de PROD (diferente de DEV)

### **2.2. `AWS_SECRET_ACCESS_KEY`**
- **Valor:** `tfgqmsB0bG4FfHjYjej0ZXdMDouhA5tJ0xk4Pn4z`
- **Tipo:** Credencial AWS
- **Uso:** Chave secreta AWS para SES
- **Prioridade:** 🔴 **CRÍTICO**
- **Segurança:** ⚠️ **CREDENCIAL SENSÍVEL** - Não compartilhar
- **Observação:** Credencial específica de PROD (diferente de DEV)

### **2.3. `AWS_REGION`**
- **Valor:** `sa-east-1`
- **Tipo:** Região AWS
- **Uso:** Região AWS onde o serviço SES está configurado
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Região América do Sul (São Paulo)

### **2.4. `AWS_SES_ADMIN_EMAILS`**
- **Valor:** `lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com`
- **Tipo:** Lista de emails (separados por vírgula)
- **Uso:** Emails dos administradores que recebem notificações do sistema
- **Prioridade:** 🟡 **ALTO**
- **Observação:** Lista de emails para notificações administrativas

### **2.5. `AWS_SES_FROM_EMAIL`**
- **Valor:** `noreply@bssegurosimediato.com.br`
- **Tipo:** Email
- **Uso:** Email remetente padrão para envio de emails via AWS SES
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** ⚠️ **VALOR INCORRETO** - Deveria ser `noreply@bpsegurosimediato.com.br` (domínio verificado no AWS SES)

---

## 🟡 CATEGORIA 3: VARIÁVEIS DE BANCO DE DADOS (4 variáveis)

### **3.1. `LOG_DB_HOST`**
- **Valor:** `localhost`
- **Tipo:** Hostname/IP
- **Uso:** Host do servidor de banco de dados para logs
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Banco de dados local no mesmo servidor

### **3.2. `LOG_DB_NAME`**
- **Valor:** `rpa_logs_prod`
- **Tipo:** Nome do banco de dados
- **Uso:** Nome do banco de dados para armazenamento de logs
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Específico do ambiente PROD

### **3.3. `LOG_DB_USER`**
- **Valor:** `rpa_logger_prod`
- **Tipo:** Usuário do banco de dados
- **Uso:** Usuário para conexão com banco de dados de logs
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Específico do ambiente PROD

### **3.4. `LOG_DB_PASS`**
- **Valor:** `tYbAwe7QkKNrHSRhaWplgsSxt`
- **Tipo:** Senha do banco de dados
- **Uso:** Senha para conexão com banco de dados de logs
- **Prioridade:** 🔴 **CRÍTICO**
- **Segurança:** ⚠️ **CREDENCIAL SENSÍVEL** - Não compartilhar

### **3.5. `LOG_DB_PORT`**
- **Valor:** `3306`
- **Tipo:** Porta
- **Uso:** Porta do servidor de banco de dados MySQL/MariaDB
- **Prioridade:** 🟡 **ALTO**
- **Observação:** Porta padrão MySQL/MariaDB

---

## 🟠 CATEGORIA 4: VARIÁVEIS DE INTEGRAÇÃO (5 variáveis)

### **4.1. `ESPOCRM_URL`**
- **Valor:** `https://flyingdonkeys.com.br`
- **Tipo:** URL
- **Uso:** URL base da API EspoCRM
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Específico do ambiente PROD (diferente de DEV)

### **4.2. `ESPOCRM_API_KEY`**
- **Valor:** `82d5f667f3a65a9a43341a0705be2b0c`
- **Tipo:** Chave de API
- **Uso:** Chave de autenticação para API EspoCRM
- **Prioridade:** 🔴 **CRÍTICO**
- **Segurança:** ⚠️ **CREDENCIAL SENSÍVEL** - Não compartilhar
- **Observação:** Credencial específica de PROD (diferente de DEV)

### **4.3. `OCTADESK_API_BASE`**
- **Valor:** `https://o205242-d60.api004.octadesk.services`
- **Tipo:** URL
- **Uso:** URL base da API OctaDesk
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Endpoint da API OctaDesk

### **4.4. `OCTADESK_API_KEY`**
- **Valor:** `b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b`
- **Tipo:** Chave de API
- **Uso:** Chave de autenticação para API OctaDesk
- **Prioridade:** 🔴 **CRÍTICO**
- **Segurança:** ⚠️ **CREDENCIAL SENSÍVEL** - Não compartilhar

### **4.5. `WEBFLOW_SECRET_FLYINGDONKEYS`**
- **Valor:** `50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51`
- **Tipo:** Secret Key
- **Uso:** Secret key para webhooks do Webflow (FlyingDonkeys)
- **Prioridade:** 🔴 **CRÍTICO**
- **Segurança:** ⚠️ **CREDENCIAL SENSÍVEL** - Não compartilhar
- **Observação:** Credencial específica de PROD (diferente de DEV)

### **4.6. `WEBFLOW_SECRET_OCTADESK`**
- **Valor:** `4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd`
- **Tipo:** Secret Key
- **Uso:** Secret key para webhooks do Webflow (OctaDesk)
- **Prioridade:** 🔴 **CRÍTICO**
- **Segurança:** ⚠️ **CREDENCIAL SENSÍVEL** - Não compartilhar
- **Observação:** Credencial específica de PROD (diferente de DEV)

---

## ⚪ CATEGORIA 5: VARIÁVEIS DE SISTEMA (4 variáveis)

### **5.1. `PHP_ENV`**
- **Valor:** `production`
- **Tipo:** Ambiente
- **Uso:** Identifica o ambiente atual da aplicação (production/development)
- **Prioridade:** 🔴 **CRÍTICO**
- **Observação:** Define comportamento da aplicação baseado no ambiente

### **5.2. `LOG_DIR`**
- **Valor:** `/var/log/webflow-segurosimediato`
- **Tipo:** Caminho do sistema de arquivos
- **Uso:** Diretório para armazenamento de arquivos de log
- **Prioridade:** 🟡 **ALTO**
- **Observação:** ⚠️ **VARIÁVEL EXISTE APENAS EM PROD** - Não existe em DEV

---

## 📋 LISTA COMPLETA DE VARIÁVEIS (ORDEM ALFABÉTICA)

| # | Variável | Valor | Categoria | Prioridade |
|---|----------|-------|-----------|------------|
| 1 | `APP_BASE_DIR` | `/var/www/html/prod/root` | Aplicação | 🔴 CRÍTICO |
| 2 | `APP_BASE_URL` | `https://prod.bssegurosimediato.com.br` | Aplicação | 🔴 CRÍTICO |
| 3 | `APP_CORS_ORIGINS` | `https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br` | Aplicação | 🔴 CRÍTICO |
| 4 | `AWS_ACCESS_KEY_ID` | `AKIA3JCQSJTSMSKFZPW3` | AWS SES | 🔴 CRÍTICO |
| 5 | `AWS_REGION` | `sa-east-1` | AWS SES | 🔴 CRÍTICO |
| 6 | `AWS_SECRET_ACCESS_KEY` | `tfgqmsB0bG4FfHjYjej0ZXdMDouhA5tJ0xk4Pn4z` | AWS SES | 🔴 CRÍTICO |
| 7 | `AWS_SES_ADMIN_EMAILS` | `lrotero@gmail.com,alex.kaminski@imediatoseguros.com.br,alexkaminski70@gmail.com` | AWS SES | 🟡 ALTO |
| 8 | `AWS_SES_FROM_EMAIL` | `noreply@bssegurosimediato.com.br` | AWS SES | 🔴 CRÍTICO |
| 9 | `ESPOCRM_API_KEY` | `82d5f667f3a65a9a43341a0705be2b0c` | Integração | 🔴 CRÍTICO |
| 10 | `ESPOCRM_URL` | `https://flyingdonkeys.com.br` | Integração | 🔴 CRÍTICO |
| 11 | `LOG_DB_HOST` | `localhost` | Banco de Dados | 🔴 CRÍTICO |
| 12 | `LOG_DB_NAME` | `rpa_logs_prod` | Banco de Dados | 🔴 CRÍTICO |
| 13 | `LOG_DB_PASS` | `tYbAwe7QkKNrHSRhaWplgsSxt` | Banco de Dados | 🔴 CRÍTICO |
| 14 | `LOG_DB_PORT` | `3306` | Banco de Dados | 🟡 ALTO |
| 15 | `LOG_DB_USER` | `rpa_logger_prod` | Banco de Dados | 🔴 CRÍTICO |
| 16 | `LOG_DIR` | `/var/log/webflow-segurosimediato` | Sistema | 🟡 ALTO |
| 17 | `OCTADESK_API_BASE` | `https://o205242-d60.api004.octadesk.services` | Integração | 🔴 CRÍTICO |
| 18 | `OCTADESK_API_KEY` | `b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b` | Integração | 🔴 CRÍTICO |
| 19 | `PHP_ENV` | `production` | Sistema | 🔴 CRÍTICO |
| 20 | `WEBFLOW_SECRET_FLYINGDONKEYS` | `50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51` | Integração | 🔴 CRÍTICO |
| 21 | `WEBFLOW_SECRET_OCTADESK` | `4fd920be63ac4933f2e5f912132fc39d13f8bf19383ecddf1ea2867236112cbd` | Integração | 🔴 CRÍTICO |

**Total:** 21 variáveis

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### Variáveis com Problemas Identificados

1. **`AWS_SES_FROM_EMAIL`**
   - **Problema:** Valor atual `noreply@bssegurosimediato.com.br` está incorreto
   - **Valor Correto:** `noreply@bpsegurosimediato.com.br` (domínio verificado no AWS SES)
   - **Ação Necessária:** Modificar valor em PROD
   - **Prioridade:** 🔴 **CRÍTICO**

### Variáveis Específicas de PROD

As seguintes variáveis têm valores diferentes em DEV e PROD (comportamento esperado):

- `APP_BASE_DIR`: `/var/www/html/prod/root` (PROD) vs `/var/www/html/dev/root` (DEV)
- `APP_BASE_URL`: `https://prod.bssegurosimediato.com.br` (PROD) vs `https://dev.bssegurosimediato.com.br` (DEV)
- `APP_CORS_ORIGINS`: Valores específicos de PROD
- `ESPOCRM_URL`: `https://flyingdonkeys.com.br` (PROD) vs `https://dev.flyingdonkeys.com.br` (DEV)
- `ESPOCRM_API_KEY`: Valores diferentes (esperado)
- `LOG_DB_NAME`: `rpa_logs_prod` (PROD) vs `rpa_logs_dev` (DEV)
- `LOG_DB_USER`: `rpa_logger_prod` (PROD) vs `rpa_logger_dev` (DEV)
- `PHP_ENV`: `production` (PROD) vs `development` (DEV)
- `AWS_ACCESS_KEY_ID`: Credenciais diferentes (esperado)
- `AWS_SECRET_ACCESS_KEY`: Credenciais diferentes (esperado)
- `WEBFLOW_SECRET_FLYINGDONKEYS`: Valores diferentes (esperado)
- `WEBFLOW_SECRET_OCTADESK`: Valores diferentes (esperado)

### Variável Existe Apenas em PROD

- **`LOG_DIR`**: Existe apenas em PROD (`/var/log/webflow-segurosimediato`), não existe em DEV

### Credenciais Sensíveis

As seguintes variáveis contêm credenciais sensíveis e **NÃO devem ser compartilhadas**:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `ESPOCRM_API_KEY`
- `LOG_DB_PASS`
- `OCTADESK_API_KEY`
- `WEBFLOW_SECRET_FLYINGDONKEYS`
- `WEBFLOW_SECRET_OCTADESK`

---

## 📊 COMPARAÇÃO COM DEV

### Variáveis que Existem em PROD mas NÃO em DEV

- `LOG_DIR` = `/var/log/webflow-segurosimediato`

### Variáveis que Existem em DEV mas NÃO em PROD (20 variáveis)

Estas variáveis precisam ser adicionadas em PROD:

**CRÍTICO (3 variáveis):**
- `APILAYER_KEY`
- `SAFETY_TICKET`
- `SAFETY_API_KEY`

**ALTO (13 variáveis):**
- `AWS_SES_FROM_NAME`
- `VIACEP_BASE_URL`
- `APILAYER_BASE_URL`
- `SAFETYMAILS_OPTIN_BASE`
- `RPA_API_BASE_URL`
- `SAFETYMAILS_BASE_DOMAIN`
- `PH3A_API_KEY`
- `PH3A_DATA_URL`
- `PH3A_LOGIN_URL`
- `PH3A_PASSWORD`
- `PH3A_USERNAME`
- `PLACAFIPE_API_TOKEN`
- `PLACAFIPE_API_URL`
- `SUCCESS_PAGE_URL`

**MÉDIO (4 variáveis):**
- `RPA_ENABLED`
- `USE_PHONE_API`
- `VALIDAR_PH3A`
- `OCTADESK_FROM`

**Total:** 20 variáveis a adicionar + 1 variável a modificar (`AWS_SES_FROM_EMAIL`)

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- **Análise Comparativa:** `ANALISE_VARIAVEIS_AMBIENTE_DEV_PROD_20251122.md`
- **Projeto de Atualização:** `PROJETO_ATUALIZAR_VARIAVEIS_AMBIENTE_PROD_20251122.md`
- **Tracking de Alterações:** `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`

---

## 📝 METADADOS DO MAPEAMENTO

- **Data de Coleta:** 22/11/2025 21:13:05
- **Método:** `php-fpm8.3 -tt` (teste de configuração)
- **Servidor:** `prod.bssegurosimediato.com.br` (157.180.36.223)
- **Arquivo de Configuração:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Total de Variáveis Mapeadas:** 21 variáveis
- **Status:** ✅ **COMPLETO**

---

**Última Atualização:** 22/11/2025  
**Próxima Revisão:** Após atualização de variáveis em PROD

