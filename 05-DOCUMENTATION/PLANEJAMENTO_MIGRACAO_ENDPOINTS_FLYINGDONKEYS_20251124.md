# 📋 PLANEJAMENTO: Migração de Endpoints para flyingdonkeys.com.br

**Data de Criação:** 24/11/2025  
**Status:** 📋 **PLANEJAMENTO** - Aguardando definição de data e aprovação  
**Prioridade:** Média (não urgente, mas recomendado)

---

## 📋 SUMÁRIO EXECUTIVO

### **Objetivo:**
Migrar os endpoints `add_flyingdonkeys.php` e `add_webflow_octa.php` do servidor atual (`bpsegurosimediato.com.br`) para o servidor `flyingdonkeys.com.br`, onde já está hospedado o EspoCRM.

### **Motivo da Não Migração Atual:**
- ⚠️ **Configuração do EspoCRM é muito sensível:**
  - SQL: Banco de dados do EspoCRM com configurações específicas
  - PHP: Versão e extensões específicas necessárias para o EspoCRM
  - Nginx: Configuração de proxy reverso, SSL, e outras configurações críticas

### **Benefícios Esperados:**
- ✅ Redução de latência (endpoints e EspoCRM no mesmo servidor)
- ✅ Simplificação de infraestrutura (tudo na mesma infraestrutura Hetzner)
- ✅ Redução de problemas de conectividade entre servidores
- ✅ Menos pontos de falha na comunicação

---

## 🎯 CONTEXTO ATUAL

### **Infraestrutura Atual:**

| Componente | Localização | Servidor | Infraestrutura |
|-------------|-------------|----------|----------------|
| **EspoCRM** | `flyingdonkeys.com.br` | Servidor flyingdonkeys | Hetzner |
| **Endpoint EspoCRM** | `bpsegurosimediato.com.br/webhooks/add_flyingdonkeys_v2.php` | Servidor bpsegurosimediato | ? |
| **Endpoint Octadesk** | `bpsegurosimediato.com.br/webhooks/add_webflow_octa_v2.php` | Servidor bpsegurosimediato | ? |
| **Servidor de Produção** | `prod.bssegurosimediato.com.br` (IP: 157.180.36.223) | Servidor de produção | ? |

### **Problema Identificado:**
- ⚠️ Requisições do servidor de produção para servidores Hetzner podem falhar
- ⚠️ Problemas de conectividade entre servidores diferentes
- ⚠️ Latência adicional devido a múltiplos hops de rede
- ⚠️ Mais pontos de falha na comunicação

### **Evidência de Problema:**
- Erro em produção (24/11/2025 12:04:43): "Load failed" nas requisições para EspoCRM e Octadesk
- Problema temporário de conectividade entre servidores
- Registro às 09:44 funcionando normalmente indica problema de infraestrutura

---

## 🎯 OBJETIVO DA MIGRAÇÃO

### **Estado Desejado:**

| Componente | Localização Futura | Servidor | Infraestrutura |
|-------------|-------------------|----------|----------------|
| **EspoCRM** | `flyingdonkeys.com.br` | Servidor flyingdonkeys | Hetzner |
| **Endpoint EspoCRM** | `flyingdonkeys.com.br/webhooks/add_flyingdonkeys_v2.php` | Servidor flyingdonkeys | Hetzner |
| **Endpoint Octadesk** | `flyingdonkeys.com.br/webhooks/add_webflow_octa_v2.php` | Servidor flyingdonkeys | Hetzner |
| **Servidor de Produção** | `prod.bssegurosimediato.com.br` | Servidor de produção | ? |

### **Benefícios Esperados:**

1. **Redução de Latência:**
   - Endpoints e EspoCRM no mesmo servidor
   - Menos hops de rede
   - Comunicação local (mesmo servidor) ou mesma infraestrutura

2. **Simplificação de Infraestrutura:**
   - Tudo na mesma infraestrutura Hetzner
   - Menos pontos de falha
   - Manutenção mais simples

