# 📊 ANÁLISE COMPARATIVA: SAFETYMAILS VS PROVEDORES ORIGINAIS

**Data da Análise:** 31/10/2025 01:15  
**Objetivo:** Comparar SafetyMails com provedores originais e verificar possível terceirização

---

## 🔍 DOCUMENTAÇÃO SAFETYMAILS - ANÁLISE TÉCNICA

### **Informações Obtidas da Documentação:**

#### **1. Erro 403 - Origem Não Autorizada** ⚠️ **CRÍTICO**

De acordo com a documentação oficial do SafetyMails:
- **O erro 403 ocorre quando a requisição é feita de uma origem diferente da cadastrada**
- É necessário **registrar e autorizar** o domínio/IP de origem na conta SafetyMails
- Requisições de navegadores (browser) podem ser bloqueadas por padrão

**Implicação para o Código Atual:**
```javascript
// Requisição sendo feita via fetch() no navegador
const response = await fetch(url, {
  method: "POST",
  headers: { "Sf-Hmac": hmac },
  body: form
});
```

**Problema Identificado:**
- Se o domínio atual (`dev.bpsegurosimediato.com.br` ou domínio do Webflow) não está autorizado na conta SafetyMails, a requisição será rejeitada com 403
- SafetyMails pode ter políticas que bloqueiam requisições diretas de navegadores

#### **2. Autenticação HMAC**

Baseado na documentação e padrões comuns:
- **Header:** `Sf-Hmac` (confirmado pelo código atual)
- **Método:** HMAC SHA-256 do email usando a API Key
- **Formato:** Hexadecimal (confirmado pela implementação atual)

**Implementação Atual (Aparece Correta):**
```javascript
const hmac = await window.hmacSHA256(email, window.SAFETY_API_KEY);
headers: { "Sf-Hmac": hmac }
```

#### **3. Endpoint da API**

**Formato Esperado:**
```
https://{TICKET}.safetymails.com/api/{SHA1(TICKET)}
```

