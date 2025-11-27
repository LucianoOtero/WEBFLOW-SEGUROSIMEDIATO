/**
 * PROJETO: UNIFICAÇÃO DE ARQUIVOS FOOTER CODE
 * INÍCIO: 30/10/2025 19:55
 * ÚLTIMA ALTERAÇÃO: 11/11/2025 13:35
 * 
 * VERSÃO: 1.7.0 - Eliminação de setInterval + MutationObserver
 * 
 * Arquivo unificado contendo:
 * - FooterCodeSiteDefinitivoUtils.js (Parte 1)
 * - Footer Code Site Definitivo.js (Parte 2 - modificado)
 * - Inside Head Tag Pagina.js (Parte 3 - GCLID integrado)
 * 
 * ALTERAÇÕES VERSÃO 1.7.0:
 * - ✅ Eliminado setInterval que causava memory leak (linha 1685-1693)
 * - ✅ Substituído por MutationObserver para detectar criação do modal
 * - ✅ Implementada função de limpeza centralizada (cleanup)
 * - ✅ Adicionado fallback para jQuery não disponível
 * - ✅ Melhorada performance (não usa polling, apenas detecta mudanças no DOM)
 * 
 * ALTERAÇÕES VERSÃO 1.6.0:
 * - ✅ Implementada detecção iOS melhorada (inclui iPad iOS 13+)
 * - ✅ Adicionada flag de controle para prevenir dupla execução
 * - ✅ Implementado handler touchstart para iOS (intercepta antes do Safari seguir link)
 * - ✅ Melhorado handler click com prevenção de dupla execução
 * - ✅ Implementado uso de passive: false apenas em iOS (otimizado para outros dispositivos)
 * - ✅ Correção do problema do modal abrindo como nova aba em dispositivos iOS
 * 
 * BASEADO EM:
 * - PESQUISA_SOLUCOES_VALIDADAS_FONTES_REFERENCIA.md
 * - MDN Web Docs, Stack Overflow, web.dev, WCAG Guidelines
 * 
 * ARQUIVOS RELACIONADOS:
 * - MODAL_WHATSAPP_DEFINITIVO_dev.js
 * - WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PESQUISA_SOLUCOES_VALIDADAS_FONTES_REFERENCIA.md
 * - WEBFLOW-SEGUROSIMEDIATO/05-DOCUMENTATION/PROJETO_CORRECAO_MODAL_IOS_NOVA_ABA.md
 * 
 * ALTERAÇÕES VERSÃO 1.5.0:
 * - ✅ Correção crítica: window.DEBUG_CONFIG não sobrescreve mais valores do Webflow Footer Code
 * - ✅ Verificação prioritária movida para primeira linha de logUnified()
 * - ✅ Bloqueio completo de logs quando enabled === false
 * - ✅ Verificações adicionais em todas as callbacks da função logDebug()
 * - ✅ Preservação de valores definidos no Webflow Footer Code usando || operator
 * - ✅ Sistema de logs agora respeita completamente window.DEBUG_CONFIG.enabled
 * 
 * ALTERAÇÕES VERSÃO 1.4.0:
 * - ✅ Sistema unificado de controle de logs implementado
 * - ✅ ~102 ocorrências de console.log/error/warn substituídas por funções unificadas
 * - ✅ Função logDebug() mantida intacta (13 logs internos preservados)
 * - ✅ Configuração global via window.DEBUG_CONFIG (nível, categorias, ambiente)
 * - ✅ Auto-detecção de ambiente (dev/prod) com cache para performance
 * - ✅ Funções de alias: logInfo(), logError(), logWarn(), logDebug()
 * - ✅ Logs categorizados: UTILS, GCLID, MODAL, FOOTER, RPA, GTM, DEBUG, etc.
 * 
 * ALTERAÇÕES VERSÃO 1.3.1:
 * - Constantes globais movidas para ANTES da verificação do Footer Code Utils
 * - Eliminado aviso "Constantes faltando" no console
 * - Sincronização com versão de produção
 * 
 * ALTERAÇÕES VERSÃO 1.3:
 * - Adicionados logs de debug detalhados na captura imediata de GCLID
 * - Implementado fallback no DOMContentLoaded para re-tentar captura se cookie não existir
 * - Adicionado tratamento de erros com try-catch na captura imediata
 * - Adicionado log de verificação do cookie após salvamento
 * - Melhorados logs no preenchimento de campos GCLID_FLD (mostra quantidade encontrada e índice)
 * - Logs adicionais para diagnóstico: URL, window.location.search, valores capturados, gclsrc
 * - Garantido que código execute corretamente mesmo se captura imediata falhar
 * 
 * ALTERAÇÕES VERSÃO 1.2:
 * - Integração completa do código GCLID do Inside Head Tag Pagina.js
 * - Captura imediata de GCLID/GBRAID da URL e salvamento em cookie
 * - Preenchimento automático de campos GCLID_FLD
 * - Configuração de CollectChatAttributes
 * - Listeners em anchors para salvar valores no localStorage
 * - Eliminação da necessidade de Head Code no Webflow
 * 
 * Localização: https://dev.bssegurosimediato.com.br/webhooks/FooterCodeSiteDefinitivoCompleto_dev.js
 * 
 * ⚠️ AMBIENTE: DESENVOLVIMENTO
 * - SafetyMails Ticket: fc5e18c10c4aa883b2c31a305f1c09fea3834138
 * - SafetyMails API Key: 20a7a1c297e39180bd80428ac13c363e882a531f
 * - Ver documentação: DOCUMENTACAO_MIGRACAO_PRODUCAO_SAFETYMAILS.md
 */

// ======================
// VARIÁVEL GLOBAL DE VERSÃO
// ======================
window.versao = '1.7.0';
    
    // ======================
// CONFIGURAÇÃO DE LOGGING E FUNÇÕES CENTRALIZADAS (MOVIDAS PARA O INÍCIO)
// PROJETO: Mover novo_log() para Início e Substituir console.log
// Data: 27/11/2025
    // ======================
(function initLoggingSystem() {
  'use strict';
    
  try {
    // Função helper para ler data attribute do script tag
    function getDataAttribute(attributeName) {
    const currentScript = document.currentScript;
      if (currentScript && currentScript.dataset && currentScript.dataset[attributeName]) {
        return currentScript.dataset[attributeName];
      }
      // Fallback: buscar em todos os scripts
      const scripts = document.getElementsByTagName('script');
      for (let script of scripts) {
        if (script.src && script.src.includes('bssegurosimediato.com.br') && script.dataset && script.dataset[attributeName]) {
          return script.dataset[attributeName];
        }
      }
      return null;
    }
    
    // Tentar ler APP_BASE_URL do data attribute (se disponível)
    if (!window.APP_BASE_URL) {
      const appBaseUrl = getDataAttribute('appBaseUrl');
      if (appBaseUrl) {
        window.APP_BASE_URL = appBaseUrl;
      }
    }
    
    // Ler configuração de logging do data attribute do script tag
    let logConfigFromAttribute = {};
    const currentScript = document.currentScript || (() => {
      const scripts = document.getElementsByTagName('script');
      for (let script of scripts) {
        if (script.src && script.src.includes('bssegurosimediato.com.br') && script.dataset) {
          return script;
        }
      }
      return null;
    })();
    
    if (currentScript && currentScript.dataset) {
      // Ler configurações de logging do data attribute
      if (currentScript.dataset.logEnabled !== undefined) {
        logConfigFromAttribute.enabled = currentScript.dataset.logEnabled === 'true' || currentScript.dataset.logEnabled === '1';
      }
      if (currentScript.dataset.logLevel !== undefined) {
        logConfigFromAttribute.level = currentScript.dataset.logLevel;
      }
      if (currentScript.dataset.logDatabaseEnabled !== undefined) {
        logConfigFromAttribute.database = logConfigFromAttribute.database || {};
        logConfigFromAttribute.database.enabled = currentScript.dataset.logDatabaseEnabled === 'true' || currentScript.dataset.logDatabaseEnabled === '1';
      }
      if (currentScript.dataset.logDatabaseMinLevel !== undefined) {
        logConfigFromAttribute.database = logConfigFromAttribute.database || {};
        logConfigFromAttribute.database.min_level = currentScript.dataset.logDatabaseMinLevel;
      }
      if (currentScript.dataset.logConsoleEnabled !== undefined) {
        logConfigFromAttribute.console = logConfigFromAttribute.console || {};
        logConfigFromAttribute.console.enabled = currentScript.dataset.logConsoleEnabled === 'true' || currentScript.dataset.logConsoleEnabled === '1';
      }
      if (currentScript.dataset.logConsoleMinLevel !== undefined) {
        logConfigFromAttribute.console = logConfigFromAttribute.console || {};
        logConfigFromAttribute.console.min_level = currentScript.dataset.logConsoleMinLevel;
      }
      if (currentScript.dataset.logFileEnabled !== undefined) {
        logConfigFromAttribute.file = logConfigFromAttribute.file || {};
        logConfigFromAttribute.file.enabled = currentScript.dataset.logFileEnabled === 'true' || currentScript.dataset.logFileEnabled === '1';
      }
      if (currentScript.dataset.logFileMinLevel !== undefined) {
        logConfigFromAttribute.file = logConfigFromAttribute.file || {};
        logConfigFromAttribute.file.min_level = currentScript.dataset.logFileMinLevel;
      }
      if (currentScript.dataset.logExcludeCategories !== undefined) {
        logConfigFromAttribute.exclude_categories = currentScript.dataset.logExcludeCategories.split(',').map(c => c.trim()).filter(c => c);
      }
      if (currentScript.dataset.logExcludeContexts !== undefined) {
        logConfigFromAttribute.exclude_contexts = currentScript.dataset.logExcludeContexts.split(',').map(c => c.trim()).filter(c => c);
      }
      if (currentScript.dataset.logEnvironment !== undefined) {
        logConfigFromAttribute.environment = currentScript.dataset.logEnvironment;
      }
    }
    
    // Auto-detectar ambiente se não especificado
    let detectedEnvironment = logConfigFromAttribute.environment || window.APP_ENVIRONMENT || 'prod';
    if (detectedEnvironment === 'auto') {
      const hostname = window.location.hostname;
      if (hostname.includes('dev.') || hostname.includes('localhost') || hostname.includes('127.0.0.1')) {
        detectedEnvironment = 'dev';
      } else {
        detectedEnvironment = 'prod';
      }
    }
    
    // Valores padrão (usados se não definidos via data attribute ou código)
    const defaultLogConfig = {
      enabled: true,
      level: 'info',
      database: {
        enabled: true,
        min_level: 'info'
      },
      console: {
        enabled: true,
        min_level: 'info'
      },
      file: {
        enabled: true,
        min_level: 'error'
      },
      exclude_categories: [],
      exclude_contexts: [],
      environment: detectedEnvironment
    };
    
    // Aplicar valores mais restritivos em produção
    if (detectedEnvironment === 'prod') {
      defaultLogConfig.level = 'error';
      defaultLogConfig.database.min_level = 'error';
      defaultLogConfig.console.min_level = 'error';
    }
    
    // Merge de configurações (ordem de prioridade: data attributes > window.LOG_CONFIG > defaults)
    window.LOG_CONFIG = {
      ...defaultLogConfig,
      ...logConfigFromAttribute,
      ...(window.LOG_CONFIG || {}), // Permitir override programático
      database: {
        ...defaultLogConfig.database,
        ...(logConfigFromAttribute.database || {}),
        ...(window.LOG_CONFIG?.database || {})
      },
      console: {
        ...defaultLogConfig.console,
        ...(logConfigFromAttribute.console || {}),
        ...(window.LOG_CONFIG?.console || {})
      },
      file: {
        ...defaultLogConfig.file,
        ...(logConfigFromAttribute.file || {}),
        ...(window.LOG_CONFIG?.file || {})
      },
      environment: detectedEnvironment
    };
    
    // Funções helper para verificação de logging
    window.shouldLog = function(level, category = null) {
      if (!window.LOG_CONFIG || window.LOG_CONFIG.enabled === false) {
        return false;
      }
      
      // Verificar nível
      const levels = { 'none': 0, 'error': 1, 'warn': 2, 'info': 3, 'debug': 4, 'all': 5 };
      const configLevel = levels[window.LOG_CONFIG.level?.toLowerCase()] || levels['info'];
      const messageLevel = levels[level?.toLowerCase()] || levels['info'];
      if (messageLevel > configLevel) {
        return false;
      }
      
      // Verificar exclusão de categoria
      if (category && window.LOG_CONFIG.exclude_categories && window.LOG_CONFIG.exclude_categories.length > 0) {
        if (window.LOG_CONFIG.exclude_categories.includes(category)) {
          return false;
        }
      }
      
      return true;
    };
    
    window.shouldLogToDatabase = function(level) {
      if (!window.LOG_CONFIG || !window.LOG_CONFIG.database || window.LOG_CONFIG.database.enabled === false) {
        return false;
      }
      
      const levels = { 'none': 0, 'error': 1, 'warn': 2, 'info': 3, 'debug': 4, 'all': 5 };
      const minLevel = levels[window.LOG_CONFIG.database.min_level?.toLowerCase()] || levels['info'];
      const messageLevel = levels[level?.toLowerCase()] || levels['info'];
      return messageLevel <= minLevel;
    };
    
    window.shouldLogToConsole = function(level) {
      if (!window.LOG_CONFIG || !window.LOG_CONFIG.console || window.LOG_CONFIG.console.enabled === false) {
        return false;
      }
      
      const levels = { 'none': 0, 'error': 1, 'warn': 2, 'info': 3, 'debug': 4, 'all': 5 };
      const minLevel = levels[window.LOG_CONFIG.console.min_level?.toLowerCase()] || levels['info'];
      const messageLevel = levels[level?.toLowerCase()] || levels['info'];
      return messageLevel <= minLevel;
    };
    
    /**
     * Envia log para o novo sistema profissional
     * @param {string} level - Nível do log (DEBUG, INFO, WARN, ERROR, FATAL)
     * @param {string} category - Categoria do log (UTILS, MODAL, RPA, etc.)
     * @param {string} message - Mensagem do log
     * @param {*} data - Dados adicionais (opcional)
     * @returns {Promise<boolean>} true se enviado com sucesso
     */
    async function sendLogToProfessionalSystem(level, category, message, data) {
      // Verificar parametrização completa usando window.LOG_CONFIG
      // Verificar se logs estão desabilitados globalmente
      if (!window.shouldLog || !window.shouldLog(level, category)) {
        return false;
      }
      
      // Verificar se deve enviar para banco de dados
      if (!window.shouldLogToDatabase || !window.shouldLogToDatabase(level)) {
        return false;
      }
      
      // Verificar DEBUG_CONFIG (compatibilidade com código legado)
      if (window.DEBUG_CONFIG && 
          (window.DEBUG_CONFIG.enabled === false || window.DEBUG_CONFIG.enabled === 'false')) {
        return false;
      }
      
      // Validar parâmetros obrigatórios
      if (!level || level === null || level === undefined || level === '') {
        // Usar console.warn direto para prevenir loop infinito
        console.warn('[LOG] sendLogToProfessionalSystem chamado sem level válido');
        return false;
      }
      
      if (!message || message === null || message === undefined || message === '') {
        // Usar console.warn direto para prevenir loop infinito
        console.warn('[LOG] sendLogToProfessionalSystem chamado sem message válido');
        return false;
      }
      
      // Validar que APP_BASE_URL está disponível (pode não estar se movido para início)
      if (!window.APP_BASE_URL) {
        // Usar console.error direto para prevenir loop infinito
        console.error('[LOG] CRITICAL: APP_BASE_URL não está disponível');
        console.error('[LOG] CRITICAL: Verifique se data-app-base-url está definido no script tag no Webflow Footer Code');
        return false;
      }
      
      try {
        // Construir URL do endpoint
        const baseUrl = window.APP_BASE_URL;
        const endpoint = baseUrl + '/log_endpoint.php';
        
        // Garantir que level seja string válido
        const validLevel = String(level).toUpperCase().trim();
        const validLevels = ['DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL', 'TRACE'];
        if (!validLevels.includes(validLevel)) {
          // Usar console.warn direto para prevenir loop infinito
          console.warn('[LOG] Level inválido: ' + level + ' - usando INFO como fallback', { level: level });
          level = 'INFO';
        } else {
          level = validLevel;
        }
        
        // Garantir que message seja string
        const validMessage = String(message);
        
        // Capturar stack trace para identificar arquivo/linha
        let stackTrace = null;
        let callerInfo = null;
        try {
          const error = new Error();
          if (error.stack) {
            stackTrace = error.stack;
            // Extrair informações do caller (ignorar sendLogToProfessionalSystem e logUnified)
            const stackLines = error.stack.split('\n');
            for (let i = 3; i < stackLines.length; i++) {
              const line = stackLines[i].trim();
              // Padrão: "at functionName (file.js:123:45)"
              const match = line.match(/at\s+(?:\w+\.)?(\w+)?\s*\(?([^:]+):(\d+):(\d+)\)?/);
              if (match) {
                callerInfo = {
                  file_name: match[2].split('/').pop().split('\\').pop(),
                  file_path: match[2],
                  line_number: parseInt(match[3]),
                  function_name: match[1] || null
                };
                break;
              }
            }
          }
        } catch (e) {
          // Silenciosamente ignorar erros de captura
        }
        
        // Preparar payload
        const logData = {
          level: level, // Já validado e em maiúsculas
          category: category || null,
          message: validMessage, // Já validado como string
          data: data || null,
          session_id: window.sessionId || null,
          url: window.location.href,
          stack_trace: stackTrace,
          // Informações do caller (se capturadas)
          file_name: callerInfo ? callerInfo.file_name : null,
          file_path: callerInfo ? callerInfo.file_path : null,
          line_number: callerInfo ? callerInfo.line_number : null,
          function_name: callerInfo ? callerInfo.function_name : null
        };
        
        // Log detalhado no console ANTES de enviar (Usar console.log direto para prevenir loop infinito)
        const requestId = 'req_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
        console.log('[LOG] Enviando log para', endpoint, { requestId: requestId });
        console.log('[LOG] Payload', {
          level: logData.level,
          category: logData.category,
          message: logData.message.substring(0, 100) + (logData.message.length > 100 ? '...' : ''),
          message_length: logData.message.length,
          has_data: logData.data !== null,
          has_stack_trace: logData.stack_trace !== null,
          has_caller_info: callerInfo !== null,
          url: logData.url,
          session_id: logData.session_id
        });
        console.log('[LOG] Payload completo', logData);
        console.log('[LOG] Endpoint', { endpoint: endpoint });
        console.log('[LOG] Timestamp', { timestamp: new Date().toISOString() });
        
        // Enviar requisição (assíncrono, não bloqueia)
        const fetchStartTime = performance.now();
        fetch(endpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(logData),
          mode: 'cors',
          credentials: 'omit'
        }).then(response => {
          const fetchDuration = performance.now() - fetchStartTime;
          // Usar console.log direto para prevenir loop infinito
          console.log('[LOG] Resposta recebida (' + Math.round(fetchDuration) + 'ms)', {
            status: response.status,
            statusText: response.statusText,
            ok: response.ok,
            headers: Object.fromEntries(response.headers.entries())
          });
          
          if (!response.ok) {
            // Tentar ler o corpo da resposta mesmo em caso de erro
            return response.text().then(text => {
              let errorData = null;
              try {
                errorData = JSON.parse(text);
              } catch (e) {
                errorData = { raw_response: text.substring(0, 500), parse_error: e.message };
              }
              
              // Log detalhado do erro com todos os dados (Usar console.error direto)
              console.error('[LOG] Erro HTTP na resposta', {
                status: response.status,
                statusText: response.statusText,
                response_data: errorData,
                request_id: requestId
              });
              
              // Log expandido do response_data para facilitar análise
              console.log('[LOG] Detalhes completos do erro', errorData);
              
              // Se houver debug info, mostrar separadamente
              if (errorData && errorData.debug) {
                console.log('[LOG] Debug info do servidor', errorData.debug);
              }
              
              throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            });
          }
          return response.json();
        }).then(result => {
          const fetchDuration = performance.now() - fetchStartTime;
          // Usar console.log direto para prevenir loop infinito
          console.log('[LOG] Sucesso (' + Math.round(fetchDuration) + 'ms)', {
            success: result.success,
            log_id: result.log_id,
            request_id: result.request_id,
            timestamp: result.timestamp,
            full_response: result
          });
          
          if (result.success) {
            console.log('[LOG] Enviado', { log_id: result.log_id });
          }
        }).catch(error => {
          const fetchDuration = performance.now() - fetchStartTime;
          // Usar console.error direto para prevenir loop infinito
          console.error('[LOG] Erro ao enviar log (' + Math.round(fetchDuration) + 'ms)', {
            error: error,
            message: error.message,
            stack: error.stack,
            request_id: requestId,
            endpoint: endpoint,
            payload: logData
          });
          
          // Não quebrar aplicação se logging falhar
          console.error('[LOG] Erro ao enviar log', error);
        });
        
        return true;
      } catch (error) {
        // Não quebrar aplicação se logging falhar (Usar console.error direto para prevenir loop infinito)
        console.error('[LOG] Erro ao enviar log', error);
        return false;
      }
    }
    
    // Expor função globalmente para uso em outros escopos
    window.sendLogToProfessionalSystem = sendLogToProfessionalSystem;
    
    /**
     * Função única de log centralizada - novo_log()
     * PROJETO: Unificar Função de Log - Uma Única Função Centralizada
     * Data: 17/11/2025
     * Versão: 2.0.0
     */
    function novo_log(level, category, message, data, context = 'OPERATION', verbosity = 'SIMPLE') {
      try {
        // 1. Verificar parametrização global (window.shouldLog)
        if (typeof window.shouldLog === 'function') {
          if (!window.shouldLog(level, category)) {
            return false; // Não deve logar
          }
        }
        
        // 2. Verificar DEBUG_CONFIG (compatibilidade com código existente)
        if (window.DEBUG_CONFIG && 
            (window.DEBUG_CONFIG.enabled === false || window.DEBUG_CONFIG.enabled === 'false')) {
          // CRITICAL sempre exibe mesmo se desabilitado
          if (level !== 'CRITICAL') {
            return false;
          }
        }
        
        // 3. Verificar se deve exibir no console
        let shouldLogToConsole = true;
        if (typeof window.shouldLogToConsole === 'function') {
          shouldLogToConsole = window.shouldLogToConsole(level);
        }
        
        // 4. Verificar se deve enviar para banco
        let shouldLogToDatabase = true;
        if (typeof window.shouldLogToDatabase === 'function') {
          shouldLogToDatabase = window.shouldLogToDatabase(level);
        }
        
        // Se não deve logar em nenhum lugar, retornar
        if (!shouldLogToConsole && !shouldLogToDatabase) {
          return false;
        }
        
        // 5. Exibir no console se configurado
        if (shouldLogToConsole) {
          const formattedMessage = category ? `[${category}] ${message}` : message;
          const levelUpper = String(level || 'INFO').toUpperCase();
          
          switch(levelUpper) {
            case 'CRITICAL':
            case 'ERROR':
            case 'FATAL':
              console.error(formattedMessage, data || '');
              break;
            case 'WARN':
            case 'WARNING':
              console.warn(formattedMessage, data || '');
              break;
            case 'INFO':
            case 'DEBUG':
            case 'TRACE':
            default:
              console.log(formattedMessage, data || '');
              break;
          }
        }
        
        // 6. Enviar para banco se configurado (assíncrono, não bloqueia)
        if (shouldLogToDatabase && typeof window.sendLogToProfessionalSystem === 'function') {
          // Chamar de forma assíncrona com tratamento de erro silencioso
          window.sendLogToProfessionalSystem(level, category, message, data).catch(() => {
            // Silenciosamente ignorar erros de logging (não quebrar aplicação)
          });
        }
        
        return true;
      } catch (error) {
        // Tratamento de erro silencioso - não quebrar aplicação se logging falhar
        // Usar console.error direto para prevenir loop infinito
        console.error('[LOG] Erro em novo_log():', error);
        return false;
      }
    }
    
    // Expor função globalmente
    window.novo_log = novo_log;
    
    // ======================
    // LOG DE CARREGAMENTO DO ARQUIVO
    // ======================
    // Logar versão quando arquivo for carregado
    (function logFileLoad() {
      try {
        // Aguardar DOM estar pronto ou executar imediatamente se já estiver
        if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', function() {
            window.novo_log('INFO', 'FOOTER_CODE', 'FooterCodeSiteDefinitivoCompleto.js carregado', {
              versao: window.versao || 'não definida',
              timestamp: new Date().toISOString(),
              readyState: document.readyState
            }, 'INIT', 'MEDIUM');
          });
        } else {
          // DOM já está pronto, logar imediatamente
          window.novo_log('INFO', 'FOOTER_CODE', 'FooterCodeSiteDefinitivoCompleto.js carregado', {
            versao: window.versao || 'não definida',
            timestamp: new Date().toISOString(),
            readyState: document.readyState
          }, 'INIT', 'MEDIUM');
        }
      } catch (error) {
        // Tratamento de erro silencioso - não quebrar aplicação
        console.warn('[FOOTER_CODE] Erro ao logar carregamento:', error);
      }
    })();
    
  } catch (error) {
    // Tratamento de erro silencioso - não quebrar aplicação se logging falhar
    console.error('[LOG] Erro ao inicializar sistema de logging:', error);
  }
})();

