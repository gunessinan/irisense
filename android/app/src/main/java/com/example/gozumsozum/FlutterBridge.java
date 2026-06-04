package com.example.irisense;

import java.util.Map;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class FlutterBridge {
    private static final String CHANNEL_METHOD = "com.irisense/method";
    private static final String CHANNEL_EVENT = "com.irisense/event";

    private EventChannel.EventSink eventSink;
    private final BridgeListener listener;

    public interface BridgeListener {
        void onResetCalibration();
        void onSaveCalibration(MethodChannel.Result result);
        void onStartCameraRequest();
    }

    public FlutterBridge(FlutterEngine flutterEngine, BridgeListener listener) {
        this.listener = listener;
        setupMethodChannel(flutterEngine);
        setupEventChannel(flutterEngine);
    }

    private void setupMethodChannel(FlutterEngine flutterEngine) {
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_METHOD)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("resetCalibration")) {
                        listener.onResetCalibration();
                        result.success("Calibration Reset");
                    } else if (call.method.equals("saveCalibration")) {
                        listener.onSaveCalibration(result);
                        result.success("Calibration Saved");
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private void setupEventChannel(FlutterEngine flutterEngine) {
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_EVENT)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSink = events;
                        listener.onStartCameraRequest();
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        eventSink = null;
                    }
                });
    }

    public void sendEvent(Map<String, Object> data) {
        if (eventSink != null) {
            eventSink.success(data);
        }
    }
}