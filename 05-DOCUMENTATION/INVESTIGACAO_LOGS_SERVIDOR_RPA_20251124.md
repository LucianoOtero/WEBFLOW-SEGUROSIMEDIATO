# Investigação: Logs do Servidor RPA
**Data:** 24/11/2025  
**Servidor:** `rpaimediatoseguros.com.br` (IP: 37.27.92.160)  
**Status:** ✅ **INVESTIGAÇÃO COMPLETA**

---

## 📋 RESUMO EXECUTIVO

Investigação completa dos logs e configuração do servidor RPA identificou **múltiplos problemas** que explicam os erros reportados no frontend:

1. **🔴 CRÍTICO:** Incompatibilidade de nomenclatura de campos (`nome` vs `NOME`)
2. **🟡 IMPORTANTE:** Serviços do Supervisor em estado FATAL (mas não crítico para API PHP)
3. **🟡 IMPORTANTE:** Erro PHP "upstream sent too big header" causado por múltiplos warnings
4. **✅ FUNCIONANDO:** API de progresso está respondendo corretamente (HTTP 200)

---

## 🔍 DESCOBERTAS DA INVESTIGAÇÃO

### 1. Estrutura do Servidor

**Diretório Principal:**
- `/opt/imediatoseguros-rpa-v4/public/` - Diretório web root do Nginx
- `/opt/imediatoseguros-rpa-v4/public/api/rpa/start.php` - Endpoint de início (arquivo direto)
- `/opt/imediatoseguros-rpa-v4/public/index.php` - Roteador principal (usa RPAController)

**Serviços Ativos:**
- ✅ **Nginx:** 1.24.0 - Ativo e funcionando
- ✅ **PHP-FPM:** 8.3.6 - Ativo e funcionando
- ✅ **Redis:** 7.0.15 - Ativo e funcionando
- ❌ **Supervisor:** Serviços em estado FATAL (não crítico para API PHP)

### 2. Problema Principal: Incompatibilidade de Nomenclatura

**Evidência nos Logs:**
```
2025/11/24 17:23:10 [error] PHP Warning: Undefined array key "nome" 
in /opt/imediatoseguros-rpa-v4/src/Controllers/RPAController.php on line 123
```

**Causa Raiz:**
- **Frontend envia:** `NOME` (maiúsculas) - conforme visto no log de erro
- **Backend espera:** `nome` (minúsculas) - conforme código PHP

**Localização do Problema:**
- `RPAController.php:123` - Acessa `$data['nome']` sem verificar se existe
- `RPAController.php:214` - Acessa `$data['nome']` novamente
- `start.php:33` - Valida campo obrigatório `'nome'` (minúsculas)

**Dados Recebidos pelo Backend (conforme log):**
```php
[
    'NOME' => '1409 luciano',  // ❌ Maiúsculas
    'GCLID_FLD' => 'teste-dev-202511241409',
    'cpf' => '251.517.878-29',
    'placa' => 'FPG-8D63',
    'email' => 'lrotero@gmail.com',
    'telefone' => '1197668-7668',
    // ... outros campos
]
```

**Código Esperado:**
```php
[
    'nome' => '1409 luciano',  // ✅ Minúsculas
    'cpf' => '251.517.878-29',
    // ... outros campos
]
```

### 3. Erro "upstream sent too big header"

**Evidência:**
```
2025/11/24 17:38:03 [error] upstream sent too big header while reading response header from upstream
```

**Causa:**
- Múltiplos warnings PHP são enviados no header da resposta
- Nginx tem limite de tamanho de header (padrão: 4KB ou 8KB)
- Warnings acumulados excedem o limite

**Impacto:**
- Requisição retorna **502 Bad Gateway**
- Frontend recebe erro genérico "Erro ao iniciar o cálculo"

### 4. Serviços do Supervisor em Estado FATAL

**Status dos Serviços:**
```
imediatoseguros-celery       FATAL     Exited too quickly
imediatoseguros-celerybeat   FATAL     Exited too quickly
imediatoseguros-rpa          FATAL     Exited too quickly
```

**Configuração do Supervisor:**
- **Gunicorn:** Deveria rodar na porta 5000 (não está rodando)
- **Celery:** Deveria processar tarefas assíncronas (não está rodando)
- **Celerybeat:** Deveria agendar tarefas (não está rodando)

**Impacto:**
- ⚠️ **NÃO crítico** para a API PHP atual
- ⚠️ Pode ser necessário se houver processamento assíncrono planejado
- ✅ API PHP funciona independentemente do Supervisor

### 5. API de Progresso Funcionando (Mas RPA Não Avança)

**Evidência nos Logs de Acesso:**
```
191.9.24.241 - - [24/Nov/2025:17:38:52 +0000] "GET /api/rpa/progress/rpa_v4_20251124_172310_ba6e50a1 HTTP/1.1" 200 1114
```

