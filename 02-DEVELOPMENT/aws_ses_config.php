<?php
/**
 * PROJETO: CONFIGURAÇÃO AWS SES PARA NOTIFICAÇÕES ADMINISTRADORES
 * INÍCIO: 03/11/2025
 * 
 * VERSÃO: 1.0 - Configuração real (NÃO VERSIONAR NO GIT!)
 * 
 * ⚠️ SEGURANÇA:
 * - Este arquivo contém credenciais sensíveis
 * - NUNCA commitar no GitHub
 * - Proteger com chmod 600
 */

// ======================
// CREDENCIAIS AWS SES
// ======================
// Prioridade: Variáveis de ambiente > .env.local > valores padrão

// Tentar carregar de .env.local se existir (apenas localmente)
if (file_exists(__DIR__ . '/.env.local')) {
    $envFile = parse_ini_file(__DIR__ . '/.env.local');
    if (isset($envFile['AWS_ACCESS_KEY_ID'])) {
        $_ENV['AWS_ACCESS_KEY_ID'] = $envFile['AWS_ACCESS_KEY_ID'];
    }
    if (isset($envFile['AWS_SECRET_ACCESS_KEY'])) {
        $_ENV['AWS_SECRET_ACCESS_KEY'] = $envFile['AWS_SECRET_ACCESS_KEY'];
    }
    if (isset($envFile['AWS_REGION'])) {
        $_ENV['AWS_REGION'] = $envFile['AWS_REGION'];
    }
}

// Usar variáveis de ambiente se disponíveis, senão usar valores padrão
define('AWS_ACCESS_KEY_ID', $_ENV['AWS_ACCESS_KEY_ID'] ?? '[CONFIGURE_VARIAVEL_AMBIENTE]');
define('AWS_SECRET_ACCESS_KEY', $_ENV['AWS_SECRET_ACCESS_KEY'] ?? '[CONFIGURE_VARIAVEL_AMBIENTE]');
define('AWS_REGION', $_ENV['AWS_REGION'] ?? 'sa-east-1');

// ======================
// CONFIGURAÇÃO DE EMAIL
// ======================

// Email remetente (deve ser do domínio verificado)
define('EMAIL_FROM', 'noreply@bpsegurosimediato.com.br');
define('EMAIL_FROM_NAME', 'BP Seguros Imediato');

// Emails dos administradores (destinatários)
define('ADMIN_EMAILS', [
    'lrotero@gmail.com', // Email já verificado
    'alex.kaminski@imediatoseguros.com.br',
    'alexkaminski70@gmail.com',
]);

