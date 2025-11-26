import ExpoModulesCore

public class VoucherScannerModule: Module {
  public func definition() -> ModuleDefinition {
    Name("VoucherScannerViewModule")

    View(VoucherScannerView.self) {
    }
  }
}
