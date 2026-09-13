# Decisiones transversales

> Detalle de las entradas de la sección **Decisiones** de `../MEMORY.md`.
> Una decisión por bloque: qué se decidió, qué se descartó y por qué.

## [2026-09-13] Memoria híbrida: global aquí, por proyecto en su repo

**Decidido.** La memoria global (esto que aplica a todos los proyectos) vive
versionada en `Main/memory/` y `install.sh` la instala en `~/.claude/memory/`. La
memoria de cada proyecto vive **dentro del repo de ese proyecto**, en
`.claude/memory/MEMORY.md`, generada por `scripts/new-project.sh`. En
`projects/` queda el registro: la plantilla y una fila por proyecto apuntando a
dónde está su memoria real.

**Descartado — todo en este repo.** Centralizar la memoria de cada proyecto aquí
la separa del código que describe: se queda obsoleta y no viaja con el repo del
proyecto cuando se clona en otra parte.

**Descartado — sólo plantilla.** Sin memoria global no hay sitio para lo que
aplica a todo, que es justo lo que más se repite.

**Excepción.** El proyecto `main` *es* este repo, así que sus archivos de proyecto
viven directamente en `projects/main/` en vez de duplicarse en `.claude/memory/`.

## [2026-09-13] Carga: índice corto importado, detalle bajo demanda

**Decidido.** `CLAUDE.md` importa `@~/.claude/memory/MEMORY.md`, que es un índice
de una línea por entrada. El detalle vive en `memory/topics/*.md`, que **no** se
importan: se leen cuando la tarea lo pide.

**Por qué.** Es el mismo patrón que usa la auto-memoria nativa de Claude Code
(índice cargado, archivos de tema bajo demanda) y mantiene bajo el coste de
contexto. Importarlo todo funciona pero se paga en tokens en cada sesión; no
importar nada obliga a acordarse de mirar.

**Coste conocido.** La importación usa ruta absoluta (`@~/.claude/...`) porque
`CLAUDE.md` se instala como enlace simbólico en `~/.claude/` y una ruta relativa
resolvería distinto según desde dónde se cargue. Al ser una ruta fuera del
directorio de trabajo, Claude Code pedirá aprobación **una vez por proyecto** la
primera vez que la vea. Es el diálogo de *external imports* documentado en
<https://code.claude.com/docs/en/memory>.

## [2026-09-13] El CLAUDE.md de raíz es el global; lo de `Main` va aparte

**Decidido.** `CLAUDE.md` en la raíz se trata como memoria **global** y no debe
contener nada específico de este repo: se instala en `~/.claude/` y aplicaría a
todos los proyectos. Lo específico de `Main` (que no tiene código de aplicación,
que se prueba con `scripts/test-new-project.sh`, etc.) vive en
`projects/main/CLAUDE.md`.

**Consecuencia.** Al editar `CLAUDE.md`, la pregunta de control es: *¿esto vale
para cualquier proyecto?* Si la respuesta es no, va a `projects/main/`.
