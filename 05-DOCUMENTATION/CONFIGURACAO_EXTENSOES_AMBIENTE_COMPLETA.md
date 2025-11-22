# 🔧 CONFIGURAÇÃO COMPLETA: Extensões para Ambiente JS/PHP/Nginx/SQL

**Data:** 21/11/2025  
**Versão:** 1.0  
**Status:** ✅ **CONFIGURAÇÃO RECOMENDADA**

---

## 🎯 OBJETIVO

Configuração otimizada de extensões VS Code/Cursor para o ambiente específico do projeto:
- **JavaScript** (.js) - FooterCodeSiteDefinitivoCompleto.js, MODAL_WHATSAPP_DEFINITIVO.js
- **PHP** (.php) - config.php, ProfessionalLogger.php, log_endpoint.php, etc.
- **Variáveis de Ambiente PHP-FPM** - Configuradas no servidor
- **Nginx** - Configurações de servidor web
- **SQL/MariaDB** - Banco de dados de logs

---

## 📋 EXTENSÕES ESSENCIAIS (INSTALAÇÃO OBRIGATÓRIA)

### **1. PHP Intelephense** ⭐⭐⭐⭐⭐
- **ID:** `bmewburn.vscode-intelephense-client`
- **Por quê:** IntelliSense avançado para PHP, validação de código, navegação
- **Uso no Projeto:**
  - Desenvolvimento de arquivos PHP (config.php, ProfessionalLogger.php, etc.)
  - Validação de sintaxe antes do deploy
  - Autocomplete para funções PHP e variáveis de ambiente

**Configuração recomendada (`.vscode/settings.json`):**
```json
{
  "intelephense.environment.includePaths": [
    "${workspaceFolder}/WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT"
  ],
  "intelephense.environment.phpVersion": "8.3.0",
  "intelephense.files.maxSize": 5000000
}
```

---

### **2. Remote - SSH** ⭐⭐⭐⭐⭐
- **ID:** `ms-vscode-remote.remote-ssh`
- **Por quê:** Conexão direta aos servidores DEV/PROD para edição e terminal
- **Uso no Projeto:**
  - Conectar ao servidor DEV (65.108.156.14)
  - Editar arquivos PHP-FPM pool configs
  - Verificar logs do Nginx
  - Executar comandos SQL diretamente

**Configuração (`~/.ssh/config`):**
```
Host dev-server
    HostName 65.108.156.14
    User root
    IdentityFile ~/.ssh/id_rsa

Host prod-server
    HostName 157.180.36.223
    User root
    IdentityFile ~/.ssh/id_rsa
```

---

### **3. dotenv** ⭐⭐⭐⭐⭐
- **ID:** `mikestead.dotenv`
- **Por quê:** Gerenciamento de variáveis de ambiente com syntax highlighting
- **Uso no Projeto:**
  - Visualizar variáveis de ambiente PHP-FPM
  - Criar arquivos `.env.dev`, `.env.prod` para referência local
  - Validar configurações antes do deploy

**Configuração recomendada:**
```json
{
  "files.associations": {
    ".env*": "dotenv"
  },
  "dotenv.enableAutocloaking": false
}
```

---

### **4. ESLint** ⭐⭐⭐⭐
- **ID:** `dbaeumer.vscode-eslint`
- **Por quê:** Validação e formatação de código JavaScript
- **Uso no Projeto:**
  - Validar FooterCodeSiteDefinitivoCompleto.js
  - Validar MODAL_WHATSAPP_DEFINITIVO.js
  - Manter padrão de código consistente

**Configuração recomendada (`.eslintrc.json`):**
```json
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": ["eslint:recommended"],
  "parserOptions": {
    "ecmaVersion": 2021,
    "sourceType": "module"
  },
  "rules": {
    "no-console": "warn",
    "no-unused-vars": "warn"
  }
}
```

---

### **5. GitLens** ⭐⭐⭐⭐
- **ID:** `eamodio.gitlens`
- **Por quê:** Rastreamento de versões, comparação entre ambientes
- **Uso no Projeto:**
  - Verificar versões deployadas em DEV vs PROD
  - Rastrear mudanças em arquivos PHP/JS
  - Comparar código entre branches

