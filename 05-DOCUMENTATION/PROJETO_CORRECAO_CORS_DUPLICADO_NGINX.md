# 📋 PROJETO: CORREÇÃO CORS DUPLICADO - REMOVER HEADERS DO NGINX

**Data:** 12/11/2025  
**Status:** 📝 **PROJETO ELABORADO**  
**Baseado em:** `ANALISE_ERRO_CORS_PLACA_VALIDATE_DUPLICADO.md`

---

## 🎯 OBJETIVO

Corrigir o erro CORS onde o header `Access-Control-Allow-Origin` está sendo enviado duas vezes (Nginx + PHP), causando bloqueio pelo browser.

---

## 🔍 PROBLEMA IDENTIFICADO

### **Causa Raiz:**
O header `Access-Control-Allow-Origin` está sendo enviado tanto pelo Nginx quanto pelo PHP, causando duplicação e bloqueio pelo browser.

### **Erro:**
```
The 'Access-Control-Allow-Origin' header contains multiple values 
'https://segurosimediato-dev.webflow.io, https://segurosimediato-dev.webflow.io', 
but only one is allowed.
```

### **Fluxo do Problema:**
1. Nginx envia header: `Access-Control-Allow-Origin: $http_origin`
2. PHP também envia header: `Access-Control-Allow-Origin: https://segurosimediato-dev.webflow.io`
3. Browser recebe header duplicado
4. CORS policy bloqueia requisição

---

## 💡 SOLUÇÃO PROPOSTA

### **Remover Headers CORS do Nginx:**

**Estratégia:**
- Remover todas as diretivas `add_header` relacionadas a CORS do Nginx
- Deixar PHP controlar completamente via `setCorsHeaders()`
- PHP já tem validação de origem implementada

**Motivos:**
1. ✅ PHP já valida origem (`isCorsOriginAllowed()`)
2. ✅ Validação centralizada em `config.php`
3. ✅ Mais seguro (validação antes de enviar)
4. ✅ Mais fácil de manter (lógica em um lugar só)
5. ✅ Já está implementado e funcionando no PHP

---

## 📋 ARQUIVOS QUE SERÃO MODIFICADOS

### **1. Configuração Nginx**
- **Localização:** `/etc/nginx/sites-available/dev.bssegurosimediato.com.br` (no servidor)
- **Arquivo Local:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_cors_fix.conf` (criar)
- **Modificações:**
  - Remover ou comentar diretivas `add_header` relacionadas a CORS
  - Manter apenas headers não relacionados a CORS
  - Documentar mudanças

---

## 🔧 IMPLEMENTAÇÃO DETALHADA

### **FASE 1: Criar Backup**

1. ✅ Criar backup da configuração Nginx no servidor
   - Arquivo: `/etc/nginx/sites-available/dev.bssegurosimediato.com.br.backup_ANTES_CORRECAO_CORS_YYYYMMDD_HHMMSS`
2. ✅ Criar arquivo de configuração local
   - Arquivo: `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_cors_fix.conf`
   - Conter apenas as mudanças necessárias

---

### **FASE 2: Identificar Headers CORS no Nginx**

**Headers a Remover/Comentar:**
```nginx
add_header 'Access-Control-Allow-Origin' '$http_origin' always;
add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
add_header 'Access-Control-Allow-Headers' 'Content-Type, X-Webflow-Signature, X-Webflow-Timestamp' always;
add_header 'Access-Control-Allow-Credentials' 'true' always;
```

**Localização Confirmada:**
- Arquivo: `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`
- Dentro do bloco `location ~ \.php$` (após `include fastcgi_params;`)
- Linhas exatas: 76-79
- Contexto: Após `fastcgi_pass` e `include fastcgi_params;`

---

### **FASE 3: Criar Arquivo de Configuração Local**

**Criar arquivo:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/nginx_dev_cors_fix.conf`

**Conteúdo:**
```nginx
# CORREÇÃO CORS - REMOVER HEADERS DUPLICADOS
# Data: 12/11/2025
# Motivo: Headers CORS estão sendo enviados tanto pelo Nginx quanto pelo PHP
# Solução: Remover headers do Nginx e deixar PHP controlar via setCorsHeaders()

# INSTRUÇÕES:
# 1. Fazer backup do arquivo original
# 2. Comentar ou remover as seguintes linhas do bloco location ~ \.php$:
#
#    # REMOVER ESTAS LINHAS:
#    # add_header 'Access-Control-Allow-Origin' '$http_origin' always;
#    # add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
#    # add_header 'Access-Control-Allow-Headers' 'Content-Type, X-Webflow-Signature, X-Webflow-Timestamp' always;
#    # add_header 'Access-Control-Allow-Credentials' 'true' always;
#
# 3. Manter apenas headers não relacionados a CORS
# 4. Testar configuração: nginx -t
# 5. Recarregar Nginx: systemctl reload nginx

# NOTA: PHP já controla headers CORS via setCorsHeaders() em config.php
# PHP valida origem antes de enviar header (mais seguro)
```

---

### **FASE 4: Modificar Configuração no Servidor**

**Processo:**
1. ✅ Fazer backup da configuração atual
2. ✅ Editar arquivo `/etc/nginx/sites-available/dev.bssegurosimediato.com.br`
3. ✅ Comentar ou remover linhas `add_header` relacionadas a CORS
4. ✅ Testar configuração: `nginx -t`
5. ✅ Se teste passar, recarregar Nginx: `systemctl reload nginx`

