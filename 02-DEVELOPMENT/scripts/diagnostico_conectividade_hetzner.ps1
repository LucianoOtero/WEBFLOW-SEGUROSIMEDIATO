# Script de Diagnóstico de Conectividade - Servidores Hetzner
# Versão: 1.0.0
# Data: 24/11/2025
# Objetivo: Diagnosticar problemas de conectividade com servidores Hetzner
#
# USO:
#   .\diagnostico_conectividade_hetzner.ps1
#   .\diagnostico_conectividade_hetzner.ps1 -ServidorProd
#
# PARÂMETROS:
#   -ServidorProd: Executar diagnóstico no servidor de produção (via SSH)

param(
    [switch]$ServidorProd = $false
)

$ErrorActionPreference = "Continue"

# Configurações
$servidorProd = "root@157.180.36.223"
$endpoints = @(
    @{
        Nome = "EspoCRM (FlyingDonkeys) - PROD"
        URL = "https://bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php"
        Dominio = "bpsegurosimediato.com.br"
        IP = $null  # Será resolvido
    },
    @{
        Nome = "Octadesk - PROD"
        URL = "https://bpsegurosimediato.com.br/webhooks/add_webflow_octa_v2.php"
        Dominio = "bpsegurosimediato.com.br"
        IP = $null  # Será resolvido
    },
    @{
        Nome = "Email Notification - PROD"
        URL = "https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php"
        Dominio = "prod.bssegurosimediato.com.br"
        IP = "157.180.36.223"
    }
)

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "DIAGNÓSTICO DE CONECTIVIDADE - HETZNER" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

if ($ServidorProd) {
    Write-Host "⚠️  Executando diagnóstico no servidor de produção via SSH..." -ForegroundColor Yellow
    Write-Host ""
}

# Função para testar DNS
function Test-DNSResolution {
    param([string]$Domain)
    
    Write-Host "🔍 Testando resolução DNS: $Domain" -ForegroundColor Cyan
    try {
        $result = Resolve-DnsName -Name $Domain -ErrorAction Stop
        $ip = $result[0].IPAddress
        Write-Host "   ✅ DNS resolvido: $ip" -ForegroundColor Green
        return $ip
    } catch {
        Write-Host "   ❌ Erro ao resolver DNS: $_" -ForegroundColor Red
        return $null
    }
}

# Função para testar ping
function Test-PingConnectivity {
    param([string]$Target, [int]$Count = 4)
    
    Write-Host "📡 Testando ping: $Target" -ForegroundColor Cyan
    try {
        $result = Test-Connection -ComputerName $Target -Count $Count -ErrorAction Stop
        $avgLatency = ($result | Measure-Object -Property ResponseTime -Average).Average
        $packetLoss = (($result | Where-Object { $_.StatusCode -eq 0 }).Count / $Count) * 100
        Write-Host "   ✅ Ping OK - Latência média: $([math]::Round($avgLatency, 2))ms" -ForegroundColor Green
        Write-Host "   📊 Perda de pacotes: $([math]::Round(100 - $packetLoss, 2))%" -ForegroundColor Gray
        return $true
    } catch {
        Write-Host "   ❌ Ping falhou: $_" -ForegroundColor Red
        return $false
    }
}

# Função para testar conectividade TCP
function Test-TCPConnectivity {
    param([string]$Host, [int]$Port = 443, [int]$Timeout = 5)
    
    Write-Host "🔌 Testando conectividade TCP: ${Host}:${Port}" -ForegroundColor Cyan
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $connect = $tcpClient.BeginConnect($Host, $Port, $null, $null)
        $wait = $connect.AsyncWaitHandle.WaitOne($Timeout * 1000, $false)
        
        if ($wait) {
            $tcpClient.EndConnect($connect)
            $tcpClient.Close()
            Write-Host "   ✅ Conexão TCP OK" -ForegroundColor Green
            return $true
        } else {
            $tcpClient.Close()
            Write-Host "   ❌ Timeout na conexão TCP (${Timeout}s)" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "   ❌ Erro na conexão TCP: $_" -ForegroundColor Red
        return $false
    }
}

# Função para testar SSL/TLS
function Test-SSLCertificate {
    param([string]$URL)
    
    Write-Host "🔒 Testando certificado SSL/TLS: $URL" -ForegroundColor Cyan
    try {
        $request = [System.Net.HttpWebRequest]::Create($URL)
        $request.Timeout = 10000
        $request.Method = "HEAD"
        $response = $request.GetResponse()
        $response.Close()
        
        $cert = [System.Net.ServicePointManager]::ServerCertificateValidationCallback
        Write-Host "   ✅ Certificado SSL/TLS válido" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "   ❌ Erro ao verificar certificado SSL/TLS: $_" -ForegroundColor Red
        return $false
    }
}

