import { requireNativeModule } from 'expo-modules-core';

// It loads the native module object from the JSI or falls back to
// the bridge module (from NativeModulesProxy) if the remote debugger is on.
const OcrNativeModule = requireNativeModule('OcrNativeModule');

export function analyzeImage(base64Image: string) {
    return OcrNativeModule.analyzeImage(base64Image);
}

export { OcrNativeModule };
