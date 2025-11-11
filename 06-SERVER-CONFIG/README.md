# 📁 Diretório de Configurações de Servidor

Este diretório contém arquivos de configuração de servidor que devem ser criados localmente e copiados para o servidor via SCP.

## 🚨 REGRAS IMPORTANTES

- ❌ **NUNCA criar** arquivos de configuração diretamente no servidor
- ✅ **SEMPRE criar** localmente neste diretório primeiro
- ✅ **SEMPRE copiar** para o servidor via SCP após criação local

## 📋 TIPOS DE ARQUIVOS

### Nginx
- `nginx_dev_config.conf` - Configuração do Nginx para ambiente DEV
- `nginx_prod_config.conf` - Configuração do Nginx para ambiente PROD

### PHP-FPM
- `php-fpm_dev_pool.conf` - Pool PHP-FPM para ambiente DEV
- `php-fpm_prod_pool.conf` - Pool PHP-FPM para ambiente PROD

### Systemd
- `*.service` - Arquivos de serviço systemd

### Scripts de Configuração
- `*.sh` - Scripts bash para configuração do servidor

## 🔄 FLUXO DE TRABALHO

1. Criar arquivo de configuração neste diretório
2. Verificar sintaxe (quando possível)
3. Copiar para servidor: `scp arquivo.conf root@servidor:/caminho/destino/`
4. Aplicar configuração no servidor
5. Verificar funcionamento

## 📝 EXEMPLO

```bash
# Criar arquivo localmente
# (arquivo criado em: WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_config.conf)

# Copiar para servidor
scp "WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_config.conf" root@65.108.156.14:/etc/nginx/sites-available/dev.bssegurosimediato.com.br

# Aplicar no servidor
ssh root@65.108.156.14 "nginx -t && systemctl reload nginx"
```

