<?php
/**
 * TESTE DE INTEGRAÇÃO DE EMAIL NO LOGGING
 * 
 * Este arquivo testa o envio de emails automático quando logs de nível
 * ERROR ou FATAL são registrados.
 * 
 * Uso:
 * - Acessar via: https://dev.bssegurosimediato.com.br/test_email_logging_categories.php
 * - Ou executar via CLI: php test_email_logging_categories.php
 * 
 * Data: 09/11/2025
 */

// Carregar ProfessionalLogger
require_once __DIR__ . '/ProfessionalLogger.php';

// Headers para output
header('Content-Type: text/html; charset=utf-8');

?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teste de Email no Logging</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 10px;
        }
        .test-section {
            margin: 20px 0;
            padding: 15px;
            border-left: 4px solid #2196F3;
            background-color: #f9f9f9;
        }
        .test-section.error {
            border-left-color: #F44336;
        }
        .test-section.fatal {
            border-left-color: #FF5722;
        }
        .result {
            margin: 10px 0;
            padding: 10px;
            background-color: #e8f5e9;
            border-radius: 4px;
        }
        .result.error {
            background-color: #ffebee;
        }
        .result.fatal {
            background-color: #fff3e0;
        }
        .log-id {
            font-family: monospace;
            color: #666;
            font-size: 0.9em;
        }
        .info {
            margin: 5px 0;
            color: #555;
        }
        .success {
            color: #4CAF50;
            font-weight: bold;
        }
        .warning {
            color: #FF9800;
            font-weight: bold;
        }
        .error-text {
            color: #F44336;
            font-weight: bold;
        }
        .summary {
            margin-top: 30px;
            padding: 20px;
            background-color: #e3f2fd;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧪 Teste de Integração de Email no Logging</h1>
        <p><strong>Data/Hora:</strong> <?php echo date('d/m/Y H:i:s'); ?></p>
        <p><strong>Ambiente:</strong> <?php echo ($_ENV['PHP_ENV'] ?? 'development'); ?></p>
        <p><strong>Objetivo:</strong> Verificar se emails são enviados automaticamente para ERROR e FATAL</p>
        
        <hr>
        
        <?php
        $logger = new ProfessionalLogger();
        $results = [];
        $testCount = 0;
        $successCount = 0;
        
        // ============================================
        // TESTE 1: ERROR - Categoria DATABASE
        // ============================================
        $testCount++;
        echo '<div class="test-section error">';
        echo '<h2>❌ Teste 1: ERROR - Categoria DATABASE</h2>';
        echo '<div class="info">Categoria: DATABASE</div>';
        echo '<div class="info">Mensagem: Falha ao conectar ao banco de dados</div>';
        
        $logId = $logger->error(
            'Falha ao conectar ao banco de dados',
            [
                'host' => 'localhost',
                'port' => 3306,
                'database' => 'rpa_logs_dev',
                'error_code' => 'CONNECTION_FAILED',
                'timestamp' => date('Y-m-d H:i:s')
            ],
            'DATABASE'
        );
        
        if ($logId) {
            $successCount++;
            echo '<div class="result success">';
            echo '✅ <strong>Log salvo com sucesso!</strong><br>';
            echo '<span class="log-id">Log ID: ' . htmlspecialchars($logId) . '</span><br>';
            echo '📧 <strong>Email deve ser enviado automaticamente</strong> para os administradores';
            echo '</div>';
            $results[] = ['test' => 'ERROR-DATABASE', 'log_id' => $logId, 'success' => true];
        } else {
            echo '<div class="result error-text">';
            echo '❌ <strong>Falha ao salvar log!</strong>';
            echo '</div>';
            $results[] = ['test' => 'ERROR-DATABASE', 'log_id' => null, 'success' => false];
        }
        echo '</div>';
        
        // Aguardar 1 segundo entre testes
        sleep(1);
        
        // ============================================
        // TESTE 2: ERROR - Categoria API
        // ============================================
        $testCount++;
        echo '<div class="test-section error">';
        echo '<h2>❌ Teste 2: ERROR - Categoria API</h2>';
        echo '<div class="info">Categoria: API</div>';
        echo '<div class="info">Mensagem: Erro ao chamar API externa</div>';
        
        $logId = $logger->error(
            'Erro ao chamar API externa',
            [
                'endpoint' => 'https://api.exemplo.com/v1/data',
                'method' => 'POST',
                'status_code' => 500,
                'response' => 'Internal Server Error',
                'timestamp' => date('Y-m-d H:i:s')
            ],
            'API'
        );
        
        if ($logId) {
            $successCount++;
            echo '<div class="result success">';
            echo '✅ <strong>Log salvo com sucesso!</strong><br>';
            echo '<span class="log-id">Log ID: ' . htmlspecialchars($logId) . '</span><br>';
            echo '📧 <strong>Email deve ser enviado automaticamente</strong> para os administradores';
            echo '</div>';
            $results[] = ['test' => 'ERROR-API', 'log_id' => $logId, 'success' => true];
        } else {
            echo '<div class="result error-text">';
            echo '❌ <strong>Falha ao salvar log!</strong>';
            echo '</div>';
            $results[] = ['test' => 'ERROR-API', 'log_id' => null, 'success' => false];
        }
        echo '</div>';
        
        // Aguardar 1 segundo entre testes
        sleep(1);
        
        // ============================================
        // TESTE 3: ERROR - Categoria VALIDATION
        // ============================================
        $testCount++;
        echo '<div class="test-section error">';
        echo '<h2>❌ Teste 3: ERROR - Categoria VALIDATION</h2>';
        echo '<div class="info">Categoria: VALIDATION</div>';
        echo '<div class="info">Mensagem: Erro de validação de dados</div>';
        
        $logId = $logger->error(
            'Erro de validação de dados',
            [
                'field' => 'cpf',
                'value' => '123.456.789-00',
                'rule' => 'cpf_valid',
                'error' => 'CPF inválido',
                'timestamp' => date('Y-m-d H:i:s')
            ],
            'VALIDATION'
        );
        
        if ($logId) {
            $successCount++;
            echo '<div class="result success">';
            echo '✅ <strong>Log salvo com sucesso!</strong><br>';
            echo '<span class="log-id">Log ID: ' . htmlspecialchars($logId) . '</span><br>';
            echo '📧 <strong>Email deve ser enviado automaticamente</strong> para os administradores';
            echo '</div>';
            $results[] = ['test' => 'ERROR-VALIDATION', 'log_id' => $logId, 'success' => true];
        } else {
            echo '<div class="result error-text">';
            echo '❌ <strong>Falha ao salvar log!</strong>';
            echo '</div>';
            $results[] = ['test' => 'ERROR-VALIDATION', 'log_id' => null, 'success' => false];
        }
        echo '</div>';
        
        // Aguardar 1 segundo entre testes
        sleep(1);
        
        // ============================================
        // TESTE 4: FATAL - Categoria SYSTEM
        // ============================================
        $testCount++;
        echo '<div class="test-section fatal">';
        echo '<h2>🚨 Teste 4: FATAL - Categoria SYSTEM</h2>';
        echo '<div class="info">Categoria: SYSTEM</div>';
        echo '<div class="info">Mensagem: Erro fatal no sistema</div>';
        
        try {
            throw new Exception('Erro fatal: Sistema não pode continuar');
        } catch (Exception $e) {
            $logId = $logger->fatal(
                'Erro fatal no sistema',
                [
                    'component' => 'core',
                    'action' => 'initialize',
                    'error_type' => 'FATAL_EXCEPTION',
                    'timestamp' => date('Y-m-d H:i:s')
                ],
                'SYSTEM',
                $e
            );
            
            if ($logId) {
                $successCount++;
                echo '<div class="result fatal">';
                echo '✅ <strong>Log salvo com sucesso!</strong><br>';
                echo '<span class="log-id">Log ID: ' . htmlspecialchars($logId) . '</span><br>';
                echo '📧 <strong>Email deve ser enviado automaticamente</strong> para os administradores<br>';
                echo '📋 <strong>Stack trace incluído no email</strong>';
                echo '</div>';
                $results[] = ['test' => 'FATAL-SYSTEM', 'log_id' => $logId, 'success' => true];
            } else {
                echo '<div class="result error-text">';
                echo '❌ <strong>Falha ao salvar log!</strong>';
                echo '</div>';
                $results[] = ['test' => 'FATAL-SYSTEM', 'log_id' => null, 'success' => false];
            }
        }
        echo '</div>';
        
        // Aguardar 1 segundo entre testes
        sleep(1);
        
        // ============================================
        // TESTE 5: FATAL - Categoria SECURITY
        // ============================================
        $testCount++;
        echo '<div class="test-section fatal">';
        echo '<h2>🚨 Teste 5: FATAL - Categoria SECURITY</h2>';
        echo '<div class="info">Categoria: SECURITY</div>';
        echo '<div class="info">Mensagem: Tentativa de acesso não autorizado</div>';
        
        try {
            throw new Exception('Tentativa de acesso não autorizado detectada');
        } catch (Exception $e) {
            $logId = $logger->fatal(
                'Tentativa de acesso não autorizado',
                [
                    'ip_address' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
                    'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
                    'attempted_action' => 'unauthorized_access',
                    'timestamp' => date('Y-m-d H:i:s')
                ],
                'SECURITY',
                $e
            );
            
            if ($logId) {
                $successCount++;
                echo '<div class="result fatal">';
                echo '✅ <strong>Log salvo com sucesso!</strong><br>';
                echo '<span class="log-id">Log ID: ' . htmlspecialchars($logId) . '</span><br>';
                echo '📧 <strong>Email deve ser enviado automaticamente</strong> para os administradores<br>';
                echo '📋 <strong>Stack trace incluído no email</strong>';
                echo '</div>';
                $results[] = ['test' => 'FATAL-SECURITY', 'log_id' => $logId, 'success' => true];
            } else {
                echo '<div class="result error-text">';
                echo '❌ <strong>Falha ao salvar log!</strong>';
                echo '</div>';
                $results[] = ['test' => 'FATAL-SECURITY', 'log_id' => null, 'success' => false];
            }
        }
        echo '</div>';
        
        // Aguardar 1 segundo entre testes
        sleep(1);
        
        // ============================================
        // TESTE 6: FATAL - Categoria CRITICAL
        // ============================================
        $testCount++;
        echo '<div class="test-section fatal">';
        echo '<h2>🚨 Teste 6: FATAL - Categoria CRITICAL</h2>';
        echo '<div class="info">Categoria: CRITICAL</div>';
        echo '<div class="info">Mensagem: Erro crítico que impede funcionamento</div>';
        
        try {
            throw new Exception('Erro crítico: Sistema não pode continuar operando');
        } catch (Exception $e) {
            $logId = $logger->fatal(
                'Erro crítico que impede funcionamento',
                [
                    'severity' => 'CRITICAL',
                    'impact' => 'Sistema indisponível',
                    'requires_immediate_action' => true,
                    'timestamp' => date('Y-m-d H:i:s')
                ],
                'CRITICAL',
                $e
            );
            
            if ($logId) {
                $successCount++;
                echo '<div class="result fatal">';
                echo '✅ <strong>Log salvo com sucesso!</strong><br>';
                echo '<span class="log-id">Log ID: ' . htmlspecialchars($logId) . '</span><br>';
                echo '📧 <strong>Email deve ser enviado automaticamente</strong> para os administradores<br>';
                echo '📋 <strong>Stack trace incluído no email</strong>';
                echo '</div>';
                $results[] = ['test' => 'FATAL-CRITICAL', 'log_id' => $logId, 'success' => true];
            } else {
                echo '<div class="result error-text">';
                echo '❌ <strong>Falha ao salvar log!</strong>';
                echo '</div>';
                $results[] = ['test' => 'FATAL-CRITICAL', 'log_id' => null, 'success' => false];
            }
        }
        echo '</div>';
        
        // ============================================
        // RESUMO
        // ============================================
        echo '<div class="summary">';
        echo '<h2>📊 Resumo dos Testes</h2>';
        echo '<p><strong>Total de testes:</strong> ' . $testCount . '</p>';
        echo '<p><strong>Testes bem-sucedidos:</strong> <span class="success">' . $successCount . '</span></p>';
        echo '<p><strong>Testes falhados:</strong> <span class="error-text">' . ($testCount - $successCount) . '</span></p>';
        
        echo '<h3>Logs Registrados:</h3>';
        echo '<ul>';
        foreach ($results as $result) {
            $status = $result['success'] ? '✅' : '❌';
            $logId = $result['log_id'] ?: 'FALHOU';
            echo '<li>' . $status . ' <strong>' . htmlspecialchars($result['test']) . '</strong> - Log ID: <code>' . htmlspecialchars($logId) . '</code></li>';
        }
        echo '</ul>';
        
        echo '<h3>📧 Verificação de Emails</h3>';
        echo '<p>Verifique a caixa de entrada dos seguintes administradores:</p>';
        echo '<ul>';
        echo '<li>lrotero@gmail.com</li>';
        echo '<li>alex.kaminski@imediatoseguros.com.br</li>';
        echo '<li>alexkaminski70@gmail.com</li>';
        echo '</ul>';
        echo '<p><strong>⚠️ Nota:</strong> Os emails são enviados de forma assíncrona. Pode levar alguns segundos para chegarem.</p>';
        echo '<p><strong>✅ Esperado:</strong> Você deve receber 6 emails (3 ERROR + 3 FATAL)</p>';
        echo '</div>';
        ?>
    </div>
</body>
</html>

