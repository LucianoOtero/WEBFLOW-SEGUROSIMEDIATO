<?php
/**
 * Simulação EXATA da requisição HTTP do JavaScript
 * Usa stream context para simular php://input
 */

echo "=== SIMULAÇÃO REQUISIÇÃO HTTP REAL ===\n\n";

// Dados que o JavaScript envia
$postData = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test_simulation',
    'momento_descricao' => 'Teste Simulação HTTP'
];

$jsonData = json_encode($postData);

echo "1. Dados que serão enviados:\n";
echo json_encode($postData, JSON_PRETTY_PRINT) . "\n\n";

// Simular variáveis de servidor HTTP
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['HTTP_ORIGIN'] = 'https://segurosimediato-dev.webflow.io';
$_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';
$_SERVER['HTTP_ACCEPT'] = 'application/json';
$_SERVER['REQUEST_URI'] = '/send_email_notification_endpoint.php';
$_SERVER['SCRIPT_NAME'] = '/send_email_notification_endpoint.php';
$_SERVER['PHP_SELF'] = '/send_email_notification_endpoint.php';

// Criar um arquivo temporário para simular php://input
$tempInput = tmpfile();
fwrite($tempInput, $jsonData);
rewind($tempInput);

// Substituir php://input temporariamente usando stream wrapper
// Mas como não podemos fazer isso diretamente, vamos modificar o endpoint temporariamente
// ou criar uma cópia que aceita dados via parâmetro

echo "2. Simulando chamada ao endpoint...\n";
echo "   Método: POST\n";
echo "   Content-Type: application/json\n";
echo "   Origin: https://segurosimediato-dev.webflow.io\n";
echo "   Body: $jsonData\n\n";

// Capturar output e erros
ob_start();
$errorOutput = '';

// Redirecionar error_log para captura
$originalErrorHandler = set_error_handler(function($errno, $errstr, $errfile, $errline) use (&$errorOutput) {
    $errorOutput .= "[$errno] $errstr in $errfile:$errline\n";
    return false;
});

// Simular php://input usando uma função wrapper
function mock_php_input($data) {
    // Criar um stream wrapper temporário
    $GLOBALS['__MOCK_PHP_INPUT__'] = $data;
}

// Substituir file_get_contents('php://input') temporariamente
function file_get_contents_mock($filename) {
    if ($filename === 'php://input' && isset($GLOBALS['__MOCK_PHP_INPUT__'])) {
        return $GLOBALS['__MOCK_PHP_INPUT__'];
    }
    return file_get_contents($filename);
}

// Não podemos substituir file_get_contents diretamente, então vamos
// criar uma versão modificada do endpoint para teste

echo "3. Executando lógica do endpoint...\n\n";

// Executar a lógica do endpoint manualmente
try {
    // Headers (como o endpoint faz)
    header('Content-Type: application/json; charset=utf-8');
    
    // Carregar arquivos (como o endpoint faz)
    require_once __DIR__ . '/ProfessionalLogger.php';
    require_once __DIR__ . '/send_admin_notification_ses.php';
    
    // Simular leitura de php://input
    $rawInput = $jsonData; // Simulando file_get_contents('php://input')
    $data = json_decode($rawInput, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('JSON inválido: ' . json_last_error_msg());
    }
    
    // Validar dados (como o endpoint faz)
    $ddd = $data['ddd'] ?? '';
    $celular = $data['celular'] ?? '';
    
    if (empty($ddd) || empty($celular)) {
        throw new Exception('DDD e CELULAR são obrigatórios');
    }
    
    // Preparar dados (como o endpoint faz)
    $emailData = [
        'ddd' => $ddd,
        'celular' => $celular,
        'cpf' => $data['cpf'] ?? 'Não informado',
        'nome' => $data['nome'] ?? 'Não informado',
        'email' => $data['email'] ?? 'Não informado',
        'cep' => $data['cep'] ?? 'Não informado',
        'placa' => $data['placa'] ?? 'Não informado',
        'gclid' => $data['gclid'] ?? 'Não informado',
        'momento' => $data['momento'] ?? 'unknown',
        'momento_descricao' => $data['momento_descricao'] ?? 'Notificação',
        'momento_emoji' => $data['momento_emoji'] ?? '📧',
        'erro' => $data['erro'] ?? null
    ];
    
    echo "4. Dados preparados para enviarNotificacaoAdministradores:\n";
    echo json_encode($emailData, JSON_PRETTY_PRINT) . "\n\n";
    
    // Verificar estado ANTES de chamar a função
    echo "5. Estado ANTES de chamar enviarNotificacaoAdministradores:\n";
    global $awsSdkAvailable;
    echo "   \$awsSdkAvailable definida: " . (isset($awsSdkAvailable) ? "SIM" : "NÃO") . "\n";
    if (isset($awsSdkAvailable)) {
        echo "   Valor: " . var_export($awsSdkAvailable, true) . "\n";
        echo "   Tipo: " . gettype($awsSdkAvailable) . "\n";
    }
    echo "   Classe Aws\\Ses\\SesClient existe: " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO") . "\n\n";
    
    // Chamar função (como o endpoint faz)
    echo "6. Chamando enviarNotificacaoAdministradores...\n";
    $result = enviarNotificacaoAdministradores($emailData);
    
    echo "\n7. Resultado:\n";
    echo json_encode($result, JSON_PRETTY_PRINT) . "\n\n";
    
    // Verificar se há debug info
    if (isset($result['debug'])) {
        echo "8. Informações de debug:\n";
        echo json_encode($result['debug'], JSON_PRETTY_PRINT) . "\n\n";
    }
    
} catch (Exception $e) {
    echo "❌ ERRO: " . $e->getMessage() . "\n";
    echo "Arquivo: " . $e->getFile() . "\n";
    echo "Linha: " . $e->getLine() . "\n";
    echo "Stack trace:\n" . $e->getTraceAsString() . "\n";
}

$output = ob_get_clean();
if ($output) {
    echo "Output capturado:\n$output\n\n";
}

if ($errorOutput) {
    echo "Erros capturados:\n$errorOutput\n";
}

// Restaurar error handler
restore_error_handler();

echo "=== FIM SIMULAÇÃO ===\n";

