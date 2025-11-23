<?php
/**
 * TEMPLATE DE EMAIL - MODAL WHATSAPP
 * 
 * Template para notificações do modal WhatsApp
 * Exibe dados do cliente (telefone, nome, CPF, etc.)
 * 
 * @param array $dados Dados do cliente e momento
 * @return array ['subject' => string, 'html' => string, 'text' => string]
 */
function renderEmailTemplateModal($dados) {
    // Preparar dados
    $ddd = $dados['ddd'] ?? '';
    $celular = $dados['celular'] ?? '';
    $telefoneCompleto = !empty($ddd) && !empty($celular)
        ? '(' . $ddd . ') ' . $celular
        : 'Não informado';

    $cpf = $dados['cpf'] ?? 'Não informado';
    $nome = $dados['nome'] ?? 'Não informado';
    $emailCliente = $dados['email'] ?? 'Não informado';
    $cep = $dados['cep'] ?? 'Não informado';
    $placa = $dados['placa'] ?? 'Não informado';
    $gclid = $dados['gclid'] ?? 'Não informado';
    $dataHora = date('d/m/Y H:i:s');

    // Identificadores visuais do momento
    $momento_emoji = $dados['momento_emoji'] ?? '📧';
    $momento_descricao = $dados['momento_descricao'] ?? 'Notificação';
    $momento = $dados['momento'] ?? 'unknown';
    
    // Verificar se há erro
    $temErro = isset($dados['erro']) && $dados['erro'] !== null;
    
    // Lógica condicional: Trocar ❌ por ✅ quando descrição é "Submissão Completa - Todos os Dados"
    $emojiFinal = $momento_emoji;
    if ($momento_descricao === 'Submissão Completa - Todos os Dados' && $momento_emoji === '❌') {
        $emojiFinal = '✅';
    }
    
    // Lógica condicional para o assunto: Trocar ❌ por 📞 (telefone verde) quando descrição é "Submissão Completa - Todos os Dados"
    $emojiAssunto = $momento_emoji;
    if ($momento_descricao === 'Submissão Completa - Todos os Dados' && $momento_emoji === '❌') {
        $emojiAssunto = '📞'; // Telefone verde
    }
    
    // Cor do banner baseada em erro ou momento
    if ($temErro) {
        $bannerColor = '#F44336'; // Vermelho para erro
    } else {
        $bannerColor = ($momento === 'initial') ? '#2196F3' : '#4CAF50'; // Azul para INITIAL, Verde para UPDATE
    }

    // Assunto do email
    $subject = sprintf(
        '%s %s - Modal WhatsApp - %s',
        $emojiAssunto, // Usar $emojiAssunto ao invés de $momento_emoji
        $momento_descricao,
        $telefoneCompleto
    );

    // HTML do email
    $html = '
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
            .container { max-width: 600px; margin: 20px auto; background-color: #ffffff; }
            .header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }
            .header h2 { margin: 0; font-size: 20px; }
            .content { background-color: #f9f9f9; padding: 20px; border-radius: 0 0 5px 5px; }
            .field { margin: 12px 0; padding: 12px; background-color: white; border-left: 4px solid #4CAF50; border-radius: 3px; }
            .label { font-weight: bold; color: #666; display: inline-block; min-width: 100px; }
            .value { color: #333; }
            .footer { margin-top: 20px; padding: 15px; text-align: center; color: #666; font-size: 12px; border-top: 1px solid #ddd; }
            .highlight { background-color: #e8f5e9; padding: 15px; border-radius: 5px; margin: 15px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h2>📱 Novo Contato pelo Formulário do Whatsapp</h2>
            </div>
            <div class="banner" style="background-color: ' . $bannerColor . '; color: white; padding: 15px; text-align: center; font-weight: bold; font-size: 16px; margin-bottom: 20px;">
                ' . $emojiFinal . ' ' . $momento_descricao . '
            </div>
            <div class="content">
                <div class="highlight">
                    <p style="margin: 0; font-weight: bold;">Um cliente preencheu o telefone corretamente no modal WhatsApp.</p>
                </div>
                
                <div class="field">
                    <span class="label">📞 Telefone:</span>
                    <span class="value">' . htmlspecialchars($telefoneCompleto) . '</span>
                </div>
                
                <div class="field">
                    <span class="label">👤 Nome:</span>
                    <span class="value">' . htmlspecialchars($nome) . '</span>
                </div>
                
                <div class="field">
                    <span class="label">🆔 CPF:</span>
                    <span class="value">' . htmlspecialchars($cpf) . '</span>
                </div>
                
                <div class="field">
                    <span class="label">📧 Email:</span>
                    <span class="value">' . htmlspecialchars($emailCliente) . '</span>
                </div>
                
                <div class="field">
                    <span class="label">📍 CEP:</span>
                    <span class="value">' . htmlspecialchars($cep) . '</span>
                </div>
                
                <div class="field">
                    <span class="label">🚗 Placa:</span>
                    <span class="value">' . htmlspecialchars($placa) . '</span>
                </div>
                
                <div class="field">
                    <span class="label">🔗 GCLID:</span>
                    <span class="value">' . htmlspecialchars($gclid) . '</span>
                </div>
                
                ' . ($temErro ? '
                <div class="field" style="background-color: #ffebee; border-left-color: #F44336;">
                    <span class="label" style="color: #F44336; font-weight: bold;">❌ ERRO NO ENVIO:</span>
                    <span class="value" style="color: #F44336;">' . htmlspecialchars($dados['erro']['message'] ?? 'Erro desconhecido') . '</span>
                </div>' . 
                (isset($dados['erro']['status']) && $dados['erro']['status'] !== null ? '
                <div class="field" style="background-color: #ffebee; border-left-color: #F44336;">
                    <span class="label">Status HTTP:</span>
                    <span class="value" style="color: #F44336;">' . htmlspecialchars($dados['erro']['status']) . '</span>
                </div>' : '') .
                (isset($dados['erro']['code']) && $dados['erro']['code'] !== null ? '
                <div class="field" style="background-color: #ffebee; border-left-color: #F44336;">
                    <span class="label">Código:</span>
                    <span class="value" style="color: #F44336;">' . htmlspecialchars($dados['erro']['code']) . '</span>
                </div>' : '') : '') . '
                
                <div class="field">
                    <span class="label">🕐 Data/Hora:</span>
                    <span class="value">' . htmlspecialchars($dataHora) . '</span>
                </div>
            </div>
            <div class="footer">
                <p>Esta é uma notificação automática do sistema BP Seguros Imediato.</p>
                <p>Não responda este email.</p>
            </div>
        </div>
    </body>
    </html>
    ';

    // Texto simples (fallback)
    $text = "
Novo Contato pelo Formulário do Whatsapp
========================================

Um cliente preencheu o telefone corretamente no modal WhatsApp.
" . ($temErro ? "\n⚠️ ERRO: O envio ao EspoCRM falhou!\n" : "") . "

Telefone: {$telefoneCompleto}
Nome: {$nome}
CPF: {$cpf}
Email: {$emailCliente}
CEP: {$cep}
Placa: {$placa}
GCLID: {$gclid}
" . ($temErro ? "ERRO: " . ($dados['erro']['message'] ?? 'Erro desconhecido') . "\n" : "") . "
Data/Hora: {$dataHora}

---
Esta é uma notificação automática do sistema BP Seguros Imediato.
Não responda este email.
    ";

    return [
        'subject' => $subject,
        'html' => $html,
        'text' => $text
    ];
}

