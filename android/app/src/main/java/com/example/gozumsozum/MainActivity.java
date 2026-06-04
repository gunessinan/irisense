package com.example.irisense;

import android.graphics.Bitmap;
import android.graphics.PointF;
import android.util.Base64;
import androidx.annotation.NonNull;
import androidx.camera.core.ImageProxy;

import com.google.mediapipe.framework.image.BitmapImageBuilder;
import com.google.mediapipe.framework.image.MPImage;
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarkerResult;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements FlutterBridge.BridgeListener, FaceLandmarkerManager.ResultListener {

    private ExecutorService backgroundExecutor;
    private EyeTracker eyeTracker;

    // Managers
    private FlutterBridge flutterBridge;
    private FaceLandmarkerManager faceLandmarkerManager;
    private CameraManager cameraManager;
    private PointF smoothIris = new PointF(0.5f, 0.5f);
    private Bitmap currentFrameForCrop = null;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        backgroundExecutor = Executors.newSingleThreadExecutor();
        eyeTracker = new EyeTracker();

        // Start Flutter Bridge
        flutterBridge = new FlutterBridge(flutterEngine, this);

        // Start MediaPipe Manager
        faceLandmarkerManager = new FaceLandmarkerManager(this, this);

        // Start Camera Manager
        cameraManager = new CameraManager(this, this, backgroundExecutor, this::analyzeImage);
    }

    // --- FlutterBridge.BridgeListener Implementation ---
    @Override
    public void onResetCalibration() {
        eyeTracker.resetCalibration();
    }

    @Override
    public void onSaveCalibration(MethodChannel.Result result) {
        if (smoothIris != null) {
            eyeTracker.updateCalibration(smoothIris.x, smoothIris.y);
            result.success("Calibration Saved: " + smoothIris.x + ", " + smoothIris.y);
        } else {
            result.error("NO_DATA", "Iris data not available yet", null);
        }
    }

    @Override
    public void onStartCameraRequest() {
        cameraManager.startCamera();
    }
    // --- FlutterBridge.BridgeListener Implementation ---

    // <--- Runs on every frame --->
    private void analyzeImage(@NonNull ImageProxy imageProxy) {
        Bitmap originalBitmap = imageProxy.toBitmap();
        currentFrameForCrop = originalBitmap;
        Bitmap systemImage = ImageUtils.prepareSystemImageForDetection(originalBitmap, this);

        MPImage mpImage = new BitmapImageBuilder(systemImage).build();
        long timestampMs = imageProxy.getImageInfo().getTimestamp();

        faceLandmarkerManager.detectAsync(mpImage, timestampMs);
        imageProxy.close();
    }

    // --- FaceLandmarkerManager.ResultListener Implementation ---
    public void onLandmarkResult(FaceLandmarkerResult result, MPImage inputImage) {
        if (result.faceLandmarks().isEmpty() || currentFrameForCrop == null) return;

        List<com.google.mediapipe.tasks.components.containers.NormalizedLandmark> landmarks = result.faceLandmarks().get(0);

        Bitmap userImageBitmap = ImageUtils.generateUserImage(currentFrameForCrop, landmarks);
        String userImageEncoded = bitmapToBase64(userImageBitmap);
        Map<String, Object> data = new HashMap<>();
        
        data.put("userImage", userImageEncoded);

        List<PointF> convertedLandmarks = new ArrayList<>();
        for(com.google.mediapipe.tasks.components.containers.NormalizedLandmark lm : landmarks) {
            convertedLandmarks.add(new PointF(lm.x(), lm.y()));
        }

        boolean isEyeClosed = eyeTracker.isEyeClosed(convertedLandmarks, true) && eyeTracker.isEyeClosed(convertedLandmarks, false);

        if (isEyeClosed)
        {
            data.put("x", -1.0);
            data.put("y", -1.0);
        }
        else {
            PointF rawIris = eyeTracker.getIrisPosition(convertedLandmarks, 1, 1);
            smoothIris = eyeTracker.getSmoothedGaze(rawIris.x, rawIris.y);
            eyeTracker.processGaze(smoothIris.x, smoothIris.y);
            if (!eyeTracker.calibrationActive) { 
                
                data.put("x", eyeTracker.normalX);
                data.put("y", eyeTracker.normalY);
            }
        }

        // Send to Flutter
        runOnUiThread(() -> flutterBridge.sendEvent(data));
    }

    private String bitmapToBase64(Bitmap bitmap) {
        if (bitmap == null) return "";
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);
        byte[] byteArray = baos.toByteArray();
        return Base64.encodeToString(byteArray, Base64.NO_WRAP);
    }
}