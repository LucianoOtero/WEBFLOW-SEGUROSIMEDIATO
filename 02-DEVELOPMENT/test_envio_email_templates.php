<?php
/**
 * TEST_ENVIO_EMAIL_TEMPLATES.PHP
 * 
 * Script de teste para verificar se o envio de emails está funcionando
 * com os 3 templates disponíveis:
 * 1. template_logging.php - Para erros de logging
 * 2. template_modal.php - Para notificações do modal WhatsApp
 * 3. template_primeiro_contato.php - Para primeiro contato (se existir)
 */

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/send_admin_notification_ses.php';

header('Content-Type: text/plain');

echo "==========================================" . PHP_EOL;
echo "TESTE DE ENVIO DE EMAILS - 3 TEMPLATES" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$resultados = [];
$erros = [];

// ==================== TESTE 1: TEMPLATE LOGGING ====================
echo "TESTE 1: Template Logging (Erros de Sistema)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$dadosLogging = [
    'ddd' => '00',
    'celular' => '000000000',
    'erro' => [
        'level' => 'ERROR',
        'category' => 'DATABASE',
        'message' => 'Erro de conexão com banco de dados',
        'file_name' => 'ProfessionalLogger.php',
        'line_number' => 150,
        'stack_trace' => "Error: Database connection failed\n  at ProfessionalLogger->getConnection() (ProfessionalLogger.php:150)\n  at ProfessionalLogger->log() (ProfessionalLogger.php:200)",
        'timestamp' => date('Y-m-d H:i:s'),
        'environment' => 'development'
    ],
    'momento' => 'system_error',
    'momento_descricao' => 'Erro de Sistema - Logging'
];

try {
    $resultado = enviarNotificacaoAdministradores($dadosLogging);
    if ($resultado['success']) {
        echo "✅ Template Logging: EMAIL ENVIADO COM SUCESSO" . PHP_EOL;
        echo "   Total enviados: {$resultado['total_sent']}" . PHP_EOL;
        echo "   Total falhas: {$resultado['total_failed']}" . PHP_EOL;
        $resultados['logging'] = $resultado;
    } else {
        echo "❌ Template Logging: FALHA NO ENVIO" . PHP_EOL;
        echo "   Erro: {$resultado['error']}" . PHP_EOL;
        $erros['logging'] = $resultado['error'];
    }
} catch (Exception $e) {
    echo "❌ Template Logging: EXCEÇÃO" . PHP_EOL;
    echo "   Erro: " . $e->getMessage() . PHP_EOL;
    $erros['logging'] = $e->getMessage();
}

echo PHP_EOL;

// ==================== TESTE 2: TEMPLATE MODAL ====================
echo "TESTE 2: Template Modal (Notificação Completa)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

$dadosModal = [
    'ddd' => '11',
    'celular' => '987654321',
    'nome' => 'João Silva',
    'email' => 'joao.silva@example.com',
    'cpf' => '123.456.789-00',
    'cep' => '01310-100',
    'placa' => 'ABC1234',
    'marca' => 'Honda',
    'modelo' => 'Civic',
    'ano' => '2020',
    'momento' => 'complete',
    'momento_descricao' => 'Formulário Completo - Modal WhatsApp',
    'timestamp' => date('Y-m-d H:i:s'),
    'gclid' => 'test-gclid-12345'
];

try {
    $resultado = enviarNotificacaoAdministradores($dadosModal);
    if ($resultado['success']) {
        echo "✅ Template Modal: EMAIL ENVIADO COM SUCESSO" . PHP_EOL;
        echo "   Total enviados: {$resultado['total_sent']}" . PHP_EOL;
        echo "   Total falhas: {$resultado['total_failed']}" . PHP_EOL;
        $resultados['modal'] = $resultado;
    } else {
        echo "❌ Template Modal: FALHA NO ENVIO" . PHP_EOL;
        echo "   Erro: {$resultado['error']}" . PHP_EOL;
        $erros['modal'] = $resultado['error'];
    }
} catch (Exception $e) {
    echo "❌ Template Modal: EXCEÇÃO" . PHP_EOL;
    echo "   Erro: " . $e->getMessage() . PHP_EOL;
    $erros['modal'] = $e->getMessage();
}

echo PHP_EOL;

// ==================== TESTE 3: TEMPLATE PRIMEIRO CONTATO ====================
echo "TESTE 3: Template Primeiro Contato (Apenas Telefone)" . PHP_EOL;
echo "----------------------------------------" . PHP_EOL;

