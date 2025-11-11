<?php
/**
 * TESTE DE ENVIO DE EMAILS COM NOVO TEMPLATE DE LOGGING
 * 
 * Envia 3 emails de teste (ERROR, WARN, FATAL) usando o novo template de logging
 */

// Carregar função de envio de email
require_once __DIR__ . '/send_admin_notification_ses.php';

echo "🧪 TESTE DE ENVIO DE EMAILS COM NOVO TEMPLATE DE LOGGING\n";
echo str_repeat("=", 70) . "\n\n";

// ============================================
// TESTE 1: ERROR
// ============================================
echo "❌ TESTE 1: Enviando email ERROR...\n";
echo str_repeat("-", 70) . "\n";

$dadosError = [
    'ddd' => '00',
    'celular' => '000000000',
    'nome' => 'Sistema de Logging',
    'cpf' => 'N/A',
    'email' => 'N/A',
    'cep' => 'N/A',
    'placa' => 'N/A',
    'gclid' => 'N/A',
    'momento' => 'error',
    'momento_descricao' => 'Erro no Sistema',
    'momento_emoji' => '❌',
    'erro' => [
        'level' => 'ERROR',
        'message' => 'Erro ao conectar ao banco de dados MySQL',
        'category' => 'DATABASE',
        'file_name' => 'ProfessionalLogger.php',
        'line_number' => 150,
        'function_name' => 'getConnection',
        'class_name' => 'ProfessionalLogger',
        'stack_trace' => "Error: Database connection failed\n  at ProfessionalLogger->getConnection() (ProfessionalLogger.php:150)\n  at ProfessionalLogger->log() (ProfessionalLogger.php:200)\n  at log_endpoint.php:45\n  at main() (log_endpoint.php:1)",
        'data' => [
            'host' => '172.17.0.1',
            'port' => 3306,
            'database' => 'rpa_logs_dev',
            'error_code' => 'HY000',
            'error_message' => 'Connection refused'
        ],
        'timestamp' => date('Y-m-d H:i:s'),
        'request_id' => 'req_test_error_' . uniqid(),
        'environment' => 'development'
    ]
];

$resultError = enviarNotificacaoAdministradores($dadosError);
echo "   Sucesso: " . ($resultError['success'] ? '✅ SIM' : '❌ NÃO') . "\n";
echo "   Total enviado: " . ($resultError['total_sent'] ?? 0) . "\n";
echo "   Total falhou: " . ($resultError['total_failed'] ?? 0) . "\n";
if (isset($resultError['error'])) {
    echo "   Erro: " . $resultError['error'] . "\n";
}
echo "\n";

// Aguardar 2 segundos entre envios
sleep(2);

// ============================================
// TESTE 2: WARN
// ============================================
echo "⚠️ TESTE 2: Enviando email WARN...\n";
echo str_repeat("-", 70) . "\n";

$dadosWarn = [
    'ddd' => '00',
    'celular' => '000000000',
    'nome' => 'Sistema de Logging',
    'cpf' => 'N/A',
    'email' => 'N/A',
    'cep' => 'N/A',
    'placa' => 'N/A',
    'gclid' => 'N/A',
    'momento' => 'warn',
    'momento_descricao' => 'Aviso no Sistema',
    'momento_emoji' => '⚠️',
    'erro' => [
        'level' => 'WARN',
        'message' => 'Taxa de requisições alta detectada - possível ataque',
        'category' => 'RATE_LIMIT',
        'file_name' => 'log_endpoint.php',
        'line_number' => 80,
        'function_name' => 'checkRateLimit',
        'class_name' => null,
        'stack_trace' => "Warning: Rate limit exceeded\n  at checkRateLimit() (log_endpoint.php:80)\n  at log_endpoint.php:120",
        'data' => [
            'requests_per_minute' => 120,
            'limit' => 100,
            'ip_address' => '191.9.24.241',
            'time_window' => '60 seconds'
        ],
        'timestamp' => date('Y-m-d H:i:s'),
        'request_id' => 'req_test_warn_' . uniqid(),
        'environment' => 'development'
    ]
];

