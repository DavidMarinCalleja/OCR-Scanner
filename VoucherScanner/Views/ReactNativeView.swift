import SwiftUI
import UIKit

struct ReactNativeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ReactNativeViewController {
        return ReactNativeViewController()
    }

    func updateUIViewController(_ uiViewController: ReactNativeViewController, context: Context) {
        // No updates needed for now
    }
}
