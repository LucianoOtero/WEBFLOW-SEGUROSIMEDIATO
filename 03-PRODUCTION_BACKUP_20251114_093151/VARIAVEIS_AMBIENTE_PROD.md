# 🔧 VARIÁVEIS DE AMBIENTE - PRODUÇÃO

**Data:** 14/11/2025  
**Status:** 📝 **CONFIGURAÇÃO DEFINIDA**  
**Servidor:** `157.180.36.223` (prod.bssegurosimediato.com.br)  
**Arquivo PHP-FPM:** `/etc/php/8.3/fpm/pool.d/www.conf`

---

## 🎯 OBJETIVO

Definir corretamente as variáveis de ambiente específicas de produção que precisam ser ajustadas no PHP-FPM do servidor de produção.

---

## ⚠️ PROBLEMAS IDENTIFICADOS

Com base no relatório de comparação entre DEV e PROD, as seguintes variáveis estão **incorretas** em PROD:

1. ❌ **APP_CORS_ORIGINS** - PROD está usando origens de DEV
2. ❌ **ESPOCRM_URL** - PROD está usando URL de DEV
3. ❌ **LOG_DB_NAME** - PROD está usando banco de DEV
4. ❌ **LOG_DB_USER** - PROD está usando usuário de DEV
5. ❌ **LOG_DIR** - Faltando em PROD

---

## ✅ CONFIGURAÇÃO CORRETA PARA PROD

### **1. APP_CORS_ORIGINS**

**Status Atual (PROD):** ❌ **INCORRETO**
```
env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br
```

**Valor Correto (PROD):** ✅
```
env[APP_CORS_ORIGINS] = https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br
```

**Ação:** Atualizar em `/etc/php/8.3/fpm/pool.d/www.conf`

---

### **2. ESPOCRM_URL**

**Status Atual (PROD):** ❌ **INCORRETO**
```
env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
```

**Valor Correto (PROD):** ✅
```
env[ESPOCRM_URL] = https://flyingdonkeys.com.br
```

**Nota:** Conforme especificação do usuário, o valor correto é `https://flyingdonkeys.com.br`.

**Ação:** Atualizar em `/etc/php/8.3/fpm/pool.d/www.conf`

---

### **3. LOG_DB_NAME**

**Status Atual (PROD):** ❌ **INCORRETO**
```
env[LOG_DB_NAME] = rpa_logs_dev
```

**Valor Correto (PROD):** ✅
```
env[LOG_DB_NAME] = rpa_logs_prod
```

**Ação:** Atualizar em `/etc/php/8.3/fpm/pool.d/www.conf`

---

### **4. LOG_DB_USER**

**Status Atual (PROD):** ❌ **INCORRETO**
```
env[LOG_DB_USER] = rpa_logger_dev
```

**Valor Correto (PROD):** ✅
```
env[LOG_DB_USER] = rpa_logger_prod
```

**Ação:** Atualizar em `/etc/php/8.3/fpm/pool.d/www.conf`

---

### **5. LOG_DIR**

**Status Atual (PROD):** ❌ **FALTANDO**

**Valor Correto (PROD):** ✅
```
env[LOG_DIR] = /var/log/webflow-segurosimediato
```

**Ação:** Adicionar em `/etc/php/8.3/fpm/pool.d/www.conf`

---

## 📋 VARIÁVEIS QUE JÁ ESTÃO CORRETAS

### **Variáveis Corretas (não precisam alteração):**

1. ✅ **APP_BASE_DIR**
   ```
   env[APP_BASE_DIR] = /var/www/html/prod/root
   ```
   - ✅ Correto para PROD

2. ✅ **APP_BASE_URL**
   ```
   env[APP_BASE_URL] = https://prod.bssegurosimediato.com.br
   ```
   - ✅ Correto para PROD

3. ✅ **PHP_ENV**
   ```
   env[PHP_ENV] = production
   ```
   - ✅ Correto para PROD

4. ✅ **ESPOCRM_URL** (valor atual está incorreto, mas a variável existe)
   - ⚠️ Precisa ser corrigida (ver item 2 acima)

5. ✅ **LOG_DB_HOST**
   ```
   env[LOG_DB_HOST] = localhost
   ```
   - ✅ Correto (igual em DEV e PROD)

6. ✅ **LOG_DB_PORT**
   ```
   env[LOG_DB_PORT] = 3306
   ```
   - ✅ Correto (igual em DEV e PROD)

---

## 📋 VARIÁVEIS COM VALORES DIFERENTES (ESPERADO)

### **Variáveis que DEVEM ser diferentes entre DEV e PROD:**

1. ✅ **WEBFLOW_SECRET_FLYINGDONKEYS**
   - **DEV:** `5e93a6f31e520738ce8bf4770f32929bec207696ad9ca54f6f5e67813c33ae40`
   - **PROD:** `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142`
   - ✅ **Status:** Diferentes (esperado - secret keys diferentes para cada ambiente)

2. ✅ **WEBFLOW_SECRET_OCTADESK**
   - **DEV:** `000b928364360d28af0db403c33aa5ec39d8ea9a8358add26a41f9ef951e6246`
   - **PROD:** `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291`
   - ✅ **Status:** Diferentes (esperado - secret keys diferentes para cada ambiente)

