# 🔧 SOLUÇÃO: Servidores em Projetos Diferentes - Private Network

**Data:** 25/11/2025  
**Problema:** Servidores estão em projetos diferentes - Private Network não permite conectar servidores de projetos diferentes  
**Status:** ✅ **SOLUÇÕES DISPONÍVEIS**

---

## 🔍 DIAGNÓSTICO CONFIRMADO

### **Problema Identificado:**

- ⚠️ **bssegurosimediato** está em um projeto Hetzner
- ⚠️ **FlyingDonkeys** está em outro projeto Hetzner
- ⚠️ **Private Networks são isoladas por projeto** - servidores de projetos diferentes não podem estar na mesma Private Network
- ⚠️ Por isso só aparece o servidor do mesmo projeto na lista

---

## ✅ SOLUÇÃO 1: Mover Servidor para o Mesmo Projeto (RECOMENDADO)

### **Vantagens:**
- ✅ Permite usar Private Network (comunicação direta, sem internet)
- ✅ Mais seguro (isolado da internet)
- ✅ Melhor performance (latência <1ms)
- ✅ Gratuito

### **Desvantagens:**
- ⚠️ Pode causar breve downtime (alguns segundos)
- ⚠️ Requer acesso a ambos projetos

### **Passo a Passo:**

#### **Passo 1: Identificar Projetos**

1. **No Hetzner Cloud Console:**
   - Verificar qual projeto está selecionado (canto superior direito)
   - Anotar nome do projeto onde está o **bssegurosimediato**

2. **Verificar projeto do FlyingDonkeys:**
   - Mudar para outro projeto (se houver)
   - Verificar se FlyingDonkeys aparece
   - Anotar nome do projeto onde está o **FlyingDonkeys**

---

#### **Passo 2: Mover Servidor FlyingDonkeys**

**⚠️ IMPORTANTE:** Fazer em horário de baixo tráfego para minimizar impacto.

1. **No Hetzner Cloud Console:**
   - Selecionar projeto onde está o **FlyingDonkeys**
   - Menu: **Servers** → **Servers**
   - Clicar no servidor **FlyingDonkeys**

2. **Mover servidor:**
   - Menu: **Actions** → **Move to Project**
   - **OU** Menu: **Settings** → **Move to Project**
   - Selecionar projeto onde está o **bssegurosimediato**
   - Confirmar operação

3. **Aguardar conclusão:**
   - Operação pode levar 1-2 minutos
   - Servidor pode ter breve downtime (alguns segundos)
   - Aguardar até aparecer mensagem de sucesso

---

#### **Passo 3: Verificar e Conectar à Private Network**

1. **Selecionar projeto correto:**
   - Mudar para projeto onde está o **bssegurosimediato**
   - Verificar se **FlyingDonkeys** aparece na lista de servidores

2. **Conectar à Private Network:**
   - Menu: **Networking** → **Networks**
   - Clicar na Private Network criada
   - Clicar em **"Add Route"** ou **"Attach Server"**
   - **FlyingDonkeys deve aparecer na lista agora!**
   - Selecionar **FlyingDonkeys**
   - Definir IP privado: `10.0.0.20`
   - Clicar em **"Add"**

3. **Verificar:**
   - Ambos servidores devem aparecer na lista da Private Network
   - Testar conectividade (ping entre IPs privados)

---

## ✅ SOLUÇÃO 2: IP Público com Firewall Restrito (ALTERNATIVA)

**Se não quiser mover servidor ou não tiver acesso:**

### **Vantagens:**
- ✅ Não requer mover servidor
- ✅ Não causa downtime
- ✅ Funciona imediatamente
- ✅ Ainda seguro (com firewall restrito)

### **Desvantagens:**
- ⚠️ Passa pela internet pública (mas com firewall restrito)
- ⚠️ Latência um pouco maior (mas ainda baixa, mesma datacenter)

### **Passo a Passo:**

#### **Passo 1: Configurar Firewall no Servidor FlyingDonkeys**

**Conectar ao servidor FlyingDonkeys:**

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

**Resultado:**
```
Status: active

To                         Action      From
--                         ------      ----
443/tcp                    ALLOW       65.108.156.14
443/tcp                    ALLOW       157.180.36.223
```

---

#### **Passo 2: Configurar Firewall no Servidor bssegurosimediato**

**Conectar ao servidor bssegurosimediato:**

```bash
ssh root@65.108.156.14  # DEV
# ou
ssh root@157.180.36.223  # PROD

# Permitir apenas IP do FlyingDonkeys
ufw allow from [IP_DO_FLYINGDONKEYS] to any port 443

# Verificar regras
ufw status numbered
```

