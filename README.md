# VoucherScanner

## Descripción
VoucherScanner es una aplicación iOS escrita en SwiftUI que permite escanear, mediante la cámara del iPhone, vouchers impresos o en pantalla. Utiliza `Vision` (`VNRecognizeTextRequest`) para reconocer texto en tiempo real y detectar códigos de 16 dígitos que cumplan con un formato válido.

## Nuevas Funcionalidades
La aplicación ahora inicia con una pantalla de selección (`SelectorView`) que ofrece dos opciones:
1. **Show React Native view**: Abre una vista desarrollada en React Native (Expo).
2. **Show UIKit view**: Abre la vista nativa original con el escáner OCR.

## Integración con Expo (React Native)
El proyecto ha añadido soporte para Expo a través de CocoaPods. El código de React Native se encuentra en la carpeta `ocr-expo`.

## Configuración y Ejecución

### 1. Preparar el entorno de Expo
Antes de ejecutar la app iOS, debes iniciar el servidor de desarrollo de Metro:

1. Abre una terminal y navega a la carpeta `ocr-expo`:
   ```bash
   cd ocr-expo
   ```
2. Instala las dependencias (solo la primera vez):
   ```bash
   npm install
   ```
3. Inicia el servidor de desarrollo:
   ```bash
   npm start
   ```
   Esto ejecutará `expo start --dev-client`. Mantén esta terminal abierta.

### 2. Ejecutar la App iOS
1. El proyecto se distribuye como un `.xcodeproj`.
2. Asegúrate de haber instalado los pods si es necesario (aunque el proyecto ya debería tenerlos configurados, si faltan, ejecuta `pod install` en la carpeta raíz o `ios`).
3. Abre el proyecto en Xcode (`File ▸ Open...`) y selecciona `VoucherScanner.xcodeproj`.
4. La configuración de build está externalizada en `Configurations/Debug.xcconfig` y `Configurations/Release.xcconfig`. Ajusta ahí:
   - `PRODUCT_BUNDLE_IDENTIFIER` con tu dominio inverso.
   - `DEVELOPMENT_TEAM` con tu Team ID de Apple Developer.
5. Selecciona tu dispositivo físico como destino.
6. Ejecuta la app (`Cmd + R`).

## Requisitos y permisos
- Requiere iOS 15+ (según lo definido en los `.xcconfig`).
- Permiso de cámara (`NSCameraUsageDescription` descrito en `Info.plist`).

## Uso de la aplicación (Vista Nativa)
1. Selecciona "show UIKit view" en la pantalla de inicio.
2. Apunta la cámara al voucher.
3. El texto reconocido se mostrará en pantalla.

## Formatos reconocidos
La detección acepta los siguientes patrones de 16 dígitos:
- `XXXX-XXXX-XXXX-XXXX` (con guiones cada cuatro números).
- `XXXX XXXX XXXX XXXX` (con espacios).
- `XXXXXXXXXXXXXXXX` (16 dígitos seguidos).

Independientemente del formato original, la app normaliza y presenta el voucher como `XXXX-XXXX-XXXX-XXXX`.

