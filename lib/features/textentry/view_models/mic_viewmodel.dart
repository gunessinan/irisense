import 'package:flutter/foundation.dart';
import 'package:irisense/core/services/sound_service.dart';

class MicViewModel extends ChangeNotifier {
  final SoundService soundService;
  bool isRecording = false;

  MicViewModel({required this.soundService});

  Future<void> startListening({required Function(String) onResult}) async {
    if (isRecording || soundService.isListening) {
      await stopListening();
      return;
    }

    isRecording = true;
    notifyListeners();

    try {
      await soundService.listenToSpeech(onResult: (text) {
        onResult(text);
        debugPrint("MicModel detected: $text");
      });
    } catch (e) {
      debugPrint("MicModel error: $e");
      await stopListening();
    }
  }

  Future<void> stopListening() async {
    if (!isRecording) return;
    await soundService.stopListening();
    isRecording = false;
    notifyListeners();
  }
}