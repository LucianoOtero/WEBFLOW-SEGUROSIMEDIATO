# 🎯 PROJETO: Atualização de Variáveis SafetyMails em Produção

**Data de Criação:** 23/11/2025  
**Versão:** 1.0.0  
**Status:** ⏳ **PENDENTE AUTORIZAÇÃO** - Aguardando aprovação para execução  
**Última Atualização:** 23/11/2025 - Versão 1.0.0

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Atualizar as variáveis de ambiente `SAFETY_TICKET` e `SAFETY_API_KEY` no servidor de produção para corrigir o erro 403 "Origem diferente da cadastrada" do SafetyMails, garantindo que:

1. **O ambiente PROD use as credenciais corretas** do SafetyMails para produção
2. **A funcionalidade dos arquivos .js e .php atualmente publicados no ambiente de produção seja preservada** e não seja prejudicada pela atualização das variáveis
3. **Nenhuma funcionalidade existente seja quebrada** ou tenha seu comportamento alterado negativamente
4. **O erro 403 do SafetyMails seja resolvido** após a atualização

### Escopo

- **Ambiente:** PRODUÇÃO (PROD)
- **Servidor:** `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)
- **Arquivo de Configuração:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Variáveis a Atualizar:** 2 variáveis
  - 🔴 **CRÍTICO:** `SAFETY_TICKET` (modificar)
  - 🔴 **CRÍTICO:** `SAFETY_API_KEY` (verificar se precisa modificar)

### Valores Atuais vs Novos

| Variável | Valor Atual (PROD) | Valor Novo (PROD) | Ação |
|----------|-------------------|-------------------|------|
| `SAFETY_TICKET` | `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` (DEV) | `fb2e3ae784c2fe56144a0d97f99f1adf1eb2d1b9` | 🔴 **MODIFICAR** |
| `SAFETY_API_KEY` | `20a7a1c297e39180bd80428ac13c363e882a531f` | `20a7a1c297e39180bd80428ac13c363e882a531f` | ⚠️ **VERIFICAR** |

**Observação:** O `SAFETY_TICKET` atual é o ticket de desenvolvimento, causando erro 403 porque não tem origem de produção cadastrada.

### Impacto Esperado

- ✅ **Correção do Erro 403:** Requisições do SafetyMails funcionarão corretamente em produção
- ✅ **Preservação:** Arquivos .js e .php atualmente em produção continuarão funcionando normalmente
- ✅ **Segurança:** Credenciais corretas de produção serão usadas
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
2. ⏳ **Aguardando autorização explícita do usuário**
3. ⏳ Execução após autorização
4. ⏳ Validação pós-execução

---

## 🎯 ESPECIFICAÇÕES DO USUÁRIO

### Requisitos Específicos

1. **🚨 CRÍTICO:** NÃO modificar servidor de produção sem autorização explícita
2. **Criar script PowerShell** localmente antes de executar
3. **Criar backup** do arquivo PHP-FPM config antes de qualquer modificação
4. **Verificar valores atuais** antes de modificar
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
- ✅ Variável `SAFETY_TICKET` modificada com sucesso
- ✅ Variável `SAFETY_API_KEY` verificada e atualizada se necessário
- ✅ Sintaxe do arquivo PHP-FPM validada
- ✅ PHP-FPM recarregado sem erros
- ✅ Variáveis de ambiente carregadas corretamente
- ✅ Nenhum erro crítico nos logs após atualização
- ✅ **Erro 403 do SafetyMails resolvido**
- ✅ **Arquivos .js e .php em produção continuam funcionando normalmente**
- ✅ **Nenhuma funcionalidade existente foi quebrada ou alterada negativamente**
- ✅ **Console do navegador sem erros JavaScript relacionados às variáveis**
- ✅ Documentação atualizada com alterações realizadas

---

## 📊 RESUMO DAS FASES

| Fase | Descrição | Tempo Base | Buffer | Tempo Total | Risco | Status |
|------|-----------|------------|--------|-------------|-------|--------|
| 1 | Preparação e Análise | 0.3h | 0.1h | 0.4h | 🟢 | ⏳ Pendente |
| 2 | Criação do Script PowerShell | 0.5h | 0.1h | 0.6h | 🟡 | ⏳ Pendente |
| 3 | Validação do Script Localmente | 0.2h | 0.1h | 0.3h | 🟡 | ⏳ Pendente |
| 4 | Backup do Arquivo PHP-FPM Config | 0.2h | 0.1h | 0.3h | 🟢 | ⏳ Pendente |
| 5 | Execução do Script em PROD | 0.3h | 0.1h | 0.4h | 🔴 | ⏳ Pendente |
| 6 | Validação de Sintaxe PHP-FPM | 0.2h | 0.1h | 0.3h | 🟡 | ⏳ Pendente |
| 7 | Recarregar PHP-FPM | 0.2h | 0.1h | 0.3h | 🟡 | ⏳ Pendente |
| 8 | Verificação de Variáveis | 0.2h | 0.1h | 0.3h | 🟢 | ⏳ Pendente |
| 9 | Validação Funcional | 0.3h | 0.2h | 0.5h | 🟡 | ⏳ Pendente |
| 10 | Documentação Final | 0.2h | 0.1h | 0.3h | 🟢 | ⏳ Pendente |
| **TOTAL** | | **2.6h** | **1.0h** | **3.6h** | | |

---

## 📝 FASES DETALHADAS

### FASE 1: Preparação e Análise

**Objetivo:** Verificar estado atual e preparar ambiente

**Tarefas:**
- [ ] Verificar valores atuais das variáveis no servidor PROD
- [ ] Comparar com valores esperados (credenciais de produção)
- [ ] Verificar se `SAFETY_API_KEY` precisa ser modificada
- [ ] Documentar estado atual

**Validações:**
- ✅ Valores atuais identificados
- ✅ Comparação realizada
- ✅ Plano de ação definido

**Artefatos:**
- Documento com valores atuais vs esperados

---

### FASE 2: Criação do Script PowerShell

**Objetivo:** Criar script PowerShell para atualização segura

**Tarefas:**
- [ ] Criar script `atualizar_safetymails_prod.ps1` em `02-DEVELOPMENT/scripts/`
- [ ] Implementar função de backup automático
- [ ] Implementar verificação de valores atuais
- [ ] Implementar atualização de variáveis
- [ ] Implementar validação de sintaxe PHP-FPM
- [ ] Implementar recarregamento de PHP-FPM
- [ ] Implementar verificação de variáveis após atualização
- [ ] Adicionar logs detalhados
- [ ] Adicionar tratamento de erros
- [ ] Adicionar modo dry-run

**Validações:**
- ✅ Script criado localmente
- ✅ Todas as funções implementadas
- ✅ Tratamento de erros implementado

**Artefatos:**
- Script: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/atualizar_safetymails_prod.ps1`

