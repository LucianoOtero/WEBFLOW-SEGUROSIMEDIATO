# 🔧 GUIA: Como Mover Servidor de Projeto no Hetzner Cloud

**Data:** 25/11/2025  
**Objetivo:** Mover servidor FlyingDonkeys para o mesmo projeto do bssegurosimediato  
**Status:** 📋 **GUIA PASSO A PASSO**

---

## ⚠️ IMPORTANTE ANTES DE COMEÇAR

### **Informações Importantes:**

- ⚠️ **Downtime:** Pode haver breve downtime (alguns segundos a 1-2 minutos)
- ⚠️ **Horário:** Recomendado fazer em horário de baixo tráfego
- ⚠️ **Backup:** Servidor não será afetado, mas é bom ter backup (precaução)
- ✅ **Reversível:** Pode mover de volta se necessário
- ✅ **Dados:** Nenhum dado será perdido

---

## 🚀 PASSO A PASSO

### **PASSO 1: IDENTIFICAR PROJETOS**

#### **1.1. Identificar Projeto do bssegurosimediato**

1. **Acessar Hetzner Cloud Console:**
   - URL: https://console.hetzner.cloud/
   - Fazer login

2. **Verificar projeto atual:**
   - Canto superior direito, verificar qual projeto está selecionado
   - **Anotar nome do projeto** onde está o bssegurosimediato
   - Exemplo: `Projeto Principal` ou `bssegurosimediato-project`

3. **Confirmar servidor bssegurosimediato:**
   - Menu: **Servers** → **Servers**
   - Verificar se servidor bssegurosimediato aparece na lista
   - Se aparecer, este é o projeto correto ✅

---

#### **1.2. Identificar Projeto do FlyingDonkeys**

1. **Verificar outros projetos:**
   - Canto superior direito, clicar no dropdown de projetos
   - Verificar se há outros projetos listados

2. **Selecionar outro projeto:**
   - Clicar em outro projeto (se houver)
   - Menu: **Servers** → **Servers**
   - Verificar se servidor FlyingDonkeys aparece na lista

3. **Anotar projeto:**
   - **Anotar nome do projeto** onde está o FlyingDonkeys
   - Exemplo: `Projeto FlyingDonkeys` ou `flyingdonkeys-project`

**Se não houver outros projetos:**
- ⚠️ FlyingDonkeys pode estar em projeto diferente que você não tem acesso
- ✅ Solução: Verificar com administrador ou usar Solução 2 (IP público + firewall)

---

### **PASSO 2: ACESSAR SERVIDOR FLYINGDONKEYS**

1. **Selecionar projeto do FlyingDonkeys:**
   - Canto superior direito, selecionar projeto onde está o FlyingDonkeys

2. **Abrir servidor FlyingDonkeys:**
   - Menu: **Servers** → **Servers**
   - Clicar no servidor **FlyingDonkeys**

3. **Verificar informações:**
   - Confirmar que é o servidor correto
   - Verificar status (deve estar "Running")

---

### **PASSO 3: MOVER SERVIDOR**

#### **Opção A: Via Menu Actions (Mais Comum)**

1. **No servidor FlyingDonkeys:**
   - Na página do servidor, procurar menu **"Actions"** ou **"⚙️ Settings"**
   - Clicar em **"Actions"** ou **"⚙️"**

2. **Selecionar "Move to Project":**
   - No menu dropdown, procurar opção **"Move to Project"** ou **"Move to another project"**
   - Clicar na opção

3. **Selecionar projeto destino:**
   - Aparecerá lista de projetos disponíveis
   - Selecionar projeto onde está o **bssegurosimediato**
   - Clicar em **"Move"** ou **"Confirm"**

4. **Confirmar operação:**
   - Pode aparecer confirmação
   - Clicar em **"Yes"** ou **"Confirm"** para confirmar

---

#### **Opção B: Via Settings (Alternativa)**

1. **No servidor FlyingDonkeys:**
   - Na página do servidor, procurar aba **"Settings"** ou **"⚙️ Settings"**
   - Clicar em **"Settings"**

2. **Procurar opção de mover:**
   - Procurar seção **"Project"** ou **"Move to Project"**
   - Clicar em **"Move to Project"** ou botão similar

3. **Selecionar projeto destino:**
   - Selecionar projeto onde está o **bssegurosimediato**
   - Clicar em **"Move"** ou **"Save"**

---

#### **Opção C: Via Lista de Servidores (Alternativa)**

1. **Na lista de servidores:**
   - Menu: **Servers** → **Servers**
   - Clicar nos **três pontos (⋯)** ao lado do servidor FlyingDonkeys
   - Ou clicar com botão direito no servidor

2. **Selecionar "Move to Project":**
   - No menu de contexto, procurar **"Move to Project"**
   - Clicar na opção

3. **Selecionar projeto destino:**
   - Selecionar projeto onde está o **bssegurosimediato**
   - Confirmar

---

### **PASSO 4: AGUARDAR CONCLUSÃO**

1. **Aguardar operação:**
   - Operação pode levar **1-2 minutos**
   - Pode aparecer notificação de progresso
   - **Não fechar a página** durante a operação

2. **Verificar status:**
   - Servidor pode mostrar status temporário (ex: "Moving")
   - Aguardar até aparecer mensagem de sucesso
   - Ou verificar que servidor voltou ao status "Running"

