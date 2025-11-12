# 🌐 GUIA: CONFIGURAÇÃO CLOUDFLARE PARA SERVIDOR PROD

**Data:** 11/11/2025  
**Servidor PROD:** `157.180.36.223`  
**Status:** ⏳ **AGUARDANDO CONFIGURAÇÃO**

---

## 🎯 OBJETIVO

Configurar registros DNS no Cloudflare para apontar o domínio de produção para o novo servidor PROD.

---

## ✅ DOMÍNIO ESCOLHIDO

**Domínio de Produção:** `prod.bssegurosimediato.com.br`  
**IP do Servidor:** `157.180.36.223`

**Vantagens desta escolha:**
- ✅ Separação clara entre DEV e PROD
- ✅ Facilita identificação do ambiente
- ✅ Permite manter domínio principal para outro uso

---

## 📋 PASSO A PASSO: CONFIGURAR DNS NO CLOUDFLARE

### **PASSO 1: ACESSAR CLOUDFLARE**

1. **Acesse o painel do Cloudflare:**
   ```
   https://dash.cloudflare.com/
   ```

2. **Faça login** com suas credenciais

3. **Selecione o domínio:** `bssegurosimediato.com.br`

---

### **PASSO 2: NAVEGAR PARA DNS**

1. **No menu lateral**, clique em **"DNS"** ou **"DNS Records"**

2. **Você verá a lista de registros DNS existentes**

---

### **PASSO 3: ADICIONAR REGISTRO A PARA PROD**

1. **Adicionar novo registro:**
   - Clique em **"Add record"** ou **"Adicionar registro"**

2. **Configurar o registro:**
   - **Tipo:** `A`
   - **Nome:** `prod`
   - **IPv4 address:** `157.180.36.223`
   - **Proxy status:** 
     - ⚠️ **Desligado (DNS only)** - Para permitir Certbot funcionar
     - OU **Ligado (Proxied)** - Se quiser usar CDN do Cloudflare
   - **TTL:** `Auto` ou `3600`
   - Clique em **"Save"** ou **"Salvar"**

**Resultado:** O domínio `prod.bssegurosimediato.com.br` apontará para `157.180.36.223`

---

### **PASSO 4: VERIFICAR REGISTRO CRIADO**

Após salvar, você verá na lista:

```
Tipo | Nome        | Conteúdo        | Proxy | TTL
-----|-------------|-----------------|-------|-----
A    | prod        | 157.180.36.223 | DNS   | Auto
```

**Domínio completo:** `prod.bssegurosimediato.com.br` → `157.180.36.223`

---

### **PASSO 5: AGUARDAR PROPAGAÇÃO DNS**

1. **Tempo estimado:**
   - **Cloudflare:** Geralmente instantâneo (se Proxy desligado)
   - **Internet:** 15 minutos a 1 hora
   - **Máximo:** 48 horas (raro)

2. **Verificar propagação:**
   ```bash
   # No seu computador
   nslookup prod.bssegurosimediato.com.br
   
   # Deve retornar: 157.180.36.223
   ```

3. **Verificar online:**
   - Acesse: https://www.whatsmydns.net/
   - Digite o domínio
   - Verifique se o IP está correto em diferentes localizações

---

## ⚠️ IMPORTANTE: PROXY STATUS

### **Proxy DESLIGADO (DNS only) - RECOMENDADO para Certbot**

**Vantagens:**
- ✅ Certbot funciona corretamente
- ✅ IP real do servidor visível
- ✅ Sem interferência do CDN

**Desvantagens:**
- ❌ Sem proteção DDoS do Cloudflare
- ❌ Sem cache do Cloudflare

**Quando usar:**
- ✅ **Recomendado** para servidores com Certbot
- ✅ Quando precisa de IP real visível

---

### **Proxy LIGADO (Proxied) - Para CDN**

**Vantagens:**
- ✅ Proteção DDoS automática
- ✅ Cache do Cloudflare
- ✅ IP do servidor oculto

**Desvantagens:**
- ⚠️ Certbot pode ter problemas (precisa configurar SSL no Cloudflare)
- ⚠️ IP real não é visível diretamente

