# Script para Testar Endpoints do Servidor RPA
# Versão: 1.0.0
# Data: 24/11/2025
# Objetivo: Testar conectividade e funcionamento dos endpoints do RPA

$ErrorActionPreference = "Continue"

# Configurações
$servidorRPA = "rpaimediatoseguros.com.br"
$ipServidor = "37.27.92.160"
$endpoints = @(
    @{
        Nome = "Health Check"
        URL = "https://rpaimediatoseguros.com.br/api/rpa/health"
        Metodo = "GET"
    },
    @{
        Nome = "API Start (Teste - sem dados)"
        URL = "https://rpaimediatoseguros.com.br/api/rpa/start"
        Metodo = "POST"
        Body = @{
            teste = "conectividade"
        } | ConvertTo-Json
    },
    @{
        Nome = "Root"
        URL = "https://rpaimediatoseguros.com.br/"
        Metodo = "GET"
    },
    @{
        Nome = "API Root"
        URL = "https://rpaimediatoseguros.com.br/api/"
        Metodo = "GET"
    }
)

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "TESTE DE ENDPOINTS - SERVIDOR RPA" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Servidor: $servidorRPA" -ForegroundColor Yellow
Write-Host "IP: $ipServidor" -ForegroundColor Yellow
Write-Host "Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# Teste 1: Resolução DNS
Write-Host "--- Teste 1: Resolução DNS ---" -ForegroundColor Yellow
try {
    $dnsResult = [System.Net.Dns]::GetHostAddresses($servidorRPA)
    $resolvedIPs = $dnsResult | Select-Object -ExpandProperty IPAddressToString
    Write-Host "✅ DNS resolvido:" -ForegroundColor Green
    foreach ($ip in $resolvedIPs) {
        Write-Host "   - $ip" -ForegroundColor Gray
        if ($ip -eq $ipServidor) {
            Write-Host "   ✅ IP coincide com configuração" -ForegroundColor Green
        }
    }
} catch {
    Write-Host "❌ Erro ao resolver DNS: $_" -ForegroundColor Red
}
Write-Host ""

# Teste 2: Conectividade TCP (Porta 443)
Write-Host "--- Teste 2: Conectividade TCP (Porta 443) ---" -ForegroundColor Yellow
try {
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $connectTask = $tcpClient.ConnectAsync($ipServidor, 443)
    $connectTask.Wait(5000) | Out-Null
    
    if ($tcpClient.Connected) {
        Write-Host "✅ Porta 443: ABERTA" -ForegroundColor Green
        $tcpClient.Close()
    } else {
        Write-Host "❌ Porta 443: FECHADA (Timeout)" -ForegroundColor Red
        $tcpClient.Close()
    }
} catch {
    Write-Host "❌ Erro ao conectar: $_" -ForegroundColor Red
}
Write-Host ""

# Teste 3: Certificado SSL
Write-Host "--- Teste 3: Certificado SSL ---" -ForegroundColor Yellow
try {
    $request = [System.Net.WebRequest]::Create("https://$servidorRPA")
    $request.Timeout = 10000
    $response = $request.GetResponse()
    $cert = $response.ServicePoint.Certificate
    $x509 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($cert)
    
    $validFrom = $x509.NotBefore
    $validTo = $x509.NotAfter
    $issuer = $x509.Issuer
    $subject = $x509.Subject
    
    Write-Host "✅ Certificado SSL válido" -ForegroundColor Green
    Write-Host "   Emissor: $issuer" -ForegroundColor Gray
    Write-Host "   Válido de: $($validFrom.ToString('yyyy-MM-dd'))" -ForegroundColor Gray
    Write-Host "   Válido até: $($validTo.ToString('yyyy-MM-dd'))" -ForegroundColor Gray
    
    if ($validTo -lt (Get-Date)) {
        Write-Host "   ⚠️ Certificado EXPIRADO!" -ForegroundColor Red
    } elseif ($validFrom -gt (Get-Date)) {
        Write-Host "   ⚠️ Certificado ainda não válido!" -ForegroundColor Yellow
    } else {
        Write-Host "   ✅ Certificado dentro do período de validade" -ForegroundColor Green
    }
    
    $response.Close()
} catch {
    Write-Host "❌ Erro ao verificar SSL: $_" -ForegroundColor Red
}
Write-Host ""

# Teste 4: Endpoints HTTP/HTTPS
Write-Host "--- Teste 4: Endpoints HTTP/HTTPS ---" -ForegroundColor Yellow
Write-Host ""

