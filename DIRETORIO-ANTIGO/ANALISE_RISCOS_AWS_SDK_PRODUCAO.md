# ⚠️ ANÁLISE DE RISCOS - INSTALAR AWS SDK EM PRODUÇÃO

**Data:** 03/11/2025  
**Contexto:** Instalar AWS SDK PHP no servidor de produção para envio de emails via SES  
**Ambiente:** bpsegurosimediato.com.br (Servidor Hetzner)

---

## 🎯 RESUMO EXECUTIVO

### **Risco GERAL:** 🟡 **BAIXO a MÉDIO** (Gerenciável)

**Conclusão:** Instalar AWS SDK é **SEGURO**, mas há cuidados necessários com credenciais.

---

## 📊 ANÁLISE DETALHADA DE RISCOS

### **1. RISCO: Instalar o AWS SDK PHP**

**O que é o AWS SDK:**
- Biblioteca PHP oficial da Amazon
- Apenas código (biblioteca), não é um serviço rodando
- Usado via `require` nos arquivos PHP que precisam

**Riscos Identificados:**

| Risco | Probabilidade | Impacto | Severidade |
|-------|---------------|---------|------------|
| Vulnerabilidade no SDK | 🟢 Baixa | 🟡 Médio | 🟡 BAIXA |
| Conflito com outras bibliotecas | 🟢 Baixa | 🟢 Baixo | 🟢 MUITO BAIXA |
| Aumento de uso de recursos | 🟢 Baixa | 🟢 Baixo | 🟢 MUITO BAIXA |
| Problemas de compatibilidade PHP | 🟡 Média | 🟡 Médio | 🟡 BAIXA |

**Análise:**

✅ **Vulnerabilidades:**
- AWS SDK é mantido pela Amazon com atualizações regulares
- Comunidade grande (milhões de downloads)
- Vulnerabilidades são corrigidas rapidamente
- **Mitigação:** Usar versão estável (`composer require aws/aws-sdk-php` sem versão específica = última estável)

✅ **Conflitos:**
- AWS SDK usa namespaces próprios (`Aws\Ses\SesClient`)
- Baixa probabilidade de conflito
- **Mitigação:** Testar em ambiente de desenvolvimento primeiro

✅ **Recursos:**
- SDK é leve (~5-10MB no disco)
- Carregado apenas quando arquivo PHP é executado
- Não fica rodando em background
- **Mitigação:** Impacto mínimo, apenas quando email é enviado

✅ **Compatibilidade PHP:**
- AWS SDK PHP requer PHP 7.2+ ou 8.0+
- Você tem PHP 8.3 (compatível)
- **Mitigação:** Nenhuma (já compatível)

**Risco REBAIXADO de 🟠 MÉDIO para 🟢 BAIXO**

---

### **2. RISCO: Credenciais AWS no Servidor**

**Risco Identificado:** 🔴 **ALTO** (Se não protegidas adequadamente)

**Cenários de Risco:**

| Cenário | Probabilidade | Impacto | Severidade |
|---------|---------------|---------|------------|
| Credenciais expostas publicamente | 🟡 Média | 🔴 Crítico | 🔴 ALTA |
| Credenciais comprometidas via hack | 🟢 Baixa | 🔴 Crítico | 🟠 ALTA |
| Credenciais acessíveis via web | 🟡 Média | 🔴 Crítico | 🔴 ALTA |
| Credenciais em logs | 🟡 Média | 🔴 Crítico | 🔴 ALTA |

**Análise Detalhada:**

#### **2.1. Exposição Pública de Arquivo**

**Risco:** Arquivo `aws_ses_config.php` acessível via URL HTTP

**Impacto:**
- 🔴 **CRÍTICO:** Qualquer pessoa pode ver credenciais
- 🔴 **CRÍTICO:** Pode usar credenciais para enviar spam
- 🔴 **CRÍTICO:** Custos na conta AWS
- 🔴 **CRÍTICO:** Blacklist do domínio

**Probabilidade:**
- 🟡 **MÉDIA:** Se arquivo estiver em diretório web-accessible
- 🟢 **BAIXA:** Se arquivo estiver fora de `/var/www/html` ou com proteção

**Mitigação:**
1. ✅ **Colocar arquivo FORA de diretório web:**
   ```bash
   /var/www/.aws_config/aws_ses_config.php  # ✅ Seguro
   /var/www/html/webhooks/aws_ses_config.php # ❌ Arriscado
   ```

2. ✅ **OU usar proteção .htaccess (se Apache):**
   ```apache
   <Files "aws_ses_config.php">
       Order Allow,Deny
       Deny from all
   </Files>
   ```

3. ✅ **OU proteger via Nginx:**
   ```nginx
   location ~ aws_ses_config\.php$ {
       deny all;
       return 404;
   }
   ```

4. ✅ **Verificar acesso:**
   - Tentar acessar: `https://bpsegurosimediato.com.br/webhooks/aws_ses_config.php`
   - Deve retornar 404 ou erro, NUNCA mostrar conteúdo

#### **2.2. Comprometimento do Servidor**

**Risco:** Se servidor for hackeado, credenciais podem ser roubadas

**Impacto:**
- 🔴 **CRÍTICO:** Mesmo que acima
- Adicionalmente: Acesso à conta AWS pode ser explorado

**Probabilidade:**
- 🟢 **BAIXA:** Se servidor está bem protegido
- Depende de segurança geral do servidor

**Mitigação:**
1. ✅ **Permissões restritas:**
   ```bash
   chmod 600 aws_ses_config.php  # Apenas owner pode ler/escrever
   chown www-data:www-data aws_ses_config.php  # Proprietário correto
   ```

2. ✅ **Usar IAM com permissões mínimas:**
   - Criar política IAM que permite APENAS SES (não EC2, S3, etc.)
   - Limitar a região específica (sa-east-1)
   - Limitar a ações específicas (apenas sendEmail)

3. ✅ **Monitorar uso de credenciais:**
   - CloudWatch logs do SES
   - Alertas se uso anormal
   - Revisar logs regularmente

#### **2.3. Credenciais em Logs**

**Risco:** Credenciais aparecem em logs de erro PHP

**Impacto:**
- 🔴 **CRÍTICO:** Se logs forem acessíveis ou compartilhados
- Logs podem ser expostos acidentalmente

**Probabilidade:**
- 🟡 **MÉDIA:** Se código faz `var_dump()` ou `print_r()` de variáveis com credenciais

**Mitigação:**
1. ✅ **NUNCA fazer debug com credenciais:**
   ```php
   // ❌ ERRADO:
   var_dump(AWS_SECRET_ACCESS_KEY);
   error_log(AWS_SECRET_ACCESS_KEY);
   
   // ✅ CORRETO:
   error_log('AWS SES configurado'); // Sem mostrar credenciais
   ```

2. ✅ **Proteger arquivos de log:**
   - Logs fora de diretório web
   - Permissões restritas (chmod 600)

3. ✅ **Usar variáveis de ambiente:**
   - Carregar de `.env` que não é versionado
   - PHP não mostra variáveis de ambiente em erros

#### **2.4. Credenciais no Git/GitHub**

**Risco:** Credenciais commitadas acidentalmente

**Impacto:**
- 🔴 **CRÍTICO:** Se repositório for público, credenciais expostas
- 🔴 **CRÍTICO:** Mesmo em repositórios privados, é má prática

**Probabilidade:**
- 🟡 **MÉDIA:** Se desenvolvedor não for cuidadoso

**Mitigação:**
1. ✅ **`.gitignore` já criado:**
   ```
   aws_ses_config.php
   *.env
   ```

2. ✅ **Usar arquivo de exemplo:**
   - `aws_ses_config.example.php` (versionado, sem credenciais)
   - `aws_ses_config.php` (não versionado, com credenciais)

3. ✅ **Verificar antes de commit:**
   ```bash
   git status
   # Verificar se aws_ses_config.php não aparece
   ```

4. ✅ **Se já commitou por engano:**
   - Deletar credenciais do histórico Git
   - Criar novas credenciais no IAM (invalidar antigas)
   - Usar `git-filter-repo` ou similar

---

### **3. RISCO: Permissões IAM Excessivas**

**Risco:** Usuário IAM com permissões muito amplas

**Análise:**
- Você criou usuário com `AmazonSESFullAccess`
- Isso dá acesso TOTAL ao SES (não apenas envio)

