# 🔍 FERRAMENTAS DE GRAVAÇÃO NO POWERSHELL

**Data:** 21/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **FERRAMENTAS DOCUMENTADAS**

---

## 🎯 OBJETIVO

Documentar ferramentas nativas do PowerShell para **gravar sessões e comandos**:
- ✅ Gravar todas as sessões PowerShell
- ✅ Gravar comandos executados
- ✅ Gravar saídas dos comandos
- ✅ Histórico completo e auditável

---

## 📝 START-TRANSCRIPT ⭐⭐⭐⭐⭐

### **1. Descrição**

**Start-Transcript** é o comando nativo do PowerShell para gravar sessões completas:
- ✅ Grava todos os comandos executados
- ✅ Grava todas as saídas dos comandos
- ✅ Grava timestamps
- ✅ Grava erros e warnings
- ✅ Funciona em todas as versões do PowerShell

---

### **2. Uso Básico**

#### **2.1. Iniciar Gravação**

```powershell
# Iniciar gravação com arquivo específico
Start-Transcript -Path "C:\logs\powershell_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# Iniciar gravação com arquivo padrão
Start-Transcript

# Iniciar gravação com append (adicionar ao arquivo existente)
Start-Transcript -Path "C:\logs\powershell.log" -Append
```

#### **2.2. Parar Gravação**

```powershell
# Parar gravação
Stop-Transcript
```

#### **2.3. Verificar Status**

```powershell
# Verificar se está gravando
$Host.UI.RawUI.BufferSize

# Verificar arquivo de transcript atual
$PSDefaultParameterValues['*:Transcript']
```

---

### **3. Configuração Automática**

#### **3.1. Perfil do PowerShell**

**Arquivo:** `$PROFILE`

```powershell
# Criar diretório de logs se não existir
$logDir = "C:\Users\$env:USERNAME\Documents\PowerShell\Logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Iniciar transcript automaticamente
$logFile = Join-Path $logDir "PowerShell_$(Get-Date -Format 'yyyyMMdd').log"
Start-Transcript -Path $logFile -Append

# Função para parar transcript antes de sair
function Stop-TranscriptOnExit {
    Stop-Transcript
}
Register-EngineEvent PowerShell.Exiting -Action { Stop-TranscriptOnExit }
```

#### **3.2. Aplicar Perfil**

```powershell
# Verificar se perfil existe
Test-Path $PROFILE

# Criar perfil se não existir
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# Editar perfil
notepad $PROFILE

# Recarregar perfil
. $PROFILE
```

---

### **4. Exemplo de Log Gerado**

```
**********************
Windows PowerShell transcript start
Start time: 20251121153000
Username: DESKTOP-USER\Luciano
Machine: DESKTOP-USER (Microsoft Windows NT 10.0.26200.0)
Host Application: C:\Program Files\PowerShell\7\pwsh.exe
Process ID: 12345
PSVersion: 7.4.0
PSEdition: Core
GitCommitId: 7.4.0
OS: Microsoft Windows 10.0.26200
Platform: Win32NT
PSCompatibleVersions: 1.0, 2.0, 3.0, 4.0, 5.0, 5.1.10032.0, 6.0.0, 6.1.0, 6.2.0, 7.0.0, 7.1.0, 7.2.0, 7.3.0, 7.4.0
PSRemotingProtocolVersion: 2.3
SerializationVersion: 1.1.0.1
WSManStackVersion: 3.0
**********************

PS C:\Users\Luciano> scp config.php root@65.108.156.14:/var/www/html/dev/root/
config.php                                                                    100%   1234     1.2KB/s   00:01

PS C:\Users\Luciano> ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/config.php"
abc123def456...  /var/www/html/dev/root/config.php

PS C:\Users\Luciano> Stop-Transcript
**********************
Windows PowerShell transcript end
End time: 20251121153015
**********************
```

---

## 📋 GET-HISTORY ⭐⭐⭐⭐

### **1. Descrição**

**Get-History** mostra histórico de comandos executados na sessão atual:
- ✅ Lista comandos executados
- ✅ Mostra timestamps
- ✅ Mostra IDs dos comandos
- ✅ Permite reexecutar comandos

---

### **2. Uso**

#### **2.1. Ver Histórico**

```powershell
# Ver histórico completo
Get-History

# Ver últimos 10 comandos
Get-History -Count 10

# Ver histórico formatado
Get-History | Format-Table -AutoSize

# Ver histórico com detalhes
Get-History | Format-List
```

#### **2.2. Exportar Histórico**

```powershell
# Exportar para arquivo
Get-History | Export-Csv -Path "C:\logs\powershell_history_$(Get-Date -Format 'yyyyMMdd').csv" -NoTypeInformation

# Exportar para arquivo de texto
Get-History | Out-File -FilePath "C:\logs\powershell_history_$(Get-Date -Format 'yyyyMMdd').txt"

# Exportar apenas comandos
Get-History | Select-Object -ExpandProperty CommandLine | Out-File -FilePath "C:\logs\commands.txt"
```

#### **2.3. Limpar Histórico**

```powershell
# Limpar histórico da sessão atual
Clear-History

# Limpar histórico específico
Remove-History -Id 1,2,3
```

---

### **3. Configuração de Histórico**

#### **3.1. Aumentar Tamanho do Histórico**