$resultWarn = enviarNotificacaoAdministradores($dadosWarn);
echo "   Sucesso: " . ($resultWarn['success'] ? '✅ SIM' : '❌ NÃO') . "\n";
echo "   Total enviado: " . ($resultWarn['total_sent'] ?? 0) . "\n";
echo "   Total falhou: " . ($resultWarn['total_failed'] ?? 0) . "\n";
if (isset($resultWarn['error'])) {
    echo "   Erro: " . $resultWarn['error'] . "\n";
}
echo "\n";

// Aguardar 2 segundos entre envios
sleep(2);

// ============================================
// TESTE 3: FATAL
// ============================================
echo "🚨 TESTE 3: Enviando email FATAL...\n";
echo str_repeat("-", 70) . "\n";

$dadosFatal = [
    'ddd' => '00',
    'celular' => '000000000',
    'nome' => 'Sistema de Logging',
    'cpf' => 'N/A',
    'email' => 'N/A',
    'cep' => 'N/A',
    'placa' => 'N/A',
    'gclid' => 'N/A',
    'momento' => 'fatal',
    'momento_descricao' => 'Erro Fatal no Sistema',
    'momento_emoji' => '🚨',
    'erro' => [
        'level' => 'FATAL',
        'message' => 'Erro fatal: Memória esgotada - sistema pode estar comprometido',
        'category' => 'SYSTEM',
        'file_name' => 'index.php',
        'line_number' => 1,
        'function_name' => null,
        'class_name' => null,
        'stack_trace' => "Fatal error: Allowed memory size of 134217728 bytes exhausted\n  at index.php:1\n  at bootstrap.php:10\n  at main() (index.php:1)",
        'data' => [
            'memory_limit' => '128M',
            'memory_used' => '130M',
            'memory_peak' => '132M',
            'php_version' => PHP_VERSION,
            'server_load' => 'high'
        ],
        'timestamp' => date('Y-m-d H:i:s'),
        'request_id' => 'req_test_fatal_' . uniqid(),
        'environment' => 'development'
    ]
];

$resultFatal = enviarNotificacaoAdministradores($dadosFatal);
echo "   Sucesso: " . ($resultFatal['success'] ? '✅ SIM' : '❌ NÃO') . "\n";
echo "   Total enviado: " . ($resultFatal['total_sent'] ?? 0) . "\n";
echo "   Total falhou: " . ($resultFatal['total_failed'] ?? 0) . "\n";
if (isset($resultFatal['error'])) {
    echo "   Erro: " . $resultFatal['error'] . "\n";
}
echo "\n";

// ============================================
// RESUMO
// ============================================
echo str_repeat("=", 70) . "\n";
echo "📊 RESUMO DOS TESTES\n";
echo str_repeat("=", 70) . "\n";
echo "ERROR: " . ($resultError['success'] ? '✅ Enviado' : '❌ Falhou') . " (" . ($resultError['total_sent'] ?? 0) . " emails)\n";
echo "WARN:  " . ($resultWarn['success'] ? '✅ Enviado' : '❌ Falhou') . " (" . ($resultWarn['total_sent'] ?? 0) . " emails)\n";
echo "FATAL: " . ($resultFatal['success'] ? '✅ Enviado' : '❌ Falhou') . " (" . ($resultFatal['total_sent'] ?? 0) . " emails)\n";
echo "\n";
echo "📧 Total de emails enviados: " . (($resultError['total_sent'] ?? 0) + ($resultWarn['total_sent'] ?? 0) + ($resultFatal['total_sent'] ?? 0)) . "\n";
echo "👥 Para " . (($resultError['total_recipients'] ?? 0) ?: ($resultWarn['total_recipients'] ?? 0) ?: ($resultFatal['total_recipients'] ?? 0)) . " administrador(es)\n";
echo "\n";
echo "✅ TESTE CONCLUÍDO!\n";
echo "   Verifique sua caixa de entrada para os emails com o novo template.\n";
echo str_repeat("=", 70) . "\n";

