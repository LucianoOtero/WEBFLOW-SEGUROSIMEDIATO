<?php
/**
 * Comparação EXATA entre chamada do Modal e testes
 */

echo "=== COMPARAÇÃO: MODAL vs TESTES ===\n\n";

// DADOS QUE O MODAL ENVIA (linha 694-713)
echo "1. DADOS QUE O MODAL ENVIA:\n";
$modalPayload = [
    'ddd' => '11',
    'celular' => '916481648',
    'cpf' => 'Não informado',
    'nome' => 'Não informado',
    'email' => 'Não informado',
    'cep' => 'Não informado',
    'placa' => 'Não informado',
    'gclid' => 'Não informado',
    'momento' => 'initial_contact', // Exemplo do modal
    'momento_descricao' => 'Primeiro Contato - Apenas Telefone',
    'momento_emoji' => '📞',
    'erro' => null
];
echo json_encode($modalPayload, JSON_PRETTY_PRINT) . "\n\n";

// HEADERS QUE O MODAL ENVIA (linha 733-736)
echo "2. HEADERS QUE O MODAL ENVIA:\n";
$modalHeaders = [
    'Content-Type' => 'application/json',
    'User-Agent' => 'Modal-WhatsApp-EmailNotification-v1.0'
];
echo json_encode($modalHeaders, JSON_PRETTY_PRINT) . "\n\n";

// MÉTODO QUE O MODAL USA (linha 732)
echo "3. MÉTODO: POST\n\n";

// COMPARAR COM TESTES
echo "4. COMPARAÇÃO COM TESTES:\n";
echo "   Teste 1 (test_simulate_http_request.php):\n";
$test1Data = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test_simulation',
    'momento_descricao' => 'Teste Simulação HTTP'
];
echo "   Dados: " . json_encode($test1Data) . "\n";
echo "   ✅ Método: POST\n";
echo "   ✅ Content-Type: application/json\n";
echo "   ⚠️ DIFERENÇA: Teste não inclui todos os campos do modal\n";
echo "   ⚠️ DIFERENÇA: Teste não inclui header User-Agent\n\n";

// TESTE COM DADOS IDÊNTICOS AO MODAL
echo "5. EXECUTANDO TESTE COM DADOS IDÊNTICOS AO MODAL:\n\n";

// Simular exatamente o que o endpoint recebe
$_SERVER['REQUEST_METHOD'] = 'POST';
$_SERVER['HTTP_CONTENT_TYPE'] = 'application/json';
$_SERVER['HTTP_USER_AGENT'] = 'Modal-WhatsApp-EmailNotification-v1.0';

// Executar lógica do endpoint
try {
    // Headers
    header('Content-Type: application/json; charset=utf-8');
    
    // Carregar arquivos (ordem exata do endpoint)
    require_once __DIR__ . '/ProfessionalLogger.php';
    require_once __DIR__ . '/send_admin_notification_ses.php';
    
    // Simular leitura de php://input (dados do modal)
    $rawInput = json_encode($modalPayload);
    $data = json_decode($rawInput, true);
    
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('JSON inválido: ' . json_last_error_msg());
    }
    
    // Validar (como endpoint faz)
    $ddd = $data['ddd'] ?? '';
    $celular = $data['celular'] ?? '';
    
    if (empty($ddd) || empty($celular)) {
        throw new Exception('DDD e CELULAR são obrigatórios');
    }
    
    // Preparar dados (como endpoint faz)
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
    
    echo "   Dados preparados: " . json_encode($emailData, JSON_PRETTY_PRINT) . "\n\n";
    
    // Verificar estado ANTES de chamar função
    echo "6. Estado ANTES de chamar enviarNotificacaoAdministradores:\n";
    global $awsSdkAvailable;
    echo "   \$awsSdkAvailable definida: " . (isset($awsSdkAvailable) ? "SIM" : "NÃO") . "\n";
    if (isset($awsSdkAvailable)) {
        echo "   Valor: " . var_export($awsSdkAvailable, true) . "\n";
        echo "   Tipo: " . gettype($awsSdkAvailable) . "\n";
    }
    echo "   Classe Aws\\Ses\\SesClient existe: " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO") . "\n\n";
    
    // Chamar função (como endpoint faz)
    echo "7. Chamando enviarNotificacaoAdministradores...\n";
    $result = enviarNotificacaoAdministradores($emailData);
    
    echo "\n8. Resultado:\n";
    echo json_encode($result, JSON_PRETTY_PRINT) . "\n\n";
    
    // Verificar se há debug info
    if (isset($result['debug'])) {
        echo "9. Informações de debug:\n";
        echo json_encode($result['debug'], JSON_PRETTY_PRINT) . "\n\n";
    }
    
    // Comparar resultado
    echo "10. ANÁLISE:\n";
    if ($result['success']) {
        echo "   ✅ SUCESSO: Email enviado\n";
        echo "   ✅ Total enviado: " . ($result['total_sent'] ?? 0) . "\n";
    } else {
        echo "   ❌ FALHA: " . ($result['error'] ?? 'Erro desconhecido') . "\n";
        if (isset($result['error']) && strpos($result['error'], 'AWS SDK não instalado') !== false) {
            echo "   ⚠️ PROBLEMA IDENTIFICADO: AWS SDK não disponível\n";
            if (isset($result['debug'])) {
                echo "   Debug info:\n";
                echo "   - awsSdkAvailable_isset: " . ($result['debug']['awsSdkAvailable_isset'] ? 'SIM' : 'NÃO') . "\n";
                echo "   - awsSdkAvailable_value: " . var_export($result['debug']['awsSdkAvailable_value'], true) . "\n";
                echo "   - class_exists: " . ($result['debug']['class_exists'] ? 'SIM' : 'NÃO') . "\n";
            }
        }
    }
    
} catch (Exception $e) {
    echo "❌ ERRO: " . $e->getMessage() . "\n";
    echo "Arquivo: " . $e->getFile() . "\n";
    echo "Linha: " . $e->getLine() . "\n";
}

echo "\n=== FIM COMPARAÇÃO ===\n";