```powershell
# Ver tamanho atual
$MaximumHistoryCount

# Aumentar para 10000 comandos
$MaximumHistoryCount = 10000

# Tornar permanente (adicionar ao perfil)
Add-Content -Path $PROFILE -Value "`$MaximumHistoryCount = 10000"
```

---

## 🔍 GET-PSCALLSTACK ⭐⭐⭐

### **1. Descrição**

**Get-PSCallStack** mostra pilha de chamadas (call stack):
- ✅ Mostra funções chamadas
- ✅ Mostra scripts executados
- ✅ Útil para debugging

---

### **2. Uso**

```powershell
# Ver call stack atual
Get-PSCallStack

# Ver call stack formatado
Get-PSCallStack | Format-List
```

---

## 📊 LOGGING INTEGRADO EM SCRIPTS

### **1. Função de Logging para Scripts**

```powershell
# Adicionar no início de cada script
$LOG_FILE = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright\WEBFLOW-SEGUROSIMEDIATO\05-DOCUMENTATION\LOGS_SCRIPTS_$(Get-Date -Format 'yyyyMMdd').log"

function Write-ScriptLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Write-Host $logEntry
    $logEntry | Out-File -FilePath $LOG_FILE -Append
}

# Logar início do script
Write-ScriptLog "INICIANDO: replicar-php-prod.ps1 - Arquivo: $arquivo" "INFO"

# Logar cada ação importante
Write-ScriptLog "Hash local calculado: $hashLocal" "INFO"
Write-ScriptLog "Arquivo copiado para servidor" "SUCCESS"

# Logar fim do script
Write-ScriptLog "FIM: replicar-php-prod.ps1 - Status: Sucesso" "SUCCESS"
```

---

### **2. Gravar Comandos Executados**

```powershell
# Função para gravar comandos antes de executar
function Invoke-LoggedCommand {
    param(
        [string]$Command,
        [string]$Description
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [COMMAND] $Description`n  Comando: $Command"
    
    Write-Host $logEntry
    $logEntry | Out-File -FilePath $LOG_FILE -Append
    
    # Executar comando
    Invoke-Expression $Command
    
    # Logar resultado
    if ($LASTEXITCODE -eq 0) {
        Write-ScriptLog "Comando executado com sucesso" "SUCCESS"
    } else {
        Write-ScriptLog "Comando falhou com código: $LASTEXITCODE" "ERROR"
    }
}

# Uso
Invoke-LoggedCommand -Command "scp config.php root@servidor:/destino/" -Description "Copiar arquivo PHP para servidor"
```

---

## 🔐 WINDOWS EVENT LOG ⭐⭐⭐⭐

### **1. Descrição**

**Windows Event Log** pode gravar eventos do PowerShell:
- ✅ Gravar eventos de execução de scripts
- ✅ Gravar erros e warnings
- ✅ Integração com sistema de auditoria Windows

---

### **2. Configuração**

#### **2.1. Habilitar Logging de Módulo PowerShell**

```powershell
# Habilitar logging de módulo PowerShell
$configPath = "$env:ProgramFiles\PowerShell\7\pwsh.exe.config"
# Configurar via Group Policy ou Registry
```

#### **2.2. Consultar Event Log**

```powershell
# Ver eventos do PowerShell
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" | Select-Object -First 10

# Ver eventos de execução de script
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" | Where-Object {$_.Message -like "*script*"} | Select-Object -First 10

# Exportar eventos
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" | Export-Csv -Path "C:\logs\powershell_events.csv"
```

---

## 📋 RESUMO DAS FERRAMENTAS

| Ferramenta | Comando | Função | Prioridade |
|------------|---------|--------|------------|
| **Start-Transcript** | `Start-Transcript` | Gravar sessão completa | ⭐⭐⭐⭐⭐ |
| **Get-History** | `Get-History` | Ver histórico de comandos | ⭐⭐⭐⭐ |
| **Get-PSCallStack** | `Get-PSCallStack` | Ver call stack | ⭐⭐⭐ |
| **Logging em Scripts** | Função customizada | Gravar ações de scripts | ⭐⭐⭐⭐⭐ |
| **Windows Event Log** | `Get-WinEvent` | Ver eventos do sistema | ⭐⭐⭐⭐ |

---

## ✅ CONFIGURAÇÃO RECOMENDADA

### **1. Perfil do PowerShell com Transcript Automático**

**Criar arquivo:** `$PROFILE`

```powershell
# Configuração de logging automático
$logDir = "C:\Users\$env:USERNAME\Documents\PowerShell\Logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Iniciar transcript diário
$logFile = Join-Path $logDir "PowerShell_$(Get-Date -Format 'yyyyMMdd').log"
Start-Transcript -Path $logFile -Append

# Aumentar histórico
$MaximumHistoryCount = 10000

# Função para parar transcript ao sair
function Stop-TranscriptOnExit {
    Stop-Transcript -ErrorAction SilentlyContinue
}
Register-EngineEvent PowerShell.Exiting -Action { Stop-TranscriptOnExit }
```

### **2. Aplicar Configuração**

```powershell
# Criar perfil
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# Editar perfil
notepad $PROFILE

# Recarregar perfil
. $PROFILE
```

---

## 🎯 CONCLUSÃO

### **Ferramentas de Gravação PowerShell:**

**Nativas:**
- ✅ **Start-Transcript** - Gravação completa de sessões
- ✅ **Get-History** - Histórico de comandos
- ✅ **Get-PSCallStack** - Call stack para debugging

**Customizadas:**
- ✅ **Logging em Scripts** - Funções de logging integradas
- ✅ **Windows Event Log** - Eventos do sistema

**Com essas ferramentas:**
- ✅ Todas as sessões PowerShell gravadas
- ✅ Todos os comandos executados registrados
- ✅ Histórico completo e auditável
- ✅ Integração com scripts de deploy

---

**Ferramentas de gravação PowerShell documentadas completamente.**

