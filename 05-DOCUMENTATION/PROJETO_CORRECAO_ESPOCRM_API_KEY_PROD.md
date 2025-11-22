# 📋 PROJETO: Correção ESPOCRM_API_KEY - PROD

**Data de Criação:** 16/11/2025  
**Status:** 📋 **PRONTO PARA IMPLEMENTAÇÃO**  
**Prioridade:** 🔴 **ALTA** (Erro HTTP 401 em produção)

---

## 🎯 OBJETIVO

Corrigir a variável de ambiente `ESPOCRM_API_KEY` no PHP-FPM de produção para usar o valor correto de produção (`82d5f667f3a65a9a43341a0705be2b0c`) ao invés do valor de desenvolvimento (`73b5b7983bfc641cdba72d204a48ed9d`).

---

## 🔍 PROBLEMA IDENTIFICADO

### **Causa Raiz:**
A variável de ambiente `ESPOCRM_API_KEY` em PROD está configurada com o valor de DEV, causando erro HTTP 401 (Não autorizado) ao tentar autenticar no EspoCRM de produção.

### **Valores:**
- **Atual (incorreto):** `73b5b7983bfc641cdba72d204a48ed9d` (valor de DEV)
- **Correto (produção):** `82d5f667f3a65a9a43341a0705be2b0c` (valor de PROD)

### **Localização:**
- **Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf` (servidor PROD)
- **Arquivo Local:** `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`

---

## 🔧 SOLUÇÃO PROPOSTA

### **Modificação Necessária:**

**Arquivo:** `php-fpm_www_conf_PROD.conf`

**Antes:**
```ini
env[ESPOCRM_API_KEY] = 73b5b7983bfc641cdba72d204a48ed9d
```

**Depois:**
```ini
env[ESPOCRM_API_KEY] = 82d5f667f3a65a9a43341a0705be2b0c
```

---

## 📋 FASES DO PROJETO

### **FASE 1: Backup e Verificação**

**Objetivo:** Criar backup do arquivo PHP-FPM atual e verificar valor atual

**Processo:**
1. Baixar arquivo atual do servidor PROD para local (se não existir localmente)
2. Criar backup do arquivo local com timestamp
3. Verificar valor atual de `ESPOCRM_API_KEY` no arquivo

**Comandos:**
```bash
# 1. Baixar arquivo atual (se necessário)
scp root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD_ATUAL.conf

# 2. Criar backup local
cp WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf.backup_ANTES_CORRECAO_API_KEY_$(date +%Y%m%d_%H%M%S)

# 3. Verificar valor atual
grep "ESPOCRM_API_KEY" WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf
```

---

### **FASE 2: Modificar Localmente**

**Objetivo:** Atualizar valor de `ESPOCRM_API_KEY` no arquivo local

**Processo:**
1. Modificar arquivo local `php-fpm_www_conf_PROD.conf`
2. Alterar `env[ESPOCRM_API_KEY]` de `73b5b7983bfc641cdba72d204a48ed9d` para `82d5f667f3a65a9a43341a0705be2b0c`
3. Verificar que modificação foi aplicada corretamente

**Arquivo a Modificar:**
- `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/php-fpm_www_conf_PROD.conf`

**Linha a Modificar:**
- Localizar linha com `env[ESPOCRM_API_KEY]`
- Substituir valor

---

### **FASE 3: Backup no Servidor e Cópia**

**Objetivo:** Criar backup no servidor e copiar arquivo corrigido

**Processo:**
1. Criar backup do arquivo atual no servidor PROD
2. Copiar arquivo corrigido do Windows para servidor PROD
3. Verificar hash SHA256 após cópia

**Comandos:**
```bash
# 1. Criar backup no servidor
ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_ANTES_CORRECAO_API_KEY_\$(date +%Y%m%d_%H%M%S)"

# 2. Copiar arquivo corrigido para servidor
scp "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_www_conf_PROD.conf" root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf

# 3. Verificar hash SHA256
# Local
Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_www_conf_PROD.conf" -Algorithm SHA256

# Servidor
ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf | cut -d' ' -f1"
```

---

### **FASE 4: Reiniciar PHP-FPM e Verificar**

**Objetivo:** Aplicar mudanças e verificar funcionamento

**Processo:**
1. Testar sintaxe do arquivo PHP-FPM
2. Reiniciar PHP-FPM
3. Verificar variável de ambiente após reinício
4. Testar autenticação com EspoCRM

**Comandos:**
```bash
# 1. Testar sintaxe
ssh root@157.180.36.223 "php-fpm -t"

# 2. Reiniciar PHP-FPM
ssh root@157.180.36.223 "systemctl restart php8.3-fpm"

# 3. Verificar status
ssh root@157.180.36.223 "systemctl status php8.3-fpm"

# 4. Verificar variável de ambiente
ssh root@157.180.36.223 "php -r \"echo getenv('ESPOCRM_API_KEY');\""
```

---

### **FASE 5: Teste e Validação**

**Objetivo:** Validar que correção funcionou

**Processo:**
1. Submeter formulário de teste em produção
2. Verificar logs do `add_flyingdonkeys.php`
3. Confirmar que não há mais erro HTTP 401
4. Confirmar que autenticação funciona corretamente

**Verificações:**
- ✅ Log `flyingdonkeys_exception` não deve conter `http_code: 401`
- ✅ Log `flyingdonkeys_lead_created` deve ser gerado (se lead criado)
- ✅ Nenhum erro de autenticação nos logs

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

- [ ] FASE 1: Backup criado (local e servidor)
- [ ] FASE 2: Arquivo modificado localmente
- [ ] FASE 3: Arquivo copiado para servidor
- [ ] FASE 3: Hash SHA256 verificado
- [ ] FASE 4: Sintaxe PHP-FPM testada
- [ ] FASE 4: PHP-FPM reiniciado
- [ ] FASE 4: Variável de ambiente verificada
- [ ] FASE 5: Teste realizado
- [ ] FASE 5: Logs verificados
- [ ] FASE 5: Autenticação funcionando

---

## 🚨 AVISOS IMPORTANTES

### **1. Backup Obrigatório**
- ✅ **SEMPRE criar backup** antes de modificar arquivo PHP-FPM
- ✅ Backup local e no servidor

### **2. Reinício do PHP-FPM**
- ⚠️ **OBRIGATÓRIO:** Reiniciar PHP-FPM após modificar variáveis de ambiente
- ⚠️ Variáveis de ambiente são carregadas apenas no início do processo

### **3. Verificação de Hash**
- ✅ **OBRIGATÓRIO:** Verificar hash SHA256 após cópia
- ✅ Garantir integridade do arquivo

### **4. Teste em Produção**
- ⚠️ Testar imediatamente após correção
- ⚠️ Verificar logs para confirmar funcionamento

---

## 📝 NOTAS

- A correção é simples (apenas uma linha)
- Não requer modificação de código PHP
- Apenas atualização de variável de ambiente
- Impacto: Baixo (apenas reinício do PHP-FPM)

---

**Status:** 📋 **PRONTO PARA IMPLEMENTAÇÃO**

