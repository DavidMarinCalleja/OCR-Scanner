import SwiftUI

@main
struct VoucherScannerApp: App {
    @StateObject private var viewModel = CameraViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