**Impacto:**
- 🟠 **ALTO:** Se credenciais forem comprometidas, podem:
  - Modificar configurações do SES
  - Verificar/deletar identidades
  - Alterar quotas
  - Mas **NÃO** pode acessar outros serviços AWS (EC2, S3, etc.)

**Mitigação:**
1. ✅ **Criar Política Customizada (Recomendado):**
   - Permissão APENAS para `ses:SendEmail`
   - Limitar a região `sa-east-1`
   - Limitar a identidade verificada

**Política IAM Mais Restritiva:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": [
                "arn:aws:ses:sa-east-1:*:identity/bpsegurosimediato.com.br"
            ]
        }
    ]
}
```

---

### **4. RISCO: Impacto no Servidor Existente**

**Análise:**
- AWS SDK é apenas biblioteca PHP
- Não é serviço rodando em background
- Carregado apenas quando necessário

**Impacto:**
- 🟢 **BAIXO:** Impacto mínimo no servidor
- 🟢 **BAIXO:** Não interfere com serviços existentes (RPA, Nginx, etc.)

**Risco:** 🟢 **MUITO BAIXO**

---

## 🛡️ PLANO DE MITIGAÇÃO RECOMENDADO

### **FASE 1: Antes de Instalar (Bloqueadores)**

#### **1.1. Criar Política IAM Restritiva (15 minutos)**

**Recomendação:** Substituir `AmazonSESFullAccess` por política customizada

1. Console IAM → **Policies** → **Create policy**
2. Escolher **JSON**
3. Cole a política restritiva (acima)
4. Nome: `SES-SendEmail-Only-bpsegurosimediato`
5. Criar policy

6. Usuário `ses-email-sender` → **Permissions** → **Detach policy** (`AmazonSESFullAccess`)
7. **Attach policy** → Selecionar política customizada criada

**Benefício:** Se credenciais forem comprometidas, dano limitado ao SES apenas.

#### **1.2. Verificar Estrutura de Diretórios**

**Arquivo deve estar:**
```bash
# ✅ Opção 1: Fora de diretório web
/var/www/.aws_config/aws_ses_config.php

# ✅ Opção 2: No diretório webhooks MAS protegido
/var/www/html/dev/webhooks/aws_ses_config.php
# + Proteção Nginx/Apache
```

---

### **FASE 2: Durante Instalação**

#### **2.1. Instalar AWS SDK**

```bash
cd /var/www/html/dev/webhooks
composer require aws/aws-sdk-php
```

**Riscos:** 🟢 Muito baixo (apenas baixa biblioteca)

#### **2.2. Copiar Arquivo de Configuração**

```bash
# Copiar para local seguro
cp aws_ses_config.php /var/www/.aws_config/aws_ses_config.php
# OU manter em webhooks mas proteger

# Proteger arquivo
chmod 600 /var/www/.aws_config/aws_ses_config.php
chown www-data:www-data /var/www/.aws_config/aws_ses_config.php
```

#### **2.3. Atualizar Código para Usar Caminho Seguro**

Em `send_admin_notification_ses.php`:
```php
// Se arquivo estiver fora de webhooks:
require_once '/var/www/.aws_config/aws_ses_config.php';
```

---

### **FASE 3: Após Instalação (Validações)**

#### **3.1. Testar Acesso Público**

```bash
# Testar se arquivo é acessível via HTTP
curl https://dev.bpsegurosimediato.com.br/webhooks/aws_ses_config.php

