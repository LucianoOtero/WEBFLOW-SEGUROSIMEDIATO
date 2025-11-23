# 🎯 PROJETO: Atualização de Variáveis de Ambiente em Produção

**Data de Criação:** 22/11/2025  
**Versão:** 3.1.0  
**Status:** ⏳ **PENDENTE AUTORIZAÇÃO** - Aguardando aprovação para execução  
**Última Atualização:** 22/11/2025 - Versão 3.1.0 (Objetivos atualizados para garantir preservação de arquivos .js e .php)

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Atualizar o ambiente de produção com todas as variáveis de ambiente identificadas na análise comparativa DEV vs PROD, garantindo que:

1. **O ambiente PROD tenha todas as variáveis necessárias** para funcionamento correto das funcionalidades
2. **A funcionalidade dos arquivos .js e .php atualmente publicados no ambiente de produção seja preservada** e não seja prejudicada pela atualização das variáveis de ambiente
3. **Nenhuma funcionalidade existente seja quebrada** ou tenha seu comportamento alterado negativamente

### Escopo

- **Ambiente:** PRODUÇÃO (PROD)
- **Servidor:** `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)
- **Arquivo de Configuração:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Total de Variáveis:** 21 variáveis (1 modificar + 20 adicionar)
- **Prioridades:**
  - 🔴 **CRÍTICO:** 4 variáveis (1 modificar + 3 adicionar)
  - 🟡 **ALTO:** 13 variáveis (adicionar)
  - 🟢 **MÉDIO:** 4 variáveis (adicionar)

### Impacto Esperado

- ✅ **Funcionalidade:** Todas as APIs e serviços funcionarão corretamente em PROD
- ✅ **Preservação:** Arquivos .js e .php atualmente em produção continuarão funcionando normalmente
- ✅ **Consistência:** Ambiente PROD alinhado com DEV em termos de variáveis
- ✅ **Segurança:** Credenciais e configurações centralizadas via variáveis de ambiente
- ✅ **Manutenibilidade:** Facilita futuras atualizações e manutenção
- ✅ **Estabilidade:** Nenhuma funcionalidade existente será quebrada ou alterada negativamente

---

## 👥 STAKEHOLDERS

### Identificação de Stakeholders

| Stakeholder | Papel | Responsabilidade | Aprovação Necessária |
|-------------|-------|-----------------|---------------------|
| **Usuário/Autorizador** | Aprovador Final | Autorizar execução em produção | ✅ Sim (obrigatória) |
| **Executor do Script** | Executor Técnico | Executar script PowerShell e validar resultados | ✅ Sim (execução) |
| **Auditor** | Validador | Validar conformidade e qualidade | ⚠️ Opcional |

### Processo de Aprovação

1. ✅ Projeto elaborado e documentado
2. ✅ Auditoria realizada e aprovada
3. ⏳ **Aguardando autorização explícita do usuário**
4. ⏳ Execução após autorização
5. ⏳ Validação pós-execução

---

## 🎯 ESPECIFICAÇÕES DO USUÁRIO

### Requisitos Específicos

1. **🚨 CRÍTICO:** NÃO modificar servidor de produção sem autorização explícita
2. **Criar script PowerShell** localmente antes de executar
3. **Criar backup** do arquivo PHP-FPM config antes de qualquer modificação
4. **Verificar duplicatas** antes de adicionar variáveis
5. **Validar sintaxe** do arquivo PHP-FPM após modificações
6. **Recarregar PHP-FPM** após atualização de configuração
7. **Verificar funcionamento** após atualização
8. **🚨 CRÍTICO:** Garantir que arquivos .js e .php em produção continuam funcionando normalmente
9. **🚨 CRÍTICO:** Verificar que nenhuma funcionalidade existente foi quebrada ou alterada negativamente
10. **Documentar** todas as alterações realizadas
11. **Ter plano de rollback** pronto antes de executar

### Critérios de Aceitação

- ✅ Script PowerShell criado localmente
- ✅ Backup do arquivo PHP-FPM config criado no servidor PROD
- ✅ Todas as 21 variáveis adicionadas/modificadas com sucesso
- ✅ Sintaxe do arquivo PHP-FPM validada
- ✅ PHP-FPM recarregado sem erros
- ✅ Variáveis de ambiente carregadas corretamente
- ✅ Nenhum erro crítico nos logs após atualização
- ✅ **Arquivos .js e .php em produção continuam funcionando normalmente**
- ✅ **Nenhuma funcionalidade existente foi quebrada ou alterada negativamente**
- ✅ **Console do navegador sem erros JavaScript relacionados às variáveis**
- ✅ Documentação atualizada com alterações realizadas

---

## 📊 RESUMO DAS FASES

| Fase | Descrição | Tempo Base | Buffer | Tempo Total | Risco | Status |
|------|-----------|------------|--------|-------------|-------|--------|
| 1 | Preparação e Análise | 0.5h | 0.1h | 0.6h | 🟢 | ⏳ Pendente |
| 2 | Criação do Script PowerShell | 1h | 0.2h | 1.2h | 🟡 | ⏳ Pendente |
| 3 | Validação do Script Localmente | 0.5h | 0.1h | 0.6h | 🟡 | ⏳ Pendente |
| 4 | Backup do Arquivo PHP-FPM Config | 0.3h | 0.1h | 0.4h | 🟢 | ⏳ Pendente |
| 5 | Execução do Script em PROD | 1h | 0.3h | 1.3h | 🔴 | ⏳ Pendente |
| 6 | Validação de Sintaxe PHP-FPM | 0.3h | 0.1h | 0.4h | 🔴 | ⏳ Pendente |
| 7 | Recarga do PHP-FPM | 0.2h | 0.1h | 0.3h | 🔴 | ⏳ Pendente |
| 8 | Verificação de Variáveis | 0.5h | 0.1h | 0.6h | 🟡 | ⏳ Pendente |
| 9 | Testes Funcionais | 1h | 0.3h | 1.3h | 🔴 | ⏳ Pendente |
| 10 | Documentação Final | 0.5h | 0.1h | 0.6h | 🟢 | ⏳ Pendente |
| **TOTAL** | | **6.4h** | **1.5h** | **7.9h** | | |

---

## 📋 FASES DETALHADAS

### FASE 1: Preparação e Análise

**Objetivo:** Revisar análise de variáveis e preparar ambiente para execução

**Tarefas:**
- [ ] Revisar documento `ANALISE_VARIAVEIS_AMBIENTE_DEV_PROD_20251122.md`
- [ ] Confirmar lista completa de 21 variáveis a processar
- [ ] Verificar acesso SSH ao servidor PROD usando função wrapper
- [ ] Verificar que arquivo `/etc/php/8.3/fpm/pool.d/www.conf` existe usando script temporário
- [ ] Listar variáveis existentes em PROD antes da modificação usando script temporário
- [ ] Confirmar valores a serem adicionados/modificados

**Método Seguro - Script Temporário no Servidor:**

O script PowerShell criará scripts temporários no servidor para evitar problemas de escape de caracteres:

```powershell
# Função wrapper para executar comandos SSH simples
function Invoke-SafeSSH {
    param(
        [string]$Server,
        [string]$Command
    )
    $result = ssh root@$Server $Command 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "SSH command failed: $Command"
    }
    return $result
}

# Verificar acesso SSH
Invoke-SafeSSH -Server "157.180.36.223" -Command "echo 'Acesso SSH OK'"

# Criar script temporário para verificar arquivo
$checkFileScript = @"
#!/bin/bash
if [ -f /etc/php/8.3/fpm/pool.d/www.conf ]; then
    echo "EXISTS"
    ls -la /etc/php/8.3/fpm/pool.d/www.conf
else
    echo "NOT_FOUND"
    exit 1
fi
"@

# Criar script no servidor usando heredoc
ssh root@157.180.36.223 "cat > /tmp/check_phpfpm_config.sh << 'EOFSCRIPT'
$checkFileScript
EOFSCRIPT
chmod +x /tmp/check_phpfpm_config.sh
/tmp/check_phpfpm_config.sh
rm /tmp/check_phpfpm_config.sh"

