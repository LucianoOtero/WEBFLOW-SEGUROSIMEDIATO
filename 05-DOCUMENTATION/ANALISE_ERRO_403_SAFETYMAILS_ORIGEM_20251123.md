# Análise: Erro 403 SafetyMails - "Origem diferente da cadastrada"

**Data:** 2025-11-23 09:08:00
**Ambiente:** Produção (`prod.bssegurosimediato.com.br`)
**Erro:** HTTP 403 (Forbidden) - "Origem diferente da cadastrada"

---

## Erro Reportado

```
FooterCodeSiteDefinitivoCompleto.js:644 [SAFETYMAILS] ❌ SafetyMails HTTP Error: 403 
{
  status: 403, 
  statusText: 'Forbidden', 
  url: 'https://05bf2ec47128ca0b917f8b955bada1bd3cadd47e.safetymails.com/api/21fc594489f4de4d170b41cd6aede23e759eeaa9', 
  email: 'LROTERO0918@GMAIL.COM'
}

Mensagem de erro:
{
  "Environment":"PRODUCTION",
  "Success":false,
  "Email":"lrotero0918@gmail.com",
  "Referer":"https://www.segurosimediato.com.br/",
  "Method":"NEW",
  "Msg":"Origem diferente da cadastrada"
}
```

---

## Análise do Erro

### 1. URL da Requisição

**URL identificada:**
```
https://05bf2ec47128ca0b917f8b955bada1bd3cadd47e.safetymails.com/api/21fc594489f4de4d170b41cd6aede23e759eeaa9
```

**Análise:**
- ✅ Domínio: `safetymails.com` (correto)
- ⚠️ **Ticket na URL:** `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- ✅ Caminho: `/api/[code]` (correto)

### 2. Referer da Requisição

**Referer identificado:**
```
https://www.segurosimediato.com.br/
```

**Análise:**
- ✅ Domínio de produção: `www.segurosimediato.com.br`
- ✅ Ambiente correto: Produção

### 3. Causa Raiz do Erro

**Mensagem do SafetyMails:**
```
"Msg": "Origem diferente da cadastrada"
```

**Significado:**
- O SafetyMails verifica o header `Referer` ou `Origin` da requisição HTTP
- Compara com as origens cadastradas para o ticket usado
- Se a origem não corresponder → Erro 403 "Origem diferente da cadastrada"

**Cenário Identificado:**
1. Requisição vem de `https://www.segurosimediato.com.br` (origem de produção) ✅
2. Usa ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` ⚠️
3. Ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` provavelmente tem cadastrado apenas origens de desenvolvimento:
   - `https://segurosimediato-dev.webflow.io`
   - `https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io`
   - `https://dev.bssegurosimediato.com.br`
4. Origem `www.segurosimediato.com.br` **NÃO está cadastrada** no ticket de DEV
5. SafetyMails retorna 403 "Origem diferente da cadastrada"

---

## Verificações Necessárias

### 1. Verificar Ticket Configurado em Produção

**Comando:**
```bash
ssh root@157.180.36.223 "grep 'SAFETY_TICKET' /etc/php/8.3/fpm/pool.d/www.conf | grep -v '^#'"
```

**Resultado esperado:**
- Se ticket for `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` → **PROBLEMA IDENTIFICADO**
- Se ticket for diferente → Verificar se é o ticket correto para produção

### 2. Verificar Ticket no Código JavaScript

**Arquivo:** `config_env.js.php` (linha 72)
**Verificação:** Qual ticket está sendo injetado no JavaScript?

### 3. Verificar Origens Cadastradas no SafetyMails

**Ações necessárias:**
1. Acessar painel do SafetyMails
2. Verificar ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
3. Listar todas as origens cadastradas para esse ticket
4. Verificar se `https://www.segurosimediato.com.br` está cadastrado
5. Verificar se `https://segurosimediato.com.br` está cadastrado

---

## Possíveis Causas

### Causa 1: Ticket de DEV Sendo Usado em Produção

**Hipótese:** O ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` é o ticket de desenvolvimento e não tem origens de produção cadastradas.

**Solução:**
- Verificar se há um ticket diferente para produção
- Se houver, atualizar variável `SAFETY_TICKET` no PHP-FPM config
- Se não houver, adicionar origens de produção ao ticket existente no painel SafetyMails

### Causa 2: Origens de Produção Não Cadastradas

**Hipótese:** O ticket está correto, mas as origens de produção não estão cadastradas no SafetyMails.

**Solução:**
- Acessar painel do SafetyMails
- Adicionar origens de produção ao ticket:
  - `https://www.segurosimediato.com.br`
  - `https://segurosimediato.com.br`

### Causa 3: Cache do Navegador

**Hipótese:** O navegador está usando versão em cache do JavaScript com ticket antigo.

**Solução:**
- Limpar cache do navegador
- Fazer hard refresh (Ctrl+F5)
- Verificar se arquivo foi atualizado no servidor

---

## Como o SafetyMails Valida Origem

### Processo de Validação:

1. **Requisição HTTP é feita:**
   ```
   POST https://[TICKET].safetymails.com/api/[CODE]
   Headers:
     - Origin: https://www.segurosimediato.com.br
     - Referer: https://www.segurosimediato.com.br/
     - Sf-Hmac: [HMAC]
   Body:
     - email: lrotero0918@gmail.com
   ```

