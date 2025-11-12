# 📸 PASSO A PASSO: CRIAR SNAPSHOT NO HETZNER CLOUD

**Data:** 11/11/2025  
**Servidor DEV:** 65.108.156.14  
**Objetivo:** Criar snapshot do servidor DEV para usar como base do servidor PROD

---

## 🎯 VISÃO GERAL

Um **snapshot** é uma imagem completa do servidor em um momento específico, incluindo:
- ✅ Sistema operacional completo
- ✅ Todos os pacotes instalados (Nginx, PHP, etc.)
- ✅ Todas as configurações (Nginx, PHP-FPM, etc.)
- ✅ Estrutura de diretórios
- ⚠️ **NÃO inclui:** Dados de aplicação em `/var/www/html/dev/root/` (serão copiados depois)

**Tempo estimado:** 5-15 minutos

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

### **PASSO 2: LOCALIZAR O SERVIDOR DEV**

1. **No menu lateral esquerdo**, clique em **"Servers"** (ou "Servidores")

2. **Encontre o servidor DEV** na lista:
   - **Nome:** Geralmente algo como `servidor-dev` ou similar
   - **IP:** `65.108.156.14`
   - **Status:** Deve estar **"Running"** (verde)

3. **Clique no nome do servidor** para abrir os detalhes

---

### **PASSO 3: ACESSAR A ABA DE SNAPSHOTS**

1. **Na página de detalhes do servidor**, você verá várias abas no topo:
   - Overview
   - **Snapshots** ← Clique aqui
   - Backups
   - Networks
   - Firewalls
   - etc.

2. **Clique na aba "Snapshots"**

---

### **PASSO 4: CRIAR O SNAPSHOT**

1. **Na página de Snapshots**, você verá:
   - Lista de snapshots existentes (se houver)
   - Botão **"Create Snapshot"** ou **"Take Snapshot"** (geralmente no canto superior direito)

2. **Clique em "Create Snapshot"** ou **"Take Snapshot"**

3. **Uma janela/modal aparecerá** pedindo informações:

   **Nome do Snapshot:**
   ```
   servidor-dev-backup-2025-11-11
   ```
   ou
   ```
   servidor-dev-prod-base-2025-11-11
   ```
   
   **Descrição (opcional):**
   ```
   Snapshot do servidor DEV para criar servidor PROD
   Backup completo antes de criar ambiente de produção
   ```

4. **Clique em "Create Snapshot"** ou **"Take Snapshot"** para confirmar

---

### **PASSO 5: AGUARDAR CRIAÇÃO DO SNAPSHOT**

1. **Você verá uma notificação** indicando que o snapshot está sendo criado

2. **Na lista de snapshots**, aparecerá um novo item com status:
   - ⏳ **"Creating"** ou **"In Progress"** (durante a criação)
   - ✅ **"Available"** (quando concluído)

3. **Aguarde a conclusão:**
   - **Tempo estimado:** 5-15 minutos (depende do tamanho do servidor)
   - **Você pode acompanhar o progresso** na lista de snapshots
   - **Não feche a página** durante a criação

4. **Quando o status mudar para "Available"**, o snapshot está pronto!

---

### **PASSO 6: VERIFICAR O SNAPSHOT CRIADO**

1. **Na lista de snapshots**, você verá:
   - **Nome:** O nome que você escolheu
   - **Data/Hora:** Quando foi criado
   - **Tamanho:** Tamanho do snapshot em GB
   - **Status:** "Available" ✅

2. **Anote o nome do snapshot** para usar na criação do servidor PROD

---

## 📸 DESCRIÇÃO VISUAL DA INTERFACE

### **Tela 1: Lista de Servidores**
```
┌─────────────────────────────────────────┐
│ Hetzner Cloud Console                   │
├─────────────────────────────────────────┤
│ [Servers] [Networks] [Firewalls] ...    │
├─────────────────────────────────────────┤
│                                         │
│  Servers                                │
│  ┌───────────────────────────────────┐ │
│  │ Name          IP            Status │ │
│  ├───────────────────────────────────┤ │
│  │ servidor-dev  65.108.156.14  🟢   │ │ ← Clique aqui
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 2: Detalhes do Servidor**
```
┌─────────────────────────────────────────┐
│ servidor-dev                            │
├─────────────────────────────────────────┤
│ [Overview] [Snapshots] [Backups] ...    │ ← Clique em "Snapshots"
├─────────────────────────────────────────┤
│                                         │
│  Server Details                         │
│  IP: 65.108.156.14                     │
│  Status: Running                        │
│  ...                                    │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 3: Aba Snapshots**
```
┌─────────────────────────────────────────┐
│ servidor-dev - Snapshots                │
├─────────────────────────────────────────┤
│ [Overview] [Snapshots] [Backups] ...    │
├─────────────────────────────────────────┤
│                                         │
│  Snapshots                              │
│  ┌───────────────────────────────────┐ │
│  │ [Create Snapshot]  ← Botão aqui    │ │
│  └───────────────────────────────────┘ │
│                                         │
│  Existing Snapshots:                    │
│  (lista vazia ou com snapshots antigos) │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 4: Modal de Criação**
```
┌─────────────────────────────────────────┐
│ Create Snapshot                         │
├─────────────────────────────────────────┤
│                                         │
│  Snapshot Name:                         │
│  ┌───────────────────────────────────┐ │
│  │ servidor-dev-backup-2025-11-11    │ │ ← Digite aqui
│  └───────────────────────────────────┘ │
│                                         │
│  Description (optional):                │
│  ┌───────────────────────────────────┐ │
│  │ Snapshot do servidor DEV para...  │ │ ← Opcional
│  └───────────────────────────────────┘ │
│                                         │
│  [Cancel]  [Create Snapshot] ← Clique   │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 5: Snapshot em Progresso**
```
┌─────────────────────────────────────────┐
│ servidor-dev - Snapshots                │
├─────────────────────────────────────────┤
│                                         │
│  Snapshots                              │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ servidor-dev-backup-2025-11-11    │ │
│  │ Status: ⏳ Creating...             │ │ ← Aguarde aqui
│  │ Size: Calculating...              │ │
│  │ Created: 2025-11-11 20:15:00      │ │
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

### **Tela 6: Snapshot Concluído**
```
┌─────────────────────────────────────────┐
│ servidor-dev - Snapshots                │
├─────────────────────────────────────────┤
│                                         │
│  Snapshots                              │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │ servidor-dev-backup-2025-11-11    │ │
│  │ Status: ✅ Available               │ │ ← Pronto!
│  │ Size: 25.4 GB                     │ │
│  │ Created: 2025-11-11 20:30:00      │ │
│  └───────────────────────────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

