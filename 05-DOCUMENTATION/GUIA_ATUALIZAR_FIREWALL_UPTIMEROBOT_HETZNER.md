# 🔧 GUIA: Atualizar Firewall para IPs do UptimeRobot no Hetzner

**Data:** 24/11/2025  
**Versão:** 1.0.0  
**Contexto:** UptimeRobot atualizou infraestrutura de monitoramento

---

## 📋 SUMÁRIO

### **Problema:**
UptimeRobot atualizou sua infraestrutura de monitoramento e agora usa novos IPs. O firewall do servidor Hetzner precisa ser atualizado para permitir requisições desses novos IPs.

### **Solução:**
Atualizar regras de firewall (iptables, ufw, ou firewall-cmd) no servidor Hetzner para permitir os novos IPs do UptimeRobot.

---

## 🔍 IDENTIFICAR IPs DO UPTIMEROBOT

### **IPs do UptimeRobot (North America Region):**

**📍 ONDE ENCONTRAR OS IPs ATUALIZADOS:**
1. **Dashboard do UptimeRobot:** 
   - Acessar: https://uptimerobot.com/
   - Ir em: **Settings** → **Monitoring IPs**
   - Ou: **Settings** → **Locations** → Ver IPs da região "North America"

2. **Documentação oficial:** 
   - https://uptimerobot.com/help/locations/
   - https://uptimerobot.com/help/monitoring-ips/

**⚠️ IMPORTANTE:** 
- **SEMPRE verificar os IPs atualizados** no dashboard do UptimeRobot
- Os IPs podem ter mudado recentemente
- Usar os IPs listados na mensagem de alerta ou no dashboard

**IPs conhecidos (verificar se são os mais recentes):**
- `216.144.250.150`
- `216.144.250.151`
- `216.144.250.152`
- `216.144.250.153`
- `216.144.250.154`
- `216.144.250.155`
- `216.144.250.156`
- `216.144.250.157`
- `216.144.250.158`
- `216.144.250.159`

**🔍 Como verificar IPs atualizados:**
1. Acessar dashboard do UptimeRobot
2. Ir em Settings → Monitoring IPs
3. Filtrar por região "North America"
4. Copiar todos os IPs listados

---

## 🔧 VERIFICAR FIREWALL ATUAL

### **1. Verificar qual firewall está em uso:**

```bash
# Verificar se iptables está ativo
sudo iptables -L -n

# Verificar se ufw está ativo
sudo ufw status

# Verificar se firewalld está ativo
sudo systemctl status firewalld
```

### **2. Verificar regras atuais do firewall:**

```bash
# Se usar iptables
sudo iptables -L -n -v | grep -i uptime

# Se usar ufw
sudo ufw status numbered | grep -i uptime

# Se usar firewalld
sudo firewall-cmd --list-all | grep -i uptime
```

---

## 🔧 ATUALIZAR FIREWALL (IPTABLES)

### **Método 1: Adicionar IPs individuais**

```bash
# Conectar ao servidor Hetzner
ssh root@[IP_DO_SERVIDOR_HETZNER]

# Adicionar regras para cada IP do UptimeRobot
# Substituir [IP] pelos IPs reais do UptimeRobot

sudo iptables -A INPUT -s 216.144.250.150 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.151 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.152 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.153 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.154 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.155 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.156 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.157 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.158 -j ACCEPT
sudo iptables -A INPUT -s 216.144.250.159 -j ACCEPT

# Salvar regras (depende da distribuição)
# Para Debian/Ubuntu:
sudo iptables-save > /etc/iptables/rules.v4

# Para CentOS/RHEL:
sudo service iptables save
# ou
sudo /sbin/service iptables save
```

### **Método 2: Script para adicionar todos os IPs**

