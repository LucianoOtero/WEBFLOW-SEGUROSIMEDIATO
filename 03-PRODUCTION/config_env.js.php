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
 * - window.APILAYER_KEY: Chave da API Layer
 * - window.SAFETY_TICKET: Ticket SafetyMails
 * - window.SAFETY_API_KEY: Chave API SafetyMails
 * - window.VIACEP_BASE_URL: URL base ViaCEP
 * - window.APILAYER_BASE_URL: URL base API Layer
 * - window.SAFETYMAILS_OPTIN_BASE: URL base SafetyMails Optin
 * - window.RPA_API_BASE_URL: URL base API RPA
 * - window.SAFETYMAILS_BASE_DOMAIN: Domínio base SafetyMails
 */

header('Content-Type: application/javascript');

// Ler variáveis de ambiente do Docker (variáveis existentes)
$base_url = $_ENV['APP_BASE_URL'] ?? '';
$environment = $_ENV['PHP_ENV'] ?? 'development';

// Novas variáveis (movidas de data-attributes do Webflow)
$apilayer_key = $_ENV['APILAYER_KEY'] ?? '';
$safety_ticket = $_ENV['SAFETY_TICKET'] ?? '';
$safety_api_key = $_ENV['SAFETY_API_KEY'] ?? '';
$viacep_base_url = $_ENV['VIACEP_BASE_URL'] ?? '';
$apilayer_base_url = $_ENV['APILAYER_BASE_URL'] ?? '';
$safetymails_optin_base = $_ENV['SAFETYMAILS_OPTIN_BASE'] ?? '';
$rpa_api_base_url = $_ENV['RPA_API_BASE_URL'] ?? '';
$safetymails_base_domain = $_ENV['SAFETYMAILS_BASE_DOMAIN'] ?? '';

// Validação fail-fast para variável crítica existente
if (empty($base_url)) {
    http_response_code(500);
    header('Content-Type: application/javascript');
    echo "console.error('[CONFIG] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');";
    echo "throw new Error('APP_BASE_URL não está definido');";
    exit;
}

// Validação fail-fast para variáveis críticas (API keys)
$critical_vars = [
    'APILAYER_KEY' => $apilayer_key,
    'SAFETY_TICKET' => $safety_ticket,
    'SAFETY_API_KEY' => $safety_api_key
];

foreach ($critical_vars as $name => $value) {
    if (empty($value)) {
        http_response_code(500);
        header('Content-Type: application/javascript');
        echo "console.error('[CONFIG] ERRO CRÍTICO: {$name} não está definido nas variáveis de ambiente');";
        echo "throw new Error('{$name} não está definido');";
        exit;
    }
}

// Expor como variáveis globais simples (NÃO objeto de configuração)
?>
window.APP_BASE_URL = <?php echo json_encode($base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APP_ENVIRONMENT = <?php echo json_encode($environment); ?>;

// Novas variáveis expostas (movidas de data-attributes do Webflow)
window.APILAYER_KEY = <?php echo json_encode($apilayer_key, JSON_UNESCAPED_SLASHES); ?>;
window.SAFETY_TICKET = <?php echo json_encode($safety_ticket, JSON_UNESCAPED_SLASHES); ?>;
window.SAFETY_API_KEY = <?php echo json_encode($safety_api_key, JSON_UNESCAPED_SLASHES); ?>;
window.VIACEP_BASE_URL = <?php echo json_encode($viacep_base_url, JSON_UNESCAPED_SLASHES); ?>;
window.APILAYER_BASE_URL = <?php echo json_encode($apilayer_base_url, JSON_UNESCAPED_SLASHES); ?>;
window.SAFETYMAILS_OPTIN_BASE = <?php echo json_encode($safetymails_optin_base, JSON_UNESCAPED_SLASHES); ?>;
window.RPA_API_BASE_URL = <?php echo json_encode($rpa_api_base_url, JSON_UNESCAPED_SLASHES); ?>;
window.SAFETYMAILS_BASE_DOMAIN = <?php echo json_encode($safetymails_base_domain, JSON_UNESCAPED_SLASHES); ?>;

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

