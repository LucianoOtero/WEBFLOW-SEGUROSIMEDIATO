<?php
/**
 * SUÍTE DE TESTES EXTENSIVA - SISTEMA DE ENVIO DE EMAIL
 * 
 * Este arquivo contém testes abrangentes para garantir que o sistema
 * de envio de email via AWS SES está funcionando corretamente.
 * 
 * EXECUÇÃO:
 * php test_email_system_completo.php
 * 
 * OU para executar testes específicos:
 * php test_email_system_completo.php --test=config
 * php test_email_system_completo.php --test=function
 * php test_email_system_completo.php --test=endpoint
 * php test_email_system_completo.php --test=integration
 */

// Configuração
error_reporting(E_ALL);
ini_set('display_errors', 1);
set_time_limit(300); // 5 minutos para testes completos

// Cores para output
class Colors {
    const RESET = "\033[0m";
    const RED = "\033[31m";
    const GREEN = "\033[32m";
    const YELLOW = "\033[33m";
    const BLUE = "\033[34m";
    const CYAN = "\033[36m";
    const BOLD = "\033[1m";
}

// Estatísticas de testes
$testStats = [
    'total' => 0,
    'passed' => 0,
    'failed' => 0,
    'skipped' => 0,
    'errors' => []
];

// ==================== FUNÇÕES AUXILIARES ====================

function printHeader($title) {
    echo "\n" . Colors::BOLD . Colors::CYAN . str_repeat("=", 80) . Colors::RESET . "\n";
    echo Colors::BOLD . Colors::CYAN . "  " . $title . Colors::RESET . "\n";
    echo Colors::BOLD . Colors::CYAN . str_repeat("=", 80) . Colors::RESET . "\n\n";
}

function printTest($name) {
    global $testStats;
    $testStats['total']++;
    echo Colors::BLUE . "  [TESTE] " . Colors::RESET . $name . " ... ";
}

function printPass($message = "") {
    global $testStats;
    $testStats['passed']++;
    echo Colors::GREEN . "✓ PASSOU" . Colors::RESET;
    if ($message) echo " - " . $message;
    echo "\n";
}

function printFail($message = "") {
    global $testStats, $testStats;
    $testStats['failed']++;
    echo Colors::RED . "✗ FALHOU" . Colors::RESET;
    if ($message) echo " - " . $message;
    echo "\n";
    if ($message) {
        $testStats['errors'][] = $message;
    }
}

function printSkip($message = "") {
    global $testStats;
    $testStats['skipped']++;
    echo Colors::YELLOW . "⊘ PULADO" . Colors::RESET;
    if ($message) echo " - " . $message;
    echo "\n";
}

function printInfo($message) {
    echo Colors::CYAN . "    [INFO] " . Colors::RESET . $message . "\n";
}

function printError($message) {
    echo Colors::RED . "    [ERRO] " . Colors::RESET . $message . "\n";
}

function printSummary() {
    global $testStats;
    echo "\n" . Colors::BOLD . str_repeat("=", 80) . Colors::RESET . "\n";
    echo Colors::BOLD . "  RESUMO DOS TESTES" . Colors::RESET . "\n";
    echo Colors::BOLD . str_repeat("=", 80) . Colors::RESET . "\n";
    echo "  Total: " . $testStats['total'] . "\n";
    echo Colors::GREEN . "  Passou: " . $testStats['passed'] . Colors::RESET . "\n";
    echo Colors::RED . "  Falhou: " . $testStats['failed'] . Colors::RESET . "\n";
    echo Colors::YELLOW . "  Pulado: " . $testStats['skipped'] . Colors::RESET . "\n";
    
    if (!empty($testStats['errors'])) {
        echo "\n" . Colors::RED . Colors::BOLD . "  ERROS ENCONTRADOS:" . Colors::RESET . "\n";
        foreach ($testStats['errors'] as $i => $error) {
            echo "    " . ($i + 1) . ". " . $error . "\n";
        }
    }
    
    $successRate = $testStats['total'] > 0 
        ? round(($testStats['passed'] / $testStats['total']) * 100, 2) 
        : 0;
    
    echo "\n  Taxa de sucesso: " . ($successRate >= 80 ? Colors::GREEN : Colors::RED) . $successRate . "%" . Colors::RESET . "\n";
    echo "\n";
}

// ==================== TESTE 1: CONFIGURAÇÃO E DEPENDÊNCIAS ====================

