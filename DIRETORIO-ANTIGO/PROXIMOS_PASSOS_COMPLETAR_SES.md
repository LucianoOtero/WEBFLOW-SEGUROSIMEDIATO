# 🚀 PRÓXIMOS PASSOS - COMPLETAR CONFIGURAÇÃO SES

**Status Atual:** ✅ Credenciais AWS obtidas  
**Credenciais:**
- Access Key ID: `[REMOVED_FOR_SECURITY]`
- Secret Access Key: `[REMOVED_FOR_SECURITY]`
- Região: Verificar qual você escolheu no SES (sa-east-1 ou us-east-1)

---

## ⚠️ SEGURANÇA - IMPORTANTE!

### **JÁ FEITO:**
- ✅ Arquivo `aws_ses_config.php` criado com suas credenciais
- ✅ Arquivo `.gitignore` criado (protege credenciais do Git)

### **AÇÃO NECESSÁRIA:**
1. **Verificar região:** No console SES, qual região você escolheu?
   - Se foi **São Paulo** → `sa-east-1`
   - Se foi **N. Virginia** → `us-east-1`
   - **Ajustar** no arquivo `aws_ses_config.php` se necessário

2. **Verificar emails de administradores:**
   - Adicionar todos os emails que devem receber notificações
   - Atualizar array `ADMIN_EMAILS` no arquivo `aws_ses_config.php`

---

## 📋 CHECKLIST DE PRÓXIMOS PASSOS

### **PASSO 1: Verificar Região AWS (1 minuto)**

1. No console AWS SES, verificar qual região está selecionada (canto superior direito)
2. Abrir arquivo: `02-DEVELOPMENT/custom-codes/aws_ses_config.php`
3. Verificar se `AWS_REGION` está correto:
   ```php
   define('AWS_REGION', 'sa-east-1'); // ou 'us-east-1'
   ```

### **PASSO 2: Adicionar Emails de Administradores (2 minutos)**

1. Abrir: `02-DEVELOPMENT/custom-codes/aws_ses_config.php`
2. Atualizar array `ADMIN_EMAILS`:
   ```php
   define('ADMIN_EMAILS', [
       'lrotero@gmail.com', // Já verificado
       'outro-admin@email.com', // Adicionar mais aqui
   ]);
   ```

**⚠️ Lembrete:** Se ainda estiver em sandbox, todos os emails precisam estar verificados no SES.

### **PASSO 3: Instalar AWS SDK no Servidor (5 minutos)**

**Via SSH no servidor:**

```bash
# Conectar ao servidor
ssh root@46.62.174.150

# Navegar para diretório dos webhooks
cd /var/www/html/dev/webhooks

# Verificar se Composer existe
composer --version

# Se não existir, instalar:
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Instalar AWS SDK
composer require aws/aws-sdk-php

# Verificar instalação
php -r "require 'vendor/autoload.php'; echo 'AWS SDK OK!';"
```

### **PASSO 4: Copiar Arquivos para o Servidor (5 minutos)**

**Copiar 3 arquivos:**

```bash
# Arquivo de configuração (com credenciais)
scp "02-DEVELOPMENT/custom-codes/aws_ses_config.php" root@46.62.174.150:/var/www/html/dev/webhooks/aws_ses_config.php

# Arquivo da função de envio
scp "02-DEVELOPMENT/custom-codes/send_admin_notification_ses.php" root@46.62.174.150:/var/www/html/dev/webhooks/send_admin_notification_ses.php

# .gitignore (proteger credenciais)
scp "02-DEVELOPMENT/custom-codes/.gitignore" root@46.62.174.150:/var/www/html/dev/webhooks/.gitignore
```

**Proteger arquivo com credenciais no servidor:**

```bash
ssh root@46.62.174.150
chmod 600 /var/www/html/dev/webhooks/aws_ses_config.php
chown www-data:www-data /var/www/html/dev/webhooks/aws_ses_config.php
```

### **PASSO 5: Testar Envio de Email (5 minutos)**

**Criar arquivo de teste:**

```bash
ssh root@46.62.174.150
cd /var/www/html/dev/webhooks
nano test_ses.php
```

**Conteúdo do teste:**

