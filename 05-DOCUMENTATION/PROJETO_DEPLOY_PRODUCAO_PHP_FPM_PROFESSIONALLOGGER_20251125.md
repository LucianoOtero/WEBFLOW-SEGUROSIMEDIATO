# 🚀 PROJETO: Deploy para Produção - PHP-FPM e ProfessionalLogger.php

**Data de Criação:** 25/11/2025  
**Última Atualização:** 25/11/2025  
**Status:** 📋 **PROJETO ELABORADO - AGUARDANDO AUTORIZAÇÃO**  
**Versão:** 1.0.0  
**Ambiente:** Production (PROD)

---

## 🚨 ALERTAS OBRIGATÓRIOS - PRODUÇÃO

⚠️ **ALERTA CRÍTICO:** Este projeto envolve modificações no servidor de **PRODUÇÃO**  
⚠️ **ALERTA:** Servidor de produção: `prod.bssegurosimediato.com.br` (IP: `157.180.36.223`)  
⚠️ **ALERTA:** Caminho no servidor: `/var/www/html/prod/root/`  
⚠️ **ALERTA:** Procedimento para produção ainda não está oficialmente definido  
⚠️ **ALERTA:** Este projeto requer autorização explícita e verificação de `.env.production_access`

---

## 🎯 OBJETIVO DO PROJETO

Realizar deploy cuidadoso para produção das alterações implementadas em desenvolvimento:

1. **Configuração PHP-FPM:** Aumentar `pm.max_children` de 5 para 10
2. **Arquivo PHP:** Atualizar `ProfessionalLogger.php` com função cURL

### **Objetivos Específicos:**

1. ✅ Copiar arquivo PHP-FPM modificado do diretório de produção local para servidor de produção
2. ✅ Copiar `ProfessionalLogger.php` de desenvolvimento para diretório de produção local
3. ✅ Copiar `ProfessionalLogger.php` de produção local para servidor de produção
4. ✅ Aplicar configuração PHP-FPM no servidor (reload)
5. ✅ Garantir que nenhuma funcionalidade seja perdida ou quebrada
6. ✅ Manter todas as variáveis de ambiente de produção intactas

---

## 📋 ESPECIFICAÇÕES DO USUÁRIO

### **Objetivos do Usuário:**

1. ✅ **Aplicar correções testadas em desenvolvimento para produção**
   - Configuração PHP-FPM aumentada (10 workers)
   - Melhorias de diagnóstico (cURL)

2. ✅ **Evitar problemas anteriores**
   - Não perder variáveis de ambiente (como ocorreu em DEV)
   - Garantir que arquivos de produção sejam preservados antes de alterar
   - Validar integridade após cada cópia

3. ✅ **Garantir estabilidade e segurança**
   - Zero downtime durante deploy (usar `reload` ao invés de `restart`)
   - Rollback rápido se necessário
   - Validação completa antes e depois do deploy

### **Funcionalidades Solicitadas:**

1. ✅ **Deploy de Configuração PHP-FPM**
   - Copiar arquivo modificado de produção local para servidor
   - Aplicar apenas alterações necessárias (pm.max_children e relacionados)
   - Manter todas as variáveis de ambiente de produção

2. ✅ **Deploy de Arquivo PHP (ProfessionalLogger.php)**
   - Copiar de desenvolvimento para produção local primeiro
   - Copiar de produção local para servidor de produção
   - Atualizar com função cURL implementada em desenvolvimento
   - Manter compatibilidade com código existente

### **Requisitos Não-Funcionais:**

1. ✅ **Segurança:**
   - Backup completo antes de qualquer alteração
   - Validação de integridade após deploy (hash SHA256)
   - Rollback rápido se necessário

2. ✅ **Disponibilidade:**
   - Zero downtime (usar `reload` ao invés de `restart`)
   - Validação de funcionamento após deploy
   - Monitoramento de erros

3. ✅ **Confiabilidade:**
   - Validação de sintaxe e integridade
   - Testes funcionais básicos
   - Verificação de hash após cada cópia

### **Critérios de Aceitação do Usuário:**

1. ✅ **Critério 1: Variáveis de Ambiente Preservadas**
   - **Aceitação:** Todas as 42 variáveis de ambiente de produção devem estar presentes após deploy
   - **Métrica:** Contagem de variáveis `env[...]` no arquivo PHP-FPM
   - **Validação:** Comparar antes e depois do deploy

2. ✅ **Critério 2: PHP-FPM Configurado Corretamente**
   - **Aceitação:** `pm.max_children = 10` e configurações relacionadas aplicadas
   - **Métrica:** Validação de sintaxe e valores no arquivo
   - **Validação:** `php-fpm8.3 -tt` deve passar sem erros

3. ✅ **Critério 3: ProfessionalLogger.php Atualizado**
   - **Aceitação:** Função `makeHttpRequest()` (cURL) presente no arquivo
   - **Métrica:** Verificação de hash SHA256 e presença da função
   - **Validação:** Arquivo deve ter função cURL implementada

4. ✅ **Critério 4: Sem Erros Após Deploy**
   - **Aceitação:** Nenhum erro 500, 502, 503 nos logs após deploy
   - **Métrica:** Verificação de logs Nginx e PHP-FPM
   - **Validação:** Monitorar por 1 hora após deploy

### **Restrições e Limitações:**

1. 🚨 **Servidor de Produção:** IP `157.180.36.223` (prod.bssegurosimediato.com.br)
2. 🚨 **Procedimento de Produção:** Ainda não oficialmente definido (seguir diretivas de bloqueio)
3. 🚨 **Validação Obrigatória:** Verificar arquivo `.env.production_access` antes de executar
4. ⚠️ **Horário:** Preferencialmente fora do horário de pico
5. ⚠️ **Backup:** Obrigatório antes de qualquer alteração

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
   - **Mitigação:** Copiar arquivo de produção para local primeiro, fazer backup completo, verificar hash após cópia

2. 🚨 **RISCO MÉDIO: Problemas de Performance**
   - **Probabilidade:** Baixa
   - **Impacto:** Médio (pode degradar experiência do usuário)
   - **Mitigação:** Monitoramento após deploy, rollback se necessário

3. 🚨 **RISCO BAIXO: Downtime Não Planejado**
   - **Probabilidade:** Baixa
   - **Impacto:** Alto (sistema indisponível)
   - **Mitigação:** Usar `reload` ao invés de `restart`, validação prévia

