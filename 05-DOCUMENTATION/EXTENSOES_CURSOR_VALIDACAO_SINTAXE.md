# 🔍 EXTENSÕES CURSOR: Validação de Sintaxe

**Data:** 21/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **RECOMENDAÇÕES COMPILADAS**

---

## 🎯 OBJETIVO

Recomendar extensões do Cursor/VS Code para **validação de sintaxe** de todos os tipos de arquivos usados no projeto:
- ✅ PHP
- ✅ JavaScript
- ✅ SQL
- ✅ PowerShell
- ✅ PHP-FPM (configurações)
- ✅ Nginx (configurações)

---

## 📋 EXTENSÕES RECOMENDADAS POR TIPO

### **1. PHP - Validação de Sintaxe** ⭐⭐⭐⭐⭐

#### **1.1. PHP Intelephense** (Recomendado)
- **ID:** `bmewburn.vscode-intelephense-client`
- **Descrição:** IntelliSense completo para PHP
- **Funcionalidades:**
  - ✅ Validação de sintaxe PHP em tempo real
  - ✅ Autocomplete inteligente
  - ✅ Detecção de erros antes de salvar
  - ✅ Navegação de código
  - ✅ Refatoração
- **Uso no Projeto:**
  - Validar sintaxe de arquivos `.php` antes de copiar para servidor
  - Detectar erros de sintaxe antes de deploy
  - Autocomplete de funções PHP nativas e customizadas

#### **1.2. PHP CS Fixer** (Opcional - Formatação)
- **ID:** `junstyle.php-cs-fixer`
- **Descrição:** Formatação automática de código PHP
- **Funcionalidades:**
  - ✅ Formatação automática de código
  - ✅ Correção de estilo de código
  - ✅ Validação de padrões PSR
- **Uso no Projeto:**
  - Manter código PHP formatado consistentemente
  - Validar padrões de código

---

### **2. JavaScript - Validação de Sintaxe** ⭐⭐⭐⭐⭐

#### **2.1. ESLint** (Recomendado)
- **ID:** `dbaeumer.vscode-eslint`
- **Descrição:** Validação de sintaxe e estilo JavaScript
- **Funcionalidades:**
  - ✅ Validação de sintaxe JavaScript em tempo real
  - ✅ Detecção de erros e warnings
  - ✅ Validação de padrões de código
  - ✅ Correção automática de problemas comuns
- **Uso no Projeto:**
  - Validar sintaxe de arquivos `.js` antes de copiar para servidor
  - Detectar erros de sintaxe antes de deploy
  - Manter padrões de código consistentes

#### **2.2. Prettier - Code Formatter** (Opcional - Formatação)
- **ID:** `esbenp.prettier-vscode`
- **Descrição:** Formatação automática de código JavaScript
- **Funcionalidades:**
  - ✅ Formatação automática de código
  - ✅ Suporte a JavaScript, JSON, HTML, CSS
- **Uso no Projeto:**
  - Formatação automática de arquivos JavaScript
  - Manter código formatado consistentemente

---

### **3. SQL - Validação de Sintaxe** ⭐⭐⭐⭐⭐

#### **3.1. SQL Tools** (Recomendado)
- **ID:** `mtxr.sqltools`
- **Descrição:** Ferramentas completas para SQL
- **Funcionalidades:**
  - ✅ Validação de sintaxe SQL
  - ✅ Autocomplete de comandos SQL
  - ✅ Conexão com bancos de dados
  - ✅ Execução de queries
  - ✅ Suporte a MySQL, MariaDB, PostgreSQL
- **Uso no Projeto:**
  - Validar sintaxe de scripts SQL antes de executar
  - Detectar erros de sintaxe SQL
  - Conectar ao banco DEV para testar queries

#### **3.2. SQL Tools - MySQL Driver** (Recomendado)
- **ID:** `mtxr.sqltools-driver-mysql`
- **Descrição:** Driver MySQL para SQL Tools
- **Funcionalidades:**
  - ✅ Conexão com MySQL/MariaDB
  - ✅ Validação de sintaxe MySQL específica
- **Uso no Projeto:**
  - Conectar ao banco `rpa_logs_dev` e `rpa_logs_prod`
  - Validar scripts SQL antes de executar

---

### **4. PowerShell - Validação de Sintaxe** ⭐⭐⭐⭐⭐

#### **4.1. PowerShell** (Recomendado)
- **ID:** `ms-vscode.PowerShell`
- **Descrição:** Suporte completo para PowerShell
- **Funcionalidades:**
  - ✅ Validação de sintaxe PowerShell em tempo real
  - ✅ IntelliSense para PowerShell
  - ✅ Detecção de erros antes de executar
  - ✅ Debugging de scripts PowerShell
