#!/usr/bin/env bash
#
# Smoke test para scripts/new-project.sh.
#
#   ./scripts/test-new-project.sh
#
# Crea un repo de juguete en un directorio temporal, ejecuta el scaffolder
# contra él y comprueba que deja los archivos esperados con el contenido
# esperado. No toca nada fuera de $TMPDIR.

set -uo pipefail

REPO_DIR=$(cd "$(dirname "$0")/.." && pwd)
SCAFFOLD="$REPO_DIR/scripts/new-project.sh"

PASS=0
FAIL=0

ok()   { printf '  ok   %s\n' "$1"; PASS=$((PASS + 1)); }
bad()  { printf '  FAIL %s\n' "$1"; FAIL=$((FAIL + 1)); }

check_file() { [ -f "$1" ] && ok "existe $2" || bad "falta $2"; }
check_grep() {
  if grep -qF "$2" "$1" 2>/dev/null; then ok "$3"; else bad "$3"; fi
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Probando $SCAFFOLD"
echo

# --- 1. El script existe y es ejecutable ------------------------------------
if [ -x "$SCAFFOLD" ]; then ok "new-project.sh existe y es ejecutable"
else bad "new-project.sh existe y es ejecutable"; fi

# --- 2. Falla sin argumentos ------------------------------------------------
if "$SCAFFOLD" >/dev/null 2>&1; then bad "sin argumentos debe salir != 0"
else ok "sin argumentos sale != 0"; fi

# --- 3. Scaffolding sobre un repo vacío -------------------------------------
TARGET="$TMP/demo-app"
mkdir -p "$TARGET"
if "$SCAFFOLD" "$TARGET" >/dev/null 2>&1; then ok "scaffolding sale 0"
else bad "scaffolding sale 0"; fi

check_file "$TARGET/CLAUDE.md"                        "CLAUDE.md del proyecto"
check_file "$TARGET/.claude/memory/MEMORY.md"         "MEMORY.md del proyecto"
check_file "$TARGET/.claude/memory/topics/.gitkeep"   "carpeta topics/"

# El CLAUDE.md del proyecto debe importar su propia memoria con ruta relativa.
check_grep "$TARGET/CLAUDE.md" "@.claude/memory/MEMORY.md" \
  "CLAUDE.md importa @.claude/memory/MEMORY.md"

# El nombre del proyecto se deduce del directorio destino.
check_grep "$TARGET/CLAUDE.md"                "demo-app" "CLAUDE.md nombra el proyecto"
check_grep "$TARGET/.claude/memory/MEMORY.md" "demo-app" "MEMORY.md nombra el proyecto"

# --- 4. Idempotencia: no pisa archivos existentes ---------------------------
echo "MARCA-PROPIA" >> "$TARGET/CLAUDE.md"
"$SCAFFOLD" "$TARGET" >/dev/null 2>&1
check_grep "$TARGET/CLAUDE.md" "MARCA-PROPIA" "segunda pasada no pisa CLAUDE.md"

# --- 5. --dry-run no escribe nada -------------------------------------------
DRY="$TMP/dry-app"
mkdir -p "$DRY"
"$SCAFFOLD" --dry-run "$DRY" >/dev/null 2>&1
if [ -e "$DRY/CLAUDE.md" ]; then bad "--dry-run no escribe"; else ok "--dry-run no escribe"; fi

echo
echo "Pasan: $PASS   Fallan: $FAIL"
[ "$FAIL" -eq 0 ]
