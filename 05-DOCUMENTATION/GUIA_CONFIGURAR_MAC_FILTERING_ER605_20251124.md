# Guia: Configurar MAC Filtering - Roteador TP-Link TL-ER605

**Data:** 24/11/2025  
**Roteador:** TP-Link TL-ER605  
**Funcionalidade:** MAC Filtering (Filtro de Endereços MAC)  
**Objetivo:** Controlar acesso à rede baseado em endereços MAC dos dispositivos

---

## 📋 RESUMO EXECUTIVO

### **O que é MAC Filtering:**
- ✅ **Controle de acesso** baseado no endereço MAC (identificador único do hardware)
- ✅ **Segurança adicional** - Permite ou bloqueia dispositivos específicos
- ✅ **Duas políticas:** Whitelist (permitir apenas listados) ou Blacklist (bloquear apenas listados)

### **Recomendação:**
- ✅ **Para máxima segurança:** Usar **Whitelist** (permitir apenas dispositivos conhecidos)
- ✅ **Para flexibilidade:** Usar **Blacklist** (bloquear apenas dispositivos suspeitos)
- ⚠️ **Cuidado:** Whitelist pode bloquear dispositivos legítimos se não estiverem na lista

---

## 🔐 1. O QUE É ENDEREÇO MAC

### **Definição:**
- **MAC Address** = Media Access Control Address
- **Identificador único** do hardware de rede (NIC - Network Interface Card)
- **Formato:** `XX:XX:XX:XX:XX:XX` (6 pares de caracteres hexadecimais)
- **Exemplo:** `00:1B:44:11:3A:B7`

### **Características:**
- ✅ **Único por dispositivo** - Cada placa de rede tem um MAC único
- ✅ **Não muda facilmente** - Pode ser alterado (MAC spoofing), mas não é comum
- ✅ **Identifica hardware** - Não identifica usuário, mas identifica dispositivo

---

## 🎯 2. POLÍTICAS DE MAC FILTERING

### **Opção 1: Whitelist (Lista Branca) - RECOMENDADO PARA MÁXIMA SEGURANÇA**

#### **Configuração:**
```
✅ Enable MAC Filtering: ATIVAR
✅ Política: "Allow packets with the MAC addresses listed below and deny the rest"
✅ Direction: ALL
```

#### **O que faz:**
- ✅ **Permite APENAS** dispositivos com MAC listados
- ❌ **Bloqueia TODOS** os outros dispositivos
- ✅ **Máxima segurança** - Apenas dispositivos conhecidos podem acessar

#### **Quando usar:**
- ✅ **Rede corporativa** - Apenas dispositivos autorizados
- ✅ **Rede doméstica pequena** - Apenas seus dispositivos
- ✅ **Máxima segurança** - Controle total sobre quem acessa

#### **Vantagens:**
- ✅ **Máxima segurança** - Apenas dispositivos conhecidos
- ✅ **Previne acesso não autorizado** - Mesmo com senha WiFi, dispositivo não autorizado não acessa
- ✅ **Controle total** - Você decide exatamente quem pode acessar

#### **Desvantagens:**
- ⚠️ **Menos flexível** - Novos dispositivos precisam ser adicionados manualmente
- ⚠️ **Manutenção** - Precisa adicionar cada novo dispositivo
- ⚠️ **Pode bloquear legítimos** - Se esquecer de adicionar, dispositivo legítimo fica bloqueado

---

### **Opção 2: Blacklist (Lista Negra) - RECOMENDADO PARA FLEXIBILIDADE**

#### **Configuração:**
```
✅ Enable MAC Filtering: ATIVAR
✅ Política: "Deny packets with the MAC addresses listed below and allow the rest"
✅ Direction: ALL
```

#### **O que faz:**
- ❌ **Bloqueia APENAS** dispositivos com MAC listados
- ✅ **Permite TODOS** os outros dispositivos
- ✅ **Flexibilidade** - Novos dispositivos podem acessar automaticamente

#### **Quando usar:**
- ✅ **Rede doméstica** - Muitos dispositivos (celulares, TVs, tablets)
- ✅ **Rede flexível** - Novos dispositivos frequentemente
- ✅ **Bloquear específicos** - Apenas dispositivos suspeitos ou não autorizados

