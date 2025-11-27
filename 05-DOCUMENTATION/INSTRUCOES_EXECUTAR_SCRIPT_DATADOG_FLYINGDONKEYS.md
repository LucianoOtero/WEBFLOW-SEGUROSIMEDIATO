# 📋 Instruções: Executar Script Datadog no dev.flyingdonkeys.com.br

**Data:** 25/11/2025  
**Script:** `install_datadog_php_fpm_flyingdonkeys.sh`

---

## 🚀 COMO EXECUTAR

### **Opção 1: Via Console Hetzner (Recomendado)**

1. **Acessar Console Hetzner:**
   - Painel Hetzner Cloud → Servidor `dev.flyingdonkeys.com.br` → Console

2. **Copiar script para o servidor:**
   ```bash
   # No console do servidor, criar arquivo:
   nano /tmp/install_datadog_php_fpm.sh
   ```
   
   **Copiar conteúdo do arquivo:**
   `WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/install_datadog_php_fpm_flyingdonkeys.sh`

3. **Dar permissão de execução:**
   ```bash
   chmod +x /tmp/install_datadog_php_fpm.sh
   ```

4. **Executar script:**
   ```bash
   /tmp/install_datadog_php_fpm.sh
   ```

---

### **Opção 2: Via SCP (se conseguir acesso SSH)**

```bash
# Do seu computador local
scp WEBFLOW-SEGUROSIMEDIATO/06-SERVER-CONFIG/install_datadog_php_fpm_flyingdonkeys.sh root@dev.flyingdonkeys.com.br:/tmp/

# Conectar ao servidor
ssh root@dev.flyingdonkeys.com.br

# Executar script
chmod +x /tmp/install_datadog_php_fpm_flyingdonkeys.sh
/tmp/install_datadog_php_fpm_flyingdonkeys.sh
```

---

### **Opção 3: Executar Comandos Manualmente**

Se preferir executar passo a passo, seguir o guia:
`WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/GUIA_IMPLEMENTACAO_DATADOG_PHP_FPM.md`

---

## ✅ O QUE O SCRIPT FAZ

1. ✅ Verifica se Datadog Agent está instalado
2. ✅ Identifica versão PHP-FPM automaticamente
3. ✅ Identifica socket Unix automaticamente
4. ✅ Adiciona dd-agent ao grupo www-data
5. ✅ Verifica acesso ao socket
6. ✅ Cria backup (se configuração existir)
7. ✅ Cria arquivo de configuração
8. ✅ Valida sintaxe
9. ✅ Reinicia Datadog Agent
10. ✅ Valida integração
11. ✅ Verifica PHP-FPM

---

## ⚠️ PRÉ-REQUISITOS

- ✅ Datadog Agent instalado e rodando
- ✅ PHP-FPM instalado e rodando
- ✅ Acesso root ao servidor

---

## 📊 RESULTADO ESPERADO

Após execução bem-sucedida:
- ✅ Integração PHP-FPM aparecerá no status do Datadog como `[OK]`
- ✅ Métricas começarão a aparecer no dashboard (após alguns minutos)
- ✅ PHP-FPM continuará funcionando normalmente

---

## 🔍 VALIDAÇÃO

Após executar o script, validar:

```bash
# Verificar status da integração
datadog-agent status | grep -A 15 php_fpm

# Verificar PHP-FPM
systemctl status php*-fpm | head -10

# Verificar logs (se necessário)
tail -f /var/log/datadog-agent/collector.log | grep php_fpm
```

---

**Após executar, me avise o resultado para validarmos a implementação!**

