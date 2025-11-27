# 🔧 GUIA: Atualizar Firewall para UptimeRobot via Hetzner Cloud Console

**Data:** 24/11/2025  
**Versão:** 1.0.0  
**Método:** Via Console Web do Hetzner (Mais Fácil)

---

## 📋 SUMÁRIO

### **Método Recomendado:**
✅ **Via Hetzner Cloud Console** - Interface web, mais fácil e seguro

### **Vantagens:**
- ✅ Não requer acesso SSH
- ✅ Interface visual e intuitiva
- ✅ Pode ser revertido facilmente
- ✅ Não afeta servidor em execução

---

## 🔍 PASSO 1: OBTER IPs DO UPTIMEROBOT

### **Como obter os IPs atualizados:**

1. **Acessar Dashboard do UptimeRobot:**
   - URL: https://uptimerobot.com/
   - Fazer login

2. **Navegar para Monitoring IPs:**
   - Menu: **Settings** → **Monitoring IPs**
   - Ou: **Settings** → **Locations** → Selecionar "North America"

3. **Copiar todos os IPs listados:**
   - Copiar cada IP individualmente
   - Ou copiar lista completa se disponível

**📋 Exemplo de IPs (verificar se são os mais recentes):**
```
216.144.250.150
216.144.250.151
216.144.250.152
216.144.250.153
216.144.250.154
216.144.250.155
216.144.250.156
216.144.250.157
216.144.250.158
216.144.250.159
```

---

## 🔧 PASSO 2: ACESSAR HETZNER CLOUD CONSOLE

### **1. Acessar Console:**

- **URL:** https://console.hetzner.cloud/
- **Login:** Com suas credenciais do Hetzner

### **2. Selecionar Projeto:**

- Selecionar o projeto que contém o servidor onde os endpoints estão hospedados
- Geralmente o servidor `flyingdonkeys` ou servidor onde está `bpsegurosimediato.com.br`

---

## 🔧 PASSO 3: NAVEGAR PARA FIREWALLS

### **Opções de Navegação:**

1. **Menu Lateral:**
   - Clicar em **"Firewalls"** no menu lateral esquerdo

2. **Ou via Networking:**
   - Clicar em **"Networking"** → **"Firewalls"**

---

## 🔧 PASSO 4: IDENTIFICAR FIREWALL DO SERVIDOR

### **Cenário 1: Firewall já existe e está aplicado ao servidor**

1. **Listar Firewalls:**
   - Ver lista de firewalls existentes
   - Identificar qual firewall está aplicado ao servidor

2. **Como identificar:**
   - Ver coluna "Applied to" ou "Resources"
   - Procurar pelo servidor onde estão os endpoints

3. **Editar Firewall:**
   - Clicar no nome do firewall
   - Ou clicar no botão **"Edit"** (ícone de lápis)

---

### **Cenário 2: Não existe firewall (criar novo)**

1. **Criar Novo Firewall:**
   - Clicar no botão **"Add Firewall"** ou **"Create Firewall"**

2. **Configurar Nome:**
   - **Nome:** `firewall-uptimerobot-monitoring`
   - **Descrição:** `Firewall para permitir monitoramento do UptimeRobot`

3. **Aplicar ao Servidor:**
   - Na seção **"Apply to"** ou **"Resources"**
   - Selecionar o servidor onde estão os endpoints
   - Clicar em **"Apply"** ou **"Save"**

---

## 🔧 PASSO 5: ADICIONAR REGRAS PARA IPs DO UPTIMEROBOT

### **Para cada IP do UptimeRobot:**

1. **Adicionar Nova Regra:**
   - Clicar no botão **"Add Rule"** ou **"Add Inbound Rule"**

2. **Configurar Regra:**
   - **Direção:** `Inbound` (Entrada)
   - **Protocolo:** `TCP`
   - **Porta:** `80, 443` (ou selecionar "All ports" se necessário)
   - **Ação:** `Allow` (Permitir)
   - **Source IPs:** Colar o IP do UptimeRobot (ex: `216.144.250.150`)
   - **Descrição (opcional):** `UptimeRobot Monitoring - North America`

3. **Salvar Regra:**
   - Clicar em **"Add"** ou **"Save"**

4. **Repetir para cada IP:**
   - Adicionar uma regra para cada IP do UptimeRobot
   - Ou adicionar todos os IPs em uma única regra (se a interface permitir)

---

### **Método Alternativo: Adicionar Múltiplos IPs de uma vez**

**Se a interface permitir:**

1. **Adicionar Regra:**
   - Clicar em **"Add Rule"**

2. **Configurar Regra:**
   - **Direção:** `Inbound`
   - **Protocolo:** `TCP`
   - **Porta:** `80, 443`
   - **Ação:** `Allow`
   - **Source IPs:** Colar todos os IPs, um por linha:
     ```
     216.144.250.150
     216.144.250.151
     216.144.250.152
     216.144.250.153
     216.144.250.154
     216.144.250.155
     216.144.250.156
     216.144.250.157
     216.144.250.158
     216.144.250.159
     ```
   - **Descrição:** `UptimeRobot Monitoring IPs - North America`

3. **Salvar:**
   - Clicar em **"Add"** ou **"Save"**

---

## 🔧 PASSO 6: APLICAR FIREWALL AO SERVIDOR

### **Se firewall já estava aplicado:**

- ✅ **Não precisa fazer nada** - Alterações são aplicadas automaticamente

### **Se criou novo firewall:**