```bash
#!/bin/bash
# Script para adicionar IPs do UptimeRobot ao firewall

UPTIMEROBOT_IPS=(
    "216.144.250.150"
    "216.144.250.151"
    "216.144.250.152"
    "216.144.250.153"
    "216.144.250.154"
    "216.144.250.155"
    "216.144.250.156"
    "216.144.250.157"
    "216.144.250.158"
    "216.144.250.159"
)

echo "Adicionando IPs do UptimeRobot ao firewall..."

for ip in "${UPTIMEROBOT_IPS[@]}"; do
    # Verificar se regra já existe
    if ! sudo iptables -C INPUT -s "$ip" -j ACCEPT 2>/dev/null; then
        sudo iptables -A INPUT -s "$ip" -j ACCEPT
        echo "✅ IP $ip adicionado"
    else
        echo "⚠️  IP $ip já existe"
    fi
done

# Salvar regras
if [ -f /etc/iptables/rules.v4 ]; then
    sudo iptables-save > /etc/iptables/rules.v4
    echo "✅ Regras salvas em /etc/iptables/rules.v4"
elif [ -f /etc/sysconfig/iptables ]; then
    sudo service iptables save
    echo "✅ Regras salvas"
else
    echo "⚠️  Não foi possível salvar regras automaticamente"
    echo "   Execute manualmente: sudo iptables-save > /etc/iptables/rules.v4"
fi

echo "✅ Concluído!"
```

**Como usar o script:**
```bash
# 1. Criar arquivo
nano add_uptimerobot_ips.sh

# 2. Colar o conteúdo do script acima
# 3. Salvar e sair (Ctrl+X, Y, Enter)

# 4. Dar permissão de execução
chmod +x add_uptimerobot_ips.sh

# 5. Executar
sudo ./add_uptimerobot_ips.sh
```

---

## 🔧 ATUALIZAR FIREWALL (UFW)

### **Adicionar IPs ao UFW:**

```bash
# Conectar ao servidor Hetzner
ssh root@[IP_DO_SERVIDOR_HETZNER]

# Adicionar regras para cada IP do UptimeRobot
sudo ufw allow from 216.144.250.150
sudo ufw allow from 216.144.250.151
sudo ufw allow from 216.144.250.152
sudo ufw allow from 216.144.250.153
sudo ufw allow from 216.144.250.154
sudo ufw allow from 216.144.250.155
sudo ufw allow from 216.144.250.156
sudo ufw allow from 216.144.250.157
sudo ufw allow from 216.144.250.158
sudo ufw allow from 216.144.250.159

# Verificar regras adicionadas
sudo ufw status numbered
```

### **Script para UFW:**

```bash
#!/bin/bash
# Script para adicionar IPs do UptimeRobot ao UFW

UPTIMEROBOT_IPS=(
    "216.144.250.150"
    "216.144.250.151"
    "216.144.250.152"
    "216.144.250.153"
    "216.144.250.154"
    "216.144.250.155"
    "216.144.250.156"
    "216.144.250.157"
    "216.144.250.158"
    "216.144.250.159"
)

echo "Adicionando IPs do UptimeRobot ao UFW..."

for ip in "${UPTIMEROBOT_IPS[@]}"; do
    sudo ufw allow from "$ip"
    echo "✅ IP $ip adicionado"
done

echo "✅ Concluído!"
echo ""
echo "Verificando regras:"
sudo ufw status numbered
```

---

## 🔧 ATUALIZAR FIREWALL (FIREWALLD)

### **Adicionar IPs ao Firewalld:**

```bash
# Conectar ao servidor Hetzner
ssh root@[IP_DO_SERVIDOR_HETZNER]

# Adicionar regras para cada IP do UptimeRobot
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.150" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.151" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.152" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.153" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.154" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.155" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.156" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.157" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.158" accept'
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="216.144.250.159" accept'

# Recarregar firewall
sudo firewall-cmd --reload

# Verificar regras
sudo firewall-cmd --list-all
```

---

## 🔧 ATUALIZAR FIREWALL VIA HETZNER CLOUD CONSOLE

### **Se usar Hetzner Cloud Firewall:**

1. **Acessar Hetzner Cloud Console:**
   - https://console.hetzner.cloud/

2. **Navegar para Firewalls:**
   - Selecionar projeto
   - Ir para "Firewalls"

3. **Editar Firewall:**
   - Selecionar firewall do servidor
   - Clicar em "Edit"

