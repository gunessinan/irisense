package com.example.irisense;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.util.Log;
import android.util.Size;
import androidx.annotation.NonNull;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.LifecycleOwner;
import java.util.concurrent.ExecutorService;

public class CameraManager {
    private final Activity activity;
    private final LifecycleOwner lifecycleOwner;
    private final ExecutorService executorService;
    private final ImageAnalysis.Analyzer analyzer;

    public CameraManager(Activity activity, LifecycleOwner lifecycleOwner, ExecutorService executorService, ImageAnalysis.Analyzer analyzer) {
        this.activity = activity;
        this.lifecycleOwner = lifecycleOwner;
        this.executorService = executorService;
        this.analyzer = analyzer;
    }

    public void startCamera() {
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.CAMERA}, 101);
            return;
        }

        ProcessCameraProvider.getInstance(activity).addListener(() -> {
            try {
                ProcessCameraProvider cameraProvider = ProcessCameraProvider.getInstance(activity).get();
                int rotation = activity.getWindowManager().getDefaultDisplay().getRotation();

                ImageAnalysis imageAnalysis = new ImageAnalysis.Builder()
                        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                        .setTargetResolution(new Size(1280, 720))
                        .setTargetRotation(rotation)
                        .build();

                imageAnalysis.setAnalyzer(executorService, analyzer);

                CameraSelector cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA;
                cameraProvider.unbindAll();
                cameraProvider.bindToLifecycle(lifecycleOwner, cameraSelector, imageAnalysis);

            } catch (Exception e) {
                Log.e("Gaze", "Camera Fail: " + e.getMessage());
            }
        }, ContextCompat.getMainExecutor(activity));
    }
}