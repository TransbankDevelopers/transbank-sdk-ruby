# Transbank SDK Ruby

SDK Oficial de Transbank

## Requisitos:

- Ruby 2.4+

# Instalación

Puedes instalar el SDK directamente

```bash
gem install transbank-sdk
```

o añadirlo a tu `Gemfile`

```ruby
gem 'transbank-sdk'
```

y luego ejecutar

```bash
bundle install
```

## Documentación

Puedes encontrar toda la documentación de cómo usar este SDK en el sitio https://www.transbankdevelopers.cl.

La documentación relevante para usar este SDK es:

- Documentación sobre [ambientes, deberes del comercio, puesta en producción,
  etc](https://www.transbankdevelopers.cl/documentacion/como_empezar#ambientes).

## Información para contribuir y desarrollar este SDK

### Standares

- Para los commits respetamos las siguientes normas: https://chris.beams.io/posts/git-commit/
- Usamos ingles, para los mensajes de commit.
- Se pueden usar tokens como WIP, en el subject de un commit, separando el token con `:`, por ejemplo:
  `WIP: This is a useful commit message`
- Para los nombres de ramas también usamos ingles.
- Se asume, que una rama de feature no mezclada, es un feature no terminado.
- El nombre de las ramas va en minúsculas.
- Las palabras se separan con `-`.
- Las ramas comienzan con alguno de los short lead tokens definidos, por ejemplo: `feat/tokens-configuration`

### **Reglas** 📖

1. Todo PR debe incluir test o evidencia de que funcione correctamente(gif, foto).
2. El PR debe tener 2 o más aprobaciones para poder mezclarse.
3. Si un commit revierte un commit anterior deberá comenzar con "revert:" seguido del mensaje del commit anterior.

### **Pull Request**

- Usar un lenguaje imperativo y en tiempo presente: "change" no "changed" ni "changes".
- El título del los PR y mensajes de commit no pueden comenzar con una letra mayúscula.
- No se debe usar punto final en los títulos o descripción de los commits.
- El título del PR debe comenzar con el short lead token definido para la rama, seguido de : y una breve descripción del cambio.
- La descripción del PR debe detallar los cambios.
- La descripción del PR debe incluir evidencias de que los test se ejecutan de forma correcta.
- Se pueden usar gif o videos para complementar la descripción o evidenciar el funcionamiento del PR.

#### Short lead tokens

`WIP` = En progreso.

`feat` = Nuevos features.

`fix` = Corrección de un bug.

`docs` = Cambios solo de documentación.

`style` = Cambios que no afectan el significado del código. (espaciado, formateo de código, comillas faltantes, etc)

`refactor` = Un cambio en el código que no arregla un bug ni agrega una funcionalidad.

`perf` = Cambio que mejora el rendimiento.

`test` = Agregar test faltantes o los corrige.

`chore` = Cambios en el build o herramientas auxiliares y librerías.

`revert` = Revierte un commit.

`release` = Para liberar una nueva versión.

### Todas las mezclas a master se hacen mediante Pull Request.

### Deploy de una nueva versión.

Para generar una nueva versión, se debe crear un PR (con un título "Prepare release X.Y.Z" con los valores que correspondan para `X`, `Y` y `Z`). Se debe seguir el estándar semver para determinar si se incrementa el valor de `X` (si hay cambios no retrocompatibles), `Y` (para mejoras retrocompatibles) o `Z` (si sólo hubo correcciones a bugs).

En ese PR deben incluirse los siguientes cambios:

1. Modificar el archivo `CHANGELOG.md` para incluir una nueva entrada (al comienzo) para `X.Y.Z` que explique en español los cambios **de cara al usuario del SDK**.
2. Modificar [version.rb](./lib/transbank/sdk/version.rb) para poner la nueva versión que corresponde.

Luego de obtener aprobación del pull request, debe mezclarse a master e inmediatamente generar un release en GitHub con el tag `vX.Y.Z`. En la descripción del release debes poner lo mismo que agregaste al changelog.

Con eso Github Actions generará automáticamente una nueva versión de la librería y la publicará en RubyGems.
