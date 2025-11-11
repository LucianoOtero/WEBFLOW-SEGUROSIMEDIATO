<?php
/**
 * CARREGADOR DE TEMPLATES DE EMAIL
 * 
 * Sistema modular para carregar e renderizar templates de email
 * baseado no contexto dos dados recebidos.
 * 
 * @param array $dados Dados para o template
 * @return array ['subject' => string, 'html' => string, 'text' => string]
 */
function renderEmailTemplate($dados) {
    // Detectar tipo de template
    $templateType = detectTemplateType($dados);
    
    // Carregar template apropriado
    switch ($templateType) {
        case 'logging':
            require_once __DIR__ . '/email_templates/template_logging.php';
            return renderEmailTemplateLogging($dados);
            
        case 'primeiro_contato':
            $templatePrimeiroContatoPath = __DIR__ . '/email_templates/template_primeiro_contato.php';
            if (file_exists($templatePrimeiroContatoPath)) {
                require_once $templatePrimeiroContatoPath;
                return renderEmailTemplatePrimeiroContato($dados);
            } else {
                // Fallback para template modal se template_primeiro_contato não existir
                require_once __DIR__ . '/email_templates/template_modal.php';
                return renderEmailTemplateModal($dados);
            }
            
        case 'modal':
        default:
            require_once __DIR__ . '/email_templates/template_modal.php';
            return renderEmailTemplateModal($dados);
    }
}

/**
 * Detecta o tipo de template baseado nos dados
 * 
 * @param array $dados Dados do email
 * @return string 'logging', 'primeiro_contato' ou 'modal'
 */
function detectTemplateType($dados) {
    // Se há erro com informações técnicas (level, category, file_name) → Template Logging
    if (isset($dados['erro']) && is_array($dados['erro'])) {
        $erro = $dados['erro'];
        if (isset($erro['level']) && isset($erro['category'])) {
            // Verificar se tem informações técnicas (file_name ou stack_trace)
            if (isset($erro['file_name']) || isset($erro['stack_trace']) || isset($erro['line_number'])) {
                return 'logging';
            }
        }
    }
    
    // Se DDD e celular são válidos (não são valores padrão do sistema de logging)
    $ddd = $dados['ddd'] ?? '';
    $celular = $dados['celular'] ?? '';
    
    if ($ddd !== '00' && $celular !== '000000000' && !empty($ddd) && !empty($celular)) {
        // Verificar se é primeiro contato (momento = 'initial' ou 'initial_error')
        $momento = $dados['momento'] ?? '';
        if ($momento === 'initial' || $momento === 'initial_error') {
            return 'primeiro_contato';
        }
        
        // Verificar também pela descrição do momento
        $momento_descricao = $dados['momento_descricao'] ?? '';
        if (stripos($momento_descricao, 'Primeiro Contato') !== false || 
            stripos($momento_descricao, 'Apenas Telefone') !== false) {
            return 'primeiro_contato';
        }
        
        // Verificar se CPF, CEP e PLACA estão vazios (indicando primeiro contato)
        $cpf = $dados['cpf'] ?? '';
        $cep = $dados['cep'] ?? '';
        $placa = $dados['placa'] ?? '';
        
        if (empty($cpf) || $cpf === 'Não informado') {
            if ((empty($cep) || $cep === 'Não informado') && 
                (empty($placa) || $placa === 'Não informado')) {
                return 'primeiro_contato';
            }
        }
        
        // Caso contrário, usar template modal completo
        return 'modal';
    }
    
    // Fallback: Template Modal (compatibilidade)
    return 'modal';
}

/**
 * Valida dados do template
 * 
 * @param string $type Tipo do template ('logging' ou 'modal')
 * @param array $dados Dados a validar
 * @return bool true se válido, false caso contrário
 */
function validateTemplateData($type, $dados) {
    if ($type === 'logging') {
        // Para logging, precisa ter erro com level e category
        return isset($dados['erro']) && 
               is_array($dados['erro']) && 
               isset($dados['erro']['level']) && 
               isset($dados['erro']['category']);
    } else {
        // Para modal, precisa ter DDD e celular válidos
        $ddd = $dados['ddd'] ?? '';
        $celular = $dados['celular'] ?? '';
        return !empty($ddd) && !empty($celular) && 
               $ddd !== '00' && $celular !== '000000000';
    }
}

