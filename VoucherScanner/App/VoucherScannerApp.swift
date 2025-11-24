import SwiftUI

@main
struct VoucherScannerApp: App {
    var body: some Scene {
        WindowGroup {
            ReactNativeView()
                .ignoresSafeArea() // Optional: React Native usually handles safe areas itself or needs full screen
        }
    }
}

