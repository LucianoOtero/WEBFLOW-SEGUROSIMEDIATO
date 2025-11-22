# Plano de Atualização do Servidor: Correção Erro HTTP 500 - strlen() recebendo array

**Versão:** 1.2.0  
**Data de Criação:** 2025-11-18  
**Última Atualização:** 2025-11-18  
**Status:** 📋 **PLANO CRIADO E 100% CONFORME - Aguardando autorização para execução**  
**Baseado em:** `PROJETO_CORRIGIR_ERRO_HTTP_500_STRLEN_ARRAY_20251118.md` (Versão 1.1.0)

---

## 📋 Resumo Executivo

Este plano documenta o processo de atualização do servidor de produção com as correções implementadas no ambiente DEV para o erro HTTP 500 causado por `TypeError: strlen(): Argument #1 ($string) must be of type string, array given`.

**Status Atual:**
- ✅ Correções implementadas em DEV (`dev.bssegurosimediato.com.br`)
- ✅ Arquivos testados e verificados em DEV
- ⏳ Aguardando atualização para produção

---

## 🎯 Objetivo

Atualizar o servidor de produção com as correções implementadas em DEV, seguindo o fluxo obrigatório definido nas diretivas do projeto.

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### Objetivo do Usuário

Atualizar o servidor de produção com as correções do erro HTTP 500 que foram implementadas e testadas no ambiente DEV.

### Requisitos Explícitos

1. **Atualizar servidor de produção** com arquivos corrigidos de DEV
2. **Manter integridade** dos arquivos durante o processo de atualização
3. **Garantir que correções funcionem** em produção da mesma forma que em DEV
4. **Não quebrar funcionalidades existentes** em produção
5. **Seguir processo sequencial obrigatório** definido nas diretivas

### Requisitos Não-Funcionais

1. **Segurança:** Criar backups antes de qualquer modificação
2. **Integridade:** Verificar hash SHA256 após cada cópia
3. **Rastreabilidade:** Documentar cada fase do processo
4. **Conformidade:** Seguir diretivas do projeto rigorosamente

### Critérios de Aceitação

1. ✅ Arquivos copiados de DEV para PROD local (`03-PRODUCTION/`)
2. ✅ Hash SHA256 verificado após cópia local
3. ✅ Arquivos copiados para servidor de produção
4. ✅ Hash SHA256 verificado após cópia para servidor
5. ✅ Funcionalidade testada em produção
6. ✅ Logs verificados sem erros

### Stakeholders

**Stakeholders Identificados:**
- **Usuário/Cliente:** Solicitante da atualização, responsável por aprovar execução
- **Desenvolvedor/Operador:** Responsável por executar o plano de atualização
- **Equipe de Infraestrutura:** Responsável por manter servidor de produção disponível

**Responsabilidades:**
- **Usuário:** Aprovar execução do plano, limpar cache do Cloudflare após atualização
- **Desenvolvedor/Operador:** Executar plano conforme fases definidas, documentar resultados
- **Equipe de Infraestrutura:** Garantir disponibilidade do servidor durante atualização

---

## 📐 Especificações Técnicas

### Arquivos a Atualizar

