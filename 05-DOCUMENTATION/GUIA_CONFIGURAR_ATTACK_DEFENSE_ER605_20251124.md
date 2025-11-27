# Guia: Configurar Attack Defense - Roteador TP-Link TL-ER605

**Data:** 24/11/2025  
**Roteador:** TP-Link TL-ER605  
**Funcionalidade:** Attack Defense (Proteção contra Ataques)  
**Objetivo:** Configurar proteções contra DDoS e outros ataques

---

## 📋 RESUMO EXECUTIVO

### **Configuração Recomendada:**
- ✅ **Flood Defense:** Ativar todos com valores padrão ou ajustados
- ✅ **Packet Anomaly Defense:** Ativar todas as opções
- ✅ **Security Option:** Ativar todas as opções de bloqueio

### **Valores Padrão (Bons):**
Os valores que você mostrou estão **bem configurados** e podem ser mantidos ou ajustados conforme necessário.

---

## 🔥 1. FLOOD DEFENSE

### **O que é:**
- ✅ **Proteção contra ataques de inundação** - DDoS e Flood attacks
- ✅ **Limita pacotes por segundo** - Previne sobrecarga
- ✅ **Protege servidores** - Mantém rede funcionando mesmo sob ataque

### **Configuração Recomendada:**

#### **Multi-connections (Múltiplas Conexões):**
- **TCP SYN Flood:** `10000` Pkt/s ✅ **BOM** (pode manter)
- **UDP Flood:** `12000` Pkt/s ✅ **BOM** (pode manter)
- **ICMP Flood:** `1500` Pkt/s ✅ **BOM** (pode manter)

**O que faz:**
- Detecta quando múltiplas conexões fazem muitos pacotes
- Bloqueia se exceder o limite configurado
- Protege contra ataques distribuídos (DDoS)

#### **Stationary source (Fonte Estacionária):**
- **TCP SYN Flood:** `4000` Pkt/s ✅ **BOM** (pode manter)
- **UDP Flood:** `6000` Pkt/s ✅ **BOM** (pode manter)
- **ICMP Flood:** `600` Pkt/s ✅ **BOM** (pode manter)

**O que faz:**
- Detecta quando uma única fonte faz muitos pacotes
- Bloqueia se exceder o limite configurado
- Protege contra ataques de fonte única

### **Valores Recomendados:**

#### **Para Rede Doméstica/Pequena (Recomendado):**
```
Multi-connections TCP SYN Flood:  10000 Pkt/s ✅
Multi-connections UDP Flood:      12000 Pkt/s ✅
Multi-connections ICMP Flood:     1500 Pkt/s ✅
Stationary source TCP SYN Flood:  4000 Pkt/s ✅
Stationary source UDP Flood:      6000 Pkt/s ✅
Stationary source ICMP Flood:    600 Pkt/s ✅
```

**Justificativa:**
- ✅ Valores altos o suficiente para uso normal
- ✅ Baixos o suficiente para bloquear ataques
- ✅ Não bloqueia tráfego legítimo
- ✅ Protege contra ataques reais

#### **Se Tiver Problemas (Ajustar):**
- **Aumentar valores** se tráfego legítimo for bloqueado
- **Diminuir valores** se quiser proteção mais agressiva
- **Monitorar logs** para ajustar conforme necessário

---

## 🛡️ 2. PACKET ANOMALY DEFENSE

### **O que é:**
- ✅ **Proteção contra pacotes anômalos** - Pacotes malformados ou suspeitos
- ✅ **Bloqueia varreduras** - Port scanning e reconhecimento
- ✅ **Protege contra exploits** - Ataques conhecidos

### **Configuração Recomendada (Ativar TODAS):**

#### **Block TCP Scan:**
- ✅ **Block TCP Scan (Stealth FIN/Xmas/Null):** **ATIVAR**
- ✅ **Block TCP Scan with RST:** **ATIVAR**

