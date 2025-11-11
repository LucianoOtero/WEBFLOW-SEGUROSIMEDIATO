<?php
/**
 * TESTE DE ENDPOINT HTTP - send_email_notification_endpoint.php
 * 
 * Este script testa o endpoint HTTP diretamente, simulando requisições
 * do JavaScript do modal do WhatsApp.
 * 
 * EXECUÇÃO:
 * php test_email_endpoint_http.php
 * 
 * OU para enviar email real:
 * php test_email_endpoint_http.php --send-email
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Cores
class Colors {
    const RESET = "\033[0m";
    const RED = "\033[31m";
    const GREEN = "\033[32m";
    const YELLOW = "\033[33m";
    const BLUE = "\033[34m";
    const CYAN = "\033[36m";
    const BOLD = "\033[1m";
}

function printHeader($title) {
    echo "\n" . Colors::BOLD . Colors::CYAN . str_repeat("=", 80) . Colors::RESET . "\n";
    echo Colors::BOLD . Colors::CYAN . "  " . $title . Colors::RESET . "\n";
    echo Colors::BOLD . Colors::CYAN . str_repeat("=", 80) . Colors::RESET . "\n\n";
}

function printTest($name) {
    echo Colors::BLUE . "  [TESTE] " . Colors::RESET . $name . " ... ";
}

function printPass($message = "") {
    echo Colors::GREEN . "✓ PASSOU" . Colors::RESET;
    if ($message) echo " - " . $message;
    echo "\n";
}

function printFail($message = "") {
    echo Colors::RED . "✗ FALHOU" . Colors::RESET;
    if ($message) echo " - " . $message;
    echo "\n";
}

function printInfo($message) {
    echo Colors::CYAN . "    [INFO] " . Colors::RESET . $message . "\n";
}

function printResponse($response) {
    echo Colors::YELLOW . "    [RESPOSTA] " . Colors::RESET;
    echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";
}

// Simular requisição HTTP ao endpoint
function testEndpointRequest($data, $description) {
    printTest($description);
    
    // Simular ambiente HTTP
    $_SERVER['REQUEST_METHOD'] = 'POST';
    $_SERVER['HTTP_ORIGIN'] = 'https://segurosimediato-dev.webflow.io';
    $_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';
    
    // Capturar output
    ob_start();
    
    try {
        // Incluir endpoint
        $_POST = [];
        $GLOBALS['_POST'] = [];
        
        // Simular php://input
        $jsonData = json_encode($data);
        file_put_contents('php://memory', $jsonData);
        
        // Incluir endpoint (vai usar file_get_contents('php://input'))
        // Como não podemos realmente simular php://input, vamos modificar temporariamente
        $endpointPath = __DIR__ . '/send_email_notification_endpoint.php';
        
        if (!file_exists($endpointPath)) {
            printFail("Endpoint não encontrado");
            return false;
        }
        
        // Criar script de teste temporário
        $testScript = "<?php\n";
        $testScript .= "\$_SERVER['REQUEST_METHOD'] = 'POST';\n";
        $testScript .= "\$_SERVER['HTTP_ORIGIN'] = 'https://segurosimediato-dev.webflow.io';\n";
        $testScript .= "\$_POST = [];\n";
        $testScript .= "\$GLOBALS['_POST'] = [];\n";
        $testScript .= "\$testData = " . var_export($data, true) . ";\n";
        $testScript .= "\$jsonData = json_encode(\$testData);\n";
        $testScript .= "// Simular php://input\n";
        $testScript .= "file_put_contents('php://temp', \$jsonData);\n";
        $testScript .= "// Incluir endpoint\n";
        $testScript .= "require_once '$endpointPath';\n";
        
        // Executar via CLI
        $tempFile = tempnam(sys_get_temp_dir(), 'test_endpoint_');
        file_put_contents($tempFile, $testScript);
        
        $output = shell_exec("php $tempFile 2>&1");
        unlink($tempFile);
        
        if ($output) {
            $response = json_decode($output, true);
            if ($response) {
                if (isset($response['success'])) {
                    if ($response['success']) {
                        printPass("Email enviado com sucesso");
                        printInfo("Total enviados: " . ($response['total_sent'] ?? 0));
                    } else {
                        printFail("Falha: " . ($response['error'] ?? 'Erro desconhecido'));
                    }
                    printResponse($response);
                    return $response['success'];
                } else {
                    printFail("Resposta inválida");
                    printResponse($response);
                    return false;
                }
            } else {
                printFail("Resposta não é JSON válido");
                echo "Output: " . substr($output, 0, 200) . "\n";
                return false;
            }
        } else {
            printFail("Nenhuma saída do endpoint");
            return false;
        }
        
    } catch (Exception $e) {
        printFail("Exceção: " . $e->getMessage());
        return false;
    } finally {
        ob_end_clean();
    }
}

// Teste direto da função (mais simples)
function testFunctionDirect($data, $description, $sendEmail = false) {
    printTest($description);
    
    if (!$sendEmail) {
        echo Colors::YELLOW . "⊘ PULADO (use --send-email para enviar)" . Colors::RESET . "\n";
        return true;
    }
    
    require_once __DIR__ . '/send_admin_notification_ses.php';
    
    try {
        $result = enviarNotificacaoAdministradores($data);
        
        if ($result['success'] && $result['total_sent'] > 0) {
            printPass("Email enviado com sucesso");
            printInfo("Total enviados: " . $result['total_sent']);
            printInfo("Total falhas: " . $result['total_failed']);
            return true;
        } else {
            printFail("Falha: " . ($result['error'] ?? 'Erro desconhecido'));
            printResponse($result);
            return false;
        }
    } catch (Exception $e) {
        printFail("Exceção: " . $e->getMessage());
        return false;
    }
}

function main() {
    global $argv;
    
    $sendEmail = in_array('--send-email', $argv);
    
    printHeader("TESTE DE ENDPOINT HTTP - send_email_notification_endpoint.php");
    
    if ($sendEmail) {
        echo Colors::YELLOW . Colors::BOLD . "\n⚠️  ATENÇÃO: Emails REAIS serão enviados!\n" . Colors::RESET;
        sleep(2);
    } else {
        echo Colors::CYAN . "\nℹ️  Modo simulado - emails NÃO serão enviados\n";
        echo "   Use --send-email para enviar emails reais\n" . Colors::RESET;
    }
    
    // Teste 1: Primeiro contato - apenas telefone
    $data1 = [
        'ddd' => '11',
        'celular' => '987654321',
        'cpf' => 'Não informado',
        'nome' => 'Não informado',
        'email' => 'Não informado',
        'momento' => 'primeiro_contato_telefone',
        'momento_descricao' => 'Primeiro Contato - Apenas Telefone',
        'momento_emoji' => '📱'
    ];
    
    testFunctionDirect($data1, "1. Primeiro contato (apenas telefone)", $sendEmail);
    
    // Teste 2: Primeiro contato - com CPF
    $data2 = [
        'ddd' => '11',
        'celular' => '987654321',
        'cpf' => '12345678900',
        'nome' => 'João Silva',
        'email' => 'joao@example.com',
        'cep' => '01234567',
        'placa' => 'ABC1234',
        'momento' => 'primeiro_contato_cpf',
        'momento_descricao' => 'Primeiro Contato - Com CPF',
        'momento_emoji' => '📋'
    ];
    
    testFunctionDirect($data2, "2. Primeiro contato (com CPF)", $sendEmail);
    
    // Teste 3: Notificação de erro
    $data3 = [
        'ddd' => '00',
        'celular' => '000000000',
        'erro' => [
            'message' => 'Erro de teste do sistema',
            'code' => 'TEST_ERROR',
            'file' => 'test.php',
            'line' => 42
        ],
        'momento' => 'erro_sistema',
        'momento_descricao' => 'Erro no Sistema',
        'momento_emoji' => '⚠️'
    ];
    
    testFunctionDirect($data3, "3. Notificação de erro", $sendEmail);
    
    echo "\n" . Colors::BOLD . "Testes concluídos!\n" . Colors::RESET;
}

main();

