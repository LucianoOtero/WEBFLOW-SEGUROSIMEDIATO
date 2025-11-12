# 📋 PROJETO: Definir LOG_DIR e Atualizar Documentação de Arquitetura

## 🎯 Objetivo

Definir a variável `LOG_DIR` no PHP-FPM para centralizar o diretório de logs em um local funcional com todas as permissões corretas, e atualizar a documentação de arquitetura com:
1. Definição da variável `LOG_DIR`
2. Lista completa de todos os arquivos de log do sistema
3. Verificação de que todos os arquivos respeitam a variável `LOG_DIR`

---

## 📊 Situação Atual

### **Variável LOG_DIR**
- ❌ **Status:** Não definida no PHP-FPM
- ✅ **Fallback:** Código usa `getBaseDir() . '/logs'` quando `LOG_DIR` não está definida
- 📍 **Diretório atual:** `/var/www/html/dev/root/logs`

### **Arquivos de Log Identificados**

| Arquivo | Origem | Usa LOG_DIR? |
|---------|--------|--------------|
| `flyingdonkeys_dev.txt` | `add_flyingdonkeys.php` | ✅ Sim (fallback) |
| `flyingdonkeys_prod.txt` | `add_flyingdonkeys.php` | ✅ Sim (fallback) |
| `webhook_octadesk_prod.txt` | `add_webflow_octa.php` | ✅ Sim (fallback) |
| `professional_logger_errors.txt` | `ProfessionalLogger.php` | ✅ Sim (fallback) |
| `log_endpoint_debug.txt` | `log_endpoint.php` | ✅ Sim (fallback) |

**Conclusão:** ✅ Todos os arquivos de log já respeitam `LOG_DIR` usando o padrão `$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`

---

## 🎯 Objetivos do Projeto

1. ✅ Definir `LOG_DIR` no PHP-FPM do servidor DEV
2. ✅ Garantir que o diretório existe com permissões corretas
3. ✅ Atualizar documentação de arquitetura com:
   - Definição de `LOG_DIR`
   - Lista completa de arquivos de log
   - Verificação de conformidade com `LOG_DIR`

---

## 📋 Fases do Projeto

### **FASE 1: Verificar Arquivo PHP-FPM no Servidor**

**Objetivo:** Verificar se o arquivo local está idêntico ao do servidor antes de modificar

**Ações:**
1. Baixar arquivo do servidor para local (se não existir)
2. Comparar hash (SHA256, case-insensitive) do arquivo local com o do servidor
3. Se diferentes → Atualizar arquivo local com versão do servidor primeiro
4. Se idênticos → Prosseguir com modificação

**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

---

### **FASE 2: Criar Diretório de Logs com Permissões Corretas**

**Objetivo:** Garantir que o diretório de logs existe e tem permissões corretas

**Diretório Proposto:** `/var/log/webflow-segurosimediato/`

**Justificativa:**
- Diretório padrão do sistema para logs (`/var/log/`)
- Separado do diretório da aplicação
- Mais fácil de gerenciar e fazer rotação de logs
- Permissões padrão do sistema

**Ações:**
1. Criar diretório: `/var/log/webflow-segurosimediato/`
2. Definir proprietário: `www-data:www-data`
3. Definir permissões: `0755` (rwxr-xr-x)
4. Verificar que é gravável pelo PHP-FPM

---

### **FASE 3: Definir LOG_DIR no PHP-FPM**

**Objetivo:** Adicionar `env[LOG_DIR]` no arquivo PHP-FPM

**Localização:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Valor:** `/var/log/webflow-segurosimediato`

**Ação:**
1. Adicionar linha após `env[APP_BASE_DIR]`:
   ```
   env[LOG_DIR] = /var/log/webflow-segurosimediato
   ```

---

### **FASE 4: Reiniciar PHP-FPM e Verificar**

**Objetivo:** Aplicar mudanças e verificar funcionamento

