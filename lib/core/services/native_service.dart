import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
// Core
import 'package:irisense/core/utils/base64_utils.dart';

class NativeService extends ChangeNotifier {
  static const EventChannel _eventChannel = EventChannel('com.irisense/event');
  static const MethodChannel _methodChannel = MethodChannel('com.irisense/method');

  StreamSubscription? _streamSubscription;
  Stream<dynamic> get gazeStream => _eventChannel.receiveBroadcastStream();

  double normalX = 0.00;
  double normalY = 0.00;
  Uint8List? userImage;
  
  NativeService() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListening();
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _startListening() {
    _streamSubscription = gazeStream.listen(
      (data) {
        if (data == null) return;

        // Update coordinates
        if (data['x'] != null || data['y'] != null) {
          normalX = (data['x'] as double).toDouble();
          normalY = (data['y'] as double).toDouble();
        }
        debugPrint("DATA: $normalX - $normalY");

        // Decode Test Image if available
        if (data['userImage'] != null) {
          try {
            String base64String = data['userImage'] as String;
            Uint8List bytes = Base64Utils.decodeImage(base64String);
            userImage = bytes;
          } catch (e) {
            debugPrint("Base64 decode error: $e");
          }
        }
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Data stream error: $error");
      },
    );
  }

  // --- Native Methods ---
  Future<void> resetCalibration() async {
    try {
      await _methodChannel.invokeMethod('resetCalibration');
    } catch (e) {
      debugPrint("Error (Reset Calibration): $e");
    }
  }

  Future<void> saveCalibration() async {
    try {
      await _methodChannel.invokeMethod('saveCalibration');
    } catch (e) {
      debugPrint("Error (Save Calibration): $e");
    }
  }
}