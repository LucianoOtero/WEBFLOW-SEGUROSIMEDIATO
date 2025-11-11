<?php
/**
 * test_direct.php - Teste direto de conexão
 */
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== Teste Direto ===\n\n";

echo "Variáveis de ambiente:\n";
echo "LOG_DB_HOST: " . ($_ENV['LOG_DB_HOST'] ?? 'não definido') . "\n";
echo "LOG_DB_NAME: " . ($_ENV['LOG_DB_NAME'] ?? 'não definido') . "\n";
echo "LOG_DB_USER: " . ($_ENV['LOG_DB_USER'] ?? 'não definido') . "\n";
echo "LOG_DB_PASS: " . (isset($_ENV['LOG_DB_PASS']) ? 'definido' : 'não definido') . "\n\n";

$host = $_ENV['LOG_DB_HOST'] ?? '172.17.0.1';
$port = (int)($_ENV['LOG_DB_PORT'] ?? 3306);
$database = $_ENV['LOG_DB_NAME'] ?? 'rpa_logs_dev';
$username = $_ENV['LOG_DB_USER'] ?? 'rpa_logger_dev';
$password = $_ENV['LOG_DB_PASS'] ?? 'tYbAwe7QkKNrHSRhaWplgsSxt';

echo "Tentando conectar:\n";
echo "Host: $host\n";
echo "Port: $port\n";
echo "Database: $database\n";
echo "Username: $username\n\n";

try {
    $dsn = "mysql:host=$host;port=$port;dbname=$database;charset=utf8mb4";
    $pdo = new PDO($dsn, $username, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_TIMEOUT => 5
    ]);
    echo "✅ Conexão OK!\n\n";
    
    // Testar inserção
    $stmt = $pdo->prepare("INSERT INTO application_logs (log_id, request_id, timestamp, server_time, level, file_name, message, environment) VALUES (?, ?, NOW(6), ?, ?, ?, ?, ?)");
    $logId = uniqid('log_', true);
    $result = $stmt->execute([
        $logId,
        uniqid('req_', true),
        microtime(true),
        'INFO',
        'test_direct.php',
        'Teste direto de inserção',
        'development'
    ]);
    
    if ($result) {
        echo "✅ Inserção OK! Log ID: $logId\n";
    } else {
        echo "❌ Inserção falhou\n";
    }
    
} catch (PDOException $e) {
    echo "❌ Erro: " . $e->getMessage() . "\n";
}

