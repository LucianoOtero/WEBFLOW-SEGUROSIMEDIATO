# 🔒 PROCESSO DE REPLICAÇÃO 100% SEGURA: DEV → PROD

**Data de Criação:** 21/11/2025  
**Versão:** 1.0.0  
**Status:** ✅ **PROCESSO DEFINIDO**

---

## 🎯 OBJETIVO

Garantir replicação **100% segura e correta** de todas as alterações feitas em DEV para PROD, utilizando:
- ✅ Sistema de tracking existente
- ✅ Extensões VS Code/Cursor recomendadas
- ✅ Validações automáticas
- ✅ Verificações obrigatórias
- ✅ Processo documentado e auditável

---

## 📊 VISÃO GERAL DO PROCESSO

### **Fluxo Completo:**

```
┌─────────────────────────────────────────────────────────────┐
│ 1. DESENVOLVIMENTO (DEV)                                    │
│    ├─ Modificar código (.js, .php)                         │
│    ├─ Alterar configurações (PHP-FPM, Nginx)               │
│    ├─ Executar SQL no banco                                │
│    └─ ✅ ATUALIZAR DOCUMENTO DE TRACKING                    │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. VALIDAÇÃO EM DEV                                         │
│    ├─ Testar funcionalidades                               │
│    ├─ Verificar logs                                        │
│    ├─ Validar integridade                                   │
│    └─ ✅ CONFIRMAR FUNCIONAMENTO                            │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. PREPARAÇÃO PARA PROD                                     │
│    ├─ Revisar documento de tracking                        │
│    ├─ Criar/validar scripts para PROD                      │
│    ├─ Criar backup de PROD                                 │
│    └─ ✅ CHECKLIST COMPLETO                                │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. REPLICAÇÃO EM PROD                                       │
│    ├─ Copiar arquivos (.js, .php)                          │
│    ├─ Aplicar configurações                                │
│    ├─ Executar SQL                                          │
│    └─ ✅ VERIFICAR INTEGRIDADE                              │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. VALIDAÇÃO EM PROD                                        │
│    ├─ Testar funcionalidades                               │
│    ├─ Verificar logs                                        │
│    ├─ Monitorar por 24-48h                                  │
│    └─ ✅ CONFIRMAR SUCESSO                                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. DOCUMENTAÇÃO FINAL                                       │
│    ├─ Atualizar histórico                                   │
│    ├─ Marcar como replicado                                 │
│    └─ ✅ PROCESSO CONCLUÍDO                                │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔐 GARANTIAS DE SEGURANÇA

### **1. Tracking Automático**
- ✅ **Documento único:** `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`
- ✅ **Atualização obrigatória:** Após cada alteração em DEV
- ✅ **Categorização:** PHP, JavaScript, Configurações, Banco de Dados
- ✅ **Checklist:** Lista completa de itens para replicar

### **2. Validação de Integridade**
- ✅ **Hash SHA256:** Comparar arquivos antes/depois da cópia
- ✅ **Verificação de sintaxe:** PHP e JavaScript validados
- ✅ **Testes funcionais:** Validar funcionamento em DEV antes de PROD
- ✅ **Comparação de configurações:** Verificar que PHP-FPM está idêntico

### **3. Scripts Idempotentes**
- ✅ **SQL:** Scripts podem executar múltiplas vezes sem erro
- ✅ **Configurações:** Verificações antes de aplicar
- ✅ **Rollback:** Scripts de reversão prontos

### **4. Processo Documentado**
- ✅ **Cada etapa:** Documentada e verificável
- ✅ **Histórico:** Todas as replicações registradas
- ✅ **Auditoria:** Rastreabilidade completa

---

## 🛠️ COMO AS EXTENSÕES AJUDAM

### **1. GitLens - Rastreamento de Versões**
**Como ajuda:**
- ✅ Verificar exatamente quais arquivos foram modificados
- ✅ Comparar código entre DEV e PROD
- ✅ Identificar versões deployadas
- ✅ Rastrear quando cada alteração foi feita

**Uso no processo:**
```bash
# Ver diferenças entre DEV e PROD
git diff dev-branch prod-branch

# Ver histórico de commits
git log --oneline --graph

# Ver tags e releases
git tag --list
```

### **2. Remote SSH - Conexão Segura**
**Como ajuda:**
- ✅ Conexão direta aos servidores DEV e PROD
- ✅ Edição remota com validação
- ✅ Terminal integrado para comandos
- ✅ Verificação de arquivos remotos

**Uso no processo:**
```bash
# Conectar ao servidor DEV
ssh root@65.108.156.14

# Conectar ao servidor PROD
ssh root@157.180.36.223

# Verificar arquivos remotos
ls -la /var/www/html/dev/root/
ls -la /var/www/html/prod/root/
```

### **3. SQL Tools - Validação de Banco**
**Como ajuda:**
- ✅ Conectar aos bancos DEV e PROD simultaneamente
- ✅ Comparar schemas entre ambientes
- ✅ Executar queries de verificação
- ✅ Validar alterações antes/depois

**Uso no processo:**
```sql
-- Verificar schema antes da replicação
SELECT COLUMN_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rpa_logs_prod' 
  AND TABLE_NAME = 'application_logs' 
  AND COLUMN_NAME = 'level';

-- Comparar com DEV
SELECT COLUMN_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rpa_logs_dev' 
  AND TABLE_NAME = 'application_logs' 
  AND COLUMN_NAME = 'level';
```

### **4. PHP Intelephense - Validação de Código**
**Como ajuda:**
- ✅ Validar sintaxe PHP antes do deploy
- ✅ Detectar erros antes de copiar para PROD
- ✅ Verificar uso de variáveis de ambiente
- ✅ Autocomplete para garantir código correto

**Uso no processo:**
```bash
# Validar sintaxe PHP antes de copiar
php -l arquivo.php

# Verificar variáveis de ambiente usadas
grep -r '\$_ENV\[' arquivo.php
```

### **5. ESLint - Validação JavaScript**
**Como ajuda:**
- ✅ Validar sintaxe JavaScript
- ✅ Detectar erros antes do deploy
- ✅ Manter padrão de código
- ✅ Verificar uso correto de variáveis

**Uso no processo:**
```bash
# Validar JavaScript
eslint FooterCodeSiteDefinitivoCompleto.js

# Verificar variáveis usadas
grep -r 'window\.APP_' arquivo.js
```

---

## 📋 PROCESSO DETALHADO DE REPLICAÇÃO

### **FASE 1: PREPARAÇÃO (ANTES DE REPLICAR)**

#### **1.1. Revisar Documento de Tracking**
- ✅ Abrir: `ALTERACOES_DESDE_ULTIMA_REPLICACAO_PROD_YYYYMMDD.md`
- ✅ Verificar todas as alterações listadas
- ✅ Confirmar que todas foram validadas em DEV
- ✅ Verificar checklist de replicação

#### **1.2. Validar Ambiente DEV**
```bash
# Verificar que código está funcionando em DEV
curl https://dev.bssegurosimediato.com.br/log_endpoint.php

# Verificar logs de erro
ssh root@65.108.156.14 "tail -n 50 /var/log/nginx/error.log"

# Verificar PHP-FPM
ssh root@65.108.156.14 "php-fpm8.3 -tt | grep env\["
```

#### **1.3. Criar Backup de PROD**
```bash
# Backup de arquivos PHP/JS
ssh root@157.180.36.223 "tar -czf /tmp/backup_prod_$(date +%Y%m%d_%H%M%S).tar.gz /var/www/html/prod/root/"

# Backup de configurações PHP-FPM
ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/prod.conf /etc/php/8.3/fpm/pool.d/prod.conf.backup_$(date +%Y%m%d_%H%M%S)"

