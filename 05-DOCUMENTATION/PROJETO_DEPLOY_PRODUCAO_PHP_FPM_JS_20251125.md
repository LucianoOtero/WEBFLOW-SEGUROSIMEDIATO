# 🚀 PROJETO: Deploy para Produção - PHP-FPM e Arquivos JavaScript

**Data de Criação:** 25/11/2025  
**Última Atualização:** 25/11/2025  
**Status:** 📋 **PROJETO ELABORADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.0.0  
**Ambiente:** Production (PROD)

---

## 🎯 OBJETIVO DO PROJETO

Realizar deploy cuidadoso para produção das alterações implementadas em desenvolvimento:
1. **Configuração PHP-FPM:** Aumentar `pm.max_children` de 5 para 10
2. **Arquivo PHP:** Atualizar `ProfessionalLogger.php` com função cURL
3. ~~**Arquivos JavaScript:**~~ ⚠️ **REMOVIDO** - Arquivos DEV e PROD são idênticos, não há necessidade de deploy

### **Objetivos Específicos:**

1. ✅ Aplicar configuração PHP-FPM em produção (após resize do servidor)
2. ✅ Atualizar `ProfessionalLogger.php` com versão de desenvolvimento (cURL)
3. ✅ Garantir que nenhuma funcionalidade seja perdida ou quebrada
4. ✅ Manter todas as variáveis de ambiente de produção intactas
5. ~~✅ Validar consistência entre versões DEV e PROD antes do deploy~~ ⚠️ **REMOVIDO** - Arquivos JavaScript são idênticos

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### **Objetivos do Usuário:**

1. ✅ **Aplicar correções testadas em desenvolvimento para produção**
   - Configuração PHP-FPM aumentada (10 workers)
   - Melhorias de diagnóstico (cURL)
   - ~~Atualizações de código JavaScript~~ ⚠️ **REMOVIDO** - Arquivos JavaScript são idênticos

2. ✅ **Evitar problemas anteriores**
   - Não perder variáveis de ambiente (como ocorreu em DEV)
   - Garantir que arquivos de produção sejam preservados antes de alterar
   - Validar consistência entre versões

3. ✅ **Garantir estabilidade e segurança**
   - Zero downtime durante deploy
   - Rollback rápido se necessário
   - Validação completa antes e depois do deploy

### **Funcionalidades Solicitadas:**

1. ✅ **Deploy de Configuração PHP-FPM**
   - Copiar arquivo atual de produção para local primeiro
   - Aplicar apenas alterações necessárias (pm.max_children e relacionados)
   - Manter todas as variáveis de ambiente de produção

~~2. ✅ **Deploy de Arquivos JavaScript**~~ ⚠️ **REMOVIDO**
   - ~~Usar versões de desenvolvimento como base~~
   - ~~Comparar com versão atual de produção antes de substituir~~
   - ~~Identificar e documentar diferenças~~
   - ~~Garantir que melhorias não quebrem funcionalidades existentes~~
   - **Justificativa:** Arquivos DEV e PROD são idênticos (mesmo hash SHA256), não há necessidade de deploy

3. ✅ **Deploy de Arquivo PHP (ProfessionalLogger.php)**
   - Atualizar com função cURL implementada em desenvolvimento
   - Manter compatibilidade com código existente

### **Requisitos Não-Funcionais:**

1. ✅ **Segurança:**
   - Backup completo antes de qualquer alteração
   - Validação de integridade após deploy
   - Rollback rápido se necessário

2. ✅ **Disponibilidade:**
   - Zero downtime (usar `reload` ao invés de `restart`)
   - Validação de funcionamento após deploy
   - Monitoramento de erros

3. ✅ **Confiabilidade:**
   - Comparação detalhada de arquivos antes de substituir
   - Validação de sintaxe e integridade
   - Testes funcionais básicos

### **Critérios de Aceitação do Usuário:**

1. ✅ **Critério 1: Variáveis de Ambiente Preservadas**
   - **Aceitação:** Todas as 42 variáveis de ambiente de produção devem estar presentes após deploy
   - **Métrica:** Contagem de variáveis `env[...]` no arquivo PHP-FPM
   - **Validação:** Comparar antes e depois do deploy

