# 🎯 PROJETO: Deploy de Desenvolvimento para Produção

**Data de Criação:** 23/11/2025  
**Versão:** 1.1.0  
**Status:** ⏳ **PENDENTE AUTORIZAÇÃO** - Aguardando aprovação para execução  
**Última Atualização:** 23/11/2025 - Versão 1.1.0 (Atualizado: Script de variáveis não precisa ser executado)

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Realizar deploy completo e seguro de todos os arquivos `.js` e `.php` do ambiente de desenvolvimento para produção, garantindo:

1. **Cópia segura** de todos os arquivos para diretório PROD local (Windows) antes do deploy
2. **Backup completo** de todos os arquivos originais em produção antes de qualquer modificação
3. **Estratégia de rollback robusta** para restaurar estado original em caso de erro grave
4. **Validação completa** de integridade e funcionamento após deploy
5. **Preservação** de funcionalidades existentes em produção

### Escopo

- **Ambiente Origem:** DESENVOLVIMENTO (DEV)
  - **Diretório Local:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`
  - **Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
  - **Caminho Servidor:** `/var/www/html/dev/root/`

- **Ambiente Destino:** PRODUÇÃO (PROD)
  - **Diretório Local:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/`
  - **Servidor:** `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)
  - **Caminho Servidor:** `/var/www/html/prod/root/`

- **Arquivos a Deployar:**
  - **JavaScript:** 3 arquivos principais
  - **PHP:** 9 arquivos principais
  - **Scripts:** Scripts PowerShell que funcionaram (atualizar variáveis) - ⚠️ **NÃO NECESSÁRIO** (variáveis já estão corretas)

- **Total de Arquivos:** ~12 arquivos principais + scripts auxiliares (scripts de variáveis não precisam ser executados)

### Impacto Esperado

- ✅ **Sincronização:** Ambiente PROD alinhado com DEV
- ✅ **Funcionalidade:** Todas as funcionalidades funcionando corretamente em PROD
- ✅ **Segurança:** Backups completos antes de qualquer modificação
- ✅ **Confiabilidade:** Estratégia de rollback testada e pronta
- ✅ **Rastreabilidade:** Log completo de todas as operações

---

## 👥 STAKEHOLDERS

### Identificação de Stakeholders

| Stakeholder | Papel | Responsabilidade | Aprovação Necessária |
|-------------|-------|-----------------|---------------------|
| **Usuário/Autorizador** | Aprovador Final | Autorizar execução em produção | ✅ Sim (obrigatória) |
| **Executor do Script** | Executor Técnico | Executar scripts PowerShell e validar resultados | ✅ Sim (execução) |
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
2. **Copiar arquivos** de DEV local para PROD local (Windows) primeiro
3. **Incluir scripts** que funcionaram (atualizar_variaveis_ambiente_prod.ps1) - ⚠️ **NÃO EXECUTAR** (variáveis já estão corretas)
4. **Criar backup completo** de todos os arquivos originais em PROD antes de deploy
5. **Estratégia de rollback** que restaure arquivos originais em caso de erro grave
6. **Validar integridade** de todos os arquivos após cópia (hash SHA256)
7. **Validar funcionamento** após deploy
8. **🚨 CRÍTICO:** Garantir que nenhuma funcionalidade existente seja quebrada
9. **Documentar** todas as alterações realizadas
10. **Ter plano de rollback** pronto antes de executar

### Critérios de Aceitação

- ✅ Todos os arquivos copiados para PROD local (Windows)
- ✅ Scripts funcionais incluídos em PROD local (para referência/documentação)
- ✅ Backup completo de todos os arquivos originais em PROD criado
- ✅ Hash SHA256 de todos os backups calculado e documentado
- ✅ Todos os arquivos deployados para servidor PROD com sucesso
- ✅ Hash SHA256 de todos os arquivos deployados validado
- ✅ Sintaxe PHP validada após deploy
- ✅ Funcionalidades testadas e funcionando corretamente
- ✅ Nenhum erro crítico nos logs após deploy
- ✅ Estratégia de rollback testada e documentada
- ✅ Documentação atualizada com alterações realizadas

---

## 📊 ARQUIVOS A DEPLOYAR

### Arquivos JavaScript (3 arquivos)

| # | Arquivo | Descrição | Prioridade | Status |
|---|---------|-----------|------------|--------|
| 1 | `FooterCodeSiteDefinitivoCompleto.js` | Script principal de inicialização e carregamento | 🔴 CRÍTICO | ⏳ Pendente |
| 2 | `MODAL_WHATSAPP_DEFINITIVO.js` | Modal WhatsApp com integração | 🔴 CRÍTICO | ⏳ Pendente |
| 3 | `webflow_injection_limpo.js` | Injeção Webflow completa | 🟡 ALTO | ⏳ Pendente |

### Arquivos PHP (9 arquivos)

| # | Arquivo | Descrição | Prioridade | Status |
|---|---------|-----------|------------|--------|
| 1 | `config.php` | Configuração central da aplicação | 🔴 CRÍTICO | ⏳ Pendente |
| 2 | `config_env.js.php` | Expõe variáveis de ambiente para JS | 🔴 CRÍTICO | ⏳ Pendente |
| 3 | `add_webflow_octa.php` | Endpoint para adicionar leads OctaDesk | 🔴 CRÍTICO | ⏳ Pendente |
| 4 | `add_flyingdonkeys.php` | Endpoint para adicionar leads FlyingDonkeys | 🔴 CRÍTICO | ⏳ Pendente |
| 5 | `cpf-validate.php` | Validação de CPF/CNPJ | 🟡 ALTO | ⏳ Pendente |
| 6 | `placa-validate.php` | Validação de placa de veículo | 🟡 ALTO | ⏳ Pendente |
| 7 | `log_endpoint.php` | Endpoint de logging | 🟡 ALTO | ⏳ Pendente |
| 8 | `ProfessionalLogger.php` | Classe de logging profissional | 🟡 ALTO | ⏳ Pendente |
| 9 | `aws_ses_config.php` | Configuração AWS SES | 🔴 CRÍTICO | ⏳ Pendente |

### Scripts PowerShell (1 script)

| # | Arquivo | Descrição | Status | Observação |
|---|---------|-----------|--------|------------|
| 1 | `atualizar_variaveis_ambiente_prod.ps1` | Script que atualizou variáveis de ambiente com sucesso | ✅ Funcional | ⚠️ **NÃO PRECISA SER EXECUTADO** - Todas as variáveis já estão corretas em PROD (verificado em 23/11/2025) |

**Total:** 12 arquivos principais + 1 script (script não precisa ser executado)

**⚠️ IMPORTANTE:** O script `atualizar_variaveis_ambiente_prod.ps1` **NÃO precisa ser executado** porque todas as 21 variáveis de ambiente já estão presentes e corretas em produção. Verificação completa realizada em 23/11/2025 - ver documento `VERIFICACAO_SCRIPT_VS_PROD_20251123.md`.

---

## 📊 RESUMO DAS FASES

| Fase | Descrição | Tempo Base | Buffer | Tempo Total | Risco | Status |
|------|-----------|------------|--------|-------------|-------|--------|
| 1 | Preparação e Análise | 0.5h | 0.1h | 0.6h | 🟢 | ⏳ Pendente |
| 2 | Cópia para PROD Local (Windows) | 0.5h | 0.1h | 0.6h | 🟢 | ⏳ Pendente |
| 3 | Backup Completo em PROD | 1h | 0.2h | 1.2h | 🟡 | ⏳ Pendente |
| 4 | Validação de Arquivos Locais | 0.5h | 0.1h | 0.6h | 🟡 | ⏳ Pendente |
| 5 | Deploy para Servidor PROD | 1h | 0.3h | 1.3h | 🔴 | ⏳ Pendente |
| 6 | Validação de Integridade | 0.5h | 0.1h | 0.6h | 🟡 | ⏳ Pendente |
| 7 | Validação de Funcionamento | 1h | 0.3h | 1.3h | 🔴 | ⏳ Pendente |
| 8 | Documentação Final | 0.5h | 0.1h | 0.6h | 🟢 | ⏳ Pendente |

**Tempo Total Estimado:** 5.5h base + 1.3h buffer = **6.8h**

---

## 🔄 FASES DETALHADAS

### FASE 1: Preparação e Análise

**Objetivo:** Preparar ambiente e analisar arquivos a serem deployados

**Tarefas:**
- [ ] Verificar acesso SSH aos servidores DEV e PROD
- [ ] Listar todos os arquivos `.js` e `.php` em DEV local
- [ ] Verificar integridade dos arquivos em DEV local (hash SHA256)
- [ ] Comparar arquivos DEV local vs DEV servidor (verificar sincronização)
- [ ] Identificar diferenças entre DEV e PROD atual
- [ ] Criar lista completa de arquivos a deployar
- [ ] Verificar espaço em disco no servidor PROD
- [ ] Verificar permissões de escrita no servidor PROD

**Validações:**
- ✅ Acesso SSH funcionando
- ✅ Todos os arquivos identificados
- ✅ Integridade dos arquivos verificada
- ✅ Espaço em disco suficiente

**Artefatos:**
- Lista de arquivos a deployar
- Hash SHA256 de todos os arquivos em DEV local
- Comparação DEV local vs DEV servidor

---

### FASE 2: Cópia para PROD Local (Windows)

**Objetivo:** Copiar todos os arquivos de DEV local para PROD local (Windows)

**Tarefas:**
- [ ] Criar diretório PROD local se não existir: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/`
- [ ] Copiar arquivos JavaScript (3 arquivos)
  - [ ] `FooterCodeSiteDefinitivoCompleto.js`
  - [ ] `MODAL_WHATSAPP_DEFINITIVO.js`
  - [ ] `webflow_injection_limpo.js`