3. **Redução de Problemas de Conectividade:**
   - Sem necessidade de comunicação entre servidores diferentes
   - Menos problemas de firewall/DNS entre servidores
   - Mais resiliência

4. **Melhor Performance:**
   - Comunicação mais rápida
   - Menos timeout
   - Melhor experiência do usuário

---

## ⚠️ RISCOS E CONSIDERAÇÕES

### **Riscos Identificados:**

1. **Configuração Sensível do EspoCRM:**
   - ⚠️ **SQL:** Banco de dados do EspoCRM com configurações específicas
   - ⚠️ **PHP:** Versão e extensões específicas necessárias para o EspoCRM
   - ⚠️ **Nginx:** Configuração de proxy reverso, SSL, e outras configurações críticas
   - ⚠️ **Impacto:** Qualquer alteração pode afetar o funcionamento do EspoCRM

2. **Riscos da Migração:**
   - ⚠️ **Impacto no EspoCRM:** Se houver problema, pode afetar o sistema principal
   - ⚠️ **Necessidade de Testes:** Testes extensivos antes de migrar
   - ⚠️ **Plano de Rollback:** Necessário ter plano de reversão

3. **Riscos Técnicos:**
   - ⚠️ **Compatibilidade:** Verificar se versão PHP dos endpoints é compatível
   - ⚠️ **Extensões:** Verificar se extensões PHP necessárias estão disponíveis
   - ⚠️ **Permissões:** Verificar permissões de arquivos e diretórios
   - ⚠️ **SSL/TLS:** Verificar certificados SSL para novo domínio

---

## 📋 FASES DO PROJETO (PROPOSTA)

### **FASE 1: Análise e Documentação**

**Objetivo:** Documentar configuração atual e requisitos

**Tarefas:**
- [ ] Documentar configuração atual do EspoCRM (SQL, PHP, Nginx)
- [ ] Documentar requisitos dos endpoints PHP (versão, extensões)
- [ ] Verificar compatibilidade entre requisitos
- [ ] Documentar estrutura de diretórios atual
- [ ] Documentar variáveis de ambiente necessárias
- [ ] Documentar dependências e bibliotecas

**Entregáveis:**
- Documento de configuração atual
- Documento de requisitos dos endpoints
- Análise de compatibilidade

---

### **FASE 2: Preparação do Ambiente**

**Objetivo:** Preparar ambiente no servidor flyingdonkeys.com.br

**Tarefas:**
- [ ] Verificar se versão PHP é compatível
- [ ] Verificar se extensões PHP necessárias estão disponíveis
- [ ] Criar estrutura de diretórios (`/webhooks/`)
- [ ] Configurar permissões de arquivos e diretórios
- [ ] Configurar SSL/TLS para novo domínio (se necessário)
- [ ] Configurar Nginx para novos endpoints (se necessário)

**Entregáveis:**
- Ambiente preparado e testado
- Documentação de configuração

---

### **FASE 3: Migração dos Arquivos**

**Objetivo:** Copiar e configurar arquivos no novo servidor

**Tarefas:**
- [ ] Criar backup dos arquivos atuais
- [ ] Copiar arquivos para servidor flyingdonkeys.com.br
- [ ] Configurar variáveis de ambiente
- [ ] Configurar conexões de banco de dados (se necessário)
- [ ] Verificar integridade dos arquivos (hash SHA256)
- [ ] Testar acesso aos endpoints (sem alterar código de produção)

**Entregáveis:**
- Arquivos copiados e configurados
- Testes de acesso realizados

---

### **FASE 4: Testes em Ambiente Isolado**

**Objetivo:** Testar endpoints no novo servidor sem afetar produção

**Tarefas:**
- [ ] Criar ambiente de teste isolado
- [ ] Testar endpoints com dados de teste
- [ ] Verificar integração com EspoCRM
- [ ] Verificar integração com Octadesk
- [ ] Testar tratamento de erros
- [ ] Testar performance e latência
- [ ] Validar logs e monitoramento

