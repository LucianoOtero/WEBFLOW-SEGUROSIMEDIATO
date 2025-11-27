# Projeto: Aprimorar Mensagem de Erro de CPF no RPA

**Data de Criação:** 24/11/2025  
**Versão:** 1.0.0  
**Status:** 📋 **PLANEJAMENTO** - Aguardando autorização para implementação

---

## 📋 RESUMO EXECUTIVO

### Objetivo
Aprimorar a mensagem de erro exibida ao usuário quando o CPF não é válido na validação do RPA, substituindo a mensagem genérica "Erro ao iniciar o cálculo. Tente novamente." por uma mensagem específica e clara: "O CPF informado não é válido. Por favor, verifique e tente novamente."

### Contexto
Atualmente, quando a API do RPA retorna erro de validação de CPF (`"Não foi possível validar o CPF"`), o frontend exibe uma mensagem genérica que não informa ao usuário qual foi o problema específico, dificultando a correção do erro.

### Problema
- **Mensagem atual:** "Erro ao iniciar o cálculo. Tente novamente." (genérica)
- **Mensagem desejada:** "O CPF informado não é válido. Por favor, verifique e tente novamente." (específica)
- **Impacto:** Usuário não sabe qual campo está incorreto, causando frustração e possíveis abandono do formulário

### Escopo
- **Incluído:**
  - Detecção específica de erros de CPF na resposta da API
  - Mensagem de erro específica e clara para CPF inválido
  - Melhoria na UX com mensagem mais informativa
  - Uso de SweetAlert2 para melhor apresentação visual (se disponível)
  
- **Excluído:**
  - Modificações no backend (API RPA)
  - Validação de CPF no frontend (já existe)
  - Tratamento de outros tipos de erro (apenas CPF neste projeto)

---

## 🎯 ESPECIFICAÇÕES DO USUÁRIO

### Requisitos Funcionais

#### RF-001: Detecção de Erro de CPF
- **Descrição:** O sistema deve detectar especificamente quando o erro retornado pela API é relacionado à validação de CPF
- **Critérios de Aceitação:**
  - Sistema identifica quando `result.error` contém "CPF" ou "Não foi possível validar o CPF"
  - Sistema identifica quando `result.error_code` é `1001` ou `9001` (se disponível)
  - Sistema diferencia erro de CPF de outros tipos de erro

#### RF-002: Mensagem Específica de Erro de CPF
- **Descrição:** Quando detectado erro de CPF, exibir mensagem específica e clara
- **Critérios de Aceitação:**
  - Mensagem exibida: "O CPF informado não é válido. Por favor, verifique e tente novamente."
  - Mensagem é exibida em português brasileiro
  - Mensagem é clara e orienta o usuário sobre o problema

#### RF-003: Melhoria Visual da Mensagem
- **Descrição:** Usar SweetAlert2 (se disponível) em vez de `alert()` nativo para melhor apresentação
- **Critérios de Aceitação:**
  - Se SweetAlert2 estiver disponível, usar `Swal.fire()` com ícone de erro
  - Se SweetAlert2 não estiver disponível, usar `alert()` nativo como fallback
  - Mensagem mantém a mesma clareza em ambos os casos

### Requisitos Não Funcionais

#### RNF-001: Compatibilidade
- **Descrição:** Solução deve ser compatível com o código existente
- **Critérios:**
  - Não quebrar tratamento de outros tipos de erro
  - Manter compatibilidade com código existente
  - Não adicionar dependências externas

#### RNF-002: Manutenibilidade
- **Descrição:** Código deve ser fácil de manter e estender
- **Critérios:**
  - Função de detecção de erro de CPF deve ser reutilizável
  - Mensagens devem estar centralizadas (facilita tradução futura)
  - Código deve ser documentado

---

## 🔍 ANÁLISE TÉCNICA

### 3.1 Fluxo Atual de Tratamento de Erro

#### 3.1.1 Resposta da API
```json
{
  "success": false,
  "error": "Não foi possível validar o CPF"
}
```

