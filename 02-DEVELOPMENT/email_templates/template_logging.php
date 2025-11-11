<?php
/**
 * TEMPLATE DE EMAIL - LOGGING (ERROR/WARN/FATAL)
 * 
 * Template específico para notificações de erro/warning/fatal do sistema de logging
 * Focado em informações técnicas (arquivo, linha, stack trace, etc.)
 * 
 * @param array $dados Dados do log (deve conter 'erro' com informações técnicas)
 * @return array ['subject' => string, 'html' => string, 'text' => string]
 */
function renderEmailTemplateLogging($dados) {
    // Extrair informações do erro
    $erro = $dados['erro'] ?? [];
    $level = strtoupper($erro['level'] ?? 'ERROR');
    $message = $erro['message'] ?? 'Erro desconhecido';
    $category = $erro['category'] ?? 'UNKNOWN';
    $fileName = $erro['file_name'] ?? 'unknown';
    $lineNumber = $erro['line_number'] ?? null;
    $functionName = $erro['function_name'] ?? null;
    $className = $erro['class_name'] ?? null;
    $stackTrace = $erro['stack_trace'] ?? null;
    $data = $erro['data'] ?? null;
    $timestamp = $erro['timestamp'] ?? date('Y-m-d H:i:s');
    $requestId = $erro['request_id'] ?? 'N/A';
    $environment = $erro['environment'] ?? 'unknown';
    
    // Cores e emojis por nível
    $levelConfig = [
        'ERROR' => ['color' => '#F44336', 'emoji' => '❌', 'title' => 'Erro no Sistema'],
        'WARN' => ['color' => '#FF9800', 'emoji' => '⚠️', 'title' => 'Aviso no Sistema'],
        'FATAL' => ['color' => '#D32F2F', 'emoji' => '🚨', 'title' => 'Erro Fatal no Sistema']
    ];
    
    $config = $levelConfig[$level] ?? $levelConfig['ERROR'];
    $bannerColor = $config['color'];
    $emoji = $config['emoji'];
    $title = $config['title'];
    
    // Assunto do email
    $subject = sprintf(
        '%s %s - %s',
        $emoji,
        $title,
        $category
    );
    
    // Formatar dados JSON se disponível
    $dataFormatted = 'N/A';
    if ($data !== null) {
        if (is_string($data)) {
            $dataFormatted = $data;
        } else {
            $dataFormatted = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        }
    }
    
    // Formatar stack trace
    $stackTraceFormatted = $stackTrace ? htmlspecialchars($stackTrace) : 'Não disponível';
    
    // Localização do erro
    $location = $fileName;
    if ($lineNumber !== null) {
        $location .= ':' . $lineNumber;
    }
    if ($functionName !== null) {
        $location .= ' em ' . $functionName . '()';
    }
    if ($className !== null) {
        $location = $className . '::' . $location;
    }
    
    // HTML do email
    $html = '
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body { 
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; 
                line-height: 1.6; 
                color: #333; 
                margin: 0; 
                padding: 0; 
                background-color: #f5f5f5;
            }
            .container { 
                max-width: 700px; 
                margin: 20px auto; 
                background-color: #ffffff;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                border-radius: 8px;
                overflow: hidden;
            }
            .banner { 
                background-color: ' . $bannerColor . '; 
                color: white; 
                padding: 20px; 
                text-align: center; 
                font-weight: bold; 
                font-size: 18px;
            }
            .banner .level {
                font-size: 24px;
                margin-bottom: 5px;
            }
            .content { 
                padding: 25px; 
            }
            .section {
                margin-bottom: 25px;
                padding: 15px;
                background-color: #f9f9f9;
                border-radius: 5px;
                border-left: 4px solid ' . $bannerColor . ';
            }
            .section-title {
                font-weight: bold;
                color: ' . $bannerColor . ';
                font-size: 14px;
                text-transform: uppercase;
                margin-bottom: 10px;
                letter-spacing: 0.5px;
            }
            .field { 
                margin: 10px 0; 
                padding: 10px; 
                background-color: white; 
                border-radius: 3px;
                border-left: 3px solid ' . $bannerColor . ';
            }
            .field-label { 
                font-weight: bold; 
                color: #666; 
                display: block;
                margin-bottom: 5px;
                font-size: 12px;
                text-transform: uppercase;
            }
            .field-value { 
                color: #333; 
                word-break: break-word;
            }
            .code-block {
                background-color: #2d2d2d;
                color: #f8f8f2;
                padding: 15px;
                border-radius: 5px;
                font-family: "Courier New", Courier, monospace;
                font-size: 12px;
                line-height: 1.5;
                overflow-x: auto;
                white-space: pre-wrap;
                word-wrap: break-word;
            }
            .footer { 
                margin-top: 30px; 
                padding: 20px; 
                text-align: center; 
                color: #666; 
                font-size: 12px; 
                border-top: 1px solid #ddd;
                background-color: #f9f9f9;
            }
            .badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 3px;
                font-size: 11px;
                font-weight: bold;
                text-transform: uppercase;
            }
            .badge-error { background-color: #F44336; color: white; }
            .badge-warn { background-color: #FF9800; color: white; }
            .badge-fatal { background-color: #D32F2F; color: white; }
            .badge-dev { background-color: #2196F3; color: white; }
            .badge-prod { background-color: #4CAF50; color: white; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="banner">
                <div class="level">' . $emoji . ' ' . $level . '</div>
                <div>' . $title . '</div>
            </div>
            
            <div class="content">
                <!-- Seção: Informações Principais -->
                <div class="section">
                    <div class="section-title">📋 Informações Principais</div>
                    
                    <div class="field">
                        <span class="field-label">Mensagem</span>
                        <div class="field-value" style="font-weight: bold; color: ' . $bannerColor . ';">' . htmlspecialchars($message) . '</div>
                    </div>
                    
                    <div class="field">
                        <span class="field-label">Categoria</span>
                        <div class="field-value">
                            <span class="badge badge-' . strtolower($level) . '">' . htmlspecialchars($category) . '</span>
                        </div>
                    </div>
                    
                    <div class="field">
                        <span class="field-label">Ambiente</span>
                        <div class="field-value">
                            <span class="badge badge-' . ($environment === 'production' ? 'prod' : 'dev') . '">' . htmlspecialchars($environment) . '</span>
                        </div>
                    </div>
                    
                    <div class="field">
                        <span class="field-label">Timestamp</span>
                        <div class="field-value">' . htmlspecialchars($timestamp) . '</div>
                    </div>
                    
                    <div class="field">
                        <span class="field-label">Request ID</span>
                        <div class="field-value" style="font-family: monospace; font-size: 11px;">' . htmlspecialchars($requestId) . '</div>
                    </div>
                </div>
                
                <!-- Seção: Localização -->
                <div class="section">
                    <div class="section-title">📍 Localização do Erro</div>
                    
                    <div class="field">
                        <span class="field-label">Arquivo e Linha</span>
                        <div class="field-value" style="font-family: monospace; font-size: 12px;">' . htmlspecialchars($location) . '</div>
                    </div>
                    
                    ' . ($functionName ? '
                    <div class="field">
                        <span class="field-label">Função</span>
                        <div class="field-value" style="font-family: monospace;">' . htmlspecialchars($functionName) . '()</div>
                    </div>' : '') . '
                    
                    ' . ($className ? '
                    <div class="field">
                        <span class="field-label">Classe</span>
                        <div class="field-value" style="font-family: monospace;">' . htmlspecialchars($className) . '</div>
                    </div>' : '') . '
                </div>
                
                ' . ($stackTrace && $stackTrace !== 'Não disponível' ? '
                <!-- Seção: Stack Trace -->
                <div class="section">
                    <div class="section-title">🔍 Stack Trace</div>
                    <div class="code-block">' . $stackTraceFormatted . '</div>
                </div>' : '') . '
                
                ' . ($data && $data !== 'N/A' ? '
                <!-- Seção: Dados Adicionais -->
                <div class="section">
                    <div class="section-title">📦 Dados Adicionais</div>
                    <div class="code-block">' . htmlspecialchars($dataFormatted) . '</div>
                </div>' : '') . '
            </div>
            
            <div class="footer">
                <p><strong>BP Seguros Imediato - Sistema de Logging</strong></p>
                <p>Esta é uma notificação automática do sistema.</p>
                <p>Não responda este email.</p>
            </div>
        </div>
    </body>
    </html>
    ';

    // Texto simples (fallback)
    $text = "
{$title} - {$level}
" . str_repeat("=", 50) . "

Mensagem: {$message}
Categoria: {$category}
Nível: {$level}
Ambiente: {$environment}

Localização:
  Arquivo: {$location}
" . ($functionName ? "  Função: {$functionName}()\n" : "") . ($className ? "  Classe: {$className}\n" : "") . "
Timestamp: {$timestamp}
Request ID: {$requestId}

" . ($stackTrace ? "Stack Trace:\n" . str_repeat("-", 50) . "\n{$stackTrace}\n" : "") . "
" . ($data && $data !== 'N/A' ? "Dados Adicionais:\n" . str_repeat("-", 50) . "\n{$dataFormatted}\n" : "") . "
" . str_repeat("=", 50) . "

BP Seguros Imediato - Sistema de Logging
Esta é uma notificação automática do sistema.
Não responda este email.
    ";

    return [
        'subject' => $subject,
        'html' => $html,
        'text' => $text
    ];
}

