# 🔍 ANÁLISE: OCTADESK_FROM Hardcoded no Servidor DEV

**Data:** 22/11/2025  
**Servidor:** Desenvolvimento (`65.108.156.14`)  
**Arquivo Analisado:** `add_webflow_octa.php`  
**Tipo de Análise:** ⚠️ **APENAS VERIFICAÇÃO** - Nenhuma alteração realizada

---

## 🎯 OBJETIVO

Verificar se o número `OCTADESK_FROM` está em hardcode no arquivo `add_webflow_octa.php` do servidor de desenvolvimento.

---

## 📋 RESULTADO DA ANÁLISE

### 🔴 **NÚMERO HARDCODED ENCONTRADO**

#### **Localização no Arquivo:**

**Linha 56 do arquivo `/var/www/html/dev/root/add_webflow_octa.php`:**

```php
$OCTADESK_FROM = '+551132301422'; // TODO: Mover para variável de ambiente se necessário
```

#### **Status:**
- 🔴 **HARDCODED** - Valor está diretamente no código
- ⚠️ **Comentário TODO:** Indica que deveria ser movido para variável de ambiente
- ❌ **Não usa variável de ambiente** - Não há verificação de `$_ENV['OCTADESK_FROM']`

---

## 🔍 ANÁLISE DETALHADA

### **1. Valor Hardcoded:**

**Linha 56:**
```php
$OCTADESK_FROM = '+551132301422'; // TODO: Mover para variável de ambiente se necessário
```

**Valor:** `+551132301422`  
**Tipo:** Número de telefone remetente OctaDesk  
**Formato:** E.164 (com código do país +55)

---

### **2. Uso da Variável no Arquivo:**

**Linha 139 (função `sendToOctaDesk`):**
```php
global $API_BASE, $OCTADESK_FROM, $URL_SEND_TPL, $URL_CONTACTS;
```

**Linha 215 (payload do send-template):**
```php
'origin' => ['from' => ['number' => $OCTADESK_FROM]],
```

**Status:** Variável é usada corretamente no código, mas valor está hardcoded

---

## 📊 COMPARAÇÃO DEV vs PROD

### **Arquivo `add_webflow_octa.php`:**

| Ambiente | Linha | Valor Hardcoded | Status |
|----------|-------|-----------------|--------|
| **DEV** | 56 | `'+551132301422'` | 🔴 **HARDCODED** |
| **PROD** | 62 | `'+551132301422'` | 🔴 **HARDCODED** |

**Conclusão:** Ambos os ambientes têm o mesmo valor hardcoded

---

## 🔍 VERIFICAÇÃO DE VARIÁVEIS DE AMBIENTE

### **No PHP-FPM:**

| Ambiente | Variável `OCTADESK_FROM` | Status |
|----------|--------------------------|--------|
| **DEV** | ❌ Não existe | Não configurada |
| **PROD** | ❌ Não existe | Não configurada |

**Conclusão:** Variável não existe em nenhum dos ambientes

---

## 📋 RESUMO EXECUTIVO

### **Situação Atual:**

1. ✅ **Arquivo DEV:** Número está hardcoded na linha 56
2. ✅ **Arquivo PROD:** Número está hardcoded na linha 62
3. ❌ **PHP-FPM DEV:** Variável `OCTADESK_FROM` não existe
4. ❌ **PHP-FPM PROD:** Variável `OCTADESK_FROM` não existe
5. ⚠️ **Comentário TODO:** Indica intenção de mover para variável de ambiente

### **Valor Hardcoded:**
- **Número:** `+551132301422`
- **Formato:** E.164 (com código do país Brasil +55)
- **Uso:** Número remetente para envio de templates WhatsApp via OctaDesk

---

## 🔴 PROBLEMA IDENTIFICADO

### **Hardcode Confirmado:**

- ✅ **Número está hardcoded** no arquivo `add_webflow_octa.php` do servidor DEV
- ✅ **Valor:** `+551132301422`
- ✅ **Localização:** Linha 56
- ⚠️ **Comentário TODO:** Indica que deveria ser movido para variável de ambiente

---

## 📝 RECOMENDAÇÃO

### **Para Corrigir:**

**1. Adicionar variável ao PHP-FPM config (`/etc/php/8.3/fpm/pool.d/www.conf`):**
```ini
env[OCTADESK_FROM] = +551132301422
```

**2. Atualizar código para usar variável de ambiente:**
```php
// ❌ ATUAL (Hardcoded):
$OCTADESK_FROM = '+551132301422'; // TODO: Mover para variável de ambiente se necessário

// ✅ RECOMENDADO (Variável de Ambiente):
$OCTADESK_FROM = $_ENV['OCTADESK_FROM'] ?? '+551132301422';
```

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- **Verificação DEV:** `VERIFICACAO_OCTADESK_FROM_DEV.md`
- **Verificação PROD:** `VERIFICACAO_VARIAVEIS_OCTADESK_PRODUCAO.md`
- **Análise de Keys Hardcoded:** `ANALISE_KEYS_HARDCODE_PRODUCAO.md`

---

**Última Atualização:** 22/11/2025  
**Status:** ✅ **ANÁLISE CONCLUÍDA** - Nenhuma alteração realizada (conforme solicitado)

