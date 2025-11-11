<?php
/**
 * Teste que chama o endpoint REAL via HTTP (como o modal faz)
 */

echo "=== TESTE ENDPOINT REAL VIA HTTP ===\n\n";

$endpointUrl = 'https://dev.bssegurosimediato.com.br/send_email_notification_endpoint.php';

$data = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test_http',
    'momento_descricao' => 'Teste HTTP Real'
];

echo "1. Preparando requisição...\n";
echo "   URL: $endpointUrl\n";
echo "   Dados: " . json_encode($data, JSON_PRETTY_PRINT) . "\n\n";

echo "2. Enviando requisição HTTP POST...\n";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $endpointUrl);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Accept: application/json'
]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_VERBOSE, true);
curl_setopt($ch, CURLOPT_STDERR, fopen('php://temp', 'r+'));

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);
curl_close($ch);

echo "   HTTP Code: $httpCode\n";
if ($curlError) {
    echo "   Erro cURL: $curlError\n";
}
echo "\n";

echo "3. Resposta do servidor:\n";
$responseData = json_decode($response, true);
if ($responseData) {
    echo "   " . json_encode($responseData, JSON_PRETTY_PRINT) . "\n";
    echo "\n";
    echo "   Análise:\n";
    echo "   - success: " . ($responseData['success'] ?? 'N/A') . "\n";
    if (isset($responseData['error'])) {
        echo "   - error: " . $responseData['error'] . "\n";
    }
    if (isset($responseData['total_sent'])) {
        echo "   - total_sent: " . $responseData['total_sent'] . "\n";
    }
} else {
    echo "   Resposta não é JSON válido:\n";
    echo "   $response\n";
}

echo "\n=== FIM TESTE ===\n";

