# 🎯 PROJETO: Eliminação dos Últimos Hardcodes Restantes

**Data de Criação:** 22/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **CONCLUÍDO** - Implementação realizada com sucesso em 22/11/2025  
**Última Atualização:** 22/11/2025 - Versão 1.0.0 (Implementação concluída)

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Eliminar os últimos hardcodes restantes identificados na busca completa realizada em 22/11/2025, garantindo que todas as variáveis sejam lidas de variáveis de ambiente (PHP) ou data attributes/globals (JavaScript).

### Escopo

- **Ambiente:** DESENVOLVIMENTO (DEV) apenas
- **Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
- **Caminho no Servidor:** `/var/www/html/dev/root/`
- **Arquivos PHP:** 2 arquivos
- **Arquivos JavaScript:** 1 arquivo
- **Arquivo de Configuração:** 1 arquivo PHP-FPM config
- **Total:** 4 arquivos para modificar

### Impacto Esperado

- ✅ **Segurança:** Eliminação completa de credenciais e valores hardcoded
- ✅ **Consistência:** Uso correto de variáveis já criadas mas não utilizadas
- ✅ **Manutenibilidade:** Configuração centralizada via variáveis de ambiente
- ✅ **Robustez:** Sistema falha explicitamente quando configuração está ausente

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
| 1 | Preparação e Verificação | 0.3h | 0.1h | 0.4h | 🟢 | ⏳ Pendente |
| 2 | Backups no Servidor | 0.3h | 0.1h | 0.4h | 🟢 | ⏳ Pendente |
| 3 | Atualizar PHP-FPM Config | 0.5h | 0.1h | 0.6h | 🔴 | ⏳ Pendente |
| 4 | Modificar Arquivos PHP | 1h | 0.2h | 1.2h | 🟡 | ⏳ Pendente |
| 5 | Modificar Arquivos JavaScript | 0.5h | 0.1h | 0.6h | 🟡 | ⏳ Pendente |
| 6 | Deploy Arquivos Modificados | 1h | 0.2h | 1.2h | 🟡 | ⏳ Pendente |
| 7 | Verificação de Integridade | 0.5h | 0.1h | 0.6h | 🟡 | ⏳ Pendente |
| 8 | Testes Funcionais | 1h | 0.2h | 1.2h | 🔴 | ⏳ Pendente |
| 9 | Documentação Final | 0.3h | 0.1h | 0.4h | 🟢 | ⏳ Pendente |
| **TOTAL** | | **5.4h** | **1.2h** | **6.6h** | | |

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
- [ ] Verificar variáveis de ambiente existentes no PHP-FPM

**Comandos:**
```bash
# Verificar acesso SSH
ssh root@65.108.156.14 "echo 'Acesso SSH OK'"

# Verificar diretório
ssh root@65.108.156.14 "ls -la /var/www/html/dev/root/ | head -20"

# Verificar espaço em disco
ssh root@65.108.156.14 "df -h /var/www/html/dev/root/"

# Verificar variáveis OctaDesk existentes
ssh root@65.108.156.14 "php-fpm8.3 -tt 2>&1 | grep -i 'OCTADESK' | sort"
```

**Validação:**
- Acesso SSH funcionando
- Diretório existe e tem permissões adequadas
- Espaço em disco suficiente (> 100MB livre)
- Variáveis `OCTADESK_API_KEY` e `OCTADESK_API_BASE` existem no PHP-FPM

**Risco:** 🟢 **BAIXO** - Apenas verificação

**Tempo Estimado:** 0.4 horas (0.3h base + 0.1h buffer)

---

### FASE 2: Criação de Backups no Servidor

**Objetivo:** Criar backups de todos os arquivos que serão modificados

**Tarefas:**
- [ ] Criar backup de `add_webflow_octa.php`
- [ ] Criar backup de `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Criar backup do PHP-FPM config atual
- [ ] Verificar que todos os backups foram criados

**Comandos:**
```bash
# Criar timestamp único
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backups PHP
ssh root@65.108.156.14 "cp /var/www/html/dev/root/add_webflow_octa.php /var/www/html/dev/root/add_webflow_octa.php.backup_\${TIMESTAMP}.php"

# Backups JavaScript
ssh root@65.108.156.14 "cp /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js.backup_\${TIMESTAMP}.js"

