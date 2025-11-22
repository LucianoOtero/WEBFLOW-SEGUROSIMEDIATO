# 🚀 PROJETO: Deploy - Eliminação de Variáveis Hardcoded - Servidor DEV

**Data de Criação:** 21/11/2025  
**Versão:** 1.1.0  
**Status:** 📋 **PLANEJAMENTO** - Aguardando autorização para execução  
**Última Atualização:** 21/11/2025 - Versão 1.1.0 (correções após auditoria)

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Fazer deploy de todos os arquivos modificados no projeto de eliminação de variáveis hardcoded para o servidor de desenvolvimento (DEV), garantindo integridade dos arquivos, funcionalidade preservada e configuração correta das variáveis de ambiente.

### Escopo

- **Ambiente:** DESENVOLVIMENTO (DEV) apenas
- **Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
- **Caminho no Servidor:** `/var/www/html/dev/root/`
- **Arquivos PHP:** 4 arquivos
- **Arquivos JavaScript:** 3 arquivos
- **Arquivo de Configuração:** 1 arquivo PHP-FPM config
- **Total:** 8 arquivos para deploy

### Impacto Esperado

- ✅ **Segurança:** Variáveis hardcoded eliminadas, credenciais protegidas
- ✅ **Manutenibilidade:** Configuração centralizada via variáveis de ambiente
- ✅ **Robustez:** Sistema falha explicitamente quando configuração está ausente
- ✅ **Conformidade:** Alinhamento com diretivas do projeto

### Impacto em Performance ⭐ **NOVO**

**Avaliação de Impacto:**
- ✅ **Impacto Esperado:** Mínimo ou nulo
- ✅ **Justificativa:**
  - Mudanças são apenas substituição de valores hardcoded por leitura de variáveis de ambiente
  - Variáveis de ambiente são carregadas uma vez pelo PHP-FPM no início de cada requisição
  - Leitura de variáveis de ambiente é operação de baixo custo (acesso direto a `$_ENV`)
  - JavaScript lê data attributes uma vez na inicialização (operação de baixo custo)
  - Não há mudanças em algoritmos ou lógica de processamento
  - Não há mudanças em consultas ao banco de dados
  - Não há mudanças em chamadas a APIs externas

**Métricas Esperadas:**
- Tempo de resposta de endpoints PHP: Sem alteração significativa (< 5ms adicional)
- Tempo de inicialização JavaScript: Sem alteração significativa (< 10ms adicional)
- Uso de memória: Sem alteração significativa

**Monitoramento:**
- Monitorar logs do PHP-FPM após deploy para identificar qualquer degradação
- Comparar tempos de resposta antes e depois do deploy (se métricas disponíveis)
- Validar que não há aumento significativo de erros ou timeouts

---

## 🎯 ESPECIFICAÇÕES DO USUÁRIO

### Requisitos Específicos

1. **Deploy APENAS para ambiente DEV** (conforme diretivas)
2. **Criar backups no servidor** antes de qualquer modificação
3. **Verificar hash SHA256** após cópia de cada arquivo
4. **Atualizar PHP-FPM config** no servidor DEV
5. **Recarregar PHP-FPM** após atualização de configuração
6. **Testar funcionalidades** após deploy
7. **Avisar sobre cache Cloudflare** (obrigatório)

### Critérios de Aceitação

- ✅ Todos os arquivos copiados com sucesso
- ✅ Hash SHA256 de todos os arquivos verificado e confirmado
- ✅ PHP-FPM config atualizado e recarregado
- ✅ Variáveis de ambiente carregadas corretamente
- ✅ Funcionalidades testadas e funcionando
- ✅ Nenhum erro crítico nos logs
- ✅ Cache Cloudflare limpo (avisar ao usuário)

---

## 📊 RESUMO DAS FASES

