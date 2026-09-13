#!/usr/bin/env bash
#
# Da de alta un proyecto: copia la plantilla de projects/_template/ dentro del
# repo de destino, dejándole su propio CLAUDE.md y su memoria de proyecto.
#
#   ./scripts/new-project.sh ../mi-proyecto      crea los archivos
#   ./scripts/new-project.sh --dry-run ../mi-proyecto
#   ./scripts/new-project.sh --name api ../svc   fuerza el nombre del proyecto
#
# Deja en el destino:
#
#   <destino>/CLAUDE.md                      instrucciones del proyecto
#   <destino>/.claude/memory/MEMORY.md       índice de memoria del proyecto
#   <destino>/.claude/memory/topics/         detalle, bajo demanda
#
# Es idempotente: nunca sobrescribe un archivo que ya exista, sólo lo avisa.
# Después, añade la fila del proyecto al registro de memory/MEMORY.md.

set -euo pipefail

DRY=false
NAME=""
TARGET=""

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) DRY=true ;;
    --name)    shift; NAME="${1:-}" ;;
    -h|--help) sed -n '2,19p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)        echo "Opción desconocida: $1 (usa --help)" >&2; exit 2 ;;
    *)
      if [ -n "$TARGET" ]; then
        echo "Sobra un argumento: $1 (sólo se admite un destino)" >&2; exit 2
      fi
      TARGET="$1"
      ;;
  esac
  shift
done

if [ -z "$TARGET" ]; then
  echo "Falta el directorio de destino. Uso: $0 [--dry-run] [--name <nombre>] <ruta>" >&2
  exit 2
fi

if [ ! -d "$TARGET" ]; then
  echo "No existe el directorio: $TARGET" >&2
  echo "Créalo (o clona el repo) antes de dar de alta el proyecto." >&2
  exit 1
fi

REPO_DIR=$(cd "$(dirname "$0")/.." && pwd)
TPL_DIR="$REPO_DIR/projects/_template"
TARGET_DIR=$(cd "$TARGET" && pwd)

[ -d "$TPL_DIR" ] || { echo "No encuentro la plantilla en $TPL_DIR" >&2; exit 1; }

[ -n "$NAME" ] || NAME=$(basename "$TARGET_DIR")
DATE=$(date +%Y-%m-%d)

MEM_DIR="$TARGET_DIR/.claude/memory"

echo "Proyecto: $NAME"
echo "Destino : $TARGET_DIR"
$DRY && echo "Modo    : dry-run (no se escribe nada)"
echo

run() { if $DRY; then echo "  [dry-run] $*"; else "$@"; fi; }

# Sustituye los marcadores de la plantilla y escribe el archivo, salvo que ya exista.
render() {
  local src=$1 dest=$2 rel=${2#"$TARGET_DIR"/}

  if [ -e "$dest" ]; then
    echo "  ya existe, no se toca: $rel"
    return 0
  fi
  if $DRY; then
    echo "  [dry-run] escribiría: $rel"
    return 0
  fi
  sed -e "s/{{PROJECT}}/$NAME/g" -e "s/{{DATE}}/$DATE/g" "$src" > "$dest"
  echo "  creado: $rel"
}

run mkdir -p "$MEM_DIR/topics"

render "$TPL_DIR/CLAUDE.md.template" "$TARGET_DIR/CLAUDE.md"
render "$TPL_DIR/MEMORY.md.template" "$MEM_DIR/MEMORY.md"

if [ -e "$MEM_DIR/topics/.gitkeep" ]; then
  echo "  ya existe, no se toca: .claude/memory/topics/.gitkeep"
elif $DRY; then
  echo "  [dry-run] escribiría: .claude/memory/topics/.gitkeep"
else
  : > "$MEM_DIR/topics/.gitkeep"
  echo "  creado: .claude/memory/topics/.gitkeep"
fi

echo
if $DRY; then
  echo "Dry-run: no se modificó nada."
else
  cat <<EOF
Listo. Siguientes pasos:

  1. Rellena el stack y los comandos en $TARGET/CLAUDE.md
  2. Añade la fila de '$NAME' al registro de proyectos:
     $REPO_DIR/memory/MEMORY.md
EOF
fi
