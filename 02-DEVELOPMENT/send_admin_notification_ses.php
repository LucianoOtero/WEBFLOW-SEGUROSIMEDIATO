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

        // Criar cliente SES
        $sesClient = new \Aws\Ses\SesClient([
            'version' => 'latest',
            'region'  => AWS_REGION,
            'credentials' => [
                'key'    => AWS_ACCESS_KEY_ID,
                'secret' => AWS_SECRET_ACCESS_KEY,
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
            try {
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
                
                // Log de sucesso
                error_log("✅ SES: Email enviado com sucesso para {$adminEmail} - MessageId: {$result['MessageId']}");
                
            } catch (\Aws\Exception\AwsException $e) {
                $results[] = [
                    'email' => $adminEmail,
                    'success' => false,
                    'error' => $e->getAwsErrorMessage(),
                    'code' => $e->getAwsErrorCode(),
                ];
                $failCount++;
                
                // Log de erro
                error_log("❌ SES: Erro ao enviar para {$adminEmail} - {$e->getAwsErrorCode()}: {$e->getAwsErrorMessage()}");
            }
        }

        // Retornar resultado consolidado
        return [
            'success' => $successCount > 0,
            'total_sent' => $successCount,
            'total_failed' => $failCount,
            'total_recipients' => count(ADMIN_EMAILS),
            'results' => $results,
        ];

    } catch (\Aws\Exception\AwsException $e) {
        error_log("❌ SES: Erro na configuração/cliente - {$e->getAwsErrorCode()}: {$e->getAwsErrorMessage()}");
        return [
            'success' => false,
            'error' => $e->getAwsErrorMessage(),
            'code' => $e->getAwsErrorCode(),
        ];
    } catch (Exception $e) {
        error_log("❌ SES: Erro geral - {$e->getMessage()}");
        return [
            'success' => false,
            'error' => $e->getMessage(),
        ];
    }
}
