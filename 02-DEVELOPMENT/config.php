<?php
/**
 * CONFIG.PHP
 * 
 * Arquivo central de configuração usando variáveis de ambiente do Docker
 * 
 * Este arquivo lê todas as variáveis de ambiente do Docker e fornece
 * funções helper para acesso seguro e consistente às configurações.
 * 
 * VERSÃO: 2.0.0
 * DATA: 10/11/2025
 * 
 * SUBSTITUI: config/dev_config.php (que será eliminado)
 */

// ==================== VARIÁVEIS DE AMBIENTE PRINCIPAIS ====================

/**
 * Obter ambiente atual (development/production)
 * @return string 'development' ou 'production'
 */
function getEnvironment() {
    if (empty($_ENV['PHP_ENV'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PHP_ENV não está definido nas variáveis de ambiente');
        throw new RuntimeException('PHP_ENV não está definido nas variáveis de ambiente');
    }
    return $_ENV['PHP_ENV'];
}

/**
 * Verificar se está em ambiente de desenvolvimento
 * @return bool
 */
function isDevelopment() {
    return getEnvironment() === 'development';
}

/**
 * Verificar se está em ambiente de produção
 * @return bool
 */
function isProduction() {
    return getEnvironment() === 'production';
}

/**
 * Obter diretório base físico (APP_BASE_DIR)
 * Usar para includes locais, file_get_contents (arquivo local), etc.
 * @return string Caminho físico no servidor
 */
function getBaseDir() {
    $baseDir = $_ENV['APP_BASE_DIR'] ?? '';
    if (empty($baseDir)) {
        error_log('[CONFIG] ERRO CRÍTICO: APP_BASE_DIR não está definido nas variáveis de ambiente');
        throw new RuntimeException('APP_BASE_DIR não está definido nas variáveis de ambiente');
    }
    // Garantir que não termina com barra
    return rtrim($baseDir, '/\\');
}

/**
 * Obter URL base HTTP (APP_BASE_URL)
 * Usar para requisições HTTP, fetch, curl, etc.
 * @return string URL base (ex: https://dev.bssegurosimediato.com.br)
 */
function getBaseUrl() {
    $baseUrl = $_ENV['APP_BASE_URL'] ?? '';
    if (empty($baseUrl)) {
        error_log('[CONFIG] ERRO CRÍTICO: APP_BASE_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('APP_BASE_URL não está definido nas variáveis de ambiente');
    }
    // Garantir que não termina com barra
    return rtrim($baseUrl, '/');
}

/**
 * Obter origens permitidas para CORS (APP_CORS_ORIGINS)
 * @return array Array de origens permitidas
 */
function getCorsOrigins() {
    $corsOrigins = $_ENV['APP_CORS_ORIGINS'] ?? '';
    if (empty($corsOrigins)) {
        error_log('[CONFIG] ERRO CRÍTICO: APP_CORS_ORIGINS não está definido nas variáveis de ambiente');
        throw new RuntimeException('APP_CORS_ORIGINS não está definido nas variáveis de ambiente');
    }
    // Separar por vírgula e limpar espaços
    $origins = array_map('trim', explode(',', $corsOrigins));
    return array_filter($origins); // Remover vazios
}

/**
 * Verificar se uma origem é permitida para CORS
 * @param string $origin Origem a verificar
 * @return bool
 */
function isCorsOriginAllowed($origin) {
    $allowedOrigins = getCorsOrigins();
    return in_array($origin, $allowedOrigins, true);
}

/**
 * Configurar headers CORS baseado na origem da requisição
 * @param string|null $origin Origem da requisição (opcional, pega de $_SERVER)
 */
function setCorsHeaders($origin = null) {
    if ($origin === null) {
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    }
    
    if (!empty($origin) && isCorsOriginAllowed($origin)) {
        header('Access-Control-Allow-Origin: ' . $origin);
    }
    
    header('Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE');
    header('Access-Control-Allow-Headers: Content-Type, X-Webflow-Signature, X-Webflow-Timestamp, X-Requested-With, Authorization');
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400'); // 24 horas
    
    // Responder a requisições OPTIONS (preflight)
    if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
        http_response_code(200);
        header('Content-Length: 0');
        header('Content-Type: text/plain');
        exit(0);
    }
}

// ==================== VARIÁVEIS DE BANCO DE DADOS ====================

/**
 * Obter configuração do banco de dados de logs
 * @return array Array com host, port, name, user, pass
 */
function getDatabaseConfig() {
    $config = [
        'host' => $_ENV['LOG_DB_HOST'] ?? '',
        'port' => (int)($_ENV['LOG_DB_PORT'] ?? 0),
        'name' => $_ENV['LOG_DB_NAME'] ?? '',
        'user' => $_ENV['LOG_DB_USER'] ?? '',
        'pass' => $_ENV['LOG_DB_PASS'] ?? ''
    ];
    
    // Validar campos obrigatórios
    $required = ['host', 'name', 'user', 'pass'];
    foreach ($required as $field) {
        if (empty($config[$field])) {
            error_log("[CONFIG] ERRO CRÍTICO: LOG_DB_{$field} não está definido nas variáveis de ambiente");
            throw new RuntimeException("LOG_DB_{$field} não está definido nas variáveis de ambiente");
        }
    }
    
    // Port padrão se não definido
    if ($config['port'] === 0) {
        $config['port'] = 3306;
    }
    
    return $config;
}

// ==================== VARIÁVEIS DE APIs EXTERNAS ====================

/**
 * Obter URL do EspoCRM
 * @return string URL do EspoCRM
 */
function getEspoCrmUrl() {
    $url = $_ENV['ESPOCRM_URL'] ?? '';
    if (empty($url)) {
        error_log('[CONFIG] ERRO CRÍTICO: ESPOCRM_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('ESPOCRM_URL não está definido nas variáveis de ambiente');
    }
    return $url;
}

/**
 * Obter API Key do EspoCRM
 * @return string API Key
 */
function getEspoCrmApiKey() {
    if (empty($_ENV['ESPOCRM_API_KEY'])) {
        error_log('[CONFIG] ERRO CRÍTICO: ESPOCRM_API_KEY não está definido nas variáveis de ambiente');
        throw new RuntimeException('ESPOCRM_API_KEY não está definido nas variáveis de ambiente');
    }
    return $_ENV['ESPOCRM_API_KEY'];
}

/**
 * Obter Secret do Webflow para FlyingDonkeys
 * @return string Secret
 */
function getWebflowSecretFlyingDonkeys() {
    if (empty($_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'])) {
        error_log('[CONFIG] ERRO CRÍTICO: WEBFLOW_SECRET_FLYINGDONKEYS não está definido nas variáveis de ambiente');
        throw new RuntimeException('WEBFLOW_SECRET_FLYINGDONKEYS não está definido nas variáveis de ambiente');
    }
    return $_ENV['WEBFLOW_SECRET_FLYINGDONKEYS'];
}

/**
 * Obter Secret do Webflow para OctaDesk
 * @return string Secret
 */
function getWebflowSecretOctaDesk() {
    if (empty($_ENV['WEBFLOW_SECRET_OCTADESK'])) {
        error_log('[CONFIG] ERRO CRÍTICO: WEBFLOW_SECRET_OCTADESK não está definido nas variáveis de ambiente');
        throw new RuntimeException('WEBFLOW_SECRET_OCTADESK não está definido nas variáveis de ambiente');
    }
    return $_ENV['WEBFLOW_SECRET_OCTADESK'];
}

/**
 * Obter API Key do OctaDesk
 * @return string API Key
 */
function getOctaDeskApiKey() {
    if (empty($_ENV['OCTADESK_API_KEY'])) {
        error_log('[CONFIG] ERRO CRÍTICO: OCTADESK_API_KEY não está definido nas variáveis de ambiente');
        throw new RuntimeException('OCTADESK_API_KEY não está definido nas variáveis de ambiente');
    }
    return $_ENV['OCTADESK_API_KEY'];
}

/**
 * Obter URL base da API OctaDesk
 * @return string URL base
 */
function getOctaDeskApiBase() {
    $base = $_ENV['OCTADESK_API_BASE'] ?? '';
    if (empty($base)) {
        error_log('[CONFIG] ERRO CRÍTICO: OCTADESK_API_BASE não está definido nas variáveis de ambiente');
        throw new RuntimeException('OCTADESK_API_BASE não está definido nas variáveis de ambiente');
    }
    return $base;
}

/**
 * Obter número remetente OctaDesk (OCTADESK_FROM)
 * @return string Número no formato E.164 (ex: +551132301422)
 */
function getOctaDeskFrom() {
    if (empty($_ENV['OCTADESK_FROM'])) {
        error_log('[CONFIG] ERRO CRÍTICO: OCTADESK_FROM não está definido nas variáveis de ambiente');
        throw new RuntimeException('OCTADESK_FROM não está definido nas variáveis de ambiente');
    }
    return $_ENV['OCTADESK_FROM'];
}

// ==================== VARIÁVEIS PH3A API ====================

/**
 * Obter username da API PH3A
 * @return string Username
 */
function getPh3aUsername() {
    if (empty($_ENV['PH3A_USERNAME'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PH3A_USERNAME não está definido nas variáveis de ambiente');
        throw new RuntimeException('PH3A_USERNAME não está definido nas variáveis de ambiente');
    }
    return $_ENV['PH3A_USERNAME'];
}

/**
 * Obter password da API PH3A
 * @return string Password
 */
function getPh3aPassword() {
    if (empty($_ENV['PH3A_PASSWORD'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PH3A_PASSWORD não está definido nas variáveis de ambiente');
        throw new RuntimeException('PH3A_PASSWORD não está definido nas variáveis de ambiente');
    }
    return $_ENV['PH3A_PASSWORD'];
}

/**
 * Obter API Key da API PH3A
 * @return string API Key
 */
function getPh3aApiKey() {
    if (empty($_ENV['PH3A_API_KEY'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PH3A_API_KEY não está definido nas variáveis de ambiente');
        throw new RuntimeException('PH3A_API_KEY não está definido nas variáveis de ambiente');
    }
    return $_ENV['PH3A_API_KEY'];
}

/**
 * Obter URL de login da API PH3A
 * @return string URL de login
 */
function getPh3aLoginUrl() {
    if (empty($_ENV['PH3A_LOGIN_URL'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PH3A_LOGIN_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('PH3A_LOGIN_URL não está definido nas variáveis de ambiente');
    }
    return $_ENV['PH3A_LOGIN_URL'];
}

/**
 * Obter URL de dados da API PH3A
 * @return string URL de dados
 */
function getPh3aDataUrl() {
    if (empty($_ENV['PH3A_DATA_URL'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PH3A_DATA_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('PH3A_DATA_URL não está definido nas variáveis de ambiente');
    }
    return $_ENV['PH3A_DATA_URL'];
}

// ==================== VARIÁVEIS PLACAFIPE API ====================

/**
 * Obter token da API PlacaFipe
 * @return string Token
 */
function getPlacaFipeApiToken() {
    if (empty($_ENV['PLACAFIPE_API_TOKEN'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PLACAFIPE_API_TOKEN não está definido nas variáveis de ambiente');
        throw new RuntimeException('PLACAFIPE_API_TOKEN não está definido nas variáveis de ambiente');
    }
    return $_ENV['PLACAFIPE_API_TOKEN'];
}

/**
 * Obter URL da API PlacaFipe
 * @return string URL
 */
function getPlacaFipeApiUrl() {
    if (empty($_ENV['PLACAFIPE_API_URL'])) {
        error_log('[CONFIG] ERRO CRÍTICO: PLACAFIPE_API_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('PLACAFIPE_API_URL não está definido nas variáveis de ambiente');
    }
    return $_ENV['PLACAFIPE_API_URL'];
}

// ==================== VARIÁVEIS AWS SES ====================

/**
 * Obter Access Key ID da AWS
 * @return string Access Key ID
 */
function getAwsAccessKeyId() {
    if (empty($_ENV['AWS_ACCESS_KEY_ID'])) {
        error_log('[CONFIG] ERRO CRÍTICO: AWS_ACCESS_KEY_ID não está definido nas variáveis de ambiente');
        throw new RuntimeException('AWS_ACCESS_KEY_ID não está definido nas variáveis de ambiente');
    }
    return $_ENV['AWS_ACCESS_KEY_ID'];
}

/**
 * Obter Secret Access Key da AWS
 * @return string Secret Access Key
 */
function getAwsSecretAccessKey() {
    if (empty($_ENV['AWS_SECRET_ACCESS_KEY'])) {
        error_log('[CONFIG] ERRO CRÍTICO: AWS_SECRET_ACCESS_KEY não está definido nas variáveis de ambiente');
        throw new RuntimeException('AWS_SECRET_ACCESS_KEY não está definido nas variáveis de ambiente');
    }
    return $_ENV['AWS_SECRET_ACCESS_KEY'];
}

/**
 * Obter região da AWS
 * @return string Região
 */
function getAwsRegion() {
    if (empty($_ENV['AWS_REGION'])) {
        error_log('[CONFIG] ERRO CRÍTICO: AWS_REGION não está definido nas variáveis de ambiente');
        throw new RuntimeException('AWS_REGION não está definido nas variáveis de ambiente');
    }
    return $_ENV['AWS_REGION'];
}

/**
 * Obter email remetente do AWS SES
 * @return string Email
 */
function getAwsSesFromEmail() {
    if (empty($_ENV['AWS_SES_FROM_EMAIL'])) {
        error_log('[CONFIG] ERRO CRÍTICO: AWS_SES_FROM_EMAIL não está definido nas variáveis de ambiente');
        throw new RuntimeException('AWS_SES_FROM_EMAIL não está definido nas variáveis de ambiente');
    }
    return $_ENV['AWS_SES_FROM_EMAIL'];
}

/**
 * Obter nome remetente do AWS SES
 * @return string Nome
 */
function getAwsSesFromName() {
    if (empty($_ENV['AWS_SES_FROM_NAME'])) {
        error_log('[CONFIG] ERRO CRÍTICO: AWS_SES_FROM_NAME não está definido nas variáveis de ambiente');
        throw new RuntimeException('AWS_SES_FROM_NAME não está definido nas variáveis de ambiente');
    }
    return $_ENV['AWS_SES_FROM_NAME'];
}

/**
 * Obter lista de emails de administradores do AWS SES
 * @return array Array de emails
 */
function getAwsSesAdminEmails() {
    $emails = $_ENV['AWS_SES_ADMIN_EMAILS'] ?? '';
    if (empty($emails)) {
        error_log('[CONFIG] ERRO CRÍTICO: AWS_SES_ADMIN_EMAILS não está definido nas variáveis de ambiente');
        throw new RuntimeException('AWS_SES_ADMIN_EMAILS não está definido nas variáveis de ambiente');
    }
    return array_map('trim', explode(',', $emails));
}

// ==================== VARIÁVEIS JAVASCRIPT CONFIG ====================

/**
 * Obter flag RPA Enabled (para JavaScript)
 * @return bool
 */
function getRpaEnabled() {
    $value = $_ENV['RPA_ENABLED'] ?? '';
    if ($value === '') {
        error_log('[CONFIG] ERRO CRÍTICO: RPA_ENABLED não está definido nas variáveis de ambiente');
        throw new RuntimeException('RPA_ENABLED não está definido nas variáveis de ambiente');
    }
    return filter_var($value, FILTER_VALIDATE_BOOLEAN);
}

/**
 * Obter flag Use Phone API (para JavaScript)
 * @return bool
 */
function getUsePhoneApi() {
    $value = $_ENV['USE_PHONE_API'] ?? '';
    if ($value === '') {
        error_log('[CONFIG] ERRO CRÍTICO: USE_PHONE_API não está definido nas variáveis de ambiente');
        throw new RuntimeException('USE_PHONE_API não está definido nas variáveis de ambiente');
    }
    return filter_var($value, FILTER_VALIDATE_BOOLEAN);
}

/**
 * Obter flag Validar PH3A (para JavaScript)
 * @return bool
 */
function getValidarPh3a() {
    $value = $_ENV['VALIDAR_PH3A'] ?? '';
    if ($value === '') {
        error_log('[CONFIG] ERRO CRÍTICO: VALIDAR_PH3A não está definido nas variáveis de ambiente');
        throw new RuntimeException('VALIDAR_PH3A não está definido nas variáveis de ambiente');
    }
    return filter_var($value, FILTER_VALIDATE_BOOLEAN);
}

/**
 * Obter API Key do APILayer (para JavaScript)
 * @return string API Key
 */
function getApiLayerKey() {
    if (empty($_ENV['APILAYER_KEY'])) {
        error_log('[CONFIG] ERRO CRÍTICO: APILAYER_KEY não está definido nas variáveis de ambiente');
        throw new RuntimeException('APILAYER_KEY não está definido nas variáveis de ambiente');
    }
    return $_ENV['APILAYER_KEY'];
}

/**
 * Obter Safety Ticket (para JavaScript)
 * @return string Ticket
 */
function getSafetyTicket() {
    if (empty($_ENV['SAFETY_TICKET'])) {
        error_log('[CONFIG] ERRO CRÍTICO: SAFETY_TICKET não está definido nas variáveis de ambiente');
        throw new RuntimeException('SAFETY_TICKET não está definido nas variáveis de ambiente');
    }
    return $_ENV['SAFETY_TICKET'];
}

/**
 * Obter Safety API Key (para JavaScript)
 * @return string API Key
 */
function getSafetyApiKey() {
    if (empty($_ENV['SAFETY_API_KEY'])) {
        error_log('[CONFIG] ERRO CRÍTICO: SAFETY_API_KEY não está definido nas variáveis de ambiente');
        throw new RuntimeException('SAFETY_API_KEY não está definido nas variáveis de ambiente');
    }
    return $_ENV['SAFETY_API_KEY'];
}

// ==================== VARIÁVEIS DE URLs DE APIs ====================

/**
 * Obter URL base do ViaCEP
 * @return string URL base
 */
function getViaCepBaseUrl() {
    if (empty($_ENV['VIACEP_BASE_URL'])) {
        error_log('[CONFIG] ERRO CRÍTICO: VIACEP_BASE_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('VIACEP_BASE_URL não está definido nas variáveis de ambiente');
    }
    return rtrim($_ENV['VIACEP_BASE_URL'], '/');
}

/**
 * Obter URL base do APILayer
 * @return string URL base
 */
function getApiLayerBaseUrl() {
    if (empty($_ENV['APILAYER_BASE_URL'])) {
        error_log('[CONFIG] ERRO CRÍTICO: APILAYER_BASE_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('APILAYER_BASE_URL não está definido nas variáveis de ambiente');
    }
    return rtrim($_ENV['APILAYER_BASE_URL'], '/');
}

/**
 * Obter URL base do SafetyMails Optin
 * @return string URL base
 */
function getSafetyMailsOptinBase() {
    if (empty($_ENV['SAFETYMAILS_OPTIN_BASE'])) {
        error_log('[CONFIG] ERRO CRÍTICO: SAFETYMAILS_OPTIN_BASE não está definido nas variáveis de ambiente');
        throw new RuntimeException('SAFETYMAILS_OPTIN_BASE não está definido nas variáveis de ambiente');
    }
    return rtrim($_ENV['SAFETYMAILS_OPTIN_BASE'], '/');
}

/**
 * Obter URL base da API RPA
 * @return string URL base
 */
function getRpaApiBaseUrl() {
    if (empty($_ENV['RPA_API_BASE_URL'])) {
        error_log('[CONFIG] ERRO CRÍTICO: RPA_API_BASE_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('RPA_API_BASE_URL não está definido nas variáveis de ambiente');
    }
    return rtrim($_ENV['RPA_API_BASE_URL'], '/');
}

/**
 * Obter URL da página de sucesso
 * @return string URL
 */
function getSuccessPageUrl() {
    if (empty($_ENV['SUCCESS_PAGE_URL'])) {
        error_log('[CONFIG] ERRO CRÍTICO: SUCCESS_PAGE_URL não está definido nas variáveis de ambiente');
        throw new RuntimeException('SUCCESS_PAGE_URL não está definido nas variáveis de ambiente');
    }
    return $_ENV['SUCCESS_PAGE_URL'];
}

// ==================== ARRAY DE CONFIGURAÇÃO (COMPATIBILIDADE) ====================

/**
 * Obter array completo de configuração (para compatibilidade com código legado)
 * @return array Array com todas as configurações
 */
function getConfig() {
    return [
        'environment' => getEnvironment(),
        'is_dev' => isDevelopment(),
        'is_prod' => isProduction(),
        'base_dir' => getBaseDir(),
        'base_url' => getBaseUrl(),
        'cors' => [
            'allowed_origins' => getCorsOrigins()
        ],
        'database' => getDatabaseConfig(),
        'espocrm' => [
            'url' => getEspoCrmUrl(),
            'api_key' => getEspoCrmApiKey()
        ],
        'webflow' => [
            'secret_flyingdonkeys' => getWebflowSecretFlyingDonkeys(),
            'secret_octadesk' => getWebflowSecretOctaDesk()
        ],
        'octadesk' => [
            'api_key' => getOctaDeskApiKey(),
            'api_base' => getOctaDeskApiBase()
        ],
        'ph3a' => [
            'username' => getPh3aUsername(),
            'password' => getPh3aPassword(),
            'api_key' => getPh3aApiKey(),
            'login_url' => getPh3aLoginUrl(),
            'data_url' => getPh3aDataUrl()
        ],
        'placafipe' => [
            'api_token' => getPlacaFipeApiToken(),
            'api_url' => getPlacaFipeApiUrl()
        ],
        'aws_ses' => [
            'access_key_id' => getAwsAccessKeyId(),
            'secret_access_key' => getAwsSecretAccessKey(),
            'region' => getAwsRegion(),
            'from_email' => getAwsSesFromEmail(),
            'from_name' => getAwsSesFromName(),
            'admin_emails' => getAwsSesAdminEmails()
        ],
        'javascript' => [
            'rpa_enabled' => getRpaEnabled(),
            'use_phone_api' => getUsePhoneApi(),
            'validar_ph3a' => getValidarPh3a(),
            'apilayer_key' => getApiLayerKey(),
            'safety_ticket' => getSafetyTicket(),
            'safety_api_key' => getSafetyApiKey()
        ],
        'api_urls' => [
            'viacep_base_url' => getViaCepBaseUrl(),
            'apilayer_base_url' => getApiLayerBaseUrl(),
            'safetymails_optin_base' => getSafetyMailsOptinBase(),
            'rpa_api_base_url' => getRpaApiBaseUrl(),
            'success_page_url' => getSuccessPageUrl()
        ]
    ];
}

// Expor array global para compatibilidade (se necessário)
$CONFIG = getConfig();

// ==================== FUNÇÕES HELPER PARA INCLUDES ====================

/**
 * Incluir arquivo usando APP_BASE_DIR
 * @param string $filePath Caminho relativo do arquivo (ex: 'class.php', 'ProfessionalLogger.php')
 * @return bool true se incluído com sucesso
 */
function requireFile($filePath) {
    $fullPath = getBaseDir() . '/' . ltrim($filePath, '/\\');
    if (file_exists($fullPath)) {
        require_once $fullPath;
        return true;
    }
    error_log("Config: Arquivo não encontrado: $fullPath");
    return false;
}

/**
 * Construir URL de endpoint usando APP_BASE_URL
 * @param string $endpoint Caminho do endpoint (ex: 'log_endpoint.php', '/add_flyingdonkeys.php')
 * @return string URL completa
 */
function getEndpointUrl($endpoint) {
    return getBaseUrl() . '/' . ltrim($endpoint, '/\\');
}

// ==================== CONSTANTES (OPCIONAL) ====================

// Definir constantes se não existirem (para compatibilidade)
if (!defined('APP_ENVIRONMENT')) {
    define('APP_ENVIRONMENT', getEnvironment());
}
if (!defined('APP_BASE_DIR')) {
    define('APP_BASE_DIR', getBaseDir());
}
if (!defined('APP_BASE_URL')) {
    define('APP_BASE_URL', getBaseUrl());
}