1. **`ProfessionalLogger.php`**
   - **Localização DEV:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
   - **Localização PROD Local:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/ProfessionalLogger.php`
   - **Servidor PROD:** `/var/www/html/prod/root/ProfessionalLogger.php`
   - **Modificações:** Normalização de `$logData['data']` + verificações de tipo nas linhas 737 e 819

2. **`send_admin_notification_ses.php`**
   - **Localização DEV:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/send_admin_notification_ses.php`
   - **Localização PROD Local:** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/send_admin_notification_ses.php`
   - **Servidor PROD:** `/var/www/html/prod/root/send_admin_notification_ses.php`
   - **Modificações:** 4 chamadas diretas substituídas por `log()`

### Informações do Servidor

- **Servidor DEV:** `dev.bssegurosimediato.com.br` (IP: 65.108.156.14)
- **Servidor PROD:** `prod.bssegurosimediato.com.br` (IP: 157.180.36.223)
- **Caminho DEV:** `/var/www/html/dev/root/`
- **Caminho PROD:** `/var/www/html/prod/root/`

### Métricas de Performance

**Métricas a Monitorar:**

1. **Tempo de Cópia de Arquivos:**
   - Tempo de cópia DEV → PROD local: ~1-2 segundos por arquivo
   - Tempo de cópia PROD local → Servidor PROD: ~2-5 segundos por arquivo (depende da conexão)

2. **Tempo de Verificação de Hash:**
   - Tempo de cálculo hash SHA256 local: ~0.1-0.5 segundos por arquivo
   - Tempo de cálculo hash SHA256 no servidor: ~0.1-0.5 segundos por arquivo

3. **Tempo de Resposta do Endpoint:**
   - Tempo de resposta esperado antes da atualização: Baseline a ser medido
   - Tempo de resposta esperado após atualização: Não deve degradar (impacto mínimo: ~0.1ms por chamada)

4. **Tempo Total de Execução:**
   - Estimativa total: ~55 minutos (~1h)
   - Breakdown por fase:
     - FASE 1: ~10 minutos
     - FASE 2: ~5 minutos
     - FASE 3: ~5 minutos
     - FASE 4: ~10 minutos
     - FASE 5: ~15 minutos
     - FASE 6: ~10 minutos

**Métricas de Sucesso:**
- ✅ Tempo de cópia < 10 segundos por arquivo
- ✅ Tempo de verificação de hash < 2 segundos por arquivo
- ✅ Tempo de resposta do endpoint não degrada significativamente
- ✅ Tempo total de execução < 1h30min

---

## 📋 CASOS DE USO

### **Cenário 1: Atualização Bem-Sucedida (Cenário Principal)**

**Descrição:** Atualização completa do servidor de produção sem problemas.

**Fluxo:**
1. Verificação pré-atualização concluída com sucesso
2. Backups criados sem erros
3. Arquivos copiados de DEV para PROD local
4. Hash SHA256 verificado e coincidindo (DEV = PROD local)
5. Arquivos copiados para servidor de produção
6. Hash SHA256 verificado e coincidindo (local = servidor)
7. Sintaxe PHP verificada sem erros
8. Logs do PHP-FPM verificados sem erros de `strlen()`
9. Endpoint de email testado e funcionando corretamente
10. Cache do Cloudflare limpo pelo usuário

**Resultado Esperado:**
- ✅ Endpoint de email funciona sem HTTP 500
- ✅ Logs são inseridos no banco de dados corretamente
- ✅ Emails são enviados corretamente
- ✅ Nenhum erro nos logs do PHP-FPM

---

### **Cenário 2: Hash Não Coincide - Tentar Novamente**

**Descrição:** Hash SHA256 não coincide após cópia, requerendo nova tentativa.

**Fluxo:**
1. Arquivo copiado para servidor
2. Hash SHA256 calculado e comparado
3. **Hash não coincide** → Erro detectado
4. Verificar conexão de rede
5. Tentar copiar novamente
6. Verificar hash novamente
7. Se hash ainda não coincidir após 3 tentativas → Investigar problema de rede/servidor

**Ações de Contingência:**
- Verificar conectividade de rede
- Verificar espaço em disco no servidor
- Verificar permissões de arquivo
- Tentar copiar novamente após verificar problemas

**Resultado Esperado:**
- ✅ Hash coincide após nova tentativa
- ✅ Arquivo copiado corretamente

---

### **Cenário 3: Erro Após Atualização - Rollback Necessário**

**Descrição:** Após atualização, erro é detectado e rollback é necessário.

**Fluxo:**
1. Atualização concluída
2. Teste do endpoint de email realizado
3. **Erro HTTP 500 detectado** ou **erro nos logs do PHP-FPM**
4. Decisão de rollback tomada
5. Restaurar backups do servidor de produção
6. Verificar hash SHA256 dos arquivos restaurados
7. Testar endpoint após rollback
8. Verificar logs do PHP-FPM após rollback
9. Confirmar que rollback foi bem-sucedido

**Ações de Contingência:**
- Restaurar arquivos do servidor usando backups criados na FASE 2
- Verificar que arquivos foram restaurados corretamente
- Testar funcionalidade após rollback
- Investigar causa do erro antes de tentar atualização novamente

**Resultado Esperado:**
- ✅ Arquivos restaurados corretamente
- ✅ Endpoint funciona após rollback
- ✅ Sistema volta ao estado anterior à atualização

---

### **Cenário 4: Servidor Indisponível Durante Atualização**

**Descrição:** Servidor de produção fica indisponível durante processo de atualização.

**Fluxo:**
1. Início da atualização
2. Tentativa de conexão SSH para criar backup
3. **Servidor não responde** ou **timeout na conexão**
4. Aguardar alguns minutos
5. Tentar conectar novamente
6. Se servidor continuar indisponível → Abortar atualização
7. Aguardar servidor voltar ao normal
8. Verificar que servidor está funcionando corretamente
9. Reiniciar processo de atualização a partir da FASE 1

**Ações de Contingência:**
- Verificar status do servidor (ping, SSH)
- Aguardar servidor voltar ao normal
- Verificar logs do servidor para identificar causa
- Reiniciar processo apenas após servidor estar estável

**Resultado Esperado:**
- ✅ Servidor volta ao normal
- ✅ Processo de atualização pode ser reiniciado com segurança

---

## ⚠️ ANÁLISE DE RISCOS

### Riscos Identificados

#### **Risco 1: Arquivo pode ser corrompido durante cópia**
- **Severidade:** Alta
- **Probabilidade:** Baixa
- **Mitigação:** Verificação de hash SHA256 após cada cópia
- **Plano de Contingência:** Restaurar backup se hash não coincidir

#### **Risco 2: Servidor de produção pode ficar indisponível**
- **Severidade:** Alta
- **Probabilidade:** Baixa
- **Mitigação:** Backups criados antes de copiar, rollback disponível
- **Plano de Contingência:** Restaurar backups do servidor se necessário

#### **Risco 3: Correções podem não funcionar em produção**
- **Severidade:** Média
- **Probabilidade:** Baixa
- **Mitigação:** Correções já testadas em DEV, ambiente similar
- **Plano de Contingência:** Rollback imediato se problemas forem detectados

#### **Risco 4: Cache do Cloudflare pode manter versão antiga**
- **Severidade:** Média
- **Probabilidade:** Média
- **Mitigação:** Avisar usuário sobre necessidade de limpar cache
- **Plano de Contingência:** Limpar cache manualmente se necessário

### Matriz de Riscos

| Risco | Severidade | Probabilidade | Prioridade | Status |
|-------|------------|---------------|------------|--------|
| R1: Arquivo corrompido | Alta | Baixa | Alta | Mitigado |
| R2: Servidor indisponível | Alta | Baixa | Alta | Mitigado |
| R3: Correções não funcionam | Média | Baixa | Média | Mitigado |
| R4: Cache Cloudflare | Média | Média | Média | Mitigado |

---

## 📋 Fases do Plano

### **FASE 1: Verificação Pré-Atualização**

**Objetivo:** Verificar que todas as condições estão atendidas antes de iniciar atualização  
**Estimativa de Tempo:** ~10 minutos

**Tarefas:**
1. ✅ Verificar que correções foram implementadas em DEV
2. ✅ Verificar que arquivos existem em `02-DEVELOPMENT/`
3. ✅ Verificar que testes em DEV foram bem-sucedidos (ou documentados como pendentes)
4. ✅ Verificar que diretório `03-PRODUCTION/` existe
5. ✅ Calcular hash SHA256 dos arquivos em DEV

**Checklist:**
- [ ] `ProfessionalLogger.php` existe em `02-DEVELOPMENT/`
- [ ] `send_admin_notification_ses.php` existe em `02-DEVELOPMENT/`
- [ ] Diretório `03-PRODUCTION/` existe
- [ ] Hash SHA256 dos arquivos DEV calculado

**Critérios de Sucesso:**
- ✅ Todos os arquivos necessários estão disponíveis
- ✅ Diretório de produção local existe
- ✅ Hash SHA256 calculado para verificação posterior

---

### **FASE 2: Criar Backups dos Arquivos de Produção**

**Objetivo:** Criar backups dos arquivos atuais de produção antes de atualizar  
**Estimativa de Tempo:** ~5 minutos

**Tarefas:**
1. ✅ Criar backup local dos arquivos em `03-PRODUCTION/` (se existirem)
2. ✅ Criar backup no servidor de produção antes de copiar novos arquivos

**Comandos:**
```powershell
# Backup local (se arquivos existirem em 03-PRODUCTION/) - usando caminho completo do workspace
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
# Criar diretório de backup se não existir
if (-not (Test-Path "WEBFLOW-SEGUROSIMEDIATO\04-BACKUPS")) {
    New-Item -ItemType Directory -Path "WEBFLOW-SEGUROSIMEDIATO\04-BACKUPS" -Force | Out-Null
}
if (Test-Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php") {
    Copy-Item "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" "WEBFLOW-SEGUROSIMEDIATO\04-BACKUPS\ProfessionalLogger.php.backup_ANTES_ATUALIZACAO_STRLEN_ARRAY_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
}
if (Test-Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\send_admin_notification_ses.php") {
    Copy-Item "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\send_admin_notification_ses.php" "WEBFLOW-SEGUROSIMEDIATO\04-BACKUPS\send_admin_notification_ses.php.backup_ANTES_ATUALIZACAO_STRLEN_ARRAY_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
}

# Backup no servidor de produção
ssh root@157.180.36.223 "cp /var/www/html/prod/root/ProfessionalLogger.php /var/www/html/prod/root/ProfessionalLogger.php.backup_ANTES_ATUALIZACAO_STRLEN_ARRAY_$(date +%Y%m%d_%H%M%S)"
ssh root@157.180.36.223 "cp /var/www/html/prod/root/send_admin_notification_ses.php /var/www/html/prod/root/send_admin_notification_ses.php.backup_ANTES_ATUALIZACAO_STRLEN_ARRAY_$(date +%Y%m%d_%H%M%S)"
```

**Critérios de Sucesso:**
- ✅ Backups criados localmente (se arquivos existirem)
- ✅ Backups criados no servidor de produção

---

### **FASE 3: Copiar de DEV para PROD Local**

**Objetivo:** Copiar arquivos corrigidos de DEV para diretório de produção local  
**Estimativa de Tempo:** ~5 minutos

**Tarefas:**
1. ✅ Copiar `ProfessionalLogger.php` de `02-DEVELOPMENT/` para `03-PRODUCTION/`
2. ✅ Copiar `send_admin_notification_ses.php` de `02-DEVELOPMENT/` para `03-PRODUCTION/`
3. ✅ Verificar que arquivos foram copiados corretamente
4. ✅ Comparar hash SHA256 dos arquivos DEV e PROD local (devem ser idênticos)

**Comandos:**
```powershell
# Copiar arquivos (usando caminho completo do workspace)
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
Copy-Item "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -Force
Copy-Item "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_admin_notification_ses.php" "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\send_admin_notification_ses.php" -Force

