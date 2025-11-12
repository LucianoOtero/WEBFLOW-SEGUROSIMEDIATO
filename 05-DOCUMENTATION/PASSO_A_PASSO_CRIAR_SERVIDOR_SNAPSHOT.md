# 🖥️ PASSO A PASSO: CRIAR SERVIDOR PROD A PARTIR DE SNAPSHOT

**Data:** 11/11/2025  
**Objetivo:** Criar servidor de produção usando snapshot do servidor DEV

---

## 🎯 VISÃO GERAL

Após criar o snapshot do servidor DEV, você pode criar um novo servidor idêntico em minutos. Este novo servidor terá:
- ✅ Mesmo sistema operacional
- ✅ Mesmos pacotes instalados
- ✅ Mesmas configurações
- ⚠️ **Será necessário ajustar:** Variáveis de ambiente para PROD

**Tempo estimado:** 5-10 minutos

---

## 📋 PASSO A PASSO DETALHADO

### **PASSO 1: ACESSAR HETZNER CLOUD CONSOLE**

1. **Abra seu navegador** e acesse:
   ```
   https://console.hetzner.cloud/
   ```

2. **Faça login** com suas credenciais Hetzner

3. **Selecione seu projeto** (se tiver múltiplos projetos)

---

### **PASSO 2: INICIAR CRIAÇÃO DE SERVIDOR**

1. **No menu lateral esquerdo**, clique em **"Servers"** (ou "Servidores")

2. **Clique no botão "Create Server"** ou **"Add Server"**
   - Geralmente está no canto superior direito
   - Ou pode haver um botão grande no centro da página

---

### **PASSO 3: ESCOLHER IMAGEM (SNAPSHOT)**

1. **Na página de criação do servidor**, você verá várias seções:

   **Seção "Image"** ou **"Choose Image"**:
   - Opções: "Ubuntu", "Debian", "CentOS", etc.
   - **Procure por:** "Snapshots" ou "From Snapshot" ou "My Snapshots"
   - **OU** clique na aba "Snapshots" no topo da seção de imagens

2. **Selecione a aba "Snapshots"** ou **"My Snapshots"**

3. **Na lista de snapshots**, você verá:
   - O snapshot que você criou anteriormente
   - Nome: `servidor-dev-backup-2025-11-11` (ou o nome que você escolheu)
   - Data de criação
   - Tamanho

4. **Clique no snapshot** para selecioná-lo
   - O snapshot ficará destacado/realçado

---

### **PASSO 4: ESCOLHER TIPO DE SERVIDOR**

1. **Na seção "Type"** ou **"Choose Server Type"**:

   **Opções disponíveis:**
   - **CX11** - 1 vCPU, 2 GB RAM (menor)
   - **CX21** - 2 vCPU, 4 GB RAM
   - **CX31** - 2 vCPU, 8 GB RAM
   - **CX41** - 4 vCPU, 16 GB RAM
   - **CX51** - 8 vCPU, 32 GB RAM (maior)

2. **Recomendação:**
   - **Use o mesmo tipo** do servidor DEV (para garantir compatibilidade)
   - **OU escolha um tipo maior** se quiser mais recursos para produção

3. **Como descobrir o tipo do servidor DEV:**
   - Vá para o servidor DEV existente
   - Na página de detalhes, veja a seção "Type" ou "Server Type"
   - Anote o tipo (ex: CX21, CX31, etc.)

4. **Selecione o tipo** clicando nele

---

### **PASSO 5: ESCOLHER LOCALIZAÇÃO**

1. **Na seção "Location"** ou **"Choose Location"**:

   **Opções disponíveis:**
   - **Falkenstein** (Alemanha)
   - **Nuremberg** (Alemanha)
   - **Helsinki** (Finlândia)
   - **Ashburn** (EUA)
   - **Hillsboro** (EUA)
   - Outras localizações disponíveis

2. **Recomendação:**
   - **Mesma localização** do servidor DEV (para latência similar)
   - **OU** escolha localização mais próxima dos usuários finais

3. **Selecione a localização** clicando nela

---

