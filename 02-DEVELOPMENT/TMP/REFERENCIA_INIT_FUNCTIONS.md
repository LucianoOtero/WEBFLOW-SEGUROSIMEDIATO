# Referência: Função init() de MainPage - webflow_injection_limpo.js

Este arquivo contém todas as versões da função `init()` encontradas nos 6 backups do arquivo `webflow_injection_limpo.js`.

---

## ❌ BACKUP 1: ANTES_CLASSIFICACAO_20251111_103646
**Arquivo:** `backups/webflow_injection_limpo.js.backup_ANTES_CLASSIFICACAO_20251111_103646`  
**Status:** ❌ CORROMPIDO (mesmo erro)

```javascript
init() {
    console.log('🚀 MainPage inicializada');
    this.);
    } else {
        this.}

    else {
                    console.error('❌ Formulário não encontrado');
                }
            });
        }
        
        // Fallback: interceptar submit do formulário
        forms.forEach((form, index) => {
            console.log(`📋 Configurando formulário ${index + 1}`);
            
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                console.log('📋 Formulário submetido:', form);
                this.handleFormSubmit(form);
            });
        });
    }
```

---

## ❌ BACKUP 2: 20251111_095231
**Arquivo:** `backups/webflow_injection_limpo.js.backup_20251111_095231`  
**Status:** ❌ CORROMPIDO (mesmo erro)

```javascript
init() {
    console.log('🚀 MainPage inicializada');
    this.);
    } else {
        this.}

    else {
                    console.error('❌ Formulário não encontrado');
                }
            });
        }
        
        // Fallback: interceptar submit do formulário
        forms.forEach((form, index) => {
            console.log(`📋 Configurando formulário ${index + 1}`);
            
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                console.log('📋 Formulário submetido:', form);
                this.handleFormSubmit(form);
            });
        });
    }
```

---

## ❌ BACKUP 3: 20251110_125248 (variáveis_ambiente)
**Arquivo:** `backups/20251110_variaveis_ambiente/webflow_injection_limpo.js.backup_20251110_125248`  
**Status:** ❌ CORROMPIDO (mesmo erro)

```javascript
init() {
    console.log('🚀 MainPage inicializada');
    this.);
    } else {
        this.}

    else {
                    console.error('❌ Formulário não encontrado');
                }
            });
        }
        
        // Fallback: interceptar submit do formulário
        forms.forEach((form, index) => {
            console.log(`📋 Configurando formulário ${index + 1}`);
            
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                console.log('📋 Formulário submetido:', form);
                this.handleFormSubmit(form);
            });
        });
    }
```

---

## ❌ BACKUP 4: 20251110_200738 (ELIMINACAO_URLS_HARDCODED)
**Arquivo:** `04-BACKUPS/2025-11-10_ELIMINACAO_URLS_HARDCODED/webflow_injection_limpo.js.backup_20251110_200738`  
**Status:** ❌ CORROMPIDO (mesmo erro)

```javascript
init() {
    console.log('🚀 MainPage inicializada');
    this.);
    } else {
        this.}

    else {
                    console.error('❌ Formulário não encontrado');
                }
            });
        }
        
        // Fallback: interceptar submit do formulário
        forms.forEach((form, index) => {
            console.log(`📋 Configurando formulário ${index + 1}`);
            
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                console.log('📋 Formulário submetido:', form);
                this.handleFormSubmit(form);
            });
        });
    }
```

---

## ❌ BACKUP 5: 20251109_094230 (INTEGRACAO_LOGGING)
**Arquivo:** `04-BACKUPS/2025-11-09_INTEGRACAO_LOGGING_20251109_094230/webflow_injection_limpo.js.backup`  
**Status:** ❌ CORROMPIDO (mesmo erro)

```javascript
init() {
    console.log('🚀 MainPage inicializada');
    this.);
    } else {
        this.}

    else {
                    console.error('❌ Formulário não encontrado');
                }
            });
        }
        
        // Fallback: interceptar submit do formulário
        forms.forEach((form, index) => {
            console.log(`📋 Configurando formulário ${index + 1}`);
            
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                console.log('📋 Formulário submetido:', form);
                this.handleFormSubmit(form);
            });
        });
    }
```

---

## ❌ BACKUP 6: 20251108_224417 (MIGRACAO_VARIAVEIS_AMBIENTE)
**Arquivo:** `04-BACKUPS/2025-11-08_MIGRACAO_VARIAVEIS_AMBIENTE_20251108_224417/JavaScript/webflow_injection_limpo.js.backup`  
**Status:** ❌ CORROMPIDO (mesmo erro)

```javascript
init() {
    console.log('🚀 MainPage inicializada');
    this.);
    } else {
        this.}

    else {
                    console.error('❌ Formulário não encontrado');
                }
            });
        }
        
        // Fallback: interceptar submit do formulário
        forms.forEach((form, index) => {
            console.log(`📋 Configurando formulário ${index + 1}`);
            
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                console.log('📋 Formulário submetido:', form);
                this.handleFormSubmit(form);
            });
        });
    }
```

---

## ✅ VERSÃO CORRETA (baseada em webflow_injection_definitivo.js)

**Arquivo de referência:** `webflow_injection_definitivo.js`  
**Status:** ✅ ESTRUTURA CORRETA

```javascript
init() {
    console.log('🚀 MainPage inicializada');
    this.setupEventListeners();
}

setupEventListeners() {
    // Aguardar o DOM estar pronto
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            this.setupFormSubmission();
        });
    } else {
        this.setupFormSubmission();
    }
}

setupFormSubmission() {
    // Procurar por formulário no Webflow
    const forms = document.querySelectorAll('form');
    console.log('📋 Formulários encontrados:', forms.length);
    
    // Interceptar botão específico do Webflow
    const submitButton = document.getElementById('submit_button_auto');
    if (submitButton) {
        console.log('🎯 Botão submit_button_auto encontrado');
        
        submitButton.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            console.log('🎯 Botão CALCULE AGORA! clicado');
            
            // Encontrar o formulário pai
            const form = submitButton.closest('form');
            if (form) {
                console.log('📋 Formulário encontrado via botão');
                this.handleFormSubmit(form);
            } else {
                console.error('❌ Formulário não encontrado');
            }
        });
    }
    
    // Fallback: interceptar submit do formulário
    forms.forEach((form, index) => {
        console.log(`📋 Configurando formulário ${index + 1}`);
        
        form.addEventListener('submit', (e) => {
            e.preventDefault();
            console.log('📋 Formulário submetido:', form);
            this.handleFormSubmit(form);
        });
    });
}
```

---

## 📊 CONCLUSÃO

**Todos os 6 backups têm o mesmo erro de sintaxe:**
- Código incompleto/quebrado: `this.);` e `this.}`
- Estrutura `else` incorreta
- Falta a declaração de `const forms = document.querySelectorAll('form');`
- Falta a lógica completa de `setupFormSubmission()`

**A versão correta deve:**
1. Chamar `this.setupEventListeners()` em `init()`
2. `setupEventListeners()` deve aguardar o DOM e chamar `setupFormSubmission()`
3. `setupFormSubmission()` deve conter toda a lógica de interceptação de formulários

---

**Data de criação:** 2025-11-11  
**Arquivo de referência:** `webflow_injection_definitivo.js` (linhas 2282-2334)