# Backup PHP-FPM config
ssh root@65.108.156.14 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_\${TIMESTAMP}"
```

**Validação:**
- Todos os backups criados com sucesso
- Tamanho dos backups > 0
- Timestamp correto em todos os backups

**Risco:** 🟢 **BAIXO** - Apenas criação de backups

**Tempo Estimado:** 0.4 horas (0.3h base + 0.1h buffer)

---

### FASE 3: Atualizar PHP-FPM Config

**Objetivo:** Adicionar variável `OCTADESK_FROM` ao PHP-FPM config

**Tarefas:**
- [ ] Verificar sintaxe do arquivo PHP-FPM config antes de modificar
- [ ] Adicionar `env[OCTADESK_FROM] = +551132301422` ao arquivo PHP-FPM config
- [ ] Verificar sintaxe do PHP-FPM config após modificação
- [ ] Recarregar PHP-FPM sem reiniciar (teste de configuração)
- [ ] Recarregar PHP-FPM (aplicar configuração)
- [ ] Verificar que variável está carregada

**Comandos:**
```bash
# Verificar sintaxe antes
ssh root@65.108.156.14 "php-fpm8.3 -t"

# Adicionar variável ao PHP-FPM config
ssh root@65.108.156.14 "echo 'env[OCTADESK_FROM] = +551132301422' >> /etc/php/8.3/fpm/pool.d/www.conf"

# Verificar sintaxe após modificação
ssh root@65.108.156.14 "php-fpm8.3 -t"

# Recarregar PHP-FPM
ssh root@65.108.156.14 "systemctl reload php8.3-fpm"

# Verificar status do PHP-FPM
ssh root@65.108.156.14 "systemctl status php8.3-fpm --no-pager"

# Verificar que variável está carregada
ssh root@65.108.156.14 "php-fpm8.3 -tt 2>&1 | grep -i 'OCTADESK_FROM'"
```

**Validação:**
- Arquivo PHP-FPM config modificado com sucesso
- Sintaxe do PHP-FPM config válida
- PHP-FPM recarregado sem erros
- Status do PHP-FPM: ativo e funcionando
- Variável `OCTADESK_FROM` carregada corretamente

**Risco:** 🔴 **CRÍTICO** - Configuração do PHP-FPM pode quebrar o servidor

**Tempo Estimado:** 0.6 horas (0.5h base + 0.1h buffer)

---

### FASE 4: Modificar Arquivos PHP

**Objetivo:** Atualizar arquivos PHP para usar variáveis de ambiente

#### **4.1. Modificar `add_webflow_octa.php`**

**Tarefas:**
- [ ] Criar função `getOctaDeskFrom()` em `config.php`
- [ ] Substituir hardcode `$OCTADESK_FROM = '+551132301422'` por `$OCTADESK_FROM = getOctaDeskFrom();`
- [ ] Verificar que `$OCTADESK_API_KEY` e `$API_BASE` já estão usando funções helper (confirmar)
- [ ] Verificar sintaxe PHP

**Modificações Necessárias:**

**Em `config.php` (adicionar função):**
```php
/**
 * Obter número remetente OctaDesk (OCTADESK_FROM)
 * @return string Número no formato E.164 (ex: +551132301422)
 */
function getOctaDeskFrom() {
    if (empty($_ENV['OCTADESK_FROM'])) {
        error_log('[CONFIG] ERRO CRÍTICO: OCTADESK_FROM não está definido nas variáveis de ambiente');
        throw new RuntimeException('OCTADESK_FROM não está definido nas variáveis de ambiente');
    }
    return $_ENV['OCTADESK_FROM'];
}
```

**Em `add_webflow_octa.php` (linha 56):**
```php
// ❌ ANTES:
$OCTADESK_FROM = '+551132301422'; // TODO: Mover para variável de ambiente se necessário

