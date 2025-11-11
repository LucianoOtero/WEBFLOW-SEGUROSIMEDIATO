<?php
/**
 * test_connection.php - Teste de conexão detalhado
 */
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== Teste de Conexão MySQL ===\n\n";

$hosts = ['172.17.0.1', 'host.docker.internal', 'localhost'];
$port = 3306;
$database = 'rpa_logs_dev';
$username = 'rpa_logger_dev';
$password = 'tYbAwe7QkKNrHSRhaWplgsSxt';

foreach ($hosts as $host) {
    echo "Tentando conectar em: $host:$port\n";
    try {
        $dsn = "mysql:host=$host;port=$port;dbname=$database;charset=utf8mb4";
        $pdo = new PDO($dsn, $username, $password, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_TIMEOUT => 3
        ]);
        echo "✅ SUCESSO em $host\n";
        echo "Testando query...\n";
        $stmt = $pdo->query("SELECT 1 as test");
        $result = $stmt->fetch();
        echo "Query OK: " . $result['test'] . "\n";
        break;
    } catch (PDOException $e) {
        echo "❌ FALHA em $host: " . $e->getMessage() . "\n";
    }
    echo "\n";
}

echo "\n=== Verificando variáveis de ambiente ===\n";
echo "LOG_DB_HOST: " . ($_ENV['LOG_DB_HOST'] ?? 'não definido') . "\n";
echo "LOG_DB_NAME: " . ($_ENV['LOG_DB_NAME'] ?? 'não definido') . "\n";
echo "LOG_DB_USER: " . ($_ENV['LOG_DB_USER'] ?? 'não definido') . "\n";
echo "Is Docker: " . (file_exists('/.dockerenv') ? 'YES' : 'NO') . "\n";