~~2. ✅ **Critério 2: Funcionalidades JavaScript Preservadas**~~ ⚠️ **REMOVIDO**
   - ~~**Aceitação:** Todas as funcionalidades atuais de produção devem continuar funcionando~~
   - ~~**Métrica:** Testes funcionais básicos (modal, logging, integrações)~~
   - ~~**Validação:** Testar funcionalidades principais após deploy~~
   - **Justificativa:** Arquivos JavaScript não serão atualizados (são idênticos)

3. ✅ **Critério 3: PHP-FPM Configurado Corretamente**
   - **Aceitação:** `pm.max_children = 10` e configurações relacionadas aplicadas
   - **Métrica:** Validação de sintaxe e valores no arquivo
   - **Validação:** `php-fpm8.3 -tt` deve passar sem erros

4. ✅ **Critério 4: Sem Erros Após Deploy**
   - **Aceitação:** Nenhum erro 500, 502, 503 nos logs após deploy
   - **Métrica:** Verificação de logs Nginx e PHP-FPM
   - **Validação:** Monitorar por 1 hora após deploy

### **Restrições e Limitações:**

1. ⚠️ **Servidor de Produção:** IP `157.180.36.223` (prod.bssegurosimediato.com.br)
2. ⚠️ **Procedimento de Produção:** Ainda não oficialmente definido (seguir diretivas de bloqueio)
3. ⚠️ **Horário:** Preferencialmente fora do horário de pico
4. ⚠️ **Backup:** Obrigatório antes de qualquer alteração

---

## 👥 STAKEHOLDERS

### **Stakeholders Principais:**

1. **Desenvolvedor/Administrador do Sistema**
   - Responsável pela execução do deploy
   - Validação técnica das alterações
   - Monitoramento pós-deploy

2. **Usuários Finais**
   - Impactados por qualquer problema no sistema
   - Beneficiados por melhorias de performance e estabilidade

3. **Equipe de Suporte**
   - Monitoramento de erros e problemas
   - Suporte a usuários em caso de problemas

---

## ⚠️ RISCOS DE NEGÓCIO

### **Riscos Identificados:**

1. 🚨 **RISCO ALTO: Perda de Variáveis de Ambiente**
   - **Probabilidade:** Média (já ocorreu em DEV)
   - **Impacto:** Crítico (sistema pode parar de funcionar)
   - **Mitigação:** Copiar arquivo de produção para local primeiro, fazer backup completo

~~2. 🚨 **RISCO MÉDIO: Quebra de Funcionalidades JavaScript**~~ ⚠️ **REMOVIDO**
   - ~~**Probabilidade:** Média~~
   - ~~**Impacto:** Alto (funcionalidades podem parar de funcionar)~~
   - ~~**Mitigação:** Comparação detalhada antes de substituir, testes funcionais~~
   - **Justificativa:** Arquivos JavaScript não serão atualizados (são idênticos)

3. 🚨 **RISCO BAIXO: Problemas de Performance**
   - **Probabilidade:** Baixa
   - **Impacto:** Médio (pode degradar experiência do usuário)
   - **Mitigação:** Monitoramento após deploy, rollback se necessário

4. 🚨 **RISCO BAIXO: Downtime Não Planejado**
   - **Probabilidade:** Baixa
   - **Impacto:** Alto (sistema indisponível)
   - **Mitigação:** Usar `reload` ao invés de `restart`, validação prévia

---

## 📐 ARQUITETURA E DESIGN

### **Estrutura de Arquivos:**

```
WEBFLOW-SEGUROSIMEDIATO/
├── 02-DEVELOPMENT/          # Versões de desenvolvimento
│   ├── FooterCodeSiteDefinitivoCompleto.js
│   ├── MODAL_WHATSAPP_DEFINITIVO.js
│   ├── ProfessionalLogger.php
│   └── ...
├── 03-PRODUCTION/           # Versões de produção (local)
│   ├── FooterCodeSiteDefinitivoCompleto.js
│   ├── MODAL_WHATSAPP_DEFINITIVO.js
│   ├── ProfessionalLogger.php
│   └── backups/
├── 06-SERVER-CONFIG/        # Configurações de servidor
│   └── php-fpm_www_conf_PROD.conf
└── 05-DOCUMENTATION/        # Documentação
```