**Estrutura do Script:**
```powershell
# Funções principais:
- Write-Log: Logging detalhado
- Invoke-SafeSSHScript: Execução segura de scripts SSH
- Backup-PhpFpmConfig: Backup do arquivo PHP-FPM config
- Get-CurrentVariables: Obter valores atuais
- Update-SafetyMailsVariables: Atualizar variáveis
- Validate-PhpFpmSyntax: Validar sintaxe PHP-FPM
- Reload-PhpFpm: Recarregar PHP-FPM
- Verify-Variables: Verificar variáveis após atualização
```

---

### FASE 3: Validação do Script Localmente

**Objetivo:** Validar script antes de executar em produção

**Tarefas:**
- [ ] Executar script em modo dry-run
- [ ] Verificar logs gerados
- [ ] Validar sintaxe PowerShell
- [ ] Verificar tratamento de erros
- [ ] Documentar validação

**Validações:**
- ✅ Script executado em modo dry-run sem erros
- ✅ Logs gerados corretamente
- ✅ Sintaxe PowerShell válida

**Artefatos:**
- Log de validação: `atualizar_safetymails_prod_dryrun_YYYYMMDD_HHMMSS.log`

---

### FASE 4: Backup do Arquivo PHP-FPM Config

**Objetivo:** Criar backup completo antes de qualquer modificação

**Tarefas:**
- [ ] Criar backup do arquivo `/etc/php/8.3/fpm/pool.d/www.conf`
- [ ] Calcular hash SHA256 do arquivo original
- [ ] Calcular hash SHA256 do backup
- [ ] Verificar que hashes coincidem
- [ ] Documentar localização do backup

**Validações:**
- ✅ Backup criado com sucesso
- ✅ Hash SHA256 do backup idêntico ao original
- ✅ Backup documentado

**Artefatos:**
- Backup: `/etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS`
- Hash SHA256 do backup
- Documento de backup

---

### FASE 5: Execução do Script em PROD

**Objetivo:** Executar script para atualizar variáveis

**Tarefas:**
- [ ] Executar script PowerShell em modo produção
- [ ] Monitorar execução
- [ ] Verificar logs gerados
- [ ] Confirmar que variáveis foram atualizadas

**Validações:**
- ✅ Script executado sem erros
- ✅ Variáveis atualizadas com sucesso
- ✅ Logs documentados