# Deve retornar 404 ou 403, NUNCA o conteúdo
```

#### **3.2. Verificar Permissões**

```bash
ls -la /var/www/.aws_config/aws_ses_config.php
# Deve mostrar: -rw------- (600) e owner correto
```

#### **3.3. Testar Envio**

```bash
php test_ses.php
# Verificar se funciona e se logs não expõem credenciais
```

#### **3.4. Configurar Monitoramento**

**No console AWS SES:**
- Habilitar CloudWatch metrics
- Configurar alertas se:
  - Volume de emails > 100/dia (suspicious)
  - Taxa de bounce > 10%
  - Taxa de spam complaints > 1%

---

## ✅ CHECKLIST DE SEGURANÇA

### **Antes de Instalar:**
- [ ] Política IAM restritiva criada (não usar FullAccess)
- [ ] Local seguro para arquivo de configuração definido
- [ ] Proteção Nginx/Apache planejada (se arquivo em diretório web)

### **Durante Instalação:**
- [ ] AWS SDK instalado via Composer
- [ ] Arquivo de configuração copiado para local seguro
- [ ] Permissões restritas aplicadas (chmod 600)
- [ ] Owner correto (www-data:www-data)

### **Após Instalação:**
- [ ] Testado acesso público (deve retornar 404/403)
- [ ] Testado envio de email (funciona?)
- [ ] Verificado logs (sem credenciais expostas)
- [ ] CloudWatch metrics configurado
- [ ] Alertas configurados

### **Contínuo:**
- [ ] Revisar logs de uso do SES mensalmente
- [ ] Verificar custos AWS mensalmente
- [ ] Rotacionar credenciais anualmente (ou se suspeita de comprometimento)
- [ ] Manter AWS SDK atualizado (`composer update aws/aws-sdk-php`)

---

## 📊 MATRIZ DE RISCOS FINAL

| Risco | Probabilidade | Impacto | Severidade | Mitigação |
|-------|---------------|---------|------------|-----------|
| Vulnerabilidade no SDK | 🟢 Baixa | 🟡 Médio | 🟡 BAIXA | Manter atualizado |
| Exposição pública de credenciais | 🟡 Média | 🔴 Crítico | 🔴 ALTA | Arquivo fora de web + proteção |
| Comprometimento servidor | 🟢 Baixa | 🔴 Crítico | 🟠 ALTA | Permissões IAM restritivas |
| Credenciais em logs | 🟡 Média | 🔴 Crítico | 🔴 ALTA | Não logar credenciais |
| Credenciais no Git | 🟡 Média | 🔴 Crítico | 🔴 ALTA | .gitignore + exemplo |
| Permissões IAM excessivas | 🟡 Média | 🟠 Alto | 🟡 MÉDIA | Política customizada |
| Impacto no servidor | 🟢 Baixa | 🟢 Baixo | 🟢 MUITO BAIXA | Nenhuma |

---

## 💡 RECOMENDAÇÕES FINAIS

### **✅ PODE INSTALAR, MAS:**

1. **OBRIGATÓRIO (Bloqueadores):**
   - ✅ Criar política IAM restritiva (antes de instalar)
   - ✅ Proteger arquivo de configuração (fora de web OU com proteção)
   - ✅ Aplicar permissões restritas (chmod 600)

2. **RECOMENDADO (Alto):**
   - ✅ Testar acesso público após instalação
   - ✅ Configurar monitoramento CloudWatch
   - ✅ Revisar logs regularmente

3. **OPCIONAL (Médio):**
   - ✅ Rotacionar credenciais periodicamente
   - ✅ Manter SDK atualizado

### **🎯 CONCLUSÃO:**

**Risco é BAIXO a MÉDIO e GERENCIÁVEL** se:
- ✅ Política IAM restritiva for usada
- ✅ Arquivo de configuração for protegido adequadamente
- ✅ Boas práticas de segurança forem seguidas

**NÃO instalar se:**
- ❌ Não pode proteger arquivo de configuração adequadamente
- ❌ Não pode criar política IAM restritiva
- ❌ Servidor está comprometido ou inseguro

---

## 🔄 ALTERNATIVAS SE RISCO FOR MUITO ALTO

Se considerar o risco muito alto, alternativas:

### **Opção 1: Serviço Gerenciado (SendGrid, Mailgun)**
- ✅ Mais simples
- ✅ Credenciais via API key (mais seguro que IAM)
- ✅ Mesmo custo (R$ 0 para volume baixo)

### **Opção 2: Webhook para Serviço Terceiro**
- ✅ Zapier/Make.com (tem planos gratuitos)
- ✅ Integração via webhook (sem credenciais no servidor)
- ✅ Mais seguro (credenciais ficam no serviço terceiro)

### **Opção 3: Email via SMTP Tradicional**
- ✅ Servidor SMTP próprio ou gerenciado
- ✅ Credenciais SMTP (senha) ao invés de IAM
- ✅ Mais familiar para equipe

---

**Status:** 📋 **Análise Completa de Riscos**  
**Recomendação:** ✅ **Pode instalar com as devidas proteções**  
**Próxima Ação:** Criar política IAM restritiva e proteger arquivo antes de instalar


