import AVFoundation
import Combine
import UIKit
import Vision

final class CameraViewModel: NSObject, ObservableObject {
    @Published var detectedVoucher: String = ""

    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "CameraSessionQueue")
    private var isSessionConfigured = false
    private var requests: [VNRequest] = []

    override init() {
        super.init()
        configureVisionRequest()
    }

    func startSession() {
        sessionQueue.async {
            guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.startSession()
                    }
                }
                return
            }

            if !self.isSessionConfigured {
                self.configureSession()
            }

            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func resetDetection() {
        DispatchQueue.main.async {
            self.detectedVoucher = ""
        }
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            session.commitConfiguration()
            return
        }

        session.addInput(input)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraOutputQueue"))

        guard session.canAddOutput(videoOutput) else {
            session.commitConfiguration()
            return
        }

        session.addOutput(videoOutput)

        if let connection = videoOutput.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }

        session.commitConfiguration()
        isSessionConfigured = true
    }

    private func configureVisionRequest() {
        let textRequest = VNRecognizeTextRequest { [weak self] request, error in
            guard error == nil else { return }
            self?.handleTextRecognition(request: request)
        }
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = false
        requests = [textRequest]
    }

    private func handleTextRecognition(request: VNRequest) {
        guard detectedVoucher.isEmpty,
              let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }

        for observation in results {
            guard let candidate = observation.topCandidates(1).first else { continue }
            if let voucher = Self.extractVoucher(from: candidate.string) {
                DispatchQueue.main.async {
                    if self.detectedVoucher.isEmpty {
                        self.detectedVoucher = voucher
                        self.provideHapticFeedback()
                    }
                }
                break
            }
        }
    }

    private func provideHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    private static func extractVoucher(from text: String) -> String? {
        let patterns = [
            #"^\d{4}-\d{4}-\d{4}-\d{4}$"#,
            #"^\d{4}\s\d{4}\s\d{4}\s\d{4}$"#,
            #"^\d{16}$"#
        ]

        for pattern in patterns {
            if let range = text.range(of: pattern, options: .regularExpression) {
                let matched = String(text[range])
                return normalizeVoucher(matched)
            }
        }
        return nil
    }

    private static func normalizeVoucher(_ voucher: String) -> String {
        let digits = voucher.filter(\.isNumber)
        guard digits.count == 16 else { return voucher }

        var groups: [String] = []
        stride(from: 0, to: 16, by: 4).forEach {
            let start = digits.index(digits.startIndex, offsetBy: $0)
            let end = digits.index(start, offsetBy: 4)
            groups.append(String(digits[start..<end]))
        }

        return groups.joined(separator: "-")
    }
}

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard detectedVoucher.isEmpty,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        var requestOptions: [VNImageOption: AnyObject] = [:]
        if let cameraData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions[.cameraIntrinsics] = cameraData
        }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: requestOptions)

        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print("Vision error: \(error.localizedDescription)")
        }
    }
}

