# 🎯 PROJETO: Deploy do FooterCodeSiteDefinitivoCompleto.js para Produção - Correção GCLID

**Data de Criação:** 23/11/2025  
**Versão:** 1.0.0  
**Status:** ⏳ **PENDENTE AUTORIZAÇÃO** - Aguardando aprovação para execução  
**Última Atualização:** 23/11/2025 - Versão 1.0.0

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Realizar deploy seguro e cuidadoso do arquivo `FooterCodeSiteDefinitivoCompleto.js` do ambiente de desenvolvimento para produção, garantindo que:

1. **As correções do GCLID sejam aplicadas** em produção (preenchimento do campo GCLID_FLD e timing do DOMContentLoaded)
2. **Backup completo** do arquivo original em produção antes de qualquer modificação
3. **Estratégia de rollback robusta** para restaurar estado original em caso de erro grave
4. **Validação completa** de integridade e funcionamento após deploy
5. **Preservação** de funcionalidades existentes em produção
6. **Nenhuma funcionalidade seja quebrada** ou tenha seu comportamento alterado negativamente

### Escopo

- **Ambiente Origem:** DESENVOLVIMENTO (DEV)
  - **Diretório Local:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`
  - **Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
  - **Caminho Servidor:** `/var/www/html/dev/root/`

- **Ambiente Destino:** PRODUÇÃO (PROD)
  - **Diretório Local:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/`
  - **Servidor:** `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)
  - **Caminho Servidor:** `/var/www/html/prod/root/`

- **Arquivo a Deployar:**
  - **JavaScript:** `FooterCodeSiteDefinitivoCompleto.js` (arquivo único)

### Correções Contidas no Arquivo

O arquivo contém **duas correções críticas** relacionadas ao GCLID:

1. **Correção do Preenchimento do Campo GCLID_FLD:**
   - Busca por ID e NAME (ambos)
   - Melhora leitura de cookie com múltiplos fallbacks
   - Validação de tipo de campo antes de preencher
   - Disparo de eventos (input/change) após preencher
   - Retry (imediato, 1s, 3s)
   - MutationObserver para campos adicionados dinamicamente
   - Tratamento de erros robusto
   - Validação final com log de confirmação

2. **Correção do Timing do DOMContentLoaded:**
   - Verificação de `document.readyState` antes de adicionar listener
   - Execução imediata se DOM já estiver pronto
   - Listener apenas se DOM ainda estiver carregando
   - Log de inicialização e caminho de execução
   - Garantia de que função `fillGCLIDFields()` seja sempre executada

### Impacto Esperado

- ✅ **Correção do GCLID:** Campo `GCLID_FLD` será preenchido corretamente em produção
- ✅ **Funcionalidade:** Funcionalidades existentes preservadas
- ✅ **Segurança:** Backup completo antes de qualquer modificação
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
2. **Seguir processo sequencial obrigatório** conforme diretivas do `.cursorrules` (FASE 1 a FASE 6)
3. **Copiar arquivo** de DEV local para PROD local (Windows) primeiro
4. **Criar backup completo** do arquivo original em PROD antes de deploy
5. **Estratégia de rollback** que restaure arquivo original em caso de erro grave
6. **Validar integridade** do arquivo após cada cópia (hash SHA256)
7. **Validar funcionamento** após deploy
8. **🚨 CRÍTICO:** Garantir que nenhuma funcionalidade existente seja quebrada
9. **Documentar** todas as alterações realizadas
10. **Ter plano de rollback** pronto antes de executar
11. **🚨 OBRIGATÓRIO:** Limpar cache do Cloudflare após deploy

### Critérios de Aceitação

- ✅ Arquivo copiado para PROD local (Windows)
- ✅ Backup completo do arquivo original em PROD criado
- ✅ Hash SHA256 do backup calculado e documentado
- ✅ Arquivo deployado para servidor PROD com sucesso
- ✅ Hash SHA256 do arquivo deployado validado
- ✅ Sintaxe JavaScript validada após deploy
- ✅ Funcionalidade GCLID testada e funcionando corretamente
- ✅ Nenhum erro crítico nos logs após deploy
- ✅ Estratégia de rollback testada e documentada
- ✅ Documentação atualizada com alterações realizadas
- ✅ Cache do Cloudflare limpo após deploy

---

## 📊 RESUMO DAS FASES

| Fase | Descrição | Tempo Base | Buffer | Tempo Total | Risco | Status |
|------|-----------|------------|--------|-------------|-------|--------|
| 1 | Preparação e Análise | 0.2h | 0.1h | 0.3h | 🟢 | ⏳ Pendente |
| 2 | Cópia para PROD Local (Windows) | 0.2h | 0.1h | 0.3h | 🟢 | ⏳ Pendente |
| 3 | Backup Completo em PROD | 0.3h | 0.1h | 0.4h | 🟡 | ⏳ Pendente |
| 4 | Validação de Arquivo Local | 0.2h | 0.1h | 0.3h | 🟡 | ⏳ Pendente |
| 5 | Deploy para Servidor PROD | 0.3h | 0.1h | 0.4h | 🔴 | ⏳ Pendente |
| 6 | Validação de Integridade | 0.2h | 0.1h | 0.3h | 🟡 | ⏳ Pendente |
| 7 | Validação de Funcionamento | 0.5h | 0.2h | 0.7h | 🔴 | ⏳ Pendente |
| 8 | Documentação Final | 0.2h | 0.1h | 0.3h | 🟢 | ⏳ Pendente |

**Tempo Total Estimado:** 2.1h base + 0.8h buffer = **2.9h**

---

## 📋 FASES DETALHADAS

### FASE 1: Preparação e Análise

**Objetivo:** Preparar ambiente e analisar estado atual do arquivo

**Tarefas:**
- [ ] Verificar que arquivo existe em DEV local: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
- [ ] Calcular hash SHA256 do arquivo em DEV local
- [ ] Verificar que arquivo foi deployado no servidor DEV e está funcionando
- [ ] Verificar hash SHA256 do arquivo no servidor DEV
- [ ] Comparar hash DEV local vs DEV servidor (devem ser idênticos)
- [ ] Verificar se arquivo existe em PROD local (`03-PRODUCTION/`)
- [ ] Se arquivo existir em PROD local, calcular hash SHA256
- [ ] Verificar hash SHA256 do arquivo atual no servidor PROD (via SSH)
- [ ] Documentar estado atual (hash DEV, hash PROD atual)

**Validações:**
- ✅ Arquivo existe em DEV local
- ✅ Hash SHA256 calculado e documentado
- ✅ Arquivo funcionando em DEV servidor
- ✅ Estado atual documentado

**Artefatos:**
- Hash SHA256 do arquivo em DEV local
- Hash SHA256 do arquivo em DEV servidor
- Hash SHA256 do arquivo em PROD servidor (atual)
- Documento de estado atual

---

### FASE 2: Cópia para PROD Local (Windows)

**Objetivo:** Copiar arquivo de DEV local para PROD local (Windows)

**Tarefas:**
- [ ] Criar diretório PROD local se não existir: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/`
- [ ] Copiar arquivo de DEV para PROD local:
  - Origem: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
  - Destino: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/FooterCodeSiteDefinitivoCompleto.js`
- [ ] Calcular hash SHA256 do arquivo copiado em PROD local
- [ ] Comparar hash SHA256 DEV local vs PROD local (devem ser idênticos)
- [ ] Documentar hash SHA256 do arquivo em PROD local

**Validações:**
- ✅ Arquivo copiado com sucesso
- ✅ Hash SHA256 dos arquivos DEV e PROD local idênticos
- ✅ Estrutura de diretórios criada corretamente

**Artefatos:**
- Arquivo em `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/FooterCodeSiteDefinitivoCompleto.js`
- Hash SHA256 do arquivo copiado
- Documento de hash SHA256

---

### FASE 3: Backup Completo em PROD

**Objetivo:** Criar backup completo do arquivo original em produção antes do deploy

**Tarefas:**
- [ ] Criar script PowerShell para backup (`backup_footercode_prod.ps1`)
- [ ] Conectar ao servidor PROD via SSH
- [ ] Criar diretório de backup no servidor: `/var/www/html/prod/root/backups/deploy_footercode_YYYYMMDD_HHMMSS/`
- [ ] Fazer backup do arquivo original:
  - Arquivo: `FooterCodeSiteDefinitivoCompleto.js`
  - Origem: `/var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js`
  - Destino: `/var/www/html/prod/root/backups/deploy_footercode_YYYYMMDD_HHMMSS/FooterCodeSiteDefinitivoCompleto.js`
- [ ] Calcular hash SHA256 do arquivo original
- [ ] Calcular hash SHA256 do backup criado
- [ ] Verificar que hash dos backups é idêntico ao original
- [ ] Documentar localização do backup
- [ ] Criar arquivo de índice de backup: `backup_index.txt`
- [ ] Baixar arquivo de índice para documentação local

**Validações:**
- ✅ Arquivo original foi copiado para backup
- ✅ Hash SHA256 do backup idêntico ao original
- ✅ Diretório de backup criado com sucesso
- ✅ Arquivo de índice criado

**Artefatos:**
- Diretório de backup no servidor: `/var/www/html/prod/root/backups/deploy_footercode_YYYYMMDD_HHMMSS/`
- Hash SHA256 do arquivo original
- Hash SHA256 do backup
- Arquivo `backup_index.txt` com mapeamento completo
- Arquivo de índice baixado localmente

**Script de Backup:**
- Localização: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/backup_footercode_prod.ps1`
- Funcionalidades:
  - Criar diretório de backup com timestamp
  - Copiar arquivo original para backup
  - Calcular hash SHA256 do original e do backup
  - Verificar integridade do backup
  - Criar arquivo de índice
  - Baixar índice para documentação local