4. 🚨 **RISCO BAIXO: Quebra de Funcionalidades**
   - **Probabilidade:** Baixa
   - **Impacto:** Alto (funcionalidades podem parar de funcionar)
   - **Mitigação:** Validação de sintaxe, testes funcionais básicos

---

## 📐 ARQUITETURA E DESIGN

### **Estrutura de Arquivos:**

```
WEBFLOW-SEGUROSIMEDIATO/
├── 02-DEVELOPMENT/          # Versões de desenvolvimento
│   └── ProfessionalLogger.php
├── 03-PRODUCTION/           # Versões de produção (local)
│   ├── php-fpm_www_conf_PROD.conf (modificado)
│   ├── php-fpm_www_conf_PROD_ORIGINAL.conf (backup)
│   └── ProfessionalLogger.php (será copiado de DEV)
├── 06-SERVER-CONFIG/        # Configurações de servidor
│   └── php-fpm_www_conf_DEV.conf
└── 05-DOCUMENTATION/        # Documentação
```

### **Fluxo de Deploy:**

```
1. Verificar .env.production_access
   ↓
2. Backup completo (servidor PROD)
   ↓
3. Copiar ProfessionalLogger.php de DEV para PROD local
   ↓
4. Validar integridade (hash SHA256)
   ↓
5. Copiar PHP-FPM de PROD local para servidor PROD
   ↓
6. Validar integridade (hash SHA256)
   ↓
7. Validar sintaxe PHP-FPM (php-fpm8.3 -tt)
   ↓
8. Copiar ProfessionalLogger.php de PROD local para servidor PROD
   ↓
9. Validar integridade (hash SHA256)
   ↓
10. Recarregar PHP-FPM (systemctl reload php8.3-fpm)
   ↓
11. Validação funcional
   ↓
12. Monitoramento (1 hora)
```

---

## 🔧 ESPECIFICAÇÕES TÉCNICAS

### **1. Configuração PHP-FPM**

#### **1.1. Arquivo a Copiar:**
- **Local (Modificado):** `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/php-fpm_www_conf_PROD.conf`
- **Servidor (Destino):** `/etc/php/8.3/fpm/pool.d/www.conf`
- **Status:** ✅ Arquivo modificado e pronto para deploy

#### **1.2. Alterações Contidas:**
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

### **2. Arquivo PHP (ProfessionalLogger.php)**

#### **2.1. Alterações Contidas:**
- Adicionar função `makeHttpRequest()` (cURL)
- Adicionar função `makeHttpRequestFileGetContents()` (fallback)
- Modificar `sendEmailNotification()` para usar `makeHttpRequest()`

#### **2.2. Compatibilidade:**
- ✅ Manter compatibilidade com código existente
- ✅ Fallback automático se cURL não disponível

---

## 📋 FASES DO PROJETO

### **FASE 0: Validação de Acesso a Produção** 🚨 **CRÍTICO**

**Objetivo:** Verificar se é permitido acessar produção

**Tarefas:**
1. ✅ Verificar existência do arquivo `.env.production_access`
2. ✅ Ler valor de `PRODUCTION_ACCESS` do arquivo
3. ✅ **Se `PRODUCTION_ACCESS=DISABLED`:** 
   - ❌ **BLOQUEAR** execução do projeto
   - 🚨 **EMITIR ALERTA** obrigatório
   - ✅ **PARAR** e informar ao usuário
4. ✅ **Se `PRODUCTION_ACCESS=ENABLED`:** 
   - ✅ Continuar com validação adicional
   - ✅ Verificar autorização explícita do usuário
5. ✅ **Se `PRODUCTION_ACCESS=READ_ONLY`:** 
   - ❌ **BLOQUEAR** modificações
   - ✅ Permitir apenas comandos de leitura/investigação

**Validações:**
- [ ] Arquivo `.env.production_access` verificado
- [ ] Valor `PRODUCTION_ACCESS` lido
- [ ] Autorização confirmada (se ENABLED)
- [ ] Alerta emitido (se necessário)

**Tempo Estimado:** 5 minutos

---

### **FASE 1: Preparação e Backup Completo**

**Objetivo:** Garantir que temos backup completo antes de qualquer alteração

**Tarefas:**
1. ✅ Criar backup completo do servidor PROD
   - Backup do arquivo PHP-FPM: `/etc/php/8.3/fpm/pool.d/www.conf`
   - Backup do arquivo `ProfessionalLogger.php` em `/var/www/html/prod/root/`
   - Registrar timestamp e localização dos backups

2. ✅ Verificar espaço em disco no servidor
   - Garantir espaço suficiente para backups
   - Verificar permissões de escrita

3. ✅ Documentar estado atual
   - Listar todas as variáveis de ambiente de produção
   - Documentar versões atuais dos arquivos
   - Registrar hash (SHA256) de todos os arquivos

**Comandos:**
```bash
# Backup PHP-FPM
ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_\$(date +%Y%m%d_%H%M%S)"

# Backup ProfessionalLogger.php
ssh root@157.180.36.223 "cp /var/www/html/prod/root/ProfessionalLogger.php /var/www/html/prod/root/ProfessionalLogger.php.backup_\$(date +%Y%m%d_%H%M%S)"

# Calcular hash dos arquivos atuais
ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf /var/www/html/prod/root/ProfessionalLogger.php"
```

**Validações:**
- [ ] Backup criado com sucesso
- [ ] Hash dos backups registrado
- [ ] Documentação do estado atual criada

**Tempo Estimado:** 10 minutos

---

### **FASE 2: Copiar ProfessionalLogger.php de DEV para PROD Local**

**Objetivo:** Preparar arquivo PHP para deploy

**Tarefas:**
1. ✅ Copiar arquivo de desenvolvimento para produção local:
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/ProfessionalLogger.php`
   - Destino: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/ProfessionalLogger.php`

2. ✅ Validar que arquivo foi copiado corretamente:
   - Calcular hash SHA256 do arquivo em DEV
   - Calcular hash SHA256 do arquivo em PROD local
   - Comparar hashes (devem ser idênticos)
   - Verificar que arquivo não está corrompido

3. ✅ Verificar conteúdo do arquivo:
   - Verificar que função `makeHttpRequest()` está presente
   - Verificar que função `makeHttpRequestFileGetContents()` está presente
   - Verificar que `sendEmailNotification()` foi modificada

