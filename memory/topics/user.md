# Usuario

> Detalle de las entradas de la sección **Usuario** de `../MEMORY.md`.
> No se carga en cada sesión: se lee cuando hace falta.

## Idioma

Escribe indistintamente en inglés y en español. Regla vigente (`CLAUDE.md`,
sección *Response style*): responder en el idioma del mensaje; código,
identificadores y mensajes de commit **siempre en inglés**.

Los archivos de este repo son bilingües a propósito: las instrucciones que lee el
modelo, en inglés; las notas explicativas para el usuario, en español y citadas
como bloque `>`.

## Estilo de respuesta

- La respuesta primero; el razonamiento sólo si aporta.
- Sin preámbulo, sin halagos, sin repetir lo que acaba de decir.
- Informar con fidelidad: si algo falla, mostrar la salida; si se saltó un paso, decirlo.

## Preguntar antes de asumir

Regla explícita suya, y de las que más pesa. Si dos lecturas razonables de un
encargo producen trabajo materialmente distinto, **preguntar**, no adivinar. Las
decisiones de rutina no necesitan pregunta.

Ejemplo real: [2026-09-13] ante «crea un archivo de memoria», las opciones
(dónde vive, qué proyectos, cómo se carga) daban diseños incompatibles, así que
se preguntaron las tres antes de escribir nada. Eligió: híbrido / sólo `main` +
plantilla / índice corto importado.

## Citar fuentes

Cualquier afirmación que venga de fuera del repo necesita fuente: una URL, un
`archivo:línea`, o el comando y su salida. Nunca presentar como verificado algo
recordado del entrenamiento.
