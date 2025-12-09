import ExpoModulesCore
import Vision

public class OcrNativeModule: Module {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('OcrNativeModule')` in JavaScript.
    Name("OcrNativeModule")

    // Defines event names that the module can send to JavaScript.
    Events("onChange")

    // Defines a JavaScript function that always returns a Promise and whose native code
    // is by default dispatched on the different thread than the JavaScript runtime runs on.
    AsyncFunction("setValueAsync") { (value: String) in
      // Send an event to JavaScript.
      self.sendEvent("onChange", [
        "value": value
      ])
    }

    // Función asíncrona para analizar imagen recibida como base64
    AsyncFunction("analyzeImage") { (base64Image: String, promise: Promise) in
      // Convertir base64 a Data
      guard let imageData = Data(base64Encoded: base64Image),
            let image = UIImage(data: imageData),
            let cgImage = image.cgImage else {
        promise.reject("INVALID_IMAGE", "No se pudo convertir la imagen base64")
        return
      }
      
      // Crear la solicitud de reconocimiento de texto
      let request = VNRecognizeTextRequest { (request, error) in
        if let error = error {
          promise.reject("OCR_ERROR", error.localizedDescription)
          return
        }
        
        // Extraer todas las cadenas de texto reconocidas
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
          promise.resolve([])
          return
        }
        
        // Obtener el texto de cada observación
        let recognizedStrings = observations.compactMap { observation in
          observation.topCandidates(1).first?.string
        }
        
        // Devolver el array de strings
        promise.resolve(recognizedStrings)
      }
      
      // Configurar el nivel de reconocimiento (accurate para mejor precisión)
      request.recognitionLevel = .accurate
      
      // Crear el handler y ejecutar la solicitud
      let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
      
      do {
        try handler.perform([request])
      } catch {
        promise.reject("OCR_ERROR", "Error al procesar la imagen: \(error.localizedDescription)")
      }
    }
  }
}