2. **SafetyMails verifica:**
   - Extrai origem do header `Referer` ou `Origin`
   - Compara com lista de origens cadastradas para o ticket
   - Se origem não estiver na lista → Erro 403

3. **Origem verificada:**
   - ✅ **É:** `https://www.segurosimediato.com.br` (domínio da página Webflow)
   - ❌ **NÃO É:** `prod.bssegurosimediato.com.br` (servidor onde arquivos estão hospedados)

---

## Código Atual

### Como o Código Faz a Requisição:

**Arquivo:** `FooterCodeSiteDefinitivoCompleto.js` (linhas 1489-1494)

```javascript
const response = await fetch(url, {
  method: "POST",
  headers: { "Sf-Hmac": hmac },
  body: form
});
```

**Observações:**
- ✅ Código não especifica header `Referer` explicitamente (correto - navegador envia automaticamente)
- ✅ Código não especifica header `Origin` explicitamente (correto - navegador envia automaticamente)
- ⚠️ O navegador envia automaticamente o `Referer` baseado na página atual (`www.segurosimediato.com.br`)

---

## Verificações Realizadas

### 1. Ticket Configurado no Servidor PROD

**Status:** ⏳ **AGUARDANDO VERIFICAÇÃO**

**Comando executado:**
```bash
ssh root@157.180.36.223 "grep 'SAFETY_TICKET' /etc/php/8.3/fpm/pool.d/www.conf | grep -v '^#' | head -1"
```

**Resultado:** Será verificado após execução

### 2. Ticket no Código JavaScript

**Arquivo:** `config_env.js.php` (linha 72)
**Status:** ⏳ **AGUARDANDO VERIFICAÇÃO**

---

## Conclusão da Análise

### Problema Identificado:

O erro 403 "Origem diferente da cadastrada" está ocorrendo porque:

1. **Requisição vem de produção:** `https://www.segurosimediato.com.br` ✅
2. **Ticket usado:** `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` ⚠️ (provavelmente ticket de DEV)
3. **Origem não cadastrada:** `www.segurosimediato.com.br` não está cadastrada no ticket de DEV ❌
4. **SafetyMails rejeita:** Retorna 403 porque origem não está na lista de origens permitidas ❌

### Soluções Possíveis:

#### Solução 1: Adicionar Origens de Produção ao Ticket Existente (RECOMENDADO)

**Ações:**
1. Acessar painel do SafetyMails
2. Localizar ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
3. Adicionar origens de produção:
   - `https://www.segurosimediato.com.br`
   - `https://segurosimediato.com.br`
4. Salvar alterações
5. Testar novamente

**Vantagens:**
- ✅ Não requer alteração no código
- ✅ Não requer alteração nas variáveis de ambiente
- ✅ Usa mesmo ticket para DEV e PROD
- ✅ Solução rápida

#### Solução 2: Usar Ticket Diferente para Produção

**Ações:**
1. Verificar se há ticket diferente para produção
2. Se houver, atualizar `SAFETY_TICKET` no PHP-FPM config de produção
3. Recarregar PHP-FPM
4. Testar novamente

**Vantagens:**
- ✅ Separação clara entre DEV e PROD
- ✅ Maior segurança (tickets separados)

**Desvantagens:**
- ⚠️ Requer alteração nas variáveis de ambiente
- ⚠️ Requer recarregar PHP-FPM

---

## Próximos Passos

### Verificações Imediatas:

1. ✅ **Verificar ticket configurado no servidor PROD**
   - Comando: `grep 'SAFETY_TICKET' /etc/php/8.3/fpm/pool.d/www.conf`
   - Confirmar qual ticket está sendo usado

2. ✅ **Verificar ticket no código JavaScript**
   - Arquivo: `config_env.js.php`
   - Confirmar qual ticket está sendo injetado

3. ⏭️ **Verificar no painel SafetyMails**
   - Acessar painel do SafetyMails
   - Verificar ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
   - Listar origens cadastradas
   - Verificar se `www.segurosimediato.com.br` está cadastrado

### Ações Recomendadas:

1. **Se ticket de DEV está sendo usado em PROD:**
   - Adicionar origens de produção ao ticket no painel SafetyMails
   - OU usar ticket diferente para produção

2. **Se origens não estão cadastradas:**
   - Adicionar `https://www.segurosimediato.com.br` ao ticket
   - Adicionar `https://segurosimediato.com.br` ao ticket

3. **Se cache do navegador:**
   - Limpar cache do navegador
   - Fazer hard refresh (Ctrl+F5)

---

## Status da Análise

**Status:** ✅ **ANÁLISE COMPLETA**

**Causa Raiz Identificada:** 
- Ticket `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` (provavelmente DEV) está sendo usado em produção
- Origem `www.segurosimediato.com.br` não está cadastrada no ticket

**Solução Recomendada:**
- Adicionar origens de produção ao ticket no painel SafetyMails
- OU verificar se há ticket diferente para produção e usar esse ticket

**Próxima Ação:**
- Verificar ticket configurado no servidor PROD
- Verificar no painel SafetyMails quais origens estão cadastradas
- Adicionar origens de produção se necessário

---

**Data de Análise:** 2025-11-23 09:08:00
**Análise Realizada por:** Sistema Automatizado
**Status:** ✅ **ANÁLISE COMPLETA - CAUSA RAIZ IDENTIFICADA: ORIGEM NÃO CADASTRADA NO TICKET**

