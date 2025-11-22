# 📋 TODO: Parametrização SafetyMails DEV vs PROD

**Data de Criação:** 16/11/2025  
**Status:** 📋 **PENDENTE**  
**Prioridade:** 🔶 **MÉDIA**

---

## 🎯 OBJETIVO

Implementar parametrização específica para as credenciais do SafetyMails (`SAFETY_TICKET` e `SAFETY_API_KEY`) diferenciando entre ambientes DEV e PROD, seguindo o mesmo padrão usado para outras APIs (EspoCRM, Webflow Secrets).

---

## 📊 SITUAÇÃO ATUAL

### **Problema Identificado:**

- ❌ Credenciais SafetyMails estão **hardcoded** no JavaScript
- ❌ **Mesmas credenciais** são usadas em DEV e PROD
- ❌ **Não há variáveis de ambiente** PHP-FPM para SafetyMails
- ❌ **Não há lógica condicional** baseada em ambiente

### **Credenciais Atuais:**

| Ambiente | SAFETY_TICKET | SAFETY_API_KEY |
|----------|---------------|----------------|
| **DEV** | `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` | `20a7a1c297e39180bd80428ac13c363e882a531f` |
| **PROD** | `9bab7f0c2711c5accfb83588c859dc1103844a94` | `20a7a1c297e39180bd80428ac13c363e882a531f` |

---

## ✅ TAREFAS A IMPLEMENTAR

### **FASE 1: Adicionar Variáveis de Ambiente PHP-FPM**

#### **1.1. Arquivo DEV (`php-fpm_www_conf_DEV.conf`)**

**Adicionar:**
```ini
; SafetyMails DEV
env[SAFETY_TICKET_DEV] = 05bf2ec47128ca0b917f8b955bada1bd3cadd47e
env[SAFETY_API_KEY] = 20a7a1c297e39180bd80428ac13c363e882a531f
```

#### **1.2. Arquivo PROD (`php-fpm_www_conf_PROD.conf`)**

**Adicionar:**
```ini
; SafetyMails PROD
env[SAFETY_TICKET_PROD] = 9bab7f0c2711c5accfb83588c859dc1103844a94
env[SAFETY_API_KEY] = 20a7a1c297e39180bd80428ac13c363e882a531f
```

**Nota:** `SAFETY_API_KEY` pode ser compartilhada se for a mesma em ambos os ambientes.

---

### **FASE 2: Expor Variáveis via `config_env.js.php`**

#### **2.1. Atualizar `config_env.js.php` (DEV e PROD)**

**Adicionar exposição das credenciais SafetyMails:**

```php
// SafetyMails Credentials
$safety_ticket = $_ENV['SAFETY_TICKET_DEV'] ?? ''; // DEV
// OU
$safety_ticket = $_ENV['SAFETY_TICKET_PROD'] ?? ''; // PROD

$safety_api_key = $_ENV['SAFETY_API_KEY'] ?? '';

// Expor para JavaScript
?>
window.SAFETY_TICKET = <?php echo json_encode($safety_ticket); ?>;
window.SAFETY_API_KEY = <?php echo json_encode($safety_api_key); ?>;
```

**OU usar lógica condicional:**

```php
// Detectar ambiente
$environment = $_ENV['PHP_ENV'] ?? 'development';
$is_prod = ($environment === 'production' || $environment === 'prod');

// SafetyMails Credentials baseado em ambiente
$safety_ticket = $is_prod 
    ? ($_ENV['SAFETY_TICKET_PROD'] ?? '')
    : ($_ENV['SAFETY_TICKET_DEV'] ?? '');
$safety_api_key = $_ENV['SAFETY_API_KEY'] ?? '';

// Expor para JavaScript
?>
window.SAFETY_TICKET = <?php echo json_encode($safety_ticket); ?>;
window.SAFETY_API_KEY = <?php echo json_encode($safety_api_key); ?>;
```

---