- [ ] Copiar arquivos PHP (9 arquivos)
  - [ ] `config.php`
  - [ ] `config_env.js.php`
  - [ ] `add_webflow_octa.php`
  - [ ] `add_flyingdonkeys.php`
  - [ ] `cpf-validate.php`
  - [ ] `placa-validate.php`
  - [ ] `log_endpoint.php`
  - [ ] `ProfessionalLogger.php`
  - [ ] `aws_ses_config.php`
- [ ] Copiar scripts PowerShell funcionais (para referência/documentação)
  - [ ] `atualizar_variaveis_ambiente_prod.ps1` (⚠️ **NÃO PRECISA SER EXECUTADO** - variáveis já estão corretas)
- [ ] Criar diretório de backups local: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/backups/`
- [ ] Calcular hash SHA256 de todos os arquivos copiados
- [ ] Documentar hash SHA256 de todos os arquivos

**Validações:**
- ✅ Todos os arquivos copiados com sucesso
- ✅ Hash SHA256 dos arquivos copiados idêntico aos originais
- ✅ Estrutura de diretórios criada corretamente

**Artefatos:**
- Arquivos em `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/`
- Lista de hash SHA256 dos arquivos copiados
- Script PowerShell de cópia executado

---

### FASE 3: Backup Completo em PROD

**Objetivo:** Criar backup completo de todos os arquivos originais em produção antes do deploy

**Tarefas:**
- [ ] Criar script PowerShell para backup completo
- [ ] Conectar ao servidor PROD via SSH
- [ ] Criar diretório de backup no servidor: `/var/www/html/prod/root/backups/deploy_YYYYMMDD_HHMMSS/`
- [ ] Fazer backup de todos os arquivos JavaScript (3 arquivos)
  - [ ] `FooterCodeSiteDefinitivoCompleto.js`
  - [ ] `MODAL_WHATSAPP_DEFINITIVO.js`
  - [ ] `webflow_injection_limpo.js`
- [ ] Fazer backup de todos os arquivos PHP (9 arquivos)
  - [ ] `config.php`
  - [ ] `config_env.js.php`
  - [ ] `add_webflow_octa.php`
  - [ ] `add_flyingdonkeys.php`
  - [ ] `cpf-validate.php`
  - [ ] `placa-validate.php`
  - [ ] `log_endpoint.php`
  - [ ] `ProfessionalLogger.php`
  - [ ] `aws_ses_config.php`
- [ ] Calcular hash SHA256 de todos os arquivos originais
- [ ] Calcular hash SHA256 de todos os backups criados
- [ ] Verificar que hash dos backups é idêntico aos originais
- [ ] Documentar localização de todos os backups
- [ ] Criar arquivo de índice de backups: `backup_index.txt`

**Validações:**
- ✅ Todos os arquivos originais foram copiados para backup
- ✅ Hash SHA256 dos backups idêntico aos originais
- ✅ Diretório de backup criado com sucesso
- ✅ Arquivo de índice criado

**Artefatos:**
- Diretório de backup no servidor: `/var/www/html/prod/root/backups/deploy_YYYYMMDD_HHMMSS/`
- Hash SHA256 de todos os arquivos originais
- Hash SHA256 de todos os backups
- Arquivo `backup_index.txt` com mapeamento completo

**Script de Backup:**
```powershell
# Script será criado na FASE 3
# Criará backup completo com hash SHA256 de todos os arquivos
```

---

### FASE 4: Validação de Arquivos Locais

**Objetivo:** Validar integridade e sintaxe dos arquivos antes do deploy

**Tarefas:**
- [ ] Validar sintaxe PHP de todos os arquivos PHP locais
  - [ ] Executar `php -l` em cada arquivo PHP
  - [ ] Verificar que nenhum erro de sintaxe foi encontrado
- [ ] Validar sintaxe JavaScript (se ESLint disponível)
  - [ ] Executar ESLint nos arquivos JavaScript
  - [ ] Verificar que nenhum erro crítico foi encontrado
- [ ] Verificar dependências entre arquivos
  - [ ] Verificar que `config.php` está sendo incluído corretamente
  - [ ] Verificar que variáveis de ambiente estão sendo usadas corretamente
- [ ] Comparar hash SHA256 dos arquivos PROD local vs DEV local
  - [ ] Verificar que arquivos são idênticos
- [ ] Verificar que arquivos não contêm referências hardcoded a DEV
  - [ ] Buscar por `dev.bssegurosimediato.com.br` nos arquivos
  - [ ] Buscar por `65.108.156.14` nos arquivos
  - [ ] Verificar que todas as URLs usam variáveis de ambiente

**Validações:**
- ✅ Sintaxe PHP válida em todos os arquivos
- ✅ Sintaxe JavaScript válida (ou sem erros críticos)
- ✅ Dependências verificadas
- ✅ Arquivos idênticos entre DEV e PROD local
- ✅ Nenhuma referência hardcoded a DEV encontrada

**Artefatos:**
- Relatório de validação de sintaxe
- Relatório de verificação de dependências
- Relatório de comparação de hash SHA256

---

### FASE 5: Deploy para Servidor PROD

**Objetivo:** Copiar todos os arquivos do PROD local para servidor PROD

**Tarefas:**
- [ ] Criar script PowerShell para deploy completo
- [ ] Conectar ao servidor PROD via SSH
- [ ] Para cada arquivo JavaScript (3 arquivos):
  - [ ] Copiar arquivo via SCP
  - [ ] Calcular hash SHA256 do arquivo no servidor
  - [ ] Comparar hash com arquivo local (devem ser idênticos)
  - [ ] Verificar permissões do arquivo (644 para arquivos, 755 para diretórios)
- [ ] Para cada arquivo PHP (9 arquivos):
  - [ ] Copiar arquivo via SCP
  - [ ] Calcular hash SHA256 do arquivo no servidor
  - [ ] Comparar hash com arquivo local (devem ser idênticos)
  - [ ] Verificar permissões do arquivo (644 para arquivos)
- [ ] Verificar que todos os arquivos foram copiados com sucesso
- [ ] Documentar hash SHA256 de todos os arquivos deployados

**Validações:**
- ✅ Todos os arquivos copiados com sucesso
- ✅ Hash SHA256 de todos os arquivos no servidor idêntico aos locais
- ✅ Permissões corretas em todos os arquivos
- ✅ Nenhum erro durante cópia

**Artefatos:**
- Arquivos deployados no servidor PROD
- Hash SHA256 de todos os arquivos deployados
- Log completo do processo de deploy

**Script de Deploy:**
```powershell
# Script será criado na FASE 5
# Copiará todos os arquivos com validação de hash SHA256
```

---

### FASE 6: Validação de Integridade

**Objetivo:** Validar integridade e sintaxe dos arquivos após deploy

**Tarefas:**
- [ ] Validar sintaxe PHP de todos os arquivos PHP no servidor PROD
  - [ ] Executar `php -l` em cada arquivo PHP via SSH
  - [ ] Verificar que nenhum erro de sintaxe foi encontrado
- [ ] Verificar que variáveis de ambiente estão disponíveis
  - [ ] Criar script PHP temporário para verificar variáveis
  - [ ] Executar script e verificar que todas as variáveis necessárias estão presentes
- [ ] Verificar integridade dos arquivos JavaScript
  - [ ] Verificar que arquivos JavaScript estão acessíveis via HTTP
  - [ ] Verificar que arquivos não estão corrompidos
- [ ] Comparar hash SHA256 final dos arquivos no servidor com arquivos locais
  - [ ] Verificar que todos os hashes coincidem

**Validações:**
- ✅ Sintaxe PHP válida em todos os arquivos
- ✅ Todas as variáveis de ambiente disponíveis
- ✅ Arquivos JavaScript acessíveis e íntegros
- ✅ Hash SHA256 de todos os arquivos validado

**Artefatos:**
- Relatório de validação de sintaxe PHP
- Relatório de verificação de variáveis de ambiente
- Relatório de validação de integridade

---

### FASE 7: Validação de Funcionamento

**Objetivo:** Testar funcionalidades críticas após deploy

**Tarefas:**
- [ ] Testar carregamento de arquivos JavaScript
  - [ ] Acessar `https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js`
  - [ ] Verificar que arquivo carrega sem erros
  - [ ] Verificar console do navegador para erros JavaScript
- [ ] Testar endpoints PHP críticos
  - [ ] Testar `config_env.js.php` (deve retornar JavaScript válido)
  - [ ] Testar `cpf-validate.php` (endpoint de validação)
  - [ ] Testar `placa-validate.php` (endpoint de validação)
- [ ] Verificar logs do servidor
  - [ ] Verificar logs do PHP-FPM para erros críticos
  - [ ] Verificar logs do Nginx para erros
- [ ] Testar funcionalidades principais
  - [ ] Testar formulário de cotação (se aplicável)
  - [ ] Testar integração com APIs externas
  - [ ] Verificar que variáveis de ambiente estão sendo usadas corretamente

**Validações:**
- ✅ Arquivos JavaScript carregam sem erros
- ✅ Endpoints PHP funcionam corretamente
- ✅ Nenhum erro crítico nos logs
- ✅ Funcionalidades principais funcionando

**Artefatos:**
- Relatório de testes funcionais
- Screenshots de testes (se aplicável)
- Logs do servidor verificados

---

### FASE 8: Documentação Final

**Objetivo:** Documentar todas as alterações realizadas

**Tarefas:**
- [ ] Criar relatório completo de execução
- [ ] Documentar todos os arquivos deployados
- [ ] Documentar hash SHA256 de todos os arquivos (antes e depois)
- [ ] Documentar localização de todos os backups
- [ ] Atualizar documento de tracking de alterações
- [ ] Criar documento de rollback com instruções detalhadas
- [ ] Atualizar histórico de deploys

**Artefatos:**
- `RELATORIO_DEPLOY_DEV_PARA_PROD_YYYYMMDD.md`
- `BACKUP_INDEX_DEPLOY_YYYYMMDD.txt`
- `ROLLBACK_INSTRUCTIONS_DEPLOY_YYYYMMDD.md`
- Atualização de `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`

---

## 🔄 PLANO DE ROLLBACK

### Estratégia de Rollback

**Objetivo:** Restaurar estado original de produção em caso de erro grave

### Cenários de Rollback

#### Cenário 1: Erro durante Deploy (antes de completar)

**Condição:** Erro durante cópia de arquivos para servidor PROD

**Ação:**
1. Parar processo de deploy imediatamente
2. Verificar quais arquivos foram modificados
3. Restaurar apenas arquivos modificados do backup
4. Validar hash SHA256 dos arquivos restaurados
5. Verificar funcionamento após restauração

#### Cenário 2: Erro após Deploy (validação de integridade falhou)

**Condição:** Sintaxe PHP inválida ou arquivos corrompidos após deploy

**Ação:**
1. Identificar arquivos com problemas
2. Restaurar arquivos problemáticos do backup
3. Validar hash SHA256 dos arquivos restaurados
4. Validar sintaxe PHP após restauração
5. Verificar funcionamento após restauração

#### Cenário 3: Erro Funcional (funcionalidades quebradas)

**Condição:** Funcionalidades não funcionam após deploy

**Ação:**
1. Identificar funcionalidades afetadas
2. Analisar logs do servidor para identificar causa
3. Decidir se rollback completo ou parcial
4. Restaurar arquivos necessários do backup
5. Validar funcionamento após restauração
6. Documentar causa raiz do problema

#### Cenário 4: Rollback Completo

**Condição:** Múltiplos problemas ou erro crítico não identificado

**Ação:**
1. Restaurar TODOS os arquivos do backup
2. Validar hash SHA256 de todos os arquivos restaurados
3. Validar sintaxe PHP de todos os arquivos
4. Testar funcionalidades principais
5. Verificar logs do servidor
6. Documentar rollback completo

### Processo de Rollback Detalhado

#### Passo 1: Identificar Arquivos a Restaurar

```powershell
# Listar arquivos no backup
ssh root@157.180.36.223 "ls -la /var/www/html/prod/root/backups/deploy_YYYYMMDD_HHMMSS/"
```

#### Passo 2: Restaurar Arquivos

```powershell
# Para cada arquivo a restaurar:
ssh root@157.180.36.223 "cp /var/www/html/prod/root/backups/deploy_YYYYMMDD_HHMMSS/arquivo.php /var/www/html/prod/root/arquivo.php"
```

#### Passo 3: Validar Hash SHA256

```powershell
# Calcular hash do arquivo restaurado
ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/arquivo.php"