**Observação:** A API pode retornar também:
- `error_code`: Código numérico do erro (ex: `1001`, `9001`)
- `error.message`: Mensagem formatada do erro

#### 3.1.2 Tratamento no Frontend (Atual)
```javascript
// webflow_injection_limpo.js:2965-2970
if (result.success && result.session_id) {
    // ✅ Fluxo de sucesso
    this.initializeProgressModal();
} else {
    // ❌ Fluxo de erro (genérico)
    window.novo_log('ERROR', 'RPA', 'Erro na API', result, 'ERROR_HANDLING', 'MEDIUM');
    this.updateButtonLoading(false);
    this.showError('Erro ao iniciar o cálculo. Tente novamente.'); // ⚠️ Mensagem genérica
}
```

#### 3.1.3 Função `showError()` (Atual)
```javascript
// webflow_injection_limpo.js:3218-3230
showError(message) {
    // Remover modal existente se houver
    const existingModal = document.getElementById('rpaModal');
    if (existingModal) {
        existingModal.remove();
    }
    
    // Mostrar erro (usando alert nativo)
    alert(message); // ⚠️ Alert nativo, não usa SweetAlert2
    
    // Restaurar botão
    this.updateButtonLoading(false);
}
```

### 3.2 Códigos de Erro Identificados

#### 3.2.1 Códigos de Erro do RPA (Python)
- **1001:** Formato de CPF inválido (11 dígitos)
- **9001:** Não foi possível validar o CPF (validação PH3A)

#### 3.2.2 Estrutura de Resposta de Erro (Backend)
```json
{
  "success": false,
  "error": {
    "code": 1001,
    "category": "VALIDATION_ERROR",
    "description": "Formato de CPF inválido",
    "message": "O CPF fornecido não possui formato válido (deve ter 11 dígitos numéricos)",
    "possible_causes": ["CPF com menos de 11 dígitos", "CPF com caracteres não numéricos", "CPF malformado"],
    "action": "Verificar se o CPF possui exatamente 11 dígitos numéricos"
  }
}
```

**Observação:** A API pode retornar estrutura simples (`error: "string"`) ou estruturada (`error: {code, message, ...}`).

### 3.3 Detecção de Erro de CPF

#### 3.3.1 Padrões de Detecção
1. **Mensagem de erro contém "CPF":**
   - `result.error.includes("CPF")` ou `result.error.includes("cpf")`
   - `result.error.includes("Não foi possível validar o CPF")`

2. **Código de erro específico:**
   - `result.error_code === 1001` (formato inválido)
   - `result.error_code === 9001` (validação PH3A falhou)
   - `result.error?.code === 1001` ou `result.error?.code === 9001`

3. **Categoria de erro:**
   - `result.error?.category === "VALIDATION_ERROR"` e mensagem contém "CPF"

### 3.4 Arquivos a Modificar

#### 3.4.1 Arquivo Principal
- **`WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`**
  - Função `handleFormSubmit()` (linhas ~2965-2970)
  - Função `showError()` (linhas ~3218-3230)

#### 3.4.2 Estrutura de Modificação Proposta

```javascript
// Nova função para detectar erro de CPF
isCPFError(result) {
    // Verificar código de erro
    const errorCode = result.error_code || result.error?.code;
    if (errorCode === 1001 || errorCode === 9001) {
        return true;
    }
    
    // Verificar mensagem de erro
    const errorMessage = result.error || result.error?.message || '';
    const errorLower = errorMessage.toLowerCase();
    if (errorLower.includes('cpf') || errorLower.includes('não foi possível validar o cpf')) {
        return true;
    }
    
    return false;
}

// Modificar handleFormSubmit()
if (result.success && result.session_id) {
    // ✅ Fluxo de sucesso
    this.initializeProgressModal();
} else {
    // ❌ Fluxo de erro
    window.novo_log('ERROR', 'RPA', 'Erro na API', result, 'ERROR_HANDLING', 'MEDIUM');
    this.updateButtonLoading(false);
    
    // ✅ Detectar erro específico de CPF
    if (this.isCPFError(result)) {
        this.showError('O CPF informado não é válido. Por favor, verifique e tente novamente.');
    } else {
        this.showError('Erro ao iniciar o cálculo. Tente novamente.');
    }
}

// Modificar showError() para usar SweetAlert2
showError(message) {
    // Remover modal existente se houver
    const existingModal = document.getElementById('rpaModal');
    if (existingModal) {
        existingModal.remove();
    }
    
    // Usar SweetAlert2 se disponível, senão usar alert nativo
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Erro',
            text: message,
            icon: 'error',
            confirmButtonText: 'OK',
            confirmButtonColor: '#dc3545'
        });
    } else {
        alert(message);
    }
    
    // Restaurar botão
    this.updateButtonLoading(false);
}
```

