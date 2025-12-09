import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, TextInput, TouchableOpacity, ActivityIndicator } from 'react-native';
import { CameraView, useCameraPermissions } from 'expo-camera';
import { useState, useEffect, useRef } from 'react';
import { analyzeImage } from '../modules/ocr-native-module';

export default function App() {
  const [permission, requestPermission] = useCameraPermissions();
  const [recognizedText, setRecognizedText] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const cameraRef = useRef(null);

  const handleAnalyzeImage = async () => {
    if (cameraRef.current && !isLoading) {
      setIsLoading(true);
      try {
        // Capturar el frame actual de la cámara
        const photo = await cameraRef.current.takePictureAsync({
          quality: 1,
          base64: true,
        });

        // Enviar la imagen al módulo nativo y esperar el resultado
        if (photo.base64) {
          const textStrings = await analyzeImage(photo.base64);
          // Unir todas las cadenas de texto con saltos de línea
          const allText = textStrings.join('\n');
          setRecognizedText(allText);
        }
      } catch (error) {
        console.error('Error al capturar o analizar imagen:', error);
        setRecognizedText('Error al analizar la imagen');
      } finally {
        setIsLoading(false);
      }
    }
  };

  const handleReset = () => {
    setRecognizedText('');
  };

  if (!permission) {
    // Cargando permisos de la cámara
    return <View style={styles.container} />;
  }

  if (!permission.granted) {
    // No tenemos permiso, mostrar mensaje y solicitar permiso
    return (
      <View style={styles.container}>
        <Text style={styles.message}>Necesitamos permiso para usar la cámara</Text>
        <Text style={styles.button} onPress={requestPermission}>
          Conceder permiso
        </Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <CameraView ref={cameraRef} style={styles.camera} facing="back" />
      <TextInput
        style={styles.textInput}
        value={recognizedText}
        placeholder="El texto reconocido aparecerá aquí..."
        placeholderTextColor="#999"
        multiline
        editable={false}
      />
      <TouchableOpacity
        style={[styles.analyzeButton, isLoading && styles.buttonDisabled]}
        onPress={handleAnalyzeImage}
        disabled={isLoading}
      >
        {isLoading ? (
          <ActivityIndicator color="#fff" size="small" />
        ) : (
          <Text style={styles.analyzeButtonText}>Analizar imagen</Text>
        )}
      </TouchableOpacity>
      <TouchableOpacity
        style={[styles.resetButton, isLoading && styles.buttonDisabled]}
        onPress={handleReset}
        disabled={isLoading}
      >
        <Text style={styles.resetButtonText}>Reset</Text>
      </TouchableOpacity>
      <StatusBar style="light" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  camera: {
    flex: 1,
  },
  textInput: {
    position: 'absolute',
    top: 60,
    left: 20,
    right: 20,
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 15,
    fontSize: 16,
    maxHeight: 150,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  message: {
    textAlign: 'center',
    paddingBottom: 10,
    color: '#fff',
  },
  button: {
    color: '#fff',
    textAlign: 'center',
    padding: 10,
    backgroundColor: '#007AFF',
    margin: 20,
    borderRadius: 5,
  },
  analyzeButton: {
    position: 'absolute',
    bottom: 100,
    left: 20,
    right: 20,
    backgroundColor: '#007AFF',
    borderRadius: 10,
    padding: 15,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  analyzeButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  resetButton: {
    position: 'absolute',
    bottom: 20,
    left: 20,
    right: 20,
    backgroundColor: '#FF3B30',
    borderRadius: 10,
    padding: 15,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  resetButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  buttonDisabled: {
    opacity: 0.5,
  },
});
