# 📋 GUIA: Reduzir Nível de Log do EspoCRM

**Data:** 25/11/2025  
**Objetivo:** Reduzir nível de log de DEBUG/TRACE para INFO/WARNING  
**Servidor:** `flyingdonkeys.com.br` (37.27.1.242)  
**Impacto Esperado:** Redução de ~140 MB/dia para ~10-20 MB/dia

---

## 🎯 MÉTODO 1: Via Painel Administrativo (RECOMENDADO)

### **PASSO 1: Acessar o Painel de Administração**

1. **Fazer login no EspoCRM:**
   - Acesse: `https://flyingdonkeys.com.br`
   - Faça login com uma conta de **Administrador**

2. **Abrir menu de Administração:**
   - No canto superior direito, clique no **ícone do seu perfil** (ou menu hambúrguer)
   - Selecione **"Administração"** (ou "Administration")

---

### **PASSO 2: Navegar até Configurações**

1. **No painel de administração:**
   - Procure por **"Configurações"** (ou "Settings")
   - Clique em **"Configurações"**

2. **Localizar seção de Logs:**
   - Procure por uma seção chamada:
     - **"Logs"** ou
     - **"Logging"** ou
     - **"System Logs"** ou
     - **"Debug"**

---

### **PASSO 3: Alterar Nível de Log**

1. **Encontrar opção de nível de log:**
   - Procure por um campo/dropdown com opções como:
     - `DEBUG`
     - `TRACE`
     - `INFO`
     - `WARNING`
     - `ERROR`

2. **Alterar para INFO ou WARNING:**
   - Selecione **`INFO`** (recomendado para produção)
   - Ou **`WARNING`** (mais restritivo, apenas avisos e erros)

3. **Salvar alterações:**
   - Clique em **"Salvar"** (ou "Save")
   - Aguarde confirmação de sucesso

---

### **PASSO 4: Verificar Alteração**

1. **Verificar logs:**
   - Aguarde alguns minutos
   - Verifique se os novos logs estão menores
   - Localização dos logs: `/var/www/espocrm/data/logs/`

2. **Confirmar redução:**
   - Após 1 hora, verifique o tamanho do log atual
   - Deve estar significativamente menor que antes

---

## 🔧 MÉTODO 2: Via Arquivo de Configuração (ALTERNATIVA)

**Se não encontrar a opção no painel administrativo, use este método:**

### **PASSO 1: Acessar o Servidor**

```bash
ssh espo@37.27.1.242
```

---

### **PASSO 2: Localizar Arquivo de Configuração**

```bash
# Navegar até o diretório do EspoCRM
cd /var/www/espocrm

# Verificar se arquivo existe
ls -la data/config.php
```

---

### **PASSO 3: Fazer Backup do Arquivo**

```bash
# Criar backup antes de modificar
cp data/config.php data/config.php.backup_$(date +%Y%m%d_%H%M%S)
```

---

### **PASSO 4: Editar Arquivo de Configuração**

```bash
# Abrir arquivo para edição
nano data/config.php
# ou
vi data/config.php
```

---

### **PASSO 5: Localizar e Alterar Nível de Log**

**Procurar por uma das seguintes linhas:**

```php
'logLevel' => 'DEBUG',
// ou
'logger' => [
    'level' => 'DEBUG',
],
// ou
'loggerLevel' => 'DEBUG',
```

**Alterar para:**

```php
'logLevel' => 'INFO',
// ou
'logger' => [
    'level' => 'INFO',
],
// ou
'loggerLevel' => 'INFO',
```

**Exemplo completo do arquivo:**

```php
<?php
return [
    'database' => [
        // ... configurações do banco ...
    ],
    'logLevel' => 'INFO',  // ← ALTERAR AQUI
    // ... outras configurações ...
];
```

---

### **PASSO 6: Salvar e Verificar**

1. **Salvar arquivo:**
   - No `nano`: `Ctrl + O`, depois `Enter`, depois `Ctrl + X`
   - No `vi`: `:wq` e `Enter`

2. **Verificar sintaxe PHP:**
   ```bash
   php -l data/config.php
   ```

3. **Reiniciar containers (se necessário):**
   ```bash
   # Verificar se precisa reiniciar
   docker restart espocrm
   ```

---

## 📊 NÍVEIS DE LOG DISPONÍVEIS