| Fase | Descrição | Tempo Base | Buffer | Tempo Total | Risco | Status |
|------|-----------|------------|--------|-------------|-------|--------|
| 1 | Preparação e Verificação | 0.5h | 0.1h | 0.6h | 🟢 | ⏳ Pendente |
| 2 | Backups no Servidor | 0.5h | 0.1h | 0.6h | 🟢 | ⏳ Pendente |
| 3 | Deploy Arquivos PHP | 1h | 0.2h | 1.2h | 🟡 | ⏳ Pendente |
| 4 | Deploy Arquivos JavaScript | 1h | 0.2h | 1.2h | 🟡 | ⏳ Pendente |
| 5 | Atualizar PHP-FPM Config | 1h | 0.2h | 1.2h | 🔴 | ⏳ Pendente |
| 6 | Verificação de Integridade | 0.5h | 0.1h | 0.6h | 🟡 | ⏳ Pendente |
| 7 | Testes Funcionais | 1h | 0.2h | 1.2h | 🔴 | ⏳ Pendente |
| 8 | Documentação Final | 0.5h | 0.1h | 0.6h | 🟢 | ⏳ Pendente |
| **TOTAL** | | **6h** | **1.2h** | **7.2h** | | |

### ⏱️ Estimativas com Buffer para Imprevistos

**Justificativa do Buffer (20%):**
- Complexidade média do deploy
- Múltiplos arquivos e verificações
- Necessidade de testes extensivos
- Risco de problemas técnicos inesperados
- Atualização de PHP-FPM requer cuidado

---

## 👥 RECURSOS HUMANOS ⭐ **NOVO**

### Equipe Necessária

**Papéis Identificados:**
- **Desenvolvedor:** Responsável pela execução do deploy e testes
- **Administrador de Sistema:** Responsável pela atualização do PHP-FPM config e recarregamento do serviço

### Competências Necessárias

**Competências Técnicas Obrigatórias:**
- ✅ Conhecimento de SSH/SCP para acesso ao servidor
- ✅ Conhecimento de PowerShell (Windows) e Bash (Linux)
- ✅ Conhecimento de PHP-FPM e configuração de variáveis de ambiente
- ✅ Conhecimento de verificação de integridade (hash SHA256)
- ✅ Conhecimento de testes funcionais de endpoints PHP
- ✅ Conhecimento de JavaScript e testes no browser

**Competências Técnicas Desejáveis:**
- Conhecimento de Cloudflare e limpeza de cache
- Conhecimento de monitoramento de logs
- Conhecimento de rollback de deploy

### Disponibilidade de Recursos

**Recursos Técnicos:**
- ✅ Servidor DEV disponível (`dev.bssegurosimediato.com.br`)
- ✅ Acesso SSH ao servidor DEV
- ✅ PHP-FPM instalado e configurável
- ✅ Editor de código disponível

**Recursos Humanos:**
- ⚠️ **Verificar disponibilidade** do desenvolvedor para 7.2 horas de trabalho
- ⚠️ **Verificar disponibilidade** do administrador de sistema para atualização do PHP-FPM config
- ⚠️ **Verificar disponibilidade** para testes e validação após deploy

### Treinamento Necessário

**Treinamento Opcional:**
- Revisão das diretivas do projeto (`.cursorrules`)
- Revisão do processo de deploy documentado
- Revisão do processo de rollback

### Responsabilidades

**Desenvolvedor:**
- Executar todas as fases do deploy
- Criar backups antes de modificações
- Verificar hash SHA256 após cada cópia
- Testar funcionalidades após deploy
- Criar relatório de deploy

**Administrador de Sistema:**
- Atualizar PHP-FPM config no servidor
- Verificar sintaxe do PHP-FPM config
- Recarregar PHP-FPM após atualização
- Validar que PHP-FPM está funcionando corretamente

---

## 📋 FASES DETALHADAS

### FASE 1: Preparação e Verificação

**Objetivo:** Verificar pré-requisitos e acesso ao servidor