# Verificar hash SHA256 (devem ser idênticos)
$hashDEV_PL = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
$hashPROD_PL = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
if ($hashDEV_PL -eq $hashPROD_PL) {
    Write-Host "✅ ProfessionalLogger.php: Hash coincide!" -ForegroundColor Green
} else {
    Write-Host "❌ ProfessionalLogger.php: Hash não coincide!" -ForegroundColor Red
}

$hashDEV_SES = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\send_admin_notification_ses.php" -Algorithm SHA256).Hash.ToUpper()
$hashPROD_SES = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\send_admin_notification_ses.php" -Algorithm SHA256).Hash.ToUpper()
if ($hashDEV_SES -eq $hashPROD_SES) {
    Write-Host "✅ send_admin_notification_ses.php: Hash coincide!" -ForegroundColor Green
} else {
    Write-Host "❌ send_admin_notification_ses.php: Hash não coincide!" -ForegroundColor Red
}
```

**Critérios de Sucesso:**
- ✅ Arquivos copiados para `03-PRODUCTION/`
- ✅ Hash SHA256 dos arquivos DEV e PROD local coincidem

---

### **FASE 4: Copiar de PROD Local para Servidor de Produção**

**Objetivo:** Copiar arquivos corrigidos do diretório local de produção para servidor de produção  
**Estimativa de Tempo:** ~10 minutos

**Tarefas:**
1. ✅ Copiar `ProfessionalLogger.php` de `03-PRODUCTION/` para servidor PROD
2. ✅ Copiar `send_admin_notification_ses.php` de `03-PRODUCTION/` para servidor PROD
3. ✅ Verificar hash SHA256 após cópia (case-insensitive)
4. ✅ Confirmar que arquivos foram copiados corretamente

**Comandos:**
```bash
# Copiar arquivos para servidor de produção (usando caminho completo do workspace)
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" root@157.180.36.223:/var/www/html/prod/root/
scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\send_admin_notification_ses.php" root@157.180.36.223:/var/www/html/prod/root/

