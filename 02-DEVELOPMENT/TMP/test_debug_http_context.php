<?php
/**
 * Teste para debugar o contexto HTTP vs CLI
 * Simula exatamente o que acontece quando o endpoint é chamado via HTTP
 */

// Headers como se fosse uma requisição HTTP
header('Content-Type: text/plain; charset=utf-8');

echo "=== DEBUG CONTEXTO HTTP ===\n\n";

// 1. Verificar __DIR__ no contexto HTTP
echo "1. __DIR__ atual: " . __DIR__ . "\n";
echo "   getcwd(): " . getcwd() . "\n";
echo "   \$_SERVER['SCRIPT_FILENAME']: " . ($_SERVER['SCRIPT_FILENAME'] ?? 'N/A') . "\n";
echo "   \$_SERVER['DOCUMENT_ROOT']: " . ($_SERVER['DOCUMENT_ROOT'] ?? 'N/A') . "\n\n";

// 2. Verificar se send_admin_notification_ses.php já foi carregado
echo "2. Verificando se send_admin_notification_ses.php já foi carregado...\n";
$alreadyLoaded = function_exists('enviarNotificacaoAdministradores');
echo "   Função existe? " . ($alreadyLoaded ? "SIM (já carregado)" : "NÃO (não carregado)") . "\n\n";

// 3. Carregar ProfessionalLogger
echo "3. Carregando ProfessionalLogger...\n";
require_once __DIR__ . '/ProfessionalLogger.php';
echo "   ✅ Carregado\n\n";

// 4. Verificar se variável global já existe ANTES de carregar
echo "4. Verificando variável global ANTES de carregar send_admin_notification_ses.php...\n";
global $awsSdkAvailable;
echo "   \$awsSdkAvailable existe? " . (isset($awsSdkAvailable) ? "SIM = " . var_export($awsSdkAvailable, true) : "NÃO") . "\n\n";

// 5. Carregar send_admin_notification_ses.php
echo "5. Carregando send_admin_notification_ses.php...\n";
require_once __DIR__ . '/send_admin_notification_ses.php';
echo "   ✅ Carregado\n\n";

// 6. Verificar variável global DEPOIS de carregar
echo "6. Verificando variável global DEPOIS de carregar...\n";
global $awsSdkAvailable;
echo "   \$awsSdkAvailable existe? " . (isset($awsSdkAvailable) ? "SIM = " . var_export($awsSdkAvailable, true) : "NÃO") . "\n";
echo "   Tipo: " . gettype($awsSdkAvailable) . "\n";
echo "   Valor: " . ($awsSdkAvailable ? "true" : "false") . "\n\n";

// 7. Verificar diretamente se a classe existe
echo "7. Verificando se classe Aws\\Ses\\SesClient existe...\n";
if (class_exists('Aws\Ses\SesClient')) {
    echo "   ✅ Classe existe\n";
} else {
    echo "   ❌ Classe NÃO existe\n";
}

// 8. Verificar se vendor/autoload.php existe
echo "\n8. Verificando vendor/autoload.php...\n";
$vendorPath = __DIR__ . '/vendor/autoload.php';
echo "   Caminho: " . $vendorPath . "\n";
echo "   Existe? " . (file_exists($vendorPath) ? "SIM" : "NÃO") . "\n";
if (file_exists($vendorPath)) {
    echo "   Tamanho: " . filesize($vendorPath) . " bytes\n";
}

// 9. Testar função diretamente
echo "\n9. Testando função enviarNotificacaoAdministradores...\n";
$testData = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test'
];

$result = enviarNotificacaoAdministradores($testData);
echo "   Resultado:\n";
echo "   - success: " . ($result['success'] ? "true" : "false") . "\n";
if (isset($result['error'])) {
    echo "   - error: " . $result['error'] . "\n";
}

echo "\n=== FIM DEBUG ===\n";