foreach ($endpoint in $endpoints) {
    Write-Host "Testando: $($endpoint.Nome)" -ForegroundColor Cyan
    Write-Host "  URL: $($endpoint.URL)" -ForegroundColor Gray
    Write-Host "  Método: $($endpoint.Metodo)" -ForegroundColor Gray
    
    try {
        $headers = @{
            "User-Agent" = "RPA-Test-Script/1.0"
            "Accept" = "application/json"
        }
        
        if ($endpoint.Metodo -eq "GET") {
            $response = Invoke-WebRequest -Uri $endpoint.URL -Method GET -Headers $headers -TimeoutSec 30 -ErrorAction Stop
        } else {
            $headers["Content-Type"] = "application/json"
            $response = Invoke-WebRequest -Uri $endpoint.URL -Method POST -Headers $headers -Body $endpoint.Body -TimeoutSec 30 -ErrorAction Stop
        }
        
        Write-Host "  ✅ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "  ✅ Tempo de resposta: $($response.Headers.'X-Response-Time' ?? 'N/A')" -ForegroundColor Gray
        
        # Verificar se resposta é JSON
        try {
            $jsonContent = $response.Content | ConvertFrom-Json
            Write-Host "  ✅ Resposta JSON válida" -ForegroundColor Green
            Write-Host "  📄 Conteúdo (primeiros 200 chars):" -ForegroundColor Gray
            $contentPreview = $response.Content.Substring(0, [System.Math]::Min(200, $response.Content.Length))
            Write-Host "     $contentPreview..." -ForegroundColor DarkGray
        } catch {
            Write-Host "  📄 Resposta (primeiros 200 chars):" -ForegroundColor Gray
            $contentPreview = $response.Content.Substring(0, [System.Math]::Min(200, $response.Content.Length))
            Write-Host "     $contentPreview..." -ForegroundColor DarkGray
        }
        
        # Verificar headers importantes
        if ($response.Headers.'CF-Ray') {
            Write-Host "  ✅ Cloudflare ativo (CF-Ray: $($response.Headers.'CF-Ray'))" -ForegroundColor Green
        }
        if ($response.Headers.'Server') {
            Write-Host "  📋 Server: $($response.Headers.'Server')" -ForegroundColor Gray
        }
        
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        $statusDescription = $_.Exception.Response.StatusDescription
        
        Write-Host "  ⚠️ Status: $statusCode $statusDescription" -ForegroundColor Yellow
        
        if ($statusCode -eq 404) {
            Write-Host "  ℹ️ Endpoint não encontrado (pode ser normal se endpoint não existir)" -ForegroundColor Gray
        } elseif ($statusCode -eq 400) {
            Write-Host "  ℹ️ Bad Request (esperado para teste sem dados válidos)" -ForegroundColor Gray
        } elseif ($statusCode -eq 405) {
            Write-Host "  ℹ️ Method Not Allowed (endpoint pode não aceitar este método)" -ForegroundColor Gray
        } elseif ($statusCode -eq 502) {
            Write-Host "  ❌ Bad Gateway (problema no servidor upstream)" -ForegroundColor Red
        } elseif ($statusCode -eq 503) {
            Write-Host "  ❌ Service Unavailable (serviço indisponível)" -ForegroundColor Red
        } else {
            Write-Host "  ❌ Erro: $_" -ForegroundColor Red
        }
    }
    
    Write-Host ""
}

# Teste 5: Verificar Cloudflare
Write-Host "--- Teste 5: Verificação Cloudflare ---" -ForegroundColor Yellow
try {
    $cfTest = Invoke-WebRequest -Uri "https://$servidorRPA/" -Method GET -TimeoutSec 10 -ErrorAction Stop
    
    if ($cfTest.Headers.'CF-Ray') {
        Write-Host "✅ Cloudflare ativo" -ForegroundColor Green
        Write-Host "   CF-Ray: $($cfTest.Headers.'CF-Ray')" -ForegroundColor Gray
        Write-Host "   CF-Country: $($cfTest.Headers.'CF-IPCountry' ?? 'N/A')" -ForegroundColor Gray
    } else {
        Write-Host "⚠️ Cloudflare não detectado (pode estar desativado ou não configurado)" -ForegroundColor Yellow
    }
    
    # Verificar se IP é do Cloudflare
    $cfIPs = @("104.16.0.0/12", "172.64.0.0/13", "173.245.48.0/20")
    Write-Host "   ℹ️ Nota: Se o IP de origem for diferente de $ipServidor, o Cloudflare está fazendo proxy" -ForegroundColor Gray
    
} catch {
    Write-Host "❌ Erro ao verificar Cloudflare: $_" -ForegroundColor Red
}
Write-Host ""

Write-Host "==========================================" -ForegroundColor Green
Write-Host "TESTE CONCLUÍDO" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