**Tarefas:**
- [ ] Verificar acesso SSH ao servidor DEV
- [ ] Verificar que diretório `/var/www/html/dev/root/` existe
- [ ] Verificar permissões do diretório
- [ ] Listar arquivos que serão modificados no servidor
- [ ] Verificar espaço em disco disponível
- [ ] Calcular hash SHA256 de todos os arquivos locais antes do deploy

**Comandos:**
```bash
# Verificar acesso SSH
ssh root@65.108.156.14 "echo 'Acesso SSH OK'"

# Verificar diretório
ssh root@65.108.156.14 "ls -la /var/www/html/dev/root/ | head -20"

# Verificar espaço em disco
ssh root@65.108.156.14 "df -h /var/www/html/dev/root/"
```

**Validação:**
- Acesso SSH funcionando
- Diretório existe e tem permissões adequadas
- Espaço em disco suficiente (> 100MB livre)

**Risco:** 🟢 **BAIXO** - Apenas verificação

**Tempo Estimado:** 0.6 horas (0.5h base + 0.1h buffer)

---

### FASE 2: Criação de Backups no Servidor

**Objetivo:** Criar backups de todos os arquivos que serão modificados

**Tarefas:**
- [ ] Criar backup de `config.php`
- [ ] Criar backup de `cpf-validate.php`
- [ ] Criar backup de `placa-validate.php`
- [ ] Criar backup de `aws_ses_config.php`
- [ ] Criar backup de `add_webflow_octa.php`
- [ ] Criar backup de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Criar backup de `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Criar backup de `webflow_injection_limpo.js`
- [ ] Criar backup do PHP-FPM config atual
- [ ] Verificar que todos os backups foram criados

**Comandos:**
```bash
# Criar timestamp único
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backups PHP
ssh root@65.108.156.14 "cp /var/www/html/dev/root/config.php /var/www/html/dev/root/config.php.backup_\${TIMESTAMP}.php"
ssh root@65.108.156.14 "cp /var/www/html/dev/root/cpf-validate.php /var/www/html/dev/root/cpf-validate.php.backup_\${TIMESTAMP}.php"
ssh root@65.108.156.14 "cp /var/www/html/dev/root/placa-validate.php /var/www/html/dev/root/placa-validate.php.backup_\${TIMESTAMP}.php"
ssh root@65.108.156.14 "cp /var/www/html/dev/root/aws_ses_config.php /var/www/html/dev/root/aws_ses_config.php.backup_\${TIMESTAMP}.php"
ssh root@65.108.156.14 "cp /var/www/html/dev/root/add_webflow_octa.php /var/www/html/dev/root/add_webflow_octa.php.backup_\${TIMESTAMP}.php"

# Backups JavaScript
ssh root@65.108.156.14 "cp /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js.backup_\${TIMESTAMP}.js"
ssh root@65.108.156.14 "cp /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js.backup_\${TIMESTAMP}.js"
ssh root@65.108.156.14 "cp /var/www/html/dev/root/webflow_injection_limpo.js /var/www/html/dev/root/webflow_injection_limpo.js.backup_\${TIMESTAMP}.js"

# Backup PHP-FPM config
ssh root@65.108.156.14 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_\${TIMESTAMP}"
```

**Validação:**
- Todos os backups criados com sucesso
- Tamanho dos backups > 0
- Timestamp correto em todos os backups

**Risco:** 🟢 **BAIXO** - Apenas criação de backups

**Tempo Estimado:** 0.6 horas (0.5h base + 0.1h buffer)

---

### FASE 3: Deploy Arquivos PHP

**Objetivo:** Copiar arquivos PHP modificados para o servidor DEV

**Tarefas:**
- [ ] Copiar `config.php`
- [ ] Verificar hash SHA256 de `config.php`
- [ ] Copiar `cpf-validate.php`
- [ ] Verificar hash SHA256 de `cpf-validate.php`
- [ ] Copiar `placa-validate.php`
- [ ] Verificar hash SHA256 de `placa-validate.php`
- [ ] Copiar `aws_ses_config.php`
- [ ] Verificar hash SHA256 de `aws_ses_config.php`
- [ ] Copiar `add_webflow_octa.php`
- [ ] Verificar hash SHA256 de `add_webflow_octa.php`
- [ ] Verificar sintaxe PHP de todos os arquivos

**Comandos:**
```powershell
# Definir caminho do workspace
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
cd $workspacePath

