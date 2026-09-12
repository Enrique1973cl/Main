#!/usr/bin/env bash
#
# Instala CLAUDE.md como memoria global de Claude Code, de modo que aplique a
# todos tus proyectos (presentes y futuros).
#
#   ./install.sh             enlace simbólico -> se actualiza solo con `git pull`
#   ./install.sh --copy      copia independiente del repo
#   ./install.sh --dry-run   muestra qué haría, sin tocar nada
#
# Destino: $CLAUDE_CONFIG_DIR/CLAUDE.md, o ~/.claude/CLAUDE.md si esa variable
# no está definida. Ver https://code.claude.com/docs/en/memory

set -euo pipefail

MODE=link
DRY=false

for arg in "$@"; do
  case "$arg" in
    --copy)    MODE=copy ;;
    --link)    MODE=link ;;
    --dry-run) DRY=true ;;
    -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Opción desconocida: $arg (usa --help)" >&2; exit 2 ;;
  esac
done

REPO_DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$REPO_DIR/CLAUDE.md"
DEST_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
DEST="$DEST_DIR/CLAUDE.md"

[ -f "$SRC" ] || { echo "No encuentro $SRC" >&2; exit 1; }

run() { if $DRY; then echo "  [dry-run] $*"; else "$@"; fi; }

echo "Origen : $SRC"
echo "Destino: $DEST"
echo "Modo   : $MODE"
echo

# Ya instalado como enlace al mismo archivo: nada que hacer.
if [ "$MODE" = link ] && [ -L "$DEST" ] && [ "$(readlink "$DEST")" = "$SRC" ]; then
  echo "Ya instalado (enlace correcto). Nada que hacer."
  exit 0
fi

run mkdir -p "$DEST_DIR"

# Respalda lo que hubiera antes; nunca se sobrescribe en silencio.
if [ -e "$DEST" ] || [ -L "$DEST" ]; then
  BACKUP="$DEST.bak.$(date +%Y%m%d-%H%M%S)"
  echo "Ya existe $DEST — lo respaldo en:"
  echo "  $BACKUP"
  run mv "$DEST" "$BACKUP"
fi

if [ "$MODE" = link ]; then
  run ln -s "$SRC" "$DEST"
else
  run cp "$SRC" "$DEST"
fi

echo
if $DRY; then
  echo "Dry-run: no se modificó nada."
else
  echo "Instalado. Reinicia Claude Code para que lo cargue."
  echo "Comprueba con /memory dentro de Claude Code."
fi
