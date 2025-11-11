<?php
/**
 * Teste que simula EXATAMENTE a chamada HTTP do JavaScript
 * Incluindo todos os headers e contexto
 */

// Simular exatamente o que o endpoint recebe
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['HTTP_ORIGIN'] = 'https://segurosimediato-dev.webflow.io';
$_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';

// Simular php://input
$testData = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test_exact_http',
    'momento_descricao' => 'Teste HTTP Exato'
];

// Capturar output
ob_start();

// Executar o endpoint EXATAMENTE como ele é executado
try {
    // Incluir o endpoint
    include __DIR__ . '/send_email_notification_endpoint.php';
} catch (Throwable $e) {
    echo "ERRO: " . $e->getMessage() . "\n";
    echo "Arquivo: " . $e->getFile() . "\n";
    echo "Linha: " . $e->getLine() . "\n";
    echo "Stack trace:\n" . $e->getTraceAsString() . "\n";
}

$output = ob_get_clean();

echo "=== TESTE ENDPOINT EXATO ===\n\n";
echo "Output capturado:\n";
echo $output;
echo "\n\n";

// Verificar logs de erro do PHP
echo "Últimos erros do PHP:\n";
$errors = error_get_last();
if ($errors) {
    print_r($errors);
} else {
    echo "Nenhum erro registrado\n";
}

