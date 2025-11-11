<?php
/**
 * Teste para verificar se AWS SDK está acessível dentro do Docker
 */

echo "=== TESTE AWS SDK NO DOCKER ===\n\n";

// 1. Verificar __DIR__
echo "1. __DIR__ atual: " . __DIR__ . "\n";

// 2. Verificar se vendor/autoload.php existe
$vendorPath = __DIR__ . '/vendor/autoload.php';
echo "2. Caminho vendor/autoload.php: " . $vendorPath . "\n";
echo "   Existe? " . (file_exists($vendorPath) ? "SIM" : "NÃO") . "\n";

if (file_exists($vendorPath)) {
    echo "   Tamanho: " . filesize($vendorPath) . " bytes\n";
    echo "   Legível? " . (is_readable($vendorPath) ? "SIM" : "NÃO") . "\n";
}

// 3. Tentar carregar autoloader
echo "\n3. Tentando carregar autoloader...\n";
if (file_exists($vendorPath)) {
    try {
        require $vendorPath;
        echo "   ✅ Autoloader carregado com sucesso\n";
    } catch (Exception $e) {
        echo "   ❌ Erro ao carregar: " . $e->getMessage() . "\n";
    }
} else {
    echo "   ❌ Arquivo não existe\n";
}

// 4. Verificar se classe existe
echo "\n4. Verificando se classe Aws\\Ses\\SesClient existe...\n";
if (class_exists('Aws\Ses\SesClient')) {
    echo "   ✅ Classe existe\n";
} else {
    echo "   ❌ Classe NÃO existe\n";
}

// 5. Verificar variável global $awsSdkAvailable
echo "\n5. Verificando variável global \$awsSdkAvailable...\n";
require_once __DIR__ . '/send_admin_notification_ses.php';
global $awsSdkAvailable;
echo "   Valor: " . ($awsSdkAvailable ? "true (DISPONÍVEL)" : "false (NÃO DISPONÍVEL)") . "\n";

// 6. Testar caminho real
echo "\n6. Caminho real de vendor/autoload.php:\n";
if (file_exists($vendorPath)) {
    echo "   " . realpath($vendorPath) . "\n";
} else {
    echo "   Arquivo não existe\n";
}

// 7. Listar conteúdo do diretório vendor
echo "\n7. Conteúdo do diretório vendor:\n";
$vendorDir = __DIR__ . '/vendor';
if (is_dir($vendorDir)) {
    $files = scandir($vendorDir);
    echo "   Arquivos encontrados: " . count($files) . "\n";
    foreach (array_slice($files, 0, 10) as $file) {
        if ($file !== '.' && $file !== '..') {
            echo "   - $file\n";
        }
    }
} else {
    echo "   Diretório não existe\n";
}

echo "\n=== FIM DO TESTE ===\n";

