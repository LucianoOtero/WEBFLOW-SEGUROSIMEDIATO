# 🔧 RECOMENDAÇÕES: Extensões para Controle de Ambientes

**Data:** 21/11/2025  
**Versão:** 1.0  
**Status:** ✅ **RECOMENDAÇÕES COMPILADAS**

---

## 🎯 OBJETIVO

Documentar extensões e ferramentas recomendadas para controle eficiente de ambientes de desenvolvimento, UAT e produção no contexto do projeto Imediato Seguros RPA.

---

## 📋 EXTENSÕES VS CODE / CURSOR RECOMENDADAS

### **1. Environment Variable Manager**
- **Nome:** `mikestead.dotenv` ou `dotenv`
- **Descrição:** Gerenciamento de arquivos `.env` com suporte a múltiplos ambientes
- **Funcionalidades:**
  - Syntax highlighting para arquivos `.env`
  - Validação de variáveis
  - Suporte a múltiplos arquivos (`.env.dev`, `.env.prod`, `.env.uat`)
- **Uso no Projeto:**
  - Gerenciar variáveis de ambiente por ambiente
  - Validar configurações antes do deploy

### **2. Environment Switcher**
- **Nome:** `mikestead.dotenv` (com suporte a múltiplos arquivos)
- **Alternativa:** Criar workspace settings com configurações por ambiente
- **Funcionalidades:**
  - Trocar entre ambientes rapidamente
  - Visualizar variáveis ativas
  - Validar configurações
- **Uso no Projeto:**
  - Alternar entre DEV, UAT e PROD
  - Validar configurações antes de deploy

### **3. Remote - SSH**
- **Nome:** `ms-vscode-remote.remote-ssh`
- **Descrição:** Conectar e trabalhar diretamente em servidores remotos
- **Funcionalidades:**
  - Conexão SSH direta
  - Edição de arquivos remotos
  - Terminal integrado
- **Uso no Projeto:**
  - Conectar aos servidores DEV (65.108.156.14) e PROD (157.180.36.223)
  - Editar arquivos diretamente no servidor (com cuidado!)
  - Executar comandos remotos

### **4. GitLens**
- **Nome:** `eamodio.gitlens`
- **Descrição:** Visualização avançada do Git
- **Funcionalidades:**
  - Histórico de commits por arquivo
  - Comparação de branches
  - Tags e releases
- **Uso no Projeto:**
  - Rastrear mudanças entre ambientes
  - Verificar versões deployadas
  - Comparar código entre DEV e PROD

### **5. Docker**
- **Nome:** `ms-azuretools.vscode-docker`
- **Descrição:** Gerenciamento de containers Docker
- **Funcionalidades:**
  - Visualizar containers
  - Gerenciar imagens
  - Ver logs
- **Uso no Projeto:**
  - Gerenciar containers PHP-FPM
  - Verificar logs de containers
  - Validar configurações Docker

### **6. YAML**
- **Nome:** `redhat.vscode-yaml`
- **Descrição:** Suporte completo para YAML
- **Funcionalidades:**
  - Syntax highlighting
  - Validação de schema
  - Formatação
- **Uso no Projeto:**
  - Editar `docker-compose.yml`
  - Configurar CI/CD (se implementado)

### **7. PHP Intelephense**
- **Nome:** `bmewburn.vscode-intelephense-client`
- **Descrição:** IntelliSense avançado para PHP
- **Funcionalidades:**
  - Autocomplete
  - Validação de código
  - Navegação de código
- **Uso no Projeto:**
  - Desenvolvimento PHP
  - Validação de código antes do deploy

---

## 🛠️ FERRAMENTAS DE LINHA DE COMANDO

### **1. dotenv-cli**
- **Instalação:** `npm install -g dotenv-cli`
- **Uso:**
  ```bash
  dotenv -e .env.dev -- php script.php
  dotenv -e .env.prod -- php script.php
  ```
- **Benefício:** Executar scripts com variáveis de ambiente específicas

### **2. direnv**
- **Instalação:** `brew install direnv` (macOS) ou `apt install direnv` (Linux)
- **Uso:** Carrega automaticamente variáveis de ambiente baseado no diretório
- **Benefício:** Ambiente automático por projeto/diretório

### **3. asdf-vm**
- **Descrição:** Gerenciador de versões universal
- **Uso:** Gerenciar versões de PHP, Node.js, etc. por projeto
- **Benefício:** Garantir versões consistentes entre ambientes

---

## 🏗️ SOLUÇÕES ESPECÍFICAS PARA O PROJETO

### **1. Workspace Settings por Ambiente**

Criar arquivos `.vscode/settings.json` específicos:

**`.vscode/settings.dev.json`:**
```json
{
  "files.associations": {
    ".env": "dotenv"
  },
  "dotenv.enableAutocloaking": false,
  "dotenv.enableDotenv": true,
  "dotenv.path": "${workspaceFolder}/.env.dev"
}
```