# Comparar com hash do backup (devem ser idênticos)
```

#### Passo 4: Validar Sintaxe PHP

```powershell
# Validar sintaxe de cada arquivo PHP restaurado
ssh root@157.180.36.223 "php -l /var/www/html/prod/root/arquivo.php"
```

#### Passo 5: Verificar Funcionamento

```powershell
# Testar endpoints críticos
# Verificar logs do servidor
# Testar funcionalidades principais
```

### Script de Rollback

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/rollback_deploy_prod.ps1`

**Funcionalidades:**
- Listar backups disponíveis
- Restaurar arquivos específicos ou todos
- Validar hash SHA256 após restauração
- Validar sintaxe PHP após restauração
- Gerar relatório de rollback

### Tempo Estimado de Rollback

- **Rollback Parcial (1-3 arquivos):** 10-15 minutos
- **Rollback Completo (todos os arquivos):** 20-30 minutos

---

## ⚠️ RISCOS E MITIGAÇÕES

### Riscos Identificados

| # | Risco | Severidade | Probabilidade | Mitigação |
|---|-------|------------|---------------|-----------|
| 1 | Arquivo corrompido durante cópia | 🔴 ALTA | 🟡 MÉDIA | Validação de hash SHA256 após cada cópia |
| 2 | Sintaxe PHP inválida após deploy | 🔴 ALTA | 🟡 MÉDIA | Validação de sintaxe antes e depois do deploy |
| 3 | Variáveis de ambiente não disponíveis | 🔴 ALTA | 🟢 BAIXA | Verificação de variáveis antes do deploy |
| 4 | Funcionalidades quebradas após deploy | 🔴 ALTA | 🟡 MÉDIA | Testes funcionais completos após deploy |
| 5 | Backup não criado corretamente | 🔴 CRÍTICA | 🟢 BAIXA | Validação de hash SHA256 dos backups |
| 6 | Rollback não funciona | 🔴 CRÍTICA | 🟢 BAIXA | Teste de rollback antes do deploy |
| 7 | Perda de dados durante deploy | 🔴 CRÍTICA | 🟢 BAIXA | Backup completo antes de qualquer modificação |
| 8 | Arquivos não copiados corretamente | 🟡 MÉDIA | 🟡 MÉDIA | Validação de hash SHA256 após cada cópia |
| 9 | Permissões incorretas após deploy | 🟡 MÉDIA | 🟢 BAIXA | Verificação de permissões após deploy |
| 10 | Espaço em disco insuficiente | 🟡 MÉDIA | 🟢 BAIXA | Verificação de espaço antes do deploy |