- **Uso no Projeto:**
  - Validar sintaxe de scripts `.ps1` antes de executar
  - Detectar erros de sintaxe PowerShell
  - Autocomplete de cmdlets PowerShell

#### **4.2. PSScriptAnalyzer** (Integrado no PowerShell Extension)
- **Descrição:** Analisador estático de código PowerShell
- **Funcionalidades:**
  - ✅ Análise de código PowerShell
  - ✅ Detecção de problemas de estilo
  - ✅ Sugestões de melhorias
- **Uso no Projeto:**
  - Validar scripts PowerShell antes de usar
  - Detectar problemas de estilo e boas práticas

---

### **5. PHP-FPM - Validação de Configuração** ⭐⭐⭐⭐

#### **5.1. INI** (Recomendado)
- **ID:** `mikestead.dotenv`
- **Descrição:** Suporte para arquivos INI (usado em PHP-FPM)
- **Funcionalidades:**
  - ✅ Syntax highlighting para arquivos INI
  - ✅ Validação básica de sintaxe INI
- **Uso no Projeto:**
  - Validar sintaxe de arquivos `www.conf` e `prod.conf`
  - Syntax highlighting para configurações PHP-FPM

#### **5.2. Validação Manual via Script**
- **Descrição:** Script PowerShell que valida PHP-FPM via `php-fpm -tt`
- **Funcionalidades:**
  - ✅ Validação de sintaxe PHP-FPM no servidor
  - ✅ Detecção de erros de configuração
- **Uso no Projeto:**
  - Validar configuração PHP-FPM antes de aplicar
  - Detectar erros de sintaxe PHP-FPM

---

### **6. Nginx - Validação de Configuração** ⭐⭐⭐⭐

#### **6.1. Nginx** (Recomendado)
- **ID:** `raynerwang.vscode-nginx`
- **Descrição:** Suporte para configurações Nginx
- **Funcionalidades:**
  - ✅ Syntax highlighting para Nginx
  - ✅ Validação básica de sintaxe Nginx
  - ✅ Autocomplete de diretivas Nginx
- **Uso no Projeto:**
  - Validar sintaxe de configurações Nginx
  - Syntax highlighting para arquivos de configuração

#### **6.2. Validação Manual via Script**
- **Descrição:** Script PowerShell que valida Nginx via `nginx -t`
- **Funcionalidades:**
  - ✅ Validação de sintaxe Nginx no servidor
  - ✅ Detecção de erros de configuração
- **Uso no Projeto:**
  - Validar configuração Nginx antes de aplicar
  - Detectar erros de sintaxe Nginx

---

## 📦 INSTALAÇÃO DAS EXTENSÕES

### **Método 1: Via Interface do Cursor**

1. Abrir Cursor
2. Clicar em **Extensions** (Ctrl+Shift+X)
3. Buscar pelo **ID da extensão**
4. Clicar em **Install**

### **Método 2: Via Linha de Comando**

```powershell
# Instalar extensões via code CLI (se disponível)
code --install-extension bmewburn.vscode-intelephense-client
code --install-extension dbaeumer.vscode-eslint
code --install-extension mtxr.sqltools
code --install-extension mtxr.sqltools-driver-mysql
code --install-extension ms-vscode.PowerShell
code --install-extension raynerwang.vscode-nginx
```

---

## ⚙️ CONFIGURAÇÃO RECOMENDADA

### **Arquivo: `.vscode/settings.json`**