// ✅ DEPOIS:
$OCTADESK_FROM = getOctaDeskFrom();
```

**Verificação:**
- [ ] Confirmar que linhas 54-55 já usam `getOctaDeskApiKey()` e `getOctaDeskApiBase()`
- [ ] Se não estiverem usando, corrigir também

**Validação:**
- Função `getOctaDeskFrom()` criada em `config.php`
- Hardcode substituído por função helper
- Sintaxe PHP válida
- Nenhum hardcode restante relacionado a OctaDesk

**Risco:** 🟡 **MÉDIO** - Modificações em arquivo crítico

**Tempo Estimado:** 1.2 horas (1h base + 0.2h buffer)

---

### FASE 5: Modificar Arquivos JavaScript

**Objetivo:** Atualizar arquivo JavaScript para usar variáveis globais

#### **5.1. Modificar `MODAL_WHATSAPP_DEFINITIVO.js`**

**Tarefas:**
- [ ] Substituir hardcode `phone: '551132301422'` por `phone: window.WHATSAPP_PHONE`
- [ ] Substituir hardcode `message: 'Olá! Quero uma cotação de seguro.'` por `message: window.WHATSAPP_DEFAULT_MESSAGE`
- [ ] Adicionar validação para garantir que variáveis existem
- [ ] Verificar sintaxe JavaScript

**Modificações Necessárias:**

**Em `MODAL_WHATSAPP_DEFINITIVO.js` (linha 68-69):**
```javascript
// ❌ ANTES:
whatsapp: {
  phone: '551132301422',
  message: 'Olá! Quero uma cotação de seguro.'
}

// ✅ DEPOIS:
whatsapp: {
  phone: window.WHATSAPP_PHONE || (function() {
    throw new Error('[CONFIG] ERRO CRÍTICO: window.WHATSAPP_PHONE não está definido. Carregue FooterCodeSiteDefinitivoCompleto.js ANTES deste script.');
  })(),
  message: window.WHATSAPP_DEFAULT_MESSAGE || (function() {
    throw new Error('[CONFIG] ERRO CRÍTICO: window.WHATSAPP_DEFAULT_MESSAGE não está definido. Carregue FooterCodeSiteDefinitivoCompleto.js ANTES deste script.');
  })()
}
```

**Alternativa mais limpa (adicionar validação no início do arquivo):**
```javascript
// No início do arquivo, após definir MODAL_CONFIG
if (!window.WHATSAPP_PHONE) {
  throw new Error('[CONFIG] ERRO CRÍTICO: window.WHATSAPP_PHONE não está definido. Carregue FooterCodeSiteDefinitivoCompleto.js ANTES deste script.');
}
if (!window.WHATSAPP_DEFAULT_MESSAGE) {
  throw new Error('[CONFIG] ERRO CRÍTICO: window.WHATSAPP_DEFAULT_MESSAGE não está definido. Carregue FooterCodeSiteDefinitivoCompleto.js ANTES deste script.');
}

// Depois usar diretamente:
whatsapp: {
  phone: window.WHATSAPP_PHONE,
  message: window.WHATSAPP_DEFAULT_MESSAGE
}
```

**Validação:**
- Hardcodes substituídos por variáveis globais
- Validação adicionada para garantir que variáveis existem
- Sintaxe JavaScript válida
- Nenhum hardcode restante relacionado a WhatsApp

**Risco:** 🟡 **MÉDIO** - Arquivo JavaScript crítico

**Tempo Estimado:** 0.6 horas (0.5h base + 0.1h buffer)

---

### FASE 6: Deploy Arquivos Modificados

**Objetivo:** Copiar arquivos modificados para o servidor DEV

**Tarefas:**
- [ ] Copiar `config.php` (se modificado)
- [ ] Verificar hash SHA256 de `config.php`
- [ ] Copiar `add_webflow_octa.php`
- [ ] Verificar hash SHA256 de `add_webflow_octa.php`
- [ ] Copiar `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Verificar hash SHA256 de `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] Verificar sintaxe PHP de todos os arquivos

**Comandos:**
```powershell
# Definir caminho do workspace
$workspacePath = "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
cd $workspacePath

# Copiar config.php (se modificado)
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

# Copiar add_webflow_octa.php
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\add_webflow_octa.php" root@65.108.156.14:/var/www/html/dev/root/

# Verificar hash SHA256
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\add_webflow_octa.php" -Algorithm SHA256).Hash.ToUpper()
$hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/add_webflow_octa.php | cut -d' ' -f1").ToUpper()
if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ add_webflow_octa.php: Hash coincide"
} else {
    Write-Host "❌ add_webflow_octa.php: Hash não coincide - tentar copiar novamente"
    exit 1
}

# Copiar MODAL_WHATSAPP_DEFINITIVO.js
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\MODAL_WHATSAPP_DEFINITIVO.js" root@65.108.156.14:/var/www/html/dev/root/

