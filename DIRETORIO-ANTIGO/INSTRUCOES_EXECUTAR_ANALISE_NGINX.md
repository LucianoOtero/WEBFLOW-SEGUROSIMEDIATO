# INSTRUÇÕES: EXECUÇÃO DO SCRIPT DE ANÁLISE NGINX

## Objetivo
Analisar profundamente a configuração do Nginx e ambiente web do `bpsegurosimediato.com.br` para descobrir por que os arquivos JavaScript não estão acessíveis em produção.

## Pré-requisitos
- Acesso SSH ao servidor de produção
- Permissões sudo (para algumas verificações)
- O arquivo `ANALISE_NGINX_PRODUCAO.sh` deve estar no servidor

## Como executar

### 1. Copiar o script para o servidor

```bash
# Via SCP (do seu computador Windows)
scp "02-DEVELOPMENT/ANALISE_NGINX_PRODUCAO.sh" usuario@bpsegurosimediato.com.br:/tmp/

# Ou via WinSCP/SFTP
# Copiar: ANALISE_NGINX_PRODUCAO.sh
# Para: /tmp/ no servidor
```

### 2. Conectar ao servidor

```bash
ssh usuario@bpsegurosimediato.com.br
```

### 3. Tornar o script executável

```bash
chmod +x /tmp/ANALISE_NGINX_PRODUCAO.sh
```

### 4. Executar o script

```bash
# Executar com sudo para verificar permissões como usuário do Nginx
sudo /tmp/ANALISE_NGINX_PRODUCAO.sh
```

**OU** (se não tiver sudo)

```bash
/tmp/ANALISE_NGINX_PRODUCAO.sh
```

## O que o script faz

O script realiza uma análise completa em 11 seções:

1. **Informações do Sistema**: OS, kernel, usuário, grupos
2. **Status do Nginx**: Versão, status do serviço, processos
3. **Configuração do Nginx**: Análise do arquivo de configuração, server blocks, location blocks
4. **Verificação de Arquivos**: Existência, permissões, propriedade dos arquivos e diretórios
5. **Análise de Permissões**: Compatibilidade com usuário/grupo do Nginx
6. **Teste de Acesso HTTP**: Requisições HTTP para verificar se o arquivo é acessível
7. **Logs do Nginx**: Análise de erros e acessos recentes
8. **SELinux/AppArmor**: Verificação de restrições de segurança
9. **Firewall e Rede**: Verificação de regras de firewall e portas
10. **Comparação com DEV**: Compara configuração PROD vs DEV (que funciona)
11. **Análise de Path**: Como o Nginx resolve o caminho do arquivo

## Saída do script

O script gera:
- **Saída no console**: Informações em tempo real durante a execução
- **Relatório completo**: Arquivo em `/tmp/nginx_analysis_report_YYYYMMDD_HHMMSS.txt`

## Após a execução

1. O script mostrará um resumo das principais descobertas
2. O relatório completo estará salvo em `/tmp/nginx_analysis_report_*.txt`
3. Você pode copiar o relatório para análise:

```bash
# No servidor
cat /tmp/nginx_analysis_report_*.txt

# Ou copiar para seu computador
scp usuario@bpsegurosimediato.com.br:/tmp/nginx_analysis_report_*.txt ./
```

## O que procurar nos resultados

### Problemas comuns e seus indicadores:

1. **Arquivo não existe no caminho esperado**
   - Seção 4 e 11: Caminho do arquivo vs caminho esperado

2. **Permissões incorretas**
   - Seção 5: Nginx não consegue ler o arquivo/diretório

3. **Location block incorreto ou ausente**
   - Seção 3: Location block para /webhooks/ não configurado corretamente

4. **Proxy pass sobrescrevendo location**
   - Seção 3: Ordem dos location blocks pode estar errada

5. **SELinux bloqueando**
   - Seção 8: Contexto SELinux incorreto

6. **Raiz (root) incorreta**
   - Seção 11: Diretório root do Nginx não corresponde ao local do arquivo

7. **404 no log de acesso**
   - Seção 7: Logs mostram requisições 404 para /webhooks/

## Segurança

⚠️ **IMPORTANTE**: O script NÃO altera nada, apenas lê e analisa. É seguro executar em produção.

## Suporte

Se o script não executar, verifique:
- Permissões do arquivo (`chmod +x`)
- Sintaxe bash (`bash -n /tmp/ANALISE_NGINX_PRODUCAO.sh`)
- Conexão SSH ao servidor


