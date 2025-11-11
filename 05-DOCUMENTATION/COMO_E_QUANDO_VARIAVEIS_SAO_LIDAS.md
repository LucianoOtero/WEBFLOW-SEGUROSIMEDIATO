# 📋 COMO E QUANDO AS VARIÁVEIS SÃO LIDAS

**Data:** 08/11/2025  
**Status:** ✅ **DOCUMENTAÇÃO COMPLETA**

---

## 🎯 RESUMO EXECUTIVO

| Aspecto | PHP | JavaScript |
|---------|-----|------------|
| **Quando são lidas** | ✅ No início da execução do script PHP | ⚠️ Não tem acesso direto |
| **Como são lidas** | ✅ Via `$_ENV['APP_BASE_DIR']` e `$_ENV['APP_BASE_URL']` | ⚠️ Precisa de intermediário |
| **Disponibilidade** | ✅ Sempre disponíveis (definidas no Docker) | ⚠️ Precisa ser passado via HTML |

---

## 🔧 PARA PHP

### **Quando são lidas:**

1. **No momento da inicialização do container Docker:**
   - Variáveis são definidas no `docker-compose.yml`
   - Docker injeta as variáveis no ambiente do container
   - Variáveis ficam disponíveis para todos os processos PHP dentro do container

2. **No início da execução de cada script PHP:**
   - Quando um script PHP é executado, as variáveis já estão disponíveis
   - Não precisa de configuração adicional
   - Acessíveis imediatamente via `$_ENV`

### **Como são lidas:**

```php
<?php
// ✅ Variáveis disponíveis IMEDIATAMENTE quando o script PHP inicia
$base_dir = $_ENV['APP_BASE_DIR'] ?? __DIR__;
$base_url = $_ENV['APP_BASE_URL'] ?? 'https://dev.bssegurosimediato.com.br';

// Exemplo: config.php
require_once __DIR__ . '/config.php';

// Dentro de config.php:
$CONFIG = [
    'base_dir' => $_ENV['APP_BASE_DIR'],  // ✅ Lido diretamente
    'base_url' => $_ENV['APP_BASE_URL'], // ✅ Lido diretamente
];
```

### **Fluxo de execução PHP:**

```
1. Container Docker inicia
   ↓
2. Docker lê docker-compose.yml
   ↓
3. Docker injeta variáveis no ambiente do container:
   - APP_BASE_DIR=/var/www/html/dev/root
   - APP_BASE_URL=https://dev.bssegurosimediato.com.br
   ↓
4. PHP-FPM inicia com variáveis disponíveis
   ↓
5. Requisição HTTP chega → Nginx → PHP-FPM
   ↓
6. Script PHP executa → $_ENV já está populado
   ↓
7. Script PHP lê: $_ENV['APP_BASE_DIR'] e $_ENV['APP_BASE_URL']
```

### **Exemplo prático:**

```php
<?php
// debug_logger_db.php
// ✅ Variáveis já disponíveis quando este script executa

// Ler variáveis de ambiente
$base_dir = $_ENV['APP_BASE_DIR'];  // /var/www/html/dev/root
$base_url = $_ENV['APP_BASE_URL'];   // https://dev.bssegurosimediato.com.br

// Usar para includes
require_once $base_dir . '/class.php';

// Usar para construir URLs (se necessário)
$endpoint_url = $base_url . '/debug_logger_db.php';
```

---

## ⚠️ PARA JAVASCRIPT

### **Problema:**

JavaScript **NÃO tem acesso direto** às variáveis de ambiente do servidor porque:
- JavaScript roda no **browser** (cliente)
- Variáveis de ambiente estão no **servidor** (Docker)
- Browser e servidor são ambientes separados

### **Soluções possíveis:**

#### **Opção 1: Meta Tag (gerada por PHP)**

**Quando é lida:**
- Quando o HTML é carregado no browser
- JavaScript lê a meta tag via `document.querySelector()`

**Como funciona:**
```php
<?php
// Arquivo PHP que gera HTML (ex: index.php ou template)
// ✅ PHP lê variável de ambiente
$base_url = $_ENV['APP_BASE_URL'];
?>
<!DOCTYPE html>
<html>
<head>
    <!-- ✅ PHP gera meta tag com variável de ambiente -->
    <meta name="app-base-url" content="<?php echo htmlspecialchars($base_url); ?>">
</head>
<body>
    <script>
        // ✅ JavaScript lê meta tag
        function getServerBaseUrl() {
            const meta = document.querySelector('meta[name="app-base-url"]');
            return meta ? meta.getAttribute('content') : 'https://dev.bssegurosimediato.com.br';
        }
        
        const baseUrl = getServerBaseUrl();
        fetch(`${baseUrl}/debug_logger_db.php`, {...});
    </script>
</body>
</html>
```