---

### FASE 4: Validação de Arquivo Local

**Objetivo:** Validar integridade e sintaxe do arquivo antes do deploy

**Tarefas:**
- [ ] Validar sintaxe JavaScript do arquivo local
  - [ ] Executar `node --check` no arquivo (se Node.js disponível)
  - [ ] Verificar que nenhum erro de sintaxe foi encontrado
- [ ] Comparar hash SHA256 dos arquivos PROD local vs DEV local
  - [ ] Verificar que arquivos são idênticos
- [ ] Verificar que arquivo não contém referências hardcoded a DEV
  - [ ] Buscar por `dev.bssegurosimediato.com.br` no arquivo
  - [ ] Buscar por `65.108.156.14` no arquivo
  - [ ] Verificar que todas as URLs usam variáveis de ambiente ou são genéricas
- [ ] Verificar que correções do GCLID estão presentes no arquivo
  - [ ] Buscar por `executeGCLIDFill` (função de correção de timing)
  - [ ] Buscar por `fillGCLIDFields` (função de preenchimento)
  - [ ] Buscar por `document.readyState` (verificação de timing)
  - [ ] Buscar por `MutationObserver` (observer para campos dinâmicos)

**Validações:**
- ✅ Sintaxe JavaScript válida (ou sem erros críticos)
- ✅ Arquivos idênticos entre DEV e PROD local
- ✅ Nenhuma referência hardcoded a DEV encontrada
- ✅ Correções do GCLID presentes no arquivo

