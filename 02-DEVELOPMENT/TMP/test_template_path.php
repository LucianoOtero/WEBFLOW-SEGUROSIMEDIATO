<?php
/**
 * Script de teste para verificar caminhos dos templates
 */

// Simular como send_admin_notification_ses.php carrega
chdir('/var/www/html/dev/root');
require_once __DIR__ . '/email_template_loader.php';

echo "=== VERIFICAÇÃO DE CAMINHOS DE TEMPLATES ===\n\n";

echo "DIR do email_template_loader.php: " . __DIR__ . "\n";
echo "DIR atual (getcwd): " . getcwd() . "\n\n";

echo "Verificando templates:\n";
$baseDir = __DIR__;
$templatesDir = $baseDir . '/email_templates';

echo "  Diretório de templates: {$templatesDir}\n";
echo "  Existe diretório: " . (is_dir($templatesDir) ? 'SIM' : 'NAO') . "\n\n";

$templates = [
    'template_modal.php',
    'template_logging.php',
    'template_primeiro_contato.php'
];

foreach ($templates as $template) {
    $path = $templatesDir . '/' . $template;
    $exists = file_exists($path);
    $size = $exists ? filesize($path) : 0;
    echo "  {$template}:\n";
    echo "    Caminho: {$path}\n";
    echo "    Existe: " . ($exists ? 'SIM' : 'NAO') . "\n";
    if ($exists) {
        echo "    Tamanho: {$size} bytes\n";
    }
    echo "\n";
}

echo "=== TESTE DE CARREGAMENTO ===\n\n";

// Testar carregamento real
try {
    $dados = [
        'ddd' => '11',
        'celular' => '987654321',
        'nome' => 'Teste',
        'momento' => 'initial',
        'momento_descricao' => 'Primeiro Contato - Apenas Telefone',
        'momento_emoji' => '📞'
    ];
    
    $result = renderEmailTemplate($dados);
    echo "Template carregado com sucesso!\n";
    echo "Assunto: " . $result['subject'] . "\n";
    echo "HTML gerado: " . (strlen($result['html']) > 0 ? 'SIM (' . strlen($result['html']) . ' bytes)' : 'NAO') . "\n";
    echo "Texto gerado: " . (strlen($result['text']) > 0 ? 'SIM (' . strlen($result['text']) . ' bytes)' : 'NAO') . "\n";
} catch (Exception $e) {
    echo "ERRO ao carregar template: " . $e->getMessage() . "\n";
}

