# 📚 SOLUÇÕES DE PERFORMANCE: EspoCRM (Documentação Oficial e Blogs)

**Data:** 25/11/2025  
**Fonte:** Documentação oficial EspoCRM + Blogs especializados  
**Problema Identificado:** I/O Wait alto (17-18%), muitas leituras de disco (2,400+ ops/s)

---

## 🎯 PRINCIPAIS PROBLEMAS E SOLUÇÕES

### **1. CONFIGURAÇÃO DO MYSQL/MARIADB** ⭐ **CRÍTICO**

#### **1.1. innodb_buffer_pool_size**

**Problema:**
- Buffer pool muito pequeno causa muitas leituras de disco
- Dados não ficam em memória, forçando acesso constante ao disco

**Solução:**
- **Configurar para ~70% da RAM disponível**
- Exemplo: Se RAM = 7.6 GB → `innodb_buffer_pool_size = 5.3 GB`

**Como aplicar:**
```bash
# Editar configuração do MySQL/MariaDB no container
docker exec -it espocrm-db bash
nano /etc/mysql/my.cnf
# ou
nano /etc/mysql/mariadb.conf.d/50-server.cnf

# Adicionar/modificar:
[mysqld]
innodb_buffer_pool_size = 5G  # 70% de 7.6 GB

# Reiniciar container
docker restart espocrm-db
```

**Impacto esperado:** ✅ **Redução significativa de leituras de disco**