# Copiar config.php
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\config.php" root@65.108.156.14:/var/www/html/dev/root/

# Verificar hash SHA256
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\config.php" -Algorithm SHA256).Hash.ToUpper()
$hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/config.php | cut -d' ' -f1").ToUpper()
if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ config.php: Hash coincide"
} else {
    Write-Host "❌ config.php: Hash não coincide - tentar copiar novamente"
    exit 1
}

# Repetir para cada arquivo PHP...
```

**Validação:**
- Todos os arquivos copiados com sucesso
- Hash SHA256 de todos os arquivos coincide (case-insensitive)
- Sintaxe PHP válida em todos os arquivos

**Risco:** 🟡 **MÉDIO** - Modificações em arquivos críticos

**Tempo Estimado:** 1.2 horas (1h base + 0.2h buffer)

---

### FASE 4: Deploy Arquivos JavaScript

**Objetivo:** Copiar arquivos JavaScript modificados para o servidor DEV

**Tarefas:**
- [ ] Copiar `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Verificar hash SHA256 de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Copiar `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Verificar hash SHA256 de `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Copiar `webflow_injection_limpo.js`
- [ ] Verificar hash SHA256 de `webflow_injection_limpo.js`

**Comandos:**
```powershell
# Copiar FooterCodeSiteDefinitivoCompleto.js
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js" root@65.108.156.14:/var/www/html/dev/root/

# Verificar hash SHA256
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js" -Algorithm SHA256).Hash.ToUpper()
$hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js | cut -d' ' -f1").ToUpper()
if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ FooterCodeSiteDefinitivoCompleto.js: Hash coincide"
} else {
    Write-Host "❌ FooterCodeSiteDefinitivoCompleto.js: Hash não coincide - tentar copiar novamente"
    exit 1
}

# Repetir para cada arquivo JS...
```

**Validação:**
- Todos os arquivos copiados com sucesso
- Hash SHA256 de todos os arquivos coincide (case-insensitive)

**Risco:** 🟡 **MÉDIO** - Arquivos JavaScript críticos

**Tempo Estimado:** 1.2 horas (1h base + 0.2h buffer)

---

### FASE 5: Atualizar PHP-FPM Config

**Objetivo:** Atualizar configuração do PHP-FPM com novas variáveis de ambiente

**Tarefas:**
- [ ] Verificar sintaxe do arquivo PHP-FPM config antes de copiar
- [ ] Copiar arquivo PHP-FPM config para o servidor
- [ ] Verificar hash SHA256 do arquivo PHP-FPM config
- [ ] Verificar sintaxe do PHP-FPM config no servidor
- [ ] Recarregar PHP-FPM sem reiniciar (teste de configuração)
- [ ] Recarregar PHP-FPM (aplicar configuração)

**Comandos:**
```powershell
# Verificar sintaxe local (se possível)
# Nota: PHP-FPM config não pode ser validado localmente, apenas no servidor

# Copiar PHP-FPM config
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_www_conf_DEV.txt" root@65.108.156.14:/etc/php/8.3/fpm/pool.d/www.conf

# Verificar hash SHA256
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_www_conf_DEV.txt" -Algorithm SHA256).Hash.ToUpper()
$hashServidor = (ssh root@65.108.156.14 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf | cut -d' ' -f1").ToUpper()
if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ PHP-FPM config: Hash coincide"
} else {
    Write-Host "❌ PHP-FPM config: Hash não coincide - tentar copiar novamente"
    exit 1
}

# Verificar sintaxe no servidor
ssh root@65.108.156.14 "php-fpm8.3 -t"

# Recarregar PHP-FPM (teste de configuração)
ssh root@65.108.156.14 "systemctl reload php8.3-fpm"

# Verificar status do PHP-FPM
ssh root@65.108.156.14 "systemctl status php8.3-fpm --no-pager"
```