**Comandos (PowerShell):**
```powershell
# Copiar arquivo
Copy-Item "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" -Destination "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php"

# Calcular hash DEV
$hashDev = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()

# Calcular hash PROD local
$hashProd = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()

# Comparar
if ($hashDev -eq $hashProd) {
    Write-Host "✅ Hash coincide - arquivo copiado corretamente"
} else {
    Write-Host "❌ Hash não coincide - tentar copiar novamente"
}
```

**Validações:**
- [ ] Arquivo copiado com sucesso
- [ ] Hash coincide com versão DEV
- [ ] Função cURL presente no arquivo
- [ ] Arquivo pronto para deploy

**Tempo Estimado:** 5 minutos

---

### **FASE 3: Copiar PHP-FPM de PROD Local para Servidor PROD**

**Objetivo:** Aplicar configuração PHP-FPM no servidor

**Tarefas:**
1. ✅ Calcular hash SHA256 do arquivo local:
   - Arquivo: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/php-fpm_www_conf_PROD.conf`
   - Registrar hash para comparação posterior

2. ✅ Copiar arquivo para servidor PROD:
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/php-fpm_www_conf_PROD.conf`
   - Destino: `/etc/php/8.3/fpm/pool.d/www.conf` no servidor `157.180.36.223`

3. ✅ Validar integridade após cópia:
   - Calcular hash SHA256 do arquivo no servidor
   - Comparar com hash do arquivo local (case-insensitive)
   - Se hashes não coincidirem, tentar copiar novamente

4. ✅ Validar sintaxe do arquivo:
   - Executar: `php-fpm8.3 -tt` no servidor
   - Verificar que não há erros de sintaxe
   - Verificar que todas as 42 variáveis de ambiente estão presentes

**Comandos:**
```bash
# Calcular hash local (PowerShell)
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\php-fpm_www_conf_PROD.conf" -Algorithm SHA256).Hash.ToUpper()

# Copiar para servidor (usar caminho completo do workspace)
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\php-fpm_www_conf_PROD.conf" root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf

# Validar hash no servidor
ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf | cut -d' ' -f1 | tr '[:lower:]' '[:upper:]'"

# Validar sintaxe
ssh root@157.180.36.223 "php-fpm8.3 -tt"
```

**Validações:**
- [ ] Arquivo copiado para servidor
- [ ] Hash coincide (case-insensitive)
- [ ] Sintaxe validada sem erros
- [ ] Todas as 42 variáveis de ambiente presentes

**Tempo Estimado:** 10 minutos

---

### **FASE 4: Copiar ProfessionalLogger.php de PROD Local para Servidor PROD**

**Objetivo:** Atualizar arquivo PHP no servidor

**Tarefas:**
1. ✅ Calcular hash SHA256 do arquivo local:
   - Arquivo: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/ProfessionalLogger.php`
   - Registrar hash para comparação posterior

2. ✅ Copiar arquivo para servidor PROD:
   - Origem: `WEBFLOW-SEGUROSIMEDIATO/03-PRODUCTION/ProfessionalLogger.php`
   - Destino: `/var/www/html/prod/root/ProfessionalLogger.php` no servidor `157.180.36.223`

3. ✅ Validar integridade após cópia:
   - Calcular hash SHA256 do arquivo no servidor
   - Comparar com hash do arquivo local (case-insensitive)
   - Se hashes não coincidirem, tentar copiar novamente

4. ✅ Validar sintaxe PHP:
   - Executar: `php -l /var/www/html/prod/root/ProfessionalLogger.php` no servidor
   - Verificar que não há erros de sintaxe

**Comandos:**
```bash
# Calcular hash local (PowerShell)
$hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()

# Copiar para servidor (usar caminho completo do workspace)
cd "C:\Users\Luciano\OneDrive - Imediato Soluções em Seguros\Imediato\imediatoseguros-rpa-playwright"
scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" root@157.180.36.223:/var/www/html/prod/root/ProfessionalLogger.php

# Validar hash no servidor
ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/ProfessionalLogger.php | cut -d' ' -f1 | tr '[:lower:]' '[:upper:]'"

# Validar sintaxe PHP
ssh root@157.180.36.223 "php -l /var/www/html/prod/root/ProfessionalLogger.php"
```

**Validações:**
- [ ] Arquivo copiado para servidor
- [ ] Hash coincide (case-insensitive)
- [ ] Sintaxe PHP validada sem erros
- [ ] Função cURL presente no arquivo

**Tempo Estimado:** 5 minutos

---

### **FASE 5: Aplicar Configuração PHP-FPM (Reload)**

**Objetivo:** Aplicar configuração sem downtime

**Tarefas:**
1. ✅ Recarregar PHP-FPM (sem reiniciar):
   - Executar: `systemctl reload php8.3-fpm`
   - Verificar que reload foi bem-sucedido
   - **NÃO usar `restart`** - usar apenas `reload` para zero downtime

2. ✅ Verificar status do PHP-FPM:
   - Executar: `systemctl status php8.3-fpm`
   - Verificar que serviço está ativo e funcionando
   - Verificar número de workers ativos

3. ✅ Verificar configuração aplicada:
   - Executar: `grep "pm.max_children" /etc/php/8.3/fpm/pool.d/www.conf`
   - Verificar que valor é `10`
   - Verificar outras configurações relacionadas

**Comandos:**
```bash
# Recarregar PHP-FPM (zero downtime)
ssh root@157.180.36.223 "systemctl reload php8.3-fpm"

# Verificar status
ssh root@157.180.36.223 "systemctl status php8.3-fpm"

# Verificar workers ativos
ssh root@157.180.36.223 "ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l"

# Verificar configuração aplicada
ssh root@157.180.36.223 "grep 'pm.max_children\|pm.start_servers\|pm.min_spare_servers\|pm.max_spare_servers' /etc/php/8.3/fpm/pool.d/www.conf"
```

**Validações:**
- [ ] PHP-FPM recarregado com sucesso
- [ ] Serviço ativo e funcionando
- [ ] Configuração aplicada corretamente
- [ ] Workers ativos dentro do limite

**Tempo Estimado:** 5 minutos

---

### **FASE 6: Validação Funcional e Monitoramento**

**Objetivo:** Garantir que sistema está funcionando corretamente após deploy

**Tarefas:**
1. ✅ Testes funcionais básicos:
   - Acessar site de produção
   - Verificar que `config_env.js.php` retorna HTTP 200
   - Verificar que variáveis de ambiente estão sendo expostas
   - Testar funcionalidade básica (se possível)

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

**Comandos:**
```bash
# Verificar logs Nginx (últimas 50 linhas)
ssh root@157.180.36.223 "tail -50 /var/log/nginx/error.log | grep -E '500|502|503'"

