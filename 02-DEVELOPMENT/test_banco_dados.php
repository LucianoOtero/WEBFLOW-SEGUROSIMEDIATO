<?php
/**
 * TEST_BANCO_DADOS.PHP
 * 
 * Teste completo do banco de dados:
 * - Conexão
 * - Estrutura das tabelas
 * - Permissões
 * - Operações CRUD
 * - Performance de queries
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de Banco de Dados</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 1400px; margin: 0 auto; padding: 20px; }
        .test-section { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #333; color: white; }
        .success { color: green; }
        .error { color: red; }
        .warning { color: orange; }
    </style>
</head>
<body>
    <h1>🗄️ Teste de Banco de Dados</h1>
    
    <?php
    try {
        $dbConfig = getDatabaseConfig();
        $dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['name']};charset=utf8mb4";
        $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['pass'], [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_TIMEOUT => 5
        ]);
        
        echo '<div class="test-section">';
        echo '<h2>✅ Conexão com Banco de Dados</h2>';
        echo '<p><strong>Host:</strong> ' . htmlspecialchars($dbConfig['host']) . '</p>';
        echo '<p><strong>Port:</strong> ' . htmlspecialchars($dbConfig['port']) . '</p>';
        echo '<p><strong>Database:</strong> ' . htmlspecialchars($dbConfig['name']) . '</p>';
        echo '<p><strong>User:</strong> ' . htmlspecialchars($dbConfig['user']) . '</p>';
        echo '<p><strong>Versão MySQL:</strong> ' . $pdo->query('SELECT VERSION()')->fetchColumn() . '</p>';
        echo '</div>';
        
        // Teste 2: Estrutura das Tabelas
        echo '<div class="test-section">';
        echo '<h2>📊 Estrutura das Tabelas</h2>';
        $tables = $pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
        echo '<table>';
        echo '<tr><th>Tabela</th><th>Linhas</th><th>Status</th></tr>';
        foreach ($tables as $table) {
            try {
                $count = $pdo->query("SELECT COUNT(*) FROM `$table`")->fetchColumn();
                echo "<tr><td>$table</td><td>" . number_format($count) . "</td><td class='success'>✅ OK</td></tr>";
            } catch (PDOException $e) {
                echo "<tr><td>$table</td><td>N/A</td><td class='error'>❌ ERRO: " . htmlspecialchars($e->getMessage()) . "</td></tr>";
            }
        }
        echo '</table>';
        echo '</div>';
        
        // Teste 3: Permissões
        echo '<div class="test-section">';
        echo '<h2>🔐 Permissões do Usuário</h2>';
        $grants = $pdo->query("SHOW GRANTS FOR CURRENT_USER()")->fetchAll(PDO::FETCH_COLUMN);
        echo '<ul>';
        foreach ($grants as $grant) {
            echo '<li>' . htmlspecialchars($grant) . '</li>';
        }
        echo '</ul>';
        echo '</div>';
        
        // Teste 4: Operações CRUD
        echo '<div class="test-section">';
        echo '<h2>✏️ Teste de Operações CRUD</h2>';
        echo '<table>';
        echo '<tr><th>Operação</th><th>Resultado</th><th>Status</th></tr>';
        
        // CREATE
        try {
            $testTable = 'test_crud_' . time();
            $pdo->exec("CREATE TABLE IF NOT EXISTS `$testTable` (
                id INT AUTO_INCREMENT PRIMARY KEY,
                test_data VARCHAR(255),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )");
            echo "<tr><td>CREATE TABLE</td><td>Tabela criada: $testTable</td><td class='success'>✅ OK</td></tr>";
        } catch (PDOException $e) {
            echo "<tr><td>CREATE TABLE</td><td>" . htmlspecialchars($e->getMessage()) . "</td><td class='error'>❌ ERRO</td></tr>";
        }
        
        // INSERT
        try {
            $stmt = $pdo->prepare("INSERT INTO `$testTable` (test_data) VALUES (?)");
            $stmt->execute(['Teste de INSERT']);
            $insertId = $pdo->lastInsertId();
            echo "<tr><td>INSERT</td><td>ID inserido: $insertId</td><td class='success'>✅ OK</td></tr>";
        } catch (PDOException $e) {
            echo "<tr><td>INSERT</td><td>" . htmlspecialchars($e->getMessage()) . "</td><td class='error'>❌ ERRO</td></tr>";
        }
        
        // SELECT
        try {
            $stmt = $pdo->query("SELECT * FROM `$testTable` WHERE id = $insertId");
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            echo "<tr><td>SELECT</td><td>Dados recuperados: " . htmlspecialchars($result['test_data']) . "</td><td class='success'>✅ OK</td></tr>";
        } catch (PDOException $e) {
            echo "<tr><td>SELECT</td><td>" . htmlspecialchars($e->getMessage()) . "</td><td class='error'>❌ ERRO</td></tr>";
        }
        
        // UPDATE
        try {
            $stmt = $pdo->prepare("UPDATE `$testTable` SET test_data = ? WHERE id = ?");
            $stmt->execute(['Teste de UPDATE', $insertId]);
            echo "<tr><td>UPDATE</td><td>Linhas afetadas: " . $stmt->rowCount() . "</td><td class='success'>✅ OK</td></tr>";
        } catch (PDOException $e) {
            echo "<tr><td>UPDATE</td><td>" . htmlspecialchars($e->getMessage()) . "</td><td class='error'>❌ ERRO</td></tr>";
        }
        
        // DELETE
        try {
            $stmt = $pdo->prepare("DELETE FROM `$testTable` WHERE id = ?");
            $stmt->execute([$insertId]);
            echo "<tr><td>DELETE</td><td>Linhas deletadas: " . $stmt->rowCount() . "</td><td class='success'>✅ OK</td></tr>";
        } catch (PDOException $e) {
            echo "<tr><td>DELETE</td><td>" . htmlspecialchars($e->getMessage()) . "</td><td class='error'>❌ ERRO</td></tr>";
        }
        
        // DROP
        try {
            $pdo->exec("DROP TABLE IF EXISTS `$testTable`");
            echo "<tr><td>DROP TABLE</td><td>Tabela removida: $testTable</td><td class='success'>✅ OK</td></tr>";
        } catch (PDOException $e) {
            echo "<tr><td>DROP TABLE</td><td>" . htmlspecialchars($e->getMessage()) . "</td><td class='error'>❌ ERRO</td></tr>";
        }
        
        echo '</table>';
        echo '</div>';
        
        // Teste 5: Performance de Queries
        echo '<div class="test-section">';
        echo '<h2>⚡ Performance de Queries</h2>';
        echo '<table>';
        echo '<tr><th>Query</th><th>Tempo (ms)</th><th>Status</th></tr>';
        
        $queries = [
            'SELECT 1' => 'SELECT 1',
            'SELECT VERSION()' => 'SELECT VERSION()',
            'SHOW TABLES' => 'SHOW TABLES',
            'SELECT COUNT(*) FROM information_schema.tables' => 'SELECT COUNT(*) FROM information_schema.tables'
        ];
        
        foreach ($queries as $nome => $query) {
            $inicio = microtime(true);
            try {
                $pdo->query($query)->fetchAll();
                $fim = microtime(true);
                $tempo = round(($fim - $inicio) * 1000, 2);
                echo "<tr><td>$nome</td><td>$tempo</td><td class='success'>✅ OK</td></tr>";
            } catch (PDOException $e) {
                echo "<tr><td>$nome</td><td>N/A</td><td class='error'>❌ ERRO</td></tr>";
            }
        }
        
        echo '</table>';
        echo '</div>';
        
        // Teste 6: Verificar Tabelas de Log
        echo '<div class="test-section">';
        echo '<h2>📝 Tabelas de Log</h2>';
        $logTables = array_filter($tables, function($table) {
            return stripos($table, 'log') !== false;
        });
        
        if (empty($logTables)) {
            echo '<p class="warning">⚠️ Nenhuma tabela de log encontrada</p>';
        } else {
            echo '<table>';
            echo '<tr><th>Tabela</th><th>Linhas</th><th>Última Atualização</th></tr>';
            foreach ($logTables as $table) {
                try {
                    $count = $pdo->query("SELECT COUNT(*) FROM `$table`")->fetchColumn();
                    $lastUpdate = $pdo->query("SELECT MAX(created_at) FROM `$table`")->fetchColumn();
                    echo "<tr><td>$table</td><td>" . number_format($count) . "</td><td>" . ($lastUpdate ?: 'N/A') . "</td></tr>";
                } catch (PDOException $e) {
                    echo "<tr><td>$table</td><td>N/A</td><td>ERRO</td></tr>";
                }
            }
            echo '</table>';
        }
        echo '</div>';
        
    } catch (PDOException $e) {
        echo '<div class="test-section">';
        echo '<h2 class="error">❌ Erro ao conectar com banco de dados</h2>';
        echo '<p>' . htmlspecialchars($e->getMessage()) . '</p>';
        echo '</div>';
    }
    ?>
</body>
</html>