---

## ⚠️ IMPORTANTE: O QUE O SNAPSHOT INCLUI E NÃO INCLUI

### ✅ **O QUE ESTÁ INCLUÍDO NO SNAPSHOT:**

- ✅ Sistema operacional completo (Ubuntu/Debian)
- ✅ Todos os pacotes instalados:
  - Nginx
  - PHP 8.3 e PHP-FPM
  - MySQL (se instalado)
  - Certbot
  - Outros pacotes do sistema
- ✅ Todas as configurações:
  - `/etc/nginx/` (configurações Nginx)
  - `/etc/php/8.3/fpm/` (configurações PHP-FPM)
  - `/etc/letsencrypt/` (certificados SSL)
  - Variáveis de ambiente configuradas
- ✅ Estrutura de diretórios:
  - `/var/www/html/dev/root/` (estrutura, mas não arquivos de aplicação)
  - Outros diretórios do sistema

### ⚠️ **O QUE NÃO ESTÁ INCLUÍDO (OU PODE ESTAR DESATUALIZADO):**

- ⚠️ **Arquivos de aplicação** em `/var/www/html/dev/root/`:
  - Arquivos PHP (`.php`)
  - Arquivos JavaScript (`.js`)
  - Templates de email
  - **Solução:** Copiar arquivos depois de criar servidor PROD

- ⚠️ **Dados de banco de dados** (se houver):
  - Dados do MySQL/MariaDB
  - **Solução:** Fazer backup separado do banco de dados

- ⚠️ **Certificados SSL**:
  - Certificados Let's Encrypt podem estar no snapshot
  - **Mas:** Será necessário obter novos certificados para domínio PROD

---

## 🔍 VERIFICAÇÃO PÓS-SNAPSHOT

Após criar o snapshot, verifique:

1. **Status do snapshot:**
   - ✅ Deve estar "Available"
   - ✅ Deve ter um tamanho razoável (ex: 20-50 GB)

2. **Informações do snapshot:**
   - ✅ Nome correto
   - ✅ Data/hora de criação
   - ✅ Tamanho do snapshot

3. **Anotar informações:**
   - ✅ Nome do snapshot: `_________________`
   - ✅ Data de criação: `_________________`
   - ✅ Tamanho: `_________________`

---

## 📋 CHECKLIST DE CRIAÇÃO DO SNAPSHOT

- [ ] Acessei Hetzner Cloud Console
- [ ] Localizei o servidor DEV (IP: 65.108.156.14)
- [ ] Abri a aba "Snapshots"
- [ ] Cliquei em "Create Snapshot"
- [ ] Preenchi o nome do snapshot
- [ ] Confirmei a criação
- [ ] Aguardei conclusão (status "Available")
- [ ] Anotei o nome do snapshot criado

---

## 🆘 TROUBLESHOOTING

### **Problema: Botão "Create Snapshot" não aparece**

**Possíveis causas:**
- Servidor não está em execução
- Você não tem permissões suficientes
- Servidor está em estado de erro

**Solução:**
- Verifique se o servidor está "Running"
- Verifique suas permissões no projeto
- Entre em contato com suporte Hetzner se necessário

---

### **Problema: Snapshot está demorando muito**

**Normal:**
- Snapshots podem levar 5-30 minutos dependendo do tamanho
- Servidores maiores levam mais tempo

**Solução:**
- Aguarde pacientemente
- Não feche a página durante a criação
- Verifique se há erros na interface

---

### **Problema: Snapshot falhou**

**Possíveis causas:**
- Espaço insuficiente no Hetzner Cloud
- Servidor em estado inconsistente
- Problema temporário do Hetzner

**Solução:**
- Tente criar novamente
- Verifique o espaço disponível no projeto
- Entre em contato com suporte Hetzner se persistir

---

## ✅ PRÓXIMOS PASSOS APÓS CRIAR O SNAPSHOT

1. ✅ **Snapshot criado com sucesso**
2. ⏭️ **Criar servidor PROD** a partir do snapshot
3. ⏭️ **Executar script de ajuste** (`ajustar_dev_para_prod.sh`)
4. ⏭️ **Copiar arquivos** de aplicação
5. ⏭️ **Configurar DNS** e SSL

---

## 📝 NOTAS ADICIONAIS

### **Custo do Snapshot:**
- Snapshots no Hetzner Cloud têm custo de armazenamento
- Geralmente: ~€0.01 por GB/mês
- Um snapshot de 25 GB custa aproximadamente €0.25/mês
- **Dica:** Delete snapshots antigos para economizar

### **Manter Snapshot:**
- Recomendado manter o snapshot até confirmar que servidor PROD está funcionando
- Após validação, você pode manter ou deletar o snapshot
- Snapshots podem ser usados para restaurar servidor se necessário

---

**Última atualização:** 11/11/2025