**O que faz:**
- Bloqueia tentativas de varredura de portas (port scanning)
- Previne reconhecimento de rede por hackers
- Protege contra tentativas de descobrir serviços

#### **Block Ping Attacks:**
- ✅ **Block Ping of Death:** **ATIVAR**
- ✅ **Block Large Ping:** **ATIVAR**
- ✅ **Block Ping from WAN:** **ATIVAR** (recomendado)

**O que faz:**
- **Ping of Death:** Bloqueia pings maliciosos que podem causar crash
- **Large Ping:** Bloqueia pings grandes (possível ataque)
- **Ping from WAN:** Bloqueia pings da internet (recomendado para segurança)

#### **Block Other Attacks:**
- ✅ **Block WinNuke attack:** **ATIVAR**
- ✅ **Block TCP packets with SYN and FIN Bits set:** **ATIVAR**
- ✅ **Block TCP packets with FIN Bit set but no ACK Bit set:** **ATIVAR**

**O que faz:**
- **WinNuke:** Bloqueia ataque específico do Windows
- **SYN+FIN:** Bloqueia pacotes TCP inválidos
- **FIN sem ACK:** Bloqueia pacotes TCP malformados

#### **Block packets with specified IP options:**
- ✅ **Block packets with specified IP options:** **ATIVAR**
- ✅ **Security Option:** **ATIVAR**
- ✅ **Record Route Option:** **ATIVAR**
- ✅ **Stream Option:** **ATIVAR**
- ✅ **Timestamp Option:** **ATIVAR**
- ✅ **No Operation Option:** **ATIVAR**

**O que faz:**
- Bloqueia pacotes com opções IP suspeitas
- Previne uso de opções IP para ataques
- Segurança adicional contra pacotes maliciosos

---

## ✅ CONFIGURAÇÃO RECOMENDADA COMPLETA

### **Flood Defense (Manter Valores Atuais):**

```
✅ Multi-connections TCP SYN Flood:  10000 Pkt/s
✅ Multi-connections UDP Flood:      12000 Pkt/s
✅ Multi-connections ICMP Flood:     1500 Pkt/s
✅ Stationary source TCP SYN Flood:  4000 Pkt/s
✅ Stationary source UDP Flood:      6000 Pkt/s
✅ Stationary source ICMP Flood:     600 Pkt/s
```

### **Packet Anomaly Defense (Ativar TODAS):**

```
✅ Block TCP Scan (Stealth FIN/Xmas/Null)
✅ Block TCP Scan with RST
✅ Block Ping of Death
✅ Block Large Ping
✅ Block Ping from WAN
✅ Block WinNuke attack
✅ Block TCP packets with SYN and FIN Bits set
✅ Block TCP packets with FIN Bit set but no ACK Bit set
✅ Block packets with specified IP options
   ✅ Security Option
   ✅ Record Route Option
   ✅ Stream Option
   ✅ Timestamp Option
   ✅ No Operation Option
```

---

## 📊 EXPLICAÇÃO DETALHADA

### **Flood Defense - Multi-connections vs Stationary source:**

#### **Multi-connections (Múltiplas Conexões):**
- **Detecta:** Quando múltiplos IPs fazem muitos pacotes
- **Protege contra:** DDoS (Distributed Denial of Service)
- **Exemplo:** 1000 computadores fazendo 10 pacotes cada = 10000 pacotes
- **Valores mais altos:** Permite mais tráfego legítimo

#### **Stationary source (Fonte Estacionária):**
- **Detecta:** Quando um único IP faz muitos pacotes
- **Protege contra:** Ataques de fonte única
- **Exemplo:** Um computador fazendo 4000 pacotes TCP SYN
- **Valores mais baixos:** Mais restritivo para fonte única

### **Por que valores diferentes:**
- **Multi-connections:** Valores mais altos (10000-15000) porque tráfego legítimo pode vir de múltiplas fontes
- **Stationary source:** Valores mais baixos (600-6000) porque uma única fonte não deveria fazer tantos pacotes