4. **Adicionar Regras:**
   - Adicionar regra de entrada (Inbound)
   - Tipo: IPv4
   - Source IPs: Adicionar IPs do UptimeRobot (um por linha)
   - Port: 80, 443 (ou "All")
   - Action: Allow

5. **Aplicar:**
   - Clicar em "Apply to resources"
   - Selecionar servidor
   - Aplicar

---

## ✅ VERIFICAR SE FUNCIONOU

### **1. Verificar regras adicionadas:**

```bash
# iptables
sudo iptables -L -n | grep 216.144.250

# ufw
sudo ufw status | grep 216.144.250

# firewalld
sudo firewall-cmd --list-all | grep 216.144.250
```

### **2. Testar conectividade:**

```bash
# Testar se IP pode acessar (do servidor)
# Isso não testa diretamente, mas verifica se regra está ativa

# Verificar logs de firewall (se disponível)
sudo tail -f /var/log/firewall.log
```

### **3. Verificar no UptimeRobot:**

1. Acessar dashboard do UptimeRobot
2. Verificar status dos monitores
3. Aguardar alguns minutos para verificar se monitoramento está funcionando
4. Verificar histórico de checks

---

## 🚨 REMOVER IPs ANTIGOS (SE NECESSÁRIO)

### **Se houver IPs antigos do UptimeRobot:**

```bash
# iptables - Listar regras e identificar IPs antigos
sudo iptables -L -n --line-numbers | grep -i uptime

# Remover regra específica (substituir [NUMERO] pelo número da linha)
sudo iptables -D INPUT [NUMERO]

# Salvar
sudo iptables-save > /etc/iptables/rules.v4
```

```bash
# ufw - Listar regras numeradas
sudo ufw status numbered

# Remover regra (substituir [NUMERO] pelo número da regra)
sudo ufw delete [NUMERO]
```

```bash
# firewalld - Remover regra
sudo firewall-cmd --permanent --remove-rich-rule='rule family="ipv4" source address="[IP_ANTIGO]" accept'
sudo firewall-cmd --reload
```

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Antes de Começar:**

- [ ] Verificar IPs atualizados no dashboard do UptimeRobot
- [ ] Identificar qual firewall está em uso (iptables, ufw, firewalld)
- [ ] Fazer backup das regras atuais do firewall
- [ ] Verificar se há IPs antigos do UptimeRobot

### **Durante a Implementação:**

- [ ] Adicionar novos IPs do UptimeRobot
- [ ] Verificar se regras foram adicionadas corretamente
- [ ] Salvar regras (se necessário)
- [ ] Remover IPs antigos (se necessário)

### **Após a Implementação:**

- [ ] Verificar no UptimeRobot se monitoramento está funcionando
- [ ] Aguardar alguns minutos e verificar histórico de checks
- [ ] Documentar IPs adicionados
- [ ] Criar backup das novas regras

---

## 📝 NOTAS IMPORTANTES

1. **IPs Podem Mudar:**
   - UptimeRobot pode atualizar IPs periodicamente
   - Verificar dashboard regularmente
   - Considerar usar range de IPs se disponível

2. **Backup das Regras:**
   - Sempre fazer backup antes de modificar firewall
   - Comando para backup:
     ```bash
     # iptables
     sudo iptables-save > /root/iptables_backup_$(date +%Y%m%d).txt
     
     # ufw
     sudo cp /etc/ufw/user.rules /root/ufw_backup_$(date +%Y%m%d).txt
     ```

3. **Testar em Horário de Baixo Tráfego:**
   - Se possível, fazer alterações em horário de baixo tráfego
   - Ter plano de rollback pronto

4. **Documentar:**
   - Documentar quais IPs foram adicionados
   - Documentar data da atualização
   - Manter registro para futuras atualizações

---

## 🔗 LINKS ÚTEIS

- **UptimeRobot Monitoring IPs:** https://uptimerobot.com/help/monitoring-ips/
- **Hetzner Cloud Firewall:** https://docs.hetzner.com/cloud/firewalls/
- **iptables Documentation:** https://linux.die.net/man/8/iptables
- **UFW Documentation:** https://help.ubuntu.com/community/UFW

---

**Documento criado em:** 24/11/2025  
**Versão:** 1.0.0

