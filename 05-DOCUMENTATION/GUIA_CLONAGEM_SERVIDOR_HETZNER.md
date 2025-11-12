# 🖥️ GUIA: CLONAGEM DE SERVIDOR HETZNER PARA PRODUÇÃO

**Data:** 11/11/2025  
**Objetivo:** Criar servidor de produção idêntico ao servidor DEV existente

---

## 🎯 OPÇÕES DISPONÍVEIS NO HETZNER

O Hetzner oferece várias opções para clonar/replicar configurações de servidor:

### **1. ✅ SNAPSHOT/IMAGE (RECOMENDADO - Mais Rápido)**

**Como funciona:**
- Cria uma imagem completa do servidor atual (sistema operacional + dados + configurações)
- Permite criar novos servidores a partir dessa imagem

**Vantagens:**
- ✅ Mais rápido (criação de servidor em minutos)
- ✅ Configurações idênticas garantidas
- ✅ Inclui todos os pacotes instalados
- ✅ Inclui todas as configurações (Nginx, PHP-FPM, etc.)

**Desvantagens:**
- ⚠️ Pode incluir dados de desenvolvimento (precisa limpar depois)
- ⚠️ Pode incluir credenciais/configurações específicas de DEV

**Passos:**
1. **No Hetzner Cloud Console:**
   - Acesse o servidor DEV existente
   - Clique em "Snapshots" ou "Create Snapshot"
   - Aguarde criação do snapshot (pode levar alguns minutos)

2. **Criar novo servidor a partir do snapshot:**
   - Clique em "Create Server"
   - Selecione "From Snapshot"
   - Escolha o snapshot criado
   - Configure IP, localização, etc.
   - Crie o servidor

3. **Ajustes necessários após clonagem:**
   - Alterar variáveis de ambiente para PROD
   - Alterar configurações de domínio (Nginx)
   - Limpar dados de desenvolvimento
   - Configurar certificados SSL para domínio de produção

---

### **2. ✅ SCRIPT DE CONFIGURAÇÃO AUTOMATIZADA (RECOMENDADO - Mais Limpo)**

**Como funciona:**
- Documenta todas as configurações do servidor atual
- Cria scripts de instalação e configuração
- Aplica no novo servidor limpo

**Vantagens:**
- ✅ Servidor limpo (sem dados de desenvolvimento)
- ✅ Configurações documentadas
- ✅ Reproduzível e versionável
- ✅ Mais seguro (não copia credenciais de DEV)

**Desvantagens:**
- ⚠️ Mais trabalhoso inicialmente
- ⚠️ Requer documentação completa

**Passos:**
1. **Documentar configuração atual:**
   - Listar pacotes instalados
   - Documentar configurações Nginx
   - Documentar configurações PHP-FPM
   - Documentar variáveis de ambiente
   - Documentar estrutura de diretórios

2. **Criar scripts de instalação:**
   - Script de instalação de pacotes
   - Script de configuração Nginx
   - Script de configuração PHP-FPM
   - Script de criação de diretórios

3. **Aplicar no novo servidor:**
   - Criar servidor limpo no Hetzner
   - Executar scripts de instalação
   - Copiar arquivos de aplicação
   - Configurar variáveis de ambiente

---

### **3. ⚠️ BACKUP E RESTORE MANUAL (Não Recomendado)**

**Como funciona:**
- Faz backup manual de arquivos e configurações
- Restaura no novo servidor manualmente

**Desvantagens:**
- ❌ Muito trabalhoso
- ❌ Propenso a erros
- ❌ Não garante configurações idênticas

---

## 🎯 RECOMENDAÇÃO: ABORDAGEM HÍBRIDA

**Combinar Snapshot + Scripts de Ajuste:**

1. **Criar snapshot do servidor DEV** (rápido)
2. **Criar servidor PROD a partir do snapshot**
3. **Executar script de ajuste** para:
   - Alterar variáveis de ambiente para PROD
   - Limpar dados de desenvolvimento
   - Ajustar configurações de domínio
   - Configurar SSL para domínio de produção

---

## 📋 CHECKLIST DE CLONAGEM

### **Fase 1: Preparação (Servidor DEV)**

- [ ] Criar snapshot do servidor DEV no Hetzner
- [ ] Documentar IP do servidor DEV atual
- [ ] Documentar domínio DEV: `dev.bssegurosimediato.com.br`
- [ ] Documentar domínio PROD: `bssegurosimediato.com.br`
- [ ] Listar todas as variáveis de ambiente configuradas
- [ ] Documentar estrutura de diretórios

### **Fase 2: Criação do Servidor PROD**

