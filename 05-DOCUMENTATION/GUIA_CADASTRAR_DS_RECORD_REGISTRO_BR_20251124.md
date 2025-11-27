# Guia: Cadastrar Registro DS (DNSSEC) no Registro.br

**Data:** 24/11/2025  
**Domínio:** `rpaimediatoseguros.com.br`  
**Registrador:** Registro.br  
**Objetivo:** Ativar DNSSEC adicionando registro DS no Registro.br

---

## 📋 RESUMO EXECUTIVO

### **O que fazer:**
Adicionar o registro **DS (Delegation Signer)** fornecido pelo Cloudflare no **Registro.br** para ativar DNSSEC.

### **Onde fazer:**
- 🌐 **Site:** https://registro.br
- 📍 **Local:** Seção de DNS/DNSSEC do domínio
- ⏱️ **Tempo estimado:** 5-10 minutos

---

## 🔧 PASSO A PASSO - REGISTRO.BR

### **Passo 1: Acessar o Registro.br**

1. Acesse: **https://registro.br**
2. Faça login na sua conta
3. Vá em **"Meus Domínios"** ou **"Gerenciar Domínios"**

---

### **Passo 2: Localizar o Domínio**

1. Na lista de domínios, encontre: **`rpaimediatoseguros.com.br`**
2. Clique no domínio para abrir os detalhes

---

### **Passo 3: Acessar Configurações DNS/DNSSEC**

**Opção A: Se houver seção específica de DNSSEC:**
1. Procure por **"DNSSEC"** ou **"Segurança DNS"** no menu
2. Clique para abrir a configuração de DNSSEC

**Opção B: Se estiver em configurações DNS:**
1. Procure por **"DNS"** ou **"Configurações DNS"**
2. Procure por seção **"DNSSEC"** ou **"DS Records"**

**Opção C: Se não encontrar seção específica:**
1. Procure por **"Configurações Avançadas"** ou **"Advanced Settings"**
2. Procure por **"DNSSEC"** ou **"DS Records"**

---

### **Passo 4: Adicionar Registro DS**

O Registro.br pode pedir os campos de diferentes formas. Use os valores abaixo:

#### **Valores do Registro DS (fornecidos pelo Cloudflare):**

| Campo | Valor | Descrição |
|-------|-------|-----------|
| **Key Tag** | `2371` | Identificador da chave |
| **Algorithm** | `13` | Algoritmo de assinatura |
| **Digest Type** | `2` | Tipo de digest (SHA256) |
| **Digest** | `53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A` | Hash da chave pública |

#### **Formato Completo (se pedir tudo junto):**
```
2371 13 2 53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A
```

---

### **Passo 5: Preencher Campos no Registro.br**

O Registro.br pode pedir os campos de diferentes formas:

#### **Formato 1: Campos Separados**
- **Key Tag:** `2371`
- **Algorithm:** `13`
- **Digest Type:** `2`
- **Digest:** `53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A`

#### **Formato 2: Linha Única**
- **DS Record:** `2371 13 2 53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A`

#### **Formato 3: Formato Completo**
- **DS Record:** `rpaimediatoseguros.com.br. 3600 IN DS 2371 13 2 53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A`

---

### **Passo 6: Salvar e Validar**

1. **Salvar** a configuração
2. **Aguardar propagação** (pode levar algumas horas)
3. **Validar** no Cloudflare que o registro DS foi aceito

---

## ✅ VALIDAÇÃO

### **Como Verificar se Funcionou:**

#### **1. No Cloudflare:**
1. Ir em **DNS** → **Settings** → **DNSSEC**
2. Verificar status: Deve mostrar **"Active"** ou **"Ativo"**
3. Se ainda mostrar "Pending" ou "Aguardando", aguardar mais algumas horas