1. **Aplicar ao Servidor:**
   - Na seção **"Applied to"** ou **"Resources"**
   - Clicar em **"Assign Resources"** ou **"Apply to"**
   - Selecionar o servidor onde estão os endpoints
   - Clicar em **"Apply"** ou **"Save"**

2. **Verificar:**
   - Verificar se servidor aparece na lista de recursos aplicados

---

## ✅ PASSO 7: VERIFICAR SE FUNCIONOU

### **1. Verificar no Console:**

1. **Visualizar Regras:**
   - Ver lista de regras do firewall
   - Verificar se todas as regras do UptimeRobot foram adicionadas

2. **Verificar Ordem:**
   - Regras são processadas de cima para baixo
   - Regras de "Allow" devem estar antes de regras de "Deny" (se houver)

### **2. Verificar no UptimeRobot:**

1. **Aguardar alguns minutos:**
   - Firewall pode levar alguns minutos para aplicar mudanças

2. **Verificar Status dos Monitores:**
   - Acessar dashboard do UptimeRobot
   - Verificar se monitores estão funcionando
   - Verificar histórico de checks recentes

3. **Verificar Alertas:**
   - Se havia alertas de "monitoring failed", devem parar de aparecer

---

## 📋 EXEMPLO VISUAL PASSO A PASSO

### **Tela 1: Lista de Firewalls**
```
Firewalls
├── firewall-producao (aplicado ao servidor)
├── firewall-desenvolvimento
└── [Add Firewall]
```

### **Tela 2: Editar Firewall**
```
Firewall: firewall-producao
├── Inbound Rules
│   ├── Allow SSH (22) from 123.45.67.89
│   ├── Allow HTTP (80) from 0.0.0.0/0
│   └── Allow HTTPS (443) from 0.0.0.0/0
└── [Add Rule]
```

### **Tela 3: Adicionar Regra**
```
Add Inbound Rule
├── Direction: Inbound
├── Protocol: TCP
├── Port: 80, 443
├── Action: Allow
├── Source IPs: 216.144.250.150
└── [Add]
```

### **Tela 4: Regras Adicionadas**
```
Firewall: firewall-producao
├── Inbound Rules
│   ├── Allow SSH (22) from 123.45.67.89
│   ├── Allow HTTP (80) from 0.0.0.0/0
│   ├── Allow HTTPS (443) from 0.0.0.0/0
│   ├── Allow TCP (80,443) from 216.144.250.150 [UptimeRobot]
│   ├── Allow TCP (80,443) from 216.144.250.151 [UptimeRobot]
│   └── ... (outros IPs)
└── Applied to: servidor-flyingdonkeys
```

---

## 🚨 TROUBLESHOOTING

### **Problema: Não consigo encontrar o firewall**

**Solução:**
1. Verificar se está no projeto correto
2. Verificar se servidor tem firewall aplicado
3. Criar novo firewall se necessário

---

### **Problema: Regras não estão funcionando**

**Solução:**
1. Verificar se firewall está aplicado ao servidor correto
2. Verificar ordem das regras (Allow antes de Deny)
3. Aguardar alguns minutos para propagação
4. Verificar se IPs estão corretos

---

### **Problema: Não sei qual servidor usar**

**Solução:**
- **Servidor flyingdonkeys:** Onde está o EspoCRM e endpoints
- **Servidor bpsegurosimediato.com.br:** Onde estão os endpoints webhooks
- Verificar qual servidor está hospedando os endpoints monitorados

---

## 📋 CHECKLIST RÁPIDO

### **Antes de Começar:**

- [ ] Obter lista atualizada de IPs do UptimeRobot
- [ ] Acessar Hetzner Cloud Console
- [ ] Identificar servidor correto

### **Durante a Configuração:**

- [ ] Navegar para Firewalls
- [ ] Editar firewall existente OU criar novo
- [ ] Adicionar regra para cada IP do UptimeRobot
- [ ] Configurar: Inbound, TCP, Porta 80/443, Allow
- [ ] Aplicar firewall ao servidor (se novo)

### **Após Configuração:**

- [ ] Verificar regras adicionadas
- [ ] Aguardar alguns minutos
- [ ] Verificar no UptimeRobot se monitoramento está funcionando
- [ ] Documentar IPs adicionados

---

## 🔗 LINKS ÚTEIS

- **Hetzner Cloud Console:** https://console.hetzner.cloud/
- **Documentação Hetzner Firewall:** https://docs.hetzner.com/cloud/firewalls/
- **UptimeRobot Monitoring IPs:** https://uptimerobot.com/help/locations/
- **UptimeRobot Dashboard:** https://uptimerobot.com/

---

## 💡 DICAS IMPORTANTES

1. **Ordem das Regras:**
   - Regras são processadas de cima para baixo
   - Se houver regra de "Deny" antes de "Allow", pode bloquear
   - Mover regras de "Allow" para o topo se necessário

2. **Portas:**
   - **Porta 80:** HTTP (se endpoints usam HTTP)
   - **Porta 443:** HTTPS (recomendado, se endpoints usam HTTPS)
   - **Ambas:** Se não tiver certeza, permitir ambas

3. **IPs:**
   - Verificar se IPs estão corretos (sem espaços, sem erros de digitação)
   - Usar formato correto: `216.144.250.150` (sem /32, a menos que necessário)

4. **Backup:**
   - Anotar regras existentes antes de modificar
   - Pode tirar screenshot das regras atuais

---

**Documento criado em:** 24/11/2025  
**Versão:** 1.0.0  
**Método:** Via Console Web (Mais Fácil)

