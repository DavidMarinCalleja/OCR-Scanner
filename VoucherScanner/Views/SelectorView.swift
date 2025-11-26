import SwiftUI

struct SelectorView: View {
    @StateObject private var cameraViewModel = CameraViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: ReactNativeView()) {
                    Text("show React Native view")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                NavigationLink(destination: ContentView().environmentObject(cameraViewModel)) {
                    Text("show UIKit view")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Select View")
        }
    }
}

#Preview {
    SelectorView()
}