**Validação:**
- Arquivo PHP-FPM config copiado com sucesso
- Hash SHA256 coincide
- Sintaxe do PHP-FPM config válida
- PHP-FPM recarregado sem erros
- Status do PHP-FPM: ativo e funcionando

**Risco:** 🔴 **CRÍTICO** - Configuração do PHP-FPM pode quebrar o servidor

**Tempo Estimado:** 1.2 horas (1h base + 0.2h buffer)

---

### FASE 6: Verificação de Integridade

**Objetivo:** Verificar que todas as variáveis de ambiente estão carregadas corretamente

**Tarefas:**
- [ ] Criar script PHP de teste para verificar variáveis de ambiente
- [ ] Executar script no servidor
- [ ] Verificar que todas as variáveis obrigatórias estão definidas
- [ ] Verificar logs do PHP-FPM para erros
- [ ] Verificar que funções helper funcionam corretamente

**Comando de Teste:**
```php
<?php
// test_env_vars.php
require_once __DIR__ . '/config.php';

$vars = [
    'PHP_ENV',
    'APP_BASE_DIR',
    'APP_BASE_URL',
    'ESPOCRM_API_KEY',
    'PH3A_USERNAME',
    'PH3A_PASSWORD',
    'PH3A_API_KEY',
    'PLACAFIPE_API_TOKEN',
    'RPA_ENABLED',
    'USE_PHONE_API',
    'VALIDAR_PH3A',
    'APILAYER_KEY',
    'SAFETY_TICKET',
    'SAFETY_API_KEY',
    'VIACEP_BASE_URL',
    'APILAYER_BASE_URL',
    'RPA_API_BASE_URL',
    'SUCCESS_PAGE_URL'
];

echo "=== VERIFICAÇÃO DE VARIÁVEIS DE AMBIENTE ===\n";
foreach ($vars as $var) {
    $value = $_ENV[$var] ?? null;
    if ($value === null) {
        echo "❌ $var: NÃO DEFINIDA\n";
    } else {
        $display = strlen($value) > 20 ? substr($value, 0, 20) . '...' : $value;
        echo "✅ $var: $display\n";
    }
}

echo "\n=== TESTE DE FUNÇÕES HELPER ===\n";
try {
    echo "✅ getEnvironment(): " . getEnvironment() . "\n";
    echo "✅ getBaseUrl(): " . getBaseUrl() . "\n";
    echo "✅ getPh3aUsername(): " . getPh3aUsername() . "\n";
    echo "✅ getRpaEnabled(): " . (getRpaEnabled() ? 'true' : 'false') . "\n";
    echo "✅ getViaCepBaseUrl(): " . getViaCepBaseUrl() . "\n";
    echo "\n✅ Todas as funções helper funcionando corretamente\n";
} catch (Exception $e) {
    echo "❌ Erro ao testar funções helper: " . $e->getMessage() . "\n";
    exit(1);
}
```

**Validação:**
- Todas as variáveis obrigatórias estão definidas
- Funções helper funcionam corretamente
- Nenhum erro nos logs do PHP-FPM

**Risco:** 🟡 **MÉDIO** - Validação de configuração

**Tempo Estimado:** 0.6 horas (0.5h base + 0.1h buffer)

---

### FASE 7: Testes Funcionais

**Objetivo:** Testar que todas as funcionalidades continuam funcionando

**Tarefas:**

#### 7.1. Testes Funcionais Básicos
- [ ] Testar validação de CPF (endpoint `cpf-validate.php`)
- [ ] Testar validação de placa (endpoint `placa-validate.php`)
- [ ] Testar webhook OctaDesk (endpoint `add_webflow_octa.php`)
- [ ] Verificar que JavaScript carrega corretamente
- [ ] Verificar que variáveis JavaScript estão disponíveis

