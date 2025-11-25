import UIKit
import AVFoundation
import Vision

@objc(VoucherScannerView)
class VoucherScannerView: UIView {

    @objc var onVoucherDetected: RCTDirectEventBlock?

    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let textRecognitionRequest = VNRecognizeTextRequest()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
        setupVision()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer?.frame = bounds
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            print("Error: Unable to access back camera")
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)

        self.videoPreviewLayer = previewLayer
        self.captureSession = session

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }

    private func setupVision() {
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
    }

    private func process(image: CVPixelBuffer) {
        let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .right, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
            guard let observations = textRecognitionRequest.results else { return }
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                let text = topCandidate.string
                
                if let voucher = extractVoucher(from: text) {
                    DispatchQueue.main.async {
                        self.onVoucherDetected?(["voucher": voucher])
                    }
                }
            }
        } catch {
            print("Vision error: \(error)")
        }
    }

    private func extractVoucher(from text: String) -> String? {
        // Regex patterns
        let patterns = [
            "^\\d{16}$", // Continuous
            "^\\d{4} \\d{4} \\d{4} \\d{4}$", // Space separated
            "^\\d{4}-\\d{4}-\\d{4}-\\d{4}$"  // Hyphen separated
        ]

        for pattern in patterns {
            if text.range(of: pattern, options: .regularExpression) != nil {
                return text
            }
        }
        return nil
    }
}

extension VoucherScannerView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        process(image: pixelBuffer)
    }
}