---

## 📋 CHECKLIST DE EXECUÇÃO

### Pré-Deploy

- [ ] Projeto aprovado pelo usuário
- [ ] Acesso SSH aos servidores DEV e PROD verificado
- [ ] Espaço em disco no servidor PROD verificado
- [ ] Todos os arquivos identificados e listados
- [ ] Scripts PowerShell criados e testados

### Durante Deploy

- [ ] Arquivos copiados para PROD local (Windows)
- [ ] Backup completo criado no servidor PROD
- [ ] Hash SHA256 dos backups validado
- [ ] Arquivos deployados para servidor PROD
- [ ] Hash SHA256 dos arquivos deployados validado
- [ ] Sintaxe PHP validada após deploy
- [ ] Variáveis de ambiente verificadas
- [ ] Funcionalidades testadas

### Pós-Deploy

- [ ] Relatório de execução criado
- [ ] Documentação atualizada
- [ ] Rollback testado e documentado
- [ ] Logs do servidor verificados
- [ ] Nenhum erro crítico identificado

---

## 📝 DOCUMENTAÇÃO RELACIONADA

- **Projeto de Variáveis:** `PROJETO_ATUALIZAR_VARIAVEIS_AMBIENTE_PROD_20251122.md`
- **Verificação de Variáveis:** `VERIFICACAO_SCRIPT_VS_PROD_20251123.md` (⚠️ **IMPORTANTE:** Confirma que script não precisa ser executado)
- **Tracking de Alterações:** `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`
- **Scripts de Deploy:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/`
- **Diretivas do Projeto:** `./cursorrules`

## ⚠️ OBSERVAÇÕES IMPORTANTES

### Script de Variáveis de Ambiente

**Status:** ✅ **NÃO PRECISA SER EXECUTADO**

O script `atualizar_variaveis_ambiente_prod.ps1` **NÃO precisa ser executado** durante o deploy porque:

1. ✅ Todas as 21 variáveis de ambiente já estão presentes em PROD
2. ✅ Todos os valores estão corretos e idênticos aos definidos no script
3. ✅ Verificação completa realizada em 23/11/2025 confirma conformidade 100%
4. ✅ O script já foi executado anteriormente com sucesso

**Documentação:** Ver `VERIFICACAO_SCRIPT_VS_PROD_20251123.md` para detalhes completos da verificação.

**Ação:** O script pode ser copiado para PROD local apenas para referência/documentação, mas **NÃO deve ser executado**.

---

## 🔗 PRÓXIMOS PASSOS

1. ⏳ **Aguardar autorização explícita do usuário**
2. ⏳ Executar FASE 1: Preparação e Análise
3. ⏳ Executar FASE 2: Cópia para PROD Local
4. ⏳ Executar FASE 3: Backup Completo em PROD
5. ⏳ Executar FASE 4: Validação de Arquivos Locais
6. ⏳ Executar FASE 5: Deploy para Servidor PROD
7. ⏳ Executar FASE 6: Validação de Integridade
8. ⏳ Executar FASE 7: Validação de Funcionamento
9. ⏳ Executar FASE 8: Documentação Final

---

**Projeto criado em:** 23/11/2025  
**Versão:** 1.1.0  
**Status:** ⏳ **PENDENTE AUTORIZAÇÃO**

