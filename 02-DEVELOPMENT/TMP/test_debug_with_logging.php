<?php
/**
 * Teste com logging detalhado de cada passo
 * Para identificar exatamente onde o problema ocorre
 */

// Ativar todos os erros
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('log_errors', 1);

// Função de log
function debugLog($message) {
    $timestamp = date('Y-m-d H:i:s');
    echo "[$timestamp] $message\n";
    error_log("[$timestamp] $message");
}

debugLog("=== INÍCIO TESTE COM LOGGING ===\n");

// PASSO 1
debugLog("PASSO 1: Verificando __DIR__");
debugLog("  __DIR__ = " . __DIR__);

// PASSO 2
debugLog("PASSO 2: Carregando ProfessionalLogger");
$loggerPath = __DIR__ . '/ProfessionalLogger.php';
debugLog("  Caminho: $loggerPath");
debugLog("  Existe: " . (file_exists($loggerPath) ? "SIM" : "NÃO"));

try {
    require_once $loggerPath;
    debugLog("  ✅ ProfessionalLogger carregado");
} catch (Throwable $e) {
    debugLog("  ❌ Erro: " . $e->getMessage());
    debugLog("  Arquivo: " . $e->getFile());
    debugLog("  Linha: " . $e->getLine());
}

// PASSO 3
debugLog("PASSO 3: Estado ANTES de send_admin_notification_ses.php");
global $awsSdkAvailable;
debugLog("  \$awsSdkAvailable definida: " . (isset($awsSdkAvailable) ? "SIM" : "NÃO"));
debugLog("  Classe existe: " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO"));

// PASSO 4
debugLog("PASSO 4: Carregando send_admin_notification_ses.php");
$sesPath = __DIR__ . '/send_admin_notification_ses.php';
debugLog("  Caminho: $sesPath");
debugLog("  Existe: " . (file_exists($sesPath) ? "SIM" : "NÃO"));

// Ler o arquivo e verificar linha por linha
$fileLines = file($sesPath);
debugLog("  Total de linhas: " . count($fileLines));
debugLog("  Linha 24-36 (código AWS SDK):");
for ($i = 23; $i < 36 && $i < count($fileLines); $i++) {
    debugLog("    " . ($i + 1) . ": " . trim($fileLines[$i]));
}

$errorsBefore = error_get_last();
try {
    require_once $sesPath;
    $errorsAfter = error_get_last();
    
    if ($errorsAfter !== $errorsBefore && $errorsAfter !== null) {
        debugLog("  ⚠️ Erro durante require_once:");
        debugLog("    Tipo: " . $errorsAfter['type']);
        debugLog("    Mensagem: " . $errorsAfter['message']);
        debugLog("    Arquivo: " . $errorsAfter['file']);
        debugLog("    Linha: " . $errorsAfter['line']);
    } else {
        debugLog("  ✅ Arquivo carregado sem erros aparentes");
    }
} catch (Throwable $e) {
    debugLog("  ❌ Exceção: " . $e->getMessage());
    debugLog("  Arquivo: " . $e->getFile());
    debugLog("  Linha: " . $e->getLine());
}

// PASSO 5
debugLog("PASSO 5: Estado DEPOIS de send_admin_notification_ses.php");
global $awsSdkAvailable;
debugLog("  \$awsSdkAvailable definida: " . (isset($awsSdkAvailable) ? "SIM" : "NÃO"));
if (isset($awsSdkAvailable)) {
    debugLog("  Valor: " . var_export($awsSdkAvailable, true));
    debugLog("  Tipo: " . gettype($awsSdkAvailable));
    debugLog("  É true? " . ($awsSdkAvailable === true ? "SIM" : "NÃO"));
    debugLog("  É false? " . ($awsSdkAvailable === false ? "SIM" : "NÃO"));
}
debugLog("  Classe existe: " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO"));

// PASSO 6
debugLog("PASSO 6: Verificando caminho vendor/autoload.php");
$vendorPath = __DIR__ . '/vendor/autoload.php';
debugLog("  Caminho: $vendorPath");
debugLog("  Existe: " . (file_exists($vendorPath) ? "SIM" : "NÃO"));
if (file_exists($vendorPath)) {
    debugLog("  Tamanho: " . filesize($vendorPath) . " bytes");
    debugLog("  Legível: " . (is_readable($vendorPath) ? "SIM" : "NÃO"));
    debugLog("  Caminho real: " . realpath($vendorPath));
}

// PASSO 7
debugLog("PASSO 7: Testando função enviarNotificacaoAdministradores");
$testData = [
    'ddd' => '11',
    'celular' => '916481648',
    'momento' => 'test_logging'
];

try {
    $result = enviarNotificacaoAdministradores($testData);
    debugLog("  ✅ Função executada");
    debugLog("  success: " . ($result['success'] ? "true" : "false"));
    if (isset($result['error'])) {
        debugLog("  error: " . $result['error']);
    }
    debugLog("  total_sent: " . ($result['total_sent'] ?? 0));
} catch (Throwable $e) {
    debugLog("  ❌ Erro na função: " . $e->getMessage());
    debugLog("  Arquivo: " . $e->getFile());
    debugLog("  Linha: " . $e->getLine());
}

debugLog("\n=== FIM TESTE ===");