// ======================
// SENTRY ERROR TRACKING
// Integração: 27/11/2025
// Versão: Simplificada - Início do arquivo
// ======================
(function initSentryTracking() {
  'use strict';
  
  // Evitar duplicação
  if (window.SENTRY_INITIALIZED) {
    return;
  }
  
  // Função helper para detectar ambiente
  function getEnvironment() {
    const hostname = window.location.hostname;
    const href = window.location.href;
    
    // Prioridade 1: Detecção explícita via hostname
    if (hostname.includes('dev.') || 
        hostname.includes('localhost') ||
        hostname.includes('127.0.0.1') ||
        hostname.includes('-dev.webflow.io') ||
        hostname.includes('.dev.') ||
        href.includes('/dev/')) {
      return 'dev';
    }
    
    // Prioridade 2: Verificar webflow.io (geralmente é DEV)
    if (hostname.indexOf('webflow.io') !== -1) {
      return 'dev';
    }
    
    // Prioridade 3: Usar window.APP_ENVIRONMENT se disponível
    if (typeof window.APP_ENVIRONMENT !== 'undefined' && window.APP_ENVIRONMENT) {
      return window.APP_ENVIRONMENT === 'dev' ? 'dev' : 'prod';
    }
    
    // Prioridade 4: Usar window.LOG_CONFIG.environment se disponível
    if (typeof window.LOG_CONFIG !== 'undefined' && window.LOG_CONFIG && window.LOG_CONFIG.environment) {
      return window.LOG_CONFIG.environment === 'dev' ? 'dev' : 'prod';
    }
    
    // Prioridade 5: Fallback para prod
    return 'prod';
  }
  
  // Expor função globalmente para testes e debug
  window.getEnvironment = getEnvironment;
  
  // Função centralizada de inicialização
  function initializeSentry() {
    if (window.SENTRY_INITIALIZED || typeof Sentry === 'undefined') {
      return;
    }
    
    try {
      const environment = getEnvironment();
      
      Sentry.init({
        dsn: "https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424",
        environment: environment,
        tracesSampleRate: 0.1,
        beforeSend: function(event, hint) {
          if (event && event.extra) {
            delete event.extra.ddd;
            delete event.extra.celular;
            delete event.extra.cpf;
            delete event.extra.nome;
            delete event.extra.email;
            delete event.extra.phone;
            delete event.extra.phone_number;
          }
          
          if (event && event.contexts) {
            if (event.contexts.user) {
              delete event.contexts.user.email;
              delete event.contexts.user.phone;
            }
          }
          
          return event;
        },
        ignoreErrors: [
          'ResizeObserver loop limit exceeded',
          'Non-Error promise rejection captured',
          'Script error.',
          'NetworkError'
        ]
      });
      
      window.SENTRY_INITIALIZED = true;
      
      // Log de inicialização usando novo_log()
      window.novo_log('INFO', 'SENTRY', 'Sentry inicializado com sucesso', {
        environment: environment,
        method: 'simplified_init'
      }, 'INIT', 'MEDIUM');
      
      // Log de status usando novo_log()
      window.novo_log('INFO', 'SENTRY', 'Status', {
        carregado: typeof Sentry !== 'undefined',
        inicializado: window.SENTRY_INITIALIZED,
        environment: environment,
        timestamp: new Date().toISOString()
      }, 'INIT', 'MEDIUM');
    } catch (sentryError) {
      // Não quebrar aplicação se Sentry falhar
      const errorMsg = sentryError.message || 'Erro desconhecido';
      if (typeof window.novo_log === 'function') {
        window.novo_log('WARN', 'SENTRY', 'Erro ao inicializar Sentry (não bloqueante)', {
          error: errorMsg,
          stack: sentryError.stack
        }, 'INIT', 'SIMPLE');
      } else {
        console.error('[SENTRY] Erro ao inicializar Sentry:', errorMsg);
      }
    }
  }
  
  // Se Sentry já está carregado, inicializar diretamente
  if (typeof Sentry !== 'undefined') {
    // Log usando novo_log()
    window.novo_log('INFO', 'SENTRY', 'Sentry já está carregado, inicializando...', null, 'INIT', 'MEDIUM');
    initializeSentry();
    return;
  }
  
  // Log usando novo_log()
  window.novo_log('INFO', 'SENTRY', 'Carregando SDK do Sentry...', null, 'INIT', 'MEDIUM');
  
  // Se não está carregado, carregar e inicializar após carregar
  const script = document.createElement('script');
  script.src = 'https://js-de.sentry-cdn.com/9cbeefde9ce7c0b959b51a4c5e6e52dd.min.js';
  script.crossOrigin = 'anonymous';
  script.async = true;
  
  script.onload = function() {
    // Log usando novo_log()
    window.novo_log('INFO', 'SENTRY', 'SDK do Sentry carregado com sucesso, inicializando...', null, 'INIT', 'MEDIUM');
    initializeSentry();
  };
  
  script.onerror = function() {
    // Não quebrar aplicação se script falhar ao carregar
    if (typeof window.novo_log === 'function') {
      window.novo_log('WARN', 'SENTRY', 'Falha ao carregar SDK do Sentry (não bloqueante)', null, 'INIT', 'SIMPLE');
    } else {
      console.warn('[SENTRY] Falha ao carregar SDK do Sentry');
    }
  };
  
  document.head.appendChild(script);
})();

// ======================
// TRATAMENTO DE ERRO GLOBAL (Recomendação do Engenheiro)
// ======================
(function() {
  'use strict';
  
  try {
    
    // ======================
    // CARREGAMENTO DE VARIÁVEIS DE AMBIENTE (DATA ATTRIBUTES)
    // ======================
    // Solução definitiva: ler variáveis do data attribute do próprio script tag
    // Elimina necessidade de carregamento assíncrono, polling e detecção complexa
    
    const currentScript = document.currentScript;
    
    // Função helper para ler data attribute e lançar erro se não estiver definido
    function getRequiredDataAttribute(script, attributeName, displayName) {
      const value = script && script.dataset ? script.dataset[attributeName] : null;
      if (value === null || value === undefined || value === '') {
        const errorMsg = `[CONFIG] ERRO CRÍTICO: ${displayName} não está definido no script tag (data-${attributeName})`;
        console.error(errorMsg);
        throw new Error(errorMsg);
      }
      return value;
    }
    
    // Função helper para ler data attribute boolean
    function getRequiredBooleanDataAttribute(script, attributeName, displayName) {
      const value = getRequiredDataAttribute(script, attributeName, displayName);
      return value === 'true' || value === '1' || value === true;
    }
    
    // Função helper para buscar em todos os scripts (fallback se currentScript não disponível)
    function findScriptWithAttributes() {
      const scripts = document.getElementsByTagName('script');
      for (let script of scripts) {
        if (script.src && script.src.includes('bssegurosimediato.com.br') && script.dataset) {
          return script;
        }
      }
      return null;
    }
    
    const scriptElement = currentScript || findScriptWithAttributes();
    
    if (!scriptElement || !scriptElement.dataset) {
      throw new Error('[CONFIG] ERRO CRÍTICO: Script tag não encontrado ou sem data attributes');
    }
    
    // Variáveis obrigatórias (sem fallbacks)
    // Variáveis injetadas pelo PHP (config_env.js.php) - OBRIGATÓRIAS
    // Estas variáveis devem ser carregadas ANTES deste script via config_env.js.php
    if (typeof window.APILAYER_KEY === 'undefined' || !window.APILAYER_KEY) {
        throw new Error('[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido. Carregue config_env.js.php ANTES deste script.');
    }
    if (typeof window.SAFETY_TICKET === 'undefined' || !window.SAFETY_TICKET) {
        throw new Error('[CONFIG] ERRO CRÍTICO: SAFETY_TICKET não está definido. Carregue config_env.js.php ANTES deste script.');
    }
    if (typeof window.SAFETY_API_KEY === 'undefined' || !window.SAFETY_API_KEY) {
        throw new Error('[CONFIG] ERRO CRÍTICO: SAFETY_API_KEY não está definido. Carregue config_env.js.php ANTES deste script.');
    }
    if (typeof window.VIACEP_BASE_URL === 'undefined' || !window.VIACEP_BASE_URL) {
        throw new Error('[CONFIG] ERRO CRÍTICO: VIACEP_BASE_URL não está definido. Carregue config_env.js.php ANTES deste script.');
    }
    if (typeof window.APILAYER_BASE_URL === 'undefined' || !window.APILAYER_BASE_URL) {
        throw new Error('[CONFIG] ERRO CRÍTICO: APILAYER_BASE_URL não está definido. Carregue config_env.js.php ANTES deste script.');
    }
    if (typeof window.SAFETYMAILS_OPTIN_BASE === 'undefined' || !window.SAFETYMAILS_OPTIN_BASE) {
        throw new Error('[CONFIG] ERRO CRÍTICO: SAFETYMAILS_OPTIN_BASE não está definido. Carregue config_env.js.php ANTES deste script.');
    }
    if (typeof window.RPA_API_BASE_URL === 'undefined' || !window.RPA_API_BASE_URL) {
        throw new Error('[CONFIG] ERRO CRÍTICO: RPA_API_BASE_URL não está definido. Carregue config_env.js.php ANTES deste script.');
    }
    // SAFETYMAILS_BASE_DOMAIN é opcional (tem fallback 'safetymails.com' na linha 1458)
    // Apenas garantir que está definida (pode ser string vazia, será tratada com fallback)
    if (typeof window.SAFETYMAILS_BASE_DOMAIN === 'undefined') {
        // Definir como string vazia se não estiver definida (fallback será usado quando necessário)
        window.SAFETYMAILS_BASE_DOMAIN = '';
    }
    
    // Atribuir variáveis do window (já validadas acima)
    // Nota: Estas variáveis já foram injetadas pelo config_env.js.php, apenas garantimos que estão disponíveis
    window.APILAYER_KEY = window.APILAYER_KEY;
    window.SAFETY_TICKET = window.SAFETY_TICKET;
    window.SAFETY_API_KEY = window.SAFETY_API_KEY;
    window.VIACEP_BASE_URL = window.VIACEP_BASE_URL;
    window.APILAYER_BASE_URL = window.APILAYER_BASE_URL;
    window.SAFETYMAILS_OPTIN_BASE = window.SAFETYMAILS_OPTIN_BASE;
    window.RPA_API_BASE_URL = window.RPA_API_BASE_URL;
    window.SAFETYMAILS_BASE_DOMAIN = window.SAFETYMAILS_BASE_DOMAIN;
    
    // Variáveis que permanecem via data-attributes (Webflow)
    window.APP_BASE_URL = getRequiredDataAttribute(scriptElement, 'appBaseUrl', 'APP_BASE_URL');
    window.APP_ENVIRONMENT = getRequiredDataAttribute(scriptElement, 'appEnvironment', 'APP_ENVIRONMENT');
    window.rpaEnabled = getRequiredBooleanDataAttribute(scriptElement, 'rpaEnabled', 'rpaEnabled');
    window.USE_PHONE_API = getRequiredBooleanDataAttribute(scriptElement, 'usePhoneApi', 'USE_PHONE_API');
    window.VALIDAR_PH3A = getRequiredBooleanDataAttribute(scriptElement, 'validarPh3a', 'VALIDAR_PH3A');
    window.SUCCESS_PAGE_URL = getRequiredDataAttribute(scriptElement, 'successPageUrl', 'SUCCESS_PAGE_URL');
    window.WHATSAPP_API_BASE = getRequiredDataAttribute(scriptElement, 'whatsappApiBase', 'WHATSAPP_API_BASE');
    window.WHATSAPP_PHONE = getRequiredDataAttribute(scriptElement, 'whatsappPhone', 'WHATSAPP_PHONE');
    window.WHATSAPP_DEFAULT_MESSAGE = getRequiredDataAttribute(scriptElement, 'whatsappDefaultMessage', 'WHATSAPP_DEFAULT_MESSAGE');
    
    // ======================
    // CONFIGURAÇÃO DE LOGGING (MOVIDA PARA O INÍCIO DO ARQUIVO)
    // ======================
    // A configuração de logging, sendLogToProfessionalSystem, novo_log() e log de carregamento
    // foram movidas para o início do arquivo (após window.versao) para garantir disponibilidade
    // antes de qualquer uso. Ver seção "CONFIGURAÇÃO DE LOGGING E FUNÇÕES CENTRALIZADAS" no início.
    
    // Verificar se novo_log() está disponível (deve estar, pois foi movido para o início)
    if (typeof window.novo_log !== 'function') {
      console.warn('[CONFIG] novo_log() não está disponível - sistema de logging pode não funcionar corretamente');
    }
    
    // Log de confirmação da configuração (apenas em dev) - usando novo_log se disponível
    if (window.LOG_CONFIG && window.LOG_CONFIG.environment === 'dev' && typeof window.novo_log === 'function') {
      window.novo_log('INFO', 'CONFIG', 'Configuração de logging carregada', window.LOG_CONFIG);
    }
    
    // Código removido - movido para o início do arquivo (após window.versao)
    // Ver seção "CONFIGURAÇÃO DE LOGGING E FUNÇÕES CENTRALIZADAS" no início do arquivo
    
    // ======================
    // FIM DA CONFIGURAÇÃO DE LOGGING (MOVIDA PARA O INÍCIO)
    // ======================
    
    // ======================
    // FUNÇÃO DE LOG CLASSIFICADO (NOVO SISTEMA)
    // Movida para antes de sua primeira chamada (FASE 2 - Correção CRÍTICA)
    // ======================
    
    /**
     * Função para logs classificados com controle granular via DEBUG_CONFIG
     * @param {string} level - 'CRITICAL' | 'ERROR' | 'WARN' | 'INFO' | 'DEBUG' | 'TRACE'
     * @param {string} category - Categoria do log (ex: 'EMAIL_DEBUG', 'JSON_DEBUG', 'CONFIG')
     * @param {string} message - Mensagem do log
     * @param {object} data - Dados opcionais
     * @param {string} context - Contexto: 'INIT' | 'OPERATION' | 'ERROR_HANDLING' | 'PERFORMANCE' | 'DATA_FLOW' | 'UI'
     * @param {string} verbosity - Verbosidade: 'SIMPLE' | 'MEDIUM' | 'VERBOSE'
     */
    /**
     * @deprecated Use window.novo_log() ao invés desta função.
     * Esta função será removida em versões futuras.
     * Mantida apenas por compatibilidade temporária.
     */
    
    // ======================
    // FIM DA FUNÇÃO DE LOG CLASSIFICADO
    // ======================
    
    // Validar que APP_BASE_URL foi definido
    if (!window.APP_BASE_URL) {
      novo_log('CRITICAL', 'CONFIG', 'data-app-base-url não está definido no script tag', null, 'INIT', 'SIMPLE');
      novo_log('CRITICAL', 'CONFIG', 'Adicione data-app-base-url e data-app-environment ao script tag no Webflow Footer Code', null, 'INIT', 'SIMPLE');
      throw new Error('APP_BASE_URL não está definido - verifique data-app-base-url no script tag');
    }
    
    // Log de confirmação (controlado via DEBUG_CONFIG)
    novo_log('INFO', 'CONFIG', 'Variáveis de ambiente carregadas', {
      APP_BASE_URL: window.APP_BASE_URL,
      APP_ENVIRONMENT: window.APP_ENVIRONMENT
    }, 'INIT', 'MEDIUM');
    
    // ======================
    // CONSTANTES DE ENDPOINTS E URLs (FASE 3 - Correção ALTA)
    // ======================
    // Todas as URLs e endpoints devem ser configuráveis via variáveis de ambiente
    // Fallback para valores padrão se não estiverem configurados
    
    // APIs Externas (usando variáveis de ambiente - sem fallbacks)
    // Todas as variáveis devem estar definidas via data attributes
    const VIACEP_BASE_URL = window.VIACEP_BASE_URL;
    const APILAYER_BASE_URL = window.APILAYER_BASE_URL;
    // SAFETYMAILS_BASE_DOMAIN pode ser derivado de SAFETYMAILS_OPTIN_BASE se necessário
    // SAFETYMAILS_BASE_DOMAIN agora vem do config_env.js.php (definida acima)
    // SAFETYMAILS_BASE_DOMAIN é opcional (tem fallback 'safetymails.com' na linha 1458)
    const SAFETYMAILS_BASE_DOMAIN = window.SAFETYMAILS_BASE_DOMAIN || 'safetymails.com';
    // WhatsApp - valores não críticos, manter fallbacks por enquanto
    // Variáveis WHATSAPP agora vêm de data-attributes (definidas acima)
    const WHATSAPP_API_BASE = window.WHATSAPP_API_BASE;
    const WHATSAPP_PHONE = window.WHATSAPP_PHONE;
    const WHATSAPP_DEFAULT_MESSAGE = window.WHATSAPP_DEFAULT_MESSAGE;
    
    // Validação fail-fast
    if (!WHATSAPP_API_BASE) throw new Error('[CONFIG] ERRO CRÍTICO: WHATSAPP_API_BASE não está definido.');
    if (!WHATSAPP_PHONE) throw new Error('[CONFIG] ERRO CRÍTICO: WHATSAPP_PHONE não está definido.');
    if (!WHATSAPP_DEFAULT_MESSAGE) throw new Error('[CONFIG] ERRO CRÍTICO: WHATSAPP_DEFAULT_MESSAGE não está definido.');
    
    // Endpoints Internos (usar APP_BASE_URL diretamente - não criar constantes)
    
    // ======================
    // FIM DAS CONSTANTES DE ENDPOINTS
    // ======================
    
    // ======================
    // PARTE 1: FOOTER CODE UTILS (sem modificações)
    // ======================
// ====================== 
// 🛠️ FOOTER CODE UTILS - Funções Utilitárias
// Versão: 2.0 | Data: 2025-10-30
// Atualizado: Adicionadas funções de validação de API e loading
(function() {
  'use strict';
  
  // ======================
  // CONSTANTES GLOBAIS (definir ANTES de qualquer uso)
  // ======================
  // ✅ Variáveis agora são lidas de data attributes no início do script
  // ✅ Nenhum valor hardcoded - todas as variáveis vêm de variáveis de ambiente
  // ✅ Erros são lançados se variáveis não estiverem definidas
  // ======================
  
  // ======================
  // SISTEMA DE CONTROLE DE LOGS
  // ======================
  // Controle global de logs - alterar conforme necessário
  // ⚠️ IMPORTANTE: Usar || para NÃO sobrescrever se já existir (definido no Webflow Footer Code)
  window.DEBUG_CONFIG = window.DEBUG_CONFIG || {
    // Nível global: 'none' | 'error' | 'warn' | 'info' | 'debug' | 'all'
    level: 'info',
    
    // Habilitar/desabilitar logs completamente
    enabled: true,
    
    // Categorias a ignorar (array vazio = nenhuma ignorada)
    exclude: [], // Exemplo: ['DEBUG'] = ignora esta categoria
    
    // Ambiente (auto-detectado uma vez, depois cached)
    environment: 'auto' // 'auto' | 'dev' | 'prod'
  };

  // ======================
  // NÍVEIS DE AJUSTE DISPONÍVEIS
  // ======================
  // 
  // Hierarquia de níveis (ordem crescente de verbosidade):
  // 
  // 1. 'none' (Prioridade: 0)
  //    - Nenhum log é exibido
  //    - Uso: Desativar completamente todos os logs
  //    - Exemplo: window.DEBUG_CONFIG.level = 'none';
  // 
  // 2. 'error' (Prioridade: 1)
  //    - Apenas logs de erro (logError)
  //    - Uso: Produção com foco em erros críticos
  //    - Exemplo: window.DEBUG_CONFIG.level = 'error';
  // 
  // 3. 'warn' (Prioridade: 2)
  //    - Erros + Avisos (logError + logWarn)
  //    - Uso: Produção com alertas importantes
  //    - Exemplo: window.DEBUG_CONFIG.level = 'warn';
  // 
  // 4. 'info' (Prioridade: 3) ⭐ PADRÃO
  //    - Erros + Avisos + Informações (logError + logWarn + logInfo)
  //    - Uso: Desenvolvimento e produção balanceada (RECOMENDADO)
  //    - Exemplo: window.DEBUG_CONFIG.level = 'info';
  // 
  // 5. 'debug' (Prioridade: 4)
  //    - Todos os logs, incluindo debug (exceto logs internos preservados)
  //    - Uso: Depuração detalhada em desenvolvimento
  //    - Exemplo: window.DEBUG_CONFIG.level = 'debug';
  // 
  // 6. 'all' (Prioridade: 5)
  //    - Todos os logs disponíveis (máximo detalhamento)
  //    - Uso: Análise profunda e troubleshooting
  //    - Exemplo: window.DEBUG_CONFIG.level = 'all';
  // 
  // REGRA DE HIERARQUIA:
  // - Ao escolher um nível, todos os níveis abaixo dele também são exibidos
  // - Exemplo: 'info' exibe error + warn + info
  // 
  // OUTRAS CONFIGURAÇÕES:
  // 
  // enabled: true/false
  //    - Controla se o sistema de logs está ativo
  //    - Se false, nenhum log é exibido, independente do nível
  //    - Exemplo: window.DEBUG_CONFIG.enabled = false;
  // 
  // exclude: ['CATEGORIA1', 'CATEGORIA2']
  //    - Ignora logs de categorias específicas
  //    - Categorias disponíveis: 'UTILS', 'GCLID', 'MODAL', 'FOOTER', 
  //      'RPA', 'GTM', 'DEBUG', 'UNIFIED', etc.
  //    - Exemplo: window.DEBUG_CONFIG.exclude = ['DEBUG', 'RPA'];
  // 
  // environment: 'auto' | 'dev' | 'prod'
  //    - 'auto': Detecta automaticamente pelo hostname (recomendado)
  //    - 'dev': Força ambiente de desenvolvimento
  //    - 'prod': Força ambiente de produção
  //    - Em 'prod' sem nível definido, usa 'error' automaticamente
  //    - Exemplo: window.DEBUG_CONFIG.environment = 'prod';
  // 
  // EXEMPLOS PRÁTICOS:
  // 
  // Produção (apenas erros):
  //   window.DEBUG_CONFIG.level = 'error';
  //   window.DEBUG_CONFIG.environment = 'prod';
  // 
  // Desenvolvimento (todos os logs):
  //   window.DEBUG_CONFIG.level = 'all';
  //   window.DEBUG_CONFIG.environment = 'dev';
  // 
  // Desabilitar completamente:
  //   window.DEBUG_CONFIG.enabled = false;
  //   // OU
  //   window.DEBUG_CONFIG.level = 'none';
  // 
  // Ignorar categorias específicas:
  //   window.DEBUG_CONFIG.exclude = ['DEBUG', 'RPA'];
  // 
  // ======================

  // Cache para ambiente detectado (otimização de performance)
  let _envCache = null;

  // ======================
  // SISTEMA DE LOGGING PROFISSIONAL
  // ======================
  
  /**
   * Captura informações do arquivo e linha que chamou a função de log
   * @returns {Object} {file_name, file_path, line_number, function_name}
   */
  function getCallerInfo() {
    try {
      const stack = new Error().stack;
      if (!stack) return { file_name: 'unknown', line_number: null, function_name: null };
      
      const stackLines = stack.split('\n');
      
      // Ignorar:
      // - linha 0: "Error"
      // - linha 1: getCallerInfo()
      // - linha 2: sendLogToProfessionalSystem()
      // - linha 3: window.logUnified()
      // Procurar a partir da linha 4 (primeira chamada real)
      
      for (let i = 4; i < stackLines.length; i++) {
        const line = stackLines[i].trim();
        
        // Padrão 1: "at functionName (file.js:123:45)"
        let match = line.match(/at\s+(?:\w+\.)?(\w+)\s+\(([^:]+):(\d+):(\d+)\)/);
        if (match) {
          const filePath = match[2];
          const fileName = filePath.split('/').pop().split('\\').pop();
          return {
            file_name: fileName,
            file_path: filePath,
            line_number: parseInt(match[3]),
            function_name: match[1]
          };
        }
        
        // Padrão 2: "at file.js:123:45"
        match = line.match(/at\s+([^:]+):(\d+):(\d+)/);
        if (match) {
          const filePath = match[1];
          const fileName = filePath.split('/').pop().split('\\').pop();
          return {
            file_name: fileName,
            file_path: filePath,
            line_number: parseInt(match[2]),
            function_name: null
          };
        }
      }
    } catch (e) {
      // Silenciosamente ignorar erros de captura
    }
    
    return {
      file_name: 'unknown',
      file_path: null,
      line_number: null,
      function_name: null
    };
  }
  
  // ======================
  // FUNÇÕES sendLogToProfessionalSystem() E novo_log() REMOVIDAS - MOVIDAS PARA O INÍCIO (FASE 0)
  // Ver linhas 296-605 para definições atuais
  // ======================
  
  // ======================
  // ALIASES PARA COMPATIBILIDADE (DEFINIDOS ANTES DE QUALQUER USO)
  // ======================
  // ⚠️ CRÍTICO: Estas funções devem ser definidas ANTES de serem chamadas
  // Elas são usadas em várias partes do código e devem estar disponíveis imediatamente
  
  
  // ======================
  
  window.novo_log('INFO', 'UTILS', '🔄 Carregando Footer Code Utils...', null, 'OPERATION', 'SIMPLE');
  
  // ========= MANIPULAÇÃO DE DADOS =========
  
  /**
   * Extrai apenas dígitos de uma string
   * @param {string} s - String a processar
   * @returns {string} String contendo apenas dígitos
   */
  function onlyDigits(s) {
    return (s || '').replace(/\D+/g, '');
  }
  
  /**
   * Converte para maiúsculas e remove espaços
   * @param {string} s - String a processar
   * @returns {string} String em maiúsculas sem espaços
   */
  function toUpperNospace(s) {
    return (s || '').toUpperCase().trim();
  }
  
  /**
   * Define valor em campo do formulário
   * @param {string} id - ID ou nome do campo
   * @param {string} val - Valor a definir
   */
  function setFieldValue(id, val) {
    var $f = $('#' + id + ', [name="' + id + '"]');
    if ($f.length) {
      $f.val(val).trigger('input').trigger('change');
    }
  }
  
  /**
   * Lê valor de cookie pelo nome
   * @param {string} name - Nome do cookie
   * @returns {string|null} Valor do cookie ou null
   */
  function readCookie(name) {
    var n = name + "=", cookie = document.cookie.split(';');
    for (var i = 0; i < cookie.length; i++) {
      var c = cookie[i].trim();
      if (c.indexOf(n) === 0) return c.substring(n.length);
    }
    return null;
  }
  
  /**
   * Gera ID único de sessão
   * @returns {string} ID de sessão
   */
  function generateSessionId() {
    if (!window.sessionId) {
      window.sessionId = 'sess_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }
    return window.sessionId;
  }
  
  /**
   * Submete formulário de forma nativa
   * @param {jQuery} $form - Objeto jQuery do formulário
   */
  function nativeSubmit($form) {
    var f = $form.get(0);
    if (!f) return;
    (typeof f.requestSubmit === 'function') ? f.requestSubmit() : f.submit();
  }
  
  // ========= VALIDAÇÃO LOCAL =========
  
  /**
   * Valida formato de email via regex
   * @param {string} v - Email a validar
   * @returns {boolean} true se válido
   */
  function validarEmailLocal(v) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/i.test((v || '').trim());
  }
  
  /**
   * Valida formato básico do CPF
   * @param {string} cpf - CPF a validar
   * @returns {boolean} true se formato válido
   */
  function validarCPFFormato(cpf) {
    const cpfLimpo = onlyDigits(cpf);
    return cpfLimpo.length === 11 && !/^(\d)\1{10}$/.test(cpfLimpo);
  }
  
  /**
   * Valida CPF usando algoritmo de dígitos verificadores
   * @param {string} cpf - CPF a validar
   * @returns {boolean} true se válido
   */
  function validarCPFAlgoritmo(cpf) {
    cpf = onlyDigits(cpf);
    if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) return false;
    
    let soma = 0, resto = 0;
    for (let i = 1; i <= 9; i++) {
      soma += parseInt(cpf[i-1], 10) * (11 - i);
    }
    resto = (soma * 10) % 11;
    if (resto === 10 || resto === 11) resto = 0;
    if (resto !== parseInt(cpf[9], 10)) return false;
    
    soma = 0;
    for (let i = 1; i <= 10; i++) {
      soma += parseInt(cpf[i-1], 10) * (12 - i);
    }
    resto = (soma * 10) % 11;
    if (resto === 10 || resto === 11) resto = 0;
    return resto === parseInt(cpf[10], 10);
  }
  
  /**
   * Valida formato de placa (antigo ou Mercosul)
   * @param {string} p - Placa a validar
   * @returns {boolean} true se formato válido
   */
  function validarPlacaFormato(p) {
    const placaLimpa = p.toUpperCase().replace(/[^A-Z0-9]/g, '');
    const antigo = /^[A-Z]{3}[0-9]{4}$/;
    const mercosul = /^[A-Z]{3}[0-9][A-Z][0-9]{2}$/;
    return antigo.test(placaLimpa) || mercosul.test(placaLimpa);
  }
  
  /**
   * Valida formato local de celular (DDD + número)
   * @param {string} ddd - DDD
   * @param {string} numero - Número do celular
   * @returns {Object} {ok: boolean, reason?: string, national?: string}
   */
  function validarCelularLocal(ddd, numero) {
    const d = onlyDigits(ddd), n = onlyDigits(numero);
    if (d.length !== 2) return {ok: false, reason: 'ddd'};
    if (n.length !== 9) return {ok: false, reason: 'len'};
    if (n[0] !== '9') return {ok: false, reason: 'pattern'};
    return {ok: true, national: d + n};
  }
  
  /**
   * Aplica máscara jQuery Mask em campo de placa
   * @param {jQuery} $i - Objeto jQuery do campo
   */
  function aplicarMascaraPlaca($i) {
    const t = {'S': {pattern: /[A-Za-z]/}, '0': {pattern: /\d/}, 'A': {pattern: /[A-Za-z0-9]/}};
    $i.on('input', function() {
      this.value = this.value.toUpperCase();
    });
    $i.mask('SSS-0A00', {translation: t, clearIfNotMatch: false});
  }
  
  // ========= CRIPTOGRAFIA =========
  
  /**
   * Gera hash SHA-1 de texto
   * @param {string} text - Texto a processar
   * @returns {Promise<string>} Hash SHA-1 em hexadecimal
   */
  async function sha1(text) {
    const encoder = new TextEncoder();
    const data = encoder.encode(text);
    const hashBuffer = await crypto.subtle.digest("SHA-1", data);
    return [...new Uint8Array(hashBuffer)]
      .map(byte => byte.toString(16).padStart(2, "0"))
      .join("");
  }
  
  /**
   * Gera assinatura HMAC SHA-256
   * @param {string} value - Valor a assinar
   * @param {string} key - Chave secreta
   * @returns {Promise<string>} Assinatura HMAC em hexadecimal
   */
  async function hmacSHA256(value, key) {
    const encoder = new TextEncoder();
    const keyData = encoder.encode(key);
    const valueData = encoder.encode(value);

    const cryptoKey = await crypto.subtle.importKey(
      "raw", keyData, { name: "HMAC", hash: { name: "SHA-256" } }, false, ["sign"]
    );
    const signature = await crypto.subtle.sign("HMAC", cryptoKey, valueData);
    return [...new Uint8Array(signature)]
      .map(byte => byte.toString(16).padStart(2, "0"))
      .join("");
  }
  
  // ========= EXTRAÇÃO/TRANSFORMAÇÃO DE DADOS =========
  
  /**
   * Extrai e formata dados do CPF da API PH3A
   * @param {Object} apiJson - Resposta JSON da API PH3A
   * @returns {Object} {sexo, dataNascimento, estadoCivil}
   */
  function extractDataFromPH3A(apiJson) {
    const data = apiJson && apiJson.data;
    if (!data || typeof data !== 'object') {
      return {
        sexo: '',
        dataNascimento: '',
        estadoCivil: ''
      };
    }
    
    // Mapear sexo
    let sexo = '';
    if (data.sexo !== undefined) {
      switch (data.sexo) {
        case 1: sexo = 'Masculino'; break;
        case 2: sexo = 'Feminino'; break;
        default: sexo = ''; break;
      }
    }
    
    // Mapear estado civil
    let estadoCivil = '';
    if (data.estado_civil !== undefined) {
      switch (data.estado_civil) {
        case 0: estadoCivil = 'Solteiro'; break;
        case 1: estadoCivil = 'Casado'; break;
        case 2: estadoCivil = 'Divorciado'; break;
        case 3: estadoCivil = 'Viúvo'; break;
        default: estadoCivil = ''; break;
      }
    }
    
    // Formatar data de nascimento (de ISO para DD/MM/YYYY)
    let dataNascimento = '';
    if (data.data_nascimento) {
      try {
        const date = new Date(data.data_nascimento);
        if (!isNaN(date.getTime())) {
          const day = String(date.getDate()).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          dataNascimento = `${day}/${month}/${year}`;
        }
      } catch (e) {
        dataNascimento = data.data_nascimento;
      }
    }
    
    return {
      sexo: sexo,
      dataNascimento: dataNascimento,
      estadoCivil: estadoCivil
    };
  }
  
  /**
   * Preenche campos de endereço com dados do ViaCEP
   * @param {Object} data - Dados do ViaCEP
   */
  function preencherEnderecoViaCEP(data) {
    setFieldValue('CIDADE', data.localidade || '');
    setFieldValue('ESTADO', data.uf || '');
  }
  
  /**
   * Extrai dados do veículo da API Placa Fipe
   * @param {Object} apiJson - Resposta JSON da API Placa Fipe
   * @returns {Object} {marcaTxt, anoModelo, tipoVeiculo}
   */
  function extractVehicleFromPlacaFipe(apiJson) {
    const r = apiJson && (apiJson.informacoes_veiculo || apiJson);
    if (!r || typeof r !== 'object') return {marcaTxt: '', anoModelo: '', tipoVeiculo: ''};
    
    // Extrair dados da API Placa Fipe
    const fabricante = r.marca || '';
    const modelo = r.modelo || '';
    const anoMod = r.ano || r.ano_modelo || '';
    
    // Determinar tipo de veículo baseado no segmento
    let tipoVeiculo = '';
    if (r.segmento) {
      const segmento = r.segmento.toLowerCase();
      if (segmento.includes('moto')) {
        tipoVeiculo = 'moto';
      } else if (segmento.includes('auto')) {
        tipoVeiculo = 'carro';
      } else {
        // Fallback baseado em marcas conhecidas
        const modeloLower = modelo.toLowerCase();
        const marcaLower = fabricante.toLowerCase();
        
        if (marcaLower.includes('honda') || marcaLower.includes('yamaha') || 
            marcaLower.includes('suzuki') || marcaLower.includes('kawasaki') ||
            modeloLower.includes('cg') || modeloLower.includes('cb') || 
            modeloLower.includes('fazer') || modeloLower.includes('ninja')) {
          tipoVeiculo = 'moto';
        } else {
          tipoVeiculo = 'carro';
        }
      }
    } else {
      // Fallback baseado em marcas conhecidas
      const modeloLower = modelo.toLowerCase();
      const marcaLower = fabricante.toLowerCase();
      
      if (marcaLower.includes('honda') || marcaLower.includes('yamaha') || 
          marcaLower.includes('suzuki') || marcaLower.includes('kawasaki') ||
          modeloLower.includes('cg') || modeloLower.includes('cb') || 
          modeloLower.includes('fazer') || modeloLower.includes('ninja')) {
        tipoVeiculo = 'moto';
      } else {
        tipoVeiculo = 'carro';
      }
    }
    
    return { 
      marcaTxt: [fabricante, modelo].filter(Boolean).join(' / '), 
      anoModelo: onlyDigits(String(anoMod)).slice(0, 4),
      tipoVeiculo: tipoVeiculo
    };
  }
  
  // ========= VALIDAÇÃO API =========
  
  /**
   * Valida CPF via API PH3A
   * @param {string} cpf - CPF a validar
   * @returns {Promise<Object>} {ok: boolean, reason?: string, parsed?: Object}
   */
  function validarCPFApi(cpf) {
    if (typeof window.onlyDigits !== 'function' || typeof window.validarCPFFormato !== 'function' || typeof window.validarCPFAlgoritmo !== 'function') {
      window.novo_log('ERROR', 'UTILS', '❌ Funções de CPF não disponíveis', null, 'ERROR_HANDLING', 'SIMPLE');
      return Promise.resolve({ok: false, reason: 'erro_utils'});
    }
    
    const cpfLimpo = window.onlyDigits(cpf);
    
    // Primeiro validar formato e algoritmo
    if (!window.validarCPFFormato(cpfLimpo) || !window.validarCPFAlgoritmo(cpfLimpo)) {
      return Promise.resolve({
        ok: false, 
        reason: 'formato'
      });
    }
    
    // Verificar se VALIDAR_PH3A está habilitado
    if (typeof window.VALIDAR_PH3A === 'undefined') {
      window.novo_log('WARN', 'UTILS', '⚠️ VALIDAR_PH3A não disponível, assumindo false', null, 'ERROR_HANDLING', 'SIMPLE');
    }
    
    // Se não deve validar via API, retornar apenas validação local
    if (window.VALIDAR_PH3A === false || typeof window.VALIDAR_PH3A === 'undefined') {
      return Promise.resolve({
        ok: true,
        reason: 'ok'
      });
    }
    
    // Consultar API PH3A via proxy
    if (!window.APP_BASE_URL) {
      return Promise.reject(new Error('APP_BASE_URL não disponível para validação de CPF'));
    }
    const cpfUrl = window.APP_BASE_URL + '/cpf-validate.php';
    return fetch(cpfUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        cpf: cpfLimpo
      })
    })
    .then(r => r.json())
    .then(j => {
      const ok = !!j && (j.codigo === 1 || j.success === true);
      return {
        ok, 
        reason: ok ? 'ok' : 'nao_encontrado', 
        parsed: ok && typeof window.extractDataFromPH3A === 'function' ? window.extractDataFromPH3A(j) : {
          sexo: '',
          dataNascimento: '',
          estadoCivil: ''
        }
      };
    })
    .catch(_ => ({
      ok: false, 
      reason: 'erro_api'
    }));
  }
  
  /**
   * Valida CEP via ViaCEP
   * @param {string} cep - CEP a validar
   * @returns {Promise<Object>} {ok: boolean, reason?: string, viacep?: Object}
   */
  function validarCepViaCep(cep) {
    if (typeof window.onlyDigits !== 'function') {
      window.novo_log('ERROR','UTILS', '❌ onlyDigits não disponível');
      return Promise.resolve({ok: false, reason: 'erro_utils'});
    }
    cep = window.onlyDigits(cep);
    if (cep.length !== 8) return Promise.resolve({ok: false, reason: 'formato'});
    return fetch(`${VIACEP_BASE_URL}/ws/${cep}/json/`)
      .then(r => r.json())
      .then(d => ({ok: !d?.erro, reason: d?.erro ? 'nao_encontrado' : 'ok', viacep: d}))
      .catch(_ => ({ok: false, reason: 'erro_api'}));
  }
  
  /**
   * Valida placa via API Placa Fipe
   * @param {string} placa - Placa a validar
   * @returns {Promise<Object>} {ok: boolean, reason?: string, parsed?: Object}
   */
  function validarPlacaApi(placa) {
    if (typeof window.validarPlacaFormato !== 'function') {
      window.novo_log('ERROR','UTILS', '❌ validarPlacaFormato não disponível');
      return Promise.resolve({ok: false, reason: 'erro_utils'});
    }
    const raw = placa.toUpperCase().replace(/[^A-Z0-9]/g, '');
    if (!window.validarPlacaFormato(raw)) return Promise.resolve({ok: false, reason: 'formato'});
    
    if (!window.APP_BASE_URL) {
      return Promise.reject(new Error('APP_BASE_URL não disponível para validação de placa'));
    }
    const placaUrl = window.APP_BASE_URL + '/placa-validate.php';
    return fetch(placaUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        placa: raw
      })
    })
      .then(r => r.json())
      .then(j => {
        const ok = !!j && (j.codigo === 1 || j.success === true);
        return {
          ok, 
          reason: ok ? 'ok' : 'nao_encontrada', 
          parsed: ok && typeof window.extractVehicleFromPlacaFipe === 'function' ? window.extractVehicleFromPlacaFipe(j) : {marcaTxt: '', anoModelo: '', tipoVeiculo: ''}
        };
      })
      .catch(_ => ({ok: false, reason: 'erro_api'}));
  }
  
  /**
   * Valida celular via API Layer
   * @param {string} nat - Número nacional (DDD + número)
   * @returns {Promise<Object>} {ok: boolean}
   */
  function validarCelularApi(nat) {
    if (typeof window.APILAYER_KEY === 'undefined') {
      window.novo_log('WARN','UTILS', '⚠️ APILAYER_KEY não disponível, usando fallback');
      return Promise.resolve({ok: true}); // fallback - falha externa não bloqueia
    }
    return fetch(`${APILAYER_BASE_URL}/api/validate?access_key=${window.APILAYER_KEY}&country_code=BR&number=${nat}`)
      .then(r => r.json())
      .then(j => ({ok: !!j?.valid}))
      .catch(_ => ({ok: true})); // falha externa não bloqueia
  }
  
  /**
   * Valida telefone completo (DDD + Celular)
   * @param {jQuery} $DDD - Objeto jQuery do campo DDD
   * @param {jQuery} $CEL - Objeto jQuery do campo Celular
   * @returns {Promise<Object>} {ok: boolean, reason?: string}
   */
  function validarTelefoneAsync($DDD, $CEL) {
    if (typeof window.validarCelularLocal !== 'function') {
      window.novo_log('ERROR','UTILS', '❌ validarCelularLocal não disponível');
      return Promise.resolve({ok: false, reason: 'erro_utils'});
    }
    const local = window.validarCelularLocal($DDD.val(), $CEL.val());
    if (!local.ok) return Promise.resolve({ok: false, reason: local.reason});
    
    if (typeof window.USE_PHONE_API === 'undefined') {
      window.novo_log('WARN','UTILS', '⚠️ USE_PHONE_API não disponível, assumindo false');
      return Promise.resolve({ok: true});
    }
    
    if (!window.USE_PHONE_API) return Promise.resolve({ok: true});
    return validarCelularApi(local.national).then(api => ({ok: api.ok}));
  }
  
  /**
   * Valida email via SafetyMails
   * @param {string} email - Email a validar
   * @returns {Promise<Object|null>} Resposta da API ou null
   */
  async function validarEmailSafetyMails(email) {
    // LOG 1: Início da função
    window.novo_log('INFO', 'SAFETYMAILS', '🔍 Iniciando validação SafetyMails', { email: email }, 'OPERATION', 'SIMPLE');
    
    try {
      // Verificar funções necessárias
      if (typeof window.sha1 !== 'function' || typeof window.hmacSHA256 !== 'function') {
        window.novo_log('ERROR','SAFETYMAILS', '❌ sha1 ou hmacSHA256 não disponíveis');
        return null;
      }
      
      // Verificar credenciais
      if (typeof window.SAFETY_TICKET === 'undefined' || typeof window.SAFETY_API_KEY === 'undefined') {
        window.novo_log('WARN','SAFETYMAILS', '⚠️ SAFETY_TICKET ou SAFETY_API_KEY não disponíveis');
        return null;
      }
      
      // LOG 2: Credenciais disponíveis
      window.novo_log('INFO', 'SAFETYMAILS', '✅ Credenciais disponíveis', {
        SAFETY_TICKET: window.SAFETY_TICKET ? `${window.SAFETY_TICKET.substring(0, 8)}...` : 'undefined',
        SAFETY_API_KEY: window.SAFETY_API_KEY ? `${window.SAFETY_API_KEY.substring(0, 8)}...` : 'undefined'
      }, 'OPERATION', 'SIMPLE');
      
      // Construir URL e HMAC
      const code = await window.sha1(window.SAFETY_TICKET);
      const SAFETYMAILS_BASE_DOMAIN = window.SAFETYMAILS_BASE_DOMAIN || 'safetymails.com';
      const url = `https://${window.SAFETY_TICKET}.${SAFETYMAILS_BASE_DOMAIN}/api/${code}`;
      const hmac = await window.hmacSHA256(email, window.SAFETY_API_KEY);

      // LOG 3: URL e dados preparados
      window.novo_log('INFO', 'SAFETYMAILS', '📤 Preparando requisição', {
        url: url,
        email: email,
        hmac: hmac ? `${hmac.substring(0, 16)}...` : 'null',
        code: code ? `${code.substring(0, 16)}...` : 'null'
      }, 'OPERATION', 'SIMPLE');

      // Preparar FormData
      let form = new FormData();
      form.append('email', email);

      // LOG 4: Dados enviados
window.novo_log('INFO', 'SAFETYMAILS', '📨 Enviando requisição', {
        method: 'POST',
        url: url,
        headers: {
          'Sf-Hmac': hmac ? `${hmac.substring(0, 16)}...` : 'null'
        },
        body: {
          email: email
        }
      }, 'OPERATION', 'SIMPLE');

      // Fazer requisição
      const response = await fetch(url, {
        method: "POST",
        headers: { "Sf-Hmac": hmac },
        body: form
      });
      
      // LOG 5: Resposta HTTP recebida
window.novo_log('INFO', 'SAFETYMAILS', '📥 Resposta HTTP recebida', {
        status: response.status,
        statusText: response.statusText,
        ok: response.ok,
        headers: Object.fromEntries(response.headers.entries())
      }, 'OPERATION', 'SIMPLE');
      
      if (!response.ok) {
        // LOG 6: Erro HTTP
        window.novo_log('ERROR','SAFETYMAILS', `❌ SafetyMails HTTP Error: ${response.status}`, {
          status: response.status,
          statusText: response.statusText,
          url: url,
          email: email
        });
        
        // Tentar ler corpo da resposta para mais detalhes
        try {
          const errorText = await response.text();
window.novo_log('ERROR', 'SAFETYMAILS', '📄 Corpo da resposta de erro', {
            errorText: errorText.substring(0, 500) // Limitar tamanho
          }, 'ERROR_HANDLING', 'SIMPLE');
        } catch (e) {
          window.novo_log('WARN','SAFETYMAILS', '⚠️ Não foi possível ler corpo da resposta de erro');
        }
        
        return null;
      }
      
      // Ler dados da resposta
      let data;
      try {
        data = await response.json();
      } catch (e) {
window.novo_log('ERROR', 'SAFETYMAILS', '❌ Erro ao parsear resposta JSON', {
          error: e.message,
          email: email
        }, 'ERROR_HANDLING', 'SIMPLE');
        return null;
      }
      
      // LOG 7: Dados recebidos da API (com todos os campos disponíveis)
window.novo_log('INFO', 'SAFETYMAILS', '📥 Dados recebidos da API', {
        success: data?.Success,
        status: data?.Status,
        domainStatus: data?.DomainStatus,
        advice: data?.Advice,
        idStatus: data?.IdStatus,
        idAdvice: data?.IdAdvice,
        email: data?.Email,
        balance: data?.Balance,
        environment: data?.Environment,
        method: data?.Method,
        limited: data?.Limited,
        public: data?.Public,
        mx: data?.Mx,
        referer: data?.Referer,
        data: data // Log completo dos dados
      }, 'OPERATION', 'SIMPLE');
      
      // LOG 8: Verificar Success primeiro (antes de calcular isValid)
      // ⚠️ IMPORTANTE: Success: true não significa email válido!
      // Mas se Success: false, a requisição falhou e não devemos continuar
      if (!data || !data.Success) {
window.novo_log('WARN', 'SAFETYMAILS', '⚠️ Requisição não foi bem-sucedida', {
          email: email,
          success: data?.Success,
          status: data?.Status,
          domainStatus: data?.DomainStatus,
          advice: data?.Advice,
          balance: data?.Balance,
          environment: data?.Environment,
          data: data
        }, 'ERROR_HANDLING', 'SIMPLE');
        return null;
      }
      
      // LOG 9: Análise detalhada da validação (só se Success é true)
      // Validação baseada em múltiplos indicadores conforme documentação SafetyMails
      const status = data.Status || '';
      const domainStatus = data.DomainStatus || '';
      const advice = data.Advice || '';
      const idStatus = data.IdStatus;
      const idAdvice = data.IdAdvice;
      
      // Indicadores de validade (conforme REFERENCIA_API_SAFETYMAILS.md)
      const isValid = status === 'VALIDO';
      const isDomainValid = domainStatus === 'VALIDO';
      const isAdviceValid = advice === 'Valid';
      const isValidIdStatus = idStatus === 9000;
      const isValidIdAdvice = idAdvice === 5200;
      
      // Análise de status pendente/desconhecido
      const isPending = status === 'PENDENTE' || domainStatus === 'UNKNOWN' || advice === 'Unknown';
      const isInvalid = status === 'INVALIDO' || domainStatus === 'INVALIDO' || advice === 'Invalid';
      
      // Informações adicionais da resposta
      const balance = data.Balance;
      const environment = data.Environment || 'UNKNOWN';
      const method = data.Method || 'UNKNOWN';
      const limited = data.Limited === true;
      const isPublic = data.Public === true;
      const mxRecords = data.Mx || '';
      
window.novo_log('INFO', 'SAFETYMAILS', '🔍 Análise detalhada da validação', {
        email: email,
        success: data.Success,
        // Campos principais
        status: status,
        domainStatus: domainStatus,
        advice: advice,
        idStatus: idStatus,
        idAdvice: idAdvice,
        // Indicadores calculados
        isValid: isValid,
        isDomainValid: isDomainValid,
        isAdviceValid: isAdviceValid,
        isValidIdStatus: isValidIdStatus,
        isValidIdAdvice: isValidIdAdvice,
        isPending: isPending,
        isInvalid: isInvalid,
        // Informações adicionais
        balance: balance,
        environment: environment,
        method: method,
        limited: limited,
        public: isPublic,
        mxRecords: mxRecords ? `${mxRecords.substring(0, 50)}...` : 'N/A',
        // Conclusão
        conclusao: isValid ? 'EMAIL VÁLIDO' : (isPending ? 'EMAIL PENDENTE/DESCONHECIDO' : 'EMAIL NÃO VÁLIDO')
      }, 'OPERATION', 'SIMPLE');
      
      // LOG 10: Verificação de saldo e limitações
      if (balance !== undefined) {
        if (balance <= 0) {
window.novo_log('WARN', 'SAFETYMAILS', '⚠️ Saldo da conta SafetyMails zerado ou negativo', {
            email: email,
            balance: balance
          }, 'ERROR_HANDLING', 'SIMPLE');
        } else if (balance < 100) {
window.novo_log('WARN', 'SAFETYMAILS', '⚠️ Saldo da conta SafetyMails abaixo de 100 créditos', {
            email: email,
            balance: balance
          }, 'ERROR_HANDLING', 'SIMPLE');
        }
      }
      
      if (limited) {
window.novo_log('WARN', 'SAFETYMAILS', '⚠️ Validação limitada (Limited: true)', {
          email: email,
          limited: limited
        }, 'ERROR_HANDLING', 'SIMPLE');
      }
      
      // LOG 11: Resultado final
      // ⚠️ IMPORTANTE: Success: true não significa email válido!
      // Mas se Success: true, sempre retornar objeto completo para handler decidir qual SweetAlert mostrar
      // Retornar null apenas se requisição falhou (Success: false)

      // Verificar Success primeiro (já verificado antes, mas garantir)
      if (!data || !data.Success) {
        // Requisição falhou - retornar null
window.novo_log('WARN', 'SAFETYMAILS', '⚠️ Requisição não foi bem-sucedida', {
          email: email,
          success: data?.Success,
          status: data?.Status,
          domainStatus: data?.DomainStatus,
          advice: data?.Advice
        }, 'ERROR_HANDLING', 'SIMPLE');
        return null;
      }

      // Success é true - sempre retornar objeto completo
      // Handler decidirá qual SweetAlert mostrar baseado em Status, DomainStatus, Advice
      if (isValid) {
window.novo_log('INFO', 'SAFETYMAILS', '✅ Email válido confirmado', {
          email: email,
          status: status,
          domainStatus: domainStatus,
          advice: advice,
          idStatus: idStatus,
          idAdvice: idAdvice,
          balance: balance,
          environment: environment,
          method: method,
          resultado: {
            Status: status,
            DomainStatus: domainStatus,
            Advice: advice,
            IdStatus: idStatus,
            IdAdvice: idAdvice
          }
        }, 'OPERATION', 'SIMPLE');
      } else {
        // Email não é válido (mesmo que Success: true)
        // Pode ser PENDENTE, INVALIDO ou outro status não válido
        const motivo = isPending 
          ? `Status: ${status} (PENDENTE/DESCONHECIDO)`
          : isInvalid
          ? `Status: ${status} (INVALIDO)`
          : `Status: ${status} (esperado: "VALIDO")`;
        
window.novo_log('WARN', 'SAFETYMAILS', '⚠️ Email não válido (mesmo com Success: true)', {
          email: email,
          status: status,
          domainStatus: domainStatus,
          advice: advice,
          idStatus: idStatus,
          idAdvice: idAdvice,
          isPending: isPending,
          isInvalid: isInvalid,
          motivo: motivo,
          resultado: {
            Status: status,
            DomainStatus: domainStatus,
            Advice: advice,
            IdStatus: idStatus,
            IdAdvice: idAdvice
          }
        }, 'ERROR_HANDLING', 'SIMPLE');
      }

      // Sempre retornar objeto completo quando Success é true
      // Handler decidirá qual SweetAlert mostrar baseado nos campos Status, DomainStatus, Advice
      return data;
    } catch (error) {
      // LOG 12: Erro de exceção
window.novo_log('ERROR', 'SAFETYMAILS', '❌ SafetyMails request failed', {
        error: error.message,
        stack: error.stack,
        email: email,
        errorName: error.name,
        errorType: typeof error
      }, 'ERROR_HANDLING', 'SIMPLE');
      return null;
    }
  }
  
  // ========= LOADING UI =========
  
  /**
   * Inicializa overlay de loading
   */
  function initLoading() {
    // Verificar se já existe (evitar duplicação)
    if (document.getElementById('si-loading-overlay')) return;
    
    const style = document.createElement('style');
    style.textContent = `
    #si-loading-overlay{position:fixed;inset:0;background:rgba(0,0,0,.35);display:none;z-index:99998;align-items:center;justify-content:center}
    #si-loading-box{background:#fff;border-radius:12px;padding:18px 22px;box-shadow:0 10px 30px rgba(0,0,0,.2);display:flex;gap:12px;align-items:center;font-family:system-ui}
    .si-spinner{width:20px;height:20px;border:3px solid #e5e7eb;border-top-color:#111827;border-radius:50%;animation:si-spin .8s linear infinite}
    @keyframes si-spin{to{transform:rotate(360deg)}}
    `;
    document.head.appendChild(style);

    const overlay = document.createElement('div');
    overlay.id = 'si-loading-overlay';
    overlay.innerHTML = `<div id="si-loading-box"><div class="si-spinner"></div><div id="si-loading-text">Validando dados…</div></div>`;
    document.body.appendChild(overlay);
  }
  
  // Variável de controle de loading (escopo do IIFE)
  let __siLoadingCount = 0;
  
  /**
   * Mostra overlay de loading
   * @param {string} txt - Texto a exibir (opcional)
   */
  function showLoading(txt) {
    const o = document.getElementById('si-loading-overlay');
    const t = document.getElementById('si-loading-text');
    if (!o || !t) return;
    if (txt) t.textContent = txt;
    __siLoadingCount++;
    o.style.display = 'flex';
  }
  
  /**
   * Oculta overlay de loading
   */
  function hideLoading() {
    const o = document.getElementById('si-loading-overlay');
    if (!o) return;
    __siLoadingCount = Math.max(0, __siLoadingCount - 1);
    if (__siLoadingCount === 0) o.style.display = 'none';
  }
  
  // Inicializar loading ao carregar Utils.js
  initLoading();
  
  // ========= EXPOSIÇÃO GLOBAL =========
  
  // Expor funções globalmente para uso no Footer Code principal
  window.onlyDigits = onlyDigits;
  window.toUpperNospace = toUpperNospace;
  window.setFieldValue = setFieldValue;
  window.readCookie = readCookie;
  window.generateSessionId = generateSessionId;
  window.nativeSubmit = nativeSubmit;
  window.validarEmailLocal = validarEmailLocal;
  window.validarCPFFormato = validarCPFFormato;
  window.validarCPFAlgoritmo = validarCPFAlgoritmo;
  window.validarPlacaFormato = validarPlacaFormato;
  window.validarCelularLocal = validarCelularLocal;
  window.aplicarMascaraPlaca = aplicarMascaraPlaca;
  window.sha1 = sha1;
  window.hmacSHA256 = hmacSHA256;
  window.extractDataFromPH3A = extractDataFromPH3A;
  window.extractVehicleFromPlacaFipe = extractVehicleFromPlacaFipe;
  window.preencherEnderecoViaCEP = preencherEnderecoViaCEP;
  
  // ✅ NOVAS FUNÇÕES: Validação de API
  window.validarCPFApi = validarCPFApi;
  window.validarCepViaCep = validarCepViaCep;
  window.validarPlacaApi = validarPlacaApi;
  window.validarCelularApi = validarCelularApi;
  window.validarTelefoneAsync = validarTelefoneAsync;
  window.validarEmailSafetyMails = validarEmailSafetyMails;
  
  // ✅ NOVAS FUNÇÕES: Loading UI
  window.initLoading = initLoading;
  window.showLoading = showLoading;
  window.hideLoading = hideLoading;
  
  // Verificar se todas as funções foram expostas corretamente
  const requiredFunctions = [
    'onlyDigits', 'toUpperNospace', 'setFieldValue', 'readCookie',
    'generateSessionId', 'nativeSubmit', 'validarEmailLocal',
    'validarCPFFormato', 'validarCPFAlgoritmo', 'validarPlacaFormato',
    'validarCelularLocal', 'aplicarMascaraPlaca', 'sha1', 'hmacSHA256',
    'extractDataFromPH3A', 'extractVehicleFromPlacaFipe',
    'preencherEnderecoViaCEP', 'validarCPFApi', 'validarCepViaCep',
    'validarPlacaApi', 'validarCelularApi', 'validarTelefoneAsync',
    'validarEmailSafetyMails', 'initLoading', 'showLoading', 'hideLoading'
  ];
  
  const missing = requiredFunctions.filter(fn => typeof window[fn] !== 'function');
  if (missing.length > 0) {
    window.novo_log('ERROR', 'UTILS', '❌ Funções faltando:', missing, 'ERROR_HANDLING', 'SIMPLE');
  } else {
    window.novo_log('INFO', 'UTILS', '✅ Footer Code Utils carregado - 26 funções disponíveis', null, 'OPERATION', 'SIMPLE');
  }
  
  // ✅ Verificar se constantes estão disponíveis (recomendação do engenheiro)
  const requiredConstants = ['USE_PHONE_API', 'APILAYER_KEY', 'SAFETY_TICKET', 'SAFETY_API_KEY', 'VALIDAR_PH3A'];
  const missingConstants = requiredConstants.filter(c => typeof window[c] === 'undefined');
  if (missingConstants.length > 0) {
    window.novo_log('WARN', 'UTILS', '⚠️ Constantes faltando:', missingConstants, 'ERROR_HANDLING', 'SIMPLE');
  } else {
    window.novo_log('INFO', 'UTILS', '✅ Todas as constantes disponíveis', null, 'OPERATION', 'SIMPLE');
  }
})();
// ======================

    
    // ======================
    // FIM DA PARTE 1: FOOTER CODE UTILS
    // ======================
    
    // ======================
    // PARTE 2: FOOTER CODE PRINCIPAL (modificado)
    // ======================
    // Nota: Constantes globais já foram definidas no início do Footer Code Utils (PARTE 1)
    
    // ======================
    // CAPTURA E GERENCIAMENTO DE GCLID (Integrado do Inside Head Tag Pagina.js)
    // ======================
    
    /**
     * Captura parâmetro da URL
     * @param {string} p - Nome do parâmetro
     * @returns {string|null} Valor do parâmetro ou null
     */
    function getParam(p) {
      var params = new URLSearchParams(window.location.search);
      return params.get(p) ? decodeURIComponent(params.get(p)) : null;
    }
    
    /**
     * Define cookie com expiração
     * @param {string} name - Nome do cookie
     * @param {string} value - Valor do cookie
     * @param {number} days - Dias até expiração
     */
    function setCookie(name, value, days) {
      var date = new Date();
      date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000);
      var expires = "; expires=" + date.toUTCString();
      document.cookie = name + "=" + value + expires + ";path=/";
    }
    
    // Captura imediata de GCLID/GBRAID da URL (executa ANTES do DOM)
    novo_log('DEBUG', 'GCLID', '🔍 Iniciando captura - URL:', window.location.href);
    novo_log('DEBUG', 'GCLID', '🔍 window.location.search:', window.location.search);
    
    var gclid = getParam("gclid") || getParam("GCLID") || getParam("gclId");
    var gbraid = getParam("gbraid") || getParam("GBRAID") || getParam("gBraid");
    var trackingId = gclid || gbraid;
    
    novo_log('DEBUG', 'GCLID', '🔍 Valores capturados:', { gclid: gclid, gbraid: gbraid, trackingId: trackingId });
    
    if (trackingId) {
      var gclsrc = getParam("gclsrc");
      novo_log('DEBUG', 'GCLID', '🔍 gclsrc:', gclsrc);
      
      if (!gclsrc || gclsrc.indexOf("aw") !== -1) {
        try {
          setCookie("gclid", trackingId, 90);
          window.novo_log('INFO', 'GCLID', '✅ Capturado da URL e salvo em cookie:', trackingId, 'OPERATION', 'SIMPLE');
          
          // Verificar se cookie foi salvo corretamente
          var cookieVerificado = readCookie("gclid");
          novo_log('DEBUG', 'GCLID', '🔍 Cookie verificado após salvamento:', cookieVerificado);
        } catch (error) {
          window.novo_log('ERROR', 'GCLID', '❌ Erro ao salvar cookie:', error, 'ERROR_HANDLING', 'SIMPLE');
        }
      } else {
        window.novo_log('WARN', 'GCLID', '⚠️ gclsrc bloqueou salvamento:', gclsrc, 'ERROR_HANDLING', 'SIMPLE');
      }
    } else {
      window.novo_log('WARN','GCLID', '⚠️ Nenhum trackingId encontrado na URL');
    }
    
    // Função de verificação defensiva de dependências (Recomendação do Engenheiro)
    function waitForDependencies(callback, maxWait = 5000) {
      const startTime = Date.now();
      
      function check() {
        const hasJQuery = typeof jQuery !== 'undefined';
        const hasUtils = typeof window.onlyDigits === 'function';
        
        if (hasJQuery && hasUtils) {
          callback();
        } else if (Date.now() - startTime < maxWait) {
          setTimeout(check, 50);
        } else {
window.novo_log('ERROR', 'FOOTER', '[FOOTER COMPLETO] Timeout aguardando dependências:', {
            jQuery: hasJQuery,
            Utils: hasUtils
          }, 'ERROR_HANDLING', 'SIMPLE');
          // Executar mesmo assim - pode haver fallbacks no código
          callback();
        }
      }
      
      check();
    }
    
    // Função de inicialização consolidada
    function init() {
      // 1. WhatsApp form submit especial
      document.addEventListener('DOMContentLoaded', function () {
        var form = document.getElementById('form-wp');
        if (!form) return;
        form.addEventListener('submit', function (e) {
          e.preventDefault();
          var whatsappUrl = `${WHATSAPP_API_BASE}/send?phone=${WHATSAPP_PHONE}&text=${WHATSAPP_DEFAULT_MESSAGE}`;
          window.open(whatsappUrl, '_blank');
          form.submit();
        });
      });
      
      // 2. Configuração RPA Global (já definida via data attributes no início do script)
      window.novo_log('INFO', 'CONFIG', '🎯 RPA habilitado:', window.rpaEnabled, 'OPERATION', 'SIMPLE');
      
      // 2.1. Gerenciamento GCLID (com verificação de readyState)
      function executeGCLIDFill() {
        // Log de inicialização para facilitar debug (RECOMENDAÇÃO DA AUDITORIA)
        try {
          var readyState = document.readyState;
          var executionMode = readyState === 'loading' ? 'via DOMContentLoaded' : 'imediato (DOM já pronto)';
          window.novo_log('INFO', 'GCLID', '🚀 executeGCLIDFill() iniciada - Modo: ' + executionMode + ' | readyState: ' + readyState, null, 'OPERATION', 'MEDIUM');
        } catch (e) {
          window.novo_log('INFO', 'GCLID', 'executeGCLIDFill() iniciada', null, 'OPERATION', 'MEDIUM');
        }
        
        // Tentar capturar novamente se não foi capturado antes (FALLBACK)
        var cookieExistente = window.readCookie ? window.readCookie("gclid") : null;
        
        if (!cookieExistente) {
          novo_log('DEBUG', 'GCLID', '🔍 Cookie não encontrado, tentando captura novamente no DOMContentLoaded...');
          var gclid = getParam("gclid") || getParam("GCLID") || getParam("gclId");
          var gbraid = getParam("gbraid") || getParam("GBRAID") || getParam("gBraid");
          var trackingId = gclid || gbraid;
          
          if (trackingId) {
            var gclsrc = getParam("gclsrc");
            if (!gclsrc || gclsrc.indexOf("aw") !== -1) {
              try {
                setCookie("gclid", trackingId, 90);
                window.novo_log('INFO', 'GCLID', '✅ Capturado no DOMContentLoaded e salvo em cookie:', trackingId, 'OPERATION', 'SIMPLE');
                cookieExistente = trackingId;
              } catch (error) {
                window.novo_log('ERROR', 'GCLID', '❌ Erro ao salvar cookie no DOMContentLoaded:', error, 'ERROR_HANDLING', 'SIMPLE');
              }
            }
          } else {
            window.novo_log('WARN','GCLID', '⚠️ Nenhum trackingId encontrado na URL no DOMContentLoaded');
          }
        } else {
          window.novo_log('INFO', 'GCLID', '✅ Cookie já existe:', cookieExistente, 'OPERATION', 'SIMPLE');
        }
        
        // Função robusta para preencher campos GCLID_FLD
        function fillGCLIDFields() {
          try {
            // 1. Buscar por ID e NAME (ambos)
            var fieldsById = document.getElementById("GCLID_FLD") ? [document.getElementById("GCLID_FLD")] : [];
            var fieldsByName = Array.from(document.getElementsByName("GCLID_FLD"));
            
            // Combinar resultados evitando duplicatas
            var allFields = [];
            var seenFields = new Set();
            
            fieldsById.forEach(function(field) {
              if (!seenFields.has(field)) {
                allFields.push(field);
                seenFields.add(field);
              }
            });
            
            fieldsByName.forEach(function(field) {
              if (!seenFields.has(field)) {
                allFields.push(field);
                seenFields.add(field);
              }
            });
            
            // Log de campos encontrados
            var logMsg = '🔍 Campos GCLID_FLD encontrados: ' + allFields.length;
            if (allFields.length > 0) {
              logMsg += ' (por ID: ' + fieldsById.length + ', por NAME: ' + fieldsByName.length + ')';
            }
            try {
              window.novo_log('INFO', 'GCLID', logMsg, null, 'OPERATION', 'MEDIUM');
            } catch (e) {
              window.novo_log('INFO', 'GCLID', logMsg, null, 'OPERATION', 'MEDIUM');
            }
            
            if (allFields.length === 0) {
              return false; // Nenhum campo encontrado
            }
            
            // 2. Melhorar Leitura de Cookie
            var cookieValue = null;
            try {
              // Tentar window.readCookie primeiro
              if (typeof window.readCookie === 'function') {
                cookieValue = window.readCookie("gclid");
              }
              
              // Fallback para leitura direta do cookie
              if (!cookieValue) {
                var cookies = document.cookie.split(';');
                for (var i = 0; i < cookies.length; i++) {
                  var cookie = cookies[i].trim();
                  if (cookie.indexOf("gclid=") === 0) {
                    cookieValue = cookie.substring(6);
                    break;
                  }
                }
              }
              
              // Usar cookieExistente como último recurso
              if (!cookieValue && cookieExistente) {
                cookieValue = cookieExistente;
              }
            } catch (e) {
              try {
                novo_log('ERROR', 'GCLID', '❌ Erro ao ler cookie:', e);
              } catch (logErr) {
                console.error('[GCLID] Erro ao ler cookie:', e);
              }
            }
            
            if (!cookieValue) {
              try {
                novo_log('WARN', 'GCLID', '⚠️ Cookie gclid não encontrado - campos não serão preenchidos');
              } catch (e) {
                console.warn('[GCLID] Cookie gclid não encontrado');
              }
              return false;
            }
            
            var fieldsFilled = 0;
            
            // 3. Preencher cada campo encontrado
            for (var i = 0; i < allFields.length; i++) {
              try {
                var field = allFields[i];
                
                // 3.1. Validar Tipo de Campo
                var tagName = field.tagName ? field.tagName.toUpperCase() : '';
                var isValidField = (tagName === 'INPUT' || tagName === 'TEXTAREA' || tagName === 'SELECT');
                var isDisabled = field.disabled === true;
                var isReadonly = field.readOnly === true || field.getAttribute('readonly') !== null;
                
                if (!isValidField) {
                  try {
                    novo_log('WARN', 'GCLID', '⚠️ Campo GCLID_FLD[' + i + '] ignorado - tipo inválido:', tagName);
                  } catch (e) {
                    console.warn('[GCLID] Campo ignorado - tipo inválido:', tagName);
                  }
                  continue;
                }
                
                if (isDisabled || isReadonly) {
                  try {
                    novo_log('WARN', 'GCLID', '⚠️ Campo GCLID_FLD[' + i + '] ignorado - desabilitado ou readonly');
                  } catch (e) {
                    console.warn('[GCLID] Campo ignorado - desabilitado ou readonly');
                  }
                  continue;
                }
                
                // 3.2. Preencher campo
                var oldValue = field.value || '';
                field.value = cookieValue;
                
                // 3.3. Disparar Eventos
                try {
                  var inputEvent = new Event('input', { bubbles: true, cancelable: true });
                  field.dispatchEvent(inputEvent);
                  
                  var changeEvent = new Event('change', { bubbles: true, cancelable: true });
                  field.dispatchEvent(changeEvent);
                } catch (e) {
                  // Se eventos não funcionarem, continuar mesmo assim
                  try {
                    novo_log('DEBUG', 'GCLID', '⚠️ Erro ao disparar eventos no campo[' + i + ']:', e);
                  } catch (logErr) {
                    console.debug('[GCLID] Erro ao disparar eventos:', e);
                  }
                }
                
                // 3.4. Validação Final com Log de Confirmação
                // Ler novamente o campo após preenchimento
                var valueRead = field.value || '';
                var fieldId = field.id || '(sem ID)';
                var fieldName = field.name || '(sem NAME)';
                var fieldType = tagName;
                
                var valuesMatch = (valueRead === cookieValue);
                var statusIcon = valuesMatch ? '✅' : '⚠️';
                var statusText = valuesMatch ? 'SUCESSO' : 'AVISO';
                
                var confirmationMsg = statusIcon + ' Campo GCLID_FLD[' + i + '] ' + statusText + ':';
                confirmationMsg += ' | ID: ' + fieldId;
                confirmationMsg += ' | NAME: ' + fieldName;
                confirmationMsg += ' | Tipo: ' + fieldType;
                confirmationMsg += ' | Valor esperado: ' + cookieValue;
                confirmationMsg += ' | Valor lido: ' + valueRead;
                
                if (!valuesMatch) {
                  confirmationMsg += ' | ⚠️ VALORES NÃO COINCIDEM - possível problema';
                }
                
                try {
                  window.novo_log(valuesMatch ? 'INFO' : 'WARN', 'GCLID', confirmationMsg, null, 'OPERATION', 'MEDIUM');
                } catch (e) {
                  window.novo_log(valuesMatch ? 'INFO' : 'WARN', 'GCLID', confirmationMsg, null, 'OPERATION', 'MEDIUM');
                }
                
                fieldsFilled++;
                
              } catch (fieldError) {
                try {
                  novo_log('ERROR', 'GCLID', '❌ Erro ao preencher campo GCLID_FLD[' + i + ']:', fieldError);
                } catch (e) {
                  console.error('[GCLID] Erro ao preencher campo:', fieldError);
                }
              }
            }
            
            return fieldsFilled > 0;
            
          } catch (error) {
            // Tratamento de Erros Robusto - não interromper execução
            try {
              novo_log('ERROR', 'GCLID', '❌ Erro crítico em fillGCLIDFields():', error);
            } catch (logErr) {
              console.error('[GCLID] Erro crítico:', error);
            }
            return false;
          }
        }
        
        // Executar imediatamente
        fillGCLIDFields();
        
        // Retry após 1 segundo
        setTimeout(function() {
          fillGCLIDFields();
        }, 1000);
        
        // Retry após 3 segundos
        setTimeout(function() {
          fillGCLIDFields();
        }, 3000);
        
        // MutationObserver para campos adicionados dinamicamente
        try {
          var observer = new MutationObserver(function(mutations) {
            var shouldFill = false;
            mutations.forEach(function(mutation) {
              mutation.addedNodes.forEach(function(node) {
                if (node.nodeType === 1) { // Element node
                  // Verificar se o próprio nó é um campo GCLID_FLD
                  if ((node.id === 'GCLID_FLD' || node.name === 'GCLID_FLD') && 
                      (node.tagName === 'INPUT' || node.tagName === 'TEXTAREA' || node.tagName === 'SELECT')) {
                    shouldFill = true;
                  }
                  // Verificar se contém campos GCLID_FLD
                  if (node.querySelectorAll && (
                      node.querySelectorAll('#GCLID_FLD').length > 0 ||
                      node.querySelectorAll('[name="GCLID_FLD"]').length > 0)) {
                    shouldFill = true;
                  }
                }
              });
            });
            if (shouldFill) {
              try {
                window.novo_log('INFO', 'GCLID', 'Campo adicionado dinamicamente detectado', null, 'OPERATION', 'MEDIUM');
              } catch (e) {
                window.novo_log('INFO', 'GCLID', 'Campo adicionado dinamicamente detectado', null, 'OPERATION', 'MEDIUM');
              }
              fillGCLIDFields();
            }
          });
          
          observer.observe(document.body, {
            childList: true,
            subtree: true
          });
          
          try {
            window.novo_log('INFO', 'GCLID', 'MutationObserver configurado', null, 'OPERATION', 'MEDIUM');
          } catch (e) {
            window.novo_log('INFO', 'GCLID', 'MutationObserver configurado', null, 'OPERATION', 'MEDIUM');
          }
        } catch (observerError) {
          // Se MutationObserver não estiver disponível (navegadores muito antigos), continuar sem ele
          try {
            novo_log('WARN', 'GCLID', '⚠️ MutationObserver não disponível:', observerError);
          } catch (e) {
            console.warn('[GCLID] MutationObserver não disponível');
          }
        }
      }
      
      // Verificar se DOM já está pronto
      if (document.readyState === 'loading') {
        // DOM ainda está carregando, adicionar listener
        try {
          window.novo_log('INFO', 'GCLID', 'DOM ainda carregando - Adicionando listener', null, 'OPERATION', 'MEDIUM');
        } catch (e) {
          window.novo_log('INFO', 'GCLID', 'DOM ainda carregando - Adicionando listener', null, 'OPERATION', 'MEDIUM');
        }
        document.addEventListener("DOMContentLoaded", executeGCLIDFill);
      } else {
        // DOM já está pronto, executar imediatamente
        try {
          window.novo_log('INFO', 'GCLID', 'DOM já pronto - Executando imediatamente', null, 'OPERATION', 'MEDIUM');
        } catch (e) {
          window.novo_log('INFO', 'GCLID', 'DOM já pronto - Executando imediatamente', null, 'OPERATION', 'MEDIUM');
        }
        executeGCLIDFill();
      }
      
      // Configurar listeners em anchors [whenClicked='set']
        var anchors = document.querySelectorAll("[whenClicked='set']");
        for (var i = 0; i < anchors.length; i++) {
          anchors[i].onclick = function () {
            // Verificação defensiva antes de acessar .value
            var emailEl = document.getElementById("email");
            var gclidEl = document.getElementById("GCLID_FLD");
            var gclidWpEl = document.getElementById("GCLID_FLD_WP");
            
            var global_email = emailEl ? emailEl.value : null;
            var global_gclid = gclidEl ? gclidEl.value : null;
            var global_gclid_wp = gclidWpEl ? gclidWpEl.value : null;
            
            // Salvar apenas valores válidos no localStorage
            if (global_gclid) {
              window.localStorage.setItem("GCLID_FLD", global_gclid);
            }
            if (global_gclid_wp) {
              window.localStorage.setItem("GCLID_FLD_WP", global_gclid_wp);
            }
            if (global_email) {
              window.localStorage.setItem("EMAIL_FLD", global_email);
            }
          };
        }
        
        // Configurar CollectChatAttributes
        var gclidCookie = (document.cookie.match(/(^|;)\s*gclid=([^;]+)/) || [])[2];
        if (gclidCookie) {
          window.CollectChatAttributes = {
            gclid: decodeURIComponent(gclidCookie)
          };
          window.novo_log('INFO',"GCLID", "✅ CollectChatAttributes configurado:", decodeURIComponent(gclidCookie));
        }
      
      
      // Teste da funcionalidade de logging (usar função local diretamente)
      novo_log('INFO', 'CONFIG', '[CONFIG] RPA habilitado via PHP Log', {rpaEnabled: window.rpaEnabled});
      
      // 3. Função para carregar script RPA dinamicamente
      function loadRPAScript() {
        return new Promise((resolve, reject) => {
          // Verificar se já foi carregado
          if (window.MainPage && window.ProgressModalRPA) {
            window.novo_log('INFO','RPA', '🎯 Script RPA já carregado');
            resolve();
            return;
          }

          window.novo_log('INFO','RPA', '🎯 Carregando script RPA...');
          
          // Validar que APP_BASE_URL está disponível (deve estar, pois vem de data attribute)
          if (!window.APP_BASE_URL) {
            novo_log('CRITICAL', 'FOOTER', 'APP_BASE_URL não disponível para carregar webflow_injection_limpo.js', null, 'INIT', 'SIMPLE');
            novo_log('CRITICAL', 'FOOTER', 'Verifique se data-app-base-url está definido no script tag no Webflow Footer Code', null, 'INIT', 'SIMPLE');
            reject(new Error('APP_BASE_URL não disponível'));
            return;
          }
          
          const script = document.createElement('script');
          script.src = window.APP_BASE_URL + '/webflow_injection_limpo.js';
          script.onload = () => {
            window.novo_log('INFO','RPA', '✅ Script RPA carregado com sucesso');
            resolve();
          };
          script.onerror = () => {
            window.novo_log('ERROR','RPA', '❌ Erro ao carregar script RPA');
            reject(new Error('Falha ao carregar script RPA'));
          };
          document.head.appendChild(script);
        });
      }

      // Expor função globalmente
      window.loadRPAScript = loadRPAScript;
      
      // 4. WhatsApp links com GCLID
      var gclid = null;
      
      function initGCLID() {
        if (typeof window.readCookie === 'function') {
          gclid = window.readCookie('gclid');
        } else {
          // Fallback se Utils.js não carregou
          window.novo_log('WARN','FOOTER', '⚠️ readCookie não disponível, tentando novamente...');
          setTimeout(initGCLID, 100);
        }
      }
      
      // Tentar inicializar imediatamente ou aguardar carregamento do Utils
      if (typeof window.readCookie === 'function') {
        gclid = window.readCookie('gclid');
      } else {
        window.addEventListener('footerUtilsLoaded', initGCLID);
        setTimeout(initGCLID, 500); // Fallback após 500ms
      }

      /**
       * Detecção iOS melhorada (inclui iPad iOS 13+)
       * Baseado em: MDN, Stack Overflow, GeeksforGeeks
       * Validação: PESQUISA_SOLUCOES_VALIDADAS_FONTES_REFERENCIA.md
       */
      function isIOS() {
        // Detecção padrão
        const isStandardIOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
        
        // Detecção para iPad iOS 13+ (retorna MacIntel)
        const isIPadOS13 = navigator.platform === 'MacIntel' && 
                           navigator.maxTouchPoints > 1 &&
                           'ontouchend' in document;
        
        return isStandardIOS || isIPadOS13;
      }

      // Função para carregar modal dinamicamente
      function loadWhatsAppModal() {
        if (window.whatsappModalLoaded) {
          window.novo_log('INFO','MODAL', '✅ Modal já carregado');
          return;
        }
        
        // Validar que APP_BASE_URL está disponível (deve estar, pois vem de data attribute)
        if (!window.APP_BASE_URL) {
          novo_log('CRITICAL', 'FOOTER', 'APP_BASE_URL não disponível para carregar MODAL_WHATSAPP_DEFINITIVO.js', null, 'INIT', 'SIMPLE');
          novo_log('CRITICAL', 'FOOTER', 'Verifique se data-app-base-url está definido no script tag no Webflow Footer Code', null, 'INIT', 'SIMPLE');
          return;
        }
        
        window.novo_log('INFO','MODAL', '🔄 Carregando modal...');
        const script = document.createElement('script');
        script.src = window.APP_BASE_URL + '/MODAL_WHATSAPP_DEFINITIVO.js?v=24&force=' + Math.random();
        script.onload = function() {
          window.whatsappModalLoaded = true;
          window.novo_log('INFO','MODAL', '✅ Modal carregado com sucesso');
        };
        script.onerror = function() {
          window.novo_log('ERROR','MODAL', '❌ Erro ao carregar modal');
        };
        document.head.appendChild(script);
      }
      
      /**
       * Flag de controle para prevenir dupla execução
       * Baseado em: Stack Overflow, CSS-Tricks (padrão da indústria)
       */
      let modalOpening = false;

      /**
       * Função unificada para abrir modal
       * Previne dupla execução com flag de controle
       */
      function openWhatsAppModal() {
        if (modalOpening) {
          novo_log('DEBUG', 'MODAL', '⚠️ Modal já está sendo aberto, ignorando chamada duplicada');
          return;
        }
        
        modalOpening = true;
        novo_log('DEBUG', 'MODAL', '🔄 Abrindo modal WhatsApp');
        
        // Se modal já existe, apenas abrir
        if ($('#whatsapp-modal').length) {
          $('#whatsapp-modal').fadeIn(300);
          // Resetar flag após animação completar
          setTimeout(() => {
            modalOpening = false;
          }, 500);
        } else {
          // Modal não existe, carregar
          loadWhatsAppModal();
          
          // Usar MutationObserver para detectar quando o modal é criado (elimina setInterval e memory leak)
          let observer = null;
          let timeoutId = null;
          
          // Função para limpar recursos
          const cleanup = () => {
            if (observer) {
              observer.disconnect();
              observer = null;
            }
            if (timeoutId) {
              clearTimeout(timeoutId);
              timeoutId = null;
            }
          };
          
          // Função para abrir o modal
          const openModal = () => {
            cleanup();
            const modal = document.getElementById('whatsapp-modal');
            if (modal && typeof $ !== 'undefined' && $.fn.fadeIn) {
              $('#whatsapp-modal').fadeIn(300);
              setTimeout(() => {
                modalOpening = false;
              }, 500);
            } else {
              // Fallback: mostrar modal diretamente se jQuery não estiver disponível
              if (modal) {
                modal.style.display = 'block';
                setTimeout(() => {
                  modalOpening = false;
                }, 500);
              } else {
                modalOpening = false;
              }
            }
          };
          
          // Verificar se o modal já existe (caso tenha sido criado muito rapidamente)
          if (document.getElementById('whatsapp-modal')) {
            openModal();
            return;
          }
          
          // Criar MutationObserver para observar mudanças no DOM
          observer = new MutationObserver((mutations) => {
            if (document.getElementById('whatsapp-modal')) {
              openModal();
            }
          });
          
          // Observar mudanças no body (onde o modal provavelmente será adicionado)
          observer.observe(document.body, {
            childList: true,
            subtree: true
          });
          
          // Timeout de segurança (3 segundos)
          timeoutId = setTimeout(() => {
            cleanup();
            const modal = document.getElementById('whatsapp-modal');
            if (modal) {
              openModal();
            } else {
              modalOpening = false;
              if (window.logClassified) {
                novo_log('WARN', 'MODAL', 'Modal WhatsApp não foi criado após 3 segundos', null, 'ERROR_HANDLING', 'SIMPLE');
              }
            }
          }, 3000);
        }
      }

      /**
       * Verificar suporte a passive listeners
       * Baseado em: MDN, web.dev
       */
      let passiveSupported = false;
      try {
        const opts = Object.defineProperty({}, 'passive', {
          get() { passiveSupported = true; }
        });
        window.addEventListener('test', null, opts);
        window.removeEventListener('test', null, opts);
      } catch (e) {
        // Navegador não suporta passive option
        passiveSupported = false;
      }

      // Aguardar jQuery para inicializar validações
      $(function () {
        /**
         * Configurar handlers com detecção de dispositivo iOS
         * Baseado em: PESQUISA_SOLUCOES_VALIDADAS_FONTES_REFERENCIA.md
         * 
         * Soluções implementadas:
         * 1. Detecção iOS melhorada (inclui iPad iOS 13+)
         * 2. Flag de controle para prevenir dupla execução
         * 3. Handler touchstart para iOS (intercepta antes do Safari seguir link)
         * 4. Handler click melhorado com prevenção de dupla execução
         * 5. Uso de passive: false apenas em iOS
         */
        ['whatsapplink', 'whatsapplinksucesso', 'whatsappfone1', 'whatsappfone2'].forEach(function (id) {
          var $el = $('#' + id);
          if (!$el.length) return;
          
          // Handler touchstart (apenas iOS)
          // iOS Safari processa touchstart ANTES de click
          // Precisamos interceptar touchstart para prevenir navegação
          if (isIOS()) {
            const touchOptions = passiveSupported ? { passive: false } : false;
            
            $el.on('touchstart', function (e) {
              // Se modal já está sendo aberto, prevenir evento
              if (modalOpening) {
                e.preventDefault();
                e.stopPropagation();
                return false;
              }
              
              // Prevenir comportamento padrão (navegação)
              e.preventDefault();
              e.stopPropagation();
              
              // Abrir modal
              openWhatsAppModal();
              
              // Retornar false para garantir que não segue link
              return false;
            });
            
            novo_log('DEBUG', 'MODAL', '✅ Handler touchstart configurado para iOS:', id);
          }
          
          // Handler click (todos os dispositivos)
          $el.on('click', function (e) {
            // Em iOS, se touchstart já executou, prevenir click
            if (isIOS() && modalOpening) {
              e.preventDefault();
              e.stopPropagation();
              return false;
            }
            
            // Prevenir comportamento padrão
            e.preventDefault();
            e.stopPropagation();
            
            // Abrir modal
            openWhatsAppModal();
            
            // Retornar false para garantir que não segue link
            return false;
          });
          
          novo_log('DEBUG', 'MODAL', '✅ Handler click configurado:', id);
        });
        
        // 5. Validações unificadas: CPF, CEP, PLACA, CELULAR, E-MAIL
        // Campos
        const $CPF   = $('#CPF, [name="CPF"]');
        const $CEP   = $('#CEP, [name="CEP"]');
        const $PLACA = $('#PLACA, [name="PLACA"]');
        const $MARCA = $('#MARCA, [name="MARCA"]');
        const $ANO   = $('#ANO, [name="ANO"]');
        const $DDD   = $('#DDD-CELULAR, [name="DDD-CELULAR"]');
        const $CEL   = $('#CELULAR, [name="CELULAR"]');
        const $EMAIL = $('#email, [name="email"], #EMAIL, [name="EMAIL"]');

        // Máscaras
        if ($CPF.length)   $CPF.mask('000.000.000-00');
        if ($CEP.length)   $CEP.mask('00000-000');
        if ($PLACA.length && typeof window.aplicarMascaraPlaca === 'function') {
          window.aplicarMascaraPlaca($PLACA);
        }
        if ($DDD.length)   $DDD.off('.siPhone').mask('00', { clearIfNotMatch:false });
        if ($CEL.length)   $CEL.off('.siPhone').mask('00000-0000', { clearIfNotMatch:false });

        // ============ Helpers de Alert (SweetAlert2) ============
        function saWarnConfirmCancel(opts) {
          return Swal.fire(Object.assign({
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Corrigir',
            cancelButtonText: 'Não',
            reverseButtons: true,
            allowOutsideClick: false,
            allowEscapeKey: true
          }, opts));
        }
        function saInfoConfirmCancel(opts) {
          return Swal.fire(Object.assign({
            icon: 'info',
            showCancelButton: true,
            confirmButtonText: 'Prosseguir assim mesmo',
            cancelButtonText: 'Corrigir',
            reverseButtons: true,
            allowOutsideClick: false,
            allowEscapeKey: true
          }, opts));
        }

        // CPF → change (com/sem API PH3A)
        $CPF.on('change', function(){
          const cpfValue = $(this).val();
          
          // Validação local primeiro
          if (typeof window.validarCPFAlgoritmo !== 'function') {
            window.novo_log('ERROR','FOOTER', '❌ validarCPFAlgoritmo não disponível');
            return;
          }
          if (!window.validarCPFAlgoritmo(cpfValue)) {
            saWarnConfirmCancel({
              title: 'CPF inválido',
              html: 'Deseja corrigir?'
            }).then(r => { 
              if (r.isConfirmed) $CPF.focus(); 
            });
            return;
          }
          
          // Se flag VALIDAR_PH3A estiver desabilitada, apenas validar formato
          if (!window.VALIDAR_PH3A) {
            // CPF válido, mas sem consulta à API - limpar campos para preenchimento manual
            if (typeof window.setFieldValue === 'function') {
              window.setFieldValue('SEXO', '');
              window.setFieldValue('DATA-DE-NASCIMENTO', '');
              window.setFieldValue('ESTADO-CIVIL', '');
            }
            return;
          }
          
          // Se CPF válido e flag ativa, consultar API PH3A
          if (typeof window.showLoading === 'function') window.showLoading('Consultando dados do CPF…');
          if (typeof window.validarCPFApi === 'function') {
            window.validarCPFApi(cpfValue).then(res => {
              if (typeof window.hideLoading === 'function') window.hideLoading();
              
              if (res.ok && res.parsed && typeof window.setFieldValue === 'function') {
                // Preencher campos automaticamente
                if (res.parsed.sexo) window.setFieldValue('SEXO', res.parsed.sexo);
                if (res.parsed.dataNascimento) window.setFieldValue('DATA-DE-NASCIMENTO', res.parsed.dataNascimento);
                if (res.parsed.estadoCivil) window.setFieldValue('ESTADO-CIVIL', res.parsed.estadoCivil);
              } else if (res.reason === 'nao_encontrado') {
                // CPF válido mas não encontrado na base
                saWarnConfirmCancel({
                  title: 'CPF não encontrado',
                  html: 'O CPF é válido, mas não foi encontrado na nossa base de dados.<br><br>Deseja preencher os dados manualmente?',
                  confirmButtonText: 'Sim, preencher manualmente',
                  cancelButtonText: 'Corrigir CPF'
                }).then(r => {
                  if (r.isConfirmed) {
                    // Limpar campos e permitir preenchimento manual
                    if (typeof window.setFieldValue === 'function') {
                      window.setFieldValue('SEXO', '');
                      window.setFieldValue('DATA-DE-NASCIMENTO', '');
                      window.setFieldValue('ESTADO-CIVIL', '');
                    }
                  } else {
                    // Usuário escolheu corrigir CPF
                    $CPF.focus();
                  }
                });
              }
            }).catch(_ => {
              if (typeof window.hideLoading === 'function') window.hideLoading();
              // Em caso de erro na API, não bloquear o usuário
              window.novo_log('ERROR','FOOTER', 'Erro na consulta da API PH3A');
            });
          }
        });

        // CEP → change (ViaCEP)
        $CEP.on('change', function(){
          const val = $(this).val();
          if (typeof window.showLoading === 'function') window.showLoading('Validando CEP…');
          if (typeof window.validarCepViaCep === 'function') {
            window.validarCepViaCep(val).then(res=>{
              if (typeof window.hideLoading === 'function') window.hideLoading();
              if (!res.ok){
                saWarnConfirmCancel({
                  title: 'CEP inválido',
                  html: 'Deseja corrigir?'
                }).then(r=>{ if (r.isConfirmed) $CEP.focus(); });
              } else if (res.viacep && typeof window.preencherEnderecoViaCEP === 'function'){
                window.preencherEnderecoViaCEP(res.viacep);
              }
            }).catch(_=>{
              if (typeof window.hideLoading === 'function') window.hideLoading();
            });
          }
        });

        // PLACA → change (preenche MARCA/ANO/TIPO se ok)
        $PLACA.on('change', function(){
          if (typeof window.showLoading === 'function') window.showLoading('Validando placa…');
          if (typeof window.validarPlacaApi === 'function') {
            window.validarPlacaApi($(this).val()).then(res=>{
              if (typeof window.hideLoading === 'function') window.hideLoading();
              if (!res.ok){
                saWarnConfirmCancel({
                  title: 'Placa inválida',
                  html: 'Deseja corrigir?'
                }).then(r=>{ if (r.isConfirmed) $PLACA.focus(); });
                if (typeof window.setFieldValue === 'function') {
                  window.setFieldValue('MARCA',''); 
                  window.setFieldValue('ANO',''); 
                  window.setFieldValue('TIPO-DE-VEICULO','');
                }
              } else {
                if (typeof window.setFieldValue === 'function' && res.parsed) {
                  if (res.parsed.marcaTxt) window.setFieldValue('MARCA', res.parsed.marcaTxt);
                  if (res.parsed.anoModelo) window.setFieldValue('ANO', res.parsed.anoModelo);
                  if (res.parsed.tipoVeiculo) window.setFieldValue('TIPO-DE-VEICULO', res.parsed.tipoVeiculo);
                }
              }
            }).catch(_=>{
              if (typeof window.hideLoading === 'function') window.hideLoading();
            });
          }
        });

        // CELULAR → valida SÓ no BLUR do CELULAR
        $DDD.off('change'); $CEL.off('change'); // remove handlers antigos
        
        // DDD → valida no BLUR do DDD
        $DDD.on('blur.siPhone', function(){
          if (typeof window.onlyDigits !== 'function') {
            window.novo_log('ERROR','FOOTER', '❌ onlyDigits não disponível');
            return;
          }
          const dddDigits = window.onlyDigits($DDD.val()).length;
          
          // Se DDD incompleto (não tem 2 dígitos)
          if (dddDigits > 0 && dddDigits < 2) {
            saWarnConfirmCancel({
              title: 'DDD incompleto',
              html: 'O DDD precisa ter 2 dígitos.<br><br>Deseja corrigir?'
            }).then(r=>{ if (r.isConfirmed) $DDD.focus(); });
            return;
          }
          
          // Se DDD inválido (mais de 2 dígitos)
          if (dddDigits > 2) {
            saWarnConfirmCancel({
              title: 'DDD inválido',
              html: 'O DDD deve ter exatamente 2 dígitos.<br><br>Deseja corrigir?'
            }).then(r=>{ if (r.isConfirmed) $DDD.focus(); });
            return;
          }
        });
        
        $CEL.on('blur.siPhone', function(){
          if (typeof window.onlyDigits !== 'function') {
            window.novo_log('ERROR','FOOTER', '❌ onlyDigits não disponível');
            return;
          }
          const dddDigits = window.onlyDigits($DDD.val()).length;
          const celDigits = window.onlyDigits($CEL.val()).length;

          // Validação DDD: deve ter exatamente 2 dígitos
          if (dddDigits !== 2) {
            saWarnConfirmCancel({
              title: 'DDD inválido',
              html: 'O DDD precisa ter 2 dígitos.<br><br>Deseja corrigir?'
            }).then(r=>{ if (r.isConfirmed) $DDD.focus(); });
            return;
          }

          // Validação Celular: deve ter exatamente 9 dígitos
          if (celDigits > 0 && celDigits < 9) {
            saWarnConfirmCancel({
              title: 'Celular incompleto',
              html: 'O celular precisa ter 9 dígitos.<br><br>Deseja corrigir?'
            }).then(r=>{ if (r.isConfirmed) $CEL.focus(); });
            return;
          }

          // Se DDD=2 e celular=9 → valida via API
          if (dddDigits === 2 && celDigits === 9){
            if (typeof window.showLoading === 'function') window.showLoading('Validando celular…');
            if (typeof window.validarTelefoneAsync === 'function') {
              window.validarTelefoneAsync($DDD,$CEL).then(res=>{
                if (typeof window.hideLoading === 'function') window.hideLoading();
                if (!res.ok){
                  const numero = `${($DDD.val()||'').trim()}-${($CEL.val()||'').trim()}`;
                  saWarnConfirmCancel({
                    title: 'Celular inválido',
                    html: `Parece que o celular informado<br><br><b>${numero}</b><br><br>não é válido.<br><br>Deseja corrigir?`
                  }).then(r=>{ if (r.isConfirmed) $CEL.focus(); });
                }
              }).catch(_=>{
                if (typeof window.hideLoading === 'function') window.hideLoading();
              });
            }
          }
          // Se DDD incompleto ou celular vazio → não valida agora (submit cuida)
        });

        // E-MAIL → change (regex bloqueia; SafetyMails só avisa)
        $EMAIL.on('change.siMail', function(){
          const v = ($(this).val()||'').trim();
          // LOG DE DIAGNÓSTICO: Handler executado
window.novo_log('INFO', 'FOOTER', '🔍 Handler change.siMail executado', {
            email: v,
            campoVazio: !v,
            timestamp: new Date().toISOString()
          }, 'OPERATION', 'SIMPLE');
          if (!v) return;
          if (typeof window.validarEmailLocal !== 'function') {
            window.novo_log('ERROR','FOOTER', '❌ validarEmailLocal não disponível');
            return;
          }
          // LOG DE DIAGNÓSTICO: Validação local
          window.novo_log('INFO', 'FOOTER', '🔍 Iniciando validação local', { email: v }, 'OPERATION', 'SIMPLE');
          if (!window.validarEmailLocal(v)){
            window.novo_log('WARN', 'FOOTER', '⚠️ Validação local falhou', { email: v }, 'ERROR_HANDLING', 'SIMPLE');
            saWarnConfirmCancel({
              title: 'E-mail inválido',
              html: `O e-mail informado:<br><br><b>${v}</b><br><br>não parece válido.<br><br>Deseja corrigir?`,
              cancelButtonText: 'Não Corrigir',
              confirmButtonText: 'Corrigir'
            }).then(r=>{ if (r.isConfirmed) $EMAIL.focus(); });
            return;
          }
          window.novo_log('INFO', 'FOOTER', '✅ Validação local passou', { email: v }, 'OPERATION', 'SIMPLE');
          // Aviso opcional via SafetyMails (não bloqueia)
          // LOG DE DIAGNÓSTICO: Verificar se função está disponível
window.novo_log('INFO', 'FOOTER', '🔍 Verificando função SafetyMails', {
            email: v,
            validacaoLocalPassou: true,
            funcaoExiste: typeof window.validarEmailSafetyMails === 'function',
            tipoFuncao: typeof window.validarEmailSafetyMails,
            funcaoDefinida: window.validarEmailSafetyMails !== undefined
          }, 'OPERATION', 'SIMPLE');
          
          if (typeof window.validarEmailSafetyMails === 'function') {
            window.novo_log('INFO', 'FOOTER', '✅ Função SafetyMails disponível, chamando...', { email: v }, 'OPERATION', 'SIMPLE');
            window.validarEmailSafetyMails(v).then(resp=>{
              if (resp && resp.Status) {
                const status = resp.Status;
                const domainStatus = resp.DomainStatus;
                const advice = resp.Advice;
                
                // Email inválido (Status: "INVALIDO")
                if (status === 'INVALIDO' || domainStatus === 'INVALIDO' || advice === 'Invalid') {
                  saWarnConfirmCancel({
                    title: 'E-mail Inválido',
                    html: `O e-mail informado:<br><br><b>${v}</b><br><br>não é válido segundo nosso verificador.<br><br>Por favor, verifique se digitou corretamente ou use outro endereço de e-mail.`,
                    cancelButtonText: 'Manter',
                    confirmButtonText: 'Corrigir',
                    icon: 'error'
                  }).then(r=>{ if (r.isConfirmed) $EMAIL.focus(); });
                }
                // Email pendente/desconhecido (Status: "PENDENTE")
                else if (status === 'PENDENTE' || domainStatus === 'UNKNOWN' || advice === 'Unknown') {
                  saWarnConfirmCancel({
                    title: 'E-mail Não Verificado',
                    html: `Não foi possível verificar o e-mail:<br><br><b>${v}</b><br><br>O endereço pode estar correto, mas nosso verificador não conseguiu confirmá-lo no momento.<br><br>Deseja corrigir ou prosseguir com este e-mail?`,
                    cancelButtonText: 'Prosseguir',
                    confirmButtonText: 'Corrigir',
                    icon: 'warning'
                  }).then(r=>{ if (r.isConfirmed) $EMAIL.focus(); });
                }
                // Email válido (Status: "VALIDO"): não mostrar alerta
                // else if (status === 'VALIDO') { /* não fazer nada - continuar fluxo normalmente */ }
              }
            }).catch((error)=>{
              // LOG DE ERRO: Capturar erros silenciosos
window.novo_log('ERROR', 'FOOTER', '❌ Erro ao chamar SafetyMails', {
                email: v,
                error: error.message,
                stack: error.stack
              }, 'ERROR_HANDLING', 'SIMPLE');
            });
          } else {
            // LOG DE AVISO: Função não disponível
window.novo_log('WARN', 'FOOTER', '⚠️ Função SafetyMails não disponível', {
              email: v,
              tipo: typeof window.validarEmailSafetyMails,
              funcaoDefinida: window.validarEmailSafetyMails !== undefined,
              todasFuncoes: Object.keys(window).filter(k => k.includes('validarEmail'))
            }, 'ERROR_HANDLING', 'SIMPLE');
          }
        });


        // CONTROLE MANUAL DO BOTÃO SUBMIT
        $('#submit_button_auto').on('click', function(e) {
          novo_log('DEBUG', 'DEBUG', '🎯 Botão CALCULE AGORA! clicado');
          e.preventDefault(); // Bloquear submit natural para validação
          e.stopPropagation();
          
          // Encontrar o formulário e disparar validação
          const $form = $(this).closest('form');
          if ($form.length) {
            novo_log('DEBUG', 'DEBUG', '🔍 Disparando validação manual do formulário');
            $form.trigger('submit');
          }
        });

        // SUBMIT — revalida tudo e oferece Corrigir / Prosseguir
        $('form').each(function(){
          const $form=$(this);
          
          $form.on('submit', function(ev){
            if ($form.data('validated-ok') === true) { $form.removeData('validated-ok'); return true; }
            if ($form.data('skip-validate') === true){ $form.removeData('skip-validate');  return true; }

            novo_log('DEBUG', 'DEBUG', '🔍 Submit do formulário interceptado');
            ev.preventDefault();
            ev.stopPropagation();
            if (typeof window.showLoading === 'function') window.showLoading('Validando seus dados…');

            Promise.all([
              $CPF.length ? (window.VALIDAR_PH3A ? (typeof window.validarCPFApi === 'function' ? window.validarCPFApi($CPF.val()) : Promise.resolve({ok: false})) : Promise.resolve({ok: typeof window.validarCPFAlgoritmo === 'function' ? window.validarCPFAlgoritmo($CPF.val()) : false})) : Promise.resolve({ok: true}),
              $CEP.length   ? (typeof window.validarCepViaCep === 'function' ? window.validarCepViaCep($CEP.val()) : Promise.resolve({ok:true}))  : Promise.resolve({ok:true}),
              $PLACA.length ? (typeof window.validarPlacaApi === 'function' ? window.validarPlacaApi($PLACA.val()) : Promise.resolve({ok:true})) : Promise.resolve({ok:true}),
              // TELEFONE no submit — considera incompleto como inválido
              ($DDD.length && $CEL.length && typeof window.onlyDigits === 'function')
                ? (function(){
                    const d = window.onlyDigits($DDD.val()).length;
                    const n = window.onlyDigits($CEL.val()).length;
                    if (d === 2 && n === 9) return (typeof window.validarTelefoneAsync === 'function' ? window.validarTelefoneAsync($DDD,$CEL) : Promise.resolve({ok:false}));    // completo → valida API
                    if (d === 2 && n > 0 && n < 9) return Promise.resolve({ok:false});  // incompleto → inválido
                    return Promise.resolve({ok:false}); // ddd incompleto ou vazio → inválido
                  })()
                : Promise.resolve({ok:false}),
              // E-mail: regex (bloqueante)
              $EMAIL.length ? Promise.resolve({ok: typeof window.validarEmailLocal === 'function' ? window.validarEmailLocal(($EMAIL.val()||'').trim()) : false}) : Promise.resolve({ok:true})
            ])
            .then(([cpfRes, cepRes, placaRes, telRes, mailRes])=>{
              if (typeof window.hideLoading === 'function') window.hideLoading();

              // autopreenche MARCA/ANO/TIPO de novo se validou placa
              if (placaRes.ok && placaRes.parsed && typeof window.setFieldValue === 'function'){
                if (placaRes.parsed.marcaTxt) window.setFieldValue('MARCA', placaRes.parsed.marcaTxt);
                if (placaRes.parsed.anoModelo) window.setFieldValue('ANO', placaRes.parsed.anoModelo);
                if (placaRes.parsed.tipoVeiculo) window.setFieldValue('TIPO-DE-VEICULO', placaRes.parsed.tipoVeiculo);
              }

              // autopreenche SEXO/DATA/ESTADO-CIVIL se validou CPF com API
              if (cpfRes.ok && cpfRes.parsed && window.VALIDAR_PH3A && typeof window.setFieldValue === 'function') {
                if (cpfRes.parsed.sexo) window.setFieldValue('SEXO', cpfRes.parsed.sexo);
                if (cpfRes.parsed.dataNascimento) window.setFieldValue('DATA-DE-NASCIMENTO', cpfRes.parsed.dataNascimento);
                if (cpfRes.parsed.estadoCivil) window.setFieldValue('ESTADO-CIVIL', cpfRes.parsed.estadoCivil);
              }

              const invalido = (!cpfRes.ok) || (!cepRes.ok) || (!placaRes.ok) || (!telRes.ok) || (!mailRes.ok);
              novo_log('DEBUG', 'DEBUG', '🔍 Dados inválidos?', invalido);

              if (!invalido){
                novo_log('DEBUG', 'DEBUG', '✅ Dados válidos - verificando RPA');
                
                // 🎯 CAPTURAR CONVERSÃO GTM - DADOS VÁLIDOS COM ENHANCED CONVERSIONS
                window.novo_log('INFO','GTM', '🎯 Registrando conversão - dados válidos');
                if (typeof window.dataLayer !== 'undefined') {
                  // Formatar telefone para E.164 (+55...) para Enhanced Conversions
                  let rawPhone = '';
                  if ($DDD.length && $CEL.length && typeof window.onlyDigits === 'function') {
                    const dddDigits = window.onlyDigits($DDD.val());
                    const celDigits = window.onlyDigits($CEL.val());
                    const combined = dddDigits + celDigits;
                    
                    // Validar tamanho (10-11 dígitos) antes de formatar
                    if (combined.length >= 10 && combined.length <= 11) {
                      // Se já começa com 55 (código do país), usar como está
                      if (combined.length === 12 && combined.startsWith('55')) {
                        rawPhone = '+' + combined;
                      } else {
                        // Adicionar prefixo +55 para números brasileiros
                        rawPhone = '+55' + combined;
                      }
                    }
                  }
                  
                  // Coletar email se disponível
                  const emailValue = ($EMAIL.length && $EMAIL.val()) ? $EMAIL.val().trim() : undefined;
                  
                  // Construir objeto user_data para Enhanced Conversions
                  const userData = {};
                  if (rawPhone) {
                    userData.phone_number = rawPhone;
                  }
                  if (emailValue) {
                    userData.email = emailValue;
                  }
                  
                  // Evento GTM com Enhanced Conversions
                  const gtmEventData = {
                    'event': 'form_submit_valid',
                    'form_type': 'cotacao_seguro',
                    'validation_status': 'valid'
                  };
                  
                  // Adicionar user_data apenas se houver dados
                  if (Object.keys(userData).length > 0) {
                    gtmEventData.user_data = userData;
                  }
                  
                  window.dataLayer.push(gtmEventData);
                  
                  // ✅ LOG ESPECÍFICO PARA ENHANCED CONVERSIONS
                  if (gtmEventData.user_data && gtmEventData.user_data.phone_number) {
                    window.novo_log('INFO', 'GTM', '✅ Enhanced Conversions enviado', {
                      event: gtmEventData.event,
                      phone_number: gtmEventData.user_data.phone_number,
                      has_email: !!gtmEventData.user_data.email,
                      user_data: gtmEventData.user_data
                    }, 'OPERATION', 'MEDIUM');
                  } else {
                    window.novo_log('WARN', 'GTM', '⚠️ Enhanced Conversions não enviado', {
                      event: gtmEventData.event,
                      reason: 'user_data ausente ou phone_number não formatado',
                      has_user_data: !!gtmEventData.user_data
                    }, 'OPERATION', 'MEDIUM');
                  }
                }
                
                if (window.rpaEnabled === true) {
                  window.novo_log('INFO','RPA', '🎯 RPA habilitado - iniciando processo RPA');
                  window.loadRPAScript()
                    .then(() => {
                      window.novo_log('INFO','RPA', '🎯 Script RPA carregado - executando processo');
                      if (window.MainPage && typeof window.MainPage.prototype.handleFormSubmit === 'function') {
                        const mainPageInstance = new window.MainPage();
                        mainPageInstance.handleFormSubmit($form[0]);
                      } else {
                        window.novo_log('WARN','RPA', '🎯 Função handleFormSubmit não encontrada - usando fallback');
                        $form.data('validated-ok', true);
                        if (typeof window.nativeSubmit === 'function') {
                          window.nativeSubmit($form);
                        } else {
                          $form[0].submit();
                        }
                      }
                    })
                    .catch((error) => {
                      window.novo_log('ERROR', 'RPA', '🎯 Erro ao carregar script RPA:', error, 'ERROR_HANDLING', 'SIMPLE');
                      window.novo_log('INFO','RPA', '🎯 Fallback para processamento Webflow');
                      $form.data('validated-ok', true);
                      if (typeof window.nativeSubmit === 'function') {
                        window.nativeSubmit($form);
                      } else {
                        $form[0].submit();
                      }
                    });
                } else {
                  window.novo_log('INFO','RPA', '🎯 RPA desabilitado - processando apenas com Webflow');
                  $form.data('validated-ok', true);
                  if (typeof window.nativeSubmit === 'function') {
                    window.nativeSubmit($form);
                  } else {
                    $form[0].submit();
                  }
                }
              } else {
                novo_log('DEBUG', 'DEBUG', '❌ Dados inválidos - mostrando SweetAlert');
                let linhas = "";
                if (!cpfRes.ok)       linhas += "• CPF inválido\n";
                if (!cepRes.ok)   linhas += "• CEP inválido\n";
                if (!placaRes.ok) linhas += "• Placa inválida\n";
                if (!telRes.ok)   linhas += "• Celular inválido\n";
                if (!mailRes.ok)  linhas += "• E-mail inválido\n";

                Swal.fire({
                  icon: 'info',
                  title: 'Atenção!',
                  html:
                    "⚠️ Os campos CPF, CEP, PLACA, CELULAR e E-MAIL corretamente preenchidos são necessários para efetuar o cálculo do seguro.\n\n" +
                    "Campos com problema:\n\n" + linhas + "\n" +
                    "Caso decida prosseguir assim mesmo, um especialista entrará em contato para coletar esses dados.",
                  showCancelButton: true,
                  confirmButtonText: 'Corrigir',
                  cancelButtonText: 'Prosseguir assim mesmo',
                  reverseButtons: true,
                  allowOutsideClick: false,
                  allowEscapeKey: true
                }).then(r=>{
                  if (r.isConfirmed){
                    // ✅ Usuário escolheu CORRIGIR (ENTER aciona aqui agora)
                    // Foca no primeiro campo com erro
                    if (!cpfRes.ok && $CPF.length)        { $CPF.focus(); return; }
                    if (!cepRes.ok && $CEP.length)    { $CEP.focus(); return; }
                    if (!placaRes.ok && $PLACA.length){ $PLACA.focus(); return; }
                    if (!telRes.ok && ($DDD.length && $CEL.length)) { $CEL.focus(); return; }
                    if (!mailRes.ok && $EMAIL.length) { $EMAIL.focus(); return; }
                  } else {
                    // Usuário escolheu PROSSEGUIR ASSIM MESMO
                    window.novo_log('INFO','RPA', '🎯 Usuário escolheu prosseguir com dados inválidos');
                    
                    // ⚠️ EVENTO REMOVIDO: form_submit_invalid_proceed não é mais necessário
                    // Apenas conversões válidas são rastreadas para Enhanced Conversions
                    
                    if (window.rpaEnabled === true) {
                      window.novo_log('INFO','RPA', '🎯 RPA habilitado - iniciando processo RPA com dados inválidos');
                      window.loadRPAScript()
                        .then(() => {
                          window.novo_log('INFO','RPA', '🎯 Script RPA carregado - executando processo com dados inválidos');
                          if (window.MainPage && typeof window.MainPage.prototype.handleFormSubmit === 'function') {
                            const mainPageInstance = new window.MainPage();
                            mainPageInstance.handleFormSubmit($form[0]);
                          } else {
                            window.novo_log('WARN','RPA', '🎯 Função handleFormSubmit não encontrada - usando fallback');
                            $form.data('skip-validate', true);
                            if (typeof window.nativeSubmit === 'function') {
                              window.nativeSubmit($form);
                            } else {
                              $form[0].submit();
                            }
                          }
                        })
                        .catch((error) => {
                          window.novo_log('ERROR', 'RPA', '🎯 Erro ao carregar script RPA:', error, 'ERROR_HANDLING', 'SIMPLE');
                          window.novo_log('INFO','RPA', '🎯 Fallback para processamento Webflow');
                          $form.data('skip-validate', true);
                          if (typeof window.nativeSubmit === 'function') {
                            window.nativeSubmit($form);
                          } else {
                            $form[0].submit();
                          }
                        });
                    } else {
                      window.novo_log('INFO','RPA', '🎯 RPA desabilitado - processando apenas com Webflow');
                      $form.data('skip-validate', true);
                      if (typeof window.nativeSubmit === 'function') {
                        window.nativeSubmit($form);
                      } else {
                        $form[0].submit();
                      }
                    }
                  }
                });
              }
            })
            .catch(_=>{
              if (typeof window.hideLoading === 'function') window.hideLoading();
              Swal.fire({
                icon: 'info',
                title: 'Não foi possível validar agora',
                html:  'Deseja corrigir os dados ou prosseguir assim mesmo?',
                showCancelButton: true,
                confirmButtonText: 'Corrigir',
                cancelButtonText: 'Prosseguir assim mesmo',
                reverseButtons: true,
                allowOutsideClick: false,
                allowEscapeKey: true
              }).then(r=>{
                if (r.isConfirmed) { 
                  // ✅ Usuário escolheu CORRIGIR (ENTER aciona aqui agora)
                  // Focar no primeiro campo do formulário
                  if ($CPF.length) { $CPF.focus(); }
                  else if ($CEP.length) { $CEP.focus(); }
                  else if ($PLACA.length) { $PLACA.focus(); }
                  else if ($DDD.length && $CEL.length) { $DDD.focus(); }
                  else if ($EMAIL.length) { $EMAIL.focus(); }
                } else {
                  // Usuário escolheu PROSSEGUIR ASSIM MESMO
                  window.novo_log('INFO','RPA', '🎯 Usuário escolheu prosseguir após erro de rede');
                  
                  // ⚠️ EVENTO REMOVIDO: form_submit_network_error_proceed não é mais necessário
                  // Apenas conversões válidas são rastreadas para Enhanced Conversions
                  
                  if (window.rpaEnabled === true) {
                    window.novo_log('INFO','RPA', '🎯 RPA habilitado - iniciando processo RPA após erro de rede');
                    window.loadRPAScript()
                      .then(() => {
                        window.novo_log('INFO','RPA', '🎯 Script RPA carregado - executando processo após erro de rede');
                        if (window.MainPage && typeof window.MainPage.prototype.handleFormSubmit === 'function') {
                          const mainPageInstance = new window.MainPage();
                          mainPageInstance.handleFormSubmit($form[0]);
                        } else {
                          window.novo_log('WARN','RPA', '🎯 Função handleFormSubmit não encontrada - usando fallback');
                          $form.data('skip-validate', true);
                          if (typeof window.nativeSubmit === 'function') {
                            window.nativeSubmit($form);
                          } else {
                            $form[0].submit();
                          }
                        }
                      })
                      .catch((error) => {
                        window.novo_log('ERROR', 'RPA', '🎯 Erro ao carregar script RPA:', error, 'ERROR_HANDLING', 'SIMPLE');
                        window.novo_log('INFO','RPA', '🎯 Fallback para processamento Webflow');
                        $form.data('skip-validate', true);
                        if (typeof window.nativeSubmit === 'function') {
                          window.nativeSubmit($form);
                        } else {
                          $form[0].submit();
                        }
                      });
                  } else {
                    window.novo_log('INFO','RPA', '🎯 RPA desabilitado - processando apenas com Webflow');
                    $form.data('skip-validate', true);
                    if (typeof window.nativeSubmit === 'function') {
                      window.nativeSubmit($form);
                    } else {
                      $form[0].submit();
                    }
                  }
                }
              });
            });
          });
        });
        
        // 6. Webflow Equipes
        window.Webflow ||= [];
        window.Webflow.push(() => {
          const LIST = document.querySelector('#Equipes-list');
          const OUT  = document.getElementById('qtde_colaboradores');

          const isVisible = (el) => {
            const st = getComputedStyle(el);
            return el.offsetParent !== null && st.display !== 'none' && st.visibility !== 'hidden' && st.opacity !== '0';
          };

          const recalc = () => {
            const n = LIST ? [...LIST.querySelectorAll('.w-dyn-item')].filter(isVisible).length : 0;
            if (OUT) OUT.textContent = String(n);
          };

          recalc(); // na carga

          // Atualiza em mudanças (filtros/paginação/dinâmicas)
          if (LIST) new MutationObserver(recalc).observe(LIST, {
            childList: true, subtree: true, attributes: true, attributeFilter: ['style','class']
          });
          document.addEventListener('fs-cmsfilter-update', recalc);       // Finsweet
          document.addEventListener('jetboost:filter:applied', recalc);    // Jetboost
          document.addEventListener('jetboost:pagination:loaded', recalc); // Jetboost
        });
        
        // 7. Debug RPA
        novo_log('DEBUG', 'DEBUG', '🔍 Iniciando verificação de injeção RPA...');

        // Função para verificar se a injeção foi bem-sucedida
        function debugRPAModule() {
          novo_log('DEBUG', 'DEBUG', '🔍 === VERIFICAÇÃO DE INJEÇÃO RPA ===');
          
          // 1. Verificar se window.rpaEnabled existe
          if (typeof window.rpaEnabled !== 'undefined') {
            novo_log('DEBUG', 'DEBUG', '✅ window.rpaEnabled encontrado:', window.rpaEnabled);
          } else {
            window.novo_log('ERROR','DEBUG', '❌ window.rpaEnabled NÃO encontrado!');
          }
          
          // 2. Verificar se loadRPAScript existe
          if (typeof window.loadRPAScript === 'function') {
            novo_log('DEBUG', 'DEBUG', '✅ window.loadRPAScript encontrado');
          } else {
            window.novo_log('ERROR','DEBUG', '❌ window.loadRPAScript NÃO encontrado!');
          }
          
          // 3. Verificar se jQuery está disponível
          if (typeof $ !== 'undefined') {
            novo_log('DEBUG', 'DEBUG', '✅ jQuery disponível:', $.fn.jquery);
          } else {
            window.novo_log('ERROR','DEBUG', '❌ jQuery NÃO disponível!');
          }
          
          // 4. Verificar se SweetAlert2 está disponível
          if (typeof Swal !== 'undefined') {
            novo_log('DEBUG', 'DEBUG', '✅ SweetAlert2 disponível');
          } else {
            window.novo_log('WARN','DEBUG', '⚠️ SweetAlert2 NÃO disponível (pode ser carregado dinamicamente)');
          }
          
          // 5. Verificar conflitos de nomes de função
          const globalFunctions = Object.keys(window).filter(key => typeof window[key] === 'function');
          const rpaFunctions = globalFunctions.filter(func => func.toLowerCase().includes('rpa') || func.toLowerCase().includes('load'));
          novo_log('DEBUG', 'DEBUG', '🔍 Funções globais relacionadas ao RPA:', rpaFunctions);
          
          // 6. Verificar se há elementos de formulário
          const forms = document.querySelectorAll('form');
          novo_log('DEBUG', 'DEBUG', '🔍 Formulários encontrados:', forms.length);
          
          // 7. Verificar se há botões de submit
          const submitButtons = document.querySelectorAll('button[type="submit"], input[type="submit"]');
          novo_log('DEBUG', 'DEBUG', '🔍 Botões de submit encontrados:', submitButtons.length);
          
          novo_log('DEBUG', 'DEBUG', '🔍 === FIM DA VERIFICAÇÃO ===');
        }

        // Função para testar carregamento dinâmico
        function testDynamicLoading() {
          novo_log('DEBUG', 'DEBUG', '🔍 Testando carregamento dinâmico...');
          
          if (typeof window.loadRPAScript === 'function') {
            novo_log('DEBUG', 'DEBUG', '🔍 Tentando carregar script RPA...');
            
            window.loadRPAScript()
              .then(() => {
                novo_log('DEBUG', 'DEBUG', '✅ Script RPA carregado com sucesso!');
                
                // Verificar se as classes RPA foram carregadas
                if (typeof window.MainPage !== 'undefined') {
                  novo_log('DEBUG', 'DEBUG', '✅ window.MainPage disponível');
                } else {
                  window.novo_log('ERROR','DEBUG', '❌ window.MainPage NÃO disponível após carregamento');
                }
                
                if (typeof window.ProgressModalRPA !== 'undefined') {
                  novo_log('DEBUG', 'DEBUG', '✅ window.ProgressModalRPA disponível');
                } else {
                  window.novo_log('ERROR','DEBUG', '❌ window.ProgressModalRPA NÃO disponível após carregamento');
                }
                
                if (typeof window.SpinnerTimer !== 'undefined') {
                  novo_log('DEBUG', 'DEBUG', '✅ window.SpinnerTimer disponível');
                } else {
                  window.novo_log('ERROR','DEBUG', '❌ window.SpinnerTimer NÃO disponível após carregamento');
                }
                
              })
              .catch(error => {
                window.novo_log('ERROR', 'DEBUG', '❌ Erro ao carregar script RPA:', error, 'ERROR_HANDLING', 'SIMPLE');
              });
          } else {
            window.novo_log('ERROR','DEBUG', '❌ window.loadRPAScript não está disponível para teste');
          }
        }

        // Função para detectar conflitos
        function detectConflicts() {
          novo_log('DEBUG', 'DEBUG', '🔍 === DETECÇÃO DE CONFLITOS ===');
          
          // Verificar se há múltiplas definições de funções
          const functionNames = [];
          const scripts = document.querySelectorAll('script');
          
          scripts.forEach((script, index) => {
            if (script.textContent) {
              const content = script.textContent;
              
              // Pular scripts que contêm apenas código de debug (evitar detectar a si mesmo)
              if (content.includes('detectConflicts') && content.includes('DEBUG] === DETECÇÃO DE CONFLITOS ===')) {
                return; // Pular este script
              }
              
              // Verificar se há DEFINIÇÕES reais de loadRPAScript (não apenas menções)
              if (content.includes('window.loadRPAScript =') || content.includes('function loadRPAScript(')) {
                functionNames.push(`Script ${index + 1}: loadRPAScript`);
              }
              
              // Verificar se há DEFINIÇÕES reais de rpaEnabled (não apenas menções)
              if (content.includes('window.rpaEnabled =') || content.includes('var rpaEnabled') || content.includes('let rpaEnabled') || content.includes('const rpaEnabled')) {
                functionNames.push(`Script ${index + 1}: rpaEnabled`);
              }
            }
          });
          
          if (functionNames.length > 1) {
            window.novo_log('WARN', 'DEBUG', '⚠️ Possível conflito detectado - múltiplas definições:', functionNames, 'ERROR_HANDLING', 'SIMPLE');
          } else {
            novo_log('DEBUG', 'DEBUG', '✅ Nenhum conflito de múltiplas definições detectado');
          }
          
          // Interceptação de console.error removida - não é mais necessária
          // novo_log() está disponível e pode ser usado diretamente para logs de debug
          // Se necessário detectar erros, usar window.addEventListener('error') ao invés de interceptar console.error
          
          novo_log('DEBUG', 'DEBUG', '🔍 === FIM DA DETECÇÃO DE CONFLITOS ===');
        }

        // Executar verificações após DOM estar pronto
        if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', () => {
            setTimeout(debugRPAModule, 100);
            setTimeout(detectConflicts, 200);
          });
        } else {
          setTimeout(debugRPAModule, 100);
          setTimeout(detectConflicts, 200);
        }

        // Expor funções de debug globalmente para teste manual
        window.debugRPAModule = debugRPAModule;
        window.testDynamicLoading = testDynamicLoading;
        window.detectConflicts = detectConflicts;

        novo_log('DEBUG', 'DEBUG', '🔍 Funções de debug disponíveis:');
        novo_log('DEBUG', 'DEBUG', '  - window.debugRPAModule()');
        novo_log('DEBUG', 'DEBUG', '  - window.testDynamicLoading()');
        novo_log('DEBUG', 'DEBUG', '  - window.detectConflicts()');
      });
    }
    
    // Inicialização (aguarda DOM e dependências)
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function() {
        waitForDependencies(init);
      });
    } else {
      // DOM já está pronto, mas ainda precisamos verificar dependências
      waitForDependencies(init);
    }
    
  } catch (error) {
    // Usar console.error diretamente porque novo_log pode não estar definida ainda
    if (typeof window.novo_log === 'function') {
      window.novo_log('ERROR', 'UNIFIED', 'Erro crítico no Footer Code Unificado:', error, 'ERROR_HANDLING', 'SIMPLE');
      window.novo_log('ERROR', 'UNIFIED', 'Stack trace:', error.stack, 'ERROR_HANDLING', 'SIMPLE');
    } else {
      console.error('[CONFIG] ERRO CRÍTICO no Footer Code Unificado:', error);
      console.error('[CONFIG] Stack trace:', error.stack);
      // Se o erro for sobre variáveis do PHP não definidas, dar instrução clara
      if (error.message && error.message.includes('config_env.js.php')) {
        console.error('[CONFIG] SOLUÇÃO: Adicione <script src="https://dev.bssegurosimediato.com.br/config_env.js.php"></script> ANTES de FooterCodeSiteDefinitivoCompleto.js no Webflow Footer Code');
      }
    }
    // Não bloquear a página, mas registrar o erro
  }
})();