**Artefatos:**
- Relatório de validação de sintaxe
- Relatório de verificação de hash SHA256
- Relatório de verificação de referências hardcoded
- Relatório de verificação de correções do GCLID

---

### FASE 5: Deploy para Servidor PROD

**Objetivo:** Copiar arquivo de PROD local para servidor PROD com validação completa

**Tarefas:**
- [ ] Criar script PowerShell para deploy (`deploy_footercode_prod.ps1`)
- [ ] Conectar ao servidor PROD via SSH
- [ ] Calcular hash SHA256 do arquivo local antes de copiar
- [ ] Copiar arquivo via SCP:
  - Origem: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/FooterCodeSiteDefinitivoCompleto.js`
  - Destino: `/var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js`
- [ ] Ajustar permissões do arquivo no servidor (se necessário):
  - [ ] `chmod 644 /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js`
- [ ] Calcular hash SHA256 do arquivo no servidor após cópia
- [ ] Comparar hash SHA256 local vs servidor (devem ser idênticos)
- [ ] Se hash não coincidir, tentar copiar novamente
- [ ] Documentar hash SHA256 do arquivo deployado

**Validações:**
- ✅ Arquivo copiado com sucesso
- ✅ Permissões ajustadas corretamente
- ✅ Hash SHA256 local e servidor idênticos
- ✅ Integridade do arquivo confirmada

**Artefatos:**
- Arquivo deployado no servidor: `/var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js`
- Hash SHA256 do arquivo local (antes da cópia)
- Hash SHA256 do arquivo no servidor (após cópia)
- Documento de hash SHA256 comparado

**Script de Deploy:**
- Localização: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/deploy_footercode_prod.ps1`
- Funcionalidades:
  - Calcular hash SHA256 do arquivo local
  - Copiar arquivo via SCP usando caminho completo do workspace
  - Ajustar permissões do arquivo
  - Calcular hash SHA256 do arquivo no servidor
  - Comparar hashes (case-insensitive)
  - Tentar copiar novamente se hash não coincidir
  - Gerar relatório de deploy

