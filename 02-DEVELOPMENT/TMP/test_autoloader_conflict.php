<?php
/**
 * Teste para verificar conflitos com o autoloader
 * Simula diferentes cenários de carregamento
 */

echo "=== TESTE CONFLITO AUTOLOADER ===\n\n";

// CENÁRIO 1: Carregar autoloader ANTES de send_admin_notification_ses.php
echo "CENÁRIO 1: Carregar autoloader ANTES...\n";
$vendorPath = __DIR__ . '/vendor/autoload.php';
if (file_exists($vendorPath)) {
    require_once $vendorPath;
    echo "   ✅ Autoloader carregado\n";
    echo "   Classe existe? " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO") . "\n";
} else {
    echo "   ❌ Arquivo não existe\n";
}
echo "\n";

// Agora carregar send_admin_notification_ses.php
echo "CENÁRIO 1 (continuação): Carregando send_admin_notification_ses.php...\n";
require_once __DIR__ . '/send_admin_notification_ses.php';
global $awsSdkAvailable;
echo "   \$awsSdkAvailable: " . (isset($awsSdkAvailable) ? var_export($awsSdkAvailable, true) : "NÃO DEFINIDA") . "\n";
echo "   Classe existe? " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO") . "\n";

// Testar função
$result = enviarNotificacaoAdministradores(['ddd' => '11', 'celular' => '916481648', 'momento' => 'test']);
echo "   Função success: " . ($result['success'] ? "true" : "false") . "\n";
if (isset($result['error'])) {
    echo "   Função error: " . $result['error'] . "\n";
}
echo "\n\n";

// CENÁRIO 2: Verificar se require (não require_once) causa problema
echo "CENÁRIO 2: Testando require vs require_once do autoloader...\n";

// Resetar estado (não podemos fazer isso completamente, mas vamos testar)
echo "   Tentando carregar autoloader com require (não require_once)...\n";
if (file_exists($vendorPath)) {
    try {
        require $vendorPath; // Mesmo que já tenha sido carregado
        echo "   ✅ require executado sem erro fatal\n";
    } catch (Throwable $e) {
        echo "   ❌ Erro: " . $e->getMessage() . "\n";
    }
}
echo "\n";

// CENÁRIO 3: Verificar se ProfessionalLogger carrega autoloader
echo "CENÁRIO 3: Verificando se ProfessionalLogger carrega autoloader...\n";
// Resetar (não podemos, mas vamos verificar)
$beforeLogger = class_exists('Aws\Ses\SesClient');
echo "   Classe existe ANTES de ProfessionalLogger? " . ($beforeLogger ? "SIM" : "NÃO") . "\n";

require_once __DIR__ . '/ProfessionalLogger.php';
$afterLogger = class_exists('Aws\Ses\SesClient');
echo "   Classe existe DEPOIS de ProfessionalLogger? " . ($afterLogger ? "SIM" : "NÃO") . "\n";

// Verificar se ProfessionalLogger tem vendor/autoload
$loggerContent = file_get_contents(__DIR__ . '/ProfessionalLogger.php');
if (strpos($loggerContent, 'vendor/autoload') !== false) {
    echo "   ⚠️ ProfessionalLogger contém referência a vendor/autoload\n";
} else {
    echo "   ✅ ProfessionalLogger não carrega autoloader\n";
}
echo "\n";

// CENÁRIO 4: Verificar ordem exata do endpoint
echo "CENÁRIO 4: Simulando ordem exata do endpoint...\n";
// Resetar variável global (não podemos, mas vamos verificar estado)
unset($GLOBALS['awsSdkAvailable']);

echo "   Passo 1: Carregar ProfessionalLogger\n";
require_once __DIR__ . '/ProfessionalLogger.php';
echo "   Passo 2: Carregar send_admin_notification_ses.php\n";
require_once __DIR__ . '/send_admin_notification_ses.php';

global $awsSdkAvailable;
echo "   \$awsSdkAvailable: " . (isset($awsSdkAvailable) ? var_export($awsSdkAvailable, true) : "NÃO DEFINIDA") . "\n";

echo "\n=== FIM TESTE ===\n";

