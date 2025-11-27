/**
 * CONFIGURAÇÃO DO SENTRY - ARQUIVO LOCAL (NÃO VERSIONAR)
 * 
 * ⚠️ IMPORTANTE: Este arquivo contém informações sensíveis e NÃO deve ser versionado no GitHub
 * 
 * Este arquivo está no .gitignore e não será commitado.
 * 
 * Para usar:
 * 1. Copiar este arquivo para o servidor
 * 2. Incluir no HTML ou JavaScript conforme necessário
 * 3. NUNCA commitar este arquivo no Git
 */

// ============================================================================
// CONFIGURAÇÃO BÁSICA DO SENTRY
// ============================================================================

// Script do Sentry (incluir no HTML antes de </body>)
const SENTRY_SCRIPT = `
<script
  src="https://js-de.sentry-cdn.com/9cbeefde9ce7c0b959b51a4c5e6e52dd.min.js"
  crossorigin="anonymous"
></script>
`;

// Inicialização do Sentry (incluir após o script acima)
const SENTRY_INIT = `
<script>
  Sentry.onLoad(function() {
    Sentry.init({
      dsn: "https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424",
      environment: window.location.hostname.includes('dev') ? 'dev' : 'prod',
      tracesSampleRate: 0.1, // 10% das transações para performance
      
      // Sanitizar dados sensíveis ANTES de enviar
      beforeSend(event, hint) {
        // Remover dados sensíveis
        if (event.extra) {
          delete event.extra.ddd;
          delete event.extra.celular;
          delete event.extra.cpf;
          delete event.extra.nome;
          delete event.extra.email;
          delete event.extra.phone;
          delete event.extra.phone_number;
        }
        
        // Manter apenas metadados seguros
        return event;
      },
      
      // Ignorar erros específicos (opcional)
      ignoreErrors: [
        'ResizeObserver loop limit exceeded',
        'Non-Error promise rejection captured'
      ]
    });
  });
</script>
`;

// ============================================================================
// EXEMPLOS DE USO
// ============================================================================

/**
 * ERROR / EXCEPTION TRACKING
 * 
 * Use Sentry.captureException(error) para capturar exceções
 * Use em blocos try/catch ou áreas onde exceções são esperadas
 */
function exemploCaptureException() {
  try {
    // código que pode falhar
  } catch (error) {
    Sentry.captureException(error, {
      tags: {
        component: 'MODAL',
        action: 'octadesk_initial'
      },
      extra: {
        attempt: 1,
        duration: 35000
      }
    });
  }
}

/**
 * CUSTOM SPAN INSTRUMENTATION - Component Actions
 * 
 * Criar spans para ações significativas como cliques de botão, chamadas de API, etc.
 */
function exemploSpanComponent() {
  Sentry.startSpan(
    {
      op: "ui.click",
      name: "Test Button Click",
    },
    (span) => {
      const value = "some config";
      const metric = "some metric";

      // Métricas podem ser adicionadas ao span
      span.setAttribute("config", value);
      span.setAttribute("metric", metric);

      doSomething();
    },
  );
}

/**
 * CUSTOM SPAN INSTRUMENTATION - API Calls
 * 
 * Criar spans para chamadas de API
 */
async function exemploSpanAPI(userId) {
  return Sentry.startSpan(
    {
      op: "http.client",
      name: `GET /api/users/${userId}`,
    },
    async () => {
      const response = await fetch(`/api/users/${userId}`);
      const data = await response.json();
      return data;
    },
  );
}

/**
 * LOGS
 * 
 * Para usar logs, importar Sentry usando: import * as Sentry from "@sentry/browser"
 * Habilitar logging: Sentry.init({ _experiments: { enableLogs: true } })
 * Referenciar logger: const { logger } = Sentry
 */
function exemploLogs() {
  // Configuração baseline
  /*
  import * as Sentry from "@sentry/browser";

  Sentry.init({
    dsn: "https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424",
    _experiments: {
      enableLogs: true,
    },
  });
  */

  // Logger Integration
  /*
  Sentry.init({
    dsn: "https://9cbeefde9ce7c0b959b51a4c5e6e52dd@o4510432472530944.ingest.de.sentry.io/4510432482361424",
    integrations: [
      // Enviar console.log, console.warn, e console.error como logs para Sentry
      Sentry.consoleLoggingIntegration({ levels: ["log", "warn", "error"] }),
    ],
  });
  */

  // Exemplos de uso do logger
  /*
  import * as Sentry from "@sentry/browser";
  const { logger } = Sentry;

  logger.trace("Starting database connection", { database: "users" });
  logger.debug(logger.fmt`Cache miss for user: ${userId}`);
  logger.info("Updated profile", { profileId: 345 });
  logger.warn("Rate limit reached for endpoint", {
    endpoint: "/api/results/",
    isEnterprise: false,
  });
  logger.error("Failed to process payment", {
    orderId: "order_123",
    amount: 99.99,
  });
  logger.fatal("Database connection pool exhausted", {
    database: "users",
    activeConnections: 100,
  });
  */
}

// ============================================================================
// FUNÇÃO PARA LOGAR ERROS (USAR NO CÓDIGO)
// ============================================================================

/**
 * Função para logar erro no Sentry
 * 
 * @param {Object} errorData - Dados do erro
 * @param {string} errorData.error - Mensagem de erro
 * @param {string} errorData.component - Componente onde erro ocorreu
 * @param {string} errorData.action - Ação que causou erro
 * @param {number} errorData.attempt - Número da tentativa
 * @param {number} errorData.duration - Duração em ms
 */
function logErrorToSentry(errorData) {
  if (typeof Sentry === 'undefined') {
    return; // Sentry não disponível
  }
  
  try {
    Sentry.captureMessage(errorData.error || 'unknown_error', {
      level: 'error',
      tags: {
        component: errorData.component || 'MODAL',
        action: errorData.action || 'unknown',
        environment: errorData.environment || (window.location.hostname.includes('dev') ? 'dev' : 'prod')
      },
      extra: {
        error: errorData.error,
        attempt: errorData.attempt,
        duration: errorData.duration,
        url: window.location.href,
        userAgent: navigator.userAgent,
        // ⚠️ Dados sensíveis serão removidos pelo beforeSend
        ddd: errorData.ddd,
        celular: errorData.celular,
      }
    });
  } catch (err) {
    console.error('Falha ao logar no Sentry:', err);
  }
}

// ============================================================================
// FUNÇÃO DE TESTE (PENDENTE - CRIAR PROJETO PRIMEIRO)
// ============================================================================

/**
 * ⚠️ PENDENTE: Criar projeto antes de implementar
 * 
 * Função de teste para validar integração do Sentry
 * 
 * Exemplo:
 * myUndefinedFunction();
 * 
 * Esta função deve causar erro e ser capturada pelo Sentry
 * para validar que a integração está funcionando corretamente.
 */
function myUndefinedFunction() {
  // Esta função não está definida e causará erro
  // Útil para testar se Sentry está capturando erros corretamente
  // ⚠️ NÃO implementar ainda - aguardar criação do projeto
}

// ============================================================================
// EXPORTAR CONFIGURAÇÕES (se necessário)
// ============================================================================

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    SENTRY_SCRIPT,
    SENTRY_INIT,
    logErrorToSentry,
    myUndefinedFunction
  };
}