---

### FASE 6: Validação de Integridade

**Objetivo:** Validar integridade e acessibilidade do arquivo após deploy

**Tarefas:**
- [ ] Validar sintaxe JavaScript no servidor (se possível via SSH)
- [ ] Verificar acessibilidade do arquivo via HTTP:
  - [ ] URL: `https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js`
  - [ ] Verificar status HTTP (deve ser 200)
  - [ ] Verificar tamanho do arquivo via HTTP
- [ ] Comparar hash SHA256 final:
  - [ ] Calcular hash SHA256 do arquivo no servidor novamente
  - [ ] Comparar com hash do arquivo local (devem ser idênticos)
- [ ] Verificar logs do servidor para erros relacionados ao arquivo

**Validações:**
- ✅ Sintaxe JavaScript válida (se validação possível)
- ✅ Arquivo acessível via HTTP (status 200)
- ✅ Tamanho do arquivo via HTTP corresponde ao esperado
- ✅ Hash SHA256 final idêntico ao local
- ✅ Nenhum erro crítico nos logs

**Artefatos:**
- Relatório de validação de sintaxe
- Relatório de verificação HTTP
- Relatório de hash SHA256 final
- Relatório de verificação de logs

---

### FASE 7: Validação de Funcionamento

**Objetivo:** Testar funcionalidade do GCLID em produção após deploy

**Tarefas:**
- [ ] Testar funcionalidade do GCLID em produção:
  - [ ] Acessar página com formulário contendo campo `GCLID_FLD`
  - [ ] Verificar que log de inicialização aparece quando função é chamada
  - [ ] Verificar que log de caminho de execução aparece corretamente
  - [ ] Verificar que função executa mesmo se DOM já estiver pronto
  - [ ] Verificar que função executa mesmo se DOM ainda estiver carregando
  - [ ] Verificar que campo `GCLID_FLD` é preenchido corretamente
  - [ ] Verificar que retry funciona (1s, 3s)
  - [ ] Verificar que MutationObserver funciona
  - [ ] Verificar que validação final funciona
  - [ ] Verificar console do navegador para erros
- [ ] Verificar logs do servidor para erros relacionados ao GCLID
- [ ] Testar em múltiplos navegadores (Chrome, Firefox, Safari, Edge) - se possível
- [ ] Documentar resultados dos testes

**Validações:**
- ✅ Funcionalidade GCLID funcionando corretamente
- ✅ Campo `GCLID_FLD` preenchido corretamente
- ✅ Nenhum erro crítico no console do navegador
- ✅ Nenhum erro crítico nos logs do servidor
- ✅ Funcionalidades existentes preservadas

**Artefatos:**
- Relatório de testes funcionais
- Screenshots ou logs de testes (se aplicável)
- Relatório de verificação de logs do servidor

**⚠️ IMPORTANTE:** Testes funcionais podem requerer intervenção manual (acessar página, verificar campo, etc.). Documentar claramente que teste requer intervenção manual.

---

### FASE 8: Documentação Final

**Objetivo:** Documentar todas as alterações realizadas e atualizar tracking

**Tarefas:**
- [ ] Criar relatório de execução completo:
  - [ ] Resumo executivo
  - [ ] Todas as fases executadas
  - [ ] Hash SHA256 de todos os arquivos (DEV, PROD local, PROD servidor)
  - [ ] Localização do backup criado
  - [ ] Resultados das validações
  - [ ] Resultados dos testes funcionais
  - [ ] Problemas encontrados e soluções aplicadas
- [ ] Atualizar documento de tracking de alterações:
  - [ ] Arquivo: `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`
  - [ ] Registrar data, hora, tipo de alteração, arquivo afetado
  - [ ] Documentar correções do GCLID aplicadas
- [ ] Criar documento de instruções de rollback (se necessário)
- [ ] Atualizar histórico de deploy (se existir)

**Validações:**
- ✅ Relatório de execução criado
- ✅ Documentação completa
- ✅ Tracking atualizado

**Artefatos:**
- Relatório: `RELATORIO_DEPLOY_FOOTERCODE_PROD_GCLID_YYYYMMDD.md`
- Documento de auditoria pós-implementação
- Atualização de `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`

---

## 🔄 PLANO DE ROLLBACK

### Objetivo

Restaurar estado original de produção em caso de erro grave.

### Valores Originais para Rollback

