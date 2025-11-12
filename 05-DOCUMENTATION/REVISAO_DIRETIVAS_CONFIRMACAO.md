# ✅ REVISÃO COMPLETA DAS DIRETIVAS - CONFIRMAÇÃO DE ENTENDIMENTO

**Data:** 11/11/2025  
**Status:** ✅ **REVISADO E CONFIRMADO**

---

## 🚨 REGRAS CRÍTICAS - PRIORIDADE MÁXIMA

### **1. Autorização Prévia para Modificações**
✅ **ENTENDIDO:**
- ❌ **NUNCA** modificar código fora de projeto autorizado
- ✅ **SEMPRE** perguntar: "Posso iniciar o projeto X agora?"
- ✅ Aguardar autorização **EXPLÍCITA** antes de começar
- ✅ Dentro de projeto autorizado: Não pedir autorização para cada arquivo
- ⚠️ Projetos isolados: Sempre perguntar antes de modificar

**⚠️ PONTO CRÍTICO:** Não assumir autorização - sempre perguntar primeiro

---

### **2. Modificação de Arquivos JavaScript**
✅ **ENTENDIDO:**
- ❌ **NUNCA** modificar `.js` diretamente no servidor
- ✅ **SEMPRE** modificar localmente em `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`
- ✅ Deploy via scripts/comandos autorizados após modificação local

**⚠️ PONTO CRÍTICO:** Mesmo para pequenas correções, sempre modificar localmente primeiro

---

### **3. Modificação de Arquivos PHP**
✅ **ENTENDIDO:**
- ❌ **NUNCA** modificar `.php` diretamente no servidor
- ✅ **SEMPRE** modificar localmente em `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/` primeiro
- ✅ **SEMPRE** criar backup do arquivo original ANTES de modificar
- ✅ Deploy via scripts/comandos autorizados após modificação local e backup
- ❌ **NUNCA** modificar configurações Nginx e PHP quando estão funcionando
- ⚠️ Sempre confirmar antes de modificar configurações de infraestrutura

**⚠️ PONTO CRÍTICO:** Backup é OBRIGATÓRIO antes de qualquer modificação PHP

---

### **4. Servidores com Acesso SSH**
✅ **ENTENDIDO:**
- ❌ **NUNCA** modificar ou criar arquivos diretamente no servidor
- ✅ **SEMPRE** criar arquivos localmente no Windows primeiro
- ✅ **SEMPRE** criar backup antes de qualquer modificação
- ✅ **SEMPRE** copiar arquivos do Windows para servidor (via scp, scripts, etc.)
- ❌ **SEM EXCEÇÕES** - Nunca modificar diretamente no servidor

**⚠️ PONTO CRÍTICO:** Mesmo quando autorizado, criar localmente primeiro e copiar depois

---

### **5. Arquivos de Configuração de Servidor**
✅ **ENTENDIDO:**
- ❌ **NUNCA** criar arquivos de configuração diretamente no servidor
- ✅ **SEMPRE** criar localmente primeiro
- ✅ **SEMPRE** criar em `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/`
- ✅ **SEMPRE** copiar para servidor via SCP após criação local
- ❌ **NUNCA** usar heredoc ou comandos inline complexos no servidor
- ✅ **SEMPRE** usar arquivo local + SCP

**Estrutura de diretório:**
- Nginx: `nginx_*.conf`
- PHP-FPM: `php-fpm_*.conf`
- systemd: `*.service`
- Scripts: `*.sh`

**⚠️ PONTO CRÍTICO:** Criar localmente em `06-SERVER-CONFIG/` e copiar via SCP

---

### **6. Organização de Arquivos no Diretório DEV**
✅ **ENTENDIDO:**
- ❌ **NUNCA** criar arquivos novos diretamente no raiz de `02-DEVELOPMENT/`
- ✅ **SEMPRE** criar novos arquivos nos diretórios apropriados:
  - 📁 Documentação: `05-DOCUMENTATION/`
  - 📁 Backups: `02-DEVELOPMENT/backups/` ou `04-BACKUPS/`
  - 📁 Testes: `02-DEVELOPMENT/TMP/`
  - 📁 Configuração: `06-SERVER-CONFIG/`
  - 📁 Scripts Deploy: `02-DEVELOPMENT/` (apenas essenciais)
- ✅ Arquivos do projeto (JS/PHP principais) no raiz de `02-DEVELOPMENT/`
- ✅ Arquivos auxiliares em subdiretórios apropriados

**⚠️ PONTO CRÍTICO:** Não criar arquivos novos no raiz - usar subdiretórios apropriados

---

### **7. Comandos de Parada**
✅ **ENTENDIDO:**
- 🛑 Quando usuário disser "Pare", "Não pode fazer isso" → **PARAR IMEDIATAMENTE**
- 🛑 Não continuar com ação rejeitada
- 🛑 Aguardar novas instruções antes de prosseguir

