# 🔍 DIAGNÓSTICO: FlyingDonkeys Não Aparece na Rede Privada

**Data:** 25/11/2025  
**Problema:** Servidor flyingdonkeys não aparece na lista ao tentar conectar à Private Network  
**Localização:** Ambos servidores estão em Helsinki (mesma datacenter) ✅  
**Status:** 🔍 **DIAGNÓSTICO EM ANDAMENTO**

---

## 🎯 DIAGNÓSTICO RÁPIDO

### **Passo 1: Verificar se Servidor Está no Mesmo Projeto**

**No Hetzner Cloud Console:**

1. **Verificar projeto atual:**
   - Canto superior direito, verificar qual projeto está selecionado
   - Anotar nome do projeto

2. **Procurar servidor flyingdonkeys:**
   - Menu: **Servers** → **Servers**
   - Procurar na lista por `flyingdonkeys` ou nome similar
   - Verificar se aparece

**Se NÃO aparecer:**
- ⚠️ **Problema:** Servidor pode estar em **projeto diferente**
- ✅ **Solução:** Ver SOLUÇÃO 1 abaixo

**Se aparecer:**
- ✅ Servidor está no projeto
- ⚠️ **Próximo passo:** Verificar tipo de servidor

---

### **Passo 2: Verificar Tipo de Servidor**

**No Hetzner Cloud Console:**

1. **Se servidor flyingdonkeys aparecer na lista:**
   - Clicar no servidor
   - Verificar informações:
     - **Type:** Cloud Server ou Dedicated Server?
     - **Status:** Running, Stopped, ou Paused?

**Se for "Dedicated Server":**
- ⚠️ **Problema:** Servidores dedicados **NÃO aparecem** no Cloud Console para Private Networks
- ✅ **Solução:** Usar **vSwitch** (ver SOLUÇÃO 2 abaixo)

**Se for "Cloud Server":**
- ✅ Servidor é Cloud
- ⚠️ **Próximo passo:** Verificar se está ativo

---

### **Passo 3: Verificar Status do Servidor**

**Se servidor aparecer na lista:**

1. **Verificar status:**
   - **Running** ✅ - Servidor está ativo (deve aparecer)
   - **Stopped** ⚠️ - Servidor está desligado (ligar primeiro)
   - **Paused** ⚠️ - Servidor está pausado (retomar primeiro)

**Se estiver Stopped ou Paused:**
- ✅ **Solução:** Ligar servidor primeiro, depois tentar conectar à rede privada

---

## ✅ SOLUÇÃO 1: Servidor em Projeto Diferente

### **Cenário:** Servidor flyingdonkeys está em outro projeto Hetzner

### **Opção A: Mover Servidor para o Mesmo Projeto**

**⚠️ IMPORTANTE:** Mover servidor pode causar downtime. Fazer em horário de baixo tráfego.

**Passo a Passo:**

1. **No Hetzner Cloud Console:**
   - Selecionar projeto onde está o servidor flyingdonkeys
   - Menu: **Servers** → **Servers**
   - Clicar no servidor flyingdonkeys
   - Menu: **Actions** → **Move to Project** (se disponível)
   - Selecionar projeto do bssegurosimediato
   - Confirmar

2. **Aguardar conclusão:**
   - Operação pode levar alguns minutos
   - Servidor pode ter breve downtime

3. **Verificar:**
   - Selecionar projeto do bssegurosimediato
   - Verificar se servidor flyingdonkeys aparece na lista
   - Tentar conectar à rede privada novamente

---

### **Opção B: Criar Rede Privada em Cada Projeto (NÃO RECOMENDADO)**

**⚠️ LIMITAÇÃO:** Servidores em projetos diferentes **NÃO podem** estar na mesma Private Network.

**Solução Alternativa:** Usar IP público com firewall restrito (ver SOLUÇÃO 3)

---

## ✅ SOLUÇÃO 2: Servidor É Dedicado (vSwitch)

### **Cenário:** Servidor flyingdonkeys é dedicado (não Cloud)

**Servidores dedicados NÃO aparecem no Cloud Console para Private Networks.**

**Solução:** Usar **vSwitch** para conectar Cloud + Dedicado.

### **Passo a Passo:**

#### **Passo 1: Criar vSwitch no Hetzner Robot**

1. **Acessar Hetzner Robot:**
   - URL: https://robot.your-server.de/
   - Fazer login

2. **Criar vSwitch:**
   - Menu: **Networks** → **vSwitch**
   - Clicar em **"Create vSwitch"**
   - Preencher:
     - **Nome:** `bssegurosimediato-vswitch`
     - **VLAN ID:** (deixar automático ou definir manualmente)
   - Clicar em **"Create"**

3. **Anotar informações:**
   - **vSwitch ID:** (será gerado)
   - **VLAN ID:** (será gerado)

---

#### **Passo 2: Conectar Servidor Dedicado ao vSwitch**

1. **No Hetzner Robot:**
   - Menu: **Servers** → Selecionar servidor flyingdonkeys
   - Menu: **Network** → **vSwitch**
   - Selecionar vSwitch criado
   - Clicar em **"Connect"**

2. **Aguardar:**
   - Conexão pode levar alguns minutos
   - Servidor pode precisar reiniciar interface de rede

