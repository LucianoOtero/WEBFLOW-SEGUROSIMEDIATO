<?php
/**
 * TEST_CARGA.PHP
 * 
 * Teste de Carga:
 * - Múltiplas requisições simultâneas aos endpoints
 * - Teste de rate limiting (se aplicável)
 * - Teste de timeout
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de Carga</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 1200px; margin: 0 auto; padding: 20px; }
        .test-section { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #333; color: white; }
        .success { color: green; }
        .error { color: red; }
        button { padding: 10px 20px; margin: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <h1>📊 Teste de Carga</h1>
    
    <div class="test-section">
        <h2>Configuração do Teste</h2>
        <p>
            <label>Número de requisições simultâneas: <input type="number" id="numRequests" value="10" min="1" max="100"></label>
        </p>
        <p>
            <label>Endpoint: 
                <select id="endpointSelect">
                    <option value="log_endpoint.php">log_endpoint.php</option>
                    <option value="cpf-validate.php">cpf-validate.php</option>
                    <option value="placa-validate.php">placa-validate.php</option>
                    <option value="config_env.js.php">config_env.js.php</option>
                </select>
            </label>
        </p>
        <button onclick="executarTesteCarga()">Executar Teste de Carga</button>
    </div>
    
    <div class="test-section">
        <h2>Resultados</h2>
        <div id="resultados"></div>
        <table id="resultados-table" style="display: none;">
            <tr>
                <th>Requisição</th>
                <th>Tempo (ms)</th>
                <th>Status</th>
                <th>HTTP Code</th>
            </tr>
        </table>
    </div>
    
    <div class="test-section">
        <h2>Estatísticas</h2>
        <div id="estatisticas"></div>
    </div>

    <script>
        const BASE_URL = '<?php echo getBaseUrl(); ?>';
        
        async function fazerRequisicao(endpoint, index) {
            const inicio = performance.now();
            try {
                const data = endpoint.includes('validate') ? 
                    (endpoint.includes('cpf') ? { cpf: '12345678900' } : { placa: 'ABC1234' }) :
                    (endpoint.includes('log') ? { level: 'INFO', category: 'TEST', message: 'Load test ' + index } : null);
                
                const options = {
                    method: data ? 'POST' : 'GET',
                    headers: { 'Content-Type': 'application/json' },
                    mode: 'cors'
                };
                if (data) {
                    options.body = JSON.stringify(data);
                }
                
                const response = await fetch(BASE_URL + '/' + endpoint, options);
                const fim = performance.now();
                const tempo = Math.round(fim - inicio);
                
                return {
                    index,
                    tempo,
                    status: response.ok ? 'success' : 'error',
                    httpCode: response.status
                };
            } catch (error) {
                const fim = performance.now();
                const tempo = Math.round(fim - inicio);
                return {
                    index,
                    tempo,
                    status: 'error',
                    httpCode: 0,
                    error: error.message
                };
            }
        }
        
        async function executarTesteCarga() {
            const numRequests = parseInt(document.getElementById('numRequests').value);
            const endpoint = document.getElementById('endpointSelect').value;
            
            document.getElementById('resultados').innerHTML = `<p>Executando ${numRequests} requisições simultâneas para ${endpoint}...</p>`;
            document.getElementById('resultados-table').style.display = 'table';
            const table = document.getElementById('resultados-table');
            while (table.rows.length > 1) {
                table.deleteRow(1);
            }
            
            const inicio = performance.now();
            const promessas = [];
            for (let i = 1; i <= numRequests; i++) {
                promessas.push(fazerRequisicao(endpoint, i));
            }
            
            const resultados = await Promise.all(promessas);
            const fim = performance.now();
            const tempoTotal = Math.round(fim - inicio);
            
            // Exibir resultados
            resultados.forEach(resultado => {
                const row = table.insertRow();
                row.insertCell(0).textContent = 'Requisição ' + resultado.index;
                row.insertCell(1).textContent = resultado.tempo + ' ms';
                const statusCell = row.insertCell(2);
                statusCell.textContent = resultado.status === 'success' ? '✅ OK' : '❌ ERRO';
                statusCell.className = resultado.status;
                row.insertCell(3).textContent = resultado.httpCode || 'N/A';
            });
            
            // Estatísticas
            const sucessos = resultados.filter(r => r.status === 'success').length;
            const falhas = resultados.filter(r => r.status === 'error').length;
            const tempos = resultados.map(r => r.tempo);
            const media = Math.round(tempos.reduce((a, b) => a + b, 0) / tempos.length);
            const max = Math.max(...tempos);
            const min = Math.min(...tempos);
            
            document.getElementById('estatisticas').innerHTML = `
                <p><strong>Tempo total:</strong> ${tempoTotal} ms</p>
                <p><strong>Sucessos:</strong> ${sucessos} (${Math.round(sucessos/numRequests*100)}%)</p>
                <p><strong>Falhas:</strong> ${falhas} (${Math.round(falhas/numRequests*100)}%)</p>
                <p><strong>Tempo médio por requisição:</strong> ${media} ms</p>
                <p><strong>Tempo mínimo:</strong> ${min} ms</p>
                <p><strong>Tempo máximo:</strong> ${max} ms</p>
                <p><strong>Requisições por segundo:</strong> ${Math.round(numRequests / (tempoTotal / 1000))}</p>
            `;
        }
    </script>
</body>
</html>

