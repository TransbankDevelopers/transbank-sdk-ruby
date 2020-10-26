# Changelog
Todos los cambios notables a este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
y este proyecto adhiere a [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2020-10-26

### Added

- Se agrega soporte para:
    - Webpay Plus Rest
        - modalidad normal
        - modalidad captura diferida
        - modalidad mall
        - modalidad mall captura diferida
    - Patpass by Webpay Rest
    - Patpass Comercio Rest
    - Transacción completa Rest
        - modalidad mall
    - Oneclick Mall Captura diferida

## [1.2.0] - 2019-12-26
### Added
- Se agrega soporte para Oneclick Mall y Transacción Completa en sus versiones REST.

## [1.1.0] - 2018-04-08
### Added
- Se agregaron los parámetros `qr_width_height` y `commerce_logo_url` a Options, para definir el tamaño del QR generado para la transacción, y especificar la ubicación del logo de comercio para ser mostrado en la aplicación móvil de Onepay. Puedes configurar estos parámetros globalmente o por transacción.

## [1.0.2] - 2018-11-29
### Fixed
- Corrige problema que evitaba poder utilizar un `CHANNEL` distinto a `WEB`

## [1.0.1] - 2018-10-24
### Fixed
- Cambios para subir automáticamente la gema a RubyGems cuando se hace un nuevo release

## [1.0.0] - 2018-10-23
### Added
- Primer lanzamiento del SDK
