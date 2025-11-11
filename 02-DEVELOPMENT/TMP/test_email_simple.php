<?php
/**
 * Teste simples para verificar envio de email
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "Testando envio de email...\n\n";

// Carregar função
require_once __DIR__ . '/send_admin_notification_ses.php';

// Verificar variável global
global $awsSdkAvailable;
echo "AWS SDK Available: " . ($awsSdkAvailable ? "SIM" : "NAO") . "\n";

if (!$awsSdkAvailable) {
    echo "ERRO: AWS SDK não disponível!\n";
    exit(1);
}

// Dados de teste
$testData = [
    'ddd' => '11',
    'celular' => '987654321',
    'cpf' => '12345678900',
    'nome' => 'Teste Sistema',
    'email' => 'teste@example.com',
    'momento' => 'test_sistema',
    'momento_descricao' => 'Teste do Sistema de Email',
    'momento_emoji' => '🧪'
];

echo "\nEnviando email de teste...\n";
$result = enviarNotificacaoAdministradores($testData);

echo "\nResultado:\n";
echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) . "\n";

if ($result['success']) {
    echo "\n✅ Email enviado com sucesso!\n";
    echo "Total enviados: " . $result['total_sent'] . "\n";
} else {
    echo "\n❌ Falha no envio: " . ($result['error'] ?? 'Erro desconhecido') . "\n";
    exit(1);
}