**⚠️ PONTO CRÍTICO:** Parar imediatamente quando solicitado, sem questionar

---

## 📋 DIRETIVAS DE IMPLEMENTAÇÃO

### **Variáveis de Ambiente**
✅ **ENTENDIDO:**
- ✅ **SEMPRE** usar variáveis de ambiente do Docker (`APP_BASE_DIR`, `APP_BASE_URL`, etc.)
- ✅ **SEMPRE** usar variáveis de sistema via `$_ENV` no PHP
- ❌ **NÃO** criar sistemas de configuração complexos
- ✅ Usar variáveis globais simples quando necessário

---

### **Estrutura de Arquivos**
✅ **ENTENDIDO:**
- ✅ Arquivos `.js` e `.php` no mesmo diretório raiz
- ✅ Acessíveis via `https://dev.bssegurosimediato.com.br/` (dev) ou `https://bssegurosimediato.com.br/` (prod)
- ✅ Modificações sempre começam localmente em `02-DEVELOPMENT/`
- ✅ Arquivos de configuração em `06-SERVER-CONFIG/`

---

### **Fluxo de Trabalho (OBRIGATÓRIO)**
✅ **ENTENDIDO - SEQUÊNCIA CORRETA:**
1. ✅ **Criar backup** do arquivo original (se existir)
2. ✅ **Modificar localmente** → `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`
3. ✅ **Testar localmente** (quando possível)
4. ✅ **Deploy para servidor** via scripts/comandos autorizados
5. ✅ **Verificar funcionamento** no servidor
6. ✅ **OBRIGATÓRIO: Realizar auditoria pós-implementação**

**⚠️ PONTO CRÍTICO:** Auditoria é OBRIGATÓRIA e deve ser o último passo

---

### **Fluxo para Arquivos de Configuração de Servidor**
✅ **ENTENDIDO:**
1. ✅ Criar arquivo localmente → `06-SERVER-CONFIG/`
2. ✅ Verificar sintaxe (quando possível)
3. ✅ Copiar para servidor via SCP
4. ✅ Aplicar configuração no servidor (reload/restart)
5. ✅ Verificar funcionamento no servidor

---

### **Auditoria Pós-Implementação (OBRIGATÓRIA)**
✅ **ENTENDIDO - DEVE SER REALIZADA SEMPRE:**

**Auditoria de Código:**
- ✅ Verificar falhas de sintaxe
- ✅ Verificar inconsistências lógicas
- ✅ Verificar problemas de segurança
- ✅ Verificar violações de padrões
- ✅ Verificar dependências quebradas

**Auditoria de Funcionalidade:**
- ✅ Comparar com backup original
- ✅ Garantir que nenhuma funcionalidade não prevista foi alterada
- ✅ Confirmar que todas as funcionalidades previstas foram implementadas
- ✅ Verificar que regras de negócio não foram quebradas
- ✅ Verificar que integrações não foram afetadas

**Documentação:**
- ✅ Criar relatório em `05-DOCUMENTATION/`
- ✅ Listar arquivos auditados
- ✅ Documentar problemas e correções
- ✅ Confirmar que nenhuma funcionalidade foi prejudicada
- ✅ Registrar aprovação

**⚠️ PONTO CRÍTICO:** Não considerar projeto concluído sem auditoria completa e documentada

---

## 💬 DIRETIVAS DE COMUNICAÇÃO

### **Clareza e Objetividade**
✅ **ENTENDIDO:**
- Ser direto e objetivo
- Evitar verbosidade desnecessária
- Ir direto ao ponto

---

### **Implementação vs Sugestão**
✅ **ENTENDIDO:**
- ✅ **Implementar** mudanças quando solicitado, não apenas sugerir
- ✅ Usar ferramentas disponíveis para fazer alterações
- ⚠️ Se não tiver certeza, perguntar antes de implementar

---

### **Investigação Proativa**
✅ **ENTENDIDO:**
- ✅ Consultar documentação antes de responder
- ✅ Buscar informações no código antes de perguntar
- ✅ Tentar resolver problemas sozinho quando possível
- ⚠️ Se não encontrar informação, informar claramente

---

### **Documentação**
✅ **ENTENDIDO:**
- ✅ Documentar decisões importantes quando solicitado
- ✅ Criar documentos de especificação quando necessário
- ✅ Manter histórico das decisões técnicas

---

### **Backups Locais**
✅ **ENTENDIDO:**
- ✅ **SEMPRE** incluir backups locais em diretório específico
- ✅ Criar estrutura de backup antes de modificar arquivos importantes
- ✅ Manter histórico de versões dos arquivos modificados
- 📁 Diretório padrão: `backups/` ou conforme projeto

**⚠️ PONTO CRÍTICO:** Backups locais são obrigatórios, não apenas no servidor

---

