# 🔐 PROJETO: Atualização de Secret Keys Webflow em Desenvolvimento

**Data de Criação:** 23/11/2025  
**Versão:** 1.0.0  
**Status:** ⏳ **PENDENTE AUTORIZAÇÃO** - Aguardando aprovação para execução  
**Última Atualização:** 23/11/2025 - Versão 1.0.0

---

## 📋 SUMÁRIO EXECUTIVO

### Objetivo

Atualizar as secret keys do Webflow no ambiente de desenvolvimento, garantindo que:

1. **As novas secret keys sejam armazenadas de forma segura** em documento não versionado pelo Git
2. **As variáveis de ambiente no servidor DEV sejam atualizadas** com os novos valores
3. **A funcionalidade dos webhooks seja preservada** e continue funcionando corretamente após a atualização
4. **Nenhuma funcionalidade existente seja quebrada** ou tenha seu comportamento alterado negativamente

### Escopo

- **Ambiente:** DESENVOLVIMENTO (DEV)
- **Servidor:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
- **Arquivo de Configuração:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Variáveis a Atualizar:** 2 variáveis
  - `WEBFLOW_SECRET_FLYINGDONKEYS`
  - `WEBFLOW_SECRET_OCTADESK`

### Impacto Esperado

- ✅ **Segurança:** Novas secret keys armazenadas de forma segura
- ✅ **Funcionalidade:** Webhooks do Webflow continuarão funcionando corretamente
- ✅ **Validação:** Assinaturas dos webhooks serão validadas corretamente com as novas secret keys
- ✅ **Preservação:** Nenhuma funcionalidade existente será quebrada
- ✅ **Documentação:** Credenciais documentadas em local seguro (não versionado)

---

## 👥 STAKEHOLDERS

### Identificação de Stakeholders

| Stakeholder | Papel | Responsabilidade | Aprovação Necessária |
|-------------|-------|-----------------|---------------------|
| **Usuário/Autorizador** | Aprovador Final | Autorizar execução em desenvolvimento | ✅ Sim (obrigatória) |
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

1. **🚨 CRÍTICO:** Guardar secret keys em documento que o GitHub não atualize (`CREDENCIAIS/`)
2. **Criar backup** do arquivo PHP-FPM config antes de qualquer modificação
3. **Atualizar variáveis** no servidor DEV apenas
4. **Verificar duplicatas** antes de adicionar/modificar variáveis
5. **Validar sintaxe** do arquivo PHP-FPM após modificações
6. **Recarregar PHP-FPM** após atualização de configuração
7. **Verificar funcionamento** dos webhooks após atualização
8. **🚨 CRÍTICO:** Garantir que webhooks continuam funcionando normalmente
9. **🚨 CRÍTICO:** Verificar que nenhuma funcionalidade existente foi quebrada
10. **Documentar** todas as alterações realizadas
11. **Ter plano de rollback** pronto antes de executar

### Critérios de Aceitação

- ✅ Documento de credenciais criado em `CREDENCIAIS/WEBFLOW_SECRET_KEYS_DEV.md`
- ✅ Backup do arquivo PHP-FPM config criado no servidor DEV
- ✅ Ambas as variáveis atualizadas com sucesso no servidor DEV
- ✅ Sintaxe do arquivo PHP-FPM validada
- ✅ PHP-FPM recarregado sem erros
- ✅ Variáveis de ambiente carregadas corretamente
- ✅ Nenhum erro crítico nos logs após atualização
- ✅ Webhooks continuam funcionando normalmente
- ✅ Validação de assinatura funcionando corretamente
- ✅ Documentação atualizada com alterações realizadas

---

## 📊 RESUMO DAS FASES

| Fase | Descrição | Tempo Base | Buffer | Tempo Total | Risco | Status |
|------|-----------|------------|--------|-------------|-------|--------|
| 1 | Preparação e Armazenamento Seguro | 0.3h | 0.1h | 0.4h | 🟢 | ⏳ Pendente |
| 2 | Criação de Backup | 0.2h | 0.1h | 0.3h | 🟢 | ⏳ Pendente |
| 3 | Criação do Script PowerShell | 0.5h | 0.2h | 0.7h | 🟡 | ⏳ Pendente |
| 4 | Validação do Script Localmente | 0.3h | 0.1h | 0.4h | 🟡 | ⏳ Pendente |
| 5 | Execução no Servidor DEV | 0.3h | 0.2h | 0.5h | 🟡 | ⏳ Pendente |
| 6 | Validação e Testes | 0.5h | 0.2h | 0.7h | 🟡 | ⏳ Pendente |
| 7 | Documentação Final | 0.2h | 0.1h | 0.3h | 🟢 | ⏳ Pendente |
| **TOTAL** | | **2.3h** | **1.0h** | **3.3h** | 🟡 | ⏳ Pendente |

---

## 📝 DETALHAMENTO DAS FASES

### FASE 1: Preparação e Armazenamento Seguro

**Objetivo:** Criar documento seguro para armazenar as novas secret keys

**Tarefas:**
1. Criar arquivo `WEBFLOW-SEGUROSIMEDIATO/CREDENCIAIS/WEBFLOW_SECRET_KEYS_DEV.md`
2. Documentar as novas secret keys com contexto completo
3. Documentar valores anteriores para referência
4. Adicionar notas sobre segurança e uso

**Entregas:**
- ✅ Arquivo `WEBFLOW_SECRET_KEYS_DEV.md` criado em `CREDENCIAIS/`
- ✅ Secret keys documentadas com URLs e variáveis de ambiente
- ✅ Valores anteriores documentados para referência

**Critérios de Validação:**
- Arquivo criado em diretório não versionado pelo Git
- Todas as informações necessárias documentadas
- Formato consistente com outros arquivos de credenciais

---

### FASE 2: Criação de Backup

**Objetivo:** Criar backup do arquivo de configuração PHP-FPM antes de modificar

**Tarefas:**
1. Conectar ao servidor DEV via SSH
2. Criar backup do arquivo `/etc/php/8.3/fpm/pool.d/www.conf`
3. Calcular hash SHA256 do arquivo original e do backup
4. Validar integridade do backup

**Comandos:**
```bash
# Criar backup com timestamp
BACKUP_FILE="/etc/php/8.3/fpm/pool.d/www.conf.backup_$(date +%Y%m%d_%H%M%S)"
cp /etc/php/8.3/fpm/pool.d/www.conf "$BACKUP_FILE"

# Calcular hashes
ORIG_HASH=$(sha256sum /etc/php/8.3/fpm/pool.d/www.conf | cut -d' ' -f1)
BACK_HASH=$(sha256sum "$BACKUP_FILE" | cut -d' ' -f1)

# Validar integridade
if [ "$ORIG_HASH" == "$BACK_HASH" ]; then
    echo "✅ Backup criado com sucesso: $BACKUP_FILE"
else
    echo "❌ ERRO: Hash do backup não coincide"
    exit 1
fi
```

**Entregas:**
- ✅ Backup do arquivo PHP-FPM config criado no servidor DEV
- ✅ Hash SHA256 validado (original = backup)
- ✅ Localização do backup documentada

**Critérios de Validação:**
- Backup criado com sucesso
- Hash SHA256 do backup coincide com o original
- Backup acessível para rollback se necessário

---

### FASE 3: Criação do Script PowerShell

**Objetivo:** Criar script PowerShell para atualizar as variáveis de ambiente no servidor DEV

**Tarefas:**
1. Criar script `atualizar_secret_keys_webflow_dev.ps1`
2. Implementar funções de log e SSH wrapper
3. Implementar função para atualizar variáveis no servidor
4. Implementar validação de duplicatas antes de atualizar
5. Implementar validação de sintaxe após atualização

**Estrutura do Script:**
```powershell
# Variáveis a atualizar
$variaveis_atualizar = @{
    'WEBFLOW_SECRET_FLYINGDONKEYS' = 'f7b51405e219164038394cf8f0c6b2f197d5a060f0959e3272570a4c10cf1678'
    'WEBFLOW_SECRET_OCTADESK' = '01956c927e436abf74efbd58b1e605b5b6f8f3da409e78241d32a34cec76d50d'
}

# Servidor DEV
$servidorDev = "65.108.156.14"
$configFile = "/etc/php/8.3/fpm/pool.d/www.conf"
```

**Funcionalidades:**
- ✅ Backup automático antes de modificar
- ✅ Verificação de duplicatas
- ✅ Atualização segura via script temporário no servidor
- ✅ Validação de sintaxe PHP-FPM após atualização
- ✅ Reload do PHP-FPM após atualização
- ✅ Validação final das variáveis

**Entregas:**
- ✅ Script PowerShell criado em `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/`
- ✅ Script validado localmente (dry-run)
- ✅ Documentação do script incluída

**Critérios de Validação:**
- Script criado seguindo padrão dos outros scripts do projeto
- Funções de log e SSH wrapper implementadas
- Validação de duplicatas implementada
- Validação de sintaxe implementada

---

### FASE 4: Validação do Script Localmente

**Objetivo:** Validar o script PowerShell antes de executar no servidor

**Tarefas:**
1. Executar script em modo dry-run
2. Validar sintaxe do PowerShell
3. Validar lógica do script
4. Verificar se comandos SSH estão corretos

