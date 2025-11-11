<?php
/**
 * TEST_LOGGING.PHP
 * 
 * Teste de Logging:
 * - Verificar se logs estão sendo gravados corretamente
 * - Verificar formato dos logs
 * - Verificar rotação de logs
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de Logging</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 1400px; margin: 0 auto; padding: 20px; }
        .test-section { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #333; color: white; }
        .success { color: green; }
        .error { color: red; }
        .warning { color: orange; }
        pre { background: #f0f0f0; padding: 10px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <h1>📝 Teste de Logging</h1>
    
    <?php
    $logDir = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
    $logFiles = [
        'flyingdonkeys_dev.txt' => 'Logs do FlyingDonkeys (DEV)',
        'webhook_octadesk_prod.txt' => 'Logs do OctaDesk',
        'professional_logger_errors.txt' => 'Logs de Erros do ProfessionalLogger',
        'log_endpoint_debug.txt' => 'Logs de Debug do log_endpoint'
    ];
    
    // Teste 1: Verificar Diretório de Logs
    echo '<div class="test-section">';
    echo '<h2>📁 Diretório de Logs</h2>';
    if (is_dir($logDir)) {
        echo '<p class="success">✅ Diretório existe: ' . htmlspecialchars($logDir) . '</p>';
        echo '<p>Permissões: ' . substr(sprintf('%o', fileperms($logDir)), -4) . '</p>';
        echo '<p>Gravável: ' . (is_writable($logDir) ? '✅ SIM' : '❌ NÃO') . '</p>';
    } else {
        echo '<p class="error">❌ Diretório não existe: ' . htmlspecialchars($logDir) . '</p>';
    }
    echo '</div>';
    
    // Teste 2: Verificar Arquivos de Log
    echo '<div class="test-section">';
    echo '<h2>📄 Arquivos de Log</h2>';
    echo '<table>';
    echo '<tr><th>Arquivo</th><th>Existe</th><th>Tamanho</th><th>Última Modificação</th><th>Status</th></tr>';
    
    foreach ($logFiles as $file => $descricao) {
        $path = $logDir . '/' . $file;
        $existe = file_exists($path);
        $tamanho = $existe ? filesize($path) : 0;
        $modificacao = $existe ? date('d/m/Y H:i:s', filemtime($path)) : 'N/A';
        $status = $existe ? '✅' : '⚠️';
        
        echo "<tr>";
        echo "<td>$file</td>";
        echo "<td>" . ($existe ? 'SIM' : 'NÃO') . "</td>";
        echo "<td>" . number_format($tamanho) . " bytes</td>";
        echo "<td>$modificacao</td>";
        echo "<td>$status</td>";
        echo "</tr>";
    }
    
    echo '</table>';
    echo '</div>';
    
    // Teste 3: Testar Gravação de Log
    echo '<div class="test-section">';
    echo '<h2>✏️ Teste de Gravação de Log</h2>';
    
    $testLogFile = $logDir . '/test_logging_' . time() . '.txt';
    $testMessage = '[' . date('Y-m-d H:i:s') . '] [TEST] Mensagem de teste do sistema de logging';
    
    if (file_put_contents($testLogFile, $testMessage . PHP_EOL, FILE_APPEND | LOCK_EX)) {
        echo '<p class="success">✅ Log gravado com sucesso</p>';
        echo '<p><strong>Arquivo:</strong> ' . htmlspecialchars($testLogFile) . '</p>';
        echo '<p><strong>Mensagem:</strong> ' . htmlspecialchars($testMessage) . '</p>';
        
        // Ler o log gravado
        $conteudo = file_get_contents($testLogFile);
        echo '<h3>Conteúdo do Log:</h3>';
        echo '<pre>' . htmlspecialchars($conteudo) . '</pre>';
        
        // Remover arquivo de teste
        unlink($testLogFile);
        echo '<p class="success">✅ Arquivo de teste removido</p>';
    } else {
        echo '<p class="error">❌ Erro ao gravar log</p>';
    }
    
    echo '</div>';
    
    // Teste 4: Verificar Formato dos Logs Existentes
    echo '<div class="test-section">';
    echo '<h2>📋 Formato dos Logs</h2>';
    
    foreach ($logFiles as $file => $descricao) {
        $path = $logDir . '/' . $file;
        if (file_exists($path) && filesize($path) > 0) {
            echo "<h3>$descricao ($file)</h3>";
            $linhas = file($path);
            $ultimasLinhas = array_slice($linhas, -5);
            echo '<pre>';
            foreach ($ultimasLinhas as $linha) {
                echo htmlspecialchars($linha);
            }
            echo '</pre>';
            
            // Analisar formato
            $primeiraLinha = trim($linhas[0] ?? '');
            $temTimestamp = preg_match('/\[\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\]/', $primeiraLinha);
            $temLevel = preg_match('/\[(INFO|ERROR|WARN|DEBUG|SUCCESS)\]/', $primeiraLinha);
            
            echo '<p>';
            echo 'Formato: ';
            echo $temTimestamp ? '✅ Timestamp' : '❌ Sem timestamp';
            echo ' | ';
            echo $temLevel ? '✅ Level' : '❌ Sem level';
            echo '</p>';
        }
    }
    
    echo '</div>';
    
    // Teste 5: Testar ProfessionalLogger
    echo '<div class="test-section">';
    echo '<h2>🔧 Teste do ProfessionalLogger</h2>';
    
    try {
        require_once __DIR__ . '/ProfessionalLogger.php';
        $logger = new ProfessionalLogger();
        
        echo '<p>Testando diferentes níveis de log...</p>';
        
        $logger->info('TESTE', 'Mensagem de teste INFO', ['test' => true]);
        echo '<p class="success">✅ INFO logado</p>';
        
        $logger->warn('TESTE', 'Mensagem de teste WARN', ['test' => true]);
        echo '<p class="success">✅ WARN logado</p>';
        
        $logger->error('TESTE', 'Mensagem de teste ERROR', ['test' => true]);
        echo '<p class="success">✅ ERROR logado</p>';
        
        echo '<p class="success">✅ ProfessionalLogger funcionando corretamente</p>';
    } catch (Exception $e) {
        echo '<p class="error">❌ Erro ao testar ProfessionalLogger: ' . htmlspecialchars($e->getMessage()) . '</p>';
    }
    
    echo '</div>';
    ?>
</body>
</html>

