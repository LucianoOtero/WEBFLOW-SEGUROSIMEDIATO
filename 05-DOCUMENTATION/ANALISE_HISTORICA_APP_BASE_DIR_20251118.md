# 📅 ANÁLISE HISTÓRICA: Variável APP_BASE_DIR

**Data:** 18/11/2025  
**Pergunta:** A variável `APP_BASE_DIR` já existia antes da implementação do sistema de logging unificado?

---

## 📊 CRONOLOGIA

### **03/11/2025 - Criação do Endpoint**
- `send_email_notification_endpoint.php` criado (versão 1.1)
- **NÃO usava `config.php`**
- Headers CORS hardcoded: `header('Access-Control-Allow-Origin: *')`
- **Não dependia de `APP_BASE_DIR`**

---

### **10/11/2025 - Introdução do config.php**
- `config.php` criado (versão 2.0.0)
- Endpoint atualizado para versão 1.2
- **Passou a usar `config.php` para CORS** (`setCorsHeaders()`)
- `config.php` tinha **FALLBACK**:
  ```php
  function getBaseDir() {
      $baseDir = $_ENV['APP_BASE_DIR'] ?? __DIR__;  // ✅ FALLBACK para __DIR__
      return rtrim($baseDir, '/\\');
  }
  ```
- **Se `APP_BASE_DIR` não estivesse definido, usava `__DIR__` como fallback**
- **Não lançava exceção**

---

### **16/11/2025 - Remoção do Fallback**
- `config.php` atualizado (conforme `PROJETO_ELIMINAR_URLS_HARDCODED.md`)
- **FALLBACK REMOVIDO**:
  ```php
  function getBaseDir() {
      $baseDir = $_ENV['APP_BASE_DIR'] ?? '';
      if (empty($baseDir)) {
          error_log('[CONFIG] ERRO CRÍTICO: APP_BASE_DIR não está definido');
          throw new RuntimeException('APP_BASE_DIR não está definido');  // ❌ LANÇA EXCEÇÃO
      }
      return rtrim($baseDir, '/\\');
  }
  ```
- **Agora lança exceção se `APP_BASE_DIR` não estiver definido**

---

### **17/11/2025 - Sistema de Logging Unificado**
- Sistema de logging unificado implementado
- Endpoint passou a usar `ProfessionalLogger`
- **Mas o problema já existia desde 16/11** (remoção do fallback)

---

## ✅ RESPOSTA À PERGUNTA

### **A variável `APP_BASE_DIR` já existia antes?**

**Resposta:** ⚠️ **DEPENDE DO CONTEXTO**

1. **A variável pode ter existido no servidor:**
   - Documentação mostra que `APP_BASE_DIR` deveria estar configurada no PHP-FPM
   - Mas pode não ter sido configurada corretamente

2. **O código não dependia dela antes:**
   - **Antes de 16/11:** `config.php` tinha fallback `__DIR__`
   - **Se `APP_BASE_DIR` não estivesse definido, o código funcionava mesmo assim**
   - **Não lançava exceção**

3. **O código passou a depender dela depois:**
   - **Depois de 16/11:** Fallback removido
   - **Se `APP_BASE_DIR` não estiver definido, lança exceção**
   - **Endpoint retorna HTTP 500**

---

## 🎯 CONCLUSÃO

### **O Problema Não É Novo:**

1. ✅ **A variável `APP_BASE_DIR` pode ter existido antes** (ou não)
2. ✅ **Mas o código não dependia dela** porque tinha fallback
3. ✅ **Quando o fallback foi removido (16/11), o código passou a depender da variável**
4. ✅ **Se a variável não estiver configurada no PHP-FPM, o endpoint falha**

### **Por Que Funcionava Antes:**

- **Antes de 16/11:** `config.php` usava `__DIR__` como fallback
- **Endpoint funcionava mesmo sem `APP_BASE_DIR` definido**
- **Não havia erro porque não lançava exceção**

### **Por Que Não Funciona Agora:**

- **Depois de 16/11:** Fallback removido
- **Se `APP_BASE_DIR` não estiver definido, lança exceção**
- **Endpoint retorna HTTP 500**

---

## 📋 AÇÃO NECESSÁRIA

**Configurar `APP_BASE_DIR` e `APP_BASE_URL` nas variáveis de ambiente do PHP-FPM:**

```ini
[Service]
Environment="APP_BASE_DIR=/var/www/html/dev/root"
Environment="APP_BASE_URL=https://dev.bssegurosimediato.com.br"
```

**Depois:** Reiniciar PHP-FPM: `systemctl restart php8.3-fpm`

---

**Documento criado em:** 18/11/2025  
**Status:** ✅ **ANÁLISE COMPLETA**