3. **Verificar projeto:**
   - Canto superior direito, verificar se projeto mudou automaticamente
   - Ou mudar manualmente para projeto do bssegurosimediato
   - Verificar se FlyingDonkeys aparece na lista de servidores

---

### **PASSO 5: VERIFICAR E CONECTAR À PRIVATE NETWORK**

1. **Selecionar projeto correto:**
   - Canto superior direito, selecionar projeto onde está o **bssegurosimediato**
   - Verificar que ambos servidores aparecem na lista:
     - ✅ bssegurosimediato
     - ✅ FlyingDonkeys

2. **Conectar à Private Network:**
   - Menu: **Networking** → **Networks**
   - Clicar na Private Network criada: `bssegurosimediato-private-network`

3. **Adicionar FlyingDonkeys:**
   - Clicar em **"Add Route"** ou **"Attach Server"**
   - **FlyingDonkeys deve aparecer na lista agora!** ✅
   - Selecionar servidor **FlyingDonkeys**
   - Definir IP privado: `10.0.0.20`
   - Clicar em **"Add"** ou **"Attach"**

4. **Verificar:**
   - Ambos servidores devem aparecer na lista da Private Network:
     - ✅ bssegurosimediato - IP: `10.0.0.10`
     - ✅ FlyingDonkeys - IP: `10.0.0.20`

---

## 🔍 ONDE ENCONTRAR A OPÇÃO "MOVE TO PROJECT"

### **Localizações Possíveis:**

1. **Menu Actions (Mais Comum):**
   - Na página do servidor, botão **"Actions"** ou **"⚙️"**
   - Dropdown com opções, procurar **"Move to Project"**

2. **Aba Settings:**
   - Na página do servidor, aba **"Settings"** ou **"⚙️ Settings"**
   - Seção **"Project"** ou **"Move to Project"**

3. **Menu de Contexto:**
   - Na lista de servidores, três pontos (⋯) ao lado do servidor
   - Ou clique com botão direito no servidor

4. **Seção de Informações:**
   - Na página do servidor, seção mostrando projeto atual
   - Pode ter botão para mudar projeto

---

## ⚠️ SE A OPÇÃO NÃO APARECER

### **Possíveis Causas:**

1. **Permissões Insuficientes:**
   - Usuário pode não ter permissão para mover servidor
   - ✅ Solução: Solicitar permissão ao administrador do projeto

2. **Servidor em Uso:**
   - Servidor pode estar em operação que impede mover
   - ✅ Solução: Aguardar conclusão da operação

3. **Interface Diferente:**
   - Interface do Hetzner pode ter mudado
   - ✅ Solução: Procurar em outras localizações (Settings, Actions, etc.)

---

## 🆘 TROUBLESHOOTING

### **Problema 1: Opção "Move to Project" Não Aparece**

**Solução:**
1. Verificar permissões do usuário
2. Verificar se servidor está ativo (Running)
3. Tentar em outra localização (Settings, Actions, etc.)
4. Contatar suporte Hetzner se necessário

---

### **Problema 2: Operação Falha ou Demora Muito**

**Solução:**
1. Aguardar mais alguns minutos (pode levar até 5 minutos)
2. Verificar status do servidor
3. Tentar novamente
4. Se persistir, contatar suporte Hetzner

---

### **Problema 3: Servidor Não Aparece no Projeto Destino**

**Solução:**
1. Recarregar página (F5)
2. Verificar se projeto correto está selecionado
3. Verificar se operação foi concluída com sucesso
4. Aguardar alguns segundos e verificar novamente

---

## ✅ CHECKLIST

### **Antes de Mover:**
- [ ] Identificar projeto do bssegurosimediato
- [ ] Identificar projeto do FlyingDonkeys
- [ ] Verificar que servidor FlyingDonkeys está ativo (Running)
- [ ] Escolher horário de baixo tráfego (se possível)

### **Durante Movimentação:**
- [ ] Acessar servidor FlyingDonkeys
- [ ] Encontrar opção "Move to Project"
- [ ] Selecionar projeto destino (bssegurosimediato)
- [ ] Confirmar operação
- [ ] Aguardar conclusão (1-2 minutos)

### **Após Movimentação:**
- [ ] Verificar que FlyingDonkeys aparece no projeto correto
- [ ] Conectar FlyingDonkeys à Private Network
- [ ] Atribuir IP privado: `10.0.0.20`
- [ ] Testar conectividade (ping entre servidores)

---

## 📊 RESULTADO ESPERADO

Após mover servidor:

**Projeto do bssegurosimediato:**
- ✅ Servidor bssegurosimediato
- ✅ Servidor FlyingDonkeys (movido)

**Private Network:**
- ✅ bssegurosimediato - IP: `10.0.0.10`
- ✅ FlyingDonkeys - IP: `10.0.0.20`

**Conectividade:**
- ✅ Ping funciona entre IPs privados
- ✅ HTTP funciona entre servidores
- ✅ Comunicação direta, sem internet pública

---

## 🎯 PRÓXIMOS PASSOS

Após mover servidor e conectar à Private Network:

1. ✅ Verificar interface de rede privada em ambos servidores
2. ✅ Testar ping entre IPs privados
3. ✅ Testar HTTP (opcional)
4. ✅ Modificar código para usar IP privado
5. ✅ Monitorar logs para confirmar uso da rede privada

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **GUIA COMPLETO - PRONTO PARA USO**

