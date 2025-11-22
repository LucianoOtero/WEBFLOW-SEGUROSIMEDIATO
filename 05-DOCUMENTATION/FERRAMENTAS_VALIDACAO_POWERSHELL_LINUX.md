# 🔧 FERRAMENTAS: Validação PowerShell e Linux

**Data:** 21/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **FERRAMENTAS DOCUMENTADAS**

---

## 🎯 OBJETIVO

Documentar ferramentas nativas e disponíveis para **validação de sintaxe** em:
- ✅ PowerShell (Windows)
- ✅ Linux (Servidor)
- ✅ PHP, JavaScript, SQL, Bash, Configurações

---

## 💻 FERRAMENTAS POWERSHELL (WINDOWS)

### **1. Validação de Sintaxe PowerShell**

#### **1.1. PSScriptAnalyzer** ⭐⭐⭐⭐⭐
- **Descrição:** Analisador estático de código PowerShell
- **Instalação:**
  ```powershell
  Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
  ```
- **Uso:**
  ```powershell
  # Validar script PowerShell
  Invoke-ScriptAnalyzer -Path .\replicar-php-prod.ps1
  
  # Validar com regras específicas
  Invoke-ScriptAnalyzer -Path .\replicar-php-prod.ps1 -Severity Error,Warning
  ```
- **Funcionalidades:**
  - ✅ Validação de sintaxe PowerShell
  - ✅ Detecção de problemas de estilo
  - ✅ Sugestões de melhorias
  - ✅ Análise de código estático

#### **1.2. Validação de Sintaxe PowerShell (Built-in)**
- **Comando:** `powershell -File script.ps1 -WhatIf`
- **Uso:**
  ```powershell
  # Validar sintaxe sem executar
  powershell -Command "& { $ErrorActionPreference='Stop'; . '.\script.ps1' }" -WhatIf
  ```
- **Limitação:** Não valida sintaxe completamente, apenas tenta executar

#### **1.3. PowerShell ISE / VS Code PowerShell Extension**
- **Descrição:** Validação em tempo real no editor
- **Uso:** Já instalado (PowerShell Extension no Cursor)
- **Funcionalidades:**
  - ✅ Validação em tempo real
  - ✅ Detecção de erros antes de executar
  - ✅ IntelliSense

---

### **2. Validação de Sintaxe PHP (Windows)**

#### **2.1. PHP CLI (php -l)** ⭐⭐⭐⭐⭐
- **Descrição:** Validador de sintaxe PHP nativo
- **Instalação:** Requer PHP instalado no Windows
- **Uso:**
  ```powershell
  # Validar sintaxe PHP
  php -l config.php
  # Output: No syntax errors detected in config.php
  ```
- **Integração em Scripts:**
  ```powershell
  $sintaxe = php -l $arquivoLocal 2>&1
  if ($LASTEXITCODE -ne 0) {
      Write-Host "❌ ERRO: Sintaxe PHP inválida" -ForegroundColor Red
      exit 1
  }
  ```

---

### **3. Validação de Sintaxe JavaScript (Windows)**

#### **3.1. Node.js (node --check)** ⭐⭐⭐⭐
- **Descrição:** Validador de sintaxe JavaScript via Node.js
- **Instalação:** Requer Node.js instalado
- **Uso:**
  ```powershell
  # Validar sintaxe JavaScript
  node --check FooterCodeSiteDefinitivoCompleto.js
  ```
- **Limitação:** Requer Node.js instalado

#### **3.2. ESLint CLI** ⭐⭐⭐⭐⭐
- **Descrição:** Validador de sintaxe JavaScript via ESLint
- **Instalação:**
  ```powershell
  npm install -g eslint
  ```
- **Uso:**
  ```powershell
  # Validar sintaxe JavaScript
  eslint FooterCodeSiteDefinitivoCompleto.js
  ```

---

## 🐧 FERRAMENTAS LINUX (SERVIDOR)

### **1. Validação de Sintaxe Bash**

#### **1.1. bash -n** ⭐⭐⭐⭐⭐
- **Descrição:** Validador de sintaxe Bash nativo
- **Uso:**
  ```bash
  # Validar sintaxe bash sem executar
  bash -n script.sh
  ```
