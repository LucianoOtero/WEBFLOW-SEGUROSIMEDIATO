<?php
/**
 * Teste que faz uma requisição HTTP REAL usando cURL
 * Simula exatamente o que o JavaScript faz
 */

echo "=== TESTE ENDPOINT VIA CURL (HTTP REAL) ===\n\n";

$endpointUrl = 'http://localhost/send_email_notification_endpoint.php';

$data = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test_curl_http',
    'momento_descricao' => 'Teste cURL HTTP Real'
];

$jsonData = json_encode($data);

echo "1. Preparando requisição HTTP...\n";
echo "   URL: $endpointUrl\n";
echo "   Método: POST\n";
echo "   Content-Type: application/json\n";
echo "   Dados: $jsonData\n\n";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $endpointUrl);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $jsonData);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Accept: application/json',
    'Origin: https://segurosimediato-dev.webflow.io'
]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_VERBOSE, false);

echo "2. Enviando requisição...\n";
$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
$curlError = curl_error($ch);
curl_close($ch);

echo "   HTTP Code: $httpCode\n";
if ($curlError) {
    echo "   Erro cURL: $curlError\n";
}
echo "\n";

// Separar headers e body
$headers = substr($response, 0, $headerSize);
$body = substr($response, $headerSize);

echo "3. Headers da resposta:\n";
echo $headers . "\n";

echo "4. Body da resposta:\n";
$responseData = json_decode($body, true);
if ($responseData) {
    echo json_encode($responseData, JSON_PRETTY_PRINT) . "\n\n";
    
    echo "5. Análise do resultado:\n";
    echo "   success: " . ($responseData['success'] ?? 'N/A') . "\n";
    if (isset($responseData['error'])) {
        echo "   error: " . $responseData['error'] . "\n";
    }
    if (isset($responseData['total_sent'])) {
        echo "   total_sent: " . $responseData['total_sent'] . "\n";
    }
    if (isset($responseData['debug'])) {
        echo "\n6. Informações de debug:\n";
        echo json_encode($responseData['debug'], JSON_PRETTY_PRINT) . "\n";
    }
} else {
    echo "   Resposta não é JSON válido:\n";
    echo "   $body\n";
}

echo "\n=== FIM TESTE ===\n";