# Verificar hash SHA256
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\MODAL_WHATSAPP_DEFINITIVO.js" -Algorithm SHA256).Hash.ToUpper()
$hashServidor = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/MODAL_WHATSAPP_DEFINITIVO.js | cut -d' ' -f1").ToUpper()
if ($hashLocal -eq $hashServidor) {
    Write-Host "✅ MODAL_WHATSAPP_DEFINITIVO.js: Hash coincide"
} else {
    Write-Host "❌ MODAL_WHATSAPP_DEFINITIVO.js: Hash não coincide - tentar copiar novamente"
    exit 1
}

# Verificar sintaxe PHP
ssh root@65.108.156.14 "php -l /var/www/html/dev/root/config.php"
ssh root@65.108.156.14 "php -l /var/www/html/dev/root/add_webflow_octa.php"
```

**Validação:**
- Todos os arquivos copiados com sucesso
- Hash SHA256 de todos os arquivos coincide (case-insensitive)
- Sintaxe PHP válida em todos os arquivos

**Risco:** 🟡 **MÉDIO** - Modificações em arquivos críticos

**Tempo Estimado:** 1.2 horas (1h base + 0.2h buffer)

---

### FASE 7: Verificação de Integridade

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
// test_env_vars_octadesk.php
require_once __DIR__ . '/config.php';

echo "=== VERIFICAÇÃO DE VARIÁVEIS OCTADESK ===\n";

try {
    $octadeskApiKey = getOctaDeskApiKey();
    echo "✅ OCTADESK_API_KEY: " . substr($octadeskApiKey, 0, 20) . "...\n";
} catch (Exception $e) {
    echo "❌ OCTADESK_API_KEY: " . $e->getMessage() . "\n";
}

try {
    $octadeskApiBase = getOctaDeskApiBase();
    echo "✅ OCTADESK_API_BASE: $octadeskApiBase\n";
} catch (Exception $e) {
    echo "❌ OCTADESK_API_BASE: " . $e->getMessage() . "\n";
}

try {
    $octadeskFrom = getOctaDeskFrom();
    echo "✅ OCTADESK_FROM: $octadeskFrom\n";
} catch (Exception $e) {
    echo "❌ OCTADESK_FROM: " . $e->getMessage() . "\n";
}

echo "\n=== VERIFICAÇÃO DE VARIÁVEIS WHATSAPP (JavaScript) ===\n";
echo "⚠️ Variáveis JavaScript devem ser verificadas no navegador:\n";
echo "  - window.WHATSAPP_PHONE\n";
echo "  - window.WHATSAPP_DEFAULT_MESSAGE\n";
?>
```

**Validação:**
- Todas as variáveis obrigatórias estão definidas
- Funções helper funcionam corretamente
- Nenhum erro nos logs do PHP-FPM

**Risco:** 🟡 **MÉDIO** - Validação de configuração

**Tempo Estimado:** 0.6 horas (0.5h base + 0.1h buffer)

---

### FASE 8: Testes Funcionais

**Objetivo:** Testar que todas as funcionalidades continuam funcionando

**Tarefas:**

#### 8.1. Testes Funcionais Básicos
- [ ] Testar webhook OctaDesk (endpoint `add_webflow_octa.php`)
- [ ] Verificar que número `OCTADESK_FROM` está sendo usado corretamente
- [ ] Verificar que JavaScript carrega corretamente
- [ ] Verificar que variáveis JavaScript (`window.WHATSAPP_PHONE`, `window.WHATSAPP_DEFAULT_MESSAGE`) estão disponíveis
- [ ] Testar modal WhatsApp e verificar que usa variáveis globais

#### 8.2. Testes de Casos Extremos
- [ ] **Caso Extremo 1: Variável OCTADESK_FROM Ausente**
  - Remover temporariamente `env[OCTADESK_FROM]` do PHP-FPM config
  - Testar que exceção é lançada quando `getOctaDeskFrom()` é chamada
  - Verificar que erro é registrado nos logs
  - Restaurar variável após teste
- [ ] **Caso Extremo 2: Variáveis JavaScript Ausentes**
  - Testar que JavaScript lança erro quando `window.WHATSAPP_PHONE` não está presente
  - Testar que JavaScript lança erro quando `window.WHATSAPP_DEFAULT_MESSAGE` não está presente
  - Verificar que erros aparecem no console do browser
- [ ] **Caso Extremo 3: FooterCodeSiteDefinitivoCompleto.js Não Carregado**
  - Testar que `MODAL_WHATSAPP_DEFINITIVO.js` lança erro se executado antes do FooterCode
  - Verificar que erro é específico e informativo