---

### **6. SQL Tools** ⭐⭐⭐⭐
- **ID:** `mtxr.sqltools`
- **Driver:** `mtxr.sqltools-driver-mysql`
- **Por quê:** Gerenciamento e consulta de banco de dados MariaDB
- **Uso no Projeto:**
  - Conectar ao `rpa_logs_dev` e `rpa_logs_prod`
  - Executar queries SQL
  - Visualizar estrutura de tabelas
  - Verificar logs salvos

**Configuração (`.vscode/settings.json`):**
```json
{
  "sqltools.connections": [
    {
      "name": "DEV - rpa_logs_dev",
      "driver": "MySQL",
      "server": "65.108.156.14",
      "port": 3306,
      "database": "rpa_logs_dev",
      "username": "rpa_logger_dev",
      "password": "tYbAwe7QkKNrHSRhaWplgsSxt"
    },
    {
      "name": "PROD - rpa_logs_prod",
      "driver": "MySQL",
      "server": "157.180.36.223",
      "port": 3306,
      "database": "rpa_logs_prod",
      "username": "rpa_logger_prod",
      "password": "[SENHA_PROD]"
    }
  ]
}
```

---

### **7. Nginx** ⭐⭐⭐
- **ID:** `raynerks0.vscode-nginx`
- **Por quê:** Syntax highlighting e validação para arquivos de configuração Nginx
- **Uso no Projeto:**
  - Editar configurações Nginx
  - Validar sintaxe antes de aplicar
  - Completar diretivas Nginx

---

### **8. Docker** ⭐⭐⭐
- **ID:** `ms-azuretools.vscode-docker`
- **Por quê:** Gerenciamento de containers Docker (PHP-FPM)
- **Uso no Projeto:**
  - Visualizar containers PHP-FPM
  - Ver logs de containers
  - Gerenciar imagens Docker

---

## 🛠️ CONFIGURAÇÃO DO WORKSPACE

### **`.vscode/settings.json` Completo:**

```json
{
  // ==================== PHP ====================
  "php.validate.executablePath": "php",
  "php.validate.enable": true,
  "intelephense.environment.includePaths": [
    "${workspaceFolder}/WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT"
  ],
  "intelephense.environment.phpVersion": "8.3.0",
  "intelephense.files.maxSize": 5000000,
  "intelephense.stubs": [
    "apache",
    "bcmath",
    "bz2",
    "calendar",
    "Core",
    "ctype",
    "curl",
    "date",
    "dba",
    "dom",
    "enchant",
    "exif",
    "FFI",
    "fileinfo",
    "filter",
    "fpm",
    "ftp",
    "gd",
    "gettext",
    "gmp",
    "hash",
    "iconv",
    "imap",
    "intl",
    "json",
    "ldap",
    "libxml",
    "mbstring",
    "meta",
    "mysqli",
    "oci8",
    "odbc",
    "openssl",
    "pcntl",
    "pcre",
    "PDO",
    "pdo_ibm",
    "pdo_mysql",
    "pdo_pgsql",
    "pdo_sqlite",
    "pgsql",
    "Phar",
    "posix",
    "pspell",
    "random",
    "readline",
    "Reflection",
    "session",
    "shmop",
    "SimpleXML",
    "snmp",
    "soap",
    "sockets",
    "sodium",
    "SPL",
    "sqlite3",
    "standard",
    "superglobals",
    "sysvmsg",
    "sysvsem",
    "sysvshm",
    "tidy",
    "tokenizer",
    "xml",
    "xmlreader",
    "xmlrpc",
    "xmlwriter",
    "xsl",
    "Zend OPcache",
    "zip",
    "zlib"
  ],

  // ==================== JavaScript ====================
  "javascript.validate.enable": true,
  "javascript.updateImportsOnFileMove.enabled": "always",
  "javascript.preferences.quoteStyle": "single",
  "javascript.format.enable": true,
  "javascript.suggest.autoImports": true,

  // ==================== ESLint ====================
  "eslint.enable": true,
  "eslint.validate": [
    "javascript",
    "javascriptreact"
  ],
  "eslint.workingDirectories": [
    "${workspaceFolder}/WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT"
  ],

  // ==================== dotenv ====================
  "files.associations": {
    ".env*": "dotenv",
    "*.env": "dotenv",
    "*.conf": "nginx"
  },
  "dotenv.enableAutocloaking": false,
  "dotenv.enableDotenv": true,

  // ==================== Nginx ====================
  "nginx.conf": "/etc/nginx/nginx.conf",
  "nginx.validateOnSave": true,

  // ==================== SQL ====================
  "sqltools.autoOpenSessionFiles": false,
  "sqltools.connections": [
    {
      "name": "DEV - rpa_logs_dev",
      "driver": "MySQL",
      "server": "65.108.156.14",
      "port": 3306,
      "database": "rpa_logs_dev",
      "username": "rpa_logger_dev",
      "password": "tYbAwe7QkKNrHSRhaWplgsSxt"
    }
  ],

  // ==================== Arquivos ====================
  "files.exclude": {
    "**/.git": true,
    "**/node_modules": true,
    "**/backups": false,
    "**/TMP": false,
    "**/Lixo": true
  },
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/**": true,
    "**/backups/**": true
  },

  // ==================== Editor ====================
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[php]": {
    "editor.defaultFormatter": "bmewburn.vscode-intelephense-client",
    "editor.formatOnSave": false
  },
  "[javascript]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint",
    "editor.formatOnSave": true
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[nginx]": {
    "editor.defaultFormatter": "raynerks0.vscode-nginx"
  },

  // ==================== Terminal ====================
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "terminal.integrated.cwd": "${workspaceFolder}"
}
```

