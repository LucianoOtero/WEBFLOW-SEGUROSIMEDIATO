<?php
/**
 * TESTE DE ENVIO DE EMAIL COM TEMPLATE ORIGINAL DO MODAL
 * 
 * Testa se o template original do modal WhatsApp ainda funciona corretamente
 * após a refatoração para sistema de templates
 */

// Carregar função de envio de email
require_once __DIR__ . '/send_admin_notification_ses.php';

echo "🧪 TESTE DE ENVIO DE EMAIL COM TEMPLATE ORIGINAL DO MODAL\n";
echo str_repeat("=", 70) . "\n\n";

// ============================================
// TESTE 1: Modal - Initial (Novo Contato)
// ============================================
echo "📱 TESTE 1: Enviando email Modal - Initial (Novo Contato)...\n";
echo str_repeat("-", 70) . "\n";

$dadosModalInitial = [
    'ddd' => '11',
    'celular' => '987654321',
    'nome' => 'João Silva',
    'cpf' => '123.456.789-00',
    'email' => 'joao.silva@example.com',
    'cep' => '01234-567',
    'placa' => 'ABC1234',
    'gclid' => 'test-gclid-initial-123',
    'momento' => 'initial',
    'momento_descricao' => 'Novo Contato',
    'momento_emoji' => '📱',
    'erro' => null // Sem erro
];

$resultModalInitial = enviarNotificacaoAdministradores($dadosModalInitial);
echo "   Sucesso: " . ($resultModalInitial['success'] ? '✅ SIM' : '❌ NÃO') . "\n";
echo "   Total enviado: " . ($resultModalInitial['total_sent'] ?? 0) . "\n";
echo "   Total falhou: " . ($resultModalInitial['total_failed'] ?? 0) . "\n";
if (isset($resultModalInitial['error'])) {
    echo "   Erro: " . $resultModalInitial['error'] . "\n";
}
echo "\n";

// Aguardar 2 segundos entre envios
sleep(2);

// ============================================
// TESTE 2: Modal - Update (Atualização)
// ============================================
echo "📱 TESTE 2: Enviando email Modal - Update (Atualização)...\n";
echo str_repeat("-", 70) . "\n";

$dadosModalUpdate = [
    'ddd' => '21',
    'celular' => '876543210',
    'nome' => 'Maria Santos',
    'cpf' => '987.654.321-00',
    'email' => 'maria.santos@example.com',
    'cep' => '20000-000',
    'placa' => 'XYZ9876',
    'gclid' => 'test-gclid-update-456',
    'momento' => 'update',
    'momento_descricao' => 'Atualização de Contato',
    'momento_emoji' => '🔄',
    'erro' => null // Sem erro
];

$resultModalUpdate = enviarNotificacaoAdministradores($dadosModalUpdate);
echo "   Sucesso: " . ($resultModalUpdate['success'] ? '✅ SIM' : '❌ NÃO') . "\n";
echo "   Total enviado: " . ($resultModalUpdate['total_sent'] ?? 0) . "\n";
echo "   Total falhou: " . ($resultModalUpdate['total_failed'] ?? 0) . "\n";
if (isset($resultModalUpdate['error'])) {
    echo "   Erro: " . $resultModalUpdate['error'] . "\n";
}
echo "\n";

// Aguardar 2 segundos entre envios
sleep(2);

// ============================================
// TESTE 3: Modal - Com Erro (Erro no Envio)
// ============================================
echo "📱 TESTE 3: Enviando email Modal - Com Erro (Erro no Envio)...\n";
echo str_repeat("-", 70) . "\n";

$dadosModalError = [
    'ddd' => '31',
    'celular' => '765432109',
    'nome' => 'Pedro Oliveira',
    'cpf' => '111.222.333-44',
    'email' => 'pedro.oliveira@example.com',
    'cep' => '30000-000',
    'placa' => 'DEF5678',
    'gclid' => 'test-gclid-error-789',
    'momento' => 'error',
    'momento_descricao' => 'Erro no Envio',
    'momento_emoji' => '❌',
    'erro' => [
        'message' => 'Falha ao enviar dados para EspoCRM',
        'status' => 500,
        'code' => 'ESPOCRM_ERROR'
    ]
];

$resultModalError = enviarNotificacaoAdministradores($dadosModalError);
echo "   Sucesso: " . ($resultModalError['success'] ? '✅ SIM' : '❌ NÃO') . "\n";
echo "   Total enviado: " . ($resultModalError['total_sent'] ?? 0) . "\n";
echo "   Total falhou: " . ($resultModalError['total_failed'] ?? 0) . "\n";
if (isset($resultModalError['error'])) {
    echo "   Erro: " . $resultModalError['error'] . "\n";
}
echo "\n";

// ============================================
// RESUMO
// ============================================
echo str_repeat("=", 70) . "\n";
echo "📊 RESUMO DOS TESTES DO TEMPLATE ORIGINAL DO MODAL\n";
echo str_repeat("=", 70) . "\n";
echo "Modal Initial: " . ($resultModalInitial['success'] ? '✅ Enviado' : '❌ Falhou') . " (" . ($resultModalInitial['total_sent'] ?? 0) . " emails)\n";
echo "Modal Update:  " . ($resultModalUpdate['success'] ? '✅ Enviado' : '❌ Falhou') . " (" . ($resultModalUpdate['total_sent'] ?? 0) . " emails)\n";
echo "Modal Error:   " . ($resultModalError['success'] ? '✅ Enviado' : '❌ Falhou') . " (" . ($resultModalError['total_sent'] ?? 0) . " emails)\n";
echo "\n";
echo "📧 Total de emails enviados: " . (($resultModalInitial['total_sent'] ?? 0) + ($resultModalUpdate['total_sent'] ?? 0) + ($resultModalError['total_sent'] ?? 0)) . "\n";
echo "👥 Para " . (($resultModalInitial['total_recipients'] ?? 0) ?: ($resultModalUpdate['total_recipients'] ?? 0) ?: ($resultModalError['total_recipients'] ?? 0)) . " administrador(es)\n";
echo "\n";

// Verificar se template correto foi usado
echo "🔍 VERIFICAÇÃO DO TEMPLATE:\n";
echo str_repeat("-", 70) . "\n";

// Carregar carregador de templates para verificar detecção
require_once __DIR__ . '/email_template_loader.php';

$tipoModalInitial = detectTemplateType($dadosModalInitial);
$tipoModalUpdate = detectTemplateType($dadosModalUpdate);
$tipoModalError = detectTemplateType($dadosModalError);

echo "   Modal Initial → Template detectado: " . $tipoModalInitial . " (esperado: modal) " . ($tipoModalInitial === 'modal' ? '✅' : '❌') . "\n";
echo "   Modal Update → Template detectado: " . $tipoModalUpdate . " (esperado: modal) " . ($tipoModalUpdate === 'modal' ? '✅' : '❌') . "\n";
echo "   Modal Error → Template detectado: " . $tipoModalError . " (esperado: modal) " . ($tipoModalError === 'modal' ? '✅' : '❌') . "\n";
echo "\n";

echo "✅ TESTE CONCLUÍDO!\n";
echo "   Verifique sua caixa de entrada para os emails com o template original do modal.\n";
echo "   Os emails devem mostrar dados do cliente (telefone, nome, CPF, etc.) e NÃO informações técnicas.\n";
echo str_repeat("=", 70) . "\n";