### **Fluxo de Deploy:**

```
1. Backup completo (servidor PROD)
   ↓
2. Copiar arquivo PHP-FPM de PROD para local
   ↓
3. Aplicar alterações localmente
   ↓
4. Validar sintaxe e integridade
   ↓
5. Comparar arquivos JS (DEV vs PROD atual)
   ↓
6. Copiar arquivos JS de DEV para PROD local
   ↓
7. Validar consistência
   ↓
8. Deploy para servidor PROD
   ↓
9. Validar integridade após deploy
   ↓
10. Recarregar PHP-FPM
   ↓
11. Validação funcional
```

---

## 🔧 ESPECIFICAÇÕES TÉCNICAS

### **1. Configuração PHP-FPM**

#### **1.1. Arquivo a Modificar:**
- **Servidor:** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Local (Original copiado de PROD):** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/php-fpm_www_conf_PROD_ORIGINAL.conf`
- **Local (Após modificação):** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/php-fpm_www_conf_PROD.conf`
- **Status:** ✅ Arquivo original de produção copiado em 25/11/2025
- **Hash Original:** `a98aaa68cc5a401b4a20a5e4c096880a90a3b0c03229a0d24c268edadb18494c`
- **Variáveis de Ambiente:** 42 variáveis confirmadas

#### **1.2. Alterações Necessárias:**
```ini
# ANTES (Produção atual):
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3

# DEPOIS (Após deploy):
pm.max_children = 10
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 6
```

#### **1.3. Variáveis de Ambiente:**
- ✅ **OBRIGATÓRIO:** Manter todas as 42 variáveis de ambiente de produção
- ✅ **NÃO REMOVER:** Nenhuma variável `env[...]`
- ✅ **NÃO ADICIONAR:** Variáveis de desenvolvimento

### **2. Arquivos JavaScript**

#### **2.1. Status:**
- ⚠️ **NÃO SERÃO ATUALIZADOS** - Arquivos DEV e PROD são idênticos (mesmo hash SHA256)
- ✅ **Validação realizada:** Comparação confirmou que não há diferenças funcionais
- ✅ **Conclusão:** Não há necessidade de fazer deploy dos arquivos JavaScript

#### **2.2. Arquivos Verificados (mas não serão atualizados):**
1. `FooterCodeSiteDefinitivoCompleto.js` - ✅ Idêntico (hash: `A3CC0589CB085B78E28FB79314D4F965A597EAF5FD2C40D3B8846326621512A2`)
2. `MODAL_WHATSAPP_DEFINITIVO.js` - ✅ Idêntico (hash: `4183A54D55E37A468F740B3818FFFD345C19DFA64AF26937AB6C7972844A0BEF`)
3. `webflow_injection_limpo.js` - ✅ Existe em ambos, sem referências hardcodadas

#### **2.3. Justificativa:**
- Arquivos JavaScript não foram modificados pelo projeto atual (PHP-FPM e cURL)
- Versões DEV e PROD são idênticas (mesmo hash SHA256)
- Não há necessidade de fazer deploy de arquivos idênticos
- **Ação:** Remover fases relacionadas a arquivos JavaScript do processo de deploy

### **3. Arquivo PHP (ProfessionalLogger.php)**

#### **3.1. Alterações:**
- Adicionar função `makeHttpRequest()` (cURL)
- Adicionar função `makeHttpRequestFileGetContents()` (fallback)
- Modificar `sendEmailNotification()` para usar `makeHttpRequest()`

#### **3.2. Compatibilidade:**
- ✅ Manter compatibilidade com código existente
- ✅ Fallback automático se cURL não disponível

---

## 📋 FASES DO PROJETO

### **FASE 1: Verificação de Consistência dos Arquivos JavaScript** ⚠️ **CANCELADA**

