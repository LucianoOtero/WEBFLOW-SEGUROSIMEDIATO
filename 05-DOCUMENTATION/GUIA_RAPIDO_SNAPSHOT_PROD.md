# ⚡ GUIA RÁPIDO: CRIAR SERVIDOR PROD A PARTIR DE SNAPSHOT

**Data:** 11/11/2025  
**Método:** Snapshot + Ajuste de Variáveis

---

## 🎯 PASSO A PASSO

### **FASE 1: CRIAR SNAPSHOT DO SERVIDOR DEV**

📖 **Para passo-a-passo detalhado com imagens, consulte:** `PASSO_A_PASSO_SNAPSHOT_HETZNER.md`

**Resumo rápido:**

1. **Acesse Hetzner Cloud Console:**
   - https://console.hetzner.cloud/
   - Navegue até o servidor DEV (IP: 65.108.156.14)

2. **Criar Snapshot:**
   - Clique no servidor DEV
   - Aba "Snapshots" (no topo da página)
   - Clique em "Create Snapshot" ou "Take Snapshot"
   - Nome: `servidor-dev-backup-2025-11-11`
   - Descrição (opcional): "Snapshot do servidor DEV para criar servidor PROD"
   - Clique em "Create Snapshot"
   - Aguarde criação (pode levar 5-15 minutos)
   - Status mudará de "Creating" para "Available" quando concluído

---

### **FASE 2: CRIAR SERVIDOR PROD A PARTIR DO SNAPSHOT**

📖 **Para passo-a-passo detalhado com imagens, consulte:** `PASSO_A_PASSO_CRIAR_SERVIDOR_SNAPSHOT.md`

**Resumo rápido:**

1. **Criar Novo Servidor:**
   - Clique em "Create Server" ou "Add Server"
   - **Image:** Clique na aba "Snapshots" ou "My Snapshots"
   - Selecione o snapshot criado (`servidor-dev-backup-2025-11-11`)
   - **Type:** Escolha o mesmo tipo do servidor DEV (ou maior)
   - **Location:** Escolha localização (mesma ou diferente)
   - **SSH Keys:** Selecione suas chaves SSH (mesmas do DEV)
   - **Name:** Digite nome do servidor (ex: `servidor-prod`)
   - **Networks:** Deixe vazio (não necessário)
   - **Firewalls:** Deixe vazio (configurar depois)
   - Clique em "Create Server"
   - Aguarde status mudar para "Running" (2-5 minutos)

2. **Anotar Informações:**
   - IP do novo servidor PROD: `157.180.36.223` ✅
   - Hostname: `_________________`
   - Nome: `_________________`

---

### **FASE 3: AJUSTAR CONFIGURAÇÕES PARA PROD**

1. **Conectar ao servidor PROD:**
   ```bash
   ssh root@[IP_DO_SERVIDOR_PROD]
   ```

2. **Copiar script de ajuste:**
   ```bash
   # No seu computador local (Windows)
   scp "WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/ajustar_dev_para_prod.sh" root@[IP_PROD]:/root/
   ```

3. **Executar script de ajuste:**
   ```bash
   # No servidor PROD
   chmod +x /root/ajustar_dev_para_prod.sh
   /root/ajustar_dev_para_prod.sh
   ```

4. **Verificar resultado:**
   O script irá:
   - ✅ Ajustar variáveis de ambiente (APP_BASE_DIR, APP_BASE_URL, APP_ENVIRONMENT)
   - ✅ Criar configuração Nginx para PROD
   - ✅ Criar estrutura de diretórios PROD
   - ✅ Reiniciar serviços (Nginx e PHP-FPM)

---

### **FASE 4: COPIAR ARQUIVOS DE APLICAÇÃO**

1. **Copiar arquivos do projeto:**
   ```bash
   # No seu computador local (Windows)
   cd "WEBFLOW-SEGUROSIMEDIATO"
   
   # Copiar arquivos PHP e JavaScript
   scp -r "02-DEVELOPMENT/*.php" root@[IP_PROD]:/var/www/html/prod/root/
   scp -r "02-DEVELOPMENT/*.js" root@[IP_PROD]:/var/www/html/prod/root/
   
   # Copiar templates de email
   scp -r "02-DEVELOPMENT/email_templates/*" root@[IP_PROD]:/var/www/html/prod/root/email_templates/
   ```

   **OU usar o script PowerShell existente:**
   ```powershell
   # Modificar o script copiar_arquivos_servidor.ps1 para apontar para PROD
   # Alterar: $servidor = "root@[IP_PROD]"
   # Alterar: $devRemoto = "/var/www/html/prod/root"
   ```

2. **Configurar permissões:**
   ```bash
   # No servidor PROD
   chown -R www-data:www-data /var/www/html/prod
   chmod -R 755 /var/www/html/prod
   ```

---

### **FASE 5: CONFIGURAR DNS**

1. **Registros DNS necessários:**
   - **Tipo A:** `prod` → `157.180.36.223`
   - **Domínio completo:** `prod.bssegurosimediato.com.br`
   
   📖 **Para guia detalhado do Cloudflare, consulte:** `GUIA_CONFIGURACAO_CLOUDFLARE_PROD.md`

2. **Aguardar propagação DNS:**
   - Geralmente: 15 minutos a 1 hora
   - Máximo: até 48 horas (raro)