**Fluxo:**
```
1. Requisição HTTP → PHP
   ↓
2. PHP lê $_ENV['APP_BASE_URL']
   ↓
3. PHP gera HTML com meta tag: <meta name="app-base-url" content="https://dev.bssegurosimediato.com.br">
   ↓
4. Browser recebe HTML
   ↓
5. JavaScript executa e lê meta tag
   ↓
6. JavaScript usa URL base para fazer fetch()
```

---

#### **Opção 2: Script Inline (gerado por PHP)**

**Quando é lida:**
- Quando o HTML é carregado no browser
- JavaScript acessa variável global `window.APP_BASE_URL`

**Como funciona:**
```php
<?php
// Arquivo PHP que gera HTML
$base_url = $_ENV['APP_BASE_URL'];
?>
<!DOCTYPE html>
<html>
<head>
    <!-- ✅ PHP gera script inline com variável de ambiente -->
    <script>
        window.APP_BASE_URL = <?php echo json_encode($base_url); ?>;
    </script>
</head>
<body>
    <script>
        // ✅ JavaScript usa variável global
        const baseUrl = window.APP_BASE_URL;
        fetch(`${baseUrl}/debug_logger_db.php`, {...});
    </script>
</body>
</html>
```

**Fluxo:**
```
1. Requisição HTTP → PHP
   ↓
2. PHP lê $_ENV['APP_BASE_URL']
   ↓
3. PHP gera script inline: <script>window.APP_BASE_URL = "https://dev.bssegurosimediato.com.br";</script>
   ↓
4. Browser recebe HTML e executa script inline
   ↓
5. window.APP_BASE_URL fica disponível globalmente
   ↓
6. JavaScript usa window.APP_BASE_URL para fazer fetch()
```

---

#### **Opção 3: Detecção Automática (RECOMENDADA - Solução Elegante)**

**Quando é lida:**
- Quando o JavaScript é executado no browser
- Detecta automaticamente a URL base do servidor

**Como funciona:**
```javascript
// ✅ JavaScript detecta automaticamente
function getServerBaseUrl() {
    // 1. Tentar detectar do script atual
    const scripts = document.getElementsByTagName('script');
    for (let script of scripts) {
        if (script.src && script.src.includes('bssegurosimediato.com.br')) {
            return new URL(script.src).origin;
        }
    }
    
    // 2. Fallback baseado no hostname
    const hostname = window.location.hostname;
    if (hostname.includes('webflow.io') || hostname.includes('localhost')) {
        return 'https://dev.bssegurosimediato.com.br';
    }
    
    return 'https://bssegurosimediato.com.br';
}

// Usar
const baseUrl = getServerBaseUrl();
fetch(`${baseUrl}/debug_logger_db.php`, {...});
```

**Fluxo:**
```
1. JavaScript é carregado no browser
   ↓
2. Função getServerBaseUrl() é executada
   ↓
3. Detecta URL base do script atual (ex: https://dev.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js)
   ↓
4. Extrai origin: https://dev.bssegurosimediato.com.br
   ↓
5. Usa para fazer fetch()
```

**Vantagens:**
- ✅ Não precisa modificar HTML
- ✅ Não precisa de PHP gerando meta tags
- ✅ Funciona automaticamente
- ✅ Zero configuração

---

## 📊 COMPARAÇÃO DAS SOLUÇÕES

| Solução | Quando é lida | Como funciona | Complexidade |
|---------|--------------|---------------|--------------|
| **Meta Tag** | Quando HTML carrega | PHP gera meta tag → JS lê | Média |
| **Script Inline** | Quando HTML carrega | PHP gera script → JS usa | Média |
| **Detecção Automática** | Quando JS executa | JS detecta do script atual | Baixa |

---

## 🎯 RECOMENDAÇÃO FINAL

### **Para PHP:**
✅ **Usar diretamente `$_ENV['APP_BASE_DIR']` e `$_ENV['APP_BASE_URL']`**
- Variáveis já estão disponíveis quando o script PHP inicia
- Não precisa de configuração adicional

### **Para JavaScript:**
✅ **Usar detecção automática (`getServerBaseUrl()`)**
- Não precisa modificar HTML
- Não precisa de PHP gerando meta tags
- Funciona automaticamente
- Zero configuração

---

## 📋 RESUMO

| Aspecto | Resposta |
|---------|----------|
| **PHP - Quando lê** | ✅ No início da execução do script (variáveis já disponíveis) |
| **PHP - Como lê** | ✅ Via `$_ENV['APP_BASE_DIR']` e `$_ENV['APP_BASE_URL']` |
| **JavaScript - Quando lê** | ⚠️ Não tem acesso direto (precisa de intermediário) |
| **JavaScript - Como lê** | ✅ Detecção automática do script atual (recomendado) |

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