```php
<?php
require_once 'send_admin_notification_ses.php';

$dados_teste = [
    'ddd' => '11',
    'celular' => '987654321',
    'cpf' => '123.456.789-00',
    'nome' => 'Teste Sistema',
    'email' => 'teste@email.com',
    'cep' => '01234-567',
    'placa' => 'TEST1234',
    'gclid' => 'test-gclid-123',
];

$resultado = enviarNotificacaoAdministradores($dados_teste);

echo "Resultado:\n";
print_r($resultado);

if ($resultado['success']) {
    echo "\n✅ Email enviado com sucesso!\n";
    echo "Verifique a caixa de entrada de " . implode(', ', ADMIN_EMAILS) . "\n";
} else {
    echo "\n❌ Erro ao enviar email:\n";
    echo "Erro: " . ($resultado['error'] ?? 'Desconhecido') . "\n";
}
```

**Executar teste:**

```bash
php test_ses.php
```

**Verificar:**
- ✅ Se sucesso, verificar email dos administradores
- ✅ Se erro, verificar logs e mensagem de erro

### **PASSO 6: Integrar no Webhook (10 minutos)**

**Adicionar no arquivo `add_flyingdonkeys_v2.php`:**

No final do arquivo, após processamento bem-sucedido, adicionar:

```php
// Enviar notificação para administradores quando telefone é validado
if ($telefone_validado && isset($ddd) && isset($celular)) {
    try {
        require_once __DIR__ . '/send_admin_notification_ses.php';
        
        $dados_notificacao = [
            'ddd' => $ddd,
            'celular' => $celular,
            'cpf' => $data['cpf'] ?? null,
            'nome' => $data['nome'] ?? null,
            'email' => $data['email'] ?? null,
            'cep' => $data['cep'] ?? null,
            'placa' => $data['placa'] ?? null,
            'gclid' => $data['gclid'] ?? null,
        ];
        
        // Enviar notificação (não bloquear resposta do webhook)
        $resultado = enviarNotificacaoAdministradores($dados_notificacao);
        
        // Log do resultado
        if ($resultado['success']) {
            error_log("✅ SES: Notificação enviada para administradores - {$resultado['total_sent']} emails enviados");
        } else {
            error_log("⚠️ SES: Erro ao enviar notificação - " . ($resultado['error'] ?? 'Desconhecido'));
        }
        
    } catch (Exception $e) {
        // Não falhar o webhook se email falhar
        error_log("⚠️ SES: Exceção ao enviar notificação - {$e->getMessage()}");
    }
}
```

---

## 🔍 VERIFICAÇÕES IMPORTANTES

### **Verificar Região SES:**

**Pergunta:** Qual região você escolheu no SES?
- [ ] **sa-east-1** (São Paulo) → Atualizar `AWS_REGION` no arquivo
- [ ] **us-east-1** (N. Virginia) → Atualizar `AWS_REGION` no arquivo
- [ ] **Outra** → Qual? Atualizar no arquivo

### **Verificar Sandbox:**

**Pergunta:** Você está ainda no Sandbox Mode?
- [ ] **Sim** → Todos os emails de administradores precisam estar verificados
- [ ] **Não** (já aprovado) → Pode enviar para qualquer email

### **Adicionar Mais Administradores:**

**Ação:** Atualizar `ADMIN_EMAILS` no arquivo `aws_ses_config.php`

---

## 📝 ARQUIVOS CRIADOS

✅ **`aws_ses_config.php`** - Configuração com credenciais (NÃO VERSIONAR!)  
✅ **`aws_ses_config.example.php`** - Exemplo (pode versionar)  
✅ **`send_admin_notification_ses.php`** - Função de envio  
✅ **`.gitignore`** - Protege credenciais do Git  

---

## 🧪 TESTE FINAL

Após completar todos os passos:

1. ✅ Testar envio via `test_ses.php`
2. ✅ Verificar email chegou na caixa de entrada
3. ✅ Verificar HTML renderiza corretamente
4. ✅ Testar integração no webhook (preencher modal → verificar email)

---

## 📞 PRECISA DE AJUDA?

**Se estiver travado:**
1. Me diga qual passo está (1-6)
2. Me diga qual erro aparece (se houver)
3. Compartilhe logs do PHP (se disponível)

---

**Status:** 📋 **Próximos Passos Definidos**  
**Tempo estimado para completar:** 30-45 minutos  
**Dificuldade:** ⭐⭐ Média (maioria é copiar arquivos e testar)