### **Registro de Conversas**
✅ **ENTENDIDO:**
- ✅ **SEMPRE** guardar conversas em arquivos individuais
- ✅ Criar arquivo com nome descritivo e timestamp
- ✅ Registrar no `HISTORICO_CONVERSAS.md`
- 📁 Formato: `CONVERSA_YYYYMMDD_HHMMSS.md` ou `CONVERSA_[TEMA]_YYYYMMDD.md`

---

## 🔧 DIRETIVAS TÉCNICAS ESPECÍFICAS

### **Configuração e Variáveis**
✅ **ENTENDIDO:**
- PHP: Usar `$_ENV['VARIAVEL']` para variáveis Docker
- JavaScript: Usar variáveis globais simples via `config_env.js.php`
- ❌ NÃO criar objetos de configuração complexos

---

### **Credenciais e Segurança**
✅ **ENTENDIDO:**
- ✅ Credenciais em variáveis de ambiente do Docker
- ✅ NÃO hardcodar credenciais em arquivos JS/PHP
- ✅ Usar variáveis separadas para dev e prod quando necessário

---

### **Ambientes**
✅ **ENTENDIDO:**
- DEV: `https://dev.bssegurosimediato.com.br`
- PROD: `https://bssegurosimediato.com.br`
- ✅ Sempre verificar qual ambiente antes de fazer alterações

---

## ⚠️ AVISOS IMPORTANTES - RESUMO

✅ **ENTENDIDO - REGRAS ABSOLUTAS:**
1. ❌ NUNCA modificar nada diretamente no servidor
2. ✅ Backup é OBRIGATÓRIO antes de qualquer modificação
3. ⚠️ Nginx e PHP: Não modificar quando funcionando (sem autorização)
4. ❌ JavaScript: NUNCA modificar diretamente no servidor
5. ❌ PHP: NUNCA modificar diretamente no servidor
6. ❌ Configuração: NUNCA criar diretamente no servidor
7. ✅ Sistemas simples: Evitar complexidade desnecessária
8. ✅ Variáveis Docker: Sempre usar, não criar alternativas
9. ❌ Heredoc SSH: NUNCA usar - sempre arquivo local + SCP

---

## 📋 EXEMPLO DE FLUXO CORRETO

### **Antes de Iniciar um Projeto:**
✅ **ENTENDIDO - SEQUÊNCIA:**
1. ✅ Perguntar: "Posso iniciar o projeto X agora?"
2. ✅ Aguardar autorização explícita
3. ✅ Dentro do projeto: Modificar arquivos sem pedir autorização individual
4. ✅ **OBRIGATÓRIO:** Criar backups locais ANTES de qualquer alteração
5. ✅ Criar arquivos localmente (não no servidor)
6. ✅ Copiar para servidor apenas após criação local e verificação
7. ✅ Registrar conversa e atualizar histórico

### **Para Modificações Isoladas (fora de projeto):**
✅ **ENTENDIDO - SEQUÊNCIA:**
1. ✅ Perguntar: "Posso modificar o arquivo X agora?"
2. ✅ Aguardar autorização explícita
3. ✅ **OBRIGATÓRIO:** Criar backup local ANTES de modificar
4. ✅ Modificar arquivo localmente (nunca no servidor)

### **Após Modificação:**
✅ **ENTENDIDO - SEQUÊNCIA:**
1. ✅ Salvar conversa em arquivo individual
2. ✅ Atualizar `HISTORICO_CONVERSAS.md`
3. ✅ Manter backup do arquivo original
4. ✅ **OBRIGATÓRIO:** Realizar auditoria pós-implementação

---

## ✅ CONFIRMAÇÃO FINAL

**Status:** ✅ **TODAS AS DIRETIVAS REVISADAS E ENTENDIDAS**

**Compromissos:**
1. ✅ Consultar `.cursorrules` antes de qualquer ação importante
2. ✅ Seguir fluxo de trabalho obrigatório (backup → modificar local → deploy → auditoria)
3. ✅ Nunca modificar nada diretamente no servidor
4. ✅ Sempre criar backups antes de modificar
5. ✅ Sempre realizar auditoria pós-implementação
6. ✅ Sempre perguntar antes de iniciar projetos
7. ✅ Parar imediatamente quando solicitado

**Pontos Críticos que Mais Frequentemente Podem Ser Esquecidos:**
1. ⚠️ **Backup antes de modificar** (especialmente PHP)
2. ⚠️ **Modificar localmente primeiro** (nunca no servidor)
3. ⚠️ **Auditoria pós-implementação** (obrigatória, não opcional)
4. ⚠️ **Perguntar antes de iniciar projetos** (não assumir autorização)
5. ⚠️ **Criar arquivos em subdiretórios apropriados** (não no raiz)

---

**Data da Revisão:** 11/11/2025  
**Revisado por:** AI Assistant  
**Status:** ✅ **CONFIRMADO E COMPROMETIDO**