**Fonte:** [docs.espocrm.com - Performance Tweaking](https://docs.espocrm.com/administration/performance-tweaking/)

---

#### **1.2. sort_buffer_size**

**Problema:**
- Operações `ORDER BY` e `GROUP BY` lentas
- Muitas operações de ordenação causam I/O

**Solução:**
- **Aumentar sort_buffer_size** (cuidado para não exagerar)

**Como aplicar:**
```bash
# No arquivo de configuração MySQL:
[mysqld]
sort_buffer_size = 2M  # Aumentar conforme necessário
```

**Impacto esperado:** ✅ **Melhoria em queries com ORDER BY/GROUP BY**

**Fonte:** [docs.espocrm.com - Performance Tweaking](https://docs.espocrm.com/administration/performance-tweaking/)

---

#### **1.3. innodb_log_file_size**

**Problema:**
- Log file muito pequeno causa muitas operações de flush
- Aumenta I/O de escrita

**Solução:**
- **Aumentar innodb_log_file_size** (geralmente 256M-512M)

**Como aplicar:**
```bash
# No arquivo de configuração MySQL:
[mysqld]
innodb_log_file_size = 256M
```

**Impacto esperado:** ✅ **Redução de operações de flush**

**Fonte:** [docs.espocrm.com - Performance Tweaking](https://docs.espocrm.com/administration/performance-tweaking/)

---

#### **1.4. innodb_flush_log_at_trx_commit**

**Problema:**
- Flush a cada transação causa muito I/O
- Performance degradada em alta carga

**Solução:**
- **Configurar para `2`** (melhor performance, risco mínimo de perda de dados)

**Como aplicar:**
```bash
# No arquivo de configuração MySQL:
[mysqld]
innodb_flush_log_at_trx_commit = 2
```

**⚠️ Atenção:** Pequeno risco de perda de dados em caso de falha do sistema (geralmente aceitável)

**Impacto esperado:** ✅ **Melhoria significativa de performance**

**Fonte:** [docs.espocrm.com - Performance Tweaking](https://docs.espocrm.com/administration/performance-tweaking/)

---

### **2. ÍNDICES NO BANCO DE DADOS** ⭐ **CRÍTICO**

#### **2.1. Criar Índices para Campos Frequentes**

**Problema:**
- Queries sem índices fazem full table scan
- Causa muitas leituras de disco
- Muito lento em tabelas grandes

**Solução:**
- **Criar índices para campos usados em filtros e ordenações**

**Como aplicar:**
1. **Identificar campos frequentemente usados:**
   - Campos em filtros de listas
   - Campos em ordenações
   - Campos em buscas

2. **Adicionar índices no arquivo de metadados:**
```json
{
    "indexes": {
        "nomeDoIndice": {
            "columns": ["nomeDaColuna"]
        },
        "indiceComposto": {
            "columns": ["campo1", "campo2"]
        }
    }
}
```

3. **Rebuild do banco de dados:**
```bash
docker exec espocrm php rebuild.php
```

**Impacto esperado:** ✅ **Redução drástica de leituras de disco**

**Fonte:** [docs.espocrm.com - Database Indexes](https://docs.espocrm.com/development/db-indexes/)

---

#### **2.2. Pesquisa Full-Text**

**Problema:**
- Buscas em campos de texto são lentas
- Full table scan em buscas

**Solução:**
- **Criar índices full-text para tabelas grandes**

**Como aplicar:**
- Configurar índices full-text no EspoCRM
- Usar para campos de texto extensos

**Impacto esperado:** ✅ **Melhoria significativa em buscas**

**Fonte:** [docs.espocrm.com - Performance Tweaking](https://docs.espocrm.com/administration/performance-tweaking/)

---

### **3. DESATIVAR CONTAGEM TOTAL EM LISTAGENS** ⭐ **IMPORTANTE**

**Problema:**
- Função `COUNT(*)` é muito lenta em tabelas grandes
- Causa muitas leituras de disco
- Impacta performance de listagens

**Solução:**
- **Desativar contagem total de registros**

**Como aplicar:**
1. Acessar: **Administração** > **Gerenciador de Entidades**
2. Selecionar entidade (ex: Lead, Opportunity, Contact)
3. Clicar em **Editar**
4. Marcar opção **"Desativar contagem de registros"**
5. Salvar

**Impacto esperado:** ✅ **Melhoria significativa em listagens**

**Fonte:** [docs.espocrm.com - Performance Tweaking](https://docs.espocrm.com/administration/performance-tweaking/)

---

### **4. GERENCIAMENTO DE LOGS** ⭐ **IMPORTANTE**

#### **4.1. Nível de Log**

**Problema:**
- Nível DEBUG/TRACE gera logs muito grandes
- Muitas operações de escrita em disco
- Impacta I/O

**Solução:**
- **Configurar nível de log para INFO ou WARNING**

**Como aplicar:**
- Via painel administrativo (se disponível)
- Ou via arquivo `data/config.php`:
```php
'logLevel' => 'INFO',  // ou 'WARNING'
```

**Impacto esperado:** ✅ **Redução de escrita de logs**

**Fonte:** Documentação EspoCRM + Blogs especializados

---

#### **4.2. Rotação e Limpeza de Logs**

**Problema:**
- Logs muito grandes (140 MB/dia)
- Ocupam espaço e causam I/O
- Podem causar "Error 500" se disco ficar cheio

**Solução:**
- **Implementar rotação automática de logs**
- **Limpar logs antigos regularmente**

**Como aplicar:**
```bash
# Configurar rotação de logs (logrotate)
sudo nano /etc/logrotate.d/espocrm

# Conteúdo:
/var/www/espocrm/data/logs/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 www-data www-data
}
```

**Impacto esperado:** ✅ **Redução de espaço e I/O**

**Fonte:** [falconitservices.com - EspoCRM Error 500](https://www.falconitservices.com/espocrm-suddenly-stops-working-displays-error-500/)

---

### **5. CONFIGURAÇÃO DO CRON JOB** ⭐ **IMPORTANTE**

**Problema:**
- Cron job não configurado corretamente
- Tarefas em background não executam
- Acúmulo de tarefas causa lentidão

**Solução:**
- **Verificar e configurar cron job corretamente**

**Como aplicar:**
```bash
# Verificar cron job
crontab -l

# Adicionar cron job do EspoCRM (se não existir)
*/1 * * * * cd /var/www/espocrm && php cron.php > /dev/null 2>&1
```

**Impacto esperado:** ✅ **Melhoria em tarefas em background**

**Fonte:** Documentação EspoCRM + Blogs especializados

---

### **6. CONFIGURAÇÃO DO PHP** ⭐ **OPCIONAL**

#### **6.1. Preloading**

**Problema:**
- Classes PHP carregadas a cada requisição
- Overhead de carregamento

**Solução:**
- **Utilizar preloading do PHP 7.4+**

**Como aplicar:**
- Configurar preloading no PHP-FPM
- Impacto geralmente menor que outras otimizações

**Impacto esperado:** ✅ **Melhoria leve de performance**

**Fonte:** [docs.espocrm.com - Performance Tweaking](https://docs.espocrm.com/administration/performance-tweaking/)

---

### **7. MONITORAMENTO E MANUTENÇÃO** ⭐ **CONTÍNUO**

**Problema:**
- Não identificar gargalos
- Problemas não detectados

**Solução:**
- **Implementar monitoramento contínuo**
- **Revisar queries lentas regularmente**
- **Monitorar uso de recursos**

**Ferramentas:**
- MySQL slow query log
- Monitoramento de CPU, RAM, I/O
- Logs do EspoCRM

**Impacto esperado:** ✅ **Identificação proativa de problemas**

**Fonte:** [docs.klutch.sh - EspoCRM Guide](https://docs.klutch.sh/guides/open-source-software/espocrm/)

---

## 📊 PRIORIZAÇÃO DAS SOLUÇÕES

### **🔴 ALTA PRIORIDADE (Resolver Imediatamente)**

1. **innodb_buffer_pool_size (70% RAM)**
   - **Impacto:** Muito alto
   - **Dificuldade:** Baixa
   - **Risco:** Baixo

2. **Criar Índices no Banco de Dados**
   - **Impacto:** Muito alto
   - **Dificuldade:** Média
   - **Risco:** Baixo

3. **Desativar Contagem Total em Listagens**
   - **Impacto:** Alto
   - **Dificuldade:** Baixa
   - **Risco:** Muito baixo

---

### **🟡 MÉDIA PRIORIDADE (Implementar em Breve)**

4. **innodb_flush_log_at_trx_commit = 2**
   - **Impacto:** Alto
   - **Dificuldade:** Baixa
   - **Risco:** Baixo (pequeno risco de perda de dados)

5. **Rotação e Limpeza de Logs**
   - **Impacto:** Médio
   - **Dificuldade:** Baixa
   - **Risco:** Muito baixo

6. **sort_buffer_size e innodb_log_file_size**
   - **Impacto:** Médio
   - **Dificuldade:** Baixa
   - **Risco:** Baixo

---

### **🟢 BAIXA PRIORIDADE (Opcional)**

7. **Pesquisa Full-Text**
   - **Impacto:** Médio
   - **Dificuldade:** Média
   - **Risco:** Baixo

8. **PHP Preloading**
   - **Impacto:** Baixo
   - **Dificuldade:** Média
   - **Risco:** Baixo

---

## 🎯 PLANO DE AÇÃO RECOMENDADO

### **FASE 1: Configuração MySQL (Imediato)**

1. ✅ Aumentar `innodb_buffer_pool_size` para 70% da RAM (~5.3 GB)
2. ✅ Configurar `innodb_flush_log_at_trx_commit = 2`
3. ✅ Aumentar `innodb_log_file_size` para 256M
4. ✅ Aumentar `sort_buffer_size` para 2M
5. ✅ Reiniciar container MySQL
6. ✅ Monitorar I/O wait (deve diminuir)

**Tempo estimado:** 30 minutos  
**Impacto esperado:** Redução de I/O wait de 17-18% para 5-10%

---

### **FASE 2: Otimização de Banco de Dados (Curto Prazo)**

1. ✅ Identificar campos frequentemente usados em filtros/ordenações
2. ✅ Criar índices para esses campos
3. ✅ Executar `php rebuild.php`
4. ✅ Desativar contagem total em listagens (entidades grandes)
5. ✅ Monitorar queries lentas

**Tempo estimado:** 2-4 horas  
**Impacto esperado:** Redução adicional de I/O wait para < 5%

---

### **FASE 3: Gerenciamento de Logs (Curto Prazo)**

1. ✅ Configurar rotação automática de logs
2. ✅ Limpar logs antigos
3. ✅ Verificar nível de log (deve ser INFO)
4. ✅ Monitorar tamanho de logs

**Tempo estimado:** 1 hora  
**Impacto esperado:** Redução de escrita de logs

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Configuração MySQL:**
- [ ] Fazer backup do banco de dados
- [ ] Fazer backup do arquivo de configuração MySQL
- [ ] Editar configuração MySQL
- [ ] Aplicar mudanças (innodb_buffer_pool_size, etc.)
- [ ] Reiniciar container MySQL
- [ ] Verificar que MySQL iniciou corretamente
- [ ] Monitorar I/O wait (deve diminuir)

### **Índices:**
- [ ] Identificar campos para indexar
- [ ] Criar índices no arquivo de metadados
- [ ] Executar `php rebuild.php`
- [ ] Verificar que índices foram criados
- [ ] Testar performance de queries

### **Listagens:**
- [ ] Identificar entidades com muitos registros
- [ ] Desativar contagem total nessas entidades
- [ ] Testar performance de listagens

### **Logs:**
- [ ] Configurar rotação de logs
- [ ] Limpar logs antigos
- [ ] Verificar nível de log
- [ ] Monitorar tamanho de logs

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Sempre fazer backup antes de alterações**
2. **Testar em ambiente de desenvolvimento primeiro**
3. **Monitorar após cada alteração**
4. **Documentar mudanças realizadas**
5. **Revisar queries lentas regularmente**

---

## 📚 FONTES

1. **Documentação Oficial EspoCRM:**
   - [Performance Tweaking](https://docs.espocrm.com/administration/performance-tweaking/)
   - [Database Indexes](https://docs.espocrm.com/development/db-indexes/)

2. **Blogs e Guias:**
   - [Klutch.sh - EspoCRM Guide](https://docs.klutch.sh/guides/open-source-software/espocrm/)
   - [Falcon IT Services - Error 500](https://www.falconitservices.com/espocrm-suddenly-stops-working-displays-error-500/)

3. **Fórum EspoCRM:**
   - [Forum.espocrm.com - Extension Issues](https://forum.espocrm.com/forum/extensions/104864-how-to-handle-extension-issues-after-epocrm-version-upgrade)

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **SOLUÇÕES IDENTIFICADAS E DOCUMENTADAS**

