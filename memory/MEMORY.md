# MEMORY.md — global

> Índice de memoria **global**: lo que aplica a todos los proyectos.
> Se importa desde `CLAUDE.md` (`@~/.claude/memory/MEMORY.md`), así que entra en
> contexto en **cada sesión**. Mantenlo corto: **una línea por entrada**, máximo
> ~200 líneas. El detalle va en `topics/`, que se lee sólo cuando hace falta.
>
> Memoria de proyecto: no va aquí. Ver el registro al final.

<!-- Formato: `- [YYYY-MM-DD] Hecho en una línea. → topics/archivo.md` -->
<!-- Regla: si una entrada no cambiaría una decisión futura, no la escribas. -->

---

## Usuario

- Idioma: escribe en inglés y en español; responder en el idioma de su mensaje. → `topics/user.md`
- Prefiere respuestas concisas y directas: la respuesta primero, el razonamiento después. → `topics/user.md`
- Pide **preguntar antes de asumir** cuando dos lecturas de un encargo dan trabajo distinto. → `topics/user.md`
- Pide **citar fuentes** siempre: URL, `archivo:línea`, o el comando y su salida. → `topics/user.md`

## Entorno

- Trabaja con Claude Code en la web: contenedor efímero, sólo sobrevive lo commiteado. → `topics/environment.md`
- La auto-memoria nativa (`~/.claude/projects/<p>/memory/`) es local a la máquina y **no** llega a sesiones web. → `topics/environment.md`
- El repo `Main` es la base de sus proyectos: reglas del agente + plugin `superpowers` v6.3.0. → `topics/environment.md`

## Decisiones transversales

- [2026-09-13] Memoria en modelo **híbrido**: global versionada en `Main`, la de cada proyecto dentro de su propio repo. → `topics/decisions.md`
- [2026-09-13] Carga: índice corto importado en cada sesión, detalle en `topics/` bajo demanda. → `topics/decisions.md`
- [2026-09-13] `CLAUDE.md` de raíz queda como memoria **global**; lo específico de `Main` vive en `projects/main/`. → `topics/decisions.md`

---

## Registro de proyectos

Un proyecto por fila. La memoria viva de cada uno está **en su propio repo**
(`<repo>/.claude/memory/MEMORY.md`); aquí sólo se apunta dónde encontrarla.

| Proyecto | Repo | Memoria del proyecto | Estado |
|---|---|---|---|
| `main` | [Enrique1973cl/Main](https://github.com/Enrique1973cl/Main) | `projects/main/MEMORY.md` (vive aquí: el proyecto *es* este repo) | activo |

> Para dar de alta un proyecto nuevo: `./scripts/new-project.sh <ruta-al-repo>`
> y añade su fila a esta tabla.

---

## Cómo mantener este archivo

1. Escribe una entrada cuando el hecho **cambiaría una decisión futura**. Lo que se
   deduce leyendo el código, no.
2. Una línea por entrada, con fecha si es una decisión. El detalle, a `topics/`.
3. Si una entrada queda obsoleta, **bórrala o reescríbela**. Dos reglas en conflicto
   son peores que ninguna.
4. Revisa el tamaño: `wc -l memory/MEMORY.md` debe quedar por debajo de 200.
