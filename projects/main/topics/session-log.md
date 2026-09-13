# Historial de trabajo — main

> Detalle de la sección *Historial de trabajo* de `../MEMORY.md`.
> Una entrada por sesión, con lo que **quedó decidido o hecho**, no la conversación.
> Lo más reciente arriba.

---

## 2026-09-13 — Montaje de memoria global y por proyecto

**Punto de partida.** El repo tenía cuatro commits: plugin `superpowers` con
ámbito de proyecto, `CLAUDE.md` bilingüe, `README.md` e `install.sh`. No había
ningún mecanismo de memoria más allá del propio `CLAUDE.md`.

**Qué se hizo.**

1. Revisión del `CLAUDE.md` de la raíz (118 líneas: *Response style*, *Git
   workflow*, *Superpowers workflow*, *Security & secrets*, *Per-project
   overrides*). Sin cambios en esa lectura.
2. Se verificó cómo carga la memoria Claude Code contra la documentación oficial
   (<https://code.claude.com/docs/en/memory>) antes de diseñar nada — en
   particular que la auto-memoria nativa es local a la máquina y no llega a las
   sesiones web, que es el hueco que cubre este montaje.
3. Tres preguntas de diseño antes de escribir código, por la regla de *preguntar
   antes de asumir*. Respuestas: **híbrido**, **sólo `main` + plantilla**,
   **índice corto importado**.
4. Se construyó la estructura: `memory/` global, `projects/_template/`,
   `projects/main/`, `scripts/new-project.sh` con su smoke test, e `install.sh`
   ampliado para instalar también `memory/`.

**Decisiones de detalle que costaría volver a razonar.**

- La plantilla usa sufijo `.template` (`CLAUDE.md.template`) porque un
  `projects/_template/CLAUDE.md` real lo cargaría Claude Code como instrucciones
  al leer archivos de esa carpeta. El scaffolder quita el sufijo al copiar.
- El `CLAUDE.md` de un proyecto importa su memoria con **ruta relativa**
  (`@.claude/memory/MEMORY.md`): queda dentro del directorio de trabajo y no
  dispara el diálogo de aprobación. El global usa ruta absoluta por el enlace
  simbólico de `~/.claude/`; ahí el diálogo es inevitable y está asumido.
- `projects/main/` es la excepción del modelo híbrido: como el proyecto *es* este
  repo, sus archivos viven ahí en vez de en `.claude/memory/`, para no duplicar.

**Qué quedó pendiente.**

- Ningún proyecto real dado de alta todavía, sólo `main`. El primero que se cree
  con `scripts/new-project.sh` probará el flujo de verdad.
- La fila del registro en `memory/MEMORY.md` se añade a mano; el scaffolder no la
  escribe.