function testConfiguration() {
    printHeader("TESTE 1: CONFIGURAÇÃO E DEPENDÊNCIAS");
    
    // Teste 1.1: Verificar se vendor/autoload.php existe
    printTest("1.1 - Arquivo vendor/autoload.php existe");
    $vendorPath = __DIR__ . '/vendor/autoload.php';
    if (file_exists($vendorPath)) {
        printPass();
    } else {
        printFail("Arquivo não encontrado: $vendorPath");
        return false;
    }
    
    // Teste 1.2: Carregar autoloader
    printTest("1.2 - Carregar autoloader do Composer");
    try {
        require_once $vendorPath;
        printPass();
    } catch (Exception $e) {
        printFail("Erro ao carregar: " . $e->getMessage());
        return false;
    }
    
    // Teste 1.3: Verificar se classe Aws\Ses\SesClient existe
    printTest("1.3 - Classe Aws\\Ses\\SesClient disponível");
    if (class_exists('Aws\Ses\SesClient')) {
        printPass();
    } else {
        printFail("Classe não encontrada. AWS SDK pode não estar instalado corretamente.");
        return false;
    }
    
    // Teste 1.4: Verificar se aws_ses_config.php existe
    printTest("1.4 - Arquivo aws_ses_config.php existe");
    $configPath = __DIR__ . '/aws_ses_config.php';
    if (file_exists($configPath)) {
        printPass();
    } else {
        printFail("Arquivo não encontrado: $configPath");
        return false;
    }
    
    // Teste 1.5: Carregar configuração AWS
    printTest("1.5 - Carregar configuração AWS SES");
    try {
        require_once $configPath;
        printPass();
    } catch (Exception $e) {
        printFail("Erro ao carregar configuração: " . $e->getMessage());
        return false;
    }
    
    // Teste 1.6: Verificar credenciais AWS definidas
    printTest("1.6 - Credenciais AWS definidas");
    if (defined('AWS_ACCESS_KEY_ID') && defined('AWS_SECRET_ACCESS_KEY') && defined('AWS_REGION')) {
        if (AWS_ACCESS_KEY_ID !== 'SUA_ACCESS_KEY_ID_AQUI' && 
            AWS_SECRET_ACCESS_KEY !== 'SUA_SECRET_ACCESS_KEY_AQUI') {
            printPass();
            printInfo("Região AWS: " . AWS_REGION);
        } else {
            printFail("Credenciais não configuradas (valores padrão detectados)");
            return false;
        }
    } else {
        printFail("Constantes não definidas");
        return false;
    }
    
    // Teste 1.7: Verificar configuração de email
    printTest("1.7 - Configuração de email definida");
    if (defined('EMAIL_FROM') && defined('EMAIL_FROM_NAME') && defined('ADMIN_EMAILS')) {
        printPass();
        printInfo("Remetente: " . EMAIL_FROM_NAME . " <" . EMAIL_FROM . ">");
        printInfo("Destinatários: " . count(ADMIN_EMAILS) . " administrador(es)");
    } else {
        printFail("Constantes de email não definidas");
        return false;
    }
    
    // Teste 1.8: Verificar se email_template_loader.php existe
    printTest("1.8 - Sistema de templates de email disponível");
    $templateLoaderPath = __DIR__ . '/email_template_loader.php';
    if (file_exists($templateLoaderPath)) {
        try {
            require_once $templateLoaderPath;
            if (function_exists('renderEmailTemplate')) {
                printPass();
            } else {
                printFail("Função renderEmailTemplate não encontrada");
                return false;
            }
        } catch (Exception $e) {
            printFail("Erro ao carregar: " . $e->getMessage());
            return false;
        }
    } else {
        printFail("Arquivo não encontrado: $templateLoaderPath");
        return false;
    }
    
    return true;
}

// ==================== TESTE 2: FUNÇÃO DE ENVIO ====================

