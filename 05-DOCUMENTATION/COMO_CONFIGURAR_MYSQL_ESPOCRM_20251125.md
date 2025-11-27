# 🔧 COMO CONFIGURAR MYSQL NO ESPOCRM

**Data:** 25/11/2025  
**Servidor:** `flyingdonkeys.com.br` (37.27.1.242)  
**MySQL:** MariaDB 10.11.14 (container Docker)

---

## ❌ RESPOSTA DIRETA

**Não, o EspoCRM não oferece interface gráfica para configurar MySQL diretamente.**

As configurações do MySQL (como `innodb_buffer_pool_size`, `innodb_flush_log_at_trx_commit`, etc.) **não podem ser alteradas pela interface do EspoCRM**.

---

## ✅ OPÇÕES DISPONÍVEIS

### **OPÇÃO 1: Via Arquivo de Configuração MySQL (RECOMENDADO)**

**O que é:**
- Editar arquivo de configuração do MySQL/MariaDB
- Alterações são permanentes
- Aplicadas após reiniciar o container

**Como fazer:**

1. **Acessar container MySQL:**
```bash
ssh espo@37.27.1.242
docker exec -it espocrm-db bash
```

2. **Localizar arquivo de configuração:**
```bash
# Verificar onde está o arquivo de configuração
mysql --help | grep "Default options" -A 1

# Arquivos comuns:
# /etc/mysql/my.cnf
# /etc/mysql/mariadb.conf.d/50-server.cnf
# /etc/mysql/conf.d/*.cnf
```

3. **Editar arquivo:**
```bash
# Verificar arquivos disponíveis
ls -la /etc/mysql/
ls -la /etc/mysql/mariadb.conf.d/

# Editar arquivo (exemplo)
nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

4. **Adicionar configurações:**
```ini
[mysqld]
# Buffer pool (70% da RAM = ~5.3 GB para 7.6 GB RAM)
innodb_buffer_pool_size = 5G

# Flush log (melhor performance)
innodb_flush_log_at_trx_commit = 2

# Log file size
innodb_log_file_size = 256M

# Sort buffer
sort_buffer_size = 2M
```

5. **Sair e reiniciar container:**
```bash
exit  # Sair do container
docker restart espocrm-db
```

6. **Verificar configurações:**
```bash
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';"
```

**Vantagens:**
- ✅ Configurações permanentes
- ✅ Aplicadas automaticamente ao reiniciar
- ✅ Não precisa fazer toda vez

**Desvantagens:**
- ⚠️ Requer acesso SSH
- ⚠️ Requer reiniciar container

---

### **OPÇÃO 2: Via phpMyAdmin (Interface Web)**

**O que é:**
- Interface web para gerenciar MySQL
- Mais amigável que linha de comando
- **MAS:** Não permite alterar configurações do servidor MySQL (apenas dados)

**Limitação:**
- ❌ **NÃO permite alterar** `innodb_buffer_pool_size`, `innodb_flush_log_at_trx_commit`, etc.
- ✅ Permite apenas gerenciar **dados** (tabelas, queries, etc.)

**Quando usar:**
- Para gerenciar dados do banco
- Para executar queries SQL
- Para verificar estrutura de tabelas
- **NÃO para configurar servidor MySQL**

**Como instalar (se não tiver):**
```bash
# Instalar phpMyAdmin em container separado
docker run -d \
  --name phpmyadmin \
  -e PMA_HOST=espocrm-db \
  -e PMA_PORT=3306 \
  -p 8080:80 \
  --network container:espocrm-db \
  phpmyadmin/phpmyadmin
```

**Acesso:**
- URL: `http://37.27.1.242:8080`
- Usuário: `root`
- Senha: (senha do MySQL)

---

### **OPÇÃO 3: Via Linha de Comando (Temporário)**

**O que é:**
- Alterar variáveis em tempo de execução
- **MAS:** Alterações são temporárias (perdem ao reiniciar)

**Como fazer:**

1. **Acessar MySQL:**
```bash
ssh espo@37.27.1.242
docker exec -it espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD)
```

2. **Alterar variáveis:**
```sql
-- Alterar buffer pool (se permitido)
SET GLOBAL innodb_buffer_pool_size = 5368709120;  -- 5 GB

-- Verificar se foi aplicado
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
```