- **Exemplo:**
  ```bash
  # Validar script antes de executar
  if bash -n deploy.sh; then
      echo "✅ Sintaxe válida"
      bash deploy.sh
  else
      echo "❌ Erro de sintaxe"
      exit 1
  fi
  ```

#### **1.2. shellcheck** ⭐⭐⭐⭐⭐
- **Descrição:** Analisador estático de código Bash/Shell
- **Instalação:**
  ```bash
  # Ubuntu/Debian
  apt install shellcheck
  
  # CentOS/RHEL
  yum install shellcheck
  ```
- **Uso:**
  ```bash
  # Validar script bash
  shellcheck script.sh
  
  # Validar com saída formatada
  shellcheck -f gcc script.sh
  ```
- **Funcionalidades:**
  - ✅ Validação de sintaxe Bash
  - ✅ Detecção de problemas comuns
  - ✅ Sugestões de melhorias
  - ✅ Análise de código estático

---

### **2. Validação de Sintaxe PHP (Linux)**

#### **2.1. php -l** ⭐⭐⭐⭐⭐
- **Descrição:** Validador de sintaxe PHP nativo
- **Uso:**
  ```bash
  # Validar sintaxe PHP
  php -l config.php
  # Output: No syntax errors detected in config.php
  ```
- **Integração em Scripts:**
  ```bash
  # Validar antes de copiar
  if php -l arquivo.php; then
      echo "✅ Sintaxe PHP válida"
      scp arquivo.php servidor:/destino/
  else
      echo "❌ Erro de sintaxe PHP"
      exit 1
    fi
  ```

#### **2.2. php-fpm -tt** ⭐⭐⭐⭐⭐
- **Descrição:** Validador de configuração PHP-FPM
- **Uso:**
  ```bash
  # Validar configuração PHP-FPM
  php-fpm8.3 -tt
  # Output: [OK] Configuration file is valid
  ```
- **Integração em Scripts:**
  ```bash
  # Validar antes de recarregar
  if php-fpm8.3 -tt; then
      echo "✅ Configuração PHP-FPM válida"
      systemctl reload php8.3-fpm
  else
      echo "❌ Erro na configuração PHP-FPM"
      exit 1
    fi
  ```

---

### **3. Validação de Configuração Nginx (Linux)**

#### **3.1. nginx -t** ⭐⭐⭐⭐⭐
- **Descrição:** Validador de configuração Nginx nativo
- **Uso:**
  ```bash
  # Validar configuração Nginx
  nginx -t
  # Output: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
  #         nginx: configuration file /etc/nginx/nginx.conf test is successful
  ```
- **Integração em Scripts:**
  ```bash
  # Validar antes de recarregar
  if nginx -t; then
      echo "✅ Configuração Nginx válida"
      systemctl reload nginx
  else
      echo "❌ Erro na configuração Nginx"
      exit 1
    fi
  ```

---

### **4. Validação de Sintaxe SQL (Linux)**

#### **4.1. mysql --help** ⭐⭐⭐⭐
- **Descrição:** Validação básica via MySQL CLI
- **Uso:**
  ```bash
  # Validar sintaxe SQL (executando em modo dry-run)
  mysql -u user -p database -e "EXPLAIN SELECT * FROM table;" 2>&1
  ```
- **Limitação:** Não valida sintaxe completamente sem executar

#### **4.2. mysqldump --help** ⭐⭐⭐
- **Descrição:** Validação indireta via mysqldump
- **Uso:**
  ```bash
  # Validar estrutura do banco
  mysqldump -u user -p --no-data database > /dev/null
  ```

---

### **5. Validação de Hash (Linux)**

#### **5.1. sha256sum** ⭐⭐⭐⭐⭐
- **Descrição:** Validador de integridade de arquivos
- **Uso:**
  ```bash
  # Calcular hash SHA256
  sha256sum arquivo.php
  # Output: abc123... arquivo.php
  
  # Comparar hashes
  sha256sum arquivo.php | awk '{print $1}'
  ```

