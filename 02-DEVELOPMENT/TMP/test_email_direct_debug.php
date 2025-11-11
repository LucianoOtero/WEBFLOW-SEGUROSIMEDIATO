<?php
/**
 * TESTE DIRETO DE EMAIL - DEBUG COMPLETO
 */

require_once __DIR__ . '/ProfessionalLogger.php';

echo "=== TESTE DIRETO DE EMAIL - DEBUG COMPLETO ===\n\n";

// Teste 1: Verificar se endpoint está acessível
echo "1. Testando endpoint diretamente...\n";
$url = 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php';
$payload = [
    'ddd' => '00',
    'celular' => '000000000',
    'momento' => 'error',
    'erro' => [
        'message' => 'Teste direto do endpoint',
        'level' => 'ERROR',
        'category' => 'TEST'
    ]
];

$context = stream_context_create([
    'http' => [
        'method' => 'POST',
        'header' => 'Content-Type: application/json',
        'content' => json_encode($payload),
        'timeout' => 10
    ]
]);

$result = @file_get_contents($url, false, $context);
if ($result !== false) {
    $response = @json_decode($result, true);
    echo "   ✅ Endpoint acessível\n";
    echo "   Response: " . json_encode($response, JSON_PRETTY_PRINT) . "\n";
    if ($response && isset($response['success']) && $response['success']) {
        echo "   ✅ Email enviado com sucesso!\n";
        echo "   Total enviado: " . ($response['total_sent'] ?? 0) . "\n";
    } else {
        echo "   ❌ Email falhou ao enviar\n";
        echo "   Erro: " . ($response['error'] ?? 'Desconhecido') . "\n";
    }
} else {
    $error = error_get_last();
    echo "   ❌ Endpoint não acessível\n";
    echo "   Error: " . ($error['message'] ?? 'Erro desconhecido') . "\n";
}
echo "\n";

// Teste 2: Testar com ProfessionalLogger
echo "2. Testando com ProfessionalLogger...\n";
$logger = new ProfessionalLogger();

// Verificar se método sendEmailNotification existe
$reflection = new ReflectionClass($logger);
$method = $reflection->getMethod('sendEmailNotification');
$method->setAccessible(true);

// Preparar dados de teste
$logData = [
    'file_name' => 'test_email_direct_debug.php',
    'line_number' => 50,
    'function_name' => 'test',
    'class_name' => null,
    'timestamp' => date('Y-m-d H:i:s')
];

// Chamar método diretamente
echo "   Chamando sendEmailNotification diretamente...\n";
$method->invoke($logger, 'ERROR', 'Teste direto de email via ProfessionalLogger', ['test' => true], 'TEST', null, $logData);
echo "   ✅ Método chamado\n";
echo "   Aguardando 3 segundos...\n";
sleep(3);

// Teste 3: Testar via método error()
echo "\n3. Testando via método error()...\n";
$logId = $logger->error('Teste de email via error()', ['test' => true, 'debug' => true], 'TEST');
echo "   Log ID: " . ($logId ?: 'FALHOU') . "\n";
echo "   Aguardando 3 segundos...\n";
sleep(3);

echo "\n=== FIM DO TESTE ===\n";
echo "Verifique os logs do PHP e do banco de dados para mais detalhes.\n";

