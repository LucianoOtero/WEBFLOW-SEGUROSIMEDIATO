# 🔧 GUIA PASSO A PASSO: Criar Rede Privada no Hetzner

**Data:** 25/11/2025  
**Status:** 📋 **GUIA PRÁTICO**  
**Objetivo:** Criar rede privada entre servidores bssegurosimediato.com.br e flyingdonkeys.com.br

---

## 📋 PRÉ-REQUISITOS

Antes de começar, você precisa:

- ✅ Acesso ao Hetzner Cloud Console (https://console.hetzner.cloud/)
- ✅ Credenciais de login do Hetzner
- ✅ Conhecer os nomes dos servidores (bssegurosimediato e flyingdonkeys)
- ✅ Acesso SSH aos servidores (para testes)

---

## 🚀 PASSO 1: ACESSAR HETZNER CLOUD CONSOLE

### **1.1. Abrir Navegador e Acessar Console**

1. Abrir navegador (Chrome, Firefox, Edge)
2. Acessar: **https://console.hetzner.cloud/**
3. Fazer login com suas credenciais Hetzner

### **1.2. Selecionar Projeto**

1. No canto superior direito, verificar se o projeto correto está selecionado
2. Se houver múltiplos projetos, selecionar o projeto que contém os servidores

---

## 🚀 PASSO 2: CRIAR PRIVATE NETWORK

### **2.1. Navegar para Networks**

**Opção A - Menu Lateral:**
1. No menu lateral esquerdo, clicar em **"Networking"**
2. Clicar em **"Networks"**

**Opção B - Menu Superior:**
1. Clicar em **"Networking"** no menu superior
2. Clicar em **"Networks"**

### **2.2. Criar Nova Network**

1. Clicar no botão **"Add Network"** (canto superior direito, botão verde)
2. Preencher formulário:

   **Nome da Network:**
   ```
   bssegurosimediato-private-network
   ```
   *(ou outro nome de sua preferência)*

   **IP Range:**
   ```
   10.0.0.0/16
   ```
   *(ou `10.0.0.0/24` para rede menor - 254 IPs)*

   **Gateway:**
   ```
   10.0.0.1
   ```
   *(geralmente automático, mas pode definir manualmente)*

3. Clicar em **"Create Network"**

### **2.3. Anotar Informações**

Após criar, anotar:
- ✅ **Network ID:** (ex: `123456`)
- ✅ **Network Name:** `bssegurosimediato-private-network`
- ✅ **IP Range:** `10.0.0.0/16`
- ✅ **Gateway:** `10.0.0.1`

---

## 🚀 PASSO 3: CONECTAR SERVIDOR bssegurosimediato.com.br

### **3.1. Selecionar Network Criada**

1. Na lista de Networks, clicar na network criada: `bssegurosimediato-private-network`
2. Será aberta a página de detalhes da network

### **3.2. Adicionar Servidor à Network**

1. Na página de detalhes, procurar seção **"Attached Servers"** ou **"Routes"**
2. Clicar em **"Add Route"** ou **"Attach Server"** (botão verde)

### **3.3. Selecionar Servidor**

1. No dropdown, selecionar servidor `bssegurosimediato.com.br`
   - Pode aparecer como nome do servidor ou IP público
   - Exemplo: `bssegurosimediato-dev` ou `65.108.156.14`

2. **Definir IP Privado:**
   - Campo: **"IP"** ou **"Private IP"**
   - Valor: `10.0.0.10`
   - *(ou outro IP disponível no range 10.0.0.0/16)*

3. Clicar em **"Add"** ou **"Attach"**

### **3.4. Repetir para Servidor PROD (se aplicável)**

Se houver servidor PROD separado:
1. Clicar novamente em **"Add Route"** ou **"Attach Server"**
2. Selecionar servidor PROD (ex: `157.180.36.223`)
3. Definir IP privado: `10.0.0.11`
4. Clicar em **"Add"**

---

## 🚀 PASSO 4: CONECTAR SERVIDOR flyingdonkeys.com.br

### **4.1. Adicionar Servidor à Network**

1. Na mesma página de detalhes da network
2. Clicar em **"Add Route"** ou **"Attach Server"**

### **4.2. Selecionar Servidor**

1. No dropdown, selecionar servidor `flyingdonkeys.com.br`
   - Pode aparecer como nome do servidor ou IP público
   - Exemplo: `flyingdonkeys` ou IP do servidor

2. **Definir IP Privado:**
   - Campo: **"IP"** ou **"Private IP"**
   - Valor: `10.0.0.20`
   - *(ou outro IP disponível no range)*

3. Clicar em **"Add"** ou **"Attach"**

---

## 🚀 PASSO 5: VERIFICAR NO HETZNER CONSOLE

### **5.1. Verificar Servidores Conectados**

Na página de detalhes da network, você deve ver:

**Attached Servers:**
- ✅ `bssegurosimediato.com.br` - IP: `10.0.0.10`
- ✅ `flyingdonkeys.com.br` - IP: `10.0.0.20`

Se ambos aparecerem, a configuração no Hetzner está completa!

---

## 🚀 PASSO 6: VERIFICAR NOS SERVIDORES (VIA SSH)

### **6.1. Conectar ao Servidor bssegurosimediato.com.br**

```bash
# Conectar via SSH
ssh root@65.108.156.14
# (ou IP do servidor DEV/PROD)
```

### **6.2. Verificar Interface de Rede Privada**

```bash
# Ver todas as interfaces de rede
ip addr show

# Ou apenas interfaces com IP privado
ip addr show | grep "10.0.0"
```

**Resultado Esperado:**
```
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
    inet 10.0.0.10/16 brd 10.0.0.255 scope global eth1
```

Se aparecer interface com IP `10.0.0.10`, está correto!

### **6.3. Verificar Roteamento**

```bash
# Ver rotas de rede
ip route show

# Ou apenas rotas para rede privada
ip route show | grep "10.0.0"
```

**Resultado Esperado:**
```
10.0.0.0/16 dev eth1 scope link
```

---

## 🚀 PASSO 7: TESTAR CONECTIVIDADE

### **7.1. Testar Ping do bssegurosimediato para flyingdonkeys**

**No servidor bssegurosimediato.com.br:**

```bash
# Testar ping para IP privado do flyingdonkeys
ping -c 4 10.0.0.20
```

**Resultado Esperado:**
```
PING 10.0.0.20 (10.0.0.20) 56(84) bytes of data.
64 bytes from 10.0.0.20: icmp_seq=1 ttl=64 time=0.123 ms
64 bytes from 10.0.0.20: icmp_seq=2 ttl=64 time=0.098 ms
64 bytes from 10.0.0.20: icmp_seq=3 ttl=64 time=0.105 ms
64 bytes from 10.0.0.20: icmp_seq=4 ttl=64 time=0.112 ms

--- 10.0.0.20 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss
```

✅ **Se ping funcionar, conectividade está OK!**

### **7.2. Testar Ping do flyingdonkeys para bssegurosimediato**

**Conectar ao servidor flyingdonkeys.com.br:**

```bash
# Conectar via SSH
ssh root@[IP_DO_FLYINGDONKEYS]

# Testar ping para IP privado do bssegurosimediato
ping -c 4 10.0.0.10
```

**Resultado Esperado:**
```
PING 10.0.0.10 (10.0.0.10) 56(84) bytes of data.
64 bytes from 10.0.0.10: icmp_seq=1 ttl=64 time=0.115 ms
64 bytes from 10.0.0.10: icmp_seq=2 ttl=64 time=0.102 ms
64 bytes from 10.0.0.10: icmp_seq=3 ttl=64 time=0.108 ms
64 bytes from 10.0.0.10: icmp_seq=4 ttl=64 time=0.110 ms
```

✅ **Se ping funcionar em ambos sentidos, rede privada está funcionando!**

---

## 🚀 PASSO 8: TESTAR HTTP (OPCIONAL)

### **8.1. Testar HTTP do bssegurosimediato para flyingdonkeys**

**No servidor bssegurosimediato.com.br:**

```bash
# Testar HTTP para IP privado do flyingdonkeys
curl -v http://10.0.0.20/webhooks/add_flyingdonkeys_v2.php
```

**Resultado Esperado:**
```
* Connected to 10.0.0.20 (10.0.0.20) port 80
* HTTP/1.1 200 OK
...
```

✅ **Se HTTP funcionar, aplicação pode usar IP privado!**

---

## 🚀 PASSO 9: CONFIGURAR VARIÁVEIS DE AMBIENTE (OPCIONAL)

### **9.1. No Servidor bssegurosimediato.com.br**

```bash
# Editar arquivo de variáveis de ambiente
nano /etc/environment

# Adicionar linhas:
FLYINGDONKEYS_PRIVATE_IP=10.0.0.20
FLYINGDONKEYS_PRIVATE_PROTOCOL=http

# Salvar e sair (Ctrl+X, Y, Enter)
```

### **9.2. Recarregar Variáveis de Ambiente**

```bash
# Recarregar variáveis
source /etc/environment

# Verificar se foram carregadas
echo $FLYINGDONKEYS_PRIVATE_IP
# Deve mostrar: 10.0.0.20
```

### **9.3. Configurar PHP-FPM para Usar Variáveis**

```bash
# Editar arquivo PHP-FPM
nano /etc/php/8.3/fpm/pool.d/www.conf

# Adicionar na seção [www]:
env[FLYINGDONKEYS_PRIVATE_IP] = 10.0.0.20
env[FLYINGDONKEYS_PRIVATE_PROTOCOL] = http

# Salvar e sair
# Recarregar PHP-FPM
systemctl reload php8.3-fpm
```

---

## 🚀 PASSO 10: MODIFICAR CÓDIGO (OPCIONAL - DEPOIS DE TESTAR)

### **10.1. Modificar ProfessionalLogger.php**

**Arquivo:** `ProfessionalLogger.php`

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`

**Modificar método `sendEmailNotification()`:**

```php
// ANTES:
$endpoint = $_ENV['APP_BASE_URL'] . '/send_email_notification_endpoint.php';

// DEPOIS (com fallback seguro):
$flyingdonkeys_ip = $_ENV['FLYINGDONKEYS_PRIVATE_IP'] ?? 'flyingdonkeys.com.br';
$flyingdonkeys_protocol = $_ENV['FLYINGDONKEYS_PRIVATE_PROTOCOL'] ?? 'https';
$endpoint = "{$flyingdonkeys_protocol}://{$flyingdonkeys_ip}/webhooks/add_flyingdonkeys_v2.php";
```

### **10.2. Testar em DEV Primeiro**

1. ✅ Modificar código em DEV
2. ✅ Testar comunicação via rede privada
3. ✅ Verificar logs
4. ✅ Validar que funciona corretamente
5. ✅ Aplicar em PROD após validação

---

## ✅ CHECKLIST DE VERIFICAÇÃO

### **Após Criar Rede Privada:**

- [ ] Network criada no Hetzner Console
- [ ] Servidor bssegurosimediato conectado (IP: 10.0.0.10)
- [ ] Servidor flyingdonkeys conectado (IP: 10.0.0.20)
- [ ] Interface de rede privada aparece em ambos servidores
- [ ] Ping funciona de bssegurosimediato para flyingdonkeys
- [ ] Ping funciona de flyingdonkeys para bssegurosimediato
- [ ] HTTP funciona entre servidores (opcional)
- [ ] Variáveis de ambiente configuradas (opcional)
- [ ] Código modificado com fallback (opcional)

---

## 🚨 TROUBLESHOOTING

### **Problema 1: Interface de Rede Privada Não Aparece**

**Sintoma:** `ip addr show` não mostra IP privado

**Solução:**
```bash
# Verificar se servidor está conectado à network no Hetzner Console
# Se não estiver, conectar novamente
# Aguardar alguns segundos para interface aparecer
# Reiniciar interface de rede (se necessário)
systemctl restart networking
```

---

### **Problema 2: Ping Não Funciona**

**Sintoma:** `ping 10.0.0.20` retorna "Network is unreachable"

**Solução:**
```bash
# Verificar roteamento
ip route show | grep "10.0.0"

# Se não aparecer rota, adicionar manualmente (temporário)
ip route add 10.0.0.0/16 dev eth1

# Verificar firewall
ufw status
# Permitir comunicação entre servidores
ufw allow from 10.0.0.0/16
```

---

### **Problema 3: Servidor Não Aparece no Dropdown**

**Sintoma:** Servidor não aparece na lista ao tentar conectar

**Solução:**
- ✅ Verificar se servidor está no mesmo projeto Hetzner
- ✅ Verificar se servidor está ativo
- ✅ Tentar recarregar página do Hetzner Console
- ✅ Verificar se servidor é Cloud (não dedicado)

---

### **Problema 4: HTTP Retorna Erro 502 ou Timeout**

**Sintoma:** `curl http://10.0.0.20` retorna erro

**Solução:**
```bash
# Verificar se Nginx está escutando na interface privada
netstat -tlnp | grep :80

# Verificar se firewall permite porta 80
ufw allow from 10.0.0.0/16 to any port 80

# Verificar se Nginx aceita conexões da rede privada
# Editar /etc/nginx/nginx.conf se necessário
```

---

## 📊 RESUMO DOS IPs

Após configuração, você terá:

| Servidor | IP Público | IP Privado | Função |
|----------|------------|------------|--------|
| **bssegurosimediato.com.br** | `65.108.156.14` (DEV) / `157.180.36.223` (PROD) | `10.0.0.10` (DEV) / `10.0.0.11` (PROD) | Servidor principal |
| **flyingdonkeys.com.br** | `?` | `10.0.0.20` | Servidor CRM |

**Uso:**
- **IP Público:** Continua funcionando normalmente (internet pública)
- **IP Privado:** Usar para comunicação entre servidores (rede privada)

---

## 🎯 PRÓXIMOS PASSOS

Após criar rede privada e testar:

1. ✅ **Validar conectividade** (ping e HTTP)
2. ✅ **Configurar variáveis de ambiente** (opcional)
3. ✅ **Modificar código com fallback** (opcional)
4. ✅ **Testar em DEV** (se modificou código)
5. ✅ **Aplicar em PROD** (após validação em DEV)
6. ✅ **Monitorar logs** para confirmar uso da rede privada

---

## 📚 REFERÊNCIAS

- **Documentação Hetzner:** https://docs.hetzner.com/networking/networks/
- **Hetzner Cloud Console:** https://console.hetzner.cloud/
- **Documento Completo:** `REDE_PRIVADA_HETZNER_SERVIDORES_20251125.md`

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **GUIA PRÁTICO COMPLETO - PRONTO PARA USO**

