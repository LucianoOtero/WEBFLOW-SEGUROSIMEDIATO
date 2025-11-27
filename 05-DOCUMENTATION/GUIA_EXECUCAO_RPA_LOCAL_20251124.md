# Guia: Executar RPA Localmente - Windows

**Data:** 24/11/2025  
**Ambiente:** Windows Local  
**Objetivo:** Executar o RPA de cotação de seguros localmente para testes e desenvolvimento

---

## 📋 RESUMO EXECUTIVO

### **Como Executar:**
1. ✅ **Preparar arquivo `parametros.json`** com dados da cotação
2. ✅ **Executar script Python** com JSON como parâmetro
3. ✅ **Aguardar conclusão** da execução (2-3 minutos)

### **Formas de Execução:**
- **Opção 1:** JSON direto na linha de comando
- **Opção 2:** JSON de arquivo via pipe
- **Opção 3:** JSON de arquivo via redirecionamento

---

## 🚀 FORMAS DE EXECUÇÃO

### **Opção 1: JSON Direto na Linha de Comando (Recomendado para Testes Rápidos)**

```powershell
python executar_rpa_imediato.py '{"configuracao": {"tempo_estabilizacao": 1, "tempo_carregamento": 10}, "url_base": "https://www.app.tosegurado.com.br/imediatoseguros", "placa": "FGV2J21", "marca": "RENAULT", "modelo": "KWID ZEN 2", "ano": "2022", "combustivel": "Flex", "veiculo_segurado": "Não", "cep": "04150-060", "endereco_completo": "Rua Serra de Botucatu, 410 APTO 11 - São Paulo, SP", "uso_veiculo": "Pessoal", "nome": "DERMIVAL PANSERA", "cpf": "00381360822", "data_nascimento": "20/10/1992", "sexo": "Masculino", "estado_civil": "Casado", "email": "drpansera@uol.com.br", "celular": "11976389614"}'
```

**Vantagens:**
- ✅ Rápido para testes
- ✅ Não precisa criar arquivo
- ✅ Útil para testes pontuais

**Desvantagens:**
- ⚠️ Comando muito longo
- ⚠️ Difícil de editar

---

### **Opção 2: JSON de Arquivo via Pipe (Recomendado)**

```powershell
type parametros.json | python executar_rpa_imediato.py -
```

**Vantagens:**
- ✅ Fácil de editar (editar `parametros.json`)
- ✅ Reutilizável
- ✅ Padrão do projeto

**Desvantagens:**
- ⚠️ Precisa criar/editar arquivo

---

### **Opção 3: JSON de Arquivo via Redirecionamento**

```powershell
python executar_rpa_imediato.py - < parametros.json
```

**Vantagens:**
- ✅ Similar à Opção 2
- ✅ Funciona em diferentes shells

---

## 📄 CONTEÚDO ATUAL DO `parametros.json`

### **Arquivo:** `parametros.json` (raiz do projeto)

```json
{
  "configuracao": {
    "log": true,
    "display": true,
    "log_rotacao_dias": 90,
    "log_nivel": "INFO",
    "tempo_estabilizacao": 0.5,
    "tempo_carregamento": 0.5,
    "tempo_estabilizacao_tela5": 2,
    "tempo_carregamento_tela5": 5,
    "tempo_estabilizacao_tela15": 3,
    "tempo_carregamento_tela15": 5,
    "inserir_log": true,
    "visualizar_mensagens": true,
    "eliminar_tentativas_inuteis": true,
    "modo_silencioso": false
  },
  "autenticacao": {
    "email_login": "aleximediatoseguros@gmail.com",
    "senha_login": "Lrotero1$",
    "manter_login_atual": true
  },
  "url": "https://www.app.tosegurado.com.br/imediatosolucoes",
  "tipo_veiculo": "carro",
  "placa": "FGV2J21",
  "marca": "RENAULT",
  "modelo": "KWID ZEN 2",
  "ano": "2022",
  "zero_km": false,
  "combustivel": "Flex",
  "veiculo_segurado": "Não",
  "cep": "04150-060",
  "endereco_completo": "Rua Serra de Botucatu, 410 APTO 11 - São Paulo, SP",
  "uso_veiculo": "Pessoal",
  "nome": "DERMIVAL PANSERA",
  "cpf": "00381360822",
  "data_nascimento": "20/10/1992",
  "sexo": "Masculino",
  "estado_civil": "Casado",
  "email": "drpansera@uol.com.br",
  "celular": "11976389614",
  "endereco": "Rua Serra de Botucatu, Tatuapé - São Paulo/SP",
  "condutor_principal": true,
  "nome_condutor": "SANDRA LOUREIRO",
  "cpf_condutor": "25151787829",
  "data_nascimento_condutor": "28/08/1975",
  "sexo_condutor": "Feminino",
  "estado_civil_condutor": "Casado ou Uniao Estavel",
  "local_de_trabalho": false,
  "estacionamento_proprio_local_de_trabalho": false,
  "local_de_estudo": false,
  "estacionamento_proprio_local_de_estudo": false,
  "garagem_residencia": true,
  "portao_eletronico": "Eletronico",
  "reside_18_26": "Não",
  "sexo_do_menor": "N/A",
  "faixa_etaria_menor_mais_novo": "N/A",
  "kit_gas": false,
  "blindado": false,
  "financiado": false,
  "continuar_com_corretor_anterior": true
}
```

---

## 📊 ESTRUTURA DO JSON DE PARÂMETROS

### **1. Seção: `configuracao`**
- **`log`:** Ativa/desativa logs (true/false)
- **`display`:** Exibe mensagens no terminal (true/false)
- **`log_rotacao_dias`:** Dias para rotação de logs (90)
- **`log_nivel`:** Nível de log ("INFO", "DEBUG", "WARNING", "ERROR")
- **`tempo_estabilizacao`:** Tempo de espera geral (0.5 segundos)
- **`tempo_carregamento`:** Timeout para carregamento (0.5 segundos)
- **`tempo_estabilizacao_tela5`:** Tempo específico Tela 5 (2 segundos)
- **`tempo_carregamento_tela5`:** Carregamento específico Tela 5 (5 segundos)
- **`tempo_estabilizacao_tela15`:** Tempo específico Tela 15 (3 segundos)
- **`tempo_carregamento_tela15`:** Carregamento específico Tela 15 (5 segundos)
- **`inserir_log`:** Insere logs no arquivo (true/false)
- **`visualizar_mensagens`:** Exibe mensagens detalhadas (true/false)
- **`eliminar_tentativas_inuteis`:** Otimiza execução (true/false)
- **`modo_silencioso`:** Execução silenciosa (true/false)

### **2. Seção: `autenticacao`**
- **`email_login`:** Email para login no sistema
- **`senha_login`:** Senha para login no sistema
- **`manter_login_atual`:** Manter sessão ativa (true/false)

### **3. Dados do Veículo:**
- **`url`:** URL base do portal Tô Segurado
- **`tipo_veiculo`:** Tipo de veículo ("carro", "moto")
- **`placa`:** Placa do veículo (formato: ABC1234)
- **`marca`:** Marca do veículo
- **`modelo`:** Modelo do veículo
- **`ano`:** Ano de fabricação
- **`zero_km`:** Veículo zero quilômetro (true/false)
- **`combustivel`:** Tipo de combustível ("Flex", "Gasolina", "Álcool", "Diesel", "Híbrido", "Elétrico")
- **`veiculo_segurado`:** Veículo já possui seguro ("Sim", "Não")

### **4. Dados de Endereço:**
- **`cep`:** CEP do endereço (formato: XXXXX-XXX)
- **`endereco_completo`:** Endereço completo
- **`endereco`:** Endereço simplificado

### **5. Uso do Veículo:**
- **`uso_veiculo`:** Finalidade do uso ("Pessoal", "Profissional", "Motorista de aplicativo", "Taxi")

### **6. Dados Pessoais:**
- **`nome`:** Nome completo do segurado
- **`cpf`:** CPF do segurado (formato: 11 dígitos)
- **`data_nascimento`:** Data de nascimento (formato: DD/MM/AAAA)
- **`sexo`:** Sexo ("Masculino", "Feminino")
- **`estado_civil`:** Estado civil ("Solteiro", "Casado", "Divorciado", "Separado", "Viúvo", "Casado ou Uniao Estavel")
- **`email`:** Email do segurado
- **`celular`:** Celular do segurado (formato: 11 dígitos)

### **7. Dados do Condutor (Opcional):**
- **`condutor_principal`:** Condutor é o principal (true/false)
- **`nome_condutor`:** Nome do condutor (obrigatório se condutor_principal = false)
- **`cpf_condutor`:** CPF do condutor (obrigatório se condutor_principal = false)
- **`data_nascimento_condutor`:** Data de nascimento do condutor (obrigatório se condutor_principal = false)
- **`sexo_condutor`:** Sexo do condutor (obrigatório se condutor_principal = false)
- **`estado_civil_condutor`:** Estado civil do condutor (obrigatório se condutor_principal = false)

