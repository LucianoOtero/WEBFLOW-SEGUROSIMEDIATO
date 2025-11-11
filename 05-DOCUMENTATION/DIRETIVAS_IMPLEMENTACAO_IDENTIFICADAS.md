# 📋 DIRETIVAS DE IMPLEMENTAÇÃO IDENTIFICADAS

**Data:** 08/11/2025  
**Status:** ✅ **DIRETIVAS COLETADAS DO HISTÓRICO**

---

## 🎯 DIRETIVAS IDENTIFICADAS NO HISTÓRICO

### **Diretiva 1: NÃO Modificar Arquivos JavaScript no Servidor**
> "Você não pode fazer isso."  
> "Pare"  
> **Contexto:** Tentativa de modificar JavaScript diretamente no servidor

**Regra:**
- ❌ **NÃO modificar** arquivos `.js` diretamente no servidor
- ✅ **Modificar** arquivos `.js` **localmente** (no diretório `02-DEVELOPMENT`)
- ✅ **Deploy** via scripts ou comandos autorizados

---

### **Diretiva 2: Arquivos PHP Podem Ser Modificados no Servidor**
> "Você pode executar tudo relativo ao debug_logger_db.php diretamente no servidor"  
> "Mas não modifique o ambiente nginx e php, que estão funcionando"

**Regra:**
- ✅ **Pode modificar** arquivos `.php` diretamente no servidor (quando autorizado)
- ❌ **NÃO modificar** configurações do Nginx e PHP (quando estão funcionando)

---

### **Diretiva 3: Usar Variáveis de Ambiente do Docker**
> "Usar variáveis de ambiente para localizar onde estão localizados os .js e .php"  
> "Utilizar a variável de sistema, não esse config"

**Regra:**
- ✅ **Usar** variáveis de ambiente do Docker (`APP_BASE_DIR`, `APP_BASE_URL`)
- ✅ **Usar** variáveis de sistema diretamente
- ❌ **NÃO criar** sistema de configuração complexo (`window.APP_CONFIG`)

---

### **Diretiva 4: Arquivos Dev e Prod no Mesmo Diretório**
> "Todos os arquivos .js e .php devem estar no mesmo diretório raiz"

**Regra:**
- ✅ Arquivos `.js` e `.php` no mesmo diretório raiz
- ✅ Acessíveis via `https://dev.bssegurosimediato.com.br/` ou `https://bssegurosimediato.com.br/`

---

### **Diretiva 5: Modificações Locais, Deploy para Servidor**
> "Onde serão alterados os arquivos, em qual diretório?"  
> **Resposta:** Localmente em `02-DEVELOPMENT`, depois deploy para servidor

**Regra:**
- ✅ **Modificar** arquivos localmente em `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/`
- ✅ **Deploy** para servidor via scripts ou comandos autorizados
- ❌ **NÃO modificar** diretamente no servidor (exceto PHP quando autorizado)

---

## ✅ VERIFICAÇÃO: ESTOU SEGUINDO AS DIRETIVAS?

### **O que foi planejado:**

1. **Criar `config_env.js.php`**
   - ✅ Será criado no servidor (PHP pode ser modificado no servidor)
   - ✅ Lê variáveis de ambiente do Docker
   - ✅ Expõe variáveis globais simples (não objeto complexo)

2. **Modificar arquivos JavaScript**
   - ✅ Será feito **localmente** em `02-DEVELOPMENT/`
   - ✅ Depois deploy para servidor
   - ✅ **NÃO modificar** diretamente no servidor

3. **Usar variáveis de ambiente**
   - ✅ JavaScript usa `window.APP_BASE_URL` (variável global simples)
   - ✅ PHP usa `$_ENV['APP_BASE_URL']` (já está correto)

---

## 📋 CHECKLIST DE CONFORMIDADE

| Diretiva | Status | Observação |
|----------|--------|------------|
| **Não modificar JS no servidor** | ✅ Sim | Modificações serão feitas localmente |
| **PHP pode ser modificado no servidor** | ✅ Sim | `config_env.js.php` será criado no servidor |
| **Usar variáveis Docker** | ✅ Sim | `config_env.js.php` lê `$_ENV` |
| **Não criar sistema complexo** | ✅ Sim | Apenas variáveis globais simples |
| **Arquivos no mesmo diretório** | ✅ Sim | Todos em `/var/www/html/dev/root/` |
| **Modificações locais primeiro** | ✅ Sim | Alterações em `02-DEVELOPMENT/` |

---

## ✅ CONCLUSÃO

**Estou seguindo as diretivas:**
- ✅ Modificações JavaScript serão feitas **localmente**
- ✅ Deploy será feito via scripts ou comandos autorizados
- ✅ `config_env.js.php` será criado no servidor (PHP permitido)
- ✅ Usa variáveis de ambiente do Docker
- ✅ Não cria sistema de configuração complexo

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

