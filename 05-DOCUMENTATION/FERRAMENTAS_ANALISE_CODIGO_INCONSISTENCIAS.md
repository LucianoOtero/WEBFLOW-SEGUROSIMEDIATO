# 🔍 FERRAMENTAS DE ANÁLISE DE CÓDIGO - Detecção de Inconsistências

**Data:** 22/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **DOCUMENTAÇÃO COMPLETA**

---

## 🎯 OBJETIVO

Documentar ferramentas e extensões que revisam código automaticamente, buscando inconsistências, vulnerabilidades, code smells e problemas de qualidade.

---

## 📋 CATEGORIAS DE FERRAMENTAS

### **1. EXTENSÕES VS CODE/CURSOR (Análise em Tempo Real)**

#### **1.1. SonarLint** ⭐⭐⭐⭐⭐
- **ID:** `SonarSource.sonarlint-vscode`
- **Descrição:** Análise estática de código em tempo real, detecta bugs, vulnerabilidades e code smells
- **Linguagens:** PHP, JavaScript, TypeScript, Python, Java, C#, etc.
- **Funcionalidades:**
  - Detecção de bugs e vulnerabilidades
  - Code smells e problemas de qualidade
  - Inconsistências de código
  - Regras personalizáveis
  - Integração com SonarQube (opcional)

**Configuração recomendada (`.vscode/settings.json`):**
```json
{
  "sonarlint.connectedMode.servers": [
    {
      "serverId": "sonarqube",
      "serverUrl": "https://sonarqube.example.com",
      "token": "seu-token-aqui"
    }
  ],
  "sonarlint.rules": {
    "php": {
      "S1481": "error",  // Unused local variables
      "S3776": "error",  // Cognitive Complexity
      "S138": "warning" // Functions should not have too many lines
    },
    "javascript": {
      "S1481": "error",  // Unused local variables
      "S3776": "error",  // Cognitive Complexity
      "S138": "warning" // Functions should not have too many lines
    }
  }
}
```

**Problemas Detectados:**
- Variáveis não utilizadas
- Complexidade ciclomática alta
- Funções muito grandes
- Código duplicado
- Vulnerabilidades de segurança
- Problemas de performance

---

#### **1.2. ESLint** ⭐⭐⭐⭐⭐ (Já Instalado)
- **ID:** `dbaeumer.vscode-eslint`
- **Descrição:** Linter JavaScript com regras extensíveis
- **Funcionalidades:**
  - Detecção de erros e warnings
  - Regras de estilo de código
  - Regras de segurança
  - Regras de qualidade

**Configuração avançada (`.eslintrc.json`):**
```json
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:security/recommended"
  ],
  "plugins": ["security"],
  "parserOptions": {
    "ecmaVersion": 2021,
    "sourceType": "module"
  },
  "rules": {
    "no-console": "warn",
    "no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "no-duplicate-imports": "error",
    "no-var": "error",
    "prefer-const": "error",
    "eqeqeq": ["error", "always"],
    "curly": ["error", "all"],
    "no-eval": "error",
    "no-implied-eval": "error",
    "security/detect-object-injection": "warn",
    "security/detect-eval-with-expression": "error"
  }
}
```

**Instalação de plugin de segurança:**
```bash
npm install --save-dev eslint-plugin-security
```

---

#### **1.3. PHP_CodeSniffer** ⭐⭐⭐⭐
- **ID:** `valeryanm.vscode-phpsab`
- **Descrição:** Integração do PHP_CodeSniffer e PHP CS Fixer no VS Code
- **Funcionalidades:**
  - Detecção de violações de padrões de código
  - Correção automática de problemas
  - Suporte a PSR-12, PSR-2, etc.

**Configuração (`.vscode/settings.json`):**
```json
{
  "phpsab.standard": "PSR12",
  "phpsab.executablePath": "phpcs",
  "phpsab.autoExecutable": true,
  "phpsab.snifferEnable": true,
  "phpsab.fixerEnable": true
}
```

**Instalação:**
```bash
composer global require "squizlabs/php_codesniffer=*"
composer global require "friendsofphp/php-cs-fixer"
```

---

#### **1.4. Code Spell Checker** ⭐⭐⭐
- **ID:** `streetsidesoftware.code-spell-checker`
- **Descrição:** Verifica ortografia em código, comentários e strings
- **Funcionalidades:**
  - Detecção de erros de ortografia
  - Dicionário personalizável
  - Suporte a múltiplas linguagens

**Configuração (`.vscode/settings.json`):**
```json
{
  "cSpell.language": "en,pt",
  "cSpell.words": [
    "OctaDesk",
    "Webflow",
    "WhatsApp",
    "Intelephense",
    "bssegurosimediato"
  ]
}
```

---

