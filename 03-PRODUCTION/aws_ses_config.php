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

// Incluir config.php para usar funções helper
require_once __DIR__ . '/config.php';

// Usar funções helper do config.php (sem fallbacks)
define('AWS_ACCESS_KEY_ID', getAwsAccessKeyId());
define('AWS_SECRET_ACCESS_KEY', getAwsSecretAccessKey());
define('AWS_REGION', getAwsRegion());

// ======================
// CONFIGURAÇÃO DE EMAIL
// ======================

// Email remetente (usando variáveis de ambiente)
define('EMAIL_FROM', getAwsSesFromEmail());
define('EMAIL_FROM_NAME', getAwsSesFromName());

// Emails dos administradores (usando variáveis de ambiente)
define('ADMIN_EMAILS', getAwsSesAdminEmails());