#### **Vantagens:**
- ✅ **Flexível** - Novos dispositivos acessam automaticamente
- ✅ **Fácil manutenção** - Não precisa adicionar cada dispositivo
- ✅ **Boa para redes domésticas** - Muitos dispositivos diferentes

#### **Desvantagens:**
- ⚠️ **Menos seguro** - Qualquer dispositivo com senha WiFi pode acessar
- ⚠️ **Não previne acesso não autorizado** - Se alguém souber a senha WiFi, pode acessar

---

## 📊 3. COMPARAÇÃO DAS POLÍTICAS

| Característica | Whitelist (Permitir Listados) | Blacklist (Bloquear Listados) |
|----------------|-------------------------------|--------------------------------|
| **Segurança** | ⭐⭐⭐⭐⭐ Máxima | ⭐⭐⭐ Média |
| **Flexibilidade** | ⭐⭐ Baixa | ⭐⭐⭐⭐⭐ Alta |
| **Manutenção** | ⭐⭐ Requer adicionar cada dispositivo | ⭐⭐⭐⭐ Pouca manutenção |
| **Uso Recomendado** | Rede corporativa, máxima segurança | Rede doméstica, flexibilidade |
| **Novos Dispositivos** | ❌ Bloqueados até adicionar | ✅ Acessam automaticamente |
| **Dispositivos Não Listados** | ❌ Bloqueados | ✅ Permitidos |

---

## 🎯 4. RECOMENDAÇÃO PARA SEU CASO

### **Análise do Contexto:**
- ✅ **Rede doméstica** - Múltiplos dispositivos (PC, celulares, TVs, etc.)
- ✅ **Flexibilidade desejada** - Novos dispositivos podem aparecer
- ✅ **Segurança importante** - Mas não precisa ser extremamente restritiva

### **Recomendação:**
✅ **Usar Blacklist (Deny packets with the MAC addresses listed below and allow the rest)**

**Justificativa:**
- ✅ **Flexível** - Novos dispositivos podem acessar automaticamente
- ✅ **Boa segurança** - Pode bloquear dispositivos suspeitos
- ✅ **Fácil manutenção** - Não precisa adicionar cada dispositivo
- ✅ **Adequado para rede doméstica** - Muitos dispositivos diferentes

### **Alternativa (Se Quiser Máxima Segurança):**
✅ **Usar Whitelist (Allow packets with the MAC addresses listed below and deny the rest)**

**Quando usar:**
- ✅ Se quiser controle total sobre quem acessa
- ✅ Se tiver poucos dispositivos fixos
- ✅ Se segurança for prioridade máxima

---

## 📋 5. COMO CONFIGURAR

### **Passo 1: Decidir Política**
- ✅ **Blacklist** (recomendado para rede doméstica)
- ✅ **Whitelist** (se quiser máxima segurança)

### **Passo 2: Obter Endereços MAC dos Dispositivos**

#### **Opção A: Usar Script PowerShell (Recomendado)**
```powershell
# Executar script para descobrir MAC do PC
.\descobrir_mac_ip_pc.ps1
```

#### **Opção B: Manualmente**

**Windows:**
```powershell
Get-NetAdapter | Select-Object Name, MacAddress, InterfaceDescription
```

**Linux/Mac:**
```bash
ifconfig | grep -i "ether"
# ou
ip link show
```

**Android:**
- Configurações → Sobre o telefone → Status → Endereço MAC Wi-Fi

**iOS:**
- Configurações → Geral → Sobre → Endereço Wi-Fi

### **Passo 3: Configurar no Roteador**

#### **Para Blacklist (Recomendado):**
1. ✅ **Enable MAC Filtering:** ATIVAR
2. ✅ **Política:** "Deny packets with the MAC addresses listed below and allow the rest"
3. ✅ **Direction:** ALL
4. ✅ **Adicionar MACs** de dispositivos que deseja bloquear
5. ✅ **Save**

#### **Para Whitelist (Máxima Segurança):**
1. ✅ **Enable MAC Filtering:** ATIVAR
2. ✅ **Política:** "Allow packets with the MAC addresses listed below and deny the rest"
3. ✅ **Direction:** ALL
4. ✅ **Adicionar MACs** de TODOS os dispositivos que deseja permitir
5. ⚠️ **IMPORTANTE:** Adicionar TODOS os dispositivos legítimos (PC, celulares, TVs, etc.)
6. ✅ **Save**

