import { StatusBar } from 'expo-status-bar';
import React, { useState } from 'react';
import { StyleSheet, Text, View, TextInput } from 'react-native';
import VoucherScanner from './VoucherScanner';

export default function App() {
  const [voucher, setVoucher] = useState('');

  const handleVoucherDetected = (detectedVoucher) => {
    setVoucher(detectedVoucher);
  };

  return (
    <View style={styles.container}>
      <View style={styles.cameraContainer}>
        <VoucherScanner
          style={styles.camera}
          onVoucherDetected={handleVoucherDetected}
        />
      </View>
      <View style={styles.inputContainer}>
        <Text style={styles.label}>Voucher capturado:</Text>
        <TextInput
          style={styles.input}
          value={voucher}
          editable={false}
          placeholder="Esperando voucher..."
        />
      </View>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  cameraContainer: {
    flex: 1,
    backgroundColor: '#000',
  },
  camera: {
    flex: 1,
  },
  inputContainer: {
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  label: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 12,
    fontSize: 18,
    backgroundColor: '#fff',
    fontFamily: 'monospace',
  },
});
