import Flutter
import UIKit
import AVFoundation
import MediaPipeTasksVision

@main
@objc class AppDelegate: FlutterAppDelegate {

    private let CHANNEL_METHOD = "com.irisense/method"
    private let CHANNEL_EVENT = "com.irisense/event"

    private var faceLandmarker: FaceLandmarker?
    private let eyeTracker = EyeTracker()
    private var eventSink: FlutterEventSink?

    private var screenWidth: Int = 1080
    private var screenHeight: Int = 1920

    private var smoothIris = CGPoint(x: 0.5, y: 0.5)

    // Camera
    private var captureSession: AVCaptureSession?
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated)

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }

        setupChannels(controller: controller)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func setupChannels(controller: FlutterViewController) {
        // 1. Method Channel
        let methodChannel = FlutterMethodChannel(name: CHANNEL_METHOD, binaryMessenger: controller.binaryMessenger)
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }

            switch call.method {
            case "resetCalibration":
                self.eyeTracker.resetCalibration()
                result("Calibration Reset")

            case "saveCalibration":
                self.eyeTracker.updateCalibration(ratioX: Float(self.smoothIris.x), ratioY: Float(self.smoothIris.y))
                result("Calibration Saved: \(self.smoothIris.x), \(self.smoothIris.y)")

            case "setScreenSize":
                if let args = call.arguments as? [String: Any],
                   let width = args["width"] as? Int,
                   let height = args["height"] as? Int {
                    self.screenWidth = width
                    self.screenHeight = height
                    result("Size Set")
                } else {
                    result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        // 2. Event Channel
        let eventChannel = FlutterEventChannel(name: CHANNEL_EVENT, binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)
    }

    private func setupFaceLandmarker() {
        guard let modelPath = Bundle.main.path(forResource: "face_landmarker", ofType: "task") else {
            print("❌ Face Landmarker model not found!")
            return
        }

        let baseOptions = BaseOptions()
        baseOptions.modelAssetPath = modelPath
        
        let options = FaceLandmarkerOptions()
        options.runningMode = .liveStream
        options.baseOptions = baseOptions
        options.numFaces = 1
        options.minFaceDetectionConfidence = 0.5
        options.minFacePresenceConfidence = 0.5
        options.faceLandmarkerLiveStreamDelegate = self

        do {
            faceLandmarker = try FaceLandmarker(options: options)
            print("✅ Face Landmarker initialized")
        } catch {
            print("❌ Face Landmarker error: \(error.localizedDescription)")
        }
    }

    private func startCamera() {
        // Kamera izin kontrolü
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.setupCamera()
                }
            }
        default:
            print("❌ Camera permission denied")
        }
    }

    private func setupCamera() {
        setupFaceLandmarker()

        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .hd1280x720

        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              let session = captureSession,
              session.canAddInput(videoInput) else {
            print("❌ Cannot setup camera input")
            return
        }

        session.addInput(videoInput)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }

        if let connection = videoOutput.connection(with: .video) {
            connection.videoOrientation = .portrait
            // Ön kamera için ayna efekti
            if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
            print("✅ Camera started")
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension AppDelegate: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let timestampMs = Int(CMTimeGetSeconds(timestamp) * 1000)

        // MediaPipe için MPImage oluştur
        let mpImage = try? MPImage(sampleBuffer: sampleBuffer)

        guard let image = mpImage, let landmarker = faceLandmarker else { return }

        // Async olarak işle
        try? landmarker.detectAsync(image: image, timestampInMilliseconds: timestampMs)
    }
}

// MARK: - FaceLandmarkerLiveStreamDelegate
extension AppDelegate: FaceLandmarkerLiveStreamDelegate {
    func faceLandmarker(_ faceLandmarker: FaceLandmarker, didFinishDetection result: FaceLandmarkerResult?, timestampInMilliseconds: Int, error: Error?) {

        if let error = error {
            print("❌ MediaPipe Error: \(error.localizedDescription)")
            return
        }

        guard let result = result,
              let faceLandmarks = result.faceLandmarks.first else {
            return
        }

        // Normalized landmark'ları CGPoint array'e çevir
        let landmarks: [CGPoint] = faceLandmarks.map { landmark in
            return CGPoint(x: CGFloat(landmark.x), y: CGFloat(landmark.y))
        }

        // İris pozisyonu
        let rawIris = eyeTracker.getIrisPosition(landmarks: landmarks, width: 1, height: 1)
        smoothIris = eyeTracker.getSmoothedGaze(relX: Float(rawIris.x), relY: Float(rawIris.y))

        if eyeTracker.calibrationActive {
            // Kalibrasyon modu - Flutter tarafında tetiklenecek
        } else {
            // Takip modu
            eyeTracker.processGaze(smoothX: Float(smoothIris.x), smoothY: Float(smoothIris.y), screenW: screenWidth, screenH: screenHeight)

            let selectedZone = eyeTracker.checkDwellTime()

            // Flutter'a gönderilecek veri
            var data: [String: Any] = [
                "x": eyeTracker.screenX,
                "y": eyeTracker.screenY
            ]

            if let zone = selectedZone {
                data["gazeType"] = zone
            }

            // UI Thread'de Flutter'a gönder
            DispatchQueue.main.async { [weak self] in
                self?.eventSink?(data)
            }
        }
    }
}

// MARK: - FlutterStreamHandler
extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        startCamera()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        captureSession?.stopRunning()
        return nil
    }
}
