# Guia: Medir Performance do Cursor com e sem VPN

**Data:** 24/11/2025  
**Objetivo:** Comparar performance do Cursor com e sem Proton VPN  
**Método:** Testes práticos e métricas objetivas

---

## 📋 RESUMO EXECUTIVO

### **Métodos de Medição:**
1. **Latência de Rede** - Ping e traceroute
2. **Tempo de Resposta do Cursor AI** - Medição manual
3. **Velocidade de Download** - Testes de largura de banda
4. **Análise de Logs** - Verificar tempos de resposta

### **Ferramentas:**
- PowerShell (Windows)
- Ferramentas online
- Métricas do próprio Cursor

---

## 🔧 MÉTODO 1: Medir Latência de Rede

### **Passo 1: Testar Latência SEM VPN**

```powershell
# Testar latência para servidores comuns
Test-Connection -TargetName "8.8.8.8" -Count 10 | Measure-Object -Property ResponseTime -Average

# Testar latência para servidor do Cursor/Claude (se conhecido)
Test-Connection -TargetName "api.cursor.sh" -Count 10 | Measure-Object -Property ResponseTime -Average
```

### **Passo 2: Testar Latência COM VPN**

1. **Conectar ao Proton VPN** (servidor São Paulo)
2. **Executar os mesmos comandos:**

```powershell
# Testar latência para servidores comuns
Test-Connection -TargetName "8.8.8.8" -Count 10 | Measure-Object -Property ResponseTime -Average

# Testar latência para servidor do Cursor/Claude
Test-Connection -TargetName "api.cursor.sh" -Count 10 | Measure-Object -Property ResponseTime -Average
```

### **Passo 3: Comparar Resultados**

- **Sem VPN:** Anotar média de latência
- **Com VPN:** Anotar média de latência
- **Diferença:** Calcular aumento percentual

**Exemplo:**
```
Sem VPN: 20ms média
Com VPN: 35ms média
Diferença: +15ms (+75% de aumento)
```

---

## ⏱️ MÉTODO 2: Medir Tempo de Resposta do Cursor AI

### **Teste Prático:**

#### **Sem VPN:**
1. **Desconectar VPN**
2. **Abrir Cursor**
3. **Fazer uma pergunta simples ao Cursor AI** (ex: "Explique o que é JavaScript")
4. **Medir tempo** desde o envio até a primeira resposta aparecer
5. **Repetir 5 vezes** e calcular média

#### **Com VPN:**
1. **Conectar ao Proton VPN** (servidor São Paulo)
2. **Abrir Cursor**
3. **Fazer a MESMA pergunta** ao Cursor AI
4. **Medir tempo** desde o envio até a primeira resposta aparecer
5. **Repetir 5 vezes** e calcular média

### **Como Medir:**
- **Método 1:** Usar cronômetro manual
- **Método 2:** Usar ferramenta de captura de tela com timestamp
- **Método 3:** Verificar logs do Cursor (se disponível)

---

## 📊 MÉTODO 3: Teste de Velocidade de Download

### **Teste de Largura de Banda:**

#### **Sem VPN:**
```powershell
# Testar velocidade de download
Invoke-WebRequest -Uri "https://speedtest.tele2.net/10MB.zip" -OutFile "$env:TEMP\test10mb.zip"
Measure-Command { Invoke-WebRequest -Uri "https://speedtest.tele2.net/10MB.zip" -OutFile "$env:TEMP\test10mb_vpn.zip" }
```

#### **Com VPN:**
1. **Conectar VPN**
2. **Executar mesmo comando**
3. **Comparar tempos**

### **Ferramentas Online:**
- **Speedtest.net:** https://www.speedtest.net/
- **Fast.com:** https://fast.com/
- **Testar antes e depois** de conectar VPN

---

## 🔍 MÉTODO 4: Análise de Logs do Cursor

### **Localizar Logs do Cursor:**

**Windows:**
```
%APPDATA%\Cursor\logs\
ou
%LOCALAPPDATA%\Cursor\logs\
```

### **Verificar:**
1. **Abrir logs mais recentes**
2. **Procurar por timestamps** de requisições
3. **Comparar tempos** de resposta com e sem VPN

---

## 📝 MÉTODO 5: Script de Teste Automatizado

### **Script PowerShell Completo:**

```powershell
# Script para medir performance com e sem VPN
# Salvar como: test_cursor_vpn_performance.ps1

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "TESTE DE PERFORMANCE CURSOR COM/SEM VPN" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Função para testar latência
function Test-Latency {
    param([string]$Target, [int]$Count = 10)
    
    $results = Test-Connection -TargetName $Target -Count $Count -ErrorAction SilentlyContinue
    if ($results) {
        $avg = ($results | Measure-Object -Property ResponseTime -Average).Average
        $min = ($results | Measure-Object -Property ResponseTime -Minimum).Minimum
        $max = ($results | Measure-Object -Property ResponseTime -Maximum).Maximum
        return @{
            Average = [math]::Round($avg, 2)
            Minimum = $min
            Maximum = $max
        }
    }
    return $null
}

# Função para testar velocidade de download
function Test-DownloadSpeed {
    param([string]$Url, [string]$OutputFile)
    
    $startTime = Get-Date
    try {
        Invoke-WebRequest -Uri $Url -OutFile $OutputFile -ErrorAction Stop
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        $fileSize = (Get-Item $OutputFile).Length / 1MB
        $speed = $fileSize / $duration
        Remove-Item $OutputFile -ErrorAction SilentlyContinue
        return @{
            Duration = [math]::Round($duration, 2)
            Speed = [math]::Round($speed, 2)
        }
    } catch {
        return $null
    }
}

# Testes
$targets = @("8.8.8.8", "1.1.1.1", "api.cursor.sh")
$downloadUrl = "https://speedtest.tele2.net/1MB.zip"

Write-Host "--- TESTE SEM VPN ---" -ForegroundColor Yellow
Write-Host "Desconecte o VPN e pressione Enter para continuar..."
Read-Host

Write-Host "Testando latência (sem VPN)..." -ForegroundColor Cyan
$resultsWithoutVPN = @{}
foreach ($target in $targets) {
    Write-Host "  Testando $target..." -ForegroundColor Gray
    $result = Test-Latency -Target $target
    if ($result) {
        $resultsWithoutVPN[$target] = $result
        Write-Host "    Média: $($result.Average)ms (Min: $($result.Minimum)ms, Max: $($result.Maximum)ms)" -ForegroundColor Green
    } else {
        Write-Host "    Falha ao testar $target" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Testando velocidade de download (sem VPN)..." -ForegroundColor Cyan
$downloadWithoutVPN = Test-DownloadSpeed -Url $downloadUrl -OutputFile "$env:TEMP\test_vpn.zip"
if ($downloadWithoutVPN) {
    Write-Host "  Velocidade: $($downloadWithoutVPN.Speed) MB/s (Tempo: $($downloadWithoutVPN.Duration)s)" -ForegroundColor Green
}

Write-Host ""
Write-Host "--- TESTE COM VPN ---" -ForegroundColor Yellow
Write-Host "Conecte ao Proton VPN (servidor São Paulo) e pressione Enter para continuar..."
Read-Host

Write-Host "Testando latência (com VPN)..." -ForegroundColor Cyan
$resultsWithVPN = @{}
foreach ($target in $targets) {
    Write-Host "  Testando $target..." -ForegroundColor Gray
    $result = Test-Latency -Target $target
    if ($result) {
        $resultsWithVPN[$target] = $result
        Write-Host "    Média: $($result.Average)ms (Min: $($result.Minimum)ms, Max: $($result.Maximum)ms)" -ForegroundColor Green
    } else {
        Write-Host "    Falha ao testar $target" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Testando velocidade de download (com VPN)..." -ForegroundColor Cyan
$downloadWithVPN = Test-DownloadSpeed -Url $downloadUrl -OutputFile "$env:TEMP\test_vpn.zip"
if ($downloadWithVPN) {
    Write-Host "  Velocidade: $($downloadWithVPN.Speed) MB/s (Tempo: $($downloadWithVPN.Duration)s)" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "RESULTADOS COMPARATIVOS" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($target in $targets) {
    if ($resultsWithoutVPN[$target] -and $resultsWithVPN[$target]) {
        $diff = $resultsWithVPN[$target].Average - $resultsWithoutVPN[$target].Average
        $percent = ($diff / $resultsWithoutVPN[$target].Average) * 100
        Write-Host "$target:" -ForegroundColor Yellow
        Write-Host "  Sem VPN: $($resultsWithoutVPN[$target].Average)ms" -ForegroundColor Gray
        Write-Host "  Com VPN: $($resultsWithVPN[$target].Average)ms" -ForegroundColor Gray
        Write-Host "  Diferença: $([math]::Round($diff, 2))ms ($([math]::Round($percent, 1))%)" -ForegroundColor $(if ($diff -gt 0) { "Red" } else { "Green" })
        Write-Host ""
    }
}

if ($downloadWithoutVPN -and $downloadWithVPN) {
    $speedDiff = $downloadWithVPN.Speed - $downloadWithoutVPN.Speed
    $speedPercent = ($speedDiff / $downloadWithoutVPN.Speed) * 100
    Write-Host "Velocidade de Download:" -ForegroundColor Yellow
    Write-Host "  Sem VPN: $($downloadWithoutVPN.Speed) MB/s" -ForegroundColor Gray
    Write-Host "  Com VPN: $($downloadWithVPN.Speed) MB/s" -ForegroundColor Gray
    Write-Host "  Diferença: $([math]::Round($speedDiff, 2)) MB/s ($([math]::Round($speedPercent, 1))%)" -ForegroundColor $(if ($speedDiff -lt 0) { "Red" } else { "Green" })
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "TESTE CONCLUÍDO" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
```