| Item | Valor Original (antes do deploy) |
|------|----------------------------------|
| **Arquivo** | `FooterCodeSiteDefinitivoCompleto.js` |
| **Localização Backup** | `/var/www/html/prod/root/backups/deploy_footercode_YYYYMMDD_HHMMSS/FooterCodeSiteDefinitivoCompleto.js` |
| **Hash SHA256 Original** | (será documentado na FASE 3) |

### Cenários de Rollback

#### Cenário 1: Erro durante Deploy (antes de completar)

**Condição:** Erro durante cópia do arquivo para servidor PROD

**Ação:**
1. Parar processo de deploy imediatamente
2. Verificar se arquivo foi modificado no servidor
3. Se arquivo foi modificado, restaurar do backup
4. Validar hash SHA256 do arquivo restaurado
5. Verificar funcionamento após restauração
6. Documentar rollback

#### Cenário 2: Erro após Deploy (validação de integridade falhou)

**Condição:** Sintaxe JavaScript inválida ou arquivo corrompido após deploy

**Ação:**
1. Identificar problema específico
2. Restaurar arquivo do backup
3. Validar hash SHA256 do arquivo restaurado
4. Validar sintaxe JavaScript após restauração
5. Verificar acessibilidade via HTTP após restauração
6. Verificar funcionamento após restauração
7. Documentar rollback

#### Cenário 3: Erro Funcional (funcionalidades quebradas)

**Condição:** Funcionalidades não funcionam após deploy ou GCLID não funciona corretamente

**Ação:**
1. Identificar funcionalidades afetadas
2. Analisar logs do servidor para identificar causa
3. Analisar console do navegador para identificar erros JavaScript
4. Decidir se rollback completo ou parcial
5. Restaurar arquivo do backup
6. Validar funcionamento após restauração
7. Documentar causa raiz do problema
8. Documentar rollback

#### Cenário 4: Rollback Completo

**Condição:** Múltiplos problemas ou erro crítico não identificado

**Ação:**
1. Restaurar arquivo do backup
2. Validar hash SHA256 do arquivo restaurado
3. Validar sintaxe JavaScript do arquivo
4. Verificar acessibilidade via HTTP
5. Testar funcionalidades principais
6. Verificar logs do servidor
7. Verificar console do navegador
8. Documentar rollback completo

### Processo de Rollback Detalhado

#### Passo 1: Identificar Localização do Backup

```powershell
# Listar backups disponíveis
ssh root@157.180.36.223 "ls -la /var/www/html/prod/root/backups/deploy_footercode_*/"
```

#### Passo 2: Restaurar Arquivo

```powershell
# Restaurar arquivo do backup
ssh root@157.180.36.223 "cp /var/www/html/prod/root/backups/deploy_footercode_YYYYMMDD_HHMMSS/FooterCodeSiteDefinitivoCompleto.js /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js"
```

#### Passo 3: Validar Hash SHA256

```powershell
# Calcular hash do arquivo restaurado
ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js"

# Comparar com hash do backup (devem ser idênticos)
```

#### Passo 4: Validar Sintaxe JavaScript

```powershell
# Validar sintaxe (se Node.js disponível no servidor)
ssh root@157.180.36.223 "node --check /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js"
```

#### Passo 5: Verificar Funcionamento

```powershell
# Verificar acessibilidade via HTTP
# Testar funcionalidades principais
# Verificar logs do servidor
# Verificar console do navegador
```

### Script de Rollback

