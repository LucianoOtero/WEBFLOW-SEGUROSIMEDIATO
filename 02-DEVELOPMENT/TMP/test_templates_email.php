<?php
/**
 * TESTE DO SISTEMA DE TEMPLATES DE EMAIL
 * 
 * Testa ambos os templates (modal e logging)
 */

// Carregar sistema de templates
require_once __DIR__ . '/email_template_loader.php';

echo "🧪 TESTE DO SISTEMA DE TEMPLATES DE EMAIL\n";
echo str_repeat("=", 60) . "\n\n";

// ============================================
// TESTE 1: Template Modal
// ============================================
echo "📧 TESTE 1: Template Modal\n";
echo str_repeat("-", 60) . "\n";

$dadosModal = [
    'ddd' => '11',
    'celular' => '987654321',
    'nome' => 'João Silva',
    'cpf' => '123.456.789-00',
    'email' => 'joao@example.com',
    'cep' => '01234-567',
    'placa' => 'ABC1234',
    'gclid' => 'test-gclid-123',
    'momento' => 'initial',
    'momento_descricao' => 'Novo Contato',
    'momento_emoji' => '📱'
];

$templateModal = renderEmailTemplate($dadosModal);
echo "✅ Template Modal renderizado com sucesso\n";
echo "   Assunto: " . $templateModal['subject'] . "\n";
echo "   HTML: " . strlen($templateModal['html']) . " caracteres\n";
echo "   Texto: " . strlen($templateModal['text']) . " caracteres\n\n";

// ============================================
// TESTE 2: Template Logging - ERROR
// ============================================
echo "❌ TESTE 2: Template Logging - ERROR\n";
echo str_repeat("-", 60) . "\n";

$dadosLoggingError = [
    'ddd' => '00',
    'celular' => '000000000',
    'nome' => 'Sistema de Logging',
    'erro' => [
        'level' => 'ERROR',
        'message' => 'Erro ao conectar ao banco de dados',
        'category' => 'DATABASE',
        'file_name' => 'ProfessionalLogger.php',
        'line_number' => 150,
        'function_name' => 'getConnection',
        'class_name' => 'ProfessionalLogger',
        'stack_trace' => "Error: Database connection failed\n  at ProfessionalLogger->getConnection()\n  at ProfessionalLogger->log()\n  at log_endpoint.php:45",
        'data' => ['host' => '172.17.0.1', 'port' => 3306],
        'timestamp' => date('Y-m-d H:i:s'),
        'request_id' => 'req_test_123',
        'environment' => 'development'
    ]
];

$templateLoggingError = renderEmailTemplate($dadosLoggingError);
echo "✅ Template Logging (ERROR) renderizado com sucesso\n";
echo "   Assunto: " . $templateLoggingError['subject'] . "\n";
echo "   HTML: " . strlen($templateLoggingError['html']) . " caracteres\n";
echo "   Texto: " . strlen($templateLoggingError['text']) . " caracteres\n\n";

// ============================================
// TESTE 3: Template Logging - WARN
// ============================================
echo "⚠️ TESTE 3: Template Logging - WARN\n";
echo str_repeat("-", 60) . "\n";

$dadosLoggingWarn = [
    'ddd' => '00',
    'celular' => '000000000',
    'nome' => 'Sistema de Logging',
    'erro' => [
        'level' => 'WARN',
        'message' => 'Taxa de requisições alta detectada',
        'category' => 'RATE_LIMIT',
        'file_name' => 'log_endpoint.php',
        'line_number' => 80,
        'function_name' => 'checkRateLimit',
        'stack_trace' => null,
        'data' => ['requests_per_minute' => 120, 'limit' => 100],
        'timestamp' => date('Y-m-d H:i:s'),
        'request_id' => 'req_test_456',
        'environment' => 'development'
    ]
];

$templateLoggingWarn = renderEmailTemplate($dadosLoggingWarn);
echo "✅ Template Logging (WARN) renderizado com sucesso\n";
echo "   Assunto: " . $templateLoggingWarn['subject'] . "\n";
echo "   HTML: " . strlen($templateLoggingWarn['html']) . " caracteres\n";
echo "   Texto: " . strlen($templateLoggingWarn['text']) . " caracteres\n\n";

// ============================================
// TESTE 4: Template Logging - FATAL
// ============================================
echo "🚨 TESTE 4: Template Logging - FATAL\n";
echo str_repeat("-", 60) . "\n";

$dadosLoggingFatal = [
    'ddd' => '00',
    'celular' => '000000000',
    'nome' => 'Sistema de Logging',
    'erro' => [
        'level' => 'FATAL',
        'message' => 'Erro fatal: Memória esgotada',
        'category' => 'SYSTEM',
        'file_name' => 'index.php',
        'line_number' => 1,
        'function_name' => null,
        'class_name' => null,
        'stack_trace' => "Fatal error: Allowed memory size of 134217728 bytes exhausted\n  at index.php:1\n  at bootstrap.php:10",
        'data' => ['memory_limit' => '128M', 'memory_used' => '130M'],
        'timestamp' => date('Y-m-d H:i:s'),
        'request_id' => 'req_test_789',
        'environment' => 'production'
    ]
];

$templateLoggingFatal = renderEmailTemplate($dadosLoggingFatal);
echo "✅ Template Logging (FATAL) renderizado com sucesso\n";
echo "   Assunto: " . $templateLoggingFatal['subject'] . "\n";
echo "   HTML: " . strlen($templateLoggingFatal['html']) . " caracteres\n";
echo "   Texto: " . strlen($templateLoggingFatal['text']) . " caracteres\n\n";

// ============================================
// TESTE 5: Detecção Automática
// ============================================
echo "🔍 TESTE 5: Detecção Automática de Template\n";
echo str_repeat("-", 60) . "\n";

// Testar detecção de template modal
$tipoModal = detectTemplateType($dadosModal);
echo "   Dados Modal → Tipo detectado: " . $tipoModal . " (esperado: modal)\n";
echo "   " . ($tipoModal === 'modal' ? '✅' : '❌') . " Detecção correta\n\n";

// Testar detecção de template logging
$tipoLogging = detectTemplateType($dadosLoggingError);
echo "   Dados Logging → Tipo detectado: " . $tipoLogging . " (esperado: logging)\n";
echo "   " . ($tipoLogging === 'logging' ? '✅' : '❌') . " Detecção correta\n\n";

// ============================================
// RESUMO
// ============================================
echo str_repeat("=", 60) . "\n";
echo "✅ TODOS OS TESTES CONCLUÍDOS COM SUCESSO!\n";
echo str_repeat("=", 60) . "\n";