### **FASE 3: Atualizar `FooterCodeSiteDefinitivoCompleto.js`**

#### **3.1. Remover Hardcode e Usar Variáveis Globais**

**ANTES (hardcoded):**
```javascript
window.SAFETY_TICKET = '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // DEV: Ticket origem atualizado
window.SAFETY_API_KEY = '20a7a1c297e39180bd80428ac13c363e882a531f'; // Mesmo para DEV e PROD
```

**DEPOIS (usar variáveis expostas por config_env.js.php):**
```javascript
// SafetyMails Credentials (vindas de config_env.js.php)
// Se não estiverem definidas, usar fallback (para compatibilidade)
window.SAFETY_TICKET = window.SAFETY_TICKET || '05bf2ec47128ca0b917f8b955bada1bd3cadd47e'; // Fallback DEV
window.SAFETY_API_KEY = window.SAFETY_API_KEY || '20a7a1c297e39180bd80428ac13c363e882a531f'; // Fallback
```

**OU (sem fallback, obrigatório):**
```javascript
// SafetyMails Credentials (devem vir de config_env.js.php)
if (typeof window.SAFETY_TICKET === 'undefined' || typeof window.SAFETY_API_KEY === 'undefined') {
    console.error('[CONFIG] ERRO CRÍTICO: SAFETY_TICKET ou SAFETY_API_KEY não estão definidos');
    throw new Error('SAFETY_TICKET ou SAFETY_API_KEY não estão definidos - verifique config_env.js.php');
}
```

---

### **FASE 4: Ordem de Carregamento**

#### **4.1. Garantir que `config_env.js.php` é carregado ANTES de `FooterCodeSiteDefinitivoCompleto.js`**

**No Webflow Footer Code:**
```html
<!-- PRIMEIRO: config_env.js.php (expõe variáveis de ambiente) -->
<script src="https://prod.bssegurosimediato.com.br/config_env.js.php" defer></script>

<!-- SEGUNDO: FooterCodeSiteDefinitivoCompleto.js (usa as variáveis) -->
<script 
  src="https://prod.bssegurosimediato.com.br/FooterCodeSiteDefinitivoCompleto.js" 
  defer
  data-app-base-url="https://prod.bssegurosimediato.com.br"
  data-app-environment="production">
</script>
```

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

### **Preparação:**
- [ ] Verificar se `SAFETY_API_KEY` é a mesma em DEV e PROD
- [ ] Confirmar valores corretos de `SAFETY_TICKET_DEV` e `SAFETY_TICKET_PROD`
- [ ] Criar backups dos arquivos que serão modificados

### **FASE 1: Variáveis de Ambiente PHP-FPM**
- [ ] Adicionar `SAFETY_TICKET_DEV` em `php-fpm_www_conf_DEV.conf`
- [ ] Adicionar `SAFETY_TICKET_PROD` em `php-fpm_www_conf_PROD.conf`
- [ ] Adicionar `SAFETY_API_KEY` em ambos os arquivos (se compartilhada)
- [ ] Criar backup dos arquivos PHP-FPM antes de modificar
- [ ] Copiar arquivos modificados para servidores
- [ ] Reiniciar PHP-FPM em DEV: `systemctl restart php8.3-fpm`
- [ ] Reiniciar PHP-FPM em PROD: `systemctl restart php8.3-fpm`
- [ ] Verificar variáveis via `php -r "echo getenv('SAFETY_TICKET_DEV');"` (DEV)
- [ ] Verificar variáveis via `php -r "echo getenv('SAFETY_TICKET_PROD');"` (PROD)

### **FASE 2: Exposição via config_env.js.php**
- [ ] Atualizar `02-DEVELOPMENT/config_env.js.php` para expor SafetyMails
- [ ] Atualizar `03-PRODUCTION/config_env.js.php` para expor SafetyMails
- [ ] Testar `config_env.js.php` em DEV: `curl https://dev.bssegurosimediato.com.br/config_env.js.php`
- [ ] Testar `config_env.js.php` em PROD: `curl https://prod.bssegurosimediato.com.br/config_env.js.php`
- [ ] Verificar que `window.SAFETY_TICKET` e `window.SAFETY_API_KEY` estão sendo expostos

