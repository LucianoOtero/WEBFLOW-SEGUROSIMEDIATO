# Guia: Corrigir Nameservers do Cloudflare no Registro.br

**Data:** 24/11/2025  
**Domínio:** `rpaimediatoseguros.com.br`  
**Problema:** Registros NS do Registro.br aparecendo no Cloudflare  
**Status:** ⚠️ **AÇÃO NECESSÁRIA**

---

## 📋 RESUMO EXECUTIVO

### **Problema Identificado:**
Os registros NS (`a.sec.dns.br` e `b.sec.dns.br`) que aparecem no Cloudflare são **resquícios do Registro.br** e indicam que o domínio pode ainda estar usando os nameservers do registrador em vez dos nameservers do Cloudflare.

### **Impacto:**
- ⚠️ **Alto:** Se nameservers não estiverem corretos, o Cloudflare pode não estar totalmente ativo
- ⚠️ **Proteção:** DDoS e cache do Cloudflare podem não estar funcionando completamente
- ⚠️ **SSL:** Certificados SSL automáticos podem não estar funcionando

### **Solução:**
Atualizar nameservers no Registro.br para apontar para o Cloudflare.

---

## 🔍 IDENTIFICAÇÃO DO PROBLEMA

### **Sintomas:**
- ✅ Registros NS aparecem na lista de DNS do Cloudflare:
  - `NS rpaimediatoseguros.com.br → a.sec.dns.br`
  - `NS rpaimediatoseguros.com.br → b.sec.dns.br`
- ⚠️ Esses são os nameservers padrão do Registro.br
- ❌ **Não deveriam aparecer** se o Cloudflare estiver totalmente configurado

### **O que isso significa:**
- ⚠️ O domínio pode ainda estar usando nameservers do Registro.br
- ⚠️ O Cloudflare pode não estar totalmente ativo
- ⚠️ Algumas funcionalidades do Cloudflare podem não estar funcionando

---

## ✅ COMO VERIFICAR

### **Passo 1: Verificar Nameservers no Registro.br**

1. Acessar: https://registro.br
2. Fazer login na sua conta
3. Ir em **"Meus Domínios"**
4. Localizar `rpaimediatoseguros.com.br`
5. Clicar no domínio para ver detalhes
6. Procurar seção **"Nameservers"** ou **"Servidores DNS"**

### **Cenário A: Nameservers do Registro.br (INCORRETO)**
```
Nameservers:
- a.sec.dns.br
- b.sec.dns.br
```

**Status:** ❌ **PRECISA ATUALIZAR**

### **Cenário B: Nameservers do Cloudflare (CORRETO)**
```
Nameservers:
- [nome].ns.cloudflare.com
- [nome].ns.cloudflare.com
```

**Status:** ✅ **ESTÁ CORRETO**

---

## 🔧 COMO CORRIGIR

### **Passo 1: Obter Nameservers do Cloudflare**

1. Acessar painel do Cloudflare: https://dash.cloudflare.com
2. Selecionar domínio `rpaimediatoseguros.com.br`
3. Ir em **DNS** → **Overview** (ou **Configuração** → **DNS**)
4. Procurar seção **"Nameservers"** ou **"Servidores de Nomes"**
5. Copiar os 2 nameservers fornecidos (exemplo):
   ```
   [nome].ns.cloudflare.com
   [nome].ns.cloudflare.com
   ```

### **Passo 2: Atualizar Nameservers no Registro.br**

1. Acessar: https://registro.br
2. Fazer login
3. Ir em **"Meus Domínios"**
4. Clicar em `rpaimediatoseguros.com.br`
5. Procurar opção **"Alterar Nameservers"** ou **"Servidores DNS"**
6. Selecionar **"Usar nameservers personalizados"** ou **"DNS Personalizado"**
7. Inserir os 2 nameservers do Cloudflare:
   - Nameserver 1: `[nome].ns.cloudflare.com`
   - Nameserver 2: `[nome].ns.cloudflare.com`
8. Salvar alterações
9. Confirmar alteração (pode pedir confirmação por email)

### **Passo 3: Aguardar Propagação**

- ⚠️ **Tempo de propagação:** Até 24 horas (normalmente 1-2 horas)
- ✅ **Cloudflare geralmente detecta em minutos**
- ⚠️ **Durante propagação:** Alguns serviços podem ficar temporariamente indisponíveis

### **Passo 4: Verificar se Funcionou**