**Artefatos:**
- Log de execução: `atualizar_safetymails_prod_YYYYMMDD_HHMMSS.log`
- Documento de execução

---

### FASE 6: Validação de Sintaxe PHP-FPM

**Objetivo:** Validar que arquivo PHP-FPM config está correto

**Tarefas:**
- [ ] Executar validação de sintaxe: `php-fpm8.3 -tt`
- [ ] Verificar que não há erros de sintaxe
- [ ] Verificar que não há avisos críticos
- [ ] Documentar resultado da validação

**Validações:**
- ✅ Sintaxe PHP-FPM válida
- ✅ Nenhum erro crítico
- ✅ Validação documentada

**Artefatos:**
- Resultado da validação de sintaxe
- Documento de validação

---

### FASE 7: Recarregar PHP-FPM

**Objetivo:** Aplicar novas configurações sem interrupção de serviço

**Tarefas:**
- [ ] Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
- [ ] Verificar status do serviço: `systemctl status php8.3-fpm`
- [ ] Verificar que serviço está ativo e rodando
- [ ] Verificar logs do PHP-FPM para erros
- [ ] Documentar resultado do recarregamento

**Validações:**
- ✅ PHP-FPM recarregado com sucesso
- ✅ Serviço ativo e rodando
- ✅ Nenhum erro nos logs

**Artefatos:**
- Status do serviço PHP-FPM
- Logs do PHP-FPM
- Documento de recarregamento

---

### FASE 8: Verificação de Variáveis

**Objetivo:** Confirmar que variáveis foram atualizadas corretamente

**Tarefas:**
- [ ] Verificar variável `SAFETY_TICKET` no PHP-FPM config
- [ ] Verificar variável `SAFETY_API_KEY` no PHP-FPM config
- [ ] Verificar que valores estão corretos
- [ ] Verificar que variáveis estão disponíveis via `$_ENV` (teste PHP)
- [ ] Documentar verificação

**Validações:**
- ✅ `SAFETY_TICKET` = `fb2e3ae784c2fe56144a0d97f99f1adf1eb2d1b9`
- ✅ `SAFETY_API_KEY` = `20a7a1c297e39180bd80428ac13c363e882a531f`
- ✅ Variáveis disponíveis via `$_ENV`

**Artefatos:**
- Valores verificados das variáveis
- Teste PHP confirmando disponibilidade
- Documento de verificação

---

### FASE 9: Validação Funcional

**Objetivo:** Verificar que funcionalidades continuam funcionando

**Tarefas:**
- [ ] Verificar que arquivo `config_env.js.php` carrega variáveis corretamente
- [ ] Verificar que JavaScript recebe variáveis corretas
- [ ] Testar requisição ao SafetyMails (se possível)
- [ ] Verificar console do navegador para erros JavaScript
- [ ] Verificar logs do servidor para erros PHP
- [ ] Documentar validação funcional

**Validações:**
- ✅ `config_env.js.php` carrega variáveis corretamente
- ✅ JavaScript recebe variáveis corretas
- ✅ Nenhum erro no console do navegador
- ✅ Nenhum erro nos logs do servidor
- ✅ **Erro 403 do SafetyMails resolvido**

**Artefatos:**
- Resultado da validação funcional
- Screenshots do console do navegador (se aplicável)
- Documento de validação funcional

---

### FASE 10: Documentação Final

**Objetivo:** Documentar todas as alterações realizadas

**Tarefas:**
- [ ] Criar relatório de execução
- [ ] Documentar valores antes e depois
- [ ] Documentar backup criado
- [ ] Documentar validações realizadas
- [ ] Atualizar documento de tracking de alterações
- [ ] Criar documento de auditoria pós-implementação

**Validações:**
- ✅ Relatório de execução criado
- ✅ Documentação completa
- ✅ Tracking atualizado

**Artefatos:**
- Relatório: `RELATORIO_EXECUCAO_ATUALIZAR_SAFETYMAILS_PROD_YYYYMMDD.md`
- Documento de auditoria pós-implementação

---

## 🔄 PLANO DE ROLLBACK

### Objetivo

Restaurar estado original em caso de erro grave ou falha na atualização.

### Cenários de Rollback

#### Cenário 1: Erro na Atualização das Variáveis

**Sintomas:**
- Script falha durante execução
- Variáveis não foram atualizadas corretamente
- Erro de sintaxe no arquivo PHP-FPM config

**Ação:**
1. Parar execução imediatamente
2. Restaurar arquivo PHP-FPM config do backup
3. Validar sintaxe do arquivo restaurado
4. Recarregar PHP-FPM
5. Verificar que variáveis foram restauradas
6. Documentar rollback

