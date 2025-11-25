import React from 'react';
import { requireNativeComponent } from 'react-native';

const NativeVoucherScanner = requireNativeComponent('VoucherScannerView');

const VoucherScanner = ({ onVoucherDetected, style }) => {
    const handleVoucherDetected = (event) => {
        if (onVoucherDetected) {
            onVoucherDetected(event.nativeEvent.voucher);
        }
    };

    return (
        <NativeVoucherScanner
            style={style}
            onVoucherDetected={handleVoucherDetected}
        />
    );
};

export default VoucherScanner;