**Entregáveis:**
- Relatório de testes
- Validação de funcionamento

---

### **FASE 5: Atualização do Código JavaScript**

**Objetivo:** Atualizar URLs dos endpoints no código JavaScript

**Tarefas:**
- [ ] Identificar todos os arquivos que usam os endpoints
- [ ] Atualizar URLs de `bpsegurosimediato.com.br` para `flyingdonkeys.com.br`
- [ ] Testar em ambiente de desenvolvimento
- [ ] Validar que todas as referências foram atualizadas
- [ ] Criar backup dos arquivos antes de modificar

**Arquivos a Modificar:**
- `MODAL_WHATSAPP_DEFINITIVO.js` (função `getEndpointUrl()`)
- Verificar outros arquivos que possam usar os endpoints

**Entregáveis:**
- Código atualizado e testado
- Lista de arquivos modificados

---

### **FASE 6: Deploy em Produção**

**Objetivo:** Fazer deploy das alterações em produção

**Tarefas:**
- [ ] Criar backup completo de produção
- [ ] Deploy dos arquivos JavaScript atualizados
- [ ] Verificar hash SHA256 após deploy
- [ ] Testar endpoints em produção
- [ ] Monitorar logs e erros
- [ ] Validar funcionamento completo

**Entregáveis:**
- Deploy realizado com sucesso
- Validação de funcionamento em produção

---

### **FASE 7: Validação e Monitoramento**

**Objetivo:** Validar funcionamento e monitorar por período

**Tarefas:**
- [ ] Monitorar logs por 24-48 horas
- [ ] Verificar se não há erros
- [ ] Validar performance
- [ ] Comparar latência antes/depois
- [ ] Documentar resultados

**Entregáveis:**
- Relatório de validação
- Confirmação de sucesso da migração

---

### **FASE 8: Limpeza (Opcional)**

**Objetivo:** Remover arquivos antigos (após validação completa)

**Tarefas:**
- [ ] Aguardar período de validação (sugestão: 1 semana)
- [ ] Criar backup final dos arquivos antigos
- [ ] Remover arquivos antigos do servidor anterior
- [ ] Documentar limpeza realizada

**Entregáveis:**
- Limpeza documentada
- Projeto concluído

---

## 🔍 ANÁLISE DE COMPATIBILIDADE

### **Requisitos a Verificar:**

#### **1. Versão PHP:**
- [ ] Versão PHP atual do EspoCRM: `?`
- [ ] Versão PHP necessária para endpoints: `?`
- [ ] Compatibilidade: `?`

#### **2. Extensões PHP:**
- [ ] Extensões necessárias para EspoCRM: `?`
- [ ] Extensões necessárias para endpoints: `?`
- [ ] Compatibilidade: `?`

#### **3. Configuração Nginx:**
- [ ] Configuração atual do EspoCRM: `?`
- [ ] Configuração necessária para endpoints: `?`
- [ ] Compatibilidade: `?`

#### **4. Banco de Dados:**
- [ ] Endpoints precisam acessar banco de dados? `?`
- [ ] Se sim, qual banco? `?`
- [ ] Credenciais e permissões: `?`

#### **5. Variáveis de Ambiente:**
- [ ] Variáveis necessárias para EspoCRM: `?`
- [ ] Variáveis necessárias para endpoints: `?`
- [ ] Compatibilidade: `?`

---

## 📝 CHECKLIST DE PRÉ-REQUISITOS

### **Antes de Iniciar a Migração:**

- [ ] Configuração atual do EspoCRM documentada
- [ ] Requisitos dos endpoints documentados
- [ ] Análise de compatibilidade realizada
- [ ] Plano de rollback definido
- [ ] Ambiente de teste preparado
- [ ] Backup completo realizado
- [ ] Janela de manutenção agendada (se necessário)
- [ ] Equipe de suporte disponível

