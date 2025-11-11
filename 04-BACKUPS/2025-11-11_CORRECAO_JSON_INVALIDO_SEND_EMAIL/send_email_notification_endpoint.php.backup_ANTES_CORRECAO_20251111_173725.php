<?php
/**
 * PROJETO: ENDPOINT DE NOTIFICAÇÃO EMAIL ADMINISTRADORES
 * INÍCIO: 03/11/2025 19:00
 * 
 * VERSÃO: 1.3 - Correção validação JSON (sanitização e logging)
 * 
 * Endpoint dedicado APENAS para receber dados do JavaScript
 * e enviar notificações por email aos administradores via Amazon SES.
 * 
 * Este endpoint é chamado pelo FooterCodeSiteDefinitivoCompleto.js
 * após sucesso nas chamadas do modal para add_flyingdonkeys_v2.php
 * 
 * ⚠️ IMPORTANTE: Este endpoint NÃO processa dados de CRM,
 * apenas envia emails de notificação.
 * 
 * CORREÇÕES VERSÃO 1.2:
 * - CORS corrigido: usando setCorsHeaders() do config.php (valida origem)
 * - Removido header hardcoded 'Access-Control-Allow-Origin: *' que conflitava com Nginx
 */

// Incluir config.php ANTES de qualquer header ou output para usar setCorsHeaders()
require_once __DIR__ . '/config.php';

// Headers CORS (usar função do config.php para evitar duplicação com Nginx)
// IMPORTANTE: Headers devem ser enviados ANTES de qualquer output
header('Content-Type: application/json; charset=utf-8');
// Usar setCorsHeaders() do config.php - valida origem e envia apenas um valor no header
setCorsHeaders();
// Adicionar headers específicos do send_email_notification_endpoint.php após setCorsHeaders()
header('Access-Control-Allow-Headers: Content-Type');

// Nota: setCorsHeaders() já trata requisições OPTIONS (preflight) e envia os headers corretos
// Não é necessário código adicional para OPTIONS

// Apenas POST permitido
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'error' => 'Method not allowed. Use POST.'
    ]);
    exit;
}

// Carregar sistema de logging profissional
require_once __DIR__ . '/ProfessionalLogger.php';

// Carregar função de notificação
require_once __DIR__ . '/send_admin_notification_ses.php';

// Inicializar logger
$logger = new ProfessionalLogger();

try {
    // Ler dados do POST
    $rawInput = file_get_contents('php://input');
    
    // Verificar se o input não está vazio
    if (empty($rawInput)) {
        throw new Exception('JSON vazio recebido');
    }
    
    // Tentar decodificar JSON
    $data = json_decode($rawInput, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        // Logar preview do JSON inválido para debug (limitado a 500 caracteres)
        $preview = substr($rawInput, 0, 500);
        error_log("[EMAIL-ENDPOINT] JSON inválido recebido. Preview: " . $preview);
        throw new Exception('JSON inválido: ' . json_last_error_msg());
    }
    
    // Validar dados mínimos
    $ddd = $data['ddd'] ?? '';
    $celular = $data['celular'] ?? '';
    
    // Permitir valores padrão do sistema de logging (00 e 000000000)
    $isLoggingSystem = ($ddd === '00' && $celular === '000000000' && isset($data['erro']));
    
    if (!$isLoggingSystem && (empty($ddd) || empty($celular))) {
        throw new Exception('DDD e CELULAR são obrigatórios');
    }
    
    // Preparar dados para função de envio
    $emailData = [
        'ddd' => $ddd,
        'celular' => $celular,
        'cpf' => $data['cpf'] ?? 'Não informado',
        'nome' => $data['nome'] ?? 'Não informado',
        'email' => $data['email'] ?? 'Não informado',
        'cep' => $data['cep'] ?? 'Não informado',
        'placa' => $data['placa'] ?? 'Não informado',
        'gclid' => $data['gclid'] ?? 'Não informado',
        'momento' => $data['momento'] ?? 'unknown',
        'momento_descricao' => $data['momento_descricao'] ?? 'Notificação',
        'momento_emoji' => $data['momento_emoji'] ?? '📧',
        // NOVO: Informações de erro (se presente)
        'erro' => $data['erro'] ?? null
    ];
    
    // Enviar email
    $result = enviarNotificacaoAdministradores($emailData);
    
    // Log de resultado usando sistema profissional
    $logLevel = $result['success'] ? 'INFO' : 'WARN';
    $logMessage = sprintf(
        "[EMAIL-ENDPOINT] Momento: %s | DDD: %s | Celular: %s*** | Sucesso: %s | Erro: %s",
        $emailData['momento'],
        $ddd,
        substr($celular, 0, 3),
        $result['success'] ? 'SIM' : 'NÃO',
        ($emailData['erro'] !== null) ? 'SIM' : 'NÃO'
    );
    $logger->log($logLevel, $logMessage, [
        'momento' => $emailData['momento'],
        'ddd' => $ddd,
        'celular_masked' => substr($celular, 0, 3) . '***',
        'success' => $result['success'],
        'has_error' => ($emailData['erro'] !== null),
        'total_sent' => $result['total_sent'] ?? 0,
        'total_failed' => $result['total_failed'] ?? 0
    ], 'EMAIL');
    
    // Retornar resultado
    // HTTP 200 mesmo quando success=false, pois a requisição foi processada corretamente
    // (diferente de erro de validação ou processamento)
    http_response_code(200);
    echo json_encode($result);
    
} catch (Exception $e) {
    // Log de erro usando sistema profissional
    if (isset($logger)) {
        $logger->error("[EMAIL-ENDPOINT] Erro: " . $e->getMessage(), [
            'exception' => get_class($e),
            'file' => $e->getFile(),
            'line' => $e->getLine()
        ], 'EMAIL', $e);
    } else {
        error_log("[EMAIL-ENDPOINT] Erro: " . $e->getMessage());
    }
    
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}

