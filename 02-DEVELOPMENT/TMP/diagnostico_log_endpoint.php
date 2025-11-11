<?php
/**
 * diagnostico_log_endpoint.php - Diagnóstico Completo do log_endpoint.php
 * 
 * Testa todas as etapas do processo de logging para identificar problemas
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== DIAGNÓSTICO COMPLETO DO LOG_ENDPOINT.PHP ===\n\n";

// 1. Verificar se ProfessionalLogger.php existe
echo "1. Verificando ProfessionalLogger.php...\n";
$loggerPath = __DIR__ . '/ProfessionalLogger.php';
if (file_exists($loggerPath)) {
    echo "   ✅ Arquivo existe\n";
} else {
    echo "   ❌ Arquivo NÃO existe em: $loggerPath\n";
    exit(1);
}

// 2. Tentar carregar ProfessionalLogger
echo "\n2. Tentando carregar ProfessionalLogger...\n";
try {
    require_once $loggerPath;
    echo "   ✅ ProfessionalLogger carregado\n";
} catch (Exception $e) {
    echo "   ❌ Erro ao carregar: " . $e->getMessage() . "\n";
    exit(1);
} catch (Error $e) {
    echo "   ❌ Erro fatal ao carregar: " . $e->getMessage() . "\n";
    exit(1);
}

// 3. Verificar variáveis de ambiente
echo "\n3. Verificando variáveis de ambiente...\n";
$envVars = [
    'LOG_DB_HOST',
    'LOG_DB_PORT',
    'LOG_DB_NAME',
    'LOG_DB_USER',
    'LOG_DB_PASS',
    'PHP_ENV'
];

foreach ($envVars as $var) {
    $value = $_ENV[$var] ?? getenv($var);
    if ($value !== false && $value !== null) {
        if ($var === 'LOG_DB_PASS') {
            echo "   ✅ $var: " . str_repeat('*', strlen($value)) . " (length: " . strlen($value) . ")\n";
        } else {
            echo "   ✅ $var: $value\n";
        }
    } else {
        echo "   ⚠️  $var: NÃO DEFINIDA\n";
    }
}

// 4. Tentar instanciar ProfessionalLogger
echo "\n4. Tentando instanciar ProfessionalLogger...\n";
try {
    $logger = new ProfessionalLogger();
    echo "   ✅ Instância criada com sucesso\n";
    echo "   ✅ Request ID: " . $logger->getRequestId() . "\n";
} catch (Exception $e) {
    echo "   ❌ Erro ao criar instância: " . $e->getMessage() . "\n";
    echo "   📍 Arquivo: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "   📍 Stack trace:\n" . $e->getTraceAsString() . "\n";
    exit(1);
} catch (Error $e) {
    echo "   ❌ Erro fatal ao criar instância: " . $e->getMessage() . "\n";
    echo "   📍 Arquivo: " . $e->getFile() . ":" . $e->getLine() . "\n";
    exit(1);
}

// 5. Testar conexão com banco de dados
echo "\n5. Testando conexão com banco de dados...\n";
try {
    $conn = $logger->getConnection();
    if ($conn) {
        echo "   ✅ Conexão estabelecida\n";
    } else {
        echo "   ❌ Conexão FALHOU (retornou null)\n";
        exit(1);
    }
} catch (Exception $e) {
    echo "   ❌ Erro na conexão: " . $e->getMessage() . "\n";
    exit(1);
}

// 6. Testar inserção de log
echo "\n6. Testando inserção de log...\n";
try {
    $logId = $logger->info('Teste de diagnóstico', ['test' => true, 'timestamp' => date('Y-m-d H:i:s')], 'DIAGNOSTIC');
    if ($logId) {
        echo "   ✅ Log inserido com sucesso\n";
        echo "   ✅ Log ID: $logId\n";
    } else {
        echo "   ❌ Inserção FALHOU (retornou false)\n";
        exit(1);
    }
} catch (Exception $e) {
    echo "   ❌ Erro na inserção: " . $e->getMessage() . "\n";
    echo "   📍 Arquivo: " . $e->getFile() . ":" . $e->getLine() . "\n";
    exit(1);
}

// 7. Simular requisição POST completa
echo "\n7. Simulando requisição POST completa...\n";
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['REMOTE_ADDR'] = '127.0.0.1';
$_SERVER['HTTP_USER_AGENT'] = 'Diagnostic Test';
$_SERVER['HTTP_REFERER'] = 'https://test.local/';

// Simular JSON input
$testPayload = [
    'level' => 'INFO',
    'message' => 'Teste de requisição completa',
    'category' => 'TEST',
    'data' => ['test' => true],
    'session_id' => 'test_session_123'
];

// Capturar output
ob_start();
$_POST = [];
file_put_contents('php://memory', json_encode($testPayload));
// Simular file_get_contents('php://input')
$originalInput = file_get_contents('php://input');
// Não podemos realmente simular php://input, então vamos testar diretamente

echo "   ✅ Payload preparado: " . json_encode($testPayload) . "\n";

// 8. Testar método log() diretamente
echo "\n8. Testando método log() diretamente...\n";
try {
    $logId = $logger->log(
        'INFO',
        'Teste de requisição completa',
        ['test' => true],
        'TEST',
        null,
        [
            'file_name' => 'test.js',
            'file_path' => '/test/test.js',
            'line_number' => 123,
            'function_name' => 'testFunction'
        ]
    );
    if ($logId) {
        echo "   ✅ Log inserido via método log()\n";
        echo "   ✅ Log ID: $logId\n";
    } else {
        echo "   ❌ Método log() FALHOU\n";
        exit(1);
    }
} catch (Exception $e) {
    echo "   ❌ Erro no método log(): " . $e->getMessage() . "\n";
    echo "   📍 Arquivo: " . $e->getFile() . ":" . $e->getLine() . "\n";
    exit(1);
}

echo "\n=== DIAGNÓSTICO CONCLUÍDO COM SUCESSO ===\n";
echo "✅ Todos os testes passaram!\n";