#### 7.2. Testes de Casos Extremos ⭐ **NOVO**
- [ ] **Caso Extremo 1: Variável de Ambiente Ausente**
  - Remover temporariamente uma variável crítica do PHP-FPM config
  - Testar que exceção é lançada quando função helper é chamada
  - Verificar que erro é registrado nos logs
  - Restaurar variável após teste
- [ ] **Caso Extremo 2: Data Attribute Ausente no Webflow**
  - Testar que JavaScript lança erro quando `data-rpa-enabled` não está presente
  - Testar que JavaScript lança erro quando `data-app-environment` não está presente
  - Verificar que erros aparecem no console do browser
- [ ] **Caso Extremo 3: PHP-FPM Falha ao Recarregar**
  - Simular erro de sintaxe no PHP-FPM config
  - Testar que `php-fpm8.3 -t` detecta o erro
  - Verificar que PHP-FPM não recarrega com configuração inválida
  - Restaurar configuração válida após teste
- [ ] **Caso Extremo 4: Hash SHA256 Não Coincide Após Retry**
  - Simular falha de cópia (arquivo corrompido)
  - Testar que hash não coincide após primeira tentativa
  - Tentar copiar novamente
  - Se hash ainda não coincidir após 3 tentativas, abortar deploy e fazer rollback
- [ ] **Caso Extremo 5: Variável com Valor Inválido**
  - Testar que função helper lança exceção quando variável tem valor inválido (ex: boolean onde espera string)
  - Verificar que erro é específico e informativo
- [ ] **Caso Extremo 6: Múltiplas Variáveis Ausentes**
  - Remover temporariamente múltiplas variáveis críticas
  - Testar que cada variável ausente gera exceção específica
  - Verificar que logs indicam todas as variáveis ausentes
  - Restaurar variáveis após teste

#### 7.3. Testes de Validação
- [ ] Verificar logs do sistema para erros
- [ ] Verificar que nenhum erro crítico aparece nos logs
- [ ] Verificar que exceções são lançadas corretamente quando variáveis ausentes
- [ ] Validar que sistema funciona normalmente quando todas as variáveis estão definidas

**Comandos de Teste:**
```bash
# Testar endpoint CPF
curl -X POST https://dev.bssegurosimediato.com.br/cpf-validate.php \
  -H "Content-Type: application/json" \
  -H "Origin: https://segurosimediato-dev.webflow.io" \
  -d '{"cpf":"12345678901"}'

# Testar endpoint Placa
curl -X POST https://dev.bssegurosimediato.com.br/placa-validate.php \
  -H "Content-Type: application/json" \
  -H "Origin: https://segurosimediato-dev.webflow.io" \
  -d '{"placa":"ABC1234"}'

# Verificar logs PHP-FPM
ssh root@65.108.156.14 "tail -50 /var/log/php8.3-fpm.log"
```

**Validação:**
- Endpoints PHP funcionam corretamente
- JavaScript carrega sem erros
- Variáveis JavaScript disponíveis
- Exceções lançadas quando variáveis não estão definidas
- Nenhum erro crítico nos logs
- **Casos extremos tratados adequadamente:**
  - Variável ausente → Exceção lançada ✅
  - Data attribute ausente → Erro no console ✅
  - PHP-FPM falha ao recarregar → Rollback automático ✅
  - Hash não coincide após retry → Abortar deploy ✅
  - Valor inválido → Erro específico ✅
  - Múltiplas variáveis ausentes → Múltiplas exceções ✅

**Risco:** 🔴 **CRÍTICO** - Validação de funcionalidades

**Tempo Estimado:** 1.2 horas (1h base + 0.2h buffer)

---

### FASE 8: Documentação Final

**Objetivo:** Documentar o deploy realizado