# Criar script temporário para listar variáveis
$listVarsScript = @"
#!/bin/bash
php-fpm8.3 -tt 2>&1 | grep 'env\[' | sort > /tmp/phpfpm_vars.txt
cat /tmp/phpfpm_vars.txt
rm /tmp/phpfpm_vars.txt
"@

# Executar script no servidor
ssh root@157.180.36.223 "cat > /tmp/list_vars.sh << 'EOFSCRIPT'
$listVarsScript
EOFSCRIPT
chmod +x /tmp/list_vars.sh
/tmp/list_vars.sh
rm /tmp/list_vars.sh"
```

**Validação:**
- ✅ Acesso SSH confirmado
- ✅ Arquivo PHP-FPM config existe e é acessível
- ✅ Lista de variáveis existentes documentada
- ✅ Scripts temporários removidos após execução

**Risco:** 🟢 **BAIXO**

---

### FASE 2: Criação do Script PowerShell

**Objetivo:** Criar script PowerShell local para automatizar atualização de variáveis usando métodos seguros SSH

**Tarefas:**
- [ ] Criar script `atualizar_variaveis_ambiente_prod.ps1` em `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`
- [ ] Implementar funções wrapper SSH com tratamento de erros
- [ ] Implementar função para criar scripts temporários no servidor
- [ ] Implementar função de backup do arquivo PHP-FPM config usando script temporário
- [ ] Implementar função de verificação de duplicatas usando script temporário
- [ ] Implementar função de adição de variáveis (21 variáveis) usando script temporário
- [ ] Implementar função de modificação de variável (`AWS_SES_FROM_EMAIL`) usando script temporário
- [ ] Implementar função de validação de sintaxe usando script temporário
- [ ] Implementar função de recarga do PHP-FPM usando comando simples
- [ ] Implementar logs detalhados de todas as operações
- [ ] Adicionar tratamento de erros robusto
- [ ] Implementar modo dry-run para testes

**Estrutura do Script:**
```powershell
# Variáveis a adicionar (20 variáveis)
$variaveis_adicionar = @{
    # CRÍTICO (3 variáveis)
    'APILAYER_KEY' = 'dce92fa84152098a3b5b7b8db24debbc'
    'SAFETY_TICKET' = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'
    'SAFETY_API_KEY' = '20a7a1c297e39180bd80428ac13c363e882a531f'
    
    # ALTO (13 variáveis)
    'AWS_SES_FROM_NAME' = 'BP Seguros Imediato'
    'VIACEP_BASE_URL' = 'https://viacep.com.br'
    'APILAYER_BASE_URL' = 'https://apilayer.net'
    'SAFETYMAILS_OPTIN_BASE' = 'https://optin.safetymails.com'
    'RPA_API_BASE_URL' = 'https://rpaimediatoseguros.com.br'
    'SAFETYMAILS_BASE_DOMAIN' = 'safetymails.com'
    'PH3A_API_KEY' = '691dd2aa-9af4-84f2-06f9-350e1d709602'
    'PH3A_DATA_URL' = 'https://api.ph3a.com.br/DataBusca/api/Data/GetData'
    'PH3A_LOGIN_URL' = 'https://api.ph3a.com.br/DataBusca/api/Account/Login'
    'PH3A_PASSWORD' = 'ImdSeg2025$$'
    'PH3A_USERNAME' = 'alex.kaminski@imediatoseguros.com.br'
    'PLACAFIPE_API_TOKEN' = '1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214'
    'PLACAFIPE_API_URL' = 'https://api.placafipe.com.br/getplaca'
    'SUCCESS_PAGE_URL' = 'https://www.segurosimediato.com.br/sucesso'
    
    # MÉDIO (4 variáveis)
    'RPA_ENABLED' = 'false'
    'USE_PHONE_API' = 'true'
    'VALIDAR_PH3A' = 'false'
    'OCTADESK_FROM' = '+551132301422'
}

# Variável a modificar (1 variável)
$variavel_modificar = @{
    'AWS_SES_FROM_EMAIL' = 'noreply@bpsegurosimediato.com.br'
}
```

**Funcionalidades do Script:**

1. **Funções Wrapper SSH:**
   - `Invoke-SafeSSH`: Executa comandos SSH simples com tratamento de erros
   - `Invoke-SafeSSHScript`: Cria e executa script temporário no servidor
   - `Get-SSHOutput`: Captura saída de comandos SSH com validação

2. **Backup:** Criar backup com timestamp usando script temporário no servidor

3. **Verificação de Duplicatas:** Criar script temporário para verificar se variável já existe antes de adicionar

4. **Adição Segura:** Criar script temporário para adicionar variáveis apenas se não existirem

5. **Modificação Segura:** Criar script temporário para modificar variável apenas se existir e valor for diferente

6. **Validação:** Criar script temporário para validar sintaxe do arquivo após modificações

7. **Recarga:** Recarregar PHP-FPM usando comando simples apenas se validação passar

8. **Logs:** Registrar todas as operações em arquivo de log local

9. **Limpeza:** Remover todos os scripts temporários após execução

**Estrutura de Funções Wrapper:**

```powershell
# Função wrapper para comandos SSH simples
function Invoke-SafeSSH {
    param(
        [string]$Server,
        [string]$Command,
        [switch]$IgnoreErrors
    )
    Write-Log "Executando SSH: $Command" -Level "DEBUG"
    $result = ssh root@$Server $Command 2>&1
    if (-not $IgnoreErrors -and $LASTEXITCODE -ne 0) {
        Write-Log "Erro ao executar comando SSH: $Command" -Level "ERROR"
        throw "SSH command failed with exit code $LASTEXITCODE: $Command"
    }
    return $result
}

# Função para criar e executar script temporário no servidor
function Invoke-SafeSSHScript {
    param(
        [string]$Server,
        [string]$ScriptContent,
        [string]$ScriptName = "temp_script.sh"
    )
    $tempScript = "/tmp/$ScriptName"
    Write-Log "Criando script temporário: $tempScript" -Level "DEBUG"
    
    # Criar script usando heredoc para evitar problemas de escape
    $heredoc = @"
cat > $tempScript << 'EOFSCRIPT'
$ScriptContent
EOFSCRIPT
chmod +x $tempScript
$tempScript
EXIT_CODE=`$?
rm -f $tempScript
exit `$EXIT_CODE
"@
    
    $result = ssh root@$Server $heredoc 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Erro ao executar script temporário" -Level "ERROR"
        throw "Script execution failed with exit code $LASTEXITCODE"
    }
    return $result
}
```

**Validação:**
- ✅ Script criado localmente
- ✅ Todas as funções implementadas
- ✅ Tratamento de erros implementado
- ✅ Logs detalhados implementados

**Risco:** 🟡 **MÉDIO**

---

### FASE 3: Validação do Script Localmente

**Objetivo:** Validar script antes de executar em PROD

**Tarefas:**
- [ ] Executar script em modo "dry-run" (simulação)
- [ ] Verificar que script identifica variáveis corretamente
- [ ] Verificar que script detecta duplicatas corretamente
- [ ] Verificar tratamento de erros
- [ ] Validar formato de saída dos logs
- [ ] Revisar código do script para garantir segurança

**Comandos:**
```powershell
# Executar em modo dry-run (não modificar servidor)
.\atualizar_variaveis_ambiente_prod.ps1 -DryRun -Verbose
```

**Validação:**
- ✅ Script executa sem erros em modo dry-run
- ✅ Todas as verificações funcionam corretamente
- ✅ Logs gerados corretamente
- ✅ Código revisado e aprovado

**Risco:** 🟡 **MÉDIO**

---

### FASE 4: Backup do Arquivo PHP-FPM Config

**Objetivo:** Criar backup seguro do arquivo antes de modificações usando script temporário

**Tarefas:**
- [ ] Conectar ao servidor PROD via SSH usando função wrapper
- [ ] Criar script temporário para backup com timestamp
- [ ] Executar script temporário para criar backup: `www.conf.backup_YYYYMMDD_HHMMSS`
- [ ] Verificar que backup foi criado corretamente usando script temporário
- [ ] Calcular hash SHA256 do arquivo original usando script temporário
- [ ] Documentar hash do backup
- [ ] Remover scripts temporários

**Método Seguro - Script Temporário:**

```powershell
# Script temporário para criar backup e calcular hash
$backupScript = @"
#!/bin/bash
set -e