// Verificar se template existe
$templatePrimeiroContatoPath = __DIR__ . '/email_templates/template_primeiro_contato.php';
if (!file_exists($templatePrimeiroContatoPath)) {
    echo "⚠️  Template template_primeiro_contato.php não encontrado" . PHP_EOL;
    echo "   O sistema usará template_modal.php como fallback" . PHP_EOL;
    echo "   Testando com dados de primeiro contato..." . PHP_EOL;
}

$dadosPrimeiroContato = [
    'ddd' => '21',
    'celular' => '987654321',
    'nome' => 'Maria Santos',
    'email' => '', // Vazio - primeiro contato
    'cpf' => '', // Vazio - primeiro contato
    'cep' => '', // Vazio - primeiro contato
    'placa' => '', // Vazio - primeiro contato
    'momento' => 'initial',
    'momento_descricao' => 'Primeiro Contato - Apenas Telefone',
    'timestamp' => date('Y-m-d H:i:s')
];

try {
    $resultado = enviarNotificacaoAdministradores($dadosPrimeiroContato);
    if ($resultado['success']) {
        echo "✅ Template Primeiro Contato: EMAIL ENVIADO COM SUCESSO" . PHP_EOL;
        echo "   Total enviados: {$resultado['total_sent']}" . PHP_EOL;
        echo "   Total falhas: {$resultado['total_failed']}" . PHP_EOL;
        if (!file_exists($templatePrimeiroContatoPath)) {
            echo "   ⚠️  Nota: Usou template_modal.php (template_primeiro_contato.php não existe)" . PHP_EOL;
        }
        $resultados['primeiro_contato'] = $resultado;
    } else {
        echo "❌ Template Primeiro Contato: FALHA NO ENVIO" . PHP_EOL;
        echo "   Erro: {$resultado['error']}" . PHP_EOL;
        $erros['primeiro_contato'] = $resultado['error'];
    }
} catch (Exception $e) {
    echo "❌ Template Primeiro Contato: EXCEÇÃO" . PHP_EOL;
    echo "   Erro: " . $e->getMessage() . PHP_EOL;
    $erros['primeiro_contato'] = $e->getMessage();
}

echo PHP_EOL;

// ==================== RESUMO ====================
echo "==========================================" . PHP_EOL;
echo "RESUMO DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;
echo PHP_EOL;

$sucessos = count($resultados);
$falhas = count($erros);
$templatesExistentes = 2; // template_logging e template_modal existem
$templatePrimeiroContatoExiste = file_exists(__DIR__ . '/email_templates/template_primeiro_contato.php');
if ($templatePrimeiroContatoExiste) {
    $templatesExistentes = 3;
}

echo "Templates existentes: $templatesExistentes" . PHP_EOL;
echo "Templates testados: 3" . PHP_EOL;
echo "Sucessos: $sucessos" . PHP_EOL;
echo "Falhas: $falhas" . PHP_EOL;
echo PHP_EOL;

if ($sucessos === 3) {
    if ($templatePrimeiroContatoExiste) {
        echo "✅ TODOS OS 3 TEMPLATES FUNCIONANDO CORRETAMENTE!" . PHP_EOL;
    } else {
        echo "✅ TEMPLATES DISPONÍVEIS FUNCIONANDO CORRETAMENTE!" . PHP_EOL;
        echo "   ⚠️  Nota: template_primeiro_contato.php não existe (usando template_modal como fallback)" . PHP_EOL;
    }
} elseif ($sucessos > 0) {
    echo "⚠️  ALGUNS TEMPLATES FUNCIONANDO" . PHP_EOL;
    echo PHP_EOL;
    echo "Templates com sucesso:" . PHP_EOL;
    foreach ($resultados as $template => $resultado) {
        echo "  ✅ $template: {$resultado['total_sent']} email(s) enviado(s)" . PHP_EOL;
    }
    echo PHP_EOL;
    if (count($erros) > 0) {
        echo "Templates com falha:" . PHP_EOL;
        foreach ($erros as $template => $erro) {
            echo "  ❌ $template: $erro" . PHP_EOL;
        }
    }
} else {
    echo "❌ NENHUM TEMPLATE FUNCIONOU" . PHP_EOL;
    echo PHP_EOL;
    echo "Erros encontrados:" . PHP_EOL;
    foreach ($erros as $template => $erro) {
        echo "  ❌ $template: $erro" . PHP_EOL;
    }
}

echo PHP_EOL;
echo "==========================================" . PHP_EOL;
echo "FIM DOS TESTES" . PHP_EOL;
echo "==========================================" . PHP_EOL;