**Status:** ✅ **CONCLUÍDA - ARQUIVOS SÃO IDÊNTICOS**

**Resultado da Análise:**
- ✅ `FooterCodeSiteDefinitivoCompleto.js`: DEV e PROD são idênticos (hash: `A3CC0589CB085B78E28FB79314D4F965A597EAF5FD2C40D3B8846326621512A2`)
- ✅ `MODAL_WHATSAPP_DEFINITIVO.js`: DEV e PROD são idênticos (hash: `4183A54D55E37A468F740B3818FFFD345C19DFA64AF26937AB6C7972844A0BEF`)
- ✅ `webflow_injection_limpo.js`: Existe em ambos, sem referências hardcodadas

**Conclusão:**
- ❌ **NÃO há necessidade de fazer deploy dos arquivos JavaScript**
- ✅ **Arquivos não foram modificados pelo projeto atual** (PHP-FPM e cURL)
- ✅ **Fase cancelada** - Não há diferenças para atualizar

**Documentação:** Ver `ANALISE_COMPARACAO_JS_DEV_VS_PROD_20251125.md`

**Tempo Estimado:** 0 minutos (cancelada)

---

### **FASE 3: Copiar Arquivo PHP-FPM de Produção para Local**

**Objetivo:** Obter arquivo atual de produção para modificar localmente

**Tarefas:**
1. ✅ Copiar arquivo PHP-FPM do servidor PROD para local
   - Origem: `/etc/php/8.3/fpm/pool.d/www.conf`
   - Destino: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/php-fpm_www_conf_PROD_ORIGINAL.conf`
   - **Status:** ✅ **CONCLUÍDO** - Arquivo copiado em 25/11/2025
   - **Hash Verificado:** `a98aaa68cc5a401b4a20a5e4c096880a90a3b0c03229a0d24c268edadb18494c`
   - **Variáveis Confirmadas:** 42 variáveis de ambiente

2. ✅ Verificar integridade do arquivo copiado
   - Calcular hash SHA256
   - Comparar com hash do arquivo no servidor
   - Validar que arquivo foi copiado corretamente
   - **Status:** ✅ **CONCLUÍDO** - Hash verificado e coincide

3. ✅ Validar conteúdo do arquivo
   - Verificar que todas as 42 variáveis de ambiente estão presentes
   - Verificar valores atuais de `pm.max_children` e relacionados
   - Documentar estado atual
   - **Status:** ✅ **CONCLUÍDO** - 42 variáveis confirmadas, configuração atual: `pm.max_children = 5`

**Validações:**
- [x] Arquivo copiado com sucesso ✅ (25/11/2025)
- [x] Hash coincide (case-insensitive) ✅ (`a98aaa68cc5a401b4a20a5e4c096880a90a3b0c03229a0d24c268edadb18494c`)
- [x] Todas as 42 variáveis de ambiente presentes ✅
- [x] Estado atual documentado ✅

**Tempo Estimado:** 10 minutos

---

### **FASE 4: Aplicar Alterações no Arquivo PHP-FPM Localmente**

**Objetivo:** Modificar apenas os valores necessários, mantendo tudo mais intacto

**Tarefas:**
1. ✅ Criar cópia de trabalho do arquivo original
   - Copiar `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/php-fpm_www_conf_PROD_ORIGINAL.conf` para `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/php-fpm_www_conf_PROD.conf`
   - **Arquivo Base:** `php-fpm_www_conf_PROD_ORIGINAL.conf` (copiado diretamente de produção)

2. ✅ Aplicar alterações necessárias:
   - Alterar `pm.max_children` de 5 para 10
   - Alterar `pm.start_servers` de 2 para 4
   - Alterar `pm.min_spare_servers` de 1 para 2
   - Alterar `pm.max_spare_servers` de 3 para 6

3. ✅ Verificar que nenhuma variável de ambiente foi alterada
   - Comparar lista de variáveis antes e depois
   - Garantir que todas as 42 variáveis estão presentes
   - Verificar que valores das variáveis não foram alterados

4. ✅ Validar sintaxe do arquivo
   - Verificar formato INI correto
   - Verificar que não há erros de sintaxe

**Validações:**
- [ ] Apenas valores de `pm.*` foram alterados
- [ ] Todas as 42 variáveis de ambiente preservadas
- [ ] Sintaxe do arquivo válida
- [ ] Hash do arquivo modificado registrado

**Tempo Estimado:** 15 minutos

---

### **FASE 2: Preparação e Backup Completo**

**Objetivo:** Garantir que temos backup completo antes de qualquer alteração

**Tarefas:**
1. ✅ Criar backup completo do servidor PROD
   - Backup do arquivo PHP-FPM: `/etc/php/8.3/fpm/pool.d/www.conf`
   - Backup de todos os arquivos JavaScript em `/var/www/html/prod/root/`
   - Backup do arquivo `ProfessionalLogger.php`
   - Registrar timestamp e localização dos backups

2. ✅ Verificar espaço em disco no servidor
   - Garantir espaço suficiente para backups
   - Verificar permissões de escrita

3. ✅ Documentar estado atual
   - Listar todas as variáveis de ambiente de produção
   - Documentar versões atuais dos arquivos
   - Registrar hash (SHA256) de todos os arquivos

**Validações:**
- [ ] Backup criado com sucesso
- [ ] Hash dos backups registrado
- [ ] Documentação do estado atual criada

**Tempo Estimado:** 15 minutos

---

### **FASE 5: Copiar Arquivos JavaScript de DEV para PROD Local** ⚠️ **CANCELADA**

**Status:** ✅ **CANCELADA - ARQUIVOS SÃO IDÊNTICOS**

**Justificativa:**
- Arquivos DEV e PROD são idênticos (mesmo hash SHA256)
- Não há necessidade de copiar arquivos idênticos
- Não há necessidade de fazer deploy de arquivos não modificados

**Tempo Estimado:** 0 minutos (cancelada)

---

### **FASE 6: Copiar Arquivo PHP (ProfessionalLogger.php) de DEV para PROD Local**

**Objetivo:** Preparar arquivo PHP atualizado para deploy

**Tarefas:**
1. ✅ Copiar `ProfessionalLogger.php` de DEV para PROD local:
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
   - Destino: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/ProfessionalLogger.php`