- [ ] Criar novo servidor no Hetzner Cloud
- [ ] Escolher localização (mesma do DEV ou diferente)
- [ ] Escolher tamanho do servidor (mesmo ou maior)
- [ ] Criar servidor a partir do snapshot OU criar servidor limpo

### **Fase 3: Configuração do Servidor PROD**

#### **3.1. Se criado a partir de Snapshot:**
- [ ] Alterar hostname do servidor
- [ ] Limpar dados de desenvolvimento
- [ ] Alterar variáveis de ambiente para PROD
- [ ] Ajustar configurações Nginx para domínio PROD
- [ ] Configurar certificados SSL para domínio PROD

#### **3.2. Se criado servidor limpo:**
- [ ] Executar script de instalação de pacotes
- [ ] Executar script de configuração Nginx
- [ ] Executar script de configuração PHP-FPM
- [ ] Criar estrutura de diretórios
- [ ] Configurar variáveis de ambiente PROD
- [ ] Configurar certificados SSL

### **Fase 4: Cópia de Arquivos**

- [ ] Copiar arquivos PHP do projeto para `/var/www/html/prod/root/`
- [ ] Copiar arquivos JavaScript do projeto
- [ ] Copiar templates de email
- [ ] Configurar permissões de arquivos

### **Fase 5: Configuração DNS**

- [ ] Configurar registro A para `prod.bssegurosimediato.com.br` apontando para IP do servidor PROD (`157.180.36.223`)
- [ ] Aguardar propagação DNS (pode levar até 48h, geralmente < 1h)

### **Fase 6: SSL e Segurança**

- [ ] Executar Certbot para obter certificado SSL
- [ ] Verificar renovação automática de certificados
- [ ] Configurar firewall (UFW)
- [ ] Verificar portas abertas (22, 80, 443)

### **Fase 7: Testes**

- [ ] Testar acesso via HTTPS
- [ ] Testar endpoints PHP
- [ ] Testar carregamento de arquivos JavaScript
- [ ] Testar envio de emails
- [ ] Verificar logs de erro

---

## 📝 CONFIGURAÇÕES QUE PRECISAM SER ALTERADAS

### **1. Variáveis de Ambiente PHP-FPM**

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf` (ou criar `prod.conf`)

**Alterar:**
```ini
# DEV → PROD
env[APP_BASE_DIR] = /var/www/html/prod/root
env[APP_BASE_URL] = https://prod.bssegurosimediato.com.br
env[APP_ENVIRONMENT] = production
```

**Todas as outras variáveis devem permanecer iguais:**
- `VIACEP_BASE_URL`
- `APILAYER_BASE_URL`
- `SAFETYMAILS_BASE_DOMAIN`
- `WHATSAPP_API_BASE`
- `RPA_API_BASE_URL`
- `LOG_DB_HOST`, `LOG_DB_PORT`, `LOG_DB_NAME`, `LOG_DB_USER`, `LOG_DB_PASS`
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`

---

### **2. Configuração Nginx**

**Arquivo:** `/etc/nginx/sites-available/prod.bssegurosimediato.com.br`

**Criar novo arquivo baseado em `nginx_dev_config.conf`, mas alterando:**
- `server_name`: `dev.bssegurosimediato.com.br` → `prod.bssegurosimediato.com.br`
- `root`: `/var/www/html/dev/root` → `/var/www/html/prod/root`
- Certificados SSL: Apontar para domínio de produção

---

### **3. Estrutura de Diretórios**

**Criar:**
```bash
mkdir -p /var/www/html/prod/root
mkdir -p /var/www/html/prod/root/email_templates
chown -R www-data:www-data /var/www/html/prod
chmod -R 755 /var/www/html/prod
```

---

### **4. Certificados SSL**

**Obter certificado para produção:**
```bash
certbot --nginx -d prod.bssegurosimediato.com.br
```

---

## 🔧 SCRIPTS NECESSÁRIOS

### **Script 1: Ajustar Variáveis de Ambiente para PROD**

```bash
#!/bin/bash
# Ajustar variáveis de ambiente PHP-FPM para PROD

POOL_FILE="/etc/php/8.3/fpm/pool.d/www.conf"

# Backup
cp "$POOL_FILE" "${POOL_FILE}.backup_$(date +%Y%m%d_%H%M%S)"

# Alterar variáveis
sed -i 's|env[APP_BASE_DIR] = /var/www/html/dev/root|env[APP_BASE_DIR] = /var/www/html/prod/root|g' "$POOL_FILE"
sed -i 's|env[APP_BASE_URL] = https://dev.bssegurosimediato.com.br|env[APP_BASE_URL] = https://prod.bssegurosimediato.com.br|g' "$POOL_FILE"
sed -i 's|env[APP_ENVIRONMENT] = development|env[APP_ENVIRONMENT] = production|g' "$POOL_FILE"

# Reiniciar PHP-FPM
systemctl restart php8.3-fpm

echo "✅ Variáveis de ambiente ajustadas para PROD"
```

