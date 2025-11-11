# 📊 DIAGRAMAS VISUAIS: webflow_injection_limpo.js

**Data:** 11/11/2025  
**Arquivo:** `WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/webflow_injection_limpo.js`

---

## 🎯 DIAGRAMA 1: ARQUITETURA GERAL DO SISTEMA

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         WEBFLOW INJECTION LIMPO                         │
│                              (3073 linhas)                              │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
                    ▼               ▼               ▼
        ┌─────────────────┐ ┌──────────────┐ ┌──────────────────┐
        │  SpinnerTimer   │ │ProgressModal │ │    MainPage       │
        │   (Classe)      │ │    RPA       │ │    (Classe)       │
        │                 │ │  (Classe)    │ │                   │
        │ ✅ FUNCIONAL    │ │✅ FUNCIONAL  │ │❌ CORROMPIDO     │
        └─────────────────┘ └──────────────┘ └──────────────────┘
                │                   │                   │
                │                   │                   │
                ▼                   ▼                   ▼
        ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
        │ Timer 3min   │   │ Polling 2s    │   │ Intercepta    │
        │ + 2min ext    │   │ Progress API │   │ Formulários   │
        └──────────────┘   └──────────────┘   └──────────────┘
```

---

## 🔄 DIAGRAMA 2: FLUXO COMPLETO DE EXECUÇÃO

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        FASE 1: INICIALIZAÇÃO                            │
└─────────────────────────────────────────────────────────────────────────┘

    [Arquivo JS Carregado]
            │
            ▼
    ┌───────────────────────┐
    │ new MainPage()        │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ constructor()         │
    │ - sessionId = null    │
    │ - modalProgress = null│
    │ - fixedData = {...}   │
    │ - this.init()         │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ init() ❌ CORROMPIDO  │
    │ (será corrigido)      │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ setupEventListeners()│
    │ ✅ (será adicionado)  │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ setupFormSubmission()│
    │ ✅ (será adicionado)  │
    │                       │
    │ - Busca formulários  │
    │ - Intercepta botão   │
    │ - Configura listeners │
    └───────────┬───────────┘
                │
                │ [Aguardando evento]
                │
                ▼

┌─────────────────────────────────────────────────────────────────────────┐
│                    FASE 2: SUBMISSÃO DO FORMULÁRIO                     │
└─────────────────────────────────────────────────────────────────────────┘

    [Usuário submete formulário]
            │
            ▼
    ┌───────────────────────┐
    │ Event Listener        │
    │ - preventDefault()    │
    │ - stopPropagation()   │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ handleFormSubmit()    │
    │                       │
    │ 1. updateButton       │
    │    Loading(true) ✅   │
    │                       │
    │ 2. collectFormData()  │
    │    ❌ CORROMPIDO      │
    │    (linha 2534)       │
    │                       │
    │ 3. validateFormData() │
    │    ❌ CORROMPIDO      │
    │    (linha 2622)       │
    │                       │
    │ 4. openProgressModal()│
    │    ✅ FUNCIONAL       │
    │                       │
    │ 5. fetch('/api/rpa/   │
    │    start') ✅         │
    │                       │
    │ 6. initializeProgress │
    │    Modal() ✅         │
    └───────────┬───────────┘
                │
                ▼

┌─────────────────────────────────────────────────────────────────────────┐
│                      FASE 3: PROCESSAMENTO RPA                         │
└─────────────────────────────────────────────────────────────────────────┘

    ┌───────────────────────┐
    │ new ProgressModalRPA() │
    │ ✅ FUNCIONAL           │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ startProgressPolling()│
    │ ✅ FUNCIONAL          │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ setInterval(          │
    │   updateProgress,     │
    │   2000                │
    │ )                     │
    └───────────┬───────────┘
                │
                │ [A cada 2 segundos]
                │
                ▼
    ┌───────────────────────┐
    │ updateProgress()      │
    │ ✅ FUNCIONAL          │
    │                       │
    │ - fetch('/api/rpa/    │
    │   progress/...')      │
    │                       │
    │ - updateProgress      │
    │   Elements()          │
    │                       │
    │ - updateInitial       │
    │   Estimate()          │
    │                       │
    │ - updateResults()     │
    └───────────────────────┘
```

---

## 🏗️ DIAGRAMA 3: ESTRUTURA DE CLASSES

```
┌─────────────────────────────────────────────────────────────────────────┐
│                            CLASSE: SpinnerTimer                          │
│                              ✅ FUNCIONAL                                │
└─────────────────────────────────────────────────────────────────────────┘

    constructor()
        │
        ├─> initialDuration = 180s (3min)
        ├─> extendedDuration = 120s (2min)
        ├─> remainingSeconds = 180
        └─> elements = { spinnerCenter, timerMessage }

    init()
        │
        ├─> Busca spinnerCenter no DOM
        └─> Busca timerMessage no DOM

    start()
        │
        ├─> isRunning = true
        └─> setInterval(tick, 100)

    tick()
        │
        ├─> remainingSeconds -= 0.1
        ├─> Se remainingSeconds <= 0:
        │   ├─> Se não estendido: extendTimer()
        │   └─> Se estendido: finish()
        └─> updateDisplay()

    extendTimer()
        │
        ├─> isExtended = true
        └─> remainingSeconds = extendedDuration

    finish()
        │
        ├─> clearInterval()
        ├─> remainingSeconds = 0
        └─> updateDisplay()

    updateDisplay()
        │
        └─> Formata: MM:SS.C

    stop()
        │
        └─> finish()

    reset()
        │
        ├─> remainingSeconds = initialDuration
        └─> isExtended = false


┌─────────────────────────────────────────────────────────────────────────┐
│                         CLASSE: ProgressModalRPA                        │
│                              ✅ FUNCIONAL                               │
└─────────────────────────────────────────────────────────────────────────┘

    constructor(sessionId)
        │
        ├─> apiBaseUrl = 'https://rpaimediatoseguros.com.br'
        ├─> sessionId = sessionId
        ├─> progressInterval = null
        ├─> isProcessing = true
        ├─> spinnerTimer = null
        ├─> phaseMessages = { 1-16: "..." }
        ├─> phaseSubMessages = { 1-16: "..." }
        └─> phasePercentages = { 0-16: 0-100% }

    setSessionId(sessionId)
        │
        ├─> this.sessionId = sessionId
        └─> initSpinnerTimer() (se não inicializado)

    initSpinnerTimer()
        │
        ├─> new SpinnerTimer()
        ├─> spinnerTimer.init()
        └─> spinnerTimer.start()

    stopSpinnerTimer()
        │
        ├─> spinnerTimer.finish()
        └─> Esconde container

    startProgressPolling()
        │
        └─> setInterval(updateProgress, 2000)

    stopProgressPolling()
        │
        └─> clearInterval(progressInterval)

    updateProgress()
        │
        ├─> fetch('/api/rpa/progress/${sessionId}')
        ├─> Se erro: handleRPAError()
        ├─> Se sucesso:
        │   ├─> updateProgressElements()
        │   ├─> updateInitialEstimate()
        │   └─> updateResults()
        └─> Se fase 16: stopProgressPolling()

    isErrorStatus(status, mensagem, errorCode)
        │
        └─> Verifica se status é erro

    handleRPAError(mensagem, errorCode)
        │
        ├─> stopProgressPolling()
        ├─> stopSpinnerTimer()
        └─> showErrorAlert()

    showErrorAlert(mensagem, acao, errorCode)
        │
        └─> Mostra alerta com SweetAlert

    updateProgressElements(percentual, currentPhase, ...)
        │
        ├─> Atualiza progress-bar-fill
        ├─> Atualiza progress-text
        ├─> Atualiza current-phase
        └─> Atualiza sub-phase

    updateInitialEstimate(data)
        │
        └─> Atualiza estimativa inicial

    updateResults(data)
        │
        ├─> Atualiza plano recomendado
        ├─> Atualiza plano alternativo
        └─> highlightInitialEstimate()


┌─────────────────────────────────────────────────────────────────────────┐
│                            CLASSE: MainPage                              │
│                         ❌ MÚLTIPLOS PROBLEMAS                          │
└─────────────────────────────────────────────────────────────────────────┘

    constructor()
        │
        ├─> sessionId = null
        ├─> modalProgress = null
        ├─> fixedData = { ... }
        └─> this.init() ❌ CORROMPIDO

    init() ❌ CORROMPIDO
        │
        └─> [Código quebrado - será corrigido]

    setupEventListeners() ⚠️ NÃO EXISTE
        │
        └─> [Será adicionado]

    setupFormSubmission() ⚠️ NÃO EXISTE
        │
        ├─> Busca formulários
        ├─> Intercepta botão submit_button_auto
        └─> Intercepta submit de formulários

    collectFormData(form) ⚠️ NÃO EXISTE
        │
        ├─> Coleta dados do FormData
        ├─> Captura GCLID_FLD
        ├─> applyFieldConversions() ❌ CORROMPIDO
        ├─> removeDuplicateFields() ❌ NÃO CHAMADO
        └─> Mescla com fixedData

    applyFieldConversions(data) ❌ CORROMPIDO
        │
        ├─> convertEstadoCivil() ✅
        ├─> convertSexo() ✅
        ├─> convertTipoVeiculo() ✅
        └─> Mapeia campos Webflow → RPA

    removeDuplicateFields(data) ✅ EXISTE
        │
        └─> Remove campos duplicados maiúsculos

    validateFormData(formData) ❌ CORROMPIDO
        │
        ├─> new FormValidator() ⚠️ (classe não encontrada)
        ├─> validateCPF() ❌ CORROMPIDO
        ├─> validateCEP() ❌ CORROMPIDO
        ├─> validatePlaca() ❌ CORROMPIDO
        ├─> validateCelular() ❌ CORROMPIDO
        └─> validateEmail() ❌ CORROMPIDO

    handleFormSubmit(form)
        │
        ├─> updateButtonLoading(true) ✅
        ├─> collectFormData(form) ❌ CORROMPIDO
        ├─> validateFormData(formData) ❌ CORROMPIDO
        ├─> showValidationAlert() ⚠️ (código corrompido)
        ├─> openProgressModal() ✅
        ├─> fetch('/api/rpa/start') ✅
        └─> initializeProgressModal() ✅

    initializeProgressModal()
        │
        ├─> new ProgressModalRPA(sessionId) ✅
        └─> modalProgress.startProgressPolling() ✅

    openProgressModal() ✅
        │
        └─> Cria HTML do modal

    updateButtonLoading(isLoading) ✅
        │
        └─> Atualiza texto do botão

    showError(message) ✅
        │
        └─> Mostra erro

    convertEstadoCivil(webflowValue) ✅
        │
        └─> Converte estado civil

    convertSexo(webflowValue) ✅
        │
        └─> Converte sexo

    convertTipoVeiculo(webflowValue) ✅
        │
        └─> Converte tipo de veículo
```