### **PASSO 6: CONFIGURAR SSH KEYS**

1. **Na seção "SSH Keys"** ou **"Add SSH Key"**:

2. **Opções:**
   - **Se você já tem SSH Keys cadastradas:**
     - Selecione as chaves que deseja usar
     - Marque as checkboxes das chaves
   
   - **Se não tem SSH Keys:**
     - Você pode criar uma nova chave
     - OU adicionar depois (não recomendado para produção)

3. **Recomendação:**
   - Use as **mesmas SSH Keys** do servidor DEV
   - Isso permite acesso imediato ao servidor PROD

---

### **PASSO 7: CONFIGURAR REDE (NETWORKS) - OPCIONAL**

1. **Na seção "Networks"** (se disponível):

2. **Opções:**
   - Deixar vazio (servidor terá IP público)
   - Adicionar a uma rede privada existente
   - Criar nova rede privada

3. **Para este projeto:**
   - **Deixe vazio** (não é necessário para este caso)
   - O servidor terá um IP público automaticamente

---

### **PASSO 8: CONFIGURAR FIREWALL - OPCIONAL**

1. **Na seção "Firewalls"** (se disponível):

2. **Opções:**
   - Deixar vazio (sem firewall específico)
   - Adicionar firewall existente

3. **Para este projeto:**
   - **Deixe vazio** (firewall será configurado depois)
   - OU adicione o mesmo firewall do servidor DEV

---

### **PASSO 9: CONFIGURAR NOME E VOLUME - OPCIONAL**

1. **Na seção "Name"** ou **"Server Name"**:

2. **Digite um nome para o servidor:**
   ```
   servidor-prod
   ```
   ou
   ```
   bssegurosimediato-prod
   ```
   ou
   ```
   webflow-seguros-prod
   ```

3. **Volumes adicionais (opcional):**
   - Geralmente não é necessário para este projeto
   - Deixe vazio

---

### **PASSO 10: REVISAR E CRIAR**

1. **Antes de criar**, revise todas as configurações:

   **Checklist de revisão:**
   - ✅ **Image:** Snapshot selecionado (`servidor-dev-backup-2025-11-11`)
   - ✅ **Type:** Tipo escolhido (ex: CX21)
   - ✅ **Location:** Localização escolhida
   - ✅ **SSH Keys:** Chaves selecionadas
   - ✅ **Name:** Nome do servidor definido

2. **Verifique o custo estimado** (geralmente mostrado no canto da página)

3. **Clique em "Create Server"** ou **"Create & Buy Now"**

---

### **PASSO 11: AGUARDAR CRIAÇÃO DO SERVIDOR**

1. **Você será redirecionado** para a página do novo servidor

2. **Status do servidor:**
   - ⏳ **"Creating"** - Servidor está sendo criado
   - ⏳ **"Starting"** - Servidor está iniciando
   - ✅ **"Running"** - Servidor está pronto!

3. **Aguarde até o status mudar para "Running"**
   - Tempo estimado: 2-5 minutos

---

### **PASSO 12: ANOTAR INFORMAÇÕES DO SERVIDOR**

1. **Quando o servidor estiver "Running"**, anote as informações:

   **IP Público:**
   ```
   IP: _________________
   ```
   (Exemplo: `65.108.156.15`)

   **Nome do Servidor:**
   ```
   Nome: _________________
   ```
   (Exemplo: `servidor-prod`)

   **Hostname:**
   ```
   Hostname: _________________
   ```
   (Geralmente igual ao nome)

2. **Guarde essas informações** - você precisará delas para:
   - Conectar via SSH
   - Configurar DNS
   - Executar scripts de configuração

---

## 📸 DESCRIÇÃO VISUAL DA INTERFACE

