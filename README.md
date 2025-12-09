# OCR Expo Native

Una aplicación móvil desarrollada con Expo y React Native que utiliza OCR (Reconocimiento Óptico de Caracteres) para extraer texto de imágenes capturadas con la cámara del dispositivo.

## 📋 Descripción

Esta aplicación permite a los usuarios:
- Acceder a la cámara del dispositivo en tiempo real
- Capturar imágenes y procesarlas mediante OCR
- Visualizar el texto reconocido en pantalla
- Limpiar los resultados con un botón de reset

La aplicación utiliza el framework **Vision** de iOS para realizar el reconocimiento de texto de forma nativa, proporcionando alta precisión y rendimiento.

## 🏗️ Arquitectura del Proyecto

```
OCR-expo-native/
├── app/
│   ├── App.js              # Componente principal de la aplicación
│   └── index.js            # Punto de entrada
├── modules/
│   └── ocr-native-module/  # Módulo nativo personalizado
│       ├── ios/
│       │   └── OcrNativeModule.swift  # Implementación OCR en Swift
│       ├── index.ts        # Exportación del módulo
│       ├── package.json
│       └── expo-module.config.json
├── assets/                 # Recursos (iconos, splash screen)
├── ios/                    # Proyecto iOS nativo
├── app.json               # Configuración de Expo
├── package.json           # Dependencias del proyecto
└── tsconfig.json          # Configuración de TypeScript
```

## 🚀 Tecnologías Utilizadas

- **Expo SDK 54** - Framework para desarrollo React Native
- **React Native 0.81.5** - Framework de desarrollo móvil
- **React 19.1.0** - Biblioteca de UI
- **expo-camera** - Acceso a la cámara del dispositivo
- **expo-dev-client** - Cliente de desarrollo personalizado
- **Vision Framework (iOS)** - OCR nativo de Apple
- **TypeScript** - Tipado estático

## 📦 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Node.js** (versión 18 o superior)
- **npm** o **yarn**
- **Xcode** (para desarrollo iOS) - versión 15 o superior
- **CocoaPods** - para gestión de dependencias iOS
- **Expo CLI** - se instalará automáticamente con las dependencias
- **Cuenta de Apple Developer** (para ejecutar en dispositivo físico iOS)

### Verificar instalaciones

```bash
node --version
npm --version
xcode-select --version
pod --version
```

## 🛠️ Instalación y Configuración

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd OCR-expo-native
```

### 2. Instalar dependencias

```bash
npm install
```

Esto instalará todas las dependencias necesarias, incluyendo el módulo nativo personalizado `ocr-native-module`.

### 3. Configurar iOS

#### a) Instalar pods de iOS

```bash
cd ios
pod install
cd ..
```

#### b) Configurar el equipo de desarrollo

Abre el proyecto en Xcode:

```bash
open ios/OCRexponative.xcworkspace
```

En Xcode:
1. Selecciona el proyecto en el navegador
2. Ve a **Signing & Capabilities**
3. Selecciona tu **Team** de Apple Developer
4. Verifica que el **Bundle Identifier** sea único: `com.anonymous.ocr-expo-native`

### 4. Configurar permisos de cámara

Los permisos ya están configurados en `app.json`, pero verifica que estén presentes:

```json
"ios": {
  "infoPlist": {
    "NSCameraUsageDescription": "Esta aplicación necesita acceso a la cámara para escanear documentos."
  }
}
```

## ▶️ Ejecutar la Aplicación

### Modo Desarrollo

#### Iniciar el servidor de desarrollo

```bash
npm start
```

#### Ejecutar en iOS

En una nueva terminal:

```bash
npm run ios
```

O especifica un dispositivo:

```bash
npx expo run:ios --device
```

### Compilación para Producción

Para crear una build de producción:

```bash
npx expo build:ios
```

## 🎯 Funcionalidades

### Interfaz de Usuario

La aplicación cuenta con una interfaz simple e intuitiva:

1. **Vista de Cámara** - Muestra el feed de la cámara trasera en tiempo real
2. **Caja de Texto (Superior)** - Muestra el texto reconocido por OCR
3. **Botón "Analizar imagen" (Centro-Inferior)** - Captura y procesa la imagen
4. **Botón "Reset" (Inferior)** - Limpia el texto reconocido

### Flujo de Trabajo

1. La aplicación solicita permisos de cámara al iniciar
2. El usuario apunta la cámara hacia el texto que desea escanear
3. Presiona el botón "Analizar imagen"
4. La aplicación captura la imagen y la envía al módulo nativo
5. El módulo OCR procesa la imagen usando Vision Framework
6. El texto reconocido se muestra en la caja de texto superior
7. El usuario puede limpiar el resultado con el botón "Reset"

## 🔧 Módulo Nativo OCR

### OcrNativeModule

El módulo nativo está implementado en Swift y expone las siguientes funciones:

#### `analyzeImage(base64Image: string): Promise<string[]>`
Función asíncrona que procesa una imagen en formato base64 y retorna un array de strings con el texto reconocido.

```javascript
import { analyzeImage } from '../modules/ocr-native-module';

