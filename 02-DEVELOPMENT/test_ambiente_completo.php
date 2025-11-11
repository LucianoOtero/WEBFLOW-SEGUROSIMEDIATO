<?php
/**
 * TEST_AMBIENTE_COMPLETO.PHP
 * 
 * Teste completo do ambiente DEV para verificar:
 * 1. Variáveis de ambiente
 * 2. Configuração PHP
 * 3. Conexão com banco de dados
 * 4. AWS SDK
 * 5. CORS
 * 6. Arquivos essenciais
 * 7. Permissões de diretórios
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teste Completo do Ambiente DEV</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .test-section {
            background: white;
            padding: 20px;
            margin: 20px 0;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .test-item {
            padding: 10px;
            margin: 5px 0;
            border-left: 4px solid #ddd;
        }
        .success {
            border-left-color: #4CAF50;
            background: #e8f5e9;
        }
        .error {
            border-left-color: #f44336;
            background: #ffebee;
        }
        .warning {
            border-left-color: #ff9800;
            background: #fff3e0;
        }
        h1 { color: #333; }
        h2 { color: #666; margin-top: 0; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #f5f5f5;
        }
        .code {
            font-family: monospace;
            background: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <h1>🧪 Teste Completo do Ambiente DEV</h1>
    <p><strong>Servidor:</strong> <?php echo $_SERVER['SERVER_NAME'] ?? 'N/A'; ?></p>
    <p><strong>Data/Hora:</strong> <?php echo date('d/m/Y H:i:s'); ?></p>
    
    <?php
    $resultados = [];
    $erros = [];
    
    // ==================== TESTE 1: VARIÁVEIS DE AMBIENTE ====================
    echo '<div class="test-section">';
    echo '<h2>1. Variáveis de Ambiente</h2>';
    
    $variaveis = [
        'APP_BASE_DIR' => getBaseDir(),
        'APP_BASE_URL' => getBaseUrl(),
        'PHP_ENV' => $_ENV['PHP_ENV'] ?? 'NÃO DEFINIDO',
        'ESPOCRM_URL' => getEspoCrmUrl(),
        'OCTADESK_API_BASE' => getOctaDeskApiBase(),
        'LOG_DB_HOST' => $_ENV['LOG_DB_HOST'] ?? 'NÃO DEFINIDO',
        'LOG_DB_NAME' => $_ENV['LOG_DB_NAME'] ?? 'NÃO DEFINIDO'
    ];
    
    echo '<table>';
    echo '<tr><th>Variável</th><th>Valor</th><th>Status</th></tr>';
    foreach ($variaveis as $var => $valor) {
        $status = $valor !== 'NÃO DEFINIDO' && !empty($valor) ? '✅' : '❌';
        echo "<tr><td><code>$var</code></td><td>$valor</td><td>$status</td></tr>";
        if ($status === '✅') {
            $resultados['var_' . $var] = true;
        } else {
            $erros['var_' . $var] = $var;
        }
    }
    echo '</table>';
    echo '</div>';
    
    // ==================== TESTE 2: CORS ====================
    echo '<div class="test-section">';
    echo '<h2>2. Configuração CORS</h2>';
    
    try {
        $corsOrigins = getCorsOrigins();
        $devIncluded = in_array('https://dev.bssegurosimediato.com.br', $corsOrigins);
        
        echo '<p><strong>Origens permitidas:</strong></p>';
        echo '<ul>';
        foreach ($corsOrigins as $origin) {
            $highlight = $origin === 'https://dev.bssegurosimediato.com.br' ? ' <strong>(DEV)</strong>' : '';
            echo "<li>$origin$highlight</li>";
        }
        echo '</ul>';
        
        if ($devIncluded) {
            echo '<div class="test-item success">✅ dev.bssegurosimediato.com.br está incluído no CORS</div>';
            $resultados['cors'] = true;
        } else {
            echo '<div class="test-item error">❌ dev.bssegurosimediato.com.br NÃO está incluído no CORS</div>';
            $erros['cors'] = 'dev.bssegurosimediato.com.br não está no CORS';
        }
    } catch (Exception $e) {
        echo '<div class="test-item error">❌ Erro ao obter CORS: ' . htmlspecialchars($e->getMessage()) . '</div>';
        $erros['cors'] = $e->getMessage();
    }
    echo '</div>';
    
    // ==================== TESTE 3: ARQUIVOS ESSENCIAIS ====================
    echo '<div class="test-section">';
    echo '<h2>3. Arquivos Essenciais</h2>';
    
    $arquivos = [
        'config.php',
        'config_env.js.php',
        'add_flyingdonkeys.php',
        'add_webflow_octa.php',
        'send_email_notification_endpoint.php',
        'send_admin_notification_ses.php',
        'ProfessionalLogger.php',
        'log_endpoint.php',
        'email_template_loader.php',
        'aws_ses_config.php',
        'class.php',
        'cpf-validate.php',
        'placa-validate.php',
        'FooterCodeSiteDefinitivoCompleto.js',
        'MODAL_WHATSAPP_DEFINITIVO.js',
        'webflow_injection_limpo.js'
    ];
    
    echo '<table>';
    echo '<tr><th>Arquivo</th><th>Existe</th><th>Tamanho</th><th>Status</th></tr>';
    foreach ($arquivos as $arquivo) {
        $path = __DIR__ . '/' . $arquivo;
        $existe = file_exists($path);
        $tamanho = $existe ? filesize($path) : 0;
        $status = $existe && $tamanho > 0 ? '✅' : '❌';
        echo "<tr><td><code>$arquivo</code></td><td>" . ($existe ? 'SIM' : 'NÃO') . "</td><td>" . number_format($tamanho) . " bytes</td><td>$status</td></tr>";
        if ($existe && $tamanho > 0) {
            $resultados['file_' . $arquivo] = true;
        } else {
            $erros['file_' . $arquivo] = $arquivo;
        }
    }
    echo '</table>';
    echo '</div>';
    
    // ==================== TESTE 4: TEMPLATES DE EMAIL ====================
    echo '<div class="test-section">';
    echo '<h2>4. Templates de Email</h2>';
    
    $templates = [
        'template_logging.php',
        'template_modal.php',
        'template_primeiro_contato.php'
    ];
    
    echo '<table>';
    echo '<tr><th>Template</th><th>Existe</th><th>Status</th></tr>';
    foreach ($templates as $template) {
        $path = __DIR__ . '/email_templates/' . $template;
        $existe = file_exists($path);
        $status = $existe ? '✅' : '⚠️';
        $statusText = $existe ? 'Disponível' : ($template === 'template_primeiro_contato.php' ? 'Não existe (usa fallback)' : 'NÃO EXISTE');
        echo "<tr><td><code>$template</code></td><td>" . ($existe ? 'SIM' : 'NÃO') . "</td><td>$status $statusText</td></tr>";
    }
    echo '</table>';
    echo '</div>';
    
    // ==================== TESTE 5: AWS SDK ====================
    echo '<div class="test-section">';
    echo '<h2>5. AWS SDK</h2>';
    
    $vendorPath = __DIR__ . '/vendor/autoload.php';
    if (file_exists($vendorPath)) {
        require_once $vendorPath;
        if (class_exists('Aws\\Ses\\SesClient')) {
            echo '<div class="test-item success">✅ AWS SDK instalado e disponível</div>';
            $resultados['aws_sdk'] = true;
        } else {
            echo '<div class="test-item error">❌ AWS SDK não está disponível (classe não encontrada)</div>';
            $erros['aws_sdk'] = 'Classe Aws\\Ses\\SesClient não encontrada';
        }
    } else {
        echo '<div class="test-item error">❌ vendor/autoload.php não encontrado</div>';
        $erros['aws_sdk'] = 'vendor/autoload.php não existe';
    }
    echo '</div>';
    
    // ==================== TESTE 6: BANCO DE DADOS ====================
    echo '<div class="test-section">';
    echo '<h2>6. Conexão com Banco de Dados</h2>';
    
    try {
        $dbConfig = getDatabaseConfig();
        $dsn = "mysql:host={$dbConfig['host']};port={$dbConfig['port']};dbname={$dbConfig['name']};charset=utf8mb4";
        $pdo = new PDO($dsn, $dbConfig['user'], $dbConfig['pass'], [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_TIMEOUT => 5
        ]);
        
        echo '<div class="test-item success">✅ Conexão com banco de dados estabelecida</div>';
        echo '<p><strong>Configuração:</strong></p>';
        echo '<ul>';
        echo "<li>Host: {$dbConfig['host']}</li>";
        echo "<li>Port: {$dbConfig['port']}</li>";
        echo "<li>Database: {$dbConfig['name']}</li>";
        echo "<li>User: {$dbConfig['user']}</li>";
        echo '</ul>';
        $resultados['database'] = true;
    } catch (PDOException $e) {
        echo '<div class="test-item error">❌ Erro ao conectar com banco de dados: ' . htmlspecialchars($e->getMessage()) . '</div>';
        $erros['database'] = $e->getMessage();
    }
    echo '</div>';
    
    // ==================== TESTE 7: DIRETÓRIOS E PERMISSÕES ====================
    echo '<div class="test-section">';
    echo '<h2>7. Diretórios e Permissões</h2>';
    
    $baseDir = getBaseDir();
    $logDir = $baseDir . '/logs';
    $emailTemplatesDir = $baseDir . '/email_templates';
    
    $diretorios = [
        'Base' => $baseDir,
        'Logs' => $logDir,
        'Email Templates' => $emailTemplatesDir
    ];
    
    echo '<table>';
    echo '<tr><th>Diretório</th><th>Caminho</th><th>Existe</th><th>Gravável</th><th>Status</th></tr>';
    foreach ($diretorios as $nome => $path) {
        $existe = is_dir($path);
        $gravavel = $existe && is_writable($path);
        $status = $existe && $gravavel ? '✅' : ($existe ? '⚠️' : '❌');
        echo "<tr><td>$nome</td><td><code>$path</code></td><td>" . ($existe ? 'SIM' : 'NÃO') . "</td><td>" . ($gravavel ? 'SIM' : 'NÃO') . "</td><td>$status</td></tr>";
        if ($existe && $gravavel) {
            $resultados['dir_' . $nome] = true;
        } else {
            $erros['dir_' . $nome] = $nome;
        }
    }
    echo '</table>';
    echo '</div>';
    
    // ==================== TESTE 8: PHP CONFIGURATION ====================
    echo '<div class="test-section">';
    echo '<h2>8. Configuração PHP</h2>';
    
    $phpConfig = [
        'PHP Version' => PHP_VERSION,
        'variables_order' => ini_get('variables_order'),
        'memory_limit' => ini_get('memory_limit'),
        'max_execution_time' => ini_get('max_execution_time'),
        'upload_max_filesize' => ini_get('upload_max_filesize'),
        'post_max_size' => ini_get('post_max_size')
    ];
    
    echo '<table>';
    echo '<tr><th>Configuração</th><th>Valor</th><th>Status</th></tr>';
    foreach ($phpConfig as $config => $valor) {
        $status = '✅';
        if ($config === 'variables_order' && strpos($valor, 'E') === false) {
            $status = '❌';
            $erros['php_' . $config] = $config;
        } else {
            $resultados['php_' . $config] = true;
        }
        echo "<tr><td>$config</td><td><code>$valor</code></td><td>$status</td></tr>";
    }
    echo '</table>';
    echo '</div>';
    
    // ==================== RESUMO ====================
    echo '<div class="test-section">';
    echo '<h2>📊 Resumo dos Testes</h2>';
    
    $totalTestes = count($resultados) + count($erros);
    $sucessos = count($resultados);
    $falhas = count($erros);
    $percentual = $totalTestes > 0 ? round(($sucessos / $totalTestes) * 100, 1) : 0;
    
    echo "<p><strong>Total de testes:</strong> $totalTestes</p>";
    echo "<p><strong>Sucessos:</strong> <span style='color: green;'>$sucessos</span></p>";
    echo "<p><strong>Falhas:</strong> <span style='color: red;'>$falhas</span></p>";
    echo "<p><strong>Taxa de sucesso:</strong> $percentual%</p>";
    
    if ($falhas > 0) {
        echo '<h3>⚠️ Problemas Encontrados:</h3>';
        echo '<ul>';
        foreach ($erros as $tipo => $erro) {
            echo "<li><code>$tipo</code>: $erro</li>";
        }
        echo '</ul>';
    } else {
        echo '<div class="test-item success"><h3>✅ TODOS OS TESTES PASSARAM!</h3></div>';
    }
    echo '</div>';
    ?>
</body>
</html>

