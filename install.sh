#!/usr/bin/env bash
#
# Instala la memoria global de Claude Code, de modo que aplique a todos tus
# proyectos (presentes y futuros):
#
#   CLAUDE.md  ->  $CLAUDE_CONFIG_DIR/CLAUDE.md     reglas de trabajo
#   memory/    ->  $CLAUDE_CONFIG_DIR/memory/       índice de memoria + temas
#
#   ./install.sh             enlace simbólico -> se actualiza solo con `git pull`
#   ./install.sh --copy      copia independiente del repo
#   ./install.sh --dry-run   muestra qué haría, sin tocar nada
#
# Destino: $CLAUDE_CONFIG_DIR, o ~/.claude si esa variable no está definida.
# Ver https://code.claude.com/docs/en/memory

set -euo pipefail

MODE=link
DRY=false

for arg in "$@"; do
  case "$arg" in
    --copy)    MODE=copy ;;
    --link)    MODE=link ;;
    --dry-run) DRY=true ;;
    -h|--help) sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Opción desconocida: $arg (usa --help)" >&2; exit 2 ;;
  esac
done

REPO_DIR=$(cd "$(dirname "$0")" && pwd)
DEST_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

[ -f "$REPO_DIR/CLAUDE.md" ] || { echo "No encuentro $REPO_DIR/CLAUDE.md" >&2; exit 1; }
[ -d "$REPO_DIR/memory"   ] || { echo "No encuentro $REPO_DIR/memory" >&2; exit 1; }

echo "Origen : $REPO_DIR"
echo "Destino: $DEST_DIR"
echo "Modo   : $MODE"
echo

run() { if $DRY; then echo "  [dry-run] $*"; else "$@"; fi; }

# Instala un archivo o directorio del repo en $DEST_DIR. Nunca sobrescribe en
# silencio: lo que hubiera antes se respalda con sufijo de fecha.
install_item() {
  local name=$1
  local src="$REPO_DIR/$name"
  local dest="$DEST_DIR/$name"

  echo "$name"

  if [ "$MODE" = link ] && [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  ya instalado (enlace correcto), nada que hacer"
    return 0
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="$dest.bak.$(date +%Y%m%d-%H%M%S)"
    echo "  ya existe — lo respaldo en $backup"
    run mv "$dest" "$backup"
  fi

  if [ "$MODE" = link ]; then
    run ln -s "$src" "$dest"
    echo "  enlazado"
  else
    run cp -R "$src" "$dest"
    echo "  copiado"
  fi
}

run mkdir -p "$DEST_DIR"

install_item CLAUDE.md
install_item memory

echo
if $DRY; then
  echo "Dry-run: no se modificó nada."
else
  echo "Instalado. Reinicia Claude Code para que lo cargue."
  echo "Comprueba con /memory dentro de Claude Code, y con /context que"
  echo "CLAUDE.md aparece en 'Memory files'."
fi