**Limitações:**
- ⚠️ Algumas variáveis **não podem ser alteradas** em tempo de execução
- ⚠️ Alterações são **temporárias** (perdem ao reiniciar)
- ⚠️ `innodb_buffer_pool_size` geralmente **não pode ser alterado** em tempo de execução

**Quando usar:**
- Para testar configurações temporariamente
- Para variáveis que podem ser alteradas em runtime
- **NÃO para configurações permanentes**

---

### **OPÇÃO 4: Via Variáveis de Ambiente Docker**

**O que é:**
- Configurar MySQL via variáveis de ambiente do container
- Algumas configurações podem ser passadas assim

**Como fazer:**

1. **Verificar docker-compose.yml ou comando docker:**
```bash
# Ver como o container foi criado
docker inspect espocrm-db | grep -A 20 "Env"
```

2. **Parar container:**
```bash
docker stop espocrm-db
```

3. **Recriar com variáveis de ambiente:**
```bash
# Exemplo (ajustar conforme necessário)
docker run -d \
  --name espocrm-db \
  -e MYSQL_ROOT_PASSWORD=senha \
  -e MYSQL_DATABASE=espocrm \
  mariadb:10.11 \
  --innodb-buffer-pool-size=5G \
  --innodb-flush-log-at-trx-commit=2
```

**Limitações:**
- ⚠️ Requer recriar container
- ⚠️ Pode perder dados se não configurar volumes corretamente
- ⚠️ Mais complexo

**Quando usar:**
- Se container foi criado manualmente
- Se tem controle total sobre criação do container
- **NÃO recomendado** se container já está em produção

---

## 🎯 RECOMENDAÇÃO PARA SEU CASO

### **Para Configurar MySQL no EspoCRM (flyingdonkeys.com.br):**

**Use a OPÇÃO 1: Via Arquivo de Configuração**

**Por quê:**
- ✅ Configurações permanentes
- ✅ Não perde ao reiniciar
- ✅ Mais seguro
- ✅ Padrão recomendado

**Passo a passo simplificado:**

1. **Conectar ao servidor:**
```bash
ssh espo@37.27.1.242
```

2. **Acessar container MySQL:**
```bash
docker exec -it espocrm-db bash
```

3. **Localizar e editar arquivo:**
```bash
# Verificar arquivos
ls -la /etc/mysql/mariadb.conf.d/

# Editar (geralmente 50-server.cnf)
nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

4. **Adicionar configurações:**
```ini
[mysqld]
innodb_buffer_pool_size = 5G
innodb_flush_log_at_trx_commit = 2
innodb_log_file_size = 256M
sort_buffer_size = 2M
```

5. **Sair e reiniciar:**
```bash
exit
docker restart espocrm-db
```

6. **Verificar:**
```bash
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';"
```

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Sempre fazer backup antes de alterar configurações**
2. **Testar em ambiente de desenvolvimento primeiro**
3. **Algumas configurações requerem reiniciar MySQL**
4. **Algumas variáveis não podem ser alteradas em runtime**
5. **Monitorar após alterações**

---

## 📋 CHECKLIST

- [ ] Fazer backup do banco de dados
- [ ] Fazer backup do arquivo de configuração MySQL
- [ ] Conectar ao servidor via SSH
- [ ] Acessar container MySQL
- [ ] Localizar arquivo de configuração
- [ ] Editar arquivo com novas configurações
- [ ] Salvar arquivo
- [ ] Sair do container
- [ ] Reiniciar container MySQL
- [ ] Verificar que MySQL iniciou corretamente
- [ ] Verificar que configurações foram aplicadas
- [ ] Monitorar I/O wait (deve diminuir)

---

## 🔍 VERIFICAÇÃO DE CONFIGURAÇÕES

**Após aplicar configurações, verificar:**

```bash
# Verificar buffer pool
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_buffer_pool_size';"

# Verificar flush log
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_flush_log_at_trx_commit';"

# Verificar log file size
docker exec espocrm-db mysql -uroot -p$(docker exec espocrm-db printenv MYSQL_ROOT_PASSWORD) -e "SHOW VARIABLES LIKE 'innodb_log_file_size';"
```

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **OPÇÕES DOCUMENTADAS**

