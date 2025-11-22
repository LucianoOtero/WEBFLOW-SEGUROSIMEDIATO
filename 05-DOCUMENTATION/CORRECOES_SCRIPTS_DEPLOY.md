# 🔧 CORREÇÕES DE SCRIPTS DE DEPLOY

**Data de Criação:** 21/11/2025  
**Versão:** 1.0.0  
**Propósito:** Registrar todas as correções aplicadas aos scripts de deploy

---

## 🎯 OBJETIVO

Manter histórico completo de todas as correções aplicadas aos scripts de deploy, garantindo que:
- ✅ Erros não se repetem
- ✅ Scripts melhoram continuamente
- ✅ Processo fica mais confiável
- ✅ Rastreabilidade completa

---

## 📋 REGISTRO DE CORREÇÕES

### **Template para Nova Correção:**

```markdown
### Correção #XXX - DD/MM/YYYY - [Nome do Script]

**Data:** DD/MM/YYYY HH:MM  
**Script:** scripts/[nome-do-script].ps1  
**Versão Antes:** X.Y.Z  
**Versão Depois:** X.Y.Z+1  

**Erro Identificado:**
- [Descrição detalhada do erro]
- Comando que falhou: `comando original`
- Mensagem de erro: `mensagem exata`
- Contexto: [Quando/onde ocorreu]

**Correção Aplicada no Servidor:**
- Comando executado: `comando corrigido`
- Resultado: ✅ Funcionou / ❌ Não funcionou
- Observações: [Notas adicionais]

**Correção Aplicada no Script:**
- Linha modificada: XX
- Antes: 
  ```powershell
  código antigo
  ```
- Depois: 
  ```powershell
  código corrigido
  ```
- Comentário: `explicação da correção`

**Validação:**
- ✅ Script testado e validado
- ✅ Funciona corretamente
- ✅ Pronto para uso
- ⏳ Pendente teste / ❌ Falhou teste

**Commit Git:**
- Hash: `commit_hash`
- Mensagem: "fix(scripts): [descrição]"
```

---

## 📊 HISTÓRICO DE CORREÇÕES

| # | Data | Script | Versão | Status |
|---|------|--------|--------|--------|
| - | - | - | - | - |

---

## 🚨 REGRAS CRÍTICAS

### **OBRIGATÓRIO:**
1. ✅ Registrar correção **IMEDIATAMENTE** após aplicar no servidor
2. ✅ Atualizar script **ANTES** de próxima execução
3. ✅ Testar script corrigido **ANTES** de usar
4. ✅ Commitar script corrigido no Git

### **NUNCA:**
1. ❌ Corrigir no servidor sem atualizar script
2. ❌ Usar script sem validar correção
3. ❌ Fazer múltiplas correções sem documentar

---

**Última Atualização:** 21/11/2025  
**Próxima Revisão:** Conforme correções aplicadas

