# Guia: Proteção usando Roteador TP-Link TL-ER605

**Data:** 24/11/2025  
**Roteador:** TP-Link Load Balance Router Multi-WAN VPN TL-ER605  
**Objetivo:** Proteger toda a rede sem impactar performance do Cursor  
**Vantagem:** VPN no roteador, não no PC

---

## 📋 RESUMO EXECUTIVO

### **Vantagem do Roteador:**
- ✅ **VPN no roteador** = Proteção para toda a rede
- ✅ **Sem impacto no PC** = Cursor não é afetado
- ✅ **Multi-WAN** = Balanceamento de carga e redundância
- ✅ **Firewall integrado** = Proteção adicional

### **Solução Ideal:**
Configurar VPN no roteador TL-ER605 para proteger toda a rede, enquanto o Cursor no PC funciona sem VPN (sem degradação de performance).

---

## 🎯 CONFIGURAÇÃO RECOMENDADA

### **Estratégia: VPN no Roteador, Não no PC**

#### **Arquitetura:**
```
Internet → Roteador TL-ER605 (com VPN) → Rede Local → PC (sem VPN) → Cursor (performance normal)
```

**Vantagens:**
- ✅ **Toda a rede protegida** via VPN do roteador
- ✅ **PC não precisa de VPN** = Cursor funciona normalmente
- ✅ **Performance preservada** = Sem degradação
- ✅ **Proteção transparente** = Automática para todos os dispositivos

---

## 🔧 1. CONFIGURAÇÃO DE VPN NO ROTEADOR

### **Opção A: VPN Client (Recomendado para Proton VPN)**

#### **Configurar Proton VPN no Roteador:**

1. **Acessar Interface Web:**
   - IP padrão: `192.168.1.1` ou `192.168.0.1`
   - Login: `admin` / Senha: (verificar manual do roteador)

2. **Ir em VPN → VPN Client:**
   - Clicar em "Add" para adicionar nova VPN
   - Selecionar tipo: **OpenVPN** (Proton VPN suporta)

3. **Configurar OpenVPN:**
   - **Server Address:** Servidor Proton VPN (São Paulo)
   - **Port:** 1194 (UDP) ou 443 (TCP)
   - **Protocol:** UDP (recomendado) ou TCP
   - **Username:** Seu usuário Proton VPN
   - **Password:** Sua senha Proton VPN
   - **Upload Config File:** Fazer upload do arquivo `.ovpn` do Proton VPN

4. **Salvar e Ativar:**
   - Salvar configuração
   - Ativar VPN Client
   - Verificar status de conexão

#### **Arquivo de Configuração Proton VPN:**
- Baixar arquivo `.ovpn` do Proton VPN
- Fazer upload no roteador
- Configurar credenciais

---

### **Opção B: VPN Server (Criar sua própria VPN)**

#### **Configurar VPN Server no Roteador:**

1. **Ir em VPN → VPN Server:**
   - Selecionar tipo: **PPTP**, **L2TP**, ou **IPSec**
   - **PPTP:** Mais simples, menos seguro
   - **L2TP/IPSec:** Mais seguro, recomendado

2. **Configurar L2TP/IPSec:**
   - **Server IP:** IP do roteador (ex: 192.168.1.1)
   - **Pre-shared Key:** Gerar chave forte
   - **Username/Password:** Criar credenciais
   - **Ativar:** Marcar como ativo

3. **Configurar Port Forwarding (se necessário):**
   - Porta 1701 (L2TP)
   - Porta 500 (IPSec)
   - Porta 4500 (IPSec NAT-T)

---

## 🌐 2. CONFIGURAÇÃO MULTI-WAN

### **Balanceamento de Carga:**

#### **Configurar Múltiplas WANs:**

1. **Ir em Network → WAN:**
   - **WAN1:** Configurar primeira conexão
   - **WAN2:** Configurar segunda conexão (se disponível)

2. **Modo de Balanceamento:**
   - **Load Balance:** Distribui tráfego entre WANs
   - **Backup:** WAN2 como backup de WAN1
   - **Intelligent Routing:** Roteamento inteligente

3. **Configuração Recomendada:**
   - **Modo:** Load Balance (se tiver 2 conexões)
   - **Ratio:** 1:1 (distribuição igual)
   - **Health Check:** Ativado (verifica se WAN está online)

**Vantagens:**
- ✅ **Redundância:** Se uma WAN cair, outra assume
- ✅ **Performance:** Distribui carga entre conexões
- ✅ **Confiabilidade:** Maior disponibilidade

