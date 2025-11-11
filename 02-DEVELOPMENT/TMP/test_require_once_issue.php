<?php
/**
 * Teste para verificar problema com require_once e variável global
 */

echo "=== TESTE REQUIRE_ONCE E VARIÁVEL GLOBAL ===\n\n";

// Simular o problema: carregar o arquivo duas vezes
echo "1. Primeira carga de send_admin_notification_ses.php...\n";
require_once __DIR__ . '/send_admin_notification_ses.php';
global $awsSdkAvailable;
echo "   \$awsSdkAvailable após primeira carga: " . (isset($awsSdkAvailable) ? var_export($awsSdkAvailable, true) : "NÃO DEFINIDA") . "\n\n";

echo "2. Segunda carga de send_admin_notification_ses.php (deve ser ignorada pelo require_once)...\n";
require_once __DIR__ . '/send_admin_notification_ses.php';
global $awsSdkAvailable;
echo "   \$awsSdkAvailable após segunda carga: " . (isset($awsSdkAvailable) ? var_export($awsSdkAvailable, true) : "NÃO DEFINIDA") . "\n\n";

echo "3. Testando função...\n";
$result = enviarNotificacaoAdministradores(['ddd' => '11', 'celular' => '916481648', 'momento' => 'test']);
echo "   success: " . ($result['success'] ? "true" : "false") . "\n";
if (isset($result['error'])) {
    echo "   error: " . $result['error'] . "\n";
}

echo "\n=== TESTE PROBLEMA COM REQUIRE DO AUTOLOADER ===\n\n";

// Verificar se o autoloader já foi carregado
echo "4. Verificando se autoloader já foi carregado...\n";
$autoloaderLoaded = class_exists('Composer\Autoload\ClassLoader') || function_exists('spl_autoload_register');
echo "   Autoloader já carregado? " . ($autoloaderLoaded ? "SIM" : "NÃO") . "\n\n";

// Tentar carregar novamente (simulando o problema)
echo "5. Tentando carregar vendor/autoload.php novamente...\n";
$vendorPath = __DIR__ . '/vendor/autoload.php';
if (file_exists($vendorPath)) {
    try {
        require $vendorPath; // Usa require, não require_once
        echo "   ✅ Carregado (pode causar erro se já estava carregado)\n";
    } catch (Exception $e) {
        echo "   ❌ Erro: " . $e->getMessage() . "\n";
    } catch (Error $e) {
        echo "   ❌ Erro fatal: " . $e->getMessage() . "\n";
    }
} else {
    echo "   ❌ Arquivo não existe\n";
}

echo "\n=== FIM TESTE ===\n";

