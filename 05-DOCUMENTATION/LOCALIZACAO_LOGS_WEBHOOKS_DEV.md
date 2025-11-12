# 📍 Localização dos Logs dos Webhooks - Ambiente DEV

## 🎯 Objetivo

Este documento identifica onde os logs dos webhooks `add_flyingdonkeys.php` e `add_webflow_octa.php` são escritos no servidor DEV para facilitar a verificação durante testes.

---

## 📂 Localização dos Arquivos de Log

### **1. add_flyingdonkeys.php**

**Arquivo de Log:** `flyingdonkeys_dev.txt`

**Caminho Completo no Servidor DEV:**
```
/var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
```

**Lógica de Determinação:**
- O código usa: `$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';`
- `$_ENV['LOG_DIR']` está definido no PHP-FPM como `/var/log/webflow-segurosimediato`
- Arquivo final: `rtrim($logDir, '/\\') . '/flyingdonkeys_dev.txt'`

**Formato do Log:**
- Prefixo: `[DEV-FLYINGDONKEYS]`
- Formato JSON com timestamp, environment, webhook, event, success, data, request_id, memory_usage, execution_time

---

### **2. add_webflow_octa.php**

**Arquivo de Log:** `webhook_octadesk_prod.txt`

**Caminho Completo no Servidor DEV:**
```
/var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
```

**Lógica de Determinação:**
- O código usa: `$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';`
- `$_ENV['LOG_DIR']` está definido no PHP-FPM como `/var/log/webflow-segurosimediato`
- Arquivo final: `rtrim($logDir, '/\\') . '/webhook_octadesk_prod.txt'`

**Formato do Log:**
- Prefixo: `[OCTADESK-PROD]`
- Formato: `[timestamp] [STATUS] [OCTADESK-PROD] action | Data: {...}`

---

## 🔍 Como Verificar os Logs

### **Opção 1: Via SSH (Recomendado)**

```bash
# Conectar ao servidor DEV
ssh root@65.108.156.14

# Ver últimas 50 linhas do log do FlyingDonkeys
tail -n 50 /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt

# Ver últimas 50 linhas do log do OctaDesk
tail -n 50 /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Monitorar em tempo real (seguir novas linhas)
tail -f /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
tail -f /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Ver todo o arquivo (se pequeno)
cat /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
cat /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Buscar por texto específico
grep "webhook_started" /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
grep "webhook_received" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
```

### **Opção 2: Verificar Tamanho e Última Modificação**

```bash
# Verificar se os arquivos existem e seus tamanhos
ls -lh /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
ls -lh /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Verificar última modificação
stat /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
stat /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
```

### **Opção 3: Verificar Variáveis de Ambiente**

```bash
# Verificar se LOG_DIR está definido no PHP-FPM
grep "LOG_DIR" /etc/php/8.3/fpm/pool.d/www.conf

# Verificar APP_BASE_DIR (usado como fallback)
grep "APP_BASE_DIR" /etc/php/8.3/fpm/pool.d/www.conf
```

---

## 📋 Resumo Rápido

| Webhook | Arquivo de Log | Caminho Completo (DEV) |
|---------|----------------|------------------------|
| `add_flyingdonkeys.php` | `flyingdonkeys_dev.txt` | `/var/log/webflow-segurosimediato/flyingdonkeys_dev.txt` |
| `add_webflow_octa.php` | `webhook_octadesk_prod.txt` | `/var/log/webflow-segurosimediato/webhook_octadesk_prod.txt` |

---

## ⚠️ Observações Importantes

1. **Diretório de Logs:**
   - `$_ENV['LOG_DIR']` está definido no PHP-FPM como `/var/log/webflow-segurosimediato`
   - Todos os logs são escritos neste diretório centralizado

2. **Permissões:**
   - Os arquivos de log são criados automaticamente pelo PHP
   - O usuário do PHP-FPM (`www-data`) tem permissão de escrita no diretório `/var/log/webflow-segurosimediato/`

3. **Rotação de Logs:**
   - Atualmente não há rotação automática configurada
   - Os logs crescem indefinidamente até serem limpos manualmente

4. **Monitoramento em Tempo Real:**
   - Use `tail -f` para monitorar os logs em tempo real durante os testes
   - Isso permite ver imediatamente quando uma requisição é processada

---

## 🔧 Comandos Úteis para Testes

```bash
# Limpar logs antes do teste (opcional)
> /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
> /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Monitorar ambos os logs simultaneamente (em terminais separados)
# Terminal 1:
tail -f /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt

# Terminal 2:
tail -f /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Ver apenas erros
grep "ERROR\|false" /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
grep "ERROR" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt

# Contar requisições bem-sucedidas
grep -c '"success":true' /var/log/webflow-segurosimediato/flyingdonkeys_dev.txt
grep -c "SUCCESS" /var/log/webflow-segurosimediato/webhook_octadesk_prod.txt
```

---

**Data de Criação:** 2025-11-12  
**Última Atualização:** 2025-11-12  
**Ambiente:** DEV (`dev.bssegurosimediato.com.br`)

