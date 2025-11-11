<?php
/**
 * CONFIG_ENV.JS.PHP
 * 
 * Expõe variáveis de ambiente do Docker para JavaScript
 * 
 * Este arquivo lê as variáveis de ambiente do Docker e as expõe
 * como variáveis globais simples no JavaScript (NÃO objeto de configuração).
 * 
 * Variáveis expostas:
 * - window.APP_BASE_URL: URL base do ambiente (dev ou prod)
 * - window.APP_ENVIRONMENT: Ambiente atual (development ou production)
 */

header('Content-Type: application/javascript');

// Ler variáveis de ambiente do Docker
$base_url = $_ENV['APP_BASE_URL'] ?? '';
$environment = $_ENV['PHP_ENV'] ?? 'development';

if (empty($base_url)) {
    http_response_code(500);
    header('Content-Type: application/javascript');
    echo "console.error('[CONFIG] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');";
    echo "throw new Error('APP_BASE_URL não está definido');";
    exit;
}

// Expor como variáveis globais simples (NÃO objeto de configuração)
?>
window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;

// Função helper simples (opcional, para facilitar uso)
window.getEndpointUrl = function(endpoint) {
    if (!window.APP_BASE_URL) {
        // Verificar DEBUG_CONFIG antes de logar (FASE 11 - Correção MÉDIA)
        if (window.DEBUG_CONFIG && 
            (window.DEBUG_CONFIG.enabled !== false && window.DEBUG_CONFIG.enabled !== 'false')) {
            if (window.console && window.console.warn) {
                console.warn('[CONFIG] APP_BASE_URL não disponível');
            }
        }
        return null;
    }
    return window.APP_BASE_URL + '/' + endpoint.replace(/^\//, '');
};