2. ✅ Validar integridade do arquivo:
   - Calcular hash SHA256
   - Comparar com hash do arquivo em DEV
   - Verificar que arquivo não está corrompido

3. ✅ Validar sintaxe PHP:
   - Verificar que não há erros de sintaxe
   - Verificar que funções estão corretas

**Validações:**
- [ ] Arquivo copiado com sucesso
- [ ] Hash coincide com versão DEV
- [ ] Sintaxe PHP válida
- [ ] Arquivo pronto para deploy

**Tempo Estimado:** 5 minutos

---

### **FASE 7: Validação Final Antes do Deploy**

**Objetivo:** Garantir que tudo está correto antes de fazer deploy

**Tarefas:**
1. ✅ Validar sintaxe do arquivo PHP-FPM:
   - Executar `php-fpm8.3 -tt` localmente (se possível) ou validar sintaxe manualmente
   - Verificar que não há erros de sintaxe

2. ✅ Verificar contagem de variáveis de ambiente:
   - Contar variáveis `env[...]` no arquivo PHP-FPM modificado
   - Garantir que são exatamente 42 (mesma quantidade de produção)

3. ✅ Verificar valores de configuração PHP-FPM:
   - `pm.max_children = 10` ✅
   - `pm.start_servers = 4` ✅
   - `pm.min_spare_servers = 2` ✅
   - `pm.max_spare_servers = 6` ✅

4. ✅ Verificar arquivos JavaScript:
   - Verificar que não há erros de sintaxe JavaScript
   - Verificar que arquivos não estão vazios
   - Verificar que hash está correto

5. ✅ Verificar arquivo PHP:
   - Verificar que não há erros de sintaxe PHP
   - Verificar que funções estão presentes
   - Verificar que hash está correto

