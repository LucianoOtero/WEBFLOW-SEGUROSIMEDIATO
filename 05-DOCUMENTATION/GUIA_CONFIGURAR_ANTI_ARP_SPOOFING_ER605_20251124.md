# Guia: Configurar Anti ARP Spoofing - Roteador TP-Link TL-ER605

**Data:** 24/11/2025  
**Roteador:** TP-Link TL-ER605  
**Funcionalidade:** Anti ARP Spoofing Defense  
**Objetivo:** Proteger contra ataques ARP Spoofing e Man-in-the-Middle

---

## 📋 RESUMO EXECUTIVO

### **Configuração Recomendada:**
- ✅ **Enable ARP Spoofing Defense:** Ativar
- ✅ **Permit the packets matching the IP-MAC Binding entries only:** Ativar (mais seguro)
- ✅ **Send GARP packets when ARP attack is detected:** Ativar
- ✅ **Interval:** 1000ms (padrão está bom)
- ✅ **IP-MAC Binding List:** Adicionar dispositivos conhecidos

### **Nível de Segurança:**
- **Alto:** Ativar todas as opções + IP-MAC Binding completo
- **Médio:** Ativar apenas ARP Spoofing Defense (sem binding)
- **Baixo:** Desativado (não recomendado)

---

## 🔧 CONFIGURAÇÃO PASSO A PASSO

### **Passo 1: Configurações Gerais**

#### **1.1 Enable ARP Spoofing Defense:**
- ✅ **ATIVAR** - Marcar checkbox
- **O que faz:** Ativa a proteção contra ARP Spoofing

#### **1.2 Permit the packets matching the IP-MAC Binding entries only:**
- ✅ **ATIVAR** - Marcar checkbox (recomendado para máxima segurança)
- **O que faz:** Apenas permite pacotes de dispositivos na lista IP-MAC Binding
- **Vantagem:** Máxima segurança - bloqueia dispositivos não autorizados
- **Desvantagem:** Precisa adicionar todos os dispositivos na lista

#### **1.3 Send GARP packets when ARP attack is detected:**
- ✅ **ATIVAR** - Marcar checkbox
- **O que faz:** Envia pacotes GARP (Gratuitous ARP) quando detecta ataque
- **Vantagem:** Notifica outros dispositivos sobre o ataque

#### **1.4 Interval:**
- **Valor:** `1000` ms (padrão está bom)
- **O que faz:** Intervalo de verificação de ataques ARP
- **Recomendação:** Manter 1000ms (1 segundo)

#### **1.5 Interface:**
- **Selecionar:** Interface da rede (geralmente LAN ou todas)
- **Recomendação:** Selecionar todas as interfaces ou LAN principal

---

### **Passo 2: IP-MAC Binding List**

#### **O que é IP-MAC Binding:**
- **Vincula IPs a MACs** - Cada dispositivo tem IP e MAC fixos
- **Previne spoofing** - Dispositivos não podem falsificar IPs
- **Segurança adicional** - Apenas dispositivos conhecidos podem usar IPs específicos

#### **Como Adicionar Dispositivos:**

##### **2.1 Descobrir MAC Address do PC:**

**No Windows (PowerShell):**
```powershell
# Descobrir MAC do PC atual
Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Select-Object Name, MacAddress, InterfaceDescription

# Ou mais simples:
ipconfig /all | findstr /i "physical"
```

**Resultado esperado:**
```
Physical Address. . . . . . . . . : XX-XX-XX-XX-XX-XX
```

##### **2.2 Descobrir IP do PC:**
```powershell
# Descobrir IP do PC
ipconfig | findstr /i "IPv4"

# Ou:
Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like "192.168.*"} | Select-Object IPAddress
```

**Resultado esperado:**
```
IPv4 Address. . . . . . . . . . . : 192.168.0.101
```

##### **2.3 Adicionar no Roteador:**
1. **Clicar em:** "Add" na seção "IP-MAC Binding List"
2. **Preencher:**
   - **IP Address:** IP do dispositivo (ex: `192.168.0.101`)
   - **MAC Address:** MAC do dispositivo (ex: `XX-XX-XX-XX-XX-XX`)
   - **Interface:** Selecionar interface (geralmente LAN)
   - **Description:** Nome descritivo (ex: "PC Desenvolvimento")
3. **Salvar**

##### **2.4 Adicionar Outros Dispositivos:**
- **Repetir processo** para cada dispositivo na rede
- **Celulares, tablets, outros PCs, etc.**
- **Ou adicionar conforme necessário** (modo menos restritivo)

---

## 🎯 CONFIGURAÇÃO RECOMENDADA

### **Opção A: Máxima Segurança (Recomendado para Redes Pequenas)**

#### **Configuração:**
- ✅ **Enable ARP Spoofing Defense:** Ativar
- ✅ **Permit the packets matching the IP-MAC Binding entries only:** Ativar
- ✅ **Send GARP packets when ARP attack is detected:** Ativar
- ✅ **Interval:** 1000ms
- ✅ **IP-MAC Binding List:** Adicionar TODOS os dispositivos conhecidos

#### **Vantagens:**
- ✅ **Máxima segurança** - Apenas dispositivos conhecidos
- ✅ **Proteção total** - Bloqueia dispositivos não autorizados
- ✅ **Previne spoofing** - Dispositivos não podem falsificar IPs

#### **Desvantagens:**
- ⚠️ **Mais trabalho** - Precisa adicionar todos os dispositivos
- ⚠️ **Menos flexível** - Novos dispositivos precisam ser adicionados manualmente

---

### **Opção B: Segurança Moderada (Recomendado para Redes Médias/Grandes)**