### **Tela 1: Botão Create Server**
```
┌─────────────────────────────────────────┐
│ Hetzner Cloud Console                   │
├─────────────────────────────────────────┤
│ [Servers] [Networks] [Firewalls] ...    │
├─────────────────────────────────────────┤
│                                         │
│  Servers                                │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │      [+ Create Server]  ← Clique  │ │
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 2: Seleção de Image (Snapshot)**
```
┌─────────────────────────────────────────┐
│ Create Server                           │
├─────────────────────────────────────────┤
│                                         │
│  Image                                  │
│  [Ubuntu] [Debian] [Snapshots] ← Clique│
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ servidor-dev-backup-2025-11-11   │ │ ← Selecione
│  │ Created: 2025-11-11               │ │
│  │ Size: 25.4 GB                     │ │
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 3: Seleção de Type**
```
┌─────────────────────────────────────────┐
│ Create Server                           │
├─────────────────────────────────────────┤
│                                         │
│  Type                                   │
│  ┌──────┐ ┌──────┐ ┌──────┐            │
│  │ CX11 │ │ CX21 │ │ CX31 │ ← Escolha  │
│  └──────┘ └──────┘ └──────┘            │
│                                         │
│  1 vCPU   2 vCPU   2 vCPU              │
│  2 GB     4 GB     8 GB                 │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 4: Seleção de Location**
```
┌─────────────────────────────────────────┐
│ Create Server                           │
├─────────────────────────────────────────┤
│                                         │
│  Location                               │
│  ┌─────────────┐ ┌─────────────┐       │
│  │ Falkenstein │ │ Nuremberg   │ ← Escolha
│  └─────────────┘ └─────────────┘       │
│                                         │
│  ┌─────────────┐ ┌─────────────┐       │
│  │ Helsinki    │ │ Ashburn     │       │
│  └─────────────┘ └─────────────┘       │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 5: Configuração SSH Keys**
```
┌─────────────────────────────────────────┐
│ Create Server                           │
├─────────────────────────────────────────┤
│                                         │
│  SSH Keys                               │
│  ┌───────────────────────────────────┐ │
│  │ ☑ ssh-rsa AAAAB3... (meu-key)    │ │ ← Marque
│  └───────────────────────────────────┘ │
│  ┌───────────────────────────────────┐ │
│  │ ☐ ssh-rsa AAAAB3... (outra-key)  │ │
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 6: Revisão Final**
```
┌─────────────────────────────────────────┐
│ Create Server                           │
├─────────────────────────────────────────┤
│                                         │
│  Summary                                │
│  Image: servidor-dev-backup-2025-11-11 │
│  Type: CX21 (2 vCPU, 4 GB RAM)        │
│  Location: Falkenstein                  │
│  SSH Keys: 1 selected                   │
│  Name: servidor-prod                    │
│                                         │
│  Estimated: €4.75/month                 │
│                                         │
│  [Cancel]  [Create Server] ← Clique    │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 7: Servidor Criado**
```
┌─────────────────────────────────────────┐
│ servidor-prod                           │
├─────────────────────────────────────────┤
│                                         │
│  Status: ✅ Running                     │
│  IP: 65.108.156.15                      │ ← Anote!
│  Type: CX21                             │
│  Location: Falkenstein                   │
│                                         │
│  [Connect] [Snapshots] [Backups] ...    │
│                                         │
└─────────────────────────────────────────┘
```

---

## ⚠️ IMPORTANTE: O QUE ACONTECE APÓS A CRIAÇÃO

### ✅ **O QUE JÁ ESTÁ CONFIGURADO:**

- ✅ Sistema operacional completo
- ✅ Todos os pacotes instalados (Nginx, PHP, etc.)
- ✅ Configurações do sistema (Nginx, PHP-FPM)
- ✅ Estrutura de diretórios básica

### ⚠️ **O QUE PRECISA SER AJUSTADO:**

- ⚠️ **Variáveis de ambiente:** Ainda apontam para DEV
- ⚠️ **Configuração Nginx:** Ainda configurada para domínio DEV
- ⚠️ **Arquivos de aplicação:** Não estão no servidor (precisa copiar)
- ⚠️ **Certificados SSL:** Precisam ser obtidos para domínio PROD
- ⚠️ **DNS:** Precisa ser configurado para apontar para novo IP

---

## 📋 CHECKLIST DE CRIAÇÃO DO SERVIDOR

