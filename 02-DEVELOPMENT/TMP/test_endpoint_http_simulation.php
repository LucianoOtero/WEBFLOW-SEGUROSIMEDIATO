<?php
/**
 * Teste que simula EXATAMENTE o que acontece quando o endpoint é chamado via HTTP
 * Incluindo todos os passos na ordem exata
 */

// Simular headers HTTP
header('Content-Type: application/json; charset=utf-8');

// Ativar logging de erros
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

echo "=== SIMULAÇÃO EXATA DO ENDPOINT HTTP ===\n\n";

// PASSO 1: Simular o que send_email_notification_endpoint.php faz
echo "PASSO 1: Carregando ProfessionalLogger...\n";
$loggerPath = __DIR__ . '/ProfessionalLogger.php';
echo "   Caminho: $loggerPath\n";
echo "   Existe? " . (file_exists($loggerPath) ? "SIM" : "NÃO") . "\n";
require_once $loggerPath;
echo "   ✅ Carregado\n\n";

// PASSO 2: Verificar estado ANTES de carregar send_admin_notification_ses.php
echo "PASSO 2: Estado ANTES de carregar send_admin_notification_ses.php...\n";
global $awsSdkAvailable;
echo "   \$awsSdkAvailable definida? " . (isset($awsSdkAvailable) ? "SIM = " . var_export($awsSdkAvailable, true) : "NÃO") . "\n";
echo "   Classe Aws\\Ses\\SesClient existe? " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO") . "\n";
echo "   vendor/autoload.php já carregado? " . (class_exists('Composer\Autoload\ClassLoader') ? "SIM" : "NÃO") . "\n\n";

// PASSO 3: Carregar send_admin_notification_ses.php (como o endpoint faz)
echo "PASSO 3: Carregando send_admin_notification_ses.php...\n";
$sesPath = __DIR__ . '/send_admin_notification_ses.php';
echo "   Caminho: $sesPath\n";
echo "   Existe? " . (file_exists($sesPath) ? "SIM" : "NÃO") . "\n";

// Capturar qualquer erro durante o carregamento
$errorsBefore = error_get_last();
require_once $sesPath;
$errorsAfter = error_get_last();

if ($errorsAfter !== $errorsBefore && $errorsAfter !== null) {
    echo "   ⚠️ ERRO durante carregamento: " . $errorsAfter['message'] . "\n";
    echo "   Arquivo: " . $errorsAfter['file'] . "\n";
    echo "   Linha: " . $errorsAfter['line'] . "\n";
} else {
    echo "   ✅ Carregado sem erros aparentes\n";
}
echo "\n";

// PASSO 4: Verificar estado DEPOIS de carregar
echo "PASSO 4: Estado DEPOIS de carregar send_admin_notification_ses.php...\n";
global $awsSdkAvailable;
echo "   \$awsSdkAvailable definida? " . (isset($awsSdkAvailable) ? "SIM = " . var_export($awsSdkAvailable, true) : "NÃO") . "\n";
echo "   Tipo: " . (isset($awsSdkAvailable) ? gettype($awsSdkAvailable) : "N/A") . "\n";
echo "   Valor booleano: " . (isset($awsSdkAvailable) ? ($awsSdkAvailable ? "true" : "false") : "N/A") . "\n";
echo "   Classe Aws\\Ses\\SesClient existe? " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO") . "\n\n";

// PASSO 5: Verificar caminhos usados dentro do arquivo
echo "PASSO 5: Verificando caminhos que o arquivo usa...\n";
$vendorPath = __DIR__ . '/vendor/autoload.php';
echo "   __DIR__: " . __DIR__ . "\n";
echo "   vendor/autoload.php: $vendorPath\n";
echo "   Existe? " . (file_exists($vendorPath) ? "SIM" : "NÃO") . "\n";
if (file_exists($vendorPath)) {
    echo "   Tamanho: " . filesize($vendorPath) . " bytes\n";
    echo "   Legível? " . (is_readable($vendorPath) ? "SIM" : "NÃO") . "\n";
    echo "   Caminho real: " . realpath($vendorPath) . "\n";
}
echo "\n";

// PASSO 6: Testar função enviarNotificacaoAdministradores
echo "PASSO 6: Testando função enviarNotificacaoAdministradores...\n";
$testData = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test',
    'momento_descricao' => 'Teste HTTP'
];

// Capturar output da função
ob_start();
$result = enviarNotificacaoAdministradores($testData);
$output = ob_get_clean();

echo "   Resultado:\n";
echo "   - success: " . ($result['success'] ? "true" : "false") . "\n";
if (isset($result['error'])) {
    echo "   - error: " . $result['error'] . "\n";
}
echo "   - total_sent: " . ($result['total_sent'] ?? 0) . "\n";
if ($output) {
    echo "   - output capturado: $output\n";
}
echo "\n";

// PASSO 7: Verificar variável global DENTRO da função (simular)
echo "PASSO 7: Verificando acesso à variável global dentro de função...\n";
function testGlobalAccess() {
    global $awsSdkAvailable;
    return [
        'isset' => isset($awsSdkAvailable),
        'value' => $awsSdkAvailable ?? 'NÃO DEFINIDA',
        'type' => isset($awsSdkAvailable) ? gettype($awsSdkAvailable) : 'N/A',
        'bool' => isset($awsSdkAvailable) ? ($awsSdkAvailable ? 'true' : 'false') : 'N/A'
    ];
}
$globalTest = testGlobalAccess();
echo "   isset(\$awsSdkAvailable): " . ($globalTest['isset'] ? "SIM" : "NÃO") . "\n";
echo "   Valor: " . var_export($globalTest['value'], true) . "\n";
echo "   Tipo: " . $globalTest['type'] . "\n";
echo "   Booleano: " . $globalTest['bool'] . "\n\n";

// PASSO 8: Verificar se há múltiplas definições da variável
echo "PASSO 8: Verificando se variável foi redefinida em algum lugar...\n";
$reflection = new ReflectionFunction('enviarNotificacaoAdministradores');
$functionFile = $reflection->getFileName();
echo "   Arquivo da função: $functionFile\n";
echo "   Linha: " . $reflection->getStartLine() . "\n";

// Ler o arquivo e procurar por redefinições
$fileContent = file_get_contents($functionFile);
$matches = [];
preg_match_all('/\$awsSdkAvailable\s*=/', $fileContent, $matches, PREG_OFFSET_CAPTURE);
echo "   Ocorrências de '\$awsSdkAvailable =': " . count($matches[0]) . "\n";
foreach ($matches[0] as $i => $match) {
    $line = substr_count(substr($fileContent, 0, $match[1]), "\n") + 1;
    echo "   - Linha $line\n";
}

echo "\n=== FIM SIMULAÇÃO ===\n";

