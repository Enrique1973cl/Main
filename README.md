# Main

Repositorio base para mis proyectos futuros, preconfigurado para trabajar con
[Claude Code](https://claude.com/claude-code).

No contiene código de aplicación: aporta el **punto de partida** — las reglas de trabajo
del agente y el plugin de metodología ya instalado — para no repetir esa configuración en
cada proyecto nuevo.

## Contenido

| Archivo | Para qué sirve |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | Memoria del agente: estilo de respuesta, flujo de git, workflow de Superpowers y reglas de seguridad. Bilingüe (instrucciones en inglés, notas en español). |
| [`.claude/settings.json`](.claude/settings.json) | Declara el marketplace `obra/superpowers-marketplace` y activa el plugin `superpowers` con ámbito de proyecto. |
| [`install.sh`](install.sh) | Instala `CLAUDE.md` como memoria global de Claude Code (`~/.claude/CLAUDE.md`). |

## Uso

### 1. Clonar

```bash
git clone https://github.com/Enrique1973cl/Main.git
cd Main
```

Al abrir Claude Code en este directorio, el plugin `superpowers` se activa solo: está
declarado en `.claude/settings.json` y se descarga en el primer arranque.

### 2. Aplicar las reglas a todos tus proyectos

`CLAUDE.md` está escrito para servir como memoria **global**. Instálalo una vez por máquina
y aplicará a todos tus proyectos, no solo a este:

```bash
./install.sh              # enlace simbólico: se actualiza solo con git pull
./install.sh --copy       # copia independiente del repo
./install.sh --dry-run    # muestra qué haría, sin tocar nada
```

El script instala en `$CLAUDE_CONFIG_DIR/CLAUDE.md` (o `~/.claude/CLAUDE.md`), respalda
cualquier archivo previo en `CLAUDE.md.bak.<fecha>` y es idempotente: ejecutarlo dos veces
no hace daño. Reinicia Claude Code y comprueba con `/memory`.

El `CLAUDE.md` propio de cada proyecto tiene prioridad sobre el global cuando hay conflicto.

> **Claude Code en la web** — cada sesión arranca en un contenedor nuevo, así que el
> `~/.claude/CLAUDE.md` de tu máquina no viaja. Para que aplique también ahí, añade esto al
> *setup script* del entorno en claude.ai/code:
>
> ```bash
> git clone --depth 1 https://github.com/Enrique1973cl/Main.git /tmp/main-config \
>   && /tmp/main-config/install.sh --copy
> ```

### 3. Arrancar un proyecto nuevo desde aquí

```bash
git clone https://github.com/Enrique1973cl/Main.git mi-proyecto
cd mi-proyecto
rm -rf .git && git init
```

Luego edita `CLAUDE.md` y añade lo específico del proyecto: stack, gestor de paquetes y los
comandos exactos de build / test / lint.

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
