# CLAUDE.md — main

> Instrucciones específicas del repo `Main`. Ganan sobre el `CLAUDE.md` global
> cuando hay conflicto.
>
> **Ojo:** el `CLAUDE.md` de la raíz de este repo **no** es el de este proyecto;
> es la memoria *global* que `install.sh` instala en `~/.claude/`. Al editarla,
> la pregunta de control es *¿esto vale para cualquier proyecto?* Si no, va aquí.
>
> Este archivo vive en `projects/main/` y no se carga solo: se lee al trabajar
> en este repo. La raíz está apuntada en `memory/MEMORY.md`.

---

## Qué es este repo

Repositorio base de configuración, **sin código de aplicación**. Aporta las reglas
de trabajo del agente, el plugin de metodología y ahora el montaje de memoria,
para no repetir esa configuración en cada proyecto nuevo.

## Stack y comandos

- **Stack:** Markdown y Bash. Sin gestor de paquetes, sin build, sin CI.

| Tarea | Comando |
|---|---|
| build | — (no hay) |
| test | `./scripts/test-new-project.sh` |
| lint | — (no hay; `bash -n <script>` para comprobar sintaxis) |
| typecheck | — (no hay) |

Antes de commitear cambios en `scripts/`: `./scripts/test-new-project.sh` y
`bash -n` sobre los scripts tocados. `install.sh` se comprueba con
`./install.sh --dry-run`, que no escribe nada.

## Layout

| Ruta | Qué es |
|---|---|
| `CLAUDE.md` | Memoria **global**. Se instala en `~/.claude/CLAUDE.md`. |
| `memory/MEMORY.md` | Índice de memoria global. Se importa en cada sesión. |
| `memory/topics/` | Detalle de la memoria global. Bajo demanda. |
| `projects/_template/` | Plantilla de scaffolding (`*.template`). |
| `projects/main/` | Los archivos de proyecto de **este** repo. |
| `scripts/new-project.sh` | Da de alta un proyecto nuevo. |
| `scripts/test-new-project.sh` | Smoke test del anterior. |
| `install.sh` | Instala `CLAUDE.md` y `memory/` en `~/.claude/`. |
| `.claude/settings.json` | Marketplace y plugin `superpowers`. |

## Convenciones propias

- **Bilingüe a propósito:** lo que lee el modelo como instrucción, en inglés; las
  notas explicativas para el usuario, en español y citadas como bloque `>`.
- Los archivos de `projects/_template/` llevan sufijo `.template` para que Claude
  Code no los cargue como instrucciones reales.
- Los scripts son idempotentes, aceptan `--dry-run` y nunca sobrescriben en
  silencio: respaldan o se saltan el archivo existente.
- Los mensajes de usuario de los scripts van en español; el código y los
  identificadores, en inglés.

## Trampas conocidas

- `install.sh` enlaza `CLAUDE.md` en `~/.claude/`. Al abrir una sesión **dentro de
  este repo**, ese archivo se carga dos veces: una como memoria de usuario y otra
  como memoria de proyecto. Es ruido de contexto conocido, no un error.
- La importación de memoria global usa ruta absoluta (`@~/.claude/memory/MEMORY.md`)
  a propósito: una ruta relativa resolvería distinto al cargarse desde el enlace de
  `~/.claude/`. El precio es el diálogo de aprobación de *external imports* la
  primera vez en cada proyecto.
- El `superpowers` completo es caro en contexto. Para un arreglo de una línea o una
  pregunta, saltárselo (ya lo dice el `CLAUDE.md` global).