**Implementação Atual:**
```javascript
const code = await window.sha1(window.SAFETY_TICKET);
const url = `https://${window.SAFETY_TICKET}.safetymails.com/api/${code}`;
```
✅ **Parece correto**

#### **4. Body da Requisição**

**Formato:**
- FormData com campo `email`

**Implementação Atual:**
```javascript
let form = new FormData();
form.append('email', email);
```
✅ **Parece correto**

---

## 🏢 VERIFICAÇÃO DE TERCEIRIZAÇÃO

### **Análise: SafetyMails é Reseller?**

**Indícios Encontrados:**
- SafetyMails aparece como serviço brasileiro de validação de email
- Não há evidências claras de que seja reseller de ZeroBounce, NeverBounce ou outros
- A estrutura de preços e API parecem ser próprios da SafetyMails
- **Não foi encontrada evidência definitiva** de que SafetyMails terceirize de outro provedor

**Conclusão:** SafetyMails parece ser um **provedor direto**, não um reseller identificável.

---

## 💰 COMPARAÇÃO DE PREÇOS - SAFETYMAILS

### **Planos SafetyMails (2024-2025):**

#### **Compra Avulsa:**
- **1.000 créditos:** $10,01 (≈ R$ 50,00)
- **5.000 créditos:** $33,00 (≈ R$ 165,00)
- **10.000 créditos:** Preço não especificado nos resultados
- **Créditos não expiram** ✅

#### **Assinatura Mensal:**
- **5.000 créditos/mês:** $31,35/mês (≈ R$ 157,00/mês)
- Mais econômico que compra avulsa para uso contínuo

#### **Sistema de Créditos:**
- **1 crédito = 1 verificação de email**
- Créditos não expiram (na compra avulsa)
- Sem limites de tempo para uso

---

## 🔄 COMPARAÇÃO COM PROVEDORES ORIGINAIS

### **Principais Provedores de Validação de Email:**

#### **1. ZeroBounce**
**Preços Estimados (2024-2025):**
- **2.000 verificações:** ~$16/mês (≈ R$ 80,00)
- **10.000 verificações:** ~$60/mês (≈ R$ 300,00)
- **50.000 verificações:** ~$250/mês (≈ R$ 1.250,00)
- **API em tempo real:** Disponível
- **Precisão:** ~98%
- **Características:** Empresa consolidada, API robusta, documentação extensa

#### **2. NeverBounce**
**Preços Estimados (2024-2025):**
- **1.000 verificações:** ~$0,008 por verificação (≈ $8/mês para 1.000)
- **Volume discounts:** Disponíveis
- **API em tempo real:** Disponível
- **Precisão:** ~99%
- **Características:** Focado em precisão, boa para listas grandes

#### **3. Abstract API (Email Validation)**
**Preços Estimados (2024-2025):**
- **Gratuito:** 100 verificações/mês
- **Básico:** $9,99/mês para 10.000 verificações (≈ R$ 50,00)
- **Profissional:** $49,99/mês para 100.000 verificações (≈ R$ 250,00)
- **API em tempo real:** Disponível
- **Características:** Múltiplas APIs em um serviço

#### **4. Mailgun (Email Validation)**
**Preços Estimados (2024-2025):**
- **Free Tier:** 5.000 verificações/mês gratuitas
- **Pay as you go:** ~$0,01 por verificação adicional
- **API em tempo real:** Disponível
- **Características:** Parte de um ecossistema maior de email delivery

#### **5. SendGrid (Email Validation)**
**Preços Estimados (2024-2025):**
- **Free Tier:** 100 verificações/dia gratuitas
- **Pay as you go:** Preços sob consulta
- **API em tempo real:** Disponível
- **Características:** Integrado com plataforma de envio

---

## 📊 TABELA COMPARATIVA DE PREÇOS

| Provedor | 1.000 Verificações | 5.000 Verificações | 10.000 Verificações | Características |
|----------|-------------------|-------------------|---------------------|-----------------|
| **SafetyMails** | $10,01 (avulsa)<br>$10,01 (≈R$50) | $33,00 (avulsa)<br>$31,35/mês | Preço não divulgado | Créditos não expiram<br>Serviço brasileiro |
| **ZeroBounce** | ~$16/mês<br>(≈R$80) | ~$60/mês<br>(≈R$300) | Incluído em planos maiores | API robusta<br>98% precisão |
| **NeverBounce** | ~$8/mês<br>(≈R$40) | ~$40/mês<br>(≈R$200) | ~$80/mês<br>(≈R$400) | 99% precisão<br>Volume discounts |
| **Abstract API** | Grátis (100/mês)<br>$9,99 (10k) | $9,99/mês<br>(10k verificações) | $9,99/mês<br>(10k verificações) | Plano único cobre 10k<br>Múltiplas APIs |
| **Mailgun** | Grátis<br>(5k/mês) | Grátis<br>(5k/mês) | Grátis (5k) + $50 extras | 5k grátis/mês<br>Depois $0,01/verificação |

---

## 🎯 ANÁLISE DE CUSTO-BENEFÍCIO

### **Para Volume Baixo (< 1.000/mês):**
1. **Mailgun** - Grátis (5.000/mês) ✅ **MELHOR OPÇÃO**
2. **Abstract API** - Grátis (100/mês) ou $9,99 para 10k
3. **SafetyMails** - $10,01 (compra única, créditos não expiram) ✅ **BOA OPÇÃO**

### **Para Volume Médio (1.000 - 10.000/mês):**
1. **Abstract API** - $9,99/mês para 10k ✅ **MELHOR CUSTO**
2. **Mailgun** - Grátis até 5k, depois $0,01/extra
3. **SafetyMails** - $31,35/mês para 5k (mais caro que Abstract)
4. **NeverBounce** - ~$40/mês para 5k

### **Para Volume Alto (> 10.000/mês):**
1. **ZeroBounce** - Planos escaláveis com desconto por volume
2. **NeverBounce** - Volume discounts disponíveis
3. **Abstract API** - $49,99 para 100k
4. **SafetyMails** - Preços não divulgados para volumes altos

---

## ⚠️ PROBLEMA CRÍTICO IDENTIFICADO

### **Erro 403 - Origem Não Autorizada**

**Causa Mais Provável do Erro 403:**
- **Domínio não autorizado** na conta SafetyMails
- Requisições diretas de navegador podem ser bloqueadas por política de segurança
- Necessário **autorizar domínio** no painel SafetyMails

**Solução Recomendada:**
1. Acessar painel SafetyMails
2. Verificar/Configurar **"Origens Autorizadas"** ou **"Allowed Origins"**
3. Adicionar domínios:
   - `dev.bpsegurosimediato.com.br`
   - Domínio do Webflow (se aplicável)
   - `*.webflow.io` (para desenvolvimento)
4. Ou configurar para aceitar requisições de qualquer origem (não recomendado em produção)

**Alternativa Técnica:**
- Fazer requisições via **backend/proxy** ao invés de diretamente do navegador
- Criar endpoint PHP/Node que faz a requisição para SafetyMails
- Backend tem mais flexibilidade com CORS e whitelist

---

## 📝 RECOMENDAÇÕES

### **Curto Prazo (Resolver Erro 403):**
1. ✅ **Verificar/Configurar origens autorizadas** no painel SafetyMails
2. ✅ Adicionar logs detalhados para debug
3. ✅ Capturar resposta completa do erro para diagnóstico

### **Médio Prazo (Otimização de Custo):**
1. **Se volume < 1.000/mês:** Manter SafetyMails ou migrar para Mailgun (grátis)
2. **Se volume 1.000-10.000/mês:** Considerar migração para **Abstract API** ($9,99/mês para 10k)
3. **Se volume > 10.000/mês:** Avaliar ZeroBounce ou NeverBounce com volume discounts

### **Técnico:**
1. Considerar **backend proxy** para SafetyMails (resolve CORS/origem)
2. Implementar **cache** de validações para reduzir custos
3. Implementar **validação local primeiro** (regex) antes de chamar API

---

## 🔗 LINKS ÚTEIS

- **Documentação SafetyMails:** https://docs.safetymails.com
- **Preços SafetyMails:** https://www.safetymails.com/pt/verificacao-de-email-preco/
- **ZeroBounce:** https://www.zerobounce.net
- **NeverBounce:** https://neverbounce.com
- **Abstract API:** https://www.abstractapi.com
- **Mailgun:** https://www.mailgun.com

---

## ✅ CONCLUSÃO

### **Problema Principal (403):**
- **Causa mais provável:** Domínio não autorizado no SafetyMails
- **Solução:** Configurar origens autorizadas no painel da conta

### **Comparação de Preços:**
- **SafetyMails não é o mais barato** para volumes médios/altos
- **Abstract API oferece melhor custo-benefício** ($9,99 para 10k verificações)
- **Mailgun oferece 5k grátis/mês** (melhor para baixo volume)
- **SafetyMails tem vantagem** de créditos que não expiram (compra avulsa)

### **Recomendação:**
1. **Imediato:** Resolver problema de origem/autorização no SafetyMails
2. **Futuro:** Avaliar migração para Abstract API ou Mailgun dependendo do volume

---

**Status:** ✅ **Análise Completa**  
**Próxima Ação:** Configurar origens autorizadas no SafetyMails ou implementar backend proxy





