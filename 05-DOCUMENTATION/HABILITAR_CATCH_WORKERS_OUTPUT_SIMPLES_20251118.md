# ✅ HABILITAR catch_workers_output - PROCEDIMENTO SIMPLES

**Data:** 18/11/2025  
**Servidor:** DEV (`dev.bssegurosimediato.com.br` - IP: 65.108.156.14)  
**Complexidade:** 🟢 **SIMPLES** (2-3 minutos)

---

## ✅ SIM, É SIMPLES!

### **O que fazer:**
Descomentar uma linha no arquivo de configuração do PHP-FPM e reiniciar o serviço.

---

## 📋 PASSOS NECESSÁRIOS

### **1. Criar Backup do Arquivo**
```bash
ssh root@65.108.156.14 "cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.backup_catch_workers_$(date +%Y%m%d_%H%M%S)"
```

### **2. Editar Arquivo de Configuração**
**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

**Linha atual:**
```ini
;catch_workers_output = yes
```

**Alterar para:**
```ini
catch_workers_output = yes
```

**Ação:** Remover o `;` do início da linha (descomentar)

### **3. Verificar Sintaxe**
```bash
ssh root@65.108.156.14 "php-fpm8.3 -t"
```

**Resultado esperado:** `configuration file /etc/php/8.3/fpm/php-fpm.conf test is successful`

### **4. Reiniciar PHP-FPM**
```bash
ssh root@65.108.156.14 "systemctl restart php8.3-fpm"
```

### **5. Verificar Status**
```bash
ssh root@65.108.156.14 "systemctl status php8.3-fpm --no-pager"
```

**Resultado esperado:** `Active: active (running)`

---

## ⏱️ TEMPO ESTIMADO

**Total:** 2-3 minutos

- Backup: 10 segundos
- Edição: 30 segundos
- Verificação de sintaxe: 10 segundos
- Reinício: 30 segundos
- Verificação de status: 10 segundos

---

## ⚠️ RESSALVAS

### **1. Backup Obrigatório**
✅ **SEMPRE criar backup antes de modificar configuração do servidor**

### **2. Verificação de Sintaxe**
✅ **SEMPRE verificar sintaxe antes de reiniciar serviço**

### **3. Aumento de Logs**
⚠️ **Habilitar `catch_workers_output` pode gerar mais logs**
- Logs podem aumentar significativamente
- Monitorar uso de disco
- Considerar rotação de logs se necessário

### **4. Impacto no Desempenho**
✅ **Impacto mínimo ou nenhum**
- Apenas habilita captura de erros
- Não afeta desempenho da aplicação

---

## ✅ BENEFÍCIOS

### **Após habilitar:**
1. ✅ Erros HTTP 500 aparecerão nos logs do PHP-FPM
2. ✅ Poderemos identificar a causa exata do erro
3. ✅ Debugging será muito mais fácil
4. ✅ Problemas futuros serão mais fáceis de diagnosticar

---

## 🔍 VERIFICAÇÃO PÓS-IMPLEMENTAÇÃO

### **1. Testar Endpoint**
```bash
curl -X POST https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php \
  -H "Content-Type: application/json" \
  -d '{"ddd":"11","celular":"987654321","momento":"test"}'
```

### **2. Verificar Logs Imediatamente**
```bash
ssh root@65.108.156.14 "tail -n 50 /var/log/php8.3-fpm.log"
```

**Resultado esperado:** Erros relacionados ao endpoint devem aparecer nos logs

---

## 📋 RESUMO

| Item | Valor |
|------|-------|
| **Complexidade** | 🟢 Simples |
| **Tempo** | 2-3 minutos |
| **Ação Principal** | Descomentar 1 linha |
| **Risco** | 🟢 Baixo (com backup e verificação) |
| **Benefício** | 🔴 Alto (identificar causa de HTTP 500) |

---

**Documento criado em:** 18/11/2025  
**Status:** ✅ **PRONTO PARA IMPLEMENTAÇÃO**

