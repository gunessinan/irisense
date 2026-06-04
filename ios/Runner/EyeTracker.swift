import Foundation
import CoreGraphics

class EyeTracker {
    // MediaPipe Indexleri
    static let LEFT_IRIS: [Int] = [474, 475, 476, 477]
    static let LEFT_EYE: [Int] = [362, 382, 381, 380, 374, 373, 390, 249, 263, 466, 388, 387, 386, 385, 41, 359]

    // Kalibrasyon Sınırları
    private var calXMin: Float = 0.45
    private var calXMax: Float = 0.55
    private var calYMin: Float = 0.45
    private var calYMax: Float = 0.55

    // Stabilizasyon
    private let historyLength: Int = 5
    private var gazeHistory: [CGPoint] = []

    // Kalibrasyon Durumu
    var calibrationActive: Bool = false
    var calibrationStep: Int = 0

    // Dwell Time Logic
    private var lastRegion: String? = nil
    private var dwellStartTime: Int64 = 0
    private static let DWELL_THRESHOLD_MS: Int64 = 1400
    private var actionTriggered: Bool = false

    // Son hesaplanan değerler
    var screenX: Int = 0
    var screenY: Int = 0
    var currentZone: String = ""

    func getIrisPosition(landmarks: [CGPoint], width: Int, height: Int) -> CGPoint {
        // Iris Merkezi
        var irisSumX: Float = 0
        var irisSumY: Float = 0

        for idx in EyeTracker.LEFT_IRIS {
            irisSumX += Float(landmarks[idx].x) * Float(width)
            irisSumY += Float(landmarks[idx].y) * Float(height)
        }

        let irisCenterX = irisSumX / Float(EyeTracker.LEFT_IRIS.count)
        let irisCenterY = irisSumY / Float(EyeTracker.LEFT_IRIS.count)

        // Göz Sınırları (Min/Max)
        var xMin: Float = Float.greatestFiniteMagnitude
        var yMin: Float = Float.greatestFiniteMagnitude
        var xMax: Float = -Float.greatestFiniteMagnitude
        var yMax: Float = -Float.greatestFiniteMagnitude

        for idx in EyeTracker.LEFT_EYE {
            let px = Float(landmarks[idx].x) * Float(width)
            let py = Float(landmarks[idx].y) * Float(height)
            if px < xMin { xMin = px }
            if px > xMax { xMax = px }
            if py < yMin { yMin = py }
            if py > yMax { yMax = py }
        }

        let eyeWidth = xMax - xMin
        let eyeHeight = yMax - yMin

        if eyeWidth == 0 || eyeHeight == 0 {
            return CGPoint(x: 0.5, y: 0.5)
        }

        let relX = (irisCenterX - xMin) / eyeWidth
        let relY = (irisCenterY - yMin) / eyeHeight

        return CGPoint(x: CGFloat(relX), y: CGFloat(relY))
    }

    func getSmoothedGaze(relX: Float, relY: Float) -> CGPoint {
        gazeHistory.append(CGPoint(x: CGFloat(relX), y: CGFloat(relY)))
        if gazeHistory.count > historyLength {
            gazeHistory.removeFirst()
        }

        var sumX: CGFloat = 0
        var sumY: CGFloat = 0
        for p in gazeHistory {
            sumX += p.x
            sumY += p.y
        }

        return CGPoint(x: sumX / CGFloat(gazeHistory.count), y: sumY / CGFloat(gazeHistory.count))
    }

    func updateCalibration(ratioX: Float, ratioY: Float) {
        if calibrationStep == 2 {
            calibrationStep = 0
            calibrationActive = false
            return
        }

        if ratioX < calXMin { calXMin = ratioX }
        if ratioX > calXMax { calXMax = ratioX }
        if ratioY < calYMin { calYMin = ratioY }
        if ratioY > calYMax { calYMax = ratioY }
        calibrationStep += 1
    }

    func resetCalibration() {
        calXMin = 1.0
        calXMax = 0.0
        calYMin = 1.0
        calYMax = 0.0
        calibrationActive = true
        calibrationStep = 0
        gazeHistory.removeAll()
    }

    func processGaze(smoothX: Float, smoothY: Float, screenW: Int, screenH: Int) {
        let rangeX = (calXMax - calXMin) > 0.001 ? (calXMax - calXMin) : 0.001
        let rangeY = (calYMax - calYMin) > 0.001 ? (calYMax - calYMin) : 0.001

        var normX = (smoothX - calXMin) / rangeX
        var normY = (smoothY - calYMin) / rangeY

        // Dikey invert
        normY = 1.0 - normY
        normX = 1.0 - normX

        // Clip
        normX = max(0, min(1, normX))
        normY = max(0, min(1, normY))

        self.screenX = Int(normX * Float(screenW))
        self.screenY = Int(normY * Float(screenH))

        determineZone(normX: normX, normY: normY, w: screenW, h: screenH)
    }

    private func determineZone(normX: Float, normY: Float, w: Int, h: Int) {
        var colIdx = 1
        if normX < 0.33 { colIdx = 0 }
        else if normX > 0.66 { colIdx = 2 }

        var regionName = ""

        if colIdx == 0 || colIdx == 2 {
            let prefix = (colIdx == 0) ? "Left" : "Right"
            if normY < 0.5 {
                regionName = "\(prefix) Up"
            } else {
                regionName = prefix
            }
        } else {
            // Center Column
            if normY < 0.33 { regionName = "Up" }
            else if normY > 0.66 { regionName = "Down" }
            else { regionName = "Straight" }
        }

        self.currentZone = regionName
    }

    // Dwell Time Kontrolü
    func checkDwellTime() -> String? {
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000)

        if currentZone == lastRegion {
            let elapsed = currentTime - dwellStartTime
            if elapsed >= EyeTracker.DWELL_THRESHOLD_MS && !actionTriggered {
                actionTriggered = true
                return currentZone
            }
        } else {
            lastRegion = currentZone
            dwellStartTime = currentTime
            actionTriggered = false
        }
        return nil
    }
}