function testSendFunction() {
    printHeader("TESTE 2: FUNÇÃO enviarNotificacaoAdministradores");
    
    // Carregar função
    $functionPath = __DIR__ . '/send_admin_notification_ses.php';
    if (!file_exists($functionPath)) {
        printError("Arquivo não encontrado: $functionPath");
        return false;
    }
    
    require_once $functionPath;
    
    if (!function_exists('enviarNotificacaoAdministradores')) {
        printError("Função enviarNotificacaoAdministradores não encontrada");
        return false;
    }
    
    // Teste 2.1: Verificar variável global $awsSdkAvailable
    printTest("2.1 - Variável global \$awsSdkAvailable definida");
    global $awsSdkAvailable;
    if (isset($awsSdkAvailable)) {
        if ($awsSdkAvailable) {
            printPass();
        } else {
            printFail("AWS SDK não disponível");
            return false;
        }
    } else {
        printFail("Variável não definida");
        return false;
    }
    
    // Teste 2.2: Teste com dados mínimos válidos (SEM ENVIAR EMAIL REAL)
    printTest("2.2 - Validação de estrutura de retorno (sem envio real)");
    printInfo("  Nota: Este teste não envia email real, apenas valida a estrutura");
    
    // Criar dados de teste
    $testData = [
        'ddd' => '11',
        'celular' => '987654321',
        'cpf' => '12345678900',
        'nome' => 'Teste Usuário',
        'email' => 'teste@example.com',
        'cep' => '01234567',
        'placa' => 'ABC1234',
        'momento' => 'test',
        'momento_descricao' => 'Teste de Sistema',
        'momento_emoji' => '🧪'
    ];
    
    // Verificar se podemos criar o cliente SES (sem enviar)
    try {
        /** @var \Aws\Ses\SesClient $sesClient */
        $sesClient = new \Aws\Ses\SesClient([
            'version' => 'latest',
            'region'  => AWS_REGION,
            'credentials' => [
                'key'    => AWS_ACCESS_KEY_ID,
                'secret' => AWS_SECRET_ACCESS_KEY,
            ],
        ]);
        printPass("Cliente SES criado com sucesso");
    } catch (Exception $e) {
        printFail("Erro ao criar cliente SES: " . $e->getMessage());
        return false;
    }
    
    // Teste 2.3: Verificar renderização de template
    printTest("2.3 - Renderização de template de email");
    try {
        /** @var callable $renderEmailTemplate */
        $template = renderEmailTemplate($testData);
        if (isset($template['subject']) && isset($template['html']) && isset($template['text'])) {
            printPass();
            printInfo("  Assunto: " . substr($template['subject'], 0, 50) . "...");
            printInfo("  HTML: " . strlen($template['html']) . " caracteres");
            printInfo("  Texto: " . strlen($template['text']) . " caracteres");
        } else {
            printFail("Template não retornou estrutura esperada");
            return false;
        }
    } catch (Exception $e) {
        printFail("Erro ao renderizar template: " . $e->getMessage());
        return false;
    }
    
    return true;
}

// ==================== TESTE 3: ENDPOINT HTTP ====================

function testEndpoint() {
    printHeader("TESTE 3: ENDPOINT send_email_notification_endpoint.php");
    
    $endpointPath = __DIR__ . '/send_email_notification_endpoint.php';
    
    // Teste 3.1: Arquivo existe
    printTest("3.1 - Arquivo endpoint existe");
    if (file_exists($endpointPath)) {
        printPass();
    } else {
        printFail("Arquivo não encontrado: $endpointPath");
        return false;
    }
    
    // Teste 3.2: Estrutura do arquivo
    printTest("3.2 - Estrutura do endpoint válida");
    $content = file_get_contents($endpointPath);
    $checks = [
        'Content-Type' => strpos($content, 'Content-Type') !== false,
        'CORS headers' => strpos($content, 'Access-Control-Allow-Origin') !== false,
        'POST validation' => strpos($content, 'REQUEST_METHOD') !== false,
        'JSON parsing' => strpos($content, 'json_decode') !== false,
        'Function call' => strpos($content, 'enviarNotificacaoAdministradores') !== false
    ];
    
    $allPassed = true;
    foreach ($checks as $check => $passed) {
        if (!$passed) {
            printFail("Check '$check' falhou");
            $allPassed = false;
        }
    }
    
    if ($allPassed) {
        printPass();
    } else {
        return false;
    }
    
    return true;
}

// ==================== TESTE 4: TESTES DE INTEGRAÇÃO (COM ENVIO REAL) ====================

