# Validação do Código Webflow para Produção

**Data:** 2025-11-23 09:07:00
**Objetivo:** Validar código HTML que será inserido no custom code do Webflow

---

## Código Fornecido

```html
<!-- 1. Carregar variáveis de ambiente do PHP (OBRIGATÓRIO - ANTES do script principal) -->
<script src="https://prod.bssegurosimediato.com.br/config_env.js.php"></script>

<!-- 2. Carregar script principal (usa variáveis do window injetadas pelo PHP) -->
<script 
    src="https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js"
    data-app-base-url="https://prod.bssegurosimediato.com.br"
    data-app-environment="production"
    data-rpa-enabled="false"
    data-use-phone-api="true"
    data-validar-ph3a="false"
    data-success-page-url="https://www.segurosimediato.com.br/sucesso"
    data-whatsapp-api-base="https://api.whatsapp.com"
    data-whatsapp-phone="551132301422"
    data-whatsapp-default-message="Ola.%20Quero%20fazer%20uma%20cotacao%20de%20seguro."
></script>
```

---

## Validação Detalhada

### ✅ 1. Ordem de Carregamento

**Status:** ✅ **CORRETO**

- `config_env.js.php` é carregado ANTES de `FooterCodeSiteDefinitivoCompleto.js`
- Isso é obrigatório porque `FooterCodeSiteDefinitivoCompleto.js` depende das variáveis injetadas pelo PHP
- Ordem correta: PHP primeiro → JavaScript depois

---

### ✅ 2. URLs dos Arquivos

**Status:** ✅ **CORRETO**

- `config_env.js.php`: `https://prod.bssegurosimediato.com.br/config_env.js.php` ✅
- `FooterCodeSiteDefinitivoCompleto.js`: `https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js` ✅
- Ambos apontam para o servidor de produção correto

---

### ✅ 3. Data-Attributes Obrigatórios

#### 3.1. `data-app-base-url`
- **Valor fornecido:** `https://prod.bssegurosimediato.com.br`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 707-712 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.APP_BASE_URL` usado para construir URLs de endpoints

#### 3.2. `data-app-environment`
- **Valor fornecido:** `production`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 130-140 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.APP_ENVIRONMENT` usado para detectar ambiente

#### 3.3. `data-rpa-enabled`
- **Valor fornecido:** `false`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 175 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.RPA_ENABLED` (boolean) usado para habilitar/desabilitar RPA

#### 3.4. `data-use-phone-api`
- **Valor fornecido:** `true`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 176 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.USE_PHONE_API` (boolean) usado para habilitar API de telefone

#### 3.5. `data-validar-ph3a`
- **Valor fornecido:** `false`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 177 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.VALIDAR_PH3A` (boolean) usado para habilitar validação PH3A

#### 3.6. `data-success-page-url`
- **Valor fornecido:** `https://www.segurosimediato.com.br/sucesso`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 178 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.SUCCESS_PAGE_URL` usado para redirecionamento após sucesso

#### 3.7. `data-whatsapp-api-base`
- **Valor fornecido:** `https://api.whatsapp.com`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 179 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.WHATSAPP_API_BASE` usado para API do WhatsApp

#### 3.8. `data-whatsapp-phone`
- **Valor fornecido:** `551132301422`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 184 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.WHATSAPP_PHONE` usado para número do WhatsApp

#### 3.9. `data-whatsapp-default-message`
- **Valor fornecido:** `Ola.%20Quero%20fazer%20uma%20cotacao%20de%20seguro.`
- **Status:** ✅ **CORRETO**
- **Validação no código:** Linha 185 do `FooterCodeSiteDefinitivoCompleto.js`
- **Função:** Define `window.WHATSAPP_DEFAULT_MESSAGE` usado para mensagem padrão do WhatsApp
- **Observação:** Mensagem está URL-encoded (correto para uso em links WhatsApp)

---

### ✅ 4. Valores dos Data-Attributes

#### 4.1. Ambiente de Produção
- **`data-app-environment="production"`** ✅ Correto para produção
- **`data-app-base-url="https://prod.bssegurosimediato.com.br"`** ✅ Correto para produção

#### 4.2. Configurações de Funcionalidades
- **`data-rpa-enabled="false"`** ✅ RPA desabilitado em produção (correto)
- **`data-use-phone-api="true"`** ✅ API de telefone habilitada (correto)
- **`data-validar-ph3a="false"`** ✅ Validação PH3A desabilitada (correto)

#### 4.3. URLs e Endpoints
- **`data-success-page-url="https://www.segurosimediato.com.br/sucesso"`** ✅ URL de produção correta
- **`data-whatsapp-api-base="https://api.whatsapp.com"`** ✅ API oficial do WhatsApp

#### 4.4. WhatsApp
- **`data-whatsapp-phone="551132301422"`** ✅ Número correto (formato E.164 sem +)
- **`data-whatsapp-default-message="Ola.%20Quero%20fazer%20uma%20cotacao%20de%20seguro."`** ✅ Mensagem URL-encoded correta

---

### ✅ 5. Sintaxe HTML

**Status:** ✅ **CORRETO**

- Tags `<script>` corretamente fechadas
- Atributos `data-*` com valores entre aspas duplas
- Comentários HTML corretos
- Formatação legível

---

### ✅ 6. Compatibilidade com Código Deployado

**Status:** ✅ **COMPATÍVEL**

- Todos os data-attributes fornecidos são lidos pelo código JavaScript
- Funções `getRequiredDataAttribute()` e `getRequiredBooleanDataAttribute()` estão implementadas
- Código valida todos os atributos obrigatórios
- Fail-fast implementado para atributos faltando

---

## Resumo da Validação

| Item | Status | Observações |
|------|--------|-------------|
| Ordem de carregamento | ✅ | Correto - PHP antes de JS |
| URLs dos arquivos | ✅ | Ambas apontam para produção |
| Data-attributes obrigatórios | ✅ | Todos os 9 atributos presentes |
| Valores dos atributos | ✅ | Valores corretos para produção |
| Sintaxe HTML | ✅ | Sintaxe válida |
| Compatibilidade | ✅ | Compatível com código deployado |

---

## Conclusão

### ✅ **CÓDIGO APROVADO PARA PRODUÇÃO**

O código fornecido está **100% correto** e pronto para ser inserido no custom code do Webflow.

**Todos os requisitos foram atendidos:**
- ✅ Ordem de carregamento correta
- ✅ URLs apontando para produção
- ✅ Todos os data-attributes obrigatórios presentes
- ✅ Valores corretos para ambiente de produção
- ✅ Sintaxe HTML válida
- ✅ Compatível com código JavaScript deployado

**Nenhuma alteração necessária.**

---

## Próximos Passos

1. ✅ Copiar código para o custom code do Webflow
2. ✅ Publicar alterações no Webflow
3. ✅ Testar funcionalidades após publicação
4. ✅ Verificar console do navegador para erros
5. ✅ Validar que variáveis estão sendo carregadas corretamente

---

**Status Final:** ✅ **APROVADO PARA PRODUÇÃO**

