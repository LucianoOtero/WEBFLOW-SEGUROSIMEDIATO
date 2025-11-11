<?php
/**
 * Teste que executa o endpoint diretamente via HTTP
 * Usando include para simular requisição real
 */

// Simular ambiente HTTP
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['HTTP_ORIGIN'] = 'https://segurosimediato-dev.webflow.io';
$_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';

// Dados de teste
$testData = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test_direct_http',
    'momento_descricao' => 'Teste HTTP Direto'
];

// Criar stream para simular php://input
$inputData = json_encode($testData);

// Salvar dados em arquivo temporário e usar como input
$tempFile = tempnam(sys_get_temp_dir(), 'php_input_');
file_put_contents($tempFile, $inputData);

// Redirecionar php://input (não é possível diretamente, então vamos modificar temporariamente)
// Vamos criar uma versão do endpoint que aceita dados via GET para teste

echo "=== TESTE ENDPOINT DIRETO VIA HTTP ===\n\n";
echo "Dados de teste: " . json_encode($testData, JSON_PRETTY_PRINT) . "\n\n";

// Capturar output
ob_start();

// Executar endpoint com dados simulados
// Como não podemos modificar php://input, vamos criar um wrapper
class PhpInputWrapper {
    private static $data = null;
    
    public static function setData($data) {
        self::$data = $data;
    }
    
    public static function getData() {
        return self::$data;
    }
}

// Modificar temporariamente file_get_contents para capturar chamadas a php://input
$originalFileGetContents = 'file_get_contents';
PhpInputWrapper::setData($inputData);

// Não podemos sobrescrever file_get_contents, então vamos
// executar a lógica manualmente com os dados simulados

try {
    // Headers
    header('Content-Type: application/json; charset=utf-8');
    
    // Carregar arquivos
    require_once __DIR__ . '/ProfessionalLogger.php';
    require_once __DIR__ . '/send_admin_notification_ses.php';
    
    // Simular leitura de php://input
    $rawInput = $inputData;
    $data = json_decode($rawInput, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('JSON inválido: ' . json_last_error_msg());
    }
    
    // Validar
    $ddd = $data['ddd'] ?? '';
    $celular = $data['celular'] ?? '';
    
    if (empty($ddd) || empty($celular)) {
        throw new Exception('DDD e CELULAR são obrigatórios');
    }
    
    // Preparar dados
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
    
    echo "Estado ANTES de chamar função:\n";
    global $awsSdkAvailable;
    echo "  \$awsSdkAvailable: " . (isset($awsSdkAvailable) ? var_export($awsSdkAvailable, true) : "NÃO DEFINIDA") . "\n";
    echo "  Classe existe: " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO") . "\n\n";
    
    // Chamar função
    $result = enviarNotificacaoAdministradores($emailData);
    
    // Retornar resultado (como o endpoint faz)
    http_response_code(200);
    echo json_encode($result);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}

$output = ob_get_clean();
echo "\n\nOutput do endpoint:\n";
echo $output;
echo "\n\n";

// Limpar arquivo temporário
unlink($tempFile);

echo "=== FIM TESTE ===\n";

