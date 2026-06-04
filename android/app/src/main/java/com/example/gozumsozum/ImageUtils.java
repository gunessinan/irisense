package com.example.irisense;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.renderscript.Allocation;
import android.renderscript.Element;
import android.renderscript.RenderScript;
import android.renderscript.ScriptIntrinsicBlur;

import java.util.List;
import com.google.mediapipe.tasks.components.containers.NormalizedLandmark;

public class ImageUtils {
    static final int TARGET_WIDTH  = 400;
    static final int TARGET_HEIGHT = 100;

    public static Bitmap prepareSystemImageForDetection(Bitmap src, Context context) {
        Bitmap gray = toGrayscale(src, false);

        Bitmap contrast = increaseBlackContrast(gray);

        return applyGaussianBlur(context, contrast, 1.5f);
    }

    public static Bitmap generateUserImage(Bitmap original, List<NormalizedLandmark> landmarks) {
        Bitmap cropped = cropEyeRegion(original, landmarks);
        return toGrayscale(cropped, true);
    }

    // -- Crop Eyes Region of Interest ---
    public static Bitmap cropEyeRegion(
        Bitmap original,
        List<NormalizedLandmark> landmarks
    ) {
        if (original == null || original.isRecycled()) {
            return createEmptyBitmap();
        }

        int imgW = original.getWidth();
        int imgH = original.getHeight();

        int leftOuterIdx  = 263;
        int rightOuterIdx = 33;
        int leftTopIdx    = 386;
        int rightBottomIdx= 145;

        float xLeft  = landmarks.get(leftOuterIdx).x() * imgW;
        float xRight = landmarks.get(rightOuterIdx).x() * imgW;
        float yTop   = landmarks.get(leftTopIdx).y() * imgH;
        float yBot   = landmarks.get(rightBottomIdx).y() * imgH;

        float centerX = (xLeft + xRight) / 2f;
        float centerY = (yTop + yBot) / 2f;

        float eyeDistance = Math.abs(xRight - xLeft);
        float ZOOM_FACTOR = 1.5f;

        float cropWidth = eyeDistance * ZOOM_FACTOR;
        float targetRatio = (float) TARGET_WIDTH / TARGET_HEIGHT;
        float cropHeight = cropWidth / targetRatio;

        float left   = Math.max(0, centerX - cropWidth / 2f);
        float top    = Math.max(0, centerY - cropHeight / 2f);
        float right  = Math.min(imgW, centerX + cropWidth / 2f);
        float bottom = Math.min(imgH, centerY + cropHeight / 2f);

        int w = (int) (right - left);
        int h = (int) (bottom - top);

        if (w <= 0 || h <= 0) {
            return createEmptyBitmap();
        }

        Bitmap cropped = Bitmap.createBitmap(
                original,
                (int) left,
                (int) top,
                w,
                h
        );

        return Bitmap.createScaledBitmap(
                cropped,
                TARGET_WIDTH,
                TARGET_HEIGHT,
                true
        );
    }

    // -- To Gray Scale ---
    public static Bitmap toGrayscale(Bitmap src, boolean mirror) {
        Bitmap output = Bitmap.createBitmap(
                src.getWidth(),
                src.getHeight(),
                Bitmap.Config.ARGB_8888
        );

        Canvas canvas = new Canvas(output);

        // If mirror is true, perform mirroring
        if (mirror) {
            canvas.scale(-1, 1, src.getWidth() / 2f, src.getHeight() / 2f);
        }

        Paint paint = new Paint();
        ColorMatrix cm = new ColorMatrix();
        cm.setSaturation(0);

        paint.setColorFilter(new ColorMatrixColorFilter(cm));
        canvas.drawBitmap(src, 0, 0, paint);

        return output;
    }
    
    // -- Increase Black Contrast ---
    public static Bitmap increaseBlackContrast(Bitmap src) {
        Bitmap output = Bitmap.createBitmap(
                src.getWidth(),
                src.getHeight(),
                Bitmap.Config.ARGB_8888
        );

        Canvas canvas = new Canvas(output);
        Paint paint = new Paint();

        ColorMatrix contrastMatrix = new ColorMatrix(new float[]{
                1.4f, 0,    0,    0, -40,
                0,    1.4f, 0,    0, -40,
                0,    0,    1.4f, 0, -40,
                0,    0,    0,    1,  0
        });

        paint.setColorFilter(new ColorMatrixColorFilter(contrastMatrix));
        canvas.drawBitmap(src, 0, 0, paint);

        return output;
    }

    // --- Apply Blur ---
    public static Bitmap applyGaussianBlur(Context context, Bitmap src, float radius) {
        Bitmap output = Bitmap.createBitmap(src);

        RenderScript rs = null;
        Allocation input = null;
        Allocation outputAlloc = null;
        ScriptIntrinsicBlur blur = null;

        try {
            rs = RenderScript.create(context);
            input = Allocation.createFromBitmap(rs, src);
            outputAlloc = Allocation.createFromBitmap(rs, output);

            blur = ScriptIntrinsicBlur.create(rs, Element.U8_4(rs));
            blur.setRadius(Math.max(1f, Math.min(25f, radius)));
            blur.setInput(input);
            blur.forEach(outputAlloc);

            outputAlloc.copyTo(output);

        } finally {
            // Hata olsa bile kaynakları temizle
            if (input != null) input.destroy();
            if (outputAlloc != null) outputAlloc.destroy();
            if (blur != null) blur.destroy();
            if (rs != null) rs.destroy();
        }

        return output;
    }

    private static Bitmap createEmptyBitmap() {
        return Bitmap.createBitmap(TARGET_WIDTH, TARGET_HEIGHT, Bitmap.Config.ARGB_8888);
    }
}