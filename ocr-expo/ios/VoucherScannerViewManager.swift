import Foundation

@objc(VoucherScannerViewManager)
class VoucherScannerViewManager: RCTViewManager {

  override func view() -> UIView! {
    return VoucherScannerView()
  }

  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