**⚠️ IMPORTANTE:** Verificar se as secret keys de PROD estão corretas e atualizadas (API v2 do Webflow).

---

## 📋 RESUMO DE ALTERAÇÕES NECESSÁRIAS

### **Arquivo a Modificar:**
`/etc/php/8.3/fpm/pool.d/www.conf` (no servidor `157.180.36.223`)

### **Alterações Necessárias:**

1. **Atualizar APP_CORS_ORIGINS:**
   ```bash
   # De:
   env[APP_CORS_ORIGINS] = https://segurosimediato-dev.webflow.io,https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io,https://dev.bssegurosimediato.com.br
   
   # Para:
   env[APP_CORS_ORIGINS] = https://www.segurosimediato.com.br,https://segurosimediato.com.br,https://prod.bssegurosimediato.com.br
   ```

2. **Atualizar ESPOCRM_URL:**
   ```bash
   # De:
   env[ESPOCRM_URL] = https://dev.flyingdonkeys.com.br
   
   # Para:
   env[ESPOCRM_URL] = https://flyingdonkeys.com.br
   ```

3. **Atualizar LOG_DB_NAME:**
   ```bash
   # De:
   env[LOG_DB_NAME] = rpa_logs_dev
   
   # Para:
   env[LOG_DB_NAME] = rpa_logs_prod
   ```

4. **Atualizar LOG_DB_USER:**
   ```bash
   # De:
   env[LOG_DB_USER] = rpa_logger_dev
   
   # Para:
   env[LOG_DB_USER] = rpa_logger_prod
   ```

5. **Adicionar LOG_DIR:**
   ```bash
   # Adicionar após env[APP_BASE_URL]:
   env[LOG_DIR] = /var/log/webflow-segurosimediato
   ```

---

## 🔧 PROCESSO DE APLICAÇÃO

### **1. Criar Backup do Arquivo PHP-FPM**
```bash
ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_ANTES_CORRECAO_VARIAVEIS_$(date +%Y%m%d_%H%M%S)"
```

### **2. Criar Arquivo Local com Configuração Corrigida**

Criar arquivo local: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`

**Processo:**
1. Baixar arquivo atual do servidor PROD
2. Fazer backup local
3. Aplicar correções
4. Copiar arquivo corrigido para servidor
5. Verificar hash após cópia

### **3. Aplicar no Servidor**

**Opção A: Editar diretamente no servidor (NÃO RECOMENDADO - viola diretivas)**
- ❌ Não fazer isso - viola diretivas do projeto

**Opção B: Criar arquivo local e copiar (RECOMENDADO)**
1. Criar arquivo localmente em `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/`
2. Aplicar correções localmente
3. Copiar para servidor via SCP
4. Verificar hash após cópia

### **4. Reiniciar PHP-FPM**
```bash
ssh root@157.180.36.223 "systemctl restart php8.3-fpm"
```

### **5. Verificar Variáveis Aplicadas**
```bash
ssh root@157.180.36.223 "php -r \"echo getenv('APP_CORS_ORIGINS') . PHP_EOL;\""
ssh root@157.180.36.223 "php -r \"echo getenv('ESPOCRM_URL') . PHP_EOL;\""
ssh root@157.180.36.223 "php -r \"echo getenv('LOG_DB_NAME') . PHP_EOL;\""
ssh root@157.180.36.223 "php -r \"echo getenv('LOG_DB_USER') . PHP_EOL;\""
ssh root@157.180.36.223 "php -r \"echo getenv('LOG_DIR') . PHP_EOL;\""
```

---

## 📋 CHECKLIST DE APLICAÇÃO

- [ ] Criar backup do arquivo PHP-FPM no servidor
- [ ] Baixar arquivo atual do servidor para local
- [ ] Criar backup local do arquivo
- [ ] Aplicar correções no arquivo local
- [ ] Copiar arquivo corrigido para servidor
- [ ] Verificar hash após cópia (SHA256, case-insensitive)
- [ ] Reiniciar PHP-FPM
- [ ] Verificar todas as variáveis aplicadas
- [ ] Testar funcionamento dos endpoints PHP
- [ ] Verificar logs

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Backup Obrigatório:**
   - Sempre criar backup antes de modificar arquivo PHP-FPM
   - Backup local e remoto

2. **Verificação de Hash:**
   - Sempre verificar hash SHA256 após cópia
   - Comparar hashes case-insensitive

3. **ESPOCRM_URL:**
   - ✅ Valor correto confirmado: `https://flyingdonkeys.com.br`

4. **Secret Keys:**
   - Verificar se as secret keys de PROD estão atualizadas (API v2)
   - Não commitar secret keys no Git

5. **LOG_DIR:**
   - Garantir que o diretório existe no servidor
   - Garantir permissões corretas: `www-data:www-data` e `755`

---

## 📝 PRÓXIMOS PASSOS

1. ✅ Documento criado
2. ✅ Valor de ESPOCRM_URL confirmado: `https://flyingdonkeys.com.br`
3. ⏳ Criar arquivo PHP-FPM corrigido localmente
4. ⏳ Aplicar no servidor
5. ⏳ Verificar funcionamento

---

**Data de Criação:** 14/11/2025  
**Status:** 📝 **CONFIGURAÇÃO DEFINIDA - AGUARDANDO APLICAÇÃO**

