# 🔧 GUIA: Diagnóstico de Conectividade - Servidores Hetzner

**Data:** 24/11/2025  
**Versão:** 1.0.0  
**Script:** `diagnostico_conectividade_hetzner.ps1`

---

## 📋 OBJETIVO

Este script realiza diagnóstico completo de conectividade com os servidores Hetzner, identificando problemas de:
- Resolução DNS
- Conectividade de rede (ping)
- Conectividade TCP (porta 443)
- Certificados SSL/TLS
- Acessibilidade de endpoints HTTP/HTTPS

---

## 🚀 COMO USAR

### **1. Executar Localmente (Windows):**

```powershell
cd "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\scripts"
.\diagnostico_conectividade_hetzner.ps1
```

**O que faz:**
- Testa conectividade do seu computador Windows para os servidores Hetzner
- Útil para verificar se o problema é local ou no servidor de produção

---

### **2. Executar no Servidor de Produção (via SSH):**

```powershell
cd "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\scripts"
.\diagnostico_conectividade_hetzner.ps1 -ServidorProd
```

**O que faz:**
- Executa diagnóstico no servidor de produção via SSH
- Testa conectividade do servidor de produção para os servidores Hetzner
- **Mais relevante** para diagnosticar problemas reais de produção

---

## 🔍 TESTES REALIZADOS

### **1. Resolução DNS**

**O que testa:**
- Se os domínios (`bpsegurosimediato.com.br`, etc.) são resolvidos corretamente
- Qual IP é retornado para cada domínio

**Possíveis problemas:**
- DNS não resolve → Problema de DNS
- IP incorreto → Problema de configuração DNS

---

### **2. Teste de Ping**

**O que testa:**
- Se há conectividade básica de rede (ICMP)
- Latência média de resposta
- Perda de pacotes

**Possíveis problemas:**
- Ping falha → Problema de conectividade de rede
- Alta latência → Problema de rota ou rede lenta
- Perda de pacotes → Problema de estabilidade de rede

---

### **3. Conectividade TCP (Porta 443)**

**O que testa:**
- Se a porta 443 (HTTPS) está acessível
- Se há firewall bloqueando a conexão
- Timeout de conexão

**Possíveis problemas:**
- Conexão TCP falha → Firewall bloqueando ou porta fechada
- Timeout → Problema de rede ou servidor não responde

---

### **4. Certificados SSL/TLS**

**O que testa:**
- Se o certificado SSL/TLS é válido
- Se não está expirado
- Se a cadeia de certificados está completa

**Possíveis problemas:**
- Certificado inválido → Certificado expirado ou inválido
- Erro de SSL → Problema na cadeia de certificados

---

### **5. Endpoints HTTP/HTTPS**

**O que testa:**
- Se os endpoints estão acessíveis via HTTP/HTTPS
- Status code retornado
- Tempo de resposta
- Timeout de conexão

**Possíveis problemas:**
- Timeout → Problema de conectividade ou servidor lento
- Erro DNS → Problema de resolução de DNS
- Erro SSL → Problema de certificado
- Status 500 → Erro no servidor (mas conectividade OK)

---

## 📊 INTERPRETAÇÃO DOS RESULTADOS

### **✅ Todos os Testes Passaram:**

```
✅ Todos os endpoints estão acessíveis
```

**Significado:**
- Conectividade está OK no momento do teste
- Problema pode ser intermitente
- Verificar logs históricos para identificar padrão

---

### **⚠️ Alguns Testes Falharam:**

```
⚠️ PROBLEMAS IDENTIFICADOS:
   ❌ EspoCRM (FlyingDonkeys) - PROD
      URL: https://bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php
      Erro: Timeout ao acessar endpoint (30s)
```

**Significado:**
- Problema de conectividade identificado
- Verificar qual teste falhou:
  - **DNS:** Problema de resolução de DNS
  - **Ping:** Problema de conectividade de rede básica
  - **TCP:** Firewall bloqueando ou porta fechada
  - **SSL:** Problema de certificado
  - **HTTP:** Timeout ou erro de servidor

---

## 🔧 AÇÕES RECOMENDADAS

### **Se DNS Falhar:**

1. Verificar configuração DNS do servidor
2. Verificar se domínio está configurado corretamente
3. Verificar se há problemas conhecidos com o provedor DNS

---

### **Se Ping Falhar:**

1. Verificar conectividade de rede básica
2. Verificar se há firewall bloqueando ICMP
3. Verificar rotas de rede

---

### **Se TCP Falhar:**

1. Verificar firewall entre servidores
2. Verificar se porta 443 está aberta
3. Verificar se servidor Hetzner está acessível

---

### **Se SSL Falhar:**

1. Verificar certificado SSL/TLS
2. Verificar se certificado não está expirado
3. Verificar cadeia de certificados

---

### **Se HTTP Falhar com Timeout:**

1. **Problema mais provável:** Problema de conectividade entre servidores
2. Verificar logs de rede do servidor de produção
3. Verificar se há problemas conhecidos na Hetzner
4. Verificar latência e timeout configurados

---

## 📋 EXEMPLO DE USO

### **Cenário: Diagnosticar problema de "Load failed"**

```powershell
# 1. Executar diagnóstico no servidor de produção
.\diagnostico_conectividade_hetzner.ps1 -ServidorProd

# 2. Analisar resultados
# - Se todos passarem: Problema pode ser intermitente
# - Se falharem: Problema de conectividade identificado

# 3. Verificar logs históricos
# - Comparar com horários de erros conhecidos
# - Identificar padrão de ocorrência
```

---

## 🔗 RELAÇÃO COM ERROS IDENTIFICADOS

### **Erros "Load failed":**

- **Causa provável:** Timeout de conexão ou erro de rede
- **Diagnóstico:** Executar script e verificar:
  - Se ping funciona
  - Se TCP funciona
  - Se HTTP retorna timeout

### **Erros de Email:**

- **Causa provável:** Endpoint de email não acessível
- **Diagnóstico:** Verificar se `send_email_notification_endpoint.php` está acessível

---

## 📝 NOTAS IMPORTANTES

1. **Teste em Momento de Erro:**
   - Se possível, executar diagnóstico quando erro ocorrer
   - Isso ajuda a identificar problema em tempo real

2. **Teste Periódico:**
   - Executar diagnóstico periodicamente
   - Comparar resultados ao longo do tempo
   - Identificar padrões de instabilidade

3. **Comparar com Logs:**
   - Comparar resultados do diagnóstico com logs de erros
   - Identificar correlação entre problemas de conectividade e erros

---

## 🚨 LIMITAÇÕES

1. **Teste Momentâneo:**
   - Diagnóstico testa conectividade no momento da execução
   - Problemas intermitentes podem não ser detectados

2. **Não Testa Carga:**
   - Não testa comportamento sob carga
   - Não identifica problemas de performance sob alta demanda

3. **Não Testa Todos os Cenários:**
   - Testa apenas conectividade básica
   - Não testa todos os possíveis problemas de rede

---

## 📋 CHECKLIST DE DIAGNÓSTICO

### **Antes de Executar:**

- [ ] Verificar se tem acesso SSH ao servidor de produção (se usar `-ServidorProd`)
- [ ] Verificar se tem permissões necessárias
- [ ] Verificar se script está no diretório correto

### **Após Executar:**

- [ ] Analisar resultados de cada teste
- [ ] Identificar quais testes falharam
- [ ] Comparar com logs de erros conhecidos
- [ ] Documentar resultados
- [ ] Tomar ações corretivas se necessário

---

**Documento criado em:** 24/11/2025  
**Versão:** 1.0.0