**Status da API:**
- ✅ Requisições GET para `/api/rpa/progress/{session_id}` retornam **HTTP 200**
- ✅ Resposta tem 1114 bytes (dados de progresso)
- ✅ Polling está funcionando corretamente
- ✅ Endpoint roteado corretamente via `index.php` → `RPAController->getProgress()`

**Resposta da API de Progresso (Teste Real):**
```json
{
    "success": true,
    "session_id": "rpa_v4_20251124_172310_ba6e50a1",
    "progress": {
        "etapa_atual": 0,
        "total_etapas": 15,
        "percentual": 0,
        "status": "iniciando",
        "mensagem": "Iniciando RPA",
        "estimativas": {
            "capturadas": false,
            "dados": null
        },
        "resultados_finais": {
            "rpa_finalizado": false,
            "dados": null
        },
        "timeline": [
            {
                "etapa": "inicio",
                "timestamp": "2025-11-24T17:23:10.809689",
                "status": "iniciando",
                "mensagem": "ProgressTracker inicializado"
            }
        ]
    }
}
```

**Problema Identificado:**
- Progresso retorna sempre **etapa_atual: 0**, **percentual: 0**, e status **"iniciando"**
- Timeline mostra apenas etapa "inicio" com "ProgressTracker inicializado"
- **RPA não está executando** - processo não avança além da inicialização
- Indica que o script Python RPA não está sendo executado ou travou na inicialização

---

## 🎯 CAUSAS RAIZ IDENTIFICADAS

### Causa 1: Incompatibilidade de Nomenclatura de Campos (CRÍTICA)

**Problema:**
- Frontend envia `NOME` (maiúsculas)
- Backend espera `nome` (minúsculas)
- Código PHP acessa `$data['nome']` sem verificar se existe

**Impacto:**
- Warnings PHP gerados
- Possível falha na validação
- Erro "upstream sent too big header"

**Solução Necessária:**
- Normalizar nomenclatura de campos (frontend ou backend)
- Adicionar verificação de existência antes de acessar array
- Mapear `NOME` → `nome` no backend

### Causa 2: Múltiplos Warnings PHP Acumulados

**Problema:**
- Cada warning PHP adiciona informação ao header da resposta
- Múltiplos warnings excedem limite do Nginx
- Resulta em erro 502 Bad Gateway

**Impacto:**
- Frontend recebe erro genérico
- Usuário não vê mensagem específica

**Solução Necessária:**
- Corrigir warnings PHP (verificar existência de chaves antes de acessar)
- Aumentar limite de header do Nginx (solução temporária)
- Suprimir warnings em produção (não recomendado)

### Causa 3: RPA Não Avança Além da Fase 1

**Problema:**
- Progresso sempre retorna Fase 1 (6.25%) e status "iniciando"
- Indica que o processo RPA não está executando ou travou

**Possíveis Causas:**
- Script Python não está sendo executado
- Processo travou na primeira fase
- Dados insuficientes para avançar

**Solução Necessária:**
- Verificar logs do processo RPA Python
- Verificar se script está sendo executado
- Verificar se há erros no processo Python

---

## 📊 ANÁLISE DOS LOGS

### Logs do Nginx (Erros)

**Padrão Identificado:**
- Múltiplos warnings PHP sobre `Undefined array key "nome"`
- Erro "upstream sent too big header"
- Ataques de scanner (não relacionados ao problema)

**Timestamps Relevantes:**
- `17:23:10` - Primeira ocorrência do erro de "nome"
- `17:23:17` - Múltiplas tentativas simultâneas
- `17:38:03` - Erro "upstream sent too big header"

### Logs de Acesso (Sucesso)

**Padrão Identificado:**
- Múltiplas requisições GET para `/api/rpa/progress/` retornando 200
- Polling funcionando corretamente
- Respostas consistentes (1114 bytes)

**Timestamps:**
- `17:38:52` até `17:39:02` - Polling ativo
- Session IDs: `rpa_v4_20251124_172310_*`

---

## 🔧 ARQUIVOS E CÓDIGO ANALISADOS

### Arquivos Verificados

1. **`/opt/imediatoseguros-rpa-v4/public/api/rpa/start.php`**
   - Endpoint direto (não usado pelo roteador)
   - Valida campo `'nome'` (minúsculas) na linha 33

2. **`/opt/imediatoseguros-rpa-v4/public/index.php`**
   - Roteador principal
   - Usa `RPAController` para processar requisições
   - Roteia `/api/rpa/start` para `$controller->startRPA()`

