# Entorno

> Detalle de las entradas de la sección **Entorno** de `../MEMORY.md`.

## Claude Code en la web

Las sesiones arrancan en un contenedor efímero: el repo se clona de cero y el
contenedor se recicla por inactividad. Consecuencia práctica: **sólo sobrevive lo
que se commitea y se empuja**. Nada escrito en `~/` persiste entre sesiones.

Por eso la memoria de este montaje vive versionada en el repo y se *instala* a
`~/.claude/` con `install.sh`, en vez de vivir sólo en `~/.claude/`.

El `README.md` documenta el *setup script* del entorno que lo reconstruye en cada
sesión web:

```bash
git clone --depth 1 https://github.com/Enrique1973cl/Main.git /tmp/main-config \
  && /tmp/main-config/install.sh --copy
```

## Auto-memoria nativa de Claude Code

Claude Code trae su propio sistema de auto-memoria, activado por defecto, que
guarda notas en `~/.claude/projects/<project>/memory/` (un `MEMORY.md` índice más
un archivo por tema). Se carga en cada sesión, pero **sólo las primeras 200 líneas
o 25 KB** del índice.

Limitación que motiva todo este montaje, citada textualmente de la documentación:
«Auto memory is machine-local. All worktrees and subdirectories within the same
git repository share one auto memory directory. **Files are not shared across
machines or cloud environments.**»
— <https://code.claude.com/docs/en/memory>, sección *Storage location*.

Es decir: la auto-memoria nativa no llega a las sesiones web. La memoria
versionada de este repo y la nativa **conviven**; no se pisan.

## Cómo carga Claude Code los archivos de memoria

Resumen de <https://code.claude.com/docs/en/memory>, útil para no equivocarse al
tocar este montaje:

- Orden de carga, de más amplio a más específico: política gestionada →
  `~/.claude/CLAUDE.md` (usuario) → `./CLAUDE.md` o `./.claude/CLAUDE.md`
  (proyecto) → `./CLAUDE.local.md` (local, va a `.gitignore`).
- Se cargan los `CLAUDE.md` del directorio de trabajo **y de todos los de encima**;
  los de subdirectorios se cargan bajo demanda, al leer archivos de esa carpeta.
- Importaciones `@ruta/al/archivo`: rutas relativas **al archivo que las contiene**,
  no al directorio de trabajo. Máximo 4 saltos. El parser **ignora** las que están
  dentro de comillas invertidas o de un bloque de código.
- Una importación en un archivo de proyecto cuya ruta sale del directorio de
  trabajo es *externa*: Claude Code pide aprobación la primera vez. Las de
  archivos de ámbito de usuario (`~/.claude/...`) se cargan sin diálogo.
- Importar no ahorra contexto: lo importado entra igual en el arranque.
- Objetivo de tamaño: por debajo de **200 líneas** por `CLAUDE.md`.

## Superpowers

Plugin `superpowers` v6.3.0, declarado en `.claude/settings.json` con ámbito de
proyecto (marketplace `obra/superpowers-marketplace`). No expone slash commands:
las skills se activan solas según la tarea. El flujo y cuándo saltárselo están en
`CLAUDE.md`, sección *Superpowers workflow*.
