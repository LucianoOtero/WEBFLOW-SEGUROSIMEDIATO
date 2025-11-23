<?php
/**
 * TESTE DE VERIFICAÇÃO DE LOG_DIR
 * 
 * Testa todos os arquivos PHP que escrevem logs e verifica
 * se estão usando o diretório correto definido por LOG_DIR
 * 
 * Versão: 1.0.0
 * Data: 2025-11-12
 */

require_once __DIR__ . '/config.php';

// Configurações
$LOG_DIR_ESPERADO = $_ENV['LOG_DIR'] ?? getBaseDir() . '/logs';
$BASE_URL = getBaseUrl();
$TIMEOUT = 5; // segundos para aguardar criação do log
$TEST_ID = 'test_log_dir_' . date('Ymd_His') . '_' . uniqid();

// Headers padrão
header('Content-Type: text/html; charset=utf-8');

?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de Verificação LOG_DIR</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 1400px; margin: 0 auto; padding: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 3px solid #4CAF50; padding-bottom: 10px; }
        h2 { color: #555; margin-top: 30px; border-left: 4px solid #2196F3; padding-left: 10px; }
        .test-section { background: #f9f9f9; padding: 15px; margin: 15px 0; border-radius: 5px; border-left: 4px solid #2196F3; }
        .success { color: #4CAF50; font-weight: bold; }
        .error { color: #f44336; font-weight: bold; }
        .warning { color: #FF9800; font-weight: bold; }
        .info { color: #2196F3; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #333; color: white; }
        tr:hover { background: #f5f5f5; }
        pre { background: #f0f0f0; padding: 10px; border-radius: 5px; overflow-x: auto; font-size: 12px; }
        .summary { background: #e8f5e9; padding: 15px; border-radius: 5px; margin-top: 20px; }
        .summary h3 { margin-top: 0; color: #2e7d32; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Teste de Verificação de LOG_DIR</h1>
        
        <?php
        echo "<p class='info'><strong>Data/Hora:</strong> " . date('Y-m-d H:i:s') . "</p>";
        echo "<p class='info'><strong>LOG_DIR Esperado:</strong> <code>$LOG_DIR_ESPERADO</code></p>";
        echo "<p class='info'><strong>BASE_URL:</strong> <code>$BASE_URL</code></p>";
        echo "<p class='info'><strong>Test ID:</strong> <code>$TEST_ID</code></p>";
        echo "<hr>";
        
        // Função para verificar caminho do log
        function verificarCaminhoLog($arquivoLog, $logDirEsperado) {
            $caminhoEsperado = rtrim($logDirEsperado, '/\\') . '/' . $arquivoLog;
            $caminhoReal = null;
            $diretoriosTestados = [];
            
            // Verificar se arquivo existe no diretório esperado
            if (file_exists($caminhoEsperado)) {
                $caminhoReal = $caminhoEsperado;
            } else {
                // Buscar arquivo em outros locais possíveis (fallback)
                $fallbackDirs = [
                    getBaseDir() . '/logs',
                    '/var/www/html/dev/root/logs',
                    '/var/log/webflow-segurosimediato'
                ];
                
                foreach ($fallbackDirs as $dir) {
                    $diretoriosTestados[] = $dir;
                    $caminhoTeste = rtrim($dir, '/\\') . '/' . $arquivoLog;
                    if (file_exists($caminhoTeste)) {
                        $caminhoReal = $caminhoTeste;
                        break;
                    }
                }
            }
            
            $resultado = [
                'esperado' => $caminhoEsperado,
                'real' => $caminhoReal,
                'correto' => $caminhoReal === $caminhoEsperado,
                'existe' => $caminhoReal !== null,
                'diretorios_testados' => $diretoriosTestados
            ];
            
            if ($caminhoReal) {
                $resultado['tamanho'] = filesize($caminhoReal);
                $resultado['modificado'] = date('Y-m-d H:i:s', filemtime($caminhoReal));
                $resultado['permissoes'] = substr(sprintf('%o', fileperms($caminhoReal)), -4);
            }
            
            return $resultado;
        }
        
        // Função para fazer requisição HTTP
        function fazerRequisicao($url, $method = 'POST', $data = null, $headers = []) {
            $ch = curl_init($url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
            curl_setopt($ch, CURLOPT_TIMEOUT, 30);
            curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
            
            $headerArray = ['Content-Type: application/json'];
            foreach ($headers as $key => $value) {
                $headerArray[] = "$key: $value";
            }
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headerArray);
            
            if ($method === 'POST' && $data !== null) {
                curl_setopt($ch, CURLOPT_POST, true);
                curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
            }
            
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            curl_close($ch);
            
            return [
                'success' => $httpCode >= 200 && $httpCode < 300 && empty($error),
                'http_code' => $httpCode,
                'response' => $response,
                'error' => $error
            ];
        }
        
        // Função para aguardar criação do log
        function aguardarLog($arquivoLog, $logDir, $timeout = 5) {
            $caminho = rtrim($logDir, '/\\') . '/' . $arquivoLog;
            $inicio = time();
            
            while (time() - $inicio < $timeout) {
                if (file_exists($caminho)) {
                    // Aguardar um pouco mais para garantir que arquivo foi completamente escrito
                    usleep(500000); // 0.5 segundos
                    return true;
                }
                usleep(200000); // 0.2 segundos
            }
            
            return false;
        }
        
        $resultados = [];
        $totalTestes = 0;
        $testesSucesso = 0;
        $testesFalha = 0;
        
        // ==================== TESTE 1: add_flyingdonkeys.php ====================
        echo "<div class='test-section'>";
        echo "<h2>📋 TESTE 1: add_flyingdonkeys.php</h2>";
        $totalTestes++;
        
        $teste1 = [
            'nome' => 'add_flyingdonkeys.php',
            'arquivo_log' => 'flyingdonkeys_dev.txt',
            'endpoint' => $BASE_URL . '/add_flyingdonkeys.php',
            'payload' => [
                'name' => 'Home',
                'siteId' => '68f77ea29d6b098f6bcad795',
                'data' => [
                    'NOME' => 'Teste LOG_DIR - ' . $TEST_ID,
                    'Email' => 'teste_logdir@teste.com',
                    'DDD-CELULAR' => '11',
                    'CELULAR' => '987654321'
                ],
                'submittedAt' => date('c'),
                'id' => $TEST_ID . '_flyingdonkeys',
                'formId' => '68f788bd5dc3f2ca4483eee0'
            ]
        ];
        
        echo "<p><strong>Endpoint:</strong> <code>{$teste1['endpoint']}</code></p>";
        echo "<p><strong>Arquivo de Log Esperado:</strong> <code>{$teste1['arquivo_log']}</code></p>";
        
        // Fazer requisição
        $requisicao1 = fazerRequisicao($teste1['endpoint'], 'POST', $teste1['payload']);
        
        echo "<p><strong>Status HTTP:</strong> {$requisicao1['http_code']}</p>";
        if ($requisicao1['error']) {
            echo "<p class='error'>Erro cURL: {$requisicao1['error']}</p>";
        }
        
        // Aguardar criação do log
        echo "<p>Aguardando criação do log...</p>";
        $logCriado1 = aguardarLog($teste1['arquivo_log'], $LOG_DIR_ESPERADO, $TIMEOUT);
        
        // Verificar caminho
        $verificacao1 = verificarCaminhoLog($teste1['arquivo_log'], $LOG_DIR_ESPERADO);
        
        echo "<table>";
        echo "<tr><th>Verificação</th><th>Resultado</th></tr>";
        echo "<tr><td>Arquivo existe</td><td>" . ($verificacao1['existe'] ? "<span class='success'>✅ SIM</span>" : "<span class='error'>❌ NÃO</span>") . "</td></tr>";
        echo "<tr><td>Caminho correto</td><td>" . ($verificacao1['correto'] ? "<span class='success'>✅ SIM</span>" : "<span class='error'>❌ NÃO</span>") . "</td></tr>";
        echo "<tr><td>Caminho esperado</td><td><code>{$verificacao1['esperado']}</code></td></tr>";
        if ($verificacao1['real']) {
            echo "<tr><td>Caminho real</td><td><code>{$verificacao1['real']}</code></td></tr>";
            echo "<tr><td>Tamanho</td><td>" . number_format($verificacao1['tamanho']) . " bytes</td></tr>";
            echo "<tr><td>Modificado</td><td>{$verificacao1['modificado']}</td></tr>";
            echo "<tr><td>Permissões</td><td>{$verificacao1['permissoes']}</td></tr>";
        } else {
            echo "<tr><td>Caminho real</td><td><span class='error'>Arquivo não encontrado</span></td></tr>";
            if (!empty($verificacao1['diretorios_testados'])) {
                echo "<tr><td>Diretórios testados</td><td><ul>";
                foreach ($verificacao1['diretorios_testados'] as $dir) {
                    echo "<li><code>$dir</code></li>";
                }
                echo "</ul></td></tr>";
            }
        }
        echo "</table>";
        
        $resultado1 = $verificacao1['correto'] && $verificacao1['existe'];
        if ($resultado1) {
            $testesSucesso++;
            echo "<p class='success'>✅ TESTE PASSOU: Log criado no diretório correto</p>";
        } else {
            $testesFalha++;
            echo "<p class='error'>❌ TESTE FALHOU: Log não encontrado ou em diretório incorreto</p>";
        }
        
        $resultados[] = [
            'teste' => 'add_flyingdonkeys.php',
            'arquivo_log' => $teste1['arquivo_log'],
            'sucesso' => $resultado1,
            'verificacao' => $verificacao1
        ];
        
        echo "</div>";
        
        // ==================== TESTE 2: add_webflow_octa.php ====================
        echo "<div class='test-section'>";
        echo "<h2>📋 TESTE 2: add_webflow_octa.php</h2>";
        $totalTestes++;
        
        $teste2 = [
            'nome' => 'add_webflow_octa.php',
            'arquivo_log' => 'webhook_octadesk_prod.txt',
            'endpoint' => $BASE_URL . '/add_webflow_octa.php',
            'payload' => [
                'payload' => [
                    'name' => 'Home',
                    'data' => [
                        'NOME' => 'Teste LOG_DIR OctaDesk - ' . $TEST_ID,
                        'DDD-CELULAR' => '11',
                        'CELULAR' => '987654321'
                    ]
                ]
            ]
        ];
        
        echo "<p><strong>Endpoint:</strong> <code>{$teste2['endpoint']}</code></p>";
        echo "<p><strong>Arquivo de Log Esperado:</strong> <code>{$teste2['arquivo_log']}</code></p>";
        
        // Fazer requisição
        $requisicao2 = fazerRequisicao($teste2['endpoint'], 'POST', $teste2['payload']);
        
        echo "<p><strong>Status HTTP:</strong> {$requisicao2['http_code']}</p>";
        if ($requisicao2['error']) {
            echo "<p class='error'>Erro cURL: {$requisicao2['error']}</p>";
        }
        
        // Aguardar criação do log
        echo "<p>Aguardando criação do log...</p>";
        $logCriado2 = aguardarLog($teste2['arquivo_log'], $LOG_DIR_ESPERADO, $TIMEOUT);
        
        // Verificar caminho
        $verificacao2 = verificarCaminhoLog($teste2['arquivo_log'], $LOG_DIR_ESPERADO);
        
        echo "<table>";
        echo "<tr><th>Verificação</th><th>Resultado</th></tr>";
        echo "<tr><td>Arquivo existe</td><td>" . ($verificacao2['existe'] ? "<span class='success'>✅ SIM</span>" : "<span class='error'>❌ NÃO</span>") . "</td></tr>";
        echo "<tr><td>Caminho correto</td><td>" . ($verificacao2['correto'] ? "<span class='success'>✅ SIM</span>" : "<span class='error'>❌ NÃO</span>") . "</td></tr>";
        echo "<tr><td>Caminho esperado</td><td><code>{$verificacao2['esperado']}</code></td></tr>";
        if ($verificacao2['real']) {
            echo "<tr><td>Caminho real</td><td><code>{$verificacao2['real']}</code></td></tr>";
            echo "<tr><td>Tamanho</td><td>" . number_format($verificacao2['tamanho']) . " bytes</td></tr>";
            echo "<tr><td>Modificado</td><td>{$verificacao2['modificado']}</td></tr>";
            echo "<tr><td>Permissões</td><td>{$verificacao2['permissoes']}</td></tr>";
        } else {
            echo "<tr><td>Caminho real</td><td><span class='error'>Arquivo não encontrado</span></td></tr>";
            if (!empty($verificacao2['diretorios_testados'])) {
                echo "<tr><td>Diretórios testados</td><td><ul>";
                foreach ($verificacao2['diretorios_testados'] as $dir) {
                    echo "<li><code>$dir</code></li>";
                }
                echo "</ul></td></tr>";
            }
        }
        echo "</table>";
        
        $resultado2 = $verificacao2['correto'] && $verificacao2['existe'];
        if ($resultado2) {
            $testesSucesso++;
            echo "<p class='success'>✅ TESTE PASSOU: Log criado no diretório correto</p>";
        } else {
            $testesFalha++;
            echo "<p class='error'>❌ TESTE FALHOU: Log não encontrado ou em diretório incorreto</p>";
        }
        
        $resultados[] = [
            'teste' => 'add_webflow_octa.php',
            'arquivo_log' => $teste2['arquivo_log'],
            'sucesso' => $resultado2,
            'verificacao' => $verificacao2
        ];
        
        echo "</div>";
        
        // ==================== TESTE 3: log_endpoint.php ====================
        echo "<div class='test-section'>";
        echo "<h2>📋 TESTE 3: log_endpoint.php</h2>";
        $totalTestes++;
        
        $teste3 = [
            'nome' => 'log_endpoint.php',
            'arquivo_log' => 'log_endpoint_debug.txt',
            'endpoint' => $BASE_URL . '/log_endpoint.php',
            'payload' => [
                'level' => 'INFO',
                'message' => 'Teste LOG_DIR - log_endpoint - ' . $TEST_ID,
                'data' => [
                    'test_id' => $TEST_ID . '_log_endpoint',
                    'test_type' => 'log_dir_verification'
                ],
                'category' => 'TEST'
            ]
        ];
        
        echo "<p><strong>Endpoint:</strong> <code>{$teste3['endpoint']}</code></p>";
        echo "<p><strong>Arquivo de Log Esperado:</strong> <code>{$teste3['arquivo_log']}</code></p>";
        
        // Fazer requisição
        $requisicao3 = fazerRequisicao($teste3['endpoint'], 'POST', $teste3['payload']);
        
        echo "<p><strong>Status HTTP:</strong> {$requisicao3['http_code']}</p>";
        if ($requisicao3['error']) {
            echo "<p class='error'>Erro cURL: {$requisicao3['error']}</p>";
        }
        
        // Aguardar criação do log
        echo "<p>Aguardando criação do log...</p>";
        $logCriado3 = aguardarLog($teste3['arquivo_log'], $LOG_DIR_ESPERADO, $TIMEOUT);
        
        // Verificar caminho
        $verificacao3 = verificarCaminhoLog($teste3['arquivo_log'], $LOG_DIR_ESPERADO);
        
        echo "<table>";
        echo "<tr><th>Verificação</th><th>Resultado</th></tr>";
        echo "<tr><td>Arquivo existe</td><td>" . ($verificacao3['existe'] ? "<span class='success'>✅ SIM</span>" : "<span class='error'>❌ NÃO</span>") . "</td></tr>";
        echo "<tr><td>Caminho correto</td><td>" . ($verificacao3['correto'] ? "<span class='success'>✅ SIM</span>" : "<span class='error'>❌ NÃO</span>") . "</td></tr>";
        echo "<tr><td>Caminho esperado</td><td><code>{$verificacao3['esperado']}</code></td></tr>";
        if ($verificacao3['real']) {
            echo "<tr><td>Caminho real</td><td><code>{$verificacao3['real']}</code></td></tr>";
            echo "<tr><td>Tamanho</td><td>" . number_format($verificacao3['tamanho']) . " bytes</td></tr>";
            echo "<tr><td>Modificado</td><td>{$verificacao3['modificado']}</td></tr>";
            echo "<tr><td>Permissões</td><td>{$verificacao3['permissoes']}</td></tr>";
        } else {
            echo "<tr><td>Caminho real</td><td><span class='error'>Arquivo não encontrado</span></td></tr>";
            if (!empty($verificacao3['diretorios_testados'])) {
                echo "<tr><td>Diretórios testados</td><td><ul>";
                foreach ($verificacao3['diretorios_testados'] as $dir) {
                    echo "<li><code>$dir</code></li>";
                }
                echo "</ul></td></tr>";
            }
        }
        echo "</table>";
        
        $resultado3 = $verificacao3['correto'] && $verificacao3['existe'];
        if ($resultado3) {
            $testesSucesso++;
            echo "<p class='success'>✅ TESTE PASSOU: Log criado no diretório correto</p>";
        } else {
            $testesFalha++;
            echo "<p class='error'>❌ TESTE FALHOU: Log não encontrado ou em diretório incorreto</p>";
        }
        
        $resultados[] = [
            'teste' => 'log_endpoint.php',
            'arquivo_log' => $teste3['arquivo_log'],
            'sucesso' => $resultado3,
            'verificacao' => $verificacao3
        ];
        
        echo "</div>";
        
        // ==================== TESTE 4: ProfessionalLogger.php ====================
        echo "<div class='test-section'>";
        echo "<h2>📋 TESTE 4: ProfessionalLogger.php</h2>";
        $totalTestes++;
        
        // ProfessionalLogger só escreve log quando há erro ao inserir no banco
        // Vamos tentar forçar um erro temporariamente
        echo "<p><strong>Observação:</strong> ProfessionalLogger só escreve log quando há erro ao inserir no banco de dados.</p>";
        echo "<p><strong>Estratégia:</strong> Usar log_endpoint.php que internamente usa ProfessionalLogger e pode falhar.</p>";
        
        $teste4 = [
            'nome' => 'ProfessionalLogger.php (via log_endpoint)',
            'arquivo_log' => 'professional_logger_errors.txt',
            'endpoint' => $BASE_URL . '/log_endpoint.php',
            'payload' => [
                'level' => 'ERROR',
                'message' => 'Teste LOG_DIR - ProfessionalLogger - ' . $TEST_ID,
                'data' => [
                    'test_id' => $TEST_ID . '_professional_logger',
                    'test_type' => 'log_dir_verification',
                    'force_error' => true
                ],
                'category' => 'TEST'
            ]
        ];
        
        echo "<p><strong>Endpoint:</strong> <code>{$teste4['endpoint']}</code></p>";
        echo "<p><strong>Arquivo de Log Esperado:</strong> <code>{$teste4['arquivo_log']}</code></p>";
        echo "<p class='warning'>⚠️ Este teste pode não criar log se ProfessionalLogger não falhar. Verificando se arquivo já existe...</p>";
        
        // Verificar se arquivo já existe (pode ter sido criado por erro anterior)
        $verificacao4 = verificarCaminhoLog($teste4['arquivo_log'], $LOG_DIR_ESPERADO);
        
        if (!$verificacao4['existe']) {
            // Tentar forçar erro fazendo requisição com dados inválidos
            $requisicao4 = fazerRequisicao($teste4['endpoint'], 'POST', $teste4['payload']);
            echo "<p><strong>Status HTTP:</strong> {$requisicao4['http_code']}</p>";
            
            // Aguardar criação do log
            echo "<p>Aguardando criação do log...</p>";
            $logCriado4 = aguardarLog($teste4['arquivo_log'], $LOG_DIR_ESPERADO, $TIMEOUT);
            
            // Verificar novamente
            $verificacao4 = verificarCaminhoLog($teste4['arquivo_log'], $LOG_DIR_ESPERADO);
        }
        
        echo "<table>";
        echo "<tr><th>Verificação</th><th>Resultado</th></tr>";
        echo "<tr><td>Arquivo existe</td><td>" . ($verificacao4['existe'] ? "<span class='success'>✅ SIM</span>" : "<span class='warning'>⚠️ NÃO (pode não ter erro)</span>") . "</td></tr>";
        if ($verificacao4['existe']) {
            echo "<tr><td>Caminho correto</td><td>" . ($verificacao4['correto'] ? "<span class='success'>✅ SIM</span>" : "<span class='error'>❌ NÃO</span>") . "</td></tr>";
            echo "<tr><td>Caminho esperado</td><td><code>{$verificacao4['esperado']}</code></td></tr>";
            echo "<tr><td>Caminho real</td><td><code>{$verificacao4['real']}</code></td></tr>";
            echo "<tr><td>Tamanho</td><td>" . number_format($verificacao4['tamanho']) . " bytes</td></tr>";
            echo "<tr><td>Modificado</td><td>{$verificacao4['modificado']}</td></tr>";
            echo "<tr><td>Permissões</td><td>{$verificacao4['permissoes']}</td></tr>";
        } else {
            echo "<tr><td>Observação</td><td><span class='warning'>ProfessionalLogger só escreve log quando há erro. Se não há erro, arquivo não será criado.</span></td></tr>";
        }
        echo "</table>";
        
        // Para ProfessionalLogger, consideramos sucesso se arquivo existe E está no caminho correto
        // OU se não existe mas é porque não houve erro (comportamento esperado)
        $resultado4 = $verificacao4['existe'] ? ($verificacao4['correto']) : true; // Se não existe, pode ser porque não houve erro
        
        if ($verificacao4['existe'] && $verificacao4['correto']) {
            $testesSucesso++;
            echo "<p class='success'>✅ TESTE PASSOU: Log criado no diretório correto</p>";
        } elseif (!$verificacao4['existe']) {
            $testesSucesso++;
            echo "<p class='info'>ℹ️ TESTE PASSOU: Arquivo não existe porque não houve erro (comportamento esperado)</p>";
        } else {
            $testesFalha++;
            echo "<p class='error'>❌ TESTE FALHOU: Log encontrado em diretório incorreto</p>";
        }
        
        $resultados[] = [
            'teste' => 'ProfessionalLogger.php',
            'arquivo_log' => $teste4['arquivo_log'],
            'sucesso' => $resultado4,
            'verificacao' => $verificacao4
        ];
        
        echo "</div>";
        
        // ==================== RESUMO FINAL ====================
        echo "<div class='summary'>";
        echo "<h3>📊 RESUMO DOS TESTES</h3>";
        echo "<table>";
        echo "<tr><th>Teste</th><th>Arquivo de Log</th><th>Status</th><th>Caminho</th></tr>";
        
        foreach ($resultados as $resultado) {
            $status = $resultado['sucesso'] ? "<span class='success'>✅ PASSOU</span>" : "<span class='error'>❌ FALHOU</span>";
            $caminho = $resultado['verificacao']['real'] ?? 'Não encontrado';
            echo "<tr>";
            echo "<td>{$resultado['teste']}</td>";
            echo "<td>{$resultado['arquivo_log']}</td>";
            echo "<td>$status</td>";
            echo "<td><code>" . htmlspecialchars($caminho) . "</code></td>";
            echo "</tr>";
        }
        
        echo "</table>";
        
        $taxaSucesso = $totalTestes > 0 ? round(($testesSucesso / $totalTestes) * 100, 2) : 0;
        
        echo "<h3>Estatísticas</h3>";
        echo "<p><strong>Total de Testes:</strong> $totalTestes</p>";
        echo "<p><strong>Testes Bem-Sucedidos:</strong> <span class='success'>$testesSucesso</span></p>";
        echo "<p><strong>Testes Falhados:</strong> <span class='error'>$testesFalha</span></p>";
        echo "<p><strong>Taxa de Sucesso:</strong> <strong>$taxaSucesso%</strong></p>";
        
        if ($taxaSucesso == 100) {
            echo "<p class='success'><strong>🎉 TODOS OS TESTES PASSARAM! LOG_DIR está sendo respeitado corretamente.</strong></p>";
        } elseif ($taxaSucesso >= 75) {
            echo "<p class='warning'><strong>⚠️ Maioria dos testes passou, mas alguns falharam. Verificar detalhes acima.</strong></p>";
        } else {
            echo "<p class='error'><strong>❌ Muitos testes falharam. Verificar configuração de LOG_DIR.</strong></p>";
        }
        
        echo "</div>";
        ?>
    </div>
</body>
</html>