| Nível | Descrição | Uso Recomendado | Tamanho Esperado |
|-------|-----------|-----------------|------------------|
| **TRACE** | Muito detalhado (tudo) | Desenvolvimento | ~200 MB/dia |
| **DEBUG** | Detalhado (debug) | Desenvolvimento | ~140 MB/dia |
| **INFO** | Informações gerais | **Produção** ✅ | ~10-20 MB/dia |
| **WARNING** | Apenas avisos e erros | Produção crítica | ~5-10 MB/dia |
| **ERROR** | Apenas erros | Emergência | ~1-5 MB/dia |

---

## ✅ RECOMENDAÇÃO

### **Para Produção (flyingdonkeys.com.br):**

**Nível Recomendado:** `INFO`

**Por quê:**
- ✅ Reduz logs de ~140 MB/dia para ~10-20 MB/dia
- ✅ Ainda captura informações importantes
- ✅ Mantém avisos e erros
- ✅ Não perde informações críticas

**Se precisar de mais redução:**
- Use `WARNING` (apenas avisos e erros)
- Mas pode perder informações importantes

---

## 🔍 VERIFICAÇÃO PÓS-ALTERAÇÃO

### **Após 1 hora:**

```bash
# Verificar tamanho do log atual
ls -lh /var/www/espocrm/data/logs/espo-$(date +%Y-%m-%d).log

# Comparar com log anterior (se disponível)
ls -lh /var/www/espocrm/data/logs/espo-$(date -d "yesterday" +%Y-%m-%d).log
```

### **Após 24 horas:**

```bash
# Verificar tamanho do log do dia
ls -lh /var/www/espocrm/data/logs/espo-$(date +%Y-%m-%d).log

# Deve estar significativamente menor que antes (~140 MB)
```

**Resultado Esperado:**
- **Antes:** ~140 MB/dia
- **Depois (INFO):** ~10-20 MB/dia
- **Redução:** ~85-90%

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

1. **Não altere para ERROR:**
   - Pode perder informações importantes para diagnóstico
   - Use apenas em emergências

2. **Mantenha backup:**
   - Sempre faça backup antes de alterar configurações
   - Pode reverter se necessário

3. **Monitore após alteração:**
   - Verifique se logs ainda capturam informações necessárias
   - Ajuste se necessário

4. **Impacto no I/O:**
   - Redução de logs deve diminuir I/O wait
   - Monitore I/O wait após alteração

---

## 🚨 TROUBLESHOOTING

### **Problema: Não encontro opção no painel**

**Solução:** Use o Método 2 (arquivo de configuração)

---

### **Problema: Arquivo config.php não tem logLevel**

**Solução:** Adicione a linha manualmente:

```php
<?php
return [
    // ... configurações existentes ...
    'logLevel' => 'INFO',  // ← ADICIONAR ESTA LINHA
];
```

---

### **Problema: Logs não diminuíram após alteração**

**Possíveis causas:**
1. Alteração não foi salva corretamente
2. Cache do EspoCRM precisa ser limpo
3. Containers precisam ser reiniciados

**Solução:**
```bash
# Limpar cache do EspoCRM
docker exec espocrm php rebuild.php

# Reiniciar container
docker restart espocrm
```

---

### **Problema: Erro de sintaxe PHP**

**Solução:**
```bash
# Verificar sintaxe
php -l data/config.php

# Se houver erro, restaurar backup
cp data/config.php.backup_* data/config.php
```

---

## 📝 CHECKLIST DE IMPLEMENTAÇÃO

- [ ] Fazer login no EspoCRM como Administrador
- [ ] Acessar painel de Administração
- [ ] Localizar seção de Configurações/Logs
- [ ] Alterar nível de log para `INFO`
- [ ] Salvar alterações
- [ ] Aguardar 1 hora
- [ ] Verificar tamanho do log atual
- [ ] Confirmar redução (deve estar menor)
- [ ] Monitorar I/O wait (deve melhorar)

**OU (se usar método alternativo):**

- [ ] Conectar ao servidor via SSH
- [ ] Fazer backup do `data/config.php`
- [ ] Editar arquivo `data/config.php`
- [ ] Alterar `logLevel` para `INFO`
- [ ] Verificar sintaxe PHP
- [ ] Salvar arquivo
- [ ] Reiniciar container (se necessário)
- [ ] Verificar logs após 1 hora

---

## 📊 RESULTADO ESPERADO

### **Antes da Alteração:**
- Logs: ~140 MB/dia
- I/O Wait: 9-18%
- Disco: Alto uso de I/O

### **Depois da Alteração (INFO):**
- Logs: ~10-20 MB/dia (redução de ~85-90%)
- I/O Wait: Deve diminuir para 5-10%
- Disco: Menor uso de I/O

---

**Documento criado em:** 25/11/2025  
**Status:** ✅ **GUIA PRONTO PARA USO**

