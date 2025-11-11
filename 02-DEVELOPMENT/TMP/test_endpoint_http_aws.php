<?php
/**
 * Teste que simula exatamente o que acontece quando o endpoint é chamado via HTTP
 */

echo "=== TESTE ENDPOINT HTTP - AWS SDK ===\n\n";

// Simular o que o endpoint faz
echo "1. Carregando ProfessionalLogger...\n";
require_once __DIR__ . '/ProfessionalLogger.php';
echo "   ✅ Carregado\n\n";

echo "2. Carregando send_admin_notification_ses.php...\n";
require_once __DIR__ . '/send_admin_notification_ses.php';
echo "   ✅ Carregado\n\n";

echo "3. Verificando variável global \$awsSdkAvailable...\n";
global $awsSdkAvailable;
echo "   Valor: " . ($awsSdkAvailable ? "true (DISPONÍVEL)" : "false (NÃO DISPONÍVEL)") . "\n\n";

echo "4. Testando função enviarNotificacaoAdministradores...\n";
$testData = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test',
    'momento_descricao' => 'Teste'
];

$result = enviarNotificacaoAdministradores($testData);
echo "   Resultado:\n";
echo "   - success: " . ($result['success'] ? "true" : "false") . "\n";
echo "   - error: " . ($result['error'] ?? 'Nenhum') . "\n";
echo "   - total_sent: " . ($result['total_sent'] ?? 0) . "\n\n";

echo "5. Verificando caminhos usados...\n";
echo "   __DIR__: " . __DIR__ . "\n";
echo "   vendor/autoload.php: " . __DIR__ . '/vendor/autoload.php' . "\n";
echo "   Existe? " . (file_exists(__DIR__ . '/vendor/autoload.php') ? "SIM" : "NÃO") . "\n\n";

echo "=== FIM DO TESTE ===\n";

