# Guia: Configurar Proton VPN no Roteador TP-Link TL-ER605

**Data:** 24/11/2025  
**Roteador:** TP-Link TL-ER605  
**VPN:** Proton VPN  
**IP do Roteador:** `192.168.0.1`  
**Opções Disponíveis:** OpenVPN, Wireguard, IPsec, L2TP, PPTP

---

## 📋 RESUMO EXECUTIVO

### **Opções de VPN Disponíveis:**
- ✅ **Wireguard** - ⭐ **RECOMENDADO** (mais rápido e moderno)
- ✅ **OpenVPN** - ✅ **SUPORTADO** (mais comum, bem testado)
- ✅ **IPsec** - ✅ **SUPORTADO** (IKEv2/IPsec)
- ⚠️ **L2TP** - ⚠️ Menos seguro
- ⚠️ **PPTP** - ❌ Não recomendado (inseguro)

### **Recomendação:**
⭐ **Wireguard** (se disponível no Proton VPN) ou **OpenVPN** (mais comum)

---

## 🎯 OPÇÃO 1: WIREGUARD (RECOMENDADO - SE DISPONÍVEL)

### **Vantagens do Wireguard:**
- ✅ **Mais rápido** - Performance superior
- ✅ **Mais moderno** - Protocolo mais recente
- ✅ **Menos overhead** - Menor impacto na velocidade
- ✅ **Mais seguro** - Criptografia moderna

### **Configuração Wireguard:**

#### **Passo 1: Verificar se Proton VPN suporta Wireguard**
- Acessar: https://account.protonvpn.com/downloads
- Verificar se há arquivo de configuração Wireguard (`.conf`)
- Se não houver, usar OpenVPN (Opção 2)

#### **Passo 2: Baixar Configuração Wireguard**
1. Fazer login no Proton VPN
2. Ir em Downloads → Wireguard
3. Selecionar servidor **São Paulo**
4. Baixar arquivo `.conf`

#### **Passo 3: Configurar no Roteador**
1. **Acessar roteador:** `http://192.168.0.1`
2. **Ir em:** VPN → Wireguard
3. **Clicar em:** Add (ou Add New)
4. **Preencher:**
   - **Interface Name:** `proton-vpn-sp` (ou nome de sua escolha)
   - **Private Key:** Copiar do arquivo `.conf` (chave privada)
   - **Public Key:** Copiar do arquivo `.conf` (chave pública)
   - **Address:** IP do servidor (do arquivo `.conf`)
   - **DNS:** `1.1.1.1` ou deixar vazio (usar DNS do Proton)
   - **MTU:** `1420` (padrão Wireguard)

5. **Configurar Peer (Servidor):**
   - **Public Key:** Chave pública do servidor (do arquivo `.conf`)
   - **Endpoint:** `servidor.protonvpn.com:51820` (do arquivo `.conf`)
   - **Allowed IPs:** `0.0.0.0/0` (todo o tráfego)
   - **Persistent Keepalive:** `25` (segundos)

6. **Salvar e Ativar:**
   - Salvar configuração
   - Ativar Wireguard
   - Verificar status: deve mostrar "Connected"

---

## 🎯 OPÇÃO 2: OPENVPN (MAIS COMUM - RECOMENDADO SE WIREGUARD NÃO DISPONÍVEL)

### **Vantagens do OpenVPN:**
- ✅ **Amplamente suportado** - Funciona em todos os lugares
- ✅ **Bem testado** - Protocolo maduro e confiável
- ✅ **Suportado pelo Proton VPN** - Configuração fácil

### **Configuração OpenVPN:**

