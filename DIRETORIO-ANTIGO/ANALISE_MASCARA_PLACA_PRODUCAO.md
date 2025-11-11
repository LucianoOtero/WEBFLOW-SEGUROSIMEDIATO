# Análise: Máscara de Placa em Produção

**Data:** 2025-10-30  
**Objetivo:** Registrar código exato da máscara de placa que funciona em produção

---

## 📋 Código Exato em Produção

### Função `aplicarMascaraPlaca` (Produção)

```javascript
function aplicarMascaraPlaca($i){
  const t={'S':{pattern:/[A-Za-z]/},'0':{pattern:/\d/},'A':{pattern:/[A-Za-z0-9]/}};
  $i.on('input',function(){this.value=this.value.toUpperCase();});
  $i.mask('SSS-0A00',{translation:t, clearIfNotMatch:false});
}
```

**Localização no código:** Dentro do bloco `/* ========= MÁSCARAS ========= */`

---

## 🔍 Características da Implementação em Produção

1. **Tradução (translation):**
   - `'S'`: `{pattern:/[A-Za-z]/}` - Aceita letras maiúsculas e minúsculas
   - `'0'`: `{pattern:/\d/}` - Aceita apenas dígitos
   - `'A'`: `{pattern:/[A-Za-z0-9]/}` - Aceita letras ou números
   - **NÃO** usa `recursive: true` no pattern 'S'

2. **Evento para uppercase:**
   - Usa evento `input` separado: `$i.on('input',function(){this.value=this.value.toUpperCase();});`
   - Aplicado ANTES da máscara

3. **Aplicação da máscara:**
   - `$i.mask('SSS-0A00',{translation:t, clearIfNotMatch:false});`
   - **NÃO** usa callback `onKeyPress`
   - **NÃO** usa `recursive: true`

---

## 🔄 Comparação: Produção vs. Desenvolvimento (Atual)

### Produção (Funciona):
```javascript
function aplicarMascaraPlaca($i){
  const t={'S':{pattern:/[A-Za-z]/},'0':{pattern:/\d/},'A':{pattern:/[A-Za-z0-9]/}};
  $i.on('input',function(){this.value=this.value.toUpperCase();});
  $i.mask('SSS-0A00',{translation:t, clearIfNotMatch:false});
}
```

### Desenvolvimento (Modificado):
```javascript
function aplicarMascaraPlaca($i) {
  const t = {'S': {pattern: /[A-Za-z]/, recursive: true}, '0': {pattern: /\d/}, 'A': {pattern: /[A-Za-z0-9]/}};
  $i.mask('SSS-0A00', {
    translation: t, 
    clearIfNotMatch: false,
    onKeyPress: function(value, e, field, options) {
      field.val(value.toUpperCase());
    }
  });
}
```

---

## ⚠️ Diferenças Identificadas

| Característica | Produção | Desenvolvimento (Atual) |
|----------------|----------|-------------------------|
| **Evento uppercase** | `input` separado | `onKeyPress` callback |
| **recursive: true** | ❌ Não usa | ✅ Usa no pattern 'S' |
| **Ordem de aplicação** | Evento ANTES da máscara | Callback DENTRO da máscara |

---

## 💡 Observações

1. **Em produção funciona:** A implementação usa evento `input` separado antes de aplicar a máscara
2. **Recursive:** Produção NÃO usa `recursive: true`, desenvolvimento foi modificado para usar
3. **onKeyPress vs input:** Produção usa `input`, desenvolvimento foi modificado para `onKeyPress`

---

## 🤔 Questão

Se em produção funciona com:
- Evento `input` separado
- Sem `recursive: true`
- Sem `onKeyPress` callback

Por que no desenvolvimento não funcionava? Possíveis causas:
1. Conflito com outros event handlers
2. Ordem de carregamento dos scripts
3. Versão diferente do jQuery Mask
4. Conflito com outros códigos JavaScript

---

## 📝 Recomendação

**Opção 1:** Reverter para código exato de produção
```javascript
function aplicarMascaraPlaca($i){
  const t={'S':{pattern:/[A-Za-z]/},'0':{pattern:/\d/},'A':{pattern:/[A-Za-z0-9]/}};
  $i.on('input',function(){this.value=this.value.toUpperCase();});
  $i.mask('SSS-0A00',{translation:t, clearIfNotMatch:false});
}
```

**Opção 2:** Manter código atual (com `onKeyPress` e `recursive: true`) se estiver funcionando no desenvolvimento após correção








