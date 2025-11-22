# 🔍 DIAGNÓSTICO: Região AWS SES

**Data:** 21/11/2025  
**Status:** 🔍 **INVESTIGAÇÃO**

---

## 🔍 PROBLEMA IDENTIFICADO

O usuário relata que **funcionava antes** sem precisar verificar o email FROM específico. Isso sugere que:

1. ✅ **Antes:** Credenciais antigas funcionavam
2. ❌ **Agora:** Credenciais novas não funcionam
3. ✅ **Identidades:** Todos os emails e domínios estão verificados

---

## 🎯 POSSÍVEIS CAUSAS

### **1. Região AWS Diferente**

**Evidências encontradas:**
- Backups antigos mostram: `AWS_REGION = 'sa-east-1'` (São Paulo)
- Configuração atual: `AWS_REGION = us-east-1` (N. Virginia)

**Problema:**
- Identidades verificadas em `sa-east-1` **NÃO são válidas** em `us-east-1`
- Cada região AWS SES tem suas próprias identidades verificadas

**Solução:**
- Verificar em qual região as identidades estão verificadas
- Usar a mesma região nas credenciais

### **2. Conta AWS Diferente**

**Possibilidade:**
- Credenciais antigas podem ter sido de outra conta AWS
- Nova conta AWS pode ter identidades verificadas em região diferente

**Solução:**
- Verificar qual conta AWS está sendo usada
- Confirmar região das identidades verificadas

### **3. Sandbox Mode**

**Possibilidade:**
- Mesmo com domínio verificado, no Sandbox pode precisar verificar emails específicos
- Mas usuário diz que funcionava antes...

**Solução:**
- Verificar se está em Sandbox
- Solicitar saída do Sandbox se necessário

---

## ✅ VERIFICAÇÕES NECESSÁRIAS

### **1. Verificar Região das Identidades**

No Console AWS SES:
1. **Altere a região** no seletor do topo direito
2. **Verifique em cada região:**
   - `us-east-1` (N. Virginia)
   - `sa-east-1` (São Paulo)
   - `us-west-2` (Oregon)
3. **Veja em qual região** as identidades aparecem como "Verified"

### **2. Verificar Região Configurada**

**No servidor:**
```bash
grep AWS_REGION /etc/php/8.3/fpm/pool.d/www.conf
```

**Deve corresponder à região onde as identidades estão verificadas.**

---

## 🔧 SOLUÇÃO PROVÁVEL

**Se as identidades estão verificadas em `sa-east-1` mas estamos usando `us-east-1`:**

1. **Atualizar região no PHP-FPM:**
   ```bash
   nano /etc/php/8.3/fpm/pool.d/www.conf
   ```
   
2. **Alterar:**
   ```ini
   env[AWS_REGION] = sa-east-1
   ```
   
3. **Recarregar:**
   ```bash
   systemctl reload php8.3-fpm
   ```

---

## 📋 CHECKLIST

- [ ] Verificar em qual região as identidades estão verificadas no Console AWS SES
- [ ] Comparar com região configurada no PHP-FPM (`AWS_REGION`)
- [ ] Se diferentes, atualizar `AWS_REGION` para corresponder
- [ ] Testar envio de email novamente

---

**Documento criado em:** 21/11/2025  
**Última atualização:** 21/11/2025

