<?php
/**
 * TESTE DE DEBUG - ENVIO DE EMAIL
 */

require_once __DIR__ . '/ProfessionalLogger.php';

echo "=== TESTE DE DEBUG - ENVIO DE EMAIL ===\n\n";

// Teste 1: Verificar configuração
echo "1. Verificando configuração PHP...\n";
echo "   allow_url_fopen: " . (ini_get('allow_url_fopen') ? 'ON' : 'OFF') . "\n";
echo "   openssl: " . (extension_loaded('openssl') ? 'LOADED' : 'NOT LOADED') . "\n";
echo "   APP_BASE_URL: " . ($_ENV['APP_BASE_URL'] ?? 'NOT SET') . "\n\n";

// Teste 2: Testar endpoint diretamente
echo "2. Testando endpoint diretamente...\n";
$url = 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php';
$payload = [
    'ddd' => '00',
    'celular' => '000000000',
    'momento' => 'error',
    'erro' => ['message' => 'Teste direto do endpoint']
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
    echo "   ✅ Endpoint acessível\n";
    echo "   Response: " . substr($result, 0, 200) . "\n";
} else {
    $error = error_get_last();
    echo "   ❌ Endpoint não acessível\n";
    echo "   Error: " . ($error['message'] ?? 'Erro desconhecido') . "\n";
}
echo "\n";

// Teste 3: Testar com ProfessionalLogger
echo "3. Testando com ProfessionalLogger...\n";
$logger = new ProfessionalLogger();
$logId = $logger->error('Teste de email após correção do endpoint', ['test' => true], 'TEST');
echo "   Log ID: " . ($logId ?: 'FALHOU') . "\n";
echo "   Aguardando 3 segundos para email ser enviado...\n";
sleep(3);

echo "\n=== FIM DO TESTE ===\n";