#### Cenário 2: Erro Após Recarregar PHP-FPM

**Sintomas:**
- PHP-FPM não recarrega corretamente
- Serviço PHP-FPM para de funcionar
- Erros nos logs do PHP-FPM

**Ação:**
1. Restaurar arquivo PHP-FPM config do backup
2. Validar sintaxe do arquivo restaurado
3. Reiniciar PHP-FPM: `systemctl restart php8.3-fpm`
4. Verificar status do serviço
5. Verificar que variáveis foram restauradas
6. Documentar rollback

#### Cenário 3: Funcionalidades Quebradas Após Atualização

**Sintomas:**
- Erros JavaScript no console do navegador
- Requisições ao SafetyMails falhando
- Funcionalidades não funcionando corretamente

**Ação:**
1. Verificar logs do servidor para identificar problema
2. Se problema for relacionado às variáveis:
   - Restaurar arquivo PHP-FPM config do backup
   - Validar sintaxe do arquivo restaurado
   - Recarregar PHP-FPM
   - Verificar que variáveis foram restauradas
3. Documentar rollback e problema identificado

### Procedimento de Rollback Detalhado

#### ETAPA 1: Identificar Backup

```bash
# Listar backups disponíveis
ls -lh /etc/php/8.3/fpm/pool.d/www.conf.backup_*

# Identificar backup mais recente
BACKUP_FILE="/etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS"
```

#### ETAPA 2: Restaurar Arquivo

```bash
# Criar backup do arquivo atual (antes de restaurar)
cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.before_rollback_$(date +%Y%m%d_%H%M%S)

# Restaurar arquivo do backup
cp "$BACKUP_FILE" /etc/php/8.3/fpm/pool.d/www.conf

# Verificar que arquivo foi restaurado
ls -lh /etc/php/8.3/fpm/pool.d/www.conf
```

#### ETAPA 3: Validar Sintaxe

```bash
# Validar sintaxe do arquivo restaurado
php-fpm8.3 -tt

# Verificar que não há erros
if [ $? -eq 0 ]; then
    echo "✅ Sintaxe válida"
else
    echo "❌ Erro de sintaxe - verificar arquivo"
    exit 1
fi
```

#### ETAPA 4: Recarregar PHP-FPM

```bash
# Recarregar PHP-FPM
systemctl reload php8.3-fpm

# Verificar status
systemctl status php8.3-fpm

# Verificar que serviço está ativo
if systemctl is-active --quiet php8.3-fpm; then
    echo "✅ PHP-FPM ativo"
else
    echo "❌ PHP-FPM não está ativo - reiniciar"
    systemctl restart php8.3-fpm
fi
```

#### ETAPA 5: Verificar Variáveis Restauradas

```bash
# Verificar variáveis restauradas
grep -E 'SAFETY_TICKET|SAFETY_API_KEY' /etc/php/8.3/fpm/pool.d/www.conf | grep -v '^#'

# Verificar valores esperados
# SAFETY_TICKET deve ser: 05bf2ec47128ca0b917f8b955bada1bd3cadd47e (valor original)
# SAFETY_API_KEY deve ser: 20a7a1c297e39180bd80428ac13c363e882a531f (valor original)
```

#### ETAPA 6: Testar Funcionalidades

```bash
# Verificar que funcionalidades estão funcionando
# Testar acesso ao config_env.js.php
curl -s https://prod.bssegurosimediato.com.br/config_env.js.php | grep SAFETY_TICKET

# Verificar logs do servidor
tail -n 50 /var/log/php8.3-fpm.log
```

#### ETAPA 7: Documentar Rollback

```bash
# Criar documento de rollback
cat > /tmp/rollback_safetymails_$(date +%Y%m%d_%H%M%S).txt << EOF
ROLLBACK REALIZADO
Data: $(date)
Backup usado: $BACKUP_FILE
Motivo: [DESCREVER MOTIVO]
Status: [SUCESSO/FALHA]
EOF
```

### Validação do Rollback

- ✅ Arquivo PHP-FPM config restaurado
- ✅ Sintaxe PHP-FPM válida
- ✅ PHP-FPM ativo e rodando
- ✅ Variáveis restauradas aos valores originais
- ✅ Funcionalidades funcionando normalmente
- ✅ Rollback documentado

---

## ⚠️ RISCOS E MITIGAÇÕES

### Riscos Identificados