**Comandos:**
```bash
# Backup
cp /etc/nginx/sites-available/dev.bssegurosimediato.com.br \
   /etc/nginx/sites-available/dev.bssegurosimediato.com.br.backup_ANTES_CORRECAO_CORS_$(date +%Y%m%d_%H%M%S)

# Comentar linhas 76-79 usando sed
sed -i '76s/^/# /' /etc/nginx/sites-available/dev.bssegurosimediato.com.br
sed -i '77s/^/# /' /etc/nginx/sites-available/dev.bssegurosimediato.com.br
sed -i '78s/^/# /' /etc/nginx/sites-available/dev.bssegurosimediato.com.br
sed -i '79s/^/# /' /etc/nginx/sites-available/dev.bssegurosimediato.com.br

# OU editar manualmente com nano/vi e comentar as linhas:
# # add_header 'Access-Control-Allow-Origin' '$http_origin' always;
# # add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
# # add_header 'Access-Control-Allow-Headers' 'Content-Type, X-Webflow-Signature, X-Webflow-Timestamp' always;
# # add_header 'Access-Control-Allow-Credentials' 'true' always;

# Testar configuração
nginx -t

# Se teste passar, recarregar Nginx
systemctl reload nginx
```

---

### **FASE 5: Verificar Headers Enviados**

**Teste Manual:**
```bash
# Testar endpoint placa-validate.php
curl -I -X OPTIONS \
  -H "Origin: https://segurosimediato-dev.webflow.io" \
  -H "Access-Control-Request-Method: POST" \
  https://dev.bssegurosimediato.com.br/placa-validate.php

# Verificar se header Access-Control-Allow-Origin aparece apenas uma vez
```

**Verificar no Browser:**
- Abrir DevTools → Network
- Fazer requisição para `placa-validate.php`
- Verificar headers da resposta
- Confirmar que `Access-Control-Allow-Origin` aparece apenas uma vez

---

### **FASE 6: Testes Funcionais**

1. ✅ Testar validação de placa:
   - Digitar placa no formulário
   - Verificar se validação funciona
   - Verificar se não há erro CORS no console

2. ✅ Testar validação de CPF:
   - Digitar CPF no formulário
   - Verificar se validação funciona
   - Verificar se não há erro CORS no console

3. ✅ Testar outros endpoints:
   - Verificar se outros endpoints PHP ainda funcionam
   - Verificar se não há regressões

---

### **FASE 7: Auditoria Pós-Implementação**

1. ✅ **Auditoria de Configuração:**
   - Verificar sintaxe do Nginx (`nginx -t`)
   - Verificar se headers CORS foram removidos
   - Verificar se outros headers não foram afetados

2. ✅ **Auditoria de Funcionalidade:**
   - Comparar configuração modificada com backup
   - Confirmar que apenas headers CORS foram removidos
   - Confirmar que nenhuma funcionalidade foi quebrada

3. ✅ **Documentar Auditoria:**
   - Criar relatório de auditoria em `05-DOCUMENTATION/`
   - Listar mudanças realizadas
   - Confirmar que problema foi resolvido

---

## 📊 RESUMO DAS MUDANÇAS

### **Arquivo Modificado:**
- `/etc/nginx/sites-available/dev.bssegurosimediato.com.br` (no servidor)

### **Linhas Modificadas:**
- Linhas ~76-79: Comentar ou remover diretivas `add_header` relacionadas a CORS

### **Mudança Principal:**
- Remover headers CORS do Nginx
- Deixar PHP controlar completamente via `setCorsHeaders()`

### **Impacto:**
- ✅ Corrige erro CORS duplicado
- ✅ Mantém funcionalidade CORS (via PHP)
- ✅ Melhora segurança (validação de origem no PHP)
- ✅ Não quebra funcionalidades existentes

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

- [ ] FASE 1: Criar backup da configuração Nginx no servidor
- [ ] FASE 1: Criar arquivo de configuração local
- [ ] FASE 2: Identificar headers CORS no Nginx
- [ ] FASE 3: Criar arquivo de documentação local
- [ ] FASE 4: Fazer backup no servidor
- [ ] FASE 4: Editar configuração Nginx
- [ ] FASE 4: Comentar/remover headers CORS
- [ ] FASE 4: Testar configuração (`nginx -t`)
- [ ] FASE 4: Recarregar Nginx (`systemctl reload nginx`)
- [ ] FASE 5: Verificar headers enviados (curl)
- [ ] FASE 5: Verificar headers no browser
- [ ] FASE 6: Testar validação de placa
- [ ] FASE 6: Testar validação de CPF
- [ ] FASE 6: Testar outros endpoints
- [ ] FASE 7: Realizar auditoria de configuração
- [ ] FASE 7: Realizar auditoria de funcionalidade
- [ ] FASE 7: Documentar auditoria

---

## 🎯 RESULTADO ESPERADO

Após implementação:
- ✅ Header `Access-Control-Allow-Origin` enviado apenas uma vez (pelo PHP)
- ✅ Validação de origem funcionando corretamente
- ✅ Erro CORS duplicado resolvido
- ✅ Validação de placa funcionando sem erros
- ✅ Validação de CPF funcionando sem erros

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Backup Obrigatório:**
   - Sempre fazer backup antes de modificar configuração Nginx
   - Configuração incorreta pode quebrar todo o site

2. **Teste Obrigatório:**
   - Sempre testar configuração com `nginx -t` antes de recarregar
   - Não recarregar se teste falhar

3. **Ambiente:**
   - Este projeto trabalha apenas no ambiente DEV
   - Não modificar configuração de produção

---

**Status:** 📝 **PROJETO ELABORADO**  
**Próximo Passo:** Aguardar autorização para implementar