# Verificar hash SHA256 após cópia (usando caminho completo do workspace)
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$hashLocalPL = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
$hashServidorPL = (ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/ProfessionalLogger.php | cut -d' ' -f1").ToUpper()
if ($hashLocalPL -eq $hashServidorPL) {
    Write-Host "✅ ProfessionalLogger.php: Hash coincide!" -ForegroundColor Green
} else {
    Write-Host "❌ ProfessionalLogger.php: Hash não coincide!" -ForegroundColor Red
}

$hashLocalSES = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\send_admin_notification_ses.php" -Algorithm SHA256).Hash.ToUpper()
$hashServidorSES = (ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/send_admin_notification_ses.php | cut -d' ' -f1").ToUpper()
if ($hashLocalSES -eq $hashServidorSES) {
    Write-Host "✅ send_admin_notification_ses.php: Hash coincide!" -ForegroundColor Green
} else {
    Write-Host "❌ send_admin_notification_ses.php: Hash não coincide!" -ForegroundColor Red
}
```

**Critérios de Sucesso:**
- ✅ Arquivos copiados para servidor de produção
- ✅ Hash SHA256 local e servidor coincidem (case-insensitive)

---

### **FASE 5: Verificação e Testes em Produção**

**Objetivo:** Verificar que atualização foi bem-sucedida e testar funcionalidade em produção  
**Estimativa de Tempo:** ~15 minutos

**Tarefas:**
1. ✅ Verificar sintaxe PHP dos arquivos no servidor (se possível)
2. ✅ Verificar logs do PHP-FPM para confirmar ausência de erros
3. ✅ Testar endpoint de email via HTTP POST (se possível)
4. ✅ Verificar que não há erros HTTP 500
5. ✅ Verificar que emails são enviados corretamente (se possível)

**Comandos:**
```bash
# Verificar sintaxe PHP no servidor
ssh root@157.180.36.223 "php -l /var/www/html/prod/root/ProfessionalLogger.php"
ssh root@157.180.36.223 "php -l /var/www/html/prod/root/send_admin_notification_ses.php"

# Verificar logs do PHP-FPM (últimas 50 linhas)
ssh root@157.180.36.223 "tail -n 50 /var/log/php8.3-fpm.log | grep -i 'strlen\|TypeError\|ProfessionalLogger'"

# Testar endpoint de email (exemplo)
curl -X POST https://prod.bssegurosimediato.com.br/send_email_notification_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{
    "momento": "teste_producao",
    "ddd": "11",
    "celular": "987654321",
    "erro": null
  }'
```

**Critérios de Sucesso:**
- ✅ Sintaxe PHP verificada sem erros
- ✅ Logs do PHP-FPM não mostram erros de `strlen()`
- ✅ Endpoint de email responde sem HTTP 500
- ✅ Funcionalidade testada e funcionando corretamente

---

### **FASE 6: Verificação Final e Documentação**

**Objetivo:** Confirmar que todas as atualizações foram aplicadas e documentar processo  
**Estimativa de Tempo:** ~10 minutos

**Checklist Final:**
- [ ] Backups criados localmente (se arquivos existiam)
- [ ] Backups criados no servidor de produção
- [ ] Arquivos copiados de DEV para PROD local
- [ ] Hash SHA256 verificado após cópia local (DEV = PROD local)
- [ ] Arquivos copiados para servidor de produção
- [ ] Hash SHA256 verificado após cópia para servidor (local = servidor)
- [ ] Sintaxe PHP verificada no servidor
- [ ] Logs do PHP-FPM verificados sem erros
- [ ] Endpoint de email testado (se possível)
- [ ] Funcionalidade verificada em produção

**Documentação:**
- ✅ Criar relatório de execução da atualização
- ✅ Documentar hash SHA256 de todos os arquivos
- ✅ Documentar resultados dos testes
- ✅ Documentar qualquer problema encontrado

**Estimativa Total do Plano:** ~55 minutos (~1h)

---

## 🔄 Plano de Rollback

Se houver problemas após a atualização:

### **Rollback Imediato:**

1. **Restaurar arquivos do servidor de produção:**
   ```bash
   ssh root@157.180.36.223 "cp /var/www/html/prod/root/ProfessionalLogger.php.backup_ANTES_ATUALIZACAO_STRLEN_ARRAY_* /var/www/html/prod/root/ProfessionalLogger.php"
   ssh root@157.180.36.223 "cp /var/www/html/prod/root/send_admin_notification_ses.php.backup_ANTES_ATUALIZACAO_STRLEN_ARRAY_* /var/www/html/prod/root/send_admin_notification_ses.php"
   ```

2. **Restaurar arquivos localmente (se necessário):**
   - Copiar backups de `04-BACKUPS/` para `03-PRODUCTION/`

3. **Verificar funcionamento após rollback:**
   - Testar endpoint de email
   - Verificar logs do PHP-FPM

---

## 📊 Verificação de Hash SHA256

### **Arquivos em DEV (Origem):**

**Hash SHA256 dos arquivos em `02-DEVELOPMENT/`:**
- `ProfessionalLogger.php`: [SERÁ CALCULADO NA FASE 1]
- `send_admin_notification_ses.php`: [SERÁ CALCULADO NA FASE 1]

### **Arquivos em PROD Local:**

**Hash SHA256 após cópia de DEV para PROD local:**
- `ProfessionalLogger.php`: [SERÁ CALCULADO NA FASE 3] (deve coincidir com DEV)
- `send_admin_notification_ses.php`: [SERÁ CALCULADO NA FASE 3] (deve coincidir com DEV)

### **Arquivos no Servidor de Produção:**

**Hash SHA256 após cópia para servidor:**
- `ProfessionalLogger.php`: [SERÁ CALCULADO NA FASE 4] (deve coincidir com PROD local)
- `send_admin_notification_ses.php`: [SERÁ CALCULADO NA FASE 4] (deve coincidir com PROD local)

**Verificação Obrigatória:**
- Hash DEV = Hash PROD local (após FASE 3)
- Hash PROD local = Hash Servidor PROD (após FASE 4)
- Se hashes não coincidirem, tentar copiar novamente

---

## 🚨 Avisos Importantes

### ⚠️ **CACHE CLOUDFLARE - OBRIGATÓRIO**

Após atualizar arquivos `.php` no servidor de produção, **é necessário limpar o cache do Cloudflare** para que as alterações sejam refletidas imediatamente. O Cloudflare pode manter versões antigas em cache, causando erros como uso de código desatualizado.

**Ação Requerida:** Limpar cache do Cloudflare após conclusão da FASE 4.

### ⚠️ **PRODUÇÃO - PROCEDIMENTO ESPECIAL**

- 🚨 **ALERTA:** Este plano atualiza o servidor de produção
- ✅ **Seguir rigorosamente** todas as fases do processo sequencial obrigatório
- ✅ **NUNCA pular etapas** do processo
- ✅ **SEMPRE criar backups** antes de qualquer modificação
- ✅ **SEMPRE verificar hash SHA256** após cada cópia

---

## 📝 Documentação de Referência

- **Projeto Base:** `PROJETO_CORRIGIR_ERRO_HTTP_500_STRLEN_ARRAY_20251118.md` (Versão 1.1.0)
- **Relatório de Implementação DEV:** `RELATORIO_IMPLEMENTACAO_CORRECAO_STRLEN_ARRAY_20251118.md`
- **Análise do Erro:** `ANALISE_ERRO_STRLEN_ARRAY_20251118.md`
- **Diretivas do Projeto:** `.cursorrules`

---

## ✅ Critérios de Sucesso

1. ✅ Arquivos copiados de DEV para PROD local com hash SHA256 coincidindo
2. ✅ Arquivos copiados para servidor de produção com hash SHA256 coincidindo
3. ✅ Sintaxe PHP verificada sem erros no servidor
4. ✅ Logs do PHP-FPM não mostram erros de `strlen()`
5. ✅ Endpoint de email funciona sem HTTP 500 em produção
6. ✅ Funcionalidade testada e verificada em produção

---

## 📝 HISTÓRICO DE VERSÕES

### **Versão 1.2.0 (2025-11-18)**
- ✅ Adicionada seção "## 📋 CASOS DE USO" com 4 cenários explícitos
- ✅ Adicionada seção "Métricas de Performance" com métricas específicas
- ✅ Adicionada seção "Stakeholders" com responsabilidades definidas
- ✅ Correções para atingir 100% de conformidade com auditoria

### **Versão 1.1.0 (2025-11-18)**
- ✅ Correção: Comandos `scp` e PowerShell agora usam caminho completo do workspace
- ✅ Adicionado `cd` para diretório do workspace antes de executar comandos
- ✅ Correções baseadas em auditoria do plano

### **Versão 1.0.0 (2025-11-18)**
- ✅ Versão inicial do plano de atualização
- ✅ Baseado no fluxo obrigatório definido nas diretivas
- ✅ Todas as fases documentadas com comandos e verificações

---

**Status:** 📋 **PLANO CRIADO E 100% CONFORME**  
**Próximo Passo:** Aguardar autorização explícita do usuário para iniciar execução do plano

