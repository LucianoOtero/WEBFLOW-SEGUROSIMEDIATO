# 🔧 TROUBLESHOOTING: FlyingDonkeys Não Aparece na Rede Privada

**Data:** 25/11/2025  
**Problema:** Servidor flyingdonkeys não aparece na lista ao tentar conectar à rede privada  
**Status:** 🔍 **DIAGNÓSTICO E SOLUÇÕES**

---

## 🔍 DIAGNÓSTICO

### **Causas Possíveis:**

1. ⚠️ **Servidor em projeto diferente** - Servidor flyingdonkeys está em outro projeto Hetzner
2. ⚠️ **Servidor dedicado (não Cloud)** - Servidor flyingdonkeys é dedicado, não Cloud
3. ⚠️ **Servidor não está ativo** - Servidor está desligado ou pausado
4. ⚠️ **Permissões insuficientes** - Usuário não tem permissão para ver o servidor
5. ⚠️ **Servidor já conectado a outra network** - Servidor já está em outra rede privada

---

## ✅ SOLUÇÕES

### **SOLUÇÃO 1: Verificar se Servidor Está no Mesmo Projeto**

#### **Passo 1: Verificar Projeto Atual**

1. No Hetzner Cloud Console, verificar qual projeto está selecionado (canto superior direito)
2. Anotar nome do projeto

#### **Passo 2: Verificar Servidor flyingdonkeys**

1. Menu: **Servers** → **Servers**
2. Procurar servidor `flyingdonkeys` na lista
3. Verificar em qual projeto ele está

**Se servidor estiver em projeto diferente:**
- ⚠️ **Problema:** Servidores em projetos diferentes não podem estar na mesma rede privada
- ✅ **Solução:** Mover servidor para o mesmo projeto OU criar rede privada em cada projeto e conectá-las

---

### **SOLUÇÃO 2: Verificar Tipo de Servidor (Cloud vs Dedicado)**

#### **Passo 1: Identificar Tipo de Servidor**

**No Hetzner Cloud Console:**
1. Menu: **Servers** → **Servers**
2. Procurar servidor `flyingdonkeys`
3. Verificar se aparece na lista

**Se NÃO aparecer na lista:**
- ⚠️ **Problema:** Servidor pode ser **dedicado** (não Cloud)
- ✅ **Solução:** Servidores dedicados usam **vSwitch** (não Private Network)

#### **Passo 2: Verificar no Hetzner Robot (se for dedicado)**

1. Acessar: https://robot.your-server.de/
2. Fazer login
3. Verificar se servidor `flyingdonkeys` aparece na lista de servidores dedicados

**Se for servidor dedicado:**
- ⚠️ **Problema:** Servidores dedicados não aparecem no Cloud Console
- ✅ **Solução:** Usar **vSwitch** para conectar Cloud + Dedicado (ver SOLUÇÃO 3)

---

### **SOLUÇÃO 3: Conectar Cloud + Dedicado via vSwitch**

**Se bssegurosimediato é Cloud e flyingdonkeys é Dedicado:**

#### **Passo 1: Criar vSwitch no Hetzner Robot**

1. Acessar: https://robot.your-server.de/
2. Menu: **Networks** → **vSwitch**
3. Clicar em **"Create vSwitch"**
4. Definir:
   - **Nome:** `bssegurosimediato-vswitch`
   - **VLAN ID:** (deixar automático ou definir manualmente)
5. Clicar em **"Create"**

#### **Passo 2: Conectar Servidor Dedicado ao vSwitch**

1. No Hetzner Robot, selecionar servidor `flyingdonkeys`
2. Menu: **Network** → **vSwitch**
3. Selecionar vSwitch criado
4. Clicar em **"Connect"**

#### **Passo 3: Conectar Private Network Cloud ao vSwitch**

1. No Hetzner Cloud Console, ir para **Networking** → **Networks**
2. Selecionar Private Network criada
3. Procurar opção **"Enable dedicated server vSwitch Connection"**
4. Selecionar vSwitch criado no Robot
5. Clicar em **"Save"**

**Resultado:** Cloud e Dedicado estarão na mesma rede privada!

---

### **SOLUÇÃO 4: Verificar Status do Servidor**

#### **Passo 1: Verificar se Servidor Está Ativo**

**No Hetzner Cloud Console:**
1. Menu: **Servers** → **Servers**
2. Procurar servidor `flyingdonkeys`
3. Verificar status:
   - ✅ **Running** - Servidor está ativo
   - ⚠️ **Stopped** - Servidor está desligado (ligar primeiro)
   - ⚠️ **Paused** - Servidor está pausado (retomar primeiro)