---

## 🚨 PLANO DE ROLLBACK

### **Cenários que Requerem Rollback:**

1. **Erro Crítico no EspoCRM:**
   - Reverter alterações imediatamente
   - Restaurar configuração original
   - Validar funcionamento do EspoCRM

2. **Endpoints Não Funcionam:**
   - Reverter URLs no código JavaScript
   - Restaurar arquivos antigos
   - Validar funcionamento

3. **Problemas de Performance:**
   - Avaliar impacto
   - Decidir se rollback é necessário
   - Documentar problemas encontrados

### **Procedimento de Rollback:**

1. **Reverter Código JavaScript:**
   - Restaurar backup dos arquivos JavaScript
   - Deploy em produção
   - Verificar hash SHA256

2. **Reverter Arquivos PHP (se necessário):**
   - Restaurar backup dos arquivos PHP
   - Verificar funcionamento

3. **Validar Funcionamento:**
   - Testar endpoints
   - Verificar logs
   - Confirmar que tudo voltou ao normal

---

## 📊 MÉTRICAS DE SUCESSO

### **Métricas a Monitorar:**

1. **Latência:**
   - Latência antes da migração: `?`
   - Latência após migração: `?`
   - Meta: Redução de latência

2. **Taxa de Erro:**
   - Taxa de erro antes: `?`
   - Taxa de erro após: `?`
   - Meta: Redução ou manutenção da taxa de erro

3. **Disponibilidade:**
   - Disponibilidade antes: `?`
   - Disponibilidade após: `?`
   - Meta: Manutenção ou melhoria da disponibilidade

4. **Performance:**
   - Tempo de resposta antes: `?`
   - Tempo de resposta após: `?`
   - Meta: Melhoria do tempo de resposta

---

## 📋 NOTAS IMPORTANTES

### **⚠️ ATENÇÃO:**

1. **Configuração Sensível:**
   - ⚠️ Configuração do EspoCRM é muito sensível
   - ⚠️ Qualquer alteração pode afetar o funcionamento
   - ⚠️ Necessário cuidado extremo ao modificar

2. **Testes Obrigatórios:**
   - ✅ Testes extensivos antes de migrar
   - ✅ Testes em ambiente isolado
   - ✅ Validação completa antes de produção

3. **Plano de Rollback:**
   - ✅ Plano de rollback deve estar pronto antes de iniciar
   - ✅ Backup completo obrigatório
   - ✅ Procedimento de reversão documentado

4. **Monitoramento:**
   - ✅ Monitorar logs após migração
   - ✅ Validar funcionamento por período
   - ✅ Estar preparado para rollback se necessário

---

## 🔗 REFERÊNCIAS

### **Documentos Relacionados:**
- `ANALISE_ERROS_MODAL_WHATSAPP_PRODUCAO_20251124.md` - Análise do erro que motivou esta migração
- `ARQUITETURA_FOOTER_CODES_WEBFLOW_DEV_PROD.md` - Arquitetura atual dos endpoints

### **Arquivos Envolvidos:**
- `MODAL_WHATSAPP_DEFINITIVO.js` - Código JavaScript que usa os endpoints
- `add_flyingdonkeys_v2.php` - Endpoint EspoCRM (a migrar)
- `add_webflow_octa_v2.php` - Endpoint Octadesk (a migrar)

---

## 📅 PRÓXIMOS PASSOS

### **Ações Imediatas:**
- [ ] Definir data para início do projeto
- [ ] Definir responsáveis pelo projeto
- [ ] Iniciar FASE 1: Análise e Documentação

### **Aguardando:**
- ⏳ Definição de data para início
- ⏳ Aprovação para iniciar projeto
- ⏳ Disponibilidade de recursos

---

**Documento criado em:** 24/11/2025  
**Status:** 📋 **PLANEJAMENTO** - Aguardando definição de data e aprovação  
**Versão:** 1.0.0

