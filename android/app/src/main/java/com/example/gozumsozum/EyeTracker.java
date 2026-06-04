package com.example.irisense;

import android.graphics.PointF;
import java.util.ArrayList;
import java.util.List;

public class EyeTracker {
    // MediaPipe Indexes
    public static final int[] LEFT_IRIS = {474, 475, 476, 477};
    public static final int[] LEFT_EYE = {
            362, 382, 381, 380,
            374, 373, 390, 249,
            263, 466, 388, 387,
            386, 385, 41, 359
    };
    public static final int[] RIGHT_IRIS = {469, 470, 471, 472};
    public static final int[] RIGHT_EYE = {
            33, 7, 163, 144,
            145, 159, 160, 161,
            246, 173, 157, 158,
            153, 154, 155, 133
    };

    // Calibration Limits
    private float calXMin = 0.45f;
    private float calXMax = 0.55f;
    private float calYMin = 0.45f;
    private float calYMax = 0.55f;

    // Stabilization
    private final int historyLength = 5;
    private final List<PointF> gazeHistory = new ArrayList<>();

    // Calibration Status
    public boolean calibrationActive = false;
    public int calibrationStep = 0;
    private static final float BLINK_THRESHOLD = 0.25f;

    // Gaze Info
    public float normalX = 0.00f;
    public float normalY = 0.00f;

    public PointF getIrisPosition(List<PointF> landmarks, int width, int height) {
        // Iris Center
        float irisSumX = 0, irisSumY = 0;
        for (int idx : LEFT_IRIS) {
            irisSumX += landmarks.get(idx).x * width;
            irisSumY += landmarks.get(idx).y * height;
        }
        float irisCenterX = irisSumX / LEFT_IRIS.length;
        float irisCenterY = irisSumY / LEFT_IRIS.length;

        // Eye Borders (Min/Max)
        float xMin = Float.MAX_VALUE, yMin = Float.MAX_VALUE;
        float xMax = Float.MIN_VALUE, yMax = Float.MIN_VALUE;

        for (int idx : LEFT_EYE) {
            float px = landmarks.get(idx).x * width;
            float py = landmarks.get(idx).y * height;
            if (px < xMin) xMin = px;
            if (px > xMax) xMax = px;
            if (py < yMin) yMin = py;
            if (py > yMax) yMax = py;
        }

        float eyeWidth = xMax - xMin;
        float eyeHeight = yMax - yMin;

        if (eyeWidth == 0 || eyeHeight == 0) return new PointF(0.5f, 0.5f);

        float relX = (irisCenterX - xMin) / eyeWidth;
        float relY = (irisCenterY - yMin) / eyeHeight;

        return new PointF(relX, relY);
    }

    public PointF getSmoothedGaze(float relX, float relY) {
        gazeHistory.add(new PointF(relX, relY));
        if (gazeHistory.size() > historyLength) {
            gazeHistory.remove(0);
        }

        float sumX = 0, sumY = 0;
        for (PointF p : gazeHistory) {
            sumX += p.x;
            sumY += p.y;
        }

        return new PointF(sumX / gazeHistory.size(), sumY / gazeHistory.size());
    }

    public void updateCalibration(float ratioX, float ratioY) {
        if (calibrationStep == 2)
        {
            calibrationStep = 0;
            calibrationActive = false;
            return;
        }

        if (ratioX < calXMin) calXMin = ratioX;
        if (ratioX > calXMax) calXMax = ratioX;
        if (ratioY < calYMin) calYMin = ratioY;
        if (ratioY > calYMax) calYMax = ratioY;
        calibrationStep = calibrationStep + 1;
    }

    public boolean isEyeClosed(List<PointF> landmarks, boolean isLeft) {
        if (landmarks == null || landmarks.isEmpty()) return false;

        int top, bottom, inner, outer;

        if (isLeft) { // Left Eye
            top = 386; bottom = 374; inner = 362; outer = 263;
        } else { // Right Eye
            top = 159; bottom = 145; inner = 33; outer = 133;
        }

        // Vertical Distance
        float distVertical = (float) Math.hypot(
                landmarks.get(top).x - landmarks.get(bottom).x,
                landmarks.get(top).y - landmarks.get(bottom).y
        );

        // Horizontal Distance
        float distHorizontal = (float) Math.hypot(
                landmarks.get(inner).x - landmarks.get(outer).x,
                landmarks.get(inner).y - landmarks.get(outer).y
        );

        if (distHorizontal == 0) return false;

        float ratio = distVertical / distHorizontal;

        return ratio < BLINK_THRESHOLD;
    }

    public void resetCalibration() {
        calXMin = 1.0f; calXMax = 0.0f;
        calYMin = 1.0f; calYMax = 0.0f;
        calibrationActive = true;
        calibrationStep = 0;
        gazeHistory.clear();
    }

    public void processGaze(float smoothX, float smoothY) {
        float rangeX = (calXMax - calXMin) > 0.001f ? (calXMax - calXMin) : 0.001f;
        float rangeY = (calYMax - calYMin) > 0.001f ? (calYMax - calYMin) : 0.001f;

        float normX = (smoothX - calXMin) / rangeX;
        float normY = (smoothY - calYMin) / rangeY;

        // Invert
        normX = 1.0f - normX;
        normY = 1.0f - normY;

        // Clip
        normX = Math.max(0, Math.min(1, normX));
        normY = Math.max(0, Math.min(1, normY));

        normalX = normX;
        normalY = normY;
    }
}