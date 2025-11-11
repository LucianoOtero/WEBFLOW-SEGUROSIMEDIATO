#!/bin/bash
# Script para configurar estrutura de diretórios completa
# Executar no servidor 65.108.156.14

set -e

echo "=========================================="
echo "CONFIGURACAO DE DIRETORIOS"
echo "=========================================="
echo ""

# ==================== FASE 1: CRIAR ESTRUTURA BASE ====================
echo "FASE 1: Criando estrutura de diretorios..."

# Diretórios principais
mkdir -p /var/www/html/dev/root
mkdir -p /var/www/html/prod/root
mkdir -p /var/www/html/dev/logs
mkdir -p /var/www/html/prod/logs

# Diretórios para backups (opcional)
mkdir -p /var/www/html/dev/backups
mkdir -p /var/www/html/prod/backups

# Diretórios para uploads temporários (se necessário)
mkdir -p /var/www/html/dev/tmp
mkdir -p /var/www/html/prod/tmp

echo "  ✅ Diretorios principais criados"
echo ""

# ==================== FASE 2: CONFIGURAR PERMISSÕES ====================
echo "FASE 2: Configurando permissoes..."

# Definir proprietário e grupo
chown -R www-data:www-data /var/www/html

# Permissões para diretórios
find /var/www/html -type d -exec chmod 755 {} \;

# Permissões para arquivos (serão definidas quando os arquivos forem copiados)
# Por enquanto, garantir que os diretórios estejam acessíveis
chmod 755 /var/www/html
chmod 755 /var/www/html/dev
chmod 755 /var/www/html/prod
chmod 755 /var/www/html/dev/root
chmod 755 /var/www/html/prod/root
chmod 755 /var/www/html/dev/logs
chmod 755 /var/www/html/prod/logs

# Permissões de escrita para logs
chmod 775 /var/www/html/dev/logs
chmod 775 /var/www/html/prod/logs

echo "  ✅ Permissoes configuradas"
echo ""

# ==================== FASE 3: CRIAR ARQUIVOS INICIAIS ====================
echo "FASE 3: Criando arquivos iniciais..."

# Arquivo .htaccess para DEV (se necessário)
cat > /var/www/html/dev/root/.htaccess << 'EOF'
# Configurações Apache (se aplicável)
# Nginx não usa .htaccess, mas mantido para compatibilidade
EOF

# Arquivo .htaccess para PROD
cat > /var/www/html/prod/root/.htaccess << 'EOF'
# Configurações Apache (se aplicável)
# Nginx não usa .htaccess, mas mantido para compatibilidade
EOF

# Arquivo index.html padrão para DEV
cat > /var/www/html/dev/root/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>DEV - Imediato Seguros</title>
</head>
<body>
    <h1>Ambiente de Desenvolvimento</h1>
    <p>Servidor configurado e funcionando.</p>
</body>
</html>
EOF

# Arquivo index.html padrão para PROD
cat > /var/www/html/prod/root/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Imediato Seguros</title>
</head>
<body>
    <h1>Servidor em Manutenção</h1>
    <p>Em breve estaremos online.</p>
</body>
</html>
EOF

# Arquivo .gitkeep para manter diretórios vazios no git (se aplicável)
touch /var/www/html/dev/logs/.gitkeep
touch /var/www/html/prod/logs/.gitkeep
touch /var/www/html/dev/backups/.gitkeep
touch /var/www/html/prod/backups/.gitkeep

echo "  ✅ Arquivos iniciais criados"
echo ""

# ==================== FASE 4: CONFIGURAR SELINUX (SE APLICÁVEL) ====================
echo "FASE 4: Verificando SELinux..."

if command -v getenforce &> /dev/null; then
    if [ "$(getenforce)" != "Disabled" ]; then
        echo "  ⚠️  SELinux detectado e ativo"
        echo "  Configurando contexto para /var/www/html..."
        setsebool -P httpd_can_network_connect 1 2>/dev/null || true
        chcon -R -t httpd_sys_content_t /var/www/html 2>/dev/null || true
        echo "  ✅ SELinux configurado"
    else
        echo "  ✅ SELinux desabilitado (OK)"
    fi
else
    echo "  ✅ SELinux nao instalado (OK)"
fi

echo ""

# ==================== FASE 5: VERIFICAÇÃO FINAL ====================
echo "FASE 5: Verificacao final..."

echo "Estrutura de diretorios:"
tree -L 3 /var/www/html 2>/dev/null || find /var/www/html -maxdepth 3 -type d | sort

echo ""
echo "Permissoes:"
ls -ld /var/www/html
ls -ld /var/www/html/dev
ls -ld /var/www/html/prod
ls -ld /var/www/html/dev/root
ls -ld /var/www/html/prod/root
ls -ld /var/www/html/dev/logs
ls -ld /var/www/html/prod/logs

echo ""
echo "Espaco em disco:"
df -h /var/www/html

echo ""
echo "=========================================="
echo "CONFIGURACAO DE DIRETORIOS CONCLUIDA!"
echo "=========================================="
echo ""
echo "ESTRUTURA CRIADA:"
echo "  /var/www/html/"
echo "    ├── dev/"
echo "    │   ├── root/          (arquivos PHP e JS)"
echo "    │   ├── logs/          (logs da aplicacao)"
echo "    │   ├── backups/       (backups locais)"
echo "    │   └── tmp/           (arquivos temporarios)"
echo "    └── prod/"
echo "        ├── root/          (arquivos PHP e JS)"
echo "        ├── logs/          (logs da aplicacao)"
echo "        ├── backups/       (backups locais)"
echo "        └── tmp/           (arquivos temporarios)"
echo ""
echo "PROXIMOS PASSOS:"
echo "  1. Copiar arquivos do Windows para /var/www/html/dev/root/"
echo "  2. Copiar arquivos do Windows para /var/www/html/prod/root/"
echo "  3. Instalar AWS SDK via Composer em ambos os diretorios"
echo ""

