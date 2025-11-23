<?php
/**
 * PROJETO: NOTIFICAÇÃO EMAIL ADMINISTRADORES VIA AMAZON SES
 * INÍCIO: 03/11/2025
 * 
 * VERSÃO: 2.0 - Sistema modular de templates de email
 * 
 * Função para enviar notificações para administradores
 * quando cliente preenche telefone corretamente no MODAL_WHATSAPP_DEFINITIVO
 * ou quando ocorrem erros no sistema de logging
 * 
 * USO:
 * require_once 'send_admin_notification_ses.php';
 * $resultado = enviarNotificacaoAdministradores($dados);
 */

// Carregar configuração AWS SES
require_once __DIR__ . '/aws_ses_config.php';

// Carregar sistema de templates de email
require_once __DIR__ . '/email_template_loader.php';

// Carregar AWS SDK se disponível
$awsSdkAvailable = false;
$awsSdkDebugLog = [];

$vendorPath = __DIR__ . '/vendor/autoload.php';
$awsSdkDebugLog[] = "Iniciando verificação AWS SDK";
$awsSdkDebugLog[] = "__DIR__: " . __DIR__;
$awsSdkDebugLog[] = "vendor/autoload.php path: " . $vendorPath;
$awsSdkDebugLog[] = "file_exists: " . (file_exists($vendorPath) ? "SIM" : "NÃO");

if (file_exists($vendorPath)) {
    $awsSdkDebugLog[] = "Arquivo existe, tentando carregar...";
    try {
        require $vendorPath;
        $awsSdkDebugLog[] = "Autoloader carregado com sucesso";
        
        // Verificar se a classe está disponível após carregar o autoloader
        $classExists = class_exists('Aws\Ses\SesClient');
        $awsSdkDebugLog[] = "class_exists('Aws\\Ses\\SesClient'): " . ($classExists ? "SIM" : "NÃO");
        
        if ($classExists) {
            $awsSdkAvailable = true;
            $awsSdkDebugLog[] = "✅ AWS SDK disponível - \$awsSdkAvailable = true";
        } else {
            error_log('⚠️ AWS SDK autoloader carregado, mas classe Aws\Ses\SesClient não encontrada!');
            $awsSdkDebugLog[] = "❌ Classe não encontrada após carregar autoloader";
        }
    } catch (Throwable $e) {
        error_log('⚠️ Erro ao carregar AWS SDK: ' . $e->getMessage());
        $awsSdkDebugLog[] = "❌ Erro ao carregar: " . $e->getMessage();
    }
} else {
    error_log('⚠️ AWS SDK não encontrado! Arquivo não existe: ' . $vendorPath);
    $awsSdkDebugLog[] = "❌ Arquivo vendor/autoload.php não existe";
}

// Log de debug (apenas em desenvolvimento)
if (isset($_ENV['PHP_ENV']) && $_ENV['PHP_ENV'] === 'development') {
    error_log('🔍 AWS SDK Debug: ' . implode(' | ', $awsSdkDebugLog));
}

/**
 * Envia notificação para administradores via Amazon SES
 * 
 * @param array $dados Dados do cliente (DDD, celular, CPF, nome, etc.)
 * @return array Resultado do envio ['success' => bool, 'total_sent' => int, 'results' => array]
 */
function enviarNotificacaoAdministradores($dados) {
    try {
        // Verificar se AWS SDK está disponível
        global $awsSdkAvailable;
        
        // Debug logging
        $debugInfo = [
            'awsSdkAvailable_isset' => isset($awsSdkAvailable),
            'awsSdkAvailable_value' => $awsSdkAvailable ?? 'NÃO DEFINIDA',
            'awsSdkAvailable_type' => isset($awsSdkAvailable) ? gettype($awsSdkAvailable) : 'N/A',
            'class_exists' => class_exists('Aws\Ses\SesClient'),
            '__DIR__' => __DIR__
        ];
        
        if (isset($_ENV['PHP_ENV']) && $_ENV['PHP_ENV'] === 'development') {
            error_log('🔍 enviarNotificacaoAdministradores Debug: ' . json_encode($debugInfo));
        }
        
        if (!$awsSdkAvailable) {
            return [
                'success' => false,
                'error' => 'AWS SDK não instalado. Execute: composer require aws/aws-sdk-php',
                'total_sent' => 0,
                'total_failed' => 0,
                'total_recipients' => 0,
                'results' => [],
                'debug' => $debugInfo
            ];
        }
        
        // Validar se credenciais estão configuradas
        if (!defined('AWS_ACCESS_KEY_ID') || !defined('AWS_SECRET_ACCESS_KEY')) {
            return [
                'success' => false,
                'error' => 'Credenciais AWS não configuradas',
                'total_sent' => 0,
                'total_failed' => 0,
                'total_recipients' => 0,
                'results' => [],
                'debug' => $debugInfo
            ];
        }

        // Criar cliente SES com timeout configurado para evitar travamento
        $sesClient = new \Aws\Ses\SesClient([
            'version' => 'latest',
            'region'  => AWS_REGION,
            'credentials' => [
                'key'    => AWS_ACCESS_KEY_ID,
                'secret' => AWS_SECRET_ACCESS_KEY,
            ],
            // Configuração de timeout HTTP para evitar processos travados
            'http' => [
                'timeout' => 10,           // Timeout total da requisição (segundos)
                'connect_timeout' => 5,    // Timeout de conexão (segundos)
            ],
        ]);

        // Renderizar template de email (sistema modular)
        // O carregador detecta automaticamente o tipo de template baseado nos dados
        $template = renderEmailTemplate($dados);
        
        $subject = $template['subject'];
        $htmlBody = $template['html'];
        $textBody = $template['text'];

        // Enviar para cada administrador
        $results = [];
        $successCount = 0;
        $failCount = 0;
        
        foreach (ADMIN_EMAILS as $adminEmail) {
            // Log de debug antes de tentar enviar
            error_log("🔍 DEBUG: Tentando enviar email para {$adminEmail} | Source: " . EMAIL_FROM_NAME . ' <' . EMAIL_FROM . '>');
            
            try {
                error_log("🔍 DEBUG: Chamando sesClient->sendEmail() para {$adminEmail}");
                $result = $sesClient->sendEmail([
                    'Source' => EMAIL_FROM_NAME . ' <' . EMAIL_FROM . '>',
                    'Destination' => [
                        'ToAddresses' => [$adminEmail],
                    ],
                    'Message' => [
                        'Subject' => [
                            'Data' => $subject,
                            'Charset' => 'UTF-8',
                        ],
                        'Body' => [
                            'Html' => [
                                'Data' => $htmlBody,
                                'Charset' => 'UTF-8',
                            ],
                            'Text' => [
                                'Data' => $textBody,
                                'Charset' => 'UTF-8',
                            ],
                        ],
                    ],
                    // Tags para identificação (útil para métricas)
                    'Tags' => [
                        [
                            'Name' => 'source',
                            'Value' => 'modal-whatsapp',
                        ],
                        [
                            'Name' => 'type',
                            'Value' => 'admin-notification',
                        ],
                    ],
                ]);

                $results[] = [
                    'email' => $adminEmail,
                    'success' => true,
                    'message_id' => $result['MessageId'],
                ];
                $successCount++;
                
                // Log de sucesso usando ProfessionalLogger
                try {
                    require_once __DIR__ . '/ProfessionalLogger.php';
                    $logger = new ProfessionalLogger();
                    $logger->log('INFO', "SES: Email enviado com sucesso para {$adminEmail}", [
                        'email' => $adminEmail,
                        'message_id' => $result['MessageId']
                    ], 'EMAIL');
                } catch (Exception $logException) {
                    // Fallback para error_log se ProfessionalLogger falhar
                    error_log("✅ SES: Email enviado com sucesso para {$adminEmail} - MessageId: {$result['MessageId']}");
                }
                
            } catch (\Aws\Exception\AwsException $e) {
                // Logar erro DIRETO primeiro (antes de tentar ProfessionalLogger) para garantir que seja capturado
                error_log("🔍 DEBUG: Catch AwsException executado para {$adminEmail}");
                $errorCode = $e->getAwsErrorCode();
                $errorMessage = $e->getAwsErrorMessage();
                $errorType = get_class($e);
                error_log("❌ SES: Erro ao enviar para {$adminEmail} - Type: {$errorType} | Code: {$errorCode} | Message: {$errorMessage}");
                error_log("🔍 DEBUG: Stack trace: " . $e->getTraceAsString());
                
                $results[] = [
                    'email' => $adminEmail,
                    'success' => false,
                    'error' => $errorMessage,
                    'code' => $errorCode,
                ];
                $failCount++;
                
                // Log de erro usando ProfessionalLogger (se não estiver dentro de endpoint de email)
                try {
                    require_once __DIR__ . '/ProfessionalLogger.php';
                    $logger = new ProfessionalLogger();
                    $logger->log('ERROR', "SES: Erro ao enviar para {$adminEmail}", [
                        'email' => $adminEmail,
                        'error_code' => $errorCode,
                        'error_message' => $errorMessage
                    ], 'EMAIL');
                } catch (Exception $logException) {
                    // Erro já foi logado acima, apenas ignorar
                }
            }
        }

        // Retornar resultado consolidado
        // IMPORTANTE: Quando success: false, sempre incluir campo error para JavaScript
        if ($successCount > 0) {
            return [
                'success' => true,
                'total_sent' => $successCount,
                'total_failed' => $failCount,
                'total_recipients' => count(ADMIN_EMAILS),
                'results' => $results,
            ];
        } else {
            // Quando success: false, sempre incluir campo error
            $errorMessage = $failCount > 0 
                ? "Falha ao enviar para {$failCount} de " . count(ADMIN_EMAILS) . " destinatário(s). Verifique os detalhes em 'results'."
                : "Nenhum email foi enviado. Verifique se ADMIN_EMAILS está definido e não está vazio.";
            
            return [
                'success' => false,
                'error' => $errorMessage,
                'total_sent' => 0,
                'total_failed' => $failCount,
                'total_recipients' => count(ADMIN_EMAILS),
                'results' => $results,
            ];
        }

    } catch (\Aws\Exception\AwsException $e) {
        // Log de erro usando ProfessionalLogger
        try {
            require_once __DIR__ . '/ProfessionalLogger.php';
            $logger = new ProfessionalLogger();
            $logger->log('ERROR', "SES: Erro na configuração/cliente", [
                'error_code' => $e->getAwsErrorCode(),
                'error_message' => $e->getAwsErrorMessage()
            ], 'EMAIL');
        } catch (Exception $logException) {
            // Fallback para error_log se ProfessionalLogger falhar
            error_log("❌ SES: Erro na configuração/cliente - {$e->getAwsErrorCode()}: {$e->getAwsErrorMessage()}");
        }
        return [
            'success' => false,
            'error' => $e->getAwsErrorMessage(),
            'code' => $e->getAwsErrorCode(),
        ];
    } catch (Exception $e) {
        // Log de erro DIRETO primeiro
        error_log("🔍 DEBUG: Catch Exception EXTERNO executado (erro geral)");
        $errorType = get_class($e);
        $errorMessage = $e->getMessage();
        error_log("❌ SES: Erro geral - Type: {$errorType} | Message: {$errorMessage}");
        error_log("🔍 DEBUG: Stack trace: " . $e->getTraceAsString());
        
        // Log de erro usando ProfessionalLogger
        try {
            require_once __DIR__ . '/ProfessionalLogger.php';
            $logger = new ProfessionalLogger();
            $logger->log('ERROR', "SES: Erro geral", [
                'error_message' => $errorMessage
            ], 'EMAIL');
        } catch (Exception $logException) {
            // Erro já foi logado acima
        }
        return [
            'success' => false,
            'error' => $e->getMessage(),
        ];
    }
}
