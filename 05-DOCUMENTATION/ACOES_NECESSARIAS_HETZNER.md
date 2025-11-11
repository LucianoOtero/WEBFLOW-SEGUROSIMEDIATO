# 🔧 AÇÕES NECESSÁRIAS NO SERVIDOR HETZNER

**Data:** 09/11/2025  
**Problema:** Container PHP não consegue conectar ao MySQL no host

---

## ✅ JÁ FEITO

1. ✅ MySQL configurado para escutar em `0.0.0.0:3306`
2. ✅ Banco de dados `rpa_logs_dev` criado
3. ✅ Tabelas criadas com sucesso
4. ✅ Arquivos PHP deployados

---

## ⚠️ PROBLEMA IDENTIFICADO

O container Docker `webhooks-php-dev` não consegue conectar ao MySQL que está rodando no host.

**Possíveis causas:**
1. Firewall bloqueando conexões do Docker network
2. Usuário MySQL sem permissão para conectar de IPs externos
3. Docker network não consegue alcançar o host

---

## 🔧 AÇÕES NECESSÁRIAS

### **1. Verificar e Corrigir Permissões do Usuário MySQL**

Execute no servidor:

```bash
mysql -u root -p << EOF
GRANT ALL PRIVILEGES ON rpa_logs_dev.* TO 'rpa_logger_dev'@'%' IDENTIFIED BY 'tYbAwe7QkKNrHSRhaWplgsSxt';
FLUSH PRIVILEGES;
SELECT user, host FROM mysql.user WHERE user='rpa_logger_dev';
EOF
```

**O que faz:** Permite que o usuário `rpa_logger_dev` conecte de qualquer IP (`%`)

---

### **2. Verificar Firewall (iptables/ufw)**

Execute no servidor:

```bash
# Verificar se há regras bloqueando
iptables -L -n | grep 3306

# Se necessário, permitir conexões do Docker network
# Descobrir o IP do gateway Docker
docker exec webhooks-php-dev ip route | grep default

# Permitir conexões do Docker network (exemplo para 172.18.0.0/16)
iptables -I INPUT -p tcp -s 172.18.0.0/16 --dport 3306 -j ACCEPT
```

**O que faz:** Garante que o firewall não está bloqueando conexões do Docker network

---

### **3. Corrigir docker-compose.yml (se corrompido)**

Se o `docker-compose.yml` estiver com erro de sintaxe, execute:

```bash
cd /opt/webhooks-server
docker compose config 2>&1 | head -20
```

Se houver erro, será necessário corrigir manualmente ou restaurar de backup.

---

### **4. Testar Conectividade**

Execute no servidor:

```bash
# Testar se o container consegue alcançar o host
docker exec webhooks-php-dev ping -c 2 172.18.0.1

# Testar se a porta 3306 está acessível
docker exec webhooks-php-dev nc -zv 172.18.0.1 3306

# Testar conexão MySQL direta do container
docker exec webhooks-php-dev php -r "
try {
    \$pdo = new PDO('mysql:host=172.18.0.1;port=3306;dbname=rpa_logs_dev', 'rpa_logger_dev', 'tYbAwe7QkKNrHSRhaWplgsSxt');
    echo 'Connection OK\n';
} catch (Exception \$e) {
    echo 'Error: ' . \$e->getMessage() . '\n';
}
"
```

---

## 🎯 SOLUÇÃO ALTERNATIVA (SE NADA FUNCIONAR)

### **Opção: Usar network_mode: host**

Se as soluções acima não funcionarem, modificar o `docker-compose.yml`:

```yaml
php-dev:
  network_mode: host
  # Remover ou comentar:
  # networks:
  #   - webhooks-network
```

**Vantagem:** Container acessa MySQL diretamente via `localhost`  
**Desvantagem:** Container compartilha rede com host (menos isolamento)

**Após modificar:**
```bash
cd /opt/webhooks-server
docker compose down php-dev
docker compose up -d php-dev
```

E atualizar `ProfessionalLogger.php` para usar `localhost` ao invés de `172.18.0.1`.

---

## 📋 CHECKLIST

- [ ] Verificar permissões do usuário MySQL
- [ ] Verificar firewall/iptables
- [ ] Testar conectividade do container
- [ ] Se necessário, aplicar solução alternativa (network_mode: host)
- [ ] Testar inserção de log
- [ ] Testar consulta de logs

---

## 🚨 IMPORTANTE

**NÃO modifique o Nginx e PHP quando estão funcionando** (conforme diretivas).

As ações acima são apenas para:
- Configuração do MySQL (permissões)
- Verificação de firewall
- Correção de conectividade Docker

**Não alteram** a configuração do Nginx ou PHP-FPM.

---

**Última atualização:** 09/11/2025