3. **Verificar propagação:**
   ```bash
   # No seu computador
   nslookup prod.bssegurosimediato.com.br
   # Deve retornar: 157.180.36.223
   ```

---

### **FASE 6: CONFIGURAR SSL (CERTIFICADO HTTPS)**

1. **Obter certificado Let's Encrypt:**
   ```bash
   # No servidor PROD
   certbot --nginx -d prod.bssegurosimediato.com.br
   ```

2. **Seguir instruções do Certbot:**
   - Escolher redirecionar HTTP → HTTPS (opção 2)
   - Aguardar obtenção do certificado

3. **Verificar renovação automática:**
   ```bash
   # Verificar se o timer está ativo
   systemctl status certbot.timer
   
   # Testar renovação manualmente (não renova, apenas testa)
   certbot renew --dry-run
   ```

---

### **FASE 7: TESTES FINAIS**

1. **Testar acesso HTTPS:**
   ```bash
   curl -I https://prod.bssegurosimediato.com.br
   # Deve retornar HTTP 200 ou 301/302
   ```

2. **Testar endpoints PHP:**
   ```bash
   curl https://prod.bssegurosimediato.com.br/config_env.js.php
   # Deve retornar JavaScript com variáveis
   ```

3. **Verificar variáveis de ambiente:**
   ```bash
   # No servidor PROD
   php -r "require '/var/www/html/prod/root/config_env.js.php'; echo 'APP_BASE_URL: ' . APP_BASE_URL . PHP_EOL;"
   # Deve mostrar: APP_BASE_URL: https://prod.bssegurosimediato.com.br
   ```

4. **Testar no navegador:**
   - Acessar: https://prod.bssegurosimediato.com.br
   - Verificar se carrega corretamente
   - Verificar console do navegador (F12) para erros

---

## 📋 CHECKLIST RÁPIDO

### **Preparação**
- [ ] Criar snapshot do servidor DEV no Hetzner
- [ ] Anotar IP do servidor DEV: `65.108.156.14`

### **Criação do Servidor**
- [ ] Criar servidor PROD a partir do snapshot
- [ ] Anotar IP do servidor PROD: `_________________`
- [ ] Conectar via SSH ao servidor PROD

### **Ajuste de Configurações**
- [ ] Copiar script `ajustar_dev_para_prod.sh` para servidor PROD
- [ ] Executar script de ajuste
- [ ] Verificar que variáveis foram alteradas corretamente
- [ ] Verificar que configuração Nginx PROD foi criada

### **Cópia de Arquivos**
- [ ] Copiar arquivos PHP para `/var/www/html/prod/root/`
- [ ] Copiar arquivos JavaScript para `/var/www/html/prod/root/`
- [ ] Copiar templates de email para `/var/www/html/prod/root/email_templates/`
- [ ] Configurar permissões dos arquivos

### **DNS e SSL**
- [ ] Configurar registros DNS (A) para domínio PROD
- [ ] Aguardar propagação DNS
- [ ] Obter certificado SSL com Certbot
- [ ] Verificar renovação automática de certificados

### **Testes**
- [ ] Testar acesso HTTPS
- [ ] Testar endpoints PHP
- [ ] Verificar variáveis de ambiente
- [ ] Testar no navegador
- [ ] Verificar logs de erro

---

## 🔍 VARIÁVEIS QUE SERÃO ALTERADAS

O script `ajustar_dev_para_prod.sh` altera automaticamente:

| Variável | DEV | PROD |
|----------|-----|------|
| `APP_BASE_DIR` | `/var/www/html/dev/root` | `/var/www/html/prod/root` |
| `APP_BASE_URL` | `https://dev.bssegurosimediato.com.br` | `https://prod.bssegurosimediato.com.br` |
| `APP_ENVIRONMENT` | `development` | `production` |

**Todas as outras variáveis permanecem iguais:**
- `VIACEP_BASE_URL`
- `APILAYER_BASE_URL`
- `SAFETYMAILS_BASE_DOMAIN`
- `WHATSAPP_API_BASE`
- `RPA_API_BASE_URL`
- `LOG_DB_HOST`, `LOG_DB_PORT`, `LOG_DB_NAME`, `LOG_DB_USER`, `LOG_DB_PASS`
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`

---

## ⚠️ IMPORTANTE

1. **Backup:** O script cria backups automáticos antes de modificar arquivos
2. **DNS:** Configure DNS ANTES de obter certificado SSL
3. **Permissões:** Certifique-se de que os arquivos têm permissões corretas
4. **Firewall:** Verifique se as portas 80 e 443 estão abertas no firewall

---

## 🆘 TROUBLESHOOTING

### **Erro: "nginx -t failed"**
```bash
# Verificar configuração Nginx manualmente
nginx -t
# Corrigir erros apontados
```

### **Erro: "PHP-FPM não reinicia"**
```bash
# Verificar logs
systemctl status php8.3-fpm
journalctl -u php8.3-fpm -n 50
```

### **Erro: "Certbot não consegue obter certificado"**
- Verificar se DNS está propagado: `nslookup prod.bssegurosimediato.com.br`
- Verificar se porta 80 está acessível: `curl -I http://prod.bssegurosimediato.com.br`

---

**Última atualização:** 11/11/2025