# Backup de banco de dados (se necessário)
ssh root@157.180.36.223 "mysqldump -u rpa_logger_prod -p rpa_logs_prod > /tmp/backup_db_prod_$(date +%Y%m%d_%H%M%S).sql"
```

#### **1.4. Preparar Scripts para PROD**
- ✅ Copiar scripts SQL de DEV para PROD (ajustar nomes de banco)
- ✅ Validar scripts SQL (sintaxe, lógica)
- ✅ Preparar comandos de cópia de arquivos
- ✅ Preparar comandos de atualização de configurações

---

### **FASE 2: REPLICAÇÃO DE CÓDIGO PHP/JS**

#### **2.1. Copiar Arquivos PHP**
```bash
# Para cada arquivo PHP listado no documento de tracking:
# Exemplo: config.php

# 1. Calcular hash do arquivo local (DEV)
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\config.php" -Algorithm SHA256).Hash.ToUpper()

# 2. Copiar para servidor DEV (se ainda não estiver)
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\config.php" root@65.108.156.14:/var/www/html/dev/root/

# 3. Verificar hash no servidor DEV
$hashDev = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/config.php | cut -d' ' -f1").ToUpper()

# 4. Se hash coincide, copiar para PROD
if ($hashLocal -eq $hashDev) {
    # Criar backup em PROD
    ssh root@157.180.36.223 "cp /var/www/html/prod/root/config.php /var/www/html/prod/root/config.php.backup_$(date +%Y%m%d_%H%M%S)"
    
    # Copiar para PROD
    scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\config.php" root@157.180.36.223:/var/www/html/prod/root/
    
    # Verificar hash em PROD
    $hashProd = (ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/config.php | cut -d' ' -f1").ToUpper()
    
    # Confirmar que hash coincide
    if ($hashLocal -eq $hashProd) {
        Write-Host "✅ Arquivo copiado com sucesso - hash coincide"
    } else {
        Write-Host "❌ ERRO: Hash não coincide - tentar novamente"
        exit 1
    }
} else {
    Write-Host "❌ ERRO: Hash DEV não coincide com local - verificar arquivo"
    exit 1
}
```

#### **2.2. Copiar Arquivos JavaScript**
```bash
# Mesmo processo para arquivos JavaScript
# Exemplo: FooterCodeSiteDefinitivoCompleto.js

# 1. Validar sintaxe JavaScript localmente
eslint "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js"

# 2. Calcular hash
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js" -Algorithm SHA256).Hash.ToUpper()

# 3. Copiar para DEV (se necessário)
scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js" root@65.108.156.14:/var/www/html/dev/root/

# 4. Verificar hash DEV
$hashDev = (ssh root@65.108.156.14 "sha256sum /var/www/html/dev/root/FooterCodeSiteDefinitivoCompleto.js | cut -d' ' -f1").ToUpper()

# 5. Se hash coincide, copiar para PROD
if ($hashLocal -eq $hashDev) {
    # Backup PROD
    ssh root@157.180.36.223 "cp /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js.backup_$(date +%Y%m%d_%H%M%S)"
    
    # Copiar para PROD
    scp "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\FooterCodeSiteDefinitivoCompleto.js" root@157.180.36.223:/var/www/html/prod/root/
    
    # Verificar hash PROD
    $hashProd = (ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/FooterCodeSiteDefinitivoCompleto.js | cut -d' ' -f1").ToUpper()
    
    # Confirmar
    if ($hashLocal -eq $hashProd) {
        Write-Host "✅ Arquivo JavaScript copiado com sucesso"
    } else {
        Write-Host "❌ ERRO: Hash não coincide"
        exit 1
    }
}
```

#### **2.3. Verificar Sintaxe PHP em PROD**
```bash
# Validar sintaxe de todos os arquivos PHP copiados
ssh root@157.180.36.223 "cd /var/www/html/prod/root && for file in *.php; do php -l \"\$file\" || exit 1; done"
```

---

### **FASE 3: REPLICAÇÃO DE CONFIGURAÇÕES PHP-FPM**

#### **3.1. Comparar Configurações DEV vs PROD**
```bash
# Ver variáveis de ambiente DEV
ssh root@65.108.156.14 "php-fpm8.3 -tt | grep 'env\[' | sort"

# Ver variáveis de ambiente PROD
ssh root@157.180.36.223 "php-fpm8.3 -tt | grep 'env\[' | sort"

# Comparar (salvar em arquivos e comparar)
ssh root@65.108.156.14 "php-fpm8.3 -tt | grep 'env\[' | sort > /tmp/env_dev.txt"
ssh root@157.180.36.223 "php-fpm8.3 -tt | grep 'env\[' | sort > /tmp/env_prod.txt"

# Comparar arquivos
ssh root@157.180.36.223 "diff /tmp/env_dev.txt /tmp/env_prod.txt"
```

#### **3.2. Aplicar Configurações em PROD**
```bash
# 1. Criar backup da configuração PROD
ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/prod.conf /etc/php/8.3/fpm/pool.d/prod.conf.backup_$(date +%Y%m%d_%H%M%S)"

# 2. Copiar configuração de DEV para local
scp root@65.108.156.14:/etc/php/8.3/fpm/pool.d/www.conf "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_www_conf_DEV.txt"

# 3. Ajustar configuração para PROD (substituir DEV por PROD)
# Editar arquivo localmente

# 4. Copiar configuração ajustada para PROD
scp "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\php-fpm_prod_conf.txt" root@157.180.36.223:/etc/php/8.3/fpm/pool.d/prod.conf

# 5. Validar sintaxe PHP-FPM
ssh root@157.180.36.223 "php-fpm8.3 -tt"

# 6. Se válido, recarregar PHP-FPM
ssh root@157.180.36.223 "systemctl reload php8.3-fpm"

# 7. Verificar que variáveis foram aplicadas
ssh root@157.180.36.223 "php-fpm8.3 -tt | grep 'env\[' | sort"
```

---

### **FASE 4: REPLICAÇÃO DE BANCO DE DADOS**

#### **4.1. Verificar Schema Atual em PROD**
```sql
-- Conectar ao banco PROD via SQL Tools
USE rpa_logs_prod;

-- Verificar schema atual
SELECT COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'rpa_logs_prod'
  AND TABLE_NAME = 'application_logs'
  AND COLUMN_NAME = 'level';
```

#### **4.2. Comparar com DEV**
```sql
-- Conectar ao banco DEV
USE rpa_logs_dev;

-- Verificar schema DEV
SELECT COLUMN_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'rpa_logs_dev'
  AND TABLE_NAME = 'application_logs'
  AND COLUMN_NAME = 'level';

-- Comparar resultados
```

#### **4.3. Executar Script SQL em PROD**
```bash
# 1. Copiar script SQL para servidor PROD
scp "WEBFLOW-SEGUROSIMEDIATO\06-SERVER-CONFIG\alterar_enum_level_adicionar_trace_prod.sql" root@157.180.36.223:/tmp/

# 2. Executar script SQL
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -p rpa_logs_prod < /tmp/alterar_enum_level_adicionar_trace_prod.sql"

# 3. Verificar que alteração foi aplicada
ssh root@157.180.36.223 "mysql -u rpa_logger_prod -p rpa_logs_prod -e \"SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'rpa_logs_prod' AND TABLE_NAME = 'application_logs' AND COLUMN_NAME = 'level';\""
```

---

### **FASE 5: VALIDAÇÃO EM PROD**

#### **5.1. Testes Funcionais**
```bash
# 1. Testar endpoint de log
curl -X POST https://prod.bssegurosimediato.com.br/log_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{"level":"TRACE","category":"TEST","message":"Teste de replicação"}'

# 2. Verificar resposta
# Deve retornar status 200 e log_id válido

# 3. Verificar logs do servidor
ssh root@157.180.36.223 "tail -n 50 /var/log/nginx/error.log"
ssh root@157.180.36.223 "tail -n 50 /var/log/php8.3-fpm.log"
```

#### **5.2. Verificar Integridade**
```bash
# Comparar hashes de todos os arquivos copiados
# Lista de arquivos do documento de tracking

# Para cada arquivo:
$hashLocal = (Get-FileHash -Path "arquivo" -Algorithm SHA256).Hash.ToUpper()
$hashProd = (ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/arquivo | cut -d' ' -f1").ToUpper()

if ($hashLocal -eq $hashProd) {
    Write-Host "✅ arquivo: OK"
} else {
    Write-Host "❌ arquivo: ERRO - hash não coincide"
}
```

#### **5.3. Monitoramento (24-48h)**
```bash
# Monitorar logs de erro
ssh root@157.180.36.223 "tail -f /var/log/nginx/error.log"
ssh root@157.180.36.223 "tail -f /var/log/php8.3-fpm.log"

# Verificar métricas
# - Taxa de erro
# - Tempo de resposta
# - Uso de recursos
```

---

### **FASE 6: DOCUMENTAÇÃO FINAL**

#### **6.1. Atualizar Histórico**
- ✅ Abrir: `HISTORICO_REPLICACAO_PRODUCAO.md`
- ✅ Registrar data/hora da replicação
- ✅ Listar todos os arquivos replicados
- ✅ Listar todas as configurações aplicadas
- ✅ Listar todas as alterações no banco

#### **6.2. Atualizar Documento de Tracking**
- ✅ Marcar itens como "✅ REPLICADO" no checklist
- ✅ Registrar data/hora de cada item replicado
- ✅ Documentar problemas encontrados (se houver)
- ✅ Registrar resultados dos testes

#### **6.3. Atualizar Tracking de Banco de Dados**
- ✅ Abrir: `TRACKING_ALTERACOES_BANCO_DADOS.md`
- ✅ Marcar alteração como "✅ REPLICADA"
- ✅ Registrar data/hora da replicação
- ✅ Documentar resultados dos testes em PROD

---

## 🔒 GARANTIAS DE SEGURANÇA IMPLEMENTADAS

### **1. Validação de Integridade**
- ✅ **Hash SHA256:** Todos os arquivos verificados antes/depois
- ✅ **Comparação:** Arquivos DEV vs PROD comparados
- ✅ **Validação de sintaxe:** PHP e JavaScript validados

### **2. Processo Documentado**
- ✅ **Tracking:** Todas as alterações registradas
- ✅ **Checklist:** Lista completa de itens para replicar
- ✅ **Histórico:** Todas as replicações documentadas

### **3. Scripts Idempotentes**
- ✅ **SQL:** Scripts podem executar múltiplas vezes
- ✅ **Configurações:** Verificações antes de aplicar
- ✅ **Rollback:** Scripts de reversão prontos

### **4. Validação em Múltiplas Etapas**
- ✅ **Antes:** Validação em DEV
- ✅ **Durante:** Verificação de hash durante cópia
- ✅ **Depois:** Testes funcionais em PROD
- ✅ **Monitoramento:** 24-48h após replicação

---

## 🛠️ AUTOMAÇÃO COM EXTENSÕES

### **Tasks VS Code/Cursor para Replicação**

Criar tasks em `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Replicar Arquivo PHP para PROD",
      "type": "shell",
      "command": "powershell",
      "args": [
        "-File",
        "${workspaceFolder}/scripts/replicar-php-prod.ps1",
        "${file}"
      ],
      "problemMatcher": []
    },
    {
      "label": "Replicar Arquivo JS para PROD",
      "type": "shell",
      "command": "powershell",
      "args": [
        "-File",
        "${workspaceFolder}/scripts/replicar-js-prod.ps1",
        "${file}"
      ],
      "problemMatcher": []
    },
    {
      "label": "Validar Hash Arquivo PROD",
      "type": "shell",
      "command": "powershell",
      "args": [
        "-File",
        "${workspaceFolder}/scripts/validar-hash-prod.ps1",
        "${file}"
      ],
      "problemMatcher": []
    },
    {
      "label": "Replicar Configuração PHP-FPM para PROD",
      "type": "shell",
      "command": "powershell",
      "args": [
        "-File",
        "${workspaceFolder}/scripts/replicar-phpfpm-prod.ps1"
      ],
      "problemMatcher": []
    },
    {
      "label": "Replicar SQL para PROD",
      "type": "shell",
      "command": "powershell",
      "args": [
        "-File",
        "${workspaceFolder}/scripts/replicar-sql-prod.ps1",
        "${file}"
      ],
      "problemMatcher": []
    },
    {
      "label": "Validar Replicação Completa",
      "type": "shell",
      "command": "powershell",
      "args": [
        "-File",
        "${workspaceFolder}/scripts/validar-replicacao-completa.ps1"
      ],
      "problemMatcher": []
    }
  ]
}
```

---

## 📋 CHECKLIST COMPLETO DE REPLICAÇÃO

### **ANTES DE REPLICAR:**
- [ ] Documento de tracking revisado completamente
- [ ] Todas as alterações validadas em DEV
- [ ] Backup de PROD criado (arquivos, configs, banco)
- [ ] Scripts SQL para PROD criados e validados
- [ ] Horário de manutenção agendado (se necessário)
- [ ] Plano de rollback preparado

### **DURANTE A REPLICAÇÃO:**
- [ ] Arquivos PHP copiados com verificação de hash
- [ ] Arquivos JavaScript copiados com verificação de hash
- [ ] Configurações PHP-FPM aplicadas e validadas
- [ ] Scripts SQL executados e verificados
- [ ] Sintaxe PHP validada em PROD
- [ ] Variáveis de ambiente verificadas em PROD

### **APÓS A REPLICAÇÃO:**
- [ ] Testes funcionais executados em PROD
- [ ] Logs verificados (sem erros)
- [ ] Integridade de arquivos confirmada (hash)
- [ ] Schema do banco verificado
- [ ] Documentação atualizada
- [ ] Histórico atualizado

### **MONITORAMENTO (24-48h):**
- [ ] Logs de erro monitorados
- [ ] Métricas verificadas
- [ ] Nenhum problema identificado
- [ ] Replicação confirmada como bem-sucedida

---

## 🚨 REGRAS CRÍTICAS

### **NUNCA:**
1. ❌ **NUNCA** replicar sem revisar documento de tracking
2. ❌ **NUNCA** replicar sem criar backup de PROD
3. ❌ **NUNCA** replicar sem validar hash dos arquivos
4. ❌ **NUNCA** replicar sem testar em DEV primeiro
5. ❌ **NUNCA** replicar sem validar sintaxe PHP/JS

### **SEMPRE:**
1. ✅ **SEMPRE** atualizar documento de tracking após alteração em DEV
2. ✅ **SEMPRE** criar backup antes de replicar
3. ✅ **SEMPRE** verificar hash antes/depois da cópia
4. ✅ **SEMPRE** validar sintaxe antes de copiar
5. ✅ **SEMPRE** testar em PROD após replicação
6. ✅ **SEMPRE** documentar resultados

---

## 📊 RESUMO: COMO GARANTIR 100% DE SEGURANÇA

### **1. Tracking Automático**
- ✅ Documento único com todas as alterações
- ✅ Atualização obrigatória após cada mudança
- ✅ Checklist completo para replicação

### **2. Validação de Integridade**
- ✅ Hash SHA256 em todas as cópias
- ✅ Comparação DEV vs PROD
- ✅ Validação de sintaxe PHP/JS

### **3. Processo Documentado**
- ✅ Cada etapa documentada
- ✅ Histórico completo
- ✅ Auditoria rastreável

### **4. Extensões VS Code/Cursor**
- ✅ GitLens: Rastrear versões
- ✅ Remote SSH: Conexão segura
- ✅ SQL Tools: Validar banco
- ✅ PHP Intelephense: Validar código
- ✅ ESLint: Validar JavaScript

### **5. Scripts Automatizados**
- ✅ Tasks VS Code para replicação
- ✅ Scripts PowerShell para validação
- ✅ Scripts SQL idempotentes

---

**Processo criado para garantir replicação 100% segura e correta de DEV para PROD.**