#### **Passo 1: Baixar Configuração OpenVPN**
1. **Acessar:** https://account.protonvpn.com/downloads
2. **Selecionar:** OpenVPN
3. **Escolher servidor:** São Paulo (BR#1, BR#2, etc.)
4. **Baixar arquivo:** `.ovpn`

#### **Passo 2: Abrir Arquivo .ovpn**
O arquivo terá algo como:
```
client
dev tun
proto udp
remote br-xxx.protonvpn.net 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-CBC
auth SHA512
...
```

#### **Passo 3: Configurar no Roteador**
1. **Acessar roteador:** `http://192.168.0.1`
2. **Ir em:** VPN → OpenVPN
3. **Clicar em:** Add (ou Add New)
4. **Preencher campos:**

   **Configuração Básica:**
   - **Interface Name:** `proton-vpn-sp` (ou nome de sua escolha)
   - **Server Address:** `br-xxx.protonvpn.net` (do arquivo .ovpn, linha `remote`)
   - **Port:** `1194` (UDP) ou `443` (TCP) - verificar no arquivo .ovpn
   - **Protocol:** `UDP` (recomendado) ou `TCP`
   - **Username:** Seu usuário Proton VPN
   - **Password:** Sua senha Proton VPN

   **Upload de Certificado:**
   - **CA Certificate:** Copiar conteúdo entre `<ca>` e `</ca>` do arquivo .ovpn
   - **Client Certificate:** Copiar conteúdo entre `<cert>` e `</cert>` (se houver)
   - **Client Key:** Copiar conteúdo entre `<key>` e `</key>` (se houver)

   **Ou fazer upload do arquivo completo:**
   - **Upload Config File:** Fazer upload do arquivo `.ovpn` completo
   - O roteador pode importar automaticamente

5. **Salvar e Ativar:**
   - Salvar configuração
   - Ativar OpenVPN
   - Verificar status: deve mostrar "Connected"

---

## 🎯 OPÇÃO 3: IPSEC (IKEv2/IPsec)

### **Configuração IPsec:**

#### **Passo 1: Obter Credenciais IPsec do Proton VPN**
1. Acessar: https://account.protonvpn.com/downloads
2. Verificar se há configuração IKEv2/IPsec
3. Obter:
   - **Server Address:** Servidor Proton VPN
   - **Username:** Seu usuário
   - **Password:** Senha IPsec (pode ser diferente da senha normal)
   - **Pre-shared Key:** Chave compartilhada (se aplicável)

#### **Passo 2: Configurar no Roteador**
1. **Acessar roteador:** `http://192.168.0.1`
2. **Ir em:** VPN → IPsec
3. **Clicar em:** Add (ou Add New)
4. **Preencher:**
   - **Connection Name:** `proton-vpn-ipsec`
   - **Remote Gateway:** Servidor Proton VPN
   - **Authentication Method:** Pre-shared Key ou Certificate
   - **Pre-shared Key:** Chave do Proton VPN
   - **Local ID:** Seu usuário Proton VPN
   - **Remote ID:** ID do servidor (geralmente o mesmo do servidor)
   - **Phase 1/Phase 2:** Configurações de criptografia (verificar documentação Proton VPN)

5. **Salvar e Ativar**

---

## 📊 COMPARAÇÃO DAS OPÇÕES

| Opção | Velocidade | Segurança | Facilidade | Recomendação |
|-------|------------|-----------|------------|--------------|
| **Wireguard** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐ **MELHOR** |
| **OpenVPN** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ **RECOMENDADO** |
| **IPsec** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | 🟡 Alternativa |
| **L2TP** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⚠️ Menos seguro |
| **PPTP** | ⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐⭐ | ❌ Não recomendado |

---

## ✅ RECOMENDAÇÃO FINAL

### **Ordem de Preferência:**

1. ⭐ **Wireguard** - Se disponível no Proton VPN (melhor performance)
2. ✅ **OpenVPN** - Se Wireguard não disponível (mais comum, funciona bem)
3. 🟡 **IPsec** - Alternativa se OpenVPN não funcionar

### **Não Recomendado:**
- ❌ **PPTP** - Inseguro, não usar
- ⚠️ **L2TP** - Menos seguro que OpenVPN/Wireguard

---

## 🔧 PASSOS PRÁTICOS RECOMENDADOS

### **Para seu caso (Proton VPN + Roteador TL-ER605):**

#### **1. Verificar Suporte Wireguard:**
- Acessar: https://account.protonvpn.com/downloads
- Verificar se há arquivo Wireguard (`.conf`)
- **Se SIM:** Usar Wireguard (Opção 1)
- **Se NÃO:** Usar OpenVPN (Opção 2)

#### **2. Configurar no Roteador:**
- Acessar: `http://192.168.0.1`
- Ir em: VPN → [Wireguard ou OpenVPN]
- Seguir passos de configuração acima

#### **3. Verificar Conexão:**
```powershell
# Verificar IP público (deve ser IP do Proton VPN)
Invoke-RestMethod -Uri "https://api.ipify.org?format=json"
```

#### **4. Testar Performance:**
- Desativar VPN no PC
- Testar Cursor (deve funcionar normalmente)
- Verificar que não há degradação

---

## 📋 CHECKLIST DE CONFIGURAÇÃO

### **Preparação:**
- [ ] Acessar https://account.protonvpn.com/downloads
- [ ] Verificar se Wireguard está disponível
- [ ] Baixar arquivo de configuração (Wireguard ou OpenVPN)
- [ ] Ter credenciais Proton VPN (usuário e senha)

### **Configuração no Roteador:**
- [ ] Acessar `http://192.168.0.1`
- [ ] Fazer login no roteador
- [ ] Ir em VPN → [Wireguard ou OpenVPN]
- [ ] Adicionar nova configuração VPN
- [ ] Preencher todos os campos necessários
- [ ] Fazer upload de certificados (se OpenVPN)
- [ ] Salvar configuração
- [ ] Ativar VPN

### **Verificação:**
- [ ] Verificar status: "Connected"
- [ ] Testar IP público (deve ser IP do Proton VPN)
- [ ] Desativar VPN no PC
- [ ] Testar Cursor (deve funcionar normalmente)
- [ ] Verificar performance (sem degradação)

---

## 🔍 TROUBLESHOOTING

### **Problema: VPN não conecta**

**Soluções:**
1. **Verificar credenciais:** Usuário e senha corretos
2. **Verificar servidor:** Servidor Proton VPN está online
3. **Verificar porta:** Porta correta (1194 UDP para OpenVPN)
4. **Verificar firewall:** Firewall do roteador não está bloqueando
5. **Verificar certificados:** Certificados corretos (se OpenVPN)

### **Problema: Conexão lenta**

**Soluções:**
1. **Tentar servidor diferente:** Outro servidor Proton VPN
2. **Tentar protocolo diferente:** Wireguard em vez de OpenVPN
3. **Verificar MTU:** Ajustar MTU se necessário
4. **Verificar carga do servidor:** Servidor pode estar sobrecarregado

### **Problema: Não consigo acessar roteador após configurar VPN**

**Soluções:**
1. **Acessar via IP local:** `http://192.168.0.1` (não via VPN)
2. **Desativar VPN temporariamente:** Para acessar interface
3. **Verificar roteamento:** VPN pode estar redirecionando todo tráfego

---

## ✅ CONCLUSÃO

### **Recomendação Específica:**
1. ⭐ **Tentar Wireguard primeiro** (se disponível no Proton VPN)
2. ✅ **Usar OpenVPN** (se Wireguard não disponível)
3. 🟡 **IPsec como alternativa** (se necessário)

### **Resultado Esperado:**
- ✅ **VPN ativo no roteador** = Toda a rede protegida
- ✅ **PC sem VPN** = Cursor funciona normalmente
- ✅ **Performance preservada** = Sem degradação
- ✅ **Proteção completa** = Via roteador

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 21:25  
**Status:** ✅ **GUIA ESPECÍFICO** - Configuração Proton VPN no TL-ER605


