# 🔍 Análise: Restrições Webflow e CORS
## Pesquisa sobre Chamadas de API Externa em Projetos Webflow

---

## 📋 RESUMO EXECUTIVO

**Problema Identificado:** Chamadas `fetch()` do Webflow para endpoints PHP externos estão sendo bloqueadas por CORS.

**Solução Recomendada:** Configurar headers CORS no servidor PHP (nossa API) para permitir requisições do domínio Webflow.

---

## 🎯 RESTRIÇÕES DO WEBFLOW

### **1. Limitações da Plataforma**

- **Webflow hospeda em servidores próprios**: Sem acesso ao backend do Webflow
- **Custom Code é executado no frontend**: Todo código JavaScript roda no navegador do cliente
- **Sem controle sobre CORS no lado do Webflow**: Não podemos configurar headers CORS no servidor do Webflow

### **2. Políticas de Segurança**

- **CORS é obrigatório**: Navegadores bloqueiam requisições cross-origin por padrão
- **HTTPS obrigatório**: Todas as comunicações devem ser seguras
- **Não expor credenciais**: Chaves de API não devem estar no frontend

---

## ✅ SOLUÇÕES RECOMENDADAS (Documentação Webflow)

### **Opção 1: Configurar CORS no Servidor de Destino** ⭐ RECOMENDADO

**Descrição:** Configurar headers CORS no servidor PHP que recebe as requisições.

**Vantagens:**
- ✅ Solução direta e eficiente
- ✅ Mantém a arquitetura atual
- ✅ Controle total sobre segurança
- ✅ Segue padrões da indústria

**Implementação:**
```php
// Adicionar headers CORS nos endpoints PHP
header('Access-Control-Allow-Origin: https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-Requested-With, Authorization');

// Responder a requisições OPTIONS (preflight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit(0);
}
```

**Status:** ✅ Esta é a solução que devemos implementar

---

### **Opção 2: Servidor Proxy Intermediário**

**Descrição:** Criar um servidor intermediário (Cloudflare Workers, Netlify Functions) que faz as chamadas.

**Vantagens:**
- ✅ Evita problemas de CORS completamente
- ✅ Pode proteger chaves de API
- ✅ Flexibilidade adicional

**Desvantagens:**
- ❌ Complexidade adicional
- ❌ Custo e manutenção extra
- ❌ Desnecessário no nosso caso

**Status:** ❌ Não necessário (já temos controle do servidor PHP)

---

### **Opção 3: Ferramentas No-Code (Zapier, Make)**

**Descrição:** Usar plataformas de automação para fazer as chamadas.

**Vantagens:**
- ✅ Sem código necessário
- ✅ Interface visual

**Desvantagens:**
- ❌ Dependência de serviços externos
- ❌ Custos adicionais
- ❌ Menos controle

**Status:** ❌ Não adequado para nosso caso

---

## 📊 NOSSO CASO ESPECÍFICO

### **Análise da Situação**

1. **Já estamos fazendo chamadas `fetch()` diretas:**
   - `https://rpaimediatoseguros.com.br/api/rpa/start` ✅ Funciona
   - `https://bpsegurosimediato.com.br/dev/webhooks/add_travelangels.php` ❌ Bloqueado
   - `https://bpsegurosimediato.com.br/dev/webhooks/add_webflow_octa.php` ❌ Bloqueado

2. **Diferença:**
   - A API RPA provavelmente já tem CORS configurado
   - Os endpoints PHP de desenvolvimento não têm CORS

3. **Conclusão:**
   - Precisamos adicionar headers CORS nos endpoints PHP
   - Esta é a solução padrão e recomendada

---

## 🔒 SEGURANÇA E BOAS PRÁTICAS

### **Recomendações da Documentação Webflow:**

1. **Validar e Sanitizar no Servidor:**
   - ✅ Já fazemos (validação de signature Webflow)
   - ✅ Validação de dados no PHP

2. **Usar HTTPS:**
   - ✅ Todas as URLs já são HTTPS

3. **Não Expor Credenciais no Frontend:**
   - ✅ Chaves de API estão apenas no servidor
   - ✅ Signature validation no servidor

4. **Headers CORS Específicos (não `*` para produção):**
   ```php
   // Desenvolvimento: Pode usar wildcard ou específico
   header('Access-Control-Allow-Origin: https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io');
   
   // Produção: ESPECÍFICO para o domínio do site
   header('Access-Control-Allow-Origin: https://www.bpsegurosimediato.com.br');
   ```

---

## 📝 IMPLEMENTAÇÃO RECOMENDADA

### **Para Desenvolvimento:**

```php
// Permitir requisições do Webflow staging
$allowed_origins = [
    'https://segurosimediato-8119bf26e77bf4ff336a58e.webflow.io',
    'https://dev.bpsegurosimediato.com.br'
];

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if (in_array($origin, $allowed_origins)) {
    header("Access-Control-Allow-Origin: $origin");
}

header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-Requested-With, Authorization');
header('Access-Control-Max-Age: 86400'); // 24 horas

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit(0);
}
```

### **Para Produção:**

```php
// Permitir apenas domínios específicos
$allowed_origins = [
    'https://www.bpsegurosimediato.com.br',
    'https://bpsegurosimediato.com.br'
];

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
if (in_array($origin, $allowed_origins)) {
    header("Access-Control-Allow-Origin: $origin");
}

header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-Requested-With, Authorization');
header('Access-Control-Max-Age: 86400');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit(0);
}
```

---

## ✅ CONCLUSÃO

**Solução Definida:** Adicionar headers CORS nos endpoints PHP de desenvolvimento.

**Justificativa:**
1. ✅ Segue as melhores práticas recomendadas pela documentação Webflow
2. ✅ Solução padrão da indústria para APIs REST
3. ✅ Mantém a arquitetura atual (sem proxy intermediário)
4. ✅ Controle total sobre segurança
5. ✅ Já está sendo usado com sucesso na API RPA

**Arquivos a Modificar:**
- `/var/www/html/dev/webhooks/add_travelangels.php`
- `/var/www/html/dev/webhooks/add_webflow_octa.php`

**Ordem de Implementação:**
1. ✅ Adicionar headers CORS nos endpoints de desenvolvimento
2. ✅ Testar com requisições do Webflow
3. ✅ Após validação, aplicar mesma configuração em produção

---

**Fontes:**
- Webflow Community Forum
- Flowvibe Studio - Blog sobre CORS no Webflow
- Startbit - Artigo sobre CORS e políticas de segurança

**Data da Análise:** 2025-10-29











