# 🔍 Análise: Erros na Chamada do add_webflow_octa.php em Desenvolvimento

**Data:** 23/11/2025  
**Arquivo:** `add_webflow_octa.php`  
**Problema:** Erros de assinatura inválida (`invalid_signature`)  
**Status:** ⚠️ **ERROS IDENTIFICADOS**

---

## 📋 ANÁLISE DOS LOGS

### Logs Verificados

**Arquivo de Log:** `/var/www/html/dev/root/logs/webhook_octadesk_prod.txt`

### Erros Encontrados

#### **Erro 1: 23/11/2025 13:21:07**
```
[ERROR] [OCTADESK-PROD] invalid_signature | Data: {
  "signature_received": "a910eb0cad817a36...",
  "timestamp_received": "1763904066860",
  "expected_length": 64,
  "ip": "172.71.190.104",
  "reason": "signature_invalid"
}
```

#### **Erro 2: 23/11/2025 13:31:07**
```
[ERROR] [OCTADESK-PROD] invalid_signature | Data: {
  "signature_received": "76d52044c82df3b0...",
  "timestamp_received": "1763904667367",
  "expected_length": 64,
  "ip": "162.158.152.170",
  "reason": "signature_invalid"
}
```

#### **Erro 3: 23/11/2025 13:41:08**
```
[ERROR] [OCTADESK-PROD] invalid_signature | Data: {
  "signature_received": "4bec6700968a8112...",
  "timestamp_received": "1763905267898",
  "expected_length": 64,
  "ip": "172.71.190.105",
  "reason": "signature_invalid"
}
```

#### **Erro 4: 23/11/2025 13:50:40**
```
[ERROR] [OCTADESK-PROD] invalid_signature | Data: {
  "signature_received": "5ac8506a12c64c4c...",
  "timestamp_received": "1763905839772",
  "expected_length": 64,
  "ip": "172.70.174.176",
  "reason": "signature_invalid"
}
```

---

## 🔍 ANÁLISE DETALHADA

### Características dos Erros

1. **Tipo de Erro:** `invalid_signature` (assinatura inválida)
2. **Frequência:** 4 erros em aproximadamente 30 minutos (13:21, 13:31, 13:41, 13:50)
3. **Origem:** Requisições vindas do Webflow (IPs dos EUA: 35.170.124.222, 184.73.26.63, 34.234.5.255)
4. **Headers Presentes:**
   - `X-Webflow-Signature`: Presente
   - `X-Webflow-Timestamp`: Presente
   - `Content-Type`: `application/json`
   - `User-Agent`: `node-fetch/1.0` (Webflow)

### Requisições Bem-Sucedidas

Antes desses erros, havia requisições bem-sucedidas:
- **21/11/2025 23:15:40** - ✅ Sucesso (HTTP 201)
- **21/11/2025 23:30:51** - ✅ Sucesso (HTTP 201)
- **22/11/2025 20:16:53** - ✅ Sucesso (HTTP 201)

**Diferença:** As requisições bem-sucedidas vinham do navegador (`Origin: https://segurosimediato-dev.webflow.io`), enquanto as com erro vêm diretamente do Webflow (`User-Agent: node-fetch/1.0`).

---

## 🎯 CAUSA RAIZ IDENTIFICADA

### Problema Principal: Validação de Assinatura do Webflow ⚠️ **CRÍTICO**

O erro `invalid_signature` indica que:

1. **Webflow está enviando assinatura:** Headers `X-Webflow-Signature` e `X-Webflow-Timestamp` estão presentes
2. **Assinatura está sendo rejeitada:** A validação da assinatura está falhando
3. **Possíveis causas:**
   - Secret do Webflow incorreto ou diferente entre DEV e PROD
   - Algoritmo de validação de assinatura incorreto
   - Timestamp fora da janela de validade
   - Payload sendo modificado antes da validação

### Requisições do Navegador vs Webflow

**Requisições do Navegador (Bem-sucedidas):**
- `Origin: https://segurosimediato-dev.webflow.io`
- `User-Agent: Mozilla/5.0...`
- Validação de assinatura: **SKIPPED** (`signature_not_provided`)
- Status: ✅ **SUCESSO**

**Requisições do Webflow (Com erro):**
- `User-Agent: node-fetch/1.0`
- `X-Webflow-Signature`: Presente
- `X-Webflow-Timestamp`: Presente
- Validação de assinatura: **FALHOU** (`signature_invalid`)
- Status: ❌ **ERRO**

---

## 📊 RESUMO DA ANÁLISE

### Status dos Logs

| Tipo | Quantidade | Status |
|------|------------|--------|
| **Requisições bem-sucedidas** | 3+ | ✅ Funcionando |
| **Erros de assinatura inválida** | 4 | ❌ Falhando |
| **Erros de sintaxe PHP** | 0 | ✅ Nenhum |
| **Erros de conexão** | 0 | ✅ Nenhum |

### Padrão Identificado

- ✅ **Requisições do navegador:** Funcionam corretamente (validação de assinatura é pulada)
- ❌ **Requisições do Webflow:** Falham na validação de assinatura

### Impacto

- **Impacto:** Requisições automáticas do Webflow estão sendo rejeitadas
- **Requisições manuais do navegador:** Funcionam normalmente
- **Frequência:** Erros ocorrem aproximadamente a cada 10 minutos (possivelmente tentativas automáticas do Webflow)

---

## ✅ CONCLUSÃO

### Problema Identificado

O arquivo `add_webflow_octa.php` está funcionando corretamente para requisições do navegador, mas está rejeitando requisições automáticas do Webflow devido a erros de validação de assinatura.

### Próximos Passos (Não Implementados - Apenas Análise)

1. Verificar se o `WEBFLOW_SECRET` está correto em desenvolvimento
2. Verificar se o algoritmo de validação de assinatura está correto
3. Verificar se há diferença entre o secret de DEV e PROD
4. Verificar se o timestamp está dentro da janela de validade

---

**Análise realizada em:** 23/11/2025  
**Status:** ⚠️ Erros identificados - aguardando investigação adicional