---

## 📋 CHECKLIST DE TESTE

### **Preparação:**
- [ ] Fechar todas as aplicações desnecessárias
- [ ] Garantir que internet está estável
- [ ] Ter script de teste pronto (ou usar métodos manuais)

### **Teste Sem VPN:**
- [ ] Desconectar VPN
- [ ] Executar testes de latência
- [ ] Executar testes de velocidade
- [ ] Testar Cursor AI (5 perguntas, medir tempo)
- [ ] Anotar todos os resultados

### **Teste Com VPN:**
- [ ] Conectar ao Proton VPN (servidor São Paulo)
- [ ] Aguardar conexão estabilizar (30 segundos)
- [ ] Executar mesmos testes
- [ ] Testar Cursor AI (mesmas 5 perguntas)
- [ ] Anotar todos os resultados

### **Análise:**
- [ ] Comparar resultados
- [ ] Calcular diferenças percentuais
- [ ] Identificar se impacto é significativo

---

## 🎯 INTERPRETAÇÃO DOS RESULTADOS

### **Latência:**
- **< 10ms de diferença:** Impacto mínimo (aceitável)
- **10-30ms de diferença:** Impacto moderado (perceptível)
- **> 30ms de diferença:** Impacto alto (pode afetar experiência)

### **Velocidade de Download:**
- **< 10% de redução:** Impacto mínimo
- **10-30% de redução:** Impacto moderado
- **> 30% de redução:** Impacto alto

### **Tempo de Resposta do Cursor:**
- **< 0.5s de diferença:** Impacto mínimo
- **0.5-2s de diferença:** Impacto moderado
- **> 2s de diferença:** Impacto alto

---

## ✅ CONCLUSÃO

### **Métodos Recomendados:**
1. ✅ **Script automatizado** - Mais preciso e completo
2. ✅ **Teste manual do Cursor AI** - Mais realista
3. ✅ **Teste de latência** - Rápido e objetivo

### **Tempo Estimado:**
- ⏱️ **Teste completo:** 15-20 minutos
- ⏱️ **Teste rápido:** 5-10 minutos (apenas latência)

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 21:00  
**Status:** ✅ **GUIA COMPLETO** - Pronto para uso


