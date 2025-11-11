# 📧 PROJETO: SISTEMA DE TEMPLATES DE EMAIL

**Data de Início:** 09/11/2025  
**Status:** 📋 **PLANO CRIADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.0.0

---

## 🎯 OBJETIVO

Criar um sistema modular de templates de email para separar templates específicos por contexto:
- **Template Modal:** Para notificações do modal WhatsApp (já existe)
- **Template Logging:** Para notificações de erro/warning/fatal do sistema de logging (novo)

---

## 📊 SITUAÇÃO ATUAL

### **Problema Identificado:**
- ✅ O template atual em `send_admin_notification_ses.php` é específico para o modal WhatsApp
- ✅ Mostra campos como telefone, nome, CPF, CEP, placa, GCLID (dados do cliente)
- ✅ Quando usado para logging, mostra "N/A" ou valores padrão que não fazem sentido
- ❌ Não há separação entre templates para diferentes contextos

### **Template Atual:**
- Focado em dados do cliente (telefone, nome, CPF, etc.)
- Banner verde/azul para sucesso, vermelho para erro
- Estrutura HTML inline no código PHP
- Não reutilizável para outros contextos

---

## 🎯 OBJETIVOS DO PROJETO

1. ✅ **Criar sistema modular de templates**
2. ✅ **Separar template do modal do template de logging**
3. ✅ **Criar template específico para erros/warnings/fatais**
4. ✅ **Manter compatibilidade com código existente**
5. ✅ **Facilitar manutenção e extensão futura**

---

## 📁 ESTRUTURA PROPOSTA

### **Arquivos a Criar:**
1. `email_templates/` - Diretório para templates
   - `template_modal.php` - Template para modal WhatsApp
   - `template_logging.php` - Template para logging (ERROR/WARN/FATAL)
   - `template_base.php` - Classe base para templates (opcional)

2. `email_template_loader.php` - Carregador de templates
   - Função para carregar template baseado em tipo
   - Validação de templates
   - Cache de templates (opcional)

### **Arquivos a Modificar:**
1. `send_admin_notification_ses.php`
   - Refatorar para usar sistema de templates
   - Manter compatibilidade com código existente
   - Adicionar suporte a diferentes tipos de template

---

## 🎨 TEMPLATE DE LOGGING (NOVO)

### **Características:**
- ✅ Design focado em informações técnicas de erro
- ✅ Cores diferentes por nível (ERROR=vermelho, WARN=laranja, FATAL=vermelho escuro)
- ✅ Exibição clara de:
  - Nível do erro (ERROR/WARN/FATAL)
  - Mensagem do erro
  - Categoria (DATABASE, API, SYSTEM, etc.)
  - Arquivo e linha onde ocorreu
  - Stack trace completo (se disponível)
  - Dados adicionais (JSON formatado)
  - Timestamp e Request ID
  - Ambiente (dev/prod)

### **Estrutura Visual:**
- Banner colorido por nível
- Seção de informações principais (nível, mensagem, categoria)
- Seção técnica (arquivo, linha, função)
- Seção de stack trace (colapsável ou completo)
- Seção de dados adicionais (JSON formatado)
- Footer com informações do sistema

---

## 📋 FASES DO PROJETO

### **Fase 1: Preparação e Backups**
- [ ] Criar diretório de backup
- [ ] Fazer backup de `send_admin_notification_ses.php`
- [ ] Fazer backup de `send_email_notification_endpoint.php`

### **Fase 2: Criar Estrutura de Templates**
- [ ] Criar diretório `email_templates/`
- [ ] Criar `template_modal.php` (extrair do código atual)
- [ ] Criar `template_logging.php` (novo template)
- [ ] Criar `email_template_loader.php` (carregador)

### **Fase 3: Refatorar Código Existente**
- [ ] Modificar `send_admin_notification_ses.php` para usar templates
- [ ] Adicionar detecção automática de tipo de template
- [ ] Manter compatibilidade com código existente

### **Fase 4: Testes**
- [ ] Testar template do modal (garantir que não quebrou)
- [ ] Testar template de logging (ERROR, WARN, FATAL)
- [ ] Verificar emails recebidos

### **Fase 5: Documentação**
- [ ] Documentar sistema de templates
- [ ] Criar guia de uso
- [ ] Documentar como adicionar novos templates

---

## 🔧 ESPECIFICAÇÃO TÉCNICA

### **Template Modal:**
- **Tipo:** `modal`
- **Uso:** Notificações do modal WhatsApp
- **Dados:** Telefone, nome, CPF, email, CEP, placa, GCLID
- **Cores:** Verde (sucesso), Azul (initial), Vermelho (erro)

### **Template Logging:**
- **Tipo:** `logging`
- **Uso:** Notificações de erro/warning/fatal
- **Dados:** Nível, mensagem, categoria, arquivo, linha, stack trace, dados JSON
- **Cores:** Vermelho (ERROR/FATAL), Laranja (WARN)

### **Detecção Automática:**
- Se `erro` contém `level`, `category`, `file_name` → Template Logging
- Se `ddd` e `celular` são válidos (não '00'/'000000000') → Template Modal
- Fallback: Template Modal (compatibilidade)

---

## 📝 NOTAS IMPORTANTES

- ✅ Manter compatibilidade total com código existente
- ✅ Não quebrar funcionalidade atual do modal
- ✅ Templates devem ser fáceis de manter e estender
- ✅ Seguir diretivas do projeto (backups, documentação, etc.)

---

## ⚠️ RISCOS E MITIGAÇÕES

### **Risco 1: Quebrar funcionalidade do modal**
- **Mitigação:** Testes extensivos, manter compatibilidade

### **Risco 2: Templates complexos demais**
- **Mitigação:** Manter templates simples e focados

### **Risco 3: Performance**
- **Mitigação:** Templates são carregados apenas quando necessário

---

**Documento criado em:** 09/11/2025  
**Aguardando autorização para iniciar implementação**