**Entregas:**
- ✅ Script validado localmente
- ✅ Dry-run executado com sucesso
- ✅ Comandos SSH testados (sem execução real)

**Critérios de Validação:**
- Script executa sem erros de sintaxe
- Dry-run mostra todas as operações que seriam realizadas
- Comandos SSH estão corretos e seguros

---

### FASE 5: Execução no Servidor DEV

**Objetivo:** Executar o script para atualizar as variáveis no servidor DEV

**Tarefas:**
1. Executar script PowerShell
2. Monitorar execução e logs
3. Verificar se backup foi criado
4. Verificar se variáveis foram atualizadas
5. Verificar se sintaxe PHP-FPM está correta
6. Recarregar PHP-FPM

**Comandos de Execução:**
```powershell
# Executar script
.\WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\scripts\atualizar_secret_keys_webflow_dev.ps1
```

**Entregas:**
- ✅ Variáveis atualizadas no servidor DEV
- ✅ PHP-FPM recarregado com sucesso
- ✅ Logs de execução documentados

**Critérios de Validação:**
- Backup criado antes da atualização
- Variáveis atualizadas corretamente
- Sintaxe PHP-FPM validada sem erros
- PHP-FPM recarregado sem erros

---

### FASE 6: Validação e Testes

**Objetivo:** Validar que as atualizações funcionam corretamente

**Tarefas:**
1. Verificar variáveis de ambiente carregadas via PHP
2. Testar validação de assinatura dos webhooks
3. Verificar logs do PHP-FPM
4. Verificar logs dos webhooks
5. Testar webhook `add_flyingdonkeys.php` (se possível)
6. Testar webhook `add_webflow_octa.php` (se possível)

**Comandos de Validação:**
```bash
# Verificar variáveis carregadas
php -r "require '/var/www/html/dev/root/config.php'; echo getWebflowSecretFlyingDonkeys() . PHP_EOL; echo getWebflowSecretOctaDesk() . PHP_EOL;"

# Verificar logs PHP-FPM
tail -n 50 /var/log/php8.3-fpm.log | grep -i error

# Verificar logs dos webhooks
tail -n 50 /var/www/html/dev/root/logs/webhook_*.txt | grep -i signature
```

**Entregas:**
- ✅ Variáveis de ambiente validadas
- ✅ Logs verificados sem erros críticos
- ✅ Webhooks funcionando corretamente (se testável)

**Critérios de Validação:**
- Variáveis carregadas corretamente via PHP
- Nenhum erro crítico nos logs
- Validação de assinatura funcionando (se testável)

---

### FASE 7: Documentação Final

**Objetivo:** Documentar todas as alterações realizadas

**Tarefas:**
1. Criar relatório de execução
2. Documentar valores anteriores e novos
3. Documentar localização do backup
4. Atualizar documento de credenciais se necessário

**Entregas:**
- ✅ Relatório de execução criado
- ✅ Documentação atualizada
- ✅ Backup localizado e documentado

**Critérios de Validação:**
- Relatório completo com todas as informações
- Documentação atualizada e consistente
- Backup localizado para rollback se necessário

---

## 🔄 PLANO DE ROLLBACK

### Objetivo

Restaurar as variáveis de ambiente para os valores anteriores em caso de problemas.

### Procedimento de Rollback (10 Passos)

1. **Identificar Backup:**
   - Localizar arquivo de backup criado na FASE 2
   - Verificar hash SHA256 do backup

2. **Conectar ao Servidor DEV:**
   ```bash
   ssh root@65.108.156.14
   ```

3. **Criar Backup do Estado Atual:**
   ```bash
   cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_antes_rollback_$(date +%Y%m%d_%H%M%S)
   ```

4. **Restaurar Arquivo Original:**
   ```bash
   cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf
   ```

5. **Validar Integridade:**
   ```bash
   sha256sum /etc/php/8.3/fpm/pool.d/www.conf
   sha256sum /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS
   ```

6. **Validar Sintaxe PHP-FPM:**
   ```bash
   php-fpm8.3 -tt
   ```

7. **Recarregar PHP-FPM:**
   ```bash
   systemctl reload php8.3-fpm
   ```

8. **Verificar Status PHP-FPM:**
   ```bash
   systemctl status php8.3-fpm
   ```

9. **Validar Variáveis Restauradas:**
   ```bash
   php -r "require '/var/www/html/dev/root/config.php'; var_dump(\$_ENV['WEBFLOW_SECRET_FLYINGDONKEYS']); var_dump(\$_ENV['WEBFLOW_SECRET_OCTADESK']);"
   ```

10. **Documentar Rollback:**
    - Registrar data/hora do rollback
    - Documentar motivo do rollback
    - Documentar estado restaurado

### Valores para Rollback