**`.vscode/settings.prod.json`:**
```json
{
  "files.associations": {
    ".env": "dotenv"
  },
  "dotenv.enableAutocloaking": false,
  "dotenv.enableDotenv": true,
  "dotenv.path": "${workspaceFolder}/.env.prod"
}
```

### **2. Tasks para Deploy**

Criar tasks no `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Deploy DEV",
      "type": "shell",
      "command": "./scripts/deploy-dev.sh",
      "problemMatcher": []
    },
    {
      "label": "Deploy PROD",
      "type": "shell",
      "command": "./scripts/deploy-prod.sh",
      "problemMatcher": []
    }
  ]
}
```

### **3. Snippets para Variáveis de Ambiente**

Criar snippets em `.vscode/php.code-snippets`:

```json
{
  "Get Environment Variable": {
    "prefix": "getenv",
    "body": [
      "$env = $_ENV['${1:VAR_NAME}'] ?? getenv('${1:VAR_NAME}') ?: '${2:default}';"
    ],
    "description": "Get environment variable safely"
  }
}
```

---

## 📊 COMPARAÇÃO DE SOLUÇÕES

### **Extensões VS Code/Cursor:**
| Extensão | Complexidade | Benefício | Recomendação |
|----------|-------------|-----------|--------------|
| dotenv | ⭐ Baixa | ⭐⭐⭐ Alto | ✅ **RECOMENDADO** |
| Remote SSH | ⭐⭐ Média | ⭐⭐⭐⭐ Muito Alto | ✅ **RECOMENDADO** |
| GitLens | ⭐ Baixa | ⭐⭐⭐⭐ Muito Alto | ✅ **RECOMENDADO** |
| Docker | ⭐⭐ Média | ⭐⭐⭐ Alto | ✅ **ÚTIL** |
| PHP Intelephense | ⭐ Baixa | ⭐⭐⭐⭐ Muito Alto | ✅ **ESSENCIAL** |

### **Ferramentas CLI:**
| Ferramenta | Complexidade | Benefício | Recomendação |
|-----------|-------------|-----------|--------------|
| dotenv-cli | ⭐ Baixa | ⭐⭐⭐ Alto | ✅ **RECOMENDADO** |
| direnv | ⭐⭐ Média | ⭐⭐⭐⭐ Muito Alto | ✅ **RECOMENDADO** |
| asdf-vm | ⭐⭐⭐ Alta | ⭐⭐⭐ Alto | ⚠️ **OPCIONAL** |

---

## 🎯 RECOMENDAÇÕES ESPECÍFICAS PARA O PROJETO

### **Prioridade ALTA:**
1. ✅ **dotenv** - Gerenciamento de variáveis de ambiente
2. ✅ **Remote SSH** - Conexão com servidores DEV/PROD
3. ✅ **GitLens** - Rastreamento de versões e mudanças
4. ✅ **PHP Intelephense** - Desenvolvimento PHP eficiente

### **Prioridade MÉDIA:**
1. ✅ **Docker** - Gerenciamento de containers
2. ✅ **YAML** - Edição de configurações Docker
3. ✅ **dotenv-cli** - Execução de scripts com ambiente específico

### **Prioridade BAIXA:**
1. ⚠️ **direnv** - Carregamento automático de ambiente (pode ser útil)
2. ⚠️ **asdf-vm** - Gerenciamento de versões (se necessário)

---

## 📝 IMPLEMENTAÇÃO SUGERIDA

### **Fase 1: Configuração Básica**
1. Instalar extensões prioritárias (dotenv, Remote SSH, GitLens, PHP Intelephense)
2. Criar arquivos `.env.dev`, `.env.uat`, `.env.prod` (se necessário)
3. Configurar Remote SSH para servidor DEV

### **Fase 2: Automação**
1. Criar tasks para deploy
2. Configurar snippets para variáveis de ambiente
3. Implementar scripts de deploy por ambiente

### **Fase 3: Otimização**
1. Implementar direnv (se necessário)
2. Configurar asdf-vm (se necessário)
3. Criar workflows automatizados

---

## 🔗 LINKS ÚTEIS

### **Extensões:**
- [dotenv](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv)
- [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [PHP Intelephense](https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client)

### **Ferramentas CLI:**
- [dotenv-cli](https://www.npmjs.com/package/dotenv-cli)
- [direnv](https://direnv.net/)
- [asdf-vm](https://asdf-vm.com/)

---

## ✅ CONCLUSÃO

Para o projeto Imediato Seguros RPA, recomenda-se começar com as extensões de **prioridade ALTA**:
1. **dotenv** - Para gerenciar variáveis de ambiente
2. **Remote SSH** - Para conectar aos servidores
3. **GitLens** - Para rastrear versões
4. **PHP Intelephense** - Para desenvolvimento PHP

Essas extensões fornecerão uma base sólida para controle eficiente de ambientes DEV, UAT e PROD.

---

**Documento criado em:** 21/11/2025  
**Próxima revisão:** Conforme necessidade