1. Aguardar 1-2 horas após atualização
2. Verificar no Cloudflare se status mudou para "Ativo"
3. Verificar se registros NS do Registro.br desapareceram da lista
4. Testar acesso ao domínio

---

## 📊 VERIFICAÇÃO DE STATUS

### **Como Saber se Está Funcionando:**

#### **1. No Cloudflare:**
- ✅ Status do domínio deve mostrar "Ativo" (não "Pendente")
- ✅ Registros NS do Registro.br devem desaparecer (ou não aparecer mais)
- ✅ Seção "Nameservers" deve mostrar apenas os nameservers do Cloudflare

#### **2. Teste de DNS:**
```bash
# No Windows PowerShell:
nslookup rpaimediatoseguros.com.br

# Deve retornar IPs do Cloudflare (não IP do servidor diretamente)
```

#### **3. Teste de Headers:**
- ✅ Headers HTTP devem incluir `CF-Ray` (já confirmado nos testes anteriores)
- ✅ Header `Server: cloudflare` deve estar presente

---

## ⚠️ AVISOS IMPORTANTES

### **1. Tempo de Propagação:**
- ⚠️ Alterações de nameservers podem levar até 24 horas para propagar globalmente
- ⚠️ Durante propagação, pode haver instabilidade temporária
- ✅ Normalmente, propagação completa ocorre em 1-2 horas

### **2. Impacto Durante Propagação:**
- ⚠️ Alguns serviços podem ficar temporariamente indisponíveis
- ⚠️ Emails podem ter atraso temporário
- ⚠️ Acesso ao site pode ter interrupções curtas

### **3. Rollback:**
- ✅ Se houver problemas, pode reverter para nameservers do Registro.br
- ⚠️ Mas isso desativará o Cloudflare

---

## 📋 CHECKLIST DE CORREÇÃO

### **Antes de Atualizar:**
- [ ] Nameservers do Cloudflare copiados
- [ ] Acesso ao painel do Registro.br confirmado
- [ ] Backup de configurações atuais (se necessário)

### **Durante Atualização:**
- [ ] Nameservers atualizados no Registro.br
- [ ] Confirmação recebida (email ou no painel)
- [ ] Alteração salva com sucesso

### **Após Atualização:**
- [ ] Aguardar 1-2 horas para propagação
- [ ] Verificar status no Cloudflare (deve mostrar "Ativo")
- [ ] Verificar se registros NS do Registro.br desapareceram
- [ ] Testar acesso ao domínio
- [ ] Verificar headers HTTP (CF-Ray presente)
- [ ] Deletar registros NS do Cloudflare (se ainda aparecerem)

---

## 🔍 VERIFICAÇÃO ADICIONAL

### **Se Nameservers Já Estão Corretos no Registro.br:**

Se você verificar e os nameservers já estiverem apontando para o Cloudflare, mas os registros NS ainda aparecem no Cloudflare:

1. ⚠️ **Pode ser cache:** Aguardar mais tempo (até 24 horas)
2. ⚠️ **Pode ser informativo:** Cloudflare pode estar mostrando nameservers antigos
3. ✅ **Pode deletar:** Se nameservers estão corretos no Registro.br, pode deletar esses registros NS do Cloudflare

---

## 📝 NOTAS TÉCNICAS

### **Por que esses registros aparecem?**
- ⚠️ Quando um domínio é adicionado ao Cloudflare, mas os nameservers ainda não foram atualizados no registrador
- ⚠️ O Cloudflare pode importar registros DNS existentes, incluindo registros NS
- ⚠️ Esses registros NS são apenas informativos e não são necessários quando o Cloudflare está totalmente ativo

### **O que são `a.sec.dns.br` e `b.sec.dns.br`?**
- ✅ São os nameservers padrão do Registro.br
- ✅ Usados quando o domínio está usando DNS do Registro.br (não Cloudflare)
- ❌ Não devem estar presentes quando o Cloudflare está totalmente configurado

---

## ✅ CONCLUSÃO

**Resposta:** ✅ **SIM, são resquícios do Registro.br**

**Ação Recomendada:**
1. ✅ Verificar nameservers no Registro.br
2. ✅ Se estiverem apontando para Registro.br → Atualizar para Cloudflare
3. ✅ Se já estiverem apontando para Cloudflare → Deletar registros NS do Cloudflare
4. ✅ Aguardar propagação e verificar funcionamento

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 19:50  
**Status:** ⚠️ **AÇÃO NECESSÁRIA** - Verificar e corrigir nameservers

