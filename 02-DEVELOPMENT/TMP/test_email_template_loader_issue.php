<?php
/**
 * Teste para verificar se email_template_loader.php está causando problema
 */

echo "=== TESTE EMAIL_TEMPLATE_LOADER ===\n\n";

// Verificar se arquivo existe
$templateLoaderPath = __DIR__ . '/email_template_loader.php';
echo "1. Verificando email_template_loader.php...\n";
echo "   Caminho: $templateLoaderPath\n";
echo "   Existe? " . (file_exists($templateLoaderPath) ? "SIM" : "NÃO") . "\n\n";

// Tentar carregar aws_ses_config.php primeiro
echo "2. Carregando aws_ses_config.php...\n";
try {
    require_once __DIR__ . '/aws_ses_config.php';
    echo "   ✅ Carregado com sucesso\n";
} catch (Throwable $e) {
    echo "   ❌ Erro: " . $e->getMessage() . "\n";
    echo "   Arquivo: " . $e->getFile() . "\n";
    echo "   Linha: " . $e->getLine() . "\n";
}
echo "\n";

// Tentar carregar email_template_loader.php
echo "3. Tentando carregar email_template_loader.php...\n";
if (file_exists($templateLoaderPath)) {
    try {
        require_once $templateLoaderPath;
        echo "   ✅ Carregado com sucesso\n";
    } catch (Throwable $e) {
        echo "   ❌ Erro: " . $e->getMessage() . "\n";
        echo "   Arquivo: " . $e->getFile() . "\n";
        echo "   Linha: " . $e->getLine() . "\n";
    }
} else {
    echo "   ❌ Arquivo não existe - isso vai causar erro fatal!\n";
    echo "   Tentando carregar mesmo assim para ver o erro...\n";
    try {
        require_once $templateLoaderPath;
    } catch (Throwable $e) {
        echo "   Erro capturado: " . $e->getMessage() . "\n";
        echo "   Tipo: " . get_class($e) . "\n";
    }
}
echo "\n";

// Agora tentar carregar send_admin_notification_ses.php completo
echo "4. Carregando send_admin_notification_ses.php completo...\n";
$errorsBefore = error_get_last();
try {
    require_once __DIR__ . '/send_admin_notification_ses.php';
    $errorsAfter = error_get_last();
    
    if ($errorsAfter !== $errorsBefore && $errorsAfter !== null) {
        echo "   ⚠️ Erro durante carregamento:\n";
        echo "   Mensagem: " . $errorsAfter['message'] . "\n";
        echo "   Arquivo: " . $errorsAfter['file'] . "\n";
        echo "   Linha: " . $errorsAfter['line'] . "\n";
    } else {
        echo "   ✅ Carregado sem erros aparentes\n";
    }
} catch (Throwable $e) {
    echo "   ❌ Exceção: " . $e->getMessage() . "\n";
    echo "   Arquivo: " . $e->getFile() . "\n";
    echo "   Linha: " . $e->getLine() . "\n";
    echo "   Stack trace:\n" . $e->getTraceAsString() . "\n";
}
echo "\n";

// Verificar estado da variável
echo "5. Verificando estado da variável \$awsSdkAvailable...\n";
global $awsSdkAvailable;
echo "   Definida? " . (isset($awsSdkAvailable) ? "SIM = " . var_export($awsSdkAvailable, true) : "NÃO") . "\n";
echo "   Classe existe? " . (class_exists('Aws\Ses\SesClient') ? "SIM" : "NÃO") . "\n";

echo "\n=== FIM TESTE ===\n";

