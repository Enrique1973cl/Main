# MEMORY.md — main

> Memoria del repo `Main`. No se importa sola: está apuntada desde
> `memory/MEMORY.md` y se lee al trabajar en este repo.
> Una línea por entrada; el detalle, en `topics/`.

<!-- Formato: `- [YYYY-MM-DD] Hecho en una línea. → topics/archivo.md` -->

---

## Estado actual

- [2026-09-13] Repo de configuración funcionando: `CLAUDE.md` global, plugin
  `superpowers` v6.3.0, `install.sh`, y el montaje de memoria recién añadido.
- Sin código de aplicación, sin CI. El único test es `scripts/test-new-project.sh`.
- Rama de trabajo de la sesión: `claude/beautiful-euler-ee1vul`.

## Decisiones

- [2026-09-13] Memoria híbrida: global versionada aquí, por proyecto en cada repo. → `../../memory/topics/decisions.md`
- [2026-09-13] Índice corto importado, detalle bajo demanda. → `../../memory/topics/decisions.md`
- [2026-09-13] El `CLAUDE.md` de la raíz es el **global**; lo de `Main` vive en `projects/main/`. → `CLAUDE.md`
- [2026-09-13] La plantilla usa sufijo `.template` para no ser cargada como instrucciones. → `topics/session-log.md`

## Contexto que no está en el código

- El repo se clona en cada sesión web desde un *setup script*; nada fuera de git sobrevive. → `../../memory/topics/environment.md`
- Origen: <https://github.com/Enrique1973cl/Main>. Repositorio personal, sin licencia pública.

## Trampas conocidas

- `CLAUDE.md` se carga dos veces al trabajar dentro de este repo (usuario + proyecto). → `CLAUDE.md`
- La importación global es *external import*: pide aprobación una vez por proyecto. → `CLAUDE.md`
- `scripts/test-new-project.sh` no usa framework: es Bash a pelo y devuelve != 0 si algo falla.

## Historial de trabajo

- [2026-09-13] Revisión del `CLAUDE.md` global y diseño del montaje de memoria. → `topics/session-log.md`

---

## Mantenimiento

1. Una entrada sólo si cambiaría una decisión futura.
2. Lo deducible del código, fuera.
3. Obsoleto: se borra o se reescribe.
4. `wc -l` por debajo de 200.
