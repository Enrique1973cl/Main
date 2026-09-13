# projects/

Registro de proyectos. **No contiene la memoria viva de cada proyecto**: esa vive
dentro del repo de su proyecto, en `.claude/memory/MEMORY.md`, para que viaje con
el código y no se quede obsoleta aquí.

| Carpeta | Qué es |
|---|---|
| `_template/` | Plantilla que copia `scripts/new-project.sh` en un repo nuevo. Los archivos llevan sufijo `.template` para que Claude Code no los cargue como instrucciones. |
| `main/` | Excepción: el proyecto `main` **es** este repo, así que sus archivos de proyecto viven aquí en vez de duplicarse en `.claude/memory/`. |

La tabla maestra de proyectos (repo + dónde está su memoria) está en
[`../memory/MEMORY.md`](../memory/MEMORY.md), sección *Registro de proyectos*.

## Dar de alta un proyecto

```bash
./scripts/new-project.sh ../mi-proyecto     # crea CLAUDE.md y .claude/memory/ allí
./scripts/new-project.sh --dry-run ../mi-proyecto
```

Después, añade su fila al registro en `memory/MEMORY.md`.

## Por qué esta separación

- `memory/` → aplica a **todos** los proyectos. Se instala en `~/.claude/memory/`.
- `<repo>/.claude/memory/` → aplica a **ese** proyecto. Se carga sólo al trabajar allí.
- `projects/` → sólo el índice y la plantilla.

Al editar `CLAUDE.md` de la raíz, la pregunta de control es: *¿esto vale para
cualquier proyecto?* Si no, va al `CLAUDE.md` del proyecto.
