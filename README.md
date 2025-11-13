# VoucherScanner

## Descripción
VoucherScanner es una aplicación iOS escrita en SwiftUI que permite escanear, mediante la cámara del iPhone, vouchers impresos o en pantalla. Utiliza `Vision` (`VNRecognizeTextRequest`) para reconocer texto en tiempo real y detectar códigos de 16 dígitos que cumplan con un formato válido. Cuando un voucher es reconocido, la app lo normaliza y lo muestra en un campo de texto para que el usuario lo valide o copie.

## Configuración del proyecto
- El proyecto se distribuye como un `.xcodeproj` 
- La configuración de build está externalizada en `Configurations/Debug.xcconfig` y `Configurations/Release.xcconfig`. Ajusta ahí:
  - `PRODUCT_BUNDLE_IDENTIFIER` con tu dominio inverso.
  - `DEVELOPMENT_TEAM` con tu Team ID de Apple Developer.
  - Opcionalmente, otros flags o el `IPHONEOS_DEPLOYMENT_TARGET`.
- Abre el proyecto en Xcode (`File ▸ Open...`) y selecciona `VoucherScanner.xcodeproj`.
- Selecciona tu dispositivo físico como destino (se recomienda dispositivo real; el OCR de cámara necesita hardware).

## Requisitos y permisos
- Requiere iOS 15+ (según lo definido en los `.xcconfig`).
- Permiso de cámara (`NSCameraUsageDescription` descrito en `Info.plist`). El sistema solicitará acceso la primera vez que intentes usar la app; debes aceptarlo para que el escaneo funcione.

## Uso de la aplicación
1. Al abrir la app, se inicia la vista en vivo de la cámara trasera.
2. Apunta la cámara al voucher que quieras leer. Mantén el texto centrado y con buena iluminación.
3. Cuando el OCR detecte un código válido, el texto se mostrará en el cuadro inferior y vibrará con feedback háptico.
4. Revisa el número detectado; puedes copiarlo o pulsar “Limpiar” para volver a escanear.

## Formatos reconocidos
La detección acepta los siguientes patrones de 16 dígitos:
- `XXXX-XXXX-XXXX-XXXX` (con guiones cada cuatro números).
- `XXXX XXXX XXXX XXXX` (con espacios).
- `XXXXXXXXXXXXXXXX` (16 dígitos seguidos).

Independientemente del formato original, la app normaliza y presenta el voucher como `XXXX-XXXX-XXXX-XXXX`.

