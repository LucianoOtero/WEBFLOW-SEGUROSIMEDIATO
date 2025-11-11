# 💾 PLANO DE BACKUP LOCAL - ANTES DAS MODIFICAÇÕES

**Data:** 08/11/2025  
**Status:** ✅ **PLANO COMPLETO**

---

## 🎯 OBJETIVO

Criar backups locais completos de todos os arquivos que serão modificados ANTES de iniciar as alterações.

---

## 📋 ARQUIVOS QUE SERÃO MODIFICADOS

### **Arquivos JavaScript:**
1. `FooterCodeSiteDefinitivoCompleto.js`
2. `MODAL_WHATSAPP_DEFINITIVO.js`
3. `webflow_injection_limpo.js`

### **Arquivos PHP (novos):**
1. `config_env.js.php` (será criado)

---

## 💾 ESTRUTURA DE BACKUP

### **Diretório de Backup:**
```
WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/2025-11-08_MIGRACAO_VARIAVEIS_AMBIENTE/
├── JavaScript/
│   ├── FooterCodeSiteDefinitivoCompleto.js.backup
│   ├── MODAL_WHATSAPP_DEFINITIVO.js.backup
│   └── webflow_injection_limpo.js.backup
├── PHP/
│   └── config_env.js.php (novo, não precisa backup)
└── backup_log.txt (log do backup)
```

---

## 🔧 SCRIPT DE BACKUP (PowerShell)

### **Script: `backup_pre_migracao_variaveis.ps1`**

```powershell
# backup_pre_migracao_variaveis.ps1
# Script para criar backup local antes da migração para variáveis de ambiente

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "WEBFLOW-SEGUROSIMEDIATO\04-BACKUPS\2025-11-08_MIGRACAO_VARIAVEIS_AMBIENTE_$timestamp"
$sourceDir = "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   BACKUP LOCAL - ANTES DA MIGRAÇÃO                        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Criar diretório de backup
New-Item -ItemType Directory -Path "$backupDir\JavaScript" -Force | Out-Null
New-Item -ItemType Directory -Path "$backupDir\PHP" -Force | Out-Null

Write-Host "📁 Diretório de backup: $backupDir" -ForegroundColor Green
Write-Host ""

# Lista de arquivos para backup
$filesToBackup = @(
    @{Name="FooterCodeSiteDefinitivoCompleto.js"; Path="$sourceDir\FooterCodeSiteDefinitivoCompleto.js"; Type="JavaScript"},
    @{Name="MODAL_WHATSAPP_DEFINITIVO.js"; Path="$sourceDir\MODAL_WHATSAPP_DEFINITIVO.js"; Type="JavaScript"},
    @{Name="webflow_injection_limpo.js"; Path="$sourceDir\webflow_injection_limpo.js"; Type="JavaScript"}
)

$backupCount = 0
$backupLog = @()

# Fazer backup de cada arquivo
foreach ($file in $filesToBackup) {
    $sourcePath = $file.Path
    $destPath = "$backupDir\$($file.Type)\$($file.Name).backup"
    
    if (Test-Path $sourcePath) {
        try {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            $backupCount++
            $fileSize = (Get-Item $sourcePath).Length
            Write-Host "✅ Backup: $($file.Name) ($([math]::Round($fileSize/1KB, 2)) KB)" -ForegroundColor Green
            $backupLog += "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - ✅ $($file.Name) - $([math]::Round($fileSize/1KB, 2)) KB"
        } catch {
            Write-Host "❌ Erro ao fazer backup: $($file.Name)" -ForegroundColor Red
            $backupLog += "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - ❌ $($file.Name) - ERRO: $_"
        }
    } else {
        Write-Host "⚠️  Arquivo não encontrado: $($file.Name)" -ForegroundColor Yellow
        $backupLog += "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - ⚠️  $($file.Name) - NÃO ENCONTRADO"
    }
}

# Criar log do backup
$logContent = @"
BACKUP LOCAL - ANTES DA MIGRAÇÃO PARA VARIÁVEIS DE AMBIENTE
Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Timestamp: $timestamp
Diretório: $backupDir

ARQUIVOS BACKUPADOS:
$($backupLog -join "`n")

