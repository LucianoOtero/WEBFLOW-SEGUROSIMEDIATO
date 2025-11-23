<?php
/**
 * Script de Verificação de LOG_DIR
 * 
 * Verifica se LOG_DIR está definido e qual diretório está sendo usado
 * Deve ser executado via web (não CLI) para ter acesso às variáveis do PHP-FPM
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/plain; charset=utf-8');

echo "=== VERIFICAÇÃO DE LOG_DIR ===\n\n";

// Verificar LOG_DIR
$logDirEnv = $_ENV['LOG_DIR'] ?? null;
echo "LOG_DIR definido: " . ($logDirEnv ? "SIM" : "NÃO") . "\n";
if ($logDirEnv) {
    echo "Valor de LOG_DIR: " . $logDirEnv . "\n";
}

// Verificar APP_BASE_DIR
$appBaseDir = getBaseDir();
echo "\nAPP_BASE_DIR: " . $appBaseDir . "\n";

// Calcular diretório de log usado
$logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
echo "\nDiretório de log calculado: " . $logDir . "\n";
echo "Diretório existe: " . (is_dir($logDir) ? "SIM" : "NÃO") . "\n";

// Verificar permissões
if (is_dir($logDir)) {
    echo "Permissões: " . substr(sprintf('%o', fileperms($logDir)), -4) . "\n";
    echo "Proprietário: " . posix_getpwuid(fileowner($logDir))['name'] . "\n";
    echo "Grupo: " . posix_getgrgid(filegroup($logDir))['name'] . "\n";
    echo "Gravável: " . (is_writable($logDir) ? "SIM" : "NÃO") . "\n";
}

// Listar arquivos no diretório de logs
echo "\n=== Arquivos no diretório de logs ===\n";
if (is_dir($logDir)) {
    $files = scandir($logDir);
    foreach ($files as $file) {
        if ($file !== '.' && $file !== '..') {
            $filePath = $logDir . '/' . $file;
            $size = filesize($filePath);
            $modified = date('Y-m-d H:i:s', filemtime($filePath));
            echo sprintf("%-40s %10s %s\n", $file, number_format($size) . ' B', $modified);
        }
    }
} else {
    echo "Diretório não existe!\n";
}

// Verificar variáveis de ambiente relacionadas
echo "\n=== Variáveis de Ambiente Relacionadas ===\n";
echo "PHP_ENV: " . ($_ENV['PHP_ENV'] ?? 'NÃO DEFINIDO') . "\n";
echo "APP_BASE_URL: " . ($_ENV['APP_BASE_URL'] ?? 'NÃO DEFINIDO') . "\n";
echo "APP_ENVIRONMENT: " . (isDevelopment() ? 'development' : 'production') . "\n";

echo "\n=== FIM DA VERIFICAÇÃO ===\n";