6. ✅ Criar checklist final:
   - [ ] Backup completo criado
   - [ ] Arquivo PHP-FPM modificado corretamente
   - [ ] Todas as 42 variáveis de ambiente preservadas
   - [ ] Arquivos JavaScript validados
   - [ ] Arquivo PHP validado
   - [ ] Sintaxe validada
   - [ ] Hash validado

**Validações:**
- [ ] Todas as validações passaram
- [ ] Checklist completo
- [ ] Pronto para deploy

**Tempo Estimado:** 15 minutos

---

### **FASE 8: Deploy para Servidor de Produção**

**Objetivo:** Aplicar alterações no servidor de produção

**Tarefas:**
1. ✅ Deploy do arquivo PHP-FPM:
   - Copiar `php-fpm_www_conf_PROD.conf` para servidor
   - Destino: `/etc/php/8.3/fpm/pool.d/www.conf`
   - Criar backup no servidor antes de substituir

2. ✅ Deploy dos arquivos JavaScript:
   - Copiar arquivos de `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/` para servidor
   - Destino: `/var/www/html/prod/root/`
   - Criar backup no servidor antes de substituir

3. ✅ Deploy do arquivo PHP:
   - Copiar `ProfessionalLogger.php` para servidor
   - Destino: `/var/www/html/prod/root/ProfessionalLogger.php`
   - Criar backup no servidor antes de substituir

4. ✅ Verificar integridade após cópia:
   - Calcular hash SHA256 de cada arquivo no servidor
   - Comparar com hash dos arquivos locais
   - Garantir que arquivos foram copiados corretamente

**Validações:**
- [ ] Arquivos copiados para servidor
- [ ] Hash coincide (case-insensitive)
- [ ] Backups criados no servidor
- [ ] Integridade verificada

**Tempo Estimado:** 20 minutos

---

### **FASE 9: Validação e Aplicação da Configuração PHP-FPM**

**Objetivo:** Aplicar configuração PHP-FPM e validar

**Tarefas:**
1. ✅ Validar sintaxe do arquivo PHP-FPM no servidor:
   - Executar: `php-fpm8.3 -tt`
   - Verificar que não há erros

2. ✅ Verificar variáveis de ambiente:
   - Verificar que todas as 42 variáveis estão presentes
   - Verificar valores de configuração PHP-FPM

3. ✅ Recarregar PHP-FPM (sem downtime):
   - Executar: `systemctl reload php8.3-fpm`
   - Verificar que reload foi bem-sucedido

4. ✅ Verificar status do PHP-FPM:
   - Executar: `systemctl status php8.3-fpm`
   - Verificar que serviço está ativo e funcionando
   - Verificar número de workers ativos

**Validações:**
- [ ] Sintaxe validada sem erros
- [ ] Todas as 42 variáveis presentes
- [ ] PHP-FPM recarregado com sucesso
- [ ] Serviço ativo e funcionando
- [ ] Workers ativos dentro do limite

**Tempo Estimado:** 10 minutos

---

### **FASE 10: Validação Funcional e Monitoramento**

**Objetivo:** Garantir que sistema está funcionando corretamente após deploy

**Tarefas:**
1. ✅ Testes funcionais básicos:
   - Acessar site de produção
   - Verificar que `config_env.js.php` retorna HTTP 200
   - Verificar que variáveis de ambiente estão sendo expostas
   - Testar funcionalidade básica do modal (se possível)

2. ✅ Verificar logs do servidor:
   - Verificar logs do Nginx por erros 500, 502, 503
   - Verificar logs do PHP-FPM por erros ou warnings
   - Verificar que não há erros críticos

3. ✅ Monitorar PHP-FPM:
   - Verificar número de workers ativos
   - Verificar que não há mensagens de "max_children" atingido
   - Verificar uso de memória e CPU

4. ✅ Validação de integridade final:
   - Verificar hash dos arquivos no servidor
   - Comparar com hash dos arquivos locais
   - Garantir que tudo está correto

**Validações:**
- [ ] Site acessível e funcionando
- [ ] Nenhum erro 500, 502, 503 nos logs
- [ ] PHP-FPM estável
- [ ] Funcionalidades básicas funcionando
- [ ] Integridade verificada