#### **5.2. md5sum** ⭐⭐⭐⭐
- **Descrição:** Validador de integridade MD5 (alternativa)
- **Uso:**
  ```bash
  # Calcular hash MD5
  md5sum arquivo.php
  ```

---

## 📋 INTEGRAÇÃO EM SCRIPTS POWERSHELL

### **Script de Validação Completa:**

```powershell
# scripts/validar-antes-deploy.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$TipoArquivo,  # "php", "js", "ps1", "sql"
    
    [Parameter(Mandatory=$true)]
    [string]$Arquivo
)

$ErrorActionPreference = "Stop"

function Write-ValidationLog {
    param([string]$Message, [string]$Level = "INFO")
    Write-Host "[$Level] $Message"
}

Write-ValidationLog "Validando arquivo: $Arquivo" "INFO"
Write-ValidationLog "Tipo: $TipoArquivo" "INFO"

switch ($TipoArquivo.ToLower()) {
    "php" {
        Write-ValidationLog "Validando sintaxe PHP..." "INFO"
        $result = php -l $Arquivo 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-ValidationLog "✅ Sintaxe PHP válida" "SUCCESS"
            exit 0
        } else {
            Write-ValidationLog "❌ Erro de sintaxe PHP:" "ERROR"
            Write-Host $result -ForegroundColor Red
            exit 1
        }
    }
    
    "js" {
        Write-ValidationLog "Validando sintaxe JavaScript..." "INFO"
        if (Get-Command node -ErrorAction SilentlyContinue) {
            $result = node --check $Arquivo 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-ValidationLog "✅ Sintaxe JavaScript válida" "SUCCESS"
                exit 0
            } else {
                Write-ValidationLog "❌ Erro de sintaxe JavaScript:" "ERROR"
                Write-Host $result -ForegroundColor Red
                exit 1
            }
        } else {
            Write-ValidationLog "⚠️ Node.js não encontrado - pulando validação JavaScript" "WARN"
            exit 0
        }
    }
    
    "ps1" {
        Write-ValidationLog "Validando sintaxe PowerShell..." "INFO"
        if (Get-Module -ListAvailable -Name PSScriptAnalyzer) {
            $result = Invoke-ScriptAnalyzer -Path $Arquivo -Severity Error,Warning 2>&1
            if ($result.Count -eq 0) {
                Write-ValidationLog "✅ Sintaxe PowerShell válida" "SUCCESS"
                exit 0
            } else {
                Write-ValidationLog "❌ Problemas encontrados:" "ERROR"
                $result | ForEach-Object { Write-Host $_ -ForegroundColor Red }
                exit 1
            }
        } else {
            Write-ValidationLog "⚠️ PSScriptAnalyzer não encontrado - pulando validação PowerShell" "WARN"
            exit 0
        }
    }
    
    "sql" {
        Write-ValidationLog "⚠️ Validação SQL requer conexão com banco de dados" "WARN"
        Write-ValidationLog "Use SQL Tools no Cursor para validar sintaxe SQL" "INFO"
        exit 0
    }
    
    default {
        Write-ValidationLog "❌ Tipo de arquivo não suportado: $TipoArquivo" "ERROR"
        exit 1
    }
}
```

---

## 📋 INTEGRAÇÃO EM SCRIPTS BASH (LINUX)

### **Script de Validação Completa:**