---

### **Script 2: Criar Configuração Nginx PROD**

```bash
#!/bin/bash
# Criar configuração Nginx para PROD baseada em DEV

DEV_CONFIG="/etc/nginx/sites-available/dev.bssegurosimediato.com.br"
PROD_CONFIG="/etc/nginx/sites-available/prod.bssegurosimediato.com.br"

# Copiar configuração DEV
cp "$DEV_CONFIG" "$PROD_CONFIG"

# Alterar para PROD
sed -i 's|dev.bssegurosimediato.com.br|prod.bssegurosimediato.com.br|g' "$PROD_CONFIG"
sed -i 's|/var/www/html/dev/root|/var/www/html/prod/root|g' "$PROD_CONFIG"

# Ativar site
ln -sf "$PROD_CONFIG" /etc/nginx/sites-enabled/prod.bssegurosimediato.com.br

# Testar configuração
nginx -t && systemctl reload nginx

echo "✅ Configuração Nginx PROD criada"
```

---

### **Script 3: Criar Estrutura de Diretórios PROD**

```bash
#!/bin/bash
# Criar estrutura de diretórios para PROD

mkdir -p /var/www/html/prod/root
mkdir -p /var/www/html/prod/root/email_templates
mkdir -p /var/www/html/prod/logs

chown -R www-data:www-data /var/www/html/prod
chmod -R 755 /var/www/html/prod

echo "✅ Estrutura de diretórios PROD criada"
```

---

## 📊 COMPARAÇÃO: SNAPSHOT vs SCRIPT

| Aspecto | Snapshot | Script |
|---------|----------|--------|
| **Velocidade** | ⚡ Muito rápido (minutos) | 🐢 Mais lento (horas) |
| **Garantia de Idêntico** | ✅ 100% idêntico | ⚠️ Depende da documentação |
| **Limpeza** | ❌ Inclui dados DEV | ✅ Servidor limpo |
| **Segurança** | ⚠️ Pode incluir credenciais DEV | ✅ Sem dados sensíveis |
| **Reproduzibilidade** | ⚠️ Depende do snapshot | ✅ Totalmente reproduzível |
| **Manutenção** | ⚠️ Difícil atualizar | ✅ Fácil atualizar |

---

## 🎯 RECOMENDAÇÃO FINAL

**Para este projeto, recomendo:**

1. **Criar snapshot do servidor DEV** (backup de segurança)
2. **Criar servidor PROD limpo** (mais seguro)
3. **Usar scripts de instalação** para configurar
4. **Copiar apenas arquivos de aplicação** (não dados de desenvolvimento)

**Motivos:**
- ✅ Servidor limpo sem dados de desenvolvimento
- ✅ Configurações documentadas e reproduzíveis
- ✅ Mais seguro (não copia credenciais/configurações de DEV)
- ✅ Facilita manutenção futura

---

## 📁 ARQUIVOS DE REFERÊNCIA

### **Configurações Existentes no Projeto:**

- `06-SERVER-CONFIG/nginx_dev_config.conf` - Configuração Nginx DEV
- `05-DOCUMENTATION/ESPECIFICACAO_VARIAVEIS_AMBIENTE.md` - Variáveis de ambiente
- `05-DOCUMENTATION/SCRIPT_INSTALACAO_SERVIDOR.sh` - Script de instalação básica

### **Scripts a Criar:**

- `06-SERVER-CONFIG/ajustar_variaveis_prod.sh` - Ajustar variáveis para PROD
- `06-SERVER-CONFIG/criar_nginx_prod.sh` - Criar configuração Nginx PROD
- `06-SERVER-CONFIG/criar_diretorios_prod.sh` - Criar estrutura de diretórios PROD
- `06-SERVER-CONFIG/nginx_prod_config.conf` - Configuração Nginx PROD (baseada em DEV)

---

## ✅ PRÓXIMOS PASSOS

1. **Decidir abordagem:** Snapshot ou Script?
2. **Se Snapshot:** Criar snapshot no Hetzner e ajustar configurações
3. **Se Script:** Criar scripts de instalação e configuração
4. **Criar servidor PROD** no Hetzner
5. **Aplicar configurações** no servidor PROD
6. **Copiar arquivos** de aplicação
7. **Configurar DNS** e SSL
8. **Testar** ambiente de produção

---

**Última atualização:** 11/11/2025