# Verificar logs PHP-FPM (últimas 50 linhas)
ssh root@157.180.36.223 "tail -50 /var/log/php8.3-fpm.log | grep -E 'ERROR|WARNING|max_children'"

# Verificar workers ativos
ssh root@157.180.36.223 "ps aux | grep 'php-fpm: pool www' | grep -v grep"

# Verificar hash final dos arquivos
ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf /var/www/html/prod/root/ProfessionalLogger.php"
```

**Validações:**
- [ ] Site acessível e funcionando
- [ ] Nenhum erro 500, 502, 503 nos logs
- [ ] PHP-FPM estável
- [ ] Funcionalidades básicas funcionando
- [ ] Integridade verificada

**Tempo Estimado:** 15 minutos (validação inicial) + 1 hora (monitoramento)

---

## 📊 CRONOGRAMA

| Fase | Descrição | Tempo Estimado | Dependências |
|------|-----------|----------------|--------------|
| 0 | Validação de Acesso a Produção | 5 min | - |
| 1 | Preparação e Backup Completo | 10 min | Fase 0 |
| 2 | Copiar ProfessionalLogger.php (DEV → PROD Local) | 5 min | - |
| 3 | Copiar PHP-FPM (PROD Local → Servidor PROD) | 10 min | Fase 1 |
| 4 | Copiar ProfessionalLogger.php (PROD Local → Servidor PROD) | 5 min | Fase 2, Fase 3 |
| 5 | Aplicar Configuração PHP-FPM (Reload) | 5 min | Fase 3 |
| 6 | Validação Funcional e Monitoramento | 15 min + 1h | Fase 4, Fase 5 |
| **TOTAL** | | **55 minutos** + **1 hora monitoramento** | |

---

## 🚨 PROCEDIMENTOS DE SEGURANÇA

### **1. Validação de Acesso Obrigatória:**

⚠️ **ANTES de executar QUALQUER comando:**
- ✅ Verificar arquivo `.env.production_access`
- ✅ Se `PRODUCTION_ACCESS=DISABLED`: **BLOQUEAR** e emitir alerta
- ✅ Se `PRODUCTION_ACCESS=ENABLED`: Permitir após validação adicional
- ✅ Se `PRODUCTION_ACCESS=READ_ONLY`: Permitir apenas leitura

### **2. Backup Obrigatório:**

✅ **SEMPRE criar backup antes de modificar:**
- Backup do arquivo PHP-FPM no servidor
- Backup do arquivo ProfessionalLogger.php no servidor
- Registrar timestamp e hash dos backups

### **3. Validação de Integridade Obrigatória:**

✅ **SEMPRE verificar hash após cópia:**
- Calcular hash SHA256 do arquivo local
- Calcular hash SHA256 do arquivo no servidor
- Comparar hashes (case-insensitive)
- Se não coincidirem, tentar copiar novamente

### **4. Validação de Sintaxe Obrigatória:**

✅ **SEMPRE validar sintaxe antes de aplicar:**
- PHP-FPM: `php-fpm8.3 -tt`
- PHP: `php -l arquivo.php`
- Se houver erros, **NÃO prosseguir**

### **5. Zero Downtime:**

✅ **SEMPRE usar `reload` ao invés de `restart`:**
- `systemctl reload php8.3-fpm` (zero downtime)
- **NÃO usar** `systemctl restart php8.3-fpm` (causa downtime)

---

## 🛡️ PLANO DETALHADO DE FALLBACK

### **Objetivo do Plano de Fallback:**

Garantir que, em caso de qualquer problema durante ou após o deploy, seja possível restaurar o sistema ao estado anterior de forma rápida e segura, minimizando impacto aos usuários.

### **Princípios do Plano de Fallback:**

1. ✅ **Sempre ter backup antes de modificar**
2. ✅ **Validar integridade após cada operação**
3. ✅ **Parar imediatamente se houver problemas críticos**
4. ✅ **Restaurar ao estado anterior se necessário**
5. ✅ **Documentar todos os problemas e ações tomadas**

### **Estratégia de Fallback:**

- **Fallback Parcial:** Restaurar apenas o arquivo/problemático
- **Fallback Completo:** Restaurar todos os arquivos modificados
- **Decisão:** Baseada na severidade e escopo do problema

### **Tempo Máximo de Resolução:**

- **Problemas Críticos (site inacessível):** 15-30 minutos
- **Problemas Altos (erros 500/502/503):** 10-20 minutos
- **Problemas Médios (funcionalidades quebradas):** 10-15 minutos
- **Problemas Baixos (hash não coincide):** 5-10 minutos

---

### **CENÁRIO 1: Falha na FASE 2 (Copiar ProfessionalLogger.php DEV → PROD Local)**

**Sintomas:**
- Hash não coincide após cópia
- Arquivo corrompido ou incompleto
- Erro de permissão ao copiar

**Ação de Fallback:**
1. ✅ **Verificar integridade do arquivo em DEV:**
   ```powershell
   $hashDev = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
   Write-Host "Hash DEV: $hashDev"
   ```

2. ✅ **Remover arquivo corrompido em PROD local (se existir):**
   ```powershell
   Remove-Item "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -ErrorAction SilentlyContinue
   ```

3. ✅ **Tentar copiar novamente:**
   ```powershell
   Copy-Item "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" -Destination "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -Force
   ```

4. ✅ **Validar hash novamente:**
   ```powershell
   $hashDev = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
   $hashProd = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
   if ($hashDev -ne $hashProd) {
       Write-Host "❌ FALHA: Hash ainda não coincide após 2 tentativas"
       Write-Host "🛑 PARAR DEPLOY - Investigar problema antes de continuar"
       exit 1
   }
   ```

5. ✅ **Se falhar após 2 tentativas:**
   - 🛑 **PARAR deploy imediatamente**
   - 🚨 **NÃO prosseguir** para próximas fases
   - 📋 **Documentar erro** e investigar causa
   - ✅ **Aguardar correção** antes de tentar novamente

**Tempo de Fallback:** 5 minutos  
**Impacto:** Nenhum (não afeta servidor de produção)

---

### **CENÁRIO 2: Falha na FASE 3 (Copiar PHP-FPM PROD Local → Servidor PROD)**

**Sintomas:**
- Hash não coincide após cópia
- Erro de sintaxe no PHP-FPM (`php-fpm8.3 -tt` falha)
- Variáveis de ambiente ausentes
- Erro de conexão SSH/SCP

**Ação de Fallback:**

#### **2.1. Se Hash Não Coincidir:**

1. ✅ **Tentar copiar novamente (máximo 2 tentativas):**
   ```bash
   # Tentativa 1
   scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\php-fpm_www_conf_PROD.conf" root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf
   
   # Verificar hash
   $hashServidor = (ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf | cut -d' ' -f1").ToUpper()
   $hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\php-fpm_www_conf_PROD.conf" -Algorithm SHA256).Hash.ToUpper()
   
   if ($hashServidor -ne $hashLocal) {
       # Tentativa 2
       scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\php-fpm_www_conf_PROD.conf" root@157.180.36.223:/etc/php/8.3/fpm/pool.d/www.conf
       # Verificar hash novamente
   }
   ```

2. ✅ **Se falhar após 2 tentativas:**
   - 🛑 **PARAR deploy imediatamente**
   - ✅ **Restaurar arquivo original do backup:**
     ```bash
     ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf"
     ```
   - ✅ **Verificar hash do arquivo restaurado:**
     ```bash
     ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf"
     ```
   - 🚨 **NÃO prosseguir** para próximas fases
   - 📋 **Documentar erro** e investigar causa (problema de rede, permissões, etc.)

#### **2.2. Se Erro de Sintaxe PHP-FPM:**

1. ✅ **Validar sintaxe localmente primeiro (antes de copiar):**
   ```bash
   # Verificar sintaxe do arquivo local (se possível)
   # Nota: php-fpm8.3 -tt só funciona no servidor, mas podemos verificar formato INI
   ```

2. ✅ **Se `php-fpm8.3 -tt` falhar no servidor:**
   - 🛑 **PARAR deploy imediatamente**
   - ✅ **Restaurar arquivo original do backup:**
     ```bash
     ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf"
     ```
   - ✅ **Validar sintaxe do arquivo restaurado:**
     ```bash
     ssh root@157.180.36.223 "php-fpm8.3 -tt"
     ```
   - 🚨 **NÃO prosseguir** até corrigir erro de sintaxe
   - 📋 **Documentar erro** e corrigir arquivo local antes de tentar novamente

#### **2.3. Se Variáveis de Ambiente Ausentes:**

1. ✅ **Verificar contagem de variáveis:**
   ```bash
   ssh root@157.180.36.223 "grep -c '^env\[' /etc/php/8.3/fpm/pool.d/www.conf"
   # Deve retornar 42
   ```

2. ✅ **Se contagem for diferente de 42:**
   - 🛑 **PARAR deploy imediatamente**
   - ✅ **Restaurar arquivo original do backup:**
     ```bash
     ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf"
     ```
   - ✅ **Verificar contagem do arquivo restaurado:**
     ```bash
     ssh root@157.180.36.223 "grep -c '^env\[' /etc/php/8.3/fpm/pool.d/www.conf"
     ```
   - 🚨 **NÃO prosseguir** até corrigir arquivo local
   - 📋 **Documentar quais variáveis estão faltando** e corrigir

#### **2.4. Se Erro de Conexão SSH/SCP:**

1. ✅ **Verificar conectividade:**
   ```bash
   ping 157.180.36.223
   ssh -o ConnectTimeout=10 root@157.180.36.223 "echo 'Conexão OK'"
   ```

2. ✅ **Se conexão falhar:**
   - 🛑 **PARAR deploy imediatamente**
   - 🚨 **NÃO tentar copiar** arquivos
   - 📋 **Documentar erro de conexão**
   - ✅ **Aguardar resolução** do problema de rede antes de tentar novamente

**Tempo de Fallback:** 10-15 minutos  
**Impacto:** Nenhum (arquivo original restaurado, sistema permanece funcionando)

---

### **CENÁRIO 3: Falha na FASE 4 (Copiar ProfessionalLogger.php PROD Local → Servidor PROD)**

**Sintomas:**
- Hash não coincide após cópia
- Erro de sintaxe PHP (`php -l` falha)
- Erro de conexão SSH/SCP

**Ação de Fallback:**

#### **3.1. Se Hash Não Coincidir:**

1. ✅ **Tentar copiar novamente (máximo 2 tentativas):**
   ```bash
   # Tentativa 1
   scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" root@157.180.36.223:/var/www/html/prod/root/ProfessionalLogger.php
   
   # Verificar hash
   $hashServidor = (ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/ProfessionalLogger.php | cut -d' ' -f1").ToUpper()
   $hashLocal = (Get-FileHash -Path "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" -Algorithm SHA256).Hash.ToUpper()
   
   if ($hashServidor -ne $hashLocal) {
       # Tentativa 2
       scp "WEBFLOW-SEGUROSIMEDIATO\03-PRODUCTION\ProfessionalLogger.php" root@157.180.36.223:/var/www/html/prod/root/ProfessionalLogger.php
       # Verificar hash novamente
   }
   ```

2. ✅ **Se falhar após 2 tentativas:**
   - 🛑 **PARAR deploy imediatamente**
   - ✅ **Restaurar arquivo original do backup:**
     ```bash
     ssh root@157.180.36.223 "cp /var/www/html/prod/root/ProfessionalLogger.php.backup_YYYYMMDD_HHMMSS /var/www/html/prod/root/ProfessionalLogger.php"
     ```
   - ✅ **Verificar hash do arquivo restaurado:**
     ```bash
     ssh root@157.180.36.223 "sha256sum /var/www/html/prod/root/ProfessionalLogger.php"
     ```
   - 🚨 **NÃO prosseguir** para próximas fases
   - 📋 **Documentar erro** e investigar causa

#### **3.2. Se Erro de Sintaxe PHP:**

1. ✅ **Se `php -l` falhar:**
   - 🛑 **PARAR deploy imediatamente**
   - ✅ **Restaurar arquivo original do backup:**
     ```bash
     ssh root@157.180.36.223 "cp /var/www/html/prod/root/ProfessionalLogger.php.backup_YYYYMMDD_HHMMSS /var/www/html/prod/root/ProfessionalLogger.php"
     ```
   - ✅ **Validar sintaxe do arquivo restaurado:**
     ```bash
     ssh root@157.180.36.223 "php -l /var/www/html/prod/root/ProfessionalLogger.php"
     ```
   - 🚨 **NÃO prosseguir** até corrigir erro de sintaxe
   - 📋 **Documentar erro** e corrigir arquivo local antes de tentar novamente

**Tempo de Fallback:** 5-10 minutos  
**Impacto:** Nenhum (arquivo original restaurado, sistema permanece funcionando)

---

### **CENÁRIO 4: Falha na FASE 5 (Aplicar Configuração PHP-FPM - Reload)**

**Sintomas:**
- `systemctl reload php8.3-fpm` falha
- PHP-FPM não inicia após reload
- Serviço PHP-FPM fica inativo
- Erro nos logs do PHP-FPM

**Ação de Fallback:**

1. ✅ **Verificar status do PHP-FPM:**
   ```bash
   ssh root@157.180.36.223 "systemctl status php8.3-fpm"
   ```

2. ✅ **Se serviço estiver inativo ou falhando:**
   - 🛑 **AÇÃO IMEDIATA: Restaurar configuração original:**
     ```bash
     ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf"
     ```

3. ✅ **Recarregar PHP-FPM com configuração original:**
   ```bash
   ssh root@157.180.36.223 "systemctl reload php8.3-fpm"
   ```

4. ✅ **Se reload falhar, tentar restart (último recurso):**
   ```bash
   ssh root@157.180.36.223 "systemctl restart php8.3-fpm"
   ```

5. ✅ **Verificar que serviço está funcionando:**
   ```bash
   ssh root@157.180.36.223 "systemctl status php8.3-fpm"
   ssh root@157.180.36.223 "ps aux | grep 'php-fpm: pool www' | grep -v grep | wc -l"
   ```

6. ✅ **Verificar logs por erros:**
   ```bash
   ssh root@157.180.36.223 "tail -50 /var/log/php8.3-fpm.log | grep -E 'ERROR|FATAL|WARNING'"
   ```

7. ✅ **Se serviço não iniciar:**
   - 🚨 **EMERGÊNCIA: Investigar logs detalhadamente:**
     ```bash
     ssh root@157.180.36.223 "journalctl -u php8.3-fpm -n 100 --no-pager"
     ```
   - 📋 **Documentar erro completo**
   - ✅ **Manter configuração original restaurada**
   - 🚨 **NÃO prosseguir** até identificar e corrigir problema

**Tempo de Fallback:** 5-10 minutos  
**Impacto:** Baixo (downtime mínimo se restart for necessário, mas configuração original restaurada)

---

### **CENÁRIO 5: Problemas Após Deploy (FASE 6 - Validação Funcional)**

**Sintomas:**
- Erros 500, 502, 503 nos logs
- Site inacessível
- Funcionalidades quebradas
- PHP-FPM instável
- Alto uso de recursos

**Ação de Fallback:**

#### **5.1. Se Erros 500, 502, 503:**

1. ✅ **Verificar logs imediatamente:**
   ```bash
   ssh root@157.180.36.223 "tail -100 /var/log/nginx/error.log | grep -E '500|502|503'"
   ssh root@157.180.36.223 "tail -100 /var/log/php8.3-fpm.log | grep -E 'ERROR|FATAL'"
   ```

2. ✅ **Identificar causa raiz:**
   - Se erro relacionado a `ProfessionalLogger.php`: Restaurar arquivo original
   - Se erro relacionado a PHP-FPM: Restaurar configuração original
   - Se erro não relacionado: Investigar mais profundamente

3. ✅ **Aplicar rollback parcial ou completo conforme necessário**

#### **5.2. Se Site Inacessível:**

1. ✅ **Verificar status dos serviços:**
   ```bash
   ssh root@157.180.36.223 "systemctl status nginx"
   ssh root@157.180.36.223 "systemctl status php8.3-fpm"
   ```

2. ✅ **Se PHP-FPM estiver inativo:**
   - Aplicar rollback completo (CENÁRIO 4)

3. ✅ **Se Nginx estiver inativo:**
   - Reiniciar Nginx:
     ```bash
     ssh root@157.180.36.223 "systemctl restart nginx"
     ```

#### **5.3. Se Funcionalidades Quebradas:**

1. ✅ **Identificar qual funcionalidade está quebrada:**
   - Se relacionada a logging: Restaurar `ProfessionalLogger.php` original
   - Se relacionada a performance: Restaurar configuração PHP-FPM original
   - Se relacionada a outras funcionalidades: Investigar logs

2. ✅ **Aplicar rollback seletivo conforme necessário**

#### **5.4. Se PHP-FPM Instável:**

1. ✅ **Verificar workers e recursos:**
   ```bash
   ssh root@157.180.36.223 "ps aux | grep 'php-fpm: pool www' | wc -l"
   ssh root@157.180.36.223 "free -h"
   ssh root@157.180.36.223 "top -bn1 | head -20"
   ```

2. ✅ **Se workers atingindo limite ou recursos esgotados:**
   - Restaurar configuração PHP-FPM original (valores menores)
   - Recarregar PHP-FPM

**Tempo de Fallback:** 10-20 minutos  
**Impacto:** Médio a Alto (dependendo da severidade do problema)

---

### **CENÁRIO 6: Rollback Completo (Último Recurso)**

**Quando Aplicar:**
- Múltiplos problemas simultâneos
- Sistema completamente inacessível
- Incapacidade de identificar causa raiz específica
- Decisão do administrador

**Ação de Fallback Completa:**

1. ✅ **Restaurar TODOS os arquivos dos backups:**
   ```bash
   # Restaurar PHP-FPM
   ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf"
   
   # Restaurar ProfessionalLogger.php
   ssh root@157.180.36.223 "cp /var/www/html/prod/root/ProfessionalLogger.php.backup_YYYYMMDD_HHMMSS /var/www/html/prod/root/ProfessionalLogger.php"
   ```

2. ✅ **Validar hash dos arquivos restaurados:**
   ```bash
   ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf /var/www/html/prod/root/ProfessionalLogger.php"
   ```

3. ✅ **Recarregar PHP-FPM:**
   ```bash
   ssh root@157.180.36.223 "systemctl reload php8.3-fpm"
   ```

4. ✅ **Se reload falhar, usar restart:**
   ```bash
   ssh root@157.180.36.223 "systemctl restart php8.3-fpm"
   ```

5. ✅ **Verificar status dos serviços:**
   ```bash
   ssh root@157.180.36.223 "systemctl status php8.3-fpm"
   ssh root@157.180.36.223 "systemctl status nginx"
   ```

6. ✅ **Testar acesso ao site:**
   - Acessar `https://prod.bssegurosimediato.com.br`
   - Verificar que site responde
   - Testar funcionalidades básicas

7. ✅ **Verificar logs por erros:**
   ```bash
   ssh root@157.180.36.223 "tail -100 /var/log/nginx/error.log"
   ssh root@157.180.36.223 "tail -100 /var/log/php8.3-fpm.log"
   ```

8. ✅ **Documentar rollback completo:**
   - Registrar timestamp do rollback
   - Listar todos os problemas encontrados
   - Documentar ações tomadas
   - Registrar estado final do sistema

**Tempo de Fallback:** 15-30 minutos  
**Impacto:** Médio (downtime durante rollback, mas sistema restaurado ao estado anterior)

---

### **CENÁRIO 7: Documentação de Problemas e Análise Pós-Fallback**

**Após aplicar qualquer fallback:**

1. ✅ **Documentar problema completo:**
   - Timestamp do problema
   - Fase em que ocorreu
   - Sintomas observados
   - Ações de fallback aplicadas
   - Resultado do fallback

2. ✅ **Registrar em arquivo de log:**
   - Criar arquivo: `FALLBACK_PROD_YYYYMMDD_HHMMSS.md`
   - Incluir todos os detalhes do problema
   - Incluir comandos executados
   - Incluir resultados das validações

3. ✅ **Análise de causa raiz:**
   - Identificar por que o problema ocorreu
   - Verificar se foi erro humano, técnico ou de infraestrutura
   - Propor correções preventivas

4. ✅ **Atualizar projeto:**
   - Adicionar lições aprendidas
   - Atualizar procedimentos se necessário
   - Documentar melhorias para próximos deploys

**Template de Documentação:**
```markdown
# FALLBACK APLICADO - [Data/Hora]

## Problema Detectado:
- Fase: [FASE X]
- Sintoma: [Descrição]
- Timestamp: [YYYY-MM-DD HH:MM:SS]

## Ações de Fallback Aplicadas:
1. [Ação 1]
2. [Ação 2]
...

## Resultado:
- Status: [Sucesso/Falha]
- Tempo de resolução: [X minutos]
- Sistema restaurado: [Sim/Não]

## Análise de Causa Raiz:
- Causa identificada: [Descrição]
- Tipo: [Erro humano/Técnico/Infraestrutura]
- Correções preventivas: [Lista]
```

---

## 📋 MATRIZ DE DECISÃO DE FALLBACK

| Problema | Severidade | Ação Imediata | Rollback Necessário? | Tempo Estimado |
|----------|-----------|---------------|---------------------|----------------|
| Hash não coincide (FASE 2) | Baixa | Tentar copiar novamente | Não | 5 min |
| Hash não coincide (FASE 3) | Média | Tentar copiar novamente | Sim (se falhar 2x) | 10-15 min |
| Hash não coincide (FASE 4) | Média | Tentar copiar novamente | Sim (se falhar 2x) | 5-10 min |
| Erro sintaxe PHP-FPM | Alta | Restaurar backup | Sim | 10 min |
| Erro sintaxe PHP | Alta | Restaurar backup | Sim | 5 min |
| Variáveis ausentes | Alta | Restaurar backup | Sim | 10 min |
| PHP-FPM não inicia | Crítica | Restaurar backup + restart | Sim | 10-15 min |
| Erros 500/502/503 | Alta | Investigar + restaurar se necessário | Parcial/Completo | 10-20 min |
| Site inacessível | Crítica | Verificar serviços + restaurar | Sim | 15-30 min |
| Funcionalidades quebradas | Média | Investigar + restaurar seletivo | Parcial | 10-15 min |
| PHP-FPM instável | Média | Restaurar configuração | Sim | 10 min |

---

## 📊 RESUMO EXECUTIVO DO PLANO DE FALLBACK

### **Cobertura do Plano:**

✅ **6 cenários de problemas cobertos:**
1. Falha na cópia ProfessionalLogger.php (DEV → PROD local)
2. Falha na cópia PHP-FPM (PROD local → servidor)
3. Falha na cópia ProfessionalLogger.php (PROD local → servidor)
4. Falha no reload PHP-FPM
5. Problemas após deploy (validação funcional)
6. Rollback completo (último recurso)

### **Procedimentos de Fallback:**

- ✅ **Tentativas de recuperação:** Máximo 2 tentativas antes de aplicar rollback
- ✅ **Validação obrigatória:** Hash SHA256 após cada operação
- ✅ **Restauração automática:** Backup sempre disponível para restauração
- ✅ **Zero downtime quando possível:** Usar `reload` ao invés de `restart`

### **Tempos de Resolução:**

- **Problemas Críticos:** 15-30 minutos
- **Problemas Altos:** 10-20 minutos
- **Problemas Médios:** 10-15 minutos
- **Problemas Baixos:** 5-10 minutos

### **Garantias do Plano:**

1. ✅ **Sistema sempre pode ser restaurado** ao estado anterior
2. ✅ **Backups sempre disponíveis** antes de qualquer modificação
3. ✅ **Validação de integridade** após cada operação
4. ✅ **Documentação completa** de todos os problemas

---

## 🔄 PROCEDIMENTO DE ROLLBACK

### **Se houver problemas após deploy:**

1. ✅ **Restaurar arquivos dos backups:**
   ```bash
   # Restaurar PHP-FPM
   ssh root@157.180.36.223 "cp /etc/php/8.3/fpm/pool.d/www.conf.backup_YYYYMMDD_HHMMSS /etc/php/8.3/fpm/pool.d/www.conf"
   
   # Restaurar ProfessionalLogger.php
   ssh root@157.180.36.223 "cp /var/www/html/prod/root/ProfessionalLogger.php.backup_YYYYMMDD_HHMMSS /var/www/html/prod/root/ProfessionalLogger.php"
   ```

2. ✅ **Recarregar PHP-FPM:**
   ```bash
   ssh root@157.180.36.223 "systemctl reload php8.3-fpm"
   ```

3. ✅ **Verificar hash dos arquivos restaurados:**
   ```bash
   ssh root@157.180.36.223 "sha256sum /etc/php/8.3/fpm/pool.d/www.conf /var/www/html/prod/root/ProfessionalLogger.php"
   ```

4. ✅ **Verificar funcionamento:**
   - Acessar site de produção
   - Verificar logs por erros
   - Confirmar que sistema está funcionando

---

## 🛑 CRITÉRIOS PARA PARAR O DEPLOY

### **Quando PARAR Imediatamente:**

1. 🚨 **Se hash não coincidir após 2 tentativas de cópia:**
   - 🛑 **PARAR** e não prosseguir
   - 📋 Investigar problema antes de continuar

2. 🚨 **Se validação de sintaxe falhar:**
   - 🛑 **PARAR** e não prosseguir
   - 📋 Corrigir arquivo local antes de tentar novamente

3. 🚨 **Se variáveis de ambiente estiverem ausentes:**
   - 🛑 **PARAR** e não prosseguir
   - 📋 Corrigir arquivo local antes de tentar novamente

4. 🚨 **Se PHP-FPM não iniciar após reload:**
   - 🛑 **PARAR** e aplicar rollback imediato
   - 📋 Restaurar configuração original

5. 🚨 **Se site ficar inacessível:**
   - 🛑 **PARAR** e aplicar rollback imediato
   - 📋 Restaurar todos os arquivos

6. 🚨 **Se múltiplos erros 500/502/503 aparecerem:**
   - 🛑 **PARAR** e aplicar rollback imediato
   - 📋 Investigar causa raiz

### **Regra de Ouro:**

> **"Se houver qualquer dúvida sobre a segurança do deploy, PARAR e aplicar rollback. É melhor não fazer alterações do que quebrar o sistema."**

---

## 📞 COMUNICAÇÃO DURANTE PROBLEMAS

### **Quando Comunicar ao Usuário:**

1. ✅ **Antes de aplicar rollback:**
   - Informar que problema foi detectado
   - Explicar ação de fallback que será tomada
   - Estimar tempo de resolução

2. ✅ **Durante rollback:**
   - Manter usuário informado sobre progresso
   - Informar se rollback está funcionando
   - Atualizar sobre tempo estimado

3. ✅ **Após rollback:**
   - Confirmar que sistema foi restaurado
   - Informar que sistema está funcionando normalmente
   - Documentar problemas encontrados para análise posterior

### **Template de Comunicação:**

```
🚨 ALERTA: Problema detectado durante deploy

Problema: [Descrição do problema]
Ação: [Ação de fallback sendo aplicada]
Tempo estimado: [X minutos]
Status: [Em andamento/Concluído]

Sistema será restaurado ao estado anterior.
```

---

## 📝 CHECKLIST DE DEPLOY

### **Antes de Iniciar:**
- [ ] Arquivo `.env.production_access` verificado
- [ ] `PRODUCTION_ACCESS=ENABLED` confirmado
- [ ] Autorização explícita do usuário obtida
- [ ] Backup completo criado
- [ ] Hash dos arquivos originais registrado

### **Durante Deploy:**
- [ ] ProfessionalLogger.php copiado de DEV para PROD local
- [ ] Hash validado (DEV vs PROD local)
- [ ] PHP-FPM copiado para servidor PROD
- [ ] Hash validado (local vs servidor)
- [ ] Sintaxe PHP-FPM validada
- [ ] ProfessionalLogger.php copiado para servidor PROD
- [ ] Hash validado (local vs servidor)
- [ ] Sintaxe PHP validada
- [ ] PHP-FPM recarregado (reload)
- [ ] Status do PHP-FPM verificado

### **Após Deploy:**
- [ ] Site acessível
- [ ] Nenhum erro 500, 502, 503
- [ ] PHP-FPM estável
- [ ] Funcionalidades básicas funcionando
- [ ] Integridade verificada
- [ ] Monitoramento iniciado (1 hora)

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
     - ✅ **Ação quando detectado:** BLOQUEAR automaticamente se `PRODUCTION_ACCESS=DISABLED`, emitir alerta obrigatório
   - 🚨 **ALERTA OBRIGATÓRIO:** Sempre emitir alerta quando detectar tentativa de acesso ao servidor de produção
   - ❌ **BLOQUEIO:** Não executar comandos ou modificações em produção até que procedimento seja oficialmente definido E arquivo `.env.production_access` tenha `PRODUCTION_ACCESS=ENABLED`

2. 🚨 **CACHE CLOUDFLARE - OBRIGATÓRIO:**
   - ⚠️ **IMPORTANTE:** Após atualizar arquivo `ProfessionalLogger.php` no servidor, **SEMPRE avisar** ao usuário sobre a necessidade de limpar o cache do Cloudflare para que as alterações sejam refletidas imediatamente.

3. 🚨 **BACKUP OBRIGATÓRIO:**
   - ✅ **SEMPRE criar backup** antes de qualquer modificação
   - ✅ **SEMPRE verificar hash** após cópia
   - ✅ **SEMPRE manter backups** por pelo menos 7 dias

4. 🚨 **ZERO DOWNTIME:**
   - ✅ **SEMPRE usar `reload`** ao invés de `restart`
   - ✅ **NUNCA usar `restart`** durante horário de pico

---

## ✅ CRITÉRIOS DE SUCESSO

1. ✅ **Configuração PHP-FPM aplicada:**
   - `pm.max_children = 10` ✅
   - Todas as 42 variáveis de ambiente preservadas ✅
   - PHP-FPM funcionando normalmente ✅

2. ✅ **Arquivo PHP atualizado:**
   - Função cURL implementada ✅
   - Compatibilidade mantida ✅
   - Sintaxe validada ✅

3. ✅ **Sistema funcionando:**
   - Nenhum erro 500, 502, 503 ✅
   - Funcionalidades básicas funcionando ✅
   - PHP-FPM estável ✅

4. ✅ **Integridade verificada:**
   - Hash SHA256 coincide ✅
   - Backups criados ✅
   - Rollback testado ✅

---

## 📝 HISTÓRICO DE VERSÕES

| Versão | Data | Alterações |
|--------|------|------------|
| 1.0.0 | 25/11/2025 | Criação inicial do projeto |

---

**Documento criado em:** 25/11/2025  
**Status:** 📋 **PROJETO ELABORADO - AGUARDANDO AUTORIZAÇÃO**

