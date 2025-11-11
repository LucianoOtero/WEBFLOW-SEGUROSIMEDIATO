<?php
/**
 * TEST_PERFORMANCE.PHP
 * 
 * Teste de Performance:
 * - Tempo de resposta de cada endpoint
 * - Tempo de carregamento dos scripts JavaScript
 * - Tempo de renderização dos templates de email
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de Performance</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; }
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
    <h1>⚡ Teste de Performance</h1>
    
    <div class="test-section">
        <h2>1. Tempo de Resposta dos Endpoints PHP</h2>
        <table id="endpoints-table">
            <tr>
                <th>Endpoint</th>
                <th>Tempo (ms)</th>
                <th>Status</th>
                <th>Detalhes</th>
            </tr>
        </table>
    </div>
    
    <div class="test-section">
        <h2>2. Tempo de Carregamento dos Scripts JavaScript</h2>
        <table id="scripts-table">
            <tr>
                <th>Script</th>
                <th>Tempo (ms)</th>
                <th>Status</th>
            </tr>
        </table>
    </div>
    
    <div class="test-section">
        <h2>3. Tempo de Renderização dos Templates de Email</h2>
        <table id="templates-table">
            <tr>
                <th>Template</th>
                <th>Tempo (ms)</th>
                <th>Status</th>
            </tr>
        </table>
    </div>
    
    <div class="test-section">
        <h2>📊 Resumo</h2>
        <div id="resumo"></div>
    </div>

    <script>
        const BASE_URL = '<?php echo getBaseUrl(); ?>';
        const resultados = [];
        
        async function testarEndpointPerformance(nome, url, data = null) {
            const inicio = performance.now();
            try {
                const options = {
                    method: data ? 'POST' : 'GET',
                    headers: { 'Content-Type': 'application/json' },
                    mode: 'cors'
                };
                if (data) {
                    options.body = JSON.stringify(data);
                }
                const response = await fetch(url, options);
                const fim = performance.now();
                const tempo = Math.round(fim - inicio);
                return {
                    nome,
                    tempo,
                    status: response.ok ? 'success' : 'error',
                    httpCode: response.status
                };
            } catch (error) {
                const fim = performance.now();
                const tempo = Math.round(fim - inicio);
                return {
                    nome,
                    tempo,
                    status: 'error',
                    error: error.message
                };
            }
        }
        
        async function testarScriptPerformance(nome, url) {
            return new Promise((resolve) => {
                const inicio = performance.now();
                const script = document.createElement('script');
                script.src = url;
                script.onload = () => {
                    const fim = performance.now();
                    resolve({
                        nome,
                        tempo: Math.round(fim - inicio),
                        status: 'success'
                    });
                };
                script.onerror = () => {
                    const fim = performance.now();
                    resolve({
                        nome,
                        tempo: Math.round(fim - inicio),
                        status: 'error'
                    });
                };
                document.head.appendChild(script);
            });
        }
        
        async function executarTestes() {
            // Teste 1: Endpoints PHP
            const endpoints = [
                { nome: 'config_env.js.php', url: BASE_URL + '/config_env.js.php' },
                { nome: 'log_endpoint.php', url: BASE_URL + '/log_endpoint.php', data: {
                    level: 'INFO', category: 'TEST', message: 'Performance test'
                }},
                { nome: 'cpf-validate.php', url: BASE_URL + '/cpf-validate.php', data: {
                    cpf: '12345678900'
                }},
                { nome: 'placa-validate.php', url: BASE_URL + '/placa-validate.php', data: {
                    placa: 'ABC1234'
                }}
            ];
            
            const endpointsTable = document.getElementById('endpoints-table');
            for (const endpoint of endpoints) {
                const resultado = await testarEndpointPerformance(endpoint.nome, endpoint.url, endpoint.data);
                resultados.push(resultado);
                const row = endpointsTable.insertRow();
                row.insertCell(0).textContent = resultado.nome;
                row.insertCell(1).textContent = resultado.tempo + ' ms';
                const statusCell = row.insertCell(2);
                statusCell.textContent = resultado.status === 'success' ? '✅ OK' : '❌ ERRO';
                statusCell.className = resultado.status;
                row.insertCell(3).textContent = resultado.httpCode || resultado.error || 'N/A';
            }
            
            // Teste 2: Scripts JavaScript
            const scripts = [
                { nome: 'config_env.js.php', url: BASE_URL + '/config_env.js.php' },
                { nome: 'webflow_injection_limpo.js', url: BASE_URL + '/webflow_injection_limpo.js' },
                { nome: 'MODAL_WHATSAPP_DEFINITIVO.js', url: BASE_URL + '/MODAL_WHATSAPP_DEFINITIVO.js' }
            ];
            
            const scriptsTable = document.getElementById('scripts-table');
            for (const script of scripts) {
                const resultado = await testarScriptPerformance(script.nome, script.url);
                const row = scriptsTable.insertRow();
                row.insertCell(0).textContent = resultado.nome;
                row.insertCell(1).textContent = resultado.tempo + ' ms';
                const statusCell = row.insertCell(2);
                statusCell.textContent = resultado.status === 'success' ? '✅ OK' : '❌ ERRO';
                statusCell.className = resultado.status;
            }
            
            // Teste 3: Templates de Email (via PHP)
            const templatesTable = document.getElementById('templates-table');
            const templates = ['logging', 'modal', 'primeiro_contato'];
            for (const template of templates) {
                const inicio = performance.now();
                try {
                    const response = await fetch(BASE_URL + '/test_envio_email_templates.php');
                    const fim = performance.now();
                    const tempo = Math.round(fim - inicio);
                    const row = templatesTable.insertRow();
                    row.insertCell(0).textContent = 'template_' + template + '.php';
                    row.insertCell(1).textContent = tempo + ' ms';
                    const statusCell = row.insertCell(2);
                    statusCell.textContent = response.ok ? '✅ OK' : '❌ ERRO';
                    statusCell.className = response.ok ? 'success' : 'error';
                } catch (error) {
                    const fim = performance.now();
                    const tempo = Math.round(fim - inicio);
                    const row = templatesTable.insertRow();
                    row.insertCell(0).textContent = 'template_' + template + '.php';
                    row.insertCell(1).textContent = tempo + ' ms';
                    const statusCell = row.insertCell(2);
                    statusCell.textContent = '❌ ERRO';
                    statusCell.className = 'error';
                }
            }
            
            // Resumo
            const tempos = resultados.map(r => r.tempo);
            const media = Math.round(tempos.reduce((a, b) => a + b, 0) / tempos.length);
            const max = Math.max(...tempos);
            const min = Math.min(...tempos);
            
            document.getElementById('resumo').innerHTML = `
                <p><strong>Média de tempo:</strong> ${media} ms</p>
                <p><strong>Tempo mínimo:</strong> ${min} ms</p>
                <p><strong>Tempo máximo:</strong> ${max} ms</p>
                <p><strong>Total de testes:</strong> ${resultados.length}</p>
            `;
        }
        
        executarTestes();
    </script>
</body>
</html>

