<?php
/**
 * TESTE DE DEBUG DO log_endpoint.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== TESTE DE DEBUG log_endpoint.php ===\n\n";

// 1. Testar carregamento do ProfessionalLogger
echo "1. Testando carregamento do ProfessionalLogger...\n";
try {
    require_once __DIR__ . '/ProfessionalLogger.php';
    echo "   ✅ ProfessionalLogger.php carregado\n";
} catch (Exception $e) {
    echo "   ❌ Erro ao carregar: " . $e->getMessage() . "\n";
    exit(1);
}

// 2. Testar criação de instância
echo "\n2. Testando criação de instância...\n";
try {
    $logger = new ProfessionalLogger();
    echo "   ✅ Instância criada\n";
} catch (Exception $e) {
    echo "   ❌ Erro ao criar instância: " . $e->getMessage() . "\n";
    echo "   Stack trace: " . $e->getTraceAsString() . "\n";
    exit(1);
}

// 3. Testar rate limiting (diretório temporário)
echo "\n3. Testando rate limiting (diretório temporário)...\n";
try {
    $tempDir = sys_get_temp_dir();
    echo "   Diretório temporário: $tempDir\n";
    $testFile = $tempDir . '/log_rate_limit_test_' . uniqid() . '.tmp';
    $result = file_put_contents($testFile, 'test');
    if ($result !== false) {
        echo "   ✅ Escrita no diretório temporário OK\n";
        unlink($testFile);
    } else {
        echo "   ❌ Falha ao escrever no diretório temporário\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erro: " . $e->getMessage() . "\n";
}

// 4. Testar inserção de log
echo "\n4. Testando inserção de log...\n";
try {
    $logId = $logger->log('INFO', 'Teste de debug do log_endpoint.php', ['test' => true], 'TEST');
    if ($logId !== false) {
        echo "   ✅ Log inserido com sucesso. ID: $logId\n";
    } else {
        echo "   ❌ Falha ao inserir log\n";
    }
} catch (Exception $e) {
    echo "   ❌ Erro ao inserir log: " . $e->getMessage() . "\n";
    echo "   Stack trace: " . $e->getTraceAsString() . "\n";
}

// 5. Simular requisição POST
echo "\n5. Simulando requisição POST...\n";
try {
    // Simular dados JSON
    $jsonData = json_encode([
        'level' => 'INFO',
        'message' => 'Teste via script',
        'category' => 'TEST',
        'data' => ['test' => true]
    ]);
    
    // Simular file_get_contents('php://input')
    $tempInput = tmpfile();
    fwrite($tempInput, $jsonData);
    rewind($tempInput);
    
    // Simular processamento
    $input = json_decode($jsonData, true);
    if ($input) {
        echo "   ✅ JSON decodificado com sucesso\n";
        echo "   Level: " . $input['level'] . "\n";
        echo "   Message: " . $input['message'] . "\n";
    } else {
        echo "   ❌ Erro ao decodificar JSON: " . json_last_error_msg() . "\n";
    }
    
    fclose($tempInput);
} catch (Exception $e) {
    echo "   ❌ Erro: " . $e->getMessage() . "\n";
}

echo "\n=== TESTE CONCLUÍDO ===\n";