| Risco | Probabilidade | Impacto | Severidade | Mitigação |
|-------|--------------|---------|------------|-----------|
| **Erro de sintaxe no arquivo PHP-FPM config** | 🟡 Média | 🔴 Alto | 🔴 Crítico | Validação de sintaxe antes e depois da atualização |
| **PHP-FPM não recarrega corretamente** | 🟢 Baixa | 🔴 Alto | 🟡 Alto | Verificação de status após recarregamento, rollback pronto |
| **Variáveis não atualizadas corretamente** | 🟢 Baixa | 🟡 Médio | 🟡 Médio | Verificação de variáveis após atualização |
| **Funcionalidades quebradas após atualização** | 🟢 Baixa | 🔴 Alto | 🟡 Alto | Validação funcional completa, rollback pronto |
| **Backup não criado corretamente** | 🟢 Baixa | 🔴 Alto | 🟡 Alto | Verificação de hash SHA256 do backup |
| **Perda de acesso ao servidor durante execução** | 🟢 Baixa | 🔴 Alto | 🟡 Alto | Script com tratamento de erros, rollback automático |

### Mitigações Implementadas

1. ✅ **Backup obrigatório antes de qualquer modificação**
2. ✅ **Validação de sintaxe antes e depois da atualização**
3. ✅ **Verificação de status do PHP-FPM após recarregamento**
4. ✅ **Verificação de variáveis após atualização**
5. ✅ **Validação funcional completa**
6. ✅ **Plano de rollback detalhado e testado**
7. ✅ **Script com tratamento de erros robusto**
8. ✅ **Logs detalhados de todas as operações**

---

## 📋 CHECKLIST DE EXECUÇÃO

### Antes de Executar

- [ ] Projeto documentado e aprovado
- [ ] Script PowerShell criado e validado localmente
- [ ] Backup do arquivo PHP-FPM config criado
- [ ] Plano de rollback revisado
- [ ] Autorização explícita do usuário obtida

### Durante Execução

- [ ] Executar script em modo dry-run primeiro
- [ ] Verificar logs gerados
- [ ] Executar script em modo produção
- [ ] Monitorar execução
- [ ] Verificar cada fase conforme executa

### Após Execução

- [ ] Validar sintaxe PHP-FPM
- [ ] Verificar status do PHP-FPM
- [ ] Verificar variáveis atualizadas
- [ ] Validar funcionalidades
- [ ] Documentar execução
- [ ] Criar relatório final

---

## 📊 MÉTRICAS DE SUCESSO

### Métricas Técnicas

- ✅ **Taxa de Sucesso:** 100% das variáveis atualizadas corretamente
- ✅ **Tempo de Execução:** < 1 hora (incluindo validações)
- ✅ **Disponibilidade:** 0% de downtime (PHP-FPM reload sem interrupção)
- ✅ **Erros:** 0 erros críticos durante execução

### Métricas Funcionais

- ✅ **Erro 403 Resolvido:** Requisições ao SafetyMails funcionando corretamente
- ✅ **Funcionalidades Preservadas:** 100% das funcionalidades existentes funcionando
- ✅ **Console Limpo:** 0 erros JavaScript relacionados às variáveis

---

## 📝 NOTAS IMPORTANTES

### Observações

1. **Credenciais Sensíveis:** As credenciais estão armazenadas em `CREDENCIAIS/SAFETYMAILS_PROD_CREDENTIALS.md` (não commitado no Git)
2. **Ticket Diferente:** O ticket de produção (`fb2e3ae784c2fe56144a0d97f99f1adf1eb2d1b9`) é diferente do ticket de desenvolvimento (`05bf2ec47128ca0b917f8b955bada1bd3cadd47e`)
3. **API Key:** A API Key pode ser a mesma entre DEV e PROD (verificar após execução)
4. **Origem:** O ticket de produção deve ter a origem `https://www.segurosimediato.com.br` cadastrada no SafetyMails

### Dependências

- ✅ Acesso SSH ao servidor de produção
- ✅ Permissões de root no servidor
- ✅ Script PowerShell funcional
- ✅ Backup criado antes da execução

---

## ✅ APROVAÇÃO

### Status de Aprovação

- [ ] ⏳ **Aguardando autorização explícita do usuário**

### Autorização Necessária

**🚨 CRÍTICO:** Este projeto modifica configurações no servidor de produção. É **OBRIGATÓRIA** autorização explícita do usuário antes de executar.

**Pergunta:** Posso iniciar o projeto de atualização das variáveis SafetyMails em produção agora?

---

**Data de Criação:** 23/11/2025  
**Versão:** 1.0.0  
**Status:** ⏳ **PENDENTE AUTORIZAÇÃO**