**Localização:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/rollback_footercode_prod.ps1`

**Funcionalidades:**
- Listar backups disponíveis
- Restaurar arquivo do backup
- Validar hash SHA256 após restauração
- Validar sintaxe JavaScript após restauração
- Verificar acessibilidade via HTTP após restauração
- Gerar relatório de rollback

### Tempo Estimado de Rollback

- **Rollback Completo:** 5-10 minutos

---

## ⚠️ RISCOS E MITIGAÇÕES

### Riscos Identificados

| # | Risco | Severidade | Probabilidade | Mitigação |
|---|-------|------------|---------------|-----------|
| 1 | Arquivo corrompido durante cópia | 🔴 ALTA | 🟡 MÉDIA | Validação de hash SHA256 após cada cópia |
| 2 | Sintaxe JavaScript inválida após deploy | 🔴 ALTA | 🟢 BAIXA | Validação de sintaxe antes e depois do deploy |
| 3 | Funcionalidades quebradas após deploy | 🔴 ALTA | 🟡 MÉDIA | Testes funcionais completos após deploy |
| 4 | Cache do Cloudflare mantém versão antiga | 🟡 MÉDIA | 🟡 MÉDIA | Limpar cache do Cloudflare após deploy |
| 5 | Erro durante rollback | 🔴 ALTA | 🟢 BAIXA | Backup validado antes do deploy, script de rollback testado |

### Mitigações Adicionais

- ✅ **Backup obrigatório** antes de qualquer modificação
- ✅ **Validação de hash SHA256** após cada operação crítica
- ✅ **Processo sequencial obrigatório** (não pular etapas)
- ✅ **Validação completa** antes e depois do deploy
- ✅ **Plano de rollback** testado e documentado
- ✅ **Documentação completa** de todas as operações

---

## 📋 CHECKLIST DE EXECUÇÃO

### Antes de Iniciar

- [ ] Projeto documentado e aprovado
- [ ] Autorização explícita do usuário obtida
- [ ] Backup do arquivo atual em PROD verificado (ou será criado na FASE 3)
- [ ] Scripts PowerShell criados e validados
- [ ] Acesso SSH ao servidor PROD verificado
- [ ] Plano de rollback revisado

### Durante Execução

- [ ] FASE 1: Preparação e Análise concluída
- [ ] FASE 2: Cópia para PROD Local concluída
- [ ] FASE 3: Backup Completo em PROD concluído
- [ ] FASE 4: Validação de Arquivo Local concluída
- [ ] FASE 5: Deploy para Servidor PROD concluído
- [ ] FASE 6: Validação de Integridade concluída
- [ ] FASE 7: Validação de Funcionamento concluída
- [ ] FASE 8: Documentação Final concluída

### Após Execução

- [ ] Relatório de execução criado
- [ ] Documentação atualizada
- [ ] Tracking atualizado
- [ ] Cache do Cloudflare limpo
- [ ] Auditoria pós-implementação realizada

---

## 🚨 ALERTAS OBRIGATÓRIOS

### Cache do Cloudflare

⚠️ **IMPORTANTE:** Após atualizar arquivo `.js` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare. O Cloudflare pode manter versões antigas em cache, causando erros como uso de código desatualizado, funcionalidades não funcionando, etc.

**Aviso a ser emitido:**
> ⚠️ **IMPORTANTE:** Após atualizar arquivo no servidor, é necessário limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.

### Produção

⚠️ **ALERTA:** Este projeto modifica arquivos no servidor de produção. Todas as precauções devem ser tomadas:
- Backup obrigatório antes de qualquer modificação
- Validação completa após deploy
- Plano de rollback pronto e testado
- Documentação completa de todas as operações

---

## 📝 NOTAS TÉCNICAS

### Compatibilidade

- ✅ **JavaScript:** Compatível com todos os navegadores modernos (Chrome, Firefox, Safari, Edge)
- ✅ **document.readyState:** Suportado em todos os navegadores modernos (IE9+)
- ✅ **DOMContentLoaded:** Suportado em todos os navegadores modernos (IE9+)
- ✅ **MutationObserver:** Suportado em todos os navegadores modernos (IE11+)

### Performance

- ✅ **Verificação de readyState:** Operação síncrona e instantânea
- ✅ **Execução imediata:** Não adiciona overhead se DOM já estiver pronto
- ✅ **Listener:** Adicionado apenas se necessário (DOM ainda carregando)

### Segurança

- ✅ **Não altera funcionalidade existente:** Apenas adiciona correções do GCLID
- ✅ **Mantém tratamento de erros:** Código existente preservado
- ✅ **Não expõe informações sensíveis:** Sem mudanças de segurança

---

## ✅ CONCLUSÃO

Este projeto define um processo cuidadoso e seguro para deploy do arquivo `FooterCodeSiteDefinitivoCompleto.js` para produção, garantindo que:

1. ✅ Todas as correções do GCLID sejam aplicadas
2. ✅ Backup completo seja criado antes de qualquer modificação
3. ✅ Validação completa seja realizada em cada etapa
4. ✅ Plano de rollback esteja pronto e testado
5. ✅ Funcionalidades existentes sejam preservadas
6. ✅ Documentação completa seja mantida

O projeto está pronto para execução após autorização explícita do usuário.

---

**Documento criado em:** 23/11/2025  
**Versão:** 1.0.0  
**Status:** ⏳ **PENDENTE AUTORIZAÇÃO**  
**Conforme diretivas:** `.cursorrules` - Processo sequencial obrigatório (FASE 1 a FASE 6)