---

#### **Passo 3: Conectar Private Network Cloud ao vSwitch**

1. **No Hetzner Cloud Console:**
   - Selecionar projeto do bssegurosimediato
   - Menu: **Networking** → **Networks**
   - Selecionar Private Network criada
   - Procurar seção **"Dedicated Server vSwitch Connection"** ou **"vSwitch"**
   - Habilitar conexão vSwitch
   - Selecionar vSwitch criado no Robot
   - Clicar em **"Save"** ou **"Connect"**

2. **Verificar:**
   - Na página da Private Network, deve aparecer conexão com vSwitch
   - Servidor dedicado deve aparecer como conectado via vSwitch

---

#### **Passo 4: Configurar Interface de Rede no Servidor Dedicado**

**Conectar ao servidor flyingdonkeys (dedicado):**

```bash
ssh root@[IP_DO_FLYINGDONKEYS]

# Verificar interfaces de rede
ip addr show

# Verificar se interface VLAN aparece
# Se não aparecer, pode precisar configurar manualmente
```

**Se interface VLAN não aparecer automaticamente:**

```bash
# Editar configuração de rede (Ubuntu/Debian)
nano /etc/netplan/01-netcfg.yaml

# Adicionar configuração VLAN (exemplo):
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
  vlans:
    vlan100:  # Substituir pelo VLAN ID do vSwitch
      id: 100  # Substituir pelo VLAN ID do vSwitch
      link: eth0
      dhcp4: true

# Aplicar configuração
netplan apply
```

---

## ✅ SOLUÇÃO 3: Usar IP Público com Firewall Restrito (Alternativa)

**Se não conseguir conectar via rede privada, pode usar IP público com firewall restrito:**

### **Passo 1: Configurar Firewall no Servidor flyingdonkeys**

**Conectar ao servidor flyingdonkeys:**

```bash
ssh root@[IP_DO_FLYINGDONKEYS]

# Permitir apenas IPs do bssegurosimediato
ufw allow from 65.108.156.14 to any port 443  # DEV
ufw allow from 157.180.36.223 to any port 443  # PROD

# Bloquear todo o resto (opcional, mas recomendado)
ufw default deny incoming
ufw default allow outgoing

# Ativar firewall
ufw enable

# Verificar regras
ufw status numbered
```

### **Passo 2: Usar HTTPS com Certificado SSL**

**Vantagem:** Mantém criptografia mesmo usando IP público

**Desvantagem:** Ainda passa pela internet pública (mas com firewall restrito)

---

## 🔍 DIAGNÓSTICO DETALHADO

### **Checklist Completo:**

1. ✅ **Verificar projeto:**
   - [ ] Qual projeto está selecionado no Hetzner Cloud Console?
   - [ ] Servidor bssegurosimediato está em qual projeto?
   - [ ] Servidor flyingdonkeys está em qual projeto?
   - [ ] Estão no mesmo projeto?

2. ✅ **Verificar tipo de servidor:**
   - [ ] bssegurosimediato é Cloud ou Dedicado?
   - [ ] flyingdonkeys é Cloud ou Dedicado?
   - [ ] Tipos são compatíveis?

3. ✅ **Verificar status:**
   - [ ] Servidor flyingdonkeys está ativo?
   - [ ] Servidor está rodando?

4. ✅ **Verificar permissões:**
   - [ ] Usuário tem permissão para ver servidor?
   - [ ] Usuário tem permissão para modificar networks?

---

## 📋 PRÓXIMOS PASSOS BASEADOS NO DIAGNÓSTICO

### **Se servidor está em projeto diferente:**
1. ✅ Mover servidor para o mesmo projeto (SOLUÇÃO 1 - Opção A)
2. ✅ OU usar IP público com firewall (SOLUÇÃO 3)

### **Se servidor é dedicado:**
1. ✅ Criar vSwitch no Hetzner Robot (SOLUÇÃO 2)
2. ✅ Conectar servidor dedicado ao vSwitch
3. ✅ Conectar Private Network Cloud ao vSwitch

### **Se servidor está desligado:**
1. ✅ Ligar servidor primeiro
2. ✅ Aguardar inicialização completa
3. ✅ Tentar conectar à rede privada novamente

---

## 🆘 SE NADA FUNCIONAR

### **Alternativa Final: IP Público com Firewall Restrito**

**Mesmo sem rede privada, pode garantir segurança:**

1. ✅ **Configurar firewall** para permitir apenas IPs específicos
2. ✅ **Usar HTTPS** para criptografia
3. ✅ **Monitorar logs** para garantir segurança
4. ✅ **Considerar VPN** entre servidores (mais complexo)

---

## 📞 SUPORTE HETZNER

**Se nenhuma solução funcionar, contatar suporte Hetzner:**

- **Email:** support@hetzner.com
- **Ticket:** Criar ticket no Hetzner Cloud Console
- **Informações para fornecer:**
  - Nome dos servidores
  - IPs dos servidores
  - Projetos onde estão
  - Tipo de servidores (Cloud ou Dedicado)
  - Erro específico encontrado

---

**Documento criado em:** 25/11/2025  
**Status:** 🔍 **DIAGNÓSTICO - AGUARDANDO VERIFICAÇÃO DO TIPO DE SERVIDOR**