**Tarefas:**
- [ ] Criar relatório de deploy
- [ ] Documentar hash SHA256 de todos os arquivos deployados
- [ ] Documentar timestamp dos backups criados
- [ ] Documentar resultados dos testes
- [ ] Listar próximos passos (atualizar Webflow, limpar cache Cloudflare)

**Arquivos a Criar:**
- `RELATORIO_DEPLOY_ELIMINAR_HARDCODE_DEV_20251121.md`

**Validação:**
- Relatório completo criado
- Todas as informações documentadas

**Risco:** 🟢 **BAIXO** - Apenas documentação

**Tempo Estimado:** 0.6 horas (0.5h base + 0.1h buffer)

---

## ⚠️ RISCOS E MITIGAÇÕES

### Riscos Identificados

1. **🔴 CRÍTICO: PHP-FPM Config Incorreto**
   - **Risco:** Configuração incorreta pode quebrar o servidor PHP-FPM
   - **Mitigação:** 
     - Verificar sintaxe antes de aplicar (`php-fpm8.3 -t`)
     - Criar backup antes de modificar
     - Testar reload antes de restart completo
     - Ter plano de rollback pronto

2. **🔴 CRÍTICO: Variáveis de Ambiente Ausentes**
   - **Risco:** Sistema pode quebrar se variáveis não estiverem definidas
   - **Mitigação:**
     - Verificar todas as variáveis antes do deploy
     - Testar script de verificação de variáveis
     - Validar que PHP-FPM carrega variáveis corretamente

3. **🟡 MÉDIO: Hash SHA256 Não Coincide**
   - **Risco:** Arquivo pode estar corrompido ou incompleto
   - **Mitigação:**
     - Tentar copiar novamente
     - Verificar conexão de rede
     - Comparar tamanho dos arquivos

4. **🟡 MÉDIO: Cache Cloudflare**
   - **Risco:** Alterações podem não ser refletidas imediatamente
   - **Mitigação:**
     - Avisar ao usuário sobre necessidade de limpar cache
     - Documentar processo de limpeza de cache

5. **🟢 BAIXO: Rollback Necessário**
   - **Risco:** Pode ser necessário reverter mudanças
   - **Mitigação:**
     - Backups criados com timestamp
     - Processo de rollback documentado

---

## 📋 CHECKLIST DE DEPLOY

### Antes do Deploy:
- [ ] Backups locais criados ✅
- [ ] Arquivos modificados testados localmente ✅
- [ ] Hash SHA256 dos arquivos locais calculado
- [ ] Acesso SSH ao servidor verificado
- [ ] PHP-FPM config validado localmente (se possível)

### Durante o Deploy:
- [ ] FASE 1: Preparação concluída
- [ ] FASE 2: Backups no servidor criados
- [ ] FASE 3: Arquivos PHP copiados e hash verificado
- [ ] FASE 4: Arquivos JavaScript copiados e hash verificado
- [ ] FASE 5: PHP-FPM config atualizado e recarregado
- [ ] FASE 6: Integridade verificada
- [ ] FASE 7: Testes funcionais realizados
- [ ] FASE 8: Documentação criada

### Após o Deploy:
- [ ] Cache Cloudflare limpo (avisar ao usuário)
- [ ] Webflow atualizado com novos data attributes (próximo passo)
- [ ] Monitoramento de logs por 24h
- [ ] Validação de funcionalidades em produção (após atualizar Webflow)

---

## 🚨 AVISOS IMPORTANTES

### **🚨 CACHE CLOUDFLARE - OBRIGATÓRIO:**

⚠️ **IMPORTANTE:** Após atualizar arquivos no servidor, é necessário limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente. O Cloudflare pode manter versões antigas em cache, causando erros como uso de código desatualizado, funções não encontradas, etc.

**Ação Obrigatória:**
1. Acessar painel do Cloudflare
2. Selecionar domínio `dev.bssegurosimediato.com.br`
3. Ir em "Caching" → "Purge Everything"
4. Confirmar limpeza de cache

