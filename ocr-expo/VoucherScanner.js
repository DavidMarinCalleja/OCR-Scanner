import React from 'react';
import { requireNativeViewManager } from 'expo-modules-core';

const VoucherScannerView = requireNativeViewManager('VoucherScannerViewModule');

export default function VoucherScannerViewModule(props) {
    return <VoucherScannerView{...props} />;
}
