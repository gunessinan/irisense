package com.example.irisense;

import android.content.Context;
import android.util.Log;
import com.google.mediapipe.framework.image.MPImage;
import com.google.mediapipe.tasks.core.BaseOptions;
import com.google.mediapipe.tasks.vision.core.RunningMode;
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarker;
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarkerResult;

public class FaceLandmarkerManager {
    private FaceLandmarker faceLandmarker;
    private final Context context;
    private final ResultListener resultListener;

    public interface ResultListener {
        void onLandmarkResult(FaceLandmarkerResult result, MPImage inputImage);
    }

    public FaceLandmarkerManager(Context context, ResultListener resultListener) {
        this.context = context;
        this.resultListener = resultListener;
        setupFaceLandmarker();
    }

    private void setupFaceLandmarker() {
        BaseOptions.Builder baseOptionsBuilder = BaseOptions.builder()
                .setModelAssetPath("face_landmarker.task");

        FaceLandmarker.FaceLandmarkerOptions options =
                FaceLandmarker.FaceLandmarkerOptions.builder()
                        .setBaseOptions(baseOptionsBuilder.build())
                        .setMinFaceDetectionConfidence(0.5f)
                        .setMinFacePresenceConfidence(0.5f)
                        .setNumFaces(1)
                        .setRunningMode(RunningMode.LIVE_STREAM)
                        .setResultListener(resultListener::onLandmarkResult)
                        .setErrorListener(e -> Log.e("Gaze", "MP Error: " + e.getMessage()))
                        .build();

        faceLandmarker = FaceLandmarker.createFromOptions(context, options);
    }

    public void detectAsync(MPImage mpImage, long timestampMs) {
        if (faceLandmarker != null) {
            faceLandmarker.detectAsync(mpImage, timestampMs);
        }
    }
}