CONFIG_FILE="/etc/php/8.3/fpm/pool.d/www.conf"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${CONFIG_FILE}.backup_${TIMESTAMP}"

# Criar backup
cp "$CONFIG_FILE" "$BACKUP_FILE"

# Verificar backup
if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERRO: Backup não foi criado"
    exit 1
fi

# Calcular hash do arquivo original
HASH=$(sha256sum "$CONFIG_FILE" | cut -d' ' -f1)

# Retornar informações
echo "BACKUP_FILE=$BACKUP_FILE"
echo "BACKUP_HASH=$(sha256sum "$BACKUP_FILE" | cut -d' ' -f1)"
echo "ORIGINAL_HASH=$HASH"
echo "TIMESTAMP=$TIMESTAMP"
"@

# Executar script usando função wrapper
$backupResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $backupScript -ScriptName "backup_phpfpm.sh"

# Processar resultado
$backupInfo = @{}
$backupResult | ForEach-Object {
    if ($_ -match '^(\w+)=(.*)$') {
        $backupInfo[$matches[1]] = $matches[2]
    }
}

Write-Log "Backup criado: $($backupInfo['BACKUP_FILE'])" -Level "INFO"
Write-Log "Hash original: $($backupInfo['ORIGINAL_HASH'])" -Level "INFO"
Write-Log "Hash backup: $($backupInfo['BACKUP_HASH'])" -Level "INFO"
```

**Validação:**
- ✅ Backup criado com sucesso
- ✅ Hash SHA256 calculado e documentado
- ✅ Backup acessível e íntegro
- ✅ Script temporário removido

**Risco:** 🟢 **BAIXO**

---

### FASE 5: Execução do Script em PROD

**Objetivo:** Executar script para adicionar/modificar variáveis em PROD

**Tarefas:**
- [ ] Executar script PowerShell em modo produção
- [ ] Monitorar execução em tempo real
- [ ] Verificar que cada variável foi processada corretamente
- [ ] Confirmar que variáveis foram adicionadas/modificadas
- [ ] Verificar logs de execução

**Comandos:**
```powershell
# Executar script em PROD
.\atualizar_variaveis_ambiente_prod.ps1 -Server prod.bssegurosimediato.com.br -Verbose
```

**Validação:**
- ✅ Script executado sem erros
- ✅ Todas as 21 variáveis processadas
- ✅ Logs confirmam sucesso de todas as operações
- ✅ Arquivo PHP-FPM config modificado corretamente

**Risco:** 🔴 **ALTO** - Modificação em servidor de produção

---

### FASE 6: Validação de Sintaxe PHP-FPM

**Objetivo:** Validar que arquivo PHP-FPM config está sintaticamente correto usando script temporário

**Tarefas:**
- [ ] Criar script temporário para validação de sintaxe
- [ ] Executar validação de sintaxe do PHP-FPM via script temporário
- [ ] Verificar que não há erros de sintaxe
- [ ] Criar script temporário para verificar variáveis adicionadas
- [ ] Confirmar que todas as variáveis estão no formato correto
- [ ] Verificar que não há duplicatas
- [ ] Remover scripts temporários

**Método Seguro - Script Temporário:**

```powershell
# Script temporário para validar sintaxe
$validateSyntaxScript = @"
#!/bin/bash
set -e

