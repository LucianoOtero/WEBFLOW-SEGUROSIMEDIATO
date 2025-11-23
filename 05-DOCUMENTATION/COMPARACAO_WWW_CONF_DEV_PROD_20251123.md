# Comparação: www.conf DEV vs PROD

**Data:** 23/11/2025  
**Arquivo:** `/etc/php/8.3/fpm/pool.d/www.conf`

---

## Resumo Executivo

**Status:** ❌ **ARQUIVOS NÃO SÃO IDÊNTICOS**

Os arquivos têm conteúdo diferente entre DEV e PROD, com diferenças em:
- Formatação de valores (aspas)
- Possíveis diferenças em outras variáveis de ambiente

---

## Hash SHA256

| Ambiente | Hash SHA256 |
|----------|-------------|
| **DEV** | `8C6DF8E953E9983C278E3B7EE99E37DC73FBF571C66B84D4F067FEE4ED7E45A2` |
| **PROD** | `01758462DCF059E6EF22193FA7E8E6F3B9187B7C1371AC093A14767FEA9B8D95` |

**Conclusão:** Arquivos são diferentes (hashes não coincidem)

---

## Variáveis SafetyMails

### DEV (65.108.156.14)

**Linha 591:**
```
env[SAFETY_TICKET] = 05bf2ec47128ca0b917f8b955bada1bd3cadd47e
```

**Linha 592:**
```
env[SAFETY_API_KEY] = 20a7a1c297e39180bd80428ac13c363e882a531f
```

**Observação:** Valores sem aspas

### PROD (157.180.36.223)

**Linha 585:**
```
env[SAFETY_TICKET] = "05bf2ec47128ca0b917f8b955bada1bd3cadd47e"
```

**Linha 590:**
```
env[SAFETY_API_KEY] = "20a7a1c297e39180bd80428ac13c363e882a531f"
```

**Observação:** Valores com aspas duplas

---

## Diferenças Identificadas

### 1. Número de Linhas

- **DEV:** 523 linhas
- **PROD:** 520 linhas

**Conclusão:** Arquivos têm tamanhos diferentes, indicando outras diferenças além das variáveis SafetyMails.

### 2. Formatação de Valores

- **DEV:** Valores sem aspas
- **PROD:** Valores com aspas duplas

**Exemplo:**
- DEV (linha 591): `env[SAFETY_TICKET] = 05bf2ec47128ca0b917f8b955bada1bd3cadd47e`
- PROD (linha 585): `env[SAFETY_TICKET] = "05bf2ec47128ca0b917f8b955bada1bd3cadd47e"`

**Impacto:** Ambas as formatações funcionam no PHP-FPM, mas são diferentes. O projeto deve manter a formatação de PROD (com aspas).

### 2. Valores das Variáveis SafetyMails

| Variável | DEV | PROD | Status |
|----------|-----|------|--------|
| `SAFETY_TICKET` | `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` | `05bf2ec47128ca0b917f8b955bada1bd3cadd47e` | ✅ Mesmo valor |
| `SAFETY_API_KEY` | `20a7a1c297e39180bd80428ac13c363e882a531f` | `20a7a1c297e39180bd80428ac13c363e882a531f` | ✅ Mesmo valor |

**Observação:** Ambos os ambientes estão usando o ticket de DEV (`05bf2ec47128ca0b917f8b955bada1bd3cadd47e`), o que está causando o erro 403 em produção.

---

## Conclusão

### Arquivos não são idênticos

1. **Formatação diferente:** DEV usa valores sem aspas, PROD usa valores com aspas
2. **Valores SafetyMails:** Ambos usam ticket de DEV (incorreto para PROD)
3. **Outras diferenças:** Possíveis diferenças em outras variáveis de ambiente (não verificadas em detalhe)

### Recomendações

1. **Para o projeto atual:** A atualização em PROD deve manter a formatação com aspas (formato atual de PROD)
2. **Valores:** Atualizar `SAFETY_TICKET` em PROD para `9bab7f0c2711c5accfb83588c859dc1103844a94` (ticket correto do Webflow)
3. **Formatação:** Manter aspas duplas em PROD para consistência

---

**Data de Comparação:** 23/11/2025  
**Status:** ✅ **COMPARAÇÃO COMPLETA**

