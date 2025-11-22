# 🔍 Análise: Secret Keys em Hardcode - bpsegurosimediato.com.br

**Data:** 16/11/2025  
**Objetivo:** Verificar se as secret keys dos webhooks estão em hardcode nos endpoints antigos  
**Status:** ✅ **ANÁLISE CONCLUÍDA**

---

## 📋 RESUMO EXECUTIVO

### **✅ CONCLUSÃO:**

**SIM, as secret keys estão em HARDCODE nos dois endpoints analisados.**

**Arquivos analisados:**
1. ✅ `add_flyingdonkeys_v2.php` - Secret key em hardcode
2. ✅ `add_webflow_octa_v2.php` - Secret key em hardcode

**Outras credenciais também em hardcode:**
- ⚠️ API Key do EspoCRM (FlyingDonkeys)
- ⚠️ API Key do OctaDesk

---

## 🔍 ANÁLISE DETALHADA

### **1. add_flyingdonkeys_v2.php**

#### **Secret Key do Webflow (HARDCODE):**

**Linha 52:**
```php
// ✅ SECRET DO WEBFLOW DE PRODUÇÃO (obtido do Webflow Dashboard)
$WEBFLOW_SECRET_TRAVELANGELS = 'ce051cb1d819faac5837f4e47a7fdd8cf2a8b248a2b3ecdb9ab358cfb9ed7990';
```

**Status:** ❌ **HARDCODE**
- Valor fixo no código
- Não usa variável de ambiente
- Não usa função de configuração

**Uso:**
- Linha 497: Validação de signature do Webflow
```php
if (!validateWebflowSignatureProd($raw_input, $signature, $timestamp, $WEBFLOW_SECRET_TRAVELANGELS)) {
```

#### **API Key do EspoCRM (HARDCODE):**

**Linha 629:**
```php
// ⚠️ CREDENCIAIS DE PRODUÇÃO FLYINGDONKEYS (obtidas do add_travelangels.php de produção)
$FLYINGDONKEYS_API_URL = 'https://flyingdonkeys.com.br';
$FLYINGDONKEYS_API_KEY = '82d5f667f3a65a9a43341a0705be2b0c';
```

**Status:** ❌ **HARDCODE**
- Valor fixo no código
- Não usa variável de ambiente
- Não usa função de configuração

**Uso:**
- Linha 634: Configuração do cliente EspoCRM
```php
$client->setApiKey($FLYINGDONKEYS_API_KEY);
```

---

### **2. add_webflow_octa_v2.php**

#### **Secret Key do Webflow (HARDCODE):**

**Linha 60:**
```php
$WEBFLOW_SECRET_OCTADESK = '4d012059c79aa7250f4b22825487129da9291178b17bbf1dc970de119052dc8f'; // ✅ Secret obtido do Webflow Dashboard
```

**Status:** ❌ **HARDCODE**
- Valor fixo no código
- Não usa variável de ambiente
- Não usa função de configuração

**Uso:**
- Linha 338: Validação de signature do Webflow
```php
if (!validateWebflowSignature($input, $signature, $WEBFLOW_SECRET_OCTADESK)) {
```

#### **API Key do OctaDesk (HARDCODE):**

**Linha 57:**
```php
// ⚠️ CREDENCIAIS DE PRODUÇÃO OCTADESK (obtidas do add_webflow_octa.php de produção)
$OCTADESK_API_KEY = 'b4e081fa-94ab-4456-8378-991bf995d3ea.d3e8e579-869d-4973-b34d-82391d08702b';
$API_BASE = 'https://o205242-d60.api004.octadesk.services';
$OCTADESK_FROM = '+551132301422';
```

**Status:** ❌ **HARDCODE**
- Valor fixo no código
- Não usa variável de ambiente
- Não usa função de configuração

**Uso:**
- Linha 89: Headers da requisição OctaDesk
```php
"X-API-KEY: {$OCTADESK_API_KEY}"
```

---

## 📊 COMPARAÇÃO COM IMPLEMENTAÇÃO ATUAL

### **Implementação Atual (prod.bssegurosimediato.com.br):**

#### **add_flyingdonkeys.php:**
- ✅ Usa `getWebflowSecretFlyingDonkeys()` de `config.php`
- ✅ Função tenta `$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']` primeiro
- ✅ Fallback hardcoded apenas se variável de ambiente não existir
- ✅ Usa `getEspoCrmApiKey()` de `config.php`
- ✅ Função tenta `$_ENV['ESPOCRM_API_KEY']` primeiro

