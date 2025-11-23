<?php
// Incluir config.php ANTES de qualquer header ou output para usar setCorsHeaders()
require_once __DIR__ . '/config.php';

// Headers CORS (usar função do config.php para evitar duplicação com Nginx)
// IMPORTANTE: Headers devem ser enviados ANTES de qualquer output
header('Content-Type: application/json; charset=utf-8');
// Usar setCorsHeaders() do config.php - valida origem e envia apenas um valor no header
setCorsHeaders();
// Adicionar headers específicos após setCorsHeaders() se necessário
header('Access-Control-Allow-Headers: Content-Type');

// Nota: setCorsHeaders() já trata requisições OPTIONS (preflight) e envia os headers corretos
// Não é necessário código adicional para OPTIONS

// Receber dados via POST
$input = json_decode(file_get_contents('php://input'), true);
$placa = $input['placa'] ?? '';

if (empty($placa)) {
    http_response_code(400);
    echo json_encode(["error" => "Placa é obrigatória"]);
    exit;
}

// ✅ NOVA API: doc.placa.fipe (usando variáveis de ambiente)
$token = getPlacaFipeApiToken();
$url = getPlacaFipeApiUrl();

$headers = [
    "Content-Type: application/json"
];

$body = json_encode([
    "placa" => $placa,
    "token" => $token
]);

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$error = curl_error($ch);
curl_close($ch);

if ($response === false || !empty($error)) {
    http_response_code(500);
    echo json_encode(["error" => "Erro ao consultar API: " . $error]);
    exit;
}

if ($httpCode !== 200) {
    http_response_code($httpCode);
    echo json_encode(["error" => "API retornou código: " . $httpCode]);
    exit;
}

echo $response;
?>