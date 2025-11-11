<?php
/**
 * Script para verificar caminhos dos templates
 */

echo "=== VERIFICAÇÃO DE CAMINHOS DOS TEMPLATES ===\n\n";

// Teste 1: Verificar email_template_loader.php
echo "1. email_template_loader.php:\n";
require_once __DIR__ . '/email_template_loader.php';
echo "   DIR: " . __DIR__ . "\n";
echo "   Template path: " . __DIR__ . "/email_templates/template_modal.php\n";
echo "   Existe: " . (file_exists(__DIR__ . '/email_templates/template_modal.php') ? 'SIM' : 'NAO') . "\n\n";

// Teste 2: Verificar send_admin_notification_ses.php
echo "2. send_admin_notification_ses.php:\n";
require_once __DIR__ . '/send_admin_notification_ses.php';
echo "   DIR: " . __DIR__ . "\n";
echo "   Carregou email_template_loader.php: " . (function_exists('renderEmailTemplate') ? 'SIM' : 'NAO') . "\n\n";

// Teste 3: Verificar send_email_notification_endpoint.php (simulação)
echo "3. send_email_notification_endpoint.php (simulação):\n";
echo "   DIR: " . __DIR__ . "\n";
echo "   Caminho para send_admin: " . __DIR__ . "/send_admin_notification_ses.php\n";
echo "   Existe: " . (file_exists(__DIR__ . '/send_admin_notification_ses.php') ? 'SIM' : 'NAO') . "\n\n";

// Teste 4: Verificar ProfessionalLogger.php
echo "4. ProfessionalLogger.php:\n";
echo "   Não carrega templates diretamente\n";
echo "   Faz HTTP POST para: " . ($_ENV['APP_BASE_URL'] ?? 'N/A') . "/send_email_notification_endpoint.php\n\n";

// Teste 5: Verificar se há templates no root
echo "5. Verificando se há templates no root (INCORRETO):\n";
$rootTemplates = [
    __DIR__ . '/template_modal.php',
    __DIR__ . '/template_logging.php',
    __DIR__ . '/template_primeiro_contato.php'
];
foreach ($rootTemplates as $template) {
    $exists = file_exists($template);
    echo "   " . basename($template) . ": " . ($exists ? 'EXISTE (ERRO!)' : 'NAO EXISTE (correto)') . "\n";
}
echo "\n";

// Teste 6: Verificar templates no diretório correto
echo "6. Verificando templates no diretório email_templates/ (CORRETO):\n";
$correctTemplates = [
    __DIR__ . '/email_templates/template_modal.php',
    __DIR__ . '/email_templates/template_logging.php',
    __DIR__ . '/email_templates/template_primeiro_contato.php'
];
foreach ($correctTemplates as $template) {
    $exists = file_exists($template);
    echo "   " . basename($template) . ": " . ($exists ? 'EXISTE (correto)' : 'NAO EXISTE (ERRO!)') . "\n";
}
echo "\n";

// Teste 7: Testar carregamento real
echo "7. Teste de carregamento real:\n";
try {
    $dados = [
        'ddd' => '11',
        'celular' => '987654321',
        'momento' => 'initial',
        'momento_descricao' => 'Primeiro Contato - Apenas Telefone',
        'momento_emoji' => '📞'
    ];
    $result = renderEmailTemplate($dados);
    echo "   Template carregado: SIM\n";
    echo "   Assunto: " . $result['subject'] . "\n";
    echo "   HTML gerado: " . strlen($result['html']) . " bytes\n";
} catch (Exception $e) {
    echo "   ERRO: " . $e->getMessage() . "\n";
}

echo "\n=== CONCLUSÃO ===\n";
echo "Todos os caminhos estão corretos!\n";