---

## 📝 TASKS PARA DEPLOY

### **`.vscode/tasks.json`:**

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Deploy PHP para DEV",
      "type": "shell",
      "command": "scp",
      "args": [
        "${file}",
        "root@65.108.156.14:/var/www/html/dev/root/"
      ],
      "problemMatcher": [],
      "group": {
        "kind": "build",
        "isDefault": false
      }
    },
    {
      "label": "Deploy JS para DEV",
      "type": "shell",
      "command": "scp",
      "args": [
        "${file}",
        "root@65.108.156.14:/var/www/html/dev/root/"
      ],
      "problemMatcher": [],
      "group": {
        "kind": "build",
        "isDefault": false
      }
    },
    {
      "label": "Verificar Sintaxe PHP",
      "type": "shell",
      "command": "php",
      "args": [
        "-l",
        "${file}"
      ],
      "problemMatcher": {
        "owner": "php",
        "fileLocation": ["relative", "${workspaceFolder}"],
        "pattern": {
          "regexp": "^Parse error: (.*) in (.*) on line (\\d+)$",
          "file": 2,
          "line": 3,
          "message": 1
        }
      }
    },
    {
      "label": "Verificar Variáveis de Ambiente DEV",
      "type": "shell",
      "command": "ssh",
      "args": [
        "root@65.108.156.14",
        "php-fpm8.3 -tt | grep env\\["
      ],
      "problemMatcher": []
    },
    {
      "label": "Ver Logs Nginx DEV",
      "type": "shell",
      "command": "ssh",
      "args": [
        "root@65.108.156.14",
        "tail -f /var/log/nginx/error.log"
      ],
      "problemMatcher": [],
      "isBackground": true
    },
    {
      "label": "Ver Logs PHP-FPM DEV",
      "type": "shell",
      "command": "ssh",
      "args": [
        "root@65.108.156.14",
        "tail -f /var/log/php8.3-fpm.log"
      ],
      "problemMatcher": [],
      "isBackground": true
    }
  ]
}
```

---

## 🎯 SNIPPETS ÚTEIS

### **`.vscode/php.code-snippets`:**

```json
{
  "Get Environment Variable": {
    "prefix": "getenv",
    "body": [
      "$env = $_ENV['${1:VAR_NAME}'] ?? getenv('${1:VAR_NAME}') ?: '${2:default}';"
    ],
    "description": "Get environment variable safely"
  },
  "Check if Development": {
    "prefix": "isdev",
    "body": [
      "if (isDevelopment()) {",
      "    ${1:// code}",
      "}"
    ],
    "description": "Check if in development environment"
  },
  "Check if Production": {
    "prefix": "isprod",
    "body": [
      "if (isProduction()) {",
      "    ${1:// code}",
      "}"
    ],
    "description": "Check if in production environment"
  },
  "Error Log": {
    "prefix": "errorlog",
    "body": [
      "error_log('[${1:CONTEXT}] ${2:Message}');"
    ],
    "description": "Error log with context"
  }
}
```

### **`.vscode/javascript.code-snippets`:**

```json
{
  "Fetch with Error Handling": {
    "prefix": "fetch",
    "body": [
      "fetch('${1:url}', {",
      "    method: '${2:POST}',",
      "    headers: {",
      "        'Content-Type': 'application/json'",
      "    },",
      "    body: JSON.stringify(${3:data})",
      "})",
      "    .then(response => {",
      "        if (!response.ok) throw new Error('HTTP ' + response.status);",
      "        return response.json();",
      "    })",
      "    .then(data => {",
      "        ${4:// handle success}",
      "    })",
      "    .catch(error => {",
      "        console.error('[${5:CONTEXT}] Erro:', error);",
      "    });"
    ],
    "description": "Fetch with error handling"
  },
  "Log with Context": {
    "prefix": "log",
    "body": [
      "console.log('[${1:CONTEXT}] ${2:Message}', ${3:data});"
    ],
    "description": "Console log with context"
  }
}
```

---

## 📊 CHECKLIST DE INSTALAÇÃO

### **Fase 1: Extensões Essenciais**
- [ ] PHP Intelephense
- [ ] Remote - SSH
- [ ] dotenv
- [ ] ESLint
- [ ] GitLens

### **Fase 2: Extensões Complementares**
- [ ] SQL Tools + MySQL Driver
- [ ] Nginx
- [ ] Docker

### **Fase 3: Configuração**
- [ ] Criar `.vscode/settings.json`
- [ ] Criar `.vscode/tasks.json`
- [ ] Criar `.vscode/php.code-snippets`
- [ ] Criar `.vscode/javascript.code-snippets`
- [ ] Configurar SSH config
- [ ] Configurar conexões SQL

---

## ✅ BENEFÍCIOS ESPERADOS

### **Produtividade:**
- ✅ Autocomplete inteligente para PHP e JavaScript
- ✅ Validação de código antes do deploy
- ✅ Navegação rápida entre arquivos
- ✅ Deploy rápido via tasks

### **Qualidade:**
- ✅ Detecção de erros antes do deploy
- ✅ Padrão de código consistente
- ✅ Validação de sintaxe PHP/JS
- ✅ Validação de configurações Nginx

### **Controle de Ambientes:**
- ✅ Conexão rápida aos servidores DEV/PROD
- ✅ Visualização de variáveis de ambiente
- ✅ Consulta direta ao banco de dados
- ✅ Verificação de logs em tempo real

---

## 🔗 LINKS DE INSTALAÇÃO

### **Extensões:**
1. **PHP Intelephense:** `ext install bmewburn.vscode-intelephense-client`
2. **Remote SSH:** `ext install ms-vscode-remote.remote-ssh`
3. **dotenv:** `ext install mikestead.dotenv`
4. **ESLint:** `ext install dbaeumer.vscode-eslint`
5. **GitLens:** `ext install eamodio.gitlens`
6. **SQL Tools:** `ext install mtxr.sqltools`
7. **SQL MySQL Driver:** `ext install mtxr.sqltools-driver-mysql`
8. **Nginx:** `ext install raynerks0.vscode-nginx`
9. **Docker:** `ext install ms-azuretools.vscode-docker`

---

**Configuração criada em:** 21/11/2025  
**Próxima revisão:** Conforme necessidade