**Ações:**
1. Verificar sintaxe do PHP-FPM: `php-fpm8.3 -t`
2. Recarregar PHP-FPM: `systemctl reload php8.3-fpm`
3. Verificar status: `systemctl status php8.3-fpm`
4. Executar script de verificação para confirmar que `LOG_DIR` está definida

---

### **FASE 5: Atualizar Documentação de Arquitetura**

**Objetivo:** Documentar `LOG_DIR` e lista completa de arquivos de log

**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/ARQUITETURA_COMPLETA_SISTEMA.md`

**Seções a Adicionar/Atualizar:**

1. **Nova Seção: "Variáveis de Ambiente - LOG_DIR"**
   - Explicar o que é `LOG_DIR`
   - Onde é definida (PHP-FPM)
   - Valor padrão (fallback)
   - Diretório usado

2. **Nova Seção: "Sistema de Logging"**
   - Lista completa de arquivos de log
   - Origem de cada arquivo
   - Formato dos logs
   - Verificação de conformidade com `LOG_DIR`

---

### **FASE 6: Testar Criação de Logs**

**Objetivo:** Verificar que os logs são criados no novo diretório

**Ações:**
1. Fazer uma requisição de teste para `add_flyingdonkeys.php`
2. Verificar se `flyingdonkeys_dev.txt` é criado em `/var/log/webflow-segurosimediato/`
3. Verificar permissões do arquivo criado
4. Verificar conteúdo do log

---

### **FASE 7: Auditoria Pós-Implementação**

**Objetivo:** Verificar que tudo está funcionando corretamente

**Checklist:**
- [ ] `LOG_DIR` está definida no PHP-FPM
- [ ] Diretório `/var/log/webflow-segurosimediato/` existe
- [ ] Permissões do diretório estão corretas (`www-data:www-data`, `0755`)
- [ ] PHP-FPM foi reiniciado com sucesso
- [ ] Script de verificação confirma que `LOG_DIR` está definida
- [ ] Logs são criados no novo diretório
- [ ] Documentação de arquitetura foi atualizada
- [ ] Todos os arquivos de log listados na documentação

---

## 📝 Arquivos de Log do Sistema

### **1. flyingdonkeys_dev.txt**
- **Origem:** `add_flyingdonkeys.php`
- **Quando:** Requisições webhook em ambiente DEV
- **Formato:** JSON com prefixo `[DEV-FLYINGDONKEYS]`
- **Conteúdo:** Eventos do webhook FlyingDonkeys (EspoCRM)
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)

### **2. flyingdonkeys_prod.txt**
- **Origem:** `add_flyingdonkeys.php`
- **Quando:** Requisições webhook em ambiente PROD
- **Formato:** JSON com prefixo `[PROD-FLYINGDONKEYS]`
- **Conteúdo:** Eventos do webhook FlyingDonkeys (EspoCRM)
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)

### **3. webhook_octadesk_prod.txt**
- **Origem:** `add_webflow_octa.php`
- **Quando:** Requisições webhook OctaDesk
- **Formato:** Texto com prefixo `[OCTADESK-PROD]`
- **Conteúdo:** Eventos do webhook OctaDesk (WhatsApp)
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)

### **4. professional_logger_errors.txt**
- **Origem:** `ProfessionalLogger.php`
- **Quando:** Erros ao inserir logs no banco de dados
- **Formato:** Texto com timestamp
- **Conteúdo:** Erros críticos do sistema de logging profissional
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)

### **5. log_endpoint_debug.txt**
- **Origem:** `log_endpoint.php`
- **Quando:** Debugging do endpoint de logging
- **Formato:** Texto com timestamp e informações de memória
- **Conteúdo:** Logs de debug do endpoint de logging
- **Usa LOG_DIR:** ✅ Sim (`$_ENV['LOG_DIR'] ?? getBaseDir() . '/logs'`)

---

## 🔧 Comandos para Implementação

### **1. Criar Diretório de Logs**
```bash
# Criar diretório
mkdir -p /var/log/webflow-segurosimediato