#### **1.5. Error Lens** ⭐⭐⭐⭐
- **ID:** `usernamehw.errorlens`
- **Descrição:** Melhora a visualização de erros e warnings inline
- **Funcionalidades:**
  - Mostra erros diretamente no código
  - Destaque visual de problemas
  - Contagem de problemas por arquivo

---

### **2. FERRAMENTAS EXTERNAS (Análise Completa)**

#### **2.1. SonarQube** ⭐⭐⭐⭐⭐
- **Tipo:** Servidor de análise de código
- **Descrição:** Plataforma completa de análise estática de código
- **Funcionalidades:**
  - Análise de qualidade de código
  - Detecção de vulnerabilidades
  - Cobertura de testes
  - Métricas de código
  - Dashboard de qualidade

**Integração com VS Code:**
- Use SonarLint (extensão acima) para integração

**Instalação Local (Docker):**
```bash
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
```

**Análise de Projeto:**
```bash
# Instalar SonarScanner
npm install -g sonarqube-scanner

# Executar análise
sonar-scanner \
  -Dsonar.projectKey=imediatoseguros \
  -Dsonar.sources=WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=seu-token
```

---

#### **2.2. PHPStan** ⭐⭐⭐⭐⭐
- **Tipo:** Analisador estático PHP
- **Descrição:** Encontra bugs sem executar o código
- **Níveis:** 0-9 (quanto maior, mais rigoroso)

**Instalação:**
```bash
composer require --dev phpstan/phpstan
```

**Configuração (`phpstan.neon`):**
```neon
parameters:
    level: 5
    paths:
        - WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT
    excludePaths:
        - WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups
    ignoreErrors:
        - '#Call to an undefined method#'
```

**Execução:**
```bash
vendor/bin/phpstan analyse WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT
```

**Integração com VS Code:**
- **Extensão:** `swordev.phpstan`

---

#### **2.3. Psalm** ⭐⭐⭐⭐⭐
- **Tipo:** Analisador estático PHP
- **Descrição:** Encontra bugs e melhora código PHP
- **Vantagem:** Mais rápido que PHPStan

**Instalação:**
```bash
composer require --dev vimeo/psalm
```

**Configuração (`psalm.xml`):**
```xml
<?xml version="1.0"?>
<psalm
    errorLevel="5"
    resolveFromConfigFile="true"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="https://getpsalm.org/schema/config"
    xsi:schemaLocation="https://getpsalm.org/schema/config vendor/vimeo/psalm/config.xsd"
>
    <projectFiles>
        <directory name="WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT" />
        <ignoreFiles>
            <directory name="backups" />
        </ignoreFiles>
    </projectFiles>
</psalm>
```

**Execução:**
```bash
vendor/bin/psalm
```

---

#### **2.4. Snyk Code** ⭐⭐⭐⭐⭐
- **Tipo:** Análise de segurança de código
- **Descrição:** Detecta vulnerabilidades de segurança em tempo real
- **Integração:** GitHub, GitLab, Bitbucket, VS Code

**Extensão VS Code:**
- **ID:** `snyk-security.snyk-vulnerability-scanner`

**Configuração:**
```json
{
  "snyk.enable": true,
  "snyk.token": "seu-token-snyk"
}
```

**Problemas Detectados:**
- Vulnerabilidades OWASP Top 10
- Hardcoded credentials
- SQL Injection
- XSS
- CSRF

---

#### **2.5. CodeQL** ⭐⭐⭐⭐
- **Tipo:** Análise de código baseada em queries
- **Descrição:** GitHub CodeQL para análise de segurança
- **Uso:** Mais complexo, mas muito poderoso

**Instalação:**
```bash
# Via GitHub CLI
gh extension install github/gh-codeql
```

---

### **3. FERRAMENTAS DE REVISÃO AUTOMATIZADA**

#### **3.1. CodeRabbit** ⭐⭐⭐⭐
- **Tipo:** Code Review AI
- **Descrição:** Revisão automática de Pull Requests usando IA
- **Integração:** GitHub, GitLab, Bitbucket
- **Funcionalidades:**
  - Análise de código em PRs
  - Sugestões de melhorias
  - Detecção de bugs
  - Análise de segurança

**Website:** https://coderabbit.ai/

---

#### **3.2. DeepCode** ⭐⭐⭐⭐
- **Tipo:** Code Review AI
- **Descrição:** Análise de código usando machine learning
- **Integração:** GitHub, GitLab, Bitbucket, VS Code

**Extensão VS Code:**
- **ID:** `DeepCode.deepcode`

---

#### **3.3. Codacy** ⭐⭐⭐⭐
- **Tipo:** Plataforma de qualidade de código
- **Descrição:** Análise automática de código em commits e PRs
- **Integração:** GitHub, GitLab, Bitbucket

**Website:** https://www.codacy.com/

---

### **4. FERRAMENTAS ESPECÍFICAS PARA INCONSISTÊNCIAS**