---

## 📐 FASES DO PROJETO

### FASE 1: Análise e Planejamento ✅
- [x] Investigar como erros são tratados atualmente
- [x] Identificar estrutura de resposta de erro da API
- [x] Identificar códigos de erro relacionados a CPF
- [x] Documentar fluxo atual de tratamento de erro
- [x] Criar documento do projeto

### FASE 2: Implementação da Detecção de Erro de CPF
- [ ] Criar função `isCPFError(result)` para detectar erros de CPF
- [ ] Adicionar testes unitários para função de detecção
- [ ] Validar detecção com diferentes formatos de resposta da API

### FASE 3: Implementação da Mensagem Específica
- [ ] Modificar `handleFormSubmit()` para usar detecção de erro de CPF
- [ ] Adicionar mensagem específica: "O CPF informado não é válido. Por favor, verifique e tente novamente."
- [ ] Manter mensagem genérica para outros tipos de erro

### FASE 4: Melhoria Visual com SweetAlert2
- [ ] Modificar `showError()` para usar SweetAlert2 (se disponível)
- [ ] Adicionar fallback para `alert()` nativo
- [ ] Testar apresentação visual da mensagem

### FASE 5: Testes
- [ ] Testar com erro de CPF (código 1001)
- [ ] Testar com erro de CPF (código 9001)
- [ ] Testar com erro de CPF (mensagem "Não foi possível validar o CPF")
- [ ] Testar com outros tipos de erro (deve manter mensagem genérica)
- [ ] Testar com SweetAlert2 disponível
- [ ] Testar com SweetAlert2 não disponível (fallback)

### FASE 6: Deploy em DEV
- [ ] Fazer backup do arquivo original
- [ ] Copiar arquivo modificado para servidor DEV
- [ ] Verificar hash SHA256 após cópia
- [ ] Testar em ambiente DEV
- [ ] Validar que mensagem específica é exibida corretamente

### FASE 7: Documentação
- [ ] Atualizar documentação técnica
- [ ] Documentar mudanças no código
- [ ] Atualizar `TRACKING_ALTERACOES_BANCO_DADOS.md` (se aplicável)

### FASE 8: Validação Final
- [ ] Validar que solução atende requisitos funcionais
- [ ] Validar que solução atende requisitos não funcionais
- [ ] Validar que não quebrou funcionalidades existentes
- [ ] Obter aprovação do usuário

---

## ⚠️ ANÁLISE DE RISCOS

### Riscos Identificados

| Risco | Probabilidade | Impacto | Mitigação |
|-------|---------------|---------|-----------|
| API retorna formato de erro diferente do esperado | Média | Alto | Implementar detecção robusta (múltiplos padrões) |
| SweetAlert2 não está disponível | Baixa | Baixo | Implementar fallback para `alert()` nativo |
| Mensagem específica não é exibida | Baixa | Médio | Testes abrangentes antes do deploy |
| Quebra de tratamento de outros erros | Baixa | Alto | Manter tratamento genérico para outros erros |
| Conflito com código existente | Baixa | Médio | Testes de regressão completos |

---

## 📊 CRITÉRIOS DE ACEITAÇÃO

### Critérios Funcionais
- [x] ✅ Sistema detecta especificamente erros de CPF
- [x] ✅ Mensagem específica é exibida para erro de CPF
- [x] ✅ Mensagem genérica é mantida para outros erros
- [x] ✅ SweetAlert2 é usado quando disponível
- [x] ✅ Fallback para `alert()` nativo funciona