### **8. Atividade do Veículo:**
- **`local_de_trabalho`:** Veículo usado para ir ao trabalho (true/false)
- **`estacionamento_proprio_local_de_trabalho`:** Estacionamento próprio no trabalho (true/false)
- **`local_de_estudo`:** Veículo usado para ir ao estudo (true/false)
- **`estacionamento_proprio_local_de_estudo`:** Estacionamento próprio no estudo (true/false)

### **9. Garagem na Residência:**
- **`garagem_residencia`:** Possui garagem na residência (true/false)
- **`portao_eletronico`:** Tipo de portão ("Eletronico", "Manual", "Não possui")

### **10. Uso por Residentes:**
- **`reside_18_26`:** Reside com alguém entre 18-26 anos ("Sim", "Não")
- **`sexo_do_menor`:** Sexo do menor ("Masculino", "Feminino", "N/A")
- **`faixa_etaria_menor_mais_novo`:** Faixa etária do menor ("18-21", "22-26", "N/A")

### **11. Características Especiais do Veículo:**
- **`kit_gas`:** Veículo possui kit gás (true/false)
- **`blindado`:** Veículo é blindado (true/false)
- **`financiado`:** Veículo é financiado (true/false)
- **`continuar_com_corretor_anterior`:** Continuar com corretor anterior (true/false)

---

## ✅ COMANDO RECOMENDADO PARA EXECUÇÃO LOCAL

### **Comando Completo:**
```powershell
type parametros.json | python executar_rpa_imediato.py -
```

### **Ou usando redirecionamento:**
```powershell
python executar_rpa_imediato.py - < parametros.json
```

---

## 📝 VALIDAÇÕES AUTOMÁTICAS

O sistema valida automaticamente:
- ✅ **Campos obrigatórios** - Todos os campos obrigatórios devem estar presentes
- ✅ **Formatos corretos** - CPF, CEP, email, celular, data de nascimento
- ✅ **Valores aceitos** - Sexo, estado civil, combustível, uso do veículo
- ✅ **Validação condicional** - Campos do condutor quando condutor_principal = false
- ✅ **Tipos de dados** - String, boolean, integer conforme esperado

---

## 🎯 RESULTADO ESPERADO

### **Sucesso:**
- ✅ Todas as telas executadas com sucesso
- ✅ Cotação de seguro auto completa
- ✅ Tempo total: ~2-3 minutos
- ✅ Arquivos gerados em `temp/tela_XX/` para cada tela

### **Arquivos Gerados:**
- 📁 `temp/tela_XX/` - Diretórios para cada tela
- 📄 HTML, screenshots e logs de cada etapa
- 📊 JSON com dados finais da cotação

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### **Scripts Disponíveis:**
- ✅ `executar_rpa_imediato.py` - Script principal (recebe JSON diretamente)
- ✅ `executar_rpa_json_direto.py` - Versão alternativa
- ✅ `executar_rpa_imediato_playwright.py` - Versão com Playwright

### **Formato de CPF:**
- ✅ **Aceita:** `00381360822` (11 dígitos sem formatação)
- ✅ **Aceita:** `003.813.608-22` (com formatação)
- ⚠️ **Importante:** O script aceita ambos os formatos

### **Formato de Celular:**
- ✅ **Aceita:** `11976389614` (11 dígitos sem formatação)
- ✅ **Aceita:** `(11) 97638-9614` (com formatação)
- ⚠️ **Importante:** O script aceita ambos os formatos

---

## 📚 DOCUMENTAÇÃO RELACIONADA

- 📄 `PARAMETROS_JSON_COMPLETO.md` - Documentação completa de todos os parâmetros
- 📄 `DOCUMENTACAO_COMPLETA_RPA.md` - Documentação completa do RPA
- 📄 `parametros.json` - Arquivo de exemplo atual

---

## 🔧 TROUBLESHOOTING

### **Erro: "Campo obrigatório não encontrado"**
- ✅ Verificar se todos os campos obrigatórios estão presentes no JSON
- ✅ Verificar se os campos não estão vazios

### **Erro: "JSON inválido"**
- ✅ Validar sintaxe JSON (usar validador online)
- ✅ Verificar aspas e vírgulas

### **Erro: "Formato inválido"**
- ✅ Verificar formato de CPF, CEP, email, celular
- ✅ Consultar `PARAMETROS_JSON_COMPLETO.md` para formatos corretos

---

**Documento criado em:** 24/11/2025  
**Última atualização:** 24/11/2025 22:15  
**Status:** ✅ **GUIA PRÁTICO** - Execução RPA Local