---

## 🔴 DIAGRAMA 4: PROBLEMAS CRÍTICOS E SEUS IMPACTOS

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        PROBLEMA 1: init()                              │
│                         🔴 CRÍTICO - BLOQUEIA TUDO                      │
└─────────────────────────────────────────────────────────────────────────┘

    [Arquivo carregado]
            │
            ▼
    [new MainPage()]
            │
            ▼
    [constructor() chama this.init()]
            │
            ▼
    [init() ❌ CORROMPIDO]
            │
            ├─> this.); ❌ Erro de sintaxe
            ├─> } else { ❌ Erro de sintaxe
            └─> else { ❌ Erro de sintaxe
            │
            ▼
    [❌ NUNCA EXECUTA]
            │
            ▼
    [❌ Formulários nunca são interceptados]
            │
            ▼
    [❌ Sistema completamente quebrado]


┌─────────────────────────────────────────────────────────────────────────┐
│                    PROBLEMA 2: collectFormData()                        │
│                         🔴 CRÍTICO - BLOQUEIA FLUXO                     │
└─────────────────────────────────────────────────────────────────────────┘

    [handleFormSubmit(form)]
            │
            ▼
    [const formData = this.console.log(...)] ❌
            │
            ├─> this.console.log não é método da classe
            ├─> console.log retorna undefined
            └─> formData = undefined
            │
            ▼
    [validateFormData(undefined)] ❌
            │
            ▼
    [Erro: Cannot read property 'cpf' of undefined]
            │
            ▼
    [❌ Sistema quebra]


┌─────────────────────────────────────────────────────────────────────────┐
│                    PROBLEMA 3: validateFormData()                       │
│                         🔴 CRÍTICO - BLOQUEIA VALIDAÇÃO                 │
└─────────────────────────────────────────────────────────────────────────┘

    [validateFormData(formData)]
            │
            ▼
    [const validator = new FormValidator()] ⚠️
            │
            ▼
    [await Promise.all([
        validator.) ❌ Erro de sintaxe
    ])]
            │
            ▼
    [❌ Erro de sintaxe - código não executa]
            │
            ▼
    [❌ Validações nunca executam]


┌─────────────────────────────────────────────────────────────────────────┐
│                 PROBLEMA 4: applyFieldConversions()                     │
│                         🔴 CRÍTICO - BLOQUEIA CONVERSÃO                 │
└─────────────────────────────────────────────────────────────────────────┘

    [collectFormData(form)]
            │
            ▼
    [this.applyFieldConversions(data)] ❌
            │
            ├─> this./** ❌ Código quebrado (linha 2293)
            ├─> this." → "${data.sexo}"`); ❌ (linha 2336)
            └─> this." → "${data.tipo_veiculo}"`); ❌ (linha 2341)
            │
            ▼
    [❌ Erro de sintaxe]
            │
            ▼
    [❌ Conversões nunca são aplicadas]
            │
            ▼
    [❌ Dados incorretos enviados para API]
```

---

## 📊 DIAGRAMA 5: FLUXO CORRETO APÓS TODAS AS CORREÇÕES

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FLUXO CORRETO (IDEAL)                           │
└─────────────────────────────────────────────────────────────────────────┘

    [Arquivo JS Carregado]
            │
            ▼
    [new MainPage()]
            │
            ▼
    [constructor()]
            │
            └─> this.init() ✅
                    │
                    ▼
            [setupEventListeners()] ✅
                    │
                    ▼
            [setupFormSubmission()] ✅
                    │
                    ├─> Busca formulários ✅
                    ├─> Intercepta botão ✅
                    └─> Configura listeners ✅
                            │
                            │ [Aguardando evento]
                            │
                            ▼
            [Usuário submete formulário]
                            │
                            ▼
            [handleFormSubmit(form)] ✅
                            │
                            ├─> updateButtonLoading(true) ✅
                            │
                            ├─> collectFormData(form) ✅
                            │   │
                            │   ├─> Coleta FormData ✅
                            │   ├─> Captura GCLID_FLD ✅
                            │   ├─> applyFieldConversions() ✅
                            │   │   ├─> convertEstadoCivil() ✅
                            │   │   ├─> convertSexo() ✅
                            │   │   └─> convertTipoVeiculo() ✅
                            │   ├─> removeDuplicateFields() ✅
                            │   └─> Mescla com fixedData ✅
                            │
                            ├─> validateFormData(formData) ✅
                            │   │
                            │   ├─> validateCPF() ✅
                            │   ├─> validateCEP() ✅
                            │   ├─> validatePlaca() ✅
                            │   ├─> validateCelular() ✅
                            │   └─> validateEmail() ✅
                            │
                            ├─> showValidationAlert() ✅
                            │   │
                            │   └─> Se válido ou usuário prossegue:
                            │
                            ├─> openProgressModal() ✅
                            │
                            ├─> fetch('/api/rpa/start') ✅
                            │   │
                            │   └─> Recebe sessionId ✅
                            │
                            └─> initializeProgressModal() ✅
                                    │
                                    ▼
                            [new ProgressModalRPA(sessionId)] ✅
                                    │
                                    ├─> initSpinnerTimer() ✅
                                    │   └─> SpinnerTimer inicia ✅
                                    │
                                    └─> startProgressPolling() ✅
                                            │
                                            └─> [A cada 2s]
                                                    │
                                                    ▼
                                            [updateProgress()] ✅
                                                    │
                                                    ├─> fetch('/api/rpa/progress/...') ✅
                                                    ├─> updateProgressElements() ✅
                                                    ├─> updateInitialEstimate() ✅
                                                    └─> updateResults() ✅
                                                            │
                                                            └─> [Quando fase 16]
                                                                    │
                                                                    ▼
                                                            [✅ Processo completo]
```

---

## 🎯 DIAGRAMA 6: MAPA DE DEPENDÊNCIAS

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         DEPENDÊNCIAS ENTRE MÉTODOS                     │
└─────────────────────────────────────────────────────────────────────────┘

    MainPage.constructor()
        └─> MainPage.init() ❌ CORROMPIDO
                └─> MainPage.setupEventListeners() ⚠️ NÃO EXISTE
                        └─> MainPage.setupFormSubmission() ⚠️ NÃO EXISTE
                                └─> [Event Listener]
                                        └─> MainPage.handleFormSubmit()
                                                │
                                                ├─> MainPage.updateButtonLoading() ✅
                                                │
                                                ├─> MainPage.collectFormData() ⚠️ NÃO EXISTE
                                                │   │
                                                │   ├─> MainPage.applyFieldConversions() ❌ CORROMPIDO
                                                │   │   │
                                                │   │   ├─> MainPage.convertEstadoCivil() ✅
                                                │   │   ├─> MainPage.convertSexo() ✅
                                                │   │   └─> MainPage.convertTipoVeiculo() ✅
                                                │   │
                                                │   └─> MainPage.removeDuplicateFields() ✅
                                                │       └─> [Nunca chamado devido a código quebrado]
                                                │
                                                ├─> MainPage.validateFormData() ❌ CORROMPIDO
                                                │   │
                                                │   └─> FormValidator ⚠️ NÃO ENCONTRADO
                                                │       │
                                                │       ├─> FormValidator.validateCPF() ⚠️
                                                │       ├─> FormValidator.validateCEP() ⚠️
                                                │       ├─> FormValidator.validatePlaca() ⚠️
                                                │       ├─> FormValidator.validateCelular() ⚠️
                                                │       └─> FormValidator.validateEmail() ⚠️
                                                │
                                                ├─> MainPage.showValidationAlert() ⚠️ CORROMPIDO
                                                │
                                                ├─> MainPage.openProgressModal() ✅
                                                │
                                                ├─> fetch('/api/rpa/start') ✅
                                                │
                                                └─> MainPage.initializeProgressModal() ✅
                                                        │
                                                        └─> new ProgressModalRPA() ✅
                                                                │
                                                                ├─> ProgressModalRPA.setSessionId() ✅
                                                                │   └─> ProgressModalRPA.initSpinnerTimer() ✅
                                                                │       └─> new SpinnerTimer() ✅
                                                                │           └─> SpinnerTimer.init() ✅
                                                                │               └─> SpinnerTimer.start() ✅
                                                                │
                                                                └─> ProgressModalRPA.startProgressPolling() ✅
                                                                        │
                                                                        └─> ProgressModalRPA.updateProgress() ✅
                                                                                │
                                                                                ├─> fetch('/api/rpa/progress/...') ✅
                                                                                ├─> ProgressModalRPA.updateProgressElements() ✅
                                                                                ├─> ProgressModalRPA.updateInitialEstimate() ✅
                                                                                └─> ProgressModalRPA.updateResults() ✅
```

---

## 📋 LEGENDA

| Símbolo | Significado |
|--------|------------|
| ✅ | Funcional / Correto |
| ❌ | Corrompido / Quebrado |
| ⚠️ | Não existe / Não encontrado |
| 🔴 | Crítico - Bloqueia execução |
| 🟡 | Médio - Quebra funcionalidade |
| 🟢 | Baixo - Código morto |

---

**Documento criado em:** 11/11/2025  
**Última atualização:** 11/11/2025

