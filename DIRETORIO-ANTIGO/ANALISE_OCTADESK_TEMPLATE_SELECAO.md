# 🔍 ANÁLISE: SELEÇÃO DE TEMPLATE NA API DO OCTADESK

## DATA DA ANÁLISE
02/11/2025

## OBJETIVO
Verificar se é possível escolher dinamicamente qual mensagem/template será enviado ao cliente na chamada da API do OctaDesk.

---

## ESTRUTURA ATUAL DO CÓDIGO

### Arquivo: `add_webflow_octa_v2.php` (Linha 205-214)

```php
'content' => [
    'templateMessage' => [
        'code' => 'site_cotacao',        // ⚠️ HARDCODED - Template fixo
        'language' => 'pt_BR',
        'components' => [[
            'type' => 'body',
            'parameters' => [[ 
                'type' => 'text', 
                'text' => ($nome !== '' ? $nome : 'cliente') 
            ]]
        ]]
    ]
]
```

---

## ANÁLISE DA DOCUMENTAÇÃO

### 1. PARÂMETRO `code` NO PAYLOAD

O campo `code` dentro de `templateMessage` é usado para especificar qual template do WhatsApp Business será utilizado.

**Estrutura da API:**
```
POST /chat/conversation/send-template

{
    "content": {
        "templateMessage": {
            "code": "NOME_DO_TEMPLATE",    // ✅ ESTE CAMPO PODE SER VARIÁVEL
            "language": "pt_BR",
            "components": [...]
        }
    }
}
```

### 2. CONCLUSÃO TÉCNICA

**✅ SIM, É POSSÍVEL ESCOLHER O TEMPLATE DINAMICAMENTE**

O campo `code` no payload pode receber qualquer string que corresponda a um template aprovado no WhatsApp Business da conta OctaDesk.

---

## COMO IMPLEMENTAR SELEÇÃO DINÂMICA

### Opção 1: Baseado em Campo do Formulário

Se o formulário enviar um campo indicando qual template usar:

```php
// No mapeamento de dados
$templateCode = $formData['TEMPLATE_CHOICE'] ?? 'site_cotacao'; // Default

// No payload
'templateMessage' => [
    'code' => $templateCode,  // ✅ Dinâmico baseado no formulário
    'language' => 'pt_BR',
    ...
]
```

### Opção 2: Baseado em Regra de Negócio

```php
// Lógica para escolher template baseado em condições
$templateCode = 'site_cotacao'; // Default

if ($produto === 'seguro-residencial') {
    $templateCode = 'site_cotacao_residencial';
} else if ($produto === 'seguro-vida') {
    $templateCode = 'site_cotacao_vida';
} else if (isset($formData['origem']) && $formData['origem'] === 'landing_especial') {
    $templateCode = 'site_cotacao_promocional';
}

'templateMessage' => [
    'code' => $templateCode,  // ✅ Seleção dinâmica
    ...
]
```

### Opção 3: Baseado em Metadata/Campaign

```php
$templateCode = 'site_cotacao'; // Default

// Escolher template baseado em UTM campaign
if ($utmCampaign === 'promocao_natal') {
    $templateCode = 'site_cotacao_natal';
} else if ($utmCampaign === 'black_friday') {
    $templateCode = 'site_cotacao_blackfriday';
}

'templateMessage' => [
    'code' => $templateCode,  // ✅ Seleção dinâmica baseada em campanha
    ...
]
```

---

## REQUISITOS PARA FUNCIONAR

### 1. Templates Devem Estar Aprovados no WhatsApp Business
- O template precisa estar criado e aprovado no WhatsApp Business da conta OctaDesk
- O código do template deve corresponder exatamente ao código configurado no WhatsApp Business

### 2. Idioma (Language)
- O template deve estar disponível no idioma especificado (`pt_BR`)
- Se o template existir apenas em outro idioma, usar o código correspondente

### 3. Componentes (Components)
- Os componentes do payload devem corresponder aos parâmetros esperados pelo template
- Cada template pode ter estrutura diferente de componentes

---

## EXEMPLO DE IMPLEMENTAÇÃO COMPLETA

```php
function sendToOctaDesk($data)
{
    // ... código de validação de telefone ...
    
    // ✅ SELEÇÃO DINÂMICA DO TEMPLATE
    $templateCode = $data['custom_fields']['template_code'] ?? 'site_cotacao';
    
    // Validação: garantir que template existe (lista de templates permitidos)
    $allowedTemplates = [
        'site_cotacao',
        'site_cotacao_residencial',
        'site_cotacao_vida',
        'site_cotacao_promocional'
    ];
    
    if (!in_array($templateCode, $allowedTemplates)) {
        $templateCode = 'site_cotacao'; // Fallback para default
    }
    
    // Preparar componentes baseado no template escolhido
    $components = [];
    
    if ($templateCode === 'site_cotacao') {
        // Template padrão - usa nome do cliente
        $components = [[
            'type' => 'body',
            'parameters' => [[ 
                'type' => 'text', 
                'text' => ($nome !== '' ? $nome : 'cliente') 
            ]]
        ]];
    } else if ($templateCode === 'site_cotacao_promocional') {
        // Template promocional - pode ter parâmetros diferentes
        $components = [[
            'type' => 'body',
            'parameters' => [
                ['type' => 'text', 'text' => ($nome !== '' ? $nome : 'cliente')],
                ['type' => 'text', 'text' => $data['custom_fields']['produto'] ?? 'seguro-auto']
            ]
        ]];
    }
    
    $payloadSend = [
        'target' => [
            'contact' => [
                'name' => ($nome !== '' ? $nome : 'Cliente'),
                'email' => ($email ?: null),
                'phoneContact' => ['number' => $foneE164],
            ],
            // ... outros campos ...
        ],
        'content' => [
            'templateMessage' => [
                'code' => $templateCode,  // ✅ TEMPLATE DINÂMICO
                'language' => 'pt_BR',
                'components' => $components  // ✅ COMPONENTES DINÂMICOS
            ]
        ],
        // ... resto do payload ...
    ];
    
    // ... enviar requisição ...
}
```

---

## CONSIDERAÇÕES IMPORTANTES

### 1. Validação de Templates
- Implementar lista de templates permitidos para segurança
- Validar se o template existe antes de enviar
- Ter fallback para template padrão

### 2. Logging
- Registrar qual template foi usado para cada envio
- Facilitar debugging e análise

### 3. Componentes Dinâmicos
- Cada template pode exigir componentes diferentes
- Parâmetros podem variar entre templates
- Necessário mapear cada template para seus componentes específicos

### 4. Testes
- Testar com diferentes templates
- Validar que todos os templates estão aprovados no WhatsApp Business
- Verificar que componentes correspondem aos templates

---

## CONCLUSÃO

**✅ SIM, É POSSÍVEL ESCOLHER O TEMPLATE DINAMICAMENTE**

O campo `code` no payload `templateMessage` pode ser uma variável PHP que recebe o código do template desejado.

**Recomendações:**
1. Implementar validação de templates permitidos
2. Criar mapeamento de templates para componentes
3. Adicionar campo opcional no formulário para escolha do template
4. Manter template padrão como fallback
5. Registrar qual template foi usado nos logs

**Próximos Passos:**
- Definir quais templates serão criados no WhatsApp Business
- Mapear regras de negócio para escolha de template
- Implementar validação e fallback
- Testar com diferentes templates