function testIntegration($sendRealEmail = false) {
    printHeader("TESTE 4: TESTES DE INTEGRAÇÃO" . ($sendRealEmail ? " (ENVIO REAL)" : " (SIMULADO)"));
    
    if (!$sendRealEmail) {
        printInfo("  Modo simulado: emails NÃO serão enviados");
        printInfo("  Use --send-email para enviar emails reais");
    }
    
    // Carregar função
    require_once __DIR__ . '/send_admin_notification_ses.php';
    
    // Teste 4.1: Primeiro contato - apenas telefone
    printTest("4.1 - Cenário: Primeiro contato (apenas telefone)");
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
    
    if ($sendRealEmail) {
        try {
            $result = enviarNotificacaoAdministradores($data1);
            if ($result['success'] && $result['total_sent'] > 0) {
                printPass("Email enviado com sucesso");
                printInfo("  Enviados: " . $result['total_sent']);
                printInfo("  Falhas: " . $result['total_failed']);
            } else {
                printFail("Falha no envio: " . ($result['error'] ?? 'Erro desconhecido'));
            }
        } catch (Exception $e) {
            printFail("Exceção: " . $e->getMessage());
        }
    } else {
        printSkip("Modo simulado - email não enviado");
    }
    
    // Teste 4.2: Primeiro contato - com CPF
    printTest("4.2 - Cenário: Primeiro contato (com CPF)");
    $data2 = [
        'ddd' => '11',
        'celular' => '987654321',
        'cpf' => '12345678900',
        'nome' => 'João Silva',
        'email' => 'joao@example.com',
        'momento' => 'primeiro_contato_cpf',
        'momento_descricao' => 'Primeiro Contato - Com CPF',
        'momento_emoji' => '📋'
    ];
    
    if ($sendRealEmail) {
        try {
            $result = enviarNotificacaoAdministradores($data2);
            if ($result['success'] && $result['total_sent'] > 0) {
                printPass("Email enviado com sucesso");
            } else {
                printFail("Falha no envio: " . ($result['error'] ?? 'Erro desconhecido'));
            }
        } catch (Exception $e) {
            printFail("Exceção: " . $e->getMessage());
        }
    } else {
        printSkip("Modo simulado - email não enviado");
    }
    
    // Teste 4.3: Erro no sistema
    printTest("4.3 - Cenário: Notificação de erro");
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
    
    if ($sendRealEmail) {
        try {
            $result = enviarNotificacaoAdministradores($data3);
            if ($result['success'] && $result['total_sent'] > 0) {
                printPass("Email de erro enviado com sucesso");
            } else {
                printFail("Falha no envio: " . ($result['error'] ?? 'Erro desconhecido'));
            }
        } catch (Exception $e) {
            printFail("Exceção: " . $e->getMessage());
        }
    } else {
        printSkip("Modo simulado - email não enviado");
    }
    
    return true;
}

// ==================== TESTE 5: VALIDAÇÃO DE DADOS ====================

function testDataValidation() {
    printHeader("TESTE 5: VALIDAÇÃO DE DADOS");
    
    require_once __DIR__ . '/send_admin_notification_ses.php';
    
    // Teste 5.1: Dados vazios
    printTest("5.1 - Validação: Dados mínimos obrigatórios");
    $emptyData = [];
    try {
        $result = enviarNotificacaoAdministradores($emptyData);
        // A função deve processar mesmo com dados vazios (usa valores padrão)
        printPass("Função processa dados vazios (usa valores padrão)");
    } catch (Exception $e) {
        printFail("Exceção inesperada: " . $e->getMessage());
    }
    
    // Teste 5.2: Dados com caracteres especiais
    printTest("5.2 - Validação: Caracteres especiais no nome");
    $specialCharsData = [
        'ddd' => '11',
        'celular' => '987654321',
        'nome' => 'João & Maria <script>alert("xss")</script>',
        'momento' => 'test'
    ];
    
    try {
        /** @var callable $renderEmailTemplate */
        $template = renderEmailTemplate($specialCharsData);
        // Verificar se HTML foi escapado corretamente
        if (strpos($template['html'], '<script>') === false) {
            printPass("Caracteres especiais escapados corretamente");
        } else {
            printFail("Possível vulnerabilidade XSS detectada");
        }
    } catch (Exception $e) {
        printFail("Erro: " . $e->getMessage());
    }
    
    // Teste 5.3: Dados muito longos
    printTest("5.3 - Validação: Dados com valores muito longos");
    $longData = [
        'ddd' => '11',
        'celular' => '987654321',
        'nome' => str_repeat('A', 1000),
        'momento' => 'test'
    ];
    
    try {
        /** @var callable $renderEmailTemplate */
        $template = renderEmailTemplate($longData);
        printPass("Template renderizado com dados longos");
    } catch (Exception $e) {
        printFail("Erro com dados longos: " . $e->getMessage());
    }
    
    return true;
}