```bash
#!/bin/bash
# scripts/validar-antes-deploy.sh

TIPO_ARQUIVO=$1
ARQUIVO=$2

if [ -z "$TIPO_ARQUIVO" ] || [ -z "$ARQUIVO" ]; then
    echo "Uso: $0 <tipo> <arquivo>"
    echo "Tipos: php, bash, nginx, php-fpm"
    exit 1
fi

echo "[INFO] Validando arquivo: $ARQUIVO"
echo "[INFO] Tipo: $TIPO_ARQUIVO"

case $TIPO_ARQUIVO in
    php)
        echo "[INFO] Validando sintaxe PHP..."
        if php -l "$ARQUIVO"; then
            echo "[SUCCESS] ✅ Sintaxe PHP válida"
            exit 0
        else
            echo "[ERROR] ❌ Erro de sintaxe PHP"
            exit 1
        fi
        ;;
    
    bash)
        echo "[INFO] Validando sintaxe Bash..."
        if bash -n "$ARQUIVO"; then
            echo "[SUCCESS] ✅ Sintaxe Bash válida"
            if command -v shellcheck &> /dev/null; then
                echo "[INFO] Executando shellcheck..."
                shellcheck "$ARQUIVO"
            fi
            exit 0
        else
            echo "[ERROR] ❌ Erro de sintaxe Bash"
            exit 1
        fi
        ;;
    
    nginx)
        echo "[INFO] Validando configuração Nginx..."
        if nginx -t; then
            echo "[SUCCESS] ✅ Configuração Nginx válida"
            exit 0
        else
            echo "[ERROR] ❌ Erro na configuração Nginx"
            exit 1
        fi
        ;;
    
    php-fpm)
        echo "[INFO] Validando configuração PHP-FPM..."
        if php-fpm8.3 -tt; then
            echo "[SUCCESS] ✅ Configuração PHP-FPM válida"
            exit 0
        else
            echo "[ERROR] ❌ Erro na configuração PHP-FPM"
            exit 1
        fi
        ;;
    
    *)
        echo "[ERROR] ❌ Tipo não suportado: $TIPO_ARQUIVO"
        exit 1
        ;;
esac
```

---

## 📊 RESUMO DAS FERRAMENTAS

### **PowerShell (Windows):**

| Ferramenta | Comando | Uso |
|------------|---------|-----|
| **PSScriptAnalyzer** | `Invoke-ScriptAnalyzer` | Validação PowerShell |
| **PHP CLI** | `php -l` | Validação PHP |
| **Node.js** | `node --check` | Validação JavaScript |
| **ESLint CLI** | `eslint` | Validação JavaScript |

### **Linux (Servidor):**

| Ferramenta | Comando | Uso |
|------------|---------|-----|
| **bash -n** | `bash -n script.sh` | Validação Bash |
| **shellcheck** | `shellcheck script.sh` | Análise Bash |
| **php -l** | `php -l arquivo.php` | Validação PHP |
| **php-fpm -tt** | `php-fpm8.3 -tt` | Validação PHP-FPM |
| **nginx -t** | `nginx -t` | Validação Nginx |
| **sha256sum** | `sha256sum arquivo` | Validação Hash |

---

## ✅ CHECKLIST DE INSTALAÇÃO

### **Windows (PowerShell):**
- [ ] Instalar PHP CLI (se não estiver instalado)
- [ ] Instalar PSScriptAnalyzer: `Install-Module -Name PSScriptAnalyzer`
- [ ] Instalar Node.js (opcional, para validação JavaScript)
- [ ] Instalar ESLint CLI (opcional): `npm install -g eslint`

### **Linux (Servidor):**
- [ ] Instalar shellcheck: `apt install shellcheck`
- [ ] Verificar PHP CLI: `php -l --version`
- [ ] Verificar PHP-FPM: `php-fpm8.3 -tt`
- [ ] Verificar Nginx: `nginx -t`

---

## 🎯 CONCLUSÃO

### **Ferramentas Essenciais:**

**PowerShell:**
- ✅ **PSScriptAnalyzer** - Validação PowerShell
- ✅ **PHP CLI** - Validação PHP
- ✅ **PowerShell Extension** - Validação em tempo real (já instalado)

**Linux:**
- ✅ **bash -n** - Validação Bash (nativo)
- ✅ **shellcheck** - Análise Bash (recomendado instalar)
- ✅ **php -l** - Validação PHP (nativo)
- ✅ **php-fpm -tt** - Validação PHP-FPM (nativo)
- ✅ **nginx -t** - Validação Nginx (nativo)

**Combinando essas ferramentas:**
- ✅ Validação completa antes de deploy
- ✅ Detecção de erros antes de aplicar mudanças
- ✅ Integração com scripts de deploy
- ✅ Processo automatizado e confiável

---

**Ferramentas documentadas para validação PowerShell e Linux.**

