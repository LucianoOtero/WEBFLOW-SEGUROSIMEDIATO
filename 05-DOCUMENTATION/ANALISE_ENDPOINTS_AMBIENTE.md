# 🔍 ANÁLISE DE ENDPOINTS: cpf-validate.php e add_flyingdonkeys.php

**Data:** 10/11/2025  
**Contexto:** Endpoints funcionavam em `bpsegurosimediato.com.br`, problemas são do ambiente DEV

---

## 📋 ANÁLISE DO CÓDIGO

### 1. cpf-validate.php

**Formato esperado pelo JavaScript:**
```javascript
// FooterCodeSiteDefinitivoCompleto.js linha 971-977
const cpfUrl = window.APP_BASE_URL + '/cpf-validate.php';
return fetch(cpfUrl, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ cpf: cpfValue })
});
```

**Formato de dados:**
```json
{
  "cpf": "12345678900"
}
```

**Fluxo do endpoint:**
1. Recebe POST com `{ "cpf": "..." }`
2. Faz login na API PH3A (`https://api.ph3a.com.br/DataBusca/api/Account/Login`)
3. Obtém token
4. Consulta dados do CPF (`https://api.ph3a.com.br/DataBusca/data`)
5. Retorna dados formatados

**Possíveis problemas de ambiente:**
- ❌ **Conexão com API PH3A bloqueada** (firewall, IP não autorizado)
- ❌ **Credenciais da API PH3A inválidas** (usuário/senha/api_key)
- ❌ **Timeout de rede** (API PH3A não responde a tempo)
- ❌ **SSL/TLS** (certificados ou versão de TLS incompatível)

---

### 2. add_flyingdonkeys.php

**Formato esperado pelo JavaScript:**
```javascript
// MODAL_WHATSAPP_DEFINITIVO.js linha 823-840
const endpointUrl = getEndpointUrl('flyingdonkeys');
const webhook_data = {
  name: 'Formulário de Teste',
  data: {
    'NOME': nome,
    'Email': email,
    'DDD-CELULAR': ddd,
    'CELULAR': celular,
    'CPF': cpf,
    'CEP': cep,
    'MARCA': marca,
    'PLACA': placa,
    'ANO': ano,
    'GCLID_FLD': gclid
  }
};

fetch(endpointUrl, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(webhook_data)
});
```

**Formato de dados (Modal JavaScript):**
```json
{
  "name": "Formulário de Teste",
  "data": {
    "NOME": "João Silva",
    "Email": "joao@example.com",
    "DDD-CELULAR": "11",
    "CELULAR": "987654321",
    "CPF": "12345678900",
    "CEP": "01310-100",
    "MARCA": "Honda",
    "PLACA": "ABC1234",
    "ANO": "2020",
    "GCLID_FLD": "gclid-123"
  }
}
```

**Formato de dados (Webflow API V2):**
```json
{
  "payload": {
    "name": "Formulário de Teste",
    "data": {
      "NOME": "João Silva",
      "Email": "joao@example.com",
      ...
    }
  }
}
```

**Processamento do endpoint:**
1. Recebe POST com dados
2. Detecta formato (direto ou Webflow API V2)
3. Extrai `form_data` de `data` ou `payload.data`
4. Valida campos obrigatórios: `name` (ou `NOME`) e `email` (ou `Email`)
5. Mapeia campos para formato EspoCRM
6. Envia para EspoCRM (FlyingDonkeys)
7. Retorna resposta

**Possíveis problemas de ambiente:**
- ❌ **Estrutura de dados incorreta** (teste anterior usava JSON duplo)
- ❌ **Campos obrigatórios ausentes** (`name`/`NOME` e `email`/`Email`)
- ❌ **Conexão com EspoCRM bloqueada** (firewall, IP não autorizado)
- ❌ **Credenciais EspoCRM inválidas** (URL ou API key)
- ❌ **Variáveis de ambiente não carregadas** (`ESPOCRM_URL`, `ESPOCRM_API_KEY`)

---

## 🔧 CORREÇÕES APLICADAS

### Teste Corrigido: test_endpoints_corrigido.php

**Correções:**
1. ✅ **cpf-validate.php**: Formato exato do JavaScript (`{ "cpf": "..." }`)
2. ✅ **add_flyingdonkeys.php**: Dois formatos testados:
   - Formato direto (Modal JavaScript): `{ "name": "...", "data": { ... } }`
   - Formato Webflow API V2: `{ "payload": { "name": "...", "data": { ... } } }`

**Validações:**
- ✅ Estrutura de dados idêntica ao JavaScript
- ✅ Headers corretos (`Content-Type: application/json`)
- ✅ Origin header para CORS
- ✅ Verificação de logs após cada teste

---

## 📊 VERIFICAÇÕES DE AMBIENTE

### Para cpf-validate.php:

1. **Testar conexão com API PH3A:**
```bash
curl -X POST https://api.ph3a.com.br/DataBusca/api/Account/Login \
  -H "Content-Type: application/json" \
  -d '{"UserName":"alex.kaminski@imediatoseguros.com.br","Password":"ImdSeg2025$$"}'
```

2. **Verificar se IP do servidor está autorizado na API PH3A**

3. **Verificar timeout de rede:**
```bash
curl -v --max-time 30 https://api.ph3a.com.br/DataBusca/api/Account/Login
```

### Para add_flyingdonkeys.php:

1. **Verificar variáveis de ambiente:**
```bash
php -r "require 'config.php'; echo getEspoCrmUrl();"
```

2. **Testar conexão com EspoCRM:**
```bash
curl -X GET "https://dev.flyingdonkeys.com.br/api/v1/Lead" \
  -H "X-Api-Key: [API_KEY]"
```

3. **Verificar logs do endpoint:**
```bash
tail -f /var/www/html/dev/root/logs/flyingdonkeys_dev.txt
```

---

## ✅ CONCLUSÃO

**Problemas identificados:**
1. ❌ **Teste anterior usava estrutura incorreta** (JSON duplo para `add_flyingdonkeys.php`)
2. ⚠️ **cpf-validate.php pode estar com problema de conexão com API PH3A** (ambiente)
3. ⚠️ **add_flyingdonkeys.php pode estar com problema de conexão com EspoCRM** (ambiente)

**Ações recomendadas:**
1. ✅ Executar `test_endpoints_corrigido.php` com formato correto
2. ⚠️ Verificar logs detalhados após execução
3. ⚠️ Testar conexão direta com APIs externas (PH3A e EspoCRM)
4. ⚠️ Verificar firewall e permissões de rede do servidor

---

**Status:** Teste corrigido criado e disponível em `test_endpoints_corrigido.php`

