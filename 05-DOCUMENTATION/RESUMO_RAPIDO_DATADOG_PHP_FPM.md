# ⚡ RESUMO RÁPIDO: Integração Datadog + PHP-FPM

**Para referência rápida durante implementação**

---

## 🚀 COMANDOS RÁPIDOS (Copiar/Colar)

### **1. Identificar Socket Unix:**
```bash
grep "listen" /etc/php/8.3/fpm/pool.d/www.conf | grep -v "^;"
```

### **2. Adicionar dd-agent ao Grupo:**
```bash
usermod -a -G www-data dd-agent
id dd-agent  # Verificar
```

### **3. Verificar Acesso ao Socket:**
```bash
sudo -u dd-agent test -r /run/php/php8.3-fpm.sock && echo "✅ OK" || echo "❌ FALHOU"
```

### **4. Criar Configuração:**
```bash
cat > /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml << 'EOF'
init_config:

instances:
  - status_url: unix:///run/php/php8.3-fpm.sock/status
    ping_url: unix:///run/php/php8.3-fpm.sock/ping
    use_fastcgi: true
    ping_reply: pong
EOF
```

**⚠️ AJUSTAR:** Substituir `/run/php/php8.3-fpm.sock` pelo caminho real do socket

### **5. Validar e Reiniciar:**
```bash
datadog-agent configcheck | grep php_fpm
systemctl restart datadog-agent
sleep 5
datadog-agent status | grep -A 15 php_fpm
```

---

## ✅ VALIDAÇÃO RÁPIDA

```bash
# Checklist rápido
datadog-agent status | grep -A 15 php_fpm | grep -E "\[OK\]|Last Successful"
systemctl status php8.3-fpm | grep "active (running)"
id dd-agent | grep www-data
```

---

## 🔄 REVERSÃO RÁPIDA

```bash
rm /etc/datadog-agent/conf.d/php_fpm.d/conf.yaml
gpasswd -d dd-agent www-data
systemctl restart datadog-agent
```

---

**📘 Para detalhes completos, ver:** `GUIA_IMPLEMENTACAO_DATADOG_PHP_FPM.md`

