# 📋 Instruções: Implementar Controle de Acesso a Produção

**Data:** 2025-11-18  
**Status:** 📋 **PRONTO PARA IMPLEMENTAÇÃO**

---

## 🎯 OBJETIVO

Implementar sistema de controle de acesso ao servidor de produção que permita habilitar/desabilitar acesso facilmente.

---

## ✅ IMPLEMENTAÇÃO IMEDIATA

### **PASSO 1: Criar Arquivo de Controle**

**Ação:**
Criar arquivo `.env.production_access` na raiz do projeto.

**Comando:**
```powershell
# Copiar arquivo exemplo para raiz do projeto
Copy-Item "WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\CONTROLE_ACESSO_PRODUCAO.env.example" ".env.production_access"
```

**Ou criar manualmente:**

Criar arquivo `.env.production_access` na raiz do projeto com o seguinte conteúdo:

```env
# Status do acesso (DISABLED | ENABLED | READ_ONLY)
PRODUCTION_ACCESS=DISABLED

# Informações do servidor de produção
PRODUCTION_IP=157.180.36.223
PRODUCTION_DOMAIN=prod.bssegurosimediato.com.br
PRODUCTION_PATH=/var/www/html/prod/root

# Data de habilitação (quando aplicável)
PRODUCTION_ENABLED_DATE=

# Autorizado por (quando aplicável)
PRODUCTION_AUTHORIZED_BY=

# Observações
PRODUCTION_NOTES=Procedimento para produção será definido posteriormente
```

---

### **PASSO 2: Verificar Diretivas Atualizadas**

**Ação:**
As diretivas em `.cursorrules` já foram atualizadas para incluir validação automática.

**Verificação:**
- ✅ Seção "VALIDAÇÃO AUTOMÁTICA OBRIGATÓRIA" adicionada
- ✅ Seção "DETECÇÃO AUTOMÁTICA OBRIGATÓRIA" adicionada
- ✅ Bloqueio automático quando `PRODUCTION_ACCESS=DISABLED`

---

## 🔧 COMO FUNCIONA

### **Quando `PRODUCTION_ACCESS=DISABLED` (Padrão):**

1. **Assistente detecta referência a produção:**
   - IP: `157.180.36.223`
   - Domínio: `prod.bssegurosimediato.com.br`
   - Caminho: `/var/www/html/prod/root`

2. **Assistente verifica arquivo `.env.production_access`**

3. **Se `PRODUCTION_ACCESS=DISABLED`:**
   - ❌ **BLOQUEAR** automaticamente o comando
   - 🚨 **EMITIR ALERTA** obrigatório
   - 📋 **INFORMAR** que acesso está desabilitado

### **Quando `PRODUCTION_ACCESS=ENABLED`:**

1. **Assistente detecta referência a produção**

2. **Assistente verifica arquivo `.env.production_access`**

3. **Se `PRODUCTION_ACCESS=ENABLED`:**
   - ⚠️ **EMITIR ALERTA** de que acesso está habilitado
   - ✅ **PERMITIR** após validação adicional:
     - Verificar autorização explícita do usuário
     - Verificar backup criado
     - Verificar plano de rollback

### **Quando `PRODUCTION_ACCESS=READ_ONLY`:**

1. **Assistente detecta referência a produção**

2. **Assistente verifica arquivo `.env.production_access`**

3. **Se `PRODUCTION_ACCESS=READ_ONLY`:**
   - ✅ **PERMITIR** apenas comandos de leitura/investigação
   - ❌ **BLOQUEAR** comandos de escrita/modificação

---

## 📝 COMO HABILITAR ACESSO (Futuro)

**Quando o procedimento oficial de produção for definido:**

1. **Editar arquivo `.env.production_access`:**
   ```env
   PRODUCTION_ACCESS=ENABLED
   PRODUCTION_ENABLED_DATE=2025-11-XX
   PRODUCTION_AUTHORIZED_BY=[Nome do Usuário]
   PRODUCTION_NOTES=Procedimento oficial definido em [data]
   ```

2. **Salvar arquivo**

3. **Acesso será habilitado automaticamente**

---

## 📝 COMO DESABILITAR ACESSO

**Para bloquear acesso novamente:**

1. **Editar arquivo `.env.production_access`:**
   ```env
   PRODUCTION_ACCESS=DISABLED
   ```

2. **Salvar arquivo**

3. **Acesso será bloqueado automaticamente**

---

## ✅ VERIFICAÇÃO

**Para verificar se está funcionando:**

1. **Tentar executar comando que acessa produção:**
   ```powershell
   ssh root@157.180.36.223 "ls /var/www/html/prod/root"
   ```

2. **Assistente deve:**
   - 🚨 Emitir alerta
   - ❌ Bloquear comando
   - 📋 Informar que acesso está desabilitado

---

## 📚 DOCUMENTAÇÃO RELACIONADA

- **Análise Completa:** `ANALISE_CAUSA_RAIZ_VIOLACAO_DIRETIVAS_PRODUCAO_20251118.md`
- **Diretivas Atualizadas:** `.cursorrules` (seção "PRODUÇÃO - PROCEDIMENTO NÃO DEFINIDO")

---

**Status:** ✅ **PRONTO PARA IMPLEMENTAÇÃO**  
**Próximo Passo:** Criar arquivo `.env.production_access` na raiz do projeto