#### **add_webflow_octa.php:**
- ✅ Usa `getWebflowSecretOctaDesk()` de `config.php`
- ✅ Função tenta `$_ENV['WEBFLOW_SECRET_OCTADESK']` primeiro
- ✅ Fallback hardcoded apenas se variável de ambiente não existir

### **Implementação Antiga (bpsegurosimediato.com.br):**

#### **add_flyingdonkeys_v2.php:**
- ❌ Secret key em hardcode direto
- ❌ API Key do EspoCRM em hardcode direto
- ❌ Não usa variáveis de ambiente
- ❌ Não usa funções de configuração

#### **add_webflow_octa_v2.php:**
- ❌ Secret key em hardcode direto
- ❌ API Key do OctaDesk em hardcode direto
- ❌ Não usa variáveis de ambiente
- ❌ Não usa funções de configuração

---

## ⚠️ RISCOS IDENTIFICADOS

### **1. Segurança:**
- ❌ Credenciais expostas no código fonte
- ❌ Dificuldade de rotação de chaves (requer modificação de código)
- ❌ Risco de commit acidental no Git (se versionado)

### **2. Manutenção:**
- ❌ Necessário modificar código para atualizar credenciais
- ❌ Dificuldade de gerenciar diferentes ambientes
- ❌ Não segue padrão da implementação atual

### **3. Consistência:**
- ❌ Arquitetura diferente da implementação atual
- ❌ Não usa sistema centralizado de configuração
- ❌ Dificulta migração futura

---

## 📋 RECOMENDAÇÕES

### **Opção 1: Manter Como Está (Recomendado para Fallback)**
- ✅ Servidor antigo funciona como fallback
- ✅ Não requer modificações imediatas
- ⚠️ Aceitar que credenciais estão em hardcode
- ⚠️ Documentar que servidor antigo não segue padrão atual

### **Opção 2: Atualizar para Padrão Atual (Futuro)**
- ✅ Migrar para uso de variáveis de ambiente
- ✅ Usar funções de `config.php`
- ✅ Centralizar configuração
- ⚠️ Requer acesso ao servidor `bpsegurosimediato.com.br`
- ⚠️ Requer modificação dos arquivos

### **Opção 3: Desativar Servidor Antigo (Quando Estável)**
- ✅ Eliminar necessidade de manutenção
- ✅ Reduzir complexidade
- ✅ Seguir apenas implementação atual
- ⚠️ Requer confirmação de estabilidade do servidor novo

---

## 📊 TABELA COMPARATIVA

| Aspecto | Implementação Antiga | Implementação Atual |
|---------|---------------------|-------------------|
| **Secret Key Webflow** | ❌ Hardcode direto | ✅ Variável de ambiente + fallback |
| **API Key EspoCRM** | ❌ Hardcode direto | ✅ Variável de ambiente + fallback |
| **API Key OctaDesk** | ❌ Hardcode direto | ✅ Variável de ambiente + fallback |
| **Configuração Centralizada** | ❌ Não | ✅ `config.php` |
| **Variáveis de Ambiente** | ❌ Não usa | ✅ PHP-FPM |
| **Manutenibilidade** | ❌ Baixa | ✅ Alta |
| **Segurança** | ⚠️ Média | ✅ Alta |

---

## ✅ CONCLUSÃO

### **Resposta à Pergunta:**

**SIM, as secret keys estão em HARDCODE nos endpoints antigos.**

**Detalhes:**
1. ✅ `add_flyingdonkeys_v2.php`: Secret key e API key em hardcode
2. ✅ `add_webflow_octa_v2.php`: Secret key e API key em hardcode

**Recomendação:**
- ✅ **Manter como está** por enquanto (servidor funciona como fallback)
- ✅ **Documentar** que servidor antigo não segue padrão atual
- ✅ **Considerar atualização futura** quando servidor novo estiver estável há >30 dias
- ✅ **Considerar desativação** do servidor antigo após período de estabilidade

---

**Status:** ✅ **ANÁLISE CONCLUÍDA - SECRET KEYS EM HARDCODE CONFIRMADO**

**Última atualização:** 16/11/2025