TOTAL: $backupCount arquivo(s) backupado(s)

DESCRIÇÃO:
Este backup foi criado antes da migração dos arquivos JavaScript para usar
variáveis de ambiente do Docker (APP_BASE_URL, APP_BASE_DIR).

ARQUIVOS MODIFICADOS:
- FooterCodeSiteDefinitivoCompleto.js
- MODAL_WHATSAPP_DEFINITIVO.js
- webflow_injection_limpo.js

ARQUIVOS CRIADOS:
- config_env.js.php (novo arquivo PHP)

PARA RESTAURAR:
1. Copiar arquivos de volta de: $backupDir\JavaScript\
2. Para: WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT\
"@

$logPath = "$backupDir\backup_log.txt"
$logContent | Out-File -FilePath $logPath -Encoding UTF8

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📊 RESUMO DO BACKUP" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total de arquivos backupados: $backupCount" -ForegroundColor Green
Write-Host "Diretório de backup: $backupDir" -ForegroundColor Green
Write-Host "Log do backup: $logPath" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Backup concluído com sucesso!" -ForegroundColor Green
Write-Host ""
```

---

## 🔧 SCRIPT DE BACKUP (Bash - Alternativo)

### **Script: `backup_pre_migracao_variaveis.sh`**

```bash
#!/bin/bash
# backup_pre_migracao_variaveis.sh
# Script para criar backup local antes da migração para variáveis de ambiente

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/2025-11-08_MIGRACAO_VARIAVEIS_AMBIENTE_$TIMESTAMP"
SOURCE_DIR="WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   BACKUP LOCAL - ANTES DA MIGRAÇÃO                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Criar diretórios
mkdir -p "$BACKUP_DIR/JavaScript"
mkdir -p "$BACKUP_DIR/PHP"

echo "📁 Diretório de backup: $BACKUP_DIR"
echo ""

# Lista de arquivos para backup
FILES=(
    "FooterCodeSiteDefinitivoCompleto.js"
    "MODAL_WHATSAPP_DEFINITIVO.js"
    "webflow_injection_limpo.js"
)

BACKUP_COUNT=0
BACKUP_LOG=""

# Fazer backup de cada arquivo
for file in "${FILES[@]}"; do
    SOURCE_PATH="$SOURCE_DIR/$file"
    DEST_PATH="$BACKUP_DIR/JavaScript/$file.backup"
    
    if [ -f "$SOURCE_PATH" ]; then
        cp "$SOURCE_PATH" "$DEST_PATH"
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
        FILE_SIZE=$(du -h "$SOURCE_PATH" | cut -f1)
        echo "✅ Backup: $file ($FILE_SIZE)"
        BACKUP_LOG+="$(date '+%Y-%m-%d %H:%M:%S') - ✅ $file - $FILE_SIZE\n"
    else
        echo "⚠️  Arquivo não encontrado: $file"
        BACKUP_LOG+="$(date '+%Y-%m-%d %H:%M:%S') - ⚠️  $file - NÃO ENCONTRADO\n"
    fi
done

# Criar log do backup
LOG_CONTENT="BACKUP LOCAL - ANTES DA MIGRAÇÃO PARA VARIÁVEIS DE AMBIENTE
Data: $(date '+%Y-%m-%d %H:%M:%S')
Timestamp: $TIMESTAMP
Diretório: $BACKUP_DIR

ARQUIVOS BACKUPADOS:
$BACKUP_LOG

TOTAL: $BACKUP_COUNT arquivo(s) backupado(s)

DESCRIÇÃO:
Este backup foi criado antes da migração dos arquivos JavaScript para usar
variáveis de ambiente do Docker (APP_BASE_URL, APP_BASE_DIR).