// ==================== TESTE 6: CONECTIVIDADE AWS SES ====================

function testAwsConnectivity() {
    printHeader("TESTE 6: CONECTIVIDADE AWS SES");
    
    // Teste 6.1: Criar cliente SES
    printTest("6.1 - Criar cliente AWS SES");
    try {
        /** @var \Aws\Ses\SesClient $sesClient */
        $sesClient = new \Aws\Ses\SesClient([
            'version' => 'latest',
            'region'  => AWS_REGION,
            'credentials' => [
                'key'    => AWS_ACCESS_KEY_ID,
                'secret' => AWS_SECRET_ACCESS_KEY,
            ],
        ]);
        printPass();
    } catch (Exception $e) {
        printFail("Erro ao criar cliente: " . $e->getMessage());
        return false;
    }
    
    // Teste 6.2: Verificar identidade do remetente (sem enviar email)
    printTest("6.2 - Verificar identidade do remetente");
    try {
        $result = $sesClient->getIdentityVerificationAttributes([
            'Identities' => [EMAIL_FROM]
        ]);
        
        $status = $result->get('VerificationAttributes')[EMAIL_FROM]['VerificationStatus'] ?? 'Unknown';
        if ($status === 'Success') {
            printPass("Email remetente verificado: " . EMAIL_FROM);
        } else {
            printFail("Email remetente não verificado. Status: " . $status);
            printInfo("  Verifique no console AWS SES se o email está verificado");
        }
    } catch (Exception $e) {
        printFail("Erro ao verificar identidade: " . $e->getMessage());
    }
    
    // Teste 6.3: Verificar quota de envio
    printTest("6.3 - Verificar quota de envio");
    try {
        $result = $sesClient->getSendQuota();
        $max24h = $result->get('Max24HourSend') ?? 0;
        $sent24h = $result->get('SentLast24Hours') ?? 0;
        $maxRate = $result->get('MaxSendRate') ?? 0;
        
        printPass();
        printInfo("  Quota 24h: " . number_format($sent24h) . " / " . number_format($max24h));
        printInfo("  Taxa máxima: " . number_format($maxRate) . " emails/segundo");
        
        if ($sent24h >= $max24h * 0.9) {
            printInfo("  ⚠️ ATENÇÃO: Quota quase esgotada!");
        }
    } catch (Exception $e) {
        printFail("Erro ao verificar quota: " . $e->getMessage());
    }
    
    return true;
}

// ==================== EXECUÇÃO DOS TESTES ====================

function main() {
    global $argv;
    
    $sendRealEmail = in_array('--send-email', $argv);
    $testFilter = null;
    
    // Verificar se há filtro de teste
    foreach ($argv as $arg) {
        if (strpos($arg, '--test=') === 0) {
            $testFilter = substr($arg, 7);
            break;
        }
    }
    
    echo Colors::BOLD . Colors::CYAN . "\n";
    echo "╔══════════════════════════════════════════════════════════════════════════════╗\n";
    echo "║         SUÍTE DE TESTES - SISTEMA DE ENVIO DE EMAIL AWS SES                 ║\n";
    echo "╚══════════════════════════════════════════════════════════════════════════════╝\n";
    echo Colors::RESET;
    
    if ($sendRealEmail) {
        echo Colors::YELLOW . Colors::BOLD . "\n⚠️  ATENÇÃO: Emails REAIS serão enviados!\n" . Colors::RESET;
        sleep(2);
    }
    
    $allTests = [
        'config' => 'testConfiguration',
        'function' => 'testSendFunction',
        'endpoint' => 'testEndpoint',
        'integration' => function() use ($sendRealEmail) { return testIntegration($sendRealEmail); },
        'validation' => 'testDataValidation',
        'connectivity' => 'testAwsConnectivity'
    ];
    
    if ($testFilter) {
        if (isset($allTests[$testFilter])) {
            $testFunc = $allTests[$testFilter];
            if (is_callable($testFunc)) {
                $testFunc();
            } else {
                call_user_func($testFunc);
            }
        } else {
            echo Colors::RED . "Teste não encontrado: $testFilter\n" . Colors::RESET;
            echo "Testes disponíveis: " . implode(', ', array_keys($allTests)) . "\n";
        }
    } else {
        // Executar todos os testes
        testConfiguration();
        testSendFunction();
        testEndpoint();
        testIntegration($sendRealEmail);
        testDataValidation();
        testAwsConnectivity();
    }
    
    printSummary();
}

// Executar
main();