### **Antes de Criar:**
- [ ] Snapshot criado e disponível
- [ ] Tipo de servidor escolhido
- [ ] Localização escolhida
- [ ] SSH Keys selecionadas
- [ ] Nome do servidor definido

### **Após Criar:**
- [ ] Servidor está "Running"
- [ ] IP público anotado: `_________________`
- [ ] Nome do servidor anotado: `_________________`
- [ ] Consegue conectar via SSH

---

## 🔍 VERIFICAÇÃO PÓS-CRIAÇÃO

### **1. Verificar Status do Servidor:**

Na página do servidor, verifique:
- ✅ Status: "Running"
- ✅ IP público está visível
- ✅ Tipo e localização corretos

### **2. Testar Conexão SSH:**

```bash
# No seu computador
ssh root@[IP_DO_SERVIDOR_PROD]

# Deve conectar sem problemas
# Se pedir senha, use a mesma do servidor DEV
```

### **3. Verificar Configurações Básicas:**

```bash
# No servidor PROD (após conectar via SSH)
# Verificar se Nginx está instalado
nginx -v

# Verificar se PHP está instalado
php -v

# Verificar estrutura de diretórios
ls -la /var/www/html/dev/root/
```

---

## 🆘 TROUBLESHOOTING

### **Problema: Não encontro a opção "Snapshots" na criação**

**Possíveis causas:**
- Snapshot ainda não está disponível
- Interface do Hetzner mudou
- Você está na seção errada

**Solução:**
- Verifique se o snapshot está "Available" na lista de snapshots
- Procure por "My Snapshots" ou "From Snapshot"
- Tente clicar em "Custom Images" ou "Images"
- Se não encontrar, entre em contato com suporte Hetzner

---

### **Problema: Servidor não inicia (fica em "Creating")**

**Possíveis causas:**
- Problema temporário do Hetzner
- Snapshot corrompido
- Recursos insuficientes

**Solução:**
- Aguarde alguns minutos (pode levar até 10 minutos)
- Tente criar novamente
- Verifique se há notificações de erro na interface
- Entre em contato com suporte Hetzner se persistir

---

### **Problema: Não consigo conectar via SSH**

**Possíveis causas:**
- SSH Keys não foram adicionadas corretamente
- Firewall bloqueando conexão
- Servidor ainda não está totalmente pronto

**Solução:**
- Aguarde alguns minutos após criação
- Verifique se SSH Keys estão corretas
- Tente usar senha (se configurada)
- Verifique firewall do Hetzner Cloud

---

## ✅ PRÓXIMOS PASSOS APÓS CRIAR O SERVIDOR

1. ✅ **Servidor PROD criado com sucesso**
2. ⏭️ **Conectar via SSH** ao servidor PROD
3. ⏭️ **Executar script de ajuste** (`ajustar_dev_para_prod.sh`)
4. ⏭️ **Copiar arquivos** de aplicação
5. ⏭️ **Configurar DNS** para apontar para novo IP
6. ⏭️ **Obter certificado SSL** para domínio PROD

---

## 📝 NOTAS ADICIONAIS

### **Custo do Servidor:**
- O custo depende do tipo escolhido
- CX21 (2 vCPU, 4 GB): ~€4-5/mês
- CX31 (2 vCPU, 8 GB): ~€8-10/mês
- O custo é cobrado por hora, mas mostrado como mensal

### **IP Público:**
- Cada servidor recebe um IP público automaticamente
- O IP é permanente (não muda)
- Você pode adicionar IPs adicionais se necessário

### **Backup Automático:**
- Por padrão, backups automáticos podem estar desabilitados
- Configure backups automáticos se necessário
- Snapshots podem ser usados como backup manual

---

## 🔗 REFERÊNCIAS

- **Guia de Ajuste:** `GUIA_RAPIDO_SNAPSHOT_PROD.md`
- **Script de Ajuste:** `06-SERVER-CONFIG/ajustar_dev_para_prod.sh`
- **Documentação Hetzner:** https://docs.hetzner.com/cloud/servers/

---

**Última atualização:** 11/11/2025