**Valores ANTIGOS (para restaurar se necessário):**
- `WEBFLOW_SECRET_FLYINGDONKEYS` = `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142`
- `WEBFLOW_SECRET_OCTADESK` = `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291`

---

## ⚠️ ANÁLISE DE RISCOS

### Riscos Identificados

| # | Risco | Probabilidade | Impacto | Severidade | Mitigação |
|---|-------|---------------|---------|------------|-----------|
| 1 | Erro de sintaxe no arquivo PHP-FPM após atualização | 🟡 Média | 🔴 Alto | 🟡 Médio | Validar sintaxe antes de recarregar PHP-FPM |
| 2 | Variável duplicada no arquivo PHP-FPM | 🟡 Média | 🟡 Médio | 🟡 Médio | Verificar duplicatas antes de adicionar |
| 3 | PHP-FPM não recarrega após atualização | 🟢 Baixa | 🔴 Alto | 🟡 Médio | Verificar status após reload e ter rollback pronto |
| 4 | Webhooks param de funcionar após atualização | 🟢 Baixa | 🔴 Alto | 🟡 Médio | Testar webhooks após atualização e ter rollback pronto |
| 5 | Backup corrompido ou não acessível | 🟢 Baixa | 🔴 Alto | 🟡 Médio | Validar hash do backup e criar múltiplos backups |
| 6 | Secret key incorreta configurada | 🟢 Baixa | 🔴 Alto | 🟡 Médio | Validar valores antes de atualizar e testar após |

### Probabilidade de Sucesso

- **Probabilidade de Sucesso:** 🟢 **95%**
- **Probabilidade de Rollback Necessário:** 🟢 **5%**

---

## 📋 CHECKLIST DE EXECUÇÃO

### Pré-Execução

- [ ] Projeto documentado e aprovado
- [ ] Documento de credenciais criado em `CREDENCIAIS/`
- [ ] Script PowerShell criado e validado localmente
- [ ] Backup do arquivo PHP-FPM config criado
- [ ] Plano de rollback revisado e aprovado

### Execução

- [ ] Script executado no servidor DEV
- [ ] Variáveis atualizadas com sucesso
- [ ] Sintaxe PHP-FPM validada
- [ ] PHP-FPM recarregado sem erros
- [ ] Variáveis de ambiente validadas

### Pós-Execução

- [ ] Webhooks testados e funcionando
- [ ] Logs verificados sem erros críticos
- [ ] Documentação atualizada
- [ ] Relatório de execução criado

---

## 📄 INFORMAÇÕES TÉCNICAS

### Variáveis a Atualizar

| Variável | Valor Atual (DEV) | Valor Novo (DEV) | Ação |
|----------|-------------------|------------------|------|
| `WEBFLOW_SECRET_FLYINGDONKEYS` | `888931809d5215258729a8df0b503403bfd300f32ead1a983d95a6119b166142` | `f7b51405e219164038394cf8f0c6b2f197d5a060f0959e3272570a4c10cf1678` | Modificar |
| `WEBFLOW_SECRET_OCTADESK` | `1dead60b2edf3bab32d8084b6ee105a9458c5cfe282e7b9d27e908f5a6c40291` | `01956c927e436abf74efbd58b1e605b5b6f8f3da409e78241d32a34cec76d50d` | Modificar |

### Webhooks Afetados

1. **`add_flyingdonkeys.php`**
   - URL: `https://dev.bssegurosimediato.com.br/add_flyingdonkeys.php`
   - Variável: `WEBFLOW_SECRET_FLYINGDONKEYS`

2. **`add_webflow_octa.php`**
   - URL: `https://dev.bssegurosimediato.com.br/add_webflow_octa.php`
   - Variável: `WEBFLOW_SECRET_OCTADESK`

### Arquivos Envolvidos

- **Servidor:** `/etc/php/8.3/fpm/pool.d/www.conf` (modificar)
- **Local:** `WEBFLOW-SEGUROSIMEDIATO/CREDENCIAIS/WEBFLOW_SECRET_KEYS_DEV.md` (criar)
- **Script:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/scripts/atualizar_secret_keys_webflow_dev.ps1` (criar)

---

## ✅ CONCLUSÃO

Este projeto visa atualizar as secret keys do Webflow no ambiente de desenvolvimento de forma segura e controlada, garantindo que:

1. ✅ As credenciais sejam armazenadas em local seguro (não versionado)
2. ✅ As variáveis sejam atualizadas corretamente no servidor DEV
3. ✅ A funcionalidade dos webhooks seja preservada
4. ✅ Um plano de rollback esteja disponível caso necessário

**Status:** ⏳ **AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**

---

**Data de criação:** 2025-11-23  
**Versão:** 1.0.0  
**Autor:** Assistente AI  
**Revisão:** Pendente