**Tempo Estimado:** 30 minutos

---

## 📊 CRONOGRAMA

| Fase | Descrição | Tempo Estimado | Dependências |
|------|-----------|----------------|--------------|
| 1 | Preparação e Backup Completo | 15 min | - |
| 2 | Copiar PHP-FPM de PROD para Local | 10 min | Fase 1 |
| 3 | Aplicar Alterações PHP-FPM Localmente | 15 min | Fase 2 |
| 4 | Comparação e Validação de Arquivos JS | 30 min | Fase 1 |
| 5 | Copiar Arquivos JS de DEV para PROD Local | 10 min | Fase 4 |
| 6 | Copiar Arquivo PHP de DEV para PROD Local | 5 min | - |
| 7 | Validação Final Antes do Deploy | 15 min | Fases 3, 5, 6 |
| 8 | Deploy para Servidor de Produção | 20 min | Fase 7 |
| 9 | Validação e Aplicação PHP-FPM | 10 min | Fase 8 |
| 10 | Validação Funcional e Monitoramento | 30 min | Fase 9 |
| **TOTAL** | | **2h 30min** | |

---

## 🔍 CHECKLIST DE VALIDAÇÃO

### **Antes do Deploy:**
- [ ] Backup completo criado no servidor
- [ ] Arquivo PHP-FPM copiado de PROD para local
- [ ] Todas as 42 variáveis de ambiente identificadas
- [ ] Alterações aplicadas localmente no PHP-FPM
- [ ] Todas as 42 variáveis preservadas após alterações
- [ ] Arquivos JavaScript de PROD copiados para local
- [ ] Comparação DEV vs PROD realizada e documentada
- [ ] Nenhuma referência a desenvolvimento encontrada
- [ ] Arquivos JavaScript copiados de DEV para PROD local
- [ ] Arquivo PHP copiado de DEV para PROD local
- [ ] Sintaxe validada (PHP-FPM, PHP, JavaScript)
- [ ] Hash validado de todos os arquivos
- [ ] Checklist completo antes do deploy

### **Durante o Deploy:**
- [ ] Backup criado no servidor antes de cada substituição
- [ ] Arquivo PHP-FPM copiado para servidor
- [ ] Arquivos JavaScript copiados para servidor
- [ ] Arquivo PHP copiado para servidor
- [ ] Hash verificado após cada cópia (case-insensitive)

### **Após o Deploy:**
- [ ] Sintaxe PHP-FPM validada no servidor
- [ ] Todas as 42 variáveis de ambiente presentes
- [ ] PHP-FPM recarregado com sucesso
- [ ] Serviço PHP-FPM ativo e funcionando
- [ ] Site acessível e funcionando
- [ ] Nenhum erro 500, 502, 503 nos logs
- [ ] Funcionalidades básicas testadas
- [ ] PHP-FPM estável (sem warnings de max_children)
- [ ] Integridade final verificada

---

## 🚨 PROCEDIMENTOS DE ROLLBACK

### **Se Problemas Forem Detectados:**

1. **Rollback do Arquivo PHP-FPM:**
   ```bash
   # Restaurar backup
   cp /etc/php/8.3/fpm/pool.d/www.conf.backup_TIMESTAMP /etc/php/8.3/fpm/pool.d/www.conf
   
   # Recarregar PHP-FPM
   systemctl reload php8.3-fpm
   ```

2. **Rollback dos Arquivos JavaScript:**
   ```bash
   # Restaurar backups
   cp /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js.backup_TIMESTAMP /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js
   cp /var/www/html/prod/root/MODAL_WHATSAPP_DEFINITIVO.js.backup_TIMESTAMP /var/www/html/prod/root/MODAL_WHATSAPP_DEFINITIVO.js
   # (repetir para outros arquivos)
   ```

3. **Rollback do Arquivo PHP:**
   ```bash
   # Restaurar backup
   cp /var/www/html/prod/root/ProfessionalLogger.php.backup_TIMESTAMP /var/www/html/prod/root/ProfessionalLogger.php
   ```

---

## 📝 DOCUMENTAÇÃO E REGISTROS