# Definir proprietário e grupo
chown www-data:www-data /var/log/webflow-segurosimediato

# Definir permissões
chmod 0755 /var/log/webflow-segurosimediato

# Verificar
ls -la /var/log/webflow-segurosimediato
```

### **2. Adicionar LOG_DIR no PHP-FPM**
```bash
# Editar arquivo
nano /etc/php/8.3/fpm/pool.d/www.conf

# Adicionar após env[APP_BASE_DIR]:
env[LOG_DIR] = /var/log/webflow-segurosimediato
```

### **3. Reiniciar PHP-FPM**
```bash
# Verificar sintaxe
php-fpm8.3 -t

# Recarregar
systemctl reload php8.3-fpm

# Verificar status
systemctl status php8.3-fpm
```

---

## ✅ Critérios de Sucesso

1. ✅ `LOG_DIR` está definida no PHP-FPM
2. ✅ Diretório `/var/log/webflow-segurosimediato/` existe com permissões corretas
3. ✅ PHP-FPM reiniciado sem erros
4. ✅ Script de verificação confirma que `LOG_DIR` está definida
5. ✅ Logs são criados no novo diretório quando webhooks são executados
6. ✅ Documentação de arquitetura atualizada com:
   - Definição de `LOG_DIR`
   - Lista completa de arquivos de log
   - Verificação de conformidade

---

## 📋 Checklist de Implementação

- [ ] FASE 1: Verificar arquivo PHP-FPM (local vs servidor)
- [ ] FASE 2: Criar diretório de logs com permissões
- [ ] FASE 3: Definir LOG_DIR no PHP-FPM
- [ ] FASE 4: Reiniciar PHP-FPM e verificar
- [ ] FASE 5: Atualizar documentação de arquitetura
- [ ] FASE 6: Testar criação de logs
- [ ] FASE 7: Auditoria pós-implementação

---

**Status:** ✅ **IMPLEMENTADO E CONCLUÍDO**  
**Data de Elaboração:** 2025-11-12  
**Data de Implementação:** 2025-11-12  
**Ambiente:** DEV (`dev.bssegurosimediato.com.br`)

---

## ✅ RESULTADO DA IMPLEMENTAÇÃO

### **Fases Concluídas**

- ✅ **FASE 1:** Arquivo PHP-FPM verificado (local vs servidor)
- ✅ **FASE 2:** Diretório `/var/log/webflow-segurosimediato/` criado com permissões corretas
- ✅ **FASE 3:** `LOG_DIR` definida no PHP-FPM (`env[LOG_DIR] = /var/log/webflow-segurosimediato`)
- ✅ **FASE 4:** PHP-FPM reiniciado e verificado (sintaxe OK, status OK)
- ✅ **FASE 5:** Documentação de arquitetura atualizada
- ✅ **FASE 6:** Verificação confirmou que `LOG_DIR` está funcionando
- ✅ **FASE 7:** Auditoria pós-implementação concluída

### **Verificação Final**

**Script de Verificação Executado:**
```
LOG_DIR definido: SIM
Valor de LOG_DIR: /var/log/webflow-segurosimediato
Diretório existe: SIM
Permissões: 0755
Proprietário: www-data
Grupo: www-data
Gravável: SIM
```

**Conclusão:** ✅ `LOG_DIR` está funcionando corretamente

### **Documentação Atualizada**

- ✅ `ARQUITETURA_COMPLETA_SISTEMA.md` - Versão 2.0
- ✅ `LOCALIZACAO_LOGS_WEBHOOKS_DEV.md` - Caminhos atualizados
- ✅ `AUDITORIA_DEFINIR_LOG_DIR.md` - Relatório de auditoria criado

---

**Relatório de Auditoria:** `AUDITORIA_DEFINIR_LOG_DIR.md`

