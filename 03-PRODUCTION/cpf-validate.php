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

$input = json_decode(file_get_contents('php://input'), true);
$cpf = $input['cpf'] ?? '';

if (empty($cpf)) {
    http_response_code(400);
    echo json_encode(["error" => "CPF é obrigatório"]);
    exit;
}

// Credenciais da API PH3A (usando variáveis de ambiente)
$username = getPh3aUsername();
$password = getPh3aPassword();
$api_key = getPh3aApiKey();

// Primeiro, fazer login para obter o token
$login_url = getPh3aLoginUrl();
$login_data = json_encode([
    "UserName" => $username,
    "Password" => $password
]);

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $login_url);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $login_data);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Content-Type: application/json"
]);

$login_response = curl_exec($ch);
$login_http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$login_error = curl_error($ch);
curl_close($ch);

if ($login_response === false || !empty($login_error)) {
    http_response_code(500);
    echo json_encode([
        "error" => "Erro ao fazer login na API PH3A: " . $login_error,
        "codigo" => 0,
        "success" => false
    ]);
    exit;
}

if ($login_http_code !== 200) {
    http_response_code($login_http_code);
    echo json_encode([
        "error" => "Erro no login da API PH3A. Código: " . $login_http_code,
        "codigo" => 0,
        "success" => false
    ]);
    exit;
}

$login_data = json_decode($login_response, true);

if (!$login_data || !$login_data['success']) {
    http_response_code(500);
    echo json_encode([
        "error" => "Falha no login da API PH3A: " . ($login_data['message'] ?? 'Erro desconhecido'),
        "codigo" => 0,
        "success" => false
    ]);
    exit;
}

$token = $login_data['data']['Token'] ?? '';

if (empty($token)) {
    http_response_code(500);
    echo json_encode([
        "error" => "Token não recebido da API PH3A",
        "codigo" => 0,
        "success" => false,
        "debug" => $login_data
    ]);
    exit;
}

// Agora consultar os dados do CPF
$data_url = "https://api.ph3a.com.br/DataBusca/data";
$data_body = json_encode([
    "Document" => $cpf,
    "Type" => 0,
    "HashType" => 0,
    "Rules" => [
        "Phones.Limit" => 3,
        "Phones.History" => false,
        "Phones.Rank" => 90
    ]
]);

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $data_url);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data_body);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Content-Type: application/json",
    "Token: " . $token
]);

$data_response = curl_exec($ch);
$data_http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$data_error = curl_error($ch);
curl_close($ch);

if ($data_response === false || !empty($data_error)) {
    http_response_code(500);
    echo json_encode([
        "error" => "Erro ao consultar dados do CPF: " . $data_error,
        "codigo" => 0,
        "success" => false
    ]);
    exit;
}

if ($data_http_code !== 200) {
    http_response_code($data_http_code);
    echo json_encode([
        "error" => "Erro na consulta de dados. Código: " . $data_http_code,
        "codigo" => 0,
        "success" => false
    ]);
    exit;
}

// Processar resposta da API
$api_data = json_decode($data_response, true);

if (!$api_data || !isset($api_data['Data'])) {
    echo json_encode([
        "codigo" => 0,
        "success" => false,
        "message" => "CPF não encontrado na base de dados"
    ]);
    exit;
}

$data = $api_data['Data'];
$person = $data['Person'] ?? [];

// Mapear dados conforme necessário
$result = [
    "codigo" => 1,
    "success" => true,
    "data" => [
        "cpf" => $cpf,
        "nome" => $data['NameBrasil'] ?? '',
        "sexo" => $data['Gender'] ?? 0,
        "data_nascimento" => $data['BirthDate'] ?? '',
        "estado_civil" => $person['MaritalStatus'] ?? 0,
        "idade" => $data['Age'] ?? 0
    ],
    "raw" => $api_data // Para debug
];

echo json_encode($result);
?>