---

## 🔥 3. FIREWALL E PROTEÇÃO

### **Firewall Integrado:**

#### **Configurar Regras de Firewall:**

1. **Ir em Security → Firewall:**
   - **Firewall:** Ativar
   - **DoS Protection:** Ativar (proteção contra ataques)
   - **SPI Firewall:** Ativar (Stateful Packet Inspection)

2. **Regras de Firewall:**
   - **Bloquear entrada:** Por padrão, bloquear todas as conexões de entrada
   - **Permitir saída:** Permitir conexões de saída
   - **Port Forwarding:** Configurar apenas portas necessárias

3. **Proteção Adicional:**
   - **MAC Filtering:** Filtrar dispositivos por MAC address
   - **URL Filtering:** Bloquear sites maliciosos
   - **Access Control:** Controlar acesso por horário/dispositivo

---

## 🎯 4. CONFIGURAÇÃO ESPECÍFICA PARA SEU CASO

### **Solução Ideal: VPN no Roteador + PC sem VPN**

#### **Configuração Recomendada:**

1. **Roteador:**
   - ✅ **VPN Client ativo** (Proton VPN ou outro)
   - ✅ **Toda a rede protegida** via VPN do roteador
   - ✅ **Firewall ativo** com regras de segurança

2. **PC (seu computador):**
   - ✅ **Sem VPN instalado** (ou desativado)
   - ✅ **Cursor funciona normalmente** (sem degradação)
   - ✅ **Proteção via roteador** (transparente)

3. **Resultado:**
   - ✅ **Proteção completa** da rede
   - ✅ **Performance do Cursor preservada**
   - ✅ **Sem impacto** na velocidade

---

## 🔧 5. PASSOS DE CONFIGURAÇÃO

### **Passo 1: Acessar Interface do Roteador**

```powershell
# Método 1: Usando findstr (mais confiável)
ipconfig | findstr /i "gateway"

# Método 2: Usando Get-NetRoute (PowerShell)
Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1 | Select-Object -ExpandProperty NextHop

# Método 3: Usando Get-NetIPConfiguration (PowerShell)
(Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway}).IPv4DefaultGateway.NextHop
```

**IP do seu roteador:** `192.168.0.1`

**Acessar no navegador:**
- `http://192.168.0.1` (seu roteador)
- Login: `admin` / Senha: (verificar manual do roteador)

---

### **Passo 2: Configurar VPN Client (Proton VPN)**

1. **Baixar Configuração Proton VPN:**
   - Acessar: https://account.protonvpn.com/downloads
   - Baixar arquivo `.ovpn` para servidor São Paulo

2. **No Roteador:**
   - Ir em **VPN → VPN Client → Add**
   - Selecionar **OpenVPN**
   - Fazer upload do arquivo `.ovpn`
   - Inserir **Username** e **Password** do Proton VPN
   - Salvar e ativar

3. **Verificar Conexão:**
   - Status deve mostrar "Connected"
   - Verificar IP público mudou (testar em whatismyip.com)

---

### **Passo 3: Configurar Firewall**

1. **Ir em Security → Firewall:**
   - Ativar **Firewall**
   - Ativar **DoS Protection**
   - Ativar **SPI Firewall**

2. **Regras Básicas:**
   - Bloquear todas as conexões de entrada (padrão)
   - Permitir conexões de saída
   - Configurar port forwarding apenas se necessário

---

### **Passo 4: Configurar DNS Seguro (Opcional)**

1. **Ir em Network → LAN → DHCP:**
   - **Primary DNS:** `1.1.1.1` (Cloudflare)
   - **Secondary DNS:** `1.0.0.1` (Cloudflare)
   - Ou usar `9.9.9.9` (Quad9)

2. **Aplicar:**
   - Salvar configuração
   - Dispositivos receberão DNS seguro automaticamente

---

## 📊 6. COMPARAÇÃO: VPN NO PC vs VPN NO ROTEADOR

| Aspecto | VPN no PC | VPN no Roteador |
|---------|-----------|-----------------|
| **Performance Cursor** | ❌ Degrada 83% | ✅ Sem impacto |
| **Proteção** | ✅ Apenas PC | ✅ Toda a rede |
| **Configuração** | 🟡 Por dispositivo | ✅ Uma vez no roteador |
| **Manutenção** | 🟡 Por dispositivo | ✅ Centralizada |
| **Custo** | 💰 Por dispositivo | ✅ Um roteador |

---

## ✅ 7. VANTAGENS DA SOLUÇÃO

### **Para seu caso específico:**

1. **Performance do Cursor:**
   - ✅ **Sem degradação** - PC não usa VPN
   - ✅ **Velocidade normal** - Sem impacto
   - ✅ **Latência baixa** - Conexão direta

2. **Proteção:**
   - ✅ **Toda a rede protegida** - Via roteador
   - ✅ **Transparente** - Automático para todos
   - ✅ **Firewall integrado** - Proteção adicional

3. **Conveniência:**
   - ✅ **Uma configuração** - No roteador
   - ✅ **Todos os dispositivos** - Protegidos automaticamente
   - ✅ **Manutenção simples** - Centralizada

---

## 🔍 8. VERIFICAÇÃO E TESTES

### **Testar Configuração:**

#### **1. Verificar VPN no Roteador:**
```powershell
# Verificar IP público (deve ser IP do Proton VPN)
Invoke-RestMethod -Uri "https://api.ipify.org?format=json"
```

#### **2. Testar Performance do Cursor:**
- Abrir Cursor
- Fazer pergunta ao AI
- Medir tempo de resposta
- Deve ser normal (sem degradação)

#### **3. Verificar Proteção:**
- Acessar whatismyip.com
- IP deve ser do Proton VPN (não seu IP real)
- Testar acesso a sites bloqueados (se configurado)

---

## 🎯 9. CONFIGURAÇÃO RECOMENDADA FINAL

### **Para seu caso (Desenvolvimento com Cursor):**

#### **Roteador TL-ER605:**
1. ✅ **VPN Client ativo** (Proton VPN - servidor São Paulo)
2. ✅ **Firewall ativo** com proteção DoS
3. ✅ **DNS seguro** (1.1.1.1 ou 9.9.9.9)
4. ✅ **Multi-WAN configurado** (se tiver múltiplas conexões)

#### **PC (seu computador):**
1. ✅ **Sem VPN instalado** (ou desativado)
2. ✅ **Windows Firewall ativo** (proteção local)
3. ✅ **Windows Defender ativo** (antivírus)
4. ✅ **Cursor funciona normalmente** (sem degradação)

#### **Resultado:**
- ✅ **Proteção completa** via roteador
- ✅ **Performance preservada** no Cursor
- ✅ **Melhor dos dois mundos**

---

## 📋 10. CHECKLIST DE CONFIGURAÇÃO

### **Roteador TL-ER605:**
- [ ] Acessar interface web do roteador
- [ ] Configurar VPN Client (Proton VPN)
- [ ] Verificar conexão VPN ativa
- [ ] Configurar Firewall (ativar proteção)
- [ ] Configurar DNS seguro (opcional)
- [ ] Configurar Multi-WAN (se aplicável)
- [ ] Testar IP público (deve ser IP do VPN)

### **PC:**
- [ ] Desativar/remover VPN do PC
- [ ] Verificar Windows Firewall ativo
- [ ] Verificar Windows Defender ativo
- [ ] Testar Cursor (deve funcionar normalmente)
- [ ] Verificar performance (sem degradação)

---

## 🔗 11. RECURSOS E DOCUMENTAÇÃO

### **TP-Link TL-ER605:**
- **Manual:** Disponível no site da TP-Link
- **Firmware:** Atualizar para versão mais recente
- **Suporte:** https://www.tp-link.com/support/

### **Proton VPN:**
- **Configuração OpenVPN:** https://account.protonvpn.com/downloads
- **Guia de Configuração:** Documentação do Proton VPN
- **Servidores:** Lista de servidores disponíveis

---

## ✅ CONCLUSÃO

### **Solução Ideal:**
✅ **VPN no roteador TL-ER605** = Proteção para toda a rede  
✅ **PC sem VPN** = Cursor funciona com performance normal  
✅ **Melhor dos dois mundos** = Proteção + Performance

### **Vantagens:**
1. ✅ **Performance preservada** - Cursor não é afetado
2. ✅ **Proteção completa** - Toda a rede protegida
3. ✅ **Configuração única** - No roteador, não no PC
4. ✅ **Transparente** - Funciona automaticamente

### **Próximos Passos:**
1. Acessar interface do roteador TL-ER605
2. Configurar VPN Client (Proton VPN)
3. Ativar Firewall e proteções
4. Desativar VPN no PC
5. Testar Cursor (deve funcionar normalmente)

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 21:20  
**Status:** ✅ **GUIA COMPLETO** - Configuração do Roteador TL-ER605