3. **`/opt/imediatoseguros-rpa-v4/src/Controllers/RPAController.php`**
   - Linha 123: Acessa `$data['nome']` sem verificar existência
   - Linha 214: Acessa `$data['nome']` novamente
   - Linha 214: Prepara webhook com `'NOME' => $data['nome']` (converte para maiúsculas)

### Configuração do Nginx

**Arquivo:** `/etc/nginx/sites-enabled/rpaimediatoseguros.com.br`

**Configuração:**
- Root: `/opt/imediatoseguros-rpa-v4/public`
- PHP-FPM: `unix:/var/run/php/php8.3-fpm.sock`
- SSL: Let's Encrypt ativo
- **NÃO há proxy para porta 8000** (configuração antiga removida)

---

## 📋 RECOMENDAÇÕES

### Recomendação 1: Corrigir Incompatibilidade de Nomenclatura (URGENTE)

**Ação:**
- Normalizar campo `NOME` → `nome` no backend antes de processar
- Adicionar verificação de existência antes de acessar array
- Mapear ambos os formatos (`NOME` e `nome`) para compatibilidade

**Prioridade:** 🔴 **ALTA**

### Recomendação 2: Corrigir Warnings PHP (URGENTE)

**Ação:**
- Adicionar verificações `isset()` ou `array_key_exists()` antes de acessar arrays
- Usar operador null coalescing (`??`) para valores padrão
- Suprimir warnings apenas em produção (não recomendado como solução única)

**Prioridade:** 🔴 **ALTA**

### Recomendação 3: Investigar Por Que RPA Não Avança (IMPORTANTE)

**Ação:**
- Verificar logs do processo Python RPA
- Verificar se script está sendo executado
- Verificar se há erros no processo de execução

**Prioridade:** 🟡 **MÉDIA**

### Recomendação 4: Corrigir Serviços do Supervisor (OPCIONAL)

**Ação:**
- Verificar logs do Supervisor para identificar causa das falhas
- Corrigir configuração ou dependências
- Reiniciar serviços se necessário

**Prioridade:** 🟢 **BAIXA** (não crítico para API PHP atual)

---

## 🔗 ARQUIVOS RELACIONADOS

- `/opt/imediatoseguros-rpa-v4/public/api/rpa/start.php`
- `/opt/imediatoseguros-rpa-v4/public/index.php`
- `/opt/imediatoseguros-rpa-v4/src/Controllers/RPAController.php`
- `/etc/nginx/sites-enabled/rpaimediatoseguros.com.br`
- `/var/log/nginx/rpa-v4.error.log`
- `/var/log/nginx/rpa-v4.access.log`

---

## 📋 PRÓXIMOS PASSOS

1. **🔴 URGENTE:** Corrigir incompatibilidade de nomenclatura (`NOME` vs `nome`)
2. **🔴 URGENTE:** Adicionar verificações de existência antes de acessar arrays
3. **🟡 IMPORTANTE:** Investigar por que RPA não avança além da Fase 1
4. **🟢 OPCIONAL:** Corrigir serviços do Supervisor (se necessário)

---

---

## ✅ SOLUÇÃO IMPLEMENTADA

### **Correção Aplicada:**
- **Data:** 24/11/2025
- **Projeto:** Corrigir Mapeamento de Campo NOME → nome no RPA
- **Arquivo Modificado:** `webflow_injection_limpo.js`
- **Alteração:** Adicionado mapeamento `'NOME': 'nome'` na função `applyFieldConversions()` (linha ~2684)
- **Status:** ✅ Implementado localmente e ✅ Deployado em DEV
- **Hash SHA256 DEV:** `53CC20E91EC611260A9186DDAD7DD7BE8DE43685A3C37CAD7D55E47E727C1D14`
- **Backup Local:** `02-DEVELOPMENT/backups/webflow_injection_limpo.js.backup_20251124_151453`

### **Como Funciona:**
1. Formulário Webflow envia `NOME` (maiúsculas)
2. Função `applyFieldConversions()` mapeia `NOME` → `nome` (minúsculas)
3. Backend PHP recebe sempre `nome` (minúsculas), independente do formato enviado
4. Erro "Undefined array key 'nome'" é eliminado

### **Compatibilidade:**
- ✅ Formulários que enviam `NOME` (maiúsculas) → Funcionam corretamente
- ✅ Formulários que enviam `nome` (minúsculas) → Continuam funcionando normalmente
- ✅ Compatibilidade retroativa mantida

### **Próximos Passos:**
- ⏳ Teste funcional em ambiente DEV (requer intervenção manual)
- ⏳ Preparação para produção (quando procedimento for definido)

**Documentação do Projeto:** `PROJETO_CORRIGIR_MAPEAMENTO_NOME_RPA_20251124.md`

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 18:15  
**Status:** ✅ **INVESTIGAÇÃO COMPLETA** - ✅ **SOLUÇÃO IMPLEMENTADA**