---

## ⚠️ 6. CUIDADOS IMPORTANTES

### **Se Usar Whitelist:**
- ⚠️ **Adicionar TODOS os dispositivos legítimos** antes de ativar
- ⚠️ **Se esquecer um dispositivo** - Ele ficará bloqueado
- ⚠️ **Novos dispositivos** - Precisam ser adicionados manualmente
- ⚠️ **Testar antes** - Adicionar alguns dispositivos, ativar, testar, depois adicionar mais

### **Se Usar Blacklist:**
- ✅ **Mais seguro** - Apenas bloqueia dispositivos específicos
- ✅ **Flexível** - Novos dispositivos acessam automaticamente
- ⚠️ **Ainda precisa senha WiFi** - MAC Filtering não substitui senha WiFi

### **Direction: ALL:**
- ✅ **Recomendado:** ALL (ambas direções)
- ✅ **Bloqueia** tráfego de entrada E saída
- ✅ **Máxima proteção**

---

## 🔍 7. COMO DESCOBRIR MACs DOS DISPOSITIVOS

### **PC Windows (PowerShell):**
```powershell
Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object Name, MacAddress, InterfaceDescription
```

### **PC Windows (CMD):**
```cmd
ipconfig /all
# Procurar por "Endereço Físico" ou "Physical Address"
```

### **Roteador (Lista de Dispositivos Conectados):**
- Acessar interface do roteador
- Procurar por "Dispositivos Conectados" ou "DHCP Client List"
- Lista mostra MAC de todos os dispositivos conectados

### **Script Automático:**
- ✅ Usar `descobrir_mac_ip_pc.ps1` (já criado anteriormente)
- ✅ Mostra MAC e IP do PC atual

---

## 📋 8. CHECKLIST DE CONFIGURAÇÃO

### **Decisão Inicial:**
- [ ] Escolher política: Whitelist ou Blacklist
- [ ] **Recomendação:** Blacklist para rede doméstica

### **Preparação:**
- [ ] Obter MACs dos dispositivos (se usar Whitelist, obter TODOS)
- [ ] Listar dispositivos que deseja permitir/bloquear

### **Configuração no Roteador:**
- [ ] Enable MAC Filtering: **ATIVAR**
- [ ] Política: **Escolher** (Whitelist ou Blacklist)
- [ ] Direction: **ALL**
- [ ] Adicionar MACs na lista
- [ ] **Save**

### **Teste:**
- [ ] Testar acesso de dispositivos permitidos
- [ ] Testar bloqueio de dispositivos bloqueados
- [ ] Verificar se tudo funciona corretamente

---

## ✅ 9. CONFIGURAÇÃO RECOMENDADA FINAL

### **Para Rede Doméstica (Recomendado):**

```
✅ Enable MAC Filtering: ATIVAR
✅ Política: "Deny packets with the MAC addresses listed below and allow the rest" (Blacklist)
✅ Direction: ALL
✅ Lista: Adicionar apenas MACs de dispositivos suspeitos ou não autorizados
✅ Save
```

### **Para Máxima Segurança:**

```
✅ Enable MAC Filtering: ATIVAR
✅ Política: "Allow packets with the MAC addresses listed below and deny the rest" (Whitelist)
✅ Direction: ALL
✅ Lista: Adicionar MACs de TODOS os dispositivos legítimos (PC, celulares, TVs, tablets, etc.)
⚠️ IMPORTANTE: Adicionar TODOS antes de ativar
✅ Save
```

---

## 🎯 10. CONCLUSÃO

### **Recomendação Principal:**
✅ **Usar Blacklist** para rede doméstica
- ✅ Flexível e fácil de manter
- ✅ Boa segurança sem complicar
- ✅ Novos dispositivos acessam automaticamente

### **Alternativa:**
✅ **Usar Whitelist** se quiser máxima segurança
- ✅ Controle total sobre acesso
- ⚠️ Requer adicionar cada dispositivo
- ⚠️ Menos flexível

### **Próximos Passos:**
1. ✅ Decidir política (Blacklist recomendado)
2. ✅ Obter MACs dos dispositivos (se necessário)
3. ✅ Configurar no roteador
4. ✅ Testar funcionamento
5. ✅ Salvar configuração

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 22:00  
**Status:** ✅ **GUIA PRÁTICO** - Configuração MAC Filtering


