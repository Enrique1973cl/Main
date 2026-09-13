# Main

Repositorio base para mis proyectos futuros, preconfigurado para trabajar con
[Claude Code](https://claude.com/claude-code).

No contiene código de aplicación: aporta el **punto de partida** — las reglas de trabajo
del agente y el plugin de metodología ya instalado — para no repetir esa configuración en
cada proyecto nuevo.

## Contenido

| Ruta | Para qué sirve |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | Reglas **globales** del agente: estilo de respuesta, memoria, flujo de git, workflow de Superpowers y seguridad. Bilingüe (instrucciones en inglés, notas en español). |
| [`memory/`](memory/) | Memoria **global**: `MEMORY.md` es el índice que se importa en cada sesión; `topics/` guarda el detalle, que se lee bajo demanda. |
| [`projects/`](projects/) | Registro de proyectos: la plantilla de scaffolding y los archivos del propio repo `Main`. |
| [`scripts/new-project.sh`](scripts/new-project.sh) | Da de alta un proyecto: le deja su `CLAUDE.md` y su `.claude/memory/` dentro de su repo. |
| [`scripts/test-new-project.sh`](scripts/test-new-project.sh) | Smoke test del anterior. Es el único test del repo. |
| [`install.sh`](install.sh) | Instala `CLAUDE.md` y `memory/` como memoria global de Claude Code (`~/.claude/`). |
| [`.claude/settings.json`](.claude/settings.json) | Declara el marketplace `obra/superpowers-marketplace` y activa el plugin `superpowers` con ámbito de proyecto. |

## Uso

### 1. Clonar

```bash
git clone https://github.com/Enrique1973cl/Main.git
cd Main
```

Al abrir Claude Code en este directorio, el plugin `superpowers` se activa solo: está
declarado en `.claude/settings.json` y se descarga en el primer arranque.

### 2. Aplicar las reglas a todos tus proyectos

`CLAUDE.md` y `memory/` están escritos para servir como memoria **global**. Instálalos una
vez por máquina y aplicarán a todos tus proyectos, no solo a este:

```bash
./install.sh              # enlace simbólico: se actualiza solo con git pull
./install.sh --copy       # copia independiente del repo
./install.sh --dry-run    # muestra qué haría, sin tocar nada
```

El script instala en `$CLAUDE_CONFIG_DIR` (o `~/.claude`), respalda cualquier archivo
previo con sufijo `.bak.<fecha>` y es idempotente: ejecutarlo dos veces no hace daño.
Reinicia Claude Code y comprueba con `/memory`, y con `/context` que `CLAUDE.md` aparece
bajo **Memory files**.

El `CLAUDE.md` propio de cada proyecto tiene prioridad sobre el global cuando hay conflicto.

> **Claude Code en la web** — cada sesión arranca en un contenedor nuevo, así que el
> `~/.claude/CLAUDE.md` de tu máquina no viaja. Para que aplique también ahí, añade esto al
> *setup script* del entorno en claude.ai/code:
>
> ```bash
> git clone --depth 1 https://github.com/Enrique1973cl/Main.git /tmp/main-config \
>   && /tmp/main-config/install.sh --copy
> ```

### 3. Arrancar un proyecto nuevo

Con el paso 2 hecho, las reglas globales ya aplican en cualquier repo. Lo que le falta a un
proyecto nuevo es **lo suyo**: su `CLAUDE.md` y su memoria.

```bash
mkdir ../mi-proyecto && cd ../mi-proyecto && git init && cd -
./scripts/new-project.sh ../mi-proyecto
```

Eso deja en el repo del proyecto:

```text
mi-proyecto/
├── CLAUDE.md                    # instrucciones del proyecto; importa su memoria
└── .claude/memory/
    ├── MEMORY.md                # índice de memoria del proyecto
    └── topics/                  # detalle, bajo demanda
```

Luego rellena en su `CLAUDE.md` el stack, el gestor de paquetes y los comandos exactos de
build / test / lint, y añade su fila al registro de [`memory/MEMORY.md`](memory/MEMORY.md).

> No clones `Main` como esqueleto del proyecto: arrastraría `memory/`, `projects/` e
> `install.sh`, que son del repo de configuración, no del proyecto.

## Memoria

Dos ámbitos, separados a propósito:

| Ámbito | Dónde vive | Cuándo se carga |
|---|---|---|
| **Global** — vale para todos tus proyectos | `memory/` en este repo → `~/.claude/memory/` | `CLAUDE.md` importa `MEMORY.md` en **cada** sesión |
| **Por proyecto** — vale sólo para ese repo | `<repo>/.claude/memory/` dentro del proyecto | el `CLAUDE.md` del proyecto lo importa al abrir ahí |

En ambos casos el `MEMORY.md` es un **índice corto**, una línea por entrada, por debajo de
200 líneas. El detalle va en `topics/`, que no se carga al arrancar: se lee cuando la tarea
lo pide. Es el mismo patrón que usa la auto-memoria nativa de Claude Code.

### Dar de alta un proyecto

```bash
./scripts/new-project.sh ../mi-proyecto      # crea CLAUDE.md y .claude/memory/ allí
./scripts/new-project.sh --dry-run ../mi-proyecto
```

Luego añade su fila al registro de [`memory/MEMORY.md`](memory/MEMORY.md).

### Por qué versionar la memoria en vez de dejarla en `~/.claude`

Claude Code ya trae auto-memoria, pero la documentación es explícita sobre su alcance:
«Auto memory is machine-local. […] Files are not shared across machines or cloud
environments» — <https://code.claude.com/docs/en/memory>, *Storage location*. Las sesiones
web arrancan en un contenedor nuevo, así que esa memoria no llega. Versionarla aquí sí
viaja. Los dos sistemas conviven sin pisarse.

### Dos avisos

- La importación global usa ruta absoluta (`@~/.claude/memory/MEMORY.md`). Al ser una ruta
  fuera del directorio de trabajo, Claude Code pedirá aprobación **una vez por proyecto**
  la primera vez que la vea. Es el diálogo de *external imports* documentado.
- Estos archivos se commitean: **nunca** escribas secretos, tokens ni credenciales en ellos.

---

## Superpowers

[Superpowers](https://github.com/obra/superpowers) (v6.3.0) es una metodología de
desarrollo en forma de *skills* que se activan automáticamente según la tarea — no hay
slash commands. El flujo principal:

`brainstorming` → `using-git-worktrees` → `writing-plans` →
`executing-plans` / `subagent-driven-development` → `test-driven-development` →
`requesting-code-review` → `finishing-a-development-branch`

El detalle de cada etapa y cuándo saltárselas está en [`CLAUDE.md`](CLAUDE.md).

### Comandos útiles

```bash
claude plugin list                                  # ver plugins activos y su ámbito
claude plugin marketplace update superpowers-marketplace   # actualizar a la última versión
claude plugin details superpowers                   # inventario de skills y coste en tokens
```

## Requisitos

- [Claude Code](https://claude.com/claude-code) 2.x (probado con 2.1.269)
- git

## Licencia

Repositorio personal, sin licencia pública.