ARQUIVOS MODIFICADOS:
- FooterCodeSiteDefinitivoCompleto.js
- MODAL_WHATSAPP_DEFINITIVO.js
- webflow_injection_limpo.js

ARQUIVOS CRIADOS:
- config_env.js.php (novo arquivo PHP)

PARA RESTAURAR:
1. Copiar arquivos de volta de: $BACKUP_DIR/JavaScript/
2. Para: WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT/
"

echo "$LOG_CONTENT" > "$BACKUP_DIR/backup_log.txt"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RESUMO DO BACKUP"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Total de arquivos backupados: $BACKUP_COUNT"
echo "Diretório de backup: $BACKUP_DIR"
echo "Log do backup: $BACKUP_DIR/backup_log.txt"
echo ""
echo "✅ Backup concluído com sucesso!"
echo ""
```

---

## 📋 CHECKLIST DE BACKUP

### **Antes de iniciar modificações:**

- [ ] Executar script de backup
- [ ] Verificar que todos os arquivos foram backupados
- [ ] Verificar tamanho dos arquivos de backup
- [ ] Ler o log do backup
- [ ] Confirmar localização do diretório de backup

### **Arquivos que serão backupados:**

- [ ] `FooterCodeSiteDefinitivoCompleto.js`
- [ ] `MODAL_WHATSAPP_DEFINITIVO.js`
- [ ] `webflow_injection_limpo.js`

---

## 🔄 RESTAURAÇÃO

### **Como restaurar se necessário:**

```powershell
# PowerShell
$backupDir = "WEBFLOW-SEGUROSIMEDIATO\04-BACKUPS\2025-11-08_MIGRACAO_VARIAVEIS_AMBIENTE_[TIMESTAMP]"
$sourceDir = "WEBFLOW-SEGUROSIMEDIATO\02-DEVELOPMENT"

# Restaurar FooterCodeSiteDefinitivoCompleto.js
Copy-Item "$backupDir\JavaScript\FooterCodeSiteDefinitivoCompleto.js.backup" "$sourceDir\FooterCodeSiteDefinitivoCompleto.js" -Force

# Restaurar MODAL_WHATSAPP_DEFINITIVO.js
Copy-Item "$backupDir\JavaScript\MODAL_WHATSAPP_DEFINITIVO.js.backup" "$sourceDir\MODAL_WHATSAPP_DEFINITIVO.js" -Force

# Restaurar webflow_injection_limpo.js
Copy-Item "$backupDir\JavaScript\webflow_injection_limpo.js.backup" "$sourceDir\webflow_injection_limpo.js" -Force
```

```bash
# Bash
BACKUP_DIR="WEBFLOW-SEGUROSIMEDIATO/04-BACKUPS/2025-11-08_MIGRACAO_VARIAVEIS_AMBIENTE_[TIMESTAMP]"
SOURCE_DIR="WEBFLOW-SEGUROSIMEDIATO/02-DEVELOPMENT"

# Restaurar todos os arquivos
cp "$BACKUP_DIR/JavaScript/FooterCodeSiteDefinitivoCompleto.js.backup" "$SOURCE_DIR/FooterCodeSiteDefinitivoCompleto.js"
cp "$BACKUP_DIR/JavaScript/MODAL_WHATSAPP_DEFINITIVO.js.backup" "$SOURCE_DIR/MODAL_WHATSAPP_DEFINITIVO.js"
cp "$BACKUP_DIR/JavaScript/webflow_injection_limpo.js.backup" "$SOURCE_DIR/webflow_injection_limpo.js"
```

---

## ✅ CONCLUSÃO

**Plano de Backup:**
- ✅ Script PowerShell criado
- ✅ Script Bash criado (alternativo)
- ✅ Estrutura de diretórios definida
- ✅ Log de backup incluído
- ✅ Instruções de restauração documentadas

**Próximo passo:**
1. Executar script de backup
2. Verificar backups criados
3. Iniciar modificações

---

**Documento criado em:** 08/11/2025  
**Última atualização:** 08/11/2025  
**Versão:** 1.0

