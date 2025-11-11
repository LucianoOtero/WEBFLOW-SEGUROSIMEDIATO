# Script SEGURO para copiar aws_ses_config.php para o servidor
# ⚠️ ATENÇÃO: Este arquivo contém lógica para usar variáveis de ambiente
# ⚠️ NÃO copie se o servidor não tiver variáveis de ambiente AWS configuradas
# Uso: .\copiar_aws_ses_config_servidor.ps1

# Configuracoes
$servidor = "root@65.108.156.14"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$devLocal = $scriptDir
$devRemoto = "/var/www/html/dev/root"
$arquivo = "aws_ses_config.php"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COPIA SEGURA: aws_ses_config.php" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se arquivo existe localmente
$origem = Join-Path $devLocal $arquivo
if (-not (Test-Path $origem)) {
    Write-Host "[ERRO] Arquivo nao encontrado: $origem" -ForegroundColor Red
    exit 1
}

# Verificar conteúdo do arquivo local
Write-Host "Verificando arquivo local..." -ForegroundColor Yellow
$conteudoLocal = Get-Content $origem -Raw

# Verificar se o arquivo local usa variáveis de ambiente
$usaVariaveisAmbiente = $conteudoLocal -match '\$_ENV\[.AWS_ACCESS_KEY_ID.\]' -or $conteudoLocal -match 'getenv\(.AWS_ACCESS_KEY_ID.\)'

if (-not $usaVariaveisAmbiente) {
    Write-Host ""
    Write-Host "[AVISO CRÍTICO] O arquivo local NAO usa variáveis de ambiente!" -ForegroundColor Red
    Write-Host "   O arquivo pode conter credenciais hardcoded ou valores '[REMOVED_FOR_SECURITY]'" -ForegroundColor Red
    Write-Host ""
    $confirmar = Read-Host "Deseja continuar mesmo assim? (SIM/nao)"
    if ($confirmar -ne "SIM") {
        Write-Host "Operacao cancelada pelo usuario." -ForegroundColor Yellow
        exit 0
    }
}

# Verificar se servidor tem variáveis de ambiente configuradas
Write-Host ""
Write-Host "Verificando variaveis de ambiente no servidor..." -ForegroundColor Yellow
Write-Host "  Executando: php -r \"echo getenv('AWS_ACCESS_KEY_ID') ? 'OK' : 'NAO_CONFIGURADO';\""

$verificacao = ssh $servidor "cd $devRemoto && php -r \"echo getenv('AWS_ACCESS_KEY_ID') ? 'OK' : 'NAO_CONFIGURADO';\" 2>&1"

if ($verificacao -eq "NAO_CONFIGURADO" -or $verificacao -match "NAO_CONFIGURADO") {
    Write-Host ""
    Write-Host "[AVISO CRÍTICO] Variáveis de ambiente AWS NAO estão configuradas no servidor!" -ForegroundColor Red
    Write-Host "   Se você copiar o arquivo modificado, o sistema pode parar de funcionar." -ForegroundColor Red
    Write-Host ""
    Write-Host "OPÇÕES:" -ForegroundColor Yellow
    Write-Host "  1. Configurar variáveis de ambiente no servidor PRIMEIRO" -ForegroundColor Yellow
    Write-Host "  2. Manter o arquivo atual no servidor (com credenciais hardcoded)" -ForegroundColor Yellow
    Write-Host "  3. Copiar mesmo assim (NÃO RECOMENDADO)" -ForegroundColor Yellow
    Write-Host ""
    $escolha = Read-Host "Escolha uma opcao (1/2/3) ou 'cancelar' para sair"
    
    if ($escolha -eq "cancelar" -or $escolha -eq "") {
        Write-Host "Operacao cancelada." -ForegroundColor Yellow
        exit 0
    }
    
    if ($escolha -eq "1") {
        Write-Host ""
        Write-Host "Para configurar variáveis de ambiente no servidor:" -ForegroundColor Cyan
        Write-Host "  1. Edite: /etc/php/8.3/fpm/pool.d/www.conf" -ForegroundColor Cyan
        Write-Host "  2. Adicione:" -ForegroundColor Cyan
        Write-Host "     env[AWS_ACCESS_KEY_ID] = [CONFIGURE_AWS_ACCESS_KEY_ID]" -ForegroundColor Cyan
        Write-Host "     env[AWS_SECRET_ACCESS_KEY] = [CONFIGURE_AWS_SECRET_ACCESS_KEY]" -ForegroundColor Cyan
        Write-Host "     env[AWS_REGION] = sa-east-1" -ForegroundColor Cyan
        Write-Host "  3. Reinicie: systemctl restart php8.3-fpm" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Operacao cancelada. Configure as variaveis primeiro." -ForegroundColor Yellow
        exit 0
    }
    
    if ($escolha -eq "2") {
        Write-Host ""
        Write-Host "Operacao cancelada. Mantendo arquivo atual no servidor." -ForegroundColor Yellow
        exit 0
    }
    
    if ($escolha -eq "3") {
        Write-Host ""
        Write-Host "[AVISO] Voce escolheu copiar mesmo sem variaveis configuradas." -ForegroundColor Red
        $confirmarFinal = Read-Host "Confirme digitando 'CONFIRMO' para continuar"
        if ($confirmarFinal -ne "CONFIRMO") {
            Write-Host "Operacao cancelada." -ForegroundColor Yellow
            exit 0
        }
    }
} else {
    Write-Host "  ✅ Variáveis de ambiente AWS configuradas no servidor" -ForegroundColor Green
}

# Fazer backup do arquivo no servidor antes de copiar
Write-Host ""
Write-Host "Criando backup do arquivo no servidor..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupRemoto = "${devRemoto}/${arquivo}.backup_ANTES_COPIA_${timestamp}"

ssh $servidor "cp ${devRemoto}/${arquivo} $backupRemoto 2>/dev/null || echo 'Arquivo nao existe no servidor (primeira copia)'"

# Copiar arquivo
Write-Host ""
Write-Host "Copiando arquivo para o servidor..." -ForegroundColor Cyan
try {
    scp $origem "${servidor}:${devRemoto}/"
    Write-Host "  ✅ Arquivo copiado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Backup criado em: $backupRemoto" -ForegroundColor Green
} catch {
    Write-Host "  [ERRO] Erro ao copiar: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Verificar se arquivo foi copiado corretamente
Write-Host ""
Write-Host "Verificando arquivo no servidor..." -ForegroundColor Yellow
$verificacaoRemoto = ssh $servidor "test -f ${devRemoto}/${arquivo} && echo 'OK' || echo 'ERRO'"

if ($verificacaoRemoto -eq "OK") {
    Write-Host "  ✅ Arquivo verificado no servidor" -ForegroundColor Green
} else {
    Write-Host "  [ERRO] Arquivo nao encontrado no servidor apos copia" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Copia concluida com sucesso!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANTE:" -ForegroundColor Yellow
Write-Host "  - Verifique se as variáveis de ambiente AWS estão configuradas" -ForegroundColor Yellow
Write-Host "  - Teste o envio de email para confirmar funcionamento" -ForegroundColor Yellow
Write-Host "  - Backup disponível em: $backupRemoto" -ForegroundColor Yellow
Write-Host ""

