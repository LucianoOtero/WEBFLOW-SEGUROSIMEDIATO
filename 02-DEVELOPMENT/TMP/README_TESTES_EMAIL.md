# 📧 Guia de Testes - Sistema de Envio de Email

Este documento descreve como executar os testes extensivos do sistema de envio de email via AWS SES.

## 📋 Arquivos de Teste

1. **`test_email_system_completo.php`** - Suíte completa de testes
2. **`test_email_endpoint_http.php`** - Testes específicos do endpoint HTTP

## 🚀 Execução dos Testes

### Teste Completo (Recomendado)

```bash
# Teste completo (sem enviar emails reais)
php test_email_system_completo.php

# Teste completo (ENVIANDO emails reais)
php test_email_system_completo.php --send-email
```

### Testes Específicos

```bash
# Apenas testes de configuração
php test_email_system_completo.php --test=config

# Apenas testes da função
php test_email_system_completo.php --test=function

# Apenas testes do endpoint
php test_email_system_completo.php --test=endpoint

# Apenas testes de integração
php test_email_system_completo.php --test=integration

# Apenas testes de validação
php test_email_system_completo.php --test=validation

# Apenas testes de conectividade AWS
php test_email_system_completo.php --test=connectivity
```

### Teste do Endpoint HTTP

```bash
# Teste sem enviar emails
php test_email_endpoint_http.php

# Teste enviando emails reais
php test_email_endpoint_http.php --send-email
```

## 📊 O que os Testes Verificam

### 1. Testes de Configuração
- ✅ Existência do `vendor/autoload.php`
- ✅ Carregamento do autoloader do Composer
- ✅ Disponibilidade da classe `Aws\Ses\SesClient`
- ✅ Existência e carregamento de `aws_ses_config.php`
- ✅ Credenciais AWS configuradas
- ✅ Configuração de email (remetente, destinatários)
- ✅ Sistema de templates de email

### 2. Testes da Função
- ✅ Variável global `$awsSdkAvailable` definida
- ✅ Criação do cliente SES
- ✅ Renderização de templates de email
- ✅ Estrutura de retorno da função

### 3. Testes do Endpoint
- ✅ Existência do arquivo endpoint
- ✅ Estrutura do código (CORS, validação POST, etc.)
- ✅ Integração com a função de envio

### 4. Testes de Integração
- ✅ Primeiro contato - apenas telefone
- ✅ Primeiro contato - com CPF
- ✅ Notificação de erro do sistema

### 5. Testes de Validação
- ✅ Dados vazios
- ✅ Caracteres especiais (proteção XSS)
- ✅ Dados muito longos

### 6. Testes de Conectividade AWS
- ✅ Criação do cliente SES
- ✅ Verificação de identidade do remetente
- ✅ Verificação de quota de envio

## ⚠️ Importante

### Antes de Executar Testes com Envio Real

1. **Verificar credenciais AWS** em `aws_ses_config.php`
2. **Confirmar emails verificados** no console AWS SES
3. **Verificar quota disponível** (teste 6.3 mostra isso)
4. **Usar ambiente de desenvolvimento** primeiro

### Emails de Teste

Os testes enviam emails para os endereços configurados em `ADMIN_EMAILS`:
- `lrotero@gmail.com`
- `alex.kaminski@imediatoseguros.com.br`
- `alexkaminski70@gmail.com`

## 📈 Interpretando os Resultados

### Taxa de Sucesso

- **≥ 80%**: Sistema funcionando corretamente ✅
- **< 80%**: Investigar erros reportados ⚠️

### Erros Comuns

1. **AWS SDK não instalado**
   - Solução: `composer install` no diretório do projeto

2. **Credenciais não configuradas**
   - Solução: Verificar `aws_ses_config.php`

3. **Email remetente não verificado**
   - Solução: Verificar no console AWS SES

4. **Quota esgotada**
   - Solução: Aguardar ou solicitar aumento de quota

## 🔍 Execução no Servidor

Para executar no servidor de desenvolvimento:

```bash
# Via SSH
ssh root@65.108.156.14

# Dentro do container
docker exec -it webhooks-php-dev sh

# Navegar para o diretório
cd /var/www/html/dev/root

# Executar testes
php test_email_system_completo.php
```

## 📝 Logs

Os testes exibem informações detalhadas sobre:
- Status de cada teste
- Mensagens de erro (se houver)
- Respostas da API AWS
- Estatísticas de envio

## 🎯 Próximos Passos Após Testes

1. Se todos os testes passarem: ✅ Sistema pronto para produção
2. Se houver falhas: Corrigir problemas identificados e reexecutar
3. Monitorar logs do sistema em produção
4. Verificar emails recebidos pelos administradores

## 📞 Suporte

Em caso de problemas:
1. Verificar logs do sistema (`/var/www/html/dev/root/logs/`)
2. Verificar logs do AWS SES no console
3. Revisar configurações em `aws_ses_config.php`
4. Verificar conectividade com AWS (teste 6)