```json
{
  // PHP
  "php.validate.enable": true,
  "php.validate.executablePath": "php",
  "intelephense.files.maxSize": 5000000,
  "intelephense.completion.fullyQualifyGlobalConstantsAndFunctions": false,
  
  // JavaScript
  "eslint.enable": true,
  "eslint.validate": [
    "javascript",
    "javascriptreact"
  ],
  "eslint.run": "onSave",
  
  // SQL
  "sqltools.connections": [
    {
      "name": "DEV Database",
      "driver": "MySQL",
      "server": "65.108.156.14",
      "port": 3306,
      "database": "rpa_logs_dev",
      "username": "rpa_logger_dev",
      "password": "${env:LOG_DB_PASS_DEV}"
    },
    {
      "name": "PROD Database",
      "driver": "MySQL",
      "server": "157.180.36.223",
      "port": 3306,
      "database": "rpa_logs_prod",
      "username": "rpa_logger_prod",
      "password": "${env:LOG_DB_PASS_PROD}"
    }
  ],
  
  // PowerShell
  "powershell.enableScriptAnalysis": true,
  "powershell.scriptAnalysis.settingsPath": ".vscode/PSScriptAnalyzerSettings.psd1",
  
  // Arquivos
  "files.associations": {
    "*.conf": "ini",
    "www.conf": "ini",
    "prod.conf": "ini"
  },
  
  // Validação automática
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

---

## 🧪 VALIDAÇÃO ANTES DE DEPLOY

### **Checklist de Validação:**

#### **Antes de Copiar Arquivo PHP:**
- [ ] ✅ Sintaxe PHP validada (sem erros no editor)
- [ ] ✅ Sem warnings do PHP Intelephense
- [ ] ✅ Código formatado (se usar PHP CS Fixer)
- [ ] ✅ Testado localmente (se possível)

#### **Antes de Copiar Arquivo JavaScript:**
- [ ] ✅ Sintaxe JavaScript validada (sem erros no editor)
- [ ] ✅ Sem erros do ESLint
- [ ] ✅ Código formatado (se usar Prettier)
- [ ] ✅ Testado no navegador (se possível)

#### **Antes de Executar Script SQL:**
- [ ] ✅ Sintaxe SQL validada (sem erros no editor)
- [ ] ✅ Testado no banco DEV via SQL Tools
- [ ] ✅ Backup do banco criado
- [ ] ✅ Script idempotente (pode executar múltiplas vezes)

#### **Antes de Aplicar Configuração PHP-FPM:**
- [ ] ✅ Sintaxe INI validada (sem erros no editor)
- [ ] ✅ Validação via script PowerShell (`php-fpm -tt`)
- [ ] ✅ Backup da configuração criado
- [ ] ✅ Variáveis de ambiente verificadas

#### **Antes de Aplicar Configuração Nginx:**
- [ ] ✅ Sintaxe Nginx validada (sem erros no editor)
- [ ] ✅ Validação via script PowerShell (`nginx -t`)
- [ ] ✅ Backup da configuração criado
- [ ] ✅ Testado em ambiente de desenvolvimento

---

## 🔧 INTEGRAÇÃO COM SCRIPTS DE DEPLOY

### **Atualizar Scripts para Validar Antes de Copiar:**

**Exemplo: `replicar-php-prod.ps1` atualizado:**

```powershell
# FASE 1: Validar sintaxe PHP localmente
Write-Host "🔍 FASE 1: Validando sintaxe PHP..." -ForegroundColor Cyan

# Tentar validar via PHP CLI
$sintaxe = php -l $arquivoLocal 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ERRO: Sintaxe PHP inválida:" -ForegroundColor Red
    Write-Host $sintaxe -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 DICA: Use a extensão PHP Intelephense no Cursor para validar antes de copiar" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Sintaxe PHP válida" -ForegroundColor Green
```

---

## 📋 RESUMO DAS EXTENSÕES ESSENCIAIS

| Tipo | Extensão | ID | Prioridade |
|------|----------|-----|------------|
| **PHP** | PHP Intelephense | `bmewburn.vscode-intelephense-client` | ⭐⭐⭐⭐⭐ |
| **JavaScript** | ESLint | `dbaeumer.vscode-eslint` | ⭐⭐⭐⭐⭐ |
| **SQL** | SQL Tools | `mtxr.sqltools` | ⭐⭐⭐⭐⭐ |
| **SQL** | SQL Tools MySQL Driver | `mtxr.sqltools-driver-mysql` | ⭐⭐⭐⭐⭐ |
| **PowerShell** | PowerShell | `ms-vscode.PowerShell` | ⭐⭐⭐⭐⭐ |
| **Nginx** | Nginx | `raynerwang.vscode-nginx` | ⭐⭐⭐⭐ |
| **INI** | DotENV | `mikestead.dotenv` | ⭐⭐⭐⭐ |

---

## ✅ CHECKLIST DE INSTALAÇÃO

- [ ] Instalar PHP Intelephense
- [ ] Instalar ESLint
- [ ] Instalar SQL Tools
- [ ] Instalar SQL Tools MySQL Driver
- [ ] Instalar PowerShell Extension
- [ ] Instalar Nginx Extension
- [ ] Configurar `.vscode/settings.json`
- [ ] Testar validação de sintaxe em arquivos PHP
- [ ] Testar validação de sintaxe em arquivos JavaScript
- [ ] Testar validação de sintaxe em scripts SQL
- [ ] Testar validação de sintaxe em scripts PowerShell

---

## 🎯 CONCLUSÃO

### **Extensões Essenciais para Validação:**

1. ✅ **PHP Intelephense** - Validação de sintaxe PHP
2. ✅ **ESLint** - Validação de sintaxe JavaScript
3. ✅ **SQL Tools + MySQL Driver** - Validação de sintaxe SQL
4. ✅ **PowerShell Extension** - Validação de sintaxe PowerShell
5. ✅ **Nginx Extension** - Validação de sintaxe Nginx

**Com essas extensões instaladas:**
- ✅ Validação de sintaxe em tempo real
- ✅ Detecção de erros antes de salvar
- ✅ Autocomplete inteligente
- ✅ Integração com scripts de deploy

---

**Recomendações completas de extensões para validação de sintaxe no Cursor.**

