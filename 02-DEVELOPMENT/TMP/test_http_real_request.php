<?php
/**
 * Teste que faz requisição HTTP REAL ao endpoint
 * Simula EXATAMENTE o que o modal faz
 */

echo "=== TESTE HTTP REAL (SIMULAÇÃO EXATA DO MODAL) ===\n\n";

// Dados EXATOS que o modal envia
$modalData = [
    'ddd' => '11',
    'celular' => '916481648',
    'cpf' => 'Não informado',
    'nome' => 'Não informado',
    'email' => 'Não informado',
    'cep' => 'Não informado',
    'placa' => 'Não informado',
    'gclid' => 'Não informado',
    'momento' => 'initial_contact',
    'momento_descricao' => 'Primeiro Contato - Apenas Telefone',
    'momento_emoji' => '📞',
    'erro' => null
];

$jsonData = json_encode($modalData);

echo "1. Dados que serão enviados (idênticos ao modal):\n";
echo json_encode($modalData, JSON_PRETTY_PRINT) . "\n\n";

// URL do endpoint (mesma que o modal usa)
$endpointUrl = 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php';

echo "2. Fazendo requisição HTTP REAL...\n";
echo "   URL: $endpointUrl\n";
echo "   Método: POST\n";
echo "   Headers: Content-Type: application/json, User-Agent: Modal-WhatsApp-EmailNotification-v1.0\n\n";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $endpointUrl);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonData);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'User-Agent: Modal-WhatsApp-EmailNotification-v1.0',
    'Accept: application/json'
]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // Para dev
curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false); // Para dev
curl_setopt($ch, CURLOPT_TIMEOUT, 30);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
$curlError = curl_error($ch);
$curlErrno = curl_errno($ch);
curl_close($ch);

echo "3. Resultado da requisição:\n";
echo "   HTTP Code: $httpCode\n";
if ($curlError) {
    echo "   Erro cURL: $curlError (código: $curlErrno)\n";
}
echo "\n";

// Separar headers e body
$headers = substr($response, 0, $headerSize);
$body = substr($response, $headerSize);

echo "4. Headers da resposta:\n";
echo $headers . "\n";

echo "5. Body da resposta:\n";
$responseData = json_decode($body, true);
if ($responseData) {
    echo json_encode($responseData, JSON_PRETTY_PRINT) . "\n\n";
    
    echo "6. Análise:\n";
    echo "   success: " . ($responseData['success'] ?? 'N/A') . "\n";
    if (isset($responseData['error'])) {
        echo "   error: " . $responseData['error'] . "\n";
        
        // Verificar se é o erro de AWS SDK
        if (strpos($responseData['error'], 'AWS SDK não instalado') !== false) {
            echo "\n   ⚠️ PROBLEMA IDENTIFICADO: AWS SDK não disponível na requisição HTTP real!\n";
        }
    }
    if (isset($responseData['total_sent'])) {
        echo "   total_sent: " . $responseData['total_sent'] . "\n";
    }
    if (isset($responseData['debug'])) {
        echo "\n7. Informações de debug:\n";
        echo json_encode($responseData['debug'], JSON_PRETTY_PRINT) . "\n";
    }
} else {
    echo "   Resposta não é JSON válido:\n";
    echo "   $body\n";
}

echo "\n=== FIM TESTE ===\n";

