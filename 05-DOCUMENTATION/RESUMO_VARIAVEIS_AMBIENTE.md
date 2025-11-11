# 📋 RESUMO: VARIÁVEIS DE AMBIENTE CONFIGURADAS

**Data:** 10/11/2025  
**Servidor:** 65.108.156.14  
**Status:** ✅ Configurado e Persistente

---

## 📁 ARQUIVOS CONFIGURADOS

### **1. Variáveis Globais do Sistema**
**Arquivo:** `/etc/environment.d/webhooks.conf`
- Carregado automaticamente em todos os shells
- Disponível para todos os serviços do sistema
- Persiste após reinicialização

### **2. PHP-FPM Pool DEV**
**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`
- Variáveis específicas para ambiente DEV
- Carregadas automaticamente em todas as requisições PHP via PHP-FPM
- Persiste após reinicialização

### **3. PHP-FPM Pool PROD**
**Arquivo:** `/etc/php/8.3/fpm/pool.d/prod.conf`
- Variáveis específicas para ambiente PROD
- Carregadas automaticamente em todas as requisições PHP via PHP-FPM
- Persiste após reinicialização

### **4. Script de Carregamento para Shells**
**Arquivo:** `/etc/profile.d/webhooks-env.sh`
- Executado automaticamente em todos os shells (bash, sh, etc.)
- Carrega variáveis do `/etc/environment.d/webhooks.conf`
- Persiste após reinicialização

---

## 🔄 COMO FUNCIONA A PERSISTÊNCIA

### **Para PHP (via PHP-FPM):**
1. PHP-FPM lê as variáveis dos arquivos de pool (`www.conf` e `prod.conf`)
2. As variáveis são injetadas em `$_ENV` e `getenv()` automaticamente
3. Funciona mesmo após reinicialização do servidor

### **Para Shells:**
1. `/etc/profile.d/webhooks-env.sh` é executado automaticamente
2. Carrega variáveis de `/etc/environment.d/webhooks.conf`
3. Disponível em todos os shells após login

### **Para Serviços Systemd:**
1. Variáveis podem ser lidas de `/etc/environment.d/webhooks.conf`
2. PHP-FPM já carrega automaticamente dos pools

---

## ✅ VARIÁVEIS CONFIGURADAS

### **Ambiente:**
- `PHP_ENV` - development (DEV) ou production (PROD)

### **Diretórios e URLs:**
- `APP_BASE_DIR` - Diretório base físico
- `APP_BASE_URL` - URL base do ambiente
- `APP_CORS_ORIGINS` - Origens permitidas para CORS

### **Banco de Dados:**
- `LOG_DB_HOST` - Host do MySQL
- `LOG_DB_PORT` - Porta do MySQL
- `LOG_DB_NAME` - Nome do banco
- `LOG_DB_USER` - Usuário do banco
- `LOG_DB_PASS` - Senha do banco

### **EspoCRM:**
- `ESPOCRM_URL` - URL da API EspoCRM
- `ESPOCRM_API_KEY` - Chave de API

### **Webflow:**
- `WEBFLOW_SECRET_FLYINGDONKEYS` - Secret para FlyingDonkeys
- `WEBFLOW_SECRET_OCTADESK` - Secret para OctaDesk

### **OctaDesk:**
- `OCTADESK_API_KEY` - Chave de API
- `OCTADESK_API_BASE` - URL base da API

### **AWS SES:**
- `AWS_ACCESS_KEY_ID` - Chave de acesso AWS
- `AWS_SECRET_ACCESS_KEY` - Chave secreta AWS
- `AWS_REGION` - Região AWS
- `AWS_SES_FROM_EMAIL` - Email remetente
- `AWS_SES_ADMIN_EMAILS` - Emails de administração

---

## 🧪 TESTAR VARIÁVEIS

### **Via PHP CLI:**
```bash
php -r "echo \$_ENV['PHP_ENV'] . PHP_EOL;"
php -r "echo \$_ENV['APP_BASE_URL'] . PHP_EOL;"
```

### **Via HTTP (após copiar arquivos):**
```bash
curl http://dev.bssegurosimediato.com.br/test_env.php
```

### **Via Shell:**
```bash
echo $PHP_ENV
echo $APP_BASE_URL_DEV
```

---

## ⚠️ IMPORTANTE: SUBSTITUIR VALORES

### **Valores que precisam ser substituídos:**

1. **MySQL PROD:**
   - `[SENHA_PROD]` em `/etc/php/8.3/fpm/pool.d/prod.conf`
   - Substituir pela senha real do MySQL PROD

2. **AWS SES PROD:**
   - `[AWS_KEY_PROD]` em `/etc/php/8.3/fpm/pool.d/prod.conf`
   - `[AWS_SECRET_PROD]` em `/etc/php/8.3/fpm/pool.d/prod.conf`
   - Substituir pelas credenciais AWS reais

3. **AWS SES DEV:**
   - Os valores atuais são placeholders
   - Substituir pelas credenciais AWS reais de DEV

---

## 🔧 MANUTENÇÃO

### **Adicionar nova variável:**

1. **Para PHP-FPM DEV:**
   ```bash
   echo "env[NOVA_VARIAVEL] = valor" >> /etc/php/8.3/fpm/pool.d/www.conf
   systemctl restart php8.3-fpm
   ```

2. **Para PHP-FPM PROD:**
   ```bash
   echo "env[NOVA_VARIAVEL] = valor" >> /etc/php/8.3/fpm/pool.d/prod.conf
   systemctl restart php8.3-fpm
   ```

3. **Para sistema global:**
   ```bash
   echo "NOVA_VARIAVEL=valor" >> /etc/environment.d/webhooks.conf
   ```

### **Verificar variáveis carregadas:**
```bash
# Via PHP
php -r "print_r(\$_ENV);"

# Via PHP-FPM (criar arquivo test_env.php)
```

---

## 📝 NOTAS

- ✅ Todas as variáveis são **persistentes** e **carregadas automaticamente**
- ✅ Funcionam após **reinicialização do servidor**
- ✅ **Independentes de configuração manual** - carregadas automaticamente
- ✅ **Isoladas por ambiente** - DEV e PROD têm configurações separadas
- ⚠️ **Substituir placeholders** antes de usar em produção

---

**Documento criado em:** 10/11/2025  
**Versão:** 1.0