# Validar sintaxe
VALIDATION_OUTPUT=$(php-fpm8.3 -tt 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "ERRO_SINTAXE=1"
    echo "VALIDATION_OUTPUT<<EOF"
    echo "$VALIDATION_OUTPUT"
    echo "EOF"
    exit 1
else
    echo "ERRO_SINTAXE=0"
    echo "VALIDATION_OUTPUT<<EOF"
    echo "$VALIDATION_OUTPUT"
    echo "EOF"
fi
"@

# Executar validação
$validationResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $validateSyntaxScript -ScriptName "validate_syntax.sh"

# Processar resultado
if ($validationResult -match 'ERRO_SINTAXE=1') {
    Write-Log "Erro de sintaxe detectado!" -Level "ERROR"
    throw "Sintaxe do arquivo PHP-FPM config está incorreta"
}

# Script temporário para verificar variáveis
$checkVarsScript = @"
#!/bin/bash
set -e

VARS_TO_CHECK=(
    "APILAYER_KEY"
    "SAFETY_TICKET"
    "SAFETY_API_KEY"
    "AWS_SES_FROM_NAME"
    "VIACEP_BASE_URL"
    "APILAYER_BASE_URL"
    "SAFETYMAILS_OPTIN_BASE"
    "RPA_API_BASE_URL"
    "SAFETYMAILS_BASE_DOMAIN"
    "PH3A_API_KEY"
    "PH3A_DATA_URL"
    "PH3A_LOGIN_URL"
    "PH3A_PASSWORD"
    "PH3A_USERNAME"
    "PLACAFIPE_API_TOKEN"
    "PLACAFIPE_API_URL"
    "SUCCESS_PAGE_URL"
    "RPA_ENABLED"
    "USE_PHONE_API"
    "VALIDAR_PH3A"
    "OCTADESK_FROM"
    "AWS_SES_FROM_EMAIL"
)

php-fpm8.3 -tt 2>&1 | grep 'env\[' > /tmp/vars_found.txt

MISSING_VARS=()
for VAR in "\${VARS_TO_CHECK[@]}"; do
    if ! grep -q "env\[$VAR\]" /tmp/vars_found.txt; then
        MISSING_VARS+=("\$VAR")
    fi
done

rm -f /tmp/vars_found.txt

if [ \${#MISSING_VARS[@]} -gt 0 ]; then
    echo "VARIAVEIS_FALTANDO=\${MISSING_VARS[*]}"
    exit 1
else
    echo "TODAS_VARIAVEIS_PRESENTES=1"
fi
"@

# Executar verificação de variáveis
$varsCheckResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $checkVarsScript -ScriptName "check_vars.sh"

if ($varsCheckResult -match 'VARIAVEIS_FALTANDO=') {
    Write-Log "Variáveis faltando: $($matches[1])" -Level "ERROR"
    throw "Algumas variáveis não foram adicionadas corretamente"
}
```

**Validação:**
- ✅ Sintaxe validada sem erros
- ✅ Todas as variáveis presentes e corretas
- ✅ Nenhuma duplicata encontrada
- ✅ Scripts temporários removidos

**Risco:** 🔴 **ALTO** - Se sintaxe estiver incorreta, PHP-FPM não iniciará

---

### FASE 7: Recarga do PHP-FPM

**Objetivo:** Recarregar PHP-FPM para aplicar novas variáveis de ambiente usando script temporário

**Tarefas:**
- [ ] Criar script temporário para recarregar e verificar PHP-FPM
- [ ] Recarregar PHP-FPM sem interrupção de serviço via script temporário
- [ ] Verificar que PHP-FPM recarregou sem erros
- [ ] Confirmar que serviço está rodando corretamente
- [ ] Verificar logs do PHP-FPM para erros
- [ ] Remover script temporário

**Método Seguro - Script Temporário:**

```powershell
# Script temporário para recarregar e verificar PHP-FPM
$reloadScript = @"
#!/bin/bash
set -e

# Recarregar PHP-FPM
systemctl reload php8.3-fpm
RELOAD_EXIT=$?

if [ $RELOAD_EXIT -ne 0 ]; then
    echo "ERRO_RECARGA=1"
    exit 1
fi

# Verificar status
STATUS=$(systemctl is-active php8.3-fpm)
if [ "$STATUS" != "active" ]; then
    echo "ERRO_STATUS=1"
    echo "STATUS_ATUAL=$STATUS"
    exit 1
fi

# Verificar logs recentes para erros críticos
LOG_ERRORS=$(tail -50 /var/log/php8.3-fpm.log 2>/dev/null | grep -i "error\|fatal\|critical" | wc -l)

echo "RECARGA_OK=1"
echo "STATUS=$STATUS"
echo "LOG_ERRORS=$LOG_ERRORS"
"@

# Executar script
$reloadResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $reloadScript -ScriptName "reload_phpfpm.sh"

# Processar resultado
if ($reloadResult -match 'ERRO_RECARGA=1') {
    Write-Log "Erro ao recarregar PHP-FPM!" -Level "ERROR"
    throw "Falha ao recarregar PHP-FPM"
}

if ($reloadResult -match 'ERRO_STATUS=1') {
    Write-Log "PHP-FPM não está ativo após recarga!" -Level "ERROR"
    throw "PHP-FPM não está rodando corretamente"
}

Write-Log "PHP-FPM recarregado com sucesso" -Level "INFO"
```

**Validação:**
- ✅ PHP-FPM recarregado com sucesso
- ✅ Serviço rodando sem erros
- ✅ Nenhum erro crítico nos logs
- ✅ Script temporário removido

**Risco:** 🔴 **ALTO** - Se PHP-FPM não recarregar, pode afetar produção

---

### FASE 8: Verificação de Variáveis

**Objetivo:** Confirmar que todas as variáveis estão disponíveis no ambiente PHP usando script temporário

**Tarefas:**
- [ ] Criar script PHP temporário para verificar variáveis usando script wrapper
- [ ] Executar script PHP no servidor PROD via script temporário
- [ ] Capturar saída e processar resultados
- [ ] Verificar que todas as 21 variáveis estão disponíveis
- [ ] Confirmar valores das variáveis
- [ ] Remover scripts temporários

**Método Seguro - Script Temporário:**

```powershell
# Script temporário para criar e executar script PHP de verificação
$verifyVarsScript = @"
#!/bin/bash
set -e

# Criar script PHP temporário
cat > /tmp/verificar_variaveis.php << 'EOFPHP'
<?php
\$variaveis_esperadas = [
    'APILAYER_KEY',
    'SAFETY_TICKET',
    'SAFETY_API_KEY',
    'AWS_SES_FROM_NAME',
    'VIACEP_BASE_URL',
    'APILAYER_BASE_URL',
    'SAFETYMAILS_OPTIN_BASE',
    'RPA_API_BASE_URL',
    'SAFETYMAILS_BASE_DOMAIN',
    'PH3A_API_KEY',
    'PH3A_DATA_URL',
    'PH3A_LOGIN_URL',
    'PH3A_PASSWORD',
    'PH3A_USERNAME',
    'PLACAFIPE_API_TOKEN',
    'PLACAFIPE_API_URL',
    'SUCCESS_PAGE_URL',
    'RPA_ENABLED',
    'USE_PHONE_API',
    'VALIDAR_PH3A',
    'OCTADESK_FROM',
    'AWS_SES_FROM_EMAIL'
];

\$missing = [];
\$found = [];

foreach (\$variaveis_esperadas as \$var) {
    \$valor = \$_ENV[\$var] ?? null;
    if (\$valor === null) {
        \$missing[] = \$var;
        echo "MISSING:\$var\n";
    } else {
        \$found[] = \$var;
        echo "FOUND:\$var=\$valor\n";
    }
}

if (count(\$missing) > 0) {
    echo "TOTAL_MISSING:" . count(\$missing) . "\n";
    echo "TOTAL_FOUND:" . count(\$found) . "\n";
    exit(1);
} else {
    echo "TOTAL_MISSING:0\n";
    echo "TOTAL_FOUND:" . count(\$found) . "\n";
    exit(0);
}
EOFPHP

# Executar script PHP
php /tmp/verificar_variaveis.php
EXIT_CODE=\$?

# Remover script PHP temporário
rm -f /tmp/verificar_variaveis.php

exit \$EXIT_CODE
"@

# Executar verificação
$verifyResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $verifyVarsScript -ScriptName "verify_vars.sh"

# Processar resultados
$foundVars = @()
$missingVars = @()

$verifyResult | ForEach-Object {
    if ($_ -match '^FOUND:(.+?)=(.*)$') {
        $foundVars += $matches[1]
        Write-Log "Variável encontrada: $($matches[1]) = $($matches[2])" -Level "INFO"
    } elseif ($_ -match '^MISSING:(.+)$') {
        $missingVars += $matches[1]
        Write-Log "Variável faltando: $($matches[1])" -Level "ERROR"
    }
}

if ($missingVars.Count -gt 0) {
    Write-Log "Variáveis faltando: $($missingVars -join ', ')" -Level "ERROR"
    throw "Algumas variáveis não estão disponíveis no ambiente PHP"
}

Write-Log "Todas as $($foundVars.Count) variáveis estão disponíveis" -Level "INFO"
```

**Validação:**
- ✅ Todas as 21 variáveis estão disponíveis
- ✅ Valores das variáveis estão corretos
- ✅ Scripts temporários removidos

**Risco:** 🟡 **MÉDIO**

---

### FASE 9: Testes Funcionais

**Objetivo:** Testar funcionalidades que dependem das novas variáveis e garantir que arquivos .js e .php existentes continuam funcionando

**Tarefas:**
- [ ] **CRÍTICO:** Verificar que arquivos .js e .php em produção continuam funcionando normalmente
- [ ] **CRÍTICO:** Testar funcionalidades existentes que não dependem das novas variáveis
- [ ] Testar validação de CPF/CNPJ (APILAYER_KEY)
- [ ] Testar integração SafetyMails (SAFETY_TICKET, SAFETY_API_KEY)
- [ ] Testar consulta de CEP (VIACEP_BASE_URL)
- [ ] Testar envio de email AWS SES (AWS_SES_FROM_EMAIL, AWS_SES_FROM_NAME)
- [ ] Testar integração PH3A (PH3A_*)
- [ ] Testar integração PLACAFIPE (PLACAFIPE_*)
- [ ] Verificar logs de erros após testes
- [ ] Verificar console do navegador para erros JavaScript
- [ ] Verificar que nenhuma funcionalidade existente foi quebrada

**Validação:**
- ✅ Arquivos .js e .php em produção funcionando normalmente
- ✅ Nenhuma funcionalidade existente foi quebrada
- ✅ Todas as funcionalidades testadas
- ✅ Nenhum erro crítico encontrado
- ✅ Logs verificados e limpos
- ✅ Console do navegador sem erros relacionados às variáveis

**Risco:** 🔴 **ALTO** - Testes em produção podem afetar usuários reais

**Nota:** Alguns testes podem requerer validação manual ou intervenção do usuário.

**Garantias de Preservação:**
- ✅ Variáveis existentes não são modificadas (exceto `AWS_SES_FROM_EMAIL` que é correção)
- ✅ Apenas adição de novas variáveis (não remoção de existentes)
- ✅ Valores das variáveis existentes preservados
- ✅ Arquivos .js e .php não são modificados pelo projeto

---

### FASE 10: Documentação Final

**Objetivo:** Documentar todas as alterações realizadas

**Tarefas:**
- [ ] Criar relatório de execução
- [ ] Documentar todas as variáveis adicionadas/modificadas
- [ ] Registrar hash SHA256 do backup criado
- [ ] Atualizar documento `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`
- [ ] Atualizar status do projeto para "CONCLUÍDO"
- [ ] Criar documento de auditoria pós-implementação

**Arquivos a Criar/Atualizar:**
- `RELATORIO_EXECUCAO_ATUALIZAR_VARIAVEIS_PROD_20251122.md`
- `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md` (atualizar)
- `AUDITORIA_PROJETO_ATUALIZAR_VARIAVEIS_PROD_20251122.md`

**Validação:**
- ✅ Relatório de execução criado
- ✅ Documentação atualizada
- ✅ Auditoria pós-implementação realizada

**Risco:** 🟢 **BAIXO**

---

## 📁 ARQUIVOS ENVOLVIDOS

### Arquivos a Criar

1. **`WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/atualizar_variaveis_ambiente_prod.ps1`**
   - Script PowerShell para automatizar atualização
   - Status: ⏳ A criar

### Arquivos a Modificar (Servidor PROD)

1. **`/etc/php/8.3/fpm/pool.d/www.conf`**
   - Arquivo de configuração PHP-FPM
   - Modificações: Adicionar 20 variáveis + Modificar 1 variável
   - Status: ⏳ A modificar

### Arquivos de Documentação a Criar

1. **`WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/RELATORIO_EXECUCAO_ATUALIZAR_VARIAVEIS_PROD_20251122.md`**
   - Relatório detalhado da execução
   - Status: ⏳ A criar

2. **`WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/AUDITORIA_PROJETO_ATUALIZAR_VARIAVEIS_PROD_20251122.md`**
   - Auditoria pós-implementação
   - Status: ⏳ A criar

### Arquivos de Documentação a Atualizar

1. **`WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`**
   - Atualizar com variáveis adicionadas/modificadas
   - Status: ⏳ A atualizar

2. **`WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PROJETO_ATUALIZAR_VARIAVEIS_AMBIENTE_PROD_20251122.md`**
   - Atualizar status para "CONCLUÍDO"
   - Status: ⏳ A atualizar

---

## ⚠️ RISCOS E MITIGAÇÕES

### 🔴 Riscos Críticos

1. **Modificação em Servidor de Produção**
   - **Risco:** Alterações em produção podem afetar usuários reais
   - **Severidade:** 🔴 **CRÍTICA**
   - **Probabilidade:** 🟡 **MÉDIA** (mitigada por backup e validação)
   - **Mitigação:**
     - Criar backup antes de qualquer modificação
     - Validar sintaxe antes de recarregar PHP-FPM
     - Executar em horário de baixo tráfego (se possível)
     - Ter plano de rollback pronto e testado
   - **Plano de Contingência:** Restaurar backup imediatamente se problemas forem detectados

2. **PHP-FPM Não Recarregar Corretamente**
   - **Risco:** Se PHP-FPM não recarregar, pode causar downtime
   - **Severidade:** 🔴 **CRÍTICA**
   - **Probabilidade:** 🟢 **BAIXA** (mitigada por validação de sintaxe prévia)
   - **Mitigação:**
     - Validar sintaxe antes de recarregar
     - Verificar logs após recarga
     - Ter backup para restaurar se necessário
   - **Plano de Contingência:** Restaurar arquivo de configuração do backup e recarregar PHP-FPM

3. **Variáveis com Valores Incorretos**
   - **Risco:** Valores incorretos podem quebrar funcionalidades
   - **Severidade:** 🔴 **CRÍTICA**
   - **Probabilidade:** 🟢 **BAIXA** (valores validados antes de adicionar)
   - **Mitigação:**
     - Validar valores antes de adicionar
     - Verificar variáveis após adição
     - Testar funcionalidades após atualização
   - **Plano de Contingência:** Corrigir valores incorretos ou restaurar backup

### 🟡 Riscos Médios

1. **Script PowerShell com Bugs**
   - **Risco:** Script pode ter erros que causem problemas
   - **Severidade:** 🟡 **MÉDIA**
   - **Probabilidade:** 🟢 **BAIXA** (mitigada por validação local e dry-run)
   - **Mitigação:**
     - Validar script localmente antes de executar
     - Executar em modo dry-run primeiro
     - Revisar código cuidadosamente
   - **Plano de Contingência:** Corrigir script e executar novamente, ou executar manualmente se necessário

2. **Duplicação de Variáveis**
   - **Risco:** Variáveis podem ser duplicadas no arquivo
   - **Severidade:** 🟡 **MÉDIA**
   - **Probabilidade:** 🟢 **BAIXA** (mitigada por verificação de duplicatas)
   - **Mitigação:**
     - Verificar duplicatas antes de adicionar
     - Validar arquivo após modificações
   - **Plano de Contingência:** Remover duplicatas manualmente ou restaurar backup

### 🟢 Riscos Baixos

1. **Documentação Incompleta**
   - **Risco:** Documentação pode não refletir alterações
   - **Severidade:** 🟢 **BAIXA**
   - **Probabilidade:** 🟡 **MÉDIA**
   - **Mitigação:**
     - Atualizar documentação imediatamente após execução
     - Revisar documentação antes de finalizar
   - **Plano de Contingência:** Atualizar documentação posteriormente se necessário

---

## 🔄 PLANO DE ROLLBACK DETALHADO

### Objetivo do Rollback

Restaurar o arquivo de configuração PHP-FPM (`/etc/php/8.3/fpm/pool.d/www.conf`) ao estado anterior à execução do projeto, garantindo que todas as variáveis de ambiente retornem aos valores mapeados em `MAPEAMENTO_VARIAVEIS_AMBIENTE_PROD_20251122.md`.

### Quando Executar Rollback

Execute o rollback se:
- ❌ Sintaxe do arquivo PHP-FPM estiver incorreta após modificações
- ❌ PHP-FPM não recarregar corretamente após validação bem-sucedida
- ❌ Variáveis não estiverem disponíveis após adição
- ❌ Funcionalidades críticas falharem após atualização
- ❌ Erros críticos aparecerem nos logs após atualização
- ❌ Qualquer problema que comprometa o funcionamento do ambiente PROD

### Procedimento de Rollback Passo a Passo

#### **ETAPA 1: Identificar Backup**

```powershell
# Listar backups disponíveis
$backupScript = @"
#!/bin/bash
ls -lt /etc/php/8.3/fpm/pool.d/www.conf.backup_* 2>/dev/null | head -5
"@

$backups = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $backupScript -ScriptName "list_backups.sh"

# Identificar backup mais recente (criado antes da execução do projeto)
# Formato esperado: www.conf.backup_YYYYMMDD_HHMMSS
```

**Validação:**
- ✅ Backup existe e é acessível
- ✅ Backup foi criado antes da execução do projeto
- ✅ Hash SHA256 do backup foi documentado na Fase 4

#### **ETAPA 2: Verificar Integridade do Backup**

```powershell
# Verificar hash do backup
$verifyBackupScript = @"
#!/bin/bash
BACKUP_FILE="/etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS"
EXPECTED_HASH="HASH_DOCUMENTADO_NA_FASE_4"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERRO: Backup não encontrado"
    exit 1
fi

ACTUAL_HASH=$(sha256sum "$BACKUP_FILE" | cut -d' ' -f1)

if [ "$ACTUAL_HASH" != "$EXPECTED_HASH" ]; then
    echo "ERRO: Hash do backup não coincide"
    echo "Esperado: $EXPECTED_HASH"
    echo "Atual: $ACTUAL_HASH"
    exit 1
fi

echo "BACKUP_OK=1"
echo "BACKUP_HASH=$ACTUAL_HASH"
"@

$verification = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $verifyBackupScript -ScriptName "verify_backup.sh"
```

**Validação:**
- ✅ Backup existe
- ✅ Hash SHA256 do backup coincide com o documentado
- ✅ Backup está íntegro

#### **ETAPA 3: Criar Backup do Estado Atual (Antes do Rollback)**

```powershell
# Criar backup do estado atual antes de restaurar
$backupCurrentScript = @"
#!/bin/bash
set -e

CONFIG_FILE="/etc/php/8.3/fpm/pool.d/www.conf"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_CURRENT="${CONFIG_FILE}.backup_before_rollback_${TIMESTAMP}"

cp "$CONFIG_FILE" "$BACKUP_CURRENT"
echo "BACKUP_CURRENT=$BACKUP_CURRENT"
echo "BACKUP_CURRENT_HASH=$(sha256sum "$BACKUP_CURRENT" | cut -d' ' -f1)"
"@

$currentBackup = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $backupCurrentScript -ScriptName "backup_current.sh"
```

**Validação:**
- ✅ Backup do estado atual criado com sucesso
- ✅ Hash SHA256 do backup atual documentado

#### **ETAPA 4: Restaurar Arquivo de Configuração**

```powershell
# Restaurar arquivo de configuração do backup
$restoreScript = @"
#!/bin/bash
set -e

CONFIG_FILE="/etc/php/8.3/fpm/pool.d/www.conf"
BACKUP_FILE="/etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS"

# Verificar que backup existe
if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERRO: Backup não encontrado: $BACKUP_FILE"
    exit 1
fi

# Restaurar arquivo
cp "$BACKUP_FILE" "$CONFIG_FILE"

# Verificar que arquivo foi restaurado
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERRO: Arquivo não foi restaurado"
    exit 1
fi

# Calcular hash do arquivo restaurado
RESTORED_HASH=$(sha256sum "$CONFIG_FILE" | cut -d' ' -f1)
BACKUP_HASH=$(sha256sum "$BACKUP_FILE" | cut -d' ' -f1)

if [ "$RESTORED_HASH" != "$BACKUP_HASH" ]; then
    echo "ERRO: Hash do arquivo restaurado não coincide com backup"
    exit 1
fi

echo "RESTORE_OK=1"
echo "RESTORED_HASH=$RESTORED_HASH"
"@

$restoreResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $restoreScript -ScriptName "restore_config.sh"
```

**Validação:**
- ✅ Arquivo restaurado com sucesso
- ✅ Hash SHA256 do arquivo restaurado coincide com o backup
- ✅ Arquivo está íntegro

#### **ETAPA 5: Validar Sintaxe do Arquivo Restaurado**

```powershell
# Validar sintaxe do arquivo restaurado
$validateRestoredScript = @"
#!/bin/bash
set -e

VALIDATION_OUTPUT=$(php-fpm8.3 -tt 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "ERRO_SINTAXE=1"
    echo "VALIDATION_OUTPUT<<EOF"
    echo "$VALIDATION_OUTPUT"
    echo "EOF"
    exit 1
else
    echo "SINTAXE_OK=1"
    echo "VALIDATION_OUTPUT<<EOF"
    echo "$VALIDATION_OUTPUT"
    echo "EOF"
fi
"@

$validation = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $validateRestoredScript -ScriptName "validate_restored.sh"
```

**Validação:**
- ✅ Sintaxe do arquivo restaurado está correta
- ✅ Nenhum erro de sintaxe detectado

#### **ETAPA 6: Recarregar PHP-FPM**

```powershell
# Recarregar PHP-FPM após restauração
$reloadScript = @"
#!/bin/bash
set -e

systemctl reload php8.3-fpm
RELOAD_EXIT=$?

if [ $RELOAD_EXIT -ne 0 ]; then
    echo "ERRO_RECARGA=1"
    exit 1
fi

STATUS=$(systemctl is-active php8.3-fpm)
if [ "$STATUS" != "active" ]; then
    echo "ERRO_STATUS=1"
    echo "STATUS_ATUAL=$STATUS"
    exit 1
fi

echo "RECARGA_OK=1"
echo "STATUS=$STATUS"
"@

$reloadResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $reloadScript -ScriptName "reload_after_rollback.sh"
```

**Validação:**
- ✅ PHP-FPM recarregado com sucesso
- ✅ Serviço está ativo e rodando

#### **ETAPA 7: Verificar Variáveis Restauradas**

```powershell
# Verificar que variáveis foram restauradas ao estado original
$verifyVarsScript = @"
#!/bin/bash
set -e

# Variáveis que devem existir (estado original mapeado)
VARS_ORIGINAIS=(
    "APP_BASE_DIR"
    "APP_BASE_URL"
    "APP_CORS_ORIGINS"
    "AWS_ACCESS_KEY_ID"
    "AWS_REGION"
    "AWS_SECRET_ACCESS_KEY"
    "AWS_SES_ADMIN_EMAILS"
    "AWS_SES_FROM_EMAIL"
    "ESPOCRM_API_KEY"
    "ESPOCRM_URL"
    "LOG_DB_HOST"
    "LOG_DB_NAME"
    "LOG_DB_PASS"
    "LOG_DB_PORT"
    "LOG_DB_USER"
    "LOG_DIR"
    "OCTADESK_API_BASE"
    "OCTADESK_API_KEY"
    "PHP_ENV"
    "WEBFLOW_SECRET_FLYINGDONKEYS"
    "WEBFLOW_SECRET_OCTADESK"
)

php-fpm8.3 -tt 2>&1 | grep 'env\[' > /tmp/vars_restored.txt

MISSING_VARS=()
for VAR in "\${VARS_ORIGINAIS[@]}"; do
    if ! grep -q "env\[$VAR\]" /tmp/vars_restored.txt; then
        MISSING_VARS+=("\$VAR")
    fi
done

rm -f /tmp/vars_restored.txt

if [ \${#MISSING_VARS[@]} -gt 0 ]; then
    echo "VARIAVEIS_FALTANDO=\${MISSING_VARS[*]}"
    exit 1
fi

# Verificar que variáveis adicionadas pelo projeto foram removidas
VARS_ADICIONADAS=(
    "APILAYER_KEY"
    "SAFETY_TICKET"
    "SAFETY_API_KEY"
    "AWS_SES_FROM_NAME"
    "VIACEP_BASE_URL"
    "APILAYER_BASE_URL"
    "SAFETYMAILS_OPTIN_BASE"
    "RPA_API_BASE_URL"
    "SAFETYMAILS_BASE_DOMAIN"
    "PH3A_API_KEY"
    "PH3A_DATA_URL"
    "PH3A_LOGIN_URL"
    "PH3A_PASSWORD"
    "PH3A_USERNAME"
    "PLACAFIPE_API_TOKEN"
    "PLACAFIPE_API_URL"
    "SUCCESS_PAGE_URL"
    "RPA_ENABLED"
    "USE_PHONE_API"
    "VALIDAR_PH3A"
    "OCTADESK_FROM"
)

php-fpm8.3 -tt 2>&1 | grep 'env\[' > /tmp/vars_restored.txt

REMAINING_VARS=()
for VAR in "\${VARS_ADICIONADAS[@]}"; do
    if grep -q "env\[$VAR\]" /tmp/vars_restored.txt; then
        REMAINING_VARS+=("\$VAR")
    fi
done

rm -f /tmp/vars_restored.txt

if [ \${#REMAINING_VARS[@]} -gt 0 ]; then
    echo "VARIAVEIS_REMANESCENTES=\${REMAINING_VARS[*]}"
    echo "AVISO: Variáveis adicionadas pelo projeto ainda estão presentes"
fi

echo "TODAS_VARIAVEIS_ORIGINAIS_PRESENTES=1"
"@

$verifyResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $verifyVarsScript -ScriptName "verify_restored_vars.sh"
```

**Validação:**
- ✅ Todas as 21 variáveis originais estão presentes
- ✅ Variáveis adicionadas pelo projeto foram removidas (ou não existem mais)
- ✅ Valores das variáveis originais estão corretos

#### **ETAPA 8: Verificar Valores Específicos**

```powershell
# Verificar valores específicos das variáveis críticas
$verifyValuesScript = @"
#!/bin/bash
set -e

# Valores esperados (do mapeamento)
declare -A EXPECTED_VALUES=(
    ["AWS_SES_FROM_EMAIL"]="noreply@bssegurosimediato.com.br"
    ["APP_BASE_DIR"]="/var/www/html/prod/root"
    ["APP_BASE_URL"]="https://prod.bssegurosimediato.com.br"
    ["PHP_ENV"]="production"
)

php-fpm8.3 -tt 2>&1 | grep 'env\[' > /tmp/vars_values.txt

ERRORS=0
for VAR in "\${!EXPECTED_VALUES[@]}"; do
    EXPECTED="\${EXPECTED_VALUES[\$VAR]}"
    ACTUAL=$(grep "env\[$VAR\]" /tmp/vars_values.txt | sed "s/.*env\[$VAR\] = //")
    
    if [ "$ACTUAL" != "$EXPECTED" ]; then
        echo "ERRO: $VAR tem valor incorreto"
        echo "Esperado: $EXPECTED"
        echo "Atual: $ACTUAL"
        ERRORS=$((ERRORS + 1))
    fi
done

rm -f /tmp/vars_values.txt

if [ $ERRORS -gt 0 ]; then
    echo "TOTAL_ERROS=$ERRORS"
    exit 1
fi

echo "VALORES_OK=1"
"@

$valuesResult = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $verifyValuesScript -ScriptName "verify_values.sh"
```

**Validação:**
- ✅ Valores das variáveis críticas estão corretos
- ✅ `AWS_SES_FROM_EMAIL` está com valor original (`noreply@bssegurosimediato.com.br`)

#### **ETAPA 9: Testar Funcionalidades Críticas**

```powershell
# Testar funcionalidades críticas após rollback
# Nota: Alguns testes podem requerer validação manual

Write-Log "Testando funcionalidades críticas após rollback..." -Level "INFO"

# Verificar logs do PHP-FPM
$checkLogsScript = @"
#!/bin/bash
tail -50 /var/log/php8.3-fpm.log 2>/dev/null | grep -i "error\|fatal\|critical" | wc -l
"@

$logErrors = Invoke-SafeSSHScript -Server "157.180.36.223" -ScriptContent $checkLogsScript -ScriptName "check_logs.sh"

if ($logErrors -gt 0) {
    Write-Log "Aviso: $logErrors erros encontrados nos logs após rollback" -Level "WARN"
} else {
    Write-Log "Nenhum erro crítico encontrado nos logs" -Level "INFO"
}
```

**Validação:**
- ✅ Nenhum erro crítico nos logs
- ✅ Funcionalidades críticas funcionando (validação manual recomendada)

#### **ETAPA 10: Documentar Rollback**

```powershell
# Documentar rollback realizado
$rollbackInfo = @{
    DataRollback = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    BackupRestaurado = "www.conf.backup_YYYYMMDD_HHMMSS"
    HashBackup = "HASH_DOCUMENTADO_NA_FASE_4"
    MotivoRollback = "MOTIVO_DO_ROLLBACK"
    Status = "SUCESSO" # ou "FALHA"
    Observacoes = "OBSERVACOES_RELEVANTES"
}

# Salvar informações do rollback
$rollbackInfo | ConvertTo-Json | Out-File "rollback_info_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
```

**Validação:**
- ✅ Rollback documentado com todas as informações relevantes
- ✅ Informações salvas para referência futura

### Resumo do Procedimento de Rollback

| Etapa | Ação | Validação |
|-------|------|-----------|
| 1 | Identificar backup | Backup existe e é acessível |
| 2 | Verificar integridade | Hash SHA256 coincide |
| 3 | Backup estado atual | Backup criado antes de restaurar |
| 4 | Restaurar arquivo | Arquivo restaurado e íntegro |
| 5 | Validar sintaxe | Sintaxe correta |
| 6 | Recarregar PHP-FPM | PHP-FPM ativo |
| 7 | Verificar variáveis | Todas as 21 variáveis originais presentes |
| 8 | Verificar valores | Valores críticos corretos |
| 9 | Testar funcionalidades | Nenhum erro crítico |
| 10 | Documentar | Rollback documentado |

### Tempo Estimado para Rollback

- **Tempo Base:** 0.5 horas
- **Buffer:** 0.2 horas
- **Tempo Total:** 0.7 horas

### Observações Importantes

1. ⚠️ **CRÍTICO:** Execute rollback apenas se problemas críticos forem detectados
2. ✅ **SEMPRE** crie backup do estado atual antes de restaurar
3. ✅ **SEMPRE** valide sintaxe antes de recarregar PHP-FPM
4. ✅ **SEMPRE** verifique variáveis após rollback
5. ✅ **SEMPRE** documente o rollback realizado

---

## 🧪 CASOS EXTREMOS DE TESTE

### Casos Extremos Identificados

#### **Caso 1: Variável Já Existe no Arquivo**

**Cenário:** Variável a ser adicionada já existe no arquivo PHP-FPM config.

**Comportamento Esperado:**
- Script detecta variável existente
- Script não adiciona duplicata
- Script registra aviso no log
- Script continua com próxima variável

**Validação:**
```powershell
# Verificar se variável já existe antes de adicionar
$checkExistsScript = @"
#!/bin/bash
VAR_NAME="NOME_VARIAVEL"
if grep -q "env\[$VAR_NAME\]" /etc/php/8.3/fpm/pool.d/www.conf; then
    echo "VARIAVEL_EXISTE=1"
    exit 0
else
    echo "VARIAVEL_EXISTE=0"
    exit 0
fi
"@
```

#### **Caso 2: Sintaxe Incorreta Após Modificação**

**Cenário:** Arquivo PHP-FPM config fica com sintaxe incorreta após adicionar variáveis.

**Comportamento Esperado:**
- Validação de sintaxe detecta erro
- Script NÃO recarrega PHP-FPM
- Script registra erro crítico
- Script oferece opção de rollback

**Validação:**
```powershell
# Validar sintaxe após modificação
$validateSyntaxScript = @"
#!/bin/bash
php-fpm8.3 -tt 2>&1
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    echo "ERRO_SINTAXE=1"
    exit 1
fi
"@
```

#### **Caso 3: PHP-FPM Não Recarrega Após Validação Bem-Sucedida**

**Cenário:** Sintaxe está correta, mas PHP-FPM não recarrega.

**Comportamento Esperado:**
- Script detecta falha no reload
- Script verifica status do serviço
- Script registra erro crítico
- Script oferece opção de rollback

**Validação:**
```powershell
# Verificar status após reload
$checkStatusScript = @"
#!/bin/bash
systemctl reload php8.3-fpm
if [ $? -ne 0 ]; then
    echo "ERRO_RELOAD=1"
    exit 1
fi

STATUS=$(systemctl is-active php8.3-fpm)
if [ "$STATUS" != "active" ]; then
    echo "ERRO_STATUS=1"
    echo "STATUS=$STATUS"
    exit 1
fi
"@
```

#### **Caso 4: Script Temporário Falha na Criação**

**Cenário:** Script temporário não pode ser criado no servidor.

**Comportamento Esperado:**
- Script detecta falha na criação
- Script registra erro
- Script tenta método alternativo (se disponível)
- Script aborta execução se não conseguir criar script

**Validação:**
```powershell
# Verificar criação de script temporário
$createScriptScript = @"
#!/bin/bash
TEMP_SCRIPT="/tmp/test_script.sh"
cat > "$TEMP_SCRIPT" << 'EOF'
echo "test"
EOF

if [ ! -f "$TEMP_SCRIPT" ]; then
    echo "ERRO_CRIACAO=1"
    exit 1
fi

chmod +x "$TEMP_SCRIPT"
rm -f "$TEMP_SCRIPT"
echo "CRIACAO_OK=1"
"@
```

#### **Caso 5: Backup Não Existe ou Está Corrompido**

**Cenário:** Backup criado na Fase 4 não existe ou está corrompido.

**Comportamento Esperado:**
- Script detecta ausência ou corrupção do backup
- Script aborta execução imediatamente
- Script registra erro crítico
- Script NÃO prossegue sem backup válido

**Validação:**
```powershell
# Verificar backup antes de modificar
$verifyBackupScript = @"
#!/bin/bash
BACKUP_FILE="/etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "ERRO_BACKUP_NAO_EXISTE=1"
    exit 1
fi

HASH=$(sha256sum "$BACKUP_FILE" | cut -d' ' -f1)
EXPECTED_HASH="HASH_DOCUMENTADO"

if [ "$HASH" != "$EXPECTED_HASH" ]; then
    echo "ERRO_BACKUP_CORRUPTO=1"
    exit 1
fi

echo "BACKUP_OK=1"
"@
```

#### **Caso 6: Variável Adicionada Mas Não Disponível no Ambiente PHP**

**Cenário:** Variável foi adicionada ao arquivo, mas não está disponível em `$_ENV`.

**Comportamento Esperado:**
- Script detecta variável ausente em `$_ENV`
- Script registra erro
- Script verifica se PHP-FPM foi recarregado
- Script oferece opção de rollback se necessário

**Validação:**
```powershell
# Verificar variável no ambiente PHP
$checkEnvScript = @"
#!/bin/bash
cat > /tmp/check_env.php << 'EOFPHP'
<?php
\$var = 'NOME_VARIAVEL';
if (isset(\$_ENV[\$var])) {
    echo "VARIAVEL_PRESENTE=1";
    echo "VALOR=" . \$_ENV[\$var];
} else {
    echo "VARIAVEL_AUSENTE=1";
    exit 1;
}
EOFPHP

php /tmp/check_env.php
rm -f /tmp/check_env.php
"@
```

### Plano de Ação para Casos Extremos

| Caso | Ação Imediata | Ação de Contingência |
|------|---------------|---------------------|
| Variável já existe | Pular adição, registrar aviso | Continuar execução |
| Sintaxe incorreta | Abortar, não recarregar PHP-FPM | Executar rollback |
| PHP-FPM não recarrega | Verificar logs, tentar restart | Executar rollback |
| Script temporário falha | Tentar método alternativo | Abortar execução |
| Backup não existe | Abortar execução imediatamente | Criar backup antes de continuar |
| Variável não disponível | Verificar recarga PHP-FPM | Executar rollback se necessário |

---

## ✅ CHECKLIST DE VALIDAÇÃO

### Antes de Executar

- [ ] Projeto revisado e aprovado pelo usuário
- [ ] Acesso SSH ao servidor PROD confirmado
- [ ] Backup do arquivo PHP-FPM config criado
- [ ] Script PowerShell criado e validado localmente
- [ ] Valores das variáveis confirmados
- [ ] Plano de rollback preparado

### Durante Execução

- [ ] Script executado sem erros
- [ ] Todas as variáveis processadas corretamente
- [ ] Sintaxe do arquivo PHP-FPM validada
- [ ] PHP-FPM recarregado com sucesso
- [ ] Variáveis verificadas e confirmadas

### Após Execução

- [ ] Funcionalidades testadas
- [ ] Logs verificados sem erros críticos
- [ ] Documentação atualizada
- [ ] Auditoria pós-implementação realizada
- [ ] Projeto marcado como "CONCLUÍDO"

---

## 📊 LISTA COMPLETA DE VARIÁVEIS

### 🔴 CRÍTICO - Modificar (1 variável)

1. `AWS_SES_FROM_EMAIL` = `"noreply@bpsegurosimediato.com.br"` (modificar de `noreply@bssegurosimediato.com.br`)

### 🔴 CRÍTICO - Adicionar (3 variáveis)

1. `APILAYER_KEY` = `"dce92fa84152098a3b5b7b8db24debbc"`
2. `SAFETY_TICKET` = `"05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`
3. `SAFETY_API_KEY` = `"20a7a1c297e39180bd80428ac13c363e882a531f"`

### 🟡 ALTO - Adicionar (13 variáveis)

1. `AWS_SES_FROM_NAME` = `"BP Seguros Imediato"`
2. `VIACEP_BASE_URL` = `"https://viacep.com.br"`
3. `APILAYER_BASE_URL` = `"https://apilayer.net"`
4. `SAFETYMAILS_OPTIN_BASE` = `"https://optin.safetymails.com"`
5. `RPA_API_BASE_URL` = `"https://rpaimediatoseguros.com.br"`
6. `SAFETYMAILS_BASE_DOMAIN` = `"safetymails.com"`
7. `PH3A_API_KEY` = `"691dd2aa-9af4-84f2-06f9-350e1d709602"`
8. `PH3A_DATA_URL` = `"https://api.ph3a.com.br/DataBusca/api/Data/GetData"`
9. `PH3A_LOGIN_URL` = `"https://api.ph3a.com.br/DataBusca/api/Account/Login"`
10. `PH3A_PASSWORD` = `"ImdSeg2025$$"`
11. `PH3A_USERNAME` = `"alex.kaminski@imediatoseguros.com.br"`
12. `PLACAFIPE_API_TOKEN` = `"1696FBDDD9736D542D6958B1770B683EBBA1EFCCC4D0963A2A8A6FA9EFC29214"`
13. `PLACAFIPE_API_URL` = `"https://api.placafipe.com.br/getplaca"`
14. `SUCCESS_PAGE_URL` = `"https://www.segurosimediato.com.br/sucesso"`

### 🟢 MÉDIO - Adicionar (4 variáveis)

1. `RPA_ENABLED` = `"false"`
2. `USE_PHONE_API` = `"true"`
3. `VALIDAR_PH3A` = `"false"`
4. `OCTADESK_FROM` = `"+551132301422"`

**Total:** 21 variáveis (1 modificar + 20 adicionar)

---

## 🔗 DOCUMENTAÇÃO RELACIONADA

- **Análise de Variáveis:** `ANALISE_VARIAVEIS_AMBIENTE_DEV_PROD_20251122.md`
- **Tracking de Alterações:** `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`
- **Diretivas do Projeto:** `./cursorrules`

---

## 📝 NOTAS IMPORTANTES

1. **🚨 CRÍTICO:** Este projeto modifica o servidor de PRODUÇÃO. NÃO executar sem autorização explícita do usuário.

2. **Backup Obrigatório:** Sempre criar backup antes de qualquer modificação.

3. **Validação Obrigatória:** Sempre validar sintaxe antes de recarregar PHP-FPM.

4. **Métodos Seguros SSH:** Este projeto foi refatorado para usar scripts temporários no servidor ao invés de comandos SSH inline complexos, evitando problemas de escape de caracteres e sintaxe.

5. **Scripts Temporários:** Todos os scripts temporários são criados, executados e removidos automaticamente. Nenhum arquivo temporário permanece no servidor após execução.

6. **Tratamento de Erros:** Todas as funções wrapper SSH incluem tratamento de erros robusto e validação de códigos de saída.

7. **Testes em Produção:** Alguns testes podem requerer validação manual ou intervenção do usuário.

8. **Documentação:** Atualizar documentação imediatamente após execução.

---

---

## 🔧 HISTÓRICO DE VERSÕES

### Versão 3.1.0 (22/11/2025) - Atualização de Objetivos

**Melhorias Implementadas:**

1. **Objetivos Atualizados:**
   - ✅ Garantia explícita de preservação de arquivos .js e .php em produção
   - ✅ Garantia de que nenhuma funcionalidade existente será quebrada
   - ✅ Objetivos clarificados para focar apenas em atualização de variáveis

2. **Critérios de Aceitação Expandidos:**
   - ✅ Verificação de funcionamento de arquivos .js e .php após atualização
   - ✅ Verificação de console do navegador para erros JavaScript
   - ✅ Validação de que funcionalidades existentes não foram quebradas

3. **Fase 9 Atualizada:**
   - ✅ Tarefas críticas adicionadas para verificar preservação de funcionalidades
   - ✅ Garantias de preservação documentadas
   - ✅ Verificação de console do navegador incluída

**Benefícios:**
- ✅ Clareza sobre o escopo do projeto (apenas variáveis de ambiente)
- ✅ Garantia explícita de preservação de funcionalidades existentes
- ✅ Critérios de validação mais completos

---

### Versão 3.0.0 (22/11/2025) - Adequação ao Relatório de Auditoria

**Melhorias Implementadas:**

1. **Plano de Rollback Detalhado:**
   - ✅ Procedimento passo a passo completo (10 etapas)
   - ✅ Restauração ao estado mapeado em `MAPEAMENTO_VARIAVEIS_AMBIENTE_PROD_20251122.md`
   - ✅ Validação de integridade do backup antes de restaurar
   - ✅ Verificação de variáveis e valores após rollback
   - ✅ Documentação obrigatória do rollback realizado

2. **Avaliação de Probabilidade de Riscos:**
   - ✅ Probabilidade avaliada para cada risco (Alta, Média, Baixa)
   - ✅ Justificativa da avaliação documentada
   - ✅ Planos de contingência detalhados para cada risco

3. **Casos Extremos de Teste:**
   - ✅ 6 casos extremos documentados
   - ✅ Comportamento esperado para cada caso
   - ✅ Scripts de validação para cada caso
   - ✅ Plano de ação para casos extremos

4. **Identificação de Stakeholders:**
   - ✅ Seção de stakeholders adicionada
   - ✅ Processo de aprovação documentado
   - ✅ Responsabilidades identificadas

**Benefícios:**
- ✅ Maior segurança com plano de rollback detalhado
- ✅ Melhor compreensão de riscos com avaliação de probabilidade
- ✅ Preparação para casos extremos com testes documentados
- ✅ Clareza sobre responsabilidades com stakeholders identificados

---

### Versão 2.0.0 (22/11/2025) - Refatoração de Métodos SSH

**Problema Identificado:**
- Comandos SSH inline complexos falhavam por problemas de escape de caracteres
- Sintaxe complexa com múltiplos pipes causava erros de parsing
- Difícil depurar quando comandos falhavam

**Solução Implementada:**
- ✅ Funções wrapper SSH com tratamento de erros robusto
- ✅ Uso de scripts temporários no servidor para operações complexas
- ✅ Heredoc para criar scripts sem problemas de escape
- ✅ Validação de códigos de saída em todas as operações
- ✅ Limpeza automática de scripts temporários após execução
- ✅ Logs detalhados de todas as operações SSH

**Benefícios:**
- ✅ Maior confiabilidade na execução de comandos
- ✅ Facilita depuração (scripts podem ser revisados antes de execução)
- ✅ Evita problemas de escape de caracteres
- ✅ Tratamento de erros consistente em todas as operações

---

**Última Atualização:** 22/11/2025 - Versão 3.1.0  
**Próxima Ação:** Aguardar autorização do usuário para iniciar execução