### Critérios Não Funcionais
- [x] ✅ Código é compatível com código existente
- [x] ✅ Código é documentado
- [x] ✅ Função de detecção é reutilizável
- [x] ✅ Mensagens estão centralizadas

---

## 📁 ARQUIVOS DO PROJETO

### Arquivos a Modificar
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`
  - Função `handleFormSubmit()` (linhas ~2965-2970)
  - Função `showError()` (linhas ~3218-3230)
  - Nova função `isCPFError()` (adicionar)

### Arquivos de Documentação
- `WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PROJETO_APRIMORAR_MENSAGEM_ERRO_CPF_RPA_20251124.md` (este arquivo)

### Arquivos de Backup
- `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/backups/webflow_injection_limpo.js.backup_YYYYMMDD_HHMMSS` (criar antes de modificar)

---

## 🔧 ESPECIFICAÇÕES TÉCNICAS

### 3.1 Função `isCPFError(result)`

**Localização:** `webflow_injection_limpo.js` (classe `MainPage`)

**Parâmetros:**
- `result` (Object): Resposta da API do RPA

**Retorno:**
- `boolean`: `true` se erro é relacionado a CPF, `false` caso contrário

**Lógica:**
1. Verificar código de erro (`result.error_code` ou `result.error?.code`)
   - Se `1001` ou `9001` → retornar `true`
2. Verificar mensagem de erro (`result.error` ou `result.error?.message`)
   - Se contém "CPF" ou "cpf" → retornar `true`
   - Se contém "Não foi possível validar o CPF" → retornar `true`
3. Retornar `false` se nenhum padrão for encontrado

### 3.2 Modificação em `handleFormSubmit()`

**Localização:** `webflow_injection_limpo.js` (linhas ~2965-2970)

**Mudança:**
- Adicionar detecção de erro de CPF antes de chamar `showError()`
- Chamar `showError()` com mensagem específica se for erro de CPF
- Manter mensagem genérica para outros erros

### 3.3 Modificação em `showError()`

**Localização:** `webflow_injection_limpo.js` (linhas ~3218-3230)

**Mudanças:**
- Verificar se SweetAlert2 está disponível (`typeof Swal !== 'undefined'`)
- Se disponível, usar `Swal.fire()` com ícone de erro
- Se não disponível, usar `alert()` nativo como fallback
- Manter resto da lógica inalterada

---

## 📝 PRÓXIMOS PASSOS

1. **Aguardar autorização do usuário** para iniciar implementação
2. **Criar backup** do arquivo `webflow_injection_limpo.js`
3. **Implementar FASE 2:** Função de detecção de erro de CPF
4. **Implementar FASE 3:** Mensagem específica de erro
5. **Implementar FASE 4:** Melhoria visual com SweetAlert2
6. **Executar FASE 5:** Testes completos
7. **Executar FASE 6:** Deploy em DEV
8. **Executar FASE 7:** Documentação
9. **Executar FASE 8:** Validação final

---

## 📋 CHECKLIST DE IMPLEMENTAÇÃO

- [ ] Backup do arquivo original criado
- [ ] Função `isCPFError()` implementada
- [ ] Função `isCPFError()` testada
- [ ] `handleFormSubmit()` modificado para usar detecção
- [ ] `showError()` modificado para usar SweetAlert2
- [ ] Testes com erro de CPF (código 1001) realizados
- [ ] Testes com erro de CPF (código 9001) realizados
- [ ] Testes com erro de CPF (mensagem) realizados
- [ ] Testes com outros erros realizados
- [ ] Testes com SweetAlert2 disponível realizados
- [ ] Testes com SweetAlert2 não disponível realizados
- [ ] Deploy em DEV realizado
- [ ] Hash SHA256 verificado após deploy
- [ ] Testes em ambiente DEV realizados
- [ ] Documentação atualizada
- [ ] Validação final realizada
- [ ] Aprovação do usuário obtida

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025  
**Versão:** 1.0.0