---

#### **Passo 3: Usar HTTPS com Certificado SSL**

**Vantagem:** Mantém criptografia mesmo usando IP público

**No código PHP:**
```php
// Usar IP público do FlyingDonkeys com HTTPS
$flyingdonkeys_ip = $_ENV['FLYINGDONKEYS_PUBLIC_IP'] ?? 'flyingdonkeys.com.br';
$endpoint = "https://{$flyingdonkeys_ip}/webhooks/add_flyingdonkeys_v2.php";
```

---

## 📊 COMPARAÇÃO DAS SOLUÇÕES

| Aspecto | Solução 1: Mover Servidor | Solução 2: IP Público + Firewall |
|---------|---------------------------|-----------------------------------|
| **Rede Privada** | ✅ Sim (IP privado) | ❌ Não (IP público) |
| **Internet Pública** | ❌ Não passa | ⚠️ Sim (mas com firewall) |
| **Latência** | <1ms | 1-5ms (mesma datacenter) |
| **Segurança** | ✅ Máxima (isolado) | ✅ Alta (firewall restrito) |
| **Downtime** | ⚠️ Breve (segundos) | ✅ Zero |
| **Complexidade** | Média | Baixa |
| **Custo** | Gratuito | Gratuito |

---

## 🎯 RECOMENDAÇÃO

### **Recomendação: Solução 1 (Mover Servidor)**

**Por quê:**
- ✅ Permite usar rede privada (comunicação direta, sem internet)
- ✅ Mais seguro (isolado da internet pública)
- ✅ Melhor performance (latência <1ms)
- ✅ Downtime é mínimo (alguns segundos)
- ✅ Uma vez feito, não precisa mais mexer

**Quando usar Solução 2:**
- ⚠️ Se não tiver acesso para mover servidor
- ⚠️ Se não puder ter downtime (mesmo que mínimo)
- ⚠️ Se preferir solução mais rápida (sem mover servidor)

---

## 🚀 IMPLEMENTAÇÃO RECOMENDADA

### **Opção A: Mover Servidor (Recomendado)**

1. ✅ Identificar projetos de ambos servidores
2. ✅ Mover FlyingDonkeys para projeto do bssegurosimediato
3. ✅ Conectar FlyingDonkeys à Private Network
4. ✅ Testar conectividade via IP privado
5. ✅ Modificar código para usar IP privado

**Tempo estimado:** 5-10 minutos

---

### **Opção B: IP Público + Firewall (Alternativa)**

1. ✅ Configurar firewall no FlyingDonkeys (permitir apenas IPs do bssegurosimediato)
2. ✅ Configurar firewall no bssegurosimediato (permitir apenas IP do FlyingDonkeys)
3. ✅ Usar HTTPS com certificado SSL
4. ✅ Modificar código para usar IP público (ou manter domínio)

**Tempo estimado:** 5 minutos

---

## 📋 CHECKLIST

### **Se escolher Solução 1 (Mover Servidor):**

- [ ] Identificar projeto do bssegurosimediato
- [ ] Identificar projeto do FlyingDonkeys
- [ ] Mover FlyingDonkeys para projeto do bssegurosimediato
- [ ] Verificar que FlyingDonkeys aparece na lista de servidores
- [ ] Conectar FlyingDonkeys à Private Network
- [ ] Atribuir IP privado: `10.0.0.20`
- [ ] Testar ping entre servidores
- [ ] Modificar código para usar IP privado

---

### **Se escolher Solução 2 (IP Público + Firewall):**

- [ ] Obter IP público do FlyingDonkeys
- [ ] Configurar firewall no FlyingDonkeys (permitir apenas IPs do bssegurosimediato)
- [ ] Configurar firewall no bssegurosimediato (permitir apenas IP do FlyingDonkeys)
- [ ] Testar conectividade HTTPS
- [ ] Modificar código (se necessário)

---

## 🆘 SE NÃO TIVER ACESSO PARA MOVER SERVIDOR

**Solução:** Usar Solução 2 (IP Público + Firewall)

**É seguro?**
- ✅ Sim, com firewall restrito permite apenas comunicação entre servidores específicos
- ✅ HTTPS garante criptografia
- ✅ Mesma datacenter = latência baixa (1-5ms)
- ✅ Não passa por roteamento externo (mesma infraestrutura Hetzner)

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **SOLUÇÕES DISPONÍVEIS - AGUARDANDO ESCOLHA**