### **FASE 3: Atualizar FooterCodeSiteDefinitivoCompleto.js**
- [ ] Criar backup de `02-DEVELOPMENT/FooterCodeSiteDefinitivoCompleto.js`
- [ ] Criar backup de `03-PRODUCTION/FooterCodeSiteDefinitivoCompleto.js`
- [ ] Remover hardcode de `SAFETY_TICKET` e `SAFETY_API_KEY`
- [ ] Adicionar lógica para usar variáveis de `config_env.js.php`
- [ ] Adicionar fallback ou validação (conforme decisão)
- [ ] Testar em DEV após modificação
- [ ] Testar em PROD após modificação

### **FASE 4: Ordem de Carregamento**
- [ ] Verificar ordem de carregamento no Webflow Footer Code
- [ ] Garantir que `config_env.js.php` é carregado ANTES de `FooterCodeSiteDefinitivoCompleto.js`
- [ ] Testar carregamento em DEV
- [ ] Testar carregamento em PROD

### **FASE 5: Testes e Validação**
- [ ] Testar validação de email SafetyMails em DEV
- [ ] Testar validação de email SafetyMails em PROD
- [ ] Verificar logs do SafetyMails para confirmar uso correto
- [ ] Verificar que não há erros no console do navegador
- [ ] Documentar implementação

---

## 🔍 REFERÊNCIAS

### **Padrão de Outras APIs (para seguir como exemplo):**

**EspoCRM (config.php):**
```php
function getEspoCrmApiKey() {
    return $_ENV['ESPOCRM_API_KEY'] ?? (isDevelopment()
        ? '73b5b7983bfc641cdba72d204a48ed9d'  // DEV
        : '82d5f667f3a65a9a43341a0705be2b0c'); // PROD
}
```

**Webflow Secrets (config.php):**
```php
function getWebflowSecretFlyingDonkeys() {
    return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'] ?? (isDevelopment()
        ? '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51'  // DEV
        : '50ed8a43f11260135b51965f27dc6bdde5156a74bb21f3fea387fcc0417a7c51'); // PROD
}
```

---

## 📝 NOTAS IMPORTANTES

1. **Ordem de Carregamento:**
   - `config_env.js.php` DEVE ser carregado ANTES de `FooterCodeSiteDefinitivoCompleto.js`
   - Usar `defer` nos scripts para garantir ordem

2. **Fallback vs Validação:**
   - **Opção 1 (Fallback):** Usar valores hardcoded como fallback se variáveis não estiverem disponíveis
   - **Opção 2 (Validação):** Lançar erro se variáveis não estiverem disponíveis (mais seguro)

3. **Compatibilidade:**
   - Garantir que implementação seja compatível com código existente
   - Testar em ambos os ambientes antes de considerar completo

4. **Documentação:**
   - Atualizar documentação de arquitetura após implementação
   - Documentar valores das credenciais (sem expor em documentação pública)

---

## 🎯 RESULTADO ESPERADO

Após implementação:

1. ✅ Credenciais SafetyMails diferenciadas por ambiente (DEV e PROD)
2. ✅ Variáveis de ambiente PHP-FPM configuradas
3. ✅ Exposição via `config_env.js.php` funcionando
4. ✅ `FooterCodeSiteDefinitivoCompleto.js` usando variáveis de ambiente
5. ✅ Validação de email SafetyMails funcionando em ambos os ambientes
6. ✅ Padrão consistente com outras APIs do projeto

---

**Data de Criação:** 16/11/2025  
**Status:** 📋 **PENDENTE**  
**Prioridade:** 🔶 **MÉDIA**