#### **4.1. jscpd** ⭐⭐⭐⭐
- **Tipo:** Detector de código duplicado
- **Descrição:** Encontra código duplicado em JavaScript, PHP, etc.

**Instalação:**
```bash
npm install -g jscpd
```

**Execução:**
```bash
jscpd WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT --min-lines 5 --min-tokens 50
```

**Configuração (`.jscpdrc.json`):**
```json
{
  "threshold": 0,
  "reporters": ["console", "html"],
  "ignore": [
    "**/backups/**",
    "**/node_modules/**"
  ],
  "minLines": 5,
  "minTokens": 50
}
```

---

#### **4.2. PMD** ⭐⭐⭐⭐
- **Tipo:** Analisador de código
- **Descrição:** Encontra problemas comuns em código
- **Linguagens:** Java, JavaScript, PHP, etc.

**Para PHP:**
```bash
composer require --dev phpmd/phpmd
```

**Execução:**
```bash
vendor/bin/phpmd WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT text codesize,unusedcode,naming
```

---

#### **4.3. PHP Mess Detector (PHPMD)** ⭐⭐⭐⭐
- **Tipo:** Analisador de código PHP
- **Descrição:** Detecta problemas em código PHP

**Regras Disponíveis:**
- `codesize` - Complexidade e tamanho
- `unusedcode` - Código não utilizado
- `naming` - Problemas de nomenclatura
- `design` - Problemas de design
- `controversial` - Regras controversas

**Execução:**
```bash
vendor/bin/phpmd WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT text codesize,unusedcode,naming
```

---

## 📊 COMPARAÇÃO DE FERRAMENTAS

| Ferramenta | Tipo | Linguagens | Foco Principal | Integração VS Code |
|------------|------|------------|----------------|-------------------|
| **SonarLint** | Extensão | Múltiplas | Qualidade geral | ✅ Sim |
| **ESLint** | Extensão | JavaScript | Linting | ✅ Sim |
| **PHP_CodeSniffer** | Extensão | PHP | Padrões de código | ✅ Sim |
| **PHPStan** | CLI | PHP | Análise estática | ✅ Sim (extensão) |
| **Psalm** | CLI | PHP | Análise estática | ✅ Sim (extensão) |
| **Snyk Code** | Extensão | Múltiplas | Segurança | ✅ Sim |
| **jscpd** | CLI | Múltiplas | Código duplicado | ❌ Não |
| **PHPMD** | CLI | PHP | Code smells | ❌ Não |

---

## 🎯 RECOMENDAÇÃO PARA O PROJETO

### **Configuração Recomendada:**

#### **Fase 1: Extensões Essenciais (Já Instaladas)**
- ✅ ESLint (JavaScript)
- ✅ PHP Intelephense (PHP)

#### **Fase 2: Extensões de Análise (Recomendadas)**
- ⭐ **SonarLint** - Análise completa de qualidade
- ⭐ **PHP_CodeSniffer** - Padrões PHP
- ⭐ **Error Lens** - Visualização de erros
- ⭐ **Code Spell Checker** - Ortografia

#### **Fase 3: Ferramentas CLI (Opcionais)**
- ⭐ **PHPStan** - Análise estática PHP (nível 5)
- ⭐ **jscpd** - Detecção de código duplicado
- ⭐ **PHPMD** - Code smells PHP

#### **Fase 4: Ferramentas Externas (Avançado)**
- ⭐ **SonarQube** - Servidor de análise completo
- ⭐ **Snyk Code** - Análise de segurança

---

## 📋 CONFIGURAÇÃO COMPLETA RECOMENDADA

### **`.vscode/settings.json` (Adicionar):**

```json
{
  // ==================== SonarLint ====================
  "sonarlint.connectedMode.servers": [],
  "sonarlint.rules": {
    "php": {
      "S1481": "error",   // Unused local variables
      "S3776": "error",   // Cognitive Complexity
      "S138": "warning",  // Functions should not have too many lines
      "S1192": "warning"  // String literals should not be duplicated
    },
    "javascript": {
      "S1481": "error",   // Unused local variables
      "S3776": "error",   // Cognitive Complexity
      "S138": "warning",  // Functions should not have too many lines
      "S1192": "warning"  // String literals should not be duplicated
    }
  },

  // ==================== PHP_CodeSniffer ====================
  "phpsab.standard": "PSR12",
  "phpsab.executablePath": "phpcs",
  "phpsab.autoExecutable": true,
  "phpsab.snifferEnable": true,
  "phpsab.fixerEnable": true,

  // ==================== Code Spell Checker ====================
  "cSpell.language": "en,pt",
  "cSpell.words": [
    "OctaDesk",
    "Webflow",
    "WhatsApp",
    "Intelephense",
    "bssegurosimediato",
    "safetymails",
    "FlyingDonkeys",
    "EspoCrm"
  ],

  // ==================== Error Lens ====================
  "errorLens.enabled": true,
  "errorLens.enabledDiagnosticLevels": ["error", "warning"],
  "errorLens.followCursor": "activeLine"
}
```