### **🚨 ATUALIZAÇÃO DO WEBFLOW:**

⚠️ **PRÓXIMO PASSO:** Após o deploy, é necessário atualizar o script tag no Webflow para incluir todos os novos data attributes necessários. Ver guia: `GUIA_CHAMADA_FOOTERCODE_WEBFLOW.md` (a ser criado na FASE 7 do projeto principal).

### **🚨 VERIFICAÇÃO DE HASH SHA256:**

⚠️ **OBRIGATÓRIO:** Verificar hash SHA256 de TODOS os arquivos após cópia para servidor. Se hash não coincidir, tentar copiar novamente. NUNCA considerar deploy concluído sem verificação de hash bem-sucedida.

### **🚨 ROLLBACK:**

Se houver problemas após o deploy:
1. Restaurar arquivos dos backups criados na FASE 2
2. Restaurar PHP-FPM config do backup
3. Recarregar PHP-FPM
4. Verificar hash SHA256 dos arquivos restaurados
5. Limpar cache do Cloudflare novamente

---

## 📝 PRÓXIMOS PASSOS

### Após Deploy Concluído:

1. **Atualizar Webflow:**
   - Adicionar todos os data attributes necessários no script tag
   - Valores para DEV e PROD
   - Testar carregamento do JavaScript

2. **Monitoramento:**
   - Monitorar logs por 24h após deploy
   - Verificar erros relacionados a variáveis de ambiente
   - Validar que exceções são lançadas corretamente quando variáveis ausentes

3. **Validação Final:**
   - Testar todas as funcionalidades end-to-end
   - Validar que nenhum fallback hardcoded está sendo usado
   - Confirmar que sistema falha explicitamente quando configuração ausente

---

## 📊 ARQUIVOS PARA DEPLOY

### Arquivos PHP (5 arquivos):
1. `config.php` - Funções helper atualizadas (sem fallbacks)
2. `cpf-validate.php` - Usa funções helper PH3A
3. `placa-validate.php` - Usa funções helper PlacaFipe
4. `aws_ses_config.php` - Usa funções helper AWS SES
5. `add_webflow_octa.php` - Usa funções helper OctaDesk

### Arquivos JavaScript (3 arquivos):
1. `FooterCodeSiteDefinitivoCompleto.js` - Lê variáveis de data attributes
2. `MODAL_WHATSAPP_DEFINITIVO.js` - Usa variáveis globais (sem fallbacks críticos)
3. `webflow_injection_limpo.js` - Usa variáveis globais (sem fallbacks críticos)

### Arquivo de Configuração (1 arquivo):
1. `php-fpm_www_conf_DEV.txt` - Configuração PHP-FPM com todas as variáveis de ambiente

**Total:** 9 arquivos

---

## 📝 HISTÓRICO DE VERSÕES

### Versão 1.1.0 (21/11/2025)
- ✅ Adicionada seção de Recursos Humanos (Finding #1 - IMPORTANTE)
- ✅ Adicionada avaliação de Impacto em Performance (Finding #2 - IMPORTANTE)
- ✅ Expandida FASE 7 com casos extremos detalhados (Finding #3 - IMPORTANTE)
- ✅ Adicionadas subseções 7.1, 7.2, 7.3 na FASE 7
- ✅ Adicionados 6 casos extremos específicos para testes
- ✅ Atualizada validação da FASE 7 com casos extremos

### Versão 1.0.0 (21/11/2025)
- ✅ Projeto inicial criado
- ✅ Fases detalhadas definidas
- ✅ Comandos de deploy documentados
- ✅ Riscos e mitigações identificados
- ✅ Checklist completo criado

---

**Projeto criado em:** 21/11/2025  
**Última atualização:** 21/11/2025 - Versão 1.1.0 (correções após auditoria)  
**Aguardando autorização para iniciar execução**