# Função para testar HTTP/HTTPS
function Test-HTTPEndpoint {
    param([string]$URL, [int]$Timeout = 30)
    
    Write-Host "🌐 Testando endpoint HTTP: $URL" -ForegroundColor Cyan
    try {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $request = [System.Net.HttpWebRequest]::Create($URL)
        $request.Timeout = $Timeout * 1000
        $request.Method = "HEAD"
        $request.UserAgent = "Diagnostico-Conectividade-Hetzner/1.0"
        
        $response = $request.GetResponse()
        $statusCode = $response.StatusCode
        $response.Close()
        $stopwatch.Stop()
        
        $elapsed = $stopwatch.ElapsedMilliseconds
        
        if ($statusCode -eq 200 -or $statusCode -eq 405) {
            Write-Host "   ✅ Endpoint acessível - Status: $statusCode - Tempo: ${elapsed}ms" -ForegroundColor Green
            return @{ Success = $true; StatusCode = $statusCode; Elapsed = $elapsed }
        } else {
            Write-Host "   ⚠️  Endpoint retornou status: $statusCode - Tempo: ${elapsed}ms" -ForegroundColor Yellow
            return @{ Success = $false; StatusCode = $statusCode; Elapsed = $elapsed }
        }
    } catch {
        $errorMsg = $_.Exception.Message
        if ($errorMsg -like "*timeout*" -or $errorMsg -like "*timed out*") {
            Write-Host "   ❌ Timeout ao acessar endpoint (${Timeout}s)" -ForegroundColor Red
        } elseif ($errorMsg -like "*could not be resolved*" -or $errorMsg -like "*DNS*") {
            Write-Host "   ❌ Erro de DNS: $errorMsg" -ForegroundColor Red
        } elseif ($errorMsg -like "*SSL*" -or $errorMsg -like "*certificate*") {
            Write-Host "   ❌ Erro de SSL/TLS: $errorMsg" -ForegroundColor Red
        } else {
            Write-Host "   ❌ Erro ao acessar endpoint: $errorMsg" -ForegroundColor Red
        }
        return @{ Success = $false; Error = $errorMsg }
    }
}

# Função para executar diagnóstico no servidor de produção
function Invoke-ServerDiagnostic {
    param([string]$Server, [string]$Command)
    
    try {
        $output = ssh $Server $Command 2>&1
        return $output
    } catch {
        return "ERRO: $_"
    }
}

# ==================== EXECUÇÃO DO DIAGNÓSTICO ====================

Write-Host "📋 TESTES DE CONECTIVIDADE" -ForegroundColor Yellow
Write-Host ""

# Resolver DNS dos domínios
Write-Host "1️⃣  RESOLUÇÃO DNS" -ForegroundColor Cyan
Write-Host ""

$domains = $endpoints | Select-Object -ExpandProperty Dominio -Unique
foreach ($domain in $domains) {
    $ip = Test-DNSResolution -Domain $domain
    if ($ip) {
        $endpoint = $endpoints | Where-Object { $_.Dominio -eq $domain } | Select-Object -First 1
        if ($endpoint) {
            $endpoint.IP = $ip
        }
    }
    Write-Host ""
}

# Testar ping (apenas se executando localmente)
if (-not $ServidorProd) {
    Write-Host "2️⃣  TESTE DE PING" -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($endpoint in $endpoints) {
        if ($endpoint.IP) {
            Test-PingConnectivity -Target $endpoint.IP
            Write-Host ""
        }
    }
} else {
    Write-Host "2️⃣  TESTE DE PING (via servidor de produção)" -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($endpoint in $endpoints) {
        if ($endpoint.IP) {
            Write-Host "📡 Testando ping: $($endpoint.IP)" -ForegroundColor Cyan
            $pingResult = Invoke-ServerDiagnostic -Server $servidorProd -Command "ping -c 4 $($endpoint.IP)"
            Write-Host $pingResult
            Write-Host ""
        }
    }
}

# Testar conectividade TCP
Write-Host "3️⃣  TESTE DE CONECTIVIDADE TCP (Porta 443)" -ForegroundColor Cyan
Write-Host ""

foreach ($endpoint in $endpoints) {
    if ($endpoint.IP) {
        Test-TCPConnectivity -Host $endpoint.IP -Port 443 -Timeout 10
        Write-Host ""
    }
}

# Testar certificados SSL/TLS
Write-Host "4️⃣  TESTE DE CERTIFICADOS SSL/TLS" -ForegroundColor Cyan
Write-Host ""

foreach ($endpoint in $endpoints) {
    Test-SSLCertificate -URL $endpoint.URL
    Write-Host ""
}

# Testar endpoints HTTP/HTTPS
Write-Host "5️⃣  TESTE DE ENDPOINTS HTTP/HTTPS" -ForegroundColor Cyan
Write-Host ""

$results = @()
foreach ($endpoint in $endpoints) {
    Write-Host "📋 Endpoint: $($endpoint.Nome)" -ForegroundColor Yellow
    $result = Test-HTTPEndpoint -URL $endpoint.URL -Timeout 30
    $results += @{
        Nome = $endpoint.Nome
        URL = $endpoint.URL
        Result = $result
    }
    Write-Host ""
}

# Resumo
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "RESUMO DO DIAGNÓSTICO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$successCount = ($results | Where-Object { $_.Result.Success -eq $true }).Count
$totalCount = $results.Count

Write-Host "Endpoints testados: $totalCount" -ForegroundColor Gray
Write-Host "Endpoints acessíveis: $successCount" -ForegroundColor $(if ($successCount -eq $totalCount) { "Green" } else { "Yellow" })
Write-Host "Endpoints com problemas: $($totalCount - $successCount)" -ForegroundColor $(if ($successCount -eq $totalCount) { "Green" } else { "Red" })
Write-Host ""

if ($successCount -lt $totalCount) {
    Write-Host "⚠️  PROBLEMAS IDENTIFICADOS:" -ForegroundColor Yellow
    Write-Host ""
    foreach ($result in $results) {
        if (-not $result.Result.Success) {
            Write-Host "   ❌ $($result.Nome)" -ForegroundColor Red
            Write-Host "      URL: $($result.URL)" -ForegroundColor Gray
            if ($result.Result.Error) {
                Write-Host "      Erro: $($result.Result.Error)" -ForegroundColor Gray
            }
            Write-Host ""
        }
    }
} else {
    Write-Host "✅ Todos os endpoints estão acessíveis" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "DIAGNÓSTICO CONCLUÍDO" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