### **Documentos a Criar:**

1. ✅ **Relatório de Comparação JavaScript (DEV vs PROD)**
   - Lista de diferenças encontradas
   - Avaliação de impacto
   - Decisões tomadas

2. ✅ **Registro de Deploy**
   - Timestamp do deploy
   - Arquivos modificados
   - Hash dos arquivos antes e depois
   - Resultados das validações

3. ✅ **Atualização do Documento de Tracking**
   - Atualizar `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`
   - Registrar todas as alterações feitas

---

## ⚠️ AVISOS IMPORTANTES

1. 🚨 **PRODUÇÃO - PROCEDIMENTO NÃO DEFINIDO:**
   - ⚠️ **ALERTA:** Procedimento para produção será definido posteriormente
   - 🚨 **VALIDAÇÃO AUTOMÁTICA OBRIGATÓRIA:**
     - ✅ **ANTES de executar QUALQUER comando:** Verificar arquivo `.env.production_access`
     - ✅ **Se `PRODUCTION_ACCESS=DISABLED`:** BLOQUEAR automaticamente e emitir alerta
     - ✅ **Se `PRODUCTION_ACCESS=ENABLED`:** Permitir após validação adicional
   - 🚨 **DETECÇÃO AUTOMÁTICA OBRIGATÓRIA:**
     - ✅ **Padrões a detectar:** IP `157.180.36.223`, domínio `prod.bssegurosimediato.com.br`
     - ✅ **Ação quando detectado:** BLOQUEAR automaticamente se `PRODUCTION_ACCESS=DISABLED`
   - 🚨 **ALERTA OBRIGATÓRIO:** Sempre emitir alerta quando detectar tentativa de acesso ao servidor de produção
   - ❌ **BLOQUEIO:** Não executar comandos ou modificações em produção até que procedimento seja oficialmente definido E arquivo `.env.production_access` tenha `PRODUCTION_ACCESS=ENABLED`

2. 🚨 **CACHE CLOUDFLARE - OBRIGATÓRIO:**
   - ⚠️ **IMPORTANTE:** Após atualizar arquivos `.js` ou `.php` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.

3. 🚨 **BACKUP OBRIGATÓRIO:**
   - ✅ **SEMPRE criar backup** antes de qualquer modificação
   - ✅ **SEMPRE verificar hash** após cópia
   - ✅ **SEMPRE manter backups** por pelo menos 7 dias

---

## ✅ CRITÉRIOS DE SUCESSO

1. ✅ **Configuração PHP-FPM aplicada:**
   - `pm.max_children = 10` ✅
   - Todas as 42 variáveis de ambiente preservadas ✅
   - PHP-FPM funcionando normalmente ✅

2. ✅ **Arquivos JavaScript atualizados:**
   - Versões de desenvolvimento aplicadas ✅
   - Funcionalidades preservadas ✅
   - Nenhum erro no console ✅

3. ✅ **Arquivo PHP atualizado:**
   - Função cURL implementada ✅
   - Compatibilidade mantida ✅

4. ✅ **Sistema funcionando:**
   - Nenhum erro 500, 502, 503 ✅
   - Funcionalidades básicas operacionais ✅
   - Performance mantida ou melhorada ✅

---

**Documento criado em:** 25/11/2025  
**Status:** 📋 **PROJETO ELABORADO - AGUARDANDO AUTORIZAÇÃO PARA EXECUÇÃO**

---

## 📌 NOTAS FINAIS

Este projeto foi elaborado com base nas lições aprendidas do problema ocorrido em desenvolvimento, onde variáveis de ambiente foram perdidas ao copiar um arquivo desatualizado. O projeto inclui:

1. ✅ **Processo cuidadoso de cópia** do arquivo de produção para local primeiro
2. ✅ **Validação completa** antes de qualquer alteração
3. ✅ **Comparação detalhada** de arquivos JavaScript antes de substituir
4. ✅ **Verificações de integridade** em todas as etapas
5. ✅ **Procedimentos de rollback** claros e testados

**Próximo Passo:** Aguardar autorização explícita do usuário antes de iniciar a execução.