---

## 🎯 CONFIGURAÇÃO PARA SEU CASO

### **Recomendação Final:**

#### **Flood Defense:**
- ✅ **Manter valores atuais** - Estão bem configurados
- ✅ **Não alterar** a menos que tenha problemas específicos

#### **Packet Anomaly Defense:**
- ✅ **Ativar TODAS as opções** - Máxima proteção
- ✅ **Especialmente importante:**
  - Block Ping from WAN (bloqueia pings da internet)
  - Block TCP Scan (bloqueia varredura de portas)
  - Block Ping of Death (bloqueia pings maliciosos)

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **Block Ping from WAN:**
- ✅ **Recomendado ATIVAR** - Bloqueia pings da internet
- ✅ **Segurança adicional** - Previne reconhecimento de rede
- ⚠️ **Não afeta ping local** - Ping dentro da rede continua funcionando
- ✅ **Boa prática** - Esconder rede da internet

### **Valores de Flood Defense:**
- ✅ **Valores atuais estão bons** - Não precisa alterar
- ⚠️ **Se tiver problemas:** Aumentar valores (pode estar bloqueando tráfego legítimo)
- ⚠️ **Se quiser mais proteção:** Diminuir valores (mais restritivo)

---

## 📋 CHECKLIST DE CONFIGURAÇÃO

### **Flood Defense:**
- [x] Multi-connections TCP SYN Flood: 10000 Pkt/s ✅
- [x] Multi-connections UDP Flood: 12000 Pkt/s ✅
- [x] Multi-connections ICMP Flood: 1500 Pkt/s ✅
- [x] Stationary source TCP SYN Flood: 4000 Pkt/s ✅
- [x] Stationary source UDP Flood: 6000 Pkt/s ✅
- [x] Stationary source ICMP Flood: 600 Pkt/s ✅

### **Packet Anomaly Defense:**
- [ ] Block TCP Scan (Stealth FIN/Xmas/Null) - ATIVAR
- [ ] Block TCP Scan with RST - ATIVAR
- [ ] Block Ping of Death - ATIVAR
- [ ] Block Large Ping - ATIVAR
- [ ] Block Ping from WAN - ATIVAR ⭐ **IMPORTANTE**
- [ ] Block WinNuke attack - ATIVAR
- [ ] Block TCP packets with SYN and FIN Bits set - ATIVAR
- [ ] Block TCP packets with FIN Bit set but no ACK Bit set - ATIVAR
- [ ] Block packets with specified IP options - ATIVAR
  - [ ] Security Option - ATIVAR
  - [ ] Record Route Option - ATIVAR
  - [ ] Stream Option - ATIVAR
  - [ ] Timestamp Option - ATIVAR
  - [ ] No Operation Option - ATIVAR

### **Salvar:**
- [ ] Clicar em "Save" para salvar todas as configurações

---

## ✅ CONCLUSÃO

### **Configuração Atual:**
✅ **Flood Defense está bem configurado** - Valores estão adequados

### **Ação Necessária:**
✅ **Ativar todas as opções de Packet Anomaly Defense**

### **Recomendação:**
1. ✅ **Manter valores de Flood Defense** como estão
2. ✅ **Ativar TODAS as opções de Packet Anomaly Defense**
3. ✅ **Especialmente:** Block Ping from WAN (muito importante)
4. ✅ **Salvar configuração**

### **Resultado:**
- ✅ **Proteção contra DDoS** - Flood Defense ativo
- ✅ **Proteção contra port scanning** - TCP Scan bloqueado
- ✅ **Proteção contra ping attacks** - Ping attacks bloqueados
- ✅ **Proteção contra pacotes anômalos** - Pacotes maliciosos bloqueados
- ✅ **Máxima proteção** - Todas as defesas ativas

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 21:45  
**Status:** ✅ **GUIA PRÁTICO** - Configuração Attack Defense