**Quando usar:**
- ✅ Quando quer proteção DDoS
- ✅ Quando quer usar CDN do Cloudflare
- ⚠️ Requer configuração SSL no Cloudflare também

---

## 📊 RESUMO DOS REGISTROS DNS

### **Configuração Recomendada (Proxy DESLIGADO):**

| Tipo | Nome | Conteúdo | Proxy | TTL |
|------|------|----------|-------|-----|
| A | `prod` | `157.180.36.223` | 🟡 DNS only | Auto |

**Domínio completo:** `prod.bssegurosimediato.com.br` → `157.180.36.223`

---

## 🔍 VERIFICAÇÃO PÓS-CONFIGURAÇÃO

### **1. Verificar DNS no Cloudflare:**

Na lista de registros DNS, confirme:
- ✅ Registro A existe
- ✅ IP está correto: `157.180.36.223`
- ✅ Proxy status está como desejado

### **2. Verificar Propagação:**

```bash
# Windows PowerShell
nslookup prod.bssegurosimediato.com.br

# Deve retornar:
# Name:    prod.bssegurosimediato.com.br
# Address: 157.180.36.223
```

### **3. Testar Acesso HTTP:**

```bash
# Testar se servidor responde
curl -I http://prod.bssegurosimediato.com.br

# Deve retornar HTTP 200, 301 ou 302
```

---

## 📋 CHECKLIST DE CONFIGURAÇÃO CLOUDFLARE

- [ ] Acessei painel do Cloudflare
- [ ] Selecionei domínio `bssegurosimediato.com.br`
- [ ] Naveguei para seção DNS
- [ ] Adicionei registro A para subdomínio `prod`
- [ ] Configurei IP: `157.180.36.223`
- [ ] Configurei Proxy status (DNS only recomendado)
- [ ] Salvei o registro
- [ ] Aguardei propagação DNS (verificado com nslookup)
- [ ] Testei acesso HTTP ao servidor

---

## 🆘 TROUBLESHOOTING

### **Problema: DNS não propaga**

**Possíveis causas:**
- TTL muito alto (cache antigo)
- Propagação ainda em andamento
- Registro DNS incorreto

**Solução:**
- Aguarde mais tempo (até 1 hora)
- Limpe cache DNS local: `ipconfig /flushdns` (Windows)
- Verifique se o registro está correto no Cloudflare

---

### **Problema: Certbot não funciona**

**Possíveis causas:**
- Proxy do Cloudflare está LIGADO
- DNS não propagou completamente
- Firewall bloqueando porta 80

**Solução:**
- Desligue o Proxy (DNS only) temporariamente
- Aguarde propagação DNS completa
- Verifique se porta 80 está acessível

---

### **Problema: Site não carrega após DNS**

**Possíveis causas:**
- Servidor não está configurado ainda
- Nginx não está rodando
- Certificado SSL não foi obtido

**Solução:**
- Execute script de ajuste no servidor PROD
- Copie arquivos de aplicação
- Obtenha certificado SSL via Certbot

---

## ✅ PRÓXIMOS PASSOS APÓS CONFIGURAR DNS

1. ✅ **DNS configurado no Cloudflare**
2. ⏭️ **Aguardar propagação DNS** (verificar com nslookup)
3. ⏭️ **Executar script de ajuste** no servidor PROD
4. ⏭️ **Copiar arquivos** de aplicação
5. ⏭️ **Obter certificado SSL** via Certbot
6. ⏭️ **Testar acesso HTTPS**

---

## 📝 NOTAS ADICIONAIS

### **TTL (Time To Live):**
- **Auto:** Cloudflare gerencia automaticamente
- **3600:** 1 hora (padrão)
- **1800:** 30 minutos (mais rápido para mudanças)
- **Recomendado:** Auto (Cloudflare otimiza)

### **Proxy Status:**
- **DNS only (🟡):** IP real visível, Certbot funciona
- **Proxied (🟠):** IP oculto, proteção DDoS, pode interferir com Certbot

### **Múltiplos Registros:**
- Você pode ter ambos: `bssegurosimediato.com.br` E `prod.bssegurosimediato.com.br`
- Cada um apontando para o mesmo IP ou IPs diferentes
- Útil para testes antes de migrar domínio principal

---

**Última atualização:** 11/11/2025