#### **2. Ferramentas Online:**
- **DNSViz:** https://dnsviz.net/
- **DNSSEC Analyzer:** https://dnssec-analyzer.verisignlabs.com/
- Digite o domínio: `rpaimediatoseguros.com.br`
- Verifique se DNSSEC está ativo

#### **3. Comando DNS:**
```bash
# Verificar registro DS
dig DS rpaimediatoseguros.com.br +short

# Deve retornar algo como:
# 2371 13 2 53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A
```

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **Tempo de Propagação:**
- ⏱️ **Normal:** 1-4 horas
- ⏱️ **Máximo:** Até 48 horas (raro)
- ✅ **Cloudflare:** Geralmente detecta em 1-2 horas

### **Se Não Funcionar:**
1. **Verificar valores:** Confirmar que todos os valores foram copiados corretamente
2. **Aguardar mais tempo:** Propagação DNS pode levar algumas horas
3. **Verificar formato:** Certificar-se de que o formato está correto
4. **Contatar suporte:** Se após 24 horas ainda não funcionar, contatar suporte do Registro.br

### **Formato Correto:**
- ✅ **Sem espaços extras** no início ou fim
- ✅ **Digest em maiúsculas** (mas geralmente aceita minúsculas também)
- ✅ **Sem quebras de linha** no meio do registro

---

## 📋 CHECKLIST

### **Antes de Começar:**
- [ ] Ter acesso ao painel do Registro.br
- [ ] Ter os valores do registro DS do Cloudflare
- [ ] Ter tempo para aguardar propagação (1-4 horas)

### **Durante a Configuração:**
- [ ] Acessar painel do Registro.br
- [ ] Localizar domínio `rpaimediatoseguros.com.br`
- [ ] Encontrar seção DNSSEC/DS Records
- [ ] Adicionar registro DS com valores corretos
- [ ] Salvar configuração

### **Após Configuração:**
- [ ] Aguardar propagação (1-4 horas)
- [ ] Verificar status no Cloudflare
- [ ] Validar com ferramentas online (opcional)
- [ ] Confirmar que DNSSEC está ativo

---

## 🔗 LINKS ÚTEIS

### **Registro.br:**
- **Site:** https://registro.br
- **Suporte:** https://registro.br/atendimento/
- **Documentação DNSSEC:** https://registro.br/dominio/dnssec.html

### **Cloudflare:**
- **Instruções por Registrador:** https://developers.cloudflare.com/dns/dnssec/dnssec-setup/
- **Status DNSSEC:** Verificar em DNS → Settings → DNSSEC

### **Ferramentas de Validação:**
- **DNSViz:** https://dnsviz.net/
- **DNSSEC Analyzer:** https://dnssec-analyzer.verisignlabs.com/

---

## 📊 RESUMO DOS VALORES

### **Registro DS Completo:**
```
Key Tag: 2371
Algorithm: 13
Digest Type: 2
Digest: 53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A
```

### **Formato para Copiar (Linha Única):**
```
2371 13 2 53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A
```

### **Formato Completo (se necessário):**
```
rpaimediatoseguros.com.br. 3600 IN DS 2371 13 2 53E79C2977955D752B055AAC1FDDA59D109AB92AB210F0B1CD84C50DE25BEE7A
```

---

## ✅ CONCLUSÃO

### **Resumo:**
1. ✅ Acessar **Registro.br**
2. ✅ Localizar domínio **`rpaimediatoseguros.com.br`**
3. ✅ Encontrar seção **DNSSEC** ou **DS Records**
4. ✅ Adicionar registro DS com valores fornecidos pelo Cloudflare
5. ✅ Salvar e aguardar propagação (1-4 horas)
6. ✅ Validar no Cloudflare que está ativo

### **Tempo Total:**
- ⏱️ **Configuração:** 5-10 minutos
- ⏱️ **Propagação:** 1-4 horas
- ✅ **Total:** ~4 horas para estar totalmente ativo

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 20:40  
**Status:** ✅ **GUIA COMPLETO** - Pronto para uso


