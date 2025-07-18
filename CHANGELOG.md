# Changelog

Todos los cambios notables a este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
y este proyecto adhiere a [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [5.1.0] - 2025-06-23

Esta versión agrega una clase para la nueva funcionalidad de la API de OneClick. Los métodos existentes no tienen cambios.

### Agrega

- Se agrega la clase `MallBinInfo` , la cual contiene el método `query_bin` para la consulta de información de una tarjeta registrada en Oneclick.

## [5.0.0] - 2025-05-05

Esta versión no tiene cambios en el comportamiento de las funcionalidades de la API.

¡Importante!

El SDK ya no apunta por defecto al ambiente de integración. Ahora es necesario configurar de forma explícita las credenciales. Para esto se debe inicializar explícitamente los objetos de los distintos productos, ya sea utilizando la clase Options o a través de los nuevos métodos build_for_integration y build_for_production. Además, notar que ahora la versión mínima de Ruby a la 2.7.

### Agrega
- Se agrega el parámetro timeout para que pueda modificarse en todos los productos.
- Se agregan los métodos build_for_integration y build_for_production a todos los productos

### Actualiza
- Se actualiza la versión mínima soportada de Ruby a la 2.7
- Se configura por defecto el timeout a 600 segundos para todas las peticiones.
- Se actualizan las versiones de las dependencias.
- Se actualizan los test.

### Borra
- Se elimina el constructor por defecto en Webpayplus
- Se elimina el constructor por defecto en Oneclick
- Se elimina el constructor por defecto en Patpass Comercio
- Se elimina el constructor por defecto en Full Transaction y Mall Full Transaction
- Se elimina el código que hace referencia al producto ‘Webpay Modal’
- Se elimina el código que hace referencia al producto ‘Patpass by webpay’

## [4.0.0] - 2024-03-20

### Changed

- Downgrade del API de la versión 1.3 a la versión 1.2

### Fixed

- Corregido un error en RequestService que causaba problemas debido a la dependencia de `.blank?`, que no es parte de la biblioteca estándar de Ruby

## [3.0.2] - 2023-03-7

### Fixed

- Se corrige el manejo de errores del método delete en Oneclick Mall

## Added

- En caso de error se verifica si el response tiene body y en caso de no tenerlo se retorna el status

## [3.0.0] - 2022-09-19

### Fixed

- Se soluciona el método 'has_text_with_max_length' para que valide los atributos nulos

### Changed

- Se migra el API desde la versión 1.2 a la versión 1.3

### Added

- Se agrega los métodos 'increaseAmount', 'increaseAuthorizationDate', 'reversePreAuthorizedAmount', 'deferredCaptureHistory' a las versiones diferidas de WebpayPlus, WebpayPlus Mall, Oneclick Mall, Transaccion Completa y Transaccion Completa Mall

## [2.0.1] - 2022-06-14

### Fixed

- Se soluciona error en método refund para transacciones Webpay Plus Mall. Muchas gracias por tu aporte @danirod

## [2.0.0] - 2022-01-03

### Removed

- Se elimina Onepay

### Changed

- Se agrega soporte a Webpay Modal
- Se migra el api desde la versión 1.0 a la versión 1.2
- Ahora el método de retorno al crear la transacción en WebPayPlus debe tener soporte GET (cuando es exitosa) y POST (cuando se retorna sin concluir el ingreso de la tarjeta)
- Ahora el método de retorno al inscribirse en Oneclick debe tener soporte GET (cuando es exitosa) y POST (cuando se retorna sin concluir la inscripción)
- Se refactoriza y migra todos los productos desde clases estáticas a clases instanciables
- Se unifica 'Transaction' y 'DeferredTransaction' en WebpayPlus
- Se unifica 'MallTransaction' y 'MallDeferredTransaction' en WebpayPlus y Oneclick

### Added

- Se agrega soporte a Webpay Modal
- Se agregan validaciones de obligatoriedad y tamaño de los parámetros a los métodos de WebpayPlus, Oneclick, Webpay Modal, Transacción Completa
- Se agrega un módulo de constantes con los códigos de comercio de integración: 'IntegrationCommerceCodes'
- Se agrega un módulo de constantes con las claves de comercio de integración: 'IntegrationApiKeys'

## [1.5.1] - 2021-04-12

### Added

- Se agrega captura diferida en Transacción Completa y Transacción Completa Mall

## [1.4.1] - 2021-03-30

### Fixed

- Se agrega parámetro de estado faltante en respuesta de Commit y Status en Webpay Plus
- Se agrega dependencia JSON (~> 2.0) para evitar problemas al recibir respuesta de Commit
- Se arregla endpoint de captura en Webpay Plus

## [1.4.0] - 2020-12-03

### Added

- Se agregan métodos de configuración para integración a Webpay Plus en sus modalidades diferidas y mall diferida.
- Se agregan métodos de configuración para integración a Webpay Oneclick en su modalidad mall diferida.

### Fixed

- Se arregla forma en que se lee configuración del SDK, estaba tomando valores de una constante en vez de la variable de clase correspondiente. Este arreglo es para todos los productos con la excepción de Onepay

## [1.3.1] - 2020-10-29

### Fixed

- Se revierte commit que elimina requires necesarios para productos REST

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
