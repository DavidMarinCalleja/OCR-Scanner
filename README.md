# OCR-Scanner Projects

Este repositorio contiene dos proyectos principales diseñados para demostrar la integración de React Native en aplicaciones nativas (Brownfield) utilizando Rock.

## Descripción de los Directorios

### `react-native-brownfield-medium`
Este directorio contiene un proyecto **React Native** creado con el framework **Rock**.
*   **Objetivo**: Su propósito es empaquetar y exportar su funcionalidad como un **XCFramework**.
*   Esto permite que el código de React Native sea consumido como una biblioteca binaria nativa.

### `example-react-native-brownfield-medium`
Este es un proyecto de ejemplo nativo escrito en **Swift**.
*   **Objetivo**: Importar los ficheros **XCFramework** generados por el proyecto anterior.
*   **Funcionalidad**: Muestra la vista de React Native integrada dentro de la aplicación Swift, sirviendo como demostración de la integración exitosa.
