import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: CameraViewModel
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Voucher detectado")
                        .font(.headline)
                        .foregroundColor(.white)

                    TextField("XXXX-XXXX-XXXX-XXXX", text: $viewModel.detectedVoucher)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .keyboardType(.asciiCapableNumberPad)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .focused($isTextFieldFocused)

                    Button {
                        viewModel.resetDetection()
                        isTextFieldFocused = false
                    } label: {
                        Text("Limpiar")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(16)
                .padding()
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CameraViewModel())
}

