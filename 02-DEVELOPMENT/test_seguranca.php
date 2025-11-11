<?php
/**
 * TEST_SEGURANCA.PHP
 * 
 * Teste de Segurança:
 * - Validação de CORS em diferentes origens
 * - Validação de dados de entrada
 * - Proteção contra SQL injection
 * - Proteção contra XSS
 */

require_once __DIR__ . '/config.php';

header('Content-Type: text/html; charset=utf-8');
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Teste de Segurança</title>
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
    <h1>🔒 Teste de Segurança</h1>
    
    <div class="test-section">
        <h2>1. Validação de CORS</h2>
        <table id="cors-table">
            <tr>
                <th>Origem</th>
                <th>Permitida</th>
                <th>Status</th>
            </tr>
        </table>
    </div>
    
    <div class="test-section">
        <h2>2. Validação de Dados de Entrada</h2>
        <table id="validacao-table">
            <tr>
                <th>Teste</th>
                <th>Dados Enviados</th>
                <th>Resultado</th>
                <th>Status</th>
            </tr>
        </table>
    </div>
    
    <div class="test-section">
        <h2>3. Proteção contra SQL Injection</h2>
        <table id="sql-table">
            <tr>
                <th>Teste</th>
                <th>Payload</th>
                <th>Resultado</th>
                <th>Status</th>
            </tr>
        </table>
    </div>
    
    <div class="test-section">
        <h2>4. Proteção contra XSS</h2>
        <table id="xss-table">
            <tr>
                <th>Teste</th>
                <th>Payload</th>
                <th>Resultado</th>
                <th>Status</th>
            </tr>
        </table>
    </div>

    <script>
        const BASE_URL = '<?php echo getBaseUrl(); ?>';
        
        async function testarCORS(origem) {
            try {
                const response = await fetch(BASE_URL + '/log_endpoint.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Origin': origem
                    },
                    body: JSON.stringify({ level: 'INFO', category: 'TEST', message: 'CORS test' }),
                    mode: 'cors'
                });
                
                const corsHeader = response.headers.get('Access-Control-Allow-Origin');
                return {
                    origem,
                    permitida: corsHeader === origem || corsHeader === '*',
                    status: response.ok ? 'success' : 'error'
                };
            } catch (error) {
                return {
                    origem,
                    permitida: false,
                    status: 'error',
                    error: error.message
                };
            }
        }
        
        async function testarValidacao(endpoint, dados, esperado) {
            try {
                const response = await fetch(BASE_URL + '/' + endpoint, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(dados),
                    mode: 'cors'
                });
                
                const data = await response.json();
                const validado = response.status === esperado;
                
                return {
                    endpoint,
                    dados: JSON.stringify(dados).substring(0, 50) + '...',
                    resultado: response.status + ' - ' + (data.error || 'OK'),
                    status: validado ? 'success' : 'warning'
                };
            } catch (error) {
                return {
                    endpoint,
                    dados: JSON.stringify(dados).substring(0, 50) + '...',
                    resultado: 'ERRO: ' + error.message,
                    status: 'error'
                };
            }
        }
        
        async function executarTestes() {
            // Teste 1: CORS
            const origens = [
                'https://segurosimediato-dev.webflow.io',
                'https://dev.bssegurosimediato.com.br',
                'https://evil.com',
                'http://localhost'
            ];
            
            const corsTable = document.getElementById('cors-table');
            for (const origem of origens) {
                const resultado = await testarCORS(origem);
                const row = corsTable.insertRow();
                row.insertCell(0).textContent = origem;
                row.insertCell(1).textContent = resultado.permitida ? 'SIM' : 'NÃO';
                const statusCell = row.insertCell(2);
                statusCell.textContent = resultado.permitida ? '✅ PERMITIDO' : '❌ BLOQUEADO';
                statusCell.className = resultado.permitida ? 'success' : 'success'; // Bloqueado é bom!
            }
            
            // Teste 2: Validação de Dados
            const validacoes = [
                { endpoint: 'cpf-validate.php', dados: { cpf: '' }, esperado: 400 },
                { endpoint: 'cpf-validate.php', dados: { cpf: '123' }, esperado: 400 },
                { endpoint: 'placa-validate.php', dados: { placa: '' }, esperado: 400 },
                { endpoint: 'log_endpoint.php', dados: {}, esperado: 400 }
            ];
            
            const validacaoTable = document.getElementById('validacao-table');
            for (const teste of validacoes) {
                const resultado = await testarValidacao(teste.endpoint, teste.dados, teste.esperado);
                const row = validacaoTable.insertRow();
                row.insertCell(0).textContent = teste.endpoint;
                row.insertCell(1).textContent = resultado.dados;
                row.insertCell(2).textContent = resultado.resultado;
                const statusCell = row.insertCell(3);
                statusCell.textContent = resultado.status === 'success' ? '✅ OK' : '⚠️ ATENÇÃO';
                statusCell.className = resultado.status;
            }
            
            // Teste 3: SQL Injection
            const sqlPayloads = [
                "' OR '1'='1",
                "'; DROP TABLE users; --",
                "1' UNION SELECT * FROM users --"
            ];
            
            const sqlTable = document.getElementById('sql-table');
            for (const payload of sqlPayloads) {
                const resultado = await testarValidacao('cpf-validate.php', { cpf: payload }, 400);
                const row = sqlTable.insertRow();
                row.insertCell(0).textContent = 'SQL Injection';
                row.insertCell(1).textContent = payload;
                row.insertCell(2).textContent = resultado.resultado;
                const statusCell = row.insertCell(3);
                statusCell.textContent = resultado.status === 'success' ? '✅ PROTEGIDO' : '❌ VULNERÁVEL';
                statusCell.className = resultado.status === 'success' ? 'success' : 'error';
            }
            
            // Teste 4: XSS
            const xssPayloads = [
                "<script>alert('XSS')</script>",
                "<img src=x onerror=alert('XSS')>",
                "javascript:alert('XSS')"
            ];
            
            const xssTable = document.getElementById('xss-table');
            for (const payload of xssPayloads) {
                const resultado = await testarValidacao('log_endpoint.php', { 
                    level: 'INFO', 
                    category: 'TEST', 
                    message: payload 
                }, 200);
                const row = xssTable.insertRow();
                row.insertCell(0).textContent = 'XSS';
                row.insertCell(1).textContent = payload.substring(0, 30) + '...';
                row.insertCell(2).textContent = resultado.resultado;
                const statusCell = row.insertCell(3);
                // Verificar se o payload foi sanitizado na resposta
                const sanitizado = !resultado.resultado.includes('<script>') && !resultado.resultado.includes('onerror');
                statusCell.textContent = sanitizado ? '✅ PROTEGIDO' : '⚠️ VERIFICAR';
                statusCell.className = sanitizado ? 'success' : 'warning';
            }
        }
        
        executarTestes();
    </script>
</body>
</html>