#### 8.3. Testes de Validação
- [ ] Verificar logs do sistema para erros
- [ ] Verificar que nenhum erro crítico aparece nos logs
- [ ] Verificar que exceções são lançadas corretamente quando variáveis ausentes
- [ ] Validar que sistema funciona normalmente quando todas as variáveis estão definidas

**Comandos de Teste:**
```bash
# Testar endpoint OctaDesk (simulação)
curl -X POST https://dev.bssegurosimediato.com.br/add_webflow_octa.php \
  -H "Content-Type: application/json" \
  -H "Origin: https://segurosimediato-dev.webflow.io" \
  -d '{"name":"Teste","email":"teste@teste.com","ddd":"11","celular":"987654321"}'

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
  - Variáveis JavaScript ausentes → Erro no console ✅
  - FooterCode não carregado → Erro específico ✅

**Risco:** 🔴 **CRÍTICO** - Validação de funcionalidades

**Tempo Estimado:** 1.2 horas (1h base + 0.2h buffer)

---

### FASE 9: Documentação Final

**Objetivo:** Documentar o projeto realizado

**Tarefas:**
- [ ] Criar relatório de execução
- [ ] Documentar hash SHA256 de todos os arquivos deployados
- [ ] Documentar timestamp dos backups criados
- [ ] Documentar resultados dos testes
- [ ] Listar próximos passos (atualizar Webflow, limpar cache Cloudflare)
- [ ] Atualizar documento de tracking de alterações

**Arquivos a Criar:**
- `RELATORIO_ELIMINAR_ULTIMOS_HARDCODES_DEV_20251122.md`

**Validação:**
- Relatório completo criado
- Todas as informações documentadas
- Documento de tracking atualizado

**Risco:** 🟢 **BAIXO** - Apenas documentação

**Tempo Estimado:** 0.4 horas (0.3h base + 0.1h buffer)

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

2. **🔴 CRÍTICO: Variáveis JavaScript Ausentes**
   - **Risco:** Modal WhatsApp pode quebrar se variáveis não estiverem definidas
   - **Mitigação:**
     - Adicionar validação fail-fast no início do arquivo
     - Verificar ordem de carregamento dos scripts
     - Testar que erro é específico e informativo

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
- [ ] Variáveis de ambiente existentes verificadas

### Durante o Deploy:
- [ ] FASE 1: Preparação concluída
- [ ] FASE 2: Backups no servidor criados
- [ ] FASE 3: PHP-FPM config atualizado e recarregado
- [ ] FASE 4: Arquivos PHP modificados
- [ ] FASE 5: Arquivos JavaScript modificados
- [ ] FASE 6: Arquivos copiados e hash verificado
- [ ] FASE 7: Integridade verificada
- [ ] FASE 8: Testes funcionais realizados
- [ ] FASE 9: Documentação criada

### Após o Deploy:
- [ ] Cache Cloudflare limpo (avisar ao usuário)
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

1. **Monitoramento:**
   - Monitorar logs por 24h após deploy
   - Verificar erros relacionados a variáveis de ambiente
   - Validar que exceções são lançadas corretamente quando variáveis ausentes

2. **Validação Final:**
   - Testar todas as funcionalidades end-to-end
   - Validar que nenhum hardcode restante está sendo usado
   - Confirmar que sistema falha explicitamente quando configuração ausente

---

## 📊 ARQUIVOS PARA MODIFICAÇÃO

### Arquivos PHP (2 arquivos):
1. `config.php` - Adicionar função `getOctaDeskFrom()`
2. `add_webflow_octa.php` - Substituir hardcode por função helper

### Arquivos JavaScript (1 arquivo):
1. `MODAL_WHATSAPP_DEFINITIVO.js` - Substituir hardcodes por variáveis globais

### Arquivo de Configuração (1 arquivo):
1. `php-fpm_www_conf_DEV.txt` ou `/etc/php/8.3/fpm/pool.d/www.conf` - Adicionar `env[OCTADESK_FROM]`

**Total:** 4 arquivos

---

## 📝 HISTÓRICO DE VERSÕES

### Versão 1.0.0 (22/11/2025)
- ✅ Projeto inicial criado
- ✅ Fases detalhadas definidas
- ✅ Comandos de deploy documentados
- ✅ Riscos e mitigações identificados
- ✅ Checklist completo criado

---

**Projeto criado em:** 22/11/2025  
**Última atualização:** 22/11/2025 - Versão 1.0.0  
**Aguardando autorização para iniciar execução**

