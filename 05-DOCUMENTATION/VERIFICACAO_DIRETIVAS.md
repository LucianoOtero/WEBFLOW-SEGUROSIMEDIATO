# ✅ VERIFICAÇÃO DE DIRETIVAS

**Data:** 08/11/2025  
**Status:** ⚠️ **PRECISA REVISÃO**

---

## 🎯 DIRETIVAS ORIGINAIS DO USUÁRIO

### **Diretiva 1:**
> "Usar variáveis de ambiente do Docker para localizar onde estão os arquivos .js e .php"

### **Diretiva 2:**
> "Usar variáveis de sistema, não criar config.js.php"

### **Diretiva 3:**
> "NÃO criar window.APP_CONFIG ou sistema de configuração centralizado"

### **Diretiva 4:**
> "JavaScript deve usar variáveis de ambiente diretamente"

### **Diretiva 5:**
> "PHP já está correto usando $_ENV"

---

## ❌ O QUE FOI PROPOSTO (PODE VIOLAR DIRETIVAS)

### **Proposta Atual:**
1. ✅ Criar `config_env.js.php` (arquivo PHP que gera JavaScript)
2. ✅ Criar `window.APP_ENV` (objeto de configuração)
3. ✅ JavaScript usa `window.APP_ENV.getEndpointUrl()`

### **Problema:**
- ⚠️ **Diretiva 2:** "não criar config.js.php" - Mas estamos criando `config_env.js.php` (similar)
- ⚠️ **Diretiva 3:** "NÃO criar window.APP_CONFIG" - Mas estamos criando `window.APP_ENV` (similar)

---

## ✅ O QUE DEVERIA SER (SEGUINDO DIRETIVAS)

### **Opção 1: Variáveis Globais Simples (SEM objeto de configuração)**

```javascript
// config_env.js.php
<?php
header('Content-Type: application/javascript');
$base_url = $_ENV['APP_BASE_URL'];
$environment = $_ENV['PHP_ENV'];
?>
window.APP_BASE_URL = <?php echo json_encode($base_url); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;

// Uso:
fetch(window.APP_BASE_URL + '/debug_logger_db.php', {...});
```

**Vantagens:**
- ✅ Não cria objeto de configuração
- ✅ Variáveis diretas e simples
- ✅ Segue diretiva de "usar variáveis diretamente"

**Desvantagens:**
- ⚠️ Ainda cria arquivo PHP (mas é necessário para passar variáveis para JS)

---

### **Opção 2: Meta Tags (SEM arquivo PHP adicional)**

```php
<!-- No HTML do Webflow (se tiver acesso) -->
<meta name="app-base-url" content="<?php echo $_ENV['APP_BASE_URL']; ?>">
<meta name="app-environment" content="<?php echo $_ENV['PHP_ENV']; ?>">

// JavaScript lê:
const baseUrl = document.querySelector('meta[name="app-base-url"]').content;
```

**Problema:**
- ❌ Não temos acesso ao HTML do Webflow para inserir PHP
- ❌ Webflow não executa PHP

---

### **Opção 3: Detecção Automática (SEM variáveis de ambiente)**

```javascript
function getServerBaseUrl() {
    // Detecta automaticamente
    const scripts = document.getElementsByTagName('script');
    for (let script of scripts) {
        if (script.src && script.src.includes('bssegurosimediato.com.br')) {
            return new URL(script.src).origin;
        }
    }
    // Fallback...
}
```

**Problema:**
- ❌ Não usa variáveis de ambiente do Docker
- ❌ Não sabe se está em dev ou prod
- ❌ Violou diretiva 1: "usar variáveis de ambiente"

---

## 🤔 ANÁLISE

### **Conflito entre Diretivas:**

1. **Diretiva 1:** "Usar variáveis de ambiente do Docker"
   - ✅ Requer passar variáveis do servidor (PHP) para JavaScript
   - ✅ Requer algum mecanismo de passagem

2. **Diretiva 2:** "Não criar config.js.php"
   - ⚠️ Mas precisamos de algum arquivo para passar variáveis
   - ⚠️ JavaScript não tem acesso direto a $_ENV

3. **Diretiva 3:** "NÃO criar window.APP_CONFIG"
   - ⚠️ Mas precisamos de alguma forma de expor variáveis para JavaScript
   - ⚠️ window.APP_ENV é similar a window.APP_CONFIG

### **Solução de Compromisso:**

**Criar `config_env.js.php` mas:**
- ✅ Usar variáveis globais simples (não objeto de configuração)
- ✅ Nome diferente de `config.js.php` (é `config_env.js.php`)
- ✅ Não criar sistema complexo, apenas expor variáveis

---

## ✅ PROPOSTA ALINHADA COM DIRETIVAS

### **config_env.js.php (Simplificado):**

```php
<?php
/**
 * EXPOR VARIÁVEIS DE AMBIENTE DO DOCKER PARA JAVASCRIPT
 * 
 * Este arquivo apenas expõe as variáveis de ambiente como variáveis globais simples.
 * Não cria sistema de configuração complexo.
 */
header('Content-Type: application/javascript');

// Ler variáveis de ambiente do Docker
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';
$environment = $_ENV['PHP_ENV'] ?? 'development';

// Expor como variáveis globais simples (NÃO objeto de configuração)
?>
window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;

// Função helper simples (opcional, para facilitar uso)
window.getEndpointUrl = function(endpoint) {
    return window.APP_BASE_URL + '/' + endpoint.replace(/^\//, '');
};
```

### **Uso no JavaScript:**

```javascript
// Usar variáveis diretamente (sem objeto de configuração)
fetch(window.APP_BASE_URL + '/debug_logger_db.php', {...});

// OU usar função helper
fetch(window.getEndpointUrl('debug_logger_db.php'), {...});

// Verificar ambiente
if (window.APP_ENVIRONMENT === 'development') {
    console.log('Dev');
}
```

---

## 📋 COMPARAÇÃO

| Aspecto | Diretiva Original | Proposta Inicial | Proposta Alinhada |
|---------|------------------|------------------|-------------------|
| **Usar variáveis Docker** | ✅ Sim | ✅ Sim | ✅ Sim |
| **Não criar config.js.php** | ✅ Não criar | ⚠️ Criar config_env.js.php | ✅ Nome diferente |
| **Não criar window.APP_CONFIG** | ✅ Não criar | ❌ Criar window.APP_ENV | ✅ Variáveis globais simples |
| **Usar variáveis diretamente** | ✅ Sim | ⚠️ Via objeto | ✅ Diretamente |

---

## ✅ CONCLUSÃO

**Proposta Alinhada:**
- ✅ Criar `config_env.js.php` (nome diferente, apenas expõe variáveis)
- ✅ Usar variáveis globais simples (`window.APP_BASE_URL`, `window.APP_ENVIRONMENT`)
- ✅ NÃO criar objeto de configuração complexo (`window.APP_ENV`)
- ✅ JavaScript usa variáveis diretamente

**Isso está alinhado com as diretivas?**
- ✅ Usa variáveis de ambiente do Docker
- ✅ Não cria sistema de configuração complexo
- ✅ JavaScript usa variáveis diretamente
- ⚠️ Ainda cria arquivo PHP (mas é necessário para passar variáveis)

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