**Se servidor estiver desligado ou pausado:**
- ✅ **Solução:** Ligar servidor primeiro, depois tentar conectar à rede privada

---

### **SOLUÇÃO 5: Verificar Permissões**

#### **Passo 1: Verificar Permissões do Usuário**

1. No Hetzner Cloud Console, verificar permissões do usuário
2. Menu: **Access** → **Users** (ou similar)
3. Verificar se usuário tem permissão para:
   - Ver servidores
   - Modificar networks
   - Conectar servidores a networks

**Se não tiver permissões:**
- ✅ **Solução:** Solicitar permissões ao administrador do projeto

---

### **SOLUÇÃO 6: Verificar se Servidor Já Está em Outra Network**

#### **Passo 1: Verificar Networks do Servidor**

**No Hetzner Cloud Console:**
1. Menu: **Servers** → **Servers**
2. Clicar no servidor `flyingdonkeys`
3. Aba: **Networks** ou **Networking**
4. Verificar se servidor já está conectado a outra network

**Se estiver em outra network:**
- ⚠️ **Problema:** Servidor pode estar limitado a uma network por vez (depende da configuração)
- ✅ **Solução:** Desconectar da network anterior OU usar a mesma network para ambos servidores

---

## 🔍 DIAGNÓSTICO PASSO A PASSO

### **Checklist de Diagnóstico:**

1. ✅ **Verificar projeto:**
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

5. ✅ **Verificar networks existentes:**
   - [ ] Servidor flyingdonkeys já está em outra network?
   - [ ] Precisa desconectar primeiro?

---

## 🚀 SOLUÇÃO RECOMENDADA (Baseada no Problema)

### **Cenário Mais Provável: Servidor em Projeto Diferente ou Dedicado**

#### **Opção A: Se Servidor Está em Projeto Diferente**

**Solução:** Mover servidor para o mesmo projeto OU criar rede privada em cada projeto

**Passo a Passo:**
1. Identificar projeto do servidor flyingdonkeys
2. Se possível, mover servidor para o mesmo projeto do bssegurosimediato
3. OU criar rede privada no projeto do flyingdonkeys também
4. Conectar servidores às suas respectivas networks

**Nota:** Servidores em projetos diferentes **NÃO podem** estar na mesma Private Network do Hetzner Cloud. Precisa usar vSwitch ou mover servidores.

---

#### **Opção B: Se Servidor É Dedicado**

**Solução:** Usar vSwitch para conectar Cloud + Dedicado

**Passo a Passo:**
1. Criar vSwitch no Hetzner Robot
2. Conectar servidor dedicado (flyingdonkeys) ao vSwitch
3. No Hetzner Cloud Console, habilitar conexão vSwitch na Private Network
4. Selecionar vSwitch criado
5. Servidores estarão conectados!

---

## 📋 COMANDOS PARA VERIFICAR

### **Verificar Informações do Servidor (via SSH)**

**Conectar ao servidor flyingdonkeys:**
```bash
ssh root@[IP_DO_FLYINGDONKEYS]

# Verificar tipo de servidor
hostnamectl

# Verificar interfaces de rede
ip addr show

# Verificar se já tem interface privada
ip addr show | grep "10.0.0"
```

---

## ✅ PRÓXIMOS PASSOS

1. ✅ **Identificar causa:** Verificar qual das soluções se aplica
2. ✅ **Aplicar solução:** Seguir passos da solução correspondente
3. ✅ **Testar conectividade:** Após conectar, testar ping entre servidores
4. ✅ **Validar:** Confirmar que rede privada está funcionando

---

## 🆘 SE NADA FUNCIONAR

### **Alternativa: Usar IP Público com Firewall Restrito**

Se não conseguir conectar via rede privada, pode usar IP público com firewall restrito:

1. **Configurar firewall** para permitir apenas comunicação entre IPs específicos
2. **Usar HTTPS** para criptografia
3. **Monitorar** logs para garantir segurança

**Exemplo de Firewall:**
```bash
# No servidor flyingdonkeys, permitir apenas IP do bssegurosimediato
ufw allow from 65.108.156.14 to any port 443
ufw allow from 157.180.36.223 to any port 443
```

---

**Documento criado em:** 25/11/2025  
**Status:** 🔧 **TROUBLESHOOTING - AGUARDANDO DIAGNÓSTICO**