---

## 🚀 SCRIPTS DE ANÁLISE AUTOMATIZADA

### **`scripts/analisar-codigo.sh`:**

```bash
#!/bin/bash

echo "🔍 ANÁLISE DE CÓDIGO - Detecção de Inconsistências"
echo "=================================================="

# Diretório base
BASE_DIR="WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT"

# 1. PHPStan (se instalado)
if command -v vendor/bin/phpstan &> /dev/null; then
    echo ""
    echo "📊 PHPStan - Análise Estática PHP"
    echo "-----------------------------------"
    vendor/bin/phpstan analyse $BASE_DIR --level=5
fi

# 2. jscpd - Código Duplicado
if command -v jscpd &> /dev/null; then
    echo ""
    echo "📊 jscpd - Detecção de Código Duplicado"
    echo "----------------------------------------"
    jscpd $BASE_DIR --min-lines 5 --min-tokens 50 --reporters console
fi

# 3. PHPMD (se instalado)
if command -v vendor/bin/phpmd &> /dev/null; then
    echo ""
    echo "📊 PHPMD - Code Smells PHP"
    echo "--------------------------"
    vendor/bin/phpmd $BASE_DIR text codesize,unusedcode,naming
fi

echo ""
echo "✅ Análise concluída!"
```

### **`scripts/analisar-codigo.ps1` (PowerShell):**

```powershell
Write-Host "🔍 ANÁLISE DE CÓDIGO - Detecção de Inconsistências" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

$baseDir = "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"

# 1. PHPStan (se instalado)
if (Test-Path "vendor\bin\phpstan.bat") {
    Write-Host ""
    Write-Host "📊 PHPStan - Análise Estática PHP" -ForegroundColor Yellow
    Write-Host "-----------------------------------" -ForegroundColor Yellow
    & vendor\bin\phpstan.bat analyse $baseDir --level=5
}

# 2. jscpd - Código Duplicado
if (Get-Command jscpd -ErrorAction SilentlyContinue) {
    Write-Host ""
    Write-Host "📊 jscpd - Detecção de Código Duplicado" -ForegroundColor Yellow
    Write-Host "----------------------------------------" -ForegroundColor Yellow
    jscpd $baseDir --min-lines 5 --min-tokens 50 --reporters console
}

# 3. PHPMD (se instalado)
if (Test-Path "vendor\bin\phpmd.bat") {
    Write-Host ""
    Write-Host "📊 PHPMD - Code Smells PHP" -ForegroundColor Yellow
    Write-Host "--------------------------" -ForegroundColor Yellow
    & vendor\bin\phpmd.bat $baseDir text codesize,unusedcode,naming
}

Write-Host ""
Write-Host "✅ Análise concluída!" -ForegroundColor Green
```

---

## 📝 CHECKLIST DE INSTALAÇÃO

### **Extensões VS Code/Cursor:**
- [ ] SonarLint (`SonarSource.sonarlint-vscode`)
- [ ] PHP_CodeSniffer (`valeryanm.vscode-phpsab`)
- [ ] Error Lens (`usernamehw.errorlens`)
- [ ] Code Spell Checker (`streetsidesoftware.code-spell-checker`)
- [ ] Snyk Code (`snyk-security.snyk-vulnerability-scanner`) - Opcional

### **Ferramentas CLI (Opcionais):**
- [ ] PHPStan (`composer require --dev phpstan/phpstan`)
- [ ] jscpd (`npm install -g jscpd`)
- [ ] PHPMD (`composer require --dev phpmd/phpmd`)

---

## ✅ BENEFÍCIOS ESPERADOS

### **Detecção Automática:**
- ✅ Inconsistências de nomenclatura
- ✅ Código duplicado
- ✅ Variáveis não utilizadas
- ✅ Funções muito complexas
- ✅ Vulnerabilidades de segurança
- ✅ Code smells
- ✅ Problemas de performance

### **Melhoria de Qualidade:**
- ✅ Código mais consistente
- ✅ Menos bugs em produção
- ✅ Melhor manutenibilidade
- ✅ Padrões de código seguidos

---

## 🔗 LINKS ÚTEIS

- **SonarLint:** https://www.sonarlint.org/
- **PHPStan:** https://phpstan.org/
- **Psalm:** https://psalm.dev/
- **Snyk Code:** https://snyk.io/product/snyk-code/
- **jscpd:** https://github.com/kucherenko/jscpd
- **PHPMD:** https://phpmd.org/

---

**Documento criado em:** 22/11/2025  
**Última atualização:** 22/11/2025  
**Versão:** 1.0.0

