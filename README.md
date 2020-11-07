# MarvelSearch

Projecto de candidatura para a Excibit Solutions

## Software version

- Xcode 12.0.1
- Swift 5.3

## Consideraciones

- Podríamos tener todos los http incluso en el enum HttpMethod, pero no son necesarios para el proyecto
- Podríamos tener una classe de configuración de la request, contenedo url y encabezados estándar
- Podríamos tener más atributos en el Endpoint, como BodyParameters, tipo de codificación, etc., además de tener los parámetros Encodable, para facilitar la conversión de la respuesta
- Podríamos crear un protocolo para que el SessionManager lo implemente y, con eso, podríamos usar un Session Manager diferente (Alamofire, por ejemplo)
- Podríamos dividir la clase de servicio de red en 2 partes: una clase para manejar solo la parte de red y la otra la parte de datos
- Podríamos crear un protocolo para ser implementado por la clase CharacterCell, para que esté más desacoplado cuando se use en clases de animación.
- Podríamos agregar reconizadores de gestos para cerrar la pantalla de detalles

## Cuestiones no resueltas
- Está duplicando la primera página cuando regresa de la búsqueda. No pude averiguar por qué