const textArray = await analyzeImage(base64Image);
// Ejemplo: ["Línea 1", "Línea 2", "Línea 3"]
```

### Características del OCR

- **Reconocimiento preciso**: Utiliza `VNRecognizeTextRequest` con nivel `accurate`
- **Múltiples líneas**: Detecta y separa diferentes líneas de texto
- **Manejo de errores**: Gestión robusta de errores en la conversión y procesamiento
- **Asíncrono**: No bloquea el hilo principal de la aplicación

## 📱 Configuración del Proyecto

### app.json

Configuración principal de Expo:

```json
{
  "expo": {
    "name": "OCR-expo-native",
    "slug": "OCR-expo-native",
    "version": "1.0.0",
    "orientation": "portrait",
    "newArchEnabled": true,
    "ios": {
      "bundleIdentifier": "com.anonymous.ocr-expo-native",
      "appleTeamId": "MUNF9A7YWQ"
    }
  }
}
```

### package.json

Scripts disponibles:

- `npm start` - Inicia el servidor de desarrollo Expo
- `npm run ios` - Ejecuta la app en iOS
- `npm run android` - Ejecuta la app en Android (requiere configuración adicional)
- `npm run web` - Ejecuta la app en navegador web

## 🐛 Solución de Problemas

### Error: "No script URL provided"

**Solución**: Asegúrate de que el servidor Metro esté ejecutándose:
```bash
npm start
```

### Error: "Module not found: ocr-native-module"

**Solución**: Reinstala las dependencias:
```bash
rm -rf node_modules
npm install
cd ios && pod install && cd ..
```

### Error de permisos de cámara

**Solución**: 
1. Verifica que `NSCameraUsageDescription` esté en `app.json`
2. Desinstala y reinstala la app en el dispositivo
3. Ve a Configuración > Privacidad > Cámara y verifica los permisos

### Error al compilar en Xcode

**Solución**:
1. Limpia el build: `Product > Clean Build Folder` (Shift + Cmd + K)
2. Reinstala pods: `cd ios && pod deintegrate && pod install && cd ..`
3. Verifica que el Team esté configurado correctamente

### La cámara no se muestra

**Solución**:
1. Verifica que estés ejecutando en un dispositivo físico (el simulador no tiene cámara)
2. Comprueba que los permisos estén concedidos
3. Reinicia la aplicación

## 📝 Notas Importantes

- **Solo iOS**: Actualmente, el módulo OCR solo está implementado para iOS usando Vision Framework
- **Dispositivo físico requerido**: La funcionalidad de cámara requiere un dispositivo iOS real
- **Permisos**: La app solicitará permisos de cámara en el primer uso
- **Rendimiento**: El OCR se ejecuta de forma asíncrona para no bloquear la UI
- **Calidad de imagen**: Para mejores resultados, asegúrate de tener buena iluminación y texto claro

---

**Desarrollado con ❤️ usando Expo y React Native**