#### **Configuração:**
- ✅ **Enable ARP Spoofing Defense:** Ativar
- ❌ **Permit the packets matching the IP-MAC Binding entries only:** Desativar
- ✅ **Send GARP packets when ARP attack is detected:** Ativar
- ✅ **Interval:** 1000ms
- ✅ **IP-MAC Binding List:** Adicionar apenas dispositivos críticos (servidores, PCs importantes)

#### **Vantagens:**
- ✅ **Boa segurança** - Protege contra ARP Spoofing
- ✅ **Mais flexível** - Novos dispositivos podem conectar facilmente
- ✅ **Menos manutenção** - Não precisa adicionar todos os dispositivos

#### **Desvantagens:**
- ⚠️ **Menos restritivo** - Dispositivos não autorizados podem conectar (mas não podem fazer spoofing)

---

## 📋 CHECKLIST DE CONFIGURAÇÃO

### **Configurações Gerais:**
- [ ] Ativar "Enable ARP Spoofing Defense"
- [ ] Decidir: Ativar "Permit the packets matching the IP-MAC Binding entries only"?
  - [ ] SIM (máxima segurança) - Adicionar todos os dispositivos
  - [ ] NÃO (segurança moderada) - Mais flexível
- [ ] Ativar "Send GARP packets when ARP attack is detected"
- [ ] Verificar Interval: 1000ms (ou manter padrão)
- [ ] Selecionar Interface (LAN ou todas)

### **IP-MAC Binding List:**
- [ ] Descobrir MAC Address do PC principal
- [ ] Descobrir IP do PC principal
- [ ] Adicionar PC principal na lista
- [ ] Adicionar outros dispositivos importantes (se modo máximo)
- [ ] Adicionar servidores (se houver)
- [ ] Salvar todas as entradas

### **Verificação:**
- [ ] Salvar configuração
- [ ] Verificar que proteção está ativa
- [ ] Testar acesso à internet (deve funcionar)
- [ ] Verificar que dispositivos autorizados funcionam

---

## 🔍 O QUE CADA OPÇÃO FAZ

### **Enable ARP Spoofing Defense:**
- **O que faz:** Ativa detecção e bloqueio de ataques ARP Spoofing
- **Proteção:** Previne que hackers se façam passar pelo roteador
- **Recomendação:** ✅ **SEMPRE ATIVAR**

### **Permit the packets matching the IP-MAC Binding entries only:**
- **O que faz:** Apenas permite pacotes de dispositivos na lista IP-MAC Binding
- **Proteção:** Máxima - bloqueia dispositivos não autorizados
- **Recomendação:** 
  - ✅ **ATIVAR** se rede pequena/controlada
  - 🟡 **DESATIVAR** se rede grande/com muitos dispositivos

### **Send GARP packets when ARP attack is detected:**
- **O que faz:** Envia notificações quando detecta ataque ARP
- **Proteção:** Notifica outros dispositivos sobre o ataque
- **Recomendação:** ✅ **ATIVAR**

### **Interval:**
- **O que faz:** Intervalo de verificação de ataques
- **Valor:** 1000ms (1 segundo) - padrão está bom
- **Recomendação:** ✅ **MANTER 1000ms**

---

## ✅ CONFIGURAÇÃO RECOMENDADA PARA SEU CASO

### **Para Rede de Desenvolvimento (Poucos Dispositivos):**

#### **Configuração Ideal:**
1. ✅ **Enable ARP Spoofing Defense:** Ativar
2. ✅ **Permit the packets matching the IP-MAC Binding entries only:** Ativar (máxima segurança)
3. ✅ **Send GARP packets when ARP attack is detected:** Ativar
4. ✅ **Interval:** 1000ms
5. ✅ **IP-MAC Binding List:** Adicionar:
   - Seu PC principal (desenvolvimento)
   - Outros PCs na rede
   - Dispositivos importantes

#### **Resultado:**
- ✅ **Máxima proteção** contra ARP Spoofing
- ✅ **Apenas dispositivos conhecidos** podem usar IPs específicos
- ✅ **Previne ataques MITM** (Man-in-the-Middle)
- ✅ **Segurança adicional** na rede local

---

## 🎯 RESUMO RÁPIDO

### **Configuração Mínima (Boa Proteção):**
- ✅ Ativar "Enable ARP Spoofing Defense"
- ✅ Ativar "Send GARP packets when ARP attack is detected"
- ❌ Desativar "Permit the packets matching..." (mais flexível)
- ✅ Interval: 1000ms

### **Configuração Máxima (Excelente Proteção):**
- ✅ Ativar "Enable ARP Spoofing Defense"
- ✅ Ativar "Permit the packets matching..." (máxima segurança)
- ✅ Ativar "Send GARP packets when ARP attack is detected"
- ✅ Interval: 1000ms
- ✅ Adicionar todos os dispositivos na lista IP-MAC Binding

---

## ✅ CONCLUSÃO

### **Recomendação:**
Para sua rede de desenvolvimento, recomendo **Configuração Máxima**:
1. ✅ Ativar todas as opções
2. ✅ Adicionar dispositivos conhecidos na lista IP-MAC Binding
3. ✅ Máxima proteção contra ARP Spoofing e MITM

### **Benefícios:**
- ✅ **Proteção contra MITM** - Ataques Man-in-the-Middle
- ✅ **Previne spoofing** - Dispositivos não podem falsificar IPs
- ✅ **Segurança adicional** - Camada extra de proteção
- ✅ **Sem impacto na performance** - Proteção transparente

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 21:35  
**Status:** ✅ **GUIA PRÁTICO** - Configuração Anti ARP Spoofing